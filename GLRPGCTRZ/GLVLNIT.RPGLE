     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL AMAD Validate Line Item of Usura Report')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVLNIT - Validate Line Item of Usura Report                 *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2020                 *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. LUC139  *Create    Date 22Dec20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian returns upgrade to FM2.1                *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** Standard D-specs
      ** ================

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

      /COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      /COPY ZACPYSRC,PSDS

      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.

      /COPY ZACPYSRC,ERR_XARRYS

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
     D IRFXTB        E DS                  EXTNAME(IRFXTBPD)
      ** Midas Italy - Internal Table passed to AOFXTBR0

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs - short data structure

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D Idx             S              3P 0
      ** Index for arrays of error message ids, etc

     D p_RetCode       S              7A
     D p_Option        S              7A
     D p_KeyFld        S              3A
     D p_Field         S             24A
     D ZARetcode       S              1A
      ** Ok flag

     D DDTLNIT         S              7A
      ** Line Item of Usura Report

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation                   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      ** Initialise work variable

     C                   Z-ADD     0             Idx

      ** Initialize return code

     C                   EXSR      Sr_Initialize

      ** Validate Line Item of Usura report

     C                   EVAL      p_Field = *Blanks
     C                   EVAL      p_Field = DDTLNIT

     C                   MOVE      *Blanks       p_RetCode
     C                   MOVE      '*KEY   '     p_Option
     C                   MOVE      'BAW'         p_KeyFld

      ** Validates from the Standing Data Internal Table

     C                   CALL      'AOFXTBR0'
     C                   PARM                    p_RetCode
     C                   PARM                    p_Option
     C                   PARM                    p_KeyFld
     C                   PARM                    p_Field
     C     IRFXTB        PARM      IRFXTB        DSFDY

     C     p_RetCode     Ifne      *BLANKS
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDTLNIT   '
     C                   Eval      MsgIdXAr(Idx) = 'ITG7109'
     C                   Endif

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_Initialize - Initialize return code parameter             *
      *                                                               *
      *****************************************************************

     C     Sr_Initialize BEGSR

     C                   EVAL      RetCodeIn = *Blanks

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Return code

     C                   PARM                    RetCodeIn

      ** Line Item of Usura report

     C                   PARM                    DDTLNIT

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values

      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module

      /COPY ZACPYSRC,PSSR_ILE

      *****************************************************************
**  CPY@
(c) Finastra International Systems Ltd. 2020
