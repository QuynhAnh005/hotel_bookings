PHÂN TÍCH TỶ LỆ HỦY PHÒNG VÀ DOANH THU CỦA HAI KHÁCH SẠN 7/2015 - 9/2017
I. Tổng quan
- Công cụ sử dụng: R - SQL - Excel
- Dữ liệu gốc: https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand
- Mục tiêu: Phân tích bộ dữ liệu đặt phòng khách sạn nhằm:
      + Xác định tỷ lệ hủy phòng tổng thể và theo từng nhóm phân loại.
      + Tìm ra các yếu tố ảnh hưởng đến quyết định hủy phòng.
      + Phân tích doanh thu và giá phòng trung bình (ADR) theo thời gian.
- Cấu trúc:
      File	                                    Mô tả
hotel_bookings.Rmd	                Làm sạch dữ liệu và tạo biến bằng R
hotel_bookings.sql	                Truy vấn phân tích bằng SQL Server
hotel_bookings_Query.docx	          Câu lệnh và kết quả truy vấn phân tích bằng SQL Server
hotel_bookings_Dashboard.xlsx	      Dashboard tổng hợp kết quả
hotel_bookings_Dashboard.png	      Ảnh minh họa Dashboard

II. Quy trình thực hiện
1. Làm sạch dữ liệu (R): Sử dụng package rio, dplyr, tidyr
- Dữ liệu ban đầu gồm có 119 390 quan sát với 32 biến. 
- Chọn các biến phù hợp để phân tích, sử dụng 16 trên 32 biến.
- Giá trị khuyết thiếu:
      + Kiểm tra NA thực: 
Thay 4 giá trị khuyết thiếu ở biến children bằng 0 do tỷ lệ NA quá nhỏ so với toàn bộ dữ liệu (<5%). Trong ngữ cảnh khách sạn, thiếu thông tin trẻ em khả năng cao là booking không có trẻ em, tức bằng 0. Xóa 4 quan sát này có thể làm thiếu hụt các thông tin booking quan trọng còn lại.
	      + Kiểm tra NULL dạng chuỗi:
Thay 488 giá trị NULL dạng chuỗi ở biến country bằng “Unknown” để cải thiện trực quan hóa và báo cáo. Tỷ lệ giá trị NULL nhỏ so với toàn bộ dữ liệu (<5%). Xóa những quan sát này có thể làm thiếu hụt các thông tin booking quan trọng còn lại.
	      + Kiểm tra chuỗi rỗng: Dữ liệu không có chuỗi rỗng.
  
- Dữ liệu bất hợp lý:
      + Loại bỏ 180 quan sát có tổng số khách bằng 0. Đây là booking hợp lệ nhưng lại không có người nào ở. Có thể là lỗi nhập liệu, không có cơ sở để thay thế giá trị. Lọc những quan sát có tổng khách lớn hơn 0, dữ liệu còn 119 210 quan sát.
      + Loại bỏ 1 quan sát có giá trị ADR âm. Giá phòng không thể âm. 
      + Loại bỏ 1 quan sát có giá trị ngoại lai ADR = 5 400. Có thể là lỗi nhập liệu. Cao hơn 10 lần giá trị cao thứ hai và cách xa trung vị của biến (94.95). Dữ liệu còn 119 208 quan sát với 16 biến.

2. Tạo biến mới (R)
    Biến	                       Ý nghĩa
total_nights	             Tổng số đêm lưu trú
revenue	                   Doanh thu mỗi booking (chỉ tính booking không hủy)
lead_group	               Phân tổ thời gian đặt trước thành 4 nhóm
guest_group	               Phân loại khách theo các biến adults, children, babies
month_num	                 Mã hóa tháng thành số thứ tự

3. Truy vấn phân tích (SQL Server)
Truy vấn phân tích theo:
- Tỷ lệ hủy phòng:	
      + Số lượng và tỷ lệ hủy chung
      + Số lượng và tỷ lệ hủy theo khách sạn
      + Số lượng và tỷ lệ hủy theo kênh đặt phòng
      + Số lượng và tỷ lệ hủy theo loại đặt cọc
      + Số lượng và tỷ lệ hủy theo thời gian đặt phòng
      + Số lượng và tỷ lệ hủy theo tháng
- Doanh thu: 
      + Biến động ADR theo tháng cho từng loại khách sạn (chỉ những booking không hủy và ADR > 0)
      + Nhóm khách hàng nào có doanh thu trung bình cao nhất? (chỉ những booking không hủy và revenue > 0)
      + Top 5 quốc gia có số lượng booking nhiều nhất
 
4. Tạo Dashboard tổng hợp kết quả (Excel)
- Sử dụng Pivot Table để tổng hợp dữ liệu theo từng chiều phân tích, sau đó tạo biểu đồ và tổng hợp vào Dashboard có Slicer lọc theo năm:
      + Tỷ lệ hủy theo kênh đặt phòng: Biểu đồ thanh nằm ngang
      + Tỷ lệ hủy theo khách sạn: Biểu đồ cột 
      + Tỷ lệ hủy theo loại đặt cọc: Biểu đồ cột 
      + Tỷ lệ hủy theo thời gian đặt phòng: Biểu đồ cột 
      + Tỷ lệ hủy theo tháng: Biểu đồ đường (quan sát xu hướng theo 12 tháng)
      + Doanh thu trung bình theo nhóm khách: Biểu đồ thanh nằm ngang 
      + ADR trung bình theo tháng: Biểu đồ đường (quan sát biến động theo mùa)

III. Kết quả phân tích
- Tỷ lệ hủy chung: 37.08%, cứ 3 booking thì gần 1 cái bị hủy.
- City Hotel có tỷ lệ hủy cao hơn Resort Hotel (41.79% vs 27.77%)
- Khách đặt trước hơn 180 ngày có tỷ lệ hủy cao nhất (57.01%), trong khi nhóm đặt trước 0-30 ngày chỉ 18.58%. Kế hoạch càng dài hạn thì xác suất thay đổi càng cao.
- Loại cọc Non Refund có tỷ lệ hủy gần 100% trên tổng số booking theo loại cọc này.
- Doanh thu trung bình mỗi booking: € 354.10 
- Nhóm khách Contract có doanh thu trung bình cao nhất (€ 532.04)
- ADR của Resort Hotel biến động mạnh theo mùa, cao điểm vào tháng 7-8.
- Resort Hotel đạt ADR cao nhất vào tháng 7-8 (€ 183.69/ đêm), thấp nhất vào tháng 11 (€ 50.15/ đêm). Biên độ dao động gần 4 lần giữa mùa thấp và cao điểm. Resort Hotel phụ thuộc nhiều vào du lịch hè và dễ bị ảnh hưởng khi nhu cầu thấp điểm.
- City Hotel ổn định hơn nhiều, dao động từ € 84.39/ đêm đến € 123.18/ đêm, nhu cầu đặt phòng tương đối ổn định và không phụ thuộc vào mùa vụ.
