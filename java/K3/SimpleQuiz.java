import java.util.*;

class SimpleQuiz {
    private int repeat;

    SimpleQuiz(int repeat) {
        this.repeat = repeat;
    }

    int getRepeat() {
        return repeat;
    }
    int input() {
        Scanner scan = new Scanner(System.in);
        System.out.print("Answer?: ");
        int val = scan.nextInt();
        return val;
    }

    int showQuiz() {
        Random rnd = new Random();
        int opr = rnd.nextInt(5) + 1;
        System.out.println("Quiz: " + opr + "の2倍は?");
        return opr * 2;
    }

    void play() {
        int count = 0;
        for (int i = 0; i < repeat; i++) {
            int correctAnswer = showQuiz();
            int val = input();
            if (val == correctAnswer) {
                System.out.println("Correct");
                count++;
            } else {
                System.out.println("Wrong");                
            }
            System.out.println();
        }
        System.out.println("Score: " + count);
    }
    @Override
    public String toString() {
        return "SimpleQuiz(" + repeat + ")";
    }
}
