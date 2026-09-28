import java.io.*;
import java.util.*;

public class EICONP4 {
    public static void main(String[] args) {
        int n = sc.nextInt();
        int m = sc.nextInt();
        DSU dsu = new DSU(n);
        for (int i = 0; i < m; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            if (dsu.union(u, v)) {
            }
        }
        /*
         * m: canh
         * n: dinh -> se can (n-1) canh
         * c: mien lien thong -> can (c-1) canh
         * -> so canh da co la (n-1) - (c-1) = n-c
         * -> so canh du: m - (n-c)
         * -> so canh du + so canh can = m - (n-c) + (c-1) = m - n - 1 + 2c
         */
        System.out.print(m - n - 1 + 2 * dsu.components);
    }

    static class DSU {
        public int lab[];
        public int components;

        public DSU(int n) {
            components = n;
            lab = new int[n];
            Arrays.fill(lab, -1);
        }

        public boolean union(int u, int v) {
            u = find(u);
            v = find(v);
            if (u != v) {
                if (lab[u] < lab[v]) {
                    lab[u] += lab[v];
                    lab[v] = u;
                } else {
                    lab[v] += lab[u];
                    lab[u] = v;
                }
                components--;
                return true;
            }
            return false;
        }

        public int find(int n) {
            return lab[n] < 0 ? n : (lab[n] = find(lab[n]));
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
