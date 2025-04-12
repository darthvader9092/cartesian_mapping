# Decentralized Energy Mapping in Circular Smart Grids using Cartesian Distance

This project presents a blockchain-based system for mapping energy transactions between producers, consumers, and prosumers in a circular smart grid. Users are matched using a 3D Cartesian distance formula that considers their energy balance, pricing, and grid position (represented in radians). The entire logic is implemented as a Solidity smart contract deployed on the Ethereum Virtual Machine (via Remix IDE), with synthetic data hardcoded into the contract for simulation purposes.

## 🧠 Core Idea

- **User Types**: Producers (positive energy balance), Consumers (negative energy balance), and Prosumers (both).
- **Mapping Logic**: Cartesian distance calculated using three parameters:
  - Energy classification (scale 1–5)
  - Grid position in radians (circular layout)
  - Price (cost or desired sale price)
- **Trigger**: Mapping is executed when the contract owner calls `commitMapping()`.

## 📊 Features

- Fully decentralized smart contract with hardcoded user data.
- Owner-controlled execution to maintain security and prevent misuse.
- Automatic matching based on 3D distance logic.
- Energy balances are updated automatically post-mapping.
- Clear mapping results showing which users are connected.

## 📁 Project Structure

- `SolidityContract.sol`: Contains the complete smart contract with data, logic, and mapping.
- `mapping_data.csv`: Synthetic user data (producers, consumers, prosumers).
- `architecture.png`: System architecture flowchart.
- `grid_diagram.png`: Circular grid with sample user positions.
- `classification_scale.png`: 1–5 scale classification visual.

## 🧪 Testing

Deploy the contract in [Remix IDE](https://remix.ethereum.org/), switch to the appropriate environment (e.g., JavaScript VM), and use the `commitMapping()` function to simulate the mapping process. The results will show user-to-user mapping and updated energy balances.

## 🔮 Future Scope

This project lays the foundation for integrating **real-time data preprocessing**, **dynamic mapping**, and deploying to **live circular grid infrastructures**. Future work could focus on integrating sensor data, smart meters, and edge computing for autonomous grid-level optimization.

## 📜 License

This project is open-source and available under the MIT License.

## 🤝 Acknowledgments

Developed as part of an academic research initiative exploring blockchain applications in energy systems.
