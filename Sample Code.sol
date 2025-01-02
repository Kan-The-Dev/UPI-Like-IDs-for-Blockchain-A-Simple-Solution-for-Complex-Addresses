// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockchainUPI {
    // Struct to store wallet addresses for different blockchains
    struct Wallets {
        address ethereumWallet;
        address bitcoinWallet;
        address bnbWallet;
    }

    // Mapping from UPI IDs to their associated wallets
    mapping(string => Wallets) private upiToWallets;

    // Event to notify when a UPI ID is registered
    event UPIRegistered(string upiId, Wallets wallets);

    /**
     * @dev Registers a UPI ID with associated blockchain wallets.
     * @param upiId The UPI ID to register (must be unique and >= 6 characters).
     * @param ethereumWallet The Ethereum wallet address.
     * @param bitcoinWallet The Bitcoin wallet address.
     * @param bnbWallet The BNB wallet address.
     */
    function registerUPI(
        string calldata upiId,
        address ethereumWallet,
        address bitcoinWallet,
        address bnbWallet
    ) external {
        require(bytes(upiId).length >= 6, "UPI ID must be at least 6 characters.");
        require(upiToWallets[upiId].ethereumWallet == address(0), "UPI ID already registered.");

        Wallets memory wallets = Wallets({
            ethereumWallet: ethereumWallet,
            bitcoinWallet: bitcoinWallet,
            bnbWallet: bnbWallet
        });

        upiToWallets[upiId] = wallets;
        emit UPIRegistered(upiId, wallets);
    }

    /**
     * @dev Resolves a UPI ID to the associated wallet address for a specific blockchain.
     * @param upiId The UPI ID to resolve.
     * @param blockchain The blockchain identifier (e.g., "eth", "btc", "bnb").
     * @return The resolved wallet address.
     */
    function getAddress(string calldata upiId, string calldata blockchain) external view returns (address) {
        Wallets memory wallets = upiToWallets[upiId];

        if (keccak256(abi.encodePacked(blockchain)) == keccak256(abi.encodePacked("eth"))) {
            return wallets.ethereumWallet;
        } else if (keccak256(abi.encodePacked(blockchain)) == keccak256(abi.encodePacked("btc"))) {
            return wallets.bitcoinWallet;
        } else if (keccak256(abi.encodePacked(blockchain)) == keccak256(abi.encodePacked("bnb"))) {
            return wallets.bnbWallet;
        } else {
            revert("Unsupported blockchain.");
        }
    }

    /**
     * @dev Generates the full UPI ID for a given blockchain.
     * @param upiId The UPI ID.
     * @param blockchain The blockchain identifier (e.g., "eth", "btc", "bnb").
     * @return The full UPI ID with the blockchain suffix.
     */
    function getFullUPI(string calldata upiId, string calldata blockchain) external pure returns (string memory) {
        return string(abi.encodePacked(upiId, "@", blockchain));
    }
}
