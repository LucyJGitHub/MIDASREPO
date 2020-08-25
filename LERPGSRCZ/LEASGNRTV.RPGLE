     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Assignment retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEASGNRTV - Assignment Retrieve                              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
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
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP070  *CREATE    Date 04Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
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
      *  CAP070 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  Assignment Details file
     FLEPARTL2  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** Assignment Details in file format
     D LEPARTPDFmt   E DS                  EXTNAME(LEPARTPD)
 
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** RUNDAT DATA AREA
     D RUNDAT          DS
     D  MBIN                  13     13
 
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
 
      * CLEAR OUTPUTS
 
     C                   CLEAR                   LEPARTPDFmt
     C                   MOVE      'Y'           S#ACTNok
     C                   MOVE      'Y'           S#ASTSok
     C                   MOVE      'Y'           S#ASFSok
     C                   MOVE      *BLANK        S#ASTN
     C                   MOVE      *BLANK        S#ASFN
 
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIdArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
      *
      **  Valid action code
      *
     C                   EXSR      VALACTN
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#ACTNok      IFEQ      'N'
     C                   RETURN
     C                   END
      *
      **  Validate key fields (Assigned To and Assigned From Customers)
      *
     C                   EXSR      VLDKEY
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#ACTNok      IFEQ      'N'
     C     S#ASTSok      OREQ      'N'
     C     S#ASFSok      OREQ      'N'
     C                   RETURN
     C                   END
 
      ** If not insert, check assignment exists
 
     C     S#ACTN        IFNE      'I'
     C                   EXSR      CHKLEPART
     C                   ENDIF
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#ACTNok      IFEQ      'N'
     C     S#ASTSok      OREQ      'N'
     C     S#ASFSok      OREQ      'N'
     C                   RETURN
     C                   END
      *
      **  Validate Authority (if not batch download)
      *
     C     P#MODE        IFNE      'B'
     C     RESPMODE      ANDEQ     'S'
     C                   EXSR      VLDAUT
     C                   ENDIF
 
     C                   RETURN
 
      ***********************************************************
      /SPACE 5
      ***********************************************************
      ** Valididate the action code
      ***********************************************************
     C     VALACTN       BEGSR
 
     C     P#MODE        IFEQ      'B'
 
     C     S#ACTN        IFNE      'I'
     C     S#ACTN        ANDNE     'A'
     C     S#ACTN        ANDNE     'R'
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0001'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ELSE
 
     C     S#ACTN        IFNE      'E'
     C     S#ACTN        ANDNE     'I'
     C     S#ACTN        ANDNE     'A'
     C     S#ACTN        ANDNE     'R'
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0001'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      ***********************************************************
      /SPACE 5
      ***********************************************************
      ** Validate key fields (Assigned To and Assigned From Customers)
      ***********************************************************
     C     VLDKEY        BEGSR
 
      ** Validate Assigned To Customer
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      S#ASTS        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           S#ASTSok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ASTS '     FldNameArr(Ix)
     C                   MOVEL     'LEP0032'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C                   MOVEL     *BLANK        S#ASTS
     C                   MOVEL     BBCUST        S#ASTS
     C                   MOVEL     BBCUST        S#ASTN
      *
     C                   ENDIF
 
      ** Validate Assigned From Customer
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      S#ASFS        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
 
     C                   MOVE      'N'           S#ASFSok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ASFS '     FldNameArr(Ix)
     C                   MOVEL     'LEP0031'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C                   MOVEL     *BLANK        S#ASFS
     C                   MOVEL     BBCUST        S#ASFS
     C                   MOVEL     BBCUST        S#ASFN
      *
     C                   ENDIF
      *
     C                   ENDSR
      ***********************************************************
      /SPACE 5
      ***********************************************************
      **  Check assignment exists                               *
      ***********************************************************
     C     CHKLEPART     BEGSR
      *
      **  Assignment must exist for actions 'E' 'A' and 'R'
      *
     C                   MOVE      S#PMFC        K#CNUM
     C                   MOVE      S#PMFT        K#FACT
     C                   MOVE      S#PMFN        K#FCNO
     C                   MOVE      S#ASTN        K#MNUM
     C                   MOVE      S#ASFN        K#INUM
     C     In_VDTC       IFNE      0
     C                   Z-ADD     In_VDTC       K#VDTC
     C                   ELSE
     C                   Z-ADD     BJRDNB        K#VDTC
     C                   ENDIF
      *
     C     LEPARTK       CHAIN     LEPARTL2                           80
     C     *IN80         IFEQ      *ON
     C                   MOVE      'N'           S#ASTSok
     C                   MOVE      'N'           S#ASFSok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ASTS      'FldNameArr(Ix)
     C                   MOVEL     'LEP0005'     MsgIdArr(Ix)
     C                   ELSE
      *
      ** Only assignments input today can be amended or reversed
      *
     C     S#ACTN        IFEQ      'A'
     C     S#ACTN        OREQ      'R'
     C     VDTC          IFNE      BJRDNB
     C                   MOVE      'N'           S#ASTSok
     C                   MOVE      'N'           S#ASFSok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ASTS      'FldNameArr(Ix)
     C                   MOVEL     'LEP0038'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      ***********************************************************
      /SPACE 5
      ***********************************************************
      *  VLDAUT :   Validate Authority
      ***********************************************************
     C     VLDAUT        BEGSR
      *
      **  Validate users authority to usse this branch/action
     C                   Z-ADD     *ZERO         @ERR
      *
      **  If not a multi-branch
     C     MBIN          IFEQ      'N'
      *
     C                   CALL      'ZVACTU'
     C                   PARM      S#ACTN        @ZACTN            1
     C                   PARM                    @ERR              1 0
      *
     C     @ERR          IFNE      *ZERO
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0009'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Validate branch if not an insert
     C     MBIN          IFEQ      'Y'
     C     S#ACTN        ANDNE     'I'
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      S#ACTN        @ZACTN            1
     C                   PARM      BRCA          @ZBR              3
     C                   PARM                    @ERR              1 0
      *
     C     @ERR          IFEQ      1
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0010'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     @ERR          IFEQ      2
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0011'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
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
      * Response mode
     C                   PARM                    RESPMODE          1
 
      * Action and assigned to and assigned from customers
     C                   PARM                    S#ACTN            1
     C                   PARM                    S#ASTS           10
     C                   PARM                    S#ASFS           10
 
      * Primary facility customer, type & number
     C                   PARM                    S#PMFC            6
     C                   PARM                    S#PMFT            3
     C                   PARM                    S#PMFN            2
 
      * Prime facility branch
     C                   PARM                    FcbrBranch        3
 
      * Value date of change
     C                   PARM                    In_VDTC           5 0
      *
      * OUTPUTS
 
      * Assignment Details in file format
     C                   PARM                    LEPARTPDFmt
 
      * Action and customer OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#ASTSok          1
     C                   PARM                    S#ASFSok          1
 
      * Assigned to customer number
     C                   PARM                    S#ASTN            6
 
      * Assigned from customer number
     C                   PARM                    S#ASFN            6
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
      *
      ** Access Bank Details
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
      *
      ** Access General Ledger Details
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '       '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *  GET MBIN FROM DTAARA/RUNDAT
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C     *LIKE         DEFINE    CNUM          K#CNUM
     C     *LIKE         DEFINE    FACT          K#FACT
     C     *LIKE         DEFINE    FCNO          K#FCNO
     C     *LIKE         DEFINE    MNUM          K#MNUM
     C     *LIKE         DEFINE    INUM          K#INUM
     C     *LIKE         DEFINE    VDTC          K#VDTC
 
      ** Key lists
 
     C     LEPARTK       KLIST
     C                   KFLD                    FcbrBranch
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#MNUM
     C                   KFLD                    K#INUM
     C                   KFLD                    K#VDTC
      *
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
