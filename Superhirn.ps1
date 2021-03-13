#                                                       
#   ____  _   _ ____  _____ ____  _   _ ___ ____  _   _ 
#  / ___|| | | |  _ \| ____|  _ \| | | |_ _|  _ \| \ | |
#  \___ \| | | | |_) |  _| | |_) | |_| || || |_) |  \| |
#   ___) | |_| |  __/| |___|  _ <|  _  || ||  _ <| |\  |
#  |____/ \___/|_|   |_____|_| \_|_| |_|___|_| \_|_| \_|
#                                                       


### Function 'CreateCode' to create a secret random code from array $RandomColors ###
function CreateCode
    {
        switch ($global:difficulty)
        {
            1 {$global:RandomColors = @('r','g','y','b','d','w');$global:magentaf = "black";$global:magenta = "black";$global:cyan = "black"}
            2 {$global:RandomColors = @('r','g','y','b','d','w','m');$global:cyan = "black"}
            3 {$global:RandomColors = @('r','g','y','b','d','w','m','c')}
        }
        
        $Code = Get-Random -InputObject $RandomColors -count 4 # get 4 random colors from array
        return $Code
                
    }


### Function 'CheckResult' checks input and calculates points ###
function CheckResult($fcode,$feingabe,$fposition,$fformerinput)
    {
        if ($fcode.contains($feingabe)) {$global:result = $global:result +1} # adds 1 point to scoreresult if color is contained in code (corrrect color)
        if ($fformerinput.contains($feingabe)) {$global:result--} # subtracts 1 point if color was already entered before, we don't want double colors
        if ($feingabe -eq $fcode[$fposition]) 
            {
                $global:result = $global:result + 9 # adds another 9 points to scoreresult as color has correct position (10 points in total)           
            }        
    }


### Function 'ShowPins' shows resultpins after four inputs (one complete line) ###
function ShowPins($fresult)
    {
        
        switch ($fresult)
        {
            0 {$graphic = "· ·";$graphic2 = "· ·"} # 0 Points - no correct color
            1 {$graphic = "☺ ·";$graphic2 = "· ·"} # 1 Points - 1 correct colors, 0 correct positions
            2 {$graphic = "☺ ☺";$graphic2 = "· ·"} # 2 Points - 2 correct colors, 0 correct positions
            3 {$graphic = "☺ ☺";$graphic2 = "☺ ·"} # 3 Points - 3 correct colors, 0 correct positions
            4 {$graphic = "☺ ☺";$graphic2 = "☺ ☺"} # 4 Points - 4 correct colors, 0 correct positions
            10 {$graphic = "☻ ·";$graphic2 = "· ·"}# 10 Points - 1 correct color, 1 correct positions
            20 {$graphic = "☻ ☻";$graphic2 = "· ·"}# 20 Points - 2 correct colors, 2 correct positions
            30 {$graphic = "☻ ☻";$graphic2 = "☻ ·"}# 30 Points - 3 correct colors, 3 correct positions
            40 {$graphic = "☻ ☻";$graphic2 = "☻ ☻"}# 40 Points - 4 correct colors, all on correct position (-> Game Over)
            11 {$graphic = "☻ ☺";$graphic2 = "· ·"}# 11 Points - 2 correct colors, 1 correct positions
            12 {$graphic = "☻ ☺";$graphic2 = "☺ ·"}# 12 Points - 3 correct colors, 2 correct positions
            13 {$graphic = "☻ ☺";$graphic2 = "☺ ☺"}# 13 Points - 4 correct colors, 3 correct positions
            21 {$graphic = "☻ ☻";$graphic2 = "☺ ·"}# 14 Points - 3 correct colors, 1 correct positions
            22 {$graphic = "☻ ☻";$graphic2 = "☺ ☺"}# 22 Points - 4 correct colors, 2 correct positions
            # 31 Points would mean 4 correct colors with 3 correct positions which can't happen, therefore a result > 30 points means all colors are correct and on correct position                            
        }

        # Output result to screen
        $global:resultpositionY = $global:resultpositionY+3
        $Host.UI.RawUI.CursorPosition = @{X=41; Y=$global:resultpositionY}
        write-host $graphic
        $Host.UI.RawUI.CursorPosition = @{X=41; Y=$global:resultpositionY+1}
        write-host $graphic2
        $Host.UI.RawUI.CursorPosition = @{X=41; Y=$global:resultpositionY+2}
                
    }

