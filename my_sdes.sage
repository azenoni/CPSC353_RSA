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

def _permute(pt):
  permuted = []
  permuted.append(pt[1])
  permuted.append(pt[5])
  permuted.append(pt[2])
  permuted.append(pt[0])
  permuted.append(pt[3])
  permuted.append(pt[7])
  permuted.append(pt[4])
  permuted.append(pt[6])
  return permuted

def _inv_permute(ct):
  permuted = []
  permuted.append(ct[3])
  permuted.append(ct[0])
  permuted.append(ct[2])
  permuted.append(ct[4])
  permuted.append(ct[6])
  permuted.append(ct[1])
  permuted.append(ct[7])
  permuted.append(ct[5])
  return permuted

# Pass in 8-bits, and 4-bits respectively
def _feistal(key, r):
    n = ([[r[3],r[0],r[1],r[2]], 
        [r[1],r[2],r[3],r[0]]])
    k = ([[key[0],key[1],key[2],key[3]],
          [key[4],key[5],key[6],key[7]]])
    p = ([[n[0][0] ^ k[0][0]], [n[0][1] ^ k[0][1]], [n[0][2] ^ k[0][2]], [n[0][3] ^ k[0][3]],
          [n[1][0] ^ k[1][0]], [n[1][1] ^ k[1][1]], [n[1][2] ^ k[1][2]], [n[1][3] ^ k[1][3]]])

    first_bits = [p[0][0], p[0][3]]
    first_out = 0
    for bit in first_bits:
      out = (out << 1) | bit
    secont_bits = [p[0][1], p[0][2]]
    second_out = 0
    for bit in secont_bits:
      out = (out << 1) | bit
    s_0 = s0[first_out][second_out]

    first_bits = [p[1][0], p[1][3]]
    first_out = 0
    for bit in first_bits:
      out = (out << 1) | bit
    secont_bits = [p[1][1], p[1][2]]
    second_out = 0
    for bit in secont_bits:
      out = (out << 1) | bit
    s_1 = s1[first_out][second_out]


    s_0_bits = [int(x) for x in list('{0:0b}'.format(s_0))]
    s_1_bits = [int(x) for x in list('{0:0b}'.format(s_1))]

    s_combined = s_0_bits + s_1_bits
    return [s_combined[1],s_combined[3],s_combined[2],s_combined[0]]


# May not be neccessary
def _inv_feistal(x, k):
    pass

def _generate_keys(k10):
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

#following functions found here
#https://stackoverflow.com/questions/10237926/convert-string-to-list-of-bits-and-viceversa?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
def tobits(s):
    result = []
    for c in s:
        bits = bin(ord(c))[2:]
        bits = '00000000'[len(bits):] + bits
        result.extend([int(b) for b in bits])
    return result

def frombits(bits):
    chars = []
    for b in range(len(bits) / 8):
        byte = bits[b*8:(b+1)*8]
        chars.append(chr(int(''.join([str(bit) for bit in byte]), 2)))
    return ''.join(chars)
