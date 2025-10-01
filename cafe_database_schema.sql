-- =============================================
-- CAFE APP DATABASE SCHEMA
-- =============================================
-- Tạo database cho ứng dụng quản lý cafe
-- Dựa trên cấu trúc dữ liệu từ Flutter project

-- Tạo database
CREATE DATABASE IF NOT EXISTS cafe_app;
USE cafe_app;

-- =============================================
-- BẢNG NGƯỜI DÙNG (USERS)
-- =============================================
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user', 'guest') NOT NULL DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- BẢNG DANH MỤC SẢN PHẨM (CATEGORIES)
-- =============================================
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- BẢNG SẢN PHẨM (PRODUCTS)
-- =============================================
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    base_price DECIMAL(10,2) NOT NULL,
    image_path VARCHAR(500),
    category_id INT,
    has_size BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- =============================================
-- BẢNG GIÁ THEO SIZE (PRODUCT_SIZES)
-- =============================================
CREATE TABLE product_sizes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    size_name VARCHAR(10) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_product_size (product_id, size_name)
);

-- =============================================
-- BẢNG ĐƠN HÀNG (ORDERS)
-- =============================================
CREATE TABLE orders (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT,
    customer_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    payment_method ENUM('cash', 'card', 'other') NOT NULL,
    status ENUM('pending', 'confirmed', 'completed') DEFAULT 'pending',
    total_amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- =============================================
-- BẢNG CHI TIẾT ĐƠN HÀNG (ORDER_ITEMS)
-- =============================================
CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id VARCHAR(50) NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    selected_size VARCHAR(10),
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- =============================================
-- BẢNG GIỎ HÀNG (CART_ITEMS) - Tạm thời
-- =============================================
CREATE TABLE cart_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    session_id VARCHAR(100), -- Cho guest users
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    selected_size VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product_size (user_id, product_id, selected_size),
    UNIQUE KEY unique_session_product_size (session_id, product_id, selected_size)
);

-- =============================================
-- INSERT DỮ LIỆU MẪU
-- =============================================

-- Thêm admin user
INSERT INTO users (email, password, role) VALUES 
('admin', 'admin', 'admin');

-- Thêm danh mục
INSERT INTO categories (name, description) VALUES 
('Cafe', 'Các loại cà phê'),
('Trà sữa', 'Các loại trà sữa'),
('Đồ ăn ngọt', 'Bánh ngọt, đồ ăn ngọt'),
('Đồ ăn mặn', 'Đồ ăn mặn, xúc xích'),
('Matcha', 'Các loại đồ uống matcha');

-- Thêm sản phẩm
INSERT INTO products (name, description, base_price, image_path, category_id, has_size) VALUES 
('Cà phê đen', 'Cà phê đen truyền thống, đậm đà và thơm ngon', 25000, 'assets/img/Ca-Phe-Den-scaled.jpg', 1, TRUE),
('Cà phê sữa', 'Cà phê sữa ngọt ngào, kết hợp hoàn hảo', 30000, 'assets/img/ca_phe_sua.png', 1, TRUE),
('Trà sữa trân châu', 'Trà sữa thơm ngon với trân châu dai dai', 35000, 'assets/img/Tra_sua.jpg', 2, TRUE),
('Bánh mì sandwich', 'Bánh mì sandwich tươi ngon với thịt nguội', 40000, 'assets/img/banh-mi-thit-sai-gon.jpg', 3, FALSE),
('Bánh ngọt', 'Bánh ngọt tươi ngon, nguyên liệu cao cấp', 20000, 'assets/img/banh-ngot-1.jpeg', 3, FALSE),
('Xúc xích', 'Xúc xích tươi ngon, nguyên liệu cao cấp', 20000, 'assets/img/xuc_xich.jpg', 4, FALSE),
('Matcha', 'Matcha ngọt ngào, kết hợp hoàn hảo', 20000, 'assets/img/Matcha.jpg', 5, TRUE);

-- Thêm giá theo size
INSERT INTO product_sizes (product_id, size_name, price) VALUES 
-- Cà phê đen
(1, 'S', 25000),
(1, 'M', 30000),
(1, 'L', 35000),
-- Cà phê sữa
(2, 'S', 30000),
(2, 'M', 35000),
(2, 'L', 40000),
-- Trà sữa trân châu
(3, 'S', 35000),
(3, 'M', 40000),
(3, 'L', 45000),
-- Matcha
(7, 'S', 20000),
(7, 'M', 25000),
(7, 'L', 30000);

-- =============================================
-- TẠO INDEXES ĐỂ TỐI ƯU HIỆU SUẤT
-- =============================================
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_is_active ON products(is_active);
CREATE INDEX idx_cart_items_user_id ON cart_items(user_id);
CREATE INDEX idx_cart_items_session_id ON cart_items(session_id);

-- =============================================
-- TẠO VIEWS ĐỂ DỄ DÀNG TRUY VẤN
-- =============================================

-- View đơn hàng chi tiết
CREATE VIEW order_details AS
SELECT 
    o.id as order_id,
    o.customer_name,
    o.phone,
    o.address,
    o.payment_method,
    o.status,
    o.total_amount,
    o.created_at,
    u.email as user_email,
    u.role as user_role
FROM orders o
LEFT JOIN users u ON o.user_id = u.id;

