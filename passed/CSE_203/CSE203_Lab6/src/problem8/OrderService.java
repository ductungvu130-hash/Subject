package problem8;

import java.time.LocalDate;

public class OrderService {
    private String id;
    private Restaurant res;
    private LocalDate processDate;
    private Discount discount;
    private PaymentMethod payment;
    private DeliveryMethod delivery;

    public OrderService(DeliveryMethod delivery, Discount discount, String id, PaymentMethod payment, Restaurant res) {
        this.delivery = delivery;
        this.discount = discount;
        this.id = id;
        this.payment = payment;
        this.res = res;
        this.processDate = LocalDate.now();
    }


    public void process(Order o) {
        System.out.println(res.toString());

        System.out.println("Processing order " + o.getId());

        
        double subTotal = o.getSubTotal();
        System.out.printf("Total price: $ %.2f \n", subTotal);

        double finalAmount = discount.execute(subTotal);
        System.out.printf("Price after discounting: $ %.2f \n" , finalAmount);

        payment.pay(finalAmount);

        delivery.process(o.getId());

        System.out.println("--- Completed processing ---");
    }
    
}
