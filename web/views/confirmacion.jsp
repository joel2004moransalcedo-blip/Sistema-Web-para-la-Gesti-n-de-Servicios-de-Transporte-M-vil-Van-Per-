<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.movilvanperu.model.Usuario" %>
<%@ page import="com.movilvanperu.model.Paquete" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="lang" value="${sessionScope.lang != null ? sessionScope.lang : 'es'}" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="messages" />

<%
    Usuario usuario = (Usuario) request.getAttribute("usuario");
    Paquete paquete = (Paquete) request.getAttribute("paquete");
    String metodoPago = (String) request.getAttribute("metodoPago");
    Double total = (Double) request.getAttribute("total");

    if (paquete == null) {
        out.println("<h2 class='text-danger text-center mt-5'>No se encontró la información del paquete.</h2>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="${lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="confirmacion.titulo" /> - Movil Van Perú</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body { background-color: #f8f9fa; }
        .hero {
            background: linear-gradient(90deg, #005b96, #007bff);
            color: white; padding: 60px 0; text-align: center;
        }
        .carousel-item img {
            height: 380px; object-fit: cover; border-radius: 10px;
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
        <h1 class="fw-bold"><fmt:message key="confirmacion.exito" /></h1>
        <p class="lead"><fmt:message key="confirmacion.gracias" /> <b>Movil Van Perú</b></p>
    </div>
</header>

<!-- DETALLE -->
<section class="py-5">
    <div class="container">
        <div class="row g-4 align-items-center">

            <!-- CARRUSEL -->
            <div class="col-md-6">
                <div id="carouselPaquete" class="carousel slide shadow" data-bs-ride="carousel">
                    <div class="carousel-inner">
                        <%
                            String[] imgs = { paquete.getImagen1(), paquete.getImagen2(), paquete.getImagen3() };
                            boolean hayImagen = false;
                            boolean activa = true;

                            for (String img : imgs) {
                                if (img != null && !img.trim().isEmpty()) {
                                    hayImagen = true;
                        %>
                        <div class="carousel-item <%= activa ? "active" : "" %>">
                            <img src="<%= request.getContextPath() + "/" + img %>" class="d-block w-100">
                        </div>
                        <%
                                    activa = false;
                                }
                            }
                            if (!hayImagen) {
                        %>
                        <div class="carousel-item active">
                            <img src="<%= request.getContextPath() %>/views/images/default.jpg" class="d-block w-100">
                        </div>
                        <% } %>
                    </div>

                    <button class="carousel-control-prev" type="button" data-bs-target="#carouselPaquete" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon"></span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#carouselPaquete" data-bs-slide="next">
                        <span class="carousel-control-next-icon"></span>
                    </button>
                </div>
            </div>

            <!-- INFO DEL PAQUETE -->
            <div class="col-md-6">
                <div class="info-box">
                    <h3 class="text-primary mb-3"><%= paquete.getNombre() %></h3>

                    <p><b><fmt:message key="paquete.destino" />:</b> <%= paquete.getDestino() %></p>
                    <p><b><fmt:message key="paquete.duracion" />:</b> <%= paquete.getDuracionDias() %> <fmt:message key="paquete.dias" /></p>
                    <p><b><fmt:message key="paquete.salida" />:</b> <%= paquete.getFechaSalida() %></p>
                    <p><b><fmt:message key="paquete.retorno" />:</b> <%= paquete.getFechaRetorno() %></p>

                    <p><b><fmt:message key="reserva.metodo.pago" />:</b>
                        <%= (metodoPago != null && !metodoPago.isEmpty()) ? metodoPago : "No especificado" %>
                    </p>

                    <h4 class="text-success mt-3 fw-bold">
                        <fmt:message key="reserva.total.pagado" />:
                        S/. <%= total != null ? total : paquete.getPrecio() %>
                    </h4>
                </div>

                <div class="text-center mt-4">
                    <a href="<%= request.getContextPath() %>/views/mis_reservas.jsp" class="btn btn-primary px-4 me-2">
                        <i class="bi bi-list"></i> <fmt:message key="boton.mis.reservas" />
                    </a>

                    <a href="<%= request.getContextPath() %>/views/viajes.jsp" class="btn btn-outline-secondary px-4">
                        <i class="bi bi-arrow-left"></i> <fmt:message key="boton.volver.viajes" />
                    </a>
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
