     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Place of Clearing')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVPLCLEAR - Validate Place of Clearing                      *
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
      *  Prev Amend No. CSW210   *CREATE   Date 04May10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
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
      ** Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Counterparty Nostro details
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
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
     D PRtcd           S              7A
     D POptn           S              7A
     D WKey1           S             10A
     D WKey2           S              8A
     D WKyst           S              7A
     D WWCUST          S             10A
     D WWCUSS          S              1A
     D WWNOST          S              8A
     D WWPCLR          S             10A
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     D PMode           S              6A
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
      *
      ** Validate Debtor Identification
      *
     C                   EXSR      SRValPCLR
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        ESPCLROK = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        ESPCLROK <> 'N'
     C                   EVAL      T2PCLR = WWPCLR
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALPCLR - Validation of Place of Clearing                  *
      *                                                               *
      *****************************************************************
 
     C     SRValPCLR     BEGSR
      *
      ** Validate if Place of Clearing is not blank
      *
     C                   IF        ESPCLR <> *BLANKS
      *
      ** Validate Qualified Foreign Intermediary
      *
     C                   EVAL      WWCUST = ESPCLR
     C                   EXSR      SRCust
      *
      ** Customer Number/Shortname
      *
     C                   IF        WWCUSS = 'C' OR
     C                             WWCUSS = 'S'
     C                   EVAL      WWPCLR = BBCUST
     C                   ENDIF
      *
      ** Nostro
      *
     C                   IF        WWCUSS = 'N'
     C                   EVAL      WWPCLR = AWCPNC
     C                   ENDIF
 
     C                   ELSE
      *
      ** Else If Screen Field is Blank, ensure workfield is also Blank
      *
     C                   EVAL      WWPCLR = *BLANKS
     C                   ENDIF
 
     C     EValPCLR      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCust - Validate Customer Number/Shortname/Nostro           *
      *         - This subroutine access AOCUSTR0 and AOCNSTR0        *
      *           to validate WWCUST.                                 *
      *                                                               *
      *****************************************************************
 
     C     SRCust        BEGSR
 
     C                   EVAL      WWCUSS = *BLANKS
      *
      ** Call Access Program for Customer Details using the Customer
      ** Number or the Customer Shortname.
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WWCUST        WKey1
     C                   PARM      *BLANKS       WKyst
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** If Return code is blank then set WWCUSS to 'C' if Customer
      ** Number; to 'S' if Customer Shortname.
      *
     C                   IF        PRtcd = *BLANKS AND
     C                             WKyst <> '*ERROR'
 
     C                   IF        WKyst = '*CNUM'
     C                   EVAL      WWCUSS = 'C'
     C                   ELSE
     C                   EVAL      WWCUSS = 'S'
     C                   ENDIF
      *
      ** Else (error on Customer file) may be a Counterparty Nostro
      *
     C                   ELSE
     C                   EVAL      WWNOST = WWCUST
     C                   CALL      'AOCNSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WWNOST        WKey2
     C     SDCNST        PARM      SDCNST        DSFDY
      *
      ** If Counterparty Nostro found set WWCUSS to 'N'.
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      WWCUSS = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** If no record found on either file then send error message
      *
     C                   IF        WWCUSS <> 'C' AND
     C                             WWCUSS <> 'S' AND
     C                             WWCUSS <> 'N'
     C                   EVAL      ESPCLROK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESPCLR'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00084'
     C                   ENDIF
 
     C     EndCust       ENDSR
 
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
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
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
