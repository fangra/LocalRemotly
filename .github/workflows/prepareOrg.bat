@ECHO OFF
rem set /p list=Enter your objects exemple (Account,Case): 
set /p DevHub=Enter your DEV Branch Name : 
set /p Feature=Enter your Feature Branch Name :
set /p sqllist=Enter your SQL Querys Name :
set Clid="3MVG9t0sl2P.pBypl07KvI.FUHkU1Hw6_7JdMUcR4O4vtd51XoD01z0JyibB.CUjGip1YlyEyHg.MK7GSgUNq"
rem client Id of the connected app
set pathkey=C:\Users\mfangra\KeyOSSL\server3.key 
rem path of the server key
set username="meri.wa@gmail.com"
rem username of devHub
ECHO #####################################
ECHO Congratulations! Your first steps to prepare your orgs
ECHO Do Checkout
git checkout %DevHub%
ECHO Do current branch
git branch --show-current
ECHO Do Feature creation
git checkout -b %Feature% %DevHub%
ECHO Feature checking
git branch --show-current
ECHO Do publish %Feature%
git push --set-upstream origin %Feature%
ECHO End  Do publish %Feature%
rem ECHO Authorize DEVHUB
rem call sfdx force:auth:jwt:grant --clientid %Clid% --jwtkeyfile %pathkey%  --username %username% -a hug-org -d
ECHO Scratch Org
rem call sfdx force:org:create  --setdefaultusername -f config/project-scratch-def.json -a my-scratch --setalias sorg
ECHO Password generation 
call sfdx force:user:password:generate --targetusername sorg
rem ECHO Profile FLS Pushing
rem call sfdx force:source:retrieve -x C:\Users\mfangra\Desktop\Local\LocalRemotly\.github\workflows\package.xml -u hug-org
ECHO Scratch Org Pushing
call sfdx force:source:push -f -u sorg
ECHO Export Data from DEVHUB
set n=0

for %%a in %sqllist% do (
    echo Start Query of SObject : %%a 
    echo ##################
    rem if %%a == Account call sfdx force:data:soql:query -q "SELECT  Name,FIELDS(CUSTOM) FROM %%a LIMIT 10" -u=hug-org -r=csv > %%a.csv
    rem if %%a == Case call sfdx force:data:soql:query -q "SELECT  Subject,Account.SF_Account_Number__c,SLAViolation__c,Product__c,PotentialLiability__c FROM %%a LIMIT 10" -u=hug-org -r=csv > %%a.csv
    rem if %%a == Account call sfdx force:data:tree:export -q "SELECT Id,Name,FIELDS(CUSTOM) FROM %%a LIMIT 10" -d ./data -p -u hug-org 
    rem if %%a == Case call sfdx force:data:tree:export -q "SELECT Id,Subject,FIELDS(CUSTOM) FROM %%a LIMIT 10" -d ./data -p -u hug-org 
    rem if %%a == Case call sfdx force:data:tree:export -q "SELECT  Id,Name, (SELECT Id,Subject FROM Cases) FROM Account LIMIT 10" -d ./data -p -u hug-org 
    call sfdx force:data:tree:export -q %%a -d ./data -p -u hug-org 
    echo End Query 
    echo ##################
)
ECHO Import Data to sorg
rem call sfdx force:data:tree:import -p data/Account-Case-plan.json -u sorg
set /p Files=Enter your plan files to Import, exemple Account-Case-plan :
set n=0
for %%a in %Files% do (
    echo %%a
    echo Start Upsert of %%a  's Data
    echo ##################
    rem echo sfdx force:data:bulk:upsert -s %%a -f %%a.csv -i Id -w 2 -u sorg
    rem call sfdx force:data:bulk:upsert -s %%a -f %%a.csv -i Id -w 2 -u sorg
    rem sfdx force:data:tree:import -p data/%%a-plan.json -u sorg
    rem if %%a == Case  sfdx force:data:tree:import -p data/%%a.json -u sorg
    call sfdx force:data:tree:import -p data/%%a.json -u sorg
    echo End Upsert 
    ECHO ##################
)
ECHO Dispaly Scratch Org Information
call sfdx force:user:display -u sorg
EXIT
