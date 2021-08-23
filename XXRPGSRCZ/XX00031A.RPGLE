     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('FEPOL File Extract')                                   *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM031A*-*FEPOL*File*Extract**********************************                       LUC109
      *  XX00031A - FEPOL File Extract                                *                       LUC109
      *                                                               *                       LUC109
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
      *  Prev Amend No. MUI002             Date 24Dec99               *
      *                 MMI043             Date 21Dec98               *
      *                 nnnnnn             Date ddMmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MUI002 - HOR Extract of Rediscount of Discounted Financial   *
      *           Bills.  Avoid 'HP' transaction be extracted to      *
      *           the POL file.                                       *
      *  MMI043 - Balance Sheet Extract                               *
      *                                                               *
      *****************************************************************
      *                                                               *
     FCLOANCY1  IF   E           K DISK
      *                                                               *
     FCLOANCV0  UF   E           K DISK
     F                                     RENAME(CLOANCLF:CLOANCL0)
     FCLOANCV1  UF   E           K DISK
     F                                     RENAME(CLOANCLF:CLOANCL1)
     FSDBRCHV0  UF   E           K DISK
     FFECCDDV0  UF   E           K DISK
      *                                                               *
     FSDBANKPD  IF   E           K DISK    USROPN
     FSDGELRV0  IF   E           K DISK    USROPN
      *                                                               *
     FFEPOLDPP  O    E             DISK
     F***GLM031AU  O    E             PRINTER OFLIND(*IN20)                                   LUC109
     FXX000031AUO    E             PRINTER OFLIND(*IN20)                                      LUC109
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01 - LF/CLOANCY1   File I                                   *
      *   03 - LF/CLOANCV0   File I                                   *
      *   04 - LF/CLOANCV1   File I                                   *
      *                                                               *
      *   LR - LF/SDBANKPD   File I                                   *
      *   LR - LF/SDGELRPP   File I                                   *
      *                                                               *
      ****20*-*PRTF/GLM031AU*File*O*Overflow*indicator*****************                       LUC109
      *   20 - PRTF/XX000031AU File O Overflow indicator              *                       LUC109
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  MAIN   - Main Processing                                     *
      *  CHKREC - Check if the input record must be processed         *
      *  MOVFLD - Populate all the fields of the output file          *
      *                                                               *
      *     All the following subroutines populate the corresponding  *
      *     field name                                                *
      *                                                               *
      *  SC9003 - Populate the field C9003                            *
      *  SC9151 - Populate the field C9154                            *
      *  SC9002 - Populate the field C9173                            *
      *  SC9007 - Populate the field C9100                            *
      *                                                               *
      ***XLM053*-*Calling*Routine*GLM053*for*date*conversion***********                       LUC109
      *  XLM053 - Calling Routine XX000053 for date conversion        *                       LUC109
      ***XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conversion***                       LUC109
      *  XLM041 - Calling Routine XX000041 for AM data type conversion*                       LUC109
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
      *
     D MSG             S             30    DIM(10) CTDATA PERRCD(1)
      *--------------------------------------------------------------------*
      *
     ICLOANCL1
     I              BRCA                        BRCA$1
     I              CCY                         CCY$1
     I              CNUM                        CNUM$1
     I              CPAM                        CPAM$1
     I              MDAT                        MDAT$1
     I              OLNO                        OLNO$1
     I              RECI                        RECI$1
      *
     IFECCDDP0
     I              C9003                       C9003$
     I              C0120                       C0120$
     I              C5125                       C5125$
     I              C9149                       C9149$
     I              C9150                       C9150$
     I              C9151                       C9151$
      *
      *****************************************************************
      *                                                               *
      *  MAIN   - Main processing                                     *
      *                                                               *
      *  Called By:                                                   *
      *  Calls: CHKREC - Check if the input record must be processed  *
      *         CHAINX - Chain CLOANKV0 extension file                *
      *         MOVFLD - Populate all the fields of the output file   *
      *                                                               *
      *****************************************************************
      *
     C     *LOVAL        SETLL     CLOANCY1
     C                   READ      CLOANCY1                               01
      *
     C     *IN01         DOWEQ     *OFF
      *
     C                   EXSR      CHKREC
      *
     C     *IN02         IFEQ      *OFF                                         IF   01
      *
     C                   RESET                   CLOANCL1
     C     MLNRF         SETLL     CLOANCV1
     C     MLNRF         READE     CLOANCV1                               04
      *
     C     *IN04         DOWEQ     *OFF
     C                   EXSR      MOVFLD
      *
     C****       ERRMSG    IFEQ *BLANK
     C                   WRITE     FEPOLDP0
     C****                 ENDIF
      *
     C                   RESET                   FEPOLDP0
     C                   RESET                   ERRMSG
      *
     C     MLNRF         READE     CLOANCV1                               04
     C                   ENDDO
      *
     C                   ENDIF                                                  ENDIF 01
      *
     C                   READ      CLOANCY1                               01
     C                   ENDDO
      *
     C                   WRITE     ENDREC
     C                   MOVE      *ON           *INLR
      *
      *****************************************************************
      *                                                               *
      *  MOVFLD - Populate all the fields of the output file          *
      *                                                               *
      *  Called By: Main processing                                   *
      *  Calls:     SC9003 - Populate the field C9003                 *
      *             SC9151 - Populate the field C9151                 *
      *             SC9002 - Populate the field C9002                 *
      *             SC9007 - Populate the field C9007                 *
      *                                                               *
      *****************************************************************
      *
     C     MOVFLD        BEGSR
      *
     C                   MOVEL(P)  'MOVFLD'      ERRSBR
      *
     C                   EXSR      SC9003
     C                   MOVE      BRCA          C0120
     C                   Z-ADD     CNUM          C5125
     C                   MOVEL     'LE '         C9149
     C                   MOVEL     OLNO$1        C9150
     C                   EXSR      SC9151
     C                   EXSR      SC9002
     C                   Z-ADD     CNUM$1        C9006
     C                   EXSR      SC9007
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
     C                   MOVEL     OLNO$1        KC9150
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
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     SC9002        BEGSR
      *
     C                   MOVEL(P)  'SC9002'      ERRSBR
      *
     C                   ADD       1             COUNT$            8 0
     C                   Z-ADD     COUNT$        C9002
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9007 - Populate the field C9007                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     SC9007        BEGSR
      *
     C                   MOVEL(P)  'SC9007'      ERRSBR
      *
     C                   Z-ADD     CPAM$1        $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C9007                                      nt
      *
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
     C                   MOVE      *ON           *IN02
      *
     C                   RESET                   CLOANCL0
     C     MLNRF         CHAIN(N)  CLOANCV0                           03
      *
     C     *IN03         IFEQ      *ON
     C                   Z-ADD     1             COD
     C                   EXSR      PRINT
     C                   ENDIF
      *
      * 'HP' Loan Type transactions should not be included.               MUI002
     C     LTYP          IFNE      'HP'                                                        MUI00
     C     RECI          IFEQ      'D'
     C                   MOVE      *OFF          *IN02
      *
     C                   ELSE
      *
     C     *IN03         IFEQ      *OFF
     C     RECI          ANDEQ     'M'
     C     MDAT          ANDGT     MPEMB
     C                   MOVE      *OFF          *IN02
     C                   ENDIF
      *
     C                   ENDIF
     C*                                                                   MUI002
     C                   ENDIF                                                                 MUI00
      *
     C                   RESET                   COUNT$
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      ***XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conversion***                       LUC109
      *  XLM041 - Calling Routine XX000041 for AM data type conversion*                       LUC109
      *                                                               *
      *  Called By:                                                   *
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
      *  PRINT  - Print Error                                         *
      *                                                               *
      *  Called By:                                                   *
      *  Calls:                                                       *
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
     C     COD           WHENEQ    1
     C                   MOVEL     MLNRF         ERRD01
     C     COD           WHENEQ    2
     C                   MOVEL     BRCA          ERRD01
     C     COD           WHENEQ    3
     C                   MOVEL     KC9150        ERRD01
     C                   MOVEL     KC9149        ERRD02
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
      *  Called By:                                                   *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C                   MOVEL(P)  '*INZSR'      ERRSBR
      *
     C     K1CCD         KLIST
     C                   KFLD                    KC9150
     C                   KFLD                    KC9149
      *
     C     *LIKE         DEFINE    C9149         KC9149
     C     *LIKE         DEFINE    C9150         KC9150
     C                   MOVEL     'LE '         KC9149
      *
     C                   OPEN      SDBANKPD
     C                   READ      SDBANKD0                               03                 LRLR
     C                   CLOSE     SDBANKPD
      *
     C                   WRITE     HEADAU
     C                   WRITE     COLUMS
      *
     C     *IN03         IFEQ      *ON
     C                   Z-ADD     7             COD
     C                   EXSR      PRINT
     C                   ENDIF
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
      ** False Update (only to deRESETe file in Update in order to run
      **       reset statement)
      *
     C     *IN90         IFEQ      *ON
     C     *IN90         ANDEQ     *OFF
     C                   UPDATE    CLOANCL0                             90
     C                   UPDATE    CLOANCL1                             90
     C                   UPDATE    SDBRCHD0                             90
     C                   UPDATE    FECCDDP0                             90
     C                   ENDIF
      *
     C                   ENDSR
**
CLOANCV0 RECORD NOT FOUND
SDBRCHV0 RECORD NOT FOUND
FECCDDV0 RECORD NOT FOUND
ERROR FOUND CALLING XX000041
5
6
SDBANKPD FILE IS EMPTY
SDGELRV0 FILE IS EMPTY
9
10
