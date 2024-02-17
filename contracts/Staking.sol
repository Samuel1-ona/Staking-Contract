// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20.sol";

contract Staking {
   // Custom error 

   error STAKING_TRANSFERFAILED();
   error STAKING_NO_NEED_ZERO();


   IERC20 public stakeToken;
   IERC20 PUBLIC rewardToken;

   mapping(address => uint256) s_balance;
   mapping(address => uint256) userReward;
   mapping(address => uint256) s_reward;
  
   uint256 s_totalSupply;
   uint256 rewardRate = 100;

   uint256 startTime = block.timestamp;
   uint256 endTime;


   function greaterThanZero(uint256 amount) private {
       if(amount == 0){
        revert STAKING_NO_NEED_ZERO();
       }
   }





   constructor(address _stakeToken, address _rewardToken){
      stakeToken = IERC20 (_stakeToken);
      rewardRate = IERC20 (_rewardToken
   }





}
