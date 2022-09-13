     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTR system value validity checker')           *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP7011 - Midas UP OTR system value validity checker          *
      *                                                               *
      *  Function: This program checks anrd report system values      *
      *            used for the refresh.                              *
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
     FUP7011P1  O    E             PRINTER OFLIND(*IN37)
      /EJECT

     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     D RcdCount        S              5  0

     D XVAL            S            200
     D LAYER           S              7A
     D DBASE           S              3A
     D Idx             S              2S 0
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
     C/exec SQL
     C+ select DLAYRS into :LAYER
     C+ from UPOTRMTD
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      RETURN = '*ERROR'
     C                   eval      DBASE = '100'
     C                   exsr      *pssr
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
     C                   eval      DBASE = '101'
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
     C                   eval      DBASE = '102'
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
     C                   eval      DBASE = '103'
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
     C                   eval      DBASE = '104'
     C                   exsr      *pssr
     C                   ENDIF

      * check 'BrgMidasGlobalPrefix'
     C                   eval      XVAL = *blank
     C/exec SQL
     C+ select GIVAL into :XVAL
     C+ from SDSVLXTD where GISVAL = 'BrgMidasGlobalPrefix'
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
     C                   eval      DBASE = '105'
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
     C                   eval      DBASE = '106'
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
     C                   eval      DBASE = '107'
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
