     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Movements Status - Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEMVTSVAL - Movements Status - Validations             *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE039  *CREATE    Date 17Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE039 - Automatic Settlement of Trades                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEMVTSL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEMVTSD0:SEMVTSD2)
      ** Movements Status - Omit Midas-Generated Records
 
      /COPY WNCPYSRC,SEMVTSV001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D CurTrnDets    E DS                  EXTNAME(SEMVTS1PD) PREFIX(C_)
      ** SEMVTS Transaction Details in screen format
      ** Current state (i.e. before any amendment)
 
     D APITrnDets    E DS                  EXTNAME(SEMVTS1PD)
      ** SEMVTS Transaction Details in screen format
 
     D OScrnFlds     E DS                  EXTNAME(SEMVTS2PD)
      ** SEMVTS Output only Screen Fields
 
     D OKTrnDets     E DS                  EXTNAME(SEEMVTSPD)
      ** Transaction Details OK indicators
 
     D ValidMVTS     E DS                  EXTNAME(SEVMVTSPD)
      ** Valid Transaction Details layout
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SdSCOD        E DS                  EXTNAME(SDSCODPD)
      ** SWIFT Status and Reason Codes
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short DS for access programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long DS for access programs
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Alternate arrays of Midas-generated Status Codes and Narratives
      ** and their related index
     D MidasGCod       S              4A   DIM(12) CTDATA PERRCD(1)
     D MidasGNar       S             60A   DIM(12) ALT(MidasGCod)
     D MGi             S              3P 0
 
      ** Index for error message arrays
     D Idx             S              3P 0
     D SavIdx          S              3P 0
 
      ** Index for warning message arrays
     D WIdx            S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      /COPY WNCPYSRC,SEMVTSV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SEMVTSV003
 
      ** Initializations
      *
     C                   EXSR      INIT
 
      ** When the calling module is "*CTL" or "*RPR" and the mode is "Amend",
      ** we must first verify that only amendable fields are modified.
      ** The problem can't arise in the SIN function, as only the amendable
      ** fields are input-capable.
      ** When the caller is "*CTL", an individual error message is sent for
      ** each modified non-amendable field.
      ** When the caller is "*RPR", these fields are reset to their current
      ** value, and a global error message is sent to inform the user.
      *
     C                   IF        DDACTN = 'A' AND
     C                             (CallerCode = '*CTL' OR CallerCode = '*RPR')
     C                   EVAL      SavIdx = Idx
     C                   EXSR      ValAmdFlds
      *
     C                   IF        SavIdx <> Idx AND CallerCode = '*CTL'
     C                   GOTO      EndMod
     C                   ENDIF
      *
     C                   ENDIF
 
      ** Validate Notification Date
      *
      /COPY WNCPYSRC,SEMVTSV004
     C                   IF        DDACTN = 'I'
     C                   EXSR      ValNTDT
     C                   ENDIF
      /COPY WNCPYSRC,SEMVTSV005
 
      ** Validate Notification Method
      *
      /COPY WNCPYSRC,SEMVTSV006
     C                   EXSR      ValNTMT
      /COPY WNCPYSRC,SEMVTSV007
 
      ** Validate SWIFT Status code
      *
      /COPY WNCPYSRC,SEMVTSV008
     C                   EXSR      ValSWSC
      /COPY WNCPYSRC,SEMVTSV009
 
      ** Validate SWIFT Reason code
      *
      /COPY WNCPYSRC,SEMVTSV010
     C                   EXSR      ValSWRC
      /COPY WNCPYSRC,SEMVTSV011
 
      ** Validate Message Key
      *
      /COPY WNCPYSRC,SEMVTSV012
     C                   EXSR      ValMSGK
      /COPY WNCPYSRC,SEMVTSV013
 
      ** Validate Input Origin
      *
      /COPY WNCPYSRC,SEMVTSV014
     C                   EXSR      ValINOR
      /COPY WNCPYSRC,SEMVTSV015
 
      ** Validate Settlement Confirmation Requested
      *
      /COPY WNCPYSRC,SEMVTSV016
     C                   EXSR      ValSCRQ
      /COPY WNCPYSRC,SEMVTSV017
 
      ** Validate Settlement Message Generated
      *
      /COPY WNCPYSRC,SEMVTSV018
     C                   EXSR      ValSTMG
      /COPY WNCPYSRC,SEMVTSV019
 
      ** Validate Narrative
      *
      /COPY WNCPYSRC,SEMVTSV020
     C                   EXSR      ValNARR
      /COPY WNCPYSRC,SEMVTSV021
 
     C     EndMod        TAG
      *
     C                   RETURN
 
      /COPY WNCPYSRC,SEMVTSV022
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValAmdFlds - Validate amended fields
      *****************************************************************
     C     ValAmdFlds    BEGSR
      *
     C                   MOVE      'N'           ErrorFound        1
      *
      ** Input origine can never be changed
      *
 B1  C                   IF        DDINOR <> C_DDINOR
      *
 B2  C                   IF        CallerCode = '*CTL'
     C                   EVAL      DDINOROK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDINOR'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03914'
     C   99              EVAL      MsgDtaArr(Idx)  = 'Input Origin'
 X2  C                   ELSE
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      DDINOR = C_DDINOR
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Some fields are non amendable only when the Input Origin isn't "Manual"
      *
 B1  C                   IF        C_DDINOR <> 'MANUAL'
      *
      ** -- Notification method
      *
 B2  C                   IF        DDNTMT <> C_DDNTMT
      *
 B3  C                   IF        CallerCode = '*CTL'
     C                   EVAL      DDNTMTOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDNTMT'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03914'
     C   99              EVAL      MsgDtaArr(Idx)  = 'Notification Method'
 X3  C                   ELSE
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      DDNTMT = C_DDNTMT
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
      ** -- SWIFT Status Code
      **    Note that the description may be wrong, due to the CVT module
      **    having used the wrong code to find it
      *
 B2  C                   IF        DDSWSC <> C_DDSWSC
      *
 B3  C                   IF        CallerCode = '*CTL'
     C                   EVAL      DDSWSCOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDSWSC'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03914'
     C   99              EVAL      MsgDtaArr(Idx)  = 'SWIFT Status Code'
 X3  C                   ELSE
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      DDSWSC = C_DDSWSC
     C                   EXSR      SWSCDesc
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
      ** -- SWIFT Reason Code
      **    Note that the description may be wrong, due to the CVT module
      **    having used the wrong code to find it
      *
 B2  C                   IF        DDSWRC <> C_DDSWRC
      *
 B3  C                   IF        CallerCode = '*CTL'
     C                   EVAL      DDSWRCOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDSWRC'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03914'
     C   99              EVAL      MsgDtaArr(Idx)  = 'SWIFT Reason Code'
 X3  C                   ELSE
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      DDSWRC = C_DDSWRC
     C                   EXSR      SWRCDesc
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
      ** -- Message Key
      *
 B2  C                   IF        DDMSGK <> C_DDMSGK
      *
 B3  C                   IF        CallerCode = '*CTL'
     C                   EVAL      DDMSGKOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDMSGK'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03914'
     C   99              EVAL      MsgDtaArr(Idx)  = 'Message Key'
 X3  C                   ELSE
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      DDMSGK = C_DDMSGK
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Send a global information message if needed
      *
     C                   IF        ErrorFound = 'Y'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = '*ANY'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03916'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SWSCDesc - Retrieve the description of the SWIFT Status Code
      *****************************************************************
     C     SWSCDesc      BEGSR
      *
      ** Midas-generated codes are tested first, and the access object
      ** is called only if not found.
      ** In this later case, and for the "RPLY" status code only, we need
      ** to replace the "xxxx" of its narrative with the status code of
      ** the first non-Midas-generated record prior to the current one.
      *
     C                   MOVE      'N'           MidasGenC         1
     C                   EVAL      MGi = 1
     C     DDSWSC        LOOKUP    MidasGCod(MGi)                         99
      *
 B1  C                   IF        *IN99
     C                   EVAL      DDSWSN = MidasGNar(MGi)
     C                   MOVE      'Y'           MidasGenC
 X1  C                   ELSE
     C                   CALLB     'AOSCODR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C     DDSWSC        PARM      DDSWSC        @Code             4
     C                   PARM      'S'           @CdTp             1
     C                   PARM      *Blanks       @CdDp             4
     C     SdSCOD        PARM      SdSCOD        DSFDY
      *
 B2  C                   IF        @RtCd = *Blanks
      *
 B3  C                   IF        DDSWSC = 'RPLY'
     C     KSEMVTSL2_1   SETGT     SEMVTSD2
     C     KSEMVTSL2_2   READE     SEMVTSD2                               99
      *
 B4  C                   IF        NOT *IN99
     C                   EVAL      DDSWSN = %Replace(%Trim(TMSWSC):SRCDNR:
     C                                               %Scan('xxxx':SRCDNR):4)
 X4  C                   ELSE
     C                   EVAL      DDSWSN = %Replace('????':SRCDNR:
     C                                               %Scan('xxxx':SRCDNR):4)
 E4  C                   ENDIF
      *
 X3  C                   ELSE
     C                   EVAL      DDSWSN = SRCDNR
 E3  C                   ENDIF
      *
 X2  C                   ELSE
      *
 B3  C                   IF        DDSWSC <> *Blanks
     C                   EVAL      DDSWSN = *ALL'?'
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SWRCDesc - Retrieve the description of the SWIFT Reason Code
      *****************************************************************
     C     SWRCDesc      BEGSR
      *
     C                   CALLB     'AOSCODR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C     DDSWRC        PARM      DDSWRC        @Code             4
     C                   PARM      'R'           @CdTp             1
     C                   PARM      DDSWSC        @CdDp             4
     C     SdSCOD        PARM      SdSCOD        DSFDY
      *
     C                   IF        @RtCd = *Blanks
     C                   EVAL      DDSWRN = SRCDNR
     C                   ELSE
      *
     C                   IF        DDSWRC <> *Blanks
     C                   EVAL      DDSWRN = *ALL'?'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValNTDT - Validate Notification Date
      *****************************************************************
     C     ValNTDT       BEGSR
      *
      ** Must be a valid date
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      DDNTDT        DateIn            6
     C     VTMNTDT       PARM                    DaynoOut          5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ErrorFlag         1
      *
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      DDNTDTOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDNTDT'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03917'
     C                   GOTO      EVlNTDT
     C                   ENDIF
      *
      ** Can not be after the Run Date, except for a Depot Movement when
      ** CSE015 is on
      *
     C                   IF        VTMNTDT > BJRDNB AND
     C                             (DDTRTY <> 'W' OR CSE015 = 'N')
     C                   EVAL      DDNTDTOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDNTDT'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03918'
     C                   GOTO      EVlNTDT
     C                   ENDIF
      *
      ** Can not be before the Trade or Depot Movement Date
      ** (Retrieved by the RTT module and passed by the caller)
      *
     C                   IF        VTMNTDT < P@TRDT
     C                   EVAL      DDNTDTOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDNTDT'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03919'
     C                   ENDIF
      *
     C     EVlNTDT       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValNTMT - Validate Notification Method
      *****************************************************************
     C     ValNTMT       BEGSR
      *
      ** Question mark to pick up a value in a list
      *
     C                   IF        %Scan('?':DDNTMT) > 0
     C                   CALL      'Y2VLLSR'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      1215100       @Y2LS             7 0
     C     DDNTMT        PARM      *Blanks       @INVL            20
     C                   ENDIF
      *
      ** Validate the field
      *
     C                   CALL      'Y2RVCNR'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      1215100       @Y2LS
     C                   PARM      DDNTMT        @INVL
     C                   PARM      *Blanks       @VLMP             1
     C                   PARM                    @TEXT            50
      *
     C                   IF        @Rtcd <> *BLANKS
     C                   EVAL      DDNTMTOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDNTMT'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03920'
     C                   GOTO      EVlNTMT
     C                   ENDIF
      *
      ** The field is valid
      *
     C                   EVAL      VTMNTMT = DDNTMT
      *
     C     EVlNTMT       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValSWSC - Validate SWIFT Status Code
      *****************************************************************
     C     ValSWSC       BEGSR
      *
      ** Retrieve the status code description
      *
     C                   EXSR      SWSCDesc
      *
      ** If not found
      *
     C                   IF        MidasGenC = 'N' AND @RtCd <> *Blanks
     C                   EVAL      DDSWSCOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDSWSC'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03921'
     C                   GOTO      EVlSWSC
     C                   ENDIF
      *
      ** A Midas-generated code can not be used when the input origin is "MANUAL"
      *
     C                   IF        MidasGenC = 'Y' AND DDINOR = 'MANUAL'
     C                   EVAL      DDSWSCOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDSWSC'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03922'
     C                   GOTO      EVlSWSC
     C                   ENDIF
      *
      ** The field is valid
      *
     C                   EVAL      VTMSWSC = DDSWSC
      *
     C     EVlSWSC       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValSWRC - Validate SWIFT Reason Code
      *****************************************************************
     C     ValSWRC       BEGSR
      *
      ** Should be blank for a Midas-generated Status Code
      *
     C                   IF        DDSWRC <> *Blanks AND MidasGenC = 'Y'
     C                   EVAL      DDSWRCOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDSWRC'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03923'
     C                   GOTO      EVlSWRC
     C                   ENDIF
      *
      ** Retrieve the reason code description
      *
     C                   IF        MidasGenC <> 'Y'
      *
     C                   EXSR      SWRCDesc
      *
      ** If not found
      *
     C                   IF        @RtCd <> *Blanks
     C                   EVAL      DDSWRCOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDSWRC'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03924'
     C                   GOTO      EVlSWRC
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** The field is valid
      *
     C                   EVAL      VTMSWRC = DDSWRC
      *
     C     EVlSWRC       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValMSGK - Validate Message Key
      *****************************************************************
     C     ValMSGK       BEGSR
      *
      ** The field is always valid
      *
     C                   EVAL      VTMMSGK = DDMSGK
      *
     C     EVlMSGK       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValINOR - Validate Input Origin
      *****************************************************************
     C     ValINOR       BEGSR
      *
      ** The field is always valid
      *
     C                   EVAL      VTMINOR = DDINOR
      *
     C     EVlINOR       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValSCRQ - Validate Settlement Confirmation Requested Indicator
      *****************************************************************
     C     ValSCRQ       BEGSR
      *
      ** The only valid values are "Y", "N" and blank
      *
     C                   IF        DDSCRQ <> 'Y' AND
     C                             DDSCRQ <> 'N' AND
     C                             DDSCRQ <> *Blanks
     C                   EVAL      DDSCRQOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDSCRQ'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03926'
     C                   GOTO      EVlSCRQ
     C                   ENDIF
      *
      ** The field is valid
      *
     C                   EVAL      VTMSCRQ = DDSCRQ
      *
     C     EVlSCRQ       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValSTMG - Validate Settlement Message Generated Indicator
      *****************************************************************
     C     ValSTMG       BEGSR
      *
      ** The only valid values are "Y", "N" and blank
      *
     C                   IF        DDSTMG <> 'Y' AND
     C                             DDSTMG <> 'N' AND
     C                             DDSTMG <> *Blanks
     C                   EVAL      DDSTMGOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDSTMG'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03927'
     C                   GOTO      EVlSTMG
     C                   ENDIF
      *
      ** The field is valid
      *
     C                   EVAL      VTMSTMG = DDSTMG
      *
     C     EVlSTMG       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValNARR - Validate Narrative
      *****************************************************************
     C     ValNARR       BEGSR
      *
      ** The field is mandatory when the reason code is "NARR"
      *
     C                   IF        DDSWRC = 'NARR' AND DDNARR = *Blanks
     C                   EVAL      DDNARROK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDNARR'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE03933'
     C                   GOTO      EVlNARR
     C                   ENDIF
      *
      ** The field is valid
      *
     C                   EVAL      VTMNARR = DDNARR
      *
     C     EVlNARR       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initializations                                        *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Valid file keys in Insert mode (except notification date, which
      ** will be validated and set up later)
      ** The sequence number will be correctly set up by the UPD module
      *
 B1  C                   IF        DDACTN = 'I'
      *
 B2  C                   IF        DDTRRF <> *Blanks
     C                   EVAL      VTMTRRF = DDTRRF
 X2  C                   ELSE
     C                   EVAL      VTMTRRF = DDWIOR
 E2  C                   ENDIF
      *
     C                   EVAL      VTMTRTY = DDTRTY
     C                   EVAL      VTMSQNR = 999
 E1  C                   ENDIF
      *
      /COPY WNCPYSRC,SEMVTSV023
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS
      ** Transaction Details in screen format
     C                   PARM                    APITrnDets
      ** Output only Screen Fields
     C                   PARM                    OScrnFlds
      ** Current Transaction Details in screen format
     C                   PARM                    CurTrnDets
      ** Calling Module Code (*SIN, *RPR, etc...)
     C                   PARM                    CallerCode        4
      ** Date of the linked Transaction
     C                   PARM                    P@TRDT            5 0
      *
      ** OUTPUT PARAMETERS
      ** Transaction Details OK inds
     C                   PARM                    OKTrnDets
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** Valid Transaction details layout (DS) from/to caller
     C                   PARM                    ValidMVTS
      *
      ** Defines KLIST's
      *
     C     KSEMVTSL2_1   KLIST
     C                   KFLD                    VTMTRRF
     C                   KFLD                    VTMTRTY
     C                   KFLD                    VTMNTDT
     C                   KFLD                    VTMSQNR
      *
     C     KSEMVTSL2_2   KLIST
     C                   KFLD                    VTMTRRF
     C                   KFLD                    VTMTRTY
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C                   IF        @RtCd <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EVAL      DBKEY  = @Optn
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check if switchable feature CSE015 is switched on
      ** (Forward valued depot movements)
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CSE015'      @SARD
      *
      ** Database Error
      *
     C                   IF        @RtCd <> *Blanks AND
     C                             @RtCd <> '*NRF   '
     C                   EVAL      DBKEY  = 'CSE015'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 901
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        @RtCd = *Blanks
     C                   MOVE      'Y'           CSE015            1
     C                   ELSE
     C                   MOVE      'N'           CSE015
     C                   ENDIF
      *
      /COPY WNCPYSRC,SEMVTSV024
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2003
**CTDATA MidasGCod
INS Inserted                                                    :
AMD Amended                                                     :
CHG Changed                                                     :
APP Approved                                                    :
AUT Authorised                                                  :
DEL Deleted                                                     :
RVD Reversed Deletion                                           :
PST Partial Settlement                                          :
RVS Reversed Settlement                                         :
SET Fully Settled                                               :
CST Contractual Settlement                                      :
VAL Validation Failure                                          :
