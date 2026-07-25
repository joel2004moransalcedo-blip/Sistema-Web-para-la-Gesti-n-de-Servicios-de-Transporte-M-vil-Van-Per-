<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.movilvanperu.model.Usuario" %>
<%@ page import="com.movilvanperu.dao.PaqueteDAO" %>
<%@ page import="com.movilvanperu.model.Paquete" %>
<%@ page import="java.util.List" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"admin".equalsIgnoreCase(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    PaqueteDAO dao = new PaqueteDAO();
    List<Paquete> lista = dao.listar();

    String mensaje = (String) session.getAttribute("mensaje");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("mensaje");
    session.removeAttribute("error");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Paquetes - Movil Van Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/views/css/admin.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .stars i {
            color: #f1c40f;
            font-size: 1.1rem;
        }
        .rating-input {
            display: flex;
            flex-direction: row-reverse;
            justify-content: center;
            gap: 5px;
        }
        .rating-input input {
            display: none;
        }
        .rating-input label {
            font-size: 1.5rem;
            color: #ccc;
            cursor: pointer;
            transition: color 0.2s;
        }
        .rating-input input:checked ~ label,
        .rating-input label:hover,
        .rating-input label:hover ~ label {
            color: #f1c40f;
        }
    </style>
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
        <h1 class="mb-4">Gestión de Paquetes ✈️</h1>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="text-secondary">Listado de Paquetes</h4>
            <button class="btn btn-primary" onclick="abrirModal()">
                <i class="bi bi-plus-circle"></i> Nuevo Paquete
            </button>
        </div>

        <!-- Tabla -->
        <div class="table-responsive shadow-sm rounded">
            <table class="table table-striped align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Imagen</th>
                        <th>Nombre</th>
                        <th>Destino</th>
                        <th>Precio</th>
                        <th>Salida</th>
                        <th>Retorno</th>
                        <th>Valoración</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Paquete p : lista) {
                            int estrellas = p.getValoracion(); // valor 1-5
                    %>
                        <tr>
                            <td><%= p.getId() %></td>
                            <td>
                                <img src="<%= request.getContextPath() %>/<%= p.getImagen1() %>"
                                     class="img-thumbnail"
                                     style="width:80px;height:60px;object-fit:cover;">
                            </td>
                            <td><%= p.getNombre() %></td>
                            <td><%= p.getDestino() %></td>
                            <td>S/ <%= String.format("%.2f", p.getPrecio()) %></td>
                            <td><%= p.getFechaSalida() %></td>
                            <td><%= p.getFechaRetorno() %></td>
                            <td>
                                <div class="stars">
                                    <% for (int i = 1; i <= 5; i++) { %>
                                        <% if (i <= estrellas) { %>
                                            <i class="bi bi-star-fill"></i>
                                        <% } else { %>
                                            <i class="bi bi-star"></i>
                                        <% } %>
                                    <% } %>
                                </div>
                            </td>
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

    <!-- Modales -->
    <%@ include file="paquete_form.jsp" %>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        <% if (mensaje != null) { %>
            Swal.fire({ icon: 'success', title: 'Éxito', text: '<%= mensaje %>', confirmButtonColor: '#3085d6' });
        <% } else if (error != null) { %>
            Swal.fire({ icon: 'error', title: 'Error', text: '<%= error %>', confirmButtonColor: '#d33' });
        <% } %>

        function abrirModal() {
            new bootstrap.Modal(document.getElementById('modalPaquete')).show();
        }
        function cerrarModal() {
            bootstrap.Modal.getInstance(document.getElementById('modalPaquete')).hide();
        }

        function abrirEditar(id, nombre, descripcion, destino, precio, salida, retorno, valoracion) {
            document.getElementById('edit_id').value = id;
            document.getElementById('edit_nombre').value = nombre;
            document.getElementById('edit_descripcion').value = descripcion;
            document.getElementById('edit_destino').value = destino;
            document.getElementById('edit_precio').value = precio;
            document.getElementById('edit_fecha_salida').value = salida;
            document.getElementById('edit_fecha_retorno').value = retorno;

            // Marcar la valoración en estrellas
            document.querySelectorAll('.edit-rating input').forEach(r => r.checked = (r.value == valoracion));

            new bootstrap.Modal(document.getElementById('modalEditarPaquete')).show();
        }

        function cerrarModalEditar() {
            bootstrap.Modal.getInstance(document.getElementById('modalEditarPaquete')).hide();
        }

function confirmarEliminar(id) {
    Swal.fire({
        title: '¿Eliminar paquete?',
        text: "Esta acción no se puede deshacer.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Sí, eliminar',
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        if (result.isConfirmed) {
            fetch('<%= request.getContextPath() %>/PaqueteServlet?accion=eliminar&id=' + id, {
                method: 'GET'
            })
            .then(response => response.json()) // Esperamos JSON del servidor
            .then(data => {
                if (data.success) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Eliminado',
                        text: data.message || '🗑️ Paquete eliminado correctamente.',
                        confirmButtonColor: '#3085d6',
                        timer: 1500,
                        showConfirmButton: false
                    }).then(() => location.reload());
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: data.message || 'No se pudo eliminar el paquete.',
                        confirmButtonColor: '#d33'
                    });
                }
            })
            .catch(() => {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Error de conexión con el servidor.',
                    confirmButtonColor: '#d33'
                });
            });
        }
    });
}

    </script>

</body>
</html>
