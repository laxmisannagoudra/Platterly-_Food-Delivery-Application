<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Order Confirmed</title>
<style>
    * { margin:0; padding:0; box-sizing:border-box; font-family:Arial, sans-serif; }
    body {
        background:#f5f5f5;
        padding:60px 20px;
        display:flex;
        justify-content:center;
    }
    .confirm-box {
        max-width:480px;
        width:100%;
        background:white;
        border-radius:10px;
        box-shadow:0 2px 8px rgba(0,0,0,0.15);
        padding:40px;
        text-align:center;
    }
    .check {
        width:64px;
        height:64px;
        background:#28a745;
        color:white;
        border-radius:50%;
        display:flex;
        align-items:center;
        justify-content:center;
        font-size:32px;
        margin:0 auto 20px;
    }
    h2 { margin-bottom:10px; color:#222; }
    p.sub { color:#666; margin-bottom:24px; }
    .order-summary {
        background:#fafafa;
        border-radius:8px;
        padding:18px 20px;
        text-align:left;
        margin-bottom:24px;
    }
    .order-summary .row {
        display:flex;
        justify-content:space-between;
        font-size:14px;
        padding:6px 0;
        color:#444;
    }
    .order-summary .row span:first-child { color:#888; }
    .order-summary .row.total {
        border-top:1px dashed #ddd;
        margin-top:6px;
        padding-top:10px;
        font-weight:bold;
        font-size:16px;
        color:#222;
    }
    a.btn {
        display:inline-block;
        margin-top:6px;
        padding:12px 28px;
        background:#ff6b00;
        color:white;
        text-decoration:none;
        border-radius:6px;
        font-weight:bold;
    }
    a.btn:hover { background:#e05f00; }
        .delivery-img {
        display:block;
        width:220px;
        max-width:70%;
        margin:0 auto 22px;
        animation:ride 0.9s ease-out;
    }
    @keyframes ride {
        from { transform:translateX(-80px); opacity:0; }
        to   { transform:translateX(0); opacity:1; }
    }
        
</style>
</head>
<body>

    <div class="confirm-box">
    <div class="check">&#10003;</div>
    <h2>Order Placed!</h2>
    <p class="sub">Your order has been confirmed and is being prepared.</p>

    <img src="${pageContext.request.contextPath}/Images/delivery-boy.svg"
         alt="Delivery partner on the way" class="delivery-img">

    <div class="order-summary">

    <div class="order-summary">
        <div class="row">
            <span>Order ID</span>
            <span>#<%= request.getAttribute("orderId") %></span>
        </div>
        <div class="row">
            <span>Payment Method</span>
            <span><%= request.getAttribute("paymentMethod") %></span>
        </div>
        <div class="row total">
            <span>Total Paid</span>
            <span>₹<%= request.getAttribute("totalAmount") %></span>
        </div>
    </div>

    <a href="${pageContext.request.contextPath}/restaurant" class="btn">Order Again</a>
</div>

</body>
</html>