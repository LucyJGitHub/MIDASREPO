     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('FECCD Retail/Nostro Account Extract')                  *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM028**-*FECCD*Retail/Nostro*Account*Extract*****************                       LUC109
      *  XX000028 - FECCD Retail/Nostro Account Extract               *                       LUC109
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
      *                 CM000xxxxx - ND    Date 07Jan13               *
      *                 MUI011             Date 19May04               *
      *                 LUC010             Date 22Aug01               *
      *                 167338             Date 27Oct99               *
      *                 168582             Date 25Oct99               *
      *                 MMI043             Date 23Jun99               *
      *                 MMI043             Date 11Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109CC1 - New York Amendments                              *
      *         - C9021 and C9022 must be zero if facility not found. *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  CM000xxxxx - Set fields C6124 and C9118 to zero if the       *
      *               input rate is negative                          *
      *  MUI011 - ALMS - Add detail records 17 and 18.                *
      *           Also, make sure fields C9104 and C9118 are filled   *
      *           even if Base Rate is used.                          *
      *  LUC010 - Changes to Head Office Extracts                     *
      *  167338 - Additonal amendment to this fix                     *
      *  167338 - Do not process accounts closed before month begin.  *
      *  168582 - Change sign of debit holdings                       *
      *  MMI043 - Change sign of credit entries for C0364 and do not  *
      *           report debit entries w/ positive sign.              *
      *  MMI043 - Balance Sheet Extract                               *
      *                                                               *
      *****************************************************************
      *
     FACCNTBV1  IF   E           K DISK
      *
     FACCNTBY1  IF   E           K DISK
     FSDBRCHV0  IF   E           K DISK
     FSDCUSTV0  IF   E           K DISK
     FSDACODV0  IF   E           K DISK
     FSDACRCV0  IF   E           K DISK
     F*FCLTYNV0UF  E           K        DISK
     FFCLTYMV0  IF   E           K DISK
     FHELDIBV0  IF   E           K DISK
      *
     FSDBANKPD  IF   E           K DISK    USROPN
     FSDGELRV0  IF   E           K DISK    USROPN
     FREIAC     IF   E           K DISK
     FREINT     IF   E           K DISK
      *
     FFECCDDPP  O    E             DISK
     F***GLM028AU  O    E             PRINTER OFLIND(*IN20)                                   LUC109
     FXX000028AUO    E             PRINTER OFLIND(*IN20)                                      LUC109
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01 - LF/ACCNTBV1   File I                                   *
      *   02 - LF/SDCUSTV0   File I                                   *
      *   03 - LF/SDBRCHV0   File I                                   *
      *   04 - LF/SDACODV0   File I                                   *
      *   05 - LF/ACCNTBY1   File I                                   *
      *   06 - LF/FCLTYMV0   File I                                   *
      *                                                               *   167338
      *   22 - CHKREC indicator                                       *   167338
      *                                                               *
      *   45 - REIAC Retrieval                                        *
      *   46 - REINT Retrieval                                        *
      *                                                               *
      *   LR - LF/SDBANKPD   File I                                   *
      *   LR - LF/SDGELRPP   File I                                   *
      *                                                               *
      ****20*-*PRTF/GLM028AU*File*O*Overflow*indicator*****************                       LUC109
      *   20 - PRTF/XX000028AU File O Overflow indicator              *                       LUC109
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  MAIN   - Main Processing                                     *
      *  CHKREC - Check if the input record must be processed         *   167338
      *  ACCNY1 - Chain ACCNTBY1 extension file                       *
      *  FCLTY0 - Chain FCLTYMV0 extension file                       *
      *  SDACOD - Chain SDACODV0 extension file                       *
      *  MOVFLD - Populate all the fields of the output file          *
      *                                                               *
      *     All the following subroutines populate the corresponding  *
      *     field name                                                *
      *                                                               *
      *  SC9003 - Populate the field C9003                            *
      *  SC9151 - Populate the field C9151                            *
      *  SC9176 - Populate the field C9176                            *
      *  SC9177 - Populate the field C9177                            *
      *  SC9178 - Populate the field C9178                            *
      *  SC9157 - Populate the field C9157                            *
      *  SC9100 - Populate the field C9100                            *
      *  SC9101 - Populate the field C9101                            *
      *  SC9102 - Populate the field C9102                            *
      *  SC9103 - Populate the field C9103                            *
      *  SC9104 - Populate the field C9104                            *
      *  SC9114 - Populate the field C9114                            *
      *  SC9115 - Populate the field C9115                            *
      *  SC9116 - Populate the field C9116                            *
      *  SC9117 - Populate the field C9117                            *
      *  SC9118 - Populate the field C9118                            *
      *  SC9113 - Populate the field C9113                            *
      *  SC9112 - Populate the field C9112                            *
      *  SC0051 - Populate the field C0051                            *
      *  SC0052 - Populate the field C0052                            *
      *  SC0053 - Populate the field C0053                            *
      *  SC9160 - Populate the field C9160                            *
      *  SC0064 - Populate the field C0064                            *
      *  SC0301 - Populate the field C0301                            *
      *  SC0316 - Populate the field C0316                            *
      *  SC0319 - Populate the field C0319                            *
      *  SC0322 - Populate the field C0322                            *
      *  SC0325 - Populate the field C0325                            *
      *  SC0328 - Populate the field C0328                            *
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
      *  SC0448 - Populate the field C0448                            *
      *  SC9170 - Populate the field C9170                            *
      *  SC0470 - Populate the field C0470                            *
      *  SC1501 - Populate the field C1501                            *
      *  SC5064 - Populate the field C5064                            *
      *  SC9021 - Populate the field C9021                            *
      *  SC9022 - Populate the field C9022                            *
      *  SC5383 - Populate the field C5383                            *
      *  SC5385 - Populate the field C5385                            *
      *  SC6003 - Populate the field C6003                            *
      *  SC6145 - Populate the field C6145                            *
      *  SC9340 - Populate the field C9340                            *
      *  SC9342 - Populate the field C9342                            *
      *  SC9345 - Populate the field C9345                            *
      *  SC9377 - Populate the field C9377                            *
      *  SC9811 - Populate the field C9811                            *   LUC010
      *  SC9813 - Populate the field C9813                            *   LUC010
      *  SC9814 - Populate the field C9814                            *   LUC010
      *  SC6124 - Populate the field C6124                            *   CM000XXX
      *                                                               *
      ***XLM053*-*Calling*Routine*GLM053*for*date*conversion***********                       LUC109
      *  XLM053 - Calling Routine XX000053 for date conversion        *                       LUC109
      ***XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conversion***                       LUC109
      *  XLM041 - Calling Routine XX000041 for AM data type conversion*                       LUC109
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
      *
     D SVALKK          C                   CONST('HOR_NY_Amendments')                      LUC109CC1
     D MSG             S             30    DIM(10) CTDATA PERRCD(1)
      *
     D WC9151          DS
     D  BRCA                   1      3
     D  CNUM                   4      9  0
     D  CCY                   10     12
     D  ACOD                  13     16  0
     D  ACSQ                  17     18  0
      *
     D                 DS
     D  DSREIN                 1     12
     D  DSREK1                 1      2  0
     D  DSREK2                 3      7  0
     D  DSREK3                 8     10
     D  DSREK4                11     12
      *
     D KTBY            DS
     D  BRCAX                  1      3
     D  NUMX                   4      9
     D  CCYX                  10     12
     D  ACODX                 13     16
     D  ACSQX                 17     18
      *
     D                 DS
     D  BAL2                   1     88
     D  @BAL                   1     88P 0
     D                                     DIM(11)
      *
     D                 DS
     D  RAT2                   1     66
     D  @RAT                   1     66P 0
     D                                     DIM(11)
     D DSSDY         E DS                  EXTNAME(DSSDY)                       MUI011
     D*                                                                   MUI011
     D** Second DS for access programs, long data structure               MUI011
     D*                                                                   MUI011
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)                    MUI011
      **  Data Structure for AOSVALR0 string                                               LUC109CC1
     DSVAL1            DS           200                                                    LUC109CC1
     DSVAL11                   1      1                                                    LUC109CC1
      *--------------------------------------------------------------------*
      *
     IFCLTYFMF
     I              CNUM                        CNUM$1
     I              BRCA                        BRCA$1
     I              MCCY                        MCCY$1
     I              ACSQ                        ACSQ$1
     I              FACT                        FACT$1
     I              FCNO                        FCNO$1
      *
     IHELDIHBF
     I              CNUM                        CNUM$2
     I              BRCA                        BRCA$2
     I              ACSQ                        ACSQ$2
     I              ACOD                        ACOD$2
     I              CCY                         CCY$2
      *
     IREIACDF
     I              CNUM                        CNUM$3
     I              BRCA                        BRCA$3
     I              ACSQ                        ACSQ$3
     I              ACOD                        ACOD$3
     I              CCY                         CCY$3
     I*                                                                   MUI011
     I** Base Rate Code Details                                           MUI011
      *****************************************************************
      *                                                               *
      *  MAIN   - Main processing                                     *
      *                                                               *
      *  Called By:                                                   *
      *         ACCNY1 - Chain ACCNTBY1 extension file                *
      *         FCLTY0 - Chain FCLTYMV0 extension file                *
      *         SDACOD - Chain SDACODV0 extension file                *
      *         MOVFLD - Populate all the fields of the output file   *
      *                                                               *
      *****************************************************************
      *
     C     *LOVAL        SETLL     ACCNTBV1
     C                   READ      ACCNTBV1                               01
      *
     C     *IN01         DOWEQ     *OFF
      *
     C                   EXSR      CHKREC                                                      16733
      *                                                                   167338
     C     *IN22         IFEQ      *OFF                                                        16733
      *                                                                   167338
     C                   EXSR      ACCNY1
     C                   EXSR      FCLTY0
     C                   EXSR      SDACOD
     C                   EXSR      MOVFLD
      *
     C****       ERRMSG    IFEQ *BLANK
     C                   WRITE     FECCDDP0
     C****                 ENDIF
      *
     C                   CLEAR                   FECCDDP0
      *
     C                   ENDIF                                                                 16733
      *                                                                   167338
     C                   READ      ACCNTBV1                               01
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
      *  ACCNY1 - Chain ACCNTBY1 extension file                       *
      *                                                               *
      *  Called By: Main processing                                   *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     ACCNY1        BEGSR
      *
     C                   MOVEL(P)  'ACCNY1'      ERRSBR
      *
     C                   CLEAR                   ACCNBFX0
     C     KACTBY        CHAIN     ACCNTBY1                           05
      *
     C     *IN05         IFEQ      *ON
     C                   Z-ADD     1             COD
     C                   EXSR      PRINT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  FCLTY0 - Chain FCLTYMV0 extension file                       *
      *                                                               *
      *  Called By: Main processing                                   *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     FCLTY0        BEGSR
      *
     C                   MOVEL(P)  'FCLTY0'      ERRSBR
      *
     C                   CLEAR                   FCLTYFMF
     C                   IF        NY_Amend = 'Y'                                          LUC109CC1
     C                   Z-ADD     0             DTAP                                      LUC109CC1
     C                   Z-ADD     0             DTEX                                      LUC109CC1
     C                   ENDIF                                                             LUC109CC1
      *                                                                                    LUC109CC1
     C     NY_Amend      IFNE      'Y'                                                     LUC109CC1
     C     KFCLTY        CHAIN     FCLTYMV0                           06
      *
     C     *IN06         IFEQ      *ON
     C                   Z-ADD     5             COD
     C                   EXSR      PRINT
     C                   ENDIF
     C                   ENDIF                                                             LUC109CC1
      *
     C     NY_Amend      IFNE      'Y'                                                     LUC109CC1
     C     FACT          ANDNE     *ZERO                                                   LUC109CC1
     C     KFCLTY        CHAIN     FCLTYMV0                           06                   LUC109CC1
      *                                                                                    LUC109CC1
     C     *IN06         IFEQ      *ON                                                     LUC109CC1
     C                   Z-ADD     5             COD                                       LUC109CC1
     C                   EXSR      PRINT                                                   LUC109CC1
     C                   ENDIF                                                             LUC109CC1
     C                   ENDIF                                                             LUC109CC1
      *                                                                                    LUC109CC1
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SDACOD - Chain SDACODV0 extension file                       *
      *                                                               *
      *  Called By: Main processing                                   *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     SDACOD        BEGSR
      *
     C                   MOVEL(P)  'SDACOD'      ERRSBR
      *
     C                   MOVE      ACOD          ACODX             4
     C                   CLEAR                   SDACODD0
     C     ACODX         CHAIN     SDACODV0                           04
      *
     C     *IN04         IFEQ      *ON
     C                   Z-ADD     3             COD
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
      *             SC9151 - Populate the field C9151                 *
      *             SC9176 - Populate the field C9176                 *
      *             SC9177 - Populate the field C9177                 *
      *             SC9178 - Populate the field C9178                 *
      *             SC9157 - Populate the field C9157                 *
      *             SC9100 - Populate the field C9100                 *
      *             SC9101 - Populate the field C9101                 *
      *             SC9102 - Populate the field C9102                 *
      *             SC9103 - Populate the field C9103                 *
      *             SC9104 - Populate the field C9104                 *
      *             SC9114 - Populate the field C9114                 *
      *             SC9115 - Populate the field C9115                 *
      *             SC9116 - Populate the field C9116                 *
      *             SC9117 - Populate the field C9117                 *
      *             SC9118 - Populate the field C9118                 *
      *             SC9113 - Populate the field C9113                 *
      *             SC9112 - Populate the field C9112                 *
      *             SC0051 - Populate the field C0051                 *
      *             SC0052 - Populate the field C0052                 *
      *             SC0053 - Populate the field C0053                 *
      *             SC9160 - Populate the field C9160                 *
      *             SC0064 - Populate the field C0064                 *
      *             SC0301 - Populate the field C0301                 *
      *             SC0316 - Populate the field C0316                 *
      *             SC0319 - Populate the field C0319                 *
      *             SC0322 - Populate the field C0322                 *
      *             SC0325 - Populate the field C0325                 *
      *             SC0328 - Populate the field C0328                 *
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
      *             SC0448 - Populate the field C0448                 *
      *             SC9170 - Populate the field C9170                 *
      *             SC0470 - Populate the field C0470                 *
      *             SC1501 - Populate the field C1501                 *
      *             SC5064 - Populate the field C5064                 *
      *             SC9021 - Populate the field C9021                 *
      *             SC9022 - Populate the field C9022                 *
      *             SC5383 - Populate the field C5383                 *
      *             SC5385 - Populate the field C5385                 *
      *             SC6003 - Populate the field C6003                 *
      *             SC6145 - Populate the field C6145                 *
      *             SC9340 - Populate the field C9340                 *
      *             SC9342 - Populate the field C9342                 *
      *             SC9345 - Populate the field C9345                 *
      *             SC9377 - Populate the field C9377                 *
      *             SC9811 - Populate the field C9811                 *   LUC010
      *             SC9813 - Populate the field C9813                 *   LUC010
      *             SC9814 - Populate the field C9814                 *   LUC010
      *                                                               *
      *****************************************************************
      *
     C     MOVFLD        BEGSR
      *
     C                   MOVEL(P)  'MOVFLD'      ERRSBR
      *
     C                   EXSR      SC9003
     C                   Z-ADD     CNUM          C5125
     C                   MOVE      'N'           C9172
     C                   MOVE      BRCA          C0120
     C                   MOVE      CCY           C0150
     C                   MOVEL     'RE'          C9149
     C                   MOVE      *BLANK        C9150
     C                   EXSR      SC9151
     C                   EXSR      SC9177
     C                   EXSR      SC9178
     C                   Z-ADD     ACOD          C9152
     C                   CLEAR                   C9153
     C                   CLEAR                   C9154
     C                   EXSR      SC9157
     C                   CLEAR                   C9173
     C                   CLEAR                   C9174
     C                   CLEAR                   C9175
     C                   EXSR      SC9176
     C                   Z-ADD     MDAVR         C6126
     C******************** Z-ADDMCAVR     C6124
     C                   EXSR      SC6124
     C                   EXSR      SC9100
     C                   EXSR      SC9101
     C                   EXSR      SC9102
     C                   EXSR      SC9103
     C                   EXSR      SC9104
     C                   EXSR      SC9114
     C                   EXSR      SC9115
     C                   EXSR      SC9116
     C                   EXSR      SC9117
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
     C                   CLEAR                   C0110
     C                   EXSR      SC0301
     C                   EXSR      SC0316
     C                   EXSR      SC0319
     C                   EXSR      SC0322
     C                   EXSR      SC0325
     C                   EXSR      SC0328
     C                   CLEAR                   C5334
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
     C                   Z-ADD     MNOCQ         C0456
     C                   EXSR      SC9170
     C                   EXSR      SC0470
     C                   Z-ADD     MRVNO         C0485
     C                   MOVE      *BLANK        C0584
     C                   MOVE      *BLANK        C0611
     C                   MOVE      '2'           C9339
     C                   MOVE      *BLANK        C0814
     C                   EXSR      SC1501
     C                   EXSR      SC5064
     C                   Z-ADD     FACT          C9019
     C                   Z-ADD     FCNO          C9020
     C                   EXSR      SC9021
     C                   EXSR      SC9022
     C                   EXSR      SC5383
     C                   EXSR      SC5385
     C***********          Z-ADDMNDPO     C5445
     C***********          Z-ADDMNCPO     C5446
     C                   CLEAR                   C5653
     C                   EXSR      SC6003
     C                   EXSR      SC6145
     C                   MOVE      *BLANK        C9238
     C                   EXSR      SC9340
     C                   EXSR      SC9342
     C                   CLEAR                   C9343
     C                   CLEAR                   C9344
     C                   EXSR      SC9345
     C                   MOVE      *BLANK        C9346
     C                   EXSR      SC9377
     C                   EXSR      SC9811                                                      LUC01
     C                   EXSR      SC9813                                                      LUC01
     C                   EXSR      SC9814                                                      LUC01
     C                   EXSR      SC9833                                                      MUI01
     C                   EXSR      SC9834                                                      MUI01
     C                   EXSR      SC9835                                                      MUI01
     C                   EXSR      SC9836                                                      MUI01
     C                   EXSR      SC9837                                                      MUI01
     C                   EXSR      SC9838                                                      MUI01
     C                   MOVE      DRIC          C9839                                         MUI01
     C                   MOVE      CRIC          C9840                                         MUI01
     C                   MOVE      DRIF          C9841                                         MUI01
     C                   MOVE      CRIF          C9842                                         MUI01
     C                   EXSR      SC9843                                                      MUI01
     C                   EXSR      SC9844                                                      MUI01
     C                   EXSR      SC9845                                                      MUI01
     C                   EXSR      SC9846                                                      MUI01
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
     C                   MOVE      WC9151        C9151
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9177 - Populate the field C9177                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC9177        BEGSR
      *
     C                   MOVEL(P)  'SC9177'      ERRSBR
      *
     C     ATYP          IFEQ      'N'
     C                   MOVE      '1'           C9177
     C                   ELSE
     C                   MOVE      '0'           C9177
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9178 - Populate the field C9178                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC9178        BEGSR
      *
     C                   MOVEL(P)  'SC9178'      ERRSBR
      *
     C                   MOVE      '0'           C9178
      *
     C     ATYP          IFEQ      'R'
      *
     C                   MOVE      CNUM          CNUMX             6
     C                   CLEAR                   SDCUSTD0
     C     CNUMX         CHAIN     SDCUSTV0                           02
      *
     C     *IN02         IFEQ      *ON
     C                   Z-ADD     10            COD
     C                   EXSR      PRINT
     C                   ELSE
     C     BBBNBI        IFEQ      'B'
     C     CNUMX         ANDNE     A8BICN
     C                   MOVE      '1'           C9178
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9157 - Populate the field C9157                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC9157        BEGSR
      *
     C                   MOVEL(P)  'SC9157'      ERRSBR
      *
     C     ATYP          IFEQ      'R'
      *
     C     DRIC          IFNE      0
     C                   MOVE      DRIC          C9157
     C                   ELSE
     C                   MOVE      CRIC          C9157
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANK        C9157
     C                   ENDIF
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
     C     LDBL          IFGT      0
     C     DRIS          ANDNE     0
     C                   MOVE      A5DIAD        C9176
     C                   ENDIF
      *
     C     LDBL          IFLT      0
     C     DRIS          ANDNE     0
     C                   MOVE      A5DIAC        C9176
     C                   ENDIF
      *
     C     LDBL          IFLT      0
     C     CRIS          ANDNE     0
     C                   MOVE      A5CIAC        C9176
     C                   ENDIF
      *
     C     LDBL          IFGT      0
     C     CRIS          ANDNE     0
     C                   MOVE      A5CIAD        C9176
     C                   ENDIF
      *
      * ... get REIAC record
     C                   MOVE      CNUM          KRENUM
     C                   MOVE      CCY           KRECCY
     C                   MOVE      ACOD          KRECOD
     C                   MOVE      ACSQ          KRESQ
     C                   MOVE      BRCA          KREBRC
     C     KREIAC        CHAIN     REIAC                              45
      *
     C     *IN45         IFEQ      *OFF
      *
     C     LDBL          IFGT      0
     C     DRIS          ANDEQ     0
     C     CRIS          ANDEQ     0
     C     DICT          ANDNE     0
     C                   MOVE      A5DIAD        C9176
     C                   ENDIF
      *
     C     LDBL          IFLT      0
     C     DRIS          ANDEQ     0
     C     CRIS          ANDEQ     0
     C     DICT          ANDNE     0
     C                   MOVE      A5DIAC        C9176
     C                   ENDIF
      *
     C     LDBL          IFLT      0
     C     DRIS          ANDEQ     0
     C     CRIS          ANDEQ     0
     C     CICT          ANDNE     0
     C                   MOVE      A5CIAC        C9176
     C                   ENDIF
      *
     C     LDBL          IFGT      0
     C     DRIS          ANDEQ     0
     C     CRIS          ANDEQ     0
     C     CICT          ANDNE     0
     C                   MOVE      A5CIAD        C9176
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC6124 - Populate the field C6124                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC6124        BEGSR
      *
     C                   MOVEL(P)  'SC6124'      ERRSBR
      *
     C     MCAVR         IFLT      0
     C                   Z-ADD     0             C6124
     C                   ELSE
     C                   Z-ADD     MCAVR         C6124
     C                   ENDIF
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
     C                   Z-ADD     CITM          $$AMNT
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
     C     CAIC          ADD       MACI          $$AMNT
     C     $$AMNT        ADD       GACI          $$AMNT
     C     $$AMNT        ADD       CIIE          $$AMNT
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
     C                   Z-ADD     MCPDM         $$AMNT
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
     C                   Z-ADD     LCIA          $$AMNT
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C9103                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC9104 - Populate the field C9104                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC9104        BEGSR
      *
     C                   MOVEL(P)  'SC9104'      ERRSBR
      *                                                                   MUI002
     C                   Z-ADD     *ZERO         WK9837            2 0                         MUI00
     C                   Z-ADD     *ZERO         WK9838            8 5                         MUI00
     C*                                                                   MUI011
     C** If CCIR zero, fill it with Base Rate plus Spread.                MUI011
     C*                                                                   MUI011
     C     CCIR          IFEQ      0                                                           MUI01
     C*                                                                   MUI011
     C     CRIB          IFNE      *ZERO                                                       MUI01
     C                   MOVE      CRIB          @BSRC                                         MUI01
     C                   CALL      'AOBSRTR0'                                                  MUI01
     C                   PARM      '*MSG   '     @RTCD             7                           MUI01
     C                   PARM      '*KEY   '     @OPTN             7                           MUI01
     C                   PARM      CCY           @CYCD             3                           MUI01
     C                   PARM                    @BSRC             2                           MUI01
     C     SDBSRT        PARM      SDBSRT        DSSDY                                         MUI01
     C*                                                                   MUI011
     C     @RTCD         IFEQ      *BLANKS                                                     MUI01
     C                   Z-ADD     BACBSR        CCIR                                          MUI01
     C                   ENDIF                                                                 MUI01
     C                   ENDIF                                                                 MUI01
     C                   ADD       CRIS          CCIR                                          MUI01
     C                   ENDIF                                                                 MUI01
      *
     C**********           Z-ADDCCIR      $$AMNT                          MUI011
     C                   Z-ADD(H)  CCIR          C9104                                         MUI01
      * ... get REIAC record
     C     CCIR          IFEQ      0
     C                   MOVE      CNUM          KRENUM
     C                   MOVE      CCY           KRECCY
     C                   MOVE      ACOD          KRECOD
     C                   MOVE      ACSQ          KRESQ
     C                   MOVE      BRCA          KREBRC
     C     KREIAC        CHAIN     REIAC                              45
      * ... get REINT record
     C     *IN45         IFEQ      *OFF
     C     CICT          ANDNE     0
     C                   MOVE      CICT          DSREK1
     C                   MOVE      CCST          DSREK2
     C                   MOVE      CCY$3         DSREK3
     C                   MOVEL     'D '          DSREK4
     C     DSREIN        CHAIN     REINT                              46
     C     *IN46         IFEQ      *OFF
      *
     C                   Z-ADD     LDBL          WKLDBL
     C     WKLDBL        IFLT      0
     C                   Z-SUB     WKLDBL        WKLDBL
     C                   ENDIF
      * ... Find correct rate relating to ledger balance
     C     2             DO        11            I                 2 0
     C     I             SUB       1             H                 2 0
     C     WKLDBL        IFGT      @BAL(H)
     C     WKLDBL        ANDLE     @BAL(I)
     C**********           Z-ADD@RAT,H    $$AMNT                          MUI011
     C     @RAT(H)       DIV(H)    1000000       C9104                                         MUI01
     C     @RAT(H)       DIV(H)    1000000       WK9838                                        MUI00
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   Z-ADD     BRT           WK9837                                        MUI00
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C**********           EXSR XLM041                                    MUI011
     C**********           MOVE $$CAMT    C9104                           MUI011
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
     C                   Z-ADD     DITM          $$AMNT
      *
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
     C     DAIC          ADD       MADI          $$AMNT
     C     $$AMNT        ADD       GADI          $$AMNT
     C     $$AMNT        ADD       DIIE          $$AMNT
      *
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
     C                   Z-ADD     MDPDM         $$AMNT
      *
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
     C                   Z-ADD     LDIA          $$AMNT
      *
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
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC9118        BEGSR
      *
     C                   MOVEL(P)  'SC9118'      ERRSBR
      *                                                                   MUI002
     C                   Z-ADD     *ZERO         WK9835            2 0                         MUI00
     C                   Z-ADD     *ZERO         WK9836            8 5                         MUI00
     C*                                                                   MUI011
     C** If CDIR zero, fill it with Base Rate plus Spread.                MUI011
     C*                                                                   MUI011
 b1  C     CDIR          IFEQ      0                                                           MUI01
     C*                                                                   MUI011
 b2  C     DRIB          IFNE      *ZERO                                                       MUI01
     C                   MOVE      DRIB          @BSRC                                         MUI01
     C                   CALL      'AOBSRTR0'                                                  MUI01
     C                   PARM      '*MSG   '     @RTCD             7                           MUI01
     C                   PARM      '*KEY   '     @OPTN             7                           MUI01
     C                   PARM      CCY           @CYCD             3                           MUI01
     C                   PARM                    @BSRC             2                           MUI01
     C     SDBSRT        PARM      SDBSRT        DSSDY                                         MUI01
     C*                                                                   MUI011
 b3  C     @RTCD         IFEQ      *BLANKS                                                     MUI01
     C                   Z-ADD     BACBSR        CDIR                                          MUI01
 e3  C                   ENDIF                                                                 MUI01
 e2  C                   ENDIF                                                                 MUI01
     C                   ADD       DRIS          CDIR                                          MUI01
 e1  C                   ENDIF                                                                 MUI01
      *
     C**********           Z-ADDCDIR      $$AMNT                          MUI011
     C**********           Z-ADDCDIR      C9118     H                     MUI011
      *
 b1  C     CDIR          IFLT      0                                                           CM000
     C                   Z-ADD     0             C9118                                         CM000
     C                   ELSE                                                                  CM000
     C                   Z-ADD(H)  CDIR          C9118                                         CM000
 e1  C                   ENDIF                                                                 CM000
      *
      * ... get REIAC record
 b1  C     CDIR          IFEQ      0
     C                   MOVE      CNUM          KRENUM
     C                   MOVE      CCY           KRECCY
     C                   MOVE      ACOD          KRECOD
     C                   MOVE      ACSQ          KRESQ
     C                   MOVE      BRCA          KREBRC
     C     KREIAC        CHAIN     REIAC                              45
      * ... get REINT record
 b2  C     *IN45         IFEQ      *OFF
     C     DICT          ANDNE     0
     C                   MOVE      DICT          DSREK1
     C                   MOVE      DCST          DSREK2
     C                   MOVE      CCY$3         DSREK3
     C                   MOVEL     'D '          DSREK4
     C     DSREIN        CHAIN     REINT                              46
 b3  C     *IN46         IFEQ      *OFF
      *
     C                   Z-ADD     LDBL          WKLDBL
 b4  C     WKLDBL        IFLT      0
     C                   Z-SUB     WKLDBL        WKLDBL
 e4  C                   ENDIF
      * ... Find correct rate relating to ledger balance
     C     2             DO        11            I                 2 0
     C     I             SUB       1             H                 2 0
 b4  C     WKLDBL        IFGT      @BAL(H)
     C     WKLDBL        ANDLE     @BAL(I)
     C**********           Z-ADD@RAT,H    $$AMNT                          MUI011
     C     @RAT(H)       DIV(H)    1000000       C9118                                         MUI01
 b5  C     C9118         IFLT      0
     C                   Z-ADD     0             C9118
 e5  C                   ENDIF
     C     @RAT(H)       DIV(H)    1000000       WK9836                                        MUI00
     C                   LEAVE
