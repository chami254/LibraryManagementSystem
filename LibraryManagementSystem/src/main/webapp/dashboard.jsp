<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. Session Management (Module 1 Requirement)
    // Prevent unauthenticated access
   /* if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Safety route: If an admin logs in, send them to the admin dashboard
    String role = (String) session.getAttribute("role");
    if ("Admin".equalsIgnoreCase(role)) {
        response.sendRedirect("admin.jsp");
        return;
    }*/
    
    String currentUsername = "Lazaro";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard - Library Management System</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; background-color: #f9f9f9; }
        .nav-bar { display: flex; justify-content: space-between; align-items: center; background-color: #333; color: white; padding: 10px 20px; }
        .nav-bar a { color: white; text-decoration: none; margin-left: 15px; }
        .nav-bar a:hover { text-decoration: underline; }
        .content-section { background: white; padding: 20px; margin-top: 20px; border-radius: 5px; border: 1px solid #ddd; }
        .search-box { margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #f4f4f4; }
    </style>
</head>
<body>

    <div class="nav-bar">
        <h2>Welcome, <%= currentUsername %>!</h2>
        <div>
            <a href="dashboard.jsp">Home</a>
            <a href="borrow.jsp">Borrow Book</a>
            <a href="return.jsp">Return Book</a>
            <a href="LogoutServlet">Logout</a>
        </div>
    </div>

    <div class="content-section">
        <h3>Search for Books</h3>
        <div class="search-box">
            <form action="SearchServlet" method="GET">
                <input type="text" name="query" placeholder="Enter book title, author, or ISBN..." size="50" required>
                <button type="submit">Search</button>
            </form>
        </div>
    </div>

    <div class="content-section">
        <h3>Available Books</h3>
        <table>
            <thead>
                <tr>
                    <th>Book ID</th>
                    <th>Title</th>
                    <th>Author</th>
                    <th>ISBN</th>
                    <th>Category</th>
                    <th>Available Copies</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>101</td>
                    <td>Java: The Complete Reference</td>
                    <td>Herbert Schildt</td>
                    <td>123456789</td>
                    <td>Programming</td>
                    <td>5</td>
                    <td>
                        <form action="BorrowServlet" method="POST">
                            <input type="hidden" name="book_id" value="101">
                            <button type="submit">Borrow</button>
                        </form>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="content-section">
        <h3>Your Currently Borrowed Books</h3>
        <table>
            <thead>
                <tr>
                    <th>Borrow ID</th>
                    <th>Book Title</th>
                    <th>Borrow Date</th>
                    <th>Due Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td colspan="5" style="text-align:center;">You have no active borrows.</td>
                </tr>
            </tbody>
        </table>
    </div>

</body>
</html>