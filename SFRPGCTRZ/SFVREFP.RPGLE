     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Refresh Period')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Function Module - User Maintenamce  *
      *          and Menu Items Validation                            *
      *                                                               *
      *  SFVREFP  - Validate Refresh Period                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, User Maintenance + Menu Items amendments must not be*
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026  *CREATE    Date 19May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
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
 
      ** Data structure to enable right-justification of field
     D @VAL            DS
     D @POS1                   1      1
     D @POS2                   2      2
     D @POS3                   3      3
     D @POS4                   4      4
     D @FST2                   1      2
     D @FST3                   1      3
     D @LST3                   2      4
     D @LST2                   3      4
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
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
     C                   Z-ADD     0             WIdx
 
      *
      ** VALIDATION
 
      *
      ** Validate the Auto Refresh Period
      *
      ** Right-justify input value first
      *
     C     DDREFP        IFEQ      *BLANKS
     C                   MOVE      '0000'        DDREFP
     C                   ENDIF
      *
     C                   MOVE      DDREFP        @VAL
      *
     C     @FST3         IFEQ      *BLANKS
     C                   MOVEL     '000'         DDREFP
     C                   ENDIF
      *
     C     @FST2         IFEQ      *BLANKS
     C                   MOVEL     '00'          DDREFP
     C                   ENDIF
      *
     C     @POS1         IFEQ      *BLANK
     C                   MOVEL     '0'           DDREFP
     C                   ENDIF
      *
     C                   MOVE      DDREFP        @VAL
      *
     C     @LST3         IFEQ      *BLANK
     C                   MOVE      *ZEROS        DDREFP
     C                   MOVE      @POS1         DDREFP
     C                   ELSE
     C     @LST2         IFEQ      *BLANK
     C                   MOVE      *ZEROS        DDREFP
     C                   MOVE      @FST2         DDREFP
     C                   ELSE
     C     @POS4         IFEQ      *BLANK
     C                   MOVE      *ZEROS        DDREFP
     C                   MOVE      @FST3         DDREFP
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDAURF        IFEQ      'N'
     C     DDREFP        ANDNE     *ZEROS
     C                   Eval      DDREFPOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDREFP'
     C                   Eval      MsgIdXAr(Idx) = 'SFM0468'
      *
     C                   ELSE
     C     DDAURF        IFEQ      'Y'
      *
      ** Need to check that value input is numeric
      *
     C                   MOVEL     DDREFP        @REFP             5 0
     C                   MOVEL     @REFP         @TSTV             4
      *
     C     DDREFP        IFEQ      @TSTV
      ** Ensure that value input is sensible, ie. at least 30 secs.
      *
     C     DDREFP        IFLT      '0030'
     C                   Eval      DDREFPOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDREFP'
     C                   Eval      MsgIdXAr(Idx) = 'SFM0469'
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   Eval      DDREFPOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDREFP'
     C                   Eval      MsgIdXAr(Idx) = 'SFM0470'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
 
 
 
      *
      * RETURN
      *
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
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
      ** Field(s) requiring validation
     C                   PARM                    DDREFP            4
     C                   PARM                    DDAURF            1
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Refresh Period - OK
     C                   PARM                    DDREFPOK          1
      *
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
(c) Misys International Banking Systems Ltd. 2006
