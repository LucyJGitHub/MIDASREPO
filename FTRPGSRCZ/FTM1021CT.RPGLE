     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT CCT Header Convert- File to Screen Fmt')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1021CT - Customer Credit Transfer conversion: Converts    *
      *              from database file to screen file and vice versa *
      *                                                               *
      *  Function:  This module converts the CCT header details from  *
      *             the file format retrieved in FTM1021RV to the     *
      *             display format for FTM1024DP and can also convert *
      *             in the other direction.                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. AR928996A          Date 03May12               *
      *  Prev Amend No. AR928996           Date 27Mar12               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      *                 BUG24279           Date 10Jun09               *
      *                 BUG24802           Date 08Jul09               *
      *                 BUG24843           Date 09Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15151           Date 01Nov07               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG10602           Date 16Feb06               *
      *                 221538             Date 16Jan04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178384             Date 28apr00               *
      *                 CFT006  *Create    Date 08Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR928996A- Data truncation error. Amended PDATA and PDAT2    *
      *             data structure field to have the correct length.  *
      *             (Child: AR928997A)                                *
      *  AR928996 - Data lost due to rate field :36: being truncated. *
      *             (Child: AR928997)                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  BUG24279 - Dump encountered                                  *
      *  BUG24802 - Sending institution in STP is missing             *
      *  BUG24843 - 'GL Account not found' error displayed in         *
      *             Ordering Customer upon enquiry                    *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15151 - Unable to authorise CCTD                          *
      *  CSW207 - Swift 2007 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  221538 - Expansion of field details.                         *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *           Recompile                                           *
      *  185107 - Mapping of details from swift message               *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  178384 - GEMS error, date is displayed in Midas day number   *
      *           convert it to DD/MM/YY for display purposes         *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
      *                                                               *
      *****************************************************************
      *                                                               *
      *     FUNCTION OF INDICATORS                                    *
      *     **********************                                    *
      *                                                               *
      *     Enable CF03 - Exit                                        *
      *     Enable CF12 - Cancel                                      *
      *                                                               *
      *     80    - Not multibranching                                *
      *     81    - Originating branch not used                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *     SUBROUTINES                                               *
      *     ***********                                               *
      *                                                               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦

     D/COPY MECPYSRC,ME1100_ILE
      **

      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * CCT Header details in File format
     D CctHdr        E DS                  EXTNAME(FT102HPD)

      * CCT Header details in Screen format
     D CctScnFmt     E DS                  EXTNAME(FT102HSPD)
     D  SPBRCA       E                     EXTFLD(PBRCA)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

     D P8FT            DS           128                                                       221538
      *                                                                                       221538
      ** Currency                                                                             221538
     D  W8CCY                  1      3                                                       221538
      *                                                                                       221538
      ** Settlement Type                                                                      221538
     D  W8STMT                 4      5                                                       221538
      *                                                                                       221538
      ** Mandatory Text - convert BIC identifiers                                             221538
     D  W8MTXT                 6      6                                                       221538
      *                                                                                       221538
      ** Message Tag                                                                          221538
     D  W8MTAG                 7     11                                                       221538
      *                                                                                       221538
      ** Construct of data in field                                                           221538
     D  W8TYPE                12     12                                                       221538
      *                                                                                       221538
      ** Number of Lines available                                                            221538
     D  W8NLIN                13     14  0                                                    221538
      *                                                                                       221538
      ** Network and Message Type                                                             221538
     D  W8NWRK                15     20                                                       221538
     D  W8MTPY                21     23                                                       221538
      *                                                                                       221538
      ** Calling Program                                                                      221538
     D  W8CPGM                24     33                                                       221538
      *                                                                                       221538
      ** Action *PRINT/*ENQ/*MSG GEN                                                          221538
     D  W8ACT                 34     41                                                       221538
      *                                                                                       221538
      ** Critical Reporting - Database error if 'Y'.                                          221538
      ** If no BIC directory and BIC entered, no error.                                       221538
     D  W8CRIT                42     42                                                       221538
      *                                                                                       221538
      ** Force Midas Address - where possible                                                 221538
     D  W8MADD                43     43                                                       221538
      *                                                                                       221538
      ** If Retail, get first address from account                                            221538
     D  W8RTAD                44     44                                                       221538
      *                                                                                       221538
      ** Alternative Address                                                                  221538
     D  W8ALTN                45     45                                                       221538
      *                                                                                       221538
      ** Address Type                                                                         221538
     D  W8ADTP                46     46                                                       221538
      *                                                                                       221538
      ** DS for Redefining Address Fields                                                     221538
     D                 DS                                                                     221538
     D  WADDRSS                1    175                                                       221538
     D  WADCHK1                1     35                                                       221538
     D  WADCHK2               36     70                                                       221538
     D  WADCHK3               71    105                                                       221538
     D  WADCHK4              106    140                                                       221538
     D  WADCHK5              141    175                                                       221538
      *                                                                                       221538
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Constant
     D NbType          C                   CONST(10)

      ** Parameters for ZALIGN
     D Zalignok        S              1
     D Zfield          S             16
     D Zadec           S              1  0
     D Zadig           S              2  0

      ** Parameters for ZDATE1
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D DatFmt          S              1A
     D ErrorFlag       S              1A

      ** Parameters passed on entry - for conversion type
     D CnvTyp          S              2

      ** Parameters passed on entry - for conversion type
     D TypAcct         S              1    DIM(10)

      ** Working variable for conversion of exchange rate on swift
     D WCctrte         S              1    DIM(16)

      ** Working variable for conversion of exchange rate on swift
     D TCctrte         S             16

     D AplyType        S              1    Dim(NBTYPE)

      ** Position of ',' into an amount
     D Comma           S              2  0

      ** Parameters for ME1330
     D Prefix          S             20A
     D SpecialC        S            256A
     D AplyValue       S            256A
     D TypeValue       S              1A

     D RetCode         S                   LIKE(RetCodeIn)

      ** Working CCy variables for sum of sender's charges and sum
      ** of receivers charges (since not on FT102HPd file)
     D SndCcy          S              3
     D RcvCCy          S              3

      ** Message reference                                                      185107
     D MgmsgR          S                   LIKE(PhmsgR)                         185107
                                                                                              CSW207
      ** Swift 2007                                                                           CSW207
     D CSW207          S              1                                                       CSW207
      ** Swift 2009                                                                           CSW209
     D CSW209          S              1                                                       CSW209
     D RetCd           S              7                                                       CSW207
                                                                                              CSW207
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *
      ** Check to see the direction of the conversion (from file to screen
      ** and vice versa)
      *
     C                   IF        CnvTyp = 'SH'
     C                             OR CnvTyp = 'XD'                                         BUG15151
     C                   EVAL      CctScnFmt = *BLANKS
     C                   ELSE
     C                   CLEAR                   CctHdr
     C                   ENDIF
      *
      ** Set Output Screen Fields
      *
     C                   IF        CnvTyp = 'SH'
     C                             OR CnvTyp = 'XD'                                         BUG15151
     C**********         IF        PDATA = *BLANK                                             CSW209
     C                   IF        (PDATA = *BLANK AND                                        CSW209
     C                             PDAT2  = *BLANK)                                           CSW209
     C                   EXSR      SetScn
     C                   ELSE
     C                   EXSR      SwiftMe
     C                   EXSR      SetScn
     C                   ENDIF
     C                   ELSE
      *
      ** Set Output File Fields
      *
     C**********         IF        PData = *BLANKS                                            CSW209
     C                   IF        (PDATA = *BLANK AND                                        CSW209
     C                             PDAT2  = *BLANK)                                           CSW209
     C                   EXSR      SetFle
     C                   ELSE
     C                   EXSR      SwiftMe
     C                   ENDIF
     C                   ENDIF
      *
      ** Exit module and return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT                                                                                  221538
      *****************************************************************                       221538
      *                                                               *                       221538
      *  SREXPGM - Call expansion program FT0315                      *                       221538
      *                                                               *                       221538
      *****************************************************************                       221538
      *                                                                                       221538
     C     SREXPGM       BEGSR                                                                221538
      *                                                                                       221538
      ** Call expansion program.                                                              221538
      *                                                                                       221538
     C                   CALL      'FT0315'                             9090                  221538
     C                   PARM      *BLANKS       P8RTN             7                          221538
     C                   PARM                    P8FT                                         221538
     C                   PARM                    P8LINS          256                          221538
     C                   PARM                    P8RPT           256                          221538
     C                   PARM                    P8MSG           256                          221538
     C                   PARM                    P8SCR           256                          221538
      *                                                                                       221538
      ** Check if database error occurred.                                                    221538
      *                                                                                       221538
     C     *IN90         IFEQ      '1'                                                        221538
     C     P8RTN         ORNE      *BLANKS                                                    221538
     C                   MOVEL     '*CALL'       DBKEY                                        221538
     C                   MOVEL     'FT0315  '    DBFILE                                       221538
     C                   Z-ADD     5             DBASE                                        221538
     C                   EXSR      *PSSR                                                      221538
     C                   ENDIF                                                                221538
      *                                                                                       221538
     C                   ENDSR                                                                221538
      *                                                                                       221538
      *****************************************************************                       221538
      /EJECT
      *****************************************************************
      ** SwiftMe - Map Swift Messages
      *****************************************************************
      *
     C     SwiftMe       BEGSR
      *
      ** Initialise fields
      *
     C                   EVAL      AplyType = *Blanks
      *
      ** File reference
      *
     C                   IF        PH20 <> *BLANKS
     C                   RESET                   DsTran
     C                   MOVEL     PH20          Dstran
     C                   EVAL      FilRef = Ttref
     C                   ENDIF
      *
      ** Bank Operation Code
      *
     C                   IF        PH23 <> *BLANKS
     C                   RESET                   DSTRAN
     C                   MOVEL     PH23          Dstran
     C                   EVAL      CCtBoC = TTref
     C                   ENDIF
      *
      ** Sending Institution
      *
     C                   IF        PH51A <> *BLANKS
     C                   MOVEL     PH51A         Dstran
     C                   IF        Trcode = *BLANKS
     C                   EVAL      Sinst = TmLin1
     C                   ELSE
     C                   EVAL      AplyType(1) = 'C'
     C                   EVAL      AplyType(2) = 'F'
     C                   EVAL      AplyType(3) = 'G'
     C                   EVAL      AplyType(4) = 'R'
     C                   EXSR      APLYTRN
     C                   EVAL      SINST = AplyValue
     C                   ENDIF
     C                   ELSE                                                               BUG24802
     C                   MOVEL     PSN           DSTRAN                                     BUG24802
     C                   IF        Trcode = *BLANKS                                         BUG24802
     C                   EVAL      Sinst = TmLin1                                           BUG24802
     C                   ELSE                                                               BUG24802
     C                   EVAL      AplyType(1) = 'F'                                        BUG24802
     C                   EVAL      AplyType(2) = 'R'                                        BUG24802
     C                   EVAL      AplyType(3) = 'G'                                        BUG24802
     C                   EXSR      APLYTRN                                                  BUG24802
     C                   EVAL      Sinst = AplyValue                                        BUG24802
     C                   ENDIF                                                              BUG24802
     C                   ENDIF
      *
      ** Ordering Customer
      *
     C                   IF        PH50 <> *BLANKS
     C                   RESET                   DsTran
     C                   MOVEL     PH50          Dstran
     C                   IF        Trcode = *BLANKS
     C                   EVAL      ToCus1 = TmLin1
     C                   EVAL      ToCus2 = TmLin2
     C                   EVAL      ToCus3 = TmLin3
     C                   EVAL      ToCus4 = TmLin4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      ToCus5 = TmLin5                                            CSW207
     C                   ENDIF                                                                CSW207
     C                   ELSE
     C                   EVAL      AplyType(1) = 'F'
     C                   EVAL      AplyType(2) = 'R'
     C                   EVAL      AplyType(3) = 'G'
     C                   EXSR      APLYTRN
     C                   EVAL      ToCus1 = AplyValue
     C                   ENDIF
     C                   ENDIF
      *
      ** Ordering Institution
      *
     C                   IF        PH52 <> *BLANKS
     C                   RESET                   DsTran
     C                   MOVEL     PH52          Dstran
     C                   IF        TRCODE = *Blanks
     C                   EVAL      Oinst3 = TmLin1
     C                   ELSE
     C                   EVAL      AplyType(1) = 'C'
     C                   EVAL      AplyType(2) = 'F'
     C                   EVAL      AplyType(3) = 'R'
     C                   EVAL      AplyType(4) = 'G'
     C                   EXSR      APLYTRN
     C                   EVAL      Oinst3 = AplyValue
     C                   ENDIF
     C                   ENDIF
      *
      ** Transaction Type Code
      *
     C                   IF        PH26T <> *BLANKS
     C                   RESET                   Dstran
     C                   MOVEL     PH26T         Dstran
     C                   EVAL      TrnStp = Tmlin1
     C                   ENDIF
      *
      ** Regulatory Reporting
      *
     C                   IF        PH77B <> *BLANKS
     C                   RESET                   Dstran
     C                   MOVEL     PH77B         Dstran
     C                   EVAL      RegRp1 = Tmlin1
     C                   EVAL      RegRp2 = Tmlin2
     C                   EVAL      RegRp3 = Tmlin3
     C                   ENDIF
      *
      ** Details of Charges
      *
     C                   IF        PH71 <> *BLANKS
     C                   RESET                   Dstran
     C                   MOVEL     PH71          Dstran
     C                   EVAL      CctChg = TtRef
     C                   ENDIF
      *
      ** Exchange Rate
      *
      ** DO NOT MAP EXHANGE RATE FROM SWIFT TAG 36
      ** (tag 36 is for the exchange rate between original ordered
      ** amount-pay amount in file in 'BO'- and transfer amount)
      *
      ** Sequence C fields mapped to header file
      ** Total transfer amount/value date/currency
      *
     C                   IF        PH32A <> *BLANKS
     C                   RESET                   DSTRAN
     C                   MOVEL     PH32A         Dstran
      *
      ** Map total transfer date
     C                   IF        TVVDat <> *Zeros
     C                   MOVE      TVVDat        Pttvdte
      ** Swift Convention date format is YYMMDD
      ** We need to reformat it into  DDMMYY before converting
      ** it into Midas day number (parm accepted are only D or M)
     C                   EVAL      %SUBST(Pttvdte:1:2) = %SUBST(TVDCA:5:2)
     C                   EVAL      %SUBST(Pttvdte:3:2) = %SUBST(TVDCA:3:2)
     C                   EVAL      %SUBST(Pttvdte:5:2) = %SUBST(TVDCA:1:2)
     C                   CALLB     'ZDATE1'
     C                   PARM      Pttvdte       DateIn
     C                   PARM      *ZEROS        DaynoOut
     C                   PARM      'D'           DatFmt
     C                   PARM      *BLANKS       ErrorFlag
     C                   Z-ADD     DaynoOut      TTvDte
     C                   ELSE
     C                   Z-ADD     *ZEROS        TTvDte
     C                   ENDIF
      *
      ** Map total transfer currency and amount
     C                   IF        TVccy <> *BLANKS
     C                   EVAL      CCtCcy = TVCcy
     C                   EVAL      Comma = %scan(',':TVAMT)
     C                   IF        Comma <> 0
     C                   EVAL       %subst(TvAMT:Comma:1) = '.'
     C                   ENDIF
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      CctCcy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format total transfer amount
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      TVAmt         Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
      *
     C                   MOVE      Zfield        Cctamt
     C                   ENDIF
     C                   ENDIF
      *
      ** Sum of amounts
      *
     C                   IF        PH19 <> *BLANKS
     C                   MOVEL     PH19          DSTRAN
     C                   EVAL      Comma = %scan(',':TSAMT)
     C                   IF        Comma <> 0
     C                   EVAL       %subst(TSAMT:Comma:1) = '.'
     C                   ENDIF
      *
     C                   IF        CCtCcy <> *BLANKS
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      CctCcy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format sum of amounts
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVEL     TSAMT         Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
      *
     C                   MOVE      Zfield        SumCct
     C                   ENDIF
     C                   ENDIF
      *
      ** Sum of sender's charges amount/ccy
      *
     C                   IF        PH71F <> *BLANKS
     C                   RESET                   DSTRAN
     C                   MOVEL     PH71F         DSTran
     C                   IF        TTccy <> *BLANKS
     C                   EVAL      SndCcy = TTCcy
     C                   EVAL      Comma = %scan(',':TTAMT)
     C                   IF        Comma <> 0
     C                   EVAL       %subst(TTAMT:Comma:1) = '.'
     C                   ENDIF
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      SndCcy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format sum of senders charges
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      TTAMT         Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
      *
     C                   MOVE      Zfield        SumScg
     C                   ENDIF
     C                   ENDIF
      *
      ** Sum of receivers charges amount/ccy
      *
     C                   IF        PH71G <> *BLANKS
     C                   RESET                   DSTRAN
     C                   MOVEL     PH71G         DSTran
     C                   IF        TTccy <> *BLANKS
     C                   EVAL      RcvCcy = TTCcy
     C                   EVAL      Comma = %scan(',':TTAMT)
     C                   IF        Comma <> 0
     C                   EVAL       %subst(TTAMT:Comma:1) = '.'
     C                   ENDIF
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      RcvCcy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format sum of receivers charges
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      TTAMT         Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
      *
     C                   MOVE      Zfield        SumRch
     C                   ENDIF
     C                   ENDIF
      *
      ** Sender's correspondent
      *
     C                   IF        PH53 <> *BLANKS
     C                   RESET                   DSTRAN
     C                   MOVEL     PH53          DSTran
     C                   IF        Trcode = *BLANKS
     C                   EVAL      SndCor = TmLin1
     C                   ELSE
     C                   EVAL      AplyType(1) = 'F'
     C                   EVAL      AplyType(2) = 'R'
     C                   EVAL      AplyType(3) = 'G'
     C                   EXSR      APLYTRN
     C                   EVAL      SndCor = AplyValue
     C                   ENDIF
     C                   ENDIF
      *
      ** Receiver's correspondent
      *
     C                   IF        PH54 <> *BLANKS
     C                   RESET                   DSTRAN
     C                   MOVEL     PH54          DSTran
     C                   IF        Trcode = *BLANKS
     C                   EVAL      RcvCor = TmLin1
     C                   ELSE
     C                   EVAL      AplyType(1) = 'F'
     C                   EVAL      AplyType(2) = 'R'
     C                   EVAL      AplyType(3) = 'G'
     C                   EXSR      APLYTRN
     C                   EVAL      RcvCor = AplyValue
     C                   ENDIF
     C                   ENDIF
      *
      ** Sender to receiver Information (additional information)
      *
     C                   IF        PH72 <> *BLANKS
     C                   RESET                   DSTRAN
     C                   MOVEL     PH72          DSTran
     C                   EVAL      AdnLi1 = TmLin1
     C                   EVAL      AdnLi2 = TmLin2
     C                   EVAL      AdnLi3 = TmLin3
     C                   EVAL      AdnLi4 = TmLin4
     C                   EVAL      AdnLi5 = TmLin5
     C                   EVAL      AdnLi6 = TmLin6
     C                   ENDIF
      *

      ** Map Swift ID
     C                   Eval      STID = PSNDR
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C**********         EVAL      CCNWRK = PSNWRK                                   CSW209 BUG24279
     C**********         EVAL      CCMTPY = PSMTPY                                   CSW209 BUG24279
     C                   EVAL      CCNWRK = PNWRK                                           BUG24279
     C                   EVAL      CCMTPY = PMTPY                                           BUG24279
     C                   EVAL      CCVALF = P119                                              CSW209
     C                   EVAL      CCOMVF = *BLANKS                                           CSW209
     C                   EVAL      CCOCVF = *BLANKS                                           CSW209
     C                   ENDIF                                                                CSW209
      *                                                                         185107
      ** Message Reference                                                      185107
      *                                                                         185107
     C                   Z-ADD     MGMSGR        CHMSGR                         185107
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SetScn - Set Output Screen Fields
      *****************************************************************
      *
     C     SetScn        BEGSR
      *
      ** Screen 1
      *
      ** Customer Credit Transfer ID
      *
     C                   MOVE      Cctid         PCctid
      *
      ** File Reference
      *
     C                   MOVE      Filref        PFilref
      *
      ** Cct transfer type
      *
     C                   MOVE      Ccttyp        PCcttyp
      *
      ** Transfer Sub Type
      *
     C                   MOVE      Ccttst        PCcttst
      *
      ** Booking Branch
      *
     C                   MOVE      Brca          SPbrca
      *
      ** Originating Branch
      *
     C                   MOVE      Orbr          POrbr
      *
      ** Book Code
      *
     C                   MOVE      Bokc          PBokc
      *
      ** Profit Centre
      *
     C                   MOVE      Prfc          PPrfc
      *
      ** Swift Priority
      *
     C                   MOVE      Swprio        PSwprio
      *
      ** Ordering Institution
      *
     C                   MOVE      Oinst3        POinst3
      *
     C                   MOVE      Oinst1        POinst1
      *
      ** Ordering Customer
      *
     C                   MOVE      Tocus1        PTocus1
     C                   MOVE      Tocus2        PTocus2
     C                   MOVE      Tocus3        PTocus3
     C                   MOVE      Tocus4        PTocus4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      PTocus5 = TOCUS5                                           CSW207
     C                   ENDIF                                                                CSW207
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   EVAL      PSNWRK = CCNWRK                                            CSW209
     C                   EVAL      PSMTPY = CCMTPY                                            CSW209
     C                   EVAL      PSVALF = CCVALF                                            CSW209
     C                   EVAL      POMVLF = CCOMVF                                            CSW209
     C                   EVAL      POCVLF = CCOCVF                                            CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       221538
     C     Actn          IFEQ      'E'                                                        221538
      *                                                                                       221538
     C                   CLEAR                   P8FT                                         221538
     C                   MOVEL     *BLANKS       W8STMT                                       221538
     C                   MOVEL     PSPROCPGM     W8CPGM                                       221538
     C                   MOVEL     '*ENQ  '      W8ACT                                        221538
     C                   Z-ADD     5             W8NLIN                                       221538
      *                                                                                       221538
     C                   MOVEL     CUSTTH        W8TYPE                                       221538
     C                   MOVEL     *BLANKS       P8LINS                                       221538
     C                   MOVEL     *BLANKS       WADDRSS                                      221538
     C                   MOVEL     *BLANKS       WLDGER                                       221538
      *                                                                                     BUG24843
     C                   MOVEL     *BLANKS       CUST01           35                        BUG24843
     C                   MOVEL     TOCUS1        CUST01                                     BUG24843
     C                   IF        %SUBST(TOCUS1:1:1) = '/'                                 BUG24843
     C                   EVAL      TOCUS1 = %SUBST(TOCUS1:2:34)                             BUG24843
     C                   ENDIF                                                              BUG24843
      *                                                                                     BUG24843
     C     CUSTTH        IFEQ      'G'                                                        221538
     C                   MOVEL     TOCUS1        WLDGER           18                          221538
     C                   MOVE      WLDGER        WACCNT           15                          221538
     C                   MOVEL     WLDGER        WBRCA             3                          221538
     C     WACCNT        CAT       WBRCA         WADCHK1                                      221538
     C                   ELSE                                                                 221538
     C                   MOVEL     TOCUS1        WADCHK1                                      221538
     C                   ENDIF                                                                221538
     C                   MOVEL     CUST01        TOCUS1                                     BUG24843
     C                   MOVEL     TOCUS2        WADCHK2                                      221538
     C                   MOVEL     TOCUS3        WADCHK3                                      221538
     C                   MOVEL     TOCUS4        WADCHK4                                      221538
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      WADCHK5 = TOCUS5                                           CSW207
     C                   ELSE                                                                 CSW207
     C                   MOVEL     *BLANKS       WADCHK5                                      221538
     C                   ENDIF                                                                CSW207
     C                   MOVEL     WADDRSS       P8LINS                                       221538
      *                                                                                       221538
     C                   EXSR      SREXPGM                                                    221538
      *                                                                                       221538
     C     35            SUBST     P8SCR:1       PTOCUS1                                      221538
     C     CUSTTH        IFEQ      'G'                                                        221538
     C                   MOVEL     WLDGER        PTOCUS1                                      221538
     C                   ENDIF                                                                221538
     C     35            SUBST     P8SCR:36      PTOCUS2                                      221538
     C     35            SUBST     P8SCR:71      PTOCUS3                                      221538
     C     35            SUBST     P8SCR:106     PTOCUS4                                      221538
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      PTOCUS5 = %SUBST(P8SCR:141:35)                             CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       221538
     C                   ENDIF                                                                221538
      *
      ** Sending Institution
      *
     C                   MOVE      Sinst         PSinst
      *
      ** Destination
      *
     C                   MOVE      Cctdst        PCctdst
      *
      ** Senders correspondent
      *
     C                   MOVE      Sndcor        PSndcor
      *
      ** Recievers correspondent
      *
     C                   MOVE      Rcvcor        PRcvcor
      *
      ** Debit Value Date
      *
     C                   IF        Dbtvdt <> *ZEROS
     C                   Z-ADD     Dbtvdt        Zdayno
     C                   EXSR      SRCctdt
     C                   MOVE      ZDate         PDbtvdt
     C                   ELSE
     C                   MOVEL     *BLANKS       PDbtvdt
     C                   ENDIF
      *
      ** Transfer amount and transfer CCy (total)
      *
     C                   IF        Cctccy <> *BLANKS
     C                   MOVE      Cctccy        PCctccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      Cctccy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format transfer amount
      *
     C                   IF        Cctamt <> 0                                              BUG15151
     C                   Z-ADD     Cctamt        @@Amtw
     C                   Z-ADD     A6NBDP        @@Qecn
     C                   EXSR      SRCctam
     C                   MOVE      @@Amtd        PCctamt
     C                   ELSE                                                               BUG15151
     C                   MOVEL     *BLANKS       PCctamt                                    BUG15151
     C                   ENDIF                                                              BUG15151
     C                   ELSE
     C                   MOVEL     *BLANKS       PCctCcy
     C                   MOVEL     *BLANKS       PCctamt
     C                   ENDIF
      *
      ** Transfer Date
      *
     C                   IF        Ttvdte <> *ZEROS
     C                   Z-ADD     Ttvdte        ZDAYNO
     C                   EXSR      SRCctdt
     C                   MOVE      Zdate         PTtvdte
     C                   ELSE
     C                   MOVEL     *BLANKS       PTtvdte
     C                   ENDIF
      *
      ** Exchange rate
      *
     C                   IF        CctRte <> *ZEROS
      *
     C                   MOVE      CctRte        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      8             ZADEC             1 0
      *
     C                   MOVE      ZFIELD        PCctRte
     C                   ENDIF
      *
      ** Sum of amounts
      *
     C                   IF        Cctccy <> *BLANKS
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      Cctccy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format Sum of amount
      *
     C                   Z-ADD     SumCct        @@Amtw
     C                   Z-ADD     A6NBDP        @@Qecn
     C                   EXSR      SRCctam
     C                   MOVE      @@Amtd        PSumCct
     C                   ELSE
     C                   MOVEL     *BLANKS       PSumCct
     C                   ENDIF
      *
      ** Screen 2
      *
      ** Details of charges
      *
     C                   MOVE      Cctchg        PCctchg
      *
      ** Sum of Senders charges
      *
     C                   IF        Sumscg <> *ZEROS  AND
     C                             CctCcy <> *BLANKS
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      Cctccy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format Sum of senders charges
      *
     C                   Z-ADD     Sumscg        @@Amtw
     C                   Z-ADD     A6NBDP        @@Qecn
     C                   EXSR      SRCctam
     C                   MOVE      @@Amtd        PSumScg
     C                   ELSE
     C                   MOVEL     *BLANKS       PSumScg
     C                   ENDIF
      *
      ** Sum of Recievers charges
      *
     C                   IF        SumRch <> *ZEROS AND
     C                             CCtCcy <> *BLANKS
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      Cctccy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format Sum of Recievers charges
      *
     C                   Z-ADD     SumRch        @@Amtw
     C                   Z-ADD     A6NBDP        @@Qecn
     C                   EXSR      SRCctam
     C                   MOVE      @@Amtd        PSumRch
     C                   ELSE
     C                   MOVEL     *BLANKS       PSumRch
     C                   ENDIF
      *
      ** Transaction type code
      *
     C                   MOVE      Trnstp        PTrnstp
      *
      ** Regulatory Reporting
      *
     C                   MOVE      Regrp1        Pregrp1
     C                   MOVE      Regrp2        Pregrp2
     C                   MOVE      Regrp3        Pregrp3
      *
      ** Bank Operation Code
      *
     C                   MOVE      Cctboc        PCctboc
      *
      ** Additional Information
      *
     C                   MOVE      AdnlI1        PAdnlI1
     C                   MOVE      AdnlI2        PAdnlI2
     C                   MOVE      AdnlI3        PAdnlI3
     C                   MOVE      AdnlI4        PAdnlI4
     C                   MOVE      AdnlI5        PAdnlI5
     C                   MOVE      AdnlI6        PAdnlI6
      *
      ** Types (hidden fields)
      *
      ** Sending institution type
      *
     C                   MOVE      Sinstt        PSinstt
      *
      ** Destination type
     C                   MOVE      Dsttyp        PDsttyp
      *
      ** Ordering customer type
     C                   MOVE      Custth        PCustth
      *
      ** Ordering institution type
     C                   MOVE      Orditp        POrditp
      *
      ** Senders correspondent type
     C                   MOVE      Sndtyp        PSndtyp
      *
      ** Recievers correspondent type
     C                   MOVE      Rcvtyp        PRcvtyp
      *
      ** User Data
      *
     C                   MOVEL     INUSER        PINUSER
     C**********         MOVEL     INDATE        PINDATE                        178384
     C                   IF        Indate <> *ZEROS                             178384
     C                   Z-ADD     Indate        Zdayno                         178384
     C                   EXSR      SRCctdt                                      178384
     C                   MOVE      ZDate         PIndate                        178384
     C                   ELSE                                                   178384
     C                   MOVEL     *BLANKS       PIndate                        178384
     C                   ENDIF                                                  178384
      *                                                                         178384
     C                   MOVEL     INTIME        PINTIME
     C                   MOVEL     UPDUSR        PUPDUSR
      *                                                                         178384
     C********           MOVEL     UPDDTE        PUPDDTE                        178384
     C                   IF        Upddte <> *ZEROS                             178384
     C                   Z-ADD     Upddte        Zdayno                         178384
     C                   EXSR      SRCctdt                                      178384
     C                   MOVE      ZDate         PUpddte                        178384
     C                   ELSE                                                   178384
     C                   MOVEL     *BLANKS       PUpddte                        178384
     C                   ENDIF                                                  178384
      *                                                                         178384
     C                   MOVEL     UPDTIM        PUPDTIM
     C                   MOVEL     AUP1          PAUP1
     C                   MOVEL     AUP2          PAUP2
     C                   MOVEL     CDUAL         PCDUAL
     C                   MOVEL     AUIN          PAUIN
     C                   MOVEL     BAUTH         PBAUTH
     C                   MOVEL     BATUSR        PBATUSR
      *
      ** Swift Reference
      *
     C                   MOVEL     STID          PSTID
      *                                                                         185107
      ** Message Reference                                                      185107
      *                                                                         185107
     C                   Z-ADD     CHMSGR        PCHMSGR                        185107
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SetFle - Set Output File Fields
      *****************************************************************
      *
     C     SetFle        BEGSR
      *
      ** Screen 1
      *
      ** Customer Credit Transfer ID
      *
     C                   MOVE      PCctid        Cctid
      *
      ** File Reference
      *
     C                   MOVE      PFilref       Filref
      *
      ** Cct transfer type
      *
     C                   MOVE      PCcttyp       Ccttyp
      *
      ** Transfer Sub Type
      *
     C                   MOVE      PCcttst       Ccttst
      *
      ** Booking Branch
      *
     C                   MOVE      SPBrca        Brca
      *
      ** Originating Branch
      *
     C                   MOVE      POrbr         Orbr
      *
      ** Book Code
      *
     C                   MOVE      PBokc         Bokc
      *
      ** Profit Centre
      *
     C                   MOVE      PPrfc         Prfc
      *
      ** Swift Priority
      *
     C                   MOVE      PSwprio       Swprio
      *
      ** Ordering Institution
      *
     C                   MOVE      POinst3       Oinst3
      *
     C                   MOVE      POinst1       Oinst1
      *
      ** Ordering Customer
      *
     C                   MOVE      PTocus1       Tocus1
     C                   MOVE      PTocus2       Tocus2
     C                   MOVE      PTocus3       Tocus3
     C                   MOVE      PTocus4       Tocus4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      TOCUS5 = PTOCUS5                                           CSW207
     C                   ENDIF                                                                CSW207
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   EVAL      CCNWRK  = PSNWRK                                           CSW209
     C                   EVAL      CCMTPY  = PSMTPY                                           CSW209
     C                   EVAL      CCVALF  = PSVALF                                           CSW209
     C                   EVAL      CCOMVF  = POMVLF                                           CSW209
     C                   EVAL      CCOCVF  = POCVLF                                           CSW209
     C                   ENDIF                                                                CSW209
      *
      ** Sending Institution
      *
     C                   MOVE      PSinst        Sinst
      *
      ** Destination
      *
     C                   MOVE      PCctdst       Cctdst
      *
      ** Senders correspondent
      *
     C                   MOVE      PSndcor       Sndcor
      *
      ** Recievers correspondent
      *
     C                   MOVE      PRcvcor       Rcvcor
      *
      ** Debit Value Date
      *
     C                   IF        PDbtvdt <> *BLANKS
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      PDbtvdt       DateIn
     C                   PARM      *ZEROS        DaynoOut
     C                   PARM      BJDFIN        DatFmt
     C                   PARM      *BLANKS       ErrorFlag
      *
     C                   Z-ADD     DaynoOut      Dbtvdt
      *
     C                   ELSE
      *
     C                   Z-ADD     *ZEROS        Dbtvdt
      *
     C                   ENDIF
      *
      ** Total Transfer amount and transfer CCy
      *
     C                   IF        PCctccy <> *BLANKS
     C                   MOVE      PCctccy       Cctccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      PCctccy       @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format total transfer amount
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      PCCtamt       Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
     C                   MOVE      Zfield        Cctamt
      *
     C                   ELSE
     C
     C                   MOVE      *Blanks       Cctccy
     C                   Z-ADD     *Zeros        CctAmt
      *
     C                   ENDIF
      *
      ** Transfer Date
      *
     C                   IF        PTtvdte <> *BLANKS
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      Pttvdte       DateIn
     C                   PARM      *ZEROS        DaynoOut
     C                   PARM      BJDFIN        DatFmt
     C                   PARM      *BLANKS       ErrorFlag
      *
     C                   Z-ADD     DaynoOut      Ttvdte
      *
     C                   ELSE
      *
     C                   Z-ADD     *ZEROS        Ttvdte
      *
     C                   ENDIF
      *
      ** Exchange rate
      *
     C                   IF        PCctRte <> *Blanks
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      PCctRte       Zfield
     C                   Z-ADD     8             Zadec
     C                   Z-ADD     5             Zadig
     C                   EXSR      SRFAFL
     C                   MOVE      Zfield        CctRte
      *
     C                   ELSE
      *
     C                   Z-ADD     *ZEROS        CctRte
      *
     C                   ENDIF
      *
      ** Sum of amounts
      *
     C                   IF        PSumcct <> *BLANKS AND
     C                             PCctCCy <> *BLANKS
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      PCctccy       @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format Sum of amount
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      PSumcct       Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 15 - A6NBDP
     C                   EXSR      SRFAFL
      *
     C                   MOVE      Zfield        Sumcct
     C                   ELSE
     C                   Z-ADD     *ZEROS        SumCct
     C                   ENDIF
      *
      ** Screen 2
      *
      ** Details of charges
      *
     C                   MOVE      PCctchg       Cctchg
      *
      ** Sum of Senders charges
      *
     C                   IF        PSumScg <> *BLANKS AND
     C                             PCctCCy <> *BLANKS
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      PcctCcy       @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format Sum of senders charges
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      PSumScg       Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
      *
     C                   MOVE      Zfield        SumScg
     C                   ELSE
     C                   MOVEL     *ZEROS        SumScg
     C                   ENDIF
      *
      ** Sum of Recievers charges
      *
     C                   IF        PSumRch <> *BLANKS AND
     C                             PCctCcy <> *BLANKS
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      PCctCCy       @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format Sum of Recievers charges
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      PSumRch       Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
      *
     C                   MOVE      Zfield        SumRch
     C                   ELSE
     C                   Z-ADD     *ZEROS        SumRch
     C                   ENDIF
      *
      ** Transaction type code
      *
     C                   MOVE      PTrnstp       Trnstp
      *
      ** Regulatory Reporting
      *
     C                   MOVE      PRegrp1       Regrp1
     C                   MOVE      PRegrp2       Regrp2
     C                   MOVE      PRegrp3       Regrp3
      *
      ** Bank Operation Code
      *
     C                   MOVE      PCctboc       Cctboc
      *
      ** Additional Information
      *
     C                   MOVE      PAdnlI1       AdnlI1
     C                   MOVE      PAdnlI2       AdnlI2
     C                   MOVE      PAdnlI3       AdnlI3
     C                   MOVE      PAdnlI4       AdnlI4
     C                   MOVE      PAdnlI5       AdnlI5
     C                   MOVE      PAdnlI6       AdnlI6
      *
      ** Types (hidden fields)
      *
      ** Sending institution type
      *
     C                   MOVE      PSinstt       Sinstt
      *
      ** Destination type
     C                   MOVE      PDsttyp       Dsttyp
      *
      ** Ordering customer type
     C                   MOVE      PCustth       Custth
      *
      ** Ordering institution type
     C                   MOVE      POrditp       Orditp
      *
      ** Senders correspondent type
     C                   MOVE      PSndtyp       Sndtyp
      *
      ** Recievers correspondent type
     C                   MOVE      PRcvtyp       Rcvtyp
      *
      ** User Data
      *
     C                   MOVEL     PINUSER       INUSER
      *                                                                         178384
     C********           MOVEL     PINDATE       INDATE                         178384
     C                   IF        PIndate <> *BLANKS                           178384
     C                   CALLB     'ZDATE1'                                     178384
     C                   PARM      PIndate       DateIn                         178384
     C                   PARM      *ZEROS        DaynoOut                       178384
     C                   PARM      BJDFIN        DatFmt                         178384
     C                   PARM      *BLANKS       ErrorFlag                      178384
      *                                                                         178384
     C                   Z-ADD     DaynoOut      Indate                         178384
     C                   ELSE                                                   178384
     C                   Z-ADD     *ZEROS        Indate                         178384
     C                   ENDIF                                                  178384
      *                                                                         178384
     C                   MOVEL     PINTIME       INTIME
     C                   MOVEL     PUPDUSR       UPDUSR
      *                                                                         178384
     C**********         MOVEL     PUPDDTE       UPDDTE                         178384
     C                   IF        PUpddte <> *BLANKS                           178384
     C                   CALLB     'ZDATE1'                                     178384
     C                   PARM      PUpddte       DateIn                         178384
     C                   PARM      *ZEROS        DaynoOut                       178384
     C                   PARM      BJDFIN        DatFmt                         178384
     C                   PARM      *BLANKS       ErrorFlag                      178384
      *                                                                         178384
     C                   Z-ADD     DaynoOut      Upddte                         178384
     C                   ELSE                                                   178384
     C                   Z-ADD     *ZEROS        Upddte                         178384
     C                   ENDIF                                                  178384
      *                                                                         178384
     C                   MOVEL     PUPDTIM       UPDTIM
     C                   MOVEL     PAUP1         AUP1
     C                   MOVEL     PAUP2         AUP2
     C                   MOVEL     PCDUAL        CDUAL
     C                   MOVEL     PAUIN         AUIN
     C                   MOVEL     PBAUTH        BAUTH
     C                   MOVEL     PBATUSR       BATUSR
      *
      * Sender Id
     C                   MOVEL     PSTID         STID
      *                                                                         185107
      ** Message Reference                                                      185107
      *                                                                         185107
     C                   Z-ADD     PCHMSGR       CHMSGR                         185107
      *
     C
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCctDt - Format Date for Display                             *
      *****************************************************************
      *
     C     SRCctDt       BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        ZDATFM            1
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCctAm - Format Amount For Display                           *
      *****************************************************************
      *
     C     SRCctAm       BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANKS       @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM      '.'           BNDCSP            1
     C                   PARM      *BLANKS       @@AMTD           14
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFAFL - Format Amount for File                               *
      *****************************************************************
      *
     C     SRFAFL        BEGSR
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    Zalignok
     C                   PARM                    Zfield
     C                   PARM                    Zadec
     C                   PARM                    Zadig
      *
      ** Database Error
      *
     C                   IF        Zalignok = 'N'
     C                   MOVEL     'ZALIGN  '    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     ZFIELD        DBKEY
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      ** APLYTRN - Apply translation
      *****************************************************************
      *
     C     APLYTRN       BEGSR
      *
     C                   CALLB     'ME1330'
     C                   PARM                    TRCODE
     C                   PARM                    Prefix
     C                   PARM                    AplyType
     C                   PARM                    SpecialC
     C                   PARM                    AplyValue
     C                   PARM                    RetCode
     C                   PARM                    TypeValue
      *
     C                   EVAL      Prefix = *Blank
     C                   EVAL      AplyType = *Blanks
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *                                                                                       221538
      ** Action Code                                                                          221538
      *                                                                                       221538
     C                   Parm                    Actn              1                          221538
      *
      ** Swift message selected
      *
     C                   PARM                    Pdata
      *                                                                                       CSW209
      ** Swift message selected (Extension)                                                   CSW209
      *                                                                                       CSW209
     C                   PARM                    Pdat2                                        CSW209
      *                                                                         185107
      ** Message reference                                                      185107
      *                                                                         185107
     C                   PARM                    MGMSGR                         185107
      *
      ** Type of Conversion
      *
     C                   PARM                    CnvTyp            2
      *
      ** CCt Header Details in file format
      *
     C                   PARM                    CCtHdr
      *
      ** OUTPUTS
      *
      ** CCt details in screen format
      *
     C                   PARM                    CctScnFmt
      *
      ** Initialize program name
      *
     C                   MOVEL     'FTM1021CT'   DBPGM
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*FIRST '     @Optn             7
     C     SDBANK        PARM      SDBANK        Dsfdy
      *
      ** Database Error
      *
     C                   IF        @Rtcd <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CSW207
      ** Check Swift 2007 is installed                                                        CSW207
                                                                                              CSW207
     C                   Call      'SWIF2007'                                                 CSW207
     C                   PARM                    RetCd                                        CSW207
                                                                                              CSW207
     C                   IF        RetCd = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW209
      ** Check Swift 2009 is installed                                                        CSW209
      *                                                                                       CSW209
     C                   Call      'SWIF2009'                                                 CSW209
     C                   PARM                    RetCd                                        CSW209
      *                                                                                       CSW209
     C                   IF        RetCd = 'CSW2009'                                          CSW209
     C                   EVAL      CSW209 = 'Y'                                               CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      CSW209 = 'N'                                               CSW209
     C                   ENDIF                                                                CSW209
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
