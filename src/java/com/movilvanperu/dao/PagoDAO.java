package com.movilvanperu.dao;

import com.movilvanperu.utils.Conexion;
import java.sql.*;
import java.util.*;

/**
 * DAO para la tabla 'pago'.
 * Gestiona los pagos asociados a las reservas.
 */
public class PagoDAO {

    /**
     * ✅ Registrar un nuevo pago.
     */
    public boolean registrarPago(int idReserva, String metodo, String numeroTarjeta, String nombreTitular, double monto) {
        String sql = "INSERT INTO pago (id_reserva, metodo, numero_tarjeta, nombre_titular, monto, estado, fecha_pago, codigo_pago) " +
                     "VALUES (?, ?, ?, ?, ?, 'pendiente', NOW(), ?)";
        String codigoPago = "PAY-" + System.currentTimeMillis();

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idReserva);
            ps.setString(2, metodo);
            ps.setString(3, numeroTarjeta);
            ps.setString(4, nombreTitular);
            ps.setDouble(5, monto);
            ps.setString(6, codigoPago);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("❌ Error al registrar pago: " + e.getMessage());
            return false;
        }
    }

    /**
     * ✅ Listar todos los pagos asociados a una reserva.
     */
    public List<Map<String, Object>> listarPagosPorReserva(int idReserva) {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT * FROM pago WHERE id_reserva = ? ORDER BY fecha_pago DESC";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idReserva);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("id", rs.getInt("id"));
                    map.put("id_reserva", rs.getInt("id_reserva"));
                    map.put("codigo_pago", rs.getString("codigo_pago")); // ✅ agregado
                    map.put("metodo", rs.getString("metodo"));
                    map.put("numero_tarjeta", rs.getString("numero_tarjeta"));
                    map.put("nombre_titular", rs.getString("nombre_titular"));
                    map.put("fecha_pago", rs.getString("fecha_pago"));
                    map.put("monto", rs.getDouble("monto"));
                    map.put("estado", rs.getString("estado"));
                    lista.add(map);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("❌ Error al listar pagos: " + e.getMessage());
        }
        return lista;
    }

    /**
     * ✅ Obtener un pago por su ID.
     */
    public Map<String, Object> obtenerPagoPorId(int idPago) {
        String sql = "SELECT * FROM pago WHERE id = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idPago);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("id", rs.getInt("id"));
                    map.put("id_reserva", rs.getInt("id_reserva"));
                    map.put("codigo_pago", rs.getString("codigo_pago")); // ✅ agregado
                    map.put("metodo", rs.getString("metodo"));
                    map.put("numero_tarjeta", rs.getString("numero_tarjeta"));
                    map.put("nombre_titular", rs.getString("nombre_titular"));
                    map.put("fecha_pago", rs.getString("fecha_pago"));
                    map.put("monto", rs.getDouble("monto"));
                    map.put("estado", rs.getString("estado"));
                    return map;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("❌ Error al obtener pago por ID: " + e.getMessage());
        }
        return null;
    }

    /**
     * ✅ Actualizar el estado del pago (ej: pendiente → completado / fallido)
     */
    public boolean actualizarEstadoPago(int idPago, String nuevoEstado) {
        String sql = "UPDATE pago SET estado = ? WHERE id = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nuevoEstado);
            ps.setInt(2, idPago);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("❌ Error al actualizar estado de pago: " + e.getMessage());
            return false;
        }
    }

    /**
     * ✅ Eliminar un pago (opcional)
     */
    public boolean eliminar(int idPago) {
        String sql = "DELETE FROM pago WHERE id = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idPago);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("❌ Error al eliminar pago: " + e.getMessage());
            return false;
        }
    }
}
