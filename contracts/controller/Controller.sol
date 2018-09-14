pragma solidity 0.4.24;


import "../utils/OwnableContract.sol";
import "../utils/OwnableContractOwner.sol";
import "../controller/ControllerInterface.sol";
import "../token/WBTCInterface.sol";
import "../factory/MembersInterface.sol";


contract Controller is ControllerInterface, OwnableContract, OwnableContractOwner {

    WBTCInterface public token;
    MembersInterface public members;
    address public factory;

    constructor(WBTCInterface _token) public {
        require(_token != address(0), "invalid _tokens address");
        token = _token;
    }

    modifier onlyFactory() {
        require(msg.sender == factory, "sender not authorized for minting or burning.");
        _;
    }

    // setters
    event WBTCSet(WBTCInterface token);

    function setWBTC(WBTCInterface _token) external onlyOwner returns (bool) {
        require(_token != address(0), "invalid _token address");
        token = _token;
        emit WBTCSet(_token);
        return true;
    }

    event MembersSet(MembersInterface members);

    function setMembers(MembersInterface _members) external onlyOwner returns (bool) {
        require(_members != address(0), "invalid _members address");
        members = _members;
        emit MembersSet(members);
        return true;
    }

    event FactorySet(address factory);

    function setFactory(address _factory) external onlyOwner returns (bool) {
        require(_factory != address(0), "invalid _factory address");
        factory = _factory;
        emit FactorySet(factory);
        return true;
    }

    // only owner actions on token
    event Paused();

    function pause() external onlyOwner returns (bool) {
        token.pause();
        emit Paused();
        return true;
    }

    event Unpaused();

    function unpause() external onlyOwner returns (bool) {
        token.unpause();
        emit Unpaused();
        return true;
    }

    // only factory actions on token
    function mint(address to, uint amount) external onlyFactory returns (bool) {
        require(to != address(0), "bad address");
        require(token.mint(to, amount), "minting failed.");
        return true;
    }

    function burn(uint value) external onlyFactory returns (bool) {
        token.burn(value);
        return true;
    }

    // all accessible
    function isCustodian(address addr) external view returns (bool) {
        return members.isCustodian(addr);
    }

    function isMerchant(address addr) external view returns (bool) {
        return members.isMerchant(addr);
    }

    function getWBTC() external view returns (WBTCInterface) {
        return token;
    }
}
