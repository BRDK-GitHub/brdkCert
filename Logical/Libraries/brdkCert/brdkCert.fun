
FUNCTION_BLOCK SendThirdPartyToPanel (*Will send a certificate from Third Party directry in AS to panel (ex. T80)*)
	VAR_INPUT
		Execute : BOOL;
		PanelEndpoint : STRING[16]; (*Endpoint to panel (IP)*)
		PanelType : brdk_cert_panel_type_typ;
		PanelPassword : STRING[10]; (*Password for usershare (configured in panel service menu)*)
		CertificateName : STRING[80]; (*'Example.cer" or "Example.crt"*)
		Simulated : BOOL;
	END_VAR
	VAR_OUTPUT
		Done : BOOL;
		Error : BOOL;
		BufferTooSmall : BOOL; (*Buffer too small for used certificate. Please increase "MAX_CERT_BUFFER_SIZE_IDX"*)
	END_VAR
	VAR
		state : USINT;
		ArCertExportThirdParty_0 : ArCertExportThirdParty;
		DevLink_0 : DevLink;
		DirCreate_0 : DirCreate;
		FileDelete_0 : FileDelete;
		FileCreate_0 : FileCreate;
		FileOpen_0 : FileOpen;
		FileWriteEx_0 : FileWriteEx;
		FileClose_0 : FileClose;
		DevUnlink_0 : DevUnlink;
		handle : UDINT;
		cifsParam : STRING[120]; (*Parameters to connect to panel usershare*)
		certBuffer : ARRAY[0..MAX_CERT_BUFFER_SIZE_IDX] OF USINT; (*Increase if certificate size exceeds "MAX_CERT_BUFFER_SIZE"*)
		filePath : STRING[50];
		fileIdent : UDINT;
		fileDeviceName : STRING[10];
	END_VAR
END_FUNCTION_BLOCK
