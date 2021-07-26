const { expect } = require("chai");

// Linear Bancor Bonding Curve
describe("BancorContinuousToken", function () {
  let bct;

  beforeEach(async () => {
    const bctFactory = await ethers.getContractFactory('BancorContinuousToken');
    bct = await bctFactory.deploy('linear','LNR',5e5);
    await bct.deployed();
    await bct.init({value: ethers.utils.parseEther('0.1')});
  })

  it('initialization', async function() {
    expect(await bct.reserveWeight()).to.equal(5e5);
    expect(await bct.totalSupply()).to.equal(1);
    expect(await bct.price()).to.equal(ethers.utils.parseEther('0.2'));
  })

  it('minting 3', async function() {
    expect(await bct.purchaseCost(3)).to.equal(ethers.utils.parseEther('1.5'));
    expect(await bct.purchaseTargetAmount(ethers.utils.parseEther('1.5'))).to.equal(3);
  })

  it('liquidating 3', async function() {
    await bct.functions['mint()']({value: ethers.utils.parseEther('1.5')});
    console.log(await bct.totalSupply());
  })
});
