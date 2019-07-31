     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer/Authority Dbase Update Cntroller')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUAHUPC - SD Customer/Authority Holders Database Update    *
      *              Controller                                       *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG26903 *CREATE   Date 15Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26903 - Background job DBU_CUAH fails                     *
      *                                                               *
      *****************************************************************
      *
      ** Midas SD Valid Customer/Authority Holder Details
      *
     FSDVCUAHPD UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Midas SD Valid Customer/Authority
      *
     FSDVCUAHL0 UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDVCUAHD0:SDVCUAHD1)
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      ** True       logical = *on (for indcator processing)
      ** False      logical = *off (for indcator processing)
      ** DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      ** error handler)
      ** and the following variables:
      ** RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
      *
      /COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
      *
      /COPY ZACPYSRC,DTAQCHKDCL
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
     D DBerrUpd        C                   CONST('DB error in CUAH +
     D                                           API update')
      *
      *****************************************************************
      *
      **  Externally Described Data Structure for Customer
      *
     D SDVCUAH       E DS                  EXTNAME(SDVCUAHPD)
      *
     D PUpdKey         DS
     D   WkCust                1      6
     D   WkAuth                7     16
     D   WkLtyp               17     18
      *
      ** Parameter for APCALCOBJ
      *
     D Object          S             10A   INZ('SDCUAHUPC')
     D LockObj         S             10A   INZ('SDCUAHLCK')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockStateE      S              7A   INZ('*EXCL')
     D LockStateS      S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('*CLS')
     D Dlcobj          S              1A
     D Return          S              7A
     D Endjob          S              1A   INZ('Y')
     D PTimestamp      S               Z
      *
      ** Parameter for Access Objects
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              7A
      *
      ** Parameter for APCCRTQTO
      *
     D ReturnCde       S             10A
      *
      ** Dummy message ID and message file fields for use on the calls
      ** to ZAMSGTOOPR
      *
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
     D MsgSndRtn       S             10A
      *
      ** Data queue details
      *
     D DtqLen          S              5P 0 INZ(10)
     D DtqWait         S              5P 0 INZ(-1)
     D DtqNam          S             10A   INZ('APCUAHDTQ')
     D DtqLib          S             10A   INZ('*LIBL')
     D DtqDta          S             10A
      *
      ** Other Variables
      *
     D DBError         S             28A
     D PAuth           S             10A
     D KFCust          S              6A
     D KFFrntOffc      S             20A
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
      *
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DtaQName = 'APCUAHDTQ'
      *
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a
      ** 'GO'. message to the data queue if there are not.
      *
      /COPY ZACPYSRC,DTAQCHK
      *
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file
      *
     C                   DOW       DtqDta <> 'END'
      *
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam
     C                   PARM                    DtqLib
     C                   PARM                    DtqLen
     C                   PARM                    DtqDta
     C                   PARM                    DtqWait
      *
      ** If data queue entry is 'END', leave the DOW loop at this point
      *
     C                   IF        DtqDta = 'END'
     C                   LEAVE
     C                   ENDIF
      *
      ** If data queue entry says run, first lock allocation data area
      *
     C                   IF        DtqDta = 'GO'
      *
      ** Allocate with exclusive lock state
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
      *
      ** Ensure the U7 and U8 indicators are off, to prevent problems
      ** caused by earlier errors.
      *
     C                   CLEAR                   *INU7
     C                   CLEAR                   *INU8
      *
      ** Position file cursor to start of file to prevent problems on
      ** later calls
      *
     C     1             SETLL     SDVCUAHPD
     C                   READ      SDVCUAHD0                              98
      *
     C                   DOW       *IN98 = *OFF
      *
      ** Load the API Dump data area with as many fields from the
      ** message header as are available, so that dumps in any lower
      ** level modules will include the key information
      *
     C                   EVAL      ARFOTranID = ACFRNT
     C                   EVAL      ARRprLocn  = ACREPA
     C                   EVAL      PTimestamp = ACTMST
     C                   EVAL      KFCust = ACCUST
     C                   EVAL      KFFrntOffc = ACFRNT
      *
      ** Update Customer/Authority Holder Details
      *
     C                   CALLB     'SDCUAHUPD'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      *BLANKS       PUpdKey
     C                   PARM                    SDVCUAH
      *
      ** Commit Updates if no error
      *
     C                   IF        PRtCd = '*ERROR ' OR
     C                             PRtCd = '*RECUPD'
      *
     C                   ROLBK
     C                   ELSE
      *
      ** Delete the details from valid file if update is successful
      *
     C                   DELETE    SDVCUAHD0
     C                   COMMIT
      *
     C                   ENDIF
      *
     C                   IF        PRtcd = '*ERROR ' OR
     C                             PRtcd = '*RECUPD'
      *
     C     KLCuAh        CHAIN     SDVCUAHL0
      *
     C                   DELETE    SDVCUAHD1
      *
      ** Send message to system operator
      *
     C                   EVAL      DBError = DBerrUpd
      *
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
      *
     C                   ENDIF
      *
      ** Read next record from the valid file
      *
     C                   READ      SDVCUAHD0                              98
      *
     C                   ENDDO
      *
      ** Unlock allocation data area
      *
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Return
      *
     C                   ENDIF
      *
      ** End loop for data queue prompt
      *
     C                   ENDDO
      *
      ** Return from Program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Define key list for SDVCUAHL1
      *
     C     KLCuAh        KLIST
     C                   KFLD                    KFCust
     C                   KFLD                    KFFrntOffc
      *
      ** Check if an existing DBU_CUAH job is active in the subsystem
      *
     C                   CALL      'SCC0520'
     C                   PARM                    LockObj
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Endjob
     C                   PARM                    Return
      *
      ** Lock allocation data area
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
      *
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2010
