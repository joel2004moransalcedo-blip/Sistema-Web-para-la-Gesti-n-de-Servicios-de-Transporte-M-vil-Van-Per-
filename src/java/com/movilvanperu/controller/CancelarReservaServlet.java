package com.movilvanperu.controller;

import com.movilvanperu.facade.SistemaViajesFacade;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/CancelarReservaServlet")
public class CancelarReservaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🧾 Obtener el ID de la reserva desde el formulario
        String idReservaStr = request.getParameter("id_reserva");
        String tipo = request.getParameter("tipo"); 

        if (idReservaStr != null && !idReservaStr.isEmpty()) {
            try {
                int idReserva = Integer.parseInt(idReservaStr);

                // ✅ Usar el facade para cancelar la reserva
                SistemaViajesFacade facade = new SistemaViajesFacade();
                 boolean exito = facade.cancelarReserva(idReserva, tipo); 

                if (exito) {
                    // 🔁 Redirigir a la lista de reservas con mensaje de éxito
                    response.sendRedirect(request.getContextPath() + "/views/mis_reservas.jsp?msg=cancelada");
                } else {
                    response.sendRedirect(request.getContextPath() + "/views/mis_reservas.jsp?error=no_cancelada");
                }

            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/views/mis_reservas.jsp?error=formato");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/views/mis_reservas.jsp?error=falta_id");
        }
    }
}
