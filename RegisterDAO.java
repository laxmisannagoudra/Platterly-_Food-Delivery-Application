package com.tap.DAO;

import java.util.List;

import com.tap.model.Register;

public interface RegisterDAO {
	int addUser(Register register);

    Register getUser(int userId);

    Register getUserByEmail(String email);
    
    Register getUserByname(String name);
    

    List<Register> getAllUsers();

    void updateUser(Register register);

    void deleteUser(int userId);

}
