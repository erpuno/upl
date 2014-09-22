Universal Processing Language
=============================

The objective of this project is to create small and compact
language for payment transaction processing. Underlying instrumentation
code should be KVS layer for storing transaction chains but
naturally should be extended to different backends like Java,
PL/SQL and other languages currently involved in banking card processing.

Pocessing systems are using manually crafted application
relays to handle card processing business rules. Being defined by business
analysts these rules are fallen down to engineering teams informally.
Approach we provide pushes card processing to solid background in a form
of domain specific language common for all card plans analytics departments.

Having compact language we can formally build various translators
for particular customers and existing processing systems. At the same time
we provide reference back-end Erlang system implementation
for transactions processing. Also DSL gives us a natural and easy
verification strategies and compactifications.

This language could be easily extended to other domain aread like
internet payment processing, shopping mall bonus programs, mobile
operators tariff plans.

Build
-----

Using MAD in PATH just perform make.

Events
------

```
initial-payment
last-payment
```

Components
----------

```
payment_direction = charge | withdraw
charge_rule = Fixed + Percent [ of amount (default)
                              | of debt 
                              | of credit 
                              | of deposit 
                              | of rate ]
```

Examples
--------

Moneybox

```
card "moneybox"
deposit duration range monthly 1 -> 20%
                       monthly 3 -> 22%
                       monthly 6 -> 22% of amount
                       annual -> 23% of amount
        partial widthdraw disabled
        charge enabled
        fee 15% account "TAX-001"
```

Deposit Plus

```
card "Deposit-Plus" UAH
deposit duration range monthly 1 -> 20%
                       monthly 3 -> 22%
                       monthly 6 -> 22%
                       annual -> 23%
        withdraw disabled
        auto
        charge enabled limit max 20000 monthly
        monthly 1% of amount to account "Bonus-Plus"
        final move from rate to deposit -- Capitalization
        fee 15% name "tax" account "users/maxim/accounts/TAX-001"
accounts deposit "users/maxim/accounts/MB-0001"
         rate "users/maxim/accounts/MB-0001-Percents"
```

Universal
```
card PB-UNIVERSAL UAH
limit 25K
grace-period 55 days
deposit duration range monthly 1 -> 20%
                       monthly 3 -> 22%
                       monthly 6 -> 22% of amount
                       annual -> 23% of amount
        partial 
        fee 15% name "tax" account "users/maxim/accounts/TAX-001"
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

Planitum

```
card M-PLA-CB UAH
limit unknown
grace duration range number 1 -> 100
                               _ 60 days
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

UPL TREE
--------

```erlang
    {card,6,
         {name,'Deposit_Plus'},
         {currency,'UAH'},
         [{deposit,
              [{duration,
                   [{monthly,{int,1},{fee,[],{charge,{percent,0.2}}}},
                    {monthly,{int,3},{fee,[],{charge,{percent,0.22}}}},
                    {monthly,
                        {int,6},
                        {fee,
                            [{account,"users/maxim/accounts/MB-0001-Percents"},
                             {name,[]}],
                            {charge,amount,{percent,0.22},undefined}}},
                    {annual,
                        {fee,[],{charge,amount,{percent,0.23},undefined}}}]},
               {withdraw,disabled},
               {auto},
               {charge,enabled,
                   {monthly,1,{fee,[],{limit,[{max,{int,20000}}]}}}},
               {monthly,1,
                   {fee,
                       [{account,"Bonus_Plus"},{name,[]}],
                       {charge,amount,{percent,0.01},undefined}}},
               {fee,17}]},
          {accounts,
              [{deposit,"users/maxim/accounts/MB-0001"},
               {rate,"users/maxim/accounts/MB-0001-Percents"}]}]}
```

Even for Investment Banking, Swap trade Sample:

```
instrument 'Stub_Amort_Swap'
parties name DB id PARTYAUS33 trade DB-0001
        name Barclays id BARCGB2L trade SW2000

stream pay Barclays rate 'EUR-LIBOR-BBA' monthly 6 of
       notional range 06/14/1995 50000000
                      12/14/1995 40000000
                      12/14/1996 30000000
                      12/14/1997 20000000
                      12/14/1998 10000000
       from 06/14/1995 to 12/14/1999 adjust MODFOLLOWING
       recalculate monthly 6 roll 14
       fraction 'ACT/360'
       calendar GBLO

stream pay DB rate 6% annual of
       notional range 06/14/1995 50000000
                      12/14/1995 40000000
                      12/14/1996 30000000
                      12/14/1997 20000000
                      12/14/1998 10000000
       recalculate annual roll 14
       calendar DEFR
       fraction '30E/360'

```

Credits
-------

* Maxim Sokhatsky

OM A HUM
