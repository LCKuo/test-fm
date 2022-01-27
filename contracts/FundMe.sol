//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface AggregatorV3Interface {
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

    // getRoundData and latestRoundData should both raise "No data present"
    // if they do not have data to report, instead of returning unset values
    // which could be misinterpreted as actual reported values.

    function getRoundData(uint80 _roundId)
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

contract FundMe {
    mapping(address => uint256) public funders;
    address public owner;
    AggregatorV3Interface public coinInf;

    constructor(address _feedPrice) {
        coinInf = AggregatorV3Interface(_feedPrice);
        owner = msg.sender;
    }

    address[] public fundersArray;

    function Fund() public payable {
        uint256 miniAsd = 50 * (10**18);
        require(getConverted(msg.value) >= miniAsd, "you shall not pass");
        funders[msg.sender] += msg.value;
        fundersArray.push(msg.sender);
    }

    function version() external view returns (uint256) {
        return coinInf.version();
    }

    function decimal() external view returns (uint256) {
        return coinInf.decimals();
    }

    function getPrice() public view returns (uint256) {
        (, int256 answer, , , ) = coinInf.latestRoundData();
        return uint256(answer * (10**10));
    }

    function getDescription() public view returns (string memory) {
        return coinInf.description();
    }

    function getConverted(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / (10**18);
        return ethAmountInUsd;
    }

    function withDraw() public payable {
        payable(msg.sender).transfer(funders[msg.sender]);
    }

    function revielFund() public view returns (uint256) {
        return funders[msg.sender] / 10**18;
    }

    modifier onlyOner() {
        require(msg.sender == owner);
        _;
    }

    function doStuffByOnerOnly() public payable onlyOner {
        payable(msg.sender).transfer(address(this).balance);
        for (uint256 i = 0; i < fundersArray.length; i++) {
            funders[fundersArray[i]] = 0;
        }
        fundersArray = new address[](0);
    }

    function showContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getEntrancePrice() public view returns (uint256) {
        uint256 minimumUSD = 50 * 10**18;
        uint256 price = getPrice();
        uint256 pricision = 1 * 10**18;
        return (minimumUSD * pricision) / price;
    }
}
