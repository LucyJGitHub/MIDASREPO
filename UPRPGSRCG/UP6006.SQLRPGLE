     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTU restore package libraries')               *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP6006 - Midas UP OTU restore package libraries              *
      *                                                               *
      *  Function: This program displays screen to allow package      *
      *            libraries to be restored.                          *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD061544           Date 27Jun23               *
      *  Prev Amend No. MD060386           Date 22Aug22               *
      *                 MD060362           Date 19Aug22               *
      *                 CUP044 *CREATE     Date 22May22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061544 - Allow CPF messages while restoring as long as     *
      *             all objects have been restored                    *
      *  MD060386 - 1) monitor authority issues when restoring, 2)    *
      *             correct library name for *U library               *
      *  MD060362 - DSPF does not compile                             *
      *  CUP044 - One Touch Bridge Automation Changes - Release/      *
      *           Patch Upgrade                                       *
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
     FUP6006GF  CF   E             WORKSTN

      ** Declared Variables
     D ErrInd          S             10A
     D SAVF            S             10A
     D DBASE           S              3A
     D Member          S             10A
     D sqlStat         S           5000A
      ** ZASNMS Variables
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
      ** CBTIME Parameters
     D DayNoa          S              5
     D STime           S              6
     D DFmt            S              1
      ** ZDATE2 Parameters
     D CurrDt          S              5  0
     D WQ0003          S              6  0
     D ZDate           S              7

     D Cmd_String      S            200
     D Cmd_Len         S             15  5
     D X_CHK           S              2                                                     MD060386
     D pos             S              5  0                                                  MD060386

     D ZONE          E DS                  EXTNAME(GPZONEPD)

     D C_DOTA          C                   Const('Enter library name where the-             MD060362
     D                                     se save files are placed. Each save-             MD060362
     D                                      file contains')                                 MD060362
     D C_DOTB          C                   Const('one installation library tha-             MD060362
     D                                     t will be restored:')                            MD060362
                                                                                            MD060362
      ** Program data structure
     D MyPSDS         SDS
     D DFPGMQ                  1     10
     D DFJOBN                244    253
     D DFDUSR                254    263
     D DFJBNO                264    269S 0
     D DFJBNC                264    269
      **  Exception type
     D PSExcpType             40     42
      **  Exception number
     D PSExcpNo               43     46
     **  Exception data
     D PSExcpData             91    170                                                     MD060386
                                                                                            MD060386
      **  Exception Id                                                                      MD060386
     D PSExcpID              171    174                                                     MD060386
       /EJECT
      *****************************************************************

      ** Handle package name
     C                   exsr      Sr_Package

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF


      ** Handle library names
     C                   exsr      Sr_LibInst

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

      ** Proceed with restore

     C                   IF        *INKC = *OFF
     C                   exsr      Sr_LibRest
     C                   ENDIF

      ** End of program.
     C                   EVAL      *INLR = *ON
     C                   RETURN

      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    Error            10

      ** Get the current time.
     C                   CALL      'CBTIME'
     C                   PARM                    DayNoa
     C                   PARM                    STime
     C                   PARM                    DFmt
     C                   MOVE      DayNoa        CurrDt
      *
      ** Convert date to DDMMYY format.
     C                   CALL      'ZDATE2'
     C                   PARM                    CurrDt
     C                   PARM                    DFmt
     C                   PARM                    WQ0003
     C                   PARM      *blanks       ZDate

     C                   EVAL      DFDATE = ZDate

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
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_Package - Request package name                            *
      *                                                               *
      *****************************************************************
     C     Sr_Package    BEGSR

     C                   eval      ErrInd = 'Y'

      * display first part
     C                   setoff                                       19
     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   WRITE     UP6006F0

     C                   seton                                        28
     C                   WRITE     UP6006C1

     C                   EXFMT     UP6006F2

     C                   EXSR      CLEAR
     C                   setoff                                       3031

      * Validate non blank
     C                   If        XCUM  = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6009'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        29
     C                   EXSR      ZASNMS
     C                   ITER
     C                   ENDIF

      * Validate 'Y' or 'N'
     C                   If        XCUM <> 'Y' and XCUM <> 'N'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6009'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        29
     C                   EXSR      ZASNMS
     C                   ITER
     C                   ENDIF

     C                   ENDDO

      * display second part
     C                   eval      ErrInd = 'Y'
     C                   seton                                        19
     C                   If        XCUM = 'Y'
     C                   seton                                        18
     C                   else
     C                   setoff                                       18
     C                   endif

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   WRITE     UP6006F0

     C                   seton                                        28
     C                   WRITE     UP6006C1
     C                   WRITE     UP6006F22

     C                   EXFMT     UP6006F2

     C                   EXSR      CLEAR
     C                   setoff                                       3031

      * Validate that package entered is non blank
     C                   If        XPACK = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6002'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        30
     C                   EXSR      ZASNMS
     C                   ENDIF

     C                   If        XCUM = 'Y'
     C                   If        XPACK2 = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6002'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        31
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF

     C                   If        ErrInd = 'Y'
     C                   ITER
     C                   Endif

      * Validate that package entered is 9 char
     C                   If        %len(%trim(XPACK)) <> 9
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6003'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        30
     C                   EXSR      ZASNMS
     C                   ENDIF

     C                   If        XCUM = 'Y'
     C                   If        %len(%trim(XPACK2)) <> 9
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6003'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        31
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF

     C                   If        ErrInd = 'Y'
     C                   ITER
     C                   Endif

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_LibInst - Request library name for SAVF                   *
      *                                                               *
      *****************************************************************
     C     Sr_LibInst    BEGSR

     C                   eval      ##DOT1 = C_DOTA                                          MD060362
     C                   eval      ##DOT2 = C_DOTB                                          MD060362
     C                   eval      ##DOT3 = C_DOTA                                          MD060362
     C                   eval      ##DOT4 = C_DOTB                                          MD060362
                                                                                            MD060362
      * for non- cumulative package
     C                   If        XCUM = 'N'

      * Protect Package name
     C                   seton                                        20

     C                   eval      ErrInd = 'Y'
     C                   eval      #LIBB = XPACK + 'B - Bridge Library'
     C                   eval      #LIBD = XPACK + 'D - Deliverable Data Lib' +
     C                             'rary'
     C                   eval      #LIBQ = XPACK + 'Q - Stored Procedure Lib' +
     C                             'rary'
     C                   eval      #LIBU = XPACK + 'U - Upgrade Library'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   WRITE     UP6006F0

     C                   seton                                        28
     C                   WRITE     UP6006C1
     C                   WRITE     UP6006F2
     C                   WRITE     UP6006F22

     C                   EXFMT     UP6006F21

     C                   EXSR      CLEAR
     C                   setoff                                       515253
     C                   setoff                                       54

      * *B library
      * Validate that library entered is non blank
     C                   If        #LIBSFB = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6005'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        51
     C                   EXSR      ZASNMS
     C                   else

      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      #LIBSFB       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        51
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = #LIBSFB
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that SAVF exists in the library
     C                   eval      SAVF = XPACK + 'B'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      SAVF          P2OBNM
     C                   PARM      #LIBSFB       P2TLIB
     C                   PARM      '*FILE'       P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        51
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6006'
     C                   EVAL      ZAMSDA = SAVF
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * *D library
      * Validate that library entered is non blank
     C                   If        #LIBSFD = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6005'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        52
     C                   EXSR      ZASNMS
     C                   else

      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      #LIBSFD       P2OBNM
     C                   PARM      '*LIBL'       P2TLIB
     C                   PARM      '*LIB'        P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        52
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = #LIBSFD
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that SAVF exists in the library
     C                   eval      SAVF = XPACK + 'D'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      SAVF          P2OBNM
     C                   PARM      #LIBSFD       P2TLIB
     C                   PARM      '*FILE'       P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        52
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6006'
     C                   EVAL      ZAMSDA = SAVF
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * *Q library
      * Validate that library entered is non blank
      * But it can be blank  as Stored Procedure are not always delivered
     C                   If        #LIBSFQ = *blanks
     C**********         EVAL      ZAMSGF = 'UTMSGF'
     C**********         EVAL      ZAMSID = 'UPM6005'
     C**********         EVAL      ErrInd = 'Y'
     C**********         seton                                        53
     C**********         EXSR      ZASNMS
     C                   else

      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      #LIBSFQ       P2OBNM
     C                   PARM      '*LIBL'       P2TLIB
     C                   PARM      '*LIB'        P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        53
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = #LIBSFQ
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that SAVF exists in the library
     C                   eval      SAVF = XPACK + 'Q'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      SAVF          P2OBNM
     C                   PARM      #LIBSFQ       P2TLIB
     C                   PARM      '*FILE'       P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        53
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6006'
     C                   EVAL      ZAMSDA = SAVF
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * *U library
      * Validate that library entered is non blank
     C                   If        #LIBSFU = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6005'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        54
     C                   EXSR      ZASNMS
     C                   else

      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      #LIBSFU       P2OBNM
     C                   PARM      '*LIBL'       P2TLIB
     C                   PARM      '*LIB'        P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        54
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = #LIBSFU
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that SAVF exists in the library
     C                   eval      SAVF = XPACK + 'U'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      SAVF          P2OBNM
     C                   PARM      #LIBSFU       P2TLIB
     C                   PARM      '*FILE'       P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        54
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6006'
     C                   EVAL      ZAMSDA = SAVF
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

      * for cumulative package
     C                   else
      * Protect Package name
     C                   seton                                        20

     C                   eval      ErrInd = 'Y'
     C                   eval      #LIBCB = XPACK2 + 'B - Cumulative and' +
     C                             ' compatibility Bridge library'
     C                   eval      #LIBCD = XPACK2 + 'D - Cumulative and' +
     C                             ' compatibility Deliverable Data library'
     C                   eval      #LIBCM = XPACK2 + 'M - Cumulative and' +
     C                             ' compatibility Global objects library'
     C                   eval      #LIBCN = XPACK2 + 'N - Cumulative and' +
     C                             ' compatibility Zone objects library'
     C                   eval      #LIBCP = XPACK2 + 'P - Cumulative and' +
     C                             ' compatibility Installer package library'
     C                   eval      #LIBCU = XPACK + 'U - Cumulative Upgrade' +
     C                             ' library'
     C                   eval      #LIBCG = XPACK + 'G - Cumulative Global ' +
     C                             'objects library'
     C                   eval      #LIBCQ = XPACK + 'Q - Cumulative Stored ' +
     C                             'procedures library'
     C                   eval      #LIBCZ = XPACK + 'Z - Cumulative Zone ' +
     C                             'objects library'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   WRITE     UP6006F0

     C                   seton                                        28
     C                   WRITE     UP6006C1
     C                   WRITE     UP6006F2
     C                   WRITE     UP6006F22

     C                   EXFMT     UP6006F23

     C                   EXSR      CLEAR
     C                   eval      %Subarr(*IN : 51 : 10) = *OFF

      * *B library
      * Validate that library entered is non blank
     C                   If        #LIBCBN = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6005'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        51
     C                   EXSR      ZASNMS
     C                   else

      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      #LIBCBN       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        51
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = #LIBCBN
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that SAVF exists in the library
     C                   eval      SAVF = XPACK2 + 'B'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      SAVF          P2OBNM
     C                   PARM      #LIBCBN       P2TLIB
     C                   PARM      '*FILE'       P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        51
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6006'
     C                   EVAL      ZAMSDA = SAVF
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * *D library
      * Validate that library entered is non blank
     C                   If        #LIBCDN = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6005'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        52
     C                   EXSR      ZASNMS
     C                   else

      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      #LIBCDN       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        52
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = #LIBCDN
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that SAVF exists in the library
     C                   eval      SAVF = XPACK2 + 'D'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      SAVF          P2OBNM
     C                   PARM      #LIBCDN       P2TLIB
     C                   PARM      '*FILE'       P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        52
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6006'
     C                   EVAL      ZAMSDA = SAVF
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * *M library
      * Validate that library entered is non blank
     C                   If        #LIBCMN = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6005'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        53
     C                   EXSR      ZASNMS
     C                   else

      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      #LIBCMN       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        53
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = #LIBCMN
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that SAVF exists in the library
     C                   eval      SAVF = XPACK2 + 'M'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      SAVF          P2OBNM
     C                   PARM      #LIBCMN       P2TLIB
     C                   PARM      '*FILE'       P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        53
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6006'
     C                   EVAL      ZAMSDA = SAVF
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * *N library
      * Validate that library entered is non blank
     C                   If        #LIBCNN = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6005'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        54
     C                   EXSR      ZASNMS
     C                   else

      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      #LIBCNN       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        54
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = #LIBCNN
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that SAVF exists in the library
     C                   eval      SAVF = XPACK2 + 'N'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      SAVF          P2OBNM
     C                   PARM      #LIBCNN       P2TLIB
     C                   PARM      '*FILE'       P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        54
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6006'
     C                   EVAL      ZAMSDA = SAVF
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * *P library
      * Validate that library entered is non blank
     C                   If        #LIBCPN = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6005'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        55
     C                   EXSR      ZASNMS
     C                   else

      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      #LIBCPN       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        55
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = #LIBCPN
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that SAVF exists in the library
     C                   eval      SAVF = XPACK2 + 'P'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      SAVF          P2OBNM
     C                   PARM      #LIBCPN       P2TLIB
     C                   PARM      '*FILE'       P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        55
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6006'
     C                   EVAL      ZAMSDA = SAVF
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * *U library
      * Validate that library entered is non blank
     C                   If        #LIBCUN = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6005'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        56
     C                   EXSR      ZASNMS
     C                   else

      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      #LIBCUN       P2OBNM
     C                   PARM      '*LIBL'       P2TLIB
     C                   PARM      '*LIB'        P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        56
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = #LIBCUN
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that SAVF exists in the library
     C                   eval      SAVF = XPACK + 'U'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      SAVF          P2OBNM
     C                   PARM      #LIBCUN       P2TLIB
     C                   PARM      '*FILE'       P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        56
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6006'
     C                   EVAL      ZAMSDA = SAVF
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * *G library
      * Validate that library entered is non blank
     C                   If        #LIBCGN = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6005'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        57
     C                   EXSR      ZASNMS
     C                   else

      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      #LIBCGN       P2OBNM
     C                   PARM      '*LIBL'       P2TLIB
     C                   PARM      '*LIB'        P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        57
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = #LIBCGN
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that SAVF exists in the library
     C                   eval      SAVF = XPACK + 'G'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      SAVF          P2OBNM
     C                   PARM      #LIBCGN       P2TLIB
     C                   PARM      '*FILE'       P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        57
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6006'
     C                   EVAL      ZAMSDA = SAVF
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * *Q library
      * Validate that library entered is non blank
     C                   If        #LIBCQN = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6005'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        58
     C                   EXSR      ZASNMS
     C                   else

      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      #LIBCQN       P2OBNM
     C                   PARM      '*LIBL'       P2TLIB
     C                   PARM      '*LIB'        P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        58
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = #LIBCQN
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that SAVF exists in the library
     C                   eval      SAVF = XPACK + 'Q'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      SAVF          P2OBNM
     C                   PARM      #LIBCQN       P2TLIB
     C                   PARM      '*FILE'       P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        58
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6006'
     C                   EVAL      ZAMSDA = SAVF
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * *Z library
      * Validate that library entered is non blank
     C                   If        #LIBCZN = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6005'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        59
     C                   EXSR      ZASNMS
     C                   else

      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      #LIBCZN       P2OBNM
     C                   PARM      '*LIBL'       P2TLIB
     C                   PARM      '*LIB'        P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        59
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = #LIBCQN
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that SAVF exists in the library
     C                   eval      SAVF = XPACK + 'Z'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      SAVF          P2OBNM
     C                   PARM      #LIBCZN       P2TLIB
     C                   PARM      '*FILE'       P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        59
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6006'
     C                   EVAL      ZAMSDA = SAVF
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

     C                   endif

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_LibRest - Restore libraries from SAVF                     *
      *                                                               *
      *****************************************************************
     C     Sr_LibRest    BEGSR

      * Protect Package name
     C                   seton                                        2021

     C                   EVAL      Cmd_Len = 200

      * for non- cumulative package
     C                   If        XCUM = 'N'

     C                   eval      ErrInd = 'Y'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

      ** Display screen for conformation
     C                   seton                                        2021
     C                   WRITE     UP6006C1
     C                   WRITE     UP6006F2
     C                   WRITE     UP6006F22
     C                   EXFMT     UP6006F21

     C                   setoff                                       515253
     C                   setoff                                       54
      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   EXSR      CLEAR

      * *B library
     C                   eval      PSExcpNo = '    '
     C                   EVAL      Cmd_String = 'RSTLIB SAVLIB(' +
     C                             %trimr(XPACK) + 'B) DEV(*SAVF) SAVF(' +
     C                             %trim(#LIBSFB) + '/' +
     C                             %trimr(XPACK) + 'B) RSTLIB(' +
     C                             %trimr(XPACK) + 'B) OUTPUT(*PRINT)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if CPF3773, allow '0 not restored'                                                 MD060386
     C                   eval      X_CHK = *blanks                                          MD060386
     C                   If        PSExcpNo = '3773'                                        MD060386
     C                   eval      pos = %scan('not restored':PSExcpData:1)                 MD060386
     C                   eval      X_CHK = %subst(PSExcpData:pos-3:2)                       MD060386
     C                   ENDIF                                                              MD060386
                                                                                            MD060386
      ** if error
     C                   If        PSExcpNo <> '    '
     C                             and PSExcpNo <> '3707'                                   MD060386
     C                             and PSExcpNo <> '3773'                                   MD060386
     C                             or PSExcpNo = '3773' and X_CHK <> ' 0'                   MD060386
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6007'
     C                   EVAL      ZAMSDA = %trimr(XPACK) + 'B'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        51
     C                   EXSR      ZASNMS
     C                   Endif

      * *D library
     C                   eval      PSExcpNo = '    '
     C                   EVAL      Cmd_String = 'RSTLIB SAVLIB(' +
     C                             %trimr(XPACK) + 'D) DEV(*SAVF) SAVF(' +
     C                             %trim(#LIBSFD) + '/' +
     C                             %trimr(XPACK) + 'D) RSTLIB(' +
     C                             %trimr(XPACK) + 'D) OUTPUT(*PRINT)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if error
     C                   If        PSExcpNo <> '    '
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6007'
     C                   EVAL      ZAMSDA = %trimr(XPACK) + 'D'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        52
     C                   EXSR      ZASNMS
     C                   Endif

      * *Q library
     C                   if        #LIBSFQ <> *blanks
     C                   eval      PSExcpNo = '    '
     C                   EVAL      Cmd_String = 'RSTLIB SAVLIB(' +
     C                             %trimr(XPACK) + 'Q) DEV(*SAVF) SAVF(' +
     C                             %trim(#LIBSFQ) + '/' +
     C                             %trimr(XPACK) + 'Q) RSTLIB(' +
     C                             %trimr(XPACK) + 'Q) OUTPUT(*PRINT)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if error
     C                   If        PSExcpNo <> '    '
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6007'
     C                   EVAL      ZAMSDA = %trimr(XPACK) + 'Q'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        53
     C                   EXSR      ZASNMS
     C                   Endif
     C                   Endif

      * *U library
     C                   eval      PSExcpNo = '    '
     C                   EVAL      Cmd_String = 'RSTLIB SAVLIB(' +
     C                             %trimr(XPACK) + 'U) DEV(*SAVF) SAVF(' +
     C**********                   %trim(#LIBSFQ) + '/' +                                   MD060386
     C                             %trim(#LIBSFU) + '/' +                                   MD060386
     C                             %trimr(XPACK) + 'U) RSTLIB(' +
     C                             %trimr(XPACK) + 'U) OUTPUT(*PRINT)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if error
     C                   If        PSExcpNo <> '    '
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6007'
     C                   EVAL      ZAMSDA = %trimr(XPACK) + 'U'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        54
     C                   EXSR      ZASNMS
     C                   Endif

     C                   ENDDO

      * for cumulative package
     C                   else

     C                   eval      ErrInd = 'Y'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

      ** Display screen for conformation
     C                   seton                                        2021
     C                   WRITE     UP6006C1
     C                   WRITE     UP6006F2
     C                   WRITE     UP6006F22
     C                   EXFMT     UP6006F23

     C                   eval      %Subarr(*IN : 51 : 10) = *OFF

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   EXSR      CLEAR

      * *B library
     C                   eval      PSExcpNo = '    '
     C                   EVAL      Cmd_String = 'RSTLIB SAVLIB(' +
     C                             %trimr(XPACK2) + 'B) DEV(*SAVF) SAVF(' +
     C                             %trim(#LIBCBN) + '/' +
     C                             %trimr(XPACK2) + 'B) RSTLIB(' +
     C                             %trimr(XPACK2) + 'B) OUTPUT(*PRINT)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if CPF3773, allow '0 not restored'                                                 MD061544
     C                   eval      X_CHK = *blanks                                          MD061544
     C                   If        PSExcpNo = '3773'                                        MD061544
     C                   eval      pos = %scan('not restored':PSExcpData:1)                 MD061544
     C                   eval      X_CHK = %subst(PSExcpData:pos-3:2)                       MD061544
     C                   ENDIF                                                              MD061544
                                                                                            MD061544
      ** if error
     C                   If        PSExcpNo <> '    '
     C                             and PSExcpNo <> '3773'                                   MD061544
     C                             or PSExcpNo = '3773' and X_CHK <> ' 0'                   MD061544
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6007'
     C                   EVAL      ZAMSDA = %trimr(XPACK2) + 'B'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        51
     C                   EXSR      ZASNMS
     C                   Endif

      * *D library
     C                   eval      PSExcpNo = '    '
     C                   EVAL      Cmd_String = 'RSTLIB SAVLIB(' +
     C                             %trimr(XPACK2) + 'D) DEV(*SAVF) SAVF(' +
     C                             %trim(#LIBCDN) + '/' +
     C                             %trimr(XPACK2) + 'D) RSTLIB(' +
     C                             %trimr(XPACK2) + 'D) OUTPUT(*PRINT)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if CPF3773, allow '0 not restored'                                                 MD061544
     C                   eval      X_CHK = *blanks                                          MD061544
     C                   If        PSExcpNo = '3773'                                        MD061544
     C                   eval      pos = %scan('not restored':PSExcpData:1)                 MD061544
     C                   eval      X_CHK = %subst(PSExcpData:pos-3:2)                       MD061544
     C                   ENDIF                                                              MD061544
                                                                                            MD061544
      ** if error
     C                   If        PSExcpNo <> '    '
     C                             and PSExcpNo <> '3773'                                   MD061544
     C                             or PSExcpNo = '3773' and X_CHK <> ' 0'                   MD061544
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6007'
     C                   EVAL      ZAMSDA = %trimr(XPACK2) + 'D'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        52
     C                   EXSR      ZASNMS
     C                   Endif

      * *M library
     C                   eval      PSExcpNo = '    '
     C                   EVAL      Cmd_String = 'RSTLIB SAVLIB(' +
     C                             %trimr(XPACK2) + 'M) DEV(*SAVF) SAVF(' +
     C                             %trim(#LIBCMN) + '/' +
     C                             %trimr(XPACK2) + 'M) RSTLIB(' +
     C                             %trimr(XPACK2) + 'M) OUTPUT(*PRINT)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if CPF3773, allow '0 not restored'                                                 MD061544
     C                   eval      X_CHK = *blanks                                          MD061544
     C                   If        PSExcpNo = '3773'                                        MD061544
     C                   eval      pos = %scan('not restored':PSExcpData:1)                 MD061544
     C                   eval      X_CHK = %subst(PSExcpData:pos-3:2)                       MD061544
     C                   ENDIF                                                              MD061544
                                                                                            MD061544
      ** if error
     C                   If        PSExcpNo <> '    '
     C                             and PSExcpNo <> '3773'                                   MD061544
     C                             or PSExcpNo = '3773' and X_CHK <> ' 0'                   MD061544
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6007'
     C                   EVAL      ZAMSDA = %trimr(XPACK2) + 'M'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        53
     C                   EXSR      ZASNMS
     C                   Endif

      * *N library
     C                   eval      PSExcpNo = '    '
     C                   EVAL      Cmd_String = 'RSTLIB SAVLIB(' +
     C                             %trimr(XPACK2) + 'N) DEV(*SAVF) SAVF(' +
     C                             %trim(#LIBCNN) + '/' +
     C                             %trimr(XPACK2) + 'N) RSTLIB(' +
     C                             %trimr(XPACK2) + 'N) OUTPUT(*PRINT)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if CPF3773, allow '0 not restored'                                                 MD061544
     C                   eval      X_CHK = *blanks                                          MD061544
     C                   If        PSExcpNo = '3773'                                        MD061544
     C                   eval      pos = %scan('not restored':PSExcpData:1)                 MD061544
     C                   eval      X_CHK = %subst(PSExcpData:pos-3:2)                       MD061544
     C                   ENDIF                                                              MD061544
                                                                                            MD061544
      ** if error
     C                   If        PSExcpNo <> '    '
     C                             and PSExcpNo <> '3773'                                   MD061544
     C                             or PSExcpNo = '3773' and X_CHK <> ' 0'                   MD061544
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6007'
     C                   EVAL      ZAMSDA = %trimr(XPACK2) + 'N'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        54
     C                   EXSR      ZASNMS
     C                   Endif

      * *P library
     C                   eval      PSExcpNo = '    '
     C                   EVAL      Cmd_String = 'RSTLIB SAVLIB(' +
     C                             %trimr(XPACK2) + 'P) DEV(*SAVF) SAVF(' +
     C                             %trim(#LIBCPN) + '/' +
     C                             %trimr(XPACK2) + 'P) RSTLIB(' +
     C                             %trimr(XPACK2) + 'P) OUTPUT(*PRINT)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if CPF3773, allow '0 not restored'                                                 MD061544
     C                   eval      X_CHK = *blanks                                          MD061544
     C                   If        PSExcpNo = '3773'                                        MD061544
     C                   eval      pos = %scan('not restored':PSExcpData:1)                 MD061544
     C                   eval      X_CHK = %subst(PSExcpData:pos-3:2)                       MD061544
     C                   ENDIF                                                              MD061544
                                                                                            MD061544
      ** if error
     C                   If        PSExcpNo <> '    '
     C                             and PSExcpNo <> '3773'                                   MD061544
     C                             or PSExcpNo = '3773' and X_CHK <> ' 0'                   MD061544
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6007'
     C                   EVAL      ZAMSDA = %trimr(XPACK2) + 'P'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        55
     C                   EXSR      ZASNMS
     C                   Endif

      * *U library
     C                   eval      PSExcpNo = '    '
     C                   EVAL      Cmd_String = 'RSTLIB SAVLIB(' +
     C                             %trimr(XPACK) + 'U) DEV(*SAVF) SAVF(' +
     C                             %trim(#LIBCUN) + '/' +
     C                             %trimr(XPACK) + 'U) RSTLIB(' +
     C                             %trimr(XPACK) + 'U) OUTPUT(*PRINT)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if CPF3773, allow '0 not restored'                                                 MD061544
     C                   eval      X_CHK = *blanks                                          MD061544
     C                   If        PSExcpNo = '3773'                                        MD061544
     C                   eval      pos = %scan('not restored':PSExcpData:1)                 MD061544
     C                   eval      X_CHK = %subst(PSExcpData:pos-3:2)                       MD061544
     C                   ENDIF                                                              MD061544
                                                                                            MD061544
      ** if error
     C                   If        PSExcpNo <> '    '
     C                             and PSExcpNo <> '3773'                                   MD061544
     C                             or PSExcpNo = '3773' and X_CHK <> ' 0'                   MD061544
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6007'
     C                   EVAL      ZAMSDA = %trimr(XPACK) + 'U'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        56
     C                   EXSR      ZASNMS
     C                   Endif

      * *G library
     C                   eval      PSExcpNo = '    '
     C                   EVAL      Cmd_String = 'RSTLIB SAVLIB(' +
     C                             %trimr(XPACK) + 'G) DEV(*SAVF) SAVF(' +
     C                             %trim(#LIBCGN) + '/' +
     C                             %trimr(XPACK) + 'G) RSTLIB(' +
     C                             %trimr(XPACK) + 'G) OUTPUT(*PRINT)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if CPF3773, allow '0 not restored'                                                 MD061544
     C                   eval      X_CHK = *blanks                                          MD061544
     C                   If        PSExcpNo = '3773'                                        MD061544
     C                   eval      pos = %scan('not restored':PSExcpData:1)                 MD061544
     C                   eval      X_CHK = %subst(PSExcpData:pos-3:2)                       MD061544
     C                   ENDIF                                                              MD061544
                                                                                            MD061544
      ** if error
     C                   If        PSExcpNo <> '    '
     C                             and PSExcpNo <> '3773'                                   MD061544
     C                             or PSExcpNo = '3773' and X_CHK <> ' 0'                   MD061544
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6007'
     C                   EVAL      ZAMSDA = %trimr(XPACK) + 'G'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        57
     C                   EXSR      ZASNMS
     C                   Endif

      * *Q library
     C                   eval      PSExcpNo = '    '
     C                   EVAL      Cmd_String = 'RSTLIB SAVLIB(' +
     C                             %trimr(XPACK) + 'Q) DEV(*SAVF) SAVF(' +
     C                             %trim(#LIBCQN) + '/' +
     C                             %trimr(XPACK) + 'Q) RSTLIB(' +
     C                             %trimr(XPACK) + 'Q) OUTPUT(*PRINT)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if CPF3773, allow '0 not restored'                                                 MD061544
     C                   eval      X_CHK = *blanks                                          MD061544
     C                   If        PSExcpNo = '3773'                                        MD061544
     C                   eval      pos = %scan('not restored':PSExcpData:1)                 MD061544
     C                   eval      X_CHK = %subst(PSExcpData:pos-3:2)                       MD061544
     C                   ENDIF                                                              MD061544
                                                                                            MD061544
      ** if error
     C                   If        PSExcpNo <> '    '
     C                             and PSExcpNo <> '3773'                                   MD061544
     C                             or PSExcpNo = '3773' and X_CHK <> ' 0'                   MD061544
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6007'
     C                   EVAL      ZAMSDA = %trimr(XPACK) + 'Q'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        58
     C                   EXSR      ZASNMS
     C                   Endif

      * *Z library
     C                   eval      PSExcpNo = '    '
     C                   EVAL      Cmd_String = 'RSTLIB SAVLIB(' +
     C                             %trimr(XPACK) + 'Z) DEV(*SAVF) SAVF(' +
     C                             %trim(#LIBCZN) + '/' +
     C                             %trimr(XPACK) + 'Z) RSTLIB(' +
     C                             %trimr(XPACK) + 'Z) OUTPUT(*PRINT)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if CPF3773, allow '0 not restored'                                                 MD061544
     C                   eval      X_CHK = *blanks                                          MD061544
     C                   If        PSExcpNo = '3773'                                        MD061544
     C                   eval      pos = %scan('not restored':PSExcpData:1)                 MD061544
     C                   eval      X_CHK = %subst(PSExcpData:pos-3:2)                       MD061544
     C                   ENDIF                                                              MD061544
                                                                                            MD061544
      ** if error
     C                   If        PSExcpNo <> '    '
     C                             and PSExcpNo <> '3773'                                   MD061544
     C                             or PSExcpNo = '3773' and X_CHK <> ' 0'                   MD061544
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6007'
     C                   EVAL      ZAMSDA = %trimr(XPACK) + 'Z'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        59
     C                   EXSR      ZASNMS
     C                   Endif

     C                   ENDDO

     C                   Endif

     C                   ENDSR
