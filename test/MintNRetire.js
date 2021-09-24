const chai = require('chai');
const { expect } = require('chai');
const { waffle } = require('hardhat');
const { purchaseCost, purchaseTargetAmount, saleTargetAmount } = require('../scripts/bancor.js');

const bigNum2Int=(bn)=>{
  return parseInt(bn.toString())
}

describe("Bancor Continuous Token Mint & Retire Test", async function(){
  let one = ethers.utils.parseEther("1.0");

  let SimpToken, Formula, Bct;
  var simpInstance, formulaInstance, bctInstance;

  let signer, owner;
  const cw = 800000;
  const delta = 1e3;

  beforeEach(async() => {
    [signer, owner] = await ethers.getSigners();    
    SimpToken = await ethers.getContractFactory('SimpleToken');
    Formula = await ethers.getContractFactory('BancorFormula');
    Bct = await (await ethers.getContractFactory('BancorContinuousToken')).connect(owner);
    simpInstance = await SimpToken.deploy();
    formulaInstance = await Formula.deploy();
    await simpInstance.deployed();
    await simpInstance.mint(1e10);
    await formulaInstance.deployed();
    bctInstance = await Bct.deploy(cw, formulaInstance.address, simpInstance.address);
    await bctInstance.deployed();
    await bctInstance["init(string,string)"]('bct-test','btc');
    bctInstance = bctInstance.connect(signer);
  });

  it("Successful Minting of Tokens (implies correct calculations by formula)", async ()=>{
    expect(
      parseInt((await bctInstance.purchaseTargetAmount(2e6)).toString())
    ).to.be.closeTo(
      purchaseTargetAmount(1e18,1e6,8e5,2e6),
      delta
    );
    await simpInstance.approve(bctInstance.address, 2e6);
    await bctInstance.mint(2e6);

    expect(
      parseInt((await bctInstance.reserveBalance()).toString())
    ).to.equal(3e6);

    expect(
      parseInt((await bctInstance.balanceOf(await signer.getAddress())).toString())
    ).to.be.closeTo(
      purchaseTargetAmount(1e18,1e6,8e5,2e6),
      delta
    );
  });

  it("Successful burning of tokens", async ()=>{
    await simpInstance.approve(bctInstance.address, 5e6);
    await bctInstance.mint(5e6);
    var all = bigNum2Int(await bctInstance.balanceOf(signer.address));
    //Correct saleTargetAmount calculation
    var tmp = saleTargetAmount(
      bigNum2Int(await bctInstance.totalSupply()),
      bigNum2Int(await bctInstance.reserveBalance()),
      cw,
      1e18
    );
    //console.log(tmp);
    //console.log(bigNum2Int(await bctInstance.saleTargetAmount(ethers.BigNumber.from(all.toString()))));
    expect(
      bigNum2Int(await bctInstance.saleTargetAmount(one))
      //parseInt((await bctInstance.saleTargetAmount(1e18)).toString())
    ).to.be.closeTo(
      tmp,
      delta
    );
    // Correct retire of tokens
    const balance_0 = bigNum2Int(await simpInstance.balanceOf(signer.address));
    await bctInstance.retire(one);
    expect(
      bigNum2Int(
        await simpInstance.balanceOf(signer.address)
      )
    ).to.be.closeTo(
      balance_0 + tmp,
      delta
    )
  });
});