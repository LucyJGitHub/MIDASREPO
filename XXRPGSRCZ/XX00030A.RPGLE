     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('FERAT Dealing Module Extract')                         *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM030A*-*FERAT*Dealing*Module*Extract************************                       LUC109
      *  XX00030A - FERAT Dealing Module Extract                      *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: Balance sheet Extract                              *
      *                                                               *
      *                                                               *
      ***CALLED*BY**GLCM043*-*Head*Office*reporting*extract*file*******                       LUC109
      *  Called By XXC000043 - Head Office reporting extract file     *                       LUC109
      *                       creation component                      *
      *                                                               *                       LUC109
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1993,*1994**************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend NO. MMI043             Date 21Dec98               *
      *                 nnnnnn             Date ddMmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MMI043 - Balance Sheet Extract                               *
      *                                                               *
      *****************************************************************
      *                                                               *
     FDEALSCV1  IF   E           K DISK
      *                                                               *
     FFECCDDV0  UF   E           K DISK
     FSDBRCHV0  UF   E           K DISK
      *                                                               *
     FSDBANKPD  IF   E           K DISK    USROPN
     FSDGELRV0  IF   E           K DISK    USROPN
      *                                                               *
     FFERATDPP  O    E             DISK
     F***GLM030AU  O    E             PRINTER OFLIND(*IN20)                                   LUC109
     FXX000030AUO    E             PRINTER OFLIND(*IN20)                                      LUC109
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01 - LF/DEALSCV1   File I                                   *
      *   03 - LF/FEECCDV0   File I                                   *
      *   03 - LF/SDBRCHV0   File I                                   *
      *   03 - LF/SDBANKPD   File I                                   *
      *   03 - LF/SDGELRV0   File I                                   *
      *                                                               *
      ****20*-*PRTF/GLM027PT*File*O*Overflow*indicator*****************                       LUC109
      *   20 - PRTF/XX00030AU File O Overflow indicator               *                       LUC109
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  MAIN   - Main Processing                                     *
      ***XGLM46*-*Call*GLM046*-*Next*interest*date*********************                       LUC109
      *  XGLM46 - Call XX000046 - Next interest date                  *                       LUC109
      *  CHKREC - Check if the input record must be processed         *
      *  MOVFLD - Populate all the fields of the output file          *
      ***XLM053*-*Calling*Routine*GLM053*for*date*conversion***********                       LUC109
      *  XLM053 - Calling Routine XX000053 for date conversion        *                       LUC109
      ***XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conversion***                       LUC109
      *  XLM041 - Calling Routine XX000041 for AM data type conversion*                       LUC109
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *     All the following subroutines populate the corresponding  *
      *     field name                                                *
      *                                                               *
      *  SC9003 - Populate the field C9003                            *
      *  SC9151 - Populate the field C9151                            *
      *  SC9002 - Populate the field C9002                            *
      *  SC0056 - Populate the field C0056                            *
      *  SC0407 - Populate the field C0407                            *
      *  SC5334 - Populate the field C5334                            *
      *                                                               *
      *****************************************************************
      *
     D MSG             S             30    DIM(10) CTDATA PERRCD(1)
      *
     IFECCDDP0
     I              C9003                       C9003$
     I              C0120                       C0120$
     I              C5125                       C5125$
     I              C9149                       C9149$
     I              C9150                       C9150$
     I              C9151                       C9151$
     I              C5334                       C5334$
      *
      *****************************************************************
      *                                                               *
      *  MAIN   - Main processing                                     *
      *                                                               *
      *  Called By:                                                   *
      *  Calls: CHKREC - Check if the input record must be processed  *
      *         MOVFLD - Populate the commn flds. output file         *
      **********XGLM46*-*Call*GLM046*-*Next*interest*date**************                       LUC109
      *         XGLM46 - Call XX000046 - Next interest date           *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     *LOVAL        SETLL     DEALSCV1
     C                   READ      DEALSCV1                               01
     C                   Z-ADD     DLNO          $DLNO             6 0
     C                   Z-ADD     SLID          @NEXID
      *
     C     *IN01         DOWEQ     *OFF
      *
     C                   EXSR      CHKREC
     C                   RESET                   FERATDP0
      *
     C     *IN02         DOWEQ     *OFF
     C                   EXSR      MOVFLD
      *
     C****       ERRMSG    IFEQ *BLANK
     C                   WRITE     FERATDP0
     C****                 ENDIF
      *
     C                   EXSR      XGLM46
     C     @NEXID        IFGE      MDAT
     C                   MOVE      *ON           *IN02
     C                   ENDIF
     C                   ENDDO
      *
     C                   READ      DEALSCV1                               01
     C                   Z-ADD     SLID          @NEXID
     C                   ENDDO
      *
     C     *IN20         IFEQ      *ON
     C                   WRITE     HEADAU
     C                   WRITE     COLUMS
     C                   MOVE      *OFF          *IN20
     C                   ENDIF
     C                   WRITE     ENDREC
      *
     C                   MOVE      *ON           *INLR
      *
      *****************************************************************
      *                                                               *
      *  MOVFLD - Populate the common fields of the output file       *
      *                                                               *
      *  Called By: Main processing                                   *
      *  Calls:     SC9003 - Populate the field C9003                 *
      *             SC9151 - Populate the field C9151                 *
      *             SC9002 - Populate the field C9002                 *
      *             SC0056 - Populate the field C0056                 *
      *             SC0407 - Populate the field C0407                 *
      *             SC5334 - Populate the field C5334                 *
      *                                                               *
      *****************************************************************
      *
     C     MOVFLD        BEGSR
      *
     C                   MOVEL(P)  'MOVFLD'      ERRSBR
      *
     C                   EXSR      SC9002
      *
      ** The following sub-routine are execute only on the first cycle
      *
     C     $COUNT        IFEQ      1
     C                   EXSR      SC9003
     C                   Z-ADD     CNUM          C5125
     C                   MOVE      BRCA          C0120
     C*                    MOVE 'MM'      C9149
     C                   MOVEL     'MM '         C9149
     C                   MOVEL     DLNO          C9150
     C                   EXSR      SC9151
     C                   EXSR      SC0407
     C                   ENDIF
      *
      ** The following routine are execute each time
      *
     C                   EXSR      SC0056
     C                   EXSR      SC5334
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9003 - Populate the field C9003                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     SC9003        BEGSR
      *
     C                   MOVEL(P)  'SC9003'      ERRSBR
      *
     C                   RESET                   SDBRCHD0
     C     BRCA          CHAIN(N)  SDBRCHV0                           03
      *
     C     *IN03         IFEQ      *OFF
     C                   MOVE      A8CMCD        C9003
     C                   ELSE
     C                   Z-ADD     2             COD
     C                   EXSR      PRINT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9151 - Populate the field C9151                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     SC9151        BEGSR
      *
     C                   MOVEL(P)  'SC9151'      ERRSBR
      *
     C                   RESET                   FECCDDP0
     C     K1CCD         CHAIN(N)  FECCDDV0                           03
      *
     C     *IN03         IFEQ      *OFF
     C                   MOVE      C9151$        C9151
     C                   ELSE
     C                   Z-ADD     3             COD
     C                   EXSR      PRINT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9002 - Populate the field C9002                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC9002        BEGSR
      *
     C                   MOVEL(P)  'SC9002'      ERRSBR
      *
     C     $DLNO         IFNE      DLNO
     C                   Z-ADD     0             $COUNT
     C                   Z-ADD     DLNO          $DLNO
     C                   ENDIF
      *
     C                   ADD       1             $COUNT
     C                   Z-ADD     $COUNT        C9002                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0056 - Populate the field C0056                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*****XLM053*-*Calling*routine*GLM053*for*date*conv.*****                       LUC109
      *  Calls:     XLM053 - Calling routine XX000053 for date conv.  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0056        BEGSR
      *
     C                   MOVEL(P)  'SC0056'      ERRSBR
      *
     C                   Z-ADD     @NEXID        $$DAY
     C                   EXSR      XLM053
     C                   MOVE      $$DATE        C0056                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0407 - Populate the field C0407                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*****XLM041*-*Calling*routine*GLM041*for*AM*field*conv.*                       LUC109
      *  Calls: XLM041 - Calling routine XX000041 for AM field conv.  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0407        BEGSR
      *
     C                   MOVEL(P)  'SC0407'      ERRSBR
      *
     C                   RESET                   $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0407                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC5334 - Populate the field C5334                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*****XLM041*-*Calling*routine*GLM041*for*AM*field*conv.*                       LUC109
      *  Calls: XLM041 - Calling routine XX000041 for AM field conv.  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC5334        BEGSR
      *
     C                   MOVEL(P)  'SC5334'      ERRSBR
      *
      ** Populate the routine parameters
      **    @SLID and @NEXID have the same value of the relative
      **    XX000047 routine parameters                                                       LUC109
      ******GLM047*routine*parameters**********************************                       LUC109
      *
     C                   Z-ADD     PCPL          @PCPL
     C                   Z-ADD     INTR          @INTR
     C                   MOVEL     ICBS          @ICBS
     C                   RESET                   @IINAM
      *
     C**********         CALL      'GLM047'                                     Parameters    LUC109
     C                   CALL      'XX000047'                                   Parameters    LUC109
     C                   PARM                    @PCPL            13 0          Principal
     C                   PARM                    @INTR            13 9          Int. rate
     C                   PARM                    @SLID             5 0          Start date
     C                   PARM                    @NEXID            5 0          Next Int.Day
     C                   PARM                    @ICBS             1            Int.calc.basis
     C                   PARM                    @IINAM           13 0          Inst.Int.Am.
      *
     C                   Z-ADD     @IINAM        $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C5334                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  CHKREC - Check if the input record must be processed         *
      *                                                               *
      *  Called By: Main processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     CHKREC        BEGSR
      *
     C                   MOVEL(P)  'CHKREC'      ERRSBR
      *
     C                   MOVE      *ON           *IN02
      *
     C     RECI          IFEQ      'D'
     C                   MOVE      *OFF          *IN02
     C                   ELSE
     C     RECI          IFEQ      'M'
     C     RECI          OREQ      'N'
     C     MDAT          IFGT      MPEMB
     C                   MOVE      *OFF          *IN02
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      XGLM46
     C     @NEXID        IFGE      MDAT
     C                   MOVE      *ON           *IN02
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      ***XGLM46*-*Call*GLM046*-*Next*interest*date*********************                       LUC109
      *  XGLM46 - Call XX000046 - Next interest date                  *                       LUC109
      *                                                               *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     XGLM46        BEGSR
      *
     C                   MOVEL(P)  'XGLM46'      ERRSBR
      *
      ** Populate routine parameters
      *
     C                   MOVEL     IPFR          @IPFR
     C                   MOVE      CCY           @CCY
     C                   RESET                   @MDAY
     C                   RESET                   @LOC
      *
      ** The start date is populate with the last Interest date
      *******calculated*from*the*routine*GLM046.**The*first*time*******                       LUC109
      **     calculated from the routine XX000046. The first time                             LUC109
      **     the Interest date contain the Start date (DEALSDC - SLID)
      *
     C                   Z-ADD     @NEXID        @SLID
     C                   RESET                   @NEXID
      *
     C**********         CALL      'GLM046'                                     Parameters    LUC109
     C                   CALL      'XX000046'                                   Parameters    LUC109
     C                   PARM                    @IPFR             1            Int.paym.frq
     C                   PARM                    @SLID             5 0          Start date
     C                   PARM                    @MDAY             2 0          Day of Mth
     C                   PARM                    @CCY              3            Currency
     C                   PARM                    @LOC              3            Locn-optionl
     C                   PARM                    @RETRN            7            Return Code
     C                   PARM                    @NEXID            5 0          Next Int.Day
      *
     C     @RETRN        IFNE      *BLANKS
     C                   Z-ADD     5             COD
     C                   EXSR      PRINT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      ***XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conversion***                       LUC109
      *  XLM041 - Calling Routine XX000041 for AM data type conversion*                       LUC109
      *                                                               *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     XLM041        BEGSR
      *
     C                   MOVE      CCY           $$CCYC
     C                   RESET                   $$CAMT
      *
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    $$CCYC            3            Currency code
     C                   PARM                    $$AMNT           15 0          Amount
     C                   PARM                    $$CAMT           19            Converted amnt
     C                   PARM                    $$EROR            1            Error indicator
      *
     C     $$EROR        IFEQ      'Y'
     C                   Z-ADD     4             COD
     C                   EXSR      PRINT
     C                   ENDIF
      *
     C                   RESET                   $$AMNT
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      ***XLM053*-*Calling*Routine*GLM053*for*date*conversion***********                       LUC109
      *  XLM053 - Calling Routine XX000053 for date conversion        *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     XLM053        BEGSR
      *
     C                   MOVEL(P)  'XLM053'      ERRSBR
      *
     C                   RESET                   $$DATE
      *
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    $$DAY             5 0
     C                   PARM                    $$DATE            8 0
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  PRINT  - Print Error                                         *
      *                                                               *
      *****************************************************************
      *
     C     PRINT         BEGSR
      *
     C                   Z-ADD     COD           COD               2 0
      *
     C                   MOVEL(P)  MSG(COD)      ERRMSG
     C                   RESET                   ERRD01
     C                   RESET                   ERRD02
     C                   RESET                   ERRD03
     C                   RESET                   ERRD04
      *
     C                   SELECT
     C     COD           WHENEQ    2
     C                   MOVEL     BRCA          ERRD01
     C     COD           WHENEQ    3
     C                   MOVEL     C9150         ERRD01
     C                   MOVEL     C9149         ERRD02
     C     COD           WHENEQ    4
     C                   MOVEL     $$CCYC        ERRD01
     C                   MOVEL     $$AMNT        ERRD02
     C     COD           WHENEQ    5
     C                   MOVEL     @IPFR         ERRD01
     C                   MOVEL     @SLID         ERRD02
     C     COD           WHENEQ    6
     C     COD           WHENEQ    7
     C     COD           WHENEQ    8
     C     COD           WHENEQ    9
     C     COD           WHENEQ    10
     C                   ENDSL
      *
     C     *IN20         IFEQ      *ON
     C                   WRITE     HEADAU
     C                   WRITE     COLUMS
     C                   MOVE      *OFF          *IN20
     C                   ENDIF
     C                   WRITE     ERRORS
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C                   MOVEL(P)  '*INZSR'      ERRSBR
      *
     C                   WRITE     HEADAU
     C                   WRITE     COLUMS
      *
      ** Read file SDBANK
      *
     C                   OPEN      SDBANKPD
     C                   READ      SDBANKD0                               03                 LRLR
     C                   CLOSE     SDBANKPD
      *
     C     *IN03         IFEQ      *ON
     C                   Z-ADD     7             COD
     C                   EXSR      PRINT
     C                   ENDIF
      *
      ** Read file SDGELR
      *
     C                   OPEN      SDGELRV0
     C                   READ      SDGELRV0                               03                 LRLR
     C                   CLOSE     SDGELRV0
      *
     C     *IN03         IFEQ      *ON
     C                   Z-ADD     8             COD
     C                   EXSR      PRINT
     C                   ENDIF
      *
      ** Exiting program if SDGELR or SDBANK access failed
      *
     C     COD           IFNE      0
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      ** Klist to access file FECCD
      *
     C     K1CCD         KLIST
     C                   KFLD                    C9150
     C                   KFLD                    C9149
      *
      ** False Update (only to deRESETe file in Update in order to run
      **       reset statement)
      *
     C     *IN90         IFEQ      *ON
     C     *IN90         ANDEQ     *OFF
     C                   UPDATE    SDBRCHD0                             90
     C                   UPDATE    FECCDDP0                             90
     C                   ENDIF
      *
      ** Set Working field
      *
     C                   Z-ADD     0             $COUNT            4 0
      *
     C                   ENDSR
**
1
SDBRCHV0 RECORD NOT FOUND
FECCDDV1 RECORD NOT FOUND
ERROR FOUND CALLING XX000041
ERROR FOUND CALLING XX000046
6
7
8
9
10
