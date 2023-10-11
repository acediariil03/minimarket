-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 20 Jan 2023 pada 18.43
-- Versi server: 10.4.24-MariaDB
-- Versi PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_minimarket`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `jml_jk_kry` (IN `gender` VARCHAR(10), OUT `jenis_kelamin` VARCHAR(10), OUT `jumlah` INT(11))   SELECT gender_karyawan, COUNT(*) INTO jenis_kelamin, jumlah 
FROM karyawan WHERE gender_karyawan = gender$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_harga` (IN `hargajual_parameter` INT(11), IN `id_parameter` VARCHAR(6))   BEGIN
	UPDATE produk
    SET harga_jual = hargajual_parameter
    WHERE id_produk = id_parameter;
END$$

--
-- Fungsi
--
CREATE DEFINER=`root`@`localhost` FUNCTION `diskon` (`harga_jual` DECIMAL(11,2), `besar_diskon` DECIMAL(11,2)) RETURNS DECIMAL(11,2)  BEGIN 
	DECLARE hasil_diskon decimal (11,2);
    DECLARE potongan_diskon decimal (11,2);
    
    SET potongan_diskon = harga_jual * (besar_diskon/100);
    SET hasil_diskon = harga_jual - potongan_diskon;
    
    RETURN hasil_diskon;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `hargajual` (`harga_beli` INT(11)) RETURNS INT(11)  BEGIN
	DECLARE hasil INT;
    SET hasil = harga_beli + 1000;
    RETURN hasil;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `gudang`
--

