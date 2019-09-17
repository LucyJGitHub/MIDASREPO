     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('FECCD Customer Lending Extract')                       *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM027**-*FECCD*CustomerLending*Extract***********************                       LUC109
      *  XX000027 - FECCD CustomerLending Extract                     *                       LUC109
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
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109CC1          Date 12Sep19               *
      *  Prev Amend No. LUC109             Date 20Sep16               *
      *                 MUI011             Date 19May04               *
      *                 197893             Date 01Oct01               *
      *                 LUC010             Date 22Aug01               *
      *                 195968             Date 20Jul01               *
      *                 194119             Date 30May01               *
      *                 174481             Date 24Mar00               *
      *                 174479             Date 01Mar00               *
      *                 167337 (REOPEN)    Date 10Feb00               *
      *                 167337             Date 08Dec99               *
      *                 167470             Date 18Nov99               *
      *                 168780             Date 21Oct99               *
      *                 167999             Date 19Oct99               *
      *                 MMI043             Date 25Jun98               *
      *                 MMI043             Date 18Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109CC1 - New York Amendments                              *
      *         - Use DLFS for facility start date.                   *
      *         - Ensure that C6145 Fix/Var Flag is never blank.      *
      *         - Fix negative spread error in C9851 Sprd on Base Rt. *
      *         - Take Interest Paid out of C9115 DB Accrued to Date. *
      *         - Change variable rate logic in C6145 Fix/Var Flag.   *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MUI011 - ALMS - Add detail records 17 and 18.                *
      *  197893 - Field C9115 contains wrong data. The field should   *
      *           report the total interest accrued up to the         *
      *           reporting day less any interest already paid.       *
      *           For discounted loans, it should contain the discount*
      *           not yet amortised.                                  *
      *           For syndicated loans, reduce by accrued interest of *
      *           participations sold.                                *
      *  LUC010 - Changes to Head Office Extracts                     *
      *  195968 - For field C0053, if no record exists on HISTSIF then*
      *           use VDAT from CLOANCK                               *
      *  194119 - For matured deals that have only one record on      *
      *           file HISTSHP re-read record and retrieve value date.*
      *  174481 - Record with field C5385 (Amount of credit postings  *
      *           of the quarter) set to 0 while field C5446 (Number  *
      *           of credit posting of the quarter) is meaningful.    *
      *           Fix patterned after 168780.                         *
      *  174479 - Use the value date of the last posting made on the  *
      *           loan in updating field C0053.                       *
      *  167337 - Reopen.  Field C0361 and C0362 should be the        *
      *           outstanding available balance.                      *
      *  167337 - Field C0361 may contain zero or wrong sign;         *
      *           Field C0362 always contains zero.                   *
      *  167470 - Rec w/ fld C0053 (Last Entry Date) in the current   *
      *           qtr) while both flds C5383 (Amt of DR postings of   *
      *           the qtr) and C5385 (Amt of CR postings of the qtr)  *
      *           are set to 0.                                       *
      *  168780 - Record with fld C5383 (No. of DR postings of the    *
      *           qtr) meaningful while fld C5383 (Amt of DR postings *
      *           of the qtr) is set to '0'.                          *
      *  167999 - Do not process parts sold and guarantees            *
      *  MMI043 - Use Processing Days + 2 for fld C0052.              *
      *           Ensure correct value for flds C0611, C9339.         *
      *  MMI043 - Balance Sheet Extract                               *
      *                                                               *
      *****************************************************************
      *
     FCLOANCV0  IF   E           K DISK
      *
     FCLOANKV0  IF   E           K DISK
     FCLOANCY0  IF   E           K DISK
     F*FCLTYNV0IF  E           K        DISK
     FFCLTYMV0  IF   E           K DISK
     FSDBRCHV0  IF   E           K DISK
     FSDBANKPD  IF   E           K DISK    USROPN
     FSDACRCV0  IF   E           K DISK
     FACKEYV0   IF   E           K DISK
     FSDGELRV0  IF   E           K DISK    USROPN
     FSDCUSTV0  IF   E           K DISK
     FLOAMSKV0  IF   E           K DISK
     FLVENTLV0  IF   E           K DISK                                         MMI043
     FHISTSIF   IF   E           K DISK                                         174479
     FPSOLD     IF   E           K DISK                                         197893
     F                                     RENAME(CLOANCLF:PSOLDF)              197893
      *
     FFECCDDPP  O    E             DISK
     F***GLM027AU  O    E             PRINTER OFLIND(*IN20)                                   LUC109
     FXX000027AUO    E             PRINTER OFLIND(*IN20)                                      LUC109
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01 - LF/CLOANCV0   File I                                   *
      *   03 - LF/CLOANKV0   File I                                   *
      *   03 - LF/SDBRCHV0   File I                                   *
      *   03 - LF/SDACRCV0   File I                                   *
      *   03 - LF/ACKEYV0    File I                                   *
      *                                                               *
      *   LR - LF/SDBANKPD   File I                                   *
      *   LR - LF/SDGELRPP   File I                                   *
      *                                                               *
      ****20*-*PRTF/GLM027PT*File*O*Overflow*indicator*****************                       LUC109
      *   20 - PRTF/XX000027AU File O Overflow indicator              *                       LUC109
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  MAIN   - Main Processing                                     *
      *  CHKREC - Check if the input record must be processed         *
      *  CHAINX - Chain CLOANKV0 extension file                       *
      *  MOVFLD - Populate all the fields of the output file          *
      *                                                               *
      *     All the following subroutines populate the corresponding  *
      *     field name                                                *
      *                                                               *
      *  SC9003 - Populate the field C9003                            *
      *  SC9172 - Populate the field C9172                            *
      *  SC9152 - Populate the field C9152                            *
      *  SC9153 - Populate the field C9153                            *
      *  SC9151 - Populate the field C9151                            *
      *  SC9154 - Populate the field C9154                            *
      *  SC9173 - Populate the field C9173                            *
      *  SC9176 - Populate the field C9176                            *
      *  SC9100 - Populate the field C9100                            *
      *  SC9101 - Populate the field C9101                            *
      *  SC9102 - Populate the field C9102                            *
      *  SC9103 - Populate the field C9103                            *
      *  SC9114 - Populate the field C9114                            *
      *  SC9115 - Populate the field C9115                            *
      *  SC9116 - Populate the field C9116                            *
      *  SC9117 - Populate the field C9117                            *
      *  SC9113 - Populate the field C9113                            *
      *  SC9112 - Populate the field C9112                            *
      *  SC0051 - Populate the field C0051                            *
      *  SC0052 - Populate the field C0052                            *
      *  SC0053 - Populate the field C0053                            *
      *  SC9160 - Populate the field C9160                            *
      *  SC0064 - Populate the field C0064                            *
      *  SC0110 - Populate the field C0110                            *
      *  SC0301 - Populate the field C0301                            *
      *  SC0316 - Populate the field C0316                            *
      *  SC0319 - Populate the field C0319                            *
      *  SC0322 - Populate the field C0322                            *
      *  SC0325 - Populate the field C0325                            *
      *  SC0328 - Populate the field C0328                            *
      *  SC5334 - Populate the field C5334                            *
      *  SC0361 - Populate the field C0361                            *
      *  SC0362 - Populate the field C0362                            *
      *  SC0364 - Populate the field C0364                            *
      *  SC0366 - Populate the field C0366                            *
      *  SC0379 - Populate the field C0379                            *
      *  SC0380 - Populate the field C0380                            *
      *  SC0382 - Populate the field C0382                            *
      *  SC0384 - Populate the field C0384                            *
      *  SC0395 - Populate the field C0395                            *
      *  SC0396 - Populate the field C0396                            *
      *  SC0421 - Populate the field C0421                            *
      *  SC0438 - Populate the field C0438                            *
      *  SC9170 - Populate the field C9170                            *
      *  SC0470 - Populate the field C0470                            *
      *  SC0611 - Populate the field C0611                            *
      *  SC9339 - Populate the field C9339                            *
      *  SC1501 - Populate the field C1501                            *
      *  SC5064 - Populate the field C5064                            *
      *  SC9021 - Populate the field C9021                            *
      *  SC9022 - Populate the field C9022                            *
      *  SC5383 - Populate the field C5383                            *
      *  SC5385 - Populate the field C5385                            *
      *  SC5445 - Populate the field C5445                            *
      *  SC6145 - Populate the field C6145                            *
      *  SC9238 - Populate the field C9238                            *
      *  SC9340 - Populate the field C9340                            *
      *  SC9342 - Populate the field C9342                            *
      *  SC9343 - Populate the field C9343                            *
      *  SC9344 - Populate the field C9344                            *
      *  SC9345 - Populate the field C9345                            *
      *  SC9377 - Populate the field C9377                            *
      *  SC9802 - Populate the field C9802                            *   LUC010
      *  SC9811 - Populate the field C9811                            *   LUC010
      *  SC9812 - Populate the field C9812                            *   LUC010
      *                                                               *
      ***XLM053*-*Calling*Routine*GLM053*for*date*conversion***********                       LUC109
      *  XLM053 - Calling Routine XX000053 for date conversion        *                       LUC109
      ***XLM041*-*Calling*Routine GLM041*for*AM*data*type*conversion***                       LUC109
      *  XLM041 - Calling Routine XX000041 for AM data type conversion*                       LUC109
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
      *
     D SVALKK          C                   CONST('HOR_NY_Amendments')                      LUC109CC1
     D MSG             S             30    DIM(15) CTDATA PERRCD(1)
      *                                                                   174479
      *--------------------------------------------------------------------*
      *
     D WC9151          DS
     D  BRCA                   1      3
     D  CNUM                   4      9  0
     D  CCY                   10     12
     D  W9151                 13     16  0
     D  LASQ                  17     18  0
      *
     D K1ACKE          DS
     D  LTYP                   1      2
     D  K1C1                   3      3
     D  SUTP                   4      5
     D  K1C2                   6      8
     D  K1C3                   9      9
     D  K1C4                  10     10

      **  Data Structure for AOSVALR0 string                                               LUC109CC1
     DSVAL1            DS           200                                                    LUC109CC1
     DSVAL11                   1      1                                                    LUC109CC1
      *--------------------------------------------------------------------*
      *
     IACKEYALF
     I              RECI                        RECI$1
      *
     ICLOANCKF
     I              RECI                        RECI$2
     I              LNRF                        LNRF$2
      *
     ILOAMSDKF
     I              RECI                        RECI$3
     I              LNRF                        LNRF$3
     I              LTYP                        LTYP$3
     I              SUTP                        SUTP$3
     I              PTYP                        PTYP$3
     I              BRTT                        BRTT$3
     I              RTSP                        RTSP$3
     I              CCY                         CCY$3
     I              BRCA                        BRCA$3
     I              CNUM                        CNUM$3
     I              REPT                        REPT$3
     I              AUTO                        AUTO$3
     I              BRTE                        BRTE$3
     I              SPIN                        SPIN$3
     I              FCUS                        FCUS$3
     I              FTYP                        FTYP$3
     I              FSEQ                        FSEQ$3
     I              VDAT                        VDAT$3
      *
     IFCLTYFMF
     I              RECI                        RECI$4
     I              CNUM                        CNUM$4
     I              BRCA                        BRCA$4
      *                                                                   174479
     IHISTSHPF                                                                  174479
     I              RECI                        RECI$5                          174479
     I              LNRF                        LNRF$5                          174479
     I              CCY                         CCY$5                           174479
     I              PRAM                        PRAM$5                          174479
     I              PTYP                        PTYP$5                          174479
     I              BRCA                        BRCA$5                          174479
     I              CNUM                        CNUM$5                          174479
     I              INTR                        INTR$5                          174479
     I              FCUS                        FCUS$5                          174479
     I              FTYP                        FTYP$5                          174479
     I              LTYP                        LTYP$5                          174479
     I              SUTP                        SUTP$5                          174479
     I              FSEQ                        FSEQ$5                          174479
     I              VDAT                        VDAT$5                          174479
     I              CPAM                        CPAM$5                          174479
     I              AITC                        AITC$5                          174479
     I              IPRD                        IPRD$5                          174479
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
     C     *LOVAL        SETLL     CLOANCV0
     C                   READ      CLOANCV0                               01
      *
     C     *IN01         DOWEQ     *OFF
      *
     C                   EXSR      CHKREC
      *
     C     *IN02         IFEQ      *OFF
     C                   EXSR      CHAINX
     C                   EXSR      MOVFLD
      *
     C                   WRITE     FECCDDP0
      *
     C                   CLEAR                   FECCDDP0
     C                   CLEAR                   ERRMSG
      *
     C                   ENDIF
      *
     C                   READ      CLOANCV0                               01
     C                   ENDDO
      *
     C                   WRITE     ENDREC
     C                   MOVE      *ON           *INLR
      *
      *****************************************************************
      *                                                               *
      *  CHAINX - Chain CLOANKV0 extension file                       *
      *                                                               *
      *  Called By: Main processing                                   *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     CHAINX        BEGSR
      *
     C                   MOVEL(P)  'CHAINX'      ERRSBR
      *
     C                   CLEAR                   CLOANCKF
     C     LNRF          CHAIN(N)  CLOANKV0                           03
      *
     C     *IN03         IFEQ      *ON
     C                   Z-ADD     1             COD
     C                   EXSR      PRINT
     C                   ENDIF
      *
     C                   CLEAR                   CLOANFX0
     C     LNRF          CHAIN(N)  CLOANCY0                           03
      *
     C     *IN03         IFEQ      *ON
     C                   Z-ADD     11            COD
     C                   EXSR      PRINT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  MOVFLD - Populate all the fields of the output file          *
      *                                                               *
      *  Called By: Main processing                                   *
      *  Calls:     SC9003 - Populate the field C9003                 *
      *             SC9172 - Populate the field C9172                 **
      *             SC9152 - Populate the field C9152                 **
      *             SC9153 - Populate the field C9153                 *
      *             SC9151 - Populate the field C9151                 *
      *             SC9154 - Populate the field C9154                 *
      *             SC9173 - Populate the field C9173                 *
      *             SC9176 - Populate the field C9176                 *
      *             SC9100 - Populate the field C9100                 *
      *             SC9101 - Populate the field C9101                 *
      *             SC9102 - Populate the field C9102                 *
      *             SC9103 - Populate the field C9103                 *
      *             SC9114 - Populate the field C9114                 *
      *             SC9115 - Populate the field C9115                 *
      *             SC9116 - Populate the field C9116                 *
      *             SC9117 - Populate the field C9117                 *
      *             SC9113 - Populate the field C9113                 *
      *             SC9112 - Populate the field C9112                 *
      *             SC0051 - Populate the field C0051                 *
      *             SC0052 - Populate the field C0052                 *
      *             SC0053 - Populate the field C0053                 *
      *             SC9160 - Populate the field C9160                 *
      *             SC0064 - Populate the field C0064                 *
      *             SC0110 - Populate the field C0110                 *
      *             SC0301 - Populate the field C0301                 *
      *             SC0316 - Populate the field C0316                 *
      *             SC0319 - Populate the field C0319                 *
      *             SC0322 - Populate the field C0322                 *
      *             SC0325 - Populate the field C0325                 *
      *             SC0328 - Populate the field C0328                 *
      *             SC5334 - Populate the field C5334                 *
      *             SC0361 - Populate the field C0361                 *
      *             SC0362 - Populate the field C0362                 *
      *             SC0364 - Populate the field C0364                 *
      *             SC0366 - Populate the field C0366                 *
      *             SC0379 - Populate the field C0379                 *
      *             SC0380 - Populate the field C0380                 *
      *             SC0382 - Populate the field C0382                 *
      *             SC0384 - Populate the field C0384                 *
      *             SC0395 - Populate the field C0395                 *
      *             SC0396 - Populate the field C0396                 *
      *             SC0421 - Populate the field C0421                 *
      *             SC0438 - Populate the field C0438                 *
      *             SC9170 - Populate the field C9170                 *
      *             SC0470 - Populate the field C0470                 *
      *             SC0611 - Populate the field C0611                 *
      *             SC9339 - Populate the field C9339                 *
      *             SC1501 - Populate the field C1501                 *
      *             SC5064 - Populate the field C5064                 *
      *             SC9021 - Populate the field C9021                 *
      *             SC9022 - Populate the field C9022                 *
      *             SC5383 - Populate the field C5383                 *
      *             SC5385 - Populate the field C5385                 *
      *             SC5445 - Populate the field C5445                 *
      *             SC6145 - Populate the field C6145                 *
      *             SC9238 - Populate the field C9238                 *
      *             SC9340 - Populate the field C9340                 *
      *             SC9342 - Populate the field C9342                 *
      *             SC9343 - Populate the field C9343                 *
      *             SC9344 - Populate the field C9344                 *
      *             SC9345 - Populate the field C9345                 *
      *             SC9377 - Populate the field C9377                 *
      *             SC9802 - Populate the field C9802                 *   LUC010
      *             SC9811 - Populate the field C9811                 *   LUC010
      *             SC9812 - Populate the field C9812                 *   LUC010
      *                                                               *
      *****************************************************************
      *
     C     MOVFLD        BEGSR
      *
     C                   MOVEL(P)  'MOVFLD'      ERRSBR
      *
     C                   EXSR      SC9003
     C     PTYP          IFEQ      64
     C     PTYP          OREQ      65
     C     RCSI          ANDEQ     *BLANKS
     C                   Z-ADD     OLNO          C5125
     C                   ELSE
     C                   Z-ADD     CNUM          C5125
     C                   ENDIF
     C                   EXSR      SC9172
     C                   MOVE      BRCA          C0120
     C                   MOVE      CCY           C0150
     C                   MOVEL     'LE'          C9149
     C                   MOVEL     LNRF          C9150
     C                   MOVE      '0'           C9177
     C                   MOVE      '0'           C9178
     C                   EXSR      SC9152
     C                   EXSR      SC9153
     C                   EXSR      SC9151
     C                   EXSR      SC9154
     C                   MOVE      ICBS          C9157
     C                   EXSR      SC9173
     C                   MOVE      LTYP          C9174
     C                   MOVE      SUTP          C9175
     C                   EXSR      SC9176
     C                   Z-ADD     MDAVR         C6126
     C                   CLEAR                   C6124
     C                   EXSR      SC9100
     C                   EXSR      SC9101
     C                   EXSR      SC9102
     C                   EXSR      SC9103
     C                   CLEAR                   C9104
     C                   EXSR      SC9114
     C                   EXSR      SC9115
     C                   EXSR      SC9116
     C                   EXSR      SC9117
     C*******************  Z-ADDINTR      C9118
     C                   EXSR      SC9118
     C                   EXSR      SC9113
     C                   EXSR      SC9112
     C                   EXSR      SC0051
     C                   EXSR      SC0052
     C                   EXSR      SC0053
     C                   CLEAR                   C9158
     C                   CLEAR                   C9159
     C                   EXSR      SC9160
     C                   EXSR      SC0064
     C                   EXSR      SC0110
     C                   EXSR      SC0301
     C                   EXSR      SC0316
     C                   EXSR      SC0319
     C                   EXSR      SC0322
     C                   EXSR      SC0325
     C                   EXSR      SC0328
     C                   EXSR      SC5334
     C                   EXSR      SC5064
     C                   EXSR      SC0361
     C                   EXSR      SC0362
     C                   EXSR      SC0364
     C                   EXSR      SC0366
     C                   EXSR      SC0379
     C                   EXSR      SC0380
     C                   EXSR      SC0382
     C                   EXSR      SC0384
     C                   EXSR      SC0395
     C                   EXSR      SC0396
     C                   EXSR      SC0421
     C                   EXSR      SC0438
     C                   CLEAR                   C0447
     C                   EXSR      SC0448
     C                   CLEAR                   C0456
     C                   EXSR      SC9170
     C                   EXSR      SC0470
     C                   CLEAR                   C0485
     C     MCONS         IFEQ      *BLANK
     C                   MOVE      '0'           C0584
     C                   ELSE
     C                   MOVE      MCONS         C0584
     C                   ENDIF
     C                   EXSR      SC0611
     C                   EXSR      SC9339
     C     MCRTP         IFEQ      *BLANK
     C                   MOVE      '0'           C0814
     C                   ELSE
     C                   MOVE      MCRTP         C0814
     C                   ENDIF
     C                   EXSR      SC1501
     C                   Z-ADD     FTYP          C9019
     C                   Z-ADD     FSEQ          C9020
     C                   EXSR      SC9021
     C                   EXSR      SC9022
     C                   EXSR      SC5383
     C                   EXSR      SC5385
     C                   EXSR      SC5445
     C***********          CLEARC5446                                     167470
     C                   EXSR      SC5446                                                      16747
     C                   MOVE      MGCUS         C5653
     C     C0584         IFEQ      '2'
     C     C0584         OREQ      '4'
     C                   MOVE      MCSLD         C5653
     C                   ENDIF
     C     WTRT          IFEQ      0
     C                   MOVE      '1'           C6003
     C                   ELSE
     C                   MOVE      '0'           C6003
     C                   ENDIF
     C                   EXSR      SC6145
     C                   EXSR      SC9238
     C                   EXSR      SC9340
     C                   EXSR      SC9342
     C                   EXSR      SC9343
     C                   EXSR      SC9344
     C                   EXSR      SC9345
     C                   CLEAR                   C9346
     C                   EXSR      SC9377
     C                   EXSR      SC9802                                                      LUC01
     C                   EXSR      SC9811                                                      LUC01
     C                   EXSR      SC9812                                                      LUC01
     C                   MOVE      BOKC          C9830                                         MUI01
     C                   MOVE      MISIN         C9832                                         MUI01
     C                   MOVE      RLFQ          C9847                                         MUI01
     C                   MOVE      IPFR          C9848                                         MUI01
     C                   MOVE      RFRQ          C9849                                         MUI01
     C     BRTT          IFGT      *ZERO                                                       MUI01
     C                   MOVE      BRTT          C9850                                         MUI01
     C                   ENDIF                                                                 MUI01
     C                   EXSR      SC9851                                                      MUI01
     C                   MOVE      PTYP          C9883                                         MUI01
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
     C                   CLEAR                   SDBRCHD0
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
      *  SC9172 - Populate the field C9172                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC9172        BEGSR
      *
     C                   MOVEL(P)  'SC9172'      ERRSBR
      *
     C     PTYP          IFEQ      63
     C     PTYP          OREQ      65
     C                   MOVE      'Y'           C9172
     C                   ELSE
     C                   MOVE      'N'           C9172
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9151 - Populate the field C9151                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC9151        BEGSR
      *
     C                   MOVEL(P)  'SC9151'      ERRSBR
      *
     C     VDAT          IFLE      BJRDNB
     C                   Z-ADD     C9152         W9151
     C                   ELSE
     C                   Z-ADD     C9153         W9151
     C                   ENDIF
      *
     C                   MOVE      WC9151        C9151
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9152 - Populate the field C9152                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     SC9152        BEGSR
      *
     C                   MOVEL(P)  'SC9152'      ERRSBR
      *
     C                   MOVE      'R'           K1C1
     C                   CLEAR                   K1C2
     C                   CLEAR                   K1C3
     C                   MOVE      'A'           K1C4
     C                   CLEAR                   ACKEYALF
     C     K1ACKE        CHAIN(N)  ACKEYV0                            03
      *
     C     *IN03         IFEQ      *OFF                                         IF    01
      *
     C     PRF4          IFEQ      3                                            IF    02
     C                   Z-ADD     ACD4          C9152
     C                   ELSE                                                   ELSE  02
     C     PRF5          IFEQ      3                                            IF    03
     C                   Z-ADD     ACD5          C9152
     C                   ELSE                                                   ELSE  03
     C     PRF6          IFEQ      3                                            IF    04
     C                   Z-ADD     ACD6          C9152
     C                   ENDIF                                                  ENDIF 04
     C                   ENDIF                                                  ENDIF 03
     C                   ENDIF                                                  ENDIF 02
      *
     C                   ELSE                                                   ELSE  01
     C                   Z-ADD     3             COD
     C                   EXSR      PRINT
     C                   ENDIF                                                  ENDIF 01
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9153 - Populate the field C9153                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     SC9153        BEGSR
      *
     C                   MOVEL(P)  'SC9153'      ERRSBR
      *
     C                   MOVE      'D'           K1C1
     C                   CLEAR                   K1C2
     C                   CLEAR                   K1C3
     C                   MOVE      'A'           K1C4
     C                   CLEAR                   ACKEYALF
     C     K1ACKE        CHAIN(N)  ACKEYV0                            03
      *
     C     *IN03         IFEQ      *OFF                                         IF    01
      *
     C     ACD4          IFNE      0                                            IF    02
     C                   Z-ADD     ACD4          C9153
     C                   ELSE                                                   ELSE  02
     C     ACD5          IFNE      0                                            IF    03
     C                   Z-ADD     ACD5          C9153
     C                   ELSE                                                   ELSE  03
     C     ACD6          IFNE      0                                            IF    04
     C                   Z-ADD     ACD6          C9153
     C                   ENDIF                                                  ENDIF 04
     C                   ENDIF                                                  ENDIF 03
     C                   ENDIF                                                  ENDIF 02
      *
     C                   ELSE                                                   ELSE  01
     C                   Z-ADD     3             COD
     C                   EXSR      PRINT
     C                   ENDIF                                                  ENDIF 01
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9154 - Populate the field C9154                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     SC9154        BEGSR
      *
     C                   MOVEL(P)  'SC9154'      ERRSBR
      *
     C                   MOVE      'D'           K1C1
     C                   CLEAR                   K1C2
     C                   CLEAR                   K1C3
     C                   MOVE      'A'           K1C4
     C                   CLEAR                   ACKEYALF
     C     K1ACKE        CHAIN(N)  ACKEYV0                            03
      *
     C     *IN03         IFEQ      *OFF                                         IF    01
      *
     C     ACD1          IFNE      0                                            IF    02
     C                   Z-ADD     ACD1          C9154
     C                   ELSE                                                   ELSE  02
     C     ACD2          IFNE      0                                            IF    03
     C                   Z-ADD     ACD2          C9154
     C                   ELSE                                                   ELSE  03
     C     ACD3          IFNE      0                                            IF    04
     C                   Z-ADD     ACD3          C9154
     C                   ENDIF                                                  ENDIF 04
     C                   ENDIF                                                  ENDIF 03
     C                   ENDIF                                                  ENDIF 02
      *
     C                   ELSE                                                   ELSE  01
     C                   Z-ADD     3             COD
     C                   EXSR      PRINT
     C                   ENDIF                                                  ENDIF 01
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9173 - Populate the field C9173                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC9173        BEGSR
      *
     C                   MOVEL(P)  'SC9173'      ERRSBR
      *
     C     CPAM          SUB       PSAM          WKAMNT           13 0
     C                   Z-ADD     WKAMNT        $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C9173                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9176 - Populate the field C9176                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     SC9176        BEGSR
      *
     C                   MOVEL(P)  'SC9176'      ERRSBR
      *
     C                   MOVE      'A'           K1C1
     C                   CLEAR                   K1C2
     C                   CLEAR                   K1C3
     C                   MOVE      *ALL'§'       K1C4
      *
     C     PTYP          IFEQ      61                                           IF    01
     C     PTYP          OREQ      62
     C     PTYP          OREQ      64
     C                   MOVE      'I'           K1C4
     C                   ELSE                                                   ELSE  01
      *
     C     PTYP          IFEQ      63                                           IF    02
     C     PTYP          OREQ      65
     C                   MOVE      'D'           K1C4
     C                   ENDIF                                                  ENDIF 02
      *
     C                   ENDIF                                                  ENDIF 01
      *
     C                   CLEAR                   ACKEYALF
     C     K1ACKE        CHAIN(N)  ACKEYV0                            03
      *
     C     *IN03         IFEQ      *OFF                                         IF    01
      *
     C     ACD1          IFNE      *ZERO                                        IF    02
     C                   Z-ADD     ACD1          C9176
     C                   ELSE                                                   ELSE  02
     C     ACD2          IFNE      *ZERO                                        IF    03
     C                   Z-ADD     ACD2          C9176
     C                   ELSE                                                   ELSE  03
     C     ACD3          IFNE      *ZERO                                        IF    04
     C                   Z-ADD     ACD3          C9176
     C                   ENDIF                                                  ENDIF 04
     C                   ENDIF                                                  ENDIF 03
     C                   ENDIF                                                  ENDIF 02
      *
     C                   ELSE                                                   ELSE  01
     C                   Z-ADD     3             COD
     C                   EXSR      PRINT
     C                   ENDIF                                                  ENDIF 01
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9100 - Populate the field C9100                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC9100        BEGSR
      *
     C                   MOVEL(P)  'SC9100'      ERRSBR
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C9100                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9101 - Populate the field C9101                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC9101        BEGSR
      *
     C                   MOVEL(P)  'SC9101'      ERRSBR
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C9101                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9102 - Populate the field C9102                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC9102        BEGSR
      *
     C                   MOVEL(P)  'SC9102'      ERRSBR
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C9102                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9103 - Populate the field C9103                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC9103        BEGSR
      *
     C                   MOVEL(P)  'SC9103'      ERRSBR
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C9103                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9114 - Populate the field C9114                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC9114        BEGSR
      *
     C                   MOVEL(P)  'SC9114'      ERRSBR
      *
     C                   Z-ADD     MDACM         $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C9114                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9115 - Populate the field C9115                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC9115        BEGSR
      *
     C                   MOVEL(P)  'SC9115'      ERRSBR
      *
     C***********AITC      ADD  AIPD      WRKAMT 150                      197893
     C***********WRKAMT    ADD  AIMN      $$AMNT                          197893
     C                   IF        NY_Amend = 'Y'                                          LUC109CC1
     C                   Z-ADD     AIPD          $$AMNT                                    LUC109CC1
     C                   ELSE                                                              LUC109CC1
     C     AIPD          SUB       IPRD          WRKAMT           15 0                         19789
     C     WRKAMT        SUB       ICTD          $$AMNT                                        19789
     C                   Z-ADD     0             WRKAMT
     C                   ENDIF                                                             LUC109CC1
      *                                                                   197893
      * Discounted Loans                                                  197893
      *                                                                   197893
     C     PTYP          IFEQ      63                                                          19789
     C     PTYP          OREQ      65                                                          19789
     C     TOTI          SUB       AIPD          $$AMNT                                        19789
     C                   ENDIF                                                                 19789
      *                                                                   197893
      * Reduce by accrued interest on parts sold                          197893
      *                                                                   197893
     C     PSAM          IFNE      *ZERO                                                       19789
     C     LNRF          CHAIN     PSOLD                              04                       19789
     C     *IN04         DOWEQ     *OFF                                                        19789
     C                   Z-ADD     OLNO          LNRF                                          19789
     C     PTYP          IFEQ      67                                                          19789
     C                   SUB       TOTI          $$AMNT                                        19789
     C                   ADD       AIPD          $$AMNT                                        19789
     C                   ELSE                                                                  19789
     C                   SUB       AIPD          $$AMNT                                        19789
     C                   IF        NY_Amend <> 'Y'                                         LUC109CC1
     C                   ADD       IPRD          $$AMNT                                        19789
     C                   ADD       ICTD          $$AMNT                                        19789
     C                   ENDIF                                                             LUC109CC1
     C                   ENDIF                                                                 19789
     C     LNRF          READE     PSOLD                                  04                   19789
     C                   ENDDO                                                                 19789
      * reset pointer                                                     197893
     C     LNRF          CHAIN     CLOANCV0                           04                       19789
     C                   ENDIF                                                                 19789
      *                                                                   197893
      * If loan not started, zeroise amount                               197893
      *                                                                   197893
     C     VDAT          IFGT      BJRDNB                                                      19789
     C                   Z-ADD     0             $$AMNT                                        19789
     C                   ENDIF                                                                 19789
      *                                                                   197893
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C9115                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9116 - Populate the field C9116                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC9116        BEGSR
      *
     C                   MOVEL(P)  'SC9116'      ERRSBR
      *
     C                   Z-ADD     IPRM          $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C9116                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9117 - Populate the field C9117                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC9117        BEGSR
      *
     C                   MOVEL(P)  'SC9117'      ERRSBR
      *
     C                   Z-ADD     IPRD          $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C9117                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9118 - Populate the field C9118                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC9118        BEGSR
      *
     C                   MOVEL(P)  'SC9118'      ERRSBR
      *
     C     INTR          IFLT      0
     C                   Z-ADD     0             C9118
     C                   ELSE
     C                   Z-ADD     INTR          C9118
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9113 - Populate the field C9113                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC9113        BEGSR
      *
     C                   MOVEL(P)  'SC9113'      ERRSBR
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C9113                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9112 - Populate the field C9112                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC9112        BEGSR
      *
     C                   MOVEL(P)  'SC9112'      ERRSBR
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C9112                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0051 - Populate the field C0051                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC0051        BEGSR
      *
     C                   MOVEL(P)  'SC0051'      ERRSBR
      *
     C                   Z-ADD     DDAT          $$DAY
     C                   EXSR      XLM053
     C                   MOVE      $$DATE        C0051                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0052 - Populate the field C0052                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC0052        BEGSR
      *
     C                   MOVEL(P)  'SC0052'      ERRSBR
      *
     C     MDAT          IFEQ      0                                                           MMI04
     C***********VDAT      ADD  2         $$DAY                           MMI043
     C     BJDNWD        ADD       2             $$DAY                                         MMI04
     C                   ELSE                                                                  MMI04
     C                   Z-ADD     MDAT          $$DAY
     C                   ENDIF                                                                 MMI04
      *                                                                   MMI043
     C                   EXSR      XLM053
     C                   MOVE      $$DATE        C0052                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0053 - Populate the field C0053                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC0053        BEGSR
      *
     C                   MOVEL(P)  'SC0053'      ERRSBR
      *
     C     MDAT          IFGT      BJRDNB                                       IF    01
     C     MDAT          OREQ      0                                            IF    01
      *
     C     RBDT          IFGT      VDAT                                         IF    02
     C     RBDT          ANDLT     BJRDNB
     C                   Z-ADD     RBDT          $$DAY
     C                   ENDIF                                                  ENDIF 02
      *
     C     RBDT          IFGT      VDAT                                         IF    02
     C     RBDT          ANDGT     BJRDNB
     C                   Z-ADD     VDAT          $$DAY
     C                   ENDIF                                                  ENDIF 02
     C*                                                                   174479
     C** If Principal Amount is already 0, use date of the last posting   174479
     C*                                                                   174479
     C     CPAM          IFEQ      0                                                           17447
     C                   MOVE      BRCA          XBRCA             3                           17447
     C                   MOVE      CNUM          XCNUM                                         17447
     C                   MOVE      LNRF          XLNRF                                         17447
     C                   MOVE      MDAT          XVDAT                                         17447
     C     K1HIST        SETLL     HISTSIF                                                     17447
     C                   READP     HISTSIF                                10                   17447
     C*                                                                   174479
     C** If a Maturity record was read, perform another READP             174479
     C** to get the latest posting.                                       174479
     C*                                                                   174479
     C     *IN10         IFEQ      '0'                                                         17447
     C     AMTP          IFEQ      'MA'                                                        17447
     C                   READP     HISTSIF                                10                   17447
     C                   ENDIF                                                                 17447
     C*                                                                   174479
     C     *IN10         IFEQ      '0'                                                         17447
     C                   MOVE      VDAT$5        $$DAY                                         17447
     C                   ENDIF                                                                 17447
     C*                                                                   174479
     C                   ENDIF                                                                 17447
     C                   ENDIF                                                                 17447
      *
     C                   ELSE                                                   ELSE  01
     C                   Z-ADD     MDAT          $$DAY
     C                   ENDIF                                                  ENDIF 01
      *
     C     $$DAY         IFLE      MPEQB
     C     $$DAY         ORGT      BJRDNB
     C                   Z-ADD     0             $$DAY
     C                   ENDIF
      *
     C     MDAT          IFLE      BJRDNB                                                      17447
     C                   MOVE      BRCA          XBRCA             3                           17447
     C                   MOVE      CNUM          XCNUM                                         17447
     C                   MOVE      LNRF          XLNRF                                         17447
     C                   MOVE      MDAT          XVDAT                                         17447
     C     K1HIST        SETLL     HISTSIF                                                     17447
     C                   READP     HISTSIF                                10                   17447
     C*                                                                   174479
      ** If record read is for a different loan the read next record.     194119
     C*                                                                   194119
     C     LNRF$5        IFNE      LNRF                                                        19411
     C                   READ      HISTSIF                                10                   19411
     C                   GOTO      NXREC                                                       19411
     C                   ENDIF                                                                 19411
     C*                                                                   194119
     C** If a Maturity record was read, perform another READP             174479
     C** to get the latest posting.                                       174479
     C*                                                                   174479
     C     *IN10         IFEQ      '0'                                                         17447
     C     AMTP          IFEQ      'MA'                                                        17447
     C                   READP     HISTSIF                                10                   17447
     C                   ENDIF                                                                 17447
     C*                                                                   174479
     C     NXREC         TAG                                                                   19411
     C*                                                                   194119
     C*                                                                   195968
      ** If no records exist for this loan use Value Date from CLOANSDK   195968
     C*                                                                   195968
     C     LNRF$5        IFNE      LNRF                                                        19596
     C                   MOVE      VDAT          $$DAY                                         19596
     C****       *IN10     IFEQ '0'                                       195968
     C                   ELSE                                                                  19596
     C                   MOVE      VDAT$5        $$DAY                                         17447
     C                   ENDIF                                                                 17447
     C*                                                                   174479
     C                   ENDIF                                                                 17447
     C                   ENDIF                                                                 17447
     C*                                                                   174479
     C                   EXSR      XLM053
     C                   MOVE      $$DATE        C0053                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9160 - Populate the field C9160                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC9160        BEGSR
      *
     C                   MOVEL(P)  'SC9160'      ERRSBR
      *
     C                   Z-ADD     VDAT          $$DAY
     C                   EXSR      XLM053
     C                   MOVE      $$DATE        C9160                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0064 - Populate the field C0064                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC0064        BEGSR
      *
     C                   MOVEL(P)  'SC0064'      ERRSBR
      *
     C     RECI          IFEQ      'M'
     C     MDAT          ANDLE     BJRDNB
     C                   Z-ADD     MDAT          $$DAY
     C                   ELSE
     C                   CLEAR                   $$DAY                                      nt
     C                   ENDIF
      *
     C     LNRF          CHAIN     LOAMSKV0                           05
     C     *IN05         IFEQ      '0'
     C     MDAT          ANDLE     MMDNB
     C                   CLEAR                   $$DAY
     C                   ENDIF
      *
     C                   EXSR      XLM053
     C                   MOVE      $$DATE        C0064                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0110 - Populate the field C0110                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     SC0110        BEGSR
      *
     C                   MOVEL(P)  'SC0110'      ERRSBR
      *
     C                   CLEAR                   SDCUSTD0
     C     MCSLD         CHAIN(N)  SDCUSTV0                           03
      *
     C     *IN03         IFEQ      *OFF
     C                   MOVE      BBCOLC        C0110
     C                   ELSE
     C                   Z-ADD     9             COD
     C                   EXSR      PRINT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0301 - Populate the field C0301                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0301        BEGSR
      *
     C                   MOVEL(P)  'SC0301'      ERRSBR
      *
     C     RECI          IFNE      'M'
     C     CPAM          SUB       PSAM          WKAMT2           13 0
     C                   Z-SUB     WKAMT2        $$AMNT
     C                   ENDIF
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0301                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0316 - Populate the field C0316                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0316        BEGSR
      *
     C                   MOVEL(P)  'SC0316'      ERRSBR
      *
     C                   Z-SUB     MDALB         $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0316                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0319 - Populate the field C0319                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0319        BEGSR
      *
     C                   MOVEL(P)  'SC0319'      ERRSBR
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0319                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0322 - Populate the field C0322                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0322        BEGSR
      *
     C                   MOVEL(P)  'SC0322'      ERRSBR
      *
     C                   Z-SUB     MDACB         $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0322                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0325 - Populate the field C0325                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0325        BEGSR
      *
     C                   MOVEL(P)  'SC0325'      ERRSBR
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0325                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0328 - Populate the field C0328                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0328        BEGSR
      *
     C                   MOVEL(P)  'SC0328'      ERRSBR
      *
     C                   Z-ADD     MQXAB         $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0328                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC5334 - Populate the field C5334                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC5334        BEGSR
      *
     C                   MOVEL(P)  'SC5334'      ERRSBR
      *
     C                   Z-ADD     MTOTI         $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C5334                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0361 - Populate the field C0361                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0361        BEGSR
      *
     C                   MOVEL(P)  'SC0361'      ERRSBR
      *
     C     MQMAV         IFLT      0                                                           16733
     C                   Z-ADD     MQMAV         $$AMNT
     C                   ELSE                                                                  16733
     C                   Z-SUB     MQMAV         $$AMNT                                        16733
     C     MQMAV         IFEQ      0                                                           16733
     C     RECI          ANDEQ     'D'                                                         16733
     C     CPAM          SUB       PSAM          TCAMT            15 0                         16733
     C                   Z-SUB     TCAMT         $$AMNT                                        16733
     C                   ENDIF                                                                 16733
     C                   ENDIF                                                                 16733
     C*                                                                   167337
     C     C5064         IFEQ      '0'                                                         16733
     C                   Z-ADD     0             $$AMNT                                        16733
     C                   ENDIF                                                                 16733
     C*                                                                   167337
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0361                                      nt
      *
     C***********C5064     IFEQ '0'
     C***********          MOVE *BLANKS   C0361
     C***********          ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0362 - Populate the field C0362                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0362        BEGSR
      *
     C                   MOVEL(P)  'SC0362'      ERRSBR
      *
     C**********           Z-ADD0         $$AMNT                          167337
     C     MQXAV         IFLT      0                                                           16733
     C                   Z-ADD     MQXAV         $$AMNT                                        16733
     C                   ELSE                                                                  16733
     C                   Z-SUB     MQXAV         $$AMNT                                        16733
     C     MQXAV         IFEQ      0                                                           16733
     C     RECI          ANDEQ     'D'                                                         16733
     C***********          Z-SUBOPAM      $$AMNT                   167337 167337
     C     CPAM          SUB       PSAM          WCPAM1           13 0                         16733
     C                   Z-SUB     WCPAM1        $$AMNT                                        16733
     C                   ENDIF                                                                 16733
     C                   ENDIF                                                                 16733
     C*                                                                   167337
     C     C5064         IFEQ      '0'                                                         16733
     C                   Z-SUB     OPAM          $$AMNT                                        16733
     C                   ENDIF                                                                 16733
     C*                                                                   167337
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0362                                      nt
      *
     C***********C5064     IFEQ '0'                                       167337
     C***********          MOVE *BLANKS   C0362                           167337
     C***********          ENDIF                                          167337
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0364 - Populate the field C0364                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0364        BEGSR
      *
     C                   MOVEL(P)  'SC0364'      ERRSBR
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0364                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0366 - Populate the field C0366                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0366        BEGSR
      *
     C                   MOVEL(P)  'SC0366'      ERRSBR
      *
     C     CPAM          SUB       PSAM          WKAMT2
     C                   Z-SUB     WKAMT2        $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0366                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0379 - Populate the field C0379                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0379        BEGSR
      *
     C                   MOVEL(P)  'SC0379'      ERRSBR
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0379                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0380 - Populate the field C0380                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0380        BEGSR
      *
     C                   MOVEL(P)  'SC0380'      ERRSBR
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0380                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0382 - Populate the field C0382                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0382        BEGSR
      *
     C                   MOVEL(P)  'SC0382'      ERRSBR
      *
     C                   Z-ADD     MQDIM         $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0382                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0384 - Populate the field C0384                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0384        BEGSR
      *
     C                   MOVEL(P)  'SC0384'      ERRSBR
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0384                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0395 - Populate the field C0395                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0395        BEGSR
      *
     C                   MOVEL(P)  'SC0395'      ERRSBR
      *
     C     VDAT          IFLT      MPEQB
     C     CPAM          SUB       PSAM          WKAMT2
     C                   Z-SUB     WKAMT2        $$AMNT
     C                   ENDIF
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0395                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0396 - Populate the field C0396                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0396        BEGSR
      *
     C                   MOVEL(P)  'SC0396'      ERRSBR
      *
     C                   Z-ADD     0             $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0396                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0421 - Populate the field C0421                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0421        BEGSR
      *
     C                   MOVEL(P)  'SC0421'      ERRSBR
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0421                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0438 - Populate the field C0438                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0438        BEGSR
      *
     C                   MOVEL(P)  'SC0438'      ERRSBR
      *
     C                   Z-ADD     OPAM          $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0438                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0448 - Populate the field C0448                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0448        BEGSR
      *
     C                   MOVEL(P)  'SC0448'      ERRSBR
      *
     C     LNRF          SETLL     LOAMSKV0
     C     LNRF          READE     LOAMSKV0                               05
      *
     C     *IN05         DOWEQ     *OFF
      *
     C                   ADD       PRAM          $$AMNT
      *
     C     LNRF          READE     LOAMSKV0                               05
     C                   ENDDO
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0448                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9170 - Populate the field C9170                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC9170        BEGSR
      *
     C                   MOVEL(P)  'SC9170'      ERRSBR
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C9170                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0470 - Populate the field C0470                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC0470        BEGSR
      *
     C                   MOVEL(P)  'SC0470'      ERRSBR
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0470                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC0611 - Populate the field C0611                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC0611        BEGSR
      *
     C                   MOVEL(P)  'SC0611'      ERRSBR
      *
     C     RFRQ          IFEQ      'M'
     C                   MOVE      '1'           C0611
     C                   ENDIF
      *
     C     RFRQ          IFEQ      'Q'
     C                   MOVE      '3'           C0611
     C                   ENDIF
      *
     C     RFRQ          IFNE      ' '
     C     RFRQ          ANDNE     'M'
     C     RFRQ          ANDNE     'Q'
     C                   MOVE      '2'           C0611
     C                   ENDIF
      *
     C     RFRQ          IFEQ      ' '
     C                   MOVE      '0'           C0611
      *                                                                   MMI043
     C     LNRF          SETLL     LVENTLV0                                                    MMI04
     C     LNRF          READE     LVENTLV0                               06                   MMI04
      *                                                                   MMI043
     C     *IN06         DOWEQ     '0'                                                         MMI04
     C                   MOVE      *BLANK        REVNT             2                           MMI04
     C                   MOVE      ETYP          REVNT                                         MMI04
     C     REVNT         IFEQ      'R1'                                                        MMI04
     C                   MOVE      '2'           C0611                                         MMI04
     C                   MOVE      'Y'           SREP              1                           MMI04
     C                   ENDIF                                                                 MMI04
     C     REVNT         IFEQ      'R2'                                                        MMI04
     C                   MOVE      'Y'           SREP                                          MMI04
     C                   ENDIF                                                                 MMI04
     C     LNRF          READE     LVENTLV0                               06                   MMI04
     C                   ENDDO                                                                 MMI04
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9339 - Populate the field C9339                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC9339        BEGSR
      *
     C                   MOVEL(P)  'SC9339'      ERRSBR
      *
     C     C0611         IFEQ      '0'
     C     IPFR          IFEQ      *BLANK
     C                   MOVE      '2'           C9339
     C                   ELSE
     C***********          MOVE '3'       C9339                      MMI043
     C                   MOVE      '1'           C9339                                    MMI043
     C                   ENDIF
     C                   ENDIF
      *
     C     C0611         IFNE      '0'
     C                   MOVE      '1'           C9339
     C                   ENDIF
      *
     C     SREP          IFEQ      'Y'                                                    MMI043
     C                   MOVE      '1'           C9339                                    MMI043
     C                   ELSE                                                             MMI043
     C     C0611         IFEQ      '0'                                                    MMI043
     C                   MOVE      '2'           C9339                                    MMI043
     C                   ENDIF                                                            MMI043
     C                   ENDIF                                                            MMI043
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC1501 - Populate the field C1501                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC1501        BEGSR
      *
     C                   MOVEL(P)  'SC1501'      ERRSBR
      *
     C     BRTT          IFNE      *ZERO
      *
     C     RLDT          IFNE      *ZERO
     C                   Z-ADD     RLDT          $$DAY
     C                   ELSE
     C                   Z-ADD     MDAT          $$DAY
     C                   ENDIF
      *
     C                   ELSE
     C                   Z-ADD     *ZERO         $$DAY
     C                   ENDIF
      *
     C                   EXSR      XLM053
     C                   MOVE      $$DATE        C1501                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC5064 - Populate the field C5064                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC5064        BEGSR
      *
     C                   MOVEL(P)  'SC5064'      ERRSBR
      *
     C     MDAT          IFLE      MLACD
     C     MDAT          ANDGT     MPEMB
     C                   MOVE      '0'           C5064
     C                   ELSE
     C                   MOVE      '1'           C5064
     C                   ENDIF
      *
     C     LNRF          CHAIN     LOAMSKV0                           05
     C     *IN05         IFEQ      '0'
     C     MDAT          ANDLE     MMDNB
     C                   MOVE      '1'           C5064
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9021 - Populate the field C9021                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC9021        BEGSR
      *
     C                   MOVEL(P)  'SC9021'      ERRSBR
      *
     C                   CLEAR                   FCLTYFMF
     C     K1FCLT        CHAIN(N)  FCLTYMV0                           03
      *
     C     *IN03         IFEQ      *OFF
      *
     C                   If        NY_Amend = 'Y'                                          LUC109CC1
     C                   Z-ADD     DLFS          $$DAY                                     LUC109CC1
     C                   ELSE                                                              LUC109CC1
     C                   Z-ADD     DTAP          $$DAY                                     LUC109CC1
     C                   ENDIF                                                             LUC109CC1
     C                   EXSR      XLM053
     C                   MOVE      $$DATE        C9021                                      nt
      *
     C                   ELSE
      *
     C                   Z-ADD     10            COD
     C                   EXSR      PRINT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9022 - Populate the field C9022                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC9022        BEGSR
      *
     C                   MOVEL(P)  'SC9022'      ERRSBR
      *
     C                   CLEAR                   FCLTYFMF
     C     K1FCLT        CHAIN(N)  FCLTYMV0                           03
      *
     C     *IN03         IFEQ      *OFF
      *
     C                   Z-ADD     DTEX          $$DAY
     C                   EXSR      XLM053
     C                   MOVE      $$DATE        C9022                                      nt
      *
     C                   ELSE
      *
     C                   Z-ADD     10            COD
     C                   EXSR      PRINT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC5383 - Populate the field C5383                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC5383        BEGSR
      *
     C                   MOVEL(P)  'SC5383'      ERRSBR
      *
     C     VDAT          IFGT      MPEQB
     C***********PTYP      IFEQ 66                                        167470
     C***********PTYP      OREQ 67                                        167470
     C***********CPAM      SUB  PSAM      $$AMNT                          167470
     C     OPAM          SUB       PSAM          $$AMT1                                        16747
     C                   Z-SUB     $$AMT1        $$AMNT                                        16747
     C***********          ENDIF                                          167470
     C                   ENDIF
     C                   Z-ADD     0             $$AMT1                                        16747
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C5383                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC5385 - Populate the field C5385                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC5385        BEGSR
      *
     C                   MOVEL(P)  'SC5385'      ERRSBR
      *
     C                   Z-ADD     MACPQ         $$AMNT                                        16747
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C5385                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC5445 - Populate the field C5445                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC5445        BEGSR
      *
     C                   MOVEL(P)  'SC5445'      ERRSBR
      *
     C                   CLEAR                   C5445
      *
     C     VDAT          IFGT      MPEQB
     C***********PTYP      IFEQ 66                                        167470
     C***********PTYP      OREQ 67                                        167470
     C     OPAM          SUB       PSAM          $$AMT1           15 0                         16878
     C     $$AMT1        IFNE      0                                                           16878
     C                   Z-ADD     1             C5445
     C                   ELSE                                                                  16878
     C                   Z-ADD     0             C5445                                         16878
     C                   ENDIF                                                                 16878
     C***********          ENDIF                                          167470
     C                   ENDIF
     C                   Z-ADD     0             $$AMT1                                        16878
      *
     C                   ENDSR
      *                                                                   167470
      *****************************************************************   167470
      *                                                               *   167470
      *  SC5446 - Populate the field C5446                            *   167470
      *                                                               *   167470
      *  Called By: MOVFLD                                            *   167470
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *   167470
      *****************************************************************   167470
      *                                                                   167470
     C     SC5446        BEGSR                                                                 16747
      *                                                                   167470
     C                   MOVEL(P)  'SC5446'      ERRSBR                                        16747
      *                                                                   167470
     C                   CLEAR                   C5446                                         16747
      *                                                                   167470
     C     MACPQ         IFNE      0                                                           17448
     C                   Z-ADD     MNCPQ         C5446                                         16747
     C                   ELSE                                                                  17448
     C                   Z-ADD     0             C5446                                         17448
     C                   ENDIF                                                                 17448
      *                                                                   167470
     C                   ENDSR                                                                 16747
      *
      *****************************************************************
      *                                                               *
      *  SC6145 - Populate the field C6145                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC6145        BEGSR
      *
     C                   MOVEL(P)  'SC6145'      ERRSBR
      *
     C     BRTT          IFNE      *ZERO
     C                   MOVE      'V'           C6145                                      nt
     C                   ENDIF
      *
     C                   IF        NY_Amend = 'Y'                                          LUC109CC1
     C     BRTT          IFEQ      *ZERO                                                   LUC109CC1
     C     RLDT          ANDEQ     *ZERO                                                   LUC109CC1
     C     DLRC          ANDEQ     VDAT                                                    LUC109CC1
     C                   MOVE      'F'           C6145                                     LUC109CC1
     C                   ELSE                                                              LUC109CC1
     C                   MOVE      'V'           C6145                                     LUC109CC1
     C                   ENDIF                                                             LUC109CC1
      *                                                                                    LUC109CC1
     C                   ELSE                                                              LUC109CC1
     C     INTR          IFNE      *ZERO
     C     BRTT          ANDEQ     *ZERO
     C                   MOVE      'F'           C6145                                      nt
     C                   ENDIF
      *                                                                                    LUC109CC1
     C                   ENDIF                                                             LUC109CC1
      *
     C     INTR          IFEQ      *ZERO
     C     BRTT          ANDEQ     *ZERO
     C                   MOVE      'I'           C6145                                      nt
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9238 - Populate the field C9238                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC9238        BEGSR
      *
     C                   MOVEL(P)  'SC9238'      ERRSBR
      *
     C                   Z-ADD     VDAT          @DAYNO
     C                   Z-ADD     1             @NRDYS
     C                   MOVE      CCY           @CCY
     C                   CLEAR                   @LOC
      *
     C**********         CALL      'GLM043'                                     Parameters    LUC109
     C                   CALL      'XX000043'                                   Parameters    LUC109
     C                   PARM                    @DAYNO            5 0          Input Day #
     C                   PARM                    @NRDYS            2 0          # Wk Dys Fwd
     C                   PARM                    @CCY              3            Currency
     C                   PARM                    @LOC              3            Locn-optionl
     C                   PARM                    @DYNBR            5 0          Output Day #
      *
     C     MDAT          IFLE      @DYNBR
     C     MDAT          ANDNE     0
     C                   MOVE      '1'           C9238
     C                   ELSE
     C                   MOVE      '0'           C9238
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9340 - Populate the field C9340                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC9340        BEGSR
      *
     C                   MOVEL(P)  'SC9340'      ERRSBR
      *
     C                   Z-ADD     RLDT          $$DAY
     C                   EXSR      XLM053
     C                   MOVE      $$DATE        C9340                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9342 - Populate the field C9342                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     SC9342        BEGSR
      *
     C                   MOVEL(P)  'SC9342'      ERRSBR
      *
     C                   MOVE      C9152         K1ACCD
     C                   MOVE      '9'           K1RSNO
     C                   CLEAR                   SDACRCD0
      *
     C     CPAM          IFGT      *ZERO                                        IF    01
     C                   MOVE      'D'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     CPAM          IFLT      *ZERO                                        IF    01
     C                   MOVE      'C'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     CPAM          IFEQ      *ZERO                                        IF    01
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      'D'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      'C'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     *IN03         IFEQ      *OFF                                         IF    01
      *
     C                   TESTN                   G6RSCD               77
     C     *IN77         IFEQ      *ON                                          IF    02
     C                   MOVE      G6RSCD        C9342
     C                   ELSE                                                   ELSE  02
     C                   CLEAR                   C9342
     C                   Z-ADD     6             COD
     C                   EXSR      PRINT
     C                   ENDIF                                                  ENDIF 02
      *
     C                   ELSE                                                   ELSE  01
     C                   CLEAR                   C9342
     C                   Z-ADD     5             COD
     C                   EXSR      PRINT
     C                   ENDIF                                                  ENDIF 01
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9343 - Populate the field C9343                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     SC9343        BEGSR
      *
     C                   MOVEL(P)  'SC9343'      ERRSBR
      *
     C                   MOVE      C9153         K1ACCD
     C                   MOVE      '9'           K1RSNO
     C                   CLEAR                   SDACRCD0
      *
     C     CPAM          IFGT      *ZERO                                        IF    01
     C                   MOVE      'D'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     CPAM          IFLT      *ZERO                                        IF    01
     C                   MOVE      'C'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     CPAM          IFEQ      *ZERO                                        IF    01
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      'D'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      'C'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     *IN03         IFEQ      *OFF                                         IF    01
      *
     C                   TESTN                   G6RSCD               77
     C     *IN77         IFEQ      *ON                                          IF    02
     C                   MOVE      G6RSCD        C9343
     C                   ELSE                                                   ELSE  02
     C                   CLEAR                   C9343
     C                   Z-ADD     6             COD
     C                   EXSR      PRINT
     C                   ENDIF                                                  ENDIF 02
      *
     C                   ELSE                                                   ELSE  01
     C                   CLEAR                   C9343
     C                   Z-ADD     5             COD
     C                   EXSR      PRINT
     C                   ENDIF                                                  ENDIF 01
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9344 - Populate the field C9344                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     SC9344        BEGSR
      *
     C                   MOVEL(P)  'SC9344'      ERRSBR
      *
     C                   MOVE      C9154         K1ACCD
     C                   MOVE      '9'           K1RSNO
     C                   CLEAR                   SDACRCD0
      *
     C     CPAM          IFGT      *ZERO                                        IF    01
     C                   MOVE      'D'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     CPAM          IFLT      *ZERO                                        IF    01
     C                   MOVE      'C'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     CPAM          IFEQ      *ZERO                                        IF    01
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      'D'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      'C'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     *IN03         IFEQ      *OFF                                         IF    01
      *
     C                   TESTN                   G6RSCD               77
     C     *IN77         IFEQ      *ON                                          IF    02
     C                   MOVE      G6RSCD        C9344
     C                   ELSE                                                   ELSE  02
     C                   CLEAR                   C9344
     C                   Z-ADD     6             COD
     C                   EXSR      PRINT
     C                   ENDIF                                                  ENDIF 02
      *
     C                   ELSE                                                   ELSE  01
     C                   CLEAR                   C9344
     C                   Z-ADD     5             COD
     C                   EXSR      PRINT
     C                   ENDIF                                                  ENDIF 01
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9345 - Populate the field C9345                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     SC9345        BEGSR
      *
     C                   MOVEL(P)  'SC9345'      ERRSBR
      *
     C                   MOVE      C9176         K1ACCD
     C                   MOVE      '9'           K1RSNO
     C                   CLEAR                   SDACRCD0
      *
     C     CPAM          IFGT      *ZERO                                        IF    01
     C                   MOVE      'D'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     CPAM          IFLT      *ZERO                                        IF    01
     C                   MOVE      'C'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     CPAM          IFEQ      *ZERO                                        IF    01
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      'D'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      'C'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     *IN03         IFEQ      *OFF                                         IF    01
      *
     C                   TESTN                   G6RSCD               77
     C     *IN77         IFEQ      *ON                                          IF    02
     C                   MOVE      G6RSCD        C9345
     C                   ELSE                                                   ELSE  02
     C                   CLEAR                   C9345
     C                   Z-ADD     6             COD
     C                   EXSR      PRINT
     C                   ENDIF                                                  ENDIF 02
      *
     C                   ELSE                                                   ELSE  01
     C                   CLEAR                   C9345
     C                   Z-ADD     5             COD
     C                   EXSR      PRINT
     C                   ENDIF                                                  ENDIF 01
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9377 - Populate the field C9377                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC9377        BEGSR
      *
     C                   MOVEL(P)  'SC9377'      ERRSBR
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C9377                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************   LUC010
      *                                                               *   LUC010
      *  SC9802 - Populate the field C9802                            *   LUC010
      *                                                               *   LUC010
      *  Called By: MOVFLD                                            *   LUC010
      *                                                               *   LUC010
      *****************************************************************   LUC010
      *                                                                   LUC010
     C     SC9802        BEGSR                                                                 LUC01
      *                                                                   LUC010
     C                   MOVEL(P)  'SC9802'      ERRSBR                                        LUC01
      *                                                                   LUC010
     C                   MOVE      FCUS          C9802                                         LUC01
      *                                                                   LUC010
     C                   ENDSR                                                                 LUC01
      *                                                                   LUC010
      *****************************************************************   LUC010
      *                                                               *   LUC010
      *  SC9811 - Populate the field C9811                            *   LUC010
      *                                                               *   LUC010
      *  Called By: MOVFLD                                            *   LUC010
      *                                                               *   LUC010
      *****************************************************************   LUC010
      *                                                                   LUC010
     C     SC9811        BEGSR                                                                 LUC01
      *                                                                   LUC010
     C                   MOVEL(P)  'SC9811'      ERRSBR                                        LUC01
      *                                                                   LUC010
     C                   MOVE      PRFC          C9811                                         LUC01
      *                                                                   LUC010
     C                   ENDSR                                                                 LUC01
      *                                                                   LUC010
      *****************************************************************   LUC010
      *                                                               *   LUC010
      *  SC9812 - Populate the field C9812                            *   LUC010
      *                                                               *   LUC010
      *  Called By: MOVFLD                                            *   LUC010
      *                                                               *   LUC010
      *****************************************************************   LUC010
      *                                                                   LUC010
     C     SC9812        BEGSR                                                                 LUC01
      *                                                                   LUC010
     C                   MOVEL(P)  'SC9812'      ERRSBR                                        LUC01
      *                                                                   LUC010
     C     MARG          IFEQ      *ZERO                                                       LUC01
     C                   MOVEL     *ZEROS        C9812                                         LUC01
     C                   ELSE                                                                  LUC01
     C     MARG          IFLT      *ZERO                                                       LUC01
     C                   MOVEL     '-0'          C9812                                         LUC01
     C                   Z-SUB     MARG          WMARG             7 5                         LUC01
     C                   MOVE      WMARG         C9812                                         LUC01
     C                   ELSE                                                                  LUC01
     C                   MOVEL     '+0'          C9812                                         LUC01
     C                   MOVE      MARG          C9812                                         LUC01
     C                   ENDIF                                                                 LUC01
     C                   ENDIF                                                                 LUC01
      *                                                                   LUC010
     C                   ENDSR                                                                 LUC01
      *                                                                   LUC010
      *****************************************************************   MUI011
      *                                                               *   MUI011
      *  SC9851 - Populate the field C9851                            *   MUI011
      *                                                               *   MUI011
      *  Called By: MOVFLD                                            *   MUI011
      *                                                               *   MUI011
      *****************************************************************   MUI011
      *                                                                   MUI011
     C     SC9851        BEGSR                                                                 MUI01
      *                                                                   MUI011
     C                   MOVEL(P)  'SC9851'      ERRSBR                                        MUI01
      *                                                                   MUI011
     C     BRTT          IFNE      0                                                           MUI01
     C     RTSP          ANDNE     0                                                           MUI01
     C     NY_Amend      IFNE      'Y'                                                     LUC109CC1
     C     RTSP          IFLT      0                                                           MUI01
     C                   Z-SUB(H)  RTSP          WK9851            8 5                         MUI01
     C                   MOVEL     '-'           C9851                                         MUI01
     C                   ELSE                                                                  MUI01
     C                   Z-ADD     RTSP          WK9851                                        MUI01
     C                   MOVEL     '+'           C9851                                         MUI01
     C                   ENDIF                                                                 MUI01
     C                   ENDIF                                                             LUC109CC1
     C     NY_Amend      IFEQ      'Y'                                                     LUC109CC1
     C     SPIN          IFEQ      'S'                                                     LUC109CC1
     C                   Z-ADD(H)  RTSP          WK9851            8 5                     LUC109CC1
     C                   MOVEL     '-'           C9851                                     LUC109CC1
     C                   ELSE                                                              LUC109CC1
     C                   Z-ADD     RTSP          WK9851                                    LUC109CC1
     C                   MOVEL     '+'           C9851                                     LUC109CC1
     C                   ENDIF                                                             LUC109CC1
     C                   ENDIF                                                             LUC109CC1
      *                                                                                    LUC109CC1
     C                   MOVE      WK9851        C9851                                         MUI01
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
     C                   ENDSR                                                                 MUI01
      *                                                                   MUI011
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
     C     RECI          IFEQ      'D'
     C     PTYP          ANDNE     66                                                          16799
     C     PTYP          ANDNE     67                                                          16799
     C     PTYP          ANDNE     70                                                          16799
     C     PTYP          ANDNE     71                                                          16799
     C     PTYP          ANDNE     72                                                          16799
     C                   MOVE      *OFF          *IN02
      *
     C                   ELSE
      *
     C     RECI          IFEQ      'M'
      *
     C     MDAT          IFGT      MPEMB
     C     PTYP          ANDNE     66                                                          16799
     C     PTYP          ANDNE     67                                                          16799
     C     PTYP          ANDNE     70                                                          16799
     C     PTYP          ANDNE     71                                                          16799
     C     PTYP          ANDNE     72                                                          16799
     C                   MOVE      *OFF          *IN02
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
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
     C                   CLEAR                   $$CAMT
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
     C                   CLEAR                   $$AMNT
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      ***XLM053*-*Calling*Routine*GLM053*for*date*conversion***********                       LUC109
      *  XLM053 - Calling Routine XX000053 for date conversion        *                       LUC109
      *                                                               *
      *  Called By:                                                   *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     XLM053        BEGSR
      *
     C                   MOVEL(P)  'XLM053'      ERRSBR
      *
     C                   CLEAR                   $$DATE
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
     C                   CLEAR                   ERRD01
     C                   CLEAR                   ERRD02
     C                   CLEAR                   ERRD03
     C                   CLEAR                   ERRD04
      *
     C                   SELECT
     C     COD           WHENEQ    1
     C                   MOVEL     LNRF          ERRD01
     C     COD           WHENEQ    2
     C                   MOVEL     BRCA          ERRD01
     C     COD           WHENEQ    3
     C                   MOVEL     K1ACKE        ERRD01
     C                   MOVEL     PTYP          ERRD02
     C     COD           WHENEQ    4
     C                   MOVEL     $$CCYC        ERRD02
     C                   MOVEL     $$AMNT        ERRD03
     C     COD           WHENEQ    5
     C     K1RSNO        CAT       K1ACCD:0      ERRD01
     C     ERRD01        CAT       K1DRCR:0      ERRD01
     C     COD           WHENEQ    6
     C                   MOVEL     G6RSCD        ERRD02
     C     COD           WHENEQ    7
     C     COD           WHENEQ    8
     C     COD           WHENEQ    9
     C                   MOVEL     MCSLD         ERRD01
     C     COD           WHENEQ    10
     C                   MOVE      CNUM          ERRD01
     C                   MOVE      FTYP          ERRD02
     C                   MOVE      FSEQ          ERRD03
     C     COD           WHENEQ    11
     C                   MOVEL     LNRF          ERRD01
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
     C     COD           IFNE      0
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
     C     *LIKE         DEFINE    G6RSNO        K1RSNO
     C     *LIKE         DEFINE    G6ACCD        K1ACCD
     C     *LIKE         DEFINE    G6DRCR        K1DRCR
     C     *LIKE         DEFINE    CNUM          XCNUM                                         17447
     C     *LIKE         DEFINE    LNRF          XLNRF                                         17447
     C     *LIKE         DEFINE    VDAT          XVDAT                                         17447
      *
     C     K1ACRC        KLIST
     C                   KFLD                    K1RSNO
     C                   KFLD                    K1ACCD
     C                   KFLD                    K1DRCR
      *
     C     K1FCLT        KLIST
     C                   KFLD                    FCUS
     C                   KFLD                    FTYP
     C                   KFLD                    FSEQ
     C*                                                                   174479
     C     K1HIST        KLIST                                                                 17447
     C                   KFLD                    XBRCA                                         17447
     C                   KFLD                    XCNUM                                         17447
     C                   KFLD                    XLNRF                                         17447
     C                   KFLD                    XVDAT                                         17447
      *
     C                   CALL      'AOSVALR0'                                              LUC109CC1
     C                   PARM                    @RTCD             7                       LUC109CC1
     C                   PARM      SVALKK        SVALK1           20                       LUC109CC1
     C                   PARM      *BLANKS       SVAL1           200                       LUC109CC1
     C                   PARM                    SVALK2           20                       LUC109CC1
     C                   PARM                    SVAL2           200                       LUC109CC1
     C                   PARM                    SVALK3           20                       LUC109CC1
     C                   PARM                    SVAL3           200                       LUC109CC1
     C                   PARM                    SVALK4           20                       LUC109CC1
     C                   PARM                    SVAL4           200                       LUC109CC1
     C                   PARM                    SVALK5           20                       LUC109CC1
     C                   PARM                    SVAL5           200                       LUC109CC1
     C                   PARM                    SVALK6           20                       LUC109CC1
     C                   PARM                    SVAL6           200                       LUC109CC1
     C                   PARM                    SVALK7           20                       LUC109CC1
     C                   PARM                    SVAL7           200                       LUC109CC1
     C                   PARM                    SVALK8           20                       LUC109CC1
     C                   PARM                    SVAL8           200                       LUC109CC1
     C                   PARM                    SVALK9           20                       LUC109CC1
     C                   PARM                    SVAL9           200                       LUC109CC1
     C                   PARM                    SVALK0           20                       LUC109CC1
     C                   PARM                    SVAL10          200                       LUC109CC1
      *                                                                                    LUC109CC1
      ** If Set to use NY Amendments                                                       LUC109CC1
     C     SVAL11        IFEQ      'Y'                                                     LUC109CC1
     C                   MOVE      'Y'           NY_Amend          1                       LUC109CC1
     C                   ELSE                                                              LUC109CC1
     C                   MOVE      'N'           NY_AMend                                  LUC109CC1
     C                   ENDIF                                                             LUC109CC1
                                                                                           LUC109CC1
     C                   ENDSR
**
CLOANKV0 RECORD NOT FOUND
SDBRCHV0 RECORD NOT FOUND
ACKEYV0  RECORD NOT FOUND
ERROR FOUND CALLING XX000041
SDACRCV0 RECORD NOT FOUND
G6RSCD NOT NUMERIC
SDBANKPD FILE IS EMPTY
SDGELRV0 FILE IS EMPTY
SDCUSTPD RECORD NOT FOUND
FCLTYMV0 RECORD NOT FOUND
CLOANCY0 RECORD NOT FOUND
12
13
14
15
