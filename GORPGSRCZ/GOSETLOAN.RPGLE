     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Setup Customer Loan TRAP record')             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSETLOAN - Setup Customer Loan TRAP record                  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. EMP100             Date 16Apr20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3860            Date 11Aug04               *
      *                 BG3092             Date 07Jun04               *
      *                 BG2936             Date 23May04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EMP100 - ML Date Adjustment (Upgrade NADF04 to FM2.1 SP21)   *
      *           Addition of hooks EMP100_001 to EMP100_004          *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3860 - (recompile)                                        *
      *  BG3092 - Records on GPPOSNPD with duplicate key              *
      *  BG2936 - Customer on parts sold loans wrongly set.           *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     FGPUTXTL0  IF A E           K DISK    INFSR(*PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC


     D/COPY WNCPYSRC,EMP100_001                                                          EMP100
     D LOANCL        E DS                  EXTNAME(CLOANCL) PREFIX(CL_)


      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)


     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D/COPY WNCPYSRC,EMP100_002                                                          EMP100


      * ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    LOANCL
     C**********         PARM                    SL_CNUM           6 0                        CSD027
     C                   PARM                    SL_CNUM           6                          CSD027
     C**********         PARM                    SL_MLNR           6 0                        CLE148
     C                   PARM                    SL_MLNR           6                          CLE148
     C**********         PARM                    SL_OLNO           6 0                        CSD027
     C                   PARM                    SL_OLNO           6                          CSD027
      * OUTPUTS
     C                   PARM                    T_TRAP

      * SETUP TRANSACTION INDEX RECORD

     C                   EXSR      SETUP_TRAP

      * RETURN

     C                   RETURN
      *
      *****************************************************************
      * SETUP TRANSACTION INDEX RECORD
      *****************************************************************
     C     SETUP_TRAP    BEGSR

      * Clear Transaction Index

     C                   CLEAR                   T_TRAP

      * Zone
     C                   MOVEL     O#ZONE        T_ZONE
      * Module
     C                   MOVEL     'LE'          T_MOD
      * Sub module
     C                   MOVEL     'LOAN'        T_SMOD

      * Customer - normally transaction customer unless part sold
      * with recourse, then use original borrower
     C                   MOVEL     CL_CNUM       T_CNUM
      *
     C     CL_PTYP       IFEQ      66                                           *
     C     CL_PTYP       OREQ      67                                           *
     C     CL_PTYP       OREQ      69                                           *
     C     CL_PTYP       OREQ      72                                           *
     C*****SL_MLNR       IFNE      0                                            *      BG2936 CLE148
     C     SL_MLNR       IFNE      *BLANK                                                     CLE148
     C                   MOVEL     SL_OLNO       OrigBorrower                                 BG2936
     C                   ELSE                                                   *             BG2936
     C                   MOVEL     SL_CNUM       OrigBorrower                                 BG2936
     C                   ENDIF                                                  *             BG2936
     C     CL_RCSI       IFEQ      'Y'                                          *             BG2936
     C*****OrigBorrower  ANDNE     0                                            *      BG2936 CSD027
     C     OrigBorrower  ANDNE     *BLANKS                                      *             CSD027
     C                   MOVEL     OrigBorrower  T_CNUM                                       BG2936
     C                   ENDIF                                                                BG2936
     C*****CL_RCSI*******IFEQ      'Y'                                          *             BG2936
     C*****CL_OLNO*******ANDNE     0                                            *             BG2936
     C*******************MOVEL     CL_OLNO       T_CNUM                                       BG2936
     C*******************ENDIF                                                                BG2936
     C                   ENDIF
      * Portfolio reference
     C                   MOVEL     CL_PTFR       T_PTFR
      * Booking Branch
     C                   MOVEL     CL_BRCA       T_BRCA
      * Book
     C                   MOVEL     CL_BOKC       T_BOOK
      *
      * Transaction Reference (Loan reference, except for parts sold where
      * it should be made up of original loan reference and part sold
      * loan reference. N.B. for parts sold against IPP's, the original loan
      * reference is the Mirror Loan Number).
      *
     C                   MOVEL     CL_LNRF       T_TREF
      *
     C**********         Z-ADD     CL_OLNO       OrigBorrower      6 0                        CSD027
     C                   MOVE      CL_OLNO       OrigBorrower      6                          CSD027
     C     CL_PTYP       IFEQ      66                                           *
     C     CL_PTYP       OREQ      67                                           *
     C     CL_PTYP       OREQ      69                                           *
     C     CL_PTYP       OREQ      72                                           *
      *
      * For parts sold, CL_OLNO holds the Sale of Loan Number.
      * For parts purchased, CL_OLNO holds the Original Borrower.
      *
     C*****SL_MLNR       IFNE      0                                            *             CLE148
     C     SL_MLNR       IFNE      *BLANK                                                     CLE148
     C                   MOVEL     SL_MLNR       W#LNRF
     C                   MOVEL     SL_OLNO       OrigBorrower
     C                   ELSE                                                   *
     C**********         MOVEL     CL_OLNO       W#LNRF            6 0                        CLE148
     C                   MOVEL     CL_OLNO       W#LNRF            6                          CLE148
     C                   MOVEL     SL_CNUM       OrigBorrower
     C                   ENDIF                                                  *
      *
     C*******************MOVEL     W#LNRF        W#LNRF7           7
     C                   MOVEL     CL_LNRF       W#LNRF7           7
     C                   MOVE      '/'           W#LNRF7
     C                   MOVEL     W#LNRF7       W#LNRF13         13
     C*******************MOVE      CL_LNRF       W#LNRF13
     C                   MOVE      W#LNRF        W#LNRF13
     C                   MOVEL     W#LNRF13      T_TREF
     C                   ENDIF                                                  *
      * Identifier
     C     GPUTXTK       CHAIN     GPUTXTD0                           99
     C     *IN99         IFEQ      *ON
      /COPY GOCPYSRC,GOGETNTID
     C                   MOVEL     T_ZONE        XTZONE
     C                   MOVEL     T_MOD         XTMOD
     C                   MOVEL     T_SMOD        XTSMOD
     C                   MOVEL     T_TREF        XTTREF
     C                   Z-ADD     O#NTID        XTID
     C                   WRITE     GPUTXTD0
     C                   ENDIF
     C                   Z-ADD     XTID          T_ID
      * Shortname
     C                   EVAL      T_SNAM = T_TREF
      * Transaction Type
     C                   MOVEL     CL_LTYP       T_TRTP
      * Transaction Sub-Type
     C                   MOVEL     CL_SUTP       T_TRST
      * Transaction Profit Centre
     C                   MOVEL     CL_PRFC       T_TPFC
      * Risk Customer  - normally transaction customer unless part purchased
      * or part sold without recourse, then use original borrower
     C                   MOVEL     CL_CNUM       T_RCST
      *
     C     CL_PTYP       IFEQ      64                                           *
     C     CL_PTYP       OREQ      65                                           *
     C     CL_PTYP       OREQ      68                                           *
     C     CL_PTYP       OREQ      71                                           *
     C*****OrigBorrower  IFNE      0                                            *             CSD027
     C     OrigBorrower  IFNE      *BLANKS                                      *             CSD027
     C                   MOVEL     OrigBorrower  T_RCST
     C                   ENDIF
     C                   ENDIF
      *
     C     CL_PTYP       IFEQ      66                                           *
     C     CL_PTYP       OREQ      67                                           *
     C     CL_PTYP       OREQ      69                                           *
     C     CL_PTYP       OREQ      72                                           *
     C     CL_RCSI       IFNE      'Y'                                          *
     C*****OrigBorrower  ANDNE     0                                            *             CSD027
     C     OrigBorrower  ANDNE     *BLANKS                                      *             CSD027
     C                   MOVEL     OrigBorrower  T_RCST
     C                   ENDIF
     C                   ENDIF
      * Risk Currency
     C                   MOVEL     CL_CCY        T_RCCY
      * Local Industry Code
     C                   MOVEL     CL_LIND       T_LICD
      * Country Code
     C                   MOVEL     CL_CRSK       T_CNCD
      * Transaction Date
     C                   Z-ADD     CL_DDAT       T_TDAT
      * Start Date
     C                   Z-ADD     CL_VDAT       T_SDAT
      * End Date
     C                   Z-ADD     CL_MDAT       T_EDAT
      /COPY WNCPYSRC,EMP100_004                                                          EMP100
      * Recourse ind
     C                   MOVEL     CL_RCSI       T_RCSI
      * Customer branch
     C                   MOVEL     T_CNUM        @KEY1
     C                   EXSR      ACS_CUST
     C                   MOVEL     BBBRCD        T_CUBR
      * Risk customer branch
     C     T_CNUM        IFNE      T_RCST
     C                   MOVEL     T_RCST        @KEY1
     C                   EXSR      ACS_CUST
     C                   ENDIF
     C                   MOVEL     BBBRCD        T_RCBR
      *
      * Internal Participations Purchased should not affect exposure
      * as this is reported against the agent loan.
      *
     C*****CL_MLNR       IFNE      0                                                          CLE148
     C     CL_MLNR       IFNE      *BLANKS                                                    CLE148
     C                   MOVEL     'Y'           T_OMEI
     C                   ENDIF
      * Matured?
     C     CL_RECI       IFEQ      'M'
     C                   MOVEL     'Y'           T_MATI
     C                   ENDIF
      * Deleted?
     C     CL_RECI       IFEQ      'R'
     C                   MOVEL     'D'           T_ACTN
     C                   ELSE
     C                   MOVEL     'A'           T_ACTN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Access customer details
      ********************************************************************
     C     ACS_CUST      BEGSR
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C     @RTCD         IFNE      *BLANK
     C     @KYST         OREQ      '*ERROR'
     C                   CLEAR                   SDCUST
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR
      ********************************************************************
     C     *INZSR        BEGSR

      * Get Zone

      /COPY GOCPYSRC,GOGETZONE


      * key list

     C     GPUTXTK       KLIST
     C                   KFLD                    T_ZONE
     C                   KFLD                    T_MOD
     C                   KFLD                    T_SMOD
     C                   KFLD                    T_TREF
      /COPY WNCPYSRC,EMP100_003                                                          EMP100
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *********************************************************************
**  CPY@
(c) Finastra International Limited 2003
