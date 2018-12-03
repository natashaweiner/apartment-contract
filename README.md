# Apartments 721
# Property Management Contract 

# Requirements:
Must be able to handle a variable amount of participants

We have a mapping of uint256 (apartmentIDs) to addresses (owners) and a mapping of addresses (owners) to uint256 (number of apartments). This means we can have up to 2256 apartment owners.
Must have at least one payable function

transferFrom is a payable function that can be called by any individual. This function requires msg.value to be greater than or equal to 2 ether. This amount is to be used as collateral (see next point)

Must punish any dishonest participants in the contract

If _from argument in transferFrom does not match msg.sender or if the owner of the apartment is not _from, then nothing happens and the value sent belongs to the contract; otherwise, if the above conditions hold, then the 2 ether amount will be transferred back to _from (msg.sender)

Must disallow new participants after the contract is over/finished (if your contract has a terminal state)

The contract does not terminate since individuals should always be able to transfer their apartment to another individual that the contract has not seen before.

# Functionality: 
# Global View
Token Name
Token Symbol
Building owner (the creator of the contract)
Apartment Structure
ID
Name
Owner of the apartment
List of Apartments
Mapping of apartment IDs to owners
Mapping of owners to number of apartments
# Functions:
#Constructor()
Arguments:
None
Function:
Sets the building owner global variable to the creator of the contract
Return:
No return value
# createApartment(string apt_name) external
Arguments:
Name of the apartment
Condition:
Name of the apartment string cannot be empty
Function caller (msg.sender) is the building owner (since the building owner is the only one that can create an apartment)
Function:
Calls the internal _createApartment function
Returns:
No return value
# _createApartment(address owner, string apt_name) internal returns (Apartment newApartment)
Arguments:
The new owner of this created apartment
Apartment Name
Condition:
None
Function:
Creates an a new apartment structure and fills out the required fields
Adds the apartment to the global list of apartments
Calls the internal _transfer function with the from argument to be 0 since no one previously owned the apartment, the to argument to be the new apartment owner, and tokenID to be the new apartment index
Returns
The new apartment structure
# contract_balance() external view returns (uint256)
Arguments:
None
Condition:
None
Function:
Gets the balance of the contract
Return:
The balance of the contract
# send_contract_value_to_owner() external
Arguments:
None
Condition:
Caller for this function (msg.sender) must be the building owner
Function:
Transfers all the balance associated to the contract and sends it to the building owner
Returns
None
# transferFrom(address _from, address _to, uint256 _tokenId) external payable
Arguments:
From address
To address
Token ID (apartment ID)
Condition:
_to must not be 0 (so that the token doesn’t burn)
The value sent must be greater than 2 ether
Function with dishonesty:
If _from is not the caller (msg.sender) or the caller does not own the specified tokenId, then nothing happens and the contract keeps the ether sent
Otherwise the ether sent will be refunded to the caller
Returns
None
# balanceOf(address _owner) external view returns (uint256)
Arguments
Address to look at
Condition:
None
Function:
Gets the number of apartments that the address owns
Returns
Returns the number of apartments that the address owns
# ownerOf(uint256 _tokenId) external view returns (address)
Arguments:
TokenId (the ID of the apartment)
Condition:
None
Function:
Gets the owner of the specified token ID
Returns:
Returns the owner of the specified token ID
# transfer(address _from, address _to, uint256 _tokenId) internal
Arguments:
From address
To address
Token ID (Apartment ID)
Condition:
None
Function:
Changes the owner of the apartment by updating the owner of the apartment ID
Changes the owner field in the respective apartment structure
Updates the token count for the specified owner
Returns
None
