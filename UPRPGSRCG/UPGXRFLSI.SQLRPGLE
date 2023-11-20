     H DEBUG ALWNULL(*USRCTL)
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - list dependent files of IGNORE PF')         *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UPGXRFLSI - This program update the work file for the         *
      *             ADBU update monitor (Global).                     *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD061992             Date 23Oct23             *
      *  Prev Amend No. CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061992 - Allow 3 char prefix for reference libraries       *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************
      *
     FUPGXRIPD  O  A E             DISK

     D FILELIB         S             20    DIM(999)
      * Data structure for DSPDBR array.
     D FILEA           S             10    DIM(9999)
     D                 DS
     D  FILELIBArray           1     20
     D  ArrayFILE              1     10
     D  ArrayLIB              11     20

     D                 DS
     D  FILELIBArayLU          1     20
     D  ArrayFILELU            1     10
     D  ArrayLIBLU            11     20

     D OriginLib       S             10A
     D LIB2            S             10A
     D LIBM            S             10A
     D File            S             10A
     D @DBFFIL         S             10A
     D @DBFLIB         S             10A
     D @DBFFDP         S             10A
     D @DBFLDP         S             10A
     D @DBFFDP2        S             10A
     D @DBFLDP2        S             10A
     D @DBFFIL2        S             10A
     D @DBFLIB2        S             10A
     D @DBFTDP2        S             10A
     D @DBFFDP3        S             10A
     D @DBFLDP3        S             10A
     D @DBFTDP3        S              1A
     D @DBFFDP4        S             10A
     D @DBFLDP4        S             10A
     D @DBFTDP4        S              1A
     D @DBFFIL3        S             10A
     D @DBFLIB3        S             10A
     D @DBFFIL4        S             10A
     D @DBFLIB4        S             10A
     D @DBFFDP5        S             10A
     D @DBFLDP5        S             10A
     D @DBFFIL5        S             10A
     D @DBFLIB5        S             10A
     D @DBFTDP5        S              1A
     D @FIL2           S             10A
     D @LIB2           S             10A
     D @TYP2           S              1A
     D @FIL3           S             10A
     D @LIB3           S             10A
     D @TYP3           S              1A
     D @FIL4           S             10A
     D @LIB4           S             10A
     D @TYP4           S              1A
     D @FIL5           S             10A
     D @LIB5           S             10A
     D @TYP5           S              1A
     D @FIL6           S             10A
     D @LIB6           S             10A
     D @TYP6           S              1A
     D @FIL7           S             10A
     D @LIB7           S             10A
     D @TYP7           S              1A
     D @FIL8           S             10A
     D @LIB8           S             10A
     D @TYP8           S              1A
     D @FIL9           S             10A
     D @LIB9           S             10A
     D @TYP9           S              1A
     D @FIL10          S             10A
     D @LIB10          S             10A
     D @TYP10          S              1A
     D @FIL11          S             10A
     D @LIB11          S             10A
     D @TYP11          S              1A
     D @FIL12          S             10A
     D @LIB12          S             10A
     D @TYP12          S              1A
     D @FIL13          S             10A
     D @LIB13          S             10A
     D @TYP13          S              1A
     D @FIL14          S             10A
     D @LIB14          S             10A
     D @TYP14          S              1A
     D @FIL15          S             10A
     D @LIB15          S             10A
     D @TYP15          S              1A
     D @FIL16          S             10A
     D @LIB16          S             10A
     D @TYP16          S              1A
     D @FIL17          S             10A
     D @LIB17          S             10A
     D @TYP17          S              1A
     D @FIL18          S             10A
     D @LIB18          S             10A
     D @TYP18          S              1A
     D @FIL19          S             10A
     D @LIB19          S             10A
     D @TYP19          S              1A
     D @FIL20          S             10A
     D @LIB20          S             10A
     D @TYP20          S              1A
     D Prev_File1      S             10A
     D Prev_File2      S             10A
     D Prev_File21     S             10A
     D Prev_File3      S             10A
     D Prev_File31     S             10A
     D Prev_File4      S             10A
     D Prev_File41     S             10A
     D Prev_File5      S             10A
     D Prev_File51     S             10A
     D Prev_File6      S             10A
     D Prev_File61     S             10A
     D Prev_File7      S             10A
     D Prev_File71     S             10A
     D Prev_File8      S             10A
     D Prev_File81     S             10A
     D Prev_File9      S             10A
     D Prev_File91     S             10A
     D Prev_File10     S             10A
     D Prev_File101    S             10A
     D Prev_File11     S             10A
     D Prev_File111    S             10A
     D Prev_File12     S             10A
     D Prev_File121    S             10A
     D Prev_File13     S             10A
     D Prev_File131    S             10A
     D Prev_File14     S             10A
     D Prev_File141    S             10A
     D Prev_File15     S             10A
     D Prev_File151    S             10A
     D Prev_File16     S             10A
     D Prev_File161    S             10A
     D Prev_File17     S             10A
     D Prev_File171    S             10A
     D Prev_File18     S             10A
     D Prev_File181    S             10A
     D Prev_File19     S             10A
     D Prev_File191    S             10A
     D Prev_File20     S             10A
     D Prev_File201    S             10A
     D Idx             S              5  0
     D I               S              5  0
     D WLIB1           S             10A
     D WFILE           S             10A

     D UPGDRV        E DS                  EXTNAME(UPGDRVTD)

     D  @@DBFLIB       DS
     D  @LibType               3      4
     D  @LibType3              3      5

     D  @@LIB1         DS
     D  @1LibType              3      4
     D  @1LibType3             3      5


      *
     C     *ENTRY        PLIST
     C**********         PARM                    RefSys            2                        MD061992
     C                   PARM                    RefSys            3                        MD061992
     C                   PARM                    Error            10


      * Read driver file and process each entry
     C/exec SQL
     C+ declare CursorRdZ cursor for
     C+ select *
     C+ from UPGDRVTD where DRACTN = 'IGNORE'
     C/end-exec
      *
     C/exec SQL
     C+ open CursorRdZ
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from CursorRdZ
     C+ into :UPGDRV
     C/end-exec


     C                   DOW       SQLCODE = 0

     C                   CLEAR                   FILEA
     C                   eval      Idx = 0
      ** Set the library to Reference System
     C                   eval      WLIB1 = DRLIB
     C                   eval      WFILE = DRFILE
      ** look for its dependents (DSPDBR)
     C                   EXSR      SR_LEVEL1

      ** Set the library to Reference System
     C                   eval      WLIB1 = RefSys + %SUBST(DRLIB:3:8)
     C                   eval      WFILE = DRFILE
      ** look for its dependents (DSPDBR)
     C                   EXSR      SR_LEVEL1

     C/exec SQL
     C+ fetch next
     C+ from CursorRdZ
     C+ into :UPGDRV
     C/end-exec

     C                   ENDDO

      * and update DRACTN = 'IGNORE' for any LF for which its dependency is flagged
      * as 'IGNORE'
     C/exec SQL
     C+ update UPGdrvtd u set u.DRACTN = 'IGNORE'
     C+ where exists (select * from UPGXRIPD i where i.PDEPF = u.DRFILE)
     C/end-exec

     C                   EVAL      *INLR = *ON
     C                   RETURN

     C*                  CLEAR                   FILELIB
      *****************************************************************
      /EJECT
     C     SR_LEVEL1     BEGSR

     C                   EVAL      Prev_File1 = *BLANKS
     C                   EVAL      PINCR = 0
     C/exec SQL
     C+ declare LEVEL1 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :WLIB1
     C+ and DBFFIL = :WFILE
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL1
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL1
     C+ into :@DBFFDP,
     C+      :@DBFLDP
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File1 <> @DBFFDP
     C     @DBFFDP       LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @DBFFDP
      ** dependent file is dependency?  (DSPDBR)
     C                   EXSR      SR_LEVEL2
      ** dependent file is has dependent? (DSPFD)
     C                   EXSR      SR_LEVEL21
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB  = WLIB1
     C                   EVAL      PFILE = WFILE
     C                   EVAL      PLIB  = WLIB1
     C                   EVAL      PDEPF = @DBFFDP
     C                   EVAL      PLIBO = @DBFLDP
     C                   EVAL      PLEVEL= '1.1'
     C                   EVAL      PSEQ  = 999
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File1 = @DBFFDP
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL1
     C+ into :@DBFFDP,
     C+      :@DBFLDP
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL1
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL2     BEGSR

     C                   EVAL      Prev_File2 = *BLANKS
     C/exec SQL
     C+ declare LEVEL2 cursor for
     C+ select DBFFDP, DBFLDP, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@DBFLDP
     C+ and DBFFIL = :@DBFFDP
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL2
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL2
     C+ into :@FIL2,
     C+      :@LIB2,
     C+      :@TYP2
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File2 <> @FIL2
     C     @FIL2         LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL2
      ** if logical
     C*                  IF        @TYP2 = 'V'
      ** dependent file is dependency?  (DSPDBR)
     C                   EXSR      SR_LEVEL3
      ** dependent file is has dependent? (DSPFD)
     C                   EXSR      SR_LEVEL31
     C*                  ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @DBFFDP
     C                   EVAL      PLIB  = @DBFLDP
     C                   EVAL      PDEPF = @FIL2
     C                   EVAL      PLIBO = @LIB2
     C                   EVAL      PLEVEL= '2'
     C                   EVAL      PSEQ  = 998
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File2 = @FIL2
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL2
     C+ into :@FIL2,
     C+      :@LIB2,
     C+      :@TYP2
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL2
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL21    BEGSR

     C                   EVAL      Prev_File21 = *BLANKS
     C/exec SQL
     C+ declare LEVEL21 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@DBFLDP
     C+ and DBFFDP = :@DBFFDP
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL21
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL21
     C+ into :@FIL2,
     C+      :@LIB2,
     C+      :@TYP2
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File21 <> @FIL2
     C                             and @FIL2 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL2
     C                   EVAL      PLIB  = @LIB2
     C                   EVAL      PDEPF = @DBFFDP
     C                   EVAL      PLIBO = @DBFLDP
     C                   EVAL      PLEVEL= '2.1'
     C                   EVAL      PSEQ  = 997
     C                   EVAL      PDEPT =  @TYP2
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File21 = @FIL2
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL21
     C+ into :@FIL2,
     C+      :@LIB2,
     C+      :@TYP2
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL21
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL3     BEGSR

     C                   EVAL      Prev_File3 = *BLANKS
     C/exec SQL
     C+ declare LEVEL3 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB2
     C+ and DBFFIL = :@FIL2
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL3
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL3
     C+ into :@FIL3,
     C+      :@LIB3
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File3 <> @FIL3
     C***                          and @FIL3 <> @DBFFDP
     C     @FIL3         LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL3
     C                   IF        @FIL3 <> @DBFFDP
     C                   EXSR      SR_LEVEL4
     C                   EXSR      SR_LEVEL41
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL2
     C                   EVAL      PLIB  = @LIB2
     C                   EVAL      PDEPF = @FIL3
     C                   EVAL      PLIBO = @LIB3
     C                   EVAL      PLEVEL= '3'
     C                   EVAL      PSEQ  = 996
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File3 = @FIL3
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL3
     C+ into :@FIL3,
     C+      :@LIB3
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL3
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL31    BEGSR

     C                   EVAL      Prev_File31 = *BLANKS
     C/exec SQL
     C+ declare LEVEL31 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB2
     C+ and DBFFDP = :@FIL2
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL31
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL31
     C+ into :@FIL3,
     C+      :@LIB3,
     C+      :@TYP3
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File31 <> @FIL3
     C                             and @FIL3 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL3
     C                   EVAL      PLIB  = @LIB3
     C                   EVAL      PDEPF = @FIL2
     C                   EVAL      PLIBO = @LIB2
     C                   EVAL      PLEVEL= '3.1'
     C                   EVAL      PSEQ  = 995
     C                   EVAL      PDEPT =  @TYP3
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File31 = @FIL3
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL31
     C+ into :@FIL3,
     C+      :@LIB3,
     C+      :@TYP3
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL31
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL4     BEGSR

     C                   EVAL      Prev_File4 = *BLANKS
     C/exec SQL
     C+ declare LEVEL4 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB3
     C+ and DBFFIL = :@FIL3
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL4
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL4
     C+ into :@FIL4,
     C+      :@LIB4
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File4 <> @FIL4
     C     @FIL4         LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL4
     C                   IF        @FIL4 <> @FIL2
     C                   EXSR      SR_LEVEL5
     C                   EXSR      SR_LEVEL51
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL3
     C                   EVAL      PLIB  = @LIB3
     C                   EVAL      PDEPF = @FIL4
     C                   EVAL      PLIBO = @LIB4
     C                   EVAL      PLEVEL= '4'
     C                   EVAL      PSEQ  = 994
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File4 = @FIL4
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL4
     C+ into :@FIL4,
     C+      :@LIB4
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL4
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL41    BEGSR

     C                   EVAL      Prev_File41 = *BLANKS
     C/exec SQL
     C+ declare LEVEL41 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB3
     C+ and DBFFDP = :@FIL3
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL41
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL41
     C+ into :@FIL4,
     C+      :@LIB4,
     C+      :@TYP4
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File41 <> @FIL4
     C                             and @FIL4 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL4
     C                   EVAL      PLIB  = @LIB4
     C                   EVAL      PDEPF = @FIL3
     C                   EVAL      PLIBO = @LIB3
     C                   EVAL      PLEVEL= '4.1'
     C                   EVAL      PSEQ  = 993
     C                   EVAL      PDEPT =  @TYP4
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File41 = @FIL4
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL41
     C+ into :@FIL4,
     C+      :@LIB4,
     C+      :@TYP4
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL41
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL5     BEGSR

     C                   EVAL      Prev_File5 = *BLANKS
     C/exec SQL
     C+ declare LEVEL5 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB4
     C+ and DBFFIL = :@FIL4
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL5
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL5
     C+ into :@FIL5,
     C+      :@LIB5
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File5 <> @FIL5
     C     @FIL5         LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL5
     C                   IF        @FIL5 <> @FIL3
     C                   EXSR      SR_LEVEL6
     C                   EXSR      SR_LEVEL61
     C*                  DUMP
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL4
     C                   EVAL      PLIB  = @LIB4
     C                   EVAL      PDEPF = @FIL5
     C                   EVAL      PLIBO = @LIB5
     C                   EVAL      PLEVEL= '5'
     C                   EVAL      PSEQ  = 992
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File5 = @FIL5
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL5
     C+ into :@FIL5,
     C+      :@LIB5
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL5
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL51    BEGSR

     C                   EVAL      Prev_File51 = *BLANKS
     C/exec SQL
     C+ declare LEVEL51 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB4
     C+ and DBFFDP = :@FIL4
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL51
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL51
     C+ into :@FIL5,
     C+      :@LIB5,
     C+      :@TYP5
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File51 <> @FIL5
     C                             and @FIL5 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL5
     C                   EVAL      PLIB  = @LIB5
     C                   EVAL      PDEPF = @FIL4
     C                   EVAL      PLIBO = @LIB4
     C                   EVAL      PLEVEL= '5.1'
     C                   EVAL      PSEQ  = 991
     C                   EVAL      PDEPT =  @TYP5
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File51 = @FIL5
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL51
     C+ into :@FIL5,
     C+      :@LIB5,
     C+      :@TYP5
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL51
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL6     BEGSR

     C                   EVAL      Prev_File6 = *BLANKS
     C/exec SQL
     C+ declare LEVEL6 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB5
     C+ and DBFFIL = :@FIL5
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL6
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL6
     C+ into :@FIL6,
     C+      :@LIB6
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File6 <> @FIL6
     C     @FIL6         LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL6
     C                   IF        @FIL6 <> @FIL4
     C                   EXSR      SR_LEVEL7
     C                   EXSR      SR_LEVEL71
     C*                  DUMP
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL5
     C                   EVAL      PLIB  = @LIB5
     C                   EVAL      PDEPF = @FIL6
     C                   EVAL      PLIBO = @LIB6
     C                   EVAL      PLEVEL= '6'
     C                   EVAL      PSEQ  = 990
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File6 = @FIL6
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL6
     C+ into :@FIL6,
     C+      :@LIB6
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL6
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL61    BEGSR

     C                   EVAL      Prev_File61 = *BLANKS
     C/exec SQL
     C+ declare LEVEL61 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB5
     C+ and DBFFDP = :@FIL5
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL61
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL61
     C+ into :@FIL6,
     C+      :@LIB6,
     C+      :@TYP6
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File61 <> @FIL6
     C                             and @FIL6 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL6
     C                   EVAL      PLIB  = @LIB6
     C                   EVAL      PDEPF = @FIL5
     C                   EVAL      PLIBO = @LIB5
     C                   EVAL      PLEVEL= '6.1'
     C                   EVAL      PSEQ  = 989
     C                   EVAL      PDEPT =  @TYP6
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File61 = @FIL6
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL61
     C+ into :@FIL6,
     C+      :@LIB6,
     C+      :@TYP6
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL61
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL7     BEGSR

     C                   EVAL      Prev_File7 = *BLANKS
     C/exec SQL
     C+ declare LEVEL7 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB6
     C+ and DBFFIL = :@FIL6
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL7
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL7
     C+ into :@FIL7,
     C+      :@LIB7
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File7 <> @FIL7
     C     @FIL7         LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL7
     C                   IF        @FIL7 <> @FIL5
     C                   EXSR      SR_LEVEL8
     C                   EXSR      SR_LEVEL81
     C*                  DUMP
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL6
     C                   EVAL      PLIB  = @LIB6
     C                   EVAL      PDEPF = @FIL7
     C                   EVAL      PLIBO = @LIB7
     C                   EVAL      PLEVEL= '7'
     C                   EVAL      PSEQ  = 988
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File7 = @FIL7
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL7
     C+ into :@FIL7,
     C+      :@LIB7
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL7
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL71    BEGSR

     C                   EVAL      Prev_File71 = *BLANKS
     C/exec SQL
     C+ declare LEVEL71 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB6
     C+ and DBFFDP = :@FIL6
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL71
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL71
     C+ into :@FIL7,
     C+      :@LIB7,
     C+      :@TYP7
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File71 <> @FIL7
     C                             and @FIL7 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL7
     C                   EVAL      PLIB  = @LIB7
     C                   EVAL      PDEPF = @FIL6
     C                   EVAL      PLIBO = @LIB6
     C                   EVAL      PLEVEL= '7.1'
     C                   EVAL      PSEQ  = 987
     C                   EVAL      PDEPT =  @TYP7
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File71 = @FIL7
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL71
     C+ into :@FIL7,
     C+      :@LIB7,
     C+      :@TYP7
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL71
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL8     BEGSR

     C                   EVAL      Prev_File8 = *BLANKS
     C/exec SQL
     C+ declare LEVEL8 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB7
     C+ and DBFFIL = :@FIL7
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL8
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL8
     C+ into :@FIL8,
     C+      :@LIB8
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File8 <> @FIL8
     C     @FIL8         LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL8
     C                   IF        @FIL8 <> @FIL6
     C                   EXSR      SR_LEVEL9
     C                   EXSR      SR_LEVEL91
     C*                  DUMP
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL7
     C                   EVAL      PLIB  = @LIB7
     C                   EVAL      PDEPF = @FIL8
     C                   EVAL      PLIBO = @LIB8
     C                   EVAL      PLEVEL= '8'
     C                   EVAL      PSEQ  = 986
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File8 = @FIL8
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL8
     C+ into :@FIL8,
     C+      :@LIB8
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL8
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL81    BEGSR

     C                   EVAL      Prev_File81 = *BLANKS
     C/exec SQL
     C+ declare LEVEL81 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB7
     C+ and DBFFDP = :@FIL7
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL81
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL81
     C+ into :@FIL8,
     C+      :@LIB8,
     C+      :@TYP8
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File81 <> @FIL8
     C                             and @FIL8 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL8
     C                   EVAL      PLIB  = @LIB8
     C                   EVAL      PDEPF = @FIL7
     C                   EVAL      PLIBO = @LIB7
     C                   EVAL      PLEVEL= '8.1'
     C                   EVAL      PSEQ  = 985
     C                   EVAL      PDEPT =  @TYP8
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File81 = @FIL8
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL81
     C+ into :@FIL8,
     C+      :@LIB8,
     C+      :@TYP8
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL81
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL9     BEGSR

     C                   EVAL      Prev_File9 = *BLANKS
     C/exec SQL
     C+ declare LEVEL9 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB8
     C+ and DBFFIL = :@FIL8
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL9
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL9
     C+ into :@FIL9,
     C+      :@LIB9
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File9 <> @FIL9
     C     @FIL9         LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL9
     C                   IF        @FIL9 <> @FIL7
     C                   EXSR      SR_LEVEL10
     C                   EXSR      SR_LEVEL101
     C*                  DUMP
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL8
     C                   EVAL      PLIB  = @LIB8
     C                   EVAL      PDEPF = @FIL9
     C                   EVAL      PLIBO = @LIB9
     C                   EVAL      PLEVEL= '9'
     C                   EVAL      PSEQ  = 984
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File9 = @FIL9
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL9
     C+ into :@FIL9,
     C+      :@LIB9
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL9
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL91    BEGSR

     C                   EVAL      Prev_File91 = *BLANKS
     C/exec SQL
     C+ declare LEVEL91 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB8
     C+ and DBFFDP = :@FIL8
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL91
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL91
     C+ into :@FIL9,
     C+      :@LIB9,
     C+      :@TYP9
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File91 <> @FIL9
     C                             and @FIL9 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL9
     C                   EVAL      PLIB  = @LIB9
     C                   EVAL      PDEPF = @FIL8
     C                   EVAL      PLIBO = @LIB8
     C                   EVAL      PLEVEL= '9.1'
     C                   EVAL      PSEQ  = 983
     C                   EVAL      PDEPT =  @TYP9
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File91 = @FIL9
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL91
     C+ into :@FIL9,
     C+      :@LIB9,
     C+      :@TYP9
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL91
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL10    BEGSR

     C                   EVAL      Prev_File10 = *BLANKS
     C/exec SQL
     C+ declare LEVEL10 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB9
     C+ and DBFFIL = :@FIL9
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL10
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL10
     C+ into :@FIL10,
     C+      :@LIB10
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File10 <> @FIL10
     C     @FIL10        LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL10
     C                   IF        @FIL10 <> @FIL8
     C                   EXSR      SR_LEVEL11
     C                   EXSR      SR_LEVEL111
     C*                  DUMP
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL9
     C                   EVAL      PLIB  = @LIB9
     C                   EVAL      PDEPF = @FIL10
     C                   EVAL      PLIBO = @LIB10
     C                   EVAL      PLEVEL= '10'
     C                   EVAL      PSEQ  = 982
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File10 = @FIL10
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL10
     C+ into :@FIL10,
     C+      :@LIB10
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL10
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL101   BEGSR

     C                   EVAL      Prev_File101 = *BLANKS
     C/exec SQL
     C+ declare LEVEL101 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB9
     C+ and DBFFDP = :@FIL9
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL101
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL101
     C+ into :@FIL10,
     C+      :@LIB10,
     C+      :@TYP10
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File101 <> @FIL10
     C                             and @FIL10 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL10
     C                   EVAL      PLIB  = @LIB10
     C                   EVAL      PDEPF = @FIL9
     C                   EVAL      PLIBO = @LIB9
     C                   EVAL      PLEVEL= '10.1'
     C                   EVAL      PSEQ  = 981
     C                   EVAL      PDEPT =  @TYP10
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File101 = @FIL10
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL101
     C+ into :@FIL10,
     C+      :@LIB10,
     C+      :@TYP10
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL101
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL11    BEGSR

     C                   EVAL      Prev_File11 = *BLANKS
     C/exec SQL
     C+ declare LEVEL11 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB10
     C+ and DBFFIL = :@FIL10
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL11
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL11
     C+ into :@FIL11,
     C+      :@LIB11
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File11 <> @FIL11
     C     @FIL11        LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL11
     C                   IF        @FIL11 <> @FIL9
     C                   EXSR      SR_LEVEL12
     C                   EXSR      SR_LEVEL121
     C*                  DUMP
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL10
     C                   EVAL      PLIB  = @LIB10
     C                   EVAL      PDEPF = @FIL11
     C                   EVAL      PLIBO = @LIB11
     C                   EVAL      PLEVEL= '11'
     C                   EVAL      PSEQ  = 980
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File11 = @FIL11
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL11
     C+ into :@FIL11,
     C+      :@LIB11
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL11
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL111   BEGSR

     C                   EVAL      Prev_File111 = *BLANKS
     C/exec SQL
     C+ declare LEVEL111 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB10
     C+ and DBFFDP = :@FIL10
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL111
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL111
     C+ into :@FIL11,
     C+      :@LIB11,
     C+      :@TYP11
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File111 <> @FIL11
     C                             and @FIL11 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL11
     C                   EVAL      PLIB  = @LIB11
     C                   EVAL      PDEPF = @FIL10
     C                   EVAL      PLIBO = @LIB10
     C                   EVAL      PLEVEL= '11.1'
     C                   EVAL      PSEQ  = 979
     C                   EVAL      PDEPT =  @TYP11
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File111 = @FIL11
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL111
     C+ into :@FIL11,
     C+      :@LIB11,
     C+      :@TYP11
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL111
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL12    BEGSR

     C                   EVAL      Prev_File12 = *BLANKS
     C/exec SQL
     C+ declare LEVEL12 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB11
     C+ and DBFFIL = :@FIL11
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL12
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL12
     C+ into :@FIL12,
     C+      :@LIB12
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File12 <> @FIL12
     C     @FIL12        LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL12
     C                   IF        @FIL12 <> @FIL10
     C                   EXSR      SR_LEVEL13
     C                   EXSR      SR_LEVEL131
     C*                  DUMP
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL11
     C                   EVAL      PLIB  = @LIB11
     C                   EVAL      PDEPF = @FIL12
     C                   EVAL      PLIBO = @LIB12
     C                   EVAL      PLEVEL= '12'
     C                   EVAL      PSEQ  = 978
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File12 = @FIL12
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL12
     C+ into :@FIL12,
     C+      :@LIB12
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL12
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL121   BEGSR

     C                   EVAL      Prev_File121 = *BLANKS
     C/exec SQL
     C+ declare LEVEL121 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB11
     C+ and DBFFDP = :@FIL11
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL121
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL121
     C+ into :@FIL12,
     C+      :@LIB12,
     C+      :@TYP12
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File121 <> @FIL12
     C                             and @FIL12 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL12
     C                   EVAL      PLIB  = @LIB12
     C                   EVAL      PDEPF = @FIL11
     C                   EVAL      PLIBO = @LIB11
     C                   EVAL      PLEVEL= '12.1'
     C                   EVAL      PSEQ  = 977
     C                   EVAL      PDEPT =  @TYP12
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File121 = @FIL12
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL121
     C+ into :@FIL12,
     C+      :@LIB12,
     C+      :@TYP12
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL121
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL13    BEGSR

     C                   EVAL      Prev_File13 = *BLANKS
     C/exec SQL
     C+ declare LEVEL13 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB12
     C+ and DBFFIL = :@FIL12
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL13
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL13
     C+ into :@FIL13,
     C+      :@LIB13
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File13 <> @FIL13
     C     @FIL13        LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL13
     C                   IF        @FIL13 <> @FIL11
     C                   EXSR      SR_LEVEL14
     C                   EXSR      SR_LEVEL141
     C*                  DUMP
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL12
     C                   EVAL      PLIB  = @LIB12
     C                   EVAL      PDEPF = @FIL13
     C                   EVAL      PLIBO = @LIB13
     C                   EVAL      PLEVEL= '13'
     C                   EVAL      PSEQ  = 976
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File13 = @FIL13
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL13
     C+ into :@FIL13,
     C+      :@LIB13
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL13
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL131   BEGSR

     C                   EVAL      Prev_File131 = *BLANKS
     C/exec SQL
     C+ declare LEVEL131 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB12
     C+ and DBFFDP = :@FIL12
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL131
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL131
     C+ into :@FIL13,
     C+      :@LIB13,
     C+      :@TYP13
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File131 <> @FIL13
     C                             and @FIL13 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL13
     C                   EVAL      PLIB  = @LIB13
     C                   EVAL      PDEPF = @FIL12
     C                   EVAL      PLIBO = @LIB12
     C                   EVAL      PLEVEL= '13.1'
     C                   EVAL      PSEQ  = 975
     C                   EVAL      PDEPT =  @TYP13
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File131 = @FIL13
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL131
     C+ into :@FIL13,
     C+      :@LIB13,
     C+      :@TYP13
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL131
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL14    BEGSR

     C                   EVAL      Prev_File14 = *BLANKS
     C/exec SQL
     C+ declare LEVEL14 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB13
     C+ and DBFFIL = :@FIL13
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL14
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL14
     C+ into :@FIL14,
     C+      :@LIB14
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File14 <> @FIL14
     C     @FIL14        LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL14
     C                   IF        @FIL14 <> @FIL12
     C                   EXSR      SR_LEVEL15
     C                   EXSR      SR_LEVEL151
     C*                  DUMP
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL13
     C                   EVAL      PLIB  = @LIB13
     C                   EVAL      PDEPF = @FIL14
     C                   EVAL      PLIBO = @LIB14
     C                   EVAL      PLEVEL= '14'
     C                   EVAL      PSEQ  = 974
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File14 = @FIL14
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL14
     C+ into :@FIL14,
     C+      :@LIB14
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL14
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL141   BEGSR

     C                   EVAL      Prev_File141 = *BLANKS
     C/exec SQL
     C+ declare LEVEL141 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB13
     C+ and DBFFDP = :@FIL13
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL141
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL141
     C+ into :@FIL14,
     C+      :@LIB14,
     C+      :@TYP14
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File141 <> @FIL14
     C                             and @FIL14 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL14
     C                   EVAL      PLIB  = @LIB14
     C                   EVAL      PDEPF = @FIL13
     C                   EVAL      PLIBO = @LIB13
     C                   EVAL      PLEVEL= '14.1'
     C                   EVAL      PSEQ  = 973
     C                   EVAL      PDEPT =  @TYP14
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File141 = @FIL14
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL141
     C+ into :@FIL14,
     C+      :@LIB14,
     C+      :@TYP14
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL141
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL15    BEGSR

     C                   EVAL      Prev_File15 = *BLANKS
     C/exec SQL
     C+ declare LEVEL15 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB14
     C+ and DBFFIL = :@FIL14
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL15
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL15
     C+ into :@FIL15,
     C+      :@LIB15
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File15 <> @FIL15
     C     @FIL15        LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL15
     C                   IF        @FIL15 <> @FIL13
     C                   EXSR      SR_LEVEL16
     C                   EXSR      SR_LEVEL161
     C*                  DUMP
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL14
     C                   EVAL      PLIB  = @LIB14
     C                   EVAL      PDEPF = @FIL15
     C                   EVAL      PLIBO = @LIB15
     C                   EVAL      PLEVEL= '15'
     C                   EVAL      PSEQ  = 972
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File15 = @FIL15
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL15
     C+ into :@FIL15,
     C+      :@LIB15
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL15
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL151   BEGSR

     C                   EVAL      Prev_File151 = *BLANKS
     C/exec SQL
     C+ declare LEVEL151 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB14
     C+ and DBFFDP = :@FIL14
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL151
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL151
     C+ into :@FIL15,
     C+      :@LIB15,
     C+      :@TYP15
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File151 <> @FIL15
     C                             and @FIL15 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL15
     C                   EVAL      PLIB  = @LIB15
     C                   EVAL      PDEPF = @FIL14
     C                   EVAL      PLIBO = @LIB14
     C                   EVAL      PLEVEL= '15.1'
     C                   EVAL      PSEQ  = 971
     C                   EVAL      PDEPT =  @TYP15
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File151 = @FIL15
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL151
     C+ into :@FIL15,
     C+      :@LIB15,
     C+      :@TYP15
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL151
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL16    BEGSR

     C                   EVAL      Prev_File16 = *BLANKS
     C/exec SQL
     C+ declare LEVEL16 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB15
     C+ and DBFFIL = :@FIL15
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL16
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL16
     C+ into :@FIL16,
     C+      :@LIB16
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File16 <> @FIL16
     C     @FIL16        LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL16
     C                   IF        @FIL16 <> @FIL14
     C                   EXSR      SR_LEVEL17
     C                   EXSR      SR_LEVEL171
     C*                  DUMP
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL15
     C                   EVAL      PLIB  = @LIB15
     C                   EVAL      PDEPF = @FIL16
     C                   EVAL      PLIBO = @LIB16
     C                   EVAL      PLEVEL= '16'
     C                   EVAL      PSEQ  = 970
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File16 = @FIL16
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL16
     C+ into :@FIL16,
     C+      :@LIB16
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL16
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL161   BEGSR

     C                   EVAL      Prev_File161 = *BLANKS
     C/exec SQL
     C+ declare LEVEL161 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB15
     C+ and DBFFDP = :@FIL15
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL161
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL161
     C+ into :@FIL16,
     C+      :@LIB16,
     C+      :@TYP16
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File161 <> @FIL16
     C                             and @FIL16 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL16
     C                   EVAL      PLIB  = @LIB16
     C                   EVAL      PDEPF = @FIL15
     C                   EVAL      PLIBO = @LIB15
     C                   EVAL      PLEVEL= '16.1'
     C                   EVAL      PSEQ  = 969
     C                   EVAL      PDEPT =  @TYP16
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C
     C                   EVAL      Prev_File161 = @FIL16
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL161
     C+ into :@FIL16,
     C+      :@LIB16,
     C+      :@TYP16
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL161
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL17    BEGSR

     C                   EVAL      Prev_File17 = *BLANKS
     C/exec SQL
     C+ declare LEVEL17 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB16
     C+ and DBFFIL = :@FIL16
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL17
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL17
     C+ into :@FIL17,
     C+      :@LIB17
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File17 <> @FIL17
     C     @FIL17        LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL17
     C                   IF        @FIL17 <> @FIL15
     C                   EXSR      SR_LEVEL18
     C                   EXSR      SR_LEVEL181
     C*                  DUMP
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL16
     C                   EVAL      PLIB  = @LIB16
     C                   EVAL      PDEPF = @FIL17
     C                   EVAL      PLIBO = @LIB17
     C                   EVAL      PLEVEL= '17'
     C                   EVAL      PSEQ  = 968
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File17 = @FIL17
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL17
     C+ into :@FIL17,
     C+      :@LIB17
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL17
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL171   BEGSR

     C                   EVAL      Prev_File171 = *BLANKS
     C/exec SQL
     C+ declare LEVEL171 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB16
     C+ and DBFFDP = :@FIL16
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL171
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL171
     C+ into :@FIL17,
     C+      :@LIB17,
     C+      :@TYP17
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File171 <> @FIL17
     C                             and @FIL17 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL17
     C                   EVAL      PLIB  = @LIB17
     C                   EVAL      PDEPF = @FIL16
     C                   EVAL      PLIBO = @LIB16
     C                   EVAL      PLEVEL= '17.1'
     C                   EVAL      PSEQ  = 967
     C                   EVAL      PDEPT =  @TYP17
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File171 = @FIL17
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL171
     C+ into :@FIL17,
     C+      :@LIB17,
     C+      :@TYP17
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL171
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL18    BEGSR

     C                   EVAL      Prev_File18 = *BLANKS
     C/exec SQL
     C+ declare LEVEL18 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB17
     C+ and DBFFIL = :@FIL17
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL18
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL18
     C+ into :@FIL18,
     C+      :@LIB18
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File18 <> @FIL18
     C     @FIL18        LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL18
     C                   IF        @FIL18 <> @FIL16
     C                   EXSR      SR_LEVEL19
     C                   EXSR      SR_LEVEL191
     C*                  DUMP
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL17
     C                   EVAL      PLIB  = @LIB17
     C                   EVAL      PDEPF = @FIL18
     C                   EVAL      PLIBO = @LIB18
     C                   EVAL      PLEVEL= '18'
     C                   EVAL      PSEQ  = 966
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File18 = @FIL18
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL18
     C+ into :@FIL18,
     C+      :@LIB18
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL18
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL181   BEGSR

     C                   EVAL      Prev_File181 = *BLANKS
     C/exec SQL
     C+ declare LEVEL181 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB17
     C+ and DBFFDP = :@FIL17
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL181
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL181
     C+ into :@FIL18,
     C+      :@LIB18,
     C+      :@TYP18
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File181 <> @FIL18
     C                             and @FIL18 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL18
     C                   EVAL      PLIB  = @LIB18
     C                   EVAL      PDEPF = @FIL17
     C                   EVAL      PLIBO = @LIB17
     C                   EVAL      PLEVEL= '18.1'
     C                   EVAL      PSEQ  = 965
     C                   EVAL      PDEPT =  @TYP18
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File181 = @FIL18
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL181
     C+ into :@FIL18,
     C+      :@LIB18,
     C+      :@TYP18
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL181
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL19    BEGSR

     C                   EVAL      Prev_File19 = *BLANKS
     C/exec SQL
     C+ declare LEVEL19 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB19
     C+ and DBFFIL = :@FIL19
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL19
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL19
     C+ into :@FIL19,
     C+      :@LIB19
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File19 <> @FIL19
     C     @FIL19        LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL19
     C                   IF        @FIL19 <> @FIL17
     C                   EXSR      SR_LEVEL20
     C                   EXSR      SR_LEVEL201
     C*                  DUMP
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL18
     C                   EVAL      PLIB  = @LIB18
     C                   EVAL      PDEPF = @FIL19
     C                   EVAL      PLIBO = @LIB19
     C                   EVAL      PLEVEL= '19'
     C                   EVAL      PSEQ  = 964
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File19 = @FIL19
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL19
     C+ into :@FIL19,
     C+      :@LIB19
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL19
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL191   BEGSR

     C                   EVAL      Prev_File191 = *BLANKS
     C/exec SQL
     C+ declare LEVEL191 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB18
     C+ and DBFFDP = :@FIL18
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL191
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL191
     C+ into :@FIL19,
     C+      :@LIB19,
     C+      :@TYP19
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File191 <> @FIL18
     C                             and @FIL19 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL19
     C                   EVAL      PLIB  = @LIB19
     C                   EVAL      PDEPF = @FIL18
     C                   EVAL      PLIBO = @LIB18
     C                   EVAL      PLEVEL= '19.1'
     C                   EVAL      PSEQ  = 963
     C                   EVAL      PDEPT =  @TYP19
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File191 = @FIL19
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL191
     C+ into :@FIL19,
     C+      :@LIB19,
     C+      :@TYP19
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL191
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL20    BEGSR

     C                   EVAL      Prev_File20 = *BLANKS
     C/exec SQL
     C+ declare LEVEL20 cursor for
     C+ select DBFFDP, DBFLDP
     C+ from QADBFDEP
     C+ where DBFLIB = :@LIB20
     C+ and DBFFIL = :@FIL20
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL20
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL20
     C+ into :@FIL20,
     C+      :@LIB20
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File20 <> @FIL20
     C     @FIL20        LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = @FIL20
     C                   IF        @FIL19 <> @FIL18
     C*                  EXSR      SR_LEVEL21
     C*                  EXSR      SR_LEVEL211
     C*                  DUMP
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL19
     C                   EVAL      PLIB  = @LIB19
     C                   EVAL      PDEPF = @FIL20
     C                   EVAL      PLIBO = @LIB20
     C                   EVAL      PLEVEL= '20'
     C                   EVAL      PSEQ  = 962
     C                   EVAL      PDEPT =  ' '
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File20 = @FIL20
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL20
     C+ into :@FIL20,
     C+      :@LIB20
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL20
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
     C     SR_LEVEL201   BEGSR

     C                   EVAL      Prev_File201 = *BLANKS
     C/exec SQL
     C+ declare LEVEL201 cursor for
     C+ select DBFFIL, DBFLIB, DBFTDP
     C+ from QADBFDEP
     C+ where DBFLDP = :@LIB19
     C+ and DBFFDP = :@FIL19
     C+ order by DBFFIL
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL201
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL201
     C+ into :@FIL20,
     C+      :@LIB20,
     C+      :@TYP20
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   IF        Prev_File201 <> @FIL19
     C                             and @FIL20 <> WFILE
     C                   EVAL      PMFILE= WFILE
     C                   EVAL      PMLIB = WLIB1
     C                   EVAL      PFILE = @FIL20
     C                   EVAL      PLIB  = @LIB20
     C                   EVAL      PDEPF = @FIL19
     C                   EVAL      PLIBO = @LIB19
     C                   EVAL      PLEVEL= '20.1'
     C                   EVAL      PSEQ  = 961
     C                   EVAL      PDEPT =  @TYP20
     C                   EVAL      PINCR = PINCR + 1
     C                   WRITE     UPGXRID0
     C                   EVAL      Prev_File201 = @FIL20
     C                   ENDIF
     C/exec SQL
     C+ fetch next
     C+ from LEVEL201
     C+ into :@FIL20,
     C+      :@LIB20,
     C+      :@TYP20
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL201
     C/end-exec
     C                   ENDSR
      *****************************************************************
      *
