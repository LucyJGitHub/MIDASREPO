     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXS *  RPGCVTOPT2                                                   *                       CSD053
/*EXI *  TEXT('Midas CG Write Data to Stream File')                   *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3626 - Write Data to Stream File                           *
      *                                                               *
      *  Function: This sub-module receives parameters from CG3625    *
      *            and process as follows:                            *
      *                                                               *
      *            a) *GEN - do nothing                               *
      *            b) *WRITE - write CGUXMLPD data into stream file.  *
      *            c) *CLOSE - do nothing                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055442           Date 01Jun20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD027486           Date 23Jun15               *
      *                 CSD053A            Date 14Dec12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD053             Date 01Jun06               *
      *                 CCG015  *CREATE    Date 03Sep01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055442 - Correspondence manager - pick up Czech CCSID 870. *
      *           - Replace & with &amp; instead of using CDATA.      *
      *             Also replace < with &lt; and > with &gt;          *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027486 - Tag contains '£CDATA£' rather than '[CDATA[       *
      *             Use character '[' instead of '£' in formatting    *
      *             the Tag value field                               *
      *             Applied for MD031921.                             *
      *  CSD053A - Correspondence Manager DBCS Support                *
      *            Applied for AR924785 (Child: AR924788)             *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *  CCG015 - Correspondence Manager                              *
      *                                                               *
      *****************************************************************
      /EJECT
      * +------------------+
      * ¦ File declaration ¦
      * +------------------+
      *  XML Merged Data by Item Reference (Current)
     FCGUXMLL0  IF   E           K DISK

      *  XML Merged Data by Item Reference (Archive)
     FCGXXMLL0  IF   E           K DISK

      /EJECT
      * +--------------------------------------+
      * ¦ Prototypes required for the IFS APIs ¦
      * +--------------------------------------+
      /COPY CGCPYSRC,IFSPROTO

      * +------------------------------------------------------+
      * ¦ READ API() definitions for oflag and mode parameters ¦
      * +------------------------------------------------------+
      /COPY CGCPYSRC,OPENDFN

      * +-------------------------------------------------+
      * ¦ Variable declaration for the IFS APIs used here ¦
      * +-------------------------------------------------+
     D FileDesc        S             10I 0
     D Oflag           S             10I 0 INZ

      * +-----------------------------------------------+
      * ¦ Variable declaration for *WRITE mode to *STMF ¦
      * +-----------------------------------------------+
     D RecordData      S            135    INZ(*BLANKS)
     D  TagName        S             33    INZ(*BLANKS)
     D  TagValue       S             65    INZ(*BLANKS)
     D  ConvValue      S             80    INZ(*BLANKS)
     D  TagEnd         S             33    INZ(*BLANKS)

      * +-------------------------+
      * ¦ Other standalone fields ¦
      * +-------------------------+
     D RC              S             10I 0
     D Count           S              5P 0 INZ
     D*Buffer***       S            250A   INZ(*BLANK)                                        CSD053
     D*pBuffer**       S               *   INZ(%ADDR(Buffer))                                 CSD053
     D BigString       S           1000
     D i               S              3  0 INZ(0)
     D Pos             S              5  0
     D Head            S            230
     D Output          S           1000C   CCSID(1200)                                        CSD053
     D BOM             S             10A                                                      CSD053

     D RtnCode         S              7
     D ActCode         S              6

      * +----------------------------------+
      * ¦ For *PSSR Error Handling routine ¦
      * +----------------------------------+
     D @RUN            S              1

      * +-------------------------+
      * ¦ Parameters for AOCORMR0 ¦
      * +-------------------------+
     D Rtcd            S              7    INZ(*BLANK)
     D Optn            S              7    INZ(*BLANK)

      * +-----------------------+
      * ¦ Parameters for CG3627 ¦
      * +-----------------------+
     D StrTag          S             33    DIM(200)
     D Value           S             65    DIM(200)
     D EndTag          S             33    DIM(200)

      * +----------------------------------------+
      * ¦ Variables for writing into Stream File ¦
      * +----------------------------------------+
     D HeadLine        S            100
     D CorrLine        S            184
     D SysLine         S            135
     D WFlag           S              1
                                                                                             CSD053A
     D Buffer          S            250A   INZ(*BLANK)                                       CSD053A
     D pBuffer         S               *   INZ(%ADDR(Buffer))                                CSD053A
     D AllowDBCS       S              1                                                      CSD053A

      * +-----------------+
      * ¦ Named Constants ¦
      * +-----------------+
     D*XMLHead1*       C                   'xml version="1.0" encoding="UTF-8"'               CSD053
     D***XMLHead1        C                   'xml version="1.0" encoding="UTF-16"     CSD053 CSD053A
     D XMLHead1        C                   '?xml version="1.0" encoding= +                   CSD053A
     D                                          "ISO-8859-1"?'                               CSD053A
     D CRLF            C                   X'0D25'
     D Null            C                   X'00'

      * +-----------------------------------------------+
      * ¦ Data structure for Correspondence Manager ICD ¦
      * +-----------------------------------------------+
     D Sdcorm        E DS                  EXTNAME(SDCORMPD)

      * +-----------------------------------------------+
      * ¦ Data Structure (long) used by Access Programs ¦
      * +-----------------------------------------------+
     D Dsldy         E DS                  EXTNAME(DSLDY)

      * +----------------------------------------------------+
      * ¦ System Local Data Area to hold <OutputInformation> ¦
      * +----------------------------------------------------+
     D Cglda         E DS                  EXTNAME(CGLDA)

      * +----------------------------------------------+
      * ¦ Data structure for Print Process driver file ¦
      * +----------------------------------------------+
     D PrtGen        E DS                  EXTNAME(CGPGENPD)

      * +------------------------------------------------------+
      * ¦ Local Data Area Structure for error handling routine ¦
      * +------------------------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *  LDA definition :                   134 141 DBFILE
      *                                     142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *                                     184 193 DBMOD
      *                                     194 203 DBPROC
      * +-----------------------------------------------------------------+
      * ¦ The following /COPY line includes all the defined fields in the ¦
      * ¦ PSDS.  They have meaningful names, prefixed by 'PS'.            ¦
      * +-----------------------------------------------------------------+
     D/COPY ZACPYSRC,PSDS

      * +-------------------------------------------------------------+
      * ¦ Function to return formatted Tag Value field if it contains ¦
      * ¦ special characters in the text.                             ¦
      * +-------------------------------------------------------------+
     DScanFld          PR            80
     D TagValue                            LIKE(XMTAGV)

      * +-------------------------------------------------------------+
      * ¦ Function to convert in Ascii characters according to the    ¦
      * ¦ conversion table ASCII.                                     ¦
      * +-------------------------------------------------------------+
     DConvertAscii     PR          1000
     DInputData                    1000

      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Main Routine                                                ¦
      * +-------------------------------------------------------------+
     C                   SELECT

      * +-------------------------------------------------------------+
      * ¦ Mode = *GEN                                                 ¦
      * +-------------------------------------------------------------+
     C                   WHEN      ActCode = '*GEN  '

      * +-------------------------------------------------------------+
      * ¦ Mode = *WRITE                                               ¦
      * +-------------------------------------------------------------+
     C                   WHEN      ActCode = '*WRITE'

      *  Setup system data area
     C                   EXSR      SETLDA

      *  Write XML Heading line
     C                   EXSR      WRTHEAD

      *  Write XML data from PF/CGUXMLPD
     C                   EXSR      WRTDET

      * +-------------------------------------------------------------+
      * ¦ Mode = *CLOSE                                               ¦
      * +-------------------------------------------------------------+
     C                   WHEN      ActCode = '*CLOSE'

     C                   ENDSL
      *
     C                   RETURN

      /EJECT
      * +------------------------------------------------------------------+
      * ¦ Subr/*INZSR - Initialisation subroutine                          ¦
      * +------------------------------------------------------------------+
     C     *INZSR        BEGSR

      *  Define parameter passed from calling program
     C     *ENTRY        PLIST
     C                   PARM                    ActCode
     C                   PARM                    PrtGen
     C                   PARM                    FileDesc
     C                   PARM                    RtnCode
     C                   PARM                    AllowDBCS                                   CSD053A

      *  Define work dataarea
     C     *DTAARA       DEFINE    *LDA          Cglda

      *  Retrieve Correspondence Manager ICD
     C                   CALLB(E)  'AOCORMR0'
     C                   PARM      *BLANKS       Rtcd
     C                   PARM      '*FIRST '     Optn
     C     Sdcorm        PARM      *BLANKS       Dsldy

      * Error calling AOCORMR0
     C                   IF        %ERROR OR Rtcd <> *BLANK

     C                   EVAL      DBFILE =  'SDCORMPD'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod

     C                   EXSR      *PSSR

     C                   ENDIF

     C                   ENDSR

      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/WRTHEAD - Write XML Heading line                       ¦
      * +-------------------------------------------------------------+
     C     WRTHEAD       BEGSR

      *  Write header only if details line exists
      *  This situation may happen if Correspondence Manager
      *  is installed with former UDC extract files (CGUDT*)
     C                   IF        #@ARCH = 'A'
     C     B2ITEM        SETLL     CGXXMLL0
     C                   IF        NOT %EQUAL
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C     B2ITEM        SETLL     CGUXMLL0
     C                   IF        NOT %EQUAL
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF

      *  Format Byte Order Mark (Unicode Big Endian = x'FEFF')                                CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      BOM = x'FEFF'                                              CSD053
     C                   EVAL      RC = WRITE(FileDesc : %ADDR(BOM) :                         CSD053
     C                                         %LEN(%TRIMR(BOM)))                             CSD053
     C                   ENDIF                                                               CSD053A
      *  Format XML Heading line
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      HeadLine = '<' + %TRIM(CMHDSC) + '>'
     C                   ELSE                                                                CSD053A
     C                   EVAL      HeadLine = '<' + %TRIM(XMLHead1) + '>'                    CSD053A
     C                   ENDIF                                                               CSD053A

      *  Attach CRLF
     C                   EVAL      BigString = %TRIM(HeadLine) + CRLF
     C**********         EVAL      Buffer = %TRIMR(ConvertAscii(BigString))                   CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      Output = %TRIMR(%UCS2(BigString))                          CSD053
     C                   ELSE                                                                CSD053A
     C                   EVAL      Buffer = %TRIMR(ConvertAscii(BigString))                  CSD053A
     C                   ENDIF                                                               CSD053A

      *  Write XML Heading line into the stream file
     C**********         EVAL      RC = WRITE(FileDesc : pBuffer :                            CSD053
     C**********                               %LEN(%TRIMR(Buffer)))                          CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      RC = WRITE(FileDesc : %ADDR(Output):                       CSD053
     C                                         %LEN(%TRIMR(Output))*2)                        CSD053
     C                   ELSE                                                                CSD053A
     C                   EVAL      RC = WRITE(FileDesc : pBuffer:                            CSD053A
     C                                         %LEN(%TRIMR(Buffer)))                         CSD053A
     C                   ENDIF                                                               CSD053A

      *  Error encountered, issue error screen and dump the program
     C                   IF        RC = -1
     C                   EVAL      DBFILE =  *BLANKS
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod

     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/SETLDA - Set up Print Process Communications Data      ¦
      * ¦               Area.                                         ¦
      * +-------------------------------------------------------------+
     C     SETLDA        BEGSR

      *  Update Cglda with relevant Print Process data
     C                   IN        Cglda

     C                   EVAL      #@ITEM = B2ITEM
     C                   EVAL      #@DCOR = B2DCOR
     C                   EVAL      #@UNT  = B2LGID

     C                   OUT       Cglda

     C                   ENDSR

      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/WRTSYS  - Write SYSTEM FIELD information into the      ¦
      * ¦                Stream File. The data will be retrieved via  ¦
      * ¦                call to CG3627.                              ¦
      * +-------------------------------------------------------------+
     C     WRTSYS        BEGSR

      *  Call program to retrieve formatted system fields. Output of
      *  CG3627 are arrays StrTag, Value and EndTag (all of which has
      *  dimension = 200 elements)

     C                   CALLB(E)  'CG3627'
     C                   PARM      *BLANKS       Rtcd
     C                   PARM      *BLANKS       StrTag
     C                   PARM      *BLANKS       Value
     C                   PARM      *BLANKS       EndTag

      *  Error encountered, issue error screen and dump the program
     C                   IF        %ERROR OR Rtcd = '*ERROR '
     C                   EVAL      DBFILE =  *BLANK
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  004
     C                   EVAL      DBMOD  =  PSProcMod

     C                   EXSR      *PSSR

      *  otherwise, write array data into the stream file
     C                   ELSE

      *  Initialise array counter and process array
     C                   EVAL      i = 1
     C                   EVAL      Count = 1

     C                   DOW       Count < %ELEM(StrTag) AND
     C                               StrTag(i) <> *BLANK
      *  Scan tag value for special characters (i.e. '&','<', '>'),
      *  if so, format field as '<!£CDATA£Tag Value]]>'.
     C                   EVAL      ConvValue = ScanFld(Value(i))

      *  Combine Start Tag + Value + End Tag into one compressed field.
     C                   EVAL      SysLine = %TRIM(StrTag(i))
     C                                + %TRIM(ConvValue) + %TRIM(EndTag(i))

      *  Attach CRLF at the end of each line
     C                   EVAL      BigString = %TRIM(SysLine) + CRLF
     C**********         Eval      Buffer = %TRIMR(ConvertAscii(BigString))                   CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   Eval      Output = %TRIMR(%UCS2(BigString))                          CSD053
     C                   ELSE                                                                CSD053A
     C                   EVAL      Buffer = %TRIMR(ConvertAscii(BigString))                  CSD053A
     C                   ENDIF                                                               CSD053A

      *  Write data into stream file
     C**********         EVAL      RC = WRITE(FileDesc : pBuffer :                            CSD053
     C**********                               %LEN(%TRIMR(Buffer)))                          CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      RC = WRITE(FileDesc : %ADDR(Output):                       CSD053
     C                                         %LEN(%TRIMR(Output))*2)                        CSD053
     C                   ELSE                                                                CSD053A
     C                   EVAL      RC = WRITE(FileDesc : pBuffer:                            CSD053A
     C                                         %LEN(%TRIMR(Buffer)))                         CSD053A
     C                   ENDIF                                                               CSD053A

      *  Error encountered, issue error screen and dump the program
     C                   IF        RC = -1
     C                   EVAL      DBFILE =  *BLANK
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  005
     C                   EVAL      DBMOD  =  PSProcMod

     C                   EXSR      *PSSR
     C                   ENDIF

      *  Process next set of data in the array
     C                   EVAL      i = i + 1
     C                   EVAL      Count = Count + 1

     C                   ENDDO
     C                   ENDIF

     C                   ENDSR

      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/WRTDET  - Write Merged XML Correspondent details       ¦
      * ¦                into the stream file.                        ¦
      * +-------------------------------------------------------------+
     C     WRTDET        BEGSR

      *  Initialise WFlag to write the System Field info ONLY ONCE
      *  and ONLY AFTER writing the first record from XML file for
      *  the current item.
     C                   EVAL      WFlag = 'N'

      *  Read records for this Item Reference from the XML Merged file.
      *  The file being processed depends on the value of Archive Flag
      *  in Cglda (*LDA): if LIVE request, read from CGUXMLPD
      *                   if ARCHIVE request, read from CGXXMLPD

     C                   IF        #@ARCH = 'A'
     C     B2ITEM        SETLL     CGXXMLL0
     C     B2ITEM        READE     CGXXMLL0
     C                   ELSE
     C     B2ITEM        SETLL     CGUXMLL0
     C     B2ITEM        READE     CGUXMLL0
     C                   ENDIF

     C                   DOW       NOT %EOF

      *  Load records into work fields.
     C                   MOVE(P)   XMTAGN        TagName
     C                   MOVE(P)   XMTAGV        TagValue
     C                   MOVE(P)   XMENDT        TagEnd

      * Format the header if it's the first record read for a given
      * item number
     C                   IF        WFlag = 'N'

     C                   EVAL      Pos = %SCAN('>':TagName)
     C                   EVAL      Head = '<' + %SUBST(TagName:2:Pos-2)
     C                             + ' '+ %TRIM(CMSTY1) + '"'
     C                             + %SUBST(TagName:2:Pos-2) + '.xsd">'
     C                   EVAL      BigString = %TRIM(Head) + CRLF
     C**********         EVAL      Buffer = %TRIMR(ConvertAscii(BigString))                   CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      Output = %TRIMR(%UCS2(BigString))                          CSD053
     C                   ELSE                                                                CSD053A
     C                   EVAL      Buffer = %TRIMR(ConvertAscii(BigString))                  CSD053A
     C                   ENDIF                                                               CSD053A
                                                                                             CSD053A
     C                   ELSE
      *  Scan tag value for special characters (i.e. '&','<', '>'),
      *  if so, format field as '<!£CDATA£Tag Value]]>'.
     C                   EVAL      ConvValue = ScanFld(TagValue)

      *  Combine data into a single compressed field.
     C                   EVAL      RecordData = %TRIM(TagName)+
     C                              %TRIM(ConvValue) + %TRIM(TagEnd)

      *  Attach CRLF at the end of each record line
     C                   EVAL      BigString = %TRIM(RecordData) + CRLF
     C**********         Eval      Buffer = %TRIMR(ConvertAscii(BigString))                   CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   Eval      Output = %TRIMR(%UCS2(BigString))                          CSD053
     C                   ELSE                                                                CSD053A
     C                   EVAL      Buffer = %TRIMR(ConvertAscii(BigString))                  CSD053A
     C                   ENDIF                                                               CSD053A
                                                                                             CSD053A
     C                   ENDIF

      * Write record to stream file
     C**********         EVAL      RC = WRITE(FileDesc : pBuffer :                            CSD053
     C**********                               %LEN(%TRIMR(Buffer)))                          CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      RC = WRITE(FileDesc : %ADDR(Output):                       CSD053
     C                                         %LEN(%TRIMR(Output))*2)                        CDS053
     C                   ELSE                                                                CSD053A
     C                   EVAL      RC = WRITE(FileDesc : pBuffer:                            CSD053A
     C                                         %LEN(%TRIMR(Buffer)))                         CDS053A
     C                   ENDIF                                                               CSD053A

      *  If error writing to stream file
     C                   IF        RC = -1
     C                   EVAL      DBFILE =  *BLANK
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  006
     C                   EVAL      DBMOD  =  PSProcMod

     C                   EXSR      *PSSR
     C                   ENDIF

      *  Write '<OutputInformation>' + System Fields information ONLY
      *  ONCE and AFTER writing the first line for Item Reference.

     C                   IF        WFlag = 'N'
     C                   EXSR      WRTSYS
     C                   EVAL      WFlag = 'Y'
     C                   ENDIF

      *  Read next record for Item Reference.
     C                   IF        #@ARCH = 'A'
     C     B2ITEM        READE     CGXXMLL0
     C                   ELSE
     C     B2ITEM        READE     CGUXMLL0
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR

      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/*PSSR - Program Exception Error Handling Routine       ¦
      * ¦              Called automatically if a program error occurs,¦
      * ¦              or directly by the program code using EXSR.    ¦
      * ¦              This subroutine DUMPs the program just once.   ¦
      * +-------------------------------------------------------------+
     C     *PSSR         BEGSR

      *  Dump the program
     C                   DUMP

      *  Display Dbase Error screen
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

      * Set job switches
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   EVAL      RtnCode = '*ERROR '

      * End program
     C                   RETURN

     C                   ENDSR
      /EJECT
      ****************************************************************
      * ScanFld - Scan Tag Value for special characters '&', '<'     *
      *           and '>' and format field as necessary.             *
      ****************************************************************
     PScanFld          B
     DScanFld          PI            80
     D  TagValue                           LIKE(XMTAGV)

     D  SpcChar        S             10    INZ('&<>')
     D  SpcArr         S              1    DIM(10)
     D  ConvValue      S             80    INZ(*BLANKS)
     D  X              S              3  0
     D  WFound         S              1    INZ('N')
     D  SpcPos         S              3  0                                                  MD055442
     D  Y              S              3  0                                                  MD055442

      *  Load special chars to be scanned into a work array and
      *  initialise array index.
     C                   MOVEA     SpcChar       SpcArr
     C                   EVAL      X = 1
     C                   Eval      ConvValue = TagValue                                     MD055442

      *  Search Tag Value field for each special character
     C                   DOW       (X <= %ELEM(SpcArr)) AND
     C                             (SpcArr(X) <> *BLANK)

     C*****SpcArr(X)*****SCAN      TagValue                               90                MD055442
     C     SpcArr(X)     SCAN      ConvValue     SpcPos                   90                MD055442

      *  If any of special character is found, format the Tag Value field.
      *+------------------------------------------------------------------+
      *¦ NOTE : A problem is encountered if character '£' is FTPd to the  ¦
      *¦        PC. '£' seems to be translated into '$'. We found that    ¦
      *¦        '[' translates to '£' when FTPd. Hence was used here.     ¦
      *+------------------------------------------------------------------+
     C**********         IF        *IN90 = *ON                                              MD055442
     C                   DOW       *IN90 = *ON                                              MD055442
     C                   EVAL      WFound = 'Y'
     C**********         EVAL      ConvValue = '<!£CDATA£' +                                MD027486
     C**********         EVAL      ConvValue = '<![CDATA[' +                       MD027486 MD055442
     C**********                     %TRIM(TagValue) + ']]>'                                MD055442
      *                                                                                     MD055442
      * Substitute the special character instead of using CDATA                             MD055442
     C                   If        SpcArr(X) = '&'                                          MD055442
     C                   Eval      ConvValue = %SUBST(ConvValue:1:SpcPos-1) +               MD055442
     C                             '&amp;' + %SUBST(ConvValue:SpcPos+1)                     MD055442
     C                   Eval      Y = SpcPos + 5                                           MD055442
     C                   Endif                                                              MD055442
     C                   If        SpcArr(X) = '<'                                          MD055442
     C                   Eval      ConvValue = %SUBST(ConvValue:1:SpcPos-1) +               MD055442
     C                             '&lt;' + %SUBST(ConvValue:SpcPos+1)                      MD055442
     C                   Eval      Y = SpcPos + 4                                           MD055442
     C                   Endif                                                              MD055442
     C                   If        SpcArr(X) = '>'                                          MD055442
     C                   Eval      ConvValue = %SUBST(ConvValue:1:SpcPos-1) +               MD055442
     C                             '&gt;' + %SUBST(ConvValue:SpcPos+1)                      MD055442
     C                   Eval      Y = SpcPos + 4                                           MD055442
     C                   Endif                                                              MD055442
      *                                                                                     MD055442
     C**********         LEAVE                                                              MD055442
     C**********         ENDIF                                                              MD055442
     C     SpcArr(X)     SCAN      ConvValue:Y   SpcPos                   90                MD055442
     C                   ENDDO                                                              MD055442

      *  Scan for next special character.
     C                   EVAL      X = X + 1
     C                   ENDDO

      *  If no special chars found in the field value, pass original
      *  field to calling procedure.
     C                   IF        WFound = 'N'
     C                   EVAL      ConvValue = TagValue
     C                   ENDIF

     C                   RETURN    ConvValue

     P                 E
      ********************************************************************  **
      * Convert to ASCII                                                 *
      ********************************************************************  **
     P*ConvertAscii     B                                                                     CSD053
     D*ConvertAscii     PI          1000                                                      CSD053
     D*InputData                    1000                                                      CSD053
      **********                                                                              CSD053
     D*ConvData*        S           1000                                                      CSD053
     D*Length***        S              5  0                                                   CSD053
     D*LengthCnv        S              5  0                                                   CSD053
     D*LengthOutBuf     S              5  0                                                   CSD053
     D*TableName        S             10                                                      CSD053
     D*LibName**        S             10                                                      CSD053
     D*DBCSLanguage     S             10                                                      CSD053
     D*ShftOutShftIn    S              1                                                      CSD053
     D*TypeOfConv       S             10                                                      CSD053
      **********                                                                              CSD053
     C*****' '**         CHECKR    InputData     Length                                       CSD053
      **********                                                                              CSD053
     C**********         CALL      'QDCXLATE'                                                 CSD053
     C**********         PARM                    Length                                       CSD053
     C**********         PARM                    InputData                                    CSD053
     C**********         PARM      'CGASCII'     TableName                                    CSD053
      **********                                                                              CSD053
     C**********         RETURN    InputData                                                  CSD053
      **********                                                                              CSD053
     P**********       E                                                                      CSD053
                                                                                             CSD053A
      ********************************************************************                   CSD053A
      * Convert to ASCII                                                                     CSD053A
      ********************************************************************                   CSD053A
     PConvertAscii     B                                                                     CSD053A
     DConvertAscii     PI          1000                                                      CSD053A
     DInputData                    1000                                                      CSD053A
     DConvData         S           1000                                                      CSD053A
     DLength           S              5  0                                                   CSD053A
     DLengthCnv        S              5  0                                                   CSD053A
     DLengthOutBuf     S              5  0                                                   CSD053A
     DTableName        S             10                                                      CSD053A
     DLibName          S             10                                                      CSD053A
     DDBCSLanguage     S             10                                                      CSD053A
     DShftOutShftIn    S              1                                                      CSD053A
     DTypeOfConv       S             10                                                      CSD053A
                                                                                             CSD053A
     C     ' '           CHECKR    InputData     Length                                      CSD053A
                                                                                             CSD053A
     C                   CALL      'QDCXLATE'                                                CSD053A
     C                   PARM                    Length                                      CSD053A
     C                   PARM                    InputData                                   CSD053A
     C                   PARM      'CGASCII'     TableName                                   CSD053A
                                                                                             CSD053A
     C                   RETURN    InputData                                                 CSD053A
                                                                                             CSD053A
     P                 E                                                                     CSD053A
