class CalcQuizTest {
    public static void main(String[] args) {
        CalcQuiz cq1 = new CalcQuiz(2, '+', 100);
        System.out.println(cq1);
        cq1.play();
        System.out.println("-------------------");
        CalcQuiz cq2 = new CalcQuiz(2, '-', 10);
        System.out.println(cq2);
        cq2.play();
    }
}