package com.tap.Servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


import com.tap.DAOImpl.OrderDAOImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Order;
import com.tap.model.OrderItem;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getItems().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart.jsp");
            return;
        }

        RequestDispatcher rd = req.getRequestDispatcher("checkout.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");

        if (cart == null || cart.getItems().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart.jsp");
            return;
        }

        String address = req.getParameter("address");
        String paymentMethod = req.getParameter("paymentMethod");

        double total = 0;
        List<OrderItem> orderItems = new ArrayList<>();

        for (CartItem ci : cart.getItems().values()) {
            total += ci.getTotalPrice();
            orderItems.add(new OrderItem(ci.getMenuId(), ci.getName(), ci.getPrice(), ci.getQty()));
        }

        Order order = new Order(restaurantId, address, paymentMethod, total);

        OrderDAOImpl orderDAOImpl = new OrderDAOImpl();
        int orderId = orderDAOImpl.placeOrder(order, orderItems);

        if (orderId == -1) {
            req.setAttribute("error", "Something went wrong while placing your order. Please try again.");
            RequestDispatcher rd = req.getRequestDispatcher("checkout.jsp");
            rd.forward(req, resp);
            return;
        }

        // clear cart after successful order
        session.removeAttribute("cart");
        session.removeAttribute("restaurantId");

        req.setAttribute("orderId", orderId);
        req.setAttribute("totalAmount", total);
        req.setAttribute("paymentMethod", paymentMethod);

        RequestDispatcher rd = req.getRequestDispatcher("orderConfirmation.jsp");
        rd.forward(req, resp);
    }
}
