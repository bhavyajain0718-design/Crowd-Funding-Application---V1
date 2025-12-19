build:; forge build
deploy_anvil:; forge script script/DeployFundMe.s.sol --rpc-url http://127.0.0.1:8545 --account Bhavya_wallet_1 --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --broadcast
test:; forge test
storage:; forge inspect FundMe storageLayout
deploy_sepolia:; forge script script/DeployFundMe.s.sol --rpc-url https://eth-sepolia.g.alchemy.com/v2/__RhVEWyYkPfML8YxbbTg --account Bhavya_Sepolia_wallet_2 --sender 0xC28bA97495A31B3859b9eB493E94a97013C2E033 --verify --etherscan-api-key 2Q7ZT69B7F5KM91DKYP793683RBZJZUWMX --broadcast