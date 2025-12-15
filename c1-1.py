def fibonacci_view(n):
    a = 0
    b = 1
    for i in range(n):
        a, b = b, a + b;
        print(f"{a}{"\n" if (i+1) % 10 == 0 else " "}", end="")

fibonacci_view(100)
    
