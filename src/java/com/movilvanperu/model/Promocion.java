package com.movilvanperu.model;

import java.sql.Timestamp;

public class Promocion {

    private int id;
    private String nombre;
    private String descripcion;

    private int idPaqueteGratis;
    private int cantidadRequerida;

    private String paqueteGratisNombre; // <-- agregado para el JSP

    private String banner; 
    private String estado; 
    private Timestamp creadaEn;
    

    public Promocion() {}

    // ------------------------
    // Getters / Setters base
    // ------------------------
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

    public String getDescripcion() { 
        return descripcion; 
    }
    public void setDescripcion(String descripcion) { 
        this.descripcion = descripcion; 
    }

    public int getIdPaqueteGratis() { 
        return idPaqueteGratis; 
    }
    public void setIdPaqueteGratis(int idPaqueteGratis) { 
        this.idPaqueteGratis = idPaqueteGratis; 
    }

    public int getCantidadRequerida() { 
        return cantidadRequerida; 
    }
    public void setCantidadRequerida(int cantidadRequerida) { 
        this.cantidadRequerida = cantidadRequerida; 
    }

    public String getBanner() { 
        return banner; 
    }
    public void setBanner(String banner) { 
        this.banner = banner; 
    }

    public String getEstado() { 
        return estado; 
    }
    public void setEstado(String estado) { 
        this.estado = estado; 
    }

    public Timestamp getCreadaEn() { 
        return creadaEn; 
    }
    public void setCreadaEn(Timestamp creadaEn) { 
        this.creadaEn = creadaEn; 
    }

    // ------------------------
    // Getters especiales para el JSP
    // ------------------------

    // Nombre del paquete gratis
    public String getPaqueteGratisNombre() { 
        return paqueteGratisNombre; 
    }
    public void setPaqueteGratisNombre(String paqueteGratisNombre) { 
        this.paqueteGratisNombre = paqueteGratisNombre; 
    }

    // Lo que tu JSP usa: getCantidadReservasRequerida()
    public int getCantidadReservasRequerida() {
        return cantidadRequerida;
    }
}
