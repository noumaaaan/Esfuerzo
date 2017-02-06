<?php
/*
 * Configuration file to save database connections
 * Date: 30/01/2017
 * @author: Nouman Mehmood
 */

require("connection.php");

$returnValue = array();

$username = $_POST['username'];
$password = $_POST['password'];

if ((empty($username)) || (empty($password))) {
    $returnValue["status"] = "Error";
    $returnValue["message"] = "The fields passed are empty";
    echo json_encode($returnValue);
    
} else {
    
    $password = md5($password);
    $statement = "SELECT * FROM users WHERE username='".$username."' AND password = '".$password."'";
    $check = query_mysql($statement);
    
    if ($check->num_rows == 0) {
        $returnValue["status"] = "Error";
        $returnValue["message"] = "No such details found on server";
        echo json_encode($returnValue);
    } else {
        $returnValue["status"] = "Success";
        $returnValue["message"] = "Successfully found login details";
        echo json_encode($returnValue);
    }
} 


?>
