     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Branch Code')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVBHCD  - Validate Branch Code                              *
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
      *  Last Amend No. 258838A            Date 27Mar09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 249179             Date 17Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 01Apr99               *
      *                                    Date ddmmmyy               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  258838A - Access rights to Customer Maintenance: add new     *
      *            System Value to control user branch validation     *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249179 - Validate action codes defined for user              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP034 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
      *                                                               *
      *****************************************************************
 
      ** Midas SD Bank Details ICD Retrieve Logical
     FSDBANKL1  IF   E           K DISK
     F                                     RENAME(@BJREEF:BANKDET)
 
      ** Midas SD Branch Codes Retrieval
     FSDBRCHL1  IF   E           K DISK
     F                                     RENAME(@A8REB0:BRCHCOD)
 
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
                                                                                             258838A
      ** Constant paramater for AOSVALR0                                                     258838A
     D BRCUSR          C                   CONST('CheckBrchUserAuthori')                     258838A
     D CurSysVal       DS           200                                                      258838A
     D CurVal                  1      1                                                      258838A
                                                                                             258838A
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
      ** VALIDATION
      *
     C                   EXSR      BRCDV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDBRCDOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION - Branch Code
      *****************************************************************
     C     BRCDV         BEGSR
 
      * If module MultiBranching is OFF
     C     BGMBIN        IFEQ      'N'
 
      * find 'bank' record on bank file to get default branch
     C     'BANK      '  CHAIN     BANKDET                            90
     C     *IN90         IFEQ      '0'
     C                   MOVE      BJSBRC        DDBRCD
     C                   ENDIF
 
      * If module MultiBranching is ON
     C                   ELSE
 
      * Branch code must be entered
     C     DDBRCD        IFEQ      *BLANK
     C                   MOVE      'N'           DDBRCDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRCD'      FldNamXAr(Idx)
     C                   MOVEL     'USR0909'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
      * and must be on file
     C     DDBRCD        IFNE      *BLANK
     C     DDBRCD        CHAIN     BRCHCOD                            90
     C     *IN90         IFEQ      '1'
     C                   MOVE      'N'           DDBRCDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRCD'      FldNamXAr(Idx)
     C                   MOVEL     'USR0075'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
                                                                                             258838A
      ** Check branch validation system value                                                258838A
     C                   CALLB     'AOSVALR0'                                                258838A
     C                   PARM                    @RTCD             7                         258838A
     C                   PARM      BRCUSR        @OP01            20                         258838A
     C     CurSysVal     PARM                    @VL01           200                         258838A
     C                   PARM                    @OP02            20                         258838A
     C                   PARM                    @VL02           200                         258838A
     C                   PARM                    @OP03            20                         258838A
     C                   PARM                    @VL03           200                         258838A
     C                   PARM                    @OP04            20                         258838A
     C                   PARM                    @VL04           200                         258838A
     C                   PARM                    @OP05            20                         258838A
     C                   PARM                    @VL05           200                         258838A
     C                   PARM                    @OP06            20                         258838A
     C                   PARM                    @VL06           200                         258838A
     C                   PARM                    @OP07            20                         258838A
     C                   PARM                    @VL07           200                         258838A
     C                   PARM                    @OP08            20                         258838A
     C                   PARM                    @VL08           200                         258838A
     C                   PARM                    @OP09            20                         258838A
     C                   PARM                    @VL09           200                         258838A
     C                   PARM                    @OP10            20                         258838A
     C                   PARM                    @VL10           200                         258838A
                                                                                             258838A
      *                                                                                       249179
      ** If synchronous input, check user's authority for the branch                          249179
      *                                                                                       249179
                                                                                             258838A
     C                   If        CurVal <> 'N'                                             258838A
     C                   Z-ADD     *ZERO         @ERR                                         249179
     C     DDBRCDOK      IFNE      'N'                                                        249179
     C     RespMode      ANDEQ     'S'                                                        249179
                                                                                              249179
     C     BGMBIN        IFEQ      'Y'                                                        249179
     C                   CALL      'ZVACTBU'                                                  249179
     C                   PARM      DDACTN        @ZACTN            1                          249179
     C                   PARM      DDBRCD        @ZBR              3                          249179
     C                   PARM                    @ERR              1 0                        249179
      *                                                                                       249179
      ** If action code invalid for user                                                      249179
      *                                                                                       249179
     C     @ERR          IFEQ      1                                                          249179
     C                   MOVE      'N'           DDBRCDOK                                     249179
     C                   ADD       1             Idx                                          249179
     C                   MOVEL     'DDBRCD'      FldNamXAr(Idx)                               249179
     C                   MOVEL     'RE71070'     MsgIdXAr(Idx)                                249179
     C                   ELSE                                                                 249179
     C     @ERR          IFEQ      2                                                          249179
     C                   MOVE      'N'           DDBRCDOK                                     249179
     C                   ADD       1             Idx                                          249179
     C                   MOVEL     'DDBRCD'      FldNamXAr(Idx)                               249179
     C                   SELECT                                                               249179
     C                   WHEN      DDACTN='E'                                                 249179
     C                   MOVEL     'RE7105B'     MsgIdXAr(Idx)                                249179
     C                   WHEN      DDACTN='I'                                                 249179
     C                   MOVEL     'RE7102B'     MsgIdXAr(Idx)                                249179
     C                   WHEN      DDACTN='A'                                                 249179
     C                   MOVEL     'RE7103B'     MsgIdXAr(Idx)                                249179
     C                   WHEN      DDACTN='D'                                                 249179
     C                   MOVEL     'RE7104B'     MsgIdXAr(Idx)                                249179
     C                   WHEN      DDACTN='C'                                                 249179
     C                   MOVEL     'USR0638'     MsgIdXAr(Idx)                                249179
     C                   WHEN      DDACTN='R'                                                 249179
     C                   MOVEL     'USR0639'     MsgIdXAr(Idx)                                249179
     C                   ENDSL                                                                249179
     C                   ENDIF                                                                249179
     C                   ENDIF                                                                249179
                                                                                              249179
     C                   ELSE                                                                 249179
     C                   CALL      'ZVACTU'                                                   249179
     C                   PARM      DDACTN        @ZACTN            1                          249179
     C                   PARM                    @ERR              1 0                        249179
      *                                                                                       249179
      ** Invalid Action Code for the user                                                     249179
      *                                                                                       249179
     C     @ERR          IFEQ      1                                                          249179
     C                   MOVE      'N'           DDBRCDOK                                     249179
     C                   ADD       1             Idx                                          249179
     C                   MOVEL     'DDBRCD'      FldNamXAr(Idx)                               249179
     C                   SELECT                                                               249179
     C                   WHEN      DDACTN='E'                                                 249179
     C                   MOVEL     'RE7105B'     MsgIdXAr(Idx)                                249179
     C                   WHEN      DDACTN='I'                                                 249179
     C                   MOVEL     'RE7102B'     MsgIdXAr(Idx)                                249179
     C                   WHEN      DDACTN='A'                                                 249179
     C                   MOVEL     'RE7103B'     MsgIdXAr(Idx)                                249179
     C                   WHEN      DDACTN='D'                                                 249179
     C                   MOVEL     'RE7104B'     MsgIdXAr(Idx)                                249179
     C                   WHEN      DDACTN='C'                                                 249179
     C                   MOVEL     'USR0638'     MsgIdXAr(Idx)                                249179
     C                   WHEN      DDACTN='R'                                                 249179
     C                   MOVEL     'USR0639'     MsgIdXAr(Idx)                                249179
     C                   ENDSL                                                                249179
     C                   ENDIF                                                                249179
                                                                                              249179
     C                   ENDIF                                                                249179
                                                                                              249179
     C                   ENDIF                                                                249179
     C                   ENDIF                                                               258838A
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
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
     C                   PARM                    RespMode          1                          249179
     C                   PARM                    DDACTN            1                          249179
      *
      ** Multi-Branching Indicator (1A)
      *  Branch Code (3A)
      *
     C                   PARM                    BGMBIN            1
     C                   PARM                    DDBRCD            3
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Branch Code - OK
     C                   PARM                    DDBRCDOK          1
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
