     H DEBUG
     F*****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*OVRF*: OVRDBF (FILE IN PROGRAM) (FILE ON SYSTEM)                  : *
/*EXI *  TEXT('Midas ME Check if P54 is Loro account')                *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  MEP0054 - Check if P54 is Loro account                       *
      *                                                               *
      *  Function:                                                    *
      *                                                               *
      *                                                               *
      *  (C) Copyrignt Misys International Banking Systems 2003       *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 15Jul2011             *
      *                 ESL038   *CREATE   Date 18Jan2005             *
      * Midas Release 4.01 -------------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
      *  ESL038 - STP for ING                                         *
      *                                                               *
      *****************************************************************
     F/EJECT
     FMEBICDL2  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : BIC Directory
      *                                                                                       STP001
     FFTLCORV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Loro Correspondent Relationship
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
      *
     D/COPY MECPYSRC,SRERRD_ILE
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
      * Received date and time as 14 long field                                               STP001
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
      * Set up Receivers's correspondent
b01  C     P54           IFNE      *BLANKS
     C                   MOVEL     P54           DSTRAN
      *
      * Check if BIC Directory key has been supplied
     C     KBicdL2       Klist
     C                   Kfld                    BDBICC
     C                   Kfld                    BDBICB
      *
     C                   If        %Subst(Tmlin1:1:1) <> '/'                                  ESL038
     C                   Eval      BDBICC = %Subst(Tmlin1:1:8)
     C                   Eval      BDBICB = %Subst(Tmlin1:9:3)
     C                   If        %Subst(Tmlin1:9:3) = *blanks
     C                   Eval      BDBICB = 'XXX'
     C                   Endif
     C                   Else                                                                 ESL038
     C                   Eval      BDBICC = %Subst(Tmlin2:1:8)                                ESL038
     C                   Eval      BDBICB = %Subst(Tmlin2:9:3)                                ESL038
     C                   If        %Subst(Tmlin2:9:3) = *blanks                               ESL038
     C                   Eval      BDBICB = 'XXX'                                             ESL038
     C                   Endif                                                                ESL038
     C                   Endif                                                                ESL038
      *
     C     KBicdL2       Chain     @BicdL2
     C                   If        not %Found
     C                   MOVEL     'F'           P#RETN
     C                   Else
      *
     C                   Clear                   DSTRAN
     C                   Movel(P)  PDCA          DSTRAN
     C                   Movel(p)  TVCCY         BDLCCY
      *
     C     KLcorl1       Klist
     C                   Kfld                    BDBICC
     C                   Kfld                    BDBICB
     C                   Kfld                    BDLCCY
      *
     C                   Setoff                                       99
     C     KLcorl1       Chain     @Lcorv1
      *
     C                   If        not %Found
     C                   Seton                                        99
     C                   Movel     '???'         BDBICB
     C     KLcorl1       Chain     @Lcorv1
     C                   If        not %Found
     C                   Seton                                        99
     C                   Endif
     C                   Endif
      *
     C                   If        *In99 = *Off
     C                   Movel     'T'           P#RETN
     C                   Else
     C                   Movel     'F'           P#RETN
     C                   Endif
      *
     C                   Endif
      *
     C                   Endif
      *
     C   U1              DUMP
      *
      * Depending on action do
      *
     C                   RETURN
      *****************************************************************                       ESL038
     C/EJECT                                                                                  ESL038
      *
     C/COPY MECPYSRC,SRERRC_ILE
**CTDATA CPY@
(C) Copyright Misys International Banking Systems Ltd. 2003
