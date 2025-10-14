param (
    [string]$csvFilePath
)

# Check if the file exists
if (Test-Path -Path $csvFilePath -PathType Leaf) {
    # Read data from the CSV file
    $data = Import-Csv -Path $csvFilePath

    # Loop through each row in the CSV data
    foreach ($row in $data) {
        # Display each column's value
        foreach ($property in $row.PSObject.Properties) {
            Write-Host "$($property.Name): $($property.Value)"
        }
        Write-Host "------------------"
        
    }
} else {
    Write-Host "File not found at $csvFilePath"
}

# .\ReadCSV.ps1 -csvFilePath "C:\Path\To\Your\File.csv"
C:\Users\jesus.ordonez\Engagements\268-NAVAIR\ReadCSVfilebyArgument.ps1 -csvfilepath "C:\Users\jesus.ordonez\Engagements\268-NAVAIR\dtf.csv"