public enum Type {
    FIRE,
    WATER,
    GRASS;

    @Override
    public String toString() {
        return switch (this) {
            case FIRE  -> "FIRE ";
            case WATER -> "WATER";
            case GRASS -> "GRASS";
        };
    }
}