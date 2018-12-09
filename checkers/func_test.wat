(module
  (memory $mem 1)
  (global $BLACK i32 (i32.const 1))
  (global $WHITE i32 (i32.const 2))
  (global $CROWN i32 (i32.const 4))

  (func $indexForPosition (param $x i32) (param $y i32) (result i32)
    (i32.add
      (i32.mul (i32.const 8) (get_local $y))
      (get_local $x)
    )
  )

  ;; Offset = (x + y * 8) * 4
  (func $offsetForPosition (param $x i32) (param $y i32) (result i32)
    (i32.mul
      (call $indexForPosition (get_local $x) (get_local $y))
      (i32.const 4)
    )
  )

  ;; Determine if a peice has been crowned
  (func $isCrowned (param $peice i32) (result i32)
    (i32.eq
      (i32.and (get_local $peice) (get_global $CROWN))
      (get_global $CROWN)
    )
  )

  ;; Determine if a peice is white
  (func $isWhite (param $peice i32) (result i32)
    (i32.eq
      (i32.and (get_local $peice) (get_global $WHITE))
      (get_global $WHITE)
    )
  )

  ;; Determine if a peice is black
  (func $isBlack (param $peice i32) (result i32)
    (i32.eq
      (i32.and (get_local $peice) (get_global $BLACK))
      (get_global $BLACK)
    )
  )

  ;; Adds a crown to a given peice (no mutation)
  (func $withCrown (param $peice i32) (result i32)
    (i32.or (get_local $peice) (get_global $CROWN))
  )

  ;; Removes a crown from a given peice (no mutation)
  (func $withoutCrown (param $peice i32) (result i32)
    (i32.and (get_local $peice) (i32.const 3))
  )

  (export "offsetForPosition" (func $offsetForPosition))
  (export "isCrowned" (func $isCrowned))
  (export "isWhite" (func $isWhite))
  (export "isBlack" (func $isBlack))
  (export "withCrown" (func $withCrown))
  (export "withoutCrown" (func $withoutCrown))
)
