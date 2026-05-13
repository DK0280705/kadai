class CoinSet {
    private int coin100;
    private int coin10;

    CoinSet(int coin100, int coin10) {
        this.coin100 = coin100;
        this.coin10 = coin10;
    }

    public int getSum() {
        return coin100 * 100 + coin10 * 10;
    }

    public boolean take(int amount) {
        if (amount > getSum()) {
            return false;
        }
        int num100 = Math.min(amount / 100, coin100);
        amount -= num100 * 100;
        int num10 = Math.min(amount / 10, coin10);
        amount -= num10 * 10;
        if (amount == 0) {
            coin100 -= num100;
            coin10 -= num10;
            return true;
        } else {
            return false;
        }
    }

    @Override
    public String toString() {
        return getSum() + "yen (100:" + coin100 + ", 10:" + coin10 + ")";
    }
}