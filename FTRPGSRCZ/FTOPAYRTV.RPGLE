     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing pmnts retr + act/deal validation')   *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAYRTV - OUTGOING PAYMENTS RETRIEVE                       *
      *              (WITH ACTION CODE VERSUS TRANS NUMBER VALIDATION *
      *                                                               *
      *  Function:  This module retrieves an outgoing payment from    *
      *             the database. As it does so, it validates the     *
      *             action code and payment reference.                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. ERZ248             Date 18Nov19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CFT157             Date 29Aug14               *
      *                 MD000091           Date 07May13               *
      *                 261152             Date 24Apr13               *
      *                 MD019877           Date 10Apr13               *
      *                 CFT120             Date 28Sep12               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 250600             Date 07Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 240624             Date 05Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG7029            Date 09Jun05               *
      *                 CFT116             Date 12Jul04               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 215687             Date 20Mar03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209408             Date 16Oct02               *
      *                 201852             Date 02May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 15Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
/*    *                 179994             Date 14Aug00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 24May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 23Aug99               *
      *                 CAP031  *CREATE    Date 15Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  ERZ248 - SWIFT UETR via OPAY API                             *
      *           Add hooks ERZ248_038, ERZ248_039                    *
      *           Amended hooks FTH00338, FTOPAYIF01, FTOPAYIC03      *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *  MD000091 - Event Codes Substitution                          *
      *  261152 - Payment reference should be blank at insert mode.   *
      *           Reinstate fix 215687.                               *
      *  MD019877 - Retest of 260045. FT-Outgoing Payments Enquiry    *
      *             Screen is Missing                                 *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  240624 - Messages routed to OPAYs cannot be amended          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSC024 - Open Month End                                      *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CFT116 - Core changes for GBO016.                            *
      *         - MT110 Generation in Funds Transfer                  *
      *                  - Upgrade to Midasplus                       *
      *           Core hooks amended:FTOPAYIF01,FTOPAYID01            *
      *           Core hooks added:FTOPAYIC02,FTOPAYIC03              *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  215687 - Database error occurred, caused by duplicate record.*
      *           Payment reference should be blank at insert mode.   *
      *  209408 - complete 201852 for monbranching                    *
      *  201852 - Do not call ZVACTBU when enquiry of a transaction   *
      *           comes from the Account Movements Enquiry (GL4442).  *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
/*    *  179994 - Access FT ICD and not FO ICD                        *
      *  175479 - FONTIS: Dealer's reference field                    *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTOPAYL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(OTPAYDDF:OTPAYFOI)
     FOTPAY     IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
     FOTPAYXL0  IF   E           K DISK    INFSR(*PSSR)                         CFT014
     F/COPY WNCPYSRC,FTOPAYIF01
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
                                                                                              CSC024
      ** String for System Values Array                                                       CSC024
     D SysValOME       C                   CONST('OMEIndicator')                              CSC024
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Data structure for file status of FT deals file.
     D INFDS           DS
     D  RECORD           *RECORD
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D*SDFODA*****   E DS                  EXTNAME(SDFODAPD)                    179994
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)                    179994
      ** EXTERNAL DS FOR FUNDS TRANSFER ICD DETAILS
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS
     D/COPY WNCPYSRC,FTOPAYID01
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D PmntFilFmt    E DS                  EXTNAME(OTPAYDD)
      ** Payment in File Format
                                                                                CFT014
     D PmntFilFmX    E DS                  EXTNAME(OTPAYXPD)                    CFT014
      ** Extension Payment details in File Format                               CFT014
      * Validation Work Fields                                                  CFT014
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)                  CFT014
     D/COPY WNCPYSRC,FTH00464
      *                                                                                       CSC024
      ** Externally described DS for SAR details                                              CSC024
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC024
     D SLCD          E                     EXTFLD(LCD)                                        CSC024
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
      *                                                                                       CGL029
     D/COPY WNCPYSRC,FTH00334
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
      *                                                                                     MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * INITIALIZATION
     C                   EXSR      INIT
 
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      VFRNT
 
      **  Carry out no further validation if errors have occurred.
     C     OKACTN        IFEQ      'N'
     C     OKPREF        OREQ      'N'
     C                   RETURN
     C                   END
     C                   END
 
      * VALIDATE ACTION CODE & Payment Reference
     C                   EXSR      VAL
 
      **  Carry out no further validation if errors have occurred.
     C     OKACTN        IFEQ      'N'
     C     OKPREF        OREQ      'N'
     C                   RETURN
     C                   END
 
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
     C     SACTION       IFEQ      'E'
     C                   EXSR      VALACE
     C                   END
 
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *  (only if the Payment Ref. is not to be generated.)
     C     SACTION       IFEQ      'I'
     C     SPREF         ANDNE     *BLANKS
     C                   EXSR      VALACI
     C                   END
 
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
     C     SACTION       IFEQ      'A'
     C                   EXSR      VALACA
     C                   END
 
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
     C     SACTION       IFEQ      'D'
     C                   EXSR      VALACD
     C                   END
     C/COPY WNCPYSRC,FTH00465
     C     SACTION       IFEQ      'S'                                                        CFT157
     C     CFT157        IFEQ      'Y'                                                        CFT157
     C                   EXSR      VALACS                                                     CFT157
     C                   ELSE                                                                 CFT157
     C                   MOVEL     'N'           OKACTN                                       CFT157
     C                   ADD       1             Ix                                           CFT157
     C                   EVAL      FldNameArr(Ix) = 'SACTION'                                 CFT157
     C                   EVAL      MsgIdArr(Ix) = '5047363'                                   CFT157
     C                   ENDIF                                                                CFT157
     C                   ENDIF                                                                CFT157
 
      **  Carry out no further validation if errors occurred.
     C     OKACTN        IFEQ      'N'
     C     OKPREF        OREQ      'N'
     C                   RETURN
     C                   END
 
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
     C     RespMode      IFEQ      'S'
     C                   EXSR      ACSSEC
     C                   END
 
      * Return
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
     C/COPY WNCPYSRC,FTH00502
 
      * ERROR IF ACTION CODE IS NOT 'I', 'A, or 'D'
     C     SACTION       IFNE      'I'
     C     SACTION       ANDNE     'A'
     C     SACTION       ANDNE     'D'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'SACTION'     FldNameArr(Ix)
     C                   MOVEL     'APM0100'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
     C/COPY WNCPYSRC,FTH00466
      *                                                                                       CFT157
     C     SACTION       IFEQ      'S'                                                        CFT157
     C     CFT157        ANDNE     'Y'                                                        CFT157
     C                   MOVE      'N'           OKACTN                                       CFT157
     C                   ADD       1             Ix                                           CFT157
     C                   MOVEL     'SACTION'     FldNameArr(Ix)                               CFT157
     C                   MOVEL     'APM0100'     MsgIdArr(Ix)                                 CFT157
     C                   GOTO      EVFRNT                                                     CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
 
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'SACTION'     FldNameArr(Ix)
     C                   MOVEL     'APM0101'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
 
      * ACCESS Payment WITH FRONT OFFICE TRANSACTION ID
     C     FOTRID        CHAIN     OTPAYFOI                           99
 
      * IF INSERT
     C     SACTION       IFEQ      'I'
 
      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'SACTION'     FldNameArr(Ix)
     C                   MOVEL     'APM0102'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
 
     C                   ELSE
 
      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
     C     *IN99         IFEQ      '1'
     C/COPY WNCPYSRC,FTH00467
      *                                                                                       CFT157
     C     SACTION       ANDNE     'S'                                                        CFT157
      *                                                                                       CFT157
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'SACTION'     FldNameArr(Ix)
     C                   MOVEL     'APM0103'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
 
      * IF NOT INSERT, UPDATE MIDAS Payment Reference
     C                   MOVEL     PREF          SPREF
 
     C                   END
 
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND PAYMENT REFERENCE
      *****************************************************************
     C     VAL           BEGSR
 
      **  For Level 1 maintenance....
     C     @Level        IFEQ      '1'
 
      **  Check that the action code is valid.
 
     C/COPY WNCPYSRC,FTH00468
     C*****SACTION       IFNE      'I'                                                     MD019877
     C*****SACTION       ANDNE     'A'                                                     MD019877
     C*****SACTION       ANDNE     'D'                                                     MD019877
     C*****SACTION       ANDNE     'E'                                                     MD019877
     C**********         MOVE      'N'           OKACTN                                    MD019877
     C**********         ADD       1             Ix                                        MD019877
     C**********         MOVEL     'SACTION'     FldNameArr(Ix)                            MD019877
     C**********         MOVEL     'MMM0161'     MsgIdArr(Ix)                              MD019877
     C**********         GOTO      EVALAI                                                  MD019877
     C**********         END                                                               MD019877
     C/COPY WNCPYSRC,FTH00335
 
      **  If action code not 'I' payment reference must be entered....
     C     SACTION       IFNE      'I'
 
     C     SPREF         IFEQ      *BLANKS
     C                   MOVE      'N'           OKPREF
     C                   ADD       1             Ix
     C                   MOVEL     'SPREF  '     FldNameArr(Ix)
     C                   MOVEL     'MMA1062'     MsgIdArr(Ix)
     C                   ELSE
 
     **  .... and must match that on file.
     C     SPREF         CHAIN     OTPAYDDF                           88
     C     *IN88         IFEQ      '1'
     C                   MOVE      'N'           OKPREF
     C                   ADD       1             Ix
     C                   MOVEL     'SPREF  '     FldNameArr(Ix)
     C                   MOVEL     'MMA1061'     MsgIdArr(Ix)
     C                   END
                                                                                CFT014
      ** Access extension file                                                  CFT014
                                                                                CFT014
     C                   If        *IN88 = False                                CFT014
     C     SPREF         CHAIN     OTPAYXL0                           88        CFT014
                                                                                CFT014
      ** DB Error if record not found                                           CFT014
                                                                                CFT014
     C                   IF         @CFT014 = 'Y'                               CFT014
     C                   If        *IN88 = True                                 CFT014
     C                   Movel     'OTPAYXL0'    DBFILE                         CFT014
     C                   Movel     '030'         DBASE                          CFT014
     C                   Movel     SPREF         DBKEY                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C/COPY WNCPYSRC,ERZ248_038                                                 ERZ248
     C                   EndIf                                                  CFT014
      *
     C                   END
     C**********         ELSE                                                          215687 240624
      ** Allow entry for Payment Reference for Insert if CSC024 is                     CSC024 240624
      ** switched on and running on OME system.                                        CSC024 240624
     C*****SPREF         IFNE      *BLANKS                                             215687 240624
     C*****RESPMODE      ANDEQ     'S'                                                 215687 240624
     C*****GENPREF       ANDEQ     'Y'                                                 CSC024 240624
     C**********         MOVE      'N'           OKPREF                                215687 240624
     C**********         ADD       1             Ix                                    215687 240624
     C**********         MOVEL     'SPREF  '     FldNameArr(Ix)                        215687 240624
     C**********         MOVEL     'FTA0102'     MsgIdArr(Ix)                          215687 240624
     C**********         ENDIF                                                         215687 240624
     C                   ELSE                                                                 261152
      ** Allow entry for Payment Reference for Insert if CSC024 is                            261152
      ** switched on and running on OME system.                                               261152
     C     SPREF         IFNE      *BLANKS                                                    261152
     C     RESPMODE      ANDEQ     'S'                                                        261152
     C     GENPREF       ANDEQ     'Y'                                                        261152
     C                   MOVE      'N'           OKPREF                                       261152
     C                   ADD       1             Ix                                           261152
     C                   MOVEL     'SPREF  '     FldNameArr(Ix)                               261152
     C                   MOVEL     'FTA0102'     MsgIdArr(Ix)                                 261152
     C                   ENDIF                                                                261152
     C                   END
      *
      ** Level 2 maintenance.....
     C                   ELSE
      *
      **  Check that the action code is valid.
 
     C     SACTION       IFNE      'I'
     C     SACTION       ANDNE     'A'
     C     SACTION       ANDNE     'E'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'SACTION'     FldNameArr(Ix)
     C                   MOVEL     'FDM0099'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   END
 
      ** Record must be on file.
     C     SPREF         CHAIN     OTPAYDDF                           88
     C     *IN88         IFEQ      '1'
     C                   MOVE      'N'           OKPREF
     C                   ADD       1             Ix
     C                   MOVEL     'SPREF  '     FldNameArr(Ix)
     C                   MOVEL     'MMA1061'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   END
                                                                                CFT014
      ** Access extension file                                                  CFT014
                                                                                CFT014
     C     SPREF         CHAIN     OTPAYXL0                           88        CFT014
                                                                                CFT014
      ** DB Error if record not found                                           CFT014
                                                                                CFT014
     C                   IF         @CFT014 = 'Y'                               CFT014
     C                   If        *IN88 = True                                 CFT014
     C                   Movel     'OTPAYXL0'    DBFILE                         CFT014
     C                   Movel     '031'         DBASE                          CFT014
     C                   Movel     SPREF         DBKEY                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
      *
     C/COPY WNCPYSRC,ERZ248_039                                                 ERZ248
      * Must be enquiry if record not live
      *
     C     RECI          IFNE      'D'
     C     SACTION       ANDNE     'E'
     C                   MOVE      'N'           OKPREF
     C                   ADD       1             Ix
     C                   MOVEL     'SPREF  '     FldNameArr(Ix)
     C                   MOVEL     'MMA1101'     MsgIdArr(Ix)
     C                   END
      *
     C                   END
      *
     C/COPY WNCPYSRC,FTOPAYIC02
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACE - VALIDATION OF ACTION CODE 'E'
      *****************************************************************
     C     VALACE        BEGSR
 
      **  If the Payment reference is blank, it is an error.
 
     C     SPREF         IFEQ      *BLANKS
     C                   MOVE      'N'           OKPREF
     C                   ADD       1             Ix
     C                   MOVEL     'SPREF '      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   END
 
     C**  If there is no valid record on OTPAY, it is an error.
     C     SPREF         CHAIN     OTPAY                              65
 
     C     *IN65         IFEQ      '1'
     C                   MOVE      'N'           OKPREF
     C                   ADD       1             Ix
     C                   MOVEL     'SPREF '      FldNameArr(Ix)
     C                   MOVEL     'MMA1061'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   END
 
     C     EVALAE        ENDSR
     C/COPY WNCPYSRC,FTH00469
      /EJECT
      *****************************************************************
      * VALACS - VALIDATION OF ACTION CODE 'S'                                                CFT157
      *****************************************************************                       CFT157
     C     VALACS        BEGSR                                                                CFT157
                                                                                              CFT157
      **  If the Payment reference is blank, it is an error.                                  CFT157
                                                                                              CFT157
     C     SPREF         IFEQ      *BLANKS                                                    CFT157
     C                   MOVE      'N'           OKPREF                                       CFT157
     C                   ADD       1             Ix                                           CFT157
     C                   MOVEL     'SPREF '      FldNameArr(Ix)                               CFT157
     C                   MOVEL     '5047355'     MsgIdArr(Ix)                                 CFT157
     C                   ENDIF                                                                CFT157
                                                                                              CFT157
     C**  If there is no valid record on OTPAY, it is an error.                               CFT157
     C     SPREF         CHAIN     OTPAY                              65                      CFT157
                                                                                              CFT157
     C     *IN65         IFEQ      '1'                                                        CFT157
     C                   MOVE      'N'           OKPREF                                       CFT157
     C                   ADD       1             Ix                                           CFT157
     C                   MOVEL     'SPREF '      FldNameArr(Ix)                               CFT157
     C                   MOVEL     '5047356'     MsgIdArr(Ix)                                 CFT157
     C                   ENDIF                                                                CFT157
                                                                                              CFT157
     C     RECI          IFNE      'D'                                                        CFT157
     C                   MOVE      'N'           OKPREF                                       CFT157
     C                   ADD       1             Ix                                           CFT157
     C                   MOVEL     'SPREF '      FldNameArr(Ix)                               CFT157
     C                   MOVEL     '5047361'     MsgIdArr(Ix)                                 CFT157
     C                   ENDIF                                                                CFT157
                                                                                              CFT157
     C     AUIN          IFNE      'Y'                                                        CFT157
     C                   MOVE      'N'           OKPREF                                       CFT157
     C                   ADD       1             Ix                                           CFT157
     C                   MOVEL     'SPREF '      FldNameArr(Ix)                               CFT157
     C                   MOVEL     '5047357'     MsgIdArr(Ix)                                 CFT157
     C                   ENDIF                                                                CFT157
     C     PYTP          IFNE      'OP'                                                       CFT157
     C                   MOVE      'N'           OKPREF                                       CFT157
     C                   ADD       1             Ix                                           CFT157
     C                   MOVEL     'SPREF '      FldNameArr(Ix)                               CFT157
     C                   MOVEL     '5047358'     MsgIdArr(Ix)                                 CFT157
     C                   ENDIF                                                                CFT157
                                                                                              CFT157
     C     OEDT          IFNE      BJRDNB                                                     CFT157
     C                   MOVE      'N'           OKPREF                                       CFT157
     C                   ADD       1             Ix                                           CFT157
     C                   MOVEL     'SPREF '      FldNameArr(Ix)                               CFT157
     C                   MOVEL     '5047359'     MsgIdArr(Ix)                                 CFT157
     C                   ENDIF                                                                CFT157
                                                                                              CFT157
     C     EVALAS        ENDSR                                                                CFT157
      *****************************************************************                       CFT157
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
 
      **  For Level 1 input:
     C/COPY WNCPYSRC,FTH00336
      **  If the Action code is 'I', payment reference must be blank.
     C     @Level        IFEQ      '2'
 
      ** Else for Level 2 input
      ** Payment reference must not already contain level 2 details
 
     C     LVL2          IFEQ      'Y'
     C                   MOVE      'N'           OKPREF
     C                   ADD       1             Ix
     C                   MOVEL     'SPREF  '     FldNameArr(Ix)
     C                   MOVEL     'MMA1102'     MsgIdArr(Ix)
     C                   END
 
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACA - VALIDATION OF ACTION CODE 'A'
      *****************************************************************
     C     VALACA        BEGSR
 
      **  If there is no valid, live record on OTPAY, it is an error.
     C     SPREF         CHAIN     OTPAY                              65
 
     C     *IN65         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   MOVE      'N'           OKPREF
     C                   ADD       1             Ix
     C                   MOVEL     'SPREF '      FldNameArr(Ix)
     C                   MOVEL     'MMA1061'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
 
     **  Error if payment authorised.
     C     PYTP          IFNE      'RP'
     C     AUIN          ANDEQ     'Y'
     C                   MOVE      'N'           OKPREF
     C                   ADD       1             Ix
     C                   MOVEL     'SPREF  '     FldNameArr(Ix)
     C                   MOVEL     'MMA1064'     MsgIdArr(Ix)
     C                   END
      *
      ** If amend and level 2 not complete, error when called from
      ** Level 2 maintenance.
 
     C     @Level        IFEQ      '2'
     C     RECI          IFEQ      'D'
     C     LVL2          ANDNE     'Y'
     C                   MOVE      'N'           OKPREF
     C                   ADD       1             Ix
     C                   MOVEL     'SPREF  '     FldNameArr(Ix)
     C                   MOVEL     'MMA1103'     MsgIdArr(Ix)
     C                   END
     C                   END
 
     C     EVALAA        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
 
      **  If there is no valid, live record on OTPAY, it is an error.
     C     SPREF         CHAIN     OTPAY                              65
 
     C     *IN65         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   MOVE      'N'           OKPREF
     C                   ADD       1             Ix
     C                   MOVEL     'SPREF '      FldNameArr(Ix)
     C                   MOVEL     'MMA1061'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
 
     **  Error if payment authorised.
     C     PYTP          IFNE      'RP'
     C     AUIN          ANDEQ     'Y'
     C                   MOVE      'N'           OKPREF
     C                   ADD       1             Ix
     C                   MOVEL     'SPREF  '     FldNameArr(Ix)
     C                   MOVEL     'MMA1065'     MsgIdArr(Ix)
     C                   END
      *
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,FTH00337
      *****************************************************************
      * ACSSEC - ACCESS SECURITY CHECKING
      *****************************************************************
     C     ACSSEC        BEGSR
 
      * If not multi-branching, check authority to only action code
     C     BJSBRC        IFNE      *BLANK
      *                                                                                       209408
      ** Skip Validation if enquiry comes from GL4442                                         209408
      *                                                                                       209408
     C     @GL442        IFNE      'Y'                                                        209408
     C                   CALL      'ZVACTU'
     C                   PARM      SACTION       ZACTN             1
     C                   PARM                    @@ERR             1 0
     C                   ENDIF                                                                209408
      *                                                                                       209408
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKPREF
     C                   ADD       1             Ix
     C                   MOVEL     'SACTION'     FldNameArr(Ix)
     C                   MOVEL     'FXM0292'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C                   END
 
      * If multi-branching, check authority to booking branch
     C     BJSBRC        IFEQ      *BLANK
     C     SACTION       IFEQ      'I'
     C     SBRCA         IFEQ      *BLANKS
     C                   MOVE      BRC           ZBR
     C                   MOVE      BRC           SBRCA
     C                   ELSE
     C                   MOVE      SBRCA         ZBR
     C                   END
     C                   ELSE
     C                   MOVE      BRCA          ZBR
     C                   END
 
     C     SACTION       IFEQ      'I'
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SBRCA         @DSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             Ix
     C                   MOVEL     'SBRCA '      FldNameArr(Ix)
     C                   MOVEL     'MMM0115'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   ELSE
     C                   MOVEL     A8BRCD        ZBR
     C                   MOVEL     A8BRCD        SBRCA
     C                   END
     C                   END
      *                                                                                       201852
      ** Skip Validation if enquiry comes from GL4442                                         201852
      *                                                                                       201852
     C     @GL442        IFNE      'Y'                                                        201852
     C                   CALL      'ZVACTBU'
     C                   PARM      SACTION       ZACTN             1
     C                   PARM                    ZBR               3
     C                   PARM                    @@ERR             1 0
     C                   ENDIF                                                                201852
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
 
      ** (If Insert then highlight branch field else Payment reference)
     C     SACTION       IFEQ      'I'
     C                   MOVE      'N'           OKBRCA
     C                   ELSE
     C                   MOVE      'N'           OKPREF
     C                   END
     C                   ADD       1             Ix
     C                   MOVEL     'SACTION'     FldNameArr(Ix)
     C                   MOVEL     'FXM0290'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C     @@ERR         IFEQ      2
     C                   MOVE      'N'           OKACTN
 
      ** (If Insert then highlight branch field else Payment reference)
     C     SACTION       IFEQ      'I'
     C                   MOVE      'N'           OKBRCA
     C                   ELSE
     C                   MOVE      'N'           OKPREF
     C                   END
     C                   ADD       1             Ix
     C                   MOVEL     'SACTION'     FldNameArr(Ix)
     C                   MOVEL     'FXM0291'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
 
      * Check authority to originating branch
     C     BKOBUV        IFEQ      'Y'
     C     SACTION       ANDNE     'E'
     C     SACTION       ANDNE     'I'
     C                   CALL      'ZVOBU'
     C                   PARM      ORBR          ZOBRX             3
     C                   PARM                    @@ERR             1 0
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKPREF
     C                   ADD       1             Ix
     C                   MOVEL     'SACTION'     FldNameArr(Ix)
     C                   MOVEL     'FXM0287'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C     @@ERR         IFEQ      2
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKPREF
     C                   ADD       1             Ix
     C                   MOVEL     'SACTION'     FldNameArr(Ix)
     C                   MOVEL     'FXM0288'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C                   END
     C                   END
 
     C     EACSSE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *                                                                                      BUG7029
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
     C                   UNLOCK    ZMUSER                                                    BUG7029
 
      * CLEAR OUTPUTS
     C                   CLEAR                   PmntFilFmt
     C                   CLEAR                   PmntFilFmX                     CFT014
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKPREF
     C                   MOVEL     'Y'           OKBRCA
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Parameters
     C     *ENTRY        PLIST
 
      * INPUTS
      * Return code
     C                   PARM                    RetCodeIn
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      * Response mode
     C                   PARM                    RespMode          1
      * Action Code
     C                   PARM                    SACTION           1
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * (Midas) Payment Reference
     C                   PARM                    SPREF            15
      * Booking branch
     C                   PARM                    SBRCA             3
      * Level 1/2 indicator
     C                   PARM                    @Level            1
      * @CFT014 workfield                                                       CFT014
     C                   PARM                    Val@Fields                     CFT014
 
      * OUTPUTS
      * (Current) Payment in file format
     C                   PARM                    PmntFilFmt
     C                   PARM                    PmntFilFmX                     CFT014
      * OK - Action code
     C                   PARM                    OKACTN            1
      * OK - Payment reference
     C                   PARM                    OKPREF            1
      * OK - Booking branch
     C                   PARM                    OKBRCA            1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
     C/COPY WNCPYSRC,FTOPAYIC03
      *                                                                                       CFT157
      *                                                                                       CFT157
     C                   CALLB     'AOSARDR0'                                                 CFT157
     C                   Parm      *BLANKS       @RTCD                                        CFT157
     C                   Parm      '*VERIFY'     @OPTN                                        CFT157
     C                   Parm      'CFT157'      @SARD                                        CFT157
     C     SCSARD        Parm      SCSARD        DSFDY                                        CFT157
                                                                                              CFT157
     C                   If        @RTCD <> *Blanks and                                       CFT157
     C                             @RTCD <> '*NRF   '                                         CFT157
     C     *LOCK         In        LDA                                                        CFT157
     C                   Movel     'SCSARDPD'    DBFILE                                       CFT157
     C                   Movel     '002'         DBASE                                        CFT157
     C                   Movel     'CFT157'      DBKEY                                        CFT157
     C                   Out       LDA                                                        CFT157
     C                   Exsr      *PSSR                                                      CFT157
     C                   ENDIF                                                                CFT157
                                                                                              CFT157
     C                   If        @RTCD = *Blanks                                            CFT157
     C                   Movel     'Y'           CFT157            1                          CFT157
     C                   Else                                                                 CFT157
     C                   Movel     'N'           CFT157                                       CFT157
     C                   ENDIF                                                                CFT157
 
      ** Initialize program name
 
     C                   MOVEL     'FTOPAYRTV'   DBPGM
      *                                                                                       201852
      ** Check if enquiry comes from GL4442                                                   201852
      *                                                                                       201852
     C                   MOVEL     ' '           @GL442                                       201852
     C                   MOVEL     RetCodeIn     @GL442            1                          201852
     C                   MOVE      *Blanks       RetCodeIn                                    201852
 
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS FUNDS TRANSFER DETAILS
     C*******************CALL      'AOFODAR0'                                   179994
     C*******************PARM      *BLANKS       @RTCD             7            179994
     C*******************PARM      '*FIRST '     @OPTN             7            179994
     C*****SDFODA        PARM      SDFODA        DSFDY                          179994
     C                   CALL      'AOFTFRR0'                                   179994
     C                   Parm      '*DBERR'      @RTCD                          179994
     C                   Parm      '*FIRST'      @OPTN                          179994
     C     SDFTFR        Parm      SDFTFR        DSFDY                          179994
 
      * DATABASE ERROR
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C*******************MOVEL     'SDFODAPD'    DBFILE                                       179994
     C                   MOVEL     'SDFTFRPD'    DBFILE                         ************* 179994
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
                                                                                              CSC024
      ** Check if enhancement CSC024 (Open Month End) is on                                   CSC024
                                                                                              CSC024
     C                   CALLB     'AOSARDR0'                                                 CSC024
     C                   PARM      *BLANKS       @RTCD                                        CSC024
     C                   PARM      '*VERIFY'     @OPTN                                        CSC024
     C                   PARM      'CSC024'      @SARD             6                          CSC024
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
                                                                                              CSC024
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CSC024
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC024
     C                   EVAL      DBKEY  = 'CSC024'                                          CSC024
     C                   EVAL      DBASE  = 3                                                 CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   IF        @RTCD = *BLANKS                                            CSC024
     C                   MOVEL     'Y'           CSC024            1                          CSC024
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode          7                          CSC024
     C                   PARM      SysValOME     P@OP01           20                          CSC024
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
     C                   EVAL      DBase = 4                                                  CSC024
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
     C                   EVAL      CSC024 = 'N'                                               CSC024
     C                   EVAL      GENPREF = 'Y'                                              CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
      **********                                                                             BUG7029
      ****GET*ZMUSER*to*access*default*branch.                                               BUG7029
     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C**********         IN        ZMUSER                                                    BUG7029
     C**********         UNLOCK    ZMUSER                                                    BUG7029
     C/COPY WNCPYSRC,FTH00338
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
