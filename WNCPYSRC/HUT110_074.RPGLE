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
      ** If HUT110 is ON and Nostro is valid for RTGS, perform                                HUT110
      ** additional validation on Account With Bank.                                          HUT110
      *                                                                                       HUT110
     C                   If        HUT110 = 'Y' and WKRtgs = 'Y'                              HUT110
      *                                                                                       HUT110
      ** Error if A/c With Bank is not entered for cross-border RTGS transaction.             HUT110
      *                                                                                       HUT110
     C                   If        SACB1 = *Blanks and WCrossB = 'Y'                          HUT110
     C                   Move      'N'           OKAcb1                                       HUT110
     C                   Add       1             Idx                                          HUT110
     C                   Movel     'SACB1'       FldNamXAr(Idx)                               HUT110
     C                   Movel     'XXX9100'     MsgIdXAr(Idx)                                HUT110
     C                   Endif                                                                HUT110
      *                                                                                       HUT110
      ** Error if customer number entered but without SWIFT ID.                               HUT110
      *                                                                                       HUT110
     C                   If        @ACBT = 'C'                                                HUT110
     C                   Movel     SACB1         CheckSlash        1                          HUT110
      *                                                                                       HUT110
     C                   If        CheckSlash = '/'                                           HUT110
     C                   Eval      PKey1 = %subst(SACB2:1:10)                                 HUT110
     C                   Else                                                                 HUT110
     C                   Eval      PKey1 = %subst(SACB1:1:10)                                 HUT110
     C                   Endif                                                                HUT110
      *                                                                                       HUT110
      ** Retrieve customer details.                                                           HUT110
      *                                                                                       HUT110
     C                   CallB     'AOCUSTR0'                                                 HUT110
     C                   Parm      *Blanks       PRetcode                                     HUT110
     C                   Parm      '*KEY'        POptn             7                          HUT110
     C                   Parm                    PKey1                                        HUT110
     C                   Parm      *Blank        PKyst                                        HUT110
     C     SDCUST        Parm      SDCUST        DSSDY                                        HUT110
      *                                                                                       HUT110
     C                   Endif                                                                HUT110
      *                                                                                       HUT110
      ** Customer is valid but no SWIFT ID.                                                   HUT110
      ** Also error if not CNAPS and A/c With Bank type is address.                           HUT110
      ** Also error if in correct SWIFT format but non-existing SWIFT BIC.                    HUT110
      *                                                                                       HUT110
     C                   If        @ACBT = 'C' and PRetcode = *Blanks                         HUT110
     C                               and BBCSID = *Blanks                                     HUT110
     C                             OR @ACBT = 'A' and WKCnaps <> 'Y'                          HUT110
     C                             OR @ACBT = 'S' and NotS = 'N'                              HUT110
     C                   Move      'N'           OKAcb1                                       HUT110
     C                   Add       1             Idx                                          HUT110
     C                   Movel     'SACB1'       FldNamXAr(Idx)                               HUT110
     C                   Movel     'XXX9101'     MsgIdXAr(Idx)                                HUT110
     C                   Endif                                                                HUT110
      *                                                                                       HUT110
     C                   Endif                                                                HUT110
      *                                                                                       HUT110
      *****************************************************************                       HUT110
      * End of /COPY HUT110_074                                       *                       HUT110
      *****************************************************************                       HUT110
