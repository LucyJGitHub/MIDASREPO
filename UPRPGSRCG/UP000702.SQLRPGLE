     H DEBUG
     H COPYRIGHT('(c) Finastra International 2019')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - Initialize GPWIPBTD and GPWIPXTD')          *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000702 - This program initializes Extension and Bespoke    *
      *             files.                                            *
      *                                                               *
      *  (c) Finastra International 2019                              *
      *                                                               *
      *  Last Amend No. MD054209   *CREATE   Date 07Sep19             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054209 - Deliverable Data Split for T_WIPCF                *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    ERROR            10

      * Add GPWIPXTD records with *REFZONE (core)

     C/exec SQL
     C+ insert into GPWIPXTD
     C+ (SELECT WC_ID,
     C+ WC_API, WC_BONSTP, WC_BOASTP,
     C+ WC_AUTLVL, WC_ZONE, 'C'
     C+ FROM GPWIPCTD A where A.WC_ZONE = '*REFZONE'
     C+ and not exists (select * from GPWIPXTD B
     C+ where A.WC_API = B.WC_API and B.WC_ZONE = '*REFZONE'))
     C/end-exec
     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   Endif

      * Add GPWIPBTD records with zone (bespoke)

     C/exec SQL
     C+ insert into GPWIPBTD
     C+ OVERRIDING USER VALUE
     C+ (SELECT WC_ID,
     C+ WC_API, WC_CAT, WC_BONSTP, WC_BOASTP, WC_BOAC, WC_BOACNE,
     C+ WC_BOACAM, WC_BOACAU, WC_BOACCL, WC_BOACDE, WC_BOACRE,
     C+ WC_BOACCH, WC_AUTOA, WC_AUTLVL, ZOZONE as WC_ZONE,
     C+ WC_SYSTEM, WC_BOFLD1, WC_BOFLD2, WC_BOFLD3, WC_BOFLD4,
     C+ WC_BOFLD5, 'B' FROM GPWIPCTD A, GPZONEPD
     C+ where A.WC_ZONE = '*REFZONE' and not exists
     C+ (select * from GPWIPBTD B where A.WC_API = B.WC_API))
     C/end-exec

     C                   IF        SQLCODE <> 0
     C                   EVAL      ERROR = '*ERROR*'
     C                   ENDIF

      * Add GPWIPXTD records with zone (bespoke) in case new API

     C/exec SQL
     C+ insert into GPWIPXTD
     C+ (SELECT WC_ID,
     C+ WC_API, WC_BONSTP, WC_BOASTP,
     C+ WC_AUTLVL, WC_ZONE, 'B'
     C+ FROM GPWIPBTD A where
     C+ not exists (select * from GPWIPXTD B
     C+ where A.WC_API = B.WC_API and B.WC_ZONE <> '*REFZONE'))
     C/end-exec
     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   Endif

     C                   Seton                                        LR
     C                   Return

      *****************************************************************

