# adamant-periphery
Peripheral contracts for Adamant Finance

## AddyEthPool.sol
The rewards contract for ADDY/ETH LP.

## StrategyDeployer.sol
Convenience contract to deploy and configure new vaults in one transaction.

## ProxyMinter.sol
Convenience contract that allows ``StrategyDeployer`` to automatically give vaults it deploys minting privileges. 
Once the ``StrategyDeployer`` for a ``ProxyMinter`` contract has been set, only the ``StrategyDeployer`` can assign new minters through it.
This guarantees that every address the ``ProxyMinter`` gives minting privileges to is a contract created by ``StrategyDeployer``.
Also allows the owner to disable minter privileges for any contract in the event of an emergency.

## MultiHarvest.sol
Convenience contract to harvest for multiple vaults in a single transaction.

## Timelock.sol
Compound Finance's Timelock contract, which will be used on the main ``Minter`` contract.
