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

@WebServlet("/editarPromocion")
@MultipartConfig
public class EditarPromocionServlet extends HttpServlet {

    private final SistemaViajesFacade facade = new SistemaViajesFacade();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            int idPaqueteGratis = Integer.parseInt(request.getParameter("idPaqueteGratis"));
            int cantidadReservas = Integer.parseInt(request.getParameter("cantidadReservas"));

            // Obtener estado desde el formulario
            String estado = request.getParameter("estado");

            // Datos actuales
            Promocion promoActual = facade.obtenerPromocionPorId(id);
            if (promoActual == null) {
                response.sendRedirect("views/admin-promociones.jsp?error=NotFound");
                return;
            }

            /* ================================
               PROCESAR NUEVA IMAGEN (OPCIONAL)
               ================================ */
            Part filePart = request.getPart("banner");
            String bannerFinal = promoActual.getBanner(); // por defecto conserva el anterior

            if (filePart != null && filePart.getSize() > 0) {

                String originalName = filePart.getSubmittedFileName();
                String fileName = System.currentTimeMillis() + "_" +
                        originalName.replaceAll("[^a-zA-Z0-9\\.\\-_]", "_");

                String uploadDir = request.getServletContext().getRealPath("/views/images");
                File folder = new File(uploadDir);
                if (!folder.exists()) folder.mkdirs();

                Files.copy(filePart.getInputStream(), new File(folder, fileName).toPath());

                bannerFinal = fileName;
            }

            /* ================================
               ACTUALIZAR PROMOCIÓN
               ================================ */
            Promocion promo = new Promocion();
            promo.setId(id);
            promo.setNombre(nombre);
            promo.setDescripcion(descripcion);
            promo.setIdPaqueteGratis(idPaqueteGratis);
            promo.setCantidadRequerida(cantidadReservas);
            promo.setBanner(bannerFinal);

            // 🔥 FALTABA ESTO → evita que la promo quede en NULL
            promo.setEstado(estado);

            boolean ok = facade.actualizarPromocion(promo);

            if (ok) {
                response.sendRedirect("views/admin-promociones.jsp?success=edit");
            } else {
                response.sendRedirect("views/admin-promociones.jsp?error=update");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("views/admin-promociones.jsp?error=Exception");
        }
    }
}
