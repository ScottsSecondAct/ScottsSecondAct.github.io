---
title: Syntax Example 1
layout: single
---
Sure! Here's your last response converted into clean **Markdown**:

---

## 🧬 What Happens When You Transcribe and Then Translate a Gene in olang?

When you **transcribe** and then **translate** a gene in biological terms—or in **olang’s symbolic model**—you follow the **central dogma of molecular biology**, ultimately producing a **protein**.

---

### 🔬 Biological Process

#### 1. **Transcription**
- **Input**: DNA sequence of a gene  
- **Output**: mRNA transcript (RNA sequence)

```text
DNA:       ATG CGT ACT GAA
Transcribe → 
RNA:       AUG CGU ACU GAA
```

#### 2. **Translation**
- **Input**: mRNA transcript  
- **Output**: Protein (amino acid sequence based on codons)

```text
RNA Codons:     AUG | CGU | ACU | GAA
Amino Acids:    Met | Arg | Thr | Glu
```

---

### 🧠 In olang Terms

```olang
gene TP53;
TP53 ⇒ transcribe ⇒ translate;
```

- `TP53 ⇒ transcribe` yields a symbolic `Transcript` object.
- `⇒ translate` on that transcript yields a `Protein` object.

---

### ✅ Final Result: `Protein` Object

This object may contain:

```json
{
  "name": "TP53_protein",
  "sourceTranscript": "TP53_mRNA",
  "sequence": "MRTG",
  "metadata": {
    "fromGene": "TP53",
    "startCodon": "AUG",
    "codons": ["AUG", "CGU", "ACU", "GAA"],
    "aminoAcids": ["Met", "Arg", "Thr", "Glu"]
  }
}
```

---

### 🧪 Example in Python Code

```python
gene = Gene("TP53", sequence="ATGCGTACTGAA")
transcript = gene.transcribe()
protein = transcript.translate()

print(protein.sequence)  # MRTG
```

---

Would you like class definitions for `Transcript` and `Protein` to support this logic in your olang compiler or interpreter?

---