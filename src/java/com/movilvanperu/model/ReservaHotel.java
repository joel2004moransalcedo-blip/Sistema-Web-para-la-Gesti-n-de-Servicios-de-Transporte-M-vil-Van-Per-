package com.movilvanperu.model;

import java.util.Date;

public class ReservaHotel {

    private int id_reserva_hotel;
    private int id_usuario;
    private int id_hotel;            // Hotel reservado
    private Date fecha_inicio;
    private Date fecha_fin;
    private double precio_noche;     // precio por noche
    private double total;
    private String estado;           // pendiente, pagado
    private Date fecha_reserva;

    // Constructor vacío
    public ReservaHotel() {}

    // Getters y Setters
    public int getId_reserva_hotel() {
        return id_reserva_hotel;
    }

    public void setId_reserva_hotel(int id_reserva_hotel) {
        this.id_reserva_hotel = id_reserva_hotel;
    }

    public int getId_usuario() {
        return id_usuario;
    }

    public void setId_usuario(int id_usuario) {
        this.id_usuario = id_usuario;
    }

    public int getId_hotel() {
        return id_hotel;
    }

    public void setId_hotel(int id_hotel) {
        this.id_hotel = id_hotel;
    }


    public Date getFecha_inicio() {
        return fecha_inicio;
    }

    public void setFecha_inicio(Date fecha_inicio) {
        this.fecha_inicio = fecha_inicio;
    }

    public Date getFecha_fin() {
        return fecha_fin;
    }

    public void setFecha_fin(Date fecha_fin) {
        this.fecha_fin = fecha_fin;
    }

    public double getPrecio_noche() {
        return precio_noche;
    }

    public void setPrecio_noche(double precio_noche) {
        this.precio_noche = precio_noche;
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

    public Date getFecha_reserva() {
        return fecha_reserva;
    }

    public void setFecha_reserva(Date fecha_reserva) {
        this.fecha_reserva = fecha_reserva;
    }

    // 🔹 Método opcional para calcular el total dinámicamente
    public void calcularTotal() {
        if (fecha_inicio != null && fecha_fin != null) {
            long diff = fecha_fin.getTime() - fecha_inicio.getTime();
            long dias = (diff / (1000 * 60 * 60 * 24)) + 1; // contar ambos días
            this.total = dias * precio_noche;
        }
    }
}
