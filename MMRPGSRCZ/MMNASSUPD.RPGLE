     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs sold DL database update')                 *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMNASSUPD - NAS SOLD DL DATABASE UPDATE                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD025244           Date 09May14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9711            Date 26Jan06               *
      *                 CAS009             Date 16May05               *
      *                 CAP086             Date 08Jun05               *
      *                 CGL014             Date 20Oct03               *
      *                 NAD002             Date 26Mar04               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209895             Date 14Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 155792             Date 03Oct00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  MD025244 - Added parameter in calling ZADLTRLRUD.            *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9711- Changes to MMVNASPPD/MMVNASSPD (re-compile)         *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  NAD002 - 10-Digit Account Code Errors                        *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  209895 - No confirmation generated during amend if BLL2II    *
      *           is "Y" and settlement instructions are blanks. Make *
      *           sure that CNRQ is "Y" after settlement instructions *
      *           have been changed to certain values.                *
      *  155792 - Check other amended fields relevant for generation  *
      *           of an amended confirmation.  And default workfield  *
      *           @@CNRQ to 'N' to prevent a blank CNRQ in DTRIXDD.   *
      *  CDL008 - Continuous Linked Settlement (recompile DEALSDB)    *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FMMDELULL  UF A E           K DISK
     F                                     COMMIT
     F                                     INCLUDE(DEALSDDF :
     F                                             DEALSDEF :
     F                                             DEALSDFF)
     FSDTIX     UF A E           K DISK
     F                                     COMMIT
     F                                     PREFIX(DX)
                                                                                              CRE020
     FREADVCL1  UF   E           K DISK    COMMIT                                             CRE020
     F                                     USROPN                                             CRE020
      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref                            CRE020
                                                                                              CRE020
     F/COPY WNCPYSRC,MMNASSDF01
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID NAS SOLD
     D MMVNAS        E DS                  EXTNAME(MMVNASSPD)
     D  @MMREC               314    382
     D**@MMRECEx            1091   1108                                                CGL029 NAD002
      *
      **  DEALS FILE - NAS SOLD
     D DEALS         E DS                  EXTNAME(DEALSDE)
     D  @DLREC               409    477
     D**@DLRECEx            1066   1083                                                CGL029 NAD002
      *
      **  Time data structure for DTRIX.
     D                 DS
     D  @XTIME                 1      6  0
     D  DXTIM                  1      4  0
                                                                                              CRE020
      ** Define fields used in CRE020                                                         CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KPrgMn          S             10A   INZ('MMNASSUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('NAsSold             ')                        CRE020
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
     D PRtCd           S              7A                                                      CRE020
     D POptn           S              7A                                                      CRE020
     D PSARD           S              6A                                                      CRE020
     D WSysVal01       S              1A                                                      CRE020
     D WNew            S              1A                                                      CRE020
      *
      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** DATA STRUCTURE FOR BANK DETAILS
 
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ** External DS for TRADE Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE020
     D  SCLCD        E                     EXTFLD(LCD)                                        CRE020
      ** External DS for Switchable Feature Details                                           CRE020
                                                                                              CRE020
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ I-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     IDEALSDDF
     I              MDAT                        PUMDAT
     I              PUPR                        PUPUPR
     I              PCLI                        PUPCLI
     I              PSZE                        PUPSZE
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
      *
      * EXIT IF NOT INSERTION, AMENDMENT OR REVERSAL
      *
     C     ILCHTP        IFNE      'I'
     C     ILCHTP        ANDNE     'A'
     C     ILCHTP        ANDNE     'R'
     C                   RETURN
     C                   END
      *
      * INSERT, AMEND, OR REVERSE THE DEAL
      *
     C     ILCHTP        CASEQ     'I'           NASINS
     C     ILCHTP        CASEQ     'A'           NASAMD
     C     ILCHTP        CASEQ     'R'           NASDEL
     C                   END
      *
      * SET PAY/RECEIVE INDICATORS TO BE WRITTEN TO DTRIX
      *
     C                   EXSR      PYRCIN
      *
      * WRITE A DTRIX RECORD
      *
     C                   EXSR      WRTDTX
      *
      * UPDATE THE DTRIX HEADER RECORD
      *
     C                   EXSR      UPDDTH
      *
      ** UPDATE THE DEALS FILE TRAILER
      ** ON INSERTS AND REVERSALS
      *
     C     ILCHTP        IFEQ      'I'
     C     ILCHTP        OREQ      'R'
     C                   EXSR      UPDTRL
     C                   END
      *
      * EXIT FROM PROGRAM
      *
     C                   RETURN
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* NASINS - INSERT AN NA SOLD                                   *
     C*                                                              *
     C****************************************************************
     C     NASINS        BEGSR
      *
      ** ACCESS RELATED NA BOUGHT
      *
     C                   MOVE      ILDADN        DLNO
     C     DLNO          CHAIN     DEALSDDF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     DLNO          DBKEY
     C                   MOVEL     'DEALSDD '    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** If parcelled, update number of sold N/A on NA bought
      *
     C     ILPCLI        IFEQ      'P'
     C                   ADD       ILPSZE        NSLD
     C                   SUB       ILPSZE        NSDD
     C                   ELSE
      *
      ** Else, update sale price, sale deal number, and sale value date
      *
     C                   Z-ADD     ILAMNP        SAPR
     C                   Z-ADD     ILDN38        ASDN
     C                   Z-ADD     ILDVSD        SADT
     C                   END
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'A'           CHTP
      *
      ** UPDATE NA BOUGHT
      *
     C                   UPDATE    DEALSDDF
      *
      * SET CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX
      *
     C                   EXSR      CNFINS
      *
      * INITIALIZE DEAL
      *
     C                   CLEAR                   DEALS
      *
      * RECORD ID
      *
     C                   MOVEL     'D'           RECI
      *
      * DEAL NUMBER & RECORD TYPE
      *
     C                   Z-ADD     ILDN38        DLNO
     C                   MOVE      'E'           RCDT
      *
      * DEAL RECORD CODE
      *
     C                   Z-ADD     18            RCDC
      *
      *  SOLD TO CUSTOMER
      *
     C**********         Z-ADD     ILCNUM        SCUS                                         CSD027
     C                   EVAL      SCUS = ILCNUM                                              CSD027
      *
      * BRANCH
     C                   MOVEL     ILBRCA        BRCA
      *
      * DEAL TYPE
     C                   MOVE      ILMTYP        DTYP
      *
      * DEAL SUB-TYPE
     C                   MOVE      ILSTYP        DLST
      *
      * DEAL DATE
     C                   Z-ADD     ILDDND        DDAT
      *
      * VALUE DATE
     C                   Z-ADD     ILDVSD        VDAT
      *
      * BROKER CODE
     C                   MOVE      ILBKCD        BRKC
      *
      * BROKERAGE
     C     ILBRKG        IFEQ      *ALL'9'
     C                   Z-ADD     0             BAGE
     C                   ELSE
     C                   Z-ADD     ILBRKG        BAGE
     C                   END
      *
      * CURRENCY
     C                   MOVE      ILCCY         CCY
      *
      * SALE PRICE
      *
     C     ILAMNP        IFLT      *ZERO
     C                   Z-SUB     ILAMNP        SAPR
     C                   ELSE
     C                   Z-ADD     ILAMNP        SAPR
     C                   END
      *
      * YIELD RATE
     C                   Z-ADD     ILINTR        YRAT
      *
      * INTEREST RATE
     C                   Z-ADD     ILFRAT        INTR
      *
      * REF.NO. OF NA
     C                   MOVE      ILCDRF        RNNA
      *
      * ISSUER
     C**********         Z-ADD     ILISCN        ISCN                                         CSD027
     C                   EVAL      ISCN = ILISCN                                              CSD027
      *
      * FACE VALUE
     C                   Z-ADD     ILFVAL        FVAL
      *
      * BASE CCY EXCHANGE RATE
     C                   Z-ADD     ILBRAT        BCXR
      *
      * ACCESS DEAL CURRENCY DETAILS
      *
     C                   EXSR      ACSDCY
      *
      * LIMIT CCY EXCHANGE RATE
     C                   Z-ADD     A6ERLC        LCXR
      *
      * SETTLEMENT INSTRUCTIONS
      *
     C                   Z-ADD     ILORCM        SETP
     C                   MOVE      ILMORI        OSAC
     C                   MOVE      ILMCPI        TSEN
      *
      * ORIGINATING BRANCH
     C                   MOVEL     ILORBR        ORBR
      *
      * OUR REC SETTLEMENT BRANCH
     C                   MOVEL     ILROBR        ROBR
      *
      * PROFIT CENTRE
     C                   MOVEL     ILPRFC        PRFC
      *
      ** RELATED DEAL NUMBER
     C                   MOVE      ILDADN        RPDN
      *
      ** RELATED MATURITY DATE
     C                   Z-ADD     PUMDAT        PMDT
      *
      ** INITIALIZE BITS for static and non static indicators.
      *
     C                   BITOFF    '01234567'    DNSI
     C                   BITOFF    '01234567'    DSTI
     C                   BITOFF    '01234567'    CNFI
     C                   BITOFF    '01234567'    ACEI
     C                   BITOFF    '01234567'    TLXI
      *
      * STATIC BIT = BROKERAGE IS ZERO WITH BROKER
      *
     C     ILBKCD        IFNE      'TELX'
     C     ILBKCD        ANDNE     'MAIL'
     C     ILBKCD        ANDNE     'PHON'
     C     ILBKCD        ANDNE     *BLANK
     C     ILBRKG        IFEQ      *ALL'9'
     C                   BITON     '0'           DSTI
     C                   END
     C                   END
      *
      * STATIC BIT = FEDERAL FUNDS
      *
     C     ILFEDF        IFEQ      'Y'
     C     ILCCY         ANDEQ     BLUSCY
     C                   BITON     '2'           DSTI
     C                   END
      *
      * LAST SWIFT SEQUENCES
      *
     C                   Z-ADD     *ZERO         LSWC
     C                   Z-ADD     *ZERO         LSWS
      *
      * ORIGINAL ENTRY DATE, LAST CHANGE DATE & LAST CHANGE TYPE
      *
     C                   Z-ADD     BJRDNB        ORED
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      ILCHTP        CHTP
     C                   Z-ADD     *ZERO         TNLU
      *
      ** BOOK CODE
     C                   MOVE      ILBOKC        BOKC
      *
      ** LINKED DEAL NUMBER
     C                   MOVE      ILLNKN        LNKDN
      *
      * RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @MMREC        @DLREC
     C                   MOVEL     ILRONS        RONS                                         NAD002
     C**********         MOVEL     @MMRECEx      @DLRECEx                              CGL029 NAD002
      *
      ** If NA is parcelled, set up parcel fields
      *
     C     ILPCLI        IFEQ      'P'
     C                   MOVE      'P'           PCLI
     C                   Z-ADD     ILPSZE        PSZE
     C                   Z-ADD     PUPUPR        PUPR
     C                   DIV       PUPSZE        PUPR
     C                   MULT      ILPSZE        PUPR
     C                   ELSE
     C                   MOVE      ' '           PCLI
     C                   Z-ADD     0             PSZE
     C                   Z-ADD     PUPUPR        PUPR
     C                   END
      *
      ** EMU Settlement fields
      *
     C                   MOVEL     ILSTCY        STCY
      *
      * WRITE NA SOLD DEAL
      *
     C                   WRITE     DEALSDEF
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C/COPY WNCPYSRC,MMNASSDC02
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* NASAMD - AMEND AN NA SOLD                                    *
     C*                                                              *
     C****************************************************************
     C     NASAMD        BEGSR
      *
      * ACCESS DEAL
      *
     C     ILDN38        CHAIN     DEALSDEF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     ILDN38        DBKEY
     C                   MOVEL     'DEALSDE '    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      * SET CONFIRMATION BIT ON DEAL
      * AND CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX
      *
     C                   EXSR      CNFAMD
      *
      * SOLD TO CUSTOMER
     C**********         Z-ADD     ILCNUM        SCUS                                         CSD027
     C                   EVAL      SCUS = ILCNUM                                              CSD027
      *
      * DEAL SUB-TYPE
     C                   MOVE      ILSTYP        DLST
      *
      * BROKER CODE
     C                   MOVE      ILBKCD        BRKC
      *
      * BROKERAGE
     C     ILBRKG        IFEQ      *ALL'9'
     C                   Z-ADD     0             BAGE
     C                   ELSE
     C                   Z-ADD     ILBRKG        BAGE
     C                   END
      *
      * SETTLEMENT INSTRUCTIONS
      *
     C                   Z-ADD     ILORCM        SETP
     C                   MOVE      ILMORI        OSAC
     C                   MOVE      ILMCPI        TSEN
      *
      * STATIC BIT = FEDERAL FUNDS
      *
     C     ILFEDF        IFEQ      'Y'
     C     ILCCY         ANDEQ     BLUSCY
     C                   BITON     '2'           DSTI
     C                   ELSE
     C                   BITOFF    '2'           DSTI
     C                   END
      *
      * LAST CHANGE DATE & LAST CHANGE TYPE
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      ILCHTP        CHTP
     C                   Z-ADD     *ZERO         TNLU
      *
      ** BOOK CODE
     C                   MOVE      ILBOKC        BOKC
      *
      ** LINKED DEAL NUMBER
     C                   MOVE      ILLNKN        LNKDN
      *
      * RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @MMREC        @DLREC
     C                   MOVEL     ILRONS        RONS                                         NAD002
     C**********         MOVEL     @MMRECEx      @DLRECEx                              CGL029 NAD002
      *
      * ORIGINATING BRANCH
     C                   MOVEL     ILORBR        ORBR
      *
      * PROFIT CENTRE
     C                   MOVEL     ILPRFC        PRFC
      *
      * OUR REC SETTLEMENT BRANCH
      *
     C                   MOVEL     ILROBR        ROBR
      *
      * EMU Settlement fields
      *
     C                   MOVEL     ILSTCY        STCY
      *
      * UPDATE DEAL
      *
     C                   UPDATE    DEALSDEF
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C/COPY WNCPYSRC,MMNASSDC03
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* NASDEL - DELETE AN NA SOLD                                   *
     C*                                                              *
     C****************************************************************
     C     NASDEL        BEGSR
      *
      * ACCESS DEAL
      *
     C     ILDN38        CHAIN     DEALSDEF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     ILDN38        DBKEY
     C                   MOVEL     'DEALSDE '    DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 003*
     C                   EXSR      SRERR                                        ************
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
     C                   UPDATE    DEALSDEF
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      *
      ** ACCESS RELATED NA BOUGHT
      *
     C                   MOVE      ILDADN        DLNO
     C     DLNO          CHAIN     DEALSDDF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     DLNO          DBKEY
     C                   MOVEL     'DEALSDD '    DBFILE                         ************
     C                   MOVEL     '004'         DBASE                          * DBERR 004*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** If parcelled, update number of sold N/A on NA bought
      *
     C     PCLI          IFEQ      'P'
     C                   SUB       PSZE          NSLD
     C                   ADD       PSZE          NSDD
     C                   ELSE
      *
      ** Else, update sale price, sale deal number, and sale value date
      *
     C                   Z-ADD     *ZERO         SAPR
     C                   Z-ADD     *ZERO         ASDN
     C                   Z-ADD     *ZERO         SADT
     C                   END
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'A'           CHTP
      *
      ** UPDATE NA BOUGHT
      *
     C                   UPDATE    DEALSDDF
     C/COPY WNCPYSRC,MMNASSDC04
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
      *
      ** PAY/RECEIVE INDICATOR 3 = VALUE DATE OF NA SOLD
      *  -----------------------------------------------
      *
      ** Determine if local or deal currency to be used
      ** in holiday checking
      *
     C                   MOVEL     'L'           @DLOLC
     C                   MOVEL     *BLANK        @NOSTR
      *
     C     ILRSTM        IFEQ      01
     C     ILRSTM        OREQ      07
     C     ILRSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     ILRONS        @NOSTR
     C                   END
      *
      ** DETERMINE TELEX DUE DATE
      *
     C                   EXSR      TLXDUE
      *
      * Set PRI3 if value date is within telex notice period
      *
     C     ILDVSD        IFGE      BJRDNB
     C     ILDVSD        ANDLE     @TLXDU
     C/COPY WNCPYSRC,MMNASSDC01
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
     C     ILRSTM        IFNE      *ZERO
     C     BLL2II        OREQ      'N'
     C                   MOVE      'Y'           @@CNRQ
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFAMD - SET CONFIRMATION INDICATOR ON AMENDMENT             *
     C*                                                              *
     C****************************************************************
     C     CNFAMD        BEGSR
      *                                                                                       155792
     C                   MOVE      'N'           @@CNRQ                                       155792
      *
      * IF SETTLEMENT INSTRUCTIONS WERE PREVIOUSLY PRESENT
      * OR IF 2 LEVEL INPUT NOT PRESENT
      *
     C     RSTM          IFNE      *ZERO
     C     ILRSTM        ORNE      *ZERO                                                      209895
     C     BLL2II        OREQ      'N'
      *
      ** If settlement instruction fields have changed
      *
     C     RSTM          IFNE      ILRSTM
     C     RONS          ORNE      ILRONS
     C     RIBN          ORNE      ILRIBN
     C     RIBA          ORNE      ILRIBA                                                     155792
     C     ROBN          ORNE      ILROBN                                                     155792
     C     ROCN          ORNE      ILROCN                                                     155792
     C     STCY          ORNE      ILSTCY                                                     155792
     C     IC72          ORNE      ILIC72                                                     155792
      *
      ** Produce a confirmation now
      *
     C                   BITOFF    '0'           CNFI
     C                   MOVE      'Y'           @@CNRQ
      *
     C                   END
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFDEL - SET CONFIRMATION INDICATOR ON DELETION              *
     C*                                                              *
     C****************************************************************
     C     CNFDEL        BEGSR
      *                                                                                       155792
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
     C                   Z-ADD     ILDN38        DXDLNO
     C                   Z-ADD     *ZERO         DXVDAT
     C                   Z-ADD     *ZERO         DXDASN
     C                   MOVE      ILCHTP        DXCHTP
     C                   MOVE      @@CNRQ        DXCNRQ
     C                   MOVE      'N'           DXCNPR
     C                   MOVE      ' '           DXREPR
     C                   TIME                    @XTIME
     C                   MOVE      @@PRI1        DXPRI1
     C                   MOVE      @@PRI2        DXPRI2
     C                   MOVE      @@PRI3        DXPRI3
     C                   Z-ADD     0             DXICIN
     C                   MOVEL     ILBRCA        DXBRCA
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
     C     DXDLNO        CHAIN     DTRIXHF                            99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     DXDLNO        DBKEY
     C                   MOVEL     'DTRIXHF '    DBFILE                         ************
     C                   MOVEL     '005'         DBASE                          * DBERR 005*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      * Add 1 to number of deal records (on DTRIXDD)
      *
     C                   ADD       1             DXNDLR
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
     C                   PARM      ILCHTP        @@CHTP            1
      *
      ** Amount
     C                   PARM      ILAMNP        @@AMNP           15 0
      *
      ** Run Date
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    EAPIC                                      MD025244
      *
      ** DATABASE ERROR
      *
     C     @@RTCD        IFEQ      '*ERROR '
     C                   MOVEL     '999999'      DBKEY
     C                   MOVEL     'DEALSDF '    DBFILE                         ************
     C                   MOVEL     '006'         DBASE                          * DBERR 006*
     C                   EXSR      SRERR                                        ************
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
      * EFFECTIVE SETTLEMENT CURRENCY
      *
     C     ILSTCY        IFNE      *BLANKS
     C                   MOVEL     ILSTCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     ILCCY         EffSetCcy         3
     C                   ENDIF
      *
     C                   CALLB     'ZATLXDUEDT'
      *
      ** Deal or local Currency
     C                   PARM                    @DLOLC            1
      *
      ** Currency
     C                   PARM      EffSetCcy     @CCY              3
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
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* ACSDCY - ACCESS DEAL CURRENCY DETAILS                        *
     C*                                                              *
     C****************************************************************
     C     ACSDCY        BEGSR
      *
      ** Access currency details using deal currency.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      ILCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @AJCD         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '007'         DBASE                          * DBERR 007*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   ENDSR
     C****************************************************************
      /EJECT                                                                                  CRE020
      *****************************************************************                       CRE020
      *                                                               *                       CRE020
      *  SRIdxTrn - Handles the advice index of the current           *                       CRE020
      *             transaction.                                      *                       CRE020
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
      ** Delete the advice index if the current record is a new deal.                         CRE020
      ** Reverse it otherwise.                                                                CRE020
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
      *****************************************************************                       CRE020
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
     C                   PARM                    MMVNAS
                                                                                              CRE020
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
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
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      SRERR                                        *************
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
     C                   MOVEL     'SDTRADPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      SRERR                                        *************
     C                   END
                                                                                              CRE020
      ** Check if CRE020 is enabled.                                                          CRE020
                                                                                              CRE020
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
     C                   EVAL      DBase = 902                                                CRE020
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
     C                   EVAL      DBase = 903                                                CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
     C*
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
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
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'MMNASSUPD'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
     C/EJECT
     C****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
