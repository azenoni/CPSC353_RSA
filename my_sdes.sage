from operator import xor

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
    k0, k1 = _generate_keys(k)
    encrypted = cipher_blockchain(m,k0,k1)
    return encrypted
    
def decrypt(c, k):
    k0 ,k1 = _generate_keys(k)
    decrypted = cipher_blockchain(m,k0,k1)
    pass

# Helper functions to use in the cipher blockchaining
# m is cipher message, k0 k1 are keys
def cipher_blockchain(m,k0,k1):
  encrypted_message = []
  #assuming m is a string of characters
  for i in m:
    num = txt_to_num(i)
    encrypted_message.append(_encrypt_single(tobits(num,8),k0,k1))
  enc = []
  print encrypted_message
  tmp = []
  for i in encrypted_message:
    for j in i:
      tmp.append(j)
  for i in encrypted_message:
    enc.append(frombits(i))

  print "tmp is:", tmp
  otherTMP = frombits(tmp)
  print num_to_txt(otherTMP)
  print enc
  encrypted_message = []
  for i in enc:
    print i
    encrypted_message.append(num_to_txt(i))
  return encrypted_message
  

# Perform SDES encryption on one 8-bit element
def _encrypt_single(x, k0, k1):
  # split message into left and right chunks
  l = x[0:4]
  r = x[4:8]

  print x
  print l
  print r

  # perform first feistal function
  feistel1 = _feistal(k0,r)

  print "first done"
  # build the next l function
  l_next = []
  for i in range(4):
    l_next.append(xor(r[i], feistel1[i]))

  # set the next r
  r_next = r

  # perform second feistal function
  feistel2 = _feistal(k1,r_next)

  # buil final l
  l_final = []
  for i in range(4):
    l_final.append(xor(r_next[i], feistel2[i]))

  # set the final r
  r_final = r_next

  # return combination of l_final and r_final
  return l_final + r_final

# Perform SDES decryption on one 8-bit element
def _decrypt_single(y, k0, k1):
  # split message into left and right chunks
  l = y[0:4]
  r = y[4:8]

  # perform a feistel function
  feistel1 = _feistal(k1, r)

  print r
  print feistel1

  # create the next l
  l_next = []
  for i in range(4):
    l_next.append(xor(r[i], feistel1[i]))


  print l_next
  # set next r
  r_next = r

  # perform second feistal function
  feistel2 = _feistal(k0, r_next)

  # get ready for final l
  l_final = []
  for i in range(4):
    l_final.append(xor(r_next[i], feistel2[i]))


  # prepare last r
  r_final = r_next

  # return combined l and r
  return l_final + r_final


# rotate bits as specified by definition
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

# rotate bits as specified by definition
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
    # create matricies
    n = ([[r[3],r[0],r[1],r[2]], 
        [r[1],r[2],r[3],r[0]]])
    print("n matrix created successfully")
    print(n)
    k = ([[key[0],key[1],key[2],key[3]],
          [key[4],key[5],key[6],key[7]]])

    print("k matrix created successfully")
    print(k)
    print(xor(n[0][0], k[0][0]))
    # xor the n and k matricies
    p = ([[xor(n[0][0], k[0][0]), xor(n[0][1], k[0][1]), xor(n[0][2], k[0][2]), xor(n[0][3], k[0][3])],
          [xor(n[1][0], k[1][0]), xor(n[1][1], k[1][1]), xor(n[1][2], k[1][2]), xor(n[1][3], k[1][3])]])

    print("p matrix created successfully")
    print(p)
    # perform operations for s box 0
    first_bits = [p[0][0], p[0][3]]
    first_out = frombits(first_bits)
    second_bits = [p[0][1], p[0][2]]
    second_out = frombits(second_bits)
    s_0 = s0[first_out][second_out]

    print("s_0 calculated successfully")
    print(s_0)
    # perform operations for s box 1
    first_bits = [p[1][0], p[1][3]]
    first_out = frombits(first_bits)
    second_bits = [p[1][1], p[1][2]]
    second_out = frombits(second_bits)
    s_1 = s1[first_out][second_out]

    print("s_1 calculated successfully")
    print(s_1)
    # convert back to bits
    s_0_bits = tobits(s_0,2)
    s_1_bits = tobits(s_1,2)

    # combine s box return values for return
    s_combined = s_0_bits + s_1_bits
    # for i in s_1_bits:
    #   s_combined.append(i)
    return [s_combined[1],s_combined[3],s_combined[2],s_combined[0]]


# May not be neccessary
def _inv_feistal(x, k):
    pass

def _generate_keys(k10):
    # Convert key to bits and truncate 
    key = format(k10, '#012b')[2:]
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

    # return keys as a tuple
    return k0p, k1p

def tobits(num,bit_length):
    # Convert num to bits and truncate "0b" header and leading 6 bits
    num = format(num, '#010b')[(10-bit_length):]
    # Convert from bit string to integer list
    return [int(digit) for digit in num]

def frombits(bits):
    num = 0
    for i in range(len(bits)):
        print "i: ", i
        print "bits[i]: ", bits[i]
        print "bits[-(i+1)]:", bits[-(i+1)]
        if (bits[-(i+1)] == 1):
            num = num + (2 ** (i)) 
            print num
    return num


#msg_in is a string
def txt_to_num(msg_in):      
  #transforms string to the indices of each letter in the 8-bit ASCII table
  msg_idx = map(ord,msg_in)
  #computes the base 256 integer formed from the indices transformed to decimal.
  #each digit in the list is multiplied by the respective power of 256 from
  #right to left.  For example, [64,64] = 256^1 * 64 + 256^0 * 64
  num = ZZ(msg_idx,256)
  return num 

#Converts a digit sequence to a string
#Return the string

#num_in is a decimal integer composed as described above 
def num_to_txt(num_in):
  #returns the list described above 
  msg_idx = num_in.digits(256)
  #maps each index to its associated character in the ascii table 
  m = map(chr,msg_idx)
  print m
  #transforms the list to a string
  m = ''.join(m)
  return m
