package com.movilvanperu.model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public class Paquete {
    private int id;
    private String nombre;
    private String descripcion;
    private double precio;
    private String destino;
    private String fechaSalida;
    private String fechaRetorno;
    private String imagen1;
    private String imagen2;
    private String imagen3;
    private int valoracion;

    public Paquete() {}

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public double getPrecio() { return precio; }
    public void setPrecio(double precio) { this.precio = precio; }

    public String getDestino() { return destino; }
    public void setDestino(String destino) { this.destino = destino; }

    public String getFechaSalida() { return fechaSalida; }
    public void setFechaSalida(String fechaSalida) { this.fechaSalida = fechaSalida; }

    public String getFechaRetorno() { return fechaRetorno; }
    public void setFechaRetorno(String fechaRetorno) { this.fechaRetorno = fechaRetorno; }

    public String getImagen1() { return imagen1; }
    public void setImagen1(String imagen1) { this.imagen1 = imagen1; }

    public String getImagen2() { return imagen2; }
    public void setImagen2(String imagen2) { this.imagen2 = imagen2; }

    public String getImagen3() { return imagen3; }
    public void setImagen3(String imagen3) { this.imagen3 = imagen3; }

    public int getValoracion() { return valoracion; }
    public void setValoracion(int valoracion) { this.valoracion = valoracion; }

    /**
     * ✅ Calcula la duración del paquete en días
     * teniendo en cuenta diferentes formatos de fecha.
     */
    public long getDuracionDias() {
        if (fechaSalida == null || fechaRetorno == null) {
            return 0;
        }

        try {
            // Elimina posibles horas en las fechas (ej: "2025-10-10 00:00:00")
            String salidaLimpia = fechaSalida.split(" ")[0];
            String retornoLimpio = fechaRetorno.split(" ")[0];

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate salida = LocalDate.parse(salidaLimpia, formatter);
            LocalDate retorno = LocalDate.parse(retornoLimpio, formatter);

            long dias = ChronoUnit.DAYS.between(salida, retorno);
            return dias > 0 ? dias : 1; // Mínimo 1 día para evitar mostrar "0 días"

        } catch (Exception e) {
            System.err.println("⚠️ Error al calcular duración: " + e.getMessage());
            return 0;
        }
    }
}
