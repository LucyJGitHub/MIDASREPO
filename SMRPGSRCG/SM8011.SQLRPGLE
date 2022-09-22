     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTU System Values validity checker')          *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SM8011 - Midas UP OTU system values validity checker         *
      *                                                               *
      *  Function: This program checks are reports system values      *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CUP044 *CREATE     Date 22May22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP044 - One Touch Bridge - upgrade                          *
      *                                                               *
      *****************************************************************
     FSM8011P1  O    E             PRINTER OFLIND(*IN37)
      /EJECT

     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     D RcdCount        S              5  0

     D ArrLyr          S              2    DIM(11)
     D XVAL            S            200
     D LAYER           S              7A
     D Idx             S              2S 0
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    Layer             7
     C                   PARM                    RETURN           10

     C                   eval      RETURN = *blanks

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

      * check 'BrgDeliveredStrPrLib'
     C                   eval      XVAL = *blank
     C/exec SQL
     C+ select GIVAL into :XVAL
     C+ from GPSVLXTD where GISVAL = 'BrgDeliveredStrPrLib'
     C/end-exec
     C                   eval      R_GISVAL = 'BrgDeliveredStrPrLib'
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

      * check 'BrgMidasGlobalPrefix'
     C                   eval      XVAL = *blank
     C/exec SQL
     C+ select GIVAL into :XVAL
     C+ from GPSVLXTD where GISVAL = 'BrgMidasGlobalPrefix'
     C/end-exec
     C                   eval      R_GISVAL = 'BrgMidasGlobalPrefix'
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

      * check 'BrgOldGlobalPrefix'
     C                   eval      XVAL = *blank
     C/exec SQL
     C+ select GIVAL into :XVAL
     C+ from GPSVLXTD where GISVAL = 'BrgOldGlobalPrefix'
     C/end-exec
     C                   eval      R_GISVAL = 'BrgOldGlobalPrefix'
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

      * check 'BrgOldSystemRlsLvl'
     C                   eval      XVAL = *blank
     C/exec SQL
     C+ select GIVAL into :XVAL
     C+ from GPSVLXTD where GISVAL = 'BrgOldSystemRlsLvl'
     C/end-exec
     C                   eval      R_GISVAL = 'BrgOldSystemRlsLvl'
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

      * check 'BrgDeliveredStrPrLib'
     C                   eval      XVAL = *blank
     C/exec SQL
     C+ select GIVAL into :XVAL
     C+ from SDSVLXTD where GISVAL = 'BrgDeliveredStrPrLib'
     C/end-exec
     C                   eval      R_GISVAL = 'BrgDeliveredStrPrLib'
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

      * check 'BrgMidasSystemPrefix'
     C                   eval      XVAL = *blank
     C/exec SQL
     C+ select GIVAL into :XVAL
     C+ from SDSVLXTD where GISVAL = 'BrgMidasSystemPrefix'
     C/end-exec
     C                   eval      R_GISVAL = 'BrgMidasSystemPrefix'
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

      * check 'BrgOldZonePrefix'
     C                   eval      XVAL = *blank
     C/exec SQL
     C+ select GIVAL into :XVAL
     C+ from SDSVLXTD where GISVAL = 'BrgOldZonePrefix'
     C/end-exec
     C                   eval      R_GISVAL = 'BrgOldZonePrefix'
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

      * check 'BrgOldSystemRlsLvl'
     C                   eval      XVAL = *blank
     C/exec SQL
     C+ select GIVAL into :XVAL
     C+ from GPSVLXTD where GISVAL = 'BrgOldSystemRlsLvl'
     C/end-exec
     C                   eval      R_GISVAL = 'BrgOldSystemRlsLvl'
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
