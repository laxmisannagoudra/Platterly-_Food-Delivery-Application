<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.DecimalFormat, com.tap.model.CartItem, com.tap.model.Cart"%>
<%@ page import="com.tap.model.Menu, com.tap.DAOImpl.MenuDAOImpl"%>
<%
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    Cart cart = (Cart) session.getAttribute("cart");
    Map<Integer, CartItem> items = (cart != null) ? cart.getItems() : null;
    boolean empty = (cart == null || items == null || items.isEmpty());

    DecimalFormat money = new DecimalFormat("#,##0.##");
    double grandTotal = 0;
    int totalQty = 0;
    if (!empty) {
        for (CartItem ci : items.values()) {
            grandTotal += ci.getTotalPrice();
            totalQty += ci.getQty();
        }
    }
    Object rid = session.getAttribute("restaurantId");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Platterly - My Cart</title>
<style>
    :root { --orange:#ff6b00; --orange-dark:#e85d00; --ink:#1f1b16; --soft:#6b6058; --line:#ede7de; --green:#0a8a3f; }
    * { margin:0; padding:0; box-sizing:border-box; font-family:'Segoe UI', Arial, sans-serif; }
    body { background:#f6f3ee; color:var(--ink); }
    a { text-decoration:none; color:inherit; }

    /* nav */
    nav { background:#fff; height:70px; display:flex; align-items:center; justify-content:space-between;
        padding:0 max(5%, calc((100% - 1200px) / 2)); box-shadow:0 2px 8px rgba(0,0,0,0.08); }
    .logo { font-size:30px; font-weight:800; color:var(--orange); letter-spacing:-0.5px; }
    .nav-links { display:flex; gap:28px; }
    .nav-links a { font-weight:600; color:#333; font-size:15px; }
    .nav-links a:hover, .nav-links a.active { color:var(--orange); }

    .wrap { width:92%; max-width:1100px; margin:34px auto 60px; }
    .head { display:flex; align-items:baseline; justify-content:space-between; flex-wrap:wrap; gap:8px; margin-bottom:22px; }
    .head h1 { font-size:32px; letter-spacing:-0.5px; }
    .head span { color:var(--soft); font-size:15px; }

    .layout { display:grid; grid-template-columns:1fr 340px; gap:24px; align-items:start; }

    /* item cards */
    .item { background:#fff; border-radius:18px; padding:16px; margin-bottom:14px; display:flex; align-items:center; gap:18px;
        box-shadow:0 2px 12px rgba(31,27,22,0.06); transition:box-shadow .2s, transform .2s; }
    .item:hover { box-shadow:0 12px 28px -14px rgba(31,27,22,0.3); transform:translateY(-2px); }
    .thumb { width:96px; height:96px; border-radius:14px; object-fit:cover; flex:0 0 96px; background:#efe9e1; }
    .thumb.noimg { display:flex; align-items:center; justify-content:center; font-size:34px; }
    .info { flex:1; min-width:0; }
    .info h3 { font-size:18px; margin-bottom:4px; }
    .info .each { color:var(--soft); font-size:14px; margin-bottom:12px; }

    .stepper { display:inline-flex; align-items:center; background:var(--orange); border-radius:10px; overflow:hidden; }
    .stepper form { display:flex; align-items:center; }
    .stepper button { background:transparent; color:#fff; border:none; width:36px; height:36px; font-size:20px; font-weight:800; cursor:pointer; }
    .stepper button:hover { background:rgba(0,0,0,0.15); }
    .stepper .q { min-width:30px; text-align:center; color:#fff; font-weight:800; font-size:15px; }

    .side { text-align:right; display:flex; flex-direction:column; align-items:flex-end; gap:14px; }
    .line-total { font-size:20px; font-weight:800; }

    /* summary */
    .summary { background:#fff; border-radius:18px; padding:22px; box-shadow:0 2px 12px rgba(31,27,22,0.06);
        position:sticky; top:20px; }
    .summary h2 { font-size:19px; margin-bottom:16px; }
    .srow { display:flex; justify-content:space-between; padding:8px 0; color:var(--soft); font-size:15px; }
    .stotal { display:flex; justify-content:space-between; padding:16px 0 4px; margin-top:8px; border-top:1px dashed var(--line);
        font-size:20px; font-weight:800; color:var(--ink); }
    .checkout { display:block; text-align:center; margin-top:18px; background:var(--green); color:#fff; font-weight:800;
        padding:15px; border-radius:12px; font-size:16px; transition:filter .2s, transform .2s; }
    .checkout:hover { filter:brightness(1.08); transform:translateY(-1px); }
    .more { display:flex; flex-direction:column; gap:8px; margin-top:16px; padding-top:16px; border-top:1px solid var(--line); }
    .more a { color:var(--orange); font-weight:700; font-size:14.5px; }
    .more a:hover { text-decoration:underline; }

    /* empty */
    .empty { background:#fff; border-radius:20px; text-align:center; padding:70px 20px; box-shadow:0 2px 12px rgba(31,27,22,0.06); }
    .empty .em { font-size:64px; margin-bottom:12px; }
    .empty h2 { margin-bottom:8px; }
    .empty p { color:var(--soft); margin-bottom:24px; }
    .empty a { background:var(--orange); color:#fff; font-weight:800; padding:13px 30px; border-radius:12px; }

    @media (max-width:860px) {
        .layout { grid-template-columns:1fr; }
        .summary { position:static; }
    }
    @media (max-width:560px) {
        .nav-links a:not(.active):not(.keep) { display:none; }
        .item { flex-wrap:wrap; }
        .thumb { width:72px; height:72px; flex-basis:72px; }
        .side { flex-direction:row; width:100%; justify-content:space-between; align-items:center; }
    }
</style>
</head>
<body>

<nav>
    <a href="<%= ctx %>/home.jsp" class="logo">Platterly</a>
    <div class="nav-links">
        <a href="<%= ctx %>/home.jsp">Home</a>
        <a href="<%= ctx %>/restaurant">Restaurants</a>
        <a href="<%= ctx %>/myorders">My Orders</a>
        <a href="<%= ctx %>/cart.jsp" class="active keep">&#128722; Cart</a>
        <%
    // shows "Login" when logged out, or a user icon + name dropdown when logged in
    String _umName = (String) session.getAttribute("userName");
    String _umCtx = request.getContextPath();
    if (_umName != null) {
        _umName = _umName.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }
%>
<style>
    .um { position:relative; display:inline-block; }
    .um-btn { display:inline-flex; align-items:center; gap:8px; background:rgba(255,107,0,0.12); color:inherit;
        border:1px solid rgba(255,107,0,0.5); border-radius:999px; padding:6px 14px 6px 8px; font:inherit;
        font-weight:700; font-size:15px; cursor:pointer; }
    .um-avatar { width:28px; height:28px; border-radius:50%; background:#ff6b00; color:#fff; display:inline-flex;
        align-items:center; justify-content:center; font-size:15px; }
    .um-drop { display:none; position:absolute; right:0; top:100%; padding-top:8px; min-width:170px; z-index:100; }
    .um-drop-in { background:#fff; border-radius:12px; box-shadow:0 14px 34px rgba(0,0,0,0.25); overflow:hidden; }
    .um:hover .um-drop, .um:focus-within .um-drop { display:block; }
    .um-drop a { display:block; padding:12px 18px; color:#1f1b16 !important; opacity:1 !important; font-weight:600;
        font-size:14.5px; text-decoration:none !important; }
    .um-drop a:hover { background:#fff3e8; color:#ff6b00 !important; }
</style>
<% if (_umName != null) { %>
    <div class="um">
        <button type="button" class="um-btn" aria-haspopup="true">
            <span class="um-avatar">&#128100;</span><span><%= _umName %></span> &#9662;
        </button>
        <div class="um-drop"><div class="um-drop-in">
            <a href="<%= _umCtx %>/myorders">My Orders</a>
            <a href="<%= _umCtx %>/logout">Logout</a>
        </div></div>
    </div>
<% } else { %>
    <a href="<%= _umCtx %>/register.html">Login</a>
<% } %>
    </div>
</nav>

<div class="wrap">

<% if (empty) { %>

    <div class="empty">
        <div class="em">&#128722;</div>
        <h2>Your cart is empty</h2>
        <p>Add something delicious from a restaurant near you.</p>
        <a href="<%= ctx %>/restaurant">Browse restaurants</a>
    </div>

<% } else { %>

    <div class="head">
        <h1>My Cart</h1>
        <span><%= totalQty %> <%= totalQty == 1 ? "item" : "items" %></span>
    </div>

    <div class="layout">

        <div class="list">
        <% for (CartItem item : items.values()) {
               String imgUrl = null;
               try {
                   Menu m = new MenuDAOImpl().getMenu(item.getMenuId());
                   if (m != null) imgUrl = m.getImageUrl();
               } catch (Exception e) { }
        %>
            <div class="item">

                <% if (imgUrl != null && !imgUrl.isEmpty()) { %>
                    <img class="thumb" src="<%= imgUrl %>" alt="<%= item.getName() %>">
                <% } else { %>
                    <span class="thumb noimg">&#127869;</span>
                <% } %>

                <div class="info">
                    <h3><%= item.getName() %></h3>
                    <div class="each">&#8377;<%= money.format(item.getPrice()) %> each</div>

                    <div class="stepper">
                        <form action="CartServlet" method="post">
                            <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                            <input type="hidden" name="action" value="update">
                            <button type="submit" name="qty" value="<%= item.getQty() - 1 %>" aria-label="Decrease">&minus;</button>
                            <span class="q"><%= item.getQty() %></span>
                            <button type="submit" name="qty" value="<%= item.getQty() + 1 %>" aria-label="Increase">+</button>
                        </form>
                    </div>
                </div>

                <div class="side">
                    <div class="line-total">&#8377;<%= money.format(item.getTotalPrice()) %></div>
                </div>

            </div>
        <% } %>
        </div>

        <aside class="summary">
            <h2>Order summary</h2>
            <div class="srow"><span>Items (<%= totalQty %>)</span><span>&#8377;<%= money.format(grandTotal) %></span></div>
            <div class="stotal"><span>Grand Total</span><span>&#8377;<%= money.format(grandTotal) %></span></div>

            <a href="CheckoutServlet" class="checkout">Proceed to Checkout &rarr;</a>

            <div class="more">
                <% if (rid != null) { %>
                    <a href="<%= ctx %>/menu?restaurantId=<%= rid %>">+ Add more from this restaurant</a>
                <% } %>
                <a href="<%= ctx %>/restaurant">+ Add from other restaurants</a>
            </div>
        </aside>

    </div>

<% } %>

</div>

</body>
</html>
