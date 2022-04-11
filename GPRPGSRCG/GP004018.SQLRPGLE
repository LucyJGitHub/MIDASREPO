     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP Event Group Roles Report')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP004018 - Event Group Roles Report                          *
      *                                                               *
      *  Function: Produce Midas GP Event Group Roles Report          *
      *                                                               *
      *  Called By: GOC004018 - Event Group Roles Report              *
      *                                                               *
      *     (c) Finastra International Limited 2012                   *
      *                                                               *
      *  Last Amend No. MD053451B          Date 21Mar22               *
      *  Prev Amend No. MD050405           Date 03Jun20               *
      *                 MD053451A          Date 19May20               *
      *                 MD042109           Date 26Jun18               *
      *                 MD046248           Date 27Oct17               *
      *                 CBF023             Date 04Jan17               *
      *                 AR1097353          Date 26Mar13               *
      *                 AR1036892          Date 27Sep12               *
      *                 AR1032571          Date 14Sep12               *
      *                 AR1030958          Date 07Sep12               *
      *                 AR1029808          Date 07Sep12               *
      *                 AR1029191          Date 07Sep12               *
      *                 AR1029156          Date 06Sep12               *
      *                 AR1029152          Date 06Sep12               *
      *                 AR1028208          Date 05Sep12               *
      *                 AR1027797          Date 03Sep12               *
      *                 AR1025965          Date 31Aug12               *
      *                 CBF022  *CREATE    Date 16Jul12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053451B - BFTC Audit Reports were not generated.           *
      *            - Use BFEVTGRPA instead of BFEVTGRP fields.        *
      *  MD050405 - Fusion Midas 2.1 Platform Upgrade                 *
      *  MD053451A - BFTC Audit Reports were not generated.           *
      *  MD042109 - Updates, amendments and deletes do not show on    *
      *             BFTC audit reports                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF023 - Soft Delete Feature on Security Related Modules     *
      *  AR1097353 - No Event code Audit Report was generated.        *
      *              Additional fix for AR1096060.                    *
      *  AR1036892 - Transaction not approved during CoB run and      *
      *              consequently approved after CoB did not appear   *
      *              in the report                                    *
      *  AR1032571 - Change Date and Change timestamp is blank on     *
      *              amended report                                   *
      *  AR1030958 - Last Modified Date field of the Child must       *
      *              reflect in Parent also (Platform changes, thus   *
      *              partial fix of AR1029191 will be reversed)       *
      *  AR1029808 - An Event Group whose associated roles are ALL    *
      *              REMOVED did not appear in the Audit Report       *
      *  AR1029191 - Amended Event GRoup Role came out in the report  *
      *              as Insert                                        *
      *  AR1029156 - Change Timestamp has a value on newly inserted   *
      *              transaction                                      *
      *  AR1029152 - An Event Group is associated to 2 roles but      *
      *              report reflects only 1                           *
      *  AR1028208 - There is a value in fields "Change Date" and     *
      *              "Change Timestamp" when action is Insert         *
      *  AR1027797 - The target for a numeric operation is too small  *
      *              to hold the result                               *
      *  AR1025965 - Unable to view the expected fields               *
      *  CBF022 - BF Infrastructure: Auditability                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      * *INZSR    - Program initialisation                            *
      * *PSSR     - Error handling subroutine                         *
      * SrFetch   - Subroutine to Fetch Record from File              *
      * SrPrint   - Subroutine to Print the Record on the Main PRTF   *
      * SrPrint2  - Subroutine to Print the Secondary Details         *
      * SrEnd     - Subroutine to Close the Main PRTF of the Report   *
      * SrAudit   - Subroutine to Print the Audit of the Report       *
      * SrConvdat - Subroutine to Convert Date from Timestamp to      *
      *              YYYYMMDD                                         *
      **SrZdateO**-*Subroutine*to*Convert*from*DDMMYY*to*Midas*Runday**                    AR1097353
      * SrZdateO  - Subroutine to Convert from YYYYMMDD to Midas Day  *                    AR1097353
      *              Number                                           *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas GP Event Group Roles Report
     FGP004018P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

      ** Midas GP Event Group Roles Report - Audit
     FGP004018AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ External data areas                  ¦
      ** ¦ ===================                  ¦
      ** +--------------------------------------+
      *
      ** Midas Local Data Area for database error reporting; based on
      ** external file
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** External DS for Bank Details
     D GZSDBANK      E DS                  EXTNAME(GZSDBANKPD)

      ** External DS for SAR Details                                                          CBF023
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CBF023
                                                                                              CBF023
      ** Short DS for Access Objects                                                          CBF023
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CBF023

      ** File Information DS for Main PRTF
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

      ** File Information DS for Audit PRTF
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

     D EvntGrpDs       DS
     D  BFEGRPID                    102A
     D  BFEGRPNM                    102A
     D**BFEFRPDS                    102A                                                   AR1029808
     D  BFMODDBY                     32A
     D  BFCRTDBY                     32A
     D  BFLSTMOD                     26A
     D  BFRCRTON                     26A
     D  BFRAPRBY                     32A
     D  BFAPRDAT                     26A
     D  BFDELDAT                     26A                                                      CBF023
     D  BFGRPNAM                     32A
     D  BFGRPDSP                     62A
     D  BFRCRTONB                    26A                                                   MD053451A
     D  BFAPRDATB                    26A                                                   MD053451A
     D  BFRAPRBYB                    32A                                                   MD053451B
     D  BFCRTDBYB                    32A                                                   MD053451B
      *                                                                                    MD053451B
     D AssocRoleDS     DS                                                                  MD053451B
     D  RoleGrpID                   102A                                                   MD053451B
     D  RoleCrtBy                    32A                                                   MD053451B
     D  RoleCrtOn                    26A                                                   MD053451B
     D  RoleAppBy                    32A                                                   MD053451B
     D  RoleAppDt                    26A                                                   MD053451B

     D***NullIndDs       S              5I 0 DIM(10)                                          CBF023
     D*NullIndDs       S              5I 0 DIM(11)                                  CBF023 MD053451A
     D*NullIndDs       S              5I 0 DIM(13)                               MD053451A MD053451B
     D NullIndDs       S              5I 0 DIM(15)                                         MD053451B

      ** Input Parameter for ZDATEO
     D                 DS
     D PDateIn                 1      8  0

     D**ZDate***        S              6  0                                                AR1097353
     D ZDate           S              8S 0                                                 AR1097353
     D ZDayNo          S              5  0
     D ZError          S              2  0

     D ZDayNo3         S              5P 0
     D***ZDayNo4***      S              5P 0                                               AR1036892

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameters for ZSFILE
     D PZSEnty         S              3
     D PZSFile         S             10
     D PZSNum          S              6  0
     D PZSErr          S              1
     D PZSSeq          S              5A

      ** Parameters for Access Programs
     D POption         S              7A
     D PRetCode        S              7A
     D PZone           S             10A
     D PErms           S             50A
     D PCache          S              1A
     D PRecImage       S          32000A
     D PSard           S              6A                                                      CBF023

      ** Other Work Variables
     D WRun            S              1A
     D Error           S              1A
     D wFlag           S              1A
     D wEGrpId         S            102A   INZ('initial')                                  AR1029808
     D wGrpNam         S             32A                                                   AR1029152
     D wZone           S             10A
     D wNoRole         S             32A   INZ('**********')
     D wNoDesc         S             32A   INZ('No Role assigned')

     D WFirst          S              1    INZ('Y')
     D wNoRec          S              4S 0
     D RqdLn1          S              3  0
     D DifLn1          S              3  0

     D**TmpDat03        S               D   DATFMT(*DMY)                                   AR1097353
     D TmpDat03        S               D   DATFMT(*ISO)                                    AR1097353
     D DatNum03        S              8S 0

     D***TmpDat04***     S               D   DATFMT(*DMY)                                  AR1036892
     D***DatNum04***     S              8S 0                                               AR1036892

     D CBF023          S              1A                                                      CBF023
     D DefTimeStamp    S             26A   INZ('1900-01-01-00.00.00.000000')               MD053451B
      ** +--------------------------------------+
      ** ¦ Declared Constants                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Read All Records from the Result Set of the SQL Statement

     C/exec sql
     C+ declare mainCursor Cursor
     C+  for select
     C****BFEVENTGROUPID,**********************************************                    AR1029808
     C****BFEVENTGRPDISPLAYNAME,***************************************                    AR1029808
     C****BFEVENTGRPSHORTDESC,*****************************************                    AR1029808
     C+   A.BFEVENTGROUPIDPK,                                                              AR1029808
     C+   A.BFEVENTGRPSHORTDESC,                                                           AR1029808
     C+   A.BFRECLASTMODIFIEDBY,
     C+   A.BFRECCREATEDBY,
     C+   A.BFRECLASTMODIFIEDDATE,
     C+   A.BFRECCREATEDON,
     C+   A.BFRECAPPROVEDBY,
     C+   A.BFRECAPPROVEDDATE,
     C+   A.BFRECDELETETDATE,                                                                 CBF023
     C+   C.BFGROUPNAME,
     C****C.BFGROUPDISPLAYNAME****************************************                     MD053451A
     C+   C.BFGROUPDISPLAYNAME,                                                            MD053451A
     C+   B.BFRECCREATEDON,                                                                MD053451A
     C****B.BFRECAPPROVEDDATE*****************************************           MD053451A MD053451B
     C+   CASE WHEN B.BFRECAPPROVEDDATE IS NULL                                            MD053451B
     C+   THEN '1900-01-01'                                                                MD053451B
     C+   ELSE B.BFRECAPPROVEDDATE END,                                                    MD053451B
     C+   CASE WHEN B.BFRECAPPROVEDBY IS NULL                                              MD053451B
     C+   THEN ''                                                                          MD053451B
     C+   ELSE B.BFRECAPPROVEDBY END,                                                      MD053451B
     C+   B.BFRECCREATEDBY                                                                 MD053451B
     C+
     C***from*MIVW_EGAS*A**********************************************                    AR1029808
     C****left*outer*join*MIVW_EVGP*B*on*B.BFEVENTGROUPIDPK*=*A.BFEVENTGROUPID             AR1029808
     C****left*outer*join*MIVW_OGRP*C*on*C.BFGROUPIDPK*=*A.BFROLEID****                    AR1029808
     C+  from MIVW_EVGP A                                                                  AR1029808
     C+   left outer join MIVW_EGAS B on B.BFEVENTGROUPID = A.BFEVENTGROUPIDPK             AR1029808
     C+   left outer join MIVW_OGRP C on C.BFGROUPIDPK = B.BFROLEID                        AR1029808
     C+
     C+  where
     C+   A.BFRECLASTMODIFIEDDATE is not null or
     C+   A.BFRECCREATEDON is not null
     C+
     C+  order by
     C***A.BFEVENTGROUPID,*********************************************                    AR1029808
     C***BFEVENTGRPDISPLAYNAME,****************************************                    AR1029808
     C+  A.BFEVENTGROUPIDPK,                                                               AR1029808
     C+  A.BFEVENTGRPDISPLAYNAME,                                                          AR1029808
     C+  C.BFGROUPNAME
     C/end-exec

     C/exec sql
     C+ open mainCursor
     C/end-exec

      ** Read First Record

     C                   EXSR      SrFetch

     C                   DOW       %SUBST(SQLSTT:1:2) = '00' OR
     C                             %SUBST(SQLSTT:1:2) = '01'
     C                   EXSR      SrConvDat

     C**********         IF        ZDayNo3  = BJRDNB OR                                    AR1036892
     C**********                   ZDayNo3  = 0)                                           AR1036892
     C**********                   (ZDayNo4 = BJRDNB AND                                   AR1036892
     C**********         IF        ZDayNo3  = BJRDNB                              AR1036892 MD050405
                                                                                            MD050405
      ** Print report based on today's date instead of Midas rundate                        MD050405
                                                                                            MD050405
     C                   IF        TmpDat03 = %DATE()                                       MD050405

      ** If Different Event Group ID

     C                   IF        BFEGRPID <> wEGrpId
     C                   EVAL      wFlag  = ' '
     C                   EVAL      WnoRec = WnoReC+ 1
     C                   EXSR      GetAssocRole                                            MD053451B
     C                   EXSR      SrPrint
     C                   ELSE
     C                   EVAL      wFlag =  'Y'
     C                   ENDIF

     C**********         IF        wFlag = ' '                                             AR1029152
     C                   IF        wFlag = ' ' OR                                          AR1029152
     C                             BFGRPNAM <> wGrpNam                                     AR1029152
     C                   EXSR      SrPrint2
     C                   ENDIF

     C                   ENDIF

     C                   EXSR      SrFetch
     C                   ENDDO

     C                   EXSR      SrEnd

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFetch - Subroutine to Fetch Record from File                *
      *                                                               *
      *****************************************************************
     C     SrFetch       BEGSR

     C/exec sql
     C+  fetch next
     C+   from mainCursor
     C+  into :EvntGrpDs indicator :NULLINDDS
     C/end-exec

     C                   ENDSR
      *****************************************************************                    MD053451B
      /EJECT                                                                               MD053451B
      *****************************************************************                    MD053451B
      *                                                               *                    MD053451B
      * Getetch2- Subroutine to Fetch Record from File                *                    MD053451B
      *                                                               *                    MD053451B
      *****************************************************************                    MD053451B
     C     GetAssocRole  BEGSR                                                             MD053451B
                                                                                           MD053451B
     C                   IF        NullIndDs(13) = 0                                       MD053451B
     C                             AND BFAPRDATB <> DefTimeStamp                           MD053451B
     C                             AND BFAPRDATB <> *BLANKS                                MD053451B
      *                                                                                    MD053451B
      ** 4-eyes                                                                            MD053451B
      *                                                                                    MD053451B
     C/exec sql                                                                            MD053451B
     C+ declare mainCursor2 Cursor                                                         MD053451B
     C+  for select                                                                        MD053451B
     C+   D.BFEVENTGROUPID,                                                                MD053451B
     C+   D.BFRECCREATEDBY,                                                                MD053451B
     C+   D.BFRECCREATEDON,                                                                MD053451B
     C+   CASE WHEN D.BFRECAPPROVEDBY IS NULL                                              MD053451B
     C+   THEN ''                                                                          MD053451B
     C+   ELSE D.BFRECAPPROVEDBY END,                                                      MD053451B
     C+   CASE WHEN D.BFRECAPPROVEDDATE IS NULL                                            MD053451B
     C+   THEN '1900-01-01'                                                                MD053451B
     C+   ELSE D.BFRECAPPROVEDDATE END                                                     MD053451B
     C+                                                                                    MD053451B
     C+  from BFTEVTGRPA D                                                                 MD053451B
     C+                                                                                    MD053451B
     C+  where                                                                             MD053451B
     C+   D.BFEVENTGROUPID = :BFEGRPID                                                     MD053451B
     C+                                                                                    MD053451B
     C+  order by                                                                          MD053451B
     C+  D.BFRECAPPROVEDDATE DESC                                                          MD053451B
      ** Approve date is set to descending order                                           MD053451B
      ** to get the latest change                                                          MD053451B
     C/end-exec                                                                            MD053451B
                                                                                           MD053451B
     C/exec sql                                                                            MD053451B
     C+ open mainCursor2                                                                   MD053451B
     C/end-exec                                                                            MD053451B
     C                   EXSR      SrFetch2                                                MD053451B
     C/exec sql                                                                            MD053451B
     C+ close mainCursor2                                                                  MD053451B
     C/end-exec                                                                            MD053451B
     C                   ELSE                                                              MD053451B
      *                                                                                    MD053451B
      ** 2-eyes                                                                            MD053451B
      *                                                                                    MD053451B
     C                   IF        NullIndDs(12) = 0                                       MD053451B
     C/exec sql                                                                            MD053451B
     C+ declare mainCursor3 Cursor                                                         MD053451B
     C+  for select                                                                        MD053451B
     C+   D.BFEVENTGROUPID,                                                                MD053451B
     C+   D.BFRECCREATEDBY,                                                                MD053451B
     C+   D.BFRECCREATEDON,                                                                MD053451B
     C+   CASE WHEN D.BFRECAPPROVEDBY IS NULL                                              MD053451B
     C+   THEN ''                                                                          MD053451B
     C+   ELSE D.BFRECAPPROVEDBY END,                                                      MD053451B
     C+   CASE WHEN D.BFRECAPPROVEDDATE IS NULL                                            MD053451B
     C+   THEN '1900-01-01'                                                                MD053451B
     C+   ELSE D.BFRECAPPROVEDDATE END                                                     MD053451B
     C+                                                                                    MD053451B
     C+  from BFTEVTGRPA D                                                                 MD053451B
     C+                                                                                    MD053451B
     C+  where                                                                             MD053451B
     C+   D.BFEVENTGROUPID = :BFEGRPID                                                     MD053451B
     C+                                                                                    MD053451B
     C+  order by                                                                          MD053451B
     C+  D.BFRECCREATEDON DESC                                                             MD053451B
      *                                                                                    MD053451B
      ** Created on date is set to descending order                                        MD053451B
      ** to get the latest change                                                          MD053451B
      *                                                                                    MD053451B
     C/end-exec                                                                            MD053451B
                                                                                           MD053451B
     C/exec sql                                                                            MD053451B
     C+ open mainCursor3                                                                   MD053451B
     C/end-exec                                                                            MD053451B
     C                   EXSR      SrFetch3                                                MD053451B
     C/exec sql                                                                            MD053451B
     C+ close mainCursor3                                                                  MD053451B
     C/end-exec                                                                            MD053451B
     C                   ENDIF                                                             MD053451B
     C                   ENDIF                                                             MD053451B
                                                                                           MD053451B
     C                   ENDSR                                                             MD053451B
      *****************************************************************                    MD053451B
      /EJECT                                                                               MD053451B
      *****************************************************************                    MD053451B
      *                                                               *                    MD053451B
      * SrFetch2- Subroutine to Fetch Record from File                *                    MD053451B
      *                                                               *                    MD053451B
      *****************************************************************                    MD053451B
     C     SrFetch2      BEGSR                                                             MD053451B
                                                                                           MD053451B
     C/exec sql                                                                            MD053451B
     C+  fetch next                                                                        MD053451B
     C+   from mainCursor2                                                                 MD053451B
     C+  into :AssocRoleDs indicator :NULLINDDS                                            MD053451B
     C/end-exec                                                                            MD053451B
                                                                                           MD053451B
     C                   ENDSR                                                             MD053451B
      *****************************************************************                    MD053451B
      /EJECT                                                                               MD053451B
      *****************************************************************                    MD053451B
      *                                                               *                    MD053451B
      * SrFetch3- Subroutine to Fetch Record from File                *                    MD053451B
      *                                                               *                    MD053451B
      *****************************************************************                    MD053451B
     C     SrFetch3      BEGSR                                                             MD053451B
                                                                                           MD053451B
     C/exec sql                                                                            MD053451B
     C+  fetch next                                                                        MD053451B
     C+   from mainCursor3                                                                 MD053451B
     C+  into :AssocRoleDs indicator :NULLINDDS                                            MD053451B
     C/end-exec                                                                            MD053451B
                                                                                           MD053451B
     C                   ENDSR                                                             MD053451B
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrint - Subroutine to Print the Record on the Main PRTF     *
      *                                                               *
      *****************************************************************
     C     SrPrint       BEGSR

      ** Open Report File

     C                   IF        NOT %OPEN(GP004018P1)
     C                   OPEN      GP004018P1
     C                   ENDIF

     C                   CALL      'ZSFILE'
     C                   PARM                    PZSSeq
     C                   PARM      *BLANKS       PZSEnty
     C                   PARM      SFILE1        PZSFile
     C                   PARM      SFNUM1        PZSNum
     C                   PARM      *BLANK        PZSErr

     C                   IF        PZSERR = 'Y'
     C                   EVAL      DBASE  = 2
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   MOVE      PZSNUM        DBKEY
     C                   EVAL      Error  = 'Y'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   DETAIL1                                   AR1028208
     C                   WRITE     HEADP1
     C                   EVAL      WFIRST = 'Y'

      ** Last Change User

     C**********         IF        BFMODDBY <> *BLANKS                                     MD053451B
     C**********         EVAL      RUSER  = BFMODDBY                                       MD053451B
     C**********         ELSE                                                              MD053451B
     C**********         EVAL      RUSER  = BFCRTDBY                                       MD053451B
     C**********         ENDIF                                                             MD053451B

      ** Change Date

     C**********         IF        BFLSTMOD <> *BLANKS                                     AR1029191
     C**********         IF        NullIndDs(6) = 0                                        AR1029191
     C**********         EVAL      RCDAT = BFLSTMOD                                        AR1029191
     C**********         ENDIF                                                             AR1029191
     C**********         ELSE                                                              AR1029191
     C                   IF        BFDELDAT <> '0'                                            CBF023
     C                             AND CBF023 = 'Y'                                           CBF023
     C                   IF        NullIndDs(5) = 0                                           CBF023
     C                   EVAL      RCDAT = BFLSTMOD                                           CBF023
     C                   ENDIF                                                                CBF023
     C                   ELSE                                                                 CBF023
                                                                                              CBF023
     C**********         IF        BFLSTMOD <> *BLANKS                           AR1030958 MD053451B
     C**********         IF        NullIndDs(5) = 0                              AR1030958 MD053451B
     C**********         EVAL      RCDAT = BFLSTMOD                              AR1030958 MD053451B
     C**********         ELSE                                                    AR1032571 MD053451B
     C**********         IF        NullIndDs(12) = 0                             MD053451A MD053451B
     C**********         EVAL      RCDAT = BFRCRTONB                             MD053451A MD053451B
     C**********         ELSE                                                    MD053451A MD053451B
     C**********         IF        NullIndDs(6) = 0                              AR1032571 MD053451B
     C**********         EVAL      RCDAT = BFRCRTON                              AR1032571 MD053451B
     C**********         ENDIF                                                   AR1032571 MD053451B
     C**********         ENDIF                                                   AR1030958 MD053451B
     C**********         ENDIF                                                   MD053451A MD053451B
     C**********         ELSE                                                    AR1030958 MD053451B
     C**********         IF        NullIndDs(12) = 0                             MD053451A MD053451B
     C**********         EVAL      RCDAT = BFRCRTONB                             MD053451A MD053451B
     C**********         ELSE                                                    MD053451A MD053451B
     C**********         IF        NullIndDs(6) = 0                                        MD053451B
     C**********         EVAL      RCDAT = BFRCRTON                                        MD053451B
     C**********         ENDIF                                                             MD053451B
     C**********         ENDIF                                                   MD053451A MD053451B
     C**********         ENDIF                                                             AR1029191
     C**********         ENDIF                                                   AR1030958 MD053451B
      *                                                                                    MD053451B
      ** Last Modified Date is not populated (2 or 4 eyes)                                 MD053451B
      ** Use approve and created fields of MIVW_EGAS                                       MD053451B
      *                                                                                    MD053451B
      ** Initialize below fields to set as blanks instead of                               MD053451B
      ** default('0001-01-01-00.00.00.000000') for 2-eyes set up                           MD053451B
      *                                                                                    MD053451B
     C                   EVAL      RAUDT = *BLANKS                                         MD053451B
     C                   EVAL      RAUTH = *BLANKS                                         MD053451B
     C                   EVAL      RATIM = *BLANKS                                         MD053451B
      *                                                                                    MD053451B
      ** If RoleAppDt is populated, set-up is 4-eyes                                       MD053451B
      *                                                                                    MD053451B
     C                   IF        NullIndDs(13) = 0                                       MD053451B
      *                                                                                    MD053451B
      ** RoleAppDt is defaulted to '1900-01-01' for 2-eyes set up                          MD053451B
      *                                                                                    MD053451B
     C                             AND RoleAppDt <> DefTimeStamp                           MD053451B
      *                                                                                    MD053451B
      ** RoleAppDt is blanks, if event group has no records in MIVW_EGAS                   MD053451B
      *                                                                                    MD053451B
     C                             AND RoleAppDt <> *BLANKS                                MD053451B
     C                   EVAL      RAUDT = RoleAppDt                                       MD053451B
     C                   EVAL      RAUTH = RoleAppBy                                       MD053451B
     C                   EVAL      RATIM = RoleAppDt                                       MD053451B
     C                   IF        NullIndDs(12) = 0                                       MD053451B
     C                   EVAL      RUSER = RoleCrtBy                                       MD053451B
     C                   EVAL      RCDAT = RoleCrtOn                                       MD053451B
     C                   EVAL      RTIME = RoleCrtOn                                       MD053451B
     C                   ENDIF                                                             MD053451B
     C                   ELSE                                                              MD053451B
      *                                                                                    MD053451B
      ** Role Create On is populated, set-up is 2-eyes                                     MD053451B
      *                                                                                    MD053451B
     C                   IF        NullIndDs(12) = 0                                       MD053451B
     C                   EVAL      RUSER = RoleCrtBy                                       MD053451B
     C                   EVAL      RCDAT = RoleCrtOn                                       MD053451B
     C                   EVAL      RTIME = RoleCrtOn                                       MD053451B
     C                   ELSE                                                              MD053451B
      *                                                                                    MD053451B
      ** Below codes are for Event Group that has no role associated                       MD053451B
      ** If Last Modified fields are populated                                             MD053451B
      *                                                                                    MD053451B
     C                   IF        NullIndDs(5) = 0                                        MD053451B
     C                   EVAL      RUSER = BFMODDBY                                        MD053451B
     C                   EVAL      RCDAT = BFLSTMOD                                        MD053451B
     C                   EVAL      RTIME = BFLSTMOD                                        MD053451B
      *                                                                                    MD053451B
      ** If Approved By/Date fields are populated                                          MD053451B
      *                                                                                    MD053451B
     C                   IF        NullIndDs(7) = 0                                        MD053451B
     C                   EVAL      RAUDT = BFAPRDAT                                        MD053451B
     C                   EVAL      RAUTH = BFRAPRBY                                        MD053451B
     C                   EVAL      RATIM = BFAPRDAT                                        MD053451B
     C                   ENDIF                                                             MD053451B
     C                   ELSE                                                              MD053451B
      *                                                                                    MD053451B
      ** If Created On/By fields are populated                                             MD053451B
      *                                                                                    MD053451B
     C                   IF        NullIndDs(6) = 0                                        MD053451B
     C                   EVAL      RUSER = BFCRTDBY                                        MD053451B
     C                   EVAL      RCDAT = BFRCRTON                                        MD053451B
     C                   EVAL      RTIME = BFRCRTON                                        MD053451B
      *                                                                                    MD053451B
      ** If Approved By/Date fields are populated                                          MD053451B
      *                                                                                    MD053451B
     C                   IF        NullIndDs(7) = 0                                        MD053451B
     C                   EVAL      RAUDT = BFAPRDAT                                        MD053451B
     C                   EVAL      RAUTH = BFRAPRBY                                        MD053451B
     C                   EVAL      RATIM = BFAPRDAT                                        MD053451B
     C                   ENDIF                                                             MD053451B
     C                   ENDIF                                                             MD053451B
     C                   ENDIF                                                             MD053451B
     C                   ENDIF                                                             MD053451B
     C                   ENDIF                                                             MD053451B
      *                                                                                    MD053451B
                                                                                              CBF023
     C                   ENDIF                                                                CBF023

      ** Change Timestamp

     C**********         IF        BFLSTMOD <> *BLANKS                                     AR1029191
     C**********         IF        NullIndDs(6) = 0                              AR1029156 AR1029191
     C**********         EVAL      RTIME = BFLSTMOD                                        AR1029191
     C**********         ENDIF                                                   AR1029156 AR1029191
     C**********         ELSE                                                              AR1029191
     C**********         IF        BFDELDAT <> '0'                                  CBF023 MD053451B
     C**********                   AND CBF023 = 'Y'                                 CBF023 MD053451B
     C**********         IF        NullIndDs(5) = 0                                 CBF023 MD053451B
     C**********         EVAL      RTIME = BFLSTMOD                                 CBF023 MD053451B
     C**********         ENDIF                                                      CBF023 MD053451B
     C**********         ELSE                                                       CBF023 MD053451B
                                                                                              CBF023
     C**********         IF        BFLSTMOD <> *BLANKS                           AR1030958 MD053451B
     C**********         IF        NullIndDs(5) = 0                              AR1030958 MD053451B
     C**********         EVAL      RTIME = BFLSTMOD                              AR1030958 MD053451B
     C**********         ELSE                                                    AR1032571 MD053451B
     C**********         IF        NullIndDs(12) = 0                             MD053451A MD053451B
     C**********         EVAL      RTIME = BFRCRTONB                             MD053451A MD053451B
     C**********         ELSE                                                    MD053451A MD053451B
     C**********         IF        NullIndDs(6) = 0                              AR1032571 MD053451B
     C**********         EVAL      RTIME = BFRCRTON                              AR1032571 MD053451B
     C**********         ENDIF                                                   AR1032571 MD053451B
     C**********         ENDIF                                                   MD053451A MD053451B
     C**********         ENDIF                                                   AR1030958 MD053451B
     C**********         ELSE                                                    AR1030958 MD053451B
     C**********         IF        NullIndDs(12) = 0                             MD053451A MD053451B
     C**********         EVAL      RTIME = BFRCRTONB                             MD053451A MD053451B
     C**********         ELSE                                                    MD053451A MD053451B
     C**********         IF        NullIndDs(6) = 0                              AR1029156 MD053451B
     C**********         EVAL      RTIME = BFRCRTON                                        MD053451B
     C**********         ENDIF                                                   AR1029156 MD053451B
     C**********         ENDIF                                                             AR1029191
     C**********         ENDIF                                                   AR1030958 MD053451B
     C**********         ENDIF                                                   MD053451A MD053451B
     C**********         ENDIF                                                   MD053451A MD053451B

      ** Last Change Action

     C**********         IF        ZDayNo3 = 0                                             AR1029191
     C**********         EVAL      RACTN = 'Insert'                                        AR1029191
     C**********         ELSE                                                              AR1029191
     C                   IF        BFDELDAT <> '0'                                            CBF023
     C                             AND CBF023 = 'Y'                                           CBF023
     C                   EVAL      RACTN = 'Delete'                                           CBF023
     C                   ELSE                                                                 CBF023
     C                   EVAL      RACTN = 'Amend'
     C                   ENDIF                                                                CBF023
     C**********         ENDIF                                                             AR1029191

      ** Last Authorising User

     C**********         EVAL      RAUTH = BFRAPRBY                                        MD053451B

      ** Authorisation Date

     C**********         IF        NullIndDs(11) = 0                                       AR1029808
     C**********         IF        NullIndDs(13) = 0                             MD053451A MD053451B
     C**********         EVAL      RAUDT = BFAPRDATB                             MD053451A MD053451B
     C**********         ELSE                                                    MD053451A MD053451B
     C**********         IF        NullIndDs(8) = 0                              AR1029808 MD053451B
     C**********         EVAL      RAUDT = BFAPRDAT                                        MD053451B
     C**********         ENDIF                                                   MD053451A MD053451B
     C**********         ENDIF                                                             MD053451B

      ** Authorisation Timestamp

     C**********         IF        NullIndDs(11) = 0                             AR1028208 AR1029808
     C**********         IF        NullIndDs(13) = 0                             MD053451A MD053451B
     C**********         EVAL      RATIM = BFAPRDATB                             MD053451A MD053451B
     C**********         ELSE                                                    MD053451A MD053451B
     C**********         IF        NullIndDs(8) = 0                    AR1028208 AR1029808 MD053451B
     C**********         EVAL      RATIM = BFAPRDAT                                        MD053451B
     C**********         ENDIF                                                   MD053451A MD053451B
     C**********         ENDIF                                                   AR1028208 MD053451B

      ** Event Group

     C                   EVAL      REGRP = BFEGRPID

      ** Event Group Name

     C                   EVAL      RENAM = BFEGRPNM

     C                   EVAL      wEGrpId = BFEGRPID
     C                   EVAL      wGrpNam = BFGRPNAM                                      AR1029152
     C                   WRITE     DETAIL1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrint2 - Subroutine to Print the Secondary Details          *
      *                                                               *
      *****************************************************************
     C     SrPrint2      BEGSR

     C                   EVAL      RqdLn1 = 6
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP2
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF

     C                   EVAL      RqdLn1 = 11                                             AR1027797
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                AR1027797
                                                                                           AR1027797
     C                   IF        DifLn1 <= RqdLn1 AND
     C                             WFirst = 'N'
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2
     C                   ENDIF

     C                   IF        BFGRPNAM <> *BLANKS
     C                   EVAL      RROLE =  BFGRPNAM
     C                   EVAL      RDESC =  BFGRPDSP

     C                   ELSE
     C                   EVAL      RROLE = wNoRole
     C                   EVAL      RDESC = wNoDesc
     C                   ENDIF

     C                   WRITE     DETAIL2

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEnd - Subroutine to Close the Main PRTF of the Report       *
      *                                                               *
      *****************************************************************
     C     SrEnd         BEGSR

      ** Close P1 and Write Trailer Record Format

     C                   IF        %OPEN(GP004018P1)

     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF

     C                   WRITE     TRAILP1
     C                   CLOSE     GP004018P1
     C                   ENDIF

     C                   EXSR      SRAudit

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAudit - Subroutine to Print the Audit of the Report         *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR

     C                   IF        (Error <> 'Y')
     C                   IF        WnoRec = 0

      ** Open and Register AU Report via RCF

     C                   Z-ADD     SFNUMU        PZSNum

     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PZSSeq
     C                   PARM      *BLANKS       PZSEnty
     C                   PARM      SFILEU        PZSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr

     C                   IF        PZSERR = 'Y'
     C                   EVAL      DBASE  = 3
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   MOVE      PZSNUM        DBKEY
     C                   EVAL      Error = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   ENDIF

     C                   WRITE     HEADAU

      ** Write No Details

     C                   WRITE     NODTLS
     C                   ENDIF

     C                   ELSE

      ** Write Database Error

     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
     C                   IF        %OPEN(GP004018P1)
     C                   CLOSE     GP004018P1
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrConvdat - Subroutine to Convert Date from Timestamp to      *
      *             YYYYMMDD                                          *
      *                                                               *
      *****************************************************************
     C     SrConvdat     BEGSR

     C                   EVAL      ZDayNo3 = 0
     C**********         EVAL      ZDayNo4 = 0                                             AR1036892

     C**********         IF        NullIndDs(5) = 0                                        AR1036892
     C**********         EVAL      TmpDat03 = %DATE(%SUBST(BFLSTMOD:1:10):*ISO)            AR1036892
     C                   EVAL      TmpDat03 = *LOVAL                                        MD042109
      *                                                                                    MD053451B
      ** Modified by and date are not populated in BFTEVTGRPA                              MD053451B
      ** via add o delete associate role                                                   MD053451B
      *                                                                                    MD053451B
      ** Check approved date is populated  (4 eyes)                                        MD053451B
      *                                                                                    MD053451B
     C                   IF        NullIndDs(13) = 0                                       MD053451A
     C                             AND BFAPRDATB <> DefTimeStamp                           MD053451B
     C                   EVAL      TmpDat03 = %DATE(%SUBST(BFAPRDATB:1:10):*ISO)           MD053451A
     C                   ELSE                                                              MD053451A
      *                                                                                    MD053451B
      ** Check created on date is populated                                                MD053451B
      *                                                                                    MD053451B
     C                   IF        NullIndDs(12) = 0                                       MD053451A
     C                   EVAL      TmpDat03 = %DATE(%SUBST(BFRCRTONB:1:10):*ISO)           MD053451A
     C                   ELSE                                                              MD053451A
      ** Approved Date                                                                      MD042109
     C                   IF        NullIndDs(8) = 0                                        AR1036892
     C                   EVAL      TmpDat03 = %DATE(%SUBST(BFAPRDAT:1:10):*ISO)            AR1036892
     C                   ELSE                                                               MD042109
      ** Last Modified Date                                                                 MD042109
     C                   IF        NullIndDs(5) = 0                                         MD042109
     C                   EVAL      TmpDat03 = %DATE(%SUBST(BFLSTMOD:1:10):*ISO)             MD042109
     C                   ELSE                                                               MD042109
      ** Created on Date                                                                    MD042109
     C                   IF        NullIndDs(6) = 0                                         MD042109
     C                   EVAL      TmpDat03 = %DATE(%SUBST(BFRCRTON:1:10):*ISO)             MD042109
     C                   ENDIF                                                              MD042109
     C                   ENDIF                                                              MD042109
     C                   ENDIF                                                              MD042109
     C                   ENDIF                                                             MD053451A
     C                   ENDIF                                                             MD053451A
     C                   IF        TmpDat03 <> *LOVAL                                       MD042109
     C                   EVAL      DatNum03 = %DEC(TmpDat03)
     C                   EVAL      PDateIN  = DatNum03
     C                   EXSR      SRZDateO
     C                   Z-ADD     ZDayNo        ZDayNo3
     C                   ENDIF

     C**********         IF        NullIndDs(6) = 0                                        AR1036892
     C**********         EVAL      TmpDat04 = %DATE(%SUBST(BFRCRTON:1:10):*ISO)            AR1036892
     C**********         EVAL      DatNum04 = %DEC(TmpDat03)                               AR1025965
     C**********         EVAL      DatNum04 = %DEC(TmpDat04)                     AR1025965 AR1036892
     C**********         EVAL      PDateIN  = DatNum04                                     AR1036892
     C**********         EXSR      SRZDateO                                                AR1036892
     C**********         Z-ADD     ZDayNo        ZDayNo4                                   AR1036892
     C**********         ENDIF                                                             AR1036892

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      **SrZdateO**-*Subroutine*to*Convert*from*DDMMYY**to*Midas********                    AR1097353
      * SrZdateO  - Subroutine to Convert from YYYYMMDD to Midas      *                    AR1097353
      *             Runday Number                                     *
      *                                                               *
      *****************************************************************
     C     SrZDateO      BEGSR

     C**********         CALL      'ZDATEO'                                                AR1097353
     C                   CALL      'ZDATE10'                                               AR1097353
     C                   PARM      PDateIN       ZDate
     C                   PARM                    ZDayNo
     C**********         PARM                    ZError                                    AR1097353

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    wZone

      ** Initialize Program Name

     C                   EVAL      DBPGM = 'GP004018'

      ** Access Bank Details

     C                   CALL      'GPACSZBNK'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      *BLANKS       PErms
     C                   PARM      wZone         PZone
     C                   PARM      'N'           PCache
     C     GZSDBANK      PARM                    PRecImage

      ** Database Error

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBPGM  = 'GPACSZBNK'
     C                   EVAL      DBFILE = 'GZSDBANKPD'
     C                   EVAL      DBKEY  = POption
     C                   OUT       LDA
     C                   EVAL      Error  = 'Y'
     C                   EXSR      SrAudit
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if CBF023 is installed                                                         CBF023
                                                                                              CBF023
     C                   CALL      'AOSARDR0'                                                 CBF023
     C                   PARM      *BLANKS       PRetCode                                     CBF023
     C                   PARM      '*VERIFY'     POption                                      CBF023
     C                   PARM      'CBF023'      PSard                                        CBF023
     C     SCSARD        PARM      SCSARD        DSFDY                                        CBF023
                                                                                              CBF023
     C                   IF        PRetCode <> *BLANKS                                        CBF023
     C                             AND PRetCode <> '*NRF   '                                  CBF023
     C     *LOCK         IN        LDA                                                        CBF023
     C                   EVAL      DBFile = 'SCSARDPD'                                        CBF023
     C                   EVAL      DBKey = PSard                                              CBF023
     C                   EVAL      DBase = 4                                                  CBF023
     C                   OUT       LDA                                                        CBF023
     C                   EXSR      *PSSR                                                      CBF023
     C                   ENDIF                                                                CBF023
                                                                                              CBF023
     C                   EVAL      CBF023 = 'N'                                               CBF023
     C                   IF        PRetCode = *BLANKS                                         CBF023
     C                   EVAL      CBF023 = 'Y'                                               CBF023
     C                   ENDIF                                                                CBF023

     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR
      ********************************************************************
