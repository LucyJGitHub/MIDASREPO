      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  XXXXXXX - (/COPY Name)                                       *
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15               *
      *  Last Amend No. AR856737           Date 13Sep11               *
      *  Last Amend No. EEE065             Date 06Apr2004             *
      * Midas Release 4 --------------- Base -------------------------*
      *  Last Amend No. nnnnnn  *CREATE    Date ddmmmyy               *
      *  Prev Amend No. nnnnnn             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD31937  - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level      *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
      *
      *  Piece of source included by /COPY statement and used to
      *        pass data to the window program
      *
     D DATA            DS          1024
      *                                                                                       EEE065
     D  #1NWRK                 1      6
     D  #1MTPY                 7      9
     D  #1SNDK                10     29
      *
      *****************************************************************
      * End of /COPY XXXXXXX                                          *
      *****************************************************************
