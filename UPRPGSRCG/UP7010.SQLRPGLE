     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTR initialize')                              *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP7010 - Midas UP OTR initialize                             *
      *                                                               *
      *  Function: This program allows initialization of 3 system     *
      *            values that are needed for the refresh to run      *
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
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index.                                            *
      *                                                               *
      *  *INZSR - Initial processing                                  *
      *  NonDisplay - Set on indicators to not display fields         *
      *  Exit - Exit program                                          *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Display File
     FUP7010GF  CF   E             WORKSTN

      ** Declared Variables
     D ErrInd          S             10A
     D LIBDM           S             10A
     D LIBGM           S             10A
     D DBASE           S              3A

      ** ZASNMS Variables
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
      ** Error Indicators
     D ErIOff          S             15
     D ErrFlg          S              1
      ** CBTIME Parameters
     D DayNoa          S              5
     D STime           S              6
     D DFmt            S              1
      ** ZDATE2 Parameters
     D CurrDt          S              5  0
     D WQ0003          S              6  0
     D ZDate           S              7
     D etc             S              3


      ** Program data structure
     D MyPSDS         SDS
     D DFPGMQ                  1     10
     D DFJOBN                244    253
     D DFDUSR                254    263
     D DFJBNO                264    269S 0
     D DFJBNC                264    269
       /EJECT
      *****************************************************************

     C                   eval      ErrInd = 'Y'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   WRITE     UP7010F0

     C                   seton                                        28
     C                   WRITE     UP7010C1

     C                   EXFMT     UP7010F1

     C                   EXSR      CLEAR
     C                   setoff                                       515253

      * *B library
      * Validate that library entered is non blank
     C                   If        #BRGLIB = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7007'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        51
     C                   EXSR      ZASNMS
     C                   else

      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      #BRGLIB       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        51
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7004'
     C                   EVAL      ZAMSDA = #BRGLIB
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that library has 'B' suffix
     C                   if        %subst(#BRGLIB:10:1) <> 'B'
     C                   seton                                        51
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7006'
     C                   EVAL      ZAMSDA = #BRGLIB
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * Global prefix
      * Validate that prefix entered is non blank
     C                   If        #GLBPFX = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7008'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        52
     C                   EXSR      ZASNMS
     C                   else

      * Check that GM library exists
     C                   eval      LIBGM = #GLBPFX + 'GMLIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      LIBGM         P2OBNM
     C                   PARM      '*LIBL'       P2TLIB
     C                   PARM      '*LIB'        P2OBTP
     C                   PARM      *blanks       CHKMBR

      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        52
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7004'
     C                   EVAL      ZAMSDA = LIBGM
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF

      * Zone prefix
      * Validate that prefix entered is non blank
     C                   If        #ZONPFX = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7008'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        53
     C                   EXSR      ZASNMS
     C                   else

      * Check that GM library exists
     C                   eval      LIBDM = #ZONPFX + 'DMLIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      LIBGM         P2OBNM
     C                   PARM      '*LIBL'       P2TLIB
     C                   PARM      '*LIB'        P2OBTP
     C                   PARM      *blanks       CHKMBR

      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        53
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7004'
     C                   EVAL      ZAMSDA = LIBDM
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

      * Redisplay screen to confirm
     C                   WRITE     UP7010F0
     C                   seton                                        2128
     C                   WRITE     UP7010C1
     C                   EXFMT     UP7010F1

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

      ** Update the system values
     C/exec SQL
     C+ update GPSVLXTD set GIVAL = :#BRGLIB
     C+   where GISVAL = 'BrgDeliveredBrgLib'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '001'
     C                   exsr      *pssr
     C                   ENDIF

     C/exec SQL
     C+ update GPSVLXTD set GIVAL = :#GLBPFX
     C+   where GISVAL = 'BrgMidasGlobalPrefix'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '002'
     C                   exsr      *pssr
     C                   ENDIF

     C/exec SQL
     C+ update SDSVLXTD set GIVAL = :#BRGLIB
     C+   where GISVAL = 'BrgDeliveredBrgLib'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '003'
     C                   exsr      *pssr
     C                   ENDIF

     C/exec SQL
     C+ update SDSVLXTD set GIVAL = :#GLBPFX
     C+   where GISVAL = 'BrgMidasGlobalPrefix'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '004'
     C                   exsr      *pssr
     C                   ENDIF

     C/exec SQL
     C+ update SDSVLXTD set GIVAL = :#ZONPFX
     C+   where GISVAL = 'BrgMidasSystemPrefix'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '005'
     C                   exsr      *pssr
     C                   ENDIF

      ** End of program.
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      *                                                               *
      *  *INZSR - Initial processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    Error            10

     C     INZSRE        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Exit - Exit program                                          *
      *                                                               *
      *****************************************************************
     C     Exit          BEGSR

     C                   eval      Error = '*Exit '
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C     ExitE         ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS - Send message to program's message queue             *
      *                                                               *
      *****************************************************************
      *
     C     ZASNMS        BEGSR

     C                   IF        ZAPGMQ = *BLANK
     C                   EVAL      ZAPGMQ = DFPGMQ
     C                   END

     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP

     C     ZAEXIT        ENDSR

      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Clear - Clear the error messages on the subfile               *
      *                                                               *
      *****************************************************************
     C     Clear         BEGSR

     C                   CALL      'Y2CLMSC'
     C                   PARM      DFPGMQ        ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL

     C     ClearE        ENDSR

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
     C                   eval      Error = '*Error'
     C                   RETURN

     C                   ENDSR
      *****************************************************************
