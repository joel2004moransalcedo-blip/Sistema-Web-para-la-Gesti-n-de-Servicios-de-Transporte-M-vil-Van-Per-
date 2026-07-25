<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.movilvanperu.facade.*, com.movilvanperu.model.*" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="${sessionScope.lang != null ? sessionScope.lang : 'es'}">
<head>
    <meta charset="UTF-8">
    <title>Movil Van Perú</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- CSS personalizado -->
    <link href="views/css/style.css" rel="stylesheet">
</head>
<body>

<!-- Navbar dinámico -->
<%@ include file="views/navbar.jsp" %>

<!-- Hero Header -->
<header class="hero">

<%
    SistemaViajesFacade facadeIndex = new SistemaViajesFacade();
    List<Promocion> banners = facadeIndex.listarPromocionesActivas();
%>

<% if (banners != null && !banners.isEmpty()) { %>

<section class="container my-5">
    <h2 class="fw-bold text-center mb-4 text-danger">
        <fmt:message key="index.featuredPromotions"/>
    </h2>

    <div id="promoCarousel" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-inner">

            <% 
                boolean active = true;
                for (Promocion promo : banners) {
            %>

            <div class="carousel-item <%= active ? "active" : "" %>">
                <img src="views/images/<%= promo.getBanner() %>" class="d-block w-100"
                     style="height: 350px; object-fit: cover;">

                <div class="carousel-caption d-none d-md-block bg-dark bg-opacity-50 p-3 rounded">
                    <h5><%= promo.getNombre() %></h5>
                    <p><%= promo.getDescripcion() %></p>
                </div>
            </div>

            <% active = false; } %>

        </div>

        <button class="carousel-control-prev" type="button" data-bs-target="#promoCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>

        <button class="carousel-control-next" type="button" data-bs-target="#promoCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>
</section>

<% } %>

<div class="container text-center">
    <h1><fmt:message key="index.welcomeTitle"/></h1>
    <p class="lead"><fmt:message key="index.welcomeSubtitle"/></p>
</div>

</header>

<!-- Servicios -->
<section class="py-5">
    <div class="container text-center">
        <h2 class="fw-bold"><fmt:message key="index.servicesTitle"/></h2>

        <div class="row mt-4">

            <!-- Servicio 1 -->
            <div class="col-md-4">
                <div class="card shadow service-card">
                    <img src="views/images/viajes.jpg" class="card-img-top" alt="">
                    <div class="card-body">
                        <h5 class="card-title"><fmt:message key="index.service1.title"/></h5>
                        <p class="card-text"><fmt:message key="index.service1.desc"/></p>
                    </div>
                </div>
            </div>

            <!-- Servicio 2 -->
            <div class="col-md-4">
                <div class="card shadow service-card">
                    <img src="views/images/reservas.jpg" class="card-img-top" alt="">
                    <div class="card-body">
                        <h5 class="card-title"><fmt:message key="index.service2.title"/></h5>
                        <p class="card-text"><fmt:message key="index.service2.desc"/></p>
                    </div>
                </div>
            </div>

            <!-- Servicio 3 -->
            <div class="col-md-4">
                <div class="card shadow service-card">
                    <img src="views/images/soporte.jpg" class="card-img-top" alt="">
                    <div class="card-body">
                        <h5 class="card-title"><fmt:message key="index.service3.title"/></h5>
                        <p class="card-text"><fmt:message key="index.service3.desc"/></p>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<!-- Footer -->
<footer class="bg-dark text-white text-center py-3">
    <p>&copy; <fmt:message key="index.footer"/></p>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
