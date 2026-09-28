                             #
-- # FROM -> JOIN -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY  #
-- #   -> LIMIT                                                         #
-- # - WHERE lọc TỪNG HÀNG, chạy TRƯỚC group, KHÔNG dùng được aggregate #
-- # - HAVING lọc TỪNG NHÓM, chạy SAU group, DÙNG ĐƯỢC aggregate        #

-- SECTION 1 — SQL DML (TRUY VẤN DỮ LIỆU)
-- -----------------------------------------------------------------
-- [TEMPLATE 1] SELECT cơ bản + nhiều điều kiện WHERE + ORDER BY
-- Dùng cho: "Liệt kê X có Y hoặc Z, và giá < N, sắp xếp theo ..."
-- -----------------------------------------------------------------
SELECT
    <cot1>,
    <cot2>,
    <cot3>
FROM   <ten_bang>
WHERE  <cot_loai> IN (<'gia_tri_1'>, <'gia_tri_2'>)   -- thay cho nhiều OR
  AND  <cot_so> < <so_tien>                            -- AND nối điều kiện
ORDER BY <cot_sap_xep> ASC;                            -- ASC tăng / DESC giảm


-- -----------------------------------------------------------------
-- [TEMPLATE 1b] Các toán tử WHERE thường dùng — chọn cái cần
-- -----------------------------------------------------------------
-- WHERE <cot> = <gia_tri>                              -- bằng
-- WHERE <cot> != <gia_tri>                              -- khác
-- WHERE <cot> BETWEEN <a> AND <b>                       -- trong khoảng (bao gồm 2 đầu)
-- WHERE <cot> LIKE '<tu_khoa>%'                         -- bắt đầu bằng tu_khoa
-- WHERE <cot> LIKE '%<tu_khoa>%'                        -- chứa tu_khoa
-- WHERE <cot> IS NULL                                   -- là NULL (KHÔNG dùng "= NULL")
-- WHERE <cot> IS NOT NULL                                -- không phải NULL
-- WHERE (<dk1> OR <dk2>) AND <dk3>                       -- luôn ngoặc OR khi trộn AND


-- -----------------------------------------------------------------
-- [TEMPLATE 2] JOIN 2 bảng — lấy dữ liệu liên quan từ bảng khác
-- Dùng cho: cần hiển thị tên/thông tin từ bảng tham chiếu (FK)
-- -----------------------------------------------------------------
SELECT
    a.<cot_a>,
    b.<cot_b>
FROM   <bang_a> a
JOIN   <bang_b> b ON a.<cot_fk> = b.<cot_pk>
WHERE  <dieu_kien>;


-- -----------------------------------------------------------------
-- [TEMPLATE 3] JOIN 3 bảng — pattern phổ biến nhất trong đề
-- Dùng cho: cần thông tin khách hàng + chi tiết đơn + tên sản phẩm
-- -----------------------------------------------------------------
SELECT
    c.<cot_ten_khach>,
    p.<cot_ten_sp>,
    d.<cot_so_luong>,
    d.<cot_so_luong> * d.<cot_don_gia> AS thanh_tien
FROM   <bang_chinh>   m            -- bảng trung tâm (vd: order_header)
JOIN   <bang_khach>   c ON c.<pk_khach> = m.<fk_khach>
JOIN   <bang_chi_tiet> d ON d.<fk_chinh> = m.<pk_chinh>
JOIN   <bang_sp>      p ON p.<pk_sp> = d.<fk_sp>
WHERE  m.<cot_trang_thai> = '<gia_tri>';


-- -----------------------------------------------------------------
-- [TEMPLATE 4] LEFT JOIN — giữ hết bảng trái, NULL nếu bảng phải
--              không có dữ liệu khớp
-- Dùng cho: "tất cả khách kể cả chưa mua hàng", "tất cả phòng kể cả
--           chưa có booking"
-- -----------------------------------------------------------------
SELECT
    a.<cot_a>,
    COALESCE(<ham_agg_b>, 0) AS <ten_alias>   -- COALESCE thay NULL -> 0
