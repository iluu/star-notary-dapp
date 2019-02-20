pragma solidity >=0.4.25 <0.6.0;

contract StarNotary {
    
    string public starName;
    address public starOwner;
    
    event starClaimed(address owner);
    
    constructor() public {
        starName = "Genesis Star";
    }
    
    function claimStar() public {
        starOwner = msg.sender;
        emit starClaimed(msg.sender);
    }

    function changeName(string memory newName) public {
        starName = newName;
    }
    
}