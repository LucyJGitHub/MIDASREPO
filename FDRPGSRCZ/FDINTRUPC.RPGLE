     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD MM int. rates database update controller')
      *****************************************************************
      *                                                               *
      *  Midas - Fixed Data Module                                    *
      *                                                               *
      *  FDINTRUPC - FD MM Interest Rates Database Update Controller  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 01May01               *
      *                 CAP058             Date 01May01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 19Jan99               *
      *                 CAP005  *CREATE    Date 17Oct98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  201589 - Change to check a new locking dataarea FDINTRLCK    *
      *           to determine whether this DBU is already active.    *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP058 - Full API for Money Market Interest Rates            *
      *  CAP006 - Send prompt to DTAQ to restart update process after *
      *           failure.                                            *
      *  CAP005 - Conversion of Citydealer Rates upload to use APIs   *
      *                                                               *
      *****************************************************************
     FFDVINTRPD UF   E             DISK
     F                                     COMMIT
     FFDVINTRL1 UF   E           K DISK
     F                                     RENAME(FDVINTRD0:FDVINTRD1)
     FFDVEINTRPDO    E             DISK
     F                                     RENAME(FDVINTRD0:FDVINTRERR)
                                                                                CSD006
      ** MDF Request Details by Request Id                                      CSD006
     FSDMDFRL1  IF   E           K DISK    INFSR(*PSSR)                         CSD006
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
     D DBerrUpd        C                   CONST('DB error in Int Rt update')
 
      *****************************************************************
 
      **  Externally described data structure for valid MM Int. Rates record
     D FDVINT        E DS                  EXTNAME(FDVINTRPD)
                                                                                CAP058
      ** Interest Rates Validation Workfields                                   CAP058
     D ValWrkFlds    E DS                  EXTNAME(FDWINTRPD)                   CAP058
                                                                                CAP058
      ** External DS for Switchable Features                                    CAP058
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP058
                                                                                CSD006
     D SDMAPC        E DS                  EXTNAME(SDMAPCPD)                    CSD006
      ** External DS for Market Data Feeds Mapping Codes                        CSD006
                                                                                CAP058
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CAP058
      ** First DS for Access Programs, short data structure                     CAP058
 
     D FDINTRUPC       DS             1
 
     D Object          S             10A   INZ('FDINTRUPC')
     D LockObj         S             10A   INZ('FDINTRLCK')                                   201589
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
                                                                                CSD006
      ** Mapping Code                                                           CSD006
     D PMAPCD          S             32                                         CSD006
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
 
      /COPY WNCPYSRC,FDINTRU001
 
      ** Set up the name of the server/database updater data queue.             CAP006
     C                   EVAL      DtaQName = 'APINTRDTQ'                       CAP006
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
     C                   EVAL      DtqNam = 'APINTRDTQ'
     C                   EVAL      DtqLib = '*LIBL'
     C                   EVAL      ObjType = '*DTAARA'
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid MM interest rates file
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
 
      /COPY WNCPYSRC,FDINTRU002
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     FDVINTRPD
 
      ** Read valid MM Interest Rates record
     C                   READ      FDVINTRD0                              99    *
     C     *IN99         DOWEQ     '0'
                                                                                CSD006
      ** Access Mapping Codes File if CSD006 is on.                             CSD006
                                                                                CSD006
     C     CSD006        IFEQ      'Y'                                          CSD006
     C                   EXSR      SrMAPCODE                                    CSD006
     C                   ENDIF                                                  CSD006
 
      /COPY WNCPYSRC,FDINTRU003
 
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = FYCCY
     C                   EVAL      ARRprLocn  = FYREPA
 
      /COPY WNCPYSRC,FDINTRU004
 
      ** FD DATABASE UPDATE
     C                   CALLB     'FDINTRUPD'
     C                   PARM                    @@RTCD            7
     C                   PARM                    FDVINT
     C                   PARM                    ValWrkFlds                     CAP058
 
      /COPY WNCPYSRC,FDINTRU005
 
      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP058
     C                   ROLBK
     C                   ELSE
     C                   DELETE    FDVINTRD0
     C                   COMMIT
     C                   END
 
      /COPY WNCPYSRC,FDINTRU006
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP058
     C                   EVAL      @Currency = FYCCY
     C                   EVAL      @Timestamp = FYTMESTMP
     C     @KINTL1       CHAIN     FDVINTRL1                          89
     ** Write details of record to error file (same format as FDVINTRPD)
     C                   WRITE     FDVINTRERR
     C                   DELETE    FDVINTRD1
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** Read valid MM Interest Rates record
     C                   READ      FDVINTRD0                              99    *
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
 
      /COPY WNCPYSRC,FDINTRU007
 
      * EXIT FROM PROGRAM
     C                   RETURN
      *****************************************************************         CSD006
     C/EJECT                                                                    CSD006
      *****************************************************************         CSD006
      *                                                               *         CSD006
      * SrMAPCODE - Access Mapping Code File                          *         CSD006
      *                                                               *         CSD006
      *****************************************************************         CSD006
     C     SrMAPCODE     BEGSR                                                  CSD006
                                                                                CSD006
      ** Initialise API Request type workfield                                  CSD006
                                                                                CSD006
     C                   EVAL      WAPIT = *BLANK                               CSD006
                                                                                CSD006
      ** If the Request Data Id is entered, check to Request Details File       CSD006
      ** if existing                                                            CSD006
                                                                                CSD006
     C     FYDTFR        IFNE      *BLANK                                       CSD006
                                                                                CSD006
     C     FYDTFR        CHAIN     SDMDFRL1                           81        CSD006
                                                                                CSD006
      ** Access Market Data Feed Mapping Code to get Request type               CSD006
                                                                                CSD006
     C     *IN81         IFEQ      FALSE                                        CSD006
     C                   CALL      'AOMAPCR0'                                   CSD006
     C                   PARM      *BLANK        @RTCD                          CSD006
     C                   PARM      '*KEY   '     @OPTN                          CSD006
     C                   PARM      MRMAPC        PMAPCD                         CSD006
     C     SDMAPC        PARM      SDMAPC        DSFDY                          CSD006
                                                                                CSD006
      ** Database error                                                         CSD006
                                                                                CSD006
     C     @RTCD         IFNE      *BLANKS                                      CSD006
     C                   MOVEL     'SDMAPCPD'    DBFILE                         CSD006
     C                   Z-ADD     4             DBASE                          CSD006
     C                   MOVEL     MRMAPC        DBKEY                          CSD006
     C                   ELSE                                                   CSD006
     C                   EVAL      WAPIT = MCAPIT                               CSD006
     C                   ENDIF                                                  CSD006
     C                   ENDIF                                                  CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
     C                   ENDSR                                                  CSD006
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
 
      *  Define data area used to check if DB update running
     C     *DTAARA       DEFINE                  FDINTRUPC
 
      *  Define key list for FDINTRLL1
     C     @KINTL1       KLIST
     C                   KFLD                    @Currency         3
     C                   KFLD                    @Timestamp
 
      *  Check if an existing DBU_INTR job is active in the subsystem.                        201589
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
                                                                                CSD006
      ** Access SAR details file to see if CSD006 is installed.                 CSD006
                                                                                CSD006
     C                   CALL      'AOSARDR0'                                   CSD006
     C                   PARM      *BLANKS       @RTCD                          CSD006
     C                   PARM      '*VERIFY'     @OPTN                          CSD006
     C                   PARM      'CSD006'      @SARD                          CSD006
     C     SCSARD        PARM      SCSARD        DSFDY                          CSD006
                                                                                CSD006
     C                   IF        @RTCD <> *Blanks AND                         CSD006
     C                             @RTCD <> '*NRF   '                           CSD006
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSD006
     C                   Z-ADD     2             DBASE                          CSD006
     C                   MOVEL     'CSD006'      DBKEY                          CSD006
     C                   EXSR      *PSSR                                        CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
     C                   IF        @RTCD = *Blanks                              CSD006
     C                   MOVEL     'Y'           CSD006                         CSD006
     C                   ELSE                                                   CSD006
     C                   MOVEL     'N'           CSD006                         CSD006
     C                   ENDIF                                                  CSD006
 
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
(c) Finastra International Limited 2001
