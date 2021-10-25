     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU DTAARA compare')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000083 - This program compares DTAARA                      *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     D RcdCount        S              5  0

     D QWCBS           DS          2036
     D  QWCBSB                 1      4B 0                                      Bytes Available
     D  QWCBSC                 5      8B 0                                      Bytes Returned
     D  QWCBSD                 9     18                                         Type Value Returned
     D  QWCBSF                19     28                                         Library Name
     D  QWCBSG                29     32B 0                                      Length Value Returne
     D  QWCBSH                33     36B 0                                      Number Decimal Posit

      * Definition of passed paramters
     D APIDEF          DS
     D  RECLEN                 1      4B 0 INZ(2036)                            Receive Length
     D  STRPOS                 5      8B 0 INZ(-1)                              Start Position
     D  DATAL                  9     12B 0 INZ(2000)                            Data Length

     D ERCDE           DS           132
     D  ERLEN                  1      4B 0 INZ(132)                             Error Length
     D  ERDTA                  4    128

     D QDtaAra         DS            20
     D  DtaAra                 1     10
     D  DtaLib                11     20

     D DTAARAN         S             10A
     D UPGXRR        E DS                  EXTNAME(UPGXRRPD)
     D UPGSCR        E DS                  EXTNAME(UPGSCRTD)
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    Lib1             10
     C                   PARM                    Lib2             10

     C     *LIKE         DEFINE    QWCBSG        ##Lgth1
     C     *LIKE         DEFINE    QWCBSG        ##Lgth2

      * List DTAARA which does not exist in Reference System
     C/exec SQL
     C+ declare Cursor1 cursor for
     C+ SELECT ODOBNM FROM dtaara1 a
     C+ where not exists (select * from dtaara2 b where a.ODOBNM = b.ODOBNM)
     C/end-exec

     C/exec SQL
     C+ open Cursor1
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Cursor1
     C+ into :DTAARAN
     C/end-exec

     C                   DOW       SQLCODE = 0

     C                   CALL      'UT000039'
     C                   PARM      Lib1          Lib1N            10
     C                   PARM      *BLANKS       Lib2N            10
     C                   PARM                    DTAARAN
     C                   PARM      'DTAA'        #FATR             4
     C                   PARM      'NOT FOUND'   #NARR            10
     C                   PARM      *BLANKS       #FIELD           10
     C                   PARM      *BLANKS       FDRPGN            6
     C                   PARM      *BLANKS       FDDESC           50
     C                   PARM      *BLANKS       DAT              40
     C                   PARM      *BLANKS       DSP              40
     C                   PARM      *BLANKS       @WHDS           132
     C                   PARM                    Lib1
     C/exec SQL
     C+ fetch next
     C+ from Cursor1
     C+ into :DTAARAN
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close Cursor1
     C/end-exec

      * List DTAARA which does not exist in Current System
     C/exec SQL
     C+ declare Cursor2 cursor for
     C+ SELECT ODOBNM FROM dtaara2 a
     C+ where not exists (select * from dtaara1 b where a.ODOBNM = b.ODOBNM)
     C/end-exec

     C/exec SQL
     C+ open Cursor2
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Cursor2
     C+ into :DTAARAN
     C/end-exec

     C                   DOW       SQLCODE = 0

     C                   CALL      'UT000039'
     C                   PARM      *BLANKS       Lib1N
     C                   PARM      Lib2          Lib2N
     C                   PARM                    DTAARAN
     C                   PARM      'DTAA'        #FATR             4
     C                   PARM      'NOT FOUND'   #NARR            10
     C                   PARM      *BLANKS       #FIELD           10
     C                   PARM      *BLANKS       FDRPGN            6
     C                   PARM      *BLANKS       FDDESC           50
     C                   PARM      *BLANKS       DAT              40
     C                   PARM      *BLANKS       DSP              40
     C                   PARM      *BLANKS       @WHDS           132
     C                   PARM                    Lib1
     C/exec SQL
     C+ fetch next
     C+ from Cursor2
     C+ into :DTAARAN
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close Cursor2
     C/end-exec

      * For DTAARA in both libraries, compare length
     C/exec SQL
     C+ declare Cursor3 cursor for
     C+ SELECT ODOBNM FROM dtaara1 a
     C+ where exists (select * from dtaara2 b where a.ODOBNM = b.ODOBNM)
     C/end-exec

     C/exec SQL
     C+ open Cursor3
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Cursor3
     C+ into :DTAARAN
     C/end-exec

     C                   DOW       SQLCODE = 0

     C                   Reset                   APIDEF
     C                   Reset                   ERCDE
     C                   eval      DtaAra = DTAARAN
     C                   eval      DtaLib = Lib1
     C                   CALL      'QWCRDTAA'
     C                   PARM      *BLANKS       QWCBS
     C                   PARM                    RECLEN
     C                   PARM                    QDtaAra
     C                   PARM                    STRPOS
     C                   PARM                    DATAL
     C                   PARM                    ERCDE
      * Store DTAARA length in Lib1
     C                   eval      ##Lgth1 = QWCBSG
     C                   eval      DtaLib = Lib2
     C                   CALL      'QWCRDTAA'
     C                   PARM      *BLANKS       QWCBS
     C                   PARM                    RECLEN
     C                   PARM                    QDtaAra
     C                   PARM                    STRPOS
     C                   PARM                    DATAL
     C                   PARM                    ERCDE
      * Store DTAARA length in Lib2
     C                   eval      ##Lgth2 = QWCBSG

      * if difference in length
     C                   if        ##Lgth1 <> ##Lgth2
     C                   CALL      'UT000039'
     C                   PARM      Lib1          Lib1N            10
     C                   PARM      Lib2          Lib2N            10
     C                   PARM                    DTAARAN
     C                   PARM      'DTAA'        #FATR             4
     C                   PARM      *BLANKS       #NARR            10
     C                   PARM      *BLANKS       #FIELD           10
     C                   PARM      *BLANKS       FDRPGN            6
     C                   PARM      *BLANKS       FDDESC           50
     C                   PARM      *BLANKS       DAT              40
     C                   PARM      *BLANKS       DSP              40
     C                   PARM      *BLANKS       @WHDS           132
     C                   PARM                    Lib1
     C                   Endif
     C/exec SQL
     C+ fetch next
     C+ from Cursor3
     C+ into :DTAARAN
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close Cursor3
     C/end-exec


     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
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
     C**                 EVAL      ERROR = '*Error'
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
