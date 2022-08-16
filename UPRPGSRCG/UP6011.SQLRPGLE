     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTU System Values validity checker')          *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP6011 - Midas UP OTU system values validity checker         *
      *                                                               *
      *  Function: This program checks are reports system values      *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CUP044 *CREATE     Date 22May22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP044 - One Touch Bridge Automation Changes - Release/      *
      *           Patch Upgrade                                       *
      *                                                               *
      *****************************************************************
     FUP6011P1  O    E             PRINTER OFLIND(*IN37)
      /EJECT

     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     D RcdCount        S              5  0

     D ArrLyr          S              2    DIM(11)
     D XVAL            S            200
     D LAYER           S              7A
     D Idx             S              2S 0
     D UPOPFX        E DS                  EXTNAME(UPOPFXTD)
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    PRFX              2
     C                   PARM                    RETURN           10

     C                   eval      RETURN = *blanks

      * Determine if prefix is *GLOBAL or *ZONE
      * Retrieve layers from UPOPFXTD
     C/exec SQL
     C+ select * into :UPOPFX
     C+ from UPOPFXTD
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      RETURN = '*ERROR'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      ArrLyr(1) = GPRFX
     C                   eval      ArrLyr(2) = ZPFX1
     C                   eval      ArrLyr(3) = ZPFX2
     C                   eval      ArrLyr(4) = ZPFX3
     C                   eval      ArrLyr(5) = ZPFX4
     C                   eval      ArrLyr(6) = ZPFX5
     C                   eval      ArrLyr(7) = ZPFX6
     C                   eval      ArrLyr(8) = ZPFX7
     C                   eval      ArrLyr(9) = ZPFX8
     C                   eval      ArrLyr(10) =ZPFX9
     C                   eval      ArrLyr(11) =ZPFX0

     C                   eval      Idx = %LOOKUP(PRFX : ArrLyr)
     C                   If        Idx = 0
     C                   exsr      *pssr
     C                   else
     C                   If        Idx = 1
     C                   eval      Layer = '*GLOBAL'
     C                   eval      R_LAYR = '*GLOBAL' + ' - ' + PRFX
     C                   else
     C                   eval      Layer = '*ZONE'
     C                   eval      R_LAYR = '*ZONE' + ' - ' + PRFX
     C                   Endif
     C                   Endif

      * Write main page header.
     C                   WRITE     HEADH
     C                   WRITE     HEADER
      * if '*GLOBAL'
     C                   If        Layer = '*GLOBAL'
      * check 'BrgDeliveredBrgLib'
     C                   eval      XVAL = *blank
     C/exec SQL
     C+ select GIVAL into :XVAL
     C+ from GPSVLXTD where GISVAL = 'BrgDeliveredBrgLib'
     C/end-exec
     C                   eval      R_GISVAL = 'BrgDeliveredBrgLib'
     C                   eval      R_GIVAL = XVAL
     C                   WRITE     DETAIL
     C                   If        SQLCode = 0 and XVAL = *blanks
     C                   eval      R_ERR = 'System Value not set.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   ENDIF
     C                   If        SQLCode = 100
     C                   eval      R_ERR = 'System Value not found.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   ENDIF
     C                   If        SQLCode <> 100 and SQLCode <> 0
     C                   eval      R_ERR = 'Error checking System Value.' +
     C                             ' See dump produced.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   exsr      *pssr
     C                   ENDIF

      * check 'BrgDeliveredDtaLib'
     C                   eval      XVAL = *blank
     C/exec SQL
     C+ select GIVAL into :XVAL
     C+ from GPSVLXTD where GISVAL = 'BrgDeliveredDtaLib'
     C/end-exec
     C                   eval      R_GISVAL = 'BrgDeliveredDtaLib'
     C                   eval      R_GIVAL = XVAL
     C                   WRITE     DETAIL
     C                   If        SQLCode = 0 and XVAL = *blanks
     C                   eval      R_ERR = 'System Value not set.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   ENDIF
     C                   If        SQLCode = 100
     C                   eval      R_ERR = 'System Value not found.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   ENDIF
     C                   If        SQLCode <> 100 and SQLCode <> 0
     C                   eval      R_ERR = 'Error checking System Value.' +
     C                             ' See dump produced.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   exsr      *pssr
     C                   ENDIF

      * check 'BrgDeliveredSrcLib'
     C                   eval      XVAL = *blank
     C/exec SQL
     C+ select GIVAL into :XVAL
     C+ from GPSVLXTD where GISVAL = 'BrgDeliveredSrcLib'
     C/end-exec
     C                   eval      R_GISVAL = 'BrgDeliveredSrcLib'
     C                   eval      R_GIVAL = XVAL
     C                   WRITE     DETAIL
     C                   If        SQLCode = 0 and XVAL = *blanks
     C                   eval      R_ERR = 'System Value not set.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   ENDIF
     C                   If        SQLCode = 100
     C                   eval      R_ERR = 'System Value not found.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   ENDIF
     C                   If        SQLCode <> 100 and SQLCode <> 0
     C                   eval      R_ERR = 'Error checking System Value.' +
     C                             ' See dump produced.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   exsr      *pssr
     C                   ENDIF

     C                   Endif

      * if '*ZONE'
     C                   If        Layer = '*ZONE'
      * check 'BrgDeliveredBrgLib'
     C                   eval      XVAL = *blank
     C/exec SQL
     C+ select GIVAL into :XVAL
     C+ from SDSVLXTD where GISVAL = 'BrgDeliveredBrgLib'
     C/end-exec
     C                   eval      R_GISVAL = 'BrgDeliveredBrgLib'
     C                   eval      R_GIVAL = XVAL
     C                   WRITE     DETAIL
     C                   If        SQLCode = 0 and XVAL = *blanks
     C                   eval      R_ERR = 'System Value not set.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   ENDIF
     C                   If        SQLCode = 100
     C                   eval      R_ERR = 'System Value not found.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   ENDIF
     C                   If        SQLCode <> 100 and SQLCode <> 0
     C                   eval      R_ERR = 'Error checking System Value.' +
     C                             ' See dump produced.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   exsr      *pssr
     C                   ENDIF

      * check 'BrgDeliveredDtaLib'
     C                   eval      XVAL = *blank
     C/exec SQL
     C+ select GIVAL into :XVAL
     C+ from SDSVLXTD where GISVAL = 'BrgDeliveredDtaLib'
     C/end-exec
     C                   eval      R_GISVAL = 'BrgDeliveredDtaLib'
     C                   eval      R_GIVAL = XVAL
     C                   WRITE     DETAIL
     C                   If        SQLCode = 0 and XVAL = *blanks
     C                   eval      R_ERR = 'System Value not set.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   ENDIF
     C                   If        SQLCode = 100
     C                   eval      R_ERR = 'System Value not found.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   ENDIF
     C                   If        SQLCode <> 100 and SQLCode <> 0
     C                   eval      R_ERR = 'Error checking System Value.' +
     C                             ' See dump produced.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   exsr      *pssr
     C                   ENDIF

      * check 'BrgDeliveredSrcLib'
     C                   eval      XVAL = *blank
     C/exec SQL
     C+ select GIVAL into :XVAL
     C+ from SDSVLXTD where GISVAL = 'BrgDeliveredSrcLib'
     C/end-exec
     C                   eval      R_GISVAL = 'BrgDeliveredSrcLib'
     C                   eval      R_GIVAL = XVAL
     C                   WRITE     DETAIL
     C                   If        SQLCode = 0 and XVAL = *blanks
     C                   eval      R_ERR = 'System Value not set.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   ENDIF
     C                   If        SQLCode = 100
     C                   eval      R_ERR = 'System Value not found.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   ENDIF
     C                   If        SQLCode <> 100 and SQLCode <> 0
     C                   eval      R_ERR = 'Error checking System Value.' +
     C                             ' See dump produced.'
     C                   WRITE     ERROR
     C                   eval      RETURN = '*INVALID'
     C                   exsr      *pssr
     C                   ENDIF

     C                   ENDIF

      * Write trailer and end program.
     C                   WRITE     TRAILP

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
     C                   eval      RETURN = '*ERROR'
     C                   RETURN

     C                   ENDSR
      *****************************************************************
