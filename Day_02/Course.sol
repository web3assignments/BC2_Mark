pragma solidity ^0.5.0;
import "./Chapter.sol";

contract Course {
  string public name;
  Chapter [] chapters;

  constructor(string memory _name) public {
    name = _name;
  }


}