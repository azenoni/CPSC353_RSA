import random

# i+1 = 345
# I+1 = 466

def compute_shared_val_key(p,a):
	secret_key = random.randint(1,p)
	return secret_key, a.powermod(secret_key,p)

def compute_key(secret_key, shared_val, p):
	return shared_val.powermod(secret_key,p)

""" First iteration. Keep for testing
secret_key_bob = 3
secret_key_alice = 4

def compute_alice(p=719,a=11):
	return a.powermod(secret_key_alice,p)

def compute_bob(p=719, a=11):
	return a.powermod(secret_key_bob, p)

def compute_shared_alice(shared_val,p=719):
	return shared_val.powermod(secret_key_alice, p)

def compute_shared_bob(shared_val,p=719):
	return shared_val.powermod(secret_key_bob ,p)
"""