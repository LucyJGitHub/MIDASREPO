     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTM prepare components table')                *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SM8002 - Midas SM Prepare components table                   *
      *                                                               *
      *  Function: This program outputs in SMMIGRTD with all          *
      *            migration components needed based on input.        *
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
     D RcdCount        S              5  0
     D MAXI            S              5  0
     D GLOBM           S              1A
     D ZONEM           S              1A

       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    RETURN           10

     C                   eval      RETURN = *blanks


      * first clear migration work table
     C/exec SQL
     C+ delete from SMMIGRTD
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   eval      DBASE = '100'
     C                   exsr      *pssr
     C                   Endif

      * check what layer was selected for migration
     C/exec SQL
     C+ select DMIGGB, DMIGZN into :GLOBM, :ZONEM
     C+ from SMOTMMTD
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '101'
     C                   exsr      *pssr
     C                   Endif

      * add components for the seleted layer
     C                   If        GLOBM = 'Y'
     C/exec SQL
     C+ insert into SMMIGRTD
     C+ (MIGINC, MIGCMP, MIGSEQ, MIGDES, MIGPGM, MIGPAR, MIGBYP, MIGLYR,
     C+  MIGSTS, MIGSTT, MIGSTD, MIGENT, MIGEND)
     C+  select 0, OTMCMP, OTMSEQ, OTMDES, OTMPGM, OTMPAR, OTMBYP, OTMLYR,
     C+  ' ', ' ', ' ', ' ', ' '
     C+ from SMOTCJW0 where OTMLYR = '*GLOBAL' and OTMRUN = 'Y'
     C+ order by OTMSEQ
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '102'
     C                   exsr      *pssr
     C                   Endif
     C                   ENDIF

     C                   If        ZONEM = 'Y'
     C/exec SQL
     C+ insert into SMMIGRTD
     C+ (MIGINC, MIGCMP, MIGSEQ, MIGDES, MIGPGM, MIGPAR, MIGBYP, MIGLYR,
     C+  MIGSTS, MIGSTT, MIGSTD, MIGENT, MIGEND)
     C+  select 0, OTMCMP, OTMSEQ, OTMDES, OTMPGM, OTMPAR, OTMBYP, OTMLYR,
     C+  ' ', ' ', ' ', ' ', ' '
     C+ from SMOTCJW0 where OTMLYR = '*ZONE' and OTMRUN = 'Y'
     C+ order by OTMSEQ
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '103'
     C                   exsr      *pssr
     C                   Endif
     C                   ENDIF

     C                   If        GLOBM = 'Y' or ZONEM = 'Y'
      * if at least one layer was selected, adjust now the increment field
     C/exec SQL
     C+ update smmigrtd set miginc = rrn(smmigrtd)
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '104'
     C                   exsr      *pssr
     C                   Endif

      * set 'Number of component'
     C/exec SQL
     C+ select max(MIGINC) into :MAXI
     C+ from smmigrtd
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '105'
     C                   exsr      *pssr
     C                   Endif
     C/exec SQL
     C+ update SMOTMMTD set DNOCMP = :MAXI
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '111'
     C                   exsr      *pssr
     C                   Endif

     C                   ENDIF

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
