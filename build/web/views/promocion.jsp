<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.movilvanperu.facade.*, com.movilvanperu.model.*" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="${sessionScope.lang != null ? sessionScope.lang : 'es'}">
<head>
    <meta charset="UTF-8">
    <title>Movil Van Perú - Promociones</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">

    <style>
        .card-img-top {
            height: 220px;
            object-fit: cover;
        }
        .star-rating i {
            color: #ffc107;
            font-size: 1.2rem;
        }
        .promo-badge {
            background-color: #dc3545;
            padding: 5px 15px;
            border-radius: 5px;
            color: white;
            font-weight: bold;
            position: absolute;
            top: 10px;
            left: 10px;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<%
    SistemaViajesFacade facade = new SistemaViajesFacade();
%>

<header class="hero bg-danger text-white py-5">
    <div class="container text-center">
        <h1><fmt:message key="promo.title"/></h1>
        <p class="lead"><fmt:message key="promo.subtitle"/></p>
    </div>
</header>

<section class="py-5">
    <div class="container">
        <div class="row g-4">

            <%
                List<Promocion> promos = facade.listarPromocionesActivas();

                if (promos != null && !promos.isEmpty()) {

                    for (Promocion promo : promos) {

                        Paquete p = facade.obtenerPaquetePorId(promo.getIdPaqueteGratis());
                        if (p == null) continue;

                        String img = (p.getImagen1() != null && !p.getImagen1().isEmpty())
                                ? request.getContextPath() + "/" + p.getImagen1()
                                : request.getContextPath() + "/views/images/default.jpg";

                        int valoracion = p.getValoracion();
                        StringBuilder estrellas = new StringBuilder();
                        for (int i = 1; i <= 5; i++) {
                            estrellas.append(i <= valoracion ? "<i class='bi bi-star-fill'></i>" : "<i class='bi bi-star'></i>");
                        }

                        int reservasPagadas = 0;
                        boolean yaReclamado = false;
                        int faltan = 0;

                        if (usuario != null) {

reservasPagadas = facade.contarReservasPagadasPorPromocion(usuario.getId(), promo.getId());
yaReclamado = facade.usuarioYaReclamoPromocion(usuario.getId(), promo.getId());
faltan = promo.getCantidadRequerida() - reservasPagadas;

                        }
            %>

            <div class="col-md-4">
                <div class="card shadow-sm border-0 h-100 position-relative">

                    <span class="promo-badge"><fmt:message key="promo.badge"/></span>

                    <img src="<%= img %>" class="card-img-top" alt="<%= p.getDestino() %>">

                    <div class="card-body">
                        <h5 class="card-title text-danger"><%= p.getNombre() %></h5>

                        <p class="text-muted mb-1">
                            <b><fmt:message key="promo.destination"/>:</b> <%= p.getDestino() %>
                        </p>

                        <p class="text-muted mb-1">
                            <b><fmt:message key="promo.departure"/>:</b> <%= p.getFechaSalida() %><br>
                            <b><fmt:message key="promo.return"/>:</b> <%= p.getFechaRetorno() %>
                        </p>

                        <div class="star-rating mb-2"><%= estrellas.toString() %></div>

                        <p class="small text-muted"><%= p.getDescripcion() %></p>

                        <h4 class="fw-bold text-danger">S/. <%= p.getPrecio() %></h4>

                        <% if (usuario == null) { %>

                            <div class="alert alert-warning mt-3">
                                <fmt:message key="promo.loginRequired"/>
                            </div>

                        <% } else { %>

                            <div class="alert alert-info mt-3">
                                <b><fmt:message key="promo.paidReservations"/>:</b>
                                <%= reservasPagadas %> / <%= promo.getCantidadRequerida() %><br>

                                <% if (faltan > 0) { %>
                                    <fmt:message key="promo.missingReservations">
                                        <fmt:param value="<%= faltan %>"/>
                                    </fmt:message>
                                <% } %>
                            </div>

                        <% } %>

                    </div>

                    <div class="card-footer bg-white border-0 text-center pb-4">

                        <% if (usuario != null) {

                                if (yaReclamado) { %>

                                    <button class="btn btn-secondary w-100" disabled>
                                        <fmt:message key="promo.alreadyClaimed"/>
                                    </button>

                                <% } else if (faltan <= 0) { %>

<form action="<%= request.getContextPath() %>/ReclamarPromocionServlet" method="get">
    <input type="hidden" name="idPromo" value="<%= promo.getId() %>">
    <button type="submit" class="btn btn-success w-100">
        <fmt:message key="promo.claimFreeTrip"/>
    </button>
</form>

                                <% } else { %>

                                    <button class="btn btn-outline-secondary w-100" disabled>
                                        <fmt:message key="promo.missing">
                                            <fmt:param value="<%= faltan %>"/>
                                        </fmt:message>
                                    </button>

                                <% }
                            } %>

                    </div>

                </div>
            </div>

            <%
                    }
                } else {
            %>

            <div class="col-12 text-center">
                <div class="alert alert-warning">
                    <fmt:message key="promo.noPromos"/>
                </div>
            </div>

            <% } %>

        </div>
    </div>
</section>

<footer class="bg-dark text-white text-center py-3">
    <p>&copy; <fmt:message key="promo.footer"/></p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
