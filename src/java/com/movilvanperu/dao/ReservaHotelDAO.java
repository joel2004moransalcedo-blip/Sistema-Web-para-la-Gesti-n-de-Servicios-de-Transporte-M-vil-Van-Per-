package com.movilvanperu.dao;

import com.movilvanperu.model.ReservaHotel;
import com.movilvanperu.utils.Conexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class ReservaHotelDAO {

    private Connection conn;

    public ReservaHotelDAO() {
        conn = Conexion.getConnection();
    }

    // ==========================
    // AGREGAR RESERVA
    // ==========================
    public boolean agregar(ReservaHotel reserva) {
        // Calcular total dinámicamente si no se ha proporcionado
        if (reserva.getTotal() <= 0) {
            reserva.calcularTotal();
        }

        String sql = "INSERT INTO reserva_hotel (id_usuario, id_hotel, fecha_inicio, fecha_fin, precio_noche, total, estado) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reserva.getId_usuario());
            ps.setInt(2, reserva.getId_hotel());
            ps.setDate(3, new java.sql.Date(reserva.getFecha_inicio().getTime()));
            ps.setDate(4, new java.sql.Date(reserva.getFecha_fin().getTime()));
            ps.setDouble(5, reserva.getPrecio_noche());
            ps.setDouble(6, reserva.getTotal());
            ps.setString(7, reserva.getEstado());

            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==========================
    // LISTAR RESERVAS POR USUARIO
    // ==========================
    public List<ReservaHotel> listarPorUsuario(int id_usuario) {
        List<ReservaHotel> lista = new ArrayList<>();
        String sql = "SELECT * FROM reserva_hotel WHERE id_usuario = ? ORDER BY fecha_reserva DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id_usuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReservaHotel r = new ReservaHotel();
                r.setId_reserva_hotel(rs.getInt("id_reserva_hotel"));
                r.setId_usuario(rs.getInt("id_usuario"));
                r.setId_hotel(rs.getInt("id_hotel"));
                r.setFecha_inicio(rs.getDate("fecha_inicio"));
                r.setFecha_fin(rs.getDate("fecha_fin"));
                r.setPrecio_noche(rs.getDouble("precio_noche"));
                r.setTotal(rs.getDouble("total"));
                r.setEstado(rs.getString("estado"));
                r.setFecha_reserva(rs.getTimestamp("fecha_reserva"));
                lista.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ==========================
    // OBTENER RESERVA POR ID
    // ==========================
    public ReservaHotel obtenerPorId(int id_reserva_hotel) {
        String sql = "SELECT * FROM reserva_hotel WHERE id_reserva_hotel = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id_reserva_hotel);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ReservaHotel r = new ReservaHotel();
                r.setId_reserva_hotel(rs.getInt("id_reserva_hotel"));
                r.setId_usuario(rs.getInt("id_usuario"));
                r.setId_hotel(rs.getInt("id_hotel"));
                r.setFecha_inicio(rs.getDate("fecha_inicio"));
                r.setFecha_fin(rs.getDate("fecha_fin"));
                r.setPrecio_noche(rs.getDouble("precio_noche"));
                r.setTotal(rs.getDouble("total"));
                r.setEstado(rs.getString("estado"));
                r.setFecha_reserva(rs.getTimestamp("fecha_reserva"));
                return r;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ==========================
    // ACTUALIZAR ESTADO DE RESERVA
    // ==========================
    public boolean actualizarEstado(int id_reserva_hotel, String estado) {
        String sql = "UPDATE reserva_hotel SET estado = ? WHERE id_reserva_hotel = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setInt(2, id_reserva_hotel);
            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==========================
    // LISTAR RESERVAS CON JOIN HOTEL 
    // ==========================
    public List<ReservaHotel> listarConHotel() {
        List<ReservaHotel> lista = new ArrayList<>();
        String sql = "SELECT r.*, h.precio_noche FROM reserva_hotel r " +
                     "JOIN hotel h ON r.id_hotel = h.id_hotel ORDER BY r.fecha_reserva DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReservaHotel r = new ReservaHotel();
                r.setId_reserva_hotel(rs.getInt("id_reserva_hotel"));
                r.setId_usuario(rs.getInt("id_usuario"));
                r.setId_hotel(rs.getInt("id_hotel"));
                r.setFecha_inicio(rs.getDate("fecha_inicio"));
                r.setFecha_fin(rs.getDate("fecha_fin"));
                r.setPrecio_noche(rs.getDouble("precio_noche"));
                r.setTotal(rs.getDouble("total"));
                r.setEstado(rs.getString("estado"));
                r.setFecha_reserva(rs.getTimestamp("fecha_reserva"));
                lista.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
public boolean registrarPago(int idReserva, String metodo, String numeroTarjeta, String nombreTitular, double monto) {
    String sql = "INSERT INTO pago_hotel(id_reserva_hotel, metodo, numero_tarjeta, nombre_titular, monto) VALUES (?, ?, ?, ?, ?)";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, idReserva);
        ps.setString(2, metodo);
        ps.setString(3, numeroTarjeta);
        ps.setString(4, nombreTitular);
        ps.setDouble(5, monto);
        ps.executeUpdate();
        return true;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
// ==========================
// OBTENER ÚLTIMO PAGO DE RESERVA HOTEL
// ==========================
public Map<String, Object> obtenerUltimoPago(int idReservaHotel) {
    String sql = "SELECT * FROM pago_hotel WHERE id_reserva_hotel = ? ORDER BY fecha_pago DESC LIMIT 1";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, idReservaHotel);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            Map<String, Object> pago = new HashMap<>();
            pago.put("id_pago", rs.getInt("id_pago"));
            pago.put("id_reserva_hotel", rs.getInt("id_reserva_hotel"));
            pago.put("metodo", rs.getString("metodo"));
            pago.put("numero_tarjeta", rs.getString("numero_tarjeta"));
            pago.put("nombre_titular", rs.getString("nombre_titular"));
            pago.put("monto", rs.getDouble("monto"));
            pago.put("fecha_pago", rs.getTimestamp("fecha_pago"));
            return pago;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null; // Si no hay pagos
}
 // ==========================
// CANCELAR RESERVA HOTEL
// ==========================
public boolean cancelarReservaHotel(int idReservaHotel) {
    String sql = "UPDATE reserva_hotel SET estado = 'Cancelada' WHERE id_reserva_hotel = ?";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, idReservaHotel);
        int filas = ps.executeUpdate();
        return filas > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

}
