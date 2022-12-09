     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTR check refresh is complete')               *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP700043 - Midas UP OTR check refresh is complete            *
      *                                                               *
      *  Function: This program checks if refresh is complete by      *
      *            retrieving number of SUBMIT, ACTIVE and FAILED     *
      *            from SMCPYDPD.                                     *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CUP045 *CREATE     Date 09Dec22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP045 - One Touch Bridge - refresh                          *
      *         - Applied for MD060769.                               *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D SubN            S              5  0
     D ActN            S              5  0
     D FaiN            S              5  0
     D DBASE           S              3A
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    PSubmit           6
     C                   PARM                    PActive           6
     C                   PARM                    PFailed           6

     C                   eval      PSubmit = *blanks
     C                   eval      PACtive = *blanks
     C                   eval      PFailed = *blanks

      * check submit
     C/EXEC SQL
     C+ select count(*) into :SubN   from SMCPYDPD
     C+ where ODDDAT = 'SUBMIT'
     C/END-EXEC
     C                   If        SQLCode <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   eval      DBASE = '101'
     C                   exsr      *pssr
     C                   Endif

      * check active
     C/EXEC SQL
     C+ select count(*) into :ActN   from SMCPYDPD
     C+ where ODDDAT = 'ACTIVE'
     C/END-EXEC
     C                   If        SQLCode <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   eval      DBASE = '102'
     C                   exsr      *pssr
     C                   Endif

      * check failed
     C/EXEC SQL
     C+ select count(*) into :FaiN   from SMCPYDPD
     C+ where ODDDAT = 'FAILED'
     C/END-EXEC
     C                   If        SQLCode <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   eval      DBASE = '103'
     C                   exsr      *pssr
     C                   Endif

     C                   EVAL      PSubmit = %EDITC(SubN:'1')
     C                   EVAL      PActive = %EDITC(ActN:'1')
     C                   EVAL      PFailed = %EDITC(FaiN:'1')

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
     C                   RETURN

     C                   ENDSR
      *****************************************************************
