     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Beneficiary of Money (Customer)')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVBOFN - Validate Beneficiary of Money (Cust Number) 1      *
      *                                                               *
      *  Component of: SETSESVAL                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSE045   *CREATE   Date 24Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
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
     D WWCABA          S              3P 0
     D WWCSID          S             12A
     D WWBLCD          S              8A
     D WWFWCD          S              9A
     D WWCHID          S              6P 0
     D WWCHSC          S              6P 0
     D WWBNBI          S              1A
     D WWNOST          S              8A
     D WWBOFN          S             10A
     D WBOFN           S             10A
     D SWRTN           S              7A
     D CSE028          S              1A
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
      ** Validate Beneficiary of Money (Customer Number)
      *
     C                   EXSR      SRValBofn
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        ESBOFNOK = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        ESBOFNOK <> 'N'
     C                   IF        (ESAWIN <> *BLANKS) or (ESAWIL <> *BLANKS)
     C                             or (*IN88 = *ON)
     C                   MOVEL     WWBOFN        T2BOFN
     C                   ELSE
     C                   MOVEL     *BLANKS       T2BOFN
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALBOFN - Validation for Beneficiary of Money              *
      *              (Customer Number)                                *
      *                                                               *
      *****************************************************************
 
     C     SRValBofn     BEGSR
 
     C                   MOVEL     *BLANKS       WBOFN
      *
      ** Validate If not Blank
      *
     C     ESBOFN        IFNE      *BLANKS
      *
      ** Validate Customer Number/Shortname/Nostro
      *
     C                   MOVE      ESBOFN        WWCUST
     C                   EXSR      SRCUST
      *
      ** Customer Number/Shortname
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C                   MOVEL     BBCUST        WWBOFN
     C                   ENDIF
      *
      ** Nostro
      *
     C     WWCUSS        IFEQ      'N'
     C                   MOVEL     AWCPNC        WWBOFN
     C                   ENDIF
 
     C     SWRTN         IFEQ      'CSW098 '
     C                   MOVEL     WWBOFN        WBOFN
     C                   ENDIF
      *
      ** Either SAWIN or SAWIL must be Non-Blank
      ** (SWIFT Field 57 must be Entered If 58 is Entered)
      *
     C     ESAWIN        IFEQ      *BLANKS
     C     ESAWIL        ANDEQ     *BLANKS
     C     *IN88         ANDEQ     *OFF
     C                   MOVE      'N'           ESAWINOK
     C                   MOVE      'N'           ESAWILOK
     C                   ADD       1             IDx
     C                   MOVEL     'ESAWIN'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5245'     MsgIdXAr(IDx)
     C                   MOVE      *BLANKS       WWBOFN
     C                   ENDIF
 
     C                   ELSE
      *
      ** Else If Screen Field is Blank, ensure workfield is also Blank
      *
     C                   MOVE      *BLANKS       WWBOFN
     C                   ENDIF
 
     C     EValBofn      ENDSR
 
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
 
     C                   MOVE      *BLANKS       WWCUSS
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
     C     PRtcd         IFEQ      *BLANK
     C     WKyst         ANDNE     '*ERROR'
 
     C     WKyst         IFEQ      '*CNUM'
     C                   MOVE      'C'           WWCUSS
     C                   ELSE
     C                   MOVE      'S'           WWCUSS
     C                   ENDIF
      *
      ** If Customer Number or Shortname then save file fields.
      *
     C                   MOVE      BBCABA        WWCABA
     C                   MOVE      BBCSID        WWCSID
     C                   MOVE      BBBLCD        WWBLCD
     C                   MOVE      BBFWCD        WWFWCD
     C                   MOVE      BBCHID        WWCHID
     C                   MOVE      BBCHSC        WWCHSC
     C                   MOVE      BBBNBI        WWBNBI
      *
      ** Else (error on Customer file) may be a Counterparty Nostro
      *
     C                   ELSE
     C                   MOVEL     WWCUST        WWNOST
     C                   CALL      'AOCNSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WWNOST        WKey2
     C     SDCNST        PARM      SDCNST        DSFDY
      *
      ** If Counterparty Nostro found set WWCUSS to 'N'.
      *
     C     PRtcd         IFEQ      *BLANK
     C                   MOVE      'N'           WWCUSS
     C                   MOVE      AWSWID        WWCSID
     C                   MOVE      AWFWCD        WWFWCD
     C                   MOVE      'Y'           WWBNBI
     C                   ENDIF
     C                   ENDIF
      *
      ** If no record found on either file then send error message
      *
     C     WWCUSS        IFNE      'C'
     C     WWCUSS        ANDNE     'S'
     C     WWCUSS        ANDNE     'N'
     C                   MOVE      'N'           ESBOFNOK
     C                   ADD       1             IDx
     C                   MOVEL     'ESBOFN'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5205'     MsgIdXAr(IDx)
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
 
     C                   PARM                    SWRTN
 
     C                   PARM                    PDATA
 
     C                   PARM                    CSE028
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
 
     C                   PARM                    WWCUSS
 
     C                   PARM                    WWBNBI
 
     C                   PARM                    WWCABA
 
     C                   PARM                    WWCSID
 
     C                   PARM                    WWFWCD
 
     C                   PARM                    WWBLCD
 
     C                   PARM                    WWCHID
 
     C                   PARM                    WWCHSC
 
     C                   PARM                    WBOFN
 
      *
      ** Enable display of counterparty safekeeping a/c if
      ** CSE028 is on and ISO15022 is on.
      *
     C     CSE028        IFEQ      'Y'
     C     PSNEW         ANDEQ     'Y'
     C     PGMES         ANDEQ     'Y'
     C                   EVAL      *IN88 = *ON
     C                   ELSE
     C                   EVAL      *IN88 = *OFF
     C                   ENDIF
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
(c) Misys International Banking Systems Ltd. 2003
