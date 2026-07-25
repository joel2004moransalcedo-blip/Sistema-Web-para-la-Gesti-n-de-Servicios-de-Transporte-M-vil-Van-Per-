package com.movilvanperu.model;

/**
 * Clase modelo que representa un usuario del sistema.
 */
public class Usuario {
    
    private int id;
    private String nombre;
    private String apellido;
    private String usuario;
    private String correo;
    private String contrasena;
    private String rol;
    private String avatar; // NUEVO: ruta de la imagen del usuario

    /** Constructor vacío (requerido por JavaBeans) */
    public Usuario() {}

    /** Constructor opcional (útil para pruebas o inserciones rápidas) */
    public Usuario(String nombre, String apellido, String usuario, String correo, String contrasena, String rol, String avatar) {
        this.nombre = nombre;
        this.apellido = apellido;
        this.usuario = usuario;
        this.correo = correo;
        this.contrasena = contrasena;
        this.rol = rol;
        this.avatar = avatar;
    }

    // Getters y Setters
    public int getId() { 
        return id; 
    }
    public void setId(int id) { 
        this.id = id; 
    }

    public String getNombre() { 
        return nombre; 
    }
    public void setNombre(String nombre) { 
        this.nombre = nombre; 
    }

    public String getApellido() { 
        return apellido; 
    }
    public void setApellido(String apellido) { 
        this.apellido = apellido; 
    }

    public String getUsuario() { 
        return usuario; 
    }
    public void setUsuario(String usuario) { 
        this.usuario = usuario; 
    }

    public String getCorreo() { 
        return correo; 
    }
    public void setCorreo(String correo) { 
        this.correo = correo; 
    }

    public String getContrasena() { 
        return contrasena; 
    }
    public void setContrasena(String contrasena) { 
        this.contrasena = contrasena; 
    }

    public String getRol() { 
        return rol; 
    }
    public void setRol(String rol) { 
        this.rol = rol; 
    }

    public String getAvatar() { 
        return avatar; 
    }
    public void setAvatar(String avatar) { 
        this.avatar = avatar; 
    }

    @Override
    public String toString() {
        return "Usuario{" +
                "id=" + id +
                ", nombre='" + nombre + '\'' +
                ", apellido='" + apellido + '\'' +
                ", usuario='" + usuario + '\'' +
                ", correo='" + correo + '\'' +
                ", rol='" + rol + '\'' +
                ", avatar='" + avatar + '\'' +
                '}';
    }
}
