// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20.sol";

contract Staking {
    error ZeroAddressCannotStake();
    error CannotDepositZeroAmount();
    error TransferFailed();
    error WithdrawFailed();
    error AlreadyWithdrawn();
    error StakingPeriodNotEnded();

    IERC20 public stakeToken;
    address public owner;

    struct Stake {
        uint256 amount;
        uint256 startTime;
        uint256 endTime;
        bool withdrawn;
    }

    mapping(address => Stake) public stakes;

    uint256 constant interestRate = 10; // The interest rate percentage per annum
    uint256 constant timeUnit = 365; // Number of days in a year

    constructor(address _stakeToken) {
        stakeToken = IERC20(_stakeToken);
        owner = msg.sender;
    }

    function stakeTokens(uint256 _amount, uint256 _duration) external {
        if (msg.sender == address(0)) {
            revert ZeroAddressCannotStake();
        }
        if (_amount == 0) {
            revert CannotDepositZeroAmount();
        }

        bool transferSuccess = stakeToken.transferFrom(msg.sender, address(this), _amount);
        if (!transferSuccess) {
            revert TransferFailed();
        }

        stakes[msg.sender] = Stake({
            amount: _amount,
            startTime: block.timestamp,
            endTime: block.timestamp + _duration,
            withdrawn: false
        });
    }

    // A function that calculates the interest for every staking over the duration
    function calculateInterest(address _user) public view returns (uint256) {
        Stake memory userStake = stakes[_user];
        if (block.timestamp < userStake.endTime) {
            revert StakingPeriodNotEnded();
        }
        uint256 stakingDuration = userStake.endTime - userStake.startTime;
        uint256 stakingInterest = (userStake.amount * interestRate * stakingDuration) / (timeUnit * 100);

        return stakingInterest;
    }

    // Withdraw function
    function withdraw() external {
        Stake storage userStake = stakes[msg.sender];
        if (block.timestamp < userStake.endTime) {
            revert StakingPeriodNotEnded();
        }
        if (userStake.withdrawn) {
            revert AlreadyWithdrawn();
        }

        uint256 userInterest = calculateInterest(msg.sender);
        userStake.withdrawn = true;

        bool transferSuccess = stakeToken.transfer(msg.sender, userStake.amount + userInterest);
        if (!transferSuccess) {
            revert WithdrawFailed();
        }
    }

    function getStakingAmount(address _user) external view returns (uint256) {
        return stakes[_user].amount;
    }
}
