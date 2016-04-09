     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade SWIFT details defaulting TRADSDX2')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETSWX2DFT - Securities Trade SWFIT Details Defaulting       *
      *               TRADSDX2                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSW206E            Date 24Aug06               *
      *                 CSW206D            Date 24Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 237295             Date 23Jan06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG6794            Date 07Sep05               *
      *                 BUG8087            Date 03Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3122            Date 17Jul04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210517  *CREATE    Date 21Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  CSW206D - Change Control for SWIFT 2006 Standard Changes     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  237295 - Do not default Deliver To/From to blank or zero.    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG6794 - Donot set up default if customer number is 0.      *
      *  BUG8087 - Don't default if customer = 0                      *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  210517 - Misssing TRADSDX2 record from the API               *
      *                                                               *
      *****************************************************************
 
     FTRADSDY2  IF   E           K DISK
 
     FSECTY     IF   E           K DISK
 
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
      /EJECT
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Trade Details, A Screen
     D A_TradX2      E DS                  EXTNAME(TRADSDX2)
     D                                     PREFIX(A_)
 
      ** Trade Details, B screen
     D B_TradX2      E DS                  EXTNAME(TRADSDX2)
     D                                     PREFIX(B_)
 
     D TradX2        E DS                  EXTNAME(TRADSDX2)
 
     D PCBSTD        E DS                  OCCURS(2) EXTNAME(STDSED)
 
     D PCBSAD        E DS                  OCCURS(8) EXTNAME(STDADSED)
 
      ** DS Trade Settlement Details
     D TrdSett       E DS                  EXTNAME(STDADSED)
     D                                     PREFIX(TP:2)
 
      ** Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Securitu Customer Details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** Switchable features description file
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SCLCD        E                     EXTFLD(LCD)
 
      ** Second Data Structure for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D PScreen         S              1A
     D PRetCode        S              7A
     D POption         S              7A
     D PSARD           S              6A
     D PBranch         S              3A
     D PTrdType        S              2A
     D PCtrPty         S              6A
     D PSecName        S             10A
     D PDelFrom        S              6A
     D PDelTo          S              6A
     D PBook           S              2A
     D PCurr           S              3A
     D PMrkCtr         S              2A
     D PInvType        S              3A
     D PTrdRef         S              6A
     D PCust           S              6A
     D PDepot          S              6A
     D PDepot2         S              6A
     D PSKAL           S             20A
     D PPortRef        S              4A
 
     D CSE022          S              1A
     D CSE028          S              1A
     D CSW210          S              1A                                                      CSW210
 
     D CSW206          S              1A                                                     CSW206E
     D CSW206RC        S              7A                                                     CSW206E
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EXSR      SRInit
 
     C                   EXSR      SRProcess
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRInit   - Initialization                                    *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Retrieve the classification of the Counterparty
 
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCtrPty
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDSECSPD'
     C                   EVAL      DBASE  = 902
     C                   EVAL      DBKEY  = PCtrPty
     C                   ENDIF
 
      ** Retrieve the internal branch customer
 
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PBranch
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRetCode <> *Blanks
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE  = 903
     C                   EVAL      DBKEY  = PBranch
     C                   ENDIF
 
     C                   CLEAR                   TradX2
      *                                                                                      CSW206E
      ** Check if SWIFT Changes 2006 (CSW206) is installed                                   CSW206E
      *                                                                                      CSW206E
     C                   CALL      'SWIF2006'                                                CSW206E
     C                   PARM      *BLANKS       CSW206RC                                    CSW206E
      *                                                                                      CSW206E
     C                   IF        CSW206RC = 'CSW2006'                                      CSW206E
     C                   EVAL      CSW206 = 'Y'                                              CSW206E
     C                   ELSE                                                                CSW206E
     C                   EVAL      CSW206 = 'N'                                              CSW206E
     C                   ENDIF                                                               CSW206E
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRProcess - Default Fields for TRADSDX2                      *
      *****************************************************************
     C     SRProcess     BEGSR
 
      ** Check whether record exists
      ** (it would already exist if F14 for Extended Settlements has
      **  been taken more than once during the same insert)
 
     C     KEY001        CHAIN     TRADSDD2                           89
 
      ** If record found then set up screen fields from file;
      ** else initialize screen fields and file fields.
 
     C                   IF        *IN89 = *OFF
     C                   EXSR      SROutFlds
     C                   ELSE
 
      ** If CSE028 is on, call SESSIR0 for default of MT5xx information
 
     C                   IF        CSE028 = 'Y'
 
     C     PSecName      CHAIN     SECTYDF                            99
     C                   MOVEL     SITP          PInvType
 
     C                   CALL      'SESSIR0'
     C                   PARM      'D'           POTYP             1
     C                   PARM                    PBranch
     C                   PARM                    PCtrPty
     C                   PARM                    PBook
     C                   PARM                    PCurr
     C                   PARM                    PMrkCtr
     C                   PARM                    PInvType
     C                   PARM                    PPortRef
     C                   PARM                    PCBSTD
     C                   PARM                    PCBSAD
     C                   PARM      *BLANKS       PRTCDE            5
 
     C                   SELECT
 
     C                   WHEN      PTrdType = 'TP'
 
      ** For Trade Purchase, Reg Details should be defaulted
      ** from the book SSI and not from the Counterparty SSI.
 
     C     *LIKE         DEFINE    SARED1        WKRD1
     C     *LIKE         DEFINE    SARED2        WKRD2
     C     1             OCCUR     PCBSAD
     C                   MOVE      PCBSAD        TrdSett
     C                   MOVE      TPRED1        WKRD1
     C                   MOVE      TPRED2        WKRD2
     C     5             OCCUR     PCBSAD
     C                   MOVE      PCBSAD        TrdSett
     C                   MOVE      WKRD1         SARED1
     C                   MOVE      WKRD2         SARED2
 
     C                   WHEN      PTrdType = 'TS'
     C     6             OCCUR     PCBSAD
     C                   MOVE      PCBSAD        TrdSett
 
     C                   ENDSL
 
     C                   EXSR      SRMovFlds
     C                   EXSR      SROutFlds
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRMovFlds - Move to TRADSDX2 file fields                     *
      *****************************************************************
     C     SRMovFlds     BEGSR
 
     C                   EVAL      T2AFPN = TPAFPN
     C                   EVAL      T2AFPL = TPAFPL
     C                   EVAL      T2AWIN = TPAWIN
     C                   EVAL      T2AWIL = TPAWIL
     C                   EVAL      T2BOFN = TPBOFN
     C                   EVAL      T2BOF1 = TPBOF1
     C                   EVAL      T2BOF2 = TPBOF2
     C                   EVAL      T2SRL1 = TPSRL1
     C                   EVAL      T2SRL2 = TPSRL2
     C                   EVAL      T2SRL3 = TPSRL3
     C                   EVAL      T2FIN1 = TPFIN1
     C                   EVAL      T2FIN2 = TPFIN2
     C                   EVAL      T2RED1 = TPRED1
     C                   EVAL      T2RED2 = TPRED2
     C                   EVAL      T2NAL1 = TPNAS1
     C                   EVAL      T2NAL2 = TPNAS2
     C                   EVAL      T2CCTN = TPCCTN
     C                   EVAL      T2BSSN = TPBSSN
     C                   EVAL      T2BSS1 = TPBSS1
     C                   EVAL      T2BSS2 = TPBSS2
 
     C                   IF        CSE028 = 'Y'
     C                   EVAL      T2IMD1 = TPIMD1
     C                   EVAL      T2IMD2 = TPIMD2
     C**********         EVAL      T2IMD3 = TPIMD3                                           CSW206D
     C**********         EVAL      T2IMD4 = TPIMD4                                           CSW206D
     C**********         EVAL      T2IMD5 = TPIMD5                                           CSW206D
     C**********         EVAL      T2IMD6 = TPIMD6                                           CSW206D
     C**********         EVAL      T2IMD7 = TPIMD7                                           CSW206D
     C**********         EVAL      T2IMD8 = TPIMD8                                           CSW206D
     C**********         EVAL      T2IMD9 = TPIMD9                                           CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      T2IMD3 = TPIMD3                                           CSW206E
     C                   EVAL      T2IMD4 = TPIMD4                                           CSW206E
     C                   EVAL      T2IMD5 = TPIMD5                                           CSW206E
     C                   EVAL      T2IMD6 = TPIMD6                                           CSW206E
     C                   EVAL      T2IMD7 = TPIMD7                                           CSW206E
     C                   EVAL      T2IMD8 = TPIMD8                                           CSW206E
     C                   EVAL      T2IMD9 = TPIMD9                                           CSW206E
     C                   ENDIF                                                               CSW206E
     C                   EVAL      T2IMS1 = TPIMS1
     C                   EVAL      T2IMS2 = TPIMS2
     C**********         EVAL      T2IMS3 = TPIMS3                                           CSW206D
     C**********         EVAL      T2IMS4 = TPIMS4                                           CSW206D
     C**********         EVAL      T2IMS5 = TPIMS5                                           CSW206D
     C**********         EVAL      T2IMS6 = TPIMS6                                           CSW206D
     C**********         EVAL      T2IMS7 = TPIMS7                                           CSW206D
     C**********         EVAL      T2IMS8 = TPIMS8                                           CSW206D
     C**********         EVAL      T2IMS9 = TPIMS9                                           CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      T2IMS3 = TPIMS3                                           CSW206E
     C                   EVAL      T2IMS4 = TPIMS4                                           CSW206E
     C                   EVAL      T2IMS5 = TPIMS5                                           CSW206E
     C                   EVAL      T2IMS6 = TPIMS6                                           CSW206E
     C                   EVAL      T2IMS7 = TPIMS7                                           CSW206E
     C                   EVAL      T2IMS8 = TPIMS8                                           CSW206E
     C                   EVAL      T2IMS9 = TPIMS9                                           CSW206E
     C                   ENDIF                                                               CSW206E
     C                   EVAL      T2PSET = TPPSET
     C                   EVAL      T2NAC1 = TPNAC1
     C                   EVAL      T2NAC2 = TPNAC2
     C                   ENDIF
 
     C                   IF        CSW210 = 'Y'                                               CSW210
     C                   EVAL      T2DIDN = TPDIDN                                            CSW210
     C                   EVAL      T2DLIN = TPDLIN                                            CSW210
     C                   EVAL      T2DAD1 = TPDAD1                                            CSW210
     C                   EVAL      T2DAD2 = TPDAD2                                            CSW210
     C                   EVAL      T2DAD3 = TPDAD3                                            CSW210
     C                   EVAL      T2DAD4 = TPDAD4                                            CSW210
     C                   EVAL      T2QFIN = TPQFIN                                            CSW210
     C                   EVAL      T2PCLR = TPPCLR                                            CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        PTrdType = 'TP'
     C                   EVAL      T2DSSN = TPDRSN
     C                   EVAL      T2DSS1 = TPDRS1
     C                   EVAL      T2DSS2 = TPDRS2
     C                   EVAL      T2DSS3 = TPDRS3
     C                   EVAL      T2DSS4 = TPDRS4
     C                   ELSE
     C                   EVAL      T2RSSN = TPDRSN
     C                   EVAL      T2RSS1 = TPDRS1
     C                   EVAL      T2RSS2 = TPDRS2
     C                   EVAL      T2RSS3 = TPDRS3
     C                   EVAL      T2RSS4 = TPDRS4
     C                   ENDIF
 
      ** Default the Deliver/Receiver of Securities if it is blank
 
     C                   IF        PTrdType = 'TP' and T2DSSN = *BLANKS
     C                             and PDelFrom <> *BLANKS                                    237295
     C                             AND PDelFrom <> '0'                                       BUG6794
     C                             AND PDelFrom <> '000000'                                  BUG6794
     C                   EVAL      T2DSSN = PDelFrom
     C                   ENDIF
 
     C                   IF        PTrdType = 'TS' and T2RSSN = *BLANKS
     C                             and PDelTo <> *BLANKS                                      237295
     C                             AND PDelTo <> '0'                                         BUG6794
     C                             AND PDelTo <> '000000'                                    BUG6794
     C                   EVAL      T2RSSN = PDelTo
     C                   ENDIF
 
      ** Set up parameters for SEDORFRTV
      ** Set up Safekeeping Account Line if CSE022 is installed
 
     C                   IF        BFCLAS = 'M'
     C                   EVAL      PCust = A8BICN
     C                   ELSE
     C                   EVAL      PCust = PCtrPty
     C                   ENDIF
 
     C                   IF        PTrdType = 'TP'
     C                   EVAL      PDepot = PDelTo
     C                   EVAL      PDepot2 = PDelFrom
     C                   ELSE
     C                   EVAL      PDepot = PDelFrom
     C                   EVAL      PDepot2 = PDelTo
     C                   ENDIF
 
      ** Default for the Safekeeping Account and Safekeeping Account Line
 
     C                   IF        CSE022 = 'Y'
 
     C                   CALL      'SEDORFRTV'
     C                   PARM                    PRetCode
     C                   PARM                    PDepot
     C                   PARM                    PCust
     C                   PARM                    PSKAL
 
     C                   IF        PSKAL = *Blanks
     C                   CALL      'SEDORFRTV'
     C                   PARM                    PRetCode
     C                   PARM                    PDepot
     C                   PARM                    PDepot
     C                   PARM                    PSKAL
     C                   ENDIF
 
     C                   If        PDepot <> '0' AND                                         BUG8087
     C                             PDepot <> '000000'                                        BUG8087
     C                   EVAL      T2SKAN = PDepot
     C                   EndIf                                                               BUG8087
     C                   EVAL      T2SKAL = PSKAL
 
     C                   CALL      'SEDORFRTV'
     C                   PARM                    PRetCode
     C                   PARM                    PDepot2
     C                   PARM      PCtrPty       PCust
     C                   PARM                    PSKAL
 
     C                   If        PDepot2 <> '0' AND                                        BUG8087
     C                             PDepot2 <> '000000'                                       BUG8087
     C                   EVAL      T2SA1N = PDepot2
     C                   EndIf                                                               BUG8087
     C                   EVAL      T2SA1L = PSKAL
     C                   ENDIF
 
     C                   EVAL      T2WHEN = PScreen
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SROutFlds - Move to Output Fields                            *
      *****************************************************************
     C     SROutflds     BEGSR
 
     C                   IF        PScreen = 'A'
     C                   CLEAR                   A_TradX2
     C                   EVAL      A_TradX2 = TradX2
     C                   ELSE
     C                   CLEAR                   B_TradX2
     C                   EVAL      B_TradX2 = TradX2
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS :
      *
      * Screen (A or B)
     C                   PARM                    PScreen
      *
      * Trade Details (screen)
      *
     C                   PARM                    PTrdRef
     C                   PARM                    PTrdType
     C                   PARM                    PCtrPty
     C                   PARM                    PSecName
     C                   PARM                    PBranch
     C                   PARM                    PDelFrom
     C                   PARM                    PDelTo
     C                   PARM                    PBook
     C                   PARM                    PCurr
     C                   PARM                    PMrkCtr
      *
      ** OUTPUT PARAMETERS :
      *
      * Screen A details
     C                   PARM                    A_TradX2
      *
      * Screen B details
     C                   PARM                    B_TradX2
      *
      ** Check if CSE028 feature is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSE028'      PSard
     C     SCSARD        PARM      SCSARD        DSSDY
      *
      ** Database Error
      *
     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = 'CSE028'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CSE028 = 'Y'
     C                   ELSE
     C                   EVAL      CSE028 = 'N'
     C                   ENDIF
      *
      ** Check if CSE022 feature is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSE022'      PSard
     C     SCSARD        PARM      SCSARD        DSSDY
      *
      ** Database Error
      *
     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 902
     C                   EVAL      DBKEY  = 'CSE022'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CSE022 = 'Y'
     C                   ELSE
     C                   EVAL      CSE022 = 'N'
     C                   ENDIF
                                                                                              CSW210
      ** Call SWIF2010 to check if CSW210 is switched on                                      CSW210
                                                                                              CSW210
     C                   CALL      'SWIF2010'                           7373                  CSW210
     C                   PARM      *BLANKS       @RTCD                                        CSW210
      *                                                                                       CSW210
     C                   IF        *IN73 = *ON                                                CSW210
     C                   MOVEL     'SDBANKPD'    DBFILE                                       CSW210
     C                   MOVEL     '904'         DBASE                                        CSW210
     C                   MOVEL     '*CALL'       DBKEY                                        CSW210
     C                   EXSR      *PSSR                                                      CSW210
     C                   ELSE                                                                 CSW210
      *                                                                                       CSW210
     C                   IF        @RTCD = 'CSW2010'                                          CSW210
     C                   MOVE      'Y'           CSW210                                       CSW210
     C                   ELSE                                                                 CSW210
     C                   MOVE      'N'           CSW210                                       CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
 
     C     KEY001        KLIST
     C                   KFLD                    PTrdRef
     C                   KFLD                    PScreen
      *
     C                   ENDSR
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
