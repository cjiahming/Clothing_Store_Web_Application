package OTPClass;

import java.util.Properties;
import java.util.Random;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class SendEmail {
    //generate vrification code
    public String getRandom() {
        Random rnd = new Random();
        int number = rnd.nextInt(999999);
        return String.format("%06d", number);
    }

    //send email to the user email
    public boolean sendEmail(String email, String code) {
        boolean test = false;

        String toEmail = email;
        String fromEmail = "choongjm-pm20@student.tarc.edu.my";  //change this email to your current logged in email. (GMAIL OR HOTMAIL ALSO CAN)
        String password = "020124070317";   //change this password to your current logged in email's password.

        try {
            // your host email smtp server details
            Properties pr = new Properties();
            pr.setProperty("mail.smtp.host", "smtp.gmail.com"); //change this if you want to use hotmail or yahoo
            pr.setProperty("mail.smtp.port", "587");    //change this port number if you want to use hotmail or yahoo
            pr.setProperty("mail.smtp.auth", "true");
            pr.setProperty("mail.smtp.starttls.enable", "true");
            pr.put("mail.smtp.socketFactory.port", "587");
            pr.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
 
            //get session to authenticate the host email address and password
            Session session = Session.getInstance(pr, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromEmail, password);
                }
            });

            //set email message details
            Message mess = new MimeMessage(session);

    		//set from email address
            mess.setFrom(new InternetAddress(fromEmail));
    		//set to email address or destination email address
            mess.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
    		
    		//set email subject
            mess.setSubject("Password Reset OTP Number");
            
    		//set message text
            mess.setText("This OTP Number is used for resetting your password.\n"+"Make sure to enter the OTP Number given below correctly.\n"+"OTP Number : " + code);
            //send the message
            Transport.send(mess);
            
            test=true;
            
        } catch(Exception e) {
            e.printStackTrace();
        }

        return test;
    }
}