from itertools import combinations, permutations

def calcBest3(lst, tgt):
    combo = None
    maxVal = float('-inf')

    for x1, x2, x3 in permutations(lst, 3):
            valor = 1 / ((1 / x1) + (1 / x2) + (1 / x3))

            if -0.1 < (valor - tgt) <= 0:
                    if abs(valor) > maxVal:
                        maxVal = valor
                        combo = (x1, x2, x3)

    return combo, maxVal

def calcBest2(lst, tgt):
    combo = None
    maxVal = float('-inf')

    for x1, x2 in permutations(lst, 2):
            valor = (x1 * x2) / (x1 + x2)

            if -0.1 < (valor - tgt) <= 0 :
                    if abs(valor) > maxVal:
                        maxVal = valor
                        combo = (x1, x2)

    return combo, maxVal

lst = [
1.5, 1.8, 2.0, 2.2, 2.4, 2.7, 3.0, 3.3, 3.6, 3.9, 4.3, 4.7,
5.1, 5.6, 6.2, 6.8, 7.5, 8.2, 9.1,
15, 18, 20, 22, 24, 27, 30, 33, 36, 39, 43, 47, 51, 56, 62, 68, 75, 82, 91,
150, 180, 200, 220, 240, 270, 300, 330, 360, 390, 430, 470, 510, 560, 620, 680, 750, 820, 910,
1500, 1800, 2000, 2200, 2400, 2700, 3000, 3300, 3600, 3900, 4300, 4700, 5100, 5600, 6200, 6800, 7500, 8200, 9100
]



r4 = 150
paraOut = (r4 * 75)/(r4 + 75)
tgt = (paraOut * (3.3 - 0.7)) / 0.7

cmb, mV = calcBest3(lst, tgt)

print(cmb, mV, 3.3 *(paraOut/(paraOut + mV)))

cmb, mV = calcBest2(lst, tgt)

print(cmb, mV, 3.3 *(paraOut/(paraOut + mV)))