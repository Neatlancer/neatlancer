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

    struct PaymentSchedule {
        uint paymentDate;
        uint amount;
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


    function createProposal(uint _date, address _client, string memory _title, string memory _description, PaymentSchedule[] memory _paymentSchedule) public {
        uint id = proposals.length;
        Proposal memory proposal = Proposal(
            id, 
            _date, 
            msg.sender, 
            _client, 
            _title, 
            _description
        );
        proposals.push(proposal);
        for (uint256 index = 0; index < _paymentSchedule.length; index++) {
            payments.push(Payments(
                payments.length, 
                id, 
                _client, 
                _paymentSchedule[index].amount, 
                _paymentSchedule[index].paymentDate, 
                0
            ));
        }
    }

    function addPayment(uint _paymentId, uint _date) public payable {
        require(payments[_paymentId].client == msg.sender, 'payment not yours');
        require(payments[_paymentId].paymentDate == 0, 'Payment already made');
        require(payments[_paymentId].amount == msg.value, 'Payment amount is not correct');
        payments[_paymentId].paymentDate = _date;
        payable(proposals[payments[_paymentId].proposalId].proposer).transfer(msg.value);
    }

    function paymentsFor(uint _proposalId) public view returns (uint) {
        uint count = 0;
        for (uint i = 0; i < payments.length; i++) {
            if (payments[i].proposalId == _proposalId) {
                count++;
            }
        }
        return count;
    }

    function paymentsOf(uint _proposalId, address _client) public view returns (uint) {
        uint count = 0;
        for (uint i = 0; i < payments.length; i++) {
            if (payments[i].proposalId == _proposalId && payments[i].client == _client) {
                count++;
            }
        }
        return count;
    }
}