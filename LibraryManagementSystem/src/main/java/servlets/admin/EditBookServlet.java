package servlets.admin;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.admin.AdminBookDAO;
import dao.admin.AdminLogsDAO;
import models.Book;
import util.admin.InventoryUtils;

@WebServlet("/admin/edit-book-action")
public class EditBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AdminBookDAO bookDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        bookDAO = new AdminBookDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookIdParam = request.getParameter("id");
        
        if (bookIdParam == null || bookIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-inventory.jsp");
            return;
        }
        
        try {
            int bookId = Integer.parseInt(bookIdParam);
            Book book = bookDAO.getBookById(bookId);
            
            if (book == null) {
                request.setAttribute("errorMessage", "Book not found.");
                request.getRequestDispatcher("/admin/manage-inventory.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("book", book);
            request.getRequestDispatcher("/admin/edit-book.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-inventory.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bookIdParam = request.getParameter("bookId");
        String title = InventoryUtils.sanitizeInput(request.getParameter("title"));
        String author = InventoryUtils.sanitizeInput(request.getParameter("author"));
        String isbn = InventoryUtils.sanitizeInput(request.getParameter("isbn"));
        String category = InventoryUtils.sanitizeInput(request.getParameter("category"));
        String quantityStr = request.getParameter("quantity");
        
        String errorMessage = null;
        
        if (bookIdParam == null || bookIdParam.isEmpty()) {
            errorMessage = "Invalid book ID.";
        } else if (!InventoryUtils.validateTitle(title)) {
            errorMessage = "Title is required and must be between 2 and 200 characters.";
        } else if (!InventoryUtils.validateAuthor(author)) {
            errorMessage = "Author is required and must be between 2 and 100 characters.";
        } else if (!InventoryUtils.validateCategory(category)) {
            errorMessage = "Category is required and must not exceed 100 characters.";
        }
        
        if (errorMessage == null) {
            try {
                int quantity = Integer.parseInt(quantityStr);
                if (!InventoryUtils.validateQuantity(quantity)) {
                    errorMessage = "Quantity must be greater than 0.";
                }
            } catch (NumberFormatException e) {
                errorMessage = "Quantity must be a valid number.";
            }
        }
        
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            if (bookIdParam != null && !bookIdParam.isEmpty()) {
                try {
                    int bookId = Integer.parseInt(bookIdParam);
                    Book book = bookDAO.getBookById(bookId);
                    request.setAttribute("book", book);
                } catch (NumberFormatException e) {
                    // Keep the original validation message.
                }
            }
            request.getRequestDispatcher("/admin/edit-book.jsp").forward(request, response);
            return;
        }
        
        try {
            int bookId = Integer.parseInt(bookIdParam);
            Book book = bookDAO.getBookById(bookId);
            
            if (book == null) {
                request.setAttribute("errorMessage", "Book not found.");
                request.getRequestDispatcher("/admin/manage-inventory.jsp").forward(request, response);
                return;
            }
            
            String validatedISBN = null;
            if (!isbn.isEmpty()) {
                validatedISBN = InventoryUtils.validateISBN(isbn);
                if (validatedISBN == null) {
                    request.setAttribute("errorMessage", "ISBN must be between 10 and 20 characters.");
                    request.setAttribute("book", book);
                    request.getRequestDispatcher("/admin/edit-book.jsp").forward(request, response);
                    return;
                }
                
                if (!validatedISBN.equals(book.getIsbn()) && bookDAO.isISBNExists(validatedISBN)) {
                    request.setAttribute("errorMessage", "A book with this ISBN already exists.");
                    request.setAttribute("book", book);
                    request.getRequestDispatcher("/admin/edit-book.jsp").forward(request, response);
                    return;
                }
            }
            
            book.setTitle(title);
            book.setAuthor(author);
            book.setIsbn(validatedISBN);
            book.setCategory(category);
            int oldBorrowedQuantity = Math.max(0, book.getQuantity() - book.getAvailableQuantity());
            int newQuantity = Integer.parseInt(quantityStr);
            book.setQuantity(newQuantity);
            book.setAvailableQuantity(Math.max(0, newQuantity - oldBorrowedQuantity));
            
            if (bookDAO.updateBook(book)) {
                AdminLogsDAO logsDAO = new AdminLogsDAO();
                Integer adminId = (Integer) request.getSession().getAttribute("adminId");
                if (adminId == null) {
                    adminId = 1;
                }
                
                String logAction = "Updated book ID " + bookId + ": " + title + " (Author: " + author + ", Qty: " + book.getQuantity() + ")";
                logsDAO.logAction(adminId, logAction);
                
                response.sendRedirect(request.getContextPath() + "/admin/manage-inventory.jsp?success=" + encodeUrlParameter("Book updated successfully!"));
            } else {
                request.setAttribute("errorMessage", "Failed to update book. Please try again.");
                request.setAttribute("book", book);
                request.getRequestDispatcher("/admin/edit-book.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input.");
            request.getRequestDispatcher("/admin/edit-book.jsp").forward(request, response);
        }
    }

    private String encodeUrlParameter(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}
