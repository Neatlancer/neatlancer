pragma solidity ^0.8.4;
// SPDX-License-Identifier: MIT

import "./Proposal.sol";

contract ProposalManager {

    struct PaymentSchedule {
        uint paymentDate;
        uint amount;
    }

    uint public proposalIds = 0;
    mapping (uint => address) public proposals;


    function createProposal(uint _date, address _client, string memory _title, string memory _description, PaymentSchedule[] memory _paymentSchedule) public {
        Proposal proposal = new Proposal(
            proposalIds, 
            _date, 
            msg.sender, 
            _client, 
            _title, 
            _description
        );
        proposals[proposalIds] = address(proposal);
        proposalIds++;

        for (uint256 index = 0; index < _paymentSchedule.length; index++) {
            proposal.addPayment( 
                _paymentSchedule[index].amount, 
                _paymentSchedule[index].paymentDate, 
                0
            );
        }
    }

    function makePayment(uint _proposalId, uint _paymentId, uint _date) public payable {
        Proposal proposal = Proposal(proposals[_proposalId]);
        uint amount;
        (,,,amount,,) = proposal.payments(_paymentId);
        require(amount == msg.value, 'Payment amount is not correct');
        proposal.makePayment(_paymentId, _date);
        payable(proposal.proposer()).transfer(msg.value);
    }
}