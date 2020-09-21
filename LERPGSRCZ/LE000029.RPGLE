     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility Exposure Update for Retail IC')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000029 - Midas LE Facility Exposure Update for Retail      *
      *             Interest Capitalisation                           *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. CSD103              Date 10Aug20              *
      *  Prev Amend No. MD052994 *CREATE    Date 25Nov19              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data.    *
      *           (Recompile)                                         *
      *  MD052994 - CL Facility Event not Generated for Retail        *
      *             Account Debit Capitalised Interests               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     ** Midas RE Summary of Generated Entries from GEICPD
     FREGEICPD  IF   E             DISK    INFSR(*PSSR)

     ** Midas LE Facility file A record by branch
     FFCLTYL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(Fm_)

     ** Midas LE Facility file B record
     FFCLTYL5   UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

     ** Midas LE Facilities Ext File by Facility
     FLEFCLTLH  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

     ** Midas GL Account details by retail account number
     FACCNTL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(A1_)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** DS for access programs, long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Facilities Key
     D                 DS
     D Ky_FCLTY                1     11A
     D  K_Cnum                 1      6A
     D  K_FacT                 7      9S 0
     D  KAFacT                 7      9A
     D  K_FcNo                10     11S 0
     D  KAFcNo                10     11A

      ** Data structure of Facility Rundates Day0 to Day9
     D                 DS
     D  RUN0                   1      3P 0
     D  RUN1                   4      6P 0
     D  RUN2                   7      9P 0
     D  RUN3                  10     12P 0
     D  RUN4                  13     15P 0
     D  RUN5                  16     18P 0
     D  RUN6                  19     21P 0
     D  RUN7                  22     24P 0
     D  RUN8                  25     27P 0
     D  RUN9                  28     30P 0
     D  RUNS                   1     30P 0
     D                                     DIM(10) ASCEND

      ** Data structure of Facility Exposure Amounts
     D                 DS
     D  OAM1                   1      7P 0
     D  OAM2                   8     14P 0
     D  OAM3                  15     21P 0
     D  OAM4                  22     28P 0
     D  OAM5                  29     35P 0
     D  OAM6                  36     42P 0
     D  OAM7                  43     49P 0
     D  OAM8                  50     56P 0
     D  OAM9                  57     63P 0
     D  OA10                  64     70P 0
     D  OAM                    1     70P 0
     D                                     DIM(10)

      ** Data structure of Facility Offset Amounts
     D                 DS
     D  FCXOF1                 1      7P 0
     D  FCXOF2                 8     14P 0
     D  FCXOF3                15     21P 0
     D  FCXOF4                22     28P 0
     D  FCXOF5                29     35P 0
     D  FCXOF6                36     42P 0
     D  FCXOF7                43     49P 0
     D  FCXOF8                50     56P 0
     D  FCXOF9                57     63P 0
     D  FCXO10                64     70P 0
     D  FCXO                   1     70P 0
     D                                     DIM(10)

      ** Data structure of Work Amounts 1
     D                 DS
     D  W1AM1                  1      7P 0
     D  W1AM2                  8     14P 0
     D  W1AM3                 15     21P 0
     D  W1AM4                 22     28P 0
     D  W1AM5                 29     35P 0
     D  W1AM6                 36     42P 0
     D  W1AM7                 43     49P 0
     D  W1AM8                 50     56P 0
     D  W1AM9                 57     63P 0
     D  W1A10                 64     70P 0
     D  W1AM                   1     70P 0
     D                                     DIM(10)

      ** Data structure for Account Codes
     D SDACOD        E DS                  EXTNAME(SDACODPD)

      ** Data structure for Instruments Types
     D SDPLIN        E DS                  EXTNAME(SDPLINPD)

      ** Data structure for Weighing Code
     D GPWEIG        E DS                  EXTNAME(GPWEIGPD)
     D   PL_LCD      E                     EXTFLD(PDLCD)
     D   PL_WEIG     E                     EXTFLD(PDWEIG)

      ** Data structure for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Data structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Data structure for Switchable features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D P_ACod          S             10
     D P_RtCd          S              7
     D P_Optn          S              7
     D P_Inmr          S              3
     D P_Weig          S              2
     D P_CNum          S             10
     D P_Curr          S              3

     D K_Brca          S              3
     D Z               S              3  0

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

      ** Work arrays
     D WSOA            S             13  0 DIM(10)
     D WSOF            S             13  0 DIM(10)

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Read through RE Summary of Generated Entries from GEICPD

     C                   READ      REGEICPD
     C                   DOW       NOT %EOF(REGEICPD)

     C                   EXSR      SR_PrAcct

     C                   READ      REGEICPD
     C                   ENDDO

     C                   COMMIT
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_PrAcct - Process Facilities per Account                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SR_GtSupD, SR_PrCalc, SR_PrTrnc                        *
      *                                                               *
      *****************************************************************
     C     SR_PrAcct     BEGSR

      ** Access Accounts to get the corresponding facility number

     C     GEACNO        CHAIN     ACCNTL1
     C                   IF        NOT %FOUND(ACCNTL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000029'
     C                   MOVEL     GEACNO        DBKey
     C                   EVAL      DBFile = 'ACCNTAB'
     C                   EVAL      DBase  = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access FCLTYFM/FN for the corresponding facility

     C                   IF        A1_Fact <> 0 and
     C                             A1_FcNo <> 0

     C                   EVAL      K_Brca = A1_Brca
     C                   EVAL      K_Cnum = A1_Fccu
     C                   EVAL      K_FacT = A1_FacT
     C                   EVAL      K_FcNo = A1_FcNo

      ** Access FCLTYFM for the corresponding facility
      ** Issue a database error if record is not found

     C     KyFcltyFM     CHAIN     FCLTYL1

     C                   IF        NOT %FOUND(FCLTYL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000029'
     C                   EVAL      DBKey  = Ky_FCLTY
     C                   EVAL      DBFile = 'FCLTYFM'
     C                   EVAL      DBase  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access FCLTYFN for the corresponding facility
      ** Issue a database error if record is not found

     C     KyFcltyFN     CHAIN     FCLTYL5

     C                   IF        NOT %FOUND(FCLTYL5)
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000029'
     C                   EVAL      DBKey  = Ky_FCLTY
     C                   EVAL      DBFile = 'FCLTYFN'
     C                   EVAL      DBase  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access LEFCLTQD for the corresponding facility
      ** Issue a database error if record is not found

     C     KyFclQ        CHAIN     LEFCLTLH
     C                   IF        NOT %FOUND(LEFCLTLH)
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE001000'
     C                   EVAL      DBKey  = Ky_FCLTY
     C                   EVAL      DBFile = 'LEFCLTQD'
     C                   EVAL      DBase  = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   WSOA
     C                   CLEAR                   WSOF

     C                   EXSR      SR_GtSupD
     C                   EXSR      SR_PrCalc

     C                   UPDATE    FCLTYFNF
     C                   UPDATE    LEFCLTD0

      ** Process the CA facility of the tranche attached to an account

     C                   IF        Fm_TRCA = 'TR'
     C                   EXSR      SR_PrTrnc
     C                   ENDIF
     C                   ENDIF

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

      ** Retrieve the instrument type via Access object for Account codes

     C                   MOVE      A1_ACOD       P_ACod
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       P_RtCd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_ACod
     C     SDACOD        PARM      SDACOD        DSSDY
     C                   IF        P_RtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000029'
     C                   EVAL      DBKey  = P_Acod
     C                   EVAL      DBFile = 'SDACODPD'
     C                   EVAL      DBase  = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        A5INNR <> *Blanks

      ** Retrieve weighting code and include offset indicator

     C                   MOVE      A5INNR        P_InMr
     C                   CALL      'AOPLINR0'
     C                   PARM      *BLANKS       P_RtCd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_InMr
     C     SDPLIN        PARM      SDPLIN        DSSDY
     C                   IF        P_RtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000029'
     C                   EVAL      DBKey  = P_InMr
     C                   EVAL      DBFile = 'SDPLINPD'
     C                   EVAL      DBase  = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ELSE
     C                   EVAL      PDINOF = *Blanks
     C                   ENDIF

     C                   EVAL      *IN81 = *OFF

     C                   SELECT

     C                   WHEN      PDINOF = 'Y'

     C                   MOVE      PDWEIG        P_Weig
     C                   CALL      'GPAOWEIGR0'
     C                   PARM      *BLANKS       P_RtCd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Weig
     C     GPWEIG        PARM      GPWEIG        DSSDY
     C                   IF        P_RtCd <> *Blanks
     C                   IF        P_RtCd = '*NRF'
     C                   EVAL      *IN81 = *ON
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000029'
     C                   EVAL      DBKey  = P_Weig
     C                   EVAL      DBFile = 'GPWEIGPD'
     C                   EVAL      DBase  = 7
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

     C                   WHEN      PDINOF = 'C'

     C                   MOVEL(P)  A1_CNum       P_CNum
     C                   CALL      'AOCUSTR1'
     C                   PARM      *BLANKS       P_RtCd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_CNum
     C                   PARM      *BLANKS       P_KYST            7
     C     SDCUST        PARM      SDCUST        DSLDY
     C                   IF        P_RtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000029'
     C                   EVAL      DBKey  = P_CNum
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase  = 8
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        BBINOF = 'Y'

     C                   MOVE      PDWEIG        P_Weig
     C                   CALL      'GPAOWEIGR0'
     C                   PARM      *BLANKS       P_RtCd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Weig
     C     GPWEIG        PARM      GPWEIG        DSSDY
     C                   IF        P_RtCd <> *Blanks
     C                   IF        P_RtCd = '*NRF'
     C                   EVAL      *IN81 = *ON
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000029'
     C                   EVAL      DBKey  = P_Weig
     C                   EVAL      DBFile = 'GPWEIGPD'
     C                   EVAL      DBase  = 9
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   EVAL      PDPERC = *ZEROS
     C                   ENDIF

     C                   OTHER
     C                   EVAL      PDPERC = *ZEROS
     C                   ENDSL

     C                   IF        *IN81 = *ON
     C                   EVAL      PDPERC = 100
     C                   ENDIF

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

     C                   CLEAR                   W1AM

      ** Access all the records in REGEICPD for the same account with
      ** value date less than or equal to the 10 facility dates


     C                   EVAL      Z = 1
     C                   DOW       Z <= 10

     C                   IF        GEPSTD <= RUNS(Z)
     C                   IF        GEDRCR = 0
     C                   EVAL      W1AM(Z) = W1AM(Z) + GEPSTA
     C                   ELSE
     C                   EVAL      W1AM(Z) = W1AM(Z) - GEPSTA
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      Z = Z + 1
     C                   ENDDO

      ** If facility currency and account currency is not the same,
      ** convert the amount to facility currency using the spot rate

     C                   IF        A1_CCY <> Fm_FCCY
     C                   EXSR      SR_CnvCcy
     C                   ENDIF

      ** Process all Account balance amounts

     C                   EVAL      Z = 1
     C                   DOW       Z <= 10

     C                   IF        W1AM(Z) >= 0
     C                   EVAL      OAM(Z)  = OAM(Z)  + W1AM(Z)
     C                   EVAL      WSOA(Z) = WSOA(Z) + W1AM(Z)

     C                   IF        Z = 2
     C                   EVAL      CAMD = OAM(2)
     C                   EVAL      CEXP = OAM(2)
     C                   ENDIF

     C                   ELSE
     C                   EVAL      W1AM(Z) = - W1AM(Z)
     C                   EVAL      W1AM(Z) = W1AM(Z) * ( PDPERC / 100 )
     C                   EVAL      FCXO(Z) = FCXO(Z) + W1AM(Z)
     C                   EVAL      WSOF(Z) = WSOF(Z) + W1AM(Z)
     C                   ENDIF

     C                   IF        Z = 2
     C                   EVAL      CAMD = OAM(2)
     C                   EVAL      CEXP = OAM(2)
     C                   ENDIF

     C                   EVAL      Z = Z + 1
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_PrTrnc - Process if facility is a tranche facility         *
      *                                                               *
      * Called by: SR_PrAcct                                          *
      *                                                               *
      * Calls: SR_Cnvrt                                               *
      *                                                               *
      *****************************************************************
     C     SR_PrTrnc     BEGSR

     C                   EVAL      K_Cnum = Fm_CANM
     C                   EVAL      K_FacT = Fm_CAFT
     C                   EVAL      K_FcNo = Fm_CAFN

      ** Access FCLTYFN for the CA facility
      ** and issue a database error if record is not found

     C     KyFcltyFN     CHAIN     FCLTYL5
     C                   IF        NOT %FOUND(FCLTYL5)
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000029'
     C                   EVAL      DBKey  = Ky_FCLTY
     C                   EVAL      DBFile = 'FCLTYFN'
     C                   EVAL      DBase  = 10
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access LEFCLTQD for the CA facility
      ** and issue a database error if record is not found

     C     KyFclQ        CHAIN     LEFCLTLH
     C                   IF        NOT %FOUND(LEFCLTLH)
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000029'
     C                   EVAL      DBKey  = Ky_FCLTY
     C                   EVAL      DBFile = 'LEFCLTQD'
     C                   EVAL      DBase  = 11
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** If CA facility currency and TR facility currency is not the same,
      ** convert the amount to the CA facility currency

     C                   IF        Fm_CACY <> Fm_FCCY
     C                   EVAL      ZCCYI = Fm_FCCY
     C                   EVAL      ZCCYO = Fm_CACY
     C                   EVAL      ZEXCH = Fm_CAXR
     C                   EVAL      ZMD   = Fm_CMDI

     C                   EVAL      Z = 1
     C                   DOW       Z <= 10
     C                   EVAL      ZAMTCI  = WSOA(Z)
     C                   EXSR      SR_Cnvrt
     C                   EVAL      WSOA(Z) = ZAMTCO
     C                   EVAL      Z = Z + 1
     C                   ENDDO

     C                   EVAL      Z = 1
     C                   DOW       Z <= 10
     C                   EVAL      ZAMTCI  = WSOF(Z)
     C                   EXSR      SR_Cnvrt
     C                   EVAL      WSOF(Z) = ZAMTCO
     C                   EVAL      Z = Z + 1
     C                   ENDDO

     C                   ENDIF

      ** Process all Account balance amounts

     C                   EVAL      Z = 1
     C                   DOW       Z <= 10

     C                   EVAL      OAM(Z)  = OAM(Z)  + WSOA(Z)
     C                   EVAL      FCXO(Z) = FCXO(Z) + WSOF(Z)

     C                   IF        Z = 2
     C                   EVAL      CAMD = OAM(2)
     C                   EVAL      CEXP = OAM(2)

     C                   ENDIF

     C                   EVAL      Z = Z + 1
     C                   ENDDO

     C                   UPDATE    FCLTYFNF
     C                   UPDATE    LEFCLTD0

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

     C                   EVAL      P_Curr = A1_CCY
     C                   EXSR      SR_GtCurr
     C                   EVAL      ZMDI1  = A6MDIN
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZCDPI  = A6NBDP

     C                   EVAL      P_Curr = Fm_FCCY
     C                   EXSR      SR_GtCurr
     C                   EVAL      ZMDI2  = A6MDIN
     C                   EVAL      ZRATE2 = A6SPRT
     C                   EVAL      ZCDPO  = A6NBDP

     C                   EXSR      SR_GtXRat
     C                   EVAL      ZEXCH  = ZRATEX
     C                   EVAL      ZMD    = ZMDIX
     C                   EVAL      ZCCYI  = A1_CCY
     C                   EVAL      ZCCYO  = Fm_FCCY

     C                   EVAL      Z = 1
     C                   DOW       Z <= 10
     C                   EVAL      ZAMTCI  = W1AM(Z)
     C                   EXSR      SR_Cnvrt
     C                   EVAL      W1AM(Z) = ZAMTCO
     C                   EVAL      Z = Z + 1
     C                   ENDDO

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

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       P_RtCd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Curr
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   IF        P_RtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm  = 'LE000029'
     C                   EVAL      DBKey  = P_Curr
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase  = 12
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_Cnvrt - Convert amount to another currency                 *
      *                                                               *
      * Called by: SR_CnvCcy, SR_PrTrnc                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SR_Cnvrt      BEGSR

     C                   CALL      'ZCONVZ1'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM                    ZAMTCO

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

     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *DTAARA       DEFINE                  LDA

     C     KyFclQ        KLIST
     C                   KFLD                    K_Cnum
     C                   KFLD                    KAFacT
     C                   KFLD                    KAFcNo

     C     KyFcltyFN     KLIST
     C                   KFLD                    K_Cnum
     C                   KFLD                    K_FacT
     C                   KFLD                    K_FcNo

     C     KyFcltyFM     KLIST
     C                   KFLD                    K_Brca
     C                   KFLD                    K_Cnum
     C                   KFLD                    K_FacT
     C                   KFLD                    K_FcNo

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR

     C                   IF        @RUN = *Blank
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
