     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Debtor Account Line')                *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVDEBTACL - Validate Debtor Account Line                    *
      *                                                               *
      *  Component of: SETSESVAL                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. AR642262           Date 14Sep10               *
      *                 CSW210  *CREATE    Date 04May10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR642262 - Error in IBAN validation (Recompile)              *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Security API Trades Extended Settlements from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SETESDPD)
      *
      ** Security API Trades Extended Settlements for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVTRX2PD)
      *
      ** Security API Trades Extended Settlements error indicators
     D SEETES        E DS                  EXTNAME(SEETESPD)
      *
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Data structure to receive parameters from SE1805 for MT5xxs
     D PDATA         E DS                  EXTNAME(SE50DT)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Work parameter
     D WWLI01          S              1A
     D WWLI02          S              2A
     D WWLI34          S             34A
     D SWRTN           S              7A
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     D PMode           S              6A
      * Declared variables for IBAN
      /COPY SECPYSRC,SRIBAN_ILE
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise work variables.
     C                   EVAL      IDx = 0
     C                   EVAL      WIx = 0
      *
      ** Validate Debtor Account Line
      *
     C                   EXSR      SRValDLIN
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        ESDLINOK = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   IF        ESDLINOK <> 'N'
     C                   EVAL      T2DLIN = ESDLIN
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  SRValDLIN - Validation for Debtor Account Line               *
      *                                                               *
      *****************************************************************
      *
     C     SRValDLIN     BEGSR
      *
      ** Validate If Debtor Account Line is not Blank
      *
     C                   IF        ESDLIN <> *BLANKS
      *
      ** Debtor Identification and Debtor Address Lines are blanks
      *
     C                   IF        ESDIDN = *BLANKS And
     C                             ESDAD1 = *BLANKS And
     C                             ESDAD2 = *BLANKS And
     C                             ESDAD3 = *BLANKS And
     C                             ESDAD4 = *BLANKS
     C                   EVAL      ESDIDNOK = 'N'
     C                   EVAL      ESDLINOK = 'N'
     C                   EVAL      ESDAD1OK = 'N'
     C                   EVAL      ESDAD2OK = 'N'
     C                   EVAL      ESDAD3OK = 'N'
     C                   EVAL      ESDAD4OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDLIN'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00082'
     C                   ENDIF
      *
      ** Debtor must be left blank when Pay Code is Free of Payment
      *
     C                   IF        PPCOD <> '1' AND
     C                             PPCOD <> '5'
     C                   EVAL      ESDLINOK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDLIN'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00112'
     C                   ENDIF
      *
      ** Validate if Debtor Account line is IBAN
      *
     C                   IF        CSW210 = 'Y' AND
     C                             CFT004 = 'Y'
     C                   EVAL      IBANFld = ESDLIN
     C                   EXSR      SrIBAN
     C                   IF        WIBAN35 <> *BLANKS
     C                   EVAL      ESDLIN = WIBAN35
     C                   ENDIF
     C                   IF        IBANWarningMsg = 'Y'
     C                   EVAL      ESDLINOK = 'N'
     C                   EVAL      WFldNmXAr(WIx) = 'ESDLIN    '
     C                   EVAL      WMsgDtXAr(WIx) = 'Debtor A/c Line'
     C                   ENDIF
     C                   EVAL      T2FDBT = ValidIBANFlag
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EValDLIN      ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRIBAN - Validation for IBAN Account                         *
      *                                                               *
      *****************************************************************
      /COPY SECPYSRC,SEVIBANVAL
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    CSW210
 
     C                   PARM                    CFT004
 
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2010
