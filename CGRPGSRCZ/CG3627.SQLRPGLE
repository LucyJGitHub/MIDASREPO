     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD054955
/*STD *  RPGSQLMOD                                                    *                     MD054955
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD054955
/**** *  RPGCVTOPT2                                                   *              CSD053 MD054955
/*EXI *  TEXT('Midas CG UDC Correspondence Details Retrieval')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3627 - Midas CG Correspondence Details Retrieval           *
      *                                                               *
      *  Function:  This module will return details of the System RDEs*
      *             in an array in XML format                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD054955           Date 16Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD053             Date 07Jul06               *
      *                 CCG015  *CREATE    Date 23Jul01               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade.       *
      *         - Recompile due to SDCORMPD.                          *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     F*CGRASCL1* IF   E           K DISK                                                    MD054955
     F*CGRDECL0* IF   E           K DISK                                                    MD054955

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D System          C                   'SYSTEM'
     D SysType         C                   'SYST'
     D SysGType        C                   'SYGP'

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Relationship between the arrays:
      *
      ** SysRde is linked to SysDta.  This contains all the system RDE's and
      ** their corresponding data
      *
      ** SysRde2 is linked to SysDta2, SysConv and SysGrp.  This contains
      ** the system RDE's where the corresponding data is not blank, their
      ** converted element names and group name if it's in a group.

      **  Correspondence Manager ICD
     D Sdcorm        E DS                  EXTNAME(SDCORMPD)

      * Data Structure (long) used by Access Programs
     D Dsldy         E DS                  EXTNAME(DSLDY)

      * System RDE arrays
     D SysRde          S             22    DIM(200)
     D SysRde2         S             22    DIM(200)

      * System RDE data arrays
     D SysDta          S             65    DIM(200)
     D SysDta2         S             65    DIM(200)

      * System RDE converted name array
     D SysConv         S             30    DIM(200)

      * System RDE group name array
     D SysGrp          S             30    DIM(200)

      * Group name array
     D GrpNm           S             30    DIM(200)

      * Arrays needed for CG3997
     D ##R             S             22    DIM(20)
     D ##D             S            256    DIM(20)
     D ##S             S            256    DIM(20)

      * Output arrays
     D StrTag          S             33    DIM(200)
     D Value           S             65    DIM(200)
     D EndTag          S             33    DIM(200)
     D CGRASC        E DS                  EXTNAME(CGRASJW0)                                MD054955
     D CGRDEC        E DS                  EXTNAME(CGRDEJW0)                                MD054955
     D XSystem         S              6                                                     MD054955
     D XSysGType       S              4                                                     MD054955
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1

      * Parameters for AOCORMR0
     D Rtcd            S              7
     D Optn            S              7

      * Parameters for CG3997
     D Actn            S              8

      * Parameters for CG3602
     D TypeOfCnv       S                   LIKE(CGTYPE)
     D Argument        S                   LIKE(CGARGT)
     D NewFld          S                   LIKE(CGNWFD)
     D RtnCode         S             10

      * Array indices
      *
      * i is used in RTVEQNM
      * j is used in RTVEQNM and WRTOUTA where j=total number of converted
      * system RDEs
      * k and l are used in RTVSYSG
      * m,n,saven and p are used in WRTOUTA
      * x is used in RTVRDE and RTVEQNM where x=total number of system RDEs
      * w,y,z and savez are used in RTVRDE
      *
     D i               S              3  0
     D j               S              3  0
     D k               S              3  0
     D l               S              3  0
     D m               S              3  0
     D n               S              3  0
     D p               S              3  0
     D w               S              2  0
     D x               S              3  0
     D y               S              2  0
     D z               S              3  0
     D savez           S              3  0
     D saven           S              3  0

     D WRde            S             22

      * Procedures interfaces

      * Sort group name array
     D SortGrpAry      PR            30    DIM(200)
     D  GrpAry                       30    VALUE DIM(200)
     D  NoElm                         3  0 VALUE

      ** Formats tag
     DFormatTag        PR            33
     D  p1                           30    VALUE
     D  p2                            1  0 VALUE
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      * Initialise
     C                   EXSR      INIT

      * Retrieve System RDEs and data
     C                   EXSR      RTVRDE

      * Retrieve System RDE equivalent element name
     C                   EXSR      RTVEQNM

      * Retrieve System Group Names and their equivalent names
     C                   EXSR      RTVSYSG

      * Write into output arrays
     C                   EXSR      WRTOUTA

     C                   SETON                                        LR


      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RTVRDE - Retrieve System RDEs and data                        *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     RTVRDE        BEGSR

      * Read RDE association table and load system RDEs into an array

     C                   eval      XSystem = System                                         MD054955
     C*****System        SETLL     CGRASCL1                                                 MD054955
     C*****System        READE     CGRASCL1                                                 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare RCursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGRASJW0                                                              MD054955
     C+ where RAGRPS = :XSystem and RARECI = 'D'                                            MD054955
     C+ order by RAGRPS, RARDE                                                              MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open RCursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from RCursor into :CGRASC                                                MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955

     C                   EVAL      x=0

     C**********         DOW       NOT %EOF                                                 MD054955
     C                   DOW       SQLCODE = 0                                              MD054955
     C                   EVAL      x=x+1
     C                   MOVE      RARDE         SysRde(x)
     C*****System        READE     CGRASCL1                                                 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from RCursor into :CGRASC                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   ENDDO

      * Retrieve system RDE data (CG3997 retrieves 20 system RDE data
      * at one time) into array

     C                   EVAL      z=1

     C                   DOW       z<=x
     C                   EVAL      savez = z

     C                   DO        20            y
     C                   EVAL      ##R(y) = SysRde(z)
     C                   EVAL      z=z+1
     C                   ENDDO

     C                   CALL      'CG3997'
     C                   PARM      *BLANKS       Rtcd
     C                   PARM      *BLANKS       Actn
     C                   PARM                    ##R
     C                   PARM      *BLANKS       ##D
     C                   PARM      *BLANKS       ##S

     C                   DO        20            w
     C                   EVAL      SysDta(savez) = ##D(w)
     C                   EVAL      savez=savez+1
     C                   ENDDO

     C                   ENDDO

     C/EXEC SQL                                                                             MD054955
     C+ close RCursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * RTVEQNM - Retrieve System RDE equivalent element name         *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     RTVEQNM       BEGSR

      * Read all the system RDEs and their corresponding data, if the data
      * is not blank, retrieve equivalent element name by calling CG3602.
      * Write equivalent element name into array only if a conversion has
      * been defined in CGRDECPD

     C                   EVAL      j=0

     C                   DO        x             i

     C                   IF        SysDta(i) <> *BLANKS

     C                   EVAL      SysRde(i) = %TRIML(SysRde(i))

     C                   CALLB     'CG3602'
     C                   PARM      SysType       TypeOfCnv
     C                   PARM      SysRde(i)     Argument
     C                   PARM      *BLANKS       NewFld
     C                   PARM      *BLANKS       RtnCode

     C                   IF        RtnCode = *BLANKS
     C                   EVAL      j=j+1
     C                   EVAL      SysRde2(j) = SysRde(i)
     C                   EVAL      SysDta2(j) = SysDta(i)
     C                   EVAL      SysConv(j) = NewFld
     C                   ENDIF

     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * RTVSYSG - Retrieve System Group names  and their equivalent   *
      *           names                                               *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     RTVSYSG       BEGSR

      * Read all the system group names, if RDE belongs to a group, write
      * group name in the corresponding RDE group name array element

     C                   EVAL      l=0

     C                   eval      XSysGType = SysGType                                     MD054955
     C*****SysGType      SETLL     CGRDECL0                                                 MD054955
     C*****SysGType      READE     CGRDECL0                                                 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare SCursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGRDEJW0                                                              MD054955
     C+ where CGTYPE = :XSysGType                                                           MD054955
     C+ order by CGTYPE, CGARGT                                                             MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open SCursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from SCursor into :CGRDEC                                                MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955

     C**********         DOW       NOT %EOF                                                 MD054955
     C                   DOW       SQLCODE = 0                                              MD054955
     C                   EVAL      k=1
     C                   EVAL      WRde = CGARGT
     C     WRde          LOOKUP    SysRde2(k)                             01

     C                   IF        %EQUAL
     C                   EVAL      SysGrp(k) = CGNWFD
     C                   ENDIF

      * Save group name in a group name array
     C                   EVAL      l=l+1
     C                   EVAL      GrpNm(l) = CGNWFD

     C*****SysGType      READE     CGRDECL0                                                 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from SCursor into :CGRDEC                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   ENDDO

      * Sort group name array, so each entry is unique
     C                   EVAL      GrpNm=SortGrpAry(GrpNm:l)

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * WRTOUTA - Write into output arrays                            *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     WRTOUTA       BEGSR

      * Write start root tag
     C                   EVAL      m=1
     C                   EVAL      StrTag(m)=FormatTag(CMELCF:0)

      * Write element name tags which are not in a group firstly

     C                   EVAL      saven=0

     C                   DOW       saven<j
     C                   EVAL      saven=saven+1
     C                   EVAL      n=saven
     C     *BLANKS       LOOKUP    SysGrp(n)                              02

     C                   IF        %EQUAL AND n<=j
     C                   EVAL      saven=n
     C                   EVAL      m=m+1
     C                   EVAL      StrTag(m)=FormatTag(SysConv(n):0)
     C                   EVAL      Value(m)=SysDta2(n)
     C                   EVAL      EndTag(m)=FormatTag(SysConv(n):1)
     C                   ENDIF

     C                   ENDDO

      * Write group name tags and their corresponding element name tags

     C                   EVAL      p=1

     C                   DOW       GrpNm(p) <> *BLANKS

      * Write start of Group tag

     C                   EVAL      m=m+1
     C                   EVAL      StrTag(m)=FormatTag(GrpNm(p):0)
     C                   EVAL      saven=0

      * Write corresponding element name tags
     C                   DOW       saven<j
     C                   EVAL      saven=saven+1
     C                   EVAL      n=saven
     C     GrpNm(p)      LOOKUP    SysGrp(n)                              03

     C                   IF        %EQUAL AND n<=j
     C                   EVAL      saven=n
     C                   EVAL      m=m+1
     C                   EVAL      StrTag(m)=FormatTag(SysConv(n):0)
     C                   EVAL      Value(m)=SysDta2(n)
     C                   EVAL      EndTag(m)=FormatTag(SysConv(n):1)
     C                   ENDIF

     C                   ENDDO

      * Write end of Group tag
     C                   EVAL      m=m+1
     C                   EVAL      StrTag(m)=FormatTag(GrpNm(p):1)
     C                   EVAL      p=p+1
     C                   ENDDO

      * Write end root tag
     C                   EVAL      m=m+1
     C                   EVAL      StrTag(m)=FormatTag(CMELCF:1)

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * INIT   - Initialisation                                       *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR

      ** Retrieve Correspondence Manager ICD

     C                   CALLB(E)  'AOCORMR0'
     C                   PARM      *BLANKS       Rtcd
     C                   PARM      '*FIRST '     Optn
     C     Sdcorm        PARM      *BLANKS       Dsldy

     C                   IF        %ERROR OR Rtcd <> *BLANK
     C                             OR CMELCF = *BLANKS
     C                   EVAL      DBFILE =  'SDCORMPD'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF

      * Clear arrays
     C                   CLEAR                   SysRde
     C                   CLEAR                   SysDta
     C                   CLEAR                   SysRde2
     C                   CLEAR                   SysDta2
     C                   CLEAR                   SysConv
     C                   CLEAR                   SysGrp
     C                   CLEAR                   GrpNm
     C                   CLEAR                   StrTag
     C                   CLEAR                   Value
     C                   CLEAR                   Endtag
     C                   CLEAR                   ##R
     C                   CLEAR                   ##D
     C                   CLEAR                   ##S

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *entry        PLIST
     C                   PARM                    Rtcd
     C                   PARM                    StrTag
     C                   PARM                    Value
     C                   PARM                    EndTag

     C                   ENDSR

      *****************************************************************

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

     C                   DUMP

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SortGrpAry - Sorts group name array                           *
      *                                                               *
      *****************************************************************
     PSortGrpAry       B

     D SortGrpAry      PI            30    DIM(200)
     D  GrpAry                       30    VALUE DIM(200)
     D  NumElm                        3  0 VALUE

     D GrpAry2         S             30    DIM(200)
     D a               S              3  0
     D b               S              3  0
     D SavElm          S             30

     C                   CLEAR                   GrpAry2
     C                   EVAL      SavElm = *BLANKS
     C                   SORTA     GrpAry
     C                   EVAL      a=201-NumElm
     C                   EVAL      b=1
     C                   DOW       a<=200

     C                   IF        GrpAry(a) <> SavElm
     C                   EVAL      GrpAry2(b) = GrpAry(a)
     C                   EVAL      SavElm = GrpAry(a)
     C                   EVAL      b=b+1
     C                   ENDIF

     C                   EVAL      a=a+1
     C                   ENDDO

     C                   RETURN    GrpAry2
     P                 E
      /EJECT
      *****************************************************************
      *                                                               *
      * FormatTag - Formats tag                                       *
      * EndTag = 0 xxxxx => <xxxxx>                                   *
      * EndTag = 1 xxxxx => </xxxxx>                                  *
      *                                                               *
      *****************************************************************
     PFormatTag        B
     DFormatTag        PI            33
     D  TagName                      30    VALUE
     D  EndTag                        1  0 VALUE

     DTag              S             33

     C                   IF        EndTag = 1
     C                   EVAL      Tag = '</' + %TRIM(TagName) + '>'
     C                   ELSE
     C                   EVAL      Tag = '<' + %TRIM(TagName) + '>'
     C                   ENDIF

     C                   RETURN    Tag
     P                 E
      ********************************************************************
