task('fund-eth', 'Gives localhost 10 ETH to account')
  .addParam('account', "The account's address")
  //.addOptionalParam("amount", "The amount of eth")
  .setAction(async(args) => {
    const ten = ethers.utils.parseEther("10.0");
    signers = await ethers.getSigners();
    console.log("----------------------------------------------------");
    console.log("Make sure the localhost network is running, and your wallet is connected to a network rpc. Otherwise, the transferred ETH won't be visible.")
    console.log("Make sure you've added `--network localhost` at the end of this command");
    console.log("----------------------------------------------------");
    console.log("Adding 10 ETH to "+args.account+" ...");
    const tx = await signers[9].sendTransaction({
      to: args.account,
      value: ten
    });
    console.log("10 ETH sent. Check your wallet to verify.")
    console.log("----------------------------------------------------");
  });

module.exports = {};