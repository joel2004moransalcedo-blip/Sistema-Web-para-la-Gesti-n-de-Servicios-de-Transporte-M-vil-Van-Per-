<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="com.movilvanperu.model.Usuario" %>
<%@ page import="com.movilvanperu.facade.SistemaViajesFacade" %>


<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"admin".equalsIgnoreCase(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    SistemaViajesFacade facade = new SistemaViajesFacade();
    List<Map<String, Object>> rutas = facade.listarPaquetesConFechas();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Rutas - Movil Van Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/views/css/admin.css" rel="stylesheet">

    <style>
        .ruta-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            margin-bottom: 25px;
            padding: 20px;
            position: relative;
            overflow: hidden;
            border-left: 6px solid #0d6efd;
            transition: all 0.3s ease;
        }

        .car-container {
            position: relative;
            height: 50px;
            margin-top: 10px;
        }

        .car {
            position: absolute;
            left: 0;
            top: 0;
            font-size: 30px;
            transition: left 6s linear;
        }

        .road {
            height: 4px;
            background: #ccc;
            margin-top: 25px;
            border-radius: 2px;
        }

        .countdown {
            font-weight: bold;
            color: #198754;
        }

        /* 🌍 Mapa simple */
        .mapa-svg {
            width: 100%;
            height: 160px;
            margin-top: 15px;
        }

        .mapa-svg path {
            stroke-width: 3;
            fill: none;
            stroke-dasharray: 6;
            animation: moverRuta 2s linear infinite;
        }

        @keyframes moverRuta {
            to {
                stroke-dashoffset: -12;
            }
        }

        .punto-inicio, .punto-final {
            fill: #dc3545;
            stroke: #fff;
            stroke-width: 2;
        }

        .punto-final {
            fill: #198754;
        }

        .car-map {
            font-size: 20px;
            animation: moverCarroMapa 6s linear infinite alternate;
        }

        @keyframes moverCarroMapa {
            from { transform: translate(30px, 90px); }
            to { transform: translate(330px, 30px); }
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <div class="logo-container">
        <img src="<%= request.getContextPath() %>/views/images/logos.png" alt="Logo MovilVanPeru" class="admin-logo">
    </div>
    <a href="<%= request.getContextPath() %>/views/dashboard.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="<%= request.getContextPath() %>/views/paquetes.jsp"><i class="bi bi-airplane"></i> Paquetes</a>
    <a href="<%= request.getContextPath() %>/views/reservas_admin.jsp"><i class="bi bi-clipboard-check"></i> Reservas</a>
           <a href="<%= request.getContextPath() %>/views/admin-promociones.jsp"><i class="bi bi-gift"></i> Promoción</a>
           <a href="<%= request.getContextPath() %>/views/hotel_admin.jsp"><i class="bi bi-building"></i> Hoteles</a>
    <a href="<%= request.getContextPath() %>/views/usuarios_admin.jsp"><i class="bi bi-people"></i> Usuarios</a>
    <a href="<%= request.getContextPath() %>/views/rutas.jsp"><i class="bi bi-car-front"></i> Rutas</a>  
    <a href="<%= request.getContextPath() %>/UsuarioServlet?action=logout"><i class="bi bi-box-arrow-right"></i> Cerrar sesión</a>
</div>

<!-- Contenido -->
<div class="content p-4">
    <h1 class="mb-4">📍 Rutas y Fechas de Salida</h1>

    <% if (rutas != null && !rutas.isEmpty()) { 
        for (Map<String, Object> r : rutas) { 
            String salida = String.valueOf(r.get("fecha_salida"));
            String retorno = String.valueOf(r.get("fecha_retorno"));

            LocalDate salidaDate = LocalDate.parse(salida);
            LocalDate retornoDate = LocalDate.parse(retorno);
            LocalDate hoy = LocalDate.now();

            long diasRestantes = ChronoUnit.DAYS.between(hoy, salidaDate);
            long duracion = ChronoUnit.DAYS.between(salidaDate, retornoDate);

            String estadoViaje;
            if (hoy.isBefore(salidaDate)) {
                estadoViaje = "pendiente";
            } else if (!hoy.isAfter(retornoDate)) {
                estadoViaje = "en curso";
            } else {
                estadoViaje = "finalizado";
            }

            String colorRuta = "#0d6efd"; // azul por defecto
            if ("en curso".equals(estadoViaje)) colorRuta = "#198754"; // verde
            if ("finalizado".equals(estadoViaje)) colorRuta = "#6c757d"; // gris
    %>
        <div class="ruta-card" data-estado="<%= estadoViaje %>">
            <h4><i class="bi bi-geo-alt text-danger"></i> <%= r.get("nombre_paquete") %></h4>
            <p><strong>Destino:</strong> <%= r.get("destino") %></p>
            <p><strong>Salida:</strong> <%= salida %> &nbsp; | &nbsp; <strong>Retorno:</strong> <%= retorno %></p>
            <p><strong>Duración:</strong> <%= duracion %> días</p>
            <p>
                <% if ("pendiente".equals(estadoViaje)) { %>
                    ⏳ Faltan <span class="countdown"><%= diasRestantes %></span> días para la salida.
                <% } else if ("en curso".equals(estadoViaje)) { %>
                    🚐 El viaje está en curso.
                <% } else { %>
                    ✅ Viaje finalizado.
                <% } %>
            </p>

            <!-- 🚗 Animación del carro en línea -->
            <div class="car-container">
                <div class="road"></div>
                <div class="car">🚗</div>
            </div>

            <!-- 🗺️ Mapa SVG animado con color según estado -->
            <svg class="mapa-svg" viewBox="0 0 400 150">
                <path d="M30 90 Q200 10 370 30" stroke="<%= colorRuta %>" />
                <circle class="punto-inicio" cx="30" cy="90" r="6" />
                <circle class="punto-final" cx="370" cy="30" r="6" />
                <text x="15" y="110" font-size="12" fill="#555">Inicio</text>
                <text x="340" y="55" font-size="12" fill="#555">Destino</text>
                <% if ("en curso".equals(estadoViaje)) { %>
                    <text class="car-map">🚐</text>
                <% } %>
            </svg>
        </div>
    <% } } else { %>
        <div class="alert alert-info">No hay rutas registradas.</div>
    <% } %>
</div>

<script>
document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll('.ruta-card').forEach(card => {
        const estado = card.dataset.estado;
        const car = card.querySelector('.car');

        // 🎨 Colores por estado
        if (estado === "pendiente") {
            card.style.borderLeft = "6px solid #0d6efd";
        } else if (estado === "en curso") {
            card.style.borderLeft = "6px solid #198754";
            setTimeout(() => { car.style.left = "90%"; }, 500);
        } else {
            card.style.borderLeft = "6px solid #6c757d";
        }
    });
});
</script>

</body>
</html>