FROM      <bang_a> a
LEFT JOIN <bang_b> b ON a.<cot_pk> = b.<cot_fk>
GROUP BY  a.<cot_a>;


-- -----------------------------------------------------------------
-- [TEMPLATE 5] GROUP BY + HAVING — báo cáo tổng hợp theo nhóm
-- Dùng cho: "Báo cáo theo khách hàng: số đơn, tổng tiền, ít nhất N đơn"
-- -----------------------------------------------------------------
SELECT
    c.<cot_ten>,
    COUNT(m.<cot_id>)        AS <ten_so_luong>,    -- đếm số dòng
    SUM(m.<cot_tien>)        AS <ten_tong_tien>    -- cộng tổng
FROM     <bang_khach> c
JOIN     <bang_giao_dich> m ON c.<pk> = m.<fk>
GROUP BY c.<pk>, c.<cot_ten>          -- PHẢI có mọi cột không-aggregate
HAVING   COUNT(m.<cot_id>) >= <so_lan>     -- lọc SAU group (HAVING, không WHERE)
ORDER BY <ten_tong_tien> DESC;


-- -----------------------------------------------------------------
-- [TEMPLATE 5b] Các hàm Aggregate hay dùng
-- -----------------------------------------------------------------
-- COUNT(*)                 -- đếm tất cả hàng
-- COUNT(DISTINCT <cot>)     -- đếm giá trị KHÔNG trùng
-- SUM(<cot>)                -- tổng (trả NULL nếu rỗng -> bọc COALESCE)
-- AVG(<cot>)                -- trung bình
-- MAX(<cot>) / MIN(<cot>)   -- lớn nhất / nhỏ nhất
-- COALESCE(SUM(<cot>), 0)   -- an toàn khi có thể không có dữ liệu


-- -----------------------------------------------------------------
-- [TEMPLATE 6] Subquery với IN — lọc theo điều kiện cần JOIN khác bảng
-- Dùng cho: "Khách đã mua sản phẩm loại X" / "Phòng đã từng dùng dịch vụ Y"
-- -----------------------------------------------------------------
SELECT <cot1>, <cot2>
FROM   <bang_chinh>
WHERE  <cot_id> IN (
    SELECT <fk_id>
    FROM   <bang_giao_dich> t
    JOIN   <bang_chi_tiet>  d ON d.<fk1> = t.<pk1>
    JOIN   <bang_phu>       p ON p.<pk2> = d.<fk2>
    WHERE  p.<cot_loai> = '<gia_tri>'
);


-- -----------------------------------------------------------------
-- [TEMPLATE 7] Scalar Subquery trong SELECT — tính 1 giá trị/hàng
-- Dùng cho: cần SUM từ bảng liên kết N-N mà không thể JOIN trực tiếp
--           (tránh tích Descartes khi join 2 bảng "nhiều" cùng lúc)
-- -----------------------------------------------------------------
SELECT
    m.<cot_id>,
    m.<cot_tong>,
    (SELECT COALESCE(SUM(<cot_tien>), 0)
     FROM   <bang_lien_quan>
     WHERE  <fk_id> = m.<cot_id>)            AS <ten_alias_1>,
    m.<cot_tong> - (SELECT COALESCE(SUM(<cot_tien>), 0)
                    FROM   <bang_lien_quan>
                    WHERE  <fk_id> = m.<cot_id>) AS <ten_alias_2>
FROM   <bang_chinh> m;


-- -----------------------------------------------------------------
-- [TEMPLATE 8] OR với 2 Subquery độc lập — dạng "High-Value Customer"
-- Dùng cho: "Khách thỏa ĐK1 (cần JOIN) HOẶC ĐK2 (cần GROUP BY/HAVING)"
-- -----------------------------------------------------------------
SELECT DISTINCT          -- DISTINCT vì 1 khách có thể thỏa cả 2 điều kiện
    c.<cot_id>,
    c.<cot_ten>,
    c.<cot_email>
