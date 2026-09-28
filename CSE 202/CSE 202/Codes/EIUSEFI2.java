import java.io.*;
import java.util.*;

public class EIUSEFI2 {
    public static void main(String[] args) {
        int n = sc.nextInt();
        Vertex vertices[] = new Vertex[n];
        for (int i = 0; i < n; i++) {
            vertices[i] = new Vertex(i);
        }
        Map<String, Integer> map = new HashMap<>();
        for (int i = 1; i < n; i++) {
            String nameU = sc.next();
            String nameV = sc.next();
            int u = get(map, nameU);
            int v = get(map, nameV);
            vertices[u].name = nameU;
            vertices[v].name = nameV;
            vertices[u].adj.add(vertices[v]);
            vertices[v].adj.add(vertices[u]);
        }
        for (var vertex : vertices) {
            vertex.lowerName = vertex.name.toLowerCase();
            vertex.adj.sort((a, b) -> a.name.compareToIgnoreCase(b.name));
        }
        int root = get(map, sc.next());
        String word = sc.next();
        dfs(vertices[root], word);
        System.out.print(sb);
    }

    static int dfs(Vertex u, String word) {
        u.visited = true;
        var list = countChild(u);
        if (list.isEmpty()) {
            return u.lowerName.contains(word) ? 1 : 0;
        } else {
            int count = 0;
            for (var v : list) {
                if (!v.visited) {
                    count += dfs(v, word);
                }
            }
            if (count > 0) {
                sb.append(u.name + " " + count + "\n");
            }
            return count;
        }
    }

    static List<Vertex> countChild(Vertex u) {
        List<Vertex> list = new ArrayList<>();
        for (var v : u.adj) {
            if (!v.visited) {
                list.add(v);
            }
        }
        return list;
    }

    static int get(Map<String, Integer> map, String name) {
        map.putIfAbsent(name, map.size());
        return map.get(name);
    }

    static class Vertex {
        public int id;
        public boolean visited;
        public List<Vertex> adj;
        public String name;
        public String lowerName;

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
