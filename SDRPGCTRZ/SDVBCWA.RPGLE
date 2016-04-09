     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Backup WHT Applicable')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Withholding Tax      *
      *                                  Details Validation           *
      *                                                               *
      *  SDVBCWA - Validate Backup WHT Applicable                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *    /COPY, Customer Withholding Tax API amendments             *
      *    must not be applied to this source.                        *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
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
     D WIdx            S              3P 0
     D Counter         S              3P 0
 
      ** Parameters
     D DDBCWA          S              1A
     D DDDCRC          S              1A
     D DDINTS          S              3A
     D DDBCWAOK        S              1A
 
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
 
      ** VALIDATION
 
      ** Validate Backup Withholding Applicable Field
 
     C                   IF        DDBCWA <> *BLANK AND
     C                             DDBCWA <> 'Y'    AND
     C                             DDBCWA <> 'N'
 
     C                   EVAL      DDBCWAOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBCWA'
     C                                        + %Trim (%Char(Counter))
     C                   EVAL      MsgIdXAr(Idx) = 'USR7511'
 
     C                   ELSE
      ** Intermediary Status = 'QI' & Backup WHT Applicable = 'Y'
     C                   IF        (DDINTS = 'QI ') AND (DDBCWA = 'Y')
     C                   EVAL      DDBCWAOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBCWA    '
     C                                        + %Trim (%Char(Counter))
     C                   EVAL      MsgIdXAr(Idx) = 'USR7521'
 
     C                   ELSE
 
      ** Default backup withholding applicable field if necessary.
 
     C                   IF        DDBCWA = *BLANK
      ** Doc. Received = 'U' & Intermediary Status = 'QI'
     C                   IF        (DDDCRC = 'U') AND (DDINTS <> 'QI')
     C                   EVAL      DDBCWA = 'Y'
     C                   ELSE
     C                   EVAL      DDBCWA = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** RETURN
 
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
 
      ** Field(s) requiring validation
     C                   PARM                    DDBCWA
     C                   PARM                    DDDCRC
     C                   PARM                    DDINTS
 
      * OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Backup WHT Applicable - OK
     C                   PARM                    DDBCWAOK
      ** Counter
     C                   PARM                    Counter
 
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
