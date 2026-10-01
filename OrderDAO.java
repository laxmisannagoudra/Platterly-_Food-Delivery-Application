package com.tap.DAO;

import java.util.List;
import com.tap.model.Order;
import com.tap.model.OrderItem;

public interface OrderDAO {
    int placeOrder(Order order, List<OrderItem> items);

    // newest orders first
    List<Order> getRecentOrders(int limit);

    List<OrderItem> getOrderItems(int orderId);
}
