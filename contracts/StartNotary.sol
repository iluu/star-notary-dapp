pragma solidity >=0.4.24;

//Importing openzeppelin-solidity ERC-721 implemented Standard
import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

// StarNotary Contract declaration inheritance the ERC721 openzeppelin implementation
contract StarNotary is ERC721 {

    struct Star {
        string name;
    }

    // Star Token name
    string private _name;

    // Star Token symbol
    string private _symbol;

    // mapping the Star with the tokenId
    mapping(uint256 => Star) public tokenIdToStarInfo;

    // mapping the TokenId and price
    mapping(uint256 => uint256) public starsForSale;

    constructor(string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
    }

    /**
     * @return string representing token name
     */
    function name() external view returns (string memory){
        return _name;
    }

    /**
     * @return string representing token symbol 
     */
    function symbol() external view returns (string memory){
        return _symbol;
    }

    /**
     * Creates a star with given name and token id 
     */
    function createStar(string memory _starName, uint256 _tokenId) public {
        Star memory newStar = Star(_starName);
        tokenIdToStarInfo[_tokenId] = newStar; // Creating in memory the Star -> tokenId mapping
        _mint(msg.sender, _tokenId); // _mint creates new token if non with given id exists, msn.sender will own the token
    }

    // Putting an Star for sale (Adding the star tokenid into the mapping starsForSale, first verify that the sender is the owner)
    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender, "You can't sale the Star you don't owned");
        starsForSale[_tokenId] = _price;
    }


    // Function that allows you to convert an address into a payable address
    function _make_payable(address x) internal pure returns (address payable) {
        return address(uint160(x));
    }

    function buyStar(uint256 _tokenId) public  payable {
        require(starsForSale[_tokenId] > 0, "The Star should be up for sale");

        uint256 starCost = starsForSale[_tokenId];
        address ownerAddress = ownerOf(_tokenId);
        require(msg.value > starCost, "You need to have enough Ether");
        _transferFrom(ownerAddress, msg.sender, _tokenId); // We can't use _addTokenTo or_removeTokenFrom functions, now we have to use _transferFrom

        address payable ownerAddressPayable = _make_payable(ownerAddress); // We need to make this conversion to be able to use transfer() function to transfer ethers
        ownerAddressPayable.transfer(starCost);
        if(msg.value > starCost) {
            msg.sender.transfer(msg.value - starCost);
        }
    }

    /**
     * @return name of the star by its tokenId
     */
    function lookUptokenIdToStarInfo (uint256 _tokenId) public view returns (string memory) {
        return tokenIdToStarInfo[_tokenId].name;
    }

    /**
     * Exchange stars between owners
     */
    function exchangeStars(uint256 _tokenId1, uint256 _tokenId2) public {
        address ownerAddress1 = ownerOf(_tokenId1);
        address ownerAddress2 = ownerOf(_tokenId2);

        require(msg.sender == ownerAddress1 || msg.sender == ownerAddress2, "You should be an owner of one of the tokens");
        // move token1 to owner2
        _transferFrom(ownerAddress1, ownerAddress2, _tokenId1);
        // move token2 to owner1
        _transferFrom(ownerAddress2, ownerAddress1, _tokenId2);
    }

    /**
     * Transfers owned token to a given address
     */
    function transferStar(address _to, uint256 _tokenId) public {
        require(msg.sender == ownerOf(_tokenId), "You cannot transfer token you don't own");
        _transferFrom(msg.sender, _to, _tokenId);
    }

}