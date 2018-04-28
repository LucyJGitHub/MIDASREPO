     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade SWIFT Extended Settlement Default')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETSESDFT - Midas SE Trade SWIFT Extended Settlement Default *
      *                                                               *
      *  Function: This module is for the initialisation of screen    *
      *            fields from file.                                  *
      *                                                               *
      *  Component of: SETSESSIN                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. AR585504           Date 30Jul10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206E            Date 24Aug06               *
      *                 CSW206D            Date 24Aug06               *
      *                 240618             Date 27Jun06               *
      *                 238825             Date 06Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG2274            Date 19Aug04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 220395             Date 07Aug03               *
      *                 CSE045  *CREATE    Date 24Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR585504 - Debtor, Debtor Account, QFIN, and Place of        *
      *             Clearing were not populated in TRDN               *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  CSW206D - Change Control for SWIFT 2006 Standard Changes     *
      *  240618 - Remove unecessary dump.                             *
      *  238825 - Move defaulted values correctly to deliver to and   *
      *           from fields.                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG2274 - Unable to access SSI information because market    *
      *            not being passed in.                               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  220395 - The repair function loses the extended settlement   *
      *           data stored in the invalid file and works as if     *
      *           they were all blanks.                               *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FSECTY     IF   E           K DISK
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(TRADSDX2)
      *
      ** Securities screen 1 details retrieved from file - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SETESDPD)
      *
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Security Customer details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Data structure to receive parameters from SE1805 for MT5xxs
     D PDATA         E DS                  EXTNAME(SE50DT)
      *
      ** DS for customer/book standard settlement instruction
      **  to be passed to SESSIR0
     D PCBSTD        E DS                  OCCURS(2) EXTNAME(STDSED)
      *
      ** Data structure for standard additional settlement details
      ** for customer/book to be passed to SESSIR0
     D PCBSAD        E DS                  OCCURS(8) EXTNAME(STDADSED)
      *
      ** DS for Trade Purchase
     D PRTPCS        E DS                  EXTNAME(STDADSED)
     D                                     PREFIX(W4:2)
      *
      ** DS for Trade Sale
     D PRTSCS        E DS                  EXTNAME(STDADSED)
     D                                     PREFIX(W5:2)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D WKey1           S             10A
     D WKyst           S              7A
     D CSE022          S              1A
     D CSE028          S              1A
     D SWRTN           S              7A
     D DFTFLG          S              1A
     D WKRD1           S             35A
     D WKRD2           S             35A
     D WCTPCN          S              6A
     D WCust           S              6A
     D PCUST           S              6A
     D PDEPO           S              6A
     D PDEPO2          S              6A
     D PGMNAM          S              9A
     D PRETC           S             10A
     D PSKAL           S             20A
     D*WWBICN***       S              6P 0                                                    CSD027
     D WWBICN          S              6A                                                      CSD027
     D CSW210          S              1A                                                      CSW210
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Default first screen fields.
      *
     C                   CLEAR                   NwSE1ScnFmt                                  220395
      *                                                                                       220395
     C                   IF        CrSEFilFmt <> *Blanks
     C                   EXSR      SRFtos
     C                   ELSE
      *
      ** If CSE028 is on, call SESSIR0 for default of MT5xx information
      *
     C     CSE028        IFEQ      'Y'
     C     DFTFLG        ANDEQ     'Y'
 
     C     PSESN         CHAIN     SECTYDF                            99
     C                   MOVEL     SITP          PINVT
      *                                                                                      BUG2274
      ** Setup Market Centre for calling SESSIR0                                             BUG2274
     C                   IF        MarktCentr = *BLANKS                                      BUG2274
     C                   EVAL      MarktCentr = SMCC                                         BUG2274
     C                   END                                                                 BUG2274
     C                   EVAL      PSMCC = MarktCentr                                        BUG2274
 
     C                   CALL      'SESSIR0'
     C                   PARM      'D'           POTYP             1
     C                   PARM                    PTDBR
     C                   PARM                    PTCNR
     C                   PARM                    PPBKC
     C                   PARM                    PTNMC
     C                   PARM                    PSMCC             2
     C                   PARM                    PINVT             3
     C                   PARM                    PPTFR
     C                   PARM                    PCBSTD
     C                   PARM                    PCBSAD
     C                   PARM      *BLANKS       PRTCDE            5
      *
      ** Retrieve SSI details for safekeeping account.
      *
     C     1             OCCUR     PCBSTD
     C     SKAC          IFEQ      ' '
     C     2             OCCUR     PCBSTD
     C                   ENDIF
     C                   MOVE      SKAC          WSKAC            20
     C                   MOVE      SFAT          WSFAT             8
     C                   MOVE      SFAF          WSFAF             8
 
     C                   SELECT
 
     C     PTDTP         WHENEQ    'TP'
     C                   DO
      *
      ** For Trade Purchase, Reg Details should be defaulted
      ** from the book SSI and not from the Counterparty SSI.
      *
     C     1             OCCUR     PCBSAD
     C                   MOVE      PCBSAD        PRTPCS
     C                   MOVE      W4RED1        WKRD1
     C                   MOVE      W4RED2        WKRD2
     C     5             OCCUR     PCBSAD
     C                   MOVE      PCBSAD        PRTPCS
     C                   MOVE      WKRD1         W4RED1
     C                   MOVE      WKRD2         W4RED2
     C                   ENDDO
      *
     C     PTDTP         WHENEQ    'TS'
     C                   DO
     C     6             OCCUR     PCBSAD
     C                   MOVE      PCBSAD        PRTSCS
     C                   ENDDO
      *
     C                   ENDSL
      *
     C                   EXSR      SRMofs
      *
     C                   ELSE
     C                   MOVE      PTDSI         ESSRL1
 
     C                   ENDIF
 
     C                   ENDIF
     C**********         DUMP                                                               240618
      *
      ** Return.
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFtos - Move File Fields to Screen Fields                   *
      *                                                               *
      *****************************************************************
     C     SRFtos        BEGSR
 
     C                   MOVE      T2AP1N        ESAP1N
     C                   MOVE      T2AP1L        ESAP1L
     C                   MOVE      T2AFPN        ESAP2N
     C                   MOVE      T2AFPL        ESAP2L
     C                   MOVE      T2AWIN        ESAWIN
     C                   MOVE      T2AWIL        ESAWIL
     C                   MOVE      T2BOFN        ESBOFN
     C                   MOVE      T2BOF1        ESBOF1
     C                   IF        CSW210 = 'N'                                               CSW210
     C                   MOVE      T2BOF2        ESBOF2
     C                   ENDIF                                                                CSW210
     C                   MOVE      T2ACL1        ESACL1
     C                   MOVE      T2ACL2        ESACL2
     C                   MOVE      T2SRL1        ESSRL1
     C                   MOVE      T2SRL2        ESSRL2
     C                   MOVE      T2SRL3        ESSRL3
     C                   MOVE      T2FIN1        ESFIN1
     C                   MOVE      T2FIN2        ESFIN2
     C                   MOVE      T2RED1        ESRED1
     C                   MOVE      T2RED2        ESRED2
     C                   MOVE      T2NAL1        ESNAL1
     C                   MOVE      T2NAL2        ESNAL2
     C                   MOVE      T2IPYN        ESIPYN
     C                   MOVE      T2IPYL        ESIPYL
     C                   MOVE      T2CTYN        ESCTYN
     C                   MOVE      T2CTYL        ESCTYL
     C                   MOVE      T2SA1N        ESSA1N
     C                   MOVE      T2SA1L        ESSA1L
     C                   MOVE      T2SKAN        ESSKAN
     C                   MOVE      T2SKAL        ESSKAL
     C                   MOVE      T2CCTN        ESCCTN
     C                   MOVE      T2DCTL        ESDCTL
     C                   MOVE      T2RSSN        ESRSSN
     C                   MOVE      T2RSS1        ESRSS1
     C                   MOVE      T2RSS2        ESRSS2
     C                   MOVE      T2RSS3        ESRSS3
     C                   MOVE      T2RSS4        ESRSS4
     C                   MOVE      T2DSSN        ESDSSN
     C                   MOVE      T2DSS1        ESDSS1
     C                   MOVE      T2DSS2        ESDSS2
     C                   MOVE      T2DSS3        ESDSS3
     C                   MOVE      T2DSS4        ESDSS4
     C                   MOVE      T2BSSN        ESBSSN
     C                   MOVE      T2BSS1        ESBSS1
     C                   MOVE      T2BSS2        ESBSS2
     C                   MOVE      T2INVE        ESINVE
      *
     C     CSE028        IFEQ      'Y'
     C                   MOVEL     T2IMD1        ESIMMD1
     C                   MOVEL     T2IMD2        ESIMMD2
     C**********         MOVEL     T2IMD3        ESIMMD3                                     CSW206D
     C**********         MOVEL     T2IMD4        ESIMMD4                                     CSW206D
     C**********         MOVEL     T2IMD5        ESIMMD5                                     CSW206D
     C**********         MOVEL     T2IMD6        ESIMMD6                                     CSW206D
     C**********         MOVEL     T2IMD7        ESIMMD7                                     CSW206D
     C**********         MOVEL     T2IMD8        ESIMMD8                                     CSW206D
     C**********         MOVEL     T2IMD9        ESIMMD9                                     CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   MOVEL     T2IMD3        ESIMMD3                                     CSW206E
     C                   MOVEL     T2IMD4        ESIMMD4                                     CSW206E
     C                   MOVEL     T2IMD5        ESIMMD5                                     CSW206E
     C                   MOVEL     T2IMD6        ESIMMD6                                     CSW206E
     C                   MOVEL     T2IMD7        ESIMMD7                                     CSW206E
     C                   MOVEL     T2IMD8        ESIMMD8                                     CSW206E
     C                   MOVEL     T2IMD9        ESIMMD9                                     CSW206E
     C                   ENDIF                                                               CSW206E
     C                   MOVEL     T2IMS1        ESIMSA1
     C                   MOVEL     T2IMS2        ESIMSA2
     C**********         MOVEL     T2IMS3        ESIMSA3                                     CSW206D
     C**********         MOVEL     T2IMS4        ESIMSA4                                     CSW206D
     C**********         MOVEL     T2IMS5        ESIMSA5                                     CSW206D
     C**********         MOVEL     T2IMS6        ESIMSA6                                     CSW206D
     C**********         MOVEL     T2IMS7        ESIMSA7                                     CSW206D
     C**********         MOVEL     T2IMS8        ESIMSA8                                     CSW206D
     C**********         MOVEL     T2IMS9        ESIMSA9                                     CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   MOVEL     T2IMS3        ESIMSA3                                     CSW206E
     C                   MOVEL     T2IMS4        ESIMSA4                                     CSW206E
     C                   MOVEL     T2IMS5        ESIMSA5                                     CSW206E
     C                   MOVEL     T2IMS6        ESIMSA6                                     CSW206E
     C                   MOVEL     T2IMS7        ESIMSA7                                     CSW206E
     C                   MOVEL     T2IMS8        ESIMSA8                                     CSW206E
     C                   MOVEL     T2IMS9        ESIMSA9                                     CSW206E
     C                   ENDIF                                                               CSW206E
     C                   MOVEL     T2PSET        ESPSET
     C                   MOVEL     T2NAC1        ESNAC1
     C                   MOVEL     T2NAC2        ESNAC2
      ** SWIFT 2010                                                                           CSW210
     C                   IF        CSW210 = 'Y'                                               CSW210
     C                   MOVEL     T2DIDN        ESDIDN                                       CSW210
     C                   MOVEL     T2DAD1        ESDAD1                                       CSW210
     C                   MOVEL     T2DAD2        ESDAD2                                       CSW210
     C                   MOVEL     T2DAD3        ESDAD3                                       CSW210
     C                   MOVEL     T2DAD4        ESDAD4                                       CSW210
     C                   MOVEL     T2DLIN        ESDLIN                                       CSW210
     C                   MOVEL     T2QFIN        ESQFIN                                       CSW210
     C                   MOVEL     T2PCLR        ESPCLR                                       CSW210
     C                   ENDIF                                                                CSW210
 
     C     T2CTYN        IFNE      *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      T2CTYN        WKey1
     C                   PARM      *BLANKS       WKyst
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     PRtcd         IFEQ      *BLANK
     C                   MOVEL     BBCUST        WCTPCN
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** If Enquiry Mode, Retrieve Customer Shortnames
     C     PACTN         IFEQ      'E'
      *
     C     T2AP1N        IFNE      *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      T2AP1N        WKey1
     C                   PARM      *BLANKS       WKyst
     C     SDCUST        PARM      SDCUST        DSSDY
     C     PRtcd         IFEQ      *BLANK
     C     WKyst         ANDNE     '*ERROR'
     C                   MOVE      BBCSSN        ESAP1N
     C                   ENDIF
     C                   ENDIF
      *
     C     T2AFPN        IFNE      *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      T2AFPN        WKey1
     C                   PARM      *BLANKS       WKyst
     C     SDCUST        PARM      SDCUST        DSSDY
     C     PRtcd         IFEQ      *BLANK
     C                   MOVE      BBCSSN        ESAP2N
     C                   ENDIF
     C                   ENDIF
      *
     C     T2AWIN        IFNE      *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      T2AWIN        WKey1
     C                   PARM      *BLANKS       WKyst
     C     SDCUST        PARM      SDCUST        DSSDY
     C     PRtcd         IFEQ      *BLANK
     C                   MOVE      BBCSSN        ESAWIN
     C                   ENDIF
     C                   ENDIF
      *
     C     T2BOFN        IFNE      *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      T2BOFN        WKey1
     C                   PARM      *BLANKS       WKyst
     C     SDCUST        PARM      SDCUST        DSSDY
     C     PRtcd         IFEQ      *BLANK
     C                   MOVE      BBCSSN        ESBOFN
     C                   ENDIF
     C                   ENDIF
      *
     C     T2IPYN        IFNE      *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      T2IPYN        WKey1
     C                   PARM      *BLANKS       WKyst
     C     SDCUST        PARM      SDCUST        DSSDY
     C     PRtcd         IFEQ      *BLANK
     C                   MOVE      BBCSSN        ESIPYN
     C                   END
     C                   END
      *
     C     SWRTN         IFNE      'CSW098 '
      *
     C     T2CTYN        IFNE      *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      T2CTYN        WKey1
     C                   PARM      *BLANKS       WKyst
     C     SDCUST        PARM      SDCUST        DSSDY
     C     PRtcd         IFEQ      *BLANK
     C                   MOVE      BBCSSN        ESCTYN
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      *
     C     T2INVE        IFNE      *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      T2INVE        WKey1
     C                   PARM      *BLANKS       WKyst
     C     SDCUST        PARM      SDCUST        DSSDY
     C     PRtcd         IFEQ      *BLANK
     C                   MOVE      BBCSSN        ESINVE
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     T2SA1N        IFNE      *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      T2SA1N        WKey1
     C                   PARM      *BLANKS       WKyst
     C     SDCUST        PARM      SDCUST        DSSDY
     C     PRtcd         IFEQ      *BLANK
     C                   MOVE      BBCSSN        ESSA1N
     C                   ENDIF
     C                   ENDIF
      *
     C     T2SKAN        IFNE      *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      T2SKAN        WKey1
     C                   PARM      *BLANKS       WKyst
     C     SDCUST        PARM      SDCUST        DSSDY
     C     PRtcd         IFEQ      *BLANK
     C                   MOVE      BBCSSN        ESSKAN
     C                   ENDIF
     C                   ENDIF
      *
     C     T2RSSN        IFNE      *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      T2RSSN        WKey1
     C                   PARM      *BLANKS       WKyst
     C     SDCUST        PARM      SDCUST        DSSDY
     C     PRtcd         IFEQ      *BLANK
     C                   MOVE      BBCSSN        ESRSSN
     C                   ENDIF
     C                   ENDIF
      *
     C     T2DSSN        IFNE      *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      T2DSSN        WKey1
     C                   PARM      *BLANKS       WKyst
     C     SDCUST        PARM      SDCUST        DSSDY
     C     PRtcd         IFEQ      *BLANK
     C                   MOVE      BBCSSN        ESDSSN
     C                   ENDIF
     C                   ENDIF
      *
     C     T2BSSN        IFNE      *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      T2BSSN        WKey1
     C                   PARM      *BLANKS       WKyst
     C     SDCUST        PARM      SDCUST        DSSDY
     C     PRtcd         IFEQ      *BLANK
     C                   MOVE      BBCSSN        ESBSSN
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMofs - Move File Fields to Screen Fields                   *
      *                                                               *
      *****************************************************************
     C     SRMofs        BEGSR
      *
     C     WCTPCN        IFEQ      *BLANKS
     C                   MOVEL     PTCNR         WCTPCN
     C                   ENDIF
      *
      ** Retrieve classification of counterparty
      *
     C                   CALL      'AOSECSR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WCTPCN        WCust
     C     SDSECS        PARM      SDSECS        DSSDY
      *
     C     PTDTP         IFEQ      'TP'
      *
     C                   MOVE      W4AFPN        ESAP2N
     C                   MOVE      W4AFPL        ESAP2L
     C                   MOVE      W4AWIN        ESAWIN
     C                   MOVE      W4AWIL        ESAWIL
     C                   MOVE      W4BOFN        ESBOFN
     C                   MOVE      W4BOF1        ESBOF1
     C                   IF        CSW210 = 'N'                                               CSW210
     C                   MOVE      W4BOF2        ESBOF2
     C                   ENDIF                                                                CSW210
     C                   MOVE      W4SRL1        ESSRL1
     C                   MOVE      W4SRL2        ESSRL2
     C                   MOVE      W4SRL3        ESSRL3
     C                   MOVE      W4FIN1        ESFIN1
     C                   MOVE      W4FIN2        ESFIN2
     C                   MOVE      W4RED1        ESRED1
     C                   MOVE      W4RED2        ESRED2
     C                   MOVE      W4NAS1        ESNAL1
     C                   MOVE      W4NAS2        ESNAL2
     C                   MOVE      W4CCTN        ESCCTN
 
     C                   MOVE      W4DRSN        ESDSSN
     C                   MOVE      W4DRS1        ESDSS1
     C                   MOVE      W4DRS2        ESDSS2
     C                   MOVE      W4DRS3        ESDSS3
     C                   MOVE      W4DRS4        ESDSS4
 
     C                   MOVE      W4BSSN        ESBSSN
     C                   MOVE      W4BSS1        ESBSS1
     C                   MOVE      W4BSS2        ESBSS2
     C                   MOVEL     W4IMD1        ESIMMD1
     C                   MOVEL     W4IMD2        ESIMMD2
     C**********         MOVEL     W4IMD3        ESIMMD3                                     CSW206D
     C**********         MOVEL     W4IMD4        ESIMMD4                                     CSW206D
     C**********         MOVEL     W4IMD5        ESIMMD5                                     CSW206D
     C**********         MOVEL     W4IMD6        ESIMMD6                                     CSW206D
     C**********         MOVEL     W4IMD7        ESIMMD7                                     CSW206D
     C**********         MOVEL     W4IMD8        ESIMMD8                                     CSW206D
     C**********         MOVEL     W4IMD9        ESIMMD9                                     CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   MOVEL     W4IMD3        ESIMMD3                                     CSW206E
     C                   MOVEL     W4IMD4        ESIMMD4                                     CSW206E
     C                   MOVEL     W4IMD5        ESIMMD5                                     CSW206E
     C                   MOVEL     W4IMD6        ESIMMD6                                     CSW206E
     C                   MOVEL     W4IMD7        ESIMMD7                                     CSW206E
     C                   MOVEL     W4IMD8        ESIMMD8                                     CSW206E
     C                   MOVEL     W4IMD9        ESIMMD9                                     CSW206E
     C                   ENDIF                                                               CSW206E
     C                   MOVEL     W4IMS1        ESIMSA1
     C                   MOVEL     W4IMS2        ESIMSA2
     C**********         MOVEL     W4IMS3        ESIMSA3                                     CSW206D
     C**********         MOVEL     W4IMS4        ESIMSA4                                     CSW206D
     C**********         MOVEL     W4IMS5        ESIMSA5                                     CSW206D
     C**********         MOVEL     W4IMS6        ESIMSA6                                     CSW206D
     C**********         MOVEL     W4IMS7        ESIMSA7                                     CSW206D
     C**********         MOVEL     W4IMS8        ESIMSA8                                     CSW206D
     C**********         MOVEL     W4IMS9        ESIMSA9                                     CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   MOVEL     W4IMS3        ESIMSA3                                     CSW206E
     C                   MOVEL     W4IMS4        ESIMSA4                                     CSW206E
     C                   MOVEL     W4IMS5        ESIMSA5                                     CSW206E
     C                   MOVEL     W4IMS6        ESIMSA6                                     CSW206E
     C                   MOVEL     W4IMS7        ESIMSA7                                     CSW206E
     C                   MOVEL     W4IMS8        ESIMSA8                                     CSW206E
     C                   MOVEL     W4IMS9        ESIMSA9                                     CSW206E
     C                   ENDIF                                                               CSW206E
     C                   MOVEL     W4PSET        ESPSET
     C                   MOVEL     W4NAC1        ESNAC1
     C                   MOVEL     W4NAC2        ESNAC2
      ** SWIFT 2010                                                                           CSW210
     C                   IF        CSW210 = 'Y'                                               CSW210
     C                   MOVEL     W4DIDN        ESDIDN                                       CSW210
     C                   MOVEL     W4DAD1        ESDAD1                                       CSW210
     C                   MOVEL     W4DAD2        ESDAD2                                       CSW210
     C                   MOVEL     W4DAD3        ESDAD3                                       CSW210
     C                   MOVEL     W4DAD4        ESDAD4                                       CSW210
     C                   MOVEL     W4DLIN        ESDLIN                                       CSW210
     C                   MOVEL     W4QFIN        ESQFIN                                       CSW210
     C                   MOVEL     W4PCLR        ESPCLR                                       CSW210
     C                   ENDIF                                                                CSW210
      *
      ** Setup parameters to call module SEDORFRTV
      *
     C     BFCLAS        IFEQ      'M'
      *                                                                                       238825
     C     PDELT         IFEQ      *ZEROS                                                     238825
     C                   MOVE      *BLANKS       PDEPO                                        238825
     C                   ELSE                                                                 238825
     C                   MOVEL     PDELT         PDEPO
     C                   ENDIF                                                                238825
      *                                                                                       238825
     C                   MOVEL     WWBICN        PCUST
      *                                                                                       238825
     C     PDELF         IFEQ      *ZEROS                                                     238825
     C                   MOVE      *BLANKS       PDEPO2                                       238825
     C                   ELSE                                                                 238825
     C                   MOVEL     PDELF         PDEPO2
     C                   ENDIF                                                                238825
      *                                                                                       238825
     C                   ELSE
      *                                                                                       238825
     C     PDELT         IFEQ      *ZEROS                                                     238825
     C                   MOVE      *BLANKS       PDEPO                                        238825
     C                   ELSE                                                                 238825
     C                   MOVEL     PDELT         PDEPO
     C                   ENDIF                                                                238825
      *                                                                                       238825
     C                   MOVEL     WCTPCN        PCUST
      *                                                                                       238825
     C     PDELF         IFEQ      *ZEROS                                                     238825
     C                   MOVE      *BLANKS       PDEPO2                                       238825
     C                   ELSE                                                                 238825
     C                   MOVEL     PDELF         PDEPO2
     C                   ENDIF                                                                238825
      *                                                                                       238825
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      W5AFPN        ESAP2N
     C                   MOVE      W5AFPL        ESAP2L
     C                   MOVE      W5AWIN        ESAWIN
     C                   MOVE      W5AWIL        ESAWIL
     C                   MOVE      W5BOFN        ESBOFN
     C                   MOVE      W5BOF1        ESBOF1
     C                   IF        CSW210 = 'N'                                             AR585504
     C                   MOVE      W5BOF2        ESBOF2
     C                   ENDIF                                                              AR585504
     C                   MOVE      W5SRL1        ESSRL1
     C                   MOVE      W5SRL2        ESSRL2
     C                   MOVE      W5SRL3        ESSRL3
     C                   MOVE      W5FIN1        ESFIN1
     C                   MOVE      W5FIN2        ESFIN2
     C                   MOVE      W5RED1        ESRED1
     C                   MOVE      W5RED2        ESRED2
     C                   MOVE      W5NAS1        ESNAL1
     C                   MOVE      W5NAS2        ESNAL2
     C                   MOVE      W5CCTN        ESCCTN
 
     C                   MOVE      W5DRSN        ESRSSN
     C                   MOVE      W5DRS1        ESRSS1
     C                   MOVE      W5DRS2        ESRSS2
     C                   MOVE      W5DRS3        ESRSS3
     C                   MOVE      W5DRS4        ESRSS4
 
     C                   MOVE      W5BSSN        ESBSSN
     C                   MOVE      W5BSS1        ESBSS1
     C                   MOVE      W5BSS2        ESBSS2
     C                   MOVEL     W5IMD1        ESIMMD1
     C                   MOVEL     W5IMD2        ESIMMD2
     C**********         MOVEL     W5IMD3        ESIMMD3                                     CSW206D
     C**********         MOVEL     W5IMD4        ESIMMD4                                     CSW206D
     C**********         MOVEL     W5IMD5        ESIMMD5                                     CSW206D
     C**********         MOVEL     W5IMD6        ESIMMD6                                     CSW206D
     C**********         MOVEL     W5IMD7        ESIMMD7                                     CSW206D
     C**********         MOVEL     W5IMD8        ESIMMD8                                     CSW206D
     C**********         MOVEL     W5IMD9        ESIMMD9                                     CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   MOVEL     W5IMD3        ESIMMD3                                     CSW206E
     C                   MOVEL     W5IMD4        ESIMMD4                                     CSW206E
     C                   MOVEL     W5IMD5        ESIMMD5                                     CSW206E
     C                   MOVEL     W5IMD6        ESIMMD6                                     CSW206E
     C                   MOVEL     W5IMD7        ESIMMD7                                     CSW206E
     C                   MOVEL     W5IMD8        ESIMMD8                                     CSW206E
     C                   MOVEL     W5IMD9        ESIMMD9                                     CSW206E
     C                   ENDIF                                                               CSW206E
     C                   MOVEL     W5IMS1        ESIMSA1
     C                   MOVEL     W5IMS2        ESIMSA2
     C**********         MOVEL     W5IMS3        ESIMSA3                                     CSW206D
     C**********         MOVEL     W5IMS4        ESIMSA4                                     CSW206D
     C**********         MOVEL     W5IMS5        ESIMSA5                                     CSW206D
     C**********         MOVEL     W5IMS6        ESIMSA6                                     CSW206D
     C**********         MOVEL     W5IMS7        ESIMSA7                                     CSW206D
     C**********         MOVEL     W5IMS8        ESIMSA8                                     CSW206D
     C**********         MOVEL     W5IMS9        ESIMSA9                                     CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   MOVEL     W5IMS3        ESIMSA3                                     CSW206E
     C                   MOVEL     W5IMS4        ESIMSA4                                     CSW206E
     C                   MOVEL     W5IMS5        ESIMSA5                                     CSW206E
     C                   MOVEL     W5IMS6        ESIMSA6                                     CSW206E
     C                   MOVEL     W5IMS7        ESIMSA7                                     CSW206E
     C                   MOVEL     W5IMS8        ESIMSA8                                     CSW206E
     C                   MOVEL     W5IMS9        ESIMSA9                                     CSW206E
     C                   ENDIF                                                               CSW206E
     C                   MOVEL     W5PSET        ESPSET
     C                   MOVEL     W5NAC1        ESNAC1
     C                   MOVEL     W5NAC2        ESNAC2
      *                                                                                     AR585504
      ** SWIFT 2010                                                                         AR585504
      *                                                                                     AR585504
     C                   IF        CSW210 = 'Y'                                             AR585504
     C                   MOVEL     W5DIDN        ESDIDN                                     AR585504
     C                   MOVEL     W5DAD1        ESDAD1                                     AR585504
     C                   MOVEL     W5DAD2        ESDAD2                                     AR585504
     C                   MOVEL     W5DAD3        ESDAD3                                     AR585504
     C                   MOVEL     W5DAD4        ESDAD4                                     AR585504
     C                   MOVEL     W5DLIN        ESDLIN                                     AR585504
     C                   MOVEL     W5QFIN        ESQFIN                                     AR585504
     C                   MOVEL     W5PCLR        ESPCLR                                     AR585504
     C                   ENDIF                                                              AR585504
      *
      ** Setup parameters to call module SEDORFRTV
      *
     C     BFCLAS        IFEQ      'M'
      *                                                                                       238825
     C     PDELF         IFEQ      *ZEROS                                                     238825
     C                   MOVE      *BLANKS       PDEPO                                        238825
     C                   ELSE                                                                 238825
     C                   MOVEL     PDELF         PDEPO
     C                   ENDIF                                                                238825
      *                                                                                       238825
     C                   MOVEL     WWBICN        PCUST
     C     PDELT         IFEQ      *ZEROS                                                     238825
     C                   MOVE      *BLANKS       PDEPO2                                       238825
     C                   ELSE                                                                 238825
     C                   MOVEL     PDELT         PDEPO2
     C                   ENDIF                                                                238825
      *                                                                                       238825
     C                   ELSE
     C     PDELF         IFEQ      *ZEROS                                                     238825
     C                   MOVE      *BLANKS       PDEPO                                        238825
     C                   ELSE                                                                 238825
     C                   MOVEL     PDELF         PDEPO
     C                   ENDIF                                                                238825
      *                                                                                       238825
     C                   MOVEL     WCTPCN        PCUST
      *                                                                                       238825
     C     PDELT         IFEQ      *ZEROS                                                     238825
     C                   MOVE      *BLANKS       PDEPO2                                       238825
     C                   ELSE                                                                 238825
     C                   MOVEL     PDELT         PDEPO2
     C                   ENDIF                                                                238825
      *                                                                                       238825
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If CSE022 is installed then setup Safekeeping A/C Line by using module SEDORFRTV
      *
     C     CSE022        IFEQ      'Y'
      *
     C                   CALL      PGMNAM
     C                   PARM      *BLANKS       PRETC
     C                   PARM                    PDEPO
     C                   PARM                    PCUST
     C                   PARM      *BLANKS       PSKAL
 
     C                   MOVEL     PDEPO         ESSKAN
     C                   MOVEL     PSKAL         ESSKAL
 
     C                   CALL      PGMNAM
     C                   PARM      *BLANKS       PRETC
     C                   PARM                    PDEPO2
     C                   PARM                    PTCNR
     C                   PARM      *BLANKS       PSKAL
 
     C     PTDTP         IFEQ      'TP'
     C     WSFAF         ANDNE     *BLANKS
     C                   MOVEL     WSFAF         ESSA1N
     C                   ELSE
     C     PTDTP         IFEQ      'TS'
     C     WSFAT         ANDNE     *BLANKS
     C                   MOVEL     WSFAT         ESSA1N
     C                   ELSE
     C                   MOVEL     PDEPO2        ESSA1N
     C                   END
     C                   END
      *
     C     PSKAL         IFNE      ' '
     C                   MOVEL     PSKAL         ESSA1L
     C                   ELSE
     C                   MOVEL     WSKAC         ESSA1L
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    CSE022
 
     C                   PARM                    CSE028
 
     C                   PARM                    SWRTN
 
     C                   PARM                    DFTFLG
 
     C                   PARM                    WWBICN
 
     C                   PARM                    PGMNAM
     C                   PARM                    MarktCentr        2                         BUG2274
     C                   PARM                    CSW206            1                         CSW206E
     C                   PARM                    CSW210                                       CSW210
      *
      ** OUTPUT
      ** ======
      *
      ** Securities screen 1 details retrieved from file - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
