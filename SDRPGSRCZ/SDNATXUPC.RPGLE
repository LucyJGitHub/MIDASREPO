     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-A/c Holder by Country of Tax Upd Ctl')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNATXUPC - SD Non-A/C Holders by Country of Tax Upd Ctl     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG24746           Date 02Jul09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 233295             Date 29Apr05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24746 - Missing Source for German Features (Recompile)    *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  233295 - Deletion problems on Non-account Holders.           *
      *  CGL032 - Automatic Exchange of Information.                  *
      *                                                               *
      *****************************************************************
     FSDVNATXPD UF   E             Disk    Commit
     FSDVNATXL1 UF   E           K Disk    Rename(SDVNATXD0:SDVNATXD1)
     FSDVENATXPDO    E             Disk    Rename(SDVNATXD0:SDVNATXERR)
 
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
     D DBerrUpd        C                   Const('DB error in NATX API update')
 
      *****************************************************************
 
      **  Externally Described Data Structure for Valid Non-A/C Holder
     D SDVNATX       E DS                  Extname(SDVNATXPD)
 
     D SDNATXUPC       DS             1    Dtaara(SDNATXUPC)
 
     D SCSARD        E DS                  Extname(SCSARDPD)
 
     D SCA_LCD       E                     Extfld(LCD)
      ** External DS for SAR details
     D DSFDY         E DS                  Extname(DSFDY)
      ** First DS for access programs, short data structure
 
 
     D Object          S             10A   Inz('SDNATXUPC')
     D LockObj         S             10A   Inz('SDNATXLCK')
     D Lib             S             10A   Inz('*LIBL')
     D ObjType         S              7A   Inz('*DTAARA')
     D LockStateE      S              7A   Inz('*EXCL')
     D LockStateS      S              7A   Inz('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   Inz('*CLS')
     D Dlcobj          S              1A
     D RETURN          S              7A
     D RETURN2         S              7A
     D Endjob          S              1A   Inz('Y')
     D @CuNaho         S             10A
     D @CuCtTx         S              2A
     D @Timestamp      S             26Z
     D CSW024          S              1A
     D PActCde         S              1A                                                      233295
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   Like(#MsgID)
     D DummyMsgF       S             10A
 
      ** Data queue details
      ** ------------------
     D DtqLen          S              5P 0 Inz(10)
     D DtqWait         S              5P 0 Inz(-1)
     D DtqNam          S             10A   Inz('APNATXDTQ')
     D DtqLib          S             10A   Inz('*LIBL')
     D DtqDta          S             10A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *******************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *******************************************************************
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APNATXDTQ'
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
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
 
      ** If data queue entry is 'END', leave the DOW loop at this point
     C                   IF        DtqDta = 'END'
     C                   LEAVE
     C                   ENDIF
 
      ** If data queue entry says run, first lock allocation data area
     C                   IF        DtqDta = 'GO'
 
      ** Allocate with exclusive lock state
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    RETURN
 
      ** Ensure the U7 and U8 indicators are off, to prevent problems
      ** caused by earlier errors.
     C                   CLEAR                   *InU7
     C                   CLEAR                   *InU8
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     SDVNATXPD
 
      ** Read Valid SD Non-A/C Holder
     C                   READ      SDVNATXD0                              99
     C                   DOW       *IN99 = *OFF
 
      ** Load the API dump data area with as many fields from the message
      **  header as are available, so that dumps in any lower level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = NTFRNT
     C                   EVAL      ARFOAsocID = *Blanks
     C                   EVAL      ARRprLocn  = NTREPA
     C                   EVAL      @Timestamp = NTTMST
 
      ** SD Database Update
     C                   CALLB     'SDNATXUPD'
     C                   PARM      *Blanks       @@RTCD            7
     C                   PARM                    PActCde                                      233295
     C                   PARM                    SDVNATX
 
      * Commit updates if no error
     C                   IF        @@RTCD = '*ERROR '
     C                             Or @@RTCD = '*RECUPD'
     C                   ROLBK
     C                   ELSE
     C                   DELETE    SDVNATXD0
     C                   COMMIT
     C                   ENDIF
 
      ** If an error has occurred, reaccess record in error and remove from
      ** the file to prevent program processing the same record again
     C                   IF        @@RTCD = '*ERROR '
     C                             Or @@RTCD = '*RECUPD'
     C                   EVAL      @CuNaho = NTNAHO
     C                   EVAL      @CuCtTx = NTCTTX
     C                   EVAL      @Timestamp = NTTMST
 
     C     @KeyNaTxL1    CHAIN     SDVNATXL1                          89
 
      ** Write details of record to error file (same format as SDVNATXPD)
     C                   WRITE     SDVNATXERR
     C                   DELETE    SDVNATXD1
 
      ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
     C                   READ      SDVNATXD0                              99
     C                   ENDDO
 
      ** Unlock allocation data area
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    RETURN
 
     C                   ENDIF
      ** End loop for data queue prompt
     C                   ENDDO
 
      ** Exit from program
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Define key list for SDVNATXL1
     C     @KeyNaTxL1    KLIST
     C                   KFLD                    @CuNaho
     C                   KFLD                    @CuCtTx
     C                   KFLD                    @Timestamp
 
      ** Check if an existing DBU_NATX job is active in the subsystem.
     C                   CALL      'SCC0520'
     C                   PARM                    LockObj
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Endjob
     C                   PARM                    RETURN2
 
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
     C                   PARM                    RETURN
 
      ** Create required QTEMP objects
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde        10
 
      ** Access SAR details file to determine if CSW024
      ** S.W.I.F.T. MT3xx Field 82/83/87 is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW024'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *Blanks
     C                   EVAL      CSW024 = 'Y'
     C                   ELSE
     C                   EVAL      CSW024 = 'N'
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * SRERR - Exception errors                                     *
      ****************************************************************
     C     SRERR         BEGSR
 
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'SDNATXUPD'   Dbpgm            10
     C                   EVAL      *InU7 = *ON
     C                   EVAL      *InU8 = *ON
     C                   EVAL      *InLR = *ON
     C                   DUMP
 
      **  Terminate the program
     C                   RETURN
 
     C                   ENDSR
      ****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
