import Mathlib.Tactic

/-
EJERCICIO INCOMPLETO
Sinceramente no se si se puede hacer con estas definiciones
de intersección... ¡qué raro!
-/

-- ex 5
-- prove that the topology with finite complementaries is top


/-
PROBLEMA
Me gustaría generalizar esto para X tipo...
-/

set_option linter.unusedVariables false

-- este lo daría ya hecho
lemma Set.compl_of_univ {X : Type} : (Set.univ : Set X)ᶜ = ∅ := by
  ext x
  constructor <;> intro h
  · simp at h
  · simp
    trivial

lemma Set.inter_of_empty_left {X : Type} {A B : Set X} (hA : A = ∅) : A ∩ B = ∅ := by
  ext x
  constructor <;> intro hx
  rw [Set.mem_inter_iff] at hx
  rw [hA] at hx
  exact hx.left
  by_contra
  exact hx

lemma Set.inter_of_empty_right {X : Type} {A B : Set X} (hB : B = ∅) : A ∩ B = ∅ := by
  rw [Set.inter_comm]
  apply Set.inter_of_empty_left hB

lemma Set.sInter_of_empty (X : Type) : ⋂₀ (∅ : Set (Set X)) = (Set.univ : Set X) := by
  ext x
  constructor <;> intro hx
  · trivial
  · rw [Set.mem_sInter]
    intro t ht
    by_contra
    exact ht

-------------------------------

def CF.IsOpen (s : Set ℝ) := Set.Finite (sᶜ) ∨ s = ∅

lemma CF.isOpen_univ : CF.IsOpen (Set.univ : Set ℝ) := by
  rw [IsOpen]
  rw [Set.compl_of_univ]
  left
  exact Set.finite_empty


lemma CF.isOpen_inter (A B : Set ℝ) (hA : IsOpen A) (hB : IsOpen B) : IsOpen (A ∩ B) := by
  rw [IsOpen] at *
  rw [Set.compl_inter]
  cases' hA with hA hA
  -- caso Aᶜ finito
  · cases' hB with hB hB
    -- caso Bᶜ finito
    · left
      exact Set.Finite.union hA hB
    -- caso B = ∅
    · right
      exact Set.inter_of_empty_right hB
  -- caso A = ∅
  · right
    exact Set.inter_of_empty_left hA


lemma CF.isOpen_sUnion (S : Set (Set ℝ)) (hS : ∀ t ∈ S, IsOpen t) : IsOpen (⋃₀ S) := by
  rw [IsOpen] at *

  have aux : (∃ t, t ∈ S) ∨ ¬ (∃ t, t ∈ S)
  exact Classical.em (∃ t, t ∈ S)

  cases' aux with aux aux

  -- en caso de que S tenga conjuntos
  · rw [Set.compl_sUnion]
    -- también hay que separar entre que contenga al vacío o no lo contenga...
    left
    cases' aux with t ht
      -- la demo de ht1 y ht2 quizás se podría autocompletar? nose
    have ht1 : tᶜ.Finite
    specialize hS t ht
    rw [IsOpen] at hS
    cases' hS with hS hS
    exact hS

    exact Set.finite_empty hS

    have ht2 : tᶜ ∈ compl '' S
    simp
    exact ht

    exact Set.Finite.sInter ht2 ht1

  -- en caso de que S sea empty?? deberia ser facil no ????
  · right
    ext x
    constructor
    all_goals intro hx
    rw [Set.mem_sUnion] at hx
    cases' hx with t ht
    have h : ∃ t, t ∈ S
    use t
    exact ht.left
    exact aux h
    by_contra
    exact hx


/-
Results used
-/

#check Set.finite_empty
#check Set.compl_inter
#check Set.Finite.union
#check Set.compl_sUnion
#check Set.Finite.sInter
#check Set.not_nonempty_iff_eq_empty
#check Set.mem_sUnion
