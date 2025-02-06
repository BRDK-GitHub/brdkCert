
FUNCTION_BLOCK SendListThirdPartyToPanel
	
	IF NOT Execute AND state > 0 THEN
		state := 222; // will reset everything and return to state 0
	END_IF
	
	CASE state OF
		
		0:
			IF Execute THEN	
				brsmemset(ADR(certBuffer),0,SIZEOF(certBuffer));
				
				// Connect to panel usershare
				cifsParam := CONCAT('/SIP=',PanelEndpoint);
				cifsParam := CONCAT(cifsParam,' /PROTOCOL=cifs /SHARE=usershare /USER=');
				CASE PanelType OF
					BRDK_CERT_T30: 	cifsParam := CONCAT(cifsParam,'ppts30-user'); ;
					BRDK_CERT_T50:	cifsParam := CONCAT(cifsParam,'ppts50-user'); ;
					BRDK_CERT_T80: 	cifsParam := CONCAT(cifsParam,'ppt80-user'); ;
					BRDK_CERT_FT50: cifsParam := CONCAT(cifsParam,'pft50-user'); ;
					BRDK_CERT_MT50:	cifsParam := CONCAT(cifsParam,'pmt50-user'); ;
				END_CASE
				cifsParam := CONCAT(cifsParam,' /PASSWORD=');
				cifsParam := CONCAT(cifsParam,PanelPassword);
				
				IF Simulated THEN
					fileDeviceName := 'USER';		// Use existing 'USER' file device if simulated
					state := 20;
				ELSE
					fileDeviceName := 'PANEL';		// Create file device 'PANEL' to usershare if real hardware.
					state := 10;
				END_IF
	
			END_IF
		
		10:
			DevLink_0.enable := TRUE;
			DevLink_0.pDevice := ADR(fileDeviceName);
			DevLink_0.pParam := ADR(cifsParam);
			DevLink_0();
		
			IF DevLink_0.status = ERR_OK OR DevLink_0.status = fiERR_DEVICE_ALREADY_EXIST THEN
				handle := DevLink_0.handle;
				DevLink_0.enable := FALSE;
				DevLink_0();
				state := 20;
			ELSIF DevLink_0.status <> ERR_FUB_BUSY THEN
				state := 222;
			END_IF	
			
		20:		
			ArCertExportThirdParty_0.Execute := TRUE;
			ArCertExportThirdParty_0.Name := CertificateName;
			ArCertExportThirdParty_0.Data := ADR(certBuffer);
			ArCertExportThirdParty_0.DataSize := SIZEOF(certBuffer);
			ArCertExportThirdParty_0();
			
			IF ArCertExportThirdParty_0.Error THEN
				state := 222;
			ELSIF ArCertExportThirdParty_0.Done AND NOT ArCertExportThirdParty_0.Busy THEN
				ArCertExportThirdParty_0.Execute := FALSE;
				ArCertExportThirdParty_0();
				
				IF ArCertExportThirdParty_0.NeededDataSize > MAX_CERT_BUFFER_SIZE_IDX THEN
					// If certificate size is bigger than the buffer we can't store it.
					BufferTooSmall := TRUE;
					state := 222;
				ELSE
					state := 30;
				END_IF
				
			END_IF
			
		30:
			DirCreate_0.enable := TRUE;
			DirCreate_0.pDevice := ADR(fileDeviceName);
			DirCreate_0.pName := ADR('cert');
			DirCreate_0();
			
			IF DirCreate_0.status = ERR_OK OR DirCreate_0.status = fiERR_DIR_ALREADY_EXIST THEN
				DirCreate_0.enable := FALSE;
				DirCreate_0();
				filePath := CONCAT('cert\',CertificateName);
				state := 40;
			ELSIF DirCreate_0.status <> ERR_FUB_BUSY THEN
				state := 222;
			END_IF
			
		40:
			FileCreate_0.enable := TRUE;
			FileCreate_0.pDevice := ADR(fileDeviceName);
			FileCreate_0.pFile := ADR(filePath);
			FileCreate_0();
			
			IF FileCreate_0.status = ERR_OK THEN
				fileIdent := FileCreate_0.ident;
				FileCreate_0.enable := FALSE;
				FileCreate_0();
				state := 60;
			ELSIF FileCreate_0.status = fiERR_EXIST THEN
				// File already exist -> use FileOpen instead.
				FileCreate_0.enable := FALSE;
				FileCreate_0();
				state := 50;
			ELSIF FileCreate_0.status <> ERR_FUB_BUSY THEN
				state := 222;
			END_IF
			
		50:
			FileOpen_0.enable := TRUE;
			FileOpen_0.pDevice := ADR(fileDeviceName);
			FileOpen_0.pFile := ADR(filePath);
			FileOpen_0.mode := FILE_W;
			FileOpen_0();
			
			IF FileOpen_0.status = ERR_OK THEN
				fileIdent := FileOpen_0.ident;
				FileOpen_0.enable := FALSE;
				FileOpen_0();
				state := 60;
			ELSIF FileOpen_0.status <> ERR_FUB_BUSY THEN
				state := 222;
			END_IF
			
		60:
			FileWriteEx_0.enable := TRUE;
			FileWriteEx_0.ident := fileIdent;
			FileWriteEx_0.pSrc := ADR(certBuffer);
			FileWriteEx_0.len := ArCertExportThirdParty_0.NeededDataSize;
			FileWriteEx_0.option := fiTruncate; // Will truncate (remove) any existing bytes after "FileWriteEx_0.len" 
			FileWriteEx_0();
			
			IF FileWriteEx_0.status = ERR_OK THEN
				FileWriteEx_0.enable := FALSE;
				FileWriteEx_0();
				state := 70;
			ELSIF FileWriteEx_0.status <> ERR_FUB_BUSY THEN
				state := 222;
			END_IF
				
		70: 
			FileClose_0.enable := TRUE;
			FileClose_0.ident := fileIdent;
			FileClose_0();
			
			IF FileClose_0.status = ERR_OK THEN
				FileClose_0.enable := FALSE;
				FileClose_0();
				state := SEL(Simulated,80,90);
			ELSIF FileClose_0.status <> ERR_FUB_BUSY THEN
				state := 222;
			END_IF
			
		80:
			DevUnlink_0.enable := TRUE;
			DevUnlink_0.handle := handle;
			DevUnlink_0();
			
			IF DevUnlink_0.status = ERR_OK THEN
				DevUnlink_0.enable := FALSE;
				DevUnlink_0();
				state := 90;
			ELSIF DevUnlink_0.status <> ERR_FUB_BUSY THEN
				state := 222;
			END_IF
			
		90:
			
			Done := TRUE;
			
			IF NOT Execute THEN
				Done := FALSE;
				state := 0;
			END_IF
		
		222:
			
			Error := TRUE;
			
			IF NOT Execute THEN
				// Reset everything
				ArCertExportThirdParty_0.Execute := FALSE;
				ArCertExportThirdParty_0();
				DevLink_0.enable := FALSE;
				DevLink_0();
				DirCreate_0.enable := FALSE;
				DirCreate_0();
				FileDelete_0.enable := FALSE;
				FileDelete_0();
				FileCreate_0.enable := FALSE;
				FileCreate_0();
				FileOpen_0.enable := FALSE;
				FileOpen_0();
				FileWriteEx_0.enable := FALSE;
				FileWriteEx_0();
				FileClose_0.enable := FALSE;
				FileClose_0();
				DevUnlink_0.enable := FALSE;
				DevUnlink_0();
	
				BufferTooSmall := FALSE;
				Error := FALSE;
				Done := FALSE;
				state := 0;
			END_IF
			
		
	END_CASE
	

	
END_FUNCTION_BLOCK
