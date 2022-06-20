/* test/sample-test.js */
describe("NFTMarket", function() {
  it("Should create and execute market sales", async function() {
    /* deploy the marketplace */
    const NFTticket_marketplace = await ethers.getContractFactory("NFTticket_marketplace")
    const NFTticket_marketplace = await NFTticket_marketplace.deploy()
    await NFTticket_marketplace.deployed()

    let listingPrice = await NFTticket_marketplace.getListingPrice()
    listingPrice = listingPrice.toString()

    const auctionPrice = ethers.utils.parseUnits('1', 'ether')

    /* create two tokens */
    await NFTticket_marketplace.createToken("https://www.mytokenlocation.com", auctionPrice, { value: listingPrice })
    await NFTticket_marketplace.createToken("https://www.mytokenlocation2.com", auctionPrice, { value: listingPrice })

    const [_, buyerAddress] = await ethers.getSigners()

    /* execute sale of token to another user */
    await NFTticket_marketplace.connect(buyerAddress).createMarketSale(1, { value: auctionPrice })

    /* resell a token */
    await NFTticket_marketplace.connect(buyerAddress).resellToken(1, auctionPrice, { value: listingPrice })

    /* query for and return the unsold tickets */
    tickets = await NFTticket_marketplace.fetchTickets()
    tickets = await Promise.all(tickets.map(async i => {
      const tokenUri = await NFTticket_marketplace.tokenURI(i.tokenId)
      let ticket = {
        price: i.price.toString(),
        tokenId: i.tokenId.toString(),
        seller: i.seller,
        owner: i.owner,
        tokenUri
      }
      return ticket
    }))
    console.log('tickets: ', tickets)
  })
})