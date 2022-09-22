     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GO update GOZONETD')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO000021 - Midas GO update GOZONETD                          *
      *                                                               *
      *  Function: This program runs during initialization of One     *
      *            Touch Bridge - migration and writes in the temp-   *
      *            orary GOZONETD that is used later during migration.*
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CUP046 *CREATE     Date 01Jun22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP046 - One Touch Bridge - migration                        *
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
     C                   PARM                    X_ZONE           10
     C                   PARM                    X_CODE            4
     C                   PARM                    X_DESC           50
     C                   PARM                    X_ACMV            3 0


      * remove record is any
     C/EXEC SQL
     C+ delete from GOZONETD
     C/END-EXEC
     C                   If        SQLCode <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   eval      DBASE = '101'
     C                   exsr      *pssr
     C                   Endif

      * check active
     C/exec SQL
     C+ insert into GOZONETD
     C+ (
     C+   GOZONE
     C+ , GOCODE
     C+ , GODESC
     C+ , GORDAY
     C+ )
     C+ values
     C+ (
     C+   :X_ZONE
     C+ , :X_CODE
     C+ , :X_DESC
     C+ , :X_ACMV
     C+ )
     C/end-exec
     C                   If        SQLCode <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   eval      DBASE = '102'
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
     C                   RETURN

     C                   ENDSR
      *****************************************************************
