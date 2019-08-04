function Inspect-Command {
    <#
.SYNOPSIS
    Returns a functions definition
.DESCRIPTION
    This command will return the code of a function.
.PARAMETER Name
    Name of the command that you would like to see the code for.
.EXAMPLE
    !Inspect Slap
    Returns the definition of the Slap function.
#>
    [PoshBot.BotCommand(
        Aliases = ('Inspect')
    )]
    [CmdletBinding()]
    param(
        [Parameter(position = 0)]
        [String]
        $Name
    )

    Try { $command = Get-Command $Name -ErrorAction Stop }
    Catch { Write-Error "Unable to find a command matching $Name" -ErrorAction Stop }

    switch ($command.CommandType) {

        'Alias' {
            if ($command.ResolvedCommand.commandType -eq 'Function') {
                $functionText = $command.ResolvedCommand
            }
            else {
                Write-Error "$($command.ResolvedCommand.CommandType) not supported. Please supply a function or an alias of a function" -ErrorAction Stop
            }
        }

        'Function' {
            $functionText = $command.Definition
        }

        default {
            Write-Error "$($command.CommandType) not supported. Please supply a function or an alias of a function" -ErrorAction Stop
        }
    }

    New-PoshBotTextResponse -text $functionText -AsCode
}
