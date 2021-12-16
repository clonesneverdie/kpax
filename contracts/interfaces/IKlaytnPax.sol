pragma solidity ^0.5.6;

import "../klaytn-contracts/token/KIP7/IKIP7.sol";

interface IKlaytnPax {

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    event SetSigner(address indexed signer);
    event SendOverHorizon(address indexed sender, uint256 indexed toChain, address indexed receiver, uint256 sendId, uint256 amount);
    event ReceiveOverHorizon(address indexed receiver, uint256 indexed fromChain, address indexed sender, uint256 sendId, uint256 amount);

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    function signer() external view returns (address);
    function sendOverHorizon(uint256 toChain, address receiver, uint256 amount) external returns (uint256 sendId);
    function sended(address sender, uint256 toChain, address receiver, uint256 sendId) external view returns (uint256 amount);
    function sendCount(address sender, uint256 toChain, address receiver) external view returns (uint256);
    function receiveOverHorizon(uint256 fromChain, uint256 toChain, address sender, uint256 sendId, uint256 amount, bytes calldata signature) external;
    function received(address receiver, uint256 fromChain, address sender, uint256 sendId) external view returns (bool);
}
