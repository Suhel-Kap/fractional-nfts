// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {FractionalNFT} from "../src/FractionalNFT.sol";
import {LicenseNFT} from "../src/LicenseNFT.sol";
import {MyUSDC} from "../src/MyUSDC.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NftSaleTest is Test {
    FractionalNFT public fractionalNft;
    LicenseNFT public licenseNft;
    MyUSDC public usdc;
    uint256 public constant FRACTIONS = 10;
    uint256 public constant LICENSE_PRICE = 500; // needs to be multiplied by usdc.decimals()
    uint256 public constant FRACTION_PRICE = 50; // needs to be multiplied by usdc.decimals()
    uint256 public constant PLATFORM_FEE = 200000;
    uint256 public constant TOTAL_LICENSE_NFT = 500;
    uint256 public constant TOTAL_FRACTION_NFT = 5000;
    address public owner = address(1);

    function setUp() public {
        vm.startPrank(owner);
        usdc = new MyUSDC();
        licenseNft = new LicenseNFT(
            usdc,
            FRACTIONS,
            LICENSE_PRICE * 10 ** usdc.decimals(),
            TOTAL_LICENSE_NFT
        );
        fractionalNft = new FractionalNFT(
            usdc,
            licenseNft,
            PLATFORM_FEE,
            FRACTION_PRICE * 10 ** usdc.decimals(),
            TOTAL_FRACTION_NFT
        );
        licenseNft.setFractionalNft(fractionalNft);
        vm.stopPrank();
    }

    function test_mintAddressZero() public {
        address buyer = address(123);
        vm.prank(buyer);
        vm.expectRevert("Zero address not allowed");
        fractionalNft.mint(address(0), 1);
    }

    function test_mintQuantityZero() public {
        address buyer = address(123);
        vm.prank(buyer);
        vm.expectRevert("Quantity must be greater than 0");
        fractionalNft.mint(buyer, 0);
    }

    function test_mintNoUsdc() public {
        address buyer = address(123);
        vm.prank(buyer);
        vm.expectRevert("Insufficient balance");
        fractionalNft.mint(buyer, 1);
    }

    function test_usdcNotApproved() public {
        address buyer = address(123);
        vm.startPrank(buyer);
        usdc.mint(buyer, LICENSE_PRICE * 10 ** usdc.decimals());
        console.log(usdc.balanceOf(buyer));
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientAllowance.selector,
                address(fractionalNft),
                0,
                FRACTION_PRICE * 10 ** usdc.decimals() + PLATFORM_FEE
            )
        );
        fractionalNft.mint(buyer, 1);
    }

    function test_buySingleFraction() public {
        address buyer = address(123);
        vm.startPrank(buyer);
        uint256 totalPriceOfOneFraction = FRACTION_PRICE *
            10 ** usdc.decimals() +
            PLATFORM_FEE;
        usdc.mint(buyer, totalPriceOfOneFraction);
        usdc.approve(address(fractionalNft), totalPriceOfOneFraction);
        fractionalNft.mint(buyer, 1);
        assertEq(usdc.balanceOf(buyer), 0);
        assertEq(
            usdc.balanceOf(address(fractionalNft)),
            totalPriceOfOneFraction
        );
        assertEq(fractionalNft.balanceOf(buyer), 1);
    }

    function test_buyMoreThanSupplyShouldRevert() public {
        address buyer = address(123);
        vm.startPrank(buyer);
        uint256 totalPriceOfOneFraction = FRACTION_PRICE *
            10 ** usdc.decimals() +
            PLATFORM_FEE;
        usdc.mint(buyer, totalPriceOfOneFraction * (TOTAL_FRACTION_NFT + 1));
        usdc.approve(
            address(fractionalNft),
            totalPriceOfOneFraction * (TOTAL_FRACTION_NFT + 1)
        );
        vm.expectRevert("Total supply reached");
        fractionalNft.mint(buyer, TOTAL_FRACTION_NFT + 1);
    }

    function test_buyOneLicenseNft() public {
        address buyer = address(123);
        vm.startPrank(buyer);
        uint256 totalPriceOfOneFraction = FRACTION_PRICE *
            10 ** usdc.decimals() +
            PLATFORM_FEE;
        usdc.mint(buyer, totalPriceOfOneFraction * 10);
        usdc.approve(address(fractionalNft), totalPriceOfOneFraction * 10);
        fractionalNft.mint(buyer, 10);
        assertEq(usdc.balanceOf(buyer), 0);
        assertEq(
            usdc.balanceOf(address(fractionalNft)),
            totalPriceOfOneFraction * 10
        );
        assertEq(fractionalNft.balanceOf(buyer), 10);
        vm.stopPrank();

        vm.startPrank(owner);
        uint256[10] memory fractions = [
            uint256(0),
            uint256(1),
            uint256(2),
            uint256(3),
            uint256(4),
            uint256(5),
            uint256(6),
            uint256(7),
            uint256(8),
            uint256(9)
        ];
        uint256 licenseTokenId = licenseNft.mint(fractions);
        assertEq(licenseNft.balanceOf(owner), 1);
        assertEq(licenseTokenId, 0);
    }

    function test_buyLicenseWithUsedFractionsShouldRevert() public {
        uint256[10] memory fractions = [
            uint256(0),
            uint256(1),
            uint256(2),
            uint256(3),
            uint256(4),
            uint256(5),
            uint256(6),
            uint256(7),
            uint256(8),
            uint256(9)
        ];
        test_buyOneLicenseNft();

        vm.expectRevert("Fraction already used");
        licenseNft.mint(fractions);
    }

    function test_buyLicenseWithInvalidFractionsShouldRevert() public {
        uint256[10] memory fractions = [
            uint256(10),
            uint256(11),
            uint256(12),
            uint256(13),
            uint256(14),
            uint256(15),
            uint256(16),
            uint256(17),
            uint256(18),
            uint256(19)
        ];
        test_buyOneLicenseNft();
        vm.expectRevert("Fraction does not exist");
        licenseNft.mint(fractions);
    }

    function test_mintLicenseShouldFailIfNoBalanceInFraction() public {
        address buyer = address(123);
        vm.startPrank(buyer);
        uint256 totalPriceOfOneFraction = FRACTION_PRICE *
            10 ** usdc.decimals() +
            PLATFORM_FEE;
        usdc.mint(buyer, totalPriceOfOneFraction * 10);
        usdc.approve(address(fractionalNft), totalPriceOfOneFraction * 10);
        fractionalNft.mint(buyer, 10);

        vm.startPrank(owner);
        uint256[10] memory fractions = [
            uint256(0),
            uint256(1),
            uint256(2),
            uint256(3),
            uint256(4),
            uint256(5),
            uint256(6),
            uint256(7),
            uint256(8),
            uint256(9)
        ];
        fractionalNft.withdrawPlatformFee(
            usdc.balanceOf(address(fractionalNft))
        );

        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientBalance.selector,
                address(fractionalNft),
                0,
                LICENSE_PRICE * 10 ** usdc.decimals()
            )
        );
        licenseNft.mint(fractions);
    }

    function test_burnFractionalNft() public {
        address buyer = address(123);
        vm.startPrank(buyer);
        uint256 totalPriceOfOneFraction = FRACTION_PRICE *
            10 ** usdc.decimals() +
            PLATFORM_FEE;
        usdc.mint(buyer, totalPriceOfOneFraction);
        usdc.approve(address(fractionalNft), totalPriceOfOneFraction);
        fractionalNft.mint(buyer, 1);
        assertEq(fractionalNft.balanceOf(buyer), 1);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                buyer
            )
        );
        fractionalNft.burn(0);
        assertEq(fractionalNft.balanceOf(buyer), 1);

        vm.startPrank(owner);
        fractionalNft.burn(0);
        assertEq(fractionalNft.balanceOf(buyer), 0);
    }
}
