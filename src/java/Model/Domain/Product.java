package Model.Domain;

/**
 *
 * @author Ashley
 */
import java.io.Serializable;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Objects;

public class Product implements Serializable {

    //class attributes
    private String prodID;
    private String prodName;
    private String prodDesc;
    private float prodPrice;
    private String prodCategory;
    private String prodImage;

    //default class constructor
    public Product() {

    }

    //constructor with a single parameter
    public Product(String prodID) {
        this.prodID = prodID;
    }

    //constructor with parameters
    public Product(String prodID, String prodName, String prodDesc, float prodPrice, String prodCategory, String prodImage) {
        this.prodID = prodID;
        this.prodName = prodName;
        this.prodDesc = prodDesc;
        this.prodPrice = prodPrice;
        this.prodCategory = prodCategory;
        this.prodImage = prodImage;
    }
    
    //INSERT constructor with parameters
    public Product(String prodName, String prodDesc, float prodPrice, String prodCategory, String prodImage) {
        this.prodID = generateProdID(prodCategory);
        this.prodName = prodName;
        this.prodDesc = prodDesc;
        this.prodPrice = prodPrice;
        this.prodCategory = prodCategory;
        this.prodImage = generateProdImage(prodImage);
    }

    //getters and setters
    public String getProdID() {
        return prodID;
    }

    public void setProdID(String prodID) {
        this.prodID = generateProdID(prodCategory);
    }

    public String getProdName() {
        return prodName;
    }

    public void setProdName(String prodName) {
        this.prodName = prodName;
    }

    public String getProdDesc() {
        return prodDesc;
    }

    public void setProdDesc(String prodDesc) {
        this.prodDesc = prodDesc;
    }

    public float getProdPrice() {
        return prodPrice;
    }

    public void setProdPrice(float prodPrice) {
        this.prodPrice = prodPrice;
    }

    public String getProdCategory() {
        return prodCategory;
    }

    public void setProdCategory(String prodCategory) {
        this.prodCategory = prodCategory;
    }

    public String getProdImage() {
        return prodImage;
    }

    public void setProdImage(String prodImage) {
        this.prodImage = prodImage;
    }

    //generate the Product ID based on its category and sequence
    public String generateProdID(String prodCategory) {
        Connection conn;
        PreparedStatement stmt;
        String host = "jdbc:derby://localhost:1527/fnfdb";
        String user = "nbuser";
        String password = "nbuser";

        int rowCount = 0;
        String rowCountStr;

        String category = "";
        String id = "";

        if (prodCategory == "WomenTops" || prodCategory.equals("WomenTops")) {
            category = "WT";
        } else if (prodCategory == "WomenSweatshirts" || prodCategory.equals("WomenSweatshirts")) {
            category = "WS";
        } else if (prodCategory == "WomenBottoms" || prodCategory.equals("WomenBottoms")) {
            category = "WB";
        } else if (prodCategory == "WomenDresses" || prodCategory.equals("WomenDresses")) {
            category = "WD";
        } else if (prodCategory == "MenTops" || prodCategory.equals("MenTops")) {
            category = "MT";
        } else if (prodCategory == "MenSweatshirts" || prodCategory.equals("MenSweatshirts")) {
            category = "MS";
        } else if (prodCategory == "MenBottoms" || prodCategory.equals("MenBottoms")) {
            category = "MB";
        }

        String countStr = "SELECT COUNT(*) FROM PRODUCT WHERE prodCategory = '" + prodCategory + "'";

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);

            stmt = conn.prepareStatement(countStr);
            ResultSet rs = stmt.executeQuery();

            //retrieving the result
            rs.next();
            rowCount = rs.getInt(1);
                    
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        rowCount++;

        rowCountStr = Integer.toString(rowCount);
        id = category + String.format("%04d", Integer.parseInt(rowCountStr));

        return id;
    }

    //generate the Product Image with its apropriate image path
    public String generateProdImage(String prodImage) {
        String imageURL = "assets/products/";

        String image = imageURL + prodImage;

        return image;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Product other = (Product) obj;
        if (!Objects.equals(this.prodID, other.prodID)) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return String.format("%-20s %-100s %-500s %-10.2f %-20s %-200s", prodID, prodName, prodDesc, prodPrice, prodCategory, prodImage);
    }
}
