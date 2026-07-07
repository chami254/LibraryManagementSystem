<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Library System</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .auth-container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0px 4px 10px rgba(0,0,0,0.1); width: 300px; }
        h2 { text-align: center; color: #333; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="text"], input[type="password"] { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        button { width: 100%; padding: 10px; background-color: #007bff; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; }
        button:hover { background-color: #0056b3; }
        .link { text-align: center; margin-top: 15px; }
        .error { color: red; text-align: center; font-weight: bold; margin-bottom: 10px; }
        .success { color: green; text-align: center; font-weight: bold; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="auth-container">
        <h2>Library Login</h2>

        <% if ("invalid".equals(request.getParameter("error"))) { %>
            <div class="error">Invalid username or password.</div>
        <% } else if ("loggedout".equals(request.getParameter("status"))) { %>
            <div class="success">You have been securely logged out.</div>
        <% } else if ("success".equals(request.getParameter("status"))) { %>
            <div class="success">Registration successful! Please login.</div>
        <% } %>

        <form action="LoginServlet" method="POST">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit">Login</button>
        </form>
        <div class="link">
            <a href="register.jsp">Need an account? Register here.</a>
        </div>
    </div>
</body>
</html>