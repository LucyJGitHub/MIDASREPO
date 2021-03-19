     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP Role Audit Report')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP004013 - Role Audit Report                                 *
      *                                                               *
      *  Function: Produce Midas GP Role Audit Report                 *
      *                                                               *
      *  Called By: GOC004013 - Role Audit Report                     *
      *                                                               *
      *     (c) Finastra International Limited 2012                   *
      *                                                               *
      *  Last Amend No. MD050405           Date 03Jun20               *
      *  Prev Amend No. MD042109           Date 26Jun18               *
      *                 MD046248           Date 27Oct17               *
      *                 CBF023             Date 04Jan17               *
      *                 AR1096973          Date 23Apr13               *
      *                 AR1097353          Date 26Mar13               *
      *                 AR1036892          Date 27Sep12               *
      *                 AR1028208          Date 05Sep12               *
      *                 AR1027797          Date 03Sep12               *
      *                 AR1026143          Date 31Aug12               *
      *                 AR1025965          Date 31Aug12               *
      *                 CBF022  *CREATE    Date 16Jul12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050405 - Fusion Midas 2.1 Platform Upgrade                 *
      *  MD042109 - Updates, amendments and deletes do not show on    *
      *             BFTC audit reports                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF023 - Soft Delete Feature on Security Related Modules     *
      *  AR1096973 - There is a value in the Parent Role ID field in  *
      *              the Report but none in BFTC.                     *
      *  AR1097353 - No Event code Audit Report was generated.        *
      *              Additional fix for AR1096060.                    *
      *  AR1036892 - Transaction not approved during CoB run and      *
      *              consequently approved after CoB did not appear   *
      *              in the report                                    *
      *  AR1028208 - There is a value in fields "Change Date" and     *
      *              "Change Timestamp" when action is Insert         *
      *  AR1027797 - The target for a numeric operation is too small  *
      *              to hold the result                               *
      *  AR1026143 - Parent Role ID mismatch                          *
      *  AR1025965 - Unable to view the expected fields               *
      *  CBF022 - BF Infrastructure: Auditability                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      * *INZSR    - Program Initialisation                            *
      * *PSSR     - Error Handling Subroutine                         *
      * SrFetch   - Subroutine to Fetch Record from File              *
      * SrPrint   - Subroutine to Print the Record on the Main PRTF   *
      * SrPrint2  - Subroutine to Print the Secondary Details         *
      * SrOvrFlw  - Subroutine to Check for Overflow                  *
      * SrEnd     - Subroutine to Close the Main PRTF or the Report   *
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

      ** Midas GP Role Audit Report
     FGP004013P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

      ** Midas GP Role Audit Report - Audit
     FGP004013AUO    E             PRINTER INFSR(*PSSR)
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

     D PermNamDs       DS           264
     D  PermNam1               1     90A
     D  PermNam2              91    180A
     D  PermNam3             181    258A
     D  PermNam4             259    264A

     D ArtRoleDs       DS
     D  BFGRPNAM                     32A
     D  BFGRPDES                     32A
     D  BFGRPDSP                     62A
     D  BFGRPPRT                     22A
     D  BFPERNAM                    258A
     D  BFMODDBY                     32A
     D  BFCRTDBY                     32A
     D  BFLSTMOD                     26A
     D  BFRCRTON                     26A
     D  BFRAPRBY                     32A
     D  BFAPRDAT                     26A
     D  BFDELDAT                     26A                                                      CBF023

     D***NullIndDs       S              5I 0 DIM(11)                                          CBF023
     D NullIndDs       S              5I 0 DIM(12)                                            CBF023

      ** Input Parameter for ZDATEO
     D                 DS
     D PDateIn                 1      8  0

     D**ZDate***        S              6  0                                                AR1097353
     D ZDate           S              8S 0                                                 AR1097353
     D ZDayNo          S              5  0
     D ZError          S              2  0

     D ZDayNo3         S              5P 0
     D ZDayNo4         S              5P 0

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
     D*WFlgCtr**       S              3  0                                                 AR1027797
     D WFlgCtr         S              6  0                                                 AR1027797
     D wGrpNam         S             32A
     D wZone           S             10A
     D wNoPerm         S             32A   INZ('**********           ')
     D wNoDesc         S             32A   INZ('No Permission Granted')

     D WFirst          S              1    INZ('Y')
     D wNoRec          S              4S 0
     D RqdLn1          S              3  0
     D DifLn1          S              3  0

     D**TmpDat03        S               D   DATFMT(*DMY)                                   AR1097353
     D TmpDat03        S               D   DATFMT(*ISO)                                    AR1097353
     D DatNum03        S              8S 0

     D**TmpDat04        S               D   DATFMT(*DMY)                                   AR1097353
     D TmpDat04        S               D   DATFMT(*ISO)                                    AR1097353
     D DatNum04        S              8S 0

     D  CBF023         S              1A                                                      CBF023

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
     C+  A.BFGROUPNAME,
     C+  A.BFGROUPDESCRIPTION,
     C+  A.BFGROUPDISPLAYNAME,
     C***A.BFGROUPPARENTID,********************************************                    AR1026143
     C***(select*BFGROUPNAME*from*MIVW_OGRP****************************
     C******where*BFGROUPIDPK*=*A.BFGROUPPARENTID),********************          AR1026143 AR1096973
     C+  (select case when BFGROUPNAME='BFRoot' then '' else BFGROUPNAME end
     C+   from MIVW_OGRP
     C+   where BFGROUPIDPK = A.BFGROUPPARENTID),                                          AR1096973
     C+  C.BFPERMISSIONNAME,
     C+  A.BFRECLASTMODIFIEDBY,
     C+  A.BFRECCREATEDBY,
     C+  A.BFRECLASTMODIFIEDDATE,
     C+  A.BFRECCREATEDON,
     C+  A.BFRECAPPROVEDBY,
     C***A.BFRECAPPROVEDDATE*******************************************                       CBF023
     C+  A.BFRECAPPROVEDDATE,                                                                 CBF023
     C+  A.BFRECDELETETDATE                                                                   CBF023
     C+
     C+  from MIVW_OGRP A
     C+  left outer join MIVW_GRPM B on B.BFGROUPID = A.BFGROUPIDPK
     C+  left outer join MIVW_PRMN C on C.BFIDPK = B.BFPERMISSIONID
     C+
     C+  where
     C+   A.BFRECLASTMODIFIEDDATE is not null or
     C+   A.BFRECCREATEDON is not null
     C+
     C+  order by
     C+  A.BFGROUPNAME,
     C+  A.BFGROUPDESCRIPTION,
     C+  A.BFGROUPPARENTID,
     C+  A.BFGROUPDISPLAYNAME,
     C+  C.BFPERMISSIONNAME
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
     C**********                   (ZDayNo4 = BJRDNB AND                                   AR1036892
     C**********                   ZDayNo3  = 0)                                           AR1036892
     C**********         IF        ZDayNo4  = BJRDNB                              AR1036892 MD050405
                                                                                            MD050405
      ** Print report based on today's date instead of Midas rundate                        MD050405
                                                                                            MD050405
     C                   IF        TmpDat04 = %DATE()                                       MD050405

      ** If Different Event Group ID

     C                   IF        BFGRPNAM <> wGrpNam
     C                   EVAL      wFlag   = ' '
     C                   EVAL      wFlgCtr = 0
     C                   EVAL      WnoRec  = WnoReC+ 1
     C                   EXSR      SrPrint
     C                   ENDIF

     C                   EVAL      PermNamDs = BFPERNAM
     C                   EXSR      SrPrint2
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
     C+  into :ArtRoleDs indicator :NULLINDDS
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrint - Subroutine to Print the Record on the Main PRTF     *
      *                                                               *
      *****************************************************************
     C     SrPrint       BEGSR

      ** Open Report File

     C                   IF        NOT %OPEN(GP004013P1)
     C                   OPEN      GP004013P1
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
     C                   EVAL      Error = 'Y'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   DETAIL1                                   AR1028208
     C                   WRITE     HEADP1
     C                   EVAL      WFIRST = 'Y'

      ** Last Change User

     C                   IF        BFMODDBY <> *BLANKS
     C                   EVAL      RUSER  = BFMODDBY
     C                   ELSE
     C                   EVAL      RUSER  = BFCRTDBY
     C                   ENDIF

      ** Change Date

     C                   IF        BFDELDAT <> '0'                                            CBF023
     C                             AND CBF023 = 'Y'                                           CBF023
     C                   IF        NullIndDs(8) = 0                                           CBF023
     C                   EVAL      RCDAT = BFLSTMOD                                           CBF023
     C                   ENDIF                                                                CBF023
     C                   ELSE                                                                 CBF023
                                                                                              CBF023
     C                   IF        BFLSTMOD <> *BLANKS
     C                   IF        NullIndDs(8) = 0
     C                   EVAL      RCDAT = BFLSTMOD
     C                   ENDIF
     C                   ELSE
     C                   IF        NullIndDs(9) = 0
     C                   EVAL      RCDAT = BFRCRTON
     C                   ENDIF
     C                   ENDIF
                                                                                              CBF023
     C                   ENDIF                                                                CBF023

      ** Change Timestamp

     C                   IF        BFDELDAT <> '0'                                            CBF023
     C                             AND CBF023 = 'Y'                                           CBF023
     C                   IF        NullIndDs(8) = 0                                           CBF023
     C                   EVAL      RTIME = BFLSTMOD                                           CBF023
     C                   ENDIF                                                                CBF023
     C                   ELSE                                                                 CBF023
                                                                                              CBF023
     C                   IF        BFLSTMOD <> *BLANKS
     C                   IF        NullIndDs(8) = 0
     C                   EVAL      RTIME = BFLSTMOD
     C                   ENDIF
     C                   ELSE
     C                   IF        NullIndDs(9) = 0
     C                   EVAL      RTIME = BFRCRTON
     C                   ENDIF
     C                   ENDIF
                                                                                              CBF023
     C                   ENDIF                                                                CBF023

      ** Last Change Action

     C                   IF        BFDELDAT <> '0'                                            CBF023
     C                             AND CBF023 = 'Y'                                           CBF023
     C                   EVAL      RACTN = 'Delete'                                           CBF023
     C                   ELSE                                                                 CBF023
     C                   IF        ZDayNo3 = 0
     C                   EVAL      RACTN = 'Insert'
     C                   ELSE
     C                   EVAL      RACTN = 'Amend'
     C                   ENDIF
     C                   ENDIF                                                                CBF023

      ** Last Authorising User

     C                   EVAL      RAUTH = BFRAPRBY

      ** Authorisation Date

     C                   IF        NullIndDs(11) = 0
     C                   EVAL      RAUDT = BFAPRDAT
     C                   ENDIF

      ** Authorisation Timestamp

     C                   IF        NullIndDs(11) = 0                                       AR1028208
     C                   EVAL      RATIM = BFAPRDAT
     C                   ENDIF                                                             AR1028208

      ** Role Name

     C                   EVAL      RROLE = BFGRPNAM

      ** Role Description

     C                   EVAL      RDESC = BFGRPDES

      ** Display Name

     C                   EVAL      RDISP = BFGRPDSP

      ** Parent Role Identifier

     C                   EVAL      RPARE = BFGRPPRT

     C                   EVAL      wGrpNam = BFGRPNAM
                                                                                           AR1027797
      ** Write Role Details to report                                                      AR1027797
                                                                                           AR1027797
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

     C                   IF        BFPERNAM <> *BLANKS

     C                   IF        PermNam1 <> ' '
     C                   EVAL      RPERM = PermNam1
     C                   EXSR      SrOvrFlw
     C                   WRITE     DETAIL2
     C                   ENDIF

     C                   IF        PermNam2 <> ' '
     C                   EVAL      RPERM = PermNam4 + PermNam2
     C                   EXSR      SrOvrFlw
     C                   WRITE     DETAIL2
     C                   ENDIF

     C                   IF        PermNam3 <> ' '
     C                   EVAL      RPERM = PermNam4 + PermNam3
     C                   EXSR      SrOvrFlw
     C                   WRITE     DETAIL2
     C                   ENDIF

     C                   EVAL      WFlgCtr = WFlgCtr + 1
     C                   ELSE

     C                   IF        wFlag <> 'Y'
     C                             AND WFlgCtr < 1
     C                   EVAL      RPERM = wNoPerm + wNoDesc
     C                   EVAL      wFlag =  'Y'
     C                   EXSR      SrOvrFlw
     C                   WRITE     DETAIL2
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrOvrFlw - Subroutine to Check for Overflow                   *
      *                                                               *
      *****************************************************************
     C     SrOvrFlw      BEGSR

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

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEnd - Subroutine to Close the Main PRTF or the Report       *
      *                                                               *
      *****************************************************************
     C     SrEnd         BEGSR

      ** Close P1 and Write Rrailer Record Format

     C                   IF        %OPEN(GP004013P1)

     C**********         EVAL      RqdLn1 = 4                                              AR1027797
     C                   EVAL      RqdLn1 = 6                                              AR1027797
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF

     C                   WRITE     TRAILP1
     C                   CLOSE     GP004013P1
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
     C                   IF        %OPEN(GP004013P1)
     C                   CLOSE     GP004013P1
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
     C                   EVAL      ZDayNo4 = 0

     C                   IF        NullIndDs(8) = 0
     C                   EVAL      TmpDat03 = %DATE(%SUBST(BFLSTMOD:1:10):*ISO)
     C                   EVAL      DatNum03 = %DEC(TmpDat03)
     C                   EVAL      PDateIN  = DatNum03
     C                   EXSR      SRZDateO
     C                   Z-ADD     ZDayNo        ZDayNo3
     C                   ENDIF

     C**********         IF        NullIndDs(9) = 0                                        AR1036892
     C**********         EVAL      TmpDat04 = %DATE(%SUBST(BFRCRTON:1:10):*ISO)            AR1036892
     C**********         EVAL      DatNum04 = %DEC(TmpDat03)                               AR1025965
     C                   EVAL      TmpDat04 = *LOVAL                                        MD042109
      ** Approved Date                                                                      MD042109
     C                   IF        NullIndDs(11) = 0                                       AR1036892
     C                   EVAL      TmpDat04 = %DATE(%SUBST(BFAPRDAT:1:10):*ISO)            AR1036892
     C                   ELSE                                                               MD042109
      ** Last Modified Date                                                                 MD042109
     C                   IF        NullIndDs(08) = 0                                        MD042109
     C                   EVAL      TmpDat04 = %DATE(%SUBST(BFLSTMOD:1:10):*ISO)             MD042109
     C                   ELSE                                                               MD042109
      ** Created on Date                                                                    MD042109
     C                   IF        NullIndDs(09) = 0                                        MD042109
     C                   EVAL      TmpDat04 = %DATE(%SUBST(BFRCRTON:1:10):*ISO)             MD042109
     C                   ENDIF                                                              MD042109
     C                   ENDIF                                                              MD042109
     C                   ENDIF                                                              MD042109
     C                   IF        TmpDat04 <> *LOVAL                                       MD042109
     C                   EVAL      DatNum04 = %DEC(TmpDat04)                               AR1025965
     C                   EVAL      PDateIN  = DatNum04
     C                   EXSR      SRZDateO
     C                   Z-ADD     ZDayNo        ZDayNo4
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      **SrZdateO**-*Subroutine*to*Convert*from*DDMMYY***to*Midas*******                    AR1097353
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

     C                   EVAL      DBPGM = 'GP004013'

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
