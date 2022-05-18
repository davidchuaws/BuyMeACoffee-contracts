//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// Deployed at 0x3156BE1e094fd0f6829D2DD666FFeFcbb3Eb5107

contract BuyMeACoffee {
    //Event to emit when a Memo is created
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

    // Memo struct
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    // Address of contract deployer
    address payable owner;
    // List of all memos received from friends
    Memo[] memos;

    constructor() {
        owner = payable(msg.sender);
    }

    /**
     * @dev buy a coffee for contract owner
     * @param _name of the coffeee buyer
     * @param _message a nice message from the coffee buyer
     */
    function buyCoffee(string memory _name, string memory _message) public payable  {
        require(msg.value > 0, "Can't buy a coffeee with 0 ETH!");
        
        // Add the memo to storage!
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));
        
        //Emit a log event when a new memo is created
        emit NewMemo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        );
    }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */
    function withdrawTips() public {
        require(owner.send(address(this).balance));
    }

    /**
     * @dev retrieve all the memos received and stored on the blockchain
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        owner = payable(_newOwner);
    }
}
