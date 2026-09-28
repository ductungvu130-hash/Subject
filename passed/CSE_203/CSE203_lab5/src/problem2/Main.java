package problem2;

import java.util.*;

public class Main {

    public static void main(String[] args) {
        Set<Instructor> instructorSet = new HashSet<>();

        // Thêm dữ liệu
        instructorSet.add(new Instructor("INS01", "Nguyen Van A"));
        instructorSet.add(new Instructor("INS02", "Tran Thi B"));
        instructorSet.add(new Instructor("INS01", "Nguyen Van A")); // Trùng ID, sẽ bị loại bỏ

        // Hiển thị danh sách
        System.out.println("List of instructors: ");
        instructorSet.forEach(System.out::println);

        // Tìm kiếm
        String searchId = "INS01";
        boolean found = instructorSet.stream().anyMatch(i -> i.getId().equals(searchId));
        System.out.println("\nSearch for ID '" + searchId + "': " + (found ? "Found" : "Not found"));
    }
}
