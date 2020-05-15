      *****************************************************************                       EML102
      *                                                               *                       EML102
      *  Midas - /COPY Member GL001425                                *                       EML102
      *                                                               *                       EML102
      *  EML102_011 - Midas GL Retrieve Postings by Network Account   *                       EML102
      *                                                               *                       EML102
      *  Last Amend No. EML104             Date 04Feb20               *                       EML104
      *  Prev Amend No. EML102  *CREATE    Date 22Nov19               *                       EML102
      *                                                               *                       EML102
      *---------------------------------------------------------------*                       EML102
      *                                                               *                       EML102
      *  EML104 - Upgrade of EML010 to FB2.1 SP21                     *                       EML104
      *      EML010 - Structured field :86:                           *                       EML104
      *  EML102 - Upgrade of UNL007 to FB21 SP21                      *                       EML102
      *      UNL007 - Extended Narratives                             *                       EML102
      *                                                               *                       EML102
      *****************************************************************                       EML102
     D EML104          S              1                                         Feature       EML104
     D Idx             S              5U 0                                      Index         EML104
     D IdxNw           S              5U 0 INZ(1000)                            Index Network EML104
     D PNwrk           S                   LIKE(EDNWRK)                         Network       EML104
     D SpAddInfo       S                   LIKE(MGADI1to6)                      Sp Add Info   EML104
     D SvMGADI1to6     S                   LIKE(MGADI1to6)                      Save Add. InfoEML104
      *                                                                                       EML104
      *                                                                                       EML102
      ** Array for additional information                                                     EML102
     D Ar_AddInf       S             65    DIM(6)                                             EML102
      *                                                                                       EML102
      ** Array for Extended information                                                       EML102
     D                 DS                                                                     EML102
     D FNA02                                                                                  EML102
     D FNA03                                                                                  EML102
     D FNA04                                                                                  EML102
     D FNA05                                                                                  EML102
     D FNA06                                                                                  EML102
     D FNA07                                                                                  EML102
     D FNA08                                                                                  EML102
     D FNA09                                                                                  EML102
     D FNA10                                                                                  EML102
     D FNA11                                                                                  EML102
     D FNA12                                                                                  EML102
     D FNA13                                                                                  EML102
     D FNA14                                                                                  EML102
     D FNA15                                                                                  EML102
     D FNA16                                                                                  EML102
     D FNA17                                                                                  EML102
     D Ar_ExtInf               1    560    DIM(16)                                            EML102
      *                                                                                       EML102
      *****************************************************************                       EML102
      * End of /COPY EML102_011                                       *                       EML102
      *****************************************************************                       EML102
