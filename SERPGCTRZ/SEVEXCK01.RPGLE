     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Extel fields will be updated')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEVEXCK01 - Pre-check that entry into Extel fields will      *
      *              update something on EXTEL file - if not warning  *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CAP060  *CREATE    Date 07Oct00               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP060 - Midas APIs, Security Prices Full API                *
      *                                                               *
      *****************************************************************
 
     FEXVALDL1  IF   E           K DISK    INFSR(*PSSR)
 
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
     D WIDX            S              3P 0
 
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
     C                   MOVE      *BLANK        WMSGIDXAR
     C                   MOVE      *BLANK        WFLDNMXAR
     C                   Z-ADD     0             WIDX
 
      * If we are inserting or amending the field
 
     C                   IF        DDACTN = 'I' OR
     C                             DDACTN = 'A'
 
      * If entry into the EXTEL fields is valid
 
     C                   IF        DDPPRT = 'V' AND
     C                             BVEXOP = 'Y'
 
      * If we have a value in any of the EXTEL fields
 
     C                   IF        DDAPND <> *BLANKS OR
     C                             DDLPRI <> *BLANKS OR
     C                             DDUPRI <> *BLANKS OR
     C                             DDPCEN <> *BLANKS
 
     C                   IF        WXPSSN  <> DDPSSN
 
     C     DDPSSN        CHAIN     EXVALDF
 
     C                   IF        NOT %FOUND
 
     C                   ADD       1             WIdx
     C                   EVAL      WFLDNMXAR (WIdx) = 'DDAPND'
     C                   EVAL      WMSGIDXAR(WIdx) = 'MMA1154'
     C                   EVAL      DDPCENOK  = 'W'
     C                   EVAL      DDAPNDOK  = 'W'
     C                   EVAL      DDLPRIOK  = 'W'
     C                   EVAL      DDUPRIOK  = 'W'
     C                   EVAL      WXPSSN    = DDPSSN
     C                   ELSE
     C                   EVAL      WXPSSN    = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      * RETURN
     C                   RETURN
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
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Security Shortname
     C                   PARM                    DDPSSN           10
      ** Price Type
     C                   PARM                    DDPPRT            2
      ** Auto Price Indicator
     C                   PARM                    DDAPND            1
      ** Lower Price
     C                   PARM                    DDLPRI           16
      ** Upper Price
     C                   PARM                    DDUPRI           16
      ** Percentage
     C                   PARM                    DDPCEN           10
      ** ICD
      *
     C                   PARM                    BVEXOP            1
      * OUTPUTS
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXar
     C                   PARM                    WMsgDtXAR
      *
      ** Auto price indicator OK
     C                   PARM                    DDAPNDOK          1
      ** Lower Price Indicator OK flags
     C                   PARM                    DDLPRIOK          1
      ** Upper Price Indicator OK flags
     C                   PARM                    DDUPRIOK          1
      ** Percentage OK flag
     C                   PARM                    DDPCENOK          1
      ** Work version of security shortname, to check if warning should be shown again
     C                   PARM                    WXPSSN           10
 
 
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
