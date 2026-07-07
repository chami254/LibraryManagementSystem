package config;

public class DatabaseConfig {

    private DatabaseConfig() {
        // Prevent instantiation
    }

    public static final String URL = getConfigValue(
            "library.db.url",
            "LIBRARY_DB_URL",
            "jdbc:mysql://localhost:3306/LibraryManagementDB"
    );

    public static final String USERNAME = getConfigValue(
            "library.db.username",
            "LIBRARY_DB_USERNAME",
            "root"
    );

    public static final String PASSWORD = getPasswordValue(
            "library.db.password",
            "LIBRARY_DB_PASSWORD",
            ""
    );

    public static final String DRIVER = getConfigValue(
            "library.db.driver",
            "LIBRARY_DB_DRIVER",
            "com.mysql.cj.jdbc.Driver"
    );

    private static String getConfigValue(String systemProperty, String environmentVariable, String defaultValue) {
        String value = System.getProperty(systemProperty);
        if (value == null || value.trim().isEmpty()) {
            value = System.getenv(environmentVariable);
        }
        return (value == null || value.trim().isEmpty()) ? defaultValue : value.trim();
    }

    private static String getPasswordValue(String systemProperty, String environmentVariable, String defaultValue) {
        String value = System.getProperty(systemProperty);
        if (value == null) {
            value = System.getenv(environmentVariable);
        }
        return value == null ? defaultValue : value;
    }
}
