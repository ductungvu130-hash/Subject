import java.io.*;
import java.util.*;

public class EICONP3 {
    public static void main(String[] args) {
        int n = sc.nextInt();
        int m = sc.nextInt();
        Vertex vertice[] = new Vertex[n];
        for (int i = 0; i < n; i++) {
            vertice[i] = new Vertex(i);
        }
        for (int i = 0; i < m; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            vertice[u].adj.add(vertice[v]);
            vertice[v].adj.add(vertice[u]);
        }
        for (int i = 0; i < n; i++) {
            if (!vertice[i].visited) {
                int result[] = bfs(vertice[i]);
                sb.append(i + " " + result[0] + " " + result[1] + "\n");
            }
        }
        System.out.println(sb);
    }

    static int[] bfs(Vertex u) {
        Queue<Vertex> queue = new LinkedList<>();
        u.visited = true;
        queue.add(u);
        int count = 1;
        int edges = u.adj.size();
        while (!queue.isEmpty()) {
            u = queue.poll();
            for (var v : u.adj) {
                if (!v.visited) {
                    v.visited = true;
                    queue.add(v);
                    count++;
                    edges += v.adj.size();
                }
            }
        }
        return new int[] { count, edges >> 1 };
    }

    static class Vertex {
        public int id;
        public boolean visited;
        public List<Vertex> adj;

        public Vertex(int id) {
            this.id = id;
            visited = false;
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
