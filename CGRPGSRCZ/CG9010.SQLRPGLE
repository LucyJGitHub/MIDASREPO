     H DEBUG
     H CVTOPT (*GRAPHIC)                                                                    MD054955
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/**** *  RPGBNOCVT                                                    *              CSD053 MD054955
/**** *  RPGCVTOPT1                                                   *              CSD053 MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG Create item reference records')
/*OVRF*: OVRDBF FILE(EXUDCRPD) TOFILE(CGUDCRPD)                     : *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG9010 - Create item reference records                       *
      *                                                               *
      *  Function:  This program creates UDC item reference records   *
      *             for primary and secondary recipients, and passes  *
      *             back the generated item identifier to the         *
      *             calling extract program.                          *
      *                                                               *
      *             It runs in two modes:                             *
      *              *GEN - generate reference records                *
      *              *REF - verify whether a record would be          *
      *                     generated - but don't generate            *
      *                                                               *
      *  Called By: All UDC extract processes                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD054955           Date 16Dec19               *
      *  Prev Amend No. MD054011           Date 19Aug19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD043920           Date 02Feb17               *
      *                 MD043686           Date 20Jan17               *
      *                 MD043637           Date 20Jan17               *
      *                 CCG024             Date 29Sep16               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD053             Date 01Jun06               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 107390             Date 09Apr97               *
      *                 S01408             Date 19Aug96               *
      *                 CCG004             DATE 01JUN95               *
      *                 087834             DATE 15MAY95               *
      *                 087831             DATE 05MAY95               *
      *                 087283             DATE 03MAY95               *
      *                 084316             DATE 21FEB95               *
      *                 082705             DATE 21FEB95               *
      *                 080068             DATE 09DEC94               *
      *                 079997             DATE 18DEC94               *
      *                 079847             DATE 07DEC94               *
      *                 S01522             DATE 22NOV94               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD054011 - SEC0304 in MSGW. Fix is replace LF/CLINT which    *
      *             only use recordformat CLINTSEF within the program.*
      *             New LF will be introduced to replace LF/CLINT.    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD043920 - Customer Lending default Address Ref to 'B'.      *
      *             Change program to ignore it.                      *
      *  MD043686 - Use retail number instead if account is not found *
      *  MD043637 - Type BUY_SELL was overlooked.                     *
      *  CCG024 - Use Atlernate Name and Address in Correspondence    *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  107390 - Advices are being created although there are no     *
      *           schedules set up for them.                          *
      *  S01408 - Core Hook CG9010CCP3 Added
      *         - Core Hook CG9010CCP2 Added
      *         - Core Hook CG9010CCP1 Added
      *  CCG004 - Add processing for Copy user                        *
      *  087834 - Only one copy coming out, regardless of             *
      *           correspondent schedule set up.                      *
      *  087831 - Secondary items sent to correspondent type          *
      *           correspondent, not secondary destination.           *
      *  087283 - Use arrays and occur data structures to reduce acces*
      *  084316 - Use L1 logical files to exclude deleted records     *
      *  082705 - Add correspondent type level default                *
      *  080068 - Incorrect defaulting for branch/account code        *
      *  079997 - Inconsistent formatting of account id.              *
      *  079847 - System level defaults corrupted if already accessed *
      *           and program runs a second time without closing down *
      *  S01522 - User Defined Correspondence                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *                                                               *
      *  01   -    XX                                                 *
      *  50   -    NrF, LF/CGCORRLn Correspondent details             *
      *  51   -    NrF, LF/CGCSCHLn Correspondent schedule            *
      *  52   -    NrF, LF/CGPSCHL0 Schedule details                  *
      *  55   -    Work                                               *
      *                                                               *
      *****************************************************************
      *
     F*GCORRL0IF  E           K        DISK                               084316
     FCGCORRL1  IF   E           K DISK                                         084316
     F                                     INFSR(SRFILE)
     FCGCORRL2  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FCGCORRL3  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FCGCORRL4  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FCGCORRLC  IF   E           K DISK                                         082705
     F                                     INFSR(SRFILE)                        082705
     F*GCSCHL2IF  E           K        DISK                               080068            MD054955
     F********************************************* KINFSR SRFILE         080068            MD054955
     F*CGCSCHL9* IF   E           K DISK                                         080068     MD054955
     F**********                           INFSR(SRFILE)                        080068      MD054955
     F*CGCSCHL3* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
     F*CGCSCHL5* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
     F*CGCSCHL2* IF   E           K DISK                                         087283     MD054955
     F**********                           INFSR(SRFILE)                        087283      MD054955
     F*GPSCHL0IF  E           K        DISK                               084316
     FCGPSCHL1  IF   E           K DISK                                         084316
     F                                     INFSR(SRFILE)
     FCGUDCRL0  IF   E           K DISK                                         082705
     F                                     INFSR(SRFILE)                        082705
     FCGUDCRPD  O    E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     COMMIT
     FEXUDCRPD  O    E           K DISK    USROPN
     F                                     RENAME(@UDCRPD:@UDCRPDX)
     F                                     INFSR(SRFILE)
     FACCNT     IF   E           K DISK    INFSR(SRFILE)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
     FCLOAN     IF   E           K DISK    INFSR(SRFILE)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     F***CLINT** IF  E           K        DISK         KINFSR SRFILE                 CCG024 MD054011
     F**********  CLINTCAF                          KIGNORE                          CCG024 MD054011
     F**********  CLINTCBF                          KIGNORE                          CCG024 MD054011
     F**********  CLINTCCF                          KIGNORE                          CCG024 MD054011
     F**********  CLINTC1F                          KIGNORE                          CCG024 MD054011
     FCLINTSL0  IF   E           K DISK    INFSR(SRFILE)                                          MD
     FACCNTL1   IF   E           K DISK    INFSR(SRFILE)                                          MD
     F                                     RENAME(ACCNTABF:RETAILF)                               MD
      /EJECT
      ** Copyright statement
      *
     D TAB1            S             10    DIM(2) CTDATA PERRCD(1)
     D TAB2            S              4    DIM(2) ALT(TAB1)
      ** Table of print schedules against item statuses
      *
     D #SCSQ           S              4    DIM(4) CTDATA PERRCD(1)                               080
      ** Search criteria - 1                                              080068
      *                                                                   080068
     D #SCLT           S              1    DIM(4)                                                080
      ** Search criteria - 2                                              080068
      *                                                                   080068
     D #CUS            S              6    DIM(20)                                               087
      ** Store of last twenty customers                                   087283
      *                                                                   087283
     D #COR            S             10    DIM(20)                                               087
      ** Store of last twenty correspondents                              087283
      *                                                                   087283
     D #PSC            S              6    DIM(10)                                               087
      ** Store of last ten print schedules                                087283
      *                                                                   087283
     D #BRC            S              3    DIM(10)                                               087
      ** Store of last ten branches                                       087283
      *                                                                   087283
     D #CTY            S             10    DIM(20)                                               087
      ** Store of last twenty correspondent types                         087283
      *                                                                   087283
      ** Store alternate address ref                                                          CCG024
     D #ADD            S              1    DIM(10)
      *                                                                                       CCG024
      *COPY*CGCPYSRC,SRERRE                                                                 MD054955
      /COPY CGCPYSRC,SRERRDLE                                                               MD054955
      /EJECT
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      ** Copyright statement
      *
     D*#DEFT***** DS                          6                           082705
     D D#DEFT          DS                  OCCURS(8)                            082705
     D  D#PRTD                 1      5  0
     D  D#RETP                 6     10  0
     D  D#LGID                11     12
     D  D#PSCH                13     18
     D  D#OVBR                19     21
     D  D#APDF                22     22
      ** Multiple occurrence data structure used to hold print schedule
      ** information for system, branch and entity
      *
     D                 DS
     D  ##ITMA                 1      8
     D  ##ITMN                 1      8  0
      ** Used to convert item reference from character to numeric
      *
     D                 DS                                                       079997
     D**********                              1  18 ##MACT                                    CGL029
     D  ##MACT                 1     24
     D************************************** 13  16 ##ACOD                079997
     D**********                             10  13 ##ACOD                             079997 CGL029
     D  ##ACOD                10     19
      ***Used*to extract account code from account id                     079997
      *
     D #KEY9D          DS                                                       080068
     D  ##PTYP                 1     10                                         080068
     D  ##PSTP                11     20                                         080068
     D**********                             21  24 ##ACCD                             080068 CGL029
     D**********                             25  42 K#MACT                             080068 CGL029
     D  ##ACCD                21     30
     D  K#MACT                31     54
      ** Key for schedule details                                         080068
      *
     D ##UDCR        E DS                  EXTNAME(CGUDCRPD)
      ** External DS for incomplete reference
     D  ##CNUM               180    185
     D  ##CCY                186    188
     D  ##ACO                189    198  0
     D  ##ACSQ               199    200  0
     D  ##BRCA               201    203
     D  ##ACNO               180    189  0                                                        MD
     D AD              DS
     D  AD1                    1      8
     D  AD2                    9     10
      *
     D CGDATA        E DS                  EXTNAME(CGDTA)
      ** Data Area for UDC (used for next item identifier)
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      ** Data Area for run-date
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CCG004
      **  Sar Text details                                                CCG004
      *                                                                   CCG004
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CCG004
      **  Data Structure used by Access Programs                          CCG004
      *                                                                   CCG004
     D CGCORR        E DS                  EXTNAME(CGCORRPD)                    087283
      ** External DS for Correspondent Details                            087283
      *                                                                   087283
     D***CSTORE*      DS                         71 800                                087283 CSD053
     D**********                                800 800 ##NFC                          087283 CSD053
     D CSTORE          DS          1273    OCCURS(71)
     D  ##NFC               1273   1273
      ** Occur data structure for stored reads                            087283
      *                                                                   087283
     D CGPSCH        E DS                  EXTNAME(CGPSCHPD)                    087283
      ** External DS for Correspondent Details                            087283
      *                                                                   087283
     D PSTORE          DS           256    OCCURS(10)                           087283
     D  ##NFP                256    256                                         087283
      ** Occur data structure for stored reads                            087283
      *                                                                   087283
      * System Value                                                                          CCG024
     D                 DS
     D  SVALK1                 1     20    INZ('RecipientSpecialChar')
      *                                                                                       CCG024
     D C#STMT          C                   CONST('STATEMENT ')
     D C#LOCM          C                   CONST('LOAN COMMC')
     D C#LORP          C                   CONST('LOAN REPAY')
     D C#LORL          C                   CONST('LOAN ROLLO')
     D C#LOFE          C                   CONST('LOAN FEE')
     D C#LOIT          C                   CONST('LOAN INTER')
     D C#LORT          C                   CONST('LOAN RATCH')
     D C#LOPD          C                   CONST('LOAN PSTDU')
     D C#RECX          C                   CONST('CURR_EXCHG')
     D C#REDL          C                   CONST('DEALINGGEN')
     D C#READ          C                   CONST('RETAILADVS')
     D C#REIC          C                   CONST('INT_CAP')
     D C#RELE          C                   CONST('LENDINGGEN')
     D C#RERC          C                   CONST('RATE_CHG')
     D C#RESO          C                   CONST('STAND_ORDR')
     D C#RETC          C                   CONST('TRN_CHRG')
     D C#REAG          C                   CONST('RTL_ADVG')
     D C#RETL          C                   CONST('RETAIL')
     D C#SEAD          C                   CONST('SEC_ADV_CF')
     D C#SEPO          C                   CONST('SEC_POS_CF')
     D C#SEBS          C                   CONST('BUY_SELL')                                      MD
     D CGCSCH        E DS                  EXTNAME(CGCSHJW0)                                MD054955
      *COPY*CGCPYSRC,SRERRI                                                                 MD054955
      /EJECT
      *****************************************************************
      *                                                               *
      *   Index to subroutines                                        *
      *   --------------------                                        *
      *                                                               *
      *   SRINIT - Initial processing                                 *
      *   SRPRIM - Processing for primary recipient                   *
      *   SRSECO - Processing for secondary recipient(s)              *
      *   SRPRSC - Create reference records for secondaries           *
      *   SRDETL - Derive details for correspondent                   *
      *   SRDEFT - Derive schedule details for system/branch/entity   *
      *   SRIDGN - Generate next item reference number                *
      *                                                               *
      *****************************************************************
      /EJECT
     C     *ENTRY        PLIST
      *
      ** Return code
     C                   PARM                    W0MSGD
      *
      ** Input: mode, commitment control indicator, primary customer
      ** incomplete UDC reference record
     C                   PARM                    ##MODE           10
     C                   PARM                    ##CMT             3
     C                   PARM                    ##CUST            6
     C                   PARM                    ##UDCR
      *
      ** Output: generated item reference (alpha format)
     C                   PARM                    ##ITEM            8
      *
      ** Initial processing; only perform once per job
     C     RUNDTA        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   END
      *
      ** Initialise generate_item indication and item_id_generated
      ** indication
     C                   MOVEL     'N'           ##GENI            1
     C                   MOVEL     'N'           ##IDGN            1
     C*                                                                   S01408
     C/COPY WNCPYSRC,CG9010CCP1                                           S01408
     C*                                                                   S01408
      *                                                                   084316
      ** Ensure correspondent exists for this customer before going any   084316
      ** further - return 'NOCR' in status to indicate no correspondent   084316
      *                                                                   087283
      * Look up customer in array                                         087283
      *                                                                   087283
     C                   Z-ADD     1             X                 5 0                         08728
     C     ##CUST        LOOKUP    #CUS(X)                                90                   08728
      *                                                                   087283
      * If found access details from CSTORE                               087283
      *                                                                   087283
     C     *IN90         IFEQ      '1'                                                         08728
     C     X             ADD       31            X                                             08728
     C     X             OCCUR     CSTORE                                                      08728
      *                                                                   087283
      * If record found move to CGCORRPD set 50 off else set 50 on        087283
      *                                                                   087283
     C     ##NFC         IFNE      'Y'                                                         08728
     C                   SETOFF                                       50                       08728
     C                   MOVEL     CSTORE        CGCORR                                        08728
     C                   ELSE                                                                  08728
     C                   SETON                                        50                       08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
      * Customer not in store so chain to find details                    087283
      *                                                                   087283
     C                   ELSE                                                                  08728
     C     ##CUST        CHAIN     CGCORRL4                           50                       08431
      *                                                                   087283
      * Set up new off set, move contents into array                      087283
      *                                                                   087283
     C                   ADD       1             ##COFS            5 0                         08728
     C     ##COFS        IFGT      20                                                          08728
     C                   Z-ADD     1             ##COFS                                        08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
     C                   Z-ADD     ##COFS        X                                             08728
     C                   MOVEA     ##CUST        #CUS(X)                                       08728
     C     ##COFS        ADD       31            X                                             08728
     C     X             OCCUR     CSTORE                                                      08728
     C                   MOVEL     *BLANKS       CSTORE                                        08728
      *                                                                   087283
      * If record found move in CGCORRPD else ##NFC to Y                  087283
      *                                                                   087283
     C     *IN50         IFEQ      *OFF                                                        08728
     C                   MOVEL     CGCORR        CSTORE                                        08728
     C                   MOVEL     *BLANKS       ##NFC                                         08728
     C                   ELSE                                                                  08728
     C                   MOVEL     'Y'           ##NFC                                         08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
     C                   ENDIF                                                                 08728
     C     *IN50         IFEQ      '1'                                                         08431
     C                   MOVEL     'N'           ##GENI                                        08431
     C                   MOVEL     'NOCR'        DRISTS                                        08431
     C                   ELSE                                                                  08431
      *
      ** Create record for primary correspondent
     C                   EXSR      SRPRIM
      *
      ** Create records for secondary correspondents
     C                   EXSR      SRSECO
      *                                                                   CCG004
      * If copy user present see if extras needed                         CCG004
      * only do when in generation                                        CCG004
      *                                                                   CCG004
     C     ##CUSR        IFEQ      'Yes'                                                       CCG00
     C     ##MODE        ANDEQ     '*GEN'                                                      CCG00
      *                                                                   CCG004
      ** Create record for Copy correspondent                             CCG004
     C                   EXSR      SRCOPY                                                      CCG00
      *                                                                   CCG004
      ** Create records for secondary Copy correspondents                 CCG004
     C                   EXSR      SRCSEC                                                      CCG00
     C                   ENDIF                                                                 CCG00
      *                                                                   084316
     C                   ENDIF                                                                 08431
      *
      ** Set up parameters for return: msgid blank => all OK, and at
      ** least one reference record generated; msgid CGD1270 => no
      ** error, but no item generated.
     C     ##GENI        IFEQ      'N'
     C                   CLEAR                   ##ITEM
     C                   MOVEL     'CGD1270'     W0MSGD
     C                   ELSE
     C                   CLEAR                   W0MSGD
     C                   ENDIF
      *
      ** Return to calling program (without setting on LR)
     C                   RETURN
      /EJECT
      *****************************************************************
      * Subroutine  :  SRPRIM                                         *
      * Purpose     :  Processing for primary recipient               *
      *                                                               *
      * Called by   :  Main process                                   *
      * Calls       :  SREDTL                                         *
      *                SRIDGN                                         *
      *****************************************************************
      *
     C     SRPRIM        BEGSR
      *
      ** Call SRDETL to obtain details for this customer
     C                   MOVEL     ##CUST        Z#CUST
     C                   CLEAR                   Z#CORR
     C                   CLEAR                   Z#PRIM                                        08006
     C                   EXSR      SRDETL
      *
      ** Store returned correspondent id of primary
     C                   MOVEL     Z#CUID        Z#PRIM
     C     *LIKE         DEFINE    CDCTYP        ##CTYP                                        CCG00
     C                   MOVEL     Z#CTYP        ##CTYP                                        CCG00
      *
      ** Setup details for primary
     C******************** CLEARDRPCOR                                    082705
     C                   MOVEL     Z#PRIM        DRPCOR                                        08270
     C                   MOVEL     Z#PRIM        DRDCOR
     C                   MOVEL     Z#PRTD        DRPRTD
     C                   MOVEL     Z#RETP        DRDDAT
     C                   MOVEL     Z#LGID        DRLGID
     C                   MOVEL     Z#ISTS        DRISTS
     C                   MOVEL     Z#OVBR        DROVBR
     C                   Z-ADD     AGRDNB        DRRDNB
     C                   MOVEL     AGMRDT        DRARDT
     C                   MOVEL     'D'           DRRECI
     C                   MOVEL     'I'           DRAACT
     C                   TIME                    DRATIM
     C                   MOVEL     ##JOB         DRAJOB
     C                   MOVEL     ##USR         DRAUSR
      *
      ** If suppress not indicated, and mode is '*GEN', generate
      ** next sequence number and write reference record
     C     Z#SUPR        IFNE      'Y'
     C                   MOVEL     'Y'           ##GENI
     C     ##MODE        IFEQ      '*GEN'
     C                   EXSR      SRIDGN
     C                   Z-ADD     ##ITMN        DRITEM
      *                                                                   CCG024
     C                   MOVEL     'Y'           TOWRT             1                           CCG02
      ** If CCG024 is on, look for alternate address                      CCG024
     C     CCG024        IFEQ      'Y'                                                         CCG02
     C     ##MODE        ANDEQ     '*GEN'                                                      CCG02
      *                                                                   CCG024
      ** For GL statement                                                 CCG024
     C     DRPTYP        IFEQ      C#STMT                                                      CCG02
     C     KMACT         CHAIN     ACCNTABF                           22                       CCG02
     C     *IN22         IFEQ      '0'                                                         CCG02
     C                   MOVEL     ADREF1        AD1                                           CCG02
     C                   MOVEL     ADREF2        AD2                                           CCG02
     C                   MOVEA     AD            #ADD                                          CCG02
     C                   DO        10            C                 2 0                         CCG02
     C     #ADD(C)       IFNE      *BLANKS                                                     CCG02
     C     #ADD(C)       IFNE      'B'                                                         CCG02
     C     ##CUST        CAT(P)    SVAL1         DRDCOR                                        CCG02
     C                   CAT       #ADD(C):0     DRDCOR                                        CCG02
     C                   ENDIF                                                                 CCG02
     C                   MOVEL     'N'           TOWRT                                         CCG02
     C     ##CMT         IFEQ      'YES'                                                       CCG02
     C                   WRITE     @UDCRPD                                                     CCG02
     C                   ELSE                                                                  CCG02
     C                   WRITE     @UDCRPDX                                                    CCG02
     C                   ENDIF                                                                 CCG02
     C                   ENDIF                                                                 CCG02
     C                   ENDDO                                                                 CCG02
     C                   ENDIF                                                                 CCG02
     C                   ENDIF                                                                 CCG02
      *                                                                   CCG024
      ** For RE advices                                                   CCG024
     C     DRPTYP        IFEQ      C#RECX                                                      CCG02
     C     DRPTYP        OREQ      C#REDL                                                      CCG02
     C     DRPTYP        OREQ      C#READ                                                      CCG02
     C     DRPTYP        OREQ      C#REIC                                                      CCG02
     C     DRPTYP        OREQ      C#RELE                                                      CCG02
     C     DRPTYP        OREQ      C#RERC                                                      CCG02
     C     DRPTYP        OREQ      C#RESO                                                      CCG02
     C     DRPTYP        OREQ      C#RETC                                                      CCG02
     C     DRPTYP        OREQ      C#REAG                                                      CCG02
     C     DRPTYP        OREQ      C#RETL                                                      CCG02
     C     KMACT         CHAIN     ACCNTABF                           22                       CCG02
     C     *IN22         IFEQ      '1'                                                       MD04368
     C     ##ACNO        CHAIN     RETAILF                            22                     MD04368
     C                   ENDIF                                                               MD04368
     C     *IN22         IFEQ      '0'                                                         CCG02
     C                   MOVEL     ADREF1        AD1                                           CCG02
     C                   MOVEL     ADREF2        AD2                                           CCG02
     C                   MOVEA     AD            #ADD                                          CCG02
     C                   DO        10            C                 2 0                         CCG02
     C     #ADD(C)       IFNE      *BLANKS                                                     CCG02
     C     #ADD(C)       IFNE      'B'                                                         CCG02
     C     ##CUST        CAT(P)    SVAL1         DRDCOR                                        CCG02
     C                   CAT       #ADD(C):0     DRDCOR                                        CCG02
     C                   ENDIF                                                                 CCG02
     C                   MOVEL     'N'           TOWRT                                         CCG02
     C     ##CMT         IFEQ      'YES'                                                       CCG02
     C                   WRITE     @UDCRPD                                                     CCG02
     C                   ELSE                                                                  CCG02
     C                   WRITE     @UDCRPDX                                                    CCG02
     C                   ENDIF                                                                 CCG02
     C                   ENDIF                                                                 CCG02
     C                   ENDDO                                                                 CCG02
     C                   ENDIF                                                                 CCG02
     C                   ENDIF                                                                 CCG02
      *                                                                   CCG024
      ** For LE confirmations                                             CCG024
     C     DRPTYP        IFEQ      C#LOCM                                                      CCG02
     C     DRPTYP        OREQ      C#LORP                                                      CCG02
     C     DRPTYP        OREQ      C#LORL                                                      CCG02
     C     DRPTYP        OREQ      C#LOFE                                                      CCG02
     C     DRPTYP        OREQ      C#LOIT                                                      CCG02
     C     DRPTYP        OREQ      C#LORT                                                      CCG02
     C     DRPTYP        OREQ      C#LOPD                                                      CCG02
     C                   MOVEL     DRMTRN        KLNRF                                         CCG02
     C                   MOVEL     'A'           KRCDT                                         CCG02
     C     KLOAN         CHAIN     CLOAN                              22                       CCG02
     C     *IN22         IFEQ      '0'                                                         CCG02
     C     NACD          ANDNE     *BLANKS                                                     CCG02
     C     NACD          ANDNE     'B'                                                       MD04392
     C     ##CUST        CAT(P)    SVAL1         DRDCOR                                        CCG02
     C                   CAT       NACD:0        DRDCOR                                        CCG02
     C                   MOVEL     'N'           TOWRT                                         CCG02
     C     ##CMT         IFEQ      'YES'                                                       CCG02
     C                   WRITE     @UDCRPD                                                     CCG02
     C                   ELSE                                                                  CCG02
     C                   WRITE     @UDCRPDX                                                    CCG02
     C                   ENDIF                                                                 CCG02
     C                   ENDIF                                                                 CCG02
     C                   ENDIF                                                                 CCG02
      *                                                                   CCG024
      ** For SE confirmations                                             CCG024
     C     DRPTYP        IFEQ      C#SEAD                                                      CCG02
     C     DRPTYP        OREQ      C#SEPO                                                      CCG02
     C     DRPTYP        OREQ      C#SEBS                                                    MD04363
     C     ##CUST        CHAIN     CLINTSEF                           22                       CCG02
     C     *IN22         IFEQ      '0'                                                         CCG02
     C     C1AN          ANDNE     *BLANKS                                                     CCG02
     C     ##CUST        CAT(P)    SVAL1         DRDCOR                                        CCG02
     C                   CAT       C1AN:0        DRDCOR                                        CCG02
     C                   MOVEL     'N'           TOWRT                                         CCG02
     C     ##CMT         IFEQ      'YES'                                                       CCG02
     C                   WRITE     @UDCRPD                                                     CCG02
     C                   ELSE                                                                  CCG02
     C                   WRITE     @UDCRPDX                                                    CCG02
     C                   ENDIF                                                                 CCG02
     C                   ENDIF                                                                 CCG02
     C                   ENDIF                                                                 CCG02
      *                                                                   CCG024
     C                   ENDIF                                                                 CCG02
     C*                                                                   S01408
     C/COPY WNCPYSRC,CG9010CCP2                                           S01408
     C*                                                                   S01408
     C     TOWRT         IFEQ      'Y'                                                         CCG02
     C     ##CMT         IFEQ      'YES'
     C                   WRITE     @UDCRPD
     C                   ELSE
     C                   WRITE     @UDCRPDX
     C                   ENDIF
     C                   ENDIF                                                                 CCG02
     C*                                                                   S01408
     C/COPY WNCPYSRC,CG9010CCP3                                           S01408
     C*                                                                   S01408
     C                   ENDIF
     C                   ENDIF
      *
     C     EXPRIM        TAG
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Subroutine  :  SRSECO                                         *
      * Purpose     :  Processing for secondary recipient(s)          *
      *                                                               *
      * Called by   :  Main process                                   *
      * Calls       :  SRPRSC                                         *
      *****************************************************************
      *
     C     SRSECO        BEGSR
      *
      ** Access all secondary recipients for this item; loop around
      ** file three times, each time removing an element of the key.
     C******************** MOVELZ#PRIM    ##PRIM                          087834
     C******************** MOVELDRPTYP    ##PTYP                          087834
     C******************** MOVELDRPSTP    ##PSTP                          087834
     C                   MOVEL     Z#PRIM        S#PRIM                                        08783
     C                   MOVEL     DRPTYP        S#PTYP                                        08783
     C                   MOVEL     DRPSTP        S#PSTP                                        08783
      *
     C***********1         DO   3         ##C     50                      087834
     C     1             DO        3             ##S               5 0                         08783
      *
     C***********##C       IFEQ 2                                         087834
     C     ##S           IFEQ      2                                                           08783
     C******************** CLEAR##PSTP                                    087834
     C                   CLEAR                   S#PSTP                                        08783
     C                   ENDIF
     C***********##C       IFEQ 3                                         087834
     C     ##S           IFEQ      3                                                           08783
     C******************** CLEAR##PTYP                                    087834
     C                   CLEAR                   S#PTYP                                        08783
     C                   ENDIF
      *
     C*****##KSTS        CHAIN     CGCSCHL5                           51                    MD054955
     C******IN51         DOWEQ     '0'                                                      MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare ACursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGCSHJW0                                                              MD054955
     C+ where CPCORR = :S#PRIM and CPPTYP = :S#PTYP and CPPSTP = :S#PSTP                    MD054955
     C+ and CPRECI = 'D'                                                                    MD054955
     C+ order by CPPCOR, CPPTYP, CPPSTP, CPCORR, CPSEQN                                     MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ close ACursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open ACursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   DOW       SQLCODE = 0                                              MD054955
     C/COPY WNCPYSRC,CG9010C001
      *
      ** If correspondent different from primary, and does not include
      ** account details (which are processed later), process secondary
     C     CPPCOR        IFNE      CPCORR
     C     CPMACT        ANDEQ     *BLANKS
     C/COPY WNCPYSRC,CG9010C002
     C                   EXSR      SRPRSC
     C                   END
      *
     C*****##KSTS        READE     CGCSCHL5                               51                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
      *
     C                   ENDDO                                                  DoW
      *
     C                   ENDDO                                                  Do 3
      *
      ** If account non-blank (ie. this is a statement) access
      ** secondary correspondents for account as well
     C     DRMACT        IFNE      *BLANKS
     C******************** MOVELDRMACT    ##MACT                          087834
     C                   MOVEL     DRMACT        S#MACT                                        08783
     C*****##KSAC        CHAIN     CGCSCHL3                           51                    MD054599
      *
     C******IN51*        DOWEQ     '0'                                                      MD054599
     C/EXEC SQL                                                                             MD054955
     C+ declare BCursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGCSHJW0                                                              MD054955
     C+ where CPMACT = :S#MACT and CPRECI = 'D' and CPMACT <> '          '                  MD054955
     C+ order by CPMACT, CPCORR, CPPTYP, CPPSTP, CPSEQN                                     MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ close BCursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open BCursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from BCursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   DOW       SQLCODE = 0                                              MD054955
     C*                                                                   107390
     C                   MOVE      'N'           FLD1              1                           10739
     C                   MOVE      'N'           FLD2              1                           10739
     C                   MOVE      'N'           FLD3              1                           10739
     C     CPPTYP        IFEQ      DRPTYP                                                      10739
     C     CPPSTP        ANDEQ     *BLANKS                                                     10739
     C                   MOVE      'Y'           FLD1                                          10739
     C                   END                                                                   10739
     C     CPPTYP        IFEQ      DRPTYP                                                      10739
     C     CPPSTP        ANDEQ     DRPSTP                                                      10739
     C                   MOVE      'Y'           FLD2                                          10739
     C                   END                                                                   10739
     C     CPPTYP        IFEQ      *BLANKS                                                     10739
     C     CPPSTP        ANDEQ     *BLANKS                                                     10739
     C                   MOVE      'Y'           FLD3                                          10739
     C                   END                                                                   10739
     C*                                                                   107390
      *
      ** If correspondent different from primary, process as secondary
     C     CPPCOR        IFNE      CPCORR
     C*                                                                   107390
     C     FLD1          IFEQ      'Y'                                                         10739
     C     FLD2          OREQ      'Y'                                                         10739
     C     FLD3          OREQ      'Y'                                                         10739
     C                   EXSR      SRPRSC
     C                   END                                                                   10739
     C*                                                                   107390
     C                   END
      *
     C*****##KSAC        READE     CGCSCHL3                               51                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from BCursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
      *
     C                   ENDDO                                                  DoW
      *
     C                   ENDIF
      *
     C     EXSECO        TAG
     C                   ENDSR
      /EJECT
      *****************************************************************   CCG004
      * Subroutine  :  SRCOPY                                         *   CCG004
      * Purpose     :  Processing for Copy correspondent              *   CCG004
      *                                                               *   CCG004
      * Called by   :  Main process                                   *   CCG004
      * Calls       :  SREDTL                                         *   CCG004
      *                SRIDGN                                         *   CCG004
      *****************************************************************   CCG004
      *                                                                   CCG004
     C     SRCOPY        BEGSR                                                                 CCG00
      *                                                                   CCG004
      ** Call SRDETL to obtain details for this copy correspondent        CCG004
      *                                                                   CCG004
     C                   SELECT                                                                CCG00
     C     ##COPY        WHENEQ    'BRANCH'                                                    CCG00
     C                   MOVEL(P)  'COPY'        Z#CORR                                        CCG00
     C                   MOVE      DRBRCA        Z#CORR                                        CCG00
     C     ##COPY        WHENEQ    'CORTYPE'                                                   CCG00
     C                   MOVEL(P)  'COPY'        Z#CORR                                        CCG00
     C     5             SUBST     ##CTYP:1      ##005A            5                           CCG00
     C                   MOVE      ##005A        Z#CORR                                        CCG00
     C                   OTHER                                                                 CCG00
     C                   MOVEL(P)  'COPY'        Z#CORR                                        CCG00
     C                   ENDSL                                                                 CCG00
      *                                                                   CCG004
     C                   CLEAR                   Z#CUST                                        CCG00
     C                   EXSR      SRDETL                                                      CCG00
     C                   MOVEL     Z#CUID        Z#CORR                                        CCG00
      *                                                                   CCG004
      ** Setup details for primary                                        CCG004
     C                   MOVEL     Z#PRIM        DRPCOR                                        CCG00
     C                   MOVEL     Z#CORR        DRDCOR                                        CCG00
     C                   MOVEL     Z#PRTD        DRPRTD                                        CCG00
     C                   MOVEL     Z#RETP        DRDDAT                                        CCG00
     C                   MOVEL     Z#LGID        DRLGID                                        CCG00
     C                   MOVEL     Z#ISTS        DRISTS                                        CCG00
     C                   MOVEL     Z#OVBR        DROVBR                                        CCG00
     C                   Z-ADD     AGRDNB        DRRDNB                                        CCG00
     C                   MOVEL     AGMRDT        DRARDT                                        CCG00
     C                   MOVEL     'D'           DRRECI                                        CCG00
     C                   MOVEL     'I'           DRAACT                                        CCG00
     C                   TIME                    DRATIM                                        CCG00
     C                   MOVEL     ##JOB         DRAJOB                                        CCG00
     C                   MOVEL     ##USR         DRAUSR                                        CCG00
      *                                                                   CCG004
      ** If suppress not indicated, and mode is '*GEN', generate          CCG004
      ** next sequence number and write reference record                  CCG004
     C     Z#SUPR        IFNE      'Y'                                                         CCG00
     C                   MOVEL     'Y'           ##GENI                                        CCG00
     C     ##MODE        IFEQ      '*GEN'                                                      CCG00
     C     ##CMT         IFEQ      'YES'                                                       CCG00
     C                   WRITE     @UDCRPD                                                     CCG00
     C                   ELSE                                                                  CCG00
     C                   WRITE     @UDCRPDX                                                    CCG00
     C                   ENDIF                                                                 CCG00
     C                   ENDIF                                                                 CCG00
     C                   ENDIF                                                                 CCG00
      *                                                                   CCG004
     C     EXCOPY        TAG                                                                   CCG00
     C                   ENDSR                                                                 CCG00
      /EJECT                                                              CCG004
      *****************************************************************   CCG004
      * Subroutine  :  SRCSEC                                         *   CCG004
      * Purpose     :  Processing for secondary copy correspondents   *   CCG004
      *                                                               *   CCG004
      * Called by   :  Main process                                   *   CCG004
      * Calls       :  SRPRSC                                         *   CCG004
      *****************************************************************   CCG004
      *                                                                   CCG004
     C     SRCSEC        BEGSR                                                                 CCG00
      *                                                                   CCG004
      ** Access all secondary recipients for this item; loop around       CCG004
      ** file three times, each time removing an element of the key.      CCG004
     C                   MOVEL     Z#CORR        S#PRIM                                        CCG00
     C                   MOVEL     DRPTYP        S#PTYP                                        CCG00
     C                   MOVEL     DRPSTP        S#PSTP                                        CCG00
      *                                                                   CCG004
     C     1             DO        3             ##S               5 0                         CCG00
      *                                                                   CCG004
     C     ##S           IFEQ      2                                                           CCG00
     C                   CLEAR                   S#PSTP                                        CCG00
     C                   ENDIF                                                                 CCG00
     C     ##S           IFEQ      3                                                           CCG00
     C                   CLEAR                   S#PTYP                                        CCG00
     C                   ENDIF                                                                 CCG00
      *                                                                   CCG004
     C*****##KSTS        CHAIN     CGCSCHL5                           51             CCG004 MD054599
     C******IN51         DOWEQ     '0'                                               CCG004 MD054599
     C/EXEC SQL                                                                             MD054955
     C+ declare CCursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGCSHJW0                                                              MD054955
     C+ where CPCORR = :S#PRIM and CPPTYP = :S#PTYP and CPPSTP = :S#PSTP                    MD054955
     C+ and CPRECI = 'D'                                                                    MD054955
     C+ order by CPPCOR, CPPTYP, CPPSTP, CPCORR, CPSEQN                                     MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ close CCursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open CCursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from CCursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   DOW       SQLCODE = 0                                              MD054955
      *                                                                   CCG004
      ** If correspondent different from primary, and does not include    CCG004
      ** account details (which are processed later), process secondary   CCG004
     C     CPPCOR        IFNE      CPCORR                                                      CCG00
     C     CPMACT        ANDEQ     *BLANKS                                                     CCG00
     C                   EXSR      SRPRSC                                                      CCG00
     C                   END                                                                   CCG00
      *                                                                   CCG004
     C*****##KSTS        READE     CGCSCHL5                               51         CCG004 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from CCursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
      *                                                                   CCG004
     C                   ENDDO                                                  DoW            CCG00
      *                                                                   CCG004
     C                   ENDDO                                                  Do 3           CCG00
      *                                                                   CCG004
      ** If account non-blank (ie. this is a statement) access            CCG004
      ** secondary correspondents for account as well                     CCG004
     C     DRMACT        IFNE      *BLANKS                                                     CCG00
     C                   MOVEL     DRMACT        S#MACT                                        CCG00
     C*****##KSAC        CHAIN     CGCSCHL3                           51             CCG004 MD054955
      *                                                                   CCG004
     C******IN51*        DOWEQ     '0'                                               CCG004 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare ECursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGCSHJW0                                                              MD054955
     C+ where CPMACT = :S#MACT and CPRECI = 'D' and CPMACT <> '          '                  MD054955
     C+ order by CPMACT, CPCORR, CPPTYP, CPPSTP, CPSEQN                                     MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ close ECursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open ECursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ECursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   DOW       SQLCODE = 0                                              MD054955
     C*                                                                   107390
     C                   MOVE      'N'           FLD1                                          10739
     C                   MOVE      'N'           FLD2                                          10739
     C                   MOVE      'N'           FLD3                                          10739
     C     CPPTYP        IFEQ      DRPTYP                                                      10739
     C     CPPSTP        ANDEQ     *BLANKS                                                     10739
     C                   MOVE      'Y'           FLD1                                          10739
     C                   END                                                                   10739
     C     CPPTYP        IFEQ      DRPTYP                                                      10739
     C     CPPSTP        ANDEQ     DRPSTP                                                      10739
     C                   MOVE      'Y'           FLD2                                          10739
     C                   END                                                                   10739
     C     CPPTYP        IFEQ      *BLANKS                                                     10739
     C     CPPSTP        ANDEQ     *BLANKS                                                     10739
     C                   MOVE      'Y'           FLD3                                          10739
     C                   END                                                                   10739
     C*                                                                   107390
      *                                                                   CCG004
      ** If correspondent different from primary, process as secondary    CCG004
     C     CPPCOR        IFNE      CPCORR                                                      CCG00
     C*                                                                   107390
     C     FLD1          IFEQ      'Y'                                                         10739
     C     FLD2          OREQ      'Y'                                                         10739
     C     FLD3          OREQ      'Y'                                                         10739
     C                   EXSR      SRPRSC                                                      CCG00
     C                   END                                                                   10739
     C*                                                                   107390
     C                   END                                                                   CCG00
      *                                                                   CCG004
     C*****##KSAC        READE     CGCSCHL3                               51         CCG004 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ECursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
      *                                                                   CCG004
     C                   ENDDO                                                  DoW            CCG00
      *                                                                   CCG004
     C                   ENDIF                                                                 CCG00
      *                                                                   CCG004
     C     EXCSEC        TAG                                                                   CCG00
     C                   ENDSR                                                                 CCG00
      /EJECT                                                              CCG004
      *****************************************************************
      * Subroutine  :  SRPRSC                                         *
      * Purpose     :  Create reference records for secondaries       *
      *                                                               *
      * Called by   :  SRSECO                                         *
      * Calls       :  SRDETL                                         *
      *                SRIDGN                                         *
      *****************************************************************
      *
     C     SRPRSC        BEGSR
      *
      ** Obtain details via subroutine SRDETL
     C                   CLEAR                   Z#CUST
     C                   MOVEL     CPCORR        Z#CORR
     C                   MOVEL     CPCORR        D#CORR                                        08783
     C                   EXSR      SRDETL
      *
      ** If suppress not indicated, set generate_item indication. If
      ** mode is '*GEN', generate item.
     C     Z#SUPR        IFNE      'Y'
     C                   MOVEL     'Y'           ##GENI
     C     ##MODE        IFEQ      '*GEN'
      *
      ** If no item id created (check item_id_generated indication),
      ** generate item id.
     C     ##IDGN        IFNE      'Y'
     C                   EXSR      SRIDGN
     C                   ENDIF
      *
     C                   Z-ADD     ##ITMN        DRITEM
     C******************** MOVELZ#CORR    DRDCOR                          087831
     C                   MOVEL     D#CORR        DRDCOR                                        08783
     C                   MOVEL     Z#PRIM        DRPCOR
     C                   MOVEL     Z#PRTD        DRPRTD
     C                   MOVEL     Z#RETP        DRDDAT
     C                   MOVEL     Z#LGID        DRLGID
     C                   MOVEL     Z#ISTS        DRISTS
     C                   MOVEL     Z#OVBR        DROVBR
      *                                                                   082705
      ** Check item does not already exist (owing to a duplication        082705
      ** on the schedules file) - if not, write new record                082705
     C     ##KUDC        SETLL     CGUDCRL0                               60                   08270
      *
     C     *IN60         IFEQ      '0'                                                         08270
      *                                                                   082705
     C     ##CMT         IFEQ      'YES'
     C                   WRITE     @UDCRPD
     C                   ELSE
     C                   WRITE     @UDCRPDX
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                   082705
     C                   ENDIF                                                                 08270
     C                   ENDIF
      *
     C     EXPRSC        TAG
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Subroutine  :  SRDETL                                         *
      * Purpose     :  Dervive details for correspondent              *
      *                                                               *
      * Called by   :  SRPRIM                                         *
      *                SRPRSC                                         *
      * Calls       :  SRDEFT                                         *
      * Parms IN    :  Z#CUST - Entity: customer number (primary)     *
      *                Z#CORR -         -or- correspondent id         *
      *       OUT   :  Z#CUID - Correspondent id of customer Z#CUST   *
      *                Z#PRTD - Scheduled print date                  *
      *                Z#RETP - Retention period                      *
      *                Z#LGID - Language id                           *
      *                Z#SUPR - Suppress_output indication            *
      *                Z#ISTS - Item status                           *
      *                Z#OVBR - Item status                           *
      *****************************************************************
      *
     C     SRDETL        BEGSR
      *
      ** Initialise output fields
     C                   MOVEL     'N'           Z#INAC            1
     C                   MOVEL     'N'           Z#SUPR            1
     C                   CLEAR                   Z#PRTD
     C                   CLEAR                   Z#RETP
     C                   CLEAR                   Z#LGID
     C                   CLEAR                   Z#PSCH
     C                   CLEAR                   Z#ISTS
     C                   CLEAR                   Z#OVBR
      *
      ** If this is primary, get defaults for system and branch
     C     Z#CORR        IFEQ      *BLANKS
     C                   MOVEL     DRBRCA        Z#BRCA
     C     1             DO        3             Z#LEVL            5 0
     C                   EXSR      SRDEFT
     C                   ENDDO     2
     C                   ENDIF
      *
      ** Access entity level defaults
     C******************** Z-ADD5         Z#LEVL                          082705
     C                   Z-ADD     7             Z#LEVL                                        08270
     C                   EXSR      SRDEFT
     C                   MOVEL     Z#CORR        Z#CUID
      *
      ** Access type level defaults                                       082705
     C                   Z-ADD     5             Z#LEVL                                        08270
     C                   EXSR      SRDEFT                                                      08270
      *
      ***Loop*6*times,*starting*at*highest*level*of*default*(entity/      082705
      ** Loop 8 times, starting at highest level of default (entity/      082705
      ** correspondent) stepping back to lowest level (system). Note
      ** that the 'defaults must be applied' indicator will over-ride
      ** previous values.
     C********** 1         DO   6         ##C                             082705
     C********** 7         SUB  ##C       ##D     50                      082705
     C     1             DO        8             ##C               5 0                         08270
     C     9             SUB       ##C           ##D               5 0                         08270
     C     ##D           OCCUR     D#DEFT
      *
      **  o print date
     C     Z#PRTD        IFEQ      *ZEROS
     C     D#APDF        OREQ      'Y'
     C     D#PRTD        ANDNE     *ZEROS
     C                   Z-ADD     D#PRTD        Z#PRTD
     C                   ENDIF
      *
      **  o retention period
     C     Z#RETP        IFEQ      *ZEROS
     C     D#APDF        OREQ      'Y'
     C     D#RETP        ANDNE     *ZEROS
     C                   Z-ADD     D#RETP        Z#RETP
     C                   ENDIF
      *
      **  o language identifier
     C     Z#LGID        IFEQ      *BLANKS
     C     D#APDF        OREQ      'Y'
     C     D#LGID        ANDNE     *BLANKS
     C                   MOVEL     D#LGID        Z#LGID
     C                   ENDIF
      *
      **  o print schedule
     C     Z#PSCH        IFEQ      *BLANKS
     C     D#APDF        OREQ      'Y'
     C     D#PSCH        ANDNE     *BLANKS
     C                   MOVEL     D#PSCH        Z#PSCH
     C                   ENDIF
      *
      **  o overide branch
     C     Z#OVBR        IFEQ      *BLANKS
     C     D#APDF        OREQ      'Y'
     C     D#OVBR        ANDNE     *BLANKS
     C                   MOVEL     D#OVBR        Z#OVBR
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Inactive correspondent indicator; if correspondent inactive
      ** suppress output
     C     Z#INAC        IFEQ      'Y'
     C                   MOVEL     'Y'           Z#SUPR
     C                   ENDIF
      *
      ** Get frequency code for schedule
     C********** Z#PSCH    CHAINCGPSCHL0             52                   084316
      *                                                                   087283
      * Look up schedule in array                                         087283
      *                                                                   087283
     C                   Z-ADD     1             X                 5 0                         08728
     C     Z#PSCH        LOOKUP    #PSC(X)                                90                   08728
      *                                                                   087283
      * If found access details from PSTORE                               087283
      *                                                                   087283
     C     *IN90         IFEQ      '1'                                                         08728
     C     X             OCCUR     PSTORE                                                      08728
      *                                                                   087283
      * If record found move to CGPSCHPD set 50 off else set 50 on        087283
      *                                                                   087283
     C     ##NFP         IFNE      'Y'                                                         08728
     C                   SETOFF                                       52                       08728
     C                   MOVEL     PSTORE        CGPSCH                                        08728
     C                   ELSE                                                                  08728
     C                   SETON                                        52                       08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
      * Schedule not in store so chain to find details                    087283
      *                                                                   087283
     C                   ELSE                                                                  08728
     C     Z#PSCH        CHAIN     CGPSCHL1                           52                       08431
      *                                                                   087283
      * Set up new off set, move contents into array                      087283
      *                                                                   087283
     C                   ADD       1             ##POFS            5 0                         08728
     C     ##POFS        IFGT      10                                                          08728
     C                   Z-ADD     1             ##POFS                                        08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
     C                   Z-ADD     ##POFS        X                                             08728
     C                   MOVEA     Z#PSCH        #PSC(X)                                       08728
     C     X             OCCUR     PSTORE                                                      08728
     C                   MOVEL     *BLANKS       PSTORE                                        08728
      *                                                                   087283
      * If record found move in CGCORRPD else ##NFC to Y                  087283
      *                                                                   087283
     C     *IN52         IFEQ      *OFF                                                        08728
     C                   MOVEL     CGPSCH        PSTORE                                        08728
     C                   MOVEL     *BLANKS       ##NFP                                         08728
     C                   ELSE                                                                  08728
     C                   MOVEL     'Y'           ##NFP                                         08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
     C                   ENDIF                                                                 08728
      *
      ** Database error
     C     *IN52         IFEQ      '1'
     C******************** MOVEL'CGPSCHL0'W0FILE                          084316
     C                   MOVEL     'CGPSCHL1'    W0FILE                                        08431
     C                   MOVEL     Z#PSCH        W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** If frequency code is SUPPRESS, set suppress_output indication,
      ** otherwise determine appropriate status code
     C     STFREQ        IFEQ      'SUPPRESS'
     C                   MOVEL     'Y'           Z#SUPR
     C                   ELSE
     C     STFREQ        LOOKUP    TAB1          TAB2                     55
     C     *IN55         IFEQ      '1'
     C                   MOVEL     TAB2          Z#ISTS
     C                   ELSE
     C                   MOVEL     'SCHD'        Z#ISTS
     C                   ENDIF
     C                   ENDIF
      *
     C     EXDETL        TAG
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Subroutine  :  SRDEFT                                         *
      * Purpose     :  Derive schedule details for system/branch/     *
      *                entity                                         *
      *                                                               *
      *                This subroutine writes schedule details (D#*)  *
      *****************to*one*of*six*occurrences*of*a*multiple*********   082705
      *                to one of eight occurrences of a multiple      *   082705
      *                occurence data structure:                      *
      *                                                               *
      *                 1  - System                                   *
      *                 2  - System/correspondent schedule details    *
      *                 3  - Branch                                   *
      *                 4  - Branch/correspondent schedule details    *
      ******************5**-*Entity************************************   082705
      ******************6**-*Entity/correspondent schedule details*****   082705
      *                 5  - Correspondent type                       *   082705
      *                 6  - Correspondent type/schedule details      *   082705
      *                 7  - Entity                                   *   082705
      *                 8  - Entity/correspondent schedule details    *   082705
      *                                                               *
      * Called by   :  SRDETL                                         *
      *                SRINIT                                         *
      * Calls       :  -                                              *
      **Parms*IN****:**Z#LEVL*-*1*=>*System;*3*=>*Branch;*5*=>*Entity**   082705
      * Parms IN    :  Z#LEVL - 1 => System; 3 => Branch; 5 => c/type *   082075
      *                7 => entity                                    *   082075
      *                Z#BRCA - Branch code                           *
      *                Z#CUST - Entity: customer number -or-          *
      *                Z#CORR -         correspondent id              *
      *       OUT   :  D#PRTD - Scheduled print date                  *
      *                D#RETP - Retention period                      *
      *                D#LGID - Language id                           *
      *                D#PSCH - Print schedule                        *
      *                D#OVBR - Override branch                       *
      *                Z#INAC - Inactive correspondent indication     *
      *                         (entity level only)                   *
      *****************************************************************
      *
     C     SRDEFT        BEGSR
      *
      ** Access DS occurence for this level, and clear
     C     Z#LEVL        OCCUR     D#DEFT
     C                   CLEAR                   D#DEFT
      *
      ** Initialise level_found indication
     C                   MOVEL     'Y'           ##LFND            1
      *
      ** Access correspondent for approriate level -
      ***System*-*only*if*not*already*accessed*************************   079847
      ** System                                                           079847
     C     Z#LEVL        IFEQ      1
     C********** ##SYST    ANDNE'Y'                                       079847
      *                                                                   079847
     C******************** MOVEL'Y'       ##SYST
      *                                                                   087283
      * Access occurrance number 1 for system details                     087283
      *                                                                   087283
     C     1             OCCUR     CSTORE                                                      08728
     C                   MOVEL     CSTORE        CGCORR                                        08728
      *                                                                   087283
      * If Correspondent blank get details                                087283
      *                                                                   087283
     C     CDCORR        IFNE      *BLANKS                                                     08728
     C                   MOVEL     CSTORE        CGCORR                                        08728
      *                                                                   087283
      *  Correspondent is blank get details                               087283
      *                                                                   087283
     C                   ELSE                                                                  08728
     C                   MOVEL     'SYSTEM'      W0KEY
     C     '   '         CHAIN     CGCORRL3                           50
      *
      ** Database error
     C     *IN50         IFEQ      '1'
     C                   MOVEL     'CGCORRL3'    W0FILE
     C                   MOVEL     'SYSTEM'      W0KEY                          ***************
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 02 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                   087283
      *  Move in corresondent infromation                                 087283
      *                                                                   087283
     C                   MOVEL     CGCORR        CSTORE                                        08728
     C                   ENDIF                                                                 08728
      *
     C                   ENDIF
      *
      ** Branch (not mandatory hence no database error processing)
     C     Z#LEVL        IFEQ      3
      *                                                                   087283
      * Look up Branch in array                                           087283
      *                                                                   087283
     C                   Z-ADD     1             X                 5 0                         08728
     C     Z#BRCA        LOOKUP    #BRC(X)                                90                   08728
      *                                                                   087283
      * If found access details from CSTORE                               087283
      *                                                                   087283
     C     *IN90         IFEQ      '1'                                                         08728
     C     X             ADD       1             X                                             08728
     C     X             OCCUR     CSTORE                                                      08728
      *                                                                   087283
      * If record found move to CGCORRPD set 50 off else set 50 on        087283
      *                                                                   087283
     C     ##NFC         IFNE      'Y'                                                         08728
     C                   SETOFF                                       50                       08728
     C                   MOVEL     CSTORE        CGCORR                                        08728
     C                   ELSE                                                                  08728
     C                   SETON                                        50                       08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
      * Branch not in store so chain to find details                      087283
      *                                                                   087283
     C                   ELSE                                                                  08728
     C     Z#BRCA        CHAIN     CGCORRL2                           50
      *                                                                   087283
      * Set up new off set, move contents into array                      087283
      *                                                                   087283
     C                   ADD       1             ##BOFS            5 0                         08728
     C     ##BOFS        IFGT      10                                                          08728
     C                   Z-ADD     1             ##BOFS                                        08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
     C                   Z-ADD     ##BOFS        X                                             08728
     C                   MOVEA     Z#BRCA        #BRC(X)                                       08728
     C     ##BOFS        ADD       1             X                                             08728
     C     X             OCCUR     CSTORE                                                      08728
     C                   MOVEL     *BLANKS       CSTORE                                        08728
      *                                                                   087283
      * If record found move in CGCORRPD else ##NFC to Y                  087283
      *                                                                   087283
     C     *IN50         IFEQ      *OFF                                                        08728
     C                   MOVEL     CGCORR        CSTORE                                        08728
     C                   MOVEL     *BLANKS       ##NFC                                         08728
     C                   ELSE                                                                  08728
     C                   MOVEL     'Y'           ##NFC                                         08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
     C                   ENDIF                                                                 08728
      *
      ** if not found, set level_found indication to prevent further
      ** processing
     C     *IN50         IFEQ      '1'
     C     4             OCCUR     D#DEFT
     C                   CLEAR                   D#DEFT
     C                   MOVEL     'N'           ##LFND
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                   082705
      ** Correspondent type                                               082705
     C     Z#LEVL        IFEQ      5                                                           08270
      *                                                                   087283
      * Look up Type in array                                             087283
      *                                                                   087283
     C                   Z-ADD     1             X                 5 0                         08728
     C     Z#CTYP        LOOKUP    #CTY(X)                                90                   08728
      *                                                                   087283
      * If found access details from CSTORE                               087283
      *                                                                   087283
     C     *IN90         IFEQ      '1'                                                         08728
     C     X             ADD       11            X                                             08728
     C     X             OCCUR     CSTORE                                                      08728
      *                                                                   087283
      * If record found move to CGCORRPD set 50 off else set 50 on        087283
      *                                                                   087283
     C     ##NFC         IFNE      'Y'                                                         08728
     C                   SETOFF                                       50                       08728
     C                   MOVEL     CSTORE        CGCORR                                        08728
     C                   ELSE                                                                  08728
     C                   SETON                                        50                       08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
      * Branch not in store so chain to find details                      087283
      *                                                                   087283
     C                   ELSE                                                                  08728
     C     Z#CTYP        CHAIN     CGCORRLC                           50                       08270
      *                                                                   087283
      * Set up new off set, move contents into array                      087283
      *                                                                   087283
     C                   ADD       1             ##TOFS            5 0                         08728
     C     ##TOFS        IFGT      10                                                          08728
     C                   Z-ADD     1             ##TOFS                                        08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
     C                   Z-ADD     ##TOFS        X                                             08728
     C                   MOVEA     Z#CTYP        #CTY(X)                                       08728
     C     ##TOFS        ADD       11            X                                             08728
     C     X             OCCUR     CSTORE                                                      08728
     C                   MOVEL     *BLANKS       CSTORE                                        08728
      *                                                                   087283
      * If record found move in CGCORRPD else ##NFC to Y                  087283
      *                                                                   087283
     C     *IN50         IFEQ      *OFF                                                        08728
     C                   MOVEL     CGCORR        CSTORE                                        08728
     C                   MOVEL     *BLANKS       ##NFC                                         08728
     C                   ELSE                                                                  08728
     C                   MOVEL     'Y'           ##NFC                                         08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
     C                   ENDIF                                                                 08728
     C     *IN50         IFEQ      '1'                                                         08270
     C     6             OCCUR     D#DEFT                                                      08270
     C                   CLEAR                   D#DEFT                                        08270
     C                   MOVEL     'N'           ##LFND                                        08270
     C                   ENDIF                                                                 08270
     C                   ENDIF                                                                 08270
      *
      ** Entity
     C***********Z#LEVL    IFEQ 5                                         082705
     C     Z#LEVL        IFEQ      7                                                           08270
      *
     C     Z#CUST        IFNE      *BLANKS
      *                                                                   087283
      * Look up customer in array                                         087283
      *                                                                   087283
     C                   Z-ADD     1             X                 5 0                         08728
     C     Z#CUST        LOOKUP    #CUS(X)                                90                   08728
      *                                                                   087283
      * If found access details from CSTORE                               087283
      *                                                                   087283
     C     *IN90         IFEQ      '1'                                                         08728
     C     X             ADD       31            X                                             08728
     C     X             OCCUR     CSTORE                                                      08728
      *                                                                   087283
      * If record found move to CGCORRPD set 50 off else set 50 on        087283
      *                                                                   087283
     C     ##NFC         IFNE      'Y'                                                         08728
     C                   SETOFF                                       50                       08728
     C                   MOVEL     CSTORE        CGCORR                                        08728
     C                   ELSE                                                                  08728
     C                   SETON                                        50                       08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
      * Customer not in store so chain to find details                    087283
      *                                                                   087283
     C                   ELSE                                                                  08728
     C                   MOVEL     Z#CUST        W0KEY
     C     Z#CUST        CHAIN     CGCORRL4                           50
      *                                                                   087283
      * Set up new off set, move contents into array                      087283
      *                                                                   087283
     C                   ADD       1             ##COFS            5 0                         08728
     C     ##COFS        IFGT      20                                                          08728
     C                   Z-ADD     1             ##COFS                                        08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
     C                   Z-ADD     ##COFS        X                                             08728
     C                   MOVEA     Z#CUST        #CUS(X)                                       08728
     C     ##COFS        ADD       31            X                                             08728
     C     X             OCCUR     CSTORE                                                      08728
     C                   MOVEL     *BLANKS       CSTORE                                        08728
      *                                                                   087283
      * If record found move in CGCORRPD else ##NFC to Y                  087283
      *                                                                   087283
     C     *IN50         IFEQ      *OFF                                                        08728
     C                   MOVEL     CGCORR        CSTORE                                        08728
     C                   MOVEL     *BLANKS       ##NFC                                         08728
     C                   ELSE                                                                  08728
     C                   MOVEL     'Y'           ##NFC                                         08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
     C                   ENDIF                                                                 08728
     C                   ELSE
     C********** Z#CORR    CHAINCGCORRL0             50                   084316
      *                                                                   087283
      * Look up correspondent in array                                    087283
      *                                                                   087283
     C                   Z-ADD     1             X                 5 0                         08728
     C     Z#CORR        LOOKUP    #COR(X)                                90                   08728
      *                                                                   087283
      * If found access details from CSTORE                               087283
      *                                                                   087283
     C     *IN90         IFEQ      '1'                                                         08728
     C     X             ADD       51            X                                             08728
     C     X             OCCUR     CSTORE                                                      08728
      *                                                                   087283
      * If record found move to CGCORRPD set 50 off else set 50 on        087283
      *                                                                   087283
     C     ##NFC         IFNE      'Y'                                                         08728
     C                   SETOFF                                       50                       08728
     C                   MOVEL     CSTORE        CGCORR                                        08728
     C                   ELSE                                                                  08728
     C                   SETON                                        50                       08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
      * Customer not in store so chain to find details                    087283
      *                                                                   087283
     C                   ELSE                                                                  08728
     C     Z#CORR        CHAIN     CGCORRL1                           50                       08431
      *                                                                   087283
      * Set up new off set, move contents into array                      087283
      *                                                                   087283
     C                   ADD       1             ##ROFS            5 0                         08728
     C     ##ROFS        IFGT      20                                                          08728
     C                   Z-ADD     1             ##ROFS                                        08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
     C                   Z-ADD     ##ROFS        X                                             08728
     C                   MOVEA     Z#CORR        #COR(X)                                       08728
     C     ##ROFS        ADD       51            X                                             08728
     C     X             OCCUR     CSTORE                                                      08728
     C                   MOVEL     *BLANKS       CSTORE                                        08728
      *                                                                   087283
      * If record found move in CGCORRPD else ##NFC to Y                  087283
      *                                                                   087283
     C     *IN50         IFEQ      *OFF                                                        08728
     C                   MOVEL     CGCORR        CSTORE                                        08728
     C                   MOVEL     *BLANKS       ##NFC                                         08728
     C                   ELSE                                                                  08728
     C                   MOVEL     'Y'           ##NFC                                         08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
     C                   ENDIF                                                                 08728
     C                   MOVEL     Z#CORR        W0KEY
     C                   ENDIF
      *
      ***Database*error                                                   080068
      ** If no correspondent details set inactive indication and return   080068
     C     *IN50         IFEQ      '1'                                                         08006
     C                   MOVEL     'N'           ##LFND                                        08006
     C                   MOVEL     'Y'           Z#INAC                                        08006
     C********** 6         OCUR D#DEFT                              080068082705
     C     8             OCCUR     D#DEFT                                                      08270
     C                   CLEAR                   D#DEFT                                        08006
     C**********           MOVEL'CGCORRLn'W0FILE           ***************080068
     C**********           Z-ADD3         W0ERNB           * DB ERROR 03 *080068
     C**********           MOVEL'MEM5004' W0MSGD           ***************080068
     C**********           MOVEL'MIDAS  ' W0MSGF                          080068
     C**********           EXSR SRERR                                     080068
     C                   ENDIF                                                                 08006
     C                   ENDIF
      *
      ** If level found, continue processing
     C     ##LFND        IFEQ      'Y'
      *
      ** Move correspondent id to Z#CORR in order to identify
      ** additional schedule information
     C                   MOVEL     CDCORR        Z#CORR
      *
      ** Move type id to Z#CTYP for next lookup (level 5)
     C                   MOVEL     CDCTYP        Z#CTYP
      *
      ** Store correspondent type for this entity
     C                   MOVEL     CDCTYP        Z#CTYP
      *
      ** For entity level, check correspondent is active. If it is not
      ** set inactive indication and end subroutine
     C     AGRDNB        IFLT      CDATDT
     C***********Z#LEVL    ANDEQ5                                         087283
     C     Z#LEVL        ANDEQ     7                                                           08728
     C     AGRDNB        ORGT      CDDADT
     C     *ZEROS        ANDNE     CDDADT
     C***********Z#LEVL    ANDEQ5                                         087283
     C     Z#LEVL        ANDEQ     7                                                           08728
      *
     C                   MOVEL     'Y'           Z#INAC            1
     C***********6         OCUR D#DEFT                                    082705
     C     8             OCCUR     D#DEFT                                                      08270
     C                   CLEAR                   D#DEFT
      *
     C                   ELSE
      *
      ** Set up defaults at this level
     C                   MOVEL     CDOBRC        D#OVBR
     C                   Z-ADD     CDDPDT        D#PRTD
     C                   Z-ADD     CDDRET        D#RETP
     C                   MOVEL     CDLGID        D#LGID
     C                   MOVEL     CDDPRT        D#PSCH
      *
      ** Access next occurence of data structure for additional details
     C     Z#LEVL        ADD       1             ##C
     C     ##C           OCCUR     D#DEFT
     C                   CLEAR                   D#DEFT
      *
      *****************************************************************   080068
      ***Check*whether*the*correspondent*has*any*additional*schedule***   080068
      ***details*for*this*type*of*item.*If*the*account*id*passed*by*the   080068
      ***calling*program*is*non-blank,*check*on*the*basis*of*account***   080068
      ***followed*by*account*code;*if*no*record*found,*or*account*is***   080068
      ***blank,*check*on*type/sub-type.********************************   080068
     C**********           MOVELZ#CORR    ##CORR                          080068
     C**********           MOVELZ#CORR    ##SAME                          080068
     C**********           MOVELDRPTYP    ##PTYP                          080068
     C**********           MOVELDRPSTP    ##PSTP                          080068
      **********                                                          080068
      ***Account*non-blank;*check*on*account,*account*code*************   080068
     C********** DRMACT    IFNE *BLANKS                                   080068
     C**********           MOVELDRMACT    ##MACT                          080068
     C********** ##KSCA    CHAINCGCSCHL3             51                   080068
     C********** *IN51     IFEQ '1'                                       080068
     C********** ##KSCC    CHAINCGCSCHL2             51                   080068
     C**********           ENDIF                                          080068
     C**********           ENDIF                                          080068
      **********                                                          080068
      ***If*no*record*found*for*account,*or*account*is*blank,*check*on*   080068
      ***print*type/sub-type*******************************************   080068
     C********** DRMACT    IFEQ *BLANKS                                   080068
     C********** *IN51     OREQ '1'                                       080068
      **********                                                          080068
     C********** ##KSCT    CHAINCGCSCHL5             51                   080068
      **********                                                          080068
      ***If*none*found,*check*for*generic*entry*-*first*for*sub-type***   080068
      ***only,*then*for*type*and*sub-type******************************   080068
     C********** *IN51     IFEQ '1'                                       080068
     C**********           CLEAR##PTYP                                    080068
     C********** ##KSCT    CHAINCGCSCHL5             51                   080068
     C********** *IN51     IFEQ '1'                                       080068
     C**********           CLEAR##PSTP                                    080068
     C********** ##KSCT    CHAINCGCSCHL5             51                   080068
     C**********           ENDIF                                          080068
     C**********           ENDIF                                          080068
      **********                                                          080068
     C**********           ENDIF                                          080068
      *                                                                   080068
      ** Access best-fit additional details for this entity:              080068
      **  o Set up fixed key values; correspondent and secondary          080068
      **    correspondent and account code (via DS)                       080068
     C                   MOVEL     Z#CORR        ##CORR                                        08006
     C     Z#PRIM        IFEQ      *BLANKS                                                     08006
     C                   MOVEL     Z#CORR        ##PCOR                                        08006
     C                   ELSE                                                                  08006
     C                   MOVEL     Z#PRIM        ##PCOR                                        08006
     C                   ENDIF                                                                 08006
     C                   MOVEL     DRMACT        ##MACT                                        08006
      *                                                                   080068
      **  o Loop using pre-defined search pattern (array SCSQ), filling   080068
      **    elements of the key until a match is found                    080068
     C                   Z-ADD     0             #W                5 0                         08006
     C     #W            DOUEQ     4                                                           08006
     C     *IN51         OREQ      '0'                                                         08006
      *                                                                   080068
      **  o increment pointer to next selection, and move to work array   080068
     C                   ADD       1             #W                                            08006
     C                   MOVEA     #SCSQ(#W)     #SCLT                                         08006
      *                                                                   080068
      **  o Clear variable key values, and set up from array              080068
     C                   CLEAR                   #KEY9D                                        08006
     C     #SCLT(1)      IFEQ      'Y'                                                         08006
     C                   MOVEL     DRPTYP        ##PTYP                                        08006
     C                   ENDIF                                                                 08006
     C     #SCLT(2)      IFEQ      'Y'                                                         08006
     C                   MOVEL     DRPSTP        ##PSTP                                        08006
     C                   ENDIF                                                                 08006
     C     #SCLT(3)      IFEQ      'Y'                                                         08006
      *                                                                   087283
      * If either no records for account codes or blank exit              087283
      *                                                                   087283
     C     ##L2NR        IFEQ      'None'                                                      08728
     C     DRMACT        OREQ      *BLANKS                                                     08728
     C                   MOVEL     '1'           *IN51                                         08728
     C                   ITER                                                                  08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
     C                   MOVEL     ##ACOD        ##ACCD                                        08006
     C                   ENDIF                                                                 08006
     C     #SCLT(4)      IFEQ      'Y'                                                         08006
      *                                                                   087283
      * If either no records for account codes or blank exit              087283
      *                                                                   087283
     C     ##L3NR        IFEQ      'None'                                                      08728
     C     DRMACT        OREQ      *BLANKS                                                     08728
     C                   MOVEL     '1'           *IN51                                         08728
     C                   ITER                                                                  08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
     C                   MOVEL     DRMACT        K#MACT                                        08006
     C                   ENDIF                                                                 08006
      *                                                                   080068
      **  o Access file                                                   080068
     C*****##KSCH        CHAIN     CGCSCHL9                           51              08006 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C+ where CPCORR = :##CORR and CPPTYP = :##PTYP and CPPSTP = :##PSTP                    MD054955
     C+ and CPACCD = :##ACCD and CPMACT = :K#MACT and CPPCOR = :##PCOR                      MD054955
     C+ and CPRECI = 'D'                                                                    MD054955
     C+ order by CPCORR, CPPTYP, CPPSTP, CPACCD, CPMACT, CPPCOR                             MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       51                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        51                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *                                                                   080068
     C                   ENDDO                                                                 08006
      *                                                                   080068
      ** If record found on schedule details set up defaults in data
      ** structure occurence
     C     *IN51         IFEQ      '0'
     C                   MOVEL     CPAPDF        D#APDF
     C******************** Z-ADDCDDPDT    D#PRTD                          082705
     C                   Z-ADD     CPNPDT        D#PRTD                                        08270
     C                   Z-ADD     CPRETP        D#RETP
     C                   MOVEL     CPLGID        D#LGID
     C                   MOVEL     CPPSCH        D#PSCH
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EXDEFT        TAG
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Subroutine  :  SRIDGN                                         *
      * Purpose     :  Generate next item reference number            *
      *                                                               *
      * Called by   :  SRPRIM                                         *
      *                SRSECO                                         *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SRIDGN        BEGSR
      *
      ** Get last item reference from data area, increment to create
      ** new item reference, and write back to data area. If data area
      ** is blank, start at 1.
     C     *DTAARA       DEFINE    CGDTA         CGDATA
     C     *LOCK         IN        CGDATA
     C                   MOVEL     DAITMA        ##ITMA
     C     ##ITMA        IFEQ      *BLANKS
     C                   Z-ADD     1             ##ITMN
     C                   ELSE
     C                   ADD       1             ##ITMN
     C                   ENDIF
     C                   MOVEL     ##ITMA        DAITMA
     C                   OUT       CGDATA
     C                   MOVEL     ##ITMA        ##ITEM
      *
      ** Set item_id_generated indication
     C                   MOVEL     'Y'           ##IDGN
      *
     C     EXIDGN        TAG
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Subroutine  :  SRINIT                                         *
      * Purpose     :  Initial processing                             *
      *                                                               *
      * Called by   :  Main process                                   *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Access run-date
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
      *
      ** Initialise system_level_already_accessed indication
     C                   MOVEL     'N'           ##SYST            1
      *
      ** Open appropriate version of reference file, depending on
      ** whether commitment control is active or not
     C     ##CMT         IFEQ      'YES'
     C                   OPEN      CGUDCRPD
     C                   ELSE
     C                   OPEN      EXUDCRPD
     C                   ENDIF
      *
      ** Set up copyright statement
     C                   MOVE      CPYR@#        ACT@             80
      *
      ** Key lists:
      **  o additional schedule information; print item type/sub-type
     C***********##KSCT*** KLIST                                          080068
     C******************** KFLD           ##CORR                          080068
     C******************** KFLD           ##PTYP                          080068
     C******************** KFLD           ##PSTP                          080068
     C******************** KFLD           ##SAME                          080068
      *
      **  o additional schedule information; account id
     C***********##KSCA*** KLIST                                           08068
     C******************** KFLD           ##MACT                           08068
     C******************** KFLD           ##CORR                           08068
     C******************** KFLD           ##PTYP                           08068
     C******************** KFLD           ##PSTP                           08068
      *
      ****o*additional*schedule information; account code                  08068
     C***********##KSCC*** KLIST                                           08068
     C******************** KFLD           ##ACOD                           08068
     C******************** KFLD           ##CORR                           08068
     C******************** KFLD           ##PTYP                           08068
     C******************** KFLD           ##PSTP                           08068
      *
      **  o additional schedule information for correspondent
     C     ##KSCH        KLIST
     C                   KFLD                    ##CORR
     C                   KFLD                    ##PTYP
     C                   KFLD                    ##PSTP
     C                   KFLD                    ##ACCD
     C                   KFLD                    K#MACT
     C                   KFLD                    ##PCOR
      *
      **  o additional schedule information; secondary recipients
      **    by print type/sub-type
     C     ##KSTS        KLIST
     C******************** KFLD           ##PRIM                          087834
     C******************** KFLD           ##PTYP                          087834
     C******************** KFLD           ##PSTP                          087834
     C                   KFLD                    S#PRIM                                        08783
     C                   KFLD                    S#PTYP                                        08783
     C                   KFLD                    S#PSTP                                        08783
      *
      **  o additional schedule information; secondary recipients
      **    by account id
     C     ##KSAC        KLIST
     C******************** KFLD           ##MACT                          087834
     C                   KFLD                    S#MACT                                        08783
      *                                                                   082705
      **  o UDC reference file; to check for duplicates                   082705
     C     ##KUDC        KLIST                                                                 08270
     C                   KFLD                    DRITEM                                        08270
     C                   KFLD                    DRDCOR                                        08270
      *
     C     KMACT         KLIST                                                                 CCG02
     C                   KFLD                    ##CNUM                                        CCG02
     C                   KFLD                    ##CCY                                         CCG02
     C                   KFLD                    ##ACO                                         CCG02
     C                   KFLD                    ##ACSQ                                        CCG02
     C                   KFLD                    ##BRCA                                        CCG02
      *                                                                   CCG024
     C     KLOAN         KLIST                                                                 CCG02
     C                   KFLD                    KLNRF             6                           CCG02
     C                   KFLD                    KRCDT             1                           CCG02
      *                                                                   CCG024
      ** *LIKE definitions
     C     *LIKE         DEFINE    DRDCOR        Z#PRIM
     C     *LIKE         DEFINE    DRPRTD        Z#PRTD
     C     *LIKE         DEFINE    DRDDAT        Z#RETP
     C     *LIKE         DEFINE    DRLGID        Z#LGID
     C     *LIKE         DEFINE    CPPSCH        Z#PSCH
     C     *LIKE         DEFINE    DROVBR        Z#OVBR
     C     *LIKE         DEFINE    DRBRCA        Z#BRCA
     C     *LIKE         DEFINE    ##CUST        Z#CUST
     C     *LIKE         DEFINE    DRDCOR        Z#CORR
     C     *LIKE         DEFINE    DRISTS        Z#ISTS
     C     *LIKE         DEFINE    DRDCOR        Z#CUID
     C     *LIKE         DEFINE    DRDCOR        ##CORR
     C     *LIKE         DEFINE    DRDCOR        ##PCOR
     C     *LIKE         DEFINE    DRDCOR        ##PRIM
     C     *LIKE         DEFINE    DRDCOR        ##SAME
     C     *LIKE         DEFINE    CDCTYP        Z#CTYP                                        08207
     C     *LIKE         DEFINE    DRDCOR        D#CORR                                        08783
     C     *LIKE         DEFINE    DRPTYP        S#PTYP                                        08783
     C     *LIKE         DEFINE    DRPSTP        S#PSTP                                        08783
     C     *LIKE         DEFINE    DRMACT        S#MACT                                        08783
     C     *LIKE         DEFINE    DRPCOR        S#PRIM                                        08783
      *                                                                   087283
      * Check if any schedules for account code                           087283
      *                                                                   087283
     C******LOVAL        SETLL     @CSCHL2                                            08728 MD054955
     C**********         READ      @CSCHL2                                90          08728 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C+ where CPACCD <> '          ' and CPRECI = 'D'                                       MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C                   MOVEL     *BLANKS       ##L2NR            4                           08728
     C     *IN90         IFEQ      *ON                                                         08728
     C                   MOVEL     'None'        ##L2NR                                        08728
     C                   ENDIF                                                                 08728
      *                                                                   087283
      * Check if any schedules for account                                087283
      *                                                                   087283
     C******LOVAL        SETLL     @CSCHL3                                            08728 MD054955
     C**********         READ      @CSCHL3                                90          08728 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C+ where CPMACT <> '          ' and CPRECI = 'D'                                       MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C                   MOVEL     *BLANKS       ##L3NR            4                           08728
     C     *IN90         IFEQ      *ON                                                         08728
     C                   MOVEL     'None'        ##L3NR                                        08728
     C                   ENDIF                                                                 08728
      *                                                                   CCG004
      * Check if copy users are present                                   CCG004
      *                                                                   CCG004
     C                   MOVEL(P)  'COPY'        CDCORR                                        CCG00
     C     CDCORR        SETLL     @CORRL1                                                     CCG00
     C                   READ      @CORRL1                                90                   CCG00
      *                                                                   CCG004
      * If found check that 'COPY   ' is in record read                   CCG004
      *                                                                   CCG004
     C                   SELECT                                                                CCG00
     C     *IN90         WHENEQ    *OFF                                                        CCG00
     C     7             SUBST     CDCORR:1      ####7A            7                           CCG00
     C     ####7A        IFEQ      'COPY   '                                                   CCG00
      *                                                                   CCG004
      **  Determine which SARs are in effect ...                          CCG004
      **  ... CCG004 - Copy by System                                     CCG004
     C                   CALL      'AOSARDR0'                           91                     CCG00
     C                   PARM      '       '     ##RTCD            7                           CCG00
     C                   PARM      '*VERIFY'     ##OPTN            7                           CCG00
     C                   PARM      'CCG004'      ##SARD            6                           CCG00
     C     SCSARD        PARM      *BLANKS       DSSDY                                         CCG00
      *                                                                   CCG004
      **  If the Access Object returns an error code, process a           CCG004
      **  database error.                                                 CCG004
     C     ##RTCD        IFNE      *BLANK                                                      CCG00
     C     ##RTCD        ANDNE     '*NRF   '                                                   CCG00
     C     *IN91         OREQ      *ON                                                         CCG00
     C                   MOVEL     'AOSARDR0'    W0FILE                         ***************CCG00
     C                   MOVEL     'CCG004'      W0KEY                          * DB ERROR 04 *CCG00
     C                   Z-ADD     04            W0ERNB                         ***************CCG00
     C                   MOVEL     'MEM5003'     W0MSGD                                        CCG00
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CCG00
     C                   EXSR      SRERR                                                       CCG00
     C                   END                                                                   CCG00
      *                                                                   CCG004
     C     ##RTCD        IFEQ      *BLANK                                                      CCG00
     C                   MOVEL     'SYSTEM'      ##COPY            8                           CCG00
     C                   END                                                                   CCG00
      *                                                                   CCG004
      *                                                                   CCG004
      **  Determine which SARs are in effect ...                          CCG004
      **  ... CCG005 - Copy by Branch                                     CCG004
     C                   CALL      'AOSARDR0'                           91                     CCG00
     C                   PARM      '       '     ##RTCD                                        CCG00
     C                   PARM      '*VERIFY'     ##OPTN                                        CCG00
     C                   PARM      'CCG005'      ##SARD                                        CCG00
     C     SCSARD        PARM      *BLANKS       DSSDY                                         CCG00
      *                                                                   CCG004
      **  If the Access Object returns an error code, process a           CCG004
      **  database error.                                                 CCG004
     C     ##RTCD        IFNE      *BLANK                                                      CCG00
     C     ##RTCD        ANDNE     '*NRF   '                                                   CCG00
     C     *IN91         OREQ      *ON                                                         CCG00
     C                   MOVEL     'AOSARDR0'    W0FILE                         ***************CCG00
     C                   MOVEL     'CCG005'      W0KEY                          * DB ERROR 05 *CCG00
     C                   Z-ADD     05            W0ERNB                         ***************CCG00
     C                   MOVEL     'MEM5003'     W0MSGD                                        CCG00
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CCG00
     C                   EXSR      SRERR                                                       CCG00
     C                   END                                                                   CCG00
      *                                                                   CCG004
     C     ##RTCD        IFEQ      *BLANK                                                      CCG00
     C                   MOVEL     'BRANCH'      ##COPY                                        CCG00
     C                   END                                                                   CCG00
      *                                                                   CCG004
      *                                                                   CCG004
      **  Determine which SARs are in effect ...                          CCG004
      **  ... CCG006 - Copy by Correspondent Type                         CCG004
     C                   CALL      'AOSARDR0'                           91                     CCG00
     C                   PARM      '       '     ##RTCD                                        CCG00
     C                   PARM      '*VERIFY'     ##OPTN                                        CCG00
     C                   PARM      'CCG006'      ##SARD                                        CCG00
     C     SCSARD        PARM      *BLANKS       DSSDY                                         CCG00
      *                                                                   CCG004
      **  If the Access Object returns an error code, process a           CCG004
      **  database error.                                                 CCG004
     C     ##RTCD        IFNE      *BLANK                                                      CCG00
     C     ##RTCD        ANDNE     '*NRF   '                                                   CCG00
     C     *IN91         OREQ      *ON                                                         CCG00
     C                   MOVEL     'AOSARDR0'    W0FILE                         ***************CCG00
     C                   MOVEL     'CCG006'      W0KEY                          * DB ERROR 06 *CCG00
     C                   Z-ADD     06            W0ERNB                         ***************CCG00
     C                   MOVEL     'MEM5003'     W0MSGD                                        CCG00
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CCG00
     C                   EXSR      SRERR                                                       CCG00
     C                   END                                                                   CCG00
      *                                                                   CCG004
     C     ##RTCD        IFEQ      *BLANK                                                      CCG00
     C                   MOVEL     'CORTYPE'     ##COPY                                        CCG00
     C                   END                                                                   CCG00
      *                                                                   CCG004
      * If ##COPY not blank then copy is being used                       CCG004
      *                                                                   CCG004
     C     ##COPY        IFNE      *BLANK                                                      CCG00
     C                   MOVEL     'Yes'         ##CUSR            3                           CCG00
     C                   ELSE                                                                  CCG00
     C                   MOVEL     'No '         ##CUSR                                        CCG00
     C                   END                                                                   CCG00
      *                                                                   CCG004
     C                   ELSE                                                                  CCG00
     C                   MOVEL     'No '         ##CUSR                                        CCG00
     C                   ENDIF                                                                 CCG00
     C     *IN90         WHENEQ    *ON                                                         CCG00
     C                   MOVEL     'No '         ##CUSR                                        CCG00
     C                   ENDSL                                                                 CCG00
      *                                                                                       CCG024
      * Check if CCG024 is switched on                                                        CCG024
     C                   CALL      'AOSARDR0'
     C                   PARM                    ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CCG024'      ##SARD
      *                                                                                       CCG024
     C     ##RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CCG024            1
      *                                                                                       CCG024
      * Check System Value RecipientSpecialChar                                               CCG024
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       RTNCDE            7
     C                   PARM                    SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM      *BLANKS       SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM      *BLANKS       SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM      *BLANKS       SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM      *BLANKS       SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM      *BLANKS       SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM      *BLANKS       SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM      *BLANKS       SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM      *BLANKS       SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM      *BLANKS       SVALK0           20
     C                   PARM                    SVAL10          200
      *                                                                                       CCG024
     C     RTNCDE        IFNE      *BLANKS
     C     SVAL1         IFEQ      '*NRF'
     C                   MOVE      SVALK1        DBKEY
     C                   ENDIF
      *                                                                                       CCG024
     C                   MOVEL     'AOSVALR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 14 *
     C                   Z-ADD     21            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CCG024
     C                   ELSE
     C                   MOVE      'N'           CCG024
     C                   ENDIF
      *
     C     EXINIT        TAG
     C                   ENDSR
      /EJECT
     C*COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD054955
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD054955
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA TAB1
IMMEDIATE IMED
HOLDMAIL  HELD
**CTDATA #SCSQ
YYNY
YYYN
YYNN
YNNN
