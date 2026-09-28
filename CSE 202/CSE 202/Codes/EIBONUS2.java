import java.io.*;
import java.util.*;

public class EIBONUS2 {
    public static void main(String[] args) {
        int n = sc.nextInt();
        double money = sc.nextDouble();
        Vertex vertices[] = new Vertex[n];
        for (int i = 0; i < n; i++) {
            vertices[i] = new Vertex(i);
        }
        for (int i = 1; i < n; i++) {
            vertices[i].weight = sc.nextDouble();
        }
        for (int i = 0; i < n - 1; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            vertices[u].adj.add(vertices[v]);
        }
        vertices[0].total = money;
        dfs(vertices[0], -1);
        for (var vertex : vertices) {
            if (vertex.adj.isEmpty()) {
                sb.append(Math.round(vertex.total)).append("\n");
            }
        }
        System.out.print(sb);
    }

    static void dfs(Vertex u, int parent) {
        u.visited = true;
        double sum = u.sum();
        if (sum > 0) {
            for (var v : u.adj) {
                if (v.id != parent) {
                    v.total += v.weight * u.total / sum;
                    dfs(v, u.id);
                }
            }
        }
    }

    static class Vertex implements Comparable<Vertex> {
        public int id;
        public boolean visited;
        public List<Vertex> adj;
        public double weight;
        public double total;

        public Vertex(int id) {
            this.id = id;
            adj = new ArrayList<>();
        }

        public double sum() {
            double cnt = 0;
            for (var v : adj) {
                if (!v.visited) {
                    cnt += v.weight;
                }
            }
            return cnt;
        }

        @Override
        public int compareTo(Vertex other) {
            return Integer.compare(this.id, other.id);
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
