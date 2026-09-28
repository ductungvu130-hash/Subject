package problem1;

public class Pet {
    private String breed;
    private String age;
    private int weight;

    public Pet(String age, String breed, int weight) {
        this.age = age;
        this.breed = breed;
        this.weight = weight;
    }

    public String getBreed() {
        return breed;
    }

    public String getAge() {
        return age;
    }

    public int getWeight() {
        return weight;
    }

    public void setBreed(String breed) {
        this.breed = breed;
    }

    public void setAge(String age) {
        this.age = age;
    }

    public void setWeight(int weight) {
        this.weight = weight;
    }

    @Override
    public String toString() {
        return "Pet Breed: " + getBreed() + ", Age: " + getAge() + ", Weight: " + getWeight() ;
    }
    
    
}
