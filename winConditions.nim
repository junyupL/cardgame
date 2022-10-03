proc higherWins*(power0, power1: int): int =
    if power0 > power1:
        return 0
    if power0 < power1:
        return 1
    return 2

proc lowerWins*(power0, power1: int): int =
    if power0 < power1:
        return 0
    if power0 > power1:
        return 1
    return 2

proc specificpowerloses*[power: static int](power0, power1: int): int =
    if power0 == power:
        return 1
    if power1 == power:
        return 0
    return 2