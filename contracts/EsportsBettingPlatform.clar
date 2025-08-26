;; Esports Betting Platform
;; A decentralized betting platform specifically designed for esports tournaments and matches
;; Supports betting on match outcomes with automated payout system

;; Define the main data structures
(define-map matches 
  uint 
  {
    team-a: (string-ascii 50),
    team-b: (string-ascii 50),
    tournament: (string-ascii 100),
    match-status: (string-ascii 20), ;; "open", "closed", "completed"
    winning-team: uint, ;; 0 = not decided, 1 = team-a, 2 = team-b
    total-pool: uint,
    team-a-pool: uint,
    team-b-pool: uint,
    created-at: uint
  }
)

(define-map user-bets
  {user: principal, match-id: uint}
  {
    amount: uint,
    team-choice: uint, ;; 1 = team-a, 2 = team-b
    claimed: bool
  }
)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-match (err u101))
(define-constant err-match-closed (err u102))
(define-constant err-invalid-team (err u103))
(define-constant err-insufficient-funds (err u104))
(define-constant err-already-bet (err u105))
(define-constant err-match-not-completed (err u106))
(define-constant err-no-bet-found (err u107))
(define-constant err-already-claimed (err u108))
(define-constant err-losing-bet (err u109))
(define-constant err-invalid-amount (err u110))

;; Data variables
(define-data-var next-match-id uint u1)
(define-data-var platform-fee-percentage uint u5) ;; 5% platform fee

;; Function 1: Place Bet
;; Allows users to place bets on esports matches
(define-public (place-bet (match-id uint) (team-choice uint))
  (let (
    (match-info (unwrap! (map-get? matches match-id) err-invalid-match))
    (bet-amount (stx-get-balance tx-sender))
    (existing-bet (map-get? user-bets {user: tx-sender, match-id: match-id}))
  )
  (begin
    ;; Validate inputs
    (asserts! (is-eq (get match-status match-info) "open") err-match-closed)
    (asserts! (or (is-eq team-choice u1) (is-eq team-choice u2)) err-invalid-team)
    (asserts! (> bet-amount u0) err-invalid-amount)
    (asserts! (is-none existing-bet) err-already-bet)
    
    ;; Transfer STX to contract
    (try! (stx-transfer? bet-amount tx-sender (as-contract tx-sender)))
    
    ;; Update match pools
    (let (
      (updated-match (merge match-info 
        {
          total-pool: (+ (get total-pool match-info) bet-amount),
          team-a-pool: (if (is-eq team-choice u1) 
                          (+ (get team-a-pool match-info) bet-amount)
                          (get team-a-pool match-info)),
          team-b-pool: (if (is-eq team-choice u2) 
                          (+ (get team-b-pool match-info) bet-amount)
                          (get team-b-pool match-info))
        }))
    )
    (begin
      ;; Update match data
      (map-set matches match-id updated-match)
      
      ;; Record user bet
      (map-set user-bets 
        {user: tx-sender, match-id: match-id}
        {
          amount: bet-amount,
          team-choice: team-choice,
          claimed: false
        })
      
      (ok {
        match-id: match-id,
        amount: bet-amount,
        team: team-choice,
        message: "Bet placed successfully"
      })
    ))
  )))

;; Function 2: Claim Winnings
;; Allows users to claim their winnings after match completion
(define-public (claim-winnings (match-id uint))
  (let (
    (match-info (unwrap! (map-get? matches match-id) err-invalid-match))
    (user-bet (unwrap! (map-get? user-bets {user: tx-sender, match-id: match-id}) err-no-bet-found))
    (winning-team (get winning-team match-info))
    (user-team-choice (get team-choice user-bet))
    (bet-amount (get amount user-bet))
  )
  (begin
    ;; Validate claim conditions
    (asserts! (is-eq (get match-status match-info) "completed") err-match-not-completed)
    (asserts! (not (get claimed user-bet)) err-already-claimed)
    (asserts! (is-eq user-team-choice winning-team) err-losing-bet)
    
    ;; Calculate winnings
    (let (
      (total-pool (get total-pool match-info))
      (winning-pool (if (is-eq winning-team u1) 
                       (get team-a-pool match-info) 
                       (get team-b-pool match-info)))
      (platform-fee (/ (* total-pool (var-get platform-fee-percentage)) u100))
      (distributable-amount (- total-pool platform-fee))
      (user-share (/ (* bet-amount distributable-amount) winning-pool))
    )
    (begin
      ;; Mark bet as claimed
      (map-set user-bets 
        {user: tx-sender, match-id: match-id}
        (merge user-bet {claimed: true}))
      
      ;; Transfer winnings to user
      (try! (as-contract (stx-transfer? user-share tx-sender tx-sender)))
      
      (ok {
        match-id: match-id,
        winnings: user-share,
        original-bet: bet-amount,
        message: "Winnings claimed successfully"
      })
    ))
  )))

;; Read-only functions for frontend integration
(define-read-only (get-match-info (match-id uint))
  (map-get? matches match-id))

(define-read-only (get-user-bet (user principal) (match-id uint))
  (map-get? user-bets {user: user, match-id: match-id}))

(define-read-only (get-contract-balance)
  (stx-get-balance (as-contract tx-sender)))

;; Owner-only function to create matches (for demo purposes)
(define-public (create-match (team-a (string-ascii 50)) (team-b (string-ascii 50)) (tournament (string-ascii 100)))
  (let ((match-id (var-get next-match-id)))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set matches match-id {
      team-a: team-a,
      team-b: team-b,
      tournament: tournament,
      match-status: "open",
      winning-team: u0,
      total-pool: u0,
      team-a-pool: u0,
      team-b-pool: u0,
      created-at: stacks-block-height
    })
    (var-set next-match-id (+ match-id u1))
    (ok match-id)
  )))

;; Owner-only function to complete matches
(define-public (complete-match (match-id uint) (winning-team-id uint))
  (let ((match-info (unwrap! (map-get? matches match-id) err-invalid-match)))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (or (is-eq winning-team-id u1) (is-eq winning-team-id u2)) err-invalid-team)
    (map-set matches match-id 
      (merge match-info {
        match-status: "completed",
        winning-team: winning-team-id
      }))
    (ok true)
  )))