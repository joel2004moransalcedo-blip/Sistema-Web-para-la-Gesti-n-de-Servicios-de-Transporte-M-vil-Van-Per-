package com.movilvanperu.dao;

import com.movilvanperu.utils.Conexion;
import java.sql.*;
import java.util.*;

/**
 * DAO para gestionar las reservas en la base de datos.
 * Usa la tabla 'reserva' (en singular).
 */
public class ReservaDAO {

    /** 
     * ✅ Registra una nueva reserva 
     */
    public boolean registrarReserva(int idUsuario, int idPaquete, String metodoPago, double total) {
        String sql = "INSERT INTO reserva (id_usuario, id_paquete, metodo_pago, total, estado, fecha_reserva) " +
                     "VALUES (?, ?, ?, ?, 'pendiente', NOW())";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setInt(2, idPaquete);
            ps.setString(3, metodoPago);
            ps.setDouble(4, total);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("❌ Error al registrar la reserva: " + e.getMessage());
            return false;
        }
    }

    /**
     * ✅ Lista todas las reservas de un usuario, uniendo datos del paquete.
     */
    public List<Map<String, Object>> listarReservasPorUsuario(int idUsuario) {
        List<Map<String, Object>> lista = new ArrayList<>();

        String sql = "SELECT r.id AS id_reserva, r.id_usuario, r.id_paquete, r.fecha_reserva, " +
                     "r.estado, r.metodo_pago, r.total, " +
                     "p.nombre AS paquete_nombre, p.imagen1 AS paquete_imagen1 " +
                     "FROM reserva r " +
                     "LEFT JOIN paquetes p ON p.id = r.id_paquete " +
                     "WHERE r.id_usuario = ? " +
                     "ORDER BY r.fecha_reserva DESC";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("id_reserva", rs.getInt("id_reserva"));
                    map.put("id_usuario", rs.getInt("id_usuario"));
                    map.put("id_paquete", rs.getInt("id_paquete"));
                    map.put("fecha_reserva", rs.getString("fecha_reserva"));
                    map.put("estado", rs.getString("estado"));
                    map.put("metodo_pago", rs.getString("metodo_pago"));
                    map.put("total", rs.getDouble("total"));
                    map.put("paquete_nombre", rs.getString("paquete_nombre"));
                    map.put("paquete_imagen1", rs.getString("paquete_imagen1"));
                    lista.add(map);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("❌ Error al listar reservas del usuario: " + e.getMessage());
        }

        return lista;
    }

    /**
     * ✅ Obtiene una reserva por ID, incluyendo los datos del paquete asociado.
     */
    public Map<String, Object> obtenerReservaPorId(int idReserva) {
        Map<String, Object> reserva = null;

        String sql = "SELECT r.id AS id_reserva, r.id_usuario, r.id_paquete, r.fecha_reserva, " +
                     "r.estado, r.metodo_pago, r.total, " +
                     "p.nombre AS paquete_nombre, p.imagen1 AS paquete_imagen1 " +
                     "FROM reserva r " +
                     "LEFT JOIN paquetes p ON p.id = r.id_paquete " +
                     "WHERE r.id = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idReserva);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    reserva = new LinkedHashMap<>();
                    reserva.put("id_reserva", rs.getInt("id_reserva"));
                    reserva.put("id_usuario", rs.getInt("id_usuario"));
                    reserva.put("id_paquete", rs.getInt("id_paquete"));
                    reserva.put("fecha_reserva", rs.getString("fecha_reserva"));
                    reserva.put("estado", rs.getString("estado"));
                    reserva.put("metodo_pago", rs.getString("metodo_pago"));
                    reserva.put("total", rs.getDouble("total"));
                    reserva.put("paquete_nombre", rs.getString("paquete_nombre"));
                    reserva.put("paquete_imagen1", rs.getString("paquete_imagen1"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("❌ Error al obtener reserva por ID: " + e.getMessage());
        }

        return reserva;
    }

    /**
     * ✅ Elimina una reserva por su ID.
     */
    public boolean eliminar(int idReserva) {
        String sql = "DELETE FROM reserva WHERE id = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idReserva);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("❌ Error al eliminar reserva: " + e.getMessage());
            return false;
        }
    }

    /**
     * ✅ Actualiza el estado de una reserva (ej: 'activa', 'cancelada', 'finalizada')
     */
public boolean actualizarEstadoReserva(int idReserva, String nuevoEstado) {
    String sql = "UPDATE reserva SET estado = ? WHERE id = ?";
    try (Connection conn = Conexion.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, nuevoEstado);
        ps.setInt(2, idReserva);

        int filas = ps.executeUpdate();
        return filas > 0;

    } catch (Exception e) {
        e.printStackTrace(); 
        return false;
    }
}


public boolean cancelarReserva(int idReserva) {
    String sql = "UPDATE reserva SET estado = 'cancelada' WHERE id = ?";
    try (Connection con = Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, idReserva);
        int rows = ps.executeUpdate();
        return rows > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
// 🔍 Lista todas las reservas con datos del usuario y del paquete
public List<Map<String, Object>> listarTodasLasReservas() {
    List<Map<String, Object>> lista = new ArrayList<>();

    String sql = "SELECT r.id AS id_reserva, " +
                 "r.fecha_reserva, r.estado, r.total, " +
                 "CONCAT(u.nombre, ' ', u.apellido) AS nombre_usuario, " +
                 "p.nombre AS nombre_paquete " +
                 "FROM reserva r " +
                 "LEFT JOIN usuarios u ON r.id_usuario = u.id " +
                 "LEFT JOIN paquetes p ON r.id_paquete = p.id " +
                 "ORDER BY r.fecha_reserva DESC";

    try (Connection conn = Conexion.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Map<String, Object> fila = new HashMap<>();
            fila.put("id_reserva", rs.getInt("id_reserva"));
            fila.put("nombre_usuario", rs.getString("nombre_usuario"));
            fila.put("nombre_paquete", rs.getString("nombre_paquete"));
            fila.put("fecha_reserva", rs.getString("fecha_reserva"));
            fila.put("estado", rs.getString("estado"));
            fila.put("total", rs.getDouble("total"));
            lista.add(fila);
        }

        System.out.println("✅ Total de reservas encontradas: " + lista.size());

    } catch (SQLException e) {
        System.err.println("❌ Error al listar todas las reservas: " + e.getMessage());
        e.printStackTrace();
    }

    return lista;
}
public int contarReservasPagadasPorPromocion(int idUsuario, int idPromocion) {

    String sql = """
        SELECT COUNT(*) AS total
        FROM reserva r
        JOIN promociones p ON p.id_paquete_gratis = r.id_paquete
        WHERE r.id_usuario = ?
          AND p.id = ?
          AND r.estado = 'pagada'
          AND (r.metodo_pago IS NULL OR r.metodo_pago != 'promocion')
    """;

    try (Connection con = Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, idUsuario);
        ps.setInt(2, idPromocion);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return 0;
}


public void crearReservaGratuita(int idUsuario, int idPromo) {
    String sql = """
        INSERT INTO reserva (id_usuario, id_paquete, metodo_pago, total, estado, fecha_reserva)
        VALUES (
            ?, 
            (SELECT id_paquete_gratis FROM promociones WHERE id = ?),
            'promocion',
            0,
            'pagada',
            NOW()
        );
    """;

    try (Connection con = Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, idUsuario);
        ps.setInt(2, idPromo);
        ps.executeUpdate();

    } catch (SQLException e) {
        e.printStackTrace();
    }
}



}
