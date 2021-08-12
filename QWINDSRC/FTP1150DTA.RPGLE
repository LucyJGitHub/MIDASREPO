      *****************************************************************
      *                                                               *
      *  Midas - /COPY FTP1120                                        *
      *                                                               *
      *  FTP1150DTA- /COPY to Pass Data to Window Program             *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                 EEE065 *Create     Date 19Jan2005             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level      *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
      *
      ** Piece of source included by /COPY statement and used to
      ** pass data to the Window program
     D DATA            DS          1024
     D  I#Idks                             Like( CsIdks )
     D  I#Iban                             Like( CsIban )
     D  I#PCCY                             Like( CsPCCY )
     D  I#Ref1                             Like( CsRef1 )
     D  I#Ref2                             Like( CsRef2 )
      *****************************************************************
      * End of /COPY FTP1150DTA                                       *
      *****************************************************************
