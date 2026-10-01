package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.RestaurantDAO;
import com.tap.Utility.DBConnection;
import com.tap.model.Restaurant;

public class RestaurantDAOImpl implements RestaurantDAO {

    private static final String INSERT_QUERY =
            "INSERT INTO restaurant "
            + "(name, cuisine, address, rating, imageUrl, deliveryTime, isActive, adminUserId) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String GET_QUERY =
            "SELECT * FROM restaurant WHERE restaurantId = ?";

    private static final String GET_ALL_QUERY =
            "SELECT * FROM restaurant";

    private static final String UPDATE_QUERY =
            "UPDATE restaurant SET name=?, cuisine=?, address=?, rating=?, imageUrl=?, "
            + "deliveryTime=?, isActive=?, adminUserId=? WHERE restaurantId=?";

    private static final String DELETE_QUERY =
            "DELETE FROM restaurant WHERE restaurantId = ?";

    @Override
    public void addRestaurant(Restaurant restaurant) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(INSERT_QUERY)) {

            pstm.setString(1, restaurant.getName());
            pstm.setString(2, restaurant.getCuisine());
            pstm.setString(3, restaurant.getAddress());
            pstm.setDouble(4, restaurant.getRating());
            pstm.setString(5, restaurant.getImageUrl());
            pstm.setString(6, restaurant.getDeliveryTime());
            pstm.setBoolean(7, restaurant.isActive());
            pstm.setInt(8, restaurant.getAdminUserId());

            int i = pstm.executeUpdate();
            System.out.println(i + " Restaurant Added Successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Restaurant getRestaurant(int restaurantId) {
        Restaurant restaurant = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(GET_QUERY)) {

            pstm.setInt(1, restaurantId);

            try (ResultSet rs = pstm.executeQuery()) {
                while (rs.next()) {
                    restaurant = mapResultSetToRestaurant(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurant;
    }

    @Override
    public void updateRestaurant(Restaurant restaurant) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(UPDATE_QUERY)) {

            pstm.setString(1, restaurant.getName());
            pstm.setString(2, restaurant.getCuisine());
            pstm.setString(3, restaurant.getAddress());
            pstm.setDouble(4, restaurant.getRating());
            pstm.setString(5, restaurant.getImageUrl());
            pstm.setString(6, restaurant.getDeliveryTime());
            pstm.setBoolean(7, restaurant.isActive());
            pstm.setInt(8, restaurant.getAdminUserId());
            pstm.setInt(9, restaurant.getRestaurantId());

            int i = pstm.executeUpdate();
            System.out.println(i + " Restaurant Updated Successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteRestaurant(int restaurantId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(DELETE_QUERY)) {

            pstm.setInt(1, restaurantId);

            int i = pstm.executeUpdate();
            System.out.println(i + " Restaurant Deleted Successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> restaurants = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(GET_ALL_QUERY);
             ResultSet rs = pstm.executeQuery()) {

            while (rs.next()) {
                restaurants.add(mapResultSetToRestaurant(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }

    private Restaurant mapResultSetToRestaurant(ResultSet rs) throws SQLException {
        int id = rs.getInt("restaurantId");
        String name = rs.getString("name");
        String cuisine = rs.getString("cuisine");
        String address = rs.getString("address");
        double rating = rs.getDouble("rating");
        String imageUrl = rs.getString("imageUrl");
        String deliveryTime = rs.getString("deliveryTime");
        boolean isActive = rs.getBoolean("isActive");
        int adminUserId = rs.getInt("adminUserId");

        return new Restaurant(id, name, cuisine, address, rating, imageUrl, deliveryTime, isActive, adminUserId);
    }
}
