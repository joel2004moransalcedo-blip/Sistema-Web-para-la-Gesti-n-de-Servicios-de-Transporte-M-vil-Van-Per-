-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 29-11-2025 a las 01:02:12
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `movilvan_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hotel`
--

CREATE TABLE `hotel` (
  `id_hotel` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `ciudad` varchar(120) DEFAULT NULL,
  `pais` varchar(120) DEFAULT NULL,
  `estrellas` int(11) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `imagen1` varchar(255) DEFAULT NULL,
  `imagen2` varchar(255) DEFAULT NULL,
  `imagen3` varchar(255) DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `precio_noche` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `hotel`
--

INSERT INTO `hotel` (`id_hotel`, `nombre`, `descripcion`, `direccion`, `ciudad`, `pais`, `estrellas`, `telefono`, `email`, `imagen1`, `imagen2`, `imagen3`, `creado_en`, `precio_noche`) VALUES
(5, 'ALQUILO HABITACION MUY BIEN UBICADO', 'ÁREA DE TERRENO 200 M2\r\nÁREA CONSTRUIDA 350 M2\r\n15 HABITACIONES\r\nZONIFICACION CZ\r\nCON O SIN MUEBLES 15 habitaciones, con o sin muebles, 20 años de antiguedad, vista a la calle, en buen estado, flat. 15.0 baños', 'Miraflores, Lima', 'Lima', 'Peru', 3, '51993471853', 'PilarVasquez2pisos@gmail.com', '1764184883794_th.outside800x600.870732_59228282_975.webp', '1764184883804_th.outside800x600.870732_59228282_661.webp', '1764184883807_th.outside800x600.870732_59228282_295.webp', '2025-11-26 19:06:13', 150.00),
(6, 'Alquiler de Habitacion en Yucay Urubamba', 'Recepcin amplia\r\nCocina equipada\r\nComedor espacioso\r\nDos patios interiores\r\nInternet incluido\r\nAgua caliente con sistema a gas\r\nTres baos comunes adicionales\r\nUbicado frente a la va principal', 'Urubamba,+Cuzco', 'Cuzco', 'Peru', 4, '51942772896', 'REMAXCUSCOIMPERIALS.A.C.@gmail.com', '1764184941333_th.outside1200x1200.175083992_144228632_395.webp', '1764184941341_th.outside1200x1200.175083992_144228632_933.webp', '1764184941343_th.outside1200x1200.175083992_144228632_725.webp', '2025-11-26 19:09:56', 350.00),
(7, 'ALQUILER CASA IDEAL HOSPEDAJES CONSULTORIOS OFICINAS CLNICAS FRENTE PARQUE', 'Oportunidad Casa Ideal Consultorios Oficinas Clnica o Vivienda Frente Parque\r\nGran Oportunidad Casa Ideal para Consultorios Oficinas Clnica o Vivienda Frente a Parque\r\nUbicada en una zona estratgica cerca de Avenida Elmer Faucett y Avenida Canta Callao a tan solo minutos del Aeropuerto Internacional Jorge Chvez Esta espaciosa propiedad ofrece una distribucin ideal para diversos usos comerciales o residenciales', 'Cercado del Callao, Lima', 'Lima', 'Peru', 3, '9435268678', 'CENTURY21PREMIUM@gmail.com', '1764185125581_th.outside1200x1200.173845859_143916174_543.webp', '1764185125591_th.outside1200x1200.173845859_143916174_235.webp', '1764185125594_th.outside1200x1200.173845859_143916174_332.webp', '2025-11-26 19:25:25', 233.30),
(8, 'HOTEL JULIACA PUNO', 'Hotel de pisos cuenta con habitaciones y locales comerciales ubicados en el primer piso Se encuentra ubicado en el corazon de Juliaca a una cuadra del Mall Real Plaza a pocas cuadras del mercado Central Esta es una oportunidad perfecta de inversion teniendo en cuenta que Juliaca es la capital comercial de Puno por lo que la afluencia de viajeros es constante', 'Juliaca, Puno', 'Puno', 'Peru', 5, '145677289', 'IDEA&CONSTRUYEE.I.R.L.@gmail.com', '1764186253076_th.outside500x500.175100773_4646696_337.webp', '1764186253087_th.outside1200x1200.175100773_4646696_180.webp', '1764186253090_th.outside1200x1200.175100773_4646696_907.webp', '2025-11-26 19:44:13', 145.67),
(9, 'SE VENDE HERMOSA HABITACION EN CERCADO DE AREQUIPA', 'SE VENDE HOTEL EN EL CERCADO DE AREQUIPA\r\nAREA DE TERRENO M\r\nAREA CONSTRUIDA M\r\nTIENE HABITACIONES PISCINA RESEPCION LAVANDERIA COCINA COMEDOR COCHERA', 'Arequipa, Arequipa', 'Arequipa', 'Peru', 5, '942742933', 'ARRASINMOBILIARIA443@gmail.com', '1764186445804_th.outside1200x1200.175084042_4612264_414.webp', '1764186445814_th.outside1200x1200.175084042_4612264_242.webp', '1764186445817_th.outside1200x1200.175084042_4612264_358.webp', '2025-11-26 19:47:25', 429.33),
(10, 'Hotel en Tarapoto', 'indo albergue en la mejor zona de la Laguna Azul, son 10 hectareas, tiene 130 metros de orilla a la Laguna Azul, el lugar es muy bonito, es una excelente inversion.', 'Tarapoto, San Martin', 'San Martin', 'Peru', 3, '51980299299', 'DIEGOMARTIN323@gmail.com', '1764186674726_th.outside1200x1200.870926_13429199_133.webp', '1764186674741_th.outside1200x1200.870926_13429199_61.webp', '1764186674743_th.outside1200x1200.870926_13429199_693.webp', '2025-11-26 19:51:14', 84.33),
(11, 'Bello hotel a orillas del mar en Mncora', 'Cuenta con habitaciones Suit Standad Standard Kitchenette Bungalows Simples para personas con discapacidad aire acondicionado atmsfera relajante y clida Buena Vista Mncora cuenta con los siguientes servicios agua caliente internet inalmbrico tv cable terrazas vista al mar hidromasajes parrilla bellos jardines etc En los cuales se pueden alojar a grupos grandes como familias estudiantes parejas amigos etc\r\nLa construccin de los departamentos son una edificacin tradicional que harn de su permanencia muy placentera Cuenta con una piscina grande de niveles para adultos y nios', 'Mancora, Piura', 'Piura', 'Peru', 4, '981140029', 'PERUSOTHEBYS456@gmail.com', '1764187031243_th.outside1200x1200.870091_143960930_541.webp', '1764187031252_th.outside1200x1200.870091_143960930_738.webp', '1764187031254_th.outside1200x1200.870091_143960930_573.webp', '2025-11-26 19:57:11', 380.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pago`
--

CREATE TABLE `pago` (
  `id` int(11) NOT NULL,
  `codigo_pago` varchar(50) DEFAULT NULL,
  `id_reserva` int(11) NOT NULL,
  `metodo` varchar(50) NOT NULL,
  `numero_tarjeta` varchar(20) DEFAULT NULL,
  `nombre_titular` varchar(100) DEFAULT NULL,
  `fecha_pago` datetime DEFAULT current_timestamp(),
  `monto` decimal(10,2) NOT NULL,
  `estado` varchar(50) DEFAULT 'pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pago`
--

INSERT INTO `pago` (`id`, `codigo_pago`, `id_reserva`, `metodo`, `numero_tarjeta`, `nombre_titular`, `fecha_pago`, `monto`, `estado`) VALUES
(7, 'PAY-1764183230470', 65, 'yape', NULL, 'Jomar', '2025-11-26 13:53:50', 1317.45, 'completado'),
(8, 'PAY-1764183235468', 66, 'yape', NULL, 'chelsea', '2025-11-26 13:53:55', 1317.45, 'completado'),
(9, 'PAY-1764183240318', 67, 'yape', NULL, 'Maria', '2025-11-26 13:54:00', 1317.45, 'completado'),
(10, 'PAY-1764275977986', 70, 'yape', NULL, 'Jomar', '2025-11-27 15:39:38', 1320.85, 'completado'),
(11, 'PAY-1764276564139', 72, 'debit', '1234 5678 9456 8890', 'Jomar', '2025-11-27 15:49:24', 794.54, 'completado'),
(12, 'PAY-1764284929640', 73, 'yape', NULL, 'Jomar', '2025-11-27 18:08:49', 794.54, 'completado'),
(13, 'PAY-1764345694072', 75, 'yape', NULL, 'Jomar', '2025-11-28 11:01:34', 1317.45, 'completado'),
(14, 'PAY-1764345699355', 76, 'yape', NULL, 'chelsea', '2025-11-28 11:01:39', 1317.45, 'completado'),
(15, 'PAY-1764345704522', 77, 'yape', NULL, 'Jomar', '2025-11-28 11:01:44', 1317.45, 'completado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pago_hotel`
--

CREATE TABLE `pago_hotel` (
  `id_pago` int(11) NOT NULL,
  `id_reserva_hotel` int(11) NOT NULL,
  `metodo` varchar(50) NOT NULL,
  `numero_tarjeta` varchar(25) DEFAULT NULL,
  `nombre_titular` varchar(100) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha_pago` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pago_hotel`
--

INSERT INTO `pago_hotel` (`id_pago`, `id_reserva_hotel`, `metodo`, `numero_tarjeta`, `nombre_titular`, `monto`, `fecha_pago`) VALUES
(5, 5, 'yape', NULL, 'chelsea', 1050.00, '2025-11-26 21:16:34'),
(6, 7, 'credit', '1234 5678 9456 8890', 'Jomar', 450.00, '2025-11-28 04:27:22'),
(7, 9, 'yape', NULL, 'Chelsea', 1200.00, '2025-11-28 16:00:34');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paquetes`
--

CREATE TABLE `paquetes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `destino` varchar(150) NOT NULL,
  `fecha_salida` date NOT NULL,
  `fecha_retorno` date NOT NULL,
  `imagen1` varchar(255) DEFAULT NULL,
  `imagen2` varchar(255) DEFAULT NULL,
  `imagen3` varchar(255) DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `valoracion` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `paquetes`
--

INSERT INTO `paquetes` (`id`, `nombre`, `descripcion`, `precio`, `destino`, `fecha_salida`, `fecha_retorno`, `imagen1`, `imagen2`, `imagen3`, `creado_en`, `valoracion`) VALUES
(8, 'Escapada a Cusco', 'Cusco, antigua capital del Imperio Inca, es una ciudad que fusiona la majestuosidad de su legado precolombino con la riqueza de la arquitectura colonial española. Declarada Patrimonio Cultural de la Humanidad por la UNESCO en 1983, Cusco ofrece una variedad de atractivos que cautivan a los visitantes.', 797.94, 'Cusco', '2025-11-26', '2025-11-28', 'views/images/paquetes/1764180145853_Turismo-en-Cusco.webp', 'views/images/paquetes/1764180146243_YTQP-Cusco-Machu-Picchu.jpg', 'views/images/paquetes/1764180146245_Cusco-2.jpg', '2025-11-26 18:02:26', 3),
(9, 'Arequipa y el Cañón del Colca', 'Si estás buscando un viaje que combine historia, cultura y paisajes impresionantes, Arequipa y el Cañón del Colca son el destino perfecto.\r\nEste lugar lo tiene todo para cautivarte y dejarte recuerdos inolvidables.', 1507.60, 'Arequipa, Perú', '2025-11-26', '2025-11-29', 'views/images/paquetes/1764180261043_El-canon-del-colca.jpg', 'views/images/paquetes/1764180261070_colca-arequipa.webp', 'views/images/paquetes/1764180261073_canon-del-colca-arequipa.jpg', '2025-11-26 18:04:21', 4),
(10, 'Escapada a Tarapoto', 'Tarapoto es una ciudad ubicada en la región San Martín, al nororiente del Perú, conocida como la “Ciudad de las Palmeras” por su vegetación exuberante.', 1320.85, 'San Martin', '2025-11-20', '2025-11-28', 'views/images/paquetes/1764180381868_ticr_640_350.jpg', 'views/images/paquetes/1764180381875_ticr_640_350__1_.jpg', 'views/images/paquetes/1764180381881_ticr_640_350__2_.jpg', '2025-11-26 18:06:21', 5),
(11, 'Puno y el Lago Titicaca', 'Embárcate en una experiencia única en Puno y el Lago Titicaca, el lago navegable más alto del mundo y uno de los destinos más emblemáticos de los Andes.', 937.16, 'Puno – Lago Titicaca', '2025-11-20', '2025-12-04', 'views/images/paquetes/1764180456531_maxresdefault__1_.jpg', 'views/images/paquetes/1764180456543_240647-Lake-Titicaca.webp', 'views/images/paquetes/1764180456566_titicaca-atractivos_637649828676542514.jpg', '2025-11-26 18:07:36', 4),
(12, 'Escapada a Lima', 'Lima, la capital de Perú, es una ciudad que combina lo mejor de la historia colonial, la modernidad y la tradición culinaria.', 794.54, 'Lima', '2025-11-28', '2025-12-02', 'views/images/paquetes/1764180556138_ticr_640_350__3_.jpg', 'views/images/paquetes/1764180556146_ticr_640_350__4_.jpg', 'views/images/paquetes/1764180556149_ticr_640_350__5_.jpg', '2025-11-26 18:09:16', 3),
(13, 'Escapada a Punta Sal', 'Punta Sal y sus bellas playas es un destino que combina belleza natural, actividades recreativas y una oferta gastronómica excepcional, convirtiéndolo en una opción ideal para quienes buscan una escapada tropical en el norte del Perú.', 1324.24, 'Tumbes', '2025-11-27', '2025-12-05', 'views/images/paquetes/1764180634171_sddefault.jpg', 'views/images/paquetes/1764180634180_79785938.jpg', 'views/images/paquetes/1764180634184_expedia_group-469855-2c034dc6-430600.jpg', '2025-11-26 18:10:34', 5),
(14, 'Escapada a Pucallpa', 'Pucallpa es una vibrante ciudad amazónica ubicada en la región Ucayali, al oriente del Perú.', 794.54, 'Ucayali', '2025-12-01', '2025-12-05', 'views/images/paquetes/1764180934756_ticr_640_350__6_.jpg', 'views/images/paquetes/1764180934775_ticr_640_350__7_.jpg', 'views/images/paquetes/1764180934777_ticr_640_350__8_.jpg', '2025-11-26 18:15:34', 3),
(15, 'Explora Kuélap y Gocta', 'Si estás buscando una aventura inolvidable en Perú, te recomendamos explorar los fascinantes destinos de Kuélap y la Catarata de Gocta.', 957.53, 'Amazonas', '2025-11-20', '2025-11-27', 'views/images/paquetes/1764181211594_ticr_640_350__9_.jpg', 'views/images/paquetes/1764181211610_ticr_640_350__10_.jpg', 'views/images/paquetes/1764181211615_ticr_640_350__11_.jpg', '2025-11-26 18:20:11', 4),
(16, 'Escapada a Máncora', 'Máncora es uno de los destinos más visitados de Perú, famoso por sus impresionantes playas de fina arena blanca y aguas cristalinas de color turquesa.', 1317.45, 'Piura', '2025-11-27', '2025-11-29', 'views/images/paquetes/1764181361167_ticr_640_350__12_.jpg', 'views/images/paquetes/1764181361183_ticr_640_350__13_.jpg', 'views/images/paquetes/1764181361184_ticr_640_350__14_.jpg', '2025-11-26 18:22:41', 2),
(17, 'Escapada a Cajamarca', 'Ubicada en el norte de Perú, Cajamarca es una ciudad de gran riqueza histórica y cultural, conocida como el lugar donde se selló el destino del imperio Inca con la captura del emperador Atahualpa.', 804.73, 'Cajamarca', '2025-11-20', '2025-11-30', 'views/images/paquetes/1764181514984_ticr_640_350__15_.jpg', 'views/images/paquetes/1764181515002_ticr_640_350__16_.jpg', 'views/images/paquetes/1764181515006_istock_59777462_large.jpg', '2025-11-26 18:25:15', 3),
(18, 'Escapada a Iquitos', 'Iquitos es la ciudad más grande de la Amazonía peruana y una de las pocas en el mundo a la que no se puede llegar por carretera, solo por avión o río.', 1320.85, 'Iquitos, Perú', '2025-11-14', '2025-11-28', 'views/images/paquetes/1764182933056_ticr_640_350__17_.jpg', 'views/images/paquetes/1764182933062_ticr_640_350__18_.jpg', 'views/images/paquetes/1764182933065_ticr_640_350__19_.jpg', '2025-11-26 18:26:53', 4),
(20, 'Majestuoso callejones de Huaraz ', 'Este es un destino ideal para viajar en bus, donde explorarás la majestuosa Cordillera Blanca, hogar del nevado Huascarán, el más alto del Perú, y la famosa Laguna 69, de aguas cristalinas.', 255.00, 'Ancash', '2025-11-30', '2025-12-04', 'views/images/paquetes/1764182917098_maxresdefault__2_.jpg', 'views/images/paquetes/1764182917126_01JNH99ASBR5YQ8Y8NWXVVBZTA.jpg', 'views/images/paquetes/1764182917134_HuarazyHuascaran.jpg', '2025-11-26 18:48:37', 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `promociones`
--

CREATE TABLE `promociones` (
  `id` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text NOT NULL,
  `id_paquete_gratis` int(11) NOT NULL,
  `cantidad_requerida` int(11) NOT NULL,
  `banner` varchar(255) DEFAULT NULL,
  `estado` enum('activa','inactiva') DEFAULT 'activa',
  `creada_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `promociones`
--

INSERT INTO `promociones` (`id`, `nombre`, `descripcion`, `id_paquete_gratis`, `cantidad_requerida`, `banner`, `estado`, `creada_en`) VALUES
(10, 'Viaje de Promoción Máncora  6D 5N', 'Si estás buscando una playa espléndida para disfrutar del calor y brillo solar, además de presenciar hermosas puestas del sol, pues te recomendamos hacer los viajes de promoción escolar a Máncora, un bello balneario de Piura en el norte de Perú.', 16, 3, '1764182225723_viajes-de-promocion-a-mancora-6-dias-por-fertur.jpg', 'activa', '2025-11-26 18:37:05'),
(11, 'Viajes de Luna de Miel en Perú y el mundo con Fertur', 'Pensando en esa fecha tan especial de su boda y los preparativos para el viaje de Luna de Miel, en Fertur PerúTravel contamos con paquetes turísticos a lugares románticos en destinos de Perú y en el extranjero.', 8, 4, '1764182420675_viajes-de-novios-peru-fertur-peru-travel.jpg', 'activa', '2025-11-26 18:40:20'),
(12, 'Decameron: Para tu viaje de promoción escolar a Punta Sal', 'Te recomendamos este maravilloso viaje de promoción escolar a Punta Sal, con el Hotel Decameron de Tumbes, ubicado en el norte del Perú. ', 13, 4, '1764182586387_flyer-promocion-escolares-decameron-punta-sal.jpg', 'activa', '2025-11-26 18:43:06'),
(13, 'Tours Huaraz para promociones escolares vía Oltursa 4D 3N', 'Con este paquete turístico los estudiantes partirán desde el terminal terrestre indicado en la ciudad de Lima, a las 22:15 horas a bordo de un confortable bus de la empresa Oltursa (servicio regular).', 20, 5, '1764183045999_huaraz-tour-escolares-580pix.jpg', 'activa', '2025-11-26 18:50:46'),
(14, 'Viajes escolares a Cajamarca con Cruz del Sur 4D 3N', 'Este viaje de promoción escolar tendrá visitas guiadas a los atractivos turísticos más representativos de Cajamarca, ubicada en la sierra norte de Perú. ', 17, 6, '1764183166991_cajamarca-viaje-promo-escolar-580px.jpg', 'activa', '2025-11-26 18:52:47'),
(15, 'Viaje de promoción escolar a Cusco en bus 5 días 4 noches', '¿Buscando tours para escolares? En Fertur Perú Travel contamos con este paquete promocional para que los estudiantes conozcan en 5 días y 4 noches, la historia, riqueza cultural y el misticismo que envuelve la ciudad de Cusco, incluyendo excursiones guiadas al Valle Sagrado y Machu Picchu. ', 8, 10, '1764183481129_cusco-promocion-escolares-5d-4n-580px.jpg', 'activa', '2025-11-26 18:58:01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `promociones_claims`
--

CREATE TABLE `promociones_claims` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_promocion` int(11) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `promociones_claims`
--

INSERT INTO `promociones_claims` (`id`, `id_usuario`, `id_promocion`, `fecha`) VALUES
(9, 3, 10, '2025-11-26 18:54:05'),
(10, 2, 10, '2025-11-28 16:01:48');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reserva`
--

CREATE TABLE `reserva` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_paquete` int(11) NOT NULL,
  `fecha_reserva` datetime DEFAULT current_timestamp(),
  `estado` varchar(50) DEFAULT 'pendiente',
  `metodo_pago` varchar(50) DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `reserva`
--

INSERT INTO `reserva` (`id`, `id_usuario`, `id_paquete`, `fecha_reserva`, `estado`, `metodo_pago`, `total`) VALUES
(65, 3, 16, '2025-11-26 13:53:29', 'pagada', 'yape', 1317.45),
(66, 3, 16, '2025-11-26 13:53:40', 'pagada', 'yape', 1317.45),
(67, 3, 16, '2025-11-26 13:53:44', 'pagada', 'yape', 1317.45),
(68, 3, 16, '2025-11-26 13:54:05', 'pagada', 'promocion', 0.00),
(69, 2, 20, '2025-11-27 15:13:22', 'cancelada', 'yape', 255.00),
(70, 2, 18, '2025-11-27 15:39:20', 'pagada', 'yape', 1320.85),
(71, 2, 18, '2025-11-27 15:39:52', 'cancelada', 'yape', 1320.85),
(72, 2, 14, '2025-11-27 15:40:17', 'pagada', 'yape', 794.54),
(73, 2, 12, '2025-11-27 18:08:43', 'pagada', 'yape', 794.54),
(74, 2, 18, '2025-11-27 18:13:57', 'cancelada', 'yape', 1320.85),
(75, 2, 16, '2025-11-28 11:01:13', 'pagada', 'yape', 1317.45),
(76, 2, 16, '2025-11-28 11:01:19', 'pagada', 'yape', 1317.45),
(77, 2, 16, '2025-11-28 11:01:24', 'pagada', 'yape', 1317.45),
(78, 2, 16, '2025-11-28 11:01:48', 'pagada', 'promocion', 0.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reserva_hotel`
--

CREATE TABLE `reserva_hotel` (
  `id_reserva_hotel` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_hotel` int(11) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `precio_noche` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `estado` varchar(50) DEFAULT 'pendiente',
  `fecha_reserva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `reserva_hotel`
--

INSERT INTO `reserva_hotel` (`id_reserva_hotel`, `id_usuario`, `id_hotel`, `fecha_inicio`, `fecha_fin`, `precio_noche`, `total`, `estado`, `fecha_reserva`) VALUES
(5, 2, 6, '2025-11-19', '2025-11-21', 350.00, 1050.00, 'pagada', '2025-11-26 21:16:27'),
(6, 2, 6, '2025-11-27', '2025-11-29', 350.00, 1050.00, 'Cancelada', '2025-11-27 20:24:27'),
(7, 2, 5, '2025-11-27', '2025-11-29', 150.00, 450.00, 'pagada', '2025-11-28 04:22:12'),
(8, 2, 11, '2025-11-27', '2025-11-29', 380.00, 1140.00, 'Cancelada', '2025-11-28 04:29:20'),
(9, 2, 5, '2025-11-28', '2025-12-05', 150.00, 1200.00, 'pagada', '2025-11-28 16:00:20');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `rol` enum('admin','usuario') NOT NULL DEFAULT 'usuario',
  `avatar` varchar(255) DEFAULT 'views/images/default-user.png'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `apellido`, `usuario`, `correo`, `contrasena`, `fecha_registro`, `rol`, `avatar`) VALUES
(1, 'Joel', 'Moran', 'admin', 'admin@correo.com', 'e10adc3949ba59abbe56e057f20f883e', '2025-10-07 20:34:20', 'admin', NULL),
(2, 'Joel Jomar', 'Moran Salcedo', 'joel1604', 'Joel2004.moran.salcedo@gmail.com', '202cb962ac59075b964b07152d234b70', '2025-10-07 22:46:04', 'usuario', 'views/images/usuarios/user_2_1763945629554_521455877_644477631994759_2973125585820058473_n.jpg'),
(3, 'Pedro ', 'Suarez Bertiz', 'Pedro2005', 'Angek2003@gmail.com', '81dc9bdb52d04dc20036dbd8313ed055', '2025-10-08 00:43:06', 'usuario', 'views/images/usuarios/user_3_1759885072586_Izurumi.png'),
(4, 'Pedro ', '', 'V2345', 'Pedro@gmail.com', 'e10adc3949ba59abbe56e057f20f883e', '2025-10-11 01:29:02', 'admin', 'views/images/default-user.png'),
(5, 'Heidy', '', 'V234345', 'Tinoco@gmail.com', '202cb962ac59075b964b07152d234b70', '2025-10-11 01:42:05', 'admin', 'views/images/default-user.png'),
(6, 'Yolanda', '', 'V23456789', 'Yolanda2004@gmial.com', 'a541c0a470b2068fb7592265ba4ab140', '2025-11-26 17:19:24', 'admin', 'views/images/default-user.png'),
(7, 'Jomar', '', 'V1582000', 'Moran2004@gmail.com', '0192023a7bbd73250516f069df18b500', '2025-11-28 23:59:37', 'admin', 'views/images/default-user.png');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `hotel`
--
ALTER TABLE `hotel`
  ADD PRIMARY KEY (`id_hotel`);

--
-- Indices de la tabla `pago`
--
ALTER TABLE `pago`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_pago_reserva` (`id_reserva`);

--
-- Indices de la tabla `pago_hotel`
--
ALTER TABLE `pago_hotel`
  ADD PRIMARY KEY (`id_pago`),
  ADD KEY `fk_pago_reserva_hotel` (`id_reserva_hotel`);

--
-- Indices de la tabla `paquetes`
--
ALTER TABLE `paquetes`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `promociones`
--
ALTER TABLE `promociones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_paquete_gratis` (`id_paquete_gratis`);

--
-- Indices de la tabla `promociones_claims`
--
ALTER TABLE `promociones_claims`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_usuario` (`id_usuario`,`id_promocion`);

--
-- Indices de la tabla `reserva`
--
ALTER TABLE `reserva`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_paquete` (`id_paquete`);

--
-- Indices de la tabla `reserva_hotel`
--
ALTER TABLE `reserva_hotel`
  ADD PRIMARY KEY (`id_reserva_hotel`),
  ADD KEY `fk_reserva_usuario` (`id_usuario`),
  ADD KEY `fk_reserva_hotel` (`id_hotel`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD UNIQUE KEY `usuario` (`usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `hotel`
--
ALTER TABLE `hotel`
  MODIFY `id_hotel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `pago`
--
ALTER TABLE `pago`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `pago_hotel`
--
ALTER TABLE `pago_hotel`
  MODIFY `id_pago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `paquetes`
--
ALTER TABLE `paquetes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `promociones`
--
ALTER TABLE `promociones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `promociones_claims`
--
ALTER TABLE `promociones_claims`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `reserva`
--
ALTER TABLE `reserva`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT de la tabla `reserva_hotel`
--
ALTER TABLE `reserva_hotel`
  MODIFY `id_reserva_hotel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `pago`
--
ALTER TABLE `pago`
  ADD CONSTRAINT `fk_pago_reserva` FOREIGN KEY (`id_reserva`) REFERENCES `reserva` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `pago_hotel`
--
ALTER TABLE `pago_hotel`
  ADD CONSTRAINT `fk_pago_reserva_hotel` FOREIGN KEY (`id_reserva_hotel`) REFERENCES `reserva_hotel` (`id_reserva_hotel`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `promociones`
--
ALTER TABLE `promociones`
  ADD CONSTRAINT `promociones_ibfk_1` FOREIGN KEY (`id_paquete_gratis`) REFERENCES `paquetes` (`id`);

--
-- Filtros para la tabla `reserva`
--
ALTER TABLE `reserva`
  ADD CONSTRAINT `reserva_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `reserva_ibfk_2` FOREIGN KEY (`id_paquete`) REFERENCES `paquetes` (`id`);

--
-- Filtros para la tabla `reserva_hotel`
--
ALTER TABLE `reserva_hotel`
  ADD CONSTRAINT `fk_reserva_hotel` FOREIGN KEY (`id_hotel`) REFERENCES `hotel` (`id_hotel`),
  ADD CONSTRAINT `fk_reserva_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
