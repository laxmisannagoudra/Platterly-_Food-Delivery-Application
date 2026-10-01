package com.tap.model;

public class Menu {

    private int menuId;
    private int restaurantId;
    private String itemName;
    private String description;
    private int price;
    private String imageUrl;

    // Constructor with menuId
    public Menu(int menuId, int restaurantId, String itemName,
                String description, int price, String imageUrl) {

        super();

        this.menuId = menuId;
        this.restaurantId = restaurantId;
        this.itemName = itemName;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
    }

    // Getters and Setters

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    // toString()

    @Override
    public String toString() {
        return "Menu [menuId=" + menuId
                + ", restaurantId=" + restaurantId
                + ", itemName=" + itemName
                + ", description=" + description
                + ", price=" + price
                + ", imageUrl=" + imageUrl + "]";
    }

    // Constructor without menuId
    public Menu(int restaurantId, String itemName,
                String description, int price, String imageUrl) {

        super();

        this.restaurantId = restaurantId;
        this.itemName = itemName;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
    }
}