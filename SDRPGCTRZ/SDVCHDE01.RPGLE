     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate CHIPS ABA')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVCHDE01- Validate CHIPS ABA                                *
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
      * Midas DBA 3.02 -----------------------------------------------*
      *  Last Amend No. CAP034  *CREATE    Date 01Apr99               *
      *  Prev Amend No.                    Date ddmmmyy               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *  CAP034 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
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
      ** VALIDATION
      *
     C                   EXSR      ABASV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDABASOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION - CHIPS ABA
      *****************************************************************
     C     ABASV         BEGSR
      *
      * If CHIPS ABA is not blank, validate that it is numeric
      *
     C     DDABAS        IFEQ      *BLANK
     C                   Z-ADD     0             CUCABA
     C                   Z-ADD     0             CUABA2
     C                   ELSE
     C                   MOVE      *BLANK        WKABAS
     C                   MOVE      DDABAS        WKABAS
     C                   CALL      'ZALIGN'
      *
      ** Return Code (7A)
      ** CHIPS Message Field (16A)
      ** Number of Decimals (1,0)
      ** Number of Digits (2,0)
      ** CHIPS File Field (16A)
     C                   PARM                    @RTCD             7
     C                   PARM                    WKABAS           16
     C                   PARM      *ZERO         DECIMALS          1 0
     C                   PARM      4             DIGITS            2 0
     C                   PARM      *BLANK        WKCABA           16
 
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      'Y'           WKERR             1
     C                   ELSE
     C                   MOVE      'N'           WKERR
 
     C                   CALL      'ZEDIT'
      ** CHIPS Message Field (16A)
      ** Number of Decimals (1,0)
     C                   PARM                    WKCABA
     C                   PARM      *ZERO         DECIMALS
 
     C                   END
      * If not numeric
     C     WKERR         IFEQ      'Y'
     C                   MOVE      'N'           DDABASOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDABAS'      FldNamXAr(Idx)
     C                   MOVEL     'USR1990'     MsgIdXAr(Idx)
     C                   END
 
     C                   MOVE      WKCABA        WKCABAN           4 0
 
      * If CHIPS 2 ABA switchable feature is on
     C     S01429        IFEQ      'Y'
 
      * value must be 1 - 9999
     C     WKCABAN       IFLT      1
     C     WKCABAN       ORGT      9999
     C                   MOVE      'N'           DDABASOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDABAS'      FldNamXAr(Idx)
     C                   MOVEL     'USR1971'     MsgIdXAr(Idx)
     C                   ELSE
     C                   Z-ADD     WKCABAN       CUABA2
     C                   Z-ADD     0             CUCABA
     C                   MOVE      WKCABA        DDABAS
     C                   END
 
     C                   ELSE
 
      * otherwise value must be 1 - 999
     C     WKCABAN       IFLT      1
     C     WKCABAN       ORGT      999
     C                   MOVE      'N'           DDABASOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDABAS'      FldNamXAr(Idx)
     C                   MOVEL     'USR1959'     MsgIdXAr(Idx)
     C                   ELSE
     C                   Z-ADD     WKCABAN       CUCABA
     C                   Z-ADD     0             CUABA2
     C                   MOVE      WKCABA        DDABAS
     C                   END
 
     C                   END
 
     C                   END
      *
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
      ** CHIPS ABA (4A)
      ** CHIPS 2 indicator (1A)
     C                   PARM                    DDABAS            4
     C                   PARM                    S01429            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** CHIPS ABA - OK
     C                   PARM                    DDABASOK          1
      *
      ** CHIPS ABA numeric (3,0)
      ** CHIPS ABA 2 numeric (4,0)
     C                   PARM                    CUCABA            3 0
     C                   PARM                    CUABA2            4 0
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
