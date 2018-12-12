(module
  (memory $mem 1)

  ;; Global variables
  (global $BLACK i32 (i32.const 1))
  (global $WHITE i32 (i32.const 2))
  (global $CROWN i32 (i32.const 4))
  (global $currentTurn (mut i32) (i32.const 0))

  (func $indexForPosition (param $x i32) (param $y i32) (result i32)
    (i32.add
      (i32.mul
        (i32.const 8)
        (get_local $y)
      )
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

  ;; Sets a piece on the board
  (func $setPiece (param $x i32) (param $y i32) (param $piece i32)
    (i32.store
      (call $offsetForPosition
        (get_local $x)
        (get_local $y)
      )
      (get_local $piece)
    )
  )

  ;; Gets a piece from the board. Out of range causes a trap
  (func $getPiece (param $x i32) (param $y i32) (result i32)
    (if (result i32)
      (block (result i32)
        (i32.and
          (call $inRange
            (i32.const 0)
            (i32.const 7)
            (get_local $x)
          )
          (call $inRange
            (i32.const 0)
            (i32.const 7)
            (get_local $y)
          )
        )
      )
      (then
        (i32.load
          (call $offsetForPosition
            (get_local $x)
            (get_local $y)
          )
        )
      )
      (else
        (unreachable)
      )
    )
  )

  ;; Determine if a space is occupied without regard for who occupies it
  (func $isOccupied (param $x i32) (param $y i32) (result i32)
    (i32.gt_s
      call $getPiece (get_local $x) (get_local $y)
      (i32.const 0)
    )
  )

  ;; Detect if vaules are within range (inclusive high and low)
  (func $inRange (param $low i32) (param $high i32) (param $value i32) (result i32)
    (i32.and
      (i32.ge_s (get_local $value) (get_local $low))
      (i32.le_s (get_local $value) (get_local $high))
    )
  )

  ;; Gets the current turn owner (white or black)
  (func $getTurnOwner (result i32)
    (get_global %currentTurn)
  )

  ;; At the end of a turn, switch turn owner to other player
  (func $toggleTurnOwner
    (if (i32.eq (call $getTurnOwner) (i32.const 1))
      (then (call $setTurnOwner (i32.const 2)))
      (else (call $setTurnOwner (i32.const 1)))
    )
  )

  ;; Sets the turn owner
  (func $setTurnOwner (param $piece i32)
    (set_global $currentTurn (get_global $piece))
  )

  ;; Determine if its a players turn
  (func $isPlayersTurn (param $player i32) (result i32)
    (i32.gt_s
      (i32.and (get_local $player i32) (result i32))
      (i32.const 0)
    )
  )
)
