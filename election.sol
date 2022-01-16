pragma solidity ^0.4.21;

contract Election{
    struct Candidate{
        string name; //name of candidate
        uint numVotes; //num of votes
    }

    struct Voter{
        bool isAuthorized; //can they vote?
        bool hasVoted; //have they already voted?
        uint vote; //which candidate is voted for
    }

//--------------public state variables---------------------------
    address public owner; //owner of the contract
    string public electionName; //name of election
    string public winner ="Voting in Progress.";

    mapping(address => Voter) public voters; //dictionary mapping address to Voter

    Candidate[] public candidates; //array to hold the names of candidates
    uint public totalVotes; //int to store total num of votes

//--------------modifiers---------------------------------------

    modifier isOwner() {
        require(msg.sender == owner); //only run the _; code if the message sender is the owner of contract
        _;
    }

//-------------methods--------------------------------------------

    function Election(string _name) public{
        owner = msg.sender; //address of the deployer
        electionName = _name; //set election name to parameter
    }

    function addCandidate(string _name) isOwner public{ //adds candidate
        candidates.push(Candidate(_name, 0)); //create new candidate with name and 0 votes
    }

    function numOfCandidates() public view returns(uint){ //returns num of candidates
        return candidates.length;
    }

    function authorizeUser(address _person) isOwner public{ //authorizes a user to vote 
        voters[_person].isAuthorized = true;
    }

    function vote(uint _voteIndex) public{
        require(!voters[msg.sender].hasVoted); //if the voter hasnt voted
        require(voters[msg.sender].isAuthorized); //if the voter is authorized

        voters[msg.sender].vote = _voteIndex; 
        voters[msg.sender].hasVoted = true;

        candidates[_voteIndex].numVotes +=1;
        totalVotes+=1;
    }
    function winningCandidate() public view returns (uint _winningCandidate) {

        uint winningVoteCount = 0;
        uint winningCandidateIndex = 9999;
        uint i;
        for ( i=0; i < numOfCandidates(); i++) {
            if (candidates[i].numVotes > winningVoteCount) {
                winningVoteCount = candidates[i].numVotes;
                winningCandidateIndex = i;
            }
            else if (candidates[i].numVotes == winningVoteCount && i!=winningCandidateIndex ){
               winningCandidateIndex = 9999;//Candidate 9999 is winning, meaning that there is a tie between 2 candidates
            }
        }
        _winningCandidate = winningCandidateIndex;

    }
    

    function endElection() isOwner public{
        uint winningCandidateIndex = winningCandidate();
        if (winningCandidateIndex == 9999){
            winner = "It's a tie!";
        }
        else {
            winner = candidates[winningCandidateIndex].name;
        }
    }

}