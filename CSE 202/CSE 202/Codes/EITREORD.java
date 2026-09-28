import java.io.*;
import java.util.*;

public class EITREORD {
    public static void main(String[] args) {
        int n = sc.nextInt();
        preOder = new int[n];
        for (int i = 0; i < n; i++) {
            preOder[i] = sc.nextInt();
        }
        inOder = new HashMap<>();
        for (int i = 0; i < n; i++) {
            int number = sc.nextInt();
            inOder.put(number, i);
        }
        Vertex root = buildTree(0, n - 1, 0, n - 1);
        postOrderTraversal(root);
        System.out.print(sb);
    }

    static void postOrderTraversal(Vertex root) {
        if (root != null) {
            postOrderTraversal(root.left);
            postOrderTraversal(root.right);
            sb.append(root.id).append(" ");
        }
    }

    static Vertex buildTree(int startPreOder, int endPreOder, int startInOder, int endInOder) {
        if (startPreOder > endPreOder || startInOder > endInOder) {
            return null;
        } else {
            int rootValue = preOder[startPreOder];
            Vertex root = new Vertex(rootValue);
            int indexRoot = inOder.get(rootValue);
            int leftSubTreeSize = indexRoot - startInOder;
            root.left = buildTree(startPreOder + 1, startPreOder + leftSubTreeSize, startInOder, indexRoot - 1);
            root.right = buildTree(startPreOder + leftSubTreeSize + 1, endPreOder, indexRoot + 1, endInOder);
            return root;
        }
    }

    static int preOder[];

    static Map<Integer, Integer> inOder;

    static class Vertex {
        public int id;
        public Vertex left;
        public Vertex right;

        public Vertex(int id) {
            this.id = id;
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
