package Model.Domain;

public class User {
    private String userID;
    private String username;
    private String phoneNum;
    private String email;
    private String password;
    private String gender;
    
    public User() {
        
    }
        
    public User(String userID){
        this.userID = userID;
    }  
            
    public User(String userID, String password){
        this.userID = userID;
        this.password = password;
    }
    
    public User(String userID, String phoneNum, String email, String gender){
        this.userID = userID;
        this.phoneNum = phoneNum;
        this.email = email;
        this.gender = gender;
    }
    
    public User(String userID, String username, String phoneNum, String email, String password){
        this.userID = userID;
        this.username = username;
        this.phoneNum = phoneNum;
        this.email = email;
        this.password = password;
    }
    
    public User(String userID, String username, String phoneNum, String email, String password, String gender){
        this.userID = userID;
        this.username = username;
        this.phoneNum = phoneNum;
        this.email = email;
        this.password = password;
        this.gender = gender;
    }

    public String getUserID() {
        return userID;
    }

    public String getUsername() {
        return username;
    }

    public String getPhoneNum() {
        return phoneNum;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getGender() {
        return gender;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPhoneNum(String phoneNum) {
        this.phoneNum = phoneNum;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }
    
    
}
