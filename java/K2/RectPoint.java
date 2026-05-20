public class RectPoint {
    private int x;
    private int y;

    public RectPoint(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    public int getQuad() {
        if (x > 0 && y > 0) {
            return 1;
        } else if (x < 0 && y > 0) {
            return 2;
        } else if (x < 0 && y < 0) {
            return 3;
        } else if (x > 0 && y < 0) {
            return 4;
        } else {
            return 0;
        }
    }

    public boolean isSameQuad(RectPoint other) {
        return this.getQuad() == other.getQuad();
    }

    @Override
    public String toString() {
        return  x + ", " + y + " (" + getQuad() + ")";
    }
}