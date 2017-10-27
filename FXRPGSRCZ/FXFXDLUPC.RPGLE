     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deals database update controller')            *
      *****************************************************************
      *                                                               *
      *  Midas - FX Dealer Module                                     *
      *                                                               *
      *  FXFXDLUPC - FX DEALS DATABASE UPDATE CONTROLLER              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CSW212             Date 03May12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257309             Date 22Oct08               *
      *                 256564             Date 17Sep08               *
      *                 245219             Date 09Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244036             Date 22Sep06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CFX114             Date 15Jun04               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 11Nov99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 24Feb99               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  257309 - Prevents DLDLDBQD locking                           *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245219 - DLDLDBQD should be updated when FXDEALPP is updated *
      *           as this is the stage java would update it.          *
      *  244036 - Missing deals in extension file DLDLDBQD (done from *
      *           Java layer).                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CFX114 - Core changes for GBO014                             *
      *         - Perform Override when Exchange Rate Tolerance is    *
      *           exceeded.                                           *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:FXFXDLU011,FXFXDLU005            *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in FXVFXDLPD*
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  201589 - Change to check a new locking dataarea FXFXDLLCK    *
      *           to determine whether this DBU is already active.    *
      *  CDL008 - Continuous Linked Settlement                        *
      *  CAP051 - Automatic Authorisation (FX Part)                   *
      *           Recompiled due to changes in FXVFXDLPD              *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in FXVFXDLPD              *
      *  CAP006 - Check for deal being updated by another workstation *
      *         - Send prompt to DTAQ to restart update process after *
      *           failure.                                            *
      *  CAP002 - Conversion of FX inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FFXVFXDLPD UF   E             DISK
     F                                     COMMIT
     FFXVFXDLL1 UF   E           K DISK
     F                                     RENAME(FXVFXDLD0:FXVFXDLD1)
     FFXVEFXDLPDO    E             DISK
     F                                     RENAME(FXVFXDLD0:FXVFXDLERR)
                                                                                              244036
      ** Midas DL Foreign Exchange Deals Extension Details.                                   244036
     FDLDEALL5  UF A E           K DISK    INFSR(*PSSR)                                       244036
     F                                     IGNORE(DLDLDCD0)                                   244036
     F                                     IGNORE(DLDLDGD0)                                   244036
     F                                     USROPN                                             257309
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FXFXDLU010
 
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
 
      ** Include the FX standard declares
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
     D DBerrUpd        C                   CONST('DB error in FX API update')
 
      *****************************************************************
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID FX DEAL
     D FXVFXD        E DS                  EXTNAME(FXVFXDLPD)
 
     D FXFXDLUPC       DS             1
 
     D Object          S             10A   INZ('FXFXDLUPC')
     D LockObj         S             10A   INZ('FXFXDLLCK')                                   201589
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
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FXFXDLU011
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
 
      /COPY WNCPYSRC,FXFXDLU001
 
      ** Set up the name of the server/database updater data queue.             CAP006
     C                   EVAL      DtaQName = 'APFXDLDTQ'                       CAP006
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
     C                   EVAL      DtqNam = 'APFXDLDTQ'
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
 
      /COPY WNCPYSRC,FXFXDLU002
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     FXVFXDLPD
 
      ** READ VALID FX DEAL
     C                   READ      FXVFXDLD0                              99    *
     C     *IN99         DOWEQ     '0'
 
      /COPY WNCPYSRC,FXFXDLU003
 
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lowere level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = F3FRNT
     C                   EVAL      ARFOAsocID = F3AFRT
     C                   EVAL      ARRprLocn  = F3REPA
 
      /COPY WNCPYSRC,FXFXDLU004
 
      ** FX DATABASE UPDATE
     C                   CALLB     'FXFXDLUPF'
     C**********         PARM                    @@RTCD            7            CAP006
     C                   PARM      *BLANKS       @@RTCD            7            CAP006
     C                   PARM                    FXVFXD
 
      /COPY WNCPYSRC,FXFXDLU005
 
      ** DL DATABASE UPDATE IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C                   ROLBK
     C                   ELSE
                                                                                              245219
      ** Add record to DLDLDBQD once deal is on FXDEALPP as this is what java does            245219
     C                   IF        F3CHTP = *blanks                                           245219
     C                   EXSR      WriteDLDLDB                                                245219
     C                   END                                                                  245219
                                                                                              245219
     C     @@RTCD        IFNE      '*RECUPD'                                    CAP006
     C     F3CHTP        IFEQ      'I'
     C     F3CHTP        OREQ      'A'
     C     F3CHTP        OREQ      'R'
 
      /COPY WNCPYSRC,FXFXDLU006
 
     C                   CALLB     'FXFXDLUPD'
     C                   PARM                    @@RTCD            7
     C                   PARM                    FXVFXD
     C/COPY WNCPYSRC,FXH00251
                                                                                              245219
      * DLDLDBQD records needs to be written when FXDEALPP record is written, not DEALSDB     245219
      * This is when F3CHTP is blank.  Authorisation needed must be YES for                   245219
      * midasplus so F3CHTP will always be blank when writing to FXDEALPP.                    245219
      *********                                                                        244036 245219
      ***Add*record within Deals Master Extension File (done from Java layer).         244036 245219
     C*********          IF        F3CHTP = 'I'                                        244036 245219
     C*********          EXSR      WriteDLDLDB                                         244036 245219
     C*********          END                                                           244036 245219
                                                                                       244036 245219
     C                   END
     C                   END                                                    CAP006
     C                   END
 
      /COPY WNCPYSRC,FXFXDLU007
 
      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
     C                   ROLBK
     C                   ELSE
     C                   DELETE    FXVFXDLD0
 
      /COPY WNCPYSRC,FXFXDLU014
 
     C                   COMMIT
     C/COPY WNCPYSRC,FXFXDLUC01
     C                   END
 
      /COPY WNCPYSRC,FXFXDLU008
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
     C                   EVAL      @Dealno = F3DN38
     C                   EVAL      @Timestamp = F3TMESTMP
     C     @KFXDL1       CHAIN     FXVFXDLL1                          89
     ** Write details of record to error file (same format as FXVFXDLPD)
     C                   WRITE     FXVFXDLERR
     C                   DELETE    FXVFXDLD1
 
      /COPY WNCPYSRC,FXFXDLU015
 
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** READ VALID FX DEAL
     C                   READ      FXVFXDLD0                              99    *
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
 
      /COPY WNCPYSRC,FXFXDLU009
 
      * EXIT FROM PROGRAM
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FXFXDLU012
 
      *****************************************************************                       244036
      /EJECT                                                                                  244036
      *****************************************************************                       244036
      *                                                               *                       244036
      * WriteDLDLDB - WRITE Foreign Exchange Extension record (done   *                       244036
      *               from Java layer).                               *                       244036
      *                                                               *                       244036
      *****************************************************************                       244036
     C     WriteDLDLDB   BEGSR                                                                244036
      *                                                                                       244036
      ** When opening new deals within DEALSDB, write a corresponding                         244036
      ** record in the Deals details extension file DLDLDBQD.                                 244036
      *                                                                                       244036
     C     @KeyDealL5    KLIST                                                                244036
     C                   KFLD                    F1DLNO                                       244036
      *                                                                                       244036
     C                   MOVE      F3DN38        F1DLNO                                       244036
     C                   OPEN      DLDEALL5                                                   257309
     C     @KeyDealL5    CHAIN     DLDLDBD0                           82                      244036
      *                                                                                       244036
     C     *IN82         IFEQ      *ON                                                        244036
     C                   EVAL      F1BRCA = F3MBCA                                            244036
     C                   WRITE     DLDLDBD0                                                   244036
                                                                                              244036
     C                   ENDIF                                                                244036
     C                   CLOSE     DLDEALL5                                                   257309
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
 
      *  Define data area used to check if DB update running
     C     *DTAARA       DEFINE                  FXFXDLUPC
      *  Define key list for FXVFXDLL1
     C     @KFXDL1       KLIST
     C                   KFLD                    @Dealno           6 0
     C                   KFLD                    @Timestamp
 
      *  Check if an existing DBU_FXDL job is active in the subsystem.                        201589
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
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FXFXDLU013
 
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
