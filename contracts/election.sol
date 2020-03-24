pragma solidity >=0.4.21 <0.7.0;
import "./erc721.sol";
import "./voteownership.sol";
import "./safemath.sol";

contract Election is ERC721, Ownable {
    using SafeMath for uint;
    // creation du model du candidat
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }
    // mapping de chaque candidat et de chaque voteur
    mapping(uint => Candidate) public candidates;
    mapping(address => uint) public votersBalance;
    mapping (uint => address) public voteToOwner;

    uint public candidatesCount; // Stoquer le nbre des condidats

    function addCandidate (string memory _name) private {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote (uint _candidateId) public {
        // require that they haven't voted before
        require(votersBalance[msg.sender] >0);
        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);
        // record that voter has voted
        votersBalance[msg.sender] = votersBalance[msg.sender].sub(1) ;

        // update candidate vote Count
        candidates[_candidateId].voteCount ++;
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return votersBalance[_owner];
    }
    
    function _transfer(address _from, address _to, uint256 _tokenId) private {
        votersBalance[_to] = votersBalance[_to].add(1);
        votersBalance[msg.sender] = votersBalance[msg.sender].sub(1);
        voteToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require (voteToOwner[_tokenId] == msg.sender);
        _transfer(_from, _to, _tokenId);
    }


    // Constructeur
    constructor() public{
        addCandidate("Candidate 1");
        
    }


}