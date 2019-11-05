     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE PDCL automatic maturity')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE007051 - Past Due Call Loan maturity                       *
      *                                                               *
      *           The function of this program is to process PDCL that*
      *           have zero principal and zero interest and set       *
      *           maturity date = run date                            *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE141             Date 08Feb16               *
      *                 AR886367           Date 11Jun13               *
      *                 AR993803           Date 03Aug12               *
      *                 AR1007020          Date 10Aug12               *
      *                 AR806881           Date 24Apr13               *
      *                 AR813436           Date 14Oct12               *
      *                 AR810495           Date 01Aug12               *
      *                 AR700107           Date 01Aug12               *
      *                 AR576000           Date 01Aug12               *
      *                 AR548809A          Date 01Aug12               *
      *                 AR548811           Date 01Aug12               *
      *                 AR548809           Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 AR318445 *CREATE   Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  AR886367 - PDCL matured eventhough an MR exists on LOAMSDK.  *
      *             Prevent maturity to be set on rundate if event    *
      *             exists on LOAMSDK. (Child: AR886368)              *
      *  AR993803 - Fee payment did not transfer to PDCL. Only mature *
      *             Fee PDCL if the origin fee is already matured.    *
      *             (Child: AR993804)                                 *
      *  AR1007020 - PDCL matured with outstanding amount. Only set   *
      *              maturity date of principal/interest PDCL if OL   *
      *              is already matured. (Child: AR1007021)           *
      *            - Corrected condition from YPORG greater than      *
      *              *BLANK to YPORG not equal to *BLANK.             *
      *  AR806881 - Reverse part of AR810495 that concerned on ADDI   *
      *             processing. (Child: AR806882)                     *
      *  AR813436 - PDCL maturing on the date when manual interest    *
      *             adjustment is inserted. Add condition to set the  *
      *             maturity of PDCL to rundate if AIMN = 0.          *
      *             (Child: AR813437)                                 *
      *  AR810495 - PDCL loans incorrectly set to mature on rundate   *
      *             though there are oustanding interest. Corrected   *
      *             system processing of ADDI.  (Child: AR810496)     *
      *  AR700107 - PDCL maturity date is set = zero if the settlement*
      *             a/c has block all debit = 'Y'. (Child: AR700108)  *
      *  AR576000 - FEES PDCLs matured later than the expected date   *
      *             (Child: AR576001)                                 *
      *  AR548809A- Next Rollover date was not updated.               *
      *             (Child: AR548815A)                                *
      *  AR548811 - Also PDCL with AUTO <> 'C' should mature          *
      *             automatically (Child: AR548816)                   *
      *  AR548809 - When the loan is brought to maturity the next     *
      *             rollover date should be zero. (Child: AR548815)   *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  AR318445 - automatic update of PDCL maturity date            *
      *             (Child: AR318446)                                 *
      *                                                               *
      *****************************************************************
      /SPACE
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      ** Loans
 
     FCLOANCL   UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(K_)
 
      ** Customer Loans
 
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L_)
     F                                     RENAME(CLOANCLF:CLOANORF)
     F                                     IGNORE(CLOANCKF) IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
     FLEFEED    IF   E           K DISK    INFSR(*PSSR)
     FLEPDUEL1  IF   E           K DISK    INFSR(*PSSR)
     FLEPDUEL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEPDUED0:LEPDUED2)
     F                                     PREFIX(P_)
     FLEPDUFL1  IF   E           K DISK    INFSR(*PSSR)
     FLOAMSOM4  IF   E           K DISK    INFSR(*PSSR)                                     AR886367
     F                                     PREFIX(Z_)                                       AR886367
     FLE007051P1O    E             PRINTER INFDS(SPOOL1)                                    AR700107
     F                                     OFLIND(*IN50)                                    AR700107
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
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
 
      ** Passed Parameters
 
      ** Overlays
 
      ** Fac. Fwd Drw Days
 
     D                 DS
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ZS2             S              1    DIM(21)                                          AR700107
     D                 DS                                                                   AR700107
     D  WORK15                 1     15  0                                                  AR700107
     D  ZS1                    1     15  0                                                  AR700107
     D                                     DIM(15)                                          AR700107
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Short data structure for access objects.
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Long data structure for access objects.
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD2       E                     EXTFLD(QQACCD)
 
      ** Nostro details
                                                                                            AR700107
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                AR700107
                                                                                            AR700107
     D SPOOL1          DS                                                                   AR700107
     D SFILE1                 83     92                                                     AR700107
     D SFNUM1                123    124B 0                                                  AR700107
     D OFLLN1                188    189B 0                                                  AR700107
     D PRTLN1                367    368B 0                                                  AR700107
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WNewMDt         S              5  0
     D WCurMDT         S              5  0
     D WFeeLon         S              1
 
     D WVDAT6          S              6  0
     D WOSAC           S             18
     D WSETP           S              2  0
     D ILCNUM          S              6
     D CCYL            S              3
     D KSCCY           S              3
     D OSBR            S              3
     D WBLCKD          S              1
     D WrkOutInt       S             13  0
     D WrkOutInt2      S             13  0
     D WkRound         S             13  0
 
     D ZIBEG           S              5  0
     D ZIEND           S              5  0
     D ZICALC          S              1  0
     D ZIAMT           S             15  0
     D ZIRATE          S             11  7
     D ZINTR           S             30  9
 
     D CLE005          S              1
 
     D PSeq            S              5
     D PEnty           S              3
     D PSFile          S             10
     D PZSNum          S              6  0
     D PZSErr          S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Retrieve & Process Past Due Call Loan Details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 021
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Print report header                                                                AR700107
                                                                                            AR700107
     C                   WRITE     LE0705H1                                                 AR700107
     C                   WRITE     LE0705H2                                                 AR700107
 
      ** Process PDCLs
 
     C                   READ(E)   CLOANCL
     C                   DOW       NOT %EOF(CLOANCL)
 
      ** If Maturity date is zero, check if it can be set = run date                        AR700107
                                                                                            AR700107
     C                   IF        K_MDAT = 0 AND K_CPAM = 0                                AR700107
     C                   EXSR      SRChkmat
                                                                                            AR700107
      ** Else                                                                               AR700107
                                                                                            AR700107
     C                   ELSE                                                               AR700107
     C                   IF        K_MDAT >= BJRDNB AND K_MDAT < BJDNWD                     AR700107
     C                   EXSR      SRChkAcc                                                 AR700107
     C                   ENDIF                                                              AR700107
     C                   ENDIF                                                              AR700107
     C                   READ(E)   CLOANCL
     C                   ENDDO
 
      ** Terminate Program
 
     C                   EVAL      *INLR = *ON
                                                                                            AR700107
      ** Print report foot                                                                  AR700107
                                                                                            AR700107
     C                   WRITE     LE0705T1                                                 AR700107
                                                                                            AR700107
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRChkmat - Check Maturity Date                                *
      *****************************************************************
 
     C     SRChkmat      BEGSR
 
      ** Select only PDCL which have maturity date = 0 and CPAM = 0
 
     C                   IF        %SUBST(K_LTYP:1:1) = 'X' OR
     C                             %SUBST(K_LTYP:1:1) = 'Y' OR
     C                             %SUBST(K_LTYP:1:1) = 'Z'
     C***********        IF        K_MDAT = 0 AND K_CPAM = 0  AND K_AUTO = 'C'              AR548811
     C                   IF        K_MDAT = 0 AND K_CPAM = 0                                AR548811
 
      ** Retrieve Original Loan from PDCL files (LEPDUEPD or LEPDUFPD)
      ** - set Original loan reference = 0
      ** - set Original loan maturity date = 0
 
     C                   Z-ADD     0             WNewMDt                                    AR700107
     C                   Z-ADD     0             WCurMDT                                    AR700107
     C                   EVAL      FEPEND = 0
     C                   EVAL      FEAMTA = 0
     C                   EVAL      FELPAM = 0
     C                   EVAL      FEAMTP = 0
     C                   EVAL      FERECI = *BLANKS                                         AR576000
     C                   EVAL      YPORG = *BLANK
     C                   EVAL      L_MDAT = 0
     C                   EVAL      L_CPAM = 0
     C                   EVAL      L_AIMN = 0                                               AR993803
     C                   MOVE      *BLANKS       WFeeLon
     C                   MOVE      'L'           WFeeLon
     C                   MOVE      ' '           WLonAmd           1                        AR886367
 
      ** PDCL - Loan
 
     C     K_LNRF        CHAIN(E)  LEPDUEL1
     C                   IF        NOT %FOUND(LEPDUEL1)
 
      ** PDCL - Fee
 
     C     K_LNRF        CHAIN(E)  LEPDUFL1
     C                   IF        %FOUND(LEPDUFL1)
     C                   MOVE      'F'           WFeeLon
 
      ** Fees File
 
     C     KFEES         CHAIN     LEFEED
                                                                                            AR576000
      ** If Fee is Matured, then set Fee amount fields to zero                              AR576000
      ** to allow PDCL to mature                                                            AR576000
                                                                                            AR576000
     C     FERECI        IFEQ      'M'                                                      AR576000
     C                   EVAL      FEAMTA = 0                                               AR576000
     C                   EVAL      FELPAM = 0                                               AR576000
     C                   EVAL      FEAMTP = 0                                               AR576000
     C                   ELSE                                                               AR993803
     C                   LEAVEsr                                                            AR993803
     C                   ENDIF                                                              AR576000
     C                   ENDIF
     C                   ENDIF
 
      ** Retrieve Original loan maturity date
 
     C                   IF        WfeeLon = 'L'
     C**********         IF        YPORG > *BLANK                                          AR1007020
     C                   IF        YPORG <> *BLANK                                         AR1007020
     C     YPORG         CHAIN(E)  CLOAN
     C                   IF        %FOUND(CLOAN)                                           AR1007020
     C                             and L_reci <> 'M'                                       AR1007020
     C                   LEAVEsr                                                           AR1007020
     C                   ENDIF                                                             AR1007020
     C                   ENDIF
     C                   ENDIF
 
      ** Orig Loan
 
     C                   IF        L_MDAT < BJDNWD AND L_CPAM = 0
 
      ** If Original Loan maturity date < next working day and CPAM = 0,
      ** then check if there are other live PDCLs for this loan.
 
     C                   EVAL      Wpdcl2 = *BLANK
     C                   EVAL      WCpam2 = 0
     C                   EVAL      WrkoutInt2 = 0
 
     C                   IF        WfeeLon = 'L'
     C     YPORG         SETLL     LEPDUEL2
     C     YPORG         READE     LEPDUEL2
     C                   DOW       NOT %EOF(LEPDUEL2)
 
      ** If PDCLs loan is not the same as loan being processed
 
     C     P_YPLON       IFNE      K_LNRF
     C                   EVAL      Wpdcl2 = P_YPLON
     C                   ENDIF
 
     C     YPORG         READE     LEPDUEL2
     C                   ENDDO
 
      ** If there is a second PDCL for the original loan, then check
      ** whether it has outstanding principal and if it does,
      ** do not allow the first PDCL to mature
 
     C                   EVAL      L_CPAM = 0
     C                   IF        Wpdcl2 > *BLANK
     C     Wpdcl2        CHAIN(E)  CLOAN
     C                   ENDIF
 
     C                   IF        L_CPAM <> 0
     C                   EVAL      WCpam2 = L_CPAM
     C                   ENDIF
 
      ** If Second PDCL CPAM is zero, then check whether there
      ** is outstanding interest
 
     C                   IF        Wcpam2  = 0
     C                   EXSR      SRIntOut2
     C                   ENDIF
     C                   ENDIF
 
      ** If PDCL is linked to a fee, then select only if Fee is matured
      **  and has no outstanding amount
      ** If there are no other PDCLs for the original loan or there is
      **  a second PDCL with CPAM = 0 and outstanding interest = 0,
      **  then set maturity date of first original loan = rundate
 
      ** Second PDCL
 
     C                   IF        Wcpam2  = 0 AND WrkOutInt2 = 0 AND FEPEND
     C                             < BJDNWD AND FELPAM = 0 AND FEAMTP = 0 AND
     C**********                   FEAMTA = 0                                               AR813436
     C                             FEAMTA = 0 and L_AIMN = 0                                AR813436
     C                   EXSR      SRIntOut
 
     C     K_LNRF        SETLL     LOAMSOM4                                                 AR886367
     C     K_LNRF        READE     LOAMSOM4                                                 AR886367
     C                   DOW       NOT %EOF(LOAMSOM4)                                       AR886367
     C                   IF        Z_RECI = 'D'                                             AR886367
     C                   EVAL      WLonAmd = 'Y'                                            AR886367
     C                   LEAVE                                                              AR886367
     C                   ENDIF                                                              AR886367
     C     K_LNRF        READE     LOAMSOM4                                                 AR886367
     C                   ENDDO                                                              AR886367
                                                                                            AR886367
      ** If outstanding insterest is zero,
      ** then set PDCL maturity date = run date
 
     C**********         IF        WrkoutInt = 0                                            AR813436
     C                   IF        WrkoutInt = 0 and K_AIMN = 0                             AR813436
     C                             and WLonAmd = ' '                                        AR886367
     C                   EVAL      K_MDAT = BJRDNB
     C                   EVAL      WNewMdt = BJRDNB                                         AR700107
     C                   EVAL      K_RLDT = 0                                               AR548809
 
      ** Update MDAT field only
 
     C                   EXCEPT    UPDMAT
     C                   ENDIF
 
      ** Print record                                                                       AR700107
                                                                                            AR700107
     C                   MOVE      *BLANKS       WBLCKD                                     AR700107
     C                   EXSR      SRPrintR                                                 AR700107
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT                                                                                AR700107
      *****************************************************************                     AR700107
      * srCheckAcc - Check Account                                    *                     AR700107
      *****************************************************************                     AR700107
                                                                                            AR700107
     C     SRChkAcc      BEGSR                                                              AR700107
                                                                                            AR700107
      ** Select only PDCL which have maturity date >= Rundate                               AR700107
      ** and < Next working date                                                            AR700107
                                                                                            AR700107
     C                   IF        %SUBST(K_LTYP:1:1) = 'X' OR                              AR700107
     C                             %SUBST(K_LTYP:1:1) = 'Y' OR                              AR700107
     C                             %SUBST(K_LTYP:1:1) = 'Z'                                 AR700107
                                                                                            AR700107
     C                   IF        K_MDAT >= BJRDNB AND K_MDAT < BJDNWD                     AR700107
                                                                                            AR700107
      ** If CPAM  or Interst are not zero then process record                               AR700107
                                                                                            AR700107
     C                   Z-ADD     0             WNewMDt                                    AR700107
     C                   Z-ADD     0             WCurMDT                                    AR700107
     C                   EVAL      WrkoutInt = 0                                            AR700107
     C                   EXSR      SRIntOut                                                 AR700107
                                                                                            AR700107
      ** If there is outstanding interest and/or principal,                                 AR700107
      ** check if account is blocked                                                        AR700107
                                                                                            AR700107
     C                   IF        WrkoutInt <> 0 OR K_CPAM <> 0                            AR700107
     C                   EXSR      SRRtvAcc                                                 AR700107
                                                                                            AR700107
      ** Retrieve                                                                           AR700107
                                                                                            AR700107
     C                   IF        Wblckd = 'Y'                                             AR700107
     C                   Z-ADD     K_MDAT        WCurMDt                                    AR700107
     C                   Z-ADD     0             K_MDAT                                     AR700107
     C                   Z-ADD     0             WNewMDt                                    AR700107
     C                   EXCEPT    UPDMAT                                                   AR700107
     C                   EXSR      SRPrintR                                                 AR700107
     C                   ENDIF                                                              AR700107
                                                                                            AR700107
     C                   ENDIF                                                              AR700107
                                                                                            AR700107
     C                   ENDIF                                                              AR700107
                                                                                            AR700107
     C                   ENDIF                                                              AR700107
                                                                                            AR700107
     C                   ENDSR                                                              AR700107
                                                                                            AR700107
      *****************************************************************                     AR700107
     C/EJECT                                                                                AR700107
      *****************************************************************                     AR700107
      * srPrintR - Print Report                                       *                     AR700107
      *****************************************************************                     AR700107
                                                                                            AR700107
     C     SRPrintR      BEGSR                                                              AR700107
                                                                                            AR700107
     C                   EXSR      SRGetCcy                                                 AR886367
                                                                                            AR886367
      ** Clear work-fields                                                                  AR700107
                                                                                            AR700107
     C                   MOVE      K_LNRF        OLNRF                                      AR700107
     C                   CLEAR                   OCPAM                                      AR700107
     C                   CLEAR                   OINTD                                      AR700107
     C                   CLEAR                   OOMDAT                                     AR700107
     C                   CLEAR                   ONMDAT                                     AR700107
     C                   MOVE      '0'           OOMDAT                                     AR700107
     C                   MOVE      '0'           ONMDAT                                     AR700107
     C                   MOVE      '0'           OCPAM                                      AR700107
     C                   MOVE      '0'           OINTD                                      AR700107
                                                                                            AR700107
      ** Set settlement account/type output field                                           AR700107
                                                                                            AR700107
     C     K_PTYP        IFNE      66                                                       AR700107
     C     K_PTYP        ANDNE     67                                                       AR700107
     C     K_PTYP        ANDNE     69                                                       AR700107
     C     K_PTYP        ANDNE     72                                                       AR700107
     C                   MOVE      K_RSTM        ORSTM                                      AR700107
     C                   MOVEL     K_RONS        ORONS                                      AR700107
     C                   ELSE                                                               AR700107
     C                   MOVE      K_PSTM        ORSTM                                      AR700107
     C                   MOVEL     K_PONS        ORONS                                      AR700107
     C                   ENDIF                                                              AR700107
                                                                                            AR700107
      ** Retrieve currency details                                                          AR700107
                                                                                            AR700107
     C                   EXSR      SRGetCcy                                                 AR700107
                                                                                            AR700107
      ** Principal                                                                          AR700107
                                                                                            AR700107
     C     K_CPAM        IFNE      0                                                        AR700107
     C                   Z-ADD     K_CPAM        ZFLD15                                     AR700107
     C                   Z-ADD     A6NBDP        Zdecs                                      AR700107
     C                   MOVE      'J'           Zecode                                     AR700107
     C                   EXSR      Zsedit                                                   AR700107
     C                   MOVE      ZOUT21        OCPAM                                      AR700107
     C                   ENDIF                                                              AR700107
                                                                                            AR700107
      ** Interest                                                                           AR700107
                                                                                            AR700107
     C     WrkoutInt     IFNE      0                                                        AR700107
     C                   Z-ADD     WrkoutInt     ZFLD15                                     AR700107
     C                   Z-ADD     A6NBDP        Zdecs                                      AR700107
     C                   MOVE      'J'           Zecode                                     AR700107
     C                   EXSR      Zsedit                                                   AR700107
     C                   MOVE      ZOUT21        OINTD                                      AR700107
     C                   ENDIF                                                              AR700107
                                                                                            AR700107
      ** New maturity                                                                       AR700107
                                                                                            AR700107
     C     WNewMdt       IFNE      0                                                        AR700107
     C                   CALL      'ZDATE2'                                                 AR700107
     C                   PARM                    WNewMdt                                    AR700107
     C                   PARM                    BJDFIN                                     AR700107
     C                   PARM      *ZEROS        WVDAT6                                     AR700107
     C                   PARM      *BLANKS       ONMDAT                                     AR700107
     C                   ENDIF                                                              AR700107
                                                                                            AR700107
      ** Current Maturity                                                                   AR700107
                                                                                            AR700107
     C     WCurMdt       IFNE      0                                                        AR700107
     C                   CALL      'ZDATE2'                                                 AR700107
     C                   PARM                    WCurMdt                                    AR700107
     C                   PARM                    BJDFIN                                     AR700107
     C                   PARM      *ZEROS        WVDAT6                                     AR700107
     C                   PARM      *BLANKS       OOMDAT                                     AR700107
     C                   ENDIF                                                              AR700107
                                                                                            AR700107
      ** Print record                                                                       AR700107
                                                                                            AR700107
     C     PRtlN1        IFGE      60                                                       AR700107
     C                   WRITE     LE0705H1                                                 AR700107
     C                   WRITE     LE0705H2                                                 AR700107
     C                   ENDIF                                                              AR700107
     C                   WRITE     LE0705D1                                                 AR700107
                                                                                            AR700107
     C                   ENDSR                                                              AR700107
                                                                                            AR700107
      *****************************************************************                     AR700107
     C/EJECT                                                                                AR700107
      *****************************************************************                     AR700107
      * srRtvAcc - Retrieve Account Details                           *                     AR700107
      *****************************************************************                     AR700107
                                                                                            AR700107
     C     SRRtvAcc      BEGSR                                                              AR700107
                                                                                            AR700107
     C                   MOVE      *BLANKS       WOSAC                                      AR700107
     C                   MOVE      *BLANKS       WSETP                                      AR700107
                                                                                            AR700107
     C     K_PTYP        IFNE      66                                                       AR700107
     C     K_PTYP        ANDNE     67                                                       AR700107
     C     K_PTYP        ANDNE     69                                                       AR700107
     C     K_PTYP        ANDNE     72                                                       AR700107
     C                   MOVE      K_RONS        WOSAC                                      AR700107
     C                   MOVE      K_RSTM        WSETP                                      AR700107
     C                   MOVE      K_OMDB        OSBR                                       AR700107
     C                   ELSE                                                               AR700107
     C                   MOVE      K_PONS        WOSAC                                      AR700107
     C                   MOVE      K_PSTM        WSETP                                      AR700107
     C                   MOVE      K_OSDB        OSBR                                       AR700107
     C                   ENDIF                                                              AR700107
                                                                                            AR700107
      ** Retrieve sett account and priority                                                 AR700107
                                                                                            AR700107
     C                   MOVE      K_CNUM        ILCNUM                                     AR700107
     C                   CALL      'LE007054'                                               AR700107
     C                   PARM      K_CCY         CCYL                                       AR700107
     C                   PARM                    ILCNUM                                     AR700107
     C                   PARM      K_SCCY        KSCCY                                      AR700107
     C                   PARM                    WOSAC                                      AR700107
     C                   PARM                    WSETP                                      AR700107
     C                   PARM                    K_OLNO                                     AR700107
     C                   PARM                    OSBR                                       AR700107
                                                                                            AR700107
     C                   PARM      *BLANKS       WBLCKD                                     AR700107
                                                                                            AR700107
     C                   ENDSR                                                              AR700107
                                                                                            AR700107
      *****************************************************************
     C/EJECT
      *****************************************************************
      * srIntOut - Outstanding Interest                               *
      *****************************************************************
 
     C     SRIntOut      BEGSR
 
      **  O/S INTEREST
      **  O/S INTEREST
 
     C                   Z-ADD     0             WrkOutInt
     C                   Z-ADD     0             WrkOutInt2
 
      ** Set End date
 
     C                   IF        K_Vdat > BJRDNB AND CLE005 = 'Y'
     C                   EVAL      ZIEND = K_VDAT
     C                   ELSE
     C                   EVAL      ZIEND = BJRDNB
     C                   ENDIF
 
     C                   IF        K_MDAT <> 0 AND K_MDAT < BJRDNB
     C                   EVAL      ZIEND = K_MDAT
     C                   ENDIF
 
      ** Start Date
 
     C                   EVAL      ZIBEG = K_IACD
 
      ** Add 1 to End date dependin on ADDI indicator
 
     C**********         IF        K_ADDI = 'B' AND ZIEND = K_MDAT AND                      AR810495
     C**********                   K_ORED < K_MDAT                                          AR810495
     C**********         IF        ((K_ADDI = 'B') OR (K_ADDI = 'L')) AND          AR810495 AR806881
     C**********                   ZIEND = K_MDAT AND K_ORED < K_MDAT              AR810495 AR806881
     C                   IF        K_ADDI = 'B' AND ZIEND = K_MDAT AND                      AR806881
     C                             K_ORED < K_MDAT                                          AR806881
     C                   EVAL      ZIEND = ZIEND + 1
     C                   ENDIF
 
      ** Add 1 to End date if Original Entry date is after
      ** maturity date
 
     C**********         IF        K_ADDI = 'B' AND K_ORED >= K_MDAT                        AR810495
     C**********         IF        ((K_ADDI = 'B') OR (K_ADDI = 'L')) AND          AR810495 AR806881
     C**********                   K_ORED >= K_MDAT                                AR810495 AR806881
     C                   IF        K_ADDI = 'B' AND K_ORED >= K_Mdat                        AR806881
     C                   EVAL      ZIEND = ZIEND + 1
     C                   ENDIF
 
      ** set parameters required for interest calculation
 
     C                   EVAL      ZICALC = K_ICBS
     C                   EVAL      ZIRATE = K_INTR
     C                   EVAL      ZIAMT = K_CPAM
     C                   EXSR      SRGLINTC
 
      ** Round Interest depending on RDFC indicator
 
     C                   IF        K_RDFC = 'Y'
     C                   Z-ADD     ZINTR         WkRound
     C                   Z-ADD     WkRound       ZINTR
     C                   ENDIF
 
      ** Calculate Interest Outstanding
 
     C                   EVAL      WrkOutInt = ZINTR + K_AITC + K_AIAP +
     C                             K_AIMN - K_IPRD - K_ICTD - K_IWOD
 
     C                   ENDSR
 
      *****************************************************************
     C/SPACE
      *****************************************************************
      * srIntOut2 - Outstanding Interest for Second PDCL              *
      *****************************************************************
 
     C     SRIntOut2     BEGSR
 
      ** O/S INTEREST
 
     C                   Z-ADD     0             WrkOutInt2
 
      ** Set End date
 
     C                   IF        L_VDAT > BJRDNB AND CLE005 = 'Y'
     C                   EVAL      ZIEND = L_VDAT
     C                   ELSE
     C                   EVAL      ZIEND = BJRDNB
     C                   ENDIF
 
     C                   IF        L_MDAT <> 0 AND L_MDAT < BJRDNB
     C                   EVAL      ZIEND = L_MDAT
     C                   ENDIF
 
      ** Start Date
 
     C                   EVAL      ZIBEG = L_IACD
 
      ** Add 1 to End date dependin on ADDI indicator
 
     C**********         IF        L_ADDI = 'B' AND ZIEND = L_MDAT AND                      AR810495
     C**********                   L_ORED < L_MDAT                                          AR810495
     C                   IF        ((L_ADDI = 'B') OR (L_ADDI = 'L')) AND                   AR810495
     C                             Ziend = L_MDAT AND L_ORED < L_MDAT                       AR810495
     C                   EVAL      ZIEND = ZIEND + 1
     C                   ENDIF
 
      ** Add 1 to End date if Original Entry date is after
      ** maturity date
 
     C**********         IF        L_ADDI = 'B' AND L_ORED >= L_MDAT                        AR810495
     C                   IF        ((L_ADDI = 'B') OR (L_ADDI = 'L')) AND                   AR810495
     C                             L_ORED >= L_MDAT                                         AR810495
     C                   EVAL      ZIEND = ZIEND + 1
     C                   ENDIF
 
      ** Set parameters required for interest calculation
 
     C                   EVAL      ZICALC = L_ICBS
     C                   EVAL      ZIRATE = L_INTR
     C                   EVAL      ZIAMT = L_CPAM
     C                   EXSR      SRGLINTC
 
      ** Round Interest depending on RDFC indicator
 
     C                   IF        L_RDFC = 'Y'
     C                   Z-ADD     ZINTR         WkRound
     C                   Z-ADD     WkRound       ZINTR
     C                   ENDIF
 
      ** Calculate Interest Outstanding
 
     C**********         EVAL      WrkOutInt = ZINTR + L_AITC + L_AIAP +                    AR810495
     C**********                   L_AIMN - L_IPRD - L_ICTD - L_IWOD                        AR810495
     C                   EVAL      WrkOutInt2 = ZINTR + L_AITC + L_AIAP +                   AR810495
     C                             L_AIMN - L_IPRD - L_ICTD - L_IWOD                        AR810495
 
     C                   ENDSR
 
      *****************************************************************
     C/SPACE
      *****************************************************************
      * srGLINTC - Calculate Interest on period                       *
      *****************************************************************
 
     C     SRGLINTC      BEGSR
 
     C                   CALL      'GLINTC'
 
      ** Starting Date
      ** Finishing Date
      ** Calc. Basis
      ** Principal
      ** Rate of Interest
      ** Interest
 
     C                   PARM                    ZIBEG
     C                   PARM                    ZIEND
     C                   PARM                    ZICALC
     C                   PARM                    ZIAMT
     C                   PARM                    ZIRATE
     C                   PARM                    ZINTR
 
     C                   ENDSR
 
      *****************************************************************                     AR700107
     C/EJECT                                                                                AR700107
      *****************************************************************                     AR700107
      * srGetCcy - Retrieve Currency Details                          *                     AR700107
      *****************************************************************                     AR700107
 
     C     SRGetCcy      BEGSR                                                              AR700107
                                                                                            AR700107
     C                   CALL      'AOCURRR0'                                               AR700107
     C                   PARM      '*DBERR'      @RTCD                                      AR700107
     C                   PARM      '*KEY'        @OPTN                                      AR700107
     C                   PARM                    K_CCY                                      AR700107
     C     SDCURR        PARM                    DSSDY                                      AR700107
                                                                                            AR700107
     C                   ENDSR                                                              AR700107
 
      *****************************************************************
      * SRRCFProc - Register Printer File via RCF                     *
      *****************************************************************
 
     C     SRRCFProc     BEGSR
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANKS       PZSErr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        PZSErr = 'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      * *INZSR - Initial processing                                   *
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
 
     C                   MOVEL     SFILE1        PSFile
     C                   Z-ADD     SFNUM1        PZSNum
     C                   EXSR      SRRCFProc
 
     C     *LIKE         DEFINE    K_LNRF        WPDCL2
     C     *LIKE         DEFINE    K_CPAM        WCPAM2
 
     C     KFEES         KLIST
     C                   KFLD                    YBRCA
     C                   KFLD                    YECNUM
     C                   KFLD                    YEFACL
     C                   KFLD                    YPORG
     C                   KFLD                    YESEQ
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
     C/SPACE
      *****************************************************************
     C/COPY ZSRSRC,ZSEDITZ3LE                                                               AR700107
     C/COPY ZACPYSRC,PSSR_ILEB
      *****************************************************************
     OCLOANCLF  E            UPDMAT
     O                       K_MDAT
     O                       K_RLDT                                                        AR548809A
 
      /EJECT
**  CPY@
(c) Finastra International Limited 2012
