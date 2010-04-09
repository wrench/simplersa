# Pick P and Q to be random primes of 4 digits in length
# N = PQ
# PHI = (P-1)(Q-1)
# Pick E to be a random prime; 1<E<PHI; such that GCD(E, PHI) == 1;
# Find D: 1<D<PHI; ED mod PHI == 1
# Simple Example: http://www.di-mgt.com.au/rsa_alg.html#proof

# Generate primes from 1000 to 9999 and return as a list.

if !ARGV[0]
  puts 'Usage: ruby RSA.rb <message_to_encrypt> OR ruby RSA.rb <message_to_encrypt> --verbose'
  exit
end
message = ARGV[0]
@@verbose = false
if ARGV[1] == '--verbose'
  @@verbose = true
end

def gen_primes(min, max)
  primes = []
  state = Numeric.new
  (min..max).each do |i|
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

def coprime(e, phi) # Determine whether 2 numbers are coprime.
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
    if coprime(e, phi)
      return e
    end
  end
end

def get_d(phi, e) # Get D: 1<D<PHI; such that (E)(D) % phi == 1;

  multiplier = 1
  while(true)
    d = ((phi * multiplier) + 1.0)/e
    if (d > phi) # Stop if D > Phi 
      return 0
    end
    if (d%1 == 0.0) # Found an int value for d
      return d.to_i
    end
    multiplier = multiplier + 1
  end
end

# c = m^e % n
def encrypt(m, n, e)
  c = (m**e) % n
  return c
end

# m1 = c^d % n
def decrypt(c, n, d)
  #m1 = (c**d) % n
  m1 = modexp(c, d, n)
end

def modexp x, e, n
  return 1%n if e.zero?
  # k - most significant bit posistion
  ee, k = e, 0
  # linear search
  (ee>>=1;k+=1) while ee>0
  y = x
  (k-2).downto(0) do |j|
    y=y*y%n  # square
    (y=y*x%n) if e[j] == 1 # multiply
  end
  y
end

def EGCD(b,m,recLevel=0)
  if b % m == 0
    tmpVal = [0,1]
    return tmpVal
  else
    tmpVal = EGCD(m, b % m, recLevel+1)
    tmpVal2 = [tmpVal[1], tmpVal[0]-tmpVal[1] * ((b/m).to_i)]
    if recLevel == 0
      return tmpVal2[0] % m
    else
      return tmpVal2
    end
  end
end

########
def encrypt_message(msg, n, e)
  ciphers = []
  bytes = []
  msg.each_byte do |m|
    bytes << m
  end
#  puts bytes
  count = 0
  bytes.each do |b|
    enc = encrypt(b, n, e)
    if @@verbose
      puts "Char: #{bytes[count]} - Cipher: #{enc}"
    end
    ciphers << encrypt(b, n, e)
    count = count + 1
  end
#  puts ciphers
  return ciphers
end

def decrypt_message(ciphers, n, d)
  decrypted = []
  ciphers.each do |c|
    decrypted << decrypt(c, n, d).chr
  end
  return decrypted.to_s
end
########
primes = gen_primes(1000, 10000)
p = get_prime(primes); puts "p: #{p}"
q = get_prime(primes); puts "q: #{q}"
#p = 3; puts "p: #{p}"
#q = 5; puts "q: #{q}"
n = p * q; puts "n: #{n}"
phi = (p - 1) * (q - 1); puts "phi: #{phi}"
e = get_e(phi); puts "e: #{e}"
d = get_d(phi, e); puts "d: #{d}"

#########
#m = 7; puts "m: #{m}" ## Using 7 as the "message" that should come out the same (m1)
#c = encrypt(m, n, e); puts "c: #{c}"
#m1 = decrypt(c, n, d); puts "m1: #{m1}"
puts "Message to Encrypt is: #{message}\nEncrypting..."
message_enc = encrypt_message(message, n, e)
message_dec = decrypt_message(message_enc, n, d)
puts "Decrypted message is:  #{message_dec}"
#
## Below just tests to make sure that the encrypt and decrypt methods are working properly. WORKS!! (w/ simple example)
##p = 11; q = 3; n = 33; phi = 20; e = 3; d = 7
##m = 7
##c = encrypt(m, n, e); puts "c: #{c}"
##m1 = decrypt(c, n, d); puts "m1: #{m1}"

#puts get_d(18,7)
