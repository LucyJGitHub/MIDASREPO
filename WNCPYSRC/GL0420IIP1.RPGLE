      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL0420)                                *
      *                                                               *
      *  GL0420IIP1 - Midas GL Balance Statements                     *
      *                                                               *
      *  Last Amend No. UUC102 *CREATE  Date 16Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC102 - Upgrade of CAR UUC063 to BF Midas 2.1               *
      *           UUC063 - Balance Statement Enhancement              *
      *                                                               *
      *****************************************************************
      *                                                                         UUC102
      * DATA STRUCTURE FOR THE SOURCE OF POSTING (PNAR) FOR APOSTPDF            UUC102
      *                                                                         UUC102
     D                 DS                                                       UUC102
     D  PNAR                   1     30                                         UUC102
     D  @DTA                  24     24                                         UUC102
     D  BTNB                  25     27                                         UUC102
     D  BINB                  28     30  0                                      UUC102
     D  BINN                  28     30                                         UUC102
      *                                                                         UUC102
      *                                                                         UUC102
      * DATA STRUCTURE FOR THE LIST OF OTHER REFERENCES FROM CXT0100A           UUC102
      *                                                                         UUC102
     D FTREF           DS                                                       UUC102
     D  FTREF1                 1     35                                         UUC102
     D  FTREF2                36     70                                         UUC102
     D  FTREF3                71    105                                         UUC102
     D  FTREF4               106    140                                         UUC102
     D  FTREF5               141    175                                         UUC102
     D  FTREF6               176    210                                         UUC102
     D  FTREF7               211    245                                         UUC102
     D  FTREF8               246    280                                         UUC102
     D  FTREF9               281    315                                         UUC102
     D  FTREFA               316    350                                         UUC102
      *                                                                         UUC102
     D APOSTX          DS                                                       UUC102
     D  LOTP                   1    170                                         UUC102
     D  LOTP2                171    289                                         UUC102
      *                                                                         UUC102
