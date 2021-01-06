@ *******************************************************
@ Date Created   : 27 June, 2019
@ Author         : :P
@ *******************************************************

1. Before you run the make commands, make sure you have sourced the .install file.
2. Next make sure you are setting the environment variable ( in this case $IP_AMBA_APB_MASTER_TOP ) before you start testing the IP.
3. This is a crude VIP, so any testing that will be done is very basic.
4. As of now there is no monitor or assertion checks or coverage or anythign like that of any sorts.

5. Adding a new feature where the logs are not define based, but switch controlled. The intention is to make everything as switch based as possible.

6. VIP Requirements ( Before the development phase ) :- 
    1] Basic VIP Architecture
    2] BFMs
    3] Makefile Commands
    4] Master
        a. Feature List
        b. Master-Monitor Checks List
    5] Slave
        a. Feature List
        b. Slave-Monitor Checks List
    6] Monitor
        a. Monitor Check Plan ( Written after the above Master & Slave Check Plans have been updated )
    7] Scoreboard









** VIP Is Mostly The MONITOR **

** Verification is done primarily using a MONITOR **
