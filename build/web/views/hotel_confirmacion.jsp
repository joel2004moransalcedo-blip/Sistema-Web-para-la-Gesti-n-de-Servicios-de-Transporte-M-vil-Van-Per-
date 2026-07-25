<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.movilvanperu.model.Hotel, com.movilvanperu.model.ReservaHotel" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="lang" value="${sessionScope.lang != null ? sessionScope.lang : 'es'}" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="messages" />

<%
    ReservaHotel reserva = (ReservaHotel) request.getAttribute("reserva");
    Hotel hotel = (Hotel) request.getAttribute("hotel");
    String metodoPago = (String) request.getAttribute("metodoPago");

    if (reserva == null || hotel == null) {
        out.println("<h2 class='text-danger text-center mt-5'>No se encontró la información de la reserva.</h2>");
        return;
    }

    long diffInMillies = reserva.getFecha_fin().getTime() - reserva.getFecha_inicio().getTime();
    long noches = (diffInMillies / (1000 * 60 * 60 * 24)) + 1; // incluir última noche
%>

<!DOCTYPE html>
<html lang="${lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="confirmacion.titulo.hotel" /> - Movil Van Perú</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body { background-color: #f8f9fa; }
        .hero {
            background: linear-gradient(90deg, #005b96, #007bff);
            color: white; padding: 60px 0; text-align: center;
        }
        .card-img-top {
            height: 300px; object-fit: cover; border-radius: 10px;
        }
        .info-box {
            background: white; border-radius: 10px;
            padding: 25px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
    </style>
</head>

<body>

<!-- HERO -->
<header class="hero">
    <div class="container">
        <h1 class="fw-bold"><fmt:message key="confirmacion.exito.hotel" /></h1>
        <p class="lead"><fmt:message key="confirmacion.gracias" /> <b>Movil Van Perú</b></p>
    </div>
</header>

<!-- DETALLE -->
<section class="py-5">
    <div class="container">
        <div class="row g-4 align-items-center">

            <!-- IMAGEN HOTEL -->
            <div class="col-md-6">
                <div class="card shadow">
                    <img src="<%= hotel.getImagen1() != null && !hotel.getImagen1().isEmpty() ? request.getContextPath() + "/views/images/" + hotel.getImagen1() : request.getContextPath() + "/views/images/default.png" %>" 
                         class="card-img-top" alt="<%= hotel.getNombre() %>">
                </div>
            </div>

            <!-- INFO RESERVA -->
            <div class="col-md-6">
                <div class="info-box">
                    <h3 class="text-primary mb-3"><%= hotel.getNombre() %></h3>

                    <p><b><fmt:message key="hotel.ciudad" />:</b> <%= hotel.getCiudad() %> - <%= hotel.getPais() %></p>
                    <p><b><fmt:message key="reserva.fecha.inicio" />:</b> <%= reserva.getFecha_inicio() %></p>
                    <p><b><fmt:message key="reserva.fecha.fin" />:</b> <%= reserva.getFecha_fin() %></p>
                    <p><b><fmt:message key="reserva.noches" />:</b> <%= noches %></p>
                    <p><b><fmt:message key="reserva.precio.noche" />:</b> S/. <%= reserva.getPrecio_noche() %></p>
                    <p><b><fmt:message key="reserva.total" />:</b> S/. <%= reserva.getTotal() %></p>
                    <p><b><fmt:message key="reserva.metodo.pago" />:</b> <%= metodoPago != null ? metodoPago : "No especificado" %></p>

                    <div class="text-center mt-4">
                        <a href="<%= request.getContextPath() %>/views/mis_reservas.jsp" class="btn btn-primary px-4 me-2">
                            <i class="bi bi-list"></i> <fmt:message key="boton.mis.reservas" />
                        </a>

                        <a href="<%= request.getContextPath() %>/views/hoteles.jsp" class="btn btn-outline-secondary px-4">
                            <i class="bi bi-arrow-left"></i> <fmt:message key="boton.volver.hoteles" />
                        </a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<!-- FOOTER -->
<footer class="bg-dark text-white text-center py-3 mt-5">
    <p>&copy; 2025 Movil Van Perú — <fmt:message key="footer.rights" /></p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
