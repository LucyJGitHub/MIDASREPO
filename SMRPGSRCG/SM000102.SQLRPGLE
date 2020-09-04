     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Consolidate SQL deliveries')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000102 - Consolidate SQL Deliveries                        *
      *                                                               *
      *  Function:  This will merge SQL script deliveries in          *
      *             file SMSQLPQT                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. AR1076132*CREATE   Date 15Feb13               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1076132 - Automate SQL delivery deployment                 *
      *                                                               *
      *****************************************************************
      *                                                               *
     D*SQLFS            DS           260    Occurs(26)
     D* SQLF                          10
     DSQLFS            S             10A    DIM(26)
      *                                                               *
     DIdx              S              2  0
     DSrcQry           S            256A
      *****************************************************************
      *                                                               *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    SQLFS
     C                   PARM                    MODE              7
     C                   PARM                    CNT               2 0
      /free
 
       // ------------------------------------------------------------*
       //  M A I N                                                    |
       // ------------------------------------------------------------*
 
       Idx = 1;
       DoW SQLFS(Idx) <> '#' and Idx <= CNT;
           SrcQry = 'Insert into SMSQLPTD (SQLLINE, SQLZONE) ' +
                    '(Select SRCDTA, '''+ MODE  + ''' from ' + SQLFS(Idx) + ')';
           Exec SQL
                Prepare STM from :SrcQry;
           Exec SQL
                Execute STM;
 
           SrcQry = '';
 
           Idx += 1;
       EndDo;
 
       *INLR = *ON;
       Return;
 
      /end-free
