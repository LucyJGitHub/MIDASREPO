     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU rebuild correct order Global')           *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000080 - This program generates script for LF rebuild      *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD060960             Date 16Jan23             *
      *  Prev Amend No. CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060960 - Some dependents do not exist yet as their         *
      *             CRTDUPOBJ has not been executed yet. Fix is to    *
      *             rebuild the order.                                *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     D RcdCount        S              5  0

      * Array to store Cross Reference Dependency<>Dependent
     D ArrXRf          S             40    DIM(9999)

      * Array to store Dependency
     D ArrDcy          S             20    DIM(9999)

      * Array to store Dependent
     D ArrDpt          S             20    DIM(9999)

      * DS for PF
     D                 DS
     D  DSXRF                  1     40
     D  DSDCY                  1     20
     D  DSDCYF                 1     10
     D  DSDCYL                11     20
     D  DSDPT                 21     40
     D  DSDPTF                21     30
     D  DSDPTL                31     40

     D SavFile         S             10A
     D SavLib          S             10A
     D Add_DR          S              1A
     D Write_Scr       S              1A
     D*SCCMD           S          32000A
     D IxX             S              5  0
     D n               S              5  0
     D CX              S              5  0
     D WIdx            S              5  0
     D #SEQ            S             15  5
     D ##MNLIB         S             10A
     D S##MNLIB        S             10A
     D ERROR           S             10A
     D RETURN          S             10A
     D UPDTBL          S             10A
     D UPDFLD          S             10A
     D UPDVAL          S            100A
     D UPDACT          S             10A
     D SQLDynStmt      S           5000A
     D TOLIB           S             10A
     D TOFILE          S             10A
     D OWNR            S             10A
     D AUTL            S             10A
     D UPGXRR        E DS                  EXTNAME(UPGXRRPD)
     D UPGSCR        E DS                  EXTNAME(UPGSCRTD)
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    Prefix            2
     C                   PARM                    RefSys            2
     C                   PARM                    System            1
     C                   PARM                    ERROR

     C                   If        System = 'P'
      * Read Ref System file
     C/exec SQL
     C+ declare CursorRdP cursor for
     C+ select *
     C+ from UPGXRFPD
     C+ order by PMLIB, PMFILE, PINCR
     C/end-exec

     C/exec SQL
     C+ open CursorRdP
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorRdP
     C+ into :UPGXRR
     C/end-exec
     C                   else
      * Read Ref System file
     C/exec SQL
     C+ declare CursorRdR cursor for
     C+ select *
     C+ from UPGXRRPD
     C+ order by PMLIB, PMFILE, PINCR
     C/end-exec

     C/exec SQL
     C+ open CursorRdR
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorRdR
     C+ into :UPGXRR
     C/end-exec
     C                   Endif

     C                   DOW       SQLCODE = 0

      ** If new file, clear arrays and DS
     C                   If        PMFILE <> SavFile

      ** If previous file not blank, output script
     C                   If        SavFile <> *BLANKS
     C                   exsr      SR_Script
     C                   ENDIF

     C                   eval      SavFile = PMFILE
     C                   eval      SavLib  = PMLIB
     C                   clear                   ArrDcy
     C                   clear                   ArrDpt
     C                   clear                   DSDCY
     C                   clear                   DSDPT
     C                   eval      IxX = 0

     C                   ENDIF


      ** Dependency
     C                   eval      DSDCYF = PFILE
     C                   eval      DSDCYL = PLIB
      ** Dependent
     C                   eval      DSDPTF = PDEPF
     C                   eval      DSDPTL = PLIBO

      ** Check entry does not exist yet
     C     DSXRF         LOOKUP    ArrXrf                                 02
     C                   IF        *IN02 = *OFF
     C                   eval      IxX = IxX + 1
     C                   eval      ArrDcy(IxX) = DSDCY
     C                   eval      ArrDpt(IxX) = DSDPT
     C                   eval      ArrXrf(IxX) = DSXRF
     C                   endif

     C                   If        System = 'P'
     C/exec SQL
     C+ fetch next
     C+ from CursorRdP
     C+ into :UPGXRR
     C/end-exec
     C                   else
     C/exec SQL
     C+ fetch next
     C+ from CursorRdR
     C+ into :UPGXRR
     C/end-exec
     C                   endif


     C                   ENDDO

      ** If previous file not blank, output script
     C                   If        SavFile <> *BLANKS
     C                   exsr      SR_Script
     C                   ENDIF


     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************

     C     SR_Script     Begsr

     C                   eval      #SEQ = 0

      * generating script for file deletion
      * the rule is: file cannot be deleted if file is a dependency
      * Process is to check the dependent array and validate that entry is not in
      * dependency array. If not in dependency array, file can be deleted and its
      * cross reference is removed.

     C                   eval      n = 0
     C     next          tag

     C                   eval      n = n + 1
     C                   eval      DSXRF = ArrXrf(n)
     C                   IF        DSXRF <> *BLANKS

      * if dependent found in dependency array
     C                   eval      WIdx = %LOOKUP(DSDPT : ArrDcy)
     C                   IF        WIdx > 0
     C                   goto      next
     C                   else
      * if not found, can be deleted
     C                   eval      CX = n
      * reset n
     C                   eval      n = 0
     C                   exsr      SR_Delete
     C                   ENDIF
     C                   goto      next

     C                   ENDIF

     C                   Endsr
      *****************************************************************
      /EJECT
      ********************************************************************
     C     SR_Delete     BEGSR

      * 2. remove from XRef array
     C                   Dow       CX <> 0

      * write in Order table
     C                   eval      #SEQ = #SEQ +1
     C                   eval      DSXRF = ArrXrf(CX)
     C
     C                   If        System = 'P'
     C/EXEC SQL
     C+ insert into UPGOPDTD
     C+ (
     C+   ORPRFX
     C+  ,ORMFIL
     C+  ,ORMLIB
     C+  ,ORSEQ
     C+  ,ORFILE
     C+  ,ORLIB
     C+  ,ORFLCY
     C+  ,ORLBCY
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:SavFile
     C+  ,:SavLib
     C+  ,:#SEQ
     C+  ,:DSDPTF
     C+  ,:DSDPTL
     C+  ,:DSDCYF
     C+  ,:DSDCYL
     C+ )
     C/END-EXEC

     C                   else
     C/EXEC SQL
     C+ insert into UPGORDTD
     C+ (
     C+   ORPRFX
     C+  ,ORMFIL
     C+  ,ORMLIB
     C+  ,ORSEQ
     C+  ,ORFILE
     C+  ,ORLIB
     C+  ,ORFLCY
     C+  ,ORLBCY
     C+  ,ORORDR                                                                            MD060960
     C+ )
     C+ Values
     C+ (
     C+   :RefSys
     C+  ,:SavFile
     C+  ,:SavLib
     C+  ,:#SEQ
     C+  ,:DSDPTF
     C+  ,:DSDPTL
     C+  ,:DSDCYF
     C+  ,:DSDCYL
     C+  ,0                                                                                 MD060960
     C+ )
     C/END-EXEC

     C                   endif
     C                   eval      %SUBARR(ArrXrf : CX) =
     C                             %SUBARR(ArrXrf : CX +1)

      * 3. remove from Dcy and Dpt array
     C                   eval      %SUBARR(ArrDcy : CX) =
     C                             %SUBARR(ArrDcy : CX +1)
     C                   eval      %SUBARR(ArrDpt : CX) =
     C                             %SUBARR(ArrDpt : CX +1)

      * look for the dependent
     C                   eval      CX = %LOOKUP(DSDPT : ArrDpt)
     C                   enddo

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR                                                  ** *PSSR SR **

     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      ERROR = '*Error'
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
