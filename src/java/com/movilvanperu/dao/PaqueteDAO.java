package com.movilvanperu.dao;

import com.movilvanperu.model.Paquete;
import com.movilvanperu.utils.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;


public class PaqueteDAO {

    // ✅ LISTAR TODOS LOS PAQUETES
    public List<Paquete> listar() {
        List<Paquete> lista = new ArrayList<>();
        String sql = "SELECT * FROM paquetes ORDER BY creado_en DESC";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapResultSetToPaquete(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    // ✅ LISTAR LOS ÚLTIMOS 3 PAQUETES
    public List<Paquete> listarUltimos3() {
        List<Paquete> lista = new ArrayList<>();
        String sql = "SELECT * FROM paquetes ORDER BY creado_en DESC LIMIT 3";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapResultSetToPaquete(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    // ✅ AGREGAR NUEVO PAQUETE
    public boolean agregar(Paquete p) {
        String sql = """
            INSERT INTO paquetes 
            (nombre, descripcion, precio, destino, fecha_salida, fecha_retorno, imagen1, imagen2, imagen3, valoracion) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getNombre());
            ps.setString(2, p.getDescripcion());
            ps.setDouble(3, p.getPrecio());
            ps.setString(4, p.getDestino());
            ps.setString(5, p.getFechaSalida());
            ps.setString(6, p.getFechaRetorno());
            ps.setString(7, p.getImagen1());
            ps.setString(8, p.getImagen2());
            ps.setString(9, p.getImagen3());
            ps.setInt(10, p.getValoracion());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ ACTUALIZAR PAQUETE
    public boolean actualizar(Paquete p) {
        String sql = """
            UPDATE paquetes 
            SET nombre=?, descripcion=?, precio=?, destino=?, fecha_salida=?, fecha_retorno=?, 
                imagen1=?, imagen2=?, imagen3=?, valoracion=? 
            WHERE id=?
        """;

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getNombre());
            ps.setString(2, p.getDescripcion());
            ps.setDouble(3, p.getPrecio());
            ps.setString(4, p.getDestino());
            ps.setString(5, p.getFechaSalida());
            ps.setString(6, p.getFechaRetorno());
            ps.setString(7, p.getImagen1());
            ps.setString(8, p.getImagen2());
            ps.setString(9, p.getImagen3());
            ps.setInt(10, p.getValoracion());
            ps.setInt(11, p.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ ELIMINAR PAQUETE
    public boolean eliminar(int id) {
        String sql = "DELETE FROM paquetes WHERE id=?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ OBTENER PAQUETE POR ID
    public Paquete obtenerPorId(int id) {
        String sql = "SELECT * FROM paquetes WHERE id=?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPaquete(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // ✅ MÉTODO PRIVADO PARA MAPEAR RESULTSET → OBJETO Paquete
    private Paquete mapResultSetToPaquete(ResultSet rs) throws SQLException {
        Paquete p = new Paquete();
        p.setId(rs.getInt("id"));
        p.setNombre(rs.getString("nombre"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setPrecio(rs.getDouble("precio"));
        p.setDestino(rs.getString("destino"));
        p.setFechaSalida(rs.getString("fecha_salida"));
        p.setFechaRetorno(rs.getString("fecha_retorno"));
        p.setImagen1(rs.getString("imagen1"));
        p.setImagen2(rs.getString("imagen2"));
        p.setImagen3(rs.getString("imagen3"));
        p.setValoracion(rs.getInt("valoracion"));
        return p;
    }
public List<Map<String, Object>> listarPaquetesConFechas() {
    List<Map<String, Object>> lista = new ArrayList<>();

    String sql = "SELECT id AS id_paquete, nombre AS nombre_paquete, destino, fecha_salida, fecha_retorno " +
                 "FROM paquetes ORDER BY fecha_salida ASC";

    try (Connection conn = Conexion.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {

        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id_paquete", rs.getInt("id_paquete"));
            map.put("nombre_paquete", rs.getString("nombre_paquete"));
            map.put("destino", rs.getString("destino"));
            map.put("fecha_salida", rs.getString("fecha_salida"));
            map.put("fecha_retorno", rs.getString("fecha_retorno"));
            lista.add(map);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return lista;
}


}
