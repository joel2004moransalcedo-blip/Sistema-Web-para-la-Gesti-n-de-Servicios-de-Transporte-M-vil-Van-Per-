package com.movilvanperu.controller;

import java.io.File;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import com.movilvanperu.model.Usuario;
import com.movilvanperu.dao.UsuarioDAO;

@WebServlet("/UsuarioServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1 MB
    maxFileSize = 1024 * 1024 * 10,       // 10 MB
    maxRequestSize = 1024 * 1024 * 50     // 50 MB
)
public class UsuarioServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("register".equals(action)) {
            registrarUsuario(request, response);
        } else if ("login".equals(action)) {
            iniciarSesion(request, response);
        } else if ("updateAvatar".equals(action)) {
            actualizarAvatar(request, response);
        } else if ("cambiarContrasena".equals(action)) {
            cambiarContrasena(request, response);
        } else if ("registrarAdmin".equals(action)) {
            registrarAdministrador(request, response);
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("logout".equals(action)) {
            cerrarSesion(request, response);
        } else if ("eliminar".equals(action)) {
            eliminarUsuario(request, response);
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    /** Registrar nuevo usuario cliente */
    private void registrarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario u = new Usuario();
        u.setNombre(request.getParameter("nombre"));
        u.setApellido(request.getParameter("apellido"));
        u.setUsuario(request.getParameter("usuario"));
        u.setCorreo(request.getParameter("correo"));
        u.setContrasena(request.getParameter("contrasena"));
        u.setRol("usuario");
        u.setAvatar(null);

        boolean registrado = usuarioDAO.registrar(u);

        if (registrado) {
            response.sendRedirect("views/login.jsp");
        } else {
            request.setAttribute("error", "Error al registrar usuario. Verifique los datos.");
            request.getRequestDispatcher("views/registro.jsp").forward(request, response);
        }
    }

    /** Registrar administrador desde el panel */
/** Registrar administrador desde el panel */
private void registrarAdministrador(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    Usuario u = new Usuario();
    u.setNombre(request.getParameter("nombre"));
    u.setApellido(""); // opcional, si no hay campo en el formulario
    u.setUsuario(request.getParameter("usuario"));
    u.setCorreo(request.getParameter("correo"));
    u.setContrasena(request.getParameter("password"));
    u.setRol("admin");
    u.setAvatar("views/images/default-user.png");

    boolean registrado = usuarioDAO.registrar(u);

    if (registrado) {
        response.sendRedirect(request.getContextPath() + "/views/usuarios_admin.jsp?msg=ok");
    } else {
        request.setAttribute("error", "No se pudo registrar el administrador. Verifique los datos.");
        request.getRequestDispatcher("/views/usuarios_admin.jsp").forward(request, response);
    }
}


    /** Eliminar usuario (solo admin) */
    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        Usuario admin = (Usuario) session.getAttribute("usuario");

        if (admin == null || !"admin".equalsIgnoreCase(admin.getRol())) {
            response.sendRedirect("index.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        boolean eliminado = usuarioDAO.eliminar(id);

        if (eliminado) {
            response.sendRedirect("views/usuarios_admin.jsp");
        } else {
            response.getWriter().write("Error al eliminar usuario.");
        }
    }

    /** Iniciar sesión */
    private void iniciarSesion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("usuario");
        String pass = request.getParameter("contrasena");

        Usuario u = usuarioDAO.login(user, pass);

        if (u != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuario", u);

            if ("admin".equalsIgnoreCase(u.getRol())) {
                response.sendRedirect("views/dashboard.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            request.setAttribute("error", "Usuario o contraseña incorrectos");
            request.getRequestDispatcher("views/login.jsp").forward(request, response);
        }
    }

    /** Cerrar sesión */
    private void cerrarSesion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("index.jsp");
    }

    /** Actualizar avatar */
    private void actualizarAvatar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect("views/login.jsp");
            return;
        }

        Part filePart = request.getPart("avatar");
        if (filePart != null && filePart.getSize() > 0) {

            String contentType = filePart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                request.setAttribute("error", "El archivo debe ser una imagen válida (jpg, png, etc).");
                request.getRequestDispatcher("views/perfil.jsp").forward(request, response);
                return;
            }

            String originalName = filePart.getSubmittedFileName().replaceAll("[^a-zA-Z0-9\\.\\-_]", "_");
            String fileName = "user_" + usuario.getId() + "_" + System.currentTimeMillis() + "_" + originalName;

            String uploadPath = getServletContext().getRealPath("/views/images/usuarios");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);

            String avatarPath = "views/images/usuarios/" + fileName;
            boolean actualizado = usuarioDAO.actualizarAvatar(usuario.getId(), avatarPath);

            if (actualizado) {
                usuario.setAvatar(avatarPath);
                session.setAttribute("usuario", usuario);
                request.setAttribute("mensaje", "Avatar actualizado correctamente.");
            } else {
                request.setAttribute("error", "No se pudo actualizar el avatar.");
            }
        }

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");

        request.getRequestDispatcher("views/perfil.jsp").forward(request, response);
    }

    /** Cambiar contraseña */
    private void cambiarContrasena(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect("views/login.jsp");
            return;
        }

        String actual = request.getParameter("actual");
        String nueva = request.getParameter("nueva");
        String confirmar = request.getParameter("confirmar");

        if (actual == null || nueva == null || confirmar == null ||
            actual.isEmpty() || nueva.isEmpty() || confirmar.isEmpty()) {
            request.setAttribute("error", "Debe completar todos los campos.");
            request.getRequestDispatcher("views/cambiarcontrasena.jsp").forward(request, response);
            return;
        }

        if (!nueva.equals(confirmar)) {
            request.setAttribute("error", "Las contraseñas nuevas no coinciden.");
            request.getRequestDispatcher("views/cambiarcontrasena.jsp").forward(request, response);
            return;
        }

        Usuario verificado = usuarioDAO.login(usuario.getUsuario(), actual);
        if (verificado == null) {
            request.setAttribute("error", "La contraseña actual es incorrecta.");
            request.getRequestDispatcher("views/cambiarcontrasena.jsp").forward(request, response);
            return;
        }

        boolean actualizado = usuarioDAO.actualizarContrasena(usuario.getId(), nueva);

        if (actualizado) {
            request.setAttribute("mensaje", "Contraseña actualizada correctamente.");
        } else {
            request.setAttribute("error", "Ocurrió un error al actualizar la contraseña.");
        }

        request.getRequestDispatcher("views/cambiarcontrasena.jsp").forward(request, response);
    }
}
