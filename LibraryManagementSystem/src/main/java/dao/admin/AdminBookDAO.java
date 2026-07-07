package dao.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import models.Book;
import util.DBConnection;

public class AdminBookDAO {

    public boolean addBook(Book book) {
        String query = "INSERT INTO Books (title, author, isbn, category, quantity, available_quantity) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getAuthor());
            stmt.setString(3, book.getIsbn());
            stmt.setString(4, book.getCategory());
            stmt.setInt(5, book.getQuantity());
            stmt.setInt(6, book.getAvailableQuantity());
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error adding book: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String query = "SELECT * FROM Books ORDER BY book_id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Book book = new Book();
                book.setBookId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setIsbn(rs.getString("isbn"));
                book.setCategory(rs.getString("category"));
                book.setQuantity(rs.getInt("quantity"));
                book.setAvailableQuantity(rs.getInt("available_quantity"));
                books.add(book);
            }
            
        } catch (SQLException e) {
            System.out.println("Error fetching books: " + e.getMessage());
            e.printStackTrace();
        }
        
        return books;
    }

    public Book getBookById(int bookId) {
        String query = "SELECT * FROM Books WHERE book_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, bookId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Book book = new Book();
                    book.setBookId(rs.getInt("book_id"));
                    book.setTitle(rs.getString("title"));
                    book.setAuthor(rs.getString("author"));
                    book.setIsbn(rs.getString("isbn"));
                    book.setCategory(rs.getString("category"));
                    book.setQuantity(rs.getInt("quantity"));
                    book.setAvailableQuantity(rs.getInt("available_quantity"));
                    return book;
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error fetching book: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }

    public boolean updateBook(Book book) {
        String query = "UPDATE Books SET title = ?, author = ?, isbn = ?, category = ?, quantity = ?, available_quantity = ? WHERE book_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getAuthor());
            stmt.setString(3, book.getIsbn());
            stmt.setString(4, book.getCategory());
            stmt.setInt(5, book.getQuantity());
            stmt.setInt(6, book.getAvailableQuantity());
            stmt.setInt(7, book.getBookId());
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error updating book: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteBook(int bookId) {
        String query = "DELETE FROM Books WHERE book_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, bookId);
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error deleting book: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean isISBNExists(String isbn) {
        String query = "SELECT COUNT(*) FROM Books WHERE isbn = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, isbn);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error checking ISBN: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
}
