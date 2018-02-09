     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Document Required by Date')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVREQB - Validate Required by Date                          *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD093  *CREATE    Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD093 - Document Management                                 *
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WDAYS           S              3A
     D WReqDays        S              3S 0
 
     ** Parameters for AOSVALR0
     D POP01           S             20A
     D POP02           S             20A
     D POP03           S             20A
     D POP04           S             20A
     D POP05           S             20A
     D POP06           S             20A
     D POP07           S             20A
     D POP08           S             20A
     D POP09           S             20A
     D POP10           S             20A
     D PVL01           S            200A
     D PVL02           S            200A
     D PVL03           S            200A
     D PVL04           S            200A
     D PVL05           S            200A
     D PVL06           S            200A
     D PVL07           S            200A
     D PVL08           S            200A
     D PVL09           S            200A
     D PVL10           S            200A
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
 
     C                   EVAL      RetCodeIn = *BLANK
 
     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
     C                   Z-ADD     0             Idx
 
      ** Validation
 
     C     DDREQB        IFEQ      *BLANKS
     C                   EXSR      SRDEFLT
     C                   ENDIF
 
     C     DDREQB        IFNE      *BLANKS
 
      ** The Required by Date must be a valid date
 
     C                   TESTN                   DDREQB               98
     C                   IF        *IN98 = *OFF
     C                   EVAL      DDREQBOK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDREQB    '
     C                   EVAL      MsgIdXAr(Idx) = 'USS0419'
     C                   ELSE
 
      ** The Required by Date must be a valid date
 
     C                   EVAL      ZDATEA = DDREQB
     C                   EXSR      SRDATE1
 
     C                   IF        ErrorFlag  = 'Y'
     C                   EVAL      DDREQBOK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDREQB    '
     C                   EVAL      MsgIdXAr(Idx) = 'USS0419'
     C                   ELSE
     C                   Z-ADD     ZDAYNO        DVREQB
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** If an error was found, set the return code appropriately
 
     C     DDREQBOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
      ** RETURN
 
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      *  SRDEFLT - Default Field in Input Screen                      *
      *                                                               *
      *****************************************************************
     C     SRDEFLT       BEGSR
      *
     C                   EVAL      POP01 = 'DocNoDaysDftReqDate'
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd             7
     C                   PARM                    POP01            20
     C                   PARM                    PVL01           200
     C                   PARM                    POP02            20
     C                   PARM                    PVL02           200
     C                   PARM                    POP03            20
     C                   PARM                    PVL03           200
     C                   PARM                    POP04            20
     C                   PARM                    PVL04           200
     C                   PARM                    POP05            20
     C                   PARM                    PVL05           200
     C                   PARM                    POP06            20
     C                   PARM                    PVL06           200
     C                   PARM                    POP07            20
     C                   PARM                    PVL07           200
     C                   PARM                    POP08            20
     C                   PARM                    PVL08           200
     C                   PARM                    POP09            20
     C                   PARM                    PVL09           200
     C                   PARM                    POP10            20
     C                   PARM                    PVL10           200
 
     C                   IF        PRtcd <> *Blanks  AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = 'POP01'
     C                   EVAL      DBASE = 903
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVALR     WDAYS = %TRIM(PVL01)
     C                   MOVE      WDAYS         WReqDays
     C                   EVAL      ZDAYNO = WReqDays + DRUND
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         DDREQB
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDATE1- Validate & convert date to a day number             *
      *                                                               *
      *****************************************************************
     C     SRDATE1       BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    DFIN
     C                   PARM                    ErrorFlag         1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDATE2 - Convert Midas day number to DDMMYY                 *
      *                                                               *
      *****************************************************************
     C     SRDATE2       BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    DFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
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
      ** Other parms
      *
      ** Private Banking Start Date - alpha
     C                   PARM                    DDREQB            6
      *
      ** MIDAS date format
     C                   PARM                    DRUND             5 0
     C                   PARM                    DFIN              1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Valid Required by Date - OK
     C                   PARM                    DDREQBOK          1
     C                   PARM                    DVREQB            5 0
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
(c) Finastra International Limited 2013
