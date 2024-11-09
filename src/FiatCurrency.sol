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
    /// @notice returns currency struct
    /// @dev this is a mapping of the byte representation of the short form
    /// to the currency struct
    mapping(bytes32 => Currency) NameToFiat;
    mapping (address => uint256) LockUpAmount;
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
        Currency memory currency = Currency(name, shortForm, imageUri, tokenCounter);
        CurrencyList.push(currency);
        bytes32 key = keccak256(abi.encodePacked(shortForm));
        NameToFiat[key] = currency;
    }
    //mint more of that currency

    function mintCurrency(string memory shortForm, uint256 amount, address user) external {
        bytes32 key = keccak256(abi.encodePacked(shortForm));
        Currency memory currency = NameToFiat[key];

        _mint(user, currency.TokenId, amount, "");
        _setApprovalForAll(user, address(this), true);
    }

    function burnCurrency(string memory shortForm, uint256 amount, address user) external {

        bytes32 key = keccak256(abi.encodePacked(shortForm));
        Currency memory currency = NameToFiat[key];
        _burn(user, currency.TokenId, amount);
    }
    function LockUp(address user, string memory shortForm, uint256 amount) external {
        // check how much the user has
        bytes32 key = getKey(shortForm);
        Currency memory currency = NameToFiat[key];
        uint256 userBalance = balanceOf(user, currency.TokenId);
        require(amount>=userBalance, "User does not have up to that amount");
        LockUpAmount[user] = amount;
    }

    //Burn from that currency
    //get total volume for each curency
    function GetTokenCounter() public view returns (uint256) {
        return tokenCounter;
    }

    function getUserBalance(string memory shortForm, address user) external view returns (uint256) {
        bytes32 key = keccak256(abi.encodePacked(shortForm));
        Currency memory currency = NameToFiat[key];
        return balanceOf(user, currency.TokenId);
    }
    function getKey(string memory shortForm) private pure returns (bytes32) {
         return keccak256(abi.encodePacked(shortForm));
    }
    //Learn override key word din solidity
}
