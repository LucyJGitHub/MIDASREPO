     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
     F*****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL FX netted deals EM extract')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Dealing                                              *
     F*                                                               *
     F*  DL0403  -  Netted Deals EM Extract                           *
     F*                                                               *
     F*  Function:  This program writes exposure management records   *
     F*  (COB)      for FX Netting Records.                           *
     F*                                                               *
     F*  Called By: DLC0607NT - EM Update for FX Netting Deals Control*
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 126894             Date 01Dec97               *
      *                 CDL002             Date 07May97               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
     F*  126894 - Relocate Access Object to prevent Database Error    *
     F*  CDL002 - Created for Netted Deals EM Extract                 *
     F*                                                               *
     F*****************************************************************
     F*
     F* Netted Deals
     FFXNETML1  IF   E             DISK    INFSR(*PSSR)
     F*
     F* Net Events
     FFXNEVTPD  O    E             DISK    INFSR(*PSSR)
     F*
     F* Dealing Exposure Extract
     FEMXT2D2   O    E             DISK    INFSR(*PSSR)
     F*
     F* Dealing Exposure Extract File Control
     FEMXT2T1   UF   E             DISK    INFSR(*PSSR)
     F*
     F* EM Dealing Tomorrow Events Extract
     FEMTE2E2   O    E             DISK    INFSR(*PSSR)
     F*
     F* EM Dealing Tomorrow Events File Control
     FEMTE2T1   UF   E             DISK    INFSR(*PSSR)
     F*
     F* Net Events File Control
     FFXNEVTPA  O    E             DISK    INFSR(*PSSR)
     F*
     FDL0403AU  O    E             PRINTER INFDS(SPOOLU)
     F*****************************************************************
     F*
     F*   INDICATOR USAGE
     F*   ---------------
     F*
     F*   86   EMTE2_EOF  End of file on EMTE2T2
     F*   87   NEVTC_EOF  End of file on FXNEVTPA
     F*   88   EMXT1_EOF  End of file on EMXT2T1
     F*   89   FXNET_EOF  End of file on FXNETMPD
     F*
     D*****************************************************************
     D*
     D** Copyright array
     D  CPY@           S             80    DIM(1) CTDATA PERRCD(1)
      *
      * Subroutine Stack
     D STK             S             10    DIM(99)
     D*
     D********************************************************************
     D*
     D** Data Structure to retrieve User and Workstation ID.
     D PSDS           SDS
     D  W#PGM            *PROC
     D  W#WSID               244    253
     D  W#USER               254    263
     D*
     D*  LDA for database error
     D*
     D DBERR         E DS                  EXTNAME(LDA)
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D** Bank ICD Details
     D*
     D SDEXPM        E DS                  EXTNAME(SDEXPMPD)
     D** Exposure Management ICD Details
     D*
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D** Customer Details
     D*
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
     D** Midas Modules
     D*
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D** Dealing ICD
     D*
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D** Currency Details
     D*
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
     D** Country Details
     D*
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D** Branch Details
     D  #DFAC1       E                     EXTFLD(QQDFAC)
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D** Data Structure for Access Objects, Short Data Structure
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D** Data Structure for Access Objects, Long Data Structure
     D*
     D W#TRUE          C                   *ON
     D W#FALSE         C                   *OFF
     D*
     D* Data Structure for named indicators
     DIndicatorP       S               *   INZ(%ADDR(*IN))
     DIndicators       DS                  Based(IndicatorP)
     DEMTE2_EOF               86     86
     DNEVTC_EOF               87     87
     DEMXT1_EOF               88     88
     DFXNET_EOF               89     89
      *
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D*
     D ZZDS            DS
     D  ZZ088                  1     88
     D  ZBRCA                  1      3
     D  ZCOBB                  4      6
     D  ZDLNO                  7     12
     D  ZCNCZ                 13     14
     D  ZRGCD                 15     16
     D  ZACOC                 21     22
     D** Data Structure for EMXT2D2 field ZZ088
     D*
     C*****************************************************************
     C*
     C                   EXSR      INITIAL
     C*
      * Net FX Exposure?
     C     W#NETFXEXP    IFEQ      'Y'
      * Net FX Customer Exposure?
     C     W#NETFXCEX    OREQ      'Y'
     C                   EXSR      MAIN
     C                   ENDIF
     C*
     C                   EXSR      FINAL
     C*
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C*****************************************************************
     C* Main Processing
     C*****************************************************************
     C     MAIN          BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'MAIN    '    STK(@Q)
      *
      *
      * Get Netted Deals
     C                   READ      FXNETML1                               89
     C     FXNET_EOF     DOWEQ     W#FALSE
      *
      * Live record?
     C     AMRECI        IFEQ      'C'
      * Value date > system run date
     C     AMVALD        ANDGT     BJRDNB
     C*                                                                                       126894
     C*   Get customer details                                                                126894
     C                   MOVEL     AMCNUM        WWCUST                                       126894
     C                   CALL      'AOCUSTR0'                                                 126894
     C                   PARM      *BLANKS       WWRTCD                                       126894
     C                   PARM      '*KEY    '    WWOPTN                                       126894
     C                   PARM                    WWCUST           10                          126894
     C                   PARM      *BLANKS       WWKYST            7                          126894
     C     SDCUST        PARM      SDCUST        DSSDY                                        126894
     C*   Error?                                                                              126894
     C     WWRTCD        IFNE      *BLANK                                                     126894
     C                   MOVEL     'SDCUSTPD'    DBFILE                                       126894
     C                   Z-ADD     3             DBASE                                        126894
     C                   MOVE      AMCNUM        DBKEY                                        126894
     C                   EXSR      *PSSR                                                      126894
     C                   ENDIF                                                                126894
      *
      * Net FX Exposure?
     C     W#NETFXEXP    IFEQ      'Y'
      *
      * Format details for output Dealing Exposure Extract
      *
      *   Record id
     C                   MOVE      'D'           RECI
      *   Customer of Net
     C                   MOVE      AMCNUM        MCUN
      *   Deal Type
     C     AMBSIN        IFEQ      'B'
     C                   MOVE      'NP'          MDTP
     C                   ENDIF
     C     AMBSIN        IFEQ      'S'
     C                   MOVE      'NS'          MDTP
     C                   ENDIF
      *   Value Date
     C                   MOVE      AMVALD        MVD
      *
     C                   Z-ADD     *ZERO         MOMD
      *   Currency Code
     C                   MOVE      AMCCYD        MCYC
      *   Currency Amount
     C                   MOVE      AMDBUY        MCYA
     C     AMBSIN        IFEQ      'S'
     C                   MULT      -1            MCYA
     C                   ENDIF
      *
     C                   Z-ADD     *ZERO         MFV
     C                   CLEAR                   ZZ001
     C                   MOVE      *ALL'0'       MFTP
     C                   MOVE      *ALL'0'       MFN
      *   Settlement Method
     C                   MOVE      AMSETM        MSMT
      *   Branch Code
     C                   MOVE      AMBRCA        ZBRCA
      *
     C                   CLEAR                   ZCOBB
     C                   CLEAR                   ZDLNO
     C*****                                                                                   126894
     C****Get customer details                                                                126894
     C*****              MOVEL     AMCNUM        WWCUST                                       126894
     C*****              CALL      'AOCUSTR0'                                                 126894
     C*****              PARM      *BLANKS       WWRTCD                                       126894
     C*****              PARM      '*KEY    '    WWOPTN                                       126894
     C*****              PARM                    WWCUST           10                          126894
     C*****              PARM      *BLANKS       WWKYST            7                          126894
     C*****SDCUST        PARM      SDCUST        DSSDY                                        126894
     C****Error?                                                                              126894
     C*****WWRTCD        IFNE      *BLANK                                                     126894
     C*****              MOVEL     'SDCUSTPD'    DBFILE                                       126894
     C*****              Z-ADD     3             DBASE                                        126894
     C*****              MOVE      AMCNUM        DBKEY                                        126894
     C*****              EXSR      *PSSR                                                      126894
     C*****              ENDIF                                                                126894
     C*
     C*   Country of Citizenship
     C                   MOVE      BBCNCZ        ZCNCZ
     C*
     C                   CLEAR                   ZRGCD
     C*   Account Officer Code
     C                   MOVE      BBACOC        ZACOC
      *
      * Write record to Extract
     C                   WRITE     EMXT2D2F
     C                   ADD       1             W#RECCEX
     C*
     C** If Value date is tomorrow, include event on Tomorrow's Events file
     C*
     C     AMVALD        IFEQ      BJDNWD
     C*  Event Type
     C     AMBSIN        IFEQ      'B'
     C                   MOVE      'NTV1'        MEVT
     C                   ELSE
     C                   MOVE      'NTV2'        MEVT
     C                   ENDIF
     C*  Event Currency
     C                   MOVE      AMCCYD        MEVC
     C*  Event Amount
     C                   MOVE      AMDBUY        MEVA
     C*  Facility Indicator
     C                   MOVE      'N'           MFCI
     C*  Settlement type
     C                   MOVE      AMSETM        SETT
     C*  Branch
     C                   MOVE      AMBRCA        BRCA
     C*  Filler
     C                   MOVE      *BLANKS       ZZ093
     C*  Maturity Date
     C                   Z-ADD     *ZEROS        MDAT
     C*  Value Date
     C                   Z-ADD     AMVALD        VDAT
      *
      * Write record to Extract
     C                   WRITE     EMTE2E2F
     C                   ADD       1             W#RECCTW
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Net FX Customer Exposure?
     C     W#NETFXCEX    IFEQ      'Y'
      *
      * Format details for output Dealing Exposure Extract
      *
      *   Record id
     C                   MOVE      'D'           RECI
      *   Deal Number
     C                   MOVE      AMNTNO        DLNO
      *   Customer
     C                   MOVE      AMCNUM        CUNR
      *   Event Type
     C     AMBSIN        IFEQ      'B'
     C                   MOVE      'NTV1'        ETYP
     C                   ELSE
     C                   MOVE      'NTV2'        ETYP
     C                   ENDIF
      *   Event Date
     C                   MOVE      AMVALD        EDAT
      *   Event Amount
     C                   Z-ADD     AMDBUY        EAMT
      *   Event Currency
     C                   MOVE      AMCCYD        ECCY
      *   Branch Code
     C                   MOVE      AMBRCA        BRCA
      *   Event Branch
     C                   MOVE      AMBRCA        EBRC
      *   Input/Output
     C     AMBSIN        IFEQ      'B'
     C                   MOVE      'I'           INOI
     C                   ENDIF
     C     AMBSIN        IFEQ      'S'
     C                   MOVE      'O'           INOI
     C                   ENDIF
      *   Limit Currency Equivalent
     C                   EXSR      LIMCURREQU
      *   Parent
     C**********         MOVE      BBPCNB        W#PCNB            6 0                        CSD027
     C**********         MOVE      W#PCNB        PTNU                                         CSD027
     C                   MOVE      BBPCNB        PTNU                                         CSD027
     C*   Country of Risk
     C                   MOVE      BBCNCZ        CCTZ
     C*   Region of Risk
      *
      *     Get Country
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       WWRTCD
     C                   PARM      '*KEY  '      WWOPTN
     C                   PARM      BBCNCZ        WWCNCZ
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     'SDCTRYPD'    DBFILE
     C                   Z-ADD     11            DBASE
     C                   MOVEL     WWCNCZ        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      A4RGCD        REGC
     C*   Company of Branch
      *
      *     Get Branch
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       WWRTCD
     C                   PARM      '*KEY  '      WWOPTN
     C                   PARM      AMBRCA        WWBRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     AMBRCA        DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     8             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      A8CMCD        COBB
      *   Customer Report Name and Town and Alpha Sort Key
     C                   MOVE      BBCRNM        CRNM
     C                   MOVE      BBCRTN        CTWN
     C                   MOVE      BBCASC        CASK
     C*
     C*   Get parent details
     C                   CLEAR                   PRNM
     C                   CLEAR                   PTWN
     C                   CLEAR                   PASK
     C     BBPCNB        IFNE      *BLANK
     C*
     C                   MOVEL     BBPCNB        WWCUST
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       WWRTCD
     C                   PARM      '*KEY    '    WWOPTN
     C                   PARM                    WWCUST           10
     C                   PARM      *BLANKS       WWKYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
     C*   Error?
     C     WWRTCD        IFNE      *BLANK
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   Z-ADD     12            DBASE
     C                   MOVE      BBPCNB        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
      *   Parent Report Name and Town ans Alpha Sort Key
     C                   MOVE      BBCRNM        PRNM
     C                   MOVE      BBCRTN        PTWN
     C                   MOVE      BBCASC        PASK
     C                   ENDIF
      *
      * Write record to Events
     C                   WRITE     FXNEVTD0
     C                   ADD       1             W#RECCNE
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Get Netted Deals
     C                   READ      FXNETML1                               89
     C                   ENDDO
      *
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
     C*****************************************************************
     C* Calculate Limit Currency Equivalent
     C*****************************************************************
     C     LIMCURREQU    BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'LIMCURREQU'  STK(@Q)
      *
      *
      * Net currency same as base currency
     C     AMCCYD        IFEQ      BNCYCD
      *
      *   Yes, Limit Currency Equivalent is Net Amount
     C                   Z-ADD     AMDBUY        LCEQ
      *
     C                   ELSE
      *
      *   Get currency details
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG'        WWRTCD
     C                   PARM      '*KEY'        WWOPTN
     C                   PARM      AMCCYD        WWCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     AMCCYD        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     10            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     A6ERLC        IFEQ      *ZERO
     C                   Z-ADD     *ZERO         LCEQ
      *
     C                   ELSE
      * Convert Amount to Limit Currency Equivalent
     C                   EVAL      W#N= A6NBDP - W#LCURNBDP + 3
     C     A6MDIN        IFEQ      'D'
     C                   EVAL(H)   LCEQ=
     C                             AMDBUY /
     C                             (A6ERLC * (10**W#N/1000))
     C                   ELSE
     C                   EVAL(H)   LCEQ=
     C                             AMDBUY *
     C                             (A6ERLC / (10**W#N/1000))
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      *
     C*****************************************************************
     C* Final Processing
     C*****************************************************************
     C     FINAL         BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'FINAL   '    STK(@Q)
      *
      *
      * Exposure Management?
     C     BGEXMG        IFEQ      'Y'
      *
      * Get Trailer Record
     C                   READ      EMXT2T1                                88
      * Error?
     C     EMXT1_EOF     IFEQ      W#TRUE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'EMXT2T1'     DBFILE
     C                   Z-ADD     4             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Update Trailer Record
     C                   Z-ADD     NONE          W#RECBEX
     C                   ADD       W#RECCEX      NONE
     C                   Z-ADD     NONE          W#RECAEX
     C                   UPDATE    EMXT2T1F
     C*
     C* Get Trailer Record
     C                   READ      EMTE2T1                                88
     C* Error?
     C     EMTE2_EOF     IFEQ      W#TRUE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'EMTE2T1'     DBFILE
     C                   Z-ADD     5             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
     C* Update Trailer Record
     C                   Z-ADD     UDLR          W#RECBTW
     C                   ADD       W#RECCTW      UDLR
     C                   Z-ADD     UDLR          W#RECATW
     C                   UPDATE    EMTE2T1F
     C                   ENDIF
      *
      * Create Trailer Record
     C                   Z-ADD     NORE          W#RECBNE
     C                   ADD       W#RECCNE      NORE
     C                   Z-ADD     NORE          W#RECANE
     C                   WRITE     FXNEVTF0
      *
      * Print Audit Report
     C                   WRITE     CONTROL
      *
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      *
     C*****************************************************************
     C* Initial Processing
     C*****************************************************************
     C     INITIAL       BEGSR
      *
     C                   Z-ADD     1             @Q                3 0
     C                   MOVEL     'INITIAL '    STK(@Q)
      *
      *
     C     *LIKE         DEFINE    BNCYCD        WWCCY
     C     *LIKE         DEFINE    A6NBDP        W#LCURNBDP
     C     *LIKE         DEFINE    A8BRCD        WWBRCD
     C     *LIKE         DEFINE    BBCNCZ        WWCNCZ
      *
     C                   Z-ADD     *ZERO         W#WK159          15 9
     C                   Z-ADD     *ZERO         W#N               1 0
      *
      * Set up Database Error Details.
     C                   MOVEL     W#PGM         DBPGM
     C                   CLEAR                   DBFILE
     C                   CLEAR                   DBKEY
     C                   CLEAR                   DBASE
     C                   CLEAR                   @DUMP
      *
      * Get bank ICD
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG'        WWRTCD            7
     C                   PARM      '*FIRST '     WWOPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      * Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
     C* Setup Audit Report
     C                   EXSR      AUDIT
      *
      * Get Midas Modules Details
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG'        WWRTCD
     C                   PARM      '*FIRST'      WWOPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     5             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
     C* Get Exposure Management ICD
     C     BGEXMG        IFEQ      'Y'
     C                   CALL      'AOEXPMR0'
     C                   PARM      '*MSG'        WWRTCD
     C                   PARM      '*FIRST '     WWOPTN
     C     SDEXPM        PARM      SDEXPM        DSFDY
     C* Error
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDEXPMPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C*
     C* Net FX Exposure?
     C                   MOVE      BUNTEM        W#NETFXEXP        1
      *
      * Get Dealing ICD Details
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*MSG'        WWRTCD
     C                   PARM      '*FIRST'      WWOPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   Z-ADD     6             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
     C* Net FX Customer Exposure
     C                   MOVE      BNNTCE        W#NETFXCEX        1
      *
      * Get Limit Currency
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG'        WWRTCD
     C                   PARM      '*KEY'        WWOPTN
     C                   PARM      BNCYCD        WWCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     BNCYCD        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     7             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Set Limit Currency Number of Decimal Places
     C                   Z-ADD     A6NBDP        W#LCURNBDP
      *
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      *****************************************************************
      *   Audit File Processing
      *****************************************************************
     C     AUDIT         BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'AUDIT   '    STK(@Q)
      *
      *
     C     DBFILE        IFEQ      *BLANKS
      *
      * Print Header for Audit Report
     C                   WRITE     HEADAU
     C*
     C                   ELSE
     C*
      * Print Database Error Details
     C                   WRITE     DBERROR
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      *****************************************************************
      *
      *  *PSSR - Exception error processing
      *      Calls - NONE
      *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      *   If an error has occurred within this program, update LDA, set
      *   error switches, dump program and return to calling program.
      *
     C     @DUMP         IFEQ      *BLANK
      *
      * Audit report required?
     C     DBFILE        IFNE      *BLANKS
     C                   EXSR      AUDIT
     C                   ENDIF
      *
     C                   DUMP
      *
     C                   MOVE      'Y'           @DUMP             1
     C                   SETON                                        U7U8LR
     C     *DTAARA       DEFINE    LDA           @LDA            256
     C     *LOCK         IN        @LDA
     C                   MOVE      DBERR         @LDA
     C                   OUT       @LDA
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2001
