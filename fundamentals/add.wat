;; (module
;;   (func $add (param $lhs i32) (param $rhs i32) (result i32)
;;     get_local $lhs
;;     get_local $rhs
;;     i32.add)
;;   (export "add" (func $add))
;; )

(module
  (func $add (param $lhs i32) (param $rhs i32) (result i32)
    (i32.add
      (get_local $lhs)
      (get_local $rhs)
    )
  )
  (export "add" (func $add))
)
