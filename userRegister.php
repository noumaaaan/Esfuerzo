<?php

/*
 * Register a new user file, return JSON request via Swift
 * Date: 30/01/2017
 * @author: Nouman Mehmood
 */

require("connection.php");

$returnValue = array();

$fullName  = $_POST['fullName'];
$uniName   = $_POST['uniName'];
$uniCourse = $_POST['uniCourse'];
$username  = $_POST['username'];
$password  = $_POST['password'];
$memorable = $_POST['memorable'];
$email     = $_POST['email'];

if ((empty($fullName)) || (empty($uniName)) ||(empty($uniCourse)) || (empty($username)) || (empty($password)) || (empty($memorable)) || (empty($email))) {
    $returnValue['status'] = "Error";
    $returnValue['message'] = "All of the fields passed are empty";
    echo json_encode($returnValue);
    
    // Provided the values are not empty
} else {
    
    $password = md5($password); // encrypt the password
    $statement = "INSERT INTO users (full_name, uni_name, uni_course, username, password, memorable_word, email) VALUES ('".$fullName."', '".$uniName."', '".$uniCourse."', '".$username."', '".$password."', '".$memorable."', '".$email."')";
    query_mysql($statement);
    
    $returnValue['status'] = "Success";
    $returnValue['message'] = "Values added successfully";
    echo json_encode($returnValue);
}

?>
