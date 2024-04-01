      *****************************************************************
      *                                                               *
      *  Midas - STP Functions                                        *
      *                                                               *
      *  UUC104_016 -  Mapping for Mt101                              *
      *                                                               *
      *  Function: This function allows 101 to be processed as        *
      *            Mt103s                                             *
      *                                                               *
      *  Component of: *None                                          *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD059365           Date 06Dec21               *
      *  Prev Amend No. UUC104             Date 12Oct20               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059365 - Mis-aligned ME1540 copy sources                   *
      *  UUC104 - MPM Integration (Upgrade of 1.4.11.06 CAR UUC069)   *
      *                                                               *
      *****************************************************************
      *                                                                                       UUC104
     C********** UUC104    IFEQ 'Y'                                                  UUC104 MD059365
     C     UUC104        IFEQ      'Y'                                                      MD059365
      * Incoming payment                                                                      UUC104
     C********** #1PYTP    ANDNE'IN'                                                 UUC104 MD059365
     C     #1PYTP        ANDNE     'IN'                                                     MD059365
      * Outgoing payment                                                                      UUC104
     C********** #1PYTP    ANDNE'OP'                                                 UUC104 MD059365
     C     #1PYTP        ANDNE     'OP'                                                     MD059365
      * Not on                                                                                UUC104
     C********** UUC104    ORNE 'Y'                                                  UUC104 MD059365
     C     UUC104        ORNE      'Y'                                                      MD059365
      *                                                                                       UUC104
      *****************************************************************
