     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Create XML line for group set')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3654 - Midas CG Create XML line for Group Set              *
      *                                                               *
      *  Function:  This module writes XML lines for a set of UDC     *
      *  paths.                                                       *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CCG016  *CREATE    Date 13Sep16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG016 - Correspondence Manager for Retail Teller System.    *
      *                                                               *
      *****************************************************************
      /EJECT
     FCGUXMGPD  O    E           K DISK    USROPN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
     D/COPY CGCPYSRC,CGNWARD
 
      ** Data structures
     DRDEcvt         E DS                  EXTNAME(CGRDECPD)
 
      ** Named constants
     DPATH             C                   CONST('PATH')
     DREFERENCE        C                   CONST('REFR')
 
      ** Working variables
     DSchemaName       S                   LIKE(DGSHNM)
     DReferName        S             21
     DOldRefer         S                   LIKE(ReferName)
     DElementName      S                   LIKE(DGNWGS)
 
      ** Procedures interfaces
     DNewName          PR                  LIKE(CGNWFD)
     D p1                                  VALUE LIKE(CGTYPE)
     D p2                                  VALUE LIKE(CGARGT)
 
     C                   OPEN      CGUXMGPD
     C                   EVAL      ReturnCode = *BLANK
 
     C                   EXSR      ChkParam
      ** If the Schema Name has been already retrieved for the
      ** Reference do not convert the Reference again.
      ** If no Schema Name has been defined the program aborts as
      ** the Schema Name identifies uniquely an Extraction template.
     C                   IF        ReferName <> OldRefer
     C                   EVAL      SchemaName = NewName(REFERENCE:ReferName)
     C                   IF        SchemaName = *BLANK
     C                             OR SchemaName = '*ERROR'
     C                   EVAL      DBFILE = 'ReferenceName'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = ReferName
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      OldRefer = ReferName
     C                   ENDIF
 
     C                   SELECT
      ** If no conversion has been defined we assume it is deliberate
      ** therefore no XML line will be written.
      ** It is done in order to remove redundant UDC repeating group
      ** in XML sheet.
     C                   WHEN      ActCode = '*GRSPOP'
      ** Converts path structure into an tag value
     C                   EVAL      ElementName = NewName(PATH:PathName)
     C                   IF        ElementName = '*ERROR'
     C                   EVAL      DBFILE = 'NewName'
     C                   EVAL      DBASE = 5
     C                   EVAL      DBKEY = ElementName
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        ElementName <> *BLANK
     C                   EVAL      DGNWGS = '/' + ElementName
     C                   EVAL      DGINCR = increment
     C                   EXSR      WriteXMG
     C                   ENDIF
 
     C                   WHEN      ActCode = '*GRSPSH'
      ** Converts path structure into an tag value
     C                   EVAL      ElementName = NewName(PATH:PathName)
     C                   IF        ElementName = '*ERROR'
     C                   EVAL      DBFILE = 'NewName'
     C                   EVAL      DBASE = 5
     C                   EVAL      DBKEY = ElementName
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        ElementName <> *BLANK
     C                   EVAL      DGNWGS = ElementName
     C                   EVAL      DGINCR = increment
     C                   EXSR      WriteXMG
     C                   ENDIF
 
     C                   WHEN      ActCode = '*WRAP'
     C                   EVAL      DGNWGS = SchemaName
     C                   EVAL      DGINCR = increment
     C                   EXSR      WriteXMG
     C                   EVAL      DGNWGS = '/' + SchemaName
     C                   EVAL      DGINCR = *HIVAL
     C                   EXSR      WriteXMG
 
     C                   ENDSL
 
     C                   CLOSE     CGUXMGPD
     C                   RETURN
      **********************************************************************
      * INITIALISATION SUBROUTINE
      **********************************************************************
     C     *INZSR        BEGSR
     C     *LIKE         DEFINE    DGINCR        Increment
     C     *LIKE         DEFINE    CGARGT        PathName
 
     C     *ENTRY        PLIST
      ** Extraction identification number
     C                   PARM                    Item              8 0
      ** Line number of the XML statement
     C                   PARM                    Increment
      ** Reference name (UDC Print Item type:UDC Print Item sub type)
     C                   PARM                    ReferName
      ** Action Code
      ** - *GRSPSH write a 'beg' tag (a group set is pushed into the stack)
      ** - *GRSPOP write a 'end' tag (a group set is pop from the stack)
      ** - *WRAP write both a 'beg' and a 'end' tags
     C                   PARM                    ActCode          10
      ** UDC path name which does NOT contain a RDE
      ** e.g  \groupset1\anothergroupset\othergroupset
     C                   PARM                    PathName
      ** Return code
      ** - *ERROR
     C                   PARM                    ReturnCode       10
      ** Commitment (not used)
      ** YES : commitment control
     C                   PARM                    W0CMT             3
 
     C                   ENDSR
      **********************************************************************
      * Parameters checkings
      **********************************************************************
     C     ChkParam      BEGSR
 
      ** Ensure that action code is correct
     C                   IF        ActCode <> '*GRSPSH'
     C                             AND ActCode <> '*GRSPOP'
     C                             AND ActCode <> '*WRAP'
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBFILE = '*ACTION'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = ActCode
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** When wrapping a new extraction the extraction
      ** line must be 1.
     C                   IF        ActCode = '*WRAP'
     C                             AND increment <> 1
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBFILE = '*WRAP'
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      * Write a record in the explored Group Set
      **********************************************************************
     C     WriteXMG      BEGSR
     C                   EVAL      DGSHNM = SchemaName
     C                   EVAL      DGITEM = Item
 
     C                   WRITE(E)  CGUXMGD0
     C                   IF        %ERROR
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBFILE = 'CGUXMGPD'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = '*WRITE'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      **********************************************************************
      * Returns the new name
      **********************************************************************
     PNewName          B
     DNewName          PI                  LIKE(CGNWFD)
     D  TypeOfCnv                          VALUE LIKE(CGTYPE)
     D  Argument                           VALUE LIKE(CGARGT)
 
     DNewFld           S                   LIKE(CGNWFD)
 
     C                   IF        Argument <> *BLANK
     C                             AND TypeOfCnv <> *BLANK
     C                   CALLB     'CG3602'
     C                   PARM                    TypeOfCnv
     C                   PARM                    Argument
     C                   PARM                    NewFld
     C                   PARM                    ReturnCode       10
     C                   ELSE
     C                   EVAL      NewFld = '*ERROR'
     C                   ENDIF
 
     C                   RETURN    NewFld
     P                 E
