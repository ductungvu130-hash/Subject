import java.io.*;
import java.util.*;

/*
 * Extended N-Queens solver (tries to output up to 10,000 canonical unique solutions).
 * Uses the provided Reader class for fast input.
 *
 * Strategy:
 *  - Solve N-queens with a swap-based min-conflicts algorithm from random starts.
 *  - Canonicalize each found solution under 8 symmetries (rotations + reflection).
 *  - Keep only lexicographically smallest canonical representation; print unique ones.
 *
 * NOTE: This is a heuristic/constructive runner intended for contest-style "find many"
 * problems. It may not reach the theoretical maximum number of unique solutions for small N,
 * but it's engineered to produce many valid, distinct solutions quickly for large N.
 */
public class Test {
    static Reader sc = new Reader();
    static final int MAX_OUTPUT = 10000;

    public static void main(String[] args) throws Exception {
        if (!sc.hasNext())
            return;
        int N = sc.nextInt();
        // Valid N are >= 4 according to problem statement; handle small cases anyway.
        if (N < 4)
            return;

        BufferedWriter out = new BufferedWriter(new OutputStreamWriter(System.out), 1 << 16);
        HashSet<String> seen = new HashSet<>();
        Random rnd = new Random(123456789L ^ System.nanoTime());

        long timeLimitNanos = (long) (1.45 * 1e9); // around SPOJ 1.5s limit; leave margin
        long startTime = System.nanoTime();

        int found = 0;
        int restarts = 0;

        // We'll attempt many restarts until we either find enough or hit time limit.
        while (found < MAX_OUTPUT && System.nanoTime() - startTime < timeLimitNanos) {
            restarts++;
            // Solve one instance
            int[] cols = new int[N];
            for (int i = 0; i < N; ++i)
                cols[i] = i;
            // shuffle initial permutation
            for (int i = N - 1; i > 0; --i) {
                int j = rnd.nextInt(i + 1);
                int tmp = cols[i];
                cols[i] = cols[j];
                cols[j] = tmp;
            }
            // diag arrays
            int[] diag1 = new int[2 * N]; // r + c
            int[] diag2 = new int[2 * N]; // r - c + N -1
            for (int r = 0; r < N; ++r) {
                int c = cols[r];
                diag1[r + c]++;
                diag2[r - c + N - 1]++;
            }

            // get rows with conflicts
            List<Integer> conflictedRows = new ArrayList<>();
            for (int r = 0; r < N; ++r) {
                int conflicts = (diag1[r + cols[r]] - 1) + (diag2[r - cols[r] + N - 1] - 1);
                if (conflicts > 0)
                    conflictedRows.add(r);
            }
            // if none, already solution
            if (conflictedRows.isEmpty()) {
                String can = canonicalString(cols, N);
                if (!seen.contains(can)) {
                    seen.add(can);
                    out.write(can);
                    out.newLine();
                    found++;
                    if (found >= MAX_OUTPUT)
                        break;
                }
                continue;
            }

            int maxIter = Math.max(3 * N, 1000);
            boolean solved = false;
            for (int iter = 0; iter < maxIter && System.nanoTime() - startTime < timeLimitNanos; ++iter) {
                // recompute list of conflicted rows occasionally or keep updated
                conflictedRows.clear();
                for (int r = 0; r < N; ++r) {
                    if ((diag1[r + cols[r]] - 1) + (diag2[r - cols[r] + N - 1] - 1) > 0) {
                        conflictedRows.add(r);
                    }
                }
                if (conflictedRows.isEmpty()) {
                    solved = true;
                    break;
                }
                // pick a random conflicted row
                int r = conflictedRows.get(rnd.nextInt(conflictedRows.size()));

                // compute current conflicts sum for row r and candidate partner j
                int cr = cols[r];
                int A = r + cr, B = r - cr + N - 1;
                // we'll search best j to swap columns with r
                int bestJ = -1;
                int bestVal = Integer.MAX_VALUE;
                int currentSum = (diag1[A] - 1) + (diag2[B] - 1); // r's conflicts
                // current conflicts of all j considered too
                for (int j = 0; j < N; ++j) {
                    if (j == r)
                        continue;
                    int cj = cols[j];
                    int C = j + cj, D = j - cj + N - 1;
                    int currSumPair = currentSum + (diag1[C] - 1) + (diag2[D] - 1);

                    // after swap: r uses cj, j uses cr
                    int A2 = r + cj, B2 = r - cj + N - 1;
                    int C2 = j + cr, D2 = j - cr + N - 1;

                    // compute new conflicts for r after swap:
                    int confRnew = (diag1[A2] - (A2 == A ? 1 : 0) - (A2 == C ? 1 : 0) + (A2 == C2 ? 1 : 0))
                            + (diag2[B2] - (B2 == B ? 1 : 0) - (B2 == D ? 1 : 0) + (B2 == D2 ? 1 : 0));
                    // compute new conflicts for j after swap:
                    int confJnew = (diag1[C2] - (C2 == A ? 1 : 0) - (C2 == C ? 1 : 0) + (C2 == A2 ? 1 : 0))
                            + (diag2[D2] - (D2 == B ? 1 : 0) - (D2 == D ? 1 : 0) + (D2 == B2 ? 1 : 0));

                    int newSumPair = confRnew + confJnew;

                    if (newSumPair < bestVal) {
                        bestVal = newSumPair;
                        bestJ = j;
                    } else if (newSumPair == bestVal && rnd.nextBoolean()) {
                        // random tie-break
                        bestJ = j;
                    }
                }

                if (bestJ == -1)
                    continue;
                int j = bestJ;
                // perform swap of columns between rows r and j
                int cj = cols[j];
                // update diag arrays
                // remove old
                diag1[r + cols[r]]--;
                diag2[r - cols[r] + N - 1]--;
                diag1[j + cols[j]]--;
                diag2[j - cols[j] + N - 1]--;
                // swap
                cols[r] = cj;
                cols[j] = cr;
                // add new
                diag1[r + cols[r]]++;
                diag2[r - cols[r] + N - 1]++;
                diag1[j + cols[j]]++;
                diag2[j - cols[j] + N - 1]++;
            }

            if (solved) {
                String can = canonicalString(cols, N);
                if (!seen.contains(can)) {
                    seen.add(can);
                    out.write(can);
                    out.newLine();
                    found++;
                    if (found >= MAX_OUTPUT)
                        break;
                }
            }
            // allow more restarts; loop will continue while time remains
        }

        out.flush();
    }

