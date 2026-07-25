package com.movilvanperu.controller;

import com.movilvanperu.facade.SistemaViajesFacade;
import com.movilvanperu.model.Promocion;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@WebServlet("/crearPromocion")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 20
)
public class PromocionCrearServlet extends HttpServlet {

    private final SistemaViajesFacade facade = new SistemaViajesFacade();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            int idPaqueteGratis = Integer.parseInt(request.getParameter("idPaqueteGratis"));
            int cantidadReservas = Integer.parseInt(request.getParameter("cantidadReservas"));

            Part filePart = request.getPart("banner");
            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect(request.getContextPath() + "/views/admin-promociones.jsp?error=NoImagen");
                return;
            }

            String originalFileName = filePart.getSubmittedFileName();

            String fileName = System.currentTimeMillis() + "_" +
                    originalFileName.replaceAll("[^a-zA-Z0-9\\.\\-_]", "_");

            String uploadDir = request.getServletContext().getRealPath("/views/images");
            File folder = new File(uploadDir);
            if (!folder.exists()) folder.mkdirs();

            File destino = new File(folder, fileName);
            Files.copy(filePart.getInputStream(), destino.toPath());

            String bannerNombre = fileName;

            Promocion promo = new Promocion();
            promo.setNombre(nombre);
            promo.setDescripcion(descripcion);
            promo.setIdPaqueteGratis(idPaqueteGratis);
            promo.setCantidadRequerida(cantidadReservas);
            promo.setBanner(bannerNombre);
            promo.setEstado("activa");

            boolean creado = facade.crearPromocion(promo);

            if (creado) {
                response.sendRedirect(request.getContextPath() + "/views/admin-promociones.jsp?success=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/views/admin-promociones.jsp?error=BD");
            }

        } catch (NumberFormatException nfe) {
            nfe.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/admin-promociones.jsp?error=Formato");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/admin-promociones.jsp?error=Exception");
        }
    }
}