### Function 'ShowCode' shows secret code at the end of the game
function ShowCode($fcode)
    {
        $fcursorX = 17
        $fcursorY = 13
        foreach ($c in $fcode)

        {
            $Host.UI.RawUI.CursorPosition = @{ X = $fcursorX; Y = $fcursorY} # puts cursor to the correct position
            $backgroundcolor = switch ( $c ) # defines color of the pin depending on the array entries
          
              {
                                            r { 'red'    }
                                            g { 'green'    }
                                            y { 'yellow'   }
                                            b { 'blue' }
                                            d { 'darkgray'  }
                                            w { 'white'    }
                                            m { 'magenta'  }
                                            c { 'cyan'  }
              }
        
            write-host " " -BackgroundColor $backgroundcolor # shows pin in the appropriate color
            $fcursorX = $fcursorX+6 # moves cursor to next postition
        }

    }

### Function 'HallofFame'
function HallofFame
    {

        $HighScoreFilePath = "$env:LOCALAPPDATA\Temp\Hall-of-Fame.txt" # Set local temp path for a HallOfFame TXT-file
        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 12}
        write-host "┌──────────────────────────────────────┐" -ForegroundColor Yellow
        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 13}
        write-host "│            Hall of Fame              │" -ForegroundColor Yellow
        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 14}
        write-host "├──────────────────────────────────────┤" -ForegroundColor Yellow
        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 15}
        write-host "│ Pos Time          Lvl  Name          │" -ForegroundColor Yellow
        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 16}
        write-host "├──────────────────────────────────────┤" -ForegroundColor Yellow
        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 17}
        write-host "│                                      │" -ForegroundColor Yellow
        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 18}
        write-host "│                                      │" -ForegroundColor Yellow
        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 19}
        write-host "│                                      │" -ForegroundColor Yellow
        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 20}
        write-host "│                                      │" -ForegroundColor Yellow
        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 21}
        write-host "│                                      │" -ForegroundColor Yellow
        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 22}
        write-host "│                                      │" -ForegroundColor Yellow
        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 23}
        write-host "│                                      │" -ForegroundColor Yellow
        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 24}
        write-host "│                                      │" -ForegroundColor Yellow
        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 25}
        write-host "│                                      │" -ForegroundColor Yellow
        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 26}
        write-host "│                                      │" -ForegroundColor Yellow
        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 27}
        write-host "└──────────────────────────────────────┘" -ForegroundColor Yellow
        ### didn't used a loop here to better visualize the output


        if(![System.IO.File]::Exists($HighScoreFilePath)) # if file doesn't exist create a new placeholderlist
            {         
                $HighScore = @() # create an empty highscore array
                for ($i=1;$i -le 10;$i++) # create 10 entries
                    {
                        $counter = "{0:00}" -f $i # converts 1-digit number in "$i" into 2-digit with leading zero, e.g. "5" into "05" 
                        $HighScore += New-Object -TypeName psobject -Property @{NAME="Player$counter"; TIME="00:$($counter):00.000"; DIFFICULTY="3"} # creates 10 players with different playtimes
                    }
                $HighScore | Select-Object NAME, TIME, DIFFICULTY | Export-Csv -Path $HighScoreFilePath -NoTypeInformation # writes newly created placeholder HallofFame into file
            }

        $HighScore = Import-Csv -Path $HighScoreFilePath # as we have a highscorefile now, we can import it
        
        if ($global:playtime -lt $HighScore[9].Time -and $result -gt 30) # if the playtime was better/lower then rank10 in Highscore and the code was also guessed we have new besttime

                    {
                        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 29}
                        write-host " *** NEW BEST TIME! ***" -ForegroundColor Yellow
                        $Host.UI.RawUI.CursorPosition = @{ X = 51; Y = 31}
                        $Playername = Read-Host " Please enter your name (max. 12 chars)" # honor to the lucky winner
                        if ($Playername.Length -gt 12) {$Playername = $Playername.SubString(0,12)} # we cut of the name after 12 chars to avoid novels here :-)
                        $HighScore += New-Object -TypeName psobject -Property @{NAME=$PlayerName; TIME=$global:playtime; DIFFICULTY=$global:difficulty} # write new entry into highscore
                        $NewHighScore = $HighScore | Sort-Object TIME # sort highscore by time
                        $NewHighScore = $NewHighScore[0..9] # as we have 11 entries in highscore now, we only keep the first 10
                        $NewHighScore | Select-Object NAME, TIME, DIFFICULTY | Export-Csv -Path $HighScoreFilePath -NoTypeInformation # write new highscore file back to directory
                        $HighScore = $NewHighScore # New highscore becomes current highscore
      
                    }

        $fy = 17 # Highscore position

        for ($i=1; $i -le 10; $i++) # print highscore to screen, no matter if we have a new entry or not
                {
                       
                       $Host.UI.RawUI.CursorPosition = @{ X = 53; Y = $fy}
                       write-Host $i". " # Rank
                       $Host.UI.RawUI.CursorPosition = @{ X = 57; Y = $fy}
                       write-host $HighScore[$i-1].Time " " $HighScore[$i-1].Difficulty " " $HighScore[$i-1].Name
                       $fy++
                            
                }

    }


