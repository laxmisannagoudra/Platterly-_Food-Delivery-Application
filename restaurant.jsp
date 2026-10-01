<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.tap.model.Restaurant"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Platterly - Restaurants</title>

<style>
    :root{
        --orange:#FF6B00;
        --orange-dark:#E85D00;
        --ink:#1F1B16;
        --ink-soft:#6B6058;
        --line:#EDE7DE;
        --cream:#FFFBF6;
        --green:#0A8A3F;
        --star:#FFB100;
    }

    *{margin:0;padding:0;box-sizing:border-box;font-family:'Segoe UI',Arial,sans-serif;}

    body{background-color:var(--cream);color:var(--ink);}

    a{text-decoration:none;color:inherit;}

    /* ================= NAV ================= */
    nav{
        background:#fff;
        height:100px;
        display:flex;
        align-items:center;
        justify-content:space-between;
        padding:0 6%;
        box-shadow:0 1px 0 var(--line);
        position:sticky;
        top:0;
        z-index:1000;
    }

    .logo{font-size:26px;font-weight:800;color:var(--orange);}

    .nav-links{display:flex;align-items:center;gap:30px;}

    .nav-links a{color:var(--ink);font-weight:600;font-size:14.5px;transition:color .2s;}
    .nav-links a:hover{color:var(--orange);}

    .nav-cart{
        display:flex;align-items:center;gap:6px;
        background:var(--ink);color:#fff !important;
        padding:4px 16px;border-radius:100px;
    }
    .nav-cart:hover{background:var(--orange);}

            /* ================= HERO ================= */
    .hero{
        background:#1F1B16;
        padding:200px 6% 240px;
        min-height:700px;
        text-align:center;
        position:relative;
        overflow:hidden;
    }

    /* slideshow layer */
    .hero-slides{
        position:absolute;inset:0;z-index:0;
        background:#1F1B16;
    }
    .hero-slides video{width:100%;height:100%;object-fit:cover;display:block;}

    /* dark overlay so text is readable */
    .hero::before{
        content:"";
        position:absolute;
        inset:0;
        background:rgba(0,0,0,0.50);
        z-index:1;
    }

    /* keep content above the images */
    .hero > *:not(.hero-slides){position:relative;z-index:2;}

    .hero h1{
        font-size:clamp(30px,4.2vw,46px);
        font-weight:800;
        color:#fff;
        margin-bottom:10px;
        text-shadow:0 2px 12px rgba(0,0,0,0.35);
    }

    .hero h1 span{color:#FF8A2B;}

    .hero p{
        color:#f3ece4;
        font-size:16px;
        max-width:520px;
        margin:0 auto 32px;
    }

    
    /* ---- Search bar ---- */

    /* ---- Search bar ---- */
    .search-bar{
        max-width:800px;
        margin:0 auto;
        background:#fff;
        border-radius:14px;
        box-shadow:0 14px 32px -12px rgba(31,27,22,0.25);
        display:flex;
        align-items:center;
        padding:6px;
        position:relative;
    }

    .search-icon{
        padding:0 25px;
        font-size:18px;
        color:var(--ink-soft);
    }

    .search-bar input{
        flex:1;
        border:none;
        outline:none;
        font-size:15.5px;
        padding:14px 6px;
        background:transparent;
        color:var(--ink);
    }

    .search-bar input::placeholder{color:#B8AFA4;}

    .search-btn{
        background:var(--orange);
        color:#fff;
        border:none;
        padding:13px 26px;
        border-radius:9px;
        font-weight:700;
        font-size:14.5px;
        cursor:pointer;
        transition:background .2s;
    }
    .search-btn:hover{background:var(--orange-dark);}

    /* ================= CUISINE CHIPS ================= */
    .chip-row{
        max-width:1100px;
        margin:-46px auto 0;
        position:relative;
        z-index:5;
        display:flex;
        gap:12px;
        overflow-x:auto;
        padding:8px 6% 8px;
        scrollbar-width:none;
    }
    .chip-row::-webkit-scrollbar{display:none;}

    .chip{
        flex:0 0 auto;
        background:#fff;
        border:1.5px solid var(--line);
        color:var(--ink);
        padding:10px 20px;
        border-radius:100px;
        font-size:13.5px;
        font-weight:600;
        cursor:pointer;
        white-space:nowrap;
        transition:all .2s;
        box-shadow:0 2px 6px rgba(31,27,22,0.06);
    }

    .chip:hover{border-color:var(--orange);color:var(--orange);}

    .chip.active{
        background:var(--orange);
        border-color:var(--orange);
        color:#fff;
    }

    /* ================= SECTION HEADING ================= */
    .page-heading{
        text-align:left;
        max-width:1200px;
        margin:56px auto 26px;
        padding:0 6%;
        display:flex;
        justify-content:space-between;
        align-items:flex-end;
        flex-wrap:wrap;
        gap:10px;
    }

    .page-heading h2{font-size:26px;color:var(--ink);}
    .page-heading p{color:var(--ink-soft);font-size:14px;}

    #result-count{color:var(--ink-soft);font-size:13.5px;font-weight:600;}

    /* ================= GRID ================= */
    .restaurant-container{
        width:88%;
        max-width:11000px;
        margin:0 auto;
        display:grid;
        grid-template-columns:repeat(3,1fr);
        gap:20px;
        padding-bottom:10px;
    }

    /* ================= CARD ================= */
    .restaurant-card{
        background:#fff;
        border-radius:20px;
        overflow:hidden;
        box-shadow:0 2px 10px rgba(31,27,22,0.08);
        transition:transform .25s ease, box-shadow .25s ease;
        display:flex;
        flex-direction:column;
    }

    .restaurant-card:hover{
        transform:translateY(-6px);
        box-shadow:0 18px 34px -14px rgba(31,27,22,0.28);
    }

    .card-img-wrap{position:relative;height:200px;overflow:hidden;}

    .card-img-wrap img{width:100%;height:100%;object-fit:cover;transition:transform .4s;}
    .restaurant-card:hover .card-img-wrap img{transform:scale(1.06);}

    .rating-badge{
        position:absolute;
        top:12px;right:12px;
        background:var(--green);
        color:#fff;
        font-size:12.5px;
        font-weight:700;
        padding:4px 9px;
        border-radius:6px;
        display:flex;
        align-items:center;
        gap:3px;
    }

    .time-badge{
        position:absolute;
        bottom:12px;left:12px;
        background:rgba(255,255,255,0.95);
        color:var(--ink);
        font-size:11.5px;
        font-weight:700;
        padding:4px 10px;
        border-radius:100px;
    }

    .card-body{padding:16px 18px 18px;flex:1;display:flex;flex-direction:column;}

    .card-body h2{font-size:18.5px;color:var(--ink);margin-bottom:4px;}

    .cuisine-tag{color:var(--ink-soft);font-size:13.5px;margin-bottom:10px;}

    .card-meta{
        display:flex;
        flex-direction:column;
        gap:4px;
        font-size:12.5px;
        color:#8A8177;
        border-top:1px dashed var(--line);
        padding-top:10px;
        margin-top:auto;
        margin-bottom:14px;
    }

    .order-btn{
        display:block;
        background:var(--orange);
        color:#fff;
        text-align:center;
        padding:11px;
        border-radius:8px;
        font-weight:700;
        font-size:14.5px;
        transition:background .2s;
    }
    .order-btn:hover{background:var(--orange-dark);}

    /* ================= EMPTY STATE ================= */
    .no-results{
        display:none;
        text-align:center;
        padding:70px 20px;
        color:var(--ink-soft);
        grid-column:1/-1;
    }
    .no-results h3{color:var(--ink);margin-bottom:8px;font-size:20px;}

    /* ================= FOOTER ================= */
    footer{
        background:var(--ink);
        color:#fff;
        text-align:center;
        padding:26px;
    }
    footer span{color:var(--orange);font-weight:700;}

    /* ================= RESPONSIVE ================= */
    @media (max-width:980px){
        .restaurant-container{grid-template-columns:repeat(2,1fr);}
    }
    @media (max-width:640px){
        nav{padding:0 5%;}
        .nav-links a:not(.nav-cart){display:none;}
        .hero{padding:120px 6% 150px;min-height:540px;}
        .search-bar{flex-wrap:wrap;}
        .search-btn{width:100%;margin-top:6px;}
        .restaurant-container{grid-template-columns:1fr;width:90%;}
        .page-heading{flex-direction:column;align-items:flex-start;}
    }

    @media (prefers-reduced-motion: reduce){
        *{transition:none !important;}
        .hero-slides video{display:none;}
    }
</style>
</head>
<body>

<!-- ================= NAV ================= -->
<nav>
    <a href="${pageContext.request.contextPath}/restaurant" class="logo">Platterly</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/home.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/myorders">My Orders</a>
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
        <a href="${pageContext.request.contextPath}/cart.jsp" class="nav-cart">🛒 Cart</a>
        
    </div>
</nav>

<!-- ================= HERO + SEARCH ================= -->
<section class="hero">

    <div class="hero-slides">
        <video id="heroVideo" autoplay muted playsinline preload="auto"></video>
    </div>

    <h1>Order food from <span>restaurants you love</span></h1>
    <p>Search by dish, cuisine, or restaurant name — find something good to eat, fast.</p>

    <div class="search-bar">
        <span class="search-icon">🔍</span>
        <input type="text" id="searchInput" placeholder="Search 'biryani', 'sushi', 'Spice Villa'...">
        <button class="search-btn" onclick="applyFilters()">Search</button>
    </div>
</section>

<!-- ================= CUISINE CHIPS ================= -->
<div class="chip-row" id="chipRow">
    <div class="chip active" data-cuisine="all" onclick="selectChip(this)">All</div>
</div>

<!-- ================= PAGE HEADING ================= -->
<div class="page-heading">
    <div>
        <h2>All Restaurants</h2>
        <p>Discover delicious food from the best restaurants near you</p>
        
        
    </div>
    <span id="result-count"></span>
</div>

<!-- ================= RESTAURANT GRID ================= -->
<div class="restaurant-container" id="restaurantGrid">

<%
    List<Restaurant> allRestaurants = (List<Restaurant>) request.getAttribute("allRestaurants");
    for (Restaurant restaurant : allRestaurants) {
        String name = restaurant.getName() == null ? "" : restaurant.getName();
        String cuisine = restaurant.getCuisine() == null ? "" : restaurant.getCuisine();
%>
<div class="restaurant-card"
     data-name="<%= name.toLowerCase() %>"
     data-cuisine="<%= cuisine.toLowerCase() %>">

    <div class="card-img-wrap">
        <img src="<%= restaurant.getImageUrl() %>" alt="<%= name %>">
        <span class="rating-badge">⭐ <%= restaurant.getRating() %></span>
        <span class="time-badge"><%= restaurant.getDeliveryTime() %> mins</span>
    </div>

    <div class="card-body">
        <h2><%= name %></h2>
        <p class="cuisine-tag"><%= cuisine %></p>

        <div class="card-meta">
            <span>📍 <%= restaurant.getAddress() %></span>
        </div>

        <a href="menu?restaurantId=<%= restaurant.getRestaurantId() %>" class="order-btn">
            View Menu
        </a>
    </div>
</div>
<% } %>

    <div class="no-results" id="noResults">
        <h3>No restaurants found</h3>
        <p>Try a different search term or cuisine filter.</p>
    </div>

</div>

<!-- ================= FOOTER ================= -->
<footer>
    <p>© 2026 <span>Platterly</span> | Delicious food delivered to you</p>
</footer>

<script>
    // Hero video playlist: plays the 5 videos one after another, then loops
    (function heroPlaylist() {
        const base = '${pageContext.request.contextPath}/video/';
        const files = [
            'res11.mp4', 'res4.mp4',
            'res1.mp4', 'res2.mp4', 'res3.mp4'
        ];   // change to your file names
        const v = document.getElementById('heroVideo');
        const SPEED = 1.5;   // 1 = normal, 1.25 = slightly faster, 1.5 = faster, 2 = double
        v.defaultPlaybackRate = SPEED;
        v.addEventListener('loadedmetadata', function () { v.playbackRate = SPEED; });
        let i = 0, errors = 0;

        function play() {
            v.src = base + files[i];
            v.play().catch(function () {});
        }
        function next() {
            i = (i + 1) % files.length;
            play();
        }
        v.addEventListener('ended', function () { errors = 0; next(); });
        v.addEventListener('error', function () {   // skip a missing/broken file
            if (++errors < files.length) next();    // stop if all fail
        });
        play();
    })();

    // Build cuisine chips dynamically from the cards actually rendered
    (function buildChips() {
        const cards = document.querySelectorAll('.restaurant-card');
        const cuisines = new Set();
        cards.forEach(c => {
            const cz = c.getAttribute('data-cuisine');
            if (cz) cuisines.add(cz);
        });

        const chipRow = document.getElementById('chipRow');
        cuisines.forEach(cz => {
            const chip = document.createElement('div');
            chip.className = 'chip';
            chip.setAttribute('data-cuisine', cz);
            chip.textContent = cz.replace(/\b\w/g, ch => ch.toUpperCase());
            chip.onclick = function () { selectChip(chip); };
            chipRow.appendChild(chip);
        });

        updateCount();
    })();

    let activeCuisine = 'all';

    function selectChip(el) {
        document.querySelectorAll('.chip').forEach(c => c.classList.remove('active'));
        el.classList.add('active');
        activeCuisine = el.getAttribute('data-cuisine');
        applyFilters();
    }

    function applyFilters() {
        const query = document.getElementById('searchInput').value.trim().toLowerCase();
        const cards = document.querySelectorAll('.restaurant-card');
        let visibleCount = 0;

        cards.forEach(card => {
            const name = card.getAttribute('data-name');
            const cuisine = card.getAttribute('data-cuisine');

            const matchesSearch = !query || name.includes(query) || cuisine.includes(query);
            const matchesCuisine = activeCuisine === 'all' || cuisine === activeCuisine;

            if (matchesSearch && matchesCuisine) {
                card.style.display = 'flex';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });

        document.getElementById('noResults').style.display = visibleCount === 0 ? 'block' : 'none';
        updateCount(visibleCount);
    }

    function updateCount(count) {
        const total = document.querySelectorAll('.restaurant-card').length;
        const shown = count === undefined ? total : count;
        document.getElementById('result-count').textContent = shown + ' of ' + total + ' restaurants';
    }

    document.getElementById('searchInput').addEventListener('input', applyFilters);
    document.getElementById('searchInput').addEventListener('input', applyFilters);

    // Read the search word sent from the home page (?q=meghana)
    const q = new URLSearchParams(location.search).get('q');
    if (q) {
        document.getElementById('searchInput').value = q;
        applyFilters();
    }

</script>

</body>
</html>
