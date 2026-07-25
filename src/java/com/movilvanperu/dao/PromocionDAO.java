package com.movilvanperu.dao;

import com.movilvanperu.model.Promocion;
import com.movilvanperu.utils.Conexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PromocionDAO {

    // ============================
    // CREAR PROMOCIÓN
    // ============================
    public boolean crearPromocion(Promocion p) {
        String sql = "INSERT INTO promociones (nombre, descripcion, id_paquete_gratis, cantidad_requerida, banner, estado) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getNombre());
            ps.setString(2, p.getDescripcion());
            ps.setInt(3, p.getIdPaqueteGratis());
            ps.setInt(4, p.getCantidadRequerida());
            ps.setString(5, p.getBanner());
            ps.setString(6, p.getEstado() != null ? p.getEstado() : "activa");

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ============================
    // LISTAR TODAS
    // ============================
    public List<Promocion> listarPromociones() {
        List<Promocion> lista = new ArrayList<>();
        String sql = """
            SELECT p.*, pa.nombre AS paqueteGratisNombre
            FROM promociones p
            LEFT JOIN paquetes pa ON p.id_paquete_gratis = pa.id
            ORDER BY creada_en DESC
        """;

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Promocion p = mapResultSet(rs);
                p.setPaqueteGratisNombre(rs.getString("paqueteGratisNombre"));
                lista.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ============================
    // LISTAR SOLO ACTIVAS
    // ============================
    public List<Promocion> listarPromocionesActivas() {
        List<Promocion> lista = new ArrayList<>();
        String sql = """
            SELECT p.*, pa.nombre AS paqueteGratisNombre
            FROM promociones p
            LEFT JOIN paquetes pa ON p.id_paquete_gratis = pa.id
            WHERE estado = 'activa'
            ORDER BY creada_en DESC
        """;

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Promocion p = mapResultSet(rs);
                p.setPaqueteGratisNombre(rs.getString("paqueteGratisNombre"));
                lista.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ============================
    // OBTENER POR ID
    // ============================
    public Promocion obtenerPorId(int id) {
        String sql = """
            SELECT p.*, pa.nombre AS paqueteGratisNombre
            FROM promociones p
            LEFT JOIN paquetes pa ON p.id_paquete_gratis = pa.id
            WHERE p.id = ?
        """;

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Promocion p = mapResultSet(rs);
                p.setPaqueteGratisNombre(rs.getString("paqueteGratisNombre"));
                return p;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ============================
    // ACTUALIZAR PROMOCIÓN
    // ============================
    public boolean actualizarPromocion(Promocion p) {
        String sql = """
            UPDATE promociones
            SET nombre = ?, descripcion = ?, id_paquete_gratis = ?, 
                cantidad_requerida = ?, banner = ?, estado = ?
            WHERE id = ?
        """;

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getNombre());
            ps.setString(2, p.getDescripcion());
            ps.setInt(3, p.getIdPaqueteGratis());
            ps.setInt(4, p.getCantidadRequerida());
            ps.setString(5, p.getBanner());
            ps.setString(6, p.getEstado());
            ps.setInt(7, p.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ============================
    // ELIMINAR PROMOCIÓN
    // ============================
    public boolean eliminarPromocion(int id) {
        String sql = "DELETE FROM promociones WHERE id = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ============================
    // REGISTRAR CLAIM
    // ============================
    public boolean registrarClaim(int idUsuario, int idPromocion) {
        String sql = "INSERT INTO promociones_claims (id_usuario, id_promocion) VALUES (?, ?)";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setInt(2, idPromocion);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ============================
    // VER SI YA RECLAMÓ
    // ============================
    public boolean usuarioYaReclamo(int idUsuario, int idPromocion) {
        String sql = "SELECT id FROM promociones_claims WHERE id_usuario = ? AND id_promocion = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setInt(2, idPromocion);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ============================
    // MAPEAR RESULTSET
    // ============================
    private Promocion mapResultSet(ResultSet rs) throws SQLException {
        Promocion p = new Promocion();

        p.setId(rs.getInt("id"));
        p.setNombre(rs.getString("nombre"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setIdPaqueteGratis(rs.getInt("id_paquete_gratis"));
        p.setCantidadRequerida(rs.getInt("cantidad_requerida"));
        p.setBanner(rs.getString("banner"));
        p.setEstado(rs.getString("estado"));
        p.setCreadaEn(rs.getTimestamp("creada_en"));

        return p;
    }
public int contarReservasPagadas(int idUsuario) {
    int cantidad = 0;
    String sql = "SELECT COUNT(*) FROM reservas WHERE id_usuario = ? AND estado = 'PAGADO'";

    try (Connection conn = Conexion.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, idUsuario);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            cantidad = rs.getInt(1);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return cantidad;
}

public boolean usuarioYaReclamoPromocion(int idUsuario, int idPromocion) {
    String sql = "SELECT COUNT(*) FROM promociones_claims WHERE id_usuario = ? AND id_promocion = ?";
    boolean reclamo = false;

    try (Connection conn = Conexion.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, idUsuario);
        stmt.setInt(2, idPromocion);

        ResultSet rs = stmt.executeQuery();
        
        if (rs.next() && rs.getInt(1) > 0) {
            reclamo = true;
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return reclamo;
}

public void registrarClaimPromocion(int idUsuario, int idPromocion) {
    String sql = "INSERT INTO promociones_claims (id_usuario, id_promocion) VALUES (?, ?)";

    try (Connection conn = Conexion.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, idUsuario);
        stmt.setInt(2, idPromocion);
        stmt.executeUpdate();

    } catch (SQLException e) {
        e.printStackTrace();
    }
}


}
