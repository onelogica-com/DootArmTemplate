param(
    [string] [Parameter(Mandatory=$false)] $vaultName,
    [string] [Parameter(Mandatory=$false)] $certificateName,
    [string] [Parameter(Mandatory=$false)] $subjectName
)

$ErrorActionPreference = 'Stop'
$DeploymentScriptOutputs = @{} 

$existingCert = Get-AzKeyVaultCertificate -VaultName $vaultName -Name $certificateName

if ($existingCert -and $existingCert.Certificate.Subject -eq $subjectName) {
    $DeploymentScriptOutputs['certThumbprint'] = $existingCert.Thumbprint
    $existingCert | Out-String
}

else {

    $policy = New-AzKeyVaultCertificatePolicy -SubjectName $subjectName -IssuerName Self -ValidityInMonths 12 -Verbose

    # private key is added as a secret that can be retrieved in the ARM template
    Add-AzKeyVaultCertificate -VaultName $vaultName -Name $certificateName -CertificatePolicy $policy -Verbose

    $newCert = Get-AzKeyVaultCertificate -VaultName $vaultName -Name $certificateName

    # it takes a few seconds for KeyVault to finish
    $tries = 0 
    do {
        Write-Host 'Waiting for certificate creation completion...'
        Start-Sleep -Seconds 10
        $operation = Get-AzKeyVaultCertificateOperation -VaultName $vaultName -Name $certificateName
        $tries++

        if ($operation.Status -eq 'failed')
        {
          throw "Creating certificate failed $certificateName in vault $vaultName failed with error $($operation.ErrorMessage)"
        }

        if ($tries -gt 120)
        {
          throw "Timed out waiting for creation of certificate $certificateName in vault $vaultName"
        }

    } while ($operation.Status -ne 'completed')

    $DeploymentScriptOutputs['certThumbprint'] = $newCert.Thumbprint
    $newCert | Out-String
}
