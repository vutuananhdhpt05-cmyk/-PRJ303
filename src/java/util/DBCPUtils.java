package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBCPUtils {
    
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=LaptopAsus;encrypt=true;trustServerCertificate=true";
    private static final String USER = "sa";
    private static final String PASS = "123";
    
    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.err.println("SQL Server Driver not found!");
        }
    }
    
    public static Connection getConnection() throws SQLException {
        // Trả về Connection trực tiếp thông qua DriverManager (hoạt động tốt với thư viện trong WEB-INF/lib)
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
