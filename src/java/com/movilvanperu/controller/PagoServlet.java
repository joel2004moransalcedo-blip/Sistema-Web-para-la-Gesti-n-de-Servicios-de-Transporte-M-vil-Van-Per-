package com.movilvanperu.controller;

import com.movilvanperu.facade.SistemaViajesFacade;
import com.movilvanperu.model.ReservaHotel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import com.movilvanperu.model.Hotel;


@WebServlet("/PagoServlet")
public class PagoServlet extends HttpServlet {

    private final SistemaViajesFacade facade = new SistemaViajesFacade();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String accion = request.getParameter("accion"); // botones como verDetalles, verComprobante

        try {
            // 🧾 1️⃣ Ver detalles de la reserva
            if ("verDetalles".equalsIgnoreCase(accion)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Map<String, Object> reserva = facade.obtenerReservaPorId(id);

                if (reserva == null) {
                    request.setAttribute("mensaje", "⚠️ No se encontró la reserva.");
                    request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
                    return;
                }

                request.setAttribute("reserva", reserva);
                request.getRequestDispatcher("/views/detalleReserva.jsp").forward(request, response);
                return;
            }

            // 📄 2️⃣ Ver comprobante del pago
// 📄 2️⃣ Ver comprobante del pago
if ("verComprobante".equalsIgnoreCase(accion)) {
    int id = Integer.parseInt(request.getParameter("id"));
    String tipo = request.getParameter("tipo"); // "hotel" o "paquete"

    if ("hotel".equalsIgnoreCase(tipo)) {
        // Obtener la reserva de hotel
        ReservaHotel reservaHotel = facade.obtenerReservaHotelPorId(id);
        if (reservaHotel == null) {
            request.setAttribute("mensaje", "⚠️ No se encontró la reserva de hotel.");
            request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
            return;
        }

        // Obtener el hotel asociado
        Hotel hotel = facade.obtenerHotelPorId(reservaHotel.getId_hotel());
        if (hotel == null) {
            request.setAttribute("mensaje", "⚠️ No se encontró el hotel de la reserva.");
            request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
            return;
        }

        // Obtener último pago de la reserva (nuevo método en ReservaHotelDAO)
        Map<String, Object> pago = facade.obtenerUltimoPagoHotel(id);
        if (pago == null) {
            request.setAttribute("mensaje", "⚠️ No se encontró el comprobante de pago.");
            request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
            return;
        }

        // Pasar datos al JSP del comprobante especial para hoteles
        request.setAttribute("reservaHotel", reservaHotel);
        request.setAttribute("hotel", hotel);
        request.setAttribute("pago", pago);

        request.getRequestDispatcher("/views/comprobante_hotel.jsp").forward(request, response);
        return;

    } else {
        // Por defecto, comprobante para paquetes
        Map<String, Object> reserva = facade.obtenerReservaPorId(id);
        List<Map<String, Object>> pagos = facade.listarPagosPorReserva(id);

        if (reserva == null) {
            request.setAttribute("mensaje", "⚠️ No se encontró la reserva.");
            request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
            return;
        }

        request.setAttribute("reserva", reserva);
        request.setAttribute("pagos", pagos);
        request.getRequestDispatcher("/views/comprobante.jsp").forward(request, response);
        return;
    }
}


   // 💳 3️⃣ Cargar formulario de pago
if ("cargar".equalsIgnoreCase(action)) {
    String idStr = request.getParameter("id_reserva");
    String tipo = request.getParameter("tipo"); // "hotel" o "paquete"

    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/views/mis_reservas.jsp");
        return;
    }

    int idReserva = Integer.parseInt(idStr);

    if ("hotel".equalsIgnoreCase(tipo)) {
        // Obtener la reserva de hotel
        ReservaHotel reservaHotel = facade.obtenerReservaHotelPorId(idReserva);
        if (reservaHotel == null) {
            request.setAttribute("mensaje", "⚠️ No se encontró la reserva de hotel seleccionada.");
            request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
            return;
        }

        // Obtener el hotel de la reserva
        Hotel hotel = facade.obtenerHotelPorId(reservaHotel.getId_hotel());
        if (hotel == null) {
            request.setAttribute("mensaje", "⚠️ No se encontró el hotel de la reserva.");
            request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
            return;
        }

        // Pasar ambos objetos al JSP
        request.setAttribute("reservaHotel", reservaHotel);
        request.setAttribute("hotel", hotel);

        request.getRequestDispatcher("/views/pagoHotel.jsp").forward(request, response);

    } else {
        // Por defecto, paquete
        Map<String, Object> reserva = facade.obtenerReservaPorId(idReserva);
        if (reserva == null) {
            request.setAttribute("mensaje", "⚠️ No se encontró la reserva seleccionada.");
            request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
            return;
        }

        request.setAttribute("reserva", reserva);
        request.getRequestDispatcher("/views/pago.jsp").forward(request, response);
    }
    return;
}

            // 🚫 Default: redirige a mis reservas
            response.sendRedirect(request.getContextPath() + "/views/mis_reservas.jsp");

        } catch (NumberFormatException nfe) {
            request.setAttribute("mensaje", "ID de reserva inválido.");
            request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "❌ Error cargando información: " + e.getMessage());
            request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            // 💰 4️⃣ Procesar el pago
            if ("pagar".equalsIgnoreCase(action)) {

                int idReserva = Integer.parseInt(request.getParameter("id_reserva"));
                String tipo = request.getParameter("tipo"); // "hotel" o "paquete"
                String metodo = request.getParameter("metodo");
                String numeroTarjeta = request.getParameter("numero_tarjeta");
                String nombreTitular = request.getParameter("nombre_titular");

                double monto = 0.0;
                try {
                    monto = Double.parseDouble(request.getParameter("monto"));
                } catch (NumberFormatException ignore) { }

                boolean ok = false;

                if ("hotel".equalsIgnoreCase(tipo)) {
                    ok = facade.registrarPagoHotel(idReserva, metodo, numeroTarjeta, nombreTitular, monto);
                    if (ok) {
                        facade.actualizarEstadoReservaHotel(idReserva, "pagada");
                    }
                } else {
                    // paquete por defecto
                    ok = facade.registrarPago(idReserva, metodo, numeroTarjeta, nombreTitular, monto);
                    if (ok) {
                        List<Map<String, Object>> pagos = facade.listarPagosPorReserva(idReserva);
                        if (pagos != null && !pagos.isEmpty()) {
                            Object idPagoObj = pagos.get(0).get("id");
                            if (idPagoObj instanceof Number) {
                                int idPago = ((Number) idPagoObj).intValue();
                                facade.actualizarEstadoPago(idPago, "completado");
                            }
                        }
                        facade.actualizarEstadoReserva(idReserva, "pagada");
                    }
                }

                if (ok) {
                    response.sendRedirect(request.getContextPath() + "/views/mis_reservas.jsp?success=1");
                } else {
                    response.sendRedirect(request.getContextPath() + "/views/mis_reservas.jsp?error=1");
                }
                return;
            }

            // 🚫 Default: redirige a mis reservas
            response.sendRedirect(request.getContextPath() + "/views/mis_reservas.jsp");

        } catch (NumberFormatException nfe) {
            nfe.printStackTrace();
            request.setAttribute("mensaje", "❗ Parámetro numérico inválido.");
            request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "⚠️ Error procesando el pago: " + e.getMessage());
            request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
        }
    }
}
