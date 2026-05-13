public class Bar {
    int len;
    char pattern;

    public Bar() {
        this.len = 1;
        this.pattern = '#';
    }

    public Bar(int len, char pattern) {
        this.len = len;
        this.pattern = pattern;
    }

    public void draw()  {
        draw(false);
    }

    public void draw(boolean isvert) {
        for(int i=0; i<len; i++) {
            System.out.print(pattern);
            if(isvert)
                System.out.println();
        }
        if(!isvert)
            System.out.println();
    }

    public void draw(int height) {
        for(int i=0; i<height; i++) {
            draw(false);
        }
    }
}
