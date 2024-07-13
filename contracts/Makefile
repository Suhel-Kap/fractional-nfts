.DEFAULT_GOAL := deploy

-include .env

deploy:
	@echo "Deploying contracts"
	@forge script --chain sepolia script/Nft.s.sol:NftScript --rpc-url $(SEPOLIA_RPC_URL) --broadcast --verify -vvvv

test_contracts:
	@echo "Running tests"
	@forge test --mc NftSaleTest
