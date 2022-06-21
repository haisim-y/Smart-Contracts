//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;



contract DecentralizedLottery {

    address payable[] public participants;
    address public Lotteryadmin;
    address payable public LotteryWinner;
    int public  tickets=0;
    uint public balance=0;
    
    constructor() {

     Lotteryadmin = msg.sender;
      
    }
   
    modifier onlyAdmin() {
        require(Lotteryadmin == msg.sender, "You are not the owner");
        _;
    }
                            /*  ALL THE BALANCE OF LOTTERY WILL BE BE RECEIVED BY THIS METHOD IN SMART CONTRACT   */
    
     receive() external payable {
        require(msg.value == 5 ether ,"Participants must deposit 5 ether in this contract to participate in lottery");
        require(msg.sender != Lotteryadmin,"Admin cannot participate in lottery");
        participants.push(payable(msg.sender));
        balance=getBalance();
        tickets++;
    }
    
                            /*   THIS METHOD RETURNS ALL THE BALANCE PRESENT IN SMART CONTRACT     */

    function getBalance()   internal view returns(uint){
        // returns the contract balance 
        return address(this).balance;
        
    }
                            /*     THIS METHOD GENERATES THE RANDOM NUMBER    */

    function randomNumber() internal view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }
                              /*     THIS METHOD PICKS THE LOTTERY WINNER     */

    function WinnerPicker() public onlyAdmin {
      
        require(participants.length >= 3 , "Not enough players in the lottery");
        LotteryWinner = participants[randomNumber() % participants.length];
        //LOTTERY WINNER WILL RECEIVE 95% OF WINNING FROM THE LOTTERY.
        LotteryWinner.transfer( (getBalance() * 95) / 100); 
        //LOTTERY ADMIN WILL RECEIVE 5% FROM THE LOTTERY.
        payable(Lotteryadmin).transfer( (getBalance() * 5) / 100); 
        LotteryReset(); 
        
    }
   
    function LotteryReset() internal {

        
        participants = new address payable[](0);
        tickets=0;
        balance=0;

    }

}
