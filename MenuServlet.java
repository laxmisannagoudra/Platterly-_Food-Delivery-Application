package com.tap.Servlet;

import java.io.IOException;
import java.util.List;

import com.tap.DAOImpl.MenuDAOImpl;
import com.tap.DAOImpl.RestaurantDAOImpl;
import com.tap.model.Menu;
import com.tap.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        MenuDAOImpl menuDAOImpl = new MenuDAOImpl();
        RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();

        String restaurantIdParam = req.getParameter("restaurantId");

        int restaurantId = 1;

        if (restaurantIdParam != null) {
            restaurantId = Integer.parseInt(restaurantIdParam);
        }

        List<Menu> allMenusByRestaurant =
                menuDAOImpl.getMenusByRestaurant(restaurantId);

        for (Menu menu : allMenusByRestaurant) {
            System.out.println(menu);
        }

        // the clicked restaurant (name, image, rating...) for the hero section
        Restaurant restaurant = restaurantDAO.getRestaurant(restaurantId);

        req.setAttribute("restaurant", restaurant);
        req.setAttribute("allMenusByRestaurant", allMenusByRestaurant);

        RequestDispatcher rd = req.getRequestDispatcher("menu.jsp");
        rd.forward(req, resp);
    }
}