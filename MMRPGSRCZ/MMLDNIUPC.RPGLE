     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits database update controller')   *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMLDNIUPC - LOANS/DEPOSITS DATABASE UPDATE CONTROLLER        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. AR1037730          Date 15Oct12               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 245219             Date 09Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244036             Date 22Sep06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240388             Date 09Sep06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 CMM105             Date 22Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209905             Date 25Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 201589             Date 03Jan02               *
      *                 188164             Date 25Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 175784             Date 01Mar00               *
      *                 CAP051             DATE 09Nov99               *
      *                 CDL007             DATE 05Oct99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 09Mar99               *
      *                 154477             Date 29Jan99               *
      *                 CAP003             Date 05May98               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  AR1037730 - Trigger error due to object lock                 *
      *              (Child:AR1037731)                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245219 - DLDLDCQD should be updated when MMDELDPP is updated *
      *           as this is the stage java would update it.          *
      *  244036 - Missing deals in extension file DLDLDCQD (done from *
      *           Java layer).                                        *
      *  240388 - Initialize WDteNumP so as not to cause dberr.       *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:MMLDNIU005,MMLDNIU011            *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Autumatic Rollover of Fixed Term Loan/Deposit       *
      *           (Recompile)                                         *
      *  222727 - Release 5.0 errors (If CDL006 is on, records on     *
      *           MMVLDNIPD are not removed once processed)           *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMVLDNIPD*
      *  209905 - Fiduciary API Enhancement                           *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  201589 - Change to check a new locking dataarea MMLDNILCK    *
      *           to determine whether this DBU is already active.    *
      *  188164 - Prevent update or delete on file MMVLDNIPD without  *
      *           prior input operation.                              *
      *  175784 - Batch update functions can fail repeatedly if one   *
      *           error occurs                                        *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMVLDNIPD              *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *           Recompiled due to changes in MMVLDNIPD              *
      *  CDL006 - Fiduciary Dealing                                   *
      *  CAP006 - Check for deal being updated by another workstation *
      *         - Send prompt to DTAQ to restart update process after *
      *           failure.                                            *
      *  154477 - Recompile for change to MMVLDNIPD.                  *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs. (RECOMPILED)                           *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FMMVLDNIPD UF   E             DISK
     F                                     COMMIT
     FMMVLDNIL1 UF   E           K DISK
     F                                     RENAME(MMVLDNID0:MMVLDNID1)
     FMMVELDNIPDO    E             DISK
     F                                     RENAME(MMVLDNID0:MMVLDNIERR)
     FMMVEFIDTPDO    E             DISK                                                       209905
     F                                     RENAME(MMVFIDTD0:MMVFIDTERR)                       209905
     F                                     PREFIX(ER)                                         209905
     FMMVFIDTL0 UF   E           K DISK    PREFIX(ER)                                         209905
                                                                                              CDL033
      ** Midas DL Valid Exception FRCD Date Schedule                                          CDL033
     FDLFRSCL5  UF A E           K DISK                                                       CDL033
                                                                                              CDL033
      ** Midas DL Valid FRCD Date Schedule                                                    CDL033
     FDLVFRSCL0 UF A E           K Disk                                                       CDL033
                                                                                              CDL033
      ** Midas DL Valid Exception FRCD Date Schedule                                          CDL033
     FDLVEFRSCPDO    E             Disk                                                       CDL033
     F                                     RENAME(DLVFRSCD0:DLVFRSCERR)                       CDL033
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,MMLDNIU010
                                                                                              CER001
     FMMVLDLX1L1UF   E           K DISK    USROPN                                             CER001
     F                                     COMMIT                                             CER001
     FMMVELDX1PDO    E             DISK    USROPN                                             CER001
     F                                     RENAME(MMVLDLXD6:MMVLDLXD6R)                       CER001
                                                                                              CER001
      ** Midas DL Money Market & Loans Deals Extension Details.                               244036
     FDLDEALL5  UF A E           K DISK    INFSR(*PSSR)                                       244036
     F                                     IGNORE(DLDLDBD0)                                   244036
     F                                     IGNORE(DLDLDGD0)                                   244036
     F                                     USROPN                                          AR1037730
 
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
 
      **------------------------------------------------------------------------CAP006--------------
      ** The following /COPY line includes the definitions for fields           CAP006
      ** used in checking whether there are messages on the data queue.         CAP006
     D/COPY ZACPYSRC,DTAQCHKDCL                                                 CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in LDNI API update')
 
      *****************************************************************
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID LOAN & DEPOSIT
     D MMVLDN        E DS                  EXTNAME(MMVLDNIPD)
                                                                                              CDL018
     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                  CDL018
      ** File - Payment Further Settlement Instructions                                       CDL018
                                                                                              CDL018
     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                  CDL018
      ** File - Receive Further Settlement Instructions                                       CDL018
 
     D MMLDNIUPC       DS             1    DTAARA(MMLDNIUPC)
                                                                                              CDL006
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL006
      ** External data structure for SAR details                                              CDL006
                                                                                              CDL006
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CDL006
      ** First DS for access programs, short date structure                                   CDL006
 
     D Object          S             10A   INZ('MMLDNIUPC')
     D LockObj         S             10A   INZ('MMLDNILCK')                                   201589
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
 
      ** Work fields for 209905                                                               209905
     D CDL006          S              1A   IMPORT                                             209905
     D PDealNo         S              6P 0                                                    209905
     D PLinkDlno       S              6P 0                                                    209905
     D PMode           S              1A                                                      209905
     D PProgram        S             10A                                                      209905
     D PRtcd           S              7A                                                      209905
                                                                                              CDL033
      ** Switchable Feature                                                                   CDL033
     D CDL033          S              1                                                       CDL033
                                                                                              CDL033
      ** Key for accessing DLVFRSCL0 file                                                     CDL033
     D k_DLVFRSC       S                   Like(IKFRNT)                                       CDL033
                                                                                              CDL033
     D                 DS                                                                     CDL033
     D WDteChr3                1      3                                                       CDL033
     D*WDteNumP*               1      3P 0                                             CDL033 240388
     D WDteNumP                1      3P 0 INZ(0)                                             240388
     D @@FIND          S              1A                                                      CER001
     D @TYPE           S              1A                                                      CER001
     D @Return         S              6A                                                      CER001
     D ULX600          S              1A                                                      CER001
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMLDNIU011
      *                                                                                       CER001
      ** External data structures for Midas Modules                                           CER001
      *                                                                                       CER001
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CER001
      *                                                                                       CER001
      ** New valid extended Deal File                                                         CER001
      *                                                                                       CER001
     D MMVLDLX6      E DS                  EXTNAME(MMVLDLX1L1)                                CER001
     D MMVLDLX6S     E DS                  EXTNAME(MMVLDLX1L1)                                CER001
     D                                     PREFIX(SS)                                         CER001
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
 
      /COPY WNCPYSRC,MMLDNIU001
 
      ** Set up the name of the server/database updater data queue.             CAP006
     C                   EVAL      DtaQName = 'APLDNIDTQ'                       CAP006
                                                                                CAP006
      **------------------------------------------------------------------------CAP006--------------
      ** The following /COPY line includes a check for whether there            CAP006
      ** are messages on the server/updater data queue, and sends a 'GO'.       CAP006
      ** message to the data queue if there are not.                            CAP006
     D/COPY ZACPYSRC,DTAQCHK                                                    CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006
      *  Initialise Data queue parms
     C                   EVAL      DtqLen = 10
     C                   EVAL      DtqWait = -1
     C                   EVAL      DtqNam = 'APLDNIDTQ'
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
     C     DtqDta        IFEQ      'GO'
      *  Lock allocation data area
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      /COPY WNCPYSRC,MMLDNIU002
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     MMVLDNIPD
 
      ** READ VALID LOANS & DEPOSITS
     C                   READ      MMVLDNID0                              99    *
     C     *IN99         DOWEQ     '0'
 
      /COPY WNCPYSRC,MMLDNIU003
                                                                                              CDL033
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C     IKFRNT        CHAIN     DLVFRSCL0                                                  CDL033
     C                   ENDIF                                                                CDL033
 
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lowere level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = IKFRNT
     C                   EVAL      ARFOAsocID = IKAFRT
     C                   EVAL      ARRprLocn  = IKREPA
 
      /COPY WNCPYSRC,MMLDNIU004
 
      ** MM DATABASE UPDATE
     C                   CALLB     'MMLDNIUPM'
     C*******************PARM                    @@RTCD            7            175784
     C                   PARM      *BLANKS       @@RTCD            7            175784
     C                   PARM                    MMVLDN
     C                   PARM                    #FPAYF                                       CDL018
     C                   PARM                    #FRECF                                       CDL018
     C                   PARM      *BLANKS       PBFRCD          100                          CDL033
     C                   PARM      *BLANKS       PAFRCD          100                          CDL033
 
      /COPY WNCPYSRC,MMLDNIU005
 
      ** DL DATABASE UPDATE IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C                   ROLBK
     C                   ELSE
                                                                                              245219
      ** Add record to DLDLDCQD once deal is on MMDELDPP as this is what java does            245219
     C                   IF        IKCHTP = *blanks                                           245219
     C                   EXSR      WriteDLDLDC                                                245219
     C                   END                                                                  245219
                                                                                              245219
     C     @@RTCD        IFNE      '*RECUPD'                                    CAP006
     C     IKCHTP        IFEQ      'I'
     C     IKCHTP        OREQ      'A'
     C     IKCHTP        OREQ      'R'
 
      /COPY WNCPYSRC,MMLDNIU006
 
     C                   CALLB     'MMLDNIUPD'
     C                   PARM                    @@RTCD            7
     C                   PARM                    MMVLDN
     C/COPY WNCPYSRC,MMLDNIUC02
                                                                                              245219
      * DLDLDCQD records needs to be written when MMDELDPP record is written, not DEALSDC     245219
      * This is when IKCHTP is blank.  Authorisation needed must be YES for                   245219
      * midasplus so IKCHTP will always be blank when writing to MMDELDPP.                    245219
      **********                                                                       244036 245219
      ***Add*record within Deals Master Extension File (done from Java layer).         244036 245219
     C**********         IF        IKCHTP = 'I'                                        244036 245219
     C**********         EXSR      WriteDLDLDC                                         244036 245219
     C**********         END                                                           244036 245219
      **********                                                                       244036 245219
     C                   END
     C                   END                                                    CAP006
     C                   END
 
      /COPY WNCPYSRC,MMLDNIU007
      *                                                                                       CER001
      ** ULX600 - API Luxembourg - Function MMLDNI                                            CER001
      *                                                                                       CER001
     C                   IF        ULX600 = 'Y'                                               CER001
                                                                                              CER001
     C                   IF        @@RTCD = *Blanks                                           CER001
      *                                                                                       CER001
      ** When no error in master files update, update extension file                          CER001
      ** For MM, no physical delete on extension file, it is done                             CER001
      ** during COB when system 'purge' MM master files                                       CER001
      *                                                                                       CER001
      ** Retrieve Extended valid record                                                       CER001
      *                                                                                       CER001
     C     IKFRNT        CHAIN     MMVLDLX1L1                         89                      CER001
      *                                                                                       CER001
     C                   IF        IKLACT = 'I' or                                            CER001
     C                             IKLACT = 'A'                                               CER001
      *                                                                                       CER001
      **  Do not update extended file if the action code is amend                             CER001
      **  and action is done via Meridian                                                     CER001
      *                                                                                       CER001
     C                   IF        IKLACT = 'A' and                                           CER001
     C                             @TYPE = '0'                                                CER001
     C                   ELSE                                                                 CER001
     C                   CALLB     'MMLDNI2UP'                                                CER001
     C                   PARM                    IKCHTP                                       CER001
     C                   PARM      *BLANK        @@RTCD                                       CER001
     C                   PARM      *BLANK        @@FIND                                       CER001
     C                   PARM                    MMVLDLX6                                     CER001
     C                   PARM      *BLANK        MMVLDLX6S                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Put here other extension....                                                         CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @@RTCD        IFEQ      *BLANK                                                     CER001
     C                   DELETE    MMVLDLXD6                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
                                                                                              222727
      * If no errors so far and if CDL006 is installed                                        222727
      *    DO FIDUCIARY TAKINGS UPDATES                                                       222727
                                                                                              222727
     C     @@RTCD        IFNE      '*ERROR '                                                  222727
     C     @@RTCD        ANDNE     '*RECUPD'                                                  222727
                                                                                              222727
     C                   IF        CDL006 = 'Y' AND IKLACT = 'I' OR                           222727
     C                             CDL006 = 'Y' AND IKLACT = 'D'                              222727
     C                   IF        IKTYPE = 'FL' OR IKTYPE = 'DP' OR                          222727
     C                             IKTYPE = 'LP'                                              222727
                                                                                              222727
     C                   MOVE      IKDN38        PDealNo                                      222727
                                                                                              222727
     C                   CALLB     'MMFIDTUPF'                                                222727
     C                   PARM      'MMLDNIUPC'   PProgram                                     222727
     C                   PARM      IKLACT        PMode                                        222727
     C                   PARM                    PDealNo                                      222727
     C                   PARM                    PLinkDlno                                    222727
     C                   PARM                    ARFOTRANID                                   222727
     C                   PARM                    @@RTCD                                       222727
                                                                                              222727
     C                   ENDIF                                                                222727
     C                   ENDIF                                                                222727
     C                   ENDIF                                                                222727
                                                                                              CDL033
     C     @@RTCD        IFNE      '*ERROR '                                                  CDL033
     C     @@RTCD        ANDNE     '*RECUPD'                                                  CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
                                                                                              CDL033
      ** Delete all R/P non-processed records before writing/updating                         CDL033
     C                   Z-ADD     IKDN38        KHHDLNO                                      CDL033
     C     KFRSCL5       SETLL     DLFRSCL5                                                   CDL033
     C     KFRSCL5       READE     DLFRSCD0                               89                  CDL033
     C     *IN89         DOWEQ     *OFF                                                       CDL033
     C                   DELETE    DLFRSCD0                                                   CDL033
     C     KFRSCL5       READE     DLFRSCD0                               89                  CDL033
     C                   ENDDO                                                                CDL033
                                                                                              CDL033
      ** Ready to write/update each date to file                                              CDL033
     C                   Z-ADD     IKDN38        HHDLNO                                       CDL033
     C                   MOVE      *BLANK        HHDTPR                                       CDL033
     C                   MOVE      'R'           HHRCIP                                       CDL033
     C                   Z-ADD     1             WCtr              5 0                        CDL033
     C     WCtr          DOWLT     492                                                        CDL033
     C     3             SUBST     XRDAT164:WCtr WDteChr3                                     CDL033
     C*****WDteNumP      IFLE      *ZERO                                               CDL033 245219
     C     WDteChr3      IFEQ      *BLANK                                                     245219
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   Z-ADD     WDteNumP      HHPRDT                                       CDL033
     C     1             SUBST     XRCOH164:WCtr HHCOHO                                       CDL033
     C                   WRITE     DLFRSCD0                                                   CDL033
     C                   ADD       3             WCtr                                         CDL033
     C                   ENDDO                                                                CDL033
                                                                                              CDL033
     C                   MOVE      'P'           HHRCIP                                       CDL033
     C                   Z-ADD     1             WCtr                                         CDL033
     C     WCtr          DOWLT     492                                                        CDL033
     C     3             SUBST     XPDAT164:WCtr WDteChr3                                     CDL033
     C*****WDteNumP      IFLE      *ZERO                                               CDL033 245219
     C     WDteChr3      IFEQ      *BLANK                                                     245219
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   Z-ADD     WDteNumP      HHPRDT                                       CDL033
     C     1             SUBST     XPCOH164:WCtr HHCOHO                                       CDL033
     C                   WRITE     DLFRSCD0                                                   CDL033
     C                   ADD       3             WCtr                                         CDL033
     C                   ENDDO                                                                CDL033
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
 
      * COMIT UPDATES IF NO ERROR
     C                   SETOFF                                         66      188164
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
     C     @@RTCD        ORNE      *BLANK                                                     222727
     C                   ROLBK
     C                   ELSE
      *******************                                                              209905 222727
      ***When*CDL006*enhancement*is installed                                          209905 222727
      *******************                                                              209905 222727
     C*******************IF        CDL006 = 'Y' AND IKLACT = 'I' OR                    209905 222727
     C*******************          CDL006 = 'Y' AND IKLACT = 'D'                       209905 222727
     C*******************IF        IKTYPE = 'FL' OR IKTYPE = 'DP' OR                   209905 222727
     C*******************          IKTYPE = 'LP'                                       209905 222727
      *******************                                                              209905 222727
     C*******************MOVE      IKDN38        PDealNo                               209905 222727
      *******************                                                              209905 222727
     C*******************CALLB     'MMFIDTUPF'                                         209905 222727
     C*******************PARM      'MMLDNIUPC'   PProgram                              209905 222727
     C*******************PARM      IKLACT        PMode                                 209905 222727
     C*******************PARM                    PDealNo                               209905 222727
     C*******************PARM                    PLinkDlno                             209905 222727
     C*******************PARM                    ARFOTRANID                            209905 222727
     C*******************PARM                    @@RTCD                                209905 222727
      *******************                                                              209905 222727
     C*******************IF        @@RTCD <> *Blanks                                   209905 222727
     C*******************ROLBK                                                         209905 222727
     C*******************ELSE                                                          209905 222727
     C**********         DELETE    MMVLDNID0                                    188164
     C                   DELETE    MMVLDNID0                            66      188164
     C*******************ENDIF                                                         209905 222727
      *******************                                                              209905 222727
     C*******************ENDIF                                                         209905 222727
     C*******************ENDIF                                                         209905 222727
      *******************                                                              209905 222727
      *                                                                                       CDL033
      ** Delete all records from DLVFRSCL0 if CDL033 is installed                             CDL033
      *                                                                                       CDL033
     C                   IF        CDL033 = 'Y'                                               CDL033
     C                   EVAL      k_DLVFRSC = IKFRNT                                         CDL033
     C     k_DLVFRSC     SETLL     DLVFRSCD0                                                  CDL033
     C     k_DLVFRSC     READE     DLVFRSCD0                                                  CDL033
     C                   DOW       Not %Eof(DLVFRSCL0)                                        CDL033
     C                   DELETE    DLVFRSCD0                                                  CDL033
     C     k_DLVFRSC     READE     DLVFRSCD0                                                  CDL033
     C                   ENDDO                                                                CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   COMMIT
     C/COPY WNCPYSRC,MMLDNIUC01
     C                   END
 
      /COPY WNCPYSRC,MMLDNIU008
      *                                                                                       CER001
      ** If an error has occurred, reaccess record in error and remove                        CER001
      ** from the file and write details of record to error valid file                        CER001
      *                                                                                       CER001
     C     ULX600        IFEQ      'Y'                                                        CER001
      *                                                                                       CER001
     C     @@RTCD        IFEQ      '*ERROR '                                                  CER001
     C     @@RTCD        OREQ      '*RECUPD'                                                  CER001
      *                                                                                       CER001
     C     IKFRNT        CHAIN     MMVLDLX1L1                         89                      CER001
      *                                                                                       CER001
     C                   WRITE     MMVLDLXD6R                                                 CER001
     C                   DELETE    MMVLDLXD6                                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
     C     *IN66         OREQ      '1'                                          188164
     C                   EVAL      @Dealno = IKDN38
     C                   EVAL      @Timestamp = IKTMESTMP
     C     @KMMDL1       CHAIN     MMVLDNIL1                          89
     ** Write details of record to error file (same format as MMVLDNIPD)
     C                   WRITE     MMVLDNIERR
     C                   DELETE    MMVLDNID1
                                                                                              209905
     C     IKFRNT        SETLL     MMVFIDTL0                                                  209905
     C     IKFRNT        READE     MMVFIDTL0                              89                  209905
     C                   DOW       *IN89 = *OFF                                               209905
     C                   WRITE     MMVFIDTERR                                                 209905
     C                   DELETE    MMVFIDTD0                                                  209905
     C     IKFRNT        READE     MMVFIDTL0                              89                  209905
     C                   ENDDO                                                                209905
                                                                                              209905
      ** Move all records from DLVFRSCL0 to DLVEFRSCPD if CDL033 is 'Y'                       CDL033
     C                   IF        CDL033 = 'Y'                                               CDL033
     C     IKFRNT        SETLL     DLVFRSCD0                                                  CDL033
     C     IKFRNT        READE     DLVFRSCD0                                                  CDL033
     C                   DOW       Not %Eof(DLVFRSCL0)                                        CDL033
     C                   WRITE     DLVFRSCERR                                                 CDL033
     C                   DELETE    DLVFRSCD0                                                  CDL033
     C     IKFRNT        READE     DLVFRSCD0                                                  CDL033
     C                   ENDDO                                                                CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** READ VALID LOANS & DEPOSITS
     C                   READ      MMVLDNID0                              99    *
     C                   END
     ** Unlock allocation data area
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Return
     C                   END
      ** End loop for data queue prompt
     C                   END
 
      /COPY WNCPYSRC,MMLDNIU009
 
      * EXIT FROM PROGRAM
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMLDNIU012
 
      *****************************************************************                       244036
      /EJECT                                                                                  244036
      *****************************************************************                       244036
      *                                                               *                       244036
      * WriteDLDLDC - WRITE Money Market & Loans Deals Extension      *                       244036
      *               record (done from Java layer).                  *                       244036
      *                                                               *                       244036
      *****************************************************************                       244036
     C     WriteDLDLDC   BEGSR                                                                244036
      *                                                                                       244036
      ** When opening new deals within DEALSDC, write a corresponding                         244036
      ** record in the Deals details extension file DLDLDCQD.                                 244036
      *                                                                                       244036
     C     @KeyDealL5    KLIST                                                                244036
     C                   KFLD                    F1DLNO                                       244036
      *                                                                                       244036
     C                   MOVE      IKDN38        F1DLNO                                       244036
     C                   OPEN      DLDEALL5                                                AR1037730
     C     @KeyDealL5    CHAIN     DLDLDCD0                           82                      244036
      *                                                                                       244036
     C     *IN82         IFEQ      *ON                                                        244036
     C                   EVAL      F1BRCA = IKBRCA                                            244036
     C                   WRITE     DLDLDCD0                                                   244036
                                                                                              244036
     C                   ENDIF                                                                244036
     C                   CLOSE     DLDEALL5                                                AR1037730
                                                                                              244036
     C                   ENDSR                                                                244036
      *****************************************************************                       244036
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
      *  Define key list for MMVLDNIL1
     C     @KMMDL1       KLIST
     C                   KFLD                    @Dealno           6 0
     C                   KFLD                    @Timestamp
                                                                                              CDL033
     C     *LIKE         DEFINE    HHDLNO        KHHDLNO                                      CDL033
     C     *LIKE         DEFINE    HHRCIP        KHHRCIP                                      CDL033
     C     KFRSCL5       KLIST                                                                CDL033
     C                   KFLD                    KHHDLNO                                      CDL033
 
      *  Check if an existing DBU_LDNI job is active in the subsystem.                        201589
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
      ** Determine whether program is running interactively or in batch                       CER001
      **  ( 0 = batch   1 = interactive)                                                      CER001
      *                                                                                       CER001
     C                   CALLB     'ZARTVJOBA'                                                CER001
     C                   PARM                    @Return                                      CER001
     C                   PARM                    @TYPE                                        CER001
      *                                                                                       CER001
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
 
      ** Check if Dealing Fiduciary is switched ON                                            CDL006
                                                                                              CDL006
     C                   CALLB     'MMFIDINIT'                                                CDL006
     C                   PARM      *BLANKS       WRTCD             7                          CDL006
 
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
                                                                                              CDL033
      ** Check if CDL033 feature is installed                                                 CDL033
                                                                                              CDL033
     C                   CALLB     'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       PRTCD             7                          CDL033
     C                   PARM      '*VERIFY'     POPTN             7                          CDL033
     C                   PARM      'CDL033'      PSARD             6                          CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
                                                                                              CDL033
     C                   EVAL      CDL033 = 'N'                                               CDL033
     C                   IF        PRTCD = *Blanks                                            CDL033
     C                   EVAL      CDL033 = 'Y'                                               CDL033
     C                   ENDIF                                                                CDL033
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMLDNIU013
      *                                                                                       CER001
      ** Access Module Details to verify if Lux Return feature is                             CER001
      ** active                                                                               CER001
      *                                                                                       CER001
     C                   CALL      'AOMMODR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*FIRST '     @OPTN                                        CER001
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER001
      *                                                                                       CER001
      ** ULX600 - API Luxembourg - Function MMLDNI                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX600                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX600'      @SARD                                        CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C     BGLRIN        ANDEQ     'Y'                                                        CER001
     C                   MOVEL     'Y'           ULX600                                       CER001
     C                   OPEN      MMVLDLX1L1                                                 CER001
     C                   OPEN      MMVELDX1PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
 
     C                   ENDSR
     C****************************************************************
      /EJECT
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
