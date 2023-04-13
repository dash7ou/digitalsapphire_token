// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract DSPHPrivateSale is Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    ERC20 public openergy;
    uint256 private _privateSellPrice; // price in wei
    uint256 private _minBuyPrice; // price in wei
    uint256 private _maxBuyPrice; // price in wei
    uint256 public numberOfTokensBought;
    uint256 public persentageOfSendTokenEveryTime;
    Counters.Counter private _numberOfUserBoughtToken;
    address[] public userBoughtToken;
    bool public privateSaleAvalible = false;
    uint256 public privateSaleStartDate;
    uint256 public privateSaleEndDate;
    mapping(address => uint256) public addressToTokenBalance;
    mapping(address => uint256) public addressToTokenBalanceSent;

    event BuyDSPH(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SendDSPH(
        address buyer,
        uint256 mainBalance,
        uint256 balanceAlreadyReceived,
        uint256 amountOfTokens
    );
    event ChangeAvailability(bool available);

    // check if private sale is avalible
    modifier checkPrivateSaleAvailability() {
        require(privateSaleAvalible == true, "Private sale not avalible now.");
        _;
    }

    constructor(address payable _dsphTokenAddress) {
        _privateSellPrice = 0.00000283 ether;
        _minBuyPrice = 0.066 ether;
        _maxBuyPrice = 50 ether;
        openergy = ERC20(_dsphTokenAddress);
        // 2000 basic points = 20 pct
        persentageOfSendTokenEveryTime = 2000;
    }

    // fall back to recieve ether directly to this contract when has body msg
    fallback() external payable {}

    // recieve ether directly when does not body msg
    receive() external payable {}

    // send contract stored in contract to the owner
    function sendContractBalanceToOwner() external payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function getPrivateSellPrice() public view returns (uint256) {
        // price in wei
        return _privateSellPrice;
    }

    function updatePrivateSellPrice(uint256 price) public onlyOwner {
        // price in wei
        _privateSellPrice = price;
    }

    function getMinBuyPrice() public view returns (uint256) {
        // price in wei
        return _minBuyPrice;
    }

    function updateMinBuyPrice(uint256 price) public onlyOwner {
        // price in wei
        _minBuyPrice = price;
    }

    function getMaxBuyPrice() public view returns (uint256) {
        // price in wei
        return _maxBuyPrice;
    }

    function updateMaxBuyPrice(uint256 price) public onlyOwner {
        // price in wei
        _maxBuyPrice = price;
    }

    function tokenPrivateSaleStart() public onlyOwner {
        privateSaleAvalible = true;
        privateSaleStartDate = block.timestamp;
        emit ChangeAvailability(true);
    }

    function tokenPrivateSaleEnd() public onlyOwner {
        privateSaleAvalible = false;
        privateSaleEndDate = block.timestamp;
        emit ChangeAvailability(false);
    }

    // need to be in 10**18
    function getValueForAmountofToken(
        uint256 _amountOftoken
    ) public view returns (uint256) {
        return (_amountOftoken * persentageOfSendTokenEveryTime) / 10000;
    }

    function getNumberOfUserBoughtToken() public view returns (uint256) {
        return _numberOfUserBoughtToken.current();
    }

    function updatePersentageOfSendTokenEveryTime(
        uint256 _persentageOfSendTokenEveryTime
    ) public onlyOwner {
        require(_persentageOfSendTokenEveryTime < 10000, "Check value!");
        require(_persentageOfSendTokenEveryTime > 100, "Check value!");
        persentageOfSendTokenEveryTime = _persentageOfSendTokenEveryTime;
    }

    function getNumberOfTokenByPrice(
        uint256 price
    ) public view returns (uint256) {
        return (price / _privateSellPrice) * 10 ** 18;
    }

    function buyTokens() public payable checkPrivateSaleAvailability {
        // checks
        require(msg.value >= _minBuyPrice, "Increase price value!");
        require(msg.value <= _maxBuyPrice, "Decrease price value!");

        uint256 amountToBuy = getNumberOfTokenByPrice(msg.value);

        numberOfTokensBought += amountToBuy;
        if (addressToTokenBalance[msg.sender] == 0) {
            userBoughtToken.push(msg.sender);
            _numberOfUserBoughtToken.increment();
        }
        addressToTokenBalance[msg.sender] += amountToBuy;

        emit BuyDSPH(msg.sender, msg.value, amountToBuy);
    }

    function getTokenContractBalance() public view returns (uint256) {
        return openergy.balanceOf(address(this));
    }

    function withdrawalTokenBalanceToOwner() public onlyOwner {
        uint256 contractBalance = getTokenContractBalance();
        openergy.transfer(owner(), contractBalance);
    }

    function sendUsersTokens() public onlyOwner {
        for (uint256 i = 0; i < _numberOfUserBoughtToken.current(); i++) {
            address userAddress = userBoughtToken[i];
            uint256 mainUserBalance = addressToTokenBalance[userAddress];
            uint256 sentUserBalance = addressToTokenBalanceSent[userAddress];
            uint256 userBalance = mainUserBalance - sentUserBalance;

            uint256 balanceWillSendToUser = getValueForAmountofToken(
                mainUserBalance
            );
            if (
                balanceWillSendToUser <= userBalance &&
                balanceWillSendToUser > 0
            ) {
                uint256 contractBalance = getTokenContractBalance();
                // send token
                if (contractBalance >= balanceWillSendToUser) {
                    addressToTokenBalanceSent[
                        userAddress
                    ] += balanceWillSendToUser;
                    openergy.transfer(userAddress, balanceWillSendToUser);
                    emit SendDSPH(
                        userAddress,
                        mainUserBalance,
                        addressToTokenBalanceSent[userAddress],
                        balanceWillSendToUser
                    );
                }
            }
        }
    }
}
