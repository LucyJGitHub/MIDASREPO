     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Repo support log setup')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMREPOLOG - Money Market Repo Support Log Setup              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 14Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
     FSECTY     IF   E           K DISK
     F                                     INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** Depot Movement record for Repos
     D TranFilFmt    E DS                  EXTNAME(DPTMVD)
 
      ** Midas MM API LDNI Format Definiton File
     D RepoDScnFmt   E DS                  EXTNAME(MMRPDDPD)
 
      **  Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      **  Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D TRANSDTL        S           5800A
     D PAction         S              1A
     D PSTS            S             24A
     D PCSTS           S             10A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRPROC
     C
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRPROC - Convert file fields to screen format              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: MMLDNICVT, ZASETINCVT                                  *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C                   CLEAR                   RepoDScnFmt
 
      ** Set REPO deal no to Blanks
     C                   EVAL      DDDLNO = DPRN
 
      ** Depot Reference Number
     C                   EVAL      DDDPMV = DPRN
 
      ** Set Action to Blanks
     C                   EVAL      DDACTN = *BLANKS
 
      ** Set up Security Shortname
     C                   EVAL      DDSECT = DPSS
 
      ** Set up Nominal
      *
      ** Access Security Details
     C     DDSECT        CHAIN     SECTY                              99
 
      ** Access no of decimal places of Nominal currency
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd             7
     C                   PARM      '*KEY   '     POptn             7
     C                   PARM      NMCY          PAjcd             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   MOVE      DPNA          ZFLD15           15 0
     C                   MOVE      NMDP          ZADEC             1 0
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      ZOUT21        DDNOML
     C                   Z-ADD     0             W#NML
      *
      ** If Nominal Decimal Places = 0 then Multiply by 10000
     C                   IF        NMDP = 0
     C     10000         MULT      ZFLD15        W#NML            15 0
     C                   ADD       W#NML         W#NOML           15 0
     C                   ENDIF
      *
      ** If Nominal Decimal Places = 1 then Multiply by 1000
     C                   IF        NMDP = 1
     C     1000          MULT      ZFLD15        W#NML
     C                   ADD       W#NML         W#NOML
     C                   ENDIF
     C
      *
      ** If Nominal Decimal Places = 2 then Multiply by 100
     C                   IF        NMDP = 2
     C     100           MULT      ZFLD15        W#NML
     C                   ADD       W#NML         W#NOML
     C                   ENDIF
     C
      *
      ** If Nominal Decimal Places = 3 then Multiply by 10
     C                   IF        NMDP = 3
     C     10            MULT      ZFLD15        W#NML
     C                   ADD       W#NML         W#NOML
     C                   ENDIF
      *
      ** If Nominal Decimal Places = 4 then Multiply by 1
     C                   IF        NMDP = 4
     C     1             MULT      ZFLD15        W#NML
     C                   ADD       W#NML         W#NOML
     C                   ENDIF
      *
      ** Set up Value Price
     C                   Z-ADD     8             ZADEC
     C                   MOVEL     *BLANK        ZFLD15
     C                   MOVEL     *BLANK        ZOUT21
     C                   MOVE      MKTP          ZFLD15
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE
     C                   PARM                    ZOUT21
     C
     C                   MOVE      ZOUT21        DDVALP
 
      ** Set up Our Depot
     C                   MOVE      DPID          W#DEPIN           6
      ** Access Customer data via access program
      ** (database error handling done in access program)
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      W#DEPIN       PuKEY1           10
     C                   PARM      *BLANKS       PiKYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   MOVE      BBCSSN        DDORDP
     C                   MOVE      *BLANKS       W#DEPIN
 
      ** Set up Counterparty Depot
     C                   MOVE      DPOD          W#DEPOT           6
      *
      ** Access Customer data via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      W#DEPOT       PuKEY1
     C                   PARM      *BLANKS       PiKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   MOVE      BBCSSN        DDCPDP
     C                   MOVE      *BLANKS       W#DEPOT
 
      ** Set Up Exchange Rate
     C                   MOVEL     *BLANK        ZFLD15
     C                   MOVE      DEXRT         ZFLD15
     C                   MOVEL     *BLANK        ZOUT21
     C
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE
     C                   PARM                    ZOUT21
     C
     C                   MOVE      ZOUT21        DDEXCR
 
     C                   EVAL      TRANSDTL = RepoDScnFmt
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    PAction
     C                   PARM                    TranFilFmt
     C                   PARM                    TRANSDTL
     C                   PARM                    W#NOML
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------+
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
