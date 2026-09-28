import java.io.*;
import java.util.*;

public class EIFBIPARTIE {
    public static void main(String[] args) {
        int m = sc.nextInt();
        int n = sc.nextInt();
        int leftSet[] = new int[m];
        for (int i = 0; i < m; i++) {
            leftSet[i] = sc.nextInt();
        }
        Arrays.sort(leftSet);
        int rightSet[] = new int[n];
        for (int i = 0; i < n; i++) {
            rightSet[i] = sc.nextInt();
        }
        Arrays.sort(rightSet);

        List<int[]> edges = new ArrayList<>();
        for (var leftVertex : leftSet) {
            for (var rightVertex : rightSet) {
                int u = Math.min(leftVertex, rightVertex);
                int v = Math.max(leftVertex, rightVertex);
                edges.add(new int[] { u, v });
            }
        }
        edges.sort((a, b) -> {
            int compare = a[0] - b[0];
            if (compare == 0) {
                compare = a[1] - b[1];
            }
            return compare;
        });
        for (var edge : edges) {
            sb.append(edge[0] + " " + edge[1] + "\n");
        }
        System.out.print(sb);
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
