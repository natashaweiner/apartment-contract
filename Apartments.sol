pragma solidity ^0.4.20;

import './ERCs.sol';

contract Building is ERC721
{
    /** Token General Information */
    string public constant name = "Building Token";
    string public constant symbol = "BDT";
    
    /// Creator of the contract
    address buildingOwner;
    
    struct Apartment
    {
        uint256 id;
        string name;
        address owner;
    }
    
    Apartment[] apartments;
    
    /// Mapping apartment ID to owner
    mapping (uint256 => address) apartmentIDToOwner;
    
    /// Mapping owner to number of apartments
    mapping (address => uint256) ownerToApartmentsCount;
    
    function Building() public
    {
        buildingOwner = msg.sender;
    }
    
    /***
     * Creates an Apartment
     * Condition: Must be the building owner
     * Condition: apt_name must not be empty
     */
    function createApartment(string apt_name) external
    {
        // Is owner
        require(msg.sender == buildingOwner);
        
        bytes memory name_bytes = bytes(apt_name);
        require(name_bytes.length > 0);
        
        _createApartment(buildingOwner, apt_name);
    }
    
    function _createApartment(address owner, string apt_name) internal returns (Apartment newApartment)
    {
        Apartment memory apartment = Apartment({
            owner: owner,
            name: apt_name,
            id: apartments.length
        });
        
        newApartment = apartment;
        apartments.push(newApartment);
        
        transfer(0, owner, newApartment.id);
    }
    
    /** Contract Balance Management */
    /***
     * View the balance for this contract
     */
    function contract_balance() external view returns (uint256)
    {
        return address(this).balance;
    }
    
    /***
     * Sends the entire contract balance to the building owner
     * Condition: Building owner must be the one calling this function
     */
    function send_contract_value_to_owner() external
    {
        require(msg.sender == buildingOwner);
        
        buildingOwner.transfer(address(this).balance);
    }
    
    /** ERC721 Functions**/
    /**
     * Transfers an apartment from one address to another
     * Condition: 2 ether must be sent
     * Condition: _to must not be 0 (we don't want to burn an apartment token)
     * 
     * Dishonesty: Caller is not _from or apartment token is not owned by _from
     * - 2 ether is not refunded to the caller and is kept by the contract
     */
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable
    {
        require(_to != address(0));
        // Collateral
        require(msg.value >= 2 ether);
        
        if(msg.sender == _from && apartmentIDToOwner[_tokenId] == _from)
        {
            transfer(_from, _to, _tokenId);
            _from.transfer(msg.value);
        }
    }
    
    /**
     * Get the number of apartment tokens for a certain address
     */
    function balanceOf(address _owner) external view returns (uint256)
    {
        return ownerToApartmentsCount[_owner];
    }
    
    /**
     * Get the owner (address) of a certain apartment token
     */
    function ownerOf(uint256 _tokenId) external view returns (address)
    {
        return apartmentIDToOwner[_tokenId];
    }
    
    /** Helper Internal Functions */
    function transfer(address _from, address _to, uint256 _tokenId) internal
    {
        ownerToApartmentsCount[_to]++;
        apartmentIDToOwner[_tokenId] = _to;
        apartments[_tokenId].owner = _to;
        
        ownerToApartmentsCount[_from]--;
        
        Transfer(_from, _to, _tokenId);
    }
}