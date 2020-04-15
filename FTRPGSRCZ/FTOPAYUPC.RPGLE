     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments dbase update controller')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTOPAYUPC - OUTGOING PAYMENTS DATABASE UPDATE CONTROLLER     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. ERZ248             Date 18Nov19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CFT120             Date 28Sep12               *
      *                 CAP211             Date 28Sep12               *
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
      *                 CSD027             Date 10Apr06               *
      *                 CER001             Date 25Apr05               *
      *                 BUG4776R (Reopen)  Date 22Dec04               *
      *                 BUG4776            Date 15Nov04               *
      *                 CFT116             Date 12Jul04               *
      *                 CGL014             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 16Oct03               *
      *                 CSD015             Date 14Oct02               *
      *                 204029             Date 26Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 197420             Date 13Sep01               *
      *                 193883             Date 20Nov01               *
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 16Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CPB001             Date 23Aug99               *
      *                 CAP031  *CREATE    Date 01Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  ERZ248 - SWIFT UETR via OPAY API                             *
      *           Add hooks ERZ248_041->042                           *
      *           Amended hooks FTH00195, FTOPAYU010, FTOPAYU013,     *
      *           FTOPAYUCC1                                          *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CAP211 - FT IN_OP APIs - Auto-Authorization of Payment       *
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
      *  CSD027 - Change Customer Number to alpha.                    *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG4776R-Reverse fix since fix only applies to Incoming.     *
      *           (Reopen)                                            *
      *  BUG4776- Correct skipping of transaction reference.          *
      *  CFT116 - Core changes for GBO016                             *
      *         - MT110 Generation in Funds Transfer                  *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:FTOPAYU011,FTOPAYUCC1            *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing.                                  *
      *         - Recompile due to change in FTVOPY2PD                *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  204029 - Data decimal error on fields MISC01,2,3,4,5         *
      *           and SWSCHG when CFT009 is not on (RECOMPILE).       *
      *  CSC011 - 24x7 Midas Availability                             *
      *  197420 - Prevent lock on data area for transaction.          *
      *  193883 - Recompile over changed FTOPAYUPD.                   *
      *  201589 - Change to check a new locking dataarea FTOPAYLCK    *
      *           to determine whether this DBU is already active.    *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompile - BIC Database Plus Integration           *
      *  CFT004 - Recompile, IBAN - International Bank Account Number *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FFTVOPAYPD UF   E             DISK    COMMIT
     F                                     INFSR(*PSSR)
 
     FFTVOPAYL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FTVOPAYD0:FTVOPAYD1)
 
     FFTVEOPAYPDO    E             DISK    INFSR(*PSSR)
     F                                     RENAME(FTVOPAYD0:FTVOPAYERR)
                                                                                CFT014
     FFTVOPY2PD UF   E             DISK    COMMIT                               CFT014
     F                                     INFSR(*PSSR)                         CFT014
                                                                                CFT014
     FFTVOPY2L1 UF   E           K DISK    INFSR(*PSSR)                         CFT014
     F                                     RENAME(FTVOPY2D0:FTVOPY2D1)          CFT014
                                                                                CFT014
     FFTVEOPY2PDO    E             DISK    INFSR(*PSSR)                         CFT014
     F                                     RENAME(FTVOPY2D0:FTVOPY2ERR)         CFT014
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FTOPAYU010
     FFTVOPLX1L0UF   E           K DISK    USROPN                                             CER001
      *                                                                                       CER001
      ** Midas FT OPAY - Valid File                                                           CER001
      *                                                                                       CER001
     F                                     COMMIT                                             CER001
     FFTVEOPX1PDO    E             DISK    USROPN                                             CER001
      *                                                                                       CER001
      ** Midas FT OPAY - Deal in Error from DBU                                               CER001
      *                                                                                       CER001
     F                                     RENAME(FTVOPLXDL:FTVOPLXDLR)                       CER001
      *                                                                                       CER001
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
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in OPAY API update')
 
      *****************************************************************
 
      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      **                                                                                      CSC022
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID OUTGOING PAYMENT
     D FTVOPY        E DS                  EXTNAME(FTVOPAYPD)
     D FTVOPYX       E DS                  EXTNAME(FTVOPY2PD)                   CFT014
     D/COPY WNCPYSRC,FTH00193
 
      * Flags to indicate whether transaction fields are valid
     D FTEOPY1       E DS                  EXTNAME(FTEOPY1PD)
     D FTEOPY2       E DS                  EXTNAME(FTEOPY2PD)
     D FTEOPY3       E DS                  EXTNAME(FTEOPY3PD)
     D FTEOPY4       E DS                  EXTNAME(FTEOPY4PD)                   CFT014
     D FTEOPY5       E DS                  EXTNAME(FTEOPY5PD)                   CFT014
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
     D FTOPAYUPC       DS             1    DTAARA(FTOPAYUPC)
 
     D Object          S             10A   INZ('FTOPAYUPC')
     D LockObj         S             10A   INZ('FTOPAYLCK')                                   201589
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockStateE      S              7A   INZ('*EXCL')
     D LockStateS      S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('*CLS')
     D Dlcobj          S              1A
     D Return          S              7A
     D Return2         S              7A                                                      201589
     D Endjob          S              1A   INZ('Y')                                           201589
     D @Timestamp      S             26Z
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      * Overide file OTPAY in UPD module
     D  OVERRIDE       S             47    INZ('OVRDBF FILE(OTPAYOVR)  +
     D                                            TOFILE(OTPAY) SHARE(*NO)')
                                                                                CFT014
      ** Overide file OTPAYXL0 in UPD module.                                   CFT014
     D  OVROPXL0       S             49    INZ('OVRDBF FILE(OTXL0)  +           CFT014
     D                                            TOFILE(OTPAYXL0) SHARE(*NO)') CFT014
      **********                                                                    BUG4776 BUG4776R
      ***Overide*file*FTPREFL0*in*UPD*module.*******************************        BUG4776 BUG4776R
     D**OVRFTPRF***    S             49    INZ('OVRDBF FILE(FTPREFX1) +             BUG4776 BUG4776R
     D**********                                  TOFILE(FTPREFL0) SHARE(*NO)')     BUG4776 BUG4776R
                                                                                              CSC011
      ** Access Object parameter fields                                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * External data structure for currency codes
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      * External data structure for General Ledger details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** SCCMTJOB DataArea Layout                                                             CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WDSJobs                4    103A                                                      CSC022
      **                                                                                      CSC022
      * Data structure to retrieve multi branch indicator
     DRUNDAT           DS
     D WMBIN                  13     13
 
     D TCNTRL          DS           256
     D  WPDTI                  1      1
     D  WGLUI                  4      4
     D  WVATF                  6      6
 
      * Data structure to retrieve VAT rate
     DVATDS            DS
     D WVATR                  10     12P 4
 
      ** CSC022 switchable field                                                              CSC022
     D CSC022          S              1A                                                      CSC022
      **                                                                                      CSC022
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
      **                                                                                      CSC022
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FTOPAYU011
     D FTVOPLXL      E DS                  EXTNAME(FTVOPLX1L0)                                CER001
     D FTVOPLXLS     E DS                  EXTNAME(FTVOPLX1L0)                                CER001
     D                                     PREFIX(SS)                                         CER001
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
 
      /COPY WNCPYSRC,FTOPAYU001
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APOPAYDTQ'
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
      *  Initialise Data queue parms
     C                   EVAL      DtqLen = 10
     C                   EVAL      DtqWait = -1
     C                   EVAL      DtqNam = 'APOPAYDTQ'
     C                   EVAL      DtqLib = '*LIBL'
     C                   EVAL      ObjType = '*DTAARA'
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file
     C     DtqDta        DOWNE     'END'
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam           10
     C                   PARM                    DtqLib           10
     C                   PARM                    DtqLen            5 0
     C                   PARM                    DtqDta           10
     C                   PARM                    DtqWait           5 0
      *
      ** Lock allocation data area
      *
     C     DtqDta        IFEQ      'GO'
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      /COPY WNCPYSRC,FTOPAYU002
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     FTVOPAYPD
 
      ** READ VALID OUTGOING PAYMENTS
     C                   READ      FTVOPAYPD                              99    *
     C     *IN99         DOWEQ     '0'
 
      /COPY WNCPYSRC,FTOPAYU003
 
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lower level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = OTFRNT
     C                   EVAL      ARRprLocn  = OTREPA
 
      /COPY WNCPYSRC,FTOPAYU004
 
      /COPY WNCPYSRC,FTOPAYU005
 
      ** FT DATABASE UPDATE
     C     @@RTCD        IFNE      '*RECUPD'
     C     OTCHTP        IFEQ      'I'
     C     OTCHTP        OREQ      'A'
     C     OTCHTP        OREQ      'D'
     C/COPY WNCPYSRC,FTH00470
 
      ** Set up fields on Val@Fields
     C                   EXSR      SetParms
 
      /COPY WNCPYSRC,FTOPAYU006
 
      ** Access Outgoing Payments extension valid file for other OP details     CFT014
                                                                                CFT014
     C                   If        (@CFT003 = 'Y') Or (@CFT014 = 'Y')           CFT014
     C                             OR (@CFT009 = 'Y')                           CFT009
     C                   Movel     OTPREF        KOTPREF                        CFT014
     C                   Movel     OTTMESTMP     KOTTIME                        CFT014
     C     KOPAYVLD      Chain     FTVOPY2L1                          89        CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C/COPY WNCPYSRC,ERZ248_041                                                 ERZ248
 
     C                   CALLB     'FTOPAYUPD'
      *  Return Code
     C                   PARM                    @@RTCD           10
 
      *  OK Flags
     C                   Parm                    FTEOPY1
     C                   Parm                    FTEOPY2
     C                   Parm                    FTEOPY3
     C                   Parm                    FTEOPY4                        CFT014
     C                   Parm                    FTEOPY5                        CFT014
 
      * New Valid payment layout
     C                   PARM                    FTVOPY
     C                   PARM                    FTVOPYX                        CFT014
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      *                                                                                       CAP211
     C                   PARM      *BLANK        PAuth             1                          CAP211
     C                   PARM      *BLANKS       PUser            10                          CAP211
      *                                                                                       CAP211
     C/COPY WNCPYSRC,FTOPAYUCC1
 
     C                   END
     C                   END
 
      /COPY WNCPYSRC,FTOPAYU007
      *                                                                                       CER001
      ** Perform IBLC 2002 treatment if required                                              CER001
      *                                                                                       CER001
     C     ULX608        IFEQ      'Y'                                                        CER001
     C     ULX043        ANDEQ     'Y'                                                        CER001
     C     @@RTCD        ANDEQ     *BLANK                                                     CER001
      *                                                                                       CER001
     C     OTPREF        CHAIN     FTVOPLX1L0                         89                      CER001
      *                                                                                       CER001
      ** FT extended database update                                                          CER001
      *                                                                                       CER001
     C                   EVAL      ActionCode = OTCHTP                                        CER001
     C                   CALLB     'FTOPAY2UP'                                                CER001
     C                   PARM                    ActionCode                                   CER001
     C                   PARM      *BLANK        @@RTCD                                       CER001
     C                   PARM      *BLANK        @@FIND            1                          CER001
     C                   PARM                    FTVOPLXL                                     CER001
     C                   PARM      *BLANK        FTVOPLXLS                                    CER001
      *                                                                                       CER001
      ** Delete record from valid file                                                        CER001
      *                                                                                       CER001
     C     @@RTCD        IFEQ      *BLANK                                                     CER001
     C                   DELETE    FTVOPLXDL                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
 
      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpComtRolbk = 'N'                                        CSC022
     C                   RolBk                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C/COPY WNCPYSRC,FTH00194
     C                   ELSE
     C                   DELETE    FTVOPAYPD                            98
 
     C     *IN98         IFEQ      '1'
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   MOVEL     'FTVOPAYPD'   DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     *BLANKS       DBKEY                          ************
     C                   MOVE      OTFRNT        DBKEY
     C                   MOVEL     OTTMESTMP     DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                CFT014
      ** Delete record being processed when update is successful                CFT014
                                                                                CFT014
     C                   If        (@CFT003 = 'Y') Or (@CFT014 = 'Y')           CFT014
     C                             OR (@CFT009 = 'Y')                           CFT009
     C                   Delete    FTVOPY2D1                            98      CFT014
     C                   If        *IN98 = True                                 CFT014
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   RolBk                                                  CFT014
     C                   EndIf                                                                CSC022
     C                   Movel     'FTVOPY2PD'   DBFILE                         CFT014
     C                   Movel     '030'         DBASE                          CFT014
     C                   Movel     *Blanks       DBKEY                          CFT014
     C                   Move      O2FRNT        DBKEY                          CFT014
     C                   Movel     O2TMST        DBKEY                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C/COPY WNCPYSRC,FTH00195
 
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   END
 
      /COPY WNCPYSRC,FTOPAYU008
      *                                                                                       CER001
      ** If an error has occurred, remove record in error from                                CER001
      ** the file and write details of record to error valid file                             CER001
      *                                                                                       CER001
     C     ULX608        IFEQ      'Y'                                                        CER001
     C     ULX043        ANDEQ     'Y'                                                        CER001
      *                                                                                       CER001
     C     @@RTCD        IFEQ      '*ERROR '                                                  CER001
     C     @@RTCD        OREQ      '*RECUPD'                                                  CER001
      *                                                                                       CER001
      ** Write record details in error valid file and remove it from file                     CER001
      *                                                                                       CER001
     C                   WRITE     FTVOPLXDLR                                                 CER001
     C                   DELETE    FTVOPLXDL                                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C                   EVAL      @Pmntref = OTPREF
     C                   EVAL      @Timestamp = OTTMESTMP
     C     @KFTOP1       CHAIN     FTVOPAYL1                          89
     ** Write details of record to error file (same format as FTVOPAYPD)
     C                   WRITE     FTVOPAYERR                           98
 
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'FTVEOPAYPD'  DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   MOVEL     *BLANKS       DBKEY                          ************
     C                   MOVE      OTFRNT        DBKEY
     C                   MOVEL     OTTMESTMP     DBKEY
     C                   EXSR      *PSSR
     C                   END
 
     C                   DELETE    FTVOPAYD1                            98
 
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'FTVOPAYPD'   DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 003*
     C                   MOVEL     *BLANKS       DBKEY                          ************
     C                   MOVE      OTPREF        DBKEY
     C                   MOVEL     OTTMESTMP     DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                CFT014
      ** Re-access OP extension file and write the record on error file         CFT014
                                                                                CFT014
     C                   If        (@CFT003 = 'Y') Or (@CFT014 = 'Y')           CFT014
     C                             OR (@CFT009 = 'Y')                           CFT009
     C     *Loval        Setll     FTVOPY2L1                                    CFT014
                                                                                CFT014
     C     KOPAYVLD      Chain     FTVOPY2L1                          89        CFT014
     C                   Write     FTVOPY2ERR                           98      CFT014
                                                                                CFT014
      ** Error writing record                                                   CFT014
                                                                                CFT014
     C                   If        *IN98 = True                                 CFT014
     C                   Movel     'FTVOPY2ERR'  DBFILE                         CFT014
     C                   Movel     '031'         DBASE                          CFT014
     C                   Movel     *Blanks       DBKEY                          CFT014
     C                   Move      O2FRNT        DBKEY                          CFT014
     C                   Movel     O2TMST        DBKEY                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Delete record on extension file                                        CFT014
                                                                                CFT014
     C                   Delete    FTVOPY2D1                            98      CFT014
                                                                                CFT014
      ** Error deleting record                                                  CFT014
                                                                                CFT014
     C                   If        *IN98 = True                                 CFT014
     C                   Movel     'FTVOPY2PD'   DBFILE                         CFT014
     C                   Movel     '032'         DBASE                          CFT014
     C                   Movel     *Blanks       DBKEY                          CFT014
     C                   Move      O2FRNT        DBKEY                          CFT014
     C                   Movel     O2TMST        DBKEY                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
      *
     C/COPY WNCPYSRC,ERZ248_042                                                 ERZ248
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** READ VALID OUTGOING PAYMENTS
     C                   READ      FTVOPAYPD                              99    *
     C                   END
     ** Unlock allocation data area
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Return
      ** Deallocate dara area created by FTOPAYUPD.                             197420
     C                   CALL      'AOC8000'                                    197420
     C                   PARM      *BLANK        C#RTCD            7            197420
     C                   PARM      'FT'          @MODLE            2            197420
     C                   PARM      *BLANK        @TREF            15            197420
     C                   PARM      *BLANK        @RTINF           80            197420
     C                   END
      ** End loop for data queue prompt
     C                   END
 
      /COPY WNCPYSRC,FTOPAYU009
 
      * EXIT FROM PROGRAM
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FTOPAYU012
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SetParms - Set up of fields required to be passed to FTOPAYUPD*
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SetParms      BEGSR
 
     C* Charges branch
      * If single branch...
     C                   If        @MBIN = 'N'
     C                   Eval      @PYBR = BJSBRC
 
     C                   Else
      * Else,if multi branched...
     C                   If        @MBIN = 'Y' and
     C                             BKOBRU = 'Y'
     C                   Eval      @PYBR = OTORBR
     C                   Else
     C                   Eval      @PYBR = OTBRCA
     C                   End
 
     C                   End
     C*
     C*
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *  Define key list for FTVOPAYL1
     C     @KFTOP1       KLIST
     C                   KFLD                    @Pmntref         15
     C                   KFLD                    @Timestamp
                                                                                CFT014
      ** Define keyfields for extension file                                    CFT014
                                                                                CFT014
     C     *Like         Define    OTPREF        KOTPREF                        CFT014
     C     *Like         Define    OTTMESTMP     KOTTIME                        CFT014
                                                                                CFT014
     C     KOPAYVLD      KList                                                  CFT014
     C                   KFld                    KOTPREF                        CFT014
     C                   KFld                    KOTTIME                        CFT014
 
      *  Check if an existing DBU_OPAY job is active in the subsystem.                        201589
                                                                                              201589
     C                   CALL      'SCC0520'                                                  201589
     C                   PARM                    LockObj                                      201589
     C                   PARM                    Lib                                          201589
     C                   PARM                    ObjType                                      201589
     C                   PARM                    LockStateE                                   201589
     C                   PARM                    Member                                       201589
     C                   PARM                    Endjob                                       201589
     C                   PARM                    Return2                                      201589
                                                                                              201589
      *  Lock allocation data area
 
      *   The data area is allocated *SHRRD here and *EXCL whilst processing
      *    of the valid file is actually taking place.
      *   The function to submit this updater tries to get a *EXCL lock.
      *   The controller tries to get a *SHRRD lock.
 
      *                         Submitter             Controller
      *                 Lock      Lock     Submitter     Lock     Controller
      *      Status    Status   Successful   Action   Successful    Action
      *      ------    ------   ---------- ---------  ----------  ----------
      *   Not running  None        Yes      Submit       Yes        Prompt
      *                                     updater                 updater
 
      *   Running not  *SHRRD      No        None        Yes        Prompt
      *    processing                                               updater
 
      *   Processing   *EXCL       No        None        No         None
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateS
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      ** Create required QTEMP objects
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde        10
 
      * Override file 'OTPAY' in UPD module to 'OTPAYOVR'
     C                   CALL      'QCMDEXC'
     C                   PARM                    OVERRIDE
     C                   PARM      47            OvrLen           15 5
                                                                                CFT014
      ** Override file 'OTPAYXL0' in UPD module with SHARE(*NO)                 CFT014
                                                                                CFT014
     C                   CALL      'QCMDEXC'                                    CFT014
     C                   PARM                    OVROPXL0                       CFT014
     C                   PARM      49            OvrLen1          15 5          CFT014
 
      ***Override*file*'FTPREFL0'*in*UPD*module*with*SHARE(*NO)***************      BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
     C**********         CALL      'QCMDEXC'                                        BUG4776 BUG4776R
     C**********         PARM                    OVRFTPRF                           BUG4776 BUG4776R
     C**********         PARM      49            OvrLen1          15 5              BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
      * Access FT Control data
     C                   CALL      'FT0005'                             9090
     C                   Parm      *BLANKS       @RTCD
     C     TCNTRL        Parm      TCNTRL        DSFDY
      *
     C                   If        *IN90 = *ON or
     C                             @RTCD = '*ERROR*'
     C                   Move      'FTOPAYUPC '  DBPGM
     C                   Move      'FT0005'      DBFILE
     C                   Eval      DBASE = 20
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        WGLUI = 'I'
     C                   Eval      @FTOV = 'Y'
     C                   Else
     C                   Eval      @FTOV = *Blanks
     C                   End
     C                   Eval      @PDTI =WPDTI
     C                   Eval      @VATF =WVATF
 
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
      * Access SAR details file to determine if CEU006 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CEU006'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C     *LOCK         In        LDA
     C                   Movel     'SCSARDPD'    DBFILE
     C                   Movel     '002'         DBASE
     C                   Movel     'CEU006'      DBKEY
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CEU006           1
     C                   Else
     C                   Movel     'N'           @CEU006
     C                   End
 
      * Access SAR details file to determine if S01494 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01494'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C     *LOCK         In        LDA
     C                   Movel     'SCSARDPD'    DBFILE
     C                   Movel     '002'         DBASE
     C                   Movel     'S01494'      DBKEY
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01494
     C                   Else
     C                   Movel     'N'           @01494
     C                   End
 
      * Access SAR details file to determine if S01499 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01499'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C     *LOCK         In        LDA
     C                   Movel     'SCSARDPD'    DBFILE
     C                   Movel     '002'         DBASE
     C                   Movel     'S01499'      DBKEY
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01499
     C                   Else
     C                   Movel     'N'           @01499
     C                   End
 
      * Read V.A.T. details if S01499 switched ON
     C                   If        @01499 = 'Y'
     C                   CALL      'AOVATR0'                            9090
     C                   Parm      '*MSG   '     @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C                   Parm                    VATDS
 
     C                   If        *IN90 = *ON or
     C                             @RTCD = '*ERROR*'
     C                   Move      'FTOPAYUPC '  DBPGM
     C                   Move      'AOVATR0'     DBFILE
     C                   Eval      DBASE = 2
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
 
     C                   Else
     C                   Eval      @VATR = WVATR
     C                   Eval      @VATP = 'Y'
     C                   End
     C                   End
 
      * Access SAR details file to see if CFT003 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT003'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Movel     'SCSARDPD'    DBFILE
     C                   Movel     '002'         DBASE
     C                   Movel     'CFT003'      DBKEY
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT003
     C                   Else
     C                   Movel     'N'           @CFT003
     C                   End
 
      * Access SAR details file to see if S01508 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01508'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Movel     'SCSARDPD'    DBFILE
     C                   Movel     '002'         DBASE
     C                   Movel     'S01508'      DBKEY
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01508
     C                   Else
     C                   Movel     'N'           @01508
     C                   End
 
      * Access SAR details file to see if S01506 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01506'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Movel     'SCSARDPD'    DBFILE
     C                   Movel     '002'         DBASE
     C                   Movel     'S01506'      DBKEY
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01506
     C                   Else
     C                   Movel     'N'           @01506
     C                   End
                                                                                CFT014
      ** Access SAR details file to see if CFT014 is installed.                 CFT014
                                                                                CFT014
     C                   Callb     'AOSARDR0'                                   CFT014
     C                   Parm      *BLANKS       @RTCD                          CFT014
     C                   Parm      '*VERIFY'     @OPTN                          CFT014
     C                   Parm      'CFT014'      @SARD                          CFT014
     C     SCSARD        Parm      SCSARD        DSFDY                          CFT014
                                                                                CFT014
     C                   If        @RTCD <> *Blanks and                         CFT014
     C                             @RTCD <> '*NRF   '                           CFT014
     C                   Movel     'SCSARDPD'    DBFILE                         CFT014
     C                   Movel     '033'         DBASE                          CFT014
     C                   Movel     'CFT014'      DBKEY                          CFT014
     C                   Exsr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        @RTCD = *Blanks                              CFT014
     C                   Movel     'Y'           @CFT014                        CFT014
     C                   Else                                                   CFT014
     C                   Movel     'N'           @CFT014                        CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT009
      ** Access SAR details file to see if CFT009 is installed.                 CFT009
                                                                                CFT009
     C                   CALLB     'AOSARDR0'                                   CFT009
     C                   PARM      *BLANKS       @RTCD                          CFT009
     C                   PARM      '*VERIFY'     @OPTN                          CFT009
     C                   PARM      'CFT009'      @SARD                          CFT009
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT009
                                                                                CFT009
     C                   IF        @RTCD <> *BLANKS AND                         CFT009
     C                             @RTCD <> '*NRF   '                           CFT009
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT009
     C                   MOVEL     '034'         DBASE                          CFT009
     C                   MOVEL     'CFT009'      DBKEY                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        @RTCD = *BLANKS                              CFT009
     C                   MOVEL     'Y'           @CFT009                        CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           @CFT009                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** Access SAR details file to see if CFT010 is installed.                 CFT009
                                                                                CFT009
     C                   CALLB     'AOSARDR0'                                   CFT009
     C                   PARM      *BLANKS       @RTCD                          CFT009
     C                   PARM      '*VERIFY'     @OPTN                          CFT009
     C                   PARM      'CFT010'      @SARD                          CFT009
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT009
                                                                                CFT009
     C                   IF        @RTCD <> *BLANKS AND                         CFT009
     C                             @RTCD <> '*NRF   '                           CFT009
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT009
     C                   MOVEL     '035'         DBASE                          CFT009
     C                   MOVEL     'CFT010'      DBKEY                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        @RTCD = *BLANKS                              CFT009
     C                   MOVEL     'Y'           @CFT010                        CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           @CFT010                        CFT009
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
     C                   EVAL      DBASE = 36                                                 CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      @CSC011 = 'Y'                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      @CSC011 = 'N'                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSD015
      ** Check if CSD015 is installed                                                         CSD015
                                                                                              CSD015
     C                   EVAL      @CSD015 = 'N'                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*VERIFY'     @Optn                                        CSD015
     C                   PARM      'CSD015'      @Sard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (@RtCd <> *BLANKS) and                                     CSD015
     C                             (@RtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 004                                                CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
     C                   EVAL      @CSD015 = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access SAR details to see if CCF001 is switched on.                                 CSD015
                                                                                              CSD015
     C                   EVAL      @CCF001 = 'N'                                              CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*VERIFY'     @Optn                                        CSD015
     C                   PARM      'CCF001'      @SARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> *Blanks  and                                      CSD015
     C                             @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CCF001'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 005                                                CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
     C                   EVAL      @CCF001 = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      **                                                                                      CSC022
      ** Access SAR details to see if CSC022 is switched on                                   CSC022
      **                                                                                      CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *Blanks       PRtCd                                        CSC022
     C                   Parm      '*VERIFY'     POptn                                        CSC022
     C                   Parm      'CSC022'      PSard                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      ** Initialize CSC022 and Skip Commit Flags                                              CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpComtRolbk = 'N'                                        CSC022
      **                                                                                      CSC022
     C                   If        PRtCd = *BLANKS                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
      **                                                                                      CSC022
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                      CSC022
      **                                                                                      CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
      ** Move committed jobs to arrary for checking                                           CSC022
     C                   MoveA     WDSJobs       WJobs                                        CSC022
      ** Verify if job running exists in array                                                CSC022
     C                   Eval      WArrPtr = %LookUp(PSJobName:WJobs)                         CSC022
     C                   If        WArrPtr > 0                                                CSC022
     C                   Eval      WSkpComtRolbk = 'Y'                                        CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
     C                   Else                                                                 CSC022
      ** Execute *PSSR if CSC022 is not found or Database error                               CSC022
     C                   If        PRtCd <> '*NRF'                                            CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBPgm  = 'FTOPAYUPC'                                       CSC022
     C                   Eval      DBKey  = 'CSC022'                                          CSC022
     C                   Eval      DBase  = 900                                               CSC022
     C                   Out       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
     C/COPY WNCPYSRC,FTH00196
 
      * Retrieve Base Currency Details
     C                   Move      BJCYCD        @K101
     C                   CALLB     'AOCURRR0'
     C                   Parm      '*DBERR '     @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    @K101             3
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   Eval      @BCDP = A6NBDP
 
      * Get RUNDAT to access Multi Branch Indicator
     C     *DTAARA       Define                  RUNDAT
     C                   In        RUNDAT
     C                   Unlock    RUNDAT
 
     C                   Eval      @MBIN = WMBIN
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FTOPAYU013
     C                   MOVEL     'N'           ULX608            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX608'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *Blanks and                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '037'         DBASE                                        CER001
     C                   MOVEL     'ULX608'      DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   END                                                                  CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *Blanks                                            CER001
     C                   MOVEL     'Y'           ULX608                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX043 - New IBLC 2002 as feature                                                    CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX043            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *Blanks and                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '038'         DBASE                                        CER001
     C                   MOVEL     'ULX043'      DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   END                                                                  CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *Blanks                                            CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ULX608        IFEQ      'Y'                                                        CER001
     C     ULX043        ANDEQ     'Y'                                                        CER001
     C                   OPEN      FTVOPLX1L0                                                 CER001
     C                   OPEN      FTVEOPX1PD                                                 CER001
     C                   ENDIF                                                                CER001
 
     C                   ENDSR
     C****************************************************************
      /EJECT
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Finastra International Limited 2001
