package com.tap.model;

public class OrderItem {
    private int orderItemId;
    private int orderId;
    private int menuId;
    private String itemName;
    private double price;
    private int qty;

    public OrderItem() {}

    public OrderItem(int menuId, String itemName, double price, int qty) {
        this.menuId = menuId;
        this.itemName = itemName;
        this.price = price;
        this.qty = qty;
    }

    public int getOrderItemId() { return orderItemId; }
    public void setOrderItemId(int orderItemId) { this.orderItemId = orderItemId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getMenuId() { return menuId; }
    public void setMenuId(int menuId) { this.menuId = menuId; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getQty() { return qty; }
    public void setQty(int qty) { this.qty = qty; }

    public double getTotalPrice() { return price * qty; }
}
