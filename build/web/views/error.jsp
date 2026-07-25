<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="lang" value="${sessionScope.lang != null ? sessionScope.lang : 'es'}" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="messages" />

<!DOCTYPE html>
<html lang="${lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="error.title" /> - Movil Van Perú</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet">

    <style>
        body { background: #f5f6fa; }
        .error-hero {
            background: linear-gradient(135deg, #b71c1c, #d32f2f);
            color: white; padding: 70px 0; text-align: center;
        }
        .error-card {
            background: white; border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            padding: 40px; animation: fadeIn 0.6s ease-in-out;
        }
        .error-icon { font-size: 80px; color: #d32f2f; }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp"/>

<header class="error-hero">
    <div class="container">
        <h1><fmt:message key="error.header" /></h1>
        <p class="lead"><fmt:message key="error.header.desc" /></p>
    </div>
</header>

<section class="py-5">
    <div class="container d-flex justify-content-center">
        <div class="col-md-8">
            <div class="error-card text-center">
                <i class="bi bi-exclamation-triangle-fill error-icon"></i>

                <h2 class="mt-3 mb-4"><fmt:message key="error.subtitle" /></h2>

                <%
                    String error = (String) request.getAttribute("error");
                    if (error == null || error.trim().isEmpty()) {
                        error = "Error desconocido. Por favor, vuelve a intentarlo más tarde.";
                    }
                %>

                <p class="text-muted mb-4"><%= error %></p>

                <div class="d-flex justify-content-center gap-3 mt-4">
                    <a href="<%= request.getContextPath() %>/views/viajes.jsp" class="btn btn-primary px-4">
                        <i class="bi bi-arrow-left-circle"></i> 
                        <fmt:message key="error.back.to.trips" />
                    </a>

                    <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-outline-dark px-4">
                        <i class="bi bi-house"></i> 
                        <fmt:message key="error.go.home" />
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<footer class="bg-dark text-white text-center py-3 mt-5">
    <p>&copy; 2025 Movil Van Perú - <fmt:message key="footer.rights" /></p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
