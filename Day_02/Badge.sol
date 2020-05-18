pragma solidity ^0.5.0;

import "./ERC1155Full.sol";

contract Badge is ERC1155 {
    address public owner;

    string[] public badges;

    mapping(string => bool) _badgeExists;
    mapping(address => bool) public _canCreate;
    mapping(uint256 => address) public _tokenCreators;

    constructor() public {
        // set owner of contract
        owner = msg.sender;
        // add owner as creator
        _canCreate[msg.sender] = true;
    }

    modifier _ownerOnly() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    modifier _creatorOnly() {
        require(_canCreate[msg.sender], "You are not a creator");
        _;
    }

    modifier _tokenCreatorOnly(uint256 _id) {
        require(_tokenCreators[_id] == msg.sender);
        _;
    }

    function addCreator(address _address) external _ownerOnly() {
        _canCreate[_address] = true;
    }

    function removeCreator(address _address) external _ownerOnly() {
        _canCreate[_address] = false;
    }

    // Creates a new token type and assings _initialSupply to minter
    function create(string calldata _badge) external _creatorOnly() returns (uint tokenId)  {
        require(!_badgeExists[_badge]);

        // FIXED supply for now
        uint _initialSupply = 10;
        uint _id = badges.push(_badge);

        _tokenCreators[_id] = msg.sender;
        balances[_id][msg.sender] = _initialSupply;

        // Transfer event with mint semantic
        emit TransferSingle(msg.sender, address(0x0), msg.sender, _id, _initialSupply);
        _badgeExists[_badge] = true;
        return _id;
    }

    function mint(uint256 _id, address _to, uint256 _quantity) external _tokenCreatorOnly(_id) {
        // Grant the items to the caller
        balances[_id][_to] = _quantity.add(balances[_id][_to]);

        // Emit the Transfer/Mint event.
        // the 0x0 source address implies a mint
        // It will also provide the circulating supply info.
        emit TransferSingle(msg.sender, address(0x0), _to, _id, _quantity);

        if (_to.isContract()) {
            _doSafeTransferAcceptanceCheck(msg.sender, msg.sender, _to, _id, _quantity, '');
        }
    }

    function setURI(string calldata _uri, uint256 _id) external _tokenCreatorOnly(_id) {
        emit URI(_uri, _id);
    }


    function getTotalSupply() public view returns (uint) {
        return badges.length;
    }

    function canCreateToken() public view returns (bool) {
        return _canCreate[msg.sender];
    }

}