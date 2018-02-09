     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate A/c for Payment A/c Line :53:')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVAP2L - Validate Account for Payment A/c Line 2            *
      *                                                               *
      *  Component of: SETSESVAL                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 AR642262           Date 14Sep10               *
      *                 AR584262           Date 28Jul10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE045  *CREATE    Date 24Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR642262 - Error in IBAN validation (Recompile)              *
      *  AR584262 - Warning message is not correct                    *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
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
     D WWAP2L          S              1A
     D WWCLTY          S              2A
     D WTDTP           S              2A
     D CSE028          S              1A                                                      CSW210
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     D PMode           S              6A
      * Declared variables for IBAN                                                           CSW210
      /COPY SECPYSRC,SRIBAN_ILE                                                               CSW210
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
     C                   EVAL      WIx = 0                                                    CSW210
      *
      ** Validate A/c for Payment A/c Line :53: (MT510)
      *
     C                   EXSR      SRValAp2l
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        ESAP2LOK = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        ESAP2LOK <> 'N'
     C                   MOVEL     ESAP2L        T2AFPL
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALAP2L - Validation for Account for Payment A/c Line 2    *
      *                                                               *
      *****************************************************************
 
     C     SRValAp2l     BEGSR
     C                   IF        PSNEW <> 'Y' OR                                            CSW210
     C                             CSE028 <> 'Y'                                              CSW210
      *
      ** Validate If not Blank
      *
     C                   MOVEL     ESAP2L        WWAP2L
     C     ESAP2L        IFNE      *BLANKS
     C     WWAP2L        ANDNE     '#'
      *
     C     WWCLTY        IFEQ      '14'
     C                   MOVE      'N'           ESAP2LOK
     C                   ADD       1             IDx
     C                   MOVEL     'ESAP2L'      FldNamXAr(IDx)
     C     ESAP2N        IFEQ      *BLANKS
     C                   MOVEL     'SEW5216'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   ELSE
      *
      ** Account for Payment must be left Blank for Instructions Free
      *
     C     PPCOD         IFNE      '1'
     C     PPCOD         ANDNE     '5'
     C                   MOVE      'N'           ESAP2LOK
     C                   ADD       1             IDx
     C                   MOVEL     'ESAP2L'      FldNamXAr(IDx)
     C     ESAP2N        IFEQ      *BLANKS
     C                   MOVEL     'SEW5217'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     ESAP2L        WWLI01
     C     WWLI01        IFNE      '/'
     C                   MOVE      'N'           ESAP2LOK
     C                   ADD       1             IDx
     C                   MOVEL     'ESAP2L'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5210'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   MOVEL     ESAP2L        WWLI02
     C     WWLI02        IFEQ      '//'
     C                   MOVE      'N'           ESAP2LOK
     C                   ADD       1             IDx
     C                   MOVEL     'ESAP2L'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5211'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   MOVE      ESAP2L        WWLI34
     C     WWLI01        IFEQ      '/'
     C     WWLI34        ANDEQ     *BLANKS
     C                   MOVE      'N'           ESAP2LOK
     C                   ADD       1             IDx
     C                   MOVEL     'ESAP2L'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5212'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Either SWIFT Field 53 or (57 AND 58) can be Entered
      *
     C     WTDTP         IFEQ      'TS'
     C     ESAP2N        ANDNE     *BLANKS
 
     C     WTDTP         OREQ      'TS'
     C     ESAP2L        ANDNE     *BLANKS
 
     C     ESAWIN        IFNE      *BLANKS
     C     ESAWIL        ORNE      *BLANKS
     C     ESBOFN        ORNE      *BLANKS
     C     ESBOF1        ORNE      *BLANKS
     C     ESBOF2        ORNE      *BLANKS
     C                   MOVE      'N'           ESAP2LOK
     C                   ADD       1             IDx
     C                   MOVEL     'ESAP2L'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5215'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** IBAN Validation                                                                      CSW210
      *                                                                                       CSW210
     C                   IF        ESAP2L <> *BLANKS AND                                      CSW210
     C                             CSW210 = 'Y' AND                                           CSW210
     C                             CFT004 = 'Y'                                               CSW210
     C                   EVAL      IBANFld = ESAP2L                                           CSW210
     C                   EXSR      SrIBAN                                                     CSW210
     C                   IF        WIBAN35 <> *BLANKS                                         CSW210
     C                   EVAL      ESAP2L = WIBAN35                                           CSW210
     C                   ENDIF                                                                CSW210
     C                   IF        IBANWarningMsg = 'Y'                                       CSW210
     C                   EVAL      ESAP2LOK = 'N'                                             CSW210
     C                   EVAL      WFldNmXAr(WIx) = 'ESAP2L    '                              CSW210
     C**********         EVAL      WMsgDtXAr(WIx) = 'Acc. for Payment2'              CSW210 AR584262
     C                   EVAL      WMsgDtXAr(WIx) = 'Account for Payment +                  AR584262
     C                                              Account 2'                              AR584262
     C                   ENDIF                                                                CSW210
     C                   EVAL      T2FAP2 = ValidIBANFlag                                     CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C     EValAp2l      ENDSR
 
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      *  SRIBAN - Validation for IBAN Account                         *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
      /COPY SECPYSRC,SEVIBANVAL                                                               CSW210
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
 
     C                   PARM                    WWCLTY
 
     C                   PARM                    WTDTP
                                                                                              CSW210
     C                   PARM                    CSW210                                       CSW210
                                                                                              CSW210
     C                   PARM                    CFT004                                       CSW210
                                                                                              CSW210
     C                   PARM                    CSE028                                       CSW210
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                       CSW210
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSW210
     C                   PARM                    WFldNmXAr                                    CSW210
     C                   PARM                    WMsgIDXAr                                    CSW210
     C                   PARM                    WMsgDtXAr                                    CSW210
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
(c) Finastra International Limited 2003
