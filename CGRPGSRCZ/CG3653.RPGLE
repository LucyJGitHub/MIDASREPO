     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Create XML line for RDE')                     *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3653 - Midas CG Create XML line for RDE                    *
      *                                                               *
      *  Function:  This module writes XML lines for a set of UDC     *
      *  paths.                                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. CCG016  *CREATE    Date 13Sep16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CCG016 - Correspondence Manager for Retail Teller System     *
      *                                                               *
      *****************************************************************
      /EJECT
     FCGUXMRPD  O    E           K DISK    USROPN

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
      ** Named constants
     DPATH             C                   CONST('PATH')
     DREFERENCE        C                   CONST('REFR')

      ** Data structures
     DRDEcvt         E DS                  EXTNAME(CGRDECPD)

      ** Working Variables
     DSchemaName       S                   LIKE(DESHNM)
     DReferName        S             21
     DOldRefer         S                   LIKE(ReferName)
     Di                S              3  0
      *
     DWpos             S              2  0
      *
      ** Procedures interfaces
     DNewName          PR                  LIKE(CGNWFD)
     D p1                                  VALUE LIKE(CGTYPE)
     D p2                                  VALUE LIKE(CGARGT)

     C                   OPEN      CGUXMRPD
     C                   EVAL      ReturnCode = *BLANK
     C                   EVAL      DEITEM = Item
     C                   EVAL      DEINCR = increment

      ** If the Schema Name has been already retrieved for the
      ** Reference do not convert the Reference again.
      ** If no Schema Name has been defined the program aborts as
      ** the Schema Name identifies uniquely an Extraction template.
     C                   IF        ReferName <> OldRefer
     C                   EVAL      SchemaName = NewName(REFERENCE:ReferName)
     C                   IF        SchemaName = *BLANK
     C                             OR SchemaName = '*ERROR'
     C                   EVAL      DBFILE = 'ReferenceName'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = ReferName
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      OldRefer = ReferName
     C                   ENDIF
     C                   EVAL      DESHNM = SchemaName

      ** Retrieve the converted values of the paths (Group set + RDEs).
      ** Write each Element name details in the new Extraction file.
     C                   EVAL      i = 1
     C                   DOW       i <= %SIZE(##RN)
     C                             AND ReturnCode = *BLANK
     C                             AND ##RN(i) <> *BLANK
      ** Converts path structure into an tag value
     C                   EVAL      DENWRD = NewName(PATH:##RN(i))

     C                   IF        DENWRD = '*ERROR'
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBFILE = 'NewName'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = ##RN(i)
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        DENWRD <> *BLANK
      *
     C                   EVAL      WPOS = %SCAN('/IACC/D':##DN(i))
     C                   IF        WPOS > 0
     C                   EVAL      DERDEV = %SUBST(##DN(i):9)
     C                   ELSE
      *
     C                   EVAL      DERDEV = ##DN(i)
     C                   ENDIF
      *
     C                   EVAL      DEFMTY = ##FM(i)
     C                   WRITE(E)  CGUXMRD0
     C                   IF        %ERROR
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBFILE = 'CGUXMRPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = '*WRITE'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      i = i + 1
     C                   ENDDO

     C                   CLOSE     CGUXMRPD
     C                   RETURN
      **********************************************************************
      * INITIALISATION SUBROUTINE
      **********************************************************************
     C     *INZSR        BEGSR
     C     *LIKE         DEFINE    DEINCR        Increment

     C     *ENTRY        PLIST
      ** Extraction identification number
     C                   PARM                    Item              8 0
      ** Line number of the XML statement
     C                   PARM                    Increment
      ** Reference name (UDC Print Item type:UDC Print Item sub type)
     C                   PARM                    ReferName
      ** RDE names
     C                   PARM                    ##RN
      ** RDE data
     C                   PARM                    ##DN
      ** RDE formats
     C                   PARM                    ##FM
      ** Return code
      ** - *ERROR
     C                   PARM                    ReturnCode       10
      ** Commitment (not used)
      ** YES : commitment control
     C                   PARM                    W0CMT             3

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
