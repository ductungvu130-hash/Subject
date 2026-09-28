import java.io.*;
import java.util.*;

public class EIMINSPAN_Kruskal {
    public static void main(String[] args) {
        int n = sc.nextInt();
        int m = sc.nextInt();

        Vertex vertices[] = new Vertex[n];
        for (int i = 0; i < n; i++) {
            vertices[i] = new Vertex(i);
        }

        List<Edge> edges = new ArrayList<>();
        for (int i = 0; i < m; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            int w = sc.nextInt();
            edges.add(new Edge(vertices[u], vertices[v], w));
        }
        edges.sort((a, b) -> a.w - b.w);

        DSU dsu = new DSU(n);

        int countEdge = 0;
        long totalWeight = 0;
        for (var edge : edges) {
            if (dsu.union(edge.u, edge.v)) {
                totalWeight += edge.w;
                countEdge++;
            }
            if (countEdge == n - 1) {
                // Hoan thanh cay gom N-1 canh
                break;
            }
        }
        System.out.print(countEdge == n - 1 ? totalWeight : -1);
    }

    static class DSU {
        public int parent[];

        public DSU(int n) {
            parent = new int[n + 1];
            for (int i = 0; i <= n; i++) {
                parent[i] = i;
            }
        }

        public boolean union(Vertex u, Vertex v) {
            int a = find(u.id);
            int b = find(v.id);
            if (a != b) {
                parent[a] = b;
                return true;
            }
            return false;
        }

        public int find(int n) {
            if (parent[n] != n) {
                parent[n] = find(parent[n]);
            }
            return parent[n];
        }
    }

    static class Edge {
        public Vertex u;
        public Vertex v;
        public int w;

        public Edge(Vertex u, Vertex v, int w) {
            this.u = u;
            this.v = v;
            this.w = w;
        }
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

    /*
     * Don't see below
     */

    static Reader sc = new Reader();
    static StringBuilder sb = new StringBuilder();
    static Random rd = new Random();

    static class Reader {
        private int BUFFER_SIZE = 1 << 16;
        private byte[] buffer = new byte[BUFFER_SIZE];
        private int bufferPointer = 0, bytesRead = 0;
        private InputStream rd;

        public Reader() {
            this.rd = System.in;
        }

        private byte read() {
            if (bufferPointer == bytesRead) {
                bufferPointer = 0;
                try {
                    bytesRead = rd.read(buffer, bufferPointer, BUFFER_SIZE);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                if (bytesRead == -1) {
                    return -1;
                }
            }
            return buffer[bufferPointer++];
        }

        public boolean hasNext() {
            int c = read();
            while (c <= ' ' && c != -1) {
                c = read();
            }
            if (c == -1) {
                return false;
            }
            bufferPointer--;
            return true;
        }

        public int nextInt() {
            int number = 0;
            int c = read();
            while (c <= ' ') {
                c = read();
            }
            boolean negative = (c == '-');
            if (negative) {
                c = read();
            }
            do {
                number = number * 10 + (c - '0');
                c = read();
            } while (c >= '0' && c <= '9');
            return negative ? -number : number;
        }

        public long nextLong() {
            long number = 0L;
            int c = read();
            while (c <= ' ') {
                c = read();
            }
            boolean negative = (c == '-');
            if (negative) {
                c = read();
            }
            do {
                number = number * 10 + (c - '0');
                c = read();
            } while (c >= '0' && c <= '9');
            return negative ? -number : number;
        }

        public String next() {
            int c = read();
            while (c <= ' ') {
                c = read();
            }
            StringBuilder t = new StringBuilder();
            do {
                t.append((char) c);
                c = read();
            } while (c > ' ');
            return t.toString();
        }

        public String nextLine() {
            int c = read();
            while (c == '\n' || c == '\r') {
                c = read();
            }
            StringBuilder t = new StringBuilder();
            while (c != '\n' && c != '\r' && c != -1) {
                t.append((char) c);
                c = read();
            }
            return t.toString();
        }

        public double nextDouble() {
            return Double.parseDouble(next());
        }

        public char nextChar() {
            int c = read();
            while (c <= ' ') {
                c = read();
            }
            return (char) c;
        }
    }
}
