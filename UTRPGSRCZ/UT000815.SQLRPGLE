     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('CGL002 Initialization Program')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  UT000815 - CGL002 Initialization Program                     *
      *                                                               *
      *  Function: The purpose of the pgm is to Add the Action Code O *
      *            in the Menu Item for Journal Entry                 *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD049728A          Date 02Jun18               *
      *  Prev Amend No. MD049728 *CREATE   Date 12Mar18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD049728A - Fix did not include insert for WebFaced menu.    *
      *  MD049728 - CGL002 Initialization program to insert Action    *
      *             code O                                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D StrippedINDX    S             10
     D ActionCode      S              1
     D MIAAC           S              2  0
     D PermType        S              8

     D RECCNT          S              2  0
     D PERMM         E DS                  EXTNAME(MITB_PERMM)
     D SFMNU         E DS                  EXTNAME(SFMENUPD)
     D  ACTION               158    167
     D  MIAC1                158    158
     D  MIAC2                159    159
     D  MIAC3                160    160
     D  MIAC4                161    161
     D  MIAC5                162    162
     D  MIAC6                163    163
     D  MIAC7                164    164
     D  MIAC8                165    165
     D  MIAC9                166    166
     D  MIAC10               167    167
     D  XMARTF         S                   LIKE(PMARTF)
     D  XMARTD         S                   LIKE(PMARTD)

      /free

       PermType = 'MI_CORE_';
       StrippedINDX = '0000001638';
       ActionCode = 'O';
       XMARTF = 'MI_MNU_CORE_0000001638_JournalEntry_O';
       XMARTD = 'GeneralLedger JournalEntry O';

       EXEC SQL
        set option commit = *CHG;

       // Process SFMENUPD. Add Action Code 'O' if not existing.

       EXEC SQL
       // Start of MD049728A
       // Declare SFcursor cursor for
        Declare SFcursor1 cursor for
       // End of MD049728A
        Select *
        from SFMENUPD
        where MIINDX = :StrippedINDX;

       EXEC SQL
       // Start of MD049728A
       // Open SFcursor;
        Open SFcursor1;
       // End of MD049728A

       EXEC SQL
        Fetch Next
       // Start of MD049728A
       // from SFcursor
        from SFcursor1
       // End of MD049728A
        into :SFMNU;

       // Check SFMENUPD for existence of Acton Code 'O'

       If SQLCode = 0;
          MIAC1 = MIAAC1;
          MIAC2 = MIAAC2;
          MIAC3 = MIAAC3;
          MIAC4 = MIAAC4;
          MIAC5 = MIAAC5;
          MIAC6 = MIAAC6;
          MIAC7 = MIAAC7;
          MIAC8 = MIAAC8;
          MIAC9 = MIAAC9;
          MIAC10 = MIAAC10;
          MIAAC = %SCAN (ActionCode : ACTION);

          // If Action Code 'O' is not found, check for next available blank Action Code Field

          If MIAAC = 0;
             MIAAC = %SCAN (' ' : ACTION);

             // If All Action Code Fields are used then fail and exit program

             If MIAAC = 0;
               ExSR *PSSR;
             Else;
               ACTION = %REPLACE (ActionCode : ACTION : MIAAC : 1);
               EXEC SQL
                 Update SFMENUPD set
                   MIAAC1 = :MIAC1,
                   MIAAC2 = :MIAC2,
                   MIAAC3 = :MIAC3,
                   MIAAC4 = :MIAC4,
                   MIAAC5 = :MIAC5,
                   MIAAC6 = :MIAC6,
                   MIAAC7 = :MIAC7,
                   MIAAC8 = :MIAC8,
                   MIAAC9 = :MIAC9,
                   MIAAC10 = :MIAC10
                 where MIINDX = :StrippedINDX;
             EndIf;

             // Process MITB_PERMM. Insert Permission for Action Code 'O'

             EXEC SQL
              // Start of MD049728A
              // Declare PEcursor cursor for
              Declare PEcursor1 cursor for
              // End of MD049728A
              Select count(*)
              from MITB_PERMM
                where PMINDX = :StrippedINDX and PMACTC = :ActionCode;

             EXEC SQL
              // Start of MD049728A
              // Open PEcursor;
              Open PEcursor1;
              // End of MD049728A

             EXEC SQL
              Fetch Next
              // Start of MD049728A
              // from PEcursor
              from PEcursor1
              // End of MD049728A
              into :RECCNT;

             EXEC SQL
              // Start of MD049728A
              // Close PEcursor;
              Close PEcursor1;
              // End of MD049728A

             // If Permission is NOT found in MITB_PERMM then
             // proceed with INSERT into BFTC tables
             If RECCNT = 0;
                EXEC SQL
                  Insert into MITB_PERMM
                    Values (
                      :StrippedINDX, :ActionCode, :XMARTF, :XMARTD);

                If SQLCode = 0;
                   EXEC SQL
                    Insert into BFTB_RESOURCE (
                     BFIDPK, BFARTEFACTID, BFTYPE,
                     BFDISPLAYNAME, BFDESCRIPTION,
                     BFSCMVERSION
                     )
                    Values (
                     concat('MI', concat(:StrippedINDX, :ActionCode)),
                     :XMARTF, 101, :XMARTD, :XMARTD,
                     'UNVERSIONED'
                    );

                   EXEC SQL
                    Insert into BFTB_PERMISSION (
                      BFIDPK, BFPERMISSIONNAME, BFLONGDESCRIPTION,
                      VERSIONNUM, BFSHORTDESCRIPTION, BFALLOWINOFFLINE,
                      BFREADONLY)
                    Values (
                      concat('MI', concat(:StrippedINDX, :ActionCode))
                    , concat(concat(concat(
                        replace(replace(:PermType,'*',''),'O','')
                        , :StrippedINDX),'_'),:ActionCode)
                    , :XMARTD, 0, :XMARTD, 1, 1
                    );

                   EXEC SQL
                    Insert into BFTB_RESOURCEPERM (
                      BFIDPK, BFRESOURCEID, BFPERMISSIONID, VERSIONNUM)
                    Values (
                      concat('MIRP', concat(:StrippedINDX, :ActionCode))
                    , :XMARTF
                    , concat('MI', concat(:StrippedINDX, :ActionCode))
                    , 1
                    );
                EndIf;

             EndIf;

          EndIf;
       Else;
          ExSR *PSSR;
       EndIf;

       EXEC SQL
       // Start of MD049728A
       // Close SFcursor;
        Close SFcursor1;

       StrippedINDX = '0000005140';
       XMARTF = 'MI_MNU_CORE_0000005140_JournalEntry_O';
       XMARTD = 'JournalEntry O';

       // Process SFMENUPD. Add Action Code 'O' if not existing.

       EXEC SQL
        Declare SFcursor2 cursor for
        Select *
        from SFMENUPD
        where MIINDX = :StrippedINDX;

       EXEC SQL
        Open SFcursor2;

       EXEC SQL
        Fetch Next
        from SFcursor2
        into :SFMNU;

       // Check SFMENUPD for existence of Acton Code 'O'

       If SQLCode = 0;
          MIAC1 = MIAAC1;
          MIAC2 = MIAAC2;
          MIAC3 = MIAAC3;
          MIAC4 = MIAAC4;
          MIAC5 = MIAAC5;
          MIAC6 = MIAAC6;
          MIAC7 = MIAAC7;
          MIAC8 = MIAAC8;
          MIAC9 = MIAAC9;
          MIAC10 = MIAAC10;
          MIAAC = %SCAN (ActionCode : ACTION);

          // If Action Code 'O' is not found, check for next available blank Action Code Field

          If MIAAC = 0;
             MIAAC = %SCAN (' ' : ACTION);

             // If All Action Code Fields are used then fail and exit program

             If MIAAC = 0;
               ExSR *PSSR;
             Else;
               ACTION = %REPLACE (ActionCode : ACTION : MIAAC : 1);
               EXEC SQL
                 Update SFMENUPD set
                   MIAAC1 = :MIAC1,
                   MIAAC2 = :MIAC2,
                   MIAAC3 = :MIAC3,
                   MIAAC4 = :MIAC4,
                   MIAAC5 = :MIAC5,
                   MIAAC6 = :MIAC6,
                   MIAAC7 = :MIAC7,
                   MIAAC8 = :MIAC8,
                   MIAAC9 = :MIAC9,
                   MIAAC10 = :MIAC10
                 where MIINDX = :StrippedINDX;
             EndIf;

             // Process MITB_PERMM. Insert Permission for Action Code 'O'

             EXEC SQL
              Declare PEcursor2 cursor for
              Select count(*)
              from MITB_PERMM
                where PMINDX = :StrippedINDX and PMACTC = :ActionCode;

             EXEC SQL
              Open PEcursor2;

             EXEC SQL
              Fetch Next
              from PEcursor2
              into :RECCNT;

             EXEC SQL
              Close PEcursor2;

             // If Permission is NOT found in MITB_PERMM then
             // proceed with INSERT into BFTC tables
             If RECCNT = 0;
                EXEC SQL
                  Insert into MITB_PERMM
                    Values (
                      :StrippedINDX, :ActionCode, :XMARTF, :XMARTD);

                If SQLCode = 0;
                   EXEC SQL
                    Insert into BFTB_RESOURCE (
                     BFIDPK, BFARTEFACTID, BFTYPE,
                     BFDISPLAYNAME, BFDESCRIPTION,
                     BFSCMVERSION
                     )
                    Values (
                     concat('MI', concat(:StrippedINDX, :ActionCode)),
                     :XMARTF, 101, :XMARTD, :XMARTD,
                     'UNVERSIONED'
                    );

                   EXEC SQL
                    Insert into BFTB_PERMISSION (
                      BFIDPK, BFPERMISSIONNAME, BFLONGDESCRIPTION,
                      VERSIONNUM, BFSHORTDESCRIPTION, BFALLOWINOFFLINE,
                      BFREADONLY)
                    Values (
                      concat('MI', concat(:StrippedINDX, :ActionCode))
                    , concat(concat(concat(
                        replace(replace(:PermType,'*',''),'O','')
                        , :StrippedINDX),'_'),:ActionCode)
                    , :XMARTD, 0, :XMARTD, 1, 1
                    );

                   EXEC SQL
                    Insert into BFTB_RESOURCEPERM (
                      BFIDPK, BFRESOURCEID, BFPERMISSIONID, VERSIONNUM)
                    Values (
                      concat('MIRP', concat(:StrippedINDX, :ActionCode))
                    , :XMARTF
                    , concat('MI', concat(:StrippedINDX, :ActionCode))
                    , 1
                    );
                EndIf;

             EndIf;

          EndIf;
       Else;
          ExSR *PSSR;
       EndIf;

       EXEC SQL
        Close SFcursor2;

        // End of MD049728A

       EXEC SQL
        Commit;

       Eval *INLR = *ON;
       Return;

      /end-free

      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BegSR

     C                   Dump
      /free

        EXEC SQL
         Rollback;
        Eval *INU7 = *ON;
        Eval *INU8 = *ON;
        Eval *INLR = *ON;
        Return;
      /end-free
     C                   EndSR
