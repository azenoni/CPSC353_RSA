secret_key_bob = 3
secret_key_alice = 4
# 

def compute_alice(p=719,a=11):
	return mod(a^secret_key_alice,p)

def compute_bob(p=719, a=11):
	return mod(a^secret_key_bob, p)

def compute_shared_alice(shared_val,p=719):
	return mod(shared_val^secret_key_alice, p)

def compute_shared_bob(shared_val,p=719):
	return mod(shared_val^secret_key_bob ,p)