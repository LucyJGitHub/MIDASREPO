     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Nostro Transfer Retrieve')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTFTNTRTV - Midas FT Nostro Transfer Retrieve                *
      *              (WITH ACTION CODE VERSUS TRANSFER REF VALIDATION)*
      *                                                               *
      *  Function:  This module retrieves a transaction from          *
      *             the database. As it does so, it validates the     *
      *             action code and rransfer reference.               *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP212  *CREATE    Date 15Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP212 - FT Nostro Transfer API                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FNTRAN     IF   E           K DISK    INFSR(*PSSR)
      * Transaction File by Transfer Reference
 
     FNTRANL0   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(NTRANDDF:NTRANFOI)
      * Transaction File by Front Office Id
 
     FMUSER     IF   E           K DISK    INFSR(*PSSR)
      * Midas Users
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details ICD retrieval
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D TranFilFmt    E DS                  EXTNAME(NTRANDD)
      ** Transaction Details in File Format
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D ZMUSER          DS
     D  USERID                 1     10
     D  DBRN                  11     13
     D  BANK                  17     17
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
     D TRNSRF          S             15
     D ZACTN           S              1
     D ZBR             S              3
     D ERR             S              1  0
     D ModeofOp        S              6
     D RespMode        S              1
     D ACTION          S              1
     D FRONT           S             20
     D PTRNSRF         S             15
     D OKACTN          S              1
     D OKTFRF          S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      * Initialisation
     C                   EVAL      TRNSRF = PTRNSRF
     C                   EXSR      INIT
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
     C                   IF        RespMode = 'S'
     C                   EVAL      ZACTN = ACTION
      *
      ** Check user authority to action code
     C                   IF        @MBIN = 'Y'
     C                   EXSR      ACSSEM
     C                   ELSE
     C                   EXSR      ACSSES
     C                   ENDIF
      *
      **  Carry out no further validation if errors have occurred.
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
      *
      * If the mode is 'Front Office Transaction Interface'
      * Do (Extra) Validation for Front Office Transaction Interface
     C                   IF        ModeofOp = '*FRONT'
     C                   EXSR      VFRNT
      *
      **  Carry out no further validation if errors have occurred.
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
      *
      * Validate Action Code & Transfer Reference
     C                   EXSR      VAL
 
      * Return
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initial processing
      *****************************************************************
     C     INIT          BEGSR
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      * Clear Outputs
     C                   CLEAR                   TranFilFmt
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKTFRF = 'Y'
 
     C                   ENDSR
      ********************************************************************
     C/EJECT
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
      *
      **  Check user's authority for the action & Booking Branch.
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN
     C                   PARM      DBRN          ZBR
     C                   PARM                    ERR
      *
      **   If action invalid for user
     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'NTACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0290'     MsgIdArr(Ix)
     C                   ELSE
     C                   IF        ERR = 2
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'ACTION'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      ACTION='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      ACTION='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      ACTION='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      ACTION='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
      *
      **  Check user's authority for the action.
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN
     C                   PARM                    ERR
      *
      **  If action invalid for user
     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'NTACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      ACTION='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      ACTION='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      ACTION='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      ACTION='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - Validation for Front Office Transaction Interface
      *****************************************************************
     C     VFRNT         BEGSR
      *
      * Error if Front Office Transaction ID is Blank
     C                   IF        FRONT = *BLANK
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'NTACTN'      FldNameArr(Ix)
     C                   MOVEL     '5047411'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      * Access Transaction with Front Office Transaction ID
     C     FRONT         CHAIN     NTRANL0                            99
      *
      * If Insert
      *
     C                   IF        ACTION = 'I'
      *
      * Front Office Transaction ID can't be Present already
     C                   IF        *IN99 = *OFF
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'NTACTN'      FldNameArr(Ix)
     C                   MOVEL     '5047412'     MsgIdArr(Ix)
     C                   MOVEL     FRONT         MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ELSE
      *
      * If not insert, Front Office Transaction ID Must be Present
     C                   IF        *IN99 = *ON
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'NTACTN'      FldNameArr(Ix)
     C                   MOVEL     '5047413'     MsgIdArr(Ix)
     C                   MOVEL     FRONT         MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - Validation of Action Code and Transfer Reference
      *****************************************************************
     C     VAL           BEGSR
      *
      * Action Code must be 'I','A','D', or 'E'
     C                   IF        ACTION <> 'I' AND
     C                             ACTION <> 'A' AND
     C                             ACTION <> 'D' AND
     C                             ACTION <> 'E'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'NTACTN'      FldNameArr(Ix)
     C                   MOVEL     '5047414'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      * Transfer reference must be blank if in insert mode
     C                   IF        ACTION = 'I' AND
     C                             TRNSRF <> *BLANKS
     C                   MOVEL     'N'           OKTFRF
     C                   ADD       1             Ix
     C                   MOVEL     'NTTFRF'      FldNameArr(Ix)
     C                   MOVEL     '5047415'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      * Transfer reference is mandatory if not in insert mode
     C                   IF        ACTION <> 'I' AND
     C                             TRNSRF = *BLANKS
     C                   MOVEL     'N'           OKTFRF
     C                   ADD       1             Ix
     C                   MOVEL     'NTTFRF'      FldNameArr(Ix)
     C                   MOVEL     '5047416'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      * Transfer reference must exist
     C                   IF        ACTION <> 'I'
 
     C     TRNSRF        CHAIN     NTRAN                              99
     C                   IF        *IN99 = *ON
     C                   MOVEL     'N'           OKTFRF
     C                   ADD       1             Ix
     C                   MOVEL     'NTTFRF'      FldNameArr(Ix)
     C                   MOVEL     '5047417'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
 
     C                   ENDIF
      *
      * For action codes 'A' and 'D' - must be live and not authorised.
     C                   IF        ACTION = 'A' OR
     C                             ACTION = 'D'
 
     C                   IF        RECI <> 'D' OR
     C                             AUIN = 'Y'
     C                   MOVEL     'N'           OKTFRF
     C                   ADD       1             Ix
     C                   MOVEL     'NTTFRF'      FldNameArr(Ix)
     C                   MOVEL     '5047418'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
 
     C                   ENDIF
 
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initialisation
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Parameters
     C     *ENTRY        PLIST
 
      * Inputs
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp
      *
      * Response mode
     C                   PARM                    RespMode
      *
      * Action Code
     C                   PARM                    ACTION
      *
      * Front Office Transaction ID
     C                   PARM                    FRONT
      *
      * (Midas) Transaction number
     C                   PARM                    PTRNSRF
      *
      * Outputs
      *
      * Transaction Details in File Format
     C                   PARM                    TranFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN
      *
      * OK - Transaction Number
     C                   PARM                    OKTFRF
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** Initialise program name
     C                   EVAL      DBPGM = 'FTFTNTRTV'
      *
      **  GET RUNDAT to access MULTI-BRANCHING flag.
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'                           ************
     C                   EVAL      DBASE  = 900                                  * DBERR 900*
     C                   EVAL      DBKEY = @Optn                                 ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
 
      *  Note: if non-standard processing required, use the PSSR_ILENE
      *  subroutine
      ****************************************************************
