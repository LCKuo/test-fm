from brownie import network, accounts, config
from brownie import MockV3Aggregator
from web3 import Web3

DECIMAL = 8
STARTPRICE = 2000

FORKED_LOACL_ENVIROMENT = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_BLOCKCHAIN_ENVIROMENT = ["development", "ganache"]


def getAccount():
    if (
        network.show_active() in LOCAL_BLOCKCHAIN_ENVIROMENT
        or network.show_active() in FORKED_LOACL_ENVIROMENT
    ):
        return accounts[0]
    else:
        return config["wallet"]["from_key"]


def deploy_Mock():
    print(f"The network is {network.show_active()}")
    print("Depolying mocks ...")
    MockV3Aggregator.deploy(
        DECIMAL, Web3.toWei(STARTPRICE, "ether"), {"from": getAccount()}
    )
