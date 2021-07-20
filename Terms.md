1. OFT: Ownable Fungible Token (As the name suggests)
2. BC: Bonding Curve
3. RBBC: Revenue Based Bonding Curve (Mint_price raised)
4. C-Org: Continuous Organizations, are those whose revenue model is based on Revenue-Based Bonding Curve; i.e. they deploy a RB continuous token.
   

* The terminology and definitions were chosen to maximize inheritance.

* Continuous Token is a fungible token that has four qualities.

* Bonding Curve as the algorithm that determines the price of a continuous token.

* Bancor Bonding Curve is based on the Bancor Formula
  R = F * P * S

* Bonding Curve with non-zero initial price and supply is a piece-wise function where p(s) when s is smaller than or equal to s_0 is constant.

* A Bonding Curve with a fixed CW and zero initial supply and price is a monomial.