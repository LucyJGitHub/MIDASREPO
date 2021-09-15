     H DEBUG
     F*****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*OVRF*: OVRDBF (FILE IN PROGRAM) (FILE ON SYSTEM)                  : *
/*EXI *  TEXT('Midas ME Check account on PCA')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  MEP0031 - Check account on PCAT                              *
      *                                                               *
      *  Function:  This program places the customer in the field     *
      *  from a specified account                                     *
      *                                                               *
      *                                                               *
      *  (C) Copyrignt Misys International Banking Systems 2003       *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. HVB021             Date 16Dec2011             *
      *                 HVB012             Date 02Nov2011             *
      *                 AR856737           Date 13Sep2011             *
      *                 STP200             Date 18Sep2007             *
      *                 STP100             Date 01Mar2006             *
      *                 MMFIX2             Date 21Feb2006             *
      *                 MM2302             Date 23Feb2005             *
      *                 MK0528             Date 18Feb2005             *
      *                 STP002             Date 18Jan2005             *
      *                 STP001             Date 18Jan2005             *
      *                 ESL038             Date 30Nov2004             *
      *                 E30004             Date 25Feb2004             *
      *                 PKO001             Date 23Jan2004             *
      *                 ERN054             Date 16Jul2003             *
      *                 DB0001             Date 02Jul2003             *
      *                 EEE058   *CREATE   Date 11Feb2003             *
      * Midas Release 4.01 -------------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  HVB021   - Enhance the existing account status check to      *
      *             include Referred and Blocked Debit accounts       *
      *  HVB012   - Ordering Customer entered in GL account format    *
      *             is not checked by check function *ACOK            *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level      *
      *             Update DS WUFDDT due to 10 digit Account Code     *
      *           - Removed unwanted code. Removed BISE and PL related*
      *             code.                                             *
      *  STP200 - BISE Incoming Payments                              *
      *  STP100 - Mass Payments. Check for 11 char part of IBAN       *
      *           and match with PCAT.                                *
      *  MMFIX2 - Wrong MPPYAM for Elixir network.                    *
      *  MM2302 - Use only ALL segment for CAFS                       *
      *  MK0528 - Set Segment Code also for 'OUR'                     *
      *  STP001 - Add processing for time.                            *
      *  STP002 - When Pay in Message ccy = Y, set CAFX and CAFS to F *
      *  ESL038 - ING FT STP Development                              *
      *  E30004 - Change to PCAT for account status                   *
      *           I is investigation                                  *
      *           C is Closed                                         *
      *           E is Data Error                                     *
      *  PKO001 - Zorba changes                                       *
      *  ERN054 - Agent message changes (Recompile)                   *
      *  DB0001 - Substring IBAN for search                           *
      *  EEE058 - Incoming STP idenifier is Elixir customer           *
      *                                                               *
      *****************************************************************
     F/EJECT
     FFTPCATJ1  IF   E           K DISK
      *
      *  Defaults table for accounts
      *
     FFTPCATJ0  IF   E           K DISK
      *
      *  Defaults table for accounts
      *
     FFTPCATJ3  IF   E           K DISK
      *
      *  Defaults table for accounts
      *
     FFTSEGXV1  IF   E           K DISK
      *
      *  Segment customer group x-ref
      *
     FFTRBRCV1  IF   E           K DISK
      *
      *  Retail branches for STP
      *
     FMEINMPL1  IF   E           K DISK
      *
      *  Message parts file for currency of payment and amount
      *
     FFTFXGPV1  IF   E           K DISK
      *
      *  FX Spread groups by customer group
      *
     FMEINCRL1  IF   E           K DISK                                                       STP001
      *                                                                                       STP001
      *  Midas ME I.M Control Retrieval index                                                 STP001
      *                                                                                       STP001
     FFTCCUTV0  IF   E           K DISK                                                       STP001
      *                                                                                       STP001
      *  Midas FT Currency Cut-Off Time                                                       STP001
      *                                                                                       STP001
     FFTNCOTV0  IF   E           K DISK                                                       STP001
      *                                                                                       STP001
      *  Midas FT Network  Cut-Off Time                                                       STP001
      *                                                                                       STP001
      *                                                                                       STP001
     FACCNTL10  IF   E           K DISK    Rename(ACCNTABF:ACCNTABX)                          STP001
     F                                     Prefix(R_)
      *                                                                                       STP001
      *  Midas Retail Accounts by CNUM/CCY                                                    STP001
      *                                                                                       STP001
      *                                                                                       STP001
     FSDCMRKL0  IF   E           K DISK                                                       STP001
      *                                                                                       STP001
      *  Midas Customer Marketing Info                                                        STP001
      *                                                                                       STP001
     F/EJECT
      *****************************************************************
      *
      *  Copyright table
      *
     D CPYR@#          DS
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
      *  Copyright
      *
      /COPY MECPYSRC,ME1100_ILE
      *
      *  Data Structures used by Access Objects
      *
     D P9PEXT        E DS                  EXTNAME(FTPEXTP0)
      *
      * FT PCAT extension details
      *
     D PCRIT         E DS                  EXTNAME(MEGNCRPD)
      *
      *  Return Criteria Details to calling program
      *
     D                 DS
      *
      *  Split the detail fields into field tag name and contents
      *
     D  WUFDDT                 1    256
     D  WUMTAG                 1      5
     D  WUFDIN                 6      6
     D  WUTGCK                 6    256
     D  WUTGVL                 7    256
     D**WUACCO*****            7     24                                                     AR856737
     D  WUACCO                 7     30                                                     AR856737
     D  WUCNUM                 7     12  0
     D  WUCNUA                 7     12
     D  WUCURR                13     15
     D**WUACCD*****           16     19  0                                                  AR856737
     D**WUACCA*****           16     19                                                     AR856737
     D**WUACSQ*****           20     21  0                                                  AR856737
     D**WUACSA*****           20     21                                                     AR856737
     D**WUBRCA*****           22     24                                                     AR856737
     D**WUORIG*****           25    256                                                     AR856737
     D  WUACCD                16     25  0                                                  AR856737
     D  WUACCA                16     25                                                     AR856737
     D  WUACSQ                26     27  0                                                  AR856737
     D  WUACSA                26     27                                                     AR856737
     D  WUBRCA                28     30                                                     AR856737
     D  WUORIG                31    256                                                     AR856737
     D**LINE1 *****           25     59                                                     AR856737
     D**LINE2 *****           60     94                                                     AR856737
     D**LINE3 *****           95    129                                                     AR856737
     D**LINE4 *****          130    164                                                     AR856737
     D**LINE5 *****          165    199                                                     AR856737
     D**SLASH *****           25     25                                                     AR856737
     D  LINE1                 31     65                                                     AR856737
     D  LINE2                 66    100                                                     AR856737
     D  LINE3                101    135                                                     AR856737
     D  LINE4                136    170                                                     AR856737
     D  LINE5                171    205                                                     AR856737
     D  SLASH                 31     31                                                     AR856737
      *                                                                                     AR856737
      * 6n followed by blanks
     D  CSTNBR                26     31
     D  CSTBLK                32     59
      * 7n followed by blanks
     D  CST000                26     26
     D  CSTNB2                27     32
     D  CSTP06                32     32
     D**WUO   *****           25    256                                                     AR856737
     D  WUO                   31    256                                                     AR856737
      ** For FONTIS tag 72 is bigger (no translation possible)
     D  F72                    7    246
     D**WUSWFT*****           25     35                                                     AR856737
     D**WUNSWF*****           36    256                                                     AR856737
     D**WUSWF2*****           60     70                                                     AR856737
     D**WUNSW2*****           71    256                                                     AR856737
     D  WUSWFT                31     41                                                     AR856737
     D  WUNSWF                42    256                                                     AR856737
     D  WUSWF2                66     76                                                     AR856737
     D  WUNSW2                77    256                                                     AR856737
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * External Data structure to hold the outgoing record format
      * of the file.
     D D@ACCT        E DS                  EXTNAME(ACCNTAB)
      * ACCNTABF - Account details record format data structure
      *
     D D@UACC        E DS                  EXTNAME(MEUACCP0)
      * MEUACCP0 - default currency account
      *
      *
     D D@CUST        E DS                  EXTNAME(SDCUSTPD)
      * SDCUSTPD - Customer details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * SDBANKPD - Bank details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      * Data Structures for Currency Definition
      *
      * Received date and time as 14 long field                                               STP001
      *                                                                                       STP001
     D RCCOMP          DS            14                                                       STP001
     D  RCCNTY                 1      2  0                                                    STP001
     D  RCDATE                 3      8  0                                                    STP001
     D  RCYEAR                 3      4  0                                                    STP001
     D  RCDATA                 3      8  0                                                    STP001
     D  RCTIME                 9     12  0                                                    STP001
     D  RCSECS                13     14  0                                                    STP001
      *                                                                                       STP001
      * Compare date and time as 14 long field                                                STP001
      *                                                                                       STP001
     D CODAY           DS            14                                                       STP001
     D  CODATE                 1      8  0                                                    STP001
     D  COTIME                 9     14  0                                                    STP001
     D  COHOMI                 9     12  0                                                    STP001
     D  COSECS                13     14  0                                                    STP001
      *                                                                                       STP001
     D D#DTA           DS           256
      *
      *  Calling parameter data structure for AOCCYCV0
      *
      *                                       From Currency & amount
     D  D#FCCY                 1      3
     D  D#FAMT                 4     11P 0
      *                                       To Currency & amount
     D  D#TCCY                12     14
     D  D#TAMT                15     22P 0
      *                                       Rate and multi/div ind.
     D  D#MDIN                23     23
     D  D#RATE                24     36P 8
      *                            Output     Rate and multi/div ind.
      *                                       If no in rate
     D  O#MDIN                37     37
     D  O#RATE                38     50P 8
      *
      *
     D DIGITS          C                   CONST('0123456789')
      *
     D INGLACC         DS            24                                                      HVB012
     D K#CNUM                  1      6  0                                                   HVB012
     D K#CNUMA                 1      6                                                      HVB012
     D K#ACOD                  7     16  0                                                   HVB012
     D K#ACODA                 7     16                                                      HVB012
     D K#ACSQ                 17     18  0                                                   HVB012
     D K#ACSQA                17     18                                                      HVB012
     D K#BRCA                 19     21                                                      HVB012
     D K#CCY                  22     24                                                      HVB012
     D AccountL1               1     24                                                      HVB012
     D ACC22                  23     24                                                      HVB012
      *
     D W#PDCA          DS            60                                                      HVB012
     D W#CCY                  37     39                                                      HVB012
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          BIS@             80
      *
     C     *LIKE         DEFINE    WUTGCK        P@IN
      *
     C     *ENTRY        PLIST
     C                   PARM                    P#RETN            7
     C     WUFDDT        PARM                    P@IN
     C                   PARM                    P#PTTN           32
     C                   PARM                    GDOPER            2
     C                   PARM                    PHEAD                          General Details
     C                   PARM                    PDATA                          Message Details
     C                   PARM                    PDAT2                          Message Details
     C                   PARM                    PCRIT
      * If true put T
     C                   MOVEL     'F'           P#RETN
     C                   MOVE      'N'           A#PCAT            1
     C                   MOVE      'N'           DIRMAT            1
      *
     C     KPCATA        KLIST
     C                   KFLD                    PCRNB1
      *
     C     KPCAT1        KLIST
     C                   KFLD                    PCRNB1
     C                   KFLD                    PCRNB2
      *
     C     KPCAT2        KLIST
     C                   KFLD                    PCIBAN
      *
      ** Full GL Account                                                                     HVB012
     C     KGLACC        KLIST                                                               HVB012
     C*****              KFLD                    K#CNUM                             HVB012   MD31937
     C                   KFLD                    K#CNUMA                                     MD31937
     C                   KFLD                    K#CCY                                       HVB012
     C                   KFLD                    K#ACOD                                      HVB012
     C                   KFLD                    K#ACSQ                                      HVB012
     C                   KFLD                    K#BRCA                                      HVB012
      *                                                                                      HVB012
      * Look for account in all 5 lines of Beneficiary (4 for Ordering Customer)
      *
     C                   Z-ADD     0             #LINE             1 0
     C                   MOVE      'N'           MATCH             1
      *  Convert string
      *
     C     1             SUBST     LINE1:1       U#0001            1
     C     U#0001        IFEQ      '/'
     C     34            SUBST(P)  LINE1:2       I#ACLN           35
     C                   ELSE
     C     34            SUBST(P)  LINE1:1       I#ACLN
     C                   ENDIF
     C                   CALL      'FTP970'
     C                   PARM      *BLANKS       @RTN              7
     C                   PARM                    I#ACLN           35
     C                   PARM      *BLANKS       O#ACLN1          35
      *
      *  Get customer details
     C                   MOVEL     *BLANK        EXTMATCH          1
     C                   Movel(p)  O#ACLN1       @W_AccLn         35
      *
     C                   EXSR      CheckAccount
      *
      *   Not Found Repeat for line 2,3,4,5 (Beneficiary only)
      *
     C     *IN90         IFEQ      *ON
      *
      *  Convert string
      *
     C     1             SUBST     LINE2:1       U#0001            1
     C     U#0001        IFEQ      '/'
     C     34            SUBST(P)  LINE2:2       I#ACLN           35
     C                   ELSE
     C     34            SUBST(P)  LINE2:1       I#ACLN
     C                   ENDIF
     C                   CALL      'FTP970'
     C                   PARM      *BLANKS       @RTN              7
     C                   PARM                    I#ACLN           35
     C                   PARM      *BLANKS       O#ACLN2          35
      *
      *  Get customer details
     C                   MOVEL     *BLANK        EXTMATCH          1
     C                   Movel(p)  O#ACLN2       @W_AccLn
     C                   Move      *BLANKS       INGLACC                                     HVB012
     C                   MoveL     @W_AccLn      INGLACC                                     HVB012
     C                   EXSR      CheckAccount
      *
      *
      *
     C     *IN90         IFEQ      *ON
      *
      *  Convert string
      *
     C     1             SUBST     LINE3:1       U#0001            1
     C     U#0001        IFEQ      '/'
     C     34            SUBST(P)  LINE3:2       I#ACLN           35
     C                   ELSE
     C     34            SUBST(P)  LINE3:1       I#ACLN
     C                   ENDIF
     C                   CALL      'FTP970'
     C                   PARM      *BLANKS       @RTN              7
     C                   PARM                    I#ACLN           35
     C                   PARM      *BLANKS       O#ACLN3          35
      *
      *  Get customer details
     C                   MOVEL     *BLANK        EXTMATCH          1
     C                   Movel(p)  O#ACLN3       @W_AccLn
     C                   EXSR      CheckAccount
      *
     C     *IN90         IFEQ      *ON
      *
      *  Convert string
      *
     C     1             SUBST     LINE4:1       U#0001            1
     C     U#0001        IFEQ      '/'
     C     34            SUBST(P)  LINE4:2       I#ACLN           35
     C                   ELSE
     C     34            SUBST(P)  LINE4:1       I#ACLN
     C                   ENDIF
     C                   CALL      'FTP970'
     C                   PARM      *BLANKS       @RTN              7
     C                   PARM                    I#ACLN           35
     C                   PARM      *BLANKS       O#ACLN4          35
      *
      *  Get customer details
     C                   MOVEL     *BLANK        EXTMATCH          1
     C                   Movel(p)  O#ACLN4       @W_AccLn
     C                   EXSR      CheckAccount
      *
      *
     C     *IN90         IFEQ      *ON
     C     WUMTAG        ANDEQ     ':59:'
      *
      *  Convert string
      *
     C     1             SUBST     LINE5:1       U#0001            1
     C     U#0001        IFEQ      '/'
     C     34            SUBST(P)  LINE5:2       I#ACLN           35
     C                   ELSE
     C     34            SUBST(P)  LINE5:1       I#ACLN
     C                   ENDIF
     C                   CALL      'FTP970'
     C                   PARM      *BLANKS       @RTN              7
     C                   PARM                    I#ACLN           35
     C                   PARM      *BLANKS       O#ACLN5          35
      *
      *  Get customer details
     C                   MOVEL     *BLANK        EXTMATCH          1
     C                   Movel(p)  O#ACLN5       @W_AccLn
     C                   EXSR      CheckAccount
      *                                                                                       PKO001
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * If Found and Direct Match
      *
     C     *IN90         IFEQ      *OFF
     C     DIRMAT        ANDEQ     'Y'
      *   Check if on PCAT
     C                   Movel(p)  IBAN          PCIBAN
     C     KPCAT2        CHAIN     @PCATJ0                            80
     C     *IN80         IFEQ      *OFF
     C                   MOVE      'Y'           A#PCAT
     C                   ENDIF
     C                   ENDIF
      *
      *
      **  Map PCAT work fields                                                                ESL038
     C                   EXSR      SRMAPP
      *
      *
      *  If Found on PCAT then check if Pay in Message currency
      *  If Yes, the find Default Account in message currency. If not Found then
      *  Beneficary account not valid
      *
     C     *IN90         IFEQ      *OFF
     C     A#PCAT        ANDEQ     'Y'
      *
     C                   IF        (PCIMCY = 'Y' and GNMTPY = '103')
     C                             OR (PCIMCY = 'Y' and GNMTPY = 'E33')
     C                             OR (PCIMCY = 'Y' and GNMTPY = 'E32')
      *
     C                   MOVEL(P)  PDCA          DSTRAN
     C                   MOVEL     TVCCY         W@CCY             3
      * Save Original IBAN
     C                   MOVEL(P)  PCIBAN        T@IBAN           34
     C                   MOVEL(P)  PCRNB1        T@RNB1           16
     C                   MOVEL(P)  PCRNB2        T@RNB2           18
      *
     C     KACCT         KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    W@CCY
      *
     C     KPCAT3        KLIST
     C                   KFLD                    R_IBAN
      *
     C                   Move      'N'           Default           1
     C     *LOVAL        SETLL     ACCNTL10
     C     KACCT         READE     ACCNTL10
     C                   DoW       (not %EOF) and (Default <> 'Y')
      *
     C     KPCAT3        CHAIN     @PCATJ0
     C                   IF        %Found and PCDACC = 'Y'
     C                   Eval      Default = 'Y'
     C                   Endif
      *
     C                   IF        Default <> 'Y'
     C     KACCT         READE     ACCNTL10
     C                   Endif
      *
     C                   Enddo
      *
     C                   IF        Default <> 'Y'
     C                   SETON                                            90
     ***                 MOVEL     'F'           P#RETN
     C                   ENDIF
      **  Map PCAT work fields                                                                ESL038
     C
     C     *IN90         IFEQ      *OFF
     C                   EXSR      SRMAPP
     C                   Endif
      *
     C                   ENDIF
      *
     C                   ENDIF

      *
     C   U1              DUMP
      *
      * Depending on action do
      *
     C                   MOVE      P#PTTN        U#ACT             5
     C                   SELECT
      * Check PCAT is correct
     C     U#ACT         WHENEQ    '*ACOK'
     C                   EXSR      SRCAOK
      * Check for PCAT Standard commission
     C     U#ACT         WHENEQ    '*ACSC'
     C     *IN90         ANDEQ     *OFF
      * Add test for No charge and Individual commission                                      EEE058
     C     U#ACT         WHENEQ    '*ACNC'
     C     *IN90         ANDEQ     *OFF
     C     U#ACT         WHENEQ    '*ACIC'
     C     *IN90         ANDEQ     *OFF
     C                   EXSR      SRCASC
      * Check for STP branch
     C     U#ACT         WHENEQ    '*ACBR'
     C     *IN90         ANDEQ     *OFF
     C                   EXSR      SRCABR
      * Check for STP branch with IBAN
     C     U#ACT         WHENEQ    '*ACIB'
     C     *IN90         ANDEQ     *ON
     C                   EXSR      SRCAIB
      * Check for Strategic STP branch with IBAN
     C     U#ACT         WHENEQ    '*ACSB'
      ***  *IN90         ANDEQ     *ON
     C                   EXSR      SRCASB
      * Test for FX
     C     U#ACT         WHENEQ    '*ACFX'
     C     *IN90         ANDEQ     *OFF
     C                   EXSR      SRCAFX
      * Test for FX for MultiCash
     C     U#ACT         WHENEQ    '*MCFX'
     C     *IN90         ANDEQ     *OFF
     C                   EXSR      SRMCFX
      * Test for pensioner
     C     U#ACT         WHENEQ    '*PENR'
     C     *IN90         ANDEQ     *OFF
     C                   EXSR      SRPENR
      * Test for FX, FX spread rate and dealer intervention
     C     U#ACT         WHENEQ    '*ACFS'
     C     *IN90         ANDEQ     *OFF
     C                   EXSR      SRCAFS
      * Test for FX, FX spread rate and dealer intervention  for MultiCash
     C     U#ACT         WHENEQ    '*MCFS'
     C     *IN90         ANDEQ     *OFF
     C                   EXSR      SRMCFS
      * Test for PCAT Status                                                                  E30004
      *                                                                                       E30004
     C     U#ACT         WHENEQ    '*AC?C'
     C     *IN90         ANDEQ     *OFF
     C     U#ACT         OREQ      '*AC?E'
     C     *IN90         ANDEQ     *OFF
     C     U#ACT         OREQ      '*AC?I'
     C     *IN90         ANDEQ     *OFF
     C     U#ACT         OREQ      '*AC?A'
     C     *IN90         ANDEQ     *OFF
     C                   EXSR      SRCASS
      * Test for special routing                                                              E30004
      *                                                                                       E30004
     C     U#ACT         WHENEQ    '*ACSR'
     C     *IN90         ANDEQ     *OFF
     C                   EXSR      SRCASR
      * Test for cut off time for given account for Incoming Payments                         STP001
      *                                                                                       STP001
     C     U#ACT         WHENEQ    '*ACIT'                                                    STP001
     C     *IN90         ANDEQ     *OFF                                                       STP001
     C                   EXSR      SRCAIT                                                     STP001
      * Test for cut off time for given account for Outgoing Payments                         STP001
      *                                                                                       STP001
     C     U#ACT         WHENEQ    '*ACOT'                                                    STP001
     C     *IN90         ANDEQ     *OFF                                                       STP001
     C                   EXSR      SRCAOT                                                     STP001
      * Test for cut off time for ccy/segment/network/msg type combination                    STP001
      *                                                                                       STP001
     C     U#ACT         WHENEQ    '*ACCT'                                                    STP001
     C                   EXSR      SRCACT                                                     STP001
     C                   ENDSL
      * Check account etc
      *
     C   U1              DUMP
      *
      *  Exit program
      *
     C                   RETURN
     C/EJECT
      *****************************************************************
      *                                                               *
      *  CheckAccount   :   Check if Midas Account                    *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   CheckAccount  BEGSR
      * Check account etc
      *
     C                   Move      'N'           BISE              1
      *
     C     @W_AccLn      IFNE      *Blanks
      *                                                                                      HVB012
      *  Check if GL Account - If more than 10 char entered (Branch @ position 19-21)        HVB012
     C                   MOVE      '1'           *IN90                                       HVB012
     C                   MOVE      *BLANKS       INGLACC                                     HVB012
     C                   MOVEL(P)  @W_AccLn      INGLACC                                     HVB012
     C     K#BRCA        IfNe      *BLANKS                                                   HVB012
     C                   EXSR      ValGLAccount                                              HVB012
     C                   EndIf                                                               HVB012
      *                                                                                      HVB012
     C     *IN90         IFEQ      *ON                                                       HVB012
      *                                                                                      HVB012
      *  Check if Retail
      *****                                                                               AR856737
     C*****              MOVEL(P)  @W_AccLn      @W6               6                      AR856737
     C*****              IF        @W6 = '300000'                                         AR856737
     C*****10            SUBST(P)  @W_AccLn:7    @RETL                                    AR856737
     C*****              ELSE                                                             AR856737
     C                   MOVEL(P)  @W_AccLn      @RETL
     C*****              ENDIF                                                            AR856737
      *
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       @RTCD             7            B:Return Cd
     C                   PARM      '*KEY'        @OPTN             7            B:Option
     C                   PARM                    @RETL            10            I:Account Identifier
     C                   PARM      *BLANKS       @CNNM             6            I:Customer Number
     C                   PARM      *BLANKS       @CUCD             3            I:Currency Code
     C*****              PARM      *BLANKS       @ACCD             4  I:Account Code Num  AR856737
     C                   PARM      *BLANKS       @ACCD            10            I:Account AR856737
     C                   PARM      *BLANKS       @ACSQ             2            I:Account Sequence
     C                   PARM      *BLANKS       @BRCD             3            I:Branch code
     C     D@ACCT        PARM      D@ACCT        DSSDY                          O:Format
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           DIRMAT
     C                   SETOFF                                       90
     C                   ELSE
     C                   SETON                                        90
     C                   ENDIF
      *
     C                   ENDIF                                                               HVB012
      *                                                                                      HVB012
     C     *IN90         IFEQ      *ON
      *
      *  Check if IBAN
      *
      *****    Check if Country Code PL, if not add it                                      AR856737
      *
     C                   MOVEL(P)  @W_AccLn      @W1               1
     C                   MOVEL(P)  @W_AccLn      @W2               2
     C                   MOVEL(P)  @W_AccLn      @W3               3
      *
     C                   SELECT
     C                   WHEN      @W1 = '.'
     C     33            SUBST(P)  @W_AccLn:2    W@IBAN           34
     C                   WHEN      @W2 = 'AC'
     C     32            SUBST(P)  @W_AccLn:3    W@IBAN
     C                   WHEN      @W3 = 'ACC'
     C     31            SUBST(P)  @W_AccLn:4    W@IBAN
     C                   WHEN      @W3 = 'AC-'
     C     31            SUBST(P)  @W_AccLn:4    W@IBAN
     C                   OTHER
     C                   Movel(p)  @W_AccLn      W@IBAN
     C                   ENDSL
      *
      *
     C*****              MOVEL(P)  W@IBAN        W@CTRY            2                        AR856737
     C*****W@CTRY        IFNE      'PL'                                                     AR856737
     C*****              MOVEL     'PL'          W@CTRY                                     AR856737
     C*****              MOVE      *BLANKS       P@IBAN           36                        AR856737
     C*****              MOVE      W@IBAN        P@IBAN                                     AR856737
     C*****              MOVEL     W@CTRY        P@IBAN                                     AR856737
     C*****              MOVE      *BLANKS       W@IBAN                                     AR856737
     C*****              MOVEL     P@IBAN        W@IBAN                                     AR856737
     C*****              ENDIF                                                              AR856737
      *
      * Repair Check Digit
      *
     C     2             SUBST(P)  W@IBAN:1      ISO               2
      *** Call AOIBANR0 to validate the IBAN check digits                 CFT004
      *                                                                   CFT004
     C                   Movel     *Blanks       P@IBAN           36
     C                   CALL      'AOIBANR5'                                                  CFT00
     C                   PARM      *BLANKS       @RTCD                                         CFT00
     C                   PARM      W@IBAN        P@IBAN                                        CFT00
      *
     C     @RTCD         IFEQ      '5'
     C                   CALL      'AOIBANR0'                                                  CFT00
     C                   PARM      *BLANKS       @RTCD                                         CFT00
     C                   PARM      'V'           IACTN             1                           CFT00
     C                   PARM      ISO           ICNTY             2                           CFT00
     C                   PARM      W@IBAN        IIBANP           34                           CFT00
     C                   PARM                    OBBAN            30                           CFT00
     C                   PARM      *Blanks       OIBAN            34                           CFT00
     C                   PARM                    OCKDG             2                           CFT00
     C                   Movel(p)  OIBAN         W@IBAN
      *                                                                   CFT004
     C                   Endif
      *
     C                   CALL      'AOIBANR4'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    W@IBAN
     C     D@ACCT        PARM      *BLANKS       DSSDY
      *
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           DIRMAT
     C                   SETOFF                                       90
     C                   ELSE
     C                   SETON                                        90
     C                   ENDIF
      *
     C     *IN90         IFEQ      *ON
      *
      * Check PCAT database
      *
      *  Get customer details
      *
     C     16            SUBST(P)  @W_AccLn:1    PCRNB1
     C     18            SUBST(P)  @W_AccLn:17   PCRNB2
     C     KPCAT1        CHAIN     @PCATJ1                            90
     C     *IN90         IFEQ      *ON
     C                   EXSR      PMATCH
     C                   ENDIF
      *
      *****   Check for Mass Payment account                                                AR856737
     C******IN90         IFEQ      *ON                                                      AR856737
      *
      * Check if Valid Iban
     C*****2             SUBST(P)  @W_AccLn      W@CTRY                                     AR856737
     C*****W@CTRY        IFNE      'PL'                                                     AR856737
     C*****'PL'          CAT(P)    @W_AccLn:0    @@ACCLN          37                        AR856737
     C*****              Movel(p)  @@ACCLN       P@IBAN                                     AR856737
     C*****              ELSE                                                               AR856737
     C*****              Movel(p)  @W_AccLn      P@IBAN                                     AR856737
     C*****              ENDIF                                                              AR856737
      *****                                                                                 AR856737
     C*****              CALL      'AOIBANR5'                                                 ECFT00
     C*****              PARM      *BLANKS       @RTCD                                        ECFT00
     C*****              PARM                    P@IBAN                                       ECFT00
      *****                                                                                 AR856737
     C*****@RTCD         IFEQ      *BLANKS                                                  AR856737
      *****                                                                                 AR856737
     C*****W@CTRY        IFEQ      'PL'                                                     AR856737
     C*****12            SUBST(P)  @W_AccLn:5    PCRNB1                                     AR856737
     C*****              Else                                                               AR856737
     C*****12            SUBST(P)  @W_AccLn:3    PCRNB1                                     AR856737
     C*****              Endif                                                              AR856737
     C*****              Move      *Blanks       PCRNB2                                     AR856737
      *****                                                                                 AR856737
     C*****KPCAT1        CHAIN     @PCATJ1                            90                    AR856737
     C******IN90         IFEQ      *OFF                                                     AR856737
     C*****              Move      'Y'           MASS              1                        AR856737
     C*****              Else                                                               AR856737
     C*****              Move      'N'           MASS                                       AR856737
     C*****              Endif                                                              AR856737
     C*****              Endif                                                              AR856737
      *****                                                                                 AR856737
      **Check for BISE Payment account                                          STP200      AR856737
     C******IN90         IFEQ      *ON                                          STP200      AR856737
      *****                                                                     STP200      AR856737
      **Check if Valid Iban                                                     STP200      AR856737
     C*****2             SUBST(P)  @W_AccLn      W@CTRY                         STP200      AR856737
     C*****W@CTRY        IFNE      'PL'                                         STP200      AR856737
     C*****'PL'          CAT(P)    @W_AccLn:0    @@ACCLN          37            STP200      AR856737
     C*****              Movel(p)  @@ACCLN       P@IBAN                         STP200      AR856737
     C*****              ELSE                                                   STP200      AR856737
     C*****              Movel(p)  @W_AccLn      P@IBAN                         STP200      AR856737
     C*****              ENDIF                                                  STP200      AR856737
      *****                                                                     STP200      AR856737
     C*****              CALL      'AOIBANR5'                                   STP200      AR856737
     C*****              PARM      *BLANKS       @RTCD                          STP200      AR856737
     C*****              PARM                    P@IBAN                         STP200      AR856737
      *****                                                                     STP200      AR856737
     C*****@RTCD         IFEQ      *BLANKS                                      STP200      AR856737
     C*****3             SUBST(P)  P@IBAN:5      BiseBank          3            STP200      AR856737
     C*****              If        BiseBank = '137'                             STP200      AR856737
     C*****                        or BiseBank = '237'                          STP200      AR856737
     C*****                        or BiseBank = '232'                          STP200      AR856737
     C*****              Move      'Y'           BISE              1            STP200      AR856737
     C*****              Setoff                                       90                    AR856737
     C*****              Else                                                   STP200      AR856737
     C*****              Move      'N'           BISE                           STP200      AR856737
     C*****              Endif                                                  STP200      AR856737
     C*****              Endif                                                  STP200      AR856737
      *****                                                                     STP200      AR856737
     C*****              Endif                                                  STP200      AR856737
      *****                                                                                 AR856737
     C******IN90         IFEQ      *ON                                                      AR856737
     C*****              MOVEL     'F'           P#RETN                                     AR856737
     C*****              ELSE                                                               AR856737
     C*****MASS          IFNE      'Y'                                                      AR856737
     C*****BISE          ANDNE     'Y'                                          STP200      AR856737
     C*****              CALL      'AOIBANR4'                                               AR856737
     C*****              PARM      *BLANKS       P@RTCD            7                        AR856737
     C*****              PARM      '*KEY   '     P@OPTN            7                        AR856737
     C*****              PARM                    PCIBAN                                     AR856737
     C*****D@ACCT        PARM      *BLANKS       DSSDY                                      AR856737
      *****                                                                                 AR856737
     C*****P@RTCD        IFEQ      *BLANKS                                                  AR856737
     C*****              SETOFF                                       90                    AR856737
     C*****              MOVE      'Y'           A#PCAT                                     AR856737
     C*****              ELSE                                                               AR856737
     C*****              MOVEL     'F'           P#RETN                                     AR856737
     C*****              SETON                                        90                    AR856737
     C*****              ENDIF                                                              AR856737
     C*****              ELSE                                                               AR856737
     C*****              MOVE      'Y'           A#PCAT                                     AR856737
     C*****              ENDIF                                                              AR856737
     C*****                                                                                 AR856737
      *
     C*****              ENDIF                                                              AR856737
     C*****              ENDIF                                                              AR856737
     C                   ENDIF
     C                   ENDIF
      *
     C                   Else
      *
     C                   SETON                                        90
      *
     C                   ENDIF
      ***
      *
      *
     CSR                 ENDSR
      *****************************************************************                       HVB012
      *                                                               *                       HVB012
      *  VALGLAccount   :   Check if Midas Account                    *                       HVB012
      *                                                               *                       HVB012
      *  CALLED BY: Main processing                                   *                       HVB012
      *                                                               *                       HVB012
      *****************************************************************                       HVB012
     CSR   ValGLAccount  BEGSR                                                                HVB012
      *                                                                                       HVB012
     C                   MoveL     PDCA          W#PDCA                                       HVB012
     C                   MoveL     W#CCY         K#CCY                                        HVB012
      *                                                                                       HVB012
     C***  KGLACC        Chain     ACCNTL10                           75                      HVB012
     C***  *IN75         Ifeq      *OFF                                                       HVB012
     C***                MOVE      'Y'           DIRMAT                                       HVB012
     C***                SETOFF                                       90                      HVB012
     C***                ELSE                                                                 HVB012
     C***                SETON                                        90                      HVB012
     C***                ENDIF                                                                HVB012
      *                                                                                       HVB012
     C                   CALL      'AOACCTR0'                                                 HVB012
     C                   Parm      *Blanks       @RTCD                                        HVB012
     C                   Parm      '*KEY'        @OPTN                                        HVB012
     C                   Parm      *Blanks       @RETL                                        HVB012
     C                   Parm                    K#CNUMA                                      HVB012
     C                   Parm                    K#CCY                                        HVB012
     C                   Parm                    K#ACODA                                      HVB012
     C                   Parm                    K#ACSQA                                      HVB012
     C                   Parm                    K#BRCA                                       HVB012
     C     D@ACCT        PARM      D@ACCT        DSSDY                          O:Format      HVB012
      *                                                                                       HVB012
     C     @RTCD         Ifeq      *Blanks                                                    HVB012
     C                   MOVE      'Y'           DIRMAT                                       HVB012
     C                   SETOFF                                       90                      HVB012
     C                   ELSE                                                                 HVB012
     C                   SETON                                        90                      HVB012
     C                   ENDIF                                                                HVB012
      *                                                                                       HVB012
     CSR                 ENDSR                                                                HVB012
     C/EJECT                                                                                  HVB012
      *****************************************************************
      *                                                               *
      *  SRCAOK   : Check PCAT data                                   *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCAOK        BEGSR
      * Check account etc
     C                   SELECT
     C     GDOPER        WHENEQ    'NE'
     C     *IN90         ANDEQ     *OFF
     C                   MOVEL     'T'           P#RETN
     C     GDOPER        WHENEQ    'EQ'
     C     *IN90         ANDEQ     *OFF
     C                   MOVEL     'T'           P#RETN
      * get present data
     C                   CALL      'FTP960'
     C                   PARM      *BLANKS       P9RTN             7
     C                   PARM                    P9PEXT
      * update data
     C***  PCIMCY        IFEQ      'Y'                                                        STP001
     C***  GNMTPY        ANDEQ     '103'
     C***                MOVEL     T@IBAN        PXIBAN                                       STP001
     C***                MOVEL     T@RNB1        PXRNB1
     C***                MOVEL     T@RNB2        PXRNB2
     C***                ELSE                                                                 STP001
     C                   MOVEL     PCIBAN        PXIBAN
     C                   MOVEL     PCRNB1        PXRNB1
     C                   MOVEL     PCRNB2        PXRNB2
     C                   If        BISE = 'Y'                                                 STP200
     C                   Movel(p)  P@IBAN        PXIBAN                                       STP200
     C                   Endif                                                                STP200
     C***                ENDIF                                                                STP001
     C                   MOVEL     'Y'           PXPCAT
     C                   CALL      'FTP960'
     C                   PARM      'STORE  '     P9RTN             7
     C                   PARM                    P9PEXT
      * Store customer group information
      *
     C                   Move      *Zeros        W@CNUM            6
     C                   Move      CNUM          W@CNUM
     C     W@CNUM        CHAIN     SDCMRKL0
     C                   If        %Found  and BISE <> 'Y'                                    STP200
     C                   Move      D7GPC1        SXGPCD
     C                   Else
     C                   Move      *Blanks       SXGPCD
     C                   Endif
     C
      *
     C     *IN90         IFEQ      *OFF
      * get present data
     C                   CALL      'FTP960'
     C                   PARM      *BLANKS       P9RTN             7
     C                   PARM                    P9PEXT
      * 71A contents - look if OUR
     C                   MOVEL(P)  P71           DSTRAN
     C                   MOVEL     TMLIN1        ##F71A            3
      * update data
     C                   SELECT
     C     P#COMI        WHENEQ    'N'
     C*****##F71A        OREQ      'OUR'                                                      MK0538
     C                   MOVEL     *BLANKS       PXGPCD
     C     P#COMI        WHENEQ    'I'
     C                   MOVEL     *BLANKS       PXGPCD
     C                   Z-ADD     P#COMA        PXCOMA
     C                   OTHER
     C                   MOVEL     SXGPCD        PXGPCD
     C                   ENDSL
      *
      *    Get Date Offset Code from Currency/Segment/Network/Message Type table
      *
     C     PHMSGR        CHAIN     @INCRL1                            91                      STP001
      *                                                                                       STP001
      * When message not found - skip the rest of processing                                  STP001
      *                                                                                       STP001
     C     *IN91         IFEQ      *OFF                                                       STP001
      *                                                                                       STP001
      * get part information                                                                  STP001
      *                                                                                       STP001
     C                   Z-ADD     PHMSGR        MPMSGR                                       STP001
     C                   Z-ADD     PHPART        MPKPRT                                       STP001
      * get data                                                                              STP001
     C     KINMP         CHAIN     @INMPL1                            91                      STP001
      *                                                                                       STP001
      * When message not found - skip the rest of processing                                  STP001
      *                                                                                       STP001
     C     *IN91         IFEQ      *OFF                                                       STP001
      *                                                                                       STP001
     C                   MOVEL     MPCYCD        ##CYCD                                       STP001
     C                   MOVEL     SXGPCD        ##BGPC                                       STP001
     C                   MOVEL     GNNWRK        ##NWRK                                       STP001
     C                   MOVEL     GNMTPY        ##MTPY                                       STP001
      *                                                                                       STP001
      * Access time cut off definition for ccy/segment/network/msg type combination...        STP001
      * ...for accounts found in PCAT                                                         STP001
      *                                                                                       STP001
     C     FTCCUT        CHAIN     @CCUTV0                            91                      STP001
      *                                                                                       STP001
     C     *IN91         IFEQ      *ON                                                        STP001
      *                                                                                       STP001
     C                   MOVEL     '*ALL'        ##BGPC                                       STP001
      *                                                                                       STP001
     C     FTCCUT        CHAIN     @CCUTV0                            91                      STP001
      *                                                                                       STP001
     C                   ENDIF                                                                STP001
      *                                                                                       STP001
      * When definition not found - skip the rest of processing                               STP001
      *                                                                                       STP001
     C     *IN91         IFEQ      *OFF                                                       STP001
     C     CCIDOC        ANDNE     *BLANKS                                                    STP001
     C                   MOVEL     CCIDOC        PXDOCD                                       STP001
     C                   ENDIF                                                                STP001
      *                                                                                       STP001
     C                   ENDIF                                                                STP001
      *                                                                                       STP001
     C                   ENDIF                                                                STP001
      *                                                                                       STP001
     C     P#IDOC        IFNE      *BLANKS                                                    STP001
     C                   MOVEL     P#IDOC        PXDOCD                                       STP001
     C                   ENDIF                                                                STP001
      *                                                                                       STP001
     C                   CALL      'FTP960'
     C                   PARM      'STORE  '     P9RTN             7
     C                   PARM                    P9PEXT
     C                   ENDIF
      *
     C                   ENDSL
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCASC   : Check PCAT standard commission                    *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCASC        BEGSR
      * Standard commission
     C                   SELECT
     C     P#COMI        WHENEQ    'S'
     C     U#ACT         ANDEQ     '*ACSC'
     C     P#COMI        OREQ      ' '
     C     U#ACT         ANDEQ     '*ACSC'
     C     P#COMI        OREQ      'I'
     C     U#ACT         ANDEQ     '*ACIC'
     C     P#COMI        OREQ      'N'
     C     U#ACT         ANDEQ     '*ACNC'
     C                   MOVEL     'T'           P#RETN
     C                   ENDSL
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCABR   : Check PCAT branch for STP                         *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCABR        BEGSR
      *
     C     KRBRC         KLIST
     C                   KFLD                    RBBRCH
      *
     C     A#PCAT        IFEQ      'Y'
     C                   MOVEL     PCBBRC        RBBRCH
     C                   ELSE
     C     8             SUBST     IBAN:5        RBBRCH
     C                   ENDIF
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCAIB   : Check IBAN branch for STP                         *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCAIB        BEGSR
      *
     C                   Movel(p)  O#ACLN1       @W1
     C                   Movel(p)  O#ACLN1       @W2
     C                   Movel(p)  O#ACLN1       @W3
      *
     C                   SELECT
     C                   WHEN      @W1 = '.'
     C     34            SUBST(P)  O#ACLN1:2     W@LINE           35
     C                   WHEN      @W2 = 'AC'
     C     33            SUBST(P)  O#ACLN1:3     W@LINE
     C                   WHEN      @W3 = 'ACC'
     C     32            SUBST(P)  O#ACLN1:4     W@LINE
     C                   WHEN      @W3 = 'AC-'
     C     32            SUBST(P)  O#ACLN1:4     W@LINE
     C                   OTHER
     C                   Movel(p)  O#ACLN1       W@LINE
     C                   ENDSL
      *
      * Test for  nnbbbbbbbb
     C     8             SUBST(P)  W@LINE:3      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   GOTO      EXCAIB
     C                   ENDIF
      * Test for  PLnnbbbbbbbb
     C     8             SUBST(P)  W@LINE:5      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   GOTO      EXCAIB
     C                   ENDIF
      * Test for  bbbbbbbb
     C     8             SUBST(P)  W@LINE:1      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   GOTO      EXCAIB
     C                   ENDIF
      *
      *
     C                   Movel(p)  O#ACLN2       @W1
     C                   Movel(p)  O#ACLN2       @W2
     C                   Movel(p)  O#ACLN2       @W3
      *
     C                   SELECT
     C                   WHEN      @W1 = '.'
     C     34            SUBST(P)  O#ACLN2:2     W@LINE           35
     C                   WHEN      @W2 = 'AC'
     C     33            SUBST(P)  O#ACLN2:3     W@LINE
     C                   WHEN      @W3 = 'ACC'
     C     32            SUBST(P)  O#ACLN2:4     W@LINE
     C                   WHEN      @W3 = 'AC-'
     C     32            SUBST(P)  O#ACLN2:4     W@LINE
     C                   OTHER
     C                   Movel(p)  O#ACLN2       W@LINE
     C                   ENDSL
      *
      * Test for  nnbbbbbbbb
     C     8             SUBST(P)  W@LINE:3      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   GOTO      EXCAIB
     C                   ENDIF
      * Test for  PLnnbbbbbbbb
     C     8             SUBST(P)  W@LINE:5      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   GOTO      EXCAIB
     C                   ENDIF
      * Test for  bbbbbbbb
     C     8             SUBST(P)  W@LINE:1      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   GOTO      EXCAIB
     C                   ENDIF
      *
      *
     C                   Movel(p)  O#ACLN3       @W1
     C                   Movel(p)  O#ACLN3       @W2
     C                   Movel(p)  O#ACLN3       @W3
      *
     C                   SELECT
     C                   WHEN      @W1 = '.'
     C     34            SUBST(P)  O#ACLN3:2     W@LINE           35
     C                   WHEN      @W2 = 'AC'
     C     33            SUBST(P)  O#ACLN3:3     W@LINE
     C                   WHEN      @W3 = 'ACC'
     C     32            SUBST(P)  O#ACLN3:4     W@LINE
     C                   WHEN      @W3 = 'AC-'
     C     32            SUBST(P)  O#ACLN3:4     W@LINE
     C                   OTHER
     C                   Movel(p)  O#ACLN3       W@LINE
     C                   ENDSL
      *
      * Test for  nnbbbbbbbb
     C     8             SUBST(P)  W@LINE:3      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   GOTO      EXCAIB
     C                   ENDIF
      * Test for  PLnnbbbbbbbb
     C     8             SUBST(P)  W@LINE:5      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   GOTO      EXCAIB
     C                   ENDIF
      * Test for  bbbbbbbb
     C     8             SUBST(P)  W@LINE:1      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   GOTO      EXCAIB
     C                   ENDIF
      *
      *
     C                   Movel(p)  O#ACLN4       @W1
     C                   Movel(p)  O#ACLN4       @W2
     C                   Movel(p)  O#ACLN4       @W3
      *
     C                   SELECT
     C                   WHEN      @W1 = '.'
      *    34            SUBST(P)  O#ACLN4:2     W@LINE           35
     C                   WHEN      @W2 = 'AC'
      *    33            SUBST(P)  O#ACLN4:3     W@LINE
     C                   WHEN      @W3 = 'ACC'
      *    32            SUBST(P)  O#ACLN4:4     W@LINE
     C                   WHEN      @W3 = 'AC-'
      *    32            SUBST(P)  O#ACLN4:4     W@LINE
     C                   OTHER
     C                   Movel(p)  O#ACLN4       W@LINE
     C                   ENDSL
      *
      * Test for  nnbbbbbbbb
     C     8             SUBST(P)  W@LINE:3      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   GOTO      EXCAIB
     C                   ENDIF
      * Test for  PLnnbbbbbbbb
     C     8             SUBST(P)  W@LINE:5      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   GOTO      EXCAIB
     C                   ENDIF
      * Test for  bbbbbbbb
     C     8             SUBST(P)  W@LINE:1      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   GOTO      EXCAIB
     C                   ENDIF
      *
      *
     C     WUMTAG        IFEQ      ':59:'
      *
     C                   Movel(p)  O#ACLN5       @W1
     C                   Movel(p)  O#ACLN5       @W2
     C                   Movel(p)  O#ACLN5       @W3
      *
     C                   SELECT
     C                   WHEN      @W1 = '.'
     C     34            SUBST(P)  O#ACLN5:2     W@LINE           35
     C                   WHEN      @W2 = 'AC'
     C     33            SUBST(P)  O#ACLN5:3     W@LINE
     C                   WHEN      @W3 = 'ACC'
     C     32            SUBST(P)  O#ACLN5:4     W@LINE
     C                   WHEN      @W3 = 'AC-'
     C     32            SUBST(P)  O#ACLN5:4     W@LINE
     C                   OTHER
     C                   Movel(p)  O#ACLN5       W@LINE
     C                   ENDSL
      *
      * Test for  nnbbbbbbbb
     C     8             SUBST(P)  W@LINE:3      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   GOTO      EXCAIB
     C                   ENDIF
      * Test for  PLnnbbbbbbbb
     C     8             SUBST(P)  W@LINE:5      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   GOTO      EXCAIB
     C                   ENDIF
      * Test for  bbbbbbbb
     C     8             SUBST(P)  W@LINE:1      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   GOTO      EXCAIB
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EXCAIB        TAG
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCASB   : Check Strategic IBAN branch for STP               *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCASB        BEGSR
      *
     C                   Movel(p)  O#ACLN1       @W1
     C                   Movel(p)  O#ACLN1       @W2
     C                   Movel(p)  O#ACLN1       @W3
      *
     C                   SELECT
     C                   WHEN      @W1 = '.'
      *    34            SUBST(P)  O#ACLN1:2     W@LINE           35
     C                   WHEN      @W2 = 'AC'
      *    33            SUBST(P)  O#ACLN1:3     W@LINE
     C                   WHEN      @W3 = 'ACC'
      *    32            SUBST(P)  O#ACLN1:4     W@LINE
     C                   WHEN      @W3 = 'AC-'
      *    32            SUBST(P)  O#ACLN1:4     W@LINE
     C                   ENDSL
      *
      * Test for  nnbbbbbbbb
     C     8             SUBST(P)  W@LINE:3      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C     RBRREG        IFEQ      'P'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   GOTO      EXCASB
     C                   ENDIF
      * Test for  PLnnbbbbbbbb
     C     8             SUBST(P)  W@LINE:5      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C     RBRREG        IFEQ      'P'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   GOTO      EXCASB
     C                   ENDIF
      * Test for  bbbbbbbb
     C     8             SUBST(P)  W@LINE:1      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C     RBRREG        IFEQ      'P'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   GOTO      EXCASB
     C                   ENDIF
      *
      *
     C                   Movel(p)  O#ACLN2       @W1
     C                   Movel(p)  O#ACLN2       @W2
     C                   Movel(p)  O#ACLN2       @W3
      *
     C                   SELECT
     C                   WHEN      @W1 = '.'
      *    34            SUBST(P)  O#ACLN2:2     W@LINE           35
     C                   WHEN      @W2 = 'AC'
      *    33            SUBST(P)  O#ACLN2:3     W@LINE
     C                   WHEN      @W3 = 'ACC'
      *    32            SUBST(P)  O#ACLN2:4     W@LINE
     C                   WHEN      @W3 = 'AC-'
      *    32            SUBST(P)  O#ACLN2:4     W@LINE
     C                   ENDSL
      *
      * Test for  nnbbbbbbbb
     C     8             SUBST(P)  W@LINE:3      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C     RBRREG        IFEQ      'P'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   GOTO      EXCASB
     C                   ENDIF
      * Test for  PLnnbbbbbbbb
     C     8             SUBST(P)  W@LINE:5      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C     RBRREG        IFEQ      'P'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   GOTO      EXCASB
     C                   ENDIF
      * Test for  bbbbbbbb
     C     8             SUBST(P)  W@LINE:1      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C     RBRREG        IFEQ      'P'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   GOTO      EXCASB
     C                   ENDIF
      *
      *
     C                   Movel(p)  O#ACLN3       @W1
     C                   Movel(p)  O#ACLN3       @W2
     C                   Movel(p)  O#ACLN3       @W3
      *
     C                   SELECT
     C                   WHEN      @W1 = '.'
      *    34            SUBST(P)  O#ACLN3:2     W@LINE           35
     C                   WHEN      @W2 = 'AC'
      *    33            SUBST(P)  O#ACLN3:3     W@LINE
     C                   WHEN      @W3 = 'ACC'
      *    32            SUBST(P)  O#ACLN3:4     W@LINE
     C                   WHEN      @W3 = 'AC-'
      *    32            SUBST(P)  O#ACLN3:4     W@LINE
     C                   ENDSL
      *
      * Test for  nnbbbbbbbb
     C     8             SUBST(P)  W@LINE:3      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C     RBRREG        IFEQ      'P'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   GOTO      EXCASB
     C                   ENDIF
      * Test for  PLnnbbbbbbbb
     C     8             SUBST(P)  W@LINE:5      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C     RBRREG        IFEQ      'P'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   GOTO      EXCASB
     C                   ENDIF
      * Test for  bbbbbbbb
     C     8             SUBST(P)  W@LINE:1      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C     RBRREG        IFEQ      'P'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   GOTO      EXCASB
     C                   ENDIF
      *
      *
     C                   Movel(p)  O#ACLN4       @W1
     C                   Movel(p)  O#ACLN4       @W2
     C                   Movel(p)  O#ACLN4       @W3
      *
     C                   SELECT
     C                   WHEN      @W1 = '.'
      *    34            SUBST(P)  O#ACLN4:2     W@LINE           35
     C                   WHEN      @W2 = 'AC'
      *    33            SUBST(P)  O#ACLN4:3     W@LINE
     C                   WHEN      @W3 = 'ACC'
      *    32            SUBST(P)  O#ACLN4:4     W@LINE
     C                   WHEN      @W3 = 'AC-'
      *    32            SUBST(P)  O#ACLN4:4     W@LINE
     C                   ENDSL
      *
      * Test for  nnbbbbbbbb
     C     8             SUBST(P)  W@LINE:3      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C     RBRREG        IFEQ      'P'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   GOTO      EXCASB
     C                   ENDIF
      * Test for  PLnnbbbbbbbb
     C     8             SUBST(P)  W@LINE:5      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C     RBRREG        IFEQ      'P'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   GOTO      EXCASB
     C                   ENDIF
      * Test for  bbbbbbbb
     C     8             SUBST(P)  W@LINE:1      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C     RBRREG        IFEQ      'P'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   GOTO      EXCASB
     C                   ENDIF
      *
      *
     C     WUMTAG        IFEQ      ':59:'
      *
     C                   Movel(p)  O#ACLN5       @W1
     C                   Movel(p)  O#ACLN5       @W2
     C                   Movel(p)  O#ACLN5       @W3
      *
     C                   SELECT
     C                   WHEN      @W1 = '.'
      *    34            SUBST(P)  O#ACLN5:2     W@LINE           35
     C                   WHEN      @W2 = 'AC'
      *    33            SUBST(P)  O#ACLN5:3     W@LINE
     C                   WHEN      @W3 = 'ACC'
      *    32            SUBST(P)  O#ACLN5:4     W@LINE
     C                   WHEN      @W3 = 'AC-'
      *    32            SUBST(P)  O#ACLN5:4     W@LINE
     C                   ENDSL
      *
      * Test for  nnbbbbbbbb
     C     8             SUBST(P)  W@LINE:3      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C     RBRREG        IFEQ      'P'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   GOTO      EXCASB
     C                   ENDIF
      * Test for  PLnnbbbbbbbb
     C     8             SUBST(P)  W@LINE:5      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C     RBRREG        IFEQ      'P'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   GOTO      EXCASB
     C                   ENDIF
      * Test for  bbbbbbbb
     C     8             SUBST(P)  W@LINE:1      RBBRCH
      *
     C     KRBRC         CHAIN     @RBRCV1                            90
     C     *IN90         IFEQ      *OFF
     C     RBSTPF        ANDEQ     'Y'
     C     RBRREG        IFEQ      'P'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   GOTO      EXCASB
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EXCASB        TAG
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCAEM   : Check if External Account match found             *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCAEM        BEGSR
      *
     CSR   EXTMATCH      IFEQ      'Y'
     CSR                 MOVEL     'T'           P#RETN
     CSR                 ENDIF
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCAFX   : Check for FX transaction                          *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCAFX        BEGSR
      *
      * get part information
     C     KINMP         KLIST
     C                   KFLD                    MPMSGR
     C                   KFLD                    MPKPRT
      *
     C                   If        BISE = 'Y'                                   STP200
     C                   MOVEL     'F'           P#RETN                         STP200
     C                   Else                                                   STP200
      *
     C                   Z-ADD     PHMSGR        MPMSGR
     C                   Z-ADD     PHPART        MPKPRT
      * get data
     C     KINMP         CHAIN     @INMPL1                            90
      * Account ccy must be different from message currency
     C     *IN90         IFEQ      *OFF
     C     CCY           ANDNE     MPCYCD
      * If Pay in Message Currency = Y and Swift and Incoming Payment
     C                   IF        (A#PCAT = 'Y' AND PCIMCY = 'Y'
     C                              AND GNMTPY = '103')
     C                             OR (A#PCAT = 'Y' AND PCIMCY = 'Y'
     C                              AND GNMTPY = 'E33')
     C                             OR (A#PCAT = 'Y' AND PCIMCY = 'Y'
     C                              AND GNMTPY = 'E32')
     C                   MOVEL     'F'           P#RETN
     C                   ELSE
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   ENDIF
      *                                                                         STP200
     C                   Endif                                                  STP200
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRMCFX   : Check for FX transaction                          *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRMCFX        BEGSR
      *
      * get part information
      *
     C                   Z-ADD     PHMSGR        MPMSGR
     C                   Z-ADD     PHPART        MPKPRT
      * get data
     C     KINMP         CHAIN     @INMPL1                            90
     C                   MOVEL     P32A          DSTRAN
      * Account ccy must be different from message currency
     C     *IN90         IFEQ      *OFF
     C     CCY           ANDNE     TVCCY
      * If Pay in Message Currency = Y and Swift and Incoming Payment
     C                   IF        (A#PCAT = 'Y' AND PCIMCY = 'Y'
     C                              AND GNMTPY = '103')
     C                             OR (A#PCAT = 'Y' AND PCIMCY = 'Y'
     C                              AND GNMTPY = 'E33')
     C                             OR (A#PCAT = 'Y' AND PCIMCY = 'Y'
     C                              AND GNMTPY = 'E32')
     C                   MOVEL     'F'           P#RETN
     C                   ELSE
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   ENDIF
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCASR   : Check for Special Routing                         *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCASR        BEGSR
      *
      * Special routing for account ?
     C     A#PCAT        IFEQ      'Y'
      *
     C                   MOVEL     PCSPRT        PCSPRT            1
     C     PCSPRT        IFEQ      'Y'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
      *
     C                   ENDIF
      *
     CSR                 ENDSR
      *                                                                                       E30004
     C/EJECT                                                                                  STP001
      *****************************************************************                       STP001
      *                                                               *                       STP001
      *  SRCAIT   : Test for cut off time for given account           *                       STP001
      *             Incoming Payments                                 *                       STP001
      *                                                               *                       STP001
      *  CALLED BY: Main processing                                   *                       STP001
      *                                                               *                       STP001
      *****************************************************************                       STP001
     CSR   SRCAIT        BEGSR                                                                STP001
      *                                                                                       STP001
      * Test time that message was received                                                   STP001
      * Get received date and time from control record                                        STP001
      *                                                                                       STP001
     CSR   PHMSGR        CHAIN     @INCRL1                            91                      STP001
      *                                                                                       STP001
      * When message not found - skip the rest of processing                                  STP001
      *                                                                                       STP001
     CSR   *IN91         IFEQ      *OFF                                                       STP001
      *                                                                                       STP001
      * Construct Received time and date into YYMMDDHHMM00 format                             STP001
      *                                                                                       STP001
     CSR                 Z-ADD     CRMODE        RCDATE                                       STP001
      *                                                                                       STP001
      * Received time and date into CCYYMMDDHHMM00 format                                     STP001
      *                                                                                       STP001
     CSR                 MOVE      CRMDEC        RCCNTY                                       STP001
      *                                                                                       STP001
     CSR                 Z-ADD     CRMOTM        RCTIME                                       STP001
     CSR                 Z-ADD     0             RCSECS                                       STP001
      *                                                                                       STP001
      * Get System Date and time and place in CCYYMMDDHHMM00 format                           STP001
      *                                                                                       STP001
     CSR                 TIME                    CODTTM           14 0                        STP001
     CSR                 Z-ADD     CODTTM        CODATE                                       STP001
     CSR                 Z-ADD     0             COSECS                                       STP001
      *                                                                                       STP001
      * Process incoming and outgoing separately                                              STP001
      *                                                                                       STP001
     CSR                 SETOFF                                       70
     CSR   A#PCAT        IFEQ      'Y'
     CSR   PCICUT        ANDNE     -1
     CSR   PCICUT        ANDNE     0
     CSR                 Z-ADD     PCICUT        COHOMI                                       STP001
     CSR                 ELSE
      *
     C     KNCT          KLIST
     C                   KFLD                    Network           6
     C                   KFLD                    FXpay             1
      *
     C                   Z-ADD     PHMSGR        MPMSGR
     C                   Z-ADD     PHPART        MPKPRT
     C                   MOVEL     'N'           FXPay
      * get data
     C                   If        BISE <> 'Y'                                  STP200
      *
     C     KINMP         CHAIN     @INMPL1                            50
      * Account ccy must be different from message currency
     C     *IN50         IFEQ      *OFF
     C     CCY           ANDNE     MPCYCD
     C                   MOVEL     'Y'           FXPay
      * If Pay in Message Currency = Y and Swift and Incoming Payment
     C                   IF        (A#PCAT = 'Y' AND PCIMCY = 'Y'
     C                              AND GNMTPY = '103')
     C                             OR (A#PCAT = 'Y' AND PCIMCY = 'Y'
     C                              AND GNMTPY = 'E33')
     C                             OR (A#PCAT = 'Y' AND PCIMCY = 'Y'
     C                              AND GNMTPY = 'E32')
     C                   MOVEL     'N'           FXPay
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  STP200
      *
     CSR                 MOVEL     GNNWRK        Network
     CSR   KNCT          CHAIN     FTNCOTV0                           70
     CSR                 Z-ADD     NNNCOT        COHOMI
     CSR                 ENDIF
      *                                                                                       STP001
      * Test the condition.                                                                   STP001
      *
     CSR   *IN70         IFEQ      *ON
      *                                                                                       STP001
     CSR                 SELECT                                                               STP001
     CSR                 WHEN      GDOPER = 'GT'
     CSR                 MOVEL     'F'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'GE'
     CSR                 MOVEL     'F'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'EQ'
     CSR                 MOVEL     'F'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'LE'
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'LT'
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 ENDSL                                                                STP001
      *                                                                                       STP001
     CSR                 ELSE
      *
     CSR                 SELECT                                                               STP001
     CSR                 WHEN      GDOPER = 'GT' AND RCCOMP > CODAY                           STP001
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'GE' AND RCCOMP >= CODAY                          STP001
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'EQ' AND RCCOMP = CODAY                           STP001
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'LE' AND RCCOMP <= CODAY                          STP001
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'LT' AND RCCOMP < CODAY                           STP001
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 ENDSL                                                                STP001
      *                                                                                       STP001
     CSR                 ENDIF                                                                STP001
      *                                                                                       STP001
     CSR                 ENDIF                                                                STP001
      *                                                                                       STP001
     CSR                 ENDSR                                                                STP001
      *                                                                                       STP001
     C/EJECT                                                                                  STP001
      *****************************************************************                       STP001
      *                                                               *                       STP001
      *  SRCAOT   : Test for cut off time for given account           *                       STP001
      *             Outgoing Payments                                 *                       STP001
      *                                                               *                       STP001
      *  CALLED BY: Main processing                                   *                       STP001
      *                                                               *                       STP001
      *****************************************************************                       STP001
     CSR   SRCAOT        BEGSR                                                                STP001
      *                                                                                       STP001
      * Test time that message was received                                                   STP001
      * Get received date and time from control record                                        STP001
      *                                                                                       STP001
     CSR   PHMSGR        CHAIN     @INCRL1                            91                      STP001
      *                                                                                       STP001
      * When message not found - skip the rest of processing                                  STP001
      *                                                                                       STP001
     CSR   *IN91         IFEQ      *OFF                                                       STP001
      *                                                                                       STP001
      * Construct Received time and date into YYMMDDHHMM00 format                             STP001
      *                                                                                       STP001
     CSR                 Z-ADD     CRMODE        RCDATE                                       STP001
      *                                                                                       STP001
      * Received time and date into CCYYMMDDHHMM00 format                                     STP001
      *                                                                                       STP001
     CSR                 MOVE      CRMDEC        RCCNTY                                       STP001
      *                                                                                       STP001
     CSR                 Z-ADD     CRMOTM        RCTIME                                       STP001
     CSR                 Z-ADD     0             RCSECS                                       STP001
      *                                                                                       STP001
      * Get System Date and time and place in CCYYMMDDHHMM00 format                           STP001
      *                                                                                       STP001
     CSR                 TIME                    CODTTM           14 0                        STP001
     CSR                 Z-ADD     CODTTM        CODATE                                       STP001
     CSR                 Z-ADD     0             COSECS                                       STP001
      *                                                                                       STP001
      * Process incoming and outgoing separately                                              STP001
      *                                                                                       STP001
      *                                                                                       STP001
     CSR                 SETOFF                                       70
     CSR   A#PCAT        IFEQ      'Y'
     CSR   PCOCUT        ANDNE     -1
     CSR   PCOCUT        ANDNE     0
     CSR                 Z-ADD     PCOCUT        COHOMI                                       STP001
     CSR                 ELSE
      *
     C                   Z-ADD     PHMSGR        MPMSGR
     C                   Z-ADD     PHPART        MPKPRT
     C                   MOVEL     'N'           FXPay
      * get data
     C     KINMP         CHAIN     @INMPL1                            50
      * Account ccy must be different from message currency
     C     *IN50         IFEQ      *OFF
     C     CCY           ANDNE     MPCYCD
     C                   MOVEL     'Y'           FXPay
     C                   ENDIF
      *
     CSR                 MOVEL(p)  GNNWRK        Network
     CSR   KNCT          CHAIN     FTNCOTV0                           70
     CSR                 Z-ADD     NNNCOT        COHOMI
     CSR                 ENDIF
      *                                                                                       STP001
      * Test the condition.                                                                   STP001
      *                                                                                       STP001
     CSR   *IN70         IFEQ      *ON
      *                                                                                       STP001
     CSR                 SELECT                                                               STP001
     CSR                 WHEN      GDOPER = 'GT'
     CSR                 MOVEL     'F'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'GE'
     CSR                 MOVEL     'F'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'EQ'
     CSR                 MOVEL     'F'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'LE'
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'LT'
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 ENDSL                                                                STP001
      *                                                                                       STP001
     CSR                 ELSE
      *                                                                                       STP001
     CSR                 SELECT                                                               STP001
     CSR                 WHEN      GDOPER = 'GT' AND RCCOMP > CODAY                           STP001
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'GE' AND RCCOMP >= CODAY                          STP001
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'EQ' AND RCCOMP = CODAY                           STP001
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'LE' AND RCCOMP <= CODAY                          STP001
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'LT' AND RCCOMP < CODAY                           STP001
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 ENDSL                                                                STP001
      *                                                                                       STP001
     CSR                 ENDIF                                                                STP001
      *                                                                                       STP001
     CSR                 ENDIF                                                                STP001
      *                                                                                       STP001
     CSR                 ENDSR                                                                STP001
      *                                                                                       STP001
     C/EJECT                                                                                  STP001
      *****************************************************************                       STP001
      *                                                               *                       STP001
      *  SRCACT   : Test for cut off time for ccy/segment/network/msg *                       STP001
      *             type combination                                  *                       STP001
      *                                                               *                       STP001
      *  CALLED BY: Main processing                                   *                       STP001
      *                                                               *                       STP001
      *****************************************************************                       STP001
     CSR   SRCACT        BEGSR                                                                STP001
      *                                                                                       STP001
      * Test time that message was received                                                   STP001
      * Get received date and time from control record                                        STP001
      *                                                                                       STP001
     CSR   PHMSGR        CHAIN     @INCRL1                            91                      STP001
      *                                                                                       STP001
      * When message not found - skip the rest of processing                                  STP001
      *                                                                                       STP001
     CSR   *IN91         IFEQ      *OFF                                                       STP001
      *                                                                                       STP001
      * get part information                                                                  STP001
      *                                                                                       STP001
     CSR                 Z-ADD     PHMSGR        MPMSGR                                       STP001
     CSR                 Z-ADD     PHPART        MPKPRT                                       STP001
      * get data                                                                              STP001
     CSR   KINMP         CHAIN     @INMPL1                            91                      STP001
      *                                                                                       STP001
      * When message not found - skip the rest of processing                                  STP001
      *                                                                                       STP001
     CSR   *IN91         IFEQ      *OFF                                                       STP001
      *                                                                                       STP001
      *                                                                                       STP001
     CSR   FTCCUT        KLIST                                                                STP001
     CSR                 KFLD                    ##CYCD            3                          STP001
     CSR                 KFLD                    ##BGPC            4                          STP001
     CSR                 KFLD                    ##NWRK            6                          STP001
     CSR                 KFLD                    ##MTPY            3                          STP001
      *
     C                   Move      *Zeros        W@CNUM
     C                   Move      CNUM          W@CNUM
     C     W@CNUM        CHAIN     SDCMRKL0
     C                   If        %Found
     C                   Move      D7GPC1        ##BGPC
     C                   Else
     C                   Move      '*ALL'        ##BGPC
     C                   Endif
     C
      *                                                                                       STP001
     CSR                 MOVEL     MPCYCD        ##CYCD                                       STP001
     CSR                 MOVEL     GNNWRK        ##NWRK                                       STP001
     CSR                 MOVEL     GNMTPY        ##MTPY                                       STP001
      *                                                                                       STP001
      * Access time cut off definition for ccy/group/network/msg type combination...          STP001
      * ...for accounts found in PCAT                                                         STP001
      *                                                                                       STP001
     CSR   *IN90         IFEQ      *OFF                                                       STP001
      *                                                                                       STP001
     CSR   FTCCUT        CHAIN     @CCUTV0                            91                      STP001
      *                                                                                       STP001
     CSR                 ENDIF                                                                STP001
      *                                                                                       STP001
      * ...for accounts NOT found in PCAT and for those with failed chain in previous attempt STP001
      *                                                                                       STP001
     CSR   *IN90         IFEQ      *ON                                                        STP001
     CSR   *IN91         OREQ      *ON                                                        STP001
      *                                                                                       STP001
     CSR                 MOVEL     '*ALL'        ##BGPC                                       STP001
      *                                                                                       STP001
     CSR   FTCCUT        CHAIN     @CCUTV0                            91                      STP001
      *                                                                                       STP001
     CSR                 ENDIF                                                                STP001
      *                                                                                       STP001
      *                                                                                       STP001
      * Construct Received time and date into YYMMDDHHMM00 format                             STP001
      *                                                                                       STP001
     CSR                 Z-ADD     CRMODE        RCDATE                                       STP001
      *                                                                                       STP001
      * Received time and date into CCYYMMDDHHMM00 format                                     STP001
      *                                                                                       STP001
     CSR                 MOVE      CRMDEC        RCCNTY                                       STP001
      *                                                                                       STP001
     CSR                 Z-ADD     CRMOTM        RCTIME                                       STP001
     CSR                 Z-ADD     0             RCSECS                                       STP001
      *                                                                                       STP001
      * Get System Date and time and place in CCYYMMDDHHMM00 format                           STP001
      *                                                                                       STP001
     CSR                 TIME                    CODTTM                                       STP001
     CSR                 Z-ADD     CODTTM        CODATE                                       STP001
     CSR                 Z-ADD     0             COSECS                                       STP001
      *                                                                                       STP001
      * When definition not found - use standard network cut off                              STP001
     CSR                 SETOFF                                       70
     CSR   *IN91         IFEQ      *ON
      *
     CSR                 Movel(p)  GNNWRK        Network
     CSR                 Movel(p)  'N'           FXPay
     CSR   KNCT          CHAIN     FTNCOTV0                           70
     CSR                 Z-ADD     NNNCOT        COHOMI
      *
     CSR                 ELSE
      *
     CSR                 Z-ADD     CCICUT        COHOMI                                       STP001
      *
     CSR                 ENDIF
      *                                                                                       STP001
      * Test the condition.                                                                   STP001
      *                                                                                       STP001
     CSR   *IN70         IFEQ      *OFF
      *
     CSR                 SELECT                                                               STP001
     CSR                 WHEN      GDOPER = 'GT' AND RCCOMP > CODAY                           STP001
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'GE' AND RCCOMP >= CODAY                          STP001
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'EQ' AND RCCOMP = CODAY                           STP001
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'LE' AND RCCOMP <= CODAY                          STP001
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'LT' AND RCCOMP < CODAY                           STP001
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 ENDSL                                                                STP001
      *                                                                                       STP001
     CSR                 ELSE
      *
     CSR                 SELECT                                                               STP001
     CSR                 WHEN      GDOPER = 'GT'
     CSR                 MOVEL     'F'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'GE'
     CSR                 MOVEL     'F'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'EQ'
     CSR                 MOVEL     'F'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'LE'
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 WHEN      GDOPER = 'LT'
     CSR                 MOVEL     'T'           P#RETN                                       STP001
     CSR                 ENDSL                                                                STP001
      *                                                                                       STP001
     CSR                 ENDIF                                                                STP001
      *                                                                                       STP001
      *
     CSR                 ENDIF                                                                STP001
      *                                                                                       STP001
     CSR                 ENDIF                                                                STP001
      *                                                                                       STP001
     CSR                 ENDSR                                                                STP001
      *                                                                                       STP001
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPENR   : Check for Pensioner                               *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRPENR        BEGSR
      *
      * Pensioner field must be Y
     C     A#PCAT        IFEQ      'Y'
      *
     C     PCPENR        IFEQ      'Y'
     C                   MOVEL     'T'           P#RETN
      * get present data
     C                   CALL      'FTP960'
     C                   PARM      *BLANKS       P9RTN             7
     C                   PARM                    P9PEXT
      * update data
     C                   MOVEL     'Y'           PXPENF                                       STP001
     C                   CALL      'FTP960'
     C                   PARM      'STORE  '     P9RTN             7
     C                   PARM                    P9PEXT
     C                   ENDIF
      *
     C                   ENDIF
      *
     CSR                 ENDSR
      *                                                                                       E30004
     C/EJECT                                                                                  E30004
      *****************************************************************                       E30004
      *                                                               *                       E30004
      *  SRCASS   : Check for Customer Account Status                 *                       E30004
      *                                                               *                       E30004
      *  CALLED BY: Main processing                                   *                       E30004
      *                                                               *                       E30004
      *****************************************************************                       E30004
     CSR   SRCASS        BEGSR
      *                                                                                       E30004
     C                   EXSR      STATUS
      *
     C     A#PCAT        IFEQ      'Y'
      *
      * Test for account status                                                               E30004
      *                                                                                       E30004
     C                   SELECT
     C     U#ACT         WHENEQ    '*AC?C'
      *
     C     PCASTS        IFEQ      'C'
     C     @CLOSE        OREQ      'Y'
     C**   @BCR          OREQ      'Y'
     C     @BANKR        OREQ      'Y'
     C     @BADD         OREQ      'Y'
     C     @RDR          OREQ      'Y'                                                       HVB021
     C**   @RCR          OREQ      'Y'                                                       HVB021
     C     @BDR          OREQ      'Y'                                                       HVB021
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
      *
     C     U#ACT         WHENEQ    '*AC?E'
      *
     C     PCASTS        IFEQ      'E'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
      *
     C     U#ACT         WHENEQ    '*AC?I'
      *
     C     PCASTS        IFEQ      'I'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
      *
     C     U#ACT         WHENEQ    '*AC?A'
      *
     C     PCASTS        IFEQ      *BLANKS
     C     @INACT        ANDNE     'Y'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ELSE
      *                                                                                       E30004
     C                   SELECT
     C     U#ACT         WHENEQ    '*AC?C'
      *
     C     @CLOSE        IFEQ      'Y'
     C**   @BCR          OREQ      'Y'
     C     @BANKR        OREQ      'Y'
     C     @BADD         OREQ      'Y'
     C     @RDR          OREQ      'Y'                                                       HVB021
     C**   @RCR          OREQ      'Y'                                                       HVB021
     C     @BDR          OREQ      'Y'                                                       HVB021
     C     @INACT        OREQ      'Y'                                                       HVB021
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
      *
     C     U#ACT         WHENEQ    '*AC?E'
      *
     C     U#ACT         WHENEQ    '*AC?I'
      *
     C     U#ACT         WHENEQ    '*AC?A'
      *
     C     @INACT        IFNE      'Y'
     C                   MOVEL     'T'           P#RETN
     C                   ENDIF
     C                   ENDSL
      *
     C                   ENDIF
      *                                                                                       E30004
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCAFS   : Check for FX transaction                          *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCAFS        BEGSR
      *
     C                   Z-ADD     PHMSGR        MPMSGR
     C                   Z-ADD     PHPART        MPKPRT
      * get data
     C     KINMP         CHAIN     @INMPL1                            90
      * Check Pay in Message currency flag
     C     *IN90         IFEQ      *OFF
     C     CCY           ANDNE     MPCYCD
     C                   IF        (A#PCAT = 'Y' AND PCIMCY = 'Y'
     C                              AND GNMTPY = '103')
     C                             OR (A#PCAT = 'Y' AND PCIMCY = 'Y'
     C                              AND GNMTPY = 'E33')
     C                             OR (A#PCAT = 'Y' AND PCIMCY = 'Y'
     C                              AND GNMTPY = 'E32')
     C                   MOVEL     'T'           NOFX              1
     C                   ELSE
     C                   MOVEL     'F'           NOFX
     C                   ENDIF
     C                   ENDIF
      * PCAT currency must be different from message currency
     C     *IN90         IFEQ      *OFF
     C     CCY           ANDNE     MPCYCD
     C     NOFX          ANDNE     'T'
     C     P#FXRI        ANDNE     'I'
      *
      ** Extract bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM                    @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
      *
      * Convert amount to base currency
      *
     C                   CLEAR                   D#DTA
      *
     C                   MOVEL     MPCYCD        @CCY                           Letter currency
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PNWRK         IFNE      'ELIXIR'                                                  MMFIX2
     C                   SELECT
     C     A6NBDP        WHENEQ    0
     C                   Z-ADD     MPPYAM        D#FAMT
     C     A6NBDP        WHENEQ    1
     C     MPPYAM        MULT      10            D#FAMT
     C     A6NBDP        WHENEQ    2
     C     MPPYAM        MULT      100           D#FAMT
     C     A6NBDP        WHENEQ    3
     C     MPPYAM        MULT      1000          D#FAMT
     C                   ENDSL
     C                   ELSE                                                                MMFIX2
     C                   Z-ADD     MPPYAM        D#FAMT                                      MMFIX2
     C                   ENDIF                                                               MMFIX2
      *
     C                   MOVEL     MPCYCD        D#FCCY
      ****               MOVEL     BJCYCD        D#TCCY
     C                   MOVEL     'EUR'         D#TCCY
      *
     C                   CALL      'AOCCYCV0'                           9090
     C                   PARM      *BLANKS       O#RTN             7
     C                   PARM      '*F*T*SPT'    W0ACT             8
     C     D#DTA         PARM      D#DTA         O#DTA           256
      *
      ****               MOVEL     BJCYCD        @CCY                           Letter currency
     C                   MOVEL     'EUR'         @CCY                           Letter currency
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   SELECT
     C     A6NBDP        WHENEQ    0
     C     *LIKE         DEFINE    D#FAMT        U#FXLA
     C                   Z-ADD     P#FXLA        U#FXLA
     C     A6NBDP        WHENEQ    1
     C     P#FXLA        MULT      10            U#FXLA
     C     A6NBDP        WHENEQ    2
     C     P#FXLA        MULT      100           U#FXLA
     C     A6NBDP        WHENEQ    3
     C     P#FXLA        MULT      1000          U#FXLA
     C                   ENDSL
      *  continue if not limit rate
     C     *IN90         IFEQ      *OFF
     C     O#RTN         ANDEQ     *BLANKS
     C     P#FXRI        ANDNE     'L'
      *  continue if limit rate and amount under limit
     C     *IN90         OREQ      *OFF
     C     O#RTN         ANDEQ     *BLANKS
     C     P#FXRI        ANDEQ     'L'
     C     U#FXLA        ANDGE     D#TAMT
      *
      * Get customer group information
      *
     C                   Move      *Zeros        W@CNUM            6
     C                   Move      CNUM          W@CNUM
     C     W@CNUM        CHAIN     SDCMRKL0
     C                   If        %Found
     C                   Move      D7GPC1        SXGPCD
     C                   Else
     C                   Move      '*ALL'        SXGPCD
     C                   Endif
     C
      *
     C     *IN90         IFEQ      *OFF
     C     *IN90         OREQ      *ON
      *
     C     KFXGP         KLIST
     C                   KFLD                    GPSNBR
     C                   KFLD                    GPGPCD
     C                   KFLD                    GPSTPR
     C                   KFLD                    GPCYCD
      *
     C                   MOVEL     '1'           GPSNBR
     C                   MOVEL     SXGPCD        GPGPCD
     C                   MOVEL     'S'           GPSTPR
     C                   MOVEL     MPCYCD        GPCYCD
      * Check if STP rate for Currency
     C     KFXGP         CHAIN     @FXGPV1                            90
     C     *IN90         IFEQ      *ON
      * Check if STP rate for ALL
     C                   MOVEL     'S'           GPSTPR
     C                   MOVEL     'ALL'         GPCYCD
     C     KFXGP         CHAIN     @FXGPV1                            90
     C                   ENDIF
     C     *IN90         IFEQ      *ON
      * Check if STP rate for ALL
     C                   MOVEL     '*ALL'        GPGPCD
     C     KFXGP         CHAIN     @FXGPV1                            90
     C                   ENDIF
     C     *IN90         IFEQ      *ON
      * Check if STP rate for Manual
     C                   MOVEL     'M'           GPSTPR
     C                   MOVEL     MPCYCD        GPCYCD
     C     KFXGP         CHAIN     @FXGPV1                            90
     C                   ENDIF
     C     *IN90         IFEQ      *ON
      * Check if STP rate for Manual ALL
     C                   MOVEL     'M'           GPSTPR
     C                   MOVEL     'ALL'         GPCYCD
     C     KFXGP         CHAIN     @FXGPV1                            90
     C                   ENDIF
     C     *IN90         IFEQ      *ON
      * Check if STP rate for Manual ALL
     C                   MOVEL     '*ALL'        GPGPCD
     C     KFXGP         CHAIN     @FXGPV1                            90
     C                   ENDIF
      * group found
     C     *IN90         IFEQ      *OFF
      * Convert message amount into Quotation currency
      *
     C                   CLEAR                   D#DTA
      *
     C                   MOVEL     MPCYCD        @CCY                           Letter currency
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PNWRK         IFNE      'ELIXIR'                                                  MMFIX2
     C                   SELECT
     C     A6NBDP        WHENEQ    0
     C                   Z-ADD     MPPYAM        D#FAMT
     C     A6NBDP        WHENEQ    1
     C     MPPYAM        MULT      10            D#FAMT
     C     A6NBDP        WHENEQ    2
     C     MPPYAM        MULT      100           D#FAMT
     C     A6NBDP        WHENEQ    3
     C     MPPYAM        MULT      1000          D#FAMT
     C                   ENDSL
     C                   ELSE                                                                MMFIX2
     C                   Z-ADD     MPPYAM        D#FAMT                                      MMFIX2
     C                   ENDIF                                                               MMFIX2
      *
     C                   MOVEL     MPCYCD        D#FCCY
     C                   MOVEL     GPQCCY        D#TCCY
      *
     C                   CALL      'AOCCYCV0'                           9090
     C                   PARM      *BLANKS       O#RTN             7
     C                   PARM      '*F*T*SPT'    W0ACT             8
     C     D#DTA         PARM      D#DTA         O#DTA           256
      *
     C                   MOVEL     GPQCCY        @CCY                           Letter currency
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     *LIKE         DEFINE    D#FAMT        U#FXL1
     C     *LIKE         DEFINE    D#FAMT        U#FXL2
     C     *LIKE         DEFINE    D#FAMT        U#FXL3
     C     *LIKE         DEFINE    D#FAMT        U#FXL4
     C     *LIKE         DEFINE    D#FAMT        U#FXL5
     C     *LIKE         DEFINE    D#FAMT        U#FXL6
     C     *LIKE         DEFINE    D#FAMT        U#FXL7
     C     *LIKE         DEFINE    D#FAMT        U#FXL8
     C     *LIKE         DEFINE    D#FAMT        U#FXL9
      *
     C***                SELECT
     C**   A6NBDP        WHENEQ    0
     C                   Z-ADD     GPLAM1        U#FXL1
     C                   Z-ADD     GPLAM2        U#FXL2
     C                   Z-ADD     GPLAM3        U#FXL3
     C                   Z-ADD     GPLAM4        U#FXL4
     C                   Z-ADD     GPLAM5        U#FXL5
     C                   Z-ADD     GPLAM6        U#FXL6
     C                   Z-ADD     GPLAM7        U#FXL7
     C                   Z-ADD     GPLAM8        U#FXL8
     C                   Z-ADD     GPLAM9        U#FXL9
     C***  A6NBDP        WHENEQ    1
     C***  GPLAM1        MULT      10            U#FXL1
     C***  GPLAM2        MULT      10            U#FXL2
     C***  GPLAM3        MULT      10            U#FXL3
     C***  GPLAM4        MULT      10            U#FXL4
     C***  GPLAM5        MULT      10            U#FXL5
     C***  GPLAM6        MULT      10            U#FXL6
     C***  GPLAM7        MULT      10            U#FXL7
     C***  GPLAM8        MULT      10            U#FXL8
     C***  GPLAM9        MULT      10            U#FXL9
     C***  A6NBDP        WHENEQ    2
     C***  GPLAM1        MULT      100           U#FXL1
     C***  GPLAM2        MULT      100           U#FXL2
     C***  GPLAM3        MULT      100           U#FXL3
     C***  GPLAM4        MULT      100           U#FXL4
     C***  GPLAM5        MULT      100           U#FXL5
     C***  GPLAM6        MULT      100           U#FXL6
     C***  GPLAM7        MULT      100           U#FXL7
     C***  GPLAM8        MULT      100           U#FXL8
     C***  GPLAM9        MULT      100           U#FXL9
     C***  A6NBDP        WHENEQ    3
     C***  GPLAM1        MULT      1000          U#FXL1
     C***  GPLAM2        MULT      1000          U#FXL2
     C***  GPLAM3        MULT      1000          U#FXL3
     C***  GPLAM4        MULT      1000          U#FXL4
     C***  GPLAM5        MULT      1000          U#FXL5
     C***  GPLAM6        MULT      1000          U#FXL6
     C***  GPLAM7        MULT      1000          U#FXL7
     C***  GPLAM8        MULT      1000          U#FXL8
     C***  GPLAM9        MULT      1000          U#FXL9
     C***                ENDSL
      *
      * Get customer group FX rate information
      *
     C     *LIKE         DEFINE    GPFXS1        SVFXSP
     C                   SELECT
      * Range 1
     C     GPLAM1        WHENEQ    -1
     C     U#FXL1        ORGE      D#TAMT
     C     GPDLR1        IFNE      'Y'
     C     GPFXS1        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS1        SVFXSP
     C                   ENDIF
      * Range 2
     C     GPLAM2        WHENEQ    -1
     C     U#FXL2        ORGE      D#TAMT
     C     GPDLR2        IFNE      'Y'
     C     GPFXS2        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS2        SVFXSP
     C                   ENDIF
      * Range 3
     C     GPLAM3        WHENEQ    -1
     C     U#FXL3        ORGE      D#TAMT
     C     GPDLR3        IFNE      'Y'
     C     GPFXS3        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS3        SVFXSP
     C                   ENDIF
      * Range 4
     C     GPLAM4        WHENEQ    -1
     C     U#FXL4        ORGE      D#TAMT
     C     GPDLR4        IFNE      'Y'
     C     GPFXS4        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS4        SVFXSP
     C                   ENDIF
      * Range 5
     C     GPLAM5        WHENEQ    -1
     C     U#FXL5        ORGE      D#TAMT
     C     GPDLR5        IFNE      'Y'
     C     GPFXS5        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS5        SVFXSP
     C                   ENDIF
      * Range 6
     C     GPLAM6        WHENEQ    -1
     C     U#FXL6        ORGE      D#TAMT
     C     GPDLR6        IFNE      'Y'
     C     GPFXS6        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS6        SVFXSP
     C                   ENDIF
      * Range 7
     C     GPLAM7        WHENEQ    -1
     C     U#FXL7        ORGE      D#TAMT
     C     GPDLR7        IFNE      'Y'
     C     GPFXS7        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS7        SVFXSP
     C                   ENDIF
      * Range 8
     C     GPLAM8        WHENEQ    -1
     C     U#FXL8        ORGE      D#TAMT
     C     GPDLR8        IFNE      'Y'
     C     GPFXS8        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS8        SVFXSP
     C                   ENDIF
      * Range 9
     C     GPLAM9        WHENEQ    -1
     C     U#FXL9        ORGE      D#TAMT
     C     GPDLR9        IFNE      'Y'
     C     GPFXS9        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS9        SVFXSP
     C                   ENDIF
     C                   ENDSL
      * If FX spread to be used store
     C     P#RETN        IFEQ      'T'
      * get present data
     C                   CALL      'FTP960'
     C                   PARM      *BLANKS       P9RTN             7
     C                   PARM                    P9PEXT
      * update data
     C                   MOVEL     SVFXSP        PXFXSP
      *
     C     P#IFXS        IFNE      *BLANKS
     C                   MOVEL     P#IFXS        PXFXSP
     C                   ENDIF
      *
     C                   CALL      'FTP960'
     C                   PARM      'STORE  '     P9RTN             7
     C                   PARM                    P9PEXT
     C                   ENDIF
      *
     C                   ENDIF                                                  FX group found
     C                   ENDIF                                                  Segment endif
      *
     C                   ENDIF                                                  Ccy convert endif
     C                   ENDIF                                                  FX endif
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRMCFS   : Check for FX transaction                          *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRMCFS        BEGSR
      *
     C                   Z-ADD     PHMSGR        MPMSGR
     C                   Z-ADD     PHPART        MPKPRT
      * get data
     C     KINMP         CHAIN     @INMPL1                            90
     C                   MOVEL     P32A          DSTRAN
      * Check Pay in Message currency flag
     C     *IN90         IFEQ      *OFF
     C     CCY           ANDNE     TVCCY
     C                   IF        (A#PCAT = 'Y' AND PCIMCY = 'Y'
     C                              AND GNMTPY = '103')
     C                             OR (A#PCAT = 'Y' AND PCIMCY = 'Y'
     C                              AND GNMTPY = 'E33')
     C                             OR (A#PCAT = 'Y' AND PCIMCY = 'Y'
     C                              AND GNMTPY = 'E32')
     C                   MOVEL     'T'           NOFX              1
     C                   ELSE
     C                   MOVEL     'F'           NOFX
     C                   ENDIF
     C                   ENDIF
      * PCAT currency must be different from message currency
     C     *IN90         IFEQ      *OFF
     C     CCY           ANDNE     TVCCY
     C     NOFX          ANDNE     'T'
     C     P#FXRI        ANDNE     'I'
      *
      ** Extract bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM                    @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
      *
      * Convert amount to base currency
      *
     C                   CLEAR                   D#DTA
      *
     C                   MOVEL     TVCCY         @CCY                           Letter currency
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      * get amount entered                                                                    FT0001
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVEL     TVAMT         ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC             1 0
     C     15            SUB       A6NBDP        ZADIG             2 0
      *
     C     ',':'.'       XLATE     ZFIELD        ZFIELD
     C                   CALL      'ZALIGN'                             90
     C                   PARM      *BLANKS       ZRTN              7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM      *BLANKS       ZAFLD            16
      *                                                                                       EEE058
      * only check if entered amount is correct                                               EEE058
     C     ZRTN          IFEQ      *BLANKS
      * Set up amount                                                                         EEE058
     C                   MOVE      ZFIELD        ##PYAM           13 0
      *
     C                   ENDIF
     C                   Z-ADD     ##PYAM        D#FAMT
      *
      *                  SELECT
      *    A6NBDP        WHENEQ    0
      *                  Z-ADD     ##PYAM        D#FAMT
      *    A6NBDP        WHENEQ    1
      *    ##PYAM        MULT      10            D#FAMT
      *    A6NBDP        WHENEQ    2
      *    ##PYAM        MULT      100           D#FAMT
      *    A6NBDP        WHENEQ    3
      *    ##PYAM        MULT      1000          D#FAMT
      *                  ENDSL
      *
     C                   MOVEL     TVCCY         D#FCCY
      ****               MOVEL     BJCYCD        D#TCCY
     C                   MOVEL     'EUR'         D#TCCY
      *
     C                   CALL      'AOCCYCV0'                           9090
     C                   PARM      *BLANKS       O#RTN             7
     C                   PARM      '*F*T*SPT'    W0ACT             8
     C     D#DTA         PARM      D#DTA         O#DTA           256
      *
      ****               MOVEL     BJCYCD        @CCY                           Letter currency
     C                   MOVEL     'EUR'         @CCY                           Letter currency
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   SELECT
     C     A6NBDP        WHENEQ    0
     C     *LIKE         DEFINE    D#FAMT        U#FXLA
     C                   Z-ADD     P#FXLA        U#FXLA
     C     A6NBDP        WHENEQ    1
     C     P#FXLA        MULT      10            U#FXLA
     C     A6NBDP        WHENEQ    2
     C     P#FXLA        MULT      100           U#FXLA
     C     A6NBDP        WHENEQ    3
     C     P#FXLA        MULT      1000          U#FXLA
     C                   ENDSL
      *  continue if not limit rate
     C     *IN90         IFEQ      *OFF
     C     O#RTN         ANDEQ     *BLANKS
     C     P#FXRI        ANDNE     'L'
      *  continue if limit rate and amount under limit
     C     *IN90         OREQ      *OFF
     C     O#RTN         ANDEQ     *BLANKS
     C     P#FXRI        ANDEQ     'L'
     C     U#FXLA        ANDGE     D#TAMT
      *
      * Get customer group information
      *
     C                   Move      *Zeros        W@CNUM            6
     C                   Move      CNUM          W@CNUM
     C     W@CNUM        CHAIN     SDCMRKL0
     C                   If        %Found
     C                   Move      D7GPC1        SXGPCD
     C                   Else
     C                   Move      '*ALL'        SXGPCD
     C                   Endif
     C
      *
     C     *IN90         IFEQ      *OFF
     C     *IN90         OREQ      *ON
      *
      *
     C                   MOVEL     '1'           GPSNBR
     C                   MOVEL     SXGPCD        GPGPCD
     C                   MOVEL     'S'           GPSTPR
     C                   MOVEL     TVCCY         GPCYCD
      * Check if STP rate for Currency
     C     KFXGP         CHAIN     @FXGPV1                            90
     C     *IN90         IFEQ      *ON
      * Check if STP rate for ALL
     C                   MOVEL     'S'           GPSTPR
     C                   MOVEL     'ALL'         GPCYCD
     C     KFXGP         CHAIN     @FXGPV1                            90
     C                   ENDIF
     C     *IN90         IFEQ      *ON
      * Check if STP rate for ALL
     C                   MOVEL     '*ALL'        GPGPCD
     C     KFXGP         CHAIN     @FXGPV1                            90
     C                   ENDIF
     C     *IN90         IFEQ      *ON
      * Check if STP rate for Manual
     C                   MOVEL     'M'           GPSTPR
     C                   MOVEL     TVCCY         GPCYCD
     C     KFXGP         CHAIN     @FXGPV1                            90
     C                   ENDIF
     C     *IN90         IFEQ      *ON
      * Check if STP rate for Manual ALL
     C                   MOVEL     'M'           GPSTPR
     C                   MOVEL     'ALL'         GPCYCD
     C     KFXGP         CHAIN     @FXGPV1                            90
     C                   ENDIF
     C     *IN90         IFEQ      *ON
      * Check if STP rate for Manual ALL
     C                   MOVEL     '*ALL'        GPGPCD
     C     KFXGP         CHAIN     @FXGPV1                            90
     C                   ENDIF
      * group found
     C     *IN90         IFEQ      *OFF
      * Convert message amount into Quotation currency
      *
     C                   CLEAR                   D#DTA
      *
     C                   MOVEL     TVCCY         @CCY                           Letter currency
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   Z-ADD     ##PYAM        D#FAMT
      *
      *                  SELECT
      *    A6NBDP        WHENEQ    0
      *                  Z-ADD     ##PYAM        D#FAMT
      *    A6NBDP        WHENEQ    1
      *    ##PYAM        MULT      10            D#FAMT
      *    A6NBDP        WHENEQ    2
      *    ##PYAM        MULT      100           D#FAMT
      *    A6NBDP        WHENEQ    3
      *    ##PYAM        MULT      1000          D#FAMT
      *                  ENDSL
      *
     C                   MOVEL     TVCCY         D#FCCY
     C                   MOVEL     GPQCCY        D#TCCY
      *
     C                   CALL      'AOCCYCV0'                           9090
     C                   PARM      *BLANKS       O#RTN             7
     C                   PARM      '*F*T*SPT'    W0ACT             8
     C     D#DTA         PARM      D#DTA         O#DTA           256
      *
     C                   MOVEL     GPQCCY        @CCY                           Letter currency
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     *LIKE         DEFINE    D#FAMT        U#FXL1
     C     *LIKE         DEFINE    D#FAMT        U#FXL2
     C     *LIKE         DEFINE    D#FAMT        U#FXL3
     C     *LIKE         DEFINE    D#FAMT        U#FXL4
     C     *LIKE         DEFINE    D#FAMT        U#FXL5
     C     *LIKE         DEFINE    D#FAMT        U#FXL6
     C     *LIKE         DEFINE    D#FAMT        U#FXL7
     C     *LIKE         DEFINE    D#FAMT        U#FXL8
     C     *LIKE         DEFINE    D#FAMT        U#FXL9
      *
     C***                SELECT
     C**   A6NBDP        WHENEQ    0
     C                   Z-ADD     GPLAM1        U#FXL1
     C                   Z-ADD     GPLAM2        U#FXL2
     C                   Z-ADD     GPLAM3        U#FXL3
     C                   Z-ADD     GPLAM4        U#FXL4
     C                   Z-ADD     GPLAM5        U#FXL5
     C                   Z-ADD     GPLAM6        U#FXL6
     C                   Z-ADD     GPLAM7        U#FXL7
     C                   Z-ADD     GPLAM8        U#FXL8
     C                   Z-ADD     GPLAM9        U#FXL9
     C***  A6NBDP        WHENEQ    1
     C***  GPLAM1        MULT      10            U#FXL1
     C***  GPLAM2        MULT      10            U#FXL2
     C***  GPLAM3        MULT      10            U#FXL3
     C***  GPLAM4        MULT      10            U#FXL4
     C***  GPLAM5        MULT      10            U#FXL5
     C***  GPLAM6        MULT      10            U#FXL6
     C***  GPLAM7        MULT      10            U#FXL7
     C***  GPLAM8        MULT      10            U#FXL8
     C***  GPLAM9        MULT      10            U#FXL9
     C***  A6NBDP        WHENEQ    2
     C***  GPLAM1        MULT      100           U#FXL1
     C***  GPLAM2        MULT      100           U#FXL2
     C***  GPLAM3        MULT      100           U#FXL3
     C***  GPLAM4        MULT      100           U#FXL4
     C***  GPLAM5        MULT      100           U#FXL5
     C***  GPLAM6        MULT      100           U#FXL6
     C***  GPLAM7        MULT      100           U#FXL7
     C***  GPLAM8        MULT      100           U#FXL8
     C***  GPLAM9        MULT      100           U#FXL9
     C***  A6NBDP        WHENEQ    3
     C***  GPLAM1        MULT      1000          U#FXL1
     C***  GPLAM2        MULT      1000          U#FXL2
     C***  GPLAM3        MULT      1000          U#FXL3
     C***  GPLAM4        MULT      1000          U#FXL4
     C***  GPLAM5        MULT      1000          U#FXL5
     C***  GPLAM6        MULT      1000          U#FXL6
     C***  GPLAM7        MULT      1000          U#FXL7
     C***  GPLAM8        MULT      1000          U#FXL8
     C***  GPLAM9        MULT      1000          U#FXL9
     C***                ENDSL
      *
      * Get customer group FX rate information
      *
     C     *LIKE         DEFINE    GPFXS1        SVFXSP
     C                   SELECT
      * Range 1
     C     GPLAM1        WHENEQ    -1
     C     U#FXL1        ORGE      D#TAMT
     C     GPDLR1        IFNE      'Y'
     C     GPFXS1        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS1        SVFXSP
     C                   ENDIF
      * Range 2
     C     GPLAM2        WHENEQ    -1
     C     U#FXL2        ORGE      D#TAMT
     C     GPDLR2        IFNE      'Y'
     C     GPFXS2        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS2        SVFXSP
     C                   ENDIF
      * Range 3
     C     GPLAM3        WHENEQ    -1
     C     U#FXL3        ORGE      D#TAMT
     C     GPDLR3        IFNE      'Y'
     C     GPFXS3        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS3        SVFXSP
     C                   ENDIF
      * Range 4
     C     GPLAM4        WHENEQ    -1
     C     U#FXL4        ORGE      D#TAMT
     C     GPDLR4        IFNE      'Y'
     C     GPFXS4        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS4        SVFXSP
     C                   ENDIF
      * Range 5
     C     GPLAM5        WHENEQ    -1
     C     U#FXL5        ORGE      D#TAMT
     C     GPDLR5        IFNE      'Y'
     C     GPFXS5        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS5        SVFXSP
     C                   ENDIF
      * Range 6
     C     GPLAM6        WHENEQ    -1
     C     U#FXL6        ORGE      D#TAMT
     C     GPDLR6        IFNE      'Y'
     C     GPFXS6        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS6        SVFXSP
     C                   ENDIF
      * Range 7
     C     GPLAM7        WHENEQ    -1
     C     U#FXL7        ORGE      D#TAMT
     C     GPDLR7        IFNE      'Y'
     C     GPFXS7        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS7        SVFXSP
     C                   ENDIF
      * Range 8
     C     GPLAM8        WHENEQ    -1
     C     U#FXL8        ORGE      D#TAMT
     C     GPDLR8        IFNE      'Y'
     C     GPFXS8        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS8        SVFXSP
     C                   ENDIF
      * Range 9
     C     GPLAM9        WHENEQ    -1
     C     U#FXL9        ORGE      D#TAMT
     C     GPDLR9        IFNE      'Y'
     C     GPFXS9        ANDNE     *BLANKS
     C                   MOVEL     'T'           P#RETN
     C                   MOVEL     GPFXS9        SVFXSP
     C                   ENDIF
     C                   ENDSL
      * If FX spread to be used store
     C     P#RETN        IFEQ      'T'
      * get present data
     C                   CALL      'FTP960'
     C                   PARM      *BLANKS       P9RTN             7
     C                   PARM                    P9PEXT
      * update data
     C                   MOVEL     SVFXSP        PXFXSP
      *
     C     P#IFXS        IFNE      *BLANKS
     C                   MOVEL     P#IFXS        PXFXSP
     C                   ENDIF
      *
     C                   CALL      'FTP960'
     C                   PARM      'STORE  '     P9RTN             7
     C                   PARM                    P9PEXT
     C                   ENDIF
      *
     C                   ENDIF                                                  FX group found
     C                   ENDIF                                                  Segment endif
      *
     C                   ENDIF                                                  Ccy convert endif
     C                   ENDIF                                                  FX endif
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCAOK   : Check PCAT data                                   *
      *                                                               *
      *  CALLED BY: Check for Multiple accounts                       *
      *                                                               *
      *****************************************************************
     CSR   SRPCAT        BEGSR
      *
      **  Map PCAT work fields                                                                ESL038
     C                   EXSR      SRMAPP
      *
      * Get message currency
      *
     C                   Z-ADD     PHMSGR        MPMSGR
     C                   Z-ADD     PHPART        MPKPRT
      * get data
     C     KINMP         CHAIN     @INMPL1                            90
      * Check if PCAT currency different from message currency
     C                   SELECT
     C     *IN90         WHENEQ    *OFF
     C     PCBCCY        ANDNE     MPCYCD
      *
     C                   SELECT
      *
      * Check if match, if currency is PLN then PLN needed otherwise no match
     C     MPCYCD        WHENEQ    'PLN'
      *
     C     KPCATA        SETLL     @PCATJ1
     C     KPCATA        READE     @PCATJ1                                90
     C     *IN90         DOUEQ     *ON
      *
      **  Map PCAT work fields                                                                ESL038
     C                   EXSR      SRMAPP
      *
      * PLN found so leave
     C     PCBCCY        IFEQ      MPCYCD
     C                   LEAVE
     C                   ENDIF
      * Read next record
     C     KPCATA        READE     @PCATJ1                                90
     C                   ENDDO
      *
      * Check if match, if currency is not PLN then PLN then EUR needed otherwise no match
     C     MPCYCD        WHENNE    'PLN'
      *
      * Note if PLN or EUR found
     C                   MOVEL     *BLANKS       ##PLN             1
     C                   MOVEL     *BLANKS       ##EUR             1
     C                   MOVEL     *BLANKS       ##USD             1
     C                   MOVEL     *BLANKS       ##GBP             1
     C                   MOVEL     *BLANKS       ##CHF             1
      *
     C     KPCATA        SETLL     @PCATJ1
     C     KPCATA        READE     @PCATJ1                                90
     C     *IN90         DOUEQ     *ON
      *
      **  Map PCAT work fields                                                                ESL038
     C                   EXSR      SRMAPP
      *
      * Account currency equals message currency
     C     PCBCCY        IFEQ      MPCYCD
     C                   LEAVE
     C                   ENDIF
      *
      * If EUR set flag
     C     PCBCCY        IFEQ      'EUR'
     C                   MOVEL     'Y'           ##EUR
     C                   ENDIF
      *
      * If PLN flag
     C     PCBCCY        IFEQ      'PLN'
     C                   MOVEL     'Y'           ##PLN
     C                   ENDIF
      *
      * If USD set flag
     C     PCBCCY        IFEQ      'USD'
     C                   MOVEL     'Y'           ##USD
     C                   ENDIF
      *
      * If GBP set flag
     C     PCBCCY        IFEQ      'GBP'
     C                   MOVEL     'Y'           ##GBP
     C                   ENDIF
      *
      * If CHF set flag
     C     PCBCCY        IFEQ      'CHF'
     C                   MOVEL     'Y'           ##CHF
     C                   ENDIF
      * Read next record
     C     KPCATA        READE     @PCATJ1                                90
     C                   ENDDO
      *
      * No direct match so look for PLN then EUR
     C     *IN90         IFEQ      *ON
     C     ##EUR         ANDEQ     'Y'
     C     *IN90         OREQ      *ON
     C     ##PLN         ANDEQ     'Y'
     C     *IN90         OREQ      *ON
     C     ##USD         ANDEQ     'Y'
     C     *IN90         OREQ      *ON
     C     ##GBP         ANDEQ     'Y'
     C     *IN90         OREQ      *ON
     C     ##CHF         ANDEQ     'Y'
      *
     C     KPCATA        SETLL     @PCATJ1
     C     KPCATA        READE     @PCATJ1                                90
     C     *IN90         DOUEQ     *ON
      *
      **  Map PCAT work fields                                                                ESL038
     C                   EXSR      SRMAPP
      *
      * If PLN exit
     C     PCBCCY        IFEQ      'PLN'
     C     ##PLN         ANDEQ     'Y'
     C                   LEAVE
     C                   ENDIF
      *
      * If EUR and no PLN exit
     C     PCBCCY        IFEQ      'EUR'
     C     ##PLN         ANDNE     'Y'
     C     ##EUR         ANDEQ     'Y'
     C                   LEAVE
     C                   ENDIF
      *
      * If USD and no EUR or PLN exit
     C     PCBCCY        IFEQ      'USD'
     C     ##PLN         ANDNE     'Y'
     C     ##EUR         ANDNE     'Y'
     C     ##USD         ANDEQ     'Y'
     C                   LEAVE
     C                   ENDIF
      *
      * If GBP and no USD, EUR or PLN exit
     C     PCBCCY        IFEQ      'GBP'
     C     ##PLN         ANDNE     'Y'
     C     ##EUR         ANDNE     'Y'
     C     ##USD         ANDNE     'Y'
     C     ##GBP         ANDEQ     'Y'
     C                   LEAVE
     C                   ENDIF
      *
      * If CHF and no GBP, USD, EUR or PLN exit
     C     PCBCCY        IFEQ      'CHF'
     C     ##PLN         ANDNE     'Y'
     C     ##EUR         ANDNE     'Y'
     C     ##USD         ANDNE     'Y'
     C     ##GBP         ANDNE     'Y'
     C     ##CHF         ANDEQ     'Y'
     C                   LEAVE
     C                   ENDIF
      * Read next record
     C     KPCATA        READE     @PCATJ1                                90
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSL
      * Currency the same as message
     C     *IN90         WHENEQ    *OFF
     C     PCBCCY        ANDEQ     MPCYCD
      * No record found
     C                   OTHER
     C                   MOVEL     *ON           *IN90
     C                   ENDSL
      *                                                                                       EEE058
      * If found check for default account                                                    EEE058
      *                                                                                       EEE058
     C     *IN90         IFEQ      *OFF
     C                   EXSR      SRDFAC
     C                   ENDIF
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************                       EEE058
      *                                                               *                       EEE058
      *  SRDMTH   : Diect math with SZOK                              *                       EEE058
      *                                                               *                       EEE058
      *  CALLED BY: Check for Partial Match                           *                       EEE058
      *                                                               *                       EEE058
      *****************************************************************                       EEE058
     CSR   SRDMTH        BEGSR
      *                                                                                       EEE058
      * Save existing match                                                                   EEE058
      *                                                                                       EEE058
     C                   MOVEL     PCIBAN        SVIBAN
     C                   MOVEL     PCRNB1        SVRNB1
     C                   MOVEL     PCRNB2        SVRNB2
     C                   MOVEL     PCBCCY        SVBCCY
     C                   MOVEL     'N'           ##NMTH            1
      *                                                                                       EEE058
      *  Check direct match with SZOK                                                         EEE058
      *                                                                                       EEE058
     C     33            SUBST(P)  O#ACLN:1      U#SZOK           33
      *                                                                                       EEE058
      *  Check for numeric                                                                    EEE058
     C     DIGITS        CHECK     U#SZOK        ##P01             5 0    92
      *                                                                                       EEE058
      *  If first invalid is position 30 check last 4 characters are blank                    EEE058
      *  if so fill with 0000 and recheck                                                     EEE058
     C     *IN92         IFEQ      *ON
     C     ##P01         ANDEQ     30
     C                   MOVE      U#SZOK        ##004A            4
     C     ##004A        IFEQ      *BLANKS
     C                   MOVE      '0000'        U#SZOK
     C     DIGITS        CHECK     U#SZOK                                 92
     C                   ENDIF
     C                   ENDIF
      *                                                                                       EEE058
     C     *IN92         IFEQ      *OFF
      *                                                                                       EEE058
      *  Numeric so check direct match                                                        EEE058
      *                                                                                       EEE058
      *  Get customer details                                                                 EEE058
      *                                                                                       EEE058
     C     16            SUBST(P)  U#SZOK:1      PCRNB1
     C     17            SUBST(P)  U#SZOK:17     PCRNB2
     C     KPCAT1        CHAIN     @PCATJ1                            90
     C  N90              EXSR      SRMAPP
     C   U1              DUMP
     C                   ENDIF
      *                                                                                       EEE058
      *  If numeric and found                                                                 EEE058
      *                                                                                       EEE058
     C     *IN92         IFEQ      *OFF
     C     *IN90         ANDEQ     *OFF
     C                   MOVEL     'Y'           ##NMTH
     C                   ELSE
     C                   MOVEL     'N'           ##NMTH
     C                   MOVEL     SVIBAN        PCIBAN
     C                   MOVEL     SVRNB1        PCRNB1
     C                   MOVEL     SVRNB2        PCRNB2
     C                   MOVEL     SVBCCY        PCBCCY
     C     KPCATA        CHAIN     @PCATJ1                            90
     C  N90              EXSR      SRMAPP
     C                   ENDIF
      *                                                                                       EEE058
     CSR                 ENDSR
     C/EJECT                                                                                  EEE058
      *****************************************************************                       EEE058
      *                                                               *                       EEE058
      *  SRDFAC   : Search for default account in currency            *                       EEE058
      *                                                               *                       EEE058
      *  CALLED BY: Check for Partial Match                           *                       EEE058
      *                                                               *                       EEE058
      *****************************************************************                       EEE058
     CSR   SRDFAC        BEGSR
      *                                                                                       EEE058
      * Save existing match                                                                   EEE058
      *                                                                                       EEE058
     C     *LIKE         DEFINE    PCIBAN        SVIBAN
     C     *LIKE         DEFINE    PCRNB1        SVRNB1
     C     *LIKE         DEFINE    PCRNB2        SVRNB2
     C     *LIKE         DEFINE    PCBCCY        SVBCCY
     C                   MOVEL     PCIBAN        SVIBAN
     C                   MOVEL     PCRNB1        SVRNB1
     C                   MOVEL     PCRNB2        SVRNB2
     C                   MOVEL     PCBCCY        SVBCCY
      *                                                                                       EEE058
      * Search for default in same currency                                                   EEE058
      *                                                                                       EEE058
     C     KPCATA        SETLL     @PCATJ1
     C     KPCATA        READE     @PCATJ1                                90
     C     *IN90         DOUEQ     *ON
      *                                                                                       ESL038
      **  Map PCAT work fields                                                                ESL038
     C                   EXSR      SRMAPP
      *                                                                                       EEE058
      * If default account in same currency use                                               EEE058
     C     PCBCCY        IFEQ      SVBCCY
     C     PCDACC        ANDEQ     'Y'
     C                   MOVEL     PCIBAN        SVIBAN
     C                   MOVEL     PCRNB1        SVRNB1
     C                   MOVEL     PCRNB2        SVRNB2
     C                   LEAVE
     C                   ENDIF
      * Read next record                                                                      EEE058
     C     KPCATA        READE     @PCATJ1                                90
     C                   ENDDO
      *                                                                                       EEE058
      * Re-establish data for account                                                         EEE058
      *                                                                                       EEE058
     C                   MOVEL     SVIBAN        PCIBAN
     C                   MOVEL     SVRNB1        PCRNB1
     C                   MOVEL     SVRNB2        PCRNB2
     C     KPCAT1        CHAIN     @PCATJ1                            90
      *                                                                                       ESL038
      **  Map PCAT work fields                                                                ESL038
     C  N90              EXSR      SRMAPP
      *                                                                                       EEE058
     CSR                 ENDSR
     C/EJECT                                                                                  EEE058
      *****************************************************************
      *                                                               *
      *  SRMATH   : Check for direct matches on PCAT, no account line *
      *                                                               *
      *  CALLED BY: Check for Direct Matches                          *
      *                                                               *
      *****************************************************************
     CSR   SRMATH        BEGSR
      *
      *  Convert string
      *
     C     34            SUBST(P)  WUORIG:1      I#ACLN
     C                   CALL      'FTP970'
     C                   PARM      *BLANKS       @RTN              7
     C                   PARM                    I#ACLN           35
     C                   PARM      *BLANKS       O#ACLN           35
      *
      *  If no account line check direct match with IBAN
      *
     C     *IN90         IFEQ      *ON
     C     26            SUBST(P)  O#ACLN:1      U#IBAN           26
      *
      *  Check for numeric
     C     DIGITS        CHECK     U#IBAN                                 92
     C     *IN92         IFEQ      *OFF
      *
      *  Numeric so check direct match
     C                   MOVEL(P)  U#IBAN        PCIBAN
     C     KPCAT2        CHAIN     @PCATJ0                            90
     C  N90              EXSR      SRMAPP
     C                   ENDIF
     C                   ENDIF
      *
      *  If no account line check direct match with SZOK
      *
     C     *IN90         IFEQ      *ON
     C     33            SUBST(P)  O#ACLN:1      U#SZOK           33
      *
      *  Check for numeric
     C     DIGITS        CHECK     U#SZOK        ##P01             5 0    92
      *
      *  If first invalid is position 30 check last 4 characters are blank
      *  if so fill with 0000 and recheck
     C     *IN92         IFEQ      *ON
     C     ##P01         ANDEQ     30
     C                   MOVE      U#SZOK        ##004A            4
     C     ##004A        IFEQ      *BLANKS
     C                   MOVE      '0000'        U#SZOK
     C     DIGITS        CHECK     U#SZOK                                 92
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN92         IFEQ      *OFF
      *
      *  Numeric so check direct match
      *
      *  Get customer details
      *
     C     16            SUBST(P)  U#SZOK:1      PCRNB1
     C     17            SUBST(P)  U#SZOK:17     PCRNB2
     C     KPCAT1        CHAIN     @PCATJ1                            90
     C  N90              EXSR      SRMAPP
     C                   ENDIF
     C                   ENDIF
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************                       ESL038
      *                                                               *                       ESL038
      *  SRMAPP   : Map PCAT work fields                              *                       ESL038
      *                                                               *                       ESL038
      *****************************************************************                       ESL038
     CSR   SRMAPP        BEGSR
      *                                                                                       ESL038
      ** Define work fields                                                                   ESL038
     C     *LIKE         DEFINE    PCCOMI        P#COMI
     C     *LIKE         DEFINE    PCCOMA        P#COMA
     C     *LIKE         DEFINE    PCFXRI        P#FXRI
     C     *LIKE         DEFINE    PCFXLA        P#FXLA
     C     *LIKE         DEFINE    PCIDOC        P#IDOC
     C     *LIKE         DEFINE    PCICUT        P#ICUT
     C     *LIKE         DEFINE    PCIFXS        P#IFXS
      *                                                                                       ESL038
     C     A#PCAT        IFEQ      'Y'
      *
      **  Set up work fields according to payment type                                        ESL038
     C     GNPYTP        IFEQ      'IN'
     C                   MOVEL     PCCOMI        P#COMI
     C                   MOVEL     PCCOMA        P#COMA
     C                   MOVEL     PCFXRI        P#FXRI
     C                   MOVEL     PCFXLA        P#FXLA
     C                   MOVEL     PCIDOC        P#IDOC
     C                   MOVEL     PCICUT        P#ICUT
     C                   MOVEL     PCIFXS        P#IFXS
     C                   ELSE
     C                   MOVEL     PCOCMI        P#COMI
     C                   MOVEL     PCOCMA        P#COMA
     C                   MOVEL     PCOXRI        P#FXRI
     C                   MOVEL     PCOXLA        P#FXLA
     C                   MOVEL     PCODOC        P#IDOC
     C                   MOVEL     PCOCUT        P#ICUT
     C                   MOVEL     PCOFXS        P#IFXS
     C                   ENDIF
      *                                                                                       ESL038
     C                   Else
      *
     C                   MOVEL     *Blanks       P#COMI
     C                   Z-add     0             P#COMA
     C                   MOVEL     *Blanks       P#FXRI
     C                   Z-add     0             P#FXLA
     C                   MOVEL     *Blanks       P#IDOC
     C                   Z-add     0             P#ICUT
     C                   MOVEL     *Blanks       P#IFXS
      *
     C                   Endif
     C
     CSR                 ENDSR
      *****************************************************************                       ESL038
     C/EJECT                                                                                  ESL038
      *****************************************************************
      *                                                               *
      *  PMATCH   : Check for Partial Match                           *
      *                                                               *
      *  CALLED BY: Main                                              *
      *                                                               *
      *****************************************************************
     CSR   PMATCH        BEGSR
      *
      *  Add Branch Number to repaired 59 and
      *  check with PCAT
      *
     C     10            SUBST(P)  @W_AccLn:1    @RNB             10
     C                   MOVE      'N'           @FOUND            1
      *
     C     *LOVAL        SETLL     FTRBRCV1
     C                   READ      FTRBRCV1                               70
     C     *IN70         DOWEQ     *OFF
     C     @FOUND        ANDNE     'Y'
      *
     C                   MOVE      *BLANKS       W@RNB1           34
     C     RBPMTH        IFEQ      'Y'
      *
     C     RBBRCH        CAT(P)    @RNB:0        W@RNB1
     C     16            SUBST(P)  W@RNB1:1      PCRNB1
     C     18            SUBST(P)  W@RNB1:17     PCRNB2
     C     KPCAT1        CHAIN     @PCATJ1                            60
     C     *IN60         IFEQ      *OFF
     C                   MOVE      'Y'           @FOUND
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      FTRBRCV1                               70
      *
     C                   ENDDO
      *
     C     @FOUND        IFNE      'Y'
     C                   SETON                                        90
     C                   ENDIF
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  STATUS   : Check for Midas Account Status                    *
      *                                                               *
      *  CALLED BY: Main                                              *
      *                                                               *
      *****************************************************************
     CSR   STATUS        BEGSR
      *
      *  Initialise Flags
      *
     C                   MOVE      *BLANKS       @BCR              1            * BLOCK CR
     C                   MOVE      *BLANKS       @INACT            1            * INACTIVE
     C                   MOVE      *BLANKS       @BANKR            1            * BANKRUPT
     C                   MOVE      *BLANKS       @BADD             1            * BAD DEBT
     C                   MOVE      *BLANKS       @CLOSE            1            * CLOSED
     C                   MOVE      *BLANKS       @BDR              1            * BLOCKED DR  HVB021
     C                   MOVE      *BLANKS       @RCR              1            * REFERRED DR HVB021
     C                   MOVE      *BLANKS       @RDR              1            * REFERRED CR HVB021
      *
     C                   TESTB     '0'           RETB                     41    REFER DR 'YES'HVB021
     C                   TESTB     '1'           RETB                     42    REFER CR 'YES'HVB021
     C                   TESTB     '2'           RETB                     43    BLOCK DR 'YES'
     C                   TESTB     '3'           RETB                     44    BLOCK CR 'YES'
     C                   TESTB     '4'           RETB                     45    INACTIVE 'YES'
     C                   TESTB     '6'           RETB                     59    BANKRUPT - YES
     C                   TESTB     '7'           RETB                     60    BAD DEBT - YES
      *
     C                   If        BISE <> 'Y'                                  STP200
      *
     C     *IN41         IFEQ      *ON                                                        HVB021
     C                   MOVE      'Y'           @RDR                                         HVB021
     C                   ENDIF                                                                HVB021
      *                                                                                       HVB021
     C     *IN42         IFEQ      *ON                                                        HVB021
     C                   MOVE      'Y'           @RCR                                         HVB021
     C                   ENDIF                                                                HVB021
      *                                                                                       HVB021
     C     *IN43         IFEQ      *ON                                                        HVB021
     C                   MOVE      'Y'           @BDR                                         HVB021
     C                   ENDIF                                                                HVB021
      *                                                                                       HVB021
     C     *IN44         IFEQ      *ON
     C                   MOVE      'Y'           @BCR
     C                   ENDIF
      *
     C     *IN45         IFEQ      *ON
     C                   MOVE      'Y'           @INACT
     C                   ENDIF
      *
     C     *IN59         IFEQ      *ON
     C                   MOVE      'Y'           @BANKR
     C                   ENDIF
      *
     C     *IN60         IFEQ      *ON
     C                   MOVE      'Y'           @BADD
     C                   ENDIF
      *
     C     ACST          IFEQ      'C'
     C                   MOVE      'Y'           @CLOSE
     C                   ENDIF
      *
     C                   ENDIF                                                  STP200
      *
     CSR                 ENDSR
     C/EJECT
**CTDATA CPY@
(C) Copyright Misys International Banking Systems Ltd. 2003
