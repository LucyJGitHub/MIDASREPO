     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate ISDA Def. & Designated Maturity')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Base Rate Details Validation  *
      *                                                               *
      *  SDVISDMAT - Validate ISDA Defin. and Deisignated Maturity    *
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
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CAP038  *CREATE    Date 24Feb00               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP038 - Midas APIs, Base Rates                              *
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
     D Ix              S              3P 0
 
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
     C                   Z-ADD     0             Ix
 
      *
      ** VALIDATION
      *
     C                   EXSR      ISDAMatV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDScddOK      IFEQ      'N'
     C     DDDgmaOK      OREQ      'N'
     C     DDOmd1OK      OREQ      'N'
     C     DDOmd2OK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION - ISDA Definition &  Designated Maturity
      *****************************************************************
     C     ISDAMatV      BEGSR
 
      *  Validate ISDA Definition
     C     DDSCDD        IFEQ      *BLANKS
     C                   MOVE      'N'           DDScddOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSCDD'      FldNamXAr(Ix)
     C                   MOVEL     'USR3119'     MsgIDXAr(Ix)
     C                   ENDIF
      * Validate Designated Maturity
      * Designated Maturity cannot be blank
     C     DDDgma        IFEQ      *BLANKS
     C                   MOVE      'N'           DDDgmaOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDDGMA'      FldNamXAr(Ix)
     C                   MOVEL     'USR3120'     MsgIdXAr(Ix)
     C                   ELSE
 
      * If Designated Maturity is not 'O' for other the first two
      * characters must be numeric.
     C     DDDGMA        IFNE      'O'
     C     2             SUBST     DDDGMA        WKFLD2            2
     C                   TESTN                   WKFLD2               9899
     C     *IN98         IFEQ      '0'
     C     *IN99         ANDEQ     '0'
     C                   MOVE      'N'           DDDgmaOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDDGMA'      FldNamXAr(Ix)
     C                   MOVEL     'USR3121'     MsgIdXAr(Ix)
     C                   ENDIF
      * If Designated Maturity is not 'O' for other the third
      * characters must be 'D', 'W', 'M' or 'Y'.
     C     1             SUBST     DDDGMA:3      WKFLD1            1
     C     WKFLD1        IFNE      'D'
     C     WKFLD1        ANDNE     'W'
     C     WKFLD1        ANDNE     'M'
     C     WKFLD1        ANDNE     'Y'
     C                   MOVE      'N'           DDDgmaOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDDGMA'      FldNamXAr(Ix)
     C                   MOVEL     'USR3122'     MsgIdXAr(Ix)
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      * If 'O  ' has been entered in Designated Maturity or               CSW097
      * 'OTHER' has been entered in the ISDA Definition of Base Rate,     CSW097
      * a free-format entry is mandatory in the fields Other Maturity     CSW097
      * Description.                                                      CSW097
     C     DDSCDD        IFEQ      'OTHER'
     C     DDDGMA        OREQ      'O  '
 
      * 'ISDA definition of Base Rate Required'
     C     DDOMD1        IFEQ      *BLANKS
     C     DDOMD2        ANDEQ     *BLANKS
     C                   MOVE      'N'           DDOmd1OK
     C                   ADD       1             Ix
     C                   MOVEL     'DDOMD1'      FldNamXAr(Ix)
     C                   MOVEL     'USR3160'     MsgIdXar(Ix)
     C                   ENDIF
 
      * Other Maturity description may only be enetered if ISDA definition
      * of Base Rate is 'OTHER' or Designated Maturity is 'O'.
     C     DDOMD1        IFEQ      *BLANKS
     C     DDOMD2        ANDNE     *BLANKS
     C                   MOVE      'N'           DDOmd1OK
     C                   ADD       1             Ix
     C                   MOVEL     'DDOMD1'      FldNamXAr(Ix)
     C                   MOVEL     'USR3161'     MsgIdXAr(Ix)
     C                   ENDIF
 
     C                   ELSE
 
      * Other Maturity description 2 may only be entered if other maturity
      * description 1 is entered.
     C     DDOMD1        IFNE      *BLANKS
     C     DDOMD2        ORNE      *BLANKS
     C                   MOVE      'N'           DDOmd2OK
     C                   ADD       1             Ix
     C                   MOVEL     'DDOMD1'      FldNamXAr(Ix)
     C                   MOVEL     'USR3159'     MsgIdXAr(Ix)
     C                   ENDIF
 
     C                   ENDIF
 
 
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
      ** ISDA Definition
      ** Designated Maturity
      ** Other Maturity Description
      *
     C                   PARM                    DDSCDD           24
     C                   PARM                    DDDGMA            3
     C                   PARM                    DDOMD1           35
     C                   PARM                    DDOMD2           35
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      *
      ** ISDA Definition     - OK
      ** Designated Maturity - OK
      ** Other Maturity Desc.- OK
     C                   PARM                    DDScddOK          1
     C                   PARM                    DDDgmaOK          1
     C                   PARM                    DDOmd1OK          1
     C                   PARM                    DDOmd2OK          1
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
