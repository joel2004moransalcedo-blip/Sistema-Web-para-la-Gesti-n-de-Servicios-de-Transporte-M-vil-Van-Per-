package com.movilvanperu.controller;

import com.movilvanperu.facade.SistemaViajesFacade;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/eliminarPromocion")
public class EliminarPromocionServlet extends HttpServlet {

    private final SistemaViajesFacade facade = new SistemaViajesFacade();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            boolean eliminado = facade.eliminarPromocion(id);

            if (eliminado) {
                response.sendRedirect("views/admin-promociones.jsp?success=delete");
            } else {
                response.sendRedirect("views/admin-promociones.jsp?error=deletefail");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("views/admin-promociones.jsp?error=Exception");
        }
    }
}
