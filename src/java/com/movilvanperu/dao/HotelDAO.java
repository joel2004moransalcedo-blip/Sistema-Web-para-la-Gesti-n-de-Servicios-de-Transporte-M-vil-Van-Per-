package com.movilvanperu.dao;

import com.movilvanperu.model.Hotel;
import com.movilvanperu.utils.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HotelDAO {

    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public HotelDAO() {
        con = Conexion.getConnection();
    }

    // ===============================
    // LISTAR HOTELES
    // ===============================
    public List<Hotel> listar() {
        List<Hotel> lista = new ArrayList<>();
        String sql = "SELECT * FROM hotel";

        try {
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Hotel h = new Hotel();

                h.setId_hotel(rs.getInt("id_hotel"));
                h.setNombre(rs.getString("nombre"));
                h.setDescripcion(rs.getString("descripcion"));
                h.setDireccion(rs.getString("direccion"));
                h.setCiudad(rs.getString("ciudad"));
                h.setPais(rs.getString("pais"));
                h.setEstrellas(rs.getInt("estrellas"));
                h.setTelefono(rs.getString("telefono"));
                h.setEmail(rs.getString("email"));
                h.setPrecioNoche(rs.getDouble("precio_noche"));   // 🔥 NUEVO
                h.setImagen1(rs.getString("imagen1"));
                h.setImagen2(rs.getString("imagen2"));
                h.setImagen3(rs.getString("imagen3"));

                lista.add(h);
            }

        } catch (Exception e) {
            System.out.println("Error al listar hoteles: " + e.getMessage());
        }
        return lista;
    }

    // ===============================
    // OBTENER POR ID
    // ===============================
    public Hotel obtenerPorId(int id) {
        Hotel h = null;
        String sql = "SELECT * FROM hotel WHERE id_hotel = ?";

        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                h = new Hotel();

                h.setId_hotel(rs.getInt("id_hotel"));
                h.setNombre(rs.getString("nombre"));
                h.setDescripcion(rs.getString("descripcion"));
                h.setDireccion(rs.getString("direccion"));
                h.setCiudad(rs.getString("ciudad"));
                h.setPais(rs.getString("pais"));
                h.setEstrellas(rs.getInt("estrellas"));
                h.setTelefono(rs.getString("telefono"));
                h.setEmail(rs.getString("email"));
                h.setPrecioNoche(rs.getDouble("precio_noche")); // 🔥 NUEVO
                h.setImagen1(rs.getString("imagen1"));
                h.setImagen2(rs.getString("imagen2"));
                h.setImagen3(rs.getString("imagen3"));
            }

        } catch (Exception e) {
            System.out.println("Error al obtener hotel: " + e.getMessage());
        }
        return h;
    }

    // ===============================
    // AGREGAR
    // ===============================
    public boolean agregar(Hotel h) {
        String sql = "INSERT INTO hotel(nombre, descripcion, direccion, ciudad, pais, estrellas, telefono, email, precio_noche, imagen1, imagen2, imagen3) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            ps = con.prepareStatement(sql);

            ps.setString(1, h.getNombre());
            ps.setString(2, h.getDescripcion());
            ps.setString(3, h.getDireccion());
            ps.setString(4, h.getCiudad());
            ps.setString(5, h.getPais());
            ps.setInt(6, h.getEstrellas());
            ps.setString(7, h.getTelefono());
            ps.setString(8, h.getEmail());
            ps.setDouble(9, h.getPrecioNoche());   // 🔥 NUEVO
            ps.setString(10, h.getImagen1());
            ps.setString(11, h.getImagen2());
            ps.setString(12, h.getImagen3());

            ps.executeUpdate();
            return true;

        } catch (Exception e) {
            System.out.println("Error al agregar hotel: " + e.getMessage());
            return false;
        }
    }

    // ===============================
    // ACTUALIZAR
    // ===============================
    public boolean actualizar(Hotel h) {
        String sql = "UPDATE hotel SET nombre=?, descripcion=?, direccion=?, ciudad=?, pais=?, estrellas=?, telefono=?, email=?, precio_noche=?, imagen1=?, imagen2=?, imagen3=? "
                   + "WHERE id_hotel=?";

        try {
            ps = con.prepareStatement(sql);

            ps.setString(1, h.getNombre());
            ps.setString(2, h.getDescripcion());
            ps.setString(3, h.getDireccion());
            ps.setString(4, h.getCiudad());
            ps.setString(5, h.getPais());
            ps.setInt(6, h.getEstrellas());
            ps.setString(7, h.getTelefono());
            ps.setString(8, h.getEmail());
            ps.setDouble(9, h.getPrecioNoche());   // 🔥 NUEVO
            ps.setString(10, h.getImagen1());
            ps.setString(11, h.getImagen2());
            ps.setString(12, h.getImagen3());
            ps.setInt(13, h.getId_hotel());

            ps.executeUpdate();
            return true;

        } catch (Exception e) {
            System.out.println("Error al actualizar hotel: " + e.getMessage());
            return false;
        }
    }

    // ===============================
    // ELIMINAR
    // ===============================
    public boolean eliminar(int id) {
        String sql = "DELETE FROM hotel WHERE id_hotel=?";

        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);

            ps.executeUpdate();
            return true;

        } catch (Exception e) {
            System.out.println("Error al eliminar hotel: " + e.getMessage());
            return false;
        }
    }
}
