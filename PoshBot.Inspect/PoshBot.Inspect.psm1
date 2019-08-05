function Inspect-Command {
    <#
.SYNOPSIS
    Returns a functions definition
.DESCRIPTION
    This command will return the code of a function.
.PARAMETER Name
   Full name of a command that you want to return the code for.
.EXAMPLE
    !Inspect Slap
    Returns the definition of the Slap function.
#>
    [PoshBot.BotCommand(
        Aliases = ('Inspect')
    )]
    [CmdletBinding()]
    param(
        [Parameter(
            position = 0,
            Mandatory)]
        [String]
        $Name
    )

    $command = Get-Command $Name -ErrorAction SilentlyContinue

    if ($Command) {

        switch ($command.CommandType) {

            'Alias' {
                if ($command.ResolvedCommand.commandType -eq 'Function') {
                    $functionText = $command.ResolvedCommand
                }
                else {
                    $errorParams = @{
                        Type = 'Error'
                        Text = "Unable to find a command matching [$Name]. Please provide the full name of a command, no alias."
                    }
                    New-PoshbotCardResponse @errorParams
                }
            }
            'Function' {
                $functionText = $command.Definition
            }

            default {
                $errorParams = @{
                    Type = 'Error'
                    Text = "Unable to find a command matching [$Name]. Please provide the full name of a command, no alias."
                }
                New-PoshbotCardResponse @errorParams
            }
        }

        New-PoshBotTextResponse -Text $functionText -AsCode
    }
    else {
        $errorParams = @{
            Type = 'Error'
            Text = "Unable to find a command matching [$Name]. Please provide the full name of a command, no alias."
        }
        New-PoshbotCardResponse @errorParams
    }
}
