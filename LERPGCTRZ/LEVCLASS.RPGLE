     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Conversion - Classification Ranges')     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVCLASS - Validate Classifications                          *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others) LDA layout
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
      ** array sizes
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
      ** Lending ICD
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      *
      ** Formatting Details
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Customer lending ICD
     D DSCLD           S             25    INZ DIM(9)
     D DSCLN           S              3  0 INZ DIM(9)
     D DSRCD           S             25    INZ DIM(9)
     D DSRCN           S              3  0 INZ DIM(9)
      *
      ** Establish the transaction type
     D RecordType      S              1A
     DLoan             C                   CONST('1')
     DFeeLoan          C                   CONST('2')
     DFeeFacility      C                   CONST('3')
      *
      ** Additional Variable Definitions
     D WRCAT           S              1  0
     D WBCAT           S              1  0
     D DDRCAT          S              1
     D DDBCAT          S              1
     D C_RCAT          S              1
     D C_BCAT          S              1
     D E_FERCAT        S              1
     D E_FEBCAT        S              1
     D NRCAT           S              1  0
     D NBCAT           S              1  0
     D DDRCATOK        S              1
     D DDBCATOK        S              1
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing ----------------------+
      ** ¦                                                   ¦
      ** ¦ Initial processing is performed automatically:    ¦
      ** ¦ the *INZSR is executed at program activation.     ¦
      ** ¦                                                   ¦
      ** +---------------------------------------------------+
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             NRCAT
     C                   Z-ADD     0             NBCAT
      *
      ** VALIDATION
      *
      ** Indicator: Reporting Past Due Classification
      *
     C                   IF        DDRCAT = *BLANKS
     C                   IF        C_RCAT <> *BLANKS
     C                             AND C_RCAT <> '0'
     C                             AND RecordType = Loan
     C                   MOVE      C_RCAT        DDRCAT
     C                   ENDIF
      *
     C                   IF        E_FERCAT <> *BLANKS
     C                             AND E_FERCAT <> '0'
     C                             AND RecordType <> Loan
     C                   MOVE      E_FERCAT      DDRCAT
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        DDRCAT >= '1'
     C                             AND DDRCAT <= '9'
     C                             OR DDRCAT = ' '
      *
     C                   IF        DDRCAT <> ' '
     C                   MOVE      DDRCAT        WRCAT
      *
      ** If valid range, the value must be valid
      ** (i.e. description <> *BLANKS)
      *
     C                   IF        DSRCD(WRCAT) = *BLANKS
     C                   EVAL      DDRCATOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRCAT'
     C                   EVAL      MsgIdXAr(Idx) = '5045700'
     C                   ELSE
     C                   Z-ADD     WRCAT         NRCAT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   EVAL      DDRCATOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRCAT'
     C                   EVAL      MsgIdXAr(Idx) = '5045700'
     C                   ENDIF
      *
      ** Indicator: Basel II Past Due Classification
      *
     C                   IF        DDBCAT = *BLANKS
     C                   IF        C_BCAT <> *BLANKS
     C                             AND C_BCAT <> '0'
     C                             AND RecordType = Loan
     C                   MOVE      C_BCAT        DDBCAT
     C                   ENDIF
      *
     C                   IF        E_FEBCAT <> *BLANKS
     C                             AND E_FEBCAT <> '0'
     C                             AND RecordType <> Loan
     C                   MOVE      E_FEBCAT      DDBCAT
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        DDBCAT >= '1'
     C                             AND DDBCAT <= '9'
     C                             OR DDBCAT = ' '
      *
     C                   IF        DDBCAT <> ' '
     C                   MOVE      DDBCAT        WBCAT
      *
      ** If valid range, the value must be valid
      ** (i.e. description <> *BLANKS)
      *
     C                   IF        DSCLD(WBCAT) = *BLANKS
     C                   EVAL      DDBCATOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBCAT'
     C                   EVAL      MsgIdXAr(Idx) = '5045783'
     C                   ELSE
     C                   Z-ADD     WBCAT         NBCAT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   EVAL      DDBCATOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBCAT'
     C                   EVAL      MsgIdXAr(Idx) = '5045783'
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
      ** Other Parameters
      *
     C                   PARM                    DDRCAT
     C                   PARM                    DDBCAT
     C                   PARM                    C_RCAT
     C                   PARM                    C_BCAT
     C                   PARM                    E_FERCAT
     C                   PARM                    E_FEBCAT
     C                   PARM                    RecordType
      *
      ** OUTPUTS
      *
     C                   PARM                    NRCAT
     C                   PARM                    NBCAT
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** OK Values
      *
     C                   PARM                    DDRCATOK
     C                   PARM                    DDBCATOK
      *
      ** Retrieve Arrays
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDCLND        PARM      SDCLND        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCLNDPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      DSCLD(1) = BPCLD1
     C                   EVAL      DSCLD(2) = BPCLD2
     C                   EVAL      DSCLD(3) = BPCLD3
     C                   EVAL      DSCLD(4) = BPCLD4
     C                   EVAL      DSCLD(5) = BPCLD5
     C                   EVAL      DSCLD(6) = BPCLD6
     C                   EVAL      DSCLD(7) = BPCLD7
     C                   EVAL      DSCLD(8) = BPCLD8
     C                   EVAL      DSCLD(9) = BPCLD9
      *
     C                   EVAL      DSRCD(1) = BPRCD1
     C                   EVAL      DSRCD(2) = BPRCD2
     C                   EVAL      DSRCD(3) = BPRCD3
     C                   EVAL      DSRCD(4) = BPRCD4
     C                   EVAL      DSRCD(5) = BPRCD5
     C                   EVAL      DSRCD(6) = BPRCD6
     C                   EVAL      DSRCD(7) = BPRCD7
     C                   EVAL      DSRCD(8) = BPRCD8
     C                   EVAL      DSRCD(9) = BPRCD9
      *
      ** Program, module and procedure names for DB error processing
      ** ===========================================================
      ** The following /COPY sets these values, and also defines LDA
      ** as an external data area
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
(c) Finastra International Limited 2012
