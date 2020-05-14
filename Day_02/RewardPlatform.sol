pragma solidity ^0.5.0;

import "./Course.sol";

contract RewardPlatform {
  string public name;
  Course[] courses;

  mapping(address => bool) public _canCreate;

  constructor(string memory _name) public {
    name = _name;
  }

  modifier _creatorOnly() {
    require(_canCreate[msg.sender], "You are not a creator");
    _;
  }

  function createCourse() {

  }
}