     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Conversion - Start Date')                *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVSTVL - Validate Start Date                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD020029           Date 12Apr13               *
      *  Prev Amend No. CLE134   *CREATE   Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD020029 - Fees transactions went into repair queue          *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
      ** Establish the transaction type
     D RecordType      S              1A
     DLoan             C                   CONST('1')
     DFeeLoan          C                   CONST('2')
     DFeeFacility      C                   CONST('3')
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *
      ** Additional Field Definitions
     D WSDAT           S              6
     D DateIn          S              6
     D DaynoOut        S              5  0
     D DateFormat      S              1
     D ErrorFlag       S              1
     D ZDate           S              6  0
     D Filler          S              7
     D DDSDAT          S              6
     D WSTDT           S              5  0
     D WENDT           S              5  0
     D BJDFIN          S              1
     D BJRDNB          S              5  0
     D NSDAT           S              5  0
     D DDSDATOK        S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
      *
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             NSDAT
      *
      ** VALIDATION
      *
      ** Value Date of Change
      *
     C                   IF        CobMode  <> 'Y'                                          MD020029
     C                   IF        DDSDAT <> *BLANKS
      *
     C                   MOVE      DDSDAT        WSDAT
     C                   TESTN                   WSDAT                9798
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      DDSDAT        DateIn
     C                   PARM                    DaynoOut
     C                   PARM      BJDFIN        DateFormat
     C                   PARM                    ErrorFlag
      *
     C                   IF        ErrorFlag = 'Y'
     C                             OR *IN97 = *OFF
     C                             AND *IN98 = *OFF
     C                   EVAL      DDSDATOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSDAT'
     C                   EVAL      MsgIdXAr(Idx) = '5045782'
     C                   GOTO      EMAIN
     C                   ELSE
     C                   EVAL      NSDAT = DaynoOut
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   EVAL      NSDAT = BJRDNB
      *
     C                   CALLB     'ZDATE2'                             H1
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM                    ZDate
     C                   PARM                    Filler
      *
     C                   MOVE      ZDate         DDSDAT
      *
     C                   ENDIF
     C                   ENDIF                                                              MD020029
      *
      ** Data must be within the range
      *
     C                   IF        CobMode  <> 'Y'                                          MD020029
     C                   IF        NSDAT < WSTDT
     C                             AND DDSDATOK = 'Y'
     C                             OR NSDAT > WENDT
     C                             AND DDSDATOK = 'Y'
     C                   EVAL      DDSDATOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSDAT'
     C                   IF        RecordType = Loan
     C                   EVAL      MsgIdXAr(Idx) = '5045627'
     C                   ELSE
     C                   EVAL      MsgIdXAr(Idx) = '5045628'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                              MD020029
      *
     C     EMAIN         TAG
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
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
     C                   PARM                    DDSDAT
     C                   PARM                    WSTDT
     C                   PARM                    WENDT
     C                   PARM                    RecordType
     C                   PARM                    BJDFIN
     C                   PARM                    BJRDNB
      *
      ** OUTPUTS
      *
     C                   PARM                    NSDAT
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Value Date - OK
      *
     C                   PARM                    DDSDATOK
     C                   PARM                    CobMode           1                        MD020029
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
