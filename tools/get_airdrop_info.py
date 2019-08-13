#!/bin/python

address_list = open('airdrop_address.txt').read().split('\n')
print("address len %d "%len(address_list))
sa = ",".join( "\"%s\""%item for item in address_list)
print sa

open("airdrop_address.json", "wb").write("[%s]"%sa)

value_list = open('airdrop_value.txt').read().split('\n')
print("value len %d "%len(value_list))
va = ",".join(["\"%s"%item+"000000000000000000\"" for item in value_list])
print va
open("airdrop_value.json", "wb").write("[%s]"%va)