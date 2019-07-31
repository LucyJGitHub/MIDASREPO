     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Movements Status - Database update')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEMVTSUPD - Movements Status - Database Update         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE039  *CREATE    Date 19Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE039 - Automatic Settlement of Trades                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEMVTSL0  UF A E           K DISK    COMMIT INFSR(*PSSR)
      ** Midas SE Movements Status - Main Key
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ValidMVTS     E DS                  EXTNAME(SEVMVTSPD)
      ** Valid Movement Status record layout
 
     D SEMVTS        E DS                  EXTNAME(SEMVTSPD)
      ** Movement Status record layout
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data structure for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for access programs, long data structure
 
 
      ** Split up of the Movement Reference
     D DDMvtRef        DS
     D  DDTRRF                        6A
     D  DDTRTY                        1A
     D  DDNTDT                        6A
     D  DDSQNR                        3S 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Dummy message ID and message file fields for ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S                   LIKE(#MsgFile)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ subroutine is executed at program activation.              ¦
      ** +------------------------------------------------------------+
      *
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
      *
     C                   EXSR      ChkOthUpd
      *
     C                   IF        @@RTCD <> *Blanks
     C                   GOTO      Exit
     C                   ENDIF
      *
      ** Insert, Amend or Delete the Movement
      *
     C     VTMLCTP       CASEQ     'I'           Insert
     C     VTMLCTP       CASEQ     'A'           AmdDel
     C     VTMLCTP       CASEQ     'D'           AmdDel
     C                   ENDCS
      *
      * Exit From Program
      *
     C     Exit          TAG
      *
     C                   RETURN
      *
      ****************************************************************
      /EJECT
      *****************************************************************
      * ChkOthUpd - Check for update by another workstation
      *****************************************************************
     C     ChkOthUpd     BEGSR
      *
      ** Set up the Midas Reference of the Movement Status (DDMvtRef)
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      VTMNTDT       ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
     C                   EVAL      DDTRRF = VTMTRRF
     C                   EVAL      DDTRTY = VTMTRTY
     C                   MOVE      ZDATE         DDNTDT
     C                   EVAL      DDSQNR = VTMSQNR
      *
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @Type             1
      *
      ** Allow access to transaction record by Front-Office ID when in Repair
      ** mode for inserts . Set  *RTV module  parameter ModeofOp to *FRONT
      ** if the pgm is:  a) running in Interactive mode - @Type= 1
      **                 b) action code is Insert - 'I'
      **                 c) Front-Office Id is NOT Blank
      *
     C                   IF        @Type   = '1' AND
     C                             VTMLCTP = 'I' AND
     C                             VTMFRNT <> *BLANKS
      *
     C                   EVAL      ModeofOp = '*FRONT'
      *
      ** Otherwise, if running in batch use Front-Office ID
      **            (if insert)
      **            else, use Midas Reference
      *
     C                   ELSE
      *
     C                   IF        @Type   = '0' AND
     C                             VTMLCTP = 'I'
     C                   EVAL      ModeofOp = '*FRONT'
     C                   ELSE
     C                   EVAL      ModeofOp = *Blanks
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Call the Retrieve module
      *
     C                   CALLB     'SEMVTSRTV'
      *
      ** INPUT PARAMETERS
      ** Return code
     C                   PARM      *Blanks       RetCodeOut
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      ** Response mode (No SPF authorization check)
     C                   PARM      *Blank        RespMode          1
      ** Action Code
     C                   PARM      VTMLCTP       DDACTN            1
      ** Front Office Transaction ID
     C                   PARM      VTMFRNT       FOTRID           20
      ** (Midas) Movement Reference
     C                   PARM                    DDMvtRef
      *
      ** INPUT/OUPUT PARAMETERS
      ** Booking Branch of the linked Transaction (trade or DPMV)
      ** (no need to pass it, as we don't ask for SPF checking)
     C                   PARM      *Blank        P@BRCA            3
      *
      ** OUPUT PARAMETERS
      ** Transaction Details in File Format
     C                   PARM                    SEMVTS
      ** OK - Action code and first key field of the movement reference
     C                   PARM                    DDACTNOK          1
     C                   PARM                    DDTRRFOK          1
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM      0             Ix                3 0
      *------------------
      ** Error if Timestamp is not the same (record has been changed
      **  by another workstation)
      *
      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original record was fetched
      ** by the SIN or RPR module.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.
      *
      ** Interactive mode:
      *
     C                   IF        @Type = '1'
 
     C                   IF        TMTMST <> VTMTMST
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF
      *
      ** Batch mode:
      *
     C                   ELSE
      *
     C                   IF        DDACTNOK = 'N' OR
     C                             DDTRRFOK = 'N'
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   EVAL      DBError = %Char(Ix) + ' update errors for ' +
     C                                       'transaction reference ' + VTMFRNT
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError         132
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      * Insert - Insert a Movement Status record
      ****************************************************************
     C     Insert        BEGSR
      *
      ** Look for the next available sequence number for the same
      ** Transaction/Type/Date (the sequence number is initialized
      ** to 999 by the VAL module)
      *
     C     KSEMVTSL0_1   SETLL     SEMVTSD0
     C     KSEMVTSL0_2   READE (N) SEMVTSD0                               99
      *
     C                   IF        *IN99
     C                   EVAL      VTMSQNR = 0
     C                   ELSE
      *
     C                   IF        TMSQNR < 999
     C                   EVAL      VTMSQNR = TMSQNR + 1
     C                   ELSE
      *
      ** Database error
      *
     C                   IF        @Type = '1'
     C     *LOCK         IN        LDA
     C                   ENDIF
      *
     C                   EVAL      DBKEY  = VTMTRRF + VTMTRTY + %Char(VTMNTDT) +
     C                                      '999: Highest Seq.'
     C                   EVAL      DBFILE = 'SEMVTSPD'
     C                   EVAL      DBASE  = 001
      *
     C                   IF        @Type = '1'
     C                   OUT       LDA
     C                   ENDIF
      *
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Initialize the record
      *
     C                   MOVE      ValidMVTS     SEMVTS
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TMTMST
      ** Last Change Date
     C                   EVAL      TMLCDT = BJRDNB
      ** Last Change User
     C                   EVAL      TMLCUS = PSUser
      *
      ** Write a new Movement Status record
      *
     C                   WRITE     SEMVTSD0
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * AmdDel - Amend/Logically delete a Movement Status record
      ****************************************************************
     C     AmdDel        BEGSR
      *
      ** Access the record
      *
     C     KSEMVTSL0_1   CHAIN     SEMVTSD0                           99
      *
      ** Database error
      *
     C                   IF        *IN99
      *
     C                   IF        @Type = '1'
     C     *LOCK         IN        LDA
     C                   ENDIF
      *
     C                   EVAL      DBKEY  = VTMTRRF + VTMTRTY + %Char(VTMNTDT) +
     C                                      %Char(VTMSQNR) + ': Not Found'
     C                   EVAL      DBFILE = 'SEMVTSPD'
     C                   EVAL      DBASE  = 002
      *
     C                   IF        @Type = '1'
     C                   OUT       LDA
     C                   ENDIF
      *
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Initialize the record
      *
     C                   MOVE      ValidMVTS     SEMVTS
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TMTMST
      ** Last Change Date
     C                   EVAL      TMLCDT = BJRDNB
      ** Last Change User
     C                   EVAL      TMLCUS = PSUser
      *
      ** Update the Movement Status record
      *
     C                   UPDATE    SEMVTSD0
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Program Parameters
      *
     C     *ENTRY        PLIST
      ** Return Code
     C                   PARM                    @@RTCD            7
      ** Externally described DS for valid Transaction Detail
     C                   PARM                    ValidMVTS
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      ** Klist's
      *
     C     KSEMVTSL0_1   KLIST
     C                   KFLD                    VTMTRRF
     C                   KFLD                    VTMTRTY
     C                   KFLD                    VTMNTDT
     C                   KFLD                    VTMSQNR
      *
     C     KSEMVTSL0_2   KLIST
     C                   KFLD                    VTMTRRF
     C                   KFLD                    VTMTRTY
     C                   KFLD                    VTMNTDT
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RtCd
     C                   PARM      '*FIRST  '    @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        @RtCd <> *Blanks
     C                   EVAL      DBKEY  = @Optn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * SRERR - Exception Errors                                     *
      ****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL (P) '*ERROR'      @@RTCD
     C                   EXSR      *PSSR
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2003
