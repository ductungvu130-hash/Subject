import java.util.*;

public class Q2 {
    public static void main(String[] args) {
        int n = sc.nextInt();
        int m = sc.nextInt();
        Vertex vertices[] = new Vertex[n];
        List<Integer> levels[] = new List[n];
        for (int i = 0; i < n; i++) {
            vertices[i] = new Vertex(i);
            levels[i] = new ArrayList<>();
        }
        for (int i = 0; i < m; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            vertices[u].adj.add(vertices[v]);
            vertices[v].adj.add(vertices[u]);
        }
        int start = sc.nextInt();
        bfs(vertices[start]);
        for (var each : vertices) {
            levels[each.level].add(each.id);
        }
        for (int i = 0; i < n; i++) {
            levels[i].sort((a, b) -> a - b);
        }
        int q = sc.nextInt();
        for (int i = 0; i < q; i++) {
            int k = sc.nextInt();
            if (levels[k].isEmpty()) {
                sb.append(-1);
            } else {
                for (var each : levels[k]) {
                    sb.append(each).append(" ");
                }
            }
            sb.append("\n");
        }
        System.out.print(sb);
    }

    static void bfs(Vertex u) {
        Queue<Vertex> queue = new LinkedList<>();
        u.visited = true;
        queue.add(u);
        while (!queue.isEmpty()) {
            u = queue.poll();
            for (var v : u.adj) {
                if (!v.visited) {
                    v.visited = true;
                    v.level = u.level + 1;
                    queue.add(v);
                }
            }
        }
    }

    static class Vertex {
        public int id;
        public int level;
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
