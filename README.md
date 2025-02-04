# brdkCert Library

## Overview

The `brdkCert` library provides functionality to export certificates from Automation Studio to the usershare certificate store on HMI panels. This library is designed to automate the process of exporting and storing certificates on panels, ensuring secure communication between devices.

## Function Blocks

### SendThirdPartyToPanel

The `SendThirdPartyToPanel` function block handles the process of exporting a certificate to a panel and storing it in a specific directory. It uses a state machine to manage the steps involved in the process.

## Usage

1. **Initialization**:
   - Set the `Execute` input to `TRUE` to start the process.
   - Provide the `CertificateName`, `PanelEndpoint`, `PanelType`, and `PanelPassword`.

2. **State Machine**:
   - The function block will progress through various states to complete the export process.
   - If any errors occur output ERROR=TRUE.

## Example

```pascal
PROGRAM _INIT

	SendThirdPartyToPanel_0.PanelEndpoint := '192.168.30.222';
	SendThirdPartyToPanel_0.PanelType := BRDK_CERT_FT50;
	SendThirdPartyToPanel_0.PanelPassword := '1234';
	SendThirdPartyToPanel_0.CertificateName := 'CertificateName.cer';
	SendThirdPartyToPanel_0.Simulated := DiagCpuIsARsim();
	
END_PROGRAM

PROGRAM _CYCLIC

	SendThirdPartyToPanel_0(); // Use .Execute=TRUE to start the transfer
	
END_PROGRAM
```