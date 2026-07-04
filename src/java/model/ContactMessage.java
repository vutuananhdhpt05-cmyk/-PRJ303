/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Trung Kien
 */

import java.sql.Timestamp;

public class ContactMessage {

    private int id;                // ← thêm
    private String name;
    private String email;
    private String phone;
    private String message;
    private Timestamp createdAt;   // ← thêm
    private String reply;
    private Timestamp replyAt;

    public ContactMessage() {
    }

    // Constructor dùng để lưu (chưa có id/createdAt)
    public ContactMessage(String name, String email, String phone, String message) {
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.message = message;
    }

    // Constructor dùng khi load từ DB (có id + createdAt)
    public ContactMessage(int id, String name, String email, String phone,
            String message, Timestamp createdAt,
            String reply, Timestamp replyAt) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.message = message;
        this.createdAt = createdAt;
        this.reply = reply;
        this.replyAt = replyAt;
    }

    // getters & setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp ts) {
        this.createdAt = ts;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public Timestamp getReplyAt() {
        return replyAt;
    }

    public void setReplyAt(Timestamp t) {
        this.replyAt = t;
    }
}
