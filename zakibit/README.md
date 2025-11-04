# ZakiBit (ZBIT)

A SIP-010-compatible fungible token implemented in Clarity and managed with Clarinet.

- Name: ZakiBit
- Symbol: ZBIT
- Decimals: 8

## Project layout

```
zakibit/
├── Clarinet.toml
└── contracts/
    └── zakibit.clar
```

## Prerequisites

- Linux/macOS
- curl or npm (to install Clarinet)

## Install Clarinet

Pick one method:

- Using npm (recommended if you already have Node.js):
  ```bash
  npm install -g @hirosystems/clarinet
  ```

- Download the Linux binary directly:
  ```bash
  curl -L https://github.com/hirosystems/clarinet/releases/latest/download/clarinet-linux-x64-glibc -o clarinet
  chmod +x ./clarinet
  sudo mv ./clarinet /usr/local/bin/clarinet
  clarinet --version
  ```

## Verify the contract

From this directory:

```bash
clarinet check
```

You should see type checking succeed.

## Run a local REPL and try it out

Start the console:

```bash
clarinet console
```

Example interactions (replace `wallet_1`, `wallet_2` with console variables):

```clarity
;; Mint 1_000_000 ZBIT (10^6) to wallet_1 (only contract owner can mint)
(contract-call? .zakibit mint wallet_1 u1000000)

;; Check balances
(contract-call? .zakibit get-balance wallet_1)

;; Transfer 250_000 ZBIT from wallet_1 to wallet_2
(contract-call? .zakibit transfer u250000 wallet_1 wallet_2 none)

;; Burn 10_000 ZBIT from wallet_2
(contract-call? .zakibit burn u10000 none)
```

## Contract API

- `(get-name)` -> `(response (string-utf8 32) uint)`
- `(get-symbol)` -> `(response (string-utf8 10) uint)`
- `(get-decimals)` -> `(response uint uint)`
- `(get-total-supply)` -> `(response uint uint)`
- `(get-balance who)` -> `(response uint uint)`
- `(transfer amount sender recipient memo)` -> `(response bool uint)`
- `(mint recipient amount)` -> `(response bool uint)` owner-only
- `(burn amount memo)` -> `(response bool uint)`

Error codes:

- `u100` not authorized
- `u101` insufficient balance
- `u102` amount zero

## Development tips

- If you edit `contracts/zakibit.clar`, run `clarinet check` frequently.
- Use `clarinet console` for quick local testing.
