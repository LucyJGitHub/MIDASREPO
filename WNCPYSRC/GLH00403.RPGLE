      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001425)                              *
      *                                                               *
      *  GLH00403 - Midas GL Retrieve Postings by Network Account     *
      *                                                               *
      *  Last Amend No. MD058767        Date 07Sep21                  *
      *  Prev Amend No. UUC103 *CREATE  Date 20Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058767 - MT940s are producing many extra spaces in tag 86. *
      *             Upgraded CAR UUC061 fix MD030976.                 *
      *  UUC103 - Upgrade of CAR UUC061 to BF Midas 2.1               *
      *           UUC061 - SWIFT Statement Enhancement                *
      *                                                               *
      *****************************************************************
     D                 DS                                                       UUC103
     D FTREF                        350                                         UUC103
     D  FTREF1                 1     35A                                        UUC103
     D  FTREF2                36     70A                                        UUC103
     D  FTREF3                71    105A                                        UUC103
     D  FTREF4               106    140A                                        UUC103
     D  FTREF5               141    175A                                        UUC103
     D  FTREF6               176    210A                                        UUC103
     D  FTREF7               211    245A                                        UUC103
     D  FTREF8               246    280A                                        UUC103
     D  FTREF9               281    315A                                        UUC103
     D  FTREFA               316    350A                                        UUC103
      *
     D GLExtNarr       DS                                                       UUC103
      ** Data Structure used to concatenate the extended narratives             UUC103
     D   MGADI1                                                                 UUC103
     D   MGADI2                                                                 UUC103
     D   MGADI3                                                                 UUC103
     D   MGADI4                                                                 UUC103
     D   MGADI5                                                                 UUC103
     D   MGADI6                                                                 UUC103
     D   MGADXX                            dim(6) like(MGADI1)                              MD058767
     D                                     overlay(GLExtNarr)                               MD058767
     D wkftref         DS                                                                   MD058767
     D  wkftre1                      65                                                     MD058767
     D  wkftre2                      65                                                     MD058767
     D  wkftre3                      65                                                     MD058767
                                                                                            MD058767
     D   FTREFXX       S                   dim(4) like(FTREF1)                              MD058767
