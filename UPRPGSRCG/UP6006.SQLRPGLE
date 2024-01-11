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
      *  Last Amend No. MD062236           Date 11Jan24               *
      *  Prev Amend No. MD062077           Date 08Nov23               *
      *                 MD061779           Date 17Aug23               *
      *                 MD061992           Date 23Oct23               *
      *                 MD061954           Date 08Oct23               *
      *                 MD061951           Date 06Oct23               *
      *                 MD061927           Date 28Sep23               *
      *                 MD061880           Date 14Sep23               *
      *                 MD061706           Date 01Aug23               *
      *                 MD061544           Date 27Jun23               *
      *                 MD061351           Date 03May23               *
      *                 MD060386           Date 22Aug22               *
      *                 MD060362           Date 19Aug22               *
      *                 CUP044 *CREATE     Date 22May22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD062236 - 1. UDF tables are selected for upgrade            *
      *             2. RSTP wrongly shows 'Restore complete'          *
      *             3. Incorrect zone reference system displayed      *
      *  MD062077 - Include reference BFLIB                           *
      *  MD061779 - Upgrading deliverable data with full DDS set      *
      *  MD061992 - Allow 3 char prefix for reference libraries       *
      *             Recompiled                                        *
      *  MD061954 - Include restore of reference libraries for aDBU   *
      *  MD061951 - Default library name based on package + 'F'       *
      *  MD061927 - Delivering Stored Procedures in *U library        *
      *  MD061880 - Include Fix package installation                  *
      *  MD061706 - Various changes for transition to aDBU            *
      *  MD061544 - Allow CPF messages while restoring as long as     *
      *             all objects have been restored                    *
      *  MD061351 - *U library for client package can be either core  *
      *             or client                                         *
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
     D SAVFU           S             10A                                                    MD061351
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
     D WAIT            S              3                                                     MD061954

     D ZONE          E DS                  EXTNAME(GPZONEPD)
     D UPRSTR        E DS                  EXTNAME(UPRSTRTD)                                MD061954

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

      ** End SBS in case option ran before                                                  MD061954
     C                   If        XCUM = '1' or XCUM = '3'                                 MD061954
     C                   eval      BRGLIB = XPACK + 'B'                                     MD061954
     C                   Else                                                               MD061954
     C                   eval      BRGLIB = XPACK2 + 'B'                                    MD061954
     C                   Endif                                                              MD061954
     C                   EVAL      Cmd_String = 'ENDSBS SBS(' +                             MD061954
     C                             %trimr(BRGLIB) + ') OPTION(*IMMED)'                      MD061954
     C                   CALL      'QCMDEXC'                            20                  MD061954
     C                   PARM                    Cmd_String                                 MD061954
     C                   PARM      40            Cmd_Len                                    MD061954
                                                                                            MD061954
     C                   EXSR      CLEAR                                                    MD061954
                                                                                            MD061954
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

     C                   EXSR      CLEAR                                                    MD061954
      ** Check if aDBU                                                                      MD061954
     C                   exsr      Sr_aDBU                                                  MD061954
                                                                                            MD061954
     C                   If        XADBU =  'Y'                                             MD061954
     C                   EXSR      CLEAR                                                    MD061954
      ** Handle library names for reference libraries restore                               MD061954
     C                   exsr      Sr_LibInstR                                              MD061954
                                                                                            MD061954
      ** End program if F3 is pressed.                                                      MD061954
     C                   IF        *INKC = *ON                                              MD061954
     C                   EXSR      Exit                                                     MD061954
     C                   ENDIF                                                              MD061954
                                                                                            MD061954
      ** Proceed with restore                                                               MD061954
                                                                                            MD061954
     C                   IF        *INKC = *OFF                                             MD061954
     C                   exsr      Sr_LibRestR                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
                                                                                            MD061954
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
     C**********         EVAL      ZAMSID = 'UPM6009'                                       MD061880
     C                   EVAL      ZAMSID = 'UPM6017'                                       MD061880
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        29
     C                   EXSR      ZASNMS
     C                   ITER
     C                   ENDIF

      **Validate*'Y' or 'N'                                                                 MD061880
      * Validate '1' or '2' or '3'                                                          MD061880
     C**********         If        XCUM <> 'Y' and XCUM <> 'N'                              MD061880
     C                   If        XCUM <> '1' and XCUM <> '2'                              MD061880
     C                             and XCUM <> '3'                                          MD061880
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C**********         EVAL      ZAMSID = 'UPM6009'                                       MD061880
     C                   EVAL      ZAMSID = 'UPM6017'                                       MD061880
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        29
     C                   EXSR      ZASNMS
     C                   ITER
     C                   ENDIF

     C                   ENDDO

      * display second part
     C                   eval      ErrInd = 'Y'
     C                   seton                                        19
     C**********         If        XCUM = 'Y'                                               MD061880
     C                   SELECT                                                             MD061880
     C                   WHEN      XCUM = '2'                                               MD061880
     C                   seton                                        18
     C                   eval      XCOFI = '(Core package)'                                 MD061880
     C**********         else                                                               MD061880
     C                   WHEN      XCUM = '3'                                               MD061880
     C                   setoff                                       18                    MD061880
     C                   eval      XCOFI = '(Fix package)'                                  MD061880
     C                   OTHER                                                              MD061880
     C                   setoff                                       18
     C                   eval      XCOFI = '(Core package)'                                 MD061880
     C**********         endif
     C                   ENDSL                                                              MD061880

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

     C**********         If        XCUM = 'Y'                                               MD061880
     C                   If        XCUM = '2'                                               MD061880
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

     C**********         If        XCUM = 'Y'                                               MD061880
     C                   If        XCUM = '2'                                               MD061880
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
     C***********        If        XCUM = 'N'                                               MD061880
     C                   If        XCUM = '1' or XCUM = '3'                                 MD061880

      * Default library name                                                                MD061951
     C                   If        XCUM = '1'                                               MD061951
     C                   eval      #LIBSFB = XPACK + 'F'                                    MD061951
     C                   eval      #LIBSFD = XPACK + 'F'                                    MD061951
     C                   eval      #LIBSFU = XPACK + 'F'                                    MD061951
     C                   Else                                                               MD061951
     C                   eval      #LIBSFB = 'MISYSFIXES'                                   MD061951
     C                   eval      #LIBSFD = 'MISYSFIXES'                                   MD061951
     C                   eval      #LIBSFU = 'MISYSFIXES'                                   MD061951
     C                   Endif                                                              MD061951
                                                                                            MD061951
      * Protect Package name
     C                   seton                                        20

     C                   eval      ErrInd = 'Y'
     C                   eval      #LIBB = XPACK + 'B - Bridge Library'
     C                   eval      #LIBD = XPACK + 'D - Deliverable Data Lib' +
     C                             'rary'
     C**********         eval      #LIBQ = XPACK + 'Q - Stored Procedure Lib' +             MD061927
     C**********                   'rary'                                                   MD061927
     C                   eval      #LIBU = XPACK + 'U - Upgrade Library'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   WRITE     UP6006F0

     C                   seton                                        28
     C                   WRITE     UP6006C1
     C**********         WRITE     UP6006F2                                                 MD061954
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
      * If deliverable data is included in the reference libraries used by aDBU             MD061779
      * *D library is not delivered anymore, hence no error message to be sent              MD061779
     C                   If        #LIBSFD = *blanks
      * If Fix package being installed, library may not be delivered                        MD061880
     C**********                   and XCUM = '1'                                  MD061880 MD061779
     C**********         EVAL      ZAMSGF = 'UTMSGF'                                        MD061779
     C**********         EVAL      ZAMSID = 'UPM6005'                                       MD061779
     C**********         EVAL      ErrInd = 'Y'                                             MD061779
     C**********         seton                                        52                    MD061779
     C**********         EXSR      ZASNMS                                                   MD061779
     C                   else

     C                   If        #LIBSFD <> *blanks                                       MD061880
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
     C                   ENDIF                                                              MD061880
     C                   ENDIF

      ***Q*library                                                                          MD061927
      **Validate that library entered is non blank                                          MD061927
      **But it can be blank  as Stored Procedure are not always delivered                   MD061927
     C**********         If        #LIBSFQ = *blanks                                        MD061927
      **If*Fix*package being installed, library may not be delivered               MD061880 MD061927
     C**********                   and XCUM = '1'                                  MD061880 MD061927
     C**********         EVAL      ZAMSGF = 'UTMSGF'
     C**********         EVAL      ZAMSID = 'UPM6005'
     C**********         EVAL      ErrInd = 'Y'
     C**********         seton                                        53
     C**********         EXSR      ZASNMS
     C**********         else                                                               MD061927
      **********                                                                            MD061927
     C**********         If        #LIBSFQ <> *blanks                              MD061880 MD061927
      **Check*that library exists                                                           MD061927
     C**********         CALL      'UTCHKOBJ'                                               MD061927
     C**********         PARM      *BLANK        RTNCOD                                     MD061927
     C**********         PARM      #LIBSFQ       P2OBNM                                     MD061927
     C**********         PARM      '*LIBL'       P2TLIB                                     MD061927
     C**********         PARM      '*LIB'        P2OBTP                                     MD061927
     C**********         PARM      *blanks       CHKMBR                                     MD061927
      **********                                                                            MD061927
      * If libary does not exist in the library list, send message                          MD061927
     C*****RTNCOD        IFNE      'Exist'                                                  MD061927
     C**********         seton                                        53                    MD061927
     C**********         EVAL      ZAMSGF = 'UTMSGF'                                        MD061927
     C**********         EVAL      ZAMSID = 'UPM6004'                                       MD061927
     C**********         EVAL      ZAMSDA = #LIBSFQ                                         MD061927
     C**********         EVAL      ErrInd = 'Y'                                             MD061927
     C**********         EXSR      ZASNMS                                                   MD061927
     C**********         else                                                               MD061927
      **********                                                                            MD061927
      **Check*that SAVF exists in the library                                               MD061927
     C**********         eval      SAVF = XPACK + 'Q'                                       MD061927
     C**********         CALL      'UTCHKOBJ'                                               MD061927
     C**********         PARM      *BLANK        RTNCOD                                     MD061927
     C**********         PARM      SAVF          P2OBNM                                     MD061927
     C**********         PARM      #LIBSFQ       P2TLIB                                     MD061927
     C**********         PARM      '*FILE'       P2OBTP                                     MD061927
     C**********         PARM      *blanks       CHKMBR                                     MD061927
      **********                                                                            MD061927
      **If*libary does not exist in the library list, send message                          MD061927
     C*****RTNCOD        IFNE      'Exist'                                                  MD061927
     C**********         seton                                        53                    MD061927
     C**********         EVAL      ZAMSGF = 'UTMSGF'                                        MD061927
     C**********         EVAL      ZAMSID = 'UPM6006'                                       MD061927
     C**********         EVAL      ZAMSDA = SAVF                                            MD061927
     C**********         EVAL      ErrInd = 'Y'                                             MD061927
     C**********         EXSR      ZASNMS                                                   MD061927
     C**********         ENDIF                                                              MD061927
     C**********         ENDIF                                                              MD061927
     C**********         ENDIF                                                     MD061880 MD061927
     C**********         ENDIF                                                              MD061927

      * *U library
      * Validate that library entered is non blank
      * *U library may not be delivered with aDBU, don't send error message                 MD061706
     C                   If        #LIBSFU = *blanks
     C**********         EVAL      ZAMSGF = 'UTMSGF'                                        MD061706
     C**********         EVAL      ZAMSID = 'UPM6005'                                       MD061706
     C**********         EVAL      ErrInd = 'Y'                                             MD061706
     C**********         seton                                        54                    MD061706
     C**********         EXSR      ZASNMS                                                   MD061706
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
      * Default library name                                                                MD061951
     C                   eval      #LIBCBN = XPACK2 + 'F'                                   MD061951
     C                   eval      #LIBCDN = XPACK2 + 'F'                                   MD061951
     C                   eval      #LIBCMN = XPACK2 + 'F'                                   MD061951
     C                   eval      #LIBCNN = XPACK2 + 'F'                                   MD061951
     C                   eval      #LIBCPN = XPACK2 + 'F'                                   MD061951
     C                   eval      #LIBCUN = XPACK2 + 'F'                                   MD061951
     C                   eval      #LIBCGN = XPACK2 + 'F'                                   MD061951
     C                   eval      #LIBCZN = XPACK2 + 'F'                                   MD061951
                                                                                            MD061951
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
     C**********         eval      #LIBCU = XPACK + 'U - Cumulative Upgrade' +              MD061351
     C**********                   ' library'                                               MD061351
     C                   eval      #LIBCU = %trim(XPACK2) + 'U/' + %trim(XPACK)+            MD061351
     C                             'U -  Cumulative Upgrade library'                        MD061351
     C                   eval      #LIBCG = XPACK + 'G - Cumulative Global ' +
     C                             'objects library'
     C**********         eval      #LIBCQ = XPACK + 'Q - Cumulative Stored ' +              MD061927
     C**********                   'procedures library'                                     MD061927
     C                   eval      #LIBCZ = XPACK + 'Z - Cumulative Zone ' +
     C                             'objects library'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   WRITE     UP6006F0

     C                   seton                                        28
     C                   WRITE     UP6006C1
     C**********         WRITE     UP6006F2                                                 MD061954
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
      * If deliverable data is included in the reference libraries used by aDBU             MD061779
      * *D library is not delivered anymore, hence no error message to be sent              MD061779
     C                   If        #LIBCDN = *blanks
     C**********         EVAL      ZAMSGF = 'UTMSGF'                                        MD061779
     C**********         EVAL      ZAMSID = 'UPM6005'                                       MD061779
     C**********         EVAL      ErrInd = 'Y'                                             MD061779
     C**********         seton                                        52                    MD061779
     C**********         EXSR      ZASNMS                                                   MD061779
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
      * *U library may not be delivered with aDBU, don't send error message                 MD061706
     C                   If        #LIBCUN = *blanks
     C**********         EVAL      ZAMSGF = 'UTMSGF'                                        MD061706
     C**********         EVAL      ZAMSID = 'UPM6005'                                       MD061706
     C**********         EVAL      ErrInd = 'Y'                                             MD061706
     C**********         seton                                        56                    MD061706
     C**********         EXSR      ZASNMS                                                   MD061706
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
      * Check first core SAVF using XPACK                                                   MD061351
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
      * Then check client SAVF using XPACK2                                                 MD061351
     C                   eval      SAVF = XPACK2 + 'U'                                      MD061351
     C                   CALL      'UTCHKOBJ'                                               MD061351
     C                   PARM      *BLANK        RTNCOD                                     MD061351
     C                   PARM      SAVF          P2OBNM                                     MD061351
     C                   PARM      #LIBCUN       P2TLIB                                     MD061351
     C                   PARM      '*FILE'       P2OBTP                                     MD061351
     C                   PARM      *blanks       CHKMBR                                     MD061351
     C     RTNCOD        IFNE      'Exist'                                                  MD061351
      *                                                                                     MD061351
     C                   seton                                        56
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6006'
     C                   EVAL      ZAMSDA = SAVF
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF                                                              MD061351
     C                   ENDIF
     C                   eval      SAVFU = SAVF                                             MD061351
     C                   eval      #LIBCU = SAVFU + ' - Cumulative Upgrade' +               MD061351
     C                             ' library'                                               MD061351
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

      ***Q*library                                                                          MD061927
      **Validate that library entered is non blank                                          MD061927
     C**********         If        #LIBCQN = *blanks                                        MD061927
     C**********         EVAL      ZAMSGF = 'UTMSGF'                                        MD061927
     C**********         EVAL      ZAMSID = 'UPM6005'                                       MD061927
     C**********         EVAL      ErrInd = 'Y'                                             MD061927
     C**********         seton                                        58                    MD061927
     C**********         EXSR      ZASNMS                                                   MD061927
     C**********         else                                                               MD061927
      **********                                                                            MD061927
      **Check*that library exists                                                           MD061927
     C**********         CALL      'UTCHKOBJ'                                               MD061927
     C**********         PARM      *BLANK        RTNCOD                                     MD061927
     C**********         PARM      #LIBCQN       P2OBNM                                     MD061927
     C**********         PARM      '*LIBL'       P2TLIB                                     MD061927
     C**********         PARM      '*LIB'        P2OBTP                                     MD061927
     C**********         PARM      *blanks       CHKMBR                                     MD061927
      **********                                                                            MD061927
      **If*libary does not exist in the library list, send message                          MD061927
     C*****RTNCOD        IFNE      'Exist'                                                  MD061927
     C**********         seton                                        58                    MD061927
     C**********         EVAL      ZAMSGF = 'UTMSGF'                                        MD061927
     C**********         EVAL      ZAMSID = 'UPM6004'                                       MD061927
     C**********         EVAL      ZAMSDA = #LIBCQN                                         MD061927
     C**********         EVAL      ErrInd = 'Y'                                             MD061927
     C**********         EXSR      ZASNMS                                                   MD061927
     C**********         else                                                               MD061927
      **********                                                                            MD061927
      * Check that SAVF exists in the library                                               MD061927
     C**********         eval      SAVF = XPACK + 'Q'                                       MD061927
     C**********         CALL      'UTCHKOBJ'                                               MD061927
     C**********         PARM      *BLANK        RTNCOD                                     MD061927
     C**********         PARM      SAVF          P2OBNM                                     MD061927
     C**********         PARM      #LIBCQN       P2TLIB                                     MD061927
     C**********         PARM      '*FILE'       P2OBTP                                     MD061927
     C**********         PARM      *blanks       CHKMBR                                     MD061927
      **********                                                                            MD061927
      **If*libary does not exist in the library list, send message                          MD061927
     C*****RTNCOD        IFNE      'Exist'                                                  MD061927
     C**********         seton                                        58                    MD061927
     C**********         EVAL      ZAMSGF = 'UTMSGF'                                        MD061927
     C**********         EVAL      ZAMSID = 'UPM6006'                                       MD061927
     C**********         EVAL      ZAMSDA = SAVF                                            MD061927
     C**********         EVAL      ErrInd = 'Y'                                             MD061927
     C**********         EXSR      ZASNMS                                                   MD061927
     C**********         ENDIF                                                              MD061927
     C**********         ENDIF                                                              MD061927
     C**********         ENDIF                                                              MD061927

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
     C**********         EVAL      ZAMSDA = #LIBCQN                                         MD061927
     C                   EVAL      ZAMSDA = #LIBCZN                                         MD061927
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
     C***********        If        XCUM = 'N'                                               MD061880
     C                   If        XCUM = '1' or XCUM = '3'                                 MD061880

     C                   eval      ErrInd = 'Y'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

      ** Display screen for conformation
     C                   seton                                        2021
     C                   WRITE     UP6006C1
     C**********         WRITE     UP6006F2                                                 MD061954
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
      * *D library may not be delivered, restore only if delivered                          MD061880
     C                   If        #LIBSFD <> *blanks                                       MD061880
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
     C                   Endif                                                              MD061880

      ***Q*library                                                                          MD061927
     C**********         if        #LIBSFQ <> *blanks                                       MD061927
     C**********         eval      PSExcpNo = '    '                                        MD061927
     C**********         EVAL      Cmd_String = 'RSTLIB SAVLIB(' +                          MD061927
     C**********                   %trimr(XPACK) + 'Q) DEV(*SAVF) SAVF(' +                  MD061927
     C**********                   %trim(#LIBSFQ) + '/' +                                   MD061927
     C**********                   %trimr(XPACK) + 'Q) RSTLIB(' +                           MD061927
     C**********                   %trimr(XPACK) + 'Q) OUTPUT(*PRINT)'                      MD061927
     C**********         CALL      'QCMDEXC'                            20                  MD061927
     C**********         PARM                    Cmd_String                                 MD061927
     C**********         PARM                    Cmd_Len                                    MD061927
      **********                                                                            MD061927
      ***if*error                                                                           MD061927
     C**********         If        PSExcpNo <> '    '                                       MD061927
     C**********         EVAL      ZAMSGF = 'UTMSGF'                                        MD061927
     C**********         EVAL      ZAMSID = 'UPM6007'                                       MD061927
     C**********         EVAL      ZAMSDA = %trimr(XPACK) + 'Q'                             MD061927
     C**********         EVAL      ErrInd = 'Y'                                             MD061927
     C**********         seton                                        53                    MD061927
     C**********         EXSR      ZASNMS                                                   MD061927
     C**********         Endif                                                              MD061927
     C**********         Endif                                                              MD061927

      * *U library
      * *U library may not be delivered, restore only if delivered                          MD061706
     C                   If        #LIBSFU <> *blanks                                       MD061706
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
     C                   Endif                                                              MD061706

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
     C**********         WRITE     UP6006F2                                                 MD061954
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
      * *D library may not be delivered, restore only if delivered                          MD061779
     C                   If        #LIBCDN <> *blanks                                       MD061779
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
     C                   Endif                                                              MD061779

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
      * *U library may not be delivered, restore only if delivered                          MD061706
     C                   If        #LIBCUN <> *blanks                                       MD061706
     C                   eval      PSExcpNo = '    '
     C**********         EVAL      Cmd_String = 'RSTLIB SAVLIB(' +                          MD061351
     C**********                   %trimr(XPACK) + 'U) DEV(*SAVF) SAVF(' +                  MD061351
     C**********                   %trim(#LIBCUN) + '/' +                                   MD061351
     C**********                   %trimr(XPACK) + 'U) RSTLIB(' +                           MD061351
     C**********                   %trimr(XPACK) + 'U) OUTPUT(*PRINT)'                      MD061351
     C                   EVAL      Cmd_String = 'RSTLIB SAVLIB(' +                          MD061351
     C                             %trimr(SAVFU) + ')  DEV(*SAVF) SAVF(' +                  MD061351
     C                             %trim(#LIBCUN) + '/' +                                   MD061351
     C                             %trimr(SAVFU) + ')  RSTLIB(' +                           MD061351
     C                             %trimr(SAVFU) + ')  OUTPUT(*PRINT)'                      MD061351
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
     C                   Endif                                                              MD061706

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

      ***Q*library                                                                          MD061927
     C**********         eval      PSExcpNo = '    '                                        MD061927
     C**********         EVAL      Cmd_String = 'RSTLIB SAVLIB(' +                          MD061927
     C**********                   %trimr(XPACK) + 'Q) DEV(*SAVF) SAVF(' +                  MD061927
     C**********                   %trim(#LIBCQN) + '/' +                                   MD061927
     C**********                   %trimr(XPACK) + 'Q) RSTLIB(' +                           MD061927
     C**********                   %trimr(XPACK) + 'Q) OUTPUT(*PRINT)'                      MD061927
     C**********         CALL      'QCMDEXC'                            20                  MD061927
     C**********         PARM                    Cmd_String                                 MD061927
     C**********         PARM                    Cmd_Len                                    MD061927
      **********                                                                            MD061927
      ***if*CPF3773, allow '0 not restored'                                        MD061544 MD061927
     C**********         eval      X_CHK = *blanks                                 MD061544 MD061927
     C**********         If        PSExcpNo = '3773'                               MD061544 MD061927
     C**********         eval      pos = %scan('not restored':PSExcpData:1)        MD061544 MD061927
     C**********         eval      X_CHK = %subst(PSExcpData:pos-3:2)              MD061544 MD061927
     C**********         ENDIF                                                     MD061544 MD061927
      **********                                                                   MD061544 MD061927
      ***if*error                                                                           MD061927
     C**********         If        PSExcpNo <> '    '                                       MD061927
     C**********                   and PSExcpNo <> '3773'                          MD061544 MD061927
     C**********                   or PSExcpNo = '3773' and X_CHK <> ' 0'          MD061544 MD061927
     C**********         EVAL      ZAMSGF = 'UTMSGF'                                        MD061927
     C**********         EVAL      ZAMSID = 'UPM6007'                                       MD061927
     C**********         EVAL      ZAMSDA = %trimr(XPACK) + 'Q'                             MD061927
     C**********         EVAL      ErrInd = 'Y'                                             MD061927
     C**********         seton                                        58                    MD061927
     C**********         EXSR      ZASNMS                                                   MD061927
     C**********         Endif                                                              MD061927

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
      /EJECT
      *****************************************************************                     MD061954
      *                                                               *                     MD061954
      *  Sr_aDBU - Check if aDBU                                      *                     MD061954
      *                                                               *                     MD061954
      *****************************************************************                     MD061954
     C     Sr_aDBU       BEGSR                                                              MD061954
                                                                                            MD061954
     C                   eval      ErrInd = 'Y'                                             MD061954
                                                                                            MD061954
      * display first part                                                                  MD061954
     C                   setoff                                       406221                MD061954
     C                   DOW       *INKC = *OFF                                             MD061954
     C                             and ErrInd = 'Y'                                         MD061954
     C                   eval      ErrInd = 'N'                                             MD061954
                                                                                            MD061954
     C                   WRITE     UP6006F0                                                 MD061954
                                                                                            MD061954
     C                   seton                                        28                    MD061954
     C                   WRITE     UP6006C1                                                 MD061954
     C                   WRITE     UP6006F22                                                MD061954
                                                                                            MD061954
     C                   EXFMT     UP6006F24                                                MD061954
                                                                                            MD061954
     C                   EXSR      CLEAR                                                    MD061954
     C                   setoff                                       62                    MD061954
                                                                                            MD061954
      * Validate non blank                                                                  MD061954
      ** Validate aDBU flag                                                                 MD061954
     C                   If        XADBU <> 'Y' and XADBU <> 'N'                            MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6009'                                       MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   seton                                        62                    MD061954
     C                   ITER                                                               MD061954
     C                   ENDIF                                                              MD061954
                                                                                            MD061954
     C                   ENDDO                                                              MD061954
                                                                                            MD061954
      * display second part                                                                 MD061954
     C                   If        XADBU =  'Y'                                             MD061954
     C                   seton                                        4063                  MD061954
     C                   setoff                                       41                    MD061954
     C                   eval      ErrInd = 'Y'                                             MD061954
                                                                                            MD061954
     C                   DOW       *INKC = *OFF                                             MD061954
     C                             and ErrInd = 'Y'                                         MD061954
     C                   eval      ErrInd = 'N'                                             MD061954
                                                                                            MD061954
     C                   WRITE     UP6006F0                                                 MD061954
                                                                                            MD061954
     C                   seton                                        28                    MD061954
     C                   WRITE     UP6006C1                                                 MD061954
     C                   WRITE     UP6006F22                                                MD061954
                                                                                            MD061954
     C                   EXFMT     UP6006F24                                                MD061954
                                                                                            MD061954
     C                   EXSR      CLEAR                                                    MD061954
     C                   setoff                                       6465                  MD061954
                                                                                            MD061954
      ** Validate Reference prefixes                                                        MD061954
     C                   If        GLOBP = *blanks                                          MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6013'                                       MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   seton                                        65                    MD061954
     C                   ENDIF                                                              MD061954
                                                                                            MD061954
     C                   If        ZONEP = *blanks                                          MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6013'                                       MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   seton                                        64                    MD061954
     C                   ENDIF                                                              MD061954
                                                                                            MD061954
                                                                                            MD061954
     C                   If        ErrInd = 'Y'                                             MD061954
     C                   ITER                                                               MD061954
     C                   Endif                                                              MD061954
                                                                                            MD061954
     C                   ENDDO                                                              MD061954
                                                                                            MD061954
     C                   Endif                                                              MD061954
                                                                                            MD061954
     C                   ENDSR                                                              MD061954
      /EJECT                                                                                MD061954
      *****************************************************************                     MD061954
      *                                                               *                     MD061954
      *  Sr_LibInstR - Request library name for SAVF                  *                     MD061954
      *                                                               *                     MD061954
      *****************************************************************                     MD061954
     C     Sr_LibInstR   BEGSR                                                              MD061954
                                                                                            MD061954
     C                   eval      ##DOT5 = C_DOTA                                          MD061954
     C                   eval      ##DOT6 = C_DOTB                                          MD061954
     C                   eval      %Subarr(*IN : 51 : 10) = *OFF                            MD061954
     C                   setoff                                       2021                  MD061954
                                                                                            MD061954
      * Default library name                                                                MD061954
     C                   SELECT                                                             MD061954
     C                   WHEN      XCUM = '1'                                               MD061954
     C                   eval      #LIBRDM = XPACK  + 'F'                                   MD061954
     C                   eval      #LIBRDP = XPACK  + 'F'                                   MD061954
     C                   eval      #LIBRDT = XPACK  + 'F'                                   MD061954
     C                   eval      #LIBRDV = XPACK  + 'F'                                   MD061954
     C                   eval      #LIBRGM = XPACK  + 'F'                                   MD061954
     C                   eval      #LIBRGP = XPACK  + 'F'                                   MD061954
     C                   eval      #LIBRGT = XPACK  + 'F'                                   MD061954
     C                   eval      #LIBRGV = XPACK  + 'F'                                   MD061954
     C                   eval      #LIBRBF = XPACK  + 'F'                                   MD062077
     C                   WHEN      XCUM = '2'                                               MD061954
     C                   eval      #LIBRDM = XPACK2 + 'F'                                   MD061954
     C                   eval      #LIBRDP = XPACK2 + 'F'                                   MD061954
     C                   eval      #LIBRDT = XPACK2 + 'F'                                   MD061954
     C                   eval      #LIBRDV = XPACK2 + 'F'                                   MD061954
     C                   eval      #LIBRGM = XPACK2 + 'F'                                   MD061954
     C                   eval      #LIBRGP = XPACK2 + 'F'                                   MD061954
     C                   eval      #LIBRGT = XPACK2 + 'F'                                   MD061954
     C                   eval      #LIBRGV = XPACK2 + 'F'                                   MD061954
     C                   eval      #LIBRBF = XPACK2 + 'F'                                   MD062077
     C                   WHEN      XCUM = '3'                                               MD061954
     C                   eval      #LIBRDM = 'MISYSFIXES'                                   MD061954
     C                   eval      #LIBRDP = 'MISYSFIXES'                                   MD061954
     C                   eval      #LIBRDT = 'MISYSFIXES'                                   MD061954
     C                   eval      #LIBRDV = 'MISYSFIXES'                                   MD061954
     C                   eval      #LIBRGM = 'MISYSFIXES'                                   MD061954
     C                   eval      #LIBRGP = 'MISYSFIXES'                                   MD061954
     C                   eval      #LIBRGT = 'MISYSFIXES'                                   MD061954
     C                   eval      #LIBRGV = 'MISYSFIXES'                                   MD061954
     C                   eval      #LIBRBF = 'MISYSFIXES'                                   MD062077
     C                   ENDSL                                                              MD061954
                                                                                            MD061954
      * Protect aDBU and prefixes                                                           MD061954
     C                   seton                                        4041                  MD061954
                                                                                            MD061954
     C                   eval      ErrInd = 'Y'                                             MD061954
     C                   eval      #LIBDMN = ZONEP + 'DMLIB - BankFusion Midas'+            MD061954
     C                             ' zone master PFs/tables/DTAARA'                         MD061954
     C                   eval      #LIBDPN = ZONEP + 'DPLIB - BankFusion Midas'+            MD061954
     C                             ' zone non-master PF/DTAARA/DTAQ'                        MD061954
     C                   eval      #LIBDTN = ZONEP + 'DTALIB - BankFusion Mida'+            MD061954
     C                             's zone delivered data'                                  MD061954
     C                   eval      #LIBDVN = ZONEP + 'DVLIB - BankFusion Midas'+            MD061954
     C                             ' zone logicals/views/indexes'                           MD061954
     C                   eval      #LIBGMN = GLOBP + 'GMLIB - BankFusion Midas'+            MD061954
     C                             ' global master PFs/tables/DTAARA'                       MD061954
     C                   eval      #LIBGPN = GLOBP + 'GPLIB - BankFusion Midas'+            MD061954
     C                             ' global non-master PF/DTAARA/DTAQ'                      MD061954
     C                   eval      #LIBGTN = GLOBP + 'GTALIB - BankFusion Mida'+            MD061954
     C                             's global delivered data'                                MD061954
     C                   eval      #LIBGVN = GLOBP + 'GVLIB - BankFusion Midas'+            MD061954
     C                             ' global logicals/views/indexes'                         MD061954
     C                   eval      #LIBBFN = GLOBP + 'BFLIB - BankFusion Globa'+            MD062077
     C                             'l Master Schema'                                        MD062077
                                                                                            MD061954
     C                   DOW       *INKC = *OFF                                             MD061954
     C                             and ErrInd = 'Y'                                         MD061954
     C                   eval      ErrInd = 'N'                                             MD061954
                                                                                            MD061954
     C                   WRITE     UP6006F0                                                 MD061954
                                                                                            MD061954
     C                   seton                                        28                    MD061954
     C                   WRITE     UP6006C1                                                 MD061954
     C                   WRITE     UP6006F22                                                MD061954
     C                   WRITE     UP6006F24                                                MD061954
                                                                                            MD061954
     C                   EXFMT     UP6006F25                                                MD061954
                                                                                            MD061954
     C                   EXSR      CLEAR                                                    MD061954
     C                   eval      %Subarr(*IN : 51 : 10) = *OFF                            MD061954
                                                                                            MD061954
      * DMLIB                                                                               MD061954
      * Validate that library entered is non blank                                          MD061954
     C                   If        #LIBRDM = *blanks                                        MD061954
      * optional for type '3'                                                               MD061954
     C                             and XCUM <> '3'                                          MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6005'                                       MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   seton                                        51                    MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   else                                                               MD061954
                                                                                            MD061954
     C                   If        #LIBRDM <> *blanks                                       MD061954
      * Check that library exists                                                           MD061954
     C                   CALL      'UTCHKOBJ'                                               MD061954
     C                   PARM      *BLANK        RTNCOD           10                        MD061954
     C                   PARM      #LIBRDM       P2OBNM           10                        MD061954
     C                   PARM      '*LIBL'       P2TLIB           10                        MD061954
     C                   PARM      '*LIB'        P2OBTP            8                        MD061954
     C                   PARM      *blanks       CHKMBR           10                        MD061954
      *                                                                                     MD061954
      * If libary does not exist in the library list, send message                          MD061954
     C     RTNCOD        IFNE      'Exist'                                                  MD061954
     C                   seton                                        51                    MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6004'                                       MD061954
     C                   EVAL      ZAMSDA = #LIBRDM                                         MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   else                                                               MD061954
                                                                                            MD061954
      * Check that SAVF exists in the library                                               MD061954
     C                   eval      SAVF = ZONEP + 'DMLIB'                                   MD061954
     C                   CALL      'UTCHKOBJ'                                               MD061954
     C                   PARM      *BLANK        RTNCOD                                     MD061954
     C                   PARM      SAVF          P2OBNM                                     MD061954
     C                   PARM      #LIBRDM       P2TLIB                                     MD061954
     C                   PARM      '*FILE'       P2OBTP                                     MD061954
     C                   PARM      *blanks       CHKMBR                                     MD061954
      *                                                                                     MD061954
      * If libary does not exist in the library list, send message                          MD061954
     C     RTNCOD        IFNE      'Exist'                                                  MD061954
     C                   seton                                        51                    MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6006'                                       MD061954
     C                   EVAL      ZAMSDA = SAVF                                            MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
                                                                                            MD061954
      * DPLIB                                                                               MD061954
      * Validate that library entered is non blank                                          MD061954
     C                   If        #LIBRDP = *blanks                                        MD061954
      * optional for type '3'                                                               MD061954
     C                             and XCUM <> '3'                                          MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6005'                                       MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   seton                                        52                    MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   else                                                               MD061954
                                                                                            MD061954
     C                   If        #LIBRDP <> *blanks                                       MD061954
      * Check that library exists                                                           MD061954
     C                   CALL      'UTCHKOBJ'                                               MD061954
     C                   PARM      *BLANK        RTNCOD           10                        MD061954
     C                   PARM      #LIBRDP       P2OBNM           10                        MD061954
     C                   PARM      '*LIBL'       P2TLIB           10                        MD061954
     C                   PARM      '*LIB'        P2OBTP            8                        MD061954
     C                   PARM      *blanks       CHKMBR           10                        MD061954
      *                                                                                     MD061954
      * If libary does not exist in the library list, send message                          MD061954
     C     RTNCOD        IFNE      'Exist'                                                  MD061954
     C                   seton                                        52                    MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6004'                                       MD061954
     C                   EVAL      ZAMSDA = #LIBRDP                                         MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   else                                                               MD061954
                                                                                            MD061954
      * Check that SAVF exists in the library                                               MD061954
     C                   eval      SAVF = ZONEP + 'DPLIB'                                   MD061954
     C                   CALL      'UTCHKOBJ'                                               MD061954
     C                   PARM      *BLANK        RTNCOD                                     MD061954
     C                   PARM      SAVF          P2OBNM                                     MD061954
     C                   PARM      #LIBRDP       P2TLIB                                     MD061954
     C                   PARM      '*FILE'       P2OBTP                                     MD061954
     C                   PARM      *blanks       CHKMBR                                     MD061954
      *                                                                                     MD061954
      * If libary does not exist in the library list, send message                          MD061954
     C     RTNCOD        IFNE      'Exist'                                                  MD061954
     C                   seton                                        52                    MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6006'                                       MD061954
     C                   EVAL      ZAMSDA = SAVF                                            MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
                                                                                            MD061954
      * DTALIB                                                                              MD061954
      * Validate that library entered is non blank                                          MD061954
     C                   If        #LIBRDT = *blanks                                        MD061954
      * optional for type '3'                                                               MD061954
     C                             and XCUM <> '3'                                          MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6005'                                       MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   seton                                        53                    MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   else                                                               MD061954
                                                                                            MD061954
     C                   If        #LIBRDT <> *blanks                                       MD061954
      * Check that library exists                                                           MD061954
     C                   CALL      'UTCHKOBJ'                                               MD061954
     C                   PARM      *BLANK        RTNCOD           10                        MD061954
     C                   PARM      #LIBRDT       P2OBNM           10                        MD061954
     C                   PARM      '*LIBL'       P2TLIB           10                        MD061954
     C                   PARM      '*LIB'        P2OBTP            8                        MD061954
     C                   PARM      *blanks       CHKMBR           10                        MD061954
      *                                                                                     MD061954
      * If libary does not exist in the library list, send message                          MD061954
     C     RTNCOD        IFNE      'Exist'                                                  MD061954
     C                   seton                                        53                    MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6004'                                       MD061954
     C                   EVAL      ZAMSDA = #LIBRDT                                         MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   else                                                               MD061954
                                                                                            MD061954
      * Check that SAVF exists in the library                                               MD061954
     C                   eval      SAVF = ZONEP + 'DTALIB'                                  MD061954
     C                   CALL      'UTCHKOBJ'                                               MD061954
     C                   PARM      *BLANK        RTNCOD                                     MD061954
     C                   PARM      SAVF          P2OBNM                                     MD061954
     C                   PARM      #LIBRDT       P2TLIB                                     MD061954
     C                   PARM      '*FILE'       P2OBTP                                     MD061954
     C                   PARM      *blanks       CHKMBR                                     MD061954
      *                                                                                     MD061954
      * If libary does not exist in the library list, send message                          MD061954
     C     RTNCOD        IFNE      'Exist'                                                  MD061954
     C                   seton                                        53                    MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6006'                                       MD061954
     C                   EVAL      ZAMSDA = SAVF                                            MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
                                                                                            MD061954
      * DVLIB                                                                               MD061954
      * Validate that library entered is non blank                                          MD061954
     C                   If        #LIBRDV = *blanks                                        MD061954
      * optional for type '3'                                                               MD061954
     C                             and XCUM <> '3'                                          MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6005'                                       MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   seton                                        54                    MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   else                                                               MD061954
                                                                                            MD061954
     C                   If        #LIBRDV <> *blanks                                       MD061954
      * Check that library exists                                                           MD061954
     C                   CALL      'UTCHKOBJ'                                               MD061954
     C                   PARM      *BLANK        RTNCOD           10                        MD061954
     C                   PARM      #LIBRDV       P2OBNM           10                        MD061954
     C                   PARM      '*LIBL'       P2TLIB           10                        MD061954
     C                   PARM      '*LIB'        P2OBTP            8                        MD061954
     C                   PARM      *blanks       CHKMBR           10                        MD061954
      *                                                                                     MD061954
      * If libary does not exist in the library list, send message                          MD061954
     C     RTNCOD        IFNE      'Exist'                                                  MD061954
     C                   seton                                        54                    MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6004'                                       MD061954
     C                   EVAL      ZAMSDA = #LIBRDV                                         MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   else                                                               MD061954
                                                                                            MD061954
      * Check that SAVF exists in the library                                               MD061954
     C                   eval      SAVF = ZONEP + 'DVLIB'                                   MD061954
     C                   CALL      'UTCHKOBJ'                                               MD061954
     C                   PARM      *BLANK        RTNCOD                                     MD061954
     C                   PARM      SAVF          P2OBNM                                     MD061954
     C                   PARM      #LIBRDV       P2TLIB                                     MD061954
     C                   PARM      '*FILE'       P2OBTP                                     MD061954
     C                   PARM      *blanks       CHKMBR                                     MD061954
      *                                                                                     MD061954
      * If libary does not exist in the library list, send message                          MD061954
     C     RTNCOD        IFNE      'Exist'                                                  MD061954
     C                   seton                                        54                    MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6006'                                       MD061954
     C                   EVAL      ZAMSDA = SAVF                                            MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
                                                                                            MD061954
      * GMLIB                                                                               MD061954
      * Validate that library entered is non blank                                          MD061954
     C                   If        #LIBRGM = *blanks                                        MD061954
      * optional for type '3'                                                               MD061954
     C                             and XCUM <> '3'                                          MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6005'                                       MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   seton                                        55                    MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   else                                                               MD061954
                                                                                            MD061954
     C                   If        #LIBRGM <> *blanks                                       MD061954
      * Check that library exists                                                           MD061954
     C                   CALL      'UTCHKOBJ'                                               MD061954
     C                   PARM      *BLANK        RTNCOD                                     MD061954
     C                   PARM      #LIBRGM       P2OBNM                                     MD061954
     C                   PARM      '*LIBL'       P2TLIB                                     MD061954
     C                   PARM      '*LIB'        P2OBTP                                     MD061954
     C                   PARM      *blanks       CHKMBR                                     MD061954
      *                                                                                     MD061954
      * If libary does not exist in the library list, send message                          MD061954
     C     RTNCOD        IFNE      'Exist'                                                  MD061954
     C                   seton                                        55                    MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6004'                                       MD061954
     C                   EVAL      ZAMSDA = #LIBRGM                                         MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   else                                                               MD061954
                                                                                            MD061954
      * Check that SAVF exists in the library                                               MD061954
     C                   eval      SAVF = GLOBP + 'GMLIB'                                   MD061954
     C                   CALL      'UTCHKOBJ'                                               MD061954
     C                   PARM      *BLANK        RTNCOD                                     MD061954
     C                   PARM      SAVF          P2OBNM                                     MD061954
     C                   PARM      #LIBRGM       P2TLIB                                     MD061954
     C                   PARM      '*FILE'       P2OBTP                                     MD061954
     C                   PARM      *blanks       CHKMBR                                     MD061954
      *                                                                                     MD061954
      * If libary does not exist in the library list, send message                          MD061954
     C     RTNCOD        IFNE      'Exist'                                                  MD061954
     C                   seton                                        55                    MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6006'                                       MD061954
     C                   EVAL      ZAMSDA = SAVF                                            MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
                                                                                            MD061954
      * GPLIB                                                                               MD061954
      * Validate that library entered is non blank                                          MD061954
     C                   If        #LIBRGP = *blanks                                        MD061954
      * optional for type '3'                                                               MD061954
     C                             and XCUM <> '3'                                          MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6005'                                       MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   seton                                        56                    MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   else                                                               MD061954
                                                                                            MD061954
     C                   If        #LIBRGP <> *blanks                                       MD061954
      * Check that library exists                                                           MD061954
     C                   CALL      'UTCHKOBJ'                                               MD061954
     C                   PARM      *BLANK        RTNCOD                                     MD061954
     C                   PARM      #LIBRGP       P2OBNM                                     MD061954
     C                   PARM      '*LIBL'       P2TLIB                                     MD061954
     C                   PARM      '*LIB'        P2OBTP                                     MD061954
     C                   PARM      *blanks       CHKMBR                                     MD061954
      *                                                                                     MD061954
      * If libary does not exist in the library list, send message                          MD061954
     C     RTNCOD        IFNE      'Exist'                                                  MD061954
     C                   seton                                        56                    MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6004'                                       MD061954
     C                   EVAL      ZAMSDA = #LIBRGP                                         MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   else                                                               MD061954
                                                                                            MD061954
      * Check that SAVF exists in the library                                               MD061954
     C                   eval      SAVF = GLOBP + 'GPLIB'                                   MD061954
     C                   CALL      'UTCHKOBJ'                                               MD061954
     C                   PARM      *BLANK        RTNCOD                                     MD061954
     C                   PARM      SAVF          P2OBNM                                     MD061954
     C                   PARM      #LIBRGP       P2TLIB                                     MD061954
     C                   PARM      '*FILE'       P2OBTP                                     MD061954
     C                   PARM      *blanks       CHKMBR                                     MD061954
      *                                                                                     MD061954
      * If libary does not exist in the library list, send message                          MD061954
     C     RTNCOD        IFNE      'Exist'                                                  MD061954
     C                   seton                                        56                    MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6006'                                       MD061954
     C                   EVAL      ZAMSDA = SAVF                                            MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
                                                                                            MD061954
      * GTALIB                                                                              MD061954
      * Validate that library entered is non blank                                          MD061954
     C                   If        #LIBRGT = *blanks                                        MD061954
      * optional for type '3'                                                               MD061954
     C                             and XCUM <> '3'                                          MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6005'                                       MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   seton                                        57                    MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   else                                                               MD061954
                                                                                            MD061954
     C                   If        #LIBRGT <> *blanks                                       MD061954
      * Check that library exists                                                           MD061954
     C                   CALL      'UTCHKOBJ'                                               MD061954
     C                   PARM      *BLANK        RTNCOD                                     MD061954
     C                   PARM      #LIBRGT       P2OBNM                                     MD061954
     C                   PARM      '*LIBL'       P2TLIB                                     MD061954
     C                   PARM      '*LIB'        P2OBTP                                     MD061954
     C                   PARM      *blanks       CHKMBR                                     MD061954
      *                                                                                     MD061954
      * If libary does not exist in the library list, send message                          MD061954
     C     RTNCOD        IFNE      'Exist'                                                  MD061954
     C                   seton                                        57                    MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6004'                                       MD061954
     C                   EVAL      ZAMSDA = #LIBRGT                                         MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   else                                                               MD061954
                                                                                            MD061954
      * Check that SAVF exists in the library                                               MD061954
     C                   eval      SAVF = GLOBP + 'GTALIB'                                  MD061954
     C                   CALL      'UTCHKOBJ'                                               MD061954
     C                   PARM      *BLANK        RTNCOD                                     MD061954
     C                   PARM      SAVF          P2OBNM                                     MD061954
     C                   PARM      #LIBRGT       P2TLIB                                     MD061954
     C                   PARM      '*FILE'       P2OBTP                                     MD061954
     C                   PARM      *blanks       CHKMBR                                     MD061954
      *                                                                                     MD061954
      * If libary does not exist in the library list, send message                          MD061954
     C     RTNCOD        IFNE      'Exist'                                                  MD061954
     C                   seton                                        57                    MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6006'                                       MD061954
     C                   EVAL      ZAMSDA = SAVF                                            MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
                                                                                            MD061954
      * GVLIB                                                                               MD061954
      * Validate that library entered is non blank                                          MD061954
     C                   If        #LIBRGV = *blanks                                        MD061954
      * optional for type '3'                                                               MD061954
     C                             and XCUM <> '3'                                          MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6005'                                       MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   seton                                        58                    MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   else                                                               MD061954
                                                                                            MD061954
     C                   If        #LIBRGV <> *blanks                                       MD061954
      * Check that library exists                                                           MD061954
     C                   CALL      'UTCHKOBJ'                                               MD061954
     C                   PARM      *BLANK        RTNCOD                                     MD061954
     C                   PARM      #LIBRGV       P2OBNM                                     MD061954
     C                   PARM      '*LIBL'       P2TLIB                                     MD061954
     C                   PARM      '*LIB'        P2OBTP                                     MD061954
     C                   PARM      *blanks       CHKMBR                                     MD061954
      *                                                                                     MD061954
      * If libary does not exist in the library list, send message                          MD061954
     C     RTNCOD        IFNE      'Exist'                                                  MD061954
     C                   seton                                        58                    MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6004'                                       MD061954
     C                   EVAL      ZAMSDA = #LIBRGV                                         MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   else                                                               MD061954
                                                                                            MD061954
      * Check that SAVF exists in the library                                               MD061954
     C                   eval      SAVF = GLOBP + 'GVLIB'                                   MD061954
     C                   CALL      'UTCHKOBJ'                                               MD061954
     C                   PARM      *BLANK        RTNCOD                                     MD061954
     C                   PARM      SAVF          P2OBNM                                     MD061954
     C                   PARM      #LIBRGV       P2TLIB                                     MD061954
     C                   PARM      '*FILE'       P2OBTP                                     MD061954
     C                   PARM      *blanks       CHKMBR                                     MD061954
                                                                                            MD061954
      * If libary does not exist in the library list, send message                          MD061954
     C     RTNCOD        IFNE      'Exist'                                                  MD061954
     C                   seton                                        58                    MD061954
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD061954
     C                   EVAL      ZAMSID = 'UPM6006'                                       MD061954
     C                   EVAL      ZAMSDA = SAVF                                            MD061954
     C                   EVAL      ErrInd = 'Y'                                             MD061954
     C                   EXSR      ZASNMS                                                   MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
     C                   ENDIF                                                              MD061954
                                                                                            MD061954
      * BFLIB                                                                               MD062077
      * Validate that library entered is non blank                                          MD062077
     C                   If        #LIBRBF = *blanks                                        MD062077
      * optional for type '3'                                                               MD062077
     C                             and XCUM <> '3'                                          MD062077
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD062077
     C                   EVAL      ZAMSID = 'UPM6005'                                       MD062077
     C                   EVAL      ErrInd = 'Y'                                             MD062077
     C                   seton                                        59                    MD062077
     C                   EXSR      ZASNMS                                                   MD062077
     C                   else                                                               MD062077
                                                                                            MD062077
     C                   If        #LIBRBF <> *blanks                                       MD062077
      * Check that library exists                                                           MD062077
     C                   CALL      'UTCHKOBJ'                                               MD062077
     C                   PARM      *BLANK        RTNCOD                                     MD062077
     C                   PARM      #LIBRBF       P2OBNM                                     MD062077
     C                   PARM      '*LIBL'       P2TLIB                                     MD062077
     C                   PARM      '*LIB'        P2OBTP                                     MD062077
     C                   PARM      *blanks       CHKMBR                                     MD062077
      *                                                                                     MD062077
      * If libary does not exist in the library list, send message                          MD062077
     C     RTNCOD        IFNE      'Exist'                                                  MD062077
     C                   seton                                        58                    MD062077
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD062077
     C                   EVAL      ZAMSID = 'UPM6004'                                       MD062077
     C                   EVAL      ZAMSDA = #LIBRBF                                         MD062077
     C                   EVAL      ErrInd = 'Y'                                             MD062077
     C                   EXSR      ZASNMS                                                   MD062077
     C                   else                                                               MD062077
                                                                                            MD062077
      * Check that SAVF exists in the library                                               MD062077
     C                   eval      SAVF = GLOBP + 'BFLIB'                                   MD062077
     C                   CALL      'UTCHKOBJ'                                               MD062077
     C                   PARM      *BLANK        RTNCOD                                     MD062077
     C                   PARM      SAVF          P2OBNM                                     MD062077
     C                   PARM      #LIBRBF       P2TLIB                                     MD062077
     C                   PARM      '*FILE'       P2OBTP                                     MD062077
     C                   PARM      *blanks       CHKMBR                                     MD062077
                                                                                            MD062077
      * If libary does not exist in the library list, send message                          MD062077
     C     RTNCOD        IFNE      'Exist'                                                  MD062077
     C                   seton                                        58                    MD062077
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD062077
     C                   EVAL      ZAMSID = 'UPM6006'                                       MD062077
     C                   EVAL      ZAMSDA = SAVF                                            MD062077
     C                   EVAL      ErrInd = 'Y'                                             MD062077
     C                   EXSR      ZASNMS                                                   MD062077
     C                   ENDIF                                                              MD062077
     C                   ENDIF                                                              MD062077
     C                   ENDIF                                                              MD062077
     C                   ENDIF                                                              MD062077
                                                                                            MD062077
     C                   ENDDO                                                              MD061954
                                                                                            MD061954
     C                   ENDSR                                                              MD061954
      *****************************************************************                     MD061954
      /EJECT                                                                                MD061954
      *****************************************************************                     MD061954
      *                                                               *                     MD061954
      *  Sr_LibRestR - Restore reference libraries                    *                     MD061954
      *                                                               *                     MD061954
      *****************************************************************                     MD061954
     C     Sr_LibRestR   BEGSR                                                              MD061954
                                                                                            MD061954
     C                   eval      ErrInd = 'Y'                                             MD061954
     C                   seton                                        21                    MD061954
                                                                                            MD061954
      ** Initialize work file                                                               MD061954
     C/exec SQL                                                                             MD061954
      + delete from UPRSTRTD                                                                MD061954
     C/end-exec                                                                             MD061954
     C                   If        SQLCode <> 0                                             MD061954
     C                             and SQLCode <> 100                                       MD061954
     C                   eval      DBASE = '100'                                            MD061954
     C                   exsr      *pssr                                                    MD061954
     C                   Endif                                                              MD061954
                                                                                            MD061954
     C/EXEC SQL                                                                             MD061954
     C+ insert into UPRSTRTD                                                                MD061954
     C+ (                                                                                   MD061954
     C+   LRSTDM                                                                            MD061954
     C+  ,LRSTDP                                                                            MD061954
     C+  ,LRSTDT                                                                            MD061954
     C+  ,LRSTDV                                                                            MD061954
     C+  ,LRSTGM                                                                            MD061954
     C+  ,LRSTGP                                                                            MD061954
     C+  ,LRSTGT                                                                            MD061954
     C+  ,LRSTGV                                                                            MD061954
     C+  ,LRSTBF                                                                            MD062077
     C+ )                                                                                   MD061954
     C+ Values                                                                              MD061954
     C+ (                                                                                   MD061954
     C+   ' '                                                                               MD061954
     C+  ,' '                                                                               MD061954
     C+  ,' '                                                                               MD061954
     C+  ,' '                                                                               MD061954
     C+  ,' '                                                                               MD061954
     C+  ,' '                                                                               MD061954
     C+  ,' '                                                                               MD061954
     C+  ,' '                                                                               MD061954
     C+  ,' '                                                                               MD062077
     C+ )                                                                                   MD061954
     C/END-EXEC                                                                             MD061954
     C                   If        SQLCode <> 0                                             MD061954
     C                   eval      DBASE = '101'                                            MD061954
     C                   exsr      *pssr                                                    MD061954
     C                   Endif                                                              MD061954
                                                                                            MD061954
     C                   DOW       *INKC = *OFF                                             MD061954
     C                             and ErrInd = 'Y'                                         MD061954
     C                   eval      ErrInd = 'N'                                             MD061954
      ** Display screen for confirmation                                                    MD061954
                                                                                            MD061954
     C                   WRITE     UP6006F0                                                 MD061954
                                                                                            MD061954
     C                   seton                                        28                    MD061954
     C                   WRITE     UP6006C1                                                 MD061954
     C                   WRITE     UP6006F22                                                MD061954
     C                   WRITE     UP6006F24                                                MD061954
                                                                                            MD061954
     C                   EXFMT     UP6006F25                                                MD061954
                                                                                            MD061954
     C                   setoff                                       515253                MD061954
     C                   setoff                                       54                    MD061954
     C                   eval      %Subarr(*IN : 71 : 8) = *OFF                             MD061954
     C                   setoff                                       81                    MD062077
                                                                                            MD061954
      ** End program if F3 is pressed.                                                      MD061954
     C                   IF        *INKC = *ON                                              MD061954
     C                   EXSR      Exit                                                     MD061954
     C                   ENDIF                                                              MD061954
                                                                                            MD061954
     C                   EXSR      CLEAR                                                    MD061954
                                                                                            MD061954
     C                   If        XCUM = '1' or XCUM = '3'                                 MD061954
     C                   eval      BRGLIB = XPACK + 'B'                                     MD061954
     C                   Else                                                               MD061954
     C                   eval      BRGLIB = XPACK2 + 'B'                                    MD061954
     C                   Endif                                                              MD061954
                                                                                            MD061954
     C                   If        #LIBRDM <> ' '                                           MD061954
     C/exec SQL                                                                             MD061954
      + update UPRSTRTD set LRSTDM = 'S'                                                    MD061954
     C/end-exec                                                                             MD061954
     C                   Endif                                                              MD061954
     C                   If        #LIBRDP <> ' '                                           MD061954
     C/exec SQL                                                                             MD061954
      + update UPRSTRTD set LRSTDP = 'S'                                                    MD061954
     C/end-exec                                                                             MD061954
     C                   Endif                                                              MD061954
     C                   If        #LIBRDT <> ' '                                           MD061954
     C/exec SQL                                                                             MD061954
      + update UPRSTRTD set LRSTDT = 'S'                                                    MD061954
     C/end-exec                                                                             MD061954
     C                   Endif                                                              MD061954
     C                   If        #LIBRDV <> ' '                                           MD061954
     C/exec SQL                                                                             MD061954
      + update UPRSTRTD set LRSTDV = ' '                                                    MD061954
     C/end-exec                                                                             MD061954
     C                   Endif                                                              MD061954
     C                   If        #LIBRGM <> ' '                                           MD061954
     C/exec SQL                                                                             MD061954
      + update UPRSTRTD set LRSTGM = 'S'                                                    MD061954
     C/end-exec                                                                             MD061954
     C                   Endif                                                              MD061954
     C                   If        #LIBRGP <> ' '                                           MD061954
     C/exec SQL                                                                             MD061954
      + update UPRSTRTD set LRSTGP = 'S'                                                    MD061954
     C/end-exec                                                                             MD061954
     C                   Endif                                                              MD061954
     C                   If        #LIBRGT <> ' '                                           MD061954
     C/exec SQL                                                                             MD061954
      + update UPRSTRTD set LRSTGT = 'S'                                                    MD061954
     C/end-exec                                                                             MD061954
     C                   Endif                                                              MD061954
     C                   If        #LIBRGV <> ' '                                           MD061954
     C/exec SQL                                                                             MD061954
      + update UPRSTRTD set LRSTGV = ' '                                                    MD061954
     C/end-exec                                                                             MD061954
     C                   Endif                                                              MD061954
      * As BFLIB must be restore before GVLIB, set status to Submitted                      MD062077
     C                   If        #LIBRBF <> ' '                                           MD062077
     C/exec SQL                                                                             MD062077
      + update UPRSTRTD set LRSTBF = 'S'                                                    MD062077
     C/end-exec                                                                             MD062077
     C                   Endif                                                              MD062077
      ** submit restore in SBSD for each SAVF having a library inserted                     MD061954
     C                   CALL      'UPC6006'                                                MD061954
     C                   PARM                    #LIBRDM                                    MD061954
     C                   PARM                    #LIBRDP                                    MD061954
     C                   PARM                    #LIBRDT                                    MD061954
     C                   PARM                    #LIBRDV                                    MD061954
     C                   PARM                    #LIBRGM                                    MD061954
     C                   PARM                    #LIBRGP                                    MD061954
     C                   PARM                    #LIBRGT                                    MD061954
     C                   PARM                    #LIBRGV                                    MD061954
     C                   PARM                    #LIBRBF                                    MD062077
     C                   PARM                    GLOBP                                      MD061954
     C                   PARM                    ZONEP                                      MD061954
     C                   PARM                    BRGLIB           10                        MD061954
     C                   PARM                    RETRN            10                        MD061954
                                                                                            MD061954
     C                   eval      WAIT = 'YES'                                             MD061954
      * Display Status                                                                      MD061954
     C                   seton                                        79                    MD061954
                                                                                            MD061954
     C                   DOW       WAIT = 'YES'                                             MD061954
     C                   CALL      'QCMDEXC'                                                MD061954
     C                   PARM      'DLYJOB 2'    CMD               8                        MD061954
     C                   PARM      8             CMDLEN           15 5                      MD061954
                                                                                            MD061954
      ** Retrieve status and wait for all to be ' ' or 'C' or 'F'                           MD061954
     C/EXEC SQL                                                                             MD061954
     C+ select * into :UPRSTR from UPRSTRTD                                                 MD061954
     C/END-EXEC                                                                             MD061954
                                                                                            MD061954
     C                   EXSR      Sr_Check                                                 MD061954
     C                   WRITE     UP6006F0                                                 MD061954
     C                   seton                                        28                    MD061954
     C                   WRITE     UP6006C1                                                 MD061954
     C                   WRITE     UP6006F24                                                MD061954
                                                                                            MD061954
     C                   WRITE     UP6006F25                                                MD061954
     C                   ENDDO                                                              MD061954
                                                                                            MD061954
      * Check if all complete                                                               MD061954
     C                   eval      pos = %LOOKUP(*ON: *IN: 70 : 8)                          MD061954
     C                   If        pos > 0                                                  MD061954
     C                             or *IN81 = *ON                                           MD062077
     C                   eval      ErrInd = 'Y'                                             MD061954
     C                   ITER                                                               MD061954
     C                   Endif                                                              MD061954
                                                                                            MD061954
      * At the end send message                                                             MD061954
     C                   WRITE     UP6006F0                                                 MD061954
     C                   seton                                        288022                MD061954
     C                   setoff                                       21                    MD061954
     C                   WRITE     UP6006C1                                                 MD061954
     C                   WRITE     UP6006F22                                                MD061954
     C                   WRITE     UP6006F24                                                MD061954
                                                                                            MD061954
     C                   EXFMT     UP6006F25                                                MD061954
                                                                                            MD061954
     C                   ENDDO                                                              MD061954
                                                                                            MD061954
     C                   ENDSR                                                              MD061954
      *****************************************************************                     MD061954
      /EJECT                                                                                MD061954
      *****************************************************************                     MD061954
      *                                                               *                     MD061954
      *  Sr_Check - Check status of restore                           *                     MD061954
      *                                                               *                     MD061954
      *****************************************************************                     MD061954
     C     Sr_Check      BEGSR                                                              MD061954
                                                                                            MD061954
     C                   SELECT                                                             MD061954
     C                   WHEN      LRSTDM = 'S'                                             MD061954
     C                   eval      #DMSTS = 'Submitted'                                     MD061954
     C                   WHEN      LRSTDM = 'F'                                             MD061954
     C                   eval      #DMSTS = 'Failed'                                        MD061954
     C                   seton                                        71                    MD061954
     C                   WHEN      LRSTDM = 'R'                                             MD061954
     C                   eval      #DMSTS = 'Running'                                       MD061954
     C                   WHEN      LRSTDM = 'C'                                             MD061954
     C                   eval      #DMSTS = 'Complete'                                      MD061954
     C                   ENDSL                                                              MD061954
                                                                                            MD061954
     C                   SELECT                                                             MD061954
     C                   WHEN      LRSTDP = 'S'                                             MD061954
     C                   eval      #DPSTS = 'Submitted'                                     MD061954
     C                   WHEN      LRSTDP = 'F'                                             MD061954
     C                   eval      #DPSTS = 'Failed'                                        MD061954
     C                   seton                                        72                    MD061954
     C                   WHEN      LRSTDP = 'R'                                             MD061954
     C                   eval      #DPSTS = 'Running'                                       MD061954
     C                   WHEN      LRSTDP = 'C'                                             MD061954
     C                   eval      #DPSTS = 'Complete'                                      MD061954
     C                   ENDSL                                                              MD061954
                                                                                            MD061954
     C                   SELECT                                                             MD061954
     C                   WHEN      LRSTDT = 'S'                                             MD061954
     C                   eval      #DTSTS = 'Submitted'                                     MD061954
     C                   WHEN      LRSTDT = 'F'                                             MD061954
     C                   eval      #DTSTS = 'Failed'                                        MD061954
     C                   seton                                        73                    MD061954
     C                   WHEN      LRSTDT = 'R'                                             MD061954
     C                   eval      #DTSTS = 'Running'                                       MD061954
     C                   WHEN      LRSTDT = 'C'                                             MD061954
     C                   eval      #DTSTS = 'Complete'                                      MD061954
     C                   ENDSL                                                              MD061954
                                                                                            MD061954
     C                   SELECT                                                             MD061954
     C                   WHEN      LRSTDV = 'S'                                             MD061954
     C                   eval      #DVSTS = 'Submitted'                                     MD061954
     C                   WHEN      LRSTDV = 'F'                                             MD061954
     C                   eval      #DVSTS = 'Failed'                                        MD061954
     C                   seton                                        74                    MD061954
     C                   WHEN      LRSTDV = 'R'                                             MD061954
     C                   eval      #DVSTS = 'Running'                                       MD061954
     C                   WHEN      LRSTDV = 'C'                                             MD061954
     C                   eval      #DVSTS = 'Complete'                                      MD061954
     C                   ENDSL                                                              MD061954
                                                                                            MD061954
     C                   SELECT                                                             MD061954
     C                   WHEN      LRSTGM = 'S'                                             MD061954
     C                   eval      #GMSTS = 'Submitted'                                     MD061954
     C                   WHEN      LRSTGM = 'F'                                             MD061954
     C                   eval      #GMSTS = 'Failed'                                        MD061954
     C                   seton                                        75                    MD061954
     C                   WHEN      LRSTGM = 'R'                                             MD061954
     C                   eval      #GMSTS = 'Running'                                       MD061954
     C                   WHEN      LRSTGM = 'C'                                             MD061954
     C                   eval      #GMSTS = 'Complete'                                      MD061954
     C                   ENDSL                                                              MD061954
                                                                                            MD061954
     C                   SELECT                                                             MD061954
     C                   WHEN      LRSTGP = 'S'                                             MD061954
     C                   eval      #GPSTS = 'Submitted'                                     MD061954
     C                   WHEN      LRSTGP = 'F'                                             MD061954
     C                   eval      #GPSTS = 'Failed'                                        MD061954
     C                   seton                                        76                    MD061954
     C                   WHEN      LRSTGP = 'R'                                             MD061954
     C                   eval      #GPSTS = 'Running'                                       MD061954
     C                   WHEN      LRSTGP = 'C'                                             MD061954
     C                   eval      #GPSTS = 'Complete'                                      MD061954
     C                   ENDSL                                                              MD061954
                                                                                            MD061954
     C                   SELECT                                                             MD061954
     C                   WHEN      LRSTGT = 'S'                                             MD061954
     C                   eval      #GTSTS = 'Submitted'                                     MD061954
     C                   WHEN      LRSTGT = 'F'                                             MD061954
     C                   eval      #GTSTS = 'Failed'                                        MD061954
     C                   seton                                        77                    MD061954
     C                   WHEN      LRSTGT = 'R'                                             MD061954
     C                   eval      #GTSTS = 'Running'                                       MD061954
     C                   WHEN      LRSTGT = 'C'                                             MD061954
     C                   eval      #GTSTS = 'Complete'                                      MD061954
     C                   ENDSL                                                              MD061954
                                                                                            MD061954
     C                   SELECT                                                             MD061954
     C                   WHEN      LRSTGV = 'S'                                             MD061954
     C                   eval      #GVSTS = 'Submitted'                                     MD061954
     C                   WHEN      LRSTGV = 'F'                                             MD061954
     C                   eval      #GVSTS = 'Failed'                                        MD061954
     C                   seton                                        78                    MD061954
     C                   WHEN      LRSTGV = 'R'                                             MD061954
     C                   eval      #GVSTS = 'Running'                                       MD061954
     C                   WHEN      LRSTGV = 'C'                                             MD061954
     C                   eval      #GVSTS = 'Complete'                                      MD061954
     C                   ENDSL                                                              MD061954
                                                                                            MD061954
     C                   SELECT                                                             MD062077
     C                   WHEN      LRSTBF = 'S'                                             MD062077
     C                   eval      #BFSTS = 'Submitted'                                     MD062077
     C                   WHEN      LRSTBF = 'F'                                             MD062077
     C                   eval      #bFSTS = 'Failed'                                        MD062077
     C                   seton                                        81                    MD062077
     C                   WHEN      LRSTBF = 'R'                                             MD062077
     C                   eval      #BFSTS = 'Running'                                       MD062077
     C                   WHEN      LRSTBF = 'C'                                             MD062077
     C                   eval      #BFSTS = 'Complete'                                      MD062077
     C                   ENDSL                                                              MD062077
                                                                                            MD062077
     C                   eval      WAIT = 'NO'                                              MD061954
      ** If at least one is submitted or running, wait                                      MD061954
      ** or if GV/DV are still blank                                                        MD062236
     C                   IF        LRSTDM = 'S' or LRSTDM = 'R'                             MD061954
     C                             or LRSTDP = 'S' or LRSTDP = 'R'                          MD061954
     C                             or LRSTDT = 'S' or LRSTDT = 'R'                          MD061954
     C                             or LRSTDV = 'S' or LRSTDV = 'R'                          MD061954
     C                             or LRSTGM = 'S' or LRSTGM = 'R'                          MD061954
     C                             or LRSTGP = 'S' or LRSTGP = 'R'                          MD061954
     C                             or LRSTGT = 'S' or LRSTGT = 'R'                          MD061954
     C                             or LRSTGV = 'S' or LRSTGV = 'R'                          MD061954
     C                             or LRSTBF = 'S' or LRSTBF = 'R'                          MD062077
     C                             or (#LIBRGV <> ' ' and LRSTGV = ' ')                     MD062236
     C                             or (#LIBRDV <> ' ' and LRSTDV = ' ')                     MD062236
     C                   eval      WAIT = 'YES'                                             MD061954
     C                   Endif                                                              MD061954
                                                                                            MD061954
     C                   ENDSR                                                              MD061954
      *****************************************************************                     MD061954
