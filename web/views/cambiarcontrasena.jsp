<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}" />
<fmt:setBundle basename="messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="title.change.password" /></title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/views/css/style.css">
</head>

<body class="perfil-bg">

    <%@ include file="navbar.jsp" %>

    <div class="perfil-container">
        <div class="perfil-card p-4 mx-auto text-center" style="max-width: 420px;">

            <!-- ICONO Y TÍTULO -->
            <div class="text-center mb-4">
                <i class="bi bi-shield-lock-fill text-warning" style="font-size: 3rem;"></i>
                <h4 class="mt-2 fw-bold">
                    <fmt:message key="profile.change.password" />
                </h4>
                <p class="text-muted small mb-0">
                    <fmt:message key="profile.change.password.subtitle" />
                </p>
            </div>

            <!-- MENSAJES -->
            <c:if test="${not empty mensaje}">
                <div class="alert alert-success text-center">
                    ${mensaje}
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger text-center">
                    ${error}
                </div>
            </c:if>

            <!-- FORMULARIO -->
            <form action="${pageContext.request.contextPath}/UsuarioServlet?action=cambiarContrasena" method="post">

                <!-- Contraseña actual -->
                <div class="mb-3 text-start">
                    <label for="actual" class="form-label fw-bold">
                        <fmt:message key="password.current" />
                    </label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent"><i class="bi bi-lock"></i></span>
                        <input type="password" id="actual" name="actual" class="form-control" required>
                    </div>
                </div>

                <!-- Nueva contraseña -->
                <div class="mb-3 text-start">
                    <label for="nueva" class="form-label fw-bold">
                        <fmt:message key="password.new" />
                    </label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent"><i class="bi bi-key"></i></span>
                        <input type="password" id="nueva" name="nueva" class="form-control" required>
                    </div>
                </div>

                <!-- Confirmar contraseña -->
                <div class="mb-4 text-start">
                    <label for="confirmar" class="form-label fw-bold">
                        <fmt:message key="password.confirm" />
                    </label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent"><i class="bi bi-check2-circle"></i></span>
                        <input type="password" id="confirmar" name="confirmar" class="form-control" required>
                    </div>
                </div>

                <!-- BOTÓN -->
                <div class="d-grid">
                    <button type="submit" class="btn btn-warning fw-bold">
                        <i class="bi bi-arrow-repeat me-2"></i>
                        <fmt:message key="password.update.button" />
                    </button>
                </div>

                <!-- VOLVER -->
                <div class="text-center mt-3">
                    <a href="${pageContext.request.contextPath}/views/perfil.jsp"
                       class="text-decoration-none text-dark small">
                        <i class="bi bi-arrow-left"></i>
                        <fmt:message key="back.to.profile" />
                    </a>
                </div>

            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
