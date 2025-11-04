;; ZakiBit (ZBIT) - SIP-010-like fungible token

(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-INSUFFICIENT-BALANCE u101)
(define-constant ERR-AMOUNT-ZERO u102)

(define-constant TOKEN-NAME "ZakiBit")
(define-constant TOKEN-SYMBOL "ZBIT")
(define-constant TOKEN-DECIMALS u8)

;; Devnet deployer (from settings/Devnet.toml)
(define-constant OWNER 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)

(define-data-var total-supply uint u0)
(define-map balances { account: principal } { amount: uint })

;; Read-only helpers
(define-read-only (get-name)
  (ok TOKEN-NAME))

(define-read-only (get-symbol)
  (ok TOKEN-SYMBOL))

(define-read-only (get-decimals)
  (ok TOKEN-DECIMALS))

(define-read-only (get-total-supply)
  (ok (var-get total-supply)))

(define-read-only (get-balance (who principal))
  (ok (default-to u0 (get amount (map-get? balances { account: who })))))

(define-read-only (get-token-uri)
  (ok none))

;; Internal helpers
(define-private (debit (owner principal) (amount uint))
  (let ((bal (default-to u0 (get amount (map-get? balances { account: owner })))))
    (if (>= bal amount)
        (begin
          (map-set balances { account: owner } { amount: (- bal amount) })
          (ok true))
        (err ERR-INSUFFICIENT-BALANCE))))

(define-private (credit (owner principal) (amount uint))
  (let ((bal (default-to u0 (get amount (map-get? balances { account: owner })))))
    (begin
      (map-set balances { account: owner } { amount: (+ bal amount) })
      (ok true))))

;; SIP-010-compatible transfer
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (try! (if (> amount u0) (ok true) (err ERR-AMOUNT-ZERO)))
    (try! (if (is-eq tx-sender sender) (ok true) (err ERR-NOT-AUTHORIZED)))
    (try! (debit sender amount))
    (unwrap-panic (credit recipient amount))
    (ok true)))


;; Owner-only mint
(define-public (mint (recipient principal) (amount uint))
  (begin
    (try! (if (> amount u0) (ok true) (err ERR-AMOUNT-ZERO)))
    (try! (if (is-eq tx-sender OWNER) (ok true) (err ERR-NOT-AUTHORIZED)))
    (var-set total-supply (+ (var-get total-supply) amount))
    (unwrap-panic (credit recipient amount))
    (ok true)))

;; Holder burn
(define-public (burn (amount uint) (memo (optional (buff 34))))
  (begin
    (try! (if (> amount u0) (ok true) (err ERR-AMOUNT-ZERO)))
    (try! (debit tx-sender amount))
    (var-set total-supply (- (var-get total-supply) amount))
    (ok true)))
