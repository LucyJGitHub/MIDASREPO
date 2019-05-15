     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Extended Narratives')                *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVEXTNAR - Validate Extended Narratives                     *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030  *CREATE    Date 09Jul08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Chain Retail Account
      *
     FACNUMA    IF   E           K DISK    INFSR(*PSSR)
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
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
      *
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *
      ** Incoming Payments Extended Narrative incoming transaction
      ** - screen format
      *
     D NwIP6AScnFmt  E DS                  EXTNAME(FTIPY6APD)
      *
      ** Incoming Payments Margin info error indicators
      *
     D FTEIPY5       E DS                  EXTNAME(FTEIPY5PD)
      *
      ** Incoming Payments for file update - file format
      *
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** External DS for account details
     D PACCN         E DS                  EXTNAME(ACCNTAB)
     D  IBCNUM       E                     EXTFLD(CNUM)
     D  IBBRCA       E                     EXTFLD(BRCA)
     D  IBACOD       E                     EXTFLD(ACOD)
     D  IBACSQ       E                     EXTFLD(ACSQ)
      *
      ** DS for access programs - Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PNwrk           S              6A
     D PMsgTyp         S              3A
     D PBrca           S              3A
     D*PCusno***       S              6  0                                                    CER059
     D PCusno          S              6A                                                      CER059
     D PCcy            S              3A
     D PAccd           S             10S 0
     D PAcsq           S              2S 0
     D PDCin           S              1A
     D PRtty           S              5A
     D PNarr1          S             65A
     D PNarr2          S             65A
     D PNarr3          S             65A
     D PNarr4          S             65A
     D PNarr5          S             65A
     D PNarr6          S             65A
     D PRtFln1         S             70A
     D PRtFln2         S             70A
     D PRtFln3         S             70A
     D PRtFln4         S             70A
     D PRtFln5         S             70A
     D PRtFln6         S             70A
     D PRtFln7         S             70A
     D PRtFln8         S             70A
     D PRtFln9         S             70A
     D PRtFln10        S             70A
     D PRtFln11        S             70A
     D PRtFln12        S             70A
     D PRtFln13        S             70A
     D PRtFln14        S             70A
     D PRtFln15        S             70A
     D PRtFln16        S             70A
     D PRtFln17        S             70A
     D PRtFln18        S             70A
     D PRtFln19        S             70A
     D PRtFln20        S             70A
      *
     D WCusno          S              6A
     D WAccd           S             10A
     D WAcsq           S              2A
     D Idx             S              3  0
     D WPos            S              3  0
     D WTAcno          S             10A
     D WAcno           S             10  0
      *
     D PMode           S              6A
      *
     D PIBan           S             47A
     D PIBan1          S             34A
     D PoWith          S             47A
     D PoNobl          S             34A
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
      ** Validate Extended narratives
      *
     C                   EXSR      SRExtNarr
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKEXT1 = 'N' OR
     C                             OKEXT2 = 'N' OR
     C                             OKEXT3 = 'N' OR
     C                             OKEXT4 = 'N' OR
     C                             OKEXT5 = 'N' OR
     C                             OKEXT6 = 'N'
      *
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ELSE
      *
      ** Move value to valid file
      *
     C                   EVAL      IPEXT1 = DDEXT1
     C                   EVAL      IPEXT2 = DDEXT2
     C                   EVAL      IPEXT3 = DDEXT3
     C                   EVAL      IPEXT4 = DDEXT4
     C                   EVAL      IPEXT5 = DDEXT5
     C                   EVAL      IPEXT6 = DDEXT6
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtNarr -  Extended Narrative validation subroutine        *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRExtNarr     BEGSR
      *
     C                   IF        IPBNCT = 'R'  OR IPBNCT = 'P'
     C                             OR IPBNCT = 'I'
      *
     C                   SELECT
      *
     C                   WHEN      IPBNCT = 'R'
     C                   EVAL      WTAcno = %SUBST(IPBNC1 : 1 : 10)
     C                   MOVEL     *BLANKS       WAcno
     C                   MOVEL     WTAcno        WAcno
      *
     C     WAcno         CHAIN     ACNUMA
      *
     C                   IF        %FOUND(ACNUMA)
      *
     C**********         EVAL      PCusno = CNUM                                              CER059
     C                   MOVE      CNUM          PCusno                                       CER059
     C                   EVAL      PCcy = CCY
     C                   EVAL      PAccd = ACOD
     C                   EVAL      PAcsq = ACSQ
     C                   EVAL      PBrca = BRCA
     C                   ENDIF
      *
      ** Partial Account
      *
     C                   WHEN      IPBNCT = 'P'
      *
     C                   EVAL      WCusno = %SUBST(IPBNC1 : 1 : 6)
     C                   EVAL      PCcy = DDPCCY
     C                   EVAL      WAccd = %SUBST(IPBNC1 : 7 : 10)
     C                   EVAL      WAcsq = %SUBST(IPBNC1 : 17 : 2)
     C                   EVAL      PBrca = %SUBST(IPBNC1 : 19 : 3)
      *
     C                   MOVE      WCusno        PCusno
     C                   MOVE      WAccd         PAccd
     C                   MOVE      WAcsq         PAcsq
      *
      ** IBAN Account
      *
     C                   WHEN      IPBNCT = 'I'
      *
     C                   IF        %SUBST(IPBNC1 : 1 : 1) = '/'
     C     34            SUBST     IPBNC1:2      PIBan
     C                   ELSE
     C                   MOVEL     IPBNC1        PIBan
     C                   ENDIF
 
     C                   CALL      'AOIBANR3'
     C                   PARM                    PRtcd
     C                   PARM                    PIBan
     C                   PARM                    PoWith
     C     PIBan1        PARM                    PoNobl
      *
     C                   MOVE      *BLANKS       DSSDY
     C                   CALL      'AOIBANR4'
     C                   PARM                    PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PIBan1           34
     C     PACCN         PARM                    DSSDY
      *
     C                   EVAL      PCcy = DDPCCY
     C**********         Z-ADD     IBCNUM        PCusno                                       CER059
     C                   MOVE      IBCNUM        PCusno                                       CER059
     C                   Z-ADD     IBACOD        PAccd
     C                   Z-ADD     IBACSQ        PAcsq
     C                   EVAL      PBrca  = IBBRCA
      *
     C                   ENDSL
      *
     C                   ELSE
      *
     C**********         EVAL      PCusno = *ZEROS                                            CER059
     C                   EVAL      PCusno = *BLANKS                                           CER059
     C                   EVAL      PCcy = *BLANKS
     C                   EVAL      PAccd = *ZEROS
     C                   EVAL      PAcsq = *ZEROS
     C                   EVAL      PBrca = *BLANKS
      *
     C                   ENDIF
      *
     C                   EVAL      POptn = '*VALID'
      *
     C                   CALL      'MG001900'
     C                   PARM                    PRtcd
     C                   PARM                    POptn
     C                   PARM                    PNwrk
     C                   PARM                    PMsgTyp
     C                   PARM                    PBrca
     C                   PARM                    PCusno
     C                   PARM                    PCcy
     C                   PARM                    PAccd
     C                   PARM                    PAcsq
     C                   PARM                    PDCin
     C                   PARM      DDRTTY        PRtty
     C                   PARM      DDEXT1        PNarr1
     C                   PARM      DDEXT2        PNarr2
     C                   PARM      DDEXT3        PNarr3
     C                   PARM      DDEXT4        PNarr4
     C                   PARM      DDEXT5        PNarr5
     C                   PARM      DDEXT6        PNarr6
     C                   PARM                    PRtFln1
     C                   PARM                    PRtFln2
     C                   PARM                    PRtFln3
     C                   PARM                    PRtFln4
     C                   PARM                    PRtFln5
     C                   PARM                    PRtFln6
     C                   PARM                    PRtFln7
     C                   PARM                    PRtFln8
     C                   PARM                    PRtFln9
     C                   PARM                    PRtFln10
     C                   PARM                    PRtFln11
     C                   PARM                    PRtFln12
     C                   PARM                    PRtFln13
     C                   PARM                    PRtFln14
     C                   PARM                    PRtFln15
     C                   PARM                    PRtFln16
     C                   PARM                    PRtFln17
     C                   PARM                    PRtFln18
     C                   PARM                    PRtFln19
     C                   PARM                    PRtFln20
     C                   PARM      *ZEROS        Idx
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
     C                   IF        PRtcd = '*ERROR'
      *
     C                   EVAL      WPos = %LOOKUP('ADDI1':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'DDEXT1'
     C                   EVAL      OKEXT1 = 'N'
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('ADDI2':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'DDEXT2'
     C                   EVAL      OKEXT2 = 'N'
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('ADDI3':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'DDEXT3'
     C                   EVAL      OKEXT3 = 'N'
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('ADDI4':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'DDEXT4'
     C                   EVAL      OKEXT4 = 'N'
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('ADDI5':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'DDEXT5'
     C                   EVAL      OKEXT5 = 'N'
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('ADDI6':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'DDEXT6'
     C                   EVAL      OKEXT6 = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      *
     C                   PARM                    RetCodeIn
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Incoming Payments Extended Narratives incoming transaction
      ** - screen format
      *
     C                   PARM                    NwIP6AScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
      *
     C                   PARM                    PMode
      *
      ** OUTPUT
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Margin info error indicators
     C                   PARM                    FTEIPY5
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
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
** CPY@
(c) Finastra International Limited 2008
