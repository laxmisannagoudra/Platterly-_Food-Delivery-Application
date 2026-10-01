package com.tap.Servlet;

import java.io.IOException;

import com.tap.DAOImpl.MenuDAOImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Menu;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		Cart cart = (Cart) session.getAttribute("cart");

		// only logged-in users can change the cart
		if (session.getAttribute("userName") == null) {
			if ("fetch".equals(req.getHeader("X-Requested-With"))) {
				resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
			} else {
				resp.sendRedirect("login.html");
			}
			return;
		}

		String action = req.getParameter("action");
		if (action == null) {
			resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}

		if (action.equals("add")) {
			int newRestaurantId = Integer.parseInt(req.getParameter("restaurantId"));

			// one cart for the whole session: items from ANY restaurant can be added
			if (cart == null) {
				cart = new Cart();
				session.setAttribute("cart", cart);
			}
			// remember the restaurant last used (cart page "Add more from this restaurant" link)
			session.setAttribute("restaurantId", newRestaurantId);

			addItemToCart(req, cart);

		} else if (action.equals("update")) {
			updateItemToCart(req, cart);

		} else {
			removeItemToCart(req, cart);
		}

		// the menu page calls this in the background (no page change needed)
		if ("fetch".equals(req.getHeader("X-Requested-With"))) {
			resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
			return;
		}

		RequestDispatcher rd = req.getRequestDispatcher("cart.jsp");
		rd.forward(req, resp);
	}

	private void addItemToCart(HttpServletRequest req, Cart cart) {

		int menuId = Integer.parseInt(req.getParameter("menuId"));
		int qty = Integer.parseInt(req.getParameter("qty"));

		CartItem existing = cart.getItems().get(menuId);

		if (existing != null) {
			// already in cart: just increase the quantity
			existing.setQty(existing.getQty() + qty);
		} else {
			MenuDAOImpl menuDAOImpl = new MenuDAOImpl();
			Menu menu = menuDAOImpl.getMenu(menuId);

			CartItem cartItem = new CartItem(menu.getMenuId(),
					menu.getRestaurantId(),
					menu.getItemName(),
					menu.getPrice(),
					qty);

			// a new item starts at exactly the quantity that was sent (1 from the ADD button)
			cart.getItems().put(menuId, cartItem);
		}
	}

	private void updateItemToCart(HttpServletRequest req, Cart cart) {
		int menuId = Integer.parseInt(req.getParameter("menuId"));
		int qty = Integer.parseInt(req.getParameter("qty"));

		if (cart == null) return;

		if (qty <= 0) {
			cart.getItems().remove(menuId);
		} else {
			CartItem cartItem = cart.getItems().get(menuId);
			if (cartItem != null) {
				cartItem.setQty(qty);
			}
		}
	}

	private void removeItemToCart(HttpServletRequest req, Cart cart) {
		if (cart == null) return;
		int menuId = Integer.parseInt(req.getParameter("menuId"));
		cart.getItems().remove(menuId);
	}
}
