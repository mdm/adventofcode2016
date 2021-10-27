import hashlib

salt = 'ihaygndm'
index = 0
keys = 0
while keys < 64:
    hash = hashlib.md5((salt + str(index)).encode('utf8')).hexdigest()
    rep3 = False
    targets = []
    for hexdigit in '0123456789abcdef':
        if hexdigit * 3 in hash:
            rep3 = True
            targets.append((hash.find(hexdigit * 3), hexdigit))
    if rep3:
        targets.sort()
        target = targets[0][1]
        for index2 in range(index + 1, index + 1001):
            hash2 = hashlib.md5((salt + str(index2)).encode('utf8')).hexdigest()
            if target * 5 in hash2:
                print(index, hash, hash2)
                keys += 1
                break
    index += 1

def stretched_hash(salt, index):
    hash = hashlib.md5((salt + str(index)).encode('utf8')).hexdigest()
    for _ in range(2016):
        hash = hashlib.md5((hash).encode('utf8')).hexdigest()
    return hash

index = 0
keys = 0
cache = {}
while keys < 64:
    if not index in cache:
        cache[index] = stretched_hash(salt, index)
    hash = cache[index]
    rep3 = False
    targets = []
    for hexdigit in '0123456789abcdef':
        if hexdigit * 3 in hash:
            rep3 = True
            targets.append((hash.find(hexdigit * 3), hexdigit))
    if rep3:
        targets.sort()
        target = targets[0][1]
        for index2 in range(index + 1, index + 1001):
            if not index2 in cache:
                cache[index2] = stretched_hash(salt, index2)
            hash2 = cache[index2]
            if target * 5 in hash2:
                print(index, hash, hash2)
                keys += 1
                break
    index += 1
