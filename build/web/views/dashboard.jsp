<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.*" %>
<%@ page import="com.movilvanperu.model.Usuario" %>
<%@ page import="com.movilvanperu.model.Paquete" %>
<%@ page import="com.movilvanperu.facade.SistemaViajesFacade" %>


<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"admin".equalsIgnoreCase(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    SistemaViajesFacade facade = new SistemaViajesFacade();
    List<Paquete> ultimosPaquetes = facade.listarPaquetes();
    if (ultimosPaquetes.size() > 3) {
        ultimosPaquetes = ultimosPaquetes.subList(ultimosPaquetes.size() - 3, ultimosPaquetes.size());
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel de Administración - Movil Van Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/views/css/admin.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="logo-container">
            <img src="<%= request.getContextPath() %>/views/images/logos.png" alt="Logo MovilVanPeru" class="admin-logo">
        </div>
        <a href="<%= request.getContextPath() %>/views/dashboard.jsp" class="active"><i class="bi bi-speedometer2"></i> Dashboard</a>
        <a href="<%= request.getContextPath() %>/views/paquetes.jsp"><i class="bi bi-airplane"></i> Paquetes</a>
       <a href="<%= request.getContextPath() %>/views/reservas_admin.jsp"><i class="bi bi-clipboard-check"></i> Reservas</a>
       <a href="<%= request.getContextPath() %>/views/admin-promociones.jsp"><i class="bi bi-gift"></i> Promoción</a>
       <a href="<%= request.getContextPath() %>/views/hotel_admin.jsp"><i class="bi bi-building"></i> Hoteles</a>
        <a href="<%= request.getContextPath() %>/views/usuarios_admin.jsp"><i class="bi bi-people"></i> Usuarios</a>
        <a href="<%= request.getContextPath() %>/views/rutas.jsp"><i class="bi bi-car-front"></i> Rutas</a>      
        <a href="<%= request.getContextPath() %>/UsuarioServlet?action=logout"><i class="bi bi-box-arrow-right"></i> Cerrar sesión</a>
    </div>

    <!-- Contenido principal -->r
    <div class="content p-4">
        <h1 class="mb-4">Bienvenido, <%= usuario.getNombre() %> 👋</h1>

        <!-- Estadísticas rápidas -->
        <div class="stats-grid mb-4">
            <div class="card">
                <h3><i class="bi bi-airplane"></i> Paquetes</h3>
                <p>Gestionar paquetes de viaje (agregar, editar, eliminar)</p>
                <a href="<%= request.getContextPath() %>/views/paquetes.jsp" class="btn-admin">Administrar</a>
            </div>
            <div class="card">
                <h3><i class="bi bi-person-lines-fill"></i> Usuarios</h3>
                <p>Ver lista de usuarios registrados</p>
                <a href="<%= request.getContextPath() %>/views/usuarios_admin.jsp" class="btn-admin">Administrar</a>
            </div>
            <div class="card">
                <h3><i class="bi bi-building"></i> Reservas</h3>
                <p>Administrar Reservas de los viajeros</p>
                <a href="<%= request.getContextPath() %>/views/reservas_admin.jsp" class="btn-admin">Administrar</a>
            </div>
            <div class="card">
                <h3><i class="bi bi-truck"></i> Monitor de rutas</h3>
                <p>Ver horarios de salida / llegada de vans</p>
                <a href="<%= request.getContextPath() %>/views/rutas.jsp" class="btn-admin">Ver rutas</a>
            </div>
        </div>

        <hr>

        <!-- Últimos paquetes -->
        <div class="card mt-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h3><i class="bi bi-briefcase"></i> Últimos Paquetes</h3>
                <button class="btn btn-primary" onclick="abrirModalNuevo()">
                    <i class="bi bi-plus-circle"></i> Nuevo Paquete
                </button>
            </div>

            <div class="table-responsive">
                <table class="table table-striped align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Imagen</th>
                            <th>Nombre</th>
                            <th>Destino</th>
                            <th>Precio</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Paquete p : ultimosPaquetes) {
                        %>
                        <tr>
                            <td><%= p.getId() %></td>
                            <td>
                                <img src="<%= request.getContextPath() %>/<%= p.getImagen1() != null ? p.getImagen1() : "views/images/default.jpg" %>"
                                     alt="Paquete"
                                     style="width: 80px; height: 60px; object-fit: cover; border-radius: 6px;">
                            </td>
                            <td><%= p.getNombre() %></td>
                            <td><%= p.getDestino() %></td>
                            <td>S/ <%= String.format("%.2f", p.getPrecio()) %></td>
                            <td>
                                <button class="btn btn-success btn-sm"
                                    onclick="abrirEditar(<%= p.getId() %>, '<%= p.getNombre().replace("'", "\\'") %>', '<%= p.getDescripcion().replace("'", "\\'") %>', '<%= p.getDestino() %>', <%= p.getPrecio() %>, '<%= p.getFechaSalida() %>', '<%= p.getFechaRetorno() %>', <%= p.getValoracion() %>)">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn btn-danger btn-sm" onclick="confirmarEliminar(<%= p.getId() %>)">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal incluir -->
    <%@ include file="paquete_form.jsp" %>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function abrirModalNuevo() {
            new bootstrap.Modal(document.getElementById('modalPaquete')).show();
        }
function cerrarModal() {
    const modal = document.getElementById('modalPaquete');
    const modalInstance = bootstrap.Modal.getInstance(modal);
    if (modalInstance) modalInstance.hide();
}

function cerrarModalEditar() {
    const modal = document.getElementById('modalEditarPaquete');
    const modalInstance = bootstrap.Modal.getInstance(modal);
    if (modalInstance) modalInstance.hide();
}
        function abrirEditar(id, nombre, descripcion, destino, precio, salida, retorno, valoracion) {
            document.getElementById('edit_id').value = id;
            document.getElementById('edit_nombre').value = nombre;
            document.getElementById('edit_descripcion').value = descripcion;
            document.getElementById('edit_destino').value = destino;
            document.getElementById('edit_precio').value = precio;
            document.getElementById('edit_fecha_salida').value = salida;
            document.getElementById('edit_fecha_retorno').value = retorno;
            document.querySelectorAll('.edit-rating input').forEach(r => r.checked = (r.value == valoracion));
            new bootstrap.Modal(document.getElementById('modalEditarPaquete')).show();
        }

function confirmarEliminar(id) {
    Swal.fire({
        title: "¿Eliminar paquete?",
        text: "Esta acción no se puede deshacer.",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#d33",
        cancelButtonColor: "#6c757d",
        confirmButtonText: "Sí, eliminar",
        cancelButtonText: "Cancelar"
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = "<%= request.getContextPath() %>/PaqueteServlet?accion=eliminar&id=" + id;
        }
    });
}

    </script>

</body>
</html>
