<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.movilvanperu.dao.*, com.movilvanperu.model.*" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<fmt:setBundle basename="messages" var="msg"/>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Movil Van Perú - <fmt:message key="hoteles.titulo"/></title>

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
    </style>
</head>
<body>

<!-- Navbar -->
<%@ include file="navbar.jsp" %>

<header class="hero bg-dark text-white py-5">
    <div class="container text-center">
        <h1><fmt:message key="hoteles.titulo"/></h1>
        <p class="lead"><fmt:message key="hoteles.descripcion"/></p>
    </div>
</header>

<section class="py-5">
    <div class="container">
        <div class="row g-4">

            <%
                HotelDAO hotelDAO = new HotelDAO();
                List<Hotel> hoteles = hotelDAO.listar();  // Obtener lista de hoteles

                if (hoteles != null && !hoteles.isEmpty()) {
                    for (Hotel h : hoteles) {

                        String img = (h.getImagen1() != null && !h.getImagen1().isEmpty())
                                ? request.getContextPath() + "/views/images/" + h.getImagen1()
                                : request.getContextPath() + "/views/images/default.png";

                        int valoracion = h.getEstrellas();
                        StringBuilder estrellas = new StringBuilder();
                        for (int i = 1; i <= 5; i++) {
                            if (i <= valoracion) estrellas.append("<i class='bi bi-star-fill'></i>");
                            else estrellas.append("<i class='bi bi-star'></i>");
                        }
            %>

            <div class="col-md-4">
                <div class="card shadow-sm border-0 h-100">
                    <img src="<%= img %>" class="card-img-top" alt="<%= h.getNombre() %>">

                    <div class="card-body">
                        <h5 class="card-title text-primary"><%= h.getNombre() %></h5>

                        <p class="text-muted mb-1">
                            <b><fmt:message key="hoteles.ciudad"/>:</b> <%= h.getCiudad() %> - <b><fmt:message key="hoteles.pais"/>:</b> <%= h.getPais() %>
                        </p>

                        <div class="star-rating mb-2"><%= estrellas.toString() %></div>

                        <p class="small text-muted"><%= h.getDescripcion() %></p>
                        <p class="text-muted"><b><fmt:message key="hoteles.email"/>:</b> <%= h.getEmail() %></p>
                        <p class="text-muted"><b><fmt:message key="hoteles.precioNoche"/>:</b> S/. <%= h.getPrecioNoche() %></p>
                    </div>

                    <div class="card-footer bg-white border-0 pb-4 text-center">
                        <form action="<%= request.getContextPath() %>/ReservaHotelServlet" method="post" class="px-3">
                            <input type="hidden" name="accion" value="reservar">
                            <input type="hidden" name="id_hotel" value="<%= h.getId_hotel() %>">
                            <input type="hidden" name="precio_noche" value="<%= h.getPrecioNoche() %>">

                            <div class="mb-2">
                                <label class="form-label"><fmt:message key="hoteles.fechaInicio"/></label>
                                <input type="date" name="fecha_inicio" class="form-control" required>
                            </div>

                            <div class="mb-2">
                                <label class="form-label"><fmt:message key="hoteles.fechaFin"/></label>
                                <input type="date" name="fecha_fin" class="form-control" required>
                            </div>

                            <select name="metodoPago" class="form-select mb-2" required>
                                <option value="" disabled selected><fmt:message key="hoteles.metodoPago"/></option>
                                <option value="tarjeta"><fmt:message key="hoteles.metodoPago.tarjeta"/></option>
                                <option value="yape"><fmt:message key="hoteles.metodoPago.yape"/></option>
                                <option value="plin"><fmt:message key="hoteles.metodoPago.plin"/></option>
                                <option value="transferencia"><fmt:message key="hoteles.metodoPago.transferencia"/></option>
                            </select>

                            <button type="submit" class="btn btn-outline-primary w-100">
                                <i class="bi bi-credit-card me-2"></i> <fmt:message key="hoteles.reservar"/>
                            </button>
                        </form>
                    </div>

                </div>
            </div>

            <%
                    }
                } else {
            %>

            <div class="col-12 text-center">
                <div class="alert alert-warning"><fmt:message key="hoteles.noDisponibles"/></div>
            </div>

            <% } %>

        </div>
    </div>
</section>

<footer class="bg-dark text-white text-center py-3 mt-5">
    <p><fmt:message key="footer.copy"/></p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
