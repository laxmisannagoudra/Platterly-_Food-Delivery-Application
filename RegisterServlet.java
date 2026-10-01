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

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Read form values
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String password = req.getParameter("password");
        String role = req.getParameter("role");
        
        String hashpw = BCrypt.hashpw(password,BCrypt.gensalt(12));

        // Create Register Object
        Register register = new Register(
                fullName,
                hashpw,
                email,
                phone,
                address,
                role
        );
        
        // Save User
        RegisterDAOImpl registerDAOImpl = new RegisterDAOImpl();
        int i = registerDAOImpl.addUser(register);
        
        if(i == 1) {
        	resp.sendRedirect("login.html");
        }
        else {
        	resp.sendRedirect("register.html");
        }

        

        
    }
}