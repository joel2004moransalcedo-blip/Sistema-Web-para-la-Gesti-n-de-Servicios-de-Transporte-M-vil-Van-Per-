package com.movilvanperu.model;

public class Hotel {

    private int id_hotel;
    private String nombre;
    private String descripcion;
    private String direccion;
    private String ciudad;
    private String pais;
    private int estrellas;
    private String telefono;
    private String email;
    private double precioNoche;   
    private String imagen1;
    private String imagen2;
    private String imagen3;

    public Hotel() {
    }

    public Hotel(int id_hotel, String nombre, String descripcion, String direccion, String ciudad,
                 String pais, int estrellas, String telefono, String email,
                 double precioNoche,   // 🔥 Nuevo parámetro
                 String imagen1, String imagen2, String imagen3) {

        this.id_hotel = id_hotel;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.direccion = direccion;
        this.ciudad = ciudad;
        this.pais = pais;
        this.estrellas = estrellas;
        this.telefono = telefono;
        this.email = email;
        this.precioNoche = precioNoche; 
        this.imagen1 = imagen1;
        this.imagen2 = imagen2;
        this.imagen3 = imagen3;
    }

    public int getId_hotel() {
        return id_hotel;
    }

    public void setId_hotel(int id_hotel) {
        this.id_hotel = id_hotel;
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

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getCiudad() {
        return ciudad;
    }

    public void setCiudad(String ciudad) {
        this.ciudad = ciudad;
    }

    public String getPais() {
        return pais;
    }

    public void setPais(String pais) {
        this.pais = pais;
    }

    public int getEstrellas() {
        return estrellas;
    }

    public void setEstrellas(int estrellas) {
        this.estrellas = estrellas;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public double getPrecioNoche() {    
        return precioNoche;
    }

    public void setPrecioNoche(double precioNoche) {   
        this.precioNoche = precioNoche;
    }

    public String getImagen1() {
        return imagen1;
    }

    public void setImagen1(String imagen1) {
        this.imagen1 = imagen1;
    }

    public String getImagen2() {
        return imagen2;
    }

    public void setImagen2(String imagen2) {
        this.imagen2 = imagen2;
    }

    public String getImagen3() {
        return imagen3;
    }

    public void setImagen3(String imagen3) {
        this.imagen3 = imagen3;
    }
}
