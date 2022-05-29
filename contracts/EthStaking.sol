// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EthStaking {
    address public walletAddress;
    IERC20 tokenERC20;
    mapping(address => uint256) private _stakeHolders;
    AggregatorV3Interface internal priceFeed;

    constructor(
        address erc20Token
    ) {
        walletAddress = msg.sender;
        tokenERC20 = IERC20(erc20Token);
        priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
    }

    function stakeEth() public payable returns (uint256) {
        require( msg.value >= 5 ether, "Stake value should be greater than 5 eth" );
        _stakeHolders[msg.sender] = msg.value;
        return msg.value;
    }

    function stakeholderStakes(address addr)
        public
        view
        returns (uint256 stakes)
    {
        return _stakeHolders[addr];
    }

    function getLatestPrice() public view returns (uint256) {
        (
            uint80 roundID,
            int256 price,
            uint256 startedAt,
            uint256 timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();

        return uint256(price);
    }

    function calculateRewards(address addr) public view returns (uint256) {
        uint256 price = (((getLatestPrice() * _stakeHolders[addr]) * 5) / 100) / ( 100000000 );
        return price;
    }

    function unstake ( ) public payable {
        uint256 rewardValue = calculateRewards(msg.sender);
        uint256 ethAmount = _stakeHolders[msg.sender];

        tokenERC20.transferFrom( walletAddress, msg.sender, rewardValue );
        payable(msg.sender).transfer(ethAmount);

        _stakeHolders[msg.sender] = 0;

    }
}
