package Model.DA;

import Model.Domain.*;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public class DAOrder {
    private String host = "jdbc:derby://localhost:1527/fnfdb";
    private String user = "nbuser";
    private String password = "nbuser";

    private PreparedStatement stmt;
    private Connection connection;

    public DAOrder() {
        createConnection();
    }

    //Get total order record count in order to create order id
    public int getOrderCount() throws SQLException {
        stmt = connection.prepareStatement("SELECT COUNT(ORDERID) FROM ORDERS");
        ResultSet rs = stmt.executeQuery();
        //if rs.next return number of count record else return 0
        return rs.next() ? rs.getInt(1) : 0;
    }

    //Insert new order record
    public Order insertOrderRecord(Order order) throws SQLException {
        stmt = connection.prepareStatement("INSERT INTO ORDERS VALUES (?,?,?,?,?)");
        stmt.setString(1, order.getOrderId());
        stmt.setString(2, order.getOrderStatus());
        stmt.setTimestamp(3, order.getOrderCreatedTime());
        stmt.setString(4, order.getOrderRemark());
        stmt.setString(5, order.getAddress().getAddressID());
        stmt.executeUpdate();
        return order;
    }

    //Get order record based on the order id
    public Order getOrderRecord(String orderId) throws SQLException {
        Order order = null;
        stmt = connection.prepareStatement("SELECT * FROM ORDERS WHERE ORDERID = ?");
        stmt.setString(1, orderId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            order = new Order(rs.getString(1), rs.getString(2), rs.getTimestamp(3), rs.getString(4), new Address(rs.getString(5)));
            return order;
        }
        return null;
    }

    //======================== ADMIN PART =======================================
    //Admin - Search order records based on the order id/product name
    public ArrayList<Map<String,ArrayList<Cart>>> searchOrdersAdmin(String inputValue, String sortBy, String dateFrom, String dateTo,String orderStatus) throws SQLException {
        //input value - admin search value
        //Sort by -latest , oldest
        //dateFrom to dateTo is the within date range
        ArrayList<Map<String,ArrayList<Cart>>> orders = new ArrayList<>();
        sortBy = sortBy.equals("latest") ? " DESC" : " ASC";
        orders = searchByKeywordsAdmin(inputValue, sortBy, dateFrom, dateTo,orderStatus);
        return orders;
    }

    //Search orders based on the order id /product name
    public ArrayList<Map<String,ArrayList<Cart>>> searchByKeywordsAdmin(String inputValue, String sortBy, String dateFrom, String dateTo,String orderStatus) throws SQLException {
        String searchByKeywordsSQL = "SELECT C.CARTITEMID,S.SKUNO,O.ORDERID,C.QTY FROM ORDERS AS O " +
                "INNER JOIN CART AS C ON O.ORDERID=C.ORDERID  " +
                "INNER JOIN SKU AS S ON S.SKUNO=C.SKUNO  " +
                "INNER JOIN PRODUCT AS P ON P.PRODID=S.PRODID " +
                "WHERE O.ORDERSTATUS='"+orderStatus+"' AND ";
        if ((dateTo == null && dateFrom != null) || (dateTo != null && dateFrom != null)) {
            //if dateTo is null set the date to today's date
            dateTo = LocalDate.now().toString();
            //Use SQL 'like' and 'or' to search for the matched record;
            searchByKeywordsSQL += "(DATE(O.ORDERCREATEDTIME) BETWEEN '" + dateFrom + "' AND " + "'" + dateTo + "') AND " +
                    "(O.ORDERID LIKE '%" + inputValue + "%' OR P.PRODNAME LIKE '%" + inputValue + "%' ) ORDER BY O.ORDERCREATEDTIME " + sortBy;
            return stmtConnGetOrders(searchByKeywordsSQL);
        }
        else if (dateFrom == null && dateTo != null) {
            //1. Get all the relevant records
            searchByKeywordsSQL += "(DATE(O.ORDERCREATEDTIME) < " + "'" + dateTo + "') AND " + "(O.ORDERID LIKE '%" + inputValue + "%' OR P.PRODNAME LIKE '%" + inputValue + "%' ) ORDER BY O.ORDERCREATEDTIME " + sortBy;
            ArrayList<Map<String,ArrayList<Cart>>> orderDetails = stmtConnGetOrders(searchByKeywordsSQL);
            //2. Filter the date compare to the dateTo
            ArrayList<Cart> orderCartsBeforeDateTo = new ArrayList<Cart>();
            for (int i = 0; i < orderDetails.size(); i++) {
                //Check the keyset(OrderID) compare with the retrieve orderID
                for(String orderID:orderDetails.get(i).keySet()){
                    ArrayList<Cart> sameCart = orderDetails.get(i).get(orderID);
                    for (Cart cart : sameCart) {
                        //Compare date inside cart
                        if (cart.getOrder().getOrderCreatedTime().toLocalDateTime().toLocalDate().compareTo(LocalDate.parse(dateTo)) < 0) {
                            orderCartsBeforeDateTo.add(cart);
                            orderDetails.get(i).put(orderID,orderCartsBeforeDateTo);
                        }
                    }
                }
            }
            return orderDetails;
        }
        else if (dateTo == null && dateFrom == null) {
            searchByKeywordsSQL += "(O.ORDERID LIKE '%" + inputValue + "%' OR P.PRODNAME LIKE '%" + inputValue + "%' ) ORDER BY O.ORDERCREATEDTIME " + sortBy;
            return stmtConnGetOrders(searchByKeywordsSQL);
        }
        return null;
    }

    //Used to retrieve all the order records (reset button)
    public ArrayList<Map<String,ArrayList<Cart>>> resetSearchAdmin() throws SQLException {
        String searchByKeywordsSQL = "SELECT C.CARTITEMID,S.SKUNO,O.ORDERID,C.QTY FROM ORDERS AS O " +
                "INNER JOIN CART AS C ON O.ORDERID=C.ORDERID  " +
                "INNER JOIN SKU AS S ON S.SKUNO=C.SKUNO  " +
                "INNER JOIN PRODUCT AS P ON P.PRODID=S.PRODID " +
                "ORDER BY O.ORDERCREATEDTIME DESC";
        return stmtConnGetOrders(searchByKeywordsSQL);
    }

    //Admin UpdateStatus page - Used to retrieve all the order records based on the order status selected
    public ArrayList<Map<String,ArrayList<Cart>>> searchStatus(String orderStatus) throws SQLException {
        String searchByKeywordsSQL = "SELECT C.CARTITEMID,S.SKUNO,O.ORDERID,C.QTY FROM ORDERS AS O " +
                "INNER JOIN CART AS C ON O.ORDERID=C.ORDERID  " +
                "INNER JOIN SKU AS S ON S.SKUNO=C.SKUNO  " +
                "INNER JOIN PRODUCT AS P ON P.PRODID=S.PRODID " +
                "WHERE O.ORDERSTATUS ='"+orderStatus+"' "+
                "ORDER BY O.ORDERCREATEDTIME DESC";
        return stmtConnGetOrders(searchByKeywordsSQL);
    }

    //Admin UpdateStatus page - Used to retrieve all the order records based on the order status & order ID selected
    public ArrayList<Map<String,ArrayList<Cart>>> searchIDStatus(String orderID,String orderStatus) throws SQLException {
        String searchByKeywordsSQL = "SELECT C.CARTITEMID,S.SKUNO,O.ORDERID,C.QTY FROM ORDERS AS O " +
                "INNER JOIN CART AS C ON O.ORDERID=C.ORDERID  " +
                "INNER JOIN SKU AS S ON S.SKUNO=C.SKUNO  " +
                "INNER JOIN PRODUCT AS P ON P.PRODID=S.PRODID " +
                "WHERE O.ORDERSTATUS ='"+orderStatus+"' AND O.ORDERID LIKE '%"+orderID+"%' "+
                "ORDER BY O.ORDERCREATEDTIME DESC";
        return stmtConnGetOrders(searchByKeywordsSQL);
    }

    //Used for retrieve order records from the database based on admin input value
    //Use Map , orderID as key , cart as value
    //Because one orderID might have different carts so use this map way to store items
    //After that store as an array returns back to servlet
    private ArrayList<Map<String,ArrayList<Cart>>> stmtConnGetOrders(String sql) throws SQLException {
        stmt = connection.prepareStatement(sql);
        System.out.println(sql.toString());
        DASKU daSKU = new DASKU();
        DAAddress daAddress = new DAAddress();
        DAProduct daProduct = new DAProduct();
        DACart daCart=new DACart();
        ArrayList<Map<String, ArrayList<Cart>>> orderDetails = new ArrayList<>();
        ResultSet rs = stmt.executeQuery();
        //Check from the map if the orderId(keySet) is duplicate or not
        //Retrieve order id from map
        //If duplicate means the cart is under same order
        while (rs.next()) {
            //Maps not empty
            if (orderDetails.isEmpty()) {
                ArrayList<Cart> carts = new ArrayList<>();
                Order order = getOrderRecord(rs.getString(3));
                Customer customer = daAddress.displaySpecificAddress(order.getAddress().getAddressID()).getCustomer();
                SKU sku = daSKU.getSKU(rs.getString(2));
                sku.setProduct(daProduct.getRecord(sku.getProduct().getProdID()));
                Cart cart = new Cart(rs.getString(1),rs.getInt(4), order, sku, customer);
                carts.add(cart);
                //Store records into map
                Map<String, ArrayList<Cart>> maps = new HashMap<>();
                maps.put(rs.getString(3), carts);
                orderDetails.add(maps);
            }
            else {
                boolean checkForID=false;
                //Looping through the maps
                for (int i = 0; i < orderDetails.size(); i++) {
                    //Check the keyset(OrderID) compare with the retrieve orderID
                    if (orderDetails.get(i).containsKey(rs.getString(3))) { //If key exists inside the map
                        //Retrieve Cart based on the map keySet
                        ArrayList<Cart> sameCart = orderDetails.get(i).get(rs.getString(3));
                        Order order = getOrderRecord(rs.getString(3));
                        Customer customer = daAddress.displaySpecificAddress(order.getAddress().getAddressID()).getCustomer();
                        SKU sku = daSKU.getSKU(rs.getString(2));
                        sku.setProduct(daProduct.getRecord(sku.getProduct().getProdID()));
                        //Add the cart items into current cart array list
                        sameCart.add(new Cart(rs.getString(1),rs.getInt(4), order, sku, customer));
                        //Get current map from current array list and replace with the latest one
                        orderDetails.get(i).put(rs.getString(3), sameCart);
                        checkForID=true;
                    }
                }
                //If no key exist
                if(!checkForID) {
                    ArrayList<Cart> carts = new ArrayList<>();
                    Order order = getOrderRecord(rs.getString(3));
                    Customer customer = daAddress.displaySpecificAddress(order.getAddress().getAddressID()).getCustomer();
                    SKU sku = daSKU.getSKU(rs.getString(2));
                    sku.setProduct(daProduct.getRecord(sku.getProduct().getProdID()));
                    Cart cart = new Cart(rs.getString(1),rs.getInt(4),order, sku, customer);
                    carts.add(cart);
                    //Store records into map
                    Map<String, ArrayList<Cart>> maps = new HashMap<>();
                    maps.put(rs.getString(3), carts);
                    orderDetails.add(maps);
                }
            }
        }
        return orderDetails;
    }

    //Admin - Update order status
    public boolean updateOrderStatus(String orderStatus, String orderID) throws SQLException {
        stmt = connection.prepareStatement("UPDATE ORDERS SET ORDERSTATUS = ?  WHERE ORDERID= ?");
        stmt.setString(1, orderStatus);
        stmt.setString(2, orderID);
        if(orderStatus.equals("SHIPPING")){
            DATracking daTracking=new DATracking();
            daTracking.insertTrackingRecord(orderID);
        }
        boolean rowsUpdated = stmt.executeUpdate() > 0;
        return rowsUpdated;
    }


    //======================== CUSTOMER PART =======================================
    //Search by order id/product name/relevant keywords in all orders
    public ArrayList<Cart> searchOrders(int searchByField, String inputValue, String sortBy, String dateFrom, String dateTo, String custId) throws SQLException {
        //searchField- 1=Relevant keywords ,2=OrderId ,3=Product Name
        //input value - customer search value
        //Sort by -latest , oldest
        //dateFrom to dateTo is the within date range
        ArrayList<Cart> orderCarts = new ArrayList<>();
        sortBy = sortBy.equals("latest") ? " DESC" : " ASC";
        switch (searchByField) {
            //Search by relevant keywords - order id or product name
            case 1:
                orderCarts = searchByKeywords(inputValue, sortBy, dateFrom, dateTo, custId);
                break;
            //Search by order id
            case 2:
                orderCarts = searchByOrderId(inputValue, sortBy, dateFrom, dateTo, custId);
                break;
            //Search by product name
            case 3:
                orderCarts = searchProductName(inputValue, sortBy, dateFrom, dateTo, custId);
                break;
        }
        return orderCarts;
    }

    //Customer Search 1-Search by keywords(Either in order id/product name keywords)
    public ArrayList<Cart> searchByKeywords(String inputValue, String sortBy, String dateFrom, String dateTo, String custID) throws SQLException {
        String searchByKeywordsSQL = "SELECT O.*,C.QTY,S.SKUNO,S.COLOUR,S.PRODSIZE,S.PRODWIDTH,S.PRODLENGTH, " +
                "P.PRODNAME,P.PRODDESC,P.PRODPRICE,P.PRODCATEGORY,P.PRODIMAGE,C.CARTITEMID , " +
                "A.* FROM ORDERS AS O  " +
                "INNER JOIN CART AS C ON O.ORDERID=C.ORDERID " +
                "INNER JOIN SKU AS S ON S.SKUNO=C.SKUNO " +
                "INNER JOIN PRODUCT AS P ON P.PRODID=S.PRODID " +
                "INNER JOIN ADDRESS AS A ON O.ADDRESSID=A.ADDRESSID " +
                "WHERE C.CUSTOMERID = '" + custID + "' AND ";
        if ((dateTo == null && dateFrom != null) || (dateTo != null && dateFrom != null)) {
            //if dateTo is null set the date to today's date
            dateTo = LocalDate.now().toString();
            //Use SQL 'like' and 'or' to search for the matched record;
            searchByKeywordsSQL += "(DATE(O.ORDERCREATEDTIME) BETWEEN '" + dateFrom + "' AND " + "'" + dateTo + "') AND " +
                    "(O.ORDERID LIKE '%" + inputValue + "%' OR P.PRODNAME LIKE '%" + inputValue + "%' ) ORDER BY O.ORDERCREATEDTIME " + sortBy;
            return stmtConnGetOrdersCart(searchByKeywordsSQL);
        } else if (dateFrom == null && dateTo != null) {
            //1. Get all the relevant records
            searchByKeywordsSQL += "(DATE(O.ORDERCREATEDTIME) < " + "'" + dateTo + "') AND " +
                    "(O.ORDERID LIKE '%" + inputValue + "%' OR P.PRODNAME LIKE '%" + inputValue + "%' ) ORDER BY O.ORDERCREATEDTIME " + sortBy;
            ArrayList<Cart> ordersCart = stmtConnGetOrdersCart(searchByKeywordsSQL);

            //2. Filter the date compare to the dateTo
            ArrayList<Cart> orderCartsBeforeDateTo = new ArrayList<Cart>();
            for (Cart cart : ordersCart) {
                if (cart.getOrder().getOrderCreatedTime().toLocalDateTime().toLocalDate().compareTo(LocalDate.parse(dateTo)) < 0) {
                    orderCartsBeforeDateTo.add(cart);
                }
            }
            return orderCartsBeforeDateTo;
        } else if (dateTo == null && dateFrom == null) {
            searchByKeywordsSQL += "(O.ORDERID LIKE '%" + inputValue + "%' OR P.PRODNAME LIKE '%" + inputValue +
                    "%' ) ORDER BY O.ORDERCREATEDTIME " + sortBy;
            return stmtConnGetOrdersCart(searchByKeywordsSQL);
        }
        return null;
    }

    //Customer Search 2-Search by order ID
    private ArrayList<Cart> searchByOrderId(String orderId, String sortBy, String dateFrom, String dateTo, String custID) throws SQLException {
        String searchByOrderIDSQL = "SELECT O.*,C.QTY,S.SKUNO,S.COLOUR,S.PRODSIZE,S.PRODWIDTH,S.PRODLENGTH, " +
                "P.PRODNAME,P.PRODDESC,P.PRODPRICE,P.PRODCATEGORY,P.PRODIMAGE,C.CARTITEMID , " +
                "A.* FROM ORDERS AS O " +
                "INNER JOIN CART AS C ON O.ORDERID=C.ORDERID " +
                "INNER JOIN SKU AS S ON S.SKUNO=C.SKUNO " +
                "INNER JOIN PRODUCT AS P ON P.PRODID=S.PRODID " +
                "INNER JOIN ADDRESS AS A ON O.ADDRESSID=A.ADDRESSID " +
                "WHERE C.CUSTOMERID = '" + custID + "' AND ";
        if ((dateTo == null && dateFrom != null) || (dateTo != null && dateFrom != null)) {
            //if dateTo is null set the date to today's date
            if (dateTo == null) {
                dateTo = LocalDate.now().toString();
            }
            //Use SQL 'like' and  to search for the like order id record
            searchByOrderIDSQL += "  DATE(ORDERCREATEDTIME) BETWEEN " + "'" + dateFrom + "'" +
                    " AND " + "'" + dateTo + "' AND O.ORDERID LIKE " + "'%" + orderId + "%' " +
                    " ORDER BY  ORDERCREATEDTIME "+sortBy ;
            System.out.println(searchByOrderIDSQL);
            return stmtConnGetOrdersCart(searchByOrderIDSQL);
        } else if (dateFrom == null && dateTo != null) {
            //1. Get all the relevant records
            searchByOrderIDSQL += "(DATE(O.ORDERCREATEDTIME) < " + "'" + dateTo + "') AND " +
                    "(O.ORDERID LIKE '%" + orderId + "%' ORDER BY O.ORDERCREATEDTIME " + sortBy;
            ArrayList<Cart> ordersCart = stmtConnGetOrdersCart(searchByOrderIDSQL);

            //2. Filter the date compare to the dateTo
            ArrayList<Cart> orderCartsBeforeDateTo = new ArrayList<>();
            for (Cart cart : ordersCart) {
                if (cart.getOrder().getOrderCreatedTime().toLocalDateTime().toLocalDate().compareTo(LocalDate.parse(dateTo)) < 0) {
                    orderCartsBeforeDateTo.add(cart);
                }
            }
            return orderCartsBeforeDateTo;
        } else if (dateTo == null && dateFrom == null) {
            searchByOrderIDSQL += "O.ORDERID LIKE '%" + orderId + "%' ORDER BY O.ORDERCREATEDTIME " + sortBy;
            return stmtConnGetOrdersCart(searchByOrderIDSQL);
        }
        return null;
    }

    //Customer Search 3-Search by product name
    private ArrayList<Cart> searchProductName(String prodName, String sortBy, String dateFrom, String dateTo, String custID) throws SQLException {
        String searchByOrderIDSQL = "SELECT O.*,C.QTY,S.SKUNO,S.COLOUR,S.PRODSIZE,S.PRODWIDTH,S.PRODLENGTH, " +
                "P.PRODNAME,P.PRODDESC,P.PRODPRICE,P.PRODCATEGORY,P.PRODIMAGE, C.CARTITEMID ," +
                "A.* FROM ORDERS AS O " +
                "INNER JOIN CART AS C ON O.ORDERID=C.ORDERID " +
                "INNER JOIN SKU AS S ON S.SKUNO=C.SKUNO " +
                "INNER JOIN PRODUCT AS P ON P.PRODID=S.PRODID " +
                "INNER JOIN ADDRESS AS A ON O.ADDRESSID=A.ADDRESSID " +
                "WHERE C.CUSTOMERID = '" + custID + "' AND ";
        if ((dateTo == null && dateFrom != null) || (dateTo != null && dateFrom != null)) {
            //if dateTo is null set the date to today's date
            if (dateTo == null) {
                dateTo = LocalDate.now().toString();
            }
            //Use SQL 'like' and  to search for the like order id record
            searchByOrderIDSQL += "  DATE(ORDERCREATEDTIME) BETWEEN " + "'" + dateFrom + "'" +
                    " AND " + "'" + dateTo + "' AND P.PRODNAME LIKE " + "'%" + prodName + "%' " +
                    " ORDER BY ORDERCREATEDTIME " + sortBy;
            System.out.println(searchByOrderIDSQL);
            return stmtConnGetOrdersCart(searchByOrderIDSQL);
        } else if (dateFrom == null && dateTo != null) {
            //1. Get all the relevant records
            searchByOrderIDSQL += "(DATE(O.ORDERCREATEDTIME) < " + "'" + dateTo + "') AND " +
                    "(P.PRODNAME LIKE '%" + prodName + "%' ORDER BY O.ORDERCREATEDTIME " + sortBy;
            ArrayList<Cart> ordersCart = stmtConnGetOrdersCart(searchByOrderIDSQL);

            //2. Filter the date compare to the dateTo
            ArrayList<Cart> orderCartsBeforeDateTo = new ArrayList<>();
            for (Cart cart : ordersCart) {
                if (cart.getOrder().getOrderCreatedTime().toLocalDateTime().toLocalDate().compareTo(LocalDate.parse(dateTo)) < 0) {
                    orderCartsBeforeDateTo.add(cart);
                }
            }
            return orderCartsBeforeDateTo;
        } else if (dateTo == null && dateFrom == null) {
            searchByOrderIDSQL += "P.PRODNAME LIKE '%" + prodName + "%' ORDER BY O.ORDERCREATEDTIME " + sortBy;
            return stmtConnGetOrdersCart(searchByOrderIDSQL);
        }
        return null;
    }

    //Customer - retrieve cart records from database
    private ArrayList<Cart> stmtConnGetOrdersCart(String sql) throws SQLException {
        ArrayList<Cart> carts = new ArrayList<>();
        stmt = connection.prepareStatement(sql);
        System.out.println(sql.toString());
        ResultSet resultSet = stmt.executeQuery();
        while (resultSet.next()) {
            Order order;
            Cart cart;
            SKU sku;
            Product product;
            Address address;
            //String addressID, String fullName, String adrPhoneNum, String states, String area, String addressLine, String posCode
            address = new Address(resultSet.getString(18), resultSet.getString(19), resultSet.getString(20), resultSet.getString(21), resultSet.getString(22), resultSet.getString(23), resultSet.getString(24));
            //String orderId, String orderStatus, Timestamp orderCreatedTime, String orderRemark, String addressId
            order = new Order(resultSet.getString(1), resultSet.getString(2), resultSet.getTimestamp(3), resultSet.getString(4), address);
            //String prodName, String prodDesc, float prodPrice, String prodCategory, String prodImage
            product = new Product(resultSet.getString(12), resultSet.getString(13), resultSet.getFloat(14), resultSet.getString(15), resultSet.getString(16));
            //String skuNo,String colour,String prodSize,int prodWidth,int prodLength
            sku = new SKU(resultSet.getString(7), resultSet.getString(8), resultSet.getString(9), resultSet.getInt(10), resultSet.getInt(11), product);
            //qty in cart
            cart = new Cart(resultSet.getString(17),resultSet.getInt(6), sku, order);
            carts.add(cart);
        }
        return carts;
    }

    //======================== CALCULATION PRICE PART =======================================
    //Used in OrderHistory page
    //This method used to cal the cart id price = qty*product
    public Double totalCartPrice(String cartID) throws SQLException{
        String calSQL="SELECT SUM(C.QTY*P.PRODPRICE) AS TOTAL " +
                "FROM CART C " +
                "JOIN SKU S ON S.SKUNO=C.SKUNO " +
                "JOIN PRODUCT P ON P.PRODID=S.PRODID " +
                "WHERE C.CARTITEMID='"+cartID+"' "+
                "GROUP BY C.CARTITEMID";
        stmt=connection.prepareStatement(calSQL);

        ResultSet rs=stmt.executeQuery();
        while(rs.next()) {
            return Double.valueOf(String.format("%.2f",rs.getDouble(1)));
        }
        return 0.0;
    }

    //Used in OrderForm page when the user want to check out the system will cal the price
    //This method used to calculate the same order id under diff carts to calculate the price
    //eg. inside 1 order have 2 carts items , take product price*qty
    public Double totalOrder(String orderId) throws SQLException{
        //Find the carts with the same order id
        String calSQL="SELECT SUM(C.QTY*P.PRODPRICE) AS TOTAL " +
                "FROM CART C " +
                "JOIN SKU S ON S.SKUNO=C.SKUNO " +
                "JOIN PRODUCT P ON P.PRODID=S.PRODID " +
                "WHERE C.ORDERID='" +orderId+"' "+
                "GROUP BY C.CARTITEMID";
        stmt=connection.prepareStatement(calSQL);
        ResultSet rs=stmt.executeQuery();
        Double total=0.0;
        while(rs.next()){
            total+=rs.getDouble(1);
        }
        return Double.valueOf(String.format("%.2f",total));
    }

    public Map<String,Double> calculatePayment(ArrayList<Cart> carts) throws SQLException {
        //A map of cart id and total of each carts(qty*product price).
        //Each cart id(key) is associated with a list of price (value) which is the customer bought
        Map<String, Double> cartPrice = new LinkedHashMap<>();
        //Store cart as a key then store cartPrice
        String cartId ="";
        Double eachTotal=0.0;
        //Looping the carts and store into maps
        for (Cart cart : carts) {
            String calSQL = "SELECT C.CARTITEMID, SUM(C.QTY*P.PRODPRICE) AS TOTAL " +
                    "FROM CART C " +
                    "JOIN SKU S ON S.SKUNO=C.SKUNO " +
                    "JOIN PRODUCT P ON P.PRODID=S.PRODID " +
                    "WHERE C.CARTITEMID='" + cart.getCartItemID() + "' " +
                    "GROUP BY C.CARTITEMID";
            //Connect to database
            stmt = connection.prepareStatement(calSQL);
            ResultSet rs = stmt.executeQuery();
            //Retrieve cart id and price
            while (rs.next()) {
                cartId = rs.getString(1);
                eachTotal = rs.getDouble(2);
                cartPrice.put(cartId, Double.valueOf(String.format("%.2f",eachTotal)));
            }
        }
        return cartPrice;
    }

    private ArrayList<Order> stmtConnectionGetOrders(String sql) throws SQLException {
        ArrayList<Order> orders = new ArrayList<>();
        stmt = connection.prepareStatement(sql);
        System.out.println(sql.toString());
        ResultSet resultSet = stmt.executeQuery();
        while (resultSet.next()) {
            Order order = new Order();
            order.setOrderId(resultSet.getString(1));
            order.setOrderStatus(resultSet.getString(2));
            order.setOrderCreatedTime(resultSet.getTimestamp(3));
            order.setOrderRemark(resultSet.getString(4));
            order.setAddress(new Address(resultSet.getString(5)));
            orders.add(order);
        }
        return orders;
    }
    
    public ArrayList<Order> getOrderIDs() {
        try {
            ArrayList<Order> orders = new ArrayList<Order>();
            String sqlQueryStr = "SELECT * from ORDERS";

            stmt = connection.prepareStatement(sqlQueryStr);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getString(1));
                o.setOrderStatus(rs.getString(2));
                orders.add(o);
            }

            return orders;

        } catch (Exception e) {
            System.out.println("Query failed: " + e.getMessage());
            return null;
        }
    }

    public ArrayList<Order> getOrders() {
        try {
            return stmtConnectionGetOrders("SELECT * FROM ORDERS");
        } catch (Exception e) {
            System.out.println("Query failed: " + e.getMessage());
            return null;
        }
    }



    private void shutDown() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException ex) {
                System.out.println("Query failed: " + ex.getMessage());
            }
        }
    }

    private void createConnection() {
        try {
            connection = DriverManager.getConnection(host, user, password);
            System.out.println("***TRACE: Connection established.");
        } catch (SQLException e) {
            System.out.println("Query failed: " + e.getMessage());
        }
    }



}





