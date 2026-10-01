<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.DecimalFormat, com.tap.model.CartItem, com.tap.model.Cart"%>
<%
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    Cart cart = (Cart) session.getAttribute("cart");
    Map<Integer, CartItem> items = (cart != null) ? cart.getItems() : null;

    DecimalFormat money = new DecimalFormat("#,##0.##");
    double grandTotal = 0;
    int totalQty = 0;
    if (items != null) {
        for (CartItem ci : items.values()) {
            grandTotal += ci.getTotalPrice();
            totalQty += ci.getQty();
        }
    }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Platterly - Checkout</title>
<style>
    :root { --orange:#ff6b00; --ink:#1f1b16; --soft:#6b6058; --line:#ede7de; --green:#0a8a3f; }
    * { margin:0; padding:0; box-sizing:border-box; font-family:'Segoe UI', Arial, sans-serif; }
    body { background:#f6f3ee; color:var(--ink); }
    a { text-decoration:none; color:inherit; }

    nav { background:#fff; height:70px; display:flex; align-items:center; justify-content:space-between;
        padding:0 max(5%, calc((100% - 1200px) / 2)); box-shadow:0 2px 8px rgba(0,0,0,0.08); }
    .logo { font-size:30px; font-weight:800; color:var(--orange); letter-spacing:-0.5px; }
    .nav-links { display:flex; gap:28px; }
    .nav-links a { font-weight:600; color:#333; font-size:15px; }
    .nav-links a:hover { color:var(--orange); }

    .wrap { width:92%; max-width:1050px; margin:34px auto 60px; }
    .back { display:inline-block; color:var(--orange); font-weight:700; margin-bottom:12px; font-size:14.5px; }
    .back:hover { text-decoration:underline; }
    h1 { font-size:32px; letter-spacing:-0.5px; margin-bottom:22px; }

    .layout { display:grid; grid-template-columns:1fr 360px; gap:24px; align-items:start; }
    .card { background:#fff; border-radius:18px; padding:24px; box-shadow:0 2px 12px rgba(31,27,22,0.06); margin-bottom:18px; }
    .card h2 { font-size:18px; margin-bottom:16px; display:flex; align-items:center; gap:10px; }
    .step { background:var(--orange); color:#fff; width:26px; height:26px; border-radius:50%; font-size:14px;
        display:inline-flex; align-items:center; justify-content:center; }

    textarea { width:100%; padding:14px; border:1.5px solid var(--line); border-radius:12px; font-size:15px;
        resize:vertical; outline:none; transition:border-color .2s, box-shadow .2s; }
    textarea:focus { border-color:var(--orange); box-shadow:0 0 0 3px rgba(255,107,0,0.15); }

    /* payment option cards */
    .pay { display:grid; grid-template-columns:1fr 1fr; gap:12px; }
    .opt { position:relative; }
    .opt input { position:absolute; opacity:0; inset:0; cursor:pointer; }
    .opt .box { border:1.5px solid var(--line); border-radius:14px; padding:16px; display:flex; align-items:center; gap:12px;
        transition:border-color .2s, background .2s; }
    .opt .ic { font-size:26px; }
    .opt b { display:block; font-size:15px; }
    .opt small { color:var(--soft); font-size:12.5px; }
    .opt input:checked + .box { border-color:var(--orange); background:#fff6ee; }
    .opt input:focus-visible + .box { outline:3px solid rgba(255,107,0,0.4); }

    .qr-panel { display:none; margin-top:18px; padding:22px; border:1.5px dashed var(--orange); border-radius:14px;
        background:#fff8f2; text-align:center; }
    .qr-panel.show { display:block; }
    .qr-panel svg { width:190px; height:190px; background:#fff; padding:10px; border-radius:12px; box-shadow:0 4px 14px rgba(0,0,0,0.12); }
    .qr-panel .amt { font-size:19px; font-weight:800; margin:14px 0 4px; }
    .qr-panel .upi { font-size:14px; color:var(--soft); }
    .qr-panel .demo { display:inline-block; margin-top:10px; font-size:12px; color:#a04a00; background:#ffe6d1; padding:3px 11px; border-radius:20px; }

    /* summary */
    .summary { position:sticky; top:20px; }
    .srow { display:flex; justify-content:space-between; gap:12px; padding:9px 0; font-size:14.5px; }
    .srow span:first-child { color:var(--soft); }
    .list { border-bottom:1px dashed var(--line); padding-bottom:8px; margin-bottom:8px; }
    .stotal { display:flex; justify-content:space-between; padding:10px 0 4px; font-size:21px; font-weight:800; }
    .place { margin-top:18px; width:100%; padding:16px; background:var(--green); color:#fff; border:none; border-radius:12px;
        font-size:16px; font-weight:800; cursor:pointer; transition:filter .2s, transform .2s; }
    .place:hover { filter:brightness(1.08); transform:translateY(-1px); }
    .secure { text-align:center; color:var(--soft); font-size:12.5px; margin-top:12px; }

    .error { background:#fdecea; color:#b3261e; padding:12px 16px; border-radius:12px; margin-bottom:16px; font-size:14px; }
    .empty { background:#fff; border-radius:20px; text-align:center; padding:60px 20px; }
    .empty a { color:var(--orange); font-weight:800; }

    @media (max-width:860px) { .layout { grid-template-columns:1fr; } .summary { position:static; } }
    @media (max-width:480px) { .pay { grid-template-columns:1fr; } .nav-links a:not(:last-child) { display:none; } }
</style>
</head>
<body>

<nav>
    <a href="<%= ctx %>/home.jsp" class="logo">Platterly</a>
    <div class="nav-links">
        <a href="<%= ctx %>/restaurant">Restaurants</a>
        <a href="<%= ctx %>/myorders">My Orders</a>
        <a href="<%= ctx %>/cart.jsp">&#128722; Cart</a>
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

<% if (items == null || items.isEmpty()) { %>

    <div class="empty">
        <h2>Nothing to check out</h2>
        <p style="margin:8px 0 18px; color:#6b6058;">Your cart is empty.</p>
        <a href="<%= ctx %>/restaurant">Browse restaurants &rarr;</a>
    </div>

<% } else { %>

    <a class="back" href="<%= ctx %>/cart.jsp">&larr; Back to cart</a>
    <h1>Checkout</h1>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
    <% } %>

    <form action="CheckoutServlet" method="post">
    <div class="layout">

        <div>
            <div class="card">
                <h2><span class="step">1</span> Delivery address</h2>
                <textarea id="address" name="address" rows="4" required
                    placeholder="House no, street, city, pincode"></textarea>
            </div>

            <div class="card">
                <h2><span class="step">2</span> Payment method</h2>

                <div class="pay">
                    <label class="opt">
                        <input type="radio" name="paymentMethod" value="COD" checked>
                        <span class="box"><span class="ic">&#128181;</span>
                            <span><b>Cash on Delivery</b><small>Pay when it arrives</small></span></span>
                    </label>
                    <label class="opt">
                        <input type="radio" name="paymentMethod" value="ONLINE">
                        <span class="box"><span class="ic">&#128241;</span>
                            <span><b>Pay Online</b><small>UPI / QR code</small></span></span>
                    </label>
                </div>

                <div class="qr-panel" id="qrPanel">
                    <div id="qrBox"></div>
                    <div class="amt">Pay &#8377;<%= money.format(grandTotal) %></div>
                    <div class="upi">Scan with any UPI app &middot; platterly@upi</div>
                    <span class="demo">Demo code &ndash; not a real payment</span>
                </div>
            </div>
        </div>

        <aside class="card summary">
            <h2>Order summary</h2>

            <div class="list">
            <% for (CartItem item : items.values()) { %>
                <div class="srow">
                    <span><%= item.getName() %> &times; <%= item.getQty() %></span>
                    <span>&#8377;<%= money.format(item.getTotalPrice()) %></span>
                </div>
            <% } %>
            </div>

            <div class="stotal"><span>Grand Total</span><span>&#8377;<%= money.format(grandTotal) %></span></div>

            <button type="submit" class="place">Place Order</button>
            <div class="secure">&#128274; Your details are kept private</div>
        </aside>

    </div>
    </form>

<% } %>

</div>

<script>
(function () {
    var panel = document.getElementById('qrPanel');
    if (!panel) return;
    var box = document.getElementById('qrBox');
    var N = 25, drawn = false;

    // seeded random so the dummy code looks the same each time
    var seed = <%= (int) grandTotal %> + 12345;
    function rnd() { seed = (seed * 1664525 + 1013904223) % 4294967296; return seed / 4294967296; }

    function isDark(cx, cy) {
        var corners = [[0,0],[N-7,0],[0,N-7]];
        for (var k = 0; k < 3; k++) {
            var x = corners[k][0], y = corners[k][1];
            if (cx >= x && cx < x + 7 && cy >= y && cy < y + 7) {
                var ring = Math.max(Math.abs(cx - x - 3), Math.abs(cy - y - 3));
                return ring !== 2;
            }
            if (cx >= x - 1 && cx <= x + 7 && cy >= y - 1 && cy <= y + 7) return false;
        }
        return rnd() > 0.5;
    }
    function draw() {
        var cells = '';
        for (var y = 0; y < N; y++)
            for (var x = 0; x < N; x++)
                if (isDark(x, y)) cells += '<rect x="' + x + '" y="' + y + '" width="1" height="1"/>';
        box.innerHTML = '<svg viewBox="0 0 ' + N + ' ' + N + '" shape-rendering="crispEdges" fill="#1F1B16" role="img" aria-label="Demo payment QR code">' + cells + '</svg>';
        drawn = true;
    }
    function update() {
        var online = document.querySelector('input[name="paymentMethod"]:checked').value === 'ONLINE';
        if (online && !drawn) draw();
        panel.classList.toggle('show', online);
    }
    document.querySelectorAll('input[name="paymentMethod"]').forEach(function (r) {
        r.addEventListener('change', update);
    });
    update();
})();
</script>

</body>
</html>
