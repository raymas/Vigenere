# Vigenere

Some lua tools for vigenere encryption, decryption and brute-force.<br>
Based on the basic [Blaise de Vigenère algorithm](https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher).

## Brief Introduction

Vigenère cipher is a enhancement of Caesar's cipher. This is a substitution encryption technique as plain text letters are replaced by some fixed number of positions down the alphabet.<br>
To implement it we need a plain-text and a key. Assuming the text is *Vigenere* and the key is *lua* . We map every alphabet character to its position :
```
a = 0, b = 1, c = 2, [...] z = 25
```
and we repeatedly add the key values to our plain text :
```
VIGENERE
LUALUALU
||||||||
GCGPHECY
```
Encoded text is ```GCGPHECY```.

## Getting Started

### Prerequisites

Required libraries :
* **lua** (tested on 5.1.5)  

### Installing

Clone the repository
```
git clone https://github.com/raymas/Vigenere.git
```

### Usage
Four functions are implemented : three for a ciphertext-only attack, one for encryption.

**Brute force**
```
keylengthguess(text, language, maxkeylength, verbose)
guessingKey(text, language, keylength, verbose)
decrypt(text, key, language)
```
You can use the three function to try a brute force decryption.<br>

Firstly, we have to guess the key length using a frequency analysis of every letter in the encrypted text. It works better with long text as the key is repeating multiple times.<br>

Secondly, we have to guess the key based



## Contributing

Please read [CONTRIBUTING.md]() for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

* **raymas** - *Initial work* - [raymas](https://github.com/raymas)

See also the list of [contributors](https://github.com/raymas/Vigenere/contributors) who participated in this project.

## License

This project is licensed under the GNU 3.0 License - see the [LICENSE.md](LICENSE.md) file for details
