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
