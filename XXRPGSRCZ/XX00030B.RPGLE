     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('FERAT Customer Lending Module Extract')                *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM030B*-*FERAT*Customer*Lending*Module*Extract***************                       LUC109
      *  XX00030B - FERAT Customer Lending Module Extract             *                       LUC109
      *                                                               *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
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
      *  Prev Amend No. MUI009             Date 24May04               *
      *                 221488             Date 24Sep03               *
      *                 167419             Date 11Nov99               *
      *                 MMI043             Date 08Jul99               *
      *                 MMI043             Date 08Jun99               *
      *                 MMI043 ** CREATE * Date 21Dec98               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MUI009 - R4.1 Upgrade - Exclude dummy Call Loans repayments. *
      *  221488 - Exclude Interbranch events.                         *
      *  167419 - Zeroise Installment Principal Amt (C0407) if        *
      *           Scheduled Principal Repayment (C0611) is '0', i.e.  *
      *           principal repayment at maturity                     *
      *  MMI043 - Do not include in report if no scheduled interest   *
      *           or principal repayment.                             *
      *  MMI043 - Balance Sheet Extract                               *
      *                                                               *
      *****************************************************************
      *                                                               *
     FLVENTLV0  IF   E           K DISK
      *                                                               *
     FFECCDDV0  UF   E           K DISK
     FSDBRCHV0  UF   E           K DISK
      *                                                               *
     FSDBANKPD  IF   E           K DISK    USROPN
     FSDGELRV0  IF   E           K DISK    USROPN
      *                                                               *
     FFERATDPP  O    E             DISK
     F***GLM030BU  O    E             PRINTER OFLIND(*IN20)                                   LUC109
     FXX000030BUO    E             PRINTER OFLIND(*IN20)                                      LUC109
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01 - LF/LVENTLV0 File Input                                 *
      *   02 - Record to be work for Interest Repayment               *
      *   03 - LF/FEECCDV0   File I                                   *
      *   03 - LF/SDBRCHV0   File I                                   *
      *   03 - LF/SDBANKPD   File I                                   *
      *   03 - LF/SDGELRV0   File I                                   *
      *   04 - Record to be work for Principal Repayment              *
      *                                                               *
      ****20*-*PRTF/GLM030BU*File*O*Overflow*indicator*****************                       LUC109
      *   20 - PRTF/XX000030BU File O Overflow indicator              *                       LUC109
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  MAIN   - Main Processing                                     *
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
     D                 DS
     D  DSETYP                 1      4
     D  ETYP12                 1      2
     D  ETYP33                 3      3
     D  ETYP34                 3      4
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
      *         SINTRE - Process for Interest Repayment               *
      *         SPRIRE - Process for Principal Repayment              *
      *                                                               *
      *****************************************************************
      *
     C     *LOVAL        SETLL     LVENTLV0
     C                   READ      LVENTLV0                               01
     C                   Z-ADD     LNRF          $LNRF             6 0
      *                                                                                   EFIXJM
     C     *IN01         DOWEQ     *OFF
      *                                                                   EFIXJM
      * Do not process Participations Sold and Guarantees.                EFIXJM
      * Do not process Interbranch events.                                221488
      * Do not process Dummy Call Loans repayments.                       MUI009
      *                                                                   EFIXJM
     C                   MOVE      ETYP          DSETYP                                        EFIXJ
      *                                                                   EFIXJM
     C     ETYP12        IFNE      '66'                                                        EFIXJ
     C     ETYP12        ANDNE     '67'                                                        EFIXJ
     C     ETYP12        ANDNE     '69'                                                        EFIXJ
     C     ETYP12        ANDNE     '70'                                                        EFIXJ
     C     ETYP12        ANDNE     '71'                                                        EFIXJ
     C     ETYP12        ANDNE     '72'                                                        EFIXJ
     C     IBRE          ANDNE     'Y'                                                         22148
     C     EDAT          ANDNE     *ZERO                                                       MUI00
      *
     C                   EXSR      CHKREC
     C                   RESET                   FERATDP0
      *
     C     *IN02         IFEQ      *ON
     C                   EXSR      SINTRE
     C                   ENDIF
     C     *IN04         IFEQ      *ON
     C                   EXSR      SPRIRE
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                      EFIXJM
     C                   READ      LVENTLV0                               01
      *
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
      *  SINTRE - Process for Interest Repayment                      *
      *                                                               *
      *  Called By: Main processing                                   *
      *  Calls: MOVFLD - Populate the fields of the output file       *
      **********XGLM46*-*Call*GLM046*-*Next*interest*date**************                       LUC109
      *         XGLM46 - Call XX000046 - Next interest date           *                       LUC109
      *         SC9002 - Populate the field C9002                     *
      *         SC0056 - Populate the field C0056                     *
      *         SI0407 - Populate the field C0407                     *
      *         SI5334 - Populate the field C5334                     *
      *                                                               *
      *****************************************************************
      *
     C     SINTRE        BEGSR
      *
     C                   EXSR      MOVFLD
     C     NOAMO         IFEQ      'Y'
     C                   GOTO      IREND
     C                   ENDIF
      *
     C                   EXSR      SC9002
     C                   EXSR      SC0056
     C                   EXSR      SI0407
     C                   EXSR      SI5334
      *
     C                   WRITE     FERATDP0
      *
     C     IREND         TAG
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SPRIRE - Process for Principal Repayment                     *
      *                                                               *
      *  Called By: Main processing                                   *
      *  Calls: MOVFLD - Populate the fields of the output file       *
      *         SC9002 - Populate the field C9002                     *
      *         SC0056 - Populate the field C0056                     *
      *         SP0407 - Populate the field C0407                     *
      *         SP5334 - Populate the field C5334                     *
      **********XGLM46*-*Call*GLM046*-*Next*interest*date**************                       LUC109
      *         XGLM46 - Call XX000046 - Next interest date           *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SPRIRE        BEGSR
      *
     C                   EXSR      MOVFLD
     C     NOAMO         IFEQ      'Y'
     C                   GOTO      PREND
     C                   ENDIF
      *
     C                   EXSR      SC9002
     C                   EXSR      SC0056
     C                   EXSR      SP0407
     C                   EXSR      SP5334
      *
     C                   WRITE     FERATDP0
      *
     C     PREND         TAG
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  MOVFLD - Populate the common fields of the output file       *
      *                                                               *
      *  Called By: Main processing                                   *
      *  Calls:     SC9003 - Populate the field C9003                 *
      *             SC9151 - Populate the field C9151                 *
      *                                                               *
      *****************************************************************
      *
     C     MOVFLD        BEGSR
      *
     C                   MOVEL(P)  'MOVFLD'      ERRSBR
      *
     C                   EXSR      SC9003
     C                   MOVE      EBRC          C0120
     C                   MOVE      CUNR          C5125
     C                   MOVEL     'LE '         C9149
     C                   MOVEL     LNRF          C9150
     C                   EXSR      SC9151
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
     C     EBRC          CHAIN(N)  SDBRCHV0                           03
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
      *
     C     C9339         IFEQ      '2'
     C                   MOVE      'Y'           NOAMO             1
     C                   ELSE
     C                   MOVE      'N'           NOAMO
     C                   ENDIF
      *
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
     C     $LNRF         IFNE      LNRF
     C                   Z-ADD     0             $COUNT
     C                   Z-ADD     LNRF          $LNRF
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
     C                   Z-ADD     EDAT          $$DAY
     C                   EXSR      XLM053
     C                   MOVE      $$DATE        C0056                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SP0407 - Populate the field C0407 for Principl process only  *
      *                                                               *
      *  Called By: MOVFLI                                            *
      ***Calls:*****XLM041*-*Calling*routine*GLM041*for*AM*field*conv.*                       LUC109
      *  Calls: XLM041 - Calling routine XX000041 for AM field conv.  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SP0407        BEGSR
      *
     C                   MOVEL(P)  'SP0407'      ERRSBR
      *
     C     C0611         IFEQ      '0'                                                         16741
     C                   Z-ADD     0             $$AMNT                                        16741
     C                   ELSE                                                                  16741
     C                   Z-ADD     EAMT          $$AMNT
     C                   END                                                                   16741
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0407                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SI0407 - Populate the field C0407 for Interest  process only *
      *                                                               *
      *  Called By: MOVFLP                                            *
      ***Calls:*****XLM041*-*Calling*routine*GLM041*for*AM*field*conv.*                       LUC109
      *  Calls: XLM041 - Calling routine XX000041 for AM field conv.  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SI0407        BEGSR
      *
     C                   MOVEL(P)  'SI0407'      ERRSBR
      *
     C                   RESET                   $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0407                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SP5334 - Populate the field C5334 for Principl process only  *
      *                                                               *
      *  Called By: MOVFLI                                            *
      ***Calls:*****XLM041*-*Calling*routine*GLM041*for*AM*field*conv.*                       LUC109
      *  Calls: XLM041 - Calling routine XX000041 for AM field conv.  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SP5334        BEGSR
      *
     C                   MOVEL(P)  'SP5334'      ERRSBR
      *
     C                   RESET                   $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C5334                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SI5334 - Populate the field C5334 for Interest  process only *
      *                                                               *
      *  Called By: MOVFLP                                            *
      ***Calls:*****XLM041*-*Calling*routine*GLM041*for*AM*field*conv.*                       LUC109
      *  Calls: XLM041 - Calling routine XX000041 for AM field conv.  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SI5334        BEGSR
      *
     C                   MOVEL(P)  'SP5334'      ERRSBR
      *
     C                   Z-ADD     EAMT          $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C5334                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  CHKREC - Check if the input record must be processed         *
      *                                                               *
      *  Called By: Main                                              *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     CHKREC        BEGSR
      *
     C                   MOVEL(P)  'CHKREC'      ERRSBR
      *
     C                   MOVE      *OFF          *IN02
     C                   MOVE      *OFF          *IN04
      *
     C                   MOVE      ETYP          DSETYP
     C     ETYP33        IFEQ      'I'
     C                   MOVE      *ON           *IN02
     C                   ENDIF
     C     ETYP34        IFEQ      'M2'
     C                   MOVE      *ON           *IN02
     C                   ENDIF
     C     ETYP33        IFEQ      'R'
     C     ETYP34        ANDNE     'R5'
     C                   MOVE      *ON           *IN04
     C                   ENDIF
     C     ETYP34        IFEQ      'M1'
     C                   MOVE      *ON           *IN04
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
     C                   MOVE      ECCY          $$CCYC
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
     C**********         RESET                   ERRD01                             LUC109
     C**********         RESET                   ERRD02                             LUC109
     C**********         RESET                   ERRD03                             LUC109
     C**********         RESET                   ERRD04                             LUC109
     C                   Move      *Blanks       ERRD01                             LUC109
     C                   Move      *Blanks       ERRD02                             LUC109
     C                   Move      *Blanks       ERRD03                             LUC109
     C                   Move      *Blanks       ERRD04                             LUC109
      *
     C                   SELECT
     C     COD           WHENEQ    2
     C                   MOVEL     EBRC          ERRD01
     C     COD           WHENEQ    3
     C                   MOVEL     C9150         ERRD01
     C                   MOVEL     C9149         ERRD02
     C     COD           WHENEQ    4
     C                   MOVEL     $$CCYC        ERRD01
     C                   MOVEL     $$AMNT        ERRD02
     C     COD           WHENEQ    5
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
     C                   READ      SDBANKD0                               03
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
