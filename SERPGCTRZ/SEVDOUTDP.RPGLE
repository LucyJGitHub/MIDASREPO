     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Out Depot')
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module                              *
      *                                                               *
      *  SEVDOUTDP - Validate Out Depot field.                        *
      *                                                               *
      *  Function:  This module performs the validation for the Out   *
      *             Depot field.                                      *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the validation    *
      *  routine for the said field. This routine has been retrieved  *
      *  from SE0070 and has been converted to ILE RPG and copied into*
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
      *                                                               *
      *  Component of: SE0070 (Depot Movements Maintenance)           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 17Aug05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 190779             Date 16Mar01               *
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039             Date 29Mar00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 19Mar99               *
      *                 CAP003  *CREATE    Date 21Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087 - Depot Movement API - Java Wrapper in Midasplus.     *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP067 - Repurchase Agreements API.                          *
      *  190779 - ? processing not working if other character present *
      *  CSE022 - Depository Definition Enhancement (Recompile)       *
      *  CAP039 - Security customer details API. Fields added to      *
      *           SDSECSPD (recompile)                                *
      *  CAP006 - Bypass initial search (AOCUSTR0) if prompt (?)      *
      *           requested.                                          *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01117
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
 
     D  DDDPOD         S             10A
     D  DDDPAD         S              6A
 
      *** Output ***
 
     D**DPOD****       S              6S 0                                                    CSD027
     D  DPOD           S              6A                                                      CSD027
     D  DDDPODOk       S              1A
 
      *** WORKING VARIABLES ***
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D  @AENB          S              6A
     D  @KEY1          S             10A
     D  @KYST          S              7A
     D  MSGID1         S                   LIKE(#MsgId)
     D  WRK6A          S              6A
     D  WRK6N          S              6P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
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
 
     C**********         Z-ADD     0             DPOD                                         CSD027
     C                   EVAL      DPOD = *BLANKS                                             CSD027
      *
      ** Validation
      *
     C                   EXSR      DPODV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDPODOK      IFEQ      'N'
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
      * DPODV - Validation routine for the Out Depot field            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DPODV         BEGSR
      *                                                                                       CAP067
      ** Determine whether program is running interactively or in batch                       CAP067
      **  ( 0 = batch   1 = interactive)                                                      CAP067
      *                                                                                       CAP067
     C                   CALLB     'ZARTVJOBA'                                                CAP067
     C                   PARM                    @Return           6                          CAP067
     C                   PARM                    @type             1                          CAP067
      *
      ** If associated deal number entered, must reference a customer
      *
     C     DDDPAD        IFNE      *BLANKS
 
     C     DDDPOD        IFEQ      *BLANKS
      *
      ** Error 205
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPOD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0192'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPODOK
 
     C                   ELSE
 
     C                   MOVEL     DDDPOD        @KEY1
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM      *BLANKS       @KYST
 
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BBCUST        DPOD
     C                   END
 
     C     @RTCD         IFNE      *BLANKS
      *
      ** Error 205
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPOD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0192'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPODOK
     C                   END
 
     C                   END
      *
     C                   ELSE
      *
      ** else must reference a customer
      *
      ** Test for numeric
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM      DDDPOD        ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
 
     C                   MOVE      ZFIELD        @AENB             6
 
     C     ZALIGNOk      IFEQ      'N'
      *                                                                                       190779
      * Only look at the Security customer screen not the customer screen                     190779
      *                                                                                       190779
     C**********         IF        %subst(DDDPOD:1:1) <> '?'                           CAP006 CAP067
     C     '?'           SCAN      DDDPOD                                 01                  CAP067
      **********                                                                              190779
     C**********         MOVEL     DDDPOD        @KEY1                                        190779
      **********                                                                              190779
     C**********         CALLB     'AOCUSTR0'                                                 190779
     C**********         PARM      *BLANKS       @RTCD                                        190779
     C**********         PARM      '*KEY   '     @OPTN                                        190779
     C**********         PARM                    @KEY1                                        190779
     C**********         PARM      *BLANKS       @KYST                                        190779
     C*****SDCUST        PARM      SDCUST        DSSDY                                        190779
      **********                                                                              190779
     C*****@RTCD         IFEQ      *BLANKS                                                    190779
     C**********         MOVEL     BBCUST        @AENB                                        190779
     C**********         END                                                                  190779
      **********                                                                              190779
     C**********         ELSE                                                          CAP006 190779
      *                                                                                       CAP067
     C                   IF        *IN01 = *ON                                                CAP067
                                                                                              CAP067
     C                   IF        @type = '1'                                                CAP067
     C                   MOVEL     '?'           @AENB                                        CAP006
     C                   ELSE                                                                 CAP067
     C                   MOVEL     *BLANKS       @AENB                                        CAP067
     C                   ENDIF                                                                CAP067
                                                                                              CAP067
     C                   ELSE                                                                 CAP067
                                                                                              CAP067
     C                   MOVEL     DDDPOD        @KEY1                                        CAP067
     C                   CALLB     'AOCUSTR0'                                                 CAP067
     C                   PARM      *BLANKS       @RTCD                                        CAP067
     C                   PARM      '*KEY   '     @OPTN                                        CAP067
     C                   PARM                    @KEY1                                        CAP067
     C                   PARM      *BLANKS       @KYST                                        CAP067
     C     SDCUST        PARM      SDCUST        DSSDY                                        CAP067
                                                                                              CAP067
     C     @RTCD         IFEQ      *BLANKS                                                    CAP067
     C                   MOVEL     BBCUST        @AENB                                        CAP067
     C                   ENDIF                                                                CAP067
                                                                                              CAP067
     C                   ENDIF                                                                CAP067
     C**********         END                                                           CAP006 CAP067
     C                   END
 
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @AENB
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
      *
      ** Error 206
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPOD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0193'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPODOK
     C                   ELSE
      *
      ** with Classification NE to 'S', 'D' or 'I'
      *
     C     BFCLAS        IFEQ      'S'
     C     BFCLAS        OREQ      'D'
      *
      ** Error 206
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPOD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0193'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPODOK
     C**********         ELSE                                                   CAP006
     C                   END                                                    CAP006
      *
      ** Update screen/file fields
      *
     C                   MOVE      *BLANKS       DDDPOD
     C                   MOVEL     BFCUST        DDDPOD
     C                   MOVEL     BFCUST        DPOD
 
     C                   END
     C                   END
     C**********         END                                                    CAP006
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Return code (10A, returned to caller)
     C                   PARM                    RetCodeIn
 
      ** Received parameters
      ** -------------------
 
      ** Screen Fields **
 
      ** Out Depot (10A)
      ** Associated Deal (6A)
     C                   PARM                    DDDPOD
     C                   PARM                    DDDPAD
 
      ** Returned parameters
      ** -------------------
 
      * Security Client Details
     C                   PARM                    SDSECS
 
      * Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Out Depot Ok Indicator (1A)
      ** Out Depot (6N)
     C                   PARM                    DDDPODOk
     C                   PARM                    DPOD
 
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
