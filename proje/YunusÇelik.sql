
CREATE DATABASE KitleFonlama
USE KitleFonlama
--Kullan�c�lar Tablosu
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

--Ba��� Tablosu
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

--Kullan�c�lar�n Takip Ettikleri Projeler Tablosu
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

--�d�ller Tablosu
CREATE TABLE oduller(
	odulID INT IDENTITY(1,1) PRIMARY KEY,
	projeID int,
	odulaciklamas� TEXT,
	MinimumMiktar DECIMAL(10,2),
	MevcutMiktar INT,
	FOREIGN KEY (projeID) REFERENCES proje(projeID)
);

--Kullan�c�lar
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
('M�zik'),
('Teknoloji'),
('�retim'),
('Oyun');

--Projeler
INSERT INTO proje(kullaniciID, projeAD, aciklama, hedefbagis,mevcutbagis)
VALUES
(1,'Yuyuto Games','Online mobil oyunlar geli�tiren Yuyuto Games global pazarda b�y�meye devam ediyor',8000.00,1000.00),
(2,'Pocket Wifi','e-sim, ta��nabilir modem',7500.00,400.00),
(3,'Minyat�r Tugla','Minyat�r Tu�la, minyat�r �l�ekli in�aat projelerini hayata ge�irmeye yard�mc� t�m i�erik ve malzemeleri �reten, ger�ek maket malzemeleri �reticisidir.',2500.00,100.00),
(4,'DPoir Beatue','do�al ve vegan cilt bak�m �r�nleri',3500.00,2000.00);

--Projelerin Kategorileri
INSERT INTO projekategorileri(projeID,kategoriID)
VALUES
(1,4), --Birinci Proje Oyun Kategorisinde
(2,2), --�kinci Proje Teknoloji Kategorisinde
(2,3), --�kinci Proje �retim Kategorisinde
(3,3), --���nc� Proje �retim Kategorisinde
(4,3); --D�rd�nc� Proje �retim Kategorisinde

--Ba���lar
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

--�d�ller
INSERT INTO oduller(projeID,odulaciklamas�,MinimumMiktar,MevcutMiktar)
VALUES
(1,'Erken Eri�im F�rsat�',1000.00,100),
(2,'Prototip Eri�imi',1500.00,70),
(3,'�imento Paketi',2000.00,500),
(4,'%25 �ndirim',5000.00,1200);

--Yorumlar
GO 
INSERT INTO yorumlar(kullaniciID,projeID,yorum,yorumtarihi)
VALUES
(1,1,'Mobil Oyunlar hi� bu kadar g�zel olmam��t�..','2024-01-15'),
(3,4,'Hayvanlar �zerinde denenmemesi ve vegan olmas� �ok ho�','2024-01-16'),
(2,2,'�nternetsiz ya�am d���nemiyorum, bu proje �ok iyi..','2024-01-17')

GO

--T�m Kullan�c�lar� Listeleme:
SELECT * FROM kullanicilar;


--Belirli Bir Projeyi ve Ba���lar� Listeleme:
SELECT proje.projeAD, proje.aciklama, kullanicilar.kullaniciAD, bagislar.miktar
FROM proje
JOIN kullanicilar ON proje.kullaniciID = kullanicilar.kullaniciID
LEFT JOIN bagislar ON proje.projeID = bagislar.projeID
WHERE proje.projeID = 1;


--Belirli bir kullan�c�n�n takip etti�i projeleri listeleme:
SELECT proje.projeAD, proje.aciklama 
FROM proje
JOIN takipedilenproje ON proje.projeID = takipedilenproje.projeID
WHERE takipedilenproje.kullaniciID = 1;


--Belirli bir projenin kategorilerini listeleme:
SELECT kategoriler.kategoriAD
FROM kategoriler
JOIN projekategorileri ON kategoriler.kategoriID = projekategorileri.kategoriID
WHERE projekategorileri.projeID = 1;


--Belirli bir projedeki �d�lleri listeleme:
SELECT odulID, odulaciklamas�, MinimumMiktar, MevcutMiktar
FROM oduller
WHERE projeID = 1;
GO

--Sakl� Yordam1: Proje �d�llerini getiren yordam
CREATE PROCEDURE ProjeOdulleriniGetir
	@projeID INT
AS
BEGIN
	SELECT
	projeID,
        odulaciklamas� AS odulAciklamasi,
        MinimumMiktar,
        MevcutMiktar
	FROM
	oduller
	WHERE
	projeID = @projeID;
END;
GO
EXEC ProjeOdulleriniGetir @projeID = 1;

--Sakl� Yordam2: Bagis �lerleme Bilgisini g�steren yordam
GO
CREATE PROCEDURE Bagis�lerlemeBilgisi
    @projeID INT
AS
BEGIN
    DECLARE @ToplamBagis DECIMAL(10,2);
    DECLARE @HedefBagis DECIMAL(10,2);

-- Toplam ba��� miktar�n� hesapla
    SELECT @ToplamBagis = SUM(miktar)
    FROM bagislar
    WHERE projeID = @projeID;

-- Hedef ba��� miktar�n� al
    SELECT @HedefBagis = hedefbagis
    FROM proje
    WHERE projeID = @projeID;

-- Hesaplanan bilgileri d�nd�r
    SELECT
        @projeID,
        @ToplamBagis AS toplamBagis,
        @HedefBagis AS hedefBagis,
        CASE
            WHEN @ToplamBagis >= @HedefBagis THEN 'Proje hedefine ula��ld�.'
            ELSE 'Proje hedefine ula��lamad�.'
        END AS durum;
END;
GO
EXEC Bagis�lerlemeBilgisi @projeID = 1;

--Trigger 1: Ba��� Tablosu ��in G�ncelleme Tetikleyicisi
GO
CREATE TRIGGER BagisGuncelleme
ON bagislar
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @projeID INT;
    DECLARE @miktar DECIMAL(10,2);

-- Eklenen ba��� bilgilerini al
    SELECT @projeID = projeID, @miktar = miktar
    FROM inserted;

-- Mevcut ba��� miktar�n� g�ncelle
    UPDATE proje
    SET mevcutbagis = mevcutbagis + @miktar
    WHERE projeID = @ProjeID;
END;

-- �rnek bir ba��� ekleme komutu
INSERT INTO bagislar (kullaniciID, projeID, miktar)
VALUES (1, 1, 50.00);

-- �lgili projenin mevcut ba��� miktar�n� kontrol etme
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

-- Projedeki toplam kategori say�s�n� kontrol et
    DECLARE @kategoriSayisi INT;
    SELECT @kategoriSayisi = COUNT(*)
    FROM projekategorileri
    WHERE projeID = @projeID;

    PRINT 'Yeni bir kategori eklendi! Toplam kategori say�s�: ' + CAST(@kategoriSayisi AS VARCHAR);
END;

GO
--�rnek kategori ekleme komutu
INSERT INTO projekategorileri (projeID, kategoriID)
VALUES (1,2);