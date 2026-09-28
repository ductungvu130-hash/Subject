import java.io.*;
import java.util.*;

public class EIGROUPSC {
    public static void main(String[] args) {
        int n = sc.nextInt();
        int m = sc.nextInt();
        Vertex vertices[] = new Vertex[n];
        for (int i = 0; i < vertices.length; i++) {
            vertices[i] = new Vertex(i);
            vertices[i].score = sc.nextDouble();
        }
        for (int i = 0; i < m; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            vertices[u].adj.add(vertices[v]);
            vertices[v].adj.add(vertices[u]);
        }
        for (int i = 0; i < vertices.length; i++) {
            if (!vertices[i].visited) {
                double scores[] = bfs(vertices[i]);
                sb.append(scores[0] + " " + scores[1]).append("\n");
            }
        }
        System.out.print(sb);
    }

    static double[] bfs(Vertex root) {
        /* [0] is max Score, [1] is min Score */
        double scores[] = { Integer.MIN_VALUE, Integer.MAX_VALUE };
        Queue<Vertex> queue = new LinkedList<>();
        queue.add(root);
        root.visited = true;
        while (!queue.isEmpty()) {
            var u = queue.poll();
            scores[0] = Math.max(scores[0], u.score);
            scores[1] = Math.min(scores[1], u.score);
            for (var v : u.adj) {
                if (!v.visited) {
                    queue.add(v);
                    v.visited = true;
                }
            }
        }
        return scores;
    }

    static class Vertex {
        public int id;
        public boolean visited;
        public List<Vertex> adj;
        public double score;

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
