pragma solidity ^0.8.4;

contract ProposalManager {

    struct Proposal {
        uint id;
        uint signDate;
        address proposer;
        address client;
        string title;
        string description;
    }

    struct Payments {
        uint id;
        uint proposalId;
        address client;
        uint amount;
        uint date;
        uint paymentDate;
    }

    Proposal[] public proposals;
    Payments[] public payments;

    function addPayment(uint _paymentId, uint _date) public payable {
        require(payments[_paymentId].client == msg.sender, 'payment not yours');
        require(payments[_paymentId].paymentDate == 0, 'Payment already made');
        require(payments[_paymentId].amount == msg.value, 'Payment amount is not correct');
        payments[_paymentId].paymentDate = _date;
        payable(proposals[payments[_paymentId].proposalId].proposer).transfer(msg.value);
    }
}