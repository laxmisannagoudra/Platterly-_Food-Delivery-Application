package com.tap.DAO;

import java.util.List;

import com.tap.model.Menu;
import com.tap.model.Restaurant;

public interface MenuDAO {
	void addMenu(Menu menu);
    Menu getMenu(int MenuId);
    void updateMenu(Menu manu);
    void deleteMenu(int MenuId);
    List<Menu> getAllMenus();
    List<Menu> getMenusByRestaurant(int restaurantId);
    

}
