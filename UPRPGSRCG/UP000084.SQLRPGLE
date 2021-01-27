     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU DTAQ compare')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000084 - This program compares DTAQ                        *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD050666 *CREATE     Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050666 - Adaptive Database Upgrade                         *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D QDS             DS
     D  RCVB                   1      4B 0                                      Bytes Available

      * Parameters for retrieval of data
     D                 DS
     D  DTAQD                  1    108
     D  BYTR                   1      4B 0
     D  BYTA                   5      8B 0
     D  MSGL                   9     12B 0
     D  KEYL                  13     16B 0
     D  SEQ                   17     17
     D  SNDR                  18     18
     D  FORCE                 19     19
     D  TEXT                  20     69
     D  RES                   70     72
     D  NOOM                  73     76B 0
     D  MAXM                  77     80B 0
     D  DQU                   81     90
     D  LBU                   91    100
     D  MXNEA                101    104B 0
     D  INNE                 105    108B 0

     D DQDataF1        DS                  Inz
     D  BytesRtn                     10I 0
     D  BytesAvail                   10I 0 Inz(%size(DQDataF1))
     D  Max_Len                      10I 0
     D  Key_Len                      10I 0
     D  Q_Seq                         1A
     D  Sender_ID                     1A
     D  Force_Write                   1A
     D  TextDesc                     50A
     D  DtaQ_Type                     1A
     D  Auto_Rcl                      1A
     D  Reserved1                     1A
     D  Cur_Msgs                     10I 0
     D  CurEntry_Cap                 10I 0
     D  DtaQName                     10A
     D  DtaQLib                      10A
     D  Max_Entry                    10I 0
     D  Init_Entry                   10I 0


     D QDtaQ           DS            20
     D  DtaQ                   1     10
     D  DtaQLb                11     20

     D DtaQN           S             10A
     D DTAQP           S            108A
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    Lib1             10
     C                   PARM                    Lib2             10

      * List DtaQ which does not exist in Reference System
     C/exec SQL
     C+ declare Cursor1 cursor for
     C+ SELECT ODOBNM FROM DtaQ1 a
     C+ where not exists (select * from DtaQ2 b where a.ODOBNM = b.ODOBNM)
     C/end-exec

     C/exec SQL
     C+ open Cursor1
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Cursor1
     C+ into :DtaQN
     C/end-exec

     C                   DOW       SQLCODE = 0

     C                   CALL      'UT000039'
     C                   PARM      Lib1          Lib1N            10
     C                   PARM      *BLANKS       Lib2N            10
     C                   PARM                    DtaQN
     C                   PARM      'DTAQ'        #FATR             4
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
     C+ into :DtaQN
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close Cursor1
     C/end-exec

      * List DtaQ which does not exist in Current System
     C/exec SQL
     C+ declare Cursor2 cursor for
     C+ SELECT ODOBNM FROM DtaQ2 a
     C+ where not exists (select * from DtaQ1 b where a.ODOBNM = b.ODOBNM)
     C/end-exec

     C/exec SQL
     C+ open Cursor2
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Cursor2
     C+ into :DtaQN
     C/end-exec

     C                   DOW       SQLCODE = 0

     C                   CALL      'UT000039'
     C                   PARM      *BLANKS       Lib1N            10
     C                   PARM      Lib2          Lib2N            10
     C                   PARM                    DtaQN
     C                   PARM      'DTAQ'        #FATR             4
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
     C+ into :DtaQN
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close Cursor2
     C/end-exec

      * For DtaQ in both libraries, compare length
     C/exec SQL
     C+ declare Cursor3 cursor for
     C+ SELECT ODOBNM FROM DtaQ1 a
     C+ where exists (select * from DtaQ2 b where a.ODOBNM = b.ODOBNM)
     C/end-exec

     C/exec SQL
     C+ open Cursor3
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Cursor3
     C+ into :DtaQN
     C/end-exec

     C                   DOW       SQLCODE = 0

     C                   Clear                   DTAQD
     C                   eval      DtaQ = DtaQN
     C                   eval      DtaQLb = Lib1
     C                   CALL      'QMHQRDQD'
     C                   PARM      *BLANKS       DTAQP
     C                   PARM      80            RCVB
     C                   PARM      'RDQD0100'    FMT               8
     C                   PARM                    QDtaQ

      * Store DtaQ details
     C                   eval      DTAQD = DTAQP
     C                   eval      DQDataF1 = DTAQP
     C                   eval      DtaQLb = Lib2
     C                   CALL      'QMHQRDQD'
     C                   PARM      *BLANKS       DTAQP
     C                   PARM      80            RCVB
     C                   PARM      'RDQD0100'    FMT
     C                   PARM                    QDtaQ

      * if difference in length
     C                   if        DTAQD <> DTAQP
     C                   CALL      'UT000039'
     C                   PARM      Lib1          Lib1N            10
     C                   PARM      Lib2          Lib2N            10
     C                   PARM                    DtaQN
     C                   PARM      'DTAQ'        #FATR             4
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
     C+ into :DtaQN
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
