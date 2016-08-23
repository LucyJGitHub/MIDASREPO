     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Trade Days adjustment')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTDAYSAD  - Validate Trade Days adjustment.                *
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
      *  Prev Amend No. 156689             Date 18Mar99               *
      *                 CAP003  *CREATE    Date 15Jan98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  156689 - ZASIGN To Recognize '.' or ',' as decimal separator *
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
 
     C                   Z-ADD     0             DADJ
      *
      ** DEFAULT
      *
     C     Default       IFEQ      'Y'
     C     DDDADJ        ANDEQ     *BLANK
     C     IADJ          ANDNE     *ZEROS
     C                   EXSR      DADJD
     C                   END
      *
      ** VALIDATION
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      DADJV
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDADJOK      IFEQ      'N'
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
     C     DADJV         BEGSR
      *
      * If defined, it must be a valid number
      *
     C     DDDADJ        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDDADJ        ZFLD17
 
     C                   CALLB     'ZASIGN'
     C                   PARM                    ZASIGNok          1
     C                   PARM                    ZFLD17           17
     C                   PARM      3             ZSDIG             2 0
     C                   PARM      0             ZSDEC             1 0
     C                   PARM                    ZSDCSP            1            156689
     C                   PARM      *BLANK        ZOUT15           15
     C                   PARM      *BLANK        ZFSIGN            1
      *
     C     ZASIGNok      IFEQ      'N'
     C                   MOVE      'N'           DDDadjOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDADJ'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0517'     MsgIdXAr(Idx)
     C                   ELSE
      *
      * Update trade
      *
     C                   MOVE      ZOUT15        DADJ
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     DADJ          DADJ
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ELSE
      *
      * If not defined, it is zero
      *
     C                   Z-ADD     *ZEROS        DADJ
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** DEFAULT
      *****************************************************************
     C     DADJD         BEGSR
      *
      *  Default days adjustment to that on the security
      *
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      IADJ          ZFLD15
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
 
     C                   MOVE      ZOUT21        DDDADJ
 
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
     C                   PARM                    DDDADJ            5
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
      ** Days Adjustment - OK
     C                   PARM                    DDDADJOK          1
      *
      ** Trade Days Adjustment
      *
     C                   PARM                    DADJ              3 0
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
