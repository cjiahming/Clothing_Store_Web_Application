package Model.Domain;

import java.io.Serializable;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Admin extends User implements Serializable {

    private UserGroup userGroup;
    private String firstName;
    private String lastName;

    public Admin() {

    }

    public Admin(String userID, String username, String firstName, String lastName, String phoneNum, String email, String password, String gender, UserGroup userGroup) {
        super(userID, username, phoneNum, email, password, gender);
        this.firstName = firstName;
        this.lastName = lastName;
        this.userGroup = userGroup;
    }

    public Admin(String userID, String phoneNum, String email, String gender) {
        super(userID, phoneNum, email, gender);
    }

    public Admin(String userID, String password) {
        super(userID, password);
    }

    public UserGroup getUserGroup() {
        return userGroup;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public void setUserGroup(UserGroup userGroup) {
        this.userGroup = userGroup;
    }

    //this method is used for encrypting password when user register account
    public static String getMd5(String input) {
        try {

            // Static getInstance method is called with hashing MD5
            MessageDigest md = MessageDigest.getInstance("MD5");

            // digest() method is called to calculate message digest
            //  of an input digest() return array of byte
            byte[] messageDigest = md.digest(input.getBytes());

            // Convert byte array into signum representation
            BigInteger no = new BigInteger(1, messageDigest);

            // Convert message digest into hex value
            String hashtext = no.toString(16);
            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            return hashtext;
        } // For specifying wrong message digest algorithms
        catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}
