package question2;

import question1.RetailItem;

public class CashRegister {
    private RetailItem retail;
    private int quantity;
    public static final double TAX =0.06;

    public CashRegister(int quantity, RetailItem retail) {
        this.quantity = quantity;
        this.retail = retail;
    }

    public RetailItem getRetail() {
        return retail;
    }

    public void setRetail(RetailItem retail) {
        this.retail = retail;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getSubtotal(){
        return (quantity*retail.getPrice());
    }

    public double getTax(){
        return (TAX * getSubtotal());
    }

    public double getTotal(){
        return (getSubtotal() + getTax() );
    }

    @Override
    public String toString() {
        return getRetail() + "\nQuantity: " + getQuantity() + "\nSubtotal: "
                + getSubtotal() + "\nTax: " + getTax() + "\nTotal: " + getTotal() ;
    }

    
}
