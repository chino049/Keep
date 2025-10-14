# Path to the CSV file
$csvFilePath = "C:\Path\To\Your\File.csv"

# Read data from the CSV file
$data = Import-Csv -Path $csvFilePath

# Loop through each row in the CSV data
foreach ($row in $data) {
    $column1Value = $row.Column1  # Replace Column1 with the actual column name
    $column2Value = $row.Column2  # Replace Column2 with the actual column name

    # Process or display the values
    Write-Host "Column1: $column1Value, Column2: $column2Value"
}