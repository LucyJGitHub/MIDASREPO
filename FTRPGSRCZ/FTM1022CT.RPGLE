     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT CCT credit convert - file to screen fmt')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1022CT - Customer Credit  Transfer Conversion:            *
      *              Database file to Screen Detail Format and        *
      *              in reverse                                       *
      *                                                               *
      *  Function:  This module converts the CCT credit details from  *
      *             the file format retrieved in FTM1022RV to the     *
      *             display format for FTM1021DP and vice versa.      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. AR928996A          Date 03May12               *
      *  Prev Amend No. AR928996           Date 27Mar12               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
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
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178751             Date 09May00               *
      *                 178384             Date 28apr00               *
      *                 CFT006  *Create    Date 09Nov99               *
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
      *  BUG24843 - 'GL Account not found' error displayed in         *
      *             Ordering Customer upon enquiry                    *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15151 - Unable to authorise CCTD                          *
      *  CSW207 - Swift 2007 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *           Recompile                                           *
      *  184060 - No transaction type code in detail screen           *
      *  178751 - Auto generation of references                       *
      *  178384 - GEMS error, date is displayed in Midas day number   *
      *           convert it to DD/MM/YY for display purposes         *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
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
      ** +--------------------------------------+
 
     D/COPY MECPYSRC,ME1100_ILE
      **
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Cct Details in File Format
     D CctDtl        E DS                  EXTNAME(FT102DPD)
 
      * CCt Details in Screen Format
     D CCtDtlScn     E DS                  EXTNAME(FT102DSPD)
 
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
      *                                                                                       CSW201
      ** Work array - Multiple lines of First Line of Pxx fields                              CSW201
     D                 DS                                                                     CSW201
     D  LFLT                   1    295    DIM(5)                                             CSW201
     D  BG1                    1     24                                                       CSW201
     D  TV1                   25     59                                                       CSW201
     D  BG2                   60     83                                                       CSW201
     D  TV2                   84    118                                                       CSW201
     D  BG3                  119    142                                                       CSW201
     D  TV3                  143    177                                                       CSW201
     D  BG4                  178    201                                                       CSW201
     D  TV4                  202    236                                                       CSW201
     D  BG5                  237    260                                                       CSW201
     D  TV5                  261    295                                                       CSW201
                                                                                              CSW201
     D WYA1            S              1    DIM(15)                                            CSW201
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
 
      ** Constant
     D NbType          C                   CONST(10)
 
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
      *                                                                                       CSW201
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
     D PRtCd           S              7A                                                      CSW201
     D L               S              2P 0                                                    CSW201
 
      ** Swift 2007                                                                           CSW207
     D CSW207          S              1                                                       CSW207
     D RetCd           S              7                                                       CSW207
 
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
     C                   IF        CnvTyp = 'SC'
     C                             OR CnvTyp = 'XD'                                         BUG15151
     C                   EVAL      CctDtlScn = *Blanks
     C                   ELSE
     C                   CLEAR                   Cctdtl
     C                   ENDIF
      *
      ** Set Output Screen Fields
      *
     C                   IF        CnvTyp = 'SC'
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
     C**********         IF        PDATA = *BLANKS                                            CSW209
     C                   IF        (PDATA = *BLANK AND                                        CSW209
     C                             PDAT2  = *BLANK)                                           CSW209
     C                   EXSR      Setfle
     C                   ELSE
     C                   EXSR      SwiftMe
     C                   ENDIF
     C                   ENDIF
      *
      *
      ** Return
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
      ** SETSCN - Set Output Screen Fields
      *****************************************************************
      *
     C     SetScn        BEGSR
      ** Customer Credit transfer ID
      *
     C                   MOVE      CctID         PCctid
      *                                                                         178751
      * Credit sequence number                                                  178751
      *                                                                         178751
     C                   MOVE      TSeqNo        PTSeqNo                        178751
      *
      ** File reference
      *
     C                   MOVE      @Filref       Pfilref
      *
      ** Transaction Type
      *
     C                   MOVE      @Ccttyp       PCcttyp
      *
      ** Transaction Reference
      *
     C                   MOVE      Trnsid        PTrnsid
      *
      ** Screen 1
      *
      *                                                                              184060
      ** Transaction Type Code                                                       184060
      *                                                                              184060
     C                   MOVEL     CCTTYC        PCctTyc                             184060
      *
      ** Beneficiary
      *
     C                   MOVEL     Benf1         PBenf1
     C                   MOVEL     Benf2         PBenf2
     C                   MOVEL     Benf3         PBenf3
     C                   MOVEL     Benf4         PBenf4
     C                   MOVEL     Benf5         PBenf5
      *                                                                                       221538
     C     Actn          IFEQ      'E'                                                        221538
      *                                                                                       221538
     C                   CLEAR                   P8FT                                         221538
     C                   MOVEL     *BLANKS       W8STMT                                       221538
     C                   MOVEL     PSPROCPGM     W8CPGM                                       221538
     C                   MOVEL     '*ENQ  '      W8ACT                                        221538
     C                   Z-ADD     5             W8NLIN                                       221538
      *                                                                                       221538
     C                   MOVEL     BENTTD        W8TYPE                                       221538
     C                   MOVEL     *BLANKS       P8LINS                                       221538
     C                   MOVEL     *BLANKS       WADDRSS                                      221538
     C                   MOVEL     *BLANKS       WLDGER                                       221538
     C     BENTTD        IFEQ      'G'                                                        221538
     C                   MOVEL     Benf1         WLDGER           18                          221538
     C                   MOVE      WLDGER        WACCNT           15                          221538
     C                   MOVEL     WLDGER        WBRCA             3                          221538
     C     WACCNT        CAT       WBRCA         WADCHK1                                      221538
     C                   ELSE                                                                 221538
     C                   MOVEL     Benf1         WADCHK1                                      221538
     C                   ENDIF                                                                221538
     C                   MOVEL     Benf2         WADCHK2                                      221538
     C                   MOVEL     Benf3         WADCHK3                                      221538
     C                   MOVEL     Benf4         WADCHK4                                      221538
     C                   MOVEL     Benf5         WADCHK5                                      221538
     C                   MOVEL     WADDRSS       P8LINS                                       221538
      *                                                                                       221538
     C                   EXSR      SREXPGM                                                    221538
      *                                                                                       221538
     C     35            SUBST     P8SCR:1       PBenf1                                       221538
     C     BENTTD        IFEQ      'G'                                                        221538
     C                   MOVEL     WLDGER        PBenf1                                       221538
     C                   ENDIF                                                                221538
     C     35            SUBST     P8SCR:36      PBenf2                                       221538
     C     35            SUBST     P8SCR:71      PBenf3                                       221538
     C     35            SUBST     P8SCR:106     PBenf4                                       221538
     C     35            SUBST     P8SCR:141     PBenf5                                       221538
      *                                                                                       221538
     C                   ENDIF                                                                221538
      *
      ** Account with Institution
      *
     C                   MOVEL     Acci35        Pacci35
     C                   MOVEL     Acci11        PAcci11
      *
      ** Ordering Institution
      *
     C                   MOVEL     Ordi35        POrdi35
     C                   MOVEL     Ordi11        POrdi11
      *
      ** Ordering Customer
      *
     C                   MOVEL     OrdCu1        POrdCu1
     C                   MOVEL     OrdCu2        POrdCu2
     C                   MOVEL     OrdCu3        POrdCu3
     C                   MOVEL     OrdCu4        POrdCu4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      POrdCu5 = OrdCu5                                           CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       221538
     C     Actn          IFEQ      'E'                                                        221538
      *                                                                                       221538
     C                   CLEAR                   P8FT                                         221538
     C                   MOVEL     *BLANKS       W8STMT                                       221538
     C                   MOVEL     PSPROCPGM     W8CPGM                                       221538
     C                   MOVEL     '*ENQ  '      W8ACT                                        221538
     C                   Z-ADD     5             W8NLIN                                       221538
      *                                                                                       221538
     C                   MOVEL     CUSTTD        W8TYPE                                       221538
     C                   MOVEL     *BLANKS       P8LINS                                       221538
     C                   MOVEL     *BLANKS       WADDRSS                                      221538
     C                   MOVEL     *BLANKS       WLDGER                                       221538
      *                                                                                     BUG24843
     C                   MOVEL     *BLANKS       CUST01           35                        BUG24843
     C                   MOVEL     OrdCu1        CUST01                                     BUG24843
     C                   IF        %SUBST(OrdCu1:1:1) = '/'                                 BUG24843
     C                   EVAL      OrdCu1 = %SUBST(OrdCu1:2:34)                             BUG24843
     C                   ENDIF                                                              BUG24843
      *                                                                                     BUG24843
     C     CUSTTD        IFEQ      'G'                                                        221538
     C                   MOVEL     OrdCu1        WLDGER           18                          221538
     C                   MOVE      WLDGER        WACCNT           15                          221538
     C                   MOVEL     WLDGER        WBRCA             3                          221538
     C     WACCNT        CAT       WBRCA         WADCHK1                                      221538
     C                   ELSE                                                                 221538
     C                   MOVEL     OrdCu1        WADCHK1                                      221538
     C                   ENDIF                                                                221538
     C                   MOVEL     CUST01        OrdCu1                                     BUG24843
     C                   MOVEL     OrdCu2        WADCHK2                                      221538
     C                   MOVEL     OrdCu3        WADCHK3                                      221538
     C                   MOVEL     OrdCu4        WADCHK4                                      221538
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      WADCHK5 = OrdCu5                                           CSW207
     C                   ELSE                                                                 CSW207
     C                   MOVEL     *BLANKS       WADCHK5                                      221538
     C                   ENDIF                                                                CSW207
     C                   MOVEL     WADDRSS       P8LINS                                       221538
      *                                                                                       221538
     C                   EXSR      SREXPGM                                                    221538
      *                                                                                       221538
     C     35            SUBST     P8SCR:1       POrdCu1                                      221538
     C     CUSTTD        IFEQ      'G'                                                        221538
     C                   MOVEL     WLDGER        POrdCu1                                      221538
     C                   ENDIF                                                                221538
     C     35            SUBST     P8SCR:36      POrdCu2                                      221538
     C     35            SUBST     P8SCR:71      POrdCu3                                      221538
     C     35            SUBST     P8SCR:106     POrdCu4                                      221538
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      POrdCu5 = %SUBST(P8SCR:141:35)                             CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       221538
     C                   ENDIF                                                                221538
      *
      ** Transfer amount and transfer CCy
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
     C                   Z-ADD     Cctamt        @@Amtw
     C                   Z-ADD     A6NBDP        @@Qecn
     C                   EXSR      SRCctam
     C                   MOVE      @@Amtd        PCctamt
     C                   ELSE
     C                   MOVEL     *BLANKS       PCctCcy
     C                   MOVEL     *BLANKS       PCctamt
     C                   ENDIF
      *
      ** Credit Date
      *
     C                   IF        Crdvdt <> *Zeros
     C                   Z-ADD     Crdvdt        ZDAYNO
     C                   EXSR      SRCctdt
     C                   MOVE      Zdate         PCrdvdt
     C                   ELSE
     C                   MOVEL     *BLANKS       PCrdvdt
     C                   ENDIF
      *
     C
      *
      ** Exchange rate
      *
     C                   IF        Xrate  <> *ZEROS
      *
     C                   MOVE      Xrate         ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      8             ZADEC             1 0
      *
     C                   MOVE      ZFIELD        PXrate
     C                   ENDIF
      *
      ** Exchange rate override
      *
     C                   MOVE      Xrateo        PXrateo
      *
      ** Payment amount and payment CCy
      *
     C                   IF        Payccy <> *BLANKS
     C                   MOVE      Payccy        PPayccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      Payccy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format transfer amount
      *
     C                   Z-ADD     Payamt        @@Amtw
     C                   Z-ADD     A6NBDP        @@Qecn
     C                   EXSR      SRCctam
     C                   MOVE      @@Amtd        PPayamt
     C                   ELSE
     C                   MOVEL     *BLANKS       PPayCcy
     C                   MOVEL     *BLANKS       PPayamt
     C                   ENDIF
      *
      ** Screen 2
      *
      ** Details of Charges
      *
     C                   MOVE      CcyChg        PCcyChg
      *
      ** Senders Charges and currency
      *
     C                   IF        Sndccy <> *BLANKS
     C                   MOVE      Sndccy        PSndCcy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      Sndccy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format senders charges
      *
     C                   Z-ADD     SndChg        @@Amtw
     C                   Z-ADD     A6NBDP        @@Qecn
     C                   EXSR      SRCctam
     C                   MOVE      @@Amtd        PSndChg
     C                   ELSE
     C                   MOVEL     *BLANKS       PSndCcy
     C                   MOVEL     *BLANKS       PSndChg
     C                   ENDIF
      *
      ** Senders charges in Transfer amount and transfer CCy
      *
     C                   IF        Cctccy <> *BLANKS
     C                   MOVE      Cctccy        PStrccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      Cctccy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format senders charges in transfer currency
      *
     C                   Z-ADD     SndCtf        @@Amtw
     C                   Z-ADD     A6NBDP        @@Qecn
     C                   EXSR      SRCctam
     C                   MOVE      @@Amtd        PSndctf
     C                   ELSE
     C                   MOVEL     *BLANKS       PStrCcy
     C                   MOVEL     *BLANKS       PSndCtf
     C                   ENDIF
      *
      ** Senders charges in Payment amount and payment CCy
      *
     C                   IF        Payccy <> *BLANKS
     C                   MOVE      Payccy        PSpyccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      Payccy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format senders charges in payment currency
      *
     C                   Z-ADD     Sndocg        @@Amtw
     C                   Z-ADD     A6NBDP        @@Qecn
     C                   EXSR      SRCctam
     C                   MOVE      @@Amtd        PSndocg
     C                   ELSE
     C                   MOVEL     *BLANKS       PSpyCcy
     C                   MOVEL     *BLANKS       PSndocg
     C                   ENDIF
      *                                                                                       CSW201
      ** Format additional sets of Sender's Charges & Currency                                CSW201
      ** when enhancement 'SWIFT 2001 standard update' is installed.                          CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
      *                                                                                       CSW201
      ** Senders charges 2                                                                    CSW201
     C                   IF        SDCCY2 <> *BLANKS                                          CSW201
     C                   MOVE      SDCCY2        PSNDCCY2                                     CSW201
                                                                                              CSW201
     C                   CALLB     'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
     C                   PARM      '*KEY   '     @Optn                                        CSW201
     C                   PARM      SDCCY2        @Ajcd                                        CSW201
     C     SDCURR        PARM      SDCURR        Dssdy                                        CSW201
                                                                                              CSW201
     C                   Z-ADD     SDCHG2        @@Amtw                                       CSW201
     C                   Z-ADD     A6NBDP        @@Qecn                                       CSW201
     C                   EXSR      SRCctam                                                    CSW201
     C                   MOVE      @@Amtd        PSNDCHG2                                     CSW201
     C                   ELSE                                                                 CSW201
     C                   MOVEL     *BLANKS       PSNDCCY2                                     CSW201
     C                   MOVEL     *BLANKS       PSNDCHG2                                     CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Senders charges 3                                                                    CSW201
     C                   IF        SDCCY3 <> *BLANKS                                          CSW201
     C                   MOVE      SDCCY3        PSNDCCY3                                     CSW201
                                                                                              CSW201
     C                   CALLB     'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
     C                   PARM      '*KEY   '     @Optn                                        CSW201
     C                   PARM      SDCCY3        @Ajcd                                        CSW201
     C     SDCURR        PARM      SDCURR        Dssdy                                        CSW201
                                                                                              CSW201
     C                   Z-ADD     SDCHG3        @@Amtw                                       CSW201
     C                   Z-ADD     A6NBDP        @@Qecn                                       CSW201
     C                   EXSR      SRCctam                                                    CSW201
     C                   MOVE      @@Amtd        PSNDCHG3                                     CSW201
     C                   ELSE                                                                 CSW201
     C                   MOVEL     *BLANKS       PSNDCCY3                                     CSW201
     C                   MOVEL     *BLANKS       PSNDCHG3                                     CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Senders charges 4                                                                    CSW201
     C                   IF        SDCCY4 <> *BLANKS                                          CSW201
     C                   MOVE      SDCCY4        PSNDCCY4                                     CSW201
                                                                                              CSW201
     C                   CALLB     'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
     C                   PARM      '*KEY   '     @Optn                                        CSW201
     C                   PARM      SDCCY4        @Ajcd                                        CSW201
     C     SDCURR        PARM      SDCURR        Dssdy                                        CSW201
                                                                                              CSW201
     C                   Z-ADD     SDCHG4        @@Amtw                                       CSW201
     C                   Z-ADD     A6NBDP        @@Qecn                                       CSW201
     C                   EXSR      SRCctam                                                    CSW201
     C                   MOVE      @@Amtd        PSNDCHG4                                     CSW201
     C                   ELSE                                                                 CSW201
     C                   MOVEL     *BLANKS       PSNDCCY4                                     CSW201
     C                   MOVEL     *BLANKS       PSNDCHG4                                     CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Senders charges 5                                                                    CSW201
     C                   IF        SDCCY5 <> *BLANKS                                          CSW201
     C                   MOVE      SDCCY5        PSNDCCY5                                     CSW201
                                                                                              CSW201
     C                   CALLB     'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
     C                   PARM      '*KEY   '     @Optn                                        CSW201
     C                   PARM      SDCCY5        @Ajcd                                        CSW201
     C     SDCURR        PARM      SDCURR        Dssdy                                        CSW201
                                                                                              CSW201
     C                   Z-ADD     SDCHG5        @@Amtw                                       CSW201
     C                   Z-ADD     A6NBDP        @@Qecn                                       CSW201
     C                   EXSR      SRCctam                                                    CSW201
     C                   MOVE      @@Amtd        PSNDCHG5                                     CSW201
     C                   ELSE                                                                 CSW201
     C                   MOVEL     *BLANKS       PSNDCCY5                                     CSW201
     C                   MOVEL     *BLANKS       PSNDCHG5                                     CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Senders charges in Transfer amount and transfer CCy                                  CSW201
     C                   IF        CCTCCY <> *BLANKS                                          CSW201
     C                   CALLB     'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
     C                   PARM      '*KEY   '     @Optn                                        CSW201
     C                   PARM      CCTCCY        @Ajcd                                        CSW201
     C     SDCURR        PARM      SDCURR        Dssdy                                        CSW201
      *                                                                                       CSW201
      ** Format senders charges in transfer currency                                          CSW201
     C                   Z-ADD     SDCTF2        @@Amtw                                       CSW201
     C                   Z-ADD     A6NBDP        @@Qecn                                       CSW201
     C                   EXSR      SRCctam                                                    CSW201
     C                   MOVE      @@Amtd        PSNDCTF2                                     CSW201
                                                                                              CSW201
     C                   Z-ADD     SDCTF3        @@Amtw                                       CSW201
     C                   Z-ADD     A6NBDP        @@Qecn                                       CSW201
     C                   EXSR      SRCctam                                                    CSW201
     C                   MOVE      @@Amtd        PSNDCTF3                                     CSW201
                                                                                              CSW201
     C                   Z-ADD     SDCTF4        @@Amtw                                       CSW201
     C                   Z-ADD     A6NBDP        @@Qecn                                       CSW201
     C                   EXSR      SRCctam                                                    CSW201
     C                   MOVE      @@Amtd        PSNDCTF4                                     CSW201
                                                                                              CSW201
     C                   Z-ADD     SDCTF5        @@Amtw                                       CSW201
     C                   Z-ADD     A6NBDP        @@Qecn                                       CSW201
     C                   EXSR      SRCctam                                                    CSW201
     C                   MOVE      @@Amtd        PSNDCTF5                                     CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Senders charges in Payment amount and payment CCy                                    CSW201
     C                   IF        PAYCCY <> *BLANKS                                          CSW201
     C                   CALLB     'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
     C                   PARM      '*KEY   '     @Optn                                        CSW201
     C                   PARM      PAYCCY        @Ajcd                                        CSW201
     C     SDCURR        PARM      SDCURR        Dssdy                                        CSW201
      *                                                                                       CSW201
      ** Format senders charges in payment currency                                           CSW201
     C                   Z-ADD     SDOCG2        @@Amtw                                       CSW201
     C                   Z-ADD     A6NBDP        @@Qecn                                       CSW201
     C                   EXSR      SRCctam                                                    CSW201
     C                   MOVE      @@Amtd        PSNDOCG2                                     CSW201
                                                                                              CSW201
     C                   Z-ADD     SDOCG3        @@Amtw                                       CSW201
     C                   Z-ADD     A6NBDP        @@Qecn                                       CSW201
     C                   EXSR      SRCctam                                                    CSW201
     C                   MOVE      @@Amtd        PSNDOCG3                                     CSW201
                                                                                              CSW201
     C                   Z-ADD     SDOCG4        @@Amtw                                       CSW201
     C                   Z-ADD     A6NBDP        @@Qecn                                       CSW201
     C                   EXSR      SRCctam                                                    CSW201
     C                   MOVE      @@Amtd        PSNDOCG4                                     CSW201
                                                                                              CSW201
     C                   Z-ADD     SDOCG5        @@Amtw                                       CSW201
     C                   Z-ADD     A6NBDP        @@Qecn                                       CSW201
     C                   EXSR      SRCctam                                                    CSW201
     C                   MOVE      @@Amtd        PSNDOCG5                                     CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
      *
      ** Recievers charges and currency
      *
     C                   IF        Rcvccy <> *BLANKS
     C                   MOVE      Rcvccy        PRcvCcy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      Rcvccy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format recievers charges
      *
     C                   Z-ADD     RcvChg        @@Amtw
     C                   Z-ADD     A6NBDP        @@Qecn
     C                   EXSR      SRCctam
     C                   MOVE      @@Amtd        PRcvChg
     C                   ELSE
     C                   MOVEL     *BLANKS       PRcvCcy
     C                   MOVEL     *BLANKS       PRcvCHG
     C                   ENDIF
      *
      ** Recievers charges in Transfer amount and transfer CCy
      *
     C                   IF        Cctccy <> *BLANKS
     C                   MOVE      Cctccy        PRtrccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      Cctccy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format recievers charges in transfer currency
      *
     C                   Z-ADD     Rcvctf        @@Amtw
     C                   Z-ADD     A6NBDP        @@Qecn
     C                   EXSR      SRCctam
     C                   MOVE      @@Amtd        PRcvctf
     C                   ELSE
     C                   MOVEL     *BLANKS       PRtrccy
     C                   MOVEL     *BLANKS       Prcvctf
     C                   ENDIF
      *
      ** Recievers charges in payment amount and payment CCy
      *
     C                   IF        Payccy <> *BLANKS
     C                   MOVE      Payccy        PRPyccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      Payccy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format recievers charges in payment currency
      *
     C                   Z-ADD     Rcvocg        @@Amtw
     C                   Z-ADD     A6NBDP        @@Qecn
     C                   EXSR      SRCctam
     C                   MOVE      @@Amtd        PRcvocg
     C                   ELSE
     C                   MOVEL     *BLANKS       PRpyccy
     C                   MOVEL     *BLANKS       PRcvocg
     C                   ENDIF
      *
      ** Generate Outgoing payment
      *
     C                   MOVE      Gopflg        PGopflg
      *
      ** Remittance Information
      *
     C                   MOVE      Remi1         PRemi1
     C                   MOVE      Remi2         PRemi2
     C                   MOVE      Remi3         PRemi3
     C                   MOVE      Remi4         PRemi4
      *
      ** Regulatory Reporting
      *
     C                   MOVE      Regrp1        PRegrp1
     C                   MOVE      Regrp2        PRegrp2
     C                   MOVE      Regrp3        PRegrp3
      *
      ** Types (hidden fields)
      *
      ** Ordering Customer type
      *
     C                   MOVE      Custtd        PCusttd
      *
      ** Ordering institution type
     C                   MOVE      Orditp        POrditp
      *
      ** Account with institution type
     C                   MOVE      Awitp         PAwitp
      *
      ** Beneficiary type
     C                   MOVE      Benttd        PBenttd
      *
      ** Further Transaction type
     C                   MOVE      Tftrnt        PTftrnt
      *
      ** Further Transaction Ref
     C                   MOVE      TftRef        PTftRef
      *
      ** User Data
      *
     C                   MOVEL     CQIN          PCQIN
     C                   MOVEL     CHQNUM        PCHQNUM
     C                   MOVEL     INUSER        PINUSER
     C********           MOVEL     INDATE        PINDATE                        178384
     C                   IF        Indate <> *Zeros                             178384
     C                   Z-ADD     Indate        ZDAYNO                         178384
     C                   EXSR      SRCctdt                                      178384
     C                   MOVE      Zdate         PIndate                        178384
     C                   ELSE                                                   178384
     C                   MOVEL     *BLANKS       PIndate                        178384
     C                   ENDIF                                                  178384
      *                                                                         178384
     C                   MOVEL     INTIME        PINTIME
     C                   MOVEL     UPDUSR        PUPDUSR
     C***********        MOVEL     UPDDTE        PUPDDTE                        178384
     C                   IF        UPddte <> *Zeros                             178384
     C                   Z-ADD     Upddte        ZDAYNO                         178384
     C                   EXSR      SRCctdt                                      178384
     C                   MOVE      Zdate         PUpddte                        178384
     C                   ELSE                                                   178384
     C                   MOVEL     *BLANKS       PUpddte                        178384
     C                   ENDIF                                                  178384
     C                   MOVEL     UPDTIM        PUPDTIM
     C                   Z-ADD     CCTMSQ        PCCTMSQ
     C                   Z-ADD     CCTMSG        PCCTMRF
     C                   MOVEL     AKEYCD        PAKEYCD
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLE - Set Output File Fields
      *****************************************************************
      *
     C     Setfle        BEGSR
      ** Customer Credit transfer ID
      *
     C                   MOVE      PCctID        Cctid
      *                                                                         178751
      * Credit sequence number                                                  178751
      *                                                                         178751
     C                   MOVE      PTSeqNo       TSeqNo                         178751
      *
      ** File reference
      *
     C                   MOVE      PFilref       @Filref
      *
      ** Transaction Type
      *
     C                   MOVE      PCcttyp       @Ccttyp
      *
      ** Transaction Reference
      *
     C                   MOVE      PTrnsid       Trnsid
      *
      ** Screen 1
      *
      *                                                                              184060
      ** Transaction Type Code                                                       184060
      *                                                                              184060
     C                   MOVEL     PCctTyc       CCTTYC                              184060
      *
      ** Beneficiary
      *
     C                   MOVEL     PBenf1        Benf1
     C                   MOVEL     PBenf2        Benf2
     C                   MOVEL     PBenf3        Benf3
     C                   MOVEL     PBenf4        Benf4
     C                   MOVEL     PBenf5        Benf5
      *
      ** Account with Institution
      *
     C                   MOVEL     PAcci35       Acci35
     C                   MOVEL     PAcci11       Acci11
      *
      ** Ordering Institution
      *
     C                   MOVEL     POrdi35       Ordi35
     C                   MOVEL     POrdi11       Ordi11
      *
      ** Ordering Customer
      *
     C                   MOVEL     POrdCu1       OrdCu1
     C                   MOVEL     POrdCu2       OrdCu2
     C                   MOVEL     POrdCu3       OrdCu3
     C                   MOVEL     POrdCu4       OrdCu4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      OrdCu5 = POrdCu5                                           CSW207
     C                   ENDIF                                                                CSW207
      *
      ** Transfer amount and transfer CCy
      *
     C                   IF        PCCtccy <> *BLANKS
     C                   MOVE      PCctccy       Cctccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      PCctccy       @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format transfer amount
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      PCCtamt       Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
     C                   MOVE      Zfield        Cctamt
     C                   ELSE
     C                   MOVE      *BLANKS       CctCcy
     C                   Z-ADD     *ZEROS        Cctamt
     C                   ENDIF
      *
      ** Credit Date
      *
     C                   IF        PCrdvdt <> *BLANKS
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      PCrdvdt       DateIn
     C                   PARM      *ZEROS        DaynoOut
     C                   PARM      BJDFIN        DatFmt
     C                   PARM      *BLANKS       ErrorFlag
      *
     C                   Z-ADD     DaynoOut      Crdvdt
     C                   ELSE
     C                   Z-ADD     *ZEROS        Crdvdt
     C                   ENDIF
      *
     C
      *
      ** Exchange rate
      *
     C                   IF        PXrate  <> *ZEROS
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      PXRate        Zfield
     C                   Z-ADD     8             Zadec
     C                   Z-ADD     5             Zadig
     C                   EXSR      SRFAFL
     C                   MOVE      Zfield        XRate
     C                   ELSE
     C                   Z-ADD     *ZEROS        XRate
     C                   ENDIF
      *
      ** Exchange rate override
      *
     C                   MOVE      PXrateo       Xrateo
      *
      ** Payment amount and payment CCy
      *
     C                   IF        PPayccy <> *BLANKS
     C                   MOVE      PPayccy       Payccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      PPayccy       @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format transfer amount
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      PPayamt       Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 15 - A6NBDP
     C                   EXSR      SRFAFL
     C                   MOVE      Zfield        Payamt
     C                   ELSE
     C                   MOVEL     *BLANKS       PayCcy
     C                   Z-ADD     *ZEROS        Payamt
     C                   ENDIF
      *
      ** Screen 2
      *
      ** Details of Charges
      *
     C                   MOVE      PCcyChg       CcyChg
      *
      ** Senders Charges and currency
      *
     C                   IF        PSndccy <> *BLANKS
     C                   MOVE      PSndccy       SndCcy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      PSndccy       @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format senders charges
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      PSndChg       Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
      *
     C                   MOVE      Zfield        SndChg
     C                   ELSE
     C                   MOVEL     *BLANKS       SndCcy
     C                   Z-ADD     *ZEROS        SndChg
     C                   ENDIF
      *                                                                                       CSW201
      ** If enhancement 'SWIFT 2001 standard update' is installed,                            CSW201
      ** set senders charges screen fields to file fields.                                    CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
      *                                                                                       CSW201
      ** Format senders charges 2                                                             CSW201
     C                   IF        PSNDCCY2 <> *BLANKS                                        CSW201
     C                   MOVE      PSNDCCY2      SDCCY2                                       CSW201
      *                                                                                       CSW201
     C                   CALLB     'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
     C                   PARM      '*KEY   '     @Optn                                        CSW201
     C                   PARM      PSNDCCY2      @Ajcd                                        CSW201
     C     SDCURR        PARM      SDCURR        Dssdy                                        CSW201
      *                                                                                       CSW201
     C                   MOVE      *BLANKS       Zfield                                       CSW201
     C                   MOVE      PSNDCHG2      Zfield                                       CSW201
     C                   EVAL      Zadec = A6NBDP                                             CSW201
     C                   EVAL      Zadig = 13 - A6NBDP                                        CSW201
     C                   EXSR      SRFAFL                                                     CSW201
      *                                                                                       CSW201
     C                   MOVE      Zfield        SDCHG2                                       CSW201
     C                   ELSE                                                                 CSW201
     C                   MOVEL     *BLANKS       SDCCY2                                       CSW201
     C                   Z-ADD     *ZEROS        SDCHG2                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Format senders charges 3                                                             CSW201
     C                   IF        PSNDCCY3 <> *BLANKS                                        CSW201
     C                   MOVE      PSNDCCY3      SDCCY3                                       CSW201
      *                                                                                       CSW201
     C                   CALLB     'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
     C                   PARM      '*KEY   '     @Optn                                        CSW201
     C                   PARM      PSNDCCY3      @Ajcd                                        CSW201
     C     SDCURR        PARM      SDCURR        Dssdy                                        CSW201
      *                                                                                       CSW201
     C                   MOVE      *BLANKS       Zfield                                       CSW201
     C                   MOVE      PSNDCHG3      Zfield                                       CSW201
     C                   EVAL      Zadec = A6NBDP                                             CSW201
     C                   EVAL      Zadig = 13 - A6NBDP                                        CSW201
     C                   EXSR      SRFAFL                                                     CSW201
      *                                                                                       CSW201
     C                   MOVE      Zfield        SDCHG3                                       CSW201
     C                   ELSE                                                                 CSW201
     C                   MOVEL     *BLANKS       SDCCY3                                       CSW201
     C                   Z-ADD     *ZEROS        SDCHG3                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Format senders charges 4                                                             CSW201
     C                   IF        PSNDCCY4 <> *BLANKS                                        CSW201
     C                   MOVE      PSNDCCY4      SDCCY4                                       CSW201
      *                                                                                       CSW201
     C                   CALLB     'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
     C                   PARM      '*KEY   '     @Optn                                        CSW201
     C                   PARM      PSNDCCY4      @Ajcd                                        CSW201
     C     SDCURR        PARM      SDCURR        Dssdy                                        CSW201
      *                                                                                       CSW201
     C                   MOVE      *BLANKS       Zfield                                       CSW201
     C                   MOVE      PSNDCHG4      Zfield                                       CSW201
     C                   EVAL      Zadec = A6NBDP                                             CSW201
     C                   EVAL      Zadig = 13 - A6NBDP                                        CSW201
     C                   EXSR      SRFAFL                                                     CSW201
      *                                                                                       CSW201
     C                   MOVE      Zfield        SDCHG4                                       CSW201
     C                   ELSE                                                                 CSW201
     C                   MOVEL     *BLANKS       SDCCY4                                       CSW201
     C                   Z-ADD     *ZEROS        SDCHG4                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Format senders charges 5                                                             CSW201
     C                   IF        PSNDCCY5 <> *BLANKS                                        CSW201
     C                   MOVE      PSNDCCY5      SDCCY5                                       CSW201
      *                                                                                       CSW201
     C                   CALLB     'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
     C                   PARM      '*KEY   '     @Optn                                        CSW201
     C                   PARM      PSNDCCY5      @Ajcd                                        CSW201
     C     SDCURR        PARM      SDCURR        Dssdy                                        CSW201
      *                                                                                       CSW201
     C                   MOVE      *BLANKS       Zfield                                       CSW201
     C                   MOVE      PSNDCHG5      Zfield                                       CSW201
     C                   EVAL      Zadec = A6NBDP                                             CSW201
     C                   EVAL      Zadig = 13 - A6NBDP                                        CSW201
     C                   EXSR      SRFAFL                                                     CSW201
      *                                                                                       CSW201
     C                   MOVE      Zfield        SDCHG5                                       CSW201
     C                   ELSE                                                                 CSW201
     C                   MOVEL     *BLANKS       SDCCY5                                       CSW201
     C                   Z-ADD     *ZEROS        SDCHG5                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ELSE                                                                 CSW201
     C                   MOVEL     *BLANKS       SDCCY2                                       CSW201
     C                   Z-ADD     *ZEROS        SDCHG2                                       CSW201
     C                   MOVEL     *BLANKS       SDCCY3                                       CSW201
     C                   Z-ADD     *ZEROS        SDCHG3                                       CSW201
     C                   MOVEL     *BLANKS       SDCCY4                                       CSW201
     C                   Z-ADD     *ZEROS        SDCHG4                                       CSW201
     C                   MOVEL     *BLANKS       SDCCY5                                       CSW201
     C                   Z-ADD     *ZEROS        SDCHG5                                       CSW201
     C                   ENDIF                                                                CSW201
      *
      ** Senders charges in Transfer amount and transfer CCy
      *
     C                   IF        PStrccy <> *BLANKS
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      PStrccy       @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format senders charges in transfer currency
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      PSndctf       Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
      *
     C                   MOVE      Zfield        Sndctf
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   MOVE      *BLANKS       Zfield                                       CSW201
     C                   MOVE      PSNDCTF2      Zfield                                       CSW201
     C                   EXSR      SRFAFL                                                     CSW201
     C                   MOVE      Zfield        SDCTF2                                       CSW201
      *                                                                                       CSW201
     C                   MOVE      *BLANKS       Zfield                                       CSW201
     C                   MOVE      PSNDCTF3      Zfield                                       CSW201
     C                   EXSR      SRFAFL                                                     CSW201
     C                   MOVE      Zfield        SDCTF3                                       CSW201
      *                                                                                       CSW201
     C                   MOVE      *BLANKS       Zfield                                       CSW201
     C                   MOVE      PSNDCTF4      Zfield                                       CSW201
     C                   EXSR      SRFAFL                                                     CSW201
     C                   MOVE      Zfield        SDCTF4                                       CSW201
      *                                                                                       CSW201
     C                   MOVE      *BLANKS       Zfield                                       CSW201
     C                   MOVE      PSNDCTF5      Zfield                                       CSW201
     C                   EXSR      SRFAFL                                                     CSW201
     C                   MOVE      Zfield        SDCTF5                                       CSW201
     C                   ELSE                                                                 CSW201
      *                                                                                       CSW201
     C                   Z-ADD     *ZEROS        SDCTF2                                       CSW201
     C                   Z-ADD     *ZEROS        SDCTF3                                       CSW201
     C                   Z-ADD     *ZEROS        SDCTF4                                       CSW201
     C                   Z-ADD     *ZEROS        SDCTF5                                       CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ELSE
     C                   Z-ADD     *ZEROS        SndCtf
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   Z-ADD     *ZEROS        SDCTF2                                       CSW201
     C                   Z-ADD     *ZEROS        SDCTF3                                       CSW201
     C                   Z-ADD     *ZEROS        SDCTF4                                       CSW201
     C                   Z-ADD     *ZEROS        SDCTF5                                       CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF
      *
      ** Senders charges in Payment amount and payment CCy
      *
     C                   IF        PSpyccy <> *BLANKS
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      PSpyccy       @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format senders charges in payment currency
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      PSndocg       Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
     C                   MOVE      Zfield        Sndocg
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   MOVE      *BLANKS       Zfield                                       CSW201
     C                   MOVE      PSNDOCG2      Zfield                                       CSW201
     C                   EXSR      SRFAFL                                                     CSW201
     C                   MOVE      Zfield        SDOCG2                                       CSW201
      *                                                                                       CSW201
     C                   MOVE      *BLANKS       Zfield                                       CSW201
     C                   MOVE      PSNDOCG3      Zfield                                       CSW201
     C                   EXSR      SRFAFL                                                     CSW201
     C                   MOVE      Zfield        SDOCG3                                       CSW201
      *                                                                                       CSW201
     C                   MOVE      *BLANKS       Zfield                                       CSW201
     C                   MOVE      PSNDOCG4      Zfield                                       CSW201
     C                   EXSR      SRFAFL                                                     CSW201
     C                   MOVE      Zfield        SDOCG4                                       CSW201
      *                                                                                       CSW201
     C                   MOVE      *BLANKS       Zfield                                       CSW201
     C                   MOVE      PSNDOCG5      Zfield                                       CSW201
     C                   EXSR      SRFAFL                                                     CSW201
     C                   MOVE      Zfield        SDOCG5                                       CSW201
     C                   ELSE                                                                 CSW201
      *                                                                                       CSW201
     C                   Z-ADD     *ZEROS        SDOCG2                                       CSW201
     C                   Z-ADD     *ZEROS        SDOCG3                                       CSW201
     C                   Z-ADD     *ZEROS        SDOCG4                                       CSW201
     C                   Z-ADD     *ZEROS        SDOCG5                                       CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ELSE
     C                   Z-ADD     *ZEROS        Sndocg
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   Z-ADD     *ZEROS        SDOCG2                                       CSW201
     C                   Z-ADD     *ZEROS        SDOCG3                                       CSW201
     C                   Z-ADD     *ZEROS        SDOCG4                                       CSW201
     C                   Z-ADD     *ZEROS        SDOCG5                                       CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF
      *
      ** Recievers charges and currency
      *
     C                   IF        PRcvccy <> *BLANKS
     C                   MOVE      PRCvccy       RCvccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      PRcvccy       @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format recievers charges
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      PRcvChg       Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
     C                   MOVE      Zfield        RcvChg
     C                   ELSE
     C                   MOVEL     *BLANKS       Rcvccy
     C                   Z-ADD     *ZEROS        RcvCHG
     C                   ENDIF
      *
      ** Recievers charges in Transfer amount and transfer CCy
      *
     C                   IF        PRtrccy <> *BLANKS
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      PRtrccy       @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format recievers charges in transfer currency
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      PRcvctf       Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
     C                   MOVE      Zfield        Rcvctf
     C                   ELSE
     C                   Z-ADD     *ZEROS        Rcvctf
     C                   ENDIF
      *
      ** Recievers charges in payment amount and payment CCy
      *
     C                   IF        PRpyccy <> *BLANKS
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      PRpyccy       @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format recievers charges in payment currency
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      PRcvocg       Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
     C                   MOVE      Zfield        Rcvocg
     C                   ELSE
     C                   Z-ADD     *ZEROS        Rcvocg
     C                   ENDIF
      *
      ** Generate Outgoing payment
      *
     C                   MOVE      PGopflg       Gopflg
      *
      ** Remittance Information
      *
     C                   MOVE      PRemi1        Remi1
     C                   MOVE      PRemi2        Remi2
     C                   MOVE      PRemi3        Remi3
     C                   MOVE      PRemi4        Remi4
      *
      ** Regulatory Reporting
      *
     C                   MOVE      PRegrp1       Regrp1
     C                   MOVE      PRegrp2       Regrp2
     C                   MOVE      PRegrp3       Regrp3
      *
      ** Types (hidden fields)
      *
      ** Ordering Customer type
      *
     C                   MOVE      PCusttd       Custtd
      *
      ** Ordering institution type
     C                   MOVE      POrditp       Orditp
      *
      ** Account with institution type
     C                   MOVE      PAwitp        Awitp
      *
      ** Beneficiary type
     C                   MOVE      PBenttd       Benttd
      *
      ** Further Transaction type
     C                   MOVE      PTftrnt       Tftrnt
      *
      ** Further Transaction Ref
     C                   MOVE      PTftRef       TftRef
      *
      ** User Data
      *
     C                   MOVEL     PCQIN         CQIN
     C                   MOVEL     PCHQNUM       CHQNUM
     C                   MOVEL     PINUSER       INUSER
     C********           MOVEL     PINDATE       INDATE                         178384
     C                   IF        PIndate <> *BLANKS                           178384
      *                                                                         178384
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
                                                                                178384
     C                   MOVEL     PINTIME       INTIME
     C                   MOVEL     PUPDUSR       UPDUSR
     C******:            MOVEL     PUPDDTE       UPDDTE                         178384
     C                   IF        Pupddte <> *BLANKS                           178384
      *                                                                         178384
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
                                                                                178384
     C                   MOVEL     PUPDTIM       UPDTIM
     C                   Z-ADD     PCCTMSQ       CCTMSQ
     C                   Z-ADD     PCCTMRF       CCTMSG
     C                   MOVEL     PAKEYCD       AKEYCD
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SwiftMe - Map Swift Messages
      *****************************************************************
      *
     C     SwiftMe       BEGSR
      *
      ** DO NOT MAP PAYMENT AMOUNT AND CURRENCY FROM SWIFT TAGS 33B
      ** (tag 33b is original ordered amount, there is no tag as yet
      ** for payment amount for BI's)
      ** DO NOT MAP EXHANGE RATE FROM SWIFT TAG 36
      ** (tag 36 is for the exchange rate between original ordered
      ** amount-pay amount in file in 'BO'- and transfer amount)
      *
      ** Initialise fields
      *
     C                   EVAL      AplyType = *Blanks
      *
      ** Screen 1
      *
      *
      ** Related/Transaction reference
      *
     C                   IF        P21 <> *BLANKS
     C                   RESET                   DsTran
     C                   MOVEL     P21           Dstran
     C                   EVAL      Trnsid = Ttref
     C                   ENDIF
      *
      ** Transaction/transfer amount and ccy
      *
     C                   IF        P32B <> *BLANKS
     C                   RESET                   DSTRAN
     C                   MOVEL     P32B          Dstran
     C                   IF        TTccy <> *BLANKS
     C                   EVAL      CCtCcy = TTCcy
     C                   Eval      Comma = %scan(',':TTAMT)
     C                   If        Comma <> 0
     C                   Eval       %subst(TTAMT:Comma:1) = '.'
     C                   Endif
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      CctCcy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format transfer amount
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      TTAmt         Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
      *
     C                   MOVE      Zfield        Cctamt
     C                   ENDIF
     C                   ENDIF
      *
      ** Ordering Customer
      *
     C                   IF        P50 <> *BLANKS
     C                   RESET                   DsTran
     C                   MOVEL     P50           Dstran
     C                   IF        Trcode = *BLANKS
     C                   EVAL      OrdCu1 = TmLin1
     C                   EVAL      OrdCu2 = TmLin2
     C                   EVAL      OrdCu3 = TmLin3
     C                   EVAL      OrdCu4 = TmLin4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      OrdCu5 = TmLin5                                            CSW207
     C                   ENDIF                                                                CSW207
     C                   ELSE
     C                   EVAL      AplyType(1) = 'F'
     C                   EVAL      AplyType(2) = 'R'
     C                   EVAL      AplyType(3) = 'G'
     C                   EXSR      APLYTRN
     C                   EVAL      OrdCu1 = AplyValue
     C                   ENDIF
     C                   ENDIF
      *
      ** Ordering Institution
      *
     C                   IF        P52 <> *BLANKS
     C                   RESET                   DsTran
     C                   MOVEL     P52           Dstran
     C                   IF        TRCODE = *Blanks
     C                   EVAL      OrdI35 = TmLin1
     C                   ELSE
     C                   EVAL      AplyType(1) = 'F'
     C                   EVAL      AplyType(2) = 'R'
     C                   EVAL      AplyType(3) = 'G'
     C                   EXSR      APLYTRN
     C                   EVAL      OrdI35 = AplyValue
     C                   ENDIF
     C                   ENDIF
      *
      ** Account with Institution
      *
     C                   IF        P57 <> *BLANKS
     C                   RESET                   Dstran
     C                   MOVEL     P57           Dstran
     C                   IF        Trcode = *BLANKS
     C                   EVAL      Acci35 = TmLin1
     C                   EVAL      Acci11 = TmLin2
     C                   ELSE
     C                   EVAL      AplyType(1) = 'F'
     C                   EVAL      AplyType(2) = 'R'
     C                   EVAL      AplyType(3) = 'G'
     C                   EXSR      APLYTRN
     C                   EVAL      Acci35 = AplyValue
     C                   ENDIF
     C                   ENDIF
      *
      ** Beneficiary Customer
      *
     C                   IF        P59 <> *BLANKS
     C                   RESET                   Dstran
     C                   MOVEL     P59           Dstran
     C                   IF        Trcode = *BLANKS
     C                   EVAL      Benf1 = Tmlin1
     C                   EVAL      Benf2 = Tmlin2
     C                   EVAL      Benf3 = Tmlin3
     C                   EVAL      Benf4 = Tmlin4
     C                   EVAL      Benf5 = Tmlin5
     C                   ELSE
     C                   EVAL      AplyType(1) = 'F'
     C                   EVAL      AplyType(2) = 'R'
     C                   EVAL      AplyType(3) = 'G'
     C                   EXSR      APLYTRN
     C                   EVAL      Benf1 = AplyValue
     C                   ENDIF
     C                   ENDIF
      *
      ** Details of Charges
      *
     C                   IF        P71 <> *BLANKS
     C                   RESET                   Dstran
     C                   MOVEL     P71           Dstran
     C                   EVAL      CcyChg = Ttref
     C                   ENDIF
      *
      ** Screen 2
     C                   IF        CSW201 <> 'Y'                                              CSW201
      *
      ** Senders Charges amount and ccy
      *
     C                   IF        P71F <> *BLANKS
     C                   RESET                   DsTran
     C                   MOVEL     P71F          Dstran
     C                   IF        TTccy <> *BLANKS
     C                   EVAL      SndCcy = TTCcy
      *
     C                   Eval      Comma = %scan(',':TTAMT)
     C                   If        Comma <> 0
     C                   Eval       %subst(TTAMT:Comma:1) = '.'
     C                   Endif
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      SndCcy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format Sender's charges amount
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      TTAmt         Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
      *
     C                   MOVE      Zfield        SndChg
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
      ** Sender's Charge fields                                                               CSW201
                                                                                              CSW201
     C     P71FX         IFNE      *BLANKS                                                    CSW201
                                                                                              CSW201
     C                   MOVEL     *BLANK        DSTRAN                                       CSW201
     C                   MOVEL     P71FX         DSTRAN                                       CSW201
     C                   Z-ADD     1             L                                            CSW201
     C                   MOVEL     TMLIN1        TV1                                          CSW201
     C                   MOVEL     TMLIN2        TV2                                          CSW201
     C                   MOVEL     TMLIN3        TV3                                          CSW201
     C                   MOVEL     TMLIN4        TV4                                          CSW201
     C                   MOVEL     TMLIN5        TV5                                          CSW201
                                                                                              CSW201
     C     L             DOWLE     5                                                          CSW201
     C     LFLT(L)       ANDNE     *BLANK                                                     CSW201
                                                                                              CSW201
     C                   MOVEL     *BLANK        DSTRAN                                       CSW201
     C                   MOVEL     LFLT(L)       DSTRAN                                       CSW201
     C                   EXSR      SRCYAM33B                                                  CSW201
                                                                                              CSW201
     C                   CALLB     'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd             7                          CSW201
     C                   PARM      '*KEY   '     @Optn             7                          CSW201
     C                   PARM      WCACY         @Ajcd             3                          CSW201
     C     SDCURR        PARM      SDCURR        Dssdy                                        CSW201
      *                                                                                       CSW201
      ** Format Sender's charges amount                                                       CSW201
      *                                                                                       CSW201
     C                   MOVE      *BLANKS       Zfield                                       CSW201
     C                   MOVE      WCAAM         Zfield                                       CSW201
     C                   EVAL      Zadec = A6NBDP                                             CSW201
     C                   EVAL      Zadig = 13 - A6NBDP                                        CSW201
     C                   EXSR      SRFAFL                                                     CSW201
                                                                                              CSW201
     C                   SELECT                                                               CSW201
     C                   WHEN      (L = 1)                                                    CSW201
     C                   MOVE      Zfield        SndChg                                       CSW201
     C                   MOVEL     WCACY         SNDCCY                                       CSW201
     C                   WHEN      (L = 2)                                                    CSW201
     C                   MOVE      Zfield        SDCHG2                                       CSW201
     C                   MOVEL     WCACY         SDCCY2                                       CSW201
     C                   WHEN      (L = 3)                                                    CSW201
     C                   MOVE      ZField        SDCHG3                                       CSW201
     C                   MOVEL     WCACY         SDCCY3                                       CSW201
     C                   WHEN      (L = 4)                                                    CSW201
     C                   MOVE      ZField        SDCHG4                                       CSW201
     C                   MOVEL     WCACY         SDCCY4                                       CSW201
     C                   WHEN      (L = 5)                                                    CSW201
     C                   MOVE      Zfield        SDCHG5                                       CSW201
     C                   MOVEL     WCACY         SDCHG5                                       CSW201
     C                   ENDSL                                                                CSW201
                                                                                              CSW201
     C                   ADD       1             L                                            CSW201
                                                                                              CSW201
     C                   ENDDO                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *
      ** Receivers Charges amount and ccy
      *
     C                   IF        P71G <> *BLANKS
     C                   RESET                   DsTran
     C                   MOVEL     P71G          Dstran
     C                   IF        TTccy <> *BLANKS
     C                   EVAL      RcvCcy = TTCcy
      *
     C                   Eval      Comma = %scan(',':TTAMT)
     C                   If        Comma <> 0
     C                   Eval       %subst(TTAMT:Comma:1) = '.'
     C                   Endif
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      RcvCcy        @Ajcd             3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
      ** Format receiver's charges
      *
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      TTAmt         Zfield
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13 - A6NBDP
     C                   EXSR      SRFAFL
      *
     C                   MOVE      Zfield        RcvChg
     C                   ENDIF
     C                   ENDIF
      *
      ** Remittance Information
      *
     C                   IF        P70 <> *BLANKS
     C                   RESET                   DsTran
     C                   MOVEL     P70           Dstran
     C                   EVAL      RemI1 = TmLin1
     C                   EVAL      RemI2 = TmLin2
     C                   EVAL      RemI3 = TmLin3
     C                   EVAL      RemI4 = TmLin4
     C                   ENDIF
      *
      ** Transaction Type Code
      *
     C                   IF        P26T <> *BLANKS
     C                   RESET                   Dstran
     C                   MOVEL     P26T          Dstran
     C                   EVAL      CctTyC = Tmlin1
     C                   ENDIF
      *
      ** Regulatory Reporting
      *
     C                   IF        P77B <> *BLANKS
     C                   RESET                   DsTran
     C                   MOVEL     P77B          Dstran
     C                   EVAL      RegRp1 = TmLin1
     C                   EVAL      RegRp2 = TmLin2
     C                   EVAL      RegRp3 = TmLin3
     C                   ENDIF
      *
      ** Message Part
      *
     C                   Z-ADD     PHPART        CCTMSQ
      *
      ** Message Reference
      *
     C                   Z-ADD     PHMSGR        CCTMSG
 
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCctDT - Format Date for Display                            *
      *****************************************************************
      *
     C     SRCctdt       BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        ZDATFM            1
     C                   PARM      *Zeros        ZDATE             6 0
     C                   PARM      *Blanks       ZADATE            7
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCCTAM - Format Amount for Display                            *
      *****************************************************************
      *
     C     SRCctam       BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *Blank        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM      '.'           BNDCSP            1
     C                   PARM      *Blank        @@AMTD           14
      *
      ** Database Error
      *
     C                   IF        @@RETC <> *Blanks
     C                   MOVEL     'ZA0920  '    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     @@AMTW        DBKEY
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   EXSR      *PSSR
     C                   ENDIF
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
     C                   Z-ADD     3             DBASE
     C                   MOVEL     ZFIELD        DBKEY
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
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
      /EJECT                                                                                  CSW201
      *****************************************************************                       CSW201
      *                                                               *                       CSW201
      *  SRCYAM33B - Retrieve the amount/currency from tag 33B.       *                       CSW201
      *           or a valid SWIFT Reference                          *                       CSW201
      *                                                               *                       CSW201
      *****************************************************************                       CSW201
      *                                                                                       CSW201
     C     SRCYAM33B     BEGSR                                                                CSW201
                                                                                              CSW201
      ** Inputs                                                                               CSW201
      ** ------                                                                               CSW201
      ** DS for tags  (will NOT be blanked at the end of the S/R)                             CSW201
      **                                  DSTRAN                                              CSW201
      ** Outputs                                                                              CSW201
      ** -------                                                                              CSW201
      ** Currency                                                                             CSW201
     C     *LIKE         DEFINE    PSNDCCY       WCACY                                        CSW201
      ** Amount                                                                               CSW201
     C     *LIKE         DEFINE    PSNDCHG       WCAAM                                        CSW201
                                                                                              CSW201
     C                   MOVEL     *Blank        WCACY                                        CSW201
     C                   MOVEL     *Blank        WCAAM                                        CSW201
                                                                                              CSW201
      ** Currency                                                                             CSW201
                                                                                              CSW201
     C                   MOVEL     TTCCY         WCACY                                        CSW201
                                                                                              CSW201
      ** Amount                                                                               CSW201
      * Format amount field (change ',' decimal point to '.').                                CSW201
                                                                                              CSW201
     C                   MOVE      *BLANKS       WYA1                                         CSW201
     C                   MOVEA     TTAMT         WYA1                                         CSW201
     C                   Z-ADD     1             CX                3 0                        CSW201
                                                                                              CSW201
     C     CX            DOUGT     15                                                         CSW201
                                                                                              CSW201
     C     WYA1(CX)      IFEQ      ','                                                        CSW201
     C                   MOVE      '.'           WYA1(CX)                                     CSW201
     C                   Z-ADD     16            Cx                                           CSW201
     C                   ELSE                                                                 CSW201
     C                   ADD       1             Cx                                           CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDDO                                                                CSW201
                                                                                              CSW201
     C                   MOVEA     WYA1          WAMT             15                          CSW201
     C                   MOVEL     WAMT          WCAAM                                        CSW201
                                                                                              CSW201
     C                   ENDSR                                                                CSW201
      *                                                                                       CSW201
      *****************************************************************                       CSW201
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *                                                                                       221538
      ** Action Code                                                                          221538
      *                                                                                       221538
     C                   Parm                    Actn              1                          221538
      *
      ** Swift message selected
      *
     C                   PARM                    PHEAD
     C                   PARM                    PDATA
     C                   PARM                    PDAT2                                        CSW209
      *
      * Type of Conversion
      *
     C                   PARM                    CnvTyp            2
      *
      * CCt Header Detail
     C                   PARM                    @CCttyp           2
     C                   PARM                    @FilRef          16
      *
      * CCt Details in file format
     C                   PARM                    CctDtl
      *
      * Output parameters
      *
      * RFT header details in screen format
     C                   PARM                    CctDtlScn
      *
      ** Initialise program name
      *
     C                   MOVEL     'FTM1022CT'   DBPGM
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       PRtCd                                        CSW201
      *                                                                                       CSW201
     C                   IF        PRtCd = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
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
