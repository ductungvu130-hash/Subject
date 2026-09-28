
import java.util.Scanner;

public class EIUMERSORT {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        // Đọc số lượng phần tử N
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        
        int[] arr = new int[n];
        for (int i = 0; i < n; i++) {
            arr[i] = sc.nextInt();
        }

        mergeSort(arr, 0, n - 1);

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n; i++) {
            sb.append(arr[i]).append("\n");
        }
        System.out.print(sb.toString());
        
    }

 
    public static void mergeSort(int[] arr, int left, int right) {
        if (left < right) {
            int mid = (right + left) / 2;

            mergeSort(arr, left, mid);      
            mergeSort(arr, mid + 1, right);

            merge(arr, left, mid, right);  
        }
    }

    // Hàm trộn hai mảng con đã sắp xếp
    public static void merge(int[] arr, int left, int mid, int right) {
        int n1 = mid - left + 1;
        int n2 = right - mid;

        int[] L = new int[n1];
        int[] R = new int[n2];

        // Sao chép dữ liệu vào mảng tạm
        for (int i = 0; i < n1; ++i) L[i] = arr[left + i];
        for (int j = 0; j < n2; ++j) R[j] = arr[mid + 1 + j];

        int i = 0, j = 0, k = left;
        while (i < n1 && j < n2) {
            if (L[i] <= R[j]) {
                arr[k++] = L[i++];
            } else {
                arr[k++] = R[j++];
            }
        }

    
        while (i < n1) arr[k++] = L[i++];
        while (j < n2) arr[k++] = R[j++];
    }
}