
CREATE DATABASE KitleFonlama
USE KitleFonlama
--Kullanýcýlar Tablosu
CREATE TABLE kullanicilar (
	kullaniciID INT IDENTITY(1,1) PRIMARY KEY ,
	kullaniciAD nvarchar(50),
	kullanicimail varchar(50) UNIQUE,
	yas tinyint,
	cinsiyet char(1),
);

--Projeler Tablosu
CREATE TABLE proje (
	projeID INT IDENTITY(1,1) PRIMARY KEY,
	kullaniciID INT,
	projeAD nvarchar(50),
	aciklama TEXT,
	hedefbagis DECIMAL(10,2),
	mevcutbagis DECIMAL(10,2) NOT NULL,
	FOREIGN KEY (kullaniciID) REFERENCES kullanicilar(kullaniciID)
);

--Baðýþ Tablosu
CREATE TABLE bagislar(
	bagisID INT IDENTITY(1,1) PRIMARY KEY,
	kullaniciID int,
	projeID int,
	miktar DECIMAL(10,2),
	FOREIGN KEY (kullaniciID) REFERENCES kullanicilar(kullaniciID),
	FOREIGN KEY (projeID) REFERENCES proje(projeID)
);
--Kategori Tablosu
CREATE TABLE kategoriler(
	kategoriID INT IDENTITY(1,1) PRIMARY KEY,
	kategoriAD nvarchar(50)
);

--Proje Kategorileri Tablosu
CREATE TABLE projekategorileri(
	projeID int,
	kategoriID int,
	PRIMARY KEY (projeID,kategoriID),
	FOREIGN KEY (projeID) REFERENCES proje(projeID),
	FOREIGN KEY (kategoriID) REFERENCES kategoriler(kategoriID)
);

--Kullanýcýlarýn Takip Ettikleri Projeler Tablosu
CREATE TABLE takipedilenproje(
	kullaniciID int,
	projeID int,
	PRIMARY KEY (kullaniciID, projeID),
	FOREIGN KEY (kullaniciID) REFERENCES kullanicilar(kullaniciID),
	FOREIGN KEY (projeID) REFERENCES proje(projeID)
);
*/
--Yorumlar Tablosu
CREATE TABLE yorumlar(
	yorumID INT IDENTITY(1,1) PRIMARY KEY,
	kullaniciID int,
	projeID int,
	yorum TEXT,
	yorumtarihi datetime,
	FOREIGN KEY (kullaniciID) REFERENCES kullanicilar(kullaniciID),
	FOREIGN KEY (projeID) REFERENCES proje(projeID)
);

--Ödüller Tablosu
CREATE TABLE oduller(
	odulID INT IDENTITY(1,1) PRIMARY KEY,
	projeID int,
	odulaciklamasý TEXT,
	MinimumMiktar DECIMAL(10,2),
	MevcutMiktar INT,
	FOREIGN KEY (projeID) REFERENCES proje(projeID)
);

--Kullanýcýlar
INSERT INTO kullanicilar(kullaniciAD, kullanicimail, yas, cinsiyet)
VALUES
('Yunus','yunus@gmail.com','23','E'),
('Kaan','kaan@gmail.com','21','E'),
('Ecem','ecem@gmail.com','24','K'),
('Berk','berk@gmail.com','25','E'),
('Beyza','beyza@gmail.com','22','K');

--Kategoriler
INSERT INTO kategoriler(kategoriAD)
VALUES
('Müzik'),
('Teknoloji'),
('Üretim'),
('Oyun');

--Projeler
INSERT INTO proje(kullaniciID, projeAD, aciklama, hedefbagis,mevcutbagis)
VALUES
(1,'Yuyuto Games','Online mobil oyunlar geliþtiren Yuyuto Games global pazarda büyümeye devam ediyor',8000.00,1000.00),
(2,'Pocket Wifi','e-sim, taþýnabilir modem',7500.00,400.00),
(3,'Minyatür Tugla','Minyatür Tuðla, minyatür ölçekli inþaat projelerini hayata geçirmeye yardýmcý tüm içerik ve malzemeleri üreten, gerçek maket malzemeleri üreticisidir.',2500.00,100.00),
(4,'DPoir Beatue','doðal ve vegan cilt bakým ürünleri',3500.00,2000.00);

--Projelerin Kategorileri
INSERT INTO projekategorileri(projeID,kategoriID)
VALUES
(1,4), --Birinci Proje Oyun Kategorisinde
(2,2), --Ýkinci Proje Teknoloji Kategorisinde
(2,3), --Ýkinci Proje Üretim Kategorisinde
(3,3), --Üçüncü Proje Üretim Kategorisinde
(4,3); --Dördüncü Proje Üretim Kategorisinde

--Baðýþlar
INSERT INTO bagislar(kullaniciID,projeID,miktar)
VALUES
(1,2,500.00),
(1,1,2000.00),
(2,3,1200.00),
(2,2,800.00),
(3,4,5000.00),
(3,1,400.00),
(4,3,6000.00),
(5,1,2000.00),
(5,4,1200.00),
(4,2,3200.00);

--Takip Edilen Projeler
INSERT INTO takipedilenproje(kullaniciID,projeID)
VALUES
(1,2),
(1,1),
(2,3),
(2,2),
(3,4),
(3,1),
(4,3),
(5,1),
(5,4),
(4,2);

