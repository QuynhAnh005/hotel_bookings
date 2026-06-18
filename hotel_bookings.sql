SELECT * FROM hotel_bookings_clean;

-- Số lượng và tỷ lệ hủy chung
SELECT is_canceled,
    COUNT(*) AS so_luong,
    CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM hotel_bookings_clean) * 100 AS DECIMAL(10,2)) AS ty_le
FROM hotel_bookings_clean
GROUP BY is_canceled
ORDER BY is_canceled;

-- Số lượng và tỷ lệ hủy theo khách sạn
SELECT hotel,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS so_luong_huy,
    COUNT(*) AS tong_booking,
    CAST(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) * 100 AS DECIMAL(10,2)) AS ty_le_huy
FROM hotel_bookings_clean
GROUP BY hotel
ORDER BY ty_le_huy DESC;

-- Số lượng và tỷ lệ hủy theo kênh đặt phòng
SELECT market_segment,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS so_luong_huy,
    COUNT(*) AS tong_booking,
    CAST(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) * 100 AS DECIMAL(10,2)) AS ty_le_huy
FROM hotel_bookings_clean
GROUP BY market_segment
ORDER BY ty_le_huy DESC;

-- Số lượng và tỷ lệ hủy theo loại đặt cọc
SELECT deposit_type,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS so_luong_huy,
    COUNT(*) AS tong_booking,
    CAST(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) * 100 AS DECIMAL(10,2)) AS ty_le_huy
FROM hotel_bookings_clean
GROUP BY deposit_type
ORDER BY ty_le_huy DESC;

-- Số lượng và tỷ lệ hủy theo thời gian đặt phòng
SELECT lead_group,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS so_luong_huy,
    COUNT(*) AS tong_booking,
    CAST(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) * 100 AS DECIMAL(10,2)) AS ty_le_huy
FROM hotel_bookings_clean
GROUP BY lead_group
ORDER BY ty_le_huy DESC;

-- Số lượng và tỷ lệ hủy theo tháng
SELECT month_num,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS so_luong_huy,
    COUNT(*) AS tong_booking,
    CAST(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) * 100 AS DECIMAL(10,2)) AS ty_le_huy
FROM hotel_bookings_clean
GROUP BY month_num
ORDER BY month_num;

-- Biến động adr theo tháng cho từng loại khách sạn (chỉ những booking không hủy và adr > 0: không kéo trung bình xuống)
SELECT hotel, month_num, 
    CAST(AVG(adr) AS DECIMAL(10,2)) AS adr_trung_binh
FROM hotel_bookings_clean
WHERE is_canceled = 0 AND adr > 0
GROUP BY hotel, month_num
ORDER BY hotel, month_num;

-- Nhóm khách hàng nào có doanh thu trung bình cao nhất? (chỉ những booking không hủy và revenue > 0)
SELECT customer_type, ROUND(AVG(revenue), 2) AS doanh_thu_trung_binh
FROM hotel_bookings_clean
WHERE is_canceled = 0 AND revenue > 0
GROUP BY customer_type
ORDER BY AVG(revenue) DESC;

-- Top 5 quốc gia có số lượng booking nhiều nhất
SELECT TOP 5 country, COUNT(*) AS so_luong_booking
FROM hotel_bookings_clean
GROUP BY country
ORDER BY COUNT(*) DESC;
