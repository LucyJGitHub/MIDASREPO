     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE PDCL Repayments - extract LEACCFPD - Fees')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE007052 - Past Due Call Loans Repayments - Extract late fees*
      *            to LEACCFPD                                        *
      *                                                               *
      *  This function extracts late fees (FECALT = '90') whose loan  *
      *  has repayment today and is linked to a Past Due Call Loan    *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE164             Date 18Aug14               *
      *                 AR1056323          Date 14Nov12               *
      *                 AR1022006          Date 01Aug12               *
      *                 AR217562           Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  AR1056323 - Revert back changes of CLE134 for LKEY1DP and    *
      *              LKEYFED (Recompile)                              *
      *  AR1022006 - COB Performance Optimisation                     *
      *  AR217562 - Incorrect Repayment methodology                   *
      *             (Child: AR217563)                                 *
      *  CLE134 - Past Due Call Loans process                         *
      *                                                               *
      *****************************************************************
     F/SPACE
      *****************************************************************
     F***LEFEED*   IF   E           K DISK    INFSR(*PSSR)                                 AR1022006
     FLEFEEDLV  IF   E           K DISK    INFSR(*PSSR)                                    AR1022006
     FACCNTL1   IF   E           K DISK    INFSR(*PSSR) PREFIX(ac)
 
     F***LEACCNL6  IF   E           K DISK    INFSR(*PSSR)                                    CLE164
     F**********                           PREFIX(r_)                                         CLE164
 
     FLEACCFL3  IF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(p_)
 
     FLEPDUEL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L_)
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L_)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     FLEPK1L0   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L_)
      *****************************************************************
     D/EJECT
      *****************************************************************
 
      ** Key Fields.
 
     D DSIntDue        S             15  0 INZ
     D DSRpyAmt        S             15  0 INZ
 
     D KacACNO         S                   INZ LIKE(acACNO)
 
     D*KRPBRCA**       S                   INZ LIKE(r_RPBRCA)                                 CLE164
     D*KRPACCY**       S                   INZ LIKE(r_RPACCY)                                 CLE164
     D*KRPCNUM**       S                   INZ LIKE(r_RPCNUM)                                 CLE164
     D*KRPACOD**       S                   INZ LIKE(r_RPACOD)                                 CLE164
     D*KRPACSQ**       S                   INZ LIKE(r_RPACSQ)                                 CLE164
     D*KRPLNRF**       S                   INZ LIKE(r_RPLNRF)                                 CLE164
     D*KRPFCNM**       S                   INZ LIKE(r_RPFCNM)                                 CLE164
     D*KRPFLNR**       S                   INZ LIKE(r_RPFLNR)                                 CLE164
     D*KRPFACT**       S                   INZ LIKE(r_RPFACT)                                 CLE164
     D*KRPFSE1**       S                   INZ LIKE(r_RPFSE1)                                 CLE164
     D*KRPFCOD**       S                   INZ LIKE(r_RPFCOD)                                 CLE164
     D*KRPFCBR**       S                   INZ LIKE(r_RPFCBR)                                 CLE164
     D KRPBRCA         S              3A                                                      CLE164
     D KRPACCY         S              3A                                                      CLE164
     D KRPCNUM         S              6A                                                      CLE164
     D KRPACOD         S             10S 0                                                    CLE164
     D KRPACSQ         S              2S 0                                                    CLE164
     D KRPLNRF         S              6A                                                      CLE164
     D KRPFCNM         S              6A                                                      CLE164
     D KRPFLNR         S              6A                                                      CLE164
     D KRPFACT         S              5S 0                                                    CLE164
     D KRPFSE1         S              2S 0                                                    CLE164
     D KRPFCOD         S              2S 0                                                    CLE164
     D KRPFCBR         S              3A                                                      CLE164
     D pRTCD           S              7A                                                      CLE164
     D pCATC           S              5A                                                      CLE164
     D pFILE           S             10A                                                      CLE164
     D pLOAN           S              6A                                                      CLE164
     D pBRCH           S              3A                                                      CLE164
     D pCUST           S              6A                                                      CLE164
     D pFCLT           S              5S 0                                                    CLE164
     D pFESQ           S              2S 0                                                    CLE164
     D pREPR           S              8S 0                                                    CLE164
     D pCAPR           S              8S 0                                                    CLE164
     D pOVFL           S              1A                                                      CLE164
 
      ** Passed Parameters.
 
      ** Overlays.
 
     D                 DS
 
      ** External Definitions.
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,PROCPARMS
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Short data structure for access objects.
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Long data structure for access objects.
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD2       E                     EXTFLD(QQACCD)
 
      ** Nostro details
 
      ** Additional Field Definitions
     D WLoan           S              6
     D Wtype           S              1
     D WPDCL           S              1
     D WSkip           S              1
     D CLE005          S              1
     D KCNUM           S              6
     D KCCY            S              3
     D KEYC1           S             10
     D KEYD            S              2
     D KNONB           S              2
     D KEYF            S              3
     D KEYG            S             10
     D KEYH            S              1
 
      *****************************************************************
     C/EJECT
 
      ** Main Processing Control
 
      ** Retrieve & Process Past Due Call Loan Details.
 
     C**********         READ(E)   LEFEED                                                  AR1022006
     C                   READ(E)   LEFEEDLV                                                AR1022006
     C
     C**********         DOW       NOT %EOF(LEFEED)                                        AR1022006
     C                   DOW       NOT %EOF(LEFEEDLV)                                      AR1022006
 
     C                   EVAL      Wskip = 'N'
 
      ***select*only*late*fees*****************************************                    AR1022006
 
 
      ** check if loan has a Past Due Call Loan and has a repayment
      ** due today
 
     C                   EXSR      SRPDCL
 
      ** Retrieve Fee Settlement account
 
     C                   EXSR      SRAccnF
 
      ** Output record to LEACCFPD
 
     C                   IF        Wskip <> 'Y'
     C                   EXSR      SRWrite
     C                   ENDIF
     C
     C**********         READ(E)   LEFEED                                                  AR1022006
     C                   READ(E)   LEFEEDLV                                                AR1022006
     C                   ENDDO
     C
     C                   MOVE      *On           *INLR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  SRPDCL: Check if Loan has a Past Due Call Loan               *
      *                                                               *
      *****************************************************************
     C     SRPDCL        BEGSR
 
     C                   MOVE      FELOAN        WLoan
 
      ** Check if Loan is a PDCL
 
     C                   MOVEL     FELTYP        Wtype
     C                   MOVE      'N'           WPDCL
     C                   IF        WType    = 'X'
     C                             or Wtype = 'Y'
     C                             or Wtype = 'Z'
     C                   EVAL      WPDCL = 'Y'
     C                   ENDIF
 
      ** if Loan is not a PDCL, then access LEPDUEL2 by Original Loan
 
     C                   IF        WPDCL  <>'Y'
     C     FELOAN        CHAIN(E)  LEPDUEL2
 
     C                   IF        NOT %FOUND(LEPDUEL2)
     C                   MOVE      'Y'           WSkip
     C                   ELSE
     C                   EVAL      Wloan = L_YPLON
     C                   ENDIF
     C                   ENDIF
 
      ** if loan is a PDCL, skip fee if both next payment date and last
      ** payment date are not equal run date.
 
     C                   IF        WPDCL  = 'Y'   and FENPYD <> Bjrdnb
     C                             and FELPDT <> Bjrdnb
     C                   MOVE      'Y'           WSkip
     C                   ENDIF
 
      ** if Wskip is not Y, then access CLOANCL by PDCL nr
 
     C                   IF        WSkip <> 'Y'
     C     WLoan         CHAIN(E)  CLOAN
     C                   IF        NOT %FOUND(CLOAN)
     C                   MOVE      'Y'           WSkip
     C                   ELSE
 
      ** if CPAM is zero, then do not output late fee
 
     C                   IF        L_CPAM = 0
     C                   MOVE      'Y'           WSkip
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check if Loan has a repayment due today
 
     C                   IF        Wskip = 'N' and WPDCL = 'N'
     C                   EVAL      Wskip = 'Y'
     C     FELOAN        SETLL     LEPK1L0
     C     FELOAN        READE     LEPK1L0
     C                   DOW       NOT %EOF(LEPK1L0)
     C                   IF        L_EAMT >0 AND L_REVI = 0
     C                   EVAL      Wskip = 'N'
     C                   LEAVE
     C                   ENDIF
     C     FELOAN        READE     LEPK1L0
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRAccnF: Retrieve Settlement account                         *
      *                                                               *
      *****************************************************************
     C     SRAccnF       BEGSR
 
      ** Initialisation.
 
     C                   IF        Wskip <> 'Y'
 
     C                   EVAL      KRPCNUM     = *BLANKS
     C                   EVAL      KRPACOD     = 0
     C                   EVAL      KRPACSQ     = 0
     C                   EVAL      KRPBRCA     = *BLANKS
     C                   EVAL      KRPACCY     = *BLANKS
 
     C                   EVAL      KRPFCNM     = FECNUM
     C                   EVAL      KRPFLNR     = FELOAN
     C                   EVAL      KRPFACT     = FEFACL
     C                   EVAL      KRPFSE1     = FEFSEQ
     C                   EVAL      KRPFCOD     = FEFCOD
     C                   EVAL      KRPFCBR     = FEBRCA
 
      ** Set Key from Payable.
 
     C                   IF        PTFI       <> *BLANKS
     C                   SELECT
     C                   WHEN      PSTM        = 01            OR
     C                             PSTM        = 08
     C                   EVAL      KCCY        = FEFCCY
     C                   EVAL      KNONB       = %SUBST(PONS:01:02)
     C                   EVAL      KCNUM       = *BLANKS
     C                   CALL      'AONOSTR0'    PLIST1
 
     C                   IF        @RTCD       = *BLANKS
     C                   EVAL      KRPCNUM     = A7CUST
     C                   EVAL      KRPACOD     = %DEC(A7ACCD:10:0)
     C                   EVAL      KRPACSQ     = A7ACSN
     C                   EVAL      KRPBRCA     = A7BRCD
     C                   EVAL      KRPACCY     = FEFCCY
     C                   ENDIF
 
     C                   WHEN      PSTM        = 05
     C                   EVAL      KRPCNUM     = %SUBST(PONS:01:06)
     C                   EVAL      KRPACOD = %DEC(%SUBST
     C                                       (PONS:07:10):10:0)
     C                   EVAL      KRPACSQ = %DEC(%SUBST
     C                                       (PONS:17:02):02:0)
     C                   EVAL      KRPBRCA     = OMDB
     C                   EVAL      KRPACCY     = FEFCCY
 
     C                   WHEN      PSTM        = 14
     C                   MOVEL     PONS          KacACNO
     C     KACCNTL1      CHAIN(E)  ACCNTL1
 
     C                   IF        %FOUND(ACCNTL1)
     C                   EVAL      KRPCNUM     = acCNUM
     C                   EVAL      KRPACOD     = acACOD
     C                   EVAL      KRPACSQ     = acACSQ
     C                   EVAL      KRPBRCA     = acBRCA
     C                   EVAL      KRPACCY     = acCCY
     C                   ENDIF
 
     C                   WHEN      PSTM        = 0             AND
     C                             PONS        = *BLANKS
 
     C                   EVAL      Wskip = 'Y'
 
     C                   ENDSL
 
      ** Set Key From Receivable.
 
     C                   ELSE
     C                   SELECT
     C                   WHEN      RSTM        = 01            OR
     C                             RSTM        = 08
     C                   EVAL      KCCY        = FEFCCY
     C                   EVAL      KNONB       = %SUBST(RONS:01:02)
     C                   EVAL      KCNUM       = *BLANKS
     C                   CALL      'AONOSTR0'    PLIST1
 
     C                   IF        @RTCD       = *BLANKS
     C                   EVAL      KRPCNUM     = A7CUST
     C                   EVAL      KRPACOD     = %DEC(A7ACCD:10:0)
     C                   EVAL      KRPACSQ     = A7ACSN
     C                   EVAL      KRPBRCA     = A7BRCD
     C                   EVAL      KRPACCY     = A7CYCD
     C                   ENDIF
 
     C                   WHEN      RSTM        = 05
     C                   EVAL      KRPCNUM     = %SUBST(RONS:01:06)
     C                   EVAL      KRPACOD     = %DEC(%SUBST
     C                                           (RONS:07:10):10:0)
     C                   EVAL      KRPACSQ     = %DEC(%SUBST
     C                                           (RONS:17:02):02:0)
     C                   EVAL      KRPBRCA     = OSDB
     C                   EVAL      KRPACCY     = FEFCCY
 
     C                   WHEN      RSTM        = 14
     C                   MOVEL     RONS          KacACNO
     C     KACCNTL1      CHAIN(E)  ACCNTL1
 
     C                   IF        %FOUND(ACCNTL1)
     C                   EVAL      KRPCNUM     = acCNUM
     C                   EVAL      KRPACOD     = acACOD
     C                   EVAL      KRPACSQ     = acACSQ
     C                   EVAL      KRPBRCA     = acBRCA
     C                   EVAL      KRPACCY     = acCCY
     C                   ENDIF
 
     C                   WHEN      RSTM        = 0             AND
     C                             RONS        = *BLANKS
 
     C                   EVAL      Wskip = 'Y'
 
     C                   ENDSL
     C                   ENDIF
      *****************************************************************                       CLE164
      ***check*if*Loan*has*a*PDCL**************************************                       CLE164
      ***Retrieve*Repayment*Priority.**********************************                       CLE164
      *****************************************************************                       CLE164
     C**********         EVAL      R_RPPCKO = 99999                                           CLE164
     C*****KLEACCNL6     CHAIN(E)  LEACCNL6                                                   CLE164
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite: Write record to work file LEACCFPD                  *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR
 
      ** output to LEACCFPD
 
     C                   EVAL      p_SERECI = 'D'
     C                   EVAL      p_SEBRCA = KRPBRCA
     C                   EVAL      p_SEACCY = KRPACCY
     C                   EVAL      p_SECNUM = KRPCNUM
     C                   EVAL      p_SEACOD = KRPACOD
     C                   EVAL      p_SEACSQ = KRPACSQ
     C                   EVAL      p_SELNRF = FELOAN
     C                   EVAL      p_SEFBRA = FEBRCA
     C                   EVAL      p_SEFCUS = FECNUM
     C                   EVAL      p_SEFCOD = FEFCOD
     C                   EVAL      p_SEFSEQ = FEFSEQ
     C                   EVAL      p_SEVDAT = FEPSTD
     C                   EVAL      p_SELTYP = FELTYP
     C                   EVAL      p_SESUTP = FESUTP
     C                   MOVE      FELTYP        P_SELTY1
     C**********         EVAL      p_SEPCKO = R_RPPCKO                                        CLE164
     C**********         EVAL      P_SEPCKM = 100                                             CLE164
     C                   EVAL      p_SEPRAM    = FEFAMT
     C                   EVAL      p_SEINTA    = 0
     C                   EVAL      p_SETAMT    = FEFAMT
     C                   EVAL      p_SEAAMT    = 0
     C                   EVAL      p_SEIPFL    = *blanks
     C                   EVAL      p_SEFILE    = 'F4'
     C**********         EVAL      P_SEPCKT = 100                                             CLE164
     C                   EVAL      P_SECATC = 'Fee90'                                         CLE164
     C                   EVAL      P_SEFILE = 'LEACCFPD'                                      CLE164
     C                   EVAL      P_SEOVRD = 0                                               CLE164
     C                   EVAL      P_SETRID = P_SETRID + 1                                    CLE164
     C                   EVAL      P_SESDAT = FEPSTD                                          CLE164
     C                   EVAL      P_SEMDAT = FEPEND                                          CLE164
     C                   EVAL      P_SEVDPD = 0                                               CLE164
     C                   EVAL      P_SEVDPY = FEPSTD                                          CLE164
     C                   EVAL      P_SEPAMT = FEFAMT                                          CLE164
     C                   EVAL      P_SETMST = STMP                                            CLE164
     C                   IF        FELOAN = *BLANKS                                           CLE164
     C                   EVAL      P_SETREF = %EDITC(FEFACL:'X') +                            CLE164
     C                                        %EDITC(FEFCOD:'X') +                            CLE164
     C                                        %EDITC(FEFSEQ:'X')                              CLE164
     C                   ELSE                                                                 CLE164
     C                   EVAL      P_SETREF = FELOAN +                                        CLE164
     C                                        %EDITC(FEFCOD:'X') +                            CLE164
     C                                        %EDITC(FEFSEQ:'X')                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   EXSR      SRRETRPKY                                                  CLE164
 
      ** Output LEACCFPD
 
     C                   WRITE     LEACCFD0
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * *INZSR - Initial processing                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   ELSE
     C                   MOVE      'N'           CLE005
     C                   ENDIF
 
      ** Access  bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RTCD      <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE      = 'SDBANKPD'
     C                   EVAL      DBKEY       = '*FIRST'
     C                   EVAL      DBASE       = 021
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CLE164
     C                   EVAL      P_SETRID = 0                                               CLE164
 
     C                   ENDSR
 
     C/EJECT
      *****************************************************************
      *                                                               *
      *  @DEFN: Definition Rountine.                                  *
      *                                                               *
      *****************************************************************
     C/SPACE
     C     @DEFN         BEGSR
 
      ** Key List...
 
     C     KACCNTL1      KLIST
     C                   KFLD                    KacACNO
 
     C*****KLEACCNL6     KLIST                                                                CLE164
     C**********         KFLD                    KRPFCNM                                      CLE164
     C**********         KFLD                    KRPFLNR                                      CLE164
     C**********         KFLD                    KRPFACT                                      CLE164
     C**********         KFLD                    KRPFSE1                                      CLE164
     C**********         KFLD                    KRPFCOD                                      CLE164
     C**********         KFLD                    KRPFCBR                                      CLE164
 
      ** Parameter List...
 
     C     P@NOSTR0      PLIST
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    KCNUM
     C                   PARM                    KCCY
     C                   PARM                    KEYC1
     C                   PARM                    KEYD
     C                   PARM                    KNONB
     C                   PARM                    KEYF
     C                   PARM                    KEYG
     C                   PARM                    KEYH
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C     PLIST1        PLIST
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    KCNUM
     C                   PARM                    KCCY
     C                   PARM                    KEYC1
     C                   PARM                    KEYD
     C                   PARM                    KNONB
     C                   PARM                    KEYF
     C                   PARM                    KEYG
     C                   PARM                    KEYH
     C     SDNOST        PARM      SDNOST        DSFDY
      *****************************************************************
     C                   ENDSR
      *****************************************************************                       CLE164
      *    SRRETRPKY - Retrieve LEACCTPD Repayment Priorities         *                       CLE164
      *****************************************************************                       CLE164
     C     SRRETRPKY     BEGSR                                                                CLE164
                                                                                              CLE164
     C                   CALL      'LE000801'                                                 CLE164
     C                   PARM      *BLANK        PRTCD                                        CLE164
     C                   PARM      P_SECATC      PCATC                                        CLE164
     C                   PARM      'LEFEEZTD'    PFILE                                        CLE164
     C                   PARM      FELOAN        PLOAN                                        CLE164
     C                   PARM      FEBRCA        PBRCH                                        CLE164
     C                   PARM      FECNUM        PCUST                                        CLE164
     C                   PARM      FEFACL        PFCLT                                        CLE164
     C                   PARM      FEFSEQ        PFESQ                                        CLE164
     C                   PARM      *ZEROS        PREPR                                        CLE164
     C                   PARM      *ZEROS        PCAPR                                        CLE164
     C                   PARM      *BLANK        POVFL                                        CLE164
                                                                                              CLE164
     C                   EVAL      P_SECAPR = PCAPR                                           CLE164
     C                   EVAL      P_SEREPR = PREPR                                           CLE164
     C                   EVAL      P_SEOVFL = POVFL                                           CLE164
                                                                                              CLE164
     C                   ENDSR                                                                CLE164
      *****************************************************************                       CLE164
     C/COPY ZACPYSRC,PSSR_ILEB
     C/EJECT
**  CPY@
(c) Finastra International Limited 2011
