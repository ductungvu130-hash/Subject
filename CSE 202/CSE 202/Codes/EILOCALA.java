import java.io.*;
import java.util.*;

public class EILOCALA {
    public static void main(String[] args) {
        int n = sc.nextInt();
        Vertex vertices[] = new Vertex[n];
        for (int i = 0; i < n; i++) {
            vertices[i] = new Vertex(i);
        }
        for (int i = 1; i < n; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            int w = sc.nextInt();
            vertices[u].adj.add(new Edge(vertices[v], w));
            vertices[v].adj.add(new Edge(vertices[u], w));
        }

        Edge best = new Edge(new Vertex(Integer.MAX_VALUE), -1);
        dfs(vertices[0], 0, best);
        Vertex A = best.vertex;

        for (int i = 0; i < n; i++) {
            vertices[i].visited = false;
        }

        best = new Edge(new Vertex(Integer.MAX_VALUE), -1);
        dfs(A, 0, best);
        Vertex B = best.vertex;

        System.out.print(Math.min(A.id, B.id) + " " + best.weight);
    }

    static void dfs(Vertex u, int distance, Edge best) {
        u.visited = true;
        if (distance > best.weight || (distance == best.weight && u.id < best.vertex.id)) {
            best.vertex = u;
            best.weight = distance;
        }
        for (var v : u.adj) {
            if (!v.vertex.visited) {
                dfs(v.vertex, distance + v.weight, best);
            }
        }
    }

    static class Vertex {
        public int id;
        public boolean visited;
        public List<Edge> adj;

        public Vertex(int id) {
            this.id = id;
            adj = new ArrayList<>();
        }
    }

    static class Edge {
        public Vertex vertex;
        public int weight;

        public Edge(Vertex vertex, int weight) {
            this.vertex = vertex;
            this.weight = weight;
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
