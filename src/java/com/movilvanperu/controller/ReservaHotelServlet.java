package com.movilvanperu.controller;

import com.movilvanperu.dao.HotelDAO;
import com.movilvanperu.dao.ReservaHotelDAO;
import com.movilvanperu.model.Hotel;
import com.movilvanperu.model.ReservaHotel;
import com.movilvanperu.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/ReservaHotelServlet")
public class ReservaHotelServlet extends HttpServlet {

    private final ReservaHotelDAO reservaDAO = new ReservaHotelDAO();
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        int id_usuario = usuario.getId();

        switch (accion) {
            case "listar":
                List<ReservaHotel> reservas = reservaDAO.listarPorUsuario(id_usuario);
                request.setAttribute("listaReservas", reservas);
                request.getRequestDispatcher("views/mis_reservas.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect("index.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("reservar".equals(accion)) {
            reservarHabitacion(request, response);
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    // ==========================
    // RESERVAR HABITACIÓN
    // ==========================
    private void reservarHabitacion(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        int id_usuario = usuario.getId();

        try {
            int id_hotel = Integer.parseInt(request.getParameter("id_hotel"));
            String fecha_inicioStr = request.getParameter("fecha_inicio");
            String fecha_finStr = request.getParameter("fecha_fin");
            double precio_noche = Double.parseDouble(request.getParameter("precio_noche"));
            String metodoPago = request.getParameter("metodoPago");

            Date fecha_inicio = sdf.parse(fecha_inicioStr);
            Date fecha_fin = sdf.parse(fecha_finStr);

            // Crear objeto reserva
            ReservaHotel reserva = new ReservaHotel();
            reserva.setId_usuario(id_usuario);
            reserva.setId_hotel(id_hotel);
            reserva.setFecha_inicio(fecha_inicio);
            reserva.setFecha_fin(fecha_fin);
            reserva.setPrecio_noche(precio_noche);
            reserva.calcularTotal();
            reserva.setEstado("pendiente");

            boolean exito = reservaDAO.agregar(reserva);

            if (exito) {
                // Obtener información del hotel para mostrar en confirmación
                HotelDAO hotelDAO = new HotelDAO();
                Hotel hotel = hotelDAO.obtenerPorId(id_hotel);

                request.setAttribute("reserva", reserva);
                request.setAttribute("hotel", hotel);
                request.setAttribute("metodoPago", metodoPago);

                // Forward al JSP de confirmación
                request.getRequestDispatcher("views/hotel_confirmacion.jsp").forward(request, response);

            } else {
                request.setAttribute("error", "No se pudo completar la reserva");
                request.getRequestDispatcher("views/error.jsp").forward(request, response);
            }

        } catch (NumberFormatException | ParseException e) {
            e.printStackTrace();
            request.setAttribute("error", "Datos inválidos o formato de fecha incorrecto");
            request.getRequestDispatcher("views/error.jsp").forward(request, response);
        }
    }
}
