create database LaptopAsus



-- Users table
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Password NVARCHAR(100) NOT NULL, -- Should be hashed on Java side
    FullName NVARCHAR(100),
    Address NVARCHAR(200),
    Phone NVARCHAR(20),
    Role NVARCHAR(20) DEFAULT 'user' 
);
GO

-- Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    Price DECIMAL(10, 2) NOT NULL, -- USD
    Stock INT NOT NULL,
    ImageUrl NVARCHAR(200),
    Brand NVARCHAR(50),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(12, 2) NOT NULL, -- USD
    Status NVARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

-- OrderDetails table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL, -- USD
    TotalPrice AS (Quantity * UnitPrice) PERSISTED,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Cart table
CREATE TABLE [Cart] (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO
-- Insert Asus laptops with price in USD (converted from triệu VND)
INSERT INTO Products (ProductName, Description, Price, Stock, ImageUrl, Brand, CreatedAt) VALUES
('Asus Vivobook S 16 OLED S5606MA Ultra 5 125H (MX050W)', 
 '16\" 3.2K OLED 120Hz, Ultra 5 125H 1.2GHz, 16GB RAM, 512GB SSD, Intel Arc Graphics, Aluminum body, 1.5kg', 
 950.49, 900, 'images/asus_vivobook_s16_mx050w.jpg', 'Asus', GETDATE()),
('Asus TUF Gaming A15 FA507NUR R7 7435HS (LP057W)', 
 '15.6\" FHD 144Hz, Ryzen 7 7435HS 3.1GHz, 16GB RAM, 512GB SSD, RTX 4050 6GB, Plastic body, 2.2kg', 
 962.19, 700, 'images/asus_tuf_a15_lp057w.jpg', 'Asus', GETDATE()),
('Asus Vivobook 15 X1504ZA i3 1215U (NJ102W)', 
 '15.6\" FHD, i3 1215U 1.2GHz, 8GB RAM, 512GB SSD, Intel UHD, Plastic body, 1.7kg', 
 420.12, 9500, 'images/asus_vivobook_15_nj102w.jpg', 'Asus', GETDATE()),
('Asus Vivobook 15 X1504ZA i5 1235U (NJ1608W)', 
 '15.6\" FHD, i5 1235U 1.3GHz, 16GB RAM, 512GB SSD, Intel Iris Xe, Plastic body, 1.7kg', 
 577.01, 2000, 'images/asus_vivobook_15_nj1608w.jpg', 'Asus', GETDATE()),
('Asus Vivobook 15 X1504ZA i5 1235U (NJ1546W)', 
 '15.6\" FHD, i5 1235U 1.3GHz, 16GB RAM, 512GB SSD, Intel Iris Xe, Plastic body, 1.7kg', 
 557.45, 1500, 'images/asus_vivobook_15_nj1546w.jpg', 'Asus', GETDATE()),
('Asus Vivobook 15 OLED A1505VA i5 13500H (MA467W)', 
 '15.6\" 2.8K OLED 120Hz, i5 13500H 2.6GHz, 16GB RAM, 512GB SSD, Intel Iris Xe, Plastic body, 1.7kg', 
 687.47, 800, 'images/asus_vivobook_15_ma467w.jpg', 'Asus', GETDATE()),
('Asus Zenbook 14 OLED UX3402VA i5 13500H (KM657W)', 
 '14\" 2.8K OLED 90Hz, i5 13500H 2.6GHz, 16GB RAM, 512GB SSD, Intel Iris Xe, Aluminum body, 1.39kg', 
 911.79, 900, 'images/asus_zenbook_14_km657w.jpg', 'Asus', GETDATE()),
('Asus Vivobook 15 OLED A1505VA i5 13500H (L1341W)', 
 '15.6\" FHD OLED, i5 13500H 2.6GHz, 16GB RAM, 512GB SSD, Intel Iris Xe, Plastic body, 1.7kg', 
 694.86, 3500, 'images/asus_vivobook_15_l1341w.jpg', 'Asus', GETDATE()),
('Asus TUF Gaming F15 FX507ZC4 i7 12700H (HNi7MW)', 
 '15.6\" FHD 144Hz, i7 12700H 2.3GHz, 16GB RAM, 512GB SSD, RTX 3050 4GB, Plastic with metal lid, 2.2kg', 
 890.62, 200, 'images/asus_tuf_f15_hni7mw.jpg', 'Asus', GETDATE()),
('Asus TUF Gaming F15 FX507VU i7 13620H (LP186W)', 
 '15.6\" FHD 144Hz, i7 13620H 2.4GHz, 16GB RAM, 512GB SSD, RTX 4050 6GB, Plastic with metal lid, 2.2kg', 
 1067.51, 400, 'images/asus_tuf_f15_lp186w.jpg', 'Asus', GETDATE()),
('Asus Vivobook 16 A1607CA Ultra 5 225H (MB038WS)', 
 '16\" WUXGA, Ultra 5 225H 1.7GHz, 16GB RAM, 512GB SSD, Intel Graphics, Plastic body, 1.88kg', 
 804.33, 100, 'images/asus_vivobook_16_mb038ws.jpg', 'Asus', GETDATE()),
('Asus Vivobook 15 OLED A1505VA i9 13900H (MA586WS)', 
 '15.6\" 2.8K OLED 120Hz, i9 13900H 2.6GHz, 16GB RAM, 512GB SSD, Intel Iris Xe, Plastic body, 1.7kg', 
 890.62, 350, 'images/asus_vivobook_15_ma586ws.jpg', 'Asus', GETDATE()),
('Asus ROG Strix G16 G614JU i7 13650HX (N3509W)', 
 '16\" FHD+ 165Hz, i7 13650HX 2.6GHz, 32GB RAM, 1TB SSD, RTX 4050 6GB, Plastic with metal lid, 2.5kg', 
 1386.99, 100, 'images/asus_rog_strix_g16_n3509w.jpg', 'Asus', GETDATE()),
('Asus Zenbook 14 OLED UX3405MA Ultra 5 125H', 
 '14\" 2.8K OLED 120Hz, Ultra 5 125H 1.2GHz, 16GB RAM, 512GB SSD, Intel Arc Graphics, Aluminum body, 1.2kg', 
 1048.04, 1100, 'images/asus_zenbook_14_ux3405ma.jpg', 'Asus', GETDATE()),
('Asus Vivobook S16 S3607VA i5 13420H (RP055WS)', 
 '16\" WUXGA 144Hz, i5 13420H 2.1GHz, 16GB RAM, 512GB SSD, Intel UHD, Aluminum body, 1.8kg', 
 745.86, 50, 'images/asus_vivobook_s16_rp055ws.jpg', 'Asus', GETDATE()),
('Asus TUF Gaming F15 FX507VV i7 13620H (LP151W)', 
 '15.6\" FHD 144Hz, i7 13620H 2.4GHz, 16GB RAM, 512GB SSD, RTX 4060 8GB, Plastic with metal lid, 2.2kg', 
 1146.54, 500, 'images/asus_tuf_f15_lp151w.jpg', 'Asus', GETDATE()),
('Asus TUF Gaming A15 FA506NCR R7 7435HS (HN097W)', 
 '15.6\" FHD 144Hz, Ryzen 7 7435HS 3.1GHz, 16GB RAM, 512GB SSD, RTX 3050 4GB, Plastic body, 2.3kg', 
 792.91, 500, 'images/asus_tuf_a15_hn097w.jpg', 'Asus', GETDATE()),
('Asus Zenbook 14 OLED UM3406KA R7 AI 350 (PP555WS)', 
 '14\" 2.8K OLED 120Hz, Ryzen AI 7 350 2GHz, 32GB RAM, 512GB SSD, Radeon, Aluminum body, 1.2kg', 
 1138.19, 70, 'images/asus_zenbook_14_pp555ws.jpg', 'Asus', GETDATE()),
('Asus Vivobook 15 X1502VA i7 13620H (BQ986WS)', 
 '15.6\" FHD, i7 13620H 2.4GHz, 16GB RAM, 512GB SSD, Intel UHD, Plastic body, 1.7kg', 
 687.47, 20, 'images/asus_vivobook_15_bq986ws.jpg', 'Asus', GETDATE()),
('Asus Gaming Vivobook K3605ZU i5 12500H (RP296W)', 
 '16\" WUXGA 144Hz, i5 12500H 2.5GHz, 16GB RAM, 512GB SSD, RTX 4050 6GB, Plastic body, 1.8kg', 
 879.45, 400, 'images/asus_vivobook_k3605zu_rp296w.jpg', 'Asus', GETDATE());

 -- Insert sample users into Users table
INSERT INTO Users (Username, Email, Password, FullName, Address, Phone, Role) VALUES
('nguyenminh', 'nguyenminh@example.com', 'Pass1234', 'Nguyen Van Minh', '123 Le Loi, District 1, Ho Chi Minh City', '+84912345678', 'user'),
('trangle', 'trangle@example.com', 'Secure567', 'Tran Thi Le', '456 Tran Hung Dao, District 5, Ho Chi Minh City', '+84987654321', 'user'),
('phamhung', 'phamhung@example.com', 'Hung8901', 'Pham Quoc Hung', '789 Nguyen Trai, District 7, Ho Chi Minh City', '+84934567890', 'user'),
('adminhieu', 'adminhieu@example.com', 'Admin2025', 'Le Quang Hieu', '101 Vo Van Tan, District 3, Ho Chi Minh City', '+84956789012', 'admin'),
('hoanganh', 'hoanganh@example.com', 'Anh3456', 'Hoang Thi Anh', '234 Hai Ba Trung, Da Nang', '+84967890123', 'user');

  select*from Users

  
  IF NOT EXISTS (
    SELECT * 
    FROM sys.tables 
    WHERE name = 'OrderInfo'
)
BEGIN
    CREATE TABLE OrderInfo (
        OrderID          INT            NOT NULL PRIMARY KEY
            CONSTRAINT FK_OrderInfo_Orders
            REFERENCES Orders(OrderID)
            ON UPDATE CASCADE
            ON DELETE CASCADE,
        ShippingName     NVARCHAR(100)  NOT NULL,
        ShippingAddress  NVARCHAR(255)  NOT NULL,
        Phone            NVARCHAR(20)   NOT NULL,
        PaymentMethod    NVARCHAR(50)   NOT NULL,
        CreatedAt        DATETIME       NOT NULL
            CONSTRAINT DF_OrderInfo_CreatedAt DEFAULT GETDATE()
    );
END
GO

select*from Orders

CREATE TABLE contact_messages (
    id          INT           IDENTITY(1,1) PRIMARY KEY,
    name        NVARCHAR(100) NOT NULL,
    email       NVARCHAR(100) NOT NULL,
    phone       NVARCHAR(20)  NULL,
    message     NVARCHAR(MAX) NOT NULL,
    created_at  DATETIME      NOT NULL CONSTRAINT DF_contact_messages_created_at DEFAULT GETDATE()
);
ALTER TABLE contact_messages
  ADD reply      NVARCHAR(MAX)    NULL,
      reply_at   DATETIME         NULL;

select*from contact_messages