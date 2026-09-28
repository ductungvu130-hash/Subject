package question6;

public class Demonstration {
    public static void main(String[] args) {
        // 1. Tạo 2 viên xúc xắc khác nhau
        Dice die6 = new Dice(6);
        Dice die20 = new Dice(20);

            
        System.out.println("6 side:");
        for (int i = 1; i <= 3; i++) {
            die6.roll();
            System.out.println("Times " + i + ": " + die6.getValue());
        }

        System.out.println();

        System.out.println("20 side");
        for (int i = 1; i <= 3; i++) {
            die20.roll();
            System.out.println("Times " + i + ": " + die20.getValue());
        }
    }
}
