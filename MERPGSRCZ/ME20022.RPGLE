     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas  MX Elements data file update')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME20022 - Midas MX Elements data file update                 *
      *                                                               *
      *  Called By: MEC20022C - MS MX IMM Extraction Control - Batch  *
      *                         process                               *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD061298           Date 26Apr23               *
      *  Prev Amend No. MD060246A          Date 04Aug22               *
      *                 MD060246           Date 21Jul22               *
      *                 CSW122 *CREATE     Date 04Oct21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061298 - Camt.108.001.01 displays truncated MX Element     *
      *             Value in ISO MX Enquiry                           *
      *  MD060246A- Increase field length value for MX Element Value  *
      *             changed from 120A to 500A.                        *
      *  MD060246 - Increase field length value for MX Element Value  *
      *             changed from 120A to 500A. (Recompile)            *
      *  CSW122 - SWIFT ISO 20022                                     *
      *                                                               *
      *****************************************************************
      /EJECT
     FMSIXISOL1 UF   E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFSR(*PSSR)
     FMEISOMPD  UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFSR(*PSSR)
     FMEISODPD  UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFSR(*PSSR)
     FMEDESCPD  UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFSR(*PSSR)
     FMEDESCL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MEDESCD0:MEDESCD1)
     FMSMXISOL1 IF   E           K DISK    INFSR(*PSSR)

     FME20022AU O    E             PRINTER USROPN INFSR(*PSSR)

      /EJECT
      /COPY MSCPYSRC,SRERRD
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data Structures used by access objects
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank details data area
      *
     D MEMXDTA       E DS                  EXTNAME(MEMXDTA)
      ** Message Management data area

      ** Next Line indicator
     D                 DS
     D  WCRLF                  1      2
     D  WCR                    1      1    INZ(x'0d')
     D  WLF                    2      2    INZ(x'25')

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Entry Parameter List
     D PRtnCode        S              7A
     D PRTCD           S              7A
     D POPTN           S              7A

      ** Work Variables
     D WrkMSID         S             36A
     D***WLastElem       S              100A                                                MD061298
     D WLastElem       S            256A                                                    MD061298
     D WStrPos         S              3S 0
     D WCRLFPos        S              3S 0
     D WCRpos          S              3S 0
     D WrkLF           S              1A
     D***WElement        S              220A                                                MD061298
     D WElement        S            600A                                                    MD061298
     D WEqPos          S              3S 0
     D WEName          S            100A
     D*WEValue**       S            120A                                                   MD060246A
     D WEValue         S            500A                                                   MD060246A
     D WrkLen          S              3S 0
      /EJECT
      *****************************************************************
      *                 M A I N L I N E
      *****************************************************************

      ** Read available MX messages until EOF (all unprocessed incoming MX messages)

     C     *LOVAL        SETLL     MSIXISOL1
     C                   READ      MSIXISOL1                              99

     C                   DOW       *IN99 = '0'

     C                   EXSR      SrNewRef

     C                   EXSR      SrDetail

     C                   EXSR      SrHeader

     C                   READ      MSIXISOL1                              99
     C                   ENDDO

     C                   RETURN
      /EJECT
      **********************************************************************
      *                                                                    *
      * SrNewRef       : New reference: get the MX main details            *
      *                                                                    *
      **********************************************************************
     C     SrNewRef      BEGSR
      *
     C     *DTAARA       DEFINE                  MEMXDTA
     C     *LOCK         IN        MEMXDTA
     C                   ADD       1             DXMSGR
     C                   OUT       MEMXDTA
      *
     C                   Z-ADD     *ZERO         MESEQN

      *
     C                   ENDSR
      /EJECT
      **********************************************************************
      *                                                                    *
      * SrDetail       : Add Incoming Message Details                      *
      *                                                                    *
      **********************************************************************
      *
     C     SrDetail      BEGSR


     C                   Z-ADD     1             WStrPos
     C                   Z-ADD     *ZERO         WCRLFPos

     C     KeyMX         SETLL     MSMXISOL1
     C     KeyMX         READE     MSMXISOL1                              61
      *
     C                   DOW       *IN61 = '0'

      ** Processing of MX Message per record in MSMXISOPD

     C                   DOW       WStrPos <> *ZERO AND WStrPos <= 256

      ** Get the position of CRLF

     C                   EVAL      WCRLFPos = %SCAN(WCRLF:MXDTA:WStrPos)

      ** When CRLF is not found, check if the last character is CR

     C                   EVAL      WrkLF = *BLANKS
     C                   IF        WCRLFPos = *ZERO
     C                   EVAL      WCRPos = %SCAN(WCR:MXDTA:WStrPos)
     C                   IF        WCRPos <> *ZERO
     C                   EVAL      WCRLFPos = WCRPos
     C                   EVAL      WrkLF = 'N'
     C                   ENDIF
     C                   ENDIF

      ** One element name and value found

     C                   IF        WCRLFPos <> *ZERO
     C                   EXSR      SrElement
      *
     C                   ELSE

      ** When delimeter is not found, check the remaining field
      ** If not blanks, an incomplete element is found, save it for later use.
      ** Length of MXDTA = 256

     C                   IF        WStrPos <= 256
     C                   EVAL      WLastElem = *BLANKS
     C                   IF        %SUBST(MXDTA:WStrPos) <> *BLANKS
     C                   EVAL      WLastElem = %SUBST(MXDTA:WStrPos)
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      WStrPos = *ZERO
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   Z-ADD     1             WStrPos
     C                   IF        WrkLF = 'N'
     C                   ADD       1             WStrPos
     C                   ENDIF
     C     KeyMX         READE     MSMXISOL1                              61
     C                   ENDDO
     C                   ENDSR
      /EJECT
      **********************************************************************
      *                                                                    *
      * SrElement      : Determine the Element Name and Value              *
      *                                                                    *
      **********************************************************************
      *
     C     SrElement     BEGSR

      ** Element Name and Element Value

     C                   EVAL      WrkLen =  WCRLFPos - WStrPos
     C                   EVAL      WElement = %SUBST(MXDTA:WStrPos:WrkLen)

      ** Check if there's an element from previous record

     C                   IF        WLastElem <> *BLANKS
     C                   EVAL      WElement = %TRIM(WLastElem) + WElement
     C                   EVAL      WLastElem = *BLANKS
     C                   ENDIF

      ** Look for '=' to determine which is the element name and element value

     C                   EVAL      WEqPos = %SCAN('=':WElement)
      *
     C                   EVAL      WEName = %SUBST(WElement:1:WEqPos-1)
     C
     C                   EVAL      WEValue = %SUBST(WElement:WEqPos+1)

      ** Update MX detail file

     C                   EXSR      SrMXUpdate

      ** Reset work fields

     C                   EVAL      WElement = *BLANKS
     C                   EVAL      WEName = *BLANKS
     C                   EVAL      WEvalue = *BLANKS
     C                   EVAL      WStrPos = WCRLFPos + 2
      *
     C                   ENDSR
      /EJECT
      **********************************************************************
      *                                                                    *
      * SrMXUpdate     : Update MX files                                   *
      *                                                                    *
      **********************************************************************
      *
     C     SrMXUpdate    BEGSR

      ** MEISODPD
      ** Get the element name text description

     C                   EXSR      SrElemDesc
      *
     C                   EVAL      MEMSGR = DXMSGR
     C                   EVAL      MEMSID = IMXID
     C                   EVAL      MEUETR = IUETR
     C                   ADD       1             MESEQN
     C                   EVAL      MEEVAL = WEValue
     C                   WRITE     MEISODD0                             06

      **  Error on write to PF/MEISODPD (Details of Elements)

     C                   IF        *IN06 = *ON
     C     *LOCK         IN        LDA
     C                   MOVE      '006'         DBASE
     C                   MOVEL     'ERROR   '    DBKEY
     C                   MOVEL     'MEISODPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      **********************************************************************
      *                                                                    *
      * SrHeader       : Add Incoming MS message Header record             *
      *                                                                    *
      **********************************************************************
      *
     C     SrHeader      BEGSR

      ** Update the header file
      ** MEISOMPD

     C                   EVAL      OMMSGR = DXMSGR
     C                   EVAL      OMMSID = IMXID
     C                   EVAL      OMUETR = IUETR
     C                   EVAL      OMTYPE = IMTPY
     C                   EVAL      OMCDTE = BJRDNB
     C                   WRITE     MEISOMD0                             05

      **  Error on write to PF/MEISOMPD (Header deails of elements)

     C                   IF        *IN05 = *ON
     C     *LOCK         IN        LDA
     C                   MOVE      '005'         DBASE
     C                   MOVEL     'ERROR   '    DBKEY
     C                   MOVEL     'MEISOMPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Update status flag to 'Y in MSMXISOPD

     C     KeyMX         CHAIN     MSIXISOL1
     C                   IF        %FOUND
     C                   EVAL      IMPF = 'Y'
     C                   UPDATE    MSIXISD0                             98
      *
     C                   IF        *IN98 = *ON
     C     *LOCK         IN        LDA
     C                   MOVE      '010'         DBASE
     C                   MOVEL     'IMPF '       DBKEY
     C                   MOVEL     'MSMXISD0'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   COMMIT
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      **********************************************************************
      *                                                                    *
      * SrElemDesc     : Get the Element name description                  *
      *                                                                    *
      **********************************************************************
      *
     C     SrElemDesc    BEGSR

     C     WEname        CHAIN     MEDESCL1
     C                   IF        %FOUND
     C                   EVAL      MEENAM = DEENAM

      ** If Element Name is Not found, Add this to the File
      ** Use the Element Name as the Element Description

     C                   ELSE
     C                   EVAL      MEENAM = WEName
     C                   EVAL      DEENAM = WEName
     C                   EVAL      DEDESC = WEName
      *
     C                   WRITE     MEDESCD0
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PRtnCode

      ** Set up LDA

     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'ME20022'     DBPGM
     C                   MOVE      *BLANKS       DBASE
     C                   OUT       LDA

      ** Access Bank details via access program (Includes Run Date)
      ** (database error handling done in access program)

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '004'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   OPEN      MSIXISOL1
     C                   OPEN      MEISOMPD
     C                   OPEN      MEISODPD
     C                   OPEN      MEDESCPD

     C     KeyMX         KLIST
     C                   KFLD                    IMXID
     C                   KFLD                    IUETR
     C                   KFLD                    IMTPY

      ** Initilize work variables

     C                   EVAL      WrkMSID = *BLANKS
     C                   EVAL      WLastElem = *BLANKS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   *PSSR - Error handling                                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

      **  Write database error to report

     C                   OPEN      ME20022AU
     C                   WRITE     HEADER
     C                   WRITE     DBERROR
     C                   CLOSE     ME20022AU

     C                   ROLBK
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN

     C                   ENDSR
