Add-Type -AssemblyName System.Windows.Forms, System.Drawing

# --- Create Form ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Nexus App Downloader"
$form.Size = "500,600"
$form.BackColor = "#121212" # Dark background
$form.ForeColor = "White"
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"

$font = New-Object System.Drawing.Font("Segoe UI", 10)
$form.Font = $font

# --- UI Header ---
$header = New-Object System.Windows.Forms.Label
$header.Text = "Search for Discord, Steam, or Store Apps"
$header.Location = "25,20"; $header.Size = "450,30"
$header.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 12)
$form.Controls.Add($header)

# --- Search Input ---
$searchInput = New-Object System.Windows.Forms.TextBox
$searchInput.Location = "25,60"; $searchInput.Size = "330,30"
$searchInput.BackColor = "#252526"; $searchInput.ForeColor = "White"
$searchInput.BorderStyle = "FixedSingle"
$form.Controls.Add($searchInput)

$searchBtn = New-Object System.Windows.Forms.Button
$searchBtn.Text = "Search"; $searchBtn.Location = "365,59"; $searchBtn.Size = "85,28"
$searchBtn.FlatStyle = "Flat"; $searchBtn.BackColor = "#0078D4"
$form.Controls.Add($searchBtn)

# --- Results List ---
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = "25,100"; $listBox.Size = "425,320"
$listBox.BackColor = "#1E1E1E"; $listBox.ForeColor = "#CCCCCC"
$listBox.BorderStyle = "None"
$form.Controls.Add($listBox)

# --- Install Button ---
$dlBtn = New-Object System.Windows.Forms.Button
$dlBtn.Text = "INSTAL SELECTED APP"
$dlBtn.Location = "25,440"; $dlBtn.Size = "425,50"
$dlBtn.FlatStyle = "Flat"; $dlBtn.BackColor = "#28A745"
$dlBtn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($dlBtn)

# --- Status Bar ---
$status = New-Object System.Windows.Forms.Label
$status.Text = "Ready."
$status.Location = "25,510"; $status.Size = "425,30"
$status.ForeColor = "#888888"
$form.Controls.Add($status)

# --- Logic Implementation ---

$searchBtn.Add_Click({
    $query = $searchInput.Text.Trim()
    if (!$query) { return }
    
    $listBox.Items.Clear()
    $status.Text = "Searching catalogs... (this may take 5-10 seconds)"
    $searchBtn.Enabled = $false
    
    # Run winget in a way that captures the columns we need
    # We use --accept-source-agreements to skip prompts that slow things down
    $results = winget search $query --accept-source-agreements | Select-String -Pattern "^\S+\s+\S+" | Select-Object -Skip 1
    
    if ($results) {
        foreach ($line in $results) {
            $listBox.Items.Add($line.ToString())
        }
        $status.Text = "Found $($results.Count) results."
    } else {
        $status.Text = "No apps found. Check spelling."
    }
    $searchBtn.Enabled = $true
})

$dlBtn.Add_Click({
    $selected = $listBox.SelectedItem
    if ($selected -match "^(\S+)\s+(\S+)") {
        $name = $matches[1]
        $id = $matches[2]
        
        $status.Text = "Starting installer for $name..."
        # Opens a separate window so the main GUI doesn't hang during install
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "Write-Host 'Starting installation of $id...'; winget install --id $id --accept-package-agreements --accept-source-agreements"
    } else {
        $status.Text = "Please select an app from the list first."
    }
})

$form.ShowDialog()
