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
   mapping(address => uint256) s_userReward;
   mapping(address => uint256) s_reward;
  
   uint256 s_totalSupply;
   uint256 rewardPertokensaves
   uint256 rewardRate = 100;

   uint256 s_startTime = block.timestamp;
   uint256 s_endTime;


   function greaterThanZero(uint256 amount) private {
       if(amount == 0){
        revert STAKING_NO_NEED_ZERO();
       }
   }


   function getRewardpaySave(address account) private view returns (uint256){
         if(s_totalSupply == 0){
            return rewardPertokensaves;
         }

         rewardPertokensaves = (((block.timestamp - s_endTime) * rewardRate * 10e18) / s_totalSupply);
   }


    function earned(uint256 amount) public view  returns (uint256){
        uint256 currentBalance = s_balance[amount];
        uint256 userAmountPaid = s_userReward[amount];
        uint256 rewardSave  = getRewardpaySave();
        uint256 pastReward = s_reward[amount];

         uint256 _earned = ((currentBalance * (currentRewardPerToken - amountPaid) / 1e18) +
        pastRewards);
        return _earned;
    }

    


   constructor(address _stakeToken, address _rewardToken){
      stakeToken = IERC20 (_stakeToken);
      rewardRate = IERC20 (_rewardToken
   }





}
