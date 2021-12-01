 pragma solidity ^0.6.7;

import "@chainlink/contracts/v0.6/ChainlinkClient.sol";

contract LuxFi is ChainlinkClient {
  
  uint256 oraclePayment;
  
  constructor(uint256 _oraclePayment) public {
    setPublicChainlinkToken();
    oraclePayment = _oraclePayment;
  }
  // Additional functions here:
  
}