      *---------------------------------------------------------------*
      *   Last Amend No. MD031937           Date 13Jan15              *
      *   Prev Amend No. AR856737           Date 13Sep11              *
      *                  ESL038             Date 01Oct2004            *
      *                  EEE058   *Create   Date 05Feb2003            *
      *---------------------------------------------------------------*
      *                                                               *
      *   MD031937 - Upgrade STP enhancements to BF Midas 2.1         *
      *   AR856737 - Upgrade STP enhancements to Midas Plus level     *
      *   ESL038 - ING STP Development                                *
      *   EEE058 - Incoming STP                                       *
      *                                                               *
      *---------------------------------------------------------------*
      *
      *
      **  Check if to records exist
     C                   MOVEL     #2MTPY        #KMTPY
     C                   MOVE      #2MSET        #KMSET
     C     #HHKEY        CHAIN     FTGNEXV0                           61
     C                   UNLOCK    FTGNEXV0                                                   162428
     C                   MOVEL     *BLANKS       ##GNEX
     C     *IN61         IFEQ      '0'
     C                   MOVEL     'Y'           ##GNEX            1
     C                   ENDIF
      *
      **  Position to detail records to be copied
     C                   MOVEL     #1MTPY        #KMTPY
     C                   MOVE      #1MSET        #KMSET
     C     #HHKEY        CHAIN     FTGNEXV0                           61
     C                   UNLOCK    FTGNEXV0                                                   162428
     C*
     C**  Copy detail records
     C     *IN61         IFEQ      '0'
     C                   MOVEL     #2MTPY        GEMTPY
     C                   MOVE      #2MSET        GEMSET
     C     ##GNEX        IFNE      'Y'
     C                   WRITE     @GNEXV0                              99
     C                   ELSE
     C                   UPDATE    @GNEXV0                              99
     C                   ENDIF
     C                   ENDIF
     C*
      *
      *---------------------------------------------------------------*
      * copy hook end ME1540DB03                                      *
      *---------------------------------------------------------------*
