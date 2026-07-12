/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;

public class VerifyCaptcha {
    private static final String SECRET_KEY = "6Lc232UrAAAAAOhcHgV_Tz28AoqcuaxpVNbhLbYx";

    public static boolean verify(String gRecaptchaResponse) {
        if (gRecaptchaResponse == null || gRecaptchaResponse.isEmpty()) {
            return false;
        }

        try {
            URL url = new URL("https://www.google.com/recaptcha/api/siteverify");
            String postData = "secret=" + SECRET_KEY + "&response=" + gRecaptchaResponse;

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);

            OutputStream out = conn.getOutputStream();
            out.write(postData.getBytes());
            out.flush();
            out.close();

            Scanner in = new Scanner(conn.getInputStream());
            String json = in.useDelimiter("\\A").next();
            in.close();

            return json.contains("\"success\": true");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
