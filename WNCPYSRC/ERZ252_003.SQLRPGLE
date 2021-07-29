      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  ERZ252_003 - Midas LE PDP Available Balance Computation      *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. ERZ252 *CREATE     Date 11Feb21               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  ERZ252 - Use External Account Balance in PDP                 *
      *****************************************************************
     D Spool1          ds                                                                     ERZ252
     D SFile1                 83     92                                                       ERZ252
     D SFNum1                123    124b 0                                                    ERZ252
     D OflLn1                188    189b 0                                                    ERZ252
     D PrtLn1                367    368b 0                                                    ERZ252
      *                                                                                       ERZ252
     D ExtBalFile    e ds                  extname(XXEXBLPD)                                  ERZ252
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  ERZ252
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  ERZ252
     D                                     OCCURS(250)                                        ERZ252
      *****************************************************************
