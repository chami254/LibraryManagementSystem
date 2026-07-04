package config;

public class DatabaseConfig {

    private DatabaseConfig() {
        // Prevent instantiation
    }

    public static final String URL =
            "jdbc:mysql://localhost:3306/librarymanagementdb";

    public static final String USERNAME =
            "root";

    public static final String PASSWORD =
            "39325229";

    public static final String DRIVER =
            "com.mysql.cj.jdbc.Driver";
}