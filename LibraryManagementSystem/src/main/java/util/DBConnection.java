package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import config.DatabaseConfig;

public class DBConnection {

    private DBConnection() {}

    public static Connection getConnection() throws SQLException {

        try {

            Class.forName(DatabaseConfig.DRIVER);

            Connection connection = DriverManager.getConnection(
                    DatabaseConfig.URL,
                    DatabaseConfig.USERNAME,
                    DatabaseConfig.PASSWORD
            );

            System.out.println("Database Connected Successfully!");
            return connection;

        } catch (ClassNotFoundException e) {

            throw new SQLException("MySQL Driver Not Found!", e);

        }
    }
}
