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

---

## Hexadecimal Number System

The **hecadecimal number system** is a **positional** base-16 system. This means:

1. **Digits:** The system has **16** digits: **0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F**.
2. **Place Value:** The position of a digit determines its value, based on powers of 16.
3. **Numbers Greater Than 16:** Once you reach 16, the next number (16) requires two digits: **1** in the "sixteens" place and **0** in the "ones" place.

For example, in **base-16**:

(3x16&#x00b2;) + (0x16&#x00b9;) + (10x16&#x2070;) = 30A&#x2081;&#x2086;

Since any digit multiplied by 0 equals 0, we can omit that value from the calculation resulting in:

(3x16&#x00b2;) + (10x16&#x2070;) = 30A&#x2081;&#x2086;

In general, in any **base-**\(b\) number system:

- The available digits range from **0** to \(b - 1\).
- A number is written using positional notation, where each digit represents a power of the base.

---

## Conversion Between Number Systems

### Useful Tables

<table style="border-collapse: collapse; width: 35%; border-style: none;" border="0">
    <caption>Powers of 2</caption>
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
<p>&nbsp;</p>
<table style="border-collapse: collapse; width: 25%; border-style: none;" border="0">
    <caption>Powers of 16</caption>
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
<p>&nbsp;</p>
<table style="border-collapse: collapse; width: 50%; border-style: none;" border="0">
    <caption>Binary to Hexadecimal</caption>
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
<h3>Decimal to Hexadecimal</h3>
<h4>Example 1: Convert Decimal 27 to Hexadecimal</h4>
<p><strong>Step 1</strong>: Find the largest power of 16, smaller than or equal to 27.</p>
<ul>
    <li>16&sup2; = 256 (too big)</li>
    <li>16&sup1; = 16 (this works)</li>
</ul>
<p><strong>Step 2</strong>: Divide 27 by 16&sup1; (which is 16).</p>
<ul>
    <li>27 &divide; 16 = 1 remainder 11</li>
</ul>
<p><strong>Step 3</strong>: Take the remainder (11) and divide by 16⁰ (which is 1).</p>
<ul>
    <li>11 &divide; 1 = 11 remainder 0</li>
</ul>
<p><strong>Step 4</strong>: Convert 11 to its hexadecimal digit.</p>
<ul>
    <li>11 in decimal = B</li>
</ul>
<p>Putting it all together, the hexadecimal&nbsp;digits are 1 (from the second step) and B (from the third and fourth steps).</p>
<p><strong>Answer</strong>: 1B&#x2081;&#x2086;</p>
<h4>Example 2: Convert Decimal 258 to Hexadecimal</h4>
<p><strong>Step 1</strong>: Find the largest power of 16, smaller than or equal to 258.</p>
<ul>
    <li>16&sup2; = 256 (&le; 258, so that&rsquo;s good)</li>
</ul>
<p><strong>Step 2</strong>: Divide 258 by 16<sup>2</sup> (which is 256).</p>
<ul>
    <li>258 &divide; 256 = 1 remainder 2</li>
</ul>
<p><strong>Step 3</strong>: Take the remainder (2) and divide by 16<sup>1</sup> (which is 16).</p>
<ul>
    <li>2 &divide; 16 = 0 remainder 2 (since 2 is smaller than 16)</li>
</ul>
<p><strong>Step 4</strong>: Take the remainder (2) and divide by 16<sup>0</sup> (which is 1).</p>
<ul>
    <li>2 &divide; 1 = 2 remainder 0</li>
</ul>
<p>Putting it all together, the hexadecimal&nbsp;digits are 1 (from the second step), 0 (from the third step), and 2 (from the fourth step).</p>
<p><strong>Answer</strong>: 102&#x2081;&#x2086;</p>
---
<h3>Hexadecimal to Decimal</h3>
<h4>Example 1: Convert 1B&#x2081;&#x2086;&nbsp;to Decimal</h4>
<ol>
    <li>
        <p>Identify the hex digits:</p>
        <ul>
            <li><strong>1</strong> (which is 1 in decimal)</li>
            <li><strong>B</strong> (which is 11 in decimal)</li>
        </ul>
    </li>
    <li>
        <p>Multiply each digit by 16 to the power of its position:</p>
        <ul>
            <li><strong>1</strong> x 16&sup1; = 1 x 16 = 16</li>
            <li><strong>B</strong> (11 in decimal) &times; 16&#x2070; = 11 x 1 = 11</li>
        </ul>
    </li>
    <li>
        <p>Add the results:</p>
    </li>
</ol>
<p>&nbsp; &nbsp; &nbsp; 16 + 11 = 27</p>
<p><strong>Answer</strong>: 27</p>
<h4>Example 2: Convert<strong> </strong>A4&#x2081;&#x2086; to Decimal</h4>
<ol>
    <li>
        <p>Identify the hex digits:</p>
        <ul>
            <li><strong>A</strong> (which is 10 in decimal)</li>
            <li><strong>4</strong> (which is 4 in decimal)</li>
        </ul>
    </li>
    <li>
        <p>Multiply each digit by 16 to the power of its position:</p>
        <ul>
            <li><strong>A</strong> &times; 16&sup1; = 10 &times; 16 = 160</li>
            <li><strong>4</strong> &times; 16⁰ = 4 &times; 1 = 4</li>
        </ul>
    </li>
    <li>
        <p>Add the results:</p>
    </li>
</ol>
<p>&nbsp; &nbsp; &nbsp; 160 + 4 = 164</p>
<p><strong>Answer</strong>: 164&nbsp;</p>
---
<h3>Decimal to Binary</h3>
<h4>Example 1: Convert Decimal 4067 to Binary</h4>
<p>We keep dividing by powers of 2, starting from the largest that&rsquo;s less than or equal to 4067:</p>
<p>4067 &divide; 2048 = 1, remainder 2019</p>
<p>2019 &divide; 1024 = 1, remainder 995</p>
<p>995 &divide; 512 = 1, remainder 483</p>
<p>483 &divide; 256 = 1, remainder 227</p>
<p>227 &divide; 128 = 1, remainder 99</p>
<p>99 &divide; 64 = 1, remainder 35</p>
<p>35 &divide; 32 = 1, remainder 3</p>
<p>3 &divide; 16 = 0, remainder 3</p>
<p>3 &divide; 8 = 0, remainder 3</p>
<p>3 &divide; 4 = 0, remainder 3</p>
<p>3 &divide; 2 = 1, remainder 1</p>
<p>1 &divide; 1 = 1, remainder 0</p>
<p>Collecting the <strong>quotients</strong> (the &ldquo;1&rdquo; or &ldquo;0&rdquo; in each step) in order, we get the binary digits: 111111100011.</p>
<p><strong>Answer</strong>: 1111 1110 0011&#x2082;</p>
<h4>Example 2: Convert Decimal 45 to Binary</h4>
<p>45 &divide; 32 = 1, remainder 13</p>
<p>13 &divide; 16 = 0, remainder 13</p>
<p>13 &divide; 8 = 1, remainder 5</p>
<p>5 &divide; 4 = 1, remainder 1</p>
<p>1 &divide; 2 = 0, remainder 1</p>
<p>1 &divide; 1 = 1, remainder 0</p>
<p>Collecting the quotients (the "1" or "0" in each step) in order, we get the binary digits: 101101</p>
<p><strong>Answer</strong>:&nbsp; 0010 1101&#x2082; (leading zeros can be added for clarity).</p>
---
<h3>Binary to Decimal</h3>
<p><strong>General Steps</strong></p>
<ol>
    <li>Multiply each binary digit (bit) by 2 raised to its position index (starting from 0 on the right).</li>
    <li>Add all these products together to get the decimal number.</li>
</ol>
<h4>Example 1: Convert 0010 1101&#x2082; to Decimal</h4>
<p>Calculation:</p>
<p>(0 &times; 2&#x2077;) + (0 &times; &#x2076;) + (1 &times; 2&#x2075;) + (0 &times; 2&#x2074;) + (1 &times; 2&#x00b3;) + (1 &times; 2&#x00b2;) + (0 &times; 2&#x00b9;) + (1 &times; 2&#x2070;)<br />= (0 &times; 128) + (0 &times; 64) + (1 &times; 32) + (0 &times; 16) + (1 &times; 8) + (1 &times; 4) + (0 &times; 2) + (1 &times; 1)<br />= 0 + 0 + 32 + 0 + 8 + 4 + 0 + 1 = 45</p>
<p><strong>Answer</strong>: 45</p>
<h4>Example 2: Convert 1111&#x2082; to Decimal</h4>
<ul>
    <li>Bits: 1 1 1 1 (from left to right, that&rsquo;s positions 3, 2, 1, 0)</li>
</ul>
<p>Calculation:</p>
<p>(1 &times; 2&#x00B3;) + (1 &times; 2&#x00B2;) + (1 &times; 2&#x00B9;) + (1 &times; 2&#x2070;)<br />= (1 &times; 8) + (1 &times; 4) + (1 &times; 2) + (1 &times; 1) = 8 + 4 + 2 + 1 = 15</p>
<p><strong>Answer</strong>: 15</p>
---
<h3>Hexadecimal to Binary</h3>
<h4>Example 1: Convert 1B&#x00B9;&#x2076; to Binary</h4>
<ol>
    <li>
        <p>Split into individual hex digits:</p>
        <ul>
            <li>1</li>
            <li>B</li>
        </ul>
    </li>
    <li>
        <p>Convert each digit to its 4-bit binary form:</p>
        <ul>
            <li>1 in hex &rarr; 0001 in binary</li>
            <li>B in hex &rarr; 1011 in binary (B = 11 in decimal, which is 1011 in binary)</li>
        </ul>
    </li>
    <li>
        <p>Combine the two 4-bit groups:</p>
    </li>
</ol>
<p>&nbsp; &nbsp; &nbsp; 0001 1011</p>
<p><strong>Answer</strong>: 0001 1011&#x2082;</p>
<h4>Example 2: Convert A4&#x00B9;&#x2076; to Binary</h4>
<ol>
    <li>
        <p><strong>Split into individual hex digits</strong>:</p>
        <ul>
            <li>A</li>
            <li>4</li>
        </ul>
    </li>
    <li>
        <p><strong>Convert each digit to its 4-bit binary form</strong>:</p>
        <ul>
            <li><strong>A</strong> in hex &rarr; <strong>1010</strong> in binary (A = 10 in decimal)</li>
            <li><strong>4</strong> in hex &rarr; <strong>0100</strong> in binary</li>
        </ul>
    </li>
    <li>
        <p><strong>Combine the two 4-bit groups</strong>:</p>
    </li>
</ol>
<p>&nbsp; &nbsp; &nbsp; 10100100</p>
<p><strong>Answer</strong>: 1010 0100&#x2082;</p>
---
<h3>Binary to Hexadecimal</h3>
<h4>Example 1: Convert 1100 1110&#x2082; to Hexadecimal</h4>
<ol>
    <li>Split into groups of 4 bits (right to left):
        <ul>
            <li>1100 1110</li>
        </ul>
    </li>
    <li>Convert each group to hex:
        <ul>
            <li>1100 = C</li>
            <li>1110 = E</li>
        </ul>
    </li>
</ol>
<p><strong>Answer</strong>: CE&#x2081;&#x2086; </p>
<h4>Example 2: Convert 1111011000&#x2082; to Hexadecimal</h4>
<ol>
    <li>Split into groups of 4 bits (right to left). Add leading zeros if needed:
        <ul>
            <li>1111011000 &rarr; 0011 1101 1000</li>
        </ul>
    </li>
    <li>Convert each nibble:
        <ul>
            <li>0011 = 3</li>
            <li>1101 = D</li>
            <li>1000 = 8</li>
        </ul>
    </li>
</ol>
**Answer:** 3D8&#x2081;&#x2086;
