<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="lang" value="${sessionScope.lang != null ? sessionScope.lang : 'es'}" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="messages" />

<%
    Map<String, Object> reserva = (Map<String, Object>) request.getAttribute("reserva");
    if (reserva == null) {
        response.sendRedirect(request.getContextPath() + "/views/mis_reservas.jsp");
        return;
    }

    int idReserva = (int) reserva.get("id_reserva");
    String estado = (String) reserva.get("estado");
    String metodoPago = (String) reserva.get("metodo_pago");
    String fecha = (String) reserva.get("fecha_reserva");
    double total = (reserva.get("total") != null) ? ((Number) reserva.get("total")).doubleValue() : 0.0;

    String paqueteNombre = (String) reserva.get("paquete_nombre");
    String paqueteImagen = (String) reserva.get("paquete_imagen1");
%>

<!DOCTYPE html>
<html lang="${lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="reserva.detalles.titulo" /> - Movil Van Perú</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/views/css/style.css" rel="stylesheet">

    <style>
        body { background-color: #f8f9fa; }
        .hero {
            background: linear-gradient(120deg, #004b8d, #007bff);
            color: white; padding: 60px 0; text-align: center;
        }
        .reserva-card {
            border-radius: 12px; overflow: hidden;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1); background: #fff;
        }
        .reserva-img { height: 300px; object-fit: cover; }
        .estado { font-weight: bold; text-transform: capitalize; }
        .estado.activa { color: green; }
        .estado.cancelada { color: red; }
        .estado.finalizada { color: gray; }
        .estado.pendiente { color: orange; }
        .estado.pagada { color: #007bff; }
        .btn-volver { background-color: #004b8d; color: white; border-radius: 50px; }
        .btn-volver:hover { background-color: #003566; }
    </style>
</head>

<body>

<jsp:include page="navbar.jsp"/>

<!-- HERO -->
<section class="hero">
    <div class="container">
        <h1 class="fw-bold mb-3"><fmt:message key="reserva.detalles.header" /></h1>
        <p class="lead"><fmt:message key="reserva.detalles.desc" /></p>
    </div>
</section>

<!-- DETALLE -->
<div class="container my-5">
    <div class="reserva-card overflow-hidden">
        <div class="row g-0">
            <div class="col-md-6">
                <img src="<%= (paqueteImagen != null && !paqueteImagen.isEmpty())
                        ? request.getContextPath() + "/" + paqueteImagen
                        : request.getContextPath() + "/views/images/default.jpg" %>"
                     class="img-fluid reserva-img" alt="Imagen del paquete">
            </div>

            <div class="col-md-6 d-flex flex-column justify-content-between p-4">
                <div>
                    <h3 class="text-primary fw-bold mb-3">
                        <i class="bi bi-airplane"></i> <%= paqueteNombre %>
                    </h3>

                    <p><i class="bi bi-hash"></i> 
                        <b><fmt:message key="reserva.id" />:</b> #<%= idReserva %>
                    </p>

                    <p><i class="bi bi-calendar-event"></i> 
                        <b><fmt:message key="reserva.fecha" />:</b> <%= fecha %>
                    </p>

                    <p><i class="bi bi-cash-stack"></i> 
                        <b><fmt:message key="reserva.total" />:</b> S/. <%= total %>
                    </p>

                    <p><i class="bi bi-credit-card"></i> 
                        <b><fmt:message key="reserva.metodo.pago" />:</b> 
                        <%= (metodoPago != null ? metodoPago : "No definido") %>
                    </p>

                    <p class="estado <%= (estado != null) ? estado.toLowerCase() : "" %>">
                        <i class="bi bi-info-circle"></i> 
                        <b><fmt:message key="reserva.estado" />:</b> <%= (estado != null) ? estado : "Desconocido" %>
                    </p>
                </div>

                <div class="mt-4">

                    <% if ("pendiente".equalsIgnoreCase(estado)) { %>
                        <a href="<%= request.getContextPath() %>/PagoServlet?action=cargar&id_reserva=<%= idReserva %>"
                           class="btn btn-success w-100 mb-3">
                            <i class="bi bi-credit-card"></i> 
                            <fmt:message key="reserva.pago.realizar" />
                        </a>

                    <% } else if ("pagada".equalsIgnoreCase(estado)) { %>

                        <a href="<%= request.getContextPath() %>/VerComprobanteServlet?id_reserva=<%= idReserva %>"
                           class="btn btn-outline-success btn-sm w-100">
                            <i class="bi bi-file-earmark-check"></i> 
                            <fmt:message key="reserva.ver.comprobante" />
                        </a>

                    <% } %>

                    <a href="<%= request.getContextPath() %>/views/mis_reservas.jsp" class="btn btn-volver w-100">
                        <i class="bi bi-arrow-left-circle"></i> 
                        <fmt:message key="reserva.volver" />
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="bg-dark text-white text-center py-3 mt-5">
    <p>&copy; 2025 Movil Van Perú - <fmt:message key="footer.rights" /></p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
