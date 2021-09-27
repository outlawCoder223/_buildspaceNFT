// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// import the ethereum contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods
contract MyEpicNFT is ERC721URIStorage {
    // Keep track of tokenIDs
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Pass NFT name and symbol
    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("What am i doing??");
    }

    // User function to get NFT
    function makeAnEpicNFT() public {
        // Get the current tokenId, starting at 0
        uint256 newItemId = _tokenIds.current();

        // Mint the NFT to the sender
        _safeMint(msg.sender, newItemId);

        // Set the NFTs data
        _setTokenURI(newItemId, "https://jsonkeeper.com/b/SQLK");
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        // Increment the counter for the next NFT
        _tokenIds.increment();
    }
}
