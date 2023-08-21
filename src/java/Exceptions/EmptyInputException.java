/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Exceptions;


public class EmptyInputException extends Exception {
    public static final String NULL_INPUT ="⚠ Input is required !";  
    public static final String NULL_PRODUCT ="Please select a product before proceed.";  
    public static final String NULL_SKU ="Please select a SKU before proceed.";  
    public static final String NULL_STOCK_ACTION = "Please Select Stock Action Before Proceed!";
    public static final String NULL_STOCKOUT_REASON= "Please provide the stock out reason in the remark section.";
    

    public EmptyInputException(String str) {
        super(str);
    }

}
