     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee adjustment convert')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFEADCVT - Fee Adjustment Convert                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE073             Date 13May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGP001             Date 09Dec03               *
      *                 CAP084             Date 10Mar03               *
      *                 CLE031             Date 10Feb03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 204452             Date 03May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP072             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CAP086 - Introduce Auto Autorisation to the API's            *
      *           without it (Recompile)                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGP001 - Status changed from 'Reauth Req' to just 'Reauth.'  *
      *           Output LEF0285 if SSTS = 'R', instead of LER0208.   *
      *  CAP084 - Valid file changed to match LEFEEAD - recompile     *
      *  CLE031 - Lending Enhancements.                               *
      *           LEFEED & LEFEEAD changed  - recompile               *
      *  204452 - Recompiled due to changed PF/LEFEED.                *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FE_)
 
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
 
      *****************************************************************
      /SPACE 5
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
 
      ** Fee Adjustment Details in file format
     D LEFEEADFmt    E DS                  EXTNAME(LEFEEAD)
 
      ** Fee Adjustment Details in screen format
     D FEAD          E DS                  EXTNAME(LEFEADPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Set output screen fields
 
     C                   EXSR      SETFLD
 
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      ** Set output screen fields
      *****************************************************************
     C     SETFLD        BEGSR
 
      ** Customer
 
     C                   MOVEL     FACNUM        S#CNUM
 
      ** Customer details
 
     C                   MOVE      *BLANK        @CNUM
     C                   MOVE      FACNUM        @CNUM
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @CNUM         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     *BLANK        S#CSSN
     C                   MOVEL     BBCUST        S#CSSN
     C                   MOVEL     BBCSSN        S#CSNM
     C                   MOVEL     BBCRNM        S#CRNM
     C                   MOVEL     BBCRTN        S#CRTN
 
      ** Facility Type and Facility Number
 
     C                   MOVEL     FAFACL        S#FACT
     C                   MOVE      FAFACL        S#FCNO
     C                   MOVE      FALOAN        S#LOAN                                       CLE073
 
      ** Fee Sequence Number
 
     C                   MOVE      FAFSEQ        S#FSEQ
 
      ** Get fee details
 
     C                   MOVEL     S#CSSN        K#CNUM
     C                   MOVEL     S#FACT        K#FACL
     C                   MOVE      S#FCNO        K#FACL
     C**********         Z-ADD     *ZEROS        K#LOAN                                       CLE148
     C                   MOVEL     *BLANKS       K#LOAN                                       CLE148
     C                   MOVE      S#FSEQ        K#FSEQ
     C                   MOVE      S#LOAN        K#LOAN                                       CLE073
 
     C     FEEAK         CHAIN     LEFEEDL1                           80
     C     *IN80         IFEQ      *ON
     C                   MOVEL     'LEFEED  '    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     '*ACCESS'     DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
      ** Fee Currency and decimal places
 
     C                   MOVE      FE_FEFCCY     S#FCCY
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FE_FEFCCY     @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     @CURR         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     A6NBDP        FecyNBDP
 
      ** Adjustment Amount and Sign
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      FASADJ        ZFIELD
     C                   Z-ADD     FecyNBDP      ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        S#SADJ
 
     C                   MOVE      FASIGN        S#SIGN
 
      * Adjustment amount edited
 
     C     FASIGN        IFEQ      '-'
     C                   Z-SUB     FASADJ        W#SADJ           13 0
     C                   ELSE
     C                   Z-ADD     FASADJ        W#SADJ                         *
     C                   ENDIF
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      W#SADJ        ZFLD15
     C                   Z-ADD     FecyNBDP      ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        S#SADE
 
      ** Record Status
 
     C                   SELECT
 
     C     SSTS          WHENEQ    'C'
     C                   MOVEL     'LER0194'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTX        S#STAT
 
     C     SSTS          WHENEQ    'R'
     C**********         MOVEL     'LER0208'     ZAMSID                                       CGP001
     C                   MOVEL     'LEF0285'     ZAMSID                                       CGP001
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTX        S#STAT
 
     C     SSTS          WHENEQ    'A'
     C                   MOVEL     'LER0196'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTX        S#STAT
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ZEDIT         BEGSR
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ZSEDIT        BEGSR
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      'J'           ZECODE            1
     C                   PARM      *BLANK        ZOUT21           21
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRTEXT  -  Set up text from message file                      *
      *****************************************************************
     C     SRTEXT        BEGSR
 
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZAMSID            7
     C                   PARM      'LERMSGF '    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM      *BLANK        ZAMSTX          132
 
     C                   ENDSR
      *****************************************************************
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
      *
      * Fee Adjustment details in file format
     C                   PARM                    LEFEEADFmt
      *
      * OUTPUTS
      *
      * Fee Adjustment Details in screen format
     C                   PARM                    FEAD
 
      * Customer details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Fee currency and decimal places
     C*******            PARM                    S#FCCY            3                          CAP084
     C                   PARM                    FecyNBDP          1 0
 
      * Adjustment amount edited
     C                   PARM                    S#SADE           19
 
      * Record status
     C                   PARM                    S#STAT           10
 
      *
      ** Access Bank Details
      *  ~~~~~~~~~~~~~~~~~~~
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     *LIKE         DEFINE    FE_FECNUM     K#CNUM
     C     *LIKE         DEFINE    FE_FEFACL     K#FACL
     C     *LIKE         DEFINE    FE_FELOAN     K#LOAN
     C     *LIKE         DEFINE    FE_FEFSEQ     K#FSEQ
 
      ** Key lists
 
     C     FEEAK         KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACL
     C                   KFLD                    K#LOAN
     C                   KFLD                    K#FSEQ
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
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
