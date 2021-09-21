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
     C     KYGNCR        CHAIN     @GNEXV0                            90                      EEE058
     C     *IN90         IFEQ      *ON                                                        EEE058
     C                   CLEAR                   PCRITX                                       EEE058
     C                   ELSE                                                                 EEE058
      *                                                                                       EEE058
      * Log queue name                                                                        EEE058
     C                   Z-ADD     PHMSGR        P8MSGR                                       EEE058
     C                   Z-ADD     PHPART        P8KPRT                                       EEE058
      *                                                                                       EEE058
     C                   CALL      'MEP1111'                                                  EEE058
     C                   PARM      *BLANKS       P8RTN             7                          EEE058
     C                   PARM                    P8PARM                                       EEE058
     C                   PARM      GESTPQ        P8STPQ           20                          EEE058
     C                   ENDIF                                                                EEE058
      *
      *---------------------------------------------------------------*
      * copy hook end ME1540DB02                                      *
      *---------------------------------------------------------------*
