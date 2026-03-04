---
title: Syntax Example 2
layout: single
---

Here’s the **Markdown-formatted explanation** of what happens when you **mutate**, **transcribe**, and **translate** a gene in **olang**:

---

## 🧬 What Happens When You `mutate`, `transcribe`, and `translate` a Gene in **olang**

In **olang**, symbolic biological operations follow the same conceptual flow as molecular biology. When you apply the sequence:

```olang
TP53 ⇝ mutate at 5 with "C→T" ⇒ transcribe ⇒ translate;
```

you are symbolically simulating a **point mutation**, followed by **gene expression** steps.

---

### 🔁 Step-by-Step Breakdown

#### 1. **Mutation**
- The `⇝ mutate at 5 with "C→T"` operation symbolically modifies the gene's DNA.
- This is a **point mutation**, substituting the nucleotide **C** at position 5 with **T**.
- The result is a **new `Gene` object**, preserving symbolic traceability back to the original gene.

```text
Original DNA: ATGCGTACCTGA
               ↑
             position 5: C → T
Mutated DNA:  ATGCGTATCTGA
```

#### 2. **Transcription**
- The mutated DNA is transcribed into an mRNA `Transcript`.
- DNA → RNA: All **T** nucleotides become **U** in the transcript.

```text
Mutated DNA: ATG CGT ATC TGA
mRNA:        AUG CGU AUC UGA
```

#### 3. **Translation**
- The transcript is translated into a `Protein` by reading RNA codons (triplets) and converting them into amino acids.

```text
Codons:       AUG | CGU | AUC | UGA
Amino Acids:  Met | Arg | Ile | Stop
```

> **Note**: `UGA` is a **stop codon**, so translation halts there.

---

### 🧠 In olang Terms

```olang
define gene TP53 {
    sequence: DNA("ATGCGTACCTGA")
};

TP53 ⇝ mutate at 5 with "C→T" ⇒ transcribe ⇒ translate;
```

- Returns a `Protein` object derived from the **mutated gene**.
- Symbolically maintains a traceable path:  
  `Gene → Transcript → Protein`, with mutation metadata.

---

### ✅ Final Result: `Protein` Object with Mutation Context

```json
{
  "name": "TP53_variant",
  "origin": "TP53",
  "mutation": "C→T at position 5",
  "sequence": "MRI",
  "codons": ["AUG", "CGU", "AUC", "UGA"],
  "aminoAcids": ["Met", "Arg", "Ile"],
  "stopped": true
}
```

---

### 🔍 Use Case in Analysis

This symbolic mutation flow can be used to:
- Simulate **SNP effects** on protein structure
- Model **loss-of-function** or **gain-of-function** variants
- Integrate with AI to predict downstream **phenotypic impact**

---

Let me know if you’d like to simulate other mutation types (insertion, deletion, frameshift) in olang!
