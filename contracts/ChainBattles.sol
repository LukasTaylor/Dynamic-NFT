// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256; //easily convert strings
    using Counters for Counters.Counter; //create token ids
    Counters.Counter private _tokenIds; //tokenId variable

    struct Character {
        uint256 level;
        uint256 speed;
        uint256 strength;
        uint256 health;
    }

    //maps two key-value pairs together
    mapping(uint256 => uint256) public tokenIdToLevels;
    mapping(uint256 => Character) public tokenIdToCharacter;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 tokenId) public returns (string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior Wizard",
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            // "Levels: ",
            // getLevel(tokenId),
            // "</text>",
            // '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Speed: ",
            getSpeed(tokenId),
            "</text>",
            // '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            // "Strength: ",
            // getStrength(tokenId),
            // "</text>",
            // '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            // "Health: ",
            // getHealth(tokenId),
            // "</text>",
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    /**
     * Generate random number
     * @return number returns a pseudorandom number
     */
    function generateRandomNumber(
        uint256 number
    ) public view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.difficulty,
                        msg.sender
                    )
                )
            ) % number;
    }

    /**
     * Retreives level of current character
     * @param tokenId current tokenId
     * @return level string representation of current tokens level
     */
    function getLevel(uint256 tokenId) public view returns (string memory) {
        //Use current tokenId to access characters level property
        Character memory character = tokenIdToCharacter[tokenId];
        uint256 level = character.level;
        return level.toString();
    }

    /**
     * Retreives speed of current character
     * @param tokenId current tokenId
     * @return speed string representation of current tokens speed
     */
    function getSpeed(uint256 tokenId) public view returns (string memory) {
        //Use current tokenId to access characters speed property
        Character memory character = tokenIdToCharacter[tokenId];
        uint256 speed = character.speed;
        return speed.toString();
    }

    /**
     * Retreives strength of current character
     * @param tokenId current tokenId
     * @return speed string representation of current tokens strength
     */
    function getStrength(uint256 tokenId) public view returns (string memory) {
        //Use current tokenId to access characters strength property
        Character memory character = tokenIdToCharacter[tokenId];
        uint256 strength = character.strength;
        return strength.toString();
    }

    /**
     * Retreives health of current character
     * @param tokenId current tokenId
     * @return speed string representation of current tokens health
     */
    function getHealth(uint256 tokenId) public view returns (string memory) {
        //Use current tokenId to access characters health property
        Character memory character = tokenIdToCharacter[tokenId];
        uint256 health = character.health;
        return health.toString();
    }

    /**
     * Generates ABI and encodes to URI
     * @param tokenId current tokenID
     * @return string URI encoded as string
     */
    function getTokenURI(uint256 tokenId) public returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    /**
     * Function to mint an NFT
     */
    function mint() public {
        Character memory newCharacter = Character(
            0, //level
            generateRandomNumber(2556), //speed
            generateRandomNumber(56), //strength
            generateRandomNumber(867665) //health
        );
        // I changed newItemId to newTokenId in this function
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _safeMint(msg.sender, newTokenId);
        tokenIdToCharacter[newTokenId] = newCharacter;
        //tokenIdToLevels[newItemId] = 0;
        _setTokenURI(newTokenId, getTokenURI(newTokenId));
    }

    /**
     * Function to train the character/NFT
     * @param tokenId current tokenId
     */
    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to train it"
        );

        Character memory character = tokenIdToCharacter[tokenId];
        uint256 currentLevel = character.level;
        character.level = currentLevel++;
        _setTokenURI(tokenId, getTokenURI(tokenId)); //updates metadata associated with this NFT
    }
}
