# Sbox definitions
s0 = ([[1, 0, 3, 2],
      [3, 2, 1, 0],
      [0, 2, 1, 3],
      [3, 1, 3, 2]])

s1 = ([[0, 1, 2, 3],
      [2, 0, 1, 3],
      [3, 0, 1, 0],
      [2, 1, 0, 3]])        

def encrypt(m, k):
    pass
    
def decrypt(c, k):
    pass

def _permute():
    pass

def _inv_permute():
    pass

def _feistal(x, k):
    pass
def _inv_feistal(x, k):
    pass

def _generate_keys(key):
    # Convert key to bits and truncate 
    key = format(key, '#012b')[2:]
    # Create array of bits for 10 bit key
    key_b = [int(digit) for digit in key]

    # Follow initial permutation
    p10 = [2, 4, 1, 6, 3, 9, 0, 8, 7, 5]
    key_perm = [0] * 10
    for i in range(10):
        key_perm[i] = key_b[p10[i]]
    
    # Create key 0 and key 1
    k0 = list(key_perm)
    k1 = list(key_perm)

    # Rotate bits of key 0 left
    k0[0:5] = k0[1:5] + [k0[0]]
    k0[5:10] = k0[6:10] + [k0[5]]

    # Rotate bits of key 0 left twice to get key 1
    k1[0:5] = k0[2:5] + k0[0:2]
    k1[5:10] = k0[7:10] + k0[5:7]

    # Follow second permutation
    p8 = [5, 2, 6, 3, 7, 4, 9, 8]
    k0p = [0] * 8 # Permuted keys
    k1p = [0] * 8
    for i in range(8):
        k0p[i] = k0[p8[i]]
        k1p[i] = k1[p8[i]]

    # Retrun permuted keys
    return k0p, k1p     