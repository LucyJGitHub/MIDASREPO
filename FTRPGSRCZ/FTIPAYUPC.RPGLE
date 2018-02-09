     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments db update controller')      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAYUPC - Incoming Payments DB Update Controller           *
      *                                                               *
      *  Function: This module is the main module for Midas database  *
      *            update of Incoming Payments processed thru the     *
      *            API.                                               *
      *                                                               *
      *  Component of: FTIPAYUPP                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CAP211             Date 28Sep12               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG7029            Date 09Jun05               *
      *                 GBO015             Date 01Jul04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 09Dec03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 193883             Date 20Nov01               *
      *                 201589             Date 03Jan02               *
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
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CAP211 - FT IN_OP APIs - Auto-Authorization of Payment       *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  GBO015 - Incoming Payments Beneficiary Validation            *
      *                  - Upgrade to Midasplus                       *
      *           Core hooks amended:FTIPAYU002,FTIPAYUC01            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Recompiled due to change in FTV2OPYPD               *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CSC011 - 24x7 Midas Availability                             *
      *  193883 - Recompile over changed FTIPAYUPD.                   *
      *  201589 - Change to check a new locking dataarea FTIPAYLCK    *
      *           to determine whether this DBU is already active.    *
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
      ** Valid Incoming Payment Details File
     FFTVIPAYPD UF   E             DISK    COMMIT
      *
      ** Valid Incoming Payment Details File - LF
     FFTVIPAYL1 UF   E           K DISK
     F                                     RENAME(FTVIPAYD0:FTVIPAYD1)
      *
      ** Valid Incoming Payment Details Error File
     FFTVEIPAYPDO    E             DISK
     F                                     RENAME(FTVIPAYD0:FTVIPAYERR)
      *                                                                         CFT014
      ** Valid Incoming Payment Details Extension File - LF                     CFT014
     FFTVIPY2L1 UF   E           K DISK                                         CFT014
      *                                                                         CFT014
      ** Valid Incoming Payment Details Extension Error File                    CFT014
     FFTVEIPY2PDO    E             DISK    RENAME(FTVIPY2D0:FTVIPY2ERR)         CFT014
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,FTIPAYU001
                                                                                              CER001
     FFTVIPLX1L0UF   E           K DISK    USROPN                                             CER001
      *                                                                                       CER001
      ** Midas FT IPAY - Valid File -                                                         CER001
      *                                                                                       CER001
     F                                     COMMIT                                             CER001
     FFTVEIPX1PDO    E             DISK    USROPN                                             CER001
      *                                                                                       CER001
      ** Midas FT IPAY - Deal in Error from DBU -                                             CER001
      *                                                                                       CER001
     F                                     RENAME(FTVIPLXDL:FTVIPLXDLR)                       CER001
                                                                                              CER001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
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
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
      *
      /COPY ZACPYSRC,DTAQCHKDCL
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
      *
      ** String for error message to the operator
     D WDBerrUpd       C                   CONST('DB error in FT API update')
      *
      ** String for error message to the operator
     D WProcErr        C                   CONST('Error in module')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** DS for IPAY data area details
     D FTIPAYUPC       DS             1    DTAARA(FTIPAYUPC)
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *                                                                         CFT014
      ** Incoming Payments Extension for file update - file format              CFT014
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)                   CFT014
     D/COPY WNCPYSRC,FTH00161
      *
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for General Ledger ICD details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** FT Control Data
     D PCNTRL          DS           256
     D  WGLUI                  4      4
      *
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PDBRN                 11     13
      *
      ** DS for IBANs full account
     D PIBANAcc        DS
     D**IBCNUM**               1      6  0                                                    CSD027
     D  IBCNUM                 1      6                                                       CSD027
     D  IBCCY                  7      9
     D**IBACOD**              10     13  0                                                    CGL029
     D**IBACSQ**              14     15  0                                                    CGL029
     D**IBBRCA**              16     18                                                       CGL029
     D  IBACOD                10     19  0                                                    CGL029
     D  IBACSQ                20     21  0                                                    CGL029
     D  IBBRCA                22     24                                                       CGL029
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PObject         S             10A   INZ('FTIPAYUPC')
     D PLockObj        S             10A   INZ('FTIPAYLCK')                                   201589
     D PLib            S             10A   INZ('*LIBL')
     D PObjtype        S              7A   INZ('*DTAARA')
     D PLockStateE     S              7A   INZ('*EXCL')
     D PLockStateS     S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('*CLS')
     D PDlcobj         S              1A
     D PReturn         S              7A
     D PReturn2        S              7A                                                      201589
     D PEndjob         S              1A   INZ('Y')                                           201589
      *
     D WTimestamp      S             26Z
      *
      ** Entry Point
     D PParmLevel      S              1A   INZ('1')
      *
      ** Dummy message Id and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
                                                                                              CSC011
      ** 24X7 Midas Availability switchable field                                             CSC011
     D CSC011          S              1A                                                      CSC011
                                                                                              CSD015
      ** Switchable features                                                                  CSD015
     D CSD015          S              1A                                                      CSD015
                                                                                              CSD015
      ** Compliance Watch switchable field                                                    CSD015
     D CCF001          S              1A                                                      CSD015
                                                                                              CSD015
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,FTIPAYU002
                                                                                              CER001
     D FTVIPLXL      E DS                  EXTNAME(FTVIPLX1L0)                                CER001
     D FTVIPLXLS     E DS                  EXTNAME(FTVIPLX1L0)                                CER001
     D                                     PREFIX(SS)                                         CER001
                                                                                              CER001
      *
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
      ** Get ZMUSER information.                                                             BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
      *                                                                                      BUG7029
      /COPY WNCPYSRC,FTIPAYU003
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DtaQName = 'APIPAYDTQ'
      *
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'
      ** message to the data queue if there are not.
      *
      /COPY ZACPYSRC,DTAQCHK
      *
      ** Initialise data queue parms.
      *
     C                   EVAL      PDtqLen = 10
     C                   EVAL      PDtqWait = -1
     C                   EVAL      PDtqNam = 'APIPAYDTQ'
     C                   EVAL      PDtqLib = '*LIBL'
     C                   EVAL      PObjType = '*DTAARA'
      *
      ** Wait for data queue prompt.
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file.
      *
     C     PDtqDta       DOWNE     'END'
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    PDtqNam          10
     C                   PARM                    PDtqLib          10
     C                   PARM                    PDtqLen           5 0
     C                   PARM                    PDtqDta          10
     C                   PARM                    PDtqWait          5 0
      *
     C     PDtqDta       IFEQ      'GO'
      *
      ** Lock allocation data area.
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateE
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcobj
     C                   PARM                    PReturn
      *
      /COPY WNCPYSRC,FTIPAYU004
      *
      ** Position file cursor to start of file to prevent problems on
      ** later calls.
      *
     C     1             SETLL     FTVIPAYPD
      *
      ** Read valid Incoming Payment.
      *
     C                   READ      FTVIPAYD0                              01
      *
     C     *IN01         DOWEQ     '0'
      *
      /COPY WNCPYSRC,FTIPAYU005
      *
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      ** will include the key information.
      *
     C                   EVAL      ARFOTranID = IPFRNT
     C                   EVAL      ARFOAsocID = *BLANKS
     C                   EVAL      ARRprLocn  = IPREPA
      *
      /COPY WNCPYSRC,FTIPAYU006
      *
      ** Save key fields.
      *
     C                   EVAL      WIncomingRef = IPPREF
     C                   EVAL      WTimestamp = IPTMST
      *
      /COPY WNCPYSRC,FTIPAYU007
      *
      ** Process only insert, amend and delete transactions.
      *
     C     IPCHTP        IFEQ      'I'
     C     IPCHTP        OREQ      'A'
     C     IPCHTP        OREQ      'D'
     C/COPY WNCPYSRC,FTH00449
      *                                                                         CFT014
      ** Retrieve payment reference additional details.                         CFT014
      *                                                                         CFT014
     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'                 CFT014
     C                             OR CFT009 = 'Y'                              CFT009
     C     KFTDL1        CHAIN     FTVIPY2L1                          03        CFT014
     C                   IF        *IN03                                        CFT014
     C                   MOVEL     IPPREF        DBKEY                          CFT014
     C                   MOVE      IPTMST        DBKEY                          CFT014
     C                   EVAL      DBFile = 'FTVIPY2PD'                         CFT014
     C                   Z-ADD     009           DBase                          CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
      *
      /COPY WNCPYSRC,FTIPAYU008
      *
      ** Update Incoming Payments file.
      *
     C                   CALLB     'FTIPAYUPD'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeIn
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
     C                   PARM                    NwIP2FilFmt                    CFT014
      *
      ** IBANs full account
     C                   PARM                    PIBANAcc
      *
      ** Originally Insert from Level 2 Entry
     C                   PARM      *BLANK        POrigACTN         1
      *
      ** FT Override for GL balances
     C                   PARM                    PFTOV             1
      *
      ** FT Control Data
     C                   PARM                    PCNTRL
      *
      ** Network
     C                   PARM      *BLANKS       PNWRK             6
      *
      ** Entry Point
     C                   PARM                    PParmLevel
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD
      *
      ** SDBANK - Midas Run Date
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDGELR - Originating Branch/User Vald Req.
     C                   PARM                    BKOBUV
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Batch Authorisation
     C                   PARM                    CFT003
      *
      ** IBAN numbers
     C                   PARM                    CFT004
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *                                                                         CFT014
      ** STP Phase 2 MT103                                                      CFT014
     C                   PARM                    CFT014                         CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010                         CFT009
     C                   PARM                    CSC011                                       CSC011
     C                   PARM                    CSD015                                       CSD015
     C                   PARM                    CCF001                                       CSD015
      *                                                                                       CAP211
     C                   PARM      *BLANK        PAuth             1                          CAP211
     C                   PARM      *BLANKS       PUser            10                          CAP211
      *                                                                                       CAP211
     C/COPY WNCPYSRC,FTIPAYUC01
      *
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPAYU009
      *
      ** Check for exception error from any program lower in the stack.
      ** If error detected, send message to system operator, rollback
      ** changes and terminate program.
      *
     C                   IN        APDUMP
      *
      /COPY WNCPYSRC,FTIPAYU010
      *
     C     ARErrMod      IFNE      *BLANK
     C                   EVAL      PMQErrLong = *BLANK
     C                   MOVEL     WProcErr      WMQError
     C                   MOVE      ARErrMod      WMQError         28
     C                   MOVEL     WMQError      PMQErrLong
      *
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn
     C                   PARM                    PMQErrLong      132
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
      *
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARErrMod = *BLANK
     C                   OUT       APDUMP
     C                   ROLBK
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPAYU011
     C                   IF        IPCHTP = 'I' OR IPCHTP = 'A' OR                            CER001
     C                             IPCHTP = 'D'                                               CER001
      *                                                                                       CER001
      ** Update NEW IBLC extension file                                                       CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y' and ULX611 = 'Y' and                          CER001
     C                                              RetCodeIn = *blanks                       CER001
      *                                                                                       CER001
     C     IPPREF        CHAIN     FTVIPLX1L0                         89                      CER001
     C                   IF        *IN89 = *OFF                                               CER001
     C                   EVAL      ActionCode = IPCHTP                                        CER001
     C                   CALLB     'FTIPAY2UP'                                                CER001
     C                   PARM                    ActionCode                                   CER001
     C                   PARM      *BLANK        RetCodeIn                                    CER001
     C                   PARM      *BLANK        @@FIND            1                          CER001
     C                   PARM                    FTVIPLXL                                     CER001
     C                   PARM      *BLANK        FTVIPLXLS                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      *
      ** Commit updates if no error.
      *
     C                   IF        RetCodeIn = '*ERROR ' OR
     C                             RetCodeIn = '*RECUPD'
      *
     C                   ROLBK
      *
     C                   ELSE
      *
     C                   DELETE    FTVIPAYD0
      *                                                                         CFT014
     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'                 CFT014
     C                             OR CFT009 = 'Y'                              CFT009
     C     KFTDL1        CHAIN     FTVIPY2L1                          03        CFT014
     C                   DELETE    FTVIPY2D0                            03      CFT014
      *                                                                         CFT014
      ** Error deleting record                                                  CFT014
     C                   IF        *IN03 = True                                 CFT014
     C                   MOVEL     IPPREF        DBKEY                          CFT014
     C                   MOVE      IPTMST        DBKEY                          CFT014
     C                   EVAL      DBFile = 'FTVIPY2PD'                         CFT014
     C                   Z-ADD     010           DBase                          CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C/COPY WNCPYSRC,FTIPAYUC02
      *                                                                                       CER001
      ** Delete NEW IBLC extension file before COMMIT                                         CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y' and ULX611 = 'Y'                              CER001
      *                                                                                       CER001
     C     IPPREF        CHAIN     FTVIPLX1L0                         89                      CER001
     C  N89              DELETE    FTVIPLXDL                                                  CER001
     C                   ENDIF                                                                CER001
     C                   COMMIT
      *
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPAYU012
      *
      ** If an error has occurred, reaccess record in error and remove from
      ** the file to prevent program processing the same record again.
      *
     C                   IF        RetCodeIn = '*ERROR ' OR
     C                             RetCodeIn = '*RECUPD'
      *
     C     KFTDL1        CHAIN     FTVIPAYL1                          02
      *
      ** Write details of record to error file (same format as FTVIPAYPD).
      *
     C                   WRITE     FTVIPAYERR
     C                   DELETE    FTVIPAYD1
     C/COPY WNCPYSRC,FTIPAYUC03
      *                                                                                       CER001
      ** Write  NEW IBLC extension error file and delete valid                                CER001
      ** extension file                                                                       CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y' and ULX611 = 'Y'                              CER001
      *                                                                                       CER001
     C     IPPREF        CHAIN     FTVIPLX1L0                         89                      CER001
     C                   IF        *IN89 = *OFF                                               CER001
     C                   WRITE     FTVIPLXDLR                                                 CER001
     C                   DELETE    FTVIPLXDL                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                         CFT014
      ** Re-access IP extension file and write the record on error file         CFT014
      *                                                                         CFT014
     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'                 CFT014
     C                             OR CFT009 = 'Y'                              CFT009
     C     KFTDL1        CHAIN     FTVIPY2L1                          03        CFT014
     C                   WRITE     FTVIPY2ERR                           03      CFT014
      *                                                                         CFT014
      ** Error writing record                                                   CFT014
     C                   IF        *IN03                                        CFT014
     C                   MOVEL     IPPREF        DBKEY                          CFT014
     C                   MOVE      IPTMST        DBKEY                          CFT014
     C                   EVAL      DBFile = 'FTVIPY2ERR'                        CFT014
     C                   Z-ADD     011           DBase                          CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Delete record on extension file                                        CFT014
     C                   Delete    FTVIPY2D0                            03      CFT014
      *                                                                         CFT014
      ** Error deleting record                                                  CFT014
     C                   IF        *IN03 = True                                 CFT014
     C                   MOVEL     IPPREF        DBKEY                          CFT014
     C                   MOVE      IPTMST        DBKEY                          CFT014
     C                   EVAL      DBFile = 'FTVIPY2PD'                         CFT014
     C                   Z-ADD     012           DBase                          CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
     C/COPY WNCPYSRC,FTH00162
      *
      ** Send message to system operator.
      *
     C                   MOVEL     WDBerrUpd     PDBError         28
      *
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn       10
     C                   PARM                    PDBError
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
      *
     C                   ENDIF
      *
     C                   EVAL      RetCodeIn = *BLANKS
      *
      ** Read valid Incoming Payment.
      *
     C                   READ      FTVIPAYD0                              01
      *
     C                   ENDDO
      *
      ** Unlock allocation data area.
      *
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateE
     C                   PARM                    PMember
     C                   PARM                    PReturn
      *
     C                   ENDIF
      *
      ** End loop for data queue prompt.
      *
     C                   ENDDO
      *
      /COPY WNCPYSRC,FTIPAYU013
      *
      ** Exit from program.
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,FTIPAYU014
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
      ** Define key list for FTVIPAYL1.
      *
     C     KFTDL1        KLIST
     C                   KFLD                    WIncomingRef     15
     C                   KFLD                    WTimestamp
      *
      *  Check if an existing DBU_IPAY job is active in the subsystem.                        201589
                                                                                              201589
     C                   CALL      'SCC0520'                                                  201589
     C                   PARM                    PLockObj                                     201589
     C                   PARM                    PLib                                         201589
     C                   PARM                    PObjType                                     201589
     C                   PARM                    PLockStateE                                  201589
     C                   PARM                    PMember                                      201589
     C                   PARM                    PEndjob                                      201589
     C                   PARM                    PReturn2                                     201589
                                                                                              201589
      **  Lock allocation data area.
      *
      **  The data area is allocated *SHRRD here and *EXCL whilst processing
      **  of the valid file is actually taking place.
      **  The function to submit this updater tries to get a *EXCL lock.
      **  The controller tries to get a *SHRRD lock.
      **
      **                        Submitter             Controller
      **
      **                Lock      Lock     Submitter     Lock     Controller
      **     Status    Status   Successful   Action   Successful    Action
      **     ------    ------   ---------- ---------  ----------  ----------
      **
      **  Not running  None        Yes      Submit       Yes        Prompt
      **                                    updater                 updater
      **  Running not  *SHRRD      No        None        Yes        Prompt
      **   processing                                               updater
      **  Processing   *EXCL       No        None        No         None
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateS
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcobj
     C                   PARM                    PReturn
      *
      ** Create required QTEMP objects.
      *
     C                   CALL      'APCCRTQTO'
     C                   PARM                    PReturnCde       10
      *
      ** Access FT Control data.
      *
     C                   CALL      'FT0005'                             9090
     C                   PARM      *BLANKS       PRtcd             7
     C     PCNTRL        PARM                    PPDTA           256
      *
     C                   IF        *IN90 = '1' OR PRtcd <> *BLANKS
     C                   MOVEL     '*CALL'       DBKey
     C                   Move      'FT0005'      DBFile
     C                   Z-ADD     001           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        WGLUI = 'I'
     C                   EVAL      PFTOV = 'Y'
     C                   ELSE
     C                   EVAL      PFTOV = *BLANKS
     C                   ENDIF
      *
      ** Access Bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C     PRtcd         IFNE      *BLANKS
     C                   MOVEL     POptn         DBKey
     C                   MOVEL     'SDBANKPD'    DBFile
     C                   Z-ADD     002           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access General Ledger details.
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Database error.
      *
     C     PRtcd         IFNE      *BLANKS
     C                   MOVEL     POptn         DBKey
     C                   MOVEL     'SDGELRPD'    DBFile
     C                   Z-ADD     003           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if CFT003
      ** (FT Batch Authorisation) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT003'      PSarD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRtcd         IFNE      *BLANKS
     C     PRtcd         ANDNE     '*NRF   '
     C                   MOVEL     'CFT003'      DBKey
     C                   MOVEL     'SCSARDPD'    DBFile
     C                   Z-ADD     004           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRtcd         IFEQ      *BLANK
     C                   MOVEL     'Y'           CFT003            1
     C                   ELSE
     C                   MOVEL     'N'           CFT003
     C                   ENDIF
      *
      ** Access SAR file to determine if S01499
      ** (BLI VAT Processing) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01499'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRtcd         IFNE      *BLANKS
     C     PRtcd         ANDNE     '*NRF   '
     C                   MOVEL     'S01499'      DBKey
     C                   MOVEL     'SCSARDPD'    DBFile
     C                   Z-ADD     005           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRtcd         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01499            1
     C                   ELSE
     C                   MOVEL     'N'           S01499
     C                   ENDIF
      *
      ** Access SAR file to determine if S01494 (BLI Funds Transfer)
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01494'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRtcd         IFNE      *BLANKS
     C     PRtcd         ANDNE     '*NRF   '
     C                   MOVEL     'S01494'      DBKey
     C                   MOVEL     'SCSARDPD'    DBFile
     C                   Z-ADD     006           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRtcd         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01494            1
     C                   ELSE
     C                   MOVEL     'N'           S01494
     C                   ENDIF
      *
      ** Access SAR file to determine if CFT004 (IBAN
      ** numbers) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT004'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CFT004'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     007           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CFT004            1
     C                   ELSE
     C                   MOVEL     'N'           CFT004
     C                   ENDIF
      *                                                                         CFT014
      ** Access SAR file to determine if CFT014 (STP Phase 2                    CFT014
      ** MT103 for FT is installed.                                             CFT014
      *                                                                         CFT014
     C                   CALLB     'AOSARDR0'                                   CFT014
     C                   PARM      *BLANKS       PRTCD                          CFT014
     C                   PARM      '*VERIFY'     POPTN                          CFT014
     C                   PARM      'CFT014'      PSARD                          CFT014
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT014
      *                                                                         CFT014
      ** An NRF (No Record Found) return code is valid.                         CFT014
      ** Issue database error only for error return codes.                      CFT014
      *                                                                         CFT014
     C     PRTCD         IFNE      *BLANKS                                      CFT014
     C     PRTCD         ANDNE     '*NRF   '                                    CFT014
     C                   MOVEL     'CFT014'      DBKEY                          CFT014
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT014
     C                   Z-ADD     008           DBASE                          CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
     C     PRTCD         IFEQ      *BLANK                                       CFT014
     C                   MOVEL     'Y'           CFT014            1            CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     'N'           CFT014                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT009
      ** Access SAR file to determine if CFT009 is installed                    CFT009
      *                                                                         CFT009
     C                   CALLB     'AOSARDR0'                                   CFT009
     C                   PARM      *BLANKS       PRTCD                          CFT009
     C                   PARM      '*VERIFY'     POPTN                          CFT009
     C                   PARM      'CFT009'      PSARD                          CFT009
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT009
      *                                                                         CFT009
      ** An NRF (No Record Found) return code is valid.                         CFT009
      ** Issue database error only for error return codes.                      CFT009
      *                                                                         CFT009
     C     PRTCD         IFNE      *BLANKS                                      CFT009
     C     PRTCD         ANDNE     '*NRF   '                                    CFT009
     C                   MOVEL     'CFT009'      DBKEY                          CFT009
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT009
     C                   Z-ADD     013           DBASE                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C     PRTCD         IFEQ      *BLANK                                       CFT009
     C                   MOVEL     'Y'           CFT009            1            CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           CFT009                         CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
      ** Access SAR file to determine if CFT010 is installed                    CFT009
      *                                                                         CFT009
     C                   CALLB     'AOSARDR0'                                   CFT009
     C                   PARM      *BLANKS       PRTCD                          CFT009
     C                   PARM      '*VERIFY'     POPTN                          CFT009
     C                   PARM      'CFT010'      PSARD                          CFT009
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT009
      *                                                                         CFT009
      ** An NRF (No Record Found) return code is valid.                         CFT009
      ** Issue database error only for error return codes.                      CFT009
      *                                                                         CFT009
     C     PRTCD         IFNE      *BLANKS                                      CFT009
     C     PRTCD         ANDNE     '*NRF   '                                    CFT009
     C                   MOVEL     'CFT010'      DBKEY                          CFT009
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT009
     C                   Z-ADD     014           DBASE                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C     PRTCD         IFEQ      *BLANK                                       CFT009
     C                   MOVEL     'Y'           CFT010            1            CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           CFT010                         CFT009
     C                   ENDIF                                                  CFT009
                                                                                              CSC011
      ** Access SAR details file to see if 24X7 (CSC011) is installed.                        CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> *BLANKS AND                                       CSC011
     C                             PRTCD <> '*NRF   '                                         CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 15                                                 CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSD015
      ** Check if Compliance Watch Enhancement (CSD015) is installed                          CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *Blank        PRtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS) AND                                     CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKey = 'CSD015'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 39                                                 CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtCd = *Blank                                             CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access SAR details to see if CCF001 is switched on.                                 CSD015
                                                                                              CSD015
     C                   EVAL      CCF001 = 'N'                                               CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PrtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CCF001'      @SARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PrtCd <> *Blanks  AND                                      CSD015
     C                             PrtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CCF001'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 40                                                 CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PrtCd = *BLANKS                                            CSD015
     C                   EVAL      CCF001 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **********                                                                             BUG7029
      ***Get*ZMUSER*information.                                                             BUG7029
      **********                                                                             BUG7029
     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C**********         IN        ZMUSER                                                    BUG7029
     C/COPY WNCPYSRC,FTH00163
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,FTIPAYU015
      *                                                                                       CER001
      ** ULX611 - API Luxembourg - Function FTIPAY                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX611            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX611'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 16                                                 CER001
     C                   EVAL      DBKEY = 'ULX611'                                           CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   MOVEL     'Y'           ULX611                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX043 - New IBLC 2002 as Feature                                                    CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX043            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 17                                                 CER001
     C                   EVAL      DBKEY = 'ULX043'                                           CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX611 = 'Y' and ULX043 = 'Y'                              CER001
     C                   OPEN      FTVIPLX1L0                                                 CER001
     C                   OPEN      FTVEIPX1PD                                                 CER001
     C                   ENDIF                                                                CER001
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
