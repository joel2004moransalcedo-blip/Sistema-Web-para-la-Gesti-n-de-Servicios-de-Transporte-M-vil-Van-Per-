package com.movilvanperu.controller;

import com.movilvanperu.dao.HotelDAO;
import com.movilvanperu.model.Hotel;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/hoteles")
public class HotelRestServlet extends HttpServlet {

    private final HotelDAO hotelDAO = new HotelDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar tipo de respuesta
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Obtener lista de hoteles desde la base de datos
        List<Hotel> hoteles = hotelDAO.listar();

        // Agregar ruta completa de imágenes para el frontend
        for (Hotel h : hoteles) {
            if (h.getImagen1() != null) h.setImagen1(request.getContextPath() + "/views/images/" + h.getImagen1());
            if (h.getImagen2() != null) h.setImagen2(request.getContextPath() + "/views/images/" + h.getImagen2());
            if (h.getImagen3() != null) h.setImagen3(request.getContextPath() + "/views/images/" + h.getImagen3());
        }

        // Convertir a JSON
        String hotelesJson = gson.toJson(hoteles);

        // Enviar JSON al cliente
        PrintWriter out = response.getWriter();
        out.print(hotelesJson);
        out.flush();
    }
}
