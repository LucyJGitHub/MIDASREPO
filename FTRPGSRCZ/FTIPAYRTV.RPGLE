     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments retrieve + actn/key val')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAYRTV - Incoming Payments Retrieve and Action Code/Key   *
      *              Validation                                       *
      *                                                               *
      *  Function: This module retrieves the Incoming Payment         *
      *            from the database.  As it does, it validates the   *
      *            Action Code and Payment Reference.  Also, it       *
      *            validates the Booking and Originating Branches.    *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                FTIPAYUPC                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055030           Date 27Apr30               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD027200           Date 20Sep16               *
      *                 MD030957           Date 10Oct14               *
      *                 CFT157             Date 29Aug14               *
      *                 MD025674           Date 25Mar14               *
      *                 MD000091           Date 07May13               *
      *                 CFT120             Date 28Sep12               *
      *                 261468             Date 10Aug12               *
      *                 CSC054             Date 23Feb12               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      *                 257673             Date 14Nov08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247277             Date 24May07               *
      *                 247448             Date 30Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSC024             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 25Aug03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May99               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055030 -  Issue on job names during SSL enabling of JDBC   *
      *              calls (Child: AR1088820)                         *
      *            - Applied for MD055645.
      *  MD046248 - Finastra Rebranding                               *
      *  MD027200 - Record locking when amending and deleting pay-    *
      *             ment. Reverse fix 261468 in this module only.     *
      *           - Applied for MD040962                              *
      *  MD030957 - Stop Request against already Stopped Transaction  *
      *             is allowed                                        *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *  MD025674 - Event code not found for Amend and Record in Use  *
      *             for Delete                                        *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  261468 - Multiple access of the same payment should not be   *
      *           allowed                                             *
      *  CSC054 - Period End Adjustments                              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  257673 - Remove checking of action code 'X' for the user who *
      *           routes an incoming message.                         *
      *  247277 - Allow for native JDBC driver as well as toolbox.    *
      *  247448 - Messages routed to IPAYs cannot be amended          *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSC024 - Open Month End                                      *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Thin Client API Wrappers                            *
      *           Also perform extra branch validation if module      *
      *           is called from Midas Plus interface.                *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Incoming Payments by Payment Reference
     FINPAY     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Incoming Payments by Front Office Id
     FINPAYL0   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(INPAYDDF:INPAYFOI)
      *                                                                         CFT014
      ** Incoming Payments Extension by Payment Reference                       CFT014
     FINPAYXL0  IF   E           K DISK    INFSR(*PSSR)                         CFT014
      *
     F/COPY WNCPYSRC,FTIPAYIF01
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
                                                                                              CSC024
      ** System Values Array                                                                  CSC024
     D*SysValOME       C                   CONST('OMEIndicator')                       CSC024 CSC054
     D SysValPEA       C                   CONST('PEAIndicator')                              CSC054
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Payments retrieved from file - file format
     D INPAYFmt      E DS                  EXTNAME(INPAYDD)
      *
      ** Incoming Payments retrieved from file - file format
      ** This DS will be passed to the calling module.
     D CrIPFilFmt    E DS                  EXTNAME(INPAYDD)
     D                                     PREFIX(CR)
      *                                                                         CFT014
      ** Incoming Payments (additional details) retrieved from file             CFT014
      ** - file format. This DS will be passed to the calling module.           CFT014
     D CrIP2FilFmt   E DS                  EXTNAME(INPAYXPD)                    CFT014
      *
      ** Externally described DS for Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D/COPY WNCPYSRC,FTH00443
      *                                                                                       CSC024
      ** Externally described DS for SAR details                                              CSC024
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC024
     D SLCD          E                     EXTFLD(LCD)                                        CSC024
     D RUNDAT        E DS                  EXTNAME(RUNDAT)                                    CFT157
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc.
     D IDx             S              3P 0
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     D CSC054          S              1A                                                      CSC054
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise.
      *
     C                   EXSR      SRInit
      *
      ** If the mode is 'Front Office Transaction Interface',
      ** do (extra) validation for Front Office Transaction Interface.
      *
     C     PMode         IFEQ      '*FRONT'
     C                   EXSR      SRValFrnt
      *
      ** No further validation if errors occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKPREF        OREQ      'N'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Action Code and Payment Reference.
      *
     C                   EXSR      SRValAct
      *
      ** No further validation if errors occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKPREF        OREQ      'N'
     C                   RETURN
     C                   ENDIF
      *
      ** Additional validation for Insert.
      *
     C     DDACTN        IFEQ      'I'
     C                   EXSR      SRValIns
     C                   ENDIF
      *
      ** Additional validation for Amend.
      *
     C     DDACTN        IFEQ      'A'
     C                   EXSR      SRValAmd
     C                   ENDIF
      *
      ** Additional validation for Delete.
      *
     C     DDACTN        IFEQ      'D'
     C                   EXSR      SRValDel
     C                   ENDIF
      *
      ** Additional validation for Enquire.
      *
     C     DDACTN        IFEQ      'E'
     C                   EXSR      SRValEnq
     C                   ENDIF
     C/COPY WNCPYSRC,FTIPAYIC01
     C     DDACTN        IFEQ      'S'                                                        CFT157
     C     CFT157        ANDEQ     'Y'                                                        CFT157
     C                   EXSR      SRValStp                                                   CFT157
     C                   END                                                                  CFT157
      *                                                                                       CFT157
      *
      ** If Action is not Insert, or Action is Insert and
      ** entry point is Level 2, move file values to
      ** output parameter if Action Code and Payment
      ** Reference are valid.
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        OREQ      'I'
     C     PParmLevel    ANDEQ     '2'
      *
     C     OKACTN        IFNE      'N'
     C     OKPREF        ANDNE     'N'
     C                   MOVE      INPAYFmt      CrIPFilFmt
      *                                                                         CFT014
      ** Retrieve additional details for Payment Reference.                     CFT014
     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'                 CFT014
     C                             OR CFT009 = 'Y'                              CFT009
     C     DDPREF        CHAIN     INPAYXL0                           01        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** No further validation if errors occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKPREF        OREQ      'N'
     C                   RETURN
     C                   ENDIF
      *
      ** Access Security Checking.
      *
     C     PResponse     IFEQ      'S'
     C                   EXSR      SRAcsSec
     C                   ENDIF
      *
      ** Return.
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Routine to initialise fields                        *
      *                                                               *
      *****************************************************************
      *
     C     SRInit        BEGSR
      *
     C                   CLEAR                   CrIPFilFmt
     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'                 CFT014
     C                             OR CFT009 = 'Y'                              CFT009
     C                   CLEAR                   CrIP2FilFmt                    CFT014
     C                   ENDIF                                                  CFT014
      *
      ** Zeroise all numeric fields in CrIPFilFmt.
      *
     C***********        Z-ADD     *ZERO         CrRCCO                                       CSD027
     C                   MOVE      *BLANKS       CrRCCO                                       CSD027
     C                   Z-ADD     *ZERO         CrSMAM
     C                   Z-ADD     *ZERO         CrSMAMD
     C                   Z-ADD     *ZERO         CrMDIN
     C                   Z-ADD     *ZERO         CrRATE
     C                   Z-ADD     *ZERO         CrRATED
     C                   Z-ADD     *ZERO         CrPYAM
     C                   Z-ADD     *ZERO         CrPYAMD
     C                   Z-ADD     *ZERO         CrSLDT
     C                   Z-ADD     *ZERO         CrSLDTD1
     C                   Z-ADD     *ZERO         CrSLDTD2
     C                   Z-ADD     *ZERO         CrSLDTD3
     C                   Z-ADD     *ZERO         CrPVDT
     C                   Z-ADD     *ZERO         CrPVDTD1
     C                   Z-ADD     *ZERO         CrPVDTD2
     C                   Z-ADD     *ZERO         CrPVDTD3
     C                   Z-ADD     *ZERO         CrSWPC
     C                   Z-ADD     *ZERO         CrDNBC
     C                   Z-ADD     *ZERO         CrTRCM
     C                   Z-ADD     *ZERO         CrTRCMD
     C                   Z-ADD     *ZERO         CrTXCH
     C                   Z-ADD     *ZERO         CrTXCHD
     C                   Z-ADD     *ZERO         CrCQCH
     C                   Z-ADD     *ZERO         CrCQCHD
     C                   Z-ADD     *ZERO         CrADCH
     C                   Z-ADD     *ZERO         CrADCHD
     C                   Z-ADD     *ZERO         CrTLCH
     C                   Z-ADD     *ZERO         CrTLCHD
     C                   Z-ADD     *ZERO         CrMSCH
     C                   Z-ADD     *ZERO         CrMSCHD
     C***********        Z-ADD     *ZERO         CrCDRO                                       CSD027
     C                   MOVE      *BLANKS       CrCDRO                                       CSD027
     C                   MOVE      *BLANKS       CrINCDRC                                     CFT120
     C                   Z-ADD     *ZERO         CrLCHT
     C                   Z-ADD     *ZERO         CrLCD
     C                   Z-ADD     *ZERO         CrOEDT
     C                   Z-ADD     *ZERO         CrOEDTD1
     C                   Z-ADD     *ZERO         CrOEDTD2
     C                   Z-ADD     *ZERO         CrOEDTD3
     C                   Z-ADD     *ZERO         CrSBCQ
     C                   Z-ADD     *ZERO         CrPBCQ
     C                   Z-ADD     *ZERO         CrSRTE
     C                   Z-ADD     *ZERO         CrPRTE
     C                   Z-ADD     *ZERO         CrDUMA1
     C                   Z-ADD     *ZERO         CrDUMA2
     C                   Z-ADD     *ZERO         CrDUMA3
     C                   Z-ADD     *ZERO         CrDUMA4
     C                   Z-ADD     *ZERO         CrDUMA5
     C                   Z-ADD     *ZERO         CrDUMA6
     C                   Z-ADD     *ZERO         CrINMSGR
     C                   Z-ADD     *ZERO         CrINKPRT
     C                   Z-ADD     *ZERO         CrINCHCM
     C                   Z-ADD     *ZERO         CrINVATT
     C                   Z-ADD     *ZERO         CrINDUM7
     C                   Z-ADD     *ZERO         CrINDUM8
     C                   Z-ADD     *ZERO         CrINVATR
     C                   Z-ADD     *ZERO         CrFXMP
     C                   Z-ADD     *ZERO         CrFXMD
     C                   Z-ADD     *ZERO         CrMAMT
     C                   Z-ADD     *ZERO         CrNDAM
      *
     C                   MOVE      '00'          CrISEQ
      *
      ** Initialise VAT flags to 'Y' in CrIPFilFmt.
      *
     C     S01499        IFEQ      'Y'
     C                   MOVE      'Y'           CrINVAT1
     C                   MOVE      'Y'           CrINVAT2
     C                   MOVE      'Y'           CrINVAT3
     C                   MOVE      'Y'           CrINVAT4
     C                   MOVE      'Y'           CrINVAT5
     C                   MOVE      'Y'           CrINVAT6
     C     S01494        IFEQ      'Y'
     C                   MOVE      'Y'           CrINVAT7
     C                   ENDIF
     C                   ENDIF
      *
     C                   CLEAR                   INPAYFmt
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValFrnt - Routine to validate Front Office Transaction     *
      *              Interface                                        *
      *                                                               *
      *****************************************************************
      *
     C     SRValFrnt     BEGSR
      *
      ** Error if action code is not I(Insert), A(Amend), D(Delete)
      ** or E(Enquire).
      *
     C/COPY WNCPYSRC,FTH00444
      *                                                                                       CFT157
     C     CFT157        IFNE      'Y'                                                        CFT157
      *                                                                                       CFT157
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'FTA0101'
     C                   ENDIF
     C/COPY WNCPYSRC,FTH00445
      *                                                                                       CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
     C     CFT157        IFEQ      'Y'                                                        CFT157
     C     DDACTN        IFNE      'I'                                                        CFT157
     C     DDACTN        ANDNE     'A'                                                        CFT157
     C     DDACTN        ANDNE     'D'                                                        CFT157
     C     DDACTN        ANDNE     'E'                                                        CFT157
     C     DDACTN        ANDNE     'S'                                                        CFT157
     C                   MOVEL     'N'           OKACTN                                       CFT157
     C                   ADD       1             IDx                                          CFT157
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'                                 CFT157
     C                   EVAL      MsgIdArr(IDx) = '5047372'                                  CFT157
     C                   ENDIF                                                                CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
      *
      ** Error if Front Office Transaction Id is blank.
      *
     C     FOTRID        IFEQ      *BLANKS
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'APM0201'
     C                   ENDIF
      *
      ** No further validation if errors occurred.
      *
     C     OKACTN        IFEQ      'N'
     C                   GOTO      EValFrnt
     C                   ENDIF
      *
      ** Access Incoming Payments file using Front Office
      ** Transaction Id.
      *
     C     FOTRID        CHAIN     INPAYFOI                           01
      *
     C     DDACTN        IFEQ      'I'
      *
      ** Front Office Transaction Id can't be present already.
      *
     C     *IN01         IFEQ      *OFF
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'APM0102'
     C**********         EVAL      MsgDtaArr(IDx) = FOTRID                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr +%TRIM(FOTRID)                   MD000091
     C                   GOTO      EValFrnt
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If not insert, Front Office Transaction Id must be present.
      *
     C     *IN01         IFEQ      *ON
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'APM0103'
     C**********         EVAL      MsgDtaArr(IDx) = FOTRID                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr +%TRIM(FOTRID)                   MD000091
     C                   GOTO      EValFrnt
     C                   ENDIF
      *
      ** If not Insert, update Midas Payment Reference.
      *
     C                   MOVEL     PREF          DDPREF
     C                   ENDIF
      *
     C     EValFrnt      ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAct - Routine to validate Action Code and Payment       *
      *             Reference                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRValAct      BEGSR
      *
      ** Check if Action Code is blank.
      *
     C     DDACTN        IFEQ      *BLANK
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) =  'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'FTA0100'
     C                   GOTO      EValAct
     C                   ENDIF
      *
      ** Entry point is Level 1 Maintenance.
      *
     C     PParmLevel    IFEQ      '1'
      *
      ** Check if Action Code is valid.
      *
     C/COPY WNCPYSRC,FTH00446
      *                                                                                       CFT157
      *                                                                                       CFT157
     C     CFT157        IFNE      'Y'                                                        CFT157
      *                                                                                       CFT157
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C/COPY WNCPYSRC,FTIPAYIC02
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'FTA0101'
     C                   GOTO      EValAct
     C                   ENDIF
      *
     C/COPY WNCPYSRC,FTH00447
      *                                                                                       CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
     C     CFT157        IFEQ      'Y'                                                        CFT157
     C     DDACTN        IFNE      'I'                                                        CFT157
     C     DDACTN        ANDNE     'A'                                                        CFT157
     C     DDACTN        ANDNE     'D'                                                        CFT157
     C     DDACTN        ANDNE     'E'                                                        CFT157
     C     DDACTN        ANDNE     'S'                                                        CFT157
     C                   MOVEL     'N'           OKACTN                                       CFT157
     C                   ADD       1             IDx                                          CFT157
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'                                 CFT157
     C                   EVAL      MsgIdArr(IDx) = '5047372'                                  CFT157
     C                   GOTO      EValAct                                                    CFT157
     C                   ENDIF                                                                CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
      *
      ** Entry for Payment Reference is prohibited for Insert.
      ***Allow*entry*for*Payment*Reference*for*Insert*if*CSC024*is                     CSC024 CSC054
      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
      ** Allow entry for Payment Reference for Insert if CSC054 is                            CSC054
      ** switched on and running on PEA system.                                               CSC054
      *
     C     PPrefInsert   IFEQ      'Y'
      *
     C     DDACTN        IFEQ      'I'
     C     DDPREF        ANDNE     *BLANKS
     C     GENPREF       ANDEQ     'Y'                                                        CSC024
     C**********         MOVEL     'N'           OKPREF                                       247448
     C**********         ADD       1             IDx                                          247448
     C**********         EVAL      FldNameArr(IDx) = 'DDPREF'                                 247448
     C**********         EVAL      MsgIdArr(IDx) = 'FTA0102'                                  247448
     C**********         GOTO      EValAct                                                    247448
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Entry for Payment Reference is mandatory for Amend,
      ** Delete and Enquire.
      *
     C     DDACTN        IFNE      'I'
     C     DDPREF        ANDEQ     *BLANKS
     C                   MOVEL     'N'           OKPREF
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'
     C                   EVAL      MsgIdArr(IDx) = 'FTA0103'
     C                   GOTO      EValAct
     C                   ENDIF
      *
      ** Entry point is Level 2 Maintenance.
      *
     C                   ELSE
      *
      ** Error if Action Code is not I(Insert), A(Amend)
      ** or E(Enquire).
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'E'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'FTM2175'
     C                   ENDIF
      *
      ** Payment Reference must be existing.
      *
     C     DDPREF        CHAIN     INPAYDDF                           01
      *
     C     *IN01         IFEQ      *ON
     C                   MOVEL     'N'           OKPREF
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'
     C                   EVAL      MsgIdArr(IDx) = 'FTM2323'
     C**********         EVAL      MsgDtaArr(IDx) = DDPREF                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(DDPREF))                               MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr +%TRIM(DDPREF)                   MD000091
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EValAct       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValIns - Routine to validate Action Code 'I'               *
      *                                                               *
      *****************************************************************
      *
     C     SRValIns      BEGSR
      *
      ** Entry point is Level 2 Maintenance.
      *
     C     PParmLevel    IFEQ      '2'
      *
      ** Matured or deleted record can only be enquired.
      *
     C     RECI          IFNE      'D'
     C                   MOVEL     'N'           OKPREF
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'
     C                   EVAL      MsgIdArr(IDx) = 'FTM2324'
     C**********         EVAL      MsgDtaArr(IDx) = DDPREF                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(DDPREF))                               MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr +%TRIM(DDPREF)                   MD000091
     C                   GOTO      EValIns
     C                   ENDIF
      *
      ** Level 1 details must be complete.
      *
     C     RECI          IFEQ      'D'
     C     INLVL1        ANDNE     'Y'
     C                   MOVEL     'N'           OKPREF
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'
     C                   EVAL      MsgIdArr(IDx) = 'FTM2328'
     C                   GOTO      EValIns
     C                   ENDIF
      *
      ** Level 2 details must be incomplete.
      *
     C     RECI          IFEQ      'D'
     C     INLVL2        ANDEQ     'Y'
     C                   MOVEL     'N'           OKPREF
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'
     C                   EVAL      MsgIdArr(IDx) = 'FTM2326'
     C                   GOTO      EValIns
     C                   ENDIF
      *
      ** Record authorised.
      *
     C     RECI          IFEQ      'D'
     C     AUIN          ANDEQ     'Y'
     C                   MOVEL     'N'           OKPREF
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'
     C                   EVAL      MsgIdArr(IDx) = 'FTM2327'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EValIns       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAmd - Routine to validate Action Code 'A'               *
      *                                                               *
      *****************************************************************
      *
     C     SRValAmd      BEGSR
      *
      ** Entry point is Level 1 Maintenance.
      *
     C     PParmLevel    IFEQ      '1'
      *
      ** Check if record is existing.
      *
     C     DDPREF        CHAIN     INPAYDDF                           01
      *
     C     *IN01         IFEQ      *ON
     C                   MOVEL     'N'           OKPREF
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'
     C                   EVAL      MsgIdArr(IDx) = 'FTA0104'
     C                   GOTO      EValAmd
     C                   ENDIF
      *
      ** Record is existing but is not live, or record is
      ** is existing but is already authorised.
      *
     C     RECI          IFNE      'D'
     C     AUIN          OREQ      'Y'
     C                   MOVEL     'N'           OKPREF
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'
     C                   EVAL      MsgIdArr(IDx) = 'FTA0105'
     C                   GOTO      EValAmd
     C                   ENDIF
      *
      ** Entry point is Level 2 Maintenance.
      *
     C                   ELSE
      *
      ** Matured or deleted record can only be enquired.
      *
     C     RECI          IFNE      'D'
     C                   MOVEL     'N'           OKPREF
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'
     C                   EVAL      MsgIdArr(IDx) = 'FTM2324'
     C**********         EVAL      MsgDtaArr(IDx) = DDPREF                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(DDPREF))                               MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr +%TRIM(DDPREF)                   MD000091
     C                   GOTO      EValAmd
     C                   ENDIF
      *
      ** Level 1 details must be complete.
      *
     C     RECI          IFEQ      'D'
     C     INLVL1        ANDNE     'Y'
     C                   MOVEL     'N'           OKPREF
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'
     C                   EVAL      MsgIdArr(IDx) = 'FTM2328'
     C                   GOTO      EValAmd
     C                   ENDIF
      *
      ** Level 2 details must be complete.
      *
     C     RECI          IFEQ      'D'
     C     INLVL2        ANDNE     'Y'
     C                   MOVEL     'N'           OKPREF
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'
     C                   EVAL      MsgIdArr(IDx) = 'FTM2325'
     C                   GOTO      EValAmd
     C                   ENDIF
      *
      ** Record authorised.
      *
     C     RECI          IFEQ      'D'
     C     AUIN          ANDEQ     'Y'
     C                   MOVEL     'N'           OKPREF
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'
     C                   EVAL      MsgIdArr(IDx) = 'FTM2327'
     C                   ENDIF
      *
     C                   ENDIF
      *****************************************************************              261468 MD027200
      ***Call*CL*program*to*allocate*this*reference*to*a*dataarea******              261468 MD027200
      *****************************************************************              261468 MD027200
     C**********         EVAL      @MODLE = 'FT'                                     261468 MD027200
     C**********         EVAL      @TREF  = DDPREF                                   261468 MD027200
     C**********         EVAL      @RTINF = *Blanks                                  261468 MD027200
     C**********         EVAL      C#RTCD = *Blanks                                  261468 MD027200
      *****************************************************************              261468 MD027200
     C**********         CALL      'AOC8000'                                         261468 MD027200
     C**********         PARM                    C#RTCD            7                 261468 MD027200
     C**********         PARM                    @MODLE            2                 261468 MD027200
     C**********         PARM                    @TREF            15                 261468 MD027200
     C**********         PARM                    @RTINF           80                 261468 MD027200
      *****************************************************************              261468 MD027200
     C*****C#RTCD        IFEQ      '*IN USE'                                         261468 MD027200
     C**********         MOVEL     'N'           OKPREF                              261468 MD027200
     C**********         ADD       1             IDx                                 261468 MD027200
     C**********         EVAL      FldNameArr(IDx) = 'DDPREF'                        261468 MD027200
     C**********         EVAL      MsgIdArr(IDx) = 'FTA0109'                         261468 MD025674
     C**********         EVAL      MsgIdArr(IDx) = 'MMM1021'                       MD025674 MD027200
     C**********         ENDIF                                                       261468 MD027200
      *
     C     EValAmd       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDel - Routine to validate Action Code 'D'               *
      *                                                               *
      *****************************************************************
      *
     C     SRValDel      BEGSR
      *
      ** Entry point is Level 1 Maintenance.
      *
     C     PParmLevel    IFEQ      '1'
      *
      ** Check if record is existing.
      *
     C     DDPREF        CHAIN     INPAYDDF                           01
      *
     C     *IN01         IFEQ      *ON
     C                   MOVEL     'N'           OKPREF
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'
     C                   EVAL      MsgIdArr(IDx) = 'FTA0104'
     C                   GOTO      EValDel
     C                   ENDIF
      *
      ** Record is existing but is not live, or record is
      ** is existing but is already authorised.
      *
     C     RECI          IFNE      'D'
     C     AUIN          OREQ      'Y'
     C                   MOVEL     'N'           OKPREF
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'
     C                   EVAL      MsgIdArr(IDx) = 'FTA0105'
     C                   ENDIF
      *
     C                   ENDIF
      *****************************************************************              261468 MD027200
      ***Call*CL*program*to*allocate*this*reference*to*a*dataarea******              261468 MD027200
      *****************************************************************              261468 MD027200
     C**********         EVAL      @MODLE = 'FT'                                     261468 MD027200
     C**********         EVAL      @TREF  = DDPREF                                   261468 MD027200
     C**********         EVAL      @RTINF = *Blanks                                  261468 MD027200
     C**********         EVAL      C#RTCD = *Blanks                                  261468 MD027200
      *****************************************************************              261468 MD027200
     C**********         CALL      'AOC8000'                                         261468 MD027200
     C**********         PARM                    C#RTCD            7                 261468 MD027200
     C**********         PARM                    @MODLE            2                 261468 MD027200
     C**********         PARM                    @TREF            15                 261468 MD027200
     C**********         PARM                    @RTINF           80                 261468 MD027200
      *****************************************************************              261468 MD027200
     C*****C#RTCD        IFEQ      '*IN USE'                                         261468 MD027200
     C**********         MOVEL     'N'           OKPREF                              261468 MD027200
     C**********         ADD       1             IDx                                 261468 MD027200
     C**********         EVAL      FldNameArr(IDx) = 'DDPREF'                        261468 MD027200
     C**********         EVAL      MsgIdArr(IDx) = 'MMM1021'                         261468 MD027200
     C**********         ENDIF                                                       261468 MD027200
      *
     C     EValDel       ENDSR
      *
     C/COPY WNCPYSRC,FTH00448
      /EJECT                                                                                  CFT157
      *****************************************************************                       CFT157
      *                                                               *                       CFT157
      *  SRValStp - Routine to validate Action Code 'S'               *                       CFT157
      *                                                               *                       CFT157
      *****************************************************************                       CFT157
      *                                                                                       CFT157
     C     SRValStp      BEGSR                                                                CFT157
      *                                                                                       CFT157
      ** Entry point is Level 1 Maintenance.                                                  CFT157
      *                                                                                       CFT157
     C     PParmLevel    IFEQ      '1'                                                        CFT157
      *                                                                                       CFT157
      ** Check if record is existing.                                                         CFT157
      *                                                                                       CFT157
     C     DDPREF        CHAIN     INPAYDDF                           01                      CFT157
      *                                                                                       CFT157
     C     *IN01         IFEQ      *ON                                                        CFT157
     C                   MOVEL     'N'           OKPREF                                       CFT157
     C                   ADD       1             IDx                                          CFT157
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'                                 CFT157
     C                   EVAL      MsgIdArr(IDx) = '5047365'                                  CFT157
     C                   GOTO      EValStp                                                    CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
      ** Record is existing but not authorised.                                               CFT157
      *                                                                                       CFT157
     C     AUIN          IFNE      'Y'                                                        CFT157
     C                   MOVEL     'N'           OKPREF                                       CFT157
     C                   ADD       1             IDx                                          CFT157
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'                                 CFT157
     C                   EVAL      MsgIdArr(IDx) = '5047366'                                  CFT157
     C                   GOTO      EValStp                                                    CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
      *                                                                                       CFT157
      ** Only "IN" subtype can be stopped.                                                    CFT157
      *                                                                                       CFT157
     C     PYTP          IFNE      'IN'                                                       CFT157
     C                   MOVEL     'N'           OKPREF                                       CFT157
     C                   ADD       1             IDx                                          CFT157
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'                                 CFT157
     C                   EVAL      MsgIdArr(IDx) = '5047367'                                  CFT157
     C                   GOTO      EValStp                                                    CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
      *                                                                                       CFT157
      ** Only payment inserted today can be stopped                                           CFT157
      *                                                                                       CFT157
     C     OEDT          IFNE      WRDNB                                                      CFT157
     C                   MOVEL     'N'           OKPREF                                       CFT157
     C                   ADD       1             IDx                                          CFT157
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'                                 CFT157
     C                   EVAL      MsgIdArr(IDx) = '5047368'                                  CFT157
     C                   GOTO      EValStp                                                    CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
      *                                                                                     MD030957
      ** Validate that transaction is not already STOPPED                                   MD030957
      *                                                                                     MD030957
     C     RECI          IFEQ      'C'                                                      MD030957
     C     CHTP          ANDEQ     'S'                                                      MD030957
     C                   MOVEL     'N'           OKPREF                                     MD030957
     C                   ADD       1             IDx                                        MD030957
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'                               MD030957
     C                   EVAL      MsgIdArr(IDx) = '5047369'                                MD030957
     C                   GOTO      EValStp                                                  MD030957
     C                   ENDIF                                                              MD030957
      *                                                                                     MD030957
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
     C     EValStp       ENDSR                                                                CFT157
      *                                                                                       CFT157
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValEnq - Routine to validate Action Code 'E'               *
      *                                                               *
      *****************************************************************
      *
     C     SRValEnq      BEGSR
      *
      ** Entry point is Level 1 Maintenance.
      *
     C     PParmLevel    IFEQ      '1'
      *
      ** Check if record is existing.
      *
     C     DDPREF        CHAIN     INPAYDDF                           01
      *
     C     *IN01         IFEQ      *ON
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'FTA0104'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcsSec - Access Security Checking                          *
      *                                                               *
      *****************************************************************
      *
     C     SRAcsSec      BEGSR
      *
      ** If single-branching, check authority to action code.
      *
     C     BJSBRC        IFNE      *BLANK
     C     PLinkPgm      ANDNE     'GL4442    '
     C     PLinkPgm      ANDNE     'GL0090    '
      *
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        PACTN             1
     C                   PARM      *ZERO         PError            1 0
      *
      ** Action code is invalid for user.
      *
     C     PError        IFNE      *ZERO
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'FTA0111'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If multi-branching, check authority to booking branch.
      *
     C     BJSBRC        IFEQ      *BLANK
      *
      ** Entry point is Level 1 Maintenance and Action is Insert.
      *
     C     PParmLevel    IFEQ      '1'
     C     DDACTN        ANDEQ     'I'
      *
      ** Check User Branch if no entry for Branch Code has been made.
      *
     C     DDBRCA        IFEQ      *BLANKS
     C                   MOVE      PDBRN         WBRCA             3
     C                   ELSE
      *
      ** Bypass Security Checking if entry for Booking Branch
      ** is Question mark.
      *
     C     '?'           SCAN      DDBRCA                                 01
     C     *IN01         IFEQ      *ON
     C                   GOTO      EAcsSec
     C                   ELSE
     C                   MOVE      DDBRCA        WBRCA
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If entry point is Level 2 Maintenance or Action is not Insert,
      ** check Branch Code kept in Incoming Payments file.
      *
     C                   MOVE      BRCA          WBRCA
      *
     C                   ENDIF
      *
      ** Do Security Checking if Branch Code is existing.
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      WBRCA         PDSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
     C     PRTCD         IFEQ      *BLANKS
      *
     C     PLinkPgm      IFNE      'GL4442    '
     C     PLinkPgm      ANDNE     'GL0090    '
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        PACTN
     C                   PARM      WBRCA         PBR               3
     C                   PARM      *ZERO         PError
      *
      ** User is not authorised to any actions for this menu item
      ** and branch combination.
      *
     C     PError        IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'FTA0079'
     C                   ENDIF
      *
      ** User is not authorised to the specific action
      ** code entered for this branch and menu item.
      *
     C     PError        IFEQ      2
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'FTA0080'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If module was called from *SIN function and entry point is
      ** Level 1 Maintenance, do further validation on Action Code
      ** and Booking Branch.
      *
     C     PMode         IFEQ      '*SIN  '
     C     PParmLevel    ANDEQ     '1'
     C     PSJobName     OREQ      'QZDASOINIT'                                               CAP084
     C     PParmLevel    ANDEQ     '1'                                                        CAP084
     C     PSJobName     OREQ      'QSQSRVR'                                                  247277
     C     PParmLevel    ANDEQ     '1'                                                        247277
     C     PSJobName     OREQ      'QZDASSINIT'                                             MD055030
     C     PParmLevel    ANDEQ     '1'                                                      MD055030
      *
      ***If*action*code*is*'I',*a*SWIFT*reference*has*been*entered*and*                       257673
      ***no*errors*so*far,*check*that*the*user*is*also*authorised*to***                       257673
      ***action*code*'X'.**This*check*allows*restriction*that*only*****                       257673
      ***nominated*branches*may*process*electronic*messages*i.e.*only**                       257673
      ***those*branches*authorised*to*action*code*'X'.*****************                       257673
      *
     C*****DDACTN        IFEQ      'I'                                                        257673
     C*****DDSWTN        ANDNE     *BLANKS                                                    257673
     C*****OKACTN        ANDNE     'N'                                                        257673
      *
     C**********         CALL      'ZVACTBU'                                                  257673
     C**********         PARM      'X'           PACTN                                        257673
     C**********         PARM      WBRCA         PBR                                          257673
     C**********         PARM      *ZERO         PError                                       257673
      *
     C*****PError        IFEQ      2                                                          257673
     C**********         MOVE      'N'           OKACTN                                       257673
     C**********         MOVE      'N'           OKBRCA                                       257673
     C**********         ADD       1             IDx                                          257673
     C**********         EVAL      FldNameArr(IDx) = 'DDACTN'                                 257673
     C**********         EVAL      MsgIdArr(IDx) = 'FTA0081'                                  257673
     C**********         ENDIF                                                                257673
      *
     C**********         ENDIF                                                                257673
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check authority to Originating Branch.
      *
     C     BKOBUV        IFEQ      'Y'
     C     DDACTN        ANDNE     'I'
     C     BKOBUV        OREQ      'Y'
     C     DDACTN        ANDEQ     'I'
     C     PParmLevel    ANDEQ     '2'
      *
     C                   CALL      'ZVOBU'
     C                   PARM      ORBR          PORBR             3
     C                   PARM      *ZERO         PError
      *
      ** User is not authorised to any Originating branches.
      *
     C     PError        IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'FTA0083'
     C                   ENDIF
      *
      ** User is not authorised to the Originating branch on the
      ** transaction.
      *
     C     PError        IFEQ      2
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKPREF
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'FTA0089'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EAcsSec       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *
      ** Response Mode
     C                   PARM                    PResponse         1
      *
      ** Action Code
     C                   PARM                    DDACTN            1
      *
      ** Front Office Transaction Id
     C                   PARM                    FOTRID           20
      *
      ** Payment Reference
     C                   PARM                    DDPREF           15
      *
      ** Booking Branch
     C                   PARM                    DDBRCA            3
      *
      ** SWIFT Reference
     C                   PARM                    DDSWTN           28
      *
      ** Entry Point
     C                   PARM                    PParmLevel        1
      *
      ** Linked Program
     C                   PARM                    PLinkPgm         10
      *
      ** Validate Payment Reference for Insert
     C                   PARM                    PPrefInsert       1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC            3
      *
      ** SDGELR - Originating Branch/User Vald Req.
     C                   PARM                    BKOBUV            1
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN             3
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494            1
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499            1
      *                                                                         CFT014
      ** FT Batch Auth and Credit Advices                                       CFT014
     C                   PARM                    CFT003            1            CFT014
      *                                                                         CFT014
      ** STP Phase 2 MT103                                                      CFT014
     C                   PARM                    CFT014            1            CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** OK Action Code
     C                   PARM                    OKACTN            1
      *
      ** OK Payment Reference
     C                   PARM                    OKPREF            1
      *
      ** OK Booking Branch
     C                   PARM                    OKBRCA            1
      *
      ** Incoming Payments retrieved from file - file format
     C                   PARM                    CrIPFilFmt
     C                   PARM                    CrIP2FilFmt                    CFT014
     C/COPY WNCPYSRC,FTIPAYIC03
     C                   CALLB     'AOSARDR0'                                                 CFT157
     C                   Parm      *BLANKS       PRTCD                                        CFT157
     C                   Parm      '*VERIFY'     POPTN                                        CFT157
     C                   Parm      'CFT157'      PSARD                                        CFT157
     C     SCSARD        Parm      SCSARD        DSFDY                                        CFT157
                                                                                              CFT157
     C                   If        PRTCD <> *Blanks and                                       CFT157
     C                             PRTCD <> '*NRF   '                                         CFT157
     C     *LOCK         In        LDA                                                        CFT157
     C                   Movel     'SCSARDPD'    DBFILE                                       CFT157
     C                   EVAL      DBASE  = 3                                                 CFT157
     C                   Movel     'CFT157'      DBKEY                                        CFT157
     C                   Out       LDA                                                        CFT157
     C                   Exsr      *PSSR                                                      CFT157
     C                   End                                                                  CFT157
                                                                                              CFT157
     C                   If        PRTCD = *Blanks                                            CFT157
     C                   Movel     'Y'           CFT157            1                          CFT157
     C                   Else                                                                 CFT157
     C                   Movel     'N'           CFT157                                       CFT157
     C                   End                                                                  CFT157
      **  GET RUNDAT to get AGRDNB                                                            CFT157
     C     *DTAARA       DEFINE                  RUNDAT                                       CFT157
     C                   IN        RUNDAT                                                     CFT157
     C                   UNLOCK    RUNDAT                                                     CFT157
     C                   MOVE      AGRDNB        WRDNB             5 0                        CFT157
      *                                                                                       CFT157
                                                                                              CSC024
      ** Check if enhancement CSC024 (Open Month End) is on                                   CSC024
                                                                                              CSC024
     C                   CALLB     'AOSARDR0'                                                 CSC024
     C                   PARM      *BLANKS       PRTCD             7                          CSC024
     C                   PARM      '*VERIFY'     POPTN             7                          CSC024
     C**********         PARM      'CSC024'      PSARD             6                   CSC024 CSC054
     C                   PARM      'CSC054'      PSARD             6                          CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
                                                                                              CSC024
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSC024
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC024
     C**********         EVAL      DBKEY  = 'CSC024'                                   CSC024 CSC054
     C                   EVAL      DBKEY  = 'CSC054'                                          CSC054
     C                   EVAL      DBASE  = 1                                                 CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   IF        PRTCD = *BLANKS                                            CSC024
     C**********         MOVEL     'Y'           CSC024            1                   CSC024 CSC054
     C                   MOVEL     'Y'           CSC054            1                          CSC054
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode          7                          CSC024
     C**********         PARM      SysValOME     P@OP01           20                   CSC024 CSC054
     C                   PARM      SysValPEA     P@OP01           20                          CSC054
     C                   PARM      *BLANKS       P@VL01          200                          CSC024
     C                   PARM      *BLANKS       P@OP02           20                          CSC024
     C                   PARM      *BLANKS       P@VL02          200                          CSC024
     C                   PARM      *BLANKS       P@OP03           20                          CSC024
     C                   PARM      *BLANKS       P@VL03          200                          CSC024
     C                   PARM      *BLANKS       P@OP04           20                          CSC024
     C                   PARM      *BLANKS       P@VL04          200                          CSC024
     C                   PARM      *BLANKS       P@OP05           20                          CSC024
     C                   PARM      *BLANKS       P@VL05          200                          CSC024
     C                   PARM      *BLANKS       P@OP06           20                          CSC024
     C                   PARM      *BLANKS       P@VL06          200                          CSC024
     C                   PARM      *BLANKS       P@OP07           20                          CSC024
     C                   PARM      *BLANKS       P@VL07          200                          CSC024
     C                   PARM      *BLANKS       P@OP08           20                          CSC024
     C                   PARM      *BLANKS       P@VL08          200                          CSC024
     C                   PARM      *BLANKS       P@OP09           20                          CSC024
     C                   PARM      *BLANKS       P@VL09          200                          CSC024
     C                   PARM      *BLANKS       P@OP10           20                          CSC024
     C                   PARM      *BLANKS       P@VL10          200                          CSC024
                                                                                              CSC024
     C                   IF        PRetCode  <> *BLANKS                                       CSC024
     C                   EVAL      DBPGM = 'FTIPAYSIN'                                        CSC024
     C                   EVAL      DBFILE = 'SDSVALPD'                                        CSC024
     C                   EVAL      DBKEy = '*KEY   '                                          CSC024
     C                   EVAL      DBase = 2                                                  CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ELSE                                                                 CSC024
     C                   IF        P@VL01 = 'Y'                                               CSC024
     C                   MOVEL     'N'           GENPREF           1                          CSC024
     C                   ELSE                                                                 CSC024
     C                   EVAL      GENPREF = 'Y'                                              CSC024
     C                   ENDIF                                                                CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   ELSE                                                                 CSC024
     C**********         EVAL      CSC024 = 'N'                                        CSC024 CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   EVAL      GENPREF = 'Y'                                              CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
