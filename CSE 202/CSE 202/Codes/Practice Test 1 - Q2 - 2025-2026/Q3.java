import java.util.*;

public class Q3 {
    public static void main(String[] args) {
        int U = sc.nextInt();
        int P = sc.nextInt();
        int M = sc.nextInt();
        Vertex users[] = new Vertex[U];
        Vertex products[] = new Vertex[P];
        for (int i = 0; i < U; i++) {
            users[i] = new Vertex(i);
        }
        for (int i = 0; i < P; i++) {
            products[i] = new Vertex(i);
        }
        for (int i = 0; i < M; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            users[u].adj.add(products[v]);
            products[v].adj.add(users[u]);
        }
        for (int i = 0; i < P; i++) {
            Map<Integer, Integer> map = new HashMap<>();
            for (var user : products[i].adj) {
                for (var product : user.adj) {
                    map.put(product.id, map.getOrDefault(product.id, 0) + 1);
                }
            }
            int id = -1, max = 0;
            for (var entry : map.entrySet()) {
                if (entry.getKey() != i) {
                    if (entry.getValue() > max) {
                        id = entry.getKey();
                        max = entry.getValue();
                    } else if (entry.getValue() == max && id > entry.getKey()) {
                        id = entry.getKey();
                    }
                }
            }
            sb.append(id + " " + max).append("\n");
        }
        System.out.print(sb);
    }

    static class Vertex {
        public int id;
        public boolean visited;
        public List<Vertex> adj;

        public Vertex(int id) {
            this.id = id;
            adj = new ArrayList<>();
        }
    }

    static Scanner sc = new Scanner(System.in);
    static StringBuilder sb = new StringBuilder();
}
