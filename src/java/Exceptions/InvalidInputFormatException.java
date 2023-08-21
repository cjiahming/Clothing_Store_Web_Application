/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Exceptions;

/**
 *
 * @author jiyeo
 */
public class InvalidInputFormatException extends Exception {
    public static final String INVALID_PASSWORD = "⚠ Password is not strong enough/in a correct format.";  
     public static final String PASSWORD_NOT_MATHCED = "⚠ Password is not matching !";  
     public static final String INVALID_PHONE_NUM = "⚠ Invalid phone number entered !"; 
     public static final String INVALID_EMAIL = "⚠ Invalid email format !"; 
     public static final String INVALID_ACCESS = "⚠ At least one page must be enabled !"; 

    public InvalidInputFormatException(String str) {

        super(str);
    }

}
