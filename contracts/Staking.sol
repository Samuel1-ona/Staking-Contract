// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20.sol";

contract Staking {
    // Custom errors
    error STAKING_TRANSFERFAILED();
    error STAKING_NO_NEED_ZERO();

    IERC20 public stakeToken;
    IERC20 public rewardToken;

    mapping(address => uint256) public s_balance;
    mapping(address => uint256) public s_userRewardPerTokenPaid; // Renamed for clarity
    mapping(address => uint256) public s_rewards; // Renamed for clarity

    uint256 public s_totalSupply;
    uint256 public rewardPerTokenStored; // Renamed for clarity
    uint256 public rewardRate = 100; // Example reward rate, can be adjusted

    uint256 public lastUpdateTime; // Renamed for clarity

    // Ensures the amount is greater than zero
    function greaterThanZero(uint256 amount) private pure {
        if (amount == 0) {
            revert STAKING_NO_NEED_ZERO();
        }
    }

    // Updates reward for a user
    function updateReward(address account) private {
        rewardPerTokenStored = getRewardPerTokenStored();
        lastUpdateTime = block.timestamp;
        if (account != address(0)) {
            s_rewards[account] = earned(account);
            s_userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
    }

    // Calculates the reward per token stored
    function getRewardPerTokenStored() private view returns (uint256) {
        if (s_totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return rewardPerTokenStored + (((block.timestamp - lastUpdateTime) * rewardRate * 1e18) / s_totalSupply);
    }

    // Calculates the amount earned by an account
    function earned(address account) public view returns (uint256) {
        uint256 currentBalance = s_balance[account];
        uint256 rewardPerTokenPaid = s_userRewardPerTokenPaid[account];
        return ((currentBalance * (getRewardPerTokenStored() - rewardPerTokenPaid)) / 1e18) + s_rewards[account];
    }

    // Constructor to set the stake and reward tokens
    constructor(address _stakeToken, address _rewardToken) {
        stakeToken = IERC20(_stakeToken);
        rewardToken = IERC20(_rewardToken);
    }

    // Function to stake tokens
    function stake(uint256 amount) external {
        updateReward(msg.sender);
        greaterThanZero(amount);
        s_balance[msg.sender] += amount;
        s_totalSupply += amount;
        bool transferSuccess = stakeToken.transferFrom(msg.sender, address(this), amount);
        if (!transferSuccess) {
            revert STAKING_TRANSFERFAILED();
        }
    }

    // Function to withdraw staked tokens
    function withdraw(uint256 amount) external {
        updateReward(msg.sender);
        greaterThanZero(amount);
        s_balance[msg.sender] -= amount;
        s_totalSupply -= amount;
        bool transferSuccess = stakeToken.transfer(msg.sender, amount);
        if (!transferSuccess) {
            revert STAKING_TRANSFERFAILED();
        }
    }

    // Function to claim rewards
    function claim() external {
        updateReward(msg.sender);
        uint256 reward = s_rewards[msg.sender];
        if (reward > 0) {
            s_rewards[msg.sender] = 0;
            bool transferSuccess = rewardToken.transfer(msg.sender, reward);
            if (!transferSuccess) {
                revert STAKING_TRANSFERFAILED();
            }
        }
    }
}
