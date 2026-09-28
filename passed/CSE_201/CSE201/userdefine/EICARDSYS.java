
import java.lang.*;
import java.util.*;

class EICARDSYS {

    static class Customer {

        private String id;

        private long sum;
        private double discount;
        private long totalDiscount;

        public Customer(String id) {
            this.discount = 0;
        
            this.id = id;
            this.sum = 0;
            this.totalDiscount = 0;
        }

        public long discount(long currentBill) {
            
        
            long discount = 0;

            if (this.sum >= 200_000_000L) {          
                discount = (currentBill * 7) / 100;
            } else if (this.sum >= 50_000_000L) {   
                discount = (currentBill * 5) / 100;
            } else if (this.sum >= 20_000_000L) {   
                discount = (currentBill * 3) / 100;
            } else if (this.sum >= 1_000_000L) {    
                discount = (currentBill * 2) / 100;
            }

            this.sum += currentBill;       
            
        
            return discount;
        }
    }

    public static void main(String[] args) throws java.lang.Exception {
        Scanner sc = new Scanner(System.in);
        StringBuilder sb = new StringBuilder();
        
        int n = sc.nextInt();
        long total = 0;
        Map<String,Customer> map = new HashMap<>();

        for(int i =0 ; i < n ; i++){
            String id = sc.next();
            long bill = sc.nextLong();

            
            map.computeIfAbsent(id, Customer -> new Customer(id) );

            total += map.get(id).discount(bill);

        }

        System.out.println(total);
    }
}
