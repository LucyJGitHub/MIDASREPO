     H DEBUG
     H COPYRIGHT('(c)Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT Report all Facilities to be Recalculated')    *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UTLE0850C - SQLRPGLE program that reports all facilties to   *
      *              be recalculated.                                 *
      *                                                               *
      *  Function: Generates report for the contents of UTLE0850PD    *
      *            which contains all facilties to be recalculated.   *
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
     FUTLE0850P3O    E             PRINTER OFLIND(*IN89)
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
      *
     D FCTY_TYPE       S              3A
     D FCTY_SEQ        S              2A
     D FCTY_TEMP       S              5S 0
     D FCTY_CHAR       S              5A
     D UTFCCY          S              3A   INZ(*BLANK)
     D UTMCCY          S              3A   INZ(*BLANK)
     D UTTRCA          S              2A   INZ(*BLANK)
      *
      ** DS FOR LEMNFUPD
      *
     D FCTY_DS       E DS                  EXTNAME(UTLE0850PD)
     D                                        QUALIFIED
      *
      ** PROGRAM START
      *
     C                   WRITE     HEADER1
      *
     C/EXEC SQL
     C+ DECLARE FCTYCursor CURSOR FOR
     C+ SELECT *
     C+ FROM UTLE0850PD
     C/END-EXEC

     C/EXEC SQL
     C+ Open FCTYCursor
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** FETCH FIRST RECORD
      *
     C/EXEC SQL
     C+ Fetch Next from FCTYCursor into :FCTY_DS
     C/END-EXEC
      *
      **
      *
     C                   EXSR      CountFcty
      *
      ** LOOP ALL FACILTIES
      *
     C                   DOW       SQLCODE = 0 AND FCTY_COUNT <> 0
      *
      ** APPLY LEADING ZEROES TO CORRECTLY SEPARATE FCLTY TYPE AND SEQ
      *
     C                   IF        FCTY_DS.UTFCTY <> 0
     C                   EVAL      FCTY_TEMP = %INT(FCTY_DS.UTFCTY)
     C                   MOVE      FCTY_TEMP     FCTY_CHAR

     C                   EVAL      FCTY_TYPE = %SUBST(FCTY_CHAR:1:3)
     C                   EVAL      FCTY_SEQ  = %SUBST(FCTY_CHAR:4:2)
     C                   ENDIF
      *
     C                   EXSR      GetFctyDetails
      *
      ** SET VALUES TO BE PRINTED
      *
     C                   IF        UTMCCY = 'Y'
     C                   EVAL      DPMCCY = 'YES'
     C                   ELSEIF    UTMCCY = 'N'
     C                   EVAL      DPMCCY = 'NO '
     C                   ENDIF
      *
     C                   IF        UTTRCA = 'TR'
     C                   EVAL      DPTRCA = 'TRANCHE'
     C                   ELSEIF    UTTRCA = 'CA'
     C                   EVAL      DPTRCA = 'CR.AGRMT'
     C                   ELSE
     C                   EVAL      DPTRCA = 'FACILITY'
     C                   ENDIF
      *
     C                   EVAL      DPBRCA = FCTY_DS.UTBRCA
     C                   EVAL      DPCNUM = FCTY_DS.UTCNUM
     C                   EVAL      DPFACT = FCTY_TYPE
     C                   EVAL      DPFCNO = FCTY_SEQ
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
     C/EXEC SQL
     C+ Fetch Next from FCTYCursor into :FCTY_DS
     C/END-EXEC
     C                   ENDDO

     C/EXEC SQL
     C+ CLOSE FCTYCursor
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
     C*     *Entry        PLIST
     C*                   PARM                    Mode              1
      *
     C                   EVAL      *IN12 = '0'
     C                   Z-ADD     0             PAGENO            2 0
     C                   Z-ADD     0             FCTY_COUNT        7 0
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
     C                   EVAL      DBPGM = 'UTLE0850C'                          * DBERR 001 *
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
      *  CountFcty -                                                  *
      *                                                               *
      *  Called from:                                                 *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     CountFcty     BEGSR
     C                   EVAL      FCTY_COUNT = 0
     C/EXEC SQL
     C+ SELECT COUNT(*) INTO :FCTY_COUNT
     C+ FROM UTLE0850PD
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        FCTY_COUNT = 0
     C                   EVAL      *IN12 = '1'
     C                   ENDIF
      *
     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  GetFctyDetails -                                             *
      *                                                               *
      *  Called from:                                                 *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     GetFctyDetailsBEGSR
      *
     C                   EVAL      UTMCCY = *BLANKS
     C                   EVAL      UTTRCA = *BLANKS
      *
     C/EXEC SQL
     C+ SELECT
     C+ FCCY,
     C+ MCCY,
     C+ TRCA
     C+ INTO
     C+ :UTFCCY,
     C+ :UTMCCY,
     C+ :UTTRCA
     C+ FROM FCLTYFM
     C+ WHERE RECI = 'D'
     C+ AND BRCA = :FCTY_DS.UTBRCA
     C+ AND CNUM = :FCTY_DS.UTCNUM
     C+ AND FACT = :FCTY_TYPE
     C+ AND FCNO = :FCTY_SEQ
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
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
