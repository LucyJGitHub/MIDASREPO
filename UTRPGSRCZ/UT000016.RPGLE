  ******************************************************************
     H DEBUG
     H DFTACTGRP(*NO)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Convert Spool Files to PDF')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000016 - Midas UT Convert Spool file to PDF                *
      *                                                               *
      *  Function:  This program converts an iSeries spooled file     *
      *               to PDF.                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CUT016  *Create    Date 10Apr15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUT016 - iSeries Spooled Files conversion                    *
      *                                                               *
      *****************************************************************

      * Work files

     FUTSPLFTD  IF   F  382        DISK

     FUTTOOPTD  UF A F  378        DISK

      * Program parameter - report title

     D paTitle         S             50A

      * Program parameter - spooled file information returned by API

     D SplInfo         DS
     D  saReturned                   10I 0
     D  saAvailabl                   10I 0
     D  saIntJobId                   16A
     D  saSplfId                     16A
     D  saJobName                    10A
     D  saUser                       10A
     D  saJobNbr                      6A
     D  saSplFile                    10A
     D  saSplNbr                     10I 0
     D  saFormType                   10A
     D  saUsrDta                     10A
     D  saStatus                     10A
     D  saFilAvail                   10A
     D  saHold                       10A
     D  saSave                       10A
     D  siPages                      10I 0
     D  siCurrPage                   10I 0
     D  siFromPage                   10I 0
     D  siToPage                     10I 0
     D  siLastPage                   10I 0
     D  siRestart                    10I 0
     D  siCopies                     10I 0
     D  siCopyRem                    10I 0
     D  siLPI                        10I 0
     D  siCPI                        10I 0
     D  siOutPty                      2A
     D  saOutq                       10A
     D  saOutqLib                    10A
     D  saOpenDate                    7A
     D  saOpenTime                    6A
     D  saPrtFile                    10A
     D  saPrtfLib                    10A
     D  saPgmName                    10A
     D  saPgmLib                     10A
     D  saAcgCode                    15A
     D  saPrtTxt                     30A
     D  siRcdLen                     10I 0
     D  siMaxRcds                    10I 0
     D  saDevType                    10A
     D  saPrtType                    10A
     D  saDocName                    12A
     D  saFlrName                    64A
     D  saS36Proc                     8A
     D  saFidelity                   10A
     D  saRplUnprt                    1A
     D  saRplChar                     1A
     D  siPageLen                    10I 0
     D  siPageWdth                   10I 0
     D  siSepartrs                   10I 0
     D  siOvrFlw                     10I 0
     D  saDBCS                       10A
     D  saDBCSExt                    10A
     D  saDBCSSOSI                   10A
     D  saDBCSRotn                   10A
     D  saDBCSCPI                    10I 0
     D  saGraphics                   10A
     D  saCodePage                   10A
     D  saFormDf                     10A
     D  saFormDfLb                   10A
     D  siDrawer                     10I 0
     D  saFont                       10A
     D  saS36SplId                    6A
     D  siRotation                   10I 0
     D  siJustify                    10I 0
     D  saDuplex                     10A
     D  saFoldRcds                   10A
     D  saCtlChar                    10A
     D  saAlign                      10A
     D  saPrtQlty                    10A
     D  saFormFeed                   10A
     D  saVolumes                    71A
     D  saLabels                     17A
     D  saExchange                   10A
     D  saCharCode                   10A
     D  siTotRcds                    10I 0
     D  siMultiUp                    10I 0
     D  saFrontOvl                   10A
     D  saFrtOvlLb                   10A
     D  snFOOffDwn                   15P 5
     D  snFOOffAcr                   15P 5
     D  saBackOvl                    10A
     D  saBckOvlLb                   10A
     D  snBOOffDwn                   15P 5
     D  snBOOffAcr                   15P 5
     D  saUOM                        10A
     D  saPagDfn                     10A
     D  saPagDfnLb                   10A
     D  saSpacing                    10A
     D  snPointSiz                   15P 5
     D  snFMOffDwn                   15P 5
     D  snFMOffAcr                   15P 5
     D  snBMOffDwn                   15P 5
     D  snBMOffAcr                   15P 5
     D  snPageLen                    15P 5
     D  snPageWdth                   15P 5
     D  saMethod                     10A
     D  saAFP                         1A
     D  saChrSet                     10A
     D  saChrSetLb                   10A
     D  saCdePagNm                   10A
     D  saCdePgeLb                   10A
     D  saCdeFnt                     10A
     D  saCdeFntLb                   10A
     D  saDBCSFnt                    10A
     D  saDBCSFntL                   10A
     D  saUserDef                    10A
     D  saReduce                     10A
     D  saReserv1                     1A
     D  siOutBin                     10I 0
     D  siCCSID                      10I 0
     D  saUserText                  100A
     D  saSystem                      8A
     D  saOrigId                      8A
     D  saCreator                    10A

      * Program parameter - bookmark option

     D paBookmark      S              7A

      * Program parameter - page format

     D PageFmt         S             11A

      * Program parameter - bookmark *POS option parameters

     D BMarkPos        DS
     D   siPosCount                   5I 0
     D   snPosLine                    3P 0
     D   snPosChar                    3P 0
     D   snPosLen                     3P 0

      * Program parameter - bookmark *KEY option parameters

     D BMarkKey        DS
     D   siKeyCount                   5I 0
     D   siLen                        5I 0
     D   saKeyStr                   378A
     D   snKeyOccur                   3P 0
     D   snKeyOff                     3P 0
     D   snKeyLen                     3P 0

      * PDF 'object' array

     D aiObject        S             10I 0 DIM(32767)

      * Start position of PDF options

     D aaStart         S             10A   DIM(32767)

      * Current object number

     D wiObject        S             10I 0

      * Current count of bytes written

     D wiChrCount      S             10I 0

      * Current page number

     D wiPage          S             10I 0

      * Start position of text

     D wiStart         S             10I 0

      * Bookmark text

     D waBookmark      S            378A

      * Count of occurrences of the bookmark key

     D wiOccurs        S              5I 0

      * Input spooled file data including control characters

     D InputData       DS
     D   saSkipLine                   3A
     D   ssSkipLine                   3S 0 OVERLAY(saSkipLine:1)
     D   saSpceLine                   1A
     D   ssSpceLine                   1S 0 OVERLAY(saSpceLine:1)
     D   saInput                    378A

      * Output PDF-format data

     D OutputData      DS
     D   saOutput                   378A

      * Procedure prototypes

     D WritePDF        PR
     D   iaOutput                   378A   CONST OPTIONS(*VARSIZE)

     D AddEscape       PR           378A
     D   iaInput                    378A

     D PDFHeader       PR

     D PDFPages        PR

     D PDFTrailer      PR

     D NewPage         PR

     D EndPage         PR

     D NumToText       PR            10A
     D    iiNum                      10I 0 CONST

     D NewObject       PR


      ** ---------------
      ** MAIN PROCESSING
      ** ---------------

      * Output a PDF header

     C                   CALLP     PDFHeader

      * Create PDF page 'objects'

     C                   CALLP     PDFPages

      * Output a PDF trailer

     C                   CALLP     PDFTrailer

     C                   RETURN
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
      *
     C     *INZSR        BEGSR

      * Program parameters

     C     *ENTRY        PLIST
     C                   PARM                    paTitle
     C                   PARM                    SplInfo
     C                   PARM                    paBookmark
     C                   PARM                    BMarkPos
     C                   PARM                    BMarkKey
     C                   PARM                    PageFmt
      *
     C     EINZSR        ENDSR

      **********************************************************************
      * Procedure to create a PDF 'header'                                 *
      **********************************************************************

     P PDFHeader       B

     D PDFHeader       PI

     D liPage          S             10I 0
     D liPageObj       S             10I 0

      * Create catalog object

     C                   CALLP     WritePDF('%PDF-1.0')
     C                   CALLP     WritePDF('%????')
     C                   CALLP     NewObject
     C                   CALLP     WritePDF(%trim(NumToText(wiObject))+' 0 obj')
     C                   CALLP     WritePDF('<<')
     C                   CALLP     WritePDF('/Type /Catalog')
     C                   CALLP     WritePDF('/Pages 5 0 R')
     C                   CALLP     WritePDF('/Outlines 2 0 R')
     C                   CALLP     WritePDF('/PageMode /UseOutlines')
     C                   CALLP     WritePDF('>>')
     C                   CALLP     WritePDF('endobj')

      * Create outlines object

     C                   CALLP     NewObject
     C                   CALLP     WritePDF(%trim(NumToText(wiObject))+' 0 obj')
     C                   CALLP     WritePDF('<<')
     C                   CALLP     WritePDF('/Type /Outlines')
     C                   CALLP     WritePDF('/Count '+%trim(NumToText(siPages)))
     C                   CALLP     WritePDF(  '/First 9 0 R')
     C
     C                   CALLP     WritePDF(  '/Last  '
     C                                      + %trim(NumToText((siPages*4)+5))
     C                                      + ' 0 R')
     C                   CALLP     WritePDF('>>')
     C                   CALLP     WritePDF('endobj')

      * Create procedures object

     C                   CALLP     NewObject
     C                   CALLP     WritePDF(%trim(NumToText(wiObject))+' 0 obj')
     C                   CALLP     WritePDF('[/PDF /Text]')
     C                   CALLP     WritePDF('endobj')

      * Create fonts object

     C                   CALLP     NewObject
     C                   CALLP     WritePDF(%trim(NumToText(wiObject))+' 0 obj')
     C                   CALLP     WritePDF('<<')
     C                   CALLP     WritePDF ('/Type /Font')
     C                   CALLP     WritePDF ('/Subtype /Type1')
     C                   CALLP     WritePDF ('/Name /F1')
     C                   CALLP     WritePDF ('/BaseFont /Courier')
     C                   CALLP     WritePDF ('/Encoding /WinAnsiEncoding')
     C                   CALLP     WritePDF ('>>')
     C                   CALLP     WritePDF ('endobj')

      * Create pages object

     C                   CALLP     NewObject
     C                   CALLP     WritePDF(%trim(NumToText(wiObject))+' 0 obj')
     C                   CALLP     WritePDF ('<<')
     C                   CALLP     WritePDF ('/Type /Pages')
     C                   CALLP     WritePDF('/Count '+%trim(NumToText(siPages)))

      * Write list of child pages

     C                   EVAL      liPage    = wiObject + 1
     C                   EVAL      liPageObj = liPage
     C                   CALLP     WritePDF (  '/Kids ['
     C                                       + %trim(NumToText(liPage))
     C                                       + ' 0 R')

     C                   DOW       liPage < siPages + wiObject
     C                   EVAL      liPage = liPage + 1
     C                   EVAL      liPageObj = liPageObj + 4
     C                   CALLP     WritePDF (  '       '
     C                                       + %trim(NumToText(liPageObj))
     C                                       + ' 0 R')
     C                   ENDDO

     C                   CALLP     WritePDF ('       ]')

     C                   CALLP     WritePDF ('>>')
     C                   CALLP     WritePDF ('endobj')

     P PDFHeader       E

      **********************************************************************
      * Procedure to create PDF pages                                      *
      **********************************************************************

     P PDFPages        B

     D liLine          S             10I 0
     D liLength        S              5I 0
     D liChar          S              5I 0
     D liX             S              5I 0
     D liY             S              5I 0

      * Create page object for first page

     C                   EVAL      wiPage = 0
     C                   EVAL      liX = 0

      * Read spooled file data from input work file

     C                   READ      UTSPLFTD      InputData                LR

     C                   DOW       *INLR = *OFF

      * Skip to a line if specified, handling page throw if it occurs

     C                   IF        saSkipLine <> *BLANKS
     C                   IF        ssSkipLine < liLine or liLine = 0
     C                   IF        wiPage <> 0
     C                   CALLP     EndPage
     C                   ENDIF
     C                   CALLP     NewPage
     C                   EVAL      liLine = ssSkipLine
     C                   IF        PageFmt = '*LANDSCAPE'
     C                   EVAL        liY
     C                             = (612/siPageLen) * (siPagelen-liLine)
     C                   else
     C                   EVAL        liY
     C                             = (792/siPageLen) * (siPagelen-liLine)
     C                   Endif
     C                   ELSE
     C                   IF        PageFmt = '*LANDSCAPE'
     C                   EVAL        liY
     C                             = -((612/siPageLen) * (ssSkipLine-liLine))
     C                   else
     C                   EVAL        liY
     C                             = -((792/siPageLen) * (ssSkipLine-liLine))
     C                   Endif
     C                   EVAL      liLine = ssSkipLine
     C                   ENDIF
     C                   ENDIF

      * Space a number of lines if specified

     C                   IF        saSpceLine <> *BLANKS
     C                   EVAL      liLine = liLine + ssSpceLine
     C                   IF        PageFmt = '*LANDSCAPE'
     C                   EVAL        liY
     C                             = -((612/siPageLen) * ssSpceLine)
     C                   else
     C                   EVAL        liY
     C                             = -((792/siPageLen) * ssSpceLine)
     C                   Endif
     C                   ENDIF

      * Set up bookmark if position option specified

     C                   IF        paBookmark = '*POS'
     C                   IF        liLine = snPosLine and waBookmark = *BLANKS
     C                   EVAL      waBookmark = %trim(%subst(saInput  :
     C                                                       snPosChar:
     C                                                       snPosLen ))
     C                   ENDIF
     C                   ENDIF

      * Set up bookmark if key option specified

     C                   IF        paBookmark = '*KEY'
     C     saKeyStr:siLenSCAN      saInput:1     liChar
     C                   IF        liChar > 0
     C                   EVAL      wiOccurs = wiOccurs + 1
     C                   IF        wiOccurs = snKeyOccur
     C                   EVAL      liChar = liChar + snKeyOff
     C                   EVAL      liLength = snKeyLen
     C                   IF        liChar + liLength > siPageWdth
     C                   EVAL      liLength = siPageWdth - liChar
     C                   ENDIF
     C                   IF        liChar < 1
     C                   EVAL      liChar = 1
     C                   ENDIF
     C                   IF        liChar + liLength <= siPageWdth
     C                   EVAL      waBookmark = %trim(%subst(saInput  :
     C                                                       liChar   :
     C                                                       liLength ))
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * Add escape character before special characters \, ( and )

     C                   EVAL      saInput = AddEscape(saInput)

      * Output the line of text

     C                   CALLP     WritePDF(  %trim(NumToText(liX))
     C                                      + ' '
     C                                      + %trim(NumToText(liY))
     C                                      + ' Td ('
     C                                      + %trimr(saInput)
     C                                      + ') Tj')

     C                   READ      UTSPLFTD      InputData                LR

     C                   ENDDO

     C                   CALLP     EndPage

     P PDFPages        E

      **********************************************************************
      * Procedure to create a PDF trailer                                  *
      **********************************************************************

     P PDFTrailer      B

     D PDFTrailer      PI

     D laDateTime      S             14A
     D i               S             10I 0
     D liXRef          S             10I 0

      * Create information object

     C                   CALLP     NewObject
     C                   CALLP     WritePDF(%trim(NumToText(wiObject))+' 0 obj')
     C                   CALLP     WritePDF('<<')
     C                   CALLP     WritePDF(  '/Creator ('
     C                                      + %trim(saPgmLib)
     C                                      + '/'
     C                                      + %trim(saPgmName)
     C                                      + ')' )
     C                   IF        %subst(saOpenDate:1:1) = '0'
     C                   EVAL      laDateTime = '19' + %subst(saOpenDate:2:6)
     C                                               + saOpenTime
     C                   ELSE
     C                   EVAL      laDateTime = '20' + %subst(saOpenDate:2:6)
     C                                               + saOpenTime
     C                   ENDIF
     C                   CALLP     WritePDF(  '/CreationDate (D:'
     C                                      + laDateTime + ')')
     C                   CALLP     WritePDF('/Title (' + %trim(paTitle) + ')')
     C                   CALLP     WritePDF('/Producer (CVTSPLPDF)')
     C                   CALLP     WritePDF('/Keywords ()')
     C                   CALLP     WritePDF(  '/Author ('
     C                                      + %trim(saJobNbr)
     C                                      + '/'
     C                                      + %trim(saUser)
     C                                      + '/'
     C                                      + %trim(saJobName)
     C                                      + ')' )
     C                   CALLP     WritePDF('>>')
     C                   CALLP     WritePDF('endobj')

      * Create cross-reference

     C                   EVAL      liXref = wiChrCount - 1
     C                   CALLP     WritePDF('xref 0 '
     C                                      + %trim(NumToText(wiObject+1)) )
     C                   CALLP     WritePDF('0000000000 65535 f')

     C                   DO        wiObject      i
     C                   CALLP     WritePDF(aaStart(i) + ' 00000 n')
     C                   ENDDO

      * Write trailer

     C                   CALLP     WritePDF('trailer')
     C                   CALLP     WritePDF('<<')
     C                   CALLP     WritePDF('/Size '
     C                                      + %trim(NumToText(wiObject+1)))
     C                   CALLP     WritePDF('/Root 1 0 R')
     C                   CALLP     WritePDF('/Info '
     C                                      + %trim(NumToText(wiObject))
     C                                      + ' 0 R')
     C                   CALLP     WritePDF('>>')
     C                   CALLP     WritePDF('startxref')
     C                   CALLP     WritePDF(%trim(NumToText(liXref)))
     C                   CALLP     WritePDF('%%EOF')

     P PDFTrailer      E

      **********************************************************************
      * Procedure to create a new PDF 'object'                             *
      **********************************************************************
     P NewObject       B

     D NewObject       PI

     D lsDataLen       S             10S 0
     D i               S             10I 0

     C                   EVAL      wiObject = wiObject + 1
     C                   EVAL      i = wiObject
     C                   EVAL      lsDataLen = wiChrCount
     C                   MOVE      lsDataLen     aaStart(i)

     P NewObject       E

      **********************************************************************
      * Procedure to output PDF data
      **********************************************************************

     P WritePDF        B

     D WritePDF        PI
     D   iaOutput                   378A   CONST OPTIONS(*VARSIZE)

     D liLength        S              5I 0

      * Update byte count with length of data to be written

     C     ' '           CHECKR    iaOutput      liLength
     C                   EVAL      wiChrCount= wiChrCount + liLength + 2

      * Output data to work file

     C                   EVAL      saOutput = %trimr(iaOutput)
     C                   WRITE     UTTOOPTD      OutputData

     P WritePDF        E

      **********************************************************************
      * Procedure to convert a number to text                              *
      **********************************************************************

     P NumToText       B

     D NumToText       PI            10A
     D    iiNum                      10I 0 CONST

     D laSign          S              1A
     D laInput         S             10A
     D laOutput        S             10A
     D liIn            S              5I 0
     D liOut           S              5I 0
     D liNum           S             10I 0

      * Set up sign if and make number positive if number is negative

     C                   IF        iiNum < 0
     C                   EVAL      laSign = '-'
     C                   EVAL      liNum = -iiNum
     C                   ELSE
     C                   EVAL      laSign = ' '
     C                   EVAL      liNum = iiNum
     C                   ENDIF

      * Number number to work character variable

     C                   MOVE      liNum         laInput

      * Skip over leading zeros

     C                   EVAL      liIn  = 1
     C                   EVAL      liOut = 1
     C                   DOW           liIn < %size(laInput)
     C                             and %subst(laInput:liIn:1) = '0'
     C                   EVAL      liIn = liIn + 1
     C                   ENDDO

      * Move digits to output area

     C                   DOW           liIn  <= %size(laInput)
     C                             and liOut <= %size(laOutput)
     C                   EVAL        %subst(laOutput:liOut:1)
     C                             = %subst(laInput :liIn :1)
     C                   EVAL      liIn  = liIn  + 1
     C                   EVAL      liOut = liOut + 1
     C                   ENDDO

      * Add sign

     C                   IF        laSign = '-'
     C                   EVAL      laOutput = laSign + laOutput
     C                   ENDIF

      * Return number in text format

     C                   RETURN    laOutput

     P NumToText       E

      **********************************************************************
      * Procedure to add an escape character before special characters     *
      **********************************************************************

     P AddEscape       B

     D AddEscape       PI           378A
     D   iaInput                    378A

     D laOutput        S            378A
     D laChar          S              1A
     D i               S              5I 0
     D o               S              5I 0
     D liLength        S              5I 0

      * Determine length of input data

     C     ' '           CHECKR    iaInput       liLength

      * Work through input data and prefix special characters with escape

     C                   EVAL      i = 1
     C                   EVAL      o = 0
     C                   DOW       i <= liLength

     C                   EVAL      laChar = %subst(iaInput:i:1)
     C                   IF        laChar = '\' or laChar = '(' or laChar = ')'
     C                   EVAL      o = o + 1
     C                   EVAL      %subst(laOutput:o:1) = '\'
     C                   ENDIF
     C                   EVAL      o = o + 1
     C                   EVAL      %subst(laOutput:o:1) = laChar
     C                   EVAL      i = i + 1
     C                   ENDDO

     C                   RETURN    laOutput

     P AddEscape       E

      **********************************************************************
      * Procedure to create a new page object                              *
      **********************************************************************

     P NewPage         B

     D NewPage         PI

      * Create a page object

     C                   EVAL      wiPage = wiPage + 1
     C                   CALLP     NewObject

     C                   CALLP     WritePDF(%trim(NumToText(wiObject))+' 0 obj')
     C                   CALLP     WritePDF('<<')
     C                   CALLP     WritePDF('/Type /Page')
     C                   CALLP     WritePDF('/Parent 5 0 R')
     C                   CALLP     WritePDF(  '/Resources << /Font <<'
     C                                      + ' /F1 4 0 R >>'
     C                                      + ' /ProcSet 3 0 R >>')
     C                   IF        PageFmt = '*LANDSCAPE'
     C                   CALLP     WritePDF('/MediaBox [0 0 792 612]')
     C                   else
     C                   CALLP     WritePDF('/MediaBox [0 0 612 792]')
     C                   Endif
     C                   CALLP     WritePDF(  '/Contents '
     C                                      + %trim(NumToText(wiObject+1))
     C                                      + ' 0 R')
     C                   CALLP     WritePDF('>>')
     C                   CALLP     WritePDF('endobj')

      * Set up bookmark if *PAGNBR option specified

     C                   IF        paBookmark = '*PAGNBR'
     C                   EVAL      waBookmark = 'Page '
     C                                        + %trim(NumToText(wiPage))
     C                   ELSE
     C                   EVAL      waBookmark = *BLANKS
     C                   EVAL      wiOccurs   = 0
     C                   ENDIF

      * Create a stream object

     C                   CALLP     NewObject

     C                   CALLP     WritePDF(%trim(NumToText(wiObject))+' 0 obj')
     C                   CALLP     WritePDF(  '<< /Length '
     C                                      + %trim(NumToText(wiObject+1))
     C                                      + ' 0 R >>')
     C                   CALLP     WritePDF('stream')
     C                   EVAL      wiStart = wiChrCount
     C                   CALLP     WritePDF('BT')

      **Determine*font*size*to*use*from*Characters*per*inch*setting*********

     C**********         SELECT
     C**********         WHEN      siCPI = 50
     C**********         CALLP     WritePDF('/F1 20 Tf')
     C**********         WHEN      siCPI = 120
     C**********         CALLP     WritePDF('/F1 9 Tf')
     C**********         WHEN      siCPI = 150
     C**********         CALLP     WritePDF('/F1 8 Tf')
     C**********         WHEN      siCPI = 167
     C**********         CALLP     WritePDF('/F1 6 Tf')
     C**********         OTHER
     C**********         CALLP     WritePDF('/F1 10 Tf')
     C**********         ENDSL
      *
      ** Use Spool file page width instead of CPI in determining the font size
      *
     C                   IF        PageFmt = '*LANDSCAPE'
     C                   SELECT
     C                   WHEN      siPageWdth <= 132
     C                   CALLP     WritePDF('/F1 10 Tf')
     C                   OTHER
     C                   CALLP     WritePDF('/F1 7.3 Tf')
     C                   ENDSL
     C                   Else
     C                   SELECT
     C                   WHEN      siPageWdth <= 132
     C                   CALLP     WritePDF('/F1 7.6 Tf')
     C                   OTHER
     C                   CALLP     WritePDF('/F1 5.6 Tf')
     C                   ENDSL
     C                   Endif

     P NewPage         E

      **********************************************************************
      * Procedure to finish a page object                                  *
      **********************************************************************

     P EndPage         B

     D EndPage         PI

     D liLength        S             10I 0

      * End text stream

     C                   CALLP     WritePDF('ET')
     C                   EVAL      liLength = wiChrCount- wiStart
     C                   CALLP     WritePDF('endstream')
     C                   CALLP     WritePDF('endobj')

      * Create indirect length object for stream

     C                   CALLP     NewObject
     C                   CALLP     WritePDF(%trim(NumToText(wiObject))+' 0 obj')
     C                   CALLP     WritePDF(%trim(NumToText(liLength)))
     C                   CALLP     WritePDF('endobj')

      * Create outline object

     C                   EVAL      waBookmark = AddEscape(waBookMark)
     C                   CALLP     NewObject
     C                   CALLP     WritePDF(%trim(NumToText(wiObject))+' 0 obj')
     C                   CALLP     WritePDF('<<')
     C                   CALLP     WritePDF('/Parent 2 0 R')
     C                   CALLP     WritePDF(  '/Title  ('
     C                                      + %trimr(waBookmark) + ')')
     C                   IF        wiPage > 1
     C                   CALLP     WritePDF(  '/Prev '
     C                                      + %trim(NumToText(wiObject-4))
     C                                      + ' 0 R')
     C                   ENDIF
     C                   IF        wiPage < siPages
     C                   CALLP     WritePDF(  '/Next '
     C                                      + %trim(NumToText(wiObject+4))
     C                                      + ' 0 R')
     C                   ENDIF
     C                   CALLP     WritePDF('/Dest ['
     C                                      + %trim(NumToText(wiObject-3))
     C                                      + ' 0 R /XYZ 0 792 0]')
     C                   CALLP     WritePDF('>>')
     C                   CALLP     WritePDF('endobj')

     P EndPage         E
