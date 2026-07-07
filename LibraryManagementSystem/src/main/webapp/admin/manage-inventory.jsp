<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.admin.AdminBookDAO" %>
<%@ page import="models.Book" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Inventory - Library Management System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            padding: 40px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 20px;
        }

        .header h1 {
            color: #333;
            font-size: 28px;
        }

        .header-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-back {
            background-color: #95a5a6;
            color: white;
        }

        .btn-back:hover {
            background-color: #7f8c8d;
        }

        .alert {
            padding: 15px 20px;
            border-radius: 5px;
            margin-bottom: 25px;
            font-size: 14px;
            display: none;
        }

        .alert.show {
            display: block;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .table-wrapper {
            overflow-x: auto;
            margin-top: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        thead {
            background-color: #f8f9fa;
            border-bottom: 2px solid #e0e0e0;
        }

        th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
            font-size: 14px;
            color: #555;
        }

        tbody tr:hover {
            background-color: #f8f9fa;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-edit {
            background-color: #3498db;
            color: white;
            padding: 8px 15px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 13px;
            display: inline-block;
        }

        .btn-edit:hover {
            background-color: #2980b9;
        }

        .btn-delete {
            background-color: #e74c3c;
            color: white;
            padding: 8px 15px;
            border-radius: 4px;
            border: none;
            font-size: 13px;
            cursor: pointer;
        }

        .btn-delete:hover {
            background-color: #c0392b;
        }

        .no-books {
            text-align: center;
            padding: 40px 20px;
            color: #999;
        }

        .no-books p {
            font-size: 16px;
            margin-bottom: 20px;
        }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 30px;
        }

        .pagination a,
        .pagination span {
            padding: 8px 12px;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            text-decoration: none;
            color: #333;
        }

        .pagination a:hover {
            background-color: #f0f0f0;
        }

        .pagination .active {
            background-color: #667eea;
            color: white;
            border-color: #667eea;
        }

        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }

            .header {
                flex-direction: column;
                align-items: flex-start;
            }

            .header h1 {
                font-size: 22px;
            }

            .header-actions {
                width: 100%;
            }

            .btn {
                flex: 1;
                min-width: 150px;
            }

            table {
                font-size: 12px;
            }

            th, td {
                padding: 10px 8px;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn-edit,
            .btn-delete {
                width: 100%;
                text-align: center;
            }
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.4);
        }

        .modal-content {
            background-color: white;
            margin: 15% auto;
            padding: 30px;
            border-radius: 10px;
            width: 90%;
            max-width: 400px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #333;
        }

        .modal-body {
            margin-bottom: 20px;
            color: #666;
        }

        .modal-actions {
            display: flex;
            gap: 10px;
        }

        .modal-actions button {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 4px;
            font-weight: 600;
            cursor: pointer;
            font-size: 14px;
        }

        .modal-actions .confirm {
            background-color: #e74c3c;
            color: white;
        }

        .modal-actions .confirm:hover {
            background-color: #c0392b;
        }

        .modal-actions .cancel {
            background-color: #e0e0e0;
            color: #333;
        }

        .modal-actions .cancel:hover {
            background-color: #d0d0d0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Manage Inventory</h1>
            <div class="header-actions">
                <a href="<%= request.getContextPath() %>/admin/add-book-action" class="btn btn-primary">+ Add New Book</a>
                <a href="<%= request.getContextPath() %>/admin/admin-dashboard.jsp" class="btn btn-back">Back to Dashboard</a>
            </div>
        </div>

        <% String successMessage = request.getParameter("success"); %>
        <% String errorMessage = request.getParameter("error"); %>

        <div class="alert alert-success <%= (successMessage != null) ? "show" : "" %>">
            <%= (successMessage != null) ? successMessage : "" %>
        </div>

        <div class="alert alert-error <%= (errorMessage != null) ? "show" : "" %>">
            <%= (errorMessage != null) ? errorMessage : "" %>
        </div>

        <%
            AdminBookDAO bookDAO = new AdminBookDAO();
            List<Book> books = bookDAO.getAllBooks();
        %>

        <% if (books != null && !books.isEmpty()) { %>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Author</th>
                        <th>ISBN</th>
                        <th>Category</th>
                        <th>Quantity</th>
                        <th>Available</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Book book : books) { %>
                    <tr>
                        <td><%= book.getBookId() %></td>
                        <td><%= book.getTitle() %></td>
                        <td><%= book.getAuthor() %></td>
                        <td><%= (book.getIsbn() != null && !book.getIsbn().isEmpty()) ? book.getIsbn() : "-" %></td>
                        <td><%= book.getCategory() %></td>
                        <td><%= book.getQuantity() %></td>
                        <td><%= book.getAvailableQuantity() %></td>
                        <td>
                            <div class="action-buttons">
                                <a href="<%= request.getContextPath() %>/admin/edit-book-action?id=<%= book.getBookId() %>" class="btn-edit">Edit</a>
                                <button class="btn-delete" onclick="showDeleteConfirmation(<%= book.getBookId() %>, '<%= book.getTitle() %>')">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <div class="no-books">
            <p>No books found in the inventory.</p>
            <a href="<%= request.getContextPath() %>/admin/add-book-action" class="btn btn-primary">Add Your First Book</a>
        </div>
        <% } %>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">Confirm Delete</div>
            <div class="modal-body">
                Are you sure you want to delete "<span id="bookTitle"></span>"? This action cannot be undone.
            </div>
            <div class="modal-actions">
                <button class="confirm" onclick="confirmDelete()">Delete</button>
                <button class="cancel" onclick="cancelDelete()">Cancel</button>
            </div>
        </div>
    </div>

    <form id="deleteForm" method="POST" action="<%= request.getContextPath() %>/admin/delete-book-action" style="display: none;">
        <input type="hidden" id="deleteBookId" name="id" value="">
    </form>

    <script>
        let deleteBookId = null;

        function showDeleteConfirmation(bookId, bookTitle) {
            deleteBookId = bookId;
            document.getElementById('bookTitle').textContent = bookTitle;
            document.getElementById('deleteModal').style.display = 'block';
        }

        function confirmDelete() {
            document.getElementById('deleteBookId').value = deleteBookId;
            document.getElementById('deleteForm').submit();
        }

        function cancelDelete() {
            document.getElementById('deleteModal').style.display = 'none';
            deleteBookId = null;
        }

        // Close modal when clicking outside of it
        window.onclick = function(event) {
            const modal = document.getElementById('deleteModal');
            if (event.target === modal) {
                modal.style.display = 'none';
                deleteBookId = null;
            }
        };

        // Auto-hide success/error messages after 5 seconds
        window.addEventListener('load', function() {
            const successAlert = document.querySelector('.alert.alert-success.show');
            const errorAlert = document.querySelector('.alert.alert-error.show');

            if (successAlert) {
                setTimeout(function() {
                    successAlert.classList.remove('show');
                }, 5000);
            }

            if (errorAlert) {
                setTimeout(function() {
                    errorAlert.classList.remove('show');
                }, 5000);
            }
        });
    </script>
</body>
</html>
