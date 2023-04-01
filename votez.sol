
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract DecentralizedVotingMachine {

    //Structure to store voter information
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    //Structure to store proposal information
    struct Proposal {
        string proposalName;
        uint voteCount;
    }

    //The owner of the contract
    address public owner;

    //The mapping to store voters
    mapping(address => Voter) public voters;

    //The list of proposals
    Proposal[] public proposals;

    //Modifiers to restrict certain functions to the contract owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    //Events to log voter and proposal registration and voting
    event VoterRegistered(address voter);
    event ProposalRegistered(uint proposalId);
    event Voted(address voter, uint proposalId);

    //Constructor to set the owner of the contract
    constructor() {
        owner = msg.sender;
    }

    //Function to register voters
    function registerVoter(address _voterAddress) public onlyOwner {
        require(!voters[_voterAddress].isRegistered, "Voter already registered");
        voters[_voterAddress].isRegistered = true;
        emit VoterRegistered(_voterAddress);
    }

    //Function to register proposals
    function registerProposal(string memory _proposalName) public onlyOwner {
        proposals.push(Proposal(_proposalName, 0));
        emit ProposalRegistered(proposals.length - 1);
    }

    //Function to cast vote
    function vote(uint _proposalId) public {
        require(voters[msg.sender].isRegistered, "You are not a registered voter");
        require(!voters[msg.sender].hasVoted, "You have already voted");
        require(_proposalId < proposals.length && _proposalId >= 0, "Invalid proposal ID");
        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedProposalId = _proposalId;
        proposals[_proposalId].voteCount++;
        emit Voted(msg.sender, _proposalId);
    }

    //Function to get the proposal details
    function getProposal(uint _proposalId) public view returns (string memory proposalName, uint voteCount) {
        require(_proposalId < proposals.length && _proposalId >= 0, "Invalid proposal ID");
        Proposal memory p = proposals[_proposalId];
        return (p.proposalName, p.voteCount);
    }
}