-- View sản phẩm với giá size
CREATE VIEW product_with_sizes AS
SELECT 
    p.id,
    p.name,
    p.description,
    p.base_price,
    p.image_path,
    c.name as category_name,
    p.has_size,
    p.is_active,
    GROUP_CONCAT(
        CONCAT(ps.size_name, ':', ps.price) 
        ORDER BY ps.size_name 
        SEPARATOR ','
    ) as size_prices
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
LEFT JOIN product_sizes ps ON p.id = ps.product_id
GROUP BY p.id, p.name, p.description, p.base_price, p.image_path, c.name, p.has_size, p.is_active;

-- View thống kê đơn hàng
CREATE VIEW order_statistics AS
SELECT 
    DATE(created_at) as order_date,
    COUNT(*) as total_orders,
    SUM(total_amount) as total_revenue,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_orders,
    COUNT(CASE WHEN status = 'confirmed' THEN 1 END) as confirmed_orders,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_orders
FROM orders
GROUP BY DATE(created_at)
ORDER BY order_date DESC;

-- =============================================
-- STORED PROCEDURES
-- =============================================

-- Procedure tạo đơn hàng mới
DELIMITER //
CREATE PROCEDURE CreateOrder(
    IN p_user_id INT,
    IN p_customer_name VARCHAR(255),
    IN p_phone VARCHAR(20),
    IN p_address TEXT,
    IN p_payment_method ENUM('cash', 'card', 'other')
)
BEGIN
    DECLARE v_order_id VARCHAR(50);
    DECLARE v_total_amount DECIMAL(10,2) DEFAULT 0;
    
    -- Tạo order ID
    SET v_order_id = CONCAT('ORD', UNIX_TIMESTAMP(), FLOOR(RAND() * 1000));
    
    -- Tính tổng tiền từ giỏ hàng
    SELECT COALESCE(SUM(ci.quantity * COALESCE(ps.price, p.base_price)), 0)
    INTO v_total_amount
    FROM cart_items ci
    JOIN products p ON ci.product_id = p.id
    LEFT JOIN product_sizes ps ON p.id = ps.product_id AND ps.size_name = ci.selected_size
    WHERE ci.user_id = p_user_id OR ci.session_id = CONCAT('session_', p_user_id);
    
    -- Tạo đơn hàng
    INSERT INTO orders (id, user_id, customer_name, phone, address, payment_method, total_amount)
    VALUES (v_order_id, p_user_id, p_customer_name, p_phone, p_address, p_payment_method, v_total_amount);
    
    -- Chuyển items từ cart sang order_items
    INSERT INTO order_items (order_id, product_id, quantity, selected_size, unit_price, total_price)
    SELECT 
        v_order_id,
        ci.product_id,
        ci.quantity,
        ci.selected_size,
        COALESCE(ps.price, p.base_price),
        ci.quantity * COALESCE(ps.price, p.base_price)
    FROM cart_items ci
    JOIN products p ON ci.product_id = p.id
    LEFT JOIN product_sizes ps ON p.id = ps.product_id AND ps.size_name = ci.selected_size
    WHERE ci.user_id = p_user_id OR ci.session_id = CONCAT('session_', p_user_id);
    
    -- Xóa giỏ hàng
    DELETE FROM cart_items 
    WHERE user_id = p_user_id OR session_id = CONCAT('session_', p_user_id);
    
    SELECT v_order_id as order_id;
END //
DELIMITER ;

-- =============================================
-- TRIGGERS
-- =============================================

-- Trigger cập nhật total_amount khi thay đổi order_items
DELIMITER //
CREATE TRIGGER update_order_total
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders 
    SET total_amount = (
        SELECT SUM(total_price) 
        FROM order_items 
        WHERE order_id = NEW.order_id
    )
    WHERE id = NEW.order_id;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_order_total_update
AFTER UPDATE ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders 
    SET total_amount = (
        SELECT SUM(total_price) 
        FROM order_items 
        WHERE order_id = NEW.order_id
    )
    WHERE id = NEW.order_id;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_order_total_delete
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders 
    SET total_amount = (
        SELECT COALESCE(SUM(total_price), 0) 
        FROM order_items 
        WHERE order_id = OLD.order_id
    )
    WHERE id = OLD.order_id;
END //
DELIMITER ;

-- =============================================
-- QUERIES MẪU
-- =============================================

-- Lấy tất cả đơn hàng với thông tin chi tiết
-- SELECT 
--     o.id,
--     o.customer_name,
--     o.phone,
--     o.status,
--     o.total_amount,
--     o.created_at,
--     COUNT(oi.id) as item_count
-- FROM orders o
-- LEFT JOIN order_items oi ON o.id = oi.order_id
-- GROUP BY o.id
-- ORDER BY o.created_at DESC;

-- Lấy sản phẩm bán chạy nhất
-- SELECT 
--     p.name,
--     SUM(oi.quantity) as total_sold,
--     SUM(oi.total_price) as total_revenue
-- FROM products p
-- JOIN order_items oi ON p.id = oi.product_id
-- JOIN orders o ON oi.order_id = o.id
-- WHERE o.status = 'completed'
-- GROUP BY p.id, p.name
-- ORDER BY total_sold DESC;

-- Thống kê doanh thu theo ngày
-- SELECT 
--     DATE(created_at) as date,
--     COUNT(*) as orders_count,
--     SUM(total_amount) as revenue
-- FROM orders
-- WHERE status = 'completed'
-- GROUP BY DATE(created_at)
-- ORDER BY date DESC;
