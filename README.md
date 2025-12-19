# 🧑‍🤝‍🧑 Crowd Sourcing (Decentralized Crowdfunding)

A **decentralized crowd sourcing (crowdfunding) smart contract** built using **Solidity** and **Foundry**. This project allows users to contribute ETH while enforcing a **minimum USD value** using **Chainlink price feeds**, and enables the owner to securely withdraw the funds.

This repository is designed as a **portfolio-grade project** demonstrating real-world smart contract architecture, testing, and best practices — suitable for **remote global Web3 roles**.

---

## 🚀 Features

* 💰 Users can fund the contract with ETH
* 💵 Minimum contribution enforced in USD (ETH → USD conversion)
* 🔗 Uses Chainlink ETH/USD price feeds
* 🔐 Only owner can withdraw funds
* 💵 Gas-optimized withdrawal function
* 🧠 Chain-agnostic design (Local, Sepolia, Arbitrum)
* 🧪 Comprehensive testing with Foundry
* 🧰 Mock price feeds for local testing

---

## 🏗 Project Structure

```
contracts/
├── FundMe.sol              # Main crowd sourcing contract
├── PriceConverter.sol      # Library for ETH → USD conversion
├── HelperConfig.sol        # Network-specific configuration
├── mocks/
│   └── MockV3Aggregator.sol

script/
├── DeployFundMe.s.sol      # Deployment script

test/
├── FundMeTest.t.sol        # Unit & fork tests
```

---

## 🧠 Architecture Overview

### Funding Flow

1. A user sends ETH to the `fund()` function
2. ETH value is converted to USD using Chainlink price feed
3. Transaction succeeds only if it meets the minimum USD threshold
4. Funders are recorded on-chain

### Withdrawal Flow

1. Only the contract owner can call `withdraw()`
2. Funders’ balances are reset
3. All ETH is transferred to the owner

---

## 🔗 Chainlink Integration

* Uses `AggregatorV3Interface` for ETH/USD pricing
* Price feed address is **injected via constructor** (no hardcoded addresses)
* Supported networks:

  * 🧪 Local Anvil (with mock aggregator)
  * 🧭 Sepolia Testnet
  * 🌐 Arbitrum One

---

## 🧪 Testing

This project uses **Foundry** for fast and reliable testing.

### Test Coverage Includes

* ✅ Constructor initialization
* ✅ Minimum funding enforcement
* ✅ Funding and withdrawal logic
* ✅ Access control (owner-only withdraw)
* ✅ Mock-based local tests
* ✅ Fork tests on real networks

### Run Tests

```bash
forge test
```

### Run Fork Tests (example: Arbitrum)

```bash
forge test --fork-url $ARB_RPC
```

---

## 🔐 Security Considerations

* Uses **Checks-Effects-Interactions** pattern
* Prevents unauthorized withdrawals
* Avoids hardcoded external addresses
* Designed to be easily auditable

---

## 🛠 Tech Stack

* **Solidity ^0.8.x**
* **Foundry (Forge, Anvil)**
* **Chainlink Price Feeds**

---

## 📌 Future Improvements

* Support for multiple tokens
* Frontend integration
* Upgradeable contract version

---

## 👤 Author

Built by **Bhavya** **Jain** as part of a focused journey toward becoming a **remote smart contract / protocol engineer**.

---

## 📄 License

MIT License
