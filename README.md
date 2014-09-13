Card Processing Language
========================

Objective. Create small and compact language for generation
erlang rules and database events for credit cards transaction processing.
Underlying instrumentation code should be KVS layer
for storing transaction chains.

Transactions
------------

```
account := { name, bank, number }
transaction := { beneficiary, subsidiary, transaction-type }
country-range := country Code [ | country-range ]
pos-terminal := pos [ ballance | source Name ]
cash-spec := pos-terminal | country-range | nil | cash-spec
wire-spec := target Name | type Name | nil | wire-spec
transaction-type :=   cashout [ cash-spec ]
                    | cashin [ cash-spec ]
                    | wire [ wire-spec]
card := name rules
grace-period [ days ] | first M days [ then N days ]
limit [ amount ]
delay [ days | formula ]
turn-off [ limit [ days | formula ] ] [ message ]
cash-back [ beneficiary | type | invoice ]
rate [ formula ]
fee [ transaction | month | annual | formula ]
bonus [ formula ]
accounts [ fee number | rate number | delay number ]
```

Events
------

```
initial-payment
last-payment
```

Components
----------

```
```

Examples
--------

```
card PB-UNIVERSAL UAH
limit 25K
grace-period 55 days
deposit annual 10% limit min 100
rate annual 40.90% of credit
penalty daily 50 + 5.8% of debt
fee month 5% of debt limit min 50 max debt
    transaction cashin 0
                cashout pos ballance 1
                        country UA 1%
                                 _ 2%
                cashout amount range      1,100 7
                                     100.01,200 12
                                     200.01,300 18
                                     300.01,400 24
                                     400,01,500 30
                                     500,01,_   4% of amount
    transaction wire target local 0
                     1% of amount or 10 + 4% of credit
                     target local type PB-UNIVERAL 0% of amount or 4% of credit
                     target local 0.5% of amount limit max 200 or 4% of credit
                     target _ 1% limit min 3 or 4% of credit
                     target _ type phone 2
accounts fee     PB-100001
         rate    PB-100002
         penalty PB-100003
```

```
card M-PLA-CB UAH
limit unknown
grace-period first 100 days then 60 days
penalty daily 100
        month add-rate 5%
currency convert 1%
rate month 4.9% of credit
fee month 12 once on initial-payment
    month 3% of debt limit min 50 max debt
    month 1.2% of debt
    month 24
    status disabled 10
    transaction cashin  0
                cashout pos ATMOSPHERA 0
                cashout contry UA 5 + 1.5%
                                _ 30 + 1%
                wire target local 0
                wire 0.5% of amount limit min 5 max 500
accounts fee     M-100001
         rate    M-100002
         penalty M-100003
```