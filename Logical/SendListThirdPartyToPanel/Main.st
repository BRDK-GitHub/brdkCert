
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

	SendListThirdPartyToPanel_0();
	
END_PROGRAM

PROGRAM _EXIT

	 
END_PROGRAM

