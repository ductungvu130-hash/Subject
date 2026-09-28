import java.io.*;
import java.util.*;

public class EIFOLTRE2 {
    public static void main(String[] args) {
        int n = sc.nextInt();
        Vertex vertice[] = new Vertex[n];
        for (int i = 0; i < n; i++) {
            vertice[i] = new Vertex(i);
        }

        Map<String, Integer> map = new HashMap<>();
        for (int i = 1; i < n; i++) {
            String nameU = sc.next();
            String nameV = sc.next();

            int u = get(map, nameU);
            int v = get(map, nameV);

            vertice[u].name = nameU;
            vertice[v].name = nameV;

            vertice[u].adj.add(vertice[v]);
            vertice[v].adj.add(vertice[u]);
        }
        for (int i = 0; i < n; i++) {
            vertice[i].adj.sort((a, b) -> a.name.compareToIgnoreCase(b.name));
        }

        String nameNode = sc.next();
        int node = get(map, nameNode);

        dfs(vertice[node], "");
        System.out.println(sb);
    }

    static void dfs(Vertex u, String s) {
        u.visited = true;
        sb.append(u.name).append("\n");
        List<Vertex> children = new ArrayList<>();
        for (Vertex v : u.adj) {
            if (!v.visited) {
                children.add(v);
            }
        }

        for (int i = 0; i < children.size(); i++) {
            Vertex v = children.get(i);
            boolean isLast = (i == children.size() - 1);
            sb.append(s).append(isLast ? "\u2514\u2500\u2500\u2500" : "\u251C\u2500\u2500\u2500");
            dfs(v, s + (isLast ? "    " : "\u2502   "));

        }
    }

    static int get(Map<String, Integer> map, String n) {
        if (!map.containsKey(n)) {
            map.put(n, map.size());
        }
        return map.get(n);
    }

    static class Vertex {
        public int id;
        public String name;
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
