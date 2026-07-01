import java.util.*;

class CalcQuiz extends SimpleQuiz {

    private char operator;

    private int max;

    public CalcQuiz(int repeat, char operator, int max) {
        super(repeat);

        if (operator != '-' && operator != '+')
            throw new IllegalArgumentException("Operator must be '+' or '-'");

        this.operator = operator;
        this.max = max;
    }

    @Override
    public int showQuiz() {
        Random rnd = new Random();
        int num1 = rnd.nextInt(this.max) + 1;
        int num2 = rnd.nextInt(this.max) + 1;
        System.out.println(num1 + " " +  this.operator + " " + num2);
        return operator == '+' ? num1 + num2 : num1 - num2; 
    }

    @Override
    public String toString() {
        return "CalcQuiz(" + super.getRepeat() + ", '" + this.operator + "', " + this.max + ")"; 
    }

}