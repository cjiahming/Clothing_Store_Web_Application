<%-- 
    Document   : 401Error
    Author     : Cheng Ling Ern
--%>
<%@ page isErrorPage="true" %>  
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/siteIcon.png" />
        <title> 404 ERROR - Fast&Fashion</title>
                <style>
    body{
        background-color: #F2F2F2;
    }
/* CSS */
.button-73 {
  appearance: none;
  background-color: #FFFFFF;
  border-radius: 40em;
  border-style: none;
  box-shadow: #ADCFFF 0 -12px 6px inset;
  box-sizing: border-box;
  color: #000000;
  cursor: pointer;
  display: block;
  font-family: -apple-system,sans-serif;
  font-size: 8px;
  font-weight: 500;
  letter-spacing: -.24px;
  margin: 0;
  outline: none;
  quotes: auto;
  text-align: center;
  text-decoration: none;
  transition: all .15s;
  user-select: none;
  -webkit-user-select: none;
  touch-action: manipulation;
  display: block; margin-left: auto; margin-right: auto;
}

.button-73:hover {
  background-color: #FFC229;
  box-shadow: #FF6314 0 -6px 8px inset;
  transform: scale(1.125);
}

.button-73:active {
  transform: scale(1.025);
}

@media (min-width: 768px) {
  .button-73 {
    font-size: 15px;
    padding: .75rem 2rem;
  }
}

</style>
    </head>
    <body>

        <img class="mb-4 img-error" src="assets/404Error-Customer.svg" style="height:450px;display: block; margin-left: auto; margin-right: auto; "/>
        <p class="lead" style="font-size: 25px;text-align:center;">Opps... Your session has ended or unknown error has occurred<br/><span style="font-size: 20px;">Please try again later.</span></p>
        <a href="Customer_LoginPage_customerView.jsp"><button class="button-73" role="button" type="submit">Back to home</button></a>
        <p style="font-size: 18px;text-align:center;color:gray;"><%= "Exception: " + exception%>
            <br/><% if(exception!=null){ %><%= "Error: " + exception.getMessage()%><% }%></p>

    </body>
</html>

