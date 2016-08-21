 <#
.SYNOPSIS
    Test for installation status of a Windows feature.
.DESCRIPTION
    Test for installation status of a Windows feature.
.PARAMETER Target
    Specifies the name of the feature to search for.
.PARAMETER Property
    Specifies the property to test for on the feature. 
.PARAMETER Should 
    A Script Block defining a Pester Assertion.
.EXAMPLE
    WindowsFeature 'TelnetClient' state { should be 'Disabled' }
.NOTES
    Only validates the State property. Assertions: Be
#> 
  
function WindowsFeature {
    [CmdletBinding(DefaultParameterSetName='prop')]
    param(
        [Parameter(Mandatory, Position=1)]
        [Alias('Name')]
        [string]$Target,
        
        [Parameter(Position=2, ParameterSetName='prop')]
        [ValidateSet('State')]
        [string]$Property = 'State',
        
        [Parameter(Mandatory, Position=2, ParameterSetName='noprop')]
        [Parameter(Mandatory, Position=3, ParameterSetName='prop')]
        [scriptblock]$Should
    )

    if (-not $PSBoundParameters.ContainsKey('Property')) {
        $Property = 'State'
        $PSBoundParameters.Add('Property', $Property)
    }
     
    $expression = { Get-WindowsOptionalFeature -Online -FeatureName '$Target' -ErrorAction SilentlyContinue }
    
    $params = Get-PoshspecParam -TestName WindowsFeature -TestExpression $expression @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}
