# ZakiCoin (ZAKI) 🪙

A SIP-10 compliant fungible token built on the Stacks blockchain using Clarinet.

## Overview

ZakiCoin is a decentralized fungible token that implements the SIP-10 standard, providing secure and efficient token operations on the Stacks blockchain. The token features standard transfer functionality, minting, burning, and administrative controls.

## Token Details

- **Name**: ZakiCoin
- **Symbol**: ZAKI
- **Decimals**: 6
- **Initial Supply**: 1,000,000 ZAKI tokens
- **Standard**: SIP-10 (Stacks Improvement Proposal 10)

## Features

### Core SIP-10 Functions
- ✅ `transfer` - Transfer tokens between accounts
- ✅ `get-name` - Get token name
- ✅ `get-symbol` - Get token symbol
- ✅ `get-decimals` - Get token decimals
- ✅ `get-balance` - Get token balance for an account
- ✅ `get-total-supply` - Get total token supply
- ✅ `get-token-uri` - Get token metadata URI

### Additional Features
- 🔥 **Burn**: Burn tokens from your account
- 💰 **Mint**: Mint new tokens (owner only)
- ⏸️ **Pause/Unpause**: Emergency pause functionality (owner only)
- 🤝 **Contract Approval**: Approve contracts for automated operations
- 🛡️ **Access Control**: Owner-only functions for administrative tasks

## Quick Start

### Prerequisites

- [Clarinet](https://docs.hiro.so/clarinet) installed
- [Node.js](https://nodejs.org/) for testing
- Basic understanding of Clarity smart contracts

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd zakicoin
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Check contract syntax**
   ```bash
   clarinet check
   ```

4. **Run tests**
   ```bash
   npm test
   ```

### Development Commands

```bash
# Check contract syntax
clarinet check

# Run unit tests
npm test

# Start a Clarinet console
clarinet console

# Deploy to testnet (configure settings first)
clarinet integrate

# Generate deployment plans
clarinet deployment generate --devnet
```

## Smart Contract Functions

### Public Functions

#### SIP-10 Standard Functions

**`transfer`**
```clarity
(transfer (amount uint) (from principal) (to principal) (memo (optional (buff 34))))
```
Transfer tokens from one account to another.

**`get-balance`**
```clarity
(get-balance (who principal))
```
Get the token balance of a specific account.

#### Additional Functions

**`mint`** (Owner only)
```clarity
(mint (amount uint) (to principal))
```
Mint new tokens to a specified account.

**`burn`**
```clarity
(burn (amount uint))
```
Burn tokens from the caller's account.

**`set-contract-paused`** (Owner only)
```clarity
(set-contract-paused (paused bool))
```
Pause or unpause the contract.

### Read-Only Functions

- `get-name()` - Returns token name
- `get-symbol()` - Returns token symbol
- `get-decimals()` - Returns token decimals
- `get-total-supply()` - Returns total supply
- `get-token-uri()` - Returns token metadata URI
- `is-paused()` - Returns pause status
- `get-contract-owner()` - Returns contract owner
- `is-approved-contract(principal)` - Check if contract is approved

## Error Codes

| Code | Error | Description |
|------|-------|-------------|
| 100  | `err-owner-only` | Function can only be called by contract owner |
| 101  | `err-not-token-owner` | Caller is not authorized to transfer from account |
| 102  | `err-insufficient-balance` | Account has insufficient balance |
| 103  | `err-invalid-amount` | Amount must be greater than zero |
| 104  | `err-contract-paused` | Contract is currently paused |

## Testing

The project includes comprehensive unit tests written in TypeScript using Clarinet's testing framework.

Run all tests:
```bash
npm test
```

Run tests with coverage:
```bash
npm run test:coverage
```

### Test Coverage
- ✅ Token transfers
- ✅ Minting and burning
- ✅ Balance checks
- ✅ Access control
- ✅ Error conditions
- ✅ Pause functionality

## Deployment

### Testnet Deployment

1. **Configure testnet settings**
   ```bash
   # Edit settings/Testnet.toml
   ```

2. **Generate deployment plan**
   ```bash
   clarinet deployment generate --testnet
   ```

3. **Deploy contract**
   ```bash
   clarinet deployment apply -p deployments/default.testnet-plan.yaml
   ```

### Mainnet Deployment

1. **Configure mainnet settings**
   ```bash
   # Edit settings/Mainnet.toml
   ```

2. **Generate deployment plan**
   ```bash
   clarinet deployment generate --mainnet
   ```

3. **Deploy contract** (use with caution)
   ```bash
   clarinet deployment apply -p deployments/default.mainnet-plan.yaml
   ```

## Security Considerations

- 🔒 **Access Control**: Only contract owner can mint tokens and pause contract
- 🛡️ **Input Validation**: All functions validate input parameters
- ⚠️ **Pause Mechanism**: Emergency pause functionality to halt operations
- 🔍 **SIP-10 Compliance**: Follows standard security practices

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Resources

- [Stacks Documentation](https://docs.stacks.co/)
- [Clarinet Documentation](https://docs.hiro.so/clarinet)
- [SIP-10 Token Standard](https://github.com/stacksgov/sips/blob/main/sips/sip-010/sip-010-fungible-token-standard.md)
- [Clarity Language Reference](https://docs.stacks.co/clarity/)

## Contact

For questions, issues, or contributions, please reach out through:
- GitHub Issues
- [Your Contact Information]

---

**⚠️ Disclaimer**: This is experimental software. Use at your own risk. Always audit smart contracts before deploying to mainnet.