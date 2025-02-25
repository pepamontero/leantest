

import Leantest.BasicProp.basic

example (X : Type) (A B C : Set X) : (A ∪ B) ∩ C = (A ∩ C) ∪ (B ∩ C) := by
  exact Set.union_inter_distrib_right A B C

example (X : Type) (A : Set X) (S : Set (Set X)) :
    (⋃ B : S, B) ∩ A = (⋃ B : S, (B ∩ A)) := by
  exact Set.iUnion_inter A Subtype.val



def TopoSubspace {X : Type} (T : TopologicalSpace X) (Y : Set X) :
  TopologicalSpace Y where

  IsOpen (U : Set Y) := ∃ V : Set X, T.IsOpen V ∧ U = V ∩ Y
  isOpen_univ := by
    use (Set.univ : Set X)
    constructor
    · exact T.isOpen_univ
    · simp
  isOpen_inter := by
    intro s t hs ht
    cases' hs with u hu
    cases' ht with v hv
    use u ∩ v
    constructor
    · exact T.isOpen_inter u v hu.left hv.left
    · simp
      rw [hu.right, hv.right]
      exact Eq.symm (Set.inter_inter_distrib_right u v Y)
  isOpen_sUnion := by
    intro S hS
    simp at hS

    -- tomamos V = ∪_i V_i, los V_i de la def. de ab. para cada t_i ∈ S
    use ⋃ t : S, Classical.choose (hS t t.property)
    constructor
    · -- 1. V es abierto
      apply T.isOpen_sUnion
      simp
      intro u t ht hu
      let hu' := Classical.choose_spec (hS t ht)
      cases' hu' with hu' _
      rw [hu] at hu'
      exact hu'
    · -- 2. ⋃₀ S = V ∩ Y

      ext x ; constructor <;> intro hx
      · simp at hx
        cases' hx with t ht
        cases' ht with ht ht'
        let V := Classical.choose (hS t ht)
        let hV := Classical.choose_spec (hS t ht)
        rw [Set.iUnion_inter]
        use t
        constructor
        · rw [hV.right]
          simp
          use t
          use ht
        · simp
          exact ht'

      · simp at hx
        cases' hx with hx' hx
        cases' hx' with t ht
        cases' ht with ht hx'
        let V := Classical.choose (hS t ht)
        let hV := Classical.choose_spec (hS t ht)

        have aux : x ∈ (t : Set X)
        · rw [hV.right]
          constructor
          · exact hx'
          · exact hx

        simp
        use t
        constructor
        · exact ht
        · use hx
          exact Set.mem_of_mem_image_val aux
