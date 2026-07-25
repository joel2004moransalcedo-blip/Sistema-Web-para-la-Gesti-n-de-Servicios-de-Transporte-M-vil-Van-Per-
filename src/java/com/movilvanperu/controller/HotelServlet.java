package com.movilvanperu.controller;

import com.movilvanperu.dao.HotelDAO;
import com.movilvanperu.model.Hotel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;

@WebServlet("/HotelServlet")
@MultipartConfig
public class HotelServlet extends HttpServlet {

    private final HotelDAO hotelDAO = new HotelDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {

            case "eliminar":
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                hotelDAO.eliminar(idEliminar);
                response.sendRedirect("views/hotel_admin.jsp");
                break;

            default:
                response.sendRedirect("views/hotel_admin.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        switch (accion) {
            case "guardar":
                agregarHotel(request, response);
                break;

            case "actualizar":
                actualizarHotel(request, response);
                break;
        }
    }

    // =====================================
    // AGREGAR HOTEL
    // =====================================
    private void agregarHotel(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        Hotel h = new Hotel();

        h.setNombre(request.getParameter("nombre"));
        h.setDescripcion(request.getParameter("descripcion"));
        h.setDireccion(request.getParameter("direccion"));
        h.setCiudad(request.getParameter("ciudad"));
        h.setPais(request.getParameter("pais"));
        h.setEstrellas(Integer.parseInt(request.getParameter("estrellas")));
        h.setTelefono(request.getParameter("telefono"));
        h.setEmail(request.getParameter("email"));

        // NUEVO → precio
        h.setPrecioNoche(Double.parseDouble(request.getParameter("precio_noche")));

        // Guardar imágenes
        h.setImagen1(guardarImagen(request.getPart("imagen1")));
        h.setImagen2(guardarImagen(request.getPart("imagen2")));
        h.setImagen3(guardarImagen(request.getPart("imagen3")));

        hotelDAO.agregar(h);

        response.sendRedirect("views/hotel_admin.jsp");
    }

    // =====================================
    // ACTUALIZAR HOTEL
    // =====================================
    private void actualizarHotel(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        Hotel h = new Hotel();

        h.setId_hotel(Integer.parseInt(request.getParameter("id_hotel")));
        h.setNombre(request.getParameter("nombre"));
        h.setDescripcion(request.getParameter("descripcion"));
        h.setDireccion(request.getParameter("direccion"));
        h.setCiudad(request.getParameter("ciudad"));
        h.setPais(request.getParameter("pais"));
        h.setEstrellas(Integer.parseInt(request.getParameter("estrellas")));
        h.setTelefono(request.getParameter("telefono"));
        h.setEmail(request.getParameter("email"));

        // NUEVO → precio
        h.setPrecioNoche(Double.parseDouble(request.getParameter("precio_noche")));

        // Mantener o reemplazar imágenes
        h.setImagen1(obtenerNuevaOAnterior(request, "imagen1", "imgActual1"));
        h.setImagen2(obtenerNuevaOAnterior(request, "imagen2", "imgActual2"));
        h.setImagen3(obtenerNuevaOAnterior(request, "imagen3", "imgActual3"));

        hotelDAO.actualizar(h);

        response.sendRedirect("views/hotel_admin.jsp");
    }

    // =====================================
    // GUARDAR IMAGEN
    // =====================================
    private String guardarImagen(Part part) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }

        String nombreArchivo = System.currentTimeMillis() + "_" + part.getSubmittedFileName();

        String ruta = getServletContext().getRealPath("views/images/");
        File directorio = new File(ruta);
        if (!directorio.exists()) {
            directorio.mkdirs();
        }

        part.write(ruta + File.separator + nombreArchivo);

        return nombreArchivo;
    }

    // =====================================
    // NUEVA IMAGEN O ANTERIOR
    // =====================================
    private String obtenerNuevaOAnterior(HttpServletRequest request, String inputFile, String inputActual)
            throws IOException, ServletException {

        Part part = request.getPart(inputFile);
        if (part != null && part.getSize() > 0) {
            return guardarImagen(part);
        }

        return request.getParameter(inputActual);
    }
}
