pragma solidity ^0.8.4;
// SPDX-License-Identifier: MIT

contract ProposalBase {

    struct Proposal {
        uint id;
        uint signDate;
        uint paymentCount;
        address proposer;
        address client;
        string title;
        string description;
    }
    
    struct Payment {
        uint id;
        uint proposalId;
        address client;
        uint amount;
        uint date;
        uint paymentDate;
    }

    Payment[] public payments;
    Proposal[] public proposals;

    function addPayment(uint proposalId, uint _amount, uint _date, uint _paymentDate) internal {
        Payment memory payment = Payment(payments.length, proposalId, proposals[proposalId].client, _amount, _date, _paymentDate);
        payments.push(payment);
        proposals[proposalId].paymentCount++;
    }

    function paymentsFor(uint _proposalId) public view returns (Payment[] memory) {
        Payment[] memory paymentsFor = new Payment[](ownerToProposalCount[_proposer]);
        uint counter = 0;
        for (uint i = 0; i <= proposalIds; i++) {
            if (proposals[i].proposer == _proposer) {
                proposalsBy[counter] = proposals[i];
                counter++;
            }
        }
        return proposalsBy;
    }   

    function makePayment(uint proposalId, uint _paymentId, uint _date) public payable {
        require(proposals[proposalId].client == msg.sender, 'payment not yours');
        require(payments[_paymentId].paymentDate == 0, 'Payment already made');
        require(payments[_paymentId].amount == msg.value, 'Payment amount is not correct');
        payments[_paymentId].paymentDate = _date;
        payable(proposals[proposalId].proposer).transfer(msg.value);
    }

}