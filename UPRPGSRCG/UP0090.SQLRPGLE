     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Create deliverables list')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP0090 - Create Deliverables List                            *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD061009             Date 23Jan23             *
      *  Prev Amend No. MD060918             Date 21Jan21             *
      *                 MD061706             Date 01Aug23             *
      *                 MD061518             Date 23Jul23             *
      *                 MD061576             Date 23Jul23             *
      *                 MD061503             Date 23Jun23             *
      *                 MD061577             Date 18Jul23             *
      *                 MD061461             Date 01Jun23             *
      *                 MD061274             Date 09May23             *
      *                 MD060877             Date 01Jan23             *
      *                 CSW101               Date 03Feb23             *
      *                 MD060964             Date 24Jan23             *
      *                 MD060352             Date 22Aug22             *
      *                 MD058188             Date 11May21             *
      *                 MD060008             Date 11May21             *
      *                 MD058830             Date 01Oct21             *
      *                 MD058081             Date 11May21             *
      *                 MD058088             Date 01Oct21             *
      *                 MD058854             Date 21Oct21             *
      *                 MD056602             Date 04Sep20             *
      *                 MD058769             Date 21Sep21             *
      *                 MD058755             Date 01Sep21             *
      *                 CSC059               Date 10Oct22             *
      *                 CUP046               Date 01Jun22             *
      *                 MD060488             Date 08Sep22             *
      *                 MD058085             Date 11May21             *
      *                 MD058069             Date 11May21             *
      *                 MD058087             Date 11May21             *
      *                 MD058089             Date 01Sep21             *
      *                 MD058079             Date 11May21             *
      *                 MD058082             Date 11May21             *
      *                 MD058068             Date 11May21             *
      *                 MD058071             Date 11May21             *
      *                 MD056808             Date 20Sep20             *
      *                 MD056891             Date 21Aug21             *
      *                 MD054346             Date 18Jul21             *
      *                 MD056555             Date 31Aug20             *
      *                 MD055891             Date 01Sep20             *
      *                 MD057707             Date 21Jan21             *
      *                 MD057599             Date 21Jan21             *
      *                 MD056612             Date 12Sep20             *
      *                 MD056557             Date 31Aug20             *
      *                 MD056565             Date 21Jan21             *
      *                 MD056810             Date 20Sep20             *
      *                 MD056806             Date 20Sep20             *
      *                 MD057598             Date 21Jan21             *
      *                 MD056888             Date 20Sep20             *
      *                 MD056816             Date 20Sep20             *
      *                 MD056812             Date 20Sep20             *
      *                 MD056752             Date 20Sep20             *
      *                 MD056751             Date 20Sep20             *
      *                 MD056633             Date 07Sep20             *
      *                 MD056613             Date 20Sep20             *
      *                 MD056611             Date 20Sep20             *
      *                 MD056567             Date 20Sep20             *
      *                 MD056560             Date 31Aug20             *
      *                 MD057943             Date 26Apr21             *
      *                 MD056811             Date 20Sep20             *
      *                 MD056564             Date 24Aug20             *
      *                 MD056807             Date 20Sep20             *
      *                 MD056605             Date 05Sep20             *
      *                 MD056609             Date 07Sep20             *
      *                 MD056781             Date 20Sep20             *
      *                 MD056889             Date 11OCt20             *
      *                 MD056890             Date 11Oct20             *
      *                 MD056887             Date 29Sep20             *
      *                 MD056556             Date 31Aug20             *
      *                 MD056559             Date 31Aug20             *
      *                 MD056608             Date 08Sep20             *
      *                 MD056558             Date 31Aug20             *
      *                 MD056606             Date 07Sep20             *
      *                 MD056610             Date 07Sep20             *
      *                 MD057035             Date 21Oct20             *
      *                 MD056694             Date 09Sep20             *
      *                 MD055682             Date 31Jul20             *
      *                 MD055681             Date 31Jul20             *
      *                 MD055242             Date 10Feb20             *
      *                 MD055265             Date 10Feb20             *
      *                 MD055264             Date 31Mar20             *
      *                 MD054955             Date 16Dec19             *
      *                 MD055081             Date 17Jan20             *
      *                 MD054605             Date 17Oct19             *
      *                 MD034724             Date 11Jun15             *
      *                 CUP042 *REWRITE    Date 04May15               *
      *                 CUP040             Date 09Aug13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CUP030             Date 04Feb05               *
      *                 CPK020             Date 27Jul04               *
      *                 CPK019             Date 02Jul04               *
      *                 CUP025             Date 08Dec03               *
      *                 CPK016             Date 12Jun03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CUP007             Date 10Apr00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CUP001 *CREATE     Date 29Dec98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061009 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD060918 - Deliverable Data Split for MITB_* tables          *
      *  MD061706 - Various changes for transition to aDBU            *
      *  MD061518 - Deliverable Data Split for ZZGBLANG and ZZGBXXLANG*
      *  MD061576 - Deliverable Data Split for T_GRMENU*              *
      *  MD061503 - Deliverable Data Split for Replication _R files   *
      *  MD061577 - Deliverable Data Split for UPDDSFPD               *
      *  MD061461 - Include BTD and XTD update                        *
      *  MD061274 - Deliverable Data Split for SDARRTTD               *
      *  MD060877 - Deliverable Data Split for SMRLSLPD and SMBFPRTD  *
      *  CSW101 - PAYplus Interface.                                  *
      *  MD060964 - Program does not compile                          *
      *  MD060352 - Deliverable Data Split for GP/SCRELCTD            *
      *  MD058188 - Deliverable Data Split for Global files           *
      *  MD060008 - Deliverable Data Split for Standing Data 2        *
      *  MD058830 - Deliverable Data Split for SDNWRKPD               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD058088 - Deliverable Data Split for global tables          *
      *  MD058854 - Deliverable Data Split for TABLEV4                *
      *  MD056602 - Deliverable Data Split for T_APICFG               *
      *  MD058769 - Deliverable Data Split for SDNARRPD and TABLETP   *
      *  MD058755 - Deliverable Data Split for SDRETRPD and TABLETZ   *
      *  CSC059 - Replace QDLS processing by IFS                      *
      *  CUP046 - One Touch Bridge - migration                        *
      *  MD060488 - Deliverable Data Split for UTMENUPD               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD058069 - Deliverable Data Split for Correspondence Mgr 2   *
      *  MD058087 - Deliverable Data Split for System Control         *
      *  MD058089 - Deliverable Data Split for SM and UP              *
      *  MD058079 - Deliverable Data Split for sundry files           *
      *  MD058082 - Deliverable Data Split for FRS                    *
      *  MD058068 - Deliverable Data Split for Bank of England        *
      *  MD058071 - Deliverable Data Split for Export Data            *
      *  MD056808 - Deliverable Data Split for SDEXMAPD               *
      *  MD056891 - Deliverable Data Split for T_WIPACT               *
      *  MD054346 - Switchable Features Password Encryption           *
      *  MD056555 - Deliverable Data Split for SAR group              *
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD057707 - Deliverable Data Split for SDOREFPD               *
      *  MD057599 - Deliverable Data Split for Bridge and Util files  *
      *  MD056612 - Deliverable Data Split for MX group               *
      *  MD056557 - Deliverable Data Split for Pulldown               *
      *  MD056565 - Deliverable Data Split for APDFFLDPD              *
      *  MD056810 - Deliverable Data Split for SDFCTYPD               *
      *  MD056806 - Deliverable Data Split for SDCCTYPD               *
      *  MD057598 - Deliverable Data Split for Replication            *
      *  MD056888 - Deliverable Data Split for SDCODEPD               *
      *  MD056816 - Deliverable Data Split for SDTRDHPD/SDTRDFPD      *
      *  MD056812 - Deliverable Data Split for SDSCODPD               *
      *  MD056752 - Deliverable Data Split for MEINFMPD               *
      *  MD056751 - Deliverable Data Split for GLFXMLPD and GLGXMLPD  *
      *  MD056633 - Deliverable Data Split for SDFACCTD (re-work)     *
      *  MD056613 - Deliverable Data Split for CSD101                 *
      *  MD056611 - Deliverable Data Split for Audit Reporting        *
      *  MD056567 - Deliverable Data Split for Validation Lists       *
      *  MD056560 - Deliverable Data Split for SDMTAGPD               *
      *  MD057943 - Program cannot set the layer for newly            *
      *             introduced files. Set the layer depending on      *
      *             source file.                                      *
      *  MD056811 - Deliverable Data Split for SDRPCKTD and SDRPDFTD  *
      *  MD056564 - Deliverable Data Split for No Display field cond  *
      *  MD056807 - Deliverable Data Split for Compliance Watch       *
      *  MD056605 - Deliverable Data Split for APDTAKPD/APUDTKPD      *
      *  MD056609 - Deliverable Data Split for APMNEXPD               *
      *  MD056781 - Deliverable Data Split for MESWACPD               *
      *  MD056889 - Deliverable Data Split for SDJARFPD               *
      *  MD056890 - Deliverable Data Split for SDMREFPD               *
      *  MD056887 - Deliverable Data Split for SCNJRNPD               *
      *  MD056556 - Deliverable Data Split for GPGLOBFPD              *
      *  MD056559 - Deliverable Data Split for SCSQLSPD               *
      *  MD056608 - Deliverable Data Split for APFUNCPD               *
      *  MD056558 - Deliverable Data Split for GODTACPD               *
      *  MD056606 - Deliverable Data Split for APDBINFPD              *
      *  MD056610 - Deliverable Data Split for APPGMSTD               *
      *  MD057035 - Allow delivery of XTD                             *
      *  MD056694 - New deliverable data file UPDDSFPD.               *
      *  MD055682 - Deliverable Data Split for TRIG                   *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD055242 - Standardization of Deliverable Data Split         *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD055264 - Deliverable Data Split for Help Text              *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD055081 - New files added for Deliverable Data Split do     *
      *             not exist yet, hence layer cannot be found.       *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD034724 - Addition for UDF tables.                          *
      *  CUP042 - Simplify update of driving file.                    *
      *  CUP040 - Handle new convention for files to be deleted.  As  *
      *           the objects are moved no prioritisation is needed.  *
      *  CUP030 - Handle REDUNDANT and RENAMED items.                 *
      *  CPK020 - Handle deliverable data.                            *
      *  CPK019 - Field reference file names have changed.            *
      *  CUP025 - MidasPlus Bridge changes.                           *
      *  CPK016 - Release 5 packaging.  Special handling for field    *
      *           reference files.                                    *
      *  CUP007 - Changes to correct handling of ILE objects.         *
      *         - Remove default of values for fields not used.       *
      *  CUP001 - Introduction of BRIDGE                              *
      *                                                               *
      *****************************************************************
      *
     D Source          S             10
     D DlvDtaLib       S             10
      *
     D Member          S             10
     D MemberType      S             10
     D SourceFile      S             10
     D ObjectType      S             10
     D ObjectAtr       S             10
     D ObjType         S              8
     D Char100         S            100
     D Command         S             60
     D CommandLen      S             15  5 INZ(60)
     D FoundPos        S              3  0
     D ReturnCode      S              1
     D ReturnData      S            180
     D ObjectText      S             50
     D Library         S             10
     D ChkFile         S             10
     D PrevFile        S             10
     D ActionFile      S              1
     D NoWrite         S              1
     D Count           S              3  0
     D RptAction       S              7    INZ('*REPORT')
     D RptPgm          S             10    INZ('UP0090')
     D x_SRCPF         S              1                                                     MD057943
      *
     D UPDLVC        E DS                  EXTNAME(UPDLVCPD)
     C     *ENTRY        PLIST
     C                   PARM                    Source
     C                   PARM                    DlvDtaLib
     C                   PARM                    ReturnCode
      *
     C                   IF        Source <> '*NONE'
      ** Insert data from member list.
     C                   EXSR      MemberData
      ** Update any records for UDF tables.                                                 MD034724
     C                   EXSR      UpdateUDF                                                MD034724
      ** Update the layer; zone has been defaulted so only update *GLOBAL.
     C                   EXSR      UpdateLayer
      ** Update object type where it can not be defaulted.
     C                   EXSR      UpdateObjType
      ** Update known exceptions.
     C                   EXSR      UpdateExcept
      ** Update priorities for shared formats.
     C                   EXSR      UpdShareFmt
      ** Update priorities for non-database items.
     C                   EXSR      UpdNonDBPty
      ** Add text if blank.
     C                   EXSR      AddText
      ** Check if any dependent logicals / views have not been delivered.
     C                   EXSR      ChkDBRel
      ** Check if any files with shared formats have not been delivered.
     C                   EXSR      ChkShareFmt
      ** Tidy up the error message file by removing duplicates.
     C                   EXSR      UpdateErrMsg
     C                   ENDIF
      *
      ** Update deliverables list for deliverable data.
     C                   IF        DlvDtaLib <> '*NONE'
     C                   EXSR      DlvData
      ** Add text if blank.
     C                   EXSR      AddText
     C                   ENDIF
      *
      ** If a problem was found then report.
     C/exec SQL
     C+ select count(*) into :Count
     C+ from QTEMP/UPERRMQT
     C/end-exec
     C                   IF        Count > 0
     C                   EVAL      ReturnCode = 'W'
     C                   CALL      'UP008010'
     C                   PARM                    RptAction
     C                   PARM                    RptPgm
     C                   PARM      *blanks       Char100
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *********************************************************************
      *                                                                   *
      *    MemberData - Insert data about source file members.            *
      *                                                                   *
      *********************************************************************
     C     MemberData    BEGSR
      *
     C/exec SQL
     C+ insert into UPDLVCPD
     C+ (
     C+   AUMBNM
     C+ , AUMBTP
     C+ , AUMBTX
     C+ , AUCAPR
     C+ , AUIPTY
     C+ , AUDTYP
     C+ , AUCPYO
     C+ , AUFMTO
     C+ , AUSRCF
     C+ , AUDTLB
     C+ , AUPROJ
     C+ , AUEXIN
     C+ , AUUSTS
     C+ )
     C+ select
     C+   MBNAME
     C+ , MBSEU2
     C+ , MBMTXT
     C+ , ' '
     C+ , 9
     C+ , 'O'
     C+ , ' '
     C+ , ' '
     C+ , MBFILE
     C+ , '*ZONE'
     C+ , '*' concat substr(MBSEU2, 1 , 9)
     C+ , ' '
     C+ , ' '
     C+
     C+ from UPC0090FD
     C+ where
     C+     MBDTAT = 'S'
     C+ and MBNAME <> ' '
     C/end-exec
      *
     C     MemberDataE   ENDSR
      *
      *
      *********************************************************************                 MD034724
      *                                                                   *                 MD034724
      *    UpdateUDF - Update any records for UDF tables.                 *                 MD034724
      *                                                                   *                 MD034724
      *********************************************************************                 MD034724
     C     UpdateUDF     BEGSR                                                              MD034724
      *
      * Check first is file still exists (not DDS converted)                                MD058089
     C                   CALL      'UTCHKOBJ'                                               MD058089
     C                   PARM      *blanks       ExistYN          10                        MD058089
     C                   PARM      'SMGNMGPD'    DFPGM            10                        MD058089
     C                   PARM      '*LIBL'       Library                                    MD058089
     C                   PARM      '*FILE'       ObjectType                                 MD058089
     C                   PARM      *blanks       Member                                     MD058089
     C                   IF        ExistYN = 'Exist'                                        MD058089
     C/exec SQL                                                                             MD034724
     C+ update UPDLVCPD u set                                                               MD034724
     C+   AUFMTO = 'S*NOCOPY'                                                               MD034724
     C+ where exists                                                                        MD034724
     C+ (                                                                                   MD034724
     C+ select * from SMGNMGPD s                                                            MD034724
     C+ where                                                                               MD034724
     C+     u.AUMBNM = s.NCOBJ                                                              MD034724
     C+ )                                                                                   MD034724
     C/end-exec                                                                             MD034724
     C                   ELSE                                                               MD058089
     C/exec SQL                                                                             MD058089
     C+ update UPDLVCPD u set                                                               MD058089
     C+   AUFMTO = 'S*NOCOPY'                                                               MD058089
     C+ where exists                                                                        MD058089
     C+ (                                                                                   MD058089
     C+ select * from SMGNMJW0 s                                                            MD058089
     C+ where                                                                               MD058089
     C+     u.AUMBNM = s.NCOBJ                                                              MD058089
     C+ )                                                                                   MD058089
     C/end-exec                                                                             MD058089
     C                   ENDIF                                                              MD058089
      *
     C     UpdateUDFE    ENDSR                                                              MD034724
      *
      *********************************************************************
      *                                                                   *
      *    UpdateLayer - Update layer to *GLOBAL where appropriate.       *
      *                                                                   *
      *********************************************************************
     C     UpdateLayer   BEGSR
      *
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUDTLB = '*GLOBAL'
     C+ where
     C+    substr(AUSRCF, 9, 1) = 'G'
     C/end-exec
      *
     C     UpdateLayerE  ENDSR
      *
      *********************************************************************
      *                                                                   *
      *    UpdateObjType - Update object type where it can not be         *
      *                    defaulted.                                     *
      *                                                                   *
      *********************************************************************
     C     UpdateObjType BEGSR
      *
      ** First save any member types with a prefix of 'X' and change the
      **  member type to a normal member type.  Special processing for
      **  SQLDTAARA.
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUEXIN = AUMBTP
     C+ where
     C+     substr(AUMBTP, 1, 1) = 'X'
     C/end-exec
      *
     C/exec SQL
     C+ update UPDLVCPD set
     C+   AUPROJ = '*' concat substr(AUMBTP, 3, 8)
     C+ where
     C+   substr(AUMBTP, 1, 1) = 'X'
     C/end-exec
      *
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUMBTP = substr(AUEXIN, 3, 8)
     C+ where
     C+     substr(AUEXIN, 1, 1) = 'X'
     C/end-exec
      *
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUMBTP = 'SQLDTAARA'
     C+ where
     C+     AUMBTP = 'SQLDTAAR'
     C/end-exec
      *
      ** Change any type of file to '*FILE'.
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUPROJ = '*FILE'
     C+ where
     C+     AUMBTP in
     C+ (
     C+   'DSPF'
     C+ , 'PRTF'
     C+ , 'PF'
     C+ , 'LF'
     C+ , 'SQLTBL'
     C+ , 'SQLVIEW'
     C+ , 'ICFF'
     C+ , 'TAPF'
     C+ )
     C/end-exec
      *
      ** If OPM type, ILE PGM or SQL procedure then change to '*PGM'.
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUPROJ = '*PGM'
     C+ where
     C+     AUMBTP in
     C+ (
     C+   'CLP'
     C+ , 'RPG'
     C+ , 'SQLRPG'
     C+ , 'SQLPROC'
     C+ )
     C/end-exec
      *
      ** Handle SQL sequences.
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUPROJ = '*DTAARA'
     C+ where
     C+     AUMBTP = 'SQLDTAARA'
     C/end-exec
      *
      ** If non-compilable then set to '*SRC'.
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUPROJ = '*SRC'
     C+ where
     C+     substr(AUSRCF, 1, 8) = 'QWINDSRC'
     C+ or  substr(AUSRCF, 1, 6) = 'ZSRSRC'
     C+ or  substr(AUSRCF, 3, 3) = 'CPY'
     C+ or  substr(AUSRCF, 1, 2) = 'SK'
     C+ or  substr(AUSRCF, 1, 3) = 'STD'
     C+ or  AUSRCF = 'H'
     C/end-exec
      *
      ** Where the member type is '*LE' then it is not know whether the object
      **  type is '*PGM' or '*MODULE'.  Use UT000025 (from CRTOBJ) to check.
     C                   EXSR      FindObjType
      *
      ** Finally set the member types back if they were originally 'X' prefixed.
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUMBTP = substr(AUEXIN, 1, 10)
     C+ , AUEXIN = ' '
     C+ where
     C+     substr(AUEXIN, 1, 1) = 'X'
     C/end-exec
     C     UpdateOBjTypeEENDSR
      *
      *********************************************************************
      *                                                                   *
      *    UpdateExcept - Handle known exceptions.                        *
      *                                                                   *
      *********************************************************************
     C     UpdateExcept  BEGSR
      *
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUDTYP = 'I'
     C+ where AUMBNM in
     C+ (
     C+   'MFRFL'
     C+ , 'GPFRFCPD'
     C+ , 'GPFRFRPD'
     C+ , 'GPFRFXPD'
     C+ , 'GPFRF0PD'
     C+ , 'GPFRF1PD'
     C+ , 'GPFRF2PD'
     C+ , 'GPFRF3PD'
     C+ , 'GPFRF4PD'
     C+ , 'GPFRF5PD'
     C+ , 'GPFRF6PD'
     C+ )
     C/end-exec
      *
     C     UpdateExceptE ENDSR
      *
      *********************************************************************
      *                                                                   *
      *    UpdShareFmt - Update priorities for shared formats.            *
      *                                                                   *
      *********************************************************************
     C     UpdShareFmt   BEGSR
      *
     C/exec SQL
     C+ update UPDLVCPD a
     C+ set
     C+   a.AUIPTY =
     C+ (
     C+ select
     C+   b.FSIPTY
     C+ from UPFMTJW0 b
     C+ where
     C+   a.AUMBNM = b.FSFSHD
     C+ fetch first 1 row only
     C+ )
     C+ where
     C+   a.AUMBNM in
     C+ (
     C+ select
     C+   b.FSFSHD
     C+ from UPFMTJW0 b
     C+ )
     C/end-exec
      *
     C     UpdShareFmtE  ENDSR
      *
      *********************************************************************
      *                                                                   *
      *    UpdateObjType - Update priorities for non-database items so    *
      *                    they can be created in correct order.          *
      *                                                                   *
      *********************************************************************
     C     UpdNonDBPty   BEGSR
      *
      ** Update priorities based on member types.
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUIPTY = 0
     C+ where
     C+     AUMBTP in
     C+ (
     C+   'DSPF'
     C+ , 'PRTF'
     C+ , 'ICFF'
     C+ , 'TAPF'
     C+ )
     C/end-exec
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUIPTY = 1
     C+ where
     C+     AUMBTP in
     C+ (
     C+   'CMD'
     C+ , 'PNLGRP'
     C+ )
     C/end-exec
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUIPTY = 2
     C+ where
     C+     AUMBTP in
     C+ (
     C+   'CLP'
     C+ , 'RPG'
     C+ , 'CLLE'
     C+ , 'RPGLE'
     C+ , 'SQLRPG'
     C+ , 'SQLRPGLE'
     C+ , 'CLE'
     C+ )
     C/end-exec
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUIPTY = 3
     C+ where
     C+     AUMBTP in
     C+ (
     C+   'SRVPGM'
     C+ )
     C/end-exec
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUIPTY = 4
     C+ where
     C+     AUMBTP in
     C+ (
     C+   'PGM'
     C+ )
     C/end-exec
      *
     C     UpdNonDBPtyE  ENDSR
      *********************************************************************
      *                                                                   *
      *    AddText - Attempt to add text if blank.                        *
      *                                                                   *
      *********************************************************************
     C     AddText       BEGSR
      *
      ** Read through records where description is blank.
     C/exec SQL
     C+ declare AddTextC cursor for
     C+ select
     C+   AUMBNM
     C+ , AUPROJ
     C+ from UPDLVCPD
     C+ where
     C+     AUMBTX = ' '
     C/end-exec
      *
     C/exec SQL
     C+ open AddTextC
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from AddTextC
     C+ into
     C+   :Member
     C+ , :ObjectType
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      ** Retrieve object description to get text.
     C                   CALL      'UTRTVOBJD'
     C                   PARM                    Member
     C                   PARM      '*LIBL'       Library
     C                   PARM                    ObjectType
     C                   PARM                    ReturnCode
     C                   PARM                    ReturnData
     C                   IF        ReturnCode = *blank
     C                   EVAL      ObjectText = %SUBST(ReturnData:101:50)
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUMBTX = :ObjectText
     C+ where current of AddTextC
     C/end-exec
     C                   ENDIF
      *
      *
     C/exec SQL
     C+ fetch next
     C+ from AddTextC
     C+ into
     C+   :Member
     C+ , :ObjectType
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close AddTextC
     C/end-exec
      *
     C     AddTextE      ENDSR
      *
      *********************************************************************
      *                                                                   *
      *    ChkDBRel - Check for any dependent logicals or views that have *
      *               not been delivered.                                 *
      *                                                                   *
      *********************************************************************
     C     ChkDBRel      BEGSR
      *
      ** Call program to build file UPC0093DB (database relations).
     C                   CALL      'UPC0093'
      *
      ** Build list of missing dependent files (from database relations).
     C/exec SQL
     C+ insert into QTEMP/UPERRXQT
     C+ select
     C+   WHREFI
     C+ from UPC0093DB a
     C+ inner join UPDLVCPD b on
     C+     a.WHRFI  = b.AUMBNM
     C+ where not exists
     C+ (
     C+ select *
     C+ from UPDLVCPD c
     C+ where
     C+     a.WHREFI = c.AUMBNM
     C+ or  a.WHREFI = ' '
     C+ )
     C/end-exec
      *
      ** Update error message to make it easier to identify.
     C/exec SQL
     C+ update QTEMP/UPERRXQT
     C+ set
     C+   UPERRXQT = 'Missing dependent file (logical/view)                  : '
     C+              concat substr(UPERRXQT, 1, 10)
     C/end-exec
      *
     C     ChkDBRelE     ENDSR
      *
      *********************************************************************
      *                                                                   *
      *    ChkShareFmt - Check if any shared format files have not been   *
      *                  delivered.                                       *
      *                                                                   *
      *********************************************************************
     C     ChkShareFmt   BEGSR
      *
      ** Build list of missing dependent files (from shared formats file).
     C/exec SQL
     C+ insert into QTEMP/UPERRXQT
     C+ select
     C+   FSFILE
     C+ from UPFMTJW0 a
     C+ inner join UPDLVCPD b on
     C+     a.FSFSHD = b.AUMBNM
     C+ where not exists
     C+ (
     C+ select *
     C+ from UPDLVCPD c
     C+ where
     C+     a.FSFILE = c.AUMBNM
     C+ )
     C/end-exec
      *
      ** Update error message to make it easier to identify.
     C/exec SQL
     C+ update QTEMP/UPERRXQT
     C+ set
     C+   UPERRXQT = 'Missing dependent file (format)                        : '
     C+              concat substr(UPERRXQT, 1, 10)
     C+ where
     C+     substr(UPERRXQT, 1, 7) <> 'Missing'
     C/end-exec
      *
     C     ChkShareFmtE  ENDSR
      *
      *********************************************************************
      *                                                                   *
      *    DlvData - Update deliverables list for deliverable data        *
      *                                                                   *
      *********************************************************************
     C     DlvData       BEGSR
      *
      ** Some fields for deliverable data will always have the same value.
     C                   EVAL      AUCAPR = *blank
     C                   EVAL      AUIPTY = 9
     C                   EVAL      AUFMTO = *blank
     C                   EVAL      AUSRCF = *blank
     C                   EVAL      AUEXIN = *blank
     C                   EVAL      AUUSTS = *blank
      *
     C/exec SQL
     C+ declare DlvDtaC cursor for
     C+ select
     C+   ODOBNM
     C+ , ODOBTP
     C+ , ODOBAT
     C+ , ODOBTX
     C+ from UPC0090OD
     C/end-exec
      *
     C/exec SQL
     C+ open DlvDtaC
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from DlvDtaC
     C+ into
     C+   :Member
     C+ , :ObjType
     C+ , :ObjectAtr
     C+ , :ObjectText
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      ** Check object is of correct type.
     C                   IF        ObjType <> '*MSGF'
     C                             and ObjType <> '*FILE'
     C                             or ObjType = '*FILE'
     C                             and ObjectAtr <> 'PF'
     C                   EVAL      Char100 = 'Deliverable data - +
     C                             Wrong type                              : ' +
     C                             Member + ObjType + ObjectAtr
     C                   EXSR      InsertErrMsg
     C                   GOTO      FetchNext
     C                   ENDIF
      *
      ** If it is a message file then update deliverables list.
     C                   IF        ObjType = '*MSGF'
     C                   EVAL      AUMBNM = Member
     C                   EVAL      AUMBTP = 'MSGF'
     C                   EVAL      AUPROJ = '*MSGF'
     C                   EVAL      AUMBTX = ObjectText
     C                   EVAL      AUDTYP = 'O'
     C                   EVAL      AUCPYO = *blank
     C                   EXSR      FindLayer
     C                   EXSR      InsertDlvList
     C                   ENDIF
      *
      ** If it is a file then there are several possibilities:
      **  1. The file is UPAFCPPD and this must be broken down by the data
      **     on the file.
      **  2. It is using Deliverable Data split.
      **  3. It is an Extract File (including '_X' versions).
      **  4. T_GREMNUL is still delivered as an old type of Action File.
     C                   IF        ObjType = '*FILE'
     C                   EVAL      AUMBNM = Member
     C                   EVAL      AUMBTP = 'DATA'
     C                   EVAL      AUPROJ = '*FILE'
     C                   EVAL      AUCPYO = *blank
     C                   SELECT
     C                   WHEN      AUMBNM = 'UPAFCPPD'
     C                   EXSR      ProcUPAFCP
      *
     C                   WHEN      AUMBNM = 'UPGMULPD'
     C                   EXSR      ProcUPGMUL
     C                   EXSR      InsertDlvList
      *
     C                   OTHER
     C                   EXSR      ProcOther
     C                   IF        NoWrite <> 'N'
     C                   EXSR      FindLayer
     C                   EXSR      InsertDlvList
     C                   ELSE
     C                   EVAL      NoWrite = *blank
     C                   ENDIF
     C
     C                   ENDSL
     C                   ENDIF
      *
     C     FetchNext     TAG
      *
     C/exec SQL
     C+ fetch next
     C+ from DlvDtaC
     C+ into
     C+   :Member
     C+ , :ObjType
     C+ , :ObjectAtr
     C+ , :ObjectText
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close DlvDtaC
     C/end-exec
      *
     C     DlvDataE      ENDSR
      *
      *********************************************************************
      *                                                                   *
      *    FindObjType - Find object type for ILE members.                *
      *                                                                   *
      *********************************************************************
     C     FindObjType   BEGSR
      *
      ** Read through member types *LE and attempt to find object type.
     C/exec SQL
     C+ declare ObjType cursor for
     C+ select
     C+   AUMBNM
     C+ , AUSRCF
     C+ , AUMBTP
     C+ from UPDLVCPD
     C+ where
     C+     AUMBTP = 'CLLE'
     C+ or  AUMBTP = 'RPGLE'
     C+ or  AUMBTP = 'CLE'
     C+ or  AUMBTP = 'SQLRPGLE'
     C/end-exec
      *
     C/exec SQL
     C+ open ObjType
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from ObjType
     C+ into
     C+   :Member
     C+ , :SourceFile
     C+ , :MemberType
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      ** Override for the call to required member and pick out standard
      **  creation parameter.
     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'OVRDBF FILE(INPSRC) TOFILE(' +
     C                             %TRIMR(SourceFile) + ') MBR(' +
     C                             %TRIMR(Member) + ')'
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C/exec SQL
     C+ select
     C+   SRCDTA
     C+ into
     C+   :Char100
     C+ from INPSRC
     C+ where
     C+   substr(SRCDTA, 1, 5) = '/*STD'
     C/end-exec
     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'DLTOVR FILE(INPSRC)'
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      *
     C                   EVAL      FoundPos = %SCAN('MOD':Char100)
     C                   IF        FoundPos > 0
     C                   EVAL      ObjectType = '*MODULE'
     C                   ELSE
     C                   EVAL      ObjectType = '*PGM'
     C                   ENDIF
      *
      ** Update the object type retrieved.
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUPROJ = :ObjectType
     C+ where current of ObjType
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from ObjType
     C+ into
     C+   :Member
     C+ , :SourceFile
     C+ , :MemberType
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close ObjType
     C/end-exec
      *
     C     FindObjTypeE  ENDSR
      *
      *********************************************************************
      *                                                                   *
      *    ProcUPAFCP - Process Action Files delivered on UPAFCPPD.       *
      *                                                                   *
      *********************************************************************
     C     ProcUPAFCP    BEGSR
      *
      ** Read through UPAFCPPD to handle individual files.
     C/exec SQL
     C+ declare UPAFCP cursor for
     C+ select distinct
     C+   ATFILE
     C+ from UPAFCPPD
     C+ order by
     C+     ATFILE
     C/end-exec
      *
     C/exec SQL
     C+ open UPAFCP
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from UPAFCP
     C+ into
     C+   :Member
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
     C                   EVAL      AUMBNM = Member
     C                   EVAL      AUMBTP = 'DATA'
     C                   EVAL      AUDTYP = 'I'
      ** Find layer (*GLOBAL or *ZONE).
     C                   EXSR      FindLayer
      ** Check if file does have an Action File.
     C                   EVAL      ChkFile = Member
     C                   EXSR      CheckActF
     C                   IF        ActionFile = 'N'
      ** Write record.
     C                   EVAL      Char100 = 'Deliverable data - +
     C                             Should not be Action File               : ' +
     C                             Member
     C                   EXSR      InsertErrMsg
     C                   ENDIF
     C                   EXSR      InsertDlvList
      *
     C/exec SQL
     C+ fetch next
     C+ from UPAFCP
     C+ into
     C+   :Member
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close UPAFCP
     C/end-exec
      *
     C     ProcUPAFCPE   ENDSR
      *
      *********************************************************************
      *                                                                   *
      *    ProcUPGMUL - Specific processing for T_GRMENUGL.               *
      *                                                                   *
      *********************************************************************
     C     ProcUPGMUL    BEGSR
      *
     C                   EVAL      AUMBNM = 'T_GRMENUL'
     C                   EVAL      AUMBTX = ObjectText
     C                   EVAL      AUDTYP = 'I'
     C                   EVAL      AUDTLB = '*GLOBAL'
      *
     C     ProcUPGMULE   ENDSR
      *
      *********************************************************************
      *                                                                   *
      *    ProcOther - Processing for any other delivered data files.     *
      *                                                                   *
      *********************************************************************
     C     ProcOther     BEGSR
      *
      ** Check if file is not '*XTD'                                               MD055242 MD057035
     C**********         If        %SUBST(Member:6:3) = 'XTD'                      MD055242 MD057035
     C**********         EVAL      Char100 = '*XTD file cannot be +                MD055242 MD057035
     C**********                   delivered, *CTD file must be delivered  : ' +   MD055242 MD057035
     C**********                   Member                                          MD055242 MD057035
     C**********         EXSR      InsertErrMsg                                    MD055242 MD057035
     C**********         EVAL      NoWrite = 'N'                                   MD055242 MD057035
     C**********         LEAVESR                                                   MD055242 MD057035
     C**********         Endif                                                     MD055242 MD057035
                                                                                   MD055242 MD057035
     C                   If        %SUBST(Member:6:3) =  'CTD'                              MD057035
     C                             or %SUBST(Member:6:3) =  'BTD'                           MD061461
      ** Check if the file has an '*XTD' equivalent; this means it is using
      **  the new Deliverable Data Split.
     C                   EVAL      ChkFile = %SUBST(Member:1:5) + 'XTD'
     C                   CALL      'UTRTVOBJD'
     C                   PARM                    ChkFile
     C                   PARM      '*LIBL'       Library
     C                   PARM      '*FILE'       ObjectType
     C                   PARM                    ReturnCode
     C                   PARM                    ReturnData
     C                   IF        ReturnCode = *blank
     C                             or ChkFile = 'GPWIPXTD'                                  MD054605
     C                             or ChkFile = 'GPSVLXTD'                                  MD054605
     C                             or ChkFile = 'GPSVRXTD'                                  MD054605
     C                             or ChkFile = 'SDSVLXTD'                                  MD054605
     C                             or ChkFile = 'SDSVRXTD'                                  MD054605
     C                             or ChkFile = 'CGCSHXTD'                                  MD054955
     C                             or ChkFile = 'CGGSAXTD'                                  MD054955
     C                             or ChkFile = 'CGPTNXTD'                                  MD054955
     C                             or ChkFile = 'CGPTYXTD'                                  MD054955
     C                             or ChkFile = 'CGRASXTD'                                  MD054955
     C                             or ChkFile = 'CGRDEXTD'                                  MD054955
     C                             or ChkFile = 'CGRDTXTD'                                  MD054955
     C                             or ChkFile = 'CGSETXTD'                                  MD054955
     C                             or ChkFile = 'SCHLPXTD'                                  MD055264
     C                             or ChkFile = 'FCRCOXTD'                                  MD055265
     C                             or ChkFile = 'FCREPXTD'                                  MD055265
     C                             or ChkFile = 'FCRSFXTD'                                  MD055265
     C                             or ChkFile = 'GPSRDXTD'                                  MD055681
     C                             or ChkFile = 'GPSRSXTD'                                  MD055681
     C                             or ChkFile = 'SCSRDXTD'                                  MD055681
     C                             or ChkFile = 'SCSRSXTD'                                  MD055681
     C                             or ChkFile = 'GPTRGXTD'                                  MD055682
     C                             or ChkFile = 'GPSRTXTD'                                  MD055682
     C                             or ChkFile = 'SCTRGXTD'                                  MD055682
     C                             or ChkFile = 'SCSRTXTD'                                  MD055682
     C                             or ChkFile = 'APPGSXTD'                                  MD056610
     C                             or ChkFile = 'APDBIXTD'                                  MD056606
     C                             or ChkFile = 'GODTCXTD'                                  MD056558
     C                             or ChkFile = 'APFUNXTD'                                  MD056608
     C                             or ChkFile = 'SCSQLXTD'                                  MD056559
     C                             or ChkFile = 'GPGLFXTD'                                  MD056556
     C                             or ChkFile = 'SCNJRXTD'                                  MD056887
     C                             or ChkFile = 'SDMRFXTD'                                  MD056890
     C                             or ChkFile = 'SDJARXTD'                                  MD056889
     C                             or ChkFile = 'GPJARXTD'                                  MD056889
     C                             or ChkFile = 'MESWAXTD'                                  MD056781
     C                             or ChkFile = 'APMNXXTD'                                  MD056609
     C                             or ChkFile = 'APDTKXTD'                                  MD056605
     C                             or ChkFile = 'APUDKXTD'                                  MD056605
     C                             or ChkFile = 'SDCWFXTD'                                  MD056807
     C                             or ChkFile = 'SDCWMXTD'                                  MD056807
     C                             or ChkFile = 'APNDCXTD'                                  MD056564
     C                             or ChkFile = 'GPNDCXTD'                                  MD056564
     C                             or ChkFile = 'SDRPCXTD'                                  MD056811
     C                             or ChkFile = 'SDRPDXTD'                                  MD056811
     C                             or ChkFile = 'SDMTGXTD'                                  MD056560
     C                             or ChkFile = 'CBVLLXTD'                                  MD056567
     C                             or ChkFile = 'FCVLLXTD'                                  MD056567
     C                             or ChkFile = 'MIVLLXTD'                                  MD056567
     C                             or ChkFile = 'Y2VLLXTD'                                  MD056567
     C                             or ChkFile = 'GPAUAXTD'                                  MD056611
     C                             or ChkFile = 'GPAUDXTD'                                  MD056611
     C                             or ChkFile = 'GPAUFXTD'                                  MD056611
     C                             or ChkFile = 'GPAUIXTD'                                  MD056611
     C                             or ChkFile = 'GPAURXTD'                                  MD056611
     C                             or ChkFile = 'SDINFXTD'                                  MD056613
     C                             or ChkFile = 'SDINPXTD'                                  MD056613
     C                             or ChkFile = 'SDIPVXTD'                                  MD056613
     C                             or ChkFile = 'SDFUCXTD'                                  MD056633
     C                             or ChkFile = 'GLFXMXTD'                                  MD056751
     C                             or ChkFile = 'GLGXMXTD'                                  MD056751
     C                             or ChkFile = 'MEINFXTD'                                  MD056752
     C                             or ChkFile = 'SDSCOXTD'                                  MD056812
     C                             or ChkFile = 'SDTRFXTD'                                  MD056816
     C                             or ChkFile = 'SDTRHXTD'                                  MD056816
     C                             or ChkFile = 'SDCODXTD'                                  MD056888
     C                             or ChkFile = 'RPCOBXTD'                                  MD057598
     C                             or ChkFile = 'RPMNUXTD'                                  MD057598
     C                             or ChkFile = 'RPSDTXTD'                                  MD057598
     C                             or ChkFile = 'RPSYRXTD'                                  MD057598
     C                             or ChkFile = 'RPTPTXTD'                                  MD057598
     C                             or ChkFile = 'RPTRQXTD'                                  MD057598
     C                             or ChkFile = 'SDCTYXTD'                                  MD056806
     C                             or ChkFile = 'SDFTYXTD'                                  MD056810
     C                             or ChkFile = 'APDFLXTD'                                  MD056565
     C                             or ChkFile = 'GPDFLXTD'                                  MD056565
     C                             or ChkFile = 'GPPWHXTD'                                  MD056557
     C                             or ChkFile = 'GPPWNXTD'                                  MD056557
     C                             or ChkFile = 'SDPWHXTD'                                  MD056557
     C                             or ChkFile = 'SDPWNXTD'                                  MD056557
     C                             or ChkFile = 'MXCMDXTD'                                  MD056612
     C                             or ChkFile = 'MXCMFXTD'                                  MD056612
     C                             or ChkFile = 'MXDGDXTD'                                  MD056612
     C                             or ChkFile = 'MXDGEXTD'                                  MD056612
     C                             or ChkFile = 'MXEXDXTD'                                  MD056612
     C                             or ChkFile = 'MXEXFXTD'                                  MD056612
     C                             or ChkFile = 'MXEXSXTD'                                  MD056612
     C                             or ChkFile = 'SMBRCXTD'                                  MD057599
     C                             or ChkFile = 'SMCARXTD'                                  MD057599
     C                             or ChkFile = 'SMCSIXTD'                                  MD057599
     C                             or ChkFile = 'SMLNRXTD'                                  MD057599
     C                             or ChkFile = 'SMLOAXTD'                                  MD057599
     C                             or ChkFile = 'UTGENXTD'                                  MD057599
     C                             or ChkFile = 'SDOREXTD'                                  MD057707
     C                             or ChkFile = 'CBCMPXTD'                                  MD055891
     C                             or ChkFile = 'CBDPRXTD'                                  MD055891
     C                             or ChkFile = 'CBMEXXTD'                                  MD055891
     C                             or ChkFile = 'CBMDCXTD'                                  MD055891
     C                             or ChkFile = 'CBRUNXTD'                                  MD055891
     C                             or ChkFile = 'CBTPGXTD'                                  MD055891
     C                             or ChkFile = 'GPSRIXTD'                                  MD056555
     C                             or ChkFile = 'GPSRNXTD'                                  MD056555
     C                             or ChkFile = 'GPSRPXTD'                                  MD056555
     C                             or ChkFile = 'GPSRVXTD'                                  MD056555
     C                             or ChkFile = 'GPSRWXTD'                                  MD056555
     C                             or ChkFile = 'SCSRBXTD'                                  MD056555
     C                             or ChkFile = 'SCSRCXTD'                                  MD056555
     C                             or ChkFile = 'SCSRIXTD'                                  MD056555
     C                             or ChkFile = 'SCSRMXTD'                                  MD056555
     C                             or ChkFile = 'SCSRNXTD'                                  MD056555
     C                             or ChkFile = 'SCSROXTD'                                  MD056555
     C                             or ChkFile = 'SCSRPXTD'                                  MD056555
     C                             or ChkFile = 'SCSRRXTD'                                  MD056555
     C                             or ChkFile = 'SCSRVXTD'                                  MD056555
     C                             or ChkFile = 'SCSRWXTD'                                  MD056555
     C                             or ChkFile = 'SCSRXXTD'                                  MD056555
     C                             or ChkFile = 'GPSECXTD'                                  MD054346
     C                             or ChkFile = 'GPWATXTD'                                  MD056891
     C                             or ChkFile = 'SDEXMXTD'                                  MD056808
     C                             or ChkFile = 'EDBUTXTD'                                  MD058071
     C                             or ChkFile = 'EDDFTXTD'                                  MD058071
     C                             or ChkFile = 'EDDKYXTD'                                  MD058071
     C                             or ChkFile = 'EDFOKXTD'                                  MD058071
     C                             or ChkFile = 'EDLKYXTD'                                  MD058071
     C                             or ChkFile = 'EDMKYXTD'                                  MD058071
     C                             or ChkFile = 'EDSKYXTD'                                  MD058071
     C                             or ChkFile = 'BYCTYXTD'                                  MD058068
     C                             or ChkFile = 'BYGTEXTD'                                  MD058068
     C                             or ChkFile = 'BYGTMXTD'                                  MD058068
     C                             or ChkFile = 'BYINDXTD'                                  MD058068
     C                             or ChkFile = 'BYINRXTD'                                  MD058068
     C                             or ChkFile = 'BYINSXTD'                                  MD058068
     C                             or ChkFile = 'BYINTXTD'                                  MD058068
     C                             or ChkFile = 'BYPRDXTD'                                  MD058068
     C                             or ChkFile = 'BYPRMXTD'                                  MD058068
     C                             or ChkFile = 'BYREGXTD'                                  MD058068
     C                             or ChkFile = 'CGCSTXTD'                                  MD058069
     C                             or ChkFile = 'CGCTYXTD'                                  MD058069
     C                             or ChkFile = 'CGISTXTD'                                  MD058069
     C                             or ChkFile = 'CGPSHXTD'                                  MD058069
     C                             or ChkFile = 'CGRGZXTD'                                  MD058069
     C                             or ChkFile = 'RNAMTXTD'                                  MD058082
     C                             or ChkFile = 'RNCPYXTD'                                  MD058082
     C                             or ChkFile = 'RNCTYXTD'                                  MD058082
     C                             or ChkFile = 'RNECSXTD'                                  MD058082
     C                             or ChkFile = 'RNEPIXTD'                                  MD058082
     C                             or ChkFile = 'RNEXCXTD'                                  MD058082
     C                             or ChkFile = 'RNICPXTD'                                  MD058082
     C                             or ChkFile = 'RNKYPXTD'                                  MD058082
     C                             or ChkFile = 'RNSECXTD'                                  MD058082
     C                             or ChkFile = 'SDAUEXTD'                                  MD058085
     C                             or ChkFile = 'SDAUFXTD'                                  MD058085
     C                             or ChkFile = 'SDAUSXTD'                                  MD058085
     C                             or ChkFile = 'SDAUXXTD'                                  MD058085
     C                             or ChkFile = 'SDBACXTD'                                  MD058085
     C                             or ChkFile = 'SDBAJXTD'                                  MD058085
     C                             or ChkFile = 'SDBAPXTD'                                  MD058085
     C                             or ChkFile = 'SDBATXTD'                                  MD058085
     C                             or ChkFile = 'SDBRKXTD'                                  MD058085
     C                             or ChkFile = 'SDBTSXTD'                                  MD058085
     C                             or ChkFile = 'SDCMTXTD'                                  MD058085
     C                             or ChkFile = 'SDCMUXTD'                                  MD058085
     C                             or ChkFile = 'SDDSTXTD'                                  MD058085
     C                             or ChkFile = 'SDECLXTD'                                  MD058085
     C                             or ChkFile = 'SDFNCXTD'                                  MD058085
     C                             or ChkFile = 'SDIRMXTD'                                  MD058085
     C                             or ChkFile = 'SDISOXTD'                                  MD058085
     C                             or ChkFile = 'SDMAPXTD'                                  MD058085
     C                             or ChkFile = 'SDMDFXTD'                                  MD058085
     C                             or ChkFile = 'SDMMOXTD'                                  MD058085
     C                             or ChkFile = 'SDMTYXTD'                                  MD058085
     C                             or ChkFile = 'SDNCDXTD'                                  MD058085
     C                             or ChkFile = 'SDNCOXTD'                                  MD058085
     C                             or ChkFile = 'SDPMRXTD'                                  MD058085
     C                             or ChkFile = 'SDSRFXTD'                                  MD058085
     C                             or ChkFile = 'SDTDTXTD'                                  MD058085
     C                             or ChkFile = 'SDTIAXTD'                                  MD058085
     C                             or ChkFile = 'SDTIZXTD'                                  MD058085
     C                             or ChkFile = 'SDWLCXTD'                                  MD058085
     C                             or ChkFile = 'SDWLIXTD'                                  MD058085
     C                             or ChkFile = 'SDWLTXTD'                                  MD058085
     C                             or ChkFile = 'SDWMTXTD'                                  MD058085
     C                             or ChkFile = 'APARCXTD'                                  MD058079
     C                             or ChkFile = 'EMCOFXTD'                                  MD058079
     C                             or ChkFile = 'ERLNAXTD'                                  MD058079
     C                             or ChkFile = 'ERL11XTD'                                  MD058079
     C                             or ChkFile = 'FCRPAXTD'                                  MD058079
     C                             or ChkFile = 'FTTRTXTD'                                  MD058079
     C                             or ChkFile = 'GLFNAXTD'                                  MD058079
     C                             or ChkFile = 'LEDLLXTD'                                  MD058079
     C                             or ChkFile = 'MQ540XTD'                                  MD058079
     C                             or ChkFile = 'MRKEYXTD'                                  MD058079
     C                             or ChkFile = 'MRMBIXTD'                                  MD058079
     C                             or ChkFile = 'SECONXTD'                                  MD058079
     C                             or ChkFile = 'SEEURXTD'                                  MD058079
     C                             or ChkFile = 'SFAPIXTD'                                  MD058079
     C                             or ChkFile = 'ZATRGXTD'                                  MD058079
     C                             or ChkFile = 'SMACFXTD'                                  MD058089
     C                             or ChkFile = 'SMCNUXTD'                                  MD058089
     C                             or ChkFile = 'SMCPYXTD'                                  MD058089
     C                             or ChkFile = 'SMFIDXTD'                                  MD058089
     C                             or ChkFile = 'SMFITXTD'                                  MD058089
     C                             or ChkFile = 'SMFIUXTD'                                  MD058089
     C                             or ChkFile = 'SMGNMXTD'                                  MD058089
     C                             or ChkFile = 'SMINPXTD'                                  MD058089
     C                             or ChkFile = 'SMMSRXTD'                                  MD058089
     C                             or ChkFile = 'SMMTOXTD'                                  MD058089
     C                             or ChkFile = 'SMRCFXTD'                                  MD058089
     C                             or ChkFile = 'SMSFCXTD'                                  MD058089
     C                             or ChkFile = 'SMZNMXTD'                                  MD058089
     C                             or ChkFile = 'UPMPXXTD'                                  MD058089
     C                             or ChkFile = 'UTSCRXTD'                                  MD058089
     C                             or ChkFile = 'UTSRCXTD'                                  MD058089
     C                             or ChkFile = 'SCDTRXTD'                                  MD058087
     C                             or ChkFile = 'SCMEXXTD'                                  MD058087
     C                             or ChkFile = 'SCRMVXTD'                                  MD058087
     C                             or ChkFile = 'SCSVPXTD'                                  MD058087
     C                             or ChkFile = 'UTMNUXTD'                                  MD060488
     C                             or ChkFile = 'SMOTCXTD'                                    CUP046
     C                             or ChkFile = 'SCFFDXTD'                                    CSC059
     C                             or ChkFile = 'SDRTRXTD'                                  MD058755
     C                             or ChkFile = 'SDNARXTD'                                  MD058769
     C                             or ChkFile = 'T_APIXTD'                                  MD056602
     C                             or ChkFile = 'TABV4XTD'                                  MD058854
     C                             or ChkFile = 'T_ALAXTD'                                  MD058088
     C                             or ChkFile = 'T_ALMXTD'                                  MD058088
     C                             or ChkFile = 'T_APTXTD'                                  MD058088
     C                             or ChkFile = 'T_FREXTD'                                  MD058088
     C                             or ChkFile = 'T_FRPXTD'                                  MD058088
     C                             or ChkFile = 'T_FROXTD'                                  MD058088
     C                             or ChkFile = 'T_FRUXTD'                                  MD058088
     C                             or ChkFile = 'T_EXAXTD'                                  MD058088
     C                             or ChkFile = 'T_EXMXTD'                                  MD058088
     C                             or ChkFile = 'T_EXTXTD'                                  MD058088
     C                             or ChkFile = 'T_MLCXTD'                                  MD058088
     C                             or ChkFile = 'T_MLEXTD'                                  MD058088
     C                             or ChkFile = 'T_MLGXTD'                                  MD058088
     C                             or ChkFile = 'T_MLLXTD'                                  MD058088
     C                             or ChkFile = 'T_MLTXTD'                                  MD058088
     C                             or ChkFile = 'T_POPXTD'                                  MD058088
     C                             or ChkFile = 'T_DLTXTD'                                  MD058088
     C                             or ChkFile = 'T_SMOXTD'                                  MD058088
     C                             or ChkFile = 'T_WACXTD'                                  MD058088
     C                             or ChkFile = 'T_WSTXTD'                                  MD058088
     C                             or ChkFile = 'MEBEIXTD'                                  MD058081
     C                             or ChkFile = 'MEBTYXTD'                                  MD058081
     C                             or ChkFile = 'MECHKXTD'                                  MD058081
     C                             or ChkFile = 'MEINCXTD'                                  MD058081
     C                             or ChkFile = 'MEISOXTD'                                  MD058081
     C                             or ChkFile = 'MEIVMXTD'                                  MD058081
     C                             or ChkFile = 'MESTGXTD'                                  MD058081
     C                             or ChkFile = 'MGCONXTD'                                  MD058081
     C                             or ChkFile = 'MG580XTD'                                  MD058081
     C                             or ChkFile = 'MSRCOXTD'                                  MD058081
     C                             or ChkFile = 'SDNWKXTD'                                  MD058830
     C                             or ChkFile = 'SDNW1XTD'                                  MD058830
     C                             or ChkFile = 'SDLIBXTD'                                  MD060008
     C                             or ChkFile = 'SDARRXTD'                                  MD061274
     C                             or ChkFile = 'GPACSXTD'                                  MD058188
     C                             or ChkFile = 'GPACXXTD'                                  MD058188
     C                             or ChkFile = 'GPCTRXTD'                                  MD058188
     C                             or ChkFile = 'GPFRSXTD'                                  MD058188
     C                             or ChkFile = 'GPGRSXTD'                                  MD058188
     C                             or ChkFile = 'GPICRXTD'                                  MD058188
     C                             or ChkFile = 'GPICYXTD'                                  MD058188
     C                             or ChkFile = 'GPINSXTD'                                  MD058188
     C                             or ChkFile = 'GPNJRXTD'                                  MD058188
     C                             or ChkFile = 'SCRELXTD'                                  MD060352
     C                             or ChkFile = 'GPRELXTD'                                  MD060352
     C                             or ChkFile = 'SDIDCXTD'                                    CSW101
     C                             or ChkFile = 'SMBFPXTD'                                  MD060877
     C                             or ChkFile = 'SMRLSXTD'                                  MD060877
     C                             or ChkFile = 'UPDDSXTD'                                  MD061577
     C                             or ChkFile = 'UPADMXTD'                                  MD061576
     C                             or ChkFile = 'ZZGBLXTD'                                  MD061518
     C                             or ChkFile = 'RPACIXTD'                                  MD061503
     C                             or ChkFile = 'RPASIXTD'                                  MD061503
     C                             or ChkFile = 'RPMSGXTD'                                  MD061503
     C                             or ChkFile = 'UPEXCXTD'                                  MD061706
     C                             or ChkFile = 'MIAFXXTD'                                  MD060918
     C                             or ChkFile = 'MIASFXTD'                                  MD060918
     C                             or ChkFile = 'MIBEVXTD'                                  MD060918
     C                             or ChkFile = 'MILNGXTD'                                  MD060918
     C                             or ChkFile = 'MIPRMXTD'                                  MD060918
     C                             or ChkFile = 'SDCTLXTD'                                  MD061009
     C                             or ChkFile = 'GPCTLXTD'                                  MD061009

     C                   EVAL      AUMBNM = Member
     C                   EVAL      AUMBTX = ObjectText
     C                   EVAL      AUDTYP = 'I'
     C                   EVAL      AUMBTP = 'DDSDATA'                                       MD054605
     C                   LEAVESR
     C                   ENDIF
     C                   Endif                                                              MD057035
      *
      ** Check if the file has '_X' which means it is a delete version of an
      **  Extract File.
     C                   EVAL      FoundPos = %SCAN('_X':Member)
     C                   IF        FoundPos <> 0
      ** Then check if the stem of the name matches the previous file name to
      **  prevent two records beign written for the same file.
     C                   EVAL      ChkFile = %SUBST(Member:1:(FoundPos - 1))
     C                   IF        ChkFile = PrevFile
     C                   EVAL      NoWrite = 'N'
     C                   ELSE
      * ..... processing to handle the write of _X without the _X.
     C                   EVAL      AUMBNM = ChkFile
     C                   EVAL      AUMBTX = *blanks
     C                   EVAL      AUDTYP = 'I'
     C                   ENDIF
      ** If it was not a file with '_X' then it is assumed that it is a normal
      **  Extract File.
     C                   ELSE
     C                   EVAL      ChkFile = Member
     C                   EVAL      AUMBNM = Member
     C                   EVAL      AUMBTX = *blanks
     C                   EVAL      AUDTYP = 'O'
      ** Find from text whether it is to be copied *ADD or *REPLACE.
     C                   EXSR      ChkCopyOpt
      *
      ** Save file name in case next record is an '_X' version.
     C                   EVAL      PrevFile = Member
     C                   ENDIF
      *
      ** Before writing the record check if it should have been delivered as an
      **  Action File.
     C                   EXSR      CheckActF
     C                   IF        ActionFile = 'Y'
     C                   EVAL      Char100 = 'Deliverable data - +
     C                             Should not be Extract File              : ' +
     C                             Member
     C                   EXSR      InsertErrMsg
     C                   ENDIF
      *
     C     ProcOtherE    ENDSR
      *
      *********************************************************************
      *                                                                   *
      *    FindLayer - Find the layer for deliverable data items.         *
      *                                                                   *
      *********************************************************************
     C     FindLayer     BEGSR
      *
     C                   EVAL      ObjectType = ObjType
     C                   CALL      'UTRTVOBJD'
     C                   PARM                    Member
     C                   PARM      '*LIBL'       Library
     C                   PARM                    ObjectType
     C                   PARM                    ReturnCode
     C                   PARM                    ReturnData
      ** If not found, try with 'old' name                                                  MD054955
     C                   IF        ReturnCode = 'E'                                         MD054955
     C                             and %SUBST(Member:6:3) = 'CTD'                           MD054955
     C                   SELECT                                                             MD054955
     C     Member        WHENEQ    'CGCSHCTD'                                               MD054955
     C                   EVAL      Member = 'CGCSCHPD'                                      MD054955
     C     Member        WHENEQ    'CGGSACTD'                                               MD054955
     C                   EVAL      Member = 'CGGSASPD'                                      MD054955
     C     Member        WHENEQ    'CGPTNCTD'                                               MD054955
     C                   EVAL      Member = 'CGPTTNPD'                                      MD054955
     C     Member        WHENEQ    'CGPTYCTD'                                               MD054955
     C                   EVAL      Member = 'CGPTYPPD'                                      MD054955
     C     Member        WHENEQ    'CGRASCTD'                                               MD054955
     C                   EVAL      Member = 'CGRASCPD'                                      MD054955
     C     Member        WHENEQ    'CGRDECTD'                                               MD054955
     C                   EVAL      Member = 'CGRDECPD'                                      MD054955
     C     Member        WHENEQ    'CGRDTCTD'                                               MD054955
     C                   EVAL      Member = 'CGRDTAPD'                                      MD054955
     C     Member        WHENEQ    'CGSETCTD'                                               MD054955
     C                   EVAL      Member = 'CGGSETPD'                                      MD054955
     C     Member        WHENEQ    'FCRCOCTD'                                               MD055265
     C                   EVAL      Member = 'FCRCOMPD'                                      MD054955
     C     Member        WHENEQ    'FCREPCTD'                                               MD055265
     C                   EVAL      Member = 'FCREPTPD'                                      MD054955
     C     Member        WHENEQ    'FCRSFCTD'                                               MD055265
     C                   EVAL      Member = 'FCRSFXPD'                                      MD054955
     C                   ENDSL                                                              MD054955
                                                                                            MD054955
     C                   CALL      'UTRTVOBJD'                                              MD054955
     C                   PARM                    Member                                     MD054955
     C                   PARM      '*LIBL'       Library                                    MD054955
     C                   PARM                    ObjectType                                 MD054955
     C                   PARM                    ReturnCode                                 MD054955
     C                   PARM                    ReturnData                                 MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C                   IF        ReturnCode = *blank
      ** Determine layer form the 3rd character of the returned library name.
     C                   IF        %SUBST(ReturnData:41:1) ='G'
     C                             or %SUBST(ReturnData:41:2) ='BF'
     C                   EVAL      AUDTLB = '*GLOBAL'
     C                   ELSE
     C                   EVAL      AUDTLB = '*ZONE'
     C                   ENDIF
     C                   ELSE
     C                   IF        Member = 'GPWIPCTD'                                      MD055081
     C                             or Member = 'GPSRDCTD'                                   MD055681
     C                             or Member = 'GPSRSCTD'                                   MD055681
     C                             or Member = 'GPTRGCTD'                                   MD055682
     C                             or Member = 'GPSRTCTD'                                   MD055682
     C**********                   or Member = 'UPDDSFPD'                          MD056694 MD061577
     C                             or Member = 'UPDDSCTD'                                   MD061577
     C                             or Member = 'GPGLFCTD'                                   MD056556
     C                             or Member = 'GPJARCTD'                                   MD056889
     C                             or Member = 'GPNDCCTD'                                   MD056564
     C                             or Member = 'GPAUACTD'                                   MD056611
     C                             or Member = 'GPAUDCTD'                                   MD056611
     C                             or Member = 'GPAUFCTD'                                   MD056611
     C                             or Member = 'GPAUICTD'                                   MD056611
     C                             or Member = 'GPAURCTD'                                   MD056611
     C                             or Member = 'GPDFLCTD'                                   MD056565
     C                             or Member = 'GPPWHCTD'                                   MD056557
     C                             or Member = 'GPPWNCTD'                                   MD056557
     C                             or Member = 'SMCSICTD'                                   MD057599
     C                             or Member = 'SMLNRCTD'                                   MD057599
     C                             or Member = 'SMLOACTD'                                   MD057599
     C                             or Member = 'GPSRICTD'                                   MD056555
     C                             or Member = 'GPSRNCTD'                                   MD056555
     C                             or Member = 'GPSRPCTD'                                   MD056555
     C                             or Member = 'GPSRVCTD'                                   MD056555
     C                             or Member = 'GPSRWCTD'                                   MD056555
     C                             or Member = 'GPSECCTD'                                   MD054346
     C                             or Member = 'GPWATCTD'                                   MD056891
     C                             or Member = 'UPMPXCTD'                                   MD058089
     C                             or Member = 'UTSCRCTD'                                   MD058089
     C                             or Member = 'UTSRCCTD'                                   MD058089
     C                             or Member = 'SMRCFCTD'                                   MD058089
     C                             or Member = 'SMFITCTD'                                   MD058089
     C                             or Member = 'SMFIUCTD'                                   MD058089
     C                             or Member = 'SMGNMCTD'                                   MD058089
     C                             or Member = 'SMINPCTD'                                   MD058089
     C                             or Member = 'SMCNUCTD'                                   MD058089
     C                             or Member = 'UTMNUCTD'                                   MD060488
     C                             or Member = 'SMOTCCTD'                                     CUP046
     C**********         EVAL      AUDTLB = '*GLOBAL'                              MD055081 MD060964
     C                             or Member = 'T_APICTD'                                   MD056602
     C                             or Member = 'T_ALACTD'                                   MD058088
     C                             or Member = 'T_ALMCTD'                                   MD058088
     C                             or Member = 'T_APTCTD'                                   MD058088
     C                             or Member = 'T_FRECTD'                                   MD058088
     C                             or Member = 'T_FRPCTD'                                   MD058088
     C                             or Member = 'T_FROCTD'                                   MD058088
     C                             or Member = 'T_FRUCTD'                                   MD058088
     C                             or Member = 'T_EXACTD'                                   MD058088
     C                             or Member = 'T_EXMCTD'                                   MD058088
     C                             or Member = 'T_EXTCTD'                                   MD058088
     C                             or Member = 'T_MLCCTD'                                   MD058088
     C                             or Member = 'T_MLECTD'                                   MD058088
     C                             or Member = 'T_MLGCTD'                                   MD058088
     C                             or Member = 'T_MLLCTD'                                   MD058088
     C                             or Member = 'T_MLTCTD'                                   MD058088
     C                             or Member = 'T_POPCTD'                                   MD058088
     C                             or Member = 'T_DLTCTD'                                   MD058088
     C                             or Member = 'T_SMOCTD'                                   MD058088
     C                             or Member = 'T_WACCTD'                                   MD058088
     C                             or Member = 'T_WSTCTD'                                   MD058088
     C                             or Member = 'GPACSCTD'                                   MD058188
     C                             or Member = 'GPACXCTD'                                   MD058188
     C                             or Member = 'GPCTRCTD'                                   MD058188
     C                             or Member = 'GPFRSCTD'                                   MD058188
     C                             or Member = 'GPGRSCTD'                                   MD058188
     C                             or Member = 'GPICRCTD'                                   MD058188
     C                             or Member = 'GPICYCTD'                                   MD058188
     C                             or Member = 'GPINSCTD'                                   MD058188
     C                             or Member = 'GPNJRCTD'                                   MD058188
     C                             or Member = 'GPRELCTD'                                   MD060352
     C                             or Member = 'SMBFPCTD'                                   MD060877
     C                             or Member = 'SMRLSCTD'                                   MD060877
     C                             or Member = 'UPADMCTD'                                   MD061576
     C                             or Member = 'ZZGBLCTD'                                   MD061518
     C                             or Member = 'UPEXCCTD'                                   MD061706
     C                             or Member = 'MIAFXCTD'                                   MD060918
     C                             or Member = 'MIASFCTD'                                   MD060918
     C                             or Member = 'MIBEVCTD'                                   MD060918
     C                             or Member = 'MILNGCTD'                                   MD060918
     C                             or Member = 'MIPRMCTD'                                   MD060918
     C                             or Member = 'GPCTLCTD'                                   MD061009
     C                   EVAL      AUDTLB = '*GLOBAL'                                       MD055081
     C                   Else                                                               MD055081
     C                   IF        Member = 'SCHLPCTD'                                      MD055264
     C                             or Member = 'SCSRDCTD'                                   MD055681
     C                             or Member = 'SCSRSCTD'                                   MD055681
     C                             or Member = 'SCTRGCTD'                                   MD055682
     C                             or Member = 'SCSRTCTD'                                   MD055682
     C                             or Member = 'APPGSCTD'                                   MD056610
     C                             or Member = 'APDBICTD'                                   MD056606
     C                             or Member = 'GODTCCTD'                                   MD056558
     C                             or Member = 'APFUNCTD'                                   MD056608
     C                             or Member = 'SCSQLCTD'                                   MD056559
     C                             or Member = 'SCNJRCTD'                                   MD056887
     C                             or Member = 'SDMRFCTD'                                   MD056890
     C                             or Member = 'SDJARCTD'                                   MD056889
     C                             or Member = 'MESWACTD'                                   MD056781
     C                             or Member = 'APMNXCTD'                                   MD056609
     C                             or Member = 'APDTKCTD'                                   MD056605
     C                             or Member = 'APUDKCTD'                                   MD056605
     C                             or Member = 'SDCWFCTD'                                   MD056807
     C                             or Member = 'SDCWMCTD'                                   MD056807
     C                             or Member = 'APNDCCTD'                                   MD056564
     C                             or Member = 'SDRPCCTD'                                   MD056811
     C                             or Member = 'SDRPDCTD'                                   MD056811
     C                             or Member = 'SDMTGCTD'                                   MD056560
     C                             or Member = 'CBVLLCTD'                                   MD056567
     C                             or Member = 'FCVLLCTD'                                   MD056567
     C                             or Member = 'MIVLLCTD'                                   MD056567
     C                             or Member = 'Y2VLLCTD'                                   MD056567
     C                             or Member = 'SDINFCTD'                                   MD056613
     C                             or Member = 'SDINPCTD'                                   MD056613
     C                             or Member = 'SDIPVCTD'                                   MD056613
     C                             or Member = 'SDFUCCTD'                                   MD056633
     C                             or Member = 'GLFXMCTD'                                   MD056751
     C                             or Member = 'GLGXMCTD'                                   MD056751
     C                             or Member = 'MEINFCTD'                                   MD056752
     C                             or Member = 'SDSCOCTD'                                   MD056812
     C                             or Member = 'SDTRFCTD'                                   MD056816
     C                             or Member = 'SDTRHCTD'                                   MD056816
     C                             or Member = 'SDCODCTD'                                   MD056888
     C                             or Member = 'RPCOBCTD'                                   MD057598
     C                             or Member = 'RPMNUCTD'                                   MD057598
     C                             or Member = 'RPSDTCTD'                                   MD057598
     C                             or Member = 'RPSYRCTD'                                   MD057598
     C                             or Member = 'RPTPTCTD'                                   MD057598
     C                             or Member = 'RPTRQCTD'                                   MD057598
     C                             or Member = 'SDCTYCTD'                                   MD056806
     C                             or Member = 'SDFTYCTD'                                   MD056810
     C                             or Member = 'APDFLCTD'                                   MD056565
     C                             or Member = 'SDPWHCTD'                                   MD056557
     C                             or Member = 'SDPWNCTD'                                   MD056557
     C                             or Member = 'MXCMDCTD'                                   MD056612
     C                             or Member = 'MXCMFCTD'                                   MD056612
     C                             or Member = 'MXDGDCTD'                                   MD056612
     C                             or Member = 'MXDGECTD'                                   MD056612
     C                             or Member = 'MXEXDCTD'                                   MD056612
     C                             or Member = 'MXEXFCTD'                                   MD056612
     C                             or Member = 'MXEXSCTD'                                   MD056612
     C                             or Member = 'SMBRCCTD'                                   MD057599
     C                             or Member = 'SMCARCTD'                                   MD057599
     C                             or Member = 'UTGENCTD'                                   MD057599
     C                             or Member = 'SDORECTD'                                   MD057707
     C                             or Member = 'CBCMPCTD'                                   MD055891
     C                             or Member = 'CBDPRCTD'                                   MD055891
     C                             or Member = 'CBMEXCTD'                                   MD055891
     C                             or Member = 'CBMDCCTD'                                   MD055891
     C                             or Member = 'CBRUNCTD'                                   MD055891
     C                             or Member = 'CBTPGCTD'                                   MD055891
     C                             or Member = 'SCSRBCTD'                                   MD056555
     C                             or Member = 'SCSRCCTD'                                   MD056555
     C                             or Member = 'SCSRICTD'                                   MD056555
     C                             or Member = 'SCSRMCTD'                                   MD056555
     C                             or Member = 'SCSRNCTD'                                   MD056555
     C                             or Member = 'SCSROCTD'                                   MD056555
     C                             or Member = 'SCSRPCTD'                                   MD056555
     C                             or Member = 'SCSRRCTD'                                   MD056555
     C                             or Member = 'SCSRVCTD'                                   MD056555
     C                             or Member = 'SCSRWCTD'                                   MD056555
     C                             or Member = 'SCSRXCTD'                                   MD056555
     C                             or Member = 'SDEXMCTD'                                   MD056808
     C                             or Member = 'EDBUTCTD'                                   MD058071
     C                             or Member = 'EDDFTCTD'                                   MD058071
     C                             or Member = 'EDDKYCTD'                                   MD058071
     C                             or Member = 'EDFOKCTD'                                   MD058071
     C                             or Member = 'EDLKYCTD'                                   MD058071
     C                             or Member = 'EDMKYCTD'                                   MD058071
     C                             or Member = 'EDSKYCTD'                                   MD058071
     C                             or Member = 'BYCTYCTD'                                   MD058068
     C                             or Member = 'BYGTECTD'                                   MD058068
     C                             or Member = 'BYGTMCTD'                                   MD058068
     C                             or Member = 'BYINDCTD'                                   MD058068
     C                             or Member = 'BYINRCTD'                                   MD058068
     C                             or Member = 'BYINSCTD'                                   MD058068
     C                             or Member = 'BYINTCTD'                                   MD058068
     C                             or Member = 'BYPRDCTD'                                   MD058068
     C                             or Member = 'BYPRMCTD'                                   MD058068
     C                             or Member = 'BYREGCTD'                                   MD058068
     C                             or Member = 'CGCSTCTD'                                   MD058069
     C                             or Member = 'CGCTYCTD'                                   MD058069
     C                             or Member = 'CGISTCTD'                                   MD058069
     C                             or Member = 'CGPSHCTD'                                   MD058069
     C                             or Member = 'CGRGZCTD'                                   MD058069
     C                             or Member = 'RNAMTCTD'                                   MD058082
     C                             or Member = 'RNCPYCTD'                                   MD058082
     C                             or Member = 'RNCTYCTD'                                   MD058082
     C                             or Member = 'RNECSCTD'                                   MD058082
     C                             or Member = 'RNEPICTD'                                   MD058082
     C                             or Member = 'RNEXCCTD'                                   MD058082
     C                             or Member = 'RNICPCTD'                                   MD058082
     C                             or Member = 'RNKYPCTD'                                   MD058082
     C                             or Member = 'RNSECCTD'                                   MD058082
     C                             or Member = 'SDAUECTD'                                   MD058085
     C                             or Member = 'SDAUFCTD'                                   MD058085
     C                             or Member = 'SDAUSCTD'                                   MD058085
     C                             or Member = 'SDAUXCTD'                                   MD058085
     C                             or Member = 'SDBACCTD'                                   MD058085
     C                             or Member = 'SDBAJCTD'                                   MD058085
     C                             or Member = 'SDBAPCTD'                                   MD058085
     C                             or Member = 'SDBATCTD'                                   MD058085
     C                             or Member = 'SDBRKCTD'                                   MD058085
     C                             or Member = 'SDBTSCTD'                                   MD058085
     C                             or Member = 'SDCMTCTD'                                   MD058085
     C                             or Member = 'SDCMUCTD'                                   MD058085
     C                             or Member = 'SDDSTCTD'                                   MD058085
     C                             or Member = 'SDECLCTD'                                   MD058085
     C                             or Member = 'SDFNCCTD'                                   MD058085
     C                             or Member = 'SDIRMCTD'                                   MD058085
     C                             or Member = 'SDISOCTD'                                   MD058085
     C                             or Member = 'SDMAPCTD'                                   MD058085
     C                             or Member = 'SDMDFCTD'                                   MD058085
     C                             or Member = 'SDMMOCTD'                                   MD058085
     C                             or Member = 'SDMTYCTD'                                   MD058085
     C                             or Member = 'SDNCDCTD'                                   MD058085
     C                             or Member = 'SDNCOCTD'                                   MD058085
     C                             or Member = 'SDPMRCTD'                                   MD058085
     C                             or Member = 'SDSRFCTD'                                   MD058085
     C                             or Member = 'SDTDTCTD'                                   MD058085
     C                             or Member = 'SDTIACTD'                                   MD058085
     C                             or Member = 'SDTIZCTD'                                   MD058085
     C                             or Member = 'SDWLCCTD'                                   MD058085
     C                             or Member = 'SDWLICTD'                                   MD058085
     C                             or Member = 'SDWLTCTD'                                   MD058085
     C                             or Member = 'SDWMTCTD'                                   MD058085
     C                             or Member = 'APARCCTD'                                   MD058079
     C                             or Member = 'EMCOFCTD'                                   MD058079
     C                             or Member = 'ERLNACTD'                                   MD058079
     C                             or Member = 'ERL11CTD'                                   MD058079
     C                             or Member = 'FCRPACTD'                                   MD058079
     C                             or Member = 'FTTRTCTD'                                   MD058079
     C                             or Member = 'GLFNACTD'                                   MD058079
     C                             or Member = 'LEDLLCTD'                                   MD058079
     C                             or Member = 'MQ540CTD'                                   MD058079
     C                             or Member = 'MRKEYCTD'                                   MD058079
     C                             or Member = 'MRMBICTD'                                   MD058079
     C                             or Member = 'SECONCTD'                                   MD058079
     C                             or Member = 'SEEURCTD'                                   MD058079
     C                             or Member = 'SFAPICTD'                                   MD058079
     C                             or Member = 'ZATRGCTD'                                   MD058079
     C                             or Member = 'SMACFCTD'                                   MD058089
     C                             or Member = 'SMCPYCTD'                                   MD058089
     C                             or Member = 'SMFIDCTD'                                   MD058089
     C                             or Member = 'SMMSRCTD'                                   MD058089
     C                             or Member = 'SMMTOCTD'                                   MD058089
     C                             or Member = 'SMSFCCTD'                                   MD058089
     C                             or Member = 'SMZNMCTD'                                   MD058089
     C                             or Member = 'SCDTRCTD'                                   MD058087
     C                             or Member = 'SCMEXCTD'                                   MD058087
     C                             or Member = 'SCRMVCTD'                                   MD058087
     C                             or Member = 'SCSVPCTD'                                   MD058087
     C                             or Member = 'SCFFDCTD'                                     CSC059
     C                             or Member = 'SDRTRCTD'                                   MD058755
     C                             or Member = 'SDNARCTD'                                   MD058769
     C                             or Member = 'TABV4CTD'                                   MD058854
     C                             or Member = 'MEBEICTD'                                   MD058081
     C                             or Member = 'MEBTYCTD'                                   MD058081
     C                             or Member = 'MECHKCTD'                                   MD058081
     C                             or Member = 'MEINCCTD'                                   MD058081
     C                             or Member = 'MEISOCTD'                                   MD058081
     C                             or Member = 'MEIVMCTD'                                   MD058081
     C                             or Member = 'MESTGCTD'                                   MD058081
     C                             or Member = 'MGCONCTD'                                   MD058081
     C                             or Member = 'MG580CTD'                                   MD058081
     C                             or Member = 'MSRCOCTD'                                   MD058081
     C                             or Member = 'SDNWKCTD'                                   MD058830
     C                             or Member = 'SDNW1CTD'                                   MD058830
     C                             or Member = 'SDLIBCTD'                                   MD060008
     C                             or Member = 'SDARRCTD'                                   MD061274
     C                             or Member = 'SCRELCTD'                                   MD060352
     C                             or Member = 'SDIDCCTD'                                     CSW101
     C                             or Member = 'RPACICTD'                                   MD061503
     C                             or Member = 'RPASICTD'                                   MD061503
     C                             or Member = 'RPMSGCTD'                                   MD061503
     C                             or Member = 'SDCTLCTD'                                   MD061009
     C                   EVAL      AUDTLB = '*ZONE'                                         MD055264
     C                   Else                                                               MD055264
     C/exec SQL                                                                             MD057943
     C+ select substr(AUSRCF, 9, 1) into :x_SRCPF                                           MD057943
     C+ from UPDLVCPD                                                                       MD057943
     C+ where AUMBNM = :Member                                                              MD057943
     C/end-exec                                                                             MD057943
     C                   If        SQLCODE = 0                                              MD057943
     C                   If        x_SRCPF = 'G'                                            MD057943
     C                   EVAL      AUDTLB = '*GLOBAL'                                       MD057943
     C                   else                                                               MD057943
     C                   EVAL      AUDTLB = '*ZONE'                                         MD057943
     C                   Endif                                                              MD057943
     C                   Else                                                               MD057943
                                                                                            MD057943
     C                   EVAL      AUDTLB = '*UNKNOWN'
     C                   EVAL      Char100 = 'Deliverable data - +
     C                             Unknown layer                           : ' +
     C                             Member + ObjectType
     C                   EXSR      InsertErrMsg
     C                   ENDIF                                                              MD057943
     C                   Endif                                                              MD055264
     C                   Endif                                                              MD055081
     C                   ENDIF
      *
     C     FindLayerE    ENDSR
      *
      *********************************************************************
      *                                                                   *
      *    CheckActF - Check if the file has an Action File or not.       *
      *                                                                   *
      *********************************************************************
     C     CheckActF     BEGSR
      *
     C/exec SQL
     C+ select count(*) into :Count
     C+ from UPACTFPD
     C+ where
     C+    AABONF = :ChkFile
     C/end-exec
      *
     C                   IF        Count <> 0
     C                   EVAL      ActionFile = 'Y'
     C                   ELSE
     C                   EVAL      ActionFile = 'N'
     C                   ENDIF
      *
     C     CheckActFE    ENDSR
      *
      *********************************************************************
      *                                                                   *
      *    ChkCopyOpt - Check if it is to be copied *ADD or *REPLACE.     *
      *                                                                   *
      *********************************************************************
     C     ChkCopyOpt    BEGSR
      *
     C                   IF        %SCAN('*ADD':ObjectText) = 0
     C                   IF        %SCAN('*REPLACE':ObjectText) = 0
     C                   EVAL      AUCPYO = '*UNKNOWN'
     C                   EVAL      Char100 = 'Deliverable data - +
     C                             Unknown copy option                     : ' +
     C                             Member + ObjectType
     C                   EXSR      InsertErrMsg
     C                   ELSE
     C                   EVAL      AUCPYO = '*REPLACE'
     C                   EVAL      AUMBTX = *blank
     C                   ENDIF
     C                   ELSE
     C                   EVAL      AUCPYO = '*ADD'
     C                   EVAL      AUMBTX = *blank
     C                   ENDIF
      *
     C     ChkCopyOptE   ENDSR
      *
      *********************************************************************
      *                                                                   *
      *    InsertDlvList - Write record to deliverables list.             *
      *                                                                   *
      *********************************************************************
     C     InsertDlvList BEGSR
      *
     C/exec SQL
     C+ insert into UPDLVCPD
     C+ (
     C+   AUMBNM
     C+ , AUMBTP
     C+ , AUMBTX
     C+ , AUCAPR
     C+ , AUIPTY
     C+ , AUDTYP
     C+ , AUCPYO
     C+ , AUFMTO
     C+ , AUSRCF
     C+ , AUDTLB
     C+ , AUPROJ
     C+ , AUEXIN
     C+ , AUUSTS
     C+ )
     C+ values
     C+ (
     C+   :AUMBNM
     C+ , :AUMBTP
     C+ , :AUMBTX
     C+ , :AUCAPR
     C+ , :AUIPTY
     C+ , :AUDTYP
     C+ , :AUCPYO
     C+ , :AUFMTO
     C+ , :AUSRCF
     C+ , :AUDTLB
     C+ , :AUPROJ
     C+ , :AUEXIN
     C+ , :AUUSTS
     C+ )
     C/end-exec
      *
     C     InsertDlvListEENDSR
      *
      *********************************************************************
      *                                                                   *
      *    UpdateErrMsg - Tidy up error message file by deleting          *
      *                   duplicates and sorting.                         *
      *                                                                   *
      *********************************************************************
     C     UpdateErrMsg  BEGSR
      *
     C/exec SQL
     C+ insert into QTEMP/UPERRMQT
     C+ select distinct UPERRXQT
     C+ from QTEMP/UPERRXQT
     C+ order by
     C+   UPERRXQT
     C/end-exec
      *
     C     UpdateErrMSgE ENDSR
      *
      *********************************************************************
      *                                                                   *
      *    InsertErrMsg - Write record to the Bridge error file.          *
      *                                                                   *
      *********************************************************************
     C     InsertErrMsg  BEGSR
      *
     C/exec SQL
     C+ insert into QTEMP/UPERRMQT
     C+ (
     C+   UPERRMQT
     C+ )
     C+ values
     C+ (
     C+   :Char100
     C+ )
     C/end-exec
      *
     C     InsertErrMSgE ENDSR
      *
