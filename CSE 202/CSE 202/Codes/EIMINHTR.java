import java.io.*;
import java.util.*;

public class EIMINHTR {
    public static void main(String[] args) {
        int n = sc.nextInt();
        Vertex vertices[] = new Vertex[n];
        for (int i = 0; i < n; i++) {
            vertices[i] = new Vertex(i);
        }
        for (int i = 1; i < n; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            vertices[u].degree++;
            vertices[v].degree++;
            vertices[u].adj.add(vertices[v]);
            vertices[v].adj.add(vertices[u]);
        }
        var list = limit(vertices);
        var root = list.size() > 1 ? Math.min(list.get(0).id, list.get(1).id) : list.get(0).id;
        System.out.print(root + " " + bfs(n, vertices[root]));
    }

    static int bfs(int n, Vertex root) {
        int distance[] = new int[n];
        boolean visited[] = new boolean[n];
        Queue<Vertex> queue = new LinkedList<>();
        queue.add(root);
        visited[root.id] = true;
        while (!queue.isEmpty()) {
            var u = queue.poll();
            for (var v : u.adj) {
                if (!visited[v.id]) {
                    queue.add(v);
                    visited[v.id] = true;
                    distance[v.id] = distance[u.id] + 1;
                }
            }
        }
        return Arrays.stream(distance).max().getAsInt();
    }

    static List<Vertex> limit(Vertex vertices[]) {
        Queue<Vertex> queue = new LinkedList<>();
        for (var vertex : vertices) {
            if (vertex.degree == 1) {
                queue.add(vertex);
            }
        }
        int remainingVertices = vertices.length;
        while (remainingVertices > 2) {
            int size = queue.size();
            remainingVertices -= size;
            for (int i = 0; i < size; i++) {
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

    static class Vertex {
        public int id;
        public int degree;
        public List<Vertex> adj;

        public Vertex(int id) {
            this.id = id;
            adj = new ArrayList<>();
        }
    }

    static int answer = Integer.MAX_VALUE;

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
