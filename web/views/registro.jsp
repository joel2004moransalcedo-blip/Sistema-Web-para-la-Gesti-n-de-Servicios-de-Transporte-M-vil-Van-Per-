<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>

<!DOCTYPE html>
<html lang="${sessionScope.lang != null ? sessionScope.lang : 'es'}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="register.button"/> - Movil Van Perú</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- CSS personalizado -->
    <link href="<%= request.getContextPath() %>/views/css/style.css" rel="stylesheet">
</head>
<body>

<!-- Navbar -->
<jsp:include page="navbar.jsp"/>

<section class="py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow">
                    <div class="card-body">
                        <h4 class="mb-4 text-center">
                            <fmt:message key="register.title"/>
                        </h4>

                        <!-- Mensaje de error -->
                        <%
                            String error = (String) request.getAttribute("error");
                            if (error != null) {
                        %>
                            <div class="alert alert-danger text-center">
                                <fmt:message key="register.error"/>
                            </div>
                        <% } %>

                        <!-- Formulario de registro -->
                        <form action="<%= request.getContextPath() %>/UsuarioServlet" method="post">
                            <input type="hidden" name="action" value="register">

                            <div class="mb-3">
                                <label for="nombre" class="form-label">
                                    <fmt:message key="register.name"/>
                                </label>
                                <input type="text" class="form-control" id="nombre" name="nombre" required>
                            </div>

                            <div class="mb-3">
                                <label for="apellido" class="form-label">
                                    <fmt:message key="register.lastname"/>
                                </label>
                                <input type="text" class="form-control" id="apellido" name="apellido" required>
                            </div>

                            <div class="mb-3">
                                <label for="usuario" class="form-label">
                                    <fmt:message key="register.username"/>
                                </label>
                                <input type="text" class="form-control" id="usuario" name="usuario" required>
                            </div>

                            <div class="mb-3">
                                <label for="correo" class="form-label">
                                    <fmt:message key="register.email"/>
                                </label>
                                <input type="email" class="form-control" id="correo" name="correo" required>
                            </div>

                            <div class="mb-3">
                                <label for="contrasena" class="form-label">
                                    <fmt:message key="register.password"/>
                                </label>
                                <input type="password" class="form-control" id="contrasena" name="contrasena" required>
                            </div>

                            <div class="mb-3">
                                <label for="confirmar" class="form-label">
                                    <fmt:message key="register.confirmPassword"/>
                                </label>
                                <input type="password" class="form-control" id="confirmar" name="confirmar" required>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-success">
                                    <fmt:message key="register.button"/>
                                </button>
                            </div>
                        </form>

                        <div class="mt-3 text-center">
                            <a href="login.jsp">
                                <fmt:message key="register.haveAccount"/>
                            </a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<footer class="bg-dark text-white text-center py-3">
    <p>&copy; <fmt:message key="register.footer"/></p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Validación del lado del cliente (también traducida) -->
<script>
document.querySelector("form").addEventListener("submit", function (e) {
    const pass = document.getElementById("contrasena").value;
    const confirm = document.getElementById("confirmar").value;

    if (pass !== confirm) {
        e.preventDefault();
        alert("<fmt:message key='register.passwordMismatch'/>");
    }
});
</script>

</body>
</html>
