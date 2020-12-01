     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Funding participant retrieve')                *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFPRTRTV - Funding Participant Retrieve                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CLE064             Date 06Dec10               *
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
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP068  *CREATE    Date 21Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
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
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP068 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      **  Facilities Details file
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(FCLTYFMF : FCLTYFNF)

     FLEREF     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(RF_)

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

      ** Facility Details in file format
     D FCLTYFMFmt    E DS                  EXTNAME(FCLTYFM)


      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Facility Type
     D SDFACT        E DS                  EXTNAME(SDFACTPD)

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

     C                   CLEAR                   FCLTYFMFmt
     C                   MOVE      'Y'           S#ACTNok
     C                   MOVE      'Y'           S#CSSNok
     C                   MOVE      'Y'           S#FACTok
     C                   MOVE      'Y'           S#FCNOok
     C                   MOVE      *BLANK        S#CNUM

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
      **  Validate key fields (Customer, facility type, facility number)
      *
     C                   EXSR      VLDKEY
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#ACTNok      IFEQ      'N'
     C     S#CSSNok      OREQ      'N'
     C     S#FACTok      OREQ      'N'
     C     S#FCNOok      OREQ      'N'
     C                   RETURN
     C                   END

      ** If not insert, check facility exists

     C     S#ACTN        IFNE      'I'
     C                   EXSR      CHKFCLTY
     C                   ENDIF
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#ACTNok      IFEQ      'N'
     C     S#CSSNok      OREQ      'N'
     C     S#FACTok      OREQ      'N'
     C     S#FCNOok      OREQ      'N'
     C                   RETURN
     C                   END

      ** If not insert, valididate the action

     C     S#ACTN        IFNE      'I'
     C                   EXSR      VLDACT
     C                   ENDIF
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#ACTNok      IFEQ      'N'
     C     S#CSSNok      OREQ      'N'
     C     S#FACTok      OREQ      'N'
     C     S#FCNOok      OREQ      'N'
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
      **  Validate key fields (Customer, facility type, facility number
      ***********************************************************
     C     VLDKEY        BEGSR

      ** Validate Customer

     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      S#CSSN        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS

     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0003'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C                   MOVEL     *BLANK        S#CSSN
     C                   MOVEL     BBCUST        S#CSSN
     C                   MOVEL     BBCUST        S#CNUM
      *
     C                   ENDIF

      ** Validate Facility type

     C                   CALL      'AOFACTR0'
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      S#FACT        FKEY              3
     C     SDFACT        PARM      SDFACT        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           S#FACTok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FACT '     FldNameArr(Ix)
     C                   MOVEL     'LEF0004'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     AMFCTY        S#FACT
     C                   ENDIF

      **  Validate Facility Seq No.

     C     S#ACTN        IFNE      'I'
     C                   TESTN                   S#FCNO               98
     C     *IN98         IFEQ      '0'
     C                   MOVE      'N'           S#FCNOok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FCNO '     FldNameArr(Ix)
     C                   MOVEL     'LEF0005'     MsgIdArr(Ix)
     C                   ENDIF

      *  For insert this field should not be entered
     C                   ELSE

     C     S#FCNO        IFNE      *BLANKS
     C                   MOVE      'N'           S#FCNOok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FCNO '     FldNameArr(Ix)
     C                   MOVEL     'LEF0054'     MsgIdArr(Ix)
     C                   ENDIF

     C                   ENDIF
      *
     C                   ENDSR
      ***********************************************************
      /SPACE 5
      ***********************************************************
      **  Check facility exists                                 *
      ***********************************************************
     C     CHKFCLTY      BEGSR
      *
      **  Facility must exist for actions 'E' 'A' and 'R'
      *
     C                   MOVE      S#CNUM        K#CNUM
     C                   MOVE      S#FACT        K#FACT
     C                   MOVE      S#FCNO        K#FCNO
     C                   MOVE      'A'           K#RCTP
      *
     C     FCLTYK        CHAIN(N)  FCLTY                              80
     C     *IN80         IFEQ      *ON
     C                   MOVE      'N'           S#CSSNok
     C                   MOVE      'N'           S#FACTok
     C                   MOVE      'N'           S#FCNOok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0006'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      ***********************************************************
      /SPACE 5
      ***********************************************************
      ** Valididate the action
      ***********************************************************
     C     VLDACT        BEGSR
      *
      ** The primary facility must match that on the funding participant
      *
     C                   MOVE      PMFC          ##PMFC            6
     C                   MOVE      PMFT          ##PMFT            3
     C                   MOVE      PMFN          ##PMFN            2
     C     S#PMFC        IFNE      ##PMFC
     C     S#PMFT        ORNE      ##PMFT
     C     S#PMFN        ORNE      ##PMFN
     C                   MOVE      'N'           S#CSSNok
     C                   MOVE      'N'           S#FACTok
     C                   MOVE      'N'           S#FCNOok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN '     FldNameArr(Ix)
     C                   MOVEL     'LEE0309'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   SELECT
      *
      ** Amendment
      *
     C     S#ACTN        WHENEQ    'A'
      *
      **  The facility must be live
      *
     C     RECI          IFNE      'D'
     C                   MOVE      'N'           S#CSSNok
     C                   MOVE      'N'           S#FACTok
     C                   MOVE      'N'           S#FCNOok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0085'     MsgIdArr(Ix)
     C                   ENDIF
      *
      ** Reversal
      *
     C     S#ACTN        WHENEQ    'R'
      *
      **  The facility must be live
      *
     C     RECI          IFNE      'D'
     C                   MOVE      'N'           S#CSSNok
     C                   MOVE      'N'           S#FACTok
     C                   MOVE      'N'           S#FCNOok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0085'     MsgIdArr(Ix)
     C                   ENDIF

      **  Check if a loan is attached to the prime facility

     C                   EXSR      CHKPRIM

      **  Check if a loan is attached to the funding facility

     C                   EXSR      CHKFUND
      *
      *
     C                   ENDSL
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
      **  Validate facility branch if not an insert
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
      **  Validate Orig. Branch if used and validation required and
      **  is not an insert
     C     BKOBRU        IFEQ      'Y'
     C     BKOBUV        ANDEQ     'Y'
     C     S#ACTN        ANDNE     'I'
      *
     C                   CALL      'ZVOBU'
     C                   PARM      ORBR          @ZOBRX            3
     C                   PARM                    @ERR              1 0
      *
     C     @ERR          IFEQ      1
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0012'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     @ERR          IFEQ      2
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0013'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * CHKPRIM  : Check if a loan is attached to the prime facility  *
      *****************************************************************
     C     CHKPRIM       BEGSR
      *
     C                   MOVE      PMFC          K#CNUM
     C                   MOVE      PMFT          K#FACT
     C                   MOVE      PMFN          K#FCNO
      *
     C     LEREFK        SETLL     LEREF
     C     LEREFK        READE     LEREF                                  70
      *
     C     *IN70         DOWEQ     '0'
      *
     C     RF_RECI       IFEQ      'D'
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEP0203'     MsgIdArr(Ix)
     C                   LEAVE
     C                   ENDIF

     C     LEREFK        READE     LEREF                                  70
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * CHKFUND  : Check if a loan is attached to the funding facility*
      *****************************************************************
     C     CHKFUND       BEGSR
      *
     C                   MOVE      CNUM          K#CNUM
     C                   MOVE      FACT          K#FACT
     C                   MOVE      FCNO          K#FCNO
     C     LEREFK        SETLL     LEREF                                  70
     C     *IN70         IFEQ      *ON
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEP0025'     MsgIdArr(Ix)
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

      * Action, customer, facility type and facility number
     C                   PARM                    S#ACTN            1
     C                   PARM                    S#CSSN           10
     C                   PARM                    S#FACT            3
     C                   PARM                    S#FCNO            2

      * Primary facility customer, type & number
     C                   PARM                    S#PMFC            6
     C                   PARM                    S#PMFT            3
     C                   PARM                    S#PMFN            2
      *
      * OUTPUTS

      * Facility Details in file format
     C                   PARM                    FCLTYFMFmt

      * Action, customer, facility type and facility number OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1

      * Customer number
     C                   PARM                    S#CNUM            6
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
     C     *LIKE         DEFINE    RCTP          K#RCTP

      ** Key lists

     C     FCLTYK        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#RCTP
     C     LEREFK        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
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
