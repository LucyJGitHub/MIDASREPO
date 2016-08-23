     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate trade price')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading                                     *
      *                                                               *
      *  SEVTPRICE - Validate Trade Price.                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL031             Date 05Jul04               *
      *                 CAS006             Date 21Jan03               *
      *                 211036             Date 31Oct02               *
      *                 CSE037             Date 29Apr02               *
      *                 CSE035             Date 22Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 162013             Date 08Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08MAR99               *
      *                 156689             Date 18Mar99               *
      *                 CAP003  *CREATE    Date 15Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  211036 - Countervalue being rounded where security is in the *
      *           last coupon period.                                 *
      *  CSE037 - Countervalue rounding.                              *
      *  CSE035 - NX/NNX Coupon Payment Processing.                   *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  162013 - Clear Price field before re-output                  *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  156689 - ZASIGN To Recognize '.' or ',' as decimal separator *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
                                                                                              CSE035
     D*   Data structure for CTR                                                              CSE035
     D                 DS                                                                     CSE035
     D  CTR                    1     21                                                       CSE035
     D                                     DIM(21)                                            CSE035
      *                                                                                       CSE037
      ** First DS for Access programs - short data structure                                  CSE037
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSE037
      *                                                                                       CSE037
      **  Data structure for Switchable features                                              CSE037
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSE037
     D                                     PREFIX(S_)                                         CSE037
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D CDArr                 183    230
     D CRArr                 231    242
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input field(s)
      ** --------------
 
      ** Screen fields
 
     D DDPric          S             17A
     D DDACIN          S              1A
 
      ** Trade Details
     D NOML            S             11P 0
     D TPDY            S             15P 8
     D TDVD            S              5P 0
     D ITRA            S             13P 0
 
      ** Nominal ccy dec places
     D NomCcyDec       S              1P 0
 
 
      ** System Info
     D BJDFIN          S              1A
 
 
      *** Output ***
     D DDPricOk        S              1A
     D PRIC            S             15P 8
 
      ** WORKING VARIABLES ***
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D SCUMEX          S              1A
     D WRKPI           S             15P 9
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZASIGNOK        S              1A
     D ZFDATE          S              5P 0
     D ZFIELD          S             16A
     D ZFLD17          S             17A
     D ZFSIGN          S              1A
     D ZNOML           S             15P 0
     D ZOUT15          S             15A
     D ZPRCIN          S             15P 8
     D ZPRCOT          S             15P 8
     D ZSDEC           S              1P 0
     D ZSDCSP          S              1A                                        156689
     D ZSDIG           S              2P 0
     D ZYLDOk          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      ** Clear output trade fields
 
     C                   Z-ADD     *ZEROS        PRIC
      *
      ** If Price Basis, no further validation needed
      *
     C     STBS          IFEQ      'P'
     C                   MOVE      TPDY          PRIC
     C                   ELSE
      *
      ** DEFAULTING
      *
     C     Default       IFEQ      'Y'
     C     DDPRIC        ANDEQ     *BLANK
     C                   EXSR      PRICD
      *                                                                                       CSE035
      ** ADDITIONAL VALIDATION FOR ACCRUED INDICATOR                                          CSE035
     C     CSE035        IFEQ      'Y'                                                        CSE035
     C     DDTPDY        IFNE      *BLANKS                                                    CSE035
     C                   EXSR      ADDVAL                                                     CSE035
     C                   ENDIF                                                                CSE035
     C                   ENDIF                                                                CSE035
      *                                                                                       CSE035
     C                   END
      *
      ** VALIDATION
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      PRICV
     C                   END
 
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDPricOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** DEFAULTING                                                   *
      *****************************************************************
     C     PRICD         BEGSR
      *
      ** Setup Parameter list
      *
      ** Price/Discount/Yield
      ** Value Date
      *
     C                   MOVE      TPDY          ZPRCIN
     C                   MOVE      TDVD          ZFDATE
      *
      * Nominal
      *
     C                   Z-ADD     NOML          ZNOML
      *
      ** Calculate PI as a fraction of Nominal
      *
     C     NOML          IFNE      0
     C     ITRA          DIV       NOML          WRKPI
     C                   ELSE
     C                   Z-ADD     0             WRKPI
     C                   END
      *                                                                                       CSE035
     C     CSE035        IFEQ      'Y'                                                        CSE035
     C                   MOVE      DDACIN        SCUMEX                                       CSE035
     C                   ELSE                                                                 CSE035
      *
      * Cum/Ex ind.
      *
     C     DDACIN        IFEQ      'X'
     C                   MOVE      'X'           SCUMEX
     C                   ELSE
     C                   MOVE      'C'           SCUMEX
     C                   END
      *                                                                                       CSE035
     C                   ENDIF                                                                CSE035
      *
      ** Calculate % price from yield
      *
     C                   CALLB     'ZPRCI'
     C                   PARM                    ZPRCIN
     C                   PARM                    ZFDATE
     C                   PARM                    SECTY
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    ZNOML
     C                   PARM                    WRKPI
     C                   PARM                    SCUMEX
     C                   PARM                    BJDFIN
     C                   PARM                    ZYLDOk
     C                   PARM                    ZPRCOT
      *                                                                                       CSE037
      ** Additional calculation for countervalue rounding                                     CSE037
     C     DDACTN        IFEQ      'I'                                                        CSE037
     C     DDACTN        OREQ      'C'                                                        CSE037
     C                   EXSR      CntValRnd                                                  CSE037
     C                   ENDIF                                                                CSE037
 
     C                   MOVE (P)  *BLANKS       ZFIELD
     C                   MOVE (P)  ZPRCOT        ZFIELD
     C                   Z-ADD     8             ZADEC
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C
     C                   MOVE      ZFIELD        DDPRIC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSE035
      ** ADDITIONAL VALIDATION FOR ACCRUED INDICATOR                  *                       CSE035
      *****************************************************************                       CSE035
     C     ADDVAL        BEGSR                                                                CSE035
      *                                                                                       CSE035
     C     CSE035        IFEQ      'Y'                                                        CSE035
      *                                                                                       CSE035
     C                   MOVE      *OFF          FLG01             1                          CSE035
      *                                                                                       CSE035
      * Only pass valid indicator to calculation modules otherwise                            CSE035
      * rubbish will be displayed on screen while indicator is in error                       CSE035
      *                                                                                       CSE035
     C     DDACIN        IFEQ      'C'                                                        CSE035
     C     DDACIN        OREQ      'F'                                                        CSE035
     C     DDACIN        OREQ      'X'                                                        CSE035
     C     DDACIN        OREQ      'N'                                                        CSE035
     C     FLG01         ANDEQ     *OFF                                                       CSE035
     C     DDACIN        OREQ      'D'                                                        CSE035
     C     FLG01         ANDEQ     *OFF                                                       CSE035
     C                   MOVE      DDACIN        SCUMEX                                       CSE035
     C                   ELSE                                                                 CSE035
      *                                                                                       CSE035
     C     DDACIN        IFEQ      'X'                                                        CSE035
     C                   MOVE      'X'           SCUMEX                                       CSE035
     C                   ELSE                                                                 CSE035
     C                   MOVE      'C'           SCUMEX                                       CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
      *         Calculate PI as a fraction of nominal                                         CSE035
      *                                                                                       CSE035
     C     NOML          IFNE      0                                                          CSE035
     C     ITRA          DIV       NOML          WRKPI                                        CSE035
     C                   ELSE                                                                 CSE035
     C                   Z-ADD     0             WRKPI                                        CSE035
     C                   END                                                                  CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
     C                   Z-ADD     NOML          ZNOML                                        CSE035
      *                                                                                       CSE035
     C                   Z-ADD     TPDY          ZPRCIN                                       CSE035
     C                   Z-ADD     TDVD          ZFDATE                                       CSE035
      *                                                                                       CSE035
     C                   CALLB     'ZPRCI'                                                    CSE035
     C                   PARM                    ZPRCIN                                       CSE035
     C                   PARM                    ZFDATE                                       CSE035
     C                   PARM                    SECTY                                        CSE035
     C                   PARM                    NomCcyDec                                    CSE035
     C                   PARM                    PROT                                         CSE035
     C                   PARM                    ZNOML                                        CSE035
     C                   PARM                    WRKPI                                        CSE035
     C                   PARM                    SCUMEX                                       CSE035
     C                   PARM                    BJDFIN                                       CSE035
     C                   PARM                    ZYLDOk                                       CSE035
     C                   PARM                    ZPRCOT                                       CSE035
      *                                                                                       CSE037
      ** Additional calculation for countervalue rounding                                     CSE037
     C     CSE037        IFEQ      'Y'                                                        CSE037
     C                   EXSR      CntValRnd                                                  CSE037
     C                   ENDIF                                                                CSE037
      *                                                                                       CSE035
     C                   MOVE (P)  *BLANKS       ZFIELD                                       CSE035
     C                   MOVE (P)  ZPRCOT        ZFIELD                                       CSE035
     C                   Z-ADD     8             ZADEC                                        CSE035
                                                                                              CSE035
     C                   CALLB     'ZEDIT'                                                    CSE035
     C                   PARM                    ZFIELD                                       CSE035
     C                   PARM                    ZADEC                                        CSE035
                                                                                              CSE035
     C                   MOVE      ZFIELD        DDPRIC                                       CSE035
      *                                                                                       CSE035
      *    Calculate counter value for processing type '9'                                    CSE035
      *                                                                                       CSE035
     C     PROT          IFEQ      '9'                                                        CSE035
     C     PROT          OREQ      '1'                                                        CSE035
     C     PROT          OREQ      '3'                                                        CSE035
     C     PROT          OREQ      '8'                                                        CSE035
     C     NOML          IFNE      0                                                          CSE035
     C     ZPRCOT        ANDNE     0                                                          CSE035
      *                                                                                       CSE035
      *    Calculate Consideration                                                            CSE035
      *                                                                                       CSE035
     C                   Z-ADD     NOML          ZNOML                                        CSE035
     C                   Z-ADD     ZPRCOT        ZPRC                                         CSE035
     C                   Z-ADD     NomCcyDec     ZCDP                                         CSE035
      *                                                                                       CSE035
     C                   EXSR      ZCNSD                                                      CSE035
      *                                                                                       CSE035
     C                   Z-ADD     ZCONS         NOMPR            17 4                        CSE035
      *                                                                                       CSE035
     C     PROT          IFEQ      '1'                                                        CSE035
     C     PROT          OREQ      '3'                                                        CSE035
     C     PROT          OREQ      '8'                                                        CSE035
     C                   Z-ADD     ITRA          ZITRAX           13 2                        CSE035
     C     ZITRAX        ADD       NOMPR         NOMPR                                        CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
     C                   MOVE      *BLANKS       ZFLD15                                       CSE035
     C                   Z-ADD (H) NOMPR         ZFLD15                                       CSE035
      *                                                                                       CSE035
     C                   Z-ADD     NomCcyDec     ZDECS                                        CSE035
     C                   MOVE      'J'           ZECODE                                       CSE035
     C                   MOVE      '*'           ZECHAR           21                          CSE035
                                                                                              CSE035
     C                   CALLB     'ZSEDIT'                                                   CSE035
     C                   PARM                    ZFLD15           15 0                        CSE035
     C                   PARM                    ZDECS             1 0                        CSE035
     C                   PARM                    ZECODE            1                          CSE035
     C                   PARM                    ZOUT21           21                          CSE035
                                                                                              CSE035
     C                   MOVE      ZOUT21        DDTCTR                                       CSE035
     C                   EXSR      CNTL                                                       CSE035
     C                   END                                                                  CSE035
     C                   END                                                                  CSE035
                                                                                              CSE035
     C                   ENDSR                                                                CSE035
      /EJECT                                                                                  CSE035
      *****************************************************************
      *****************************************************************                       CSE037
      ** Additional calculation for countervalue rounding             *                       CSE037
      *****************************************************************                       CSE037
     C     CntValRnd     BEGSR                                                                CSE037
      *                                                                                       CSE037
      *                                                                                       CSE037
      *  Setup fields for CSE037 Countervalue rounding                                        CSE037
      *  via ZPRCOT                                                                           CSE037
      *                                                                                       CSE037
      *                                                                                       CSE037
      *  +--                                                     --+      CSE037              CSE037
      *  | CSE037 Countervalue Rounding                            |      CSE037              CSE037
      *  | ==============================                          |      CSE037              CSE037
      *  | CSE037 Countervalue Rounding   works by calculating a   |      CSE037              CSE037
      *  | temporary Countervalue and getting an adjusting factor  |      CSE037              CSE037
      *  | to the value of the Rounded   amount.                   |      CSE037              CSE037
      *  | This Adjusting factor is then applied to the Price      |      CSE037              CSE037
      *  | so that when the actual Countervalue is calculated the  |      CSE037              CSE037
      *  | Rounded   portion has been added to the Consideration   |      CSE037              CSE037
      *  | via the Price.                                          |      CSE037              CSE037
      *  +--                                                     --+      CSE037              CSE037
      *                                                                                       CSE037
      *                                                                                       CSE037
      *                                                                                       CSE037
      * Only preform Rounding on Discount or Yield Basis                                      CSE037
      *                                                                                       CSE037
     C     STBS          IFEQ      'D'                                                        CSE037
     C     STBS          OREQ      'Y'                                                        CSE037
      *                                                                                       CSE037
     C     CSE037        IFEQ      'Y'                                          CSE037=Y      CSE037
      *                                                                                       211036
      * Only perform rounding if Next Coupon Date is not Maturity Date                        211036
      *                                                                                       211036
     C     NCD           IFLT      MATY                                                       211036
      *                                                                                       CSE037
      * Calculate Consideration                                                               CSE037
      *                                                                                       CSE037
     C     ZNOML         MULT      ZPRCOT        W#CNTR           20 5                        CSE037
     C                   DIV (H)   100           W#CNTR                                       CSE037
      *                                                                                       CSE037
      * Add in Interest                                                                       CSE037
      *                                                                                       CSE037
     C     PROT          IFNE      '6'                                                        CSE037
     C                   ADD       ITRA          W#CNTR                                       CSE037
     C                   ENDIF                                                                CSE037
      *                                                                                       CSE037
      * Add in Accrued Indexation                                                             CSE037
      *                                                                                       CSE037
      * Convert Countervalue to an expression of price                                        CSE037
      *                                                                                       CSE037
     C     W#CNTR        MULT      100           W#205            20 5                        CSE037
     C     W#205         DIV       ZNOML         W#PRC            15 8                        CSE037
      *                                                                                       CSE037
      * Adjust Countervalue price using Standard Routine                                      CSE037
      *                                                                                       CSE037
     C                   MOVE      SESN          ZSESN            10                          CSE037
     C                   Z-ADD     W#PRC         ZINPF            15 8                        CSE037
     C                   Z-ADD     *ZEROS        ZOUTF            15 8                        CSE037
      *                                                                                       CSE037
     C                   CALLB     'SEADJPRI'                                                 CSE037
     C                   PARM      *BLANKS       @RTCD                                        CSE037
     C                   PARM      ZSESN         @SEKEY           10                          CSE037
     C     ZINPF         PARM      ZINPF         @INAMT           15 8                        CSE037
     C     ZOUTF         PARM      ZOUTF         @OUAMT           15 8                        CSE037
      *                                                                                       CSE037
      * Convert Rounded price to a Countervalue                                               CSE037
      *                                                                                       CSE037
     C     ZOUTF         MULT      ZNOML         W#CNT1           20 5                        CSE037
     C                   DIV       100           W#CNT1                                       CSE037
      *                                                                                       CSE037
      * Calculate Rounded portion Adjusting factor (of Price)                                 CSE037
      *                                                                                       CSE037
     C     W#CNTR        SUB       W#CNT1        W#DIFF           20 5                        CSE037
     C                   MULT      100           W#DIFF                                       CSE037
     C     W#DIFF        DIV (H)   ZNOML         W#ADJT           15 8                        CSE037
      *                                                                                       CSE037
      * Apply adjusting factor to Price                                                       CSE037
      *                                                                                       CSE037
     C                   SUB       W#ADJT        ZPRCOT                                       CSE037
      *                                                                                       CSE037
     C                   ENDIF                                                                211036
      *                                                                                       211036
     C                   ENDIF                                                  CSE037=Y      CSE037
      *                                                                                       CSE037
     C                   ENDIF                                                  DSCNT/YIELD   CSE037
      *                                                                                       CSE037
      *  > End of CSE037 Rounding <                                                           CSE037
      *  --------------------------                                                           CSE037
      *                                                                                       CSE037
                                                                                              CSE037
     C                   ENDSR                                                                CSE037
      /EJECT                                                                                  CSE037
      ** VALIDATION                                                   *
      *****************************************************************
     C     PRICV         BEGSR
 
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDPRIC        ZFLD17
     C                   Z-ADD     7             ZSDIG
     C                   Z-ADD     8             ZSDEC
 
     C                   CALLB     'ZASIGN'
     C                   PARM                    ZASIGNok
     C                   PARM                    ZFLD17
     C                   PARM                    ZSDIG
     C                   PARM                    ZSDEC
     C                   PARM                    ZSDCSP                         156689
     C                   PARM                    ZOUT15
     C                   PARM                    ZFSIGN
 
     C                   Z-ADD     *ZEROS        PRIC
     C                   MOVE      ZOUT15        PRIC
 
      * Error if price is not numeric, is negative or is zero.
 
     C     ZASIGNok      IFEQ      'N'
     C     ZFSIGN        OREQ      '-'
     C     PRIC          OREQ      *ZEROS
     C                   ADD       1             Idx
     C                   MOVEL     'DDPRIC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0521'     MsgidXAr(Idx)
     C                   MOVE      'N'           DDPRICOk
     C                   ELSE
 
      * Re-format for output
 
     C                   MOVE (P)  *BLANKS       ZFIELD
     C                   MOVE (P)  PRIC          ZFIELD
     C                   Z-ADD     8             ZADEC
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C
     C                   MOVE      *BLANK        DDPRIC                                       162013
     C                   MOVE      ZFIELD        DDPRIC
 
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSE035
      *                                                               *                       CSE035
      *  CNTL Sub routine to left align Screen Countervalue.          *                       CSE035
      *                                                               *                       CSE035
      *****************************************************************                       CSE035
      *                                                                                       CSE035
     C     CNTL          BEGSR                                                                CSE035
                                                                                              CSE035
     C                   Z-ADD     0             E                 2 0                        CSE035
     C                   Z-ADD     1             R                 2 0                        CSE035
     C                   MOVE      '*'           SPLAT             1                          CSE035
     C                   Z-ADD     1             F                 2 0                        CSE035
     C                   MOVEA     DDTCTR        CTR                                          CSE035
     C     SPLAT         LOOKUP    CTR(F)                                 97                  CSE035
     C     21            SUB       F             E                                            CSE035
     C                   MOVE      ' '           CTR(F)                                       CSE035
     C                   ADD       1             F                                            CSE035
     C                   DO        E                                                          CSE035
     C                   MOVE      CTR(F)        CTR(R)                                       CSE035
     C                   ADD       1             F                                            CSE035
     C                   ADD       1             R                 2 0                        CSE035
     C                   END                                                                  CSE035
     C                   ADD       1             E                                            CSE035
     C                   MOVEA     *ALL' '       CTR(E)                                       CSE035
     C                   MOVEA     CTR           DDTCTR                                       CSE035
                                                                                              CSE035
     C     ECNTL         ENDSR                                                                CSE035
      *****************************************************************                       CSE035
      /EJECT                                                                                  CSE035
     C****************************************************************                        CSE035
     C*                                                              *                        CSE035
     C* ZCNSD - CONSIDERATION CALCULATION                            *                        CSE035
     C*                                                              *                        CSE035
     C****************************************************************                        CSE035
     C     ZCNSD         BEGSR                                                                CSE035
     C                   CALLB     'ZCNSD'                                                    CSE035
     C                   PARM                    ZNOML            15 0                        CSE035
     C                   PARM                    ZPRC             16 9                        CSE035
     C                   PARM                    SPBS                                         CSE035
     C                   PARM                    NMDP                                         CSE035
     C                   PARM      NomCcyDec     ZCDP              1 0                        CSE035
     C                   PARM                    ZCONS            15 0                        CSE035
     C                   ENDSR                                                                CSE035
     C****************************************************************                        CSE035
      /EJECT                                                                                  CSE035
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
 
      ** Trade Screen fields
      ** -------------------
      ** Price  (17A)
      ** Accrued indicator (1A)
      ** Action Code                                                                          CSE035
      ** Price/Discount/Yield                                                                 CSE035
      ** Countervalue                                                                         CSE035
     C                   PARM                    DDPRIC
     C                   PARM                    DDACIN
     C                   PARM                    DDACTN            1                          CSE035
     C                   PARM                    DDTPDY           16                          CSE035
     C                   PARM                    DDTCTR           21                          CSE035
 
      ** Trade Details
      ** -------------
      * Nominal (15P 0)
      * Price/discount/yield  (15P 8)
      * Value date (5P 0)
      * Interest Amount (13P 0)
     C                   PARM                    NOML
     C                   PARM                    TPDY
     C                   PARM                    TDVD
     C                   PARM                    ITRA
 
      ** Security Details  (& nominal ccy dec places)
      ** ----------------
     C                   PARM                    SECTY
     C                   PARM                    NomCcyDec
      **
      ** Investment Type Details
      ** -----------------------
      ** Processing Type
     C                   PARM                    PROT              1
 
      ** System Info
      ** -----------
 
      * Date Format (1A)
     C                   PARM                    BJDFIN
 
      * OUTPUTS
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Price Ok INdicator (1A)
      ** Price (15P 8)
     C                   PARM                    DDPricOk
     C                   PARM                    PRIC
                                                                                              CSE037
      ** Access SAR details file to determine if Countervalue                                 CSE037
      ** rounding processing is switched on                                                   CSE037
      *                                                                                       CSE037
     C                   CALLB     'AOSARDR0'                                                 CSE037
     C                   PARM      *BLANKS       @RTCD                                        CSE037
     C                   PARM      '*VERIFY'     @OPTN                                        CSE037
     C                   PARM      'CSE037'      @SARD             6                          CSE037
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE037
     C     @RTCD         IFEQ      *BLANK                                                     CSE037
     C                   MOVEL     'Y'           CSE037            1                          CSE037
     C                   ELSE                                                                 CSE037
     C                   MOVEL     'N'           CSE037                                       CSE037
     C                   END                                                                  CSE037
      *                                                                                       CSE035
      ** Access SAR details file to determine if CSE035                                       CSE035
      ** is switched on                                                                       CSE035
      *                                                                                       CSE035
     C                   CALLB     'AOSARDR0'                                                 CSE035
     C                   PARM      *BLANKS       @RTCD                                        CSE035
     C                   PARM      '*VERIFY'     @OPTN                                        CSE035
     C                   PARM      'CSE035'      @SARD             6                          CSE035
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE035
      *                                                                                       CSE035
     C     @RTCD         IFEQ      *BLANK                                                     CSE035
     C                   MOVEL     'Y'           CSE035            1                          CSE035
     C                   ELSE                                                                 CSE035
     C                   MOVEL     'N'           CSE035                                       CSE035
     C                   END                                                                  CSE035
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
