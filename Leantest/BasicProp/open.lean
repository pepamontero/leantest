import Leantest.BasicProp.basic


/-
  CHARACTERIZATION OF OPEN
U ⊆ X is Open in X if it's Open Neighbourhood of all its points
-/

lemma A_open_iff_is_heighbourhood_of_all
    {X : Type} [T : TopologicalSpace X]
    (A : Set X) : IsOpen A ↔
    ∀ x ∈ A, Neighbourhood A x := by
  constructor
  all_goals intro h
  · -- →
    intro x hx
    use A
    constructor
    trivial
    constructor
    exact hx
    exact h

  · -- ←
    -- classical choose?
    have h : ∀ a : X, a ∈ A → ∃ Ua : Set X, (Ua ⊆ A ∧ OpenNeighbourhood Ua a)
    · exact h

    have aux : A = ∅ ∨ ¬ (A = ∅)
    exact Classical.em (A = ∅)

    cases' aux with h1 h2

    · -- A is empty
      rw [h1]
      exact isOpen_empty

    · -- A is not empty
      --let g : A → Set X := fun a : A ↦ Classical.choose (h a a.property)

      have hUnion : A = ⋃ a : A, Classical.choose (h a a.property)
      · ext x ; constructor <;> intro hx
        · let hx' := Classical.choose_spec (h x hx)
          simp
          use x
          use hx
          exact hx'.right.left
        · simp at hx
          cases' hx with y hy
          cases' hy with hy hx
          let m := Classical.choose_spec (h y hy)
          apply m.left
          exact hx

      rw [hUnion]

      have hOpen : ∀ a : A, IsOpen (Classical.choose (h a a.property))
      · intro a
        let ha := Classical.choose_spec (h a a.property)
        exact ha.right.right

      exact isOpen_iUnion hOpen
