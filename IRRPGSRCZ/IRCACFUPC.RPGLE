     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/collars/floors update controller')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCACFUPC - Caps/Collars/Floors Database Update Controller   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 245219             Date 09Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7166            Date 12May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 217684             Date 12May03               *
      *                 CAP043             Date 02May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAP055  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245219 - Missing deals in extension file DLDLDGQD (done from *
      *           Java layer).                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7166- Valid file does not match DEALSDG (Recompile)       *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  217684 - Authorisation User Malfunction. Recompile           *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FIRVCACFPD UF   E             DISK
     F                                     COMMIT
 
     FIRVCACFL1 UF   E           K DISK
     F                                     RENAME(IRVCACFD0:IRVCACFD1)
 
     FIRVECACFPDO    E             DISK
     F                                     RENAME(IRVCACFD0:IRVCACFERR)
 
     FIRVPCSCL0 UF A E           K DISK    INFSR(*PSSR)                                       CAP043
     F                                     RENAME(IRVPCSCD0:IRVPCSCD1)                        CAP043
     F                                     PREFIX(PV)                                         CAP043
                                                                                              CAP043
     FIRVEPCSCPDO  A E             DISK    INFSR(*PSSR)                                       CAP043
     F                                     RENAME(IRVPCSCD0:IRVPCSCERR)                       CAP043
     F                                     PREFIX(PV)                                         CAP043
                                                                                              CAP043
                                                                                              245219
      ** Midas DL IRS Deals Extension Details.                                                245219
     FDLDEALL5  UF A E           K DISK    INFSR(*PSSR)                                       245219
     F                                     IGNORE(DLDLDBD0)                                   245219
     F                                     IGNORE(DLDLDCD0)                                   245219
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,IRCACFU008
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
     D DBerrUpd        C                   CONST('DB error in IRS API update')
 
      *****************************************************************
 
      **  Externally defined data structure for valid record
     D IRVCACF       E DS                  EXTNAME(IRVCACFPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External data structure for FRA/IRS I.C.D. details
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)
 
      ** External DS for Trade Details
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACD1       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External data structure for Retail details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACD2       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Switchable features Description File
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Dummy Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              CGL029
      ** Dummy Data Structure                                                                 CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
 
     D IRCACFUPC       DS             1    DTAARA(IRCACFUPC)
 
     D Object          S             10A   INZ('IRCACFUPC')
     D LockObj         S             10A   INZ('IRCACFLCK')
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
     D KTimestamp      S             26Z
     D KDealNo         S              6  0
 
      ** Parameters for QRCVDTAQ
     D DtqNam          S             10
     D DtqLib          S             10
     D DtqLen          S              5  0
     D DtqDta          S             10
     D DtqWait         S              5  0
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D MsgSndRtn       S             10A
     D DBError         S             28A
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
     D CIR005          S              1A
     D CIR006          S              1A
     D CIR008          S              1A                                                      CIR008
     D CSC011          S              1A
     D CDE001          S              1A
     D CAP056          S              1A                                                      CAP056
 
     D PRetCode        S              7A
     D POption         S              7A
     D PSard           S              6A
     D PkDBRC          S              3A
 
     D PModeOfOp       S              6A                                                      CAP056
 
      ** Variables used by CAP043                                                             CAP043
     D CAP043          S              1A                                                      CAP043
     D CAP041          S              1A                                                      CAP043
     D PRtcd           S              7A                                                      CAP043
     D FOffKey         S             20A                                                      CAP043
     D OurThrKey       S              1A                                                      CAP043
     D PScreenInpt     S              1A                                                      CAP043
                                                                                              CAP043
     D WkActn          S              1A                                                      245219
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,IRCACFU009
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
 
      /COPY WNCPYSRC,IRCACFU001
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APCACFDTQ'
 
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
 
      ** Initialise Data queue parms
 
     C                   EVAL      DtqLen = 10
     C                   EVAL      DtqWait = -1
     C                   EVAL      DtqNam = 'APCACFDTQ'
     C                   EVAL      DtqLib = '*LIBL'
 
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file
 
     C                   DOW       DtqDta <> 'END'
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam
     C                   PARM                    DtqLib
     C                   PARM                    DtqLen
     C                   PARM                    DtqDta
     C                   PARM                    DtqWait
 
     C                   IF        DtqDta = 'GO'
 
      ** Lock allocation data area
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      /COPY WNCPYSRC,IRCACFU002
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
 
     C     1             SETLL     IRVCACFPD
 
      ** Read Valid Record
 
     C                   READ      IRVCACFD0                              88
     C                   DOW       *IN88 = *OFF
 
      /COPY WNCPYSRC,IRCACFU003
 
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lowere level modules
      ** will include the key information
 
     C                   EVAL      ARFOTranID = RPFRNT
     C                   EVAL      ARRprLocn  = RPREPA
 
      /COPY WNCPYSRC,IRCACFU004
 
      ** DL Database Update
 
     C                   IF        PRetCode <> '*RECUPD'
     C                   IF        RPCHTP = 'I' OR RPCHTP = 'A' OR
     C                             RPCHTP = 'R'
     C                             OR CIR008 = 'Y' AND RPCHTP = 'X'                           CIR008
     C                   Eval      WkActn = RPCHTP                                            245219
 
     C                   CALLB     'IRCACFUPD'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FRONT'      PModeOfOp                                    CAP056
     C                   PARM                    IRVCACF
     C                   PARM      'N'           PScreenInpt                                  CAP043
 
      ** Default Branch for ZMUSER
      ** Bank Details (SDBANKPD)
      ** General Ledger ICD (SDGELRPD)
      ** Trading ICD (SDTRADPD)
      ** Retail ICD (SDRETLPD)
      ** FRA/IRS ICD (SDFAISPD)
 
     C                   PARM                    PkDBRC
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDTRAD
     C                   PARM                    SDRETL
     C                   PARM                    SDFAIS
 
      ** Business Day Convention
      ** Amortisation of Caps/Collars/Floors
      ** 24x7 Midas Availability
      ** CCRM Limits
 
     C                   PARM                    CIR005
     C                   PARM                    CIR006
     C                   PARM                    CSC011
     C                   PARM                    CDE001
                                                                                              CIR008
      ** Switchable Feature CIR008                                                            CIR008
                                                                                              CIR008
     C                   PARM                    CIR008                                       CIR008
                                                                                              CAP056
      ** Switchable Feature CAP056                                                            CAP056
                                                                                              CAP056
     C                   PARM                    CAP056                                       CAP056
 
      /COPY WNCPYSRC,IRCACFU005
     C                   ENDIF
     C                   ENDIF
 
      ** Commit updates if no error
 
     C                   IF        PRetCode = '*ERROR ' OR
     C                             PRetCode = '*RECUPD'
     C                   ROLBK
     C                   ELSE
                                                                                              245219
      ** Add record to DLDLDGQD once deal is on DEALSDG as this is what java does             245219
     C                   IF        WkActn = 'I'                                               245219
     C                   EXSR      WriteDLDLDG                                                245219
     C                   END                                                                  245219
                                                                                              245219
     C                   DELETE    IRVCACFD0
                                                                                              CAP043
      ** Delete Our Principal Change                                                          CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
     C                   MOVE      RPFRNT        FOffKey                                      CAP043
     C                   MOVE      ' '           OurThrKey                                    CAP043
     C     KCFPC         SETLL     IRVPCSCL0                                                  CAP043
     C     KCFPC         READE     IRVPCSCL0                              98                  CAP043
     C                   DOW       *IN98 = *OFF                                               CAP043
     C                   DELETE    IRVPCSCD1                                                  CAP043
     C     KCFPC         READE     IRVPCSCL0                              98                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   COMMIT
     C                   ENDIF
 
      /COPY WNCPYSRC,IRCACFU006
 
     ** If an error has occurred, reaccess record in error and remove
     ** from file to prevent program processing the same record again
 
     C                   IF        PRetCode = '*ERROR ' OR
     C                             PRetCode = '*RECUPD'
     C                   EVAL      KDealno = RPDLNO
     C                   EVAL      KTimestamp = RPTMESTMP
     C     KCACFL1       CHAIN     IRVCACFL1                          89
 
     ** Write details of record to error file (same format as IRVCACFPD)
 
     C                   WRITE     IRVCACFERR
     C                   DELETE    IRVCACFD1
                                                                                              CAP043
      ** Our Principal Change                                                                 CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
     C                   MOVE      ' '           OurThrKey                                    CAP043
     C     KCFPC         SETLL     IRVPCSCL0                                                  CAP043
     C     KCFPC         READE     IRVPCSCL0                              89                  CAP043
     C                   DOW       *IN89 = *OFF                                               CAP043
     C                   WRITE     IRVPCSCERR                                                 CAP043
     C                   DELETE    IRVPCSCD1                                                  CAP043
     C     KCFPC         READE     IRVPCSCL0                              89                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
 
     ** Send message to system operator
 
     C                   MOVEL     DBerrUpd      DBError
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** Read valid deal
 
     C                   READ      IRVCACFD0                              88
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
 
      /COPY WNCPYSRC,IRCACFU007
 
      ** Exit from program
 
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRCACFU010
 
      *****************************************************************
      /EJECT
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT                                                                                  245219
      *****************************************************************                       245219
      *                                                               *                       245219
      * WriteDLDLDG - WRITE IRS Extension record                      *                       245219
      *               (usually done from java layer)                  *                       245219
      *                                                               *                       245219
      *****************************************************************                       245219
     C     WriteDLDLDG   BEGSR                                                                245219
      *                                                                                       245219
      ** When opening new deals within DEALSDG, write a corresponding                         245219
      ** record in the Deals details extension file DLDLDGQD.                                 245219
      *                                                                                       245219
     C     @KeyDealL5    KLIST                                                                245219
     C                   KFLD                    F1DLNO                                       245219
      *                                                                                       245219
     C                   MOVE      RPDLNO        F1DLNO                                       245219
     C     @KeyDealL5    CHAIN     DLDLDGD0                           82                      245219
      *                                                                                       245219
     C     *IN82         IFEQ      *ON                                                        245219
     C                   EVAL      F1BRCA = RPBRCA                                            245219
     C                   WRITE     DLDLDGD0                                                   245219
                                                                                              245219
     C                   ENDIF                                                                245219
                                                                                              245219
     C                   ENDSR                                                                245219
      *****************************************************************                       245219
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      **  Define key list for IRVCACFL1
 
     C     KCACFL1       KLIST
     C                   KFLD                    KDealno
     C                   KFLD                    KTimestamp
                                                                                              CAP043
      ** Define key list for IRVPCSCL0                                                        CAP043
                                                                                              CAP043
     C     KCFPC         KLIST                                                                CAP043
     C                   KFLD                    FOffKey                                      CAP043
     C                   KFLD                    OurThrKey                                    CAP043
 
      *  Check if an existing DBU_CACF job is active in the subsystem.
 
     C                   CALL      'SCC0520'
     C                   PARM                    LockObj
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Endjob
     C                   PARM                    Return2
 
      ** Lock allocation data area
 
      **  The data area is allocated *SHRRD here and *EXCL whilst
      **  processing of the valid file is actually taking place.
      **  The function to submit this updater tries to get a *EXCL lock.
      **  The controller tries to get a *SHRRD lock.
 
      **                        Submitter             Controller
      **                Lock      Lock     Submitter     Lock     Controller
      **     Status    Status   Successful   Action   Successful    Action
      **     ------    ------   ---------- ---------  ----------  ----------
      **  Not running  None        Yes      Submit       Yes        Prompt
      **                                    updater                 updater
 
      **  Running not  *SHRRD      No        None        Yes        Prompt
      **   processing                                               updater
 
      **  Processing   *EXCL       No        None        No         None
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateS
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBKEY  = POption
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger details via access program
      ** (database error handling done in access program)
 
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE  = 2
     C                   EVAL      DBKEY  = POption
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access FRA/IRS ICD details
 
     C                   CALLB     'AOFAISR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDFAIS        PARM      SDFAIS        DSFDY
 
     C                   IF        PRetCode <> *BLANK
     C                   EVAL      DBFILE = 'SDFAISPD'
     C                   EVAL      DBASE  = 3
     C                   EVAL      DBKEY  = POption
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Tranding Details
 
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDTRADPD'
     C                   EVAL      DBASE  = 4
     C                   EVAL      DBKEY  = POption
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Retail details via access program
 
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANK        PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDRETL        PARM      SDRETL        DSFDY
 
     C                   IF        PRetCode <> *BLANK
     C                   EVAL      DBFILE = 'SDRETLPD'
     C                   EVAL      DBASE  = 5
     C                   EVAL      DBKEY  = POption
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if FRA/IRS Business Day Convention is installed
 
     C                   EVAL      CIR005 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    POption
     C                   PARM      'CIR005'      PSARD
     C                   PARM      SCSARD        DSFDY
 
     C                   IF        PRetCode = *Blanks
     C                   EVAL      CIR005 = 'Y'
     C                   ELSE
     C                   IF        PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 6
     C                   EVAL      DBKEY = 'CIR005'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check if FRA/IRS Amortisation of Caps, Collars, Floors is installed
 
     C                   EVAL      CIR006 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    POption
     C                   PARM      'CIR006'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRetCode = *Blanks
     C                   EVAL      CIR006 = 'Y'
     C                   ELSE
     C                   IF        PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 7
     C                   EVAL      DBKEY = 'CIR006'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check if 24x7 Midas Availability is installed
 
     C                   EVAL      CSC011 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    POption
     C                   PARM      'CSC011'      PSARD
     C                   PARM      SCSARD        DSFDY
 
     C                   IF        PRetCode = *Blanks
     C                   EVAL      CSC011 = 'Y'
     C                   ELSE
     C                   IF        PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 8
     C                   EVAL      DBKEY = 'CSC011'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check if CCRM Limits is installed
 
     C                   EVAL      CDE001 = 'Y'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    POption
     C                   PARM      'CDE001'      PSARD
     C                   PARM      SCSARD        DSFDY
 
     C                   IF        PRetCode = *Blanks
     C                   EVAL      CDE001 = 'Y'
     C                   ELSE
     C                   IF        PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 9
     C                   EVAL      DBKEY = 'CDE001'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
                                                                                              CIR008
      **  Access SAR details file to determine if CIR008 is installed.                        CIR008
                                                                                              CIR008
     C                   CALL      'AOSARDR0'                                                 CIR008
     C                   PARM      *BLANKS       PRetCode                                     CIR008
     C                   PARM      '*VERIFY'     POption                                      CIR008
     C                   PARM      'CIR008'      PSARD                                        CIR008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR008
                                                                                              CIR008
     C                   IF        PRetCode <> *BLANKS and PRetCode <> '*NRF   '              CIR008
     C     *LOCK         IN        LDA                                                        CIR008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR008
     C                   EVAL      DBASE = 10                                                 CIR008
     C                   EVAL      DBKEY = 'CIR008'                                           CIR008
     C                   OUT       LDA                                                        CIR008
     C                   EXSR      *PSSR                                                      CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   IF        PRetCode = *BLANKS                                         CIR008
     C                   EVAL      CIR008 = 'Y'                                               CIR008
     C                   ELSE                                                                 CIR008
     C                   EVAL      CIR008 = 'N'                                               CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CAP056
      **  Access SAR details file to determine if CAP056 is installed.                        CAP056
                                                                                              CAP056
     C                   CALL      'AOSARDR0'                                                 CAP056
     C                   PARM      *BLANKS       PRetCode                                     CAP056
     C                   PARM      '*VERIFY'     POption                                      CAP056
     C                   PARM      'CAP056'      PSARD                                        CAP056
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP056
                                                                                              CAP056
     C                   IF        PRetCode <> *BLANKS and PRetCode <> '*NRF   '              CAP056
     C     *LOCK         IN        LDA                                                        CAP056
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP056
     C                   EVAL      DBASE = 11                                                 CAP056
     C                   EVAL      DBKEY = 'CAP056'                                           CAP056
     C                   OUT       LDA                                                        CAP056
     C                   EXSR      *PSSR                                                      CAP056
     C                   ENDIF                                                                CAP056
                                                                                              CAP056
     C                   IF        PRetCode = *BLANKS                                         CAP056
     C                   EVAL      CAP056 = 'Y'                                               CAP056
     C                   ELSE                                                                 CAP056
     C                   EVAL      CAP056 = 'N'                                               CAP056
     C                   ENDIF                                                                CAP056
 
      ** Determine if CAP043 is installed                                                     CAP043
                                                                                              CAP043
     C                   CALL      'AOSARDR0'                                                 CAP043
     C                   PARM      *BLANKS       PRtCd                                        CAP043
     C                   PARM      '*VERIFY'     POption                                      CAP043
     C                   PARM      'CAP043'      PSard                                        CAP043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP043
                                                                                              CAP043
     C                   IF        PRtCd = *Blanks                                            CAP043
     C                   EVAL      CAP043 = 'Y'                                               CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      CAP043 = 'N'                                               CAP043
                                                                                              CAP043
     C                   IF        PRtCd <> '*NRF'                                            CAP043
     C     *LOCK         IN        LDA                                                        CAP043
     C                   EVAL      DBKEY = 'CAP043'                                           CAP043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP043
     C                   EVAL      DBASE = 12                                                 CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Determine if CAP041 enhancement is installed                                         CAP043
                                                                                              CAP043
     C                   CALL      'AOSARDR0'                                                 CAP043
     C                   PARM      *BLANKS       PRtCd                                        CAP043
     C                   PARM      '*VERIFY'     POption                                      CAP043
     C                   PARM      'CAP041'      PSard                                        CAP043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP043
                                                                                              CAP043
     C                   IF        PRtCd = *Blanks                                            CAP043
     C                   EVAL      CAP041 = 'Y'                                               CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      CAP041 = 'N'                                               CAP043
                                                                                              CAP043
     C                   IF        PRtCd <> '*NRF'                                            CAP043
     C     *LOCK         IN        LDA                                                        CAP043
     C                   EVAL      DBKEY = 'CAP041'                                           CAP043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP043
     C                   EVAL      DBASE = 13                                                 CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      **  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRCACFU011
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
