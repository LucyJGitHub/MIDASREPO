     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Participant Status Fields')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVPASS02- Validate Participant Status Fields                *
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
      *  Last Amend No. CRE007             Date 01Mar01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CAP034  *CREATE    Date 01Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE007 - Basic rate tax 2001 - Recompile                     *
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
 
      ** Customer Base Rate Tax in screen format
     D CuBrt         E DS                  EXTNAME(SDCUBRPD)
 
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
     C                   EXSR      NSTSV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DD1STSOK      IFEQ      'N'
     C     DD2STSOK      OREQ      'N'
     C     DD3STSOK      OREQ      'N'
     C     DD4STSOK      OREQ      'N'
     C     DD5STSOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION - PARTICIPANT STATUS FIELDS
      *****************************************************************
     C     NSTSV         BEGSR
 
      * Participant status fields must be Y, N or blank
 
     C     DD1NAM        IFNE      *BLANKS
     C     DD1STS        IFNE      'Y'
     C     DD1STS        ANDNE     'N'
     C     DD1STS        ANDNE     ' '
     C                   MOVE      'N'           DD1STSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DD1STS'      FldNamXAr(Idx)
     C                   MOVEL     'USR4173'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ELSE
     C                   MOVE      ' '           DD1STS
     C                   ENDIF
 
     C     DD2NAM        IFNE      *BLANKS
     C     DD2STS        IFNE      'Y'
     C     DD2STS        ANDNE     'N'
     C     DD2STS        ANDNE     ' '
     C                   MOVE      'N'           DD2STSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DD2STS'      FldNamXAr(Idx)
     C                   MOVEL     'USR4173'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ELSE
     C                   MOVE      ' '           DD2STS
     C                   ENDIF
 
     C     DD3NAM        IFNE      *BLANKS
     C     DD3STS        IFNE      'Y'
     C     DD3STS        ANDNE     'N'
     C     DD3STS        ANDNE     ' '
     C                   MOVE      'N'           DD3STSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DD3STS'      FldNamXAr(Idx)
     C                   MOVEL     'USR4173'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ELSE
     C                   MOVE      ' '           DD3STS
     C                   ENDIF
 
     C     DD4NAM        IFNE      *BLANKS
     C     DD4STS        IFNE      'Y'
     C     DD4STS        ANDNE     'N'
     C     DD4STS        ANDNE     ' '
     C                   MOVE      'N'           DD4STSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DD4STS'      FldNamXAr(Idx)
     C                   MOVEL     'USR4173'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ELSE
     C                   MOVE      ' '           DD4STS
     C                   ENDIF
 
     C     DD5NAM        IFNE      *BLANKS
     C     DD5STS        IFNE      'Y'
     C     DD5STS        ANDNE     'N'
     C     DD5STS        ANDNE     ' '
     C                   MOVE      'N'           DD5STSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DD5STS'      FldNamXAr(Idx)
     C                   MOVEL     'USR4173'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ELSE
     C                   MOVE      ' '           DD5STS
     C                   ENDIF
 
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
      * Base Rate Tax details
     C                   PARM                    CuBrt
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Participant 1 Status OK
      ** Participant 2 Status OK
      ** Participant 3 Status OK
      ** Participant 4 Status OK
      ** Participant 5 Status OK
     C                   PARM                    DD1STSOK          1
     C                   PARM                    DD2STSOK          1
     C                   PARM                    DD3STSOK          1
     C                   PARM                    DD4STSOK          1
     C                   PARM                    DD5STSOK          1
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
(c) Misys International Banking Systems Ltd. 2001
