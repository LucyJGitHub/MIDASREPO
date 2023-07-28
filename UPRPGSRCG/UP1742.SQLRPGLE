     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Add menu code')                               *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP1742 - Midas UP Add menu code                              *
      *                                                               *
      *  Function: This program allows menu code to be added in       *
      *            group/hierarchy. It ouptuts in work file           *
      *            UPADMCTD                                           *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD061576 *CREATE   Date 23Jul23               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD061576 - Deliverable Data Split for T_GRMENU*              *
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
     FUP1742GF  CF   E             WORKSTN

      ** Declared Variables
     D ErrInd          S             10
     D X_NUM           S             15
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

     D XHIDn           S             15  0
     D XGROUPn         S             15  0
     D RcdCount        S             15  0

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
       /EJECT
      *****************************************************************

      ** Validate input of menu code and hierarchy
     C                   exsr      Sr_ValH

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

      ** Validate input of group
     C                   exsr      Sr_ValG

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

      ** Redisplay screen for confirmation
     C                   seton                                        2023
     C                   WRITE     UP1742F0

     C                   seton                                        28
     C                   WRITE     UP1742F22

     C                   EXFMT     UP1742F2

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   IF        *INKC = *OFF
      ** If to be added
     C                   IF        *INKI = *ON
     C/EXEC SQL
     C+ insert into UPADMCTD
     C+ (
     C+   UMNUC
     C+  ,UHID
     C+  ,UNWH
     C+  ,UGRPID
     C+  ,UNWG
     C+  ,UMMODE
     C+ )
     C+ Values
     C+ (
     C+   :XMENU
     C+  ,:XHID
     C+  ,0
     C+  ,:XGROUP
     C+  ,0
     C+  ,'C'
     C+ )
     C/END-EXEC
     C                   If        SQLCode <> 0
     C                   exsr      *pssr
     C                   Endif

     C                   ENDIF
      ** If to be replaced
     C                   IF        *INKJ = *ON
     C/EXEC SQL
     C+ delete from UPADMCTD
     C/END-EXEC

     C/EXEC SQL
     C+ insert into UPADMCTD
     C+ (
     C+   UMNUC
     C+  ,UHID
     C+  ,UNWH
     C+  ,UGRPID
     C+  ,UNWG
     C+  ,UMMODE
     C+ )
     C+ Values
     C+ (
     C+   :XMENU
     C+  ,:XHID
     C+  ,0
     C+  ,:XGROUP
     C+  ,0
     C+  ,'C'
     C+ )
     C/END-EXEC
     C                   If        SQLCode <> 0
     C                   exsr      *pssr
     C                   Endif

     C                   ENDIF

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

     C***  *ENTRY        PLIST
     C***                PARM                    Error            10

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

     C***                eval      Error = '*Exit '
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
     C***                eval      Error = '*Error'
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_ValH - Validate menu code and hierarchy                   *
      *                                                               *
      *****************************************************************
     C     Sr_ValH       BEGSR

      ** do not display yet Group
     C                   seton                                        40
     C                   eval      ErrInd = 'Y'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   WRITE     UP1742F0

     C                   seton                                        28
     C                   WRITE     UP1742C1
     C                   WRITE     UP1742F22

     C                   EXFMT     UP1742F2

     C                   EXSR      CLEAR
     C                   setoff                                       303132

      * Validate menu code  is non blank
     C                   If        XMENU = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM1700'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        30
     C                   EXSR      ZASNMS
     C                   ITER
     C                   ENDIF

      * Validate hierarchy is entered
     C                   If        XHID = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM1702'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        32
     C                   EXSR      ZASNMS
     C                   ITER
     C                   ENDIF

      * Validate hierarchy is entered
     C                   If        XHID <> *blanks
     C                             and XHID <> '?'
     C                   EVAL      X_NUM = XHID
     C                   TESTN                   X_NUM                50
     C                   If        *IN50 = *OFF
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM1703'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        32
     C                   EXSR      ZASNMS
     C                   ITER
     C                   ENDIF
     C                   ENDIF

      ** If '?' is entered
     C     XHID          IFEQ      '?'                                          *IF
     C                   MOVEL     *BLANKS       SHID             15
      * Select RTS Retail Trans. - Retail Transaction Types  *
     C                   CALL      'UP1744S0'
     C                   PARM      *BLANK        W0RTN             7
     C     XHID          PARM      SHID          WQA003           15

      * Validate hid was selected
     C                   If        XHID   = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM1702'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        32
     C                   EXSR      ZASNMS
     C*                  ITER
     C                   ENDIF

     C                   ENDIF

     C                   If        XHID   <> *blanks
     C                   eval      XHIDn = %dec(XHID:15:0)
     C                   eval      RcdCount = 0
     C/EXEC SQL
     C+ SELECT count(*) into :RcdCount
     C+ from T_MNHXTD
     C+ where MHID = :XHIDn and MHDELETED is NULL
     C/END-EXEC

     C                   IF        RcdCount = 0
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM1704'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        32
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_ValG - Validate Group                                     *
      *                                                               *
      *****************************************************************
     C     Sr_ValG       BEGSR

      ** do display Group
     C                   setoff                                       40
      ** and protect menu and hid
     C                   seton                                        20
     C                   eval      ErrInd = 'Y'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   WRITE     UP1742F0

     C                   seton                                        28
     C                   WRITE     UP1742C1
     C                   WRITE     UP1742F22

     C                   EXFMT     UP1742F2

     C                   EXSR      CLEAR
     C                   setoff                                       303132


      * Validate group is entered
     C                   If        XGROUP = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM1701'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        31
     C                   EXSR      ZASNMS
     C*                  ITER
     C                   ENDIF

      * Validate group is numeric
     C                   If        XGROUP <> *blanks
     C                             and XGROUP <> '?'
     C                   EVAL      X_NUM = XGROUP
     C                   TESTN                   X_NUM                50
     C                   If        *IN50 = *OFF
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM1703'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        31
     C                   EXSR      ZASNMS
     C                   ITER
     C                   ENDIF
     C                   ENDIF

      ** If '?' is entered
     C     XGROUP        IFEQ      '?'                                          *IF
     C                   MOVEL     *BLANKS       SGROUP           15
      * Select RTS Retail Trans. - Retail Transaction Types  *
     C                   CALL      'UP1743S0'
     C                   PARM      *BLANK        W0RTN             7
     C     XGROUP        PARM      SGROUP        WQA003           15
     C                   PARM                    XHID

      * Validate group was selected
     C                   If        XGROUP = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM1701'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        31
     C                   EXSR      ZASNMS
     C*                  ITER
     C                   ENDIF

     C                   ENDIF

     C                   If        XGROUP <> *blanks
      * accept XGROUP = '000000000000000' for option added under hierarchy (like 0000002765)
     C                             and XGROUP <> '000000000000000'
     C                   eval      XGROUPn = %dec(XGROUP:15:0)
     C                   eval      RcdCount = 0
     C/EXEC SQL
     C+ SELECT count(*) into :RcdCount
     C+ from T_MNGXTD
     C+ where ((MGID = :XGROUPn and MGDELETED <> 'Y') or
     C+       (MGID = :XGROUPn  and MGDELETED IS NULL))
     C+       and MGHYID = :XHIDn
     C/END-EXEC

     C                   IF        RcdCount = 0
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM1706'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        31
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
