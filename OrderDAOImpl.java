package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.OrderDAO;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.Utility.DBConnection;   // ⚠️ replace with your actual DB connection class

public class OrderDAOImpl implements OrderDAO {

	@Override
	public int placeOrder(Order order, List<OrderItem> items) {
	    String orderSql = "INSERT INTO orders (restaurantId, address, paymentMethod, totalAmount) VALUES (?, ?, ?, ?)";
	    String itemSql = "INSERT INTO orderItems (orderId, menuId, itemName, price, qty) VALUES (?, ?, ?, ?, ?)";

	    int generatedOrderId = -1;

	    try (Connection con = DBConnection.getConnection()) {

	        // TEMPORARY DEBUG — remove after we find the issue
	        System.out.println("Connected to: " + con.getMetaData().getURL());
	        System.out.println("Catalog: " + con.getCatalog());

	        con.setAutoCommit(false);

	        try (PreparedStatement ps = con.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
	            ps.setInt(1, order.getRestaurantId());
	            ps.setString(2, order.getAddress());
	            ps.setString(3, order.getPaymentMethod());
	            ps.setDouble(4, order.getTotalAmount());
	            ps.executeUpdate();

	            try (ResultSet rs = ps.getGeneratedKeys()) {
	                if (rs.next()) {
	                    generatedOrderId = rs.getInt(1);
	                }
	            }
	        }

	        try (PreparedStatement ps = con.prepareStatement(itemSql)) {
	            for (OrderItem item : items) {
	                ps.setInt(1, generatedOrderId);
	                ps.setInt(2, item.getMenuId());
	                ps.setString(3, item.getItemName());
	                ps.setDouble(4, item.getPrice());
	                ps.setInt(5, item.getQty());
	                ps.addBatch();
	            }
	            ps.executeBatch();
	        }

	        con.commit();

	    } catch (Exception e) {
	        e.printStackTrace();
	        generatedOrderId = -1;
	    }

	    return generatedOrderId;
	}

	@Override
	public List<Order> getRecentOrders(int limit) {
	    List<Order> orders = new ArrayList<>();
	    String sql = "SELECT orderId, restaurantId, address, paymentMethod, totalAmount, orderDate, status "
	               + "FROM orders ORDER BY orderId DESC LIMIT ?";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setInt(1, limit);

	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                Order o = new Order();
	                o.setOrderId(rs.getInt("orderId"));
	                o.setRestaurantId(rs.getInt("restaurantId"));
	                o.setAddress(rs.getString("address"));
	                o.setPaymentMethod(rs.getString("paymentMethod"));
	                o.setTotalAmount(rs.getDouble("totalAmount"));
	                o.setOrderDate(rs.getTimestamp("orderDate"));
	                o.setStatus(rs.getString("status"));
	                orders.add(o);
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return orders;
	}

	@Override
	public List<OrderItem> getOrderItems(int orderId) {
	    List<OrderItem> items = new ArrayList<>();
	    String sql = "SELECT menuId, itemName, price, qty FROM orderItems WHERE orderId = ?";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setInt(1, orderId);

	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                OrderItem it = new OrderItem(
	                        rs.getInt("menuId"),
	                        rs.getString("itemName"),
	                        rs.getDouble("price"),
	                        rs.getInt("qty"));
	                it.setOrderId(orderId);
	                items.add(it);
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return items;
	}
}