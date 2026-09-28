import java.io.*;
import java.util.*;

public class EIMINDISTA {
    public static void main(String[] args) {
        int n = sc.nextInt();
        int m = sc.nextInt();
        Vertex vertices[] = new Vertex[n];
        for (int i = 0; i < n; i++) {
            vertices[i] = new Vertex(i);
        }
        for (int i = 0; i < m; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            long w = sc.nextLong();
            vertices[u].adj.add(new Edge(vertices[v], w));
            vertices[v].adj.add(new Edge(vertices[u], w));
        }
        dijkstra(vertices[0]);
        for (int i = 1; i < n; i++) {
            sb.append(vertices[i].distance < Long.MAX_VALUE ? vertices[i].distance : -1).append(" ");
        }
        System.out.print(sb);
    }

    static void dijkstra(Vertex root) {
        PriorityQueue<Edge> pq = new PriorityQueue<>((a, b) -> Long.compare(a.weight, b.weight));
        pq.add(new Edge(root, root.distance = 0));
        while (!pq.isEmpty()) {
            var u = pq.poll();
            for (var v : u.vertex.adj) {
                if (v.vertex.distance > u.vertex.distance + v.weight) {
                    pq.add(new Edge(v.vertex, v.vertex.distance = u.vertex.distance + v.weight));
                }
            }
        }
    }

    static class Vertex {
        public int id;
        public boolean visited;
        public List<Edge> adj;
        public long distance;

        public Vertex(int id) {
            this.id = id;
            adj = new ArrayList<>();
            distance = Long.MAX_VALUE;
        }
    }

    static class Edge {
        public Vertex vertex;
        public long weight;

        public Edge(Vertex vertex, long weight) {
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
