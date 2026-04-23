-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.32-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.16.0.7229
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for quanlythuvien
DROP DATABASE IF EXISTS `quanlythuvien`;
CREATE DATABASE IF NOT EXISTS `quanlythuvien` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `quanlythuvien`;

-- Dumping structure for table quanlythuvien.authors
DROP TABLE IF EXISTS `authors`;
CREATE TABLE IF NOT EXISTS `authors` (
  `author_id` int(11) NOT NULL AUTO_INCREMENT,
  `full_name` varchar(200) NOT NULL,
  `position` varchar(150) DEFAULT NULL,
  `workplace` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`author_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table quanlythuvien.authors: ~3 rows (approximately)
REPLACE INTO `authors` (`author_id`, `full_name`, `position`, `workplace`) VALUES
	(1, 'Nguyen Van A', 'Giang vien', 'Dai hoc Bach Khoa'),
	(2, 'Tran Thi B', 'Tac gia', 'Hoi nha van Viet Nam'),
	(3, 'Le Van C', 'Chuyen gia', 'Cong ty phan mem ABC');

-- Dumping structure for table quanlythuvien.book_authors
DROP TABLE IF EXISTS `book_authors`;
CREATE TABLE IF NOT EXISTS `book_authors` (
  `book_code` int(11) NOT NULL,
  `author_id` int(11) NOT NULL,
  PRIMARY KEY (`book_code`,`author_id`),
  KEY `fk_book_authors_author` (`author_id`),
  CONSTRAINT `fk_book_authors_author` FOREIGN KEY (`author_id`) REFERENCES `authors` (`author_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_book_authors_book` FOREIGN KEY (`book_code`) REFERENCES `books` (`bookcode`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table quanlythuvien.book_authors: ~3 rows (approximately)
REPLACE INTO `book_authors` (`book_code`, `author_id`) VALUES
	(1, 1),
	(2, 3),
	(3, 2);

-- Dumping structure for table quanlythuvien.book_imports
DROP TABLE IF EXISTS `book_imports`;
CREATE TABLE IF NOT EXISTS `book_imports` (
  `import_id` int(11) NOT NULL AUTO_INCREMENT,
  `book_code` int(11) NOT NULL,
  `import_quantity` int(11) NOT NULL,
  `import_date` datetime NOT NULL,
  `imported_by` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`import_id`),
  KEY `fk_import_book` (`book_code`),
  CONSTRAINT `fk_import_book` FOREIGN KEY (`book_code`) REFERENCES `books` (`bookcode`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table quanlythuvien.book_imports: ~3 rows (approximately)
REPLACE INTO `book_imports` (`import_id`, `book_code`, `import_quantity`, `import_date`, `imported_by`) VALUES
	(1, 1, 5, '2026-04-16 16:48:27', 'admin'),
	(2, 2, 4, '2026-04-16 16:48:27', 'admin'),
	(3, 3, 3, '2026-04-16 16:48:27', 'admin');

-- Dumping structure for table quanlythuvien.books
DROP TABLE IF EXISTS `books`;
CREATE TABLE IF NOT EXISTS `books` (
  `bookcode` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `author` varchar(255) DEFAULT NULL,
  `category_code` int(11) DEFAULT NULL,
  `publisher` varchar(200) DEFAULT NULL,
  `publisher_id` int(11) DEFAULT NULL,
  `publish_year` varchar(10) DEFAULT NULL,
  `price` decimal(12,2) DEFAULT 0.00,
  `page_count` int(11) DEFAULT 0,
  `shelf_location` varchar(100) DEFAULT NULL,
  `quantity` int(11) DEFAULT 0,
  `total_imported` int(11) DEFAULT 0,
  `image` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`bookcode`),
  KEY `fk_books_category` (`category_code`),
  KEY `fk_books_publisher` (`publisher_id`),
  CONSTRAINT `fk_books_category` FOREIGN KEY (`category_code`) REFERENCES `categories` (`categorycode`),
  CONSTRAINT `fk_books_publisher` FOREIGN KEY (`publisher_id`) REFERENCES `publishers` (`publisher_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table quanlythuvien.books: ~3 rows (approximately)
REPLACE INTO `books` (`bookcode`, `title`, `author`, `category_code`, `publisher`, `publisher_id`, `publish_year`, `price`, `page_count`, `shelf_location`, `quantity`, `total_imported`, `image`, `is_active`) VALUES
	(1, 'Lập trình Java cơ bản', 'Nguyen Van A', 1, 'NXB Giáo dục', 1, '2024', 120000.00, 350, 'Kệ A1', 5, 5, '', 1),
	(2, 'Cơ sở dữ liệu MySQL', 'Lê Văn Luyện', 1, 'NXB Trẻ', 2, '2023', 95000.00, 280, 'Kệ A2', 4, 4, '', 1),
	(3, 'Tuổi trẻ đáng giá bao nhiêu', 'Trần Văn Khoai', 5, 'NXB Kim Đồng', 3, '2022', 80000.00, 220, 'Kệ B1', 3, 3, '', 1);

-- Dumping structure for table quanlythuvien.borrowings
DROP TABLE IF EXISTS `borrowings`;
CREATE TABLE IF NOT EXISTS `borrowings` (
  `borrowingcode` int(11) NOT NULL AUTO_INCREMENT,
  `user_code` int(11) NOT NULL,
  `book_bookcode` int(11) NOT NULL,
  `borrow_date` date NOT NULL,
  `due_date` date NOT NULL,
  `return_date` date DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Chờ duyệt',
  `return_condition` varchar(100) DEFAULT 'Binh thuong',
  PRIMARY KEY (`borrowingcode`),
  KEY `fk_borrow_user` (`user_code`),
  KEY `fk_borrow_book` (`book_bookcode`),
  CONSTRAINT `fk_borrow_book` FOREIGN KEY (`book_bookcode`) REFERENCES `books` (`bookcode`),
  CONSTRAINT `fk_borrow_user` FOREIGN KEY (`user_code`) REFERENCES `users` (`usercode`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table quanlythuvien.borrowings: ~1 rows (approximately)
REPLACE INTO `borrowings` (`borrowingcode`, `user_code`, `book_bookcode`, `borrow_date`, `due_date`, `return_date`, `status`, `return_condition`) VALUES
	(1, 3, 1, '2026-04-16', '2026-04-30', NULL, 'Chờ duyệt', 'Binh thuong');

-- Dumping structure for table quanlythuvien.categories
DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `categorycode` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`categorycode`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table quanlythuvien.categories: ~5 rows (approximately)
REPLACE INTO `categories` (`categorycode`, `name`) VALUES
	(1, 'Công nghệ thông tin'),
	(2, 'Văn học'),
	(3, 'Kinh tế'),
	(4, 'Khoa học'),
	(5, 'Kỹ năng sống');

-- Dumping structure for table quanlythuvien.messages
DROP TABLE IF EXISTS `messages`;
CREATE TABLE IF NOT EXISTS `messages` (
  `message_id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_usercode` int(11) DEFAULT NULL,
  `receiver_usercode` int(11) DEFAULT NULL,
  `sender_role` varchar(30) DEFAULT NULL,
  `content` text NOT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`message_id`),
  KEY `fk_message_sender` (`sender_usercode`),
  KEY `fk_message_receiver` (`receiver_usercode`),
  CONSTRAINT `fk_message_receiver` FOREIGN KEY (`receiver_usercode`) REFERENCES `users` (`usercode`),
  CONSTRAINT `fk_message_sender` FOREIGN KEY (`sender_usercode`) REFERENCES `users` (`usercode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table quanlythuvien.messages: ~0 rows (approximately)

-- Dumping structure for table quanlythuvien.penalties
DROP TABLE IF EXISTS `penalties`;
CREATE TABLE IF NOT EXISTS `penalties` (
  `penaltiecode` int(11) NOT NULL AUTO_INCREMENT,
  `user_code` int(11) NOT NULL,
  `borrowing_code` int(11) DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `reason` varchar(255) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Chua thanh toan',
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`penaltiecode`),
  KEY `fk_penalty_user` (`user_code`),
  KEY `fk_penalty_borrowing` (`borrowing_code`),
  CONSTRAINT `fk_penalty_borrowing` FOREIGN KEY (`borrowing_code`) REFERENCES `borrowings` (`borrowingcode`),
  CONSTRAINT `fk_penalty_user` FOREIGN KEY (`user_code`) REFERENCES `users` (`usercode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table quanlythuvien.penalties: ~0 rows (approximately)

-- Dumping structure for table quanlythuvien.publishers
DROP TABLE IF EXISTS `publishers`;
CREATE TABLE IF NOT EXISTS `publishers` (
  `publisher_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `founded_date` date DEFAULT NULL,
  PRIMARY KEY (`publisher_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table quanlythuvien.publishers: ~3 rows (approximately)
REPLACE INTO `publishers` (`publisher_id`, `name`, `address`, `founded_date`) VALUES
	(1, 'NXB Giao Duc', 'Ha Noi', '1957-06-01'),
	(2, 'NXB Tre', 'TP Ho Chi Minh', '1981-03-24'),
	(3, 'NXB Kim Dong', 'Ha Noi', '1957-06-17');

-- Dumping structure for table quanlythuvien.reservations
DROP TABLE IF EXISTS `reservations`;
CREATE TABLE IF NOT EXISTS `reservations` (
  `reservationcode` int(11) NOT NULL AUTO_INCREMENT,
  `user_code` int(11) NOT NULL,
  `book_code` int(11) NOT NULL,
  `reserve_date` date NOT NULL,
  `status` varchar(50) DEFAULT 'Đang chờ',
  `borrow_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `is_notified` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`reservationcode`),
  KEY `fk_reservation_user` (`user_code`),
  KEY `fk_reservation_book` (`book_code`),
  CONSTRAINT `fk_reservation_book` FOREIGN KEY (`book_code`) REFERENCES `books` (`bookcode`),
  CONSTRAINT `fk_reservation_user` FOREIGN KEY (`user_code`) REFERENCES `users` (`usercode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table quanlythuvien.reservations: ~0 rows (approximately)

-- Dumping structure for table quanlythuvien.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `usercode` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `fullname` varchar(200) NOT NULL,
  `role` varchar(30) NOT NULL DEFAULT 'User',
  `birth_date` date DEFAULT NULL,
  `position` varchar(150) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `identity_number` varchar(50) DEFAULT NULL,
  `card_issue_date` date DEFAULT NULL,
  `card_expiry_date` date DEFAULT NULL,
  `deposit_amount` decimal(12,2) DEFAULT 0.00,
  `max_borrow_books` int(11) DEFAULT 5,
  PRIMARY KEY (`usercode`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table quanlythuvien.users: ~3 rows (approximately)
REPLACE INTO `users` (`usercode`, `username`, `password`, `fullname`, `role`, `birth_date`, `position`, `address`, `identity_number`, `card_issue_date`, `card_expiry_date`, `deposit_amount`, `max_borrow_books`) VALUES
	(1, 'admin', '123456@', 'Quan tri vien', 'Admin', '1990-01-01', 'Admin', 'Ha Noi', '000000001', '2026-04-16', '2027-04-16', 0.00, 10),
	(2, 'manager', '123456a', 'Quan Ly', 'Manager', '1992-02-02', 'Thu thu', 'Ha Noi', '000000002', '2026-04-16', '2027-04-16', 0.00, 10),
	(3, 'user', '123456', 'Doc gia mau', 'User', '2000-03-03', 'Sinh vien', 'Ha Noi', '000000003', '2026-04-16', '2027-04-16', 100000.00, 5);

-- Dumping structure for view quanlythuvien.v_borrow_statistics
DROP VIEW IF EXISTS `v_borrow_statistics`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `v_borrow_statistics` (
	`bookcode` INT(11) NOT NULL,
	`title` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`author` VARCHAR(1) NULL COLLATE 'utf8mb4_unicode_ci',
	`publisher` VARCHAR(1) NULL COLLATE 'utf8mb4_unicode_ci',
	`publish_year` VARCHAR(1) NULL COLLATE 'utf8mb4_unicode_ci',
	`category_name` VARCHAR(1) NULL COLLATE 'utf8mb4_unicode_ci',
	`borrow_count` BIGINT(21) NOT NULL
);

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `v_borrow_statistics`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_borrow_statistics` AS SELECT
    b.bookcode,
    b.title,
    b.author,
    b.publisher,
    b.publish_year,
    c.name AS category_name,
    COUNT(br.borrowingcode) AS borrow_count
FROM Books b
LEFT JOIN Categories c ON b.category_code = c.categorycode
LEFT JOIN Borrowings br ON b.bookcode = br.book_bookcode
GROUP BY b.bookcode, b.title, b.author, b.publisher, b.publish_year, c.name
ORDER BY borrow_count DESC, b.title ASC 
;

-- Đồng bộ dữ liệu trạng thái cũ (tiếng Anh) sang tiếng Việt
UPDATE Borrowings SET status = 'Chờ duyệt' WHERE status = 'Pending';
UPDATE Borrowings SET status = 'Đang mượn' WHERE status = 'Borrowing';
UPDATE Borrowings SET status = 'Đã trả' WHERE status = 'Returned';
UPDATE Borrowings SET status = 'Từ chối' WHERE status = 'Rejected';
UPDATE Borrowings SET status = 'Chờ duyệt trả' WHERE status = 'ReturnPending';
UPDATE Borrowings SET status = 'Quá hạn' WHERE status = 'Overdue';
UPDATE Reservations SET status = 'Đang chờ' WHERE status = 'Pending';

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
