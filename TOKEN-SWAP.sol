// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract TokenSwap {
    using SafeERC20 for IERC20;

    address public token1Address;
    address public token2Address;
    address public owner;


    event Swap(address indexed sender, uint256 amountToken1, uint256 amountToken2);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor(address _token1Address, address _token2Address) {
        token1Address = _token1Address;
        token2Address = _token2Address;
        owner = msg.sender;
    }
    
    function swapTokens(uint256 _amountToken1, uint256 _amountToken2) external onlyOwner {
        require(_amountToken1 > 0 && _amountToken2 > 0, "Invalid token amounts");

        IERC20(token1Address).safeTransferFrom(msg.sender, address(this), _amountToken1);
        IERC20(token2Address).safeTransferFrom(msg.sender, address(this), _amountToken2);
        IERC20(token1Address).safeTransferFrom(msg.sender, address(this), _amountToken2);
        IERC20(token2Address).safeTransferFrom(msg.sender, address(this), _amountToken1);

        emit Swap(msg.sender, _amountToken1, _amountToken2);
      }
    }