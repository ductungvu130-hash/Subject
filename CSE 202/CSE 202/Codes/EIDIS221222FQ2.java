import java.io.*;
import java.util.*;

public class EIDIS221222FQ2 {
    public static void main(String[] args) {
        int m = sc.nextInt();
        int n = sc.nextInt();
        char matrix[][] = new char[m][n];
        Point start = null, end = null;
        for (int i = 0; i < m; i++) {
            matrix[i] = sc.next().toCharArray();
            for (int j = 0; j < n; j++) {
                if (matrix[i][j] == 'S') {
                    start = new Point(i, j);
                } else if (matrix[i][j] == 'E') {
                    end = new Point(i, j);
                }
            }
        }
        // 4 huong di chuyen
        final int[][] directions = { { -1, 0 }, { 1, 0 }, { 0, -1 }, { 0, 1 } };
        // distance[i][j] la duong di ngan nhat tu Start den (i, j)
        int distance[][] = new int[m][n];
        Queue<Point> queue = new LinkedList<>();
        queue.add(start);
        while (!queue.isEmpty()) {
            Point current = queue.poll();
            for (var t : directions) {
                // Vi tri tiep theo
                var next = new Point(current.x + t[0], current.y + t[1]);
                if (check(next, m, n) && (matrix[next.x][next.y] == '.' || matrix[next.x][next.y] == 'E')) {
                    // Di qua roi thi bien thanh tuong (de khong di qua lan nua)
                    matrix[next.x][next.y] = '#';
                    distance[next.x][next.y] = distance[current.x][current.y] + 1;
                    queue.add(next);
                }
            }
        }
        if (start == null || end == null || distance[end.x][end.y] == 0) {
            System.out.println("-1");
        } else {
            System.out.println(distance[end.x][end.y]);
        }
    }

    static boolean check(Point current, int m, int n) {
        // Con nam trong ma tran
        return 0 <= current.x && current.x < m && 0 <= current.y && current.y < n;
    }

    static class Point {
        public int x;
        public int y;

        public Point(int x, int y) {
            this.x = x;
            this.y = y;
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
