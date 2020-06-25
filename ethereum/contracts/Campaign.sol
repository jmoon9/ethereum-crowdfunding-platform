// SPDX-License-Identifier: MIT
pragma solidity ^0.6.8;

contract CampaignFactory {
    address[] public deployedCampaigns;
    
    function createCampaign(uint minimum) public {
        address newCampaign = address(new Campaign(minimum, msg.sender));
        deployedCampaigns.push(newCampaign);
    }
    
    function getDeployedCampaigns() public view returns (address[] memory) {
        return deployedCampaigns;
    }
}

contract Campaign {
    struct Request {
        string description;     // Reason for request
        uint value;             // Amount to send to vendor
        address payable recipient;      // Address to be sent to
        bool complete;          // True if money has been sent
        uint approvalCount;     // Keeps track of yes votes
        mapping(address => bool) approvals;     // keeps track of contributors who have voted
    }
    
    address payable public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;      // mapping of contributor addresses
    uint public approversCount;                     // number of active contributors

    Request[] public requests;
    
    constructor(uint minimum, address payable creator) public {
        manager = creator;
        minimumContribution = minimum;
    }
    
    function contribute() public payable {
        require(
            msg.value > minimumContribution,
            "Contribution must exceed Campaign minimum to qualify as a contributor"
        );
        
        if(!approvers[msg.sender]) {
            approversCount++;
        }
        approvers[msg.sender] = true;
        
    }
    
    function createRequest(string memory description, uint value, address payable recipient) public restricted {
        // cant ask for more money than contract holds
        require(
            value <= address(this).balance,
            "Account does not contain enough funds to enable request"
        );
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount: 0
        });
        
        requests.push(newRequest);
    }
    
    function approveRequest(uint index) public {
        Request storage request = requests[index];
        
        require(
            approvers[msg.sender],
            "User not listed as Campaign contributor"
        );     
        require(
            !request.approvals[msg.sender],
            "User has previously voted on this request"
        );     // verifies person has not previously voted on this request
        
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }
    
    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];
        
        require(
            !request.complete,
            "Request has already been completed"
        );
        require(
            request.approvalCount > (approversCount / 2),
            "Request has not been approved"
        );
        
        request.recipient.transfer(request.value);
        request.complete = true;
    }

    function getSummary() public view returns(uint, uint, uint, uint, address) {
        return(
            minimumContribution,
            address(this).balance,
            requests.length,
            approversCount,
            manager
        );
    }

    function getRequestsCount() public view returns (uint){
        return requests.length;
    }
    
    modifier restricted {
        require(
            msg.sender == manager,
            "Only contract manager may access this functionality"
        );
        _;
    }
}

