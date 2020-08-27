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
      *  Last Amend No. MD055682             Date 31Jul20             *
      *  Prev Amend No. MD055681             Date 31Jul20             *
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
      ** Check if file is not '*XTD'                                                        MD055242
     C                   If        %SUBST(Member:6:3) = 'XTD'                               MD055242
     C                   EVAL      Char100 = '*XTD file cannot be +                         MD055242
     C                             delivered, *CTD file must be delivered  : ' +            MD055242
     C                             Member                                                   MD055242
     C                   EXSR      InsertErrMsg                                             MD055242
     C                   EVAL      NoWrite = 'N'                                            MD055242
     C                   LEAVESR                                                            MD055242
     C                   Endif                                                              MD055242
                                                                                            MD055242
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
     C                   EVAL      AUMBNM = Member
     C                   EVAL      AUMBTX = ObjectText
     C                   EVAL      AUDTYP = 'I'
     C                   EVAL      AUMBTP = 'DDSDATA'                                       MD054605
     C                   LEAVESR
     C                   ENDIF
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
     C                   EVAL      AUDTLB = '*GLOBAL'                                       MD055081
     C                   Else                                                               MD055081
     C                   IF        Member = 'SCHLPCTD'                                      MD055264
     C                             or Member = 'SCSRDCTD'                                   MD055681
     C                             or Member = 'SCSRSCTD'                                   MD055681
     C                             or Member = 'SCTRGCTD'                                   MD055682
     C                             or Member = 'SCSRTCTD'                                   MD055682
     C                   EVAL      AUDTLB = '*ZONE'                                         MD055264
     C                   Else                                                               MD055264
     C                   EVAL      AUDTLB = '*UNKNOWN'
     C                   EVAL      Char100 = 'Deliverable data - +
     C                             Unknown layer                           : ' +
     C                             Member + ObjectType
     C                   EXSR      InsertErrMsg
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
