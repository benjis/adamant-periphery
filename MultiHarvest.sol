pragma solidity ^0.6.7;

import "../interfaces/IStrategy.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//Harvests for multiple contracts at once in order to reduce the number of RPC calls made
contract MultiHarvest is Ownable {

    event Failure(address indexed vault);
    
    function harvestStrategies(address[] memory strategies) public onlyOwner {
        uint256 length = strategies.length;

        for (uint256 i = 0; i < length; i++) {
            try IStrategy(strategies[i]).harvest() {
                
            } 
            catch {
                emit Failure(strategies[i]);
            }
        }
    }

    //No user tokens should be in this contract
    function salvage(address _recipient, address _token, uint256 _amount) public onlyOwner {
        IERC20(_token).transfer(_recipient, _amount);
    }

    //Return ownership of the strategy contract to me
    function restoreOwnership(address strategy) public onlyOwner {
        Ownable(strategy).transferOwnership(owner());
    }
}