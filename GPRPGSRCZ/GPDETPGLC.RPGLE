     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Determine Position GL Category')              *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPDETPGLC  - Determine Position GL Category                  *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. DAI103             Date 25Jun19               *
      *  Prev Amend No. NADC01  *CREATE    Date 17Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI103 - Upgraded MPlus 121 NADC01 ML Extracts to FB 2.1     *
      *  NADC01 - ML EXTRACTS FOR MIZUHO                              *
      *                                                               *
      *****************************************************************
     D PAcKyPos01      S              3
     D PAcKyPos04      S              1
     D PAcKyPos05      S              1
     D PAcKyPos07      S              2
     D PAcKyPos13      S              1
     D PAcKyPos19      S              2
     D PAcCodDR1       S             10
     D PAcSecDR1       S              2
     D PPosRfDR1       S              1
     D PAcCodDR2       S             10
     D PAcSecDR2       S              2
     D PPosRfDR2       S              1
     D PAcCodDR3       S             10
     D PAcSecDR3       S              2
     D PPosRfDR3       S              1
     D PAcCodCR1       S             10
     D PAcSecCR1       S              2
     D PPosRfCR1       S              1
     D PAcCodCR2       S             10
     D PAcSecCR2       S              2
     D PPosRfCR2       S              1
     D PAcCodCR3       S             10
     D PAcSecCR3       S              2
     D PPosRfCR3       S              1
 
     C     *ENTRY        PLIST
     C                   PARM                    I#TRTP            5            INV TYPE
     C                   PARM                    I#SNAM           50            SHORTAME
     C                   PARM                    O#GLCAT           5            GL CATEGORY
 
     C                   MOVEL     I#TRTP        INVT              3
     C                   MOVEL     *BLANK        BOOK              2
     C                   EVAL      BOOK = %SubST(I#SNAM: 5:2)
      * Get principal key
     C                   EXSR      SRSetPrAcKy
 
     C                   RETURN
 
      ***********************************************************************************
     C     SRSetPrAcKy   BEGSR
 
     C                   EVAL      PAcKyPos01 = INVT
     C                   EVAL      PAcKyPos04 = 'V'
     C                   EVAL      PAcKyPos05 = 'P'
     C                   EVAL      PAcKyPos07 = BOOK
     C                   EVAL      PAcKyPos13 = 'S'
     C                   EVAL      PAcKyPos19 = 'CO'
 
      * Get Securities account key
 
     C                   EXSR      SRGetAcKeyD
 
     C                   IF        PPosRfDR1 = ' '
     C                   EVAL      PAcKyPos19 = 'FV'
     C                   EXSR      SRGetAcKeyD
     C                   ENDIF
 
     C                   IF        PAcSecDR1 = 'ME'
     C                   EVAL      O#GLCAT = '2 OFF'                            OFF BAL SHEET
     C                   ELSE
     C                   IF        PAcSecDR1 = 'CO'
     C                   EVAL      O#GLCAT = '3 MEM'                            MEMORANDUM
     C                   ELSE
     C                   EVAL      O#GLCAT = '1 ON '                            ON BAL SHEET
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ***********************************************************************************
     C     SRGetAcKeyD   BEGSR
 
     C                   CALLB     'MRACSSAKY'
     C                   PARM                    PAcKyPos01
     C                   PARM                    PAcKyPos04
     C                   PARM                    PAcKyPos05
     C                   PARM                    PAcKyPos07
     C                   PARM                    PAcKyPos13
     C                   PARM                    PAcKyPos19
 
     C                   PARM      *BLANKS       PAcCodDR1
     C                   PARM      *BLANKS       PAcSecDR1
     C                   PARM      *BLANKS       PPosRfDR1
     C                   PARM      *BLANKS       PAcCodDR2
     C                   PARM      *BLANKS       PAcSecDR2
     C                   PARM      *BLANKS       PPosRfDR2
     C                   PARM      *BLANKS       PAcCodDR3
     C                   PARM      *BLANKS       PAcSecDR3
     C                   PARM      *BLANKS       PPosRfDR3
     C                   PARM      *BLANKS       PAcCodCR1
     C                   PARM      *BLANKS       PAcSecCR1
     C                   PARM      *BLANKS       PPosRfCR1
     C                   PARM      *BLANKS       PAcCodCR2
     C                   PARM      *BLANKS       PAcSecCR2
     C                   PARM      *BLANKS       PPosRfCR2
     C                   PARM      *BLANKS       PAcCodCR3
     C                   PARM      *BLANKS       PAcSecCR3
     C                   PARM      *BLANKS       PPosRfCR3
 
     C                   ENDSR
      ***********************************************************************************