FROM <bang_khach> c
WHERE
    -- Điều kiện 1: cần JOIN nhiều bảng để kiểm tra
    c.<cot_id> IN (
        SELECT t.<fk_khach>
        FROM   <bang_giao_dich> t
        JOIN   <bang_chi_tiet>  d ON t.<pk> = d.<fk1>
        JOIN   <bang_phu>       p ON d.<fk2> = p.<pk2>
        WHERE  p.<cot_loai> = '<gia_tri_1>'
    )
    OR
    -- Điều kiện 2: cần GROUP BY + HAVING
    c.<cot_id> IN (
        SELECT   <fk_khach>
        FROM     <bang_giao_dich>
        GROUP BY <fk_khach>
        HAVING   SUM(<cot_tien>) > <nguong_gia_tri>
    );


-- =====================================================================
-- SECTION 2 — VIEW / PROCEDURE / TRIGGER
-- =====================================================================

-- -----------------------------------------------------------------
-- [TEMPLATE 9] CREATE VIEW — bảng ảo, dùng scalar subquery để tránh
--              tích Descartes khi cần tổng từ 2 bảng quan hệ N-N
-- -----------------------------------------------------------------
CREATE OR REPLACE VIEW <ten_view> AS
SELECT
    m.<cot_id>,
    c.<cot_ten>                                          AS <alias_ten>,
    m.<cot_ngay>,

    -- Tổng A: tính riêng trong subquery (KHÔNG JOIN trực tiếp!)
    (SELECT SUM(d.<cot_sl> * d.<cot_dongia>)
     FROM   <bang_chi_tiet> d
     WHERE  d.<fk> = m.<pk>)                              AS <alias_tong_a>,

    -- Tổng B: COALESCE để xử lý trường hợp chưa có dữ liệu (NULL -> 0)
    (SELECT COALESCE(SUM(p.<cot_tien>), 0)
     FROM   <bang_lien_quan_2> p
     WHERE  p.<fk> = m.<pk>)                               AS <alias_tong_b>,

    -- Cân đối = Tổng A - Tổng B
    (SELECT SUM(d.<cot_sl> * d.<cot_dongia>)
     FROM   <bang_chi_tiet> d
     WHERE  d.<fk> = m.<pk>)
    - (SELECT COALESCE(SUM(p.<cot_tien>), 0)
       FROM   <bang_lien_quan_2> p
       WHERE  p.<fk> = m.<pk>)                              AS <alias_can_doi>

FROM   <bang_chinh> m
JOIN   <bang_khach> c ON c.<pk_khach> = m.<fk_khach>;

-- Dùng view:        SELECT * FROM <ten_view>;
-- Xóa view:         DROP VIEW IF EXISTS <ten_view>;


-- -----------------------------------------------------------------
-- [TEMPLATE 10] CREATE PROCEDURE — bộ khung đầy đủ
-- Dùng cho: "Viết Stored Procedure để tạo đơn / thêm dịch vụ / ..."
-- -----------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE <ten_procedure>(
    IN p_<param1> INT,
    IN p_<param2> INT,
    IN p_<param3> INT
)
BEGIN
    -- DECLARE phải đặt NGAY ĐẦU BEGIN, trước mọi lệnh khác
    DECLARE v_<ton_kho>   INT;
    DECLARE v_<gia>       DECIMAL(15,2);
    DECLARE v_<id_moi>    INT;

    -- Bước 1: Lấy dữ liệu cần kiểm tra
    SELECT <cot_ton_kho>, <cot_gia>
    INTO   v_<ton_kho>, v_<gia>
    FROM   <bang_sp>
    WHERE  <cot_pk> = p_<param2>;

    -- Bước 2: Kiểm tra điều kiện hợp lệ -> báo lỗi nếu sai
    IF v_<ton_kho> < p_<param3> THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '<thong_bao_loi>';
    END IF;

    -- Bước 3: INSERT vào bảng cha
    INSERT INTO <bang_chinh> (<cot_fk_khach>, <cot_ngay>, <cot_status>, <cot_tong>)
    VALUES (p_<param1>, CURDATE(), '<trang_thai_mac_dinh>', 0);

    -- Bước 4: Lấy ID vừa tạo
    SET v_<id_moi> = LAST_INSERT_ID();

    -- Bước 5: INSERT vào bảng con
    INSERT INTO <bang_chi_tiet> (<fk_chinh>, <fk_sp>, <cot_sl>, <cot_dongia>)
    VALUES (v_<id_moi>, p_<param2>, p_<param3>, v_<gia>);

    -- Bước 6: UPDATE dữ liệu liên quan (vd: trừ tồn kho)
    UPDATE <bang_sp>
    SET    <cot_ton_kho> = <cot_ton_kho> - p_<param3>
    WHERE  <cot_pk> = p_<param2>;

