     H DEBUG
     H COPYRIGHT('(c)Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT Generate US records in FACHISA')              *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UTLE0850B - SQLRPGLE program that generates US records from  *
      *              LEMNFUPD to FACHISA.                             *
      *                                                               *
      *  Function: Reads all records in LEMNFUPD then generates 'US'  *
      *            records to FACHISA.                                *
      *                                                               *
      *  Called By: UTCLE0850 - CL program                            *
      *                                                               *
      *  (c)Finastra International Limited 2020                       *
      *                                                               *
      *  Last Amend No. MD056104 *CREATE   Date 07Aug20               *
      *  Prev Amend No. Xxnnnnnn           Date DDMMMYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056104 - Numerous incorrect utilisation records found in   *
      *             FACHISA.                                          *
      *           - Reverse all required utilisation records and      *
      *             regenerate US records from LEMNFUPD.              *
      *                                                               *
      *****************************************************************
      *
     FUTLE0850P2O    E             PRINTER OFLIND(*IN89)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N  O F  I N D I C A T O R S                    *
      *                                                               *
      *   12 -  No Details to Report                                  *
      *   89 -  Overflow UTLE0850P1                                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the LE standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /SPACE 5
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      *
      ** Bank Details.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Currency details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Data structure for Access Program
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Fields 'local' to the program
      *
     D UTFCCY          S              3A   INZ(*BLANK)
     D UTTRCA          S              2A   INZ(*BLANK)
     D UTRVCR          S              1A   INZ(*BLANK)
     D UTRCIN          S              1A   INZ(*BLANK)
     D UTCANM          S              6A   INZ(*BLANK)
     D UTCFGI          S              1A   INZ(*BLANK)
     D UTCMDI          S              1A   INZ(*BLANK)
     D UTCACY          S              3A   INZ(*BLANK)
     D UTLUCY          S              3A   INZ(*BLANK)
     D UTRTMD          S              1A   INZ(*BLANK)
     D CAFCCY          S              3A   INZ(*BLANK)
     D CARVCR          S              1A   INZ(*BLANK)
      *
      ** VARIABLES FOR SR/CheckDecNum
      *
     D CDN_FCCY        S              3A   INZ(*BLANK)
     D CDN_UCCY        S              3A   INZ(*BLANK)
      *
      ** VARIABLES FOR ERROR
      *
     D DBFCTY          S             13A   INZ(*BLANK)
      *
      ** STRING OF CHAR FOR DBERROR
      *
     D FACT_CHAR       S              3A   INZ(*BLANK)
     D FCNO_CHAR       S              2A   INZ(*BLANK)
      *
      ** ZDate2 parameters
      *
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
      *
      ** DS FOR LEMNFUPD
      *
     D MFU_DS        E DS                  EXTNAME(LEMNFUPD)
     D                                        QUALIFIED
      *
      ** PROGRAM START
      *
     C                   WRITE     HEADER1
      *
      ** FLAG ALL FAREVI = 'R' FOR ALL US/UE/UI/UD UTILISATION RECORDS IN FACHISA
      ** FACILITY SHOULD BE LIVE IN FCLTYFM
      *
     C/EXEC SQL
     C+ DECLARE MFUCursor CURSOR FOR
     C+ SELECT *
     C+ FROM LEMNFUPD
     C+ WHERE ORED <> :BJRDNB
     C+ AND PUAM <> 0
     C/END-EXEC

     C/EXEC SQL
     C+ Open MFUCursor
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** FETCH FIRST RECORD
      *
     C/EXEC SQL
     C+ Fetch Next from MFUCursor into :MFU_DS
     C/END-EXEC
      *
      ** COUNT MFUs TO BE PROCESSED
      *
     C                   EXSR      CountMFU
      *
      ** LOOP ALL MFUs
      *
     C                   DOW       SQLCODE = 0
      *
      ** GET FACILITY DETAILS
      *
     C                   EXSR      GetFctyDetail
      *
      ** CHECK IF MFU 'US' GENERATION IS TO BE SKIPPED
      ** SKIP IF NON-REVOLVING AND HAS 'UD' OR 'UE' RECORDS IN FACHISA
      ** PROCESS IF FACILITY FOUND IN LEPFHAPD
      *
     C                   IF        UTRVCR = 'N'
     C                   EXSR      CheckIfSkip
      *
     C                   IF        PFHA_COUNT = 0
      *
      ** DECREASE COUNT TO BE PROCESSED
      *
     C                   EVAL      MFU_COUNT = MFU_COUNT - 1
      *
      ** GET NEXT RECORD
      *
     C/EXEC SQL
     C+ Fetch Next from MFUCursor into :MFU_DS
     C/END-EXEC
      *
      ** SKIP TO ENDDO
      *
     C                   ITER
     C                   ENDIF                                                  PFHA_COUNT = 0
      *
     C                   ENDIF                                                  UTRVCR = 'N'
      *
      ** GET NUMBER OF DECIMAL PLACES
      *
     C                   EVAL      CDN_FCCY = UTFCCY
     C                   EVAL      CDN_UCCY = MFU_DS.UCCY
     C                   EXSR      CheckDecNum
      *
     C                   EXSR      GenerateUS
      *
      ** EXECUTE INSERT OF NEW 'US' RECORD TO FACHISA IF UPDATE MODE
      *
     C                   IF        *IN16 = '1'
     C                   EXSR      WriteUS
     C                   EXSR      TriggerRecalc
     C                   ENDIF                                                  *IN16 = '1'
      *
      ** SET VALUES TO BE PRINTED
      *
     C                   IF        UTTRCA = *BLANKS
     C                   EVAL      DPTRCA = 'FACILITY'
     C                   ELSEIF    UTTRCA = 'TR'
     C                   EVAL      DPTRCA = 'TRANCHE'
     C                   ENDIF
      *
      ** FORMAT START DATE
      *
     C                   EVAL      ZDAYNO = MFU_DS.STDT
     C                   EXSR      FmtDate
     C                   EVAL      DPSTDT = ZADATE
      *
      ** DETERMINE FORMAT FOR DISPLAY OF FACILITY AMOUNT
      *
     C                   IF        *IN50 = '1'
     C                   MOVE      ACTAMT        DPFAMT0
     C                   ELSEIF    *IN51 = '1'
     C                   MOVE      ACTAMT        DPFAMT1
     C                   ELSEIF    *IN52 = '1'
     C                   MOVE      ACTAMT        DPFAMT2
     C                   ELSEIF    *IN53 = '1'
     C                   MOVE      ACTAMT        DPFAMT3
     C                   ENDIF
      *
      ** DETERMINE FORMAT FOR DISPLAY OF UTILISATION AMOUNT
      *
     C                   IF        *IN60 = '1'
     C                   MOVE      MFU_DS.UAMT   DPUAMT0
     C                   ELSEIF    *IN61 = '1'
     C                   MOVE      MFU_DS.UAMT   DPUAMT1
     C                   ELSEIF    *IN62 = '1'
     C                   MOVE      MFU_DS.UAMT   DPUAMT2
     C                   ELSEIF    *IN63 = '1'
     C                   MOVE      MFU_DS.UAMT   DPUAMT3
     C                   ENDIF
      *
     C                   EVAL      DPBRCA = MFU_DS.BRCA
     C                   EVAL      DPCNUM = MFU_DS.CNUM
     C                   EVAL      DPFACT = MFU_DS.FACT
     C                   EVAL      DPFCNO = MFU_DS.FCNO
     C                   EVAL      DPSQNO = MFU_DS.SQNO
     C                   EVAL      DPUCCY = MFU_DS.UCCY
     C                   EVAL      DPFCCY = UTFCCY
      *
      ** CHECK IF OVERFLOW
      *
     C                   IF        *IN89 = '1'
     C                   ADD       1             PAGENO
     C                   WRITE     HEADER1
     C                   EVAL      *IN89 = '0'
     C                   ENDIF                                                  *IN89
      *
      ** WRITE DETAILS TO REPORT
      *
     C                   WRITE     DETAIL1
      *
      ** CHECK IF FACILITY OF THE MFU IS A TRANCH,
      ** GENERATE US FOR ITS CA
      *
     C                   IF        UTTRCA = 'TR'
     C                   EXSR      GetCAFacility
      *
      ** CHECK DECIMAL PLACES FOR CA CURRENCY
      *
     C                   EVAL      CDN_FCCY = CAFCCY
     C                   EVAL      CDN_UCCY = UTFCCY
     C                   EXSR      CheckDecNum
      *
      ** GENERATE US FOR THE CA FACILITY IF UPDATE MODE
      *
     C                   EXSR      GenerateUS_CA
      *
     C                   IF        *IN16 = '1'
     C                   EXSR      WriteUS
     C                   EXSR      TriggerRecalc
     C                   ENDIF
      *
      ** SET NEW VALUES TO BE PRINTED FOR CA
      ** DETERMINE FORMAT FOR DISPLAY OF FACILITY AMOUNT
      *
     C                   IF        *IN50 = '1'
     C                   MOVE      ACTAMT        DPFAMT0
     C                   ELSEIF    *IN51 = '1'
     C                   MOVE      ACTAMT        DPFAMT1
     C                   ELSEIF    *IN52 = '1'
     C                   MOVE      ACTAMT        DPFAMT2
     C                   ELSEIF    *IN53 = '1'
     C                   MOVE      ACTAMT        DPFAMT3
     C                   ENDIF
      *
     C                   EVAL      DPFACT = CAFACT
     C                   EVAL      DPFCNO = CAFCNO
     C                   EVAL      DPTRCA = 'CR.AGRMT'
     C                   EVAL      DPFCCY = CAFCCY
      *
      ** CHECK IF OVERFLOW
      *
     C                   IF        *IN89 = '1'
     C                   ADD       1             PAGENO
     C                   WRITE     HEADER1
     C                   EVAL      *IN89 = '0'
     C                   ENDIF                                                  *IN89
      *
      ** WRITE DETAILS TO REPORT
      *
     C                   WRITE     DETAIL1
      *
     C                   ENDIF                                                  UTTRCA = 'TR'
      *
     C/EXEC SQL
     C+ Fetch Next from MFUCursor into :MFU_DS
     C/END-EXEC

     C                   ENDDO

     C/EXEC SQL
     C+ CLOSE MFUCursor
     C/END-EXEC
      *
      ** ADD COUNT OF MFUs GENERATED FOR CA
      *
     C                   EVAL      MFU_COUNT = MFU_COUNT + CA_COUNT
      *
      ** WRITE FOOTER
      *
     C                   WRITE     TRAILER1

     C                   EVAL      *INLR = *ON

      *****************************************************************
      *                                                               *
      * *InzSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *InzSR        BEGSR
      *
      ** Parameter Entry List.
      *
     C     *Entry        PLIST
     C                   PARM                    Mode              1
      *
     C                   EVAL      *IN12 = '0'
     C                   Z-ADD     0             PAGENO            2 0
     C                   Z-ADD     0             MFU_COUNT         7 0
     C                   Z-ADD     1             UTTSEQ            4 0
     C                   Z-ADD     0             FS_DATE           5 0
     C                   Z-ADD     0             WOUTAMT          15 0
     C                   Z-ADD     0             ACTAMT           15 0
     C                   Z-ADD     0             UTFACT            3 0
     C                   Z-ADD     0             UTFCNO            2 0
     C                   Z-ADD     0             UTUAMT           15 0
     C                   Z-ADD     0             UTLUAM           15 0
     C                   Z-ADD     0             UTFAMT           13 0
     C                   Z-ADD     0             UTEXRT           13 8
     C                   Z-ADD     0             UTCAFT            3 0
     C                   Z-ADD     0             UTCAFN            2 0
     C                   Z-ADD     0             UTCAXR           13 8
     C                   Z-ADD     0             CAFACT            3 0
     C                   Z-ADD     0             CAFCNO            2 0
     C                   Z-ADD     0             CAFAMT           13 0
     C                   Z-ADD     0             CA_COUNT          7 0
     C                   Z-ADD     0             PFHA_COUNT        7 0
     C                   Z-ADD     0             UD_UE_COUNT       7 0
     C                   Z-ADD     0             TMPAMT           15 0
      *
      ** Check mode is AUDIT or UPDATE.
      *
     C                   IF        Mode = 'U'
     C                             OR Mode = 'u'
     C                   EVAL      *IN16 = '1'
     C                   ELSE
     C                   EVAL      *IN16 = '0'
     C                   ENDIF
      *
     C                   EVAL      *IN12 = '0'
     C                   Z-ADD     0             PAGENO            2 0
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = @OPTN                                *************
     C                   EVAL      DBPGM = 'UTLE0849'                           * DBERR 001 *
     C                   EVAL      DBASE = 001                                  *************
     C                   OUT       LDA
     C                   WRITE     HEADER1
     C                   WRITE     DBERROR1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  CheckIfSkip - Check if non-revolving facility is live and    *
      *                exists in LEPFHAPD.                            *
      *                                                               *
      *  Called from: Main                                            *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     CheckIfSkip   BEGSR
      *
     C                   EVAL      UD_UE_COUNT = 0
     C/EXEC SQL
     C+ SELECT COUNT(*) INTO :UD_UE_COUNT
     C+ FROM FACHISA WHERE
     C+ FAFCTY = CONCAT(DIGITS(:MFU_DS.FACT), DIGITS(:MFU_DS.FCNO))
     C+ AND BRCA = :MFU_DS.BRCA
     C+ AND FACNUM = :MFU_DS.CNUM
     C+ AND FARECI = 'D'
     C+ AND FAREVI = ''
     C+ AND FARCIN = 'N'
     C+ AND (FAACTN = 'UD' OR FAACTN = 'UE')
     C/END-EXEC
      *
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      PFHA_COUNT = 0
      *
     C                   IF        UD_UE_COUNT > 0
     C/EXEC SQL
     C+ SELECT COUNT(*) INTO :PFHA_COUNT FROM LEPFHAPD
     C+ WHERE DUPBRC = :MFU_DS.BRCA
     C+ AND DUPNUM = :MFU_DS.CNUM
     C+ AND DUPFAC = CONCAT(DIGITS(:MFU_DS.FACT), DIGITS(:MFU_DS.FCNO))
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF                                                  UD_UE_COUNT
      *
     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  CountMFU - Counts all MFUs to be generated.                  *
      *                                                               *
      *  Called from: Main                                            *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     CountMFU      BEGSR
     C/EXEC SQL
     C+ SELECT COUNT(*) INTO :MFU_COUNT
     C+ FROM LEMNFUPD
     C+ WHERE ORED <> :BJRDNB
     C+ AND PUAM <> 0
     C/END-EXEC
     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  GetFctyDetail - Get necessary facility details               *
      *                                                               *
      *  Called from: Main                                            *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     GetFctyDetail BEGSR
     C                   EVAL      UTFCCY = *BLANKS
     C/EXEC SQL
     C+ SELECT
     C+ FCCY,
     C+ FAMT,
     C+ TRCA,
     C+ RVCR,
     C+ CANM,
     C+ CAFT,
     C+ CAFN,
     C+ CAXR,
     C+ CMDI,
     C+ CACY
     C+ INTO
     C+ :UTFCCY,
     C+ :UTFAMT,
     C+ :UTTRCA,
     C+ :UTRVCR,
     C+ :UTCANM,
     C+ :UTCAFT,
     C+ :UTCAFN,
     C+ :UTCAXR,
     C+ :UTCMDI,
     C+ :UTCACY
     C+ FROM FCLTYFM
     C+ WHERE RECI = 'D'
     C+ AND BRCA = :MFU_DS.BRCA
     C+ AND CNUM = :MFU_DS.CNUM
     C+ AND FACT = :MFU_DS.FACT
     C+ AND FCNO = :MFU_DS.FCNO
     C/END-EXEC
     C                   IF         SQLCODE = 100
      *DBERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'FCLTY1  '
     C                   EVAL      DBKEY = UTFCCY                               *************
     C                   EVAL      DBPGM = 'UTLE0850B'                          * DBERR 003 *
     C                   EVAL      DBASE = 003                                  *************
     C                   EVAL      FACT_CHAR = %EDITC(MFU_DS.FACT:'X')
     C                   EVAL      FCNO_CHAR = %EDITC(MFU_DS.FCNO:'X')
     C                   EVAL      DBFCTY = MFU_DS.CNUM +'-'+ FACT_CHAR
     C                             +'/'+ FCNO_CHAR
     C                   EVAL      DBKEY = DBFCTY
     C                   OUT       LDA
     C                   WRITE     HEADER1
     C                   WRITE     DBERROR1
     C                   EXSR      *PSSR
      *ERROR IF SQLCODE NOT EQUAL TO 0 OR 100
     C                   ELSEIF    SQLCODE <> 0
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  GenerateUS - Generates/prepares US to be written in FACHISA. *
      *                                                               *
      *  Called from: Main                                            *
      *                                                               *
      *  Calls: PGM/ZONVZ1, SR/WriteUs, SR/TriggerRecalc              *
      *                                                               *
      *****************************************************************
     C     GenerateUS    BEGSR
      *
      ** Search for records of same date in PF/FACHISA to get
      ** the last sequence number.
      *
     C                   EVAL      UTTSEQ = 1
     C/EXEC SQL
     C+ SELECT FATSEQ INTO :UTTSEQ
     C+ FROM FACHISA
     C+ WHERE FADATE = :MFU_DS.STDT
     C+ AND BRCA = :MFU_DS.BRCA
     C+ AND FACNUM = :MFU_DS.CNUM
     C+ AND FAFCTY = CONCAT(DIGITS(:MFU_DS.FACT), DIGITS(:MFU_DS.FCNO))
     C+ ORDER BY FATSEQ DESC
     C+ LIMIT 1
     C/END-EXEC
     C                   IF        SQLCODE = 0
     C                   EVAL      UTTSEQ += 1
     C                   ELSEIF    SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      UTLUCY = *BLANKS
     C                   EVAL      UTLUAM = 0
     C                   EVAL      UTEXRT = 0
     C                   EVAL      UTRTMD = *BLANKS
      *
      ** Convert action amount to utilisation currency amount
      ** if needed.
      *
     C                   IF        MFU_DS.UCCY <> UTFCCY
      *
     C                   EVAL      WOUTAMT = 0
     C                   EVAL      UTLUCY = MFU_DS.UCCY
     C                   EVAL      UTLUAM = MFU_DS.UAMT
     C                   EVAL      UTEXRT = MFU_DS.UXRT
     C                   EVAL      UTRTMD = MFU_DS.UXID
      *
      ** MOVE UTILIZATION AMOUNT TO LENGTH 15 TO AVOID
      ** DECIMAL DATA ERROR IN ZCONVZ1
      *
     C                   MOVE      MFU_DS.UAMT   UTUAMT
      *
     C                   CALL      'ZCONVZ1'
     C                   PARM                    UTUAMT                         InputAmnt
     C                   PARM                    MFU_DS.UXRT                    ExchRate
     C                   PARM                    MFU_DS.UXID                    MultDivInd
     C                   PARM                    MFU_DS.UCCY                    FrCurrency
     C                   PARM                    UTFCCY                         ToCurrency
     C                   PARM                    UCCYDP                         FrDecPlace
     C                   PARM                    FCCYDP                         ToDecPlace
     C                   PARM                    WOUTAMT                        OutputAmnt
      *
     C                   EVAL      ACTAMT = WOUTAMT
      *
     C                   ELSE
     C                   EVAL      ACTAMT = MFU_DS.UAMT
     C                   ENDIF
      *
     C                   EVAL      UTRCIN = UTRVCR
     C                   EVAL      UTCFGI = 'Y'
     C                   EVAL      UTFACT = MFU_DS.FACT
     C                   EVAL      UTFCNO = MFU_DS.FCNO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  CheckDecNum -  Determine number of decimal places            *
      *                                                               *
      *  Called From: Main                                            *
      *                                                               *
      *  Calls: PGM/AOCURRR0                                          *
      *                                                               *
      *****************************************************************
      *
     C     CheckDecNum   BEGSR
      *
      ** Check facility details
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CDN_FCCY      @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = CDN_FCCY                             *************
     C                   EVAL      DBPGM = 'UTLE0850B'                          * DBERR 005 *
     C                   EVAL      DBASE = 005                                  *************
     C                   OUT       LDA
     C                   WRITE     HEADER1
     C                   WRITE     DBERROR1
     C                   EXSR      *PSSR
     C                   ENDIF                                                  @RTCD <> *BLANKS
      *
     C                   Z-ADD     A6NBDP        FCCYDP            1 0
      *RESET INDICATORS
     C                   EVAL      *IN50 = '0'
     C                   EVAL      *IN51 = '0'
     C                   EVAL      *IN52 = '0'
     C                   EVAL      *IN53 = '0'
      *
     C                   IF        A6NBDP = 0
     C                   EVAL      *IN50 = '1'
      *
     C                   ELSEIF    A6NBDP = 1
     C                   EVAL      *IN51 = '1'
      *
     C                   ELSEIF    A6NBDP = 2
     C                   EVAL      *IN52 = '1'
      *
     C                   ELSEIF    A6NBDP = 3
     C                   EVAL      *IN53 = '1'
      *
     C                   ENDIF
      *
      ** Utilisation details
      *
     C                   IF        CDN_UCCY <> *BLANKS
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CDN_UCCY      @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = CDN_UCCY                             *************
     C                   EVAL      DBPGM = 'UTLE0850B'                          * DBERR 005 *
     C                   EVAL      DBASE = 005                                  *************
     C                   OUT       LDA
     C                   WRITE     HEADER1
     C                   WRITE     DBERROR1
     C                   EXSR      *PSSR
     C                   ENDIF                                                  @RTCD <> *BLANKS
      *
     C                   Z-ADD     A6NBDP        UCCYDP            1 0
      *RESET INDICATORS
     C                   EVAL      *IN60 = '0'
     C                   EVAL      *IN61 = '0'
     C                   EVAL      *IN62 = '0'
     C                   EVAL      *IN63 = '0'
      *
     C                   IF        A6NBDP = 0
     C                   EVAL      *IN60 = '1'
      *
     C                   ELSEIF    A6NBDP = 1
     C                   EVAL      *IN61 = '1'
      *
     C                   ELSEIF    A6NBDP = 2
     C                   EVAL      *IN62 = '1'
      *
     C                   ELSEIF    A6NBDP = 3
     C                   EVAL      *IN63 = '1'
      *
     C                   ENDIF                                                  A6NBDP = 0
     C                   ENDIF                                                  CDN_UCCY <> *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  WriteUS - SQL to insert US.                                  *
      *                                                               *
      *  Called from: SR/GenerateUS, SR/GenerateUS_CA                 *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     WriteUS       BEGSR
     C/EXEC SQL
     C+ INSERT INTO FACHISA(
     C+ BRCA,
     C+ FAAAMT,
     C+ FAACBR,
     C+ FAACCD,
     C+ FAACCU,
     C+ FAACCY,
     C+ FAACNO,
     C+ FAACSQ,
     C+ FAACTN,
     C+ FAAFAM,
     C+ FACFAM,
     C+ FACFGI,
     C+ FACNUM,
     C+ FADATE,
     C+ FADEAL,
     C+ FADRAM,
     C+ FAEXCY,
     C+ FAEXRT,
     C+ FAFCTY,
     C+ FAFSEQ,
     C+ FAFXMT,
     C+ FAFXPC,
     C+ FAGASS,
     C+ FAGNDT,
     C+ FAINOF,
     C+ FALCRF,
     C+ FALOAN,
     C+ FALPFI,
     C+ FALUAM,
     C+ FALUCY,
     C+ FAMCY,
     C+ FAOFFS,
     C+ FAORED,
     C+ FAPAMT,
     C+ FAPART,
     C+ FAPTEO,
     C+ FAPTYP,
     C+ FARCIN,
     C+ FARCSI,
     C+ FARECI,
     C+ FAREVI,
     C+ FARIND,
     C+ FARTMD,
     C+ FASQNO,
     C+ FATSEQ,
     C+ FATTEO,
     C+ FATVAL,
     C+ FAUNDR,
     C+ FAWCPC,
     C+ FAWEIG
     C+ )
     C+ VALUES(
     C+ :MFU_DS.BRCA,
     C+ :ACTAMT,
     C+ DEFAULT,
     C+ 0,
     C+ DEFAULT,
     C+ DEFAULT,
     C+ 0,
     C+ 0,
     C+ 'US',
     C+ :UTFAMT,
     C+ :UTFAMT,
     C+ :UTCFGI,
     C+ :MFU_DS.CNUM,
     C+ :MFU_DS.STDT,
     C+ 0,
     C+ 0,
     C+ DEFAULT,
     C+ :UTEXRT,
     C+ CONCAT(DIGITS(:UTFACT), DIGITS(:UTFCNO)),
     C+ :UTTSEQ,
     C+ DEFAULT,
     C+ 0,
     C+ DEFAULT,
     C+ :MFU_DS.STDT,
     C+ DEFAULT,
     C+ DEFAULT,
     C+ DEFAULT,
     C+ DEFAULT,
     C+ :UTLUAM,
     C+ :UTLUCY,
     C+ DEFAULT,
     C+ 0,
     C+ :BJRDNB,
     C+ 0,
     C+ DEFAULT,
     C+ 0,
     C+ 0,
     C+ :UTRCIN,
     C+ DEFAULT,
     C+ :MFU_DS.RECI,
     C+ DEFAULT,
     C+ DEFAULT,
     C+ :UTRTMD,
     C+ :MFU_DS.SQNO,
     C+ :UTTSEQ,
     C+ 0,
     C+ 0,
     C+ 0,
     C+ 0,
     C+ 0)
     C/END-EXEC
     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  TriggerRecalc - Updates 2 files to recalc in COB             *
      *                                                               *
      *  Called from: SR/GenerateUS, SR/GenerateUS_CA                 *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     TriggerRecalc BEGSR
      *
      ** Get date of FS
      *
     C/EXEC SQL
     C+ SELECT FADATE INTO :FS_DATE FROM FACHISA
     C+ WHERE FAACTN = 'FS'
     C+ AND FARECI = :MFU_DS.RECI
     C+ AND BRCA = :MFU_DS.BRCA
     C+ AND FACNUM = :MFU_DS.CNUM
     C+ AND FAFCTY = CONCAT(DIGITS(:UTFACT), DIGITS(:UTFCNO))
     C/END-EXEC
      *
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** UPDATE FACHISH
      *
     C/EXEC SQL
     C+ UPDATE FACHISH SET FHRWKR = 'Y',
     C+ FHRWDT = :FS_DATE, FHRWTP = 'M'
     C+ WHERE FHBRCH = :MFU_DS.BRCA AND
     C+ FHCNUM = :MFU_DS.CNUM AND
     C+ FHFTYP = :UTFACT AND
     C+ FHFSEQ = :UTFCNO
     C/END-EXEC

     C                   IF        SQLCODE = 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBFILE = 'FACHISH'
     C                   EVAL      FACT_CHAR = %EDITC(UTFACT:'X')
     C                   EVAL      FCNO_CHAR = %EDITC(UTFCNO:'X')
     C                   EVAL      DBKEY = MFU_DS.BRCA
     C                             +'-'+ MFU_DS.CNUM
     C                             +'-'+ FACT_CHAR +'/'+ FCNO_CHAR
     C                   EVAL      DBPGM = 'UTLE0850'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   IF        *IN89 = '1'
     C                   ADD       1             PAGE
     C                   WRITE     HEADER1
     C                   EVAL      *IN89 = '0'
     C                   ENDIF
     C                   WRITE     DBERROR1
     C                   EXSR      *PSSR

     C                   ELSEIF    SQLCODE <> 0
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** UPDATE FACACT
      *
     C/EXEC SQL
     C+ UPDATE FACACT SET
     C+ FCDATE = :FS_DATE
     C+ WHERE BRCA = :MFU_DS.BRCA AND
     C+ FCCNUM = :MFU_DS.CNUM AND
     C+ FCFCTY = CONCAT(DIGITS(:UTFACT), DIGITS(:UTFCNO))
     C/END-EXEC
      *
      ** IF NOT FOUND, INSERT RECORD INTO FACACT
      *
     C                   IF        SQLCODE = 100
     C/EXEC SQL
     C+ INSERT INTO FACACT
     C+ VALUES (
     C+ :MFU_DS.BRCA,
     C+ :MFU_DS.CNUM,
     C+ CONCAT(DIGITS(:UTFACT), DIGITS(:UTFCNO)),
     C+ :FS_DATE)
     C/END-EXEC
     C                   ELSEIF    SQLCODE <> 0
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * INSERT INTO UTLE0850PD FOR REPORTING
      *
     C/EXEC SQL
     C+ INSERT INTO UTLE0850PD
     C+ VALUES (:MFU_DS.BRCA,
     C+ :MFU_DS.CNUM,
     C+ CONCAT(DIGITS(:UTFACT), DIGITS(:UTFCNO)))
     C/END-EXEC
      *
      *
     C                   IF        SQLCODE = -803
      *                  IF DUPLICATE, DO NOTHING/AVOID ERROR
     C                   ELSEIF    SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  GetCAFacility - If facility of the utilisation is a tranche, *
      *                  get the CA facility details.                 *
      *                                                               *
      *  Called from: Main                                            *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     GetCAFacility BEGSR
      *
     C/EXEC SQL
     C+ SELECT FACT, FCNO, FAMT, FCCY, RVCR
     C+ INTO :CAFACT, :CAFCNO, :CAFAMT, :CAFCCY, :CARVCR
     C+ FROM FCLTYFM
     C+ WHERE TRCA = 'CA'
     C+ AND CNUM = :UTCANM
     C+ AND FACT = :UTCAFT
     C+ AND FCNO = :UTCAFN
     C/END-EXEC
     C                   IF        SQLCODE = 0
     C                   EVAL      CA_COUNT = CA_COUNT + 1
      *
     C                   ELSEIF    SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  GenerateUS_CA - Generates US for CA facility.                *
      *                                                               *
      *  Called from: Main                                            *
      *                                                               *
      *  Calls: PGM/ZONVZ1, SR/WriteUs, SR/TriggerRecalc              *
      *                                                               *
      *****************************************************************
     C     GenerateUS_CA BEGSR
      *
      ** RESET WORK VARIABLES TO BE WRITTEN IN FACHISA
      *
     C                   EVAL      UTLUCY = *BLANKS
     C                   EVAL      UTLUAM = 0
     C                   EVAL      UTEXRT = 0
     C                   EVAL      UTRTMD = *BLANKS
      *
      ** SAVE THE CURRENCY OF TR FACILITY
      *
     C                   EVAL      TMPAMT = ACTAMT
      *
      ** Convert action amount to utilisation currency amount
      ** if needed.
      *
     C                   IF        UTFCCY <> CAFCCY
      *
     C                   EVAL      WOUTAMT = 0
     C                   EVAL      UTLUCY = UTFCCY
     C                   EVAL      UTLUAM = TMPAMT
     C                   EVAL      UTEXRT = UTCAXR
     C                   EVAL      UTRTMD = UTCMDI
      *
      ** MOVE LAST UTILISATION AMOUNT IN VARIABLE ACTAMT TO LENGTH 15 TO AVOID
      ** DECIMAL DATA ERROR IN ZCONVZ1
      *
     C                   MOVE      ACTAMT        UTUAMT
      *
     C                   CALL      'ZCONVZ1'
     C                   PARM                    UTUAMT                         InputAmnt
     C                   PARM                    UTCAXR                         ExchRate
     C                   PARM                    UTCMDI                         MultDivInd
     C                   PARM                    UTFCCY                         FrCurrency
     C                   PARM                    CAFCCY                         ToCurrency
     C                   PARM                    UCCYDP                         FrDecPlace
     C                   PARM                    FCCYDP                         ToDecPlace
     C                   PARM                    WOUTAMT                        OutputAmnt
      *
     C                   EVAL      ACTAMT = WOUTAMT
      *
     C*                   ELSE
     C*                   EVAL      ACTAMT = UTUAMT
     C                   ENDIF
      *
     C                   EVAL      UTCFGI = *BLANKS
     C                   EVAL      UTFACT = CAFACT
     C                   EVAL      UTFCNO = CAFCNO
      *
     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  FmtDate - Call to 'ZDate2'                                   *
      *                                                               *
      *****************************************************************
     C     FmtDate       BEGSR
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANKS       ZADATE
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR - Subroutine to handle error conditions                *
      *                                                               *
      *  Called from:  After abnormal operation occurs                *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   RETURN
     C                   ENDSR
