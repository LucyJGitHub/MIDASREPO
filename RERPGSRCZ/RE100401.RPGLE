     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Hierarchy Hdr Validation')    *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100401 - Cash Management Hierarchy Header Validation       *
      *                                                               *
      *  Function:  This program validates the 'front end' cash       *
      *             management hierarchy header records.              *
      *             The validation is as follows:                     *
      *             i. Records exist on REZSHXPD and REGAHXPD when    *
      *                required.                                      *
      *             ii. Certain fields on the hierarchy headers must  *
      *                 be valid.                                     *
      *             As it does the validation, it creates 'live'      *
      *             hierarchy details (the back office representation *
      *             of the front end hierarchy headers).              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 14May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 215579             Date 17Mar03               *
      *                 214360             Date 03Feb03               *
      *                 CRE008  *CREATE    Date 06Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  215579 - Hierarchy validation error                          *
      *  214360 - Cash Management Deferred Posting                    *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
      * F R O N T  E N D  F I L E S
      * ---------------------------
 
      * Zero Balancing/Sweeping Header Extension
     FREZSHXPD  IF   E           K DISK    INFSR(*PSSR)
      * Group Account Header Extension
     FREGAHXPD  IF   E           K DISK    INFSR(*PSSR)
 
      * Account Hierarchy Member - TOP a/c
     FREACCMJL0 IF   E           K DISK    INFSR(*PSSR)
 
      * ' L I V E '  B A C K  E N D  F I L E S
      * --------------------------------------
 
      * Live Cash Management Hierarchy Details
     FRELCMHDPD O  A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHDD0:O_LCMHDD0)
      * Live Zero Balancing/Sweeping Hierarchy Details
     FRELZSHDPD O  A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSHDD0:O_LZSHDD0)
      * Live Group Account Hierarchy Details
     FRELGAHDPD O  A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REGAHDD0:O_LGAHDD0)
 
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      * Account Hierarchy Header
     D I_ACCH        E DS                  EXTNAME(REACCHPD)
     D  CDHIER       E                     EXTFLD(HIID)
     D  CDHISN       E                     EXTFLD(HIHISN)
     D  CDDESC       E                     EXTFLD(HIDESC)
     D  CDHTYP       E                     EXTFLD(HIHTYP)
     D  CDBRCA       E                     EXTFLD(HIBRCA)
     D  CDDEFR       E                     EXTFLD(HIDEFR)
     D  CDRVDT       E                     EXTFLD(HIRVDT)
     D  CDINBU       E                     EXTFLD(HIINBU)
     D  CDAUBU       E                     EXTFLD(HIAUBU)
     D  CDLCDT       E                     EXTFLD(HILCDT)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Second DS for access programs
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
     IREZSHXD0
     I              ZHHIID                      ZDHIER
     I              ZHICSF                      ZDICSF
     I              ZHICSI                      ZDICSI
     I              ZHSHOC                      ZDSHOC
     I              ZHTYPT                      ZDTYPT
     I              ZHTYPS                      ZDTYPS
     I              ZHCHKC                      ZDCHKC
     I              ZHEXTL                      ZDEXTL
     I              ZHMAST                      ZDMAST
     I              ZHENAR                      ZDENAR
     I              ZHEFVS                      ZDEFVS
     I              ZHEFVD                      ZDEFVD
     I              ZHEBVD                      ZDEBVD
     I              ZHDEST                      ZDDEST
     I              ZHDSTT                      ZDDSTT
     I              ZHSNDC                      ZDSNDC
     I              ZHRCVC                      ZDRCVC
     I              ZHMCMR                      ZDMCMR
     I              ZHMVDO                      ZDMVDO
     I              ZHCHG1                      ZDCHG1
     I              ZHCAC1                      ZDCAC1
     I              ZHCAM1                      ZDCAM1
     I              ZHICD1                      ZDICD1
     I              ZHCHG3                      ZDCHG3
     I              ZHCAC3                      ZDCAC3
     I              ZHCAM3                      ZDCAM3
     I              ZHICD3                      ZDICD3
     I              ZHBOCD                      ZDBOCD
     I              ZHEXA1                      ZDEXA1
     I              ZHEXA2                      ZDEXA2
     I              ZHEXA3                      ZDEXA3
     I              ZHEXA4                      ZDEXA4
     I              ZHEXA5                      ZDEXA5
     I              ZHPROF                      ZDPROF                          214360
     I              ZHDEFP                      ZDDEFP                          214360
     I              ZHDEFZ                      ZDDEFZ                          214360
     IREGAHXD0
     I              GHHIID                      GDHIER
     I              GHCCY                       GDCCY
     I              GHTOPB                      GDTOPB
     I              GHLELC                      GDLELC
     I              GHUELC                      GDUELC
      /SPACE 5
 
 
 
      * If interactive mode
 
     C     I_MODE        IFEQ      'I'
 
      * 'No REACCHPD record exists.'
 
     C     I_HTYP        IFEQ      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'HIERARCHY'   FldNameArr(Ix)
     C                   MOVEL     'RE75000'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      * Hierarchy Type must match input hierarchy type
      * 'Hierarchy Type is not valid.'
 
     C     CDHTYP        IFNE      I_HTYP
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'HIERARCHY'   FldNameArr(Ix)
     C                   MOVEL     'RE75003'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   RETURN
     C                   ENDIF
 
      * Convert Cash Management Header
      * Validate Cash Management Header
 
     C                   EXSR      CNV_CMHEADER
     C                   EXSR      VAL_CMHEADER
 
      * Write a record to the 'Live' RECMHDPD
 
     C                   Z-ADD     0             CDNODH
     C                   Z-ADD     0             CDNODN
     C                   Z-ADD     0             CDPRSQ
     C                   MOVEL     'N'           CDHLKT
 
     C                   WRITE     O_LCMHDD0
 
      * If a zero-balancing/sweeping hierarchy
      * ---------------------------------------
 
     C     CDHTYP        IFEQ      'ZS'
 
      * Pick up Zero Balancing/Sweeping Header Extension record
      * If no record is found, it's an error
      * 'No REZSHXPD record exists.'
 
     C     CDHIER        CHAIN     REZSHXD0                           60
     C     *IN60         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'HIERARCHY'   FldNameArr(Ix)
     C                   MOVEL     'RE75001'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   RETURN
     C                   ENDIF
 
      * Get currency of top a/c
 
     C     I_HIER        CHAIN     REZSMXJ0                           60
 
      * Convert Zero Balancing/Sweeping Header
      * Validate Zero Balancing/Sweeping Header
 
     C                   EXSR      CNV_ZSHEADER
     C                   EXSR      VAL_ZSHEADER
 
      * Write a record to the 'Live' REZSHDPD
 
     C                   WRITE     O_LZSHDD0
 
     C                   ENDIF
 
      * If a group account hierarchy
      * ----------------------------
 
     C     CDHTYP        IFEQ      'GA'
 
      * Pick up Group Account Header Extension record
      * If no record is found, it's an error
      * 'No REGAHXPD record exists'
 
     C     CDHIER        CHAIN     REGAHXD0                           60
     C     *IN60         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'HIERARCHY'   FldNameArr(Ix)
     C                   MOVEL     'RE75002'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   RETURN
     C                   ENDIF
 
      * Convert Group A/c Header
      * Validate Group A/c Header
 
     C                   EXSR      CNV_GAHEADER
     C                   EXSR      VAL_GAHEADER
 
      * Write a record to the 'Live' REGAHDPD
 
     C                   WRITE     O_LGAHDD0
 
     C                   ENDIF
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Convert Cash Management Header
      ********************************************************************
     C     CNV_CMHEADER  BEGSR
 
     C                   CALLB     'RE100311'
 
      * Return code
      * Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
 
      * INPUTS
 
      * Date format
     C                   PARM      'N'           I_DATFMT          1
      * Date Effective From
      * Review Date
      * Last Change Date
     C                   PARM      CDDEFR        I_DEFR            5 0
     C                   PARM      CDRVDT        I_RVDT            5 0
     C                   PARM      CDLCDT        I_LCDT            5 0
 
 
      * BANK details
     C                   PARM                    SDBANK
 
      * OUTPUTS
      * Date Effective From
      * Review Date
      * Last Change Date
     C                   PARM                    DDDEFR            7
     C                   PARM                    DDRVDT            7
     C                   PARM                    DDLCDT            7
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN CASH MANAGEMENT HEADER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Cash Management Header
      ********************************************************************
     C     VAL_CMHEADER  BEGSR
 
     C                   CALLB     'RE100301'
 
      * Return code
      * Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
      * Hierarchy
     C                   PARM                    I_HIER            9 0
      * Hierarchy Type
      * Main Branch
     C                   PARM      CDHTYP        I_SHTYP           2
     C                   PARM      CDBRCA        I_SBRCA           3
 
      * Date Effective From
      * Review Date
      * Last Change Date
     C                   PARM      DDDEFR        I_SDEFR           7
     C                   PARM      DDRVDT        I_SRVDT           7
     C                   PARM      DDLCDT        I_SLCDT           7
 
      * BANK details
     C                   PARM                    SDBANK
 
      * OUTPUTS
      * Date Effective From
      * Review Date
      * Last Change Date
     C                   PARM                    O_DEFR            5 0
     C                   PARM                    O_RVDT            5 0
     C                   PARM                    O_LCDT            5 0
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN CASH MANAGEMENT HEADER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Zero Balancing/Sweeping Header
      ********************************************************************
     C     CNV_ZSHEADER  BEGSR
 
     C                   CALLB     'RE100312'
 
      * Return code
      * Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
      * INPUTS
      * Child Currency
     C                   PARM      ZMCCCY        I_CCCY            3
      * Edit code
     C                   PARM      *BLANK        I_ECODE           1
 
      * Input Cycle Sweeping Frequency
      * Input Cycle Sweeping Indicators
     C                   PARM      ZDICSF        I_ICSF           48
     C                   PARM      ZDICSI        I_ICSI           12
 
      * Sweeping Holiday Convention
     C                   PARM      ZDSHOC        I_SHOC            1
 
      * Check For Cover on Top A/c
     C                   PARM      ZDCHKC        I_CHKC            1
 
      * External
      * Master Account
      * External Fwd Value Sweeping
      * External Account 1                                                      214360
     C                   PARM      ZDEXTL        I_EXTL            1
     C                   PARM      ZDMAST        I_MAST            1
     C                   PARM      ZDEFVS        I_EFVS            1
     C                   PARM      ZDEXA1        I_EXA1           35            214360
 
      * MT202 Cover Message Required
     C                   PARM      ZDMCMR        I_MCMR            1
 
      * MT101 Charges Account
      * MT101 Charges Amount
     C**********         PARM      ZDCAC1        I_C1ACCID        18                          CGL029
     C                   PARM      ZDCAC1        I_C1ACCID        24                          CGL029
     C                   PARM      ZDCAM1        I_CAM1           15 0
 
      * MT103 Charges Account
      * MT103 Charges Amount
     C**********         PARM      ZDCAC3        I_C3ACCID        18                          CGL029
     C                   PARM      ZDCAC3        I_C3ACCID        24                          CGL029
     C                   PARM      ZDCAM3        I_CAM3           15 0
      * Deferred Posting                                                        214360
      * Deferred Posting Zero Narrative                                         214360
     C                   PARM      ZDDEFP        I_DEFP            1            214360
     C                   PARM      ZDDEFZ        I_DEFZ            1            214360
 
      * OUTPUTS
 
      * Input Cycle Sweeping Frequency
      * Input Cycle Sweeping Indicators
     C                   PARM                    DDICSF           59
     C                   PARM                    DDICSI           48
 
      * Sweeping Holiday Convention
     C                   PARM                    DDSHOC            7
 
      * Check For Cover on Top A/c
     C                   PARM                    DDCHKC            3
 
      * External
      * Master Account
      * External Fwd Value Sweeping
      * External Account 1                                                      214360
     C                   PARM                    DDEXTL            3
     C                   PARM                    DDMAST            3
     C                   PARM                    DDEFVS            3
     C                   PARM                    DDEXA11          25            214360
     C                   PARM                    DDEXA12          10            214360
 
      * MT202 Cover Message Required
     C                   PARM                    DDMCMR            3
 
      * MT101 Charges Account
      * MT101 Charges Amount
     C                   PARM                    DDC1ACC          22
     C                   PARM                    DDCAM1           17
 
      * MT103 Charges Account
      * MT103 Charges Amount
     C                   PARM                    DDC3ACC          22
     C                   PARM                    DDCAM3           17
      * Deferred Posting                                                        214360
      * Deferred Posting Zero Narrative                                         214360
     C                   PARM                    DDDEFP            3            214360
     C                   PARM                    DDDEFZ            3            214360
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN ZERO BAL/SWEEPING HEADER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Zero Balancing/Sweeping Header
      ********************************************************************
     C     VAL_ZSHEADER  BEGSR
 
     C                   CALLB     'RE100302'
 
      * Return code
      * Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
      * INPUTS
      * Hierarchy
      * Child currency
     C                   PARM                    I_HIER            9 0
     C                   PARM      ZMCCCY        I_CCCY            3
 
      * Input Cycle Sweeping Frequency
      * Input Cycle Sweeping Indicators
     C                   PARM      ZDICSF        I_SICSF          48
     C                   PARM      ZDICSI        I_SICSI          12
 
      * Sweeping Holiday Convention - COB
     C                   PARM      ZDSHOC        I_SSHOC           1
 
      * Transaction Type - Top
      * Transaction Type - Sweep
     C                   PARM      ZDTYPT        I_STYPT           5
     C                   PARM      ZDTYPS        I_STYPS           5
 
      * Check For Cover on Top A/c
     C                   PARM      ZDCHKC        I_SCHKC           1
 
      * External
      * Master Account
      * External Narrative
      * External Fwd Value Sweeping
      * External Fwd Value Days
      * External Bck Value Days
     C                   PARM      ZDEXTL        I_SEXTL           1
     C                   PARM      ZDMAST        I_SMAST           1
     C                   PARM      ZDENAR        I_SENAR          30
     C                   PARM      ZDEFVS        I_SEFVS           1
     C                   PARM      ZDEFVD        I_SEFVD           3
     C                   PARM      ZDEBVD        I_SEBVD           3
      * Destination
      * Destination Type
      * Sender's Correspondent
      * Receiver's Correspondent
     C                   PARM      ZDDEST        I_SDEST          18
     C                   PARM      ZDDSTT        I_SDSTT           1
     C                   PARM      ZDSNDC        I_SSNDC           2
     C                   PARM      ZDRCVC        I_SRCVC          11
 
      * MT202 Cover Message Required
      * MT103 Value Date Offset
     C                   PARM      ZDMCMR        I_SMCMR           1
     C                   PARM      ZDMVDO        I_SMVDO           1
 
      * MT101 Charges
      * MT101 Charges Account
      * MT101 Charges Amount
      * MT101 instruction Code
     C                   PARM      ZDCHG1        I_SCHG1           3
     C**********         PARM      ZDCAC1        I_C1ACCID        18                          CGL029
     C                   PARM      ZDCAC1        I_C1ACCID        24                          CGL029
     C                   PARM      DDCAM1        I_SCAM1          17
     C                   PARM      ZDICD1        I_SICD1           4
 
      * MT103 Charges
      * MT103 Charges Account
      * MT103 Charges Amount
      * MT103 instruction Code
     C                   PARM      ZDCHG3        I_SCHG3           3
     C**********         PARM      ZDCAC3        I_C3ACCID        18                          CGL029
     C                   PARM      ZDCAC3        I_C3ACCID        24                          CGL029
     C                   PARM      DDCAM3        I_SCAM3          17
     C                   PARM      ZDICD3        I_SICD3           4
      * MT103 Bank Operation Code
     C                   PARM      ZDBOCD        I_SBOCD           4
      * External Account 1-5
     C                   PARM      ZDEXA1        I_SEXA1          35
     C                   PARM      ZDEXA2        I_SEXA2          35
     C                   PARM      ZDEXA3        I_SEXA3          35
     C                   PARM      ZDEXA4        I_SEXA4          35
     C                   PARM      ZDEXA5        I_SEXA5          35
      * Deferred Posting                                                        214360
      * Deferred Posting Zero Narrative                                         214360
     C                   PARM      ZDDEFP        I_SDEFP           1            214360
     C                   PARM      ZDDEFZ        I_SDEFZ           1            214360
 
      * BANK details
     C                   PARM                    SDBANK
 
      * OUTPUTS
      * MT101 Charges Amount
      * MT103 Charges Amount
     C                   PARM                    O_CAM1           15 0
     C                   PARM                    O_CAM3           15 0
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN ZERO BAL/SWEEPING HEADER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Group A/c Header
      ********************************************************************
     C     CNV_GAHEADER  BEGSR
 
     C                   CALLB     'RE100313'
 
      * Return code
      * Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
      * INPUTS
 
      * Top on Balance Sheet
      * Link Effective At Last Capitalization Date
      * Unlink Effective At Last Capitalization Date
     C                   PARM      GDTOPB        I_TOPB            1
     C                   PARM      GDLELC        I_LELC            1
     C                   PARM      GDUELC        I_UELC            1
 
      * OUTPUTS
 
      * Top on Balance Sheet
      * Link Effective At Last Capitalization Date
      * Unlink Effective At Last Capitalization Date
     C                   PARM                    DDTOPB            3
     C                   PARM                    DDLELC            3
     C                   PARM                    DDUELC            3
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN GROUP A/C HEADER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Group A/c Header
      ********************************************************************
     C     VAL_GAHEADER  BEGSR
 
     C                   CALLB     'RE100303'
 
      * Return code
      * Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
      * INPUTS
      * Hierarchy
     C                   PARM                    I_HIER            9 0
 
      * Top on Balance Sheet
     C                   PARM      GDTOPB        I_STOPB           1
      * Hierarchy Currency
     C                   PARM      GDCCY         I_SCCY            3
      * Link Effective At Last Capitalization Date
      * Unlink Effective At Last Capitalization Date
     C                   PARM      GDLELC        I_SLELC           1
     C                   PARM      GDUELC        I_SUELC           1
 
      * BANK details
     C                   PARM                    SDBANK
 
      * OUTPUTS
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN GROUP A/C HEADER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Check for Return
      ********************************************************************
     C     CHK_4RETURN   BEGSR
     C     Ix            IFEQ      ArrayMax
     C                   RETURN
     C                   ENDIF
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
                                                                                215579
      * Return code                                                             215579
      * Error Message                                                           215579
     C                   PARM                    X_RTCD                         215579
     C                   PARM                    X_ERMS                         215579
      * INPUTS                                                                  215579
      * Mode
     C                   PARM                    I_MODE            1
      * Hierarchy
      * Hierarchy Type
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_HTYP            2
      * Account Hierarchy Header
     C                   PARM                    I_ACCH
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
 
      * Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
