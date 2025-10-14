param(

            
    [Parameter(Position=10,Mandatory = $false)]
        [string]$TECmdPath="c:\progra~1\Tripwire\tw-TECommander-8.8.7"
)

Begin {
    # Set Out-File's default encoding to "Ascii"
    $PSDefaultParameterValues = @{ 'Out-File:Encoding' = 'Ascii' }

        
    # Set Path to TECommander 
    #$TECmdPath = "D:\Tripwire\TECommander"
    $TECmd = $TECmdPath + "\bin\tecommander.cmd"
    $TECAuth = $TECmdPath + "\config\te_auth.xml"

    # Validate TECommander found
    If (!(Test-Path ($TECmd))) {
        Write-Error "The path for TECommander is invalid. Use the TECmdPath parameter or update TECmdPath variable."
        Exit
    }
   

   
    ####
    # List All Nodes in Root Node Group 
    ####
    function List-FullTree {
        Param ([string]$NodeGrp)
        Write-Debug "$(Get-Date) List-FullTree"
        Write-Verbose "$(Get-Date) $NodeGrp"

        $NodeGroupName = "`"Root Node Group`""
        $TECArgs = @('listtree', `
                '-w', $NodeGroupName, `
                '-M', $TECAuth, `
                '-Q', '-q')

        $TECmdFull = $TECmd + ' ' + $TECArgs + ' ' + $TECmdDebug
        Write-Debug "$(Get-Date) $TECmdFull"
        [array]$TECFullTree = Invoke-Expression $TECmdFull -OutVariable TECError

        If ($TECError -clike "*ERROR TECommander*") {
            $TECError -cmatch "ERROR" | write-error
            Return
        }

        If ([string]::IsNullOrWhiteSpace($TECFullTree[0])) {
            $TECError -cmatch "ERROR" | write-error
            Exit
        }

        $TECFullTree | Write-Verbose

        # Build Nodes Array with Node, Tag - Used for Get-Parents
        $NodesArray = @()
        $Tag = $null
        ConvertFrom-Csv -InputObject $TECFullTree -Delimiter ";" -Header NodeType, Node, OID |
        Where-Object { $null -ne $_.Node } |
        ForEach-Object { 
            If ($_.NodeType -eq 'nodeGroup' -and ($_.Node -ne $Tag)) { 
                $Tag = $_.Node
                return
            }
            $NodesArray += @(
                @{
                    Node = ($_.Node) 
                    OID  = ($_.OID) 
                    Tag  = ($Tag)
                }
            )
        }
        $Script:NodesArray = $NodesArray
        #$Script:NodesArray | ForEach-Object { Write-Verbose "$($_.Node) - $($_.Tag) - $($_.OID)" }
        $Script:NodesArray | ForEach-Object { Write-host "$($_.Node) - $($_.Tag) - $($_.OID)" }

    } # End Function List-FullTree

    ####
    function Get-Parents {
        Param ([string]$Node, [string]$OID)
        Write-Debug "$(Get-Date) Get-Parents"
        Write-Verbose "$(Get-Date) $Node"

        $Script:Parents = @()
        If (![string]::IsNullOrEmpty($OID)) { 
            $Script:Parents = ($NodesArray | Where-Object { $_.Node -eq $Node }).Tag
        }
        Else {
            $Script:Parents = ($NodesArray | Where-Object { $_.OID -eq $OID }).Tag
        }
        $Script:Parents | Format-Table -auto | Out-String -Stream | Write-Verbose

        #!!!! Potential issue if non-unique node name exists !!!!#
        # Check OID if duplicates? #

        Return 
    } # End Get-Parents
    
    ####
    # List Nodes in Nodegrp 
    ####
    function List-Tree {
        Param ([string]$NodeGrp)
        Write-Debug "$(Get-Date) List-Tree"
        Write-Verbose "$(Get-Date) $NodeGrp"

        $Script:ListTree = @()
        #$TECListTree  = $null
        If (![string]::IsNullOrEmpty($NodeGrp)) {
            $NodeGroupName = "`"$($NodeGrp)`""
            $TECArgs = @('listtree', `
                    '-w', $NodeGroupName, `
                    '-M', $TECAuth, `
                    '-Q', '-q')

            $TECmdFull = $TECmd + ' ' + $TECArgs + ' ' + $TECmdDebug
            Write-Debug "$(Get-Date) $TECmdFull"
            $Script:TECListTree = Invoke-Expression $TECmdFull -OutVariable TECError
        }
        Else {
            $Script:TECListTree = 'Node;' + $Node + ';' + $null
        }

        If ($TECError -clike "*ERROR TECommander*") {
            $TECError -cmatch "ERROR" | write-error
            Return
        }

        If ([string]::IsNullOrWhiteSpace($Script:TECListTree[0])) {
            $TECError -cmatch "ERROR" | write-error
            Return
        }

        $Script:TECListTree | Write-Verbose
    } # End Function Get-ListTree

    Return
     
} # End Begin

Process {
    write-host "Begin"
    List-FullTree
    
} # End Process