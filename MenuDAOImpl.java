package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.MenuDAO;
import com.tap.Utility.DBConnection;
import com.tap.model.Menu;

public class MenuDAOImpl implements MenuDAO {

    private static final String INSERT_QUERY =
            "INSERT INTO menu "
            + "(restaurantId, itemName, description, price, imageUrl) "
            + "VALUES (?, ?, ?, ?, ?)";

    private static final String GET_QUERY =
            "SELECT * FROM menu WHERE menuId = ?";

    private static final String GET_ALL_QUERY =
            "SELECT * FROM menu";

    private static final String GET_BY_RESTAURANT_QUERY =
            "SELECT * FROM menu WHERE restaurantId = ?";

    private static final String UPDATE_QUERY =
            "UPDATE menu SET restaurantId=?, itemName=?, description=?, price=?, imageUrl=? WHERE menuId=?";

    private static final String DELETE_QUERY =
            "DELETE FROM menu WHERE menuId = ?";

    @Override
    public void addMenu(Menu menu) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(INSERT_QUERY)) {

            pstm.setInt(1, menu.getRestaurantId());
            pstm.setString(2, menu.getItemName());
            pstm.setString(3, menu.getDescription());
            pstm.setInt(4, menu.getPrice());
            pstm.setString(5, menu.getImageUrl());

            int i = pstm.executeUpdate();
            System.out.println(i + " Menu Added Successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Menu getMenu(int menuId) {
        Menu menu = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(GET_QUERY)) {

            pstm.setInt(1, menuId);

            try (ResultSet rs = pstm.executeQuery()) {
                while (rs.next()) {
                    menu = mapResultSetToMenu(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menu;
    }

    @Override
    public void updateMenu(Menu menu) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(UPDATE_QUERY)) {

            pstm.setInt(1, menu.getRestaurantId());
            pstm.setString(2, menu.getItemName());
            pstm.setString(3, menu.getDescription());
            pstm.setInt(4, menu.getPrice());
            pstm.setString(5, menu.getImageUrl());
            pstm.setInt(6, menu.getMenuId());

            int i = pstm.executeUpdate();
            System.out.println(i + " Menu Updated Successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteMenu(int menuId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(DELETE_QUERY)) {

            pstm.setInt(1, menuId);

            int i = pstm.executeUpdate();
            System.out.println(i + " Menu Deleted Successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Menu> getAllMenus() {
        List<Menu> menus = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(GET_ALL_QUERY);
             ResultSet rs = pstm.executeQuery()) {

            while (rs.next()) {
                menus.add(mapResultSetToMenu(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }

    @Override
    public List<Menu> getMenusByRestaurant(int restaurantId) {
        List<Menu> menus = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(GET_BY_RESTAURANT_QUERY)) {

            pstm.setInt(1, restaurantId);

            try (ResultSet rs = pstm.executeQuery()) {
                while (rs.next()) {
                    menus.add(mapResultSetToMenu(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }

    private Menu mapResultSetToMenu(ResultSet rs) throws SQLException {
        int menuId = rs.getInt("menuId");
        int restaurantId = rs.getInt("restaurantId");
        String itemName = rs.getString("itemName");
        String description = rs.getString("description");
        int price = rs.getInt("price");
        String imageUrl = rs.getString("imageUrl");

        return new Menu(menuId, restaurantId, itemName, description, price, imageUrl);
    }
}