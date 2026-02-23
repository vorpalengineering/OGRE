// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../src/OGREMarket.sol";
import "./sample/SampleERC721.sol";
import "./sample/SampleERC20.sol";
import "./sample/BadERC20.sol";
import {IOGREMarket} from "../src/interfaces/IOGREMarket.sol";

contract OGREMarketTest is Test {
    address admin;
    address seller;
    address buyer;

    SampleERC721 nftContract;
    SampleERC20 erc20Contract;
    BadERC20 badErc20Contract;
    OGREMarket marketContract;

    uint256 orderFee = 0;
    address feeRecipient;

    function setUp() public {
        admin = makeAddr("admin");
        seller = makeAddr("seller");
        buyer = makeAddr("buyer");
        feeRecipient = makeAddr("feeRecipient");

        nftContract = new SampleERC721("Test NFTs", "TEST");
        erc20Contract = new SampleERC20("Test Token", "TKN", admin);
        badErc20Contract = new BadERC20("Bad Token", "BAD");

        // Mint NFT #0 to seller
        nftContract.mint(seller, 0);

        // Mint ERC20 to buyer
        vm.prank(admin);
        erc20Contract.mint(buyer, 1000);

        // Mint BadERC20 to buyer
        badErc20Contract.mint(buyer, 1000);
    }

    function _deployMarket(address erc20Addr) internal returns (OGREMarket) {
        vm.startPrank(admin);
        OGREMarket mkt = new OGREMarket(address(0), admin, orderFee, feeRecipient);
        mkt.setContractAllowed(address(nftContract), true);
        mkt.setContractAllowed(erc20Addr, true);
        vm.stopPrank();

        return mkt;
    }

    function test_FulfillOrder_SafeTransfer() public {
        marketContract = _deployMarket(address(erc20Contract));
        uint256 price = 100;

        // Seller approves market for NFT
        vm.prank(seller);
        nftContract.approve(address(marketContract), 0);

        // Seller creates ASK
        vm.prank(seller);
        marketContract.createOrder(IOGREMarket.OrderType.ASK, address(nftContract), 0, address(erc20Contract), price);

        // Buyer approves market for ERC20
        vm.prank(buyer);
        erc20Contract.approve(address(marketContract), price);

        // Buyer creates matching BID to fulfill
        vm.prank(buyer);
        marketContract.createOrder(IOGREMarket.OrderType.BID, address(nftContract), 0, address(erc20Contract), price);

        // Verify transfers
        assertEq(nftContract.ownerOf(0), buyer);
        assertEq(erc20Contract.balanceOf(seller), price);
        assertEq(erc20Contract.balanceOf(buyer), 1000 - price);
    }

    function test_RevertIf_ERC20TransferFails() public {
        marketContract = _deployMarket(address(badErc20Contract));
        uint256 price = 100;

        // Seller approves market for NFT
        vm.prank(seller);
        nftContract.approve(address(marketContract), 0);

        // Seller creates ASK
        vm.prank(seller);
        marketContract.createOrder(IOGREMarket.OrderType.ASK, address(nftContract), 0, address(badErc20Contract), price);

        // Buyer approves market for BadERC20
        vm.prank(buyer);
        badErc20Contract.approve(address(marketContract), price);

        // Set BadERC20 to return false on transfers
        badErc20Contract.setShouldFailTransfer(true);

        // Buyer creates matching BID — should revert because safeTransferFrom catches the false return
        vm.prank(buyer);
        vm.expectRevert();
        marketContract.createOrder(IOGREMarket.OrderType.BID, address(nftContract), 0, address(badErc20Contract), price);

        // Verify NFT stayed with seller
        assertEq(nftContract.ownerOf(0), seller);
    }
}
