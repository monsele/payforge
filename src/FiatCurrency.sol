pragma solidity >=0.8.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract FiatCurrency is ERC1155, ERC1155Holder{
     //////////////////
    /////ERRORS/////
    error EstatePool__TransactionFailed();
    ///////////////////
    // State Variables
    ///////////////////

    struct Currency{
        string Name;
        string ShortForm;
        string ImageUri
    }

    
    /// @notice returns short form URL to fiat value
    /// @dev stores the shortform url to a fiat struct
    mapping (bytes32 => Currency) NameToFiat;
     function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC1155, ERC1155Holder) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
    //Create a currency

    function create(string memory name, string memory shortForm, string imageUri) {
        
    }
    //mint more of that currency
    //Burn from that currency
    //get total volume for each curency

}