     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('sedas SE Statmts Prod. Requests - Database update')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SESTPRUPD - Statement Production Requests - D.B.Update *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE040  *CREATE    Date 25Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSESTPRL0  UF A E           K DISK    COMMIT INFSR(*PSSR)
      ** Midas SE Statement Production Request - Main key
 
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
 
     D NewSEStPR     E DS                  EXTNAME(SEVSTPRPD)
      ** New Statement Production Request in file format
 
     D SESTPR        E DS                  EXTNAME(SESTPRPD)
      ** Statement Production Request record layout
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data structure for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for access programs, long data structure
 
      ** Split up of the Statement Production Request Reference
     D DDStPRRef       DS
      ** -- Main key (used in SIN and UPD function)
     D  DDDATE                        6A
     D  DDRSEQ                        7A
      ** -- Alternative key (used in CTL & RPR functions)
     D  DDCUST                        6A
     D  DDTYPE                        2A
     D  DDSNDR                        3A
     D  DDRECP                       11A
     D  DDFREQ                        1A
 
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
     C                   IF        @@RtCd <> *Blanks
     C                   GOTO      Exit
     C                   ENDIF
      *
      ** Insert, Amend, Authorise or Delete the Request
      *
     C     DDACTN        CASEQ     'I'           Insert
     C     DDACTN        CASEQ     'A'           AmdDel
     C     DDACTN        CASEQ     'X'           AmdDel
     C     DDACTN        CASEQ     'D'           AmdDel
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
      ** Set up the Midas Reference of the Request (DDStPRRef)
      *
     C                   CLEAR                   DDStPRRef
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      VSPDATE       ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
     C                   MOVE      ZDATE         DDDATE
     C                   MOVE      VSPRSEQ       DDRSEQ
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
     C                             DDACTN  = 'I' AND
     C                             VSPFRNT <> *BLANKS
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
     C                             DDACTN  = 'I'
     C                   EVAL      ModeofOp = '*FRONT'
     C                   ELSE
     C                   EVAL      ModeofOp = *Blanks
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Call the Retrieve module
      *------------------
     C                   CALLB     'SESTPRRTV'
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
     C                   PARM                    DDACTN
      ** Front Office Transaction ID
     C                   PARM      VSPFRNT       FOTRID           20
      ** (Midas) Statement Production Request Reference
     C                   PARM                    DDStPRRef
      *
      ** OUPUT PARAMETERS
      ** Transaction Details in File Format
     C                   PARM                    SESTPR
      ** OK - Action code and first key field of the request reference
     C                   PARM                    DDACTNOK          1
     C                   PARM                    DDDATEOK          1
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      *------------------
      ** Error if Timestamp is not the same (record has been changed
      **  by another workstation)
      *
      ** Processing varies according to mode program is running in.
      ** In interactive mode simply check whether the timestamp field
      ** has been updated since the original record was fetched
      ** by the SIN or RPR module.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.
      *
      ** Interactive mode:
      *
     C                   IF        @Type = '1'
 
     C                   IF        SPTMST <> VSPTMST
     C                   EVAL      @@RtCd = '*RECUPD'
     C                   ENDIF
      *
      ** Batch mode:
      *
     C                   ELSE
      *
     C                   IF        DDACTNOK = 'N' OR
     C                             DDDATEOK = 'N'
     C                   EVAL      @@RtCD = '*RECUPD'
     C                   EVAL      DBError = %Char(Ix) + ' update errors for ' +
     C                                       'transaction reference ' + VSPFRNT
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
      * Insert - Insert a Statement Production Request
      ****************************************************************
     C     Insert        BEGSR
      *
      ** Look for the next available sequence number for the same
      ** Transaction/Type/Date (the sequence number is initialized
      ** to 999 by the VAL module)
      *
     C     KSESTPRL0_1   SETGT     SESTPRD0
     C     KSESTPRL0_2   READPE(N) SESTPRD0                               99
      *
     C                   IF        *IN99
     C                   EVAL      VSPRSEQ = 0
     C                   ELSE
      *
     C                   IF        SPRSEQ < 9999999
     C                   EVAL      VSPRSEQ = SPRSEQ + 1
     C                   ELSE
      *
      ** Database error
      *
     C                   IF        @Type = '1'
     C     *LOCK         IN        LDA
     C                   ENDIF
      *
     C                   EVAL      DBKEY  = %Char(VSPDATE) +
     C                                      '9999999: Highest Seq.'
     C                   EVAL      DBFILE = 'SESTPRPD'
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
     C                   MOVE      NewSEStPR     SESTPR
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    SPTMST
      ** Last Change Date
     C                   EVAL      SPLCD  = BJRDNB
      ** Last Change User
     C                   EVAL      SPUSER = PSUser
      *
      ** Write a new Request record
      *
     C                   WRITE     SESTPRD0
      *
      ** Call the statement generation if Action Code = 'X'
      *
     C                   IF        SPCHTP = 'X'
     C                   CALL      'SEC4650'
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * AmdDel - Amend/Authorise/Logically delete a Statement Production Request
      ****************************************************************
     C     AmdDel        BEGSR
      *
      ** Access the record
      *
     C     KSESTPRL0_1   CHAIN     SESTPRD0                           99
      *
      ** Database error
      *
     C                   IF        *IN99
      *
     C                   IF        @Type = '1'
     C     *LOCK         IN        LDA
     C                   ENDIF
      *
     C                   EVAL      DBKEY  = %Char(VSPDATE) + %Char(VSPRSEQ) +
     C                                      ': Not Found'
     C                   EVAL      DBFILE = 'SESTPRPD'
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
     C                   MOVE      NewSEStPR     SESTPR
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    SPTMST
      ** Last Change Date
     C                   EVAL      SPLCD  = BJRDNB
      ** Last Change User
     C                   EVAL      SPUSER = PSUser
      *
      ** Update the Request record
      *
     C                   UPDATE    SESTPRD0
      *
      ** Call the statement generation if Action Code = 'X'
      *
     C                   IF        SPCHTP = 'X'
     C                   CALL      'SEC4650'
     C                   ENDIF
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
     C                   PARM                    @@RtCd            7
      ** Real Action Code
     C                   PARM                    DDACTN            1
      ** Externally described DS for valid Transaction Detail
     C                   PARM                    NewSEStPR
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      ** Klist's
      *
     C     KSESTPRL0_1   KLIST
     C                   KFLD                    VSPDATE
     C                   KFLD                    VSPRSEQ
      *
     C     KSESTPRL0_2   KLIST
     C                   KFLD                    VSPDATE
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
     C                   MOVEL (P) '*ERROR'      @@RtCd
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
