//SPDX-License-Identifier:MIT
pragma solidity 0.8.10;

import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract MarketInteractions {

    address payable owner;

    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable POOL;

    address private linkAddress = 0xe9c4393a23246293a8D31BF7ab68c17d4CF90A29;

    IERC20 private link;

    constructor(address _addressProvider,address _tokenAddress) {
        ADDRESSES_PROVIDER = IPoolAddressesProvider(_addressProvider);

        //getting instance of pool
        POOL = IPool(ADDRESSES_PROVIDER.getPool());

        owner = payable(msg.sender);
        _tokenAddress = linkAddress;
        link = IERC20(_tokenAddress);
        
    }

    function setNewTokenAddress(address _tokenAddress) external {
        linkAddress = _tokenAddress;
    }

    function getTokenAddress() external view returns(address){
        return linkAddress;
    }

    function supplyLiquidity(address _tokenAddress,uint256 _amount) external{
        address asset = _tokenAddress;
        uint256 amount = _amount;
        address onBehalfOf = address(this);
        uint16 referralCode = 0;

        POOL.supply(asset,amount,onBehalfOf,referralCode);
    }

    function withdrawLiquidty(address _tokenAddress,uint256 _amount) external returns(uint256){
        address asset = _tokenAddress;
        uint256 amount = _amount;
        address to = address(this);

        return POOL.withdraw(asset,amount,to);
    }

    function getUserAccountData(address _userAddress)
    external
    view
    returns(
        uint256 totalCollateralBase,
        uint256 totalDebtBase,
        uint256 availableBorrowBase,
        uint256 currentLiquidationThreshold,
        uint256 ltv,
        uint256 healthFactor
    ){
        return POOL.getUserAccountData(_userAddress);
    }

    function approveLINK(uint256 _amount,address _poolContractAddress)
    external
    returns(bool){
        return link.approve(_poolContractAddress,_amount);
    }

    function allowanceLINK(address _poolContractAddress)
    external
    view returns(uint256){
        return link.allowance(address(this),_poolContractAddress);
    }

    function getBalance(address _tokenAddress) external view returns(uint256){
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function withdraw(address _tokenAddress) external onlyOwner{
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender,token.balanceOf(address(this)));
    }

    modifier onlyOwner {
        require(msg.sender == owner,"Only owner can call this function");
        _;
    }

    receive() external payable{}
}