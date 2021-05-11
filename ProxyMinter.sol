// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IMinter.sol";

contract ProxyMinter is Ownable {

    /* ========== STATE VARIABLES ========== */

    mapping(address => bool) private _minters;
    address public deployer;
    address public minter;

    /* ========== CONSTRUCTOR ========== */

    constructor(address _minter)
        public
    {
        minter = _minter;
    }
    
    /* ========== MODIFIERS ========== */

    modifier onlyMinter {
        require(isMinter(msg.sender) == true, "AddyMinter: caller is not the minter");
        _;
    }

    function mintFor(address user, address asset, uint256 amount) external onlyMinter {
        IMinter(minter).mintFor(user, asset, amount);
    }
    
    /* ========== VIEWS ========== */

    function isMinter(address account) public view returns (bool) {
        return _minters[account];
    }

    function amountAddyToMint(uint256 ethProfit) public view returns (uint256) {
        return IMinter(minter).amountAddyToMint(ethProfit);
    }

    /* ========== RESTRICTED FUNCTIONS ========== */

    function setDeployer(address _deployer) public onlyOwner {
        require(deployer == address(0), "already set");
        deployer = _deployer;
    }
    
    function setMinter(address _minter, bool canMint) external {
        require(deployer == msg.sender, "not deployer");

        if (canMint) {
            _minters[_minter] = canMint;
        } else {
            delete _minters[_minter];
        }
    }
    
    function disableMinter(address _minter) external onlyOwner {
        _minters[_minter] = false;
    }
}
