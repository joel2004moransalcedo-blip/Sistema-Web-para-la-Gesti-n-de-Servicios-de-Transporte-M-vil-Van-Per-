<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- Modal Agregar Paquete -->
<div class="modal fade" id="modalPaquete" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content p-3">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title"><i class="bi bi-plus-circle me-2"></i>Agregar nuevo paquete</h5>
        <button type="button" class="btn-close btn-close-white" onclick="cerrarModal()"></button>
      </div>
      <form id="formAgregar" enctype="multipart/form-data">
        <div class="modal-body">
          <input type="text" name="nombre" class="form-control mb-2" placeholder="Nombre del paquete" required>
          <textarea name="descripcion" class="form-control mb-2" placeholder="Descripción" required></textarea>
          <input type="number" step="0.01" name="precio" class="form-control mb-2" placeholder="Precio (S/.)" required>
          <input type="text" name="destino" class="form-control mb-2" placeholder="Destino" required>
          <input type="date" name="fecha_salida" class="form-control mb-2" required>
          <input type="date" name="fecha_retorno" class="form-control mb-2" required>

          <!-- Campo Valoración -->
          <label class="form-label fw-semibold">Valoración del paquete:</label>
          <div id="rating-stars" class="fs-4 mb-3">
            <i class="bi bi-star text-warning mx-1" onclick="setStars(1, 'agregar')"></i>
            <i class="bi bi-star text-warning mx-1" onclick="setStars(2, 'agregar')"></i>
            <i class="bi bi-star text-warning mx-1" onclick="setStars(3, 'agregar')"></i>
            <i class="bi bi-star text-warning mx-1" onclick="setStars(4, 'agregar')"></i>
            <i class="bi bi-star text-warning mx-1" onclick="setStars(5, 'agregar')"></i>
          </div>
          <input type="hidden" id="valoracion" name="valoracion" value="0">

          <!-- Imágenes -->
          <label class="form-label fw-bold">Imágenes:</label>
          <input type="file" name="imagen1" class="form-control mb-2" accept="image/*" required>
          <input type="file" name="imagen2" class="form-control mb-2" accept="image/*">
          <input type="file" name="imagen3" class="form-control mb-2" accept="image/*">
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary"><i class="bi bi-save"></i> Guardar</button>
          <button type="button" class="btn btn-secondary" onclick="cerrarModal()">Cancelar</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Modal Editar Paquete -->
<div class="modal fade" id="modalEditarPaquete" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content p-3">
      <div class="modal-header bg-success text-white">
        <h5 class="modal-title"><i class="bi bi-pencil-square me-2"></i>Editar paquete</h5>
        <button type="button" class="btn-close btn-close-white" onclick="cerrarModalEditar()"></button>
      </div>
      <form id="formEditar" enctype="multipart/form-data">
        <input type="hidden" name="id" id="edit_id">
        <div class="modal-body">
          <input type="text" id="edit_nombre" name="nombre" class="form-control mb-2" placeholder="Nombre" required>
          <textarea id="edit_descripcion" name="descripcion" class="form-control mb-2" placeholder="Descripción" required></textarea>
          <input type="number" step="0.01" id="edit_precio" name="precio" class="form-control mb-2" placeholder="Precio" required>
          <input type="text" id="edit_destino" name="destino" class="form-control mb-2" placeholder="Destino" required>
          <input type="date" id="edit_fecha_salida" name="fecha_salida" class="form-control mb-2" required>
          <input type="date" id="edit_fecha_retorno" name="fecha_retorno" class="form-control mb-2" required>

          <!-- Campo Valoración -->
          <label class="form-label fw-semibold">Valoración:</label>
          <div id="rating-stars-edit" class="fs-4 mb-3">
            <i class="bi bi-star text-warning mx-1" onclick="setStars(1, 'editar')"></i>
            <i class="bi bi-star text-warning mx-1" onclick="setStars(2, 'editar')"></i>
            <i class="bi bi-star text-warning mx-1" onclick="setStars(3, 'editar')"></i>
            <i class="bi bi-star text-warning mx-1" onclick="setStars(4, 'editar')"></i>
            <i class="bi bi-star text-warning mx-1" onclick="setStars(5, 'editar')"></i>
          </div>
          <input type="hidden" id="edit_valoracion" name="valoracion" value="0">

          <label class="form-label fw-bold">Actualizar imágenes (opcional):</label>
          <input type="file" name="imagen1" class="form-control mb-2" accept="image/*">
          <input type="file" name="imagen2" class="form-control mb-2" accept="image/*">
          <input type="file" name="imagen3" class="form-control mb-2" accept="image/*">
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-success"><i class="bi bi-check-circle"></i> Actualizar</button>
          <button type="button" class="btn btn-secondary" onclick="cerrarModalEditar()">Cancelar</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Librerías -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

