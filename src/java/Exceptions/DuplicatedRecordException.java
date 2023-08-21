package Exceptions;


public class DuplicatedRecordException extends Exception {
    public static final String DUPLICATED_USERNAME = "⚠ Username already existed. ";
    public static final String DUPLICATED_UG_NAME = "⚠ User Group Name already existed. ";

    public DuplicatedRecordException(String str) {

        super(str);
    }

}
