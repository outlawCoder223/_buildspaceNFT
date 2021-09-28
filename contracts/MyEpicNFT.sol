// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// import the ethereum contracts
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// Import helper funcs
import {Base64} from "./lib/Base64.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods
contract MyEpicNFT is ERC721URIStorage {
    // Keep track of tokenIDs
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Make a base Svg that all NFTs can use
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // Random words for NFT
    string[] favChars = [
        "RICK",
        "JOHNWICK",
        "TERMINATOR",
        "PREDATOR",
        "ABRAHAM",
        "VINCENT"
    ];
    string[] favTeams = [
        "REDSOX",
        "BLUEJAYS",
        "SUNS",
        "OILERS",
        "CELTICS",
        "BRUINS"
    ];
    string[] favBands = [
        "INFLAMES",
        "TRIVIUM",
        "ABR",
        "PINKFLOYD",
        "PERIPHERY",
        "KSE"
    ];

    // Pass NFT name and symbol
    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("What am i doing??");
    }

    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        // Seed random generator
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        // Squash the * between 0 and the length of the array
        rand = rand % favChars.length;
        return favChars[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        // Seed random generator
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        // Squash the * between 0 and the length of the array
        rand = rand % favTeams.length;
        return favTeams[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        // Seed random generator
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        // Squash the * between 0 and the length of the array
        rand = rand % favBands.length;
        return favBands[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // User function to get NFT
    function makeAnEpicNFT() public {
        // Get the current tokenId, starting at 0
        uint256 newItemId = _tokenIds.current();

        // Get the random three words
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        // Concatenate svg
        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        // base64 encode JSON metadata
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // prepend data:application/json;base64,
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n------------------");
        console.log(finalSvg);
        console.log("-------------------\n");
        // Mint the NFT to the sender
        _safeMint(msg.sender, newItemId);

        // Set the NFTs data
        _setTokenURI(newItemId, finalTokenUri);
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        // Increment the counter for the next NFT
        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );
    }
}
