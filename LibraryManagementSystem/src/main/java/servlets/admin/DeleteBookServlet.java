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

@WebServlet("/admin/delete-book-action")
public class DeleteBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AdminBookDAO bookDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        bookDAO = new AdminBookDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bookIdParam = request.getParameter("id");
        
        if (bookIdParam == null || bookIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-inventory.jsp?error=Invalid book ID.");
            return;
        }
        
        try {
            int bookId = Integer.parseInt(bookIdParam);
            Book book = bookDAO.getBookById(bookId);
            
            if (book == null) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-inventory.jsp?error=Book not found.");
                return;
            }
            
            if (bookDAO.deleteBook(bookId)) {
                AdminLogsDAO logsDAO = new AdminLogsDAO();
                Integer adminId = (Integer) request.getSession().getAttribute("adminId");
                if (adminId == null) {
                    adminId = 1;
                }
                
                String logAction = "Deleted book ID " + bookId + ": " + book.getTitle() + " (Author: " + book.getAuthor() + ")";
                logsDAO.logAction(adminId, logAction);
                
                response.sendRedirect(request.getContextPath() + "/admin/manage-inventory.jsp?success=Book deleted successfully!");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-inventory.jsp?error=Failed to delete book.");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-inventory.jsp?error=Invalid book ID.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
