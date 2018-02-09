     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Access a Risk Participant Prm Facility')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LE002520 - Access a Risk Participant Primary Facility        *
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
      *                 CLE042             Date 06Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP069  *CREATE    Date 15Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP069 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FLEFCLTL7  IF   E           K DISK    INFSR(*PSSR)
 
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** Branch Code Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDCUSTDFAC    E                     EXTFLD(QQDFAC)                                     CGL029
 
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
 
      ** Clear outputs
 
     C                   Z-ADD     *ZERO         W#FAMT
     C                   MOVEL     *BLANK        FcbrBranch
     C                   MOVEL     *BLANK        FcbrBICN
     C                   MOVEL     *BLANK        FcbrMQSM
     C**********         Z-ADD     *ZERO         FcbrSYCU                                     CSD027
     C                   EVAL      FcbrSYCU = *BLANKS                                         CSD027
     C                   MOVEL     *BLANK        FccyFCCY
     C                   Z-ADD     *ZERO         FccyNBDP
     C                   MOVEL     *BLANK        FctrTRCA
     C**********         Z-ADD     *ZERO         FccaCANM                                     CSD027
     C                   EVAL      FccaCANM = *BLANKS                                         CSD027
     C                   Z-ADD     *ZERO         FccaCAFT
     C                   Z-ADD     *ZERO         FccaCAFN
 
     C                   MOVEL     *BLANK        S#PRNM
     C                   MOVEL     *BLANK        S#PRTN
     C                   MOVEL     *BLANK        S#ANUM
     C                   MOVEL     *BLANK        S#CRNM
     C                   MOVEL     *BLANK        S#CRTN
     C                   MOVEL     *BLANK        S#FAMT
 
     C                   MOVE      'Y'           S#PMFCOK
     C                   MOVE      'Y'           S#PMFTOK
     C                   MOVE      'Y'           S#PMFNOK
 
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIDArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
     C                   MOVE      *BLANK        WFldNamArr
     C                   MOVE      *BLANK        WMsgIDArr
     C                   MOVE      *BLANK        WMsgDtaArr
     C                   Z-ADD     0             Wx
 
      ** Test Primary facility customer number
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
     C**********         TESTN                   S#PMFC               98                      CSD027
     C**********         MOVE      S#PMFC        @@TEST            1                          CSD027
     C**********         TESTZ                   @@TEST                   99                  CSD027
     C******IN98         IFEQ      '0'                                                        CSD027
     C******IN99         OREQ      '0'                                                        CSD027
     C                   IF        S#PMFC = *BLANKS                                           CSD027
     C                   MOVE      'N'           S#PMFCOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#PMFC'      FldNameArr(Ix)
     C                   MOVEL     'LEA0034'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      S#PMFC        K#CNUM
      *
      ** Access the primary facility customer
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C                   MOVE      *BLANK        @CNUM
     C                   MOVE      S#PMFC        @CNUM
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           S#PMFCOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#PMFC'      FldNameArr(Ix)
     C                   MOVEL     'LEA0034'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     BBCRNM        S#PRNM
     C                   MOVEL     BBCRTN        S#PRTN
     C                   ENDIF
 
     C                   ENDIF
 
      ** Test Primary facility type
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~
 
     C                   TESTN                   S#PMFT               98
     C                   MOVE      S#PMFT        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     *IN98         IFEQ      '0'
     C     *IN99         OREQ      '0'
     C                   MOVE      'N'           S#PMFTOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#PMFT'      FldNameArr(Ix)
     C                   MOVEL     'LEF0004'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      S#PMFT        K#FACT
     C                   ENDIF
 
      ** Test Primary facility number
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
     C                   TESTN                   S#PMFN               98
     C                   MOVE      S#PMFN        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     *IN98         IFEQ      '0'
     C     *IN99         OREQ      '0'
     C                   MOVE      'N'           S#PMFNOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#PMFN'      FldNameArr(Ix)
     C                   MOVEL     'LEU0008'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      S#PMFN        K#FCNO
     C                   ENDIF
 
      *
      ** Access the Prime facility
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~
 
     C     K#LTL0        CHAIN(N)  FCLTYFMF                           70
 
      * Invalid facility
 
     C     *IN70         IFEQ      *ON
 
     C                   MOVE      'N'           S#PMFCOK
     C                   MOVE      'N'           S#PMFTOK
     C                   MOVE      'N'           S#PMFNOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#PMFC'      FldNameArr(Ix)
     C                   MOVEL     'LEE0309'     MsgIdArr(Ix)
 
     C                   ENDIF
      *
      * Exit if any errors
      *
     C     Ix            IFNE      0
 
     C                   RETURN
 
     C                   ENDIF
 
      *  Prime Facility branch and currency
 
     C                   MOVEL     BRCA          FcbrBranch
     C                   MOVEL     FCCY          FccyFCCY
 
      *  Prime Facility amount
 
     C                   Z-ADD     FAMT          W#FAMT
      *
      ** Access the primary facility branch code
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C                   CALL      'AOBRCHR1'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BRCA          @BRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     BRCA          DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     A8BICN        FcbrBICN
     C                   MOVEL     A8MQSM        FcbrMQSM
     C                   MOVEL     A8SYCU        FcbrSYCU
      *
      ** Access the primary facility currency code
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C                   CALLB     'AOCURRR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FCCY          @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     FCCY          DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     A6NBDP        FccyNBDP
 
      * Prime Facility tranche/credit agreement ind
      * Prime Facility credit agreement customer, type & number
 
     C                   MOVEL     TRCA          FctrTRCA
     C**********         Z-ADD     CANM          FccaCANM                                     CSD027
     C                   EVAL      FccaCANM = CANM                                            CSD027
     C                   Z-ADD     CAFT          FccaCAFT
     C                   Z-ADD     CAFN          FccaCAFN
      *
      ** Access the agent customer
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~
     C                   MOVE      *BLANK        @CNUM
     C                   MOVE      ANUM          @CNUM
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BBCUST        S#ANUM
     C                   MOVEL     BBCRNM        S#CRNM
     C                   MOVEL     BBCRTN        S#CRTN
     C                   ENDIF
 
      ** Edit the primary facility amount
 
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      W#FAMT        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT2
     C                   MOVE      ZFIELD        S#FAMT
 
     C                   RETURN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ZEDIT2        BEGSR
     C                   CALLB     'ZEDIT2'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             2 0
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
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Primary facility customer, type & number
     C                   PARM                    S#PMFC            6
     C                   PARM                    S#PMFT            3
     C                   PARM                    S#PMFN            2
      *
      * OUTPUTS
      *
 
      * Prime Facility amount
      * Prime Facility branch
      * Prime Facility branch details
      * Prime Facility currency
      * Prime Facility currency decimal places
      * Prime Facility tranche/credit agreement ind
      * Prime Facility credit agreement customer, type & number
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C**********         PARM                    FccaCANM          6 0                        CSD027
     C                   PARM                    FccaCANM          6                          CSD027
     C                   PARM                    FccaCAFT          3 0
     C                   PARM                    FccaCAFN          2 0
 
      * Primary customer name & town
     C                   PARM                    S#PRNM           20
     C                   PARM                    S#PRTN           10
 
      * Agent customer number, name & town
     C                   PARM                    S#ANUM            6
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Primary facility amount edited
     C                   PARM                    S#FAMT           14
 
      * Field OK flags
     C                   PARM                    S#PMFCOK          1
     C                   PARM                    S#PMFTOK          1
     C                   PARM                    S#PMFNOK          1
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
 
     C     *LIKE         DEFINE    CNUM          K#CNUM
     C     *LIKE         DEFINE    FACT          K#FACT
     C     *LIKE         DEFINE    FCNO          K#FCNO
 
      * Key lists
 
     C     K#LTL0        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
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
(c) Finastra International Limited 2002