e4   C                   ENDIF
     C                   ENDDO
      *
     C                   Z-ADD     BRT           WK9835                                        MUI00
e3   C                   ENDIF
e2   C                   ENDIF
e1   C                   ENDIF
      *
     C**********           EXSR XLM041                                    MUI011
     C**********           MOVE $$CAMT    C9118                           MUI011
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
     C                   Z-ADD     MDCMM         $$AMNT
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
     C                   Z-ADD     MDCGM         $$AMNT
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
     C                   Z-ADD     DACO          $$DAY
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
     C                   CLEAR                   $$DAY
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
     C                   Z-ADD     LMVD          $$DAY
      *
     C     $$DAY         IFLE      MPEQB
     C     $$DAY         ORGT      BJRDNB
     C                   Z-ADD     0             $$DAY
     C                   ENDIF
      *
      *
     C     MDRPO         IFEQ      0
     C     MCRPO         ANDEQ     0
     C                   Z-ADD     0             $$DAY
     C                   ENDIF
      *
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
     C                   CLEAR                   $$DAY
      *
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
     C                   Z-ADD     DACC          $$DAY
      *
     C                   EXSR      XLM053
     C                   MOVE      $$DATE        C0064                                      nt
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
     C                   Z-SUB     LDBL          $$AMNT
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
     C                   Z-ADD     MDALB         $$AMNT
      *
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
     C                   Z-ADD     MCALB         $$AMNT
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
     C                   Z-ADD     MDACB         $$AMNT
      *
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
     C                   Z-ADD     MCACB         $$AMNT
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
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0328                                      nt
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
     C                   Z-ADD     MQMAV         $$AMNT
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0361                                      nt
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
     C                   Z-ADD     MQXAV         $$AMNT
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0362                                      nt
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
     C     LDBL          SUB       CLBL          LDBL
      *
     C     LDBL          IFGT      0                                                           MMI04
     C                   Z-ADD     0             NAVAM            15 0                         MMI04
     C                   ELSE                                                                  MMI04
     C                   Z-SUB     LDBL          NAVAM                                         MMI04
     C                   ENDIF                                                                 MMI04
     C                   Z-ADD     NAVAM         $$AMNT                                        MMI04
     C***********          Z-ADDLDBL      $$AMNT                          MMI043
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
     C                   Z-SUB     CLBL          $$AMNT
      *
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
     C                   CLEAR                   TOTPOS
     C                   CLEAR                   TOTNEG
      *
     C     ATYP          IFEQ      'R'
     C                   CLEAR                   HELDIHBF
     C     KHELD         SETLL     HELDIBV0
     C     KHELD         READE     HELDIBV0                               07
      *
     C     *IN07         DOWEQ     *OFF
     C     HLDA          IFGT      0
     C                   ADD       HLDA          TOTPOS           20 0
     C                   ELSE
     C                   ADD       HLDA          TOTNEG           20 0
     C                   ENDIF
      *
     C     KHELD         READE     HELDIBV0                               07
      *
     C                   ENDDO
     C                   ENDIF
      *
     C***********          Z-ADDTOTPOS    $$AMNT                          168582
     C                   Z-SUB     TOTPOS        $$AMNT                                        16858
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
     C     -1            MULT      TOTNEG        $$AMNT
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
      *
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
     C                   Z-ADD     MQCIM         $$AMNT
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
     C                   Z-ADD     MPQMA         $$AMNT
      *
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
     C                   Z-ADD     MPQXA         $$AMNT
      *
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
     C                   Z-ADD     MAMCQ         $$AMNT
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
     C                   Z-ADD     MUNPD         $$AMNT
      *
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C0470                                      nt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC1501 - Populate the field C1501                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      ***Calls:*XLM041*-*Calling*Routine*GLM041*for*AM*data*type*conv.*                       LUC109
      *  Calls: XLM041 - Calling Routine XX000041 for AM data type    *                       LUC109
      *                  conversion.                                  *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     SC1501        BEGSR
      *
     C                   MOVEL(P)  'SC1501'      ERRSBR
      *
     C                   CLEAR                   $$DAY
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
     C     DACC          IFLT      MMDNB
     C     DACC          ANDGT     MPEMB
     C                   MOVE      '0'           C5064
     C                   ELSE
     C                   MOVE      '1'           C5064
     C                   ENDIF
      *
     C     DACC          IFNE      0
     C                   MOVE      '0'           C5064
     C                   ENDIF
      *
     C                   ENDSR
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
     C                   MOVE      'I'           C6145
      *
     C     ATYP          IFEQ      'R'
      *
     C     DRIB          IFNE      0
     C                   MOVE      'V'           C6145
     C                   ENDIF
      *
     C     DRIB          IFEQ      0
     C     CRIB          ANDNE     0                                                        nt
     C                   MOVE      'V'           C6145
     C                   ENDIF
      *
     C     DRIS          IFNE      0
     C     DRIB          ANDEQ     0                                                        nt
     C                   MOVE      'F'           C6145
     C                   ENDIF
      *
     C     DRIS          IFEQ      0
     C     CRIS          IFNE      0                                                        nt
     C     CRIB          ANDEQ     0                                                        nt
     C                   MOVE      'F'           C6145
     C                   ENDIF
     C                   ENDIF
      *
     C     DRIS          IFEQ      0
     C     CRIS          ANDEQ     0                                                        nt
      * ... get REIAC record
     C                   MOVE      CNUM          KRENUM
     C                   MOVE      CCY           KRECCY
     C                   MOVE      ACOD          KRECOD
     C                   MOVE      ACSQ          KRESQ
     C                   MOVE      BRCA          KREBRC
     C     KREIAC        CHAIN     REIAC                              45
      * ... get REINT record
     C     *IN45         IFEQ      *OFF
      *
     C     DICT          IFNE      0
     C                   MOVE      DICT          DSREK1
     C                   MOVE      DCST          DSREK2
     C                   MOVE      CCY$3         DSREK3
     C                   MOVEL     'D '          DSREK4
     C     DSREIN        CHAIN     REINT                              46
     C     *IN46         IFEQ      *OFF
     C     BRT           IFNE      0
     C                   MOVE      'V'           C6145
     C                   ELSE
     C                   MOVE      'F'           C6145
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C     CICT          IFNE      0
     C                   MOVE      CICT          DSREK1
     C                   MOVE      CCST          DSREK2
     C                   MOVE      CCY$3         DSREK3
     C                   MOVEL     'D '          DSREK4
     C     DSREIN        CHAIN     REINT                              46
     C     *IN46         IFEQ      *OFF
     C     BRT           IFNE      0
     C                   MOVE      'V'           C6145
     C                   ELSE
     C                   MOVE      'F'           C6145
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
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
     C                   Z-ADD     DTAP          $$DAY
     C                   EXSR      XLM053
     C                   MOVE      $$DATE        C9021                                      nt
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
     C                   Z-ADD     DTEX          $$DAY
     C                   EXSR      XLM053
     C                   MOVE      $$DATE        C9022                                      nt
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
     C                   Z-ADD     MDRPO         $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C5383                                      nt
      *
     C     MDRPO         IFEQ      0
     C                   Z-ADD     0             C5445
     C                   ELSE
     C                   Z-ADD     MNDPO         C5445
     C                   ENDIF
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
     C                   Z-ADD     MCRPO         $$AMNT
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C5385                                      nt
      *
     C     MCRPO         IFEQ      0
     C                   Z-ADD     0             C5446
     C                   ELSE
     C                   Z-ADD     MNCPO         C5446
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SC6003 - Populate the field C6003                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SC6003        BEGSR
      *
     C                   MOVEL(P)  'SC6003'      ERRSBR
      *
     C     A5WTAC        IFNE      *BLANK
     C                   MOVE      '0'           C6003
     C                   ELSE
     C                   MOVE      '1'           C6003
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
     C                   CLEAR                   $$DAY
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
     C     LDBL          IFGT      *ZERO                                        IF    01
     C                   MOVE      'D'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     LDBL          IFLT      *ZERO                                        IF    01
     C                   MOVE      'C'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     LDBL          IFEQ      *ZERO                                        IF    01
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
     C                   Z-ADD     9             COD
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
     C     LDBL          IFGT      *ZERO                                        IF    01
     C                   MOVE      '0'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     LDBL          IFLT      *ZERO                                        IF    01
     C                   MOVE      '1'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     LDBL          IFEQ      *ZERO                                        IF    01
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      '0'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    03
     C                   MOVE      '1'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 03
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
     C                   Z-ADD     9             COD
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
      *  SC9813 - Populate the field C9813                            *   LUC010
      *                                                               *   LUC010
      *  Called By: MOVFLD                                            *   LUC010
      *                                                               *   LUC010
      *****************************************************************   LUC010
      *                                                                   LUC010
     C     SC9813        BEGSR                                                                 LUC01
      *                                                                   LUC010
     C                   MOVEL(P)  'SC9813'      ERRSBR                                        LUC01
      *                                                                   LUC010
     C     ATYP          IFEQ      'R'                                                         LUC01
     C                   Z-ADD     ODLN          C9813                                         LUC01
     C                   ENDIF                                                                 LUC01
      *                                                                   LUC010
     C                   ENDSR                                                                 LUC01
      *                                                                   LUC010
      *****************************************************************   LUC010
      *                                                               *   LUC010
      *  SC9814 - Populate the field C9814                            *   LUC010
      *                                                               *   LUC010
      *  Called By: MOVFLD                                            *   LUC010
      *                                                               *   LUC010
      *****************************************************************   LUC010
      *                                                                   LUC010
     C     SC9814        BEGSR                                                                 LUC01
      *                                                                   LUC010
     C                   MOVEL(P)  'SC9814'      ERRSBR                                        LUC01
      *                                                                   LUC010
     C     ATYP          IFEQ      'R'                                                         LUC01
     C                   Z-ADD     ODED          $$DAY                                         LUC01
     C                   EXSR      XLM053                                                      LUC01
     C                   MOVE      $$DATE        C9814                                         LUC01
     C                   ENDIF                                                                 LUC01
      *                                                                   LUC010
     C                   ENDSR                                                                 LUC01
      *                                                                   LUC010
      *****************************************************************   MUI011
      *                                                               *   MUI011
      *  SC9833 - Populate the field C9833                            *   MUI011
      *                                                               *   MUI011
      *  Called By: MOVFLD                                            *   MUI011
      *                                                               *   MUI011
      *****************************************************************   MUI011
      *                                                                   MUI011
     C     SC9833        BEGSR                                                                 MUI01
      *                                                                   MUI011
     C                   MOVEL(P)  'SC9833'      ERRSBR                                        MUI01
      *                                                                   MUI011
      * Not interest bearing                                              MUI011
      *                                                                   MUI011
     C                   MOVE      'I'           C9833                                         MUI01
      *                                                                   MUI011
      * Fixed interest                                                    MUI011
      *                                                                   MUI011
     C     DRIB          IFEQ      *ZERO                                                       MUI01
     C     DRIS          ANDNE     *ZERO                                                       MUI01
     C     WK9835        OREQ      *ZERO                                                       MUI01
     C     WK9836        ANDNE     *ZERO                                                       MUI01
     C                   MOVE      'F'           C9833                                         MUI01
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
      * Variable interest                                                 MUI011
      *                                                                   MUI011
     C     DRIB          IFNE      *ZERO                                                       MUI01
     C     WK9835        ORNE      *ZERO                                                       MUI01
     C                   MOVE      'V'           C9833                                         MUI01
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
     C                   ENDSR                                                                 MUI01
      *                                                                   MUI011
      *****************************************************************   MUI011
      *                                                               *   MUI011
      *  SC9834 - Populate the field C9834                           *    MUI011
      *                                                               *   MUI011
      *  Called By: MOVFLD                                            *   MUI011
      *                                                               *   MUI011
      *****************************************************************   MUI011
      *                                                                   MUI011
     C     SC9834        BEGSR                                                                 MUI01
      *                                                                   MUI011
     C                   MOVEL(P)  'SC9834'      ERRSBR                                        MUI01
      *                                                                   MUI011
      * Not interest bearing                                              MUI011
      *                                                                   MUI011
     C                   MOVE      'I'           C9834                                         MUI01
      *                                                                   MUI011
      * Fixed interest                                                    MUI011
      *                                                                   MUI011
     C     CRIB          IFEQ      *ZERO                                                       MUI01
     C     CRIS          ANDNE     *ZERO                                                       MUI01
     C     WK9837        OREQ      *ZERO                                                       MUI01
     C     WK9838        ANDNE     *ZERO                                                       MUI01
     C                   MOVE      'F'           C9834                                         MUI01
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
      * Variable interest                                                 MUI011
      *                                                                   MUI011
     C     CRIB          IFNE      *ZERO                                                       MUI01
     C     WK9837        ORNE      *ZERO                                                       MUI01
     C                   MOVE      'V'           C9834                                         MUI01
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
     C                   ENDSR                                                                 MUI01
      *                                                                   MUI011
      *****************************************************************   MUI011
      *                                                               *   MUI011
      *  SC9835 - Populate the field C9835                            *   MUI011
      *                                                               *   MUI011
      *  Called By: MOVFLD                                            *   MUI011
      *                                                               *   MUI011
      *****************************************************************   MUI011
      *                                                                   MUI011
     C     SC9835        BEGSR                                                                 MUI01
      *                                                                   MUI011
     C                   MOVEL(P)  'SC9835'      ERRSBR                                        MUI01
      *                                                                   MUI011
     C     DRIB          IFNE      0                                                           MUI01
     C                   Z-ADD     DRIB          WK9835                                        MUI01
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
     C                   MOVE      WK9835        C9835                                         MUI01
      *                                                                   MUI011
     C                   ENDSR                                                                 MUI01
      *                                                                   MUI011
      *****************************************************************   MUI011
      *                                                               *   MUI011
      *  SC9836 - Populate the field C9836                            *   MUI011
      *                                                               *   MUI011
      *  Called By: MOVFLD                                            *   MUI011
      *                                                               *   MUI011
      *****************************************************************   MUI011
      *                                                                   MUI011
     C     SC9836        BEGSR                                                                 MUI01
      *                                                                   MUI011
     C                   MOVEL(P)  'SC9836'      ERRSBR                                        MUI01
      *                                                                   MUI011
     C     DRIS          IFNE      0                                                           MUI01
     C                   Z-ADD(H)  DRIS          WK9836                                        MUI01
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
     C                   MOVEL     '+'           C9836                                         MUI01
     C     WK9836        IFLT      *ZERO                                                       MUI01
     C                   MOVEL     '-'           C9836                                         MUI01
     C                   MULT      -1            WK9836                                        MUI01
     C                   ENDIF                                                                 MUI01
     C                   MOVE      WK9836        C9836                                         MUI01
      *                                                                   MUI011
     C                   ENDSR                                                                 MUI01
      *                                                                   MUI011
      *****************************************************************   MUI011
      *                                                               *   MUI011
      *  SC9837 - Populate the field C9837                            *   MUI011
      *                                                               *   MUI011
      *  Called By: MOVFLD                                            *   MUI011
      *                                                               *   MUI011
      *****************************************************************   MUI011
      *                                                                   MUI011
     C     SC9837        BEGSR                                                                 MUI01
      *                                                                   MUI011
     C                   MOVEL(P)  'SC9837'      ERRSBR                                        MUI01
      *                                                                   MUI011
     C     CRIB          IFNE      0                                                           MUI01
     C                   Z-ADD     CRIB          WK9837                                        MUI01
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
     C                   MOVE      WK9837        C9837                                         MUI01
      *                                                                   MUI011
     C                   ENDSR                                                                 MUI01
      *                                                                   MUI011
      *****************************************************************   MUI011
      *                                                               *   MUI011
      *  SC9838 - Populate the field C9838                            *   MUI011
      *                                                               *   MUI011
      *  Called By: MOVFLD                                            *   MUI011
      *                                                               *   MUI011
      *****************************************************************   MUI011
      *                                                                   MUI011
     C     SC9838        BEGSR                                                                 MUI01
      *                                                                   MUI011
     C                   MOVEL(P)  'SC9838'      ERRSBR                                        MUI01
      *                                                                   MUI011
     C     CRIS          IFNE      0                                                           MUI01
     C                   Z-ADD(H)  CRIS          WK9838                                        MUI01
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
     C                   MOVEL     '+'           C9838                                         MUI01
     C     WK9838        IFLT      *ZERO                                                       MUI01
     C                   MOVEL     '-'           C9838                                         MUI01
     C                   MULT      -1            WK9838                                        MUI01
     C                   ENDIF                                                                 MUI01
     C                   MOVE      WK9838        C9838                                         MUI01
      *                                                                   MUI011
     C                   ENDSR                                                                 MUI01
      *                                                                   MUI011
      *****************************************************************   MUI011
      *                                                               *   MUI011
      *  SC9843 - Populate the field C9843                            *   MUI011
      *                                                               *   MUI011
      *  Called By: MOVFLD                                            *   MUI011
      *  Calls:                                                       *   MUI011
      *                                                               *   MUI011
      *****************************************************************   MUI011
      *                                                                   MUI011
     C     SC9843        BEGSR                                                                 MUI01
      *                                                                   MUI011
     C                   MOVEL(P)  'SC9843'      ERRSBR                                        MUI01
      *                                                                   MUI011
     C                   Z-ADD     NDID          $$DAY                                         MUI01
     C                   EXSR      XLM053                                                      MUI01
     C                   MOVE      $$DATE        C9843                                         MUI01
      *                                                                   MUI011
     C                   ENDSR                                                                 MUI01
      *                                                                   MUI011
      *****************************************************************   MUI011
      *                                                               *   MUI011
      *  SC9844 - Populate the field C9844                            *   MUI011
      *                                                               *   MUI011
      *  Called By: MOVFLD                                            *   MUI011
      *  Calls:                                                       *   MUI011
      *                                                               *   MUI011
      *****************************************************************   MUI011
      *                                                                   MUI011
     C     SC9844        BEGSR                                                                 MUI01
      *                                                                   MUI011
     C                   MOVEL(P)  'SC9844'      ERRSBR                                        MUI01
      *                                                                   MUI011
     C                   Z-ADD     NCID          $$DAY                                         MUI01
     C                   EXSR      XLM053                                                      MUI01
     C                   MOVE      $$DATE        C9844                                         MUI01
      *                                                                   MUI011
     C                   ENDSR                                                                 MUI01
      *                                                                   MUI011
      *****************************************************************   MUI011
      *                                                               *   MUI011
      *  SC9845 - Populate the field C9845                            *   MUI011
      *                                                               *   MUI011
      *  Called By: MOVFLD                                            *   MUI011
      *  Calls:                                                       *   MUI011
      *                                                               *   MUI011
      *****************************************************************   MUI011
      *                                                                   MUI011
     C     SC9845        BEGSR                                                                 MUI01
      *                                                                   MUI011
     C                   MOVEL(P)  'SC9845'      ERRSBR                                        MUI01
      *                                                                   MUI011
     C                   Z-ADD     LDID          $$DAY                                         MUI01
     C                   EXSR      XLM053                                                      MUI01
     C                   MOVE      $$DATE        C9845                                         MUI01
      *                                                                   MUI011
     C                   ENDSR                                                                 MUI01
      *                                                                   MUI011
      *****************************************************************   MUI011
      *                                                               *   MUI011
      *  SC9846 - Populate the field C9846                            *   MUI011
      *                                                               *   MUI011
      *  Called By: MOVFLD                                            *   MUI011
      *  Calls:                                                       *   MUI011
      *                                                               *   MUI011
      *****************************************************************   MUI011
      *                                                                   MUI011
     C     SC9846        BEGSR                                                                 MUI01
      *                                                                   MUI011
     C                   MOVEL(P)  'SC9846'      ERRSBR                                        MUI01
      *                                                                   MUI011
     C                   Z-ADD     LCID          $$DAY                                         MUI01
     C                   EXSR      XLM053                                                      MUI01
     C                   MOVE      $$DATE        C9846                                         MUI01
      *                                                                   MUI011
     C                   ENDSR                                                                 MUI01
      *                                                                   MUI011
      *****************************************************************   167338
      *                                                               *   167338
      *  CHKREC - Check if the input record must be processed         *   167338
      *                                                               *   167338
      *  Called By: Main                                              *   167338
      *  Calls:                                                       *   167338
      *                                                               *   167338
      *****************************************************************   167338
      *                                                                   167338
     C     CHKREC        BEGSR                                                                 16733
      *                                                                   167338
     C                   MOVEL(P)  'CHKREC'      ERRSBR                                        16733
      *                                                                   167338
     C                   MOVE      *ON           *IN22                                         16733
      *                                                                   167338
      * Do not process accounts that closed before the month begin        |67999
     C     DACC          IFGT      MPEMB                                                       16733
     C     DACC          OREQ      0                                                           16733
     C                   MOVE      *OFF          *IN22                                         16733
     C                   ENDIF                                                                 16733
      *                                                                   167338
      *                                                                   167338
     C                   ENDSR                                                                 16733
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
      *
     C                   SELECT
     C     COD           WHENEQ    1
     C                   MOVE      CNUM          NUMX
     C                   MOVE      CCY           CCYX
     C                   MOVE      ACOD          ACODX
     C                   MOVE      ACSQ          ACSQX
     C                   MOVE      BRCA          BRCAX
     C                   MOVEL     KTBY          ERRD01
     C     COD           WHENEQ    2
     C                   MOVEL     BRCA          ERRD01
     C     COD           WHENEQ    3
     C                   MOVEL     ACOD          ERRD01
     C     COD           WHENEQ    4
     C                   MOVEL     $$CCYC        ERRD02
     C                   MOVEL     $$AMNT        ERRD03
     C     COD           WHENEQ    5
     C                   MOVEL     CNUM          ERRD01
     C                   MOVEL     FACT          ERRD02
     C                   MOVEL     FCNO          ERRD03
     C     COD           WHENEQ    6
     C                   MOVEL     G6RSCD        ERRD02
     C     COD           WHENEQ    7
     C     COD           WHENEQ    8
     C     COD           WHENEQ    9
     C     K1RSNO        CAT       K1ACCD:0      ERRD01
     C     ERRD01        CAT       K1DRCR:0      ERRD01
     C     COD           WHENEQ    10
     C                   MOVEL     CNUM          ERRD01
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
     C     *LIKE         DEFINE    CNUM          KRENUM
     C     *LIKE         DEFINE    CCY           KRECCY
     C     *LIKE         DEFINE    ACOD          KRECOD
     C     *LIKE         DEFINE    ACSQ          KRESQ
     C     *LIKE         DEFINE    BRCA          KREBRC
     C     *LIKE         DEFINE    LDBL          WKLDBL
      *
     C     KFCLTY        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    FACT
     C                   KFLD                    FCNO
      *
     C     KHELD         KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
      *
     C     KACTBY        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
      *
     C     K1ACRC        KLIST
     C                   KFLD                    K1RSNO
     C                   KFLD                    K1ACCD
     C                   KFLD                    K1DRCR
      *
     C     KREIAC        KLIST
     C                   KFLD                    KRENUM
     C                   KFLD                    KRECCY
     C                   KFLD                    KRECOD
     C                   KFLD                    KRESQ
     C                   KFLD                    KREBRC
      *                                                                                    LUC109CC1
     C                   CALL      'AOSVALR0'                                              LUC109CC1
     C                   PARM                    @RTCD                                     LUC109CC1
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
      *
     C*          *IN90     IFEQ *ON
     C*          *IN90     ANDEQ*OFF
     C*                    UPDATSDBRCHD0               90
     C*                    UPDATSDACRCD0               90
     C*                    UPDATACCNBFX0               90
     C*                    UPDATFCLTYFNF               90
     C*                    UPDATSDCUSTD0               90
     C*                    UPDATSDACODD0               90
     C*                    UPDATHELDIHBF               90
     C*                    ENDIF
      *
     C                   ENDSR
**
ACCNTBY1 RECORD NOT FOUND
SDBRCHV0 RECORD NOT FOUND
SDACODV0 RECORD NOT FOUND
ERROR FOUND CALLING XX000041
FCLTYMV0 RECORD NOT FOUND
G6RSCD NOT NUMERIC
SDBANKPD FILE IS EMPTY
SDGELRV0 FILE IS EMPTY
SDACRCV0 RECORD NOT FOUND
SDCUSTV0 RECORD NOT FOUND
