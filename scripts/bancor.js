// Bancor Formula Written in JS
module.exports = {
  purchaseCost: function(
    supply,
    reserveBalance,
    reserveWeight,
    amount
  ){
    base = 1 + amount/supply
    power = 1000000/reserveWeight
    return reserveBalance * (Math.pow(base,power)-1)
  },
  purchaseTargetAmount: function(
    supply,
    reserveBalance,
    reserveWeight,
    amount
  ){
    base = 1 + amount/reserveBalance
    power = reserveWeight/1000000
    return supply * (Math.pow(base,power)-1)
  },
  saleTargetAmount: function(
    supply,
    reserveBalance,
    reserveWeight,
    amount
  ){
    base = 1 - amount/supply
    power = 1000000/reserveWeight
    return reserveBalance * (1-Math.pow(base,power))
  }
}