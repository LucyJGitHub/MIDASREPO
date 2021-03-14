     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Trade Reallowance')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTREALLW - Validate Trade reallowance                      *
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
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL031             Date 05Jul04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08MAR99               *
      *                 156689             Date 18Mar99               *
      *                 CAP003  *CREATE    Date 23Jan98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  156689 - ZASIGN To Recognize '.' or ',' as decimal separator *
      *  CAP003 - Conversion of MM inputs into modular structure to   *
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
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
 
      ** Clear output trade fields
 
     C                   Z-ADD     *ZERO         RALL
      *
      ** DEFAULTING
      *
     C     Default       IFEQ      'Y'
     C     DDRALL        ANDEQ     *BLANKS                                                     E2111
     C                   EXSR      RALLD
     C                   ENDIF
      *
      ** DO VALIDATION
      ** If Reallowance is entered
      *
     C     Validate      IFEQ      'Y'
     C     DDRALL        ANDNE     *BLANKS                                                     E2111
     C                   EXSR      RALLV
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDRALLOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     RALLV         BEGSR
 
      *    The security trade basis can't be 'Y' (for yield)
 
     C     STBS          IFEQ      'Y'                                                         E2111
     C                   MOVE      'N'           ddRALLok
     C                   ADD       1             Idx
     C                   MOVEL     'DDRALL'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0504'     MsgIdXAr(Idx)
     C                   ELSE                                                                  E2111
 
      *   It must be a valid amount
 
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDRALL        ZFLD17
 
     C                   CALLB     'ZASIGN'
     C                   PARM                    ZASIGNok          1
     C                   PARM                    ZFLD17           17
     C                   PARM      4             ZSDIG             2 0
     C                   PARM      5             ZSDEC             1 0
     C                   PARM                    ZSDCSP            1            156689
     C                   PARM      *BLANK        ZOUT15           15
     C                   PARM      *BLANK        ZFSIGN            1
 
     C     ZASIGNok      IFEQ      'N'
     C                   MOVE      'N'           ddRALLok
     C                   ADD       1             Idx
     C                   MOVEL     'DDRALL'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0503'     MsgIdXAr(Idx)
     C                   ELSE
      *
      * Update trade
      *
     C                   MOVE      ZOUT15        RALL                                          S0117
     C     ZFSIGN        IFEQ      '-'                                                         S0117
     C                   Z-SUB     RALL          RALL                                          S0117
     C                   END                                                                   S0117
     C                   END
 
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** DEFAULTING
      *****************************************************************
     C     RALLD         BEGSR
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
      ** Trade Screen fields
     C                   PARM                    DDRALL           11
      *
      ** Security Details
      *
     C                   PARM                    SECTY
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Reallowance - OK
     C                   PARM                    DDRALLOK          1
      *
      ** Trade Reallowance
      *
     C                   PARM                    RALL              9 5
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
