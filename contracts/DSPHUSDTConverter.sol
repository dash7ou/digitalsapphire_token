// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract DSPHUSDTConverter is Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    ERC20 public dsph;
    ERC20 public usdt;

    uint256 public convertPrice; // price in wei
    uint256 public minBuyPrice; // price in wei
    // uint256 public maxBuyPrice; // price in wei
    uint256 public numberOfDSPHBought;
    uint256 public numberOfUSDTSold;
    Counters.Counter public numberOfUserSellToken;
    address[] public usersSoldToken;
    bool public privateSaleAvalible = false;
    mapping(address => uint256) public addressToDSPHBoughtBalance;
    mapping(address => uint256) public addressToUSDTSoldBalance;

    event ChangeAvailability(bool available);

    // check if private sale is avalible
    modifier checkPrivateSaleAvailability() {
        require(privateSaleAvalible == true, "Private sale not avalible now.");
        _;
    }

    constructor(address payable _dsphTokenAddress, address payable _usdtTokenAddress) {
        convertPrice = 0.02 ether; // usdt
        minBuyPrice = 50 ether; // dsph
        // maxBuyPrice = 50 ether; // dsph
        dsph = ERC20(_dsphTokenAddress);
        usdt = ERC20(_usdtTokenAddress);
    }

    // fall back to recieve ether directly to this contract when has body msg
    fallback() external payable {}

    // recieve ether directly when does not body msg
    receive() external payable {}

    function updateConvertPrice(uint256 price) public onlyOwner {
        // price in wei
        convertPrice = price;
    }

    function updateMinBuyPrice(uint256 price) public onlyOwner {
        // price in wei
        minBuyPrice = price;
    }


        function tokenPrivateSaleStart() public onlyOwner {
        privateSaleAvalible = true;
        emit ChangeAvailability(true);
    }

    function tokenPrivateSaleEnd() public onlyOwner {
        privateSaleAvalible = false;
        emit ChangeAvailability(false);
    }

    // get contract usdt balance
    function getContractUSDTBalance() public view returns (uint256){
        return usdt.balanceOf(address(this));
    }

    // get contract dsph balance
    function getContractDSPHBalance() public view returns (uint256){
        return dsph.balanceOf(address(this));
    }

    // send contract usdt balance to owner
    function withdrawalUSDTBalanceToOwner() public onlyOwner {
        uint256 contractBalance = getContractUSDTBalance();
        usdt.transfer(owner(), contractBalance);
    }

    // send contract dsph balance to owner
    function withdrawalDSPHBalanceToOwner() public onlyOwner {
        uint256 contractBalance = getContractDSPHBalance();
        dsph.transfer(owner(), contractBalance);
    }

    // conver function
    function convertDSPHToUSDT(uint tokenAmount) public {
        uint256 dsphDecimals = uint256(dsph.decimals());
        uint256 usdtDecimals = uint256(usdt.decimals());

        uint256 amountToConvert = tokenAmount * (10 ** dsphDecimals);
        require(dsph.transferFrom(msg.sender, address(this), amountToConvert), "Token transfer failed");
        uint256 amountToSend = (tokenAmount * convertPrice) * (10 ** usdtDecimals);
        require(usdt.transfer(msg.sender, amountToSend), "USDT transfer failed");
    }
}