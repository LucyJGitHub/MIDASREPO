     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Settlement Alloc Mult Read Access Object')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  AOSTALR1 - Settlement Allocations Multiple Read Access Obj   *
      *                                                               *
      *  Function:  This program access all the settlement            *
      *             allocations for a transaction. It will be         *
      *             called in several modes.                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8924            Date 26Sep05               *
      *                 CLE038             Date 13May04               *
      *                 CGL029             Date 01Sep03               *
      *                 222167             Date 14Oct03               *
      *                 218992             Date 10Jul03               *
      *                 CLE034  *CREATE    Date 05May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8924- Incorrect postings for Settlement Allocation when   *
      *           amount is used. Use very long Dummy DS.             *
      *  CLE038 - Lending Enhancement for Nordea: Allocation by Amount*
      *           (Recompiled over changes to LESTALPD).              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222167 - Program always returns a non blank return code.     *
      *  218992 - Check system value Settlement09Postings to decide   *
      *           whether to use Settlement or Transaction Ccy.       *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  01         LOOKUP indicator                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRINIT   - Initialisation Subroutine                         *
      *  SRTXDT   - Telex Notice Date Subroutine                      *
      *  SRSetCMT - Settlement Currency and Method Subroutine         *
      *  SRSetCcy - Settlement Currency Subroutine                    *
      *  SRCURR   - Currency Subroutine                               *
      *  SRNOST   - Nostro Subroutine                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
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
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D WConst          C                   'Settlement09Postings'                             218992
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ACI             S              1A   DIM(150)
 
     D ACT             S              1  0 DIM(150)
 
     D ACY             S              3A   DIM(150)
 
      ** Midas SC Switchable features description
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Midas SD Currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Midas SD General ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Midas SD Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Midas LE Settlement Allocation by transaction
     D SDSTAL        E DS                  EXTNAME(LESTALPD)
 
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Secondt DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                             BUG8924
      ** Third DS for Access programs - very long data structure                             BUG8924
     D DSLDY         E DS                  EXTNAME(DSLDY)                                    BUG8924
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CEU004          S              1
     D CLE031          S              1
     D Idx             S              3  0
     D NIdx            S              3  0
     D PAccCode        S              4
     D PAccSeq         S              2
     D PBranch         S              3
     D PCcy            S              3
     D PCust           S              6
     D PCustFee        S              6
     D PCustShrtNm     S             10
     D PDay            S              5P 0
     D PFeeSeq         S              2
     D PFcltyFee       S              5
     D PKey            S              3
     D PLASN           S              3
     D PLAVD           S              5
     D PLoanRef        S              6
     D PNostChk        S              1
     D PNost           S              2
     D PNostro         S              1
     D POption         S              7
     D POptn           S              7
     D PPNostro        S              1
     D PProcType       S              2  0
     D PRtnCode        S              7
     D PSard           S              6
     D PSequence       S              5
     D PStMtInd        S              1
     D PTNODT          S              5P 0
     D PTransCcy       S              3
     D PType           S              4
     D WCheck          S              1
     D WInCcyInd       S              1
     D WNOSN           S              3
     D WPayRec         S              1
     D WrkCcy          S              3A
     D WrkLoc          S              3
     D WSetCcy         S              3
     D WSetMtd         S              1
     D WSInCcyInd      S              1
     D WSvTNODT        S              5P 0
     D WTInCcyInd      S              1
     D WTXND           S              1  0
     D ZCCY            S              3
     D ZDAYNO          S              5  0
     D ZDYNBR          S              5  0
     D ZLOC            S              3
     D ZNRDYS          S              2  0
     D CLE033          S              1                                                       218992
     D Setl09          S              1A                                                      218992
                                                                                              218992
      ** Access Object Parameters                                                             218992
     D PRetCode        S              7A                                                      218992
     D PSysValK1       S             20A                                                      218992
     D PSysVal1        S            200A                                                      218992
     D PSysValK2       S             20A                                                      218992
     D PSysVal2        S            200A                                                      218992
     D PSysValK3       S             20A                                                      218992
     D PSysVal3        S            200A                                                      218992
     D PSysValK4       S             20A                                                      218992
     D PSysVal4        S            200A                                                      218992
     D PSysValK5       S             20A                                                      218992
     D PSysVal5        S            200A                                                      218992
     D PSysValK6       S             20A                                                      218992
     D PSysVal6        S            200A                                                      218992
     D PSysValK7       S             20A                                                      218992
     D PSysVal7        S            200A                                                      218992
     D PSysValK8       S             20A                                                      218992
     D PSysVal8        S            200A                                                      218992
     D PSysValK9       S             20A                                                      218992
     D PSysVal9        S            200A                                                      218992
     D PSysValK10      S             20A                                                      218992
     D PSysVal10       S            200A                                                      218992
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialisation
 
     C                   EXSR      SRINIT
 
     C                   IF        POption = '*TXDT  '
     C                   EXSR      SRTXDT
     C                   ENDIF
 
     C                   IF        POption = '*NOSTRO'
     C                   EXSR      SRNOST
     C                   ENDIF
 
     C*************      IF        POption <> '*TXDT  ' OR POption <> '*NOSTRO'               222167
     C                   IF        POption <> '*TXDT  ' AND POption <> '*NOSTRO'              222167
     C                   EVAL      PRtnCode = '*OPTION'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTXDT -  Telex Notice Date Subroutine                       *
      *                                                               *
      *****************************************************************
     C     SRTXDT        BEGSR
 
     C                   EVAL      WSvTNODT = *ZEROS
 
     C                   IF        PStMtInd = 'S'
 
     C                   IF        PProcType <> 66 AND PProcType <> 67
     C                             AND PProcType <> 69 AND PProcType <> 72
     C                   EVAL      WPayRec = 'P'
     C                   ELSE
     C                   EVAL      WPayRec = 'R'
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        PStMtInd = 'E'
 
     C                   IF        PProcType <> 66 AND PProcType <> 67
     C                             AND PProcType <> 69 AND PProcType <> 72
     C                   EVAL      WPayRec = 'R'
     C                   ELSE
     C                   EVAL      WPayRec = 'P'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   CALL      'AOSTALR3'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*FIRST'      POptn
     C                   PARM                    PType
     C                   PARM                    PLoanRef
     C                   PARM                    PLAVD
     C                   PARM                    PLASN
     C                   PARM                    PCustFee
     C                   PARM                    PFcltyFee
     C                   PARM                    PFeeSeq
     C                   PARM      *BLANKS       PSequence
     C*****SDSTAL        PARM      *BLANKS       DSSDY                                       BUG8924
     C     SDSTAL        PARM      *BLANKS       DSLDY                                       BUG8924
 
     C                   IF        PRtnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'LESTALPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   DOW       PRtnCode = *BLANKS
     C                   EVAL      WCheck = *BLANKS
     C                   IF        PNostChk = 'Y'
     C                   IF        WPayRec = 'R'
     C                   IF        RSTM = '01' OR RSTM = '07' OR RSTM = '08'
     C                   EVAL      WCheck = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        WPayRec = 'P'
     C                   IF        PSTM = '01' OR PSTM = '07' OR PSTM = '08'
     C                   EVAL      WCheck = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        WCheck = 'Y'
     C                   EVAL      PNostro = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WCheck = 'Y'
     C                   ENDIF
 
     C                   IF        WCheck = 'Y'
     C                   EXSR      SRSetCMT
     C                   EVAL      WrkLoc = *BLANKS
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C                   PARM      WSetCcy       PCcy
     C                   PARM                    PAccCode
     C                   PARM                    PAccSeq
     C                   PARM      WSetMtd       PNostro
     C                   PARM                    PBranch
     C                   PARM                    PCustShrtNm
     C                   PARM                    PPNostro
     C     SDNOST        PARM      SDNOST        DSSDY
     C                   EVAL      WrkLoc = *BLANKS
     C                   IF        PRtnCode = *BLANKS
     C                   MOVE      A7NOSN        WNOSN
     C                   EVAL      WrkLoc = WNOSN
     C                   ENDIF
     C                   EVAL      WTXND  = ZNRDYS
     C                   EVAL      WrkLoc = ZLOC
     C                   EVAL      WSetCcy = ZCCY
     C                   CALL      'ZFWDT'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZNRDYS
     C                   PARM                    ZDYNBR
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   IF        ZDYNBR > WSvTNODT
     C                   EVAL      WSvTNODT = ZDYNBR
     C                   ENDIF
     C                   ENDIF
     C                   CALL      'AOSTALR3'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*NEXT'       POptn
     C                   PARM                    PType
     C                   PARM                    PLoanRef
     C                   PARM                    PLAVD
     C                   PARM                    PLASN
     C                   PARM                    PCustFee
     C                   PARM                    PFcltyFee
     C                   PARM                    PFeeSeq
     C                   PARM      *BLANKS       PSequence
     C*****SDSTAL        PARM      *BLANKS       DSSDY                                       BUG8924
     C     SDSTAL        PARM      *BLANKS       DSLDY                                       BUG8924
     C                   ENDDO
     C                   EVAL      PTNODT = WSvTNODT
     C     PRtnCode      IFEQ      '*EOF   '                                                  222167
     C                   MOVEL     *BLANKS       PRtnCode                                     222167
     C                   ENDIF                                                                222167
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetCMT - Settlement Currency and Method Subroutine         *
      *                                                               *
      *****************************************************************
     C     SRSetCMT      BEGSR
     C                   IF        WPayRec = 'R'
     C                   EVAL      WSetMtd = RSTM
     C                   ELSE
     C                   EVAL      WSetMtd = PSTM
     C                   ENDIF
 
     C                   EVAL      WSetCcy = PTransCcy
 
     C                   IF        CLE033 = 'Y' AND WSetMtd = '09'                            218782
     C                             AND Setl09 ='T'                                            218782
     C                   ELSE                                                                 218992
     C                   IF        CEU004 = *ON
     C***********        IF        CLE031 = *OFF                                              222167
     C                   IF        CLE031 = 'N'                                               222167
     C                   IF        RSCY <> *BLANKS
     C                   EVAL      WSetCcy = RSCY
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WrkCcy = PTransCcy
     C                   EXSR      SRCURR
     C                   EVAL      WTInCcyInd = WInCcyInd
     C                   EVAL      WrkCcy = *BLANKS
     C                   EXSR      SRSetCcy
     C                   IF        WrkCcy <> *BLANKS
     C                   EXSR      SRCURR
     C                   EVAL      WSInCcyInd = WInCcyInd
     C                   IF        WSInCcyInd = 'Y'
     C                             OR WrkCcy = BKEURO AND WTInCcyInd = 'Y'
     C                   IF        RSCY <> *BLANKS
     C                   EVAL      WSetCcy = RSCY
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WSetCcy = WrkCcy
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C***********        IF        CLE031 = *ON                                               222167
     C                   IF        CLE031 = 'Y'                                               222167
     C                   EXSR      SRSetCcy
     C                   IF        WrkCcy <> *BLANKS
     C                   EVAL      WSetCcy = WrkCcy
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                218992
 
     C                   EVAL      WrkCcy = WSetCcy
     C                   EXSR      SRCURR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetCcy - Settlement Currency Subroutine                    *
      *                                                               *
      *****************************************************************
     C     SRSetCcy      BEGSR
 
     C                   IF        WPayRec = 'R' AND RSCY <> *BLANKS
     C                   EVAL      WrkCcy = RSCY
     C                   ENDIF
 
     C                   IF        WPayRec = 'P' AND PSCY <> *BLANKS
     C                   EVAL      WrkCcy = PSCY
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCURR - Currency Subroutine                                 *
      *                                                               *
      *****************************************************************
     C     SRCURR        BEGSR
 
     C                   EVAL      Idx = 1
 
     C************       DOW       Idx <= 60                                                  222167
     C     WrkCcy        LOOKUP    ACY(Idx)                               01
     C                   IF        *IN01 = *ON
     C                   EVAL      WInCcyInd = ACI(Idx)
     C                   MOVE      ACT(Idx)      WTXND
     C                   ELSE
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WrkCcy        PKey
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      NIdx = NIdx + 1
     C                   EVAL      ACY(NIDx) = A6CYCD
     C                   EVAL      ACI(NIDx) = A6INCY
     C                   MOVE      A6TXND        ACT(NIDx)
     C                   EVAL      WInCcyInd = A6INCY
     C                   EVAL      WTXND = A6TXND
     C                   ENDIF
 
     C                   ENDIF
 
     C*************      EVAL      Idx = Idx + 1                                              222167
     C*************      ENDDO                                                                222167
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNOST - Nostro Subroutine                                   *
      *                                                               *
      *****************************************************************
     C     SRNOST        BEGSR
 
     C                   EVAL      PNostro = *BLANKS
     C                   IF        PStMtInd = 'S'
     C                   IF        PProcType <> 66 AND PProcType <> 67
     C                             AND PProcType <> 69 AND PProcType <> 72
     C                   EVAL      WPayRec = 'P'
     C                   ELSE
     C                   EVAL      WPayRec = 'R'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PStMtInd = 'E'
     C                   IF        PProcType = 66 AND PProcType = 67
     C                             AND PProcType = 69 AND PProcType = 72
     C                   EVAL      WPayRec = 'R'
     C                   ELSE
     C                   EVAL      WPayRec = 'P'
     C                   ENDIF
     C                   ENDIF
 
     C                   CALL      'AOSTALR3'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*FIRST'      POptn
     C                   PARM                    PType
     C                   PARM                    PLoanRef
     C                   PARM                    PLAVD
     C                   PARM                    PLASN
     C                   PARM                    PCustFee
     C                   PARM                    PFcltyFee
     C                   PARM                    PFeeSeq
     C                   PARM      *BLANKS       PSequence
     C*****SDSTAL        PARM      *BLANKS       DSSDY                                       BUG8924
     C     SDSTAL        PARM      *BLANKS       DSLDY                                       BUG8924
 
     C                   IF        PRtnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'LESTALPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   DOW       PRtnCode = *BLANKS AND PNostro = *BLANKS
     C                   IF        WPayRec = 'R'
     C                   IF        RSTM = '01' OR RSTM = '07' OR RSTM = '08'
     C                   EVAL      PNost = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        WPayRec = 'P'
     C                   IF        PSTM = '01' OR PSTM = '07' OR PSTM = '08'
     C                   EVAL      PNost = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   CALL      'AOSTALR3'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*NEXT'       POptn
     C                   PARM                    PType
     C                   PARM                    PLoanRef
     C                   PARM                    PLAVD
     C                   PARM                    PLASN
     C                   PARM                    PCustFee
     C                   PARM                    PFcltyFee
     C                   PARM                    PFeeSeq
     C                   PARM      *BLANKS       PSequence
     C*****SDSTAL        PARM      *BLANKS       DSSDY                                       BUG8924
     C     SDSTAL        PARM      *BLANKS       DSLDY                                       BUG8924
     C                   ENDDO
     C     PRtnCode      IFEQ      '*EOF   '                                                  222167
     C                   MOVEL     *BLANKS       PRtnCode                                     222167
     C                   ENDIF                                                                222167
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation Subroutine                           *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRtnCode
     C                   PARM                    POption
     C                   PARM                    PDay
     C                   PARM                    PProcType
     C                   PARM                    PStMtInd
     C                   PARM                    PTransCcy
     C                   PARM                    PNostChk
     C                   PARM                    PType
     C                   PARM                    PLoanRef
     C                   PARM                    PLAVD
     C                   PARM                    PLASN
     C                   PARM                    PCustFee
     C                   PARM                    PFcltyFee
     C                   PARM                    PFeeSeq
     C                   PARM                    PTNODT
     C                   PARM                    PNostro
 
      ** Access AOSARDR0 to check if EMU Settlement Ccy conversion
      ** switchable feature is switched on
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU004'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   EVAL      CEU004 = 'N'
     C                   IF        PRtnCode = *BLANKS
     C                   EVAL      CEU004 = 'Y'
     C                   ELSE
      *
     C                   IF        PRtnCode <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CEU004'
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Access AOSARDR0 to check if Enhancements for Head Offices
      ** switchable feature is switched on
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CLE031'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   EVAL      CLE031 = 'N'
     C                   IF        PRtnCode = *BLANKS
     C                   EVAL      CLE031 = 'Y'
     C                   ELSE
      *
     C                   IF        PRtnCode <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CLE031'
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
                                                                                              218992
      ** Access AOSARDR0 to check if Enhancements for Head Offices                            218992
      ** switchable feature is switched on                                                    218992
                                                                                              218992
     C                   CALL      'AOSARDR0'                                                 218992
     C                   PARM      *BLANKS       PRtnCode                                     218992
     C                   PARM      '*VERIFY'     POptn                                        218992
     C                   PARM      'CLE033'      PSard                                        218992
     C     SCSARD        PARM      SCSARD        DSFDY                                        218992
                                                                                              218992
     C                   EVAL      CLE033 = 'N'                                               218992
     C                   IF        PRtnCode = *BLANKS                                         218992
     C                   EVAL      CLE033 = 'Y'                                               218992
      *                                                                                       218992
     C                   EVAL      PSysValK1 = WConst                                         218992
     C                   CALL      'AOSVALR0'                                                 218992
     C                   PARM      *BLANKS       PRetCode                                     218992
     C                   PARM                    PSysValK1                                    218992
     C                   PARM                    PSysVal1                                     218992
     C                   PARM                    PSysValK2                                    218992
     C                   PARM                    PSysVal2                                     218992
     C                   PARM                    PSysValK3                                    218992
     C                   PARM                    PSysVal3                                     218992
     C                   PARM                    PSysValK4                                    218992
     C                   PARM                    PSysVal4                                     218992
     C                   PARM                    PSysValK5                                    218992
     C                   PARM                    PSysVal5                                     218992
     C                   PARM                    PSysValK6                                    218992
     C                   PARM                    PSysVal6                                     218992
     C                   PARM                    PSysValK7                                    218992
     C                   PARM                    PSysVal7                                     218992
     C                   PARM                    PSysValK8                                    218992
     C                   PARM                    PSysVal8                                     218992
     C                   PARM                    PSysValK9                                    218992
     C                   PARM                    PSysVal9                                     218992
     C                   PARM                    PSysValK10                                   218992
     C                   PARM                    PSysVal10                                    218992
      *                                                                                       218992
     C                   IF        PRetCode <> *BLANKS                                        218992
     C     *LOCK         IN        LDA                                                        218992
     C                   EVAL      DBFILE =  'SDSVALJ0'                                       218992
     C                   EVAL      DBKEY  =  PSysValK1                                        218992
     C                   EVAL      DBASE  =  6                                                218992
     C                   OUT       LDA                                                        218992
     C                   EXSR      *PSSR                                                      218992
     C                   ENDIF                                                                218992
      *                                                                                       218992
      ** Save value of Settlement09Postings in a one character field                          218992
     C                   EVAL      Setl09 = PSysVal1                                          218992
     C                   ELSE                                                                 218992
      *                                                                                       218992
     C                   IF        PRtnCode <> '*NRF'                                         218992
     C     *LOCK         IN        LDA                                                        218992
     C                   EVAL      DBFILE = 'SCSARDPD'                                        218992
     C                   EVAL      DBKEY = 'CLE033'                                           218992
     C                   EVAL      DBASE = 7                                                  218992
     C                   OUT       LDA                                                        218992
     C                   EXSR      *PSSR                                                      218992
     C                   ENDIF                                                                218992
                                                                                              218992
     C                   ENDIF                                                                218992
     C                   Z-ADD     0             NIdx                                         222167
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
