     H DEBUG
     F*****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Check field for payment route')               *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  MEP0020 - Check field for payment route                      *
      *                                                               *
      *  Function:  This program places the customer in the field     *
      *  from a specified account                                     *
      *                                                               *
      *  (C) Copyrignt Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 29Sep2011             *
      *                 MM2302             Date 23Feb2006             *
      *                 STP017             Date 29Nov2004             *
      *                 MM0505             Date 04May2005             *
      *                 ESL038             Date 01Dec2004             *
      *                 EEE065   *CREATE   Date 19May2004             *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancement to Midas Plus level.      *
      *           - Added PCRIT to entry parameter                    *
      *  MM2302 - Need PHMSGR in FTP0718                              *
      *  STP017 - Routing for MultiCash.                              *
      *  MM0505 - Add Value Date to Routing                           *
      *  ESL038 - ING FT STP Development                              *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
     FFTMROTV0  UF A E           K DISK
     F                                     INFSR(SRFILE)
      * ADD : STP Payment Routing Data
     FMEBICPV0  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : BIC Plus data

     FMEBICDL2  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : BIC Directory

     FMEINDTS2  IF   E           K DISK
      *
      *  Message Details
      *
     F/EJECT
      *
     D/COPY MECPYSRC,SRERRD_ILE
      *
      /COPY MECPYSRC,ME1100_ILE
      *
      *  Amount change array
     D YA1             S              1    DIM(15)
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
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      * Get Rundate - Rundate  *
      *
      *  Data Structures used by Access Objects
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
      *
      * O : To FTP0716
     D POADD           DS
      * Output Data Structure for reformatted address
     D  OADD1                  1     35
     D  OADD2                 36     70
     D  OADD3                 71    105
     D  OADD4                106    140
     D  OADD5                141    175
     D PBICP           DS
      * Output Data Structure for BIC Plus return data
     D  PINST                  1    105
     D  PBNCH                106    175
     D  PADDR                176    315
     D  PCITY                316    350
     D  PZIP                 351    365
     D  PCNTY                366    435
     D  PBIC                 436    446
     D  PNATI                447    457
     D  PCHIP                458    463
     D  PPOBN                464    498
     D  PPOBZ                499    513
     D  PPOBL                514    583
     D  PCTRY                584    585
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Data Structures used by Access Programs
     D P@FMT         E DS                  EXTNAME(DSSDY)
      * External Data structure to hold the outgoing record format
      * of the file.
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      * Switchable Features Data Structure *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * Currency details
      *
     D FTMROT        E DS                  EXTNAME(FTMROTP0)
      * Routing details
      *
     D SVMROT        E DS                  EXTNAME(FTMROTP0)
     D                                     Prefix(Sv_)
      * Routing details
      *
      * O : To FTP0715
     D O2PARM          DS           256
      * O : Message Reference
     D  O2PGM                  1     10
      * O : Preferential update
     D  O2PCOR                11     11
     D  O2BICC                12     19
     D  O2BICB                20     22
     D  O2PCCY                23     25
     D  O2CBIC                26     33
     D  O2CBIB                34     36
      *
     D BenBBiKey       S                   LIKE(BiKey)
     D DIGITS          C                   CONST('0123456789')
     D/EJECT
      *                                                                                       ESL038
      * O : To FTP0706                                                                        ESL038
      *                                                                                       ESL038
     D P7PARM          DS           256                                                       ESL038
      * O : Beneficiary                                                                       ESL038
     D  P7BENB                 1     11                                                       ESL038
      * O : Beneficiary country                                                               ESL038
     D  P7BENC                12     13                                                       ESL038
     D  P7CLCD                14     48                                                       ESL038
      *                                                                                       ESL038
     D o7PARM          DS           256                                                       ESL038
      * O : Beneficiary                                                                       ESL038
     D  o7BENB                 1     11                                                       ESL038
      * O : Beneficiary country                                                               ESL038
     D  o7BENC                12     13                                                       ESL038
      *                                                                                       ESL038
      *                                                                                       MM0505
      * Parameters for ZDATE1                                                                 MM0505
     D ZDATIN          S              6A                                                      MM0505
     D ZDAYNO          S              5P 0                                                    MM0505
     D MVDATE          S              5P 0                                                    MM0505
     D ZERR            S              1A                                                      MM0505
      *                                                                                       MM0505
      * O : Value Date Conversion                                                             MM0505
      *                                                                                       MM0505
     D @VDATE          DS             6                                                       MM0505
      * O : Beneficiary                                                                       MM0505
     D  @YY                    1      2                                                       MM0505
     D  @MM                    3      4                                                       MM0505
     D  @DD                    5      6                                                       MM0505
      *                                                                                       MM0505
      *                                                                                       MM0505
     D @@DATE          DS             6                                                       MM0505
      * O : Beneficiary                                                                       MM0505
     D  @@D                    1      2                                                       MM0505
     D  @@M                    3      4                                                       MM0505
     D  @@Y                    5      6                                                       MM0505
      *

     I@INDTS2       01
     I@IN35S2       02

     D/EJECT
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
     C                   PARM                    PDAT2                          CSW209
     C                   PARM                    PCRIT                                      AR856737
      *
      * Get Rundate - Rundate  *
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
     C     AGMBIN        IFEQ      'Y'
     C                   MOVE      *ON           *IN71
     C                   ENDIF
      *
      * Check for BIC Plus Database switchable feature
     C                   CALLB     'AOSARDR0'                           9090
     C                   Parm      *BLANKS       P@RTCD
     C                   Parm      '*VERIFY'     P@OPTN
     C                   Parm      'CFT007'      P@SARD            6
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        P@RTCD = *Blanks
     C                   Movel     'Y'           CFT007            1
     C                   Else
     C                   Movel     'N'           CFT007
     C                   End
      *
      * If true put T
     C                   MOVEL     'F'           P#RETN
      *
      *  Set fields prior to call
      *
      *  Call Routing program
      *
     C                   CLEAR                   FTMROT
      *
      * MoReci
      * Default top of screen
     C     PNWRK         IFEQ      'MTCASH'                                                   STP017
     C                   MOVEL     P32A          DSTRAN                                       STP017
     C                   ELSE                                                                 STP017
     C                   MOVEL     PDCA          DSTRAN
     C                   ENDIF                                                                STP017
     C                   MOVEL     TVCCY         MOSMCY
     C                   MOVEL     TVCCY         MOPCCY
      *
      ** Format amount field (change ',' decimal point to '.').
      *
     C                   MOVEA     *BLANKS       YA1
     C                   MOVEA     TVAMT         YA1
     C                   Z-ADD     1             C                 3 0
      *
     C     C             DOUGT     15
     C     YA1(C)        IFEQ      ','
     C                   MOVE      '.'           YA1(C)
     C                   Z-ADD     16            C
     C                   ELSE
     C                   ADD       1             C
     C                   END
     C                   END
      *
     C                   Clear                   ZFIELD
     C                   MOVEA     YA1           ZFIELD
      *
      *  Look field up on database
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      TVCCY         P@KEY             3
     C     SDCURR        PARM      *BLANKS       P@FMT
      *
     C     13            SUB       A6NBDP        ZADIG
     C                   Z-ADD     A6NBDP        ZADEC
      *
     C                   CALL      'ZALIGN'                             90
     C                   PARM      *BLANKS       ZRTN              7            B:Return Code
     C                   PARM                    ZFIELD           16            B:Check Field
     C                   PARM                    ZADEC             1 0          I:No Of Decs
     C                   PARM                    ZADIG             2 0          I:No Of Digits
     C                   PARM      *BLANKS       ZAFLD            16            O:Check Field
      *
      * Only call if amount is correct format
     C     ZRTN          IFEQ      *BLANKS
     C                   MOVE      ZFIELD        MOSMAM
     C                   Z-ADD     1             MORATE
     C                   MOVE      ZFIELD        MOPYAM
      * MoPthr
      * MoBenc
      *
     C                   Clear                   MoBenb
     C                   Clear                   MoBenc
     C                   Clear                   BenBBiKey
     C                   Clear                   U#Iban            1                          ESL038
                                                                                              ESL038
      * Check for Iban in 59                                                                  ESL038
