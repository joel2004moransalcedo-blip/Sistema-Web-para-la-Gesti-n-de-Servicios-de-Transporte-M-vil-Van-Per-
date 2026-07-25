<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.movilvanperu.model.Usuario" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Configurar idioma según sesión -->
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}" />
<fmt:setBundle basename="messages" var="msg" />

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }

    String avatarPath = (usuario.getAvatar() != null && !usuario.getAvatar().isEmpty())
        ? request.getContextPath() + "/" + usuario.getAvatar()
        : request.getContextPath() + "/views/images/default-user.png";
%>

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="perfil.titulo" bundle="${msg}"/></title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/views/css/style.css" rel="stylesheet">
</head>
<body class="perfil-bg">

    <!-- Navbar -->
    <jsp:include page="navbar.jsp"/>

    <div class="container mt-5 pt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">

                <!-- Alertas -->
                <c:if test="${not empty mensaje}">
                    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i> ${mensaje}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Card perfil -->
                <div class="card shadow-lg border-0 rounded-4 bg-white bg-opacity-75 backdrop-blur">
                    <div class="card-body text-center p-4">
                        
                        <h3 class="mb-4 fw-bold text-dark">
                            <fmt:message key="perfil.titulo" bundle="${msg}"/>
                        </h3>

                        <!-- Avatar -->
                        <div class="d-flex justify-content-center mb-3">
                            <img src="<%= avatarPath %>"
                                 class="rounded-circle border border-3 border-secondary shadow-sm"
                                 style="width:130px; height:130px; object-fit:cover;">
                        </div>

                        <!-- Datos usuario -->
                        <h5 class="fw-bold mb-1"><%= usuario.getNombre() %> <%= usuario.getApellido() %></h5>
                        <p class="text-muted mb-3">
                            <i class="bi bi-envelope me-1"></i> <%= usuario.getCorreo() %>
                        </p>

                        <!-- Form actualizar avatar -->
                        <form action="<%= request.getContextPath() %>/UsuarioServlet?action=updateAvatar"
                              method="post" enctype="multipart/form-data"
                              class="text-start mt-4">

                            <input type="hidden" name="id" value="<%= usuario.getId() %>">

                            <div class="mb-3">
                                <label for="avatar" class="form-label fw-semibold">
                                    <fmt:message key="perfil.nuevoAvatar" bundle="${msg}"/>
                                </label>
                                <input type="file" id="avatar" name="avatar"
                                       class="form-control form-control-lg shadow-sm"
                                       accept="image/*" required>
                            </div>

                            <button type="submit"
                                    class="btn btn-warning text-dark fw-bold w-100 mt-3 shadow-sm">
                                <i class="bi bi-upload"></i>
                                <fmt:message key="perfil.actualizarAvatar" bundle="${msg}"/>
                            </button>
                        </form>

                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
