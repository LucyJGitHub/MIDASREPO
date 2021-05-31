     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deals DL database update')                    *
      *****************************************************************
      *                                                               *
      *  Midas - FX Dealer Module                                     *
      *                                                               *
      *  FXFXDLUPD - FX DEALS DL DATABASE UPDATE                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. 251029             Date 22May20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 247151A            Date 29Jun17               *
      *                 MD030956           Date 09Oct14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD025244           Date 09May14               *
      *                 AR990243           Date 14Jun12               *
      *                 CSW212             Date 03May12               *
      *                 AR787620           Date 10Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260363             Date 25May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255340             Date 29Jul08               *
      *                 247104             Date 20Jun07               *
      *                 246801             Date 14May07               *
      *                 246387             Date 21Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243830             Date 17Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242477             Date 27Sep06               *
      *                 240603             Date 04Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 240480             Date 30Jun06               *
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG6479            Date 20Apr05               *
      *                 BUG6191            Date 09Mar05               *
      *                 220783             Date 14Sep03               *
      *                 LSC025             Date 25Jun04               *
      *                 CTI004             Date 12Apr04               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209895             Date 14Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      *                 207072             Date 17Jul02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 155792             Date 03Oct00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 11Nov99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  251029 - Applied fix 231306.                                 *
      *  231306 - Handle file locking properly.                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date                                    *
      *  247151A- Initialise flag introduced for RecSd and PaySd      *
      *         - Applied for MD045858                                *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *  MD025244 - Added parameter in calling ZADLTRLRUD.            *
      *  AR990243 - Additional deliveries for CSW212                  *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,FXH00003                                 *
      *             WNCPYSRC,FXH00001                                 *
      *             WNCPYSRC,FXH00002                                 *
      *             WNCPYSRC,FXH00004                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  260363 - SWIFT messages generation error.                    *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255340 - Move reference rate to its field in DEALSDB when    *
      *           CDL049 is on.                                       *
      *  247104 - Only one of either Settlement Payment or            *
      *           Settlement Receipt is amended but both Pay/Rec      *
      *           messages are cancelled and regenerated. This is     *
      *           because pay/rec indicators (PRI1 and PRI3) are set  *
      *           without checking which side was amended.            *
      *           Applied fix 247151                                  *
      *  247151 - Check settlement side                               *
      *  246801 - When CSW050 is switched on always produce a         *
      *           confirmation/Pay_Receives as Bank may need to break *
      *           a multiple mesasage. i.e. If an MT203/MT210 multiple*
      *           has been generated previously a null amendment may  *
      *           be required to break this deal out of the multiple. *
      *           NOTE: Recommend this should be determined by a      *
      *           system value for core.                              *
      *           MT292 not produced with new MT202 after deal front  *
      *           office id amended. PRI1 & PRI3 were set on but      *
      *           CNRQ was not so DLC0210A never got to produce the   *
      *           MT292. Fix is not to set on PRI indicators if no    *
      *           conf is required.                                   *
      *  246387 - Amended 240603 so that CNRQ is set to 'Y' if Buy /  *
      *           Sell Net indicator is amended. 240603 only sets     *
      *           CNRQ to 'Y' when indicators are set to 'Y'          *
      *  243830 - Don't access AOTIINR0 if TI not installed           *
      *         - annotated as 240480                                 *
      *  242477 - Applied fix 200709.  Incorrect deals update due to  *
      *           authorisation of 2nd leg of swap before authorising *
      *           the 1st leg.  Prevent authorisation of the 2nd leg  *
      *           if 1st leg is not yet authorised.                   *
      *  240603 - Set CNRQ to 'Y' if Buy / Sell Net indicator is      *
      *           amended                                             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  240480 - Don't access AOTIINR0 if TI not installed           *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG6479- when option takedown is enter, not cancel and       *
      *           amendement messages are produce for the option      *
      *           for MMM.                                            *
      *  BUG6191- Validate CVMR correctly for changed status.         *
      *  220783 - SWIFT Confos always being generated on Amend of     *
      *           Deal even if nothing was changed - this was because *
      *           CVMR was ' ' on MMDELDPP but 'N' on DEALSDC & was   *
      *           being compared in Program. Set CVMR on DEALSDC equal*
      *           to F3CVMR on MMDELDPP.                              *
      *                                                               *
      *  LSC025 - Back-Dated SWIFT Messages                           *
      *           Use Core Hook FXFXDLDC10, FXFXDLDC11, FXFXDLDC12    *
      *                         FXFXDLDC13                            *
      *  CTI004 - MidasPlus-TI Integration Enhancements               *
      *           FX Deals Integration                                *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  209895 - No confirmation generated during amend if BLL2II    *
      *           is "Y" and settlement instructions are blanks. Make *
      *           sure that CNRQ is "Y" after settlement instructions *
      *           have been changed to certain values.                *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  207072 - Ensure correct message generation for linked FX     *
      *           deals.                                              *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  155792 - Check other amended fields relevant for generation  *
      *           of an amended confirmation.  And default workfield  *
      *           @@CNRQ to 'N' to prevent a blank CNRQ in DTRIXDD.   *
      *  CDL008 - Continuous Linked Settlement                        *
      *  CAP051 - Automatic Authorisation (FX Part)                   *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in FXVFXDLPD              *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
     FFXMIDBLL  UF A E           K DISK
     F                                     COMMIT
     F                                     INCLUDE(DEALSDBF)
     F                                     INCLUDE(DEALSDFF)
     FSDTIX     UF A E           K DISK
     F                                     COMMIT
     F                                     PREFIX(DX)
                                                                                              CRE020
     FREADVCL1  UF   E           K DISK    COMMIT                                             CRE020
     F                                     USROPN                                             CRE020
      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref                            CRE020
                                                                                              CRE020
     F/COPY WNCPYSRC,FXFXDLDF01

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

      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009

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

      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID FX DEAL
     D FXVFXD        E DS                  EXTNAME(FXVFXDLPD)
     D  @FXREC               400    468
     D  @FXPAY               469   1027
     D  @FXISDA             1394   2043                                                       CSW212
     D/COPY WNCPYSRC,FXFXDLDD02

      **  DEALS FILE - FX DEALS
     D DEALS         E DS                  EXTNAME(DEALSDB)
     D  @DLREC               409    477
     D  @DLPAY               478   1036
     D  @DLISDA             1376   2025                                                       CSW212
     D/COPY WNCPYSRC,FXFXDLDD03

      **  Time data structure for DTRIX.
     D                 DS
     D  @XTIME                 1      6  0
     D  DXTIM                  1      4  0
     D                 DS                                                                     CDL099
      **  Data structure for date in, to change format.                                       CDL099
     D  DateIn                 1      8  0                                                    CDL099
     D  @@YY                   1      4  0                                                    CDL099
     D  @@MM                   5      6  0                                                    CDL099
     D  @@DD                   7      8  0                                                    CDL099
      *                                                                                       CDL099
     D/COPY WNCPYSRC,FXFXDLDD01
                                                                                              CRE020
      ** CRE020 Variables                                                                     CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KPrgMn          S             10A   INZ('FXFXDLUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('ForeignExchangeDeals')                        CRE020
     D PCurSet01       S            200A                                                      CRE020
     D PSysVal02       S             20A                                                      CRE020
     D PCurSet02       S            200A                                                      CRE020
     D PSysVal03       S             20A                                                      CRE020
     D PCurSet03       S            200A                                                      CRE020
     D PSysVal04       S             20A                                                      CRE020
     D PCurSet04       S            200A                                                      CRE020
     D PSysVal05       S             20A                                                      CRE020
     D PCurSet05       S            200A                                                      CRE020
     D PSysVal06       S             20A                                                      CRE020
     D PCurSet06       S            200A                                                      CRE020
     D PSysVal07       S             20A                                                      CRE020
     D PCurSet07       S            200A                                                      CRE020
     D PSysVal08       S             20A                                                      CRE020
     D PCurSet08       S            200A                                                      CRE020
     D PSysVal09       S             20A                                                      CRE020
     D PCurSet09       S            200A                                                      CRE020
     D PSysVal10       S             20A                                                      CRE020
     D PCurSet10       S            200A                                                      CRE020
     D WSysVal01       S              1A                                                      CRE020
     D WEvent          S              8A                                                      CRE020
     D WNew            S              1A                                                      CRE020

      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS

     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ** External DS for TRADE Details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY Details
                                                                                CDL008
      ** Externally described DS for switchable feature                         CDL008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDL008
     D  SLCD         E                     EXTFLD(LCD)                          CDL008

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CTI004
      ** External DS for Module Details                                                       CTI004
                                                                                              CTI004
     D SDTIIN        E DS                  EXTNAME(SDTIINPD)                                  CTI004
      **  TI ICD FIle                                                                         CTI004
                                                                                              CAS001
      ** Define fields used in CAS001                                                         CAS001
                                                                                              CAS001
     D CAS001          S              1A                                                      CAS001
     D CTI004          S              1A                                                      CTI004
     D PRTCD           S              7A                                                      CAS001
     D POPTN           S              7A                                                      CAS001
     D PSARD           S              6A                                                      CAS001

     D CSW025          S              1A                                                     BUG6479
     D CSW050          S              1A                                                      246801
     D CER043          S              1A                                                      CER043
     D CTI006          S              1A                                                    MD030956
     D CDL099          S              1A                                                      CDL099
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************

     C/COPY WNCPYSRC,FXFXDLDC03
      * EXIT IF NOT INSERTION, AMENDMENT OR REVERSAL

     C     F3CHTP        IFNE      'I'
     C     F3CHTP        ANDNE     'A'
     C     F3CHTP        ANDNE     'R'
     C                   RETURN
     C                   END

      * INITIALIZE: DEAL MISSING INDICATOR
      *             SWAP OTHER LEG VALUE DATE

     C                   MOVEL     *BLANK        ##DEAL_MIS
     C                   Z-ADD     *ZERO         ##SOL_VDAT
     C                   MOVE      ' '           RecSd                                       247151A
     C                   MOVE      ' '           PaySd                                       247151A

      * INSERT, AMEND, OR REVERSE THE DEAL

     C     F3CHTP        CASEQ     'I'           FXINS
     C     F3CHTP        CASEQ     'A'           FXAMD
     C     F3CHTP        CASEQ     'R'           FXDEL
     C                   END

     C/COPY WNCPYSRC,FXFXDLDC04
      * IF DEAL NOT MISSING (THIS MAY HAPPEN ON REVERSAL OF SWAPS)

     C     ##DEAL_MIS    IFNE      'Y'
     C     @@CNRQ        IFEQ      'Y'                                                        246801

      * SET PAY/RECEIVE INDICATORS TO BE WRITTEN TO DTRIX

     C                   EXSR      PYRCIN
     C                   ELSE                                                                 246801
     C                   Z-ADD     *ZERO         @@PRI1                                       246801
     C                   Z-ADD     *ZERO         @@PRI2                                       246801
     C                   Z-ADD     *ZERO         @@PRI3                                       246801
     C                   ENDIF                                                                246801

      * WRITE A DTRIX RECORD

     C                   EXSR      WRTDTX

     C                   END

      * IF SWAP OTHER LEG REVERSAL HAS BEEN DONE

     C     ##SOL_VDAT    IFNE      *ZERO

      * WITH SWAP OTHER LEG DETAILS
      * SET PAY/RECEIVE INDICATORS TO BE WRITTEN TO DTRIX
      * AND WRITE A DTRIX RECORD

     C                   EXSR      SOL_PYRCIN
     C                   EXSR      SOL_WRTDTX

     C                   END

      * UPDATE THE DTRIX HEADER RECORD

     C                   EXSR      UPDDTH

     C/COPY WNCPYSRC,FXFXDLDC05
      * UPDATE THE DEALS FILE TRAILER
      * ON INSERTS AND REVERSALS (THE LATTER IF THE DEAL IS NOT MISSING)

     C     F3CHTP        IFEQ      'I'
     C     F3CHTP        OREQ      'R'
     C     ##DEAL_MIS    ANDNE     'Y'
      *
      ** The value of the update is the deal purchase currency amount,
      ** except for option takedowns which produce no net change in value
      *
     C     F3TYPE        IFNE      'OT'
     C                   Z-ADD     F3DAM1        @@AMNP
     C                   ELSE
     C                   Z-ADD     *ZERO         @@AMNP
     C                   END

     C                   EXSR      UPDTRL
     C                   END

      * IF SWAP OTHER LEG REVERSAL HAS BEEN DONE
      * UPDATE THE DEALS FILE TRAILER FOR THIS UPDATE

     C     ##SOL_VDAT    IFNE      *ZERO
      *
      ** The value of the update is the other leg purchase currency amount
      *
     C                   Z-ADD     ##SOL_PUAM    @@AMNP
     C                   EXSR      UPDTRL
     C                   END
     C/COPY WNCPYSRC,FXH00003
      *
      * EXIT FROM PROGRAM
      *
     C                   RETURN
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* FXINS  - INSERT AN FX DEAL                                   *
     C*                                                              *
     C****************************************************************
     C     FXINS         BEGSR
      *
      ** ACCESS THE ASSOCIATED DEAL
      *
     C     F3TYPE        IFEQ      'SW'
     C     F3TYPE        OREQ      'OT'
     C     F3BROK        OREQ      'SWAP'
     C     F3DTYP        OREQ      'S'                                                        242477
      *
     C                   MOVE      F3DADN        DLNO
     C*****DLNO*         CHAIN     DEALSDBF                           99                      231306
     C     DLNO          CHAIN     DEALSDBF                           9998                    231306
      *                                                                                       231306
     C     *IN98         IFEQ      *ON                                                        231306
     C                   EXSR      SRERR                                                      231306
     C                   ENDIF                                                                231306
      *
      ** IF THE ASSOCIATED DEAL IS FOUND
      *
     C                   MOVEL     'N'           ##ASOC
     C     *IN99         IFEQ      '0'
      *
      ** STORE VALUES FROM DEAL, FOR LATER USE
      *
     C                   MOVEL     'Y'           ##ASOC            1
     C                   Z-ADD     VDAT          ##VDAT            5 0
     C                   MOVE      BRKC          ##BRKC            4
     C                   Z-ADD     BAGE          ##BAGE           13 0
     C                   Z-ADD     PUAM          ##PUAM           13 0
     C                   Z-ADD     SLAM          ##SLAM           13 0
     C                   MOVE      DSTI          ##DSTI            1
     C                   IF        CDL099 = 'Y'                                               CDL099
     C                   Z-ADD     BSDT2         ##SOL_SDT2        5 0                        CDL099
     C                   ENDIF                                                                CDL099
      *
      ** DO SWAP, OPTION OR BROKER SWAP UPDATES ON INSERTION
      *
     C     F3TYPE        CASEQ     'SW'          SWAPUPINS
     C     F3TYPE        CASEQ     'OT'          OPTNUPINS
     C     F3BROK        CASEQ     'SWAP'        BSWPUPINS
     C                   END
      *
      ** UPDATE THE ASSOCIATED DEAL
      *
     C                   MOVE      'A'           CHTP
     C                   Z-ADD     BJRDNB        LCD
     C                   UPDATE    DEALSDBF
      *                                                                                      BUG6479
      ** If MMM is used, then generate DTRIXX record for the option deal                     BUG6479
      ** so that cancellation messages can be generated.                                     BUG6479
      *                                                                                      BUG6479
     C                   IF        F3TYPE = 'OT' AND CSW025 = 'Y'                            BUG6479
     C                   EXSR      OP_WRTDTX                                                 BUG6479
     C                   MOVE      ##DEAL_MIS    @TEMP_MIS         1                         BUG6479
     C                   Z-ADD     ##SOL_VDAT    @TEMP_VDAT        5 0                       BUG6479
     C                   MOVE      'N'           ##DEAL_MIS                                  BUG6479
     C                   Z-ADD     0             ##SOL_VDAT                                  BUG6479
     C                   EXSR      UPDDTH                                                    BUG6479
     C                   MOVE      @TEMP_MIS     ##DEAL_MIS                                  BUG6479
     C                   Z-ADD     @TEMP_VDAT    ##SOL_VDAT                                  BUG6479
     C                   ENDIF                                                               BUG6479
                                                                                             BUG6479
     C                   END
      *
     C                   END

      * SET CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX

     C                   EXSR      CNFINS

      * INITIALIZE DEAL

     C                   CLEAR                   DEALS
      *
      **  Record I.D./Deal Number/Record Type
      *
     C                   MOVE      'D'           RECI
     C                   MOVE      F3DN38        DLNO
     C                   MOVE      'B'           RCDT
      *
      **  Record Code
      *
     C     F3TYPE        IFEQ      'OP'
     C                   MOVE      '12'          RCDC
     C                   ELSE
     C     F3TYPE        IFEQ      'OT'
     C                   MOVE      '13'          RCDC
     C                   ELSE
     C     F3TYPE        IFEQ      'SW'
     C                   MOVE      '14'          RCDC
     C                   ELSE
     C                   MOVE      '11'          RCDC
     C                   END
     C                   END
     C                   END
      *
      **  Customer Number
      *
     C                   MOVE      F3DCNO        CNUM
      *
      **  Branch
      *
     C                   MOVE      F3MBCA        BRCA
      *
      **  Deal Type and Sub-type
      *
     C                   MOVE      F3TYPE        DTYP
     C                   MOVE      F3STYP        DLST
      *
      **  Deal date and value date
      *
     C                   MOVE      F3DDDN        DDAT
     C                   MOVE      F3VDDN        VDAT
      *
      ** Option to date
      ** (If swap, set to value date of associated deal - if present)
      *
     C     F3TYPE        IFEQ      'SW'
     C     F3BROK        OREQ      'SWAP'
     C     F3DTYP        OREQ      'S'                                                        242477
     C     ##ASOC        IFEQ      'Y'
     C                   MOVE      ##VDAT        OTDT
     C                   END
     C                   ELSE
     C                   MOVE      F3OTDN        OTDT
     C                   END
      *
      **    Account sequence number
     C                   MOVE      '01'          ZZ002
      *
      **  Broker Code and Brokerage Amount
      **  (If brokerage swap, set to values on associated deal - if present)
      *
     C     F3BROK        IFEQ      'SWAP'
     C     ##ASOC        ANDEQ     'Y'
     C                   MOVE      ##BRKC        BRKC
     C                   MOVE      ##BAGE        BAGE
     C                   ELSE
     C                   MOVE      F3BROK        BRKC
     C     F3BRKG        IFEQ      *ALL'9'
     C                   Z-ADD     0             BAGE
     C                   ELSE
     C                   MOVE      F3BRKG        BAGE
     C                   END
     C                   END
      *
      **  Purchase/Sale Currency and amounts, and exchange rate
      *
     C                   MOVE      F3CCY1        PUCY
     C                   Z-ADD     F3DAM1        PUAM
     C                   MOVE      F3DXRT        EXRT
     C                   MOVE      F3CCY2        SLCY
     C                   Z-SUB     F3DAM2        SLAM
      *
      **  Base Equivalent Amounts, and Original Purchase/Sale Amts.
      *
     C                   Z-ADD     F3BCAE        BCEQ
      *
     C     F3TYPE        IFEQ      'OP'
     C                   Z-ADD     F3BCAE        OBCE
     C                   Z-ADD     PUAM          ORPA
     C                   Z-ADD     SLAM          ORSA
     C                   ELSE
     C                   Z-ADD     *ZERO         OBCE
     C                   Z-ADD     *ZERO         ORPA
     C                   Z-ADD     *ZERO         ORSA
     C                   END
      *
      ** ACCESS PURCHASE CURRENCY DETAILS
      *
     C                   EXSR      ACSPCY
      *
      **  Limit Currency Exchange Rate
      *
     C                   Z-ADD     A6ERLC        LCXR
      *
      **  Our Pay/Receive Method & Instructions
      **  and Customer Pay/Receive Instructions
      *
     C                   MOVE      F3ORCM        PCST
     C                   MOVE      F3MORI        OPCA
     C                   MOVE      F3MCPI        TSCN
     C                   MOVE      F3MOPM        SCST
     C                   MOVE      F3MOPI        OSCA
     C                   MOVE      F3MCRI        TPCN
      *
      **  Swap Leg Indicator
      **  (Set according to value date on associated deal - if present)
      *
     C     F3TYPE        IFEQ      'SW'
     C     F3BROK        OREQ      'SWAP'
     C     F3DTYP        OREQ      'S'                                                        242477
     C     ##ASOC        IFEQ      'Y'
     C     F3VDDN        IFLT      ##VDAT
     C                   Z-ADD     1             FSLI
     C                   ELSE
     C                   Z-ADD     2             FSLI
     C                   END
     C                   END
     C                   END
      *
      **  Calculate Swap Profit/Loss and Currency
      **  (if associated deal is present)
      *
     C     F3TYPE        IFEQ      'SW'
     C     ##ASOC        ANDEQ     'Y'
     C                   EXSR      CALSPL
     C                   END
      *
      **  Swap/option deal number
      *
     C     F3TYPE        IFEQ      'SW'
     C     F3TYPE        OREQ      'OT'
     C     F3BROK        OREQ      'SWAP'
     C     F3DTYP        OREQ      'S'                                                        242477
     C                   MOVE      F3DADN        SODN
     C                   END
      *
      **  Deal For Account of/ Special Instructions
      *
     C                   MOVEL     F3MFAO        FACO
     C                   MOVEL     F3SPEC        SPI
      *
      **  INITIALIZE Indicators
      *
     C                   BITOFF    '01234567'    DNSI
     C                   BITOFF    '01234567'    DSTI
     C                   BITOFF    '01234567'    CNFI
     C                   BITOFF    '01234567'    ACEI
     C                   BITOFF    '01234567'    TLXI
      *
      * Brokerage
      *
     C     F3BROK        IFNE      'SWAP'
     C     F3BROK        ANDNE     'TELX'
     C     F3BROK        ANDNE     'PHON'
     C     F3BROK        ANDNE     'MAIL'
     C     F3BROK        ANDNE     *BLANK
     C     F3BRKG        IFEQ      *ALL'9'
     C                   BITON     '0'           DSTI
     C                   END
     C                   END
      *
      * Swap
      *
     C     F3BROK        IFEQ      'SWAP'
     C     F3TYPE        ANDEQ     'SW'
     C     ##ASOC        ANDEQ     'Y'
     C                   TESTB     '0'           ##DSTI                   99
     C     *IN99         IFEQ      '1'
     C                   BITON     '0'           DSTI
     C                   END
     C                   END
      *
     C     F3BROK        IFEQ      'SWAP'
     C                   BITON     '1'           DSTI
     C                   END
      *
      **  Federal Funds
      *
     C     F3FEDF        IFEQ      'Y'
     C     F3CCY1        ANDEQ     BLUSCY
     C                   BITON     '2'           DSTI
     C                   ELSE
     C                   BITOFF    '2'           DSTI
     C                   END
     C     F3FEDF        IFEQ      'Y'
     C     F3CCY2        ANDEQ     BLUSCY
     C                   BITON     '3'           DSTI
     C                   ELSE
     C                   BITOFF    '3'           DSTI
     C                   END
      *
      **  Last Change Fields
      *
     C                   Z-ADD     BJRDNB        ORED
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVEL     'I'           CHTP
      *
      ** Book Code
     C                   MOVE      F3BOKC        BOKC
      *
      ** Linked Ref NO
     C                   MOVE      F3LNKN        LNKDN
      *
      * RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @FXREC        @DLREC
     C                   MOVEL     F3RONS        RONS                                         CGL029
      *                                                                                       CDL094
      * Enhanced Receive Settlement Instructions                                              CDL094
     C                   MOVEL     F3RBB1        RBTB1                                        CDL094
     C                   MOVEL     F3RBB2        RBTB2                                        CDL094
     C                   MOVEL     F3RBB3        RBTB3                                        CDL094
     C                   MOVEL     F3RBB4        RBTB4                                        CDL094
     C                   MOVEL     F3RBB5        RBTB5                                        CDL094
     C                   MOVEL     F3RBB6        RBTB6                                        CDL094
     C/COPY WNCPYSRC,FXFXDLDC06
      *
      * PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @FXPAY        @DLPAY
     C                   MOVEL     F3PONS        PONS                                         CGL029
     C/COPY WNCPYSRC,FXFXDLDC07
      *
      **  Originating Branch
      *
     C                   MOVEL     F3ORBR        ORBR
      *
      **  FX Profit Centre
      *
     C                   MOVEL     F3PRFC        PRFC
      *
      **  Our Receive Branch
      **  Our Pay Branch
      *
     C                   MOVEL     F3ROBR        ROBR
     C                   MOVEL     F3POBR        POBR
      *
      **  Cover Message Required
      *
     C*****F3CVMR        IFNE      'Y'                                                        220783
     C*****              MOVE      'N'           CVMR                                         220783
     C*****              ELSE                                                                 220783
     C*****              MOVE      'Y'           CVMR                                         220783
     C*****              END                                                                  220783
     C                   MOVE      F3CVMR        CVMR                                         220783
      *
      **  Margin points, amount, currency, buy/sell indicator
      *
     C                   MOVE      F3MGPT        MGPT
     C                   MOVE      F3MGAM        MGAM
     C                   MOVE      F3MGCY        MGCY
     C                   MOVE      F3MGBS        MGBS
      *
      **  Original spot rate
     C                   MOVE      F3OSRT        OSRT
      *
      * Forward Points
     C                   MOVE      F3FWPP        FWPT
      *
      ** Buy forward Points amount
      ** Sell forward Points amount
      ** Input DL base spot rate
      ** Other DL base spot rate
      ** Other DL base spot equiv
      ** Buy DL base fwd points
      ** Sell DL base fwd points
      ** Buy DL base fwd amount
      ** Sell DL base fwd amount
      *
     C                   MOVE      F3BFPA        BFPA
     C                   MOVE      F3SFPA        SFPA
     C                   MOVE      F3BDBS        BDBS
     C                   MOVE      F3SDBS        SDBS
     C                   MOVE      F3SDBE        SDBE
     C                   MOVE      F3BDBF        BDBF
     C                   MOVE      F3SDBF        SDBF
     C                   MOVE      F3BDFA        BDFA
     C                   MOVE      F3SDFA        SDFA
      *
      **  Portfolio Reference
      *
     C                   MOVE      F3PTFR        PTFR
      *
      **  FX Netting fields
      *
     C                   MOVE      F3NBUY        NETBY
     C                   MOVE      F3NBRF        NETBR
     C                   MOVE      F3NSEL        NETSL
     C                   MOVE      F3NSRF        NETSR
     C                   MOVE      F3MTCH        MATCH
      *
      ** EMU Settlement fields
      *
     C                   MOVEL     F3RSCY        RSCY
     C                   MOVEL     F3PSCY        PSCY
     C                   MOVEL     F3IC72        IC72
      *                                                                         CAP051
      ** Automatic Authorisation flag                                           CAP051
      *                                                                         CAP051
     C                   MOVEL     F3AUTH        AUTH                           CAP051
      *                                                                         CDL008
      ** CLS settlement.                                                        CDL008
     C                   IF        CDL008 = 'Y'                                 CDL008
     C                   EVAL      CLSS = F3CLSS                                CDL008
     C                   ENDIF                                                  CDL008
                                                                                              CAS001
      ** Yield Curves                                                                         CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y'                                               CAS001
     C/COPY WNCPYSRC,FXH00236
     C                   EVAL      FSOYLC = F3OYLC                                            CAS001
     C                   EVAL      FSTYLC = F3TYLC                                            CAS001
     C                   ENDIF                                                                CAS001
      *                                                                                       CDL038
      **  Class                                                                               CDL038
      *                                                                                       CDL038
     C                   MOVE      F3CLAS        CLAS                                         CDL038
     C                   MOVE      F3RRAT        FSRRAT                                       255340
      *                                                                                       CER043
      **  Reciprocal rate indicator                                                           CER043
      *                                                                                       CER043
     C                   IF        CER043 = 'Y'                                               CER043
     C                   EVAL      FGREIN = F3REIN                                            CER043
     C                   ENDIF                                                                CER043
      *                                                                                       CSW212
      ** ISDA                                                                                 CSW212
     C                   IF        CSW212 = 'Y'                                               CSW212
     C                   MOVEL     @FXISDA       @DLISDA                                      CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CDL099
     C                   IF        CDL099 = 'Y'                                               CDL099
      *                                                                                       CDL099
     C                   Z-ADD     F3VS2Y        @@YY                                         CDL099
     C                   Z-ADD     F3VS2M        @@MM                                         CDL099
     C                   Z-ADD     F3VS2D        @@DD                                         CDL099
      *                                                                                       CDL099
     C                   CALLB     'ZDATE10'                                                  CDL099
     C                   PARM                    DateIn                                       CDL099
     C                   PARM                    ZZMDNO            5 0                        CDL099
     C                   Z-ADD     ZZMDNO        BSDT2                                        CDL099
      *                                                                                       CDL099
     C                   EVAL      BSDT1 = 0                                                  CDL099
     C                   EVAL      BRSD2 = 0                                                  CDL099
     C                   ENDIF                                                                CDL099
      *
      *  WRITE DEAL
      *
     C                   WRITE     DEALSDBF
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C/COPY WNCPYSRC,FXFXDLDC01
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SWAPUPINS - ASSOCIATED SWAP LEG UPDATE ON INSERT             *
     C*                                                              *
     C****************************************************************
     C     SWAPUPINS     BEGSR
      *
      **  Update Record Code, Deal Type, Option End Date
      *
     C                   Z-ADD     14            RCDC
     C                   MOVE      'SW'          DTYP
     C                   Z-ADD     F3VDDN        OTDT
      *
      **  Update Swap Leg indicator
      *
     C     F3VDDN        IFLT      ##VDAT
     C                   Z-ADD     2             FSLI
     C                   ELSE
     C                   Z-ADD     1             FSLI
     C                   END
      *
      **  Update other deal number
      *
     C                   Z-ADD     F3DN38        SODN
      *
      **  Calculate swap profit/loss
      *
     C                   EXSR      CALSPL
      *
      **  Flag as Brokerage swap
      *
     C     F3BROK        IFEQ      'SWAP'
     C                   BITON     '1'           DSTI
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* OPTNUPINS - ASSOCIATED OPTION UPDATE ON INSERT               *
     C*                                                              *
     C****************************************************************
     C     OPTNUPINS     BEGSR
      *
      *    Subtract option-taken-down purchased amount from purchased
      *               amount in the original deal.
      *
     C                   SUB       F3DAM1        PUAM
      *
      *    Subtract option-taken-down sell amount from sell amount
      *               in the original deal.
      *    (sell amount is signed negative)
      *
     C                   ADD       F3DAM2        SLAM
      *
      **  Reduce the margin amount of the related 'OP' deal
      *
     C                   SUB       F3MGAM        MGAM
      *
      **  Reduce the base currency equivalent of the related 'OP' deal
      *
     C                   SUB       F3BCAE        BCEQ
      *
     C                   BITON     '2'           DNSI
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* BSWPUPINS - ASSOCIATED BROKER SWAP UPDATE ON INSERT          *
     C*                                                              *
     C****************************************************************
     C     BSWPUPINS     BEGSR
      *
      **  Update option to date
      *
     C                   Z-ADD     F3VDDN        OTDT
      *
      **  Update the swap leg indicator
      *
     C     F3VDDN        IFLT      ##VDAT
     C                   Z-ADD     2             FSLI
     C                   ELSE
     C                   Z-ADD     1             FSLI
     C                   END
      *
      **  Update the other deal number
      *
     C                   Z-ADD     F3DN38        SODN
      *
     C                   BITON     '1'           DSTI
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* FXAMD  - AMEND AN FX DEAL                                    *
     C*                                                              *
     C****************************************************************
     C     FXAMD         BEGSR
      *
      * ACCESS DEAL
      *
     C*****F3DN38        CHAIN     DEALSDBF                           99                      231306
     C     F3DN38        CHAIN     DEALSDBF                           9998                    231306
      *                                                                                       231306
     C     *IN98         IFEQ      *ON                                                        231306
     C                   EXSR      SRERR                                                      231306
     C                   ENDIF                                                                231306
      *                                                                                       231306
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     F3DN38        DBKEY
     C                   MOVEL     'DEALSDB '    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      SRERR
     C                   END
     C*                                                                                       247151
     C**********         MOVE      ' '           RecSd             1                   247151 260363
     C**********         MOVE      ' '           PaySd             1                   247151 260363
     C     @FXREC        IFNE      @DLREC                                                     247151
     C     F3RONS        ORNE      RONS                                                       247151
     C                   MOVE      'Y'           RecSd             1                          247151
     C                   Endif                                                                247151
     C     @FXPAY        IFNE      @DLPAY                                                     247151
     C     F3PONS        ORNE      PONS                                                       247151
     C                   MOVE      'Y'           PaySd             1                          247151
     C                   Endif                                                                247151
     C/COPY WNCPYSRC,FXH00246
      *
      * SET CONFIRMATION BIT ON DEAL
      * AND CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX
      *
     C                   EXSR      CNFAMD
      *
      **  Customer Number
      *
     C                   MOVE      F3DCNO        CNUM
      *
      **  Branch
      *
     C                   MOVE      F3MBCA        BRCA
      *
      **  Deal Sub-type
      *
     C                   MOVE      F3STYP        DLST
      *
      **  Deal date
      *
     C                   MOVE      F3DDDN        DDAT
      *
      **  Broker Code and Brokerage Amount
      *
     C                   MOVE      F3BROK        BRKC
     C     F3BRKG        IFEQ      *ALL'9'
     C                   Z-ADD     0             BAGE
     C                   ELSE
     C                   MOVE      F3BRKG        BAGE
     C                   END
      *
      **  Our Pay/Receive Method & Instructions
      **  and Customer Pay/Receive Instructions
      *
     C                   MOVE      F3ORCM        PCST
     C                   MOVE      F3MORI        OPCA
     C                   MOVE      F3MCPI        TSCN
     C                   MOVE      F3MOPM        SCST
     C                   MOVE      F3MOPI        OSCA
     C                   MOVE      F3MCRI        TPCN
      *
      **  Deal For Account of/ Special Instructions
      *
     C                   MOVE      F3MFAO        FACO
     C                   MOVE      F3SPEC        SPI
      *
      ** Federal funds
      *
     C     F3FEDF        IFEQ      'Y'
     C     F3CCY1        ANDEQ     BLUSCY
     C                   BITON     '2'           DSTI
     C                   ELSE
     C                   BITOFF    '2'           DSTI
     C                   END
     C     F3FEDF        IFEQ      'Y'
     C     F3CCY2        ANDEQ     BLUSCY
     C                   BITON     '3'           DSTI
     C                   ELSE
     C                   BITOFF    '3'           DSTI
     C                   END
      *
      **  Last Change Fields
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'A'           CHTP
      *
      ** Book Code
     C                   MOVE      F3BOKC        BOKC
      *
      ** Linked Ref NO
     C                   Z-ADD     F3LNKN        LNKDN
      *
      * RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @FXREC        @DLREC
     C                   MOVEL     F3RONS        RONS                                         CGL029
      *                                                                                       CDL094
      * Enhanced Receive Settlement Instructions                                              CDL094
     C                   MOVEL     F3RBB1        RBTB1                                        CDL094
     C                   MOVEL     F3RBB2        RBTB2                                        CDL094
     C                   MOVEL     F3RBB3        RBTB3                                        CDL094
     C                   MOVEL     F3RBB4        RBTB4                                        CDL094
     C                   MOVEL     F3RBB5        RBTB5                                        CDL094
     C                   MOVEL     F3RBB6        RBTB6                                        CDL094
     C/COPY WNCPYSRC,FXFXDLDC08
      *
      * PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C/COPY WNCPYSRC,FXFXDLDC09
     C                   MOVEL     @FXPAY        @DLPAY
     C                   MOVEL     F3PONS        PONS                                         CGL029
      *
      **  Originating Branch
      *
     C                   MOVEL     F3ORBR        ORBR
      *
      **  FX Profit Centre
      *
     C                   MOVE      F3PRFC        PRFC
      *
      **  Our Receive Branch
      **  Our Pay Branch
      *
     C                   MOVEL     F3ROBR        ROBR
     C                   MOVEL     F3POBR        POBR
      *
      **  Cover Message Required
      *
     C*****F3CVMR        IFNE      'Y'                                                        220783
     C*****              MOVE      'N'           CVMR                                         220783
     C*****              ELSE                                                                 220783
     C*****              MOVE      'Y'           CVMR                                         220783
     C*****              END                                                                  220783
     C                   MOVE      F3CVMR        CVMR                                         220783
      *
      ** Buy forward Points amount
      ** Sell forward Points amount
      ** Input DL base spot rate
      ** Other DL base spot rate
      ** Other DL base spot equiv
      ** Buy DL base fwd points
      ** Sell DL base fwd points
      ** Buy DL base fwd amount
      ** Sell DL base fwd amount
      *
     C                   MOVE      F3BFPA        BFPA
     C                   MOVE      F3SFPA        SFPA
     C                   MOVE      F3BDBS        BDBS
     C                   MOVE      F3SDBS        SDBS
     C                   MOVE      F3SDBE        SDBE
     C                   MOVE      F3BDBF        BDBF
     C                   MOVE      F3SDBF        SDBF
     C                   MOVE      F3BDFA        BDFA
     C                   MOVE      F3SDFA        SDFA
      *
      ** Portfolio Reference
      *
     C                   MOVE      F3PTFR        PTFR
      *
      **  FX Netting fields
      *
     C                   MOVE      F3NBUY        NETBY
     C                   MOVE      F3NBRF        NETBR
     C                   MOVE      F3NSEL        NETSL
     C                   MOVE      F3NSRF        NETSR
     C                   MOVE      F3MTCH        MATCH
      *
      ** EMU Settlement fields
      *
     C                   MOVEL     F3RSCY        RSCY
     C                   MOVEL     F3PSCY        PSCY
     C                   MOVEL     F3IC72        IC72
      *                                                                         CAP051
      ** Automatic Authorisation flag                                           CAP051
      *                                                                         CAP051
     C                   MOVEL     F3AUTH        AUTH                           CAP051
      *                                                                         CDL008
      ** CLS settlement.                                                        CDL008
     C                   IF        CDL008 = 'Y'                                 CDL008
     C                   EVAL      CLSS = F3CLSS                                CDL008
     C                   ENDIF                                                  CDL008
                                                                                              CAS001
      ** Yield Curves                                                                         CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y'                                               CAS001
     C/COPY WNCPYSRC,FXH00237
     C                   EVAL      FSOYLC = F3OYLC                                            CAS001
     C                   EVAL      FSTYLC = F3TYLC                                            CAS001
     C                   ENDIF                                                                CAS001
      *                                                                                       CDL038
      **  Class                                                                               CDL038
      *                                                                                       CDL038
     C                   MOVE      F3CLAS        CLAS                                         CDL038
     C                   MOVE      F3RRAT        FSRRAT                                       255340
      *                                                                                       CER043
      **  Reciprocal rate indicator                                                           CER043
      *                                                                                       CER043
     C                   IF        CER043 = 'Y'                                               CER043
     C                   EVAL      FGREIN = F3REIN                                            CER043
     C                   ENDIF                                                                CER043
      *                                                                                       CSW212
      ** ISDA                                                                                 CSW212
     C                   IF        CSW212 = 'Y'                                               CSW212
     C                   MOVEL     @FXISDA       @DLISDA                                      CSW212
     C                   ENDIF                                                                CSW212
      *
      * UPDATE DEAL
      *
     C                   UPDATE    DEALSDBF
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C/COPY WNCPYSRC,FXFXDLDC14
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* FXDEL  - DELETE AN FX DEAL                                   *
     C*                                                              *
     C****************************************************************
     C     FXDEL         BEGSR
      *
      ** ACCESS THE ASSOCIATED DEAL
      *
     C     F3TYPE        IFEQ      'SW'
     C     F3TYPE        OREQ      'OT'
     C     F3BROK        OREQ      'SWAP'
      *
     C                   MOVE      F3DADN        DLNO
     C*****DLNO          CHAIN     DEALSDBF                           99                      231306
     C     DLNO          CHAIN     DEALSDBF                           9998                    231306
      *                                                                                       231306
     C     *IN98         IFEQ      *ON                                                        231306
     C                   EXSR      SRERR                                                      231306
     C                   ENDIF                                                                231306
      *
      ** IF THE ASSOCIATED DEAL IS FOUND
      *
     C     *IN99         IFEQ      '0'
      *
      ** DO SWAP, OPTION OR BROKER SWAP UPDATES ON DELETION
      *
     C     F3TYPE        CASEQ     'SW'          SWAPUPDEL
     C     F3TYPE        CASEQ     'OT'          OPTNUPDEL
     C     F3BROK        CASEQ     'SWAP'        BSWPUPDEL
     C                   END
      *
      ** UPDATE THE ASSOCIATED DEAL
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   UPDATE    DEALSDBF
      *                                                                                      BUG6479
      ** If MMM is used, then generate DTRIXX record for the option deal                     BUG6479
      ** so that cancellation messages can be generated.                                     BUG6479
      *                                                                                      BUG6479
     C                   IF        F3TYPE = 'OT' AND CSW025 = 'Y'                            BUG6479
     C                   EXSR      OP_WRTDTX                                                 BUG6479
     C                   MOVE      ##DEAL_MIS    @TEMP_MIS         1                         BUG6479
     C                   Z-ADD     ##SOL_VDAT    @TEMP_VDAT        5 0                       BUG6479
     C                   MOVE      'N'           ##DEAL_MIS                                  BUG6479
     C                   Z-ADD     0             ##SOL_VDAT                                  BUG6479
     C                   EXSR      UPDDTH                                                    BUG6479
     C                   MOVE      @TEMP_MIS     ##DEAL_MIS                                  BUG6479
     C                   Z-ADD     @TEMP_VDAT    ##SOL_VDAT                                  BUG6479
     C                   ENDIF                                                               BUG6479
                                                                                             BUG6479
     C                   END
     C                   END
      *
      * ACCESS DEAL
      *
     C*****F3DN38        CHAIN     DEALSDBF                           99                      231306
     C     F3DN38        CHAIN     DEALSDBF                           9998                    231306
      *                                                                                       231306
     C     *IN98         IFEQ      *ON                                                        231306
     C                   EXSR      SRERR                                                      231306
     C                   ENDIF                                                                231306
      *
      ** DATABASE ERROR IF DEAL IS NOT A SWAP
      *
     C     *IN99         IFEQ      '1'
     C     F3TYPE        IFEQ      'SW'
     C                   MOVEL     'Y'           ##DEAL_MIS        1
     C                   GOTO      EFXDEL
     C                   ELSE
     C                   MOVEL     F3DN38        DBKEY
     C                   MOVEL     'DEALSDB '    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      SRERR
     C                   END
     C                   END
      *
      * SET CONFIRMATION BIT ON DEAL
      * AND CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX
      *
     C                   EXSR      CNFDEL
      *
      * SET RECORD ID TO 'REVERSED'
      *
     C                   MOVE      'R'           RECI
      *
      ** LAST CHANGE DATE & TYPE
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'R'           CHTP
      *
     C                   UPDATE    DEALSDBF
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C/COPY WNCPYSRC,FXFXDLDC15
      *
     C     EFXDEL        ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SWAPUPDEL - ASSOCIATED SWAP LEG UPDATE ON DELETION           *
     C*                                                              *
     C****************************************************************
     C     SWAPUPDEL     BEGSR
      *
      ** Reverse other deal/leg
      *
     C                   MOVE      'R'           RECI
      *
      ** If confirmation previously produced, produce another one
      *
     C                   TESTB     '7'           CNFI                     99
     C     *IN99         IFEQ      '1'
     C                   BITOFF    '0'           CNFI
     C                   END
      *
      ** Change Type is reversal
      *
     C                   MOVE      'R'           CHTP
      *
      ** Store from swap other leg reversed:
      ** . value date
      ** . purchase amount
      ** . purchase currency, receive settle method & receive our nostro
      ** . sell currency, payment settle method & payment our nostro
      *
     C                   Z-ADD     VDAT          ##SOL_VDAT        5 0
     C                   Z-ADD     PUAM          ##SOL_PUAM       13 0
     C                   MOVE      PUCY          ##SOL_PUCY        3
     C                   MOVE      RSCY          ##SOL_RSCY        3
     C                   Z-ADD     RSTM          ##SOL_RSTM        2 0
     C**********         MOVE      RONS          ##SOL_RONS       12                          CGL029
     C                   MOVE      RONS          ##SOL_RONS       18                          CGL029
     C                   MOVE      SLCY          ##SOL_SLCY        3
     C                   MOVE      PSCY          ##SOL_PSCY        3
     C                   Z-ADD     PSTM          ##SOL_PSTM        2 0
     C**********         MOVE      PONS          ##SOL_PONS       12                          CGL029
     C                   MOVE      PONS          ##SOL_PONS       18                          CGL029
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* OPTNUPDEL - ASSOCIATED OPTION UPDATE ON DELETION             *
     C*                                                              *
     C****************************************************************
     C     OPTNUPDEL     BEGSR
      *
      *    Add option-taken-down purchased amount to purchased
      *               amount in the original deal.
      *
     C                   ADD       F3DAM1        PUAM
      *
      *    Add option-taken-down sell amount to sell amount
      *               in the original deal.
      *    (sell amount is signed negative)
      *
     C                   SUB       F3DAM2        SLAM
      *
      **  Increase the margin amount of the related 'OP' deal
      *
     C                   ADD       F3MGAM        MGAM
      *
      **  Increase the base currency equivalent of the related 'OP' deal
      *
     C                   ADD       F3BCAE        BCEQ
      *
     C                   BITON     '2'           DNSI
      *
      ** Change Type is amend
      *
     C                   MOVE      'A'           CHTP
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* BSWPUPDEL - ASSOCIATED BROKER SWAP UPDATE ON DELETION        *
     C*                                                              *
     C****************************************************************
     C     BSWPUPDEL     BEGSR
      *
      **   Reverse related brokerage swaps
      **   Zeroise Swap Other Leg Value Date, Swap Leg Indicator,
      **    and related deal number, and set deal static indicator.
      *
     C                   Z-ADD     *ZERO         OTDT
     C                   Z-ADD     *ZERO         FSLI
     C                   Z-ADD     *ZERO         SODN
     C                   BITOFF    '1'           DSTI
     C     CHTP          IFNE      'R'                                                        207072
     C                   MOVE      'A'           CHTP
     C                   ENDIF                                                                207072
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CALSPL - CALCULATE SWAP ROFIT/LOSS AND CURRENCY              *
     C*                                                              *
     C****************************************************************
     C     CALSPL        BEGSR
      *
      * Swap profit/loss is in purchase currency
      * of primary deal being updated
      *
     C     F3DAM1        IFNE      ##SLAM
     C     F3DAM1        SUB       ##SLAM        SPLA
     C                   MOVE      F3CCY1        SPLC
     C                   ELSE
      *
      * Swap profit/loss is in sale currency
      * of primary deal being updated
      * (note that sell amount is signed negative)
      *
     C     ##PUAM        ADD       F3DAM2        SPLA
     C                   MOVE      F3CCY2        SPLC
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* PYRCIN - DETERMINE PAY/RECEIVE INDICATORS                    *
     C*                                                              *
     C****************************************************************
     C     PYRCIN        BEGSR
      *
     C                   Z-ADD     *ZERO         @@PRI1            1 0
     C                   Z-ADD     *ZERO         @@PRI2            1 0
     C                   Z-ADD     *ZERO         @@PRI3            1 0
     C*                                                                                       247151
     C     RecSd         Ifeq      ' '                                                        247151
     C     PaySd         Andeq     ' '                                                        247151
      *
      *  Deal event date
      *
     C     F3TYPE        IFEQ      'OP'
     C                   Z-ADD     F3OTDN        @@EDAT            5 0
     C                   ELSE
     C                   Z-ADD     F3VDDN        @@EDAT
     C                   END
      *
      * PAY/RECEIVE INDICATOR 1 = PURCHASE CURRENCY
      * -------------------------------------------
      *
      ** Determine if local or purchase currency to be used
      ** in holiday checking
      *
     C     F3RSCY        IFNE      *BLANK
     C                   MOVE      F3RSCY        @CCY
     C                   ELSE
     C                   MOVE      F3CCY1        @CCY
     C                   END
      *
     C                   MOVEL     'L'           @DLOLC
     C                   MOVEL     *BLANK        @NOSTR
      *
     C     F3RSTM        IFEQ      01
     C     F3RSTM        OREQ      07
     C     F3RSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     F3RONS        @NOSTR
     C                   END
      *
      ** DETERMINE TELEX DUE DATE
      *
     C                   EXSR      TLXDUE
      *
      * Set PRI1 if event date is within telex notice period
      *
     C     @@EDAT        IFGE      BJRDNB
     C     @@EDAT        ANDLE     @TLXDU
     C/COPY WNCPYSRC,FXFXDLDC10
     C                   Z-ADD     1             @@PRI1
     C                   END
      *
      ** PAY/RECEIVE INDICATOR 3 = SELL CURRENCY
      *  ---------------------------------------
      *
      ** Determine if local or sell currency to be used
      ** in holiday checking
      *
     C     F3PSCY        IFNE      *BLANK
     C                   MOVE      F3PSCY        @CCY
     C                   ELSE
     C                   MOVE      F3CCY2        @CCY
     C                   END
      *
     C                   MOVEL     'L'           @DLOLC
     C                   MOVEL     *BLANK        @NOSTR
      *
     C     F3PSTM        IFEQ      01
     C     F3PSTM        OREQ      07
     C     F3PSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     F3PONS        @NOSTR
     C                   END
      *
      ** DETERMINE TELEX DUE DATE
      *
     C                   EXSR      TLXDUE
      *
      * Set PRI3 if event date is within telex notice period
      *
     C     @@EDAT        IFGE      BJRDNB
     C     @@EDAT        ANDLE     @TLXDU
     C/COPY WNCPYSRC,FXFXDLDC11
     C                   Z-ADD     1             @@PRI3
     C                   END
     C*                                                                                       247151
     C                   Else                                                                 247151
      *                                                                                       260363
      *  Deal event date                                                                      260363
      *                                                                                       260363
     C     F3TYPE        IFEQ      'OP'                                                       260363
     C                   Z-ADD     F3OTDN        @@EDAT            5 0                        260363
     C                   ELSE                                                                 260363
     C                   Z-ADD     F3VDDN        @@EDAT                                       260363
     C                   ENDIF                                                                260363
      *                                                                                       260363
     C     RecSd         Ifeq      'Y'                                                        247151
     C**********         Z-ADD     1             @@PRI1                                247151 260363
      *                                                                                       260363
      * PAY/RECEIVE INDICATOR 1 = PURCHASE CURRENCY                                           260363
      * -------------------------------------------                                           260363
      *                                                                                       260363
      ** Determine if local or purchase currency to be used                                   260363
      ** in holiday checking                                                                  260363
      *                                                                                       260363
     C     F3RSCY        IFNE      *BLANK                                                     260363
     C                   MOVE      F3RSCY        @CCY                                         260363
     C                   ELSE                                                                 260363
     C                   MOVE      F3CCY1        @CCY                                         260363
     C                   ENDIF                                                                260363
      *                                                                                       260363
     C                   MOVEL     'L'           @DLOLC                                       260363
     C                   MOVEL     *BLANK        @NOSTR                                       260363
      *                                                                                       260363
     C     F3RSTM        IFEQ      01                                                         260363
     C     F3RSTM        OREQ      07                                                         260363
     C     F3RSTM        OREQ      08                                                         260363
     C                   MOVE      'D'           @DLOLC                                       260363
     C                   MOVEL     F3RONS        @NOSTR                                       260363
     C                   ENDIF                                                                260363
      *                                                                                       260363
      ** DETERMINE TELEX DUE DATE                                                             260363
      *                                                                                       260363
     C                   EXSR      TLXDUE                                                     260363
      *                                                                                       260363
      * Set PRI1 if event date is within telex notice period                                  260363
      *                                                                                       260363
     C     @@EDAT        IFGE      BJRDNB                                                     260363
     C     @@EDAT        ANDLE     @TLXDU                                                     260363
     C                   Z-ADD     1             @@PRI1                                       260363
     C                   ENDIF                                                                260363
      *                                                                                       260363
     C                   Endif                                                                247151
     C     PaySd         Ifeq      'Y'                                                        247151
     C**********         Z-ADD     1             @@PRI3                                247151 260363
      *                                                                                       260363
      ** PAY/RECEIVE INDICATOR 3 = SELL CURRENCY                                              260363
      *  ---------------------------------------                                              260363
      *                                                                                       260363
      ** Determine if local or sell currency to be used                                       260363
      ** in holiday checking                                                                  260363
      *                                                                                       260363
     C     F3PSCY        IFNE      *BLANK                                                     260363
     C                   MOVE      F3PSCY        @CCY                                         260363
     C                   ELSE                                                                 260363
     C                   MOVE      F3CCY2        @CCY                                         260363
     C                   ENDIF                                                                260363
      *                                                                                       260363
     C                   MOVEL     'L'           @DLOLC                                       260363
     C                   MOVEL     *BLANK        @NOSTR                                       260363
      *                                                                                       260363
     C     F3PSTM        IFEQ      01                                                         260363
     C     F3PSTM        OREQ      07                                                         260363
     C     F3PSTM        OREQ      08                                                         260363
     C                   MOVE      'D'           @DLOLC                                       260363
     C                   MOVEL     F3PONS        @NOSTR                                       260363
     C                   ENDIF                                                                260363
      *                                                                                       260363
      ** DETERMINE TELEX DUE DATE                                                             260363
      *                                                                                       260363
     C                   EXSR      TLXDUE                                                     260363
      *                                                                                       260363
      * Set PRI3 if event date is within telex notice period                                  260363
      *                                                                                       260363
     C     @@EDAT        IFGE      BJRDNB                                                     260363
     C     @@EDAT        ANDLE     @TLXDU                                                     260363
     C                   Z-ADD     1             @@PRI3                                       260363
     C                   ENDIF                                                                260363
      *                                                                                       260363
     C                   Endif                                                                247151
     C                   Endif                                                                247151
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SOL_PYRCIN - DETERMINE SWAP OTHER LEG PAY/RECEIVE INDICATORS *
     C*                                                              *
     C****************************************************************
     C     SOL_PYRCIN    BEGSR
      *
     C                   Z-ADD     *ZERO         @@PRI1            1 0
     C                   Z-ADD     *ZERO         @@PRI2            1 0
     C                   Z-ADD     *ZERO         @@PRI3            1 0
      *
      * PAY/RECEIVE INDICATOR 1 = PURCHASE CURRENCY
      * -------------------------------------------
      *
      ** Determine if local or purchase currency to be used
      ** in holiday checking
      *
     C     ##SOL_RSCY    IFNE      *BLANK
     C                   MOVE      ##SOL_RSCY    @CCY
     C                   ELSE
     C                   MOVE      ##SOL_PUCY    @CCY
     C                   END
      *
     C                   MOVEL     'L'           @DLOLC
     C                   MOVEL     *BLANK        @NOSTR
      *
     C     ##SOL_RSTM    IFEQ      01
     C     ##SOL_RSTM    OREQ      07
     C     ##SOL_RSTM    OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     ##SOL_RONS    @NOSTR
     C                   END
      *
      ** DETERMINE TELEX DUE DATE
      *
     C                   EXSR      TLXDUE
      *
      * Set PRI1 if value date is within telex notice period
      *
     C     ##SOL_VDAT    IFGE      BJRDNB
     C     ##SOL_VDAT    ANDLE     @TLXDU
     C/COPY WNCPYSRC,FXFXDLDC12
     C                   Z-ADD     1             @@PRI1
     C                   END
      *
      ** PAY/RECEIVE INDICATOR 3 = SELL CURRENCY
      *  ---------------------------------------
      *
      ** Determine if local or sell currency to be used
      ** in holiday checking
      *
     C     ##SOL_PSCY    IFNE      *BLANK
     C                   MOVE      ##SOL_PSCY    @CCY
     C                   ELSE
     C                   MOVE      ##SOL_SLCY    @CCY
     C                   END
      *
     C                   MOVEL     'L'           @DLOLC
     C                   MOVEL     *BLANK        @NOSTR
      *
     C     ##SOL_PSTM    IFEQ      01
     C     ##SOL_PSTM    OREQ      07
     C     ##SOL_PSTM    OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     ##SOL_PONS    @NOSTR
     C                   END
      *
      ** DETERMINE TELEX DUE DATE
      *
     C                   EXSR      TLXDUE
      *
      * Set PRI3 if value date is within telex notice period
      *
     C     ##SOL_VDAT    IFGE      BJRDNB
     C     ##SOL_VDAT    ANDLE     @TLXDU
     C     ##SOL_SDT2    ANDEQ     0                                                          CDL099
     C     ##SOL_SDT2    ORGT      0                                                          CDL099
     C     ##SOL_SDT2    ANDGE     BJRDNB                                                     CDL099
     C     ##SOL_SDT2    ANDLE     @TLXDU                                                     CDL099
     C     CDL099        ANDEQ     'Y'                                                        CDL099
      *                                                                                       CDL099
     C/COPY WNCPYSRC,FXFXDLDC13
     C                   Z-ADD     1             @@PRI3
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFINS - SET CONFIRMATION INDICATOR ON INSERTION             *
     C*                                                              *
     C****************************************************************
     C     CNFINS        BEGSR
      *
     C                   MOVE      'N'           @@CNRQ            1
      *
      *
      * CONFIRMATION REQUIRED IF SETTLEMENT INSTRUCTIONS PRESENT
      * OR IF 2 LEVEL INPUT NOT PRESENT
      *
     C     F3RSTM        IFNE      *ZERO
     C     F3PSTM        ORNE      *ZERO
     C     BLL2II        OREQ      'N'
     C                   MOVE      'Y'           @@CNRQ
     C                   END
      *
      ** Confirmation Required indicator is 'N' for transactions                              CTI004
      ** coming from TI.                                                                      CTI004
      *                                                                                       CTI004
     C     CTI004        IFEQ      'Y'                                                        CTI004
     C     BGN3ST        ANDEQ     'Y'                                                        CTI004
     C     CTI006        OREQ      'Y'                                                      MD030956
     C     F3STYP        IFEQ      TIDLST                                                     CTI004
     C                   MOVE      'N'           @@CNRQ                                       CTI004
     C                   ENDIF                                                                CTI004
     C                   ENDIF                                                                CTI004
      *                                                                                       CTI004
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFAMD - SET CONFIRMATION INDICATOR ON AMENDMENT             *
     C*                                                              *
     C****************************************************************
     C     CNFAMD        BEGSR
     C                   MOVE      'N'           @@CNRQ                                       155792
      *
      * IF SETTLEMENT INSTRUCTIONS WERE PREVIOUSLY PRESENT
      * OR IF 2 LEVEL INPUT NOT PRESENT
      *
     C     RSTM          IFNE      *ZERO
     C     PSTM          ORNE      *ZERO
     C     F3RSTM        ORNE      *ZERO                                                      209895
     C     F3PSTM        ORNE      *ZERO                                                      209895
     C     BLL2II        OREQ      'N'
      *
      ** If settlement instruction fields have changed
      *
     C     RSTM          IFNE      F3RSTM
     C     RONS          ORNE      F3RONS
     C     RIBN          ORNE      F3RIBN
     C     RIBA          ORNE      F3RIBA                                                     155792
     C     ROBN          ORNE      F3ROBN                                                     155792
     C     ROCN          ORNE      F3ROCN                                                     155792
     C     PSTM          ORNE      F3PSTM
     C     PONS          ORNE      F3PONS
     C     PIBN          ORNE      F3PIBN                                                     155792
     C     PIBA          ORNE      F3PIBA                                                     155792
     C     POBN          ORNE      F3POBN                                                     155792
     C     POCN          ORNE      F3POCN                                                     155792
     C     RCRN          ORNE      F3RCRN                                                     155792
     C     RCRA          ORNE      F3RCRA                                                     155792
     C     RVNO          ORNE      F3RVNO                                                     155792
     C     AWBN          ORNE      F3AWBN
     C     AWBA          ORNE      F3AWBA                                                     155792
     C     BENN          ORNE      F3BENN
     C     BENA          ORNE      F3BENA                                                     155792
     C     DTP1          ORNE      F3DTP1                                                     155792
     C     DTP2          ORNE      F3DTP2                                                     155792
     C     DTP3          ORNE      F3DTP3                                                     155792
     C     DTP4          ORNE      F3DTP4                                                     155792
     C     DCHG          ORNE      F3DCHG                                                     155792
     C     BTB1          ORNE      F3BTB1
     C     BTB2          ORNE      F3BTB2                                                     155792
     C     BTB3          ORNE      F3BTB3                                                     155792
     C     BTB4          ORNE      F3BTB4                                                     155792
     C     BTB5          ORNE      F3BTB5                                                     155792
     C     BTB6          ORNE      F3BTB6                                                     155792
     C     RBTB1         ORNE      F3RBB1                                                     CDL094
     C     RBTB2         ORNE      F3RBB2                                                     CDL094
     C     RBTB3         ORNE      F3RBB3                                                     CDL094
     C     RBTB4         ORNE      F3RBB4                                                     CDL094
     C     RBTB5         ORNE      F3RBB5                                                     CDL094
     C     RBTB6         ORNE      F3RBB6                                                     CDL094
     C*****CVMR*         ORNE      F3CVMR                                             155792 BUG6191
     C     CVMR          OREQ      'Y'                                                       BUG6191
     C     F3CVMR        ANDNE     'Y'                                                       BUG6191
     C     CVMR          OREQ      'N'                                                       BUG6191
     C     F3CVMR        ANDNE     'N'                                                       BUG6191
     C     F3CVMR        ANDNE     ' '                                                       BUG6191
     C     RSCY          ORNE      F3RSCY                                                     155792
     C     PSCY          ORNE      F3PSCY                                                     155792
     C     IC72          ORNE      F3IC72                                                     155792
     C     CLSS          ORNE      F3CLSS                                       CDL008
     C     CDL008        ANDEQ     'Y'                                          CDL008
     C     FSOYLC        ORNE      F3OYLC                                                     CAS001
     C     CAS001        ANDEQ     'Y'                                                        CAS001
     C     FSTYLC        ORNE      F3TYLC                                                     CAS001
     C     CAS001        ANDEQ     'Y'                                                        CAS001
      ** If Buy/Sell Indicators have changed                                                  240603
      *                                                                                       240603
     C*****F3NBUY        OREQ      'Y'                                                 240603 246387
     C*****NETBY         ANDNE     'Y'                                                 240603 246387
     C*****F3NSEL        OREQ      'Y'                                                 240603 246387
     C*****NETSL         ANDNE     'Y'                                                 240603 246387
     C     CSW050        OREQ      'Y'                                                        246801
     C     F3NBUY        ORNE      NETBY                                                      246387
     C     F3NSEL        ORNE      NETSL                                                      246387
     C     SSR1          ORNE      F3SSR1                                                   AR990243
     C     SSR2          ORNE      F3SSR2                                                   AR990243
     C     SSR3          ORNE      F3SSR3                                                   AR990243
     C     SSR4          ORNE      F3SSR4                                                   AR990243
     C     SSR5          ORNE      F3SSR5                                                   AR990243
     C     SSR6          ORNE      F3SSR6                                                   AR990243
     C     CND1          ORNE      F3CND1                                                   AR990243
     C     CND2          ORNE      F3CND2                                                   AR990243
     C     CND3          ORNE      F3CND3                                                   AR990243
     C     CND4          ORNE      F3CND4                                                   AR990243
     C     CND5          ORNE      F3CND5                                                   AR990243
     C     CND6          ORNE      F3CND6                                                   AR990243
     C     ISDA          ORNE      F3ISDA                                                   AR990243
     C     AGTY          ORNE      F3AGTY                                                   AR990243
     C     AGDT          ORNE      F3AGDT                                                   AR990243
     C     AGVV          ORNE      F3AGVV                                                   AR990243
     C     AGVC          ORNE      F3AGVC                                                   AR990243
     C/COPY WNCPYSRC,FXH00247
      *
      ** Produce a confirmation now
      *
     C                   BITOFF    '0'           CNFI
     C                   MOVE      'Y'           @@CNRQ
      *
     C                   END
     C                   END
      *
      ** Confirmation Required indicator is 'N' for transactions                              CTI004
      ** coming from TI.                                                                      CTI004
      *                                                                                       CTI004
     C     CTI004        IFEQ      'Y'                                                        CTI004
     C     BGN3ST        ANDEQ     'Y'                                                        CTI004
     C     CTI006        OREQ      'Y'                                                      MD030956
     C     F3STYP        IFEQ      TIDLST                                                     CTI004
     C                   MOVE      'N'           @@CNRQ                                       CTI004
     C                   ENDIF                                                                CTI004
     C                   ENDIF                                                                CTI004
      *                                                                                       CTI004
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFDEL - SET CONFIRMATION INDICATOR ON DELETION              *
     C*                                                              *
     C****************************************************************
     C     CNFDEL        BEGSR
     C                   MOVE      'N'           @@CNRQ                                       155792
      *
      * CONFIRMATION REQUIRED IF ONE PRODUCED PREVIOUSLY
      *
     C                   TESTB     '7'           CNFI                     99
     C     *IN99         IFEQ      '1'
     C                   BITOFF    '0'           CNFI
     C                   MOVE      'Y'           @@CNRQ
     C                   END
      *
      ** Confirmation Required indicator is 'N' for transactions                              CTI004
      ** coming from TI.                                                                      CTI004
      *                                                                                       CTI004
     C     CTI004        IFEQ      'Y'                                                        CTI004
     C     BGN3ST        ANDEQ     'Y'                                                        CTI004
     C     CTI006        OREQ      'Y'                                                      MD030956
     C     F3STYP        IFEQ      TIDLST                                                     CTI004
     C                   MOVE      'N'           @@CNRQ                                       CTI004
     C                   ENDIF                                                                CTI004
     C                   ENDIF                                                                CTI004
      *                                                                                       CTI004
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* WRTDTX - WRITE A DTRIX RECORD                                *
     C*                                                              *
     C****************************************************************
     C     WRTDTX        BEGSR
      *
      **  SET FIELDS ON RECORD TO BE WRITTEN TO DTRIXDD
      *
     C                   MOVE      'D'           DXRECI
     C                   MOVE      'D'           DXRCDT
     C                   Z-ADD     F3DN38        DXDLNO
     C                   Z-ADD     *ZERO         DXVDAT
     C                   Z-ADD     *ZERO         DXDASN
     C                   MOVE      F3CHTP        DXCHTP
     C                   MOVE      @@CNRQ        DXCNRQ
     C                   MOVE      'N'           DXCNPR
     C                   MOVE      ' '           DXREPR
     C                   TIME                    @XTIME
     C                   MOVE      @@PRI1        DXPRI1
     C                   MOVE      @@PRI2        DXPRI2
     C                   MOVE      @@PRI3        DXPRI3
     C                   Z-ADD     0             DXICIN
     C                   MOVEL     F3DBRC        DXBRCA
     C                   Z-ADD     *ZERO         DXTNLU
     C*
     C                   WRITE     DTRIXDF
      *
     C                   ENDSR
     C****************************************************************
      /EJECT                                                                                 BUG6479
     C****************************************************************                       BUG6479
     C*                                                              *                       BUG6479
     C* OP_WRTDTX - Write a DTRIX Record for OP Deals                *                       BUG6479
     C*                                                              *                       BUG6479
     C****************************************************************                       BUG6479
     C     OP_WRTDTX     BEGSR                                                               BUG6479
      *                                                                                      BUG6479
      **  SET FIELDS ON RECORD TO BE WRITTEN TO DTRIXDD                                      BUG6479
      *                                                                                      BUG6479
     C                   MOVE      'D'           DXRECI                                      BUG6479
     C                   MOVE      'D'           DXRCDT                                      BUG6479
     C                   Z-ADD     DLNO          DXDLNO                                      BUG6479
     C                   Z-ADD     *ZERO         DXVDAT                                      BUG6479
     C                   Z-ADD     *ZERO         DXDASN                                      BUG6479
     C                   MOVE      'A'           DXCHTP                                      BUG6479
     C                   MOVE      'N'           DXCNRQ                                      BUG6479
     C                   MOVE      'N'           DXCNPR                                      BUG6479
     C                   MOVE      ' '           DXREPR                                      BUG6479
     C                   TIME                    @XTIME                                      BUG6479
     C                   MOVE      '0'           DXPRI1                                      BUG6479
     C                   MOVE      '0'           DXPRI2                                      BUG6479
     C                   MOVE      '0'           DXPRI3                                      BUG6479
     C                   TESTB     '0'           TLXI                     99                 BUG6479
     C                   IF        *IN99 = '1'                                               BUG6479
     C                   MOVE      '1'           DXPRI1                                      BUG6479
     C                   ENDIF                                                               BUG6479
     C                   TESTB     '1'           TLXI                     99                 BUG6479
     C                   IF        *IN99 = '1'                                               BUG6479
     C                   MOVE      '1'           DXPRI3                                      BUG6479
     C                   ENDIF                                                               BUG6479
     C                   Z-ADD     0             DXICIN                                      BUG6479
     C                   MOVEL     F3DBRC        DXBRCA                                      BUG6479
     C                   Z-ADD     *ZERO         DXTNLU                                      BUG6479
     C*                                                                                      BUG6479
     C                   WRITE     DTRIXDF                                                   BUG6479
      *                                                                                      BUG6479
     C                   ENDSR                                                               BUG6479
     C****************************************************************                       BUG6479
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SOL_WRTDTX - WRITE A DTRIX RECORD FOR SWAP OTHER LEG REVERSED*
     C*                                                              *
     C****************************************************************
     C     SOL_WRTDTX    BEGSR
      *
      **  SET FIELDS ON RECORD TO BE WRITTEN TO DTRIXDD
      *
     C                   MOVE      'D'           DXRECI
     C                   MOVE      'D'           DXRCDT
     C                   MOVE      F3DADN        DXDLNO
     C                   Z-ADD     *ZERO         DXVDAT
     C                   Z-ADD     *ZERO         DXDASN
     C                   MOVE      F3CHTP        DXCHTP
     C                   MOVE      'Y'           DXCNRQ
     C     CTI004        IFEQ      'Y'                                                        CTI004
     C     BGN3ST        ANDEQ     'Y'                                                        CTI004
     C     CTI006        OREQ      'Y'                                                      MD030956
     C     F3STYP        IFEQ      TIDLST                                                     CTI004
     C                   MOVE      'N'           DXCNRQ                                       CTI004
     C                   ENDIF                                                                CTI004
     C                   ENDIF                                                                CTI004
     C                   MOVE      'N'           DXCNPR
     C                   MOVE      ' '           DXREPR
     C                   TIME                    @XTIME
     C                   MOVE      @@PRI1        DXPRI1
     C                   MOVE      @@PRI2        DXPRI2
     C                   MOVE      @@PRI3        DXPRI3
     C                   Z-ADD     0             DXICIN
     C                   MOVEL     F3DBRC        DXBRCA
     C                   Z-ADD     *ZERO         DXTNLU
     C*
     C                   WRITE     DTRIXDF
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDDTH - UPDATE THE DTRIX HEADER RECORD                      *
     C*                                                              *
     C****************************************************************
     C     UPDDTH        BEGSR
      *
      ** Access the header record
      *
     C                   Z-ADD     *ZERO         DXDLNO
     C*****DXDLNO        CHAIN     DTRIXHF                            99                      231306
     C     DXDLNO        CHAIN     DTRIXHF                            9998                    231306
      *                                                                                       231306
     C     *IN98         IFEQ      *ON                                                        231306
     C                   EXSR      SRERR                                                      231306
     C                   ENDIF                                                                231306
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     DXDLNO        DBKEY
     C                   MOVEL     'DTRIXHF '    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      * Add 1 to number of deal records (on DTRIXDD)
      *
     C     ##DEAL_MIS    IFNE      'Y'
     C                   ADD       1             DXNDLR
     C                   END
     C     ##SOL_VDAT    IFNE      *ZERO
     C                   ADD       1             DXNDLR
     C                   END
      *
     C                   UPDATE    DTRIXHF
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDTRL- UPDATE THE DEALS FILE TRAILER                        *
     C*                                                              *
     C****************************************************************
     C     UPDTRL        BEGSR
      *
     C                   MOVE      *BLANKS       EAPIC            10                        MD025244
      *                                                                                     MD025244
     C                   CALLB     'ZADLTRLRUD'
      *
      ** Return Code
     C                   PARM      *BLANKS       @@RTCD            7
      *
      ** Change Type
     C                   PARM      F3CHTP        @@CHTP            1
      *
      ** Amount
     C                   PARM                    @@AMNP           15 0
      *
      ** Run Date
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    EAPIC                                      MD025244
      *
      ** DATABASE ERROR
      *
     C     @@RTCD        IFEQ      '*ERROR '
     C                   MOVEL     '999999'      DBKEY
     C                   MOVEL     'DEALSDF '    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* TLXDUE - DETERMINE TELEX DUE DATE                            *
     C*                                                              *
     C****************************************************************
     C     TLXDUE        BEGSR
      *
     C/COPY WNCPYSRC,FXH00001
     C                   CALLB     'ZATLXDUEDT'
      *
      ** Deal or local Currency
     C                   PARM                    @DLOLC            1
      *
      ** Currency
     C                   PARM                    @CCY              3
      *
      ** Nostro
     C                   PARM                    @NOSTR            2
      *
      ** Date of Next Working Day
     C                   PARM                    BJDNWD            5 0
      *
      ** Local Currency
     C                   PARM                    BJLCCY            3
      *
      ** System Location
     C                   PARM                    BJSLCD            3
      *
      ** Telex Due Date
     C                   PARM      *ZERO         @TLXDU            5 0
     C/COPY WNCPYSRC,FXH00002
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* ACSPCY - ACCESS PURCHASE CURRENCY DETAILS                    *
     C*                                                              *
     C****************************************************************
     C     ACSPCY        BEGSR
      *
      ** Access currency details using deal currency.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      F3CCY1        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @AJCD         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   EXSR      SRERR
     C                   END
     C                   ENDSR
      *****************************************************************                       CRE020
      /EJECT                                                                                  CRE020
      *****************************************************************                       CRE020
      *                                                               *                       CRE020
      *  SRIdxTrn - Handles the advice index of the current           *                       CRE020
      *             current transaction.                              *                       CRE020
      *                                                               *                       CRE020
      *****************************************************************                       CRE020
     C     SRIdxTrn      BEGSR                                                                CRE020
                                                                                              CRE020
      ** Initialise key values.                                                               CRE020
                                                                                              CRE020
     C                   MOVE      *BLANKS       KRefNo                                       CRE020
     C                   MOVEL     DLNO          KRefNo                                       CRE020
                                                                                              CRE020
      ** Begin advice index processing.                                                       CRE020
                                                                                              CRE020
     C                   MOVE      *BLANK        WNew                                         CRE020
                                                                                              CRE020
     C                   OPEN      READVCL1                                                   CRE020
                                                                                              CRE020
     C     KADVC         SETLL     READVCL1                                                   CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   DOW       NOT %EOF                                                   CRE020
                                                                                              CRE020
      ** Check first if this is a new advice index.                                           CRE020
                                                                                              CRE020
     C                   IF        WNew = *BLANK                                              CRE020
     C                   IF        RCHTYP = 'I' AND                                           CRE020
     C                             RSAPIN = 'N'                                               CRE020
     C                   MOVE      'Y'           WNew                                         CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'N'           WNew                                         CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Set default values if the advice indicator is equal to blank.                        CRE020
                                                                                              CRE020
     C                   IF        RSAPIN = ' '                                               CRE020
                                                                                              CRE020
      ** Change type is always 'I' for newly inserted records.                                CRE020
                                                                                              CRE020
     C                   MOVE      'I'           RCHTYP                                       CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Execute reversal processing if necessary.                                            CRE020
                                                                                              CRE020
     C                   IF        CHTP = 'R'                                                 CRE020
                                                                                              CRE020
      ** Delete the advice index if the current record is a new FX                            CRE020
      ** deal. Reverse it otherwise.                                                          CRE020
                                                                                              CRE020
     C                   MOVE      'R'           RCHTYP                                       CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
                                                                                              CRE020
     C                   IF        WNew = 'Y'                                                 CRE020
     C                   MOVE      'Y'           RSAPIN                                       CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Execute amend processing.                                                            CRE020
                                                                                              CRE020
     C                   IF        WNew = 'Y'                                                 CRE020
     C                   MOVE      'I'           RCHTYP                                       CRE020
                                                                                              CRE020
      ** Change field values only if the authorise indicator is equal to 'N'.                 CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   MOVE      CHTP          RCHTYP                                       CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   UPDATE    READVCD0                                                   CRE020
                                                                                              CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
     C                   ENDDO                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
     C****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    FXVFXD
     C/COPY WNCPYSRC,FXH00248
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** ACCESS TRADING DETAILS
      *
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDTRADPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      SRERR
     C                   END
      *                                                                                       CTI004
      ** Access External Modules Details                                                      CTI004
      *                                                                                       CTI004
     C                   CALL      'AOMMODR0'                                                 CTI004
     C                   PARM      *BLANKS       @RTCD                                        CTI004
     C                   PARM      '*FIRST '     @OPTN                                        CTI004
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CTI004
      *                                                                                       CTI004
      ** Access TI ICD Details via access program                                             CTI004
      *                                                                                       CTI004
     C                   IF        BGN3ST = 'Y'                                               240480
     C                             OR CTI006 = 'Y'                                          MD030956
     C                   CALL      'AOTIINR0'                                                 CTI004
     C                   PARM      '*DBERR'      @RTCD                                        CTI004
     C                   PARM      '*FIRST'      @OPTN                                        CTI004
     C     SDTIIN        PARM      SDTIIN        DSFDY                                        CTI004
     C                   ENDIF                                                                240480
                                                                                              CTI004
      *                                                                         CDL008
      ** Access SAR details file to determine if CDL008 is on.                  CDL008
      ** (Continuous Linked Settlement)                                         CDL008
      *                                                                         CDL008
     C                   CALLB     'AOSARDR0'                                   CDL008
     C                   PARM      *BLANKS       @RTCD                          CDL008
     C                   PARM      '*VERIFY'     @OPTN                          CDL008
     C                   PARM      'CDL008'      @SARD                          CDL008
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL008
     C     @RTCD         IFNE      *BLANKS                                      CDL008
     C     @RTCD         ANDNE     '*NRF   '                                    CDL008
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL008
     C                   MOVEL     '902'         DBASE                          CDL008
     C                   MOVEL     'CDL008'      DBKEY                          CDL008
     C                   EXSR      SRERR                                        CDL008
     C                   ENDIF                                                  CDL008
     C     @RTCD         IFEQ      *BLANKS                                      CDL008
     C                   MOVEL     'Y'           CDL008            1            CDL008
     C                   ELSE                                                   CDL008
     C                   MOVEL     'N'           CDL008                         CDL008
     C                   ENDIF                                                  CDL008
     C/COPY WNCPYSRC,FXH00004
                                                                                              CAS001
      ** Access SAR details file to determine if CAS001 is on.                                CAS001
      ** (Net Present Value Accounting)                                                       CAS001
                                                                                              CAS001
     C                   CALLB     'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRTCD                                        CAS001
     C                   PARM      '*VERIFY'     POPTN                                        CAS001
     C                   PARM      'CAS001'      PSARD                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
     C                             PRTCD <> '*NRF   '                                         CAS001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS001
     C                   EVAL      DBASE = 903                                                CAS001
     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
     C                   EXSR      SRERR                                                      CAS001
     C                   ENDIF                                                                CAS001
     C                   IF        PRTCD = *BLANKS                                            CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
      ** Check if SWIFT 2012  is on                                                           CSW212
      *                                                                                       CSW212
     C                   CALL      'SWIF2012'                                                 CSW212
     C                   PARM      *BLANKS       PRTCD                                        CSW212
      *                                                                                       CSW212
     C     PRTCD         IFEQ      'CSW2012'                                                  CSW212
     C                   MOVEL     'Y'           CSW212            1                          CSW212
     C                   ELSE                                                                 CSW212
     C                   MOVEL     'N'           CSW212                                       CSW212
      *                                                                                       CSW212
     C                   ENDIF                                                                CSW212
     C/COPY WNCPYSRC,FXFXDLDC02
      *                                                                                       CTI004
      ** Access SAR details file to determine if CTI004 is on.                                CTI004
      ** MidasPlus-TI Integration Enhancements                                                CTI004
      *                                                                                       CTI004
     C                   CALLB     'AOSARDR0'                                                 CTI004
     C                   PARM      *BLANKS       PRTCD                                        CTI004
     C                   PARM      '*VERIFY'     POPTN                                        CTI004
     C                   PARM      'CTI004'      PSARD                                        CTI004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CTI004
      *                                                                                       CTI004
     C                   IF        PRTCD <> *BLANKS AND                                       CTI004
     C                             PRTCD <> '*NRF   '                                         CTI004
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CTI004
     C                   EVAL      DBASE = 906                                                CTI004
     C                   EVAL      DBKEY = 'CTI004'                                           CTI004
     C                   EXSR      SRERR                                                      CTI004
     C                   ENDIF                                                                CTI004
     C                   IF        PRTCD = *BLANKS                                            CTI004
     C                   EVAL      CTI004 = 'Y'                                               CTI004
     C                   ELSE                                                                 CTI004
     C                   EVAL      CTI004 = 'N'                                               CTI004
     C                   ENDIF                                                                CTI004
                                                                                              CTI004
      ** Access SAR details file to determine if CSW025 is on.                               BUG6479
      ** (MMM is installed)                                                                  BUG6479
                                                                                             BUG6479
     C                   CALLB     'AOSARDR0'                                                BUG6479
     C                   PARM      *BLANKS       PRTCD                                       BUG6479
     C                   PARM      '*VERIFY'     POPTN                                       BUG6479
     C                   PARM      'CSW025'      PSARD                                       BUG6479
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG6479
     C                   IF        PRTCD <> *BLANKS AND                                      BUG6479
     C                             PRTCD <> '*NRF   '                                        BUG6479
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG6479
     C                   EVAL      DBASE = 907                                               BUG6479
     C                   EVAL      DBKEY = 'CSW025'                                          BUG6479
     C                   EXSR      SRERR                                                     BUG6479
     C                   ENDIF                                                               BUG6479
     C                   IF        PRTCD = *BLANKS                                           BUG6479
     C                   EVAL      CSW025 = 'Y'                                              BUG6479
     C                   ELSE                                                                BUG6479
     C                   EVAL      CSW025 = 'N'                                              BUG6479
     C                   ENDIF                                                               BUG6479
                                                                                             BUG6479
                                                                                              246801
      ** Access SAR details file to determine if CSW050 is on.                                246801
      ** (Multiple Payments mesasages)                                                        246801
                                                                                              246801
     C                   CALLB     'AOSARDR0'                                                 246801
     C                   PARM      *BLANKS       PRTCD                                        246801
     C                   PARM      '*VERIFY'     POPTN                                        246801
     C                   PARM      'CSW050'      PSARD                                        246801
     C     SCSARD        PARM      SCSARD        DSFDY                                        246801
     C                   IF        PRTCD <> *BLANKS AND                                       246801
     C                             PRTCD <> '*NRF   '                                         246801
     C                   EVAL      DBFILE = 'SCSARDPD'                                        246801
     C                   EVAL      DBASE = 909                                                246801
     C                   EVAL      DBKEY = 'CSW050'                                           246801
     C                   EXSR      SRERR                                                      246801
     C                   ENDIF                                                                246801
     C                   IF        PRTCD = *BLANKS                                            246801
     C                   EVAL      CSW050 = 'Y'                                               246801
     C                   ELSE                                                                 246801
     C                   EVAL      CSW050 = 'N'                                               246801
     C                   ENDIF                                                                246801
                                                                                              246801
     C*
      ** Check if CRE020 is enabled.                                                          CRE020
      *                                                                                       CRE020
     C                   CALLB     'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM      '*VERIFY'     POptn                                        CRE020
     C                   PARM      'CRE020'      PSARD                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   EVAL      CRE020 = 'N'                                               CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBase = 904                                                CRE020
     C                   EVAL      DBKey = 'CRE020'                                           CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Check if a System Value exists for this maintenance.                                 CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
                                                                                              CRE020
     C                   CALLB     'AOSVALR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM                    PSysVal01                                    CRE020
     C                   PARM                    PCurSet01                                    CRE020
     C                   PARM                    PSysVal02                                    CRE020
     C                   PARM                    PCurSet02                                    CRE020
     C                   PARM                    PSysVal03                                    CRE020
     C                   PARM                    PCurSet03                                    CRE020
     C                   PARM                    PSysVal04                                    CRE020
     C                   PARM                    PCurSet04                                    CRE020
     C                   PARM                    PSysVal05                                    CRE020
     C                   PARM                    PCurSet05                                    CRE020
     C                   PARM                    PSysVal06                                    CRE020
     C                   PARM                    PCurSet06                                    CRE020
     C                   PARM                    PSysVal07                                    CRE020
     C                   PARM                    PCurSet07                                    CRE020
     C                   PARM                    PSysVal08                                    CRE020
     C                   PARM                    PCurSet08                                    CRE020
     C                   PARM                    PSysVal09                                    CRE020
     C                   PARM                    PCurSet09                                    CRE020
     C                   PARM                    PSysVal10                                    CRE020
     C                   PARM                    PCurSet10                                    CRE020
                                                                                              CRE020
     C                   EVAL      WSysVal01 = 'N'                                            CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   MOVEL     PCurSet01     WSysVal01                                    CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SDSVALPD'                                        CRE020
     C                   EVAL      DBase = 905                                                CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
      *                                                                                       CER043
      ** Call AOSARDR0 to check if CER043 is switched on                                      CER043
      *                                                                                       CER043
     C                   EVAL      CER043 = 'N'                                               CER043
     C                   CALLB     'AOSARDR0'                                                 CER043
     C                   PARM      *BLANKS       PRTCD                                        CER043
     C                   PARM      '*VERIFY'     POPTN                                        CER043
     C                   PARM      'CER043'      PSARD                                        CER043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   IF        PRTCD <> *BLANKS AND                                       CER043
     C                             PRTCD <> '*NRF   '                                         CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
     C                   EVAL      DBASE = 910                                                CER043
     C                   EVAL      DBKEY = 'CER043'                                           CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      SRERR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   IF        PRTCD = *BLANKS                                            CER043
     C                   EVAL      CER043 = 'Y'                                               CER043
     C                   ENDIF                                                                CER043
                                                                                              CRE020
      ** Check if CTI006 is enabled.                                                        MD030956
      *                                                                                     MD030956
     C                   CALLB     'AOSARDR0'                                               MD030956
     C                   PARM      *BLANKS       PRtCd                                      MD030956
     C                   PARM      '*VERIFY'     POptn                                      MD030956
     C                   PARM      'CTI006'      PSARD                                      MD030956
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD030956
                                                                                            MD030956
     C                   EVAL      CTI006 = 'N'                                             MD030956
                                                                                            MD030956
     C                   IF        PRtCd = *BLANKS                                          MD030956
     C                   EVAL      CTI006 = 'Y'                                             MD030956
     C                   ELSE                                                               MD030956
                                                                                            MD030956
     C                   IF        PRtCd <> '*NRF'                                          MD030956
     C     *LOCK         IN        LDA                                                      MD030956
     C                   EVAL      DBFile = 'SCSARDPD'                                      MD030956
     C                   EVAL      DBase = 911                                              MD030956
     C                   EVAL      DBKey = 'CTI006'                                         MD030956
     C                   OUT       LDA                                                      MD030956
     C                   EXSR      SRErr                                                    MD030956
     C                   ENDIF                                                              MD030956
     C                   ENDIF                                                              MD030956
      *                                                                                       CDL099
      ** Check if CDL099 is enabled.                                                          CDL099
      *                                                                                       CDL099
     C                   CALLB     'AOSARDR0'                                                 CDL099
     C                   PARM      *BLANKS       PRtCd                                        CDL099
     C                   PARM      '*VERIFY'     POptn                                        CDL099
     C                   PARM      'CDL099'      PSARD                                        CDL099
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL099
                                                                                              CDL099
     C                   EVAL      CDL099 = 'N'                                               CDL099
                                                                                              CDL099
     C                   IF        PRtCd = *BLANKS                                            CDL099
     C                   EVAL      CDL099 = 'Y'                                               CDL099
     C                   ELSE                                                                 CDL099
                                                                                              CDL099
     C                   IF        PRtCd <> '*NRF'                                            CDL099
     C     *LOCK         IN        LDA                                                        CDL099
     C                   EVAL      DBFile = 'SCSARDPD'                                        CDL099
     C                   EVAL      DBase = 912                                                CDL099
     C                   EVAL      DBKey = 'CDL099'                                           CDL099
     C                   OUT       LDA                                                        CDL099
     C                   EXSR      SRErr                                                      CDL099
     C                   ENDIF                                                                CDL099
     C                   ENDIF                                                                CDL099
                                                                                              CDL099
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C     *IN98         IFEQ      *ON                                                        231306
     C                   MOVEL     '*RECLCK'     @@RTCD                                       231306
     C                   SETON                                        LR                      231306
     C                   ELSE                                                                 231306
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'FXFXDLUPD'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C                   ENDIF                                                                231306
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
**  CPY@
(c) Finastra International Limited 2001
