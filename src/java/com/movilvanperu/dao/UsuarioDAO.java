package com.movilvanperu.dao;
import com.movilvanperu.model.Usuario; 
import com.movilvanperu.utils.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operaciones CRUD de Usuario
 */
public class UsuarioDAO {

    /** Registrar un nuevo usuario */
    public boolean registrar(Usuario u) {
        if (existeUsuario(u.getUsuario()) || existeCorreo(u.getCorreo())) {
            return false;
        }

        String sql = "INSERT INTO usuarios (nombre, apellido, usuario, correo, contrasena, rol, avatar) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, u.getNombre());
            ps.setString(2, u.getApellido());
            ps.setString(3, u.getUsuario());
            ps.setString(4, u.getCorreo());
            ps.setString(5, encriptarContrasena(u.getContrasena()));
            ps.setString(6, u.getRol());
            ps.setString(7, (u.getAvatar() != null && !u.getAvatar().isEmpty())
                    ? u.getAvatar()
                    : "views/images/default-user.png");

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Login de usuario */
    public Usuario login(String usuario, String contrasena) {
        String sql = "SELECT * FROM usuarios WHERE usuario=? AND contrasena=?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usuario);
            ps.setString(2, encriptarContrasena(contrasena));

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setNombre(rs.getString("nombre"));
                u.setApellido(rs.getString("apellido"));
                u.setUsuario(rs.getString("usuario"));
                u.setCorreo(rs.getString("correo"));
                u.setRol(rs.getString("rol"));
                u.setAvatar(rs.getString("avatar"));
                return u;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Actualizar avatar de un usuario */
    public boolean actualizarAvatar(int id, String avatarPath) {
        String sql = "UPDATE usuarios SET avatar=? WHERE id=?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, (avatarPath != null && !avatarPath.isEmpty())
                    ? avatarPath
                    : "views/images/default-user.png");
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** 🔐 Actualizar contraseña */
    public boolean actualizarContrasena(int id, String nuevaContrasena) {
        String sql = "UPDATE usuarios SET contrasena=? WHERE id=?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, encriptarContrasena(nuevaContrasena));
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Verificar si un usuario ya existe */
    private boolean existeUsuario(String usuario) {
        String sql = "SELECT id FROM usuarios WHERE usuario=?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usuario);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Verificar si un correo ya existe */
    private boolean existeCorreo(String correo) {
        String sql = "SELECT id FROM usuarios WHERE correo=?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, correo);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Encriptar contraseña con MD5 */
    private String encriptarContrasena(String contrasena) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hash = md.digest(contrasena.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return contrasena;
        }
    }

    /** ✅ Listar todos los usuarios */
    public List<Usuario> listar() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setNombre(rs.getString("nombre"));
                u.setApellido(rs.getString("apellido"));
                u.setUsuario(rs.getString("usuario"));
                u.setCorreo(rs.getString("correo"));
                u.setRol(rs.getString("rol"));
                u.setAvatar(rs.getString("avatar"));
                lista.add(u);
            }
        } catch (Exception e) {
            System.out.println("Error al listar usuarios: " + e.getMessage());
        }
        return lista;
    }

    /** 🔍 Obtener usuario por ID */
    public Usuario obtenerPorId(int id) {
        String sql = "SELECT * FROM usuarios WHERE id=?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setNombre(rs.getString("nombre"));
                u.setApellido(rs.getString("apellido"));
                u.setUsuario(rs.getString("usuario"));
                u.setCorreo(rs.getString("correo"));
                u.setRol(rs.getString("rol"));
                u.setAvatar(rs.getString("avatar"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /** ✏️ Actualizar datos del usuario */
    public boolean actualizar(Usuario u) {
        String sql = "UPDATE usuarios SET nombre=?, apellido=?, usuario=?, correo=?, rol=?, avatar=? WHERE id=?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, u.getNombre());
            ps.setString(2, u.getApellido());
            ps.setString(3, u.getUsuario());
            ps.setString(4, u.getCorreo());
            ps.setString(5, u.getRol());
            ps.setString(6, (u.getAvatar() != null && !u.getAvatar().isEmpty())
                    ? u.getAvatar()
                    : "views/images/default-user.png");
            ps.setInt(7, u.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public List<Usuario> listarUsuarios() {
    List<Usuario> lista = new ArrayList<>();
    String sql = "SELECT * FROM usuarios";
    try (Connection con = Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Usuario u = new Usuario();
            u.setId(rs.getInt("id"));
            u.setNombre(rs.getString("nombre"));
            u.setCorreo(rs.getString("correo"));
            u.setRol(rs.getString("rol"));
            lista.add(u);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return lista;
}
public boolean eliminar(int id) {
    String sql = "DELETE FROM usuarios WHERE id = ?";
    try (Connection con = Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, id);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

}
