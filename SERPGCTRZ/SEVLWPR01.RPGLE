     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Lower/Upper Price Boundary')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEVLWPR01 - Validate Lower Price/Upper Price Boundary        *
      *              Individual and cross-validation                  *
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
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
      ** Index for arrays of warning message ids etc
     D WIDX            S              3P 0
 
      ** Lower Price, Upper Price and Price in file format
     D JUPBD           S             15  8
     D JLPBD           S             15  8
     D JPPRC           S             15  8
     D WUPBD           S                   LIKE(JUPBD)
     D WLPBD           S                   LIKE(JLPBD)
     D WPPRC           S                   LIKE(JPPRC)
 
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
      *
      * Initialise output fields
     C                   MOVEL     *BLANK        PBWN
 
      * Check that the user is allowed to enter EXTEL details
 
     C                   IF        DDPPRT <> 'V' OR
     C                             EXTEL  <> 'Y'
 
     C     DDLPRI        IFNE      *BLANKS
     C     DDUPRI        ORNE      *BLANKS
     C                   MOVE      'N'           DDLPRIOK
     C                   MOVE      'N'           DDUPRIOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIdXAr(Idx) = 'MMA1148'
     C                   EVAL      FldNamXAr (Idx) = 'DDLPRI'
     C                   ELSE
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      * User can enter EXTEL details; now do bulk of validation
 
     C                   IF        DDLPRIOK <> 'N'
     C                   EXSR      LWPRV
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDLPRIOK      IFEQ      'N'
     C     DDUPRIOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * LWPRV - Lower Price/Upper Price Boundary Validation
      *****************************************************************
     C     LWPRV         BEGSR
      *
      ** Lower price boundary is mandatory and must be validated as
      **   a 13,8 numeric field.
      *
     C     DDLPRI        IFEQ      *BLANKS
      *
      * Error 204 ; error if blanks
     C                   MOVE      'N'           DDLPRIOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0820'
     C                   EVAL      FldNamXAr (Idx) = 'DDLPRI'
      *
     C                   ELSE
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDLPRI        ZFIELD
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
      ** If field in error set up error code and indicator.
      *
     C     ZRTN          IFEQ      'N'
     C                   MOVE      'N'           DDLPRIOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXar(Idx) = 'MMA0820'
     C                   EVAL      FldNamXAr (Idx) = 'DDLPRI'
     C                   ELSE
      *
      ** If field is OK move to numeric output field.
      *
     C                   MOVE      ZFIELD        JLPBD
 
      *
      ** If field is OK move to numeric output field.
      *
     C     JLPBD         IFLT      0
     C                   MOVE      'N'           DDLPRIOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIdXar(Idx) = 'MMA0821'
     C                   EVAL      FldNamXAr (Idx) = 'DDLPRI'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Upper price boundary is mandatory and must be validated as
      **   a 13,8 numeric field.
      *
     C     DDUPRI        IFEQ      *BLANKS
     C                   MOVE      'N'           DDUPRIOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXar(Idx) = 'MMA0822'
     C                   EVAL      FldNamXAr (Idx) = 'DDUPRI'
     C                   ELSE
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDUPRI        ZFIELD
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
      * Check that UPRI is numeric
      *
     C     ZRTN          IFEQ      'N'
     C                   MOVE      'N'           DDUPRIOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXar(Idx) = 'MMA0822'
     C                   EVAL      FldNamXAr (Idx) = 'DDUPRI'
     C                   ELSE
      *
      ** If field is OK move to numeric output field and check that
      **   it is greater or equal to the lower price boundary.
      *
     C                   MOVE      ZFIELD        JUPBD
      *
     C     DDLPRIOK      IFNE      'N'
     C     JUPBD         ANDLT     JLPBD
     C                   MOVE      'N'           DDUPRIOK
     C                   MOVE      'N'           DDLPRIOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXar(Idx) = 'MMA0822'
     C                   EVAL      FldNamXAr (Idx) = 'DDUPRI'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EXTEL         IFEQ      'Y'
     C*
      ** If price type is 'V ' (current price) and the upper and
      **   lower boundaries are not zero, the price must be
      **   within these boundaries.
      *
     C*    ** WARNING ONLY - ACCEPT IF UNCHANGED **
     C     DDPPRT        IFEQ      'V '
     C     JLPBD         ANDNE     0
     C     DDPPRT        OREQ      'V '
     C     JUPBD         ANDNE     0
      *
     C     JPPRC         IFGT      JUPBD
     C     JPPRC         ORLT      JLPBD
      *
      * If any of the fields have changed from last time, don't display the warning again
      *
     C                   IF        WLPBD <> JLPBD OR
     C                             WUPBD <> JUPBD OR
     C                             WPPRC <> JPPRC
 
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIdXar(WIdx) = 'MMA0815'
     C                   EVAL      WFLDNMXAR (WIdx) = 'JPPRC'
     C                   EVAL      DDPRCOK = 'W'
 
     C                   EVAL      WLPBD = JLPBD
     C                   EVAL      WUPBD = JUPBD
     C                   EVAL      WPPRC = JPPRC
 
     C                   ENDIF
 
     C                   MOVE      'Y'           PBWN              1
     C                   ELSE
     C                   MOVE      'N'           PBWN
     C                   EVAL      DDPRCOK = 'Y'
     C                   ENDIF
     C                   ENDIF
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
      ** Lower Price
     C                   PARM                    DDLPRI           16
      ** Upper Price
     C                   PARM                    DDUPRI           16
      ** Price Type
     C                   PARM                    DDPPRT            2
      *  Price in file format
     C                   PARM                    JPPRC
      ** EXTEL indicator
     C                   PARM                    EXTEL             1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXar
     C                   PARM                    WMsgDtXAR
      *
      ** Lower and Upper Price Boundary
     C                   PARM                    JLPBD
     C                   PARM                    JUPBD
      *  EXTEL Price boundaries warning indicator
     C                   PARM                    PBWN              1
      *
      ** Lower and Upper Price Indicator OK flags
     C                   PARM                    DDLPRIOK          1
     C                   PARM                    DDUPRIOK          1
     C                   PARM                    DDPRCOK           1
      ** Work fields used only to condition the display of warnings
     C                   PARM                    WLPBD
     C                   PARM                    WUPBD
     C                   PARM                    WPPRC
 
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
