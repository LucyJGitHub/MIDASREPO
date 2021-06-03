      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  XXXXXXX - (/COPY Name)                                       *
      *                                                               *
      *  Last Amend No. MD056888 *CREATE   Date 20Sep20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056888 - Deliverable Data Split for SDCODEPD               *
      *                                                               *
      *****************************************************************
      *
      *  Set up search occurrance data structure
      *
      *  The structurce LKCODE has 20 elements and they are used
      *  to search the SWIFT Codewords file SDCODEPD for a codeword
      *  to be valid. The elements are searched in ascending sequence.
      *
      *  The LKCODE structure has four one byte flags which identify a
      *  key field. If the flag is "Y" then the field is set to that
      *  on the reference record being processed. This then gives
      *  the key to search the database. '*' in Codewords stands for
      *  codeword *ALL
      *
      *  Position     Field to be filled for key
      *
      *     1         I#SWCD - Swift Codeword
      *     2         I#MTYP - Message Type
      *     3         I#MMOD - Midas Module
      *     4         I#DSCN - Destination Customer
      *
      *  Load search occurrance data structure
      *
     C     1             OCCUR     LKCODE
     C                   MOVEL     'YYYY'        LKCODE
     C     2             OCCUR     LKCODE
     C                   MOVEL     'YNYY'        LKCODE
     C     3             OCCUR     LKCODE
     C                   MOVEL     'YNNY'        LKCODE
     C     4             OCCUR     LKCODE
     C                   MOVEL     '*NNY'        LKCODE
     C     5             OCCUR     LKCODE
     C                   MOVEL     'YYYN'        LKCODE
     C     6             OCCUR     LKCODE
     C                   MOVEL     'YNYN'        LKCODE
     C     7             OCCUR     LKCODE
     C                   MOVEL     'YNNN'        LKCODE
     C     8             OCCUR     LKCODE
     C                   MOVEL     '*NYN'        LKCODE
     C     9             OCCUR     LKCODE
     C                   MOVEL     '*NNN'        LKCODE
      * set number set up
     C                   Z-ADD     9             L#NBR
      *****************************************************************
      * End of /COPY XXXXXXX                                          *
      *****************************************************************
