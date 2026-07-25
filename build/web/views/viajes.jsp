<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.movilvanperu.facade.*, com.movilvanperu.model.*" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="${sessionScope.lang != null ? sessionScope.lang : 'es'}">
<head>
    <meta charset="UTF-8">
    <title>Movil Van Perú - Viajes</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Icons (para estrellas) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- CSS personalizado -->
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
        .btn-outline-primary {
            transition: all 0.3s ease;
        }
        .btn-outline-primary:hover {
            background-color: #0d6efd;
            color: #fff;
        }
    </style>
</head>
<body>

<!-- Navbar dinámico -->
<%@ include file="navbar.jsp" %>

<!-- Header -->
<header class="hero bg-dark text-white py-5">
    <div class="container text-center">
        <h1><fmt:message key="viajes.title"/></h1>
        <p class="lead"><fmt:message key="viajes.subtitle"/></p>
    </div>
</header>

<!-- Lista de viajes -->
<section class="py-5">
    <div class="container">
        <div class="row g-4">

            <%
                SistemaViajesFacade facade = new SistemaViajesFacade();
                List<Paquete> paquetes = facade.listarPaquetes();

                if (paquetes != null && !paquetes.isEmpty()) {
                    for (Paquete p : paquetes) {
                        String img = (p.getImagen1() != null && !p.getImagen1().isEmpty())
                                     ? request.getContextPath() + "/" + p.getImagen1()
                                     : request.getContextPath() + "/views/images/default.jpg";

                        int valoracion = p.getValoracion();
                        StringBuilder estrellas = new StringBuilder();
                        for (int i = 1; i <= 5; i++) {
                            if (i <= valoracion) estrellas.append("<i class='bi bi-star-fill'></i>");
                            else estrellas.append("<i class='bi bi-star'></i>");
                        }
            %>

            <!-- Tarjeta de viaje -->
            <div class="col-md-4">
                <div class="card shadow-sm border-0 h-100">
                    <img src="<%= img %>" class="card-img-top" alt="<%= p.getDestino() %>">
                    <div class="card-body">
                        <h5 class="card-title text-primary"><%= p.getNombre() %></h5>

                        <p class="text-muted mb-1">
                            <b><fmt:message key="viajes.card.destination"/>:</b> <%= p.getDestino() %>
                        </p>

                        <p class="text-muted mb-1">
                            <b><fmt:message key="viajes.card.departure"/>:</b> <%= p.getFechaSalida() %><br>
                            <b><fmt:message key="viajes.card.return"/>:</b> <%= p.getFechaRetorno() %>
                        </p>

                        <div class="star-rating mb-2"><%= estrellas.toString() %></div>

                        <p class="small text-muted"><%= p.getDescripcion() %></p>

                        <h4 class="text-primary fw-bold">S/. <%= p.getPrecio() %></h4>
                        <small class="text-muted">
                            <fmt:message key="viajes.card.taxes"/>
                        </small>
                    </div>

                    <!-- Formulario de reserva -->
                    <div class="card-footer text-center bg-white border-0 pb-4">
                        <form action="<%= request.getContextPath() %>/ReservaServlet" method="post" class="px-3">
                            <input type="hidden" name="action" value="registrar">
                            <input type="hidden" name="idPaquete" value="<%= p.getId() %>">
                            <input type="hidden" name="total" value="<%= p.getPrecio() %>">

                            <select name="metodoPago" class="form-select mb-2" required>
                                <option value="" disabled selected>
                                    <fmt:message key="viajes.payment.select"/>
                                </option>

                                <option value="tarjeta">
                                    <fmt:message key="viajes.payment.card"/>
                                </option>
                                <option value="yape">
                                    <fmt:message key="viajes.payment.yape"/>
                                </option>
                                <option value="plin">
                                    <fmt:message key="viajes.payment.plin"/>
                                </option>
                                <option value="transferencia">
                                    <fmt:message key="viajes.payment.transfer"/>
                                </option>
                            </select>

                            <button type="submit" class="btn btn-outline-primary w-100">
                                <i class="bi bi-credit-card me-2"></i>
                                <fmt:message key="viajes.reserveButton"/>
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
                <div class="alert alert-warning shadow-sm">
                    <fmt:message key="viajes.noPackages"/>
                </div>
            </div>

            <%
                }
            %>

        </div>
    </div>
</section>

<!-- Footer -->
<footer class="bg-dark text-white text-center py-3 mt-5">
    <p>&copy; <fmt:message key="viajes.footer"/></p>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
