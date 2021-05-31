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
      ** Work fields for RTGS processing                                                      HUT110
      *                                                                                       HUT110
     D RTGSNostro      C                   Const('RTGS_Nostros')                              HUT110
     D HUT110          S              1A                                                      HUT110
     D WRTGSNost       S            100A                                                      HUT110
     D WKRtgs          S              1A                                                      HUT110
     D WKCnaps         S              1A                                                      HUT110
     D WKNost          S              5A                                                      HUT110
     D WKPos           S              3P 0                                                    HUT110
     D PRetCode        S              7A                                                      HUT110
     D POption         S              7A                                                      HUT110
     D PKey1           S             10A                                                      HUT110
     D PKyst           S             10A                                                      HUT110
     D PCNAP           S             12A                                                      HUT110
     D C#ACCD          S             10                                                       HUT110
     D C#ACSN          S              2                                                       HUT110
     D C#BRCD          S              3                                                       HUT110
     D C#CSSN          S             10                                                       HUT110
     D C#CUST          S              6                                                       HUT110
     D C#KEY1          S             10                                                       HUT110
     D C#PNOI          S              1                                                       HUT110
     D K#ACNO          S                   LIKE(ACNO)                                         HUT110
     D WCNUMA          S              6                                                       HUT110
     D WCrossB         S              1                                                       HUT110
     D WCurr           S              3                                                       HUT110
     D WNosN           S              2                                                       HUT110
     D WKSwid          S             12                                                       HUT110
     D Nots            S              1                                                       HUT110
     D WKACB1          S             35A                                                      HUT110
     D WKACB2          S             35A                                                      HUT110
     D WKACB3          S             35A                                                      HUT110
     D WKACB4          S             35A                                                      HUT110
     D WKACB5          S             35A                                                      HUT110
                                                                                              HUT110
      *                                                                                       HUT110
      *****************************************************************                       HUT110
      * End of /COPY HUT110_072                                       *                       HUT110
      *****************************************************************                       HUT110
