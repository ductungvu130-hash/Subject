package problem10;

public class ShipDemo {
    public static void main(String[] args) {
        // Tạo mảng Ship với 3 phần tử [cite: 110]
        Ship[] ships = new Ship[3];

        // Gán các đối tượng khác nhau vào mảng [cite: 110]
        ships[0] = new Ship("Titanic", "1912");
        ships[1] = new CruiseShip("Wonder of the Seas", "2022", 6988);
        ships[2] = new CargoShip("Ever Given", "2018", 220940);

        // Duyệt qua mảng và gọi toString của từng đối tượng 
        System.out.println("--- List of ship ---");
        for (Ship s : ships) {
            System.out.println(s.toString());
            System.out.println("-------------------------");
        }
    }
}
