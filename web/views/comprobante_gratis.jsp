<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- 🌐 Cargar locale guardado en sesión -->
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}" />
<fmt:setBundle basename="messages" />

<%
    Map<String, Object> reserva = (Map<String, Object>) request.getAttribute("reserva");

    if (reserva == null) {
        response.sendRedirect(request.getContextPath() + "/views/mis_reservas.jsp");
        return;
    }

    String paqueteNombre = (String) reserva.get("paquete_nombre");
    String fecha = (String) reserva.get("fecha_reserva");
    double total = 0.0; // siempre 0 porque es gratis
%>

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="comprobante.titulo.gratis" /> | Movil Van Perú</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background: #faf7e8;
            font-family: 'Segoe UI';
        }
        .hero {
            background: linear-gradient(120deg, #c9a414, #f7d559);
            color: white;
            text-align: center;
            padding: 60px 0;
            position: relative;
        }
        .hero:after {
            content: "★";
            font-size: 180px;
            color: rgba(255,255,255,0.15);
            position: absolute;
            top: 10px;
            right: 40px;
        }
        .comprobante-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
            padding: 45px;
            max-width: 750px;
            margin: -50px auto 80px auto;
            border-top: 6px solid #d9b123;
        }
        .comprobante-header h3 {
            font-weight: 800;
            color: #c49b0b;
        }
        .sello-gratis {
            background-color: #fff6d1;
            color: #c49900;
            border: 2px dashed #c49900;
            border-radius: 10px;
            padding: 10px 18px;
            display: inline-block;
            font-size: 18px;
            font-weight: bold;
        }
        .info-line {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .btn-volver {
            background-color: #c9a414;
            color: white;
            border-radius: 50px;
        }
        .btn-volver:hover {
            background-color: #b18d0f;
        }
        .btn-imprimir {
            border-radius: 50px;
        }
    </style>
</head>

<body>

<!-- 🎁 HERO -->
<section class="hero">
    <h1 class="fw-bold mb-2"><i class="bi bi-gift-fill"></i> <fmt:message key="comprobante.beneficio.exito" /></h1>
    <p class="lead"><fmt:message key="comprobante.texto.gratis.descripcion" /></p>
</section>

<!-- 🎉 COMPROBANTE ESPECIAL -->
<div class="comprobante-card">

    <div class="text-center mb-4">
        <img src="<%= request.getContextPath() %>/views/images/logo.png" height="80" alt="Logo">
        <h3 class="mt-3"><fmt:message key="comprobante.paquete.gratis" /></h3>

        <div class="sello-gratis mt-2">
            <i class="bi bi-stars"></i> <fmt:message key="comprobante.100gratis" /> <i class="bi bi-stars"></i>
        </div>

        <p class="text-muted mt-2">
            <fmt:message key="comprobante.gracias" /><br>
            <fmt:message key="comprobante.disfruta.regalo" />
        </p>
    </div>

    <!-- Info de la reserva -->
    <h5 class="fw-bold mb-3">📘 <fmt:message key="comprobante.info.reserva" /></h5>

    <div class="info-line"><span><fmt:message key="reserva.id" />:</span><span>#<%= reserva.get("id_reserva") %></span></div>
    <div class="info-line"><span><fmt:message key="paquete.nombre" />:</span><span><%= paqueteNombre %></span></div>
    <div class="info-line"><span><fmt:message key="reserva.fecha" />:</span><span><%= fecha %></span></div>
    <div class="info-line"><span><fmt:message key="reserva.total" />:</span><span><b class="text-success">S/. 0.00</b></span></div>

    <div class="mt-4 info-line">
        <span><fmt:message key="beneficio.tipo" />:</span>
        <span class="text-primary fw-bold"><fmt:message key="beneficio.gratis.promocion" /></span>
    </div>

    <div class="text-center mt-4">
        <button class="btn btn-outline-dark btn-imprimir me-2" onclick="window.print()">
            <i class="bi bi-printer"></i> <fmt:message key="boton.imprimir" />
        </button>

        <a href="<%= request.getContextPath() %>/views/mis_reservas.jsp" class="btn btn-volver">
            <i class="bi bi-arrow-left-circle"></i> <fmt:message key="boton.volver.misreservas" />
        </a>
    </div>
</div>

<footer class="bg-dark text-white text-center py-3">
    <p>&copy; 2025 Movil Van Perú - <fmt:message key="promociones.beneficios" /></p>
</footer>

</body>
</html>