CREATE TABLE `gudang` (
  `id_pembelian` varchar(11) NOT NULL,
  `id_karyawan` varchar(6) NOT NULL,
  `id_supplier` varchar(11) NOT NULL,
  `id_produk` varchar(6) NOT NULL,
  `tanggal_transaksi` date DEFAULT NULL,
  `harga_beli` int(11) NOT NULL,
  `jumlah_produk_g` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `gudang`
--

INSERT INTO `gudang` (`id_pembelian`, `id_karyawan`, `id_supplier`, `id_produk`, `tanggal_transaksi`, `harga_beli`, `jumlah_produk_g`) VALUES
('BY0210221', 'KRY08', 'SUP02', 'PR254', '2022-10-02', 3300, 100),
('BY1710221', 'KRY06', 'SUP08', 'PR061', '2022-10-17', 4000, 200),
('BY3110221', 'KRY09', 'SUP01', 'PR043', '2022-10-31', 2500, 500),
('BY3110222', 'KRY09', 'SUP05', 'PR089', '2022-10-31', 8200, 100),
('BY3110223', 'KRY09', 'SUP10', 'PR098', '2022-10-31', 5500, 100),
('BY3112221', 'KRY05', 'SUP03', 'PR301', '2022-12-31', 8000, 200),
('BY3112222', 'KRY05', 'SUP06', 'PR083', '2022-12-31', 6500, 100),
('BY3112223', 'KRY05', 'SUP09', 'PR011', '2022-12-31', 9000, 10),
('BY3112224', 'KRY05', 'SUP07', 'PR069', '2022-12-31', 3500, 200),
('BY3112225', 'KRY05', 'SUP04', 'PR002', '2022-12-31', 7000, 200);

--
-- Trigger `gudang`
--
DELIMITER $$
CREATE TRIGGER `tambahstok` AFTER INSERT ON `gudang` FOR EACH ROW BEGIN
	UPDATE produk SET jumlah_produk = jumlah_produk + NEW.jumlah_produk_g WHERE id_produk = NEW.id_produk;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `karyawan`
--

CREATE TABLE `karyawan` (
  `id_karyawan` varchar(6) NOT NULL,
  `telp_karyawan` varchar(13) DEFAULT NULL,
  `nama_karyawan` varchar(50) NOT NULL,
  `alamat_karyawan` text NOT NULL,
  `gender_karyawan` varchar(10) NOT NULL,
  `role_karyawan` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `karyawan`
--

INSERT INTO `karyawan` (`id_karyawan`, `telp_karyawan`, `nama_karyawan`, `alamat_karyawan`, `gender_karyawan`, `role_karyawan`) VALUES
('KRY01', '082128953330', 'Angel Patience', 'Perumahan Karanglo Indah DD/1', 'Female', 'Kebersihan'),
('KRY02', '082336750115', 'Marwah Inas', 'Pesona Telaga Golf III/38', 'Female', 'Kasir'),
('KRY03', '082827349839', 'Naura Sheika', 'Jl. Sulfat Agung IV/19', 'Female', 'Kebersihan'),
('KRY04', '082986234156', 'Pirelli Rahelya', 'Jl. Ikan Paus Raya no 14', 'Female', 'Kasir'),
('KRY05', '087893245211', 'Rifaldi Indrajaya', 'Jl. Soekarno Hatta Indah II/50', 'Male', 'Gudang'),
('KRY06', '082543233839', 'Komang Andika Wira Santosa', 'Perumahan Dwiga A6/26', 'Male', 'Gudang'),
('KRY07', '082827349521', 'William Edgar', 'Jalan Haruwi no 15', 'Male', 'Kebersihan'),
('KRY08', '085673459811', 'Jovea  Clevy', 'Perum Blimbing Indah A2/8', 'Male', 'Gudang'),
('KRY09', '087759960274', 'Stita Maharani', 'Jl. Guntur 11A/16', 'Female', 'Gudang'),
('KRY10', '085288782003', 'Kezia Foejiono', 'Permata Jingga Blok Anggrek IV/15', 'Female', 'Kasir');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kasir`
--

CREATE TABLE `kasir` (
  `id_penjualan` varchar(11) NOT NULL,
  `id_karyawan` varchar(6) NOT NULL,
  `id_pelanggan` varchar(11) NOT NULL,
  `id_produk` varchar(6) NOT NULL,
  `tanggal_transaksi` date DEFAULT NULL,
  `jumlah_produk_k` int(11) NOT NULL,
  `total_belanja` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `kasir`
--

INSERT INTO `kasir` (`id_penjualan`, `id_karyawan`, `id_pelanggan`, `id_produk`, `tanggal_transaksi`, `jumlah_produk_k`, `total_belanja`) VALUES
('SL0201231', 'KRY04', 'PL0201231', 'PR069', '2023-01-02', 1, 4500),
('SL0201232', 'KRY04', 'PL0201232', 'PR011', '2023-01-02', 1, 10500),
('SL0201233', 'KRY04', 'PL0201233', 'PR002', '2023-01-02', 2, 17000),
('SL0201234', 'KRY04', 'PL0201234', 'PR043', '2023-01-02', 3, 10500),
('SL3010221', 'KRY10', 'PL3010221', 'PR083', '2022-10-30', 2, 15000),
('SL3110221', 'KRY01', 'PL3110221', 'PR089', '2022-10-31', 1, 9000),
('SL3110222', 'KRY01', 'PL3110221', 'PR043', '2022-10-31', 5, 17500),
('SL3110223', 'KRY01', 'PL3110223', 'PR002', '2022-10-31', 2, 17000),
('SL3110224', 'KRY01', 'PL3110224', 'PR254', '2022-10-31', 5, 20000),
('SL3110225', 'KRY01', 'PL3110225', 'PR301', '2022-10-31', 1, 9500);

--
-- Trigger `kasir`
--
DELIMITER $$
CREATE TRIGGER `kurangstok` AFTER INSERT ON `kasir` FOR EACH ROW BEGIN 
	UPDATE produk SET jumlah_produk = jumlah_produk - NEW.jumlah_produk_k WHERE id_produk = NEW.id_produk;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `totalbelanja` BEFORE INSERT ON `kasir` FOR EACH ROW BEGIN
    SET NEW.total_belanja = (SELECT harga_jual FROM produk WHERE produk.id_produk = NEW.id_produk) * NEW.jumlah_produk_k;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id_pelanggan` varchar(11) NOT NULL,
  `telp_pelanggan` varchar(13) DEFAULT NULL,
  `nama_pelanggan` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `pelanggan`
--

INSERT INTO `pelanggan` (`id_pelanggan`, `telp_pelanggan`, `nama_pelanggan`) VALUES
('PL0201231', '08813484564', 'Satria Ageng'),
('PL0201232', '081233172897', 'Leny Rachmawati'),
('PL0201233', '082231567811', 'Kusuma Dewi'),
('PL0201234', '085856583162', 'Aurelia Natasya'),
('PL3010221', '087434366524', 'Gabriel Angkawijaya'),
('PL3110221', '085101522804', 'Kevin Anthony'),
('PL3110222', '082337700026', 'Putri Saraswati'),
('PL3110223', '081120641675', 'Carolina Nathaniela'),
('PL3110224', '08125290500', 'Mathilda Gracelynne'),
('PL3110225', '082140487699', 'Louisa Eleonora');

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk`
--

CREATE TABLE `produk` (
  `id_produk` varchar(6) NOT NULL,
  `nama_produk` varchar(50) NOT NULL,
  `harga_jual` int(11) NOT NULL,
  `jumlah_produk` int(11) NOT NULL,
  `jenis_produk` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `produk`
--

INSERT INTO `produk` (`id_produk`, `nama_produk`, `harga_jual`, `jumlah_produk`, `jenis_produk`) VALUES
('PR002', 'Cheetos Puffs', 15000, 192, 'Snack'),
('PR011', 'Sari Roti Sobek Coklat', 10500, 8, 'Makanan'),
('PR043', 'Le Minerale 600 Ml', 3500, 484, 'Minuman'),
('PR061', 'Coca Cola', 5500, 200, 'Minuman'),
('PR069', 'Tao Kae Noi Crispy Seaweed', 4500, 198, 'Snack'),
('PR083', 'Glico Pocky', 7500, 96, 'Snack'),
('PR089', 'Nextar Choco Brownies', 9000, 98, 'Snack'),
('PR098', 'Larutan cap kaki tiga', 6700, 100, 'Minuman'),
('PR254', 'Fitbar', 4000, 90, 'Snack'),
('PR301', 'Susu Nestle Bear Brand', 9500, 198, 'Minuman');

-- --------------------------------------------------------

--
-- Struktur dari tabel `rekapkerja`
--

CREATE TABLE `rekapkerja` (
  `id_karyawan` varchar(6) NOT NULL,
  `jamkerja_karyawan` int(4) NOT NULL,
  `absen_karyawan` varchar(3) NOT NULL,
  `gaji_karyawan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `rekapkerja`
--

INSERT INTO `rekapkerja` (`id_karyawan`, `jamkerja_karyawan`, `absen_karyawan`, `gaji_karyawan`) VALUES
('KRY01', 40, '1', 625000),
('KRY04', 48, '0', 750000),
('KRY05', 32, '2', 500000),
('KRY06', 48, '0', 750000),
('KRY08', 48, '0', 750000),
('KRY09', 40, '1', 625000),
('KRY10', 48, '0', 750000);

-- --------------------------------------------------------

--
-- Struktur dari tabel `supplier`
--

CREATE TABLE `supplier` (
  `id_supplier` varchar(11) NOT NULL,
  `telp_supplier` varchar(13) DEFAULT NULL,
  `nama_supplier` varchar(50) NOT NULL,
  `alamat_supplier` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `supplier`
--

INSERT INTO `supplier` (`id_supplier`, `telp_supplier`, `nama_supplier`, `alamat_supplier`) VALUES
('SUP01', '085345568113', 'Kemajuan Utama', 'Sunrise Garden Complex no 113'),
('SUP02', '085763241789', 'Bersama Sejahtera', 'Jl. Teluk Kuantar no 88'),
('SUP03', '085445276211', 'Citra Cinta', 'Perumahan Permata Jingga A3/5'),
('SUP04', '087759980420', 'Damai Investama', 'Jl. Candi Agung IV/15A'),
('SUP05', '085445276245', 'Damar Membara', 'Pondok Estate Kav.14'),
('SUP06', '085763245437', 'Bara Kahuripan', 'Jl. Perusahaan Atas no 50'),
('SUP07', '085763283152', 'Gempita Cahaya', 'Jl. Mangliawan Permai B/70'),
('SUP08', '085445276712', 'Makmur Abadijaya', 'Jl. Soekarno Hatta Indah II/34'),
('SUP09', '087756670423', 'Tata Citra', 'Jl. MT Haryono XIII/431'),
('SUP10', '081233926571', 'Kencana Ceria', 'Jl. Raya Singosari no 7');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `gudang`
--
ALTER TABLE `gudang`
  ADD PRIMARY KEY (`id_pembelian`),
  ADD KEY `id_karyawan` (`id_karyawan`),
  ADD KEY `id_supplier` (`id_supplier`),
  ADD KEY `id_produk` (`id_produk`);

--
-- Indeks untuk tabel `karyawan`
--
ALTER TABLE `karyawan`
  ADD PRIMARY KEY (`id_karyawan`);

--
-- Indeks untuk tabel `kasir`
--
ALTER TABLE `kasir`
  ADD PRIMARY KEY (`id_penjualan`),
  ADD KEY `id_karyawan` (`id_karyawan`),
  ADD KEY `id_pelanggan` (`id_pelanggan`),
  ADD KEY `id_produk` (`id_produk`);

--
-- Indeks untuk tabel `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id_pelanggan`);

--
-- Indeks untuk tabel `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id_produk`);

--
-- Indeks untuk tabel `rekapkerja`
--
ALTER TABLE `rekapkerja`
  ADD KEY `id_karyawan` (`id_karyawan`);

--
-- Indeks untuk tabel `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id_supplier`);

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `gudang`
--
ALTER TABLE `gudang`
  ADD CONSTRAINT `gudang_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `karyawan` (`id_karyawan`),
  ADD CONSTRAINT `gudang_ibfk_2` FOREIGN KEY (`id_supplier`) REFERENCES `supplier` (`id_supplier`),
  ADD CONSTRAINT `gudang_ibfk_3` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`);

--
-- Ketidakleluasaan untuk tabel `kasir`
--
ALTER TABLE `kasir`
  ADD CONSTRAINT `kasir_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `karyawan` (`id_karyawan`),
  ADD CONSTRAINT `kasir_ibfk_2` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`),
  ADD CONSTRAINT `kasir_ibfk_3` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`);

--
-- Ketidakleluasaan untuk tabel `rekapkerja`
--
ALTER TABLE `rekapkerja`
  ADD CONSTRAINT `rekapkerja_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `karyawan` (`id_karyawan`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
