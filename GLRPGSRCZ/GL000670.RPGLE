     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Write Data to Stream File')                   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000670 - Write Data to Stream File                         *
      *                                                               *
      *  Function: This sub-module receives parameters from           *
      *            GL000668 and process as follows:                   *
      *                                                               *
      *            a) *CREATE - Open/Create stream file               *
      *            b) *WRITE - write GLFXMLPD data into stream file.  *
      *            c) *CLOSE - Close stream file                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CGL154  *CREATE    Date 13Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL154 - FATCA Reporting                                     *
      *                                                               *
      *****************************************************************
      /EJECT
      * +------------------+
      * ¦ File declaration ¦
      * +------------------+

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
     D FDescDat        S             10I 0
     D FDescCtl        S             10I 0
     D Oflag           S             10I 0 INZ
     D Mode            S             10I 0 INZ
     D RC              S             10I 0
     D Codepage        C                   X'0333'
     D SysVal1         C                   'FATCAiSeriesPath'

      * +-------------------------+
      * ¦ Other standalone fields ¦
      * +-------------------------+
     D PathName        S            100A   INZ(*BLANKS)
     D ActionCode      S              7A
     D StmfName        S             30A   INZ(*BLANKS)
     D PMessageID      S             21A
     D PTimeStamp      S               Z
     D FileName        S             21A
     D IsPathName      S             75A

      ** Parameter variables for AOSVALR0 string
     D SValK1          S             20
     D SVal1           S            200
     D SValK2          S             20
     D SVal2           S            200
     D SValK3          S             20
     D SVal3           S            200
     D SValK4          S             20
     D SVal4           S            200
     D SValK5          S             20
     D SVal5           S            200
     D SValK6          S             20
     D SVal6           S            200
     D SValK7          S             20
     D SVal7           S            200
     D SValK8          S             20
     D SVal8           S            200
     D SValK9          S             20
     D SVal9           S            200
     D SValK0          S             20
     D SVal10          S            200
     D Rtcd            S              7    INZ(*BLANK)
     D Optn            S              7    INZ(*BLANK)

      * +-----------------+
      * ¦ Named Constants ¦
      * +-----------------+
     D ExtDAT          C                   CONST('.DAT')
     D ExtCTL          C                   CONST('.CTL')
     D CRLF            C                   X'0D25'
     D Null            C                   X'00'

      * +----------------------------------+
      * ¦ For *PSSR Error Handling routine ¦
      * +----------------------------------+
     D @RUN            S              1

     D WTimeStamp      DS
     D Wyear                   1      4
     D WMonth                  6      7
     D WDay                    9     10
     D WHour                  12     13
     D WMinute                15     16
     D WSecond                18     19
     D WMsecond               21     26

      * +-------------------------------------------------+
      * ¦ Variable declaration for the IFS APIs used here ¦
      * +-------------------------------------------------+
     D FileDesc        S             10I 0

      * +-----------------------------------------------+
      * ¦ Variable declaration for *WRITE mode to *STMF ¦
      * +-----------------------------------------------+
     D RecordData      S            280    INZ(*BLANKS)
     D PTagName        S             40
     D PTagValue       S            200
     D PTagValue2      S              3
     D PTagEnd         S                   LIKE(PTagName)
     D PFormat         S              3
     D  ConvValue      S            200    INZ(*BLANKS)

      * +-------------------------+
      * ¦ Other standalone fields ¦
      * +-------------------------+
     D Count           S              5P 0 INZ
     D Buffer          S            300A   INZ(*BLANK)
     D pBuffer         S               *   INZ(%ADDR(Buffer))
     D BigString       S           1000
     D i               S              3  0 INZ(0)
     D Pos             S              5  0
     D Head            S            230

     D RtnCode         S              7

      * +----------------------------------------+
      * ¦ Variables for writing into Stream File ¦
      * +----------------------------------------+
     D HeadLine        S            100
     D CorrLine        S            184
     D SysLine         S            135
     D WFlag           S              1

      * +-----------------+
      * ¦ Named Constants ¦
      * +-----------------+
     D XMLHead1        C                   'xml version="1.0" encoding="UTF-8"'

      * +-----------------------------------------------+
      * ¦ Data Structure (long) used by Access Programs ¦
      * +-----------------------------------------------+
     D Dsldy         E DS                  EXTNAME(DSLDY)

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
     D TagValue                            LIKE(PTagValue)

      * +-------------------------------------------------------------+
      * ¦ Function to convert in Ascii characters according to the    ¦
      * ¦ conversion table ASCII.                                     ¦
      * +-------------------------------------------------------------+
     DConvertAscii     PR          1000
     DInputData                    1000

      /EJECT
      * +------------------------------------------------------------------+
      * ¦ Main Routine                                                     ¦
      * +------------------------------------------------------------------+
      *

     C                   SELECT
      *  Open the Streamfile
     C                   WHEN      ActionCode = '*CREATE'
     C                   EXSR      CREATESTMF

      *  Write the Streamfile
     C                   WHEN      ActionCode = '*WRITE'
     C                   EXSR      WRITESTMF

      *  Close the Streamfile .DAT
     C                   WHEN      ActionCode = '*CLOSE'
     C                   EXSR      CLOSESTMF
     C                   ENDSL

     C                   EVAL      *INLR = *ON
      *  Terminate the program
     C                   RETURN

      /EJECT
      * +------------------------------------------------------------------+
      * ¦ Subr/*INZSR - Initialisation subroutine                          ¦
      * +------------------------------------------------------------------+
     C     *INZSR        BEGSR

      * List of program parameters :
      * --------------------------
      * a) RtnCode - normally *BLANK at entry
      * b) ActCode - should be either *OPEN, *WRITE or *CLOSE

     C     *ENTRY        PLIST
     C                   PARM                    ActionCode
     C                   PARM                    PTagName
     C                   PARM                    PTagValue
     C                   PARM                    PTagValue2
     C                   PARM                    PTagEnd
     C                   PARM                    PFormat
     C                   PARM                    RtnCode

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       Rtcd
     C                   PARM      SysVal1       SValK1
     C                   PARM                    SVal1
     C                   PARM                    SValK2
     C                   PARM                    SVal2
     C                   PARM                    SValK3
     C                   PARM                    SVal3
     C                   PARM                    SValK4
     C                   PARM                    SVal4
     C                   PARM                    SValK5
     C                   PARM                    SVal5
     C                   PARM                    SValK6
     C                   PARM                    SVal6
     C                   PARM                    SValK7
     C                   PARM                    SVal7
     C                   PARM                    SValK8
     C                   PARM                    SVal8
     C                   PARM                    SValK9
     C                   PARM                    SVal9
     C                   PARM                    SValK0
     C                   PARM                    SVal10

     C                   IF        Rtcd <> *Blanks
     C                             AND Rtcd <> '*NRF   '
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = SValK1
     C                   EVAL      DBASE = 001
     C                   EVAL      DBPGM = 'GL000700'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      IsPathName = SVal1
     C                   ENDIF

     C                   ENDSR

      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/CREATESTMF - Create streamfile (type *STMF) in         ¦
      * ¦                   exclusive mode.                           ¦
      * +-------------------------------------------------------------+
     C     CREATESTMF    BEGSR

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimeStamp
     C                   MOVEL     PTimeStamp    WTimeStamp
     C                   EVAL      FileName = WYear + WMonth + WDay + '_' +
     C                               WHour + WMinute + WSecond + WMsecond

      *  Define the streamfile name (FileName + '.DAT').
     C                   EVAL      StmfName = FileName + ExtDAT

      *  Define the path using the Local Directory entry in ICD
     C                   EVAL      PathName =
     C                               %TRIM(IsPathName) + '/' + %TRIM(StmfName)

      *  CREATE THE STREAM FILE
      *  ----------------------
      *  Set file status flag for creation of stream file where the file
      *  is opened for writing only and not shared (i.e. exclusive for
      *  this process).
     C                   EVAL      Oflag = O_CREATE + O_WRONLY +
     C                                     O_SHARE_NONE + O_CODEPAGE
      * Set file mode parameter
     C                   EVAL      mode = S_IRWXU + S_IRWXG +
     C                                    S_IROTH + S_IXOTH

      * Create stream file
     C                   EVAL      FDescDat = OPEN(%TRIMR(PathName) :
     C                                      Oflag : mode : Codepage)

      * If error creating the Streamfile
     C                   IF        FDescDat = -1
     C                   EVAL      DBFILE =  *BLANK
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      * +-------------------------------------------------------------+
      * ¦ Subr/WRITESTMF - Write XML details                          ¦
      * ¦                into the stream file.                        ¦
      * +-------------------------------------------------------------+
     C     WRITESTMF     BEGSR

      * Format the header if it's the first record read for a given
      * item number
     C                   SELECT

     C                   WHEN      PFormat = 'ROT'  and
     C                             %SUBST(PTagName:2:1) <> '/'

     C                   EVAL      Head = %SUBST(PTagName:1:15)
     C                             + ' ' + 'xmlns:ftc="ftc " xmlns:sfa="sfa " '
     C                             + 'version="' + %TRIM(PTagvalue) + '">'
     C                   EVAL      BigString = %TRIM(Head) + CRLF
     C                   EVAL      Buffer = %TRIMR(ConvertAscii(BigString))

     C                   WHEN      PFormat = 'ISB'

     C                   EVAL      RecordData = %SUBST(PTagName:1:8) +
     C                               ' issuedBy="' + %TRIM(PTagValue2) +'">'
     C                               + %TRIM(PTagValue) + PTagEnd
     C                   EVAL      BigString = %TRIM(RecordData) + CRLF
     C                   EVAL      Buffer = %TRIMR(ConvertAscii(BigString))

     C                   WHEN      PFormat = 'AMT'
     C                   EVAL      Pos = %SCAN('>':PTagName)
     C                   EVAL      RecordData = %SUBST(PTagName:1:Pos-1) +
     C                               ' currCode="' + %TRIM(PTagValue2)
     C                               + '">' + %TRIM(PTagValue) + PTagEnd
     C                   EVAL      BigString = %TRIM(RecordData) + CRLF
     C                   EVAL      Buffer = %TRIMR(ConvertAscii(BigString))

     C                   OTHER
      *  Scan tag value for special characters (i.e. '&','<', '>'),
      *  if so, format field as '<!£CDATA£Tag Value]]>'.
     C                   EVAL      ConvValue = ScanFld(PTagValue)

      *  Combine data into a single compressed field.
     C                   EVAL      RecordData = %TRIM(PTagName)+
     C                              %TRIM(ConvValue) + %TRIM(PTagEnd)

      *  Attach CRLF at the end of each record line
     C                   EVAL      BigString = %TRIM(RecordData) + CRLF
     C                   EVAL      Buffer = %TRIMR(ConvertAscii(BigString))
     C                   ENDSL

      * Write record to stream file
     C                   EVAL      RC = WRITE(FileDesc : pBuffer :
     C                                         %LEN(%TRIMR(Buffer)))

      *  If error writing to stream file
     C                   IF        RC = -1
     C                   EVAL      DBFILE =  *BLANK
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  006
     C                   EVAL      DBMOD  =  PSProcMod

     C                   EXSR      *PSSR
     C                   ENDIF


     C                   ENDSR
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/CLOSESTMF - Wrap the stream file by writing line       ¦
      * ¦                  '</Correspondent>' then close it using     ¦
      * ¦                  IFS API CLOSE()function.                   ¦
      * +-------------------------------------------------------------+
     C     CLOSESTMF     BEGSR

      *  Now close the .DAT file
     C                   EVAL      RC = CLOSE(FDescDat)

      *  If error closing the streamfile, process dbase error.
     C                   IF        RC = -1
     C                   EVAL      DBFILE =  *BLANK
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  008
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF

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

     C                   EVAL      RtnCode = '*ERROR*'

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
     D  TagValue                           LIKE(PTagValue)

     D  SpcChar        S             10    INZ('&<>')
     D  SpcArr         S              1    DIM(10)
     D  ConvValue      S             80    INZ(*BLANKS)
     D  X              S              3  0
     D  WFound         S              1    INZ('N')

      *  Load special chars to be scanned into a work array and
      *  initialise array index.
     C                   MOVEA     SpcChar       SpcArr
     C                   EVAL      X = 1

      *  Search Tag Value field for each special character
     C                   DOW       (X <= %ELEM(SpcArr)) AND
     C                             (SpcArr(X) <> *BLANK)

     C     SpcArr(X)     SCAN      TagValue                               90

      *  If any of special character is found, format the Tag Value field.
      *+------------------------------------------------------------------+
      *¦ NOTE : A problem is encountered if character '£' is FTPd to the  ¦
      *¦        PC. '£' seems to be translated into '$'. We found that    ¦
      *¦        '[' translates to '£' when FTPd. Hence was used here.     ¦
      *+------------------------------------------------------------------+
     C                   IF        *IN90 = *ON
     C                   EVAL      WFound = 'Y'
     C                   EVAL      ConvValue = '<!£CDATA£' +
     C                               %TRIM(TagValue) + ']]>'
     C                   LEAVE
     C                   ENDIF

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
     PConvertAscii     B
     DConvertAscii     PI          1000
     DInputData                    1000
      *
     DConvData         S           1000
     DLength           S              5  0
     DLengthCnv        S              5  0
     DLengthOutBuf     S              5  0
     DTableName        S             10
     DLibName          S             10
     DDBCSLanguage     S             10
     DShftOutShftIn    S              1
     DTypeOfConv       S             10
      *
     C     ' '           CHECKR    InputData     Length
      *
     C                   CALL      'QDCXLATE'
     C                   PARM                    Length
     C                   PARM                    InputData
     C                   PARM      'CGASCII'     TableName
      *
     C                   RETURN    InputData
      *
     P                 E

