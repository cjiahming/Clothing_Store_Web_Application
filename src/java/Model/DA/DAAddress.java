package Model.DA;

import Model.Domain.Address;
import Model.Domain.Customer;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.swing.JOptionPane;

public class DAAddress {

    private DACustomer custDA;
    private String host = "jdbc:derby://localhost:1527/fnfdb";
    private String user = "nbuser";
    private String password = "nbuser";
    private String tableName = "ADDRESS";
    private Connection conn;
    private PreparedStatement stmt;

    public DAAddress() {
        createConnection();
        custDA = new DACustomer();
    }

    //to display current logged in customer's addresses
    public ArrayList<Address> displayAllAddressRecords(String custID) {
        ArrayList<Address> address = new ArrayList<>();
        String displayAllAddressRecords = "SELECT * FROM " + tableName + " WHERE CUSTOMERID = ?";

        try {
            stmt = conn.prepareStatement(displayAllAddressRecords);
            stmt.setString(1, custID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Customer customer = custDA.displaySpecificCustomer(rs.getString("CUSTOMERID"));
                String addressID = rs.getString("ADDRESSID");
                String fullName = rs.getString("FULLNAME");
                String adrPhoneNum = rs.getString("ADRPHONENUM");
                String states = rs.getString("STATES");
                String area = rs.getString("AREA");
                String addressLine = rs.getString("ADDRESSLINE");
                String posCode = rs.getString("POSCODE");

                address.add(new Address(addressID, fullName, adrPhoneNum, states, area, addressLine, posCode, customer));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return address;
    }

    public Address displaySpecificAddress(String addressID) {
        Address address = null;
        String displaySpecificAddress = "SELECT * FROM " + tableName + " WHERE ADDRESSID = ?";

        try {
            stmt = conn.prepareStatement(displaySpecificAddress);
            stmt.setString(1, addressID);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Customer customer = custDA.displaySpecificCustomer(rs.getString("CUSTOMERID"));
                String fullName = rs.getString("FULLNAME");
                String adrPhoneNum = rs.getString("ADRPHONENUM");
                String states = rs.getString("STATES");
                String area = rs.getString("AREA");
                String addressLine = rs.getString("ADDRESSLINE");
                String posCode = rs.getString("POSCODE");

                address = new Address(addressID, fullName, adrPhoneNum, states, area, addressLine, posCode, customer);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return address;
    }

    public void addNewAddress(Address address) {
        String insertStr = "INSERT INTO " + tableName + " VALUES(?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            stmt = conn.prepareStatement(insertStr);
            stmt.setString(1, address.getAddressID());
            stmt.setString(2, address.getFullName());
            stmt.setString(3, address.getAdrPhoneNum());
            stmt.setString(4, address.getStates());
            stmt.setString(5, address.getArea());
            stmt.setString(6, address.getAddressLine());
            stmt.setString(7, address.getPosCode());
            stmt.setString(8, address.getCustomer().getUserID());

            stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.getMessage();
        }
    }

    public void updateAddress(Address address) {
        String updateStr = "UPDATE " + tableName + " SET FULLNAME=?, ADRPHONENUM=?, STATES=?, AREA=?, ADDRESSLINE=?, POSCODE=?, CUSTOMERID=? WHERE ADDRESSID=?";

        try {
            stmt = conn.prepareStatement(updateStr);
            stmt.setString(1, address.getFullName());
            stmt.setString(2, address.getAdrPhoneNum());
            stmt.setString(3, address.getStates());
            stmt.setString(4, address.getArea());
            stmt.setString(5, address.getAddressLine());
            stmt.setString(6, address.getPosCode());
            stmt.setString(7, address.getCustomer().getUserID());
            stmt.setString(8, address.getAddressID());
            stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.getMessage();
        }
    }

    public void deleteAddress(String addressID) {
        String deleteStr = "DELETE FROM " + tableName + " WHERE ADDRESSID = ?";

        try {
            stmt = conn.prepareStatement(deleteStr);
            stmt.setString(1, addressID);
            stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.getMessage();
        }
    }

    public int countSpecificCustomerAddressRows(String custID) {
        String countStr = "SELECT * FROM " + tableName + " WHERE CUSTOMERID = ?";
        int countAddressRows = 0;

        try {
            stmt = conn.prepareStatement(countStr);
            stmt.setString(1, custID);
            ResultSet resultSet = stmt.executeQuery();

            while (resultSet.next()) {
                countAddressRows++;
            }
        } catch (SQLException ex) {
            ex.getMessage();
        }
        countAddressRows++;
        return countAddressRows;
    }

    public ArrayList<String> getArea(String city) {
        ArrayList<String> cities = new ArrayList();

        String[] Penang = {"Bayan Lepas", "Bukit Mertajam", "Air Itam", "Balik Pulau", "Perai", "Air Itam", "Nibong Tebal", "Batu Ferringhi", "Kepala Batas", "Gelugor", "Batu Maung", "Tasek Gelugor"};
        String[] Ipoh = {"Ampang", "Anjung Tawas", "Bandar Seri Botani", "Bercham", "Canning Garden", "Greentown", "Meru Raya", "Pasir Puteh", "Kampung Simee"};
        String[] KL = {"Petaling Jaya", "Subang Jaya", "Shah Alam", "Klang", "Port Klang", "Ampang", "Puchong", "Rawang", "Kajang", "Sepang"};
        String[] Pahang = {"Balok", "Bandar Bera", "Bentong", "Damak", "Kuala Rompin", "Sungai Koyan", "Sungai Lembing", "Kuantan", "Kuala Lipis"};
        String[] nSembilan = {"Bahau", "Bandar Enstek", "Batu Kikir", "Kuala Pilah", "Nilai", "Pusat Bandar Palong", "Rompin", "Seremban", "Simpang Pertang"};
        String[] Selangor = {"Balakong", "Bangi", "Banting", "Batang Berjuntai", "Batu Arang", "Cyberjaya", "Klang", "Kuala Selangor", "Petaling Jaya"};
        String Perlis[] = {"Kaki Bukit", "Padang Besar", "Simpang Empat", "Wang Kelian", "Chuping", "Jejawi", "Kaki Bukit", "Sanglang", "Beseri"};
        String Kedah[] = {"Alor Setar", "Ayer Hitam", "Baling", "Kodiang", "Kuala Ketil", "Kota Kuala Muda", "Langkawi", "Kupang", "Lunas"};
        String[] Terengganu = {"Ceneh", "Dungun", "Kerteh", "Kuala Terengganu", "Marang", "Paka", "Permaisuri", "Sungai Tong", "Ayer Puteh"};
        String[] Melaka = {"Alor Gajah", "Asahan", "Ayer Keroh", "Bemban", "Durian Tunggal", "Jasin", "Durian Tunggal", "Melaka", "Sungai Rambai"};
        String[] Johor = {"Ayer Baloi", "Ayer Hitam", "Bandar Penawar", "Batu Pahat", "Gelang Patah", "Kota Tinggi", "Kulai", "Layang-Layang", "Nusajaya"};
        String[] Sabah = {"Bongawan", "Kota Marudu", "Lahad Datu", "Membakut", "Menumbok", "Penampang", "Tenghilan", "Tuaran", "Tenom"};
        String[] Sarawak = {"Asajaya", "Balingian", "Dalat", "Engkilili", "Long Lama", "Mukah", "Sebuyau", "Sri Aman", "Tatau"};

        int validation = 0;
        
        for (int i = 0; i < 13; i++) {
            switch (city) {
                case "Penang":
                    for (int j = 0; j < Penang.length; j++) {
                        cities.add(Penang[j]);
                    }
                    validation = 1;
                    break;
                case "Ipoh":
                    for (int j = 0; j < Ipoh.length; j++) {
                        cities.add(Ipoh[j]);
                    }
                    validation = 1;
                    break;
                case "Kuala Lumpur":
                    for (int j = 0; j < KL.length; j++) {
                        cities.add(KL[j]);
                    }
                    validation = 1;
                    break;
                case "Pahang":
                    for (int j = 0; j < Pahang.length; j++) {
                        cities.add(Pahang[j]);
                    }
                    validation = 1;
                    break;
                case "Negeri Sembilan":
                    for (int j = 0; j < nSembilan.length; j++) {
                        cities.add(nSembilan[j]);
                    }
                    validation = 1;
                    break;
                case "Selangor":
                    for (int j = 0; j < Selangor.length; j++) {
                        cities.add(Selangor[j]);
                    }
                    validation = 1;
                    break;
                case "Perlis":
                    for (int j = 0; j < Perlis.length; j++) {
                        cities.add(Perlis[j]);
                    }
                    validation = 1;
                    break;
                case "Kedah":
                    for (int j = 0; j < Kedah.length; j++) {
                        cities.add(Kedah[j]);
                    }
                    validation = 1;
                    break;
                case "Terengganu":
                    for (int j = 0; j < Terengganu.length; j++) {
                        cities.add(Terengganu[j]);
                    }
                    validation = 1;
                    break;
                case "Melaka":
                    for (int j = 0; j < Melaka.length; j++) {
                        cities.add(Melaka[j]);
                    }
                    validation = 1;
                    break;
                case "Johor":
                    for (int j = 0; j < Johor.length; j++) {
                        cities.add(Johor[j]);
                    }
                    validation = 1;
                    break;
                case "Sabah":
                    for (int j = 0; j < Sabah.length; j++) {
                        cities.add(Sabah[j]);
                    }
                    validation = 1;
                    break;
                case "Sarawak":
                    for (int j = 0; j < Sarawak.length; j++) {
                        cities.add(Sarawak[j]);
                    }
                    validation = 1;
                    break;
            }
            if(validation == 1){
                break;
            }
        }
        return cities;
    }

    private void createConnection() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(null, ex.getMessage(), "ERROR", JOptionPane.ERROR_MESSAGE);
        }
    }
    
    public static void main(String[] args){
        DAAddress aDA = new DAAddress();
        String city = "Penang";
        
        ArrayList<String> cities = aDA.getArea(city);
        
        for(int i=0; i<cities.size(); i++){
            System.out.println(cities.get(i));
        }
        
        
    }
}
