     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP Permissions By Role Report')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP004003 - Midas GP Permissions By Role Report               *
      *                                                               *
      *  Function: Produce Midas GP Permissions By Role Report        *
      *                                                               *
      *  Called By: GPC004003 - Midas GP Permissions By Role Report   *
      *                                                               *
      *     (c) Finastra International Limited 2011                   *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD042298           Date 08Nov16               *
      *                 MD037908           Date 21Mar16               *
      *                 AR924843           Date 08Mar12               *
      *                 AR892737C          Date 01Feb12               *
      *                 AR878597           Date 13Dec11               *
      *                 CBF005  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD042298 - Reports GP004003 / GP004005 not generated         *
      *  MD037908 - Inhouse permissions missing. (MI_CST_*)           *
      *  AR924843 - Entitlement Type 'Branch' as Booking Branch       *
      *  AR892737C - Permissions by User Report does not allow lower  *
      *              case characters on user profile input            *
      *  AR878597 - Global Compilation Issues                         *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      * *INZSR    - Program initialisation                            *
      * *PSSR     - Error handling subroutine                         *
      * SrExcSQLF - Subroutine to the declare and create aliases      *
      *             for files used in SQL statements in the program   *
      * SrClsSQLF - Subroutine to drop aliases used for files used in *
      *             SQL statements in the program                     *
      * SrGetUsrR - Subroutine to get User ID for Request of the      *
      *             report                                            *
      * SrExcSQLU - Subroutine to execute SQL script for getting      *
      *             User ID for Request of the report                 *
      * SRFtcSQLU - Subroutine to fetch records of StmSQLU for getting*
      *             User ID for Request of the report                 *
      * SrClsSQLU - Subroutine to close recordset of StmSQLU          *
      * SrPrcesRpt - Subroutine to process the main report            *
      * SrPrcesLv1 - Subroutine to get list of Level 1 field to report*
      *              and in which Level 1 field the Requesstor/User   *
      *              for request is authorised                        *
      * SrExcSQL1 - Subroutine to execute SQL script for getting      *
      *             Level 1 field in the report                       *
      * SRFtcSQL1 - Subroutine to fetch records of StmSQL1 for getting*
      *             Level 1 field in the report                       *
      * SrClsSQL1 - Subroutine to close recordset of StmSQL1          *
      * SrPrcesLv2 - Subroutine to get list of Level 2 field to report*
      *              and in which Level 2 field the Level 1 field is  *
      *              authorised                                       *
      * SrExcSQL2 - Subroutine to execute SQL script for getting      *
      *             Level 2 field in the report                       *
      * SRFtcSQL2 - Subroutine to fetch records of StmSQL1 for getting*
      *             Level 2 field in the report                       *
      * SrClsSQL2 - Subroutine to close recordset of StmSQL2          *
      * SrPrcesLv3 - Subroutine to get list of Level 3 field to report*
      *              and in which Level 3 field the Level 2 field is  *
      *              authorised                                       *
      * SrExcSQL3 - Subroutine to execute SQL script for getting      *
      *             Level 3 field in the report                       *
      * SRFtcSQL3 - Subroutine to fetch records of StmSQL1 for getting*
      *             Level 3 field in the report                       *
      * SrClsSQL3 - Subroutine to close recordset of StmSQL3          *
      * SrPrintRcd - Subroutine to print the record on the main PRTF  *
      * SrBegP1 - Subroutine to open the main PRTF of the report      *
      * SrEndP1 - Subroutine to close the main PRTF or the report     *
      * SrRCFP1 - Register the P1 Printer File via RCF                *
      * SrAudit - Subroutine to print the Audit of the report         *
      * SrRCFAU - Register the AU Printer File via RCF                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  I N D I C A T O R S   I N D E X                              *
      *                                                               *
      * 10 - No Consolidations                                        *
      * 11 - Consolidated in Level 1 field                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  V A R I A B L E   I N D E X                                  *
      *                                                               *
      * LPMode = 1 : Report for all users                             *
      * LPMode = 2 : Report for a specific user                       *
      * LPMode = 3 : Report for a list of specific users              *
      *              Tables to be used are overriden                  *
      * PCnsld = 0 : No Consolidations                                *
      * PCnsld = 1 : Consolidated in Level 1 field                    *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas GP Permissions By User Report
      *
     FGP004003P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F
      *
      ** Midas GP Permissions By User Report - Audit
      *
     FGP004003AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
     F
      *
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
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** External DS for Bank Details
      *
     D GZSDBANK      E DS                  EXTNAME(GZSDBANKPD)
      *
      ** Short DS for Access Objects
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** File information DS for main PRTF
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ** File information DS for audit PRTF
      *
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     DSDS             SDS
     D  JBNAM                244    253
     D  JBUSR                254    263
     D  JBNUM                264    269
      *
      ** DS for SQL cursor RS1
      **    B.A8BRCD                  3A
      **    B.A8BRNM                 30A
      *
     D DSRS1           DS
     D S1_BRCD                 1      3
     D S1_BRNM                 4     33
      *
      ** Temporary DS for SQL cursor RS1
      *
     D DSRS1T          DS
     D S1T_BRCD                1      3
     D S1T_BRNM                4     33
      *
      ** DS for SQL cursor RS2
      **    C.BFGROUPNAME,           30A
      **    C.BFGROUPDISPLAYNAME     60A
      *
     D DSRS2           DS
     D S2_GNAM                 1     30
     D*S2_GDNM**              31     90                                                    AR892737C
      *
      ** Temporary DS for SQL cursor RS2
      *
     D DSRS2T          DS
     D S2T_GNAM                1     30
     D*S2T_GDNM*              31     90                                                    AR892737C
      *                                                                                    AR892737C
      ** DS for SQL cursor RS2N                                                            AR892737C
      **    C.BFGROUPDISPLAYNAME     60A                                                   AR892737C
      *                                                                                    AR892737C
     D DSRS2N          DS                                                                  AR892737C
     D S2N_GDNM                1     60                                                    AR892737C
      *
      ** DS for SQL cursor RS3
      **    E.BFPERMISSIONNAME      256A
      **    H.BFDISPLAYNAME         256A
      *
     D DSRS3           DS
     D S3_PNAM                 1    256
     D S3_PDES               257    512
      *
      ** Temporary DS for SQL cursor RS3
      *
     D DSRS3T          DS
     D S3T_PNAM                1    256
     D S3T_PDES              257    512
      *
      ** DS for SQL cursor RSU - User ID For Request
      **    F.D5USRR                 10A
      *
     D DSRSU           DS
     D SU_USID                 1     10
      *
      ** Program entry parameters DS
      *
     D PAllParm        DS
     D PCnsld                  1      1
     D PSeq                    2      6
     D PLevl                   7      7
     D PEnty                   8     10
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameters for ZSFILE
      *
     D PZSEnty         S              3
     D PZSFile         S             10
     D PZSNum          S              6  0
     D PZSErr          S              1
     D PZSSeq          S              5A
      *
      ** Parameters for Access Programs
      *
     D POption         S              7A
     D PRetCode        S              7A
     D PZone           S             10A
     D PErms           S             50A
     D PCache          S              1A
     D PRecImage       S          32000A
      *
      ** Parameters for GOGETZONE
      *
     D I#RTCD          S              7A
     D I#ERMS          S             50A
     D I#FULLCHECK     S              1A
     D O#ZONE          S             10A
     D O#SHTC          S              4A
     D O#RDNB          S              5  0
     D O#DNWD          S              5  0
     D O#BCCY          S              3A
     D O#NJOB          S              1  0
      *
      ** SQL work variables
      *
     D StmSQL1         S           2000A
     D StmSQL2         S           2000A
     D StmSQL2N        S           2000A                                                   AR892737C
     D StmSQL3         S           2000A
     D StmSQLU         S           2000A
     D*WCtrRS1**       S              5  0 INZ(*ZEROS)                                     AR892737C
     D*WCtrRS2**       S              5  0 INZ(*ZEROS)                                     AR892737C
     D*WCtrRS3**       S              5  0 INZ(*ZEROS)                                     AR892737C
     D WCtrRS1         S             10  0 INZ(*ZEROS)                                     AR892737C
     D WCtrRS2         S             10  0 INZ(*ZEROS)                                     AR892737C
     D WCtrRS3         S             10  0 INZ(*ZEROS)                                     AR892737C
     D StmBrn          S           2000A                                                   AR892737C
      *
      ** Other work variables
      *
     D WRun            S              1A
     D Error           S              1A
      *
      ** +--------------------------------------+
      ** ¦ Declared constants                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D*WEntType*       C                   'BookingBranch'                                  AR924843
     D WEntType        C                   'Branch'                                         AR924843
     D Upper           C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                    AR892737C
     D Lower           C                   'abcdefghijklmnopqrstuvwxyz'                    AR892737C
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Process Report
      *
     C                   EXSR      SrPrcesRpt
      *
      ** Audit Report
      *
     C                   EXSR      SrAudit
      *
      ** Return
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrcesRpt - Subroutine to process the main report            *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: SrBegP1, SrPrcesLv1, SrEndP1, SrClsSQLF                *
      *                                                               *
      *****************************************************************
     C     SrPrcesRpt    BEGSR
      *
      ** Open Report file
      *
     C                   EXSR      SrBegP1
      *
      ** Process Level 1 field of the Report
      *
     C**********         IF        PCnsld = '0'                                            AR892737C
     C                   EXSR      SrPrcesLv1
      **********                                                                           AR892737C
      ***Process*Level*2*field*of*the*Report***************************                    AR892737C
      **********                                                                           AR892737C
     C**********         ELSEIF    PCnsld = '1'                                            AR892737C
     C**********         EXSR      SrPrcesLv2                                              AR892737C
     C**********         ENDIF                                                             AR892737C
      *
      ** Close Report file
      *
     C                   EXSR      SrEndP1
      *
      ** Close SQL query F - Files Declaration
      *
     C                   EXSR      SrClsSQLF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrcesLv1 - Subroutine to get list of Level 1 field to report*
      *              and in which Level 1 field the Requestor/User    *
      *              for request is authorised                        *
      *                                                               *
      * Called by: SrPrcesRpt                                         *
      *                                                               *
      * Calls: SrExcSQL1, SrFtcSQL1, SrClsSQL1, SrPrcesLv2            *
      *                                                               *
      *****************************************************************
     C     SrPrcesLv1    BEGSR
      *
      ** Excecute SQL query 1
      *
     C                   EXSR      SrExcSQL1
     C                   EVAL      StmBrn = *BLANKS                                        AR892737C
      *
      ** Fetch first recordset of SQL query 1
      *
     C                   EXSR      SrFtcSQL1
     C                   DOW       SQLCODE = *ZEROS
      *
      ** Process Level 2 field of the Report
      *
     C                   IF        PCnsld = '0'                                            AR892737C
     C                   EXSR      SrPrcesLv2
     C                   ELSEIF    PCnsld = '1'                                            AR892737C
     C                   IF        StmBrn <> *BLANKS                                       AR892737C
     C                   EVAL      StmBrn = %TRIM(StmBrn) + ' OR'                          AR892737C
     C                   ENDIF                                                             AR892737C
     C                   EVAL      StmBrn=%TRIM(StmBrn)+' A.BFENTITLEMENTVALUE'+           AR892737C
     C                                      ' = ''' + S1_BRCD + ''''                       AR892737C
     C                   ENDIF                                                             AR892737C
      *
      ** Fetch next recordset of SQL query 1
      *
     C                   EXSR      SrFtcSQL1
     C                   EVAL      DSRS1T = *BLANKS
     C                   ENDDO
     C                   IF        PCnsld = '1'                                            AR892737C
     C                             AND StmBrn <> *BLANKS                                   AR892737C
     C                   EXSR      SrPrcesLv2                                              AR892737C
     C                   ENDIF                                                             AR892737C
      *
      ** Close SQL query 1
      *
     C                   EXSR      SrClsSQL1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrcesLv2 - Subroutine to get list of Level 2 field to report*
      *              and in which Level 2 field the Level 1 field is  *
      *              authorised                                       *
      *                                                               *
      * Called by: SrPrcesLv1                                         *
      *                                                               *
      * Calls: SrExcSQL2, SrFtcSQL2, SrClsSQL2, SrPrcesLv3            *
      *                                                               *
      *****************************************************************
     C     SrPrcesLv2    BEGSR
      *
      ** Excecute SQL query 2
      *
     C                   EXSR      SrExcSQL2
      *
      ** Fetch first recordset of SQL query 2
      *
     C                   EXSR      SrFtcSQL2
     C                   DOW       SQLCODE = *ZEROS
     C                   EXSR      SrExcSQL2N                                              AR892737C
     C                   EXSR      SrFtcSQL2N                                              AR892737C
      *
      ** Process Level 3 field of the Report
      *
     C                   EXSR      SrPrcesLv3
      *
      ** Fetch next recordset of SQL query 2
      *
     C                   EXSR      SrClsSQL2N                                              AR892737C
     C                   EXSR      SrFtcSQL2
     C                   EVAL      DSRS2T = *BLANKS
     C                   ENDDO
      *
      ** Close SQL query 2
      *
     C                   EXSR      SrClsSQL2
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrcesLv3 - Subroutine to get list of Level 3 field to report*
      *              and in which Level 3 field the Level 2 field is  *
      *              authorised                                       *
      *                                                               *
      * Called by: SrPrcesLv2                                         *
      *                                                               *
      * Calls: SrExcSQL3, SrFtcSQL3, SrClsSQL3, SrPrintRcd            *
      *                                                               *
      *****************************************************************
     C     SrPrcesLv3    BEGSR
      *
      ** Excecute SQL query 3
      *
     C                   EXSR      SrExcSQL3
      *
      ** Fetch first recordset of SQL query 3
      *
     C                   EXSR      SrFtcSQL3
     C                   DOW       SQLCODE = *ZEROS
      *
      ** Print Report Record
      *
     C                   EXSR      SrPrintRcd
      *
      ** Fetch next recordset of SQL query 3
      *
     C                   EXSR      SrFtcSQL3
     C                   EVAL      DSRS3T = *BLANKS
     C                   ENDDO
      *
      ** Close SQL query 3
      *
     C                   EXSR      SrClsSQL3
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrintRcd - Subroutine to print the record on the main PRTF  *
      *                                                               *
      * Called by: SrPrcesLv3                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrPrintRcd    BEGSR
      *
      ** Write Level 1 Details
      *
     C                   IF        S1_BRCD <> S1T_BRCD
     C                             AND PCnsld = '0'
     C                   IF        OFLLN1 <= PRTLN1 + 3
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   EVAL      RBRCD = S1_BRCD
     C                   EVAL      RBRNM = S1_BRNM
     C                   EVAL      DSRS1T = DSRS1
     C                   EVAL      WCtrRS1 = WCtrRS1 + 1
     C                   WRITE     DETAIL1
     C                   ENDIF
      *
      ** Write Level 1 Details as consolidated
      *
     C                   IF        WCtrRS3 = 0
     C                             AND PCnsld = '1'
     C                   WRITE     DETAIL1
     C                   ENDIF
      *
      ** Write Level 2 Details
      *
     C                   IF        S2_GNAM <> S2T_GNAM
     C                   IF        OFLLN1 <= PRTLN1 + 5
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   EVAL      RGNAM = S2_GNAM
     C**********         EVAL      RGDNM = S2_GDNM                                         AR892737C
     C                   EVAL      RGDNM = S2N_GDNM                                        AR892737C
     C                   EVAL      DSRS2T = DSRS2
     C                   EVAL      WCtrRS2 = WCtrRS2 + 1
     C                   WRITE     DETAIL2
     C                   ENDIF
      *
      ** Write Level 3 Details
      *
     C                   IF        OFLLN1 <= PRTLN1 + 3
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   EVAL      RPNAM = S3_PNAM
     C                   EVAL      RPDES = S3_PDES
     C                   EVAL      DSRS3T = DSRS3
     C                   EVAL      WCtrRS3 = WCtrRS3 + 1
     C                   WRITE     DETAIL3
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrExcSQLF - Subroutine to the declare and create aliases      *
      *             for files used in SQL statements in the program   *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrExcSQLF     BEGSR
      *
     C/EXEC SQL
     C+ CREATE ALIAS A FOR MIVW_ENTL
     C/END-EXEC
      *
     C/EXEC SQL
     C+ CREATE ALIAS B FOR GZSDBRCHPD
     C/END-EXEC
      *
     C/EXEC SQL
     C+ CREATE ALIAS C FOR MIVW_ORGP
     C/END-EXEC
      *
     C/EXEC SQL
     C+ CREATE ALIAS D FOR MIVW_GPMP
     C/END-EXEC
      *
     C/EXEC SQL
     C+ CREATE ALIAS E FOR MIVW_PRMN
     C/END-EXEC
      *
     C/EXEC SQL
     C+ CREATE ALIAS F FOR FCRREQPD
     C/END-EXEC
      *
     C/EXEC SQL
     C+ CREATE ALIAS H FOR MIVW_RPMP
     C/END-EXEC
      *
     C/EXEC SQL
     C+ CREATE ALIAS I FOR MIVW_RSRC
     C/END-EXEC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrClsSQLF - Subroutine to drop aliases used for files used in *
      *             SQL statements in the program                     *
      *                                                               *
      * Called by: SrPrcesRpt                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrClsSQLF     BEGSR
      *
     C/EXEC SQL
     C+ DROP ALIAS A
     C/END-EXEC
      *
     C/EXEC SQL
     C+ DROP ALIAS B
     C/END-EXEC
      *
     C/EXEC SQL
     C+ DROP ALIAS C
     C/END-EXEC
      *
     C/EXEC SQL
     C+ DROP ALIAS D
     C/END-EXEC
      *
     C/EXEC SQL
     C+ DROP ALIAS E
     C/END-EXEC
      *
     C/EXEC SQL
     C+ DROP ALIAS F
     C/END-EXEC
      *
     C/EXEC SQL
     C+ DROP ALIAS H
     C/END-EXEC
      *
     C/EXEC SQL
     C+ DROP ALIAS I
     C/END-EXEC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGetUsrR - Subroutine to get User ID for Request of the      *
      *             report                                            *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: SrExcSQLU, SrFtcSQLU, SrClsSQLU                        *
      *                                                               *
      *****************************************************************
     C     SrGetUsrR     BEGSR
      *
     C                   EXSR      SrExcSQLU
      *
     C                   EXSR      SrFtcSQLU
      *
     C                   EXSR      SrClsSQLU
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrExcSQL1 - Subroutine to execute SQL script for getting      *
      *             Level 1 field in the report                       *
      *                                                               *
      * Called by: SrPrcesLv1                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrExcSQL1     BEGSR
      *
      ** Reset SQL Statement
      *
     C                   EVAL      StmSQL1 = *BLANKS
      *
      ** Statement: SELECT
      *
     C                   EVAL      StmSQL1 = %TRIM(StmSQL1) + 'SELECT         '+
     C                             ' DISTINCT                                 '+
     C                             ' B.A8BRCD  ,                              '+
     C                             ' B.A8BRNM                                 '
      *
      ** Statement: FROM
      *
     C                   EVAL      StmSQL1 = %TRIM(StmSQL1) + ' FROM          '+
     C                             ' A,                                       '+
     C                             ' B                                        '
      *
      ** Statement: WHERE
      *
     C                   EVAL      StmSQL1 = %TRIM(StmSQL1) + ' WHERE         '+
     C                             ' A.BFENTITLEMENTTYPE = '''+WEntType+'''   '+
     C**********                   ' AND A.BFUSERNAME = '''+SU_USID+'''       '+           AR892737C
     C                             ' AND UCASE(A.BFUSERNAME) = '''+SU_USID+''''+           AR892737C
     C                             ' AND A.BFENTITLEMENTVALUE = B.A8BRCD      '
     C                   IF        PEnty <> 'ALL'
     C                   EVAL      StmSQL1 = %TRIM(StmSQL1) +
     C                             ' AND B.A8BRCD   = '''+PEnty+'''           '
     C                   ENDIF
      *
      ** Statement: ORDER BY
      *
     C                   EVAL      StmSQL1 = %TRIM(StmSQL1) + ' ORDER BY      '+
     C                             ' B.A8BRCD                                 '
      *
     C/EXEC SQL
     C+ PREPARE STATEMENT1
     C+   FROM :StmSQL1
     C/END-EXEC
      *
     C/EXEC SQL
     C+ DECLARE RS1 CURSOR
     C+   FOR STATEMENT1
     C/END-EXEC
      *
     C/EXEC SQL
     C+  OPEN RS1
     C/END-EXEC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrExcSQL2 - Subroutine to execute SQL script for getting      *
      *             Level 2 field in the report  eport                *
      *                                                               *
      * Called by: SrPrcesLv2                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrExcSQL2     BEGSR
      *
      ** Reset SQL Statement
      *
     C                   EVAL      StmSQL2 = *BLANKS
      *
      ** Statement: SELECT
      *
     C                   EVAL      StmSQL2 = %TRIM(StmSQL2) + 'SELECT         '+
     C                             ' DISTINCT                                 '+
     C**********                   ' C.BFGROUPNAME,                           '+           AR892737C
     C**********                   ' C.BFGROUPDISPLAYNAME                     '            AR892737C
     C                             ' C.BFGROUPNAME                            '            AR892737C
      *
      ** Statement: FROM
      *
     C                   EVAL      StmSQL2 = %TRIM(StmSQL2) + ' FROM          '+
     C                             ' A,                                       '+
     C                             ' C                                        '
      *
      ** Statement: WHERE
      *
     C                   EVAL      StmSQL2 = %TRIM(StmSQL2) + ' WHERE         '+
     C                             ' A.BFENTITLEMENTTYPE = '''+WEntType+'''   '+
     C                             ' AND A.BFGROUPNAME = C.BFGROUPNAME        '
     C**********         IF        PCnsld <> '1'                                           AR892737C
     C                   IF        PCnsld = '0'                                            AR892737C
     C                   EVAL      StmSQL2 = %TRIM(StmSQL2) + ' AND           '+
     C                             ' A.BFENTITLEMENTVALUE = '''+S1_BRCD+'''   '
     C                   ELSEIF    PCnsld = '1'                                            AR892737C
     C                   EVAL      StmSQL2 = %TRIM(StmSQL2) + ' AND           '+           AR892737C
     C                             ' ( ' + %TRIM(StmBrn) + ' )                '            AR892737C
     C                   ENDIF
      *
      ** Statement: ORDER BY
      *
     C                   EVAL      StmSQL2 = %TRIM(StmSQL2) + ' ORDER BY      '+
     C                             ' C.BFGROUPNAME                            '
      *
     C/EXEC SQL
     C+ PREPARE STATEMENT2
     C+   FROM :StmSQL2
     C/END-EXEC
      *
     C/EXEC SQL
     C+ DECLARE RS2 CURSOR
     C+   FOR STATEMENT2
     C/END-EXEC
      *
     C/EXEC SQL
     C+  OPEN RS2
     C/END-EXEC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                    AR892737C
      *                                                               *                    AR892737C
      * SrExcSQL2N- Subroutine to execute SQL script for getting      *                    AR892737C
      *             Level 2 field in the report  eport                *                    AR892737C
      *                                                               *                    AR892737C
      * Called by: SrPrcesLv2                                         *                    AR892737C
      *                                                               *                    AR892737C
      * Calls: None                                                   *                    AR892737C
      *                                                               *                    AR892737C
      *****************************************************************                    AR892737C
     C     SrExcSQL2N    BEGSR                                                             AR892737C
      *                                                                                    AR892737C
      ** Reset SQL Statement                                                               AR892737C
      *                                                                                    AR892737C
     C                   EVAL      StmSQL2N = *BLANKS                                      AR892737C
      *                                                                                    AR892737C
      ** Statement: SELECT                                                                 AR892737C
      *                                                                                    AR892737C
     C                   EVAL      StmSQL2N = %TRIM(StmSQL2N) + 'SELECT       '+           AR892737C
     C                             ' C.BFGROUPDISPLAYNAME                     '            AR892737C
      *                                                                                    AR892737C
      ** Statement: FROM                                                                   AR892737C
      *                                                                                    AR892737C
     C                   EVAL      StmSQL2N = %TRIM(StmSQL2N) + ' FROM        '+           AR892737C
     C                             ' C                                        '            AR892737C
      *                                                                                    AR892737C
      ** Statement: WHERE                                                                  AR892737C
      *                                                                                    AR892737C
     C                   EVAL      StmSQL2N = %TRIM(StmSQL2N) + ' WHERE       '+           AR892737C
     C                             ' C.BFGROUPNAME  = ''' + S2_GNAM + '''     '            AR892737C
      *                                                                                    AR892737C
     C/EXEC SQL                                                                            AR892737C
     C+ PREPARE STATEMENT2N                                                                AR892737C
     C+   FROM :StmSQL2N                                                                   AR892737C
     C/END-EXEC                                                                            AR892737C
      *                                                                                    AR892737C
     C/EXEC SQL                                                                            AR892737C
     C+ DECLARE RS2N CURSOR                                                                AR892737C
     C+   FOR STATEMENT2N                                                                  AR892737C
     C/END-EXEC                                                                            AR892737C
      *                                                                                    AR892737C
     C/EXEC SQL                                                                            AR892737C
     C+  OPEN RS2N                                                                         AR892737C
     C/END-EXEC                                                                            AR892737C
      *                                                                                    AR892737C
     C                   ENDSR                                                             AR892737C
      *****************************************************************                    AR892737C
      /EJECT                                                                               AR892737C
      *****************************************************************
      *                                                               *
      * SrExcSQL3 - Subroutine to execute SQL script for getting      *
      *             Level 3 field in the report  report               *
      *                                                               *
      * Called by: SrPrcesLv3                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrExcSQL3     BEGSR
      *
      ** Reset SQL Statement
      *
     C                   EVAL      StmSQL3 = *BLANKS
      *
      ** Statement: SELECT
      *
     C                   EVAL      StmSQL3 = %TRIM(StmSQL3) + 'SELECT         '+
     C                             ' DISTINCT                                 '+
     C                             ' E.BFPERMISSIONNAME,                      '+
     C                             ' I.BFDISPLAYNAME                          '
      *
      ** Statement: FROM
      *
     C                   EVAL      StmSQL3 = %TRIM(StmSQL3) + ' FROM          '+
     C                             ' A,                                       '+
     C                             ' C,                                       '+           AR892737C
     C                             ' D,                                       '+
     C                             ' E,                                       '+
     C                             ' H,                                       '+
     C                             ' I                                        '
      *
      ** Statement: WHERE
      *
     C                   EVAL      StmSQL3 = %TRIM(StmSQL3) + ' WHERE         '+
     C                             ' A.BFENTITLEMENTTYPE = '''+ WEntType +''' '+
     C                             ' AND A.BFGROUPNAME = '''+ S2_GNAM +''' AND'+
     C**********                   ' A.BFGROUPNAME = D.BFGROUPID AND          '+           AR892737C
     C                             ' A.BFGROUPNAME = C.BFGROUPNAME AND        '+           AR892737C
     C                             ' C.BFGROUPIDPK = D.BFGROUPID AND          '+           AR892737C
     C                             ' D.BFPERMISSIONID = E.BFIDPK AND          '+
     C**********                   ' E.BFIDPK = H.BFIDPK AND                  '+            MD037908
     C                             ' E.BFIDPK = H.BFPERMISSIONID AND          '+            MD037908
     C**********                   ' H.BFRESOURCEID = I.BFARTEFACTID          '             MD042298
     C                             ' H.BFRESOURCEID = I.BFARTEFACTID          '+            MD042298
     C                             'AND I.BFDISPLAYNAME IS NOT NULL'                        MD042298
     C**********         IF        PCnsld <> '1'                                           AR892737C
     C                   IF        PCnsld = '0'                                            AR892737C
     C                   EVAL      StmSQL3 = %TRIM(StmSQL3) + ' AND           '+
     C                             ' A.BFENTITLEMENTVALUE = '''+S1_BRCD+'''   '
     C                   ELSEIF    PCnsld = '1'                                            AR892737C
     C                   EVAL      StmSQL3 = %TRIM(StmSQL3) + ' AND           '+           AR892737C
     C                             ' ( ' + %TRIM(StmBrn) + ' )                '            AR892737C
     C                   ENDIF
      *
      ** Statement: ORDER BY
      *
     C                   EVAL      StmSQL3 = %TRIM(StmSQL3) + ' ORDER BY      '+
     C                             ' E.BFPERMISSIONNAME                       '
      *
     C/EXEC SQL
     C+ PREPARE STATEMENT3
     C+   FROM :StmSQL3
     C/END-EXEC
      *
     C/EXEC SQL
     C+ DECLARE RS3 CURSOR
     C+   FOR STATEMENT3
     C/END-EXEC
      *
     C/EXEC SQL
     C+  OPEN RS3
     C/END-EXEC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrExcSQLU - Subroutine to execute SQL script for getting      *
      *             User ID for Request of the report                 *
      *                                                               *
      * Called by: SrGetUsrR                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrExcSQLU     BEGSR
      *
      ** Reset SQL Statement
      *
     C                   EVAL      StmSQLU = *BLANKS
      *
      ** Statement: SELECT
      *
     C                   EVAL      StmSQLU = %TRIM(StmSQLU) + 'SELECT         '+
     C                             ' F.D5USRR                                 '
      *
      ** Statement: FROM
      *
     C                   EVAL      StmSQLU = %TRIM(StmSQLU) + ' FROM          '+
     C                             ' F                                        '
      *
      ** Statement: WHERE
      *
     C                   EVAL      StmSQLU = %TRIM(StmSQLU) + ' WHERE         '+
     C                             ' F.D5RQSQ = '''+PSeq+'''                  '
      *
     C/EXEC SQL
     C+ PREPARE STATEMENTU
     C+   FROM :StmSQLU
     C/END-EXEC
      *
     C/EXEC SQL
     C+ DECLARE RSU CURSOR
     C+   FOR STATEMENTU
     C/END-EXEC
      *
     C/EXEC SQL
     C+  OPEN RSU
     C/END-EXEC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFtcSQL1 - Subroutine to fetch records of StmSQL1 for getting*
      *             Level 1 field in the report                       *
      *                                                               *
      * Called by: SrPrcesLv1                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRFtcSQL1     BEGSR
      *                                                                                    AR892737C
     C                   EVAL      DSRS1 = *BLANKS                                         AR892737C
      *
     C/EXEC SQL
     C+  FETCH NEXT FROM RS1 INTO :DSRS1
     C/END-EXEC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFtcSQL2 - Subroutine to fetch records of StmSQL2 for getting*
      *             Level 2 field in the report                       *
      *                                                               *
      * Called by: SrPrcesLv2                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRFtcSQL2     BEGSR
      *                                                                                    AR892737C
     C                   EVAL      DSRS2 = *BLANKS                                         AR892737C
      *
     C/EXEC SQL
     C+  FETCH NEXT FROM RS2 INTO :DSRS2
     C/END-EXEC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                    AR892737C
      *                                                               *                    AR892737C
      * SRFtcSQL2N- Subroutine to fetch records of StmSQL2N in getting*                    AR892737C
      *             Level 2 field in the report                       *                    AR892737C
      *                                                               *                    AR892737C
      * Called by: SrPrcesLv2                                         *                    AR892737C
      *                                                               *                    AR892737C
      * Calls: None                                                   *                    AR892737C
      *                                                               *                    AR892737C
      *****************************************************************                    AR892737C
     C     SRFtcSQL2N    BEGSR                                                             AR892737C
      *                                                                                    AR892737C
     C                   EVAL      DSRS2N = *BLANKS                                        AR892737C
      *                                                                                    AR892737C
     C/EXEC SQL                                                                            AR892737C
     C+  FETCH NEXT FROM RS2N INTO :DSRS2N                                                 AR892737C
     C/END-EXEC                                                                            AR892737C
      *                                                                                    AR892737C
     C                   ENDSR                                                             AR892737C
      *****************************************************************                    AR892737C
      /EJECT                                                                               AR892737C
      *****************************************************************
      *                                                               *
      * SRFtcSQL3 - Subroutine to fetch records of StmSQL3 for getting*
      *             Level 3 field in the report                       *
      *                                                               *
      * Called by: SrPrcesLv3                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRFtcSQL3     BEGSR
      *                                                                                    AR892737C
     C                   EVAL      DSRS3 = *BLANKS                                         AR892737C
      *
     C/EXEC SQL
     C+  FETCH NEXT FROM RS3 INTO :DSRS3
     C/END-EXEC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFtcSQLU - Subroutine to fetch records of StmSQLU for getting*
      *             User ID for Request of the report                 *
      *                                                               *
      * Called by: SrGetUsrR                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRFtcSQLU     BEGSR
      *
     C/EXEC SQL
     C+  FETCH NEXT FROM RSU INTO :DSRSU
     C/END-EXEC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrClsSQL1 - Subroutine to close recordset of StmSQL1          *
      *                                                               *
      * Called by: SrPrcesLv1                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrClsSQL1     BEGSR
     C
     C/EXEC SQL
     C+  CLOSE RS1
     C/END-EXEC
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrClsSQL2 - Subroutine to close recordset of StmSQL2          *
      *                                                               *
      * Called by: SrPrcesLv2                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrClsSQL2     BEGSR
     C
     C/EXEC SQL
     C+  CLOSE RS2
     C/END-EXEC
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                    AR892737C
      *                                                               *                    AR892737C
      * SrClsSQL2N- Subroutine to close recordset of StmSQL2N         *                    AR892737C
      *                                                               *                    AR892737C
      * Called by: SrPrcesLv2                                         *                    AR892737C
      *                                                               *                    AR892737C
      * Calls: None                                                   *                    AR892737C
      *                                                               *                    AR892737C
      *****************************************************************                    AR892737C
     C     SrClsSQL2N    BEGSR                                                             AR892737C
     C                                                                                     AR892737C
     C/EXEC SQL                                                                            AR892737C
     C+  CLOSE RS2N                                                                        AR892737C
     C/END-EXEC                                                                            AR892737C
     C                                                                                     AR892737C
     C                   ENDSR                                                             AR892737C
      *****************************************************************                    AR892737C
      /EJECT                                                                               AR892737C
      *****************************************************************
      *                                                               *
      * SrClsSQL3 - Subroutine to close recordset of StmSQL3          *
      *                                                               *
      * Called by: SrPrcesLv3                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrClsSQL3     BEGSR
     C
     C/EXEC SQL
     C+  CLOSE RS3
     C/END-EXEC
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrClsSQLU - Subroutine to close recordset of StmSQLU          *
      *                                                               *
      * Called by: SrGetUsrR                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrClsSQLU     BEGSR
     C
     C/EXEC SQL
     C+  CLOSE RSU
     C/END-EXEC
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBegP1 - Subroutine to open the main PRTF of the report      *
      *                                                               *
      * Called by: SrPrcesRpt                                         *
      *                                                               *
      * Calls: SrRCFP1                                                *
      *                                                               *
      *****************************************************************
     C     SrBegP1       BEGSR
      *
      ** Open and register P1 report via RCF
     C                   IF        NOT %OPEN(GP004003P1)
      *
     C                   OPEN      GP004003P1
     C                   EXSR      SrRCFP1
     C                   WRITE     HEADP1
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEndP1 - Subroutine to close the main PRTF or the report     *
      *                                                               *
      * Called by: SrPrcesRpt                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrEndP1       BEGSR
      *
      ** Close P1 and write trailer record format
      *
     C                   IF        %OPEN(GP004003P1)
      *
     C                   IF        OFLLN1 <= PRTLN1 + 3
     C                   WRITE     HEADP1
     C                   ENDIF
      *
     C                   WRITE     TRAILP1
     C                   CLOSE     GP004003P1
      *
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAudit - Subroutine to print the Audit of the report         *
      *                                                               *
      * Called by: SrBegP1                                            *
      *                                                               *
      * Calls: SrRCFAU                                                *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR
      *
      ** Open and register AU report via RCF
     C                   EXSR      SrRCFAU
     C                   WRITE     HEADAU
      *
     C                   IF        (Error <> 'Y')
     C                   IF        (WCtrRS1 = 0)
     C                             AND (WCtrRS2 = 0)
     C                             AND (WCtrRS3 = 0)
      *
      ** Write No details
     C                   WRITE     NODTLS
     C                   ELSE
      *
      ** Write File Control
     C                   EVAL      AU_CTR1 = WCtrRS1
     C                   EVAL      AU_CTR2 = WCtrRS2
     C                   EVAL      AU_CTR3 = WCtrRS3
     C                   WRITE     CONTROL
     C                   ENDIF
     C                   ELSE
      *
      ** Write Database Error
     C                   WRITE     DBERROR
     C                   IF        %OPEN(GP004003P1)
     C                   CLOSE     GP004003P1
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRCFP1 - Register the P1 Printer File via RCF                *
      *                                                               *
      * Called by: SrBegP1                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrRCFP1       BEGSR
      *
     C                   Z-ADD     SFNUM1        PZSNum
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSeq          PZSSeq
     C                   PARM      *BLANKS       PZSEnty
     C                   PARM      SFILE1        PZSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr
      *
     C                   IF        PZSERR = 'Y'
     C                   EVAL      DBASE  = 2
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   MOVE      PZSNUM        DBKEY
     C                   EVAL      Error = 'Y'
     C                   EXSR      SrAudit
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRCFAU - Register the AU Printer File via RCF                *
      *                                                               *
      * Called by: SrAudit                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrRCFAU       BEGSR
      *
     C                   Z-ADD     SFNUMU        PZSNum
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSeq          PZSSeq
     C                   PARM      *BLANKS       PZSEnty
     C                   PARM      SFILEU        PZSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr
      *
     C                   IF        PZSERR = 'Y'
     C                   EVAL      DBASE  = 3
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   MOVE      PZSNUM        DBKEY
     C                   EVAL      Error = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: SrExcSQLF, SrGetUsrR                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Program Entry Parameter
      *
     C     *ENTRY        PLIST
     C                   PARM                    PAllParm
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'GP004003'
      *
      ** Get current zone
      *
     C                   CALL      'GOGETZONE'
     C                   PARM                    I#RTCD
     C                   PARM                    I#ERMS
     C                   PARM      'Y'           I#FULLCHECK
     C                   PARM                    O#ZONE
     C                   PARM                    O#SHTC
     C                   PARM                    O#RDNB
     C                   PARM                    O#DNWD
     C                   PARM                    O#BCCY
     C                   PARM                    O#NJOB
      *
      ** Access Bank Details
      *
     C                   CALL      'GPACSZBNK'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      *BLANKS       PErms
     C                   PARM      O#ZONE        PZone
     C                   PARM      'N'           PCache
     C     GZSDBANK      PARM                    PRecImage
      *
      ** Database Error
      *
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBPGM = 'GPACSZBNK'
     C                   EVAL      DBFILE = 'GZSDBANKPD'
     C                   EVAL      DBKEY  = POption
     C                   OUT       LDA
     C                   EVAL      Error = 'Y'
     C                   EXSR      SrAudit
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Excecute SQL query F - Files Declaration
      *
     C                   EXSR      SrExcSQLF
      *
      ** Get user ID for Request
      *
     C                   EXSR      SrGetUsrR
     C                   EVAL      SU_USID = %XLATE(Lower :Upper :SU_USID)                 AR892737C
     C                   IF        SU_USID = *BLANKS
     C                   EVAL      SU_USID = JBUSR
     C                   ENDIF
      *
      ** Set consilidations indicators
      *
     C                   SETOFF                                       1011
     C                   IF        PCnsld = '0'
     C                   EVAL      *IN10 = *ON
     C                   ELSEIF    PCnsld = '1'
     C                   EVAL      *IN11 = *ON
     C                   ENDIF
      *
      ** Clear temporary DS for recordsets
      *
     C                   EVAL      DSRS1T = *BLANKS
     C                   EVAL      DSRS2T = *BLANKS
     C                   EVAL      DSRS3T = *BLANKS
      *
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
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2011
