$( document ).ready( function() {
    $("#loginButton").click(function(){
        login();
    });
    
    $("#signupButton").click(function(){
        alert('clicked on signup!');
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
        dataType: "json",
        success: function(response) {
            alert(response); // works as expected (returns all html)
        }
    });
}