package com.movilvanperu.controller;

import com.movilvanperu.facade.SistemaViajesFacade;
import com.movilvanperu.model.Promocion;
import com.movilvanperu.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/claimPromocion")
public class PromocionClaimServlet extends HttpServlet {

    private final SistemaViajesFacade facade = new SistemaViajesFacade();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // verificar sesión y obtener usuario
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("usuario") == null) {
                resp.sendRedirect("views/login.jsp?error=DebeIniciarSesion");
                return;
            }
            Usuario user = (Usuario) session.getAttribute("usuario");
            int idUsuario = user.getId();

            int idPromocion = Integer.parseInt(req.getParameter("idPromocion"));

            // obtener la promoción
            Promocion promo = facade.obtenerPromocionPorId(idPromocion);
            if (promo == null) {
                resp.sendRedirect("views/promocion.jsp?error=NoExiste");
                return;
            }

            // 1) Verificar si ya reclamó
            if (facade.usuarioYaReclamoPromocion(idUsuario, idPromocion)) {
                resp.sendRedirect("views/promocion.jsp?error=YaReclamada");
                return;
            }

            // 2) Verificar cantidad de reservas pagadas
            int reservasPagadas = facade.contarReservasPagadas(idUsuario);
            if (reservasPagadas < promo.getCantidadRequerida()) {
                // calcular cuántas faltan para mostrar luego en la UI
                resp.sendRedirect("views/promocion.jsp?error=NoCumple&faltan=" + (promo.getCantidadRequerida() - reservasPagadas));
                return;
            }

            // 3) Registrar claim en tabla promociones_claims
// Registrar claim directamente (no devuelve boolean)
facade.registrarClaimPromocion(idUsuario, idPromocion);


            // 4) Crear reserva GRATIS usando la firma correcta (4 parámetros)
            boolean reservaCreada = facade.registrarReserva(
                    idUsuario,
                    promo.getIdPaqueteGratis(),
                    "PROMOCION",
                    0.0
            );

            if (!reservaCreada) {
                resp.sendRedirect("views/promocion.jsp?error=NoCreoReserva");
                return;
            }

            // 5) Localizar la reserva recién creada (la más reciente para ese usuario y paquete)
            //    Usamos listarReservasPorUsuario() y buscamos por id_paquete igual al paquete gratis.
            //    Esto es un heurístico: si tu DAO devuelve la reserva creada (o el id), reemplázalo por esa forma.
            List<Map<String, Object>> reservas = facade.listarReservasPorUsuario(idUsuario);
            Integer idReservaReciente = null;
            java.sql.Timestamp ultimaFecha = null;

            if (reservas != null) {
                for (Map<String, Object> r : reservas) {
                    Object idPaqueteObj = r.get("id_paquete");
                    Object fechaObj = r.get("fecha_reserva"); // depende de cómo el DAO nombre la columna
                    if (idPaqueteObj != null && Integer.parseInt(idPaqueteObj.toString()) == promo.getIdPaqueteGratis()) {
                        // comparar fecha para obtener la más nueva
                        java.sql.Timestamp ts = null;
                        if (fechaObj instanceof java.sql.Timestamp) {
                            ts = (java.sql.Timestamp) fechaObj;
                        } else if (fechaObj != null) {
                            try {
                                ts = java.sql.Timestamp.valueOf(fechaObj.toString());
                            } catch (Exception ex) {
                                // ignore parse problem
                            }
                        }
                        // tomar la que sea más reciente (o la primera si no hay timestamps)
                        if (idReservaReciente == null) {
                            idReservaReciente = (r.get("id") instanceof Number) ? ((Number) r.get("id")).intValue() : Integer.parseInt(r.get("id").toString());
                            ultimaFecha = ts;
                        } else {
                            if (ts != null && (ultimaFecha == null || ts.after(ultimaFecha))) {
                                idReservaReciente = (r.get("id") instanceof Number) ? ((Number) r.get("id")).intValue() : Integer.parseInt(r.get("id").toString());
                                ultimaFecha = ts;
                            }
                        }
                    }
                }
            }

            // 6) Si encontramos la reserva, marcarla como 'pagada' y crear registro de pago (monto 0)
            if (idReservaReciente != null) {
                // actualizar estado de la reserva
                facade.actualizarEstadoReserva(idReservaReciente, "pagada");

                // registrar pago con monto 0 para trazabilidad
                facade.registrarPago(idReservaReciente, "PROMOCION", null, "PROMOCION", 0.0);
            } else {
                // si no pudimos encontrar la reserva, igual success (pero avisamos)
                // puedes decidir revertir el claim si prefieres, aquí solo lo notificamos.
                resp.sendRedirect("views/promocion.jsp?warning=ClaimOKPeroNoReserva");
                return;
            }

// 7) Todo OK
resp.sendRedirect("views/mis_reservas.jsp?success=1");

} catch (NumberFormatException nfe) {
    nfe.printStackTrace();
    resp.sendRedirect("views/promocion.jsp?error=Formato");
} catch (Exception e) {
    e.printStackTrace();
    resp.sendRedirect("views/promocion.jsp?error=Exception");
}

    }
}
