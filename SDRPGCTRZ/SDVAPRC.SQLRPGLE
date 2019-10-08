     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas SD Validate APR Calculation Flag')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVAPRC - Midas SD Validate APR Calculation Flag             *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD054028           Date 05Sep19               *
      *  Prev Amend No. CER050  *Create    Date 16Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
      *             being updated                                     *
      *  CER050 - Annualised Percentage Rate                          *
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

      * Midas SD Additional customer details
     D SDACUS        E DS                  EXTNAME(SDACUSPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WId             S              3P 0

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
     C                   EXSR      SRVAPRC
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDAPRCOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      *  RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SRVAPRC - Routine to validate the APR Calculation
      *****************************************************************
     C     SRVAPRC       BEGSR
      *
      **  Default APR Flag if blank
     C                   IF        DDAPRC =  *Blanks
     C                   Exsr      SRVAPRF
     C                   ENDIF
      *
      * APR Calculation must be 'Y' or 'N' or Blanks
     C     DDAPRC        IFNE      'Y'
     C     DDAPRC        ANDNE     'N'
     C     DDAPRC        ANDNE     *BLANKS
      *
     C**********         MOVE      'Y'           DDAPRCOK                                   MD054028
     C**********         EVAL      RetCodeIn = 'Warning'                                    MD054028
     C**********         EVAL      DDAPRC = 'N'                                             MD054028
     C**********         ADD       1             WId                                        MD054028
     C**********         MOVEL     'DDAPRC'      WFldNmXAr(WId)                             MD054028
     C**********         MOVEL     'SDX0460'     WMsgIDXAr(WId)                             MD054028
     C                   MOVE      'N'           DDAPRCOK                                   MD054028
     C                   EVAL      RetCodeIn = 'Error'                                      MD054028
     C                   ADD       1             Idx                                        MD054028
     C                   MOVEL     'DDAPRC'      FldNamXAr(Idx)                             MD054028
     C                   MOVEL     'SDX0460'     MsgIDXAr(Idx)                              MD054028
      *
     C                   ENDIF
      *
     C                   ENDSR

      *****************************************************************
      ** SRVAPRF - Validate APR Flag
      *****************************************************************
     C     SRVAPRF       BEGSR

      ** Access SDACUSPD

     C/exec SQL
     C+ select *
     C+ into :SDACUS
     C+ from SDACUSPD
     C+ where E5CUST =: DDCUSN
     C/end-exec

     C     SQLCOD        Ifne      100
     C                   Eval      DDAPRC = E5APRC
     C                   Endif
      *
      ** Default
     C                   If        DDAPRC = *Blanks
     C                   Eval      DDAPRC = 'Y'
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      * INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Customer Number
     C                   Parm                    DDCUSN            6
      ** Other parms
      ** APR Calculation Inndicator(1A)
     C                   PARM                    DDAPRC            1
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      * OUTPUTS
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      ** Other parms
      ** APR Calculation indndicator - OK
     C                   PARM                    DDAPRCOK          1
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2016
