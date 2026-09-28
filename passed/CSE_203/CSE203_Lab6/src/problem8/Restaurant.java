package problem8;

import java.util.ArrayList;
import java.util.List;

public class Restaurant {
    private String id;
    private String name;
    private String location;
    private double rating;
    private String phoneNumber;
    private List<MenuItem> menu;

    public Restaurant(String id, String location, String name, String phoneNumber, double rating, List<MenuItem> menu) {
        this.id = id;
        this.location = location;
        this.menu = new ArrayList<>();
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.rating = rating;
    }

    

    @Override
    public String toString() {
        return "Restaurant Id: " + getId() + ", Name: " + getName() + ", Location: " + getLocation()
                + ", Rating: " + getRating() + ", PhoneNumber: " + getPhoneNumber() ;
    }



    public void addMenuItem(MenuItem m){
        menu.add(m);
    }

    public void removeMenuItem(MenuItem m ){
        menu.remove(m);
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getLocation() {
        return location;
    }

    public double getRating() {
        return rating;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public List<MenuItem> getMenu() {
        return menu;
    }


}
