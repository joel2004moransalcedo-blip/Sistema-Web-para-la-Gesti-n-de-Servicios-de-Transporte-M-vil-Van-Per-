package com.movilvanperu.controller;

import com.movilvanperu.facade.SistemaViajesFacade;
import com.movilvanperu.model.ReservaHotel;
import com.movilvanperu.model.Hotel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;


@WebServlet("/VerComprobanteServlet")
public class VerComprobanteServlet extends HttpServlet {

    private final SistemaViajesFacade facade = new SistemaViajesFacade();

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String idStr = request.getParameter("id_reserva");
    String tipo = request.getParameter("tipo"); // "hotel" o "paquete"

    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/views/mis_reservas.jsp");
        return;
    }

    try {
        int idReserva = Integer.parseInt(idStr);

        if ("hotel".equalsIgnoreCase(tipo)) {
            // 1️⃣ Obtener reserva hotel
            ReservaHotel reservaHotel = facade.obtenerReservaHotelPorId(idReserva);
            if (reservaHotel == null) {
                request.setAttribute("mensaje", "No se encontró la reserva de hotel.");
                request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
                return;
            }

            // 2️⃣ Obtener hotel asociado
            Hotel hotel = facade.obtenerHotelPorId(reservaHotel.getId_hotel());
            if (hotel == null) {
                request.setAttribute("mensaje", "No se encontró el hotel de la reserva.");
                request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
                return;
            }

// 3️⃣ Obtener último pago
Map<String, Object> pago = facade.obtenerUltimoPagoHotel(idReserva);

if (pago == null) {
    // Pago ficticio
    pago = Map.of(
        "codigo_pago", "PEND-" + idReserva,
        "metodo", "Pago pendiente",
        "fecha_pago", reservaHotel.getFecha_inicio()
    );
} else {
    // ✅ Garantizar que haya "codigo_pago"
    if (!pago.containsKey("codigo_pago")) {
        // Por ejemplo, usar "id_pago" si existe
        if (pago.containsKey("id_pago")) {
            pago.put("codigo_pago", "HOTEL-" + pago.get("id_pago"));
        } else {
            pago.put("codigo_pago", "HOTEL-" + idReserva);
        }
    }
}

            // 4️⃣ Pasar datos al JSP de comprobante de hotel
            request.setAttribute("reservaHotel", reservaHotel);
            request.setAttribute("hotel", hotel);
            request.setAttribute("pago", pago);

            request.getRequestDispatcher("/views/comprobante_hotel.jsp").forward(request, response);
            return;

        } else {
            // Paquete normal (ya existente)
            Map<String, Object> reserva = facade.obtenerReservaPorId(idReserva);

            if (reserva == null) {
                request.setAttribute("mensaje", "La reserva no existe.");
                request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
                return;
            }

            String metodoPago = (String) reserva.get("metodo_pago");

            if ("promocion".equalsIgnoreCase(metodoPago)) {
                Map<String, Object> pagoGratis = Map.of(
                        "codigo_pago", "PROMO-" + idReserva,
                        "metodo", "Promoción (Viaje Gratis)",
                        "monto", 0,
                        "fecha", reserva.get("fecha_reserva")
                );

                request.setAttribute("pago", pagoGratis);
                request.setAttribute("reserva", reserva);
                request.getRequestDispatcher("/views/comprobante_gratis.jsp").forward(request, response);
                return;
            }

            List<Map<String, Object>> pagos = facade.listarPagosPorReserva(idReserva);
            Map<String, Object> pago = (pagos != null && !pagos.isEmpty()) ? pagos.get(0) : null;

            if (pago == null) {
                request.setAttribute("mensaje", "No se encontró ningún comprobante de pago para esta reserva.");
                request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
                return;
            }

            request.setAttribute("pago", pago);
            request.setAttribute("reserva", reserva);
            request.getRequestDispatcher("/views/comprobante.jsp").forward(request, response);
        }

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("mensaje", "Error: " + e.getMessage());
        request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
    }
}

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
