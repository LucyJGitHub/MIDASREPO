     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas MR MBI Incremental File Extraction Program')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR001004 - Midas MR MBI Process Incremental File Extraction  *
      *                                                               *
      *  Function: This program will be called by MRC001001 to        *
      *            receive journal entries for incremental extract.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR828013 *CREATE   Date 30Sep11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR828013 - Incremental database for MBI (CCR036)             *
      *                                                               *
      *****************************************************************
 
      ** Midas MR MBI Extract Key Details File
 
     FMRKEYDPD  UF A E           K DISK    USROPN
 
     D DSFFD           DS                  BASED(DTAPTR)
     D  DFLD                   1     10
     D  DPOS                  13     16B 0
     D  DLEN                  21     24B 0
 
     D ExtLibr         S             10    DTAARA('EXTRLIB')
 
     D PMode           S              7A
     D PEvt            S             20A
     D PFlg            S              1A
     D PJrnRcv         S             10A
     D PJrnSeq         S             10P 0
     D PDate           S              5P 0
     D PNumKey         S              2  0
     D PRtcd           S              7
     D PKeyFld         S             10    DIM(30)
     D PKeyFil         S             10
     D PKeyLib         S             10    INZ('*LIBL')
     D PUSRSPC         S             20    INZ('MBIUSR    QTEMP     ')
     D PFMT            S              8    INZ('FLDL0100')
     D PRFMT           S             10    INZ('*FIRST    ')
     D POVER           S              1    INZ('0')
 
      ** Parameters for the QDBRTVFD API.
 
     D RcvrLen         S              9B 0 INZ(6400)
     D QualFRtn        S             20A
     D FormatRtn       S              8A   INZ('FILD0300')
     D QualFSent       S             20A
     D RcdFmtName      S             10A   INZ('*FIRST')
     D Override        S              1A   INZ('1')
     D System          S             10A   INZ('*LCL')
     D FormatType      S             10A   INZ('*INT')
 
      ** Up to 30 key fields
 
     D RcvData         S           1920A   INZ(*BLANKS)
 
      ** Record structure for Error Code Parameter
 
     D QUSEC           DS
     D QUSBPRV                 1      4B 0
     D QUSBAVL                 5      8B 0
     D QUSEI                   9     15
     D QUSERVED               16     16
 
     D WFArr           S             10A   DIM(300)
     D WIdx            S              9  0 INZ(1)
     D WIdx1           S              9  0 INZ(1)
     D WPos            S              5I 0
     D WPos1           S              5I 0
     D WCmd            S            100A
     D WLen            S             15  5
 
     D Ix              S              9  0 INZ(1)
 
     D  PCmd           S           5000A
     D  PLen           S             15P 5
     D  PFile          S             10A
     D PFileLib        S             20
 
     D  ALTSTM         S            200A
     D  UPDSTM         S            200A
     D USRPTR          S               *
 
     D UAREA           DS                  BASED(USRPTR)
     D  SP1                       32767
     D  ARR                           1    OVERLAY(SP1) DIM(32767)
     D  OFFSET                        9B 0 OVERLAY(SP1:125)
 
     D RCVJRNE         C                   CONST('RCVJRNE JRN(ICJRN) -
     D                                     EXITPGM(MR001002) ENTTYP(PT-
     D                                      PX UP DL CR) ENTFMT(*TYPE1-
     D                                     ) DELAY(1) FILE(')
     D SNDJRNE         C                   CONST('SNDJRNE JRN(ICJRN) -
     D                                     ENTDTA(''MBI End of Extract-
     D                                      Marker'') FILE(')
     D/COPY QSYSINC/QRPGLESRC,QDBRTVFD
 
     C     *ENTRY        PLIST
     C                   PARM                    PMode
     C                   PARM                    PFile
     C                   PARM                    PDate
 
     C                   IN        ExtLibr
     C                   IF        PMode = 'ADD'
 
      ** Build key file
 
     C                   OPEN      MRKEYDPD
     C     PFile         CHAIN     MRKEYDPD
     C                   IF        %FOUND() AND
     C                             MKFLDN = *BLANKS
     C                   EXSR      SRBLDKEY
     C                   ENDIF
     C                   CLOSE     MRKEYDPD
 
     C                   EVAL      WFArr(WIdx) = PFile
     C                   EVAL      WIdx += 1
 
      ** Add Action Code field to the Temporary and Extract File
 
     C                   EVAL      ALTSTM  = 'ALTER TABLE QTEMP/' +
     C                                       %TRIMR(PFile) + ' ADD ' +
     C                                       'COLUMN ACTION CHAR(1)'
     C/EXEC SQL PREPARE A1 FROM :ALTSTM
     C/END-EXEC
     C/EXEC SQL EXECUTE A1
     C/END-EXEC
     C                   EVAL      ALTSTM  = 'ALTER TABLE ' +
     C                                       %TRIMR(ExtLibr) +
     C                                       '/' + %TRIMR(PFile) +
     C                                       ' ADD COLUMN ACTION ' +
     C                                       'CHAR(1)'
     C/EXEC SQL PREPARE A2 FROM :ALTSTM
     C/END-EXEC
     C/EXEC SQL EXECUTE A2
     C/END-EXEC
     C                   ENDIF
 
      ** Process RCVJRNE if in RUN mode OR number of files reaches
      ** max (300) allowed by RCVJRNE command.
 
     C                   IF        PMode = 'RUN' AND
     C                             WIdx  > 1     OR
     C                             WIdx  = 300
 
      ** Send unique user defined journal entry to ICJRN as marker.
 
     C                   EVAL      PCmd  = SNDJRNE +
     C                                     %TRIMR(WFArr(WIdx-1)) + ')'
     C                   EVAL      PLen  = %LEN(%TRIMR(PCmd))
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCmd
     C                   PARM                    PLen
 
     C                   FOR       Ix    = 1 to WIdx-1
 
     C                   IF        Ix    = 1
     C                   EVAL      PCmd  = WFArr(1)
     C                   ELSE
     C                   EVAL      PCmd  = %TRIMR(PCmd)+' '+WFArr(Ix)
     C                   ENDIF
 
     C                   ENDFOR
     C                   EVAL      PCmd  = RCVJRNE+%TRIMR(PCmd)+')'
 
      ** Get last journal sequence from recent COB using
      ** SCRTVJEVT (SC002472).
 
     C                   CALL      'SC002472'
     C                   PARM      'NDSUJR'      PEvt
     C                   PARM      *BLANKS       PFlg
     C                   PARM                    PJrnRcv
     C                   PARM                    PJrnSeq
 
     C                   EVAL      PCmd  = %TRIMR(PCmd)+' RCVRNG(' +
     C                                     %TRIMR(PJrnRcv)+' *CURRENT)'
 
     C                   EVAL      PCmd  = %TRIMR(PCmd)+' FROMENT('+
     C                                     %TRIM(%CHAR(PJrnSeq))+')'
 
     C                   EVAL      PLen  = %LEN(%TRIMR(PCmd))
 
      ** Call RCVJRNE command, suppress error when no transaction
      ** entry is found.
 
     C                   CALL(E)   'QCMDEXC'
     C                   PARM                    PCmd
     C                   PARM                    PLen
 
      ** Udpate audit file
 
     C                   FOR       Ix    = 1 to WIdx-1
 
     C                   EVAL      UPDSTM  = 'UPDATE ' +
     C                             %TRIMR(ExtLibr) +
     C                             '/AUDIT SET MREXTO=''Y'', MREXDT='+
     C                             %CHAR(PDate) + ', MRNORE='+
     C                             '(SELECT COUNT(*) FROM ' +
     C                             %TRIMR(ExtLibr) + '/'  +
     C                             %TRIMR(WFArr(Ix)) + ') WHERE ' +
     C                             'MRFNAM=''' + %TRIMR(WFArr(Ix)) +
     C                             ''' WITH NC'
     C/EXEC SQL PREPARE U1 FROM :UPDSTM
     C/END-EXEC
     C/EXEC SQL EXECUTE U1
     C/END-EXEC
 
     C                   EVAL      UPDSTM  = 'UPDATE MRMBIFPD SET ' +
     C                             'MREXDT = ' + %CHAR(PDate) +
     C                             ' WHERE MRFNAM=''' +
     C                             %TRIMR(WFArr(Ix)) + ''' WITH NC'
     C/EXEC SQL PREPARE U2 FROM :UPDSTM
     C/END-EXEC
     C/EXEC SQL EXECUTE U2
     C/END-EXEC
     C                   ENDFOR
 
     C                   ENDIF
 
     C                   IF        PMode = 'RUN'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRBLDKEY - Build Key Detailts for the File                   *
      *****************************************************************
     C     SRBLDKEY      BEGSR
 
      ** Get Key fields
 
     C                   EVAL      QualFSent  = MKKEYF + '*LIBL'
 
     C                   CALL      'QDBRTVFD'
     C                   PARM                    RcvData
     C                   PARM                    RcvrLen
     C                   PARM                    QualFRtn
     C                   PARM                    FormatRtn
     C                   PARM                    QualFSent
     C                   PARM                    RcdFmtName
     C                   PARM                    Override
     C                   PARM                    System
     C                   PARM                    FormatType
     C                   PARM                    QUSEC
 
      ** If the API returned an error, indicate this to the caller.
 
     C                   IF        QUSEI   = *BLANKS
 
     C                   EVAL      QDBQ63  = %SUBST(RcvData:1:24)
     C                   IF        QDBFC01 > 1
     C                   EVAL      WPos1   = 25
     C                   DO        QDBFC01
     C                   EVAL      QDBQ62  = %SUBST(RcvData:WPos1:32)
     C                   IF        QDBRN   = MKRFMT
     C                   LEAVE
     C                   ENDIF
     C                   EVAL      WPos1  += 32
     C                   ENDDO
     C                   ELSE
     C                   EVAL      QDBQ62  = %SUBST(RcvData:25:32)
     C                   ENDIF
 
      ** Process Key Information Stored in the OutputData Variable
 
     c                   EVAL      WPos    = QDBKIO + 1
     c                   FOR       WIdx1   = 1 TO QDBNBROK
     C                   EVAL      QDBQ65  = %SUBST(RcvData:WPos:64)
     C                   EVAL      PKeyFld(WIdx1) = QDBIFN
     C                   EVAL      WPos   = WPos + 64
     C                   ENDFOR
 
      ** Return the record length.
 
     C                   EVAL      PNumKey = QDBNBROK
 
     C                   EVAL      PFileLib = MKFNAM + '*LIBL'
 
     C                   CALL      'QUSLFLD'
     C                   PARM                    PUSRSPC
     C                   PARM                    PFMT
     C                   PARM                    PFileLib
     C                   PARM                    PRFMT
     C                   PARM                    POVER
 
     C                   CALL      'QUSPTRUS'
     C                   PARM                    PUSRSPC
     C                   PARM                    USRPTR
 
     C                   EVAL      DTAPTR = USRPTR + OFFSET
 
     C                   EVAL      WIdx1  = 1
     C                   DOW       WIdx1 <= PNumKey
 
     C                   IF        %LOOKUP(DFLD:PKeyFld) <> 0
 
     C                   EVAL      MKFLDN = DFLD
     C                   EVAL      MKFLDL = DLEN
     C                   EVAL      MKFLDP = DPOS
 
     C                   IF        WIdx1  = 1
     C                   UPDATE    MRKEYDD0
     C                   ELSE
     C                   WRITE     MRKEYDD0
     C                   ENDIF
 
     C                   EVAL      WIdx1  += 1
     C                   ENDIF
     C                   EVAL      DTAPTR += 544
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
