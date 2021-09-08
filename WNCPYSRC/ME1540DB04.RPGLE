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
      **  Position to detail records to be copied                                             EEE058
     C                   MOVEL     #1MTPY        #KMTPY                                       EEE058
     C                   MOVE      #1MSET        #KMSET                                       EEE058
     C     #HHKEY        CHAIN     FTGNEXV0                           61                      EEE058
     C*                                                                                       EEE058
     C**  Delete extension record                                                             EEE058
     C     *IN61         IFEQ      '0'                                                        EEE058
     C                   DELETE    @GNEXV0                              99                    EEE058
     C     *IN99         IFEQ      '1'                                                        EEE058
     C                   MOVE      'N'           #HOK                                         EEE058
     C                   ENDIF                                                                EEE058
     C                   ENDIF                                                                EEE058
     C*                                                                                       EEE058
      *
      *---------------------------------------------------------------*
      * copy hook end ME1540DB04                                      *
      *---------------------------------------------------------------*
