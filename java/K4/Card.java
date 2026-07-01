
import java.util.Random;

public class Card {
    private final Type type;
    private final int number;

    public Card() {
        Random rnd = new Random();
        this.type = Type.values()[rnd.nextInt(Type.values().length)];
        this.number = rnd.nextInt(9) + 1;
    }

    public Card(Type type, int number) {
        this.type = type;
        this.number = number;
    }

    public int getNumber() {
        return this.number;
    }

    public Type getType() {
        return this.type;
    }

    public Type getWeaknessType() {
        return switch (this.type) {
            case FIRE -> Type.WATER;
            case WATER -> Type.GRASS;
            case GRASS -> Type.FIRE;
        };
    }

    public boolean isStrongerThan(Card c) {
        return this.getType() == c.getType()
            ?  this.number > c.number
            :  this.getWeaknessType() != c.getType()
            && this.getType() == c.getWeaknessType();
    }

    public boolean isSameAs(Card c) {
        return this.type == c.type && this.number == c.number;
    }

    @Override
    public String toString() {
        return this.type + " [" + this.number + "]";
    }
}