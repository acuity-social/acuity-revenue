pragma solidity ^0.4.9;


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

    function getReleased() constant returns (uint released) {
        uint dailyAmount = 50000 ether;
        int elapsed = int((block.timestamp - startTime) / 1 days);

        while ((dailyAmount != 0) && (elapsed > 0)) {
            released += uint((elapsed < 200) ? elapsed : 200) * dailyAmount;
            dailyAmount -= 5000 ether;
            elapsed -= 200;
        }
    }

    function changeOwner(address newOwner) external {
        if (msg.sender != owner) {
            throw;
        }
        owner = newOwner;
    }

    function withdraw() external {
        uint released = getReleased();
        uint amount = released - withdrawn;
        withdrawn = released;
        if (!owner.call.value(amount)()) {
            throw;
        }
    }

}
