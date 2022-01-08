     H DEBUG
     H COPYRIGHT('(c)Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT Reverse all MFUs in FACHISA')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UTLE0850A - SQLRPGLE program that reverses utilisation       *
      *              records for live facilities in FACHISA.          *
      *                                                               *
      *  Function: Reverses all utilisation records for live          *
      *            facilities. 'US' records are then regenerated in   *
      *            UTLE0850B.                                         *
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
     FUTLE0850P1O    E             PRINTER OFLIND(*IN89)
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
      ** Data structure for Access Program
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)

     D FCTY_TYPE       S              3
     D FCTY_SEQ        S              2
     D FCTY_TEMP       S              5S 0

     D FACHISA_DS      DS
     D  Z_BRCA                        3A
     D  Z_FACNUM                      6A
     D  Z_FAFCTY                      5

     C                   WRITE     HEADER1
      *
      ** PART 1
      ** FLAG ALL FAREVI = 'R' FOR ALL US/UI/UD/UE UTILISATION RECORDS IN FACHISA
      ** FACILITY SHOULD BE LIVE IN FCLTYFM AND REVOLVING
      *
     C/EXEC SQL
     C+ Declare FACHISACursor cursor for
     C+ select DISTINCT FACHISA.BRCA,FACHISA.FACNUM,FACHISA.FAFCTY
     C+ FROM FACHISA
     C+ INNER JOIN FCLTYFM ON
     C+ FACHISA.FAFCTY = CONCAT(DIGITS(FCLTYFM.FACT), DIGITS(FCLTYFM.FCNO))
     C+ AND FACHISA.BRCA = FCLTYFM.BRCA
     C+ AND FACHISA.FACNUM = FCLTYFM.CNUM
     C+ AND FACHISA.FARECI = 'D'
     C+ AND FACHISA.FAREVI = ''
     C+ AND FACHISA.FARCIN = 'Y'
     C+ AND (FACHISA.FAACTN = 'US' OR FACHISA.FAACTN = 'UI'
     C+ OR FACHISA.FAACTN = 'UD' OR FACHISA.FAACTN = 'UE')
     C/END-EXEC

     C/EXEC SQL
     C+ Open FACHISACursor
     C/END-EXEC
      *
      ** FETCH FIRST RECORD
      *
     C/EXEC SQL
     C+ Fetch Next from FACHISACursor into :FACHISA_DS
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** GET COUNT OF DISTINCT FACILTIES
      *
     C                   EXSR      CountFacilties
      *
      ** IF NO RECORDS TO BE REPORTED, SHOW NO DETAILS
      *
     C                   IF        FCTY_COUNT = 0
     C                   EVAL      *IN12 = '1'
     C                   ENDIF
      *
      ** LOOPING OF ALL SELECTED RECORDS
      *
     C                   DOW       SQLCODE = 0

     C                   EXSR      CountUtils
      *
      ** APPLY LEADING ZEROES TO CORRECTLY SEPARATE FCLTY TYPE AND SEQ
      *
     C                   IF        Z_FAFCTY <> *BLANKS
     C                   EVAL      FCTY_TEMP = %INT(Z_FAFCTY)
     C                   MOVE      FCTY_TEMP     Z_FAFCTY

     C                   EVAL      FCTY_TYPE = %SUBST(Z_FAFCTY:1:3)
     C                   EVAL      FCTY_SEQ = %SUBST(Z_FAFCTY:4:2)
     C                   ENDIF
      *
      ** REVERSE UTILS AND TRIGGER RECALC IF UPDATE MODE
      *
     C                   IF        *IN16 = '1'
     C                   EXSR      ReverseUtils
     C                   EXSR      TriggerRecalc
     C                   ENDIF
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

     C/EXEC SQL
     C+ Fetch Next from FACHISACursor into :FACHISA_DS
     C/END-EXEC

     C                   ENDDO

     C/EXEC SQL
     C+ CLOSE FACHISACursor
     C/END-EXEC
      *
      ** PART 2
      ** FLAG ALL FAREVI = 'R' FOR ALL UD/UE UTILISATION RECORDS IN FACHISA
      ** WHERE FACILITY IS NON-REVOLVING AND EXISTS IN LEPFHAPD
      *
     C/EXEC SQL
     C+ Declare FACHISACursorNR cursor for
     C+ select DISTINCT FACHISA.BRCA,FACHISA.FACNUM,FACHISA.FAFCTY
     C+ FROM FACHISA
     C+ INNER JOIN FCLTYFM ON
     C+ FACHISA.FAFCTY = CONCAT(DIGITS(FCLTYFM.FACT), DIGITS(FCLTYFM.FCNO))
     C+ AND FACHISA.BRCA = FCLTYFM.BRCA
     C+ AND FACHISA.FACNUM = FCLTYFM.CNUM
     C+ AND FACHISA.FARECI = 'D'
     C+ AND FACHISA.FAREVI = ''
     C+ AND FACHISA.FARCIN = 'N'
     C+ AND (FACHISA.FAACTN = 'UD' OR FACHISA.FAACTN = 'UE')
     C/END-EXEC

     C/EXEC SQL
     C+ Open FACHISACursorNR
     C/END-EXEC
      *
      ** FETCH FIRST RECORD
      *
     C/EXEC SQL
     C+ Fetch Next from FACHISACursorNR into :FACHISA_DS
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** LOOPING OF ALL SELECTED RECORDS
      *
     C                   DOW       SQLCODE = 0
      *
      ** CHECK IF RECORD EXISTS IN LEPFHAPD
      *
     C                   EXSR      CheckLEPFHAPD
      *
      ** PROCESS RECORD IF FACILITY IS FOUND IN LEPFHAPD
      *
     C                   IF        PFHA_COUNT > 0
      *
      ** UPDATE COUNTS FOR REPORTING
      *
     C                   EXSR      CountUtilsNR
     C                   EXSR      ChkFctyCount
      *
      ** APPLY LEADING ZEROES TO CORRECTLY SEPARATE FCLTY TYPE AND SEQ
      *
     C                   IF        Z_FAFCTY <> *BLANKS
     C                   EVAL      FCTY_TEMP = %INT(Z_FAFCTY)
     C                   MOVE      FCTY_TEMP     Z_FAFCTY

     C                   EVAL      FCTY_TYPE = %SUBST(Z_FAFCTY:1:3)
     C                   EVAL      FCTY_SEQ = %SUBST(Z_FAFCTY:4:2)
     C                   ENDIF
      *
      ** REVERSE RECORDS AND TRIGGER RECALCUATION IF UPDATE MODE
      *
     C                   IF        *IN16 = '1'
     C                   EXSR      ReverseUtilsNR
     C                   EXSR      TriggerRecalc
     C                   ENDIF
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

     C                   ENDIF                                                  PFHA_COUNT > 0

     C/EXEC SQL
     C+ Fetch Next from FACHISACursorNR into :FACHISA_DS
     C/END-EXEC

     C                   ENDDO

     C/EXEC SQL
     C+ CLOSE FACHISACursorNR
     C/END-EXEC
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
     C                   Z-ADD     0             PAGENO           10 0
     C                   Z-ADD     0             PAGE             10 0
     C                   Z-ADD     0             UTIL_COUNT        7 0
     C                   Z-ADD     0             FCTY_COUNT        7 0
     C                   Z-ADD     0             PFHA_COUNT        7 0
     C                   Z-ADD     0             PROC_COUNT        7 0
     C                   Z-ADD     0             UTIL_TOTAL        7 0
     C                   Z-ADD     0             FS_DATE           5 0
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
     C                   Z-ADD     0             PAGENO
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
     C                   EVAL      DBPGM = 'UTLE0850A'                          * DBERR 001 *
     C                   EVAL      DBASE = 001                                  *************
     C                   OUT       LDA
     C                   WRITE     HEADER1
     C                   WRITE     DBERROR1
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  ReverseUtils - Reverses Revolving Credit Facility            *
      *                 utilisations from cursor.                     *
      *                                                               *
      *  Called from: Main                                            *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     ReverseUtils  BEGSR
                                                                                              `
     C/EXEC SQL
     C+ UPDATE FACHISA SET FAREVI = 'R'
     C+ WHERE BRCA = :Z_BRCA
     C+ AND FACNUM = :Z_FACNUM
     C+ AND FAFCTY = :Z_FAFCTY
     C+ AND FACHISA.FARECI = 'D'
     C+ AND FACHISA.FAREVI = ''
     C+ AND FACHISA.FARCIN = 'Y'
     C+ AND (FACHISA.FAACTN = 'US' OR FACHISA.FAACTN = 'UE'
     C+ OR FACHISA.FAACTN = 'UI' OR FACHISA.FAACTN = 'UD')
     C/END-EXEC

     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  ReverseUtilsNR - Reverses Non-Revolving Credit Facility      *
      *                   utilisations from cursor.                   *
      *                                                               *
      *  Called from: Main                                            *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     ReverseUtilsNRBEGSR

     C/EXEC SQL
     C+ UPDATE FACHISA SET FAREVI = 'R'
     C+ WHERE BRCA = :Z_BRCA
     C+ AND FACNUM = :Z_FACNUM
     C+ AND FAFCTY = :Z_FAFCTY
     C+ AND FACHISA.FARECI = 'D'
     C+ AND FACHISA.FAREVI = ''
     C+ AND FACHISA.FARCIN = 'N'
     C+ AND (FACHISA.FAACTN = 'UD' OR FACHISA.FAACTN = 'UE')
     C/END-EXEC

     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  CountUtils - Counts all Revolving Facility utilisations to   *
      *               be processed.                                   *
      *                                                               *
      *  Called from: Main                                            *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     CountUtils    BEGSR

     C                   EVAL      UTIL_COUNT = 0
     C/EXEC SQL
     C+ SELECT COUNT(*) INTO :UTIL_COUNT
     C+ FROM FACHISA
     C+ WHERE BRCA = :Z_BRCA
     C+ AND FACNUM = :Z_FACNUM
     C+ AND FAFCTY = :Z_FAFCTY
     C+ AND FACHISA.FARECI = 'D'
     C+ AND FACHISA.FAREVI = ''
     C+ AND FACHISA.FARCIN = 'Y'
     C+ AND (FACHISA.FAACTN = 'US' OR FACHISA.FAACTN = 'UE'
     C+ OR FACHISA.FAACTN = 'UI' OR FACHISA.FAACTN = 'UD')
     C/END-EXEC

     C                   EVAL      UTIL_TOTAL = UTIL_TOTAL + UTIL_COUNT

     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  CountUtilsNR - Counts all Non-Revolving Facility utilisations*
      *                 to be processed.                              *
      *                                                               *
      *  Called from: Main                                            *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     CountUtilsNR  BEGSR

     C                   EVAL      UTIL_COUNT = 0
     C/EXEC SQL
     C+ SELECT COUNT(*) INTO :UTIL_COUNT
     C+ FROM FACHISA
     C+ WHERE BRCA = :Z_BRCA
     C+ AND FACNUM = :Z_FACNUM
     C+ AND FAFCTY = :Z_FAFCTY
     C+ AND FACHISA.FARECI = 'D'
     C+ AND FACHISA.FAREVI = ''
     C+ AND FACHISA.FARCIN = 'N'
     C+ AND (FACHISA.FAACTN = 'UD' OR FACHISA.FAACTN = 'UE')
     C/END-EXEC

     C                   EVAL      UTIL_TOTAL = UTIL_TOTAL + UTIL_COUNT

     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  CountFacilties - Counts distinct facilities to be processed. *
      *                                                               *
      *  Called from: Main                                            *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     CountFaciltiesBEGSR

     C/EXEC SQL
     C+ SELECT COUNT(*) INTO :FCTY_COUNT FROM
     C+ (SELECT DISTINCT FACHISA.BRCA,FACHISA.FACNUM,FACHISA.FAFCTY
     C+ FROM FACHISA
     C+ INNER JOIN FCLTYFM ON
     C+ FACHISA.FAFCTY = CONCAT(DIGITS(FCLTYFM.FACT), DIGITS(FCLTYFM.FCNO))
     C+ AND FACHISA.BRCA = FCLTYFM.BRCA
     C+ AND FACHISA.FACNUM = FCLTYFM.CNUM
     C+ AND FACHISA.FARECI = 'D'
     C+ AND FACHISA.FAREVI = ''
     C+ AND FACHISA.FARCIN = 'Y'
     C+ AND (FACHISA.FAACTN = 'US' OR FACHISA.FAACTN = 'UE'
     C+ OR FACHISA.FAACTN = 'UI' OR FACHISA.FAACTN = 'UD')) AS A
     C/END-EXEC

     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  CheckLEPFHAPD - Check if non-revolving facility exists in    *
      *                  LEPFHAPD.                                    *
      *                                                               *
      *  Called from: Main                                            *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     CheckLEPFHAPD BEGSR

     C                   EVAL      PFHA_COUNT = 0
     C/EXEC SQL
     C+ SELECT COUNT(*) INTO :PFHA_COUNT FROM LEPFHAPD
     C+ WHERE DUPBRC = :Z_BRCA
     C+ AND DUPNUM = :Z_FACNUM
     C+ AND DUPFAC = :Z_FAFCTY
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  TriggerRecalc - Updates 2 files to recalc in COB             *
      *                                                               *
      *  Called from: Main                                            *
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
     C+ AND FARECI = 'D'
     C+ AND BRCA = :Z_BRCA
     C+ AND FACNUM = :Z_FACNUM
     C+ AND FAFCTY = :Z_FAFCTY
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
     C+ WHERE FHBRCH = :Z_BRCA AND
     C+ FHCNUM = :Z_FACNUM AND
     C+ FHFTYP = :FCTY_TYPE AND
     C+ FHFSEQ = :FCTY_SEQ
     C/END-EXEC

     C                   IF        SQLCODE = 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBFILE = 'FACHISH'
     C*                  EVAL      FACNUM_CHAR = %EDITC(US_FACNUM:'X')
     C                   EVAL      DBKEY = Z_BRCA+'-'+Z_FACNUM+'-'+Z_FAFCTY
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

      * UPDATE FACACT

     C/EXEC SQL
     C+ UPDATE FACACT SET
     C+ FCDATE = :FS_DATE
     C+ WHERE BRCA = :Z_BRCA AND
     C+ FCCNUM = :Z_FACNUM AND
     C+ FCFCTY = :Z_FAFCTY
     C/END-EXEC

      * IF NOT FOUND, INSERT RECORD INTO FACACT

     C                   IF        SQLCODE = 100
     C/EXEC SQL
     C+ INSERT INTO FACACT
     C+ VALUES (:Z_BRCA,
     C+ :Z_FACNUM,
     C+ :Z_FAFCTY,
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
     C+ VALUES (:Z_BRCA,
     C+ :Z_FACNUM,
     C+ :Z_FAFCTY)
     C/END-EXEC
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
      *  ChkFctyCount - Check if a revolving facility is already      *
      *                 processed before incrementing  to FCTY_COUNT  *
      *                                                               *
      *  Called from:                                                 *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     ChkFctyCount  BEGSR
      *
     C                   EVAL      PROC_COUNT = 0
     C/EXEC SQL
     C+ SELECT COUNT(*) INTO :PROC_COUNT
     C+ FROM FACHISA
     C+ WHERE FACHISA.BRCA = :Z_BRCA
     C+ AND FACHISA.FACNUM = :Z_FACNUM
     C+ AND FACHISA.FAFCTY = :Z_FAFCTY
     C+ AND FACHISA.FARCIN = 'Y'
     C+ AND (FACHISA.FAACTN = 'UD' OR FACHISA.FAACTN = 'UE')
     C/END-EXEC
      *
     C                   IF        PROC_COUNT = 0
     C                   EVAL      FCTY_COUNT = FCTY_COUNT + 1
     C                   ENDIF
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
