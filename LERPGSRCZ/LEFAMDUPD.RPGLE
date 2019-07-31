     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*OVR *  OVRDBF FILE(LEFCAMXX) TOFILE(LEFCAML6) SHARE(*NO)            *
/*OVR *  OVRDBF FILE(LEFEEDXX) TOFILE(LEFEEDL1) SHARE(*NO)            *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility amendment update')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFAMDUPD -  Facility Amendment Update                       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD024398           Date 11May14               *
      *                 MD025467           Date 08May14               *
      *                 MD024342B          Date 08May14               *
      *                 MD024342           Date 08May14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR787620           Date 10Jun11               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257297             Date 17Oct08               *
      *                 256732             Date 03Oct08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244719             Date 26Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 07Jul05               *
      *                 BUG7146            Date 18May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6318            Date 18Mar05               *
      *                 CLE041             Date 15Oct04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4555            Date 19Oct04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 20Jun03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 204452             Date 03May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP071  *CREATE    Date 25Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD024398 - API Performance Optimisation                      *
      *  MD025467 - API locking issues Redesign Approach              *
      *  MD024342B - API issue. Trailer file allocation problem.      *
      *  MD024342 - LEFCAMZZ allocation problem.                      *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00234                                 *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  257297 - Update with prior read or chain                     *
      *  256732 - Amended program to populate LEFCAMQD when a         *
      *           facility amendment is inserted thru clip to prevent *
      *           errors on the facility event screen.                *
      *  244719 - MCH3601 was encountered when calling AONOSTR0 -     *
      *           parameter mismatch.                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager.                               *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG7146 - Rename inserting, amending, and authorising user   *
      *            fields from PF/LEFEED and PF/FCLTYFM to prevent    *
      *            overriding the fields for PF/LEFCAMPD.             *
      *            Fix is patterned after 222653.                     *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6318- Move check on ZMUSER out of *INZSR                  *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4555 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs. Additional fix for BUG3760.          *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Use correct user if user is a java user             *
      *  204452 - Recompiled due to changed PF/LEFEED.                *
      *  CAP071 - Conversion of LE inputs into modular structure to   *
      *           use as API's.                                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
 
      ** Facility amendments
     FLEFCAMXX  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     COMMIT
     FLEFCAMQD  UF A E           K DISK    INFSR(*PSSR)                                       256732
     F                                     PREFIX(LFQ_)                                       256732
 
      ** Facility amendments trailer
     F***LEFCAMZZ  UF   E             DISK    INFSR(*PSSR)                                  MD024342
     F***LEFCAMZZ  UF A E             DISK    INFSR(*PSSR)                        MD024342 MD024342B
     F***LEFCAMZZ  UF   E          DISK    INFSR(*PSSR)                           MD024342B MD025467
     FLEFCAMZZ  UF A E             DISK    INFSR(*PSSR)                                    MD024342B
     F                                     COMMIT
 
      ** Facility amendments trailer                                                          CLE041
     FLEAGAMZZ  UF   E             DISK    INFSR(*PSSR)                                       CLE041
     F                                     RENAME(LEFCAMZF:LEAGAMZF)                          CLE041
     F                                     PREFIX(AGFC_)                                      CLE041
     F                                     COMMIT                                             CLE041
                                                                                              CLE041
      ** Lending fees
     FLEFEEDXX  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     COMMIT
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG4555
      ** Compliance Watch Hit List                                                          BUG4555
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)                                       CLE041
     FLEAGFCL0  IF   E           K DISK    INFSR(*PSSR)                                       CLE041
     F                                     PREFIX(AGFC_)                                      CLE041
     F                                     IGNORE(FCLTYHHF)                                   CLE041
     F                                     RENAME(FCLTYFMF:AGFCLTFMF)                         CLE041
     F                                     RENAME(FCLTYFNF:AGFCLTFNF)                         CLE041
     F                                     RENAME(FCLTYZZF:AGFCLTZZF)                         CLE041
     F***SDAPDRL0  IF   E        K DISK    INFSR(*PSSR)                            MD024342 MD025467
      *****************************************************************            MD024342 MD025467
      ***Midas*SD*API*Driving*File*************************************            MD024342 MD025467
     F***LEFCAMZZX O    E          DISK    COMMIT                                 MD024342B MD025467
     F**********                           RENAME(LEFCAMZF:LEFCAMZFX)             MD024342B MD025467
      ***API:*Midas*LE*Facility*Amendment*Transaction*Trailer**********           MD024342B MD025467
      *****************************************************************           MD024342B MD025467
 
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
 
     D OVRDBF1         C                   'OVRDBF FILE(LEFCAMXX)-
     D                                       TOFILE(LEFCAML6) SHARE(*NO)'
     D OVRDBF2         C                   'OVRDBF FILE(LEFEEDXX)-
     D                                       TOFILE(LEFEEDL1) SHARE(*NO)'
     D OVRDBF3         C                   'OVRDBF FILE(LEFCAMXX)-                            CLE041
     D                                       TOFILE(LEAGAML2) SHARE(*NO)'                     CLE041
 
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
 
      ** Amendment Details in file format
     D LEFCAMPD      E DS                  EXTNAME(LEFCAMPD)
 
      ** Valid Amendment Details in file format
     D LEVFAMDPD     E DS                  EXTNAME(LEVFAMDPD)
 
      ** Facility Amendment Details OK indicator
     D FAMD_OK       E DS                  EXTNAME(LEEFAMDPD)
 
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Customer lending details
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
 
      ** Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
                                                                                              CAP084
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                     CAP084
      ** Java user information                                                                CAP084
 
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ** Midas API Message Header Format Definition
 
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
 
     D CSC011          S              1A   INZ('N')
     D CAP086          S              1A   INZ('N')                                           CAP086
     D TRANSDTL        S           5800A
     D WTimestamp      S             26A
     D*PDealNo***      S             18A                                                      CGL029
     D*PADealNo**      S             18A                                                      CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D WDealNo         S              6A
     D WAggregate      S              1A                                                      CLE041
     D KCNUM           S                   LIKE(AMCNUM)                                       CLE041
     D KFACT           S                   LIKE(AMFACT)                                       CLE041
     D KFCNO           S                   LIKE(AMFCNO)                                       CLE041
     D KRCTP           S              1A                                                      CLE041
     D XOT             S             25A   DIM(Elements) PERRCD(1) CTDATA                   BUG4555
      ** XML Opening Tags for the Compliance Engine                                         BUG4555
                                                                                            BUG4555
     D XCT             S             25A   DIM(Elements) PERRCD(1) CTDATA                   BUG4555
      ** XML Closing Tags for the Compliance Engine                                         BUG4555
     D fclfm         E DS                  EXTNAME(FCLTYFM)                                 BUG4555
     D                                     PREFIX(CH)                                       BUG4555
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG4555
     D QQDFAC2       E                     EXTFLD(QQDFAC)                                   BUG4555
      ***  Customer Details                                                                 BUG4555
                                                                                            BUG4555
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                BUG4555
      ** Midas Functions for Watch List Checking Details File                               BUG4555
      *                                                                                     BUG4555
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                BUG4555
      ** Midas SD Watch List Configuration Data File                                        BUG4555
      *                                                                                     BUG4555
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                BUG4555
      ** Watch List Transaction details file                                                BUG4555
      *                                                                                     BUG4555
     D PFreeFmtStr     S          30000A                                                    BUG4555
      ** Compliance Engine Free Format String Parameter                                     BUG4555
                                                                                            BUG4555
     D Elements        C                   CONST(13)                                        BUG4555
      ** Array Size Definition                                                              BUG4555
                                                                                            BUG4555
     D WLF             S             18A   DIM(Elements)                                    BUG4555
      ** Watch List Fields Array.                                                           BUG4555
     D CSD015          S              1    INZ('N')                                         BUG4555
     D CCF001          S              1    INZ('N')                                         BUG4555
     D WFuncType       S              8                                                     BUG4555
     D WIdntifier      S             40                                                     BUG4555
     D WBranch         S              3                                                     BUG4555
     D WLChgFlg        S              1    INZ('N')                                         BUG4555
     D WLOkFlg         S              1    INZ('N')                                         BUG4555
     D WXMLPacket      S            310                                                     BUG4555
     D WData           S            216                                                     BUG4555
     D Ctr             S              2P 0                                                  BUG4555
     D PRetCode        S              7                                                     BUG4555
     D POption         S              7                                                     BUG4555
     D PFunc           S              8                                                     BUG4555
     D PCust           S             10                                                     BUG4555
     D PStKey          S              7                                                     BUG4555
     D PFmtCCY         S              3                                                     BUG4555
     D PDummy6         S              6                                                     BUG4555
     D PDummy16        S             16                                                     BUG4555
     D PDummy35        S             35                                                     BUG4555
     D PZARtCd         S              7                                                     BUG4555
     D PZADayNo        S              5                                                     BUG4555
     D PZADDT          S               D                                                    BUG4555
     D PZACvtDt        S             10                                                     BUG4555
     D WDDT            S               D                                                    BUG4555
     D WDtlOPay        S              1                                                     BUG4555
     D WPtyp           S              2A                                                    BUG4555
     D W#FRNT          S              8A                                                   MD0243423
 
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
 
      ** Rename fields                                                                        CLE106
                                                                                              CLE106
     ILEFEEDF                                                                                BUG7146
     I              FSTS                        LEFSTS                                        CLE106
     I              IUSR                        IUSRF                                        BUG7146
     I              AUSR                        AUSRF                                        BUG7146
     I              XUSR                        XUSRF                                        BUG7146
     I              PCRF                        PCRFF                                        BUG7146
     I              OSDB                        LEOSDB                                        CLE106
     I              OMDB                        LEOMDB                                        CLE106
     I              RSTM                        LERSTM                                        CLE106
     I              RONS                        LERONS                                        CLE106
     I              RIBN                        LERIBN                                        CLE106
     I              RIBA                        LERIBA                                        CLE106
     I              ROBN                        LEROBN                                        CLE106
     I              ROCN                        LEROCN                                        CLE106
     I              PSTM                        LEPSTM                                        CLE106
     I              PONS                        LEPONS                                        CLE106
     I              PIBN                        LEPIBN                                        CLE106
     I              PIBA                        LEPIBA                                        CLE106
     I              POBN                        LEPOBN                                        CLE106
     I              POCN                        LEPOCN                                        CLE106
     I              RCRN                        LERCRN                                        CLE106
     I              RCRA                        LERCRA                                        CLE106
     I              RVNO                        LERVNO                                        CLE106
     I              AWBN                        LEAWBN                                        CLE106
     I              AWBA                        LEAWBA                                        CLE106
     I              BENN                        LEBENN                                        CLE106
     I              BENA                        LEBENA                                        CLE106
     I              DTP1                        LEDTP1                                        CLE106
     I              DTP2                        LEDTP2                                        CLE106
     I              DTP3                        LEDTP3                                        CLE106
     I              DTP4                        LEDTP4                                        CLE106
     I              DCHG                        LEDCHG                                        CLE106
     I              BTB1                        LEBTB1                                        CLE106
     I              BTB2                        LEBTB2                                        CLE106
     I              BTB3                        LEBTB3                                        CLE106
     I              BTB4                        LEBTB4                                        CLE106
     I              BTB5                        LEBTB5                                        CLE106
     I              BTB6                        LEBTB6                                        CLE106
     I              CVMR                        LECVMR                                        CLE106
     I              PCOB                        PCOBF                                        BUG7146
     I              FRNT                        LEFRNT                                        CLE106
     I              AFRT                        LEAFRT                                        CLE106
     I              REPA                        LEREPA                                        CLE106
     I              STMP                        LESTMP                                        CLE106
     IFCLTYFMF                                                                               BUG7146
     I              IUSR                        IUSRFM                                       BUG7146
     I              AUSR                        AUSRFM                                       BUG7146
     I              XUSR                        XUSRFM                                       BUG7146
      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *inzsr is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
      *
      ** Clear output fields
      *
     C                   MOVEL     *ALL'Y'       FAMD_OK
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIDArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
      *                                                                                      BUG6318
      * If the user is connected via a browser, the job user name is QUSER -                 BUG6318
      * their user name is stored in ZMUSER                                                  BUG6318
     C                   IN        ZMUSER                                                    BUG6318
                                                                                              CLE041
      ** Perform overrides and set IsAggregate flag (WAggregate)                              CLE041
     C                   EXSR      SRChkFclt                                                  CLE041
 
      ** Only clear warning error details if not coming from MidasPlus                        CAP084
                                                                                              CAP084
     C     USRID         IFEQ      *BLANKS                                                    CAP084
     C                   MOVE      *BLANK        WFldNamArr
     C                   MOVE      *BLANK        WMsgIDArr
     C                   MOVE      *BLANK        WMsgDtaArr
     C                   Z-ADD     0             Wx
     C                   ENDIF                                                                CAP084
 
     C                   MOVE      *BLANK        A_SQNO
 
      * Set up the key fields to the facility amendments file
 
     C                   MOVEL     AMCNUM        K#CNUM
     C                   MOVEL     AMFACT        K#FACT
     C                   MOVEL     AMFCNO        K#FCNO
     C                   Z-ADD     AMVLDT        K#VLDT
     C                   MOVEL     AMSQNO        K#SQNO
 
     C                   SELECT
 
      **  Write facility amendment record
      **  ===============================
 
     C     S#ACTN        WHENEQ    'I'
     C                   EXSR      WRITER
 
      **  Amend facility amendment record
      **  ===============================
 
     C     S#ACTN        WHENEQ    'A'
     C                   EXSR      AMENDR
 
      **  Authorise facility amendment record
      **  ===================================
 
     C     S#ACTN        WHENEQ    'X'
     C                   EXSR      AUTHOR
 
      **  Delete facility amendment record
      **  ================================
 
     C     S#ACTN        WHENEQ    'D'
     C                   EXSR      DELETR
      *
     C                   ENDSL
 
      ** If 24x7 Midas Availability is installed, write to the standard
      ** log file when support system is active
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    @OPTN
     C                   PARM      ACCY          @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   MOVE      ACCY          FccyFCCY          3
     C                   MOVE      A6NBDP        FccyNBDP          1 0
 
      ** Setup Amendments support log
 
     C                   CALLB     'LEFAMDLOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    S#ACTN
     C                   PARM                    LEFCAMPD
     C                   PARM                    FccyFCCY
     C                   PARM                    FccyNBDP
     C                   PARM                    TRANSDTL
 
      ** Write to support database log file
 
     C                   IF        RetCodeOut = *BLANKS
 
     C                   EVAL      APTGTTYPE = 'LEFAMD'
                                                                                              CAP084
      * Use the job user name or remote (java) user name as appropriate                       CAP084
     C                   IF        USRID  <> *Blank                                           CAP084
     C                   EVAL      APUSERID = USRID                                           CAP084
     C                   ELSE                                                                 CAP084
     C                   EVAL      APUSERID = PSUser
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   MOVEL     AMFRNT        APFOTRANID
     C                   MOVEL     AMAFRT        APFOASOCID
     C                   MOVEL     AMCNUM        W@AMCNUM          6
     C                   MOVEL     AMFACT        W@AMFACT          3
     C                   MOVEL     AMFCNO        W@AMFCNO          2
     C                   MOVEL     AMSQNO        W@AMSQNO          3
     C                   MOVEL     AMFATP        W@AMFATP          2
     C                   EVAL      PDealNo = W@AMCNUM + W@AMFACT +
     C                                       W@AMFCNO + W@AMSQNO + W@AMFATP
     C                   EVAL      PADealNo = *BLANKS
 
     C                   CALLB     'APLOGTRAN'
 
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       WTimestamp
     C                   PARM                    PDealNo
     C                   PARM                    PADealNo
 
     C                   ENDIF
 
      ** If error occured,
 
     C                   IF        RetCodeOut <> *BLANKS
 
     C                   EVAL      RetCodeIn = '*ERROR'
 
     C                   ENDIF
 
     C                   ENDIF
 
      **  Update the trailer if no errors
      **  Else report an error
 
     C     Ix            IFEQ      0
     C                   IF        WAggregate = 'Y'                                           CLE041
     C                   EXSR      UpdTrlAg                                                   CLE041
     C                   ELSE                                                                 CLE041
     C                   EXSR      UPDTRL
     C                   ENDIF                                                                CLE041
     C                   ELSE
     C     RetCodeIn     IFEQ      *BLANK
     C                   MOVEL     '*ERROR    '  RetCodeIn
     C                   ENDIF
     C                   ENDIF
      *
     C                   CLOSE     LEFCAMXX                                                   CLE041
                                                                                              CLE041
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      * WRITER   : Write facility amendment record                    *
      *****************************************************************
     C     WRITER        BEGSR
 
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * If CLE009 is installed, update fees file
 
     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRFEES
     C                   ELSE
     C                   MOVE      *BLANKS       AMSWRI
     C                   MOVE      *BLANKS       AMAUTH
     C                   ENDIF
 
      ** Get the next available sequence no.
 
     C                   MOVE      AMSQNO        A_SQNO
 
     C                   MOVEL     LEVFAMDPD     LEFCAMPD
     C                   Z-ADD     BJRDNB        TLCD
 
     C                   EVAL      STMP  = TimeStamp
                                                                                            BUG4555
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                            BUG4555
     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                        BUG4555
     C                             AND LIBR = S1MAIN)                                       BUG4555
                                                                                            BUG4555
                                                                                            BUG4555
     C                   EXSR      SrWatch                                                  BUG4555
                                                                                            BUG4555
     C                   ENDIF                                                              BUG4555
                                                                                            BUG4555
                                                                                              CAP086
     C                   IF        AMAUTO = 'Y'                                               CAP086
     C                             AND CAP086 = 'Y'                                           CAP086
     C                   EVAL      ASTS = 'A'                                                 CAP086
     C                   EVAL      AUTO = AMAUTO                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
 
      * Write to LEFCAML6
     C                   WRITE     LEFCAMPF                             80
 
      * If an error occurs on the write, then end
 
     C     *IN80         IFEQ      *ON
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'LEFCAMPD'    DBFILE
     C                   MOVEL     '800'         DBASE
     C                   MOVEL     '*WRITE'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     P#MODE        IFEQ      'B'                                                        256732
                                                                                              256732
     C                   MOVEL     *BLANKS       LFQ_FABRCA                                   256732
     C                   MOVEL     AMCNUM        LFQ_FACNUM                                   256732
     C                   MOVEL     AMFACT        LFQ_FAFTYP                                   256732
     C                   MOVEL     AMFCNO        LFQ_FAFCNO                                   256732
     C                   MOVEL     AMFATP        LFQ_FAFATP                                   256732
     C                   Z-ADD     AMVLDT        LFQ_FAVLDT                                   256732
     C                   MOVEL     AMSQNO        LFQ_FASQNO                                   256732
     C                   MOVEL     *BLANKS       LFQ_FAFRID                                   256732
                                                                                              256732
      * Write to LEFCAMQD                                                                     256732
     C                   WRITE     LEFCAQD0                             81                    256732
                                                                                              256732
      * If an error occurs on the write, then end                                             256732
                                                                                              256732
     C     *IN81         IFEQ      *ON                                                        256732
     C                   MOVEL     '*ERROR '     RetCodeIn                                    256732
     C                   MOVEL     'LEFCAMQD'    DBFILE                                       256732
     C                   MOVEL     '801'         DBASE                                        256732
     C                   MOVEL     '*WRITE'      DBKEY                                        256732
     C                   EXSR      *PSSR                                                      256732
     C                   ENDIF                                                                256732
     C                   ENDIF                                                                256732
                                                                                              256732
     C     EWRITER       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * AMENDR   : Amend facility amendment record                    *
      *****************************************************************
     C     AMENDR        BEGSR
 
      * Access the record
 
     C     FCAMK         CHAIN     LEFCAMXX                           80
     C     *IN80         IFEQ      '0'                                                        257297
 
      * Save the previous amendment amount
 
     C                   Z-ADD     AAMT          P_AAMT           13 0
 
      **Currency
     C                   MOVEL     AMACCY        ACCY
 
      **Amount
     C                   Z-ADD     AMAAMT        AAMT
 
      **Revolving credit ind, new expiry date
 
     C                   MOVEL     AMRVCR        RVCR
     C                   Z-ADD     AMNDEX        NDEX
     C/COPY WNCPYSRC,LEH00234
 
      * Set record status if CLE002 is present and
      * Facility Amendment Authorise = Y.
 
     C     CLE002        IFEQ      'Y'
     C     BPFAAM        ANDEQ     'Y'
 
      * Status = 'R' if previous status was 'A', otherwise status = 'C'
 
     C     ASTS          IFEQ      'A'
     C     ASTS          OREQ      'R'
     C                   MOVEL     'R'           ASTS
     C                   ELSE
     C                   MOVEL     'C'           ASTS
     C                   ENDIF
 
     C                   ELSE
     C                   MOVEL     'A'           ASTS
     C                   ENDIF
 
      * Amend User
                                                                                              CAP084
      * Use the job user name or remote (java) user name as appropriate                       CAP084
     C                   If        USRID  <> *Blank                                           CAP084
     C                   EVAL      AUSR = USRID                                               CAP084
     C                   Else                                                                 CAP084
     C                   MOVEL     PsUser        AUSR
     C                   EndIf                                                                CAP084
 
      * Last change date & change type
 
     C                   Z-ADD     BJRDNB        TLCD
     C                   MOVEL     S#ACTN        CHTP
 
      * For batch mode, set interface fields
 
     C     P#MODE        IFEQ      'B'
     C                   MOVEL     AMAUSR        AUSR
     C                   MOVEL     AMXUSR        XUSR
     C                   MOVEL     AMPCRF        PCRF
     C                   MOVEL     AMFRNT        FRNT
     C                   MOVEL     'A'           ASTS
     C                   ENDIF
 
      * If CLE009 is installed, set Work Regeneration Indicator
      * to changed and update fees file
 
     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRFEES
     C                   ENDIF
 
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   EVAL      STMP = TimeStamp
      *                                                                                     BUG4555
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                            BUG4555
     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                        BUG4555
     C                             AND LIBR = S1MAIN)                                       BUG4555
                                                                                            BUG4555
     C                   EVAL      WFuncType ='LEFCAMPD'                                    BUG4555
     C                   MOVEL     '/'           Wrk3              3                        BUG4555
     C                   MOVE      FCNO          Wrk3                                       BUG4555
     C                   MOVEL     FACT          FCNbr             6                        BUG4555
     C                   MOVE      Wrk3          FCNbr                                      BUG4555
     C                   MOVEL     CNUM          FIdentfr         13                        BUG4555
     C                   MOVE      FCNbr         FIdentfr                                   BUG4555
     C                   EVAL      WIdntifier = FIdentfr                                    BUG4555
     C                   EVAL      WBranch = BRCA                                           BUG4555
                                                                                            BUG4555
     C     KCwFld        CHAIN     SDCWHTL1                                                 BUG4555
     C                   IF        NOT %FOUND(SDCWHTL1)                                     BUG4555
     C                   EXSR      SRWatch                                                  BUG4555
     C                   ENDIF                                                              BUG4555
                                                                                            BUG4555
     C                   ENDIF                                                              BUG4555
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
      *                                                                                       CAP086
     C                   IF        AMAUTO = 'Y'                                               CAP086
     C                             AND CAP086 = 'Y'                                           CAP086
     C                   EVAL      ASTS = 'A'                                                 CAP086
     C                   EVAL      AUTO = AMAUTO                                              CAP086
     C                   ENDIF                                                                CAP086
 
      * Update LEFCAML6
     C                   UPDATE    LEFCAMPF
     C                   ENDIF                                                                257297
 
     C     EAMENDR       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * AUTHOR   : Authorise facility amendment record                *
      *****************************************************************
     C     AUTHOR        BEGSR
 
      * Access the record
 
     C     FCAMK         CHAIN     LEFCAMXX                           80
     C     *IN80         IFEQ      '0'                                                        257297
 
      * Status
     C                   MOVEL     'A'           ASTS
 
      * Authorising User
                                                                                              CAP084
      * Use the job user name or remote (java) user name as appropriate                       CAP084
     C                   If        USRID  <> *Blank                                           CAP084
     C                   EVAL      XUSR = USRID                                               CAP084
     C                   Else                                                                 CAP084
     C                   MOVEL     PsUser        XUSR
     C                   EndIf                                                                CAP084
 
      * Last change date
     C                   Z-ADD     BJRDNB        TLCD
 
      * For batch mode, set interface fields
 
     C     P#MODE        IFEQ      'B'
     C                   MOVEL     AMXUSR        XUSR
     C                   MOVEL     AMPCRF        PCRF
     C                   MOVEL     AMFRNT        FRNT
     C                   MOVEL     'A'           ASTS
     C                   ENDIF
 
      * If CLE009 is installed, set Work Regeneration Indicator
      * to changed and update fees file
 
     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRFEES
     C                   ENDIF
                                                                                              CAP086
     C                   IF        AMAUTO = 'Y'                                               CAP086
     C                             AND CAP086 = 'Y'                                           CAP086
     C                   EVAL      ASTS = 'A'                                                 CAP086
     C                   EVAL      AUTO = AMAUTO                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
 
      * Update LEFCAML6
     C                   UPDATE    LEFCAMPF
     C                   ENDIF                                                                257297
 
     C     EAUTHOR       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * DELETR   : Delete facility amendment record                   *
      *****************************************************************
     C     DELETR        BEGSR
 
      * Access the record
 
     C     FCAMK         CHAIN     LEFCAMXX                           80
     C     *IN80         IFEQ      '0'                                                        257297
 
      * Record ID
     C                   MOVEL     'R'           RECI
 
      * Status
     C                   MOVEL     'D'           ASTS
 
      * Last change date & change type
 
     C                   Z-ADD     BJRDNB        TLCD
     C                   MOVEL     S#ACTN        CHTP
 
      * For batch mode, set interface fields
 
     C     P#MODE        IFEQ      'B'
     C                   MOVEL     AMPCRF        PCRF
     C                   MOVEL     AMFRNT        FRNT
     C                   ENDIF
      *
      ** If CLE009 is installed, set Work Regeneration Indicator to
      ** changed and update fees file
      *
     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRFEES
     C                   ENDIF
      *
     C                   UPDATE    LEFCAMPF
     C                   ENDIF                                                                257297
 
     C     EDELETR       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRFEES  -  Update Fees File                                   *
      *****************************************************************
     C     SRFEES        BEGSR
 
     C                   MOVE      *BLANKS       W#SWRI            1
 
      * If action code is insert, amend or delete and if action type
      * is facility increase, facility decrease or revolving credit
 
     C     S#ACTN        IFEQ      'I'
     C     S#ACTN        OREQ      'A'
     C     S#ACTN        OREQ      'D'
 
     C     AMFATP        IFEQ      'FI'
     C     AMFATP        OREQ      'FD'
     C     AMFATP        OREQ      'RC'
     C                   MOVE      'C'           W#SWRI
     C                   ENDIF
 
     C                   ENDIF
 
      * If authorisation switchable feature is on
      * and facility amendments authorisations is required
      * and action code is insert or amend
 
     C     CLE002        IFEQ      'Y'
     C     BPFAAM        ANDEQ     'Y'
     C     S#ACTN        ANDNE     'X'
     C     S#ACTN        ANDNE     'D'
 
      * If action code is insert
 
     C     S#ACTN        IFEQ      'I'
     C                   MOVE      W#SWRI        SWRI
     C                   MOVE      *BLANKS       AUTH
     C                   ENDIF
 
      * If action code is amend
 
     C     S#ACTN        IFEQ      'A'
     C     ORED          IFLT      BJRDNB
     C                   MOVE      W#SWRI        SWRI
     C                   MOVE      'Y'           AUTH
     C                   ELSE
     C     W#SWRI        IFEQ      'C'
     C     SWRI          ANDEQ     *BLANKS
     C                   MOVE      W#SWRI        SWRI
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
      * If action code is authorise
 
     C     S#ACTN        IFEQ      'X'
     C                   MOVE      SWRI          W#SWRI
     C                   MOVE      'Y'           AUTH
     C                   ENDIF
 
      * If action code is delete
 
     C     S#ACTN        IFEQ      'D'
     C     AUTH          IFEQ      *BLANKS
     C                   MOVE      *BLANKS       W#SWRI
     C                   ELSE
 
      * If work regeneration indicator is blank
 
     C     W#SWRI        IFEQ      *BLANKS
     C                   MOVE      SWRI          W#SWRI
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      * If work regeneration indicator is 'changed'
 
     C     W#SWRI        IFEQ      'C'
 
      * Check if the facility has an associated fee
 
     C                   MOVE      AAFACL        AAFACL            5
     C                   MOVEL     AMFACT        AAFACL
     C                   MOVE      AMFCNO        AAFACL
     C                   MOVE      AAFACL        WFFACL
     C**********         Z-ADD     0             WFLOAN                                       CLE148
     C                   MOVEL     *BLANK        WFLOAN                                       CLE148
     C     FEEK          SETLL     LEFEEDXX
     C     FEEK          READE     LEFEEDXX                               80
 
      * Do while an associated fee exists
 
     C     *IN80         DOWEQ     *OFF
 
      * If the fee is a confirmed calculated fee and swift
      * regeneration indicator is not 'I', 'B', 'H'
 
     C                   MOVE      FEAUTO        WAUTOC            1                          CLE134
     C     WAUTOC        IFEQ      'C'                                                        CLE134
     C     FEAUT2        OREQ      'C'                                                        CLE134
     C     CLE134        IFEQ      'Y'                                                        CLE134
     C                   MOVE      'Y'           WAUTOC            1                          CLE134
     C                   END                                                                  CLE134
     C                   END                                                                  CLE134
      *                                                                                       CLE134
     C*****FEAUTO        IFEQ      'Y'                                                        CLE134
     C     WAUTOC        IFEQ      'Y'                                                        CLE134
     C     FECALT        ANDNE     *BLANKS
     C     FESWRI        ANDNE     'I'
     C     FESWRI        ANDNE     'B'
     C     FESWRI        ANDNE     'H'
 
      * Set day to run date
      * Set currency to fee currency
      * Set number of working days to telex notice days
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   MOVE      FEFCCY        ZCCY
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    @OPTN
     C                   PARM      FEFCCY        @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   Z-ADD     A6TXND        ZNRDYS
 
      * If Fee Settlement type involves a nostro
 
     C     FESTTL        IFEQ      01
     C     FESTTL        OREQ      02
     C     FESTTL        OREQ      07
     C     FESTTL        OREQ      08
     C     FESTTL        OREQ      12
 
      ** Set location to nostro location
 
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CUSN             6
     C**********         PARM                    @ACCD             4                          CGL029
     C                   PARM      FEFCCY        @CYCD             3                          244719
     C                   PARM                    @ACCD            10                          CGL029
     C                   PARM                    @ACSN             2
     C                   PARM      FEOURS        @NONB             2
     C                   PARM                    @BRCA             3
     C                   PARM                    @CSSN            10
     C                   PARM                    @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANK        ZLOC
     C                   ELSE
     C                   MOVE      A7NOSN        ZLOC
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      *BLANKS       ZLOC
 
     C                   ENDIF
 
      * Calculate number of working days forward
 
     C                   EXSR      ZFWDT
 
      * Set Telex Notice date to day number
 
     C                   Z-ADD     ZDYNBR        TXDT              5 0
 
      * If next payment date is before or equals to Telex Notice date
      * and Next Payment Telex indicator is set to 'Y'
 
     C     FENPYD        IFLE      TXDT
     C     FEPPTI        ANDEQ     'Y'
 
      * Update Fees file
 
     C                   MOVE      'A'           FESWRI
     C                   UPDATE    LEFEEDF
     C                   ELSE
 
      * If end date is before or equals to Telex Notice date and End
      * Telex indicator is set to 'Y'
 
     C     FEPEND        IFLE      TXDT
     C     FEEPTI        ANDEQ     'Y'
 
      * Update Fees file
 
     C                   MOVE      'A'           FESWRI
     C                   UPDATE    LEFEEDF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C     FEEK          READE     LEFEEDXX                               80
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * UPDTRL   : Update trailer                                     *
      *****************************************************************
     C     UPDTRL        BEGSR
 
      ** Update trailer LEFCAMZZ
 
     C*****MTHREAD       IFEQ      'N'                                             MD024342 MD025467
     C*****1****         SETLL     LEFCAMZZ                                                 MD025467
     C**********         READ      LEFCAMZZ                             8080                MD025467
 
     C******IN80         IFEQ      *ON                                                      MD025467
     C**********         MOVEL     '*ERROR '     RetCodeIn                                  MD025467
     C**********         MOVEL     'LEFCAMZZ'    DBFILE                                     MD025467
     C**********         MOVEL     '801'         DBASE                                      MD025467
     C**********         MOVEL     '*FIRST'      DBKEY                                      MD025467
     C**********         EXSR      *PSSR                                                    MD025467
     C**********         ENDIF                                                              MD025467
     C**********         ENDIF                                                     MD024342 MD025467
      *
     C                   SELECT
 
      **  Inserts
     C     S#ACTN        WHENEQ    'I'
                                                                                   MD024342 MD025467
     C**********         IF        MTHREAD = 'Y'                                            MD024342
     C                   EXSR      Initialise                                               MD024342
     C**********         ENDIF                                                     MD024342 MD025467
 
     C                   ADD       1             NORE
     C                   ADD       1             NINS
     C                   ADD       1             NLRA
     C                   Z-ADD     W#AAMT        W#AAMT           13 0
     C     W#AAMT        DIV       1000          ZZAMT
     C                   Z-ADD     VIRF          ZZTOTI
     C                   Z-ADD     VIRL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VIRF
     C                   Z-ADD     ZZTOTD        VIRL
     C                   Z-ADD     VLAF          ZZTOTI
     C                   Z-ADD     VLAL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VLAF
     C                   Z-ADD     ZZTOTD        VLAL
 
      **  Amend
     C     S#ACTN        WHENEQ    'A'
      *                                                                            MD024342 MD025467
     C**********         IF        MTHREAD = 'Y'                                            MD024342
     C                   EXSR      Initialise                                               MD024342
     C**********         ENDIF                                                     MD024342 MD025467
 
     C                   ADD       1             NAMD
 
     C     P_AAMT        SUB       W#AAMT        WDIFF            13 0
     C     WDIFF         DIV       1000          ZZAMT
     C                   Z-ADD     VARF          ZZTOTI
     C                   Z-ADD     VARL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VARF
     C                   Z-ADD     ZZTOTD        VARL
 
      **  Delete
     C     S#ACTN        WHENEQ    'D'
      *                                                                                     MD024342
     C**********         IF        MTHREAD = 'Y'                                   MD024342 MD025467
     C                   EXSR      Initialise                                               MD024342
     C**********         ENDIF                                                     MD024342 MD025467
 
     C                   ADD       1             NDEL
     C                   SUB       1             NLRA
     C     W#AAMT        DIV       1000          ZZAMT
     C                   Z-ADD     VDRF          ZZTOTI
     C                   Z-ADD     VDRL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VDRF
     C                   Z-ADD     ZZTOTD        VDRL
     C                   Z-ADD     VLAF          ZZTOTI
     C                   Z-ADD     VLAL          ZZTOTD
     C                   EXSR      GLZSUB
     C                   Z-ADD     ZZTOTI        VLAF
     C                   Z-ADD     ZZTOTD        VLAL
 
     C                   ENDSL
 
     C**********         IF        MTHREAD = 'N'                                   MD024342 MD025467
     C**********         UPDATE    LEFCAMZF                                                 MD025467
     C**********         ELSE                                                      MD024342 MD025467
     C                   MOVEL     'D'           RECI                                       MD024342
     C**********         WRITE     LEFCAMZF                                       MD024342 MD024342B
     C**********         WRITE     LEFCAMZFX                                               MD024342B
     C                   WRITE     LEFCAMZF                                                 MD025467
     C**********         ENDIF                                                     MD024342 MD025467
 
     C                   ENDSR
      *****************************************************************                       CLE041
      /SPACE 5                                                                                CLE041
      *****************************************************************                       CLE041
      *                                                               *                       CLE041
      * SRChkFclt - Subroutine that will check and override proper    *                       CLE041
      *             facility files as per facility type (Aggregate/   *                       CLE041
      *             Non-Aggregate)                                    *                       CLE041
      *                                                               *                       CLE041
      *****************************************************************                       CLE041
     C     SRChkFclt     BEGSR                                                                CLE041
                                                                                              CLE041
     C                   EVAL      WAggregate = 'N'                                           CLE041
     C                   EVAL      KCNUM = AMCNUM                                             CLE041
     C                   EVAL      KFACT = AMFACT                                             CLE041
     C                   EVAL      KFCNO = AMFCNO                                             CLE041
     C                   EVAL      KRCTP = 'A'                                                CLE041
                                                                                              CLE041
     C     CHKFAC        CHAIN     FCLTY                                                      CLE041
                                                                                              CLE041
     C                   IF        NOT %FOUND(FCLTY)                                          CLE041
     C     CHKFAC        CHAIN     LEAGFCL0                                                   CLE041
     C                   IF        %FOUND(LEAGFCL0)                                           CLE041
     C                   EVAL      WAggregate = 'Y'                                           CLE041
     C                   ENDIF                                                                CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
      ** Override LEFCAMXX to LEAGAML2 (if aggregate) and to LEFCAML6 (if non-                CLE041
      ** aggregate)                                                                           CLE041
                                                                                              CLE041
     C                   IF        WAggregate = 'Y'                                           CLE041
     C                   EVAL      LENGTH = %SIZE(OVRDBF3)                                    CLE041
     C                   CALL      'QCMDEXC'                                                  CLE041
     C                   PARM      OVRDBF3       QCMD             70                          CLE041
     C                   PARM                    LENGTH           15 5                        CLE041
     C                   OPEN      LEFCAMXX                                                   CLE041
     C                   ELSE                                                                 CLE041
     C                   EVAL      LENGTH = %SIZE(OVRDBF1)                                    CLE041
     C                   CALL      'QCMDEXC'                                                  CLE041
     C                   PARM      OVRDBF1       QCMD             70                          CLE041
     C                   PARM                    LENGTH           15 5                        CLE041
     C                   OPEN      LEFCAMXX                                                   CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
     C                   ENDSR                                                                CLE041
      *****************************************************************                       CLE041
      /SPACE 5                                                                                CLE041
      *****************************************************************                       CLE041
      * UpdTrlAg : Update trailer(Aggregated Facilities)              *                       CLE041
      *****************************************************************                       CLE041
     C     UpdTrlAg      BEGSR                                                                CLE041
                                                                                              CLE041
      ** Update trailer LEAGAMZZ                                                              CLE041
                                                                                              CLE041
     C     1             SETLL     LEAGAMZZ                                                   CLE041
     C                   READ      LEAGAMZZ                             8080                  CLE041
                                                                                              CLE041
     C     *IN80         IFEQ      *ON                                                        CLE041
     C                   EVAL      RetCodeIn = '*ERROR '                                      CLE041
     C                   EVAL      DBFILE    = 'LEAGAMZZ'                                     CLE041
     C                   EVAL      DBASE     = 801                                            CLE041
     C                   EVAL      DBKEY     = '*FIRST'                                       CLE041
     C                   EXSR      *PSSR                                                      CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
     C                   EVAL      W#AAMT = AAMT                                              CLE041
     C                   SELECT                                                               CLE041
                                                                                              CLE041
      ** Inserts                                                                              CLE041
                                                                                              CLE041
     C                   WHEN      S#ACTN = 'I'                                               CLE041
                                                                                              CLE041
     C                   EVAL      AGFC_NORE = AGFC_NORE + 1                                  CLE041
     C                   EVAL      AGFC_NINS = AGFC_NINS + 1                                  CLE041
     C                   EVAL      AGFC_NLRA = AGFC_NLRA + 1                                  CLE041
     C                   EVAL      ZZAMT = W#AAMT/1000                                        CLE041
     C                   EVAL      ZZTOTI = AGFC_VIRF                                         CLE041
     C                   EVAL      ZZTOTD = AGFC_VIRL                                         CLE041
     C                   EXSR      GLZADD                                                     CLE041
     C                   EVAL      AGFC_VIRF = ZZTOTI                                         CLE041
     C                   EVAL      AGFC_VIRL = ZZTOTD                                         CLE041
     C                   EVAL      ZZTOTI = AGFC_VLAF                                         CLE041
     C                   EVAL      ZZTOTD = AGFC_VLAL                                         CLE041
     C                   EXSR      GLZADD                                                     CLE041
     C                   EVAL      AGFC_VLAF = ZZTOTI                                         CLE041
     C                   EVAL      AGFC_VLAL = ZZTOTD                                         CLE041
                                                                                              CLE041
      ** Amend                                                                                CLE041
                                                                                              CLE041
     C                   WHEN      S#ACTN = 'A'                                               CLE041
                                                                                              CLE041
     C                   EVAL      AGFC_NAMD = AGFC_NAMD + 1                                  CLE041
                                                                                              CLE041
     C                   EVAL      WDIFF = P_AAMT - W#AAMT                                    CLE041
     C                   EVAL      ZZAMT = WDIFF / 1000                                       CLE041
     C                   EVAL      ZZTOTI = AGFC_VARF                                         CLE041
     C                   EVAL      ZZTOTD = AGFC_VARL                                         CLE041
     C                   EXSR      GLZADD                                                     CLE041
     C                   EVAL      AGFC_VARF = ZZTOTI                                         CLE041
     C                   EVAL      AGFC_VARL = ZZTOTD                                         CLE041
                                                                                              CLE041
      ** Delete                                                                               CLE041
                                                                                              CLE041
     C                   WHEN      S#ACTN = 'D'                                               CLE041
                                                                                              CLE041
     C                   EVAL      AGFC_NDEL = AGFC_NDEL + 1                                  CLE041
     C                   EVAL      AGFC_NLRA = AGFC_NLRA - 1                                  CLE041
     C                   EVAL      ZZAMT = W#AAMT / 1000                                      CLE041
     C                   EVAL      ZZTOTI = AGFC_VDRF                                         CLE041
     C                   EVAL      ZZTOTD = AGFC_VDRL                                         CLE041
     C                   EXSR      GLZADD                                                     CLE041
     C                   EVAL      AGFC_VDRF = ZZTOTI                                         CLE041
     C                   EVAL      AGFC_VDRL = ZZTOTD                                         CLE041
     C                   EVAL      ZZTOTI = AGFC_VLAF                                         CLE041
     C                   EVAL      ZZTOTD = AGFC_VLAL                                         CLE041
     C                   EXSR      GLZSUB                                                     CLE041
     C                   EVAL      AGFC_VLAF = ZZTOTI                                         CLE041
     C                   EVAL      AGFC_VLAL = ZZTOTD                                         CLE041
                                                                                              CLE041
     C                   ENDSL                                                                CLE041
                                                                                              CLE041
     C                   UPDATE    LEAGAMZF                                                   CLE041
                                                                                              CLE041
     C                   ENDSR                                                                CLE041
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  GLZADD  -  Add an amount to the total                        *
      *****************************************************************
     C     GLZADD        BEGSR
      *
     C     ZZAMT         IFNE      0
      *
      ** Split ZZAMT into integer and decimal fields
      *
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0
     C                   MOVE      ZZAMT         ZZAMTD            3 0
      *
      ** Both ZZAMTI and ZZAMTD contain a 'sign' zone now
      *
     C                   EXSR      GLZSUM
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  GLZSUB  -  Subroutine to subtract an amount to the total     *
      *****************************************************************
     C     GLZSUB        BEGSR
      *
      ** Processing - Just reverse the 'sign' and add
      *
     C                   Z-SUB     ZZAMT         ZZAMT            15 3
     C                   EXSR      GLZADD
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  GLZSUM  -  Carry out the additon for subroutine              *
      *****************************************************************
     C     GLZSUM        BEGSR
      *
     C                   Z-ADD     ZZTOTI        ZZTOTI           15 0
     C                   Z-ADD     ZZTOTD        ZZTOTD            3 0
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599
      *
      ** Determine sign of ZZAMTI & D,  92 if neg
      *
     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND
      *
      ** Determine sign of ZZTOTI & D, 91 if neg
      *
     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193
      *
      ** If ZZTOTAL is zero, return ZZAMOUNT
      *
     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND
      *
      ** If signs differ, bypass overflow checks
      *
     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
      *
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     C     ZZWK2         COMP      999                                93
     C  N93ZZWK2         COMP      -999                                 93
      *
     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
      *
      ** If the modulus of ZZWK3 is lt mod. ZZTOTI then O/F has occured
      *
     C  N92ZZWK3         COMP      ZZTOTI                               99
     C   92ZZWK3         COMP      ZZTOTI                             99
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI
      *
      ** If O/F zeroise ZZAMT, Ind '99' set and ZZTOT fields left intact
      *
     C   99              Z-ADD     0             ZZAMT            15 3
     C                   GOTO      ZZSEND
      *
      ** The 'signs' are different
      *
     C     ZZOFPS        TAG
      *
      * If ZZAMT was negative, make it pos. to como with ZZTOT
      *
     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0
      *
      ** If ZZTOT was negative, make it pos. to comp with ZZAMT.
      *
     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD
      *
      ** Both ZZAMT and ZZTOT are now positive
      *
     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95
      *
      ** If ZZTOT eq. ZZAMT return ZERO.
      *
     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND
      *
      ** If ZZTOT gt. ZZAMT.
      *
     C   93ZZAMTD        COMP      ZZTOTD                             94
     C   93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     C   93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C   93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     C   93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
      *
      ** If ZZAMT gt. ZZTOT.
      *
     C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     C  N93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     C  N93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     C  N93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C  N93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     C  N93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
      *
      ** Reverse sign of ZZTOT if larger I/P fields were negative
      *
     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD
      *
      ** Restore sign of ZZAMTI & ZZAMTD if it was reversed
      *
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
     C     ZZSEND        TAG
      *
      **   If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD.
      *
     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD            5
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
     C     ZDATE1        BEGSR
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      'N'           ErrorFlag         1
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
     C     ZFWDT         BEGSR
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZNRDYS            2 0
     C                   PARM                    ZDYNBR            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                BUG4555
      *****************************************************************                     BUG4555
      *                                                               *                     BUG4555
      * SRWatch - Initiates the Midas Compliance Engine.              *                     BUG4555
      *                                                               *                     BUG4555
      *****************************************************************                     BUG4555
                                                                                            BUG4555
     C     SRWatch       BEGSR                                                              BUG4555
                                                                                            BUG4555
      ** Initialise the Transaction Details parameter.                                      BUG4555
                                                                                            BUG4555
     C                   CLEAR                   SDWLTD                                     BUG4555
                                                                                            BUG4555
      ** Setup First Parameter                                                              BUG4555
                                                                                            BUG4555
      ** Item Type Code                                                                     BUG4555
     C                   EVAL      W4ITEM = 'LEFCAM'                                        BUG4555
      *                                                                                     BUG4555
     C                   MOVEL     '/'           Wrk3              3                        BUG4555
     C                   MOVE      FCNO          Wrk3                                       BUG4555
     C                   MOVEL     FACT          FCNbr             6                        BUG4555
     C                   MOVE      Wrk3          FCNbr                                      BUG4555
     C                   MOVEL     CNUM          FIdentfr         13                        BUG4555
     C                   MOVE      FCNbr         FIdentfr                                   BUG4555
     C                   EVAL      W4IDEN = FIdentfr                                        BUG4555
      *                                                                                     BUG4555
     C                   EVAL      W4BRCH = BRCA                                            BUG4555
      *                                                                                     BUG4555
     C                   IF        CSC011 = 'Y'                                             BUG4555
     C                   EVAL      W4SYSM = S1MAIN                                          BUG4555
     C                   ELSE                                                               BUG4555
     C                   EVAL      W4SYSM = LIBR                                            BUG4555
     C                   ENDIF                                                              BUG4555
                                                                                            BUG4555
     C                   EVAL      W4FUNT = 'LEFCAMPD'                                      BUG4555
                                                                                            BUG4555
     C                   MOVEL     CNUM          PCUST                                      BUG4555
     C                   CALLB     'AOCUSTR0'                                               BUG4555
     C                   PARM      *BLANKS       PRTCD                                      BUG4555
     C                   PARM      '*KEY'        POPTN                                      BUG4555
     C                   Parm                    PCUST                                      BUG4555
     C                   PARM      *BLANKS       PSTKEY                                     BUG4555
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG4555
                                                                                            BUG4555
     C                   IF        PRTCD <> *BLANKS                                         BUG4555
     C                             AND PRTCD <> '*NRF   '                                   BUG4555
     C                   EVAL      DBKEY = POPTN                                            BUG4555
     C                   EVAL      DBFILE = 'SDCUSTPD'                                      BUG4555
     C                   EVAL      DBASE = 908                                              BUG4555
     C                   EXSR      *PSSR                                                    BUG4555
     C                   ENDIF                                                              BUG4555
                                                                                            BUG4555
     C                   MOVE      CNUM          W4CNUM                                     BUG4555
                                                                                            BUG4555
      ** Determine Counterparty Type                                                        BUG4555
                                                                                            BUG4555
     C                   IF        CCF001 = 'Y' AND                                         BUG4555
     C                             BBCRPC = 'Y'                                             BUG4555
     C                   EVAL      W4CTYP = 'C'                                             BUG4555
     C                   ELSE                                                               BUG4555
     C                   EVAL      W4CTYP = 'I'                                             BUG4555
     C                   ENDIF                                                              BUG4555
                                                                                            BUG4555
     C                   EVAL      W4CUST = BBCRNM + BBCRTN                                 BUG4555
                                                                                            BUG4555
      ** Convert Dates                                                                      BUG4555
                                                                                            BUG4555
     C                   MOVE      '0001-01-01'  W4DDAT                                     BUG4555
     C                   MOVE      VLDT          PZADayNo                                   BUG4555
     C                   EXSR      SRDateToDDT                                              BUG4555
     C                   EVAL      W4DDAT = WDDT                                            BUG4555
                                                                                            BUG4555
     C                   MOVE      '0001-01-01'  W4VDAT                                     BUG4555
     C                   MOVE      VLDT          PZADayNo                                   BUG4555
     C                   EXSR      SRDateToDDT                                              BUG4555
     C                   EVAL      W4VDAT = WDDT                                            BUG4555
                                                                                            BUG4555
     C                   MOVE      '0001-01-01'  W4MDAT                                     BUG4555
     C                   MOVE      NDEX          PZADayNo                                   BUG4555
     C                   EXSR      SRDateToDDT                                              BUG4555
     C                   EVAL      W4MDAT = WDDT                                            BUG4555
                                                                                            BUG4555
     C                   EVAL      W4DEN1 = ACCY                                            BUG4555
     C                   EVAL      W4DEN2 = *BLANKS                                         BUG4555
                                                                                            BUG4555
     C                   EVAL      W4AMT1 = AAMT                                            BUG4555
     C                   EVAL      W4AMT2 = 0                                               BUG4555
                                                                                            BUG4555
      ** Build the free format string (2nd parameter)                                       BUG4555
                                                                                            BUG4555
     C                   EVAL      Ctr = 1                                                  BUG4555
     C                   EVAL      PFreeFmtStr = *BLANKS                                    BUG4555
     C                   EVAL      WXMLPacket = *BLANKS                                     BUG4555
     C                   EVAL      WData = *BLANKS                                          BUG4555
     C                   MOVEL     W4CUST        WLF(1)                                     BUG4555
                                                                                            BUG4555
     C                   DOU       Ctr >= Elements                                          BUG4555
                                                                                            BUG4555
     C                   IF        WLF(Ctr) <> *BLANKS                                      BUG4555
     C                             AND WLF(Ctr) <> '000000'                                 BUG4555
                                                                                            BUG4555
     C                   EVAL      PFmtCCY = ACCY                                           BUG4555
                                                                                            BUG4555
     C                   CALL      'SDCWLFMT'                                               BUG4555
     C                   PARM                    PRTCD                                      BUG4555
     C                   PARM                    WLF(Ctr)                                   BUG4555
     C                   PARM                    PDummy35                                   BUG4555
     C                   PARM                    PDummy35                                   BUG4555
     C                   PARM                    PDummy35                                   BUG4555
     C                   PARM                    PDummy35                                   BUG4555
     C                   PARM                    PDummy35                                   BUG4555
     C                   PARM                    PFmtCCY                                    BUG4555
     C                   PARM                    WData                                      BUG4555
     C                   PARM                    PDummy6                                    BUG4555
                                                                                            BUG4555
     C                   CAT       XOT(Ctr):0    WXMLPacket                                 BUG4555
     C                   CAT       WData:0       WXMLPacket                                 BUG4555
                                                                                            BUG4555
     C                   CAT       XCT(Ctr):0    WXMLPacket                                 BUG4555
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                BUG4555
                                                                                            BUG4555
     C                   EVAL      WXMLPacket = *BLANKS                                     BUG4555
     C                   EVAL      WData = *BLANKS                                          BUG4555
     C                   ENDIF                                                              BUG4555
                                                                                            BUG4555
     C                   EVAL      Ctr = Ctr + 1                                            BUG4555
     C                   ENDDO                                                              BUG4555
                                                                                            BUG4555
      ** Check for compliance.                                                              BUG4555
                                                                                            BUG4555
     C                   CALL      'SDCWLCHK'                                               BUG4555
     C                   PARM                    SDWLTD                                     BUG4555
     C                   PARM                    PFreeFmtStr                                BUG4555
                                                                                            BUG4555
     C                   ENDSR                                                              BUG4555
      *****************************************************************                     BUG4555
      /EJECT                                                                                BUG4555
      *****************************************************************                     BUG4555
      *                                                               *                     BUG4555
      * SRDateToDDT - Converts a date into Date Data Type format.     *                     BUG4555
      *                                                               *                     BUG4555
      *****************************************************************                     BUG4555
                                                                                            BUG4555
     C     SRDateToDDT   BEGSR                                                              BUG4555
                                                                                            BUG4555
      ** Convert the derived Midas Day Number into Date Data Type.                          BUG4555
                                                                                            BUG4555
     C                   CALL      'ZACVTDATE'                                              BUG4555
     C                   PARM      *BLANKS       PZARtCd                                    BUG4555
     C                   PARM                    PZADayNo                                   BUG4555
     C                   PARM                    PZADDT                                     BUG4555
     C                   PARM                    PZACvtDt                                   BUG4555
                                                                                            BUG4555
     C                   EVAL      WDDT = PZADDT                                            BUG4555
                                                                                            BUG4555
     C                   ENDSR                                                              BUG4555
                                                                                            BUG4555
      *****************************************************************                     MD024342
      /EJECT                                                                                MD024342
      *****************************************************************                     MD024342
      * Initialise - Initialise trailer fields                        *                     MD024342
      *****************************************************************                     MD024342
     C     Initialise    BEGSR                                                              MD024342
      *                                                                                     MD024342
     C                   EVAL      NORE = 0                                                 MD024342
     C                   EVAL      NINS = 0                                                 MD024342
     C                   EVAL      NAMD = 0                                                 MD024342
     C                   EVAL      NDEL = 0                                                 MD024342
     C                   EVAL      NLRB = 0                                                 MD024342
     C                   EVAL      NLRA = 0                                                 MD024342
     C                   EVAL      VIRF = 0                                                 MD024342
     C                   EVAL      VIRL = 0                                                 MD024342
     C                   EVAL      VARF = 0                                                 MD024342
     C                   EVAL      VARL = 0                                                 MD024342
     C                   EVAL      VDRF = 0                                                 MD024342
     C                   EVAL      VDRL = 0                                                 MD024342
     C                   EVAL      VLBF = 0                                                 MD024342
     C                   EVAL      VLBL = 0                                                 MD024342
     C                   EVAL      VLAF = 0                                                 MD024342
     C                   EVAL      VLAL = 0                                                 MD024342
      *                                                                                     MD024342
     C                   ENDSR                                                              MD024342
     C****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Action Code
     C                   PARM                    S#ACTN            1
 
      * Facility Amendment details in file format
     C                   PARM                    LEVFAMDPD
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    FAMD_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Wx                3 0
 
      * Sequence assigned
     C                   PARM                    A_SQNO            3
 
      *
      ** Access Bank details
      *  ~~~~~~~~~~~~~~~~~~~
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CLE002 - Lending Authorisations - is Installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      'CLE002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CLE002
     C                   ELSE
     C                   MOVEL     'N'           CLE002            1
     C                   ENDIF
 
      ** Retrieve customer lending data, if CLE002 is Installed
 
     C     CLE002        IFEQ      'Y'
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDCLNDPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check if CLE009 - Customer Lending Enhancements - is Installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      'CLE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      'CLE009'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE009            1
     C                   ELSE
     C                   MOVE      'N'           CLE009
     C                   ENDIF
     C                   ENDIF
 
      *                                                                                       CLE134
      ** CLE134 - Past Due Call loans                                                         CLE134
      *                                                                                       CLE134
     C                   CALL      'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       @RTCD                                        CLE134
     C                   PARM      '*KEY    '    @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD             6                          CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
      *                                                                                       CLE134
     C     @RTCD         IFEQ      *BLANKS                                                    CLE134
     C                   MOVEL     'Y'           CLE134                                       CLE134
     C                   ELSE                                                                 CLE134
     C                   MOVEL     'N'           CLE134            1                          CLE134
     C                   ENDIF                                                                CLE134
 
      **If*the*user*is*connected*via*a*browser,*the*job*user*name*is*QUSER -          CAP084 BUG6318
      **their*user*name*is*stored*in*ZMUSER                                           CAP084 BUG6318
     C**********         IN        ZMUSER                                             CAP084 BUG6318
 
     C     *LIKE         DEFINE    CNUM          K#CNUM
     C     *LIKE         DEFINE    FACT          K#FACT
     C     *LIKE         DEFINE    FCNO          K#FCNO
     C     *LIKE         DEFINE    VLDT          K#VLDT
     C     *LIKE         DEFINE    SQNO          K#SQNO
 
      * Key lists
 
     C     FCAMK         KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#VLDT
     C                   KFLD                    K#SQNO
     C     FCAMKV        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#VLDT
     C     FEEK          KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    WFFACL            5 0
     C**********         KFLD                    WFLOAN            6 0                        CLE148
     C                   KFLD                    WFLOAN            6                          CLE148
      *                                                                                     BUG4555
     C     KCwFld        KLIST                                                              BUG4555
     C                   KFLD                    WFuncType                                  BUG4555
     C                   KFLD                    WIdntifier                                 BUG4555
     C                   KFLD                    WBranch                                    BUG4555
     C     CHKFAC        KLIST                                                                CLE041
     C                   KFLD                    KCNUM                                        CLE041
     C                   KFLD                    KFACT                                        CLE041
     C                   KFLD                    KFCNO                                        CLE041
     C                   KFLD                    KRCTP                                        CLE041
      *                                                                                     MD024342
     C*****KAPILST       KLIST                                                     MD024342 MD025467
     C**********         KFLD                    WAPIC             4               MD024342 MD025467
     C**********         KFLD                    WFILN            10               MD024342 MD025467
                                                                                              CLE041
      ** Do not perform override yet                                                          CLE041
      *****************************************************************                       CLE041
      ***OVRDBF*LEFCAML6*to*LEFCAMXX*then*OPEN*LEFCAMXX****************                       CLE041
      *****************************************************************                       CLE041
     C**********         EVAL      LENGTH = %SIZE(OVRDBF1)                                    CLE041
     C**********         CALL      'QCMDEXC'                                                  CLE041
     C**********         PARM      OVRDBF1       QCMD             70                          CLE041
     C**********         PARM                    LENGTH           15 5                        CLE041
     C**********         OPEN      LEFCAMXX                                                   CLE041
 
      ** OVRDBF LEFEEDL2 to LEFEEDXX then OPEN LEFEEDXX
 
     C                   EVAL      LENGTH = %SIZE(OVRDBF2)
     C                   CALL      'QCMDEXC'
     C                   PARM      OVRDBF2       QCMD             70
     C                   PARM                    LENGTH           15 5
     C                   OPEN      LEFEEDXX
 
      ** Check if CSC011 is installed
      ** CSC011 is a redundant feature. No need to check                                    MD024398
 
     C**********         CALLB     'AOSARDR0'                                               MD024398
     C**********         PARM      *BLANKS       PRTCD                                      MD024398
     C**********         PARM      '*VERIFY'     POPTN                                      MD024398
     C**********         PARM      'CSC011'      PSARD                                      MD024398
     C*****SCSARD        PARM      SCSARD        DSFDY                                      MD024398
      **********                                                                            MD024398
     C**********         IF        PRTCD = *Blanks                                          MD024398
      **********                                                                            MD024398
     C**********         EVAL      CSC011 = 'Y'                                             MD024398
      **********                                                                            MD024398
     C**********         IN        SC24X7                                                   MD024398
     C**********         IN        SDSTAT                                                   MD024398
      **********                                                                            MD024398
     C**********         ELSE                                                               MD024398
      **********                                                                            MD024398
      ***Database*error************************************************                     MD024398
      **********                                                                            MD024398
     C**********         IF        PRTCD <> '*NRF'                                          MD024398
     C**********         MOVEL     '*ERROR '     RetCodeIn                                  MD024398
     C**********         EVAL      DBKEY = 'CSC011'                                         MD024398
     C**********         EVAL      DBFILE = 'SCSARDPD'                                      MD024398
     C**********         EVAL      DBASE = 905                                              MD024398
     C**********         EXSR      *PSSR                                                    MD024398
     C**********         ENDIF                                                              MD024398
 
      ** Access SAR details to see if CSD015 is switched on.                                BUG4555
      *                                                                                     BUG4555
     C                   IN        SDSTAT                                                   BUG4555
      *                                                                                     BUG4555
     C                   CALL      'AOSARDR0'                                               BUG4555
     C                   PARM      *BLANKS       PRetCode                                   BUG4555
     C                   PARM      '*VERIFY'     POption                                    BUG4555
     C                   PARM      'CSD015'      PSARD                                      BUG4555
     C     SCSARD        PARM      *BLANKS       DSFDY                                      BUG4555
                                                                                            BUG4555
     C                   IF        PRetCode = *BLANKS                                       BUG4555
                                                                                            BUG4555
     C                   EVAL      CSD015 = 'Y'                                             BUG4555
     C                   ELSE                                                               BUG4555
                                                                                            BUG4555
     C                   IF        PRetCode <> '*NRF'                                       BUG4555
     C     *LOCK         IN        LDA                                                      BUG4555
     C                   EVAL      DBKey = 'CSD015'                                         BUG4555
     C                   EVAL      DBFile = 'SCSARDPD'                                      BUG4555
     C                   EVAL      DBase = 903                                              BUG4555
     C                   OUT       LDA                                                      BUG4555
     C                   EXSR      *PSSR                                                    BUG4555
     C                   ENDIF                                                              BUG4555
                                                                                            BUG4555
     C                   ENDIF                                                              BUG4555
                                                                                            BUG4555
     C                   IF        CSD015 = 'Y'                                             BUG4555
                                                                                            BUG4555
      ** Check if transactions are being monitored by Compliance Watch.                     BUG4555
                                                                                            BUG4555
     C                   CALL      'AOWLCCR0'                                               BUG4555
     C                   PARM      *BLANKS       PRetCode                                   BUG4555
     C                   PARM      '*KEY   '     POption                                    BUG4555
     C                   PARM      'LENDING '    PFunc                                      BUG4555
     C     SDWLCC        PARM      SDWLCC        DSFDY                                      BUG4555
                                                                                            BUG4555
     C                   IF        PRetCode <> *BLANKS AND                                  BUG4555
     C                             PRetCode <> '*NRF'                                       BUG4555
     C     *LOCK         IN        LDA                                                      BUG4555
     C                   EVAL      DBKey = 'LENDING'                                        BUG4555
     C                   EVAL      DBFile = 'SDWLCCPD'                                      BUG4555
     C                   EVAL      DBase = 904                                              BUG4555
     C                   OUT       LDA                                                      BUG4555
     C                   EXSR      *PSSR                                                    BUG4555
     C                   ENDIF                                                              BUG4555
                                                                                            BUG4555
     C                   CALL      'AOCWCDR0'                                               BUG4555
     C                   PARM      *BLANKS       PRetCode                                   BUG4555
     C                   PARM      '*FIRST '     POption                                    BUG4555
     C     SDCWCD        PARM      SDCWCD        DSSDY                                      BUG4555
                                                                                            BUG4555
     C                   IF        PRetCode <> *BLANKS                                      BUG4555
     C     *LOCK         IN        LDA                                                      BUG4555
     C                   EVAL      DBKey = POption                                          BUG4555
     C                   EVAL      DBFile = 'SDCWCDPD'                                      BUG4555
     C                   EVAL      DBase = 905                                              BUG4555
     C                   OUT       LDA                                                      BUG4555
     C                   EXSR      *PSSR                                                    BUG4555
     C                   ENDIF                                                              BUG4555
                                                                                            BUG4555
     C                   ENDIF                                                              BUG4555
                                                                                            BUG4555
      ** Access SAR details to see if CCF001 is switched on.                                BUG4555
                                                                                            BUG4555
     C                   CALL      'AOSARDR0'                                               BUG4555
     C                   PARM      *BLANKS       PRetCode                                   BUG4555
     C                   PARM      '*VERIFY'     POption                                    BUG4555
     C                   PARM      'CCF001'      PSARD                                      BUG4555
     C     SCSARD        PARM      *BLANKS       DSFDY                                      BUG4555
                                                                                            BUG4555
     C                   IF        PRetCode = *BLANKS                                       BUG4555
                                                                                            BUG4555
     C                   EVAL      CCF001 = 'Y'                                             BUG4555
     C                   ELSE                                                               BUG4555
                                                                                            BUG4555
     C                   IF        PRetCode <> '*NRF'                                       BUG4555
     C     *LOCK         IN        LDA                                                      BUG4555
     C                   EVAL      DBKey = 'CCF001'                                         BUG4555
     C                   EVAL      DBFile = 'SCSARDPD'                                      BUG4555
     C                   EVAL      DBase = 907                                              BUG4555
     C                   OUT       LDA                                                      BUG4555
     C                   EXSR      *PSSR                                                    BUG4555
     C                   ENDIF                                                              BUG4555
                                                                                            BUG4555
     C                   ENDIF                                                              BUG4555
     C**********         ENDIF                                                              MD024398
                                                                                              CAP086
      ** Check if CAP086 is enabled                                                           CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       PRtCd                                        CAP086
     C                   PARM      '*VERIFY'     POptn                                        CAP086
     C                   PARM      'CAP086'      PSARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        PRtCd = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ELSE                                                                 CAP086
                                                                                              CAP086
     C                   IF        PRtCd <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBase = 22                                                 CAP086
     C                   EVAL      DBKey = 'CAP086'                                           CAP086
     C                   OUT       LDA                                                        CAP086
     C*                  EXSR      SRErr                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRtCd                                        CSD083
     C                   PARM      '*VERIFY'     POptn                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRtCd <> *BLANKS AND                                       CSD083
     C                             PRtCd <> '*NRF'                                            CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 23                                                 CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C*                  EXSR      SRErr                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRtCd = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
      *                                                                                     MD024342
      ** Get MPHAS dataarea.                                                                MD024342
      *                                                                                     MD024342
     C******DTAARA       DEFINE                  MPHAS                             MD024342 MD025467
     C**********         IN        MPHAS                                           MD024342 MD025467
     C**********         UNLOCK    MPHAS                                           MD024342 MD025467
      *                                                                                     MD024342
     C**********         MOVEL     FRNT          W#FRNT                            MD024342 MD025467
      *                                                                                     MD024342
     C**********         MOVEL     'N'           MTHREAD           1               MD024342 MD025467
     C**********         MOVE      'FAMD'        WAPIC                             MD024342 MD025467
     C**********         MOVEL     'LEFCAMZZ'    WFILN                             MD024342 MD025467
      *                                                                                     MD024342
     C**********         IF        MPHAS = 'A' AND                                 MD024342 MD025467
     C**********                   W#FRNT <> 'LE000473'                            MD024342 MD025467
     C*****KAPILST       CHAIN     SDAPDRL0                           99           MD024342 MD025467
     C******IN99         IFEQ      '0'                                             MD024342 MD025467
     C**********         MOVEL     A8MULT        MTHREAD                           MD024342 MD025467
     C**********         ENDIF                                                     MD024342 MD025467
     C**********         ENDIF                                                     MD024342 MD025467
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      */****COPY**ZACPYSRC,PSSR_ILE                                                           CAP084
      /COPY ZACPYSRC,PSSR_ILENE                                                               CAP084
     C                   MOVEL     'ERROR'       RetCodeIn                                    CAP084
     C                   RETURN                                                               CAP084
                                                                                              CAP084
     C                   ENDSR                                                                CAP084
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
** XOT - OPEN TAGS for XML                                                                  BUG4555
<Customer>                                                                                  BUG4555
** XCT - CLOSE TAGS for XML                                                                 BUG4555
</Customer>                                                                                 BUG4555