--Ödüller
INSERT INTO oduller(projeID,odulaciklamasý,MinimumMiktar,MevcutMiktar)
VALUES
(1,'Erken Eriþim Fýrsatý',1000.00,100),
(2,'Prototip Eriþimi',1500.00,70),
(3,'Çimento Paketi',2000.00,500),
(4,'%25 Ýndirim',5000.00,1200);

--Yorumlar
GO 
INSERT INTO yorumlar(kullaniciID,projeID,yorum,yorumtarihi)
VALUES
(1,1,'Mobil Oyunlar hiç bu kadar güzel olmamýþtý..','2024-01-15'),
(3,4,'Hayvanlar üzerinde denenmemesi ve vegan olmasý çok hoþ','2024-01-16'),
(2,2,'Ýnternetsiz yaþam düþünemiyorum, bu proje çok iyi..','2024-01-17')

GO

--Tüm Kullanýcýlarý Listeleme:
SELECT * FROM kullanicilar;


--Belirli Bir Projeyi ve Baðýþlarý Listeleme:
SELECT proje.projeAD, proje.aciklama, kullanicilar.kullaniciAD, bagislar.miktar
FROM proje
JOIN kullanicilar ON proje.kullaniciID = kullanicilar.kullaniciID
LEFT JOIN bagislar ON proje.projeID = bagislar.projeID
WHERE proje.projeID = 1;


--Belirli bir kullanýcýnýn takip ettiði projeleri listeleme:
SELECT proje.projeAD, proje.aciklama 
FROM proje
JOIN takipedilenproje ON proje.projeID = takipedilenproje.projeID
WHERE takipedilenproje.kullaniciID = 1;


--Belirli bir projenin kategorilerini listeleme:
SELECT kategoriler.kategoriAD
FROM kategoriler
JOIN projekategorileri ON kategoriler.kategoriID = projekategorileri.kategoriID
WHERE projekategorileri.projeID = 1;


--Belirli bir projedeki ödülleri listeleme:
SELECT odulID, odulaciklamasý, MinimumMiktar, MevcutMiktar
FROM oduller
WHERE projeID = 1;
GO

--Saklý Yordam1: Proje ödüllerini getiren yordam
CREATE PROCEDURE ProjeOdulleriniGetir
	@projeID INT
AS
BEGIN
	SELECT
	projeID,
        odulaciklamasý AS odulAciklamasi,
        MinimumMiktar,
        MevcutMiktar
	FROM
	oduller
	WHERE
	projeID = @projeID;
END;
GO
EXEC ProjeOdulleriniGetir @projeID = 1;

--Saklý Yordam2: Bagis Ýlerleme Bilgisini gösteren yordam
GO
CREATE PROCEDURE BagisÝlerlemeBilgisi
    @projeID INT
AS
BEGIN
    DECLARE @ToplamBagis DECIMAL(10,2);
    DECLARE @HedefBagis DECIMAL(10,2);

-- Toplam baðýþ miktarýný hesapla
    SELECT @ToplamBagis = SUM(miktar)
    FROM bagislar
    WHERE projeID = @projeID;

-- Hedef baðýþ miktarýný al
    SELECT @HedefBagis = hedefbagis
    FROM proje
    WHERE projeID = @projeID;

-- Hesaplanan bilgileri döndür
    SELECT
        @projeID,
        @ToplamBagis AS toplamBagis,
        @HedefBagis AS hedefBagis,
        CASE
            WHEN @ToplamBagis >= @HedefBagis THEN 'Proje hedefine ulaþýldý.'
            ELSE 'Proje hedefine ulaþýlamadý.'
        END AS durum;
END;
GO
EXEC BagisÝlerlemeBilgisi @projeID = 1;

--Trigger 1: Baðýþ Tablosu Ýçin Güncelleme Tetikleyicisi
GO
CREATE TRIGGER BagisGuncelleme
ON bagislar
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @projeID INT;
    DECLARE @miktar DECIMAL(10,2);

-- Eklenen baðýþ bilgilerini al
    SELECT @projeID = projeID, @miktar = miktar
    FROM inserted;

-- Mevcut baðýþ miktarýný güncelle
    UPDATE proje
    SET mevcutbagis = mevcutbagis + @miktar
    WHERE projeID = @ProjeID;
END;

-- Örnek bir baðýþ ekleme komutu
INSERT INTO bagislar (kullaniciID, projeID, miktar)
VALUES (1, 1, 50.00);

-- Ýlgili projenin mevcut baðýþ miktarýný kontrol etme
SELECT projeID, mevcutbagis
FROM proje
WHERE projeID = 1;

--Trigger2: Kategori Ekleme Tetikleyicisi
GO
CREATE TRIGGER KategoriEkleme
ON projekategorileri
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @projeID INT;

-- Eklenen kategori bilgilerini al
    SELECT @projeID = projeID
    FROM inserted;

-- Projedeki toplam kategori sayýsýný kontrol et
    DECLARE @kategoriSayisi INT;
    SELECT @kategoriSayisi = COUNT(*)
    FROM projekategorileri
    WHERE projeID = @projeID;

    PRINT 'Yeni bir kategori eklendi! Toplam kategori sayýsý: ' + CAST(@kategoriSayisi AS VARCHAR);
END;

GO
--Örnek kategori ekleme komutu
INSERT INTO projekategorileri (projeID, kategoriID)
VALUES (1,2);