;; title: ZakiCoin (ZAKI)
;; version: 1.0.0
;; summary: ZakiCoin is a SIP-10 compliant fungible token on Stacks blockchain
;; description: A decentralized token with standard SIP-10 functionality including transfer, mint, and burn capabilities

;; traits
;; This contract implements SIP-10 standard functions

;; token definitions
(define-fungible-token zakicoin)

;; constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-insufficient-balance (err u102))
(define-constant err-invalid-amount (err u103))

;; Token metadata
(define-constant token-name "ZakiCoin")
(define-constant token-symbol "ZAKI")
(define-constant token-uri u"https://zakicoin.com/metadata.json")
(define-constant token-decimals u6)
(define-constant initial-supply u1000000000000) ;; 1 million ZAKI tokens (with 6 decimals)

;; data vars
(define-data-var token-total-supply uint initial-supply)
(define-data-var contract-paused bool false)

;; data maps
(define-map approved-contracts principal bool)

;; Initialize contract - mint initial supply to contract owner
(begin
  (try! (ft-mint? zakicoin initial-supply contract-owner))
)

;; public functions

;; SIP-10 Standard Functions

;; Transfer tokens between accounts
(define-public (transfer (amount uint) (from principal) (to principal) (memo (optional (buff 34))))
  (begin
    (asserts! (or (is-eq from tx-sender) (is-eq from contract-caller)) err-not-token-owner)
    (asserts! (> amount u0) err-invalid-amount)
    (asserts! (not (var-get contract-paused)) (err u104))
    (try! (ft-transfer? zakicoin amount from to))
    (match memo to-print (print to-print) 0x)
    (ok true)
  )
)

;; Get token name
(define-read-only (get-name)
  (ok token-name)
)

;; Get token symbol
(define-read-only (get-symbol)
  (ok token-symbol)
)

;; Get token decimals
(define-read-only (get-decimals)
  (ok token-decimals)
)

;; Get token balance of an account
(define-read-only (get-balance (who principal))
  (ok (ft-get-balance zakicoin who))
)

;; Get total token supply
(define-read-only (get-total-supply)
  (ok (ft-get-supply zakicoin))
)

;; Get token URI
(define-read-only (get-token-uri)
  (ok (some token-uri))
)

;; Additional Functions

;; Mint new tokens (only contract owner)
(define-public (mint (amount uint) (to principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> amount u0) err-invalid-amount)
    (asserts! (not (var-get contract-paused)) (err u104))
    (try! (ft-mint? zakicoin amount to))
    (var-set token-total-supply (+ (var-get token-total-supply) amount))
    (ok true)
  )
)

;; Burn tokens from caller's account
(define-public (burn (amount uint))
  (begin
    (asserts! (> amount u0) err-invalid-amount)
    (asserts! (not (var-get contract-paused)) (err u104))
    (asserts! (>= (ft-get-balance zakicoin tx-sender) amount) err-insufficient-balance)
    (try! (ft-burn? zakicoin amount tx-sender))
    (var-set token-total-supply (- (var-get token-total-supply) amount))
    (ok true)
  )
)

;; Pause/unpause contract (only owner)
(define-public (set-contract-paused (paused bool))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (var-set contract-paused paused)
    (ok true)
  )
)

;; Approve contract for automated operations (only owner)
(define-public (set-approved-contract (contract principal) (approved bool))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set approved-contracts contract approved)
    (ok true)
  )
)

;; read only functions

;; Check if contract is paused
(define-read-only (is-paused)
  (var-get contract-paused)
)

;; Check if a contract is approved
(define-read-only (is-approved-contract (contract principal))
  (default-to false (map-get? approved-contracts contract))
)

;; Get contract owner
(define-read-only (get-contract-owner)
  contract-owner
)

;; private functions

;; Validate transfer parameters
(define-private (is-valid-transfer (amount uint) (from principal) (to principal))
  (and
    (> amount u0)
    (not (is-eq from to))
    (>= (ft-get-balance zakicoin from) amount)
  )
)
