<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat, com.tap.model.Order, com.tap.model.OrderItem"%>
<%
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    List<Order> orders = (List<Order>) request.getAttribute("orders");
    Map<Integer, List<OrderItem>> orderItems = (Map<Integer, List<OrderItem>>) request.getAttribute("orderItems");
    Boolean hasMore = (Boolean) request.getAttribute("hasMore");
    Integer nextLimit = (Integer) request.getAttribute("nextLimit");
    SimpleDateFormat fmt = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Platterly - My Orders</title>
<style>
    * { margin:0; padding:0; box-sizing:border-box; font-family:Arial, sans-serif; }
    body { background:#f5f5f5; color:#1f1b16; }

    nav { background:#fff; height:70px; display:flex; align-items:center; justify-content:space-between;
        padding:0 max(5%, calc((100% - 1200px) / 2)); box-shadow:0 2px 8px rgba(0,0,0,0.1); }
    .logo { font-size:30px; font-weight:bold; color:#ff6b00; text-decoration:none; }
    .nav-links { display:flex; gap:30px; }
    .nav-links a { text-decoration:none; color:#333; font-weight:bold; }
    .nav-links a:hover, .nav-links a.active { color:#ff6b00; }

    .wrap { width:90%; max-width:860px; margin:40px auto 60px; }
    h1 { font-size:32px; margin-bottom:6px; }
    .sub { color:#777; margin-bottom:26px; }

    .order { background:#fff; border-radius:14px; box-shadow:0 2px 10px rgba(31,27,22,0.08);
        padding:20px 22px; margin-bottom:18px; border:1px solid transparent; }
    .order.latest { border-color:#ff6b00; }
    .top { display:flex; justify-content:space-between; align-items:flex-start; gap:12px; flex-wrap:wrap; }
    .oid { font-weight:800; font-size:17px; }
    .date { color:#777; font-size:13.5px; margin-top:3px; }
    .tags { display:flex; gap:8px; align-items:center; }
    .tag { font-size:12px; font-weight:bold; padding:4px 11px; border-radius:20px; background:#eee; color:#555; }
    .tag.now { background:#ff6b00; color:#fff; }
    .tag.status { background:#e3f5e9; color:#0a8a3f; }

    .items { margin:14px 0; border-top:1px dashed #ede7de; border-bottom:1px dashed #ede7de; padding:10px 0; }
    .row { display:flex; justify-content:space-between; font-size:14.5px; padding:4px 0; }
    .meta { display:flex; justify-content:space-between; flex-wrap:wrap; gap:8px; font-size:14px; color:#555; }
    .meta b { color:#1f1b16; }
    .total { font-size:18px; font-weight:800; color:#1f1b16; }

    .empty { background:#fff; border-radius:14px; text-align:center; padding:60px 20px; color:#888; }
    .empty a { color:#ff6b00; font-weight:bold; text-decoration:none; }
    .more { display:block; width:max-content; margin:24px auto 0; background:#fff; color:#ff6b00;
        border:1.5px solid #ff6b00; padding:11px 34px; border-radius:10px; font-weight:800; text-decoration:none; }
    .more:hover { background:#ff6b00; color:#fff; }
</style>
</head>
<body>

<nav>
    <a href="home.jsp" class="logo">Platterly</a>
    <div class="nav-links">
        <a href="home.jsp">Home</a>
        <a href="restaurant">Restaurants</a>
        <a href="myorders" class="active">My Orders</a>
        <a href="cart.jsp">&#128722; Cart</a>
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
    <h1>My Orders</h1>
    <p class="sub">Your current order and past orders</p>

<% if (orders == null || orders.isEmpty()) { %>

    <div class="empty">
        <p>You have no orders yet.</p>
        <p style="margin-top:10px;"><a href="restaurant">Browse restaurants</a></p>
    </div>

<% } else {
       boolean first = true;
       for (Order o : orders) {
           List<OrderItem> its = orderItems.get(o.getOrderId());
           String status = (o.getStatus() != null && !o.getStatus().isEmpty()) ? o.getStatus() : "Placed";
%>
    <div class="order<%= first ? " latest" : "" %>">
        <div class="top">
            <div>
                <div class="oid">Order #<%= o.getOrderId() %></div>
                <div class="date"><%= o.getOrderDate() != null ? fmt.format(o.getOrderDate()) : "" %></div>
            </div>
            <div class="tags">
                <span class="tag <%= first ? "now" : "" %>"><%= first ? "Current order" : "Past order" %></span>
                <span class="tag status"><%= status %></span>
            </div>
        </div>

        <div class="items">
        <% if (its != null) { for (OrderItem it : its) { %>
            <div class="row">
                <span><%= it.getItemName() %> &times; <%= it.getQty() %></span>
                <span>&#8377;<%= it.getTotalPrice() %></span>
            </div>
        <% } } %>
        </div>

        <div class="meta">
            <div>
                <div>Payment: <b><%= o.getPaymentMethod() %></b></div>
                <div style="margin-top:4px;">Deliver to: <b><%= o.getAddress() %></b></div>
            </div>
            <div class="total">&#8377;<%= o.getTotalAmount() %></div>
        </div>
    </div>
<%
           first = false;
       }
   }
%>

<% if (hasMore != null && hasMore) { %>
    <a class="more" href="myorders?limit=<%= nextLimit %>">Show more orders</a>
<% } %>
</div>

</body>
</html>
