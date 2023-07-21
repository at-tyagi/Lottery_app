// SPDX-Licence-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery {
    address public manager;
    address payable[] public participants;

    constructor()
    {
        manager=msg.sender;
    }

    receive() external payable 
{
    require(msg.sender!=manager, "Manager not allowedt");
    require(msg.value >= 0.01 ether);
    address payable participant = payable(msg.sender);
    bool addressAlreadyAdded = false;
    
    for (uint i = 0; i < participants.length; i++) {
        if (participants[i] == participant) {
            addressAlreadyAdded = true;
            break;
        }
    }
    
    require(!addressAlreadyAdded, "Address is already a participant");
    
    participants.push(participant);
}

    function getBalance() public view returns(uint)
    {   require(msg.sender==manager);
        return address(this).balance;
    }
    function random() public view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

    function selectWinner() public 
    {
        require(msg.sender == manager);
        require(participants.length>2);
        address payable winner;
        uint i = random() % participants.length;
        winner=participants[i];
        winner.transfer(getBalance());
        participants=new address payable[](0);
    }
    function participants_no() view public returns(uint)
    {
        return participants.length;
    }
}