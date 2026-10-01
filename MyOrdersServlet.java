package com.tap.Servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.DAOImpl.OrderDAOImpl;
import com.tap.model.Order;
import com.tap.model.OrderItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/myorders")
public class MyOrdersServlet extends HttpServlet {

	private static final int PAGE = 10;   // orders shown at a time

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		int limit = PAGE;
		try {
			limit = Math.max(PAGE, Integer.parseInt(req.getParameter("limit")));
		} catch (Exception ignored) { }

		OrderDAOImpl dao = new OrderDAOImpl();

		// ask for one extra so we know whether a "Show more" button is needed
		List<Order> orders = dao.getRecentOrders(limit + 1);
		boolean hasMore = orders.size() > limit;
		if (hasMore) {
			orders = orders.subList(0, limit);
		}

		Map<Integer, List<OrderItem>> orderItems = new HashMap<>();
		for (Order o : orders) {
			orderItems.put(o.getOrderId(), dao.getOrderItems(o.getOrderId()));
		}

		req.setAttribute("orders", orders);
		req.setAttribute("orderItems", orderItems);
		req.setAttribute("hasMore", hasMore);
		req.setAttribute("nextLimit", limit + PAGE);

		req.getRequestDispatcher("myorders.jsp").forward(req, resp);
	}
}

