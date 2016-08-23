     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Book Code')
      *****************************************************************
      *                                                               *
      *    Midas SE - Midas Security Trading validation module.       *
      *                                                               *
      *  SEVDBOOK - This module validates the Book Code field.        *
      *                                                               *
      *  Component of: SE0070 (Depot movements maintenance)           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 22Apr98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE022 - Depository Definition Enhancement (Recompile)       *
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
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
      ** Array of error message IDs
      ** Array of error message data.
     D FldNamXAr       S             10A   DIM(XArrayMax)
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** External DS for book details
      ** Client Details DS
      ** Client Details DS
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** First DS for access programs, short data structure
      ** Second DS for access programs, long data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input field(s)
      ** --------------
 
      ** Screen inputs
     D DDDPBK          S              2A
     D DDDPBN          S             10A
     D DDDPDO          S              6A
     D DDDPID          S             10A
     D DDDPMD          S              6A
     D DDDPOD          S             10A
 
     ** Transaction Details
     D DPDO            S              5P 0
     D*DPID*****       S              6S 0                                                    CSD027
     D DPID            S              6A                                                      CSD027
     D DPMD            S              5P 0
     D*DPOD*****       S              6S 0                                                    CSD027
     D DPOD            S              6A                                                      CSD027
 
      ** System Details
     D BVDMBC          S              2A
     D BVDPBC          S              2A
     D S01401          S              1A
 
      ** Output field(s)
      ** ---------------
 
     D DDDPBKok        S              1A
     D DPBK            S              2A
 
      ** Working Variables
 
     D WRK6A           S              6A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
     C                   MOVE      *Blanks       DPBK
      *
      ** Validation
      *
     C                   EXSR      DPBKV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDPBKOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DPBKV - Validation routin e for Book Code                     *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DPBKV         BEGSR
 
     C     DDDPBK        IFNE      '  '
      *
      ** must reference an active Book code
      *
     C                   CALLB     'AOBOOKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDDPBK        @BKEY             2
     C     SDBOOK        PARM      SDBOOK        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
      *
      ** Error 213
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPBK'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0191'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPBKOK
     C                   ELSE
      *
      ** Update File/Screen fields
      *
     C                   MOVE      BDBKCD        DDDPBK
     C                   MOVE      BDBKCD        DPBK
     C                   END
 
     C                   ELSE
      *
      ** Must be entered for a depot transfer
      *
     C     DDDPID        IFNE      *BLANKS
     C     DDDPOD        ANDNE     *BLANKS
     C     DDDPMD        ANDNE     *BLANKS
     C     DDDPDO        ANDEQ     *BLANKS
      *
      ** Error 233
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPBK'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0194'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPBKOK
     C                   ELSE
      *
      ** No book code entered - default to Portfolio or Market book
      *
     C                   MOVEL     DDDPBN        @KEY1
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BBCUST        @AENB
     C                   ELSE
     C                   MOVEL     DDDPBN        @AENB
     C                   END
      *
      ** If a DT entry, do not default Book Code
      *
     C*****DPID*         IFNE      *ZEROS                                                     CSD027
     C     DPID          IFNE      *BLANKS                                                    CSD027
     C     DPMD          ANDNE     *ZEROS
     C*****DPOD*         ANDNE     *ZEROS                                                     CSD027
     C     DPOD          ANDNE     *BLANKS                                                    CSD027
     C     DPDO          ANDEQ     *ZEROS
     C                   MOVE      '  '          DPBK
     C                   ELSE
      *
      ** Fetch default Book Code for other movement types
      *
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @AENB             6
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C     @RTCD         IFEQ      *BLANKS
 
     C     BFCLAS        IFEQ      'S'
     C     BFCLAS        OREQ      'D'
     C                   MOVEL     BVDPBC        DPBK
     C                   ELSE
     C                   MOVEL     BVDMBC        DPBK
     C                   END
 
     C                   ELSE
     C                   MOVEL     BVDMBC        DPBK
     C                   END
      *
      ** Update Book screen field
      *
     C                   MOVEL     DPBK          DDDPBK
 
     C                   END
 
     C                   END
 
     C                   END
 
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
 
     C     *entry        PLIST
 
     ** Return Code Error Indicator
     C                   PARM                    RetCodeIn
 
      ** Received Parameters
      ** -------------------
 
     ** Screen input fields
      ** Book (2A)
      ** In Depot (6A)
      ** Out Depot (6A)
      ** Movement Date (6A)
      ** Out Date (6A)
      ** Benificiary (10A)
     C                   PARM                    DDDPBK
     C                   PARM                    DDDPID
     C                   PARM                    DDDPOD
     C                   PARM                    DDDPMD
     C                   PARM                    DDDPDO
     C                   PARM                    DDDPBN
 
     ** Transaction Details
      ** In Depot (6S 0)
      ** Movement Date (5P 0)
      ** Out Depot (6S 0)
      ** Out Date (5P 0)
     C                   PARM                    DPID
     C                   PARM                    DPMD
     C                   PARM                    DPOD
     C                   PARM                    DPDO
 
     ** ICD
     ** System details
      ** S01401 indicator (1A)
      ** Default Portfolio book code (2A)
      ** Default Market book code (2A)
     C                   PARM                    S01401
     C                   PARM                    BVDPBC
     C                   PARM                    BVDMBC
 
     ** Returned Parameter
     ** ------------------
 
     ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Book Code Ok Indicator (1A)
      ** Book Code (2A)
     C                   PARM                    DDDPBKOk
     C                   PARM                    DPBK
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
