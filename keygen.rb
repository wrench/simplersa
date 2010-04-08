# Pick P and Q to be random primes of 4 digits in length
# N = PQ
# PHI = (P-1)(Q-1)
# Pick E to be a random prime; 1<E<PHI; such that GCD(E, PHI) == 1;
# Find D: 1<D<PHI; ED mod PHI == 1
# Simple Example: http://www.di-mgt.com.au/rsa_alg.html#proof

# Generate primes from 1000 to 9999 and return as a list.
def gen_primes(min, max)
  primes = []
  state = Numeric.new
  (min..max).each do
    |i|
    (2..(Math.sqrt(i).ceil)).each do |thing|
      state = 1
      if (i.divmod(thing)[1] == 0)
        state = 0
        break
      end
    end
    primes << i unless (state == 0)
  end
  return primes
end

def get_prime(prime_list) # Choose a random prime from the list of generated primes.
  n = rand(prime_list.size - 1)
  return prime_list[n]
end

def coprime?(e, phi) # Determine whether 2 numbers are coprime.
  if gcd(e, phi) == 1
    return true
  else 
    return false
  end
end

def gcd(a, b) # Find the GCD of two numbers.
  if b == 0
    return a
  end
  return gcd(b, a % b)
end

def get_e(phi) # Get E: A random prime 1<E<PHI; such that GCD(e, phi) == 1;
#  e_primes = gen_primes(1, phi)
  e_primes = gen_primes(1000, 10000)
  while true
    e = get_prime(e_primes)
    if coprime?(e, phi)
      return e
    end
  end
end

def get_d(phi, e) # Get D: 1<D<PHI; such that (E)(D) % phi == 1;
  i = 1
  found = false
  while !found
    val = phi * i + 1
    d = val / e
    if d >= phi
      break
    end
    #if d.instance_of?(Fixnum) || d.instance_of?(Bignum)
    if(d % 1 == 0)
      return d
    end
    i = i + 1
  end
end

# c = m^e % n
def encrypt(m, n, e)
  c = (m**e) % n
  return c
end

# m1 = c^d % n
def decrypt(c, n, d)
  m1 = (c**d) % n
  return m1
end

########
primes = gen_primes(1000, 10000)
p = get_prime(primes); puts "p: #{p}"
q = get_prime(primes); puts "q: #{q}"
n = p * q; puts "n: #{n}"
phi = (p - 1) * (q - 1); puts "phi: #{phi}"
e = get_e(phi); puts "e: #{e}"
d = get_d(phi, e); puts "d: #{d}"
########
m = 7 ## Using 7 as the "message" that should come out the same (m1)
c = encrypt(m, n, e); puts "c: #{c}"
m1 = decrypt(c, n, d); puts "m1: #{m1}"

# Below just tests to make sure that the encrypt and decrypt methods are working properly. WORKS!! (w/ simple example)
#p = 11; q = 3; n = 33; phi = 20; e = 3; d = 7
#m = 7
#c = encrypt(m, n, e); puts "c: #{c}"
#m1 = decrypt(c, n, d); puts "m1: #{m1}"




