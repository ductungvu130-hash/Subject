import java.math.BigInteger;
import java.util.*;

public class EIUSTOCK2 {

    static class Batch {
        long q, p, t;
        public Batch(long q, long p, long t) {
            this.q = q; this.p = p; this.t = t;
        }
    }

    static class Transactions {
        private int id;
        private long quantity; 
        private List<Batch> list; 
        private int head;

        public Transactions(int id) {
            this.id = id;
            this.quantity = 0;
            this.list = new ArrayList<>();
            this.head = 0; 
        }

        public void addIn(long q, long p, long t) { 
            this.list.add(new Batch(q, p, t)); 
            this.quantity += q;
        }

        public void addOut(long q) {
            if (this.quantity < q) return; 
            
            this.quantity -= q;
            long needToRemove = q;
            
            while (needToRemove > 0 && head < list.size()) {
                Batch first = list.get(head); 
                if (first.q <= needToRemove) {
                    needToRemove -= first.q;
                    head++; 
                } else {
                    first.q -= needToRemove; 
                    needToRemove = 0;
                }
            }
        }

        public long getAvg() {
            if (quantity == 0) return 0;
            BigInteger sum = BigInteger.ZERO;
            
            for (int i = head; i < list.size(); i++) {
                Batch b = list.get(i);
                BigInteger bQ = BigInteger.valueOf(b.q);
                BigInteger bP = BigInteger.valueOf(b.p);
                sum = sum.add(bQ.multiply(bP)); 
            }
            return sum.divide(BigInteger.valueOf(quantity)).longValue();
        }

        public long getOldestTime() {
            if (head < list.size()) {
                return list.get(head).t; 
            }
            return 0;
        }
    }

    

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        StringBuilder sb = new StringBuilder();

        String nStr = sc.next();
        if (nStr == null) return;
        int n = Integer.parseInt(nStr);
        
        Map<Integer, Transactions> map = new HashMap<>();

        for (int i = 0; i < n; i++) {
            String inOut = sc.next();
            if (inOut == null) break;
            
            int id = sc.nextInt();
            long quantity = sc.nextLong(); 
            long price = sc.nextLong();
            long time = sc.nextLong(); 

            Transactions t = map.get(id);
            if (t == null) {
                t = new Transactions(id);
                map.put(id, t);
            }

            switch (inOut) {
                case "+":
                    t.addIn(quantity, price, time);
                    break;
                case "-":
                    t.addOut(quantity);
                    break;
            }
        }

        List<Transactions> resultList = new ArrayList<>(map.values());
        resultList.sort((a, b) -> Integer.compare(a.id, b.id));

        for (Transactions tran : resultList) {
            if (tran.quantity > 0) {
                sb.append(tran.id)
                  .append(" ")
                  .append(tran.quantity)
                  .append(" ")
                  .append(tran.getAvg())
                  .append(" ")
                  .append(tran.getOldestTime())
                  .append("\n");
            }
        }
        
        System.out.print(sb.toString());
    }
}