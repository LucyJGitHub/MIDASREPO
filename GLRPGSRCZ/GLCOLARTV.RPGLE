     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*XBI *  OVRDBF FILE(GLCOLAX0) TOFILE(GLCOLAL0) SHARE(*NO)            *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral Allocations retrieve a record')    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLARTV - Assignment Retrieve                              *
      *                                                               *
      *  Function:  This module retrieves a collateral assignment     *
      *             from the database. As it does so, it validates    *
      *             the action code and deal number.                  *
      *                                                               *
      *  Called By: GLCOLAR (*Pgm)                                    *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11623           Date 27Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 20Aug03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  BUG11623 - Sequence No. column should be included (Recompile)*
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API wrapper project                                 *
      *         - Redundant module completely rewritten               *
      *  CGL011 - Collateral Processing for Midas.                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  Assignment Details file
     FGLCOLAX0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
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
     D COLAFilFmt    E DS                  EXTNAME(GLCOLAPD)
 
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
 
      ** Key fields
     D KEYFLDS         DS
     D  K#CREF                 1     10
     D  K#BRCA                11     13
     D**K#CNUM**              14     19  0                                                    CSD027
     D  K#CNUM                14     19                                                       CSD027
     D  K#MODS                20     21
     D**K#FCUS**              22     27  0                                                    CSD027
     D  K#FCUS                22     27                                                       CSD027
     D  K#FTYP                28     30  0
     D  K#FSEQ                31     32  0
     D**K#LNLM**              33     38  0                                                    CLE148
     D  K#LNLM                33     38                                                       CLE148
     D  K#SBRC                39     41
     D**K#SCNM**              42     47  0                                                    CSD027
     D  K#SCNM                42     47                                                       CSD027
     D  K#SCCY                48     50
     D***K#SACD*               51     54  0                                                   CGL029
     D***K#SSEQ*               55     56  0                                                   CGL029
     D  K#SACD                51     60  0                                                    CGL029
     D  K#SSEQ                61     62  0                                                    CGL029
 
      ** Retail Account Details
     D ADREAC          DS
     D  ADREAC1                1      3
     D  ADREAC2                4      9
     D  ADREAC3               10     12
     D***ADREAC4               13     16                                                      CGL029
     D***ADREAC5               17     18                                                      CGL029
     D  ADREAC4               13     22                                                       CGL029
     D  ADREAC5               23     24                                                       CGL029
 
      ** Facility Details
     D ADFCTY          DS
     D  ADFCTY1                1      6
     D  ADFCTY2                7      9
     D  ADFCTY3               10     11
 
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
 
     C                   CLEAR                   COLAFilFmt
     C                   MOVE      'Y'           ADACTNok
 
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
     C     ADACTNok      IFEQ      'N'
     C                   RETURN
     C                   END
 
      ** If not insert, check assignment exists
 
     C     ADACTN        IFNE      'I'
     C                   EXSR      CHKGLCOLA
     C                   ENDIF
      *
      **  Carry out no further validation if errors occurred.
      *
     C     ADACTNok      IFEQ      'N'
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
      ** Validate the action code
      ***********************************************************
     C     VALACTN       BEGSR
 
     C     P#MODE        IFEQ      'B'
 
     C     ADACTN        IFNE      'I'
     C     ADACTN        ANDNE     'A'
     C     ADACTN        ANDNE     'D'
     C                   MOVE      'N'           ADACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN '     FldNameArr(Ix)
     C                   MOVEL     'APM0111'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ELSE
 
     C     ADACTN        IFNE      'E'
     C     ADACTN        ANDNE     'I'
     C     ADACTN        ANDNE     'A'
     C     ADACTN        ANDNE     'D'
     C                   MOVE      'N'           ADACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'ADACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0001'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      ***********************************************************
      /SPACE 5
      ***********************************************************
      **  Check assignment exists                               *
      ***********************************************************
     C     CHKGLCOLA     BEGSR
      *
      **  Assignment must exist for actions 'E' 'A' and 'D'
      *
     C                   MOVE      ADCREF        K#CREF
     C                   MOVE      ADBRCA        K#BRCA
     C                   MOVEL     ADCUSN        K#CNUM
     C                   MOVE      ADMODI        K#MODS
     C                   MOVE      ADFCTY1       K#FCUS
     C                   MOVE      ADFCTY2       K#FTYP
     C                   MOVE      ADFCTY3       K#FSEQ
     C                   MOVE      ADLNLM        K#LNLM
     C                   MOVE      ADREAC1       K#SBRC
     C                   MOVE      ADREAC2       K#SCNM
     C                   MOVE      ADREAC3       K#SCCY
     C                   MOVE      ADREAC4       K#SACD
     C                   MOVE      ADREAC5       K#SSEQ
      *
     C     GLCOLAK       CHAIN     GLCOLAX0                           80
     C     *IN80         IFEQ      *ON
     C                   ADD       1             Ix
     C                   MOVEL     'ADCUSN      'FldNameArr(Ix)
     C                   MOVEL     'LEP0005'     MsgIdArr(Ix)
     C                   END
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
     C                   PARM      ADACTN        @ZACTN            1
     C                   PARM                    @ERR              1 0
      *
     C     @ERR          IFNE      *ZERO
     C                   MOVE      'N'           ADACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'ADACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0009'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Validate branch if not an insert
     C     MBIN          IFEQ      'Y'
     C     ADACTN        ANDNE     'I'
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      ADACTN        @ZACTN            1
     C                   PARM      ADBRCA        @ZBR              3
     C                   PARM                    @ERR              1 0
      *
     C     @ERR          IFEQ      1
     C                   MOVE      'N'           ADACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'ADACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0010'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     @ERR          IFEQ      2
     C                   MOVE      'N'           ADACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'ADACTN '     FldNameArr(Ix)
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
 
      * Action and screen fields
     C                   PARM                    ADACTN            1
     C                   PARM                    ADBRCA            3
     C                   PARM                    ADCUSN           10
     C                   PARM                    ADMODI            2
     C                   PARM                    ADFCTY           11
     C                   PARM                    ADLNLM            6
     C**********         PARM                    ADREAC           18                          CGL029
     C                   PARM                    ADREAC           24                          CGL029
     C                   PARM                    ADCREF           10
      *
      * OUTPUTS
      * Assignment Details in file format
     C                   PARM                    COLAFilFmt
 
      * Action and customer OK indicators
     C                   PARM                    ADACTNok          1
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
 
      ** Key lists
 
     C     GLCOLAK       KLIST
     C                   KFLD                    K#CREF
     C                   KFLD                    K#BRCA
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#MODS
     C                   KFLD                    K#FCUS
     C                   KFLD                    K#FTYP
     C                   KFLD                    K#FSEQ
     C                   KFLD                    K#LNLM
     C                   KFLD                    K#SBRC
     C                   KFLD                    K#SCNM
     C                   KFLD                    K#SCCY
     C                   KFLD                    K#SACD
     C                   KFLD                    K#SSEQ
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
(c) Finastra International Limited 2003
