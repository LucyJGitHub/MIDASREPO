     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')                     CAP084
      *****************************************************************
/*S******RPGBASE*******************************************************         CAP084
/*STD *  RPGBASEMOD                                                   *         CAP084
/*EXI *  TEXT('Midas AB Arbitrage deals update')                      *
     F*****************************************************************
     F*                                                               *
     F*  Midas  -  Internal Contracts & Arbitrage Dealing
     F*                                                               *
     F*     AB0240    - Update MIDAS Deals                            *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *     
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSW212             Date 03May12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241641             Date 22Sep06               *
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAP084             Date 06Sep03               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                 CAC001             Date 01Feb96               *
     F*                 080083             Date 02MAY96               *
     F*                 S01453             Date 13Dec93               *
     F*                 S01392             Date 20Jul92               *
     F*                  S01117             Date 30JAN90              *
     F*                  S01194             Date 30JAN90              *
     F*                  E19709             DATE 05/10/89             *
     F*                  E17063             DATE 07/07/89             *
     F*                  S01165             DATE 04/05/89             *
     F*                  AB0201             DATE 27/04/88             *
     F*                  AB0102             DATE 26/02/88             *
     F*                  AB0076             DATE 03/02/88             *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD046248 - Finastra Rebranding                               *     
      *  CDL099 - Split Value Date                                    *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  241641 - Initialise LITD and DITD to zeroes before writing   *
      *           new record.                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CAP084 - Convert to ILE.                                     *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CDL008 - Continuous Linked Settlement (Recompiled ABDELULL)  *
     F*  CAC001 - Profit Centre Accounting Development:               *
     F*           Additional fields for Analytical Accounting module  *
     F* 080083 - No cancellation confirmations produced for deleted   *
     F*          deals, as all bit settings were being set off. Fix   *
     F*          is to set off only bit 0 for a cancellation.         *
     F* S01453 - Margin and FX Positions/Points and Base currency     *
     F*          Positions/Points added to FX input (Recompiled)      *
     F* S01392 - JAP.SUB-MODULE INCORPORATION (CORE)                  *
     F* S01194 - NEW STANDING DATA                                    *
     F* S01117 - MULTI-BRANCHING.                                     *
     F*                                                               *
     F*  E19709 - THE DEALS FILE SHOULD ONLY BE OPENED AS INPUT,      *
     F*           ARBRITRAGE SHOULD HAVE A LOGICIAL FOR UPDATE        *
     F*           (ABDELULL) AS IN MM AND FX.                         *
     F*                                                               *
     F*  E17063 - Recompiled using IGNDECERR(*YES).                   *
     F*  S01165 - APPLY BOOK CODES AND LINKED REFERENCE NUMBER        *
     F*                                                               *
     F*  AB0076 - MUST REFERENCE FORMAT OVER PF/DTRIXHH B'COS THIS    *
     F*           IS THE FIRST OPEN OF LF/SDTIX AND OPEN FOR UPDATE   *
     F*  AB0102 - UPDATE OF PF/DEALSDF MUST BE DONE AS 2ND TO LAST    *   AB0102
     F*           UPDATE .THIS AVOIDS RECORD LOCKING.                 *   AB0102
     F*                                                               *
     F*  AB0201 - DUMP IF DBERR FOR EASIER FIXING                     *
     F*****************************************************************
     F*                                                               *
     F*  CREATION PARAMETERS                                          *
     F*                                                               *
*****F** SNPDUMP(*NONE) CODELIST(*NONE) IGNDECERR(*NO)              : *   E17063
     F*                                                               *
     F*****************************************************************
     F/EJECT
     F****************************************************************
     F*
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F*
     F*       60         FILE FAILURE
     F*
     F*       U6         PROGRAM ERROR
     F*       U7         DATA BASE OR EXCEPTION ERROR
     F*       U8         DATA BASE OR EXCEPTION ERROR
     F*
     F*****************************************************************
     F*DEALS   UF  E           K        DISK         KINFSR INFSR A    UC E19709
     F**********  DEALSDAF                          KIGNORE               E19709
     F**********  DEALSDCF                          KIGNORE               E19709
     F**********  DEALSDDF                          KIGNORE               E19709
     F**********  DEALSDEF                          KIGNORE               E19709
     F**********  DEALSDGF                          KIGNORE               E19709
     FABDELULL  UF A E           K DISK    INFSR(INFSR)                         E19709
     F                                     USROPN
     F                                     COMMIT
     F                                     INFDS(@DLOP)                         AB0102
     F**********SDTIX   O   E         K      DISK      KINFSR INFSR A UC  AB0076
     FSDTIX     UF A E           K DISK    INFSR(INFSR)                         AB0076
     F                                     USROPN
     F                                     COMMIT
     F*FDICDRLLIF*E***********K        DISK         KINFSR INFSR      UC  S01194
     F************TABTB20F*****                     KIGNORE               S01194
     F*************************                     KINFDS @ICOP          S01194
      *
     D*
     D**  ARRAY TO HOLD COPYRIGHT STATEMENT
      *
      *
     D*                                                                   AB0102
     D @DLOP           DS                                                       AB0102
     D  @DLOPN                 9      9                                         AB0102
     D**  FILE IN. DS. TO TEST IF FILE DEALS IS OPEN.                     AB0102
     D*                                                                   AB0102
     D @ICOP           DS                                                       AB0102
     D  @ICOPN                 9      9                                         AB0102
     D**  FILE IN. DS. TO TEST IF FILE FDICDRLL IS OPEN.                  AB0102
     D*                                                                   AB0102
     D @SDOP           DS                                                       CAP084
     D  @SDOPN                 9      9                                         CAP084
     D**  FILE IN. DS. TO TEST IF FILE SDTIX IS OPEN.                           CAP084
     D*                                                                         CAP084
     D @CPYRT          DS
     D*
     D**  DATA STRUCTURE FOR COMPILATION - COPYRIGHT INSERTION
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
     D PSDS           SDS
      **  PROGRAM STATUS DATA STRUCTURE.
      *
      **  Field containing file in process.
     D  @FILE                201    208
      **  Field containing workstation  ID.
     D  @JOB                 244    253
      **  Field containing user ID.
     D  @USER                254    263
      *
     D                UDS
      **  LOCAL DATA AREA FOR DATA BASE ERRORS.
      *
      **  Field containing name of database file in error.
     D  DBFILE               134    141
      **  Field containing key value causing database error.
     D  DBKEY                142    170
      **  Field containing name of program causing database error.
     D  DBPGM                171    180
      **  Field containing number of database error.
     D  DBASE                181    183
      *
      **  Data structure passed as parameters to this program.
      *
     D @DEAL         E DS                  EXTNAME(ABSTDDPP)
      *
      **  Information data structure for DEALS .
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    S01194
      ** BANK DETAILS ACCESSED VIA ACCESS PROGRAM                         S01194
     D  RUND                  34     36P 0                                      S01194
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     I* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                S01194
      *                                                                   S01194
      *****ata Structure for aligning integer/decimal purchase amount     AB0102
     I*****T      DS                             15                       AB0102
     I*****                                   1  120@INT                  AB0102
     I*****                                  13  150@DEC                  AB0102
     I*****                                   1  15 @ID                   AB0102
      /EJECT
      *
      **  Initial processing.
      *
     C                   EXSR      #A
      *
     C     @TERM         IFNE      'T'                                           B1
     C     *INU7         ANDNE     '1'                                           X1
      *
      **  Main processing 1
      *
     C                   EXSR      #B                                            *1
      *
     C     *INU7         IFNE      '1'                                          B*2
      *
      **  Main processing 2
      *
     C                   EXSR      #C                                           **2
      *
     C                   END                                                    E*2
      *
     C                   END                                                     E1
      *
      **  Termination processing
      *
     C                   EXSR      #D
      *
      /EJECT
      *****************************************************************
      *
      *  Index to subroutines - Order of listing due to frequency of
      *  ------------------------------------------------------------
      *                         usage.
      *                         ------
      *
      *      #A     -   Initial processing.
      *      #B     -   Main processing 1
      *      #C     -   Main processing 2
      *      #D     -   Termination processing
      *
      *      #BA    -   INSERTS RECORD 1 - DEALSDB
      *      #BB    -   INSERTS RECORD 2 - DEALSDB
      ****** #BC    -   UPDATES TRAILER TO DEALSDF FOR INSERT             AB0102
      *      #BD    -   UPDATES DEALSDB REC 1 & 2 FOR REVERSALS
      ****** #BE    -   UPDATES TRAILER TO DEALSDF FOR REVERSALS          AB0102
      *      #CA    -   UPDATES TRAILER TO PF/DTRIXDD
      *
      *
      ****** #ZA   -   ADD AMOUNT TO HASH TRAILER                         AB0102
      ****** #ZB   -   SUBTRACT AMOUNT FROM HASH TRAILER                  AB0102
      *
      *      INFSR  -   File error handling sub- routine.
      *      *PSSR  -   Program error handling sub- routine.
      *                                                               *
      *                                                               *
      *  External programs called.
      *  -------------------------
      *                                                               *
      *             **  NONE  **
      *                                                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SUBROUTINE: #B     - Main Processing 1
      *                                                               *
      *  FIELDS USED:        JUMACT   -   MIDAS action code.   *
      *                      @LEG     -   1ST OR 2CD LEG INDICATOR    *
      *                                                               *
      *                                                               *
      *  CALLED BY : MAIN PROGRAM                                     *
      ******LS     : #BA, #BB, #BC, #BD, BE,                          *   AB0102
      *  CALLS     : #BA, #BB, #BD                                    *   AB0102
      *                                                               *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     #B            BEGSR
      *
      **  Ascertain MIDAS action code AND PROCESS ACCORDINGLY
      *
      ** 1/ Insertions.
      *  --------------
     C     JUMACT        IFEQ      'I'                                           B1
      *
     C                   EXSR      #BA                                           *1
      *
     C     *INU7         IFEQ      '1'                                           B*2
     C                   GOTO      #B9                                           **2
     C                   END                                                     E*2
      *
     C                   EXSR      #BB                                           *1
      *
     C     *INU7         IFEQ      '1'                                           B*2
     C                   GOTO      #B9                                           **2
     C                   END                                                     E*2
      *
     C*****                EXSR #BC                         *1            AB0102
      *
     C                   ELSE                                                    X1
      *
      ** 2/ REVERSALS .
      *  --------------
      *
      **         JUMACT    WILL EQUAL 'R' AT THIS POINT
      *
     C                   EXSR      #BD                                           *1
      *
     C     *INU7         IFEQ      '1'                                           B*2
     C                   GOTO      #B9                                           **2
     C                   END                                                     E*2
      *
     C                   ADD       1             @LEG                            *1
      *
     C                   EXSR      #BD                                           *1
      *
     C     *INU7         IFEQ      '1'                                           B*2
     C                   GOTO      #B9                                           **2
     C                   END                                                     E*2
      *
     C*****                EXSR #BE                         *1            AB0102
      *
     C                   END                                                     E1
      *
     C     #B9           ENDSR                                                  **#B9**
      /EJECT
      *
      **
      *****************************************************************
      *                                                               *
      *  SUBROUTINE: #BA    - Insert a new RECORD ON MIDAS DEALS FILE *
      *                       record FORMAT DEALSDBF - PF/DEALSDB     *
      *                       (INSERTS RECORD LEG 1 FOR NEW DEAL)     *
      *                                                               *
      *  FIELDS USED:                                                 *
      *                                                               *
      *                      RECI   -  RECORD ID                      *
      *                      RCDT   -  RECORD TYPE                    *
      *                      RCDC   -  RECORD TO DATE                 *
      *                      CNUM   -  CUSTOMER NUMBER                *
      *                      BRCD   -  BRANCH CODE                    *
      *                      DTYP   -  DEAL TYPE                      *
      *                      DLST   -  DEAL SUB-TYPE                  *
      *                      DDAT   -  DEAL DATE                      *
      *                      DNSI   -  DEAL NON-STATIC INDICATORS     *
      *                      CNFI   -  CONFIRMATION INDICATORS        *
      *                      ACEI   -  ACCOUNTING INDICATORS          *
      *                      TLXI   -  TELEX INDICATORS               *
      *                      ORED   -  ORIGINAL ENTRY DATE            *
      *                      LCD    -  LAST CHANGE DATE               *
      *                      CHTP   -  LAST CHANGE TYPE               *
      *                      JUFD38 -  1ST DEAL NO                    *
      *                      DLNO   -  DEAL NO                        *
      *                      VDAT  -   VALUE DATE                    *
      *                      OTDT   -  OPTION TO DATE VALUE           *
      *                      PUCY   -  PURCHASE CCY                   *
      *                      SLCY   -  SELL CCY                       *
      *                      PUAM   -  PURCHASE AMMOUNT               *
      *                      SLAM   -  SELL AMOUNT                    *
      *****                  @SUM   -  SUM OF 1ST/2CD AMOUNTS         *   AB0102
      *                      JUNDXR -  XCHG RATE                     *
      *                      EXRT   -  XCHG RATE                      *
      *                      JUNBCA -  NEAR DATE BASE CCY FOR ACC EQUIV
      *                      BCEQ   -              "                  *
      *                      FSLI   -  FIRST LEG SWAP IND             *
      *                      JUSD38 -  2CD DEAL NO                    *
      *                      SODN   -  SWAP OPTION DEAL NO            *
      *                      DSTI   -  DEAL STATIC INDICATOR          *
      *                      BOKC   -  BOOK CODE                      *   S01165
      *                      LNKDN  -  LINKED DEAL NUMBER             *   S01165
      *                                                               *
      *  CALLED BY :  #B
      *  CALLS     :
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     #BA           BEGSR
      *
      ** CHANGES FOR BOTH LEGS
      *
      *
      ** RECORD ID
      *
     C                   MOVE      'D'           RECI
      *
      ** REC TYPE
      *
     C                   MOVE      'B'           RCDT
      *
      ** REC CODE
      *
     C                   Z-ADD     20            RCDC
      *
      ** CUST NO
      *
     C**********         Z-ADD     JUDCNO        CNUM                                         CSD027
     C                   EVAL      CNUM = JUDCNO                                              CSD027
      *
      ** BRANCH CODE
      *
     C*********************MOVE JUMBCD    BRCD                            S01117
     C                   MOVE      JUMBCA        BRCA                                          S0111
     C                   MOVE      JUORBR        ORBR                                          S0111
      *
      ** DEAL TYPE
      *
     C                   MOVE      JUMDTY        DTYP
      *
      ** DEAL SUBTYPE
      *
     C                   MOVE      JUSTYP        DLST
      *
      ** DEAL DATE
      *
     C                   Z-ADD     JUDDAT        DDAT
      *
      ** DEAL NON STATIC INDICATORS
      *
     C                   BITOFF    '01234567'    DNSI
      *
      ** CONFIRMATION INDICATORS
      *
     C                   BITOFF    '01234567'    CNFI
      *
      ** ACCOUNTING ENTRY INDICATORS
      *
     C                   BITOFF    '01234567'    ACEI
      *
      ** TELEX INDICATORS
      *
     C                   BITOFF    '01234567'    TLXI
      *
      ** ORIGINAL ENTRY DATE
      *
     C                   Z-ADD     RUND          ORED
      *
      ** LAST CHANGE DATE
      *
     C                   Z-ADD     RUND          LCD
      *
      ** LAST CHANGE TYPE
      *
     C                   MOVE      JUMACT        CHTP
      *
      ** LINKED REFERENCE                                                 S01165
      *                                                                   S01165
     C                   MOVE      JULNKN        LNKDN                                         S0116
      *                                                                   S01117
      ***PROFIT*CENTRE*********************************************S01117 CAC001
      ** FX Profit Centre                                                 CAC001
      *                                                                   S01117
     C                   MOVE      JUPRFC        PRFC                                          S0111
      *                                                                   CAC001
      ** MM Profit Centre                                                 CAC001
      *                                                                   CAC001
     C                   MOVE      JUMMPC        ICPC                                          CAC00
      *                                                                                       241641
      ** Interest accrued to date fields                                                      241641
      *                                                                                       241641
     C                   Z-ADD     0             LITD                                         241641
     C                   Z-ADD     0             DITD                                         241641
      *
      ** CHANGES FOR FIRST LEG ONLY
      *
      *
      ** DEAL NUMBER
      *
     C                   Z-ADD     JUFD38        DLNO
      *
      ** NEAR DATE VALUE
      *
     C                   Z-ADD     JUNDAT        VDAT
      *
      ** OPTION TO DATE VALUE
      *
     C                   Z-ADD     JUFDAT        OTDT
      *
      ** IF 1ST CURRENCY NEAR DATE AMOUNT IS POSITIVE THEN
      ** SET PURCHASE CURRENCY TO 1ST CURRENCY AND SET SELL
      ** CURRENCY TO 2CD CURRENCY , HOWEVER IF THE 1ST CURRENCY
      ** NEAR DATE AMOUNT IS NOT POSITIVE THEN SET PURCHASE
      ** CURRENCY TO 2CD CURRENCY AND SELL CURRENCY TO 1ST CURRENCY
      *
      *
     C     JUNDA1        IFGT      0                                            B1
     C                   MOVE      JUDFCY        PUCY                           *1
     C                   MOVE      JUDSCY        SLCY                           *1
     C                   ELSE                                                   X1
     C                   MOVE      JUDFCY        SLCY                           *1
     C                   MOVE      JUDSCY        PUCY                           *1
     C                   END                                                    E1
      *
      ** IF 1ST CURRENCY NEAR DATE AMOUNT IS POSITIVE THEN
      ** SET PURCHASE AMOUNT TO 1ST CCY NEAR DATE AMOUNT AND SET SELL
      ** AMOUNT TO 2CD CCY NEAR DATE AMOUNT,HOWEVER IF THE 1ST CURRENCY
      ** NEAR DATE AMOUNT IS NOT POSITIVE THEN SET PURCHASE AMOUNT
      ** TO 2CD CCY NEAR DATE AMOUNT AND SET SELL AMOUNT TO FIRST
      ** CURRENCY NEAR DATE AMOUNT
      ** SIMULTANEOUSLY INITIALIZE AND INCREMENT A VARIABLE HOLDING
      ** THE PURCHASE VALUES FROM THE FIRST AND SECOND LEGS
      *
     C     JUNDA1        IFGT      0                                            B1
     C                   Z-ADD     JUNDA1        PUAM                           *1
     C                   Z-SUB     JUNDA2        SLAM                           *1
     C*****                Z-ADDPUAM      @SUM             *1             AB0102
     C                   ELSE                                                   X1
     C                   Z-SUB     JUNDA1        SLAM                           *1
     C                   Z-ADD     JUNDA2        PUAM                           *1
     C*****                Z-ADDPUAM      @SUM             *1             AB0102
     C                   END                                                    E1
      *
      ** EXCHANGE RATE
      *
     C                   Z-ADD     JUNDXR        EXRT
      *
      ** NEAR DATE BASE CCY FOR ACCOUNTING EQUIVALENT
      *
     C                   Z-ADD     JUNBCA        BCEQ
      *
      ** 1ST LEG SWAP INDICATOR
      *
     C                   MOVE      '1'           FSLI
      *
      ** SWAP OPTION DEAL NUMBER
      *
     C                   Z-ADD     JUSD38        SODN
      *
      ** DEALS STATIC INDICATOR
      *
     C                   BITOFF    '01234567'    DSTI
      *                                                                   S01165
      ** FX BOOK CODE                                                     S01165
      *                                                                   S01165
     C                   MOVE      JUFXBC        BOKC                                          S0116
      *
      ** END OF 1ST LEG ONLY CODE
      *
      *
      ** INITIALIZATION OF FIELDS UNUSED IN FIRST LEG
      *
     C                   MOVE      *BLANKS       ILCY
     C                   MOVE      *BLANKS       IDCY
     C                   Z-ADD     *ZEROS        ILAM
     C                   Z-ADD     *ZEROS        IDAM
     C                   Z-ADD     *ZEROS        ILIR
     C                   Z-ADD     *ZEROS        IDIR
     C                   Z-ADD     *ZEROS        ILIA
     C                   Z-ADD     *ZEROS        IDIA
     C                   Z-ADD     *ZEROS        ILCM
     C                   Z-ADD     *ZEROS        IDCM
     C                   MOVE      *BLANKS       JLRDF                                         S0139
     C                   MOVE      *BLANKS       JDRDF                                         S0139
      *                                                                                       CDL038
      ** DEAL CLASS                                                                           CDL038
      *                                                                                       CDL038
     C                   MOVE      JUCLAS        CLAS                                         CDL038
      *                                                                                       CDL099
     C                   IF        CDL099 = 'Y'                                               CDL099
     C                   Z-ADD     JUNDAT        BSDT2                                        CDL099
     C                   Z-ADD     JUFDAT        BRSD2                                        CDL099
     C                   ENDIF                                                                CDL099
      *
      *
      ** WRITE LEG 1 RECORD OF NEW DEAL ON RECORD FORMAT DEALSDBF
      *
     C                   WRITE     DEALSDBF                             60
      *
     C     *IN60         IFEQ      '1'                                          B*1
     C                   MOVE      '001'         DBASE                           *1
     C                   MOVE      'DEALSDB'     DBFILE                          *1
     C                   MOVE      '1'           *INU7                           *1
     C                   MOVE      '1'           *INU8                           *1
     C                   DUMP                                                    *1            AB020
     C                   END                                                    E*1
      *
      *
     C     #BA9          ENDSR                                                  **#BA9**
      /EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE: #BB   -     WRITES SECOND LEG ON NEW DEAL ON TO  *
      *                          MIDAS DEAL FILE PF/DEALSDB           *
      *                          FORMAT 7EALSDBF                      *
      *                                                               *
      *  FIELDS USED:                                                 *
      *                      RCDC   -  RECORD TO DATE                 *
      *                      JUFD38 -  1ST DEAL NO                    *
      *                      DLNO   -  DEAL NO                        *
      *                      VDAT  -   VALUE DATE                    *
      *                      OTDT   -  OPTION TO DATE VALUE           *
      *                      PUCY   -  PURCHASE CCY                   *
      *                      SLCY   -  SELL CCY                       *
      *                      PUAM   -  PURCHASE AMMOUNT               *
      *                      SLAM   -  SELL AMOUNT                    *
      *****                  @SUM   -  SUM OF 1ST/2CD AMOUNTS         *
      *                      JUNDXR -  XCHG RATE                     *
      *                      EXRT   -  XCHG RATE                      *
      *                      JUNBCA -  NEAR DATE BASE CCY FOR ACC EQUIV
      *                      BCEQ   -              "                  *
      *                      FSLI   -  FIRST LEG SWAP IND             *
      *                      JUSD38 -  2CD DEAL NO                    *
      *                      SODN   -  SWAP OPTION DEAL NO            *
      *                      DSTI   -  DEAL STATIC INDICATOR          *
      *                      ILCY   -  INTERNAL LOAN CCY              *
      *                      IDCY   -  INTERNAL DEPOSIT CCY           *
      *                      ILIA   -  INTERNAL LOAN INTEREST         *
      *                      IDIA   -  INTERNAL DEPOSIT INTEREST      *
      *                      JUINT1 -  1ST CCY INTEREST AMT           *
      *                      JUINT2 -  2CD CCY INTEREST AMT           *
      *                      ILAM   -  INTERNAL LOAN AMT              *
      *                      IDAM   -  INTERNAL DEPOSIT AMT           *
      *                      ILIR   -  INTERNAL LOAN INTEREST AMT     *
      *                      IDIR   -  INTERNAL DEP INTEREST AMT     *
      *                      DSTI   -  DEAL STATIC INDICATOR          *
      *                      JUICM1 -  FIRST CCY CALC METHOD          *
      *                      JUICM2 -  2CD CCY CALC METHOD            *
      *                      ILCM   -  INTERNAL LOAN CALC METHOD      *
      *                      IDCM   -  INTERNAL LOAN DEP METHOD       *
      *                      BOKC   -  BOOK CODE                      *   S01165
      *                      LNKDN  -  LINKED DEAL NUMBER             *   S01165
      *                      JLRDF  -  INTERNAL LOAN ROUND-DOWN IND   *   S01392
      *                      JDRDF  -  INTERNAL DEP. ROUND-DOWN IND   *   S01392
      *                                                               *
      *                                                               *
      *  CALLED BY :  #B
      *  CALLS     :
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     #BB           BEGSR
      *
      ** ZERO TR4ANSACTION NO OF LAST UPDATE
      *
     C                   Z-ADD     *ZEROS        TNLU
      *
      ** SECOND DEAL NUMBER
      *
     C                   Z-ADD     JUSD38        DLNO
      *
      ** FAR DATE VALUE
      *
     C                   Z-ADD     JUFDAT        VDAT
      *
      ** OPTION TO DATE VALUE
      *
     C                   Z-ADD     JUNDAT        OTDT
      *
      ** IF 1ST CURRENCY FAR DATE AMOUNT IS POSITIVE THEN
      ** SET PURCHASE CURRENCY TO 1ST CURRENCY AND SET SELL
      ** CURRENCY TO 2CD CURRENCY , HOWEVER IF THE 1ST CURRENCY
      ** FAR DATE AMOUNT IS NOT POSITIVE THEN SET PURCHASE
      ** CURRENCY TO 2CD CURRENCY AND SELL CURRENCY TO 1ST CURRENCY
      *
      *
     C     JUFDA1        IFGT      0                                            B1
     C                   MOVE      JUDFCY        PUCY                           *1
     C                   MOVE      JUDSCY        SLCY                           *1
     C                   ELSE                                                   X1
     C                   MOVE      JUDFCY        SLCY                           *1
     C                   MOVE      JUDSCY        PUCY                           *1
     C                   END                                                    E1
      *
      ** IF 1ST CURRENCY FAR DATE AMOUNT IS POSITIVE THEN
      ** SET PURCHASE AMOUNT TO 1ST CCY FAR DATE AMOUNT AND SET SELL
      ** AMOUNT TO 2CD CCY FAR DATE AMOUNT,HOWEVER IF THE 1ST CURRENCY
      ** FAR DATE AMOUNT IS NOT POSITIVE THEN SET PURCHASE AMOUNT
      ** TO 2CD CCY FAR DATE AMOUNT AND SET SELL AMOUNT TO FIRST
      ** CURRENCY FAR DATE AMOUNT
      ** SIMULTANEOUSLY INCREMENT SUM OF PURCHASE VALUES
      *
      *
     C     JUFDA1        IFGT      0                                            B1
     C                   Z-ADD     JUFDA1        PUAM                           *1
     C                   Z-SUB     JUFDA2        SLAM                           *1
     C*****                ADD  PUAM      @SUM             *1             AB0102
     C                   ELSE                                                   X1
     C                   Z-SUB     JUFDA1        SLAM                           *1
     C                   Z-ADD     JUFDA2        PUAM                           *1
     C*****                ADD  PUAM      @SUM             *1             AB0102
     C                   END                                                    E1
      *
      ** EXCHANGE RATE
      *
     C                   Z-ADD     JUFDXR        EXRT
      *
      ** FAR DATE BASE CCY FOR ACCOUNTING EQUIVALENT
      *
     C                   Z-ADD     JUFBCA        BCEQ
      *
      ** 2CD LEG SWAP INDICATOR
      *
     C                   MOVE      '2'           FSLI
      *
      ** SWAP OPTION DEAL NUMBER
      *
     C                   Z-ADD     JUFD38        SODN
      *
      *
      ** IF 1ST CURRENCY NEAR DATE AMOUNT IS POSITIVE THEN
      ** SET INTERNAL LOAN CURRENCY TO FIRST CURRENCY AND SET INTERNAL
      ** DEPOSIT CURRENCY TO 2CD CURRENCY ,HOWEVER IF THE 1ST CURRENCY
      ** NEAR DATE AMOUNT IS NOT POSITIVE THEN SET INTERNAL LOAN CCY
      ** TO 2CD CCY AND SET INTERNAL DEPOSIT CURRENCY TO 1ST CURRENCY
      *
     C     JUNDA1        IFGT      0                                            B1
     C                   MOVE      JUDFCY        ILCY                           *1
     C                   MOVE      JUDSCY        IDCY                           *1
     C                   ELSE                                                   X1
     C                   MOVE      JUDFCY        IDCY                           *1
     C                   MOVE      JUDSCY        ILCY                           *1
     C                   END                                                    E1
      *
      ** IF 1ST CURRENCY NEAR DATE AMOUNT IS POSITIVE THEN
      ** SET INTERNAL LOAN INTEREST AMOUNT TO 1ST CURRENCY INTEREST
      ** AMOUNT AND SET INTERNAL DEPOSIT INTEREST AMT TO 2CD CURRENCY
      ** INTEREST AMOUNT
      ** HOWEVER IF THE 1ST CURRENCY NEAR DATE AMOUNT IS NOT
      ** POSITIVE THEN SET INTERNAL LOAN INTEREST AMOUNT TO 2CD CCY
      ** INTEREST AMOUNT AND SET INTERNAL DEPOSIT INTEREST AMT TO 1ST
      ** CURRENCY INTEREST AMOUNT
      *
     C     JUNDA1        IFGT      0                                            B1
     C                   Z-ADD     JUINA1        ILIA                           *1
     C                   Z-ADD     JUINA2        IDIA                           *1
     C                   ELSE                                                   X1
     C                   Z-ADD     JUINA1        IDIA                           *1
     C                   Z-ADD     JUINA2        ILIA                           *1
     C                   END                                                    E1
      *
      *
      ** IF 1ST CURRENCY NEAR DATE AMOUNT IS POSITIVE THEN
      ** SET INTERNAL LOAN AMOUNT TO 1ST CURRENCY
      ** AMOUNT AND SET INTERNAL DEPOSIT AMOUNT TO 2CD CURRENCY
      ** AMOUNT
      ** HOWEVER IF THE 1ST CURRENCY NEAR DATE AMOUNT IS NOT
      ** POSITIVE THEN SET INTERNAL LOAN AMOUNT TO 2CD CCY
      ** AMOUNT AND SET INTERNAL DEPOSIT AMOUNT TO FIRST
      ** CURRENCY AMOUNT
      *
     C     JUNDA1        IFGT      0                                            B1
     C                   Z-ADD     JUNDA1        ILAM                           *1
     C                   Z-SUB     JUNDA2        IDAM                           *1
     C                   ELSE                                                   X1
     C                   Z-SUB     JUNDA1        IDAM                           *1
     C                   Z-ADD     JUNDA2        ILAM                           *1
     C                   END                                                    E1
      *
      ** IF 1ST CURRENCY NEAR DATE AMOUNT IS POSITIVE THEN
      ** SET INTERNAL LOAN INTEREST RATE TO 1ST CURRENCY INTEREST
      ** RATE AND SET INTERNAL DEPOSIT INTEREST RATE TO 2CD CURRENCY
      ** INTEREST RATE
      ** HOWEVER IF THE 1ST CURRENCY NEAR DATE RATE IS NOT
      ** POSITIVE THEN SET INTERNAL LOAN INTEREST RATE TO 2CD CCY
      ** INTEREST RATE AND SET INTERNAL DEPOSIT INTEREST RATE TO 1ST
      ** CURRENCY INTEREST RATE
      *
     C     JUNDA1        IFGT      0                                            B1
      *
      ** MAKE INTERNAL LOAN/DEPOSIT INTEREST RATES POSITIVE ON FILE
      *
      ** DEALS STATIC INDICATOR: IF LOAN INTEREST RATE IS NEGATIVE
      ** SET ON BIT 5 AND IF DEPOSIT INTEREST RATE IS NEGATIVE SET
      ** ON BIT 6
      *
     C     JUIRT1        IFLT      0                                            B*2
     C                   Z-SUB     JUIRT1        ILIR                           **2
     C                   BITON     '5'           DSTI                           **2
     C                   ELSE                                                   X*2
     C                   Z-ADD     JUIRT1        ILIR                           **2
     C                   END                                                    E*2
      *
     C     JUIRT2        IFLT      0                                            B*2
     C                   Z-SUB     JUIRT2        IDIR                           **2
     C                   BITON     '6'           DSTI                           **2
     C                   ELSE                                                   X*2
     C                   Z-ADD     JUIRT2        IDIR                           **2
     C                   END                                                    **2
      *
     C                   ELSE                                                   X1
      *
     C     JUIRT1        IFLT      0                                            B*2
     C                   Z-SUB     JUIRT1        IDIR                           **2
     C                   BITON     '6'           DSTI                           **2
     C                   ELSE                                                   X*2
     C                   Z-ADD     JUIRT1        IDIR                           **2
     C                   END                                                    E*2
      *
     C     JUIRT2        IFLT      0                                            B*2
     C                   Z-SUB     JUIRT2        ILIR                           **2
     C                   BITON     '5'           DSTI                           **2
     C                   ELSE                                                   X*2
     C                   Z-ADD     JUIRT2        ILIR                           **2
     C                   END                                                    **2
      *
     C                   END                                                    E1
      *
      ** IF 1ST CURRENCY NEAR DATE AMOUNT IS POSITIVE THEN
      ** SET INTERNAL LOAN INTEREST CALC METH TO 1ST CURRENCY
      ** CALC METHOD AND SET INTERNAL DEPOSIT INTEREST CALC METHOD
      ** TO 2CD CURRENCY CALC METHOD
      ** HOWEVER
      ** IF 1ST CURRENCY NEAR DATE AMOUNT IS NOT POSITIVE THEN
      ** SET INTERNAL LOAN INTEREST CALC METH TO 2CD CURRENCY
      ** CALC METHOD AND SET INTERNAL DEPOSIT INTEREST CALC METHOD
      ** TO 1ST CURRENCY CALC METHOD
      *
     C     JUNDA1        IFGT      0                                            B1
     C                   Z-ADD     JUICM1        ILCM                           *1
     C                   Z-ADD     JUICM2        IDCM                           *1
     C                   ELSE                                                   X1
     C                   Z-ADD     JUICM1        IDCM                           *1
     C                   Z-ADD     JUICM2        ILCM                           *1
     C                   END                                                    E1
      *                                                                   S01392
      ** IF 1ST CURRENCY NEAR DATE AMOUNT IS POSITIVE THEN                S01392
      ** SET INTERNAL LOAN INTEREST RD-DOWN IND TO 1ST CURRENCY           S01392
      ** CALC METHOD AND SET INTERNAL DEPOSIT INTEREST RD-DOWN IND        S01392
      ** TO 2CD CURRENCY CALC METHOD                                      S01392
      ** HOWEVER                                                          S01392
      ** IF 1ST CURRENCY NEAR DATE AMOUNT IS NOT POSITIVE THEN            S01392
      ** SET INTERNAL LOAN INTEREST RD-DOWN IND TO 2CD CURRENCY           S01392
      ** CALC METHOD AND SET INTERNAL DEPOSIT INTEREST RD-DOWN IND        S01392
      ** TO 1ST CURRENCY CALC METHOD                                      S01392
      *                                                                   S01392
     C     JUNDA1        IFGT      0                                            B1             S0139
     C                   MOVE      JURDF1        JLRDF                          *1             S0139
     C                   MOVE      JURDF2        JDRDF                          *1             S0139
     C                   ELSE                                                   X1             S0139
     C                   MOVE      JURDF1        JDRDF                          *1             S0139
     C                   MOVE      JURDF2        JLRDF                          *1             S0139
     C                   END                                                    E1             S0139
      *                                                                   S01165
      ** MM BOOK CODE                                                     S01165
      *                                                                   S01165
     C                   MOVE      JUMMBC        BOKC                                          S0116
      *                                                                                       CDL038
      ** DEAL CLASS                                                                           CDL038
      *                                                                                       CDL038
     C                   MOVE      JUCLAS        CLAS                                         CDL038
      *                                                                   S01165
      *                                                                                       241641
      ** Interest accrued to date fields                                                      241641
      *                                                                                       241641
     C                   Z-ADD     0             LITD                                         241641
     C                   Z-ADD     0             DITD                                         241641
      *
     C                   IF        CDL099 = 'Y'                                               CDL099
     C                   Z-ADD     JUFDAT        BSDT2                                        CDL099
     C                   Z-ADD     JUNDAT        BRSD2                                        CDL099
     C                   ENDIF                                                                CDL099
      *
      *
      *
      ** WRITE LEG 2 RECORD OF NEW DEAL ON RECORD FORMAT DEALSDBF
      *
     C                   WRITE     DEALSDBF                             60
      *
     C     *IN60         IFEQ      '1'                                          B*1
     C                   MOVE      '002'         DBASE                           *1
     C                   MOVE      'DEALSDB'     DBFILE                          *1
     C                   MOVE      '1'           *INU7                           *1
     C                   MOVE      '1'           *INU8                           *1
     C                   DUMP                                                    *1            AB020
     C                   END                                                    E*1
      *
      *
      *
     C     #BB9          ENDSR                                                  **#BB9**
      *
      /EJECT
      *****************************************************************   AB0102
      *****                                                           *   AB0102
      *****BROUTINE: #BC    -     WRITE A TRAILER RECORD TO THE       *   AB0102
      *****                       PF/DEALSDF, RECORD FORMAT DEALSDFF  *   AB0102
      *****                       FOR AN INSERT                           AB0102
      *****                                                               AB0102
      *****                                                           *   AB0102
      *****ELDS USED:                                                 *   AB0102
      *****                  NORE   -  NO OF RECORDS                  *   AB0102
      *****                  NINS   -  NO OF INSERTIONS               *   AB0102
      *****                  NLRA   -  NO OF LIVE RECS AFTER CYCLE    *   AB0102
      *****                  WSAMNP -  }                              *   AB0102
      *****                  @HINT  -  } WORK FIELDS TO SEPARATE      *   AB0102
      *****                  @HDEC  -  } INTEGER AND DECIMAL          *   AB0102
      *****                  VRIF   -  VAL REC INSERTED - INT        *    AB0102
      *****                  VRIL   -  VAL REC INSERTED - DEC         *   AB0102
      *****                  VLAF   -  VAL REC AFTER CYCLE -INT      *    AB0102
      *****                  VLAL   -  VAL REC AFTER CYCLE -DEC       *   AB0102
      *****                  LCD    -  LAST CHANGE DATE              *    AB0102
      *****                  CHTP   -  LAST CHANGE TYPE               *   AB0102
      *****                                                           *   AB0102
      *****                                                           *   AB0102
      *****LLED BY :  #B                                                  AB0102
      *****LLS     :  #ZA                                                 AB0102
      *****                                                           *   AB0102
      *****                                                           *   AB0102
      *****************************************************************   AB0102
      *****                                                               AB0102
     C*****      #BC       BEGSR                                          AB0102
      *****                                                               AB0102
      *****CESS TRAILER RECORD                                            AB0102
      *****                                                               AB0102
     C*****      999999    CHAINDEALSDFF             60                   AB0102
      *****                                                               AB0102
     C*****      *IN60     IFEQ '1'                        B1             AB0102
     C*****                MOVE '003'     DBASE            *1             AB0102
     C*****                MOVE 'DEALSDF' DBFILE           *1             AB0102
     C*****                MOVE '1'       *INU7            *1             AB0102
     C*****                MOVE '1'       *INU8            *1             AB0102
     C*****                GOTO #BC9                       *1             AB0102
     C*****                END                             E1             AB0102
      *****                                                               AB0102
      *****CREMENT NUMBER OF RECORDS BY 2                                 AB0102
      *****                                                               AB0102
     C*****                ADD  2         NORE                            AB0102
      *****                                                               AB0102
      *****CREMENT NUMBER OF INSERTIONS BY 2                              AB0102
      *****                                                               AB0102
     C*****                ADD  2         NINS                            AB0102
      *****                                                               AB0102
      *****CREMENT NO OF LIVE RECORDS AFTER INPUT CYCLE BY 2              AB0102
      *****                                                               AB0102
     C*****                ADD  2         NLRA                            AB0102
      *****                                                               AB0102
      *****CREMENT VALUE OF RECORD INSERTED (INTEGER AND DECIMAL) BY      AB0102
      *****E SUM OF PURCHASE AMOUNTS FROM THE FIRST AND SECOND LEGS       AB0102
      *****ORED IN @SUM, SEPARATE DECIMAL POINTS AND CALL SUBROUTINE      AB0102
      *****A                                                              AB0102
      *****MULTANEOUSLY INCREMENT VALUE OF RECORDS AFTER INPUT CYCLE      AB0102
      *****NTEGER AND DECIMAL) WITH THE SAME PURCHASE AMOUNTS             AB0102
      *****                                                               AB0102
     C*****                MOVE @SUM      @SPLIT                          AB0102
     C*****      @DEC      IFLT 0                          B1             AB0102
     C*****                Z-SUB@INT      @INT             *1             AB0102
     C*****                END                             E1             AB0102
      *****                                                               AB0102
     C*****                Z-ADDVRIF      @HINT                           AB0102
     C*****                Z-ADDVRIL      @HDEC                           AB0102
     C*****                EXSR #ZA                                       AB0102
     C*****                Z-ADD@HINT     VRIF                            AB0102
     C*****                Z-ADD@HDEC     VRIL                            AB0102
      *****                                                               AB0102
     C*****                Z-ADDVLAF      @HINT                           AB0102
     C*****                Z-ADDVLAL      @HDEC                           AB0102
     C*****                EXSR #ZA                                       AB0102
     C*****                Z-ADD@HINT     VLAF                            AB0102
     C*****                Z-ADD@HDEC     VLAL                            AB0102
      *****                                                               AB0102
      *****T LAST CHANGE DATE TO MIDAS RUN DATE FROM TABTB10              AB0102
      *****                                                               AB0102
     C*****                Z-ADDRUND      LCD                             AB0102
      *****                                                               AB0102
      *****ST CHANGE TYPE                                                 AB0102
      *****                                                               AB0102
     C*****                MOVE 'I'       CHTP                            AB0102
      *****                                                               AB0102
      *****WRITE RECORD                                                   AB0102
      *****                                                               AB0102
     C*****                UPDATDEALSDFF               60                 AB0102
      *****                                                               AB0102
     C*****      *IN60     IFEQ '1'                        B1             AB0102
     C*****                MOVE '011'     DBASE            *1             AB0102
     C*****                MOVE 'DEALSDF' DBFILE           *|             AB0102
     C*****                MOVE '1'       *INU7            *1             AB0102
     C*****                MOVE '1'       *INU8            *1             AB0102
     C*****                END                             E1             AB0102
      *****                                                               AB0102
      *****                                                               AB0102
     C*****      #BC9      ENDSR                           **#BC9**       AB0102
      /EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE: #BD    -      UPDATE PF/DEALSDB ,FORMAT DEALSDBF *
      *                            FOR A REVERSAL (LEGS 1 AND 2)      *
      *                                                               *
      *  FIELDS USED:                                                 *
      *                      @LEG   -  1ST/2CD LEG INDICATOR          *
      *                      @SUM   -  SUM OF PURCHASE VALUES         *
      *                      JUFD38 -  1ST DEAL NO                    *
      *                      @KEY   -  KEY TO DEALSDBF                *
      *                      JUSD38 -  2CD DEAL NO                   *
      *                      #ZB  -  DATABASE NAME                  *
      *                      JUNDA1 -  NEAR DATE AMOUNT 1             *
      *                      @AMT   -  STORE NEAR DATE AMOUNT         *
      *                      JUNDA2 -  NEAR DATE AMOUNT 2             *
      *                      CNFI   -  CONFIRMATION INDICATORS        *
      *                      RUND   -  MIDAS RUN DATE                 *
      *                      LCD    -  LAST CHANGE DATE               *
      *                      CHTP   -  LAST CHANGE TYPE               *
      *                                                               *
      *                                                               *
      *  CALLED BY :  #B                                              *
      *  CALLS     :                                                  *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     #BD           BEGSR
      *
      ** DETERMINE WHETHER FIRST OR SECOND LEG REQUIRES UPDATING
      ** AND ACCESS APPROPRIATE RECORD FROM DEALS FILE
      ** IF FIRST LEG PROCESSING ABOUT TO COMMENCE, INITIALIZE A
      ** TOTAL FIELD REPRESENTING THE TOTAL VALUE AMOUNT OF THE DELETE
      *
     C     @LEG          IFEQ      1                                            B1
     C*****                Z-ADD*ZEROS    @SUM   150       *1             AB0102
     C                   Z-ADD     JUFD38        @KEY              6 0          *1
     C                   ELSE                                                   X1
     C                   Z-ADD     JUSD38        @KEY                           *1
     C                   END                                                    E1
      *
     C     @KEY          CHAIN     DEALSDBF                           60
      *
     C     *IN60         IFEQ      '1'                                          B1
     C                   MOVE      '004'         DBASE                          *1
     C                   MOVE      'DEALSDB'     DBFILE                         *1
     C                   MOVE      '1'           *INU7                          *1
     C                   MOVE      '1'           *INU8                          *1
     C                   DUMP                                                   *1             AB020
     C                   GOTO      #BD9                                         *1
     C                   END                                                    E1
      *****                                                               AB0102
      ***** FIRST CURRENCY NEAR DATE AMOUNT IS POSITIVE INCREMENT A       AB0102
      *****TAL BY THE FIRST CURRENCY NEAR DATE AMOUNT. IF THE FIRST       AB0102
      *****RRENCY NEAR DATE AMOUNT IS NOT POSITIVE INCREMENT THE TOTAL    AB0102
      ***** THE SECOND CURRENCY NEAR DATE AMOUNT. SIMULTANEOUSLY IF       AB0102
      *****COND LEG PROCESSING IS TAKING PLACE INITIALIZE AND SET A       AB0102
      *****RIABLE TO THE APPROPRIATE NEAR DATE AMOUNT USING THE SAME      AB0102
      *****LECTION CRITERIA AS ABOVE                                      AB0102
      *****                                                               AB0102
     C*****      JUNDA1    IFGT 0                          B1             AB0102
      *****                                                               AB0102
     C*****      @LEG      IFEQ 2                          B*2            AB0102
     C*****                Z-ADDJUNDA1    @AMT   150       **2            AB0102
     C*****                END                             E*2            AB0102
      *****                                                               AB0102
     C*****                ADD  JUNDA1    @SUM             *1             AB0102
      *****                                                               AB0102
     C*****                ELSE                            X1             AB0102
      *****                                                               AB0102
     C*****      @LEG      IFEQ 2                          B*2            AB0102
     C*****                Z-ADDJUNDA2    @AMT             **2            AB0102
     C*****                END                             E*2            AB0102
      *****                                                               AB0102
     C*****                ADD  JUNDA2    @SUM             *1             AB0102
      *****                                                               AB0102
     C*****                END                             E1             AB0102
      *
      ***SET*CONFIRMATION*INDICATORS                                      080083
      *  Set off bit 0 for cancellation.                                  080083
      *
     C*********************BITOF'01234567'CNFI                            080083
     C                   BITOFF    '0'           CNFI                                          08008
      *
      ** SET LAST CHANGE DATE TO MIDAS RUN DATE
      *
     C                   Z-ADD     RUND          LCD
      *
      ** SET LAST CHANGE TYPE
      *
     C                   MOVE      'R'           CHTP
      *
      ** SET RECORD ID
      *
     C                   MOVE      'R'           RECI
      *
      ** REWRITE RECORD
      *
     C                   UPDATE    DEALSDBF                             60
      *
     C     *IN60         IFEQ      '1'                                          B*1
     C                   MOVE      '005'         DBASE                           *1
     C                   MOVE      'DEALSDB'     DBFILE                          *1
     C                   MOVE      '1'           *INU7                          *1
     C                   MOVE      '1'           *INU8                          *1
     C                   DUMP                                                   *1             AB020
     C                   END                                                    E*1
      *
      *
     C     #BD9          ENDSR                                                  **#BD9**
      /EJECT
      *****************************************************************
      *****                                                           *   AB0102
      *****BROUTINE: #BE    -     WRITE A TRAILER RECORD TO THE       *   AB0102
      *****                       PF/DEALSDF, RECORD FORMAT DEALSDFF  *   AB0102
      *****                       FOR A REVERSAL                          AB0102
      *****                                                               AB0102
      *****                                                           *   AB0102
      *****ELDS USED:                                                 *   AB0102
      *****                  #ZB  - DATABASE NAME                   *     AB0102
      *****                  NDEL   - NO OF DELETED RECORDS           *   AB0102
      *****                  NLRA   - NO OF RECS AFTER CYCLE          *   AB0102
      *****                  RUND   - MIDAS RUN DATE                  *   AB0102
      *****                  JUNDAT - NEAR DATE                       *   AB0102
      *****                  @AMT   - PURCHASE AMOUNTS                *   AB0102
      *****                  WSAMNP - }                               *   AB0102
      *****                  @HINT  - } WORK FIELDS TO SEPARATE       *   AB0102
      *****                  @HDEC  - } DECIMAL / INTEGERS            *   AB0102
      *****                  VRDF   - VAL REC DELETED INT             *   AB0102
      *****                  VRDL   - VAL REC DELETED DEC             *   AB0102
      *****                  VLAF   - VAL REC AFTER CYCLE INT         *   AB0102
      *****                  VLAL   - VAL REC AFTER CYCLE DEC         *   AB0102
      *****                  LCD    - LAST CHANGE DATE                *   AB0102
      *****                  CHTP   - LAST CHANGE TYPE                *   AB0102
      *****                                                           *   AB0102
      *****                                                           *   AB0102
      *****LLED BY :  #B                                                  AB0102
      *****LLS     :  #ZA #ZB                                             AB0102
      *****                                                           *   AB0102
      *****                                                           *   AB0102
      *****************************************************************   AB0102
      *****                                                               AB0102
     C*****      #BE       BEGSR                                          AB0102
      *****                                                               AB0102
      *****CESS TRAILER RECORD                                            AB0102
      *****                                                               AB0102
     C*****      999999    CHAINDEALSDFF             60                   AB0102
      *****                                                               AB0102
     C*****      *IN60     IFEQ '1'                        B1             AB0102
     C*****                MOVE '006'     DBASE            *1             AB0102
     C*****                MOVE 'DEALSDF' DBFILE           *1             AB0102
     C*****                MOVE '1'       *INU7            *1             AB0102
     C*****                MOVE '1'       *INU8            *1             AB0102
     C*****                GOTO #BE9                       *1             AB0102
     C*****                END                             E1             AB0102
      *****                                                               AB0102
      *****CREMENT NO OF DELETIONS BY 2 IF NEAR DATE IS >= MIDAS RUN      AB0102
      *****TE OTHERWISE INCREMENT NO OF DELETIONS BY 1                    AB0102
      *****                                                               AB0102
     C*****      RUND      IFLT JUNDAT                     B1             AB0102
     C*****                ADD  2         NDEL             *1             AB0102
     C*****                ELSE                            X1             AB0102
     C*****                ADD  1         NDEL             *1             AB0102
     C*****                END                             E1             AB0102
      *****                                                               AB0102
      *****CREMENT NO OF LIVE RECORDS BY 2 IF NEAR DATE IS >= MIDAS RUN   AB0102
      *****TE OTHERWISE DECREMENT NO OF LIVE RECORDS BY 1                 AB0102
      *****                                                               AB0102
     C*****      RUND      IFLT JUNDAT                     B1             AB0102
     C*****                SUB  2         NLRA             *1             AB0102
     C*****                ELSE                            X1             AB0102
     C*****                SUB  1         NLRA             *1             AB0102
     C*****                END                             E1             AB0102
      *****                                                               AB0102
      ***** NEAR DATE IS >= MIDAS RUN                                     AB0102
      *****NCREMENT VALUE OF RECORD DELETED (INTEGER AND DECIMAL) BY      AB0102
      *****HE SUM OF PURCHASE AMOUNTS FROM THE FIRST AND SECOND LEGS      AB0102
      *****TORED IN @SUM,SEPARATE DECIMAL POINTS AND CALL SUBROUTINE      AB0102
      *****ZA                                                             AB0102
      *****SE INCREMENT VALUE OF RECORD DELETED (INTEGER AND DECIMAL)     AB0102
      *****Y THE PURCHASE AMOUNT OF THE SECOND LEG ONLY                   AB0102
      *****                                                               AB0102
     C*****      RUND      IFLT JUNDAT                     B1             AB0102
      *****                                                               AB0102
      *****                                                               AB0102
     C*****                MOVE @SUM      @SPLIT                          AB0102
     C*****      @DEC      IFLT 0                          B*2            AB0102
     C*****                Z-SUB@INT      @INT             **2            AB0102
     C*****                END                             E*2            AB0102
      *****                                                               AB0102
     C*****                Z-ADDVRDF      @HINT            *1             AB0102
     C*****                Z-ADDVRDL      @HDEC            *1             AB0102
     C*****                EXSR #ZA                        *1             AB0102
     C*****                Z-ADD@HINT     VRDF             *1             AB0102
     C*****                Z-ADD@HDEC     VRDL             *1             AB0102
      *****                                                               AB0102
     C*****                ELSE                            X1             AB0102
      *****                                                               AB0102
      *****                                                               AB0102
     C*****                MOVE @AMT      @SPLIT                          AB0102
     C*****      @DEC      IFLT 0                          B*2            AB0102
     C*****                Z-SUB@INT      @INT             **2            AB0102
     C*****                END                             E*2            AB0102
      *****                                                               AB0102
     C*****                Z-ADDVRDF      @HINT            *1             AB0102
     C*****                Z-ADDVRDL      @HDEC            *1             AB0102
     C*****                EXSR #ZA                        *1             AB0102
     C*****                Z-ADD@HINT     VRDF             *1             AB0102
     C*****                Z-ADD@HDEC     VRDL             *1             AB0102
      *****                                                               AB0102
     C*****                END                             E1             AB0102
      *****                                                               AB0102
      ***** NEAR DATE IS >= MIDAS RUN                                     AB0102
      *****ECREMENT VALUE OF RECORD AFTER I/C (INTEGER AND DECIMAL) BY    AB0102
      *****HE SUM OF PURCHASE AMOUNTS FROM THE FIRST AND SECOND LEGS      AB0102
      *****TORED IN @SUM,SEPARATE DECIMAL POINTS AND CALL SUBROUTINE      AB0102
      *****ZA                                                             AB0102
      *****SE DECREMENT VALUE OF RECORD AFTER I/C (INTEGER AND DECIMAL)   AB0102
      *****Y THE PURCHASE AMOUNT OF THE SECOND LEG ONLY                   AB0102
      *****                                                               AB0102
     C*****      RUND      IFLT JUNDAT                     B1             AB0102
      *****                                                               AB0102
      *****                                                               AB0102
     C*****                MOVE @SUM      @SPLIT                          AB0102
     C*****      @DEC      IFLT 0                          B*2            AB0102
     C*****                Z-SUB@INT      @INT             **2            AB0102
     C*****                END                             E*2            AB0102
      *****                                                               AB0102
     C*****                Z-ADDVLAF      @HINT            *1             AB0102
     C*****                Z-ADDVLAL      @HDEC            *1             AB0102
     C*****                EXSR #ZB                        *1             AB0102
     C*****                SUB  @HINT     VLAF             *1             AB0102
     C*****                SUB  @HDEC     VLAL             *1             AB0102
      *****                                                               AB0102
     C*****                ELSE                            X1             AB0102
      *****                                                               AB0102
      *****                                                               AB0102
     C*****                MOVE @AMT      @SPLIT                          AB0102
     C*****      @DEC      IFLT 0                          B*2            AB0102
     C*****                Z-SUB@INT      @INT             **2            AB0102
     C*****                END                             E*2            AB0102
      *****                                                               AB0102
     C*****                Z-ADDVLAF      @HINT            *1             AB0102
     C*****                Z-ADDVLAL      @HDEC            *1             AB0102
     C*****                EXSR #ZB                        *1             AB0102
     C*****                SUB  @HINT     VLAF             *1             AB0102
     C*****                SUB  @HDEC     VLAL             *1             AB0102
      *****                                                               AB0102
     C*****                END                             E1             AB0102
      *****                                                               AB0102
      *****T LAST CHANGE DATE TO MIDAS RUN DATE FROM TABTB10              AB0102
      *****                                                               AB0102
     C*****                Z-ADDRUND      LCD                             AB0102
      *****                                                               AB0102
      *****ST CHANGE TYPE                                                 AB0102
      *****                                                               AB0102
     C*****                MOVE 'R'       CHTP                            AB0102
      *****                                                               AB0102
      ***** RITE RECORD                                                   AB0102
      *****                                                               AB0102
     C*****                UPDATDEALSDFF               60                 AB0102
      *****                                                               AB0102
     C*****      *IN60     IFEQ '1'                        B1             AB0102
     C*****                MOVE '012'     DBASE            *1             AB0102
     C*****                MOVE 'DEALSDF' DBFILE           *1             AB0102
     C*****                MOVE '1'       *INU7            *1             AB0102
     C*****                MOVE '1'       *INU8            *1             AB0102
     C*****                END                             E1             AB0102
      *****                                                               AB0102
      *****                                                               AB0102
     C*****      #BE9      ENDSR                           **#BE9**       AB0102
      /EJECT
      *****************************************************************
      *  SUBROUTINE: #C     - Main Processing 2
      *                                                               *
      *  THIS ROUTINE WRITES TWO RECORDS TO THE PF/DTRIXDD ,RECORD
      *  FORMAT DTRIXDF FOR LEGS 1 AND 2
      *
      *  FIELDS USED:        @LEG - 1ST/2CD LEG INDICATOR             *
      *                                                               *
      *                                                               *
      *  CALLED BY : MAIN PROGRAM                                     *
      *  CALLS     :  #CA
      *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     #C            BEGSR
      *
     C                   Z-ADD     1             @LEG
      *
     C                   EXSR      #CA
      *
     C                   ADD       1             @LEG
      *
     C                   EXSR      #CA
      *
     C     #C9           ENDSR                                                  **#B9**
      /EJECT
      *****************************************************************
      *  SUBROUTINE: #CA    -
      *                                                               *
      *  THIS ROUTINE WRITES TWO RECORDS TO THE PF/DTRIXDD ,RECORD
      *  FORMAT DTRIXDF FOR LEGS 1 AND 2
      *
      *  FIELDS USED:        RECI   -  RECORD ID                      *
      *                      RCDT   -  RECORD TYPE                    *
      *                      @LEG   -  1ST /2CD LEG INDICATOR         *
      *                      JUFD38 -  1ST DEAL NO                    *
      *                      DLNO   -  2CD DEAL NO                    *
      *                      JUSD38 -  2CD DEAL NO                    *
      *                      VDAT   -  VALUE DATE                     *
      *                      DASN   -  DEAL AMENDMENT SEQ NO          *
      *                      JUMACT -  MIDAS ACTION TYPE              *
      *                      CHTP   -  LAST CHANGE TYPE               *
      *                      CNRQ   -  CONFIRMATION REQ IND           *
      *                      CNPR   -  CONFIRMATION PRINTED IND       *
      *                      @HMS   -  HOURS,MINS,SECS                *
      *                      @HM    -  HOURS,MINS                     *
      *                      TIM    -  SYSTEM TIME                    *
      *                      DADI   -  DEAL AMENDMENT DEAL INDICATOR  *
      *                      PRT1   -  PAY RECEIVE INDICATORS 1       *
      *                      PRT2   -                         2       *
      *                      PRT3   -                         3       *
      *                      ICIN   -  INTERNAL CONTRACT IND          *
      *                      JUMBCA -  BRANCH CODE                    *
      *                      BRCA   -  BRANCH CODE                    *
      *                                                               *
      *                                                               *
      *  CALLED BY : #C                                               *
      *  CALLS     :
      *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     #CA           BEGSR
      *
      ** ZERO TRANSACTION NO OF LAST UPDATE
      *
     C                   Z-ADD     *ZEROS        TNLU
      *
      ** RECORD ID
      *
     C                   MOVE      'D'           RECI
      *
      ** RECORD TYPE
      *
     C                   MOVE      'D'           RCDT
      *
      ** DEAL NUMBER
      *
     C     @LEG          IFEQ      1                                            B1
      *
     C                   Z-ADD     JUFD38        DLNO                           *1
     C                   ELSE                                                   X1
      *
     C                   Z-ADD     JUSD38        DLNO                           *1
      *
     C                   END                                                    E1
      *
      ** VALUE DATE
      *
     C                   Z-ADD     *ZEROS        VDAT
      *
      ** DEAL AMENDMENT SEQUENCE NUMBER
      *
     C                   Z-ADD     *ZEROS        DASN
      *
      ** CHANGE TYPE / ACTION CODE
      *
     C                   MOVE      JUMACT        CHTP
      *
      ** CONFIRMATION REQUIRED INDICATOR
      *
     C                   MOVE      'Y'           CNRQ
      *
      ** CONFIRMATION PRINTED INDICATOR
      *
     C                   MOVE      'N'           CNPR
      *
      ** SYSTEM TIME IN FORMAT HHMM
      *
     C                   TIME                    @HMS              6 0
     C                   MOVEL     @HMS          TIM
      *
      ** DEAL AMENDMENT DELETE INDICATOR
      *
     C                   MOVE      'N'           DADI
      *
      ** PAY RECEIVE INDICATORS 1,2 AND 3
      *
     C                   Z-ADD     *ZERO         PRI1
     C                   Z-ADD     *ZERO         PRI2
     C                   Z-ADD     *ZERO         PRI3
      *
      ** INTERNAL CONTRACT INDICATOR
      *
     C                   Z-ADD     1             ICIN
      *
      ** BRANCH CODE
      *
     C*********************Z-ADDJUMBCD    BRCD                            S01117
     C                   MOVE      JUMBCA        BRCA                                          S0111
      *
      ** WRITE RECORD ON PF/DTRIXDD  FORMAT DTRIXDF
      *
     C                   WRITE     DTRIXDF                              60
      *
     C     *IN60         IFEQ      '1'                                           B1
     C                   MOVE      '013'         DBASE                           *1
     C                   MOVE      'SDTIX'       DBFILE
     C                   MOVE      '1'           *INU7                           *1
     C                   MOVE      '1'           *INU8                           *1
     C                   DUMP                                                   *1             AB020
     C                   END                                                     E1
      *
     C     #CA9          ENDSR                                                  **#CA9**
      /EJECT
      *****************************************************************
      *****                                                           *   AB0102
      *****    SR.#ZA - ADD AMOUNT TO HASH TRAILER                    *   AB0102
      *****                                                           *   AB0102
      *****    @HINT - CURRENT HASH INTEGER (15,0)                    *   AB0102
      *****    @HDEC - CURRENT HASH DECIMAL (3,0)                     *   AB0102
      *****    @INT  - INTEGER AMOUNT                                 *   AB0102
      *****    @DEC  - DECIMAL AMOUNT                                 *   AB0102
      *****                                                           *   AB0102
      *****LLED BY :  #BE #BC                                         *   AB0102
      *****                                                               AB0102
      *****************************************************************   AB0102
      *****                                                               AB0102
     C*****      #ZA       BEGSR                                          AB0102
      *****                                                               AB0102
     C*****                ADD  @INT      @HINT  150                      AB0102
      *****                                                               AB0102
     C*****                Z-ADD@HDEC     @WK4N   40                      AB0102
     C*****                ADD  @DEC      @WK4N                           AB0102
      *****                                                               AB0102
     C*****      @WK4N     IFGT 999                                       AB0102
     C*****                ADD  1         @HINT                           AB0102
     C*****                END                                            AB0102
      *****                                                               AB0102
     C*****                Z-ADD@WK4N     @HDEC   30                      AB0102
      *****                                                               AB0102
     C*****                ENDSR                                          AB0102
      *****************************************************************
      /EJECT
      *****************************************************************
      *****                                                           *   AB0102
      *****    SR.#ZB - SUB AMOUNT FROM HASH TRAILER                 *    AB0102
      *****                                                           *   AB0102
      *****    @HINT - CURRENT HASH INTEGER (15,0)                    *   AB0102
      *****    @HDEC - CURRENT HASH DECIMAL (3,0)                     *   AB0102
      *****    @INT  - INTEGER AMOUNT                                 *   AB0102
      *****    @DEC  - DECIMAL AMOUNT                                 *   AB0102
      *****                                                           *   AB0102
      *****                                                           *   AB0102
      *****LLED BY :  #BE                                             *   AB0102
      *****                                                               AB0102
      *****************************************************************   AB0102
      *****                                                               AB0102
     C*****      #ZB       BEGSR                                          AB0102
      *****                                                               AB0102
     C*****                SUB  @INT      @HINT                           AB0102
      *****                                                               AB0102
     C*****                Z-ADD@HDEC     @WK3N   30                      AB0102
     C*****                ADD  @DEC      @WK3N                           AB0102
      *****                                                               AB0102
     C*****      @WK3N     IFLT 0                                         AB0102
     C*****                SUB  1         @HINT                           AB0102
     C*****      @WK3N     ADD  1000      @WK4N                           AB0102
     C*****                Z-ADD@WK4N     @HDEC                           AB0102
     C*****                ELSE                                           AB0102
     C*****                Z-ADD@WK4N     @HDEC                           AB0102
     C*****                END                                            AB0102
      *****                                                               AB0102
      *****                                                               AB0102
     C*****                ENDSR                                          AB0102
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE:  #A  - Initial processing                        *
      *                                                               *
      *  CALLED BY :  MAIN PROGRAM                                    *
      *                                                               *
      *  CALLS     :
      *                                                               *
      *  FIELDS USED :-
      *                      @TERM  -  INPUT PARAMETER                *
      *                      @DEAL  -  INPUT PARAMETER (ABSTDDLL)     *
      *                      @ONCE  -  1ST ENTRY INDICATOR            *
      *                      @LEG   -  1ST/2CD LEG INDICATOR          *
      *                      @KEY2  -  TABTB10 KEY                    *
      *                      #ZB  -  DATABASE NAME                  *
      *****************************************************************
      *
     C     #A            BEGSR
      *
      ** Non-executable code.
     C     *ENTRY        PLIST
     C                   PARM                    @TERM             1
     C                   PARM                    @DEAL
      *
      ** LF/SDTIX is read in for update to open file for later pgm        AB0076
      ** (AB0230) so must have dummy read to get it to compile            AB0076
     C     '1'           IFEQ      '2'                                          B1             AB007
     C                   READ      SDTIX                                  60    *1             AB007
     C                   END                                                    E1             AB007
      *
      *
     C     @TERM         IFEQ      'T'                                          B*1
     C                   MOVE      '1'           *INLR                           *1
     C                   GOTO      #A9                                           *1
     C                   END                                                    E*1
      *
      *
      **  Open files.
     C     @ONCE         IFNE      'Y'                                          B1
      **  Test if deals file not already opened                           AB0102
     C*****@DLOPN********IFEQ      ' '                                          B*2      AB010CAP084
     C     @DLOPN        IFEQ      '0'                                          B*2           CAP084
      *                                                                   AB0102
     C**********           OPEN DEALS                  60  **2     AB0102 E19709
     C                   OPEN      ABDELULL                             60      **2            E1970
     C     *IN60         IFEQ      '1'                                          B**3           AB010
     C                   MOVE      '007'         DBASE                          ***3           AB010
     C**********           MOVE 'DEALS'   DBFILE           ***3    AB0102 E19709
     C                   MOVE      'ABDELULL'    DBFILE                         ***3           E1970
     C                   MOVE      '1'           *INU7                          ***3           AB010
     C                   MOVE      '1'           *INU8                          ***3           AB010
     C                   DUMP                                                   ***3           AB020
     C                   GOTO      #A9                                          ***3           AB010
     C                   END                                                    E**3           AB010
     C                   END                                                    E*2            AB010
      *
      **  Test if file not already opened                                       CAP084
     C                   OPEN      SDTIX                                60      *1
     C     *IN60         IFEQ      '1'                                          B*2
     C                   MOVE      '008'         DBASE                          **2
     C                   MOVE      'SDTIX'       DBFILE                         **2
     C                   MOVE      '1'           *INU7                          **2
     C                   MOVE      '1'           *INU8                          **2
     C                   DUMP                                                   **2            AB020
     C                   GOTO      #A9                                          **2
     C                   END                                                    E*2
      *
      ****Test*if*FDICDRLL*not already opened                             S01194
     C***********@ICOPN****IFEQ ' '                        B*2            S01194
      *********************                                               S01194
     C*********************OPEN FDICDRLL               60  **2            S01194
     C********** *IN60*****IFEQ '1'                        B**3           S01194
     C*********************MOVE '009'     DBASE            ***3           S01194
     C*********************MOVE 'FDICDRLL'DBFILE           ***3           S01194
     C*********************MOVE '1'       *INU7            ***3           S01194
     C*********************MOVE '1'       *INU8            ***3           S01194
     C*********************DUMP                            ***3           S01194
     C*********************GOTO #A9                        ***3           S01194
     C*********************END                             E**3           S01194
      *********************                                               S01194
     C*********************END                             E*2            S01194
      ****Read*the*TABTB10*record                                         S01194
      *********************                                               S01194
     C*********************MOVEL'01'      @KEY2  12        *1             AB0102
     C*********************MOVE '10'      @KEY2            *1             AB0102
     C***********@KEY2*****CHAINFDICDRLL             60                   AB0102
     C********** *IN60*****IFEQ '1'                        B*2            AB0102
      *                                                                   AB0102
      ** Call AOSARDR0 to check if CDL099 is switched on                                      CDL099
      *                                                                                       CDL099
     C                   EVAL      CDL099 = 'N'                                               CDL099
     C                   CALLB     'AOSARDR0'                                                 CDL099
     C                   PARM      *BLANKS       PRTCD             7                          CDL099
     C                   PARM      '*VERIFY'     POPTN             7                          CDL099
     C                   PARM      'CDL099'      PSARD             6                          CDL099
     C                   PARM                    DSFDY                                        CDL099
      *                                                                                       CDL099
     C                   IF        PRTCD = *BLANKS                                            CDL099
     C                   MOVE      'Y'           CDL099            1                          CDL099
     C                   ENDIF                                                                CDL099
     C                   IF        PRTCD <> *BLANKS AND                                       CDL099
     C                             PRTCD <> '*NRF   '                                         CDL099
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL099
     C                   EVAL      DBASE = '011'                                              CDL099
     C                   EVAL      DBKEY = 'CDL099'                                           CDL099
     C                   MOVE      '1'           *INU7                                        CDL099
     C                   MOVE      '1'           *INU8                                        CDL099
     C                   DUMP                                                                 CDL099
     C                   GOTO      #A9                                                        CDL099
     C                   ENDIF                                                                CDL099
      *                                                                                       CDL099
     C                   CALL      'AOBANKR0'                                                  S0119
     C                   PARM      *BLANKS       @RTCD             7                           S0119
     C                   PARM      '*FIRST '     @OPTN             7                           S0119
     C     SDBANK        PARM      SDBANK        DSFDY                                         S0119
     C     @RTCD         IFNE      *BLANKS                                                     S0119
     C                   MOVEL     @OPTN         DBOPTN            7                           S0119
     C*********************MOVE @KEY2     DBKEY            **2            AB0102
     C*********************MOVE 'FDICDRLL'DBFILE           **2            AB0102
     C                   MOVEL     'SDBANKPD'    DBFILE                                        S0119
     C                   MOVE      '010'         DBASE                          **2            AB010
     C                   MOVE      '1'           *INU7                          **2            AB010
     C                   MOVE      '1'           *INU8                          **2            AB010
     C                   DUMP                                                   **2            AB020
     C                   GOTO      #A9                                          **2            AB010
     C                   END                                                    E*2            AB010
      *                                                                   AB0102
     C*
     C                   MOVE      'Y'           @ONCE             1            *1
     C                   END                                                    E1
      *
      **  SET UP FIRST LEG INDICATOR
      *
     C                   Z-ADD     1             @LEG              1 0
      *
     C     #A9           ENDSR                                                  **#A9**
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE: #D     - Terminates program.                     *
      *                                                               *
      *  FIELDS USED:                                                 *
      *                                                               *
      *  CALLED BY : Main processing                                  *
      *
      *  CALLS     : NONE                                             *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     #D            BEGSR
      *
      **  If a database error has occured, move program name into local
      **  data area, inform calling program, and seton LR.
      *
     C     *INU7         IFEQ      '1'                                          B1
     C                   MOVEL     'AB0240'      DBPGM                          *1
     C                   MOVE      '1'           *INLR                          *1
     C                   MOVE      'E'           @TERM                          *1
     C                   DUMP                                                   *1             AB020
     C                   END                                                    E1
      *
     C                   RETURN
      *
     C     #D9           ENDSR                                                  **#D9**
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE: *INFSR -- File Error handling subroutine.        *
      *                                                               *
      *  FIELDS USED:                                                 *
      *                                                               *
      *  CALLED BY : This routine is called if there are any          *
      *                file errors.                                   *
      *
      *  CALLS :                                                      *
      *                                                               *
      *****************************************************************
      *
     C     INFSR         BEGSR
      *
      ** Set @ERR2 to 'Y' to prevent looping if further errors.
     C     @ERR2         IFNE      'Y'                                          B1
     C                   MOVE      'Y'           @ERR2             1            *1
      *
     C                   MOVE      '1'           *INU7                          *1
     C                   MOVE      '1'           *INU8                          *1
      *
      ** Terminate the program,setting up LDA & producing a dump.
     C                   MOVE      '1'           *INLR                           *1
     C                   MOVE      'E'           @TERM                           *1
     C                   MOVE      @FILE         DBFILE                          *1
     C                   MOVEL     'AB0240'      DBPGM                           *1
     C                   MOVE      '992'         DBASE                           *1
      *
     C                   DUMP                                                    *1
     C                   END                                                    E*1
      *
     C                   RETURN
      *
     C     INFSR9        ENDSR                                                   ***INFSR9*
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE: *PSSR - Error handling subroutine.               *
      *                                                               *
      *  FIELDS USED:                                                 *
      *                                                               *
      *  CALLED BY : This routine is called if there are any program  *
      *                errors.                                        *
      *  CALLS :                                                      *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      **  Set @ERR1 to 'Y' to prevent looping if further errors.
     C     @ERR1         IFNE      'Y'                                          B*1
     C                   MOVE      'Y'           @ERR1             1             *1
      *
     C                   MOVEL     'AB0240'      DBPGM                           *1
     C                   MOVE      '1'           *INU6                           *1
     C                   MOVE      '991'         DBASE                           *1
      *
     C                   DUMP                                                    *1
     C                   MOVE      'E'           @TERM                           *1
     C                   END                                                    E*1
      *
     C                   MOVE      '1'           *INLR
      *
     C                   RETURN
      *
     C     #PSSR9        ENDSR                                                   ***PSSR9**
      *
      *****************************************************************
      *
**CTDATA CPY@
(c) Finastra International Limited 2001