### Main

$global:difficulty = "3"    # defines difficulty from level 1-3 (6-8 possible colors)
$global:magenta = "magenta" # unhides this color when difficulty is "2" or "3"
$global:magentaf = "white"  # unhides this color when difficulty is "2" or "3"
$global:cyan = "cyan"       # unhides this color when difficulty is "3"
$global:RandomColors = @()  # defines an array for used colors depending on difficulty

do
    {

        $global:FormerInput = @()
        $global:result = 0
        $Guess = @()
        $y=17
        $x=17

        $global:resultpositionY = 13

        $a = (Get-Host).UI.RawUI
        $a.BackgroundColor = 'Black'
        $a.ForegroundColor = 'White' ; cls
                                                  
        write-host "    ____  _   _ ____  _____ ____  _   _ ___ ____  _   _ "
        write-host "   / ___|| | | |  _ \| ____|  _ \| | | |_ _|  _ \| \ | |"
        write-host "   \___ \| | | | |_) |  _| | |_) | |_| || || |_) |  \| |"
        write-host "    ___) | |_| |  __/| |___|  _ <|  _  || ||  _ <| |\  |"
        write-host "   |____/ \___/|_|   |_____|_| \_|_| |_|___|_| \_|_| \_|"
        write-host " "
        write-host " Tribute to the famous game 'Mastermind' from Parker Brothers"
        write-host "           coded by Gregor Schillinger (2021)"
        write-host " "
        $pos = $Host.UI.RawUI.CursorPosition
        do 
            {   
                write-host " Please choose difficulty (1-3): " -NoNewline
                $In = $host.ui.RawUI.ReadKey()
                $global:difficulty = $In.Character
                $Host.UI.RawUI.CursorPosition = $pos
            }
        until (($In.Character -eq "1") -or ($In.Character -eq "2") -or ($In.Character -eq "3"))

        $Code = CreateCode # calling function 'CreateCode' which returns our secret code into variable
        
        write-host "  " -BackgroundColor Black -ForegroundColor white -NoNewline
        write-host " (R)ed      " -BackgroundColor red -nonewline
        write-host " (G)reen    " -BackgroundColor green -ForeGroundcolor Black -nonewline
        write-host " (Y)ellow   " -BackgroundColor yellow -ForeGroundcolor Black -nonewline
        write-host " (B)lue     " -BackgroundColor blue -NoNewline
        write-host " ☺ = correct color, wrong position" -BackgroundColor Black -ForegroundColor white
        write-host "  " -BackgroundColor Black -ForegroundColor white -NoNewline
        write-host " (D)arkgray " -BackgroundColor darkgray -nonewline
        write-host " (W)hite    " -BackgroundColor white -ForeGroundcolor Black -nonewline
        write-host " (M)agenta  " -BackgroundColor $magenta -ForeGroundcolor $magentaf -nonewline
        write-host " (C)yan     " -BackgroundColor $cyan -ForeGroundcolor Black -NoNewline
        write-host " ☻ = correct color, correct position" -BackgroundColor Black -ForegroundColor white
        write-host ""
        write-host "              ┌─────┬─────┬─────┬─────┐"
        write-host "              │  ?  │  ?  │  ?  │  ?  │"
        write-host "              └─────┴─────┴─────┴─────┘"
        write-host $Code[0] $code[1] $code[2] $code[3] -BackgroundColor black -ForegroundColor black # little 'easteregg' I left for debugging, choose 'white' for cheating. 

        ### Starting 10 rounds or until code is guessed, $result > 30

        $starttime = Get-Date # start the clock

        $runde = 1 # 'runde' is the german word for round. I keep this variablename for confusion :-)

        do

    {
        $round = "{0:00}" -f $runde # reformat the number into 2 digits leading 0
        write-host "              ┌─────┬─────┬─────┬─────┐"
        write-host "          $round  │     │     │     │     │"
        write-host "              └─────┴─────┴─────┴─────┘"
        
        
        
        $global:result = 0 # Starting the game with 0 points
        $cursor = $Host.UI.RawUI.CursorPosition
        
        for ($position=0; $position -le 3; $position++) 
            {
               
                $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y}
                $Input = $host.ui.RawUI.ReadKey() # let the player input a color
                $keycache = $Input # we need a second variable to check against former inputs
                
                if ($FormerInput -notcontains $Input.character -or $Input.VirtualKeyCode -eq "8") # continue only if color was not already choosen before in this round or Backspace was pressed
                               
                    {

                        ## Allow only possible colors
                        if ($RandomColors -contains $Input.character)
                            {
                                $Guess = $Guess+$Input.character
                                $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y}
                                $backgroundcolor = switch ( $Input.character )
                                    {
                                        r { 'red'    }
                                        g { 'green'    }
                                        y { 'yellow'   }
                                        b { 'blue' }
                                        d { 'darkgray'  }
                                        w { 'white'    }
                                        m { 'magenta'  }
                                        c { 'cyan'  }
                                    }
                                write-host " " -BackgroundColor $backgroundcolor
                                CheckResult $Code $Input.character $position $FormerInput
                                
                            }
                       
                       elseif ($Input.VirtualKeyCode -eq "8") ### if Backspace is pressed delete former entries from row
                           
                            {
                                 $position = -1 # reset position, will be 0 in next loop
                                 $x=11 # move cursor back to first position
                                 $FormerInput = @() # clear all entries
                                 $global:result = 0 # clear points
                            }

                    else 
                            {
                                $position--
                                $x = $x-6
                            }

                    $FormerInput = $FormerInput + $Input.character
                        
                    if ($position -eq 3)
                                {

                                    do 
                                        {
                                            $Host.UI.RawUI.CursorPosition = @{ X = $x+1; Y = $y}
                                            $Confirmation = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                                            if ($Confirmation.VirtualKeyCode -eq "8") ### if Backspace is pressed delete former entries from row
                           
                                                {
                                                     $position = -1 # reset position, will be 0 in next loop
                                                     $x=11 # move cursor back to first position
                                                     $FormerInput = @() # clear all entries
                                                     $global:result = 0 # clear points
                                                }
                                        }
                                    until (($Confirmation.virtualkeycode -eq "13") -or ($Confirmation.virtualkeycode -eq "8"))
                                }
                    
                    }
                   
                    else 
                            {
                                $position--
                                $x = $x-6                 
                            }

                $x = $x+6
                $Host.UI.RawUI.CursorPosition = @{ X = 40; Y = 13}
                ### write-host "Debug: $global:result  " # use this only for debugging Resultpoints
                                   
                # End of playerinput
            }
        
        ShowPins $result # Calling function 'ShowPins' for showing result of this round
        $x = $x-24
        $y = $y+3
        $Host.UI.RawUI.CursorPosition = @{X= $cursor.x; Y= $cursor.y}
        $runde++
        $FormerInput = @()

    }

