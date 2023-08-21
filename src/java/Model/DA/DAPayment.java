package Model.DA;


import Model.Domain.Cart;
import Model.Domain.Customer;
import Model.Domain.Order;
import Model.Domain.Payment;
import Model.Domain.Product;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;

public class DAPayment {

    private String host = "jdbc:derby://localhost:1527/fnfdb";
    private String user = "nbuser";
    private String password = "nbuser";

    private String tablePayment = "PAYMENT";
    private String columnPaymentId = "PAYMENTID";
    private String columnPaymentMethod = "PAYMENTMETHOD";
    private String columnPaymentAmount = "PAYMENTAMOUNT";
    private String columnPaymentDateTime = "PAYMENTDATETIME";
    private String columnForeignKey = "ORDERID";
    private Order order;


    private String selectCertainPaymentSQL = "SELECT * FROM " + tablePayment + " WHERE " + columnPaymentId + " = ?";
    private String insertSQL = "INSERT INTO " + tablePayment + " VALUES (?,?,?,?,?)";
    private String selectTodayTotalRecordsSQL = "SELECT COUNT (*) FROM " + tablePayment + " WHERE DATE(" + columnPaymentDateTime + ") = " + "'" + LocalDate.now() + "'";

    private PreparedStatement stmt;
    private Connection connection;


    public DAPayment() {
        createConnection();
    }

