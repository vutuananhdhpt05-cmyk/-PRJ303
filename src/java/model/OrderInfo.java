package model;

import java.sql.Timestamp;

/**
 * Model lưu thông tin giao hàng và thanh toán cho mỗi đơn hàng.
 * Bảng tương ứng: OrderInfo (OrderID PK, FK)
 */
public class OrderInfo {
    private int orderID;            // Khóa chính, đồng thời là FK tới Orders.OrderID
    private String shippingName;    // Họ và tên người nhận
    private String shippingAddress; // Địa chỉ giao hàng
    private String phone;           // Số điện thoại người nhận
    private String paymentMethod;   // Phương thức thanh toán
    private Timestamp createdAt;    // Thời gian tạo bản ghi

    public OrderInfo() {}

    public OrderInfo(int orderID, String shippingName, String shippingAddress,
                     String phone, String paymentMethod, Timestamp createdAt) {
        this.orderID = orderID;
        this.shippingName = shippingName;
        this.shippingAddress = shippingAddress;
        this.phone = phone;
        this.paymentMethod = paymentMethod;
        this.createdAt = createdAt;
    }

    // Getters & setters
    public int getOrderID() {
        return orderID;
    }
    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public String getShippingName() {
        return shippingName;
    }
    public void setShippingName(String shippingName) {
        this.shippingName = shippingName;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }
    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "OrderInfo{" +
               "orderID=" + orderID +
               ", shippingName='" + shippingName + '\'' +
               ", shippingAddress='" + shippingAddress + '\'' +
               ", phone='" + phone + '\'' +
               ", paymentMethod='" + paymentMethod + '\'' +
               ", createdAt=" + createdAt +
               '}';
    }
}
