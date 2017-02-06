<?php

/*
 * Configuration file to save database connections
 * Date: 30/01/2017
 * @author: Nouman Mehmood
 */

$dbhost = "noumanmehmood.com.mysql";
$dbname = "noumanmehmood_com";
$dbuser = "noumanmehmood_com";
$dbpass = "yyaKnuJB";

$connect = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);
if (!$connect) die('Failed to connect to MySQL Database '.mysqli_connect_error());

function query_mysql($query){
    global $connect;
    return mysqli_query($connect, $query);
}

?>
