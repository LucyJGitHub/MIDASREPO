     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GL APR Flag Validation')                         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVAPRF   - Midas GL APR Validation                          *
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

      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)

      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)


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
      ** Warning index
     D WIdx            S              3P 0

     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      ** EXTERNAL DS FOR ADDITIONAL CUSTOMER DETAILS

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
     C                   MoveL     *Blanks       FldNamXAr
     C                   MoveL     *Blanks       MsgIDXAr
     C                   MoveL     *Blanks       MsgDtaXAr
     C                   Z-Add     0             Idx
     C                   Z-Add     0             WIdx
      *
      **  APR Flag must be Y or N
     C                   IF        DDAPRC <> 'Y' AND DDAPRC <> 'N'
     C                             AND DDAPRC <> *Blank
     C                   Move      'N'           DDAPRCOK
     C                   Add       1             Idx
     C                   MoveL     'DDAPRC'      FldNamXAr(Idx)
     C                   MoveL     'GLX0460'     MsgIDXAr(Idx)
     C                   ENDIF

      **  Default APR Flag if blank
     C                   IF        DDAPRC =  *Blanks
     C                   Exsr      SRVAPRF
     C                   else
      *
     C                   IF        DDAPRC =  'Y' or DDAPRC = 'N'
     C                   Exsr      SRVAPRF2
     C                   ENDIF
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDAPRCOK      IfEq      'N'
     C                   Eval      RetCodeIn = 'Error'
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
     C                   Parm                    DDCUSN            6
     C                   Parm                    DDAPRC            1
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    Idx
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    WIdx
      *
      ** APR Flag - Ok
     C                   Parm                    DDAPRCOk          1
      *
      *
      *  Check system value
     C                   Eval      P@OP01 = 'APRRetailAccounts'
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
      *
      **  DBASE Error if APR Retail Accounts system value not found
     C                   IF        P@RTCD <> *Blank
     C     *LOCK         IN        LDA
     C                   Z-ADD     3             DBASE
     C                   MOVE      'SDSVALPD'    DBFILE
     C                   MOVE      'GLVAPRF  '   DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SRVAPRF - Default APR Flag
      *****************************************************************
     C     SRVAPRF       BEGSR

     C                   IF        P@VL01 = 'N'
     C                   Eval      DDAPRC = 'N'

     C                   Else
      *
     C/exec SQL
     C+ select *
     C+ into :SDACUS
     C+ from SDACUSPD
     C+ where E5CUST = :DDCUSN
     C/end-exec

     C     SQLCOD        Ifeq      0
     C     E5APRC        andne     *Blanks
     C                   Eval      DDAPRC = E5APRC
     C                   Else
      **  Customer Additional details not found
     C                   Eval      DDAPRC = 'Y'
     C                   Endif
     C                   EndIf
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SRVAPRF2 - Validate APR flag against Customer's and sys value
      *****************************************************************
     C     SRVAPRF2      BEGSR

     C                   IF        P@VL01 = 'N'

     C                   If        DDAPRC = 'Y'
     C                   Move      'W'           DDAPRCOK
     C                   Add       1             WIdx
     C                   EVAL      WFldNmXAr(WIdx) = 'DDAPRC'
     C                   EVAL      WMsgIDXAr(WIdx) = 'GLX0461'
     C                   Endif

     C                   Else
      *
     C/exec SQL
     C+ select *
     C+ into :SDACUS
     C+ from SDACUSPD
     C+ where E5CUST = :DDCUSN
     C/end-exec

     C     SQLCOD        Ifeq      0
     C     E5APRC        andeq     'N'
     C     DDAPRC        andeq     'Y'
     C     SQLCOD        Oreq      0
     C     E5APRC        andeq     'Y'
     C     DDAPRC        andeq     'N'
     C     SQLCOD        Oreq      0
     C     E5APRC        andeq     *Blanks
     C     DDAPRC        andeq     'N'
     C     SQLCOD        Orne      0
     C     DDAPRC        andeq     'N'
     C                   Move      'W'           DDAPRCOK
     C                   Add       1             WIdx
     C                   EVAL      WFldNmXAr(WIdx) = 'DDAPRC'
     C                   EVAL      WMsgIDXAr(WIdx) = 'GLX0462'
     C                   Endif

     C                   EndIf
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
