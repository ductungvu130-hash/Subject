package problem8;

import java.time.LocalDate;

public class Demo {
    public static void main(String[] args) {
        Customer customer1 = new Customer("Nguyen Van A", "123 Le Loi, TP.HCM", "0909123456");
        Customer customer2 = new Customer("Tran Thi B", "456 Nguyen Hue, Ha Noi", "0918654321");

        Booking weddingBooking = new Booking(customer1, SessionType.WEDDING, LocalDate.of(2026, 10, 20), 240);
        weddingBooking.setBaseFee(1500.00);
        weddingBooking.setEditingFee(300.00);
        System.out.println(weddingBooking.generateConfirmation());

        Booking familyBooking = new Booking(customer2, SessionType.FAMILY, LocalDate.now(), 60);
        familyBooking.setBaseFee(200.00);
        familyBooking.setEditingFee(50.00);
        System.out.println(familyBooking.generateConfirmation());
    }
}