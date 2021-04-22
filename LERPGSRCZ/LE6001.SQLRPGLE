     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE APR CLOANCL Extension file Take On')          *
      *****************************************************************
      *                                                               *
      *   Midas - Customer Lending Module                             *
      *                                                               *
      *  LE6001 - Midas LE APR CLOANCL Extension file Take On         *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050  *Create    Date 16Jun19               *
      *                 nnnnnn             DATE ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  CER050 - Annualised Percentage Rate (APR)                    *
      *                                                               *
     F*****************************************************************
      *
      * Array containing Copyright statement
     D ARRCPY          S             80    DIM(1) CTDATA PERRCD(1)
      *
      * External DS for Midas LE New matured loans file details
     D MCLON         E DS                  EXTNAME(MCLONCL)
     D                                     PREFIX(M_)
      *
      * External DS for Midas LE Customer loans
     D CLOAN         E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(C_)
      *
      * External DS for Additional Customer Details
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      *
      * DS for access programs, very long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
     D LDA            UDS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      * DS for AOSVALR0
     D P@VL01          DS           200
     D  SVAL11                 1      1
      *
      * AOSVALR0 key for Deposit Interest Retention Period
     D SVALKK          C                   CONST('APRLELoans')
      *
     D P_CNUM          S              6
     D P_APRC          S              1
     D P_LNRF          S              6
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            M A I N   P R O C E S S I N G                      *
      *                                                               *
      * Calls: SRMAIN - Initial processing                            *
      *                                                               *
      *****************************************************************
      *
      * Set up copyright parameter
     C                   MOVEA     ARRCPY        WCPY             80
      *
      * Initialisation process
     C                   EXSR      SRINIT
      *
      * Process records in MCLONCL
     C                   EXSR      ProcMCLON
      *
      * Process records in CLOANCL
     C                   EXSR      ProcCLOAN
      *
     C                   SETON                                        LR
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * ProcMCLON - Process MCLONCL records                           *
      * Calls:                                                        *
      * Called by: Main Processing                                    *
      *****************************************************************
      *
     C     ProcMCLON     BEGSR
      *
      ** Set file pointer to first record of MCLONCL
      *
     C/exec SQL
     C+ declare LIST1 cursor for
     C+ select * from MCLONCL
     C/end-exec
      *
     C/exec SQL
     C+ open LIST1
     C/end-exec
      *
      ** Handle SQL Error (If not %EOF)
     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   Eval      DBASE = 1
     C                   Eval      DBFILE = 'SQL STM'
     C                   Eval      DBKEY  = 'SQLSTT : ' + SQLSTT
     C                                    + '; SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from LIST1
     C+ into: MCLON
     C/end-exec
      *
     C                   DOW       SQLCode <> 100
      *
     C                   Eval      P_LNRF = M_LNRF
      *
      * Perform further processing when APRLELoans system value is 'Y'
     C                   IF        @SYSV = 'Y'
      ** check APR flag for the customer
     C                   Eval      P_CNUM = M_CNUM
     C                   EXSR      SRSAPR
     C                   Else
     C                   Eval      P_APRC = 'N'
     C                   Endif
      *
     C/exec SQL
     C+ update MCLONCL set PREM = 0,
     C+ APRC = :P_APRC
     C+ where LNRF = :P_LNRF
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LIST1
     C+ into: MCLON
     C/end-exec
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ProcCLOAN - Process CLOANCL records                           *
      * Calls:                                                        *
      * Called by: Main Processing                                    *
      *****************************************************************
      *
     C     ProcCLOAN     BEGSR
      *
      ** Set file pointer to first record of MCLONCL
      *
     C/exec SQL
     C+ declare LIST2 cursor for
     C+ select * from CLOANCL
     C/end-exec
      *
     C/exec SQL
     C+ open LIST2
     C/end-exec
      *
      ** Handle SQL Error (If not %EOF)
     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   Eval      DBASE = 1
     C                   Eval      DBFILE = 'SQL STM'
     C                   Eval      DBKEY  = 'SQLSTT : ' + SQLSTT
     C                                    + '; SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from LIST2
     C+ into: CLOAN
     C/end-exec
      *
     C                   DOW       SQLCode <> 100
      *
     C                   Eval      P_LNRF = C_LNRF
      *
      * Perform further processing when APRLELoans system value is 'Y'
     C                   IF        @SYSV = 'Y'
      ** check APR flag for the customer
     C                   Eval      P_CNUM = C_CNUM
     C                   EXSR      SRSAPR
     C                   Else
     C                   Eval      P_APRC = 'N'
     C                   Endif
      *
     C/exec SQL
     C+ update CLOANCL set PREM = 0,
     C+ APRC = :P_APRC
     C+ where LNRF = :P_LNRF
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LIST2
     C+ into: CLOAN
     C/end-exec
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSAPR - Set APR flag                                         *
      * Calls:                                                        *
      * Called by: SRMAIN                                             *
      *****************************************************************
      *
     C     SRSAPR        BEGSR
      *
      * Check for APR flag on Additional Customer Details
     C                   MOVE      P_CNUM        @CNUMA            6
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CNUMA
     C     SDACUS        PARM      SDACUS        DSLDY
      *
      * If Additional Customer details not found or if flag is blank
      * default Loan APR flag to 'Y'
     C     P@RTCD        IFNE      *BLANKS
     C     E5APRC        OREQ      *BLANKS
     C                   MOVE      'Y'           P_APRC
     C                   ELSE
     C                   MOVE      E5APRC        P_APRC
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initial processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      * Retrieve system values for 'APRLELoans'
     C                   CALL      'AOSVALR0'
     C                   PARM                    P@RTCD            7
     C                   PARM      SVALKK        P@OP01           20
     C                   PARM                    P@VL01          200
     C                   PARM      *BLANKS       P@OP02           20
     C                   PARM                    P@VL02          200
     C                   PARM      *BLANKS       P@OP03           20
     C                   PARM                    P@VL03          200
     C                   PARM      *BLANKS       P@OP04           20
     C                   PARM                    P@VL04          200
     C                   PARM      *BLANKS       P@OP05           20
     C                   PARM                    P@VL05          200
     C                   PARM      *BLANKS       P@OP06           20
     C                   PARM                    P@VL06          200
     C                   PARM      *BLANKS       P@OP07           20
     C                   PARM                    P@VL07          200
     C                   PARM      *BLANKS       P@OP08           20
     C                   PARM                    P@VL08          200
     C                   PARM      *BLANKS       P@OP09           20
     C                   PARM                    P@VL09          200
     C                   PARM      *BLANKS       P@OP10           20
     C                   PARM                    P@VL10          200
      *
      * APR Retail Accounts system value not found
     C     P@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDSVALPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     SVALKK        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      SVAL11        @SYSV             1
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE6001'      DBPGM
      *
     C                   ENDSR
      *
     C*****************************************************************
     C/EJECT
     C*****************************************************************
      *                                                               *
      * *PSSR - Error handling subroutine                             *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   ENDSR
     C*****************************************************************
** ARRCPY
(c) Finastra International Limited 2016
