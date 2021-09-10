      *****************************************************************
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                 ESL038             Date 01Oct04               *
      *                 EEE058             Date 10Feb03               *
      *                 EEE065   *CREATE   Date 26Aug03               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level      *
      *  ESL038 - ING STP Development                                 *
      *  EEE058 - Incoming STP                                        *
      *  EEE065 - Polish Features Upgrade R4                          *
      *                                                               *
      *****************************************************************
      *                                                                         EEE058
     D PCRITX        E DS                  EXTNAME(FTGNEXP0)                    EEE058
      *                                                                         EEE058
      *                                                                         EEE058
     D P9PEXT        E DS                  EXTNAME(FTPEXTP0)                    EEE058
      *                                                                         EEE058
     D P8PARM          DS                                                       EEE058
      * O :  Message reference                                                  EEE058
     D  P8MSGR                 1      8  0                                      EEE058
      *                                                                         EEE058
      * O :  Message part                                                       EEE058
     D  P8KPRT                 9     11  0                                      EEE058
