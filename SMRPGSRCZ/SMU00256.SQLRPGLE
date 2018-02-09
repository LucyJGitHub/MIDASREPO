     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Update CLOANCL ORBR field')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  SMU00256 - Midas SM Upgrade for ORBR field in CLOANCL        *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. MD023442A*CREATE   Date 02Jan14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD023442A - Update CLOANCL->ORBR field for Facility Fees     *
      *                                                               *
      *****************************************************************
      *
     DCLON           E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(WK_)
     D BRANCH          S              3
     DCOUNT            S              5  0
      *
      ** +--- Start of Main processing -----------------------------------+
      **                                                                  *
      **   Initial processing is performed automatically: the *INZSR is   *
      **   executed at program activation.                                *
      **                                                                  *
      ** +----------------------------------------------------------------+
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode              1

      /free
       EXEC SQL
          alter table CLOANTMP
          add column febrca char(3);

       EXEC SQL
          declare Pcursor cursor for
          Select a.*, c.febrca
          From CLOANCL a, lepdufpd b, lefeed c
          Where a.ltyp like 'Z%'
          And b.yplon  = a.lnrf
          And b.yefacl = c.fefacl
          And b.yporg  = ''
          And b.yecnum = c.fecnum
          And b.yeseq  = c.fefseq
          And a.orbr   <> c.febrca;

       EXEC SQL Open Pcursor;

       EXEC SQL
          Fetch NEXT from Pcursor into :CLON,:BRANCH;

          Count = 0;

          DoW SQLCODE = 0;
              Count = Count + 1;

              If Mode = 'L';
                 Exsr SrInsert;
              Else;
                 Exsr SrUpdate;
              Endif;

              EXEC SQL
                   Fetch NEXT from Pcursor into :CLON,:BRANCH ;

           EndDo;

        EXEC SQL
        Close Pcursor;

        *INLR = *ON;
        Return;

       //-------------------------------------------------------------*
       // SrInsert - Insert fields to CLOANTMP                        *
       //-------------------------------------------------------------*
         BegSr SrInsert;
         Exec SQL
              Insert into CLOANTMP
               Values (:CLON,:BRANCH);
         EndSr;
       //-------------------------------------------------------------*
       // SrUpdate - Update CLOANCL fields                            *
       //-------------------------------------------------------------*
         BegSr SrUpdate;
         If WK_LNRF <> *blanks;
            Exec SQL
            Update CLOANCL
            Set Orbr  = :BRANCH
             where CLOANCL.lnrf = :WK_LNRF;
         Endif;
         EndSr;
