@ECHO OFF
set list=(Account, Case)
ECHO #####################################
ECHO Congratulations! Your first steps to prepare your orgs
ECHO Do Checkout
git checkout DevHub
ECHO Do current branch
git branch --show-current
ECHO Do Feature creation
git checkout -b Feature1 DEVHUB
ECHO Feature checking
git branch --show-current
ECHO Do publish Feature1
git push --set-upstream origin Feature1
ECHO End  Do publish Feature1
ECHO Authorize DEVHUB
call sfdx force:auth:jwt:grant --clientid "3MVG9t0sl2P.pBypl07KvI.FUHkU1Hw6_7JdMUcR4O4vtd51XoD01z0JyibB.CUjGip1YlyEyHg.MK7GSgUNq" --jwtkeyfile C:\Users\mfangra\KeyOSSL\server3.key --username "meri.wa@gmail.com" -a hug-org -d
ECHO Scratch Org
rem call sfdx force:org:create  --setdefaultusername -f config/project-scratch-def.json -a my-scratch --setalias sorg
ECHO Password generation 
rem call sfdx force:user:password:generate --targetusername sorg
ECHO Profile FLS Pushing
call sfdx force:source:retrieve -x C:\Users\mfangra\Desktop\Local\LocalRemotly\.github\workflows\package.xml -u hug-org
ECHO Scratch Org Pushing
call sfdx force:source:push -f -u sorg
ECHO Export Data from DEVHUB
rem call sfdx force:data:tree:export -q "SELECT FIELDS(ALL) FROM Account limit 3" -d ./data.csv -p -u hug-org 
set n=0
for %%a in %list% do (
echo Start Query of SObject : %%a 
echo ##################
if %%a == Account call sfdx force:data:soql:query -q "SELECT  Name,FIELDS(CUSTOM) FROM %%a LIMIT 10" -u=hug-org -r=csv > %%a.csv
if %%a == Case call sfdx force:data:soql:query -q "SELECT  Subject,SLAViolation__c,Product__c,PotentialLiability__c FROM %%a LIMIT 10" -u=hug-org -r=csv > %%a.csv
echo End Query 
echo ##################
)
ECHO Import Data to sorg
rem call sfdx force:data:tree:import -p data/Account-Case-plan.json -u sorg
set n=0
for %%a in %list% do (
echo %%a
echo Start Upsert of %%a  's Data
echo ##################
echo sfdx force:data:bulk:upsert -s %%a -f %%a.csv -i Id -w 2 -u sorg
call sfdx force:data:bulk:upsert -s %%a -f %%a.csv -i Id -w 2 -u sorg
echo End Upsert 
echo ##################
)
ECHO Dispaly Password
call sfdx force:user:display -u sorg
PAUSE
