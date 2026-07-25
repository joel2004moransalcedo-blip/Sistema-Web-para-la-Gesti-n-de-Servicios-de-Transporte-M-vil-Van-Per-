<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.movilvanperu.model.*" %>
<%@ page import="com.movilvanperu.facade.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Confirmar Reserva | Movil Van Perú</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/views/css/style.css" rel="stylesheet">

    <style>
        .hero {
            background-color: #002b5c;
            color: white;
            padding: 40px 0;
            text-align: center;
        }
        .carousel-inner img {
            height: 350px;
            object-fit: cover;
            border-radius: 10px;
        }
        .paquete-info {
            background-color: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            border: 1px solid #ddd;
        }
        .precio {
            font-size: 1.8rem;
            font-weight: bold;
            color: #007bff;
        }
        .form-control, .form-select {
            border-radius: 8px;
        }
        .btn-success {
            font-size: 1.1rem;
            padding: 12px;
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp"/>

<%
    // ✅ Verificar sesión
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // ✅ Obtener paquete seleccionado
    String idParam = request.getParameter("idPaquete");
    int idPaquete = (idParam != null) ? Integer.parseInt(idParam) : 0;

    SistemaViajesFacade facade = new SistemaViajesFacade();
    Paquete paquete = facade.obtenerPaquetePorId(idPaquete);

    if (paquete == null) {
%>
    <div class="container text-center py-5">
        <div class="alert alert-danger">
            El paquete seleccionado no existe o fue eliminado.
        </div>
        <a href="viajes.jsp" class="btn btn-primary">Volver a los viajes</a>
    </div>
<%
        return;
    }
%>

<header class="hero">
    <div class="container">
        <h1>Confirmar tu reserva 🌍</h1>
        <p class="lead mb-0">Revisa los detalles antes de confirmar tu viaje</p>
    </div>
</header>

<section class="py-5">
    <div class="container">
        <div class="row g-4 align-items-start">

            <!-- 🖼️ Carrusel de imágenes del paquete -->
            <div class="col-md-6">
                <div id="carouselPaquete" class="carousel slide shadow rounded" data-bs-ride="carousel">
                    <div class="carousel-inner">
                        <%
                            String[] imagenes = {
                                paquete.getImagen1(),
                                paquete.getImagen2(),
                                paquete.getImagen3()
                            };
                            boolean tieneImagen = false;
                            int index = 0;
                            for (String img : imagenes) {
                                if (img != null && !img.isEmpty()) {
                                    tieneImagen = true;
                        %>
                            <div class="carousel-item <%= index == 0 ? "active" : "" %>">
                                <img src="<%= request.getContextPath() + "/" + img %>" class="d-block w-100" alt="Imagen del paquete">
                            </div>
                        <%
                                    index++;
                                }
                            }

                            if (!tieneImagen) {
                        %>
                            <div class="carousel-item active">
                                <img src="<%= request.getContextPath() + "/views/images/default.jpg" %>" class="d-block w-100" alt="Imagen por defecto">
                            </div>
                        <% } %>
                    </div>

                    <!-- Controles del carrusel -->
                    <button class="carousel-control-prev" type="button" data-bs-target="#carouselPaquete" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon"></span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#carouselPaquete" data-bs-slide="next">
                        <span class="carousel-control-next-icon"></span>
                    </button>
                </div>
            </div>

            <!-- 📋 Información del paquete y formulario -->
            <div class="col-md-6">
                <div class="paquete-info shadow-sm bg-white">
                    <h3 class="text-primary mb-3"><%= paquete.getNombre() %></h3>
                    <p><strong>Destino:</strong> <%= paquete.getDestino() %></p>
                    <p><strong>Fechas:</strong> <%= paquete.getFechaSalida() %> → <%= paquete.getFechaRetorno() %></p>
                    <p><%= paquete.getDescripcion() %></p>
                    <p class="precio mb-4">S/. <%= paquete.getPrecio() %></p>
                    <hr>

                    <form action="<%= request.getContextPath() %>/ReservaServlet" method="post">
                        <input type="hidden" name="action" value="crear">
                        <input type="hidden" name="idPaquete" value="<%= paquete.getId() %>">

                        <!-- Método de pago -->
                        <div class="mb-3">
                            <label class="form-label">Método de pago</label>
                            <select class="form-select" name="metodoPago" required>
                                <option value="">-- Selecciona un método --</option>
                                <option value="tarjeta">Tarjeta</option>
                                <option value="yape">Yape</option>
                                <option value="plin">Plin</option>
                                <option value="transferencia">Transferencia bancaria</option>
                            </select>
                        </div>

                        <!-- Número de tarjeta (opcional) -->
                        <div class="mb-3">
                            <label class="form-label">Número de tarjeta (opcional)</label>
                            <input type="text" name="numeroTarjeta" maxlength="20" class="form-control" placeholder="Ejemplo: 4111 2222 3333 4444">
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-success btn-lg">
                                Confirmar Reserva
                            </button>
                            <a href="viajes.jsp" class="btn btn-outline-secondary btn-lg">Cancelar</a>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>
</section>

<footer class="bg-dark text-white text-center py-3 mt-5">
    <p>&copy; 2025 Movil Van Perú - Todos los derechos reservados</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
