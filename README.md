# brdkCert Library

![image](https://github.com/user-attachments/assets/d707c291-8a7f-4be1-82ee-b231bee9c8cf)

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

	SendThirdPartyToPanel_0();  // Use .Execute=TRUE to start the transfer when file device ready
	
END_PROGRAM
```

### SendListThirdPartyToPanel

Same as "SendThirdPartyToPanel" but input CertificateName is now a list if the user wants to transfer more than 1.

## Example

```pascal
PROGRAM _INIT

	SendListThirdPartyToPanel_0.PanelEndpoint := '192.168.30.222';
	SendListThirdPartyToPanel_0.PanelType := BRDK_CERT_FT50;
	SendListThirdPartyToPanel_0.PanelPassword := '1234';
	SendListThirdPartyToPanel_0.CertificateName[0] := 'e6.cer';
	SendListThirdPartyToPanel_0.CertificateName[1] := 'r11.cer';
	SendListThirdPartyToPanel_0.CertificateName[2] := 'r10.cer';
	SendListThirdPartyToPanel_0.CertificateName[3] := 'isrg-root-x2-cross-signed.cer';
	SendListThirdPartyToPanel_0.CertificateName[4] := 'isrg-root-x1-cross-signed.cer';
	SendListThirdPartyToPanel_0.CertificateName[5] := 'e5.cer';
	SendListThirdPartyToPanel_0.CertificateName[6] := '1282303295.crt';
	SendListThirdPartyToPanel_0.Simulated := DiagCpuIsARsim();
	
END_PROGRAM

PROGRAM _CYCLIC

	SendListThirdPartyToPanel_0(); // Use .Execute=TRUE to start the transfer when file device ready
	
END_PROGRAM
```

### 
