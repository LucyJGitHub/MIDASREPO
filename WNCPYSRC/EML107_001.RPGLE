      *****************************************************************
      *  Start of /COPY EML107_001                                    *
      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  MG000940 - Midas MG MT940 Message Generation                 *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. EML107   *Create   Date 08May20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML107 - Output IBAN in Sender Account Number field          *
      *                                                               *
      *****************************************************************
                                                                                              EML107
     C                   When      MGIBAN <> *Blank                                           EML107
     C                             and EML107 = 'Y'                                           EML107
     C                   Movel     MGIBAN        SACN                                         EML107
     C                   Movel     *blanks       AORR                                         EML107
                                                                                              EML107
      *****************************************************************
      *  End of /COPY EML107_001                                      *
      *****************************************************************