END $$

DELIMITER ;

-- Gọi procedure:    CALL <ten_procedure>(<gia_tri_1>, <gia_tri_2>, <gia_tri_3>);


-- -----------------------------------------------------------------
-- [TEMPLATE 11] CREATE TRIGGER — AFTER INSERT: tự cập nhật bảng khác
-- Dùng cho: "Tự động tính lại total_amount khi thêm chi tiết đơn"
-- -----------------------------------------------------------------
DELIMITER $$

CREATE TRIGGER <ten_trigger>
AFTER INSERT ON <bang_chi_tiet>
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20);

    -- NEW.<cot> = giá trị của dòng VỪA được INSERT
    SELECT <cot_status> INTO v_status
    FROM   <bang_chinh>
    WHERE  <cot_pk> = NEW.<fk_chinh>;

    IF v_status != '<trang_thai_bi_loai>' THEN
        UPDATE <bang_chinh>
        SET    <cot_tong> = (
            SELECT SUM(<cot_sl> * <cot_dongia>)
            FROM   <bang_chi_tiet>
            WHERE  <fk_chinh> = NEW.<fk_chinh>
        )
        WHERE  <cot_pk> = NEW.<fk_chinh>;
    END IF;
END $$

DELIMITER ;


-- -----------------------------------------------------------------
-- [TEMPLATE 12] CREATE TRIGGER — BEFORE INSERT: chặn dữ liệu vi phạm
-- Dùng cho: "Ngăn thanh toán vượt mức", "ngăn đặt phòng trùng giờ"
-- -----------------------------------------------------------------
DELIMITER $$

CREATE TRIGGER <ten_trigger_2>
BEFORE INSERT ON <bang_can_kiem_tra>
FOR EACH ROW
BEGIN
    DECLARE v_<bien_1> DECIMAL(15,2);
    DECLARE v_<bien_2> DECIMAL(15,2);

    SELECT <cot_can_lay> INTO v_<bien_1>
    FROM   <bang_lien_quan>
    WHERE  <cot_pk> = NEW.<fk>;

    SELECT COALESCE(SUM(<cot_tien>), 0) INTO v_<bien_2>
    FROM   <bang_can_kiem_tra>
    WHERE  <fk> = NEW.<fk>;

    -- Điều kiện vi phạm -> chặn bằng SIGNAL (chỉ hoạt động ở BEFORE)
    IF v_<bien_2> + NEW.<cot_so_tien> > v_<bien_1> THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '<thong_bao_loi>';
    END IF;
END $$

DELIMITER ;


-- This BEFORE INSERT trigger acts as a database-level gatekeeper. It calculates the total payment and uses SIGNAL SQLSTATE to instantly block the transaction if it exceeds the order's total amount, preventing any overpayment errors.

-- -----------------------------------------------------------------
-- [TEMPLATE 12b] CREATE TRIGGER — BEFORE INSERT: chặn chồng chéo
--                thời gian (double booking)
-- Logic chồng chéo: [A,B) giao [C,D)  <=>  A < D  AND  C < B
-- -----------------------------------------------------------------
DELIMITER $$

CREATE TRIGGER <ten_trigger_3>
BEFORE INSERT ON <bang_booking>
FOR EACH ROW
BEGIN
    DECLARE v_overlap INT;

    SELECT COUNT(*) INTO v_overlap
    FROM   <bang_booking>
    WHERE  <cot_phong_id> = NEW.<cot_phong_id>
      AND  NEW.<cot_ngay_bat_dau> < <cot_ngay_ket_thuc>
      AND  NEW.<cot_ngay_ket_thuc> > <cot_ngay_bat_dau>;

    IF v_overlap > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '<thong_bao_loi_trung_lich>';
    END IF;
