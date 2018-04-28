     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM REPO database update controller')             *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMREPOUPC - REPOS DATABASE UPDATE CONTROLLER                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249480             Date 31Jul07               *
      *                 249095             Date 19Jul07               *
      *                 247695             Date 09May07               *
      *                 247716             Date 11May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 22Aug05               *
      *                 233352             Date 06May05               *
      *                 CDL038             Date 10May05               *
      *                 CMM105             Date 22Jun04               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249480 - Same fix as 249095.                                 *
      *  249095 - Valid depot movement not deleted.                   *
      *  247695 - Incomplete parameter list passed to MMLDNIUPM.      *
      *  247716 - Problem in REPO API. Add missing fields.            *
      *           Recompile on MMVRPDMPD.                             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087 - Depot Movement API - Java Wrapper in Midasplus.     *
      *           Change due to additional parameter added to         *
      *           call MMRPDLUPD.                                     *
      *  233352 - Problem in REPO API (Recompile)                     *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:MMREPOU002,MMREPOU007            *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************
     FMMVRPLNPD UF   E             DISK
     F                                     COMMIT
     FMMVRPLNL1 UF   E           K DISK
     F                                     RENAME(MMVRPLND0:MMVRPLND1)
     FMMVRPDML0 UF   E           K DISK
     F                                     RENAME(MMVRPDMD0:MMVRPDMDX)
     FMMVELDNIPDO    E             DISK
     F                                     RENAME(MMVLDNID0:MMVLDNIERR)
 
      * Hook to enable non-core files to be included
     F/COPY WNCPYSRC,MMREPOU001
 
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
 
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in REPO API update')
 
      *****************************************************************
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID LOAN & DEPOSIT
     D MMVREPO       E DS                  EXTNAME(MMVRPLNPD)
 
     D MMREPOUPC       DS             1    DTAARA(MMREPOUPC)
 
     D**  Data structure of Depot Movement File                                               CAP087
     D DPTXX         E DS                  EXTNAME(DPTMVDL1) PREFIX(D)                        CAP087
                                                                                              CAP087
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External data structure for SAR details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short date structure
 
                                                                                              247695
     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                  247695
      ** File - Payment Further Settlement Instructions                                       247695
                                                                                              247695
     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                  247695
      ** File - Receive Further Settlement Instructions                                       247695
                                                                                              247695
     D Object          S             10A   INZ('MMREPOUPC')
     D LockObj         S             10A   INZ('MMREPOLCK')
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
     D @Timestamp      S             26Z
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
     D ##CXX           S             89A
     D ##CXXX          S            112A
 
     D ##CM            S              1    DIM(58) CTDATA PERRCD(58)
     D ##CF            S              1    DIM(21) CTDATA PERRCD(21)
     D ##OX1           S              1    DIM(78) CTDATA PERRCD(78)
     D ##OX2           S              1    DIM(78) CTDATA PERRCD(78)
     D ##OX3           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX4           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX5           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX6           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX7           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX8           S              1    DIM(71) CTDATA PERRCD(71)
     D ##OX9           S              1    DIM(71) CTDATA PERRCD(71)
     D ##C1            S              1    DIM(77) CTDATA PERRCD(77)
     D ##C2            S              1    DIM(77) CTDATA PERRCD(77)
     D ##CN1           S              1    DIM(81) CTDATA PERRCD(81)
     D ##CT1           S              1    DIM(81) CTDATA PERRCD(81)
     D ##CN2           S              1    DIM(78) CTDATA PERRCD(78)
     D ##CT2           S              1    DIM(78) CTDATA PERRCD(78)
     D ##CX            S              1    DIM(89) CTDATA PERRCD(89)
                                                                                              CAP087
      ** Flag to indicate caller of MMRPDLUPD                                                 CAP087
      ** 'Y' - called from Securities module                                                  CAP087
      ** 'N' - called from Money Markey module                                                CAP087
     D DepotPos        S              1A                                                      CAP087
                                                                                              CAP087
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
     D/COPY WNCPYSRC,MMREPOU002
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APREPODTQ'
 
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
 
     C/COPY WNCPYSRC,MMREPOU003
 
      *  Initialise Data queue parms
     C                   EVAL      DtqLen = 10
     C                   EVAL      DtqWait = -1
     C                   EVAL      DtqNam = 'APREPODTQ'
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
 
     C/COPY WNCPYSRC,MMREPOU004
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     MMVRPLNPD
 
      ** READ VALID LOANS & DEPOSITS
     C                   READ      MMVRPLND0                              99
 
     C     *IN99         DOWEQ     '0'
 
     C/COPY WNCPYSRC,MMREPOU005
 
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lowere level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = IKFRNT
     C                   EVAL      ARFOAsocID = IKAFRT
     C                   EVAL      ARRprLocn  = IKREPA
 
     C/COPY WNCPYSRC,MMREPOU006
 
      ** MM DATABASE UPDATE
     C                   CALLB     'MMLDNIUPM'
     C                   PARM      *BLANKS       @@RTCD            7
     C                   PARM                    MMVREPO
     C                   PARM                    #FPAYF                                       247695
     C                   PARM                    #FRECF                                       247695
      ** FRCD Issued Extension details before update                                          247695
     C                   PARM      *BLANKS       PBFRCD          100                          247695
      ** FRCD Issued Extension details after update                                           247695
     C                   PARM      *BLANKS       PAFRCD          100                          247695
 
     C/COPY WNCPYSRC,MMREPOU007
 
      ** DL DATABASE UPDATE IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
 
     C                   ROLBK
 
     C                   ELSE
 
     C     @@RTCD        IFNE      '*RECUPD'
 
     C/COPY WNCPYSRC,MMREPOU008
 
     C                   CALLB     'MMLDNIUPD'
     C                   PARM      *BLANKS       @@RTCD            7
     C                   PARM                    MMVREPO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C/COPY WNCPYSRC,MMREPOU009
 
      ** DL DATABASE UPDATE IF NO ERROR
 
     C     @@RTCD        IFEQ      '*ERROR '
 
     C                   ROLBK
 
     C                   ELSE
 
     C     @@RTCD        IFNE      '*RECUPD'
 
      ** REPO Deliveru details update
 
      ** Create temporary DEPOT Movements for REPOS file
 
     C                   Z-ADD     58            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##CM
     C                   PARM                    MESLEN
 
      ** Clear temporary depot movements file
 
     C                   Z-ADD     21            MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##CF
     C                   PARM                    MESLEN
 
     C                   MOVEA     ##CX          ##CXX
     C     ##CXX         CAT       IKAFRT        ##CXXX
     C                   MOVE      '''))'        ##CXXX
 
      ** Create temporary depot movements file from the valid file
 
     C                   Z-ADD     112           MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##CXXX
     C                   PARM                    MESLEN
 
      ** Create Temporary Depot Movements for Repos Extension File 1
 
     C                   Z-ADD     77            MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##C1
     C                   PARM                    MESLEN
 
      ** Create Temporary Depot Movements for Repos Extension File 2
 
     C                   Z-ADD     77            MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##C2
     C                   PARM                    MESLEN
 
      ** Create temporary files for Certificates processing
 
     C                   Z-ADD     81            MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##CN1
     C                   PARM                    MESLEN
 
     C                   Z-ADD     81            MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##CT1
     C                   PARM                    MESLEN
 
      ** Override SECRTNTPPD to QTEMP/SECRTNTPPD
 
     C                   Z-ADD     78            MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
 
      ** Override SECRTTTPPD to QTEMP/SECRTTTPPD
 
     C                   Z-ADD     78            MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##OX2
     C                   PARM                    MESLEN
 
      ** Override DPTMVDL1 to DPTMVDL1 SHARE(*NO)
 
     C                   Z-ADD     68            MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##OX3
     C                   PARM                    MESLEN
 
      ** Override DPTMVDY1 to DPTMVDY1 SHARE(*NO)
 
     C                   Z-ADD     68            MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##OX4
     C                   PARM                    MESLEN
 
      ** Override DPTMVDY2 to DPTMVDY2 SHARE(*NO)
 
     C                   Z-ADD     68            MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##OX5
     C                   PARM                    MESLEN
 
      ** Override SEDMRPX1 to SEDMRPX1 SHARE(*NO)
 
     C                   Z-ADD     68            MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##OX6
     C                   PARM                    MESLEN
 
      ** Override SEDMRPX2 to SEDMRPX2 SHARE(*NO)
 
     C                   Z-ADD     68            MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##OX7
     C                   PARM                    MESLEN
 
      ** Override SECRTNL1 to SECRTNL1 SHARE(*NO)
 
     C                   Z-ADD     71            MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##OX8
     C                   PARM                    MESLEN
 
      ** Override SECRTTL1 to SECRTTL1 SHARE(*NO)
 
     C                   Z-ADD     71            MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##OX9
     C                   PARM                    MESLEN
 
     C                   CALLB     'MMRPDLUPD'
     C                   PARM      *BLANKS       @@RTCD
     C                   PARM                    MMVREPO
     C                   PARM                    DPTXX                                        CAP087
     C                   PARM      'N'           DepotPos                                     CAP087
 
     C                   ENDIF
 
     C                   ENDIF
 
     C/COPY WNCPYSRC,MMREPOU010
 
      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
 
     C                   ROLBK
 
     C                   ELSE
 
     C                   DELETE    MMVRPLND0
 
     C                   EXSR      DltValDepot
 
     C                   COMMIT
      *
      ** Call MMCREPOCMT to Commit changes for all activation groups.
      ** Otherwise record lock remains on MEMOS file and further update
      ** will cause database error.
      *
     C                   CALL      'MMCREPOCMT'
 
     C                   ENDIF
 
     C/COPY WNCPYSRC,MMREPOU011
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
 
     C                   EVAL      @Dealno = IKDN38
     C                   EVAL      @Timestamp = IKTMESTMP
 
     C     @KMMDL1       CHAIN     MMVRPLNL1                          89
 
     ** Write details of record to error file (same format as MMVRPLNPD)
     C                   WRITE     MMVLDNIERR
     C                   DELETE    MMVRPLND1
 
     C                   EXSR      DltValDepot
 
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** READ VALID LOANS & DEPOSITS
     C                   READ      MMVRPLND0                              99
 
     C                   ENDDO
     ** Unlock allocation data area
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Return
 
     C                   ENDIF
      ** End loop for data queue prompt
     C                   ENDDO
 
     C/COPY WNCPYSRC,MMREPOU012
 
      * EXIT FROM PROGRAM
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
     C/COPY WNCPYSRC,MMREPOU013
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DltValDepot - Delete valid REPO depot movement record set.    *
      *                                                               *
      *****************************************************************
     C     DltValDepot   BEGSR
 
      ** Remove record from REPO depot movements valid file
 
      ** Position file cursor to start of file
 
     C******LOVAL        SETLL     MMVRPDML0                                                  249095
     C     IKAFRT        SETLL     MMVRPDML0                                                  249095
 
     C     IKAFRT        READE     MMVRPDML0                              99
 
     C     *IN99         DOWEQ     '0'
 
     C                   DELETE    MMVRPDMDX
 
     C     IKAFRT        READE     MMVRPDML0                              99
 
     C                   ENDDO
 
     C                   ENDSR
 
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
 
      *  Define key list for MMVRPLNL1
     C     @KMMDL1       KLIST
     C                   KFLD                    @Dealno           6 0
     C                   KFLD                    @Timestamp
 
      *  Check if an existing DBU_REPO job is active in the subsystem.
 
     C                   CALL      'SCC0520'
     C                   PARM                    LockObj
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Endjob
     C                   PARM                    Return2
 
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
 
      ** Check if Dealing Fiduciary is switched ON
 
     C                   CALLB     'MMFIDINIT'
     C                   PARM      *BLANKS       WRTCD             7
 
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
 
      *  Hook to enable non-core initial processing to be included
     C/COPY WNCPYSRC,MMREPOU014
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
 
      ****************************************************************
      /EJECT
      ****************************************************************
 
** CPY@
(c) Misys International Banking Systems Ltd. 2001
** ##CM
CPYF FROMFILE(DPTMVD) TOFILE(QTEMP/SEDMRPXX) CRTFILE(*YES)
** ##CF
CLRPFM QTEMP/SEDMRPXX
** ##OX1
OVRDBF FILE(SECRTNTPPD) TOFILE(QTEMP/SECRTNTPPD) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX2
OVRDBF FILE(SECRTTTPPD) TOFILE(QTEMP/SECRTTTPPD) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX3
OVRDBF FILE(DPTMVDL1) TOFILE(DPTMVDL1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX4
OVRDBF FILE(DPTMVDY1) TOFILE(DPTMVDY1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX5
OVRDBF FILE(DPTMVDY2) TOFILE(DPTMVDY2) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX6
OVRDBF FILE(SEDMRPX1) TOFILE(SEDMRPX1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX7
OVRDBF FILE(SEDMRPX2) TOFILE(SEDMRPX2) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX8
OVRDBF FILE(SECRTNL1) TOFILE(SECRTNL1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX9
OVRDBF FILE(SECRTTL1) TOFILE(SECRTTL1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##C1
CPYF FROMFILE(DPTMVDY1) TOFILE(QTEMP/SEDMRPX1) CRTFILE(*YES) MBROPT(*REPLACE)
** ##C2
CPYF FROMFILE(DPTMVDY2) TOFILE(QTEMP/SEDMRPX2) CRTFILE(*YES) MBROPT(*REPLACE)
** ##CN1
CPYF FROMFILE(SECRTNTPPD) TOFILE(QTEMP/SECRTNTPPD) CRTFILE(*YES) MBROPT(*REPLACE)
** ##CT1
CPYF FROMFILE(SECRTTTPPD) TOFILE(QTEMP/SECRTTTPPD) CRTFILE(*YES) MBROPT(*REPLACE)
** ##CN2
CPYF FROMFILE(SECRTNPD) TOFILE(QTEMP/SECRTNTPPD) CRTFILE(*NO) MBROPT(*REPLACE)
** ##CT2
CPYF FROMFILE(SECRTTPD) TOFILE(QTEMP/SECRTTTPPD) CRTFILE(*NO) MBROPT(*REPLACE)
** ##CX
CPYF FROMFILE(MMVRPDMPD) TOFILE(QTEMP/SEDMRPXX) MBROPT(*REPLACE) INCREL((*IF DMAFRT *EQ '
