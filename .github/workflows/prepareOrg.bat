@ECHO OFF
setlocal EnableDelayedExpansion

set /p DevHubb=Enter your DEV Branch Name : 

set /p Feature=Enter your Feature Branch Name :

set /p huborg=Enter your DevHUB Org Alias :

set /p sorg=Enter your New Scratch Org Alias :

set /p WData=Do you want to add data to your Scratch Org? [y/n]:

IF %WData%==y ( set /p WOData=Do you want to Export Data from a source org or use files ? [s/f]: ) 

IF NOT DEFINED WData ( SET WData=n)

IF NOT DEFINED WOData ( SET WOData=n)

IF %WOData%==f ( set /p Files=Enter your Files's Names : )

IF %WOData%==s ( set /p dataorg=Enter your data source org ? : )

IF %WOData%==s ( set /p Files=Enter your Objects Files's Names : )


ECHO #####################################
ECHO Start preparing your orgs and branches...

ECHO Checkout %DevHubb% :
git checkout %DevHubb%

ECHO Check Current Branch :
git branch --show-current

ECHO Create %Feature%  :
git checkout -b %Feature% %DevHubb%


ECHO Create %sorg% Scratch Org :
rem call sfdx force:org:create  --setdefaultusername -f config/project-scratch-def.json -a my-scratch --setalias %sorg%

ECHO Generate %sorg% Password :
rem call sfdx force:user:password:generate --targetusername %sorg%


ECHO Set %sorg% As default :
call sfdx force:config:set defaultusername=%sorg%

rem verify whe, failed pushing sorg
ECHO Push into %sorg% Scratch Org :
call sfdx force:source:push -u %sorg%

# Export Data from source org using queries files
IF %WData% EQU n GOTO end  ( 
) ELSE (
    ECHO  in the IF
    IF %WOData% EQU s (
        ECHO Export Data from %dataorg% :
        for /F "tokens=*" %%Q in (./data/queries) do (  
                ECHO Start Export using Query : %%Q
                ECHO ##################
                call sfdx force:data:tree:export -q %%Q -d ./data -p -u %dataorg% 
                ECHO End Export.
                ECHO ##################
        )
    )

# Import Data into scratch org :
    ECHO Import Data to %sorg% :
    for %%A in %Files% do (
        ECHO Start Import of %%A :
        ECHO ##################
        call sfdx force:data:tree:import -p data/%%A-plan.json -u %sorg%
        echo End Import. 
        ECHO ##################
    )
)

:end

ECHO Dispaly %sorg% Scratch Org Information :
call sfdx force:user:display -u %sorg%

ECHO End of Preparation.
ECHO #####################################

EXIT
endlocal
