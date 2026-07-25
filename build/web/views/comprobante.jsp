<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}" />
<fmt:setBundle basename="messages" />

<%
    Map<String, Object> pago = (Map<String, Object>) request.getAttribute("pago");
    Map<String, Object> reserva = (Map<String, Object>) request.getAttribute("reserva");

    if (pago == null || reserva == null) {
        response.sendRedirect(request.getContextPath() + "/views/mis_reservas.jsp");
        return;
    }

    String paqueteNombre = (String) reserva.get("paquete_nombre");
    String fecha = (String) reserva.get("fecha_reserva");
    double total = (reserva.get("total") != null) ? ((Number) reserva.get("total")).doubleValue() : 0.0;

    String metodo = (String) pago.get("metodo");
    String codigoPago = (String) pago.get("codigo_pago");
    String fechaPago = (String) pago.get("fecha_pago");

    if (codigoPago == null || codigoPago.trim().isEmpty()) codigoPago = "—";
    if (fechaPago == null || fechaPago.trim().isEmpty()) fechaPago = "—";
%>

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="comprobantepago.titulo"/> | Movil Van Perú</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body { background-color: #f5f7fa; font-family: 'Segoe UI', sans-serif; }
        .hero { background: linear-gradient(120deg, #00a884, #198754); color: white; text-align: center; padding: 60px 0; }
        .comprobante-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 6px 24px rgba(0,0,0,0.1);
            padding: 40px;
            max-width: 720px;
            margin: -50px auto 60px auto;
        }
        .sello { background-color: #d1f7d6; color: #198754; border: 2px solid #198754;
                border-radius: 10px; padding: 6px 12px; font-weight: 600; }
        .info-line { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee; }
        .btn-volver { background-color: #004b8d; color: white; border-radius: 50px; }
    </style>
</head>

<body>

<!-- 🌟 HERO -->
<section class="hero">
    <div class="container">
        <h1 class="fw-bold mb-2"><i class="bi bi-file-earmark-check"></i> <fmt:message key="comprobantepago.titulo"/></h1>
        <p class="lead"><fmt:message key="comprobantepago.subtitulo"/></p>
    </div>
</section>

<!-- 💳 TRAJECTO -->
<div class="comprobante-card">
    <div class="comprobante-header text-center">
        <img src="${pageContext.request.contextPath}/views/images/logo.png" height="70">
        <h3><fmt:message key="comprobantepago.confirmado"/></h3>
        <div class="sello"><i class="bi bi-check-circle"></i> <fmt:message key="comprobantepago.verificado"/></div>

        <p class="text-muted mt-2">
            <fmt:message key="comprobantepago.codigo"/>:
            <b><%= codigoPago %></b>
        </p>
    </div>

    <!-- 🧾 INFORMACIÓN RESERVA -->
    <div class="mb-4">
        <h5 class="fw-bold mb-3">🧾 <fmt:message key="comprobantepago.info.reserva"/></h5>

        <div class="info-line"><span><fmt:message key="reserva.id"/>:</span><span>#<%= reserva.get("id_reserva") %></span></div>
        <div class="info-line"><span><fmt:message key="paquete.nombre"/>:</span><span><%= paqueteNombre %></span></div>
        <div class="info-line"><span><fmt:message key="reserva.fecha"/>:</span><span><%= fecha %></span></div>
        <div class="info-line"><span><fmt:message key="reserva.totalpagado"/>:</span>
            <span>S/. <%= String.format("%.2f", total) %></span></div>
    </div>

    <!-- 💳 INFO PAGO -->
    <div class="mb-4">
        <h5 class="fw-bold mb-3">💳 <fmt:message key="comprobantepago.info.pago"/></h5>

        <div class="info-line"><span><fmt:message key="pago.metodo"/>:</span><span><%= metodo %></span></div>
        <div class="info-line"><span><fmt:message key="pago.fecha"/>:</span><span><%= fechaPago %></span></div>
        <div class="info-line"><span><fmt:message key="pago.estado"/>:</span>
            <span class="text-success fw-bold"><fmt:message key="pago.estado.pagado"/></span></div>
    </div>

    <div class="text-center mt-4">
        <button class="btn btn-outline-secondary btn-imprimir me-2" onclick="window.print()">
            <i class="bi bi-printer"></i> <fmt:message key="boton.imprimir.comprobante"/>
        </button>

        <a href="${pageContext.request.contextPath}/views/mis_reservas.jsp" class="btn btn-volver">
            <i class="bi bi-arrow-left-circle"></i> <fmt:message key="boton.volver.misreservas"/>
        </a>
    </div>
</div>

<footer class="bg-dark text-white text-center py-3">
    <p>&copy; 2025 Movil Van Perú - <fmt:message key="footer.derechos"/></p>
</footer>

</body>
</html>
