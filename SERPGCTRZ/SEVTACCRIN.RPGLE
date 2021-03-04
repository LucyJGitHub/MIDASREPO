     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate trade accrued indicator')            *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTACCRIN  - Validate Trade Accrued Indicator.              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11193           Date 02May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG11164           Date 06Apr06               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      *                 211407             Date 06Nov02               *
      *                 202967             Date 10Apr02               *
      *                 CSE035             Date 22Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE005             Date 20Jun00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP003  *CREATE    Date 14Jan98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  211407 - NX/NNX wrong accrued indicator.                     *
      *  202967 - Effect of holidays on FRN coupon dates.             *
      *  CSE035 - NX/NNX Coupon Payment Processing.                   *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CSE005 - Added  3 more Parameters  when calling  ZNCD  module*
      *           which were introduced in it  by this  amendment .   *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
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
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D CDArr                 183    230
     D CRArr                 231    242
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                              CSE035
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSE035
     D SAR_LCD       E                     EXTFLD(LCD)                                        CSE035
                                                                                              CSE035
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSE035
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                   CSE035
 
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
 
      ** Clear output trade fields
 
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
      *                                                                                       CSE035
     C     CSE035        IFEQ      'Y'                                                        CSE035
      *                                                                                       CSE035
     C     DDACIN        IFNE      'C'                                                        CSE035
     C     DDACIN        ANDNE     'F'                                                        CSE035
     C     DDACIN        ANDNE     'X'                                                        CSE035
     C     DDACIN        ANDNE     'N'                                                        CSE035
     C     DDACIN        ANDNE     'D'                                                        CSE035
     C                   MOVE      'N'           DDAcinOK                                     CSE035
     C                   ADD       1             Idx                                          CSE035
     C                   MOVEL     'DDACIN'      FldNamXAr(Idx)                               CSE035
     C                   MOVEL     'MMA0515'     MsgIdXAr(Idx)                                CSE035
      *                                                                                       CSE035
     C                   ENDIF                                                                CSE035
      *                                                                                       CSE035
     C                   ELSE                                                                 CSE035
     C*
     C* Accrued Ind must be C, F or X
     C*
     C     DDACIN        IFNE      'C'
     C     DDACIN        ANDNE     'F'
     C     DDACIN        ANDNE     'X'
     C                   MOVE      'N'           DDAcinOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACIN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0515'     MsgIdXAr(Idx)
     C                   ENDIF
      *                                                                                       CSE035
     C                   ENDIF                                                                CSE035
     C*
     C** Schuldschein
     C*
     C     DDACIN        IFEQ      'X'
     C     DDACIN        OREQ      'C'
      *                                                                                       CSE035
     C     CSE035        OREQ      'Y'                                                        CSE035
     C     DDACIN        ANDEQ     'N'                                                        CSE035
     C     CSE035        OREQ      'Y'                                                        CSE035
     C     DDACIN        ANDEQ     'D'                                                        CSE035
     C*
     C     PROT          IFEQ      '6'
     C                   MOVE      'N'           DDAcinOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACIN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0516'     MsgIdXAr(Idx)
     C                   ENDIF
     C*
     C                   ENDIF
      *
      * Update trade
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
      *                                                                                       CSE035
     C     CSE035        IFEQ      'Y'                                                        CSE035
     C                   Z-ADD     ECD           SECD              5 0                        CSE035
     C                   Z-ADD     TDVD          ECD                                          CSE035
     C*                                                                                       CSE035
     C* CALL ZLCD + ZNCD TO DETERMINE NEXT AND LAST COUPON DATES                              CSE035
     C                   Z-ADD     NCD           @NCD              5 0                        CSE035
     C                   EXSR      ZNCD                                                       CSE035
     C                   Z-ADD     NCD           NCDD5             5 0                        CSE035
     C                   Z-ADD     @NCD          NCD                                          CSE035
     C                   Z-ADD     ZZLCD         @LCD              5 0                        CSE035
     C     NCDD5         SUB       1             ZECD                                         CSE035
     C                   EXSR      ZLCD                                                       CSE035
     C                   Z-ADD     ZZLCD         LCDD5             5 0                        CSE035
     C                   Z-ADD     @LCD          ZZLCD                                        CSE035
      *                                                                                       CSE035
      ** If TDVD is less than the FCPN, get the Last Coupon from the                          CSE035
      ** coupon array by calling ZLCD1.                                                       CSE035
      *                                                                                       CSE035
     C     TDVD          IFLT      FCPN                                                       CSE035
     C                   CALLB     'ZLCD1'                                                    CSE035
                                                                                              CSE035
      * INPUTS                                                                                CSE035
                                                                                              CSE035
      ** Security details                                                                     CSE035
     C                   PARM                    ISSD                                         CSE035
     C                   PARM                    ITLD                                         CSE035
     C                   PARM                    FCPN                                         CSE035
     C                   PARM                    MATY                                         CSE035
     C                   PARM                    CDArr                                        CSE035
     C                   PARM                    CRArr                                        CSE035
      *                                                                                       CSE035
      ** Event Control Date                                                                   CSE035
      ** Date Format                                                                          CSE035
     C                   PARM                    ZECD              5 0                        CSE035
     C                   PARM                    BJDFIN                                       CSE035
      *                                                                                       211407
     C                   PARM                    NMCY              3                          211407
     C                   PARM                    SITP              3                          211407
     C                   PARM                    BCNV              1                          211407
      ** Effect of Holidays on Dates                                                          CSE071
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
                                                                                              CSE035
      * OUTPUTS                                                                               CSE035
                                                                                              CSE035
      ** Last Coupon Date                                                                     CSE035
     C                   PARM                    ZZLCD1            5 0                        CSE035
     C                   END                                                                  CSE035
     C*                                                                                       CSE035
     C                   Z-ADD     SECD          ECD                                          CSE035
     C     TDVD          IFLT      FCPN                                                       CSE035
     C     PROT          ANDEQ     '1'                                                        CSE035
     C     SYBS          ANDEQ     'AU'                                                       211407
      *                                                                                       CSE035
      ** Compare the Last Coupon Date got from the array with the ITLD                        CSE035
      ** to classify it correctly.                                                            CSE035
      *                                                                                       CSE035
     C     ITLD          IFGE      ZZLCD1                                                     CSE035
     C     NCDD5         IFNE      FCPN                                                       CSE035
     C                   MOVE      'D'           DDACIN                                       CSE035
     C                   ELSE                                                                 CSE035
      *                                                                                       CSE035
      ** If Initial date coincides with the regular coupon date, it                           CSE035
      ** should be CUM.                                                                       CSE035
      *                                                                                       CSE035
     C     ITLD          IFEQ      ZZLCD1                                                     CSE035
     C     NCDD5         ANDEQ     FCPN                                                       CSE035
     C                   MOVE      'C'           DDACIN                                       CSE035
     C                   ELSE                                                                 CSE035
      *                                                                                       CSE035
      ** If not, it should be 'NX'.                                                           CSE035
      *                                                                                       CSE035
     C                   MOVE      'N'           DDACIN                                       CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
     C                   END                                                                  CSE035
     C                   ELSE                                                                 CSE035
     C                   MOVE      'D'           DDACIN                                       CSE035
     C                   END                                                                  CSE035
     C                   ELSE                                                                 CSE035
     C*                                                                                       CSE035
     C*    .. get next coupon date                                                            CSE035
     C                   EXSR      ZNCD                                                       CSE035
     C                   MOVE      'C'           DDACIN                                       CSE035
     C     TDVD          IFEQ      NCD                                                        CSE035
     C                   MOVE      'F'           DDACIN                                       CSE035
     C                   ELSE                                                                 CSE035
     C                   MOVEL     EDFT          ZNRDYS                                       CSE035
     C     ZNRDYS        IFNE      *ZEROS                                                     CSE035
     C                   MOVE      EDFT          WEDFT             1                          CSE035
     C     WEDFT         IFEQ      'W'                                                        CSE035
     C*    .. if working days                                                                 CSE035
     C                   Z-ADD     NCD           ZDAYNO                                       CSE035
     C                   MOVE      NMCY          ZCCY                                         CSE035
     C                   MOVE      *BLANKS       ZLOC                                         CSE035
     C                   EXSR      ZBKDT                                                      CSE035
     C                   ELSE                                                                 CSE035
     C*    .. if actual days                                                                  CSE035
     C     NCD           SUB       ZNRDYS        ZDYNBR                                       CSE035
     C                   END                                                                  CSE035
     C     TDVD          IFLT      NCD                                                        CSE035
     C     TDVD          ANDGE     ZDYNBR                                                     CSE035
     C     NCD           ANDNE     MATY                                                       CSE035
     C                   MOVE      'X'           DDACIN                                       CSE035
     C                   END                                                                  CSE035
     C                   END                                                                  CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
     C                   ELSE                                                                 CSE035
      *
      *  Determine next coupon date
      *
     C                   EXSR      ZNCD
     C                   MOVE      'C'           DDACIN
      *
      *  If trade value date is the next coupon date
      *  the trade is 'flat' of purchased interest
      *
     C     TDVD          IFEQ      NCD
     C                   MOVE      'F'           DDACIN
     C                   ELSE
      *
      *  Else if the trade value date is not the next coupon date
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
      *  If the trade value date is in the 'ex-coupon ' period
      *  the trade is 'ex' purchased interest
      *
     C     TDVD          IFLT      NCD
     C     TDVD          ANDGE     ZDYNBR
     C                   MOVE      'X'           DDACIN
     C                   END
     C                   END
     C                   END
      *                                                                                       CSE035
     C                   ENDIF                                                                CSE035
 
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
     C                   PARM      TDVD          ECD               5 0
     C                   PARM                    BJDFIN
                                                                                              CSE005
      ** Nominal Currency                                                                     CSE005
      ** Security Investment Type                                                             CSE005
      ** Effect on Holidays on Coupon Dates                                                   CSE005
     C                   PARM                    NMCY              3                          CSE005
     C                   PARM                    SITP              3                          CSE005
     C                   PARM                    BCNV              1                          CSE005
      ** Last Coupon Date                                                                     CSE031
     C                   PARM                    LCPN              5 0                        CSE031
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
      /EJECT                                                                                  CSE035
      *****************************************************************                       CSE035
      * ZLCD - Calculate Last Coupon date                                                     CSE035
      *****************************************************************                       CSE035
     C     ZLCD          BEGSR                                                                CSE035
                                                                                              CSE035
     C                   CALLB     'ZLCD'                                                     CSE035
                                                                                              CSE035
      * INPUTS                                                                                CSE035
                                                                                              CSE035
      ** Security details                                                                     CSE035
     C                   PARM                    ISSD                                         CSE035
     C                   PARM                    ITLD                                         CSE035
     C                   PARM                    FCPN                                         CSE035
     C                   PARM                    MATY                                         CSE035
     C                   PARM                    CDArr                                        CSE035
     C                   PARM                    CRArr                                        CSE035
     C                   PARM                    LCPN                                       BUG11164
      *                                                                                       CSE035
      ** Event Control Date                                                                   CSE035
      ** Date Format                                                                          CSE035
     C                   PARM                    ZECD              5 0                        CSE035
     C                   PARM                    BJDFIN                                       CSE035
      *                                                                                       202967
      ** Nominal Currency                                                                     202967
      ** Security Investment Type                                                             202967
      ** Effect on Holidays on Coupon Dates                                                   202967
     C                   PARM                    NMCY              3                          202967
     C                   PARM                    SITP              3                          202967
     C                   PARM                    BCNV              1                          202967
      ** Effect of Holidays on Dates                                                          CSE071
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
                                                                                              CSE035
      * OUTPUTS                                                                               CSE035
                                                                                              CSE035
      ** Next Coupon Date                                                                     CSE035
     C                   PARM                    ZZLCD             5 0                        CSE035
                                                                                              CSE035
     C                   ENDSR                                                                CSE035
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
      ** Trade Screen fields
     C                   PARM                    DDACIN            1
      *
      ** Trade Value Date
     C                   PARM                    TDVD              5 0
      *
      ** Security Details
      ** Processing Type
     C                   PARM                    SECTY
     C                   PARM                    PROT              1
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
      ** Trade Accrued Indicator
      *
     C                   PARM                    ACIN              1
      *
     C                   CALLB     'AOSARDR0'                                                 CSE035
     C                   PARM      *BLANKS       @RTCD             7                          CSE035
     C                   PARM      '*VERIFY'     @OPTN             7                          CSE035
     C                   PARM      'CSE035'      @SARD             6                          CSE035
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE035
      *                                                                                       CSE035
     C     @RTCD         IFEQ      *BLANK                                                     CSE035
     C                   MOVEL     'Y'           CSE035            1                          CSE035
     C                   ELSE                                                                 CSE035
     C                   MOVEL     'N'           CSE035                                       CSE035
     C                   END                                                                  CSE035
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
