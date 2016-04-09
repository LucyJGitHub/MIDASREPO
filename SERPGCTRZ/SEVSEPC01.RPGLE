     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Securities Prices Percentage')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEVSEPC01 - Validate Securities Prices Percentage field      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CAP060  *CREATE    Date 07Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP060 - Midas APIs, Security Prices Full API                *
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
      *
      * Initialise output fields
     C                   MOVEL     *BLANK        JPMOV
 
      * Check that the user is allowed to enter EXTEL details
 
     C                   IF        DDPPRT <> 'V' OR
     C                             BVEXOP <> 'Y'
 
     C     DDPCEN        IFNE      *BLANKS
     C                   MOVE      'N'           DDPCENOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIdXAr(Idx) = 'MMA1147'
     C                   EVAL      FldNamXAr (Idx) = 'DDPCEN'
     C                   ELSE
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
      * User can enter EXTEL details; now do bulk of validation
     C                   IF        DDPCENOK <> 'N'
     C                   EXSR      PCENTV
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDPCENOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * PCENTV - Percentage Validation
      *****************************************************************
     C     PCENTV        BEGSR
      *
      ** Percentage allowable is mandatory and must be validated as
      **   a 9,6 numeric field.
      *
     C     DDPCEN        IFEQ      *BLANKS
     C                   MOVE      'N'           DDPCENOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIdXAr(Idx) = 'MMA0824'
     C                   EVAL      FldNamXAr (Idx) = 'DDPCEN'
     C                   ELSE
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDPCEN        ZFIELD
     C                   Z-ADD     3             ZADIG
     C                   Z-ADD     6             ZADEC
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
      ** If field in error set up error code and indicator.
      *
      * Check that PCEN is numeric
      *
     C     ZRTN          IFEQ      'N'
     C                   MOVE      'N'           DDPCENOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIdXAr(Idx) = 'MMA0824'
     C                   EVAL      FldNamXAr (Idx) = 'DDPCEN'
     C                   ELSE
      *
      ** If field is OK move to numeric output field.
      *
     C                   MOVE      ZFIELD        JPMOV             9 6
     C                   ENDIF
      *
     C                   ENDIF
 
     C     JPMOV         IFLT      0
     C                   MOVE      'N'           DDPCENOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIdXAr(Idx) = 'MMA0825'
     C                   EVAL      FldNamXAr  (Idx) = 'DDPCEN'
     C                   ENDIF
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
      ** Percentage
     C                   PARM                    DDPCEN           10
      ** Price Type
     C                   PARM                    DDPPRT            2
      *
      ** EXTEL Indicator
     C                   PARM                    BVEXOP            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXar
     C                   PARM                    MsgDtaXAr
      *
      ** Percentage
     C                   PARM                    JPMOV
      *
      ** Percentage OK flag
     C                   PARM                    DDPCENOK          1
 
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
