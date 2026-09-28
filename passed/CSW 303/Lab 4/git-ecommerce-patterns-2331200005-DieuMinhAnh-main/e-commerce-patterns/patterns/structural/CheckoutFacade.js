import { InventoryService } from '../../services/InventoryService.js';
import { PaymentService } from '../../services/PaymentService.js';
import { ShippingService } from '../../services/ShippingService.js';

class CheckoutFacade {
    constructor() {
        this.inventoryService = new InventoryService();
        this.paymentService = new PaymentService();
        this.shippingService = new ShippingService();
    }

    placeOrder(orderDetails) {
        // TODO: Implement the Facade method.
        // This method should orchestrate the calls to the subsystem services
        // in the correct order to simplify the checkout process.
        const { userId, productIds, shippingInfo } = orderDetails;
        console.log(`[Checkout] Starting order for user: ${userId}`);

        // 1. Check if all products are in stock using `inventoryService.checkStock()`.
        const inStock = this.inventoryService.checkStock(productIds);
        if (!inStock) {
            console.log('[Checkout] Order failed: items out of stock.');
            return false;
        }

        // 2. If they are, process the payment using `paymentService.processPayment()`.
        const amount = productIds.length * 100;
        const paymentSuccess = this.paymentService.processPayment(userId, amount);
        if (!paymentSuccess) {
            console.log('[Checkout] Order failed: payment was declined.');
            return false;
        }
        // 3. If payment is successful, arrange shipping using `shippingService.arrangeShipping()`.
        const shippingResult = this.shippingService.arrangeShipping(userId, shippingInfo);

        console.log(`[Checkout] Order placed successfully! Tracking ID: ${shippingResult.trackingId}`);
        return shippingResult;
        // 4. Log the result of each step. If a step fails, log it and stop.


    }
}

export { CheckoutFacade };
