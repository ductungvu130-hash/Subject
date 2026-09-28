import java.util.*;

public class Q3 {
    public static void main(String[] args) {
        int n = sc.nextInt();
        int m = sc.nextInt();
        Vertex vertices[] = new Vertex[n + 1];
        for (int i = 1; i <= n; i++) {
            vertices[i] = new Vertex(i);
        }
        DSU dsu = new DSU(n);
        for (int i = 0; i < m; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            vertices[u].adj.add(vertices[v]);
            vertices[v].adj.add(vertices[u]);
            dsu.union(vertices[u], vertices[v]);
        }
        if (dsu.components > 1) {
            System.out.println("Disconnected graph");
        } else if (m != n - 1) {
            System.out.println("Connected graph");
        } else {
            var V = limit(vertices);
            var root = (V.size() > 1 ? Math.min(V.get(0).id, V.get(1).id) : V.get(0).id);
            System.out.println("Tree " + root + " " + bfs(vertices[root]));
        }
    }

    static int bfs(Vertex root) {
        Queue<Vertex> queue = new LinkedList<>();
        queue.add(root);
        root.visited = true;
        int maxLength = 0;
        while (!queue.isEmpty()) {
            var u = queue.poll();
            for (var v : u.adj) {
                if (!v.visited) {
                    queue.add(v);
                    v.visited = true;
                    v.distance = u.distance + 1;
                    maxLength = Math.max(maxLength, v.distance);
                }
            }
        }
        return maxLength;
    }

    static List<Vertex> limit(Vertex vertices[]) {
        Queue<Vertex> queue = new LinkedList<>();
        for (int i = 1; i < vertices.length; i++) {
            vertices[i].degree = vertices[i].adj.size();
            if (vertices[i].degree == 1) {
                queue.add(vertices[i]);
            }
        }
        int notLoang = vertices.length - 1;
        while (notLoang > 2) {
            int queueSize = queue.size();
            notLoang -= queueSize;
            for (int i = 0; i < queueSize; i++) {
                var u = queue.poll();
                for (var v : u.adj) {
                    if (v.degree > 1 && --v.degree == 1) {
                        queue.add(v);
                    }
                }
            }
        }
        return new ArrayList<>(queue);
    }

    static class DSU {
        public int components;
        public int parent[];

        public DSU(int size) {
            components = size;
            parent = new int[size + 1];
            Arrays.fill(parent, -1);
        }

        public boolean union(Vertex a, Vertex b) {
            int u = find(a.id);
            int v = find(b.id);
            if (u != v) {
                components--;
                parent[u] = v;
                return true;
            }
            return false;
        }

        public int find(int n) {
            return parent[n] < 0 ? n : (parent[n] = find(parent[n]));
        }
    }

    static class Vertex {
        public int id;
        public boolean visited;
        public List<Vertex> adj;
        public int degree;
        public int distance;

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
}
