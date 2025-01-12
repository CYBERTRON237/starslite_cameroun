
-- Structure de la table `agence`
--

DROP TABLE IF EXISTS `agence`;
CREATE TABLE IF NOT EXISTS `agence` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `chef_agence` varchar(250) NOT NULL,
  `region` varchar(250) NOT NULL,
  `ville` varchar(250) NOT NULL,
  `adresse` varchar(250) NOT NULL,
  `telephone` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chef_agence` (`chef_agence`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `agence`
--

INSERT INTO `agence` (`id`, `name`, `chef_agence`, `region`, `ville`, `adresse`, `telephone`) VALUES
(1, 'foreke', 'jores', 'Ouest', 'dschang', 'starslite@gmail.com\r\n', '677051765'),
(4, 'foto', 'sylvain', 'Extreme-Nord', 'mata', 'foto@gmail.com', '677051765'),
(5, 'olemebe', 'jores', 'Centre', 'yaounde', 'olemebe@gmail.com', '677051765'),
(6, 'village', 'jores', 'Littoral', 'douala', 'village1douala@gmail.com', '677051765'),
(7, 'foto', 'jores', 'Ouest', 'dschang', 'foto@gmail.com', '677051765');

-- --------------------------------------------------------

--

-- Structure de la table `region`
--

DROP TABLE IF EXISTS `region`;
CREATE TABLE IF NOT EXISTS `region` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `region`
--

INSERT INTO `region` (`id`, `nom`) VALUES
(1, 'Adamaoua'),
(2, 'Centre'),
(3, 'Est'),
(4, 'Littoral'),
(5, 'Nord'),
(6, 'Nord-Ouest'),
(7, 'Ouest'),
(8, 'Sud'),
(9, 'Sud-Ouest'),
(10, 'Extreme-Nord');

-- --------------------------------------------------------

--

-- Structure de la table `type`
--

DROP TABLE IF EXISTS `type`;
CREATE TABLE IF NOT EXISTS `type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(250) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `type`
--

INSERT INTO `type` (`id`, `type`) VALUES
(1, 'caissiere\r\n'),
(2, 'checkier'),
(3, 'bagagiste\r\n'),
(4, 'expediteur\r\n');

-- --------------------------------------------------------

--

-- Structure de la table `ville`
--

DROP TABLE IF EXISTS `ville`;
CREATE TABLE IF NOT EXISTS `ville` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `fichier_admin` varchar(255) DEFAULT NULL,
  `region_id` int NOT NULL,
  `date_creation` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_region_id` (`region_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `ville`
--

INSERT INTO `ville` (`id`, `nom`, `fichier_admin`, `region_id`, `date_creation`) VALUES
(1, 'jerusalem', NULL, 7, '2024-11-05 01:01:35'),
(2, 'dschang', 'admin_dschang.php', 7, '2024-11-05 01:35:37');

--

-- Contraintes pour la table `ville`
--
ALTER TABLE `ville`
  ADD CONSTRAINT `ville_ibfk_1` FOREIGN KEY (`region_id`) REFERENCES `region` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;
-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : dim. 05 jan. 2025 à 13:10
-- Version du serveur : 8.3.0
-- Version de PHP : 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `travel_agency`
--

-- --------------------------------------------------------

--
-- Structure de la table `buses`
--

DROP TABLE IF EXISTS `buses`;
CREATE TABLE IF NOT EXISTS `buses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bus_number` varchar(50) NOT NULL,
  `capacity` int NOT NULL,
  `status` enum('available','unavailable') DEFAULT 'available',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `buses`
--

INSERT INTO `buses` (`id`, `bus_number`, `capacity`, `status`, `created_at`) VALUES
(1, '1', 70, 'available', '2025-01-03 11:21:43');

-- --------------------------------------------------------

--
-- Structure de la table `chauffeur`
--

DROP TABLE IF EXISTS `chauffeur`;
CREATE TABLE IF NOT EXISTS `chauffeur` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `number` varchar(250) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `chauffeur`
--

INSERT INTO `chauffeur` (`id`, `name`, `email`, `created_at`, `number`) VALUES
(1, 'joress', 'tsamo6jores@gmail.com', '2025-01-03 11:26:31', '67051765');

