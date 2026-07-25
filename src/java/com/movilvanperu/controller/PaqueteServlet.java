package com.movilvanperu.controller;

import com.movilvanperu.model.Paquete;
import com.movilvanperu.dao.PaqueteDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Objects;

import jakarta.servlet.http.Part;

@WebServlet("/PaqueteServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,   // 1MB
    maxFileSize = 1024 * 1024 * 10,        // 10MB
    maxRequestSize = 1024 * 1024 * 50      // 50MB
)
public class PaqueteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private PaqueteDAO dao;

    @Override
    public void init() {
        dao = new PaqueteDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "editar":
                mostrarFormularioEditar(request, response);
                break;
            case "eliminar":
                manejarEliminar(request, response);
                break;
            default:
                listarPaquetes(request, response);
                break;
        }
    }

    private void listarPaquetes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Paquete> lista = dao.listar();
        request.setAttribute("listaPaquetes", lista);
        request.getRequestDispatcher("/views/paquetes.jsp").forward(request, response);
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Paquete paquete = dao.obtenerPorId(id);
        request.setAttribute("paquete", paquete);
        request.getRequestDispatcher("/views/paquete_form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) accion = "";

        switch (accion) {
            case "agregar":
                manejarAgregar(request, response);
                break;
            case "editar":
                manejarEditar(request, response);
                break;
            case "eliminar":
                manejarEliminar(request, response);
                break;
            default:
                listarPaquetes(request, response);
        }
    }

    // --- AGREGAR ---
    private void manejarAgregar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try {
            Paquete p = new Paquete();
            p.setNombre(request.getParameter("nombre"));
            p.setDescripcion(request.getParameter("descripcion"));
            p.setDestino(request.getParameter("destino"));
            p.setPrecio(Double.parseDouble(Objects.toString(request.getParameter("precio"), "0")));
            p.setFechaSalida(request.getParameter("fecha_salida"));
            p.setFechaRetorno(request.getParameter("fecha_retorno"));

            // ⭐ Valoración
            String valStr = request.getParameter("valoracion");
            int valoracion = (valStr != null && !valStr.isEmpty()) ? Integer.parseInt(valStr) : 0;
            p.setValoracion(valoracion);

            // --- Subida de imágenes ---
            String webDir = "/views/images/paquetes";
            String uploadPath = getServletContext().getRealPath(webDir);
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            for (int i = 1; i <= 3; i++) {
                Part part = request.getPart("imagen" + i);
                if (part != null && part.getSize() > 0) {
                    String original = part.getSubmittedFileName();
                    String filename = System.currentTimeMillis() + "_" + original.replaceAll("[^a-zA-Z0-9\\.\\-_]", "_");
                    part.write(uploadPath + File.separator + filename);
                    String relative = webDir.substring(1) + "/" + filename;
                    switch (i) {
                        case 1 -> p.setImagen1(relative);
                        case 2 -> p.setImagen2(relative);
                        case 3 -> p.setImagen3(relative);
                    }
                }
            }

            boolean ok = dao.agregar(p);
            response.getWriter().print(ok
                ? "{\"success\": true, \"message\": \"✅ Paquete agregado correctamente.\"}"
                : "{\"success\": false, \"message\": \"⚠️ No se pudo agregar el paquete.\"}");

        } catch (Exception ex) {
            ex.printStackTrace();
            response.getWriter().print("{\"success\": false, \"message\": \"❌ Error: " + ex.getMessage().replace("\"","\\\"") + "\"}");
        }
    }

    // --- EDITAR ---
    private void manejarEditar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Paquete p = dao.obtenerPorId(id);
            if (p == null) {
                response.getWriter().print("{\"success\": false, \"message\": \"⚠️ Paquete no encontrado.\"}");
                return;
            }

            p.setNombre(request.getParameter("nombre"));
            p.setDescripcion(request.getParameter("descripcion"));
            p.setDestino(request.getParameter("destino"));
            p.setPrecio(Double.parseDouble(Objects.toString(request.getParameter("precio"), "0")));
            p.setFechaSalida(request.getParameter("fecha_salida"));
            p.setFechaRetorno(request.getParameter("fecha_retorno"));

            // ⭐ Valoración
            String valStr = request.getParameter("valoracion");
            int valoracion = (valStr != null && !valStr.isEmpty()) ? Integer.parseInt(valStr) : p.getValoracion();
            p.setValoracion(valoracion);

            // --- Subida de imágenes ---
            String webDir = "/views/images/paquetes";
            String uploadPath = getServletContext().getRealPath(webDir);
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            for (int i = 1; i <= 3; i++) {
                Part part = request.getPart("imagen" + i);
                if (part != null && part.getSize() > 0) {
                    String original = part.getSubmittedFileName();
                    String filename = System.currentTimeMillis() + "_" + original.replaceAll("[^a-zA-Z0-9\\.\\-_]", "_");
                    part.write(uploadPath + File.separator + filename);
                    String relative = webDir.substring(1) + "/" + filename;
                    switch (i) {
                        case 1 -> p.setImagen1(relative);
                        case 2 -> p.setImagen2(relative);
                        case 3 -> p.setImagen3(relative);
                    }
                }
            }

            boolean ok = dao.actualizar(p);
            response.getWriter().print(ok
                ? "{\"success\": true, \"message\": \"✅ Paquete actualizado correctamente.\"}"
                : "{\"success\": false, \"message\": \"⚠️ No se pudo actualizar el paquete.\"}");

        } catch (Exception ex) {
            ex.printStackTrace();
            response.getWriter().print("{\"success\": false, \"message\": \"❌ Error: " + ex.getMessage().replace("\"","\\\"") + "\"}");
        }
    }

    // --- ELIMINAR ---
    private void manejarEliminar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Paquete p = dao.obtenerPorId(id);
            boolean ok = dao.eliminar(id);

            if (ok && p != null) {
                borrarArchivoFisico(p.getImagen1());
                borrarArchivoFisico(p.getImagen2());
                borrarArchivoFisico(p.getImagen3());
            }

            response.getWriter().print(ok
                ? "{\"success\": true, \"message\": \"🗑️ Paquete eliminado correctamente.\"}"
                : "{\"success\": false, \"message\": \"⚠️ No se pudo eliminar el paquete.\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("{\"success\": false, \"message\": \"❌ Error: " + e.getMessage().replace("\"","\\\"") + "\"}");
        }
    }

    private void borrarArchivoFisico(String relativePath) {
        if (relativePath == null || relativePath.trim().isEmpty()) return;
        try {
            String real = getServletContext().getRealPath("/" + relativePath);
            if (real != null) {
                File f = new File(real);
                if (f.exists()) f.delete();
            }
        } catch (Exception ignored) {}
    }
}
