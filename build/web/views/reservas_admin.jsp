<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
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
    List<Map<String, Object>> reservas = facade.listarTodasLasReservas();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Reservas - Movil Van Perú</title>
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
    <a href="<%= request.getContextPath() %>/views/dashboard.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="<%= request.getContextPath() %>/views/paquetes.jsp"><i class="bi bi-airplane"></i> Paquetes</a>
    <a href="<%= request.getContextPath() %>/views/reservas_admin.jsp" class="active"><i class="bi bi-clipboard-check"></i> Reservas</a>
           <a href="<%= request.getContextPath() %>/views/admin-promociones.jsp"><i class="bi bi-gift"></i> Promoción</a>
           <a href="<%= request.getContextPath() %>/views/hotel_admin.jsp"><i class="bi bi-building"></i> Hoteles</a>
    <a href="<%= request.getContextPath() %>/views/usuarios_admin.jsp"><i class="bi bi-people"></i> Usuarios</a>
    <a href="<%= request.getContextPath() %>/views/rutas.jsp"><i class="bi bi-car-front"></i> Rutas</a>      
    <a href="<%= request.getContextPath() %>/UsuarioServlet?action=logout"><i class="bi bi-box-arrow-right"></i> Cerrar sesión</a>
</div>

<!-- Contenido principal -->
<div class="content p-4">
    <h1 class="mb-4">Gestión de Reservas 📋</h1>

    <div class="table-responsive shadow-sm rounded bg-white p-3">
        <table class="table table-striped align-middle">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Cliente</th>
                    <th>Paquete</th>
                    <th>Fecha Reserva</th>
                    <th>Total (S/)</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (reservas != null && !reservas.isEmpty()) {
                        for (Map<String, Object> r : reservas) {
                %>
                <tr>
                    <td><%= r.get("id_reserva") %></td>
                    <td><%= r.get("nombre_usuario") %></td>
                    <td><%= r.get("nombre_paquete") %></td>
                    <td><%= r.get("fecha_reserva") %></td>
                    <td>S/ <%= String.format("%.2f", (Double) r.get("total")) %></td>
                    <td>
                        <span class="badge bg-<%= "pagada".equals(r.get("estado")) ? "success" :
                                                   "pendiente".equals(r.get("estado")) ? "warning" :
                                                   "cancelada".equals(r.get("estado")) ? "danger" : "secondary" %>">
                            <%= r.get("estado") %>
                        </span>
                    </td>
                    <td>
                        <!-- 🛠 Botón Editar -->
                        <button class="btn btn-outline-primary btn-sm"
                            onclick="editarReserva(<%= r.get("id_reserva") %>, '<%= r.get("estado") %>')">
                            <i class="bi bi-pencil"></i> Editar
                        </button>

                        <!-- 🗑 Botón Eliminar -->
                        <button class="btn btn-outline-danger btn-sm"
                            onclick="confirmarEliminar(<%= r.get("id_reserva") %>)">
                            <i class="bi bi-trash"></i> Eliminar
                        </button>
                    </td>
                </tr>
                <% } } else { %>
                <tr><td colspan="7" class="text-center">No hay reservas registradas.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal Editar Estado -->
<div class="modal fade" id="modalEditarReserva" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <!-- ✅ Se elimina EditarReservaServlet y se usa fetch -->
            <form id="formEditarReserva">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title"><i class="bi bi-pencil-square"></i> Editar Estado de Reserva</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="edit_id_reserva" name="id_reserva">

                    <div class="mb-3">
                        <label class="form-label">Estado:</label>
                        <select id="edit_estado" name="estado" class="form-select">
                            <option value="pendiente">Pendiente</option>
                            <option value="activa">Activa</option>
                            <option value="pagada">Pagada</option>
                            <option value="cancelada">Cancelada</option>
                            <option value="finalizada">Finalizada</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-success"><i class="bi bi-save"></i> Guardar</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
function editarReserva(id, estado) {
    document.getElementById('edit_id_reserva').value = id;
    document.getElementById('edit_estado').value = estado;
    new bootstrap.Modal(document.getElementById('modalEditarReserva')).show();
}

// ✅ Acción de guardar cambios en reserva
document.getElementById("formEditarReserva").addEventListener("submit", function (e) {
    e.preventDefault();

    const id = document.getElementById("edit_id_reserva").value;
    const estado = document.getElementById("edit_estado").value;

    fetch("<%= request.getContextPath() %>/ReservaServlet?action=editar", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "id_reserva=" + encodeURIComponent(id) + "&estado=" + encodeURIComponent(estado)
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            Swal.fire({
                icon: "success",
                title: "Actualizado",
                text: data.message,
                showConfirmButton: false,
                timer: 1200
            });
            setTimeout(() => location.reload(), 1200);
        } else {
            Swal.fire("Error", data.message, "error");
        }
    })
    .catch(err => {
        Swal.fire("Error", "No se pudo conectar con el servidor.", "error");
    });
});

// 🗑️ Eliminar reserva
function confirmarEliminar(id) {
    Swal.fire({
        title: '¿Eliminar reserva?',
        text: 'Esta acción no se puede deshacer.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Sí, eliminar',
        cancelButtonText: 'Cancelar'
    }).then(result => {
        if (result.isConfirmed) {
            fetch("<%= request.getContextPath() %>/ReservaServlet?action=eliminar&id=" + id, {
                method: "GET"
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Eliminado',
                        text: data.message,
                        showConfirmButton: false,
                        timer: 1300
                    });
                    setTimeout(() => location.reload(), 1300);
                } else {
                    Swal.fire("Error", data.message, "error");
                }
            })
            .catch(() => {
                Swal.fire("Error", "No se pudo conectar con el servidor.", "error");
            });
        }
    });
}
</script>

</body>
</html>
