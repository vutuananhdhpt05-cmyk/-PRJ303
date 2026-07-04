// src/main/java/model/ChatItem.java
package model;

import java.util.Date;

public class ChatItem {
    private final String sender;  // "USER" hoặc "ADMIN"
    private final String text;
    private final Date   time;    // dùng java.util.Date

    public ChatItem(String sender, String text, Date time) {
        this.sender = sender;
        this.text   = text;
        this.time   = time;
    }
    public String getSender() { return sender; }
    public String getText()   { return text; }
    public Date   getTime()   { return time; }
}
