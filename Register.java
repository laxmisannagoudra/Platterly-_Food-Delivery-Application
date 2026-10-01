package com.tap.model;
import java.sql.Timestamp;


public class Register {
	private int userId;
    private String fullName;
    private String email;
    private String phone;
    private String address;
    private String password;
    private String role;
    private Timestamp createdDate;
    
    public Register() {

    }
    public Register(String fullName,
            String password,
            String email,
            String phone,
            String address,
            String role) {

this.fullName = fullName;
this.password = password;
this.email = email;
this.phone = phone;
this.address = address;
this.role = role;
}
    
	public Register(String fullName, String email, String phone, String address, String password, String role,
			Timestamp createdDate) {
		super();
		this.fullName = fullName;
		this.email = email;
		this.phone = phone;
		this.address = address;
		this.password = password;
		this.role = role;
		this.createdDate = createdDate;
	}


	public int getUserId() {
		return userId;
	}


	public void setUserId(int userId) {
		this.userId = userId;
	}


	public String getFullName() {
		return fullName;
	}


	public void setFullName(String fullName) {
		this.fullName = fullName;
	}


	public String getEmail() {
		return email;
	}


	public void setEmail(String email) {
		this.email = email;
	}


	public String getPhone() {
		return phone;
	}


	public void setPhone(String phone) {
		this.phone = phone;
	}


	public String getAddress() {
		return address;
	}


	public void setAddress(String address) {
		this.address = address;
	}


	public String getPassword() {
		return password;
	}


	public void setPassword(String password) {
		this.password = password;
	}


	public String getRole() {
		return role;
	}


	public void setRole(String role) {
		this.role = role;
	}


	public Timestamp getCreatedDate() {
		return createdDate;
	}


	public void setCreatedDate(Timestamp createdDate) {
		this.createdDate = createdDate;
	}


	@Override
	public String toString() {
		return "Register [userId=" + userId + ", fullName=" + fullName + ", email=" + email + ", phone=" + phone
				+ ", address=" + address + ", password=" + password + ", role=" + role + "]";
	}


	public Register(int userId, String fullName, String email, String phone, String address, String password,
			String role, Timestamp createdDate) {
		super();
		this.userId = userId;
		this.fullName = fullName;
		this.email = email;
		this.phone = phone;
		this.address = address;
		this.password = password;
		this.role = role;
		this.createdDate = createdDate;
	}
	
    
    


}
