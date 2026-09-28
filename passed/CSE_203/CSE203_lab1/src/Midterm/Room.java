package Midterm;

public class Room {
    private String id;
    private double area;
    private long price;
    private RoomStatus status;

    public Room() {
        this.id = "default room ID";
        this.area = 0.0;
        this.price = 0;
        this.status = RoomStatus.CHECKEDOUT;
    }

    public Room(String id, double area, long price) {
        this.id = id;
        this.area = area;
        this.price = price;
        this.status = RoomStatus.CHECKEDOUT;
    }

    public boolean equals(Room room) {
        if (room == null) return false;
        return this.id.equals(room.id);
    }

    public String getId() { return id; }
    public RoomStatus getStatus() { return status; }
    public void setStatus(RoomStatus status) { this.status = status; }
}