<script>
  // --- Control de estrellas ---
  function setStars(n, tipo) {
    const stars = tipo === 'agregar'
      ? document.querySelectorAll('#rating-stars i')
      : document.querySelectorAll('#rating-stars-edit i');
    const input = tipo === 'agregar'
      ? document.getElementById('valoracion')
      : document.getElementById('edit_valoracion');

    input.value = n;

    stars.forEach((star, i) => {
      if (i < n) {
        star.classList.remove('bi-star');
        star.classList.add('bi-star-fill');
      } else {
        star.classList.remove('bi-star-fill');
        star.classList.add('bi-star');
      }
    });
  }

  // Rellenar estrellas automáticamente al abrir modal de edición
  document.addEventListener('show.bs.modal', function (event) {
    const modal = event.target;
    if (modal.id === 'modalEditarPaquete') {
      const valor = parseInt(document.getElementById('edit_valoracion').value || 0);
      const stars = document.querySelectorAll('#rating-stars-edit i');
      stars.forEach((star, i) => {
        if (i < valor) {
          star.classList.remove('bi-star');
          star.classList.add('bi-star-fill');
        } else {
          star.classList.remove('bi-star-fill');
          star.classList.add('bi-star');
        }
      });
    }
  });

  // --- Agregar paquete con AJAX ---
  document.getElementById("formAgregar").addEventListener("submit", function(e) {
    e.preventDefault();
    Swal.fire({
      title: '¿Guardar nuevo paquete?',
      text: 'Verifica los datos antes de continuar.',
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: 'Guardar',
      cancelButtonText: 'Cancelar',
      confirmButtonColor: '#1a73e8'
    }).then((result) => {
      if (result.isConfirmed) {
        const formData = new FormData(this);
        formData.append("accion", "agregar");
        fetch("<%= request.getContextPath() %>/PaqueteServlet", {
          method: "POST",
          body: formData
        })
        .then(res => res.ok ? res.text() : Promise.reject(res))
        .then(() => {
          Swal.fire({
            icon: 'success',
            title: 'Paquete agregado',
            text: 'Se ha guardado correctamente.',
            confirmButtonColor: '#1a73e8',
            timer: 1500,
            showConfirmButton: false
          }).then(() => location.reload());
        })
        .catch(() => {
          Swal.fire({
            icon: 'error',
            title: 'Error al guardar',
            text: 'Hubo un problema al guardar el paquete.',
            confirmButtonColor: '#d33'
          });
        });
      }
    });
  });

  // --- Editar paquete con AJAX ---
  document.getElementById("formEditar").addEventListener("submit", function(e) {
    e.preventDefault();
    Swal.fire({
      title: '¿Actualizar paquete?',
      text: 'Confirma para guardar los cambios.',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Actualizar',
      cancelButtonText: 'Cancelar',
      confirmButtonColor: '#0f9d58'
    }).then((result) => {
      if (result.isConfirmed) {
        const formData = new FormData(this);
        formData.append("accion", "editar");
        fetch("<%= request.getContextPath() %>/PaqueteServlet", {
          method: "POST",
          body: formData
        })
        .then(res => res.ok ? res.text() : Promise.reject(res))
        .then(() => {
          Swal.fire({
            icon: 'success',
            title: 'Actualizado correctamente',
            text: 'El paquete fue editado.',
            confirmButtonColor: '#0f9d58',
            timer: 1500,
            showConfirmButton: false
          }).then(() => location.reload());
        })
        .catch(() => {
          Swal.fire({
            icon: 'error',
            title: 'Error al actualizar',
            text: 'Hubo un problema al guardar los cambios.',
            confirmButtonColor: '#d33'
          });
        });
      }
    });
  });

  // --- Animación de modales ---
  document.addEventListener('show.bs.modal', function (event) {
    const modal = event.target.querySelector('.modal-content');
    modal.classList.add('animate__animated', 'animate__zoomIn');
  });

  document.addEventListener('hide.bs.modal', function (event) {
    const modal = event.target.querySelector('.modal-content');
    modal.classList.remove('animate__zoomIn');
  });
</script>
