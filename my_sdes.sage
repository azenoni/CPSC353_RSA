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
  bits = tobits(pt)
  permuted = []
  permuted.append(bits[1])
  permuted.append(bits[5])
  permuted.append(bits[2])
  permuted.append(bits[0])
  permuted.append(bits[3])
  permuted.append(bits[7])
  permuted.append(bits[4])
  permuted.append(bits[6])
  return frombits(permuted)

def _inv_permute(ct):
  bits = tobits(ct)
  permuted = []
  permuted.append(bits[3])
  permuted.append(bits[0])
  permuted.append(bits[2])
  permuted.append(bits[4])
  permuted.append(bits[6])
  permuted.append(bits[1])
  permuted.append(bits[7])
  permuted.append(bits[5])
  return frombits(permuted)

def _feistal(x, k):
    pass
def _inv_feistal(x, k):
    pass

def _generate_keys(k10):
   # Convert key to bits and truncate 
    key = format(key, '#012b')[2:]
    # Create array of bits for 10 bit key
    key_b = [int(digit) for digit in k10]

    # Follow initial permutation
    p10 = [2, 4, 1, 6, 3, 9, 0, 8, 7, 5]
    key_perm = [0] * 10
    for i in range(10):
        key_perm[i] = key_b[p10[i]]
    
    # Create key 0 and key 1
    k0 = key_perm
    k1 = key_perm

    # Rotate bits of key 0 left
    k0[0:4] = k0[1:4] + [k0[0]]
    k0[5:9] = k0[6:9] + [k0[5]]

    # Rotate bits of key 1 right
    k1[0:5] = k1[4] + [k1[0:3]]
    k1[5:9] = k1[9] + [k1[5:8]]

    # Follow second permutation
    p8 = [5, 2, 6, 3, 7, 4, 9, 8]
    k0p = [0] * 10 # Permuted keys
    k1p = [0] * 10
    for i in range(8):
        k0p[i] = k0[p8[i]]
        k1p[i] = k0[p8[i]]

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
