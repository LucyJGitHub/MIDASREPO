     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('FECCD Negotiable Assets Purchased Dealing Extract')    *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      *  GLM026  - FECCD Negotiable Assets Purchased Dealing Extract  *
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
      *  Prev Amend No. CM00036425         Date 10Feb14               *
      *                 MUI011             Date 19May04               *
      *                 197893             Date 01Oct01               *
      *                 LUC010             Date 22Aug01               *
      *                 167330             Date 23Jun99               *
      *                 MMI043             Date 23Jun99               *
      *                 MMI043             Date 02Jun99               *
      *                 MMI043             Date 04May99               *
      *                 MMI043             Date 27Apr99               *
      *  Create         MMI043             Date 17Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  CM00036425 - Add Murex Transaction Id to output record 18    *
      *  MUI011 - ALMS - Add detail records 17 and 18.                *
      *  197893 - Field C9115 contains wrong data. The field should   *
      *           report the total interest accrued up to the         *
      *           reporting day less any interest already paid.       *
      *  LUC010 - Changes to Head Office Extracts                     *
      *  167330 - Report face instead of discount amount              *
      *  MMI043 - Balance Sheet Extract                               *
      *                                                               *
      *****************************************************************
      *
     FDEALSDV0  IF   E           K DISK
      *
     FDEALSDY0  UF   E           K DISK
     FSDBRCHV0  UF   E           K DISK
     FSDACRCV0  UF   E           K DISK
     FACKEYV0   UF   E           K DISK
      *
     FSDBANKPD  IF   E           K DISK    USROPN
     FSDGELRV0  IF   E           K DISK    USROPN
     FSDDEALL0  IF   E           K DISK    USROPN
     F***GZNASPL1  IF   E           K DISK                                                    LUC109
      *
     FFECCDDPP  O    E             DISK
     F***GLM026AU  O    E             PRINTER OFLIND(*IN20)                                   LUC109
     FXX000026AUO    E             PRINTER OFLIND(*IN20)                                      LUC109
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01 - LF/DEALSDV0   File I                                   *
      *   03 - LF/DEALSDY0   File I                                   *
      *   03 - LF/SDBRCHV0   File I                                   *
      *   03 - LF/SDACRCV0   File I                                   *
      *   03 - LF/ACKEYV0    File I                                   *
      *                                                               *
      *   LR - LF/SDBANKPD   File I                                   *
      *   LR - LF/SDGELRPP   File I                                   *
      *   LR - LF/SDDEALL0   File I                                   *
      *                                                               *
      ****20*-*PRTF/GLM026AU*File*O*Overflow*indicator*****************                       LUC109
      *   20 - PRTF/XX000026AU File O Overflow indicator              *                       LUC109
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  MAIN   - Main Processing                                     *
      *  CHKREC - Check if the input record must be processed         *
      *  DEALY0 - Chain DEALSDY0 extension file                       *
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
      *  SC9339 - Populate the field C9339                            *
      *  SC1501 - Populate the field C1501                            *
      *  SC5064 - Populate the field C5064                            *
      *  SC9021 - Populate the field C9021                            *
      *  SC9022 - Populate the field C9022                            *
      *  SC5383 - Populate the field C5383                            *
      *  SC5385 - Populate the field C5385                            *
      *  SC6145 - Populate the field C6145                            *
      *  SC9238 - Populate the field C9238                            *
      *  SC9340 - Populate the field C9340                            *
      *  SC9342 - Populate the field C9342                            *
      *  SC9343 - Populate the field C9343                            *
      *  SC9344 - Populate the field C9344                            *
      *  SC9345 - Populate the field C9345                            *
      *  SC9377 - Populate the field C9377                            *
      *  SC9811 - Populate the field C9811                            *   LUC010
      *  SCMXTN - Populate the field CMXTN                            *   CM00036425
      *                                                               *
      *  XLM053 - Calling Routine GLM053 for date conversion          *
      *  XLM041 - Calling Routine GLM041 for AM data type conversion  *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
      *
     D MSG             S             30    DIM(10) CTDATA PERRCD(1)
      *--------------------------------------------------------------------*
      *
     D WC9151          DS
     D  BRCA                   1      3
     D*                                       4   90CNUM
     D  ISCN                   4      9  0
     D  CCY                   10     12
     D  W9151                 13     16  0
     D  IDAS                  17     18  0
      *
     D K1ACKE          DS
     D  DTYP                   1      2
     D  K1C1                   3      3
     D  DLST                   4      5
     D  K1C2                   6      8
     D  K1C3                   9      9
     D  K1C4                  10     10
      *--------------------------------------------------------------------*
      *
     IACKEYALF
     I              RECI                        RECI$$
      *
      *****************************************************************
      *                                                               *
      *  MAIN   - Main processing                                     *
      *                                                               *
      *  Called By:                                                   *
      *  Calls: CHKREC - Check if the input record must be processed  *
      *         DEALY0 - Chain DEALSDY0 extension file                *
      *         MOVFLD - Populate all the fields of the output file   *
      *                                                               *
      *****************************************************************
      *
     C     *LOVAL        SETLL     DEALSDV0
     C                   READ      DEALSDV0                               01
      *
     C     *IN01         DOWEQ     *OFF
      *
     C                   EXSR      CHKREC
      *
     C     *IN02         IFEQ      *OFF
     C                   EXSR      DEALY0
     C                   EXSR      MOVFLD
      *
     C****       ERRMSG    IFEQ *BLANK
     C                   WRITE     FECCDDP0
     C****                 ENDIF
      *
     C                   CLEAR                   FECCDDP0
     C                   CLEAR                   ERRMSG
      *
     C                   ENDIF
      *
     C                   READ      DEALSDV0                               01
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
      *  DEALY0 - Chain DEALSDY0 extension file                       *
      *                                                               *
      *  Called By: Main processing                                   *
      *  Calls:     PRINT  - Report error                             *
      *                                                               *
      *****************************************************************
      *
     C     DEALY0        BEGSR
      *
     C                   MOVEL(P)  'DEALY0'      ERRSBR
      *
     C                   CLEAR                   DEALDFX0
     C     DLNO          CHAIN(N)  DEALSDY0                           03
      *
     C     *IN03         IFEQ      *ON
     C                   Z-ADD     1             COD
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
      *             SC9339 - Populate the field C9339                 *
      *             SC1501 - Populate the field C1501                 *
      *             SC5064 - Populate the field C5064                 *
      *             SC9021 - Populate the field C9021                 *
      *             SC9022 - Populate the field C9022                 *
      *             SC5383 - Populate the field C5383                 *
      *             SC5385 - Populate the field C5385                 *
      *             SC6145 - Populate the field C6145                 *
      *             SC9238 - Populate the field C9238                 *
      *             SC9340 - Populate the field C9340                 *
      *             SC9342 - Populate the field C9342                 *
      *             SC9343 - Populate the field C9343                 *
      *             SC9344 - Populate the field C9344                 *
      *             SC9345 - Populate the field C9345                 *
      *             SC9377 - Populate the field C9377                 *
      *             SC9811 - Populate the field C9811                 *   LUC010
      *             SCMXTN - Populate the field CMXTN                 *   CM00036425
      *                                                               *
      *****************************************************************
      *
     C     MOVFLD        BEGSR
      *
     C                   MOVEL(P)  'MOVFLD'      ERRSBR
      *
      *                                                                   167330
      ** Use face value amount instead of discount amount                 167330
     C                   Z-ADD     PUPR          WPUPR            13 0                         16733
     C                   Z-ADD     FVAL          PUPR                                          16733
     C                   EXSR      SC9003
     C*                    Z-ADDCNUM      C5125
     C                   Z-ADD     ISCN          C5125
     C                   EXSR      SC9172
     C                   MOVE      BRCA          C0120
     C                   MOVE      CCY           C0150
     C                   MOVEL     'NA'          C9149
     C                   MOVEL     DLNO          C9150
     C                   MOVE      '0'           C9177
     C                   MOVE      '0'           C9178
     C                   EXSR      SC9152
     C                   EXSR      SC9153
     C                   EXSR      SC9151
     C                   EXSR      SC9154
     C                   MOVE      ICBS          C9157
     C                   EXSR      SC9173
     C                   MOVE      DTYP          C9174
     C                   MOVE      DLST          C9175
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
     C                   Z-ADD     INTR          C9118
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
     C                   EXSR      SC5334
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
     C                   MOVE      '0'           C0584
     C                   MOVE      '0'           C0611
     C                   EXSR      SC9339
     C                   MOVE      '0'           C0814
     C                   EXSR      SC1501
     C                   EXSR      SC5064
     C                   CLEAR                   C9019
     C                   CLEAR                   C9020
     C                   EXSR      SC9021
     C                   EXSR      SC9022
     C                   EXSR      SC5383
     C                   EXSR      SC5385
     C                   CLEAR                   C5653
     C                   MOVE      '1'           C6003
     C                   EXSR      SC6145
     C                   EXSR      SC9238
      *                                                                   167330
      ** Put back discount amount                                         167330
     C                   Z-ADD     WPUPR         PUPR                                          16733
     C                   EXSR      SC9340
     C                   EXSR      SC9342
     C                   EXSR      SC9343
     C                   EXSR      SC9344
     C                   EXSR      SC9345
     C                   CLEAR                   C9346
     C                   EXSR      SC9377
     C                   EXSR      SC9811                                                      LUC01
     C                   MOVE      BOKC          C9830                                         MUI01
     C                   Z-ADD     *ZERO         C9831                                         MUI01
     C                   MOVE      IPFR          C9848                                         MUI01
     C                   MOVE      *BLANKS       C9850                                         MUI01
     C                   EXSR      SC9851                                                      MUI01
     C                   EXSR      SCMXTN                                                      CM000
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
     C     DISA          IFNE      *ZEROS
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
     C                   MOVE      'M'           K1C1
     C                   CLEAR                   K1C2
     C                   CLEAR                   K1C3
     C                   MOVE      *ALL'§'       K1C4
      *
     C     DTYP          IFEQ      'C1'                                         IF 01
     C     DTYP          OREQ      'C2'
     C     DTYP          OREQ      'BD'
     C     DTYP          OREQ      'BP'
     C     BNNAIA        IFNE      'Y'                                          IF 02
     C                   MOVE      'A'           K1C4
     C                   ELSE                                                   ELSE 02
     C                   MOVE      'F'           K1C4
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     DTYP          IFEQ      'TB'                                         IF 01
     C     DTYP          OREQ      'TA'
     C     DTYP          OREQ      'DA'
     C     BNNAIA        IFNE      'Y'                                          IF 02
     C                   MOVE      'A'           K1C4
     C                   ELSE                                                   ELSE 02
     C                   MOVE      'F'           K1C4
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
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
     C                   MOVE      *ALL'§'       K1C4
      *
     C     DTYP          IFEQ      'C1'                                         IF 01
     C     DTYP          OREQ      'C2'
     C     DTYP          OREQ      'BD'
     C     DTYP          OREQ      'BP'
     C     BNNAIA        IFNE      'Y'                                          IF 02
     C                   MOVE      'A'           K1C4
     C                   ELSE                                                   ELSE 02
     C                   MOVE      'F'           K1C4
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     DTYP          IFEQ      'TB'                                         IF 01
     C     DTYP          OREQ      'TA'
     C     DTYP          OREQ      'DA'
     C     BNNAIA        IFNE      'Y'                                          IF 02
     C                   MOVE      'A'           K1C4
     C                   ELSE                                                   ELSE 02
     C                   MOVE      'F'           K1C4
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
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
     C                   MOVE      *ALL'§'       K1C4
      *
     C     DTYP          IFEQ      'C1'                                         IF 01
     C     DTYP          OREQ      'C2'
     C     DTYP          OREQ      'BD'
     C     DTYP          OREQ      'BP'
     C     BNNAIA        IFNE      'Y'                                          IF 02
     C                   MOVE      'A'           K1C4
     C                   ELSE                                                   ELSE 02
     C                   MOVE      'F'           K1C4
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     DTYP          IFEQ      'TB'                                         IF 01
     C     DTYP          OREQ      'TA'
     C     DTYP          OREQ      'DA'
     C     BNNAIA        IFNE      'Y'                                          IF 02
     C                   MOVE      'A'           K1C4
     C                   ELSE                                                   ELSE 02
     C                   MOVE      'F'           K1C4
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
      *                                                               *
      *****************************************************************
      *
     C     SC9173        BEGSR
      *
     C                   MOVEL(P)  'SC9173'      ERRSBR
      *
     C     DTYP          IFEQ      'C1'                                         IF 01
     C     DTYP          OREQ      'C2'
     C     DTYP          OREQ      'BD'
     C     DTYP          OREQ      'BP'
     C***********BNNAIA    IFNE 'Y'                        IF 02
     C***********          Z-ADDPUPR      $$AMNT
     C***********          ELSE                            ELSE 02
     C                   Z-ADD     FVAL          $$AMNT
     C***********          ENDIF                           ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     DTYP          IFEQ      'TB'                                         IF 01
     C     DTYP          OREQ      'TA'
     C     DTYP          OREQ      'DA'
     C                   Z-ADD     PUPR          $$AMNT
     C                   ENDIF                                                  ENDIF 01
      *
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
     C     DTYP          IFEQ      'C1'                                         IF 01
     C     DTYP          OREQ      'C2'
     C     DTYP          OREQ      'BD'
     C     DTYP          OREQ      'BP'
     C     BNNAIA        IFNE      'Y'                                          IF 02
     C                   MOVE      'A'           K1C4
     C                   ELSE                                                   ELSE 02
     C                   MOVE      'I'           K1C4
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     DTYP          IFEQ      'TB'                                         IF 01
     C     DTYP          OREQ      'TA'
     C     DTYP          OREQ      'DA'
     C                   MOVE      'D'           K1C4
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
      *                                                               *
      *****************************************************************
      *
     C     SC9114        BEGSR
      *
     C                   MOVEL(P)  'SC9114'      ERRSBR
      *
     C                   Z-ADD     MCACM         $$AMNT
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
      *                                                               *
      *****************************************************************
      *
     C     SC9115        BEGSR
      *
     C                   MOVEL(P)  'SC9115'      ERRSBR
      *
     C***********AITC      ADD  AIPD      WRKAMT 150                      197893
     C***********WRKAMT    ADD  AIAN      $$AMNT                          197893
     C     AIPD          SUB       IPRD          WRKAMT           15 0                         19789
     C                   Z-ADD     WRKAMT        $$AMNT                                        19789
     C                   Z-ADD     0             WRKAMT
      *                                                                   197893
     C     RECI          IFEQ      'M'                                                         19789
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  SC9113 - Populate the field C9113                            *
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
     C                   Z-ADD     MDAT          $$DAY
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
     C     MDAT          IFGT      BJRDNB
     C                   Z-ADD     VDAT          $$DAY
     C                   ELSE
     C                   Z-ADD     MDAT          $$DAY
     C                   ENDIF
      *
     C     $$DAY         IFLE      MPEQB
     C     $$DAY         ORGT      BJRDNB
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
     C     RECI          OREQ      'N'
     C     MDAT          ANDLE     BJRDNB
     C                   Z-ADD     MDAT          $$DAY
     C                   ELSE
     C                   CLEAR                   $$DAY                                      nt
     C                   ENDIF
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
      *                                                               *
      *****************************************************************
      *
     C     SC0301        BEGSR
      *
     C                   MOVEL(P)  'SC0301'      ERRSBR
      *
     C***********RECI      IFEQ 'M'                        IF 01
     C***********RECI      OREQ 'N'
     C***********          CLEAR$$AMNT                                 nt
      *
     C***********          ELSE
     C     RECI          IFEQ      'M'                                          IF 01
     C     RECI          OREQ      'N'
     C                   CLEAR                   $$AMNT                                     nt
      *
     C                   ELSE
      *
     C     DTYP          IFEQ      'C1'                                         IF 02
     C     DTYP          OREQ      'C2'
     C     DTYP          OREQ      'BD'
     C     DTYP          OREQ      'BP'
     C     BNNAIA        IFNE      'Y'                                          IF 03
     C                   Z-SUB     PUPR          $$AMNT
     C                   ELSE                                                   ELSE 03
     C                   Z-SUB     FVAL          $$AMNT
     C                   ENDIF                                                  ENDIF 03
     C                   ENDIF                                                  ENDIF 02
      *
     C     DTYP          IFEQ      'TB'                                         IF 02
     C     DTYP          OREQ      'TA'
     C     DTYP          OREQ      'DA'
     C                   Z-SUB     PUPR          $$AMNT
     C                   ENDIF                                                  ENDIF 02
      *
     C***********          ENDIF                           ENDIF 01
      *
     C                   ENDIF                                                  ENDIF 01
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  SC.
      *                                                               *
      *  Called By: MOVFLD                                            *
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
      *                                                               *
      *****************************************************************
      *
     C     SC0328        BEGSR
      *
     C                   MOVEL(P)  'SC0328'      ERRSBR
      *
     C     DTYP          IFEQ      'C1'                                         IF 01
     C     DTYP          OREQ      'C2'
     C     DTYP          OREQ      'BD'
     C     DTYP          OREQ      'BP'
     C     BNNAIA        IFNE      'Y'                                          IF 02
     C                   Z-SUB     PUPR          $$AMNT
     C                   ELSE                                                   ELSE 02
     C                   Z-SUB     FVAL          $$AMNT
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     DTYP          IFEQ      'TB'                                         IF 01
     C     DTYP          OREQ      'TA'
     C     DTYP          OREQ      'DA'
     C                   Z-SUB     PUPR          $$AMNT
     C                   ENDIF                                                  ENDIF 01
      *
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
      *                                                               *
      *****************************************************************
      *
     C     SC0361        BEGSR
      *
     C                   MOVEL(P)  'SC0361'      ERRSBR
      *
     C     RECI          IFEQ      'M'                                                    MMI043
     C     RECI          OREQ      'N'                                                    MMI043
     C                   Z-ADD     0             $$AMNT                                   MMI043
     C                   ELSE                                                             MMI043
     C     DTYP          IFEQ      'C1'                                         IF 01
     C     DTYP          OREQ      'C2'
     C     DTYP          OREQ      'BD'
     C     DTYP          OREQ      'BP'
     C     BNNAIA        IFNE      'Y'                                          IF 02
     C                   Z-ADD     PUPR          $$AMNT
     C                   ELSE                                                   ELSE 02
     C                   Z-ADD     FVAL          $$AMNT
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     DTYP          IFEQ      'TB'                                         IF 01
     C     DTYP          OREQ      'TA'
     C     DTYP          OREQ      'DA'
     C                   Z-ADD     PUPR          $$AMNT
     C                   ENDIF                                                  ENDIF 01
     C                   ENDIF                                                                 MMI04
      *
     C                   Z-SUB     $$AMNT        $$AMNT                         Reverse Sign
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
      *                                                               *
      *****************************************************************
      *
     C     SC0362        BEGSR
      *
     C                   MOVEL(P)  'SC0362'      ERRSBR
      *
     C     RECI          IFEQ      'M'                                                    MMI043
     C     RECI          OREQ      'N'                                                    MMI043
     C                   Z-ADD     0             $$AMNT                                   MMI043
     C                   ELSE                                                             MMI043
      *
     C     DTYP          IFEQ      'C1'                                         IF 01          MMI04
     C     DTYP          OREQ      'C2'                                                        MMI04
     C     DTYP          OREQ      'BD'                                                        MMI04
     C     DTYP          OREQ      'BP'                                                        MMI04
     C     BNNAIA        IFNE      'Y'                                          IF 02          MMI04
     C                   Z-SUB     PUPR          $$AMNT                                        MMI04
     C                   ELSE                                                   ELSE 02        MMI04
     C                   Z-SUB     FVAL          $$AMNT                                        MMI04
     C                   ENDIF                                                  ENDIF 02       MMI04
     C                   ENDIF                                                  ENDIF 01       MMI04
      *                                                                   MMI043
     C     DTYP          IFEQ      'TB'                                         IF 01          MMI04
     C     DTYP          OREQ      'TA'                                                        MMI04
     C     DTYP          OREQ      'DA'                                                        MMI04
     C                   Z-SUB     PUPR          $$AMNT                                        MMI04
     C                   ENDIF                                                  ENDIF 01       MMI04
      *
     C                   ENDIF                                                                 MMI04
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
      *                                                               *
      *****************************************************************
      *
     C     SC0366        BEGSR
      *
     C                   MOVEL(P)  'SC0366'      ERRSBR
      *
     C     RECI          IFEQ      'M'                                          IF 01
     C     RECI          OREQ      'N'
     C                   CLEAR                   $$AMNT
      *
     C                   ELSE
      *
     C     DTYP          IFEQ      'C1'                                         IF 02
     C     DTYP          OREQ      'C2'
     C     DTYP          OREQ      'BD'
     C     DTYP          OREQ      'BP'
     C     BNNAIA        IFNE      'Y'                                          IF 03
     C                   Z-SUB     PUPR          $$AMNT
     C                   ELSE                                                   ELSE 03
     C                   Z-SUB     FVAL          $$AMNT
     C                   ENDIF                                                  ENDIF 03
     C                   ENDIF                                                  ENDIF 02
      *
     C     DTYP          IFEQ      'TB'                                         IF 02
     C     DTYP          OREQ      'TA'
     C     DTYP          OREQ      'DA'
     C                   Z-SUB     PUPR          $$AMNT
     C                   ENDIF                                                  ENDIF 02
      *
     C                   ENDIF                                                  ENDIF 01
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
      *                                                               *
      *****************************************************************
      *
     C     SC0382        BEGSR
      *
     C                   MOVEL(P)  'SC0382'      ERRSBR
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
      *                                                               *
      *****************************************************************
      *
     C     SC0384        BEGSR
      *
     C                   MOVEL(P)  'SC0384'      ERRSBR
      *
     C                   Z-ADD     MQCIM         $$AMNT
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
      *                                                               *
      *****************************************************************
      *
     C     SC0395        BEGSR
      *
     C                   MOVEL(P)  'SC0395'      ERRSBR
      *
     C     VDAT          IFLT      MPEQB                                        IF 01
      *
     C     DTYP          IFEQ      'C1'                                         IF 02
     C     DTYP          OREQ      'C2'
     C     DTYP          OREQ      'BD'
     C     DTYP          OREQ      'BP'
     C     BNNAIA        IFNE      'Y'                                          IF 03
     C                   Z-ADD     PUPR          $$AMNT
     C                   ELSE                                                   ELSE 03
     C                   Z-ADD     FVAL          $$AMNT
     C                   ENDIF                                                  ENDIF 03
     C                   ENDIF                                                  ENDIF 02
      *
     C     DTYP          IFEQ      'TB'                                         IF 02
     C     DTYP          OREQ      'TA'
     C     DTYP          OREQ      'DA'
     C                   Z-ADD     PUPR          $$AMNT
     C                   ENDIF                                                  ENDIF 02
      *
     C                   ENDIF                                                  ENDIF 01
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
      *                                                               *
      *****************************************************************
      *
     C     SC0396        BEGSR
      *
     C                   MOVEL(P)  'SC0396'      ERRSBR
      *
     C     VDAT          IFLT      MPDNB                                        IF 01
      *
     C     DTYP          IFEQ      'C1'                                         IF 02
     C     DTYP          OREQ      'C2'
     C     DTYP          OREQ      'BD'
     C     DTYP          OREQ      'BP'
     C     BNNAIA        IFNE      'Y'                                          IF 03
     C                   Z-ADD     PUPR          $$AMNT
     C                   ELSE                                                   ELSE 03
     C                   Z-ADD     FVAL          $$AMNT
     C                   ENDIF                                                  ENDIF 03
     C                   ENDIF                                                  ENDIF 02
      *
     C     DTYP          IFEQ      'TB'                                         IF 02
     C     DTYP          OREQ      'TA'
     C     DTYP          OREQ      'DA'
     C                   Z-ADD     PUPR          $$AMNT
     C                   ENDIF                                                  ENDIF 02
      *
     C                   ENDIF                                                  ENDIF 01
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
     C     IPFR          IFEQ      *BLANK
     C                   MOVE      '2'           C9339
     C                   ELSE
     C*                    MOVE '1'       C9339
     C***********          MOVE '3'       C9339
     C                   MOVE      '1'           C9339
     C                   ENDIF
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
     C     MDAT          IFLT      MMDNB
     C     MDAT          ANDGT     MPEMB
     C                   MOVE      '0'           C5064
     C                   ELSE
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
     C                   CLEAR                   $$DAY
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
     C                   CLEAR                   $$DAY
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
      *                                                               *
      *****************************************************************
      *
     C     SC5383        BEGSR
      *
     C                   MOVEL(P)  'SC5383'      ERRSBR
      *
     C     VDAT          IFLE      MLACD                                        IF 01
     C     VDAT          IFGT      MPEQB                                        IF 02
     C     DTYP          IFEQ      'C1'                                         IF 03
     C     DTYP          OREQ      'C2'
     C     DTYP          OREQ      'BD'
     C     DTYP          OREQ      'BP'
     C     BNNAIA        IFNE      'Y'                                          IF 04
     C                   Z-SUB     PUPR          $$AMNT
     C                   Z-ADD     1             C5445
     C                   ELSE                                                   ELSE 04
     C                   Z-SUB     FVAL          $$AMNT
     C                   Z-ADD     1             C5445
     C                   ENDIF                                                  ENDIF 04
     C                   ENDIF                                                  ENDIF 03
      *
     C     DTYP          IFEQ      'TB'                                         IF 03
     C     DTYP          OREQ      'TA'
     C     DTYP          OREQ      'DA'
     C                   Z-SUB     PUPR          $$AMNT
     C                   Z-ADD     1             C5445
     C                   ENDIF                                                  ENDIF 03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
      *                                                               *
      *****************************************************************
      *
     C     SC5385        BEGSR
      *
     C                   MOVEL(P)  'SC5385'      ERRSBR
      *
     C     MDAT          IFLE      MLACD                                        IF 01
     C     MDAT          IFGT      MPEQB                                        IF 02
     C     DTYP          IFEQ      'C1'                                         IF 03
     C     DTYP          OREQ      'C2'
     C     DTYP          OREQ      'BD'
     C     DTYP          OREQ      'BP'
     C     BNNAIA        IFNE      'Y'                                          IF 04
     C                   Z-ADD     PUPR          $$AMNT
     C                   Z-ADD     1             C5446
     C                   ELSE                                                   ELSE 04
     C                   Z-ADD     FVAL          $$AMNT
     C                   Z-ADD     1             C5446
     C                   ENDIF                                                  ENDIF 04
     C                   ENDIF                                                  ENDIF 03
      *
     C     DTYP          IFEQ      'TB'                                         IF 03
     C     DTYP          OREQ      'TA'
     C     DTYP          OREQ      'DA'
     C                   Z-ADD     PUPR          $$AMNT
     C                   Z-ADD     1             C5446
     C                   ENDIF                                                  ENDIF 03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
     C                   EXSR      XLM041
     C                   MOVE      $$CAMT        C5385                                      nt
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
     C     INTR          IFNE      *ZERO
     C                   MOVE      'F'           C6145                                      nt
     C                   ELSE
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
     C**********         CALL      'GLM043'                                     Parameters LUC109
     C                   CALL      'XX000043'                                   Parameters LUC109
     C                   PARM                    @DAYNO            5 0          Input Day #
     C                   PARM                    @NRDYS            2 0          # Wk Dys Fwd
     C                   PARM                    @CCY              3            Currency
     C                   PARM                    @LOC              3            Locn-optionl
     C                   PARM                    @DYNBR            5 0          Output Day #
      *
     C     MDAT          IFLE      @DYNBR
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
     C                   CLEAR                   SDACRCD0
     C                   MOVE      C9152         K1ACCD
     C                   MOVE      '9'           K1RSNO
      *
     C     PUPR          IFGT      *ZERO                                        IF    01
     C                   MOVE      'D'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     PUPR          IFLT      *ZERO                                        IF    01
     C                   MOVE      'C'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     PUPR          IFEQ      *ZERO                                        IF    01
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
     C                   CLEAR                   SDACRCD0
     C                   MOVE      C9153         K1ACCD
     C                   MOVE      '9'           K1RSNO
      *
     C     PUPR          IFGT      *ZERO                                        IF    01
     C                   MOVE      'D'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     PUPR          IFLT      *ZERO                                        IF    01
     C                   MOVE      'C'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     PUPR          IFEQ      *ZERO                                        IF    01
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
     C                   CLEAR                   SDACRCD0
     C                   MOVE      C9154         K1ACCD
     C                   MOVE      '9'           K1RSNO
      *
     C     PUPR          IFGT      *ZERO                                        IF    01
     C                   MOVE      'D'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     PUPR          IFLT      *ZERO                                        IF    01
     C                   MOVE      'C'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     PUPR          IFEQ      *ZERO                                        IF    01
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
     C                   CLEAR                   SDACRCD0
     C                   MOVE      C9176         K1ACCD
     C                   MOVE      '9'           K1RSNO
      *
     C     PUPR          IFGT      *ZERO                                        IF    01
     C                   MOVE      'D'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     PUPR          IFLT      *ZERO                                        IF    01
     C                   MOVE      'C'           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C     *IN03         IFEQ      *ON                                          IF    02
     C                   MOVE      ' '           K1DRCR
     C     K1ACRC        CHAIN(N)  SDACRCV0                           03
     C                   ENDIF                                                  ENDIF 02
     C                   ENDIF                                                  ENDIF 01
      *
     C     PUPR          IFEQ      *ZERO                                        IF    01
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
      *  Calls: XLM041 - Calling Routine GLM041 for AM data type conv.*
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
     C     RTSP          IFLT      0                                                           MUI01
     C                   Z-SUB(H)  RTSP          WK9851            8 5                         MUI01
     C                   MOVEL     '-'           C9851                                         MUI01
     C                   ELSE                                                                  MUI01
     C                   Z-ADD     RTSP          WK9851                                        MUI01
     C                   MOVEL     '+'           C9851                                         MUI01
     C                   ENDIF                                                                 MUI01
     C                   MOVE      WK9851        C9851                                         MUI01
      *                                                                   MUI011
     C                   ENDSR                                                                 MUI01
      *                                                                   MUI011
      *****************************************************************   CM00036425
      *                                                               *   CM00036425
      *  SCMXTN - Populate the field CMXTN                            *   CM00036425
      *                                                               *   CM00036425
      *  Called By: MOVFLD                                            *   CM00036425
      *                                                               *   CM00036425
      *****************************************************************   CM00036425
      *                                                                   CM00036425
     C     SCMXTN        BEGSR                                                                 CM000
      *                                                                   CM00036425
     C                   MOVEL(P)  'SCMXTN'      ERRSBR                                        CM000
      *                                                                   CM00036425
     C                   MOVE      *BLANK        CMXTN                                         CM000
     C**********         MOVE      DLNO          CHDLNO            6                    CM000 LUC109
     C*****MXKEY         CHAIN     GZNASPL1                           03                CM000 LUC109
      **********                                                                   CM00036425 LUC109
     C******IN03         IFEQ      *ON                                                  CM000 LUC109
     C**********         Z-ADD     10            COD                                    CM000 LUC109
     C**********         EXSR      PRINT                                                CM000 LUC109
     C**********         ELSE                                                           CM000 LUC109
     C                   MOVE      MXTRNO        CMXTN                                         CM000
     C**********         ENDIF                                                          CM000 LUC109
      *                                                                   CM00036425
     C                   ENDSR                                                                 CM000
      *                                                                   CM00006425
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
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  XLM041 - Calling Routine GLM041 for AM data type conversion  *
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
     C**********         CALL      'GLM041'                                              LUC109
     C                   CALL      'XX000041'                                            LUC109
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
      *  XLM053 - Calling Routine GLM053 for date conversion          *
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
     C**********         CALL      'GLM053'                                              LUC109
     C                   CALL      'XX000053'                                            LUC109
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
     C                   MOVEL     DLNO          ERRD01
     C     COD           WHENEQ    2
     C                   MOVEL     BRCA          ERRD01
     C     COD           WHENEQ    3
     C                   MOVEL     K1ACKE        ERRD01
     C                   MOVEL     DTYP          ERRD02
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
     C                   MOVEL     KBN           ERRD01
     C     COD           WHENEQ    10
     C                   MOVEL     DLNO          ERRD01                         CM00036425
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
     C                   READ      SDBANKD0                             0303
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
     C                   READ      SDGELRV0                             0303
     C                   CLOSE     SDGELRV0
      *
     C     *IN03         IFEQ      *ON
     C                   Z-ADD     8             COD
     C                   EXSR      PRINT
     C                   ENDIF
      *
     C                   MOVEL(P)  'DEAL'        KBN
     C                   OPEN      SDDEALL0
     C     KSDDEA        CHAIN     SDDEALL0                           0303
     C                   CLOSE     SDDEALL0
      *
     C     *IN03         IFEQ      *ON
     C                   Z-ADD     9             COD
     C                   EXSR      PRINT
     C                   ENDIF
      *
     C     *LIKE         DEFINE    G6RSNO        K1RSNO
     C     *LIKE         DEFINE    G6ACCD        K1ACCD
     C     *LIKE         DEFINE    G6DRCR        K1DRCR
      *
     C     K1ACRC        KLIST
     C                   KFLD                    K1RSNO
     C                   KFLD                    K1ACCD
     C                   KFLD                    K1DRCR
      *
      ***Set*Up*key*to*chain*to*GZNASPL1*******************************                       LUC109
     C*****MXKEY         KLIST                                                     CM00036425 LUC109
     C**********         KFLD                    WZONE                             CM00036425 LUC109
     C**********         KFLD                    CHDLNO                            CM00036425 LUC109
      *                                                    CM00036425
     C                   MOVEL     'LONDON'      WZONE            10            CM00036425
      *
     C     *LIKE         DEFINE    BNDLDA        KBN
     C     KSDDEA        KLIST
     C                   KFLD                    KBN
      *
     C     *IN90         IFEQ      *ON
     C     *IN90         ANDEQ     *OFF
     C                   UPDATE    DEALDFX0                             90
     C                   UPDATE    SDBRCHD0                             90
     C                   UPDATE    SDACRCD0                             90
     C                   UPDATE    ACKEYALF                             90
     C                   ENDIF
      *
     C                   ENDSR
**
DEALSDY0 RECORD NOT FOUND
SDBRCHV0 RECORD NOT FOUND
ACKEYV0  RECORD NOT FOUND
ERROR FOUND CALLING XX000041
SDACRCV0 RECORD NOT FOUND
G6RSCD NOT NUMERIC
SDBANKPD FILE IS EMPTY
SDGELRV0 FILE IS EMPTY
SDDEALL0 FILE IS EMPTY
T_GZNASPEX RECORD NOT FOUND
