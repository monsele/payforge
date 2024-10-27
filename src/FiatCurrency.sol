pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract FiatCurrency is ERC1155, ERC1155Holder {
    //////////////////
    /////ERRORS/////
    error EstatePool__TransactionFailed();
    ///////////////////
    // State Variables
    ///////////////////
    uint256 private tokenCounter;
      Currency[] private CurrencyList;
    /// @notice returns short form URL to fiat value
    /// @dev stores the shortform url to a fiat struct
    mapping(bytes32 => Currency) NameToFiat;

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC1155, ERC1155Holder)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    constructor(string memory _uri) ERC1155(_uri) {
        _setURI(_uri);
    }

    struct Currency {
        string Name;
        string ShortForm;
        string ImageUri;
        uint256 TokenId;
    }

    function create(string memory name, string memory shortForm, string memory imageUri) external {
        tokenCounter = GetTokenCounter() + 1;
        Currency memory currency = Currency(name, shortForm, imageUri,tokenCounter);
        CurrencyList.push(currency);
        bytes32 key = keccak256(abi.encodePacked(shortForm));
        NameToFiat[key]=currency;
    }
    //mint more of that currency
    function mintCurrency(uint256 tokenId, uint256 amount, address user) external {  
        _mint(user, tokenId, amount,"");
        _setApprovalForAll(user, address(this), true);
    }
     function burnCurrency(uint256 tokenId, uint256 amount, address user) external {  
        _burn(user, tokenId, amount);
    }

    //Burn from that currency
    //get total volume for each curency
    function GetTokenCounter() public view returns (uint256) {
		return tokenCounter;
	}
    function getUserBalance(string memory shortForm,address user) external view returns(uint256) {
        bytes32 key = keccak256(abi.encodePacked(shortForm));
        Currency memory currency = NameToFiat[key];
        return balanceOf(user, currency.TokenId);
    }
}
