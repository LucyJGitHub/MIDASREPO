     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA CG UDC names conversion')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  ZA3602 - UDC names conversion                                *
      *                                                               *
      *  Function:  This module converts a UDC name to a new value    *
      *  It uses a conversion file.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSE040  *CREATE    Date 18Nov03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE040 - Securities Statements                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** IMPORTANT
      ** ---------
      ** This file has to be opened manually because for some unknown
      ** reasons a CLRPFM of another file makes this file disappears
      ** from the job list of opened files; this triggers a
      ** internal failure.
     FCGRDECL0  IF   E           K DISK    USROPN
      *
      /EJECT
      *
      ** Global fields definition
      *
     DArgtName         S                   LIKE(CGARGT)
     DArgtType         S                   LIKE(CGTYPE)
     DReturnCode       S             10
      *
      ** Returns converted PATH Name
      *
     DConvPath         PR            50
     D  PathName                           VALUE LIKE(CGARGT)
      *
      ** Returns converted SYSTEM Name
      *
     DConvSyst         PR            50
     D  SystName                           VALUE LIKE(CGARGT)
     D  SystType                           VALUE LIKE(CGTYPE)
      *
      ** Returns converted REFERENCE Name
      *
     DConvRefr         PR            50
     D  RefrName                           VALUE LIKE(CGARGT)
     D  RefrType                           VALUE LIKE(CGTYPE)
      *
      ** Returns converted SYSTEM GROUP Name
      *
     DConvSygp         PR            50
     D  SygpName                           VALUE LIKE(CGARGT)
     D  SygpType                           VALUE LIKE(CGTYPE)
      *
      ** Returns the Initial Group Set name
      *
     DInitGrpSet       PR             7
     D  PathNm                             VALUE LIKE(CGARGT)
      *
      ** Converts RDE Field name
      *
     DSizeOf           PR             3  0
     D  NewF                        161    VALUE DIM(500)
      *
      ** Returns all RDEs linked to a Root Group Set
      *
     DSetOfRDE         PR           161    DIM(500)
     D  InitGrp                       7    VALUE
      *
      ** Returns all RDEs linked to a Reference
      *
     DSetOfRef         PR           161    DIM(500)
     D  RefrName                           VALUE LIKE(CGARGT)
     D  RefrType                           VALUE LIKE(CGTYPE)
      *
      ** Returns all RDEs linked to a Reference
      *
     DSetOfSys         PR           161    DIM(500)
     D  SystName                           VALUE LIKE(CGARGT)
     D  SystType                           VALUE LIKE(CGTYPE)
      *
      ** Returns all RDEs linked to a System Group
      *
     DSetOfSyg         PR           161    DIM(500)
     D  SygpName                           VALUE LIKE(CGARGT)
     D  SygpType                           VALUE LIKE(CGTYPE)
      *
      ** Converts RDE field
      *
     DConvRDE          PR                  LIKE(CGNWFD)
     D  NewF                        161    VALUE DIM(500)
     D  ArrSize                       3  0 VALUE
     D  PathNm                             VALUE LIKE(CGARGT)
      *
      ** Search RDE field
      *
     DSearch           PR             3  0
     D  NewF                        161    VALUE DIM(500)
     D  BegArr                        3  0 VALUE
     D  EndArr                        3  0 VALUE
     D  PathNm                             VALUE LIKE(CGARGT)
      *
      /EJECT
      **********************************************************************
      * Main Routine                                                       *
      **********************************************************************
      *
     C                   SELECT
      *
      ** If Argument Name passed is *blank or Argument Type is invalid,
      ** return error code to calling program.
      *
     C                   WHEN      ArgtName = *BLANK or
     C                             ArgtType <> 'PATH' and
     C                             ArgtType <> 'REFR' and
     C                             ArgtType <> 'SYST' and
     C                             ArgtType <> 'SYGP'
     C                   EVAL      ReturnCode = '*ERROR'
      *
      ** Convert UDC PATH name
     C                   WHEN      ArgtType = 'PATH'
     C                   EVAL      NewField = ConvPath(ArgtName)
      *
      ** Convert UDC SYST name
     C                   WHEN      ArgtType = 'SYST'
     C                   EVAL      NewField = ConvSyst(ArgtName:ArgtType)
      *
      ** Convert UDC REFR name
     C                   WHEN      ArgtType = 'REFR'
     C                   EVAL      NewField = ConvRefr(ArgtName:ArgtType)
      *
      ** Convert UDC SYGP name
     C                   WHEN      ArgtType = 'SYGP'
     C                   EVAL      NewField = ConvSygp(ArgtName:ArgtType)
      *
     C                   ENDSL
      *
     C                   RETURN
      /EJECT
      **********************************************************************
      * Initialisation Subroutine                                          *
      **********************************************************************
      *
     C     *INZSR        BEGSR
     C     *LIKE         DEFINE    CGNWFD        NewField
      *
      *--------------------------------------------------------------------*
      ** NOTES ON PARAMETER LIST:                                          *
      **------------------------                                           *
      ** PathName - RDE to be converted appearing in UDC structure as      *
      **            '\groupset1\anothergroupset\A_RDE_NAME).               *
      ** PathType - Type of RDE to be processed                            *
      **            (e.g. PATH, REFR, SYST or SYSG).                       *
      ** NewField - Output fld containing the converted RDEName            *
      ** ReturnCode - Flag to indicate if RDE has been converted or not.   *
      *                                                                    *
      * This program will not crash if the RDE conversion has not been     *
      * successful. The calling program should be able to handle the       *
      * *ERROR return code.                                                *
      *--------------------------------------------------------------------*
      *
     C     *ENTRY        PLIST
     C                   PARM                    ArgtType
     C                   PARM                    ArgtName
     C                   PARM                    NewField
     C                   PARM                    ReturnCode       10
      *
     C                   ENDSR
      /EJECT
      **********************************************************************
      * ConvPath - returns the converted XML Element Name of the           *
      *            RDE path.                                               *
      **********************************************************************
     PConvPath         B
     DConvPath         PI            50
     DPathName                             VALUE LIKE(CGARGT)
      *
     DNewFields        S            161    DIM(500) STATIC
     DRootGroup        S              7
     DPrevRoot         S              7    STATIC
     DSz               S              3  0 STATIC
      *
      ** Get the initial group set name.
      *
     C                   EVAL      RootGroup = InitGrpSet(PathName)
      *
      ** Store the conversion entries for initial group set.
      ** Compare if current Root Group being processed is equal to
      ** to previous: a) if equal, do not rebuild array data
      **              b) if different, rebuild array with data for
      **                 current Root Group
      *
     C                   IF        PrevRoot <> RootGroup
     C                   EVAL      PrevRoot = RootGroup
     C                   EVAL      NewFields = SetOfRDE(RootGroup)
     C                   EVAL      Sz = SizeOf(NewFields)
     C                   ENDIF
      *
      ** Convert the UDC path into XML Element Name
      *
     C                   EVAL      NewField = ConvRDE(NewFields:Sz:PathName)
      *
      ** If converted field is blank, issue ERROR return code
      *
     C                   IF        NewField = *BLANK
     C                   EVAL      ReturnCode = '*ERROR'
     C                   ENDIF
      *
     C                   RETURN    NewField
     P                 E
      /EJECT
      **********************************************************************
      * ConvSyst - returns the converted XML Element Name of the           *
      *            UDC System RDE fields.                                  *
      **********************************************************************
     PConvSyst         B
     DConvSyst         PI            50
     DSystName                             VALUE LIKE(CGARGT)
     DSystType                             VALUE LIKE(CGTYPE)
      *
     DNewFields        S            161    DIM(500) STATIC
     DSz               S              3  0 STATIC
     DSysArrFlg        S              1    STATIC
      *
      ** Store the conversion entries for RDE System Fields.
      ** Compare if System RDE array has already been built
      ** (i.e. SysArrFlg = 'Y'). If so, DO NOT rebuild array.
      *
     C                   IF        SysArrFlg <> 'Y'
     C                   EVAL      SysArrFlg = 'Y'
     C                   EVAL      NewFields = SetOfSys(SystName:SystType)
     C                   EVAL      Sz = SizeOf(NewFields)
     C                   ENDIF
      *
      ** Convert the UDC System Fields into equivalent XML Element Name
      *
     C                   EVAL      NewField = ConvRDE(NewFields:Sz:SystName)
      *
      ** If converted field is blank, issue ERROR return code
      *
     C                   IF        NewField = *BLANK
     C                   EVAL      ReturnCode = '*ERROR'
     C                   ENDIF
      *
     C                   RETURN    NewField
     P                 E
      /EJECT
      **********************************************************************
      * ConvRefr - returns the converted XML Element Name of the           *
      *            RDE reference.                                          *
      **********************************************************************
     PConvRefr         B
     DConvRefr         PI            50
     DRefrName                             VALUE LIKE(CGARGT)
     DRefrType                             VALUE LIKE(CGTYPE)
      *
     DNewFields        S            161    DIM(500) STATIC
     DSz               S              3  0 STATIC
     DRefArrFlg        S              1    STATIC
      *
      ** Store the conversion entries for RDE References.
      ** Compare if Reference array has already been built
      ** (i.e. RefArrFlg = 'Y'). If so, do not rebuild array.
      *
     C                   IF        RefArrFlg <> 'Y'
     C                   EVAL      RefArrFlg = 'Y'
     C                   EVAL      NewFields = SetOfRef(RefrName:RefrType)
     C                   EVAL      Sz = SizeOf(NewFields)
     C                   ENDIF
      *
      ** Convert the UDC Reference into XML Element Name
      *
     C                   EVAL      NewField = ConvRDE(NewFields:Sz:RefrName)
      *
      ** If converted field is blank, issue ERROR return code
      *
     C                   IF        NewField = *BLANK
     C                   EVAL      ReturnCode = '*ERROR'
     C                   ENDIF
      *
     C                   RETURN    NewField
     P                 E
      /EJECT
      **********************************************************************
      * ConvSygp - returns the converted XML Element Name of the           *
      *            RDE System Group name.                                  *
      **********************************************************************
     PConvSygp         B
     DConvSygp         PI            50
     DSygpName                             VALUE LIKE(CGARGT)
     DSygpType                             VALUE LIKE(CGTYPE)
      *
     DNewFields        S            161    DIM(500) STATIC
     DSz               S              3  0 STATIC
     DSygArrFlg        S              1    STATIC
      *
      ** Store the conversion entries for RDE System Group names.
      ** Compare if System Group array has already been built
      ** (i.e. SygArrFlg = 'Y'). If so, do not rebuild array.
      *
     C                   IF        SygArrFlg <> 'Y'
     C                   EVAL      SygArrFlg = 'Y'
     C                   EVAL      NewFields = SetOfSyg(SygpName:SygpType)
     C                   EVAL      Sz = SizeOf(NewFields)
     C                   ENDIF
      *
      ** Convert the UDC System Group Name into XML Element Name
      *
     C                   EVAL      NewField = ConvRDE(NewFields:Sz:SygpName)
      *
      ** If converted field is blank, issue ERROR return code
      *
     C                   IF        NewField = *BLANK
     C                   EVAL      ReturnCode = '*ERROR'
     C                   ENDIF
      *
     C                   RETURN    NewField
     P                 E
      /EJECT
      **********************************************************************
      * InitGrpSet - function that returns the Initial Group Set Name *
      **********************************************************************
     PInitGrpSet       B
     DInitGrpSet       PI             7
     D  PathName                           VALUE LIKE(CGARGT)
     D  GrpSetRoot     S              7
     D  lenext         S              3  0 INZ(0)
      *
      ** Scan for position of 2nd occurrence of '\' within Path Name
      *
     C                   EVAL      lenext = %SCAN('\':PathName:2)
      *
      ** If index is *ZERO, the whole Path Name is the Root Group
      ** Set Name itself.
      *
     C                   IF        lenext = 0
     C                   EVAL      GrpSetRoot = PathName
     C                   ELSE
      *
      ** otherwise, retrieve portion of array containing Group Set Name.
      *
     C                   EVAL      GrpSetRoot = %SUBST(PathName:1:lenext-1)
     C                   ENDIF
      *
     C                   RETURN    GrpSetRoot
     P                 E
      /EJECT
      **********************************************************************
      * SizeOf - Function to calculate the actual number of elements       *
      *          witn non-blank.                                           *
      **********************************************************************
     PSizeOf           B
     DSizeOf           PI             3  0
     D  NewF                        161    VALUE DIM(500)
      *
     Di                S              3  0 INZ(0)
      *
      ** Get total number of array elements with NON-BLANK (i.e. Path)
      ** entries (NOTE: %ELEM returns total number of elements within
      ** array NewF).
      *
     C                   DOW       i <= %ELEM(NewF) - 1
     C                             AND NewF(i+1) <> *BLANK
     C                   EVAL      i = i + 1
     C                   ENDDO
      *
     C                   RETURN    i
     P                 E
      /EJECT
      **********************************************************************
      * Search - function to do perform a Binary search (it uses
      *          a recursion).
      **********************************************************************
     PSearch           B
     DSearch           PI             3  0
      *
     D  NewF                        161    VALUE DIM(500)
     D  BegArr                        3  0 VALUE
     D  EndArr                        3  0 VALUE
     D  PathName                           VALUE LIKE(CGARGT)
      *
     Di                S              3  0 INZ(0)
     Dm                S              3  0 INZ(0)
      *
     DEntOfVar         DS
     D  RdePath                     111
     D  NewField                     50
      *
      ** Ensure that BegArr is less than or equal to EndArr.
      *
     C                   IF        BegArr <= EndArr
      *
      ** Retrieve the middle part of the array and process from there.
      *
     C                   EVAL      m = (BegArr + EndArr) / 2
     C                   EVAL      EntOfVar = NewF(m)
      *
     C                   SELECT
      *
      ** If PathName is equal to RdePath, it means that a match is
      ** already found.
      *
     C                   WHEN      PathName = RdePath
     C                   EVAL      i = m
      *
      ** If PathName is 'greater than' RdePath, do the search from
      ** the 'right half' of the array.
      *
     C                   WHEN      PathName > RdePath
     C                   EVAL      i = Search(NewF:m+1:EndArr:PathName)
      *
      ** If PathName is 'greater than' RdePath, do the search from
      ** the 'left half' of the array.
      *
     C                   WHEN      PathName < RdePath
     C                   EVAL      i = Search(NewF:BegArr:m-1:PathName)
     C                   ENDSL
      *
     C                   ENDIF
      *
      ** Return the index of the matching Element Name found.
      *
     C                   RETURN    i
     P                 E
      /EJECT
      **********************************************************************
      * ConvRDE - Converts the UDC Name into its equivalent XML Element    *
      *           Name. (This function is run by several functions)        *
      **********************************************************************
     PConvRDE          B
     DConvRDE          PI                  LIKE(CGNWFD)
     D  NewF                        161    VALUE DIM(500)
     D  ArrSize                       3  0 VALUE
     D  PathName                           VALUE LIKE(CGARGT)
      *
     DConvValue        S                   LIKE(CGNWFD)
     Di                S              3  0
      *
     DEntOfVar         DS
     D  RdePath                     111
     D  NewField                     50
      *
      ** Call SEARCH function to locate equivalent XML name for argument.
      *
     C                   EVAL      i = Search(NewF:1:ArrSize:PathName)
      *
      ** Check that index is not zero.
      *
     C                   IF        i <> 0
      *
      ** Load data structure EntOfVar with matching element from
      ** work array NewF.
      *
     C                   EVAL      EntOfVar = NewF(i)
      *
      ** Retrieve the XML Element name (i.e. NewField) from the
      ** data structure.
      *
     C                   EVAL      ConvValue = NewField
      *
     C                   ENDIF
      *
     C                   RETURN    ConvValue
      *
     P                 E
      /EJECT
      ********************************************************************  **
      * SetOfRde - Returns all RDEs linked to a Root Group Set           *
      ********************************************************************  **
     PSetOfRDE         B
     DSetOfRDE         PI           161    DIM(500)
     D  GrpSetRoot                    7    VALUE
      *
     DSetOfVar         S            161    DIM(500)
     DEntOfVar         DS
     D  RdePath                     111
     D  NewField                     50
     Di                S              3  0 INZ(0)
     Dlenpth           S              3  0 INZ(0)
      *
      ** Key list for matching records in CGRDECPD
      *
     C     ConvKey       KLIST
     C                   KFLD                    CGTYPE
     C                   KFLD                    CGARGT
      *
      ** Retrieve the actual length of Root Group Set (i.e. no. of chars)
      *
     C     ' '           CHECKR    GrpSetRoot    lenpth
      *
      ** Initialise key field with current Root Group Set name
      ** and RDE type (PATH).
      *
     C                   EVAL      CGTYPE = 'PATH'
     C                   EVAL      CGARGT = GrpSetRoot
      *
      ** Search RDE Conversion file for matching records.
      *
     C                   OPEN      CGRDECL0
     C     ConvKey       SETLL     CGRDECL0
     C                   READ      CGRDECL0
      *
      ** Repeat search while not EOF and Root Group Set match
      ** with argument. Also ensure that only matching records
      ** with RDE type = PATH is retrieved.
      *
     C                   DOW       NOT %EOF
     C                             AND %SUBST(CGARGT:1:lenpth) = GrpSetRoot
     C                             AND CGTYPE = 'PATH'
      *
      ** If match is found, load record (CGARGT + CGNWFD) to a
      ** work data structure EntOfVar (via RdePath + NewField).
      *
     C                   EVAL      RdePath = *BLANK
     C                   EVAL      i = i + 1
     C                   EVAL      RdePath = CGARGT
     C                   EVAL      NewField = CGNWFD
      *
      ** Copy data structure to work array SetOfVar.
      *
     C                   EVAL      SetOfVar(i) = EntOfVar
      *
      ** Read the next record.
      *
     C                   READ      CGRDECL0
     C                   ENDDO
     C                   CLOSE     CGRDECL0
     C
     C                   RETURN    SetOfVar
     P                 E
      /EJECT
      ********************************************************************  **
      * SetOfRef - Returns array with all *REFR fields from PF/CGRDECPD  *
      ********************************************************************  **
     PSetOfRef         B
     DSetOfRef         PI           161    DIM(500)
     DRefrName                             VALUE LIKE(CGARGT)
     DRefrType                             VALUE LIKE(CGTYPE)
      *
     DSetOfRef         S            161    DIM(500)
     DEntOfRef         DS
     D  RdeRefr                     111
     D  NewField                     50
     Di                S              3  0 INZ(0)
      *
      ** Initialise key field
      *
     C                   EVAL      CGTYPE = RefrType
      *
      ** Read all CGRDECPD records with type = REFR and store them
      ** into array SetofRef.
      *
     C                   OPEN      CGRDECL0
     C     CGTYPE        SETLL     CGRDECL0
     C     CGTYPE        READE     CGRDECL0
      *
     C                   DOW       NOT %EOF
      *
      ** Initialise data structure fields
      *
     C                   EVAL      RdeRefr = *BLANK
     C                   EVAL      NewField = *BLANK
      *
      ** Load data structure with REFR type data
      *
     C                   EVAL      RdeRefr = CGARGT
     C                   EVAL      NewField = CGNWFD
      *
      ** Load data into array
      *
     C                   EVAL      i = i + 1
     C                   EVAL      SetOfRef(i) = EntOfRef
     C     CGTYPE        READE     CGRDECL0
     C                   ENDDO
 
     C                   CLOSE     CGRDECL0
 
     C                   RETURN    SetOfRef
     P                 E
      /EJECT
      ********************************************************************  **
      * SetOfSys - Returns array with all *SYST fields from PF/CGRDECPD  *
      ********************************************************************  **
     PSetOfSys         B
     DSetOfSys         PI           161    DIM(500)
     DSystName                             VALUE LIKE(CGARGT)
     DSystType                             VALUE LIKE(CGTYPE)
      *
     DSetOfSys         S            161    DIM(500)
     DEntOfSys         DS
     D  RdeRefr                     111
     D  NewField                     50
     Di                S              3  0 INZ(0)
      *
      ** Initialise key field
      *
     C                   EVAL      CGTYPE = SystType
      *
      ** Read all CGRDECPD records with type = SYST and store them
      ** into array SetofSys.
      *
     C                   OPEN      CGRDECL0
     C     CGTYPE        SETLL     CGRDECL0
     C     CGTYPE        READE     CGRDECL0
      *
     C                   DOW       NOT %EOF
      *
      ** Initialise data structure fields
      *
     C                   EVAL      RdeRefr = *BLANK
     C                   EVAL      NewField = *BLANK
      *
      ** Load data structure with SYST type data
      *
     C                   EVAL      RdeRefr = CGARGT
     C                   EVAL      NewField = CGNWFD
      *
      ** Load data into array
      *
     C                   EVAL      i = i + 1
     C                   EVAL      SetOfSys(i) = EntOfSys
     C     CGTYPE        READE     CGRDECL0
     C                   ENDDO
     C
     C                   CLOSE     CGRDECL0
     C                   RETURN    SetOfSys
     P                 E
      /EJECT
      ********************************************************************  **
      * SetOfSyg - Returns array with all *SYGP fields from PF/CGRDECPD  *
      ********************************************************************  **
     PSetOfSyg         B
     DSetOfSyg         PI           161    DIM(500)
     DSygpName                             VALUE LIKE(CGARGT)
     DSygpType                             VALUE LIKE(CGTYPE)
      *
     DSetOfSyg         S            161    DIM(500)
     DEntOfSyg         DS
     D  RdeRefr                     111
     D  NewField                     50
     Di                S              3  0 INZ(0)
      *
      ** Initialise key field
      *
     C                   EVAL      CGTYPE = SygpType
      *
      ** Read all CGRDECPD records with type = SYGP and store them
      ** into array SetofSyg.
      *
     C                   OPEN      CGRDECL0
     C     CGTYPE        SETLL     CGRDECL0
     C     CGTYPE        READE     CGRDECL0
      *
     C                   DOW       NOT %EOF
      *
      ** Initialise data structure fields
      *
     C                   EVAL      RdeRefr = *BLANK
     C                   EVAL      NewField = *BLANK
      *
      ** Load data structure with SYST type data
      *
     C                   EVAL      RdeRefr = CGARGT
     C                   EVAL      NewField = CGNWFD
      *
      ** Load data into array
      *
     C                   EVAL      i = i + 1
     C                   EVAL      SetOfSyg(i) = EntOfSyg
     C     CGTYPE        READE     CGRDECL0
     C                   ENDDO
     C
     C                   CLOSE     CGRDECL0
 
     C                   RETURN    SetOfSyg
     P                 E
