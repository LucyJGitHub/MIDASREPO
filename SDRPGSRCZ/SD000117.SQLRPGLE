     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Submit ARR Calculator Batch Job')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000117 - Midas SD Submit ARR Calculator Batch Job          *
      *                                                               *
      *  Function:  This program is called from a menu item to        *
      *             submit the ARR Calculator Batch Job (ARRCALC_zz)  *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CSD103  *CREATE    Date 10Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  USE OF INDICATORS                                            *
      *                                                               *
      *    U7         Database error                                  *
      *    U8         Database error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  SUBROUTINE INDEX                                             *
      *                                                               *
      * *INZSR       - Program Initialisation routine                 *
      * *PSSR        - Error processing                               *
      *                                                               *
      *****************************************************************

      *****************************************************************
      /EJECT
      *****************************************************************

     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** Data Sructure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Short Data Structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Data Structure for System Prefix
     D SDSTAT        E DS           256    EXTNAME(SDSTAT) DTAARA(SDSTAT)
     D  SYSID                  6      7

      ** Parameters for calling SD000907 program
     D APIRetC         S              1A
     D MsgArr          S           9999A   VARYING

      ** Prototype for QCMDEXC
     D RunSysCmd       PR                  EXTPGM('QCMDEXC')
     D  Cmd                         150A   OPTIONS(*VARSIZE) CONST
     D  Cmdlen                       15P 5 CONST

      ** Program Entry Parameters
     D PRunAgain       S              1A
     D PReturnCode     S             10A

      ** Parameters for calling access programs
     D PRtCd           S              7A
     D POptn           S              7A

      ** Program Variables
     D WRUN            S              1A
     D WStatus         S              1A
     D WStartDate      S              5S 0
     D WJobName        S             10A
     D WCommand        S            150A

      *****************************************************************
      /EJECT
      *****************************************************************

      ** MAIN PROCESSING
      ** Setup Library List
     C                   CALL      'SD000907'
     C                   PARM      *BLANKS       MsgArr
     C                   PARM      *BLANKS       APIRetC
     C                   PARM                    SYSID

     C                   IF        APIRetC = '0' and
     C                             MsgArr <> *BLANKS
     C                   EVAL      DBFILE = 'SD000907'
     C                   EVAL      DBKEY  = 'SD000907'
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check the Status File
     C/exec SQL
     C+ select SDSTAT, SDSTDT into :WStatus, :WStartDate
     C+ from SDCSTSTD where SDZONE = :SYSID
     C/end-exec

      ** End program if SQL read fails
     C                   IF        SQLCODE <> 0 and
     C                             SQLCODE <> 100
     C                   EVAL      DBFILE = 'SDCSTSTD'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 003
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set returncode to COMPLETED if ARR Calculator Batch Job
      ** is requested again in same Input Cycle
     C                   IF        SQLCODE <> 100 and
     C                             WStatus = 'C' and
     C                             WStartDate = BJRDNB and
     C                             PRunAgain = *BLANK
     C                   EVAL      PReturnCode = 'COMPLETED '
     C                   EXSR      SREndProgram
     C                   ENDIF

      ** Set returncode to RUNNING if ARR Calculator Batch Job
      ** is already running (i.e. DTAARA/SDARRCLCK is allocated)
      /free
        WCommand = 'ALCOBJ OBJ((SDARRCLCK *DTAARA *EXCL)) WAIT(0)';
      /end-free
     C                   CALLP(E)  RunSysCmd(WCommand: %len(WCommand))
     C                   IF        %Error = *ON
     C                   IF        PSExcpType = 'CPF' and
     C                             PSExcpNo = '1002'
     C                   EVAL      PReturnCode = 'RUNNING   '
     C                   EXSR      SREndProgram
     C                   ELSE
     C                   EVAL      DBFILE = 'QCMDEXC'
     C                   EVAL      DBKEY  = 'QCMDEXC ERROR'
     C                   EVAL      DBASE  = 004
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

      /free
        WCommand = 'DLCOBJ OBJ((SDARRCLCK *DTAARA *EXCL))';
      /end-free
     C                   CALLP(E)  RunSysCmd(WCommand: %len(WCommand))
     C                   IF        %Error = *ON
     C                   EVAL      DBFILE = 'QCMDEXC'
     C                   EVAL      DBKEY  = 'QCMDEXC ERROR'
     C                   EVAL      DBASE  = 005
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Submit ARR Calculator Batch Job
      /free
        WJobName = 'ARRCALC_' + SYSID;
        WCommand = 'SBMJOB JOB(' + %trim(WJobName) +') '
                 + 'JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) '
                 + 'RQSDTA(''CALL SDC000114'') '
                 + 'INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)';
      /end-free
     C                   CALLP(E)  RunSysCmd(WCommand: %len(WCommand))
     C                   IF        %Error = *ON
     C                   EVAL      DBFILE = 'QCMDEXC'
     C                   EVAL      DBKEY  = 'QCMDEXC ERROR'
     C                   EVAL      DBASE  = 006
     C                   EXSR      *PSSR
     C                   ENDIF

      ** End program
     C                   EXSR      SREndProgram

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREndProgram - Subroutine to end the program                  *
      *                                                               *
      *****************************************************************
     C     SREndProgram  BEGSR

     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Entry Parameters
     C     *ENTRY        PLIST
     C                   PARM                    PRunAgain
     C                   PARM                    PReturnCode

      ** Initialize Work fields
     C                   EVAL      DBPGM = 'SD000117'
     C                   EVAL      PReturnCode = *BLANKS

      ** Retrieve System ID
     C     *LOCK         IN        SDSTAT
     C                   OUT       SDSTAT

      ** Get the Bank details via access program
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      PReturnCode = 'ERROR     '
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
