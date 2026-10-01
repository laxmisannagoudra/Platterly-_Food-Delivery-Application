package com.tap.model;

import java.sql.Timestamp;

public class Order {
    private int orderId;
    private int restaurantId;
    private String address;
    private String paymentMethod;
    private double totalAmount;
    private Timestamp orderDate;
    private String status;

    public Order() {}

    public Order(int restaurantId, String address, String paymentMethod, double totalAmount) {
        this.restaurantId = restaurantId;
        this.address = address;
        this.paymentMethod = paymentMethod;
        this.totalAmount = totalAmount;
    }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
