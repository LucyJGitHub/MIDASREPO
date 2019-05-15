     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Initialization Program for CER034')           *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL000070 - Midas DL Initialisation program for CER020        *
      *                                                               *
      *  Function:  This module will initialise 'Initial Start Date', *
      *             'Final Maturity Date' and 'Original Deal Number'  *
      *             fields on MMDELDPP & DEALSDC                      *
      *                                                               *
      *  Component of: DLC00070                                       *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22611           Date 09Feb09               *
      *                 CER020  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22611 - German Features initialization pgm error          *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *                                                               *
      *****************************************************************
      *
      ** Midas MM Deals File
     FMMDEALLL  UF   E           K DISK    INCLUDE(MMDELDP0)
     F                                     INFSR(*PSSR)
     F**********                           COMMIT                                           BUG22611
      *
      ** Deals File
     FDEALS     UF   E           K DISK    INCLUDE(DEALSDCF)
     F                                     INFSR(*PSSR)
     F**********                           COMMIT                                           BUG22611
      *
      ** Midas MM Deals File by Original Deal No. and Maturity Date
     FMMDELDL10 UF   E           K DISK    RENAME(MMDELDP0:MMDELOrg)
     F                                     INFSR(*PSSR)
     F**********                           COMMIT                                           BUG22611
      *
      ** Deals File  by Original Deal No. and Maturity Date
     FDEALSL30  UF   E           K DISK    RENAME(DEALSDCF:DEALSDCOrg)
     F                                     INFSR(*PSSR)
     F**********                           COMMIT                                           BUG22611
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      *
      ** Data Structure for bank details
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  ErrOnFile             02     02
      *
      ** Data Structure for Value Date
     D DSValDate       DS
     D  HKVDYY                 1      4  0
     D  HKVDMM                 5      6  0
     D  HKVDDD                 7      8  0
      *
      ** Data Structure for Maturity Date
     D DSMatDate       DS
     D  HKMDYY                 1      4  0
     D  HKMDMM                 5      6  0
     D  HKMDDD                 7      8  0
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      *
     D WUpdateFlag     S              1A
     D PDateIn         S              8S 0
     D PDateOut        S              5P 0
     D WValDate        S              8A
     D WValDt          S              5S 0
     D WDealNum        S              6S 0
     D WDLNO           S              6S 0
     D WDealTmp        S              6A
     D WTDadn          S              6S 0
     D WFinMatDat      S              5P 0
     D WOriginalDeal   S              6A
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ *inzsr is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN - Main processing                                        *
      *****************************************************************
      *
      ** Initialize Initial Start Date, Final Maturity Date & Original
      ** Deal Number
      *
     C                   EXSR      SrInitMMFlds
     C                   EXSR      SrInitDLFlds
      *
      ** Program Termination
      *
     C                   EVAL      *INLR = TRUE
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInitMMFlds - Initialize Initial Start Date, Final Maturity *
      *                 Date and Original Deal Number of MMDELDPP     *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRPopOrgMM, SRPopFMDTM, SRZDATE10                     *
      *                                                               *
      *****************************************************************
     C     SrInitMMFlds  BEGSR
      *
      ** Read MM Deals File
      *
     C     *LOVAL        SETLL     MMDELDP0
     C                   READ      MMDELDP0                               01
      *
     C                   DOW       EndOfFile = False
     C                   EVAL      WUpdateFlag  = 'N'
      *
      ** Populate Original Deal Number
      *
     C                   IF        HKORDN = *BLANKS
      *
     C                   IF        HKDADN = *BLANKS
      *
     C                   MOVEL     HKDN38        HKORDN
     C                   EVAL      WValDate = DSValDate
     C                   ELSE
      *
     C                   EVAL      WOriginalDeal = *BLANKS
     C                   EVAL      WDLNO = HKDN38
     C                   EXSR      SRPopOrgMM
      *
     C     WDLNO         CHAIN     MMDELDP0
     C                   EVAL      HKORDN = WOriginalDeal
      *
     C                   ENDIF
      *
     C                   EVAL      WUpdateFlag  = 'Y'
      *
     C                   ENDIF
      *
      ** Populate Initial Start Date
      *
     C                   IF        HKISDT = *ZEROS
     C                   MOVEL     WValDate      PDateIn
      *
      ** Convert date from YYYYMMDD to Midas Day Number
      *
     C                   EXSR      SRZDATE10
     C                   EVAL      HKISDT = PDateOut
     C                   EVAL      WUpdateFlag = 'Y'
      *
     C                   ENDIF
      *
      ** Update MM Deal Record
      *
     C                   IF        WUpdateFlag = 'Y'
     C                   UPDATE    MMDELDP0
     C                   ENDIF
      *
     C                   READ      MMDELDP0                               01
     C                   ENDDO
      *
      ** Populate Final Maturity Date
      *
     C                   EXSR      SRPopFMDTM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopOrgMM - Populate Original Deal Number                   *
      *                                                               *
      *  Called by: SrInitMMFlds                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPopOrgMM    BEGSR
      *
     C                   DOW       WOriginalDeal = *BLANKS
      *
     C                   MOVEL     HKDADN        WTDadn
     C     WTDadn        CHAIN     MMDELDP0
      *
     C                   IF        NOT %FOUND()
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        HKORDN <> *BLANKS
      *
     C                   EVAL      WOriginalDeal = HKORDN
     C                   EVAL      WValDate = DSValDate
     C                   LEAVE
      *
     C                   ENDIF
      *
     C                   IF        HKDADN = *BLANKS
      *
     C                   MOVEL     HKDN38        WOriginalDeal
     C                   EVAL      WValDate = DSValDate
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopFMDTM - Populate Final Maturity Date                    *
      *                                                               *
      *  Called by: SrInitMMFlds                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPopFMDTM    BEGSR
      *
     C     *LOVAL        SETLL     MMDELDL10
     C                   READ      MMDELDL10                              01
      *
     C                   DOW       EndOfFile = False
      *
      ** Populate Largest Maturity Date and Original Deal of the set
      *
     C                   MOVEL     HKORDN        WDealTmp
     C                   EVAL      WFinMatDat = HKMATD
      *
      ** Process all records with same Original Deal Number
      *
     C                   DOW       WDealTmp = HKORDN
      *
     C                   IF        HKFMDT = *ZEROS
     C                   EVAL      HKFMDT = WFinMatDat
     C                   UPDATE    MMDELOrg
     C                   ENDIF
      *
     C                   READ      MMDELDL10                              01
      *
     C                   IF        EndOfFile = True
     C                   EVAL      HKORDN = *BLANKS
     C                   ENDIF
      *
     C                   IF        WDealTmp <> HKORDN
      *
     C                   READP     MMDELDL10                              01
      *
     C                   IF        HKFMDT = *ZEROS
     C                   EVAL      HKFMDT = WFinMatDat
     C                   UPDATE    MMDELOrg
     C                   ENDIF
      *
     C                   LEAVE
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   READ      MMDELDL10                              01
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitDLFlds - Initialize Initial Start Date, Final Maturity *
      *                 Date and Original Deal Number of DEALSDC      *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRPopOrgDl, SRPopFMDTD                                *
      *                                                               *
      *****************************************************************
     C     SRInitDLFlds  BEGSR
      *
      ** Read details file
      *
     C     *LOVAL        SETLL     DEALSDCF
     C                   READ      DEALSDCF                               01
      *
     C                   DOW       EndOfFile = False
     C                   EVAL      WUpdateFlag  = 'N'
      *
      ** Populate Original Deal Number
      *
     C                   IF        ORDN = *ZEROS
      *
     C                   IF        RODN = *ZEROS
      *
     C                   EVAL      ORDN = DLNO
     C                   EVAL      WValDt = VDAT
     C                   ELSE
      *
     C                   EVAL      WOriginalDeal = *BLANKS
     C                   EVAL      WDLNO = DLNO
     C                   EXSR      SRPopOrgDl
      *
     C     WDLNO         CHAIN     DEALSDCF
     C                   MOVEL     WOriginalDeal ORDN
      *
     C                   ENDIF
      *
     C                   EVAL      WUpdateFlag  = 'Y'
      *
     C                   ENDIF
      *
      ** Populate Initial Start Date
      *
     C                   IF        ISDT = *ZEROS
     C                   EVAL      ISDT = WValDt
     C                   EVAL      WUpdateFlag  = 'Y'
     C                   ENDIF
      *
      ** Update Deal Record
      *
     C                   IF        WUpdateFlag = 'Y'
     C                   UPDATE    DEALSDCF
     C                   ENDIF
      *
     C                   READ      DEALSDCF                               01
      *
     C                   ENDDO
      *
      ** Populate Final Maturity Date
      *
     C                   EXSR      SRPopFMDTD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopOrgDL - Populate Original Deal Number                   *
      *                                                               *
      *  Called by: SrInitMMFlds                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPopOrgDL    BEGSR
      *
     C                   DOW       WOriginalDeal = *BLANKS
      *
     C     RODN          CHAIN     DEALSDCF
      *
     C                   IF        NOT %FOUND
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        ORDN <> *ZEROS
      *
     C                   MOVEL     ORDN          WOriginalDeal
     C                   EVAL      WValDt = VDAT
     C                   LEAVE
      *
     C                   ENDIF
      *
     C                   IF        RODN = *ZEROS
      *
     C                   MOVEL     DLNO          WOriginalDeal
     C                   EVAL      WValDt = VDAT
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopFMDTD - Populate Final Maturity Date                    *
      *                                                               *
      *  Called by: SrInitMMFlds                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPopFMDTD    BEGSR
      *
     C     *LOVAL        SETLL     DEALSL30
     C                   READ      DEALSL30                               01
      *
     C                   DOW       EndOfFile = False
      *
      ** Populate Largest Maturity Date and Original Deal of the set
      *
     C                   MOVEL     ORDN          WDealNum
     C                   EVAL      WFinMatDat = MDAT
      *
      ** Process all records with same Original Deal Number
      *
     C                   DOW       WDealNum = ORDN
      *
     C                   IF        FMDT = *ZEROS
     C                   EVAL      FMDT = WFinMatDat
     C                   UPDATE    DEALSDCOrg
     C                   ENDIF
      *
     C                   READ      DEALSL30                               01
      *
     C                   IF        EndOfFile = True
     C                   EVAL      ORDN = *ZEROS
     C                   ENDIF
      *
     C                   IF        WDealNum <> ORDN
      *
     C                   READP     DEALSL30                               01
      *
     C                   IF        FMDT = *ZEROS
     C                   EVAL      FMDT = WFinMatDat
     C                   UPDATE    DEALSDCOrg
     C                   ENDIF
      *
     C                   LEAVE
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   READ      DEALSL30                               01
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDATE10 - Convert date from YYYYMMDD to Midas Day Number   *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRZDATE10     BEGSR
      *
      ** Call ZDATE10
      *
     C                   CALLB     'ZDATE10'
     C                   PARM                    PDateIn
     C                   PARM                    PDateOut
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
