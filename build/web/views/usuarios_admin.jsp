<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.movilvanperu.model.Usuario" %>
<%@ page import="com.movilvanperu.facade.SistemaViajesFacade" %>

<%
    // 🔒 Solo admin
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"admin".equalsIgnoreCase(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    SistemaViajesFacade facade = new SistemaViajesFacade();
    List<Usuario> listaUsuarios = facade.listarUsuarios();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Usuarios - Movil Van Perú</title>
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

<!-- Contenido principal -->
<div class="content p-4">
    <h1 class="mb-4">Gestión de Usuarios 👥</h1>

    <!-- Botón agregar -->
    <button class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#modalAgregar">
        <i class="bi bi-person-plus"></i> Agregar Administrador
    </button>

    <!-- Mensaje de éxito -->
    <% if (request.getParameter("msg") != null && request.getParameter("msg").equals("ok")) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            Administrador registrado correctamente.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <div class="table-responsive shadow-sm rounded bg-white p-3">
        <table class="table table-striped align-middle">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Correo</th>
                    <th>Rol</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% if (listaUsuarios != null && !listaUsuarios.isEmpty()) { 
                    for (Usuario u : listaUsuarios) { %>
                    <tr>
                        <td><%= u.getId() %></td>
                        <td><%= u.getNombre() %></td>
                        <td><%= u.getCorreo() %></td>
                        <td>
                            <span class="badge <%= "admin".equalsIgnoreCase(u.getRol()) ? "bg-danger" : "bg-secondary" %>">
                                <%= u.getRol() %>
                            </span>
                        </td>
                        <td>
                            <% if (!"admin".equalsIgnoreCase(u.getRol())) { %>
                                <button class="btn btn-outline-danger btn-sm" onclick="confirmarEliminar(<%= u.getId() %>)">
                                    <i class="bi bi-trash"></i> Eliminar
                                </button>
                            <% } else { %>
                                <span class="text-muted">Admin</span>
                            <% } %>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr><td colspan="5" class="text-center text-muted">No hay usuarios registrados</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal Agregar Administrador -->
<div class="modal fade" id="modalAgregar" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form action="<%= request.getContextPath() %>/UsuarioServlet" method="post" class="modal-content">
            <input type="hidden" name="action" value="registrarAdmin">

            <div class="modal-header bg-success text-white">
                <h5 class="modal-title"><i class="bi bi-person-plus"></i> Agregar Administrador</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <div class="mb-3">
                    <label>Nombre</label>
                    <input type="text" name="nombre" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Apellido (opcional)</label>
                    <input type="text" name="apellido" class="form-control">
                </div>
                <div class="mb-3">
                    <label>Correo</label>
                    <input type="email" name="correo" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Usuario</label>
                    <input type="text" name="usuario" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Contraseña</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
            </div>

            <div class="modal-footer">
                <button type="submit" class="btn btn-success"><i class="bi bi-check-circle"></i> Registrar</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
            </div>
        </form>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
function confirmarEliminar(id) {
    Swal.fire({
        title: "¿Eliminar usuario?",
        text: "Esta acción no se puede deshacer.",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#d33",
        cancelButtonColor: "#6c757d",
        confirmButtonText: "Sí, eliminar"
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = "<%= request.getContextPath() %>/UsuarioServlet?action=eliminar&id=" + id;
        }
    });
}
</script>

</body>
</html>
