import java.io.*;
import java.util.*;

public class EIUWBT {
    public static void main(String[] args) {
        int n = sc.nextInt();
        Vertex vertices[] = new Vertex[n + 1];
        long totalWeight = 0;
        for (int i = 1; i <= n; i++) {
            vertices[i] = new Vertex(i);
            vertices[i].weight = sc.nextLong();
            totalWeight += vertices[i].weight;
        }
        for (int i = 1; i < n; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            vertices[u].adj.add(vertices[v]);
            vertices[v].adj.add(vertices[u]);
        }
        dfs(vertices[1]);
        // [0] is left weight, [1] is right weight, [2] is node
        long best[] = new long[] { 0, Long.MAX_VALUE, -1 };
        for (int i = 1; i <= n; i++) {
            var u = vertices[i];
            if (u.adj.size() == 2) {
                long TW[] = new long[] { 0, 0, u.id };
                for (int j = 0; j < u.adj.size(); j++) {
                    var v = u.adj.get(j);
                    if (v.weight < u.weight) {
                        TW[j] = v.weight;
                    } else {
                        TW[j] = totalWeight - u.weight;
                    }
                }
                if (Math.abs(best[1] - best[0]) > Math.abs(TW[1] - TW[0])) {
                    best = TW;
                }
            }
        }
        if (best[2] == -1) {
            System.out.println(-1);
        } else {
            System.out.print(best[2] + " ");
            System.out.print(Math.min(best[0], best[1]) + " ");
            System.out.print(Math.max(best[0], best[1]));
        }
    }

    static void dfs(Vertex u) {
        u.visited = true;
        for (var v : u.adj) {
            if (!v.visited) {
                dfs(v);
                u.weight += v.weight;
            }
        }
    }

    static class Vertex {
        public int id;
        public boolean visited;
        public List<Vertex> adj;
        public long weight;

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
