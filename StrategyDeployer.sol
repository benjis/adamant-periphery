pragma solidity ^0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../strategies/StrategyOtherPair.sol";
import "../jars/GenericVault.sol";
import "../core/ProxyMinter.sol";
import "../interfaces/IStrategy.sol";
import "../interfaces/IMinter.sol";

//Deploys strategies for TokenA/TokenB pairs
//Make sure that a pair for rewardToken/TokenA exists
contract StrategyDeployer is Ownable {

    address public FUND = 0xC9E908D24f13c18A0ab803A4ACF469B37c1761e8;
    address MULTI_HARVEST = 0x3355743Db830Ed30FF4089DB8b18DEeb683F8546;
    address public proxy_minter;

    constructor() public {
        proxy_minter = address(new ProxyMinter(0xAAE758A2dB4204E1334236Acd6E6E73035704921));
        ProxyMinter(proxy_minter).setDeployer(address(this));
        Ownable(proxy_minter).transferOwnership(msg.sender);
    }

    function deploy(address rewards, address lp, address tokenA, address tokenB, string memory _pair_name) public onlyOwner {
        address strategy = address(new StrategyOtherPair(rewards, lp, tokenA, tokenB, FUND, _pair_name));
        address jar = address(new GenericVault(IStrategy(strategy), proxy_minter, FUND));
        StrategyOtherPair(strategy).setJar(jar);
        IMinter(proxy_minter).setMinter(jar, true);
        Ownable(strategy).transferOwnership(MULTI_HARVEST);
        Ownable(jar).transferOwnership(msg.sender);

        emit Deployed(strategy, jar);
    }

    event Deployed(address indexed strategy, address indexed jar);
}