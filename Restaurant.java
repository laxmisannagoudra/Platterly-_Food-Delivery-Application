package com.tap.model;

public class Restaurant {

    private int restaurantId;
    private String name;
    private String cuisine;
    private String address;
    private double rating;
    private String imageUrl;
    private String deliveryTime;
    private boolean isActive;
    private int adminUserId;

    // Constructor without restaurantId (used before insert)
    public Restaurant(String name, String cuisine, String address, double rating,
                       String imageUrl, String deliveryTime, boolean isActive, int adminUserId) {
        this.name = name;
        this.cuisine = cuisine;
        this.address = address;
        this.rating = rating;
        this.imageUrl = imageUrl;
        this.deliveryTime = deliveryTime;
        this.isActive = isActive;
        this.adminUserId = adminUserId;
    }

    // Constructor with restaurantId (used when reading from DB)
    public Restaurant(int restaurantId, String name, String cuisine, String address, double rating,
                       String imageUrl, String deliveryTime, boolean isActive, int adminUserId) {
        this.restaurantId = restaurantId;
        this.name = name;
        this.cuisine = cuisine;
        this.address = address;
        this.rating = rating;
        this.imageUrl = imageUrl;
        this.deliveryTime = deliveryTime;
        this.isActive = isActive;
        this.adminUserId = adminUserId;
    }

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCuisine() { return cuisine; }
    public void setCuisine(String cuisine) { this.cuisine = cuisine; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getDeliveryTime() { return deliveryTime; }
    public void setDeliveryTime(String deliveryTime) { this.deliveryTime = deliveryTime; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public int getAdminUserId() { return adminUserId; }
    public void setAdminUserId(int adminUserId) { this.adminUserId = adminUserId; }

    @Override
    public String toString() {
        return "Restaurant{" +
                "restaurantId=" + restaurantId +
                ", name='" + name + '\'' +
                ", cuisine='" + cuisine + '\'' +
                ", address='" + address + '\'' +
                ", rating=" + rating +
                ", imageUrl='" + imageUrl + '\'' +
                ", deliveryTime='" + deliveryTime + '\'' +
                ", isActive=" + isActive +
                ", adminUserId=" + adminUserId +
                '}';
    }
}