// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title ShehryarAhmedSupplyChain
 * @notice Supply chain tracking contract for manufacturer -> distributor -> retailer -> customer.
 * @dev Designed for Polygon / Hardhat assignments.
 */
contract ShehryarAhmedSupplyChain is AccessControl {
    bytes32 public constant MANUFACTURER_ROLE = keccak256("MANUFACTURER_ROLE");
    bytes32 public constant DISTRIBUTOR_ROLE   = keccak256("DISTRIBUTOR_ROLE");
    bytes32 public constant RETAILER_ROLE      = keccak256("RETAILER_ROLE");
    bytes32 public constant CUSTOMER_ROLE      = keccak256("CUSTOMER_ROLE");

    enum ProductStatus {
        Manufactured,
        InTransit,
        Delivered
    }

    struct Product {
        uint256 id;
        string name;
        string description;
        address currentOwner;
        ProductStatus status;
        bool exists;
    }

    struct HistoryEntry {
        address actor;
        address from;
        address to;
        ProductStatus status;
        string action;
        uint256 timestamp;
    }

    uint256 private _nextProductId = 1;

    mapping(uint256 => Product) private _products;
    mapping(uint256 => HistoryEntry[]) private _history;
    uint256[] private _allProductIds;

    event ProductRegistered(
        uint256 indexed productId,
        string name,
        address indexed manufacturer
    );

    event ProductTransferred(
        uint256 indexed productId,
        address indexed from,
        address indexed to,
        ProductStatus status
    );

    event RoleAssigned(address indexed account, bytes32 indexed role);

    constructor(address admin) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);

        // Convenience roles for the demo. The admin can reassign later.
        _grantRole(MANUFACTURER_ROLE, admin);
        _grantRole(DISTRIBUTOR_ROLE, admin);
        _grantRole(RETAILER_ROLE, admin);
        _grantRole(CUSTOMER_ROLE, admin);
    }

    modifier productExists(uint256 productId) {
        require(_products[productId].exists, "Product does not exist");
        _;
    }

    function assignRole(address account, bytes32 role) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(
            role == MANUFACTURER_ROLE ||
            role == DISTRIBUTOR_ROLE ||
            role == RETAILER_ROLE ||
            role == CUSTOMER_ROLE,
            "Unsupported role"
        );
        grantRole(role, account);
        emit RoleAssigned(account, role);
    }

    function revokeAssignedRole(address account, bytes32 role) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(
            role == MANUFACTURER_ROLE ||
            role == DISTRIBUTOR_ROLE ||
            role == RETAILER_ROLE ||
            role == CUSTOMER_ROLE,
            "Unsupported role"
        );
        revokeRole(role, account);
    }

    function registerProduct(
        string calldata name,
        string calldata description
    ) external onlyRole(MANUFACTURER_ROLE) returns (uint256) {
        uint256 productId = _nextProductId++;

        _products[productId] = Product({
            id: productId,
            name: name,
            description: description,
            currentOwner: msg.sender,
            status: ProductStatus.Manufactured,
            exists: true
        });

        _allProductIds.push(productId);

        _history[productId].push(
            HistoryEntry({
                actor: msg.sender,
                from: address(0),
                to: msg.sender,
                status: ProductStatus.Manufactured,
                action: "Product manufactured and registered",
                timestamp: block.timestamp
            })
        );

        emit ProductRegistered(productId, name, msg.sender);
        return productId;
    }

    function transferToDistributor(uint256 productId, address distributor)
        external
        productExists(productId)
    {
        Product storage product = _products[productId];
        require(product.currentOwner == msg.sender, "Only current owner can transfer");
        require(hasRole(DISTRIBUTOR_ROLE, distributor), "Recipient is not a distributor");
        require(hasRole(MANUFACTURER_ROLE, msg.sender), "Sender is not a manufacturer");
        _transfer(productId, distributor, ProductStatus.InTransit, "Transferred to distributor");
    }

    function transferToRetailer(uint256 productId, address retailer)
        external
        productExists(productId)
    {
        Product storage product = _products[productId];
        require(product.currentOwner == msg.sender, "Only current owner can transfer");
        require(hasRole(RETAILER_ROLE, retailer), "Recipient is not a retailer");
        require(hasRole(DISTRIBUTOR_ROLE, msg.sender), "Sender is not a distributor");
        _transfer(productId, retailer, ProductStatus.InTransit, "Transferred to retailer");
    }

    function transferToCustomer(uint256 productId, address customer)
        external
        productExists(productId)
    {
        Product storage product = _products[productId];
        require(product.currentOwner == msg.sender, "Only current owner can transfer");
        require(hasRole(CUSTOMER_ROLE, customer), "Recipient is not a customer");
        require(hasRole(RETAILER_ROLE, msg.sender), "Sender is not a retailer");
        _transfer(productId, customer, ProductStatus.Delivered, "Delivered to customer");
    }

    function _transfer(
        uint256 productId,
        address newOwner,
        ProductStatus newStatus,
        string memory action
    ) internal {
        Product storage product = _products[productId];
        address from = product.currentOwner;

        product.currentOwner = newOwner;
        product.status = newStatus;

        _history[productId].push(
            HistoryEntry({
                actor: msg.sender,
                from: from,
                to: newOwner,
                status: newStatus,
                action: action,
                timestamp: block.timestamp
            })
        );

        emit ProductTransferred(productId, from, newOwner, newStatus);
    }

    function getProduct(uint256 productId)
        external
        view
        productExists(productId)
        returns (
            uint256 id,
            string memory name,
            string memory description,
            address currentOwner,
            ProductStatus status
        )
    {
        Product storage product = _products[productId];
        return (
            product.id,
            product.name,
            product.description,
            product.currentOwner,
            product.status
        );
    }

    function getAllProductIds() external view returns (uint256[] memory) {
        return _allProductIds;
    }

    function getHistoryLength(uint256 productId)
        external
        view
        productExists(productId)
        returns (uint256)
    {
        return _history[productId].length;
    }

    function getHistoryEntry(uint256 productId, uint256 index)
        external
        view
        productExists(productId)
        returns (
            address actor,
            address from,
            address to,
            ProductStatus status,
            string memory action,
            uint256 timestamp
        )
    {
        require(index < _history[productId].length, "History index out of bounds");
        HistoryEntry storage entry = _history[productId][index];
        return (
            entry.actor,
            entry.from,
            entry.to,
            entry.status,
            entry.action,
            entry.timestamp
        );
    }

    function productCount() external view returns (uint256) {
        return _allProductIds.length;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
