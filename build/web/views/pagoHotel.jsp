<%@ page import="com.movilvanperu.model.ReservaHotel, com.movilvanperu.model.Hotel" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}" />
<fmt:setBundle basename="messages" />

<%
    ReservaHotel reservaHotel = (ReservaHotel) request.getAttribute("reservaHotel");
    Hotel hotel = (Hotel) request.getAttribute("hotel");

    if (reservaHotel == null || hotel == null) {
        response.sendRedirect(request.getContextPath() + "/views/mis_reservas.jsp");
        return;
    }

    int idReserva = reservaHotel.getId_reserva_hotel();
    String estado = reservaHotel.getEstado();
    double total = reservaHotel.getTotal();
    String fechaInicio = reservaHotel.getFecha_inicio().toString();
    String fechaFin = reservaHotel.getFecha_fin().toString();
    String hotelNombre = hotel.getNombre();
    String hotelImagen = hotel.getImagen1();
%>

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="payment.title" /></title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background: #f2f6fc;
            font-family: 'Segoe UI', sans-serif;
        }
        .card {
            border: none;
            border-radius: 14px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .resumen {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
        }
        .img-preview {
            height: 180px;
            object-fit: cover;
            border-radius: 10px;
        }
        .titulo {
            color: #004b8d;
            font-weight: 700;
        }
    </style>
</head>

<body>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-7 col-md-10">

            <div class="card p-4">

                <!-- TÍTULO -->
                <h3 class="text-center titulo mb-4">
                    <i class="bi bi-credit-card-2-front-fill me-2"></i>
                    <fmt:message key="payment.reserve.title" />
                </h3>

                <!-- RESUMEN HOTEL -->
                <div class="row g-3 mb-4 align-items-center">
                    <div class="col-md-4">
                        <img src="<%= (hotelImagen != null && !hotelImagen.isEmpty()) 
                                    ? request.getContextPath() + "/views/images/" + hotelImagen
                                    : request.getContextPath() + "/views/images/hotel_default.jpg" %>"
                             alt="Imagen del hotel"
                             class="img-preview w-100 shadow-sm">
                    </div>

                    <div class="col-md-8">
                        <div class="resumen">
                            <h5 class="mb-1"><strong><%= hotelNombre %></strong></h5>

                            <p class="mb-1">
                                <i class="bi bi-calendar-check"></i>
                                <strong><fmt:message key="reservas.checkin" />:</strong> <%= fechaInicio %>
                            </p>

                            <p class="mb-1">
                                <i class="bi bi-calendar-x"></i>
                                <strong><fmt:message key="reservas.checkout" />:</strong> <%= fechaFin %>
                            </p>

                            <p class="estado <%= (estado != null) ? estado.toLowerCase() : "" %>">
                                <i class="bi bi-info-circle"></i>
                                <strong><fmt:message key="reserva.estado" />:</strong> <%= estado %>
                            </p>

                            <p class="mb-0 fs-5 text-primary">
                                <strong><fmt:message key="payment.total" />:</strong> S/ <%= String.format("%.2f", total) %>
                            </p>
                        </div>
                    </div>
                </div>

                <!-- FORMULARIO DE PAGO -->
                <form id="formPago"
                      action="<%= request.getContextPath() %>/PagoServlet"
                      method="post"
                      class="needs-validation"
                      novalidate>

                    <input type="hidden" name="action" value="pagar">
                    <input type="hidden" name="id_reserva" value="<%= idReserva %>">
                    <input type="hidden" name="tipo" value="hotel">
                    <input type="hidden" name="monto" value="<%= String.format("%.2f", total) %>">

                    <!-- MÉTODO -->
                    <div class="mb-3">
                        <label for="metodo" class="form-label fw-semibold">
                            <fmt:message key="payment.method" />
                        </label>

                        <select id="metodo" name="metodo" class="form-select" required>
                            <option value=""><fmt:message key="payment.method.select" /></option>
                            <option value="credit"><fmt:message key="payment.method.credit" /></option>
                            <option value="debit"><fmt:message key="payment.method.debit" /></option>
                            <option value="yape"><fmt:message key="payment.method.yape" /></option>
                            <option value="plin"><fmt:message key="payment.method.plin" /></option>
                            <option value="transfer"><fmt:message key="payment.method.transfer" /></option>
                        </select>

                        <div class="invalid-feedback">
                            <fmt:message key="payment.method.required" />
                        </div>
                    </div>

<!-- TARJETA -->
<div class="mb-3" id="wrap_numero">
    <label for="numero_tarjeta" class="form-label fw-semibold">
        <fmt:message key="payment.card.number" />
    </label>

    <input type="text"
           id="numero_tarjeta"
           name="numero_tarjeta"
           class="form-control"
           placeholder="4111 1111 1111 1111"
           maxlength="25"
           inputmode="numeric"
           required>

    <div class="form-text text-muted">
        <fmt:message key="payment.card.info" />
    </div>
</div>


                    <!-- TITULAR -->
                    <div class="mb-4">
                        <label for="nombre_titular" class="form-label fw-semibold">
                            <fmt:message key="payment.card.holder" />
                        </label>

                        <input type="text"
                               id="nombre_titular"
                               name="nombre_titular"
                               class="form-control"
                               maxlength="100"
                               required>

                        <div class="invalid-feedback">
                            <fmt:message key="payment.card.holder.required" />
                        </div>
                    </div>

                    <!-- BOTONES -->
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="bi bi-check-circle me-2"></i>
                            <fmt:message key="payment.confirm" /> — S/
                            <%= String.format("%.2f", total) %>
                        </button>

                        <a href="<%= request.getContextPath() %>/views/mis_reservas.jsp"
                           class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left"></i>
                            <fmt:message key="payment.back" />
                        </a>
                    </div>

                </form>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
(() => {
    const metodoEl = document.getElementById('metodo');
    const numeroEl = document.getElementById('numero_tarjeta');
    const form = document.getElementById('formPago');

    function toggleCardFields() {
        const metodo = metodoEl.value;
        if (metodo === 'credit' || metodo === 'debit') {
            numeroEl.required = true;
            numeroEl.disabled = false;
        } else {
            numeroEl.required = false;
            numeroEl.disabled = true;
            numeroEl.value = '';
        }
    }

    metodoEl.addEventListener('change', toggleCardFields);
    toggleCardFields();

    form.addEventListener('submit', function (event) {
        if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
        }
        form.classList.add('was-validated');
    }, false);
})();

</script>

</body>
</html>
