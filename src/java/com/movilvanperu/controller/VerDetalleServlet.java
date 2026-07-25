package com.movilvanperu.controller;

import com.movilvanperu.facade.SistemaViajesFacade;
import com.movilvanperu.dao.ReservaHotelDAO;
import com.movilvanperu.dao.HotelDAO;
import com.movilvanperu.model.ReservaHotel;
import com.movilvanperu.model.Hotel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/VerDetalleServlet")
public class VerDetalleServlet extends HttpServlet {

    private final SistemaViajesFacade facade = new SistemaViajesFacade();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id_reserva");
        String tipo = request.getParameter("tipo");  // NUEVO

        if (idStr == null || idStr.isEmpty() || tipo == null || tipo.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/views/mis_reservas.jsp");
            return;
        }

        try {
            int idReserva = Integer.parseInt(idStr);

            if ("hotel".equalsIgnoreCase(tipo)) {
                ReservaHotelDAO reservaHotelDAO = new ReservaHotelDAO();
                HotelDAO hotelDAO = new HotelDAO();

                ReservaHotel reservaHotel = reservaHotelDAO.obtenerPorId(idReserva);
                if (reservaHotel == null) {
                    request.setAttribute("mensaje", "No se encontró la reserva de hotel.");
                    request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
                    return;
                }

                Hotel hotel = hotelDAO.obtenerPorId(reservaHotel.getId_hotel());

                request.setAttribute("reservaHotel", reservaHotel);
                request.setAttribute("hotel", hotel);
                request.getRequestDispatcher("/views/detalleHotel.jsp").forward(request, response);

            } else {  // paquete
                Map<String, Object> reserva = facade.obtenerReservaPorId(idReserva);
                if (reserva == null) {
                    request.setAttribute("mensaje", "No se encontró la reserva de paquete.");
                    request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
                    return;
                }
                request.setAttribute("reserva", reserva);
                request.getRequestDispatcher("/views/detalleReserva.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "ID de reserva inválido.");
            request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al obtener detalles: " + e.getMessage());
            request.getRequestDispatcher("/views/mis_reservas.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
