     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTR update monitor work table')               *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SM8009 - Midas UP monitor work table                         *
      *                                                               *
      *  Function: This program writes and update the table used for  *
      *            monitoring the refresh.                            *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CUP045 *CREATE     Date 01Jun22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP045 - One Touch Bridge - refresh                          *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     D RcdCount        S              5  0

     D MyPSDS         SDS
     D DFPGMQ                  1     10
     D DFJOBN                244    253
     D DFDUSR                254    263
     D DFJBNO                264    269S 0
     D DFJBNC                264    269

     D ArrLyr          S              2    DIM(11)
     D D_LAYR          S              7A
     D Ix              S              2S 0
     D NoCmp           S              3S 0
     D CMP             S             10A
     D SEQ             S              5S 0
     D DES             S             60A
     D LYR             S              7A
     D RETURN          S             10A
     D DBASE           S              3A
     D ##TMEDS         DS
     D   TMST                  1      6
     D   TMSD                  7     12
     D   ##TME                 1     12  0
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    MODE             10
     C                   PARM                    INCR              4 0
     C                   PARM                    DATA             10
     C                   PARM                    RETURN           10

     C                   eval      RETURN = *blanks

     C                   Select

      *--S-T-A-R-T--------------------------------------------------------------
     C                   when      MODE = '*WRITE    '

      * Set start time and date
     C                   TIME                    ##TME


      * Retrieve component details from SMMIGRTD
     C/exec SQL
     C+ select MIGCMP, MIGSEQ, MIGDES, MIGLYR
     C+ into :CMP, :SEQ, :DES, :LYR
     C+ from SMMIGRTD where MIGINC = :INCR
     C/end-exec

      * and write log
     C/EXEC SQL
     C+ insert into SMOTMLTD
     C+ (
     C+   LOGINC
     C+  ,LOGCMP
     C+  ,LOGSEQ
     C+  ,LOGDES
     C+  ,LOGSTS
     C+  ,LOGSTT
     C+  ,LOGSTD
     C+  ,LOGENT
     C+  ,LOGEND
     C+  ,LOGJNM
     C+  ,LOGUSR
     C+  ,LOGJBN
     C+  ,LOGLYR
     C+ )
     C+ Values
     C+ (
     C+   :INCR
     C+  ,:CMP
     C+  ,:SEQ
     C+  ,:DES
     C+  ,' '
     C+  ,:TMST
     C+  ,:TMSD
     C+  ,' '
     C+  ,' '
     C+  ,:DFJOBN
     C+  ,:DFDUSR
     C+  ,:DFJBNC
     C+  ,:LYR
     C+ )
     C/END-EXEC
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '101'
     C                   exsr      *pssr
     C                   Endif

      *--E-N-D------------------------------------------------------------------
     C                   when      MODE = '*END      '

      * Set start time and date
     C                   TIME                    ##TME

     C/exec SQL
     C+ update SMOTMLTD
     C+ set LOGENT= :TMST, LOGEND = :TMSD
     C+ where LOGINC = :INCR
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '122'
     C                   exsr      *pssr
     C                   Endif


      *--C-O-M-P-L-E-T-E--------------------------------------------------------
     C                   when      MODE = '*COMPLETE '

      * Set start time and date
     C                   TIME                    ##TME

     C/exec SQL
     C+ update SMMIGRTD
     C+ set MIGENT= :TMST, MIGEND = :TMSD, MIGSTS = 'C'
     C+ where MIGINC = :INCR
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '102'
     C                   exsr      *pssr
     C                   Endif


      *--F-A-I-L----------------------------------------------------------------
     C                   when      MODE = '*FAIL     '

      * Set start time and date
     C                   TIME                    ##TME

     C/exec SQL
     C+ update SMMIGRTD
     C+ set MIGENT= :TMST, MIGEND = :TMSD, MIGSTS = 'F'
     C+ where MIGINC = :INCR
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '103'
     C                   exsr      *pssr
     C                   Endif

     C                   when      MODE = '*RESTART  '

     C/exec SQL
     C+ update SMMIGRTD
     C+ set MIGSTT= ' ', MIGSTD = ' ', MIGSTS = ' '
     C+ where MIGINC = :INCR
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '104'
     C                   exsr      *pssr
     C                   Endif

      *--F-I-N-I-S-H------------------------------------------------------------
     C                   when      MODE = '*FINISH   '


     C                   Endsl


     C     EndTag        Tag
     C                   Seton                                        LR
     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   eval      RETURN = '*Error'
     C                   RETURN

     C                   ENDSR
      *****************************************************************
