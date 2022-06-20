// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";

contract NFTticket_marketplace is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _ticketsSold;

    uint256 listingPrice = 0 ether;
    address payable owner;

    mapping(uint256 => Ticket) private idToTicket;

    struct Ticket {
      uint256 tokenId;
      address payable seller;
      address payable owner;
      uint256 price;
      bool sold;
    }

    event TicketCreated (
      uint256 indexed tokenId,
      address seller,
      address owner,
      uint256 price,
      bool sold
    );

    constructor() ERC721("Metaverse Tokens", "METT") {
      owner = payable(msg.sender);
    }

    /* Updates the listing price of the contract */
    function updateListingPrice(uint _listingPrice) public payable {
      require(owner == msg.sender, "Only marketplace owner can update listing price.");
      listingPrice = _listingPrice;
    }

    /* Returns the listing price of the contract */
    function getListingPrice() public view returns (uint256) {
      return listingPrice;
    }

    /* Mints a ticket and lists it in the marketplace */
    function createToken(string memory tokenURI, uint256 price) public payable returns (uint) {
      _tokenIds.increment();
      uint256 newTokenId = _tokenIds.current();

      _mint(msg.sender, newTokenId);
      _setTokenURI(newTokenId, tokenURI);
      createTicket(newTokenId, price);
      return newTokenId;
    }

    function createTicket(
      uint256 tokenId,
      uint256 price
    ) private {
      require(price > 0, "Price must be at least 1 wei");
      require(msg.value == listingPrice, "Price must be equal to listing price");

      idToTicket[tokenId] =  Ticket(
        tokenId,
        payable(msg.sender),
        payable(address(this)),
        price,
        false
      );

      _transfer(msg.sender, address(this), tokenId);
      emit TicketCreated(
        tokenId,
        msg.sender,
        address(this),
        price,
        false
      );
    }

    /* allows the buyer to resell a ticket they have purchased */
    function resellToken(uint256 tokenId, uint256 price) public payable {
      require(idToTicket[tokenId].owner == msg.sender, "Only ticket owner can perform this operation");
      require(msg.value == listingPrice, "Price must be equal to listing price");
      idToTicket[tokenId].sold = false;
      idToTicket[tokenId].price = price;
      idToTicket[tokenId].seller = payable(msg.sender);
      idToTicket[tokenId].owner = payable(address(this));
      _ticketsSold.decrement();

      _transfer(msg.sender, address(this), tokenId);
    }

    /* Creates the sale of a marketplace ticket */
    /* Transfers ownership of the ticket, as well as funds between parties */
    function createMarketSale(
      uint256 tokenId
      ) public payable {
      uint price = idToTicket[tokenId].price;
      address seller = idToTicket[tokenId].seller;
      require(msg.value == price, "Please submit the asking price in order to complete the purchase");
      idToTicket[tokenId].owner = payable(msg.sender);
      idToTicket[tokenId].sold = true;
      idToTicket[tokenId].seller = payable(address(0));
      _ticketsSold.increment();
      _transfer(address(this), msg.sender, tokenId);
      payable(owner).transfer(listingPrice);
      payable(seller).transfer(msg.value);
    }

    /* Returns all unsold market tickets */
    function fetchTickets() public view returns (Ticket[] memory) {
      uint ticketCount = _tokenIds.current();
      uint unsoldticketCount = _tokenIds.current() - _ticketsSold.current();
      uint currentIndex = 0;

      Ticket[] memory tickets = new Ticket[](unsoldticketCount);
      for (uint i = 0; i < ticketCount; i++) {
        if (idToTicket[i + 1].owner == address(this)) {
          uint currentId = i + 1;
          Ticket storage currentticket = idToTicket[currentId];
          tickets[currentIndex] = currentticket;
          currentIndex += 1;
        }
      }
      return tickets;
    }

    /* Returns only tickets that a user has purchased */
    function fetchMyNFTtickets() public view returns (Ticket[] memory) {
      uint totalticketCount = _tokenIds.current();
      uint ticketCount = 0;
      uint currentIndex = 0;

      for (uint i = 0; i < totalticketCount; i++) {
        if (idToTicket[i + 1].owner == msg.sender) {
          ticketCount += 1;
        }
      }

      Ticket[] memory tickets = new Ticket[](ticketCount);
      for (uint i = 0; i < totalticketCount; i++) {
        if (idToTicket[i + 1].owner == msg.sender) {
          uint currentId = i + 1;
          Ticket storage currentticket = idToTicket[currentId];
          tickets[currentIndex] = currentticket;
          currentIndex += 1;
        }
      }
      return tickets;
    }

    /* Returns only tickets a user has listed */
    function fetchticketsListed() public view returns (Ticket[] memory) {
      uint totalticketCount = _tokenIds.current();
      uint ticketCount = 0;
      uint currentIndex = 0;

      for (uint i = 0; i < totalticketCount; i++) {
        if (idToTicket[i + 1].seller == msg.sender) {
          ticketCount += 1;
        }
      }

      Ticket[] memory tickets = new Ticket[](ticketCount);
      for (uint i = 0; i < totalticketCount; i++) {
        if (idToTicket[i + 1].seller == msg.sender) {
          uint currentId = i + 1;
          Ticket storage currentticket = idToTicket[currentId];
          tickets[currentIndex] = currentticket;
          currentIndex += 1;
        }
      }
      return tickets;
    }
}