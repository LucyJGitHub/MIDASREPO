      *****************************************************************                       HUT110
      *                                                               *                       HUT110
      *  Midas - /COPY Member FTVXVXV                                 *                       HUT110
      *                                                               *                       HUT110
      *  FTVXVXV - Midas FT Validate cross-validations                *                       HUT110
      *                                                               *                       HUT110
      *  Last Amend No. HUT110  *CREATE    Date 21Apr20               *                       HUT110
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
      *                                                                                       HUT110
      *****************************************************************                       HUT110
      * End of /COPY HUT110_084                                       *                       HUT110
      *****************************************************************                       HUT110