END $$

DELIMITER ;

-- This BEFORE INSERT trigger prevents double-booking. It checks for overlapping dates and uses SIGNAL SQLSTATE to abort the transaction if a time conflict is found, ensuring data integrity."
-- =====================================================================
-- SECTION 3 — INDEX & CONSTRAINT (TỐI ƯU HÓA)
-- =====================================================================

-- -----------------------------------------------------------------
-- [TEMPLATE 13] CREATE INDEX
-- -----------------------------------------------------------------
CREATE INDEX <ten_index> ON <ten_bang>(<cot_can_index>);

-- Composite (nhiều cột, dùng khi WHERE lọc đồng thời 2 cột):
-- CREATE INDEX <ten_index_2> ON <ten_bang>(<cot1>, <cot2>);

-- Unique (kèm ràng buộc không trùng):
-- CREATE UNIQUE INDEX <ten_index_3> ON <ten_bang>(<cot_unique>);

-- Xóa index:
-- DROP INDEX <ten_index> ON <ten_bang>;


-- -----------------------------------------------------------------
-- [TEMPLATE 13b] GIẢI THÍCH MẪU — vì sao hàm phá Index
-- (Copy đoạn này vào câu trả lời, không cần SQL)
-- -----------------------------------------------------------------
-- Using a function like YEAR(order_date) prevents the database from using the index.Instead of a quick index search, the system must evaluate the function for every single row, resulting in a slow Full Table Scan. Using BETWEEN allows the query to search directly within the index efficiently.
--
-- ❌ SAI (không dùng được Index):
--    WHERE YEAR(<cot_ngay>) = 2025
--    -> MySQL phải tính YEAR() cho TỪNG hàng trước khi so sánh.
--       Index lưu giá trị ngày gốc, không lưu YEAR(ngày) -> không
--       tra được trực tiếp -> phải Full Table Scan toàn bộ bảng.
--    -> Nguyên tắc: không bọc cột có index trong bất kỳ hàm nào
--       ở vế WHERE (YEAR, MONTH, LOWER, DATE_FORMAT, col+1, ...).


-- -----------------------------------------------------------------
-- [TEMPLATE 14] CONSTRAINT — ràng buộc toàn vẹn dữ liệu
-- -----------------------------------------------------------------
-- Thêm UNIQUE (vd: 1 đơn chỉ có tối đa 1 payment):
ALTER TABLE <ten_bang>
ADD CONSTRAINT <ten_constraint> UNIQUE (<cot>);

-- Thêm CHECK (MySQL 8.0.16+):
-- ALTER TABLE <ten_bang>
-- ADD CONSTRAINT <ten_check> CHECK (<cot> > 0);

-- Thêm FOREIGN KEY:
-- ALTER TABLE <ten_bang>
-- ADD CONSTRAINT <ten_fk>
--     FOREIGN KEY (<cot_fk>) REFERENCES <bang_cha>(<cot_pk>)
--     ON DELETE RESTRICT
--     ON UPDATE CASCADE;

-- NOT NULL khi tạo bảng mới:
-- <cot> <KIEU_DU_LIEU> NOT NULL,

-- DEFAULT khi tạo bảng mới:
-- <cot> VARCHAR(20) DEFAULT '<gia_tri_mac_dinh>',


-- =====================================================================
-- PHỤ LỤC — CÁC HÀM HAY DÙNG TRONG MYSQL
-- =====================================================================
-- CURDATE()                        -- ngày hiện tại (DATE)
-- NOW()                             -- ngày giờ hiện tại (DATETIME)
-- DATEDIFF(ngay_sau, ngay_truoc)    -- số ngày giữa 2 ngày
-- LAST_INSERT_ID()                  -- ID AUTO_INCREMENT vừa được tạo
-- COALESCE(expr, gia_tri_thay_the)  -- thay NULL bằng giá trị khác
-- CONCAT(a, ' ', b)                 -- nối chuỗi
-- YEAR(<cot_ngay>) / MONTH(<cot_ngay>)  -- lấy năm/tháng (TRÁNH dùng trong WHERE!)

