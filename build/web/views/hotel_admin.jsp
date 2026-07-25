<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.movilvanperu.model.Usuario" %>
<%@ page import="com.movilvanperu.dao.HotelDAO" %>
<%@ page import="com.movilvanperu.model.Hotel" %>
<%@ page import="java.util.List" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"admin".equalsIgnoreCase(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    HotelDAO dao = new HotelDAO();
    List<Hotel> lista = dao.listar();

    String mensaje = (String) session.getAttribute("mensaje");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("mensaje");
    session.removeAttribute("error");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Hoteles - MovilVan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/views/css/admin.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        .stars i, .stars-input i {
            color: #f1c40f;
            font-size: 1.3rem;
            cursor: pointer;
            transition: color 0.2s;
        }
        .stars-input {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-start;
            gap: 5px;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <div class="logo-container">
        <img src="<%= request.getContextPath() %>/views/images/logos.png" class="admin-logo">
    </div>
    <a href="<%= request.getContextPath() %>/views/dashboard.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="<%= request.getContextPath() %>/views/paquetes.jsp"><i class="bi bi-airplane"></i> Paquetes</a>
    <a href="<%= request.getContextPath() %>/views/reservas_admin.jsp"><i class="bi bi-clipboard-check"></i> Reservas</a>
    <a href="<%= request.getContextPath() %>/views/admin-promociones.jsp"><i class="bi bi-gift"></i> Promoción</a>
    <a class="active" href="<%= request.getContextPath() %>/views/hotel_admin.jsp"><i class="bi bi-building"></i> Hoteles</a>
    <a href="<%= request.getContextPath() %>/views/usuarios_admin.jsp"><i class="bi bi-people"></i> Usuarios</a>
    <a href="<%= request.getContextPath() %>/views/rutas.jsp"><i class="bi bi-car-front"></i> Rutas</a>
    <a href="<%= request.getContextPath() %>/UsuarioServlet?action=logout"><i class="bi bi-box-arrow-right"></i> Cerrar sesión</a>
</div>

<!-- Contenido principal -->
<div class="content p-4">
    <h1 class="mb-4">Gestión de Hoteles 🏨</h1>

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="text-secondary">Listado de Hoteles</h4>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalNuevo">
            <i class="bi bi-plus-circle"></i> Nuevo Hotel
        </button>
    </div>

    <!-- Tabla de hoteles -->
    <div class="table-responsive shadow-sm rounded">
        <table class="table table-striped align-middle">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Imágenes</th>
                    <th>Nombre</th>
                    <th>Ciudad</th>
                    <th>País</th>
                    <th>Estrellas</th>
                    <th>Precio (S/.)</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% for (Hotel h : lista) { %>
                <tr>
                    <td><%= h.getId_hotel() %></td>
                    <td>
                        <img src="<%= request.getContextPath() %>/views/images/<%= h.getImagen1() %>"
                             class="img-thumbnail" style="width:70px;height:60px;object-fit:cover;">
                    </td>
                    <td><%= h.getNombre() %></td>
                    <td><%= h.getCiudad() %></td>
                    <td><%= h.getPais() %></td>
                    <td>
                        <div class="stars">
                            <% for (int i = 1; i <= 5; i++) { %>
                                <% if (i <= h.getEstrellas()) { %>
                                    <i class="bi bi-star-fill"></i>
                                <% } else { %>
                                    <i class="bi bi-star"></i>
                                <% } %>
                            <% } %>
                        </div>
                    </td>
                    <td><%= h.getPrecioNoche() %></td>
                    <td>
<button class="btn btn-success btn-sm"
    onclick="editarHotel(
        <%= h.getId_hotel() %>,
        '<%= java.net.URLEncoder.encode(h.getNombre(), "UTF-8") %>',
        '<%= java.net.URLEncoder.encode(h.getDescripcion(), "UTF-8") %>',
        '<%= java.net.URLEncoder.encode(h.getDireccion(), "UTF-8") %>',
        '<%= java.net.URLEncoder.encode(h.getCiudad(), "UTF-8") %>',
        '<%= java.net.URLEncoder.encode(h.getPais(), "UTF-8") %>',
        <%= h.getEstrellas() %>,
        '<%= java.net.URLEncoder.encode(h.getTelefono(), "UTF-8") %>',
        '<%= java.net.URLEncoder.encode(h.getEmail(), "UTF-8") %>',
        <%= h.getPrecioNoche() %>,
        '<%= h.getImagen1() %>',
        '<%= h.getImagen2() %>',
        '<%= h.getImagen3() %>'
    )">

                            <i class="bi bi-pencil"></i>
                        </button>
                        <button class="btn btn-danger btn-sm"
                                onclick="confirmarEliminar(<%= h.getId_hotel() %>)">
                            <i class="bi bi-trash"></i>
                        </button>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- MODAL NUEVO HOTEL -->
<div class="modal fade" id="modalNuevo" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content p-3">
            <h4>Registrar Nuevo Hotel</h4>
            <form action="<%= request.getContextPath() %>/HotelServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="accion" value="guardar">

                <label>Nombre:</label>
                <input class="form-control" name="nombre" required>

                <label>Descripción:</label>
                <textarea class="form-control" name="descripcion"></textarea>

                <label>Dirección:</label>
                <input class="form-control" name="direccion">

                <label>Ciudad:</label>
                <input class="form-control" name="ciudad">

                <label>País:</label>
                <input class="form-control" name="pais">

                <label>Estrellas:</label>
                <div class="stars-input" id="nuevo_estrellas">
                    <i class="bi bi-star" data-value="5"></i>
                    <i class="bi bi-star" data-value="4"></i>
                    <i class="bi bi-star" data-value="3"></i>
                    <i class="bi bi-star" data-value="2"></i>
                    <i class="bi bi-star" data-value="1"></i>
                </div>
                <input type="hidden" name="estrellas" id="input_nuevo_estrellas" value="0">

                <label>Precio por noche (S/.)</label>
                <input class="form-control" type="number" step="0.01" min="0" name="precio_noche" required>

                <label>Teléfono:</label>
                <input class="form-control" name="telefono">

                <label>Email:</label>
                <input class="form-control" name="email">

                <label>Imagen 1:</label>
                <input type="file" class="form-control" name="imagen1" accept="image/*" required>

                <label>Imagen 2:</label>
                <input type="file" class="form-control" name="imagen2" accept="image/*" required>

                <label>Imagen 3:</label>
                <input type="file" class="form-control" name="imagen3" accept="image/*" required>

                <button class="btn btn-primary mt-3">Registrar</button>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDITAR HOTEL -->
<div class="modal fade" id="modalEditar" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content p-3">
            <h4>Editar Hotel</h4>
            <form action="<%= request.getContextPath() %>/HotelServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="accion" value="actualizar">
                <input type="hidden" id="edit_id" name="id_hotel">
                <input type="hidden" id="imgActual1" name="imgActual1">
                <input type="hidden" id="imgActual2" name="imgActual2">
                <input type="hidden" id="imgActual3" name="imgActual3">

                <label>Nombre:</label>
                <input class="form-control" id="edit_nombre" name="nombre">

                <label>Descripción:</label>
                <textarea class="form-control" id="edit_descripcion" name="descripcion"></textarea>

                <label>Dirección:</label>
                <input class="form-control" id="edit_direccion" name="direccion">

                <label>Ciudad:</label>
                <input class="form-control" id="edit_ciudad" name="ciudad">

                <label>País:</label>
                <input class="form-control" id="edit_pais" name="pais">

                <label>Estrellas:</label>
                <div class="stars-input" id="editar_estrellas">
                    <i class="bi bi-star" data-value="5"></i>
                    <i class="bi bi-star" data-value="4"></i>
                    <i class="bi bi-star" data-value="3"></i>
                    <i class="bi bi-star" data-value="2"></i>
                    <i class="bi bi-star" data-value="1"></i>
                </div>
                <input type="hidden" name="estrellas" id="input_editar_estrellas">

                <label>Precio por noche (S/.)</label>
                <input class="form-control" type="number" step="0.01" min="0" id="edit_precio" name="precio_noche">

                <label>Teléfono:</label>
                <input class="form-control" id="edit_telefono" name="telefono">

                <label>Email:</label>
                <input class="form-control" id="edit_email" name="email">

                <label>Imagen 1:</label>
                <input type="file" class="form-control" id="edit_img1" name="imagen1" accept="image/*">

                <label>Imagen 2:</label>
                <input type="file" class="form-control" id="edit_img2" name="imagen2" accept="image/*">

                <label>Imagen 3:</label>
                <input type="file" class="form-control" id="edit_img3" name="imagen3" accept="image/*">

                <button class="btn btn-success mt-3">Actualizar</button>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function confirmarEliminar(id) {
    Swal.fire({
        title: "¿Eliminar hotel?",
        text: "Esta acción no se puede deshacer.",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#d33",
        cancelButtonColor: "#6c757d",
        confirmButtonText: "Sí, eliminar"
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = "<%= request.getContextPath() %>/HotelServlet?accion=eliminar&id=" + id;
        }
    });
}

// Función editarHotel para abrir modal con datos
function editarHotel(id, nombre, descripcion, direccion, ciudad, pais, estrellas, telefono, email, precio, img1, img2, img3) {
    document.getElementById('edit_id').value = id;
    document.getElementById('edit_nombre').value = decodeURIComponent(nombre);
    document.getElementById('edit_descripcion').value = decodeURIComponent(descripcion);
    document.getElementById('edit_direccion').value = decodeURIComponent(direccion);
    document.getElementById('edit_ciudad').value = decodeURIComponent(ciudad);
    document.getElementById('edit_pais').value = decodeURIComponent(pais);
    document.getElementById('edit_telefono').value = decodeURIComponent(telefono);
    document.getElementById('edit_email').value = decodeURIComponent(email);
    document.getElementById('edit_precio').value = precio;
    document.getElementById('imgActual1').value = img1;
    document.getElementById('imgActual2').value = img2;
    document.getElementById('imgActual3').value = img3;

    initStars('editar_estrellas', 'input_editar_estrellas', estrellas);

    new bootstrap.Modal(document.getElementById('modalEditar')).show();
}


// Inicializa estrellas interactivas
function initStars(containerId, inputId, initial = 0) {
    const container = document.getElementById(containerId);
    const input = document.getElementById(inputId);
    const stars = container.querySelectorAll('i');

    function pintar(valor) {
        stars.forEach(star => {
            if (star.dataset.value <= valor) {
                star.classList.add('bi-star-fill');
                star.classList.remove('bi-star');
            } else {
                star.classList.add('bi-star');
                star.classList.remove('bi-star-fill');
            }
        });
        input.value = valor;
    }

    pintar(initial);

    stars.forEach(star => {
        star.addEventListener('click', () => pintar(star.dataset.value));
        star.addEventListener('mouseover', () => pintar(star.dataset.value));
        star.addEventListener('mouseout', () => pintar(input.value));
    });
}

// Inicializar estrellas para nuevo hotel
initStars('nuevo_estrellas', 'input_nuevo_estrellas');
initStars('editar_estrellas', 'input_editar_estrellas');
</script>

</body>
</html>