b01  C                   If        P59 <> *blanks                                             ESL038
     C                   Eval      Dstran = P59                                               ESL038
     C                   Eval      P@Iban = %subst(TMlin1:2:34)                               ESL038
      *                                                                                       ESL038
     C                   Call      'AOIBANR5'                           90                    ESL038
     C                   Parm      *Blanks       P@Return          7                          ESL038
     C                   Parm                    P@IBAN           34                          ESL038
      *                                                                                       ESL038
     C                   If        P@Return = *blanks                                         ESL038
     C                   Eval      U#Iban = 'Y'                                               ESL038
     C                   Endif                                                                ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
      * Set up beneficiary bank                                                               ESL038
b01  C**** P57           IFNE      *BLANKS                                                    ESL038
      * P59 with account line                                                                 ESL038
b01  C                   If        P57 <> *blanks                                             ESL038
b01  C                             Or                                                         ESL038
b01  C                             P57 = *blanks and P59 <> *blanks and                       ESL038
b01  C                             U#Iban = 'Y'                                               ESL038
     C                   MOVEL     P57           DSTRAN
      *
      * If CFT007 switched on then validate beneficiary
b02  C                   If        CFT007 = 'Y'
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
     C                   If        %Found
     C                   Eval      Mobenb = BdBicc + BdBicb
     C                   Else
      *
      * Check if BIC Plus key has been supplied
     C     KBicpV0       Klist
     C                   Kfld                    BIKEY
      *
     C                   If        %Subst(Tmlin1:9:3) = *blanks
     C                   Eval      BIKEY = %Subst(Tmlin1:1:8)
     C     KBicpV0       Chain     @Bicppd
     C                   Select
     C                   When      %Found and BiBic <> *blanks
     C                   Eval      Mobenb = BiBic
     C                   When      %Found and BiBic = *blanks
     C                   Eval      Mobenc = %Subst(Bikey:1:2)
     C                   Eval      Mobenb = BiKey
     C                   Eval      BenBBiKey = BiKey
     C                   Endsl
     C                   Endif
      *
     C                   If        Mobenb = *blanks and MoBenc = *blanks        Find via Bic Search
                                                                                              ESL038
     C                   Clear                   P7Rtn                                        ESL038
     C                   If        %Subst(Tmlin1:1:1) = '/'                                   ESL038
     C                             Or U#Iban = 'Y'                                            ESL038
      * Parameters                                                                            ESL038
     C                   Eval       P7Benb = MoBenb                                           ESL038
     C                   Eval       P7Benc = MoBenc                                           ESL038
     C                   Eval       P7Clcd = TmLin1                                           ESL038
                                                                                              ESL038
      * If IBAN then use                                                                      ESL038
     C                   If        P57 = *blanks and U#Iban = 'Y'                             ESL038
     C                   Eval      Dstran = P59                                               ESL038
     C                   Eval      P7Clcd = TmLin1                                            ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
      * If clearing code then preprocess                                                      ESL038
     C                   Call      'FTP0706'                                                  ESL038
     C                   PARM                    P7RTN             7                          ESL038
     C                   PARM                    P7Parm                                       ESL038
     C                   PARM                    O7Parm                                       ESL038
     C                   Select                                                               ESL038
     C                   When      P7rtn = '*FBic'                                            ESL038
     C                   Eval      MoBenb = O7Benb                                            ESL038
     C                   Clear                   MoBenc                                       ESL038
     C                   When      P7rtn = '*FBkey'                                           ESL038
     C                   Eval      MoBenb = O7Benb                                            ESL038
     C                   Endsl                                                                ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
     C                   If        P7rtn <> '*FBic' and                                       ESL038
     C                             P7rtn <> '*FBkey'                                          ESL038
      *
     C                   MOVE      'B'           PIMODE
     C                   MOVE      TMLIN1        PICRIT
      *
     C                   CALL      'FTP0716'
     C                   PARM                    PIMODE            1
     C                   PARM                    PICRIT           35
     C                   PARM      *BLANKS       POADD           175
     C                   PARM      *BLANKS       POCHIP           10
     C                   PARM      *BLANKS       POUTCD            2
     C                   PARM      *BLANKS       PBICP
     C                   PARM      *BLANKS       PRTCD             7
      *
     C                   MOVEL     *BLANKS       PICRIT
      *
      * Return data
