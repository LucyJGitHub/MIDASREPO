     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTR check for copy option')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP700042 - Midas UP OTR check for copy option                *
      *                                                               *
      *  Function: This program checks if special copy options are to *
      *            be used. It checks UPDLVCPD.                       *
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

     D DBASE           S              3A

       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    COPYOPT          10
     C                   PARM                    OBJECT           10
     C                   PARM                    RETURN           10

     C                   eval      COPYOPT = *blanks
     C                   eval      RETURN = *blanks

      * check if copy option is specified
     C/EXEC SQL
     C+ select AUFMTO into :COPYOPT from UPDLVCPD
     C+ where AUMBNM = :OBJECT and (AUMBTP = 'PF' or AUMBTP = 'SQLTBL')
     C/END-EXEC
     C                   If        SQLCode <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   eval      DBASE = '100'
     C                   exsr      *pssr
     C                   Endif
     C                   If        SQLCode = SQLOK
     C                   goto      EndTag
     C                   Endif

      * check if file is made redundant, in which case, no copy should be done
     C/EXEC SQL
     C+ select AUFMTO into :COPYOPT from UPDLVCPD
     C+ where AUMBNM = :OBJECT and (AUMBTP = 'XXPF' or AUMBTP = 'XXSQLTBL')
     C+ and (AUSRCF like '%DM' or AUSRCF like'%GM')
     C/END-EXEC
     C                   If        SQLCode <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   eval      DBASE = '101'
     C                   exsr      *pssr
     C                   Endif
     C                   If        SQLCode = 0
     C                   eval      COPYOPT = 'S*NOCOPY'
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
