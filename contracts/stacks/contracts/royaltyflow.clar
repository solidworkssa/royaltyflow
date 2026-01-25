;; RoyaltyFlow - Creator royalty distribution

(define-data-var split-counter uint u0)

(define-map splits uint {
    creator: principal,
    recipient1: principal,
    recipient2: principal,
    percentage1: uint,
    percentage2: uint,
    total-received: uint,
    active: bool
})

(define-constant ERR-INVALID (err u100))

(define-public (create-split (r1 principal) (r2 principal) (p1 uint) (p2 uint))
    (let ((split-id (var-get split-counter)))
        (asserts! (is-eq (+ p1 p2) u10000) ERR-INVALID)
        (map-set splits split-id {
            creator: tx-sender,
            recipient1: r1,
            recipient2: r2,
            percentage1: p1,
            percentage2: p2,
            total-received: u0,
            active: true
        })
        (var-set split-counter (+ split-id u1))
        (ok split-id)))

(define-public (distribute-payment (split-id uint) (amount uint))
    (let (
        (split (unwrap! (map-get? splits split-id) ERR-INVALID))
        (amount1 (/ (* amount (get percentage1 split)) u10000))
        (amount2 (/ (* amount (get percentage2 split)) u10000)))
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (try! (as-contract (stx-transfer? amount1 tx-sender (get recipient1 split))))
        (try! (as-contract (stx-transfer? amount2 tx-sender (get recipient2 split))))
        (ok true)))

(define-read-only (get-split (split-id uint))
    (ok (map-get? splits split-id)))
