/**
 * @title AcuityRevenue
 * @author Jonathan Brown <jbrown@acuity.social>
 */
contract AcuityRevenue {

    uint128 public startTime;
    uint128 public withdrawn;
    address payable public owner;

    /**
     * @dev The owner of this contract has chanaged.
     * @param oldOwner Old owner of this contract.
     * @param newOwner New Owner of this contract.
     */
    event ChangeOwner(address oldOwner, address newOwner);

    /**
     * @dev A withdrawal has occured.
     * @param recipient Recipient of the withdrawal.
     * @param amount Amount of ACU withdrawn.
     */
    event Withdraw(address recipient, uint amount);

    /**
     * @dev Throws if the sender is not the owner of the contract.
     */
    modifier isOwner() {
        require (msg.sender == owner);
        _;
    }

    /**
     * @dev Constructor.
     */
    constructor() {
        startTime = block.timestamp;
        owner = msg.sender;
    }

    /**
     * @dev Changes the owner of the contract.
     * @param newOwner The new owner of the contract.
     */
    function changeOwner(address payable newOwner) external isOwner {
        owner = newOwner;
        emit ChangeOwner(msg.sender, newOwner);
    }

    /**
     * @dev Withdraws any available funds to the owner.
     */
    function withdraw() external isOwner {
        uint128 released = getReleased();
        uint128 amount = released - withdrawn;
        withdrawn = released;
        owner.transfer(amount);
        emit Withdraw(owner, amount);
    }

    /**
     * @dev Determines how much ACU has been released in total so far.
     */
    function getReleased() public view returns (uint128 released) {
        uint128 dailyAmount = 50000 ether;
        int128 elapsed = int128((block.timestamp - startTime) / 1 days);

        while ((dailyAmount != 0) && (elapsed > 0)) {
            if (elapsed < 200) {
                released += uint128(elapsed) * dailyAmount;
            }
            else {
                released += 200 * dailyAmount;
            }
            dailyAmount -= 5000 ether;
            elapsed -= 200;
        }
    }

}
