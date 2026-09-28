import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class EIHPROFIT {

    static class Product{
        private int iden;
        private String name;
        private long price; 
        private long cost;
        private long quantity;
        private long profit;

        public Product(int iden, String name, long price, long cost, long quantity) {
            this.cost = cost;
            this.iden = iden;
            this.name = name;
            this.price = price;
            this.quantity = quantity;
        }
        
        public void caculate(){
            this.profit = (this.price - this.cost) * this.quantity;
        }
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        StringBuilder sb = new StringBuilder();

        if (!sc.hasNextInt()) return;

        int n = sc.nextInt();
        int k = sc.nextInt();

        List<Product> list = new ArrayList<>();

        for (int i = 0; i < n ; i++){
            int iden = sc.nextInt();
            String name = sc.next();
            long price = sc.nextLong();
            long cost = sc.nextLong();  
            long quan = sc.nextLong();  

            Product pro1 = new Product(iden, name, price, cost, quan);
            list.add(pro1);
        }
        
        for(Product s : list){
            s.caculate();
        }

        list.sort((a,b) -> {
            int index = Long.compare(b.profit, a.profit);

            if(index == 0){
                return Integer.compare(a.iden, b.iden);
            }
            
            return index;
        });

               
        long finalProfit = list.get(k - 1).profit;

        for( int i = 0 ; i < n ; i++){
            Product p = list.get(i);
            if (i < k || finalProfit == p.profit) {
                sb.append(p.iden).append(" ").append(p.name).append(" ").append(p.profit).append("\n");
            } else {
                break; 
            }
        }
        System.out.print(sb.toString());
    }
}