pragma solidity ^0.8.0;

contract RewardSystem {
    uint256 public initialPoolBalance;
    uint256 public totalPayouts;
    uint256 public initialReward;
    uint256 public decayFactor;
    mapping(address => uint256) public lastRewardTime;
    uint256 public lastPayoutTime;

    function calculateReward() public view returns (uint256) {
        uint256 poolRatio = (initialPoolBalance * 1e18) / totalPayouts;
        uint256 reward = (initialReward * decayFactor * poolRatio * 979) / (1e18 * 1000);
        return reward;
    }

    function exp(uint256 x) public pure returns (uint256) {
        uint256 result = 1e18;
        uint256 term = 1e18;
        for (uint8 i = 1; i < 21; i++) {
            term = (term * x) / (1e18 * i);
            result += term; // Corrected to add terms
        }
        return result;
    }

    function rewardPlayer(address player) public {
        require(block.timestamp - lastRewardTime[player] >= 1 days, "Reward can only be claimed once every 24 hours");
        
        uint256 reward = calculateReward();
        
        totalPayouts += reward;
        lastRewardTime[player] = block.timestamp;
        lastPayoutTime = block.timestamp;

        // Transfer the reward to the player (omitted for simplicity, needs to be implemented based on your token contract)
        // token.transfer(player, reward);
    }
}