    // Build canonical string representation for the given cols[row] configuration:
    // Among 8 transforms (rotations + optional vertical reflection), pick
    // lexicographically smallest
    // representation as "r1 c1 r2 c2 ... rN cN" (1-based rows and columns, rows
    // ordered ascending).
    static String canonicalString(int[] cols, int N) {
        String best = null;
        // For rotations 0..3, and flip 0/1 (mirror vertical after rotation)
        for (int rot = 0; rot < 4; ++rot) {
            for (int flip = 0; flip < 2; ++flip) {
                int[] newCols = transform(cols, N, rot, flip == 1);
                // build string
                StringBuilder sb = new StringBuilder(4 * N);
                for (int r = 0; r < N; ++r) {
                    // rows are 0..N-1; columns are newCols[r]
                    sb.append((r + 1)).append(' ').append((newCols[r] + 1));
                    if (r + 1 < N)
                        sb.append(' ');
                }
                String s = sb.toString();
                if (best == null || s.compareTo(best) < 0)
                    best = s;
            }
        }
        return best;
    }

    // Apply rotation 'rot' times 90deg clockwise, then optional flip across
    // vertical axis.
    // Input: cols[row]=col; returns newCols'[row'] = col' for transformed board.
    static int[] transform(int[] cols, int N, int rot, boolean flipVertical) {
        int[] res = new int[N];
        // for each queen (r,c) compute (r2,c2) after transformation and set res[r2]=c2
        for (int r = 0; r < N; ++r) {
            int c = cols[r];
            int r2 = r, c2 = c;
            // apply rotation rot times (each is (r,c)->(c, N-1 - r))
            for (int k = 0; k < rot; ++k) {
                int nr = c2;
                int nc = N - 1 - r2;
                r2 = nr;
                c2 = nc;
            }
            // optional flip across vertical axis => (r,c) -> (r, N-1 - c)
            if (flipVertical)
                c2 = N - 1 - c2;
            res[r2] = c2;
        }
        return res;
    }

    /* Fast Reader (user-provided template adapted) */
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
