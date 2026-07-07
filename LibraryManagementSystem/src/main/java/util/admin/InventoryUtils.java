package util.admin;

import models.Book;

public class InventoryUtils {

    public static boolean validateBookData(Book book) {
        return validateTitle(book.getTitle()) &&
               validateAuthor(book.getAuthor()) &&
               validateQuantity(book.getQuantity());
    }

    public static boolean validateTitle(String title) {
        if (title == null || title.trim().isEmpty()) {
            return false;
        }
        return title.trim().length() >= 2 && title.trim().length() <= 200;
    }

    public static boolean validateAuthor(String author) {
        if (author == null || author.trim().isEmpty()) {
            return false;
        }
        return author.trim().length() >= 2 && author.trim().length() <= 100;
    }

    public static String validateISBN(String isbn) {
        if (isbn == null || isbn.trim().isEmpty()) {
            return null;
        }
        String cleanedISBN = isbn.trim();
        if (cleanedISBN.length() < 10 || cleanedISBN.length() > 20) {
            return null;
        }
        return cleanedISBN;
    }

    public static boolean validateQuantity(int quantity) {
        return quantity > 0;
    }

    public static boolean validateCategory(String category) {
        return category != null && !category.trim().isEmpty() && category.trim().length() <= 100;
    }

    public static String sanitizeInput(String input) {
        if (input == null) {
            return "";
        }
        return input.trim();
    }
}
