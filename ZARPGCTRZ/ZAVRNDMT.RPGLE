     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ZA Validate Rounding Method')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  ZAVRNDMT - Midas ZA Validate Rounding Method                 *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 15May13               *
      *                 CRE073  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
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
                                                                                            MD000091
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
     C                   EVAL      DDRDMTOK = 'Y'
 
 
     C                   IF        PCurset = 0
     C                   EVAL      WCurset = *BLANKS
     C                   ELSE
     C                   EVAL      WCurset = %CHAR(PCurset)
     C                   ENDIF
 
      ** Validate Rounding Method
 
     C                   EXSR      SRRNDMT
 
     C                   IF        DDRDMTOK = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRNDMT - Validate Rounding Method                           *
      *****************************************************************
     C     SRRNDMT       BEGSR
 
 
      ** Prohibited if Contractual Spread is blanks
 
     C                   IF        PRoundMth <> *BLANKS
     C                   IF        PConSprd = *BLANKS
     C                   EVAL      DDRDMTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'USR9029'
     C                   IF        PModule = 'AMADDr'
     C                   EVAL      FldNamXAr(Idx) = 'DDDRMT' + WCurset
     C                   ELSEIF    PModule = 'AMADCr'
     C                   EVAL      FldNamXAr(Idx) = 'DDCRMT' + WCurset
     C                   ELSEIF    PModule = 'LERI  '
     C                   EVAL      FldNamXAr(Idx) = 'DDRDM2' + WCurset
     C                   ELSEIF    PModule = 'PENADr'
     C                   EVAL      FldNamXAr(Idx) = 'DPDRMT' + WCurset
     C                   ELSEIF    PModule = 'PENACr'
     C                   EVAL      FldNamXAr(Idx) = 'DPCRMT' + WCurset
     C                   ELSE
     C                   EVAL      FldNamXAr(Idx) = 'DDRDMT' + WCurset
     C                   ENDIF
 
     C                   ELSE
 
      ** Check for the valid values
 
     C                   IF        PRoundMth <> 'UP' AND
     C                             PRoundMth <> 'DOWN' AND
     C                             PRoundMth <> 'NEAREST'
     C                   EVAL      DDRDMTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'USR9027'
     C                   IF        PModule = 'AMADDr'
     C                   EVAL      FldNamXAr(Idx) = 'DDDRMT' + WCurset
     C**********         EVAL      MsgDtaXAr(Idx) = 'Debit'                                 MD000091
     C                   EVAL      MsgDtaTmp = 'Debit'                                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ELSEIF    PModule = 'AMADCr'
     C                   EVAL      FldNamXAr(Idx) = 'DDCRMT' + WCurset
     C**********         EVAL      MsgDtaXAr(Idx) = 'Credit'                                MD000091
     C                   EVAL      MsgDtaTmp = 'Credit'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ELSEIF    PModule = 'AMADCr'
     C                   EVAL      FldNamXAr(Idx) = 'DDRDM2' + WCurset
     C**********         EVAL      MsgDtaXAr(Idx) = 'Debit'                                 MD000091
     C                   EVAL      MsgDtaTmp = 'Debit'                                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ELSEIF    PModule = 'PENADr'
     C                   EVAL      FldNamXAr(Idx) = 'DPDRMT' + WCurset
     C                   ELSEIF    PModule = 'PENACr'
     C                   EVAL      FldNamXAr(Idx) = 'DPCRMT' + WCurset
     C                   ELSE
     C                   EVAL      FldNamXAr(Idx) = 'DDRDMT' + WCurset
     C**********         EVAL      MsgDtaXAr(Idx) = 'Debit'                                 MD000091
     C                   EVAL      MsgDtaTmp = 'Debit'                                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
      ** Mandatory if Rounding Fraction/Decimal is entered
 
     C                   IF        PFracDec <> *BLANKS AND
     C                             PConSprd <> *BLANKS
     C                   EVAL      DDRDMTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'USR9028'
     C                   IF        PModule = 'AMADDr'
     C                   EVAL      FldNamXAr(Idx) = 'DDDRMT' + WCurset
     C                   ELSEIF    PModule = 'AMADCr'
     C                   EVAL      FldNamXAr(Idx) = 'DDCRMT' + WCurset
     C                   ELSEIF    PModule = 'LERI  '
     C                   EVAL      FldNamXAr(Idx) = 'DDRDM2' + WCurset
     C                   ELSEIF    PModule = 'PENADr'
     C                   EVAL      FldNamXAr(Idx) = 'DPDRMT' + WCurset
     C                   ELSEIF    PModule = 'PENACr'
     C                   EVAL      FldNamXAr(Idx) = 'DPCRMT' + WCurset
     C                   ELSE
     C                   EVAL      FldNamXAr(Idx) = 'DDRDMT' + WCurset
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
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
     C                   PARM                    PRoundMth         7
     C                   PARM                    PConSprd         12
     C                   PARM                    PFracDec          4
     C                   PARM                    PModule           6
     C                   PARM                    PCurset           2 0
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    Idx
     C                   PARM                    DDRDMTOK          1
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
