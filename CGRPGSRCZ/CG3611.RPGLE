     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Control uniqueness of XML element name')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3611 - Control Uniqueness of XML Element Name              *
      *                                                               *
      *  Function: This sub-module receives XML Element Name input    *
      *            as one of parameters and validates that :          *
      *                                                               *
      *            (a) XML element name for Paths are unique within   *
      *                the Group Set which it belongs to.             *
      *            (b) XML element name for SYST and REFR are unique  *
      *                across ALL record types within CGRDECPD.       *
      *            (c) XML element name for SYGP is allowed to exist  *
      *                more than once within SYGP record type but     *
      *                should be unique across types SYST and REFR.   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CCG015  *CREATE    Date 17Jan01               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *****************************************************************
      /EJECT
 
      * RDE Conversion file
     FCGRDECL0  IF   E           K DISK
     FCGRDECL1  IF   E           K DISK    RENAME(CGRDECD0:CGRDECD1)
 
      * +-----------------------+
      * ¦ Parameter Declaration ¦
      * +-----------------------+
     D ElemArgt        S            111
     D ElemType        S              4
     D ElemName        S             30
     D MsgIdArr        S              7    DIM(25)
     D RtnCode         S              7
 
      * +-------------------+
      * ¦ Standalone fields ¦
      * +-------------------+
     D WPos            S              2  0 INZ(0)
     D WLen            S              2  0 INZ(0)
     D PathName        S                   LIKE(CGARGT)
     D GrpSetName      S              7    INZ(*BLANKS)
     D Idx1            S              2  0 INZ(0)
     D KyNWFD          S             50    INZ(*BLANKS)
 
      * +-----------------+
      * ¦ Named Constants ¦
      * +-----------------+
     D BackSlash       C                   '\'
     D BlankChar       C                   ' '
 
      * +------------------------------------+
      * ¦ Returns the Initial Group Set name ¦
      * +------------------------------------+
     DGetGrpSet        PR             7
     D  PathNm                             VALUE LIKE(CGARGT)
 
      /EJECT
      * +------------------------------------------------------------------+
      * ¦ Main Routine                                                     ¦
      * +------------------------------------------------------------------+
 
     C                   EVAL      Idx1 = 0
     C                   SELECT
 
      ** XML Element name to be validated is PATH.
 
     C                   WHEN      ElemType = 'PATH'
 
     C                   EXSR      CHKPATH
 
      ** XML Element name to be validated is SYGP.
 
     C                   WHEN      (ElemType = 'SYGP')
 
     C                   EXSR      CHKSYGP
 
      ** XML Element name to be validated is REFR and SYST.
 
     C                   WHEN      (ElemType = 'REFR') or
     C                             (ElemType = 'SYST')
 
     C                   EXSR      CHKOTHR
 
     C                   ENDSL
 
      **  Set on LR instead of return to close the files
      **  otherwise one logical file is not opened.
 
     C                   SETON                                        LR
 
      /EJECT
      * +------------------------------------------------------------------+
      * ¦ Subr/CHKPATH - Verify that XML Element Name for Path is unique   ¦
      * ¦                within its respective group set. It CAN exist in  ¦
      * ¦                other group sets.                                 ¦
      * +------------------------------------------------------------------+
     C     CHKPATH       BEGSR
 
      ** Retrieve Root Group Set name of Path to be verified.
     C                   EVAL      GrpSetName = GetGrpSet(ElemArgt)
 
      ** Calculate actual length of Group Set Name (i.e. number of
      ** characters it contains).
 
     C     BlankChar     CHECKR    GrpSetName    WLen
 
      ** Initialise key field with current Root Group Set name
      ** and RDE type (PATH).
 
     C                   EVAL      KYTYPE = 'PATH'
     C                   EVAL      KYARGT = GrpSetName
 
      ** Search RDE Conversion file for matching records.
 
     C     FileKey1      SETLL     CGRDECL0
     C                   READ      CGRDECL0
 
      ** Repeat search while not EOF and Root Group Set matches the
      ** the Argument(CGARGT). Also ensure that only matching records
      ** with RDE type = PATH needs to be read at this point (as same
      ** name can exist in other types of records as REFR, SYST and
      ** SYGP.
 
     C                   DOW       NOT %EOF
     C                             AND %SUBST(CGARGT:1:WLen) = GrpSetName
     C                             AND CGTYPE = 'PATH'
 
      ** If a match between XML Element Name and New Field (CGNWFD)
      ** is found, issue error message saying Element Name already
      ** exist for this Group Set and leave the loop processing.
 
     C                   IF        CGNWFD = ElemName
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx1 = Idx1 + 1
     C                   MOVEA     'CGD2556'     MsgIdArr(Idx1)
     C                   LEAVE
     C                   ENDIF
 
      ** Read the next record in file
     C                   READ      CGRDECL0
     C                   ENDDO
 
     C                   ENDSR
 
      /EJECT
      * +------------------------------------------------------------------+
      * ¦ Subr/CHKSYGP - Verify that XML Element Name for System Group     ¦
      * ¦                (SYGP) are unique across record types PATH,       ¦
      * ¦                REFR and SYST. However, it can occur more than    ¦
      * ¦                once within type SYGP.                            ¦
      * +------------------------------------------------------------------+
     C     CHKSYGP       BEGSR
 
      ** Initialise key field with XML Element Name and RDE type = PATH.
 
     C                   EVAL      KYTYPE = 'PATH'
     C                   EVAL      KYNWFD = ElemName
 
     C     FileKey2      CHAIN     CGRDECL1
     C                   IF        %FOUND
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx1 = Idx1 + 1
     C                   MOVEA     'CGD2558'     MsgIdArr(Idx1)
     C                   ELSE
 
      ** Initialise key field with RDE type = REFR.
 
     C                   EVAL      KYTYPE = 'REFR'
 
     C     FileKey2      CHAIN     CGRDECL1
     C                   IF        %FOUND
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx1 = Idx1 + 1
     C                   MOVEA     'CGD2560'     MsgIdArr(Idx1)
     C                   ELSE
 
      ** Initialise key field with RDE type = SYST.
 
     C                   EVAL      KYTYPE = 'SYST'
 
     C     FileKey2      CHAIN     CGRDECL1
     C                   IF        %FOUND
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx1 = Idx1 + 1
     C                   MOVEA     'CGD2559'     MsgIdArr(Idx1)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      * +------------------------------------------------------------------+
      * ¦ Subr/CHKOTHR - Verify that XML Element Name for Reference (REFR) ¦
      * ¦                and System Field (SYST) are unique ACROSS ALL     ¦
      * ¦                TYPES WITHIN THE FILE.                            ¦
      * +------------------------------------------------------------------+
     C     CHKOTHR       BEGSR
 
      ** Initialise key field with XML Element Name to be validated
 
     C                   EVAL      KyNWFD = ElemName
 
      ** Search file for matching records.
 
     C     KyNWFD        CHAIN     CGRDECL1
 
     C                   IF        %FOUND
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx1 = Idx1 + 1
     C                   MOVEA     'CGD2557'     MsgIdArr(Idx1)
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      * +------------------------------------------------------------------+
      * ¦ Subr/*INZSR - Initialisation subroutine                          ¦
      * +------------------------------------------------------------------+
     C     *INZSR        BEGSR
 
      *  Define parameter passed from calling program
 
     C     *ENTRY        PLIST
     C                   PARM                    ElemArgt
     C                   PARM                    ElemType
     C                   PARM                    ElemName
     C                   PARM                    MsgIdArr
     C                   PARM                    RtnCode
 
      * +--------------------------------------------+
      * ¦ Key lists for matching records in CGRDECPD ¦
      * +--------------------------------------------+
     C     FileKey1      KLIST
     C                   KFLD                    KYTYPE            4
     C                   KFLD                    KYARGT          111
 
     C     FileKey2      KLIST
     C                   KFLD                    KYNWFD           50
     C                   KFLD                    KYTYPE
     C                   ENDSR
 
      /EJECT
      * +--------------------------------------------------------------+
      * ¦ GetGrpSet - function that returns the Root Group Set Name of ¦
      * ¦             any Path Name.                                   ¦
      * +--------------------------------------------------------------+
     PGetGrpSet        B
     DGetGrpSet        PI             7
     D  PathName                           VALUE LIKE(CGARGT)
     D  GrpSetRoot     S              7
     D  WPos           S              3  0 INZ(0)
 
      ** Scan for position of 2nd occurrence of '\' within Path Name
 
     C                   EVAL      WPos = %SCAN(BackSlash:PathName:2)
 
      ** If WPos is *ZERO, the whole Path Name is Root Group Set Name.
 
     C                   IF        WPos = 0
     C                   EVAL      GrpSetRoot = PathName
     C                   ELSE
      *
      ** otherwise, retrieve portion of array containing Group Set Name.
      *
     C                   EVAL      GrpSetRoot = %SUBST(PathName:1:(WPos-1))
     C                   ENDIF
      *
     C                   RETURN    GrpSetRoot
     P                 E