    //Get payment records
    public Payment getPaymentRecord(String orderId) {
        Payment Payment = null;
        try {
            String getPaymentSQL = "SELECT * FROM PAYMENT WHERE ORDERID = '"+orderId+"'";
            stmt = connection.prepareStatement(getPaymentSQL);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                DAOrder daOrder=new DAOrder();
                Order order=daOrder.getOrderRecord(rs.getString(5));
                Payment = new Payment(rs.getString(1), rs.getString(2), rs.getDouble(3), rs.getTimestamp(4), order);
                return Payment;
            }
        } catch (SQLException e) {
            System.out.println("Query failed: " + e.getMessage());
        }
        return null;
    }

    //Count total payment in order to create payment ID
    public int getPaymentCount() throws SQLException {
            stmt = connection.prepareStatement("SELECT COUNT (*) FROM PAYMENT");
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                return count;
            }
        return 0;//If today no record
    }

    //Insert payment records
    public void insertPaymentRecord(Payment payment) throws SQLException {
        stmt = connection.prepareStatement("INSERT INTO PAYMENT VALUES (?,?,?,?,?)");
        stmt.setString(1, payment.getPaymentId());
        stmt.setString(2, payment.getPaymentMethod());
        stmt.setDouble(3, payment.getPaymentAmount());
        stmt.setTimestamp(4, payment.getPaymentDateTime());
        stmt.setString(5, payment.getOrder().getOrderId());

        int rows = stmt.executeUpdate();
        if (rows > 0) {
            System.out.println("Payment Id : " + payment.getPaymentId() + " has been successfully created by " + payment.getPaymentDateTime());
        } else {
            System.out.println("Payment cannot be added");
        }
    }
    
    //added by gabriel to getPayment Record by Order Id
    public Payment getPaymentRecordbyOrdID(String orderID){
        String queryStr = "SELECT * FROM " + tablePayment + " WHERE ORDERID = ?";
        Payment paymentLocal = new Payment();
        
        try{
            stmt = connection.prepareStatement(queryStr);
            stmt.setString(1, orderID);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                //this should be putting their DA with string to get their data
                Order order = new Order(rs.getString(5));
                paymentLocal = new Payment(rs.getString(1), rs.getString(2), rs.getDouble(3), rs.getTimestamp(4), order);
                System.out.println("Successfully retrieved Payment Id " + paymentLocal.getPaymentId() + " record");
                System.out.println(paymentLocal.getPaymentDateTime());
                return paymentLocal;
                
            }
            
        }
        catch(SQLException ex){
            System.out.println(ex.getMessage()+"Error Get Payment Record");
        }
        
        return paymentLocal;
    }
    
    //added by gabriel to filter all completed order 
    public ArrayList<Payment> getCompletedPayment(){
        DAOrder orderDA = new DAOrder();
        ArrayList<Order> ordArrList = orderDA.getOrders();
        DAPayment paymentDA = new DAPayment();
        
        ArrayList<Payment> filterCompletedArrList = new ArrayList<Payment>();
        
        for(int i = 0 ; i < ordArrList.size() ; i++){
            if(ordArrList.get(i).getOrderStatus().equals("COMPLETED")){
                //only if the order is completed than is only counted as earning 
                Payment localPayment = paymentDA.getPaymentRecordbyOrdID(ordArrList.get(i).getOrderId());
                
                if(localPayment.getPaymentId()!=null){
                    filterCompletedArrList.add(localPayment);
                }
               
            }
        }
        
        return filterCompletedArrList;
        
    }
    
    //added by gabriel to get total sales of the website
    public double getTotalSales(int year){
        ArrayList<Payment> filterCompletedArrList = getCompletedPayment();
        
        double[] monthly = getSalesMonthly(year);
                
        double total = 0 ; 
        for(int i = 0 ; i < monthly.length;i++){
            total += monthly[i];
        }
        
        return total;
    }
    
    public double getTotalSales(){
        ArrayList<Payment> filterCompletedArrList = getCompletedPayment();
        
        
                
        double total = 0 ; 
        for(int i = 0 ; i < filterCompletedArrList.size();i++){
            total+=filterCompletedArrList.get(i).getPaymentAmount();
        }
        
        return total;
    }
    
    public double[] getSalesMonthly(int year){
        DAPayment paymentDA = new DAPayment();
        ArrayList<Payment> filterCompletedArrList = paymentDA.getCompletedPayment();
        
        LocalDateTime theStartingYear = LocalDateTime.of(year,1,1,00,00,00);
        LocalDateTime theEndingYear = theStartingYear.plusYears(1);
        
        double jan=0,feb=0,mar=0,apr=0,may=0,june=0,july=0,aug=0,sep=0,oct=0,nov=0,dec=0;
        
        
        
        for(int i = 0 ; i < filterCompletedArrList.size();i++){
            LocalDateTime time = filterCompletedArrList.get(i).getPaymentDateTime().toLocalDateTime();
            //if its between starting and ending 
            
            if(time.isBefore(theEndingYear) && time.isAfter(theStartingYear)){
                System.out.println("TESTING GO INTO YEAR");
                //format to only left month 
                DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("MM");
                int month = Integer.parseInt(time.format(myFormatObj));
                
                if(month == 1){
                    jan+= filterCompletedArrList.get(i).getPaymentAmount();
                }else if(month ==2 ){
                    feb+= filterCompletedArrList.get(i).getPaymentAmount();
                }else if (month ==3){
                    mar+= filterCompletedArrList.get(i).getPaymentAmount();
                }else if (month ==4){
                    apr+= filterCompletedArrList.get(i).getPaymentAmount();
                }else if (month ==5){
                    may+= filterCompletedArrList.get(i).getPaymentAmount();
                }else if (month ==6){
                    june+= filterCompletedArrList.get(i).getPaymentAmount();
                }else if (month ==7){
                    july+= filterCompletedArrList.get(i).getPaymentAmount();
                }else if (month ==8){
                    aug+= filterCompletedArrList.get(i).getPaymentAmount();
                }else if (month ==9){
                    sep+= filterCompletedArrList.get(i).getPaymentAmount();
                }else if (month ==10){
                    oct+= filterCompletedArrList.get(i).getPaymentAmount();
                }else if (month ==11){
                    nov+= filterCompletedArrList.get(i).getPaymentAmount();
                }else if (month ==12){
                    dec+= filterCompletedArrList.get(i).getPaymentAmount();
                }
            }
        }
        
        double[] monthly = {jan,feb,mar,apr,may,june,july,aug,sep,oct,nov,dec};
        return monthly;
    }
    
    public String getComparePercentage(double lastmonth , double currentmonth){
        
        if(lastmonth ==0){
            return String.format("No Records last month");
        }
        
        
        double result = (currentmonth/lastmonth)*100;
        if(result < 0){
            return String.format("-%.0f %% than last month",result);
        }
        return String.format("+%.0f %% than last month month",result);
        
    }
    


    public static void main(String[] args){
        
        
        
        /*
        ArrayList<Payment> paymentArrList = paymentDA.getCompletedPayment();
        
        
        double totalSales2021 = paymentDA.getTotalSales(2021);
        
        
        System.out.println(totalSales2021);
        
        for(int i = 0 ;i < paymentArrList.size();i++){
            System.out.println(paymentArrList.get(i).getPaymentId()+"\n");
        }
        */
        
        DAPayment paymentDA = new DAPayment();
        
        double[] array = paymentDA.getSalesMonthly(2022);
        
        
        System.out.println(array.length);
        for(int i = 0 ; i < array.length;i++){
            System.out.println(array[i]+"   ");
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
