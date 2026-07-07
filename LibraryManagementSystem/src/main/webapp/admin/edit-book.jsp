<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Book" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Book - Library Management System</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
            padding: 40px;
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .header p {
            color: #777;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }

        input[type="text"],
        input[type="number"],
        select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s ease;
            font-family: inherit;
        }

        input[type="text"]:focus,
        input[type="number"]:focus,
        select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .required {
            color: #e74c3c;
            font-weight: 600;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-row .form-group {
            margin-bottom: 0;
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

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        button {
            flex: 1;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        .btn-reset {
            background-color: #e0e0e0;
            color: #333;
        }

        .btn-reset:hover {
            background-color: #d0d0d0;
        }

        .btn-back {
            background-color: #95a5a6;
            color: white;
        }

        .btn-back:hover {
            background-color: #7f8c8d;
        }

        .form-hint {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }

        .character-count {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }

        @media (max-width: 600px) {
            .container {
                padding: 25px;
            }

            .header h1 {
                font-size: 24px;
            }

            .form-row {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .button-group {
                flex-direction: column;
            }
        }

        .loading {
            display: none;
            text-align: center;
            color: #667eea;
            margin: 20px 0;
        }

        .spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #667eea;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .book-id {
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Edit Book</h1>
            <p>Update the book details below</p>
        </div>

        <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
        <% Book book = (Book) request.getAttribute("book"); %>

        <% if (errorMessage == null && book == null) { %>
            <div class="alert alert-error show">
                Book not found.
            </div>
        <% } %>

        <div class="alert alert-error <%= (errorMessage != null) ? "show" : "" %>">
            <%= (errorMessage != null) ? errorMessage : "" %>
        </div>

        <% if (book != null) { %>
        <form id="editBookForm" method="POST" action="<%= request.getContextPath() %>/admin/edit-book-action" onsubmit="return validateForm(event)">
            
            <input type="hidden" id="bookId" name="bookId" value="<%= book.getBookId() %>">
            
            <div class="form-group">
                <label for="title">
                    Book Title
                    <span class="required">*</span>
                </label>
                <input type="text" id="title" name="title" placeholder="Enter book title" required maxlength="200" value="<%= (book.getTitle() != null) ? book.getTitle() : "" %>">
                <div class="character-count"><span id="titleCount"><%= (book.getTitle() != null) ? book.getTitle().length() : 0 %></span>/200</div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="author">
                        Author
                        <span class="required">*</span>
                    </label>
                    <input type="text" id="author" name="author" placeholder="Enter author name" required maxlength="100" value="<%= (book.getAuthor() != null) ? book.getAuthor() : "" %>">
                    <div class="character-count"><span id="authorCount"><%= (book.getAuthor() != null) ? book.getAuthor().length() : 0 %></span>/100</div>
                </div>

                <div class="form-group">
                    <label for="isbn">ISBN</label>
                    <input type="text" id="isbn" name="isbn" placeholder="Enter ISBN (10-20 chars)" maxlength="20" value="<%= (book.getIsbn() != null) ? book.getIsbn() : "" %>">
                    <div class="form-hint">ISBN is optional and must be unique</div>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="category">
                        Category
                        <span class="required">*</span>
                    </label>
                    <select id="category" name="category" required>
                        <option value="">-- Select a Category --</option>
                        <option value="Programming" <%= "Programming".equals(book.getCategory()) ? "selected" : "" %>>Programming</option>
                        <option value="Database" <%= "Database".equals(book.getCategory()) ? "selected" : "" %>>Database</option>
                        <option value="Networking" <%= "Networking".equals(book.getCategory()) ? "selected" : "" %>>Networking</option>
                        <option value="Operating Systems" <%= "Operating Systems".equals(book.getCategory()) ? "selected" : "" %>>Operating Systems</option>
                        <option value="Software Engineering" <%= "Software Engineering".equals(book.getCategory()) ? "selected" : "" %>>Software Engineering</option>
                        <option value="Web Development" <%= "Web Development".equals(book.getCategory()) ? "selected" : "" %>>Web Development</option>
                        <option value="Mobile Development" <%= "Mobile Development".equals(book.getCategory()) ? "selected" : "" %>>Mobile Development</option>
                        <option value="Data Science" <%= "Data Science".equals(book.getCategory()) ? "selected" : "" %>>Data Science</option>
                        <option value="Machine Learning" <%= "Machine Learning".equals(book.getCategory()) ? "selected" : "" %>>Machine Learning</option>
                        <option value="Other" <%= "Other".equals(book.getCategory()) ? "selected" : "" %>>Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="quantity">
                        Quantity
                        <span class="required">*</span>
                    </label>
                    <input type="number" id="quantity" name="quantity" placeholder="Enter quantity" required min="1" max="9999" value="<%= book.getQuantity() %>">
                    <div class="form-hint">Must be greater than 0</div>
                </div>
            </div>

            <div class="loading" id="loadingSpinner">
                <div class="spinner"></div>
                <p>Updating book, please wait...</p>
            </div>

            <div class="button-group">
                <button type="submit" class="btn-submit" id="submitBtn">Update Book</button>
                <button type="button" class="btn-back" onclick="goBack()">Back</button>
            </div>
        </form>
        <% } %>
    </div>

    <script>
        // Character counter for title
        document.getElementById('title').addEventListener('input', function() {
            document.getElementById('titleCount').textContent = this.value.length;
        });

        // Character counter for author
        document.getElementById('author').addEventListener('input', function() {
            document.getElementById('authorCount').textContent = this.value.length;
        });

        // Form validation
        function validateForm(event) {
            const title = document.getElementById('title').value.trim();
            const author = document.getElementById('author').value.trim();
            const category = document.getElementById('category').value.trim();
            const quantity = parseInt(document.getElementById('quantity').value);
            const isbn = document.getElementById('isbn').value.trim();

            // Title validation
            if (title.length < 2 || title.length > 200) {
                alert('Title must be between 2 and 200 characters');
                return false;
            }

            // Author validation
            if (author.length < 2 || author.length > 100) {
                alert('Author name must be between 2 and 100 characters');
                return false;
            }

            // Category validation
            if (category === '') {
                alert('Please select a category');
                return false;
            }

            // Quantity validation
            if (isNaN(quantity) || quantity <= 0) {
                alert('Quantity must be a number greater than 0');
                return false;
            }

            // ISBN validation (if provided)
            if (isbn !== '' && (isbn.length < 10 || isbn.length > 20)) {
                alert('ISBN must be between 10 and 20 characters');
                return false;
            }

            // Show loading spinner
            document.getElementById('loadingSpinner').style.display = 'block';
            document.getElementById('submitBtn').disabled = true;

            return true;
        }

        // Go back function
        function goBack() {
            window.history.back();
        }

        // Auto-hide error messages after 5 seconds
        window.addEventListener('load', function() {
            const errorAlert = document.querySelector('.alert.alert-error.show');

            if (errorAlert) {
                setTimeout(function() {
                    errorAlert.classList.remove('show');
                }, 5000);
            }
        });
    </script>
</body>
</html>
