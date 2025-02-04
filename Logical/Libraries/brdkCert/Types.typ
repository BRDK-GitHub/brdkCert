
TYPE
	brdk_cert_panel_type_typ : 
		( (*Panel type.*)
		BRDK_CERT_NOT_IDENTIFIED := 0, (*Not identified.*)
		BRDK_CERT_T30 := 1, (*T30 panel.*)
		BRDK_CERT_T50 := 2, (*T50 panel.*)
		BRDK_CERT_T80 := 3, (*T80 panel.*)
		BRDK_CERT_FT50 := 4, (*FT50 panel.*)
		BRDK_CERT_MT50 := 5 (*MT50 panel.*)
		) := BRDK_CERT_NOT_IDENTIFIED;
END_TYPE
