<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: #f4f6f8;
            color: #222;
        }

        .container {
            max-width: 900px;
            margin: 60px auto;
            padding: 32px;
            background: #fff;
            border: 1px solid #dfe3e8;
            border-radius: 8px;
        }

        h1 {
            margin: 0 0 10px;
            font-size: 30px;
        }

        p {
            color: #555;
            margin: 0 0 28px;
        }

        .links {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 14px;
        }

        a {
            display: block;
            padding: 14px 16px;
            border: 1px solid #cfd7df;
            border-radius: 6px;
            color: #174ea6;
            text-decoration: none;
            font-weight: 600;
            background: #fafbfc;
        }

        a:hover {
            background: #eef4ff;
            border-color: #9bbcff;
        }
    </style>
</head>
<body>
    <main class="container">
        <h1>Library Management System</h1>
        <p>Use the links below to test the deployed application in the current Tomcat context.</p>

        <div class="links">
            <a href="<%= request.getContextPath() %>/admin/admin-dashboard.jsp">Admin Dashboard</a>
            <a href="<%= request.getContextPath() %>/admin/manage-inventory.jsp">Manage Inventory</a>
            <a href="<%= request.getContextPath() %>/admin/add-book-action">Add Book</a>
            <a href="<%= request.getContextPath() %>/login.jsp">Login</a>
        </div>
    </main>
</body>
</html>
