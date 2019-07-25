     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*XBIA*  CRTSRCPF FILE(QTEMP/CRTOBJSQF) RCDLEN(112) MBR(CRTOBJSQL)    *
/*XBIB*  RNMOBJ OBJ(QTEMP/CRTOBJSQF) OBJTYPE(*FILE)                   *
/*XBIB*  NEWOBJ(CRTOBJSQL)                                            *
/*S*D ***RPGBASEBND****************************************************                     MD029086
/*STD *  RPGSQLBND                                                    *                     MD029086
/*EXI *  TEXT('Midas UP Duplicate *REFZONE records for T_WIPCF')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP001704 - Duplicate *REFZONE Records for T_WIPCF            *
      *                                                               *
      *  Function:  This program duplicates all *REFZONE records      *
      *             in T_WIPCF and created new versions of them       *
      *             with *REFZONE replaced with the zone name.        *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD029086           Date 21Aug14               *
      *  Prev Amend No. BUG27884           Date 08Jul10               *
      *                 BUG15756           Date 05Feb08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG18305           Date 21Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK025             Date 18May06               *
      *                 CGP009             Date 22Dec04               *
      *                 BG4033  *MOVED     Date 17Aug04               *
      *                 CUP026  *CREATE    Date 20Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029086 - Running of UPT_WIPCF encountered duplicate errors *
      *  BUG27884 - Applied 15756.                                    *
      *  BUG15756 - To retain 'GLOBAL' value in WC_ZONE.              *
      *  BUG18305 - Zone initialisation fails                         *
      *  CPK025 - Bugs 5033 & 10326 changed T_WIPCF field definition. *
      *  CGP009 - Local Zone Time Difference (Recompile)              *
      *  BG4033 - Amend program to initialise T_WIPCF for all zones   *
      *           in a single execution.                              *
      *         - Move from zone to global layer.                     *
      *  CUP026 - New program to initialise T_WIPCF.                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutines                                                  *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *****************************************************************
     FCRTOBJSQL IF A E             DISK    USROPN

      * General variables

     D CommandString   S             80
     D Wrun            S              1

      * QCMDEXC parameters

     D CmdStrRunSQL    S             66
     D CmdLenRunSQL    S             15  5 INZ(66)
     D CmdStrClrSQL    S             37
     D CmdLenClrSQL    S             15  5 INZ(37)
     D CmdStrMAXSQL    S             40                                                     MD029086
     D CmdLenMAXSQL    S             15  5 INZ(40)                                          MD029086
     D CmdStr10kSQL    S             42                                                     MD029086
     D CmdLen10kSQL    S             15  5 INZ(42)                                          MD029086
      *
     D myWC_ID         S              9  0                                                  MD029086

      * SQL statment building blocks for delete processing

     D*DeleteString****C***                'DELETE FROM T_WIPCF WHERE WC_ZONE ='              BG4033
     D DeleteString01  C                   'DELETE FROM T_WIPCF WHERE WC_ZONE '               BG4033
     D*DeleteString02  C                   '!= '''' AND WC_ZONE IS NOT NULL AND'     BG4033 BUG18305
     D*DeleteString03  C                   ' WC_ZONE != '                            BG4033 BUG18305
     D DeleteString02  C                   '<> '''' AND WC_ZONE IS NOT NULL AND'            BUG18305
     D DeleteString03  C                   ' WC_ZONE <> '                                   BUG18305

      * SQL statment building blocks for alter processing                                     BG4033
                                                                                              BG4033
     D AlterString01   C                   'ALTER TABLE T_WIPCF ALTER COLUMN '                BG4033
     D***AlterString02   C                   'WC_ID RESTART WITH 1000'               BG4033 MD029086
     D AlterString02   C                   'WC_ID restart with 10000'                       MD029086
                                                                                              BG4033
      * SQL statment building blocks for insert processing

     D InsertString01  C                   'INSERT INTO T_WIPCF'
     D InsertString02  C                   'OVERRIDING USER VALUE'
     D InsertString03  C                   '(SELECT (SELECT MAX(WC_ID) FROM '
     D InsertString04  C                   'T_WIPCF) +1 AS WC_ID,WC_API,'
     D InsertString05  C                   'WC_CAT,WC_BONSTP,'
     D InsertString06  C                   'WC_BOASTP,WC_BOAC,WC_BOACNE,'
     D InsertString07  C                   'WC_BOACAM,WC_BOACAU,WC_BOACCL,'
     D*InsertString08**C****               'WC_BOACDE,WC_BOACRE,WC_AUTOA,'                    CPK025
     D InsertString08  C                   'WC_BOACDE,WC_BOACRE,WC_BOACCH,'                   CPK025
     D InsertString8a  C                   'WC_AUTOA,'                                        CPK025
     D*InsertString09**C***                'WC_AUTLVL,'                                       BG4033
     D*InsertString10**C***                ' AS WC_ZONE,WC_SYSTEM'                            BG4033
     D*InsertString11**C***                'FROM T_WIPCF WHERE WC_ZONE = '                    BG4033
     D InsertString09  C                   'WC_AUTLVL,ZOZONE AS WC_ZONE,'                     BG4033
     D*InsertString10**C***                'WC_SYSTEM FROM T_WIPCF,GPZONEPD'           BG4033 CPK025
     D*InsertString11**C***                'WHERE WC_ZONE = '                          BG4033 CPK025
     D InsertString10  C                   'WC_SYSTEM, WC_BOFLD1, WC_BOFLD2,'                 CPK025
     D InsertString11  C                   'WC_BOFLD3, WC_BOFLD4, WC_BOFLD5 '                 CPK025
     D InsertString12  C                   'FROM T_WIPCF,GPZONEPD '                           CPK025
     D InsertString13  C                   'WHERE WC_ZONE = '                                 CPK025

      * RUNSQL statement building blocks

     D RUNSQL_Cmd      C                   'RUNSQLSTM SRCFILE(QTEMP/CRTOBJSQL) +
     D                                     SRCMBR(CRTOBJSQL) COMMIT(*NONE)'

      * CLRPFM statement building blocks

     D CLRSQL_Cmd      C                   'CLRPFM FILE(CRTOBJSQL) +
     D                                     MBR(CRTOBJSQL)'
      *
      * RESETMAXID statement building blocks                                                MD029086
     D RRSTMAX_Cmd     C                   'RESETMAXID FILE(T_WIPCF) +                      MD029086
     D                                     RSTOPT(*RSTMAX)'                                 MD029086
     D RRST10k_Cmd     C                   'RESETMAXID FILE(T_WIPCF) +                      MD029086
     D                                     RSTOPT(10000)'                                   MD029086
      *
      **Entry*parameters***********************************************************           BG4033
      **********                                                                              BG4033
     C******ENTRY        PLIST                                                                BG4033
     C**********         PARM                    ZoneName         10                          BG4033

     C/exec sql whenever sqlerror go to TAGSQLERR                                           MD029086
     C/end-exec                                                                             MD029086
      *
     C                   EVAL      CmdStrRunSQL = RUNSQL_Cmd
     C                   EVAL      CmdStrClrSQL = CLRSQL_Cmd
     C                   EVAL      CmdStrMAXSQL = RRSTMAX_Cmd                               MD029086
     C                   EVAL      CmdStr10kSQL = RRST10k_Cmd                               MD029086

      * Create the work SRCPF in QTEMP

     C                   CALL      'UPC000798'

      * Clear the SQL member
      *
     C                   CALL      'QCMDEXC'
     C                   PARM                    CmdStrClrSQL
     C                   PARM                    CmdLenClrSQL

      * Build the SQL row deletion statement

     C                   OPEN      CRTOBJSQL

     C**********         EVAL      CommandString = DeleteString + ' ' +                       BG4033
     C**********                   '''' + ZoneName + ''''                                     BG4033
                                                                                              BG4033
      * Delete command line 1                                                                 BG4033
                                                                                              BG4033
     C                   EVAL      SRCDTA = *BLANKS                                           BG4033
     C                   EVAL      SRCDTA = DeleteString01                                    BG4033
                                                                                              BG4033
     C                   WRITE     CRTOBJSQF                                                  BG4033
                                                                                              BG4033
      * Delete command line 2                                                                 BG4033
                                                                                              BG4033
     C                   EVAL      SRCDTA = *BLANKS                                           BG4033
     C                   EVAL      SRCDTA = DeleteString02                                    BG4033
                                                                                              BG4033
     C                   WRITE     CRTOBJSQF                                                  BG4033
                                                                                              BG4033
      * Delete command line 3                                                                 BG4033
                                                                                              BG4033
     C                   EVAL      SRCDTA = *BLANKS                                           BG4033
     C                   EVAL      SRCDTA = DeleteString03 +                                  BG4033
     C**********                   '''' + '*REFZONE' + ''''                          BG4033 BUG15756
     C                             '''' + '*REFZONE' + '''' +                               BUG15756
     C                             ' AND WC_ZONE <>' +                                      BUG15756
     C                             '''' + 'GLOBAL' + ''''                                   BUG15756
                                                                                              BG4033
     C                   WRITE     CRTOBJSQF                                                  BG4033

     C                   EVAL      SRCDTA = CommandString

     C                   WRITE     CRTOBJSQF

      * Execute the SQL row deletion statement

     C                   CLOSE     CRTOBJSQL

     C                   CALL      'QCMDEXC'
     C                   PARM                    CmdStrRunSQL
     C                   PARM                    CmdLenRunSQL
      *
     C/exec sql                                                                             MD029086
     C+    select max(WC_ID) into :myWC_ID                                                  MD029086
     C+    from T_WIPCF                                                                     MD029086
     C/end-exec                                                                             MD029086
      *
     C                   IF        myWC_ID > 1000                                           MD029086
     C                   CALL      'QCMDEXC'                                                MD029086
     C                   PARM                    CmdStrMAXSQL                               MD029086
     C                   PARM                    CmdLenMAXSQL                               MD029086
     C                   ELSE                                                               MD029086
     C                   CALL      'QCMDEXC'                                                MD029086
     C                   PARM                    CmdStr10kSQL                               MD029086
     C                   PARM                    CmdLen10kSQL                               MD029086
     C                   ENDIF                                                              MD029086

      * Clear the SQL member                                                                  BG4033
      *                                                                                       BG4033
     C                   CALL      'QCMDEXC'                                                  BG4033
     C                   PARM                    CmdStrClrSQL                                 BG4033
     C                   PARM                    CmdLenClrSQL                                 BG4033
                                                                                              BG4033
      * Build the SQL row alter statement                                                     BG4033
                                                                                              BG4033
     C                   OPEN      CRTOBJSQL                                                  BG4033
                                                                                              BG4033
      * Alter command line 1                                                                  BG4033
                                                                                              BG4033
     C                   EVAL      SRCDTA = *BLANKS                                           BG4033
     C                   EVAL      SRCDTA = AlterString01                                     BG4033
                                                                                              BG4033
     C                   WRITE     CRTOBJSQF                                                  BG4033
                                                                                              BG4033
      * Alter command line 2                                                                  BG4033
                                                                                              BG4033
     C                   EVAL      SRCDTA = *BLANKS                                           BG4033
     C                   EVAL      SRCDTA = AlterString02                                     BG4033
                                                                                              BG4033
     C                   WRITE     CRTOBJSQF                                                  BG4033
                                                                                              BG4033
      * Execute the SQL row alter statement                                                   BG4033
                                                                                              BG4033
     C                   CLOSE     CRTOBJSQL                                                  BG4033
                                                                                              BG4033
     C                   CALL      'QCMDEXC'                                                  BG4033
     C                   PARM                    CmdStrRunSQL                                 BG4033
     C                   PARM                    CmdLenRunSQL                                 BG4033

      * Clear the SQL member

     C                   CALL      'QCMDEXC'
     C                   PARM                    CmdStrClrSQL
     C                   PARM                    CmdLenClrSQL

      * Build the SQL row addition statement

     C                   OPEN      CRTOBJSQL

      * Insert command line 1

     C                   EVAL      SRCDTA = InsertString01

     C                   WRITE     CRTOBJSQF

      * Insert command line 2

     C                   EVAL      SRCDTA = InsertString02

     C                   WRITE     CRTOBJSQF

      * Insert command line 3

     C                   EVAL      SRCDTA = InsertString03

     C                   WRITE     CRTOBJSQF

      * Insert command line 4

     C                   EVAL      SRCDTA = InsertString04

     C                   WRITE     CRTOBJSQF

      * Insert command line 5

     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = InsertString05

     C                   WRITE     CRTOBJSQF

      * Insert command line 6

     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = InsertString06

     C                   WRITE     CRTOBJSQF

      * Insert command line 7

     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = InsertString07

     C                   WRITE     CRTOBJSQF

      * Insert command line 8

     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = InsertString08

     C                   WRITE     CRTOBJSQF
                                                                                              CPK025
      * Insert command line 8a                                                                CPK025
                                                                                              CPK025
     C                   EVAL      SRCDTA = *BLANKS                                           CPK025
     C                   EVAL      SRCDTA = InsertString8a                                    CPK025
                                                                                              CPK025
     C                   WRITE     CRTOBJSQF                                                  CPK025

      * Insert command line 9

     C                   EVAL      SRCDTA = *BLANKS
     C**********         EVAL      SRCDTA = InsertString09 + ' ' +                            BG4033
     C**********                   '''' + ZoneName + ''''                                     BG4033
     C                   EVAL      SRCDTA = InsertString09                                    BG4033

     C                   WRITE     CRTOBJSQF

      * Insert command line 10

     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = InsertString10

     C                   WRITE     CRTOBJSQF

      * Insert command line 11

     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = InsertString11

     C                   WRITE     CRTOBJSQF

      * Insert command line 12

     C                   EVAL      SRCDTA = *BLANKS                                           CPK025
     C                   EVAL      SRCDTA = InsertString12                                    CPK025
                                                                                              CPK025
     C                   WRITE     CRTOBJSQF                                                  CPK025
                                                                                              CPK025
      * Insert command line 13                                                                CPK025
                                                                                              CPK025
     C                   EVAL      SRCDTA = *BLANKS                                           CPK025
     C                   EVAL      SRCDTA = InsertString13                                    CPK025
                                                                                              CPK025
     C                   WRITE     CRTOBJSQF                                                  CPK025
                                                                                              CPK025
      * Insert command line 14                                                                CPK025
                                                                                              CPK025
     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = '''' + '*REFZONE' + ''')'

     C                   WRITE     CRTOBJSQF

      * Execute the SQL row addition statement

     C                   CLOSE     CRTOBJSQL

     C                   CALL      'QCMDEXC'
     C                   PARM                    CmdStrRunSQL
     C                   PARM                    CmdLenRunSQL

     C                   EVAL      *INLR = *ON
     C
     C                   RETURN
      *
     C     TAGSQLERR     TAG                                                                MD029086
     C                   EXSR      *PSSR                                                    MD029086
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Wrun = *BLANK
     C                   EVAL      Wrun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
