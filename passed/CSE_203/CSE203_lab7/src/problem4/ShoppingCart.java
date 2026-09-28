package problem4;

import java.util.ArrayList;
import java.util.List;

public class ShoppingCart {

    private List<ShoppingItem> items = new ArrayList<>();
    private PaymentStrategy paymentStrategy;

    public void addItem(ShoppingItem item) {
        items.add(item);
    }

    public void setPaymentStrategy(PaymentStrategy paymentStrategy) {
        this.paymentStrategy = paymentStrategy;
    }

    public double calculateTotal() {
        return items.stream().mapToDouble(ShoppingItem::getCost).sum();
    }

    public void checkout() {
        double total = calculateTotal();
        System.out.printf("Total amount: $%.2f%n", total);
        paymentStrategy.pay(total);
    }
}
