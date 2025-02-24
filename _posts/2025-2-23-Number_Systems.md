---
layout: post
title: Number Systems
tags: number-systems
---

Number systems form the foundation of all numerical representations in computing, mathematics, and everyday life. They define how numbers are written, interpreted, and manipulated across different contexts. Each number system operates on a specific base and follows a unique set of rules for representing values.

The most common number systems include:

* Decimal (Base-10): The standard number system used in daily life, built on ten digits (0-9).
* Binary (Base-2): Used in computing, consisting of only two digits (0 and 1).
* Hexadecimal (Base-16): Frequently used in programming and digital systems, utilizing digits 0-9 and letters A-F.

Understanding number systems is essential in fields like computer science, electronics, and data representation. Mastering conversions between these systems allows efficient interpretation of digital data and enhances problem-solving skills in technology and engineering.

---

## Decimal Number System

The **Hindu-Arabic** or **decimal number system** is a **positional** base-10 system. This means:

1. **Digits:** The system has **ten** digits: **0, 1, 2, 3, 4, 5, 6, 7, 8, 9**.
2. **Place Value:** The position of a digit determines its value, based on powers of 10.  For example: 10&#x2076; 10&#x2075; 10&#x2074; 10&#x00b3; 10&#x00b2; 10&#x00b9; 10&#x2070; 
3. **Numbers Greater Than 9:** Once you reach 9, the next number (10) requires two digits: **1** in the "tens" place and **0** in the "ones" place.

For example, in **base-10**:

