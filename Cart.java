package com.tap.model;

import java.util.HashMap;
import java.util.Map;

public class Cart {
	
	Map<Integer,CartItem>items;
	
	public Cart() {
		
		items = new HashMap<Integer,CartItem>();
	}

	public Map<Integer, CartItem> getItems() {
		return items;
	}

	public void addItem(CartItem cartItem) {
		
	int menuId	 = cartItem.getMenuId();
	
	items.put(menuId, cartItem);
	
	if(items.containsKey(menuId)) {
		CartItem existingCartItem = items.get(menuId);
		
		existingCartItem. setQty(existingCartItem.getQty()+1);
	}
	else {
		
		items.put(menuId, cartItem);
	}
		
		
	}

	
	

}
