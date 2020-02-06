     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate OP Extended Narratives')             *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVOEXTNAR - Validate Extended Narratives                    *
      *                                                               *
      *  Component of: FTOPAY1SN                                      *
      *                FTOPAY2SN                                      *
      *                FTOPAYRPR                                      *
      *                FTOPAYCTL                                      *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22484           Date 27Jan09               *
      *                 CER030  *CREATE    Date 09Jul08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22484 - Extended Narrative (Debit) data was lost after    *
      *           first level authorisation                           *
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
     F                                     RENAME(ACCNTABF:ACNUMAF)
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
      ** Incoming Transaction
      *
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
      *
      ** Valid Payments layout
      *
     D ValidPmnt     E DS                  EXTNAME(FTVOPAYPD)
      *
      ** Flags to indicate whether transaction fields are valid
      *
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY5PD)
      *
     D TranInFiftA   E DS                  EXTNAME(FTOPY7APD)
      *
     D TranInFiftB   E DS                  EXTNAME(FTOPY7BPD)
      *
      ** External DS for account details
     D PACCN         E DS                  EXTNAME(ACCNTAB)
     D  IBCNUM       E                     EXTFLD(CNUM)
     D  IBBRCA       E                     EXTFLD(BRCA)
     D  IBACOD       E                     EXTFLD(ACOD)
     D  IBACSQ       E                     EXTFLD(ACSQ)
     D  IBCCY        E                     EXTFLD(CCY)
     D  IBLCD        E                     EXTFLD(LCD)
      *
      ** DS for access programs - Long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** External DS for SAR Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** External data structure for Nostro customer number
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D* QQACC1       E                     EXTFLD(QQACCD)
      *
      ** Ordering Cust. acc. for debit extended naarative validations
      *
     D ORDCST          DS            35
     D  WSORC1                 1     35
     D  IBAN1                  1     34
     D  IBAN2                  2     35
      *
     D  ONUM                   1      6
     D  ORET                   1     10
     D  OCOD                   7     16
     D  OSEQ                  17     18
     D  OBRC                  19     21
      *
     D  ONUMS                  2      7
     D  ORETS                  2     11
     D  OCODS                  8     17
     D  OSEQS                 18     19
     D  OBRCS                 20     22
      *
      ** Destination account for credit extended naarative validations
      *
     D DESTAN          DS            35
     D  WSDST1                 1     35
      *
     D  DRET                   1     10
      *
     D  NCUR                   1      3
     D  NNUM                   4      5
     D  DNOS                   1      5
      *
     D  DNUM                   1      6
     D  DSCY                   7      9
     D  DCOD                  10     19
     D  DSEQ                  20     21
     D  DBRC                  22     24
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WkFldNamAr      S             10A   DIM(XArrayMax)
     D WkMsgIdAr       S                   DIM(XArrayMax) LIKE(#MsgId)
     D WkMsgDtaAr      S                   DIM(XArrayMax) LIKE(#MsgData)
      *
     D CFT003          S              1A
     D PSard           S              6A
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
     D RespMode        S              1A
      *
      ** Index for update of error arrays
      *
     D Ix              S              3  0
      *
     D PIBan           S             34A
      *
      ** Parameters for AONOSTR0
      *
     D P1Rtcd          S              7A
     D P1Optn          S              7A
     D P1Cust          S              6A
     D P1Cycd          S              3A
     D P1Accd          S             10A
     D P1Acsn          S              2A
     D P1Nonb          S              2A
     D P1Brca          S              3A
     D P1Cssn          S             10A
     D P1Pnoi          S              1A
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
      ** Initialize Work Arrays
      *
     C                   EVAL      WkFldNamAr = *BLANKS
     C                   EVAL      WkMsgIdAr = *BLANKS
     C                   EVAL      WkMsgDtaAr = *BLANKS
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
     C                   EVAL      OTEXT1 = SEXT1
     C                   EVAL      OTEXT2 = SEXT2
     C                   EVAL      OTEXT3 = SEXT3
     C                   EVAL      OTEXT4 = SEXT4
     C                   EVAL      OTEXT5 = SEXT5
     C                   EVAL      OTEXT6 = SEXT6
      *
     C                   IF        CFT003 = 'Y'
     C**********         EVAL      OTEXT1 = SEXC1                                           BUG22484
     C**********         EVAL      OTEXT2 = SEXC2                                           BUG22484
     C**********         EVAL      OTEXT3 = SEXC3                                           BUG22484
     C**********         EVAL      OTEXT4 = SEXC4                                           BUG22484
     C**********         EVAL      OTEXT5 = SEXC5                                           BUG22484
     C**********         EVAL      OTEXT6 = SEXC6                                           BUG22484
     C                   EVAL      OTEXC1 = SEXC1                                           BUG22484
     C                   EVAL      OTEXC2 = SEXC2                                           BUG22484
     C                   EVAL      OTEXC3 = SEXC3                                           BUG22484
     C                   EVAL      OTEXC4 = SEXC4                                           BUG22484
     C                   EVAL      OTEXC5 = SEXC5                                           BUG22484
     C                   EVAL      OTEXC6 = SEXC6                                           BUG22484
     C                   ENDIF
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
      ** Initialize the parameters
      *
     C                   EVAL      WSORC1 = SORC1
      *
     C**********         EVAL      PCusno = *ZEROS                                            CER059
     C                   EVAL      PCusno = *BLANKS                                           CER059
     C                   EVAL      PCcy   = *BLANKS
     C                   EVAL      PAccd  = *ZEROS
     C                   EVAL      PAcsq  = *ZEROS
     C                   EVAL      PBrca  = *BLANKS
      *
     C                   SELECT
      *
      ** Retail account (ordering customer)
      *
     C                   WHEN      OTORCT = 'R'
      *
     C                   IF        %SUBST(ORDCST:1:1) = '/'
     C                   MOVEL     ORETS         ACNO
     C                   ELSE
     C                   MOVEL     ORET          ACNO
     C                   ENDIF
      *
     C     ACNO          CHAIN     ACNUMAF
      *
     C                   IF        %FOUND(ACNUMA)
     C**********         EVAL      PCusno = CNUM                                              CER059
     C                   MOVE      CNUM          PCusno                                       CER059
     C                   EVAL      PCcy   = CCY
     C                   EVAL      PAccd  = ACOD
     C                   EVAL      PAcsq  = ACSQ
     C                   EVAL      PBrca  = BRCA
     C                   ENDIF
      *
      ** Partial account identifier
      *
     C                   WHEN      OTORCT = 'P'
      *
     C                   IF        %SUBST(ORDCST:1:1) = '/'
     C                   EVAL      WCusno = ONUMS
     C                   EVAL      PCcy   = SSMCY
     C                   EVAL      WAccd  = OCODS
     C                   EVAL      WAcsq  = OSEQS
     C                   EVAL      PBrca  = OBRCS
      *
     C                   ELSE
      *
     C                   EVAL      WCusno = ONUM
     C                   EVAL      PCcy   = SSMCY
     C                   EVAL      WAccd  = OCOD
     C                   EVAL      WAcsq  = OSEQ
     C                   EVAL      PBrca  = OBRC
      *
     C                   ENDIF
      *
     C                   MOVEL     WCusno        PCusno
     C                   MOVEL     WAccd         PAccd
     C                   MOVEL     WAcsq         PAcsq
      *
      ** IBAN Account
      *
     C                   WHEN      OTORCT = 'I'
      *
     C                   IF        %SUBST(ORDCST:1:1) = '/'
     C                   CALL      'AOIBANR2'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      IBAN2         PIBan
     C     PACCN         PARM      PACCN         DSSDY
      *
     C                   ELSE
      *
     C                   CALL      'AOIBANR2'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      IBAN1         PIBan
     C     PACCN         PARM      PACCN         DSSDY
      *
     C                   ENDIF
      *
     C**********         EVAL      PCusno = IBCNUM                                            CER059
     C                   MOVE      IBCNUM        PCusno                                       CER059
     C                   EVAL      PCcy   = SSMCY
     C                   EVAL      PAccd  = IBACOD
     C                   EVAL      PAcsq  = IBACSQ
     C                   EVAL      PBrca  = IBBRCA
      *
     C                   ENDSL
      *
      ** Call extended narrative validation program
      *
     C                   CALL      'MG001900'
     C                   PARM                    PRtcd
     C                   PARM      '*VALID'      POptn
     C                   PARM                    PNwrk
     C                   PARM                    PMsgTyp
     C                   PARM                    PBrca
     C                   PARM                    PCusno
     C                   PARM                    PCcy
     C                   PARM                    PAccd
     C                   PARM                    PAcsq
     C                   PARM                    PDCin
     C                   PARM                    PRtty
     C                   PARM      SEXT1         PNarr1
     C                   PARM      SEXT2         PNarr2
     C                   PARM      SEXT3         PNarr3
     C                   PARM      SEXT4         PNarr4
     C                   PARM      SEXT5         PNarr5
     C                   PARM      SEXT6         PNarr6
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
     C                   IF        PRtcd = '*ERROR '
      *
     C                   EVAL      WPos = %LOOKUP('ADDI1':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'SEXT1'
     C                   EVAL      OKEXT1 = 'N'
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('ADDI2':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'SEXT2'
     C                   EVAL      OKEXT2 = 'N'
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('ADDI3':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'SEXT3'
     C                   EVAL      OKEXT3 = 'N'
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('ADDI4':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'SEXT4'
     C                   EVAL      OKEXT4 = 'N'
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('ADDI5':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'SEXT5'
     C                   EVAL      OKEXT5 = 'N'
     C                   ENDIF
      *
      *
     C                   EVAL      WPos = %LOOKUP('ADDI6':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'SEXT6'
     C                   EVAL      OKEXT6 = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Store Values temporarily in a work array
      *
     C                   MOVEA     FldNamXAr     WkFldNamAr
     C                   MOVEA     MsgIdXAr      WkMsgIdAr
     C                   MOVEA     MsgDtaXAr     WkMsgDtaAr
      *
      ** Credit Extended narratives
      *
     C                   IF        CFT003 = 'Y'
      *
      ** Initialize the parameters
      *
     C                   EVAL      WSDST1 = SDST1
      *
     C**********         EVAL      PCusno = *ZEROS                                            CER059
     C                   EVAL      PCusno = *BLANKS                                           CER059
     C                   EVAL      PCcy   = *BLANKS
     C                   EVAL      PAccd  = *ZEROS
     C                   EVAL      PAcsq  = *ZEROS
     C                   EVAL      PBrca  = *BLANKS
      *
     C                   SELECT
      *
      ** Retail account
      *
     C                   WHEN      OTDSTT = 'R'
      *
     C                   MOVE      DRET          ACNO
     C     ACNO          CHAIN     ACNUMAF
      *
     C                   IF        %FOUND(ACNUMA)
     C**********         EVAL      PCusno = CNUM                                              CER059
     C                   MOVE      CNUM          PCusno                                       CER059
     C                   EVAL      PCcy   = CCY
     C                   EVAL      PAccd  = ACOD
     C                   EVAL      PAcsq  = ACSQ
     C                   EVAL      PBrca  = BRCA
     C                   ENDIF
      *
      *
      ** Nostro Account
      *
     C                   WHEN      OTDSTT = 'F'
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       P1Rtcd
     C                   PARM      '*KEY   '     P1Optn
     C                   PARM      *BLANKS       P1Cust
     C                   PARM      NCUR          P1Cycd
     C                   PARM      *BLANKS       P1Accd
     C                   PARM      *BLANKS       P1Acsn
     C                   PARM      NNUM          P1Nonb
     C                   PARM      *BLANKS       P1Brca
     C                   PARM      *BLANKS       P1Cssn
     C                   PARM      *BLANKS       P1Pnoi
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   MOVE      A7CUST        PCusno
     C                   MOVE      A7ACCD        PAccd
     C                   MOVE      A7ACSN        PAcsq
     C                   EVAL      PBrca = A7BRCD
     C                   EVAL      PCcy = NCUR
      *
      ** Full Account
      *
     C                   WHEN      OTDSTT = 'G'
     C                   MOVEL     DNUM          PCusno
     C                   EVAL      PCCY = DSCY
     C                   MOVEL     DCOD          PAccd
     C                   MOVEL     DSEQ          PAcsq
     C                   EVAL      PBRCA = DBRC
      *
     C                   ENDSL
      *
      ** Credit narrative validations
      *
     C                   CALL      'MG001900'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VALID'      POptn
     C                   PARM                    PNwrk
     C                   PARM                    PMsgTyp
     C                   PARM                    PBrca
     C                   PARM                    PCusno
     C                   PARM                    PCcy
     C                   PARM                    PAccd
     C                   PARM                    PAcsq
     C                   PARM                    PDCin
     C                   PARM                    PRtty
     C                   PARM      SEXC1         PNarr1
     C                   PARM      SEXC2         PNarr2
     C                   PARM      SEXC3         PNarr3
     C                   PARM      SEXC4         PNarr4
     C                   PARM      SEXC5         PNarr5
     C                   PARM      SEXC6         PNarr6
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
     C                   PARM      *BLANKS       FldNamXAr
     C                   PARM      *BLANKS       MsgIDXAr
     C                   PARM      *BLANKS       MsgDtaXAr
     C                   PARM      *BLANKS       WFldNmXAr
     C                   PARM      *BLANKS       WMsgIDXAr
     C                   PARM      *BLANKS       WMsgDtXAr
      *
     C                   IF        PRtcd  = '*ERROR '
      *
     C                   EVAL      WPos = %LOOKUP('ADDI1':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'SEXC1'
     C                   EVAL      OKEXC1 = 'N'
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('ADDI2':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'SEXC2'
     C                   EVAL      OKEXC2 = 'N'
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('ADDI3':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'SEXC3'
     C                   EVAL      OKEXC3 = 'N'
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('ADDI4':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'SEXC4'
     C                   EVAL      OKEXC4 = 'N'
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('ADDI5':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'SEXC5'
     C                   EVAL      OKEXC5 = 'N'
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('ADDI6':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      FldNamXAr(WPos) = 'SEXC6'
     C                   EVAL      OKEXC6 = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Add errors to the wrk array and move it back Output param
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WkFldNamAr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     FldNamXar     WkFldNamAr(Ix)
     C                   MOVEA     MsgIDXAr      WkMsgIdAr(Ix)
     C                   MOVEA     MsgDtaXAr     WkMsgDtaAr(Ix)
     C                   ENDIF
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
      *
     C                   EVAL      FldNamXAr = WkFldNamAr
     C                   EVAL      MsgIDXAr  = WkMsgIdAr
     C                   EVAL      MsgDtaXAr = WkMsgDtaAr
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
      ** Outgoing Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
      *
     C                   PARM                    TranInPrim
      *
      ** Outgoing Payments Extended Narratives Debit transaction
      ** - screen format
      *
     C                   PARM                    TranInFiftA
      *
      ** Outgoing Payments Extended Narratives Credit transaction
      ** - screen format
      *
     C                   PARM                    TranInFiftB
      *
     C                   PARM                    RespMode
      *
      ** OUTPUT
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Outgoing Payments Margin info error indicators
     C                   PARM                    OKFlagsDS
      *
      ** Outgoing Payments for file update - file format
     C                   PARM                    ValidPmnt
      *
      ** Check if CFT003 is enabled
      *
     C                   EVAL      CFT003 = 'N'
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT003'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CFT003 = 'Y'
     C                   ELSE
      *
     C                   IF        PRtcd <> '*NRF'
      *
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     'CFT003'      DBKEY
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
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
