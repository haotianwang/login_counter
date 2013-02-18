var SUCCESS=1;
var ERR_BAD_CREDENTIALS=-1;
var ERR_USER_EXISTS=-2;
var ERR_BAD_USERNAME=-3;
var ERR_BAD_PASSWORD=-4;

$( document ).ready( function() {
    $("#loginButton").click(function(){
        login();
    });
    
    $("#signupButton").click(function(){
        add();
    });
    
    $("#logoutButton").click(function() {
        $("#accountFields").css("display","none");
        $("#loginFields").css("display","block");
        $("#messageBox").html("Please enter your credentials below");
        $("#usernameInput").val($("#usernameInput").css("placeholder"));
        $("#passwordInput").val($("#passwordInput").css("placeholder"));
    });
});

function getUsername() {
    return $("#usernameInput").val();
}

function getPassword() {
    return $("#passwordInput").val();
}

function login() {
    $.ajax({
        url: "users/login",
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify({user: getUsername(), password: getPassword() }),
        dataType: "json"
    }).done(function(data) {
        if (data.errCode > 0) {
            $("#accountFields").css("display","block");
            $("#loginFields").css("display","none");
        }
        $("#messageBox").html(getMessage(data));
    });
}

function add() {
    $.ajax({
        url: "users/add",
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify({user: getUsername(), password: getPassword() }),
        dataType: "json"
    }).done(function(data) {
        if (data.errCode > 0) {
            $("#accountFields").css("display","block");
            $("#loginFields").css("display","none");
        }
        $("#messageBox").html(getMessage(data));
    });
}

function getMessage(data) {
    if (data.errCode == 1) return "Welcome " + getUsername() + ". You have logged in " + data.count + " times.";
    if (data.errCode == -1) return "cannot find the user/password pair in the database";
    if (data.errCode == -2) return "trying to add a user that already exists";
    if (data.errCode == -3) return "invalid user name (user name should be non-empty and at most 128 ascii characters long)";
    if (data.errCode == -4) return "invalid password (password should be at most 128 ascii characters)";
    return "internal server error code " + data.errCode;
}