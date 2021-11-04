@ECHO OFF

set /p DevHub=Enter your DEV Branch Name : 
set /p Feature=Enter your Feature Branch Name :
set /p WData=Do you want to populate your scratch org ? [y/n]:
if %WData%==y ( set /p sqllist=Enter your SQL Querys Name :)

ECHO #####################################
ECHO Start preparing your orgs and branches..

ECHO Checkout %DevHub% :
git checkout %DevHub%

ECHO Check Current Branch :
git branch --show-current

ECHO Create %Feature%  :
git checkout -b %Feature% %DevHub%

ECHO Check %Feature% :
git branch --show-current

ECHO Publish %Feature% :
git push --set-upstream origin %Feature%

ECHO Create Scratch Org :
rem call sfdx force:org:create  --setdefaultusername -f config/project-scratch-def.json -a my-scratch --setalias sorg

ECHO Generate Scratch Org Password :
call sfdx force:user:password:generate --targetusername sorg

ECHO Push into Scratch Org :
call sfdx force:source:push -f -u sorg

IF %WData%==y (
    ECHO Export Data from DEVHUB 

    for %%a in %sqllist% do (
        echo Start Export using Query : %%a 
        echo ##################
        call sfdx force:data:tree:export -q %%a -d ./data -p -u hug-org 
        echo End Export using Query
        echo ##################
    )

    ECHO Import Data to sorg

    set /p Files=Enter your plan files to Import, exemple Account-Case-plan :
    for %%a in %Files% do (
        echo %%a
        echo Start Import of %%a Data
        echo ##################
        call sfdx force:data:tree:import -p data/%%a.json -u sorg
        echo End Import. 
        ECHO ##################
    )
) 


ECHO Dispaly Scratch Org Information :
call sfdx force:user:display -u sorg

ECHO End of Preparation.
ECHO #####################################

EXIT
