     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fac. Exposure Upd for todays RE postings')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000037 - Midas LE Facility Exposure Update for todays      *
      *             Retail postings                                   *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD061267  *CREATE  Date 26Jul23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061267 - Credit Lines (CLE025) fixes.                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *    81 - Default percentage to 100                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index                                             *
      *                                                               *
      * *INZSR    - Initialise                                        *
      * SR_PrAcct - Process Account Details                           *
      * SR_GtSupD - Get Supplementary Details                         *
      * SR_PrCalc - Process Calculations                              *
      * SR_PrTrnc - Process Tranche Facility                          *
      * SR_CnvCcy - Convert Currency                                  *
      * SR_GtCurr - Get Currency Details                              *
      * SR_Cnvrt  - Convert amount to another currency                *
      * SR_GtXRat - Get exchange rate                                 *
      * *PSSR     - Error processing                                  *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      * Midas LE Facilities detail B record
     FFCLTYFM   IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(Fm_)

      * Midas LE Facilities detail B record
     FFCLTYL5   UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

      * Midas LE Facilities Ext File by branch
     FLEFCLTLH  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

      * Midas GL Account details by facility
     FACCNTLA   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(Ac_)

      * Midas RE Gen. Entries for RE Keyed on Acct & ValDt
     FRESEODL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(Rs_)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
      **---------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Facilities Key
     D                 DS
     D Ky_FCLT                 1     11A
     D  K_CNum                 1      6A
     D  K_FacT                 7      9S 0
     D  KAFacT                 7      9A
     D  K_FcNo                10     11S 0
     D  KAFcNo                10     11A

     D WIAM            S             15  0
     D reWIAM          S             15  0
     D wrkWIAM         S             15  0
     D WSOA            S             13  0
     D WSOF            S             13  0
     D crOAM1          S             13  0
     D crCAMD          S             13  0
     D crCEXP          S             13  0
     D crPEXP          S             13  0
     D wrkOAM1         S             13  0
     D wrkCAMD         S             13  0
     D wrkCEXP         S             13  0
     D wrkPEXP         S             13  0

      * DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      * DS for access programs, long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)

      * Data structure for Account Codes
     D SDACOD        E DS                  EXTNAME(SDACODPD)

      * Data structure for Instruments Types
     D SDPLIN        E DS                  EXTNAME(SDPLINPD)

      * Data structure for Weighing Code
     D GPWEIG        E DS                  EXTNAME(GPWEIGPD)
     D  PL_ICD       E                     EXTFLD(PDLCD)
     D  PL_WEIG      E                     EXTFLD(PDWEIG)

      * Data structure for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      * Data structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      * Data structure for Switchable features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      * Data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

     ** +--------------------------------------+
     ** ¦ Declared variables                   ¦
     ** ¦ ==================                   ¦
     ** +--------------------------------------+

     D P_ACod          S             10
     D P_Inmr          S              3
     D P_Weig          S              2
     D P_CNum          S             10
     D P_Curr          S              3
     D P_KYST          S              7

     D K_VUDT          S              5  0
     D WFLAG           S              1A

     D ZAMTCI          S             15  0
     D ZAMTCO          S             15  0
     D ZEXCH           S             13  8
     D ZRATEX          S             13  8
     D ZRATE1          S             13  8
     D ZRATE2          S             13  8
     D ZMD             S              1
     D ZMDIX           S              1
     D ZMDI1           S              1
     D ZMDI2           S              1
     D ZCCYI           S              3
     D ZCCYO           S              3
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      * Read through Facilities Details
      *
     C                   READ      FCLTYFM
      *
     C                   DOW       NOT %EOF(FCLTYFM)
      *
      * Process Account details
      * Update today's facility exposure if status is live/active;
      * also if facility is expired today to align with LE000030 rerun
      * to generate retail account movements
      *
     C                   IF        (Fm_RECI = 'D')
     C                             OR (Fm_RECI = 'E' AND Fm_DTEX >= BJRDNB
     C                             AND Fm_DTEX < BJDNWD)
     C                   EXSR      SR_PrAcct
     C                   ENDIF
      *
     C                   READ      FCLTYFM
     C                   ENDDO
      *
      * Commit changes
      *
     C                   COMMIT
      *
      * End of Program
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR -  Program intialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Key List
      *
     C     KyFclQ        KLIST
     C                   KFLD                    K_CNum
     C                   KFLD                    KAFacT
     C                   KFLD                    KAFcNo
      *
     C     KyFcl1        KLIST
     C                   KFLD                    K_CNum
     C                   KFLD                    K_FacT
     C                   KFLD                    K_FcNo
      *
     C     KyAcc1        KLIST
     C                   KFLD                    Ac_BRCA
     C                   KFLD                    Ac_CNUM
     C                   KFLD                    Ac_CCY
     C                   KFLD                    Ac_ACOD
     C                   KFLD                    Ac_ACSQ
      *
     C     KyAcc2        KLIST
     C                   KFLD                    Ac_BRCA
     C                   KFLD                    Ac_CNUM
     C                   KFLD                    Ac_CCY
     C                   KFLD                    Ac_ACOD
     C                   KFLD                    Ac_ACSQ
     C                   KFLD                    K_VUDT
      *
     C     KyRec1        KLIST
     C                   KFLD                    Ac_CNUM
     C                   KFLD                    Ac_CCY
     C                   KFLD                    Ac_ACOD
     C                   KFLD                    Ac_ACSQ
     C                   KFLD                    Ac_BRCA
      *
     C     KyRec2        KLIST
     C                   KFLD                    Ac_CNUM
     C                   KFLD                    Ac_CCY
     C                   KFLD                    Ac_ACOD
     C                   KFLD                    Ac_ACSQ
     C                   KFLD                    Ac_BRCA
     C                   KFLD                    K_VUDT
      *
      * Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
      *
     C                   IF        @RtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000037'
     C                   EVAL      DBKey = @Optn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 11
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_PrAcct - Process Account Details                           *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: SR_GtSupD, SR_PrCalc, SR_PrTrnc                        *
      *                                                               *
      *****************************************************************
     C     SR_PrAcct     BEGSR
      *
     C                   EVAL      K_CNum = Fm_CNUM
     C                   EVAL      K_FacT = Fm_FACT
     C                   EVAL      K_FcNo = Fm_FCNO
      *
      * Access FCLTYFN for the corresponding facility.
      * Issue a database error if record is not found.
      *
     C     KyFcl1        CHAIN     FCLTYL5
      *
     C                   IF        NOT %FOUND(FCLTYL5)
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000037'
     C                   EVAL      DBKey  = Ky_FCLT
     C                   EVAL      DBFile = 'FCLTYFN'
     C                   EVAL      DBase  = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Access LEFCLTQD for the corresponding facility.
      * Issue a database error if record is not found.
      *
     C     KyFclQ        CHAIN     LEFCLTLH
      *
     C                   IF        NOT %FOUND(LEFCLTLH)
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000037'
     C                   EVAL      DBKey  = Ky_FCLT
     C                   EVAL      DBFile = 'LEFCLTQD'
     C                   EVAL      DBase  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Access Accounts file using the facility as the key.
      * Initialise a flag that will be used to check if the facility
      * is attached to an account
      *
     C                   EVAL      WFLAG = 'N'
     C                   CLEAR                   WSOA
     C                   CLEAR                   WSOF
     C                   CLEAR                   crOAM1
     C                   CLEAR                   crCAMD
     C                   CLEAR                   crCEXP
     C                   CLEAR                   crPEXP
      *
     C     KyFcl1        SETLL     ACCNTLA
     C     KyFcl1        READE     ACCNTLA
      *
     C                   DOW       NOT %EOF(ACCNTLA)
      *
     C                   EVAL      WFLAG = 'Y'
     C                   EXSR      SR_GtSupD
     C                   EXSR      SR_PrCalc
      *
     C     KyFcl1        READE     ACCNTLA
     C                   ENDDO
      *
     C                   IF        WFLAG = 'Y'
     C                   UPDATE    FCLTYFNF
     C                   UPDATE    LEFCLTD0
     C                   ENDIF
      *
      * Proces the CA facility of the trance attached to an account
      *
     C                   IF        Fm_TRCA = 'TR' and WFLAG = 'Y'
     C                   EXSR      SR_PrTrnc
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_GtSupD - Get Supplementary Details                         *
      *                                                               *
      * Called by: SR_PrAcct                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SR_GtSupD     BEGSR
      *
      * Retrieve the instrument type via Access object
      * for Account Codes
      *
     C                   MOVE      Ac_ACOD       P_ACod
      *
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    P_ACod
     C     SDACOD        PARM      SDACOD        DSSDY
      *
     C                   IF        @Rtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000037'
     C                   EVAL      DBKey  = P_Acod
     C                   EVAL      DBFile = 'SDACODPD'
     C                   EVAL      DBase  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        A5INNR <> *BLANKS
      *
      * Retrieve weighting code and include offset indicator
      *
     C                   EVAL      P_InMr = A5INNR
      *
     C                   CALL      'AOPLINR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    P_InMr
     C     SDPLIN        PARM      SDPLIN        DSSDY
      *
     C                   IF        @Rtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000037'
     C                   EVAL      DBKey  = P_InMr
     C                   EVAL      DBFile = 'SDPLINPD'
     C                   EVAL      DBase  = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      PDINOF = *BLANKS
     C                   ENDIF
      *
     C                   EVAL      *IN81 = *OFF
      *
     C                   SELECT
      *
     C                   WHEN      PDINOF = 'Y'
      *
     C                   MOVE      PDWEIG        P_Weig
      *
     C                   CALL      'GPAOWEIGR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    P_Weig
     C     GPWEIG        PARM      GPWEIG        DSSDY
      *
     C                   IF        @Rtcd <> *BLANKS
      *
     C                   IF        @Rtcd = '*NRF'
     C                   EVAL      *IN81 = *ON
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000037'
     C                   EVAL      DBKey  = P_Weig
     C                   EVAL      DBFile = 'GPWEIGPD'
     C                   EVAL      DBase  = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   WHEN      PDINOF = 'C'
      *
     C                   MOVEL(P)  Ac_CNum       P_CNum
      *
     C                   CALL      'AOCUSTR1'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    P_CNum
     C                   PARM                    P_KYST
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C                   IF        @Rtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000037'
     C                   EVAL      DBKey  = P_CNum
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase  = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        BBINOF = 'Y'
      *
     C                   MOVE      PDWEIG        P_Weig
      *
     C                   CALL      'GPAOWEIGR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    P_Weig
     C     GPWEIG        PARM      GPWEIG        DSSDY
      *
     C                   IF        @Rtcd <> *BLANKS
      *
     C                   IF        @Rtcd = '*NRF'
     C                   EVAL      *IN81 = *ON
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000037'
     C                   EVAL      DBKey  = P_Weig
     C                   EVAL      DBFile = 'GPWEIGPD'
     C                   EVAL      DBase  = 7
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      PDPERC = *ZEROS
     C                   ENDIF
      *
     C                   OTHER
     C                   EVAL      PDPERC = *ZEROS
     C                   ENDSL
      *
     C                   IF        *IN81 = *ON
     C                   EVAL      PDPERC = 100
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_PrCalc - Process Calculations                              *
      *                                                               *
      * Called by: SR_PrAcct                                          *
      *                                                               *
      * Calls: SR_CnvCcy                                              *
      *                                                               *
      *****************************************************************
     C     SR_PrCalc     BEGSR
      *
     C                   CLEAR                   WIAM
     C                   CLEAR                   reWIAM
     C                   CLEAR                   wrkWIAM
     C                   CLEAR                   wrkOAM1
     C                   CLEAR                   wrkCAMD
     C                   CLEAR                   wrkCEXP
     C                   CLEAR                   wrkPEXP
      *
      * Access all records in RESEODPD of the same account with
      * value date less than or equal to RUN0
      *
     C                   EVAL      K_VUDT = *LOVAL
      *
     C     KyRec2        SETLL     RESEODL0
     C     KyRec1        READE     RESEODL0
      *
     C                   DOW       NOT %EOF(RESEODL0)
      *
     C                   IF        Rs_R1VDAT <= RUN0
     C                             AND Rs_R1VDAT <= Fm_DTEX
      *
     C                   IF        Rs_R1DRCR = 0
     C                   EVAL      WIAM = WIAM + Rs_R1PSTA
     C                   ELSE
     C                   EVAL      WIAM = WIAM - Rs_R1PSTA
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     KyRec1        READE     RESEODL0
     C                   ENDDO
      *
     C                   EVAL      reWIAM = WIAM
      *
      * Retrieve and Convert Cleared Balance
      *
     C                   IF        Ac_CCY <> Fm_FCCY
     C                   EVAL      WIAM = Ac_CLBL
     C                   EXSR      SR_CnvCcy
     C                   EVAL      wrkWIAM = WIAM
     C                   ELSE
     C                   EVAL      wrkWIAM = Ac_CLBL
     C                   ENDIF
      *
      * Get the amount of non-retail accounts
      *
     C                   IF        wrkWIAM > 0
     C     OAM1          SUB       wrkWIAM       wrkOAM1
     C     CAMD          SUB       wrkWIAM       wrkCAMD
     C     CEXP          SUB       wrkWIAM       wrkCEXP
     C     PEXP          SUB       wrkWIAM       wrkPEXP
     C                   ELSE
     C                   Z-ADD     OAM1          wrkOAM1
     C                   Z-ADD     CAMD          wrkCAMD
     C                   Z-ADD     CEXP          wrkCEXP
     C                   Z-ADD     PEXP          wrkPEXP
     C                   ENDIF
     C     crOAM1        ADD       wrkOAM1       crOAM1
     C     crCAMD        ADD       wrkCAMD       crCAMD
     C     crCEXP        ADD       wrkCEXP       crCEXP
     C     crPEXP        ADD       wrkPEXP       crPEXP
      *
     C                   EVAL      WIAM = reWIAM + Ac_CLBL
      *
      * If facility currency and account currency is not the same,
      * convert the amount to facility currency using the spot rate
      *
     C                   IF        Ac_CCY <> Fm_FCCY
     C                   EXSR      SR_CnvCcy
     C                   ENDIF
      *
      * Process all Account balance amounts
      *
     C                   IF        WIAM >= 0
      *
     C     wrkOAM1       ADD       WIAM          OAM1
     C     wrkCAMD       ADD       WIAM          CAMD
     C     wrkCEXP       ADD       WIAM          CEXP
     C     wrkPEXP       ADD       WIAM          PEXP
      *
     C     WSOA          ADD       WIAM          WSOA
      *
     C                   ELSE
      *
     C                   Z-ADD     wrkOAM1       OAM1
     C                   Z-ADD     wrkCAMD       CAMD
     C                   Z-ADD     wrkCEXP       CEXP
     C                   Z-ADD     wrkPEXP       PEXP
     C                   EVAL      WIAM = - WIAM
     C                   EVAL      WIAM = WIAM * (PDPERC / 100)
     C                   Z-ADD     WIAM          FCXOF1
     C                   Z-ADD     WIAM          FCXCOF
     C     WSOF          ADD       WIAM          WSOF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_PrTrnc - Process Tranche Facility                          *
      *                                                               *
      * Called by: SR_PrAcct                                          *
      *                                                               *
      * Calls: SR_Cnvrt                                               *
      *                                                               *
      *****************************************************************
     C     SR_PrTrnc     BEGSR
      *
     C                   EVAL      K_CNum = Fm_CANM
     C                   EVAL      K_FacT = Fm_CAFT
     C                   EVAL      K_FcNo = Fm_CAFN
      *
      * Access FCLTYFN for the CA facility and issue a database
      * error if record is not found
      *
     C     KyFcl1        CHAIN     FCLTYL5
      *
     C                   IF        NOT %FOUND(FCLTYL5)
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000037'
     C                   EVAL      DBKey  = Ky_FCLT
     C                   EVAL      DBFile = 'FCLTYFN'
     C                   EVAL      DBase  = 8
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Access LEFCLTQD for the CA facility and issue a database
      * error if record is not found
      *
     C     KyFclQ        CHAIN     LEFCLTLH
      *
     C                   IF        NOT %FOUND(LEFCLTLH)
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000037'
     C                   EVAL      DBKey  = Ky_FCLT
     C                   EVAL      DBFile = 'LEFCLTQD'
     C                   EVAL      DBase  = 9
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * If CA facility currency and TR facility currency is not the
      * same, convert the amount to the CA facility curency
      *
     C                   IF        Fm_CACY <> Fm_FCCY
     C                   EVAL      ZCCYI = Fm_FCCY
     C                   EVAL      ZCCYO = Fm_CACY
     C                   EVAL      ZEXCH = Fm_CAXR
     C                   EVAL      ZMD   = Fm_CMDI
      *
     C                   EVAL      ZAMTCI = WSOA
     C                   EXSR      SR_Cnvrt
     c                   EVAL      WSOA = ZAMTCO
      *
     C                   EVAL      ZAMTCI = WSOF
     C                   EXSR      SR_Cnvrt
     C                   EVAL      WSOF = ZAMTCO
      *
     C                   EVAL      ZAMTCI = crOAM1
     C                   EXSR      SR_Cnvrt
     C                   EVAL      crOAM1 = ZAMTCO
      *
     C                   EVAL      ZAMTCI = crCAMD
     C                   EXSR      SR_Cnvrt
     C                   EVAL      crCAMD = ZAMTCO
      *
     C                   EVAL      ZAMTCI = crCEXP
     C                   EXSR      SR_Cnvrt
     C                   EVAL      crCEXP = ZAMTCO
      *
     C                   EVAL      ZAMTCI = crPEXP
     C                   EXSR      SR_Cnvrt
     C                   EVAL      crPEXP = ZAMTCO
      *
     C                   ENDIF
      *
      * Process all Account Balance amounts
      *
     C     crOAM1        ADD       WSOA          OAM1
     C     crCAMD        ADD       WSOA          CAMD
     C     crCEXP        ADD       WSOA          CEXP
     C     crPEXP        ADD       WSOA          PEXP
      *
     C                   Z-ADD     WSOF          FCXOF1
     C                   Z-ADD     WSOF          FCXCOF
      *
     C                   UPDATE    FCLTYFNF
     C                   UPDATE    LEFCLTD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_CnvCcy - Convert Currency                                  *
      *                                                               *
      * Called by: SR_PrCalc                                          *
      *                                                               *
      * Calls: SR_GtCurr, SR_GtXRat, SR_Cnvrt                         *
      *                                                               *
      *****************************************************************
     C     SR_CnvCcy     BEGSR
      *
     C                   EVAL      P_Curr = Ac_CCY
     C                   EXSR      SR_GtCurr
     C                   EVAL      ZMDI1  = A6MDIN
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZCDPI  = A6NBDP
      *
     C                   EVAL      P_Curr = Fm_FCCY
     C                   EXSR      SR_GtCurr
     C                   EVAL      ZMDI2  = A6MDIN
     C                   EVAL      ZRATE2 = A6SPRT
     C                   EVAL      ZCDPO  = A6NBDP
      *
     C                   EXSR      SR_GtXRat
     C                   EVAL      ZEXCH = ZRATEX
     C                   EVAL      ZMD   = ZMDIX
     C                   EVAL      ZCCYI = Ac_CCY
     C                   EVAL      ZCCYO = Fm_FCCY
      *
     C                   EVAL      ZAMTCI  = WIAM
     C                   EXSR      SR_Cnvrt
     C                   EVAL      WIAM = ZAMTCO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_GtCurr - Get Currency Details                              *
      *                                                               *
      * Called by: SR_CnvCcy                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SR_GtCurr     BEGSR
      *
     C                   CALL      'AOCURR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    P_Curr
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        @Rtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000037'
     C                   EVAL      DBKey  = P_Curr
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase  = 10
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_Cnvrt - Convert amount to another currency                 *
      *                                                               *
      * Called by: SR_CnvCcy,SR_PrTrnc                                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SR_Cnvrt      BEGSR
      *
     C                   CALL      'ZCONVZ1'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM                    ZAMTCO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_GtXRat - Get exchange rate                                 *
      *                                                               *
      * Called by: SR_CnvCcy                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SR_GtXRat     BEGSR
      *
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - Program exception error routine                       *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        RunBefore <> 'Y'
     C                   EVAL      RunBefore = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
