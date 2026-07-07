package dao.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import util.DBConnection;

public class AdminLogsDAO {

    public boolean logAction(int adminId, String action) {
        String query = "INSERT INTO AdminLogs (admin_id, action) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, adminId);
            stmt.setString(2, action);
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error logging action: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
