package com.movilvanperu.facade;

import com.movilvanperu.dao.*;
import com.movilvanperu.model.*;

import java.util.*;

/**
 * 🎯 Facade que centraliza el acceso a Usuarios, Paquetes, Reservas, Pagos y Promociones.
 * Actúa como intermediario entre los servlets/controladores y los DAOs.
 */
public class SistemaViajesFacade {

    /* ==============================
       🔗 DAOs
    ============================== */
    private final UsuarioDAO usuarioDAO;
    private final PaqueteDAO paqueteDAO;
    private final ReservaDAO reservaDAO;
    private final PagoDAO pagoDAO;
    private final PromocionDAO promocionDAO;
    private final ReservaHotelDAO reservaHotelDAO;

    /* ==============================
       🏗️ CONSTRUCTOR
    ============================== */
    public SistemaViajesFacade() {
        this.usuarioDAO = new UsuarioDAO();
        this.paqueteDAO = new PaqueteDAO();
        this.reservaDAO = new ReservaDAO();
        this.pagoDAO = new PagoDAO();
        this.promocionDAO = new PromocionDAO();
        this.reservaHotelDAO = new ReservaHotelDAO();
    }

    /* ==============================
       🧍 USUARIOS
    ============================== */
    public Usuario loginUsuario(String usuario, String contrasena) {
        return usuarioDAO.login(usuario, contrasena);
    }

    public boolean registrarUsuario(Usuario u) {
        return usuarioDAO.registrar(u);
    }

    public boolean actualizarAvatar(int id, String avatarPath) {
        return usuarioDAO.actualizarAvatar(id, avatarPath);
    }

    public boolean actualizarContrasena(int id, String nueva) {
        return usuarioDAO.actualizarContrasena(id, nueva);
    }

    public List<Usuario> listarUsuarios() {
        return usuarioDAO.listarUsuarios();
    }

    public Usuario obtenerUsuarioPorId(int id) {
        return usuarioDAO.obtenerPorId(id);
    }

    /* ==============================
       🧳 PAQUETES
    ============================== */
    public List<Paquete> listarPaquetes() {
        return paqueteDAO.listar();
    }

    public boolean agregarPaquete(Paquete p) {
        return paqueteDAO.agregar(p);
    }

    public boolean actualizarPaquete(Paquete p) {
        return paqueteDAO.actualizar(p);
    }

    public boolean eliminarPaquete(int id) {
        return paqueteDAO.eliminar(id);
    }

    public Paquete obtenerPaquetePorId(int id) {
        return paqueteDAO.obtenerPorId(id);
    }

    public List<Paquete> listarUltimosPaquetes(int n) {
        List<Paquete> todos = paqueteDAO.listar();
        if (todos == null || todos.isEmpty()) return Collections.emptyList();
        int size = todos.size();
        int from = Math.max(0, size - n);
        return todos.subList(from, size);
    }

    public List<Paquete> listarUltimos3() {
        return listarUltimosPaquetes(3);
    }

    public List<Map<String, Object>> listarPaquetesConFechas() {
        return paqueteDAO.listarPaquetesConFechas();
    }

    /* ==============================
       📅 RESERVAS
    ============================== */
    public boolean registrarReserva(int idUsuario, int idPaquete, String metodoPago, double total) {
        return reservaDAO.registrarReserva(idUsuario, idPaquete, metodoPago, total);
    }

    public List<Map<String, Object>> listarReservasPorUsuario(int idUsuario) {
        return reservaDAO.listarReservasPorUsuario(idUsuario);
    }

    public Map<String, Object> obtenerReservaPorId(int idReserva) {
        return reservaDAO.obtenerReservaPorId(idReserva);
    }

    public boolean actualizarEstadoReserva(int idReserva, String nuevoEstado) {
        return reservaDAO.actualizarEstadoReserva(idReserva, nuevoEstado);
    }

public boolean cancelarReserva(int idReserva, String tipo) {

    if ("hotel".equalsIgnoreCase(tipo)) {
        return reservaHotelDAO.cancelarReservaHotel(idReserva);
    } else {
        return reservaDAO.cancelarReserva(idReserva);
    }
}


    public List<Map<String, Object>> listarTodasLasReservas() {
        return reservaDAO.listarTodasLasReservas();
    }

