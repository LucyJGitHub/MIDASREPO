     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details by Country of Tax Up Ctl')   *
      *****************************************************************
      *                                                               *
      *  Midas - SD Standing Data Module                              *
      *                                                               *
      *  SDCCTXUPC - SD Customer Details by Country of Tax Update     *
      *              Controller                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236137             Date 21Sep05               *
      *                 234840             Date 05Jul04               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  236137 - Change Control for CGL031 (Recompile)               *
      *  234840    - Fix parameter mismatch for call to module        *
      *              SDCCTXUPD.                                       *
      *  CGL031 - Taxation on Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** Midas SD Valid CCTX
     FSDVCCTXPD UF   E             DISK    COMMIT
 
      ** Midas SD Valid CCTX by Customer, Country of Tax & Timestamp
     FSDVCCTXL1 UF   E           K DISK    RENAME(SDVCCTXD0:SDVCCTXD1)
 
      ** Midas SD CCTX Records in Error from DBU Function
     FSDVECCTXPDO    E             DISK    RENAME(SDVCCTXD0:SDVCCTXERR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
      /COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
      /COPY ZACPYSRC,DTAQCHKDCL
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in CCTX API update')
 
      *****************************************************************
 
      **  Externally Described Data Structure for Valid CCTX
     D SDVCCTX       E DS                  EXTNAME(SDVCCTXPD)
 
     D SDCCTXUPC       DS             1    DTAARA(SDCCTXUPC)
 
      ** Parameter for APCALCOBJ
     D Object          S             10A   INZ('SDCCTXUPC')
     D LockObj         S             10A   INZ('SDCCTXLCK')
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
 
      ** Parameter for SDCCTXUPD
     D P@Rtcd          S              7A
     D PMode           S              7A                                                      CER059
     D PAction         S              1A                                                   234840
     D PCustNo         S              6A                                                   234840
 
      ** Parameter for Access Objects
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              7A
 
      ** Parameter for APCCRTQTO
     D ReturnCde       S             10A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
     D MsgSndRtn       S             10A
 
      ** Command length for QCMDEXC
     D CommandLen      S             15P 5 INZ(26)
 
      ** Data queue details
      ** ------------------
     D DtqLen          S              5P 0 INZ(10)
     D DtqWait         S              5P 0 INZ(-1)
     D DtqNam          S             10A   INZ('APCCTXDTQ')
     D DtqLib          S             10A   INZ('*LIBL')
     D DtqDta          S             10A
 
      ** Other Variables
     D DBError         S             28A
     D WCustomer       S              6A
     D WCountry        S              2A
 
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
     C                   EVAL      DtaQName = 'APCCTXDTQ'
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
      /COPY ZACPYSRC,DTAQCHK
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
     C                   PARM                    Return
 
      ** Ensure the U7 and U8 indicators are off, to prevent problems
      ** caused by earlier errors.
 
     C                   CLEAR                   *INU7
     C                   CLEAR                   *INU8
 
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
 
     C     1             SETLL     SDVCCTXPD
 
      ** Read Valid Customer by Country of Tax
 
     C                   READ      SDVCCTXD0                              99
     C                   DOW       *IN99 = *OFF
 
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lower level modules
      **  will include the key information
 
     C                   EVAL      ARFOTranID = CTFRNT
     C                   EVAL      ARFOAsocID = *Blanks
     C                   EVAL      ARRprLocn  = CTREPA
     C                   EVAL      WTimestamp = CTTMST
 
      ** SD Database Update
 
     C                   CALLB     'SDCCTXUPD'
     C                   PARM      *Blanks       P@Rtcd
     C                   PARM      *BLANK        PMode                                        CER059
     C                   PARM      'I'           PAction                                   234840
     C                   PARM      CTCUST        PCustNo                                   234840
     C                   PARM                    SDVCCTX
 
      ** Commit Updates if no error
 
     C                   IF        P@Rtcd = '*ERROR ' or
     C                             P@Rtcd = '*RECUPD'
 
     C                   ROLBK
     C                   ELSE
 
     C                   DELETE    SDVCCTXD0
     C                   COMMIT
 
     C                   ENDIF
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
 
     C                   IF        P@Rtcd = '*ERROR ' or
     C                             P@Rtcd = '*RECUPD'
     C                   EVAL      WCustomer = CTCUST
     C                   EVAL      WCountry = CTCTTX
     C                   EVAL      WTimestamp = CTTMST
 
     C     KeyCCTXL1     CHAIN     SDVCCTXL1                          89
 
     ** Write details of record to error file (same format as SDVCCTXPD)
 
     C                   WRITE     SDVCCTXERR
     C                   DELETE    SDVCCTXD1
 
     ** Send message to system operator
 
     C                   EVAL      DBError = DBerrUpd
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** Read Valid SD Additional Customers
 
     C                   READ      SDVCCTXD0                              99
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
 
      ** Exit from program
 
     C                   RETURN
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
 
      ** Define key list for SDVCCTXL1
 
     C     KeyCCTXL1     KLIST
     C                   KFLD                    WCustomer
     C                   KFLD                    WCountry
     C                   KFLD                    WTimestamp
 
      ** Check if an existing DBU_CCTX job is active in the subsystem.
 
     C                   CALL      'SCC0520'
     C                   PARM                    LockObj
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Endjob
     C                   PARM                    Return2
 
      **  Lock allocation data area
 
      **   The data area is allocated *SHRRD here and *EXCL whilst processing
      **    of the valid file is actually taking place.
      **   The function to submit this updater tries to get a *EXCL lock.
      **   The controller tries to get a *SHRRD lock.
 
      **                         Submitter             Controller
      **                 Lock      Lock     Submitter     Lock     Controller
      **      Status    Status   Successful   Action   Successful    Action
      **      ------    ------   ---------- ---------  ----------  ----------
      **   Not running  None        Yes      Submit       Yes        Prompt
      **                                     updater                 updater
 
      **   Running not  *SHRRD      No        None        Yes        Prompt
      **    processing                                               updater
 
      **   Processing   *EXCL       No        None        No         None
 
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
     C                   PARM                    ReturnCde
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - Exception Errors                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
 
     C                   EVAL      P@Rtcd = '*ERROR '
     C                   EVAL      DBPGM  = 'SDCCTXUPD'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
 
      **  Terminate the program
 
     C                   RETURN
 
     C                   ENDSR
      ****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      /EJECT
** CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2004
