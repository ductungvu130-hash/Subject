import java.io.*;
import java.util.*;

public class EIFBF2 {
    public static void main(String[] args) {
        int n = sc.nextInt();
        int m = sc.nextInt();
        Vertex vertices[] = new Vertex[n + 1];
        for (int i = 1; i <= n; i++) {
            vertices[i] = new Vertex(i);
            vertices[i].gender = sc.next();
        }
        for (int i = 0; i < m; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            vertices[u].adj.add(vertices[v]);
            vertices[v].adj.add(vertices[u]);
        }
        Map<Integer, int[]> components = new HashMap<>();
        for (int i = 1; i <= n; i++) {
            if (!vertices[i].visited) {
                bfs(vertices[i], components);
            }
        }
        for (int i = 1; i <= n; i++) {
            int genders[] = components.get(vertices[i].component);
            sb.append(i + " " + genders[0] + " " + genders[1] + "\n");
        }
        System.out.print(sb);
    }

    static void bfs(Vertex u, Map<Integer, int[]> components) {
        Map<String, Integer> genders = new HashMap<>();
        Queue<Vertex> queue = new LinkedList<>();
        u.visited = true;
        queue.add(u);
        while (!queue.isEmpty()) {
            u = queue.poll();
            u.component = components.size();
            genders.put(u.gender, genders.getOrDefault(u.gender, 0) + 1);
            for (var v : u.adj) {
                if (!v.visited) {
                    v.visited = true;
                    queue.add(v);
                }
            }
        }
        components.put(components.size(), new int[] { genders.getOrDefault("Nam", 0), genders.getOrDefault("Nu", 0) });
    }

    static class Vertex {
        public int id;
        public String gender;
        public int component;
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
