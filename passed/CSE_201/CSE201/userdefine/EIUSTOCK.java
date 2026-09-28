import java.util.*;

public class EIUSTOCK {

    static class Transactions {
        private int id;
        private long totalIn;
        private long totalOut;
        private long quantity;
        
       
        private boolean hasSuccess; 

        public Transactions(int id) {
            this.id = id;
            this.totalIn = 0;
            this.totalOut = 0;
            this.quantity = 0;
            this.hasSuccess = false;
        }

        public void addIn(long q, long p) { 
            this.quantity += q;
            this.totalIn += q * p;
            this.hasSuccess = true; 
        }

        public void addOut(long q, long p) {
            this.totalOut += q * p;
            this.quantity -= q;
            this.hasSuccess = true; 
        }
    }

    

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        StringBuilder sb = new StringBuilder();

        int n = sc.nextInt();
        
        Map<Integer, Transactions> map = new HashMap<>();

        for (int i = 0; i < n; i++) {
            String inOut = sc.next();
            
            int id = sc.nextInt();
            long quantity = sc.nextLong(); 
            long price = sc.nextLong();

            Transactions t = map.get(id);
            if (t == null) {
                t = new Transactions(id);
                map.put(id, t);
            }

            switch (inOut) {
                case "+":
                    t.addIn(quantity, price);
                    break;
                case "-":
                   
                    if (t.quantity >= quantity) {
                        t.addOut(quantity, price);
                    }
                    break;
            }
        }

        List<Transactions> list = new ArrayList<>(map.values());

        list.sort((a, b) -> Integer.compare(a.id, b.id));

        for (Transactions tran : list) {
           
            if (tran.hasSuccess) {
                sb.append(tran.id)
                  .append(" ")
                  .append(tran.totalIn)
                  .append(" ")
                  .append(tran.totalOut)
                  .append("\n");
            }
        }
        
        System.out.print(sb.toString());
    }
}