<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.movilvanperu.model.Usuario" %>

<!-- 🌎 Establecer idioma -->
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>

<nav class="navbar navbar-expand-lg navbar-dark fixed-top" style="background: rgba(0,0,0,0.7); backdrop-filter: blur(6px);">
    <div class="container-fluid">

        <!-- Logo -->
        <a class="navbar-brand d-flex align-items-center" href="<%= request.getContextPath() %>/index.jsp">
            <img src="<%= request.getContextPath() %>/views/images/logos.png"
                 alt="Movil Van Perú"
                 style="height: 55px; width: auto; object-fit: contain;">
        </a>

        <!-- Toggle responsive -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Menú -->
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">

                <!-- Enlaces comunes traducidos -->
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/index.jsp">
                        <fmt:message key="nav.home"/>
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/views/viajes.jsp">
                        <fmt:message key="nav.packages"/>
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/views/promocion.jsp">
                        <fmt:message key="nav.promotions"/>
                    </a>
                </li>
                                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/views/hoteles.jsp">
                        <fmt:message key="nav.hotels"/>
                    </a>
                </li>

                <%
                    HttpSession sessionUser = request.getSession(false);
                    Usuario usuario = (sessionUser != null) ? (Usuario) sessionUser.getAttribute("usuario") : null;
                %>

                <% if (usuario != null) { %>

                <!-- Usuario logueado -->
                <li class="nav-item dropdown ms-3">
                    <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                        <img src="<%= (usuario.getAvatar() != null && !usuario.getAvatar().isEmpty())
                                ? (request.getContextPath() + "/" + usuario.getAvatar())
                                : (request.getContextPath() + "/views/images/default-user.png") %>"
                             class="rounded-circle border border-light me-2"
                             style="width:38px; height:38px; object-fit:cover;">
                        <span class="fw-bold text-white"><%= usuario.getNombre() %></span>
                    </a>

                    <ul class="dropdown-menu dropdown-menu-end shadow">
                        <li>
                            <a class="dropdown-item" href="<%= request.getContextPath() %>/views/perfil.jsp">
                                <i class="bi bi-person-circle me-2"></i>
                                <fmt:message key="nav.profile"/>
                            </a>
                        </li>

                        <li>
                            <a class="dropdown-item" href="<%= request.getContextPath() %>/views/mis_reservas.jsp">
                                <i class="bi bi-calendar-check me-2"></i>
                                <fmt:message key="nav.myReservations"/>
                            </a>
                        </li>

                        <li>
                            <a class="dropdown-item" href="<%= request.getContextPath() %>/views/cambiarcontrasena.jsp">
                                <i class="bi bi-key-fill me-2"></i>
                                <fmt:message key="nav.changePassword"/>
                            </a>
                        </li>

                        <li><hr class="dropdown-divider"></li>

                        <li>
                            <a class="dropdown-item text-danger fw-bold" href="<%= request.getContextPath() %>/UsuarioServlet?action=logout">
                                <i class="bi bi-box-arrow-right me-2"></i>
                                <fmt:message key="nav.logout"/>
                            </a>
                        </li>
                    </ul>
                </li>

                <% } else { %>

                <!-- Usuario invitado -->
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/views/login.jsp">
                        <fmt:message key="nav.login"/>
                    </a>
                </li>

                <li class="nav-item ms-2">
                    <a class="btn btn-warning text-dark fw-bold" href="<%= request.getContextPath() %>/views/registro.jsp">
                        <fmt:message key="nav.register"/>
                    </a>
                </li>

                <% } %>

                <!-- 🌍 Selector de idioma -->
                <li class="nav-item dropdown ms-3">
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                        🌎
                    </a>

                    <ul class="dropdown-menu dropdown-menu-end">
                        <li>
                            <a class="dropdown-item" href="<%= request.getContextPath() %>/LanguageServlet?lang=es">
                                🇪🇸 Español
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item" href="<%= request.getContextPath() %>/LanguageServlet?lang=en">
                                🇺🇸 English
                            </a>
                        </li>
                    </ul>
                </li>

            </ul>
        </div>
    </div>
</nav>
