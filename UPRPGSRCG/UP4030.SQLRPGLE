     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*XBI *  OVRDBF FILE(UPOBJCTPD) TOFILE(UPDBRLPD)                      *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP savobj BTD-XTD tables')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP4030 - SAVOBJ BTD and XTD tables                           *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD059918           Date 09Dec22               *
      *  Prev Amend No. MD059476 *CREATE   Date 09Dec22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059918 - Save and restore more than 300 tables             *
      *           - Applied for MD060769.                             *
      *  MD059476 - Bridge improvement for refresh                    *
      *           - Applied for MD060769.                             *
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
     FUP4030GF  CF   E             WORKSTN
     F                                     SFILE(UP4030S0:RdCtr)
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
     D RdCtr           S             10  0
     D TotRow          S             13  0
     D RecCount        S              5  0
     D ExistYN         S             10A
     D Library         S             10A
     D ObjectType      S              7A
     D Member          S             10A
     D sqlStat         S           5000A
     D ArrFl           S             10    DIM(999)
     D ArrFlA          S             10    DIM(999)
     D ArrDs           S             50    DIM(999)
     D ArrDsA          S             50    DIM(999)
     D Ix              S              5  0
     D IxA             S              5  0
     D SavInKK         S              1
     D ArrFLADS        DS                                                                   MD059918
     D ArrFLADS1               1   3000                                                     MD059918
     D ArrFLADS2            3001   6000                                                     MD059918
     D ArrFLADS3            6001   9000                                                     MD059918
     D ArrFLADS4            9001   9999                                                     MD059918
      ** ZASNMS Variables
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
      ** Error Indicators
     D ErIOff          S             15
     D ErrInd          S              1
     D ErrFlg          S              1
      ** CBTIME Parameters
     D DayNoa          S              5
     D STime           S              6
     D DFmt            S              1
      ** ZDATE2 Parameters
     D CurrDt          S              5  0
     D WQ0003          S              6  0
     D ZDate           S              7

     D GVALUE          S             20A   INZ('BrgDeliveredBrgLib')
     D SAVE            S              1A
     D SAVOBJ          S          10000A
     D Cmd_String      S          10300
     D Cmd_Len         S             15  5
     D SAVLIB          S             10A

     D UPCTDF        E DS                  EXTNAME(UPOBJCTPD)
      * Parameters for the QDBRTVFD API.
     D RcvrLen         S              9B 0 INZ(6400)
     D QualFRtn        S             20A
     D FormatRtn       S              8A   INZ('FILD0100')
     D QualFSent       S             20A
     D RcdFmtName      S             10A   INZ('*FIRST')
     D Override        S              1A   INZ('1')
     D System          S             10A   INZ('*LCL')
      * Format type (not actually used for the format we are requesting,
      *  but a required parameter).
     D FormatType      S             10A   INZ('*INT')
     D OUTDATA         S           6400A   INZ(*BLANKS)
     D ReturnCode      S              7
     D*COPY ZACPYSRC,PSDS
      * The following /COPY lines include the structures necessary for the
      *  QDBRTVFD API.  The first is specific to that API; the second is
      *  the generic API error structure.
     D/COPY QSYSINC/QRPGLESRC,QDBRTVFD
     D/COPY QSYSINC/QRPGLESRC,QUSEC
       /EJECT
      *****************************************************************


      ** Main process.
     C                   DOW       *INKC = *OFF
      *
      ** Display column headings on subfile.
     C                   EVAL      *IN30 = *ON
      *
      ** Process first screen.
     C                   EXSR      LoadSubfile
      *
      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF
      *
      ** If save has bee requested
     C                   IF        SAVE = 'Y'
     C                   EXSR      Sr_Save
     C                   ENDIF
      *
     C                   EXSR      GetRecord
      *
     C                   ENDDO
      *
      ** End of program.
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetRecord - Load the selected record to second screen        *
      *                                                               *
      *****************************************************************
     C     GetRecord     BEGSR

     C                   eval      Ix = 0
      ** Read changed record and process it
     C                   READC     UP4030S0                               29
     C                   DOW       *IN29 = *OFF

     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFACTC = *blank

      ** store file name and its description in array
     C                   eval      Ix = Ix + 1
     C                   eval      ArrFl(Ix) = DFFILE
     C                   eval      ArrDs(Ix) = DFDESC

     C                   UPDATE    UP4030S0
     C                   READC     UP4030S0                               29
     C                   ENDDO
      *
     C     GetRecordE    ENDSR
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
     C**********                   '/SAVF_RFR_Z)'                                           MD059918
     C                             '/SAVF_RFR1Z)'                                           MD059918
     C                   Endif
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if error other than 'SAVF not found'
     C                   If        PSExcpNo <> '    '
     C                             and PSExcpNo <> '2105'
     C                   EXSR      Sr_Error
     C                   Endif

      ** If *ZONE, delete the second SAVF                                                   MD059918
     C                   If        Layer = '*ZONE  '                                        MD059918
     C                   eval      PSExcpNo = '    '                                        MD059918
     C                   EVAL      Cmd_String = 'DLTF FILE(' +%trimr(SVAL1) +               MD059918
     C                             '/SAVF_RFR2Z)'                                           MD059918
     C                   CALL      'QCMDEXC'                            20                  MD059918
     C                   PARM                    Cmd_String                                 MD059918
     C                   PARM                    Cmd_Len                                    MD059918
                                                                                            MD059918
      ** if error other than 'SAVF not found'                                               MD059918
     C                   If        PSExcpNo <> '    '                                       MD059918
     C                             and PSExcpNo <> '2105'                                   MD059918
     C                   EXSR      Sr_Error                                                 MD059918
     C                   Endif                                                              MD059918
     C                   Endif                                                              MD059918
                                                                                            MD059918
      ** create save file
     C                   EVAL      Cmd_Len = 100
     C                   eval      PSExcpNo = '    '
     C                   If        Layer = '*GLOBAL'
     C                   EVAL      Cmd_String = 'CRTSAVF FILE(' +%trimr(SVAL1) +
     C                             '/SAVF_RFR_G)'
     C                   Else
     C                   EVAL      Cmd_String = 'CRTSAVF FILE(' +%trimr(SVAL1) +
     C**********                   '/SAVF_RFR_Z)'                                           MD059918
     C                             '/SAVF_RFR1Z)'                                           MD059918
     C                   Endif
     C                   eval      PSExcpNo = '    '
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if error
     C                   If        PSExcpNo <> '    '
     C                   EXSR      Sr_Error
     C                   Endif

      ** If *ZONE, create second SAVF                                                       MD059918
     C                   If        Layer = '*ZONE  '                                        MD059918
     C                             and ArrFl(1) = *blanks                                   MD059918
     C                   EVAL      Cmd_Len = 100                                            MD059918
     C                   EVAL      Cmd_String = 'CRTSAVF FILE(' +%trimr(SVAL1) +            MD059918
     C                             '/SAVF_RFR2Z)'                                           MD059918
     C                   eval      PSExcpNo = '    '                                        MD059918
     C                   CALL      'QCMDEXC'                            20                  MD059918
     C                   PARM                    Cmd_String                                 MD059918
     C                   PARM                    Cmd_Len                                    MD059918
                                                                                            MD059918
      ** if error                                                                           MD059918
     C                   If        PSExcpNo <> '    '                                       MD059918
     C                   EXSR      Sr_Error                                                 MD059918
     C                   Endif                                                              MD059918
     C                   Endif                                                              MD059918
                                                                                            MD059918
      ** save all files selected
     C                   EVAL      Cmd_Len = 10300
     C                   if        ArrFl(1) <> *blanks
     C                   MOVEA     ArrFl         SAVOBJ
     C                   else
     C**********         MOVEA     ArrFlA        SAVOBJ                                     MD059918
     C                   MOVEA     ArrFlA        ArrFLADS                                   MD059918
     C                   MOVEL     ArrFLADS1     SAVOBJ                                     MD059918
     C                   endif
     C                   If        Layer = '*GLOBAL'
     C                   EVAL      Cmd_String = 'SAVOBJ (' +
     C                             %trimr(SAVOBJ) + ') LIB(' + %trimr(SAVLIB) +
     C                             ') DEV(*SAVF) SAVF(' + %trimr(SVAL1) +
     C                             '/SAVF_RFR_G)'
     C                   Else
     C                   EVAL      Cmd_String = 'SAVOBJ (' +
     C                             %trimr(SAVOBJ) + ') LIB(' + %trimr(SAVLIB) +
     C                             ') DEV(*SAVF) SAVF(' + %trimr(SVAL1) +
     C**********                   '/SAVF_RFR_Z)'                                           MD059918
     C                             '/SAVF_RFR1Z)'                                           MD059918
     C                   Endif
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if error
     C                   If        PSExcpNo <> '    '
     C                   EXSR      Sr_Error
     C                   Endif

      ** If *ZONE, save files in second SAVF if any                                         MD059918
     C                   If        Layer = '*ZONE  '                                        MD059918
     C                             and ArrFLADS2 <> *blanks                                 MD059918
     C                   MOVEL     ArrFLADS2     SAVOBJ                                     MD059918
     C                   EVAL      Cmd_String = 'SAVOBJ (' +                                MD059918
     C                             %trimr(SAVOBJ) + ') LIB(' + %trimr(SAVLIB) +             MD059918
     C                             ') DEV(*SAVF) SAVF(' + %trimr(SVAL1) +                   MD059918
     C                             '/SAVF_RFR2Z)'                                           MD059918
     C                   CALL      'QCMDEXC'                            20                  MD059918
     C                   PARM                    Cmd_String                                 MD059918
     C                   PARM                    Cmd_Len                                    MD059918
                                                                                            MD059918
      ** if error                                                                           MD059918
     C                   If        PSExcpNo <> '    '                                       MD059918
     C                   EXSR      Sr_Error                                                 MD059918
     C                   Endif                                                              MD059918
     C                   Endif                                                              MD059918

     C     Sr_SaveE      ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  LoadSubfile - Display all records to subfile                 *
      *                                                               *
      *****************************************************************
     C     LoadSubfile   BEGSR
      *
      ** Clear subfile.
     C                   IF        ErrInd <> 'Y'
     C                             and *IN31 = *OFF
     C                             or *INKE = *ON
     C                   EVAL      *IN26 = *ON
     C                   WRITE     UP4030C0
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      RdCtr = 0
     C                   ENDIF

     C                   IF        *INKE = *ON
     C                   clear                   ArrFl
     C                   clear                   ArrDs
     C                   clear                   ArrFlA                                     MD059918
     C                   clear                   ArrDsA                                     MD059918
     C                   clear                   ArrFLADS                                   MD059918
     C                   ENDIF
      ** Set on control.
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN23 = *ON

      ** If save was requested
     C                   If        *INKI = *ON
     C                             or *INKF = *ON
     C                   eval      Ix = 1
     C                   eval      IxA = 1
     C                   else
      ** Prepare statement
     C                   clear                   ArrFl                                      MD059918
     C                   clear                   ArrDs                                      MD059918
     C                   clear                   ArrFlA
     C                   clear                   ArrDsA                                     MD059918
     C                   clear                   ArrFLADS                                   MD059918
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
      ** Get the number of rows of the selected records.
     C/exec SQL
     C+ get diagnostics :TotRow  = db2_number_rows
     C/end-exec

      ** take into account that each CTD has one BTD and one XTD
     C                   eval      TotRow = TotRow * 2
     C/exec SQL
     C+ fetch next from UPGDRCursor into :UPCTDF
     C/end-exec
      *
     C                   ENDIF
      *
      ** Process if no record on file.
     C                   IF        SQLCODE = 100
     C*                            and DFSRCH = *blanks
     C*                  EVAL      DFSRCH = *blanks
     C*                  EVAL      DFSRCHL = *blanks
     C*                  EVAL      DFSRCHA = *blanks
     C*                  EVAL      DFSRCHAL = *blanks
     C*                  EVAL      DFSRCHC = *blanks
     C*                  EVAL      DFSRCHE = *blanks
      *
     C                   DOW       *INKC = *OFF
     C                             and *INKI = *OFF
     C                             and *INKE = *OFF
     C                             and *INKF = *OFF
     C                   EXSR      ClearFlds
     C                   EVAL      *IN28 = *ON
      *
     C                   WRITE     UP4030F0
     C                   WRITE     UP4030F1
      *
     C                   WRITE     UP4030C1
     C                   EXFMT     UP4030F3
     C                   EVAL      ErrInd = 'N'
     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   ENDDO
      *
     C                   ELSE
      *
      ** Load records to subfile
     C                   IF        ErrInd <> 'Y'
     C                             and *IN31 = *OFF
     C                             or *INKE = *ON
     C                   DOW       TotRow > RdCtr
     C                             and 9999   > RdCtr
     C                             and *INKI = *OFF
     C                             and *INKF = *OFF
     C                             or (*INKI = *ON
     C                             and ArrFl(Ix) <> *blanks)
     C                             or (*INKF = *ON
     C                             and ArrFlA(IxA) <> *blanks)
     C                   EVAL      RdCtr = RdCtr + 1
     C                   EXSR      MoveData

     C                   if        *INKI = *ON
     C                             or *INKF = *ON
     C                   seton                                        31
     C                   ENDIF

     C                   WRITE     UP4030S0
     C                   EXSR      ClearFlds

      ** and load XTD
     C                   If        *INKI = *OFF
     C                             and *INKF = *OFF
     C                   EVAL      RdCtr = RdCtr + 1
     C                   EXSR      MoveDataX
     C                   WRITE     UP4030S0
     C                   EXSR      ClearFlds
     C                   ENDIF

     C                   If        *INKI = *ON
     C                             or *INKF = *ON
     C                   eval      Ix = Ix + 1
     C                   eval      IxA = IxA + 1
     C                   else
     C/exec SQL
     C+ fetch next from UPGDRCursor into :UPCTDF
     C/end-exec
     C                   endif
      *
     C                   ENDDO
     C                   ENDIF
      *
      ** Load screen.
     C                   WRITE     UP4030F0
     C                   if        *INKI = *ON
     C                             or *INKF = *ON
     C                   If        Layer = '*GLOBAL'
     C                   eval      DFCONF = 'These tables will be' +
     C                             ' saved in ' + %trimr(SVAL1) +
     C                             '/SAVF_RFR_G. Press enter to confirm.'
     C                   else
     C                   eval      DFCONF = 'These tables will be' +
     C                             ' saved in ' + %trimr(SVAL1) +
     C                             '/SAVF_RFR_Z. Press enter to confirm.'
     C                   endif
     C                   eval      SAVE = '?'
     C                   WRITE     UP4030F4
     C                   else
     C                   if        SAVE = 'Y'
     C                   eval      SAVE = ' '
     C                   If        Layer = '*GLOBAL'
     C                   eval      DFCONF = 'Tables are' +
     C                             ' saved in ' + %trimr(SVAL1) +
     C                             '/SAVF_RFR_G.'
     C                   else
     C                   eval      DFCONF = 'Tables are' +
     C                             ' saved in ' + %trimr(SVAL1) +
     C                             '/SAVF_RFR_Z.'
     C                   endif
     C                   WRITE     UP4030F4
     C                   else
     C                   eval      SAVE = ' '
     C                   WRITE     UP4030F1
     C                   ENDIF
     C                   endif
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UP4030C1
     C                   ENDIF
      *
      * Save F11 toggle indicator
     C                   eval      SavInKK = *INKK

     C                   EXFMT     UP4030C0
      *
      * If F12 is pressed, it should process the same as F5
     C                   if        *INKL = '1'
     C                   eval      *INKE = '1'
     C                   eval      *INKL = '0'
     C                   ENDIF

     C                   If        SAVE = '?'
     C                             and *INKE = '0' and *INKC = '0'
     C                   eval      SAVE = 'Y'
     C                   ENDIF

     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
     C                   ENDIF
     C/exec SQL
     C+ close UPGDRCursor
     C/end-exec
      *
     C     LoadSubfileE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  MoveData - Move data fields to display file                  *
      *                                                               *
      *****************************************************************
     C     MoveData      BEGSR

     C                   If        *INKI = *ON
      ** for SAVE, retrieve file names from array
     C                   EVAL      DFFILE = ArrFl(Ix)
     C                   EVAL      DFDESC = ArrDs(Ix)
     C                   If        Layer = '*GLOBAL'
     C                   EVAL      DFLIBR = CurSys + 'GMLIB'
     C                   else
     C                   eval      DFLIBR = CurSys + 'DMLIB'
     C                   ENDIF

     C                   else
     C                   If        *INKF = *ON
      ** for SAVE, retrieve file names from array
     C                   EVAL      DFFILE = ArrFlA(IxA)
     C                   EVAL      DFDESC = ArrDsA(IxA)
     C                   If        Layer = '*GLOBAL'
     C                   EVAL      DFLIBR = CurSys + 'GMLIB'
     C                   else
     C                   eval      DFLIBR = CurSys + 'DMLIB'
     C                   ENDIF

     C                   else
      ** else, get BTD
     C                   EVAL      DFACTC = *blank
     C                   EVAL      DFFILE  = %subst(WHRFI:1:5) + 'BTD'
     C                   If        Layer = '*GLOBAL'
     C                   EVAL      DFLIBR = CurSys + 'GMLIB'
     C                   else
     C                   eval      DFLIBR = CurSys + 'DMLIB'
     C                   ENDIF

      * Clear the returned error structure before passing it.
     C                   CLEAR                   QUSEC
      *
      * Set up the 'Bytes provided' field for the API error structure.
     C                   EVAL      QUSBPRV = 16
      *
      * Set up the qualified file name sent to the API.
     C                   EVAL      QualFSent = DFFILE   + DFLIBR
      *
     C                   CALL      'QDBRTVFD'
     C                   PARM                    OUTDATA
     C                   PARM                    RcvrLen
     C                   PARM                    QualFRtn
     C                   PARM                    FormatRtn
     C                   PARM                    QualFSent
     C                   PARM                    RcdFmtName
     C                   PARM                    Override
     C                   PARM                    System
     C                   PARM                    FormatType
     C                   PARM                    QUSEC
      *
      * If the API returned an error, indicate this to the caller.
     C                   EVAL      ReturnCode = QUSEI
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      DFDESC = %SUBST(OutData:85:50)
     C                   else
     C                   EVAL      DFDESC = 'ERROR - File not found'
     C                   ENDIF

      ** load BTD in array for all
     C                   eval      IxA = IxA + 1
     C                   eval      ArrFlA(IxA) = DFFILE
     C                   eval      ArrDsA(IxA) = DFDESC

     C                   ENDIF
     C                   ENDIF
     C     MoveDataE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  MoveDataX - Move data fields to display file                 *
      *                                                               *
      *****************************************************************
     C     MoveDataX     BEGSR

      ** else, get XTD
     C                   EVAL      DFACTC = *blank
     C                   EVAL      DFFILE  = %subst(WHRFI:1:5) + 'XTD'
     C                   If        Layer = '*GLOBAL'
     C                   EVAL      DFLIBR = CurSys + 'GMLIB'
     C                   else
     C                   eval      DFLIBR = CurSys + 'DMLIB'
     C                   ENDIF

      * Clear the returned error structure before passing it.
     C                   CLEAR                   QUSEC
      *
      * Set up the 'Bytes provided' field for the API error structure.
     C                   EVAL      QUSBPRV = 16
      *
      * Set up the qualified file name sent to the API.
     C                   EVAL      QualFSent = DFFILE   + DFLIBR
      *
     C                   CALL      'QDBRTVFD'
     C                   PARM                    OUTDATA
     C                   PARM                    RcvrLen
     C                   PARM                    QualFRtn
     C                   PARM                    FormatRtn
     C                   PARM                    QualFSent
     C                   PARM                    RcdFmtName
     C                   PARM                    Override
     C                   PARM                    System
     C                   PARM                    FormatType
     C                   PARM                    QUSEC
      *
      * If the API returned an error, indicate this to the caller.
     C                   EVAL      ReturnCode = QUSEI
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      DFDESC = %SUBST(OutData:85:50)
     C                   else
     C                   EVAL      DFDESC = 'ERROR - File not found'
     C                   ENDIF

      ** load XTD in array for all
     C                   eval      IxA = IxA + 1
     C                   eval      ArrFlA(IxA) = DFFILE
     C                   eval      ArrDsA(IxA) = DFDESC

     C     MoveDataXE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * ResetInds - Reset error indicators                            *
      *                                                               *
      *****************************************************************
     C     ResetInds     BEGSR
      *
      ** Set off Error Indicators
     C                   MOVEA     ErIOff        *IN(70)
     C                   EVAL      *IN28 = *OFF
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      *IN44 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF
      *
     C     ResetIndsE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Clear - Clear the error messages on the subfile               *
      *                                                               *
      *****************************************************************
     C     Clear         BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DFPGMQ        ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
     C     ClearE        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ClearFlds - Clear display file fields                        *
      *                                                               *
      *****************************************************************
     C     ClearFlds     BEGSR
      *
     C                   EVAL      DFFILE  = *blanks
     C                   EVAL      DFLIBR  = *blanks
     C                   EVAL      DFACTN = *blanks
      *
     C     ClearFldsE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_Error                                                     *
      *                                                               *
      *****************************************************************
      *
     C     Sr_Error      BEGSR

     C                   exsr      Clear
     C                   EVAL      ZAPGMQ = DFPGMQ

     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM      'UT00001'     ZAMSID
     C                   PARM      'UTMSGF'      ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP

     C                   eval      ERRIND = 'Y'
     C                   seton                                        31
     C                   DUMP

     C                   ENDSR

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
     C                   PARM                    Return           10

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
      *
      ** Perform checks as to whether fields are displayed or not.
     C                   EXSR      NonDisplay
      *
     C                   EVAL      RdCtr = 0
     C                   EVAL      ErrInd = 'N'
     C                   EVAL      ErIOff = '000000000000000'

      * get System Value
      * Call Access object:
     C                   CALL      'GPAOSVALR0'
     C                   PARM                    RTNCDE            7
     C                   PARM      GVALUE        SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM                    SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK0           20
     C                   PARM                    SVAL10          200
      * If the system value is not found then issue a database error
     C     RTNCDE        IFNE      '      '
     C                   MOVEL     'GPSVALPD'    DBFILE           10
     C                   Z-ADD     95            DBASE             5 0
     C                   MOVEL     'SVALK1'      DBKEY            10
     C                   EXSR      *PSSR
     C                   ELSE
     C     SVAL1         IFEQ      *BLANKS
     C                   ENDIF
     C                   ENDIF

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
      *  NonDisplay - Set on indicators to not display fields         *
      *                                                               *
      *****************************************************************
      *
     C     NonDisplay    BEGSR
      *
     C     NonDisplayE   ENDSR
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
