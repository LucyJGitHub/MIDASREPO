000100220214     H DEBUG
000200220214      *****************************************************************
000300220214/*STD *  RPGBASEBND                                                   *
000400220214/*EXI *  TEXT('Midas  MX Elements data file update')                  *
000500220214      *****************************************************************
000600220214      *                                                               *
000700220214      *  Midas - Message Management Module                            *
000800220214      *                                                               *
000900220214      *  ME20022 - Midas MX Elements data file update                 *
001000220214      *                                                               *
001100220214      *  Called By: MEC20022C - MS MX IMM Extraction Control - Batch  *
001200220214      *                         process                               *
001300220214      *                                                               *
001400220214      *  (c) Finastra International Limited 2021                      *
001500220214      *                                                               *
001600220214      *  Last Amend No. CSW122 *CREATE     Date 04Oct21               *
001700220214      *                                                               *
001800220214      *---------------------------------------------------------------*
001900220214      *                                                               *
002000220214      *  CSW122 - SWIFT ISO 20022                                     *
002100220214      *                                                               *
002200220214      *****************************************************************
002300220214      /EJECT
002400220214     FMSIXISOL1 UF   E           K DISK    USROPN
002500220214     F                                     COMMIT
002600220214     F                                     INFSR(*PSSR)
002700220214     FMEISOMPD  UF A E           K DISK    USROPN
002800220214     F                                     COMMIT
002900220214     F                                     INFSR(*PSSR)
003000220214     FMEISODPD  UF A E           K DISK    USROPN
003100220214     F                                     COMMIT
003200220214     F                                     INFSR(*PSSR)
003300220214     FMEDESCPD  UF A E           K DISK    USROPN
003400220214     F                                     COMMIT
003500220214     F                                     INFSR(*PSSR)
003600220214     FMEDESCL1  IF   E           K DISK    INFSR(*PSSR)
003700220214     F                                     RENAME(MEDESCD0:MEDESCD1)
003800220214     FMSMXISOL1 IF   E           K DISK    INFSR(*PSSR)
003900220214
004000220214     FME20022AU O    E             PRINTER USROPN INFSR(*PSSR)
004100220214
004200220214      /EJECT
004300220214      /COPY MSCPYSRC,SRERRD
004400220214      *
004500220214      ** +--------------------------------------+
004600220214      ** ¦ Manually included D-specs            ¦
004700220214      ** ¦ =========================            ¦
004800220214      ** +--------------------------------------+
004900220214      *
005000220214      ** +--------------------------------------+
005100220214      ** ¦ Named constants                      ¦
005200220214      ** ¦ ===============                      ¦
005300220214      ** +--------------------------------------+
005400220214      *
005500220214
005600220214     D DSFDY         E DS                  EXTNAME(DSFDY)
005700220214      ** Data Structures used by access objects
005800220214      *
005900220214     D SDBANK        E DS                  EXTNAME(SDBANKPD)
006000220214      ** Bank details data area
006100220214      *
006200220214     D MEMXDTA       E DS                  EXTNAME(MEMXDTA)
006300220214      ** Message Management data area
006400220214
006500220214      ** Next Line indicator
006600220214     D                 DS
006700220214     D  WCRLF                  1      2
006800220214     D  WCR                    1      1    INZ(x'0d')
006900220214     D  WLF                    2      2    INZ(x'25')
007000220214
007100220214      *****************************************************************
007200220214      /EJECT
007300220214      *****************************************************************
007400220214
007500220214      ** +--------------------------------------+
007600220214      ** ¦ Declared variables                   ¦
007700220214      ** ¦ ==================                   ¦
007800220214      ** +--------------------------------------+
007900220214
008000220214      ** Entry Parameter List
008100220214     D PRtnCode        S              7A
008200220214     D PRTCD           S              7A
008300220214     D POPTN           S              7A
008400220214
008500220214      ** Work Variables
008600220214     D WrkMSID         S             36A
008700220214     D WLastElem       S            100A
008800220214     D WStrPos         S              3S 0
008900220214     D WCRLFPos        S              3S 0
009000220214     D WCRpos          S              3S 0
009100220214     D WrkLF           S              1A
009200220214     D WElement        S            220A
009300220214     D WEqPos          S              3S 0
009400220214     D WEName          S            100A
009500220214     D WEValue         S            120A
009600220214     D WrkLen          S              3S 0
009700220214      /EJECT
009800220214      *****************************************************************
009900220214      *                 M A I N L I N E
010000220214      *****************************************************************
010100220214
010200220214      ** Read available MX messages until EOF (all unprocessed incoming MX messages)
010300220214
010400220214     C     *LOVAL        SETLL     MSIXISOL1
010500220214     C                   READ      MSIXISOL1                              99
010600220214
010700220214     C                   DOW       *IN99 = '0'
010800220214
010900220214     C                   EXSR      SrNewRef
011000220214
011100220214     C                   EXSR      SrDetail
011200220214
011300220214     C                   EXSR      SrHeader
011400220214
011500220214     C                   READ      MSIXISOL1                              99
011600220214     C                   ENDDO
011700220214
011800220214     C                   RETURN
011900220214      /EJECT
012000220214      **********************************************************************
012100220214      *                                                                    *
012200220214      * SrNewRef       : New reference: get the MX main details            *
012300220214      *                                                                    *
012400220214      **********************************************************************
012500220214     C     SrNewRef      BEGSR
012600220214      *
012700220214     C     *DTAARA       DEFINE                  MEMXDTA
012800220214     C     *LOCK         IN        MEMXDTA
012900220214     C                   ADD       1             DXMSGR
013000220214     C                   OUT       MEMXDTA
013100220214      *
013200220214     C                   Z-ADD     *ZERO         MESEQN
013300220214
013400220214      *
013500220214     C                   ENDSR
013600220214      /EJECT
013700220214      **********************************************************************
013800220214      *                                                                    *
013900220214      * SrDetail       : Add Incoming Message Details                      *
014000220214      *                                                                    *
014100220214      **********************************************************************
014200220214      *
014300220214     C     SrDetail      BEGSR
014400220214
014500220214
014600220214     C                   Z-ADD     1             WStrPos
014700220214     C                   Z-ADD     *ZERO         WCRLFPos
014800220214
014900220214     C     KeyMX         SETLL     MSMXISOL1
015000220214     C     KeyMX         READE     MSMXISOL1                              61
015100220214      *
015200220214     C                   DOW       *IN61 = '0'
015300220214
015400220214      ** Processing of MX Message per record in MSMXISOPD
015500220214
015600220214     C                   DOW       WStrPos <> *ZERO AND WStrPos <= 256
015700220214
015800220214      ** Get the position of CRLF
015900220214
016000220214     C                   EVAL      WCRLFPos = %SCAN(WCRLF:MXDTA:WStrPos)
016100220214
016200220214      ** When CRLF is not found, check if the last character is CR
016300220214
016400220214     C                   EVAL      WrkLF = *BLANKS
016500220214     C                   IF        WCRLFPos = *ZERO
016600220214     C                   EVAL      WCRPos = %SCAN(WCR:MXDTA:WStrPos)
016700220214     C                   IF        WCRPos <> *ZERO
016800220214     C                   EVAL      WCRLFPos = WCRPos
016900220214     C                   EVAL      WrkLF = 'N'
017000220214     C                   ENDIF
017100220214     C                   ENDIF
017200220214
017300220214      ** One element name and value found
017400220214
017500220214     C                   IF        WCRLFPos <> *ZERO
017600220214     C                   EXSR      SrElement
017700220214      *
017800220214     C                   ELSE
017900220214
018000220214      ** When delimeter is not found, check the remaining field
018100220214      ** If not blanks, an incomplete element is found, save it for later use.
018200220214      ** Length of MXDTA = 256
018300220214
018400220214     C                   IF        WStrPos <= 256
018500220214     C                   EVAL      WLastElem = *BLANKS
018600220214     C                   IF        %SUBST(MXDTA:WStrPos) <> *BLANKS
018700220214     C                   EVAL      WLastElem = %SUBST(MXDTA:WStrPos)
018800220214     C                   ENDIF
018900220214     C                   ENDIF
019000220214
019100220214     C                   EVAL      WStrPos = *ZERO
019200220214     C                   ENDIF
019300220214      *
019400220214     C                   ENDDO
019500220214      *
019600220214     C                   Z-ADD     1             WStrPos
019700220214     C                   IF        WrkLF = 'N'
019800220214     C                   ADD       1             WStrPos
019900220214     C                   ENDIF
020000220214     C     KeyMX         READE     MSMXISOL1                              61
020100220214     C                   ENDDO
020200220214     C                   ENDSR
020300220214      /EJECT
020400220214      **********************************************************************
020500220214      *                                                                    *
020600220214      * SrElement      : Determine the Element Name and Value              *
020700220214      *                                                                    *
020800220214      **********************************************************************
020900220214      *
021000220214     C     SrElement     BEGSR
021100220214
021200220214      ** Element Name and Element Value
021300220214
021400220214     C                   EVAL      WrkLen =  WCRLFPos - WStrPos
021500220214     C                   EVAL      WElement = %SUBST(MXDTA:WStrPos:WrkLen)
021600220214
021700220214      ** Check if there's an element from previous record
021800220214
021900220214     C                   IF        WLastElem <> *BLANKS
022000220214     C                   EVAL      WElement = %TRIM(WLastElem) + WElement
022100220214     C                   EVAL      WLastElem = *BLANKS
022200220214     C                   ENDIF
022300220214
022400220214      ** Look for '=' to determine which is the element name and element value
022500220214
022600220214     C                   EVAL      WEqPos = %SCAN('=':WElement)
022700220214      *
022800220214     C                   EVAL      WEName = %SUBST(WElement:1:WEqPos-1)
022900220214     C
023000220214     C                   EVAL      WEValue = %SUBST(WElement:WEqPos+1)
023100220214
023200220214      ** Update MX detail file
023300220214
023400220214     C                   EXSR      SrMXUpdate
023500220214
023600220214      ** Reset work fields
023700220214
023800220214     C                   EVAL      WElement = *BLANKS
023900220214     C                   EVAL      WEName = *BLANKS
024000220214     C                   EVAL      WEvalue = *BLANKS
024100220214     C                   EVAL      WStrPos = WCRLFPos + 2
024200220214      *
024300220214     C                   ENDSR
024400220214      /EJECT
024500220214      **********************************************************************
024600220214      *                                                                    *
024700220214      * SrMXUpdate     : Update MX files                                   *
024800220214      *                                                                    *
024900220214      **********************************************************************
025000220214      *
025100220214     C     SrMXUpdate    BEGSR
025200220214
025300220214      ** MEISODPD
025400220214      ** Get the element name text description
025500220214
025600220214     C                   EXSR      SrElemDesc
025700220214      *
025800220214     C                   EVAL      MEMSGR = DXMSGR
025900220214     C                   EVAL      MEMSID = IMXID
026000220214     C                   EVAL      MEUETR = IUETR
026100220214     C                   ADD       1             MESEQN
026200220214     C                   EVAL      MEEVAL = WEValue
026300220214     C                   WRITE     MEISODD0                             06
026400220214
026500220214      **  Error on write to PF/MEISODPD (Details of Elements)
026600220214
026700220214     C                   IF        *IN06 = *ON
026800220214     C     *LOCK         IN        LDA
026900220214     C                   MOVE      '006'         DBASE
027000220214     C                   MOVEL     'ERROR   '    DBKEY
027100220214     C                   MOVEL     'MEISODPD'    DBFILE
027200220214     C                   OUT       LDA
027300220214     C                   EXSR      *PSSR
027400220214     C                   ENDIF
027500220214      *
027600220214     C                   ENDSR
027700220214      /EJECT
027800220214      **********************************************************************
027900220214      *                                                                    *
028000220214      * SrHeader       : Add Incoming MS message Header record             *
028100220214      *                                                                    *
028200220214      **********************************************************************
028300220214      *
028400220214     C     SrHeader      BEGSR
028500220214
028600220214      ** Update the header file
028700220214      ** MEISOMPD
028800220214
028900220214     C                   EVAL      OMMSGR = DXMSGR
029000220214     C                   EVAL      OMMSID = IMXID
029100220214     C                   EVAL      OMUETR = IUETR
029200220214     C                   EVAL      OMTYPE = IMTPY
029300220214     C                   EVAL      OMCDTE = BJRDNB
029400220214     C                   WRITE     MEISOMD0                             05
029500220214
029600220214      **  Error on write to PF/MEISOMPD (Header deails of elements)
029700220214
029800220214     C                   IF        *IN05 = *ON
029900220214     C     *LOCK         IN        LDA
030000220214     C                   MOVE      '005'         DBASE
030100220214     C                   MOVEL     'ERROR   '    DBKEY
030200220214     C                   MOVEL     'MEISOMPD'    DBFILE
030300220214     C                   OUT       LDA
030400220214     C                   EXSR      *PSSR
030500220214     C                   ENDIF
030600220214
030700220214      ** Update status flag to 'Y in MSMXISOPD
030800220214
030900220214     C     KeyMX         CHAIN     MSIXISOL1
031000220214     C                   IF        %FOUND
031100220214     C                   EVAL      IMPF = 'Y'
031200220214     C                   UPDATE    MSIXISD0                             98
031300220214      *
031400220214     C                   IF        *IN98 = *ON
031500220214     C     *LOCK         IN        LDA
031600220214     C                   MOVE      '010'         DBASE
031700220214     C                   MOVEL     'IMPF '       DBKEY
031800220214     C                   MOVEL     'MSMXISD0'    DBFILE
031900220214     C                   OUT       LDA
032000220214     C                   EXSR      *PSSR
032100220214     C                   ENDIF
032200220214     C                   COMMIT
032300220214      *
032400220214     C                   ENDIF
032500220214      *
032600220214     C                   ENDSR
032700220214      /EJECT
032800220214      **********************************************************************
032900220214      *                                                                    *
033000220214      * SrElemDesc     : Get the Element name description                  *
033100220214      *                                                                    *
033200220214      **********************************************************************
033300220214      *
033400220214     C     SrElemDesc    BEGSR
033500220214
033600220214     C     WEname        CHAIN     MEDESCL1
033700220214     C                   IF        %FOUND
033800220214     C                   EVAL      MEENAM = DEENAM
033900220214
034000220214      ** If Element Name is Not found, Add this to the File
034100220214      ** Use the Element Name as the Element Description
034200220214
034300220214     C                   ELSE
034400220214     C                   EVAL      MEENAM = WEName
034500220214     C                   EVAL      DEENAM = WEName
034600220214     C                   EVAL      DEDESC = WEName
034700220214      *
034800220214     C                   WRITE     MEDESCD0
034900220214     C                   ENDIF
035000220214     C                   ENDSR
035100220214      *****************************************************************
035200220214      /EJECT
035300220214      *****************************************************************
035400220214      *                                                               *
035500220214      * *INZSR - Program initialisation routine                       *
035600220214      *                                                               *
035700220214      * Called by: Implicitly on program activation                   *
035800220214      *                                                               *
035900220214      * Calls: None                                                   *
036000220214      *                                                               *
036100220214      *****************************************************************
036200220214
036300220214     C     *INZSR        BEGSR
036400220214
036500220214     C     *ENTRY        PLIST
036600220214     C                   PARM                    PRtnCode
036700220214
036800220214      ** Set up LDA
036900220214
037000220214     C     *DTAARA       DEFINE                  LDA
037100220214     C     *LOCK         IN        LDA
037200220214     C                   MOVE      *BLANKS       DBFILE
037300220214     C                   MOVE      *BLANKS       DBKEY
037400220214     C                   MOVEL     'ME20022'     DBPGM
037500220214     C                   MOVE      *BLANKS       DBASE
037600220214     C                   OUT       LDA
037700220214
037800220214      ** Access Bank details via access program (Includes Run Date)
037900220214      ** (database error handling done in access program)
038000220214
038100220214     C                   CALL      'AOBANKR0'
038200220214     C                   PARM      '*DBERR '     PRTCD
038300220214     C                   PARM      '*FIRST '     POPTN
038400220214     C     SDBANK        PARM      SDBANK        DSFDY
038500220214
038600220214     C     PRTCD         IFNE      *BLANKS
038700220214     C     *LOCK         IN        LDA
038800220214     C                   MOVE      '004'         DBASE
038900220214     C                   MOVEL     'FIRST'       DBKEY
039000220214     C                   MOVEL     'SDBANKPD'    DBFILE
039100220214     C                   OUT       LDA
039200220214     C                   EXSR      *PSSR
039300220214     C                   ENDIF
039400220214
039500220214     C                   OPEN      MSIXISOL1
039600220214     C                   OPEN      MEISOMPD
039700220214     C                   OPEN      MEISODPD
039800220214     C                   OPEN      MEDESCPD
039900220214
040000220214     C     KeyMX         KLIST
040100220214     C                   KFLD                    IMXID
040200220214     C                   KFLD                    IUETR
040300220214     C                   KFLD                    IMTPY
040400220214
040500220214      ** Initilize work variables
040600220214
040700220214     C                   EVAL      WrkMSID = *BLANKS
040800220214     C                   EVAL      WLastElem = *BLANKS
040900220214
041000220214     C                   ENDSR
041100220214      *****************************************************************
041200220214     C/EJECT
041300220214      *****************************************************************
041400220214      *                                                               *
041500220214      *   *PSSR - Error handling                                      *
041600220214      *                                                               *
041700220214      *****************************************************************
041800220214     C     *PSSR         BEGSR
041900220214
042000220214      **  Write database error to report
042100220214
042200220214     C                   OPEN      ME20022AU
042300220214     C                   WRITE     HEADER
042400220214     C                   WRITE     DBERROR
042500220214     C                   CLOSE     ME20022AU
042600220214
042700220214     C                   ROLBK
042800220214     C                   SETON                                        U7U8LR
042900220214     C                   DUMP
043000220214     C                   RETURN
043100220214
043200220214     C                   ENDSR
