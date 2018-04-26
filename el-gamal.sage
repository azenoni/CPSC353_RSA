import hashlib
import random

def key_gen(p=1983499883, a=48651):
	secret_key = random.randint(1,p-2)
	public_key = mod(a^secret_key,p)
	return public_key, secret_key

def sign_message(m, p=1983499883,a=48651):
	k = 1
	while gcd(k,p-1) != 1:
		k = random.randint(1,p-1)
	r = mod(a^k,p)
	y, x = key_gen()
	H = hashlib.md5()
	H.update(m)
	s = mod((H - x*r)*k^(-1),p-1)
	# if s = 0, start over 
	if s == 0:
		k = 1
		while gcd(k,p-1) != 1:
			k = random.randint(1,p-1)
		r = mod(a^k,p)
		y, x = key_gen()
		s = mod((H - x*r)*k^(-1),p-1)
	return r, s