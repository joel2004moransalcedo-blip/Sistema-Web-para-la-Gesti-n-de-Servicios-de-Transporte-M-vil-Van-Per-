package com.movilvanperu.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.movilvanperu.facade.SistemaViajesFacade;
import com.movilvanperu.model.Usuario;

import java.io.IOException;

@WebServlet("/ReclamarPromocionServlet")
public class ReclamarPromocionServlet extends HttpServlet {

    private SistemaViajesFacade facade = new SistemaViajesFacade();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verificar sesión
        HttpSession session = request.getSession(false);
        Usuario usuario = (Usuario) (session != null ? session.getAttribute("usuario") : null);

        if (usuario == null) {
            response.sendRedirect("views/login.jsp");
            return;
        }

        try {
            int idPromo = Integer.parseInt(request.getParameter("idPromo"));

            // Registrar reclamo de promoción
facade.registrarClaimPromocion(usuario.getId(), idPromo);


            // Crear reserva gratuita
            facade.crearReservaGratuita(usuario.getId(), idPromo);

            // Redirige al usuario a sus reservas
            response.sendRedirect("views/mis_reservas.jsp");

        } catch (Exception e) {
    e.printStackTrace();
    request.setAttribute("error", e.getMessage());
    request.getRequestDispatcher("views/error.jsp").forward(request, response);
}

    }
}
