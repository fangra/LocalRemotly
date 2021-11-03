@ECHO OFF
ECHO Congratulations! Your first steps to prepare your orgs
ECHO Do Checkout
git checkout DevHub
ECHO Do current branch
git branch --show-current
ECHO Do Feature creation
git checkout Feature1
ECHO Feature checking
git branch --show-current
ECHO Do publish Feature1
git push --set-upstream origin Feature1
ECHO End  Do publish Feature1
ECHO Authorize DEVHUB
sfdx force:auth:jwt:grant --clientid "3MVG9t0sl2P.pBypl07KvI.FUHkU1Hw6_7JdMUcR4O4vtd51XoD01z0JyibB.CUjGip1YlyEyHg.MK7GSgUNq" --jwtkeyfile C:\Users\mfangra\KeyOSSL\server3.key --username meri.wa@gmail.com -a hug-org -d
ECHO Scratch Org
rem ECHO Password generation 
rem call sfdx force:user:password:generate --targetusername test-jxl0utitxcyh@example.com
ECHO Scratch Org Pushing
call sfdx force:source:push -u test-jxl0utitxcyh@example.com
PAUSE
