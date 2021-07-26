const { expect } = require("chai");

// Linear Bancor Bonding Curve
describe("BancorContinuousToken", function () {
  let bct;

  beforeEach(async () => {
    const bctFactory = await ethers.getContractFactory('BancorContinuousToken');
    bct = await bctFactory.deploy('linear','LNR', 8, 5e5);
    await bct.deployed();
    await bct.init({value: 1e9});
  })

  it('initialization', async function() {
    expect(await bct.reserveWeight()).to.equal(5e5);
    expect(await bct.totalSupply()).to.equal(1);
    expect(await bct.price()).to.equal(2e9);
  })

  it('minting 3', async function() {
    expect(await bct.purchaseCost(3)).to.equal(15e9);
    expect(await bct.purchaseTargetAmount(15e9)).to.equal(3);
  })

  it('liquidating 3', async function() {
    await bct.functions['mint()']({value: 15e9});
    console.log(await bct.totalSupply());
  })
});
