# 🚐 Sistema Web Empresarial - Móvil Van Perú

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Bootstrap](https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white)

## 📖 Acerca del Proyecto
**Móvil Van Perú** es una aplicación web empresarial desarrollada bajo la arquitectura Java EE (Jakarta EE), diseñada para modernizar y automatizar la gestión de clientes, reservas de transporte, viajes y servicios complementarios como hoteles y paquetes turísticos.

Este proyecto resuelve ineficiencias operativas causadas por procesos manuales, ofreciendo una plataforma unificada con disponibilidad 24/7, verificación en tiempo real, pagos ágiles y un panel administrativo completo.

## ✨ Características Principales

### 👤 Para Clientes (Usuarios Finales)
* **Autenticación Segura:** Registro, inicio de sesión, recuperación de contraseña y edición de perfil.
* **Reservas Dinámicas:** Reserva de paquetes turísticos y habitaciones de hoteles verificando disponibilidad en tiempo real.
* **Carrito y Pagos:** Selección de método de pago y visualización/descarga de comprobantes.
* **Soporte Multi-idioma (i18n):** Cambio de idioma (Español/Inglés) en tiempo real.
* **Promociones:** Sistema de banners y ofertas de paquetes gratis.

### 🛡️ Para Administradores
* **Panel de Control (Dashboard):** Gestión completa de la plataforma.
* **Mantenimiento (CRUD):** Administración de usuarios, hoteles, paquetes turísticos, promociones y reservas.
* **Control de Pagos y Viajes:** Modificación de estados de pago y monitoreo de itinerarios.
* **Reportes:** Generación de reportes operativos y de ventas.

## 🛠️ Tecnologías y Arquitectura

El proyecto está estructurado bajo una **arquitectura multinivel** y el patrón **MVC (Modelo-Vista-Controlador)**.

* **Frontend (Presentación):** HTML5, CSS3, JavaScript, Bootstrap.
* **Backend (Lógica de Negocio):** Java EE (JSP, Servlets, JSTL, EL), Servicios RESTful.
* **Base de Datos (Persistencia):** MySQL, gestionado mediante JDBC.
* **Patrones de Diseño Aplicados:** MVC, DAO (Data Access Object), DTO (Data Transfer Object), Facade.

## 🚀 Instalación y Despliegue (Getting Started)

### Prerrequisitos
* **Java JDK** (versión 8 o superior recomendada)
* Servidor de aplicaciones web: **Apache Tomcat** (o GlassFish)
* Gestor de Base de Datos: **MySQL**
* IDE: Apache NetBeans, Eclipse o IntelliJ IDEA

### Pasos de Instalación
1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/joel2004moransalcedo-blip/Sistema-Web-para-la-Gesti-n-de-Servicios-de-Transporte-M-vil-Van-Per-.git
   ```
2. **Configurar la Base de Datos:**
   * Crear una base de datos en MySQL y ejecutar el script `movilvan_db.sql` adjunto en el repositorio.
   * Actualizar las credenciales (usuario y contraseña) en el archivo de conexión de la capa DAO del proyecto.
3. **Configurar Librerías:**
   * Asegúrate de tener agregados en el `Build Path` (o carpeta `WEB-INF/lib`) los `.jar` provistos en el repositorio: `mysql-connector-j`, `gson`, `jakarta.servlet.jsp.jstl`, etc.
4. **Ejecución:**
   * Compila el proyecto y ejecútalo sobre el servidor Tomcat.

## 📂 Estructura del Proyecto

* `com.movilvanperu.model`: Clases modelo / entidades (DTOs).
* `com.movilvanperu.dao`: Clases para el acceso a la base de datos (CRUD).
* `com.movilvanperu.controller`: Servlets que manejan las peticiones HTTP y aplican la lógica.
* `Web Pages`: Vistas en JSP, hojas de estilo (CSS) y scripts (JS).

---
*Desarrollado como proyecto para la implementación de sistemas web integrados aplicando tecnologías empresariales robustas.*
