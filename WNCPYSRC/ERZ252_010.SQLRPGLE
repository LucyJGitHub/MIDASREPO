      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  ERZ252_010 - Midas LE PDP Available Balance Computation      *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. ERZ252 *CREATE     Date 11Feb21               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  ERZ252 - Use External Account Balance in PDP                 *
      *****************************************************************
      /EJECT                                                                                  ERZ252
      *****************************************************************                       ERZ252
      *                                                               *                       ERZ252
      *  FormatAmt - Formats a numeric amount                         *                       ERZ252
      *                                                               *                       ERZ252
      *****************************************************************                       ERZ252
     C     FormatAmt     BEGSR                                                                ERZ252
     C                   exsr      ZFRPED                                                     ERZ252
     C                   ENDSR                                                                ERZ252
     C/COPY ZSRSRC,ZFRPEDZ2LE                                                                 ERZ252
      *****************************************************************                       ERZ252
      /EJECT                                                                                  ERZ252
      ****************************************************************                        ERZ252
      *                                                              *                        ERZ252
      *   retrieveExtBal                                             *                        ERZ252
      *                                                              *                        ERZ252
      *   Called by: Main Processing                                 *                        ERZ252
      *                                                              *                        ERZ252
      *   Calls: None                                                *                        ERZ252
      *                                                              *                        ERZ252
      ****************************************************************                        ERZ252
     C     rtvExtBal     BEGSR                                                                ERZ252
      *                                                                                       ERZ252
     C                   eval      ExtBalFound = 'N'                                          ERZ252
      *                                                                                       ERZ252
     C                   eval      SEBRCA = CustomerDS(i).SEBRCA                              ERZ252
     C                   eval      SECNUM = CustomerDS(i).SECNUM                              ERZ252
     C                   eval      SEACCY = CustomerDS(i).SEACCY                              ERZ252
     C                   eval      SEACOD = CustomerDS(i).SEACOD                              ERZ252
     C                   eval      SEACSQ = CustomerDS(i).SEACSQ                              ERZ252
      *                                                                                       ERZ252
     C/exec SQL                                                                               ERZ252
     C+ select * into :ExtBalFile from XXEXBLPD                                               ERZ252
     C+ where XBRCA = :SEBRCA                                                                 ERZ252
     C+ and XCNUM = :SECNUM                                                                   ERZ252
     C+ and XCCY  = :SEACCY                                                                   ERZ252
     C+ and XACOD = :SEACOD                                                                   ERZ252
     C+ and XACSQ = :SEACSQ                                                                   ERZ252
     C/end-exec                                                                               ERZ252
      *                                                                                       ERZ252
     C                   if        sqlCod <> NO_ERROR and sqlCod <> NO_RECORD                 ERZ252
     C                   evalr     SEACODT = '0000000000' + %char(SEACOD)                     ERZ252
     C                   evalr     SEACSQT = '00' + %char(SEACSQ)                             ERZ252
     C                   eval      dBkey = SEBRCA + '-' + SECNUM + '-' +  SEACCY              ERZ252
     C                             + '-' + SEACODT + '-' + SEACSQT                            ERZ252
     C                   eval      dBfile = 'XXEXBLPD'                                        ERZ252
     C                   eval      dBase = 901                                                ERZ252
     C                   eval      dBpgm  = 'LE000495'                                        ERZ252
     C                   exsr      *pssr                                                      ERZ252
     C                   else                                                                 ERZ252
     C                   if        sqlCod <> NO_RECORD                                        ERZ252
     C                   eval      ExtBalFound = 'Y'                                          ERZ252
     C                   endif                                                                ERZ252
     C                   endif                                                                ERZ252
      *                                                                                       ERZ252
     C                   ENDSR                                                                ERZ252
      *
