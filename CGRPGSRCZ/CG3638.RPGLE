     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXS *  RPGCVTOPT2                                                   *                       CSD053
/*EXI *  TEXT('Midas CG Test characters for EBCDIC code page')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3638 - Test characters for EBCDIC code pages               *
      *                                                               *
      *  Function:  This program formats 2 stream files               *
      *  - 1 ascii819.txt characters expected to be found in an ASCII *
      *  table code page 819 (conversion from EBCDIC->ASCII)          *
      *  - 2 ebcdic37.txt characters expected to be found in a EBCDIC *
      *  table code page 37 (no conversion)                           *
      *                                                               *
      *                                                               *
      *  Called By: *NONE                                             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CSD053             Date 07Jul06               *
      *                 CCG015  *CREATE    Date 09Apr02               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade.       *
      *         - Recompile due to SDCORMPD.                          *
      *  CCG015 - Correspondence Manager                              *
      *                                                               *
      *****************************************************************
      * +--------------------------------------+
      * ¦ Prototypes required for the IFS APIs ¦
      * +--------------------------------------+
      /COPY CGCPYSRC,IFSPROTO
 
      * +------------------------------------------------------+
      * ¦ READ API() definitions for oflag and mode parameters ¦
      * +------------------------------------------------------+
      /COPY CGCPYSRC,OPENDFN
 
      * +-----------------------------------------------------------------+
      * ¦ The following /COPY line includes all the defined fields in the ¦
      * ¦ PSDS.  They have meaningful names, prefixed by 'PS'.            ¦
      * +-----------------------------------------------------------------+
     D/COPY ZACPYSRC,PSDS
 
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
 
      * +-----------------------------------------------+
      * ¦ Data structure for Correspondence Manager ICD ¦
      * +-----------------------------------------------+
     D Sdcorm        E DS                  EXTNAME(SDCORMPD)
 
      * +-----------------------------------------------+
      * ¦ Data Structure (long) used by Access Programs ¦
      * +-----------------------------------------------+
     D Dsldy         E DS                  EXTNAME(DSLDY)
 
      * Convert to ASCII
     DConvertAscii     PR          1000
     DInputData                    1000
 
      * +-------------------------+
      * ¦ Parameters for AOCORMR0 ¦
      * +-------------------------+
     D Rtcd            S              7    INZ(*BLANK)
     D Optn            S              7    INZ(*BLANK)
 
      * +----------------------------------+
      * ¦ For *PSSR Error Handling routine ¦
      * +----------------------------------+
     D @RUN            S              1
 
      * Variables for the IFS APIs used
     D PathA           S            100A
     D PathB           S            100A
     D FileDesc        S             10I 0
     D Oflag           S             10I 0 Inz
     D Mode            S             10I 0 Inz
     D CodePage        S              3  0
 
      *  The data in the following DS will be written as a series of records
      *    to the IFS file that we open
     D MyData          DS
     D                                1A   Inz('!')
     D                                1A   Inz('"')
     D                                1A   Inz('#')
     D                                1A   Inz('¢')
     D                                1A   Inz('%')
     D                                1A   Inz('&')
     D                                1A   Inz('''')
     D                                1A   Inz('(')
     D                                1A   Inz(')')
     D                                1A   Inz('*')
     D                                1A   Inz('+')
     D                                1A   Inz(',')
     D                                1A   Inz('-')
     D                                1A   Inz('.')
     D                                1A   Inz('/')
     D                                1A   Inz('0')
     D                                1A   Inz('1')
     D                                1A   Inz('2')
     D                                1A   Inz('3')
     D                                1A   Inz('4')
     D                                1A   Inz('5')
     D                                1A   Inz('6')
     D                                1A   Inz('7')
     D                                1A   Inz('8')
     D                                1A   Inz('9')
     D                                1A   Inz(':')
     D                                1A   Inz(';')
     D                                1A   Inz('<')
     D                                1A   Inz('=')
     D                                1A   Inz('>')
     D                                1A   Inz('?')
     D                                1A   Inz('@')
     D                                1A   Inz('A')
     D                                1A   Inz('B')
     D                                1A   Inz('C')
     D                                1A   Inz('D')
     D                                1A   Inz('E')
     D                                1A   Inz('F')
     D                                1A   Inz('G')
     D                                1A   Inz('H')
     D                                1A   Inz('I')
     D                                1A   Inz('J')
     D                                1A   Inz('K')
     D                                1A   Inz('L')
     D                                1A   Inz('M')
     D                                1A   Inz('N')
     D                                1A   Inz('O')
     D                                1A   Inz('P')
     D                                1A   Inz('Q')
     D                                1A   Inz('R')
     D                                1A   Inz('S')
     D                                1A   Inz('T')
     D                                1A   Inz('U')
     D                                1A   Inz('V')
     D                                1A   Inz('W')
     D                                1A   Inz('X')
     D                                1A   Inz('Y')
     D                                1A   Inz('Z')
     D                                1A   Inz('£')
     D                                1A   Inz('\')
     D                                1A   Inz(']')
     D                                1A   Inz('[')
     D                                1A   Inz('_')
     D                                1A   Inz('`')
     D                                1A   Inz('a')
     D                                1A   Inz('b')
     D                                1A   Inz('c')
     D                                1A   Inz('d')
     D                                1A   Inz('e')
     D                                1A   Inz('f')
     D                                1A   Inz('g')
     D                                1A   Inz('h')
     D                                1A   Inz('i')
     D                                1A   Inz('j')
     D                                1A   Inz('k')
     D                                1A   Inz('l')
     D                                1A   Inz('m')
     D                                1A   Inz('n')
     D                                1A   Inz('o')
     D                                1A   Inz('p')
     D                                1A   Inz('q')
     D                                1A   Inz('r')
     D                                1A   Inz('s')
     D                                1A   Inz('t')
     D                                1A   Inz('u')
     D                                1A   Inz('v')
     D                                1A   Inz('w')
     D                                1A   Inz('x')
     D                                1A   Inz('y')
     D                                1A   Inz('z')
     D                                1A   Inz('{')
     D                                1A   Inz('|')
     D                                1A   Inz('}')
     D                                1A   Inz('¯')
     D                                1A   Inz(' ')
     D                                1A   Inz('¡')
     D                                1A   Inz('^')
     D                                1A   Inz('$')
     D                                1A   Inz('¤')
     D                                1A   Inz('¥')
     D                                1A   Inz('¦')
     D                                1A   Inz('§')
     D                                1A   Inz('¨')
     D                                1A   Inz('©')
     D                                1A   Inz('ª')
     D                                1A   Inz('«')
     D                                1A   Inz(' ')
     D                                1A   Inz('­')
     D                                1A   Inz('®')
     D                                1A   Inz('~')
     D                                1A   Inz('°')
     D                                1A   Inz('±')
     D                                1A   Inz('²')
     D                                1A   Inz('³')
     D                                1A   Inz('´')
     D                                1A   Inz('µ')
     D                                1A   Inz(' ')
     D                                1A   Inz('·')
     D                                1A   Inz('¸')
     D                                1A   Inz('¹')
     D                                1A   Inz('º')
     D                                1A   Inz('»')
     D                                1A   Inz('¼')
     D                                1A   Inz('½')
     D                                1A   Inz('¾')
     D                                1A   Inz('¿')
     D                                1A   Inz('À')
     D                                1A   Inz('Á')
     D                                1A   Inz('Â')
     D                                1A   Inz('Ã')
     D                                1A   Inz('Ä')
     D                                1A   Inz('Å')
     D                                1A   Inz('Æ')
     D                                1A   Inz('Ç')
     D                                1A   Inz('È')
     D                                1A   Inz('É')
     D                                1A   Inz('Ê')
     D                                1A   Inz('Ë')
     D                                1A   Inz('Ì')
     D                                1A   Inz('Í')
     D                                1A   Inz('Î')
     D                                1A   Inz('Ï')
     D                                1A   Inz('Ð')
     D                                1A   Inz('Ñ')
     D                                1A   Inz('Ò')
     D                                1A   Inz('Ó')
     D                                1A   Inz('Ô')
     D                                1A   Inz('Õ')
     D                                1A   Inz('Ö')
     D                                1A   Inz('×')
     D                                1A   Inz('Ø')
     D                                1A   Inz('Ù')
     D                                1A   Inz('Ú')
     D                                1A   Inz('Û')
     D                                1A   Inz('Ü')
     D                                1A   Inz('Ý')
     D                                1A   Inz('Þ')
     D                                1A   Inz('ß')
     D                                1A   Inz('à')
     D                                1A   Inz('á')
     D                                1A   Inz('â')
     D                                1A   Inz('ã')
     D                                1A   Inz('ä')
     D                                1A   Inz('å')
     D                                1A   Inz('æ')
     D                                1A   Inz('ç')
     D                                1A   Inz('è')
     D                                1A   Inz('é')
     D                                1A   Inz('ê')
     D                                1A   Inz('ë')
     D                                1A   Inz('ì')
     D                                1A   Inz('í')
     D                                1A   Inz('î')
     D                                1A   Inz('ï')
     D                                1A   Inz('ð')
     D                                1A   Inz('ñ')
     D                                1A   Inz('ò')
     D                                1A   Inz('ó')
     D                                1A   Inz('ô')
     D                                1A   Inz('õ')
     D                                1A   Inz('ö')
     D                                1A   Inz('÷')
     D                                1A   Inz('ø')
     D                                1A   Inz('ù')
     D                                1A   Inz('ú')
     D                                1A   Inz('û')
     D                                1A   Inz('ü')
     D                                1A   Inz('ý')
     D                                1A   Inz('þ')
     D                                1A   Inz('ÿ')
     D RecordData                     1A   Dim(190) Overlay(MyData)
 
      * Stand-Alone fields
     D RC              S             10I 0
     D Count           S              5P 0 Inz
     D buffer          S            200A   Inz(*blank)
     D  buffer@        S               *   Inz(%addr(buffer))
     D bigString       S           1000
      * Constants used by the program.
     D CRLF            C                   X'0D25'
     D Null            C                   X'00'
 
     C                   If        CMLODI = '/'
     C                   Eval      PathA = %TRIMR(CMLODI) + 'ascii819.txt'
     C                   Else
     C                   Eval      PathA = %TRIMR(CMLODI) + '/' + 'ascii819.txt'
     C                   Endif
 
      * Initialise the code page for stream file representation
     C                   MOVE      CMCPAG        CodePage
 
     C                   Eval      oflag = O_CREATE + O_WRONLY +
     C                                     + O_SHARE_NONE + O_CODEPAGE
      * Set file mode parameter
     C                   Eval      mode = S_IRWXU + S_IRWXG +
     C                                       S_IROTH + S_IXOTH
 
      * Openning the file, receiving a file descriptor
     C                   Eval      FileDesc = open(%trimr(PathA) : oflag :
     C                                        mode : codepage)
     C                   If        FileDesc = -1
     C                   Else
 
      *  Write records to the file
     C                   For       Count = 1 to %Elem(RecordData)
     C                   Eval      bigString = %TRIMR(RecordData(Count))
     C                                          + CRLF
     C                   Eval      buffer = %TRIMR(ConvertAscii(bigString))
     C                   Eval      rc = write(FileDesc :
     C                                               buffer@:
     C                                         %len(%trimr(buffer)))
     C                   If        RC = -1
     C                   EndIf
     C                   EndFor
 
      * Close the file
     C                   Eval      RC = close(FileDesc)
     C                   If        RC = -1
     C                   EndIf
     C                   EndIf
 
 
      * Initialise the code page for stream file representation
     C                   Eval      CodePage = 37
 
     C                   If        CMLODI = '/'
     C                   Eval      PathB = %TRIMR(CMLODI) + 'ebcdic.txt'
     C                   Else
     C                   Eval      PathB = %TRIMR(CMLODI) + '/' + 'ebcdic37.txt'
     C                   Endif
 
     C                   Eval      oflag = O_CREATE + O_WRONLY +
     C                                     + O_SHARE_NONE + O_CODEPAGE
      * Set file mode parameter
     C                   Eval      mode = S_IRWXU + S_IRWXG +
     C                                       S_IROTH + S_IXOTH
 
      * Openning the file, receiving a file descriptor
     C                   Eval      FileDesc = open(%trimr(PathB) : oflag :
     C                                        mode : codepage)
     C                   If        FileDesc = -1
     C                   Else
 
      *  Write records to the file
     C                   For       Count = 1 to %Elem(RecordData)
     C                   Eval      bigString = %TRIMR(RecordData(Count))
     C                                          + CRLF
     C                   Eval      buffer = %TRIMR(bigString)
     C                   Eval      rc = write(FileDesc :
     C                                               buffer@:
     C                                         %len(%trimr(buffer)))
     C                   If        RC = -1
     C                   EndIf
     C                   EndFor
 
      * Close the file
     C                   Eval      RC = close(FileDesc)
     C                   If        RC = -1
     C                   EndIf
     C                   EndIf
     C                   Eval      *inLR = *on
      * +------------------------------------------------------------------+
      * ¦ Subr/*INZSR - Initialisation subroutine                          ¦
      * +------------------------------------------------------------------+
     C     *INZSR        BEGSR
 
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
 
      * Initialise the code page for stream file representation
     C                   MOVE      CMCPAG        CodePage
 
     C                   ENDSR
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
 
      * End program
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
      * Convert to ASCII                                                 *
      ********************************************************************
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
