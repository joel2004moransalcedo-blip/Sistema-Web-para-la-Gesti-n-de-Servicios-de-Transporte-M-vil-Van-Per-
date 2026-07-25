<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.movilvanperu.model.ReservaHotel, com.movilvanperu.model.Hotel" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}" />
<fmt:setBundle basename="messages" />

<%
    ReservaHotel reservaHotel = (ReservaHotel) request.getAttribute("reservaHotel");
    Hotel hotel = (Hotel) request.getAttribute("hotel");
    Map<String,Object> pago = (Map<String,Object>) request.getAttribute("pago");

    if (reservaHotel == null || hotel == null || pago == null) {
        response.sendRedirect(request.getContextPath() + "/views/mis_reservas.jsp");
        return;
    }

    // ✅ Obtener codigoPago de forma segura
    Object codigoPagoObj = pago.get("codigo_pago");
    String codigoPago = (codigoPagoObj != null) ? codigoPagoObj.toString() : "—";

    // ✅ Formatear fechaPago
    Object fechaPagoObj = pago.get("fecha_pago");
    String fechaPago = "—";
    if (fechaPagoObj != null) {
        if (fechaPagoObj instanceof java.sql.Timestamp) {
            fechaPago = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format((java.sql.Timestamp) fechaPagoObj);
        } else {
            fechaPago = fechaPagoObj.toString();
        }
    }

    // ✅ Obtener metodo de pago seguro
    Object metodoObj = pago.get("metodo");
    String metodo = (metodoObj != null) ? metodoObj.toString() : "—";

    double total = reservaHotel.getTotal();
%>

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="comprobante.hotel.titulo"/> | Movil Van Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f5f7fa; }
        .hero { background: linear-gradient(120deg, #004b8d, #007bff); color: white; padding: 60px 0; text-align: center; }
        .comprobante-card { background: white; border-radius: 16px; padding: 40px; max-width: 720px; margin: -50px auto 60px auto; box-shadow: 0 6px 24px rgba(0,0,0,0.1);}
        .sello { background-color: #d1f7d6; color: #198754; border: 2px solid #198754; border-radius: 10px; padding: 6px 12px; font-weight: 600; display:inline-block;}
        .info-line { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee; }
        .btn-volver { background-color: #004b8d; color: white; border-radius: 50px; padding: 10px 25px; text-decoration: none; }
    </style>
</head>
<body>

<section class="hero">
    <div class="container">
        <h1 class="fw-bold mb-2"><i class="bi bi-file-earmark-check"></i> <fmt:message key="comprobante.hotel.titulo"/></h1>
        <p class="lead"><fmt:message key="comprobante.hotel.subtitulo"/></p>
    </div>
</section>

<div class="comprobante-card">
    <div class="text-center mb-4">
        <img src="${pageContext.request.contextPath}/views/images/logo.png" height="70">
        <h3><fmt:message key="comprobante.confirmado"/></h3>
        <div class="sello"><i class="bi bi-check-circle"></i> <fmt:message key="comprobante.verificado"/></div>
        <p class="text-muted mt-2">
         <fmt:message key="comprobante.codigo"/>: <b><%= codigoPago %></b>

        </p>
    </div>

    <h5 class="fw-bold mb-3">🧾 <fmt:message key="comprobante.info.reserva"/></h5>
    <div class="info-line"><span><fmt:message key="reserva.id"/>:</span><span>#<%= reservaHotel.getId_reserva_hotel() %></span></div>
    <div class="info-line"><span><fmt:message key="hotel.nombre"/>:</span><span><%= hotel.getNombre() %></span></div>
    <div class="info-line"><span><fmt:message key="reserva.fecha"/>:</span><span><%= reservaHotel.getFecha_inicio() %> - <%= reservaHotel.getFecha_fin() %></span></div>
    <div class="info-line"><span><fmt:message key="reserva.totalpagado"/>:</span><span>S/. <%= String.format("%.2f", total) %></span></div>

    <h5 class="fw-bold mt-4 mb-3">💳 <fmt:message key="comprobante.info.pago"/></h5>
    <div class="info-line"><span><fmt:message key="pago.metodo"/>:</span><span><%= metodo %></span></div>
    <div class="info-line"><span><fmt:message key="pago.fecha"/>:</span><span><%= fechaPago %></span></div>
    <div class="info-line"><span><fmt:message key="pago.estado"/>:</span><span class="text-success fw-bold"><fmt:message key="pago.estado.pagado"/></span></div>

    <div class="text-center mt-4">
        <button class="btn btn-outline-secondary btn-imprimir me-2" onclick="window.print()">
            <i class="bi bi-printer"></i> <fmt:message key="boton.imprimir.comprobante"/>
        </button>

        <a href="${pageContext.request.contextPath}/views/mis_reservas.jsp" class="btn-volver">
            <i class="bi bi-arrow-left-circle"></i> <fmt:message key="boton.volver.misreservas"/>
        </a>
    </div>
</div>

<footer class="bg-dark text-white text-center py-3">
    <p>&copy; 2025 Movil Van Perú - <fmt:message key="footer.derechos"/></p>
</footer>

</body>
</html>
