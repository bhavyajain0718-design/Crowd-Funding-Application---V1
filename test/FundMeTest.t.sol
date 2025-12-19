//SPDX-License-Identifier:MIT
pragma solidity ^0.8.30;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {Script} from "forge-std/Script.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test{


    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant GAS_PRICE =1;


    function setUp() external{
        vm.deal(USER,SEND_VALUE);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    modifier funded(){
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testMinUSD() external{
        console.log(fundMe.MINUSD());
        assertEq(fundMe.MINUSD(),5e18);
    }

    function testIsOwner() external{
        console.log(fundMe.i_owner());
        console.log(msg.sender);
        assertEq(fundMe.i_owner(),msg.sender);
    }

    function testGetVersion() external {
        console.log(fundMe.getVersion());
        assertEq(fundMe.getVersion(),4);
    }

    function testRevertFund() external{
        vm.expectRevert();
        fundMe.fund();
    }

    function testDataStructuresUpdated_funders() external{
        vm.prank(USER);
        fundMe.fund{value : SEND_VALUE}();
        address funder_address = fundMe.getFunders(0);
        assertEq(funder_address,USER);
    }

    function testDataStructuresUpdated_mappings() external funded(){
        uint256 amount = fundMe.getMappings(USER);
        assertEq(amount,SEND_VALUE);
    }

    function testOnlyOwnerCanWithdraw() external funded(){
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdraw_SingleFunder() external funded(){
        uint256 startingOwnerBalance = fundMe.getOwnerBalance();
        uint256 startingContractBalance = address(fundMe).balance;

        hoax(fundMe.getOwner(),0 ether);
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwnerBalance();
        uint256 endingContractBalance = address(fundMe).balance;

        console.log(startingOwnerBalance);
        console.log(startingContractBalance);
        console.log(endingOwnerBalance);
        console.log(endingContractBalance);
        assertEq(startingContractBalance,endingOwnerBalance);
    }

    function testWithdraw_MultipleFunder() external{
        uint256 NumberOfFunders = 10;
        uint256 funders_index = 0;

        for(funders_index;funders_index < NumberOfFunders;funders_index++){
            hoax(address(uint160(NumberOfFunders)),SEND_VALUE);  // UINT256 <---> ADDRESS XX    UINT160 <---> ADDRESS (CORRECT)
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startGas = gasleft();
        vm.txGasPrice(GAS_PRICE);
        hoax(fundMe.getOwner(),0);
        fundMe.withdraw();
        uint256 endingOwnerBalance = fundMe.getOwnerBalance();
        uint256 endGas = gasleft();
        uint256 gasUsed = (startGas - endGas)*tx.gasprice;


        console.log(startGas);
        console.log(endGas);
        console.log(gasUsed);
        assertEq(endingOwnerBalance,SEND_VALUE*10);
    }

    function testCheaperWithdraw_MultipleFunder() external{
        uint256 NumberOfFunders = 10;
        uint256 funders_index = 0;

        for(funders_index;funders_index < NumberOfFunders;funders_index++){
            hoax(address(uint160(NumberOfFunders)),SEND_VALUE);  // UINT256 <---> ADDRESS XX    UINT160 <---> ADDRESS (CORRECT)
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startGas = gasleft();
        vm.txGasPrice(GAS_PRICE);
        hoax(fundMe.getOwner(),0);
        fundMe.CheaperWithdraw();
        uint256 endingOwnerBalance = fundMe.getOwnerBalance();
        uint256 endGas = gasleft();
        uint256 gasUsed = (startGas - endGas)*tx.gasprice;


        console.log(startGas);
        console.log(endGas);
        console.log(gasUsed);
        assertEq(endingOwnerBalance,SEND_VALUE*10);
    }



}