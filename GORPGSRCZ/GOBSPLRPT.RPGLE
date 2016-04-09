     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  ALWNULL(*YES) CVTOPT(*VARCHAR)                               *
/*EXI *  TEXT('Midas GO BSPL Report')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSPLRPT - BSPL Report                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CAS014             Date 10Aug05               *
      *                 CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS014 - IAS21  The Effects of Changes in Foreign Exchange   *
      *           Rates                                               *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGPACBLZPD IP   F 1277  1206AIDISK    INFSR(*PSSR)
     FGPICDTL0  IF   E           K DISK    INFSR(*PSSR)
     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)
     FGZSDCOMPL1IF   E           K DISK    INFSR(*PSSR)
     FI_GRBRCHG1IF   E           K DISK    INFSR(*PSSR)
     FGPBSPLBPD IF   E           K DISK    INFSR(*PSSR)
     FGOBSPLRPP1O    F  132        PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
     FGPBSXDPD  O    E             DISK    INFSR(*PSSR) USROPN
                                                                                              CAS014
      ** Midas GZ Account codes                                                               CAS014
     FGZSDACODL0IF   E           K DISK    INFSR(*PSSR)                                       CAS014
                                                                                              CAS014
      ** Midas GP Global Account Codes                                                        CAS014
     FGPACODL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS014
 
 
      ** File Information Data Structure for GOBSPLRPP1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
                                                                                              CAS014
      ** Data Structure for parameter INTREPDTS                                               CAS014
     D WKINTREP        DS            14                                                       CAS014
     D  Wk_InCAv               1      1A                                                      CAS014
     D  Wk_InAPd               2      3A                                                      CAS014
     D  Wk_InAPE               4      7A                                                      CAS014
     D  Wk_RpCAv               8      8A                                                      CAS014
     D  Wk_RpAPd               9     10A                                                      CAS014
     D  Wk_RpAPE              11     14A                                                      CAS014
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D PLevel          S              1
     D ZSnum           S              6  0
     D ZSerr           S              1
 
 
     D OUT             S              1    DIM(132)
 
     D UL              S              1    DIM(20) CTDATA PERRCD(20)
     D MON             S              3    DIM(12) CTDATA PERRCD(12)
 
     D TMP             S              1A   DIM(21)
     D TAM             S             21S 3 DIM(21)
 
     D PLV             S             60    DIM(20)
     D CLV             S             60    DIM(20)
     D NLV             S             60    DIM(20)
 
 
     D BRCCON          S              4    DIM(999)
     D BRCNCON         S              4    DIM(999)
 
      ** Parameters for calling AOSARDR0                                                      CAS014
     D PrtCd           S              7                                                       CAS014
     D POptn           S              7                                                       CAS014
     D PSARD           S              6                                                       CAS014
                                                                                              CAS014
      ** CAS014 variables                                                                     CAS014
     D CAS014          S              1A                                                      CAS014
     D wGSysBal        S              1A                                                      CAS014
     D Wk_Amt          S             21P 3                                                    CAS014
     D Wk_Net          S             15  0                                                    CAS014
     D wDecNo          S              1  0                                                    CAS014
     D Wk_BalLn        S             35                                                       CAS014
     D Wk_PBal         S              1                                                       CAS014
     D Wk_AcSc         S              2                                                       CAS014
     D Wk_Acod         S             10                                                       CAS014
     D Wk_Period       S              2                                                       CAS014
     D Wk_MDesc        S             20                                                       CAS014
 
      * BSPL Export Data
     D GPBSXD        E DS                  EXTNAME(GPBSXDPD)
     D CExpLevels             37   1236
     D CEXPLV                 37   1236    DIM(20)
 
     D                 DS
     D NExpLevels             37   1236
     D NEXPLV                 37   1236    DIM(20)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Second DS for access programs
 
      ** Switchable Feature descriptions                                                      CAS014
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS014
                                                                                              CAS014
     D LDA           E DS           256    EXTNAME(LDA)                                       CAS014
                                                                                              CAS014
      ** Local data area for database error details                                           CAS014
      ** *LOCK IN LDA immediately before and OUT LDA immediately                              CAS014
      ** after each database error handling.                                                  CAS014
      **                                                                                      CAS014
      **                                    134 141 DBFILE                                    CAS014
      **       Defines:                     142 170 DBKEY                                     CAS014
      **                                    171 180 DBPGM                                     CAS014
      **                                    181 1830DBASE                                     CAS014
                                                                                              CAS014
 
     IGPACBLZPD NS  01
     I                                  1 1277  Record
     I                                  1    3  BRCA
     I                                  4    6  REPCCY
     I                                  7 1206  CurrLevels
     I                               1207 1256  CurrACOD
     I                             P 1267 1277 3AMOUNT
     I          NS  **
     I                                  1    3  NextBRCA
     I                                  4    6  NextREPCCY
     I                                  7 1206  NextLevels
     I                               1207 1256  NextACOD
 
 
     C                   MOVEA     CurrLevels    CLV
     C                   MOVEA     NextLevels    NLV
 
     C                   SETON                                        54
 
      * If account code breakdown requested, append account codes to hierarchy
 
     C     DDACDBD       IFEQ      'Y'
     C                   Z-ADD     1             X                 3 0
     C     *BLANK        LOOKUP    CLV(X)                                 99
     C                   MOVEL     CurrACOD      CLV(X)
     C                   Z-ADD     1             X
     C     *BLANK        LOOKUP    NLV(X)                                 99
     C                   MOVEL     NextACOD      NLV(X)
     C                   ENDIF
 
      * EXPORT DATA
 
     C     DDEXPRT       IFEQ      'Y'
     C                   EXSR      Export_Data
     C                   ENDIF
 
      * Change of branch
 
     C     BRCA          IFNE      PrevBRCA
      *                                                                                       CAS014
      ** If CAS014 is On and there's a change of branch, print Balancing Line                 CAS014
      *                                                                                       CAS014
     C                   IF        CAS014 = 'Y' and wGSysBal = 'Y'                            CAS014
     C                   EVAL      Wk_PBal  = 'Y'                                             CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
     C                   EXSR      OPENCLOSE_PRTF
     C                   ENDIF
 
      * Change of branch or currency
 
     C     BRCA          IFNE      PrevBRCA
     C     REPCCY        ORNE      PrevREPCCY
     C                   MOVE      *BLANK        TMP
     C                   Z-ADD     *ZERO         TAM
     C                   MOVEL     *BLANK        PLV
      *                                                                                       CAS014
      ** If CAS014 is On and there's a change in CCy, print Balancing Line                    CAS014
      *                                                                                       CAS014
     C                   IF        CAS014 = 'Y' and wGSysBal = 'Y'                            CAS014
     C                   EVAL      Wk_PBal  = 'Y'                                             CAS014
     C                   EXSR      PRTBAL                                                     CAS014
     C                   EVAL      Wk_PBal  = 'N'                                             CAS014
     C                   ENDIF                                                                CAS014
 
     C                   ENDIF
 
     C     BRCA          IFNE      NextBRCA
     C     REPCCY        ORNE      NextREPCCY
     C                   MOVEL     *BLANK        NLV
     C                   ENDIF
 
      * Process headings
 
     C                   EXSR      PROC_HDG
 
     C                   ADD       AMOUNT        TAM
      *                                                                                       CAS014
      ** If CAS014 is On and Average spot rate conversion requested generate                  CAS014
      ** Balancing item                                                                       CAS014
      *                                                                                       CAS014
     C                   IF        CAS014 = 'Y' and wGSysBal = 'Y'                            CAS014
     C                   EXSR      ACCUM_AMT                                                  CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
 
      * Process totals
 
     C                   EXSR      PROC_TOT
 
     C                   MOVEL     BRCA          PrevBRCA          3
     C                   MOVEL     REPCCY        PrevREPCCY        3
 
      * End of report
 
     CLR   PrintFileOPEN IFNE      'Y'
     CLR                 EXSR      OPENCLOSE_PRTF
     CLR                 ENDIF
     CLR                 z-add     3             No_line           1 0
     CLR                 EXSR      PAGECHECK
                                                                                              CAS014
     CLR                 IF        CAS014 = 'Y' and wGSysBal = 'Y'                            CAS014
     CLR                 EXSR      PRTBAL                                                     CAS014
     CLR                 ENDIF                                                                CAS014
                                                                                              CAS014
     CLR                 EXCEPT    ENDOFRPT
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Process Headings
      ********************************************************************
     C     PROC_HDG      BEGSR
     C                   Z-ADD     1             L                 2 0
 
     C     L             DOWLE     TotNoLevels
 
     C     CLV(L)        IFNE      PLV(L)
     C     CLV(L)        ANDNE     *BLANK
     C     L             IFEQ      1
     C                   Z-ADD     EndofPage     LINENO
     C                   ENDIF
     C                   EXSR      OUTPUTHDG
     C                   Z-ADD     *ZERO         TAM(L)
     C                   MOVE      'Y'           TMP(L)
     C                   ENDIF
 
     C                   ADD       1             L
     C                   ENDDO
     C                   MOVEL     CLV           PLV
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Process Totals
      ********************************************************************
     C     PROC_TOT      BEGSR
     C                   Z-ADD     TotNoLevels   L
 
     C     L             DOWGE     1
 
     C     CLV(L)        IFNE      NLV(L)
     C     CLV(L)        ANDNE     *BLANK
     C                   EXSR      OUTPUTTOT
     C                   MOVE      ' '           TMP(L)
     C                   ENDIF
 
     C                   SUB       1             L
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Output Headings
      ********************************************************************
     C     OUTPUTHDG     BEGSR
     C                   MOVEA     *BLANK        OUT
     C                   EXSR      TEMPLATE
 
     C     L             IFNE      LastHeadLvL
     C                   z-add     1             No_line           1 0
     C                   EXSR      PAGECHECK
     C                   EXCEPT    LINESPB
     C                   ENDIF
 
     C                   EVAL      X = (Mult*L) - Minus
     C                   MOVE      CLV(L)        TEXT             50
     C                   MOVEA     TEXT          OUT(X)
 
     C                   z-add     1             No_line
     C                   EXSR      PAGECHECK
     C                   EXCEPT    LINESPB
 
     C                   MOVEL     CLV(L)        LastOUTPUT       60
     C                   Z-ADD     L             LastHeadLvl       2 0
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Output Totals
      ********************************************************************
     C     OUTPUTTOT     BEGSR
     C                   MOVEA     *BLANK        OUT
     C                   EXSR      TEMPLATE
 
     C                   EXSR      EDIT_BAL
 
      * Output amount only
 
     C     CLV(L)        IFEQ      LastOUTPUT
     C                   MOVEA     *BLANK        OUT
     C                   MOVEA     ZOUT21        OUT(112)
     C                   z-add     0             No_line
     C                   EXSR      PAGECHECK
     C                   EXCEPT    LINENOSPB
     C                   ELSE
 
      * Output underline
 
     C                   MOVEA     UL            OUT(112)
     C                   z-add     1             No_line
     C                   EXSR      PAGECHECK
     C                   EXCEPT    LINESPB
 
      * Output total heading and total
 
     C                   MOVE      CLV(L)        TEXT
     C                   MOVEA     TEXT          OUT(70)
     C                   MOVEA     ZOUT21        OUT(112)
     C                   EXSR      ADDTOTid
     C                   z-add     1             No_line
     C                   EXSR      PAGECHECK
     C                   EXCEPT    LINESPB
     C                   ENDIF
 
     C                   MOVEL     CLV(L)        LastOUTPUT
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Add Total id
      ********************************************************************
     C     ADDTOTid      BEGSR
     C                   EVAL      X = (Mult*L) - Minus
     C                   MOVE      '\'           OUT(X)
     C                   ADD       1             X
     C     OUT(X)        DOUNE     ' '
     C                   MOVE      '_'           OUT(X)
     C                   ADD       1             X
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Edit Balance
      ********************************************************************
     C     EDIT_BAL      BEGSR
 
     C                   SELECT
     C     DDROUND       WHENEQ    'T'
     C     TAM(L)        DIV(H)    1000          ZFLD15
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      'J'           ZECODE            1
     C                   PARM      *BLANK        ZOUT21           21
 
     C     DDROUND       WHENEQ    'U'
     C                   Z-ADD(H)  TAM(L)        ZFLD15
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      'J'           ZECODE            1
     C                   PARM      *BLANK        ZOUT21           21
 
     C                   OTHER
     C                   MOVE      TAM(L)        ZFLD15
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      3             ZDECS             1 0
     C                   PARM      'J'           ZECODE            1
     C                   PARM      *BLANK        ZOUT21           21
     C                   ENDSL
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Write Template to Output Data
      ********************************************************************
     C     TEMPLATE      BEGSR
     C                   Z-ADD     1             Y                 2 0
     C     Y             DOUEQ     21
     C     TMP(Y)        IFEQ      'Y'
     C                   EVAL      X = (Mult*Y) - Minus
     C                   MOVE      '|'           OUT(X)
     C                   ENDIF
     C                   ADD       1             Y
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Page Change Check
      ********************************************************************
     C     PAGECHECK     BEGSR
 
     C     BRCA          COMP      '&&&'                                  55    *Consolidated
 
     C     DDRPTYP       COMP      'B'                                    56    *Balances
 
     C                   ADD       No_Line       LINENO            2 0
     C     LINENO        IFGT      60
     C                   Z-ADD     3             LINENO
     C                   ADD       No_Line       LINENO
     C                   ADD       1             PAGENO            4 0
     C                   EXCEPT    PAGEHEAD
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Open and Close Printer File
      ********************************************************************
     C     OPENCLOSE_PRTFBEGSR
 
      * Access branch name
 
     C     BRCA          IFNE      '&&&'
     C     BRCA          CHAIN     SDBRCHD0                           99
     C   99              EVAL      A8BRNM = '* UNKNOWN *'
     C                   ENDIF
 
      * Close printer file
     C     PrintFileOPEN IFEQ      'Y'
     C                   z-add     3             No_line           1 0
     C                   EXSR      PAGECHECK
                                                                                              CAS014
     C                   IF        CAS014 = 'Y' and wGSysBal = 'Y'                            CAS014
     C                   EXSR      PRTBAL                                                     CAS014
     C                   EVAL      Wk_PBal = 'N'                                              CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
     C                   EXCEPT    ENDOFRPT
     C                   CLOSE     GOBSPLRPP1
     C                   ENDIF
 
      * Open printer file
     C                   MOVEL     'Y'           PrintFileOPEN     1
     C                   Z-ADD     *ZERO         PAGENO
     C                   OPEN      GOBSPLRPP1
     C                   EXSR      RCFP1
     C                   EXSR      SELECTION
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Export Data
      ********************************************************************
     C     Export_Data   BEGSR
 
     C                   MOVEL     DDRQID        RQID
     C                   MOVEL     DDRRQID       RRQID
 
     C                   MOVEA     CLV           CEXPLV
     C                   MOVEA     NLV           NEXPLV
 
     C                   Z-ADD     20            L                 2 0
     C     L             DOWGT     TotNoLevels
     C                   MOVEL     *BLANK        CEXPLV(L)
     C                   MOVEL     *BLANK        NEXPLV(L)
     C                   SUB       1             L
     C                   ENDDO
 
     C                   ADD       AMOUNT        TAMOUNT
 
     C     CExpLevels    IFNE      NExpLevels
     C                   WRITE     GPBSXDD0
     C                   Z-ADD     *ZERO         TAMOUNT
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Determine Reporting Levels
      ********************************************************************
     C     DET_RPT_LVLS  BEGSR
 
      * Total number of levels to report
 
     C                   MOVEL     DDHDPTH       TotNoLevels       2 0
 
      * Maximum number of levels available for reporting
 
     C                   MOVEL     MaximumLevel  MaxNoLevels       2 0
     C     DDACDBD       IFEQ      'Y'
     C                   ADD       1             MaxNoLevels
     C                   ENDIF
 
      * Report up to the maximum number of levels (but no higher than 20)
 
     C     TotNoLevels   IFGT      MaxNoLevels
     C                   Z-ADD     MaxNoLevels   TotNoLevels
     C                   ENDIF
     C     TotNoLevels   IFGT      20
     C                   Z-ADD     20            TotNoLevels
     C                   ENDIF
 
     C                   SELECT
     C     TotNoLevels   WHENGT    16
     C                   Z-ADD     3             Mult              2 0
     C                   Z-ADD     1             Minus             2 0
     C     TotNoLevels   WHENGT    10
     C                   Z-ADD     4             Mult              2 0
     C                   Z-ADD     2             Minus             2 0
     C     TotNoLevels   WHENGT    6
     C                   Z-ADD     7             Mult              2 0
     C                   Z-ADD     5             Minus             2 0
     C                   OTHER
     C                   Z-ADD     10            Mult              2 0
     C                   Z-ADD     8             Minus             2 0
     C                   ENDSL
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Digits to a Number
      ********************************************************************
     C     ZALIGN        BEGSR
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Selection Criteria
      ********************************************************************
     C     SELECTION     BEGSR
 
     C                   MOVEL     *BLANK        FieldTEXT        31
     C                   MOVEL     *BLANK        FieldVALU        45
     C                   EXCEPT    SELECTHEAD
      **
     C                   EVAL      FieldTEXT = 'Request Type                   '
     C                   IF        DDRQTYP  = 'I'
     C                   EVAL      FieldVALU = 'INTERMEDIATE'
     C                   ELSE
     C                   EVAL      FieldVALU = 'SCHEDULED'
     C                   ENDIF
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Request ID                     '
     C                   EVAL      FieldVALU = DDRQID + ' ' + DDRRQID
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Zone or Global                 '
     C                   IF        DDZNGL = 'Z'
     C                   EVAL      FieldVALU = 'ZONE'
     C                   ELSE
     C                   EVAL      FieldVALU = 'GLOBAL'
     C                   ENDIF
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Zone to Run Report             '
     C                   EVAL      FieldVALU = DDZONE
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Branch                         '
     C                   EVAL      FieldVALU = DDBRC
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Branch Group                   '
     C                   IF        DDBRGRP <> *BLANK
     C                   IF        DDZNGL = 'Z'
     C                   MOVEL     DDBRGRP       CompanyCode       3
     C     GZSDCOMPK     CHAIN     SDCOMPD0                           99
     C                   EVAL      FieldVALU = DDBRGRP + APCMNM
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDBRGRP       ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     15            ZADIG
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        BGID
     C     BGID          CHAIN     I_GRBRCHG1                         99
     C                   EVAL      FieldVALU = DDBRGRP + %SubST(BGNAME:1:30)
     C                   ENDIF
     C                   ELSE
     C                   EVAL      FieldVALU = DDBRGRP
     C                   ENDIF
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Branch Consolidation           '
     C                   IF        DDBRCON = 'Y'
     C                   EVAL      FieldVALU = 'YES'
     C                   ELSE
     C                   EVAL      FieldVALU = 'NO '
     C                   ENDIF
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'BSPL Report Set                '
     C                   IF        DDRPSET <> *BLANK
     C                   EVAL      FieldVALU = DDRPSET + %SubST(RepSetName:1:30)
     C                   ELSE
     C                   EVAL      FieldVALU = DDRPSET
     C                   ENDIF
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Hierarchy Depth                '
     C                   EVAL      FieldVALU = DDHDPTH
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Chart of Accounts              '
     C                   IF        DDCHART = 'Y'
     C                   EVAL      FieldVALU = 'YES'
     C                   ELSE
     C                   EVAL      FieldVALU = 'NO '
     C                   ENDIF
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Relative Period Number         '
     C                   EVAL      FieldVALU = DDRELPN
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Calendar Year                  '
     C                   EVAL      FieldVALU = DDCYR + '             20'+ DDCYR
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Calendar Month                 '
     C                   EVAL      FieldVALU = DDCMTH +'             '+REPMON
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Report Type                    '
     C                   IF        DDRPTYP = 'B'
     C                   EVAL      FieldVALU = 'BALANCES'
     C                   ELSE
     C                   EVAL      FieldVALU = 'MOVEMENTS'
     C                   ENDIF
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Report Movement Duration       '
     C                   SELECT
     C                   WHEN      DDRMDUR = 'M'
     C                   EVAL      FieldVALU = 'MONTHLY'
     C                   WHEN      DDRMDUR = 'Q'
     C                   EVAL      FieldVALU = 'QUARTERLY'
     C                   WHEN      DDRMDUR = 'X'
     C                   EVAL      FieldVALU = 'HALF-YEARLY'
     C                   WHEN      DDRMDUR = 'Y'
     C                   EVAL      FieldVALU = 'YEARLY'
     C                   OTHER
     C                   EVAL      FieldVALU = '      '
     C                   ENDSL
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Interim Currency               '
     C                   SELECT
     C                   WHEN      %SubST(DDINTDTLS: 1: 1) = 'N'
     C                   EVAL      FieldVALU = 'NONE'
     C                   WHEN      %SubST(DDINTDTLS: 1: 1) = 'B'
     C                   EVAL      FieldVALU = 'BASE'
     C                   WHEN      %SubST(DDINTDTLS: 1: 1) = 'D'
     C                   EVAL      FieldVALU = 'DEFINED'
     C                   ENDSL
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Interim Currency              '
     C                   EVAL      FieldVALU = %SubST(DDINTDTLS: 2: 3)
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Interim Currency Conversion    '
     C                   SELECT
     C                   WHEN      %SubST(DDINTDTLS: 5: 1) = 'Z'
     C                   EVAL      FieldVALU = 'ZONE RATES'
     C                   WHEN      %SubST(DDINTDTLS: 5: 1) = 'N'
     C                   EVAL      FieldVALU = 'NOMINATED RATES'
     C                   WHEN      %SubST(DDINTDTLS: 5: 1) = 'H'
     C                   EVAL      FieldVALU = 'HEAD-OFFICE RATES'
     C                   ENDSL
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Zone for Nominated Zone Rates  '
     C                   EVAL      FieldVALU = %SubST(DDINTDTLS: 6: 10)
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Report Currency                '
     C                   SELECT
     C                   WHEN      %SubST(DDREPDTLS: 1: 1) = 'A'
     C                   EVAL      FieldVALU = 'ACTUAL'
     C                   WHEN      %SubST(DDREPDTLS: 1: 1) = 'B'
     C                   EVAL      FieldVALU = 'BASE'
     C                   WHEN      %SubST(DDREPDTLS: 1: 1) = 'H'
     C                   EVAL      FieldVALU = 'HEAD-OFFICE'
     C                   WHEN      %SubST(DDREPDTLS: 1: 1) = 'D'
     C                   EVAL      FieldVALU = 'DEFINED'
     C                   ENDSL
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Report Currency               '
     C                   EVAL      FieldVALU = %SubST(DDREPDTLS: 2: 3)
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Report Currency Conversion     '
     C                   SELECT
     C                   WHEN      %SubST(DDREPDTLS: 5: 1) = 'Z'
     C                   EVAL      FieldVALU = 'ZONE RATES'
     C                   WHEN      %SubST(DDREPDTLS: 5: 1) = 'N'
     C                   EVAL      FieldVALU = 'NOMINATED RATES'
     C                   WHEN      %SubST(DDREPDTLS: 5: 1) = 'H'
     C                   EVAL      FieldVALU = 'HEAD-OFFICE RATES'
     C                   ENDSL
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Zone for Nominated Zone Rates  '
     C                   EVAL      FieldVALU = %SubST(DDREPDTLS: 6: 10)
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Account Code Breakdown         '
     C                   IF        DDACDBD = 'Y'
     C                   EVAL      FieldVALU = 'YES'
     C                   ELSE
     C                   EVAL      FieldVALU = 'NO '
     C                   ENDIF
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Print Zero Balances            '
     C                   IF        DDPRTZB = 'Y'
     C                   EVAL      FieldVALU = 'YES'
     C                   ELSE
     C                   EVAL      FieldVALU = 'NO '
     C                   ENDIF
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Rounding                       '
     C                   IF        DDROUND = 'N'
     C                   EVAL      FieldVALU = 'NONE'
     C                   ELSE
     C                   IF        DDROUND = 'U'
     C                   EVAL      FieldVALU = 'UNITS'
     C                   ELSE
     C                   EVAL      FieldVALU = 'THOUSANDS'
     C                   ENDIF
     C                   ENDIF
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Include Foreign Ccy Transfer   '
     C                   IF        DDIFCTFR= 'Y'
     C                   EVAL      FieldVALU = 'YES'
     C                   ELSE
     C                   EVAL      FieldVALU = 'NO '
     C                   ENDIF
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Include Base Ccy Transfer      '
     C                   IF        DDIBCTFR= 'Y'
     C                   EVAL      FieldVALU = 'YES'
     C                   ELSE
     C                   EVAL      FieldVALU = 'NO '
     C                   ENDIF
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Instruction ID                 '
     C                   EVAL      FieldVALU = DDINSID
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Description                    '
     C                   EVAL      FieldVALU = DDDESC
     C                   EXCEPT    SELECTCRIT
      **
     C                   EVAL      FieldTEXT = 'Export                         '
     C                   IF        DDEXPRT = 'Y'
     C                   EVAL      FieldVALU = 'YES'
     C                   ELSE
     C                   EVAL      FieldVALU = 'NO '
     C                   ENDIF
     C                   EXCEPT    SELECTCRIT
 
     C                   IF        CAS014 = 'Y'                                               CAS014
                                                                                              CAS014
      ** Write Interim Conversion of I/E Using Average Rates                                  CAS014
                                                                                              CAS014
     C                   EVAL      FieldTEXT = 'Interim Conv of I/E, Ave Rates '              CAS014
     C                   EVAL      FieldVALU = Wk_InCAv                                       CAS014
     C                   EXCEPT    SELECTCRIT                                                 CAS014
                                                                                              CAS014
      ** Write Interim Average Rate Period                                                    CAS014
                                                                                              CAS014
     C                   EVAL      Wk_Period = Wk_InAPd                                       CAS014
     C                   EXSR      DET_MDESC                                                  CAS014
     C                   EVAL      FieldTEXT = 'Interim Average Rate Period    '              CAS014
     C                   EVAL      FieldVALU = WK_MDesc                                       CAS014
     C                   EXCEPT    SELECTCRIT                                                 CAS014
                                                                                              CAS014
      ** Write Interim Average Period End                                                     CAS014
                                                                                              CAS014
     C                   EVAL      FieldTEXT = 'Interim Ave Period End (MMYY)  '              CAS014
     C                   EVAL      FieldVALU = Wk_INAPE                                       CAS014
     C                   EXCEPT    SELECTCRIT                                                 CAS014
                                                                                              CAS014
      ** Write Reporting Conversion of I/E Using Average Rates                                CAS014
                                                                                              CAS014
     C                   EVAL      FieldTEXT = 'Report Conv of I/E, Ave Rates '               CAS014
     C                   EVAL      FieldVALU = Wk_RpCAv                                       CAS014
     C                   EXCEPT    SELECTCRIT                                                 CAS014
                                                                                              CAS014
      ** Write Reporting Average Rate Period                                                  CAS014
                                                                                              CAS014
     C                   EVAL      Wk_Period = Wk_RpAPd                                       CAS014
     C                   EXSR      DET_MDESC                                                  CAS014
     C                   EVAL      FieldTEXT = 'Report Average Rate Period    '               CAS014
     C                   EVAL      FieldVALU = Wk_MDesc                                       CAS014
     C                   EXCEPT    SELECTCRIT                                                 CAS014
                                                                                              CAS014
      ** Reporting Average Period End (MMYY)                                                  CAS014
                                                                                              CAS014
     C                   EVAL      FieldTEXT = 'Report Ave Period End (MMYY)  '               CAS014
     C                   EVAL      FieldVALU = Wk_RPAPE                                       CAS014
     C                   EXCEPT    SELECTCRIT                                                 CAS014
                                                                                              CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
      **  Report branches
 
     C                   EXSR      REPT_BRANCHES
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Load Branches
      ********************************************************************
     C     LOAD_BRANCHES BEGSR
     C                   Z-ADD     1             #NC               3 0
     C                   Z-ADD     1             #C                3 0
     C     *LOVAL        SETLL     GPBSPLBD0
     C                   READ      GPBSPLBD0                              99
     C     *IN99         DOWEQ     *OFF
     C                   MOVEL     A8BRCD        W_BRCA            4
     C     BREXT1        IFEQ      *BLANK
     C     BREXT2        OREQ      *BLANK
     C     DDRPTYP       ANDEQ     'M'
     C                   MOVEL     W_BRCA        BRCNCON(#NC)
     C                   ADD       1             #NC
     C                   ELSE
     C                   MOVEL     W_BRCA        BRCCON(#C)
     C                   ADD       1             #C
     C                   ENDIF
     C                   READ      GPBSPLBD0                              99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Report Branches
      ********************************************************************
     C     REPT_BRANCHES BEGSR
 
      * Contributing
     C                   Z-ADD     1             #B                3 0
     C     BRCCON(#B)    DOWNE     *BLANK
     C     #B            IFEQ      1
     C                   EXCEPT    BRANCHCON
     C                   ENDIF
     C                   MOVEL     *BLANK        ListOfBranches
     C                   MOVEA     BRCCON(#B)    ListOfBranches
     C                   EXCEPT    BRANCHLIST
     C                   ADD       25            #B
     C                   ENDDO
 
      * Non-Contributing
     C                   Z-ADD     1             #B
     C     BRCNCON(#B)   DOWNE     *BLANK
     C     #B            IFEQ      1
     C                   EXCEPT    BRANCHNCON
     C                   ENDIF
     C                   MOVEL     *BLANK        ListOfBranches  100
     C                   MOVEA     BRCNCON(#B)   ListOfBranches
     C                   EXCEPT    BRANCHLIST
     C                   ADD       25            #B
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * RCF Processing for P1 Printer File
      ********************************************************************
     C     RCFP1         BEGSR
 
     C                   IF        BRCA <> '&&&'
     C                   EVAL      PEnty = BRCA
     C                   ENDIF
     C                   EVAL      ZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM      SEQUENCE      PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM                    ZSErr
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      I#ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
                                                                                              CAS014
      ********************************************************************                    CAS014
      * Accumulate Amount for Asset and Liablities                                            CAS014
      ********************************************************************                    CAS014
     C     ACCUM_AMT     BEGSR                                                                CAS014
                                                                                              CAS014
      *                                                                                       CAS014
      **  Check account section of the account code if it is 'AS'                             CAS014
      ** 'LI', 'IN' or 'EX' then accumulate the amount for the balancing entries              CAS014
      *                                                                                       CAS014
     C                   EXSR      CHKACOD                                                    CAS014
                                                                                              CAS014
                                                                                              CAS014
      ** Net debit/credit amounts                                                             CAS014
                                                                                              CAS014
     C                   IF        Wk_AcSc = 'AS' OR Wk_AcSc = 'IN'                           CAS014
     C                             OR Wk_AcSc = 'EX' OR Wk_AcSc = 'LI'                        CAS014
     C                   ADD       Amount        Wk_Amt                                       CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
     C                   ENDSR                                                                CAS014
                                                                                              CAS014
      ********************************************************************                    CAS014
      * Check Account Code if Income or Expense                                               CAS014
      ********************************************************************                    CAS014
     C     CHKACOD       BEGSR                                                                CAS014
                                                                                              CAS014
     C                   EVAL      Wk_AcSc = *Blanks                                          CAS014
     C                   MOVEL     CurrAcod      Wk_Acod                                      CAS014
      *                                                                                       CAS014
      ** Verify existence in GZ Account Codes File                                            CAS014
      *                                                                                       CAS014
     C     Wk_Acod       CHAIN     GZSDACODL0                         99                      CAS014
                                                                                              CAS014
     C                   IF        %FOUND(GZSDACODL0)                                         CAS014
     C                   EVAL      Wk_AcSc = A5ACSC                                           CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
      ** If not found, verify existence in GP Global Account Codes File                       CAS014
                                                                                              CAS014
     C                   IF        NOT %FOUND(GZSDACODL0)                                     CAS014
                                                                                              CAS014
     C     Wk_Acod       CHAIN     GPACODL0                           99                      CAS014
                                                                                              CAS014
     C                   IF        %FOUND(GPACODL0)                                           CAS014
     C                   EVAL      Wk_AcSc = ACACSC                                           CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
     C                   ENDSR                                                                CAS014
                                                                                              CAS014
      ********************************************************************                    CAS014
      * Print Balancing Line and Amount                                                       CAS014
      ********************************************************************                    CAS014
     C     PRTBAL        BEGSR                                                                CAS014
                                                                                              CAS014
     C                   MOVEA     *BLANK        OUT                                          CAS014
      ** Write Balancing Line and Amount                                                      CAS014
                                                                                              CAS014
     C                   EVAL      Wk_BalLn= 'SYSTEM - GENERATED BALANCING ITEM'              CAS014
     C                   MOVEA     Wk_BalLn      OUT(70)                                      CAS014
                                                                                              CAS014
     C                   IF        Wk_Amt <> 0                                                CAS014
                                                                                              CAS014
      *                                                                                       CAS014
      ** Reverse sign to post contra on the balancing line                                    CAS014
      *                                                                                       CAS014
     C                   Z-SUB     WK_Amt        WK_Amt                                       CAS014
                                                                                              CAS014
      *                                                                                       CAS014
      **  Edit accumulated Balance based on the request.                                      CAS014
      *                                                                                       CAS014
     C                   SELECT                                                               CAS014
     C                   WHEN      DDROUND = 'T'                                              CAS014
     C     Wk_Amt        DIV(H)    1000          Wk_Net                                       CAS014
     C                   EVAL      WDecNo = 0                                                 CAS014
                                                                                              CAS014
     C                   WHEN      DDROUND = 'U'                                              CAS014
     C                   Z-ADD(H)  Wk_Amt        Wk_Net                                       CAS014
     C                   EVAL      WDecNo = 0                                                 CAS014
                                                                                              CAS014
     C                   OTHER                                                                CAS014
     C                   MOVE      Wk_Amt        Wk_Net                                       CAS014
     C                   EVAL      WDecNo = 3                                                 CAS014
     C                   ENDSL                                                                CAS014
                                                                                              CAS014
     C                   CALL      'ZSEDIT'                                                   CAS014
     C                   PARM                    Wk_Net                                       CAS014
     C                   PARM      WDecNo        ZDECS                                        CAS014
     C                   PARM      'J'           ZECODE                                       CAS014
     C                   PARM      *BLANK        ZOUT21                                       CAS014
                                                                                              CAS014
     C                   MOVEA     ZOUT21        OUT(112)                                     CAS014
     C                   ELSE                                                                 CAS014
     C                   MOVE      0             OUT(131)                                     CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
     C                   EVAL      NO_LINE = 2                                                CAS014
     C                   EXSR      PAGECHECK                                                  CAS014
     C                   EXCEPT    LINE2SPB                                                   CAS014
                                                                                              CAS014
      ** Output underline                                                                     CAS014
                                                                                              CAS014
     C                   MOVEA     *BLANK        OUT                                          CAS014
     C                   MOVEA     UL            OUT(112)                                     CAS014
     C                   EVAL      NO_LINE = 1                                                CAS014
     C                   EXSR      PAGECHECK                                                  CAS014
     C                   EXCEPT    LINESPB                                                    CAS014
                                                                                              CAS014
     C                   EVAL      Wk_Net = 0                                                 CAS014
     C                   EVAL      Wk_Amt = 0                                                 CAS014
                                                                                              CAS014
     C                   ENDSR                                                                CAS014
                                                                                              CAS014
      ********************************************************************                    CAS014
      * Determine Month Description                                                           CAS014
      ********************************************************************                    CAS014
     C     DET_MDESC     BEGSR                                                                CAS014
                                                                                              CAS014
     C                   SELECT                                                               CAS014
                                                                                              CAS014
     C                   WHEN      Wk_Period = 'M '                                           CAS014
     C                   EVAL      Wk_MDesc = 'Monthly             '                          CAS014
     C                   WHEN      Wk_Period = 'CQ'                                           CAS014
     C                   EVAL      Wk_MDesc = 'Quarterly Calendar  '                          CAS014
     C                   WHEN      Wk_Period = 'CS'                                           CAS014
     C                   EVAL      Wk_MDesc = 'Six Monthly Calendar'                          CAS014
     C                   WHEN      Wk_Period = 'CY'                                           CAS014
     C                   EVAL      Wk_MDesc = 'Yearly Calendar     '                          CAS014
     C                   WHEN      Wk_Period = 'FQ'                                           CAS014
     C                   EVAL      Wk_MDesc = 'Quarterly Fiscal    '                          CAS014
     C                   WHEN      Wk_Period = 'FX'                                           CAS014
     C                   EVAL      Wk_MDesc = 'Six Monthly Fiscal  '                          CAS014
     C                   WHEN      Wk_Period = 'FY'                                           CAS014
     C                   EVAL      Wk_MDesc = 'Yearly Fiscal       '                          CAS014
     C                   OTHER                                                                CAS014
     C                   EVAL      Wk_MDesc = '                    '                          CAS014
                                                                                              CAS014
     C                   ENDSL                                                                CAS014
                                                                                              CAS014
     C                   ENDSR                                                                CAS014
                                                                                              CAS014
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR - Initial Processing
      ********************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * Report Set Name
      * Maximum Level
 
     C                   PARM                    RepSetName       50
     C                   PARM                    MaximumLevel      2
 
      * Request Type
     C                   PARM                    DDRQTYP           1
      * Request ID
      * Related Request ID
     C                   PARM                    DDRQID           15
     C                   PARM                    DDRRQID          15
      * Zone or Global
      * Zone To Run Report
     C                   PARM                    DDZNGL            1
     C                   PARM                    DDZONE           10
      * Branch
      * Branch Group
      * Branch Consolidation
     C                   PARM                    DDBRC             3
     C                   PARM                    DDBRGRP          15
     C                   PARM                    DDBRCON           1
      * BSPL Report Set
      * Hierarchy Depth
      * Chart of Accounts
     C                   PARM                    DDRPSET          15
     C                   PARM                    DDHDPTH           2
     C                   PARM                    DDCHART           1
      * Relative Period Number
     C                   PARM                    DDRELPN           3
      * Calendar Year
      * Calendar Month
     C                   PARM                    DDCYR             2
     C                   PARM                    DDCMTH            2
      * Report Type
      * Report Movement Duration
     C                   PARM                    DDRPTYP           1
     C                   PARM                    DDRMDUR           1
      * Interim Currency Type
      * Interim Currency
      * Interim Currency Conv. Methd
      * Interim Currency Nom. Zone
     C                   PARM                    DDINTDTLS        15
      * Report Currency Type
      * Report Currency
      * Report Currency Conv. Methd
      * Report Currency Nom. Zone
     C                   PARM                    DDREPDTLS        15
      * A/c Code Breakdown
      * Print Zero Balances
      * Rounding
     C                   PARM                    DDACDBD           1
     C                   PARM                    DDPRTZB           1
     C                   PARM                    DDROUND           1
      * Include For. Ccy Transfer
      * Include Base Ccy Transfer
     C                   PARM                    DDIFCTFR          1
     C                   PARM                    DDIBCTFR          1
      * Instruction ID
     C                   PARM                    DDINSID          10
      * Description
     C                   PARM                    DDDESC           50
      * Export
     C                   PARM                    DDEXPRT           1
      * Sequence
     C                   PARM                    SEQUENCE          5
                                                                                              CAS014
      ** Interim Average Rate Period                                                          CAS014
      ** Interim Average Period End                                                           CAS014
      ** Reporting Conversion of I/E                                                          CAS014
      ** Reporting Average Rate Period                                                        CAS014
      ** Reporting Average Period End                                                         CAS014
                                                                                              CAS014
     C                   PARM                    INTREPDTS        14                          CAS014
 
      * Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
                                                                                              CAS014
     C     *DTAARA       DEFINE                  LDA                                          CAS014
                                                                                              CAS014
      * Access Global ICD
 
     C     *LOVAL        SETLL     GPICDTD0
     C                   READ      GPICDTD0                               99
 
      * Return in error if global ICD not present
 
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'NO GLOBAL ICD PRESENT IN GPICDTPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Load branches
 
     C                   EXSR      LOAD_BRANCHES
 
      * Determine Reporting Levels
 
     C                   EXSR      DET_RPT_LVLS
 
      * End of Page Line
 
     C                   Z-ADD     61            EndOfPage         2 0
     C                   Z-ADD     EndofPage     LINENO
 
      * Report date
 
     C                   MOVEL     DDCMTH        Month             2 0
     C                   MOVEL     MON(Month)    REPMON            3
     C                   MOVEL     MON(Month)    REPDATE           5
     C                   MOVE      DDCYR         REPDATE
 
      * Export Data
 
     C     DDEXPRT       IFEQ      'Y'
     C                   OPEN      GPBSXDPD
     C                   CLEAR                   GPBSXD
     C                   ENDIF
 
     C                   EVAL      WKINTREP = INTREPDTS                                       CAS014
     C                   EVAL      Wk_PBal = ' '                                              CAS014
                                                                                              CAS014
      ** Determine if CAS014 is switched on                                                   CAS014
                                                                                              CAS014
     C                   CALL      'AOSARDR0'                                                 CAS014
     C                   PARM      *BLANKS       PrtCd                                        CAS014
     C                   PARM      '*VERIFY'     POptn                                        CAS014
     C                   PARM      'CAS014'      PSARD                                        CAS014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS014
                                                                                              CAS014
     C                   EVAL      CAS014 = 'N'                                               CAS014
                                                                                              CAS014
     C                   IF        PRTCD = *BLANKS                                            CAS014
     C                   EVAL      CAS014 = 'Y'                                               CAS014
     C                   ELSE                                                                 CAS014
                                                                                              CAS014
     C                   IF        PRTCD <> '*NRF   '                                         CAS014
                                                                                              CAS014
     C     *LOCK         IN        LDA                                                        CAS014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS014
     C                   EVAL      DBASE = 01                                                 CAS014
     C                   EVAL      DBKEY = 'CAS014'                                           CAS014
     C                   OUT       LDA                                                        CAS014
                                                                                              CAS014
     C                   EXSR      *PSSR                                                      CAS014
     C                   ENDIF                                                                CAS014
     C                   ENDIF                                                                CAS014
      *                                                                                       CAS014
      ** If interim or report average spot rate conversion is requested, set work             CAS014
      ** variable to generate system generated balance.                                       CAS014
      *                                                                                       CAS014
     C                   EVAL      wGSysBal  = 'N'                                            CAS014
     C                   IF        CAS014 = 'Y' and Wk_InCav = 'Y'                            CAS014
     C                             OR CAS014 = 'Y' and Wk_RpCav = 'Y'                         CAS014
     C                   EVAL      wGSysBal  = 'Y'                                            CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
      * Key lists
 
     C     GZSDCOMPK     KLIST
     C                   KFLD                    DDZONE
     C                   KFLD                    CompanyCode
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
     OGOBSPLRPP1E            SELECTHEAD       01
     O                                           19 'REFERENCE GOBSPLRPT'
     O                       GLSNAM             100
     O                                          118 'DATE:'
     O                       BJMRDT             129
     O          E            SELECTHEAD     5 02
     O                                           70 'REPORT SELECTION CRITERIA'
     O          E            SELECTCRIT  1
     O                       FieldTEXT           31
     O                       FieldVALU           76
     O          E            BRANCHCON   1
     O                                           14 'THE FOLLOWING '
     O                                           23 'BRANCHES '
     O                                           43 'CONTRIBUTED TO THIS '
     O                                           50 'REPORT:'
     O          E            BRANCHNCON  1
     O                                           23 'WARNING! THE FOLLOWING '
     O                                           40 'BRANCHES DID NOT '
     O                                           65 'CONTRIBUTE FULLY TO THIS '
     O                                           72 'REPORT:'
     O          E            BRANCHLIST  1
     O                       ListOfBranches     100
     O          E            PAGEHEAD         01
     O                                           19 'REFERENCE GOBSPLRPT'
     O                       GLSNAM             100
     O                                          126 'PAGE'
     O                       PAGENO        Z    130
     O          E            PAGEHEAD         02
     O                                           12 'REPORT DATE:'
     O                       REPDATE             17
     O                       RepSetName         100
     O                                          118 'DATE:'
     O                       BJMRDT             129
     O          E            PAGEHEAD         03
     O                     54                     7 'BRANCH:'
     O                    N55BRCA                11
     O                    N55A8BRNM              42
     O                     55                    20 'CONSOLIDATED'
     O                     56                    70 'BALANCES'
     O                    N56                    70 'MOVEMENTS'
     O                     54                   122 'CURRENCY:'
     O                       REPCCY             126
     O          E            LINESPB     1
     O                       OUT                132
     O          E            LINENOSPB   0
     O                       OUT                132
     O          E            LINE2SPB    2                                                    CAS014
     O                       OUT                132                                           CAS014
     O          E            ENDOFRPT    3
     O                                           75 '* END OF REPORT *'
** UL
====================
** MON
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
