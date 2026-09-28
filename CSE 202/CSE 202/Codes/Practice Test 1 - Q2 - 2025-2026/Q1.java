import java.util.*;

public class Q1 {
    public static void main(String[] args) {
        int n = sc.nextInt();
        int m = sc.nextInt();
        int q = sc.nextInt();
        Vertex vertices[] = new Vertex[n];
        for (int i = 0; i < n; i++) {
            vertices[i] = new Vertex(i);
        }
        for (int i = 0; i < m; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            vertices[u].adj.add(vertices[v]);
        }
        for (int i = 0; i < q; i++) {
            int a = sc.nextInt();
            int b = sc.nextInt();
            sb.append(bfs(n, vertices[a], vertices[b])).append("\n");
        }
        System.out.print(sb);
    }

    static String bfs(int n, Vertex a, Vertex b) {
        Queue<Vertex> queue = new LinkedList<>();
        boolean visited[] = new boolean[n];
        visited[a.id] = true;
        queue.add(a);
        while (!queue.isEmpty()) {
            Vertex u = queue.poll();
            for (var v : u.adj) {
                if (!visited[v.id]) {
                    visited[v.id] = true;
                    queue.add(v);
                }
            }
        }
        return visited[b.id] ? "Y" : "N";
    }

    static class Vertex {
        public int id;
        public List<Vertex> adj;

        public Vertex(int id) {
            this.id = id;
            adj = new ArrayList<>();
        }
    }

    static Scanner sc = new Scanner(System.in);
    static StringBuilder sb = new StringBuilder();
}
