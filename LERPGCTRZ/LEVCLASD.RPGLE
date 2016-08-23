     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Conversion - Classification Dates')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVCLASD - Validate Classification Dates                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CLE134   *CREATE   Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
 
      ** The following /COPY line includes  the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** array size.
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *
      ** Establish the transaction type
     D RecordType      S              1A
     DLoan             C                   CONST('1')
     DFeeLoan          C                   CONST('2')
     DFeeFacility      C                   CONST('3')
      *
      ** Additional Variable Definitions
     D ZDate           S              6  0
     D Filler          S              7
     D WRIDT           S              6
     D DateIn          S              6
     D DaynoOut        S              5  0
     D DateFormat      S              1
     D ErrorFlag       S              1
     D WBIDT           S              6
     D DDRIDT          S              6
     D DDBIDT          S              6
     D BJDFIN          S              1
     D BJRDNB          S              5  0
     D NSDAT           S              5  0
     D C_RIDT          S              5  0
     D C_BIDT          S              5  0
     D E_FERIDT        S              5  0
     D E_FEBIDT        S              5  0
     D NRIDT           S              5  0
     D NBIDT           S              5  0
     D DDRIDTOK        S              1
     D DDBIDTOK        S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing ------------------------+
      ** ¦                                                     ¦
      ** ¦ Initial processing is performed automatically:      ¦
      ** ¦ the *INZSR is executed at program activation.       ¦
      ** ¦                                                     ¦
      ** +-----------------------------------------------------+
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
      *
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             NRIDT
     C                   Z-ADD     0             NBIDT
      *
      ** VALIDATION
      *
      ** Reporting Initial Classification Date
      *
     C                   IF        DDRIDT = *BLANKS
     C                   IF        C_RIDT <> 0
     C                             AND RecordType = Loan
     C                   CALLB     'ZDATE2'                             H1
     C                   PARM                    C_RIDT
     C                   PARM                    BJDFIN
     C                   PARM                    ZDate
     C                   PARM                    Filler
     C                   MOVE      ZDate         DDRIDT
     C                   ENDIF
      *
     C                   IF        E_FERIDT <> 0
     C                             AND RecordType <> Loan
     C                   CALLB     'ZDATE2'                             H1
     C                   PARM                    E_FERIDT
     C                   PARM                    BJDFIN
     C                   PARM                    ZDate
     C                   PARM                    Filler
     C                   MOVE      ZDate         DDRIDT
     C                   ENDIF
     C                   ENDIF
      *8
     C                   IF        DDRIDT <> *BLANKS
     C                   MOVE      DDRIDT        WRIDT
     C                   TESTN                   WRIDT                9798
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      WRIDT         DateIn
     C                   PARM                    DaynoOut
     C                   PARM      BJDFIN        DateFormat
     C                   PARM                    ErrorFlag
      *
     C                   IF        ErrorFlag   = 'Y'
     C                             OR  *IN97 = *OFF
     C                             AND *IN98 = *OFF
     C                   EVAL      DDRIDTOK    = 'N'
     C                   EVAL      Idx        += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRIDT'
     C                   EVAL      MsgIdXAr(Idx)  = '5045692'
     C                   ELSE
     C                   EVAL      NRIDT = DaynoOut
     C                   ENDIF
      *
      ** Date cannot be any earlier than start date
      *
     C                   IF        NSDAT <> 0
     C                             AND NRIDT < NSDAT
     C                             AND DDRIDTOK = 'Y'
     C                   EVAL      DDRIDTOK    = 'N'
     C                   EVAL      Idx        += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRIDT'
     C                   EVAL      MsgIdXAr(Idx)  = '5045639'
     C                   ENDIF
      *
      ** Initial Date cannot be in the future
      *
     C                   IF        NRIDT > BJRDNB
     C                             AND DDRIDTOK = 'Y'
     C                   EVAL      DDRIDTOK    = 'N'
     C                   EVAL      Idx        += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRIDT'
     C                   EVAL      MsgIdXAr(Idx)  = '5045694'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Basel II Initial classification date
      *
     C                   IF        DDBIDT = *BLANKS
     C                   IF        C_BIDT <> 0
     C                             AND RecordType = Loan
     C                   CALLB     'ZDATE2'                             H1
     C                   PARM                    C_BIDT
     C                   PARM                    BJDFIN
     C                   PARM                    ZDate
     C                   PARM                    Filler
     C                   MOVE      ZDate         DDBIDT
     C                   ENDIF
      *
     C                   IF        E_FEBIDT <> 0
     C                             AND RecordType <> Loan
     C                   CALLB     'ZDATE2'                             H1
     C                   PARM                    E_FEBIDT
     C                   PARM                    BJDFIN
     C                   PARM                    ZDate
     C                   PARM                    Filler
     C                   MOVE      ZDate         DDBIDT
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        DDBIDT <> *BLANKS
     C                   MOVE      DDBIDT        WBIDT
     C                   TESTN                   WBIDT                9798
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      WBIDT         DateIn
     C                   PARM                    DaynoOut
     C                   PARM      BJDFIN        DateFormat
     C                   PARM                    ErrorFlag
      *
     C                   IF        ErrorFlag   = 'Y'
     C                             OR  *IN97 = *OFF
     C                             AND *IN98 = *OFF
     C                   EVAL      DDBIDTOK    = 'N'
     C                   EVAL      Idx        += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBIDT'
     C                   EVAL      MsgIdXAr(Idx)  = '5045780'
     C                   ELSE
     C                   EVAL      NBIDT = DaynoOut
     C                   ENDIF
      *
      ** Date cannot be any earlier than start date
      *
     C                   IF        NSDAT <> 0
     C                             AND NBIDT < NSDAT
     C                             AND DDBIDTOK = 'Y'
     C                   EVAL      DDBIDTOK    = 'N'
     C                   EVAL      Idx        += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBIDT'
     C                   EVAL      MsgIdXAr(Idx)  = '5045640'
     C                   ENDIF
      *
      ** Initial Date cannot be in the future
      *
     C                   IF        NBIDT > BJRDNB
     C                             AND DDBIDTOK = 'Y'
     C                   EVAL      DDBIDTOK    = 'N'
     C                   EVAL      Idx        += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBIDT'
     C                   EVAL      MsgIdXAr(Idx)  = '5045781'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   RETURN
      *
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
     C                   PARM                    DDRIDT
     C                   PARM                    DDBIDT
     C                   PARM                    BJDFIN
     C                   PARM                    BJRDNB
     C                   PARM                    NSDAT
     C                   PARM                    C_RIDT
     C                   PARM                    C_BIDT
     C                   PARM                    E_FERIDT
     C                   PARM                    E_FEBIDT
     C                   PARM                    RecordType
      *
      ** OUTPUTS
      *
     C                   PARM                    NRIDT
     C                   PARM                    NBIDT
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Value Date - OK
      *
     C                   PARM                    DDRIDTOK
     C                   PARM                    DDBIDTOK
      *
      ** Program, module and procedure names for DB error processing
      ** ===========================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) MIsys International Banking Systems Ltd. 2012
