     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Buy-sell back database update controller')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEBYSLUPC - Buy-Sell Back Database Update Controller         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSW210             Date 04May10               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22911           Date 17Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 233708             Date 02Jun05               *
      *                 CGL031             Date 05Jul04               *
      *                 222373             Date 23Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 216338             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  233708 - Addition of fields for CGL031(Recompile)            *
      *  CGL031 - Taxation of Savings Income.                         *
      *  222373 - Parameter Mismatch                                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  216338 - Add missing parameter                               *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************
     FSEVBYSLPD UF   E           K DISK
     F                                     COMMIT
     FSEVBYSLL1 UF   E           K DISK
     F                                     RENAME(SEVBYSLD0:SEVBYSLD1)
     FSEVTRX1L0 UF   E           K DISK
     F                                     COMMIT
     FSEVTRX1L1 UF   E           K DISK
     F                                     RENAME(SEVTRX1PD0:SEVTRX1D1)
     FSEVEBYSLPDO    E             DISK
     F                                     RENAME(SEVBYSLD0:SEVBYSLERR)
     FSEVETRX1PDO    E             DISK
     F                                     RENAME(SEVTRX1PD0:SEVTRX1ERR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SEBYSLU001
 
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
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
     D DBerrUpd        C                   CONST('DB error in BYSL API update')
      *
     D Command         DS
      ** OVRDBF command for QCMDEXC to run
     D                         1     26    INZ('OVRDBF TRADSDY1 SHARE(*NO)')
      *
     D SEVBYSL       E DS                  EXTNAME(SEVBYSLPD)
     D SEVTRDX1      E DS                  EXTNAME(SEVTRX1PD)
     D SEVTRDX1A     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(A_)
     D SEVTRDX1B     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(B_)
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID TRADE EXTENSION 1                     222373
     D SEVTRDX2A     E DS                  EXTNAME(SEVTRX2PD)                                 222373
     D                                     PREFIX(AA_)                                        222373
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID TRADE EXTENSION 1                     222373
     D SEVTRDX2B     E DS                  EXTNAME(SEVTRX2PD)                                 222373
     D                                     PREFIX(AB_)                                        222373
      *
      ** DS for BYSL data area details
     D SEBYSLUPC       DS             1    DTAARA(SEBYSLUPC)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D Object          S             10A   INZ('SEBYSLUPC')
     D LockObj         S             10A   INZ('SEBYSLLCK')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockStateE      S              7A   INZ('*EXCL')
     D LockStateS      S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('*CLS')
     D Dlcobj          S              1A
     D Return          S              7A
     D Return2         S              7A
     D Endjob          S              1A   INZ('Y')
     D WTimestamp      S             26Z
     D WLinkRef        S              6A
                                                                                              222373
      ** Additional entry parameter for Midas Compliance Watch                                222373
     D PMCWL           DS          9999                                                       222373
      *
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
      *
      ** Command length for QCMDEXC
     D CommandLen      S             15P 5 INZ(26)
 
     D WLinkProc       S              1A
                                                                                              CAS006
     D CAS006          S              1                                                       CAS006
     D PMODE           S              3                                                       216338
                                                                                              CGL031
      ** CGL031 Switchable Feature                                                            CGL031
                                                                                              CGL031
     D CGL031          S              1A                                                      CGL031
 
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SEBYSLU002
      *
      *******************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      /COPY WNCPYSRC,SEBYSLU003
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DtaQName = 'APBYSLDTQ'
      *
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
      *
     D/COPY ZACPYSRC,DTAQCHK
      *
      ** Initialise Data queue parms
      *
     C                   EVAL      DtqLen = 10
     C                   EVAL      DtqWait = -1
     C                   EVAL      DtqNam = 'APBYSLDTQ'
     C                   EVAL      DtqLib = '*LIBL'
     C                   EVAL      ObjType = '*DTAARA'
      *
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file
      *
     C     DtqDta        DOWNE     'END'
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam           10
     C                   PARM                    DtqLib           10
     C                   PARM                    DtqLen            5 0
     C                   PARM                    DtqDta           10
     C                   PARM                    DtqWait           5 0
     C     DtqDta        IFEQ      'GO'
      *
      ** Lock allocation data area
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      /COPY WNCPYSRC,SEBYSLU004
 
     C                   EVAL      WLinkProc = 'N'
      *
      ** Position file cursor to start of file to prevent problems on
      ** later calls
      *
     C     *LOVAL        SETLL     SEVBYSLPD
      *
      ** Read Valid SE Buy-Sell Back
      *
     C                   READ      SEVBYSLD0                              99
 
     C     *IN99         DOWEQ     '0'
 
      /COPY WNCPYSRC,SEBYSLU005
      *
      ** Update trade details
      *
     C                   EXSR      SRUpdate
      *
      ** Rollback if there are errors
     C     PRTCD         IFEQ      '*ERROR '
     C     PRTCD         OREQ      '*RECUPD'
     C                   EXSR      SRError
     C                   ELSE
 
      /COPY WNCPYSRC,SEBYSLU006
      *
      ** If no errors, delete from valid file
      *
     C                   EXSR      SRValDelt
      *
      ** Process trade details of link reference.
      *
     C                   IF        WLinkProc <> 'Y'
 
     C     WLinkRef      SETLL     SEVBYSLPD
     C     WLinkRef      READE     SEVBYSLPD                              01
 
     C                   IF        *IN01
     C                   EXSR      SRError
     C                   ELSE
     C                   EVAL      WLinkProc = 'Y'
     C                   ITER
     C                   ENDIF
 
     C                   ENDIF
 
      /COPY WNCPYSRC,SEBYSLU007
      *
      ** Commit all updates.
      *
     C                   IF        WLinkProc = 'Y'
     C                   COMMIT
     C                   ENDIF
      *
     C                   ENDIF
      *
      /COPY WNCPYSRC,SEBYSLU008
      *
      ** Reset file pointer and read another Buy-sell back.
      *
     C     *LOVAL        SETLL     SEVBYSLPD
     C                   READ      SEVBYSLPD                              99
     C                   EVAL      WLinkProc = 'N'
 
     C                   ENDDO
      *
      /COPY WNCPYSRC,SEBYSLU009
      *
      ** Unlock allocation data area
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Return
     C                   ENDIF
      *
      ** End loop for data queue prompt
     C                   ENDDO
 
      /COPY WNCPYSRC,SEBYSLU010
      *
      ** Exit from program
     C                   RETURN
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SEBYSLU011
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update processing subroutine                       *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdate      BEGSR
      *
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      ** will include the key information.
      *
     C                   EVAL      ARFOTranID = FRNT
     C                   EVAL      ARFOAsocID = AFRT
     C                   EVAL      ARRprLocn  = REPA
     C                   EVAL      WLinkRef = LKRF
      *
      ** Get extension file detail (records A & B)
      *
     C                   CLEAR                   SEVTRDX1A
     C                   CLEAR                   SEVTRDX1B
 
     C     CSW003        IFEQ      'Y'
     C                   EVAL      T1WHEN = 'A'
     C                   ELSE
     C                   EVAL      T1WHEN = ' '
     C                   ENDIF
 
     C     KeyTrx1L0     CHAIN     SEVTRX1L0                          98
     C                   IF        NOT(*IN98)
     C                   EVAL      SEVTRDX1A = SEVTRDX1
     C                   ENDIF
 
     C                   EVAL      T1WHEN = 'B'
     C     KeyTrx1L0     CHAIN     SEVTRX1L0                          98
     C                   IF        NOT(*IN98)
     C                   EVAL      SEVTRDX1B = SEVTRDX1
     C                   ENDIF
      *
      ** SE Database update
     C                   CALLB     'SETRADUPD'
     C                   PARM      *BLANK        PRTCD
     C                   PARM                    SEVBYSL
     C                   PARM                    SEVTRDX1A
     C                   PARM                    SEVTRDX1B
     C                   PARM                    S01401
     C                   PARM                    CSW003
     C                   PARM                    CAP051
     C                   PARM                    CAS006                                       CAS006
     C                   PARM                    CGL031                                       CGL031
     C                   PARM      'UPC'         PMODE                                        216338
     C                   PARM                    PMCWL                                        222373
     C                   PARM                    SEVTRDX2A                                    222373
     C                   PARM                    SEVTRDX2B                                    222373
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRError - Error processing subroutine                         *
      *                                                               *
      *****************************************************************
      *
     C     SRError       BEGSR
      *
      ** Rollback any changes
      *
     C                   ROLBK
      *
      ** If an error has occurred, reaccess record in error and remove from
      ** the file to prevent program processing the same record again.
      *
     C                   EVAL      WTradeRef  = TDRF
     C                   EVAL      WTimestamp = TMST
      *
     C     KeyByslL1     CHAIN     SEVBYSLL1                          89
     C                   EXSR      SRError2
      *
      ** Process link reference trade details and delete other leg.
      *
     C     WLinkRef      CHAIN     SEVBYSLL1                          01
     C                   IF        NOT(*IN01)
     C                   EVAL      WTradeRef  = LKRF
     C                   EXSR      SRError2
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRError2 - Error processing subroutine 2                      *
      *                                                               *
      *****************************************************************
      *
     C     SRError2      BEGSR
      *
      ** Write details of record to error file (same format as SEVBYSLPD)
      *
     C                   WRITE     SEVBYSLERR
     C                   DELETE    SEVBYSLD1
      *
     C                   EVAL      WWhen = 'A'
     C     KeyTrx1L1     CHAIN     SEVTRX1L1                          89
      *
      ** Write details of record to error file (same format as SEVTRX1PD)
      *
     C     *IN89         IFEQ      '0'
     C                   WRITE     SEVTRX1ERR
     C                   DELETE    SEVTRX1D1
     C                   ENDIF
      *
     C                   EVAL      WWhen = 'B'
     C     KeyTrx1L1     CHAIN     SEVTRX1L1                          89
      *
      ** Write details of record to error file (same format as SEVTRX1PD)
      *
     C     *IN89         IFEQ      '0'
     C                   WRITE     SEVTRX1ERR
     C                   DELETE    SEVTRX1D1
     C                   ENDIF
      *
      ** Send message to system operator
      *
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValDelt - Valid deletion processing subroutine              *
      *                                                               *
      *****************************************************************
      *
     C     SRValDelt     BEGSR
 
     C                   DELETE    SEVBYSLD0
 
     C     CSW003        IFEQ      'Y'
     C                   EVAL      T1WHEN = 'A'
     C                   ELSE
     C                   EVAL      T1WHEN = ' '
     C                   ENDIF
 
     C     KeyTrx1L0     CHAIN     SEVTRX1L0                          98
     C                   IF        NOT(*IN98)
     C                   DELETE    SEVTRX1PD0
     C                   ENDIF
 
     C                   EVAL      T1WHEN = 'B'
     C     KeyTrx1L0     CHAIN     SEVTRX1L0                          98
     C                   IF        NOT(*IN98)
     C                   DELETE    SEVTRX1PD0
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
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
      *
      ** Define key list for SEVTRX1L0
     C     KeyTrx1L0     KLIST
     C                   KFLD                    FRNT
     C                   KFLD                    T1WHEN
      *
      ** Define key list for SEVBYSLL1
     C     KeyBySlL1     KLIST
     C                   KFLD                    WTradeRef         6
     C                   KFLD                    WTimestamp
      *
      ** Define key list for SEVTRX1L1
     C     KeyTrx1L1     KLIST
     C                   KFLD                    WTradeRef
     C                   KFLD                    WWhen             1
      *
      *  Check if an existing DBU_INTC job is active in the subsystem.
 
     C                   CALL      'SCC0520'
     C                   PARM                    LockObj
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Endjob
     C                   PARM                    Return2
 
      ** Lock allocation data area
      ** The data area is allocated *SHRRD here and *EXCL whilst processing
      ** of the valid file is actually taking place.
      ** The function to submit this updater tries to get a *EXCL lock.
      ** The controller tries to get a *SHRRD lock.
      **
      **                        Submitter             Controller
      **                Lock      Lock     Submitter     Lock     Controller
      **     Status    Status   Successful   Action   Successful    Action
      **     ------    ------   ---------- ---------  ----------  ----------
      **  Not running  None        Yes      Submit       Yes        Prompt
      **                                    updater                 updater
      **  Running not  *SHRRD      No        None        Yes        Prompt
      **   processing                                               updater
      **  Processing   *EXCL       No        None        No         None
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateS
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
      *
      ** Create required QTEMP objects
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde        10
      *
      ** Override SE Extension file (used in *UPD and *RTV modules)
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      *
      ** Access SAR details file to determine if S01401
      ** (MT5XX Message Generation) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'S01401'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01401            1
     C                   ELSE
     C                   MOVEL     'N'           S01401
     C                   END
      *
      ** Access SAR details file to determine if CSW003
      ** (MT5XX - Phase 2 Message Generation) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      '*BLANKS'     PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSW003'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSW003            1
     C                   ELSE
     C                   MOVE      'N'           CSW003
     C                   ENDIF
      *
      ** Access SAR details file to determine if CAP051 is on.
      ** (Automatic Authorisation (SE Trades Part))
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAP051'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP051            1
     C                   ELSE
     C                   MOVEL     'N'           CAP051
     C                   END
                                                                                              CAS006
      ** Check if enhancement CAS006 (Hedge Accounting Phase B) is installed                  CAS006
                                                                                              CAS006
     C                   CALLB     'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRTCD                                        CAS006
     C                   PARM      '*VERIFY'     POPTN                                        CAS006
     C                   PARM      'CAS006'      PSARD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRTCD = *BLANKS                                            CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CGL031
      ** Access Switchable Features File, for Taxation Savings Income CGL031                  CGL031
                                                                                              CGL031
     C                   MOVE      'N'           CGL031                                       CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtcd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSard                                        CGL031
                                                                                              CGL031
     C                   IF        PRtcd = *BLANKS                                            CGL031
     C                   MOVE      'Y'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
      ** Database Error                                                                       CGL031
                                                                                              CGL031
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '                    CGL031
     C                   MOVEL     'CGL031 '     DBKEY                                        CGL031
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL031
     C                   MOVEL     '001'         DBASE                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SEBYSLU012
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      *
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
