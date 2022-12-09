     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*XBI *  OVRDBF FILE(UPOBJCTPD) TOFILE(UPDBRLPD)                      *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTR deliverable data split save')             *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP004030 - Midas UP OTR deliverable data split refresh       *
      *                                                               *
      *  Function: This program saves all BTD/XTD tables in either    *
      *            GM or DMLIB. It also creates the SAVF in the       *
      *            Brdige library.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CUP045 *CREATE     Date 09Dec22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP045 - One Touch Bridge - refresh                          *
      *         - Applied for MD060769.                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index.                                            *
      *                                                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Display File
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
      ** Declared Variables
     D ArrFLADS        DS
     D ArrFLADS1               1   3000
     D ArrFLADS2            3001   6000
     D ArrFLADS3            6001   9000
     D ArrFLADS4            9001   9999
     D sqlStat         S           5000A
     D ArrFl           S             10    DIM(999)
     D ArrFlA          S             10    DIM(999)
     D ArrDs           S             50    DIM(999)
     D ArrDsA          S             50    DIM(999)
     D Ix              S              5  0
     D IxA             S              5  0
     D SavInKK         S              1
      ** ZASNMS Variables
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
     D SAVE            S              1A
     D SAVOBJ          S          10000A
     D Cmd_String      S          10300
     D Cmd_Len         S             15  5
     D SAVLIB          S             10A
     D DBASE           S              3A

     D UPCTDF        E DS                  EXTNAME(UPOBJCTPD)
       /EJECT
      *****************************************************************


      ** Process first screen.
     C                   EXSR      LoadSubfile
      *
      ** If save has bee requested
     C                   EXSR      Sr_Save
      *
      ** End of program.
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_Save - Save files                                         *
      *                                                               *
      *****************************************************************
     C     Sr_Save       BEGSR

      ** delete save file
     C                   EVAL      Cmd_Len = 100
     C                   eval      PSExcpNo = '    '
     C                   If        Layer = '*GLOBAL'
     C                   EVAL      Cmd_String = 'DLTF FILE(' +%trimr(SVAL1) +
     C                             '/SAVF_RFR_G)'
     C                   Else
     C                   EVAL      Cmd_String = 'DLTF FILE(' +%trimr(SVAL1) +
     C                             '/SAVF_RFR1Z)'
     C                   Endif
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if error other than 'SAVF not found'
     C                   If        PSExcpNo <> '    '
     C                             and PSExcpNo <> '2105'
     C                   eval      DBASE = '100'
     C                   EXSR      *pssr
     C                   Endif

      ** If *ZONE, delete the second SAVF
     C                   If        Layer = '*ZONE  '
     C                   eval      PSExcpNo = '    '
     C                   EVAL      Cmd_String = 'DLTF FILE(' +%trimr(SVAL1) +
     C                             '/SAVF_RFR2Z)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if error other than 'SAVF not found'
     C                   If        PSExcpNo <> '    '
     C                             and PSExcpNo <> '2105'
     C                   eval      DBASE = '101'
     C                   EXSR      *pssr
     C                   Endif
     C                   Endif

      ** create save file
     C                   EVAL      Cmd_Len = 100
     C                   eval      PSExcpNo = '    '
     C                   If        Layer = '*GLOBAL'
     C                   EVAL      Cmd_String = 'CRTSAVF FILE(' +%trimr(SVAL1) +
     C                             '/SAVF_RFR_G)'
     C                   Else
     C                   EVAL      Cmd_String = 'CRTSAVF FILE(' +%trimr(SVAL1) +
     C                             '/SAVF_RFR1Z)'
     C                   Endif
     C                   eval      PSExcpNo = '    '
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if error
     C                   If        PSExcpNo <> '    '
     C                   eval      DBASE = '102'
     C                   EXSR      *pssr
     C                   Endif

      ** If *ZONE, create second SAVF
     C                   If        Layer = '*ZONE  '
     C                             and ArrFl(1) = *blanks
     C                   EVAL      Cmd_Len = 100
     C                   EVAL      Cmd_String = 'CRTSAVF FILE(' +%trimr(SVAL1) +
     C                             '/SAVF_RFR2Z)'
     C                   eval      PSExcpNo = '    '
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if error
     C                   If        PSExcpNo <> '    '
     C                   eval      DBASE = '103'
     C                   EXSR      *pssr
     C                   Endif
     C                   Endif

      ** save all files selected
     C                   EVAL      Cmd_Len = 10300
     C                   MOVEA     ArrFlA        ArrFLADS
     C                   MOVEL     ArrFLADS1     SAVOBJ
     C                   If        Layer = '*GLOBAL'
     C                   EVAL      Cmd_String = 'SAVOBJ (' +
     C                             %trimr(SAVOBJ) + ') LIB(' + %trimr(SAVLIB) +
     C                             ') DEV(*SAVF) SAVF(' + %trimr(SVAL1) +
     C                             '/SAVF_RFR_G)'
     C                   Else
     C                   EVAL      Cmd_String = 'SAVOBJ (' +
     C                             %trimr(SAVOBJ) + ') LIB(' + %trimr(SAVLIB) +
     C                             ') DEV(*SAVF) SAVF(' + %trimr(SVAL1) +
     C                             '/SAVF_RFR1Z)'
     C                   Endif
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if error
     C                   If        PSExcpNo <> '    '
     C                   eval      DBASE = '104'
     C                   EXSR      *pssr
     C                   Endif

      ** If *ZONE, save files in second SAVF if any
     C                   If        Layer = '*ZONE  '
     C                             and ArrFLADS2 <> *blanks
     C                   MOVEL     ArrFLADS2     SAVOBJ
     C                   EVAL      Cmd_String = 'SAVOBJ (' +
     C                             %trimr(SAVOBJ) + ') LIB(' + %trimr(SAVLIB) +
     C                             ') DEV(*SAVF) SAVF(' + %trimr(SVAL1) +
     C                             '/SAVF_RFR2Z)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if error
     C                   If        PSExcpNo <> '    '
     C                   eval      DBASE = '105'
     C                   EXSR      *pssr
     C                   Endif
     C                   Endif

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  LoadSubfile - Display all records to subfile                 *
      *                                                               *
      *****************************************************************
     C     LoadSubfile   BEGSR
      *
      ** Prepare statement
     C                   clear                   ArrFlA
     C                   eval      IxA = 0
     C                   eval      sqlStat = *BLANKS
     C                   eval      sqlStat = 'select ' +
     C                             ' * from UPOBJCTPD order by WHRFI'

     C/EXEC SQL
     C+ prepare sqlStat
     C+ from :sqlStat
     C/END-EXEC

     C/exec SQL
     C+ declare UPGDRCursor insensitive scroll cursor for
     C+ sqlStat
     C/end-exec

     C/exec SQL
     C+ open UPGDRCursor
     C/end-exec
      *
      ** take into account that each CTD has one BTD and one XTD
     C/exec SQL
     C+ fetch next from UPGDRCursor into :UPCTDF
     C/end-exec

     C                   DOW       SQLCODE = 0
      ** load BTD in array for all
     C                   eval      IxA = IxA + 1
     C                   eval      ArrFlA(IxA) = %subst(WHRFI:1:5) + 'BTD'

      ** and load XTD
     C                   eval      IxA = IxA + 1
     C                   eval      ArrFlA(IxA) = %subst(WHRFI:1:5) + 'XTD'
     C/exec SQL
     C+ fetch next from UPGDRCursor into :UPCTDF
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close UPGDRCursor
     C/end-exec

     C     LoadSubfileE  ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    CurSys            2
     C                   PARM                    Layer             7
     C                   PARM                    SVAL1            10
     C                   PARM                    Return           10



     C                   If        Layer = '*GLOBAL'
     C                   eval      SAVLIB = CurSys + 'GMLIB'
     C                   else
     C                   eval      SAVLIB = CurSys + 'DMLIB'
     C                   ENDIF

     C     INZSRE        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Exit - Exit program                                          *
      *                                                               *
      *****************************************************************
     C     Exit          BEGSR
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     ExitE         ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
