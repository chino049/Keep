Default (GPT-3.5)


# Prompt user for CSV file path
$csvFilePath = Read-Host "Enter the path to the CSV file"

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