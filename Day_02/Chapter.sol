pragma solidity ^0.5.0;
import "./Badge.sol";

contract Chapter {
  string public name;
  Badge [] badges;

  constructor(string memory _name) public {
    name = _name;
  }
}