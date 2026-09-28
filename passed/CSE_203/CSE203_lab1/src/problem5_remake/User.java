package problem5_remake;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class User {
    private String id;
    private String name;
    private String email;
    private List<BorrowingRecord> historyList;

    public User(String id, String name, String email) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.historyList = new ArrayList<>(); // Khởi tạo danh sách trống
    }

    // GHI CHÚ: Kiểm tra xem user có "hơn 1 cuốn" quá hạn không (> 1)
    public boolean isEligible() {
        int overdueCount = 0;
        LocalDate today = LocalDate.now();
        for (BorrowingRecord record : historyList) {
            // Nếu ngày đến hạn (dueDate) trước ngày hôm nay, tính là quá hạn
            if (record.getDueDate().isBefore(today)) {
                overdueCount++;
            }
        }
        // Trả về true nếu số sách quá hạn <= 1 (theo yêu cầu đề bài)
        return overdueCount <= 1;
    }

    public void addRecord(BorrowingRecord record) {
        this.historyList.add(record);
    }

    public String getName() { 
        return name; }
}