    public boolean eliminarReserva(int idReserva) {
        return reservaDAO.eliminar(idReserva);
    }

public List<Map<String, Object>> listarTodasReservasPorUsuario(int idUsuario) {
    List<Map<String, Object>> todas = new ArrayList<>();

    // 1️⃣ Reservas de paquetes
    List<Map<String, Object>> reservasPaquete = reservaDAO.listarReservasPorUsuario(idUsuario);
    if (reservasPaquete != null) {
        for (Map<String, Object> r : reservasPaquete) {
            r.put("tipo", "paquete");
            todas.add(r);
        }
    }

    // 2️⃣ Reservas de hoteles
    ReservaHotelDAO reservaHotelDAO = new ReservaHotelDAO();
    List<ReservaHotel> reservasHotel = reservaHotelDAO.listarPorUsuario(idUsuario);
    HotelDAO hotelDAO = new HotelDAO();

    if (reservasHotel != null) {
        for (ReservaHotel r : reservasHotel) {
            Map<String, Object> map = new HashMap<>();
            Hotel hotel = hotelDAO.obtenerPorId(r.getId_hotel());

            map.put("id_reserva", r.getId_reserva_hotel());
            map.put("tipo", "hotel");
            map.put("hotel_nombre", hotel != null ? hotel.getNombre() : "Hotel desconocido");
            map.put("hotel_imagen", (hotel != null && hotel.getImagen1() != null && !hotel.getImagen1().isEmpty())
                    ? "views/images/" + hotel.getImagen1()
                    : "views/images/default.png");

            map.put("fecha_inicio", r.getFecha_inicio() != null ? r.getFecha_inicio().toString() : "-");
            map.put("fecha_fin", r.getFecha_fin() != null ? r.getFecha_fin().toString() : "-");

            // Convertir a string con dos decimales
            map.put("precio_noche", String.format("%.2f", r.getPrecio_noche()));
            map.put("total", String.format("%.2f", r.getTotal()));

            map.put("estado", r.getEstado() != null ? r.getEstado() : "pendiente");
            map.put("fecha_reserva", r.getFecha_reserva() != null ? r.getFecha_reserva().toString() : "-");

            todas.add(map);
        }
    }

    return todas;
}


    /* ==============================
       💳 PAGOS
    ============================== */
    public boolean registrarPago(int idReserva, String metodo, String numeroTarjeta, String nombreTitular, double monto) {
        return pagoDAO.registrarPago(idReserva, metodo, numeroTarjeta, nombreTitular, monto);
    }

    public List<Map<String, Object>> listarPagosPorReserva(int idReserva) {
        return pagoDAO.listarPagosPorReserva(idReserva);
    }

    public Map<String, Object> obtenerPagoPorId(int idPago) {
        return pagoDAO.obtenerPagoPorId(idPago);
    }

    public boolean actualizarEstadoPago(int idPago, String nuevoEstado) {
        return pagoDAO.actualizarEstadoPago(idPago, nuevoEstado);
    }

    public boolean eliminarPago(int idPago) {
        return pagoDAO.eliminar(idPago);
    }

    public Map<String, Object> obtenerPagoPorReserva(int idReserva) {
        List<Map<String, Object>> pagos = pagoDAO.listarPagosPorReserva(idReserva);
        return (pagos != null && !pagos.isEmpty()) ? pagos.get(0) : null;
    }

    /* ==============================
       🎁 PROMOCIONES (NUEVO)
    ============================== */

    public boolean crearPromocion(Promocion p) {
        return promocionDAO.crearPromocion(p);
    }

    public List<Promocion> listarPromocionesActivas() {
        return promocionDAO.listarPromocionesActivas();
    }

    public Promocion obtenerPromocionPorId(int id) {
        return promocionDAO.obtenerPorId(id);
    }


// Cuenta todas las reservas pagadas del usuario
public int contarReservasPagadas(int idUsuario) {
    return promocionDAO.contarReservasPagadas(idUsuario);
}

// Verifica si el usuario ya reclamó esta promoción
public boolean usuarioYaReclamoPromocion(int idUsuario, int idPromocion) {
    return promocionDAO.usuarioYaReclamoPromocion(idUsuario, idPromocion);
}

// Registrar que el usuario ya reclamó la promoción
public void registrarClaimPromocion(int idUsuario, int idPromocion) {
    promocionDAO.registrarClaimPromocion(idUsuario, idPromocion);
}

        // =========================
    //   ELIMINAR PROMOCIÓN
    // =========================
    public boolean eliminarPromocion(int idPromocion) {
        return promocionDAO.eliminarPromocion(idPromocion);
    }

    // =========================
    //   ACTUALIZAR PROMOCIÓN
    // =========================
    public boolean actualizarPromocion(Promocion promocion) {
        return promocionDAO.actualizarPromocion(promocion);
    }
public int contarReservasPagadasPorPromocion(int idUsuario, int idPromocion) {
    return reservaDAO.contarReservasPagadasPorPromocion(idUsuario, idPromocion);
}


public void crearReservaGratuita(int idUsuario, int idPromo) {
    reservaDAO.crearReservaGratuita(idUsuario, idPromo);
}
public boolean registrarPagoHotel(int idReservaHotel, String metodo, String numeroTarjeta, String nombreTitular, double monto) {
    return reservaHotelDAO.registrarPago(idReservaHotel, metodo, numeroTarjeta, nombreTitular, monto);
}

public boolean actualizarEstadoReservaHotel(int idReserva, String estado) {
    return reservaHotelDAO.actualizarEstado(idReserva, estado);
}

public ReservaHotel obtenerReservaHotelPorId(int idReserva) {
    return reservaHotelDAO.obtenerPorId(idReserva);
}
public Hotel obtenerHotelPorId(int idHotel) {
    return new HotelDAO().obtenerPorId(idHotel);
}
public boolean pagarReservaHotel(int idReserva, String metodo, String numeroTarjeta, String nombreTitular, double monto) {
    boolean ok = registrarPagoHotel(idReserva, metodo, numeroTarjeta, nombreTitular, monto);
    if (ok) {
        return actualizarEstadoReservaHotel(idReserva, "pagado");
    }
    return false;
}
public Map<String, Object> obtenerUltimoPagoHotel(int idReservaHotel) {
    return reservaHotelDAO.obtenerUltimoPago(idReservaHotel);
}


}
