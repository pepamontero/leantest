import Leantest.Separation.normal


def Q : Set ℚ := {q : ℚ | 0 ≤ q ∧ q ≤ 1} -- `ℚ ∩ [0, 1]`

lemma Q1 : 1 ∈ Q := by simp [Q]
lemma Q0 : 0 ∈ Q := by simp [Q]

lemma hf : ∃ f : ℕ → Q, (f.Bijective ∧ f 0 = ⟨1, Q1⟩  ∧ f 1 = ⟨0, Q0⟩) := by
  sorry

noncomputable def f : ℕ → Q := Classical.choose hf

example (n : ℕ) (hn : n > 1) : ∃ r ∈ Finset.range n,
    ((f r < f n) ∧
    (∀ m ∈ Finset.range n, f m < f n → f m ≤ f r)) := by

  induction' hn with n HI

  · --cb
    simp

    sorry

  · --cr
    sorry




/-
Lo que he pensado ahora es:
1. realmente no necesito inducción completa??
  porque me vale para cada m < n+1 el G(m) de la G obtenida en el paso n
  (creo)

2. a lo mejor solo tendría que hacerlo para todo n
  tal que cumpla f n ∈ [0, 1]
  y luego debajo y encima del 0 ya pongo empty?? no se
-/

lemma loqueyoquiero {X : Type} [T : TopologicalSpace X]
    (hT : NormalTopoSpace T)

    (C1 C2 : Set X)
    (hC1 : IsClosed C1)
    (hC2 : IsOpen C2ᶜ)
    (hC1C2 : C1 ⊆ C2ᶜ)

    :

    ∀ n : ℕ, (
      ∃ G : ℕ → Set X, (
        (∀ p : ℕ, p ≤ n → IsOpen (G p))
        ∧
        (∀ p q : ℕ, p ≤ n → q ≤ n → f p < f q → Closure (G p) ⊆ G q)
        )
    ) := by


  intro n
  induction' n with n HI

  · --caso base
    let G : ℕ → Set X := fun n ↦ C2ᶜ
    use G
    constructor
    · intro p hp
      simp [G]
      exact { isOpen_compl := hC2 }

    · intro p q hp hq hpq
      simp at hp hq
      rw [hp, hq] at hpq
      by_contra
      exact (lt_self_iff_false (f 0)).mp hpq

  · -- caso recursivo

    /-
    NOTA: igual aquí debería meter otro caso para n = 1,
    porque si no como que no estoy definiendo G (1) = Classical.choose...

    osea la movida es que aquí para la recursión necesito que haya al menos 2 elementos ya definidos
    -/
    rw [characterization_of_normal] at hT

    cases' HI with G' hG'

    let G : ℕ → Set X := fun m ↦
      if h : f m < 0 then ∅
      else if h : f m > 1 then Set.univ
      else if h : m < n + 1 then G' m
      else ∅

    use G

    constructor
    · sorry

    · sorry
