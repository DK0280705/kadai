m = int(input())

def prime_factors(n):
    factors = []
    i = 2
    # The logic here is anything below 4 is prime
    while i * i <= n:
        if n % i == 0:
            factors.append(i)
            n = n // i
        else:
            i += 1
    if n > 1:
        factors.append(n)
    return factors

factors = prime_factors(m)
print(factors)