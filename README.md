# Bonding Curve Contract and Derivatives
## Bonding Curve and Continuous Token Contracts and Derivative Fungible Tokens

# NOTE
* The `BancorFormula` contract cannot be implemented as a library since it uses state variables.
* The `BancorContinuousToken` contract cannot inherit `BancorFormula` as a parent class due to the 25kb contract size restriction.
  Observer how the current implementation just passes the restrictions:
  ```
  $ npx hardhat size-contracts
  ·-------------------------|-------------·
  |  Contract Name          ·  Size (KB)  │
  ··························|··············
  |  BancorContinuousToken  ·     18.562  │
  ··························|··············
  |  BancorFormula          ·     18.073  │
  ··························|··············
  |  ERC20                  ·      5.013  │
  ··························|··············
  |  ERC20Restricted        ·      7.730  │
  ··························|··············
  |  Power                  ·      7.980  │
  ··························|··············
  |  SafeMath               ·      0.086  │
  ··························|··············
  |  SimpleToken            ·      5.566  │
  ··························|··············
  |  TransferHelper         ·      0.086  │
  ·-------------------------|-------------·
  ```
* Gas prices in general are pretty high. Retiring tokens doesn't cost too much, but the price of minting tokens seems unreasonably hight. But then gain, so are most contract transactions on homestead.
  ```
  ·-------------------------------------|----------------------------|-------------|-----------------------------·
  |         Solc version: 0.8.4         ·  Optimizer enabled: false  ·  Runs: 200  ·  Block limit: 12450000 gas  │
  ······································|····························|·············|······························
  |  Methods                            ·               30 gwei/gas                ·       2899.20 usd/eth       │
  ··························|···········|··············|·············|·············|···············|··············
  |  Contract               ·  Method   ·  Min         ·  Max        ·  Avg        ·  # calls      ·  usd (avg)  │
  ··························|···········|··············|·············|·············|···············|··············
  |  BancorContinuousToken  ·  init     ·           -  ·          -  ·    3882306  ·            2  ·     337.67  │
  ··························|···········|··············|·············|·············|···············|··············
  |  BancorContinuousToken  ·  mint     ·      223564  ·     223832  ·     223698  ·            2  ·      19.46  │
  ··························|···········|··············|·············|·············|···············|··············
  |  BancorContinuousToken  ·  retire   ·           -  ·          -  ·     107346  ·            1  ·       9.34  │
  ··························|···········|··············|·············|·············|···············|··············
  |  SimpleToken            ·  approve  ·           -  ·          -  ·      46845  ·            2  ·       4.07  │
  ··························|···········|··············|·············|·············|···············|··············
  |  SimpleToken            ·  mint     ·           -  ·          -  ·      68530  ·            2  ·       5.96  │
  ··························|···········|··············|·············|·············|···············|··············
  |  Deployments                        ·                                          ·  % of limit   ·             │
  ······································|··············|·············|·············|···············|··············
  |  BancorContinuousToken              ·           -  ·          -  ·    4087097  ·       32.8 %  ·     355.48  │
  ······································|··············|·············|·············|···············|··············
  |  BancorFormula                      ·           -  ·          -  ·    3866479  ·       31.1 %  ·     336.29  │
  ······································|··············|·············|·············|···············|··············
  |  SimpleToken                        ·           -  ·          -  ·    1300292  ·       10.4 %  ·     113.09  │
  ·-------------------------------------|--------------|-------------|-------------|---------------|-------------·
  ```


## TODO
- [ ] Fuctions for migration. Tbf, these contracts aren't for production &ndash; merely proof-of-concepts that I don't intend to deploy to any public network &ndash; so adding migration functionality isn't necessary.