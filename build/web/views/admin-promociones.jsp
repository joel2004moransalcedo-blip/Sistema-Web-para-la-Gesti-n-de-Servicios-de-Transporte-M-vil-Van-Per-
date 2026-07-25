<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.movilvanperu.model.Usuario" %>
<%@ page import="com.movilvanperu.model.Paquete" %>
<%@ page import="com.movilvanperu.model.Promocion" %>
<%@ page import="com.movilvanperu.facade.SistemaViajesFacade" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"admin".equalsIgnoreCase(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    SistemaViajesFacade facade = new SistemaViajesFacade();
    List<Paquete> paquetes = facade.listarPaquetes();
    List<Promocion> promociones = facade.listarPromocionesActivas();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Administrar Promociones - Movil Van Perú</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/views/css/admin.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

<div class="sidebar">
    <div class="logo-container">
        <img src="<%= request.getContextPath() %>/views/images/logos.png" alt="Logo MovilVanPeru" class="admin-logo">
    </div>

    <a href="<%= request.getContextPath() %>/views/dashboard.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="<%= request.getContextPath() %>/views/paquetes.jsp"><i class="bi bi-airplane"></i> Paquetes</a>
    <a href="<%= request.getContextPath() %>/views/reservas_admin.jsp"><i class="bi bi-clipboard-check"></i> Reservas</a>
    <a href="<%= request.getContextPath() %>/views/admin-promociones.jsp" class="active"><i class="bi bi-gift"></i> Promoción</a>
    <a href="<%= request.getContextPath() %>/views/hotel_admin.jsp"><i class="bi bi-building"></i> Hoteles</a>
    <a href="<%= request.getContextPath() %>/views/usuarios_admin.jsp"><i class="bi bi-people"></i> Usuarios</a>
    <a href="<%= request.getContextPath() %>/views/rutas.jsp"><i class="bi bi-car-front"></i> Rutas</a>
    <a href="<%= request.getContextPath() %>/UsuarioServlet?action=logout"><i class="bi bi-box-arrow-right"></i> Cerrar sesión</a>
</div>

<div class="content p-4">

    <h2 class="mb-4"><i class="bi bi-gift"></i> Gestión de Promociones</h2>

    <div class="d-flex justify-content-between mb-3">
        <h4>Promociones activas</h4>

        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalNuevaPromo">
            <i class="bi bi-plus-circle"></i> Nueva Promoción
        </button>
    </div>

    <div class="card p-3">
        <div class="table-responsive">
            <table class="table table-striped table-hover text-center align-middle">
                <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Banner</th>
                    <th>Nombre</th>
                    <th>Paquete Gratis</th>
                    <th>Requiere</th>
                    <th>Estado</th>
                    <th>Creada</th>
                    <th>Acciones</th>
                </tr>
                </thead>

                <tbody>
                <% for (Promocion promo : promociones) { %>
                    <tr>
                        <td><%= promo.getId() %></td>

                        <td>
                            <img src="<%= request.getContextPath() %>/views/images/<%= promo.getBanner() %>"
                                 style="width:120px; height:60px; object-fit:cover; border-radius:6px;">
                        </td>

                        <td><%= promo.getNombre() %></td>
                        <td><%= promo.getPaqueteGratisNombre() %></td>
                        <td><%= promo.getCantidadReservasRequerida() %> reservas</td>

                        <td>
                            <span class="badge bg-success">Activa</span>
                        </td>

                        <td><%= promo.getCreadaEn() %></td>

                        <td>
                            <button class="btn btn-warning btn-sm"
                                    data-bs-toggle="modal"
                                    data-bs-target="#modalEditarPromo_<%= promo.getId() %>">
                                <i class="bi bi-pencil-square"></i>
                            </button>

                            <button class="btn btn-danger btn-sm"
                                    onclick="eliminarPromocion(<%= promo.getId() %>)">
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


<!-- =======================
     MODAL NUEVA PROMOCIÓN
========================= -->
<div class="modal fade" id="modalNuevaPromo" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <form class="modal-content" action="<%= request.getContextPath() %>/crearPromocion" method="post" enctype="multipart/form-data">

            <div class="modal-header">
                <h5 class="modal-title">Crear Nueva Promoción</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">

                <div class="mb-3">
                    <label>Nombre de la promoción</label>
                    <input type="text" name="nombre" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label>Descripción</label>
                    <textarea name="descripcion" class="form-control" rows="3" required></textarea>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label>Paquete gratis</label>
                        <select name="idPaqueteGratis" class="form-select" required>
                            <option value="">Seleccione...</option>
                            <% for (Paquete p : paquetes) { %>
                                <option value="<%= p.getId() %>"><%= p.getNombre() %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label>Cantidad de reservas requeridas</label>
                        <input type="number" name="cantidadReservas" class="form-control" min="1" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label>Banner (imagen)</label>
                    <input type="file" name="banner" class="form-control">
                </div>

                <!-- 🔥 AGREGADO: ESTADO EN CREAR -->
                <div class="mb-3">
                    <label>Estado</label>
                    <select name="estado" class="form-select" required>
                        <option value="activa">Activa</option>
                        <option value="inactiva">Inactiva</option>
                    </select>
                </div>

                <hr>

                <div class="row">
                    <div class="col-md-6">
                        <label>Fecha Inicio</label>
                        <input type="date" name="fechaInicio" class="form-control" required>
                    </div>

                    <div class="col-md-6">
                        <label>Fecha Fin</label>
                        <input type="date" name="fechaFin" class="form-control" required>
                    </div>
                </div>

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="btn btn-primary">Crear Promoción</button>
            </div>

        </form>
    </div>
</div>


<!-- =======================
   MODALES DINÁMICOS EDITAR
========================= -->
<% for (Promocion promo : promociones) { %>
<div class="modal fade" id="modalEditarPromo_<%= promo.getId() %>" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <form class="modal-content"
              action="<%= request.getContextPath() %>/editarPromocion"
              method="post" enctype="multipart/form-data">

            <input type="hidden" name="id" value="<%= promo.getId() %>">

            <div class="modal-header">
                <h5 class="modal-title">Editar Promoción</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">

                <div class="mb-3">
                    <label>Nombre</label>
                    <input type="text" name="nombre" class="form-control" value="<%= promo.getNombre() %>" required>
                </div>

                <div class="mb-3">
                    <label>Descripción</label>
                    <textarea name="descripcion" class="form-control" rows="3" required><%= promo.getDescripcion() %></textarea>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label>Paquete Gratis</label>
                        <select name="idPaqueteGratis" class="form-select" required>
                            <% for (Paquete p : paquetes) { %>
                                <option value="<%= p.getId() %>"
                                    <%= (p.getId() == promo.getIdPaqueteGratis() ? "selected" : "") %>>
                                    <%= p.getNombre() %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label>Cantidad de reservas requeridas</label>
                        <input type="number" name="cantidadReservas" class="form-control"
                               value="<%= promo.getCantidadReservasRequerida() %>" required>
                    </div>
                </div>

                <div>
                    <label>Banner actual:</label><br>
                    <img src="<%= request.getContextPath() %>/views/images/<%= promo.getBanner() %>"
                         style="width:120px; height:60px; object-fit:cover; border-radius:6px;">
                </div>

                <div class="mb-3 mt-2">
                    <label>Nuevo banner (opcional)</label>
                    <input type="file" name="banner" class="form-control">
                </div>

                <!-- 🔥 AGREGADO: ESTADO EN EDITAR -->
                <div class="mb-3">
                    <label>Estado</label>
                    <select name="estado" class="form-select" required>
                        <option value="activa" <%= ("activa".equalsIgnoreCase(promo.getEstado()) ? "selected" : "") %>>Activa</option>
                        <option value="inactiva" <%= ("inactiva".equalsIgnoreCase(promo.getEstado()) ? "selected" : "") %>>Inactiva</option>
                    </select>
                </div>

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="btn btn-primary">Guardar cambios</button>
            </div>

        </form>
    </div>
</div>
<% } %>


<script>
function eliminarPromocion(id) {
    Swal.fire({
        title: "¿Eliminar promoción?",
        text: "Esta acción no se puede deshacer",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Eliminar",
        cancelButtonText: "Cancelar"
    }).then((result) => {
        if (result.isConfirmed) {
            window.location = "<%= request.getContextPath() %>/eliminarPromocion?id=" + id;
        }
    });
}
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