-- --------------------------------------------------------

--
-- Structure de la table `client`
--

DROP TABLE IF EXISTS `client`;
CREATE TABLE IF NOT EXISTS `client` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `number` varchar(250) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`name`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `client`
--

INSERT INTO `client` (`id`, `name`, `email`, `role`, `created_at`, `number`) VALUES
(1, 'goodness', 'goodness@gmail.com', 'user', '2025-01-03 11:22:52', '12345');

-- --------------------------------------------------------

--
-- Structure de la table `payments`
--

DROP TABLE IF EXISTS `payments`;
CREATE TABLE IF NOT EXISTS `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `client_id` int NOT NULL,
  `reservation_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `payment_method` enum('credit_card','paypal','bank_transfer','other') NOT NULL,
  `status` enum('pending','completed','failed','refunded') DEFAULT 'pending',
  `transaction_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reservation_id` (`reservation_id`),
  KEY `client_id` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `payments`
--

INSERT INTO `payments` (`id`, `client_id`, `reservation_id`, `amount`, `payment_date`, `payment_method`, `status`, `transaction_id`) VALUES
(1, 1, 1, 5000.00, '2025-01-03 10:25:10', 'credit_card', 'pending', NULL),
(2, 1, 1, 6000.00, '2025-01-04 16:25:50', 'credit_card', 'pending', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `places`
--

DROP TABLE IF EXISTS `places`;
CREATE TABLE IF NOT EXISTS `places` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bus_id` int NOT NULL,
  `place_number` int NOT NULL,
  `status` enum('available','reserved') DEFAULT 'available',
  PRIMARY KEY (`id`),
  KEY `bus_id` (`bus_id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `places`
--

INSERT INTO `places` (`id`, `bus_id`, `place_number`, `status`) VALUES
(1, 1, 1, 'reserved'),
(2, 1, 2, 'available'),
(3, 1, 3, 'available'),
(4, 1, 4, 'available'),
(5, 1, 5, 'available'),
(6, 1, 6, 'available'),
(7, 1, 7, 'available'),
(8, 1, 8, 'available'),
(9, 1, 9, 'available'),
(10, 1, 10, 'available'),
(11, 1, 11, 'available'),
(12, 1, 12, 'available'),
(13, 1, 13, 'available'),
(14, 1, 14, 'available'),
(15, 1, 15, 'available'),
(16, 1, 16, 'available'),
(17, 1, 17, 'available'),
(18, 1, 18, 'available'),
(19, 1, 19, 'available'),
(20, 1, 20, 'available'),
(21, 1, 21, 'available'),
(22, 1, 22, 'available'),
(23, 1, 23, 'available'),
(24, 1, 24, 'available'),
(25, 1, 25, 'reserved'),
(26, 1, 26, 'reserved'),
(27, 1, 27, 'available'),
(28, 1, 28, 'available'),
(29, 1, 29, 'available'),
(30, 1, 30, 'available'),
(31, 1, 31, 'available'),
(32, 1, 32, 'available'),
(33, 1, 33, 'available'),
(34, 1, 34, 'available'),
(35, 1, 35, 'available'),
(36, 1, 36, 'available'),
(37, 1, 37, 'available'),
(38, 1, 38, 'available'),
(39, 1, 39, 'available'),
(40, 1, 40, 'available'),
(41, 1, 41, 'available'),
(42, 1, 42, 'available'),
(43, 1, 43, 'available'),
(44, 1, 44, 'available'),
(45, 1, 45, 'available'),
(46, 1, 46, 'available'),
(47, 1, 47, 'available'),
(48, 1, 48, 'available'),
(49, 1, 49, 'available'),
(50, 1, 50, 'available'),
(51, 1, 51, 'available'),
(52, 1, 52, 'available'),
(53, 1, 53, 'available'),
(54, 1, 54, 'available'),
(55, 1, 55, 'available'),
(56, 1, 56, 'available'),
(57, 1, 57, 'available'),
(58, 1, 58, 'available'),
(59, 1, 59, 'available'),
(60, 1, 60, 'available'),
(61, 1, 61, 'available'),
(62, 1, 62, 'available'),
(63, 1, 63, 'available'),
(64, 1, 64, 'available'),
(65, 1, 65, 'available'),
(66, 1, 66, 'available'),
(67, 1, 67, 'available'),
(68, 1, 68, 'available'),
(69, 1, 69, 'available'),
(70, 1, 70, 'available');

-- --------------------------------------------------------

--
-- Structure de la table `reservations`
--

DROP TABLE IF EXISTS `reservations`;
CREATE TABLE IF NOT EXISTS `reservations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `client_id` int NOT NULL,
  `bus_id` int NOT NULL,
  `place_id` int NOT NULL,
  `reservation_date` datetime NOT NULL,
  `route_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_reservation` (`bus_id`,`place_id`,`reservation_date`),
  KEY `client_id` (`client_id`),
  KEY `bus_id` (`bus_id`),
  KEY `place_id` (`place_id`),
  KEY `fk_route` (`route_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `reservations`
--

INSERT INTO `reservations` (`id`, `client_id`, `bus_id`, `place_id`, `reservation_date`, `route_id`) VALUES
(1, 1, 1, 1, '2025-01-03 00:00:00', 2),
(2, 1, 1, 25, '2025-01-04 00:00:00', 2),
(3, 1, 1, 26, '2025-01-04 00:00:00', 2);

-- --------------------------------------------------------

--
-- Structure de la table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
CREATE TABLE IF NOT EXISTS `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `client_id` int NOT NULL,
  `route_id` int NOT NULL,
  `review_text` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`),
  KEY `route_id` (`route_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `reviews`
--

INSERT INTO `reviews` (`id`, `client_id`, `route_id`, `review_text`, `created_at`) VALUES
(1, 1, 2, 'impressionant ', '2025-01-03 10:25:57');

-- --------------------------------------------------------

--
-- Structure de la table `routes`
--

DROP TABLE IF EXISTS `routes`;
CREATE TABLE IF NOT EXISTS `routes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `origin` varchar(250) NOT NULL,
  `destination` varchar(250) NOT NULL,
  `duration` time NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `prix` varchar(250) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_origin_destination` (`origin`,`destination`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `routes`
--

INSERT INTO `routes` (`id`, `origin`, `destination`, `duration`, `price`, `created_at`, `prix`) VALUES
(2, 'dschang', 'yaounde', '05:47:00', 0.00, '0000-00-00 00:00:00', '5000'),
(3, 'dschang', 'douala', '04:00:00', 0.00, '2024-10-28 07:15:41', '5000');

-- --------------------------------------------------------

--
-- Structure de la table `voyage`
--

DROP TABLE IF EXISTS `voyage`;
CREATE TABLE IF NOT EXISTS `voyage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bus_number` int NOT NULL,
  `chauffeur_id` int NOT NULL,
  `departure_time` datetime NOT NULL,
  `arrival_time` datetime NOT NULL,
  `duration` time NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `capacity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bus_number` (`bus_number`),
  KEY `chauffeur_id` (`chauffeur_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `voyage`
--

INSERT INTO `voyage` (`id`, `bus_number`, `chauffeur_id`, `departure_time`, `arrival_time`, `duration`, `price`, `capacity`) VALUES
(1, 1, 1, '2025-01-03 11:26:00', '2025-01-03 15:27:00', '11:27:00', 5000.00, 70);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `places`
--
ALTER TABLE `places`
  ADD CONSTRAINT `places_ibfk_1` FOREIGN KEY (`bus_id`) REFERENCES `buses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `fk_route` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`bus_id`) REFERENCES `buses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_3` FOREIGN KEY (`place_id`) REFERENCES `places` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `voyage`
--
ALTER TABLE `voyage`
  ADD CONSTRAINT `voyage_ibfk_1` FOREIGN KEY (`bus_number`) REFERENCES `buses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `voyage_ibfk_2` FOREIGN KEY (`chauffeur_id`) REFERENCES `chauffeur` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


-- Structure de la table `userss`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role` enum('super_admin','admin','DG','chef_ville','chef_agence','user') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `region` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ville` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `agency_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `number` (`number`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