(3x10&#x00b3;) + (0x10&#x00b2;) + (4x10&#x00b9;) + (5x10&#x2070;) = 3045

Since any digit multiplied by 0 equals 0, we can omit that value from the calculation resulting in:

(3x10&#x00b3;) + (4x10&#x00b9;) + (5x10&#x2070;) = 3045

---

## Binary Number System

The **binary number system** is a **positional** base-2 system. This means:

1. **Digits:** The system has **2** digits: **0, 1**.
2. **Place Value:** The position of a digit determines its value, based on powers of 2.  For example:   2&#x2077; 2&#x2076; 2&#x2075; 2&#x2074; 2&#x00b3; 2&#x00b2; 2&#x00b9; 2&#x2070;.
3. **Numbers Greater Than 1:** Once you reach 1, the next number (2) requires two digits: **1** in the "twos" place and **0** in the "ones" place.

For example, in **base-2**: 1011 1110 0101&#x2082;

(1x2&#x00b9;&#x00b9;) + (0x2&#x00b9;&#x2070;) + (1x2&#x2079;) + (1x2&#x2078;) + (1x2&#x2077;) + (1x2&#x2076;) + (1x2&#x2075;) + (0x2&#x2074;) + (0x2&#x00b3;) + (1x2&#x00b2;) + (0x2&#x00b9;) + (1x2&#x2070;) = 3045

Since any digit multiplied by 0 equals 0, we can omit that value from the calculation resulting in:

(1x2&#x00b9;&#x00b9;) + (1x2&#x2079;) + (1x2&#x2078;) + (1x2&#x2077;) + (1x2&#x2076;) + (1x2&#x2075;) + (1x2&#x00b2;) + (1x2&#x2070;) = 3045

### Binary Numbers are written in several ways

* A prefix of **0b** indicates that the following digits are binary, a convention used in Python and many other programming languages.
  * For example: 0b101111100101
* A subscript of "&#x2082;" following the digits indicates a binary number.
  * For example: 101111100101&#x2082;
* Binary numbers are often split into groups of 4 bits (right to left) to make them easier to read.
  * For example: 1011 1111 0101&#x2082; 
* It is common to add zeros on the left side of a binary number to form a complete nibble, byte or word.
  * For example: 111110 &rarr; 00111110

---

## Hexadecimal Number System

The **hecadecimal number system** is a **positional** base-16 system. This means:

1. **Digits:** The system has **16** digits: **0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F**.
2. **Place Value:** The position of a digit determines its value, based on powers of 16.
3. **Numbers Greater Than 15:** Once you reach 15, the next number (16) requires two digits: **1** in the "sixteens" place and **0** in the "ones" place.

For example, in **base-16**:

(3x16&#x00b2;) + (0x16&#x00b9;) + (10x16&#x2070;) = 30A&#x2081;&#x2086;

Since any digit multiplied by 0 equals 0, we can omit that value from the calculation resulting in:

(3x16&#x00b2;) + (10x16&#x2070;) = 30A&#x2081;&#x2086;

In general, in any **base-**\(b\) number system:

* The available digits range from **0** to \(b - 1\).
* A number is written using positional notation, where each digit represents a power of the base.

---

## Conversion Between Number Systems

### Useful Tables

#### Powers of 2

<table style="border-collapse: collapse; width: 35%; border-style: none;" border="0">
  <tbody>
    <tr>
      <th style="width: 24%; border-style: solid; background-color: #c2e0f4;">Power</th>
      <th style="width: 24%; border-style: solid; background-color: #c2e0f4;">Value</th>
      <th style="width: 4%; border: none;"></th>
      <th style="width: 24%; border-style: solid; background-color: #c2e0f4;">Power</th>
      <th style="width: 24%; border-style: solid; background-color: #c2e0f4;">Value</th>
    </tr>
    <tr>
      <td style="width: 24%; border-style: solid;">2&#x2070;</td>
      <td style="width: 24%; border-style: solid;">1</td>
      <td style="width: 4%; border: none;"></td>
      <td style="width: 24%; border-style: solid;">2&#x2078;</td>
      <td style="width: 24%; border-style: solid;">256</td>
    </tr>
    <tr>
      <td style="width: 24%; border-style: solid;">2&#x00B9;</td>
      <td style="width: 24%; border-style: solid;">2</td>
      <td style="width: 4%; border: none;"></td>
      <td style="width: 24%; border-style: solid;">2&#x2079;</td>
      <td style="width: 24%; border-style: solid;">512</td>
    </tr>
    <tr>
      <td style="width: 24%; border-style: solid;">2&#x00B2;</td>
      <td style="width: 24%; border-style: solid;">4</td>
      <td style="width: 4%; border: none;"></td>
      <td style="width: 24%; border-style: solid;">2&#x00B9;&#x2070;</td>
      <td style="width: 24%; border-style: solid;">1024</td>
    </tr>
    <tr>
      <td style="width: 24%; border-style: solid;">2&#x00B3;</td>
      <td style="width: 24%; border-style: solid;">8</td>
      <td style="width: 4%; border: none;"></td>
      <td style="width: 24%; border-style: solid;">2&#x00B9;&#x00B9;</td>
      <td style="width: 24%; border-style: solid;">2048</td>
    </tr>
    <tr>
      <td style="width: 24%; border-style: solid;">2&#x2074;</td>
      <td style="width: 24%; border-style: solid;">16</td>
      <td style="width: 4%; border: none;"></td>
      <td style="width: 24%; border-style: solid;">2&#x00B9;&#x00B2;</td>
      <td style="width: 24%; border-style: solid;">4096</td>
    </tr>
    <tr>
      <td style="width: 24%; border-style: solid;">2&#x2075;</td>
      <td style="width: 24%; border-style: solid;">32</td>
      <td style="width: 4%; border: none;"></td>
      <td style="width: 24%; border-style: solid;">2&#x00B9;&#x00B3;</td>
      <td style="width: 24%; border-style: solid;">8192</td>
    </tr>
    <tr>
      <td style="width: 24%; border-style: solid;">2&#x2076;</td>
      <td style="width: 24%; border-style: solid;">64</td>
      <td style="width: 4%; border: none;"></td>
      <td style="width: 24%; border-style: solid;">2&#x00B9;&#x2074;</td>
      <td style="width: 24%; border-style: solid;">16,384</td>
    </tr>
    <tr>
      <td style="width: 24%; border-style: solid;">2&#x2077;</td>
      <td style="width: 24%; border-style: solid;">128</td>
      <td style="width: 4%; border: none;"></td>
      <td style="width: 24%; border-style: solid;">2&#x00B9;&#x2075;</td>
      <td style="width: 24%; border-style: solid;">32,768</td>
    </tr>
  </tbody>
</table>

#### Powers of 16

<table style="border-collapse: collapse; width: 25%; border-style: none;" border="0">
  <tbody>
    <tr>
      <th style="width: 50%; border-style: solid; background-color: #c2e0f4;">Power</th>
      <th style="width: 50%; border-style: solid; background-color: #c2e0f4;">Value</th>
    </tr>
    <tr style="height: 28px;">
      <td style="width: 50%; height: 28px; border-style: solid;">16&#x2070;</td>
      <td style="width: 50%; height: 28px; border-style: solid;">1</td>
    </tr>
    <tr style="height: 28px;">
      <td style="width: 50%; height: 28px; border-style: solid;">16&#x00B9;</td>
      <td style="width: 50%; height: 28px; border-style: solid;">16</td>
    </tr>
    <tr style="height: 28px;">
      <td style="width: 50%; height: 28px; border-style: solid;">16&#x00B2;</td>
      <td style="width: 50%; height: 28px; border-style: solid;">256</td>
    </tr>
    <tr style="height: 28px;">
      <td style="width: 50%; height: 28px; border-style: solid;">16&#x00B3;</td>
      <td style="width: 50%; height: 28px; border-style: solid;">4096</td>
    </tr>
  </tbody>
</table>

#### Binary to Hexadecimal

<table style="border-collapse: collapse; width: 50%; border-style: none;" border="0">
  <tbody>
    <tr>
      <th style="width: 20%; border-style: solid; background-color: #c2e0f4; text-align: center;">Binary</th>
      <th style="width: 28%; border-style: solid; background-color: #c2e0f4; text-align: center;">Hexadecimal</th>
      <th style="width: 4%; border: none;"></th>
      <th style="width: 20%; border-style: solid; background-color: #c2e0f4; text-align: center;">Binary</th>
      <th style="width: 28%; border-style: solid; background-color: #c2e0f4; text-align: center;">Hexadecimal</th>
    </tr>
    <tr>
      <td style="width: 20%; border-style: solid;">0000</td>
      <td style="width: 28%; border-style: solid; text-align: center;">0</td>
      <td style="width: 4%; border: none;"></td>
      <td style="width: 20%; border-style: solid;">1000</td>
      <td style="width: 28%; border-style: solid; text-align: center;">8</td>
    </tr>
    <tr>
      <td style="width: 20%; border-style: solid;">0001</td>
      <td style="width: 28%; border-style: solid; text-align: center;">1</td>
      <td style="width: 4%; border: none;"></td>
      <td style="width: 20%; border-style: solid;">1001</td>
      <td style="width: 28%; border-style: solid; text-align: center;">9</td>
    </tr>
    <tr>
      <td style="width: 20%; border-style: solid;">0010</td>
      <td style="width: 28%; border-style: solid; text-align: center;">2</td>
      <td style="width: 4%; border: none;"></td>
      <td style="width: 20%; border-style: solid;">1010</td>
      <td style="width: 28%; border-style: solid; text-align: center;">A</td>
    </tr>
    <tr>
      <td style="width: 20%; border-style: solid;">0011</td>
      <td style="width: 28%; border-style: solid; text-align: center;">3</td>
      <td style="width: 4%; border: none;"></td>
      <td style="width: 20%; border-style: solid;">1011</td>
      <td style="width: 28%; border-style: solid; text-align: center;">B</td>
    </tr>
    <tr>
      <td style="width: 20%; border-style: solid;">0100</td>
      <td style="width: 28%; border-style: solid; text-align: center;">4</td>
      <td style="width: 4%; border: none;"></td>
      <td style="width: 20%; border-style: solid;">1100</td>
      <td style="width: 28%; border-style: solid; text-align: center;">C</td>
    </tr>
    <tr>
      <td style="width: 20%; border-style: solid;">0101</td>
      <td style="width: 28%; border-style: solid; text-align: center;">5</td>
      <td style="width: 4%; border: none;"></td>
      <td style="width: 20%; border-style: solid;">1101</td>
      <td style="width: 28%; border-style: solid; text-align: center;">D</td>
    </tr>
    <tr>
      <td style="width: 20%; border-style: solid;">0110</td>
      <td style="width: 28%; border-style: solid; text-align: center;">6</td>
      <td style="width: 4%; border: none;"></td>
      <td style="width: 20%; border-style: solid;">1110</td>
      <td style="width: 28%; border-style: solid; text-align: center;">E</td>
    </tr>
    <tr>
      <td style="width: 20%; border-style: solid;">0111</td>
      <td style="width: 28%; border-style: solid; text-align: center;">7</td>
      <td style="width: 4%; border: none;"></td>
      <td style="width: 20%; border-style: solid;">1111</td>
      <td style="width: 28%; border-style: solid; text-align: center;">F</td>
    </tr>
  </tbody>
</table>

---

### Decimal to Hexadecimal

#### Example 1: Convert Decimal 27 to Hexadecimal

**Step 1:** Find the largest power of 16, smaller than or equal to 27.

* 16&sup2; = 256 (too big)
* 16&sup1; = 16 (this works)

**Step 2:** Divide 27 by 16&sup1; (which is 16).

 * 27 &divide; 16 = 1 remainder 11</li>

**Step 3:** Take the remainder (11) and divide by 16⁰ (which is 1).

* 11 &divide; 1 = 11 remainder 0

**Step 4:** Convert 11 to its hexadecimal digit.

* 11 in decimal = B

Putting it all together, the hexadecimal&nbsp;digits are 1 (from the second step) and B (from the third and fourth steps).

**Answer:** 1B&#x2081;&#x2086;

#### Example 2: Convert Decimal 258 to Hexadecimal

**Step 1:** Find the largest power of 16, smaller than or equal to 258.

* 16&sup2; = 256 (&le; 258, so that&rsquo;s good)

**Step 2**: Divide 258 by 16&#x00B2; (which is 256).

* 258 &divide; 256 = 1 remainder 2

**Step 3:** Take the remainder (2) and divide by 16&#x00B9; (which is 16).

* 2 &divide; 16 = 0 remainder 2 (since 2 is smaller than 16)

**Step 4**: Take the remainder (2) and divide by 16&#x2070 (which is 1).

* 2 &divide; 1 = 2 remainder 0

Putting it all together, the hexadecimal&nbsp;digits are 1 (from the second step), 0 (from the third step), and 2 (from the fourth step).

**Answer:** 102&#x2081;&#x2086;

---

### Hexadecimal to Decimal

#### Example 1: Convert 1B&#x2081;&#x2086;&nbsp;to Decimal

1. Identify the hex digits:
   * **1** (which is 1 in decimal)
   * **B** (which is 11 in decimal)

2. Multiply each digit by 16 to the power of its position:
   * **1**  x 16&sup1; = 1 x 16 = 16
   * **B** (11 in decimal) &times; 16&#x2070; = 11 x 1 = 11

3. Add the results:
   * 16 + 11 = 27

**Answer:** 27

#### Example 2: Convert A4&#x2081;&#x2086; to Decimal

1. Identify the hex digits:
   * **A** (which is 10 in decimal)
   * **4** (which is 4 in decimal)

2. Multiply each digit by 16 to the power of its position:
   * **A** &times; 16&sup1; = 10 &times; 16 = 160
   * **4** &times; 16⁰ = 4 &times; 1 = 4

3. Add the results:
   * 160 + 4 = 164

**Answer:** 164

---

### Decimal to Binary

#### Example 1: Convert Decimal 4067 to Binary

We keep dividing by powers of 2, starting from the largest that&rsquo;s less than or equal to 4067:

4067 &divide; 2048 = 1, remainder 2019

2019 &divide; 1024 = 1, remainder 995

995 &divide; 512 = 1, remainder 483

483 &divide; 256 = 1, remainder 227

227 &divide; 128 = 1, remainder 99

99 &divide; 64 = 1, remainder 35

35 &divide; 32 = 1, remainder 3

3 &divide; 16 = 0, remainder 3

3 &divide; 8 = 0, remainder 3

3 &divide; 4 = 0, remainder 3

3 &divide; 2 = 1, remainder 1

1 &divide; 1 = 1, remainder 0

Collecting the **quotients** (the &ldquo;1&rdquo; or &ldquo;0&rdquo; in each step) in order, we get the binary digits: 111111100011.

**Answer:** 1111 1110 0011&#x2082;

#### Example 2: Convert Decimal 45 to Binary

We keep dividing by powers of 2, starting from the largest that&rsquo;s less than or equal to 45:

45 &divide; 32 = 1, remainder 13

13 &divide; 16 = 0, remainder 13

13 &divide; 8 = 1, remainder 5

5 &divide; 4 = 1, remainder 1

1 &divide; 2 = 0, remainder 1

1 &divide; 1 = 1, remainder 0

Collecting the **quotients** (the "1" or "0" in each step) in order, we get the binary digits: 101101

**Answer:** 0010 1101&#x2082; (leading zeros can be added for clarity).

---

### Binary to Decimal

#### General Steps

* Multiply each binary digit (bit) by 2 raised to its position index (starting from 0 on the right).
* Add all these products together to get the decimal number.

#### Example 1: Convert 0010 1101&#x2082; to Decimal

Calculation:

(0 &times; 2&#x2077;) + (0 &times; 2&#x2076;) + (1 &times; 2&#x2075;) + (0 &times; 2&#x2074;) + (1 &times; 2&#x00b3;) + (1 &times; 2&#x00b2;) + (0 &times; 2&#x00b9;) + (1 &times; 2&#x2070;)

= (0 &times; 128) + (0 &times; 64) + (1 &times; 32) + (0 &times; 16) + (1 &times; 8) + (1 &times; 4) + (0 &times; 2) + (1 &times; 1)

= 0 + 0 + 32 + 0 + 8 + 4 + 0 + 1 

= 45

**Answer:** 45

#### Example 2: Convert 1111&#x2082; to Decimal

* Bits: 1 1 1 1 (from left to right, that&rsquo;s positions 3, 2, 1, 0)

Calculation:

(1 &times; 2&#x00B3;) + (1 &times; 2&#x00B2;) + (1 &times; 2&#x00B9;) + (1 &times; 2&#x2070;)

= (1 &times; 8) + (1 &times; 4) + (1 &times; 2) + (1 &times; 1) 

= 8 + 4 + 2 + 1 

= 15

**Answer:** 15

---

### Hexadecimal to Binary

#### Example 1: Convert 1B&#x2081;&#x2086; to Binary

1. Split into individual hex digits:
   * 1
   * B
2. Convert each digit to its 4-bit binary form:
   * 1 in hex &rarr; 0001 in binary
   * B in hex &rarr; 1011 in binary (B = 11 in decimal, which is 1011 in binary)
3. Combine the two 4-bit groups:
   * 0001 1011

**Answer:** 0001 1011&#x2082;

#### Example 2: Convert A4&#x00B9;&#x2076; to Binary

1. Split into individual hex digits:
   * A
   * 4
2. Convert each digit to its 4-bit binary form:
   * A in hex &rarr; 1010 in binary (A = 10 in decimal, which is 1010 in binary)
   * 4 in hex &rarr; 0100 in binary
3. Combine the two 4-bit groups:
   * 1010 0100

**Answer:** 1010 0100&#x2082;

---

### Binary to Hexadecimal

#### Example 1: Convert 11001110&#x2082; to Hexadecimal

1. Split into groups of 4 bits (right to left):
   * 11001110 &rarr; 1100 1110

2. Convert each group to hex:
   * 1100 = C
   * 1110 = E

**Answer:** CE&#x2081;&#x2086;

#### Example 2: Convert 1111011000&#x2082; to Hexadecimal

1. Split into groups of 4 bits (right to left). Add leading zeros if needed:
   * 1111011000 &rarr; 0011 1101 1000

2. Convert each nibble:
   * 0011 = 3
   * 1101 = D
   * 1000 = 8

**Answer:** 3D8&#x2081;&#x2086;
