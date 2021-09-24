task("fund-simp", "Gives 10k Simp Tokens to Account")
  .addParam("simpaddress", "The address of simple token contract")
  .addParam("account", "The account's address")
  .setAction(async(args) => {
    signers = await ethers.getSigners();
    Simp = await ethers.getContractFactory('SimpleToken');
    console.log("----------------------------------------------------");
    console.log("!!!IMPORTANT!!!")
    console.log("----------------------------------------------------");
    console.log("Make sure you're runing a localhost network and the Simple Token contract has been deployed.");
    console.log("Make sure you've added `--network localhost` at the end of this command");
    console.log("----------------------------------------------------");
    console.log("Transferring 10k Simple Tokens to "+args.account+" ...")
    simp = await Simp.attach(args.simpaddress);
    await simp.mint(1e4);
    await simp.transfer(args.account,1e4);
    console.log("Transfer Complete!")
    console.log(args.account+" has "+(await simp.balanceOf(args.account)).toString()+" SIMP")
    console.log("----------------------------------------------------");
  })