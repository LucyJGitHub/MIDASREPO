     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTR update monitor work table')               *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP8008 - Midas UP monitor work table                         *
      *                                                               *
      *  Function: This program writes and update the table used for  *
      *            monitoring the refresh.                            *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD060979           Date 27Jan23               *
      *  Prev Amend No. CUP045 *CREATE     Date 01Jun22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060979 - Monitor does not refresh                          *
      *  CUP045 - One Touch Bridge - refresh                          *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     D RcdCount        S              5  0

     D ArrLyr          S              2    DIM(11)
     D X_LYR           S              1A
     D Ix              S              2S 0
     D NoCmp           S              3S 0
     D RETURN          S             10A
     D DBASE           S              3A
     D TSTMT           S               Z                                                    MD060979
     D TSTMTA          S             30A                                                    MD060979
     D ##TMEDS         DS
     D   TMST                  1      6
     D   TMSD                  7     12
     D   TM12                  1     12                                                     MD060979
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
     C                   PARM                    RETURN           10

     C                   eval      RETURN = *blanks

     C                   Select

      *--S-T-A-R-T--------------------------------------------------------------
     C                   when      MODE = '*START    '

      * Set start time and date
     C                   TIME                    ##TME

     C/exec SQL
     C+ update SMMIGRTD
     C+ set MIGSTT= :TMST, MIGSTD = :TMSD, MIGSTS = 'R'
     C+ where MIGINC = :INCR
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '101'
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

      * and update number of component completed
     C/exec SQL
     C+ update SMOTMMTD
     C+ set DNOCMC = DNOCMC + 1
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '105'
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
     C+ set MIGSTT= ' ', MIGSTD = ' ', MIGSTS = ' ',
     C+     MIGENT= ' ', MIGEND = ' '
     C+ where MIGINC = :INCR
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '104'
     C                   exsr      *pssr
     C                   Endif

      *--F-I-N-I-S-H------------------------------------------------------------
     C                   when      MODE = '*FINISH   '

     C                   TIME                    ##TME
     C/exec SQL
     C+ update SMOTMMTD
     C+ set DENDTM = :TMST, DENDDT = :TMSD
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '107'
     C                   exsr      *pssr
     C                   Endif

      *--H-A-L-T----------------------------------------------------------------
     C                   when      MODE = '*HALT     '

     C                   TIME                    ##TME
     C/exec SQL
     C+ update SMOTMMTD
     C+ set DMIGHT = 'Y'
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '127'
     C                   exsr      *pssr
     C                   Endif

      *--L-A-Y-E-R--------------------------------------------------------------
     C                   when      MODE = '*LAYER    '

     C                   If        INCR = 1
     C                   eval      X_LYR = 'G'
     C                   else
     C                   eval      X_LYR = 'Z'
     C                   ENDIF
     C/exec SQL
     C+ update SMOTMMTD
     C+ set DACTLY = :X_LYR
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '137'
     C                   exsr      *pssr
     C                   Endif

     C                   Endsl

      * finally update timestamp for monitor refresh
     C                   TIME                    ##TME
     C                   TIME                    TSTMT                                      MD060979
     C                   eval      TSTMTA = %char(TSTMT:*ISO)                               MD060979
     C                   eval      TM12 = %subst(TSTMTA:12:12)                              MD060979
     C/exec SQL
     C+ update SMOTMMTD
     C**set*DUTMST = :TMST                                                                  MD060979
     C+ set DUTMST = :TM12                                                                  MD060979
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '106'
     C                   exsr      *pssr
     C                   Endif

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
