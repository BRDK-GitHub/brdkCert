
PROGRAM _INIT

	SendThirdPartyToPanel_0.PanelEndpoint := '192.168.30.222';
	SendThirdPartyToPanel_0.PanelType := BRDK_CERT_FT50;
	SendThirdPartyToPanel_0.PanelPassword := '1234';
	SendThirdPartyToPanel_0.CertificateName := 'e6.cer';
	
	SendThirdPartyToPanel_0.Simulated := DiagCpuIsARsim();
END_PROGRAM

PROGRAM _CYCLIC

	SendThirdPartyToPanel_0();
	
END_PROGRAM

PROGRAM _EXIT

	 
END_PROGRAM