until (($runde -gt 10) -or ($result -gt 30)) # Game ends after 10 rounds or if the code was guessed

        $global:playtime = (Get-date)-$starttime # stopping the watch
        $global:playtime = "{0:hh\:mm\:ss\.fff}" -f ([TimeSpan] $global:playtime) # reformatting playtime into something we can work with (hh/mm/ss.f)
        $global:cursor = $Host.UI.RawUI.CursorPosition
        ShowCode $Code # calls function 'ShowCode' funhides the secret code
        $Host.UI.RawUI.CursorPosition = $cursor
        write-host ""
        write-host ""
        if ($result -gt 30) {write-host " Congratulations! You hacked the code!";}
        else {write-host " Sorry, you couldn't guess the code!"}
        write-host ""
        write-host " Your playtime was: $global:playtime (HH:MM:SS.F)"
        write-host ""
        $cursor = $Host.UI.RawUI.CursorPosition

        HallofFame # calling function 'HallOfFame'
        $Host.UI.RawUI.CursorPosition = @{ X = 52; Y = 33}
        write-host "Play again? (y/n): " -ForegroundColor Green -NoNewline
        do {
                $continue = $host.ui.RawUI.ReadKey()
                $Host.UI.RawUI.CursorPosition = @{ X = 71; Y = 33}
            }
        until (($continue.character -eq "y") -or ($continue.character -eq "n"))

    }
until ($continue.character -eq "n")
cls

### End of main
