package com.movilvanperu.controller;

import com.movilvanperu.model.Usuario;
import com.movilvanperu.model.Paquete;
import com.movilvanperu.facade.SistemaViajesFacade;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/ReservaServlet")
public class ReservaServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final SistemaViajesFacade facade = new SistemaViajesFacade();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":false,\"message\":\"⚠️ No se especificó una acción válida.\"}");
            return;
        }

        switch (action) {
            case "crear":
            case "registrar":
                registrarReserva(request, response);
                break;

            case "eliminar":
                eliminarReserva(request, response);
                break;

            case "editar": // ✅ Actualizar estado de reserva
                editarReserva(request, response);
                break;
case "listar":
    listarReservas(request, response);
    break;

            default:
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false,\"message\":\"❌ Acción no reconocida.\"}");
                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    // ✅ Registrar reserva
    private void registrarReserva(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("views/login.jsp");
            return;
        }

        try {
            Usuario usuario = (Usuario) session.getAttribute("usuario");
            int idUsuario = usuario.getId();

            int idPaquete = Integer.parseInt(request.getParameter("idPaquete"));
            String metodoPago = request.getParameter("metodoPago");
            if (metodoPago == null || metodoPago.trim().isEmpty()) {
                metodoPago = "pendiente";
            }

            Paquete paquete = facade.obtenerPaquetePorId(idPaquete);
            if (paquete == null) {
                request.setAttribute("error", "No se encontró el paquete seleccionado.");
                request.getRequestDispatcher("views/error.jsp").forward(request, response);
                return;
            }

            double total = paquete.getPrecio();

            boolean registrado = facade.registrarReserva(idUsuario, idPaquete, metodoPago, total);

            if (registrado) {
                request.setAttribute("usuario", usuario);
                request.setAttribute("paquete", paquete);
                request.setAttribute("metodoPago", metodoPago);
                request.setAttribute("total", total);
                request.getRequestDispatcher("views/confirmacion.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "No se pudo registrar la reserva. Inténtalo nuevamente.");
                request.getRequestDispatcher("views/error.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la reserva: " + e.getMessage());
            request.getRequestDispatcher("views/error.jsp").forward(request, response);
        }
    }

    // ✅ Eliminar reserva
    private void eliminarReserva(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean ok = facade.eliminarReserva(id);

            if (ok) {
                out.write("{\"success\":true,\"message\":\"🗑️ Reserva eliminada correctamente.\"}");
            } else {
                out.write("{\"success\":false,\"message\":\"❌ No se pudo eliminar la reserva.\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"⚠️ ID inválido.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"message\":\"❌ Error interno: " + e.getMessage() + "\"}");
        }
    }

    // ✅ Editar reserva (actualizar estado)
    private void editarReserva(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {

            int idReserva = Integer.parseInt(request.getParameter("id_reserva"));
            String nuevoEstado = request.getParameter("estado");

            // 🚀 Llamada al método correcto del facade
            boolean actualizado = facade.actualizarEstadoReserva(idReserva, nuevoEstado);

            if (actualizado) {
                out.write("{\"success\":true,\"message\":\"✅ Estado de reserva actualizado correctamente.\"}");
            } else {
                out.write("{\"success\":false,\"message\":\"❌ No se pudo actualizar el estado.\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"⚠️ ID inválido.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"message\":\"❌ Error interno: " + e.getMessage() + "\"}");
        }
    }
    private void listarReservas(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("usuario") == null) {
        response.sendRedirect("views/login.jsp");
        return;
    }

    Usuario usuario = (Usuario) session.getAttribute("usuario");
    int idUsuario = usuario.getId();

    // 🔹 Obtener todas las reservas (paquetes + hoteles)
    var reservas = facade.listarTodasReservasPorUsuario(idUsuario);

    // 🔹 Enviar a la vista
    request.setAttribute("reservas", reservas);
    request.getRequestDispatcher("views/mis_reservas.jsp").forward(request, response);
}

}
