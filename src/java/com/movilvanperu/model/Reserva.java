package com.movilvanperu.model;

public class Reserva {
    private int id;
    private int idUsuario;
    private int idPaquete;
    private String fecha;
    private int cantidadPersonas;
    private double total;
    private String estado;

    public Reserva() {
    }

    public Reserva(int id, int idUsuario, int idPaquete, String fecha, int cantidadPersonas, double total, String estado) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.idPaquete = idPaquete;
        this.fecha = fecha;
        this.cantidadPersonas = cantidadPersonas;
        this.total = total;
        this.estado = estado;
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdPaquete() {
        return idPaquete;
    }

    public void setIdPaquete(int idPaquete) {
        this.idPaquete = idPaquete;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public int getCantidadPersonas() {
        return cantidadPersonas;
    }

    public void setCantidadPersonas(int cantidadPersonas) {
        this.cantidadPersonas = cantidadPersonas;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}
