@ECHO OFF
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
ECHO Scratch Org Pushing
call sfdx force:source:push -u sorg
ECHO Export Data from DEVHUB
call sfdx force:data:tree:export -q "SELECT Id,Name,(Select Subject from Cases) FROM Account limit 3" -d ./data -p -u hug-org
ECHO Import Data to sorg
call sfdx force:data:tree:import -p data/Account-Case-plan.json -u sorg
ECHO Dispaly Password
call sfdx force:user:display -u sorg

ECHO #####################################
ECHO.
ECHO.
PAUSE
