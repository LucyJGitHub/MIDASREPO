     H DEBUG
     F*****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*OVRF*: OVRDBF (FILE IN PROGRAM) (FILE ON SYSTEM)                  : *
/*EXI *  TEXT('Midas ME Check account on PCAT')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  MEP0053 - Check account on PCAT                              *
      *                                                               *
      *  Function:  This program places the customer in the field     *
      *  from a specified account                                     *
      *                                                               *
      *                                                               *
      *  (C) Copyrignt Misys International Banking Systems 2003       *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 15Jul2011             *
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
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
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
     D**SLASH *****           25     25                                                     AR856737
     D  WUACCD                16     25  0                                                  AR856737
     D  WUACCA                16     25                                                     AR856737
     D  WUACSQ                26     27  0                                                  AR856737
     D  WUACSA                26     27                                                     AR856737
     D  WUBRCA                28     30                                                     AR856737
     D  WUORIG                31    256                                                     AR856737
     D  SLASH                 31     31                                                     AR856737
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
      *  Convert string
      *
     C     1             SUBST     WUORIG:1      U#0001            1
     C     U#0001        IFEQ      '/'
     C     34            SUBST(P)  WUORIG:2      I#ACLN           35
     C                   ELSE
     C     34            SUBST(P)  WUORIG:1      I#ACLN
     C                   ENDIF
     C                   CALL      'FTP970'
     C                   PARM      *BLANKS       @RTN              7
     C                   PARM                    I#ACLN           35
     C                   PARM      *BLANKS       O#ACLN           35
      *
      *  Get customer details
     C                   MOVEL     *BLANK        EXTMATCH          1
      *
     C     32            SUBST(P)  O#ACLN:3      PCIBAN
      * Full IBAN match
     C     KPCAT2        CHAIN     @PCATJ0                            90
     C     *IN90         IFEQ      *ON
      * IBAN match for check digit but not PL
     C                   MOVEL(P)  O#ACLN        W@IBAN           34
     C                   MOVEL     W@IBAN        W@CTRY            2
     C     W@CTRY        IFNE      'PL'
     C     'PL'          CAT(P)    W@IBAN:0      P@IBAN           36
     C                   MOVEL(P)  P@IBAN        W@IBAN
     C                   ENDIF
     C     28            SUBST(P)  W@IBAN:1      PCIBAN
     C     KPCAT2        CHAIN     @PCATJ0                            90
      *
     C     *IN90         IFEQ      *ON
      * Especially for ING
     **    16            SUBST(P)  O#ACLN:1      PCRNB1
     **    18            SUBST(P)  O#ACLN:17     PCRNB2
     C     10            SUBST(P)  O#ACLN:1      PCRNB1
     C                   MOVE      *BLANKS       PCRNB2
     C     KPCAT1        CHAIN     @PCATJ1                            90
     C     *IN90         IFEQ      *OFF
     C                   MOVE      'Y'           EXTMATCH
     C                   ENDIF
      *
     C     *IN90         IFEQ      *ON
      * Especially for ING
     **    16            SUBST(P)  O#ACLN:1      PCRNB1
     **    18            SUBST(P)  O#ACLN:17     PCRNB2
     C                   MOVEL     O#ACLN        W@CTRY
     C     W@CTRY        IFEQ      'PL'
     C     10            SUBST(P)  O#ACLN:11     PCRNB1
     C                   ELSE
     C     10            SUBST(P)  O#ACLN:9      PCRNB1
     C                   ENDIF
     C                   MOVE      *BLANKS       PCRNB2
     C     KPCAT1        CHAIN     @PCATJ1                            90
     C     *IN90         IFEQ      *OFF
     C                   MOVE      'Y'           EXTMATCH
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C   U1              DUMP
      *
      * Depending on action do
      *
     C                   MOVE      P#PTTN        U#ACT             5
     C                   SELECT
      * Check PCAT is correct
     C     U#ACT         WHENEQ    '*CABK'
     C                   EXSR      SRCABK
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
      *  SRCABK   : Check PCAT data                                   *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCABK        BEGSR
      * Check account etc
     C                   SELECT
     C     GDOPER        WHENEQ    'NE'
     C     *IN90         ANDEQ     *OFF
     C                   MOVEL     'T'           P#RETN
     C     GDOPER        WHENEQ    'EQ'
     C     *IN90         ANDEQ     *OFF
     C                   MOVEL     'T'           P#RETN
     C                   ENDSL
      *
     CSR                 ENDSR
      *****************************************************************                       ESL038
     C/EJECT                                                                                  ESL038
**CTDATA CPY@
(C) Copyright Misys International Banking Systems Ltd. 2003
