

import java.util.Scanner;


public class Q1 {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        StringBuilder sb = new StringBuilder();

        String f = sc.next();
        int n = sc.nextInt();
        int k = sc.nextInt();

        int[] arr = new int[n];
        long[] prefix = new long[n + 1];

        for (int i = 0; i < n; i++) {
            arr[i] = sc.nextInt();
            prefix[i + 1] = arr[i] + prefix[i];
        }

        
        for (int i = 0; i < k; i++) {
            switch (f) {
                case ("SlidingWindow"):{
                    int size = sc.nextInt();
                    long sum = 0;
                    long minSum = Long.MAX_VALUE;
                    for (int j = 0; j < arr.length; j++) {
                        sum += arr[j];

                        if (j >= size) {
                            sum -= arr[j - size];
                        }
                        if (j >= size - 1) {
                            minSum = Math.min(minSum, sum);
                        }

                    }
                    System.out.println(minSum);
                    break;
                }
                case ("BinarySearch"):{
                    int value = sc.nextInt();
                    int index =-1;
                    int low = 0; int high = n-1; int mid =0;

                    while( high >= low){
                        mid = (low+high)/2;

                        if(arr[mid] == value){
                            index = mid;
                            break;
                        }else if (arr[mid] > value){
                            high = mid-1;
                        }else 
                            low = mid+1;
                    }

                    System.out.println(index);
                    break;
                }
                case ("PrefixSum"):
                    int left =sc.nextInt();
                    int right =sc.nextInt();
                    long sum = prefix[right+1] -prefix[left];
                    System.out.println(sum);
                    break;

                case ("TwoPointer"):
                    long targetSum = sc.nextInt();
                    int l = 0;
                    int r = n -1;
                    left = -1;
                    right = -1;

                    while( l < r){
                        long s = arr[l] + arr[r];
                        if(s == targetSum){
                            left = l;
                            right = r ;
                            break;
                        }else if(s >targetSum){
                            r--;
                        }else
                            l++;
                        
                    }
                    System.out.println(left + " " + right);
                    break;
            }
        }
    }
}
