<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>

<!DOCTYPE html>
<html lang="${sessionScope.lang != null ? sessionScope.lang : 'es'}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="login.button"/> - Movil Van Perú</title>

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
            <div class="col-md-5">
                <div class="card shadow">
                    <div class="card-body">

                        <h4 class="mb-4 text-center">
                            <fmt:message key="login.title"/>
                        </h4>

                        <!-- Mensajes -->
                        <%
                            String error = (String) request.getAttribute("error");
                            String success = (String) request.getAttribute("success");
                        %>

                        <% if (error != null) { %>
                            <div class="alert alert-danger text-center">
                                <fmt:message key="login.error"/>
                            </div>
                        <% } else if (success != null) { %>
                            <div class="alert alert-success text-center">
                                <fmt:message key="login.success"/>
                            </div>
                        <% } %>

                        <!-- Formulario de inicio de sesión -->
                        <form action="<%= request.getContextPath() %>/UsuarioServlet" method="post">
                            <input type="hidden" name="action" value="login">

                            <div class="mb-3">
                                <label for="usuario" class="form-label">
                                    <fmt:message key="login.username"/>
                                </label>
                                <input type="text" class="form-control" id="usuario" name="usuario" required>
                            </div>

                            <div class="mb-3">
                                <label for="contrasena" class="form-label">
                                    <fmt:message key="login.password"/>
                                </label>
                                <input type="password" class="form-control" id="contrasena" name="contrasena" required>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary">
                                    <fmt:message key="login.button"/>
                                </button>
                            </div>
                        </form>

                        <div class="mt-3 text-center">
                            <a href="#"><fmt:message key="login.forgotPassword"/></a><br>
                            <a href="registro.jsp"><fmt:message key="login.register"/></a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<footer class="bg-dark text-white text-center py-3">
    <p>&copy; <fmt:message key="login.footer"/></p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
