     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP User/Role Entitlement Audit Report')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP004012 - User/Role Entitlement Audit Report                *
      *                                                               *
      *  Function: Produce Midas GP User/Role Entitlement Audit Report*
      *                                                               *
      *  Called By: GOC004012 - User/Role Entitlement Audit Report    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD020168           Date 23Apr13               *
      *  Prev Amend No. AR1097353          Date 26Mar13               *
      *                 AR1036892          Date 27Sep12               *
      *                 AR1034050          Date 20Sep12               *
      *                 AR1032571          Date 14Sep12               *
      *                 AR1030958          Date 13Sep12               *
      *                 AR1029790          Date 11Sep12               *
      *                 AR1029172          Date 06Sep12               *
      *                 AR1028208          Date 05Sep12               *
      *                 AR1027797          Date 03Sep12               *
      *                 AR1025965          Date 31Aug12               *
      *                 CBF022  *CREATE    Date 16Jul12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD020168 - Error in GOC004012 00001                          *
      *  AR1097353 - No Event code Audit Report was generated.        *
      *              Additional fix for AR1096060.                    *
      *  AR1036892 - Transaction not approved during CoB run and      *
      *              consequently approved after CoB did not appear   *
      *              in the report                                    *
      *  AR1034050 - Remove entitlement is not reported in the Audit  *
      *              report                                           *
      *  AR1032571 - Change Date and Change timestamp is blank on     *
      *              amended report                                   *
      *  AR1030958 - Last Modified Date field of the Child must       *
      *              reflect in Parent also (Platform changes, thus   *
      *              partial fix of AR1029790 will be reversed)       *
      *  AR1029790 - Amended User/Role Entitlement is reported as     *
      *              instead of Amended                               *
      *  AR1029172 - Auditable Report contains some descrepancies     *
      *              (Recompile)                                      *
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
      * *INZSR    - Program Initialisation                            *
      * *PSSR     - Error Handling Subroutine                         *
      * SrFetch   - Subroutine to Fetch Record from File              *
      * SrPrint   - Subroutine to Print the Record on the Main PRTF   *
      * SrPrint2  - Subroutine to Print the Secondary Details         *
      * SrPrint3  - Subroutine to Print the Third Details             *
      * SrOvrFlw  - Subroutine to Check for Overflow                  *
      * SrOvrFlw2 - Subroutine to Check for Overflow                  *
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
     FGP004012P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
 
      ** Midas GP Role Audit Report - Audit
     FGP004012AUO    E             PRINTER INFSR(*PSSR)
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
      **                                    134 141 RFile
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
 
     D UsrRoleDs       DS
     D  BFUSERID                     32A
     D  BFUSRNAM                     52A
     D  BFENTTYP                     52A
     D  BFGRPNAM                     32A
     D  BFENTVAL                     52A
     D  BFENTDES                    258A
     D  BFMODDBY                     32A
     D  BFCRTDBY                     32A
     D  BFLSTMOD                     26A
     D  BFRCRTON                     26A
     D  BFRAPRBY                     32A
     D  BFAPRDAT                     26A
 
     D GrpNamDs        DS            64
     D  GrpNm1                 1     32A
     D  GrpNm2                33     64A
 
     D EntValDs        DS            52
     D  EntVl1                 1     13A
     D  EntVl2                14     26A
     D  EntVl3                27     39A
     D  EntVl4                40     52A
 
     D EntDscDs        DS           258
     D  EntDs1                 1     43A
     D  EntDs2                44     86A
     D  EntDs3                87    129A
     D  EntDs4               130    172A
     D  EntDs5               173    215A
     D  EntDs6               216    258A
 
     D NullIndDs       S              5I 0 DIM(12)
 
      ** Input Parameter for ZDATEO
     D                 DS
     D PDateIn                 1      8  0
 
     D**ZDate***        S              6  0                                                AR1097353
     D ZDate           S              8S 0                                                 AR1097353
     D ZDayNo          S              5  0
     D ZError          S              2  0
 
     D ZDayNo3         S              5P 0
     D***ZDayNo4***      S              5P 0                                              AR1036892
 
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
 
      ** Other Work Variables
     D WRun            S              1A
     D Error           S              1A
     D wFlag           S              1A
     D wFlag2          S              1A
     D*WFlgCtr**       S              3  0                                                 AR1027797
     D WFlgCtr         S              6  0                                                 AR1027797
     D*WFlgCtr2*       S              3  0                                                  MD020168
     D WFlgCtr2        S              6  0                                                  MD020168
     D*wUserID**       S             32A                                                   AR1034050
     D wUserID         S             32A   INZ('initial')                                  AR1034050
     D wZone           S             10A
 
     D wFirst          S              1    INZ('Y')
     D wSecon          S              1    INZ('Y')
     D wNoRec          S              4S 0
     D RqdLn1          S              3  0
     D DifLn1          S              3  0
 
     D**TmpDat03        S               D   DATFMT(*DMY)                                   AR1097353
     D TmpDat03        S               D   DATFMT(*ISO)                                    AR1097353
     D DatNum03        S              8S 0
 
     D***TmpDat04***     S               D   DATFMT(*DMY)                                  AR1036892
     D***DatNum04***     S              8S 0                                               AR1036892
 
     D wEntTyp         S             52A
 
      ** +--------------------------------------+
      ** ¦ Declared Constants                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D wNoEntl         S             32A   INZ('**********  ')
     D wNoDesc1        S             52A   INZ('  No Entitlement Permitted to +
     D                                     the User')
     D wNoRole         S             32A   INZ('**********')
     D wNoDesc2        S            258A   INZ('No Role Permitted To The +
     D                                     Entitlement Type')
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Read All Records from the Result Set of the SQL Statement
 
     C/exec sql
     C+ declare mainCursor Cursor
     C+  for select
     C***A.BFUSERNAME,*************************************************                    AR1034050
     C***B.BFUSERID,***************************************************                    AR1034050
     C***A.BFENTITLEMENTTYPE,******************************************                    AR1034050
     C***A.BFGROUPNAME,************************************************                    AR1034050
     C***A.BFENTITLEMENTVALUE,*****************************************                    AR1034050
     C***A.BFDESCRIPTION,**********************************************                    AR1034050
     C+  A.BFNAMEPK,                                                                       AR1034050
     C+  A.BFUSERID,                                                                       AR1034050
     C+  B.BFENTITLEMENTTYPE,                                                              AR1034050
     C+  B.BFGROUPNAME,                                                                    AR1034050
     C+  B.BFENTITLEMENTVALUE,                                                             AR1034050
     C+  B.BFDESCRIPTION,                                                                  AR1034050
     C+  A.BFRECLASTMODIFIEDBY,
     C+  A.BFRECCREATEDBY,
     C+  A.BFRECLASTMODIFIEDDATE,
     C+  A.BFRECCREATEDON,
     C+  A.BFRECAPPROVEDBY,
     C+  A.BFRECAPPROVEDDATE
     C+
     C***from*MIVW_ENTL*A**********************************************                    AR1034050
     C***left*outer*join*MIVW_USER*B*on*B.BFNAMEPK*=*A.BFUSERNAME******                    AR1034050
     C+  from MIVW_USER A                                                                  AR1034050
     C+  left outer join MIVW_ENTL B on B.BFUSERNAME =  A.BFNAMEPK                         AR1034050
     C+
     C+  where
     C+   A.BFRECLASTMODIFIEDDATE is not null or
     C+   A.BFRECCREATEDON is not null
     C+
     C+  order by
     C***A.BFUSERNAME,*************************************************                    AR1034050
     C***A.BFENTITLEMENTTYPE,******************************************                    AR1034050
     C***A.BFGROUPNAME*************************************************                    AR1034050
     C+  A.BFNAMEPK,                                                                       AR1034050
     C+  B.BFENTITLEMENTTYPE,                                                              AR1034050
     C+  B.BFGROUPNAME                                                                     AR1034050
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
     C                   IF        ZDayNo3  = BJRDNB                                       AR1036892
 
      ** If Different Event Group ID
 
     C                   IF        BFUSERID <> wUserID
     C                   EVAL      wFlag =  ' '
     C                   EVAL      wFlgCtr = 0
     C                   EVAL      wNoRec  = wNoRec+ 1
     C                   EXSR      SrPrint
     C                   EVAL      wEntTyp = *BLANKS
     C                   EVAL      wSecon  = 'Y'
     C                   ENDIF
 
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
     C+  into :UsrRoleDs indicator :NULLINDDS
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
 
     C                   IF        NOT %OPEN(GP004012P1)
     C                   OPEN      GP004012P1
     C                   ENDIF
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PZSSeq
     C                   PARM      *BLANKS       PZSEnty
     C                   PARM      SFILE1        PZSFile
     C                   PARM      SFNUM1        PZSNum
     C                   PARM      *BLANK        PZSErr
 
     C                   IF        PZSERR = 'Y'
     C                   EVAL      DBASE  = 2
     C                   EVAL      RFILE  = 'ZSFILE'
     C                   MOVE      PZSNUM        DBKEY
     C                   EVAL      Error = 'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CLEAR                   DETAIL1                                   AR1028208
     C                   WRITE     HEADP1
     C                   EVAL      wFirst = 'Y'
 
      ** Last Change User
 
     C                   IF        BFMODDBY <> *BLANKS
     C                   EVAL      RUSER  = BFMODDBY
     C                   ELSE
     C                   EVAL      RUSER  = BFCRTDBY
     C                   ENDIF
 
      ** Change Date
 
     C**********         IF        BFLSTMOD <> *BLANKS                                     AR1029790
     C**********         IF        NullIndDs(9) = 0                                        AR1029790
     C**********         EVAL      RCDAT = BFLSTMOD                                        AR1029790
     C**********         ENDIF                                                             AR1029790
     C**********         ELSE                                                              AR1029790
     C                   IF        BFLSTMOD <> *BLANKS                                     AR1030958
     C                   IF        NullIndDs(9) = 0                                        AR1030958
     C                   EVAL      RCDAT = BFLSTMOD                                        AR1030958
     C                   ELSE                                                              AR1032571
     C                   IF        NullIndDs(10) = 0                                       AR1032571
     C                   EVAL      RCDAT = BFRCRTON                                        AR1032571
     C                   ENDIF                                                             AR1032571
     C                   ENDIF                                                             AR1030958
     C                   ELSE                                                              AR1030958
     C                   IF        NullIndDs(10) = 0
     C                   EVAL      RCDAT = BFRCRTON
     C                   ENDIF
     C**********         ENDIF                                                             AR1029790
     C                   ENDIF                                                             AR1030958
 
      ** Change Timestamp
 
     C**********         IF        BFLSTMOD <> *BLANKS                                     AR1029790
     C**********         IF        NullIndDs(9) = 0                                        AR1029790
     C**********         EVAL      RTIME = BFLSTMOD                                        AR1029790
     C**********         ENDIF                                                             AR1029790
     C**********         ELSE                                                              AR1029790
     C                   IF        BFLSTMOD <> *BLANKS                                     AR1030958
     C                   IF        NullIndDs(9) = 0                                        AR1030958
     C                   EVAL      RTIME = BFLSTMOD                                        AR1030958
     C                   ELSE                                                              AR1032571
     C                   IF        NullIndDs(10) = 0                                       AR1032571
     C                   EVAL      RTIME = BFRCRTON                                        AR1032571
     C                   ENDIF                                                             AR1032571
     C                   ENDIF                                                             AR1030958
     C                   ELSE                                                              AR1030958
     C                   IF        NullIndDs(10) = 0
     C                   EVAL      RTIME = BFRCRTON
     C                   ENDIF
     C**********         ENDIF                                                             AR1029790
     C                   ENDIF                                                             AR1030958
 
      ** Last Change Action
 
     C**********         IF        ZDayNo3 = 0                                             AR1029790
     C**********         EVAL      RACTN = 'Insert'                                        AR1029790
     C**********         ELSE                                                              AR1029790
     C                   EVAL      RACTN = 'Amend'
     C**********         ENDIF                                                             AR1029790
 
      ** Last Authorising User
 
     C                   EVAL      RAUTH = BFRAPRBY
 
      ** Authorisation Date
 
     C                   IF        NullIndDs(12) = 0
     C                   EVAL      RAUDT = BFAPRDAT
     C                   ENDIF
 
      ** Authorisation Timestamp
 
     C                   IF        NullIndDs(12) = 0                                       AR1028208
     C                   EVAL      RATIM = BFAPRDAT
     C                   ENDIF                                                             AR1028208
 
      ** User ID
 
     C                   EVAL      RUSID = BFUSERID
 
      ** User Name
 
     C                   EVAL      RNAME = BFUSRNAM
 
     C                   EVAL      wUserID = BFUSERID
                                                                                           AR1027797
      ** Write User/Role Entitlement to Report                                             AR1027797
                                                                                           AR1027797
     C                   WRITE     DETAIL1
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrint2 - Subroutine to Print the Secondary Details          *
      *                                                               *
      *****************************************************************
     C     SrPrint2      BEGSR
 
     C                   IF        BFENTTYP <> *BLANKS AND
     C                             BFENTTYP <> wEntTyp
     C                   EVAL      RENTL = BFENTTYP
     C                   EVAL      wEntTyp = BFENTTYP
     C                   EXSR      SrOvrFlw
     C                   WRITE     DETAIL2
 
     C                   EVAL      WFlgCtr = WFlgCtr + 1
     C                   ELSE
 
     C                   IF        WFlgCtr = 0
     C                   EVAL      RENTL = %Trim(wNoEntl) + wNoDesc1
     C                   EXSR      SrOvrFlw
     C                   WRITE     DETAIL2
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        BFENTTYP <> *BLANKS AND
     C                             BFENTTYP =  wEntTyp AND
     C                             WFlgCtr <> 0
     C                   EXSR      SrOvrFlw                                                 MD020168
     C                   EXSR      SrPrint3
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrint3 - Subroutine to Print the Secondary Details          *
      *                                                               *
      *****************************************************************
     C     SrPrint3      BEGSR
 
     C                   IF        BFGRPNAM <> *BLANKS
     C                   EVAL      WFlgCtr2 =0                                              MD020168
     C                   EVAL      GrpNamDs = BFGRPNAM
     C                   EVAL      EntValDs = BFENTVAL
     C                   EVAL      EntDscDs = BFENTDES
     C                   EVAL      WFlgCtr2 = WFlgCtr2 + 1
     C                   ELSE
 
     C                   IF        wFlag2 <> 'Y'
     C                             AND WFlgCtr2 < 1
     C                   EVAL      GrpNamDs = wNoRole
     C                   EVAL      EntDscDs = wNoDesc2
     C                   EVAL      wFlag2 =  'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      SrOvrFlw2
 
     C                   IF        GrpNm1 <> *Blanks OR
     C                             EntVl1 <> *Blanks OR
     C                             EntDs1 <> *Blanks
     C                   EVAL      RROLE = GrpNm1
     C                   EVAL      RENTV = EntVl1
     C                   EVAL      REDES = EntDs1
     C                   WRITE     DETAIL3
     C                   ENDIF
 
     C                   IF        GrpNm2 <> *Blanks OR
     C                             EntVl2 <> *Blanks OR
     C                             EntDs2 <> *Blanks
     C                   EVAL      RROLE = GrpNm2
     C                   EVAL      RENTV = EntVl2
     C                   EVAL      REDES = EntDs2
     C                   WRITE     DETAIL3
     C                   ENDIF
 
     C                   IF        EntVl3 <> *Blanks OR
     C                             EntDs3 <> *Blanks
     C                   EVAL      RENTV = EntVl3
     C                   EVAL      REDES = EntDs3
     C                   WRITE     DETAIL3
     C                   ENDIF
 
     C                   IF        EntVl4 <> *Blanks OR
     C                             EntDs4 <> *Blanks
     C                   EVAL      RENTV = EntVl4
     C                   EVAL      REDES = EntDs4
     C                   WRITE     DETAIL3
     C                   ENDIF
 
     C                   IF        EntDs5 <> *Blanks
     C                   EVAL      REDES = EntDs5
     C                   WRITE     DETAIL3
     C                   ENDIF
 
     C                   IF        EntDs6 <> *Blanks
     C                   EVAL      REDES = EntDs6
     C                   WRITE     DETAIL3
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
     C                             wFirst = 'Y'
     C                   WRITE     HEADP2
     C                   EVAL      wFirst = 'N'
     C                   ENDIF
 
     C                   EVAL      RqdLn1 = 11                                             AR1027797
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                AR1027797
                                                                                           AR1027797
     C                   IF        DifLn1 <= RqdLn1 AND
     C                             wFirst = 'N'
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrOvrFlw2 - Subroutine to Check for Overflow                  *
      *                                                               *
      *****************************************************************
     C     SrOvrFlw2     BEGSR
 
     C                   EVAL      RqdLn1 = 6
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             wSecon = 'Y'
     C                   WRITE     HEADP3
     C                   EVAL      wSecon = 'N'
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
 
      ** Close P1 and Write Trailer Record Format
 
     C                   IF        %OPEN(GP004012P1)
 
     C**********         EVAL      RqdLn1 = 4                                              AR1027797
     C                   EVAL      RqdLn1 = 6                                              AR1027797
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     TRAILP1
     C                   CLOSE     GP004012P1
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
     C                   IF        wNoRec = 0
 
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
     C                   EVAL      RFILE  = 'ZSFILE'
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
 
     C                   IF        %OPEN(GP004012P1)
     C                   CLOSE     GP004012P1
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
 
     C**********         IF        NullIndDs(9) = 0                                        AR1036892
     C**********         EVAL      TmpDat03 = %DATE(%SUBST(BFLSTMOD:1:10):*ISO)            AR1036892
     C                   IF        NullIndDs(10) = 0                                       AR1036892
     C                   EVAL      TmpDat03 = %DATE(%SUBST(BFAPRDAT:1:10):*ISO)            AR1036892
     C                   EVAL      DatNum03 = %DEC(TmpDat03)
     C                   EVAL      PDateIN  = DatNum03
     C                   EXSR      SRZDateO
     C                   Z-ADD     ZDayNo        ZDayNo3
     C                   ENDIF
 
     C**********         IF        NullIndDs(10) = 0                                       AR1036892
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
 
     C                   EVAL      DBPGM = 'GP004012'
 
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
     C                   EVAL      RFILE  = 'GZSDBANKPD'
     C                   EVAL      DBKEY  = PZone
     C                   OUT       LDA
     C                   EVAL      Error  = 'Y'
     C                   EXSR      SrAudit
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
