pragma solidity ^0.5.6;

import "./klaytn-contracts/ownership/Ownable.sol";
import "./klaytn-contracts/math/SafeMath.sol";
import "./interfaces/IKlaytnPax.sol";
import "./klaytn-contracts/token/KIP7/KIP7.sol";
import "./klaytn-contracts/token/KIP7/KIP7Metadata.sol";

contract KlaytnPax is Ownable, IKlaytnPax, KIP7, KIP7Metadata("CND Klaytn Pax", "KPAX", 18) {
    using SafeMath for uint256;

    address public signer;

    mapping(address => mapping(uint256 => mapping(address => uint256[]))) public sended;
    mapping(address => mapping(uint256 => mapping(address => mapping(uint256 => bool)))) public received;

    constructor(address _signer) public {
        signer = _signer;
    }

    function setSigner(address _signer) onlyOwner external {
        signer = _signer;
        emit SetSigner(_signer);
    }

    function sendOverHorizon(uint256 toChain, address receiver, uint256 amount) public returns (uint256) {
        _burn(msg.sender, amount);
        
        uint256[] storage sendedAmounts = sended[msg.sender][toChain][receiver];
        uint256 sendId = sendedAmounts.length;
        sendedAmounts.push(amount);
        
        emit SendOverHorizon(msg.sender, toChain, receiver, sendId, amount);
        return sendId;
    }

    function sendCount(address sender, uint256 toChain, address receiver) external view returns (uint256) {
        return sended[sender][toChain][receiver].length;
    }

    function receiveOverHorizon(uint256 fromChain, address sender, uint256 sendId, uint256 amount, bytes memory signature) public {

        require(signature.length == 65, "invalid signature length");
        require(!received[msg.sender][fromChain][sender][sendId]);

        uint256 toChain = 8217;
        bytes32 hash = keccak256(abi.encodePacked(msg.sender, fromChain, toChain, sender, sendId, amount));
        bytes32 message = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }

        require(
            uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
            "invalid signature 's' value"
        );
        require(v == 27 || v == 28, "invalid signature 'v' value");

        require(ecrecover(message, v, r, s) == signer);

        _mint(msg.sender, amount);

        received[msg.sender][fromChain][sender][sendId] = true;
        emit ReceiveOverHorizon(msg.sender, fromChain, sender, sendId, amount);
    }
}
