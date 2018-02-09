     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP AO Zones by prefix')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  GPAOZONER1 - Read access to global zones file                *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUP002  *CREATE    Date 12Aug10               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP002 - Check zone entered is defined on GPZONEPD.          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01        *OFF 1st time round                              *
      *    90         File Error                                      *
      *    91         File Open Error                                 *
      *    92         Error on File Close                             *
      *    93         File Empty                                      *
      *    94         Eof                                             *
      *    95         No Record Found                                 *
      *    96         Parameter Error                                 *
      *    LR         Last Record                                     *
      *                                                               *
      *****************************************************************
     FGPZONEL2  IF   E           K DISK    USROPN
      *
     D PMsgDta         DS
     D  MsgDta                 1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D PReturnCode     S              7
     D POption         S              7
     D PZonePfx        S              2
     D WReturnCode     S              7
     D PPgmName        S             10
     D PDest           S              5
     D PMsgID          S              7
     D PMsgf           S             10
     D PMsgKey         S              4
     D PMsgType        S              7
      *
     D PGMDS          SDS
      * Program Status data structure
     D  PgmName                1     10
     D  PgmLib                81     90
     D  PgmJob               244    253
     D  PgmUser              254    263
     D  PgmJobNo             264    269  0
      *
     D DFormat       E DS                  EXTNAME(GPZONEPD)
      *
     D PFormat       E DS                  EXTNAME(DSFDY)
      *
     C     *ENTRY        PLIST
     C     WReturnCode   PARM                    PReturnCode
     C                   PARM                    POption
     C                   PARM                    PZonePfx
     C                   PARM                    PFormat
      *
     C                   IF        POption = '*SAME  '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      SkipTag
     C                   ENDIF
      *
     C                   MOVEA     '00000000'    *IN(90)
      *
      * First call - open file.
     C                   IF        *IN01 = *OFF
     C                   SETON                                        01
     C                   OPEN      GPZONEL2                             91
     C     *IN91         CABEQ     '1'           SkipTag                  LR
     C                   ENDIF
      *
      * Last call - close file and terminate program :
     C                   IF        POption = '*FREE  '
     C                   CLOSE     GPZONEL2                             92
     C     *IN92         CABEQ     '1'           SkipTag                  LR
     C                   SETON                                        LR
     C                   ENDIF
      *
      * Caller requests first record.
     C                   IF        POption = '*FIRST '
     C     *LOVAL        SETLL     GPZONED0                           9390
     C     *IN93         CABEQ     '1'           SkipTag
     C     *IN90         CABEQ     '1'           SkipTag                  LR
     C                   MOVE      '*NEXT  '     POption
     C                   ENDIF
      *
      * Caller requests next record.
     C                   IF        POption = '*NEXT  '
     C                   READ      GPZONED0                             9094
     C     *IN94         CABEQ     '1'           SkipTag
     C     *IN90         CABEQ     '1'           SkipTag                  LR
     C                   ENDIF
      *
      * Caller requests last record.
     C                   IF        POption = '*LAST  '
     C     *HIVAL        SETGT     GPZONED0                             90
     C     *IN90         CABEQ     '1'           SkipTag                  LR
     C                   EVAL      POption = '*PREV  '
     C                   ENDIF
      *
      * Caller requests previous record.
     C                   IF        POption = '*PREV  '
     C                   READP     GPZONED0                             9094
     C     *IN94         CABEQ     '1'           SkipTag
     C     *IN90         CABEQ     '1'           SkipTag                  LR
     C                   ENDIF
      *
      * Caller requests record indicated by key.
     C                   IF        POption = '*KEY   ' or
     C                             POption = '*VERIFY'
     C     PZonePfx      CHAIN     GPZONEL2                           9590
     C     *IN95         CABEQ     '1'           SkipTag
     C     *IN90         CABEQ     '1'           SkipTag                  LR
     C                   ENDIF
      *
     C                   IF        POption <> '*KEY   ' and
     C                             POption <> '*NEXT  ' and
     C                             POption <> '*PREV  ' and
     C                             POption <> '*VERIFY' and
     C                             POption <> '*FREE  '
     C                   SETON                                          96
     C                   ENDIF
      *
      * No record found or End of file - return error code.
     C     SkipTag       TAG
      *
     C                   EVAL      PReturnCode =  *BLANK
     C   90              EVAL      PReturnCode =  '*ERROR '
     C   91              EVAL      PReturnCode =  '*OPEN  '
     C   92              EVAL      PReturnCode =  '*CLOSE '
     C   93              EVAL      PReturnCode =  '*EMPTY '
     C   94              EVAL      PReturnCode =  '*EOF   '
     C   95              EVAL      PReturnCode =  '*NRF   '
     C   96              EVAL      PReturnCode =  '*OPTION'
      *
      * Caller requests message sent to program queue.
     C     WReturnCode   IFEQ      '*MSG   '
     C     PReturnCode   ANDNE     *BLANK
     C   90              EVAL      PMsgID = 'ACO1001'
     C   91              EVAL      PMsgID = 'ACO1002'
     C   92              EVAL      PMsgID = 'ACO1003'
     C   93              EVAL      PMsgID = 'ACO1004'
     C   94              EVAL      PMsgID = 'ACO1005'
     C   95              EVAL      PMsgID = 'ACO1006'
     C   96              EVAL      PMsgID = 'ACO1007'
      *
     C                   CALLB     'GPZASNMG'
     C                   PARM      *blanks       WReturnCode       7
     C                   PARM      PgmName       PPgmName         10
     C                   PARM      '*PRV'        PDest             5
     C                   PARM                    PMsgiD            7
     C                   PARM      *blanks       PMsgf            10
     C                   PARM      *blanks       PMsgKey           4
     C                   PARM                    PMsgDta          50
     C                   PARM      '*DIAG'       PMsgType          7
     C                   ENDIF
      *
      * Caller Requests DB Error Handling.
     C                   IF        WReturnCode = '*DBERR ' and
     C                             PReturnCode <> *blanks
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   IF        POption <> '*VERIFY' and
     C                             POption <> '*FREE  ' and
     C                             PReturnCode <> '*OPTION'
     C                   MOVEL     DFormat       PFormat
     C                   ENDIF
      *
      * Return to caller.
     C                   RETURN
      *****************************************************
** MG
GPZONEPD  GPAOZONER1  Zones
