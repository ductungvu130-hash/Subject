import java.util.*;

public class Q2 {
    public static void main(String[] args) {
        int n = sc.nextInt();
        Vertex vertices[] = new Vertex[n];
        for (int i = 0; i < n; i++) {
            vertices[i] = new Vertex(i);
            vertices[i].water = sc.nextDouble();
        }
        for (int i = 1; i < n; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            vertices[v].adj.add(vertices[u]);
        }
        dfs(vertices[0]);
        for (var vertex : vertices) {
            if (vertex.water > 0) {
                vertex.water = Math.round(vertex.water * 1e4) / 1e4;
                sb.append(vertex.id).append(" ").append(vertex.water).append("\n");
            }
        }
        System.out.print(sb);
    }

    static void dfs(Vertex u) {
        u.visited = true;
        var children = u.children();
        if (!children.isEmpty()) {
            for (var v : children) {
                if (!v.visited) {
                    v.water += u.water / children.size();
                    dfs(v);
                }
            }
            u.water = 0;
        }
    }

    static class Vertex {
        public int id;
        public boolean visited;
        public List<Vertex> adj;
        public double water;

        public Vertex(int id) {
            this.id = id;
            adj = new ArrayList<>();
        }

        public List<Vertex> children() {
            List<Vertex> list = new ArrayList<>();
            for (var v : adj) {
                if (!v.visited) {
                    list.add(v);
                }
            }
            return list;
        }
    }

    static Scanner sc = new Scanner(System.in);
    static StringBuilder sb = new StringBuilder();
}
