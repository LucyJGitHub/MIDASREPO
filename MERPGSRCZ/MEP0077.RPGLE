     H DEBUG
     F*****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*OVRF*: OVRDBF (FILE IN PROGRAM) (FILE ON SYSTEM)                  : *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  MEP0077 - Check Network Cut off Time                         *
      *                                                               *
      *  Function:  This program places the customer in the field     *
      *  from a specified account                                     *
      *                                                               *
      *                                                               *
      *  (C) Copyrignt Misys International Banking Systems 2003       *
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15            *
      *  Last Amend No. AR856737           Date 15Jul2011             *
      *  Last Amend No. STPIII   *Create   Date 09Aug2006             *
      * Midas Release 4.01 -------------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD31937  - Upgrade STP enhancements to BF Midas 2.1       *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
      *  STPIII - NordLB STP Phase III                                *
      *                                                               *
      *****************************************************************
     F/EJECT
      *
     FMEINMPL1  IF   E           K DISK
      *
      *  Message parts file for currency of payment and amount
      *
     FMEINCRL1  IF   E           K DISK                                                       STP001
      *                                                                                       STP001
      *  Midas ME I.M Control Retrieval index                                                 STP001
      *                                                                                       STP001
     FFTNCOTV0  IF   E           K DISK                                                       STP001
      *                                                                                       STP001
      *  Midas FT Network  Cut-Off Time                                                       STP001
      *                                                                                       STP001
      *                                                                                       STP001
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
     D**SLASH *****           25     25                                                     AR856737
     D  SLASH                 31     31                                                     AR856737
     D  LINE1                 25     59
     D  LINE2                 60     94
     D  LINE3                 95    129
     D  LINE4                130    164
     D  LINE5                165    199
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
      * Test for cut off time for given network
      *
     C                   EXSR      SRCACT
      *
     C   U1              DUMP
      *
      *  Exit program
      *
     C                   RETURN
     C/EJECT                                                                                  STP001
      *****************************************************************                       STP001
      *                                                               *                       STP001
      *  SRCACT   : Test for cut off time for given network           *                       STP001
      *                                                               *                       STP001
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
      *                                                                                       STP001
     CSR                 SETOFF                                       70
      *
     C     KNCT          KLIST
     C                   KFLD                    Network           6
     C                   KFLD                    FXpay             1
      *
     C     KINMP         KLIST
     C                   KFLD                    MPMSGR
     C                   KFLD                    MPKPRT
      *
     C                   Z-ADD     PHMSGR        MPMSGR
     C                   Z-ADD     PHPART        MPKPRT
     C                   MOVEL     'N'           FXPay
      * get data
     C     KINMP         CHAIN     @INMPL1                            50
      * Account ccy must be different from message currency
     C     *IN50         IFEQ      *OFF
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
     C/EJECT
**CTDATA CPY@
(C) Copyright Misys International Banking Systems Ltd. 2003
