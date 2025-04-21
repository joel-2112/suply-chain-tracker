// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SupplyChain is Ownable {
    struct Product {
        uint id;
        string name;
        address owner;
        bool isTransferred;
        uint timestamp;
    }

    mapping(uint => Product) public products;
    uint public productCount;

    event ProductCreated(uint id, string name, address owner, uint timestamp);
    event ProductTransferred(uint id, address newOwner, uint timestamp);

    function createProduct(string memory _name) public {
        productCount++;
        products[productCount] = Product(
            productCount,
            _name,
            msg.sender,
            false,
            block.timestamp
        );
        emit ProductCreated(productCount, _name, msg.sender, block.timestamp);
    }

    function transferProduct(uint _id, address _newOwner) public {
        require(_id > 0 && _id <= productCount, "Invalid product ID");
        require(products[_id].owner == msg.sender, "Not the owner");
        require(!products[_id].isTransferred, "Product already transferred");
        products[_id].owner = _newOwner;
        products[_id].isTransferred = true;
        products[_id].timestamp = block.timestamp;
        emit ProductTransferred(_id, _newOwner, block.timestamp);
    }
}