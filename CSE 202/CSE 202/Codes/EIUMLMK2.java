import java.io.*;
import java.util.*;

public class EIUMLMK2 {
    public static void main(String[] args) {
        int n = sc.nextInt();
        Vertex vertices[] = new Vertex[n];
        for (int i = 0; i < n; i++) {
            vertices[i] = new Vertex(i);
            vertices[i].countChild = 1;
        }
        for (int i = 1; i < n; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            vertices[u].adj.add(vertices[v]);
            vertices[v].adj.add(vertices[u]);
        }
        buildTree(vertices[0]);
        for (int i = 0; i < n; i++) {
            vertices[i].visited = false;
            vertices[i].maxMoney = sc.nextLong();
        }
        long price = sc.nextLong();
        if (vertices[0].maxMoney >= price) {
            bfs(vertices[0], price);
        }
        for (var vertex : vertices) {
            sb.append(vertex.countProduct).append(" ");
        }
        System.out.println(sb);
    }

    static void bfs(Vertex root, long price) {
        Queue<Edge> queue = new LinkedList<>();
        queue.add(new Edge(root, price));
        root.visited = true;
        while (!queue.isEmpty()) {
            Vertex u = queue.peek().vertex;
            u.countProduct = u.countChild;
            long nextPrice = (long) (queue.poll().price * 1.1);
            for (var v : u.adj) {
                if (!v.visited) {
                    if (nextPrice <= v.maxMoney) {
                        u.countProduct -= v.countChild;
                        queue.add(new Edge(v, nextPrice));
                        v.visited = true;
                    }
                }
            }
        }
    }

    static class Edge {
        public Vertex vertex;
        public long price;

        public Edge(Vertex vertex, long price) {
            this.vertex = vertex;
            this.price = price;
        }
    }

    static void buildTree(Vertex u) {
        u.visited = true;
        for (var v : u.adj) {
            if (!v.visited) {
                buildTree(v);
                u.countChild += v.countChild;
            }
        }
    }

    static class Vertex {
        public int id;
        public boolean visited;
        public List<Vertex> adj;
        public int countChild;
        public long maxMoney;
        public int countProduct;

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
