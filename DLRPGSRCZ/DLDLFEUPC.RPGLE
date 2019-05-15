     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Dealing Fees DB Update Controller')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLFEUPC - Midas DL Dealing Fees DB Update Controller       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
 
      ** Midas DL Valid Dealing Fees
     FDLVDLFEPD UF   E             DISK
     F                                     COMMIT
 
      ** Base Rate keyed by Ccy/Base Rate No/Timestamp
     FDLVDLFEL1 UF   E           K DISK
     F                                     RENAME(DLVDLFED0:DLVDLFED1)
 
      ** Midas DL Dealing Fees in Error from DBU Function
     FDLVEDLFEPDO    E             DISK
     F                                     RENAME(DLVDLFED0:DLVDLFEERR)
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,DLDLFEU001
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
     D DBerrUpd        C                   CONST('DB error in DLFE API update')
 
      *****************************************************************
 
      **  Externally Described Data Structure for Valid Base Rate
     D DLVDLFE       E DS                  EXTNAME(DLVDLFEPD)
 
     D DLDLFEUPC       DS             1
 
     D Object          S             10A   INZ('DLDLFEUPC')
     D LockObj         S             10A   INZ('DLDLFELCK')
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
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,DLDLFEU002
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APDLFEDTQ'
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
      **  Initialise Data queue parms
 
     C                   EVAL      DtqLen = 10
     C                   EVAL      DtqWait = -1
     C                   EVAL      DtqNam = 'APDLFEDTQ'
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
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
 
     C     1             SETLL     DLVDLFEPD
 
      ** Read Valid Dealing Fees
 
     C                   READ      DLVDLFED0                              99
     C     *IN99         DOWEQ     *OFF
 
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lowere level modules
      **  will include the key information
 
     C                   EVAL      ARFOTranID = DLFRNT
     C                   EVAL      ARRprLocn  = DLREPA
 
     C     DLLCDT        IFEQ      'I'
     C     DLLCDT        OREQ      'A'
     C     DLLCDT        OREQ      'D'
 
      ** DL Database Update
 
     C                   CALLB     'DLDLFEUPD'
     C                   PARM                    ReturnCode
     C                   PARM                    DLVDLFE
      *
     C                   ENDIF
 
      ** Comit Updates if no error
 
     C     ReturnCode    IFEQ      '*ERROR '
     C     ReturnCode    OREQ      '*ERTBTK'
     C     ReturnCode    OREQ      '*RECUPD'
     C                   ROLBK
     C                   ELSE
     C                   DELETE    DLVDLFED0
     C                   COMMIT
     C                   END
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
 
     C     ReturnCode    IFEQ      '*ERROR '
     C     ReturnCode    OREQ      '*ERTBTK'
     C     ReturnCode    OREQ      '*RECUPD'
     C                   EVAL      @DealNo    = DLDLNO
     C                   EVAL      @Sequence  = DLFSEQ
     C                   EVAL      @Timestamp = DLTMST
 
     C     @KBSRT1       CHAIN     DLVDLFEL1                          89
 
      ** Write details of record to error file (same format as DLVDLFEPD)
 
     C                   WRITE     DLVDLFEERR
     C                   DELETE    DLVDLFED1
 
      ** Send message 'Unable to update'
 
     C     ReturnCode    IFEQ      '*ERTBTK'
     C                   MOVEL     'USR0015'     DummyMsgID
     C                   ELSE
     C                   MOVEL     *BLANKS       DummyMsgID
     C                   ENDIF
 
      ** Send message to system operator
 
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** Read Valid Dealing Fees
     C                   READ      DLVDLFED0                              99
     C                   ENDDO
 
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
 
      ** Exit from Program
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Define data area used to check if DB update running
 
     C     *DTAARA       DEFINE                  DLDLFEUPC
 
      ** Define key list for DLVDLFEL1
 
     C     @KBSRT1       KLIST
     C                   KFLD                    @DealNo           6 0
     C                   KFLD                    @Sequence         2 0
     C                   KFLD                    @Timestamp
 
      ** Check if an existing DBU_DLFE job is active in the subsystem.
 
     C                   CALL      'SCC0520'
     C                   PARM                    LockObj
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Endjob
     C                   PARM                    Return2
 
      ** Lock allocation data area
 
      **  The data area is allocated *SHRRD here and *EXCL whilst processing
      **   of the valid file is actually taking place.
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
 
      ** Create required QTEMP objects
 
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde        10
 
     C                   ENDSR
      ****************************************************************
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
(c) Finastra International Limited 2004
