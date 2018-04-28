     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Buy-sell backs validate depot')
      *****************************************************************
      *                                                               *
      *    Midas SE - Midas Security Trading validation module.       *
      *                                                               *
      *  SEVBSDO  - This module validates the Our Depot and           *
      *             Counterparty Depot fields in Buy-Sell Backs       *
      *             maintenance.                                      *
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
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 190776             Date 19Jun01               *
      *                 191878             Date 23Apr01               *
      *                 191876             Date 23Apr01               *
      *                 190779             Date 16Mar01               *
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006  *CREATE    Date 28May99               *
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
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  190776 - ? processing calls incorrect screen.                *
      *  191878 - Clearance type should be set up automatically       *
      *  191876 - Our depot should onluy conform to being a security  *
      *           customer it does not need to check for depot status.*
      *           Consider this a part of fix 191878.                 *
      *  190779 - ? processing calls incorrect screen.                *
      *  CSE022 - Depository Definition Enhancement                   *
      *  CSE006 - Repurchase Agreements (REPOs) enhancement           *
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
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array containing Depot References from Security Standing Data
     D Depots          S              6A   DIM(10)
 
      ** Array containing Participant flag for each Depot Reference element
     D PartArr         S              2A   DIM(10)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Client Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Securities Trading Standing Data
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      * Securities Client Details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
     D  PartDS                85    104
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
      ** ------------
 
      ** Screen input
 
     D ScnDepot        S             10A
     D DDTCNR          S             10A
 
     D TPTCNR          S              6S 0
 
      ** Output fields
      ** -------------
 
     D FileDepot       S              6S 0
     D ScnDepotOK      S              1A
     D TC1DI           S              1A                                                      190776
     D FC1DI           S              1A                                                      190776
     D CustPNp1        S              2A                                                      190776
     D CustPNP2        S              2A                                                      190776
     D DDCLTY          S              1A                                                      190776
     D ERRIND          S              1A                                                      190776
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D DDDELFOK        S              1A                                                      190776
     D DDDELTOK        S              1A                                                      190776
 
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
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
      *
      ** Validation
      *
     C                   EXSR      DPIDV
      *
      ** If an error was found, set the return code appropriately
      *
     C     ScnDepotOK    IFEQ      'N'
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
      * DPIDV - Validate Depot field                                  *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: DEPOTCHK                                               *
      *                                                               *
      *****************************************************************
 
     C     DPIDV         BEGSR
      *
      ** Must reference an active securities customer
      *
      * If '?' entered, display securities customers
      *                                                                                       190779
      * Only allow search against the first character as searching with                       190779
      * other characters i.e ?00505 displays different screen.                                190779
      *                                                                                       190779
     C                   IF        %subst(ScnDepot:1:1) =  '?'                                190779
     C                   MOVE      *Blanks       ScnDepot                                     190779
     C                   MOVEL     '?'           ScnDepot                                     190779
     C                   END                                                                  190779
      *                                                                                       190779
     C     ScnDepot      IFEQ      '?'
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      '?      '     @AENB
     C     SDSECS        PARM      SDSECS        DSSDY
      *
      * Save selection
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BFCUST        ScnDepot
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Else if not '?', test for numeric
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM      ScnDepot      ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
 
     C                   MOVE      ZFIELD        @AENB             6
     C
      ** Depot is not numeric
     C     ZALIGNOk      IFEQ      'N'
     C     ScnDepot      ANDNE     '?'                                                        190779
     C                   MOVE      ScnDepot      @KEY1
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C**********         PARM                    @KEY1            10                          190779
     C                   PARM      DDTCNR        @KEY1            10                          190779
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BBCUST        @AENB
     C                   ENDIF
 
     C                   ENDIF
 
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @AENB
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C                   ENDIF
      *                  End of 'If ScnDepot = '?' (and ELSE)...'
      *
     C     @RTCD         IFNE      *BLANKS
      *
      ** Error mesage
     C                   ADD       1             Idx
     C                   MOVEL     FldName       FldNamXAr(Idx)
     C                   MOVEL     'MMA0720'     MsgIdXAr(Idx)
     C                   MOVE      'N'           ScnDepotOK
     C                   ELSE
      *
      ***with*Classification*equal*to*'E',*'C',*'K',*'X'*or*'M'********                       CSE022
      ** with Classification equal to 'E', 'C', 'X' or 'M'                                    CSE022
      *
     C                   IF        BFCLAS <> 'E' and BFCLAS <> 'C'
     C**********                   and BFCLAS <> 'X' and BFCLAS <> 'K'                        CSE022
     C**********                   and BFCLAS <> 'M'                                          CSE022
     C                             and BFCLAS <> 'X' and BFCLAS <> 'M'                        CSE022
      ** Error mesage
     C                   ADD       1             Idx
     C                   MOVEL     FldName       FldNamXAr(Idx)
     C                   MOVEL     'MMA1110'     MsgIdXAr(Idx)
     C                   MOVE      'N'           ScnDepotOK
     C                   ELSE
      *
      ** The Counterparty must be a participant of this Depot
      *
     C*********          EXSR      DEPOTCHK                                                   190776
      *
     C                   EXSR      VALDTDF_P                                                  190776
      *                                                                                       190776
      ** If no errors, update screen/file fields
      *
     C                   IF        ScnDepotOK <> 'N'
     C                   MOVE      *BLANKS       ScnDepot
     C                   MOVEL     SaveDepot     ScnDepot
     C                   MOVEL     SaveDepot     FileDepot
     C                   ENDIF
      *
     C                   ENDIF
      *                  End of 'If BFCLAS <> ...'
      *
     C                   ENDIF
      *                  End of 'If Rtrn Code <> *Blanks for AOSECSR0'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DEPOTCHK - Check if Counterparty is participant of Depot      *
      *                                                               *
      * Called by: DPIDV                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     DEPOTCHK      BEGSR
     C
      ** Save Depot before second call to access object
     C                   MOVEL     BFCUST        SaveDepot         6
     C                   MOVEL     BFCLAS        SaveClas          1                          191878
 
     C                   MOVE      TPTCNR        P@TCNR
 
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    P@TCNR            6
     C     SDSECS        PARM      SDSECS        DSSDY
 
      ** Initialise array with Participant flags
     C                   MOVEA     PartDS        PartArr
      *
     C                   Z-ADD     1             x                 2 0
      *
      ** If Depot not on SDSTRDPD, error
      ** And not our depot mark as an error                                                   191876
      *                                                                                       191876
     C     SaveDepot     LOOKUP    Depots(x)                              50
      *
     C                   IF        *IN50 = *Off
     C                   ADD       1             Idx
     C                   MOVEL     FldName       FldNamXAr(Idx)
     C                   MOVEL     'MMA0721'     MsgIdXAr(Idx)
     C                   MOVE      'N'           ScnDepotOK
      *
     C                   ELSE
      *
      ** The Counterparty must be a participant of this Depot
      *
     C                   IF        PartArr(x) <> 'P'
     C                   ADD       1             Idx
     C                   MOVEL     FldName       FldNamXAr(Idx)
     C                   MOVEL     'MMA0721'     MsgIdXAr(Idx)
     C                   MOVE      'N'           ScnDepotOK
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       190776
      * ValDTDF_P - Subroutine to perform the validation for the      *                       190776
      *             Delivery To and Deliver From fields - Purchases   *                       190776
      *                                                               *                       190776
      *****************************************************************                       190776
     C     ValDTDF_P     BEGSR                                                                190776
      *                                                                                       190776
      ** Reset Error indicator                                                                190776
      *                                                                                       190776
     C                   MOVE      '0'           ErrInd                                       190776
      *                                                                                       190776
     C     TC1DI         IFEQ      'E'                                                        190776
     C     FC1DI         ANDEQ     'E'                                                        190776
                                                                                              190776
     C     CustPNp1      IFNE      'P '                                                       190776
                                                                                              190776
     C     ErrInd        IFNE      '1'                                                        190776
     C                   MOVE      '1'           ErrInd                                       190776
      ** Deliver To                                                                           190776
     C                   ADD       1             Idx                                          190776
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0305'                                  190776
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'                                 190776
     C                   EVAL      DDDELTok = 'N'                                             190776
      ** Deliver From                                                                         190776
     C                   ADD       1             Idx                                          190776
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0305'                                  190776
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'                                 190776
     C                   EVAL      DDDELFok = 'N'                                             190776
     C                   END                                                                  190776
                                                                                              190776
     C                   END                                                                  190776
     C                   END                                                                  190776
      *                                                                                       190776
     C     CustPNp1      IFNE      'P '                                                       190776
     C     CustPNp1      ANDNE     'NP'                                                       190776
                                                                                              190776
     C     TC1DI         IFEQ      'E'                                                        190776
     C     FC1DI         ANDNE     'C'                                                        190776
                                                                                              190776
     C     ErrInd        IFNE      '1'                                                        190776
     C                   MOVE      '1'           ErrInd                                       190776
                                                                                              190776
      ** Deliver To                                                                           190776
     C                   ADD       1             Idx                                          190776
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0306'                                  190776
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'                                 190776
     C                   EVAL      DDDELTok = 'N'                                             190776
                                                                                              190776
      ** Deliver From                                                                         190776
     C                   ADD       1             Idx                                          190776
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0306'                                  190776
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'                                 190776
     C                   EVAL      DDDELFok = 'N'                                             190776
     C                   END                                                                  190776
                                                                                              190776
     C                   END                                                                  190776
                                                                                              190776
     C                   END                                                                  190776
      *                                                                                       190776
     C     DDCLTY        IFEQ      '5'                                                        190776
                                                                                              190776
     C     FC1DI         IFEQ      'C'                                                        190776
     C     CustPNp2      ANDNE     'P '                                                       190776
     C     FC1DI         OREQ      'E'                                                        190776
     C     CustPNp1      ANDNE     'P '                                                       190776
                                                                                              190776
     C     ErrInd        IFNE      '1'                                                        190776
     C                   MOVE      '1'           ErrInd                                       190776
      ** Deliver From                                                                         190776
     C                   ADD       1             Idx                                          190776
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0307'                                  190776
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'                                 190776
     C                   EVAL      DDDELFok = 'N'                                             190776
     C                   END                                                                  190776
                                                                                              190776
     C                   END                                                                  190776
     C                   END                                                                  190776
      *                                                                                       190776
     C     CustPNp2      IFNE      'P '                                                       190776
                                                                                              190776
     C     FC1DI         IFEQ      'C'                                                        190776
                                                                                              190776
     C     ErrInd        IFNE      '1'                                                        190776
     C                   MOVE      '1'           ErrInd                                       190776
      ** Deliver To                                                                           190776
     C                   ADD       1             Idx                                          190776
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0308'                                  190776
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'                                 190776
     C                   EVAL      DDDELTok = 'N'                                             190776
                                                                                              190776
      ** Deliver From                                                                         190776
     C                   ADD       1             Idx                                          190776
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0308'                                  190776
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'                                 190776
     C                   EVAL      DDDELFok = 'N'                                             190776
     C                   END                                                                  190776
                                                                                              190776
     C                   END                                                                  190776
     C                   END                                                                  190776
      *                                                                                       190776
     C     CustPNp1      IFNE      'P '                                                       190776
                                                                                              190776
     C     FC1DI         IFEQ      'E'                                                        190776
     C     TC1DI         ANDEQ     'C'                                                        190776
                                                                                              190776
     C     ErrInd        IFNE      '1'                                                        190776
     C                   MOVE      '1'           ErrInd                                       190776
                                                                                              190776
      ** Deliver To                                                                           190776
     C                   ADD       1             Idx                                          190776
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0309'                                  190776
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'                                 190776
     C                   EVAL      DDDELTok = 'N'                                             190776
                                                                                              190776
      ** Deliver From                                                                         190776
     C                   ADD       1             Idx                                          190776
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0309'                                  190776
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'                                 190776
     C                   EVAL      DDDELFok = 'N'                                             190776
     C                   END                                                                  190776
                                                                                              190776
     C                   END                                                                  190776
     C                   END                                                                  190776
                                                                                              190776
     C                   ENDSR                                                                190776
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
      ** Received Parameter
      ** ------------------
 
      ** Screen Fields
      * In Depot (10A)
      * Counterparty - file format (10A)
     C                   PARM                    ScnDepot
     C                   PARM                    TPTCNR
 
      ** Field name (10A)
     C                   PARM                    FldName          10
 
      ** Returned parameters
      ** -------------------
 
      * Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      * Depot Ok Indicator (1A)
      * Depot (6S 0)
     C                   PARM                    ScnDepotOK
     C                   PARM                    FileDepot
      *
      * Saved clasification flag used later for creating clearance type                       191878
     C                   PARM                    SaveClas                                     191878
      ** Access Securities Trading Details
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      * Database Error
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   MOVEL     '101'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set up Array 'Depots' with Standing Data Depots in order 1-10
     C                   MOVEA     BVDR1         Depots(1)
     C                   MOVEA     BVDR2         Depots(2)
     C                   MOVEA     BVDR3         Depots(3)
     C                   MOVEA     BVDR4         Depots(4)
     C                   MOVEA     BVDR5         Depots(5)
     C                   MOVEA     BVDR6         Depots(6)
     C                   MOVEA     BVDR7         Depots(7)
     C                   MOVEA     BVDR8         Depots(8)
     C                   MOVEA     BVDR9         Depots(9)
     C                   MOVEA     BVDR10        Depots(10)
 
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
