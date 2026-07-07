package servlets.admin;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.admin.AdminBookDAO;
import dao.admin.AdminLogsDAO;
import models.Book;
import util.admin.InventoryUtils;

@WebServlet("/admin/add-book-action")
public class AddBookServlet extends HttpServlet {
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
        request.getRequestDispatcher("/admin/add-book.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String title = InventoryUtils.sanitizeInput(request.getParameter("title"));
        String author = InventoryUtils.sanitizeInput(request.getParameter("author"));
        String isbn = InventoryUtils.sanitizeInput(request.getParameter("isbn"));
        String category = InventoryUtils.sanitizeInput(request.getParameter("category"));
        
        String quantityStr = request.getParameter("quantity");
        int quantity = 0;
        
        String errorMessage = null;
        
        if (!InventoryUtils.validateTitle(title)) {
            errorMessage = "Title is required and must be between 2 and 200 characters.";
        } else if (!InventoryUtils.validateAuthor(author)) {
            errorMessage = "Author is required and must be between 2 and 100 characters.";
        } else if (!InventoryUtils.validateCategory(category)) {
            errorMessage = "Category is required and must not exceed 100 characters.";
        } else {
            try {
                quantity = Integer.parseInt(quantityStr);
                if (!InventoryUtils.validateQuantity(quantity)) {
                    errorMessage = "Quantity must be greater than 0.";
                }
            } catch (NumberFormatException e) {
                errorMessage = "Quantity must be a valid number.";
            }
        }
        
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("/admin/add-book.jsp").forward(request, response);
            return;
        }
        
        String validatedISBN = null;
        if (!isbn.isEmpty()) {
            validatedISBN = InventoryUtils.validateISBN(isbn);
            if (validatedISBN == null) {
                request.setAttribute("errorMessage", "ISBN must be between 10 and 20 characters.");
                request.getRequestDispatcher("/admin/add-book.jsp").forward(request, response);
                return;
            }
            
            if (bookDAO.isISBNExists(validatedISBN)) {
                request.setAttribute("errorMessage", "A book with this ISBN already exists.");
                request.getRequestDispatcher("/admin/add-book.jsp").forward(request, response);
                return;
            }
        }
        
        Book book = new Book(title, author, validatedISBN, category, quantity);
        
        if (bookDAO.addBook(book)) {
            AdminLogsDAO logsDAO = new AdminLogsDAO();
            Integer adminId = (Integer) request.getSession().getAttribute("adminId");
            if (adminId == null) {
                adminId = 1;
            }
            
            String logAction = "Added book: " + title + " (Author: " + author + ", Qty: " + quantity + ")";
            logsDAO.logAction(adminId, logAction);
            
            request.setAttribute("successMessage", "Book added successfully!");
            request.getRequestDispatcher("/admin/add-book.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Failed to add book. Please try again.");
            request.getRequestDispatcher("/admin/add-book.jsp").forward(request, response);
        }
    }
}
