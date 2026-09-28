import java.io.*;
import java.util.*;

public class EILGPTH {
    public static void main(String[] args) {
        int n = sc.nextInt();
        Vertex vertices[] = new Vertex[n];
        for (int i = 0; i < n; i++) {
            vertices[i] = new Vertex(i);
        }
        for (int i = 0; i < n - 1; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            vertices[u].adj.add(vertices[v]);
            vertices[v].adj.add(vertices[u]);
        }
        Edge best = new Edge(new Vertex(-1), 0);
        bfs(n, Arrays.asList(vertices[0]), best);
        int distance[] = bfs(n, Arrays.asList(best.vertex), best);
        var setA = findMaxVertex(vertices, distance, best.weight);
        int distanceA[] = bfs(n, setA, new Edge(new Vertex(-1), 0));
        var setB = findMaxVertex(vertices, distanceA, best.weight);
        int distanceB[] = bfs(n, setB, new Edge(new Vertex(-1), 0));
        for (var vertex : vertices) {
            if (distanceA[vertex.id] + distanceB[vertex.id] == best.weight) {
                best.vertex = vertex;
                break;
            }
        }
        System.out.print(best.vertex.id + " " + best.weight);
    }

    static List<Vertex> findMaxVertex(Vertex vertices[], int distance[], int maxDistance) {
        List<Vertex> list = new ArrayList<>();
        for (var vertex : vertices) {
            if (distance[vertex.id] == maxDistance) {
                list.add(vertex);
            }
        }
        return list;
    }

    static int[] bfs(int n, List<Vertex> startNodes, Edge best) {
        int distance[] = new int[n];
        Arrays.fill(distance, -1);
        Queue<Vertex> queue = new LinkedList<>();
        for (var vertex : startNodes) {
            queue.add(vertex);
            distance[vertex.id] = 0;
        }
        while (!queue.isEmpty()) {
            var u = queue.poll();
            if (best.weight < distance[u.id]) {
                best.vertex = u;
                best.weight = distance[u.id];
            }
            for (var v : u.adj) {
                if (distance[v.id] == -1) {
                    queue.add(v);
                    distance[v.id] = distance[u.id] + 1;
                }
            }
        }
        return distance;
    }

    static class Edge {
        public Vertex vertex;
        public int weight;

        public Edge(Vertex vertex, int weight) {
            this.vertex = vertex;
            this.weight = weight;
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
