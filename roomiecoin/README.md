# RoomieCoin – Website Demo

Toàn bộ giao diện tĩnh (HTML + Tailwind CDN) của dự án **RoomieCoin**, đã được gộp
vào 1 thư mục và liên kết điều hướng giữa các trang.

## Cấu trúc trang

| File | Chức năng |
|---|---|
| `index.html` | Tổng quan / Dashboard (trang chủ) |
| `login.html` | Đăng nhập / Tham gia |
| `create-room.html` | Tạo phòng mới |
| `room.html` | Phòng của bạn (quản lý thành viên) |
| `add-expense.html` | Thêm chi phí / hóa đơn |
| `history.html` | Lịch sử chi phí |
| `settle.html` | Tất toán |
| `chores.html` | Việc nhà |
| `profile.html` | Hồ sơ cá nhân |
| `edit-profile.html` | Chỉnh sửa thông tin cá nhân |
| `notifications.html` | Thông báo |
| `settings.html` | Cài đặt |

## Cách xem

Mở `index.html` bằng trình duyệt (cần internet để tải Tailwind CDN + font).
Thanh điều hướng bên trái, chuông thông báo, icon cài đặt, và avatar ở mọi
trang đều đã trỏ đúng sang các trang tương ứng ở trên.

## Ghi chú

- Mỗi màn hình được Stitch xuất ra độc lập nên có thể lệch nhẹ tông màu giữa
  các trang — đây là đặc điểm gốc của bộ thiết kế, không phải lỗi liên kết.
- File `roomiecoin_project_brief_prd.md` đi kèm mô tả đầy đủ tính năng & hệ
  thống thiết kế của dự án.

## Chức năng JS đã bổ sung (v2)

- `app.js`: thư viện dùng chung (toast thông báo, lưu trữ localStorage, sao chép clipboard, dark-mode, menu thả xuống, đồng bộ số thông báo chưa đọc).
- **Thêm chi phí** → lưu vào lịch sử thực tế, chia tiền theo số người được chọn (chia đều / tùy chỉnh).
- **Lịch sử chi phí** → hiển thị các khoản chi mới thêm, lọc theo danh mục/người chi.
- **Việc nhà**: tick hoàn thành sẽ chuyển thẻ sang cột "Đã xong", thêm việc mới.
- **Thông báo**: bấm để đánh dấu đã đọc, lọc "Chưa đọc", số lượng chưa đọc đồng bộ với chuông ở mọi trang.
- **Tất toán**: mở modal QR theo đúng khoản nợ, xác nhận thanh toán sẽ xoá khoản nợ & cập nhật tổng.
- **Phòng của bạn**: sao chép mã mời, chỉnh sửa tên phòng, sắp xếp/thao tác thành viên, xoá thành viên.
- **Hồ sơ / Chỉnh sửa hồ sơ**: lưu tên, email, số điện thoại, thông tin ngân hàng — đồng bộ hai chiều.
- **Cài đặt**: bật/tắt giao diện tối (áp dụng toàn site), lưu tuỳ chọn thông báo & ngôn ngữ.
- **Đăng nhập**: hiện/ẩn mật khẩu, mô phỏng quên mật khẩu.
- **Tạo phòng mới**: kiểm tra tên phòng trước khi tạo.

Toàn bộ dữ liệu lưu bằng `localStorage` (khoá tiền tố `rc_`) — dữ liệu demo, không có backend thật.
