     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Conversion - Take On Accounts')          *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *          PDCL                                                 *
      *                                                               *
      *  LEVTKAC - Validate Take On Accounts                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. 262373             Date 01Aug12               *
      *  Prev Amend No. CLE134   *CREATE   Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  262373 - Take on account can be in different currency        *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
      *
      ** Accounts File
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
      *
      ** Accounts File - ACNO
     FACCNTL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACCNTABL)
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others)
      ** the LDA layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields
      ** in the  Program Status Data Structures.
      ** They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant
      ** giving the size of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
 
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
      *
      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(LEPDCLPD)
      *
     D WACC            DS
     D  WBRCA                  1      3
     D  WCUST                  4      9
     D  WCCY                  10     12
     D  WACOD                 13     22  0
     D  WACSQ                 23     24  0
     D  WACCT                  1     24
      *
      ** Establish the transaction type
     D RecordType      S              1A
     DLoan             C                   CONST('1')
     DFeeLoan          C                   CONST('2')
     DFeeFacility      C                   CONST('3')
      *
     D WACNO           S             10  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *
      ** Additional Field Definitions
     D NTLPR           S             24
     D NTLIN           S             24
     D NTLFE           S             24
     D DDTLPROK        S              1
     D DDTLINOK        S              1
     D DDTLFEOK        S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------+
      ** ¦                                                ¦
      ** ¦ Initial processing is performed automatically: ¦
      ** ¦ the *INZSR is executed at program activation.  ¦
      ** ¦                                                ¦
      ** +------------------------------------------------+
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
      *
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANKS       NTLPR
     C                   MOVE      *BLANKS       NTLIN
     C                   MOVE      *BLANKS       NTLFE
      *
      ** VALIDATION
      *
      ** Loan Principal
      *
     C                   SELECT
      *
      ** Can be entered only when it is a loan
      *
     C                   WHEN      DDTLPR <> *BLANKS
     C                             AND RecordType <> Loan
     C                   EVAL      DDTLPROK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTLPR'
     C                   EVAL      MsgIdXAr(Idx) = '5045635'
      *
      ** Check it exists
      *
     C                   WHEN      DDTLPR <> *BLANKS
     C                   MOVE      DDTLPR        WACC
     C     KACC          CHAIN     ACCNT
      *
      ** If not found using the full midas account,
      ** use the retail number
      *
     C                   IF        NOT %FOUND
     C                   EVALR     DDTLPR = %TRIM(DDTLPR)
     C                   TESTN                   DDTLPR               9798
     C                   IF        *IN97 = *ON
     C                             OR *IN98 = *ON
     C                   MOVE      DDTLPR        WACNO
     C     KACNO         CHAIN     ACCNTL1
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        NOT %FOUND
     C                             OR RECI <> 'D'
     C                             OR DACC <> 0
     C                   EVAL      DDTLPROK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTLPR'
     C                   EVAL      MsgIdXAr(Idx) = '5045613'
     C                   ELSE
     C                   MOVE      BRCA          WBRCA
     C                   MOVE      CNUM          WCUST
     C                   MOVE      CCY           WCCY
     C                   Z-ADD     ACOD          WACOD
     C                   Z-ADD     ACSQ          WACSQ
     C                   EVAL      NTLPR = WACCT
     C                   EVAL      DDTLPR = WACCT
     C                   ENDIF
 
     C                   ENDSL
 
      ** Check that the take-on CCY matches original Loan's one                               262373
                                                                                              262373
     C                   IF        DDTLPROK = 'Y'                                             262373
     C                             AND DDTLPR <> *BLANKS                                      262373
     C                             AND DDCCY <> WCCY                                          262373
     C                   EVAL      DDTLPROK = 'N'                                             262373
     C                   EVAL      Idx += 1                                                   262373
     C                   EVAL      FldNamXAr(Idx) = 'DDTLPR'                                  262373
     C                   EVAL      MsgIdXAr(Idx) = '5045661'                                  262373
     C                   ENDIF                                                                262373
      *                                                                                       262373
      ** Loan Interest
      *
     C                   SELECT
      *
      ** Can be entered only when it is a loan
      *
     C                   WHEN      DDTLIN <> *BLANKS
     C                             AND RecordType <> Loan
     C                   EVAL      DDTLINOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTLIN'
     C                   EVAL      MsgIdXAr(Idx) = '5045636'
      *
      ** Check it exists
      *
     C                   WHEN      DDTLIN <> *BLANKS
     C                   MOVE      DDTLIN        WACC
     C     KACC          CHAIN     ACCNTABF
      *
      ** If not found using the full midas account,
      ** use the retail number
      *
     C                   IF        NOT %FOUND
     C                   EVALR     DDTLIN = %TRIM(DDTLIN)
     C                   TESTN                   DDTLIN               9798
      *
     C                   IF        *IN97 = *ON
     C                             OR *IN98 = *ON
     C                   MOVE      DDTLIN        WACNO
     C     KACNO         CHAIN     ACCNTL1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        NOT %FOUND
     C                             OR RECI <> 'D'
     C                             OR DACC <> 0
     C                   EVAL      DDTLINOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTLIN'
     C                   EVAL      MsgIdXAr(Idx) = '5045614'
     C                   ELSE
     C                   MOVE      BRCA          WBRCA
     C                   MOVE      CNUM          WCUST
     C                   MOVE      CCY           WCCY
     C                   Z-ADD     ACOD          WACOD
     C                   Z-ADD     ACSQ          WACSQ
     C                   EVAL      NTLIN = WACCT
     C                   EVAL      DDTLIN = WACCT
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** Check that the take-on CCY matches original Loan's one                               262373
      *                                                                                       262373
     C                   IF        DDTLINOK = 'Y'                                             262373
     C                             AND DDTLIN <> *BLANKS                                      262373
     C                             AND DDCCY <> WCCY                                          262373
     C                   EVAL      DDTLINOK = 'N'                                             262373
     C                   EVAL      Idx += 1                                                   262373
     C                   EVAL      FldNamXAr(Idx) = 'DDTLIN'                                  262373
     C                   EVAL      MsgIdXAr(Idx) = '5045793'                                  262373
     C                   ENDIF                                                                262373
      *                                                                                       262373
      ** Fee Principal
      *
     C                   SELECT
      *
      ** Can be entered only when it is not a Loan
      *
     C                   WHEN      DDTLFE <> *BLANKS
     C                             AND RecordType = Loan
     C                   EVAL      DDTLFEOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTLFE'
     C                   EVAL      MsgIdXAr(Idx) = '5045637'
      *
      ** Check it exists
      *
     C                   WHEN      DDTLFE <> *BLANKS
     C                   MOVE      DDTLFE        WACC
     C     KACC          CHAIN     ACCNTABF
      *
      ** If not found using the full midas account,
      ** use the retail number
      *
     C                   IF        NOT %FOUND
     C                   EVALR     DDTLFE = %TRIM(DDTLFE)
     C                   TESTN                   DDTLFE               9798
      *
     C                   IF        *IN97 = *ON
     C                             OR *IN98 = *ON
     C                   MOVE      DDTLFE        WACNO
     C     KACNO         CHAIN     ACCNTL1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        NOT %FOUND
     C                             OR RECI <> 'D'
     C                             OR DACC <> 0
     C                   EVAL      DDTLFEOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTLFE'
     C                   EVAL      MsgIdXAr(Idx) = '5045615'
     C                   ELSE
     C                   MOVE      BRCA          WBRCA
     C                   MOVE      CNUM          WCUST
     C                   MOVE      CCY           WCCY
     C                   Z-ADD     ACOD          WACOD
     C                   Z-ADD     ACSQ          WACSQ
     C                   EVAL      NTLFE = WACCT
     C                   EVAL      DDTLFE = WACCT
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** Check that the take-on CCY matches original Loan's one                               262373
      *                                                                                       262373
     C                   IF        DDTLFEOK = 'Y'                                             262373
     C                             AND DDTLFE <> *BLANKS                                      262373
     C                             AND DDCCY <> WCCY                                          262373
     C                   EVAL      DDTLFEOK = 'N'                                             262373
     C                   EVAL      Idx += 1                                                   262373
     C                   EVAL      FldNamXAr(Idx) = 'DDTLFE'                                  262373
     C                   EVAL      MsgIdXAr(Idx) = '5045794'                                  262373
     C                   ENDIF                                                                262373
      *                                                                                       262373
     C     EMAIN         TAG
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUTS
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
     C                   PARM                    TrnDets
     C                   PARM                    RecordType
      *
      ** OUTPUTS
      *
     C                   PARM                    NTLPR
     C                   PARM                    NTLIN
     C                   PARM                    NTLFE
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** OK values
      *
     C                   PARM                    DDTLPROK
     C                   PARM                    DDTLINOK
     C                   PARM                    DDTLFEOK
      *
     C     KACC          KLIST
     C                   KFLD                    WCUST
     C                   KFLD                    WCCY
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
     C                   KFLD                    WBRCA
      *
     C     KACNO         KLIST
     C                   KFLD                    WACNO
      *
      ** Program, module and procedure names for DB Error processing
      ** ===========================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) MIsys International Banking Systems Ltd. 2012
