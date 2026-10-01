package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.RegisterDAO;
import com.tap.Utility.DBConnection;
import com.tap.model.Register;

public class RegisterDAOImpl implements RegisterDAO {

    private static final String INSERT_QUERY =
            "INSERT INTO register(fullName,email,phone,address,password,role) VALUES(?,?,?,?,?,?)";

    private static final String GET_QUERY =
            "SELECT * FROM  register WHERE userId=?";

    private static final String GET_ALL_QUERY =
            "SELECT * FROM register";

    private static final String GET_BY_EMAIL_QUERY =
            "SELECT * FROM register WHERE email=?";

    private static final String UPDATE_QUERY =
            "UPDATE register SET fullName=?,email=?,phone=?,address=?,password=?,role=? WHERE userId=?";

    private static final String DELETE_QUERY =
            "DELETE FROM register WHERE userId=?";

    @Override
    public int addUser(Register register) {
    	int i = 0;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(INSERT_QUERY)) {

            pstm.setString(1, register.getFullName());
            pstm.setString(2, register.getEmail());
            pstm.setString(3, register.getPhone());
            pstm.setString(4, register.getAddress());
            pstm.setString(5, register.getPassword());
            pstm.setString(6, register.getRole());

             i = pstm.executeUpdate();
            System.out.println(i + " User Registered Successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return i;
    }

    @Override
    public Register getUser(int userId) {

        Register register = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(GET_QUERY)) {

            pstm.setInt(1, userId);

            try (ResultSet rs = pstm.executeQuery()) {

                while (rs.next()) {
                    register = mapResultSetToRegister(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return register;
    }

    @Override
    public Register getUserByEmail(String email) {

        Register register = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(GET_BY_EMAIL_QUERY)) {

            pstm.setString(1, email);

            try (ResultSet rs = pstm.executeQuery()) {

                while (rs.next()) {
                    register = mapResultSetToRegister(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return register;
    }

    @Override
    public List<Register> getAllUsers() {

        List<Register> users = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(GET_ALL_QUERY);
             ResultSet rs = pstm.executeQuery()) {

            while (rs.next()) {
                users.add(mapResultSetToRegister(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }

    @Override
    public void updateUser(Register register) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(UPDATE_QUERY)) {

            pstm.setString(1, register.getFullName());
            pstm.setString(2, register.getEmail());
            pstm.setString(3, register.getPhone());
            pstm.setString(4, register.getAddress());
            pstm.setString(5, register.getPassword());
            pstm.setString(6, register.getRole());
            pstm.setInt(7, register.getUserId());

            int i = pstm.executeUpdate();
            System.out.println(i + " User Updated Successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteUser(int userId) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(DELETE_QUERY)) {

            pstm.setInt(1, userId);

            int i = pstm.executeUpdate();
            System.out.println(i + " User Deleted Successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Register mapResultSetToRegister(ResultSet rs) throws SQLException {

        int userId = rs.getInt("userId");
        String fullName = rs.getString("fullName");
        String email = rs.getString("email");
        String phone = rs.getString("phone");
        String address = rs.getString("address");
        String password = rs.getString("password");
        String role = rs.getString("role");
        java.sql.Timestamp createdDate = rs.getTimestamp("createdDate");

        return new Register(userId, fullName, email, phone, address,
                password, role, createdDate);
    }
}