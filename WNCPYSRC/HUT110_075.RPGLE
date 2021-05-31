      *****************************************************************                       HUT110
      *                                                               *                       HUT110
      *  Midas - /COPY Member FTVACBA                                 *                       HUT110
      *                                                               *                       HUT110
      *  FTVACBA - Midas FT Validate account with bank                *                       HUT110
      *                                                               *                       HUT110
      *  Last Amend No. HUT110  *CREATE    Date 20Apr20               *                       HUT110
      *                                                               *                       HUT110
      *---------------------------------------------------------------*                       HUT110
      *                                                               *                       HUT110
      *  HUT110 - Upgraded HUT022 to FBM 2.1 SP22                     *                       HUT110
      *           RTGS via SWIFT.                                     *                       HUT110
      *                                                               *                       HUT110
      *****************************************************************                       HUT110
      *                                                                                       HUT110
      /EJECT                                                                                  HUT110
      *****************************************************************                       HUT110
      *                                                               *                       HUT110
      *  ChkRTGSNost - Check if Nostro is a RTGS Nostro               *                       HUT110
      *                                                               *                       HUT110
      *****************************************************************                       HUT110
     C     ChkRTGSNost   BEGSR                                                                HUT110
      *                                                                                       HUT110
      ** Initialise work fields                                                               HUT110
      *                                                                                       HUT110
     C                   Eval      WKRtgs = 'N'                                               HUT110
     C                   Eval      OKAcb1 = 'Y'                                               HUT110
      *                                                                                       HUT110
      ** If settlement method 08 (via SWIFT), check Nostro in Sender's                        HUT110
      ** Correspondent is valid RTGS Nostro.                                                  HUT110
      *                                                                                       HUT110
     C                   If        %Subst(SSNCO:3:1) = ' ' and @STMT = 08                     HUT110
     C                   Eval      WKNost = SPCCY + %Subst(SSNCO:1:2)                         HUT110
     C                   Eval      WKPos = %Scan(WKNost:%Trim(WRTGSNost))                     HUT110
      *                                                                                       HUT110
      ** If resulting position is not 0, Nostro is found.                                     HUT110
      *                                                                                       HUT110
     C                   If        WKPos <> 0                                                 HUT110
     C                   Eval      WKRtgs = 'Y'                                               HUT110
     C                   Endif                                                                HUT110
      *                                                                                       HUT110
     C                   Endif                                                                HUT110
      *                                                                                       HUT110
     C                   ENDSR                                                                HUT110
      *****************************************************************                       HUT110
      /EJECT                                                                                  HUT110
      *****************************************************************                       HUT110
      *                                                               *                       HUT110
      *  VCnapsCd - Validate CNAPS Code                               *                       HUT110
      *                                                               *                       HUT110
      *****************************************************************                       HUT110
     C     VCnapsCd      BEGSR                                                                HUT110
      *                                                                                       HUT110
      ** Extract the CNAPS Code from Account With Bank entry                                  HUT110
      *                                                                                       HUT110
     C                   Eval      PCNAP = %Subst(SACB1:4:12)                                 HUT110
      *                                                                                       HUT110
      ** Call external CNAP validation module                                                 HUT110
      *                                                                                       HUT110
     C                   CALL      'XX000026'                                                 HUT110
     C                   Parm      *Blanks       PRetcode                                     HUT110
     C                   Parm                    PCNAP                                        HUT110
     C     XXCNAP        Parm      *Blanks       DSSDY                                        HUT110
      *                                                                                       HUT110
      ** If return code is blank, set flag to indicate valid                                  HUT110
      ** CNAPS code.                                                                          HUT110
      *                                                                                       HUT110
     C                   Eval      WKCnaps = 'N'                                              HUT110
     C                   If        PRetcode = *Blanks                                         HUT110
     C                   Eval      WKCnaps = 'Y'                                              HUT110
     C                   Endif                                                                HUT110
      *                                                                                       HUT110
     C                   ENDSR                                                                HUT110
      *****************************************************************                       HUT110
      /EJECT                                                                                  HUT110
      *****************************************************************                       HUT110
      *                                                               *                       HUT110
      *  ChkCrossB - Check Destination if Cross Border payment        *                       HUT110
      *                                                               *                       HUT110
      *****************************************************************                       HUT110
     C     ChkCrossB     BEGSR                                                                HUT110
      *                                                                                       HUT110
      ** Initialise work fields                                                               HUT110
      *                                                                                       HUT110
     C                   Movel     *Blanks       WCNUMA                                       HUT110
     C                   Movel     *Blanks       WKSwid                                       HUT110
      *                                                                                       HUT110
      ** If full NOSTRO (Dest type 'F')                                                       HUT110
      *                                                                                       HUT110
     C                   If        @DSTT = 'F'                                                HUT110
     C                   Eval      WCurr = %Subst(SDST1 : 1 : 3)                              HUT110
     C                   Eval      WNosN = %Subst(SDST1 : 4 : 2)                              HUT110
      *                                                                                       HUT110
      ** Read SDNOSTPD for customer number                                                    HUT110
      *                                                                                       HUT110
     C                   CALLB     'AONOSTR0'                                                 HUT110
     C                   Parm      *Blanks       C#RTCD                                       HUT110
     C                   Parm      '*KEY   '     C#OPTN                                       HUT110
     C                   Parm      *Blanks       C#CUST                                       HUT110
     C                   Parm                    WCurr                                        HUT110
     C                   Parm      *Blanks       C#ACCD                                       HUT110
     C                   Parm      *Blanks       C#ACSN                                       HUT110
     C                   Parm                    WNosN                                        HUT110
     C                   Parm      *Blanks       C#BRCD                                       HUT110
     C                   Parm      *Blanks       C#CSSN                                       HUT110
     C                   Parm      *Blanks       C#PNOI                                       HUT110
     C     SDNOST        Parm      SDNOST        DSFDY                                        HUT110
      *                                                                                       HUT110
      ** Save customer number                                                                 HUT110
      *                                                                                       HUT110
     C                   Movel     A7CUST        WCNUMA                                       HUT110
      *                                                                                       HUT110
     C                   Else                                                                 HUT110
      *                                                                                       HUT110
      ** If RETAIL NUMBER(R) read ACNUMA for customer number                                  HUT110
      *                                                                                       HUT110
     C                   If        @DSTT = 'R'                                                HUT110
     C                   Movel     SDST1         K#ACNO                                       HUT110
     C     K#ACNO        Chain     ACNUMAF                            90                      HUT110
      *                                                                                       HUT110
      ** If found, retrieve the Customer Number                                               HUT110
      *                                                                                       HUT110
     C                   If        *IN90 = *OFF                                               HUT110
     C                   Movel     CNUM          WCNUMA                                       HUT110
     C                   End                                                                  HUT110
      *                                                                                       HUT110
     C                   Else                                                                 HUT110
      *                                                                                       HUT110
      ** Swift Address                                                                        HUT110
      *                                                                                       HUT110
     C                   If        @DSTT = 'S'                                                HUT110
     C                   Movel     SDST1         WKSwid                                       HUT110
     C                   Else                                                                 HUT110
      *                                                                                       HUT110
      ** Customer Number                                                                      HUT110
      *                                                                                       HUT110
     C                   Movel     SDST1         WCNUMA                                       HUT110
     C                   End                                                                  HUT110
      *                                                                                       HUT110
     C                   End                                                                  HUT110
     C                   End                                                                  HUT110
      *                                                                                       HUT110
      ** Only access customer details if entry not SWIFT and                                  HUT110
      ** customer number has been worked out.                                                 HUT110
      *                                                                                       HUT110
     C                   If        @DSTT <> 'S' and WCNUMA <> *Blanks                         HUT110
      *                                                                                       HUT110
      ** Read SDCUSTPD to retrieve SWIFT address                                              HUT110
      *                                                                                       HUT110
     C                   CALLB     'AOCUSTR0'                                                 HUT110
     C                   Parm      *Blanks       C#RTCD                                       HUT110
     C                   Parm      '*KEY   '     C#OPTN                                       HUT110
     C                   Parm      WCNUMA        C#KEY1                                       HUT110
     C                   Parm      *BLANKS       C#KYST                                       HUT110
     C     SDCUST        Parm      SDCUST        DSSDY                                        HUT110
      *                                                                                       HUT110
      ** Retrieve SWIFT address from the customer detail                                      HUT110
      *                                                                                       HUT110
     C                   If        C#RTCD = *Blanks                                           HUT110
     C                   Movel     BBCSID        WKSwid                                       HUT110
     C                   Endif                                                                HUT110
      *                                                                                       HUT110
     C                   Endif                                                                HUT110
      *                                                                                       HUT110
      ** Set Cross Border flag based on pos 5-6 of SWIFT address                              HUT110
      *                                                                                       HUT110
     C                   If        %Subst(WKSwid : 5 : 2) <> 'TW'                             HUT110
     C                   Eval      WCrossB = 'Y'                                              HUT110
     C                   Else                                                                 HUT110
     C                   Eval      WCrossB = 'N'                                              HUT110
     C                   Endif                                                                HUT110
      *                                                                                       HUT110
     C                   ENDSR                                                                HUT110
      *****************************************************************                       HUT110
      /EJECT                                                                                  HUT110
      *                                                                                       HUT110
      *****************************************************************                       HUT110
      * End of /COPY HUT110_075                                       *                       HUT110
      *****************************************************************                       HUT110
