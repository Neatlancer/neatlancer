pragma solidity ^0.8.4;
// SPDX-License-Identifier: MIT

import "./ProposalBase.sol";

contract ProposalManager is ProposalBase {

    struct PaymentSchedule {
        uint paymentDate;
        uint amount;
        uint32 status;
    }

    uint public proposalIds = 0;
    mapping(address => uint) public ownerToProposalCount;

    function createProposal(uint _date, address _client, string memory _title, string memory _description, PaymentSchedule[] memory _paymentSchedule) public {
        uint proposalId = proposalIds;
        Proposal memory proposal = Proposal(proposalId, _date, 0, msg.sender, _client, _title, _description);
        proposals.push(proposal);
        proposalIds++;
        ownerToProposalCount[msg.sender]++;

        for (uint256 index = 0; index < _paymentSchedule.length; index++) {
            addPayment(proposalId, _paymentSchedule[index].amount, _paymentSchedule[index].paymentDate, 0);
        }

    }

    function getProposalsBy(address _proposer) public view returns (Proposal[] memory) {
        Proposal[] memory proposalsBy = new Proposal[](ownerToProposalCount[_proposer]);
        uint counter = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].proposer == _proposer) {
                proposalsBy[counter] = proposals[i];
                counter++;
            }
        }
        return proposalsBy;
    }   
}