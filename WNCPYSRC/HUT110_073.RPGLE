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
      *           (Include MD-30805)                                  *                       HUT110
      *                                                               *                       HUT110
      *****************************************************************                       HUT110
      *                                                                                       HUT110
      ** If HUT110 is ON, check if nostro is a RTGS Nostro                                    HUT110
      *                                                                                       HUT110
     C                   If        HUT110 = 'Y'                                               HUT110
     C                   Exsr      ChkRTGSNost                                                HUT110
      *                                                                                       HUT110
      ** Check Destination if cross-border payment or not.                                    HUT110
      *                                                                                       HUT110
     C                   If        WKRtgs = 'Y'                                               HUT110
     C                   Exsr      ChkCrossB                                                  HUT110
     C                   Endif                                                                HUT110
      *                                                                                       HUT110
      ** If RTGS Nostro and entry starts with '/CN' but Pay Ccy is not 'CNY',                 HUT110
      ** issue error message.                                                                 HUT110
      *                                                                                       HUT110
     C                   If        WKRtgs = 'Y' and %Subst(SACB1:1:3) = '/CN'                 HUT110
     C                               and SPCCY <> 'CNY'                                       HUT110
     C                   Move      'N'           OKAcb1                                       HUT110
     C                   Add       1             Idx                                          HUT110
     C                   Movel     'SACB1'       FldNamXAr(Idx)                               HUT110
     C                   Movel     'XXX9101'     MsgIdXAr(Idx)                                HUT110
     C                   Eval      RetCodeIn = 'Error'                                        HUT110
     C                   Endif                                                                HUT110
      *                                                                                       HUT110
      ** If RTGS Nostro and entry starts with '/CN' and Pay Ccy is 'CNY',                     HUT110
      ** perform CNAPS code validation.                                                       HUT110
      *                                                                                       HUT110
     C                   If        WKRtgs = 'Y' and %Subst(SACB1:1:3) = '/CN'                 HUT110
     C                               and SPCCY = 'CNY'                                        HUT110
     C                   Exsr      VCNAPSCd                                                   HUT110
      *                                                                                       HUT110
      ** If valid CNAPS Code, default rest of CNAPS detail in A/c                             HUT110
      ** With Bank fields and set entry type as an address.                                   HUT110
      *                                                                                       HUT110
     C                   If        WKCnaps = 'Y'                                              HUT110
     C                   Eval      @ACBT = 'A'                                                HUT110
     C                   Eval      SACB2 = CNBKNM                                             HUT110
     C                   Eval      SACB3 = CNBRNM                                             HUT110
     C                   Eval      SACB4 = CNCITY                                             HUT110
      *                                                                                     MD030805
      ** Load the valid CNAPS details into return valid work fields.                        MD030805
      *                                                                                       HUT110
     C                   Eval      WKACB1 = SACB1                                           MD030805
     C                   Eval      WKACB2 = SACB2                                           MD030805
     C                   Eval      WKACB3 = SACB3                                           MD030805
     C                   Eval      WKACB4 = SACB4                                           MD030805
     C                   Eval      WKACB5 = *Blanks                                         MD030805
      *                                                                                       HUT110
      ** Else, issue error message.                                                           HUT110
      *                                                                                       HUT110
     C                   Else                                                                 HUT110
     C                   Move      'N'           OKAcb1                                       HUT110
     C                   Add       1             Idx                                          HUT110
     C                   Movel     'SACB1'       FldNamXAr(Idx)                               HUT110
     C                   Movel     'XXX9101'     MsgIdXAr(Idx)                                HUT110
     C                   Eval      RetCodeIn = 'Error'                                        HUT110
     C                   Endif                                                                HUT110
      *                                                                                       HUT110
      ** Regardless of CNAPS validation error or not, skip rest of                            HUT110
      ** validation and return to calling program.                                            HUT110
      *                                                                                       HUT110
     C                   Return                                                               HUT110
      *                                                                                       HUT110
     C                   Endif                                                                HUT110
      *                                                                                       HUT110
     C                   Endif                                                                HUT110
      *                                                                                       HUT110
      *****************************************************************                       HUT110
      * End of /COPY HUT110_073                                       *                       HUT110
      *****************************************************************                       HUT110
