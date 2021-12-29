pragma solidity ^0.8.4;
// SPDX-License-Identifier: MIT

contract Proposal {
    uint public id;
    uint public signDate;
    address public proposer;
    address public client;
    string public title;
    string public description;
    uint public paymentCount= 0;
    
    struct Payment {
        uint id;
        uint proposalId;
        address client;
        uint amount;
        uint date;
        uint paymentDate;
    }

    Payment[] public payments;

    constructor(uint _id, uint _signDate, address _proposer, address _client, string memory _title, string memory  _description) {
        id = _id;
        signDate = _signDate;
        proposer = _proposer;
        client = _client;
        title = _title;
        description = _description;
    }

    function addPayment(uint _amount, uint _date, uint _paymentDate) external {
        Payment memory payment = Payment(id, paymentCount, client, _amount, _date, _paymentDate);
        payments.push(payment);
        paymentCount++;
    }

     function makePayment(uint _paymentId, uint _date) public payable {
        require(client == msg.sender, 'payment not yours');
        require(payments[_paymentId].paymentDate == 0, 'Payment already made');
        require(payments[_paymentId].amount == msg.value, 'Payment amount is not correct');
        payments[_paymentId].paymentDate = _date;
        payable(proposer).transfer(msg.value);
    }

}