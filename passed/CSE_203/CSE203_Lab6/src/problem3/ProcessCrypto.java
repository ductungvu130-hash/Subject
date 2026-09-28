package problem3;

class ProcessCrypto implements ICryptoPayment {

    @Override
    public void processCrypto(double amount){
        System.out.println("Paying " + amount + " by using Crypto!");

    }
}
