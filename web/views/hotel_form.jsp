<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- MODAL: NUEVO HOTEL -->
<div class="modal fade" id="modalHotel" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <!-- IMPORTANTE: enctype para permitir archivos -->
            <form action="<%= request.getContextPath() %>/HotelServlet"
                  method="post" enctype="multipart/form-data">

                <input type="hidden" name="accion" value="guardar">

                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">Registrar Nuevo Hotel 🏨</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">

                    <!-- NOMBRE -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Nombre del Hotel</label>
                        <input type="text" name="nombre" class="form-control" required>
                    </div>

                    <!-- DESCRIPCIÓN -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Descripción</label>
                        <textarea name="descripcion" class="form-control" rows="3"></textarea>
                    </div>

                    <!-- UBICACIÓN -->
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Dirección</label>
                            <input type="text" name="direccion" class="form-control">
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Ciudad</label>
                            <input type="text" name="ciudad" class="form-control">
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">País</label>
                            <input type="text" name="pais" class="form-control">
                        </div>
                    </div>

                    <!-- CONTACTO -->
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Teléfono</label>
                            <input type="text" name="telefono" class="form-control">
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Email</label>
                            <input type="email" name="email" class="form-control">
                        </div>
                    </div>

                    <!-- ESTRELLAS -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Valoración</label>
                        <div class="rating-input">
                            <input type="radio" id="star5" name="estrellas" value="5"><label for="star5">★</label>
                            <input type="radio" id="star4" name="estrellas" value="4"><label for="star4">★</label>
                            <input type="radio" id="star3" name="estrellas" value="3"><label for="star3">★</label>
                            <input type="radio" id="star2" name="estrellas" value="2"><label for="star2">★</label>
                            <input type="radio" id="star1" name="estrellas" value="1"><label for="star1">★</label>
                        </div>
                    </div>

                    <!-- PRECIO POR NOCHE -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Precio por noche (S/.)</label>
                        <input type="number" step="0.01" min="0" name="precio_noche" class="form-control" required>
                    </div>

                    <!-- INPUT FILE REALES -->
                    <label class="form-label fw-bold">Imágenes:</label>

                    <div class="mb-2">
                        <input type="file" class="form-control" name="imagen1" accept="image/*" required>
                    </div>
                    <div class="mb-2">
                        <input type="file" class="form-control" name="imagen2" accept="image/*" required>
                    </div>
                    <div class="mb-2">
                        <input type="file" class="form-control" name="imagen3" accept="image/*" required>
                    </div>

                </div>

                <div class="modal-footer">
                    <button class="btn btn-primary" type="submit">Guardar Hotel</button>
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                </div>

            </form>

        </div>
    </div>
</div>


<!-- MODAL: EDITAR HOTEL -->
<div class="modal fade" id="modalEditarHotel" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <form action="<%= request.getContextPath() %>/HotelServlet"
                  method="post" enctype="multipart/form-data">

                <input type="hidden" name="accion" value="editar">
                <input type="hidden" id="edit_id" name="id_hotel">

                <!-- Guardamos las imágenes actuales -->
                <input type="hidden" id="imgActual1" name="imgActual1">
                <input type="hidden" id="imgActual2" name="imgActual2">
                <input type="hidden" id="imgActual3" name="imgActual3">

                <div class="modal-header bg-warning">
                    <h5 class="modal-title">Editar Hotel ✏️</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">

                    <!-- CAMPOS IGUALES A LOS DEL NUEVO HOTEL -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Nombre</label>
                        <input type="text" id="edit_nombre" name="nombre" class="form-control">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Descripción</label>
                        <textarea id="edit_descripcion" name="descripcion" class="form-control" rows="3"></textarea>
                    </div>

                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Dirección</label>
                            <input type="text" id="edit_direccion" name="direccion" class="form-control">
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Ciudad</label>
                            <input type="text" id="edit_ciudad" name="ciudad" class="form-control">
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">País</label>
                            <input type="text" id="edit_pais" name="pais" class="form-control">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Teléfono</label>
                            <input type="text" id="edit_telefono" name="telefono" class="form-control">
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Email</label>
                            <input type="email" id="edit_email" name="email" class="form-control">
                        </div>
                    </div>

                    <!-- ESTRELLAS -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Valoración</label>

                        <div class="rating-input edit-rating">
                            <input type="radio" id="edit_star5" name="estrellas" value="5"><label for="edit_star5">★</label>
                            <input type="radio" id="edit_star4" name="estrellas" value="4"><label for="edit_star4">★</label>
                            <input type="radio" id="edit_star3" name="estrellas" value="3"><label for="edit_star3">★</label>
                            <input type="radio" id="edit_star2" name="estrellas" value="2"><label for="edit_star2">★</label>
                            <input type="radio" id="edit_star1" name="estrellas" value="1"><label for="edit_star1">★</label>
                        </div>
                    </div>

                    <!-- PRECIO POR NOCHE -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Precio por noche (S/.)</label>
                        <input type="number" step="0.01" min="0" id="edit_precio" name="precio_noche" class="form-control">
                    </div>

                    <!-- NUEVAS IMÁGENES -->
                    <label class="form-label fw-bold">Cambiar imágenes:</label>

                    <div class="mb-2">
                        <input type="file" class="form-control" name="imagen1" accept="image/*">
                    </div>
                    <div class="mb-2">
                        <input type="file" class="form-control" name="imagen2" accept="image/*">
                    </div>
                    <div class="mb-2">
                        <input type="file" class="form-control" name="imagen3" accept="image/*">
                    </div>

                </div>

                <div class="modal-footer">
                    <button class="btn btn-warning" type="submit">Guardar Cambios</button>
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                </div>

            </form>

        </div>
    </div>
</div>
