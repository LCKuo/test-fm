from brownie import FundMe, MockV3Aggregator, network, config
from eth_utils import address
from scripts.helpfulScripts import getAccount, deploy_Mock, LOCAL_BLOCKCHAIN_ENVIROMENT


def deploy_fund_me():
    print(network.show_active())
    account = getAccount()
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIROMENT:
        priceFeedAddress = config["networks"]["rinkeby"]["eth_usd_priceFeed"]
    else:
        if len(MockV3Aggregator) <= 0:
            deploy_Mock()
        priceFeedAddress = MockV3Aggregator[-1].address
        print(f"Mock deploy at : {priceFeedAddress}")

    fundMe = FundMe.deploy(
        priceFeedAddress,
        {"from": account},
        publish_source=config["networks"][network.show_active()].get("verify"),
    )
    print(fundMe)


def main():
    deploy_fund_me()
