import java.util.PriorityQueue;
import java.util.Scanner;

public class EITASKDIS {

    static class Worker {
        int id;
        long totalTime; 

        public Worker(int id, long totalTime) {
            this.id = id;
            this.totalTime = totalTime;
        }
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;

        int n = sc.nextInt();
        int m = sc.nextInt();

        int[] count = new int[100005]; 
        int maxTask = 0;
        
        for (int i = 0; i < m; i++) {
            int t = sc.nextInt();
            count[t]++;
            if (t > maxTask) {
                maxTask = t;
            }
        }

        PriorityQueue<Worker> pq = new PriorityQueue<>((w1, w2) -> {
            if (w1.totalTime != w2.totalTime) {
                return Long.compare(w1.totalTime, w2.totalTime);
            }
            return Integer.compare(w1.id, w2.id);
        });

        int limit = Math.min(n, m);
        for (int i = 0; i < limit; i++) {
            pq.add(new Worker(i, 0));
        }

        for (int taskTime = maxTask; taskTime >= 0; taskTime--) {
            while (count[taskTime] > 0) {
                Worker w = pq.poll();
                w.totalTime += taskTime;
                pq.add(w);
                count[taskTime]--;
            }
        }

        long[] result = new long[n];
        for (Worker w : pq) {
            result[w.id] = w.totalTime;
        }

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n; i++) {
            sb.append(result[i]).append(" ");
        }
        System.out.println(sb.toString().trim());
    }
}