package problem8;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;


public class Booking {
    private static final double SALES_TAX_RATE = 0.10;

    private Customer customer;
    private SessionType sessionType;
    private LocalDate sessionDate;
    private int durationMinutes;
    private double baseFee;
    private double editingFee;

    public Booking(Customer customer1, SessionType sessionType, LocalDate sessionDate, int durationMinutes) {
        if (customer1 == null) {
            throw new IllegalArgumentException("Customer cannot be null");
        }
        this.customer = customer1;
        this.sessionType = sessionType;
        this.sessionDate = sessionDate;
        this.durationMinutes = durationMinutes;
        this.baseFee = 0.0;
        this.editingFee = 0.0;
    }

    public double calculateTotalCost() {
        double subTotal = this.baseFee + this.editingFee;
        return subTotal * (1 + SALES_TAX_RATE);
    }

    public String generateConfirmation() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        String formattedDate = this.sessionDate.format(formatter);

        StringBuilder sb = new StringBuilder();
        sb.append("----- BOOKING CONFIRMATION -----\n");
        sb.append("Customer: ").append(customer.getName()).append("\n");
        sb.append("Session Type: ").append(sessionType).append("\n");
        sb.append("Date: ").append(formattedDate).append("\n");
        sb.append("Duration: ").append(durationMinutes).append(" minutes\n");
        sb.append("--------------------------------\n");
        sb.append(String.format("Base Fee:     $%.2f\n", baseFee));
        sb.append(String.format("Editing Fee:  $%.2f\n", editingFee));
        sb.append(String.format("Tax (10%%):    $%.2f\n", (baseFee + editingFee) * SALES_TAX_RATE));
        sb.append("--------------------------------\n");
        sb.append(String.format("TOTAL PRICE:  $%.2f\n", calculateTotalCost()));
        
        return sb.toString();
    }

    public void setBaseFee(double baseFee) {
        if (baseFee < 0) {
            return;
        }
        this.baseFee = baseFee;
    }

    public void setEditingFee(double editingFee) {
        if (editingFee < 0) {
            return;
        }
        this.editingFee = editingFee;
    }

    public Customer getCustomer() {
        return customer;
    }

    public SessionType getSessionType() {
        return sessionType;
    }

    public LocalDate getSessionDate() {
        return sessionDate;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

   
}