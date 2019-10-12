     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas MM APR Flag Validation')                         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  MMVAPRF   - Midas MM APR Validation                          *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CER050  *Create    Date 16Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

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

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Midas SD Additional customer details
     D SDACUS        E DS                  EXTNAME(SDACUSPD)

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure

      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MsgID)

      ** Warning message ID
     D WMsgID1         S                   LIKE(#MsgID)
     D DFTAprC         S              1


      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *
     D P@VL01          DS           200
     D  SVAL11                 1      1

     D P@FMT         E DS                  EXTNAME(DSLDY)
      ** External Data structure to hold the outgoing record format of
      ** the file.

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Initialization

     C                   MoveL     *Blanks       RetCodeIn

      ** Reset the error flag to prevent problems on subsequent calls
     C                   Move      *Blanks       ErrorFound
     C                   Move      *Blanks       WarnFound
     C                   Move      *Blanks       Msgid1
     C                   Move      *Blanks       WMsgID1
      * Check if deal is deposit/loan
     C                   IF        DDTYPE = 'IT' or
     C                             DDTYPE = 'TD' or
     C                             DDTYPE = 'CI' or
     C                             DDTYPE = 'CD' or
     C                             DDTYPE = 'IP' or
     C                             DDTYPE = 'TI' or
     C                             DDTYPE = 'CL' or
     C                             DDTYPE = 'LN' or
     C                             DDTYPE = 'DL'
      *
      **  APR Flag must be Y or N
     C                   IF        DDAPRC <> 'Y' AND DDAPRC <> 'N'
     C                             AND DDAPRC <> *Blank
     C                   MOVE      'Y'           ErrorFound
     C                   MoveL     'MMX0460'     Msgid1
     C                   ENDIF

     C     ErrorFound    Ifne      'Y'
      **  Get Default APR Flag and validate
     C                   Exsr      SRVAPRF
     C                   EndIf
      *
      ** If an error was found, set the return code appropriately
      *
     C     ErrorFound    IfEq      'Y'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *Entry        Plist
      *
      ** INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** APR Screen fields
     C                   Parm                    DDAPRC            1
     C                   Parm                    DDCUSN            6
     C                   Parm                    DDTYPE            2
     C                   Parm                    DDSTYP            2
     C                   Parm                    DDACTN            1
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    MsgID1
     C                   PARM                    WMsgid1
      *
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SRVAPRF - Validate APR Flag
      *****************************************************************
     C     SRVAPRF       BEGSR
      *
     C                   Eval      DFTAPRC = 'N'

     C                   Eval      P@OP01 = *Blanks
      * Check if deal is deposit
     C                   IF        DDTYPE = 'IT' or
     C                             DDTYPE = 'TD' or
     C                             DDTYPE = 'CI' or
     C                             DDTYPE = 'CD'
     C                   Eval      P@OP01 = 'APRMMDeposits'
     C                   ENDIF

      * Check if deal is deposit
     C                   IF        DDTYPE = 'IP' or
     C                             DDTYPE = 'TI' or
     C                             DDTYPE = 'CL' or
     C                             DDTYPE = 'LN' or
     C                             DDTYPE = 'DL'
     C                   Eval      P@OP01 = 'APRMMLoans'
     C                   ENDIF
      *
     C                   IF        P@OP01 <> *Blanks
     C                   CALL      'AOSVALR0'
     C                   PARM                    P@RTCD            7
     C                   PARM                    P@OP01           20
     C                   PARM                    P@VL01          200
     C                   PARM                    P@OP02           20
     C                   PARM                    P@VL02          200
     C                   PARM                    P@OP03           20
     C                   PARM                    P@VL03          200
     C                   PARM                    P@OP04           20
     C                   PARM                    P@VL04          200
     C                   PARM                    P@OP05           20
     C                   PARM                    P@VL05          200
     C                   PARM                    P@OP06           20
     C                   PARM                    P@VL06          200
     C                   PARM                    P@OP07           20
     C                   PARM                    P@VL07          200
     C                   PARM                    P@OP08           20
     C                   PARM                    P@VL08          200
     C                   PARM                    P@OP09           20
     C                   PARM                    P@VL09          200
     C                   PARM                    P@OP10           20
     C                   PARM                    P@VL10          200
     C                   ENDIF
      *
     C                   IF        P@RTCD = *Blank
     C                   IF        P@VL01 = 'Y'
      *
     C/exec SQL
     C+ select *
     C+ into :SDACUS
     C+ from SDACUSPD
     C+ where E5CUST = :DDCUSN
     C/end-exec

     C     SQLCOD        Ifeq      0
     C     E5APRC        andne     *Blanks
     C                   Eval      DFTAPRC = E5APRC
     C                   Else
      **  Customer Additional details not found
     C                   Eval      DFTAPRC = 'Y'
     C                   Endif

      **  APR Flag entered different from customer default
     C                   If        DDAPRC <> DFTAPRC
     C                             and DDAPRC <> *Blanks
     C                   Eval      WarnFound = 'Y'
     C                   Eval      RetCodeIn = 'Warning'
     C                   Movel     'MMX0462'     WMsgID1
     C                   Endif

     C                   Else
      **  APR Flag entered different from default
     C                   If        DDAPRC = 'Y'
     C                   Eval      WarnFound = 'Y'
     C                   Eval      RetCodeIn = 'Warning'
     C                   Movel     'MMX0461'     WMsgID1
     C                   Endif
     C                   Endif
      *
     C                   ELSE
      **  DBASE Error if APR Retail Accounts system value not found
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVE      'SDSVALPD'    DBFILE
     C                   MOVE      'MMVAPRF  '   DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Default APR flag if blank
     C                   If        DDAPRC = *Blanks and
     C                             DDACTN = 'I'
     C                   Eval      DDAPRC = DFTAPRC
     C                   Endif
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILEB
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2016
