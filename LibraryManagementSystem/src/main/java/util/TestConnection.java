package util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TestConnection {

    public static void main(String[] args) {

        try (Connection conn = DBConnection.getConnection()) {

            if(conn != null) {

                System.out.println("Connection Successful!");
                verifyBooksTable(conn);

            } else {

                System.out.println("Connection Failed!");

            }

        } catch (SQLException e) {
            System.out.println("Connection Failed!");
            e.printStackTrace();
        }
    }

    private static void verifyBooksTable(Connection conn) throws SQLException {
        String query = "SELECT COUNT(*) FROM Books";

        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                System.out.println("Books table reachable. Total books: " + rs.getInt(1));
            }
        }
    }
}
