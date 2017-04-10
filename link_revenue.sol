pragma solidity ^0.4.10;


/**
 * @title LinkRevenue
 * @author Jonathan Brown <jbrown@bluedroplet.com>
 */
contract LinkRevenue {

    uint public startTime;
    uint public withdrawn;
    address public owner;

    function LinkRevenue() {
        startTime = block.timestamp;
        owner = msg.sender;
    }

    modifier isOwner() {
        if (msg.sender != owner) {
            throw;
        }
        _;
    }

    function changeOwner(address newOwner) external isOwner {
        owner = newOwner;
    }

    function withdraw() external isOwner {
        uint released = getReleased();
        uint amount = released - withdrawn;
        withdrawn = released;
        owner.transfer(amount);
    }

    function getReleased() constant returns (uint released) {
        uint dailyAmount = 50000 ether;
        int elapsed = int((block.timestamp - startTime) / 1 days);

        while ((dailyAmount != 0) && (elapsed > 0)) {
            released += uint((elapsed < 200) ? elapsed : 200) * dailyAmount;
            dailyAmount -= 5000 ether;
            elapsed -= 200;
        }
    }

}
