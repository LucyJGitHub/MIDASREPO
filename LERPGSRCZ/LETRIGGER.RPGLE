     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Collateralised Lending DataFile Triggers')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LETRIGGER - Collateralised Lending DataFile Trigger Program  *
      *                                                               *
      *  Function:  This program sends triggers to the Data Queue     *
      *  (phase(s)) when a Standing Data file or Transaction file     *
      *             has been written to, deleted, or amended.         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11673           Date 03Jul06               *
      *                 BUG11623           Date 27Jun06               *
      *                 CDL049             Date 07Jul06               *
      *                 CIR014             Date 11May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CSE075             Date 17Nov05               *
      *                 CLE106             Date 01Aug04               *
      *                 CSE071             Date 19Jul05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE040             Date 05Jul04               *
      *                 BUG3644            Date 12Jul04               *
      *                 BUG3874            Date 30Jul04               *
      *                 BUG3824            Date 27Jul04               *
      *                 BUG3035            Date 03Jun04               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CRE026 - Consumer Banking                                    *
      *  BUG11673 - General Collateral allocation not included in     *
      *           Predeal checking                                    *
      *  BUG11623 - Sequence No. column should be included (Recompile)*
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CLE106 - Syndication Manager (Recompile)                     *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE040 - Collateralised Lending Phase 2                      *
      *  BUG3644 - Serious Error in Collateralised Lending            *
      *  BUG3874 - Generate collateral allocation message if change   *
      *            to collateral allocation % or amount.              *
      *  BUG3824 - Max length of data-queue changed to 600 from 6,000 *
      *           (GPUTUxxxx1 failing as DTAQ is full.)               *
      *  BUG3035 - Error on calculation when a rate change is done    *
      *            (Recompile)                                        *
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFCLTYL3   IF   E           K DISK                                                      BUG3644
     FDLDEALL5  IF   E           K DISK    PREFIX(L5_)                                        CLE040
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Data Area for Standing Data Details
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** First entry parameter
     D PARM1           DS
      ** Physical file name
     D  PFlName                1     10
      ** Member name
     D  MbrName               21     30
      ** Trigger event 1=Insert, 2=Delete, 3=Update, 4=Read
     D  TrgEvent              31     31
      ** Trigger time  1=After, 2=Before
     D  TrgTime               32     32
      ** Offset to the before image of the record
     D  BOff                  49     52B 0
      ** Length of the before image of the record
     D  BLen                  53     56B 0
      ** Offset to the after image of the record
     D  AOff                  65     68B 0
      ** Length of the after image of the record
     D  ALen                  69     72B 0
      ** Images
     D  EntryData            117  10117A
 
      ** Second entry parameter
     D PARM2           DS
     D  Leng                   1      4B 0
 
      ** Before images
     D BSDPLINPD     E DS                  EXTNAME(SDPLINPD) PREFIX(B2)
     D BSDCURRPD     E DS                  EXTNAME(SDCURRPD) PREFIX(B3)
     D BSDCTRYPD     E DS                  EXTNAME(SDCTRYPD) PREFIX(B4)
     D BSDACODPD     E DS                  EXTNAME(SDACODPD) PREFIX(B5)
     D BFDDTSTPD     E DS                  EXTNAME(FDDTSTPD) PREFIX(B6)
     D BSDCOTPPD     E DS                  EXTNAME(SDCOTPPD) PREFIX(B7)
     D BSDCUSTPD     E DS                  EXTNAME(SDCUSTPD) PREFIX(B8)
     D BSDMASTPD     E DS                  EXTNAME(SDMASTPD) PREFIX(B9)
     D***BT_CLCWO      E DS                  EXTNAME(T_CLCWO) PREFIX(B11)                    BUG3644
     D BSDCUWOPD     E DS                  EXTNAME(SDCUWOPD) PREFIX(B11)                     BUG3644
     D BGLCOLLPD     E DS                  EXTNAME(GLCOLLPD) PREFIX(B12)
     D BGLCOLAPD     E DS                  EXTNAME(GLCOLAPD) PREFIX(B13)
     D BLEFCLTQD     E DS                  EXTNAME(LEFCLTQD) PREFIX(B14)
     D BACCNTAB      E DS                  EXTNAME(ACCNTAB) PREFIX(B15)
     D BDLDLDCQD     E DS                  EXTNAME(DLDLDCQD) PREFIX(B16)
     D BDLDLDBQD     E DS                  EXTNAME(DLDLDBQD) PREFIX(B17)
     D BDLDLDGQD     E DS                  EXTNAME(DLDLDGQD) PREFIX(B18)
     D BSECTYD       E DS                  EXTNAME(SECTYD) PREFIX(B19)
     D BCLOANCL      E DS                  EXTNAME(CLOANCL) PREFIX(B20)
     D BDEALSDB      E DS                  EXTNAME(DEALSDB) PREFIX(B21)                       CLE040
     D BDEALSDC      E DS                  EXTNAME(DEALSDC) PREFIX(B22)                       CLE040
     D BDEALSDG      E DS                  EXTNAME(DEALSDG) PREFIX(B23)                       CLE040
 
      ** After images
     D ASDPLINPD     E DS                  EXTNAME(SDPLINPD) PREFIX(A2)
     D ASDCURRPD     E DS                  EXTNAME(SDCURRPD) PREFIX(A3)
     D ASDCTRYPD     E DS                  EXTNAME(SDCTRYPD) PREFIX(A4)
     D ASDACODPD     E DS                  EXTNAME(SDACODPD) PREFIX(A5)
     D AFDDTSTPD     E DS                  EXTNAME(FDDTSTPD) PREFIX(A6)
     D ASDCOTPPD     E DS                  EXTNAME(SDCOTPPD) PREFIX(A7)
     D ASDCUSTPD     E DS                  EXTNAME(SDCUSTPD) PREFIX(A8)
     D ASDMASTPD     E DS                  EXTNAME(SDMASTPD) PREFIX(A9)
     D***AT_CLCWO      E DS                  EXTNAME(T_CLCWO) PREFIX(A11)                    BUG3644
     D ASDCUWOPD     E DS                  EXTNAME(SDCUWOPD) PREFIX(A11)                     BUG3644
     D AGLCOLLPD     E DS                  EXTNAME(GLCOLLPD) PREFIX(A12)
     D AGLCOLAPD     E DS                  EXTNAME(GLCOLAPD) PREFIX(A13)
     D ALEFCLTQD     E DS                  EXTNAME(LEFCLTQD) PREFIX(A14)
     D AACCNTAB      E DS                  EXTNAME(ACCNTAB) PREFIX(A15)
     D ADLDLDCQD     E DS                  EXTNAME(DLDLDCQD) PREFIX(A16)
     D ADLDLDBQD     E DS                  EXTNAME(DLDLDBQD) PREFIX(A17)
     D ADLDLDGQD     E DS                  EXTNAME(DLDLDGQD) PREFIX(A18)
     D ASECTYD       E DS                  EXTNAME(SECTYD) PREFIX(A19)
     D ACLOANCL      E DS                  EXTNAME(CLOANCL) PREFIX(A20)
     D ADEALSDB      E DS                  EXTNAME(DEALSDB) PREFIX(A21)                       CLE040
     D ADEALSDC      E DS                  EXTNAME(DEALSDC) PREFIX(A22)                       CLE040
     D ADEALSDG      E DS                  EXTNAME(DEALSDG) PREFIX(A23)                       CLE040
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D ConstHead1      C                   CONST('<?xml version="1.0" encoding')
     D ConstHead2      C                   CONST('="UTF-8"?><calcManagerEvent ')
     D ConstHead3      C                   CONST('xmlns="http://www.misys.com/')
     D ConstHead4      C                   CONST('midas/midasplus/calculationm')
     D ConstHead5      C                   CONST('anager/xml"><eventType>')
     D ConstHead6      C                   CONST('</eventType>')
     D ConstDet1       C                   CONST('<eventParam><paramName>')
     D ConstDet2       C                   CONST('</paramName><paramValue>')
     D ConstDet3       C                   CONST('</paramValue></eventParam>')
     D ConstFoot       C                   CONST('</calcManagerEvent>')
 
     D AfterImg        S           4000A
     D BeforeImg       S           4000A
     D Buffer          S           6000A
     D DtqLen          S              5P 0
     D DtqLib          S             10A
     D DtqNam          S             10A
     D FacBrch         S              3A                                                     BUG3644
     D Offset          S              5P 0
     D WBeforeAfter    S              1A
     D WDetail         S            200A
     D WDtl1           S            200A
     D WDtl2           S            200A
     D WDtl3           S            200A
     D WDtl4           S            200A
     D WDtl5           S            200A
     D WDtl6           S            200A
     D WEvntTyp        S             30A
     D WFldChg1        S              1A
     D WFldChg2        S              1A
     D WFldChg3        S              1A
     D WFldChg4        S              1A
     D WFldChg5        S              1A
     D WFldChg6        S              1A
     D WFldChg7        S              1A
     D WFldChg8        S              1A
     D WFldChg9        S              1A
     D WFldChg10       S              1A
     D WFldChg11       S              1A
     D WFldChg12       S              1A
     D WFldChg13       S              1A
     D WFldChg14       S              1A
     D WFldChg15       S              1A
     D WFldChg16       S              1A
     D WFldChg17       S              1A
     D WFldChg18       S              1A
     D WFldChg19       S              1A
     D WFldChg20       S              1A
     D WFldChg21       S              1A
     D WFldChg22       S              1A
     D WFldChg23       S              1A
     D WFldChg24       S              1A
     D WFldChg25       S              1A
     D WFldChg26       S              1A
     D WFldChg27       S              1A
     D WFldChg28       S              1A
     D WFldChg29       S              1A
     D WFldChg30       S              1A
     D WFldChg31       S              1A
     D WFldChg32       S              1A
     D WFldChg33       S              1A
     D WFldChg34       S              1A
     D WFldChg35       S              1A
     D WFldChg36       S              1A
     D WFldChg37       S              1A                                                    BUG11673
     D WHeader         S            200A
     D WParamName      S             10A
     D WParamValue     S            100A
     D WRun            S              1A
     D WZoned5         S              5S 0
     D WZoned15        S             15S 0
     D WLength         S              4S 0                                                   BUG3644
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Retrieve before/after image from PARM1 using length and offset
 
     C     BOff          ADD       1             OffSet
     C     BLen          SUBST     PARM1:OffSet  BeforeImg
 
     C     AOff          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  AfterImg
 
      ** Call the appropriate subroutine, based on the physical file
 
     C                   SELECT
     C                   WHEN      PFlName = 'SDPLINPD'
     C                   EXSR      SrSDPLINPD
     C                   WHEN      PFlName = 'SDCURRPD'
     C                   EXSR      SrSDCURRPD
     C                   WHEN      PFlName = 'SDCTRYPD'
     C                   EXSR      SrSDCTRYPD
     C                   WHEN      PFlName = 'SDACODPD'
     C                   EXSR      SrSDACODPD
     C                   WHEN      PFlName = 'FDDTSTPD'
     C                   EXSR      SrFDDTSTPD
     C                   WHEN      PFlName = 'SDCOTPPD'
     C                   EXSR      SrSDCOTPPD
     C                   WHEN      PFlName = 'SDCUSTPD'
     C                   EXSR      SrSDCUSTPD
     C                   WHEN      PFlName = 'SDMASTPD'
     C                   EXSR      SrSDMASTPD
     C**********         WHEN      PFlName = 'T_CLCWO'                                       BUG3644
     C**********         EXSR      SrT_CLCWO                                                 BUG3644
     C                   WHEN      PFlName = 'SDCUWOPD'                                      BUG3644
     C                   EXSR      SrSDCUWOPD                                                BUG3644
     C                   WHEN      PFlName = 'GLCOLLPD'
     C                   EXSR      SrGLCOLLPD
     C                   WHEN      PFlName = 'GLCOLAPD'
     C                   EXSR      SrGLCOLAPD
     C                   WHEN      PFlName = 'LEFCLTQD'
     C                   EXSR      SrLEFCLTQD
     C                   WHEN      PFlName = 'ACCNTAB'
     C                   EXSR      SrACCNTAB
     C                   WHEN      PFlName = 'DLDLDCQD'
     C                   EXSR      SrDLDLDCQD
     C                   WHEN      PFlName = 'DLDLDBQD'
     C                   EXSR      SrDLDLDBQD
     C                   WHEN      PFlName = 'DLDLDGQD'
     C                   EXSR      SrDLDLDGQD
     C                   WHEN      PFlName = 'SECTYD'
     C                   EXSR      SrSECTYD
     C                   WHEN      PFlName = 'CLOANCL'
     C                   EXSR      SrCLOANCL
     C                   WHEN      PFlName = 'DEALSDB'                                        CLE040
     C                   EXSR      SrDEALSDB                                                  CLE040
     C                   WHEN      PFlName = 'DEALSDC'                                        CLE040
     C                   EXSR      SrDEALSDC                                                  CLE040
     C                   WHEN      PFlName = 'DEALSDG'                                        CLE040
     C                   EXSR      SrDEALSDG                                                  CLE040
     C                   ENDSL
 
      ** Send buffer to the data queue
 
     C                   IF        Buffer <> *BLANKS
     C                   EVAL      DtqLib = LIBR + 'DPLIB'
     C                   EXSR      SrSendDtaQ
 
     C                   ENDIF
 
      ** Terminate Program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSDPLINPD - Processing for SDPLINPD                         *
      *****************************************************************
     C     SrSDPLINPD    BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BSDPLINPD = BeforeImg
     C                   EVAL      ASDPLINPD = AfterImg
 
     C                   IF        TrgEvent = '3' AND
     C                             NOT (B2PDRECI = 'D' AND
     C                                  A2PDRECI = '*')
     C                   IF        B2PDWEIG <> A2PDWEIG
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   IF        B2PDMARG <> A2PDMARG
     C                   EVAL      WFldChg2 = 'Y'
     C                   ENDIF
     C                   IF        B2PDINOF <> A2PDINOF
     C                   EVAL      WFldChg3 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        (TrgEvent = '3' AND
     C                              B2PDRECI = 'D' AND
     C                              A2PDRECI = '*') OR
     C                             WFldChg1 = 'Y' OR WFldChg2 = 'Y' OR
     C                             WFldChg3 = 'Y'
 
     C                   EVAL      WEvntTyp = 'MN_INSTRUMENT_TYPE'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'PDINNR'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B2PDINNR
     C                   ELSE
     C                   EVAL      WParamValue = A2PDINNR
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
 
     C                   IF        WFldChg1 = 'Y'
     C                   EVAL      WParamName = 'PDWEIG'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A2PDWEIG      WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   ENDIF
 
     C                   IF        WFldChg2 = 'Y'
     C                   EVAL      WParamName = 'PDMARG'
     C                   EVAL      WParamValue = A2PDMARG
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   ENDIF
 
     C                   IF        WFldChg3 = 'Y'
     C                   EVAL      WParamName = 'PDINOF'
     C                   EVAL      WParamValue = A2PDINOF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl4 = WDetail
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C                                      + %TRIM(WDtl4) + ConstFoot
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSDCURRPD - Processing for SDCURRPD                         *
      *****************************************************************
     C     SrSDCURRPD    BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BSDCURRPD = BeforeImg
     C                   EVAL      ASDCURRPD = AfterImg
 
     C                   IF        TrgEvent = '3'
     C                   IF        B3A6POWC <> A3A6POWC
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TrgEvent = '2' OR
     C                             WFldChg1 = 'Y'
 
     C                   EVAL      WEvntTyp = 'MN_CURRENCY'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'A6CYCD'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B3A6CYCD
     C                   ELSE
     C                   EVAL      WParamValue = A3A6CYCD
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
 
     C                   IF        WFldChg1 = 'Y'
     C                   EVAL      WParamName = 'A6POWC'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A3A6POWC      WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + ConstFoot
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSDCTRYPD - Processing for SDCTRYPD                         *
      *****************************************************************
     C     SrSDCTRYPD    BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BSDCTRYPD = BeforeImg
     C                   EVAL      ASDCTRYPD = AfterImg
 
     C                   IF        TrgEvent = '3'
     C                   IF        B4A4CTWC <> A4A4CTWC
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TrgEvent = '2' OR
     C                             WFldChg1 = 'Y'
 
     C                   EVAL      WEvntTyp = 'MN_COUNTRY'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'A4CNCD'
     C*                  IF        TrgEvent = '2'
     C*                  EVAL      WParamValue = B4A4CNCD
     C*                  ELSE
     C                   EVAL      WParamValue = A4A4CNCD
     C*                  ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
 
     C                   IF        WFldChg1 = 'Y'
     C                   EVAL      WParamName = 'A4CTWC'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A4A4CTWC      WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + ConstFoot
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSDACODPD - Processing for SDACODPD                         *
      *****************************************************************
     C     SrSDACODPD    BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BSDACODPD = BeforeImg
     C                   EVAL      ASDACODPD = AfterImg
 
     C                   IF        TrgEvent = '3'
     C                   IF        B5A5INNR <> A5A5INNR
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TrgEvent = '2' OR
     C                             WFldChg1 = 'Y'
 
     C                   EVAL      WEvntTyp = 'MN_ACCOUNT_CODE'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'A5ACCD'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B5A5ACCD
     C                   ELSE
     C                   EVAL      WParamValue = A5A5ACCD
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
 
     C                   IF        WFldChg1 = 'Y'
     C                   EVAL      WParamName = 'A5INNR'
     C                   EVAL      WParamValue = A5A5INNR
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + ConstFoot
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrFDDTSTPD - Processing for FDDTSTPD                         *
      *****************************************************************
     C     SrFDDTSTPD    BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BFDDTSTPD = BeforeImg
     C                   EVAL      AFDDTSTPD = AfterImg
 
     C                   IF        TrgEvent = '3'
     C                   IF        B6INNR <> A6INNR
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TrgEvent = '2' OR
     C                             WFldChg1 = 'Y'
 
     C                   EVAL      WEvntTyp = 'MN_DEALTYPE_SUBTYPE'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'DTPE11'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B6DTPE11
     C                   ELSE
     C                   EVAL      WParamValue = A6DTPE11
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'DLST11'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B6DLST11
     C                   ELSE
     C                   EVAL      WParamValue = A6DLST11
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
 
     C                   IF        WFldChg1 = 'Y'
     C                   EVAL      WParamName = 'INNR'
     C                   EVAL      WParamValue = A6INNR
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C                                      + ConstFoot
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSDCOTPPD - Processing for SDCOTPPD                         *
      *****************************************************************
     C     SrSDCOTPPD    BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BSDCOTPPD = BeforeImg
     C                   EVAL      ASDCOTPPD = AfterImg
 
     C                   IF        TrgEvent = '3' AND
     C                             NOT (B7CTRECI = 'D' AND
     C                                  A7CTRECI = 'R')
     C                   IF        B7CTRVLM <> A7CTRVLM
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        (TrgEvent = '3' AND
     C                              B7CTRECI = 'D' AND
     C                              A7CTRECI = 'R') OR
     C                             WFldChg1 = 'Y'
 
     C                   EVAL      WEvntTyp = 'MN_COLLATERAL_TYPE'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'CTCOLT'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B7CTCOLT
     C                   ELSE
     C                   EVAL      WParamValue = A7CTCOLT
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
 
     C                   IF        WFldChg1 = 'Y'
     C                   EVAL      WParamName = 'CTRVLM'
     C                   EVAL      WParamValue = A7CTRVLM
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + ConstFoot
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSDCUSTPD - Processing for SDCUSTPD                         *
      *****************************************************************
     C     SrSDCUSTPD    BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BSDCUSTPD = BeforeImg
     C                   EVAL      ASDCUSTPD = AfterImg
 
     C                   IF        TrgEvent = '3' AND
     C                             NOT (B8BBDTDL = *ZERO AND
     C                                  A8BBDTDL > *ZERO)
     C                   IF        B8BBCOLC <> A8BBCOLC
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   IF        B8BBINOF <> A8BBINOF
     C                   EVAL      WFldChg2 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        (TrgEvent = '3' AND
     C                              B8BBDTDL = *ZERO AND
     C                              A8BBDTDL > *ZERO) OR
     C                             WFldChg1 = 'Y' OR WFldChg2 = 'Y'
 
     C                   EVAL      WEvntTyp = 'MN_CUSTOMER'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'BBCUST'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B8BBCUST
     C                   ELSE
     C                   EVAL      WParamValue = A8BBCUST
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
 
     C                   IF        WFldChg1 = 'Y'
     C                   EVAL      WParamName = 'BBCOLC'
     C                   EVAL      WParamValue = A8BBCOLC
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   ENDIF
 
     C                   IF        WFldChg2 = 'Y'
     C                   EVAL      WParamName = 'BBINOF'
     C                   EVAL      WParamValue = A8BBINOF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C                                      + ConstFoot
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSDMASTPD - Processing for SDMASTPD                         *
      *****************************************************************
     C     SrSDMASTPD    BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BSDMASTPD = BeforeImg
     C                   EVAL      ASDMASTPD = AfterImg
 
     C                   IF        TrgEvent = '3'
     C                   IF        B9MSPERC <> A9MSPERC
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TrgEvent = '2' OR
     C                             WFldChg1 = 'Y'
 
     C                   EVAL      WEvntTyp = 'MN_FX_MARGIN_TYPE'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'MSTYPE'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B9MSTYPE
     C                   ELSE
     C                   EVAL      WParamValue = A9MSTYPE
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'MSCURR'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B9MSCURR
     C                   ELSE
     C                   EVAL      WParamValue = A9MSCURR
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
 
     C                   IF        WFldChg1 = 'Y'
     C                   EVAL      WParamName = 'MSPERC'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A9MSPERC      WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C                                      + ConstFoot
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ***SrT_CLCWO*-*Processing*for*T_CLCWO****************************                      BUG3644
      *  SrSDCUWOPD - Processing for SDCUWOPD                         *                      BUG3644
      *****************************************************************
     C*****SrT_CLCWO     BEGSR                                                               BUG3644
     C     SrSDCUWOPD    BEGSR                                                               BUG3644
 
     C                   EXSR      SrReset
     C**********         EVAL      BT_CLCWO = BeforeImg                                      BUG3644
     C**********         EVAL      AT_CLCWO = AfterImg                                       BUG3644
     C                   EVAL      BSDCUWOPD = BeforeImg                                     BUG3644
     C                   EVAL      ASDCUWOPD = AfterImg                                      BUG3644
 
     C                   IF        TrgEvent = '3'
     C                   IF        B11WOWEIG <> A11WOWEIG
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TrgEvent = '2' OR
     C                             WFldChg1 = 'Y'
 
     C                   EVAL      WEvntTyp = 'MN_CUSTOMER_WEIGHTING_OVERRIDES'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'WOCNUM'
     C                   EVAL      WParamValue = *BLANKS
     C                   IF        TrgEvent = '2'
     C                   MOVEL     B11WOCNUM     WParamValue
     C                   ELSE
     C                   MOVEL     A11WOCNUM     WParamValue
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'WOPTFR'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B11WOPTFR
     C                   ELSE
     C                   EVAL      WParamValue = A11WOPTFR
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'WOSESN'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B11WOSESN
     C                   ELSE
     C                   EVAL      WParamValue = A11WOSESN
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'WOCYCD'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B11WOCYCD
     C                   ELSE
     C                   EVAL      WParamValue = A11WOCYCD
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl4 = WDetail
     C                   EVAL      WParamName = 'WOCNCD'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B11WOCNCD
     C                   ELSE
     C                   EVAL      WParamValue = A11WOCNCD
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl5 = WDetail
 
     C                   IF        WFldChg1 = 'Y'
     C                   EVAL      WParamName = 'WOWEIG'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A11WOWEIG     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl6 = WDetail
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C                                      + %TRIM(WDtl4) + %TRIM(WDtl5)
     C                                      + %TRIM(WDtl6) + ConstFoot
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrGLCOLLPD - Processing for GLCOLLPD                         *
      *****************************************************************
     C     SrGLCOLLPD    BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BGLCOLLPD = BeforeImg
     C                   EVAL      AGLCOLLPD = AfterImg
 
     C                   IF        TrgEvent = '3' AND
     C                             NOT (B12CDRECI = 'D' AND
     C                                  A12CDRECI = 'R' AND
     C                                  A12CDTYLC = 'D') AND
     C                             (A12CDRECI = 'D' AND
     C                              A12CDSTAT = 'C')
     C                   IF        B12CDCOLT <> A12CDCOLT
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   IF        B12CDGNSP <> A12CDGNSP
     C                   EVAL      WFldChg2 = 'Y'
     C                   ENDIF
     C                   IF        B12CDVDAT <> A12CDVDAT
     C                   EVAL      WFldChg3 = 'Y'
     C                   ENDIF
     C                   IF        B12CDEDAT <> A12CDEDAT
     C                   EVAL      WFldChg4 = 'Y'
     C                   ENDIF
     C                   IF        B12CDCCY <> A12CDCCY
     C                   EVAL      WFldChg5 = 'Y'
     C                   ENDIF
     C                   IF        B12CDAPCT <> A12CDAPCT
     C                   EVAL      WFldChg6 = 'Y'
     C                   ENDIF
     C                   IF        B12CDNAMT <> A12CDNAMT
     C                   EVAL      WFldChg7 = 'Y'
     C                   ENDIF
     C                   IF        B12CDPCNT <> A12CDPCNT
     C                   EVAL      WFldChg8 = 'Y'
     C                   ENDIF
     C                   IF        B12CDMXNA <> A12CDMXNA
     C                   EVAL      WFldChg9 = 'Y'
     C                   ENDIF
     C                   IF        B12CDVAMT <> A12CDVAMT
     C                   EVAL      WFldChg10 = 'Y'
     C                   ENDIF
     C                   IF        B12CDMARG <> A12CDMARG
     C                   EVAL      WFldChg11 = 'Y'
     C                   ENDIF
     C                   IF        B12CDMODS <> A12CDMODS
     C                   EVAL      WFldChg12 = 'Y'
     C                   ENDIF
     C                   IF        B12CDFCUS <> A12CDFCUS
     C                   EVAL      WFldChg13 = 'Y'
     C                   ENDIF
     C                   IF        B12CDFTYP <> A12CDFTYP
     C                   EVAL      WFldChg14 = 'Y'
     C                   ENDIF
     C                   IF        B12CDFSEQ <> A12CDFSEQ
     C                   EVAL      WFldChg15 = 'Y'
     C                   ENDIF
     C                   IF        B12CDLNLM <> A12CDLNLM
     C                   EVAL      WFldChg16 = 'Y'
     C                   ENDIF
     C                   IF        B12CDSBRC <> A12CDSBRC
     C                   EVAL      WFldChg17 = 'Y'
     C                   ENDIF
     C                   IF        B12CDSCNM <> A12CDSCNM
     C                   EVAL      WFldChg18 = 'Y'
     C                   ENDIF
     C                   IF        B12CDSCCY <> A12CDSCCY
     C                   EVAL      WFldChg19 = 'Y'
     C                   ENDIF
     C                   IF        B12CDSACD <> A12CDSACD
     C                   EVAL      WFldChg20 = 'Y'
     C                   ENDIF
     C                   IF        B12CDSSEQ <> A12CDSSEQ
     C                   EVAL      WFldChg21 = 'Y'
     C                   ENDIF
     C                   IF        B12CDCBRC <> A12CDCBRC
     C                   EVAL      WFldChg22 = 'Y'
     C                   ENDIF
     C                   IF        B12CDCCNM <> A12CDCCNM
     C                   EVAL      WFldChg23 = 'Y'
     C                   ENDIF
     C                   IF        B12CDCCCY <> A12CDCCCY
     C                   EVAL      WFldChg24 = 'Y'
     C                   ENDIF
     C                   IF        B12CDCACD <> A12CDCACD
     C                   EVAL      WFldChg25 = 'Y'
     C                   ENDIF
     C                   IF        B12CDCSEQ <> A12CDCSEQ
     C                   EVAL      WFldChg26 = 'Y'
     C                   ENDIF
     C                   IF        B12CDDEAL <> A12CDDEAL
     C                   EVAL      WFldChg27 = 'Y'
     C                   ENDIF
     C                   IF        B12CDCSBR <> A12CDCSBR
     C                   EVAL      WFldChg28 = 'Y'
     C                   ENDIF
     C                   IF        B12CDCSEC <> A12CDCSEC
     C                   EVAL      WFldChg29 = 'Y'
     C                   ENDIF
     C                   IF        B12CDCSCN <> A12CDCSCN
     C                   EVAL      WFldChg30 = 'Y'
     C                   ENDIF
     C                   IF        B12CDVPCH <> A12CDVPCH
     C                   EVAL      WFldChg31 = 'Y'
     C                   ENDIF
     C                   IF        B12CDPTFR <> A12CDPTFR
     C                   EVAL      WFldChg32 = 'Y'
     C                   ENDIF
     C                   IF        B12CDMNNA <> A12CDMNNA
     C                   EVAL      WFldChg33 = 'Y'
     C                   ENDIF
     C                   IF        B12CDWEIG <> A12CDWEIG
     C                   EVAL      WFldChg34 = 'Y'
     C                   ENDIF
     C                   IF        B12CDPRTP <> A12CDPRTP
     C                   EVAL      WFldChg35 = 'Y'
     C                   ENDIF
     C                   IF        B12CDPR01 <> A12CDPR01
     C                   EVAL      WFldChg36 = 'Y'
     C                   ENDIF
     C                   IF        B12CDTSTP <> A12CDTSTP                                   BUG11673
     C                   EVAL      WFldChg37 = 'Y'                                          BUG11673
     C                   ENDIF                                                              BUG11673
     C                   IF        (WFldChg13 = 'Y' OR
     C                              WFldChg14 = 'Y' OR
     C                              WFldChg15 = 'Y') AND
     C**********                   (B12CDFCUS <> *ZERO OR                                     CSD027
     C                             (B12CDFCUS <> *BLANKS OR                                   CSD027
     C                              B12CDFTYP <> *ZERO OR
     C                              B12CDFSEQ <> *ZERO)
     C                   EVAL      WBeforeAfter = 'B'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TrgEvent = '1' OR
     C                             (TrgEvent = '3' AND
     C                              B12CDRECI = 'D' AND
     C                              B12CDSTAT = 'C' AND
     C                              A12CDRECI = 'R' AND
     C                              A12CDTYLC = 'D') OR
     C                             WBeforeAfter = 'B' OR
     C                             WFldChg1 = 'Y' OR WFldChg2 = 'Y' OR
     C                             WFldChg3 = 'Y' OR WFldChg4 = 'Y' OR
     C                             WFldChg5 = 'Y' OR WFldChg6 = 'Y' OR
     C                             WFldChg7 = 'Y' OR WFldChg8 = 'Y' OR
     C                             WFldChg9 = 'Y' OR WFldChg10 = 'Y' OR
     C                             WFldChg11 = 'Y' OR WFldChg12 = 'Y' OR
     C                             WFldChg16 = 'Y' OR
     C                             WFldChg17 = 'Y' OR WFldChg18 = 'Y' OR
     C                             WFldChg19 = 'Y' OR WFldChg20 = 'Y' OR
     C                             WFldChg21 = 'Y' OR WFldChg22 = 'Y' OR
     C                             WFldChg23 = 'Y' OR WFldChg24 = 'Y' OR
     C                             WFldChg25 = 'Y' OR WFldChg26 = 'Y' OR
     C                             WFldChg27 = 'Y' OR WFldChg28 = 'Y' OR
     C                             WFldChg29 = 'Y' OR WFldChg30 = 'Y' OR
     C                             WFldChg31 = 'Y' OR WFldChg32 = 'Y' OR
     C                             WFldChg33 = 'Y' OR WFldChg34 = 'Y' OR
     C                             WFldChg35 = 'Y' OR WFldChg36 = 'Y' OR                    BUG11673
     C                             WFldChg37 = 'Y'                                          BUG11673
     C**********                   WFldChg35 = 'Y' OR WFldChg36 = 'Y'                       BUG11673
 
     C                   EVAL      WEvntTyp = 'MN_COLLATERAL_REGISTER'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'CDCREF'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B12CDCREF
     C                   ELSE
     C                   EVAL      WParamValue = A12CDCREF
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
 
     C                   IF        WBeforeAfter = 'B'
     C                   EVAL      CNUM = B12CDFCUS                                          BUG3644
     C                   EVAL      FACT = B12CDFTYP                                          BUG3644
     C                   EVAL      FCNO = B12CDFSEQ                                          BUG3644
     C                   EXSR      FNDBRCA                                                   BUG3644
     C                   EVAL      WParamName = 'CDFCUS'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B12CDFCUS     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'CDFTYP'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B12CDFTYP     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamValue = *BLANKS
     C                   EVAL      WParamName = 'CDFSEQ'
     C                   MOVEL     B12CDFSEQ     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl4 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl5 = WDetail                                           BUG3644
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C**********                            + %TRIM(WDtl4) + ConstFoot                       BUG3644
     C                                      + %TRIM(WDtl4) + %TRIM(WDtl5)                    BUG3644
     C                                      + ConstFoot                                      BUG3644
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrGLCOLAPD - Processing for GLCOLAPD                         *
      *****************************************************************
     C     SrGLCOLAPD    BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BGLCOLAPD = BeforeImg
     C                   EVAL      AGLCOLAPD = AfterImg
 
     C                   IF        TrgEvent = '3' AND
     C                             NOT (B13CACHTP <> 'D' AND
     C                                  A13CACHTP = 'D')
     C                   IF        B13CAFCUS <> A13CAFCUS
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   IF        B13CAFTYP <> A13CAFTYP
     C                   EVAL      WFldChg2 = 'Y'
     C                   ENDIF
     C                   IF        B13CAFSEQ <> A13CAFSEQ
     C                   EVAL      WFldChg3 = 'Y'
     C                   ENDIF
     C                   IF        B13CAPCNT <> A13CAPCNT                                    BUG3874
     C                   EVAL      WFldChg4 = 'Y'                                            BUG3874
     C                   ENDIF                                                               BUG3874
     C                   IF        B13CAAMT  <> A13CAAMT                                     BUG3874
     C                   EVAL      WFldChg5 = 'Y'                                            BUG3874
     C                   ENDIF                                                               BUG3874
     C                   IF        (WFldChg1 = 'Y' OR
     C                              WFldChg2 = 'Y' OR
     C                              WFldChg3 = 'Y') AND
     C**********                   (B13CAFCUS <> *ZERO OR                                     CSD027
     C                             (B13CAFCUS <> *BLANKS OR                                   CSD027
     C                              B13CAFTYP <> *ZERO OR
     C                              B13CAFSEQ <> *ZERO)
     C                              OR WFldChg4 = 'Y'                                        BUG3874
     C                              OR WFldChg5 = 'Y'                                        BUG3874
     C                   EVAL      WBeforeAfter = 'B'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TrgEvent = '1' OR
     C                             TrgEvent = '2' OR
     C                             TrgEvent = '3' AND
     C                             (B13CACHTP <> 'D' AND
     C                              A13CACHTP = 'D') OR
     C                             WBeforeAfter = 'B'
 
     C                   EVAL      WEvntTyp = 'MN_COLLATERAL_ALLOCATION'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'CACREF'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B13CACREF
     C                   ELSE
     C                   EVAL      WParamValue = A13CACREF
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
 
     C                   IF        TrgEvent = '2' AND
     C**********                   B13CAFCUS <> 0  AND                                        CSD027
     C                             B13CAFCUS <> *BLANKS AND                                   CSD027
     C                             B13CAFTYP <> 0  AND
     C                             B13CAFSEQ <> 0
     C                   EVAL      CNUM = B13CAFCUS                                          BUG3644
     C                   EVAL      FACT = B13CAFTYP                                          BUG3644
     C                   EVAL      FCNO = B13CAFSEQ                                          BUG3644
     C                   EXSR      FNDBRCA                                                   BUG3644
     C                   EVAL      WParamName = 'CAFCUS'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B13CAFCUS     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'CAFTYP'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B13CAFTYP     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'CAFSEQ'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B13CAFSEQ     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl4 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl5 = WDetail                                           BUG3644
     C                   ENDIF
 
     C                   IF        TrgEvent = '3' AND
     C                             (B13CACHTP <> 'D' AND
     C                              A13CACHTP = 'D') OR
     C                             WBeforeAfter = 'B'
     C                   EVAL      WParamName = 'CAFCUS'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A13CAFCUS     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'CAFTYP'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A13CAFTYP     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'CAFSEQ'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A13CAFSEQ     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl4 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl5 = WDetail                                           BUG3644
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C**********                            + %TRIM(WDtl4) + ConstFoot                       BUG3644
     C                                      + %TRIM(WDtl4) + %TRIM(WDtl5)                    BUG3644
     C                                      + ConstFoot                                      BUG3644
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrLEFCLTQD - Processing for LEFCLTQD                         *
      *****************************************************************
     C     SrLEFCLTQD    BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BLEFCLTQD = BeforeImg
     C                   EVAL      ALEFCLTQD = AfterImg
 
     C                   IF        TrgEvent = '3'
     C                   IF        B14FCXMST <> A14FCXMST
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TrgEvent = '2' OR
     C                             WFldChg1 = 'Y'
 
     C                   EVAL      WEvntTyp = 'MN_FACILITY'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'FacCustNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   IF        TrgEvent = '2'
     C                   MOVEL     B14FCXFCU     WParamValue
     C                   ELSE
     C                   MOVEL     A14FCXFCU     WParamValue
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'FacType'
     C                   EVAL      WParamValue = *BLANKS
     C                   IF        TrgEvent = '2'
     C                   MOVEL     B14FCXFTP     WParamValue
     C                   ELSE
     C                   MOVEL     A14FCXFTP     WParamValue
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'FacSeqNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   IF        TrgEvent = '2'
     C                   MOVEL     B14FCXFNO     WParamValue
     C                   ELSE
     C                   MOVEL     A14FCXFNO     WParamValue
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
 
     C                   IF        WFldChg1 = 'Y'
     C                   EVAL      WParamName = 'FCXMST'
     C                   EVAL      WParamValue = A14FCXMST
     C                   EXSR      SrDetail
     C                   EVAL      WDtl4 = WDetail
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C                                      + %TRIM(WDtl4) + ConstFoot
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrACCNTAB - Processing for ACCNTAB                           *
      *****************************************************************
     C     SrACCNTAB     BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BACCNTAB = BeforeImg
     C                   EVAL      AACCNTAB = AfterImg
 
     C                   IF        TrgEvent = '3'
     C                   IF        B15FCCU <> A15FCCU OR
     C                             B15FACT <> A15FACT OR
     C                             B15FCNO <> A15FCNO
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   IF        WFldChg1 = 'Y' AND
     C**********                   (B15FCCU <> *ZERO OR                                       CSD027
     C                             (B15FCCU <> *BLANKS OR                                     CSD027
     C                              B15FACT <> *ZERO OR
     C                              B15FCNO <> *ZERO)
     C                   EVAL      WBeforeAfter = 'B'
     C                   ENDIF
     C                   IF        WFldChg1 = 'Y' AND
     C**********                   (A15FCCU <> *ZERO OR                                       CSD027
     C                             (A15FCCU <> *BLANKS OR                                     CSD027
     C                              A15FACT <> *ZERO OR
     C                              A15FCNO <> *ZERO)
     C                   EVAL      WBeforeAfter = 'A'
     C                   ENDIF
     C                   IF        WFldChg1 = 'Y' AND
     C**********                   (B15FCCU <> *ZERO OR                                       CSD027
     C                             (B15FCCU <> *BLANKS OR                                     CSD027
     C                              B15FACT <> *ZERO OR
     C                              B15FCNO <> *ZERO) AND
     C**********                   (A15FCCU <> *ZERO OR                                       CSD027
     C                             (A15FCCU <> *BLANKS OR                                     CSD027
     C                              A15FACT <> *ZERO OR
     C                              A15FCNO <> *ZERO)
     C                   EVAL      WBeforeAfter = 'C'
     C                   ENDIF
     C                   IF        B15ACST = *BLANKS AND
     C                             A15ACST = 'C' AND
     C                             B15DACC = *ZERO AND
     C                             A15DACC > *ZERO AND
     C**********                   (B15FCCU <> *ZERO OR                                       CSD027
     C                             (B15FCCU <> *BLANKS OR                                     CSD027
     C                              B15FACT <> *ZERO OR
     C                              B15FCNO <> *ZERO)
     C                   EVAL      WBeforeAfter = 'B'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TrgEvent = '1' AND
     C**********                   (A15FCCU <> *ZERO OR                                       CSD027
     C                             (A15FCCU <> *BLANKS OR                                     CSD027
     C                              A15FACT <> *ZERO OR
     C                              A15FCNO <> *ZERO) OR
     C                             WBeforeAfter <> *BLANKS
 
     C                   EVAL      WEvntTyp = 'MN_ACCOUNT'
     C                   EXSR      SrHeader
 
     C                   IF        TrgEvent = '1' OR
     C                             WBeforeAfter = 'A' OR
     C                             WBeforeAfter = 'C'
     C                   EVAL      CNUM = A15FCCU                                            BUG3644
     C                   EVAL      FACT = A15FACT                                            BUG3644
     C                   EVAL      FCNO = A15FCNO                                            BUG3644
     C                   EXSR      FNDBRCA                                                   BUG3644
     C                   EVAL      WParamName = 'FacCustNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A15FCCU       WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'FacType'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A15FACT       WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'FacSeqNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A15FCNO       WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl4 = WDetail                                           BUG3644
     C                   ENDIF
 
     C                   IF        WBeforeAfter = 'B'
     C                   EVAL      CNUM = B15FCCU                                            BUG3644
     C                   EVAL      FACT = B15FACT                                            BUG3644
     C                   EVAL      FCNO = B15FCNO                                            BUG3644
     C                   EXSR      FNDBRCA                                                   BUG3644
     C                   EVAL      WParamName = 'FacCustNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B15FCCU       WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'FacType'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B15FACT       WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'FacSeqNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B15FCNO       WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl4 = WDetail                                           BUG3644
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C**********                            + ConstFoot                                      BUG3644
     C                                      + %TRIM(WDtl4) + ConstFoot                       BUG3644
 
     C                   EVAL      DtqLib = LIBR + 'DPLIB'
     C                   EXSR      SrSendDtaQ
     C                   EVAL      Buffer = *Blanks
 
     C                   IF        WBeforeAfter = 'C'
     C                   EVAL      CNUM = B15FCCU                                            BUG3644
     C                   EVAL      FACT = B15FACT                                            BUG3644
     C                   EVAL      FCNO = B15FCNO                                            BUG3644
     C                   EXSR      FNDBRCA                                                   BUG3644
     C                   EVAL      WEvntTyp = 'MN_ACCOUNT'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'FacCustNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B15FCCU       WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'FacType'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B15FACT       WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'FacSeqNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B15FCNO       WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl4 = WDetail                                           BUG3644
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C**********                            + ConstFoot                                      BUG3644
     C                                      + %TRIM(WDtl4) + ConstFoot                       BUG3644
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrDLDLDCQD - Processing for DLDLDCQD                         *
      *****************************************************************
     C     SrDLDLDCQD    BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BDLDLDCQD = BeforeImg
     C                   EVAL      ADLDLDCQD = AfterImg
 
     C**********         IF        TrgEvent = '3'                                             CLE040
     C                   IF        TrgEvent = '3' AND                                         CLE040
     C                             (B16F1FCCU <> A16F1FCCU OR                                 CLE040
     C                              B16F1FACT <> A16F1FACT OR                                 CLE040
     C                              B16F1FCNO <> A16F1FCNO)                                   CLE040
                                                                                              CLE040
     C**********         IF        B16F1FCCU <> *ZERO OR                                      CSD027
     C                   IF        B16F1FCCU <> *BLANKS OR                                    CSD027
     C                             B16F1FACT <> *ZERO OR
     C                             B16F1FCNO <> *ZERO
     C                   EVAL      WBeforeAfter = 'B'
     C                   ENDIF
     C**********         IF        A16F1FCCU <> *ZERO OR                                      CSD027
     C                   IF        A16F1FCCU <> *BLANKS OR                                    CSD027
     C                             A16F1FACT <> *ZERO OR
     C                             A16F1FCNO <> *ZERO
     C                   EVAL      WBeforeAfter = 'A'
     C                   ENDIF
     C**********         IF        (B16F1FCCU <> *ZERO OR                                     CSD027
     C                   IF        (B16F1FCCU <> *BLANKS OR                                   CSD027
     C                              B16F1FACT <> *ZERO OR
     C                              B16F1FCNO <> *ZERO) AND
     C**********                   (A16F1FCCU <> *ZERO OR                                     CSD027
     C                             (A16F1FCCU <> *BLANKS OR                                   CSD027
     C                              A16F1FACT <> *ZERO OR
     C                              A16F1FCNO <> *ZERO)
     C                   EVAL      WBeforeAfter = 'C'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TrgEvent = '1' AND
     C**********                   (A16F1FCCU <> *ZERO OR                                     CSD027
     C                             (A16F1FCCU <> *BLANKS OR                                   CSD027
     C                              A16F1FACT <> *ZERO OR
     C                              A16F1FCNO <> *ZERO) OR
     C                             TrgEvent = '2' AND
     C**********                   (B16F1FCCU <> *ZERO OR                                     CSD027
     C                             (B16F1FCCU <> *BLANKS OR                                   CSD027
     C                              B16F1FACT <> *ZERO OR
     C                              B16F1FCNO <> *ZERO) OR
     C**********                   TrgEvent = '3'                                             CLE040
     C                             TrgEvent = '3' AND                                         CLE040
     C                             WBeforeAfter <> *BLANKS                                    CLE040
 
     C                   EVAL      WEvntTyp = 'MN_MM_LOAN'
     C                   EXSR      SrHeader
 
     C                   IF        TrgEvent = '1' OR
     C                             TrgEvent = '3' AND WBeforeAfter = 'A' OR
     C                             TrgEvent = '3' AND WBeforeAfter = 'C'
     C                   EVAL      CNUM = A16F1FCCU                                          BUG3644
     C                   EVAL      FACT = A16F1FACT                                          BUG3644
     C                   EVAL      FCNO = A16F1FCNO                                          BUG3644
     C                   EXSR      FNDBRCA                                                   BUG3644
     C                   EVAL      WParamName = 'FacCustNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A16F1FCCU     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'FacType'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A16F1FACT     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'FacSeqNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A16F1FCNO     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl4 = WDetail                                           BUG3644
     C                   ENDIF
 
     C                   IF        TrgEvent = '2' OR
     C                             TrgEvent = '3' AND WBeforeAfter = 'B'
     C                   EVAL      CNUM = B16F1FCCU                                          BUG3644
     C                   EVAL      FACT = B16F1FACT                                          BUG3644
     C                   EVAL      FCNO = B16F1FCNO                                          BUG3644
     C                   EXSR      FNDBRCA                                                   BUG3644
     C                   EVAL      WParamName = 'FacCustNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B16F1FCCU     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'FacType'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B16F1FACT     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'FacSeqNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B16F1FCNO     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl4 = WDetail                                           BUG3644
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C**********                            + ConstFoot                                      BUG3644
     C                                      + %TRIM(WDtl4) + ConstFoot                       BUG3644
 
     C                   EVAL      DtqLib = LIBR + 'DPLIB'
     C                   EXSR      SrSendDtaQ
     C                   EVAL      Buffer = *Blanks
 
     C                   IF        WBeforeAfter = 'C'
     C                   EVAL      CNUM = B16F1FCCU                                          BUG3644
     C                   EVAL      FACT = B16F1FACT                                          BUG3644
     C                   EVAL      FCNO = B16F1FCNO                                          BUG3644
     C                   EXSR      FNDBRCA                                                   BUG3644
     C                   EVAL      WEvntTyp = 'MN_MM_LOAN'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'FacCustNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B16F1FCCU     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'FacType'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B16F1FACT     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'FacSeqNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B16F1FCNO     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl4 = WDetail                                           BUG3644
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C**********                            + ConstFoot                                      BUG3644
     C                                      + %TRIM(WDtl4) + ConstFoot                       BUG3644
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrDLDLDBQD - Processing for DLDLDBQD                         *
      *****************************************************************
     C     SrDLDLDBQD    BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BDLDLDBQD = BeforeImg
     C                   EVAL      ADLDLDBQD = AfterImg
 
     C**********         IF        TrgEvent = '3'                                             CLE040
     C                   IF        TrgEvent = '3' AND                                         CLE040
     C                             (B17F1FCCU <> A17F1FCCU OR                                 CLE040
     C                              B17F1FACT <> A17F1FACT OR                                 CLE040
     C                              B17F1FCNO <> A17F1FCNO)                                   CLE040
                                                                                              CLE040
     C**********         IF        B17F1FCCU <> *ZERO OR                                      CSD027
     C                   IF        B17F1FCCU <> *BLANKS OR                                    CSD027
     C                             B17F1FACT <> *ZERO OR
     C                             B17F1FCNO <> *ZERO
     C                   EVAL      WBeforeAfter = 'B'
     C                   ENDIF
     C**********         IF        A17F1FCCU <> *ZERO OR                                      CSD027
     C                   IF        A17F1FCCU <> *BLANKS OR                                    CSD027
     C                             A17F1FACT <> *ZERO OR
     C                             A17F1FCNO <> *ZERO
     C                   EVAL      WBeforeAfter = 'A'
     C                   ENDIF
     C**********         IF        (B17F1FCCU <> *ZERO OR                                     CSD027
     C                   IF        (B17F1FCCU <> *BLANKS OR                                   CSD027
     C                              B17F1FACT <> *ZERO OR
     C                              B17F1FCNO <> *ZERO) AND
     C**********                   (A17F1FCCU <> *ZERO OR                                     CSD027
     C                             (A17F1FCCU <> *BLANKS OR                                   CSD027
     C                              A17F1FACT <> *ZERO OR
     C                              A17F1FCNO <> *ZERO)
     C                   EVAL      WBeforeAfter = 'C'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TrgEvent = '1' AND
     C**********                   (A17F1FCCU <> *ZERO OR                                     CSD027
     C                             (A17F1FCCU <> *BLANKS OR                                   CSD027
     C                              A17F1FACT <> *ZERO OR
     C                              A17F1FCNO <> *ZERO) OR
     C                             TrgEvent = '2' AND
     C**********                   (B17F1FCCU <> *ZERO OR                                     CSD027
     C                             (B17F1FCCU <> *BLANKS OR                                   CSD027
     C                              B17F1FACT <> *ZERO OR
     C                              B17F1FCNO <> *ZERO) OR
     C**********                   TrgEvent = '3'                                             CLE040
     C                             TrgEvent = '3' AND                                         CLE040
     C                             WBeforeAfter <> *BLANKS                                    CLE040
 
     C                   EVAL      WEvntTyp = 'MN_FX_DEAL'
     C                   EXSR      SrHeader
 
     C                   IF        TrgEvent = '1' OR
     C                             TrgEvent = '3' AND WBeforeAfter = 'A' OR
     C                             TrgEvent = '3' AND WBeforeAfter = 'C'
     C                   EVAL      CNUM = A17F1FCCU                                          BUG3644
     C                   EVAL      FACT = A17F1FACT                                          BUG3644
     C                   EVAL      FCNO = A17F1FCNO                                          BUG3644
     C                   EXSR      FNDBRCA                                                   BUG3644
     C                   EVAL      WParamName = 'FacCustNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A17F1FCCU     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'FacType'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A17F1FACT     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'FacSeqNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A17F1FCNO     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl4 = WDetail                                           BUG3644
     C                   ENDIF
 
     C                   IF        TrgEvent = '2' OR
     C                             TrgEvent = '3' AND WBeforeAfter = 'B'
     C                   EVAL      CNUM = B17F1FCCU                                          BUG3644
     C                   EVAL      FACT = B17F1FACT                                          BUG3644
     C                   EVAL      FCNO = B17F1FCNO                                          BUG3644
     C                   EXSR      FNDBRCA                                                   BUG3644
     C                   EVAL      WParamName = 'FacCustNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B17F1FCCU     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'FacType'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B17F1FACT     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'FacSeqNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B17F1FCNO     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl4 = WDetail                                           BUG3644
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C**********                            + ConstFoot                                      BUG3644
     C                                      + %TRIM(WDtl4) + ConstFoot                       BUG3644
 
     C                   EVAL      DtqLib = LIBR + 'DPLIB'
     C                   EXSR      SrSendDtaQ
     C                   EVAL      Buffer = *Blanks
 
     C                   IF        WBeforeAfter = 'C'
     C                   EVAL      CNUM = B17F1FCCU                                          BUG3644
     C                   EVAL      FACT = B17F1FACT                                          BUG3644
     C                   EVAL      FCNO = B17F1FCNO                                          BUG3644
     C                   EXSR      FNDBRCA                                                   BUG3644
     C                   EVAL      WEvntTyp = 'MN_FX_DEAL'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'FacCustNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B17F1FCCU     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'FacType'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B17F1FACT     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'FacSeqNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B17F1FCNO     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl4 = WDetail                                           BUG3644
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C**********                            + ConstFoot                                      BUG3644
     C                                      + %TRIM(WDtl4) + ConstFoot                       BUG3644
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrDLDLDGQD - Processing for DLDLDGQD                         *
      *****************************************************************
     C     SrDLDLDGQD    BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BDLDLDGQD = BeforeImg
     C                   EVAL      ADLDLDGQD = AfterImg
 
     C**********         IF        TrgEvent = '3'                                             CLE040
     C                   IF        TrgEvent = '3' AND                                         CLE040
     C                             (B18F1FCCU <> A18F1FCCU OR                                 CLE040
     C                              B18F1FACT <> A18F1FACT OR                                 CLE040
     C                              B18F1FCNO <> A18F1FCNO)                                   CLE040
                                                                                              CLE040
     C**********         IF        B18F1FCCU <> *ZERO OR                                      CSD027
     C                   IF        B18F1FCCU <> *BLANKS OR                                    CSD027
     C                             B18F1FACT <> *ZERO OR
     C                             B18F1FCNO <> *ZERO
     C                   EVAL      WBeforeAfter = 'B'
     C                   ENDIF
     C**********         IF        A18F1FCCU <> *ZERO OR                                      CSD027
     C                   IF        A18F1FCCU <> *BLANKS OR                                    CSD027
     C                             A18F1FACT <> *ZERO OR
     C                             A18F1FCNO <> *ZERO
     C                   EVAL      WBeforeAfter = 'A'
     C                   ENDIF
     C**********         IF        (B18F1FCCU <> *ZERO OR                                     CSD027
     C                   IF        (B18F1FCCU <> *BLANKS OR                                   CSD027
     C                              B18F1FACT <> *ZERO OR
     C                              B18F1FCNO <> *ZERO) AND
     C**********                   (A18F1FCCU <> *ZERO OR                                     CSD027
     C                             (A18F1FCCU <> *BLANKS OR                                   CSD027
     C                              A18F1FACT <> *ZERO OR
     C                              A18F1FCNO <> *ZERO)
     C                   EVAL      WBeforeAfter = 'C'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TrgEvent = '1' AND
     C**********                   (A18F1FCCU <> *ZERO OR                                     CSD027
     C                             (A18F1FCCU <> *BLANKS OR                                   CSD027
     C                              A18F1FACT <> *ZERO OR
     C                              A18F1FCNO <> *ZERO) OR
     C                             TrgEvent = '2' AND
     C**********                   (B18F1FCCU <> *ZERO OR                                     CSD027
     C                             (B18F1FCCU <> *BLANKS OR                                   CSD027
     C                              B18F1FACT <> *ZERO OR
     C                              B18F1FCNO <> *ZERO) OR
     C**********                   TrgEvent = '3'                                             CLE040
     C                             TrgEvent = '3' AND                                         CLE040
     C                             WBeforeAfter <> *BLANKS                                    CLE040
 
     C                   EVAL      WEvntTyp = 'MN_FRAIRS_CFCO'
     C                   EXSR      SrHeader
 
     C                   IF        TrgEvent = '1' OR
     C                             TrgEvent = '3' AND WBeforeAfter = 'A' OR
     C                             TrgEvent = '3' AND WBeforeAfter = 'C'
     C                   EVAL      CNUM = A18F1FCCU                                          BUG3644
     C                   EVAL      FACT = A18F1FACT                                          BUG3644
     C                   EVAL      FCNO = A18F1FCNO                                          BUG3644
     C                   EXSR      FNDBRCA                                                   BUG3644
     C                   EVAL      WParamName = 'FacCustNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A18F1FCCU     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'FacType'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A18F1FACT     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'FacSeqNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A18F1FCNO     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl4 = WDetail                                           BUG3644
     C                   ENDIF
 
     C                   IF        TrgEvent = '2' OR
     C                             TrgEvent = '3' AND WBeforeAfter = 'B'
     C                   EVAL      CNUM = B18F1FCCU                                          BUG3644
     C                   EVAL      FACT = B18F1FACT                                          BUG3644
     C                   EVAL      FCNO = B18F1FCNO                                          BUG3644
     C                   EXSR      FNDBRCA                                                   BUG3644
     C                   EVAL      WParamName = 'FacCustNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B18F1FCCU     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'FacType'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B18F1FACT     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'FacSeqNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B18F1FCNO     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl4 = WDetail                                           BUG3644
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C**********                            + ConstFoot                                      BUG3644
     C                                      + %TRIM(WDtl4) + ConstFoot                       BUG3644
 
     C                   EVAL      DtqLib = LIBR + 'DPLIB'
     C                   EXSR      SrSendDtaQ
     C                   EVAL      Buffer = *Blanks
 
     C                   IF        WBeforeAfter = 'C'
     C                   EVAL      CNUM = B18F1FCCU                                          BUG3644
     C                   EVAL      FACT = B18F1FACT                                          BUG3644
     C                   EVAL      FCNO = B18F1FCNO                                          BUG3644
     C                   EXSR      FNDBRCA                                                   BUG3644
     C                   EVAL      WEvntTyp = 'MN_FRAIRS_CFCO'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'FacCustNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B18F1FCCU     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'FacType'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B18F1FACT     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'FacSeqNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B18F1FCNO     WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl4 = WDetail                                           BUG3644
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C**********                            + ConstFoot                                      BUG3644
     C                                      + %TRIM(WDtl4) + ConstFoot                       BUG3644
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSECTYD - Processing for SECTYD                             *
      *****************************************************************
     C     SrSECTYD      BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BSECTYD = BeforeImg
     C                   EVAL      ASECTYD = AfterImg
 
     C                   IF        TrgEvent = '3' AND
     C                             NOT (B19RECI = 'D' AND
     C                                  A19RECI = 'C')
     C                   IF        B19WEIC <> A19WEIC
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   IF        B19SCOR <> A19SCOR
     C                   EVAL      WFldChg2 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        (TrgEvent = '3' AND
     C                              B19RECI = 'D' AND
     C                              A19RECI = 'C') OR
     C                             WFldChg1 = 'Y' OR WFldChg2 = 'Y'
 
     C                   EVAL      WEvntTyp = 'MN_SECURITY'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'SESN'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B19SESN
     C                   ELSE
     C                   EVAL      WParamValue = A19SESN
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
 
     C                   IF        WFldChg1 = 'Y'
     C                   EVAL      WParamName = 'WEIC'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A19WEIC       WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   ENDIF
 
     C                   IF        WFldChg2 = 'Y'
     C                   EVAL      WParamName = 'SCOR'
     C                   EVAL      WParamValue = A19SCOR
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C                                      + ConstFoot
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCLOANCL - Processing for CLOANCL                           *
      *****************************************************************
     C     SrCLOANCL     BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BCLOANCL = BeforeImg
     C                   EVAL      ACLOANCL = AfterImg
 
     C                   IF        TrgEvent = '3'
     C                   IF        B20FCUS <> A20FCUS OR
     C                             B20FTYP <> A20FTYP OR
     C                             B20FSEQ <> A20FSEQ
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   IF        WFldChg1 = 'Y' AND
     C**********                   (B20FCUS <> *ZERO OR                                       CSD027
     C                             (B20FCUS <> *BLANKS OR                                     CSD027
     C                              B20FTYP <> *ZERO OR
     C                              B20FSEQ <> *ZERO)
     C                   EVAL      WBeforeAfter = 'B'
     C                   ENDIF
     C                   IF        WFldChg1 = 'Y' AND
     C**********                   (A20FCUS <> *ZERO OR                                       CSD027
     C                             (A20FCUS <> *BLANKS OR                                     CSD027
     C                              A20FTYP <> *ZERO OR
     C                              A20FSEQ <> *ZERO)
     C                   EVAL      WBeforeAfter = 'A'
     C                   ENDIF
     C                   IF        B20RECI = 'D' AND
     C                             A20RECI = 'R' AND
     C**********                   (B20FCUS <> *ZERO OR                                       CSD027
     C                             (B20FCUS <> *BLANKS OR                                     CSD027
     C                              B20FTYP <> *ZERO OR
     C                              B20FSEQ <> *ZERO)
     C                   EVAL      WBeforeAfter = 'B'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TrgEvent = '1' AND
     C**********                   (A20FCUS <> *ZERO OR                                       CSD027
     C                             (A20FCUS <> *BLANKS OR                                     CSD027
     C                              A20FTYP <> *ZERO OR
     C                              A20FSEQ <> *ZERO) OR
     C                             WBeforeAfter <> *BLANKS
 
     C                   EVAL      WEvntTyp = 'MN_CUSTOMER_LOAN'
     C                   EXSR      SrHeader
 
     C                   IF        TrgEvent = '1' OR
     C                             WBeforeAfter = 'A'
     C                   EVAL      CNUM = A20FCUS                                            BUG3644
     C                   EVAL      FACT = A20FTYP                                            BUG3644
     C                   EVAL      FCNO = A20FSEQ                                            BUG3644
     C                   EXSR      FNDBRCA                                                   BUG3644
     C                   EVAL      WParamName = 'FacCustNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A20FCUS       WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'FacType'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A20FTYP       WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'FacSeqNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A20FSEQ       WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl4 = WDetail                                           BUG3644
     C                   ENDIF
 
     C                   IF        WBeforeAfter = 'B'
     C                   EVAL      CNUM = B20FCUS                                            BUG3644
     C                   EVAL      FACT = B20FTYP                                            BUG3644
     C                   EVAL      FCNO = B20FSEQ                                            BUG3644
     C                   EXSR      FNDBRCA                                                   BUG3644
     C                   EVAL      WParamName = 'FacCustNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B20FCUS       WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
     C                   EVAL      WParamName = 'FacType'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B20FTYP       WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'FacSeqNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B20FSEQ       WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamName = 'FacBrch'                                    BUG3644
     C                   EVAL      WParamValue = *BLANKS                                     BUG3644
     C                   MOVEL     BRCA          WParamValue                                 BUG3644
     C                   EXSR      SrDetail                                                  BUG3644
     C                   EVAL      WDtl4 = WDetail                                           BUG3644
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C**********                            + ConstFoot                                      BUG3644
     C                                      + %TRIM(WDtl4) + ConstFoot                       BUG3644
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************                       CLE040
      /EJECT                                                                                  CLE040
      *****************************************************************                       CLE040
      *  SrDEALSDB - Processing for DEALSDB                           *                       CLE040
      *****************************************************************                       CLE040
     C     SrDEALSDB     BEGSR                                                                CLE040
                                                                                              CLE040
     C                   EXSR      SrReset                                                    CLE040
     C                   EVAL      BDEALSDB = BeforeImg                                       CLE040
     C                   EVAL      ADEALSDB = AfterImg                                        CLE040
                                                                                              CLE040
     C                   IF        B21RECI = 'D' AND                                          CLE040
     C                             A21RECI = 'R'                                              CLE040
     C                   EVAL      WEvntTyp = 'MN_FX_DEAL'                                    CLE040
     C                   MOVEL     B21DLNO       KDlNo                                        CLE040
     C                   EXSR      SrFacDetl                                                  CLE040
     C                   ENDIF                                                                CLE040
                                                                                              CLE040
     C                   ENDSR                                                                CLE040
      *****************************************************************                       CLE040
      /EJECT                                                                                  CLE040
      *****************************************************************                       CLE040
      *  SrDEALSDC - Processing for DEALSDC                           *                       CLE040
      *****************************************************************                       CLE040
     C     SrDEALSDC     BEGSR                                                                CLE040
                                                                                              CLE040
     C                   EXSR      SrReset                                                    CLE040
     C                   EVAL      BDEALSDC = BeforeImg                                       CLE040
     C                   EVAL      ADEALSDC = AfterImg                                        CLE040
                                                                                              CLE040
     C                   IF        B22RECI = 'D' AND                                          CLE040
     C                             A22RECI = 'R'                                              CLE040
     C                   EVAL      WEvntTyp = 'MN_MM_LOAN'                                    CLE040
     C                   MOVEL     B22DLNO       KDlNo                                        CLE040
     C                   EXSR      SrFacDetl                                                  CLE040
     C                   ENDIF                                                                CLE040
                                                                                              CLE040
     C                   ENDSR                                                                CLE040
      *****************************************************************                       CLE040
      /EJECT                                                                                  CLE040
      *****************************************************************                       CLE040
      *  SrDEALSDG - Processing for DEALSDG                           *                       CLE040
      *****************************************************************                       CLE040
     C     SrDEALSDG     BEGSR                                                                CLE040
                                                                                              CLE040
     C                   EXSR      SrReset                                                    CLE040
     C                   EVAL      BDEALSDG = BeforeImg                                       CLE040
     C                   EVAL      ADEALSDG = AfterImg                                        CLE040
                                                                                              CLE040
     C                   IF        B23RECI = 'D' AND                                          CLE040
     C                             A23RECI = 'R'                                              CLE040
     C                   EVAL      WEvntTyp = 'MN_FRAIRS_CFCO'                                CLE040
     C                   MOVEL     B23DLNO       KDlNo                                        CLE040
     C                   EXSR      SrFacDetl                                                  CLE040
     C                   ENDIF                                                                CLE040
                                                                                              CLE040
     C                   ENDSR                                                                CLE040
      *****************************************************************                       CLE040
      /EJECT                                                                                  CLE040
      *****************************************************************                       CLE040
      *  SrFacDetl - Processing for facility details                  *                       CLE040
      *****************************************************************                       CLE040
     C     SrFacDetl     BEGSR                                                                CLE040
                                                                                              CLE040
     C     KDlNo         CHAIN     DLDEALL5                                                   CLE040
     C                   IF        %FOUND(DLDEALL5) AND                                       CLE040
     C**********                   (L5_F1FCCU <> *ZERO OR                              CLE040 CSD027
     C                             (L5_F1FCCU <> *BLANKS OR                                   CSD027
     C                              L5_F1FACT <> *ZERO OR                                     CLE040
     C                              L5_F1FCNO <> *ZERO)                                       CLE040
                                                                                              CLE040
     C                   EVAL      CNUM = L5_F1FCCU                                           CLE040
     C                   EVAL      FACT = L5_F1FACT                                           CLE040
     C                   EVAL      FCNO = L5_F1FCNO                                           CLE040
     C                   EXSR      FNDBRCA                                                    CLE040
                                                                                              CLE040
     C                   EXSR      SrHeader                                                   CLE040
     C                   EVAL      WParamName = 'FacCustNo'                                   CLE040
     C                   EVAL      WParamValue = *BLANKS                                      CLE040
     C                   MOVEL     L5_F1FCCU     WParamValue                                  CLE040
     C                   EXSR      SrDetail                                                   CLE040
     C                   EVAL      WDtl1 = WDetail                                            CLE040
     C                   EVAL      WParamName = 'FacType'                                     CLE040
     C                   EVAL      WParamValue = *BLANKS                                      CLE040
     C                   MOVEL     L5_F1FACT     WParamValue                                  CLE040
     C                   EXSR      SrDetail                                                   CLE040
     C                   EVAL      WDtl2 = WDetail                                            CLE040
     C                   EVAL      WParamName = 'FacSeqNo'                                    CLE040
     C                   EVAL      WParamValue = *BLANKS                                      CLE040
     C                   MOVEL     L5_F1FCNO     WParamValue                                  CLE040
     C                   EXSR      SrDetail                                                   CLE040
     C                   EVAL      WDtl3 = WDetail                                            CLE040
     C                   EVAL      WParamName = 'FacBrch'                                     CLE040
     C                   EVAL      WParamValue = *BLANKS                                      CLE040
     C                   MOVEL     FacBrch       WParamValue                                  CLE040
     C                   EXSR      SrDetail                                                   CLE040
     C                   EVAL      WDtl4 = WDetail                                            CLE040
                                                                                              CLE040
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)                     CLE040
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)                     CLE040
     C                                      + %TRIM(WDtl4) + ConstFoot                        CLE040
                                                                                              CLE040
     C                   ENDIF                                                                CLE040
                                                                                              CLE040
     C                   ENDSR                                                                CLE040
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrHeader - Header Processing                                 *
      *****************************************************************
     C     SrHeader      BEGSR
 
     C                   EVAL      WHeader = ConstHead1 + ConstHead2 +
     C                                       ConstHead3 + ConstHead4 +
     C                                       ConstHead5 + %TRIM(WEvntTyp)
     C                                       + ConstHead6
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrDetail - Detail Processing                                 *
      *****************************************************************
     C     SrDetail      BEGSR
 
     C                   EVAL      WDetail = ConstDet1 + %TRIM(WParamName)
     C                                       + ConstDet2 + %TRIM(WParamValue)
     C                                       + ConstDet3
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrReset - Initialise variables                               *
      *****************************************************************
     C     SrReset       BEGSR
 
     C                   EVAL      WBeforeAfter = *BLANKS
     C                   EVAL      WDtl1 = *BLANKS
     C                   EVAL      WDtl2 = *BLANKS
     C                   EVAL      WDtl3 = *BLANKS
     C                   EVAL      WDtl4 = *BLANKS
     C                   EVAL      WDtl5 = *BLANKS
     C                   EVAL      WDtl6 = *BLANKS
     C                   EVAL      WFldChg1 = *BLANKS
     C                   EVAL      WFldChg2 = *BLANKS
     C                   EVAL      WFldChg3 = *BLANKS
     C                   EVAL      WFldChg4 = *BLANKS
     C                   EVAL      WFldChg5 = *BLANKS
     C                   EVAL      WFldChg6 = *BLANKS
     C                   EVAL      WFldChg7 = *BLANKS
     C                   EVAL      WFldChg8 = *BLANKS
     C                   EVAL      WFldChg9 = *BLANKS
     C                   EVAL      WFldChg10 = *BLANKS
     C                   EVAL      WFldChg11 = *BLANKS
     C                   EVAL      WFldChg12 = *BLANKS
     C                   EVAL      WFldChg13 = *BLANKS
     C                   EVAL      WFldChg14 = *BLANKS
     C                   EVAL      WFldChg15 = *BLANKS
     C                   EVAL      WFldChg16 = *BLANKS
     C                   EVAL      WFldChg17 = *BLANKS
     C                   EVAL      WFldChg18 = *BLANKS
     C                   EVAL      WFldChg19 = *BLANKS
     C                   EVAL      WFldChg20 = *BLANKS
     C                   EVAL      WFldChg21 = *BLANKS
     C                   EVAL      WFldChg22 = *BLANKS
     C                   EVAL      WFldChg23 = *BLANKS
     C                   EVAL      WFldChg24 = *BLANKS
     C                   EVAL      WFldChg25 = *BLANKS
     C                   EVAL      WFldChg26 = *BLANKS
     C                   EVAL      WFldChg27 = *BLANKS
     C                   EVAL      WFldChg28 = *BLANKS
     C                   EVAL      WFldChg29 = *BLANKS
     C                   EVAL      WFldChg30 = *BLANKS
     C                   EVAL      WFldChg31 = *BLANKS
     C                   EVAL      WFldChg32 = *BLANKS
     C                   EVAL      WFldChg33 = *BLANKS
     C                   EVAL      WFldChg34 = *BLANKS
     C                   EVAL      WFldChg35 = *BLANKS
     C                   EVAL      WFldChg36 = *BLANKS
     C                   EVAL      WFldChg37 = *BLANKS                                      BUG11673
     C                   EVAL      WEvntTyp = *BLANKS
     C                   EVAL      WParamName = *BLANKS
     C                   EVAL      WParamValue = *BLANKS
     C                   EVAL      Buffer = *BLANKS
     C                   EVAL      KDlNo  = *BLANKS                                           CLE040
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSendDtaQ - Send Buffer to the data queue                   *
      *****************************************************************
     C     SrSendDtaQ    BEGSR
                                                                                             BUG3644
      ** Find the first non-blank position starting from the right                           BUG3644
      ** Result field would contain the position relative to the left                        BUG3644
                                                                                             BUG3644
     C     ' '           CHECKR    BUFFER        WLength                                     BUG3644
 
     C                   CALL      'QSNDDTAQ'                           7070
     C                   PARM      'CLECALCMGR'  DtqNam
     C                   PARM                    DtqLib
     C                   PARM      WLength       DtqLen                                      BUG3644
     C**********         PARM      600           DtqLen                              BUG3824 BUG3644
     C*******************PARM      6000          DtqLen                                      BUG3824
     C                   PARM                    Buffer
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                      BUG3644
      * FNDBRCA - Get the branch from facilities file.                *                      BUG3644
      *****************************************************************                      BUG3644
     C     FNDBRCA       BEGSR                                                               BUG3644
                                                                                             BUG3644
     C     FBRCH         CHAIN     FCLTYFMF                                                  BUG3644
     C                   EVAL      FacBrch = BRCA                                            BUG3644
     C                   ENDSR                                                               BUG3644
      *****************************************************************                      BUG3644
      /EJECT                                                                                 BUG3644
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
 
      ** Read in data areas
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        RUNDAT
     C                   IN        SDSTAT
 
      ** Set Date Format Indicator *IN98 on if date format is MMDDYY
 
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
                                                                                             BUG3644
     C     FBRCH         KLIST                                                               BUG3644
     C                   KFLD                    CNUM                                        BUG3644
     C                   KFLD                    FACT                                        BUG3644
     C                   KFLD                    FCNO                                        BUG3644
                                                                                              CLE040
     C     *LIKE         DEFINE    L5_F1DLNO     KDlNo                                        CLE040
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
