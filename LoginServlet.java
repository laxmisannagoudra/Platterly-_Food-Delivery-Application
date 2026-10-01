package com.tap.Servlet;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.DAOImpl.RegisterDAOImpl;
import com.tap.model.Register;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({"/LoginServlet", "/logout"})
public class LoginServlet extends HttpServlet {

    // GET /logout  ->  end the session and go back to the home page
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();   // also clears the cart
        }
        resp.sendRedirect("home.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        RegisterDAOImpl registerDAOImpl = new RegisterDAOImpl();
        Register register = registerDAOImpl.getUserByEmail(email);

        if (register != null && BCrypt.checkpw(password, register.getPassword())) {

            HttpSession session = req.getSession();
            session.setAttribute("user", register);

            // the name shown in the top menu next to the user icon
            // (if your Register class uses another getter, e.g. getUsername(), change it here)
            session.setAttribute("userName", register.getFullName());

            // go back to the page the user wanted (e.g. a restaurant menu), else the restaurant list
            String next = (String) session.getAttribute("afterLogin");
            session.removeAttribute("afterLogin");
            resp.sendRedirect(next != null ? next : "restaurant");
        } else {
            resp.sendRedirect("login.html");
        }
    }
}
