     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Trade Actual/Difference Ind')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTACDFIN  - Validate Trade Actual/Difference Ind.          *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CPL002             Date 08MAR99               *
      *  Prev Amend No. CAP003  *CREATE    Date 16Jan98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
     C                   MOVEL     *BLANK        ADIN
      *
      ** DEFAULT
      *
     C     Default       IFEQ      'Y'
     C     DDACTD        ANDEQ     *BLANK
     C                   EXSR      ACTDD
     C                   END
      *
      ** VALIDATION
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      ACTDV
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDActdOK      IFEQ      'N'
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
     C     ACTDV         BEGSR
      *
      *    .. if days adjustment ne 0, must be 'A' or 'D'
      *
     C     DADJ          IFNE      *ZEROS
      *
     C     DDACTD        IFNE      'A'
     C     DDACTD        ANDNE     'D'
     C                   MOVE      'N'           DDActdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACTD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0518'     MsgIdXAr(Idx)
     C                   ENDIF
     C*
     C                   ELSE
      *
      *    .. But, if DADJ IS zero, A/D Ind must be blank.
      *
     C     DDACTD        IFNE      *BLANKS
     C                   MOVE      'N'           DDActdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACTD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0518'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
      *
      * Update trade
      *
     C                   MOVE      DDACTD        ADIN
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** DEFAULT
      *****************************************************************
     C     ACTDD         BEGSR
      *
      *  Actual Difference indicator
     C     IADJ          IFNE      *ZEROS
     C                   MOVE      'D'           DDACTD
     C                   END
 
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
     C                   PARM                    DDACTD            1
      *
      ** Trade Days Adjustment
     C                   PARM                    DADJ              3 0
      *
      ** Security Days Adjustment (from SECTYD)
     C                   PARM                    IADJ              3 0
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Act/Diff Indicator - OK
     C                   PARM                    DDActdOK          1
      *
      ** Trade Act/Diff Indicator
      *
     C                   PARM                    ADIN              1
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
