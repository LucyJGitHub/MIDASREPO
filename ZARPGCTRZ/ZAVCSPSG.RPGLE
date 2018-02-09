     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ZA Validate Contractual Spread and Sign')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  ZAVCSPSG - Midas ZA Validate Contractual Spread and Sign     *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 15May13               *
      *                 AR994581           Date 20Nov12               *
      *                 AR993993           Date 27Jun12               *
      *                 AR947093           Date 26Apr12               *
      *                 AR936885           Date 20Mar12               *
      *                 AR881060           Date 20Dec11               *
      *                 AR864560           Date 02Dec11               *
      *                 AR864546           Date 24Nov11               *
      *                 AR844497           Date 04Oct11               *
      *                 CRE073  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR994581 - Inconsistent description in error message in      *
      *             Period and Penallty Details (Credit Interest Side)*
      *  AR993993 - System does not allow only Contractual Spread     *
      *             without contractual details                       *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR936885 - Cannot input SECS if BSRT is blank and contractual*
      *             spread has value                                  *
      *  AR881060 - No validation on Blank base rate                  *
      *  AR864560 - Cannot input SECS if BSRT is blank and contractual*
      *             spread has value                                  *
      *  AR864546 - A Serious Midas Error encountered in Securities   *
      *             Maintenance FRN tab                               *
      *  AR844497 - A Serious Midas Error encountered                 *
      *  CRE073 - Interest Rate Rounding                              *
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
 
      ** Work Variable
     D WCurset         S              2A
     D WRun            S              1A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
      ** Parameter variables                                                                AR993993
                                                                                            AR993993
     D PRTCD           S              7A                                                    AR993993
     D POPTN           S              7A                                                    AR993993
     D PSARD           S              6A                                                    AR993993
     D CLE036          S              1A                                                    AR993993
                                                                                            AR993993
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
 
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      DDCNSPOK = 'Y'
     C                   EVAL      DDCNSGOK = 'Y'
 
     C                   IF        PCurset = 0
     C                   EVAL      WCurset = *BLANKS
     C                   ELSE
     C                   EVAL      WCurset = %CHAR(PCurset)
     C                   ENDIF
 
      ** Validate Contractual Spread and Sign
 
     C                   EXSR      SRSPSG
 
     C                   IF        DDCNSPOK = 'N' OR
     C                             DDCNSGOK = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSPSG - Validate Contractual Spread and Sign                *
      *****************************************************************
     C     SRSPSG        BEGSR
 
      ** Contractual Spread Rate
 
     C                   IF        PConSprd <> *BLANKS
 
     C                   SELECT
 
      ** Prohibited if Fixed Rate is entered
 
     C                   WHEN      PFixRate <> *BLANK AND
     C                             (Pmodule = 'LOAN  ' OR
     C                             Pmodule = 'LERI  ')
 
     C                   EVAL      DDCNSPOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'USR9033'
     C                   IF        PModule = 'LOAN  '
     C                   EVAL      FldNamXAr(Idx) = 'DDCNSP' + WCurset
     C                   ELSE
     C                   EVAL      FldNamXAr(Idx) = 'DDCNS2' + WCurset
     C                   ENDIF
 
      ** Prohibited if Base Rate/Code is not entered
 
     C                   WHEN      PBaseCode = *BLANKS AND
     C                             PBaseRate = *BLANKS AND
     C**********                   Pmodule = 'LOAN  '                                       AR881060
     C**********                   (Pmodule = 'LOAN  ' Or Pmodule = 'SECU  ')      AR881060 AR936885
     C**********                   (Pmodule = 'LOAN  ' Or                          AR936885 AR993993
     C                             ((Pmodule = 'LOAN  ' AND CLE036 = 'Y') OR                AR993993
     C                              Pmodule = 'SECU  ' and PConSign= 'S')                   AR936885
 
     C                   EVAL      DDCNSPOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCNSP' + WCurset
     C                   EVAL      MsgIdXAr(Idx) = 'USR9034'
 
     C                   OTHER
 
     C                   IF        Pmodule <> 'LDNI  '                                      AR947093
                                                                                            AR947093
     C                   MOVE      *BLANKS       PSCRF
     C                   MOVE      PConSprd      PSCRF
     C                   Z-ADD     4             PNDIG
     C                   Z-ADD     7             PNDEC
 
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM                    PSCRF            16
     C                   PARM                    PNDEC             1 0
     C                   PARM                    PNDIG             2 0
     C                   PARM      *BLANKS       PRVAL            16
 
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DDCNSPOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'USR9023'
     C                   IF        PModule = 'AMADDr'
     C                   EVAL      FldNamXAr(Idx) = 'DDDCSP' + WCurset
     C**********         EVAL      MsgDtaXAr(Idx) = 'Debit'                                 MD000091
     C                   EVAL      MsgDtaTmp = 'Debit'                                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ELSEIF    PModule = 'AMADCr'
     C                   EVAL      FldNamXAr(Idx) = 'DDCCSP' + WCurset
     C**********         EVAL      MsgDtaXAr(Idx) = 'Credit'                                MD000091
     C                   EVAL      MsgDtaTmp = 'Credit'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ELSEIF    PModule = 'LERI  '
     C                   EVAL      FldNamXAr(Idx) = 'DDCNS2' + WCurset
     C**********         EVAL      MsgDtaXAr(Idx) = 'Debit'                                 MD000091
     C                   EVAL      MsgDtaTmp = 'Debit'                                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ELSEIF    PModule = 'PENADr'
     C                   EVAL      FldNamXAr(Idx) = 'DPDCSP' + WCurset
     C**********         EVAL      MsgDtaXAr(Idx) = 'Debit'                                 MD000091
     C                   EVAL      MsgDtaTmp = 'Debit'                                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ELSEIF    PModule = 'PENACr'
     C                   EVAL      FldNamXAr(Idx) = 'DPCCSP' + WCurset
     C**********         EVAL      MsgDtaXAr(Idx) = 'Debit'                                 AR994581
     C**********         EVAL      MsgDtaXAr(Idx) = 'Credit'                       AR994581 MD000091
     C                   EVAL      MsgDtaTmp = 'Credit'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ELSE
     C                   EVAL      FldNamXAr(Idx) = 'DDCNSP' + WCurset
     C**********         EVAL      MsgDtaXAr(Idx) = 'Debit'                                 MD000091
     C                   EVAL      MsgDtaTmp = 'Debit'                                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ENDIF
     C                   ELSE
     C                   MOVE      PRVAL         TMCNSP
 
      ** Contractual Spread Sign
      ** Mandatory if Contractual spread is entered
 
     C                   IF        PConSign = *BLANKS
     C                   EVAL      DDCNSGOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'USR9025'
     C                   IF        PModule = 'AMADDr'
     C                   EVAL      FldNamXAr(Idx) = 'DDDCSG' + WCurset
     C                   ELSEIF    PModule = 'AMADCr'
     C                   EVAL      FldNamXAr(Idx) = 'DDCCSG' + WCurset
     C                   ELSEIF    PModule = 'LERI  '
     C                   EVAL      FldNamXAr(Idx) = 'DDCNG2' + WCurset
     C                   ELSEIF    PModule = 'PENADr'
     C                   EVAL      FldNamXAr(Idx) = 'DPDCSG' + WCurset
     C                   ELSEIF    PModule = 'PENACr'
     C                   EVAL      FldNamXAr(Idx) = 'DPCCSG' + WCurset
     C                   ELSE
     C                   EVAL      FldNamXAr(Idx) = 'DDCNSG' + WCurset
     C                   ENDIF
 
     C                   ELSE
 
      ** Valid values are 'A', 'S' and 'P' only
 
     C                   IF        (PConSign <> 'A' AND
     C                              PConSign <> 'S' AND
     C                              PConSign <> 'P') AND
     C                              (PModule = 'LOAN  ' OR
     C                              PModule = 'LERI  ')
     C                   EVAL      DDCNSGOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      MsgDtaXAr(Idx) = 'A, S or P'                             MD000091
     C                   EVAL      MsgDtaTmp = 'A, S or P'                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   EVAL      MsgIdXAr(Idx) = 'USR9026'
     C                   IF        Pmodule = 'LOAN  '
     C                   EVAL      FldNamXAr(Idx) = 'DDCNSG' + WCurset
     C                   ELSE
     C                   EVAL      FldNamXAr(Idx) = 'DDCNG2' + WCurset
     C                   ENDIF
 
      ** Valid values are '+', and '-' only for AMAD
 
     C                   ELSEIF    (PConSign <> '+' AND
     C                              PConSign <> '-' ) AND
     C                             (PModule = 'AMADDr' OR
     C                              PModule = 'AMADCr' OR
     C                              PModule = 'PENADr' OR
     C                              PModule = 'PENACr')
     C                   EVAL      DDCNSGOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   IF        PModule = 'AMADDr'
     C                   EVAL      FldNamXAr(Idx) = 'DDDCSG' + WCurset
     C                   ELSEIF    PModule = 'AMADCr'
     C                   EVAL      FldNamXAr(Idx) = 'DDCCSG' + WCurset
     C                   ELSEIF    PModule = 'PENADr'
     C                   EVAL      FldNamXAr(Idx) = 'DPDCSG' + WCurset
     C                   ELSEIF    PModule = 'PENACr'
     C                   EVAL      FldNamXAr(Idx) = 'DPCCSG' + WCurset
     C                   ENDIF
     C                   EVAL      MsgIdXAr(Idx) = 'USR9026'
     C**********         EVAL      MsgDtaXAr(Idx) = '+ or -'                                MD000091
     C                   EVAL      MsgDtaTmp = '+ or -'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF                                                              AR947093
 
     C                   ENDSL
 
     C                   ELSE
 
      ** Contractual Spread Sign
      ** Prohibited if Contractual spread is not entered
 
     C                   IF        PConSign <> *BLANKS  AND
     C                             PModule <> 'LDNI  '
     C                             and PModule <> 'SECU'                                    AR844497
     C                   EVAL      DDCNSGOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'USR9024'
     C                   IF        PModule = 'AMADDr'
     C                   EVAL      FldNamXAr(Idx) = 'DDDCSG' + WCurset
     C                   ELSEIF    PModule = 'AMADCr'
     C                   EVAL      FldNamXAr(Idx) = 'DDCCSG' + WCurset
     C                   ELSEIF    PModule = 'LERI  '
     C                   EVAL      FldNamXAr(Idx) = 'DDCNG2' + WCurset
     C                   ELSEIF    PModule = 'PENADr'
     C                   EVAL      FldNamXAr(Idx) = 'DPDCSG' + WCurset
     C                   ELSEIF    PModule = 'PENACr'
     C                   EVAL      FldNamXAr(Idx) = 'DPCCSG' + WCurset
     C                   ELSE
     C                   EVAL      FldNamXAr(Idx) = 'DDCNSG' + WCurset
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C**********         IF        PConSign <> *BLANKS AND                         AR844497 AR864560
     C                   IF        PConSign = 'P' AND                                       AR864560
     C                             (PBaseCode = *BLANKS  OR                                 AR844497
     C                             PConSprd  = *BLANKS)                                     AR844497
     C**********         IF        PModule = 'SECU' and                            AR844497 AR864546
     C**********                   WCurset = *BLANKS                               AR844497 AR864546
     C                   IF        PModule = 'SECU'                                         AR864546
     C                   EVAL      DDCNSGOK = 'N'                                           AR844497
     C                   EVAL      Idx = Idx + 1                                            AR844497
     C                   EVAL      MsgIdXAr(Idx) = 'USR9036'                                AR844497
     C                   EVAL      FldNamXAr(Idx) = 'DDCNSG' + WCurset                      AR844497
     C                   ENDIF                                                              AR844497
     C                   ENDIF                                                              AR844497
                                                                                            AR844497
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
 
     C                   PARM                    RetCodeIn
     C                   PARM                    PBaseRate        12
     C                   PARM                    PBaseCode         2
     C                   PARM                    PFixRate         12
     C                   PARM                    PConSprd         12
     C                   PARM                    PConSign          1
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    TMCNSP           11 7
     C                   PARM                    PModule           6
     C                   PARM                    PCurset           2 0
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    Idx
     C                   PARM                    DDCNSPOK          1
     C                   PARM                    DDCNSGOK          1
                                                                                            AR993993
      ** Determine if Fixed Base Rate and Repayments in Facility                            AR993993
      ** Currency(CLE036) is installed                                                      AR993993
                                                                                            AR993993
     C                   EVAL      CLE036 = 'N'                                             AR993993
     C                   CALL      'AOSARDR0'                                               AR993993
     C                   PARM      *BLANKS       PRTCD                                      AR993993
     C                   PARM      '*VERIFY'     POPTN                                      AR993993
     C                   PARM      'CLE036'      PSARD                                      AR993993
     C                   IF        PRTCD  = *BLANKS                                         AR993993
     C                   EVAL      CLE036 = 'Y'                                             AR993993
     C                   ENDIF                                                              AR993993
                                                                                            AR993993
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANK
     C                   EVAL      Wrun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
