<?php

/*
 * Class that will email the user with new login credentials if they have forgotten them
 * Date: 30/01/2017
 * @author: Nouman Mehmood
 */

require("connection.php");

$returnValue = array();
$email   = $_POST['email'];
$memorable = $_POST['memorable'];

// Check if the fields are empty
if (empty($email) || empty($memorable)) {
    $returnValue['status'] = "Error";
    $returnValue['message'] = "The fields passed are empty";
    echo json_encode($returnValue);
    
} else {
    
    // If not empty, check the database for the values
    $statement = "SELECT username FROM users WHERE email='".$email."' AND memorable_word='".$memorable."'";
    $check = query_mysql($statement);
    $result = $check->num_rows;
    
    // If the value is found, get the value and generate a new password
    if ($result == 1) {
        $returnValue['status'] = "Success";
        $returnValue['message'] = "Value found in the db";
        
        while ($row = $check->fetch_assoc()){
            $user = $row['username'];
        }
        
        // update the database with the new password
        $password = "sfkjn6823r"; // in production, this will be a randomly generated string, it is only declared atm for testing
        $update = "UPDATE users SET password='".md5($password)."' WHERE username='".$user."'";
        $query = query_mysql($update);
        
        if (!$query) {
            $returnValue['insert'] = "DB insert Failed";
            echo json_encode($returnValue);
        } else {
            $returnValue['insert'] = "DB insert Success";
            
            // Concerning the email to client for password reset
            $from = 'mail@nouamnmehmood.com';
            $subject = 'ESFUERZO: Password reset request';
            
            $headers = "From: ".$from."\r\n";
            $headers .= "Reply-To: ".$from."\r\n";
            $headers .= "MIME-Version: 1.0\r\n";
            $headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
            
            $message = '<html><body>';
            $message .= '<h1>Esfuerzo: Password reset request</h1>';
            $message .= '</body></html>';
            
            $message = '<html><body>';
            $message .= '<p>You are receiving this email because a password reset request was isued for this email address. If you did not issue this request, <strong>please email: support@nouman.mehmood.com</strong></p>';
            $message .= '<p>The new credentials are:</p>';
            $message .= '<table rules="all" style="border-color: #666;" cellpadding="10">';
            $message .= "<tr style='background: #eee;'><td><strong>Your username:</strong> </td><td>" .$user. "</td></tr>";
            $message .= "<tr><td><strong>Your new password:</strong> </td><td>" .$password. "</td></tr>";
            $message .= '</br></br>';
            $message .= "</table>";
            $message .= '<p>Once logged into the app, you can change your password.</p>';
            $message .= '<p>Esfuerzo. Endeavour.</p>';
            $message .= "</body></html>";
            
            mail($email, $subject, $message, $headers);
            echo json_encode($returnValue);
        }
        
    } else {
        $returnValue['status'] = "Failed";
        $returnValue['message'] = "No such values in the db";
        echo json_encode($returnValue);
    }
    
}

?>