b03  C                   IF        PRTCD = *BLANKS
      *
      * If valid BIC code/clearing code then default else just map beneficiary
      * directly
     C                   Select
     C     POUTCD        Wheneq    'A'
     C     POUTCD        Oreq      'C'
     C     POUTCD        Oreq      'DC'
     C                   MOVEL     OADD1         MOBENB
     C     POUTCD        Wheneq    'AC'
     C                   MOVEL     OADD2         MOBENB
     C                   Other
     C                   MOVEL     TMLIN1        MOBENB
     C                   Endsl
      *
e03  C                   ENDIF
     C                   Endif                                                  Endif of Bic Dir
     C                   Endif                                                  Endif not found
     C                   Endif                                                                ESL038
      *
      * Else if CFT007 switched off then just map beneficiary directly
x02  C                   Else
     C                   MOVEL     TMLIN1        MOBENB
e02  C                   Endif
      *
e01  C                   ENDIF
      * Populate other fields
      * Bank code
     C                   If        P23B <> *Blanks
     C                   Eval      DSTRAN = P23B
     C                   Eval      MoBnkc = TMLIN
     C                   Endif
     C                   If        MoBnkc =  *Blanks
     C                   Eval      MoBnkc = 'CRED'
     C                   Endif
      * Instruction code
     C                   If        P23E <> *Blanks
     C                   Eval      DSTRAN = P23E
     C                   Eval      MoInsc = TMLIN
     C                   Endif
      * Transaction Type
     C                   If        P26T <> *Blanks
     C                   Eval      DSTRAN = P26T
     C                   Eval      MoTtyp = TMLIN
     C                   Endif
      * Ordering customer
     C                   If        P50 <> *Blanks
     C                   Eval      DSTRAN = P50
     C                   Eval      MoOrdc = TMLIN
     C                   Endif
      * Ordering bank
     C                   If        P52 <> *Blanks
     C                   Eval      DSTRAN = P52
     C                   Eval      MoOrdb = TMLIN
     C                   Endif
      * Beneficiary customer
     C                   If        P59 <> *Blanks
     C                   Eval      DSTRAN = P59
     C                   Eval      MoBenf = TMLIN
     C                   Endif
      * Sender to Reciever information
     C                   If        P72 <> *Blanks
     C                   Eval      DSTRAN = P72
     C                   Eval      MoBtbi = TMLIN
     C                   Endif
      *
      *
      * Set up Details of payment
     C     P71           IFNE      *BLANKS
     C                   MOVEL     P71           DSTRAN
     C                   MOVEL     TMLIN1        MODTCH
     C                   ENDIF
      *                                                                                       MM0505
      * Set up Messge Value Date                                                              MM0505
      *                                                                                       MM0505
     C                   CLEAR                   DSTRAN                                       MM0505
     C                   Movel     PDCA          DSTRAN                                       MM0505
     C                   Movel     TVVDAT        @VDATE                                       MM0505
     C                   Movel     @YY           @@Y                                          MM0505
     C                   Movel     @DD           @@D                                          MM0505
     C                   Movel     @MM           @@M                                          MM0505
     C                   Movel     @@DATE        ZDATIN                                       MM0505
      *                                                                                       MM0505
     C                   CallB     'ZDATE1'                                                   MM0505
     C                   Parm                    ZDATIN                                       MM0505
     C                   Parm      0             ZDAYNO                                       MM0505
     C                   Parm      'D'           BJDFIN            1                          MM0505
     C                   Parm      ' '           ZERR                                         MM0505
      *                                                                                       MM0505
     C                   Z-Add     ZDAYNO        MVDATE                                       MM0505
      *                                                                                       MM0505
      *
     C                   CLEAR                   O2PARM
     C                   MOVEL     'MEP0020'     O2PGM
      *                                                                                       EMRMK5
     C     PNWRK         IFEQ      'MTCASH'                                                   EMRMK5
     C                   MOVEL     *BLANKS       MOINSC                                       EMRMK5
     C                   ENDIF                                                                EMRMK5
      *  Set up routing key details                                                           MM2302
     C                   Eval      MoMsgr = PHMSGR                                            MM2302
     C                   Eval      MoKprt = PHPART                                            MM2302
      *                                                                                       MM2302
      *
     C                   CALL      'FTP0715'
     C                   PARM                    P0RTN             7
     C                   PARM      'R'           P0ACT             1
     C                   PARM                    O2PARM
     C                   PARM                    FTMROT
     C                   PARM                    MVDATE                                       MM0505
      *
      * If destination filled then true
      *
     C                   If        P0Rtn = 'Route'
     C                   MOVEL     'T'           P#RETN
      *
      *  Set up routing key details
     C                   Eval      MoMsgr = PHMSGR
     C                   Eval      MoKprt = PHPART
      *
      *  Set up audit stamp
     C                   TIME                    TIME              6 0
      *
     C                   MOVEL     ##JOB         MOAJOB                         Job Name
     C                   MOVEL     ##USR         MOAUSR                         User
     C                   Z-ADD     TIME          MOATIM                         Action Time
     C                   MOVEL     AGMRDT        MOARDT                         Action Date
     C                   MOVEL     'I'           MOAACT                         Action Type
     C                   Z-ADD     AGRDNB        MORDNB                         Run Day No.
      *
     C                   If        BenBBiKey <> *blanks and MoBenB = *blanks
     C                   Eval      MoBenB = BenBBikey
     C                   Endif
      *
      * Get message details for Hidden Charges
      *
     C     KIndts2a      KLIST
     C                   Kfld                    DSMSGR
     C                   Kfld                    DSPART
     C                   Kfld                    DSMTG
     C                   Kfld                    DSMSEQ
     C                   Kfld                    DSSEQN
      *
     C     KIndts2b      KLIST
     C                   Kfld                    DSMSGR
     C                   Kfld                    DSPART
     C                   Kfld                    DSMTG
      * Default for hidden charge is N
     C                   Eval      MoHdnC = 'N'
      *
      * Set up key
     C                   If        MoPccy = 'USD' and MoDtch = 'SHA'                          EEE065
     C                   Eval      DSMSGR = PhMSGR
     C                   Eval      DSPART = PhPart
     C                   If        DSPART = 0
     C                   Eval      DSPART = 1
     C                   Endif
     C                   Eval      DSMTG  = ':71I:'
     C                   Eval      DSSEQN = 0
     C                   Eval      DSMSEQ = *Blanks
      * Reset found indicators
     C                   Movel     *OFF          *In01
     C                   Movel     *OFF          *In02
      *
     C     KIndts2a      Setll     Meindts2
     C     KIndts2b      Reade     Meindts2                               90
      * If found check for 71i, hidden charge
     C                   If        *in90 = *off
      * Hidden charge|
     C                   Eval      MoHdnC = 'Y'
     C                   Endif
     C                   Endif                                                                EEE065
      *
      *  Output payment routing data
     C                   Eval      MoReci = 'D'
     C                   Eval      SvMrot = FtMrot

     C     KMrotV0       Klist
     C                   KFld                    MoMsgr
     C                   KFld                    MoKprt

     C     KMrotV0       Chain     @MrotV0
     C                   If        Not %Found
     C                   Write     @MrotV0
     C                   Else
     C                   Eval      FtMrot = SvMrot
     C                   Update    @MrotV0
     C                   Endif

     C                   ENDIF
      *
     C                   ENDIF
      *
      *  Exit program
      *
     C   U1              Dump
     C                   RETURN
      *
     C/COPY MECPYSRC,SRERRC_ILE
**CTDATA CPY@
(C) Copyright Misys International Banking Systems Ltd. 2004
