
import java.lang.*;
import java.util.*;

class Main {

    static class Transactions {

        private int id;
        private long totalIn;
        private long totalOut;
        private int quantity;

        public Transactions(int id) {
            this.id = id;
            this.totalIn = 0;
            this.totalOut = 0;
            this.quantity = 0;
        }

        public void addIn(int q, int p) {
            this.quantity += q;
            this.totalIn += q * p;
        }

        public void addOut(int q, int p) {
            this.totalOut += q * p;
            this.quantity -= q;
        }

    }

    public static void main(String[] args) throws java.lang.Exception {
        Scanner sc = new Scanner(System.in);
        StringBuilder sb = new StringBuilder();

        int n = sc.nextInt();
        
        Map<Integer, Transactions> map = new HashMap<>();

        for (int i = 0; i < n; i++) {
            String inOut = sc.next();
            int id = sc.nextInt();
            int quantity = sc.nextInt();
            int price = sc.nextInt();

            if (!map.containsKey(id)) {
                map.put(id, new Transactions(id));
            }

            switch (inOut) {
                case "+":
                    map.get(id).addIn(quantity, price);
                    break;
                case "-":
                    if (map.get(id).quantity >= quantity) {
                        map.get(id).addOut(quantity, price);
                    }
                    else{
                         map.get(id).addOut(0, 0);
                    }
            }

        }

        List<Transactions> list = new ArrayList<>(map.values());

        list.sort((a, b) -> {
            return Integer.compare(a.id, b.id);
        });

        for (Transactions tran : list) {
            sb.append(tran.id)
                    .append(" ")
                    .append(tran.totalIn)
                    .append(" ")
                    .append(tran.totalOut)
                    .append("\n");
        }
        System.out.println(sb.toString().trim());
    }
}
