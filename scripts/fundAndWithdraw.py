from os import access
from brownie import FundMe
from scripts.helpfulScripts import getAccount


def fund():
    print(f"Hey !! {FundMe[-1]}")
    fund_me = FundMe[-1]
    account = getAccount()
    entranceFee = fund_me.getEntrancePrice()
    tx = fund_me.Fund({"from": account, "value": entranceFee})
    tx.wait(1)
    print(fund_me.funders(account.address))


def withDraw():
    fund_me = FundMe[-1]
    account = getAccount()
    # tx = fund_me.withDraw({"from": account})
    # tx.wait(1)
    print(fund_me.funders(account.address))


def main():
    fund()
    withDraw()
