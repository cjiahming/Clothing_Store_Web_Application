package Model.Domain;

import Model.DA.DAAddress;
//import Model.DA.DAAdmin;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class Address implements Serializable{
    private String addressID;
    private String fullName;
    private String adrPhoneNum; 
    private String country;
    private String states;
    private String area;
    private String addressLine;
    private String posCode;
    private Customer customer;
    
    public Address() {
        
    }
    
    public Address(String addressID) {
        this.addressID = addressID;
    }
    
    public Address(String addressID, String country, String states, String area, String addressLine, String posCode, Customer customer){
        this.addressID = addressID;
        this.country = country;
        this.states = states;
        this.area = area;
        this.addressLine = addressLine;
        this.posCode = posCode;
        this.customer = customer;
    }
    
    public Address(String addressID, String fullName, String adrPhoneNum, String states, String area, String addressLine, String posCode, Customer customer){
        this.addressID = addressID;
        this.fullName = fullName;
        this.adrPhoneNum = adrPhoneNum;
        this.states = states;
        this.area = area;
        this.addressLine = addressLine;
        this.posCode = posCode;
        this.customer = customer;
    }
    
    //added by jenny
     public Address(String addressID, String fullName, String adrPhoneNum, String states, String area, String addressLine, String posCode){
        this.addressID = addressID;
        this.fullName = fullName;
        this.adrPhoneNum = adrPhoneNum;
        this.states = states;
        this.area = area;
        this.addressLine = addressLine;
        this.posCode = posCode;
    }
    
    public String getAddressID() {
        return addressID;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public String getAdrPhoneNum() {
        return adrPhoneNum;
    }
    
    public String getCountry() {
        return country;
    }
    
    public String getStates() {
        return states;
    }
    
    public String getArea() {
        return area;
    }
    
    public String getAddressLine() {
        return addressLine;
    }
    
    public String getPosCode() {
        return posCode;
    }
    
    public Customer getCustomer(){
        return customer;
    }
    
    public void setAddressID() {
        this.addressID = addressID;
    }
    
    public void setCountry() {
        this.country = country;
    }
    
    public void setStates() {
        this.states = states;
    }
    
    public void setArea() {
        this.area = area;
    }
    
    public void setAddressLine() {
        this.addressLine = addressLine;
    }
    
    public void setPosCode() {
        this.posCode = posCode;
    }
    
    public void setCustomer(Customer customer){
        this.customer = customer;
    }
    
    
    public String getAddressRows(String custID) {    
        DAAddress addressDA = new DAAddress();
        String nextAddressRows;
        String nextAddressRows2;
        String errorMessage = "You can only have a maximum of 3 address only!";
        
        int countAddressRows = addressDA.countSpecificCustomerAddressRows(custID);
        
        if(countAddressRows > 3){
            return errorMessage;
        }
        else{
            nextAddressRows = Integer.toString(countAddressRows);
            nextAddressRows2 = String.format("ADR-"+custID+"-"+countAddressRows, Integer.parseInt(nextAddressRows));
            return nextAddressRows2;
        }
    }
}
