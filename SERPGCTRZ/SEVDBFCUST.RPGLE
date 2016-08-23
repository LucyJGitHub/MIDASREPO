     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Beneficiary Customer Number')        *
      *****************************************************************
      *                                                               *
      *    Midas SE - Midas Security Trading validation module.       *
      *                                                               *
      *  SEVDBFCUST - This module validates the Beneficiary Customer  *
      *               Number field.                                   *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the validation    *
      *  routine for the said field. This routine has been retrieved  *
      *  from SE0070 and has been converted to ILE RPG and copied into*
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
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
      *  Last Amend No. MD000091           Date 15May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. CSD079             Date 05Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027A            Date 09Dec05               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 09Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186103             Date 06Nov00               *
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039             Date 29Mar00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 19Mar99               *
      *                 CAP003  *CREATE    Date 22Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CSD079 - Enhance Customer Maintenance API (Recompile)        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087 - Depot Movement API - Java Wrapper in Midasplus.     *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE022 - Depository Definition Enhancement                   *
      *  186103 - Depot Movement Walk-in. No warning for undocumented *
      *           customer                                            *
      *  CSE023 - Treaty Withholding Tax                              *
      *  CAP039 - Security customer details API. Fields added to      *
      *           SDSECSPD (recompile)                                *
      *  CAP006 - Bypass initial search (AOCUSTR0) if prompt (?)      *
      *           requested.                                          *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *                                                                         CSE023
      ** Withholding Tax customers details retrieve                             CSE023
     FSDWTCSL1  IF   E           K DISK                                         CSE023
 
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
     D WFldNmXAr       S             10A   DIM(XArrayMax)                       CSE023
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)          CSE023
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)        CSE023
 
      * Client Details data structure
      * Client Details data structure
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * Second DS for access programs, very long data structure                               CSD025
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CSD025
                                                                                              CSD025
      * Second DS for access programs, short data structure                                   CSD025
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSD025
                                                                                              CSD025
      ** Externally described DS for SAR details                                              CSD025
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD025
                                                                                              CSD025
      ** Externally described DS for Branch details                                           CAP087
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  CAP087
     D OldACOD       E                     EXTFLD(QQDFAC)                                     CAP087
                                                                                              CAP087
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     ** Input field(s)
     ** --------------
 
     ** Screen field(s)
     D DDDPBN          S             10A
     D DDDPMD          S              6A
     D DDDPDO          S              6A
     D DDDPID          S             10A
     D DDDPOD          S             10A
     D DDDPAD          S              6A
     D DDDPBA          S              3A                                                      CAP087
     D DPMVType        S              2A                                                      CAP087
     D KBRCH           S              3A                                                      CAP087
 
     ** Output fields
 
     D PC101           S              6A
     D PC102           S              6A
     D DDDPBNOk        S              1A
     D*DPBN*****       S              6S 0                                                    CSD027
     D DPBN            S              6A                                                      CSD027
 
     ** System Info
 
     D S01401          S              1A
 
      * Working Variables
     D WRK6A           S              6A
     D WRK6N           S              6P 0
     D WABICN          S              6A                                                      CAP087
     D*WNBICN***       S              6P 0                                            CAP087 CSD027A
     D WNBICN          S              6A                                                     CSD027A
 
      * Parameters for calling modules
     D @KEY1           S             10A
     D @KYST           S              7A
     D @AENB           S              6A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIx             S              3P 0                                      CSE023
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
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
     C                   MOVE      *BLANK        WFldNmXAr                      CSE023
     C                   MOVE      *BLANK        WMsgIDXAr                      CSE023
     C                   MOVE      *BLANK        WMsgDtXAr                      CSE023
     C                   Z-ADD     0             WIx                            CSE023
      *
      ** Determine Internal customer for the branch, this will be used for                    CAP087
      *  validation later...                                                                  CAP087
      *                                                                                       CAP087
     C                   MOVEL     *BLANKS       WABICN                                       CAP087
     C**********         Z-ADD     0             WNBICN                               CAP087 CSD027A
     C                   Eval      WNBICN  = *Blanks                                         CSD027A
     C     DDDPBA        IFNE      *BLANKS                                                    CAP087
     C                   CALL      'AOBRCHR1'                                                 CAP087
     C                   PARM      *BLANKS       @RTCD                                        CAP087
     C                   PARM      '*KEY   '     @OPTN                                        CAP087
     C                   PARM      DDDPBA        KBRCH                                        CAP087
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CAP087
      *                                                                                       CAP087
     C     @RTCD         IFEQ      *BLANKS                                                    CAP087
     C                   MOVEL     A8BICN        WABICN                                       CAP087
     C                   MOVEL     A8BICN        WNBICN                                       CAP087
     C                   END                                                                  CAP087
      *                                                                                       CAP087
     C                   END                                                                  CAP087
 
      ** VALIDATION
      *
     C                   EXSR      DPBNV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDPBNOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
     C*
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DPBNV - Validation Routine for Beneficiary Customer No.       *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DPBNV         BEGSR
 
     C     DDDPBN        IFEQ      *BLANKS
      *
      ** mandatory entry unless both depots and date In (and not date Out)
      ** have been entered, then prohibited
      *
     C     DDDPID        IFEQ      *BLANKS
     C     DDDPOD        OREQ      *BLANKS
     C     DDDPMD        OREQ      *BLANKS
      *
      ** Error 214
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPBN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0195'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPBNOK
     C                   ELSE
 
     C     DDDPDO        IFNE      *BLANKS
      *
      ** Error 214
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPBN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0195'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPBNOK
     C                   END
 
     C                   END
 
     C**********         Z-ADD     *ZEROS        DPBN                                         CSD027
     C                   EVAL      DPBN = *BLANKS                                             CSD027
      *                                                                                       CAP087
      * If Insert and transaction is Depot Transfer, default the                              CAP087
      * Branch Internal Customer to Beneficial Customer                                       CAP087
      *                                                                                       CAP087
     C     DPMVType      IFEQ      'DT'                                                       CAP087
     C     DDACTN        IFEQ      'I'                                                        CAP087
     C     DDACTN        OREQ      'A'                                                        CAP087
     C                   MOVEL     WABICN        DDDPBN                                       CAP087
     C**********         Z-ADD     WNBICN        DPBN                                 CAP087 CSD027A
     C                   Eval      DPBN = WNBICN                                             CSD027A
     C                   END                                                                  CAP087
     C                   END                                                                  CAP087
      *
      ** else if entered
      *
     C                   ELSE
      *
      ** check not prohibited
      ** If entered and type DT, customer must be Internal customer of branch.                CAP087
      *
     C     DDDPID        IFNE      *BLANKS
     C     DDDPOD        ANDNE     *BLANKS
     C     DDDPMD        ANDNE     *BLANKS
     C     DDDPDO        ANDEQ     *BLANKS
     C     DDDPBN        ANDNE     WABICN                                                     CAP087
      *
      ** Error 214
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPBN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0195'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPBNOK
     C                   END
      *
      **   If associated deal not entered
      *
     C     DDDPAD        IFEQ      *BLANKS
      *
      ** and if only one depot has been entered
      *
     C                   SETOFF                                       33
 
     C     DDDPID        IFNE      *BLANKS
     C     DDDPOD        ANDEQ     *BLANKS
     C                   SETON                                        33
     C                   ELSE
 
     C     DDDPID        IFEQ      *BLANKS
     C     DDDPOD        ANDNE     *BLANKS
     C                   SETON                                        33
     C                   END
 
     C                   END
 
     C     *IN33         IFEQ      '1'
      *
      ** must reference a customer
      *
     C                   MOVEL     DDDPBN        @AENB             6
      *
      ** Test for numeric
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM      DDDPBN        ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
     C                   MOVEL     WRK6N         WRK6A
 
     C     ZALIGNOk      IFEQ      'N'
     C                   IF        %subst(DDDPBN:1:1) <> '?'                    CAP006
     C                   MOVEL     DDDPBN        @KEY1
 
     C*****              CALLB     'AOCUSTR0'                                                 CSD025
     C                   CALLB     'AOCUSTR1'                                                 CSD025
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM      *BLANKS       @KYST
     C*****SDCUST        PARM      SDCUST        DSSDY                                        CSD025
     C     SDCUST        PARM      SDCUST        DSLDY                                        CSD025
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BBCUST        @AENB
     C                   END
     C                   END                                                    CAP006
     C                   END
 
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @AENB
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
      *
      ** Error 216
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPBN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0196'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPBNOK
     C                   ELSE
      *
      ** Update screen/file.
      *
     C                   MOVEL     BFCUST        DPBN
     C                   MOVEL     *BLANKS       DDDPBN
     C                   MOVEL     BFCUST        DDDPBN
      *
      ** with Classification EQ to 'S' or 'D'
      *
     C     BFCLAS        IFNE      'S'
     C     BFCLAS        ANDNE     'D'
      *
      ** Error 216
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPBN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0196'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPBNOK
     C                   END
 
     C                   END
     C                   END
      *
      ** if both depots entered
      *
     C     DDDPID        IFNE      *BLANKS
     C     DDDPOD        ANDNE     *BLANKS
      *
      ** must reference an active customer
      *
     C                   MOVEL     DDDPBN        @AENB
      *
      ** Test for numeric
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM      DDDPBN        ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
 
     C     ZALIGNOk      IFNE      'Y'
     C                   IF        %subst(DDDPBN:1:1) <> '?'                    CAP006
     C                   MOVEL     DDDPBN        @KEY1
 
     C*****              CALLB     'AOCUSTR0'                                                 CSD025
     C                   CALLB     'AOCUSTR1'                                                 CSD025
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM      *BLANKS       @KYST
     C*****SDCUST        PARM      SDCUST        DSSDY                                        CSD025
     C     SDCUST        PARM      SDCUST        DSLDY                                        CSD025
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BBCUST        @AENB
     C                   END
 
     C                   END                                                    CAP006
     C                   END
 
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @AENB
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
      *
      ** Error 217
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPBN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0197'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPBNOK
     C                   END
      *
      ** Update screen/file
      *
     C                   MOVEL     *BLANKS       DDDPBN
     C                   MOVEL     BFCUST        DDDPBN
     C                   MOVEL     BFCUST        DPBN
     C                   END
      *
      ** Else Associated Deal has been entered
      *
     C                   ELSE
      *
      ** must reference an active customer
      *
     C                   MOVEL     DDDPBN        @AENB
      *
      ** Test for numeric
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM      DDDPBN        ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
 
     C     ZALIGNOk      IFNE      'Y'
     C                   IF        %subst(DDDPBN:1:1) <> '?'                    CAP006
     C                   MOVEL     DDDPBN        @KEY1
      *
     C*****              CALLB     'AOCUSTR0'                                                 CSD025
     C                   CALLB     'AOCUSTR1'                                                 CSD025
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM      *BLANKS       @KYST
     C*****SDCUST        PARM      SDCUST        DSSDY                                        CSD025
     C     SDCUST        PARM      SDCUST        DSLDY                                        CSD025
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BBCUST        @AENB
     C                   END
 
     C                   END                                                    CAP006
     C                   END
      *
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @AENB
     C     SDSECS        PARM      SDSECS        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
      *
      ** Error 217
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPBN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0197'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPBNOK
     C                   END
      *
      ** Update Screen/file
      *
     C                   MOVEL     *BLANKS       DDDPBN
     C                   MOVEL     BFCUST        DDDPBN
     C                   MOVEL     BFCUST        DPBN
      *
     C                   END
      *                                                                         CSE023
      ** If Walk-in and CSE023 is switched on                                   CSE023
      *                                                                         CSE023
     C                   IF        CSE023 = 'Y'                                 CSE023
     C                   IF        DDDPID <> *BLANKS AND                        CSE023
     C                             DDDPMD <> *BLANKS AND                        CSE023
     C                             DDDPOD = *BLANKS AND                         CSE023
     C                             DDDPDO = *BLANKS                             CSE023
      *                                                                         CSE023
      ** If beneficiary customer has a classification type 'S' or 'D'.          CSE023
      *                                                                         CSE023
     C                   IF        BFCLAS = 'S' OR                              CSE023
     C                             BFCLAS = 'D'                                 CSE023
      *                                                                         CSE023
     C                   IF        CRTT <> *BLANKS                              CSE023
     C                   MOVEL     DDDPBN        @KEY1                          CSE023
                                                                                CSE023
     C*****              CALLB     'AOCUSTR0'                             CSE023CSD025
     C                   CALLB     'AOCUSTR1'                                   CSD025
     C                   PARM      *BLANKS       @RTCD                          CSE023
     C                   PARM      '*KEY   '     @OPTN                          CSE023
     C                   PARM                    @KEY1                          CSE023
     C                   PARM      *BLANKS       @KYST                          CSE023
     C*****SDCUST        PARM      SDCUST        DSSDY                    CSE023CSD025
     C     SDCUST        PARM      SDCUST        DSLDY                          CSD025
                                                                                CSE023
     C     @RTCD         IFEQ      *BLANKS                                      CSE023
     C                   MOVEL     BBCUST        SCUST             6            CSE023
     C                   ENDIF                                                  CSE023
      *                                                                         CSE023
     C     KYWTCS        KLIST                                                  CSE023
     C                   KFLD                    SCUST                          CSE023
     C                   KFLD                    CRTT                           CSE023
      *                                                                         CSE023
     C     KYWTCS        CHAIN     SDWTCSD0                           01        CSE023
     C**********         IF        NOT *IN01 AND                         CSE023 186103
     C                   IF        *IN01 OR                                     186103
     C                             WHBCWA = 'Y'                                 CSE023
      *                                                                         CSE023
      ** Warning W13                                                            CSE023
      *                                                                         CSE023
     C                   ADD       1             WIx                            CSE023
     C                   MOVEL     'DDDPBN'      WFldNmXAr(WIx)                 CSE023
     C                   MOVEL     'MMA0590'     WMsgIdXAr(WIx)                 CSE023
     C                   MOVE      'W'           DDDPBNOk                       CSE023
     C                   ENDIF                                                  CSE023
      *                                                                         186103
      ** Warning W14                                                            186103
      *                                                                         186103
     C                   IF        *IN01 OR                                     186103
     C                             WHDCRC = 'N'                                 186103
     C                   ADD       1             WIx                            186103
     C                   MOVEL     'DDDPBN'      WFldNmXAr(WIx)                 186103
     C                   MOVEL     'MMA0591'     WMsgIdXAr(WIx)                 186103
     C                   MOVE      'W'           DDDPBNOk                       186103
     C                   ENDIF                                                  186103
      *                                                                         186103
     C                   ENDIF                                                  CSE023
     C                   ENDIF                                                  CSE023
     C                   ENDIF                                                  CSE023
     C                   ENDIF                                                  CSE023
     C                   END
      *
     C                   IF        CSD025 = 'Y'                                               CSD025
     C                             and BBDEAC = 'Y' and DDACTN = 'I'                          CSD025
      *                                                                                       CSD025
     C                   ADD       1             Idx                                          CSD025
     C                   MOVEL     'DDDPBN'      FldNamXAr(Idx)                               CSD025
     C                   EVAL      MsgIdXAr(IDx) = 'ABM0027'                                  CSD025
     C**********         EVAL      MsgDtaXAr(IDx) = BBCUST                           CSD025 MD000091
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(BBCUST)                   MD000091
     C                   MOVE      'N'           DDDPBNOK                                     CSD025
      *                                                                                       CSD025
     C                   ENDIF                                                                CSD025
      *                                                                                       CSD025
     C     S01401        IFEQ      'Y'
     C                   MOVEL     BFNDR1        BFDRF1                                       CSE022
     C                   MOVEL     BFNDR2        BFDRF2                                       CSE022
     C                   MOVE      BFDRF1        PC101
     C                   MOVE      BFDRF2        PC102
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
     C                   PARM                    RetCodeIn
      ** Received Parameters
      ** -------------------
 
      ** Screen Field(s)
      * Beneficiary Customer No. (10A)
      * Movement (In) Date (6A)
      * Out Date (6A)
      * In Depot (10A)
      * Out Depot (10A)
      * Associated Deal No. (6A)
     C                   PARM                    DDDPBN
     C                   PARM                    DDDPMD
     C                   PARM                    DDDPDO
     C                   PARM                    DDDPID
     C                   PARM                    DDDPOD
     C                   PARM                    DDDPAD
 
      ** System Info
      * S01401 SAR Indicator (1A)
 
     C                   PARM                    S01401
      ** Returned Parameters
      ** -------------------
 
     ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr                      CSE023
     C                   PARM                    WMsgIDXAr                      CSE023
     C                   PARM                    WMsgDtXAr                      CSE023
 
      ** Beneficiary Customer Details
     C                   PARM                    SDSECS
 
      ** Fields to be passed to SE1807 for MT5xxs
      * PC101 (6A)
      * PC102 (6A)
     C                   PARM                    PC101
     C                   PARM                    PC102
      * Beneficiary Customer Ok indicator (1A)
      * Beneficiary Customer (6S0)
     C                   PARM                    DDDPBNOk
     C                   PARM                    DPBN
     C                   PARM                    CSE023            1            CSE023
     C                   PARM                    CRTT              2            CSE023
     C                   PARM                    DDACTN            1                          CSD025
     C                   PARM                    DDDPBA                                       CAP087
     C                   PARM                    DPMVType                                     CAP087
 
      ** Check if CSD025 (Customer De-Activation) is active                                   CSD025
      *                                                                                       CSD025
     C                   CALLB     'AOSARDR0'                                                 CSD025
     C                   PARM      *BLANKS       PRtCd             7                          CSD025
     C                   PARM      '*VERIFY'     POptn             7                          CSD025
     C                   PARM      'CSD025'      PSARD             6                          CSD025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD025
                                                                                              CSD025
     C                   MOVE      'N'           CSD025            1                          CSD025
     C                   IF        PRtCd = *Blanks                                            CSD025
     C                   EVAL      CSD025 = 'Y'                                               CSD025
     C                   ENDIF                                                                CSD025
                                                                                              CSD025
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
