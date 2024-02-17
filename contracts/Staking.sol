// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

import "./IERC20.sol";

contract Staking{

    // custom error message
     error ZERO_ADDRESS_CAN_NOT_STAKING();
     error CAN_NOT_DEPOSIT_ZERO_AMOUNT();
     error TRANSFER_FAILED();
     error WITHDRAW_FAILED();
     error WITHDRAW_ALREADY();
     error STAKING_PERIOD_NOT_ENDED();


    
    IERC20  stakeToken;
    address owner;

    struct Stake{
        uint256 amount;
        uint256 startTime;
        uint256 endTime;
        bool withdraw;
    }
      
      mapping (address => uint) stakes;

      uint256 constant interestRate = 10;  // The interest rate percentage per annum 
      uint256 constant  timeUint = 356; // Number of days in a year

    constructor(uint256 _stakeToken){
        stakeToken = _stakeToken;
        owner = msg.sendr;
    }


   function stakeToken(uint256 _amount,uint256 _duration) external {
         if(msg.sender == 0){
            revert ZERO_ADDRESS_CAN_NOT_STAKING();
         }
         if(_amount < 0){
            revert CAN_NOT_DEPOSIT_ZERO_AMOUNT();
         }

         stakes[msg.sender] = Stake({
            amount: _amount
            startTime: block.timestamp,
            endTime: block.timestamp + _duration,
            withdraw: false
         });
   }



   function calculateInterest(address _user) external view returns (uint256){
    Stake memory userStake = stake[_user];
         if(block.timestamp < userStake.endTime){

            revert STAKING_PERIOD_NOT_ENDED();
         }
    uint256 stakingDuration = userStake.endTime - userStake.startTime;
    uint256 stakingInterest = (userStake.amount *interestRate *stakingDuration) / (timeUint*100);

    return stakingInterest;
   }

   function withdraw() external view {

   }

   function getStakingAmount(address _user) external view {

   }



}