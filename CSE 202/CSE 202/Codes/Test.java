import java.util.*;

public class Test {
    static class Vertex {
        public int id;
        public List<Vertex> adj;
        public int weight;
        public long money;

        public Vertex(int id) {
            this.id = id;
            this.adj = new ArrayList<>();
            this.money = 0;
        }
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        StringBuilder sb = new StringBuilder();

        int n = sc.nextInt();
        Vertex[] vertices = new Vertex[n];
        for (int i = 0; i < n; i++) {
            vertices[i] = new Vertex(i);
        }

        // đọc doanh thu (weights)
        for (int i = 0; i < n; i++) {
            vertices[i].weight = sc.nextInt();
        }

        // đọc n-1 dòng: u giới thiệu v => u là parent của v
        for (int i = 0; i < n - 1; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            // lưu parent vào adj của v (để ta có thể đi lên bằng adj.get(0))
            vertices[v].adj.add(vertices[u]);
        }

        // Với mỗi người i: tính hoa hồng cấp 1 rồi truyền lên dần
        for (int i = 0; i < n; i++) {
            int comm = vertices[i].weight * 15 / 100; // hoa hồng cấp 1 (lấy phần nguyên)
            if (comm == 0)
                continue;

            // Người bán lấy phần comm
            vertices[i].money += comm;

            long give = comm;
            Vertex cur = vertices[i];

            // truyền lên cha cứ mỗi lần chia cho 2 (lấy phần nguyên) đến khi bằng 0 hoặc
            // tới gốc
            while (true) {
                if (cur.adj.isEmpty())
                    break; // không có parent nữa
                Vertex parent = cur.adj.get(0); // parent được lưu ở adj[0]
                give = give / 2; // parent nhận 1/2 (lấy phần nguyên)
                if (give == 0)
                    break;
                parent.money += give;
                cur = parent;
            }
        }

        // In kết quả theo ID tăng dần
        for (Vertex each : vertices) {
            sb.append(each.id).append(" ").append(each.money).append("\n");
        }
        System.out.print(sb.toString());
        sc.close();
    }
}
