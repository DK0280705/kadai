m = int(input())

def factors(n):
    result = []
    for i in range(1, n):
        if n % i == 0:
            result.append(i)
    return result

factors_list = factors(m)
print("O" if sum(factors_list) == m else "X")