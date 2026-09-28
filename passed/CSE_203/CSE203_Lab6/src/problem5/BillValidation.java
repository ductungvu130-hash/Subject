package problem5;

public class BillValidation implements OrderValidation{

    @Override
    public boolean isValid(Order o) {
        return o.getTotalBill()>=0;
    }
}
