<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.movilvanperu.model.Usuario" %>
<%@ page import="com.movilvanperu.facade.SistemaViajesFacade" %>

<!-- JSTL -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Configurar idioma -->
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}" />
<fmt:setBundle basename="messages" var="msg" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="reservas.titulo" bundle="${msg}"/> | Movil Van Perú</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/views/css/style.css" rel="stylesheet">

    <style>
        .hero {
            background: linear-gradient(to right, #004b8d, #007bff);
            color: white;
            padding: 60px 0;
            text-align: center;
        }
        .card img {
            height: 220px;
            object-fit: cover;
            border-radius: 8px 8px 0 0;
        }
        .estado {
            font-weight: bold;
            text-transform: capitalize;
        }
        .estado.activa { color: green; }
        .estado.cancelada { color: red; }
        .estado.finalizada { color: gray; }
        .estado.pendiente { color: orange; }
        .estado.pagada { color: #007bff; }
        .btn { transition: all 0.2s ease-in-out; }
        .btn:hover { transform: scale(1.03); }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp"/>

<!-- 🧾 Encabezado -->
<header class="hero">
    <div class="container">
        <h1><fmt:message key="reservas.titulo" bundle="${msg}"/></h1>
        <p class="lead mb-0"><fmt:message key="reservas.subtitulo" bundle="${msg}"/></p>
    </div>
</header>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }

    SistemaViajesFacade facade = new SistemaViajesFacade();
    List<Map<String, Object>> reservas = facade.listarTodasReservasPorUsuario(usuario.getId());
%>

<section class="py-5 bg-light">
    <div class="container">

        <!-- ALERTAS -->
        <%
            String msg = request.getParameter("msg");
            String error = request.getParameter("error");
            String success = request.getParameter("success");

            if ("cancelada".equals(msg)) {
        %>
            <div class="alert alert-success text-center">
                <i class="bi bi-check-circle"></i>
                <fmt:message key="reservas.cancelada.exito" bundle="${msg}"/>
            </div>
        <%
            } else if ("1".equals(success)) {
        %>
            <div class="alert alert-success text-center">
                <i class="bi bi-cash-coin"></i>
                <fmt:message key="reservas.pago.exito" bundle="${msg}"/>
            </div>
        <%
            } else if ("1".equals(error) || "pago".equals(error)) {
        %>
            <div class="alert alert-danger text-center">
                <i class="bi bi-exclamation-triangle"></i>
                <fmt:message key="reservas.pago.error" bundle="${msg}"/>
            </div>
        <%
            } else if (error != null) {
        %>
            <div class="alert alert-danger text-center">
                <i class="bi bi-exclamation-triangle"></i>
                <fmt:message key="reservas.cancelada.error" bundle="${msg}"/>
            </div>
        <%
            }
        %>

        <% if (reservas == null || reservas.isEmpty()) { %>
            <div class="alert alert-info text-center">
                <i class="bi bi-info-circle"></i>
                <fmt:message key="reservas.vacia" bundle="${msg}"/>
                <a href="<%= request.getContextPath() %>/views/viajes.jsp" class="alert-link">
                    <fmt:message key="reservas.explorar" bundle="${msg}"/>
                </a>
            </div>
        <% } else { %>

        <div class="row g-4">
<% for (Map<String, Object> r : reservas) {
    int idReserva = ((Number) r.get("id_reserva")).intValue();
    String tipo = (String) r.get("tipo");

    String nombre = "";
    String imagen = "";
    String checkin = "";
    String checkout = "";
    String precioNoche = "";

    if ("hotel".equalsIgnoreCase(tipo)) {
        nombre = (String) r.get("hotel_nombre");
        String hotelImagen = (String) r.get("hotel_imagen");
        if (hotelImagen != null && !hotelImagen.isEmpty()) {
            imagen = request.getContextPath() + "/" + hotelImagen;
        } else {
            imagen = request.getContextPath() + "/views/images/hotel_default.jpg";
        }

        // Nuevos campos para hoteles
        checkin = (r.get("fecha_inicio") != null) ? r.get("fecha_inicio").toString() : "-";
        checkout = (r.get("fecha_fin") != null) ? r.get("fecha_fin").toString() : "-";
        precioNoche = (r.get("precio_noche") != null) ? String.valueOf(r.get("precio_noche")) : "-";

    } else {
        nombre = (String) r.get("paquete_nombre");
        imagen = (r.get("paquete_imagen1") != null)
                 ? request.getContextPath() + "/" + r.get("paquete_imagen1")
                 : request.getContextPath() + "/views/images/default.jpg";
    }

    String estado = (String) r.get("estado");
String total = (r.get("total") != null) ? r.get("total").toString() : "0.00";
String fechaReserva = (r.get("fecha_reserva") != null) ? r.get("fecha_reserva").toString() : "-";

%>

<div class="col-md-4">
    <div class="card shadow-sm border-0 h-100">
        <img src="<%= imagen %>" class="card-img-top">

        <div class="card-body d-flex flex-column">
            
            <h5 class="card-title text-primary mb-3">
                <%= (nombre != null) ? nombre : "Reserva sin nombre" %>
            </h5>

            <p class="mb-1"><b><fmt:message key="reservas.id" bundle="${msg}"/>:</b> #<%= idReserva %></p>
            <p class="mb-1"><b><fmt:message key="reservas.tipo" bundle="${msg}"/>:</b>
                <%= ("hotel".equalsIgnoreCase(tipo)) ? "Hotel" : "Paquete" %>
            </p>
            <p class="mb-1"><b><fmt:message key="reservas.fecha" bundle="${msg}"/>:</b> <%= fechaReserva %></p>
            <p class="mb-1"><b><fmt:message key="reservas.total" bundle="${msg}"/>:</b> S/. <%= total %></p>

            <!-- NUEVO: Información adicional para hoteles -->
            <% if ("hotel".equalsIgnoreCase(tipo)) { %>
                <p class="mb-1"><b><fmt:message key="reservas.checkin" bundle="${msg}"/>:</b> <%= checkin %></p>
                <p class="mb-1"><b><fmt:message key="reservas.checkout" bundle="${msg}"/>:</b> <%= checkout %></p>
                <p class="mb-1"><b><fmt:message key="reservas.precio_noche" bundle="${msg}"/>:</b> S/. <%= precioNoche %></p>
            <% } %>

            <p class="estado <%= (estado != null) ? estado.toLowerCase() : "" %>">
                <b><fmt:message key="reservas.estado" bundle="${msg}"/>:</b> <%= estado %>
            </p>

            <div class="mt-auto d-grid gap-2 mt-3">
                <!-- Botones existentes para detalles, pago y cancelación se mantienen -->
<a href="<%= request.getContextPath() %>/VerDetalleServlet?id_reserva=<%= idReserva %>&tipo=<%= tipo %>"
   class="btn btn-info btn-sm w-100">
   <i class="bi bi-eye"></i>
   <fmt:message key="reservas.detalles" bundle="${msg}"/>
</a>


                <% if ("pendiente".equalsIgnoreCase(estado)) { %>
<a href="<%= request.getContextPath() %>/PagoServlet?action=cargar&id_reserva=<%= idReserva %>&tipo=<%= tipo %>"
   class="btn btn-success btn-sm w-100">
   <i class="bi bi-credit-card"></i>
   <fmt:message key="reservas.pagar" bundle="${msg}"/>
</a>

<% } else if ("pagada".equalsIgnoreCase(estado)) { %>
    <a href="<%= request.getContextPath() %>/VerComprobanteServlet?id_reserva=<%= idReserva %>&tipo=<%= tipo %>"
       class="btn btn-outline-success btn-sm w-100">
       <i class="bi bi-file-earmark-check"></i>
       <fmt:message key="reservas.comprobante" bundle="${msg}"/>
    </a>
<% } %>


                <% if ("activa".equalsIgnoreCase(estado) || "pendiente".equalsIgnoreCase(estado)) { %>
                    <form action="<%= request.getContextPath() %>/CancelarReservaServlet" method="post">
                        <input type="hidden" name="id_reserva" value="<%= idReserva %>">
                        <input type="hidden" name="tipo" value="<%= tipo %>">
                        <button type="submit" class="btn btn-danger btn-sm w-100">
                            <i class="bi bi-x-circle"></i>
                            <fmt:message key="reservas.cancelar" bundle="${msg}"/>
                        </button>
                    </form>
                <% } %>

            </div>
        </div>
    </div>
</div>

<% } %>

        </div>

        <% } %>
    </div>
</section>

<footer class="bg-dark text-white text-center py-3 mt-5">
    <p>&copy; 2025 Movil Van Perú - Todos los derechos reservados</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
