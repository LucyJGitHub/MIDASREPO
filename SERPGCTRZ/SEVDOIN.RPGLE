     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate depot accrued indicator')            *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVDOIN     - Validate Depot Accrued Indicator.              *
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
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE005             Date 20Jun00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001  *CREATE    Date 24Aug99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CSE005 - Added  3 more Parameters  when calling  ZNCD  module*
      *           which were introduced in it  by this  amendment .   *
      *  CPB001 - 'Private Banking' Module                            *
      *                                                               *
      *****************************************************************
 
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
 
      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D CDArr                 183    230
     D CRArr                 231    242
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
 
     D PROT            S              1A
     D Idx             S              3P 0
 
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
 
      ** Clear output Depot fields
 
     C                   MOVEL     *BLANK        ACIN
      *
      ** DEFAULTING
      *
     C     Default       IFEQ      'Y'
     C     DDACIN        ANDEQ     *BLANK
     C                   EXSR      ACIND
     C                   END
      *
      ** VALIDATION
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      ACINV
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDAcinOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** ACINV  - ACCRUED INDICATOR VALIDATION
      *****************************************************************
     C     ACINV         BEGSR
      *
      * Accrued Ind must be C, F or X
      *
     C     DDACIN        IFNE      'C'
     C     DDACIN        ANDNE     'F'
     C     DDACIN        ANDNE     'X'
     C                   MOVE      'N'           DDAcinOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACIN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0716'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** Schuldschein
      *
     C     DDACIN        IFEQ      'X'
     C     DDACIN        OREQ      'C'
      *
     C     PROT          IFEQ      '6'
     C                   MOVE      'N'           DDAcinOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACIN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0516'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Update Depot
      *
     C                   MOVE      DDACIN        ACIN
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** ACIND - ACCRUED INDICATOR DEFAULTING
      *****************************************************************
     C     ACIND         BEGSR
      *
      *  Set up accrued indicator for schuldschein.
      *
     C     PROT          IFEQ      '6'
     C                   MOVE      'F'           DDACIN
     C                   GOTO      EACIND
     C                   END
      *
      *  Determine next coupon date
      *
     C                   EXSR      ZNCD
     C                   MOVE      'C'           DDACIN
      *
      *  If Value date is the next coupon date
      *  the Depot is 'flat' of purchased interest
      *
     C     DPVD          IFEQ      NCD
     C                   MOVE      'F'           DDACIN
     C                   ELSE
      *
      *  Else if the Depot value date is not the next coupon date
      *  Determine the ex-date of the security
      *
     C                   MOVEL     EDFT          ZNRDYS
     C     ZNRDYS        IFNE      *ZEROS
     C                   MOVE      EDFT          WEDFT             1
      *
      *    .. if working days
     C     WEDFT         IFEQ      'W'
     C                   Z-ADD     NCD           ZDAYNO
     C                   MOVE      NMCY          ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   EXSR      ZBKDT
      *
      *    .. if actual days
     C                   ELSE
     C     NCD           SUB       ZNRDYS        ZDYNBR
     C                   END
      *
      *  If the Depot value date is in the 'ex-coupon ' period
      *  the Depot is 'ex' purchased interest
      *
     C     DPVD          IFLT      NCD
     C     DPVD          ANDGE     ZDYNBR
     C                   MOVE      'X'           DDACIN
     C                   END
     C                   END
     C                   END
 
     C     EACIND        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZNCD - Calculate Next Coupon date
      *****************************************************************
     C     ZNCD          BEGSR
 
     C                   CALLB     'ZNCD'
 
      * INPUTS
 
      ** Security details
     C                   PARM                    ITLD
     C                   PARM                    FCPN
     C                   PARM                    MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
      *
      ** Event Control Date
      ** Date Format
     C                   PARM      DPVD          ECD               5 0
     C                   PARM                    BJDFIN
      *                                                                                       CSE005
      ** Nominal Currency                                                                     CSE005
      ** Security Investment Type                                                             CSE005
      ** Effect on Holidays on Coupon Dates                                                   CSE005
     C                   PARM                    NMCY              3                          CSE005
     C                   PARM                    SITP              3                          CSE005
     C                   PARM                    BCNV              1                          CSE005
      ** Last Coupon Date                                                                     CSE031
     C                   PARM                    LCPN                                         CSE031
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
 
      * OUTPUTS
 
      ** Next Coupon Date
     C                   PARM                    NCD               5 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZBKDT - Calculate a number of days back
      *****************************************************************
     C     ZBKDT         BEGSR
 
     C                   CALLB     'ZBKDT'
 
      * INPUTS
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM                    ZNRDYS            2 0
 
      * OUTPUTS
     C                   PARM                    ZDYNBR            5 0
 
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
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Depot Screen fields
     C                   PARM                    DDACIN            1
      *
      ** Depot Value Date
     C                   PARM                    DPVD              5 0
      *
      ** Security Details
      ** Processing Type
     C                   PARM                    SECTY
     C                   PARM                    PROT
      *
      ** Date format ind
     C                   PARM                    BJDFIN            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Accrued Indicator - OK
     C                   PARM                    DDAcinOK          1
      *
      ** Depot Accrued Indicator
      *
     C                   PARM                    ACIN              1
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
(c) Finastra International Limited 2001
