import java.util.*;

public class Q1 {
    public static void main(String[] args) {
        int testcases = sc.nextInt();
        while (testcases-- > 0) {
            sb.append(solve()).append("\n");
        }
        System.out.print(sb);
    }

    static String solve() {
        int n = sc.nextInt();
        int m = sc.nextInt();
        Vertex vertices[] = new Vertex[n];
        for (int i = 0; i < n; i++) {
            vertices[i] = new Vertex(i);
        }
        for (int i = 0; i < m; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            vertices[u].adj.add(vertices[v]);
            vertices[v].adj.add(vertices[u]);
        }
        for (int i = 0; i < n; i++) {
            if (!vertices[i].visited) {
                if (dfs(vertices[i])) {
                    return "Yes";
                }
            }
        }
        return "No";
    }

    static boolean dfs(Vertex u) {
        u.visited = true;
        for (var v : u.adj) {
            if (!v.visited) {
                v.distance = u.distance + 1;
                if (dfs(v)) {
                    return true;
                }
            } else {
                int path = u.distance + 1 - v.distance;
                if (path % 2 > 0) {
                    return true;
                }
            }
        }
        return false;
    }

    static class Vertex {
        public int id;
        public boolean visited;
        public List<Vertex> adj;
        public int distance;

        public Vertex(int id) {
            this.id = id;
            adj = new ArrayList<>();
        }
    }

    static Scanner sc = new Scanner(System.in);
    static StringBuilder sb = new StringBuilder();
}
