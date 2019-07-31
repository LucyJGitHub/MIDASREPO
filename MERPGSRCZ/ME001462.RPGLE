     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME SWIFTRef BANK DIRECTORY Plus Converter')      *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME001462 - ME SWIFTRef BANK DIRECTORY Plus Converter         *
      *                                                               *
      *  Function - This program reads ASCII Files (non formatted)    *
      *             and Write in appropriate EBCDIC formatted Files   *
      *             *ENTRY - PLoader parameter gives loader started   *
      *                                                               *
      *  Called By: MEC001425 and other                               *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSW218             Date 19Mar18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CFT051             Date 02Jun15               *
      *                 MD023533           Date 18Nov13               *
      *                 CFT050  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW218 - SWIFT Changes 2018                                  *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT051 - SWIFTRef Directories 2014                           *
      *  MD023533 - GOC0100 seq 00199 failed in COB (Recompile)       *
      *  CFT050 - SWIFTRef Directories upload                         *
      *                                                               *
      *****************************************************************
      **  PLoader = '1' : BANK DIRECTORY Plus Upload
      *
     FMEDWB3PD  IF   F 1248        DISK    USROPN
      ** Bank Directory Plus - DwnLd
      *
     FMEDWCTPD  IF   F 1248        DISK    USROPN
      ** Downloaded Swift CT file
      *
     FMEDWCUPD  IF   F 1248        DISK    USROPN
      ** Bank Dir. Plus/Currency - DwnLd
      *
     FMEDWHLPD  IF   F 1248        DISK    USROPN
      ** Bank Dir. Plus/Holiday - DwnLd
      *
     FMEDWTZPD  IF   F 1248        DISK    USROPN
      ** Bank Dir. Plus/Timezone- DwnLd
      *
     FMETIB3PD  UF A E             DISK    USROPN
      ** Bank Directory Plus - Wrk
      *
     FMETICCPD  UF A E             DISK    USROPN
      ** BIC Countries Temporary file
      *
     FMETICUPD  UF A E             DISK    USROPN
      ** Bank Directory Plus/Currency Wrk
      *
     FMETIHLPD  UF A E             DISK    USROPN
      ** Bank Directory Plus/Holiday Wrk
      *
     FMETITZPD  UF A E             DISK    USROPN
      ** Bank Directory Plus/Timezone Wrk
      *                                                                                       CFT051
     FMEDWSDPD  IF   F 1248        DISK    USROPN                                             CFT051
      ** Midas ME SWIFTRef Service Directory - DwnLd                                          CFT051
      *                                                                                       CFT051
     FMETISDPD  UF A E             DISK    USROPN                                             CFT051
      ** Midas ME SWIFTRef Service Directory - Wrk                                            CFT051
      *                                                                                       CFT051
     FMEDWLLPD  IF   F 1248        DISK    USROPN                                             CFT051
      ** Midas ME SWIFTRef Local Language - Dwnld                                             CFT051
      *                                                                                       CFT051
     FMETILLPD  UF A E             DISK    USROPN                                             CFT051
      ** Midas ME SWIFTRef Local Language - Wrk                                               CFT051
      *
      *
      **  PLoader = '2' : IBAN Plus DIRECTORY Upload
      *
     FMEDWIBPD  IF   F 1248        DISK    USROPN
      ** IBAN Plus Directory - DwnLd
      *
     FMEDWISPD  IF   F 1248        DISK    USROPN
      ** IBAN Plus Structure - DwnLd
      *
     FMETIIBPD  UF A E             DISK    USROPN
      ** IBAN Plus Directory - Wrk
      *
     FMETIISPD  UF A E             DISK    USROPN
      ** IBAN Plus Dir./IBAN Struct. -Wrk
      *
     FMEDWELPD  IF   F 1248        DISK    USROPN                                             CFT051
      ** Midas ME SWIFTRef Exclusion List - Dwnld                                             CFT051
      *                                                                                       CFT051
     FMETIELPD  UF A E             DISK    USROPN                                             CFT051
      ** Midas ME SWIFTRef Exclusion List - Wrk                                               CFT051
      *
      ***  PLoader = '3' : SSI  Plus DIRECTORY Upload
      *
     FMEDWSIPD  IF   F 1248        DISK    USROPN
      ** SSI Plus Download
      *
     FMETSSIPD  UF A E             DISK    USROPN
      ** SSI Plus Directory
      *
      *
      ***  PLoader = '4' : SEPA Plus DIRECTORY Upload
      *
     FMEDWSPPD  IF   F 1248        DISK    USROPN
      ** SEPA Plus Direcotry - DwnLd
      *
     FMETSEPPD  UF A E             DISK    USROPN
      ** SEPA Plus Directory - Wrk
      *
      ***  PLoader = '5' : BIC Database 2018 Upload                                           CSW218
      *                                                                                       CSW218
     FMEDWFIPD  IF   F 1248        DISK    USROPN                                             CSW218
      ** BIC Database 2018 - DwnLd                                                            CSW218
      *                                                                                       CSW218
     FMETIFIPD  UF A E             DISK    USROPN                                             CSW218
      ** BIC Database 2018 - Wrk                                                              CSW218
      *                                                                                       CSW218
      /EJECT
      *****************************************************************
      *                                                               *
      *    F U N C T I O N   O F   I N D I C A T O R S                *
      *                                                               *
      *       71  Read Indicator for Downloaded files                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     D PLoader         S              1A
      *
     D ARUN            S              1A
      *
     D PRTCD           S              7A
      *
     D POPTN           S              7A
      *
     D TMP105          S            105
      *
     D WKLIT1          S             17
      *
     D W1DATA          S           1248
      *
     D P1LEN           S              5  0
     D P1DTA           S           1248
     D P1TAB           S             10
     D P1LIB           S             10
      *
      ** Variables used in SRMOVE
      *
     D ENDPOS          S              5  0
     D TABPOS          S              5  0
     D LEN             S              5  0
     D D               S              5  0
     D E               S              5  0
     D F               S              5  0
     D I               S              5  0
     D J               S              5  0
     D T               S              5  0
      *
      ** Array containing Copyright statement
      *
     D ARRAY           S              1    DIM(1248)
     D RECORD          S              1    DIM(1248)
     D LEFT            S              1    DIM(1248)
     D FIELD           S              1    DIM(1248)
     D MOVE_IN         S              2A
     D DATA            S            250    DIM(90)
     D CR              C                   CONST(X'0D')
     D LF              C                   CONST(X'25')
     D TB              C                   CONST(X'05')
      *                                                                                       CFT051
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT051
      ** DS for Access Objects - short data structure                                         CFT051
      *                                                                                       CFT051
     D @RTCD           S              7A                                                      CFT051
     D @OPTN           S              7A                                                      CFT051
     D @SARD           S              6A                                                      CFT051
     D CFT051          S              1A                                                      CFT051
      *
      ** Data Structure for Conversion Data
      *
     D                 DS
     D  W1CONV                 1   1248
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects
      *
     D LDA             DS           256
      ** Local data area for database error details
      *
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256
      *
      ** PLoader = 1 : Input Files Formats  (no numeric in Sequence)
      *
     IMEDWB3PD  BX
     I                                  1 1248  DWB3
     IMEDWCTPD  CT
     I                                  1 1248  DWCT
     IMEDWCUPD  CU
     I                                  1 1248  DWCU
     IMEDWHLPD  HL
     I                                  1 1248  DWHL
     IMEDWTZPD  TZ
     I                                  1 1248  DWTZ
     IMEDWSDPD  SD                                                                            CFT051
     I                                  1 1248  DWSD                                          CFT051
     IMEDWLLPD  SD                                                                            CFT051
     I                                  1 1248  DWLL                                          CFT051
      *
      ** PLoader = 2 : Input Files Formats
      *
     IMEDWIBPD  IB
     I                                  1 1248  DWIB
     IMEDWISPD  IS
     I                                  1 1248  DWIS
     IMEDWELPD  SD                                                                            CFT051
     I                                  1 1248  DWEL                                          CFT051
      *
      ** PLoader = 3 : Input Files Formats
      *
     IMEDWSIPD  SI
     I                                  1 1248  DWSI
      *
      ** PLoader = 4 : Input Files Formats
      *
     IMEDWSPPD  SP
     I                                  1 1248  DWSP
      *                                                                                       CSW218
      ** PLoader = 5 : Input File Format                                                      CSW218
      *                                                                                       CSW218
     IMEDWFIPD  SP                                                                            CSW218
     I                                  1 1248  DWFI                                          CSW218
      /EJECT
      *****************************************************************
      *                                                               *
      *                   Index to subroutines                        *
      *  Main routine                                                 *
      *  SRINIT  -  Initial processing                                *
      *  SRDETL  -  Detail processing                                 *
      *  SRCONV  -  Convert ASCII record to EBCDIC                    *
      *  SRMOVE  -  Move data into arrays of fields                   *
      *  Loader1 -  Run BANK DIRECTORY Plus                           *
      *  SRDWB3  -  BANK DIRECTORY Plus Mapping - BANK V3 File        *
      *  SRDWCT  -  BANK DIRECTORY Plus Mapping - Country File        *
      *  SRDWCU  -  BANK DIRECTORY Plus Mapping - Currency File       *
      *  SRDWHL  -  BANK DIRECTORY Plus Mapping - Holiday File        *
      *  SRDWTZ  -  BANK DIRECTORY Plus Mapping - Timezone File       *
      *  SRDWSD  -  BANK DIRECTORY Plus Mapping - Service Directory   *                       CFT051
      *  SRDWLL  -  BANK DIRECTORY Plus Mapping - Local Language      *                       CFT051
      *  WriteB3 -  Write BANK DIRECTORY Plus Records (METIB3PD)      *
      *  WriteCT -  Write Country Records (METICCPD)                  *
      *  WriteCU -  Write Currency Records (METICUPD)                 *
      *  WriteHL -  Write Holiday Records (METIHLPD)                  *
      *  WriteTZ -  Write Timezone Records (METITZPD)                 *
      *  WriteSD -  Write Service Directory Records (METISDPD)        *                       CFT051
      *  WriteLL -  Write Local Language Records (METILLPD)           *                       CFT051
      *  Loader2 -  Run IBAN Plus DIRECTORY                           *
      *  SRDWIB  -  IBAN Plus DIRECTORY Mapping                       *
      *  SRDWIS  -  IBAN Plus DIRECTORY Mapping / structure           *
      *  SRDWEL  -  IBAN Plus DIRECTORY Mapping - Exclusion List      *                       CFT051
      *  WriteIB -  Write record to IBAN Plus                         *
      *  WriteIS -  Write record to IBAN Plus / Structure             *
      *  WriteEL -  Write Exclusion List Records (METIELPD)           *                       CFT051
      *  Loader3 - Run SSI Plus                                       *
      *  SRDWSI  - SSI Plus Mapping                                   *
      *  WriteSI -  Write record to SSI Plus                          *
      *  Loader4 - Run SEPA Plus                                      *
      *  SRDWSP  - SEPA Plus Mapping                                  *
      *  WriteSP -  Write record to SEPA Plus                         *
      *  SREND   -  End program                                       *
      *  *PSSR   -  Error handling subroutine                         *
      *                                                               *
      *****************************************************************
      *
      ** Main Program
      *
      *
      ** Perform initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Perform different detailed processing
      *
     C                   EXSR      SRDETL
      *
      ** Terminate program
      *
     C                   EXSR      SREND
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT  -  Initial Processing                                *
      *  Called by: Main routine                                      *
      *  Calls    : AOBANKR0 - Access Bank Details                    *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'ME001462'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBTXT = *BLANKS
     C                   EVAL      DBASE = 0
     C                   OUT       LDA
      *
      ** Retrieve bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST  '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CFT051
      *                                                                                       CFT051
      ** Check if CFT051 is ON                                                                CFT051
      *                                                                                       CFT051
     C                   CALL      'AOSARDR0'                                                 CFT051
     C                   PARM      *BLANKS       @RTCD                                        CFT051
     C                   PARM      '*VERIFY '    @OPTN                                        CFT051
     C                   PARM      'CFT051'      @SARD                                        CFT051
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT051
      *                                                                                       CFT051
     C     @RTCD         IFNE      *BLANKS                                                    CFT051
     C     @RTCD         ANDNE     '*NRF'                                                     CFT051
     C     *LOCK         IN        LDA                                                        CFT051
     C                   Z-ADD     23            DBASE                                        CFT051
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT051
     C                   EVAL      DBKEY = '*VERIFY '                                         CFT051
     C                   OUT       LDA                                                        CFT051
     C                   EXSR      *PSSR                                                      CFT051
     C                   ENDIF                                                                CFT051
      *                                                                                       CFT051
     C     @RTCD         IFEQ      *BLANKS                                                    CFT051
     C                   MOVE      'Y'           CFT051                                       CFT051
     C                   ELSE                                                                 CFT051
     C                   MOVE      'N'           CFT051                                       CFT051
     C                   ENDIF                                                                CFT051
      *                                                                                       CFT051
      *
      ** Initialise work fields and indicators
      *
     C                   EVAL      W1DATA = *BLANKS
     C                   EVAL      W1CONV = *BLANKS
     C                   EVAL      *IN98  = *OFF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDETL  -  Detail Processing                                 *
      *  Called by: Main routine                                      *
      *  Calls    : Loader1, Loader2, Loader3, Loader4                *
      *                                                               *
      *****************************************************************
      *
     C     SRDETL        BEGSR
      *
      **  PLoader indicates the SWIFTRef Loader Started
      **  PLoader = 1 then BANK DIRECTORY Plus Loader
      **  PLoader = 2 then IBAN PLus DIRECTORY Loader
      **  PLoader = 3 then SSI Plus Loader
      **  PLoader = 4 then SEPA Plus Loader
      *
     C                   SELECT
     C     PLoader       WHENEQ    '1'
     C                   EXSR      Loader1
     C     PLoader       WHENEQ    '2'
     C                   EXSR      Loader2
     C     PLoader       WHENEQ    '3'
     C                   EXSR      Loader3
     C     PLoader       WHENEQ    '4'
     C                   EXSR      Loader4
     C     PLoader       WHENEQ    '5'                                                        CSW218
     C                   EXSR      Loader5                                                    CSW218
     C                   ENDSL
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Loader1 -  BANK DIRECTORY Plus Mapping                       *
      *  Called by: SRDETL Routine                                    *
      *  Calls    : SRDWB3, SRDWCT, SRDWCU, SRDWHL, SRDWTZ            *
      *                                                               *
      *****************************************************************
      *
     C     Loader1       BEGSR
      *
      ** Mandatory MEDWB3PD
      *
     C                   EXSR      SRDWB3
      *
      ** Mandatory MEDWCTPD
      *
     C                   EXSR      SRDWCT
      *
      ** Optional MEDWCUPD
      *
     C                   EXSR      SRDWCU
      *
      ** Optional MEDWHLPD
      *
     C                   EXSR      SRDWHL
      *
      ** Optional MEDWTZPD
      *
     C                   EXSR      SRDWTZ
      *
                                                                                              CFT051
     C                   IF        CFT051 = 'Y'                                               CFT051
      *                                                                                       CFT051
      ** Optional MEDWSDPD                                                                    CFT051
      *                                                                                       CFT051
     C                   EXSR      SRDWSD                                                     CFT051
      *                                                                                       CFT051
      ** Optional MEDWLLPD                                                                    CFT051
      *                                                                                       CFT051
     C                   EXSR      SRDWLL                                                     CFT051
      *                                                                                       CFT051
     C                   ENDIF                                                                CFT051
                                                                                              CFT051
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Loader2 -  IBAN Plus DIRECTORY Mapping                       *
      *  Called by: SRDETL                                            *
      *  Calls    : SRCONV, SRMOVE                                    *
      *                                                               *
      *****************************************************************
      *
     C     Loader2       BEGSR
      *
      ** Mandatory MEDWIBPD
      *
     C                   EXSR      SRDWIB
      *
      ** Mandatory MEDWISPD
      *
     C                   EXSR      SRDWIS
      *
      *                                                                                       CFT051
     C                   IF        CFT051 = 'Y'                                               CFT051
      *                                                                                       CFT051
      ** Optional MEDWELPD                                                                    CFT051
      *                                                                                       CFT051
     C                   EXSR      SRDWEL                                                     CFT051
      *                                                                                       CFT051
     C                   ENDIF                                                                CFT051
      *                                                                                       CFT051
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Loader3 -  SSI Plus Mapping                                  *
      *  Called by: SRDETL                                            *
      *  Calls    : SRCONV, SRMOVE                                    *
      *                                                               *
      *****************************************************************
      *
     C     Loader3       BEGSR
      *
      ** Treat file by file : Mandatory MEDWSIPD
      *
     C                   EXSR      SRDWSI
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Loader4 -  SEPA Plus Mapping                                 *
      *  Called by: SRDETL                                            *
      *  Calls    : SRCONV, SRMOVE                                    *
      *                                                               *
      *****************************************************************
      *
     C     Loader4       BEGSR
      *
      ***  treat file by file : Mandatory MEDWSPPD
      *
     C                   EXSR      SRDWSP
      *
     C                   ENDSR
      
      *
      /EJECT                                                                                  CSW218
      *****************************************************************                       CSW218
      *                                                               *                       CSW218
      *  Loader5 -  BIC Database 2018 Mapping                         *                       CSW218
      *  Called by: SRDETL                                            *                       CSW218
      *  Calls    : SRCONV, SRMOVE                                    *                       CSW218
      *                                                               *                       CSW218
      *****************************************************************                       CSW218
      *                                                                                       CSW218
     C     Loader5       BEGSR                                                                CSW218
      *                                                                                       CSW218
      ***  treat file by file : Mandatory MEDWFIPD                                            CSW218
      *                                                                                       CSW218
     C                   EXSR      SRDWFI                                                     CSW218
      *                                                                                       CSW218
     C                   ENDSR                                                                CSW218
      *                                                                                       CSW218
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDWB3 - BANK DIRECTORY Plus Mapping - BANK V3 File          *
      *  Called by: Loader1                                           *
      *  Calls    : SRCONV, SRMOVE                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRDWB3        BEGSR
      *
      ** Mandatory MEDWB3PD
      *
     C                   OPEN      MEDWB3PD                             99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'MEDWB3PD'
     C                   EVAL      DBKEY = 'OPEN    '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   OPEN      METIB3PD                             99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'METIB3PD'
     C                   EVAL      DBKEY = 'OPEN    '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   READ      MEDWB3PD                               71
      *
     C     *IN71         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'MEDWB3PD'
     C                   EVAL      DBKEY = 'EMPTY   '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Convert in EBCDIC and write in METIB3PD each formatted records
      *
     C                   EVAL      MOVE_IN = 'B3'
      *
     C                   EVAL      LEFT = *BLANKS
     C     *IN71         DOWEQ     '0'
     C                   EVAL      W1DATA = *BLANKS
     C                   EVAL      W1DATA = DWB3
     C                   EVAL      W1CONV = *BLANKS
     C                   EXSR      SRCONV
     C                   EXSR      SRMOVE
      *
      ** Read next until EOF
      *
     C                   READ      MEDWB3PD                               71
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDWCT - BANK DIRECTORY Plus Mapping - Country File          *
      *  Called by: Loader1                                           *
      *  Calls    : SRCONV, SRMOVE                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRDWCT        BEGSR
      *
      ** Mandatory MEDWCTPD
      *
     C                   OPEN      MEDWCTPD                             99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'MEDWCTPD'
     C                   EVAL      DBKEY = 'OPEN    '
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      METICCPD                             99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = 'METICCPD'
     C                   EVAL      DBKEY = 'OPEN    '
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      MEDWCTPD                               71
      *
     C     *IN71         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 7
     C                   EVAL      DBFILE = 'MEDWCTPD'
     C                   EVAL      DBKEY = 'EMPTY   '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Convert in EBCDIC and write in METICTPD each formatted records
      *
     C                   EVAL      MOVE_IN = 'CT'
      *
     C                   EVAL      LEFT = *BLANKS
     C     *IN71         DOWEQ     '0'
     C                   EVAL      W1DATA = *BLANKS
     C                   EVAL      W1DATA = DWCT
     C                   EVAL      W1CONV = *BLANKS
     C                   EXSR      SRCONV
     C                   EXSR      SRMOVE
      *
      ** Read next until EOF
      *
     C                   READ      MEDWCTPD                               71
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDWCU - BANK DIRECTORY Plus Mapping - Currency File         *
      *  Called by: Loader1                                           *
      *  Calls    : SRCONV, SRMOVE                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRDWCU        BEGSR
      *
      ** Optional MEDWCUPD
      *
     C                   OPEN      MEDWCUPD                             99
     C     *IN99         IFEQ      '1'
 
      ** No File/No Data - Ignore
 
     C                   ELSE
     C                   OPEN      METICUPD                             99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 8
     C                   EVAL      DBFILE = 'METICUPD'
     C                   EVAL      DBKEY = 'OPEN    '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      MEDWCUPD                               71
      *
     C     *IN71         IFEQ      '1'
 
      ** No File/No Data - Ignore
 
     C                   ELSE
      *
      ** Convert in EBCDIC and write in METICUPD each formatted records
      *
     C                   EVAL      MOVE_IN = 'CU'
      *
     C                   EVAL      LEFT = *BLANKS
     C     *IN71         DOWEQ     '0'
     C                   EVAL      W1DATA = *BLANKS
     C                   EVAL      W1DATA = DWCU
     C                   EVAL      W1CONV = *BLANKS
     C                   EXSR      SRCONV
     C                   EXSR      SRMOVE
      *
      ** Read next until EOF
      *
     C                   READ      MEDWCUPD                               71
     C                   ENDDO
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDWHL - BANK DIRECTORY Plus Mapping - Holiday File          *
      *  Called by: Loader1                                           *
      *  Calls    : SRCONV, SRMOVE                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRDWHL        BEGSR
      *
      ** Optional MEDWHLPD
      *
     C                   OPEN      MEDWHLPD                             99
     C     *IN99         IFEQ      '1'
 
      ** No File/No Data - Ignore
 
     C                   ELSE
     C                   OPEN      METIHLPD                             99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 9
     C                   EVAL      DBFILE = 'METIHLPD'
     C                   EVAL      DBKEY = 'OPEN    '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      MEDWHLPD                               71
      *
     C     *IN71         IFEQ      '1'
 
      ** No File/No Data - Ignore
 
     C                   ELSE
      *
      **  Convert in EBCDIC and write in METIHLPD each formatted records
      *
     C                   EVAL      MOVE_IN = 'HL'
      *
     C                   EVAL      LEFT = *BLANKS
     C     *IN71         DOWEQ     '0'
     C                   EVAL      W1DATA = *BLANKS
     C                   EVAL      W1DATA = DWHL
     C                   EVAL      W1CONV = *BLANKS
     C                   EXSR      SRCONV
     C                   EXSR      SRMOVE
      *
      ** Read next until EOF
      *
     C                   READ      MEDWHLPD                               71
     C                   ENDDO
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDWTZ - BANK DIRECTORY Plus Mapping - Timezone File         *
      *  Called by: Loader1                                           *
      *  Calls    : SRCONV, SRMOVE                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRDWTZ        BEGSR
      *
      ** Optional MEDWTZPD
      *
     C                   OPEN      MEDWTZPD                             99
     C     *IN99         IFEQ      '1'
 
      ** No File/No Data - Ignore
 
     C                   ELSE
     C                   OPEN      METITZPD                             99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 10
     C                   EVAL      DBFILE = 'METITZPD'
     C                   EVAL      DBKEY = 'OPEN    '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      MEDWTZPD                               71
      *
     C     *IN71         IFEQ      '1'
 
      ** No File/No Data - ignore
 
     C                   Else
      *
      ** Convert in EBCDIC and write in METITZPD each formatted records
      *
     C                   EVAL      MOVE_IN = 'TZ'
      *
     C                   EVAL      LEFT = *BLANKS
     C     *IN71         DOWEQ     '0'
     C                   EVAL      W1DATA = *BLANKS
     C                   EVAL      W1DATA = DWTZ
     C                   EVAL      W1CONV = *BLANKS
     C                   EXSR      SRCONV
     C                   EXSR      SRMOVE
      *
      ** Read next until EOF
      *
     C                   READ      MEDWTZPD                               71
     C                   ENDDO
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *                                                                                       CFT051
      /EJECT                                                                                  CFT051
      *****************************************************************                       CFT051
      *                                                               *                       CFT051
      *  SRDWSD - SWIFTRef Service Directory File                     *                       CFT051
      *  Called by: Loader1                                           *                       CFT051
      *  Calls    : SRCONV, SRMOVE                                    *                       CFT051
      *                                                               *                       CFT051
      *****************************************************************                       CFT051
      *                                                                                       CFT051
     C     SRDWSD        BEGSR                                                                CFT051
      *                                                                                       CFT051
      ** Optional MEDWSDPD                                                                    CFT051
      *                                                                                       CFT051
     C                   OPEN      MEDWSDPD                             99                    CFT051
     C     *IN99         IFEQ      '1'                                                        CFT051
                                                                                              CFT051
      ** No File/No Data - Ignore                                                             CFT051
                                                                                              CFT051
     C                   ELSE                                                                 CFT051
     C                   OPEN      METISDPD                             99                    CFT051
     C     *IN99         IFEQ      '1'                                                        CFT051
     C     *LOCK         IN        LDA                                                        CFT051
     C                   EVAL      DBASE = 23                                                 CFT051
     C                   EVAL      DBFILE = 'METISDPD'                                        CFT051
     C                   EVAL      DBKEY = 'OPEN    '                                         CFT051
     C                   OUT       LDA                                                        CFT051
     C                   EXSR      *PSSR                                                      CFT051
     C                   ENDIF                                                                CFT051
      *                                                                                       CFT051
     C                   READ      MEDWSDPD                               71                  CFT051
      *                                                                                       CFT051
     C     *IN71         IFEQ      '1'                                                        CFT051
                                                                                              CFT051
      ** No File/No Data - Ignore                                                             CFT051
                                                                                              CFT051
     C                   ELSE                                                                 CFT051
      *                                                                                       CFT051
      ** Convert in EBCDIC and write in METISDPD each formatted records                       CFT051
      *                                                                                       CFT051
     C                   EVAL      MOVE_IN = 'SD'                                             CFT051
      *                                                                                       CFT051
     C                   EVAL      LEFT = *BLANKS                                             CFT051
     C     *IN71         DOWEQ     '0'                                                        CFT051
     C                   EVAL      W1DATA = *BLANKS                                           CFT051
     C                   EVAL      W1DATA = DWSD                                              CFT051
     C                   EVAL      W1CONV = *BLANKS                                           CFT051
     C                   EXSR      SRCONV                                                     CFT051
     C                   EXSR      SRMOVE                                                     CFT051
      *                                                                                       CFT051
      ** Read next until EOF                                                                  CFT051
      *                                                                                       CFT051
     C                   READ      MEDWSDPD                               71                  CFT051
     C                   ENDDO                                                                CFT051
      *                                                                                       CFT051
     C                   ENDIF                                                                CFT051
     C                   ENDIF                                                                CFT051
      *                                                                                       CFT051
     C                   ENDSR                                                                CFT051
      *                                                                                       CFT051
      *                                                                                       CFT051
      /EJECT                                                                                  CFT051
      *****************************************************************                       CFT051
      *                                                               *                       CFT051
      *  SRDWLL - SWIFTRef Local Language File                        *                       CFT051
      *  Called by: Loader1                                           *                       CFT051
      *  Calls    : SRCONV, SRMOVE                                    *                       CFT051
      *                                                               *                       CFT051
      *****************************************************************                       CFT051
      *                                                                                       CFT051
     C     SRDWLL        BEGSR                                                                CFT051
      *                                                                                       CFT051
      ** Optional MEDWLLPD                                                                    CFT051
      *                                                                                       CFT051
     C                   OPEN      MEDWLLPD                             99                    CFT051
     C     *IN99         IFEQ      '1'                                                        CFT051
                                                                                              CFT051
      ** No File/No Data - Ignore                                                             CFT051
                                                                                              CFT051
     C                   ELSE                                                                 CFT051
     C                   OPEN      METILLPD                             99                    CFT051
     C     *IN99         IFEQ      '1'                                                        CFT051
     C     *LOCK         IN        LDA                                                        CFT051
     C                   EVAL      DBASE = 24                                                 CFT051
     C                   EVAL      DBFILE = 'METILLPD'                                        CFT051
     C                   EVAL      DBKEY = 'OPEN    '                                         CFT051
     C                   OUT       LDA                                                        CFT051
     C                   EXSR      *PSSR                                                      CFT051
     C                   ENDIF                                                                CFT051
      *                                                                                       CFT051
     C                   READ      MEDWLLPD                               71                  CFT051
      *                                                                                       CFT051
     C     *IN71         IFEQ      '1'                                                        CFT051
                                                                                              CFT051
      ** No File/No Data - Ignore                                                             CFT051
                                                                                              CFT051
     C                   ELSE                                                                 CFT051
      *                                                                                       CFT051
      ** Convert in EBCDIC and write in METILLPD each formatted records                       CFT051
      *                                                                                       CFT051
     C                   EVAL      MOVE_IN = 'LL'                                             CFT051
      *                                                                                       CFT051
     C                   EVAL      LEFT = *BLANKS                                             CFT051
     C     *IN71         DOWEQ     '0'                                                        CFT051
     C                   EVAL      W1DATA = *BLANKS                                           CFT051
     C                   EVAL      W1DATA = DWLL                                              CFT051
     C                   EVAL      W1CONV = *BLANKS                                           CFT051
     C                   EXSR      SRCONV                                                     CFT051
     C                   EXSR      SRMOVE                                                     CFT051
      *                                                                                       CFT051
      ** Read next until EOF                                                                  CFT051
      *                                                                                       CFT051
     C                   READ      MEDWLLPD                               71                  CFT051
     C                   ENDDO                                                                CFT051
      *                                                                                       CFT051
     C                   ENDIF                                                                CFT051
     C                   ENDIF                                                                CFT051
      *                                                                                       CFT051
     C                   ENDSR                                                                CFT051
      *                                                                                       CFT051
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDWIB - IBAN Plus DIRECTORY Mapping                         *
      *  Called by: Loader2                                           *
      *  Calls    : SRCONV, SRMOVE                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRDWIB        BEGSR
      *
      ** Mandatory MEDWIBPD
      *
     C                   OPEN      MEDWIBPD                             99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 11
     C                   EVAL      DBFILE = 'MEDWIBPD'
     C                   EVAL      DBKEY = 'OPEN    '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      METIIBPD                             99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 12
     C                   EVAL      DBFILE = 'METIIBPD'
     C                   EVAL      DBKEY = 'OPEN    '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      MEDWIBPD                               71
      *
     C     *IN71         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 13
     C                   EVAL      DBFILE = 'MEDWIBPD'
     C                   EVAL      DBKEY = 'EMPTY   '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Convert in EBCDIC and write in METIIBPD each formatted records
      *
     C                   EVAL      MOVE_IN = 'IB'
      *
     C                   EVAL      LEFT = *BLANKS
     C     *IN71         DOWEQ     '0'
     C                   EVAL      W1DATA = *BLANKS
     C                   EVAL      W1DATA = DWIB
     C                   EVAL      W1CONV = *BLANKS
     C                   EXSR      SRCONV
     C                   EXSR      SRMOVE
      *
      ** Read next until EOF
      *
     C                   READ      MEDWIBPD                               71
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDWIS - IBAN Plus DIRECTORY Mapping / structure             *
      *  Called by: Loader2                                           *
      *  Calls    : SRCONV, SRMOVE                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRDWIS        BEGSR
      *
      ** Mandatory MEDWISPD
      *
     C                   OPEN      MEDWISPD                             99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 14
     C                   EVAL      DBFILE = 'MEDWISPD'
     C                   EVAL      DBKEY = 'OPEN    '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      METIISPD                             99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 15
     C                   EVAL      DBFILE = 'METIISPD'
     C                   EVAL      DBKEY = 'OPEN    '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      MEDWISPD                               71
      *
     C     *IN71         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 16
     C                   EVAL      DBFILE = 'MEDWISPD'
     C                   EVAL      DBKEY = 'EMPTY   '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Convert in EBCDIC and write in METIISPD each formatted records
      *
     C                   EVAL      MOVE_IN = 'IS'
      *
     C                   EVAL      LEFT = *BLANKS
     C     *IN71         DOWEQ     '0'
     C                   EVAL      W1DATA = *BLANKS
     C                   EVAL      W1DATA = DWIS
     C                   EVAL      W1CONV = *BLANKS
     C                   EXSR      SRCONV
     C                   EXSR      SRMOVE
      *
      ** Read next until EOF
      *
     C                   READ      MEDWISPD                               71
     C                   ENDDO
      *
     C                   ENDSR
      *                                                                                       CFT051
      /EJECT                                                                                  CFT051
      *****************************************************************                       CFT051
      *                                                               *                       CFT051
      *  SRDWEL - SWIFTRef Exclusion List File                        *                       CFT051
      *  Called by: Loader2                                           *                       CFT051
      *  Calls    : SRCONV, SRMOVE                                    *                       CFT051
      *                                                               *                       CFT051
      *****************************************************************                       CFT051
      *                                                                                       CFT051
     C     SRDWEL        BEGSR                                                                CFT051
      *                                                                                       CFT051
      ** Optional MEDWELPD                                                                    CFT051
      *                                                                                       CFT051
     C                   OPEN      MEDWELPD                             99                    CFT051
     C     *IN99         IFEQ      '1'                                                        CFT051
                                                                                              CFT051
      ** No File/No Data - Ignore                                                             CFT051
                                                                                              CFT051
     C                   ELSE                                                                 CFT051
     C                   OPEN      METIELPD                             99                    CFT051
     C     *IN99         IFEQ      '1'                                                        CFT051
     C     *LOCK         IN        LDA                                                        CFT051
     C                   EVAL      DBASE = 25                                                 CFT051
     C                   EVAL      DBFILE = 'METIELPD'                                        CFT051
     C                   EVAL      DBKEY = 'OPEN    '                                         CFT051
     C                   OUT       LDA                                                        CFT051
     C                   EXSR      *PSSR                                                      CFT051
     C                   ENDIF                                                                CFT051
      *                                                                                       CFT051
     C                   READ      MEDWELPD                               71                  CFT051
      *                                                                                       CFT051
     C     *IN71         IFEQ      '1'                                                        CFT051
                                                                                              CFT051
      ** No File/No Data - Ignore                                                             CFT051
                                                                                              CFT051
     C                   ELSE                                                                 CFT051
      *                                                                                       CFT051
      ** Convert in EBCDIC and write in METIELPD each formatted records                       CFT051
      *                                                                                       CFT051
     C                   EVAL      MOVE_IN = 'EL'                                             CFT051
      *                                                                                       CFT051
     C                   EVAL      LEFT = *BLANKS                                             CFT051
     C     *IN71         DOWEQ     '0'                                                        CFT051
     C                   EVAL      W1DATA = *BLANKS                                           CFT051
     C                   EVAL      W1DATA = DWEL                                              CFT051
     C                   EVAL      W1CONV = *BLANKS                                           CFT051
     C                   EXSR      SRCONV                                                     CFT051
     C                   EXSR      SRMOVE                                                     CFT051
      *                                                                                       CFT051
      ** Read next until EOF                                                                  CFT051
      *                                                                                       CFT051
     C                   READ      MEDWELPD                               71                  CFT051
     C                   ENDDO                                                                CFT051
      *                                                                                       CFT051
     C                   ENDIF                                                                CFT051
     C                   ENDIF                                                                CFT051
      *                                                                                       CFT051
     C                   ENDSR                                                                CFT051
      *                                                                                       CFT051
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDWSI - SSI Plus Mapping                                    *
      *  Called by: Loader3                                           *
      *  Calls    : SRCONV, SRMOVE                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRDWSI        BEGSR
      *
      ** Mandatory MEDWSIPD
      *
     C                   OPEN      MEDWSIPD                             99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 17
     C                   EVAL      DBFILE = 'MEDWSIPD'
     C                   EVAL      DBKEY = 'OPEN    '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      METSSIPD                             99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 18
     C                   EVAL      DBFILE = 'METSSIPD'
     C                   EVAL      DBKEY = 'OPEN    '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      MEDWSIPD                               71
      *
     C     *IN71         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 19
     C                   EVAL      DBFILE = 'MEDWSIPD'
     C                   EVAL      DBKEY = 'EMPTY   '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Convert in EBCDIC and write in METSSIPD each formatted records
      *
     C                   EVAL      MOVE_IN = 'SI'
      *
     C                   EVAL      LEFT = *BLANKS
     C     *IN71         DOWEQ     '0'
     C                   EVAL      W1DATA = *BLANKS
     C                   EVAL      W1DATA = DWSI
     C                   EVAL      W1CONV = *BLANKS
     C                   EXSR      SRCONV
     C                   EXSR      SRMOVE
      *
      ** Read next until EOF
      *
     C                   READ      MEDWSIPD                               71
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDWSP - SEPA Plus Mapping                                   *
      *  Called by: Loader3                                           *
      *  Calls    : SRCONV, SRMOVE                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRDWSP        BEGSR
      *
      ** Treat file by file : Mandatory MEDWSPPD
      *
     C                   OPEN      MEDWSPPD                             99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 20
     C                   EVAL      DBFILE = 'MEDWSPPD'
     C                   EVAL      DBKEY = 'OPEN    '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      METSEPPD                             99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 21
     C                   EVAL      DBFILE = 'METSEPPD'
     C                   EVAL      DBKEY = 'OPEN    '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      MEDWSPPD                               71
      *
     C     *IN71         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 22
     C                   EVAL      DBFILE = 'MEDWSPPD'
     C                   EVAL      DBKEY = 'EMPTY   '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Convert in EBCDIC and write in METSEPPD each formatted records
      *
     C                   EVAL      MOVE_IN = 'SP'
      *
     C                   EVAL      LEFT = *BLANKS
     C     *IN71         DOWEQ     '0'
     C                   EVAL      W1DATA = *BLANKS
     C                   EVAL      W1DATA = DWSP
     C                   EVAL      W1CONV = *BLANKS
     C                   EXSR      SRCONV
     C                   EXSR      SRMOVE
      *
      ** Read next until EOF
      *
     C                   READ      MEDWSPPD                               71
     C                   ENDDO
      *
     C                   ENDSR
      *                                                                                       CSW218
      /EJECT                                                                                  CSW218
      *****************************************************************                       CSW218
      *                                                               *                       CSW218
      *  SRDWFI - BIC Database 2018 Mapping                           *                       CSW218
      *  Called by: Loader5                                           *                       CSW218
      *  Calls    : SRCONV, SRMOVE                                    *                       CSW218
      *                                                               *                       CSW218
      *****************************************************************                       CSW218
      *                                                                                       CSW218
     C     SRDWFI        BEGSR                                                                CSW218
      *                                                                                       CSW218
      ** Treat file by file : Mandatory MEDWFIPD                                              CSW218
      *                                                                                       CSW218
     C                   OPEN      MEDWFIPD                             99                    CSW218
     C     *IN99         IFEQ      '1'                                                        CSW218
     C     *LOCK         IN        LDA                                                        CSW218
     C                   EVAL      DBASE = 26                                                 CSW218
     C                   EVAL      DBFILE = 'MEDWFIPD'                                        CSW218
     C                   EVAL      DBKEY = 'OPEN    '                                         CSW218
     C                   OUT       LDA                                                        CSW218
     C                   EXSR      *PSSR                                                      CSW218
     C                   ENDIF                                                                CSW218
      *                                                                                       CSW218
     C                   OPEN      METIFIPD                             99                    CSW218
     C     *IN99         IFEQ      '1'                                                        CSW218
     C     *LOCK         IN        LDA                                                        CSW218
     C                   EVAL      DBASE = 27                                                 CSW218
     C                   EVAL      DBFILE = 'METIFIPD'                                        CSW218
     C                   EVAL      DBKEY = 'OPEN    '                                         CSW218
     C                   OUT       LDA                                                        CSW218
     C                   EXSR      *PSSR                                                      CSW218
     C                   ENDIF                                                                CSW218
      *                                                                                       CSW218
     C                   READ      MEDWFIPD                               71                  CSW218
      *                                                                                       CSW218
     C     *IN71         IFEQ      '1'                                                        CSW218
     C     *LOCK         IN        LDA                                                        CSW218
     C                   EVAL      DBASE = 28                                                 CSW218
     C                   EVAL      DBFILE = 'MEDWFIPD'                                        CSW218
     C                   EVAL      DBKEY = 'EMPTY   '                                         CSW218
     C                   OUT       LDA                                                        CSW218
     C                   EXSR      *PSSR                                                      CSW218
     C                   ENDIF                                                                CSW218
      *                                                                                       CSW218
      ** Convert in EBCDIC and write in METIFIPD each formatted records                       CSW218
      *                                                                                       CSW218
     C                   EVAL      MOVE_IN = 'FI'                                             CSW218
      *                                                                                       CSW218
     C                   EVAL      LEFT = *BLANKS                                             CSW218
     C     *IN71         DOWEQ     '0'                                                        CSW218
     C                   EVAL      W1DATA = *BLANKS                                           CSW218
     C                   EVAL      W1DATA = DWFI                                              CSW218
     C                   EVAL      W1CONV = *BLANKS                                           CSW218
     C                   EXSR      SRCONV                                                     CSW218
     C                   EXSR      SRMOVE                                                     CSW218
      *                                                                                       CSW218
      ** Read next until EOF                                                                  CSW218
      *                                                                                       CSW218
     C                   READ      MEDWFIPD                               71                  CSW218
     C                   ENDDO                                                                CSW218
      *                                                                                       CSW218
     C                   ENDSR                                                                CSW218
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCONV  -  Convert ASCII record to EBCDIC                    *
      *  Called by: SRDWxx routines                                   *
      *  Calls    : QDCXLATE - Standard program to convert ASCII      *
      *                        to EBCDIC                              *
      *                                                               *
      *****************************************************************
      *
     C     SRCONV        BEGSR
      *
      ** Call standard QDCXLATE to convert IAT from ASCII to EBCDIC
      *
     C                   CALL      'QDCXLATE'
      *
     C                   PARM      1248          P1LEN
     C                   PARM      W1DATA        P1DTA
     C                   PARM      'QTCPEBC'     P1TAB
     C                   PARM      'QUSRSYS'     P1LIB
      *
      ** Set converted EBCDIC IAT Data
      *
     C                   MOVEL     P1DTA         W1CONV
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMOVE  -  Move data into arrays                             *
      *  Called by: SRDWxx Routines                                   *
      *  Calls    : WriteXX Routines                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRMOVE        BEGSR
      *
     C                   Z-ADD     0             ENDPOS
     C                   Z-ADD     1             E
     C                   Z-ADD     1             F
     C                   MOVEA     *BLANKS       ARRAY
     C                   MOVEA     W1CONV        ARRAY
      *
      ** Look up CRLF in the converted data = End of the Record unformatted
      *
     C     CR            LOOKUP    ARRAY(E)                               50
     C     E             ADD       1             F
      *
      **  Remaining characters not yet part of a written record
      *
     C     LEFT(1)       IFNE      *BLANKS
     C     LEFT(2)       ANDNE     *BLANKS
     C     ARRAY(1)      ANDEQ     LF
     C                   Z-ADD     1             E
     C                   Z-ADD     1             F
     C                   ENDIF
      *
      **  Put Left Characters in RECORD array for analysis
      *
     C     *IN50         DOWEQ     '1'
     C     F             ANDLE     1248
     C     LF            ANDEQ     ARRAY(F)
     C
     C                   MOVEA     *BLANKS       RECORD
     C                   Z-ADD     1             J
     C     LEFT(1)       IFNE      *BLANKS
     C     LEFT(2)       ORNE      *BLANKS
     C                   Z-ADD     1             I
     C     I             DOWLE     LEN
     C                   MOVEA     LEFT(I)       RECORD(J)
     C                   ADD       1             I
     C                   ADD       1             J
     C                   ENDDO
     C                   MOVEA     *BLANKS       LEFT
     C                   ENDIF
      *
      **  Add ARRAY Elements in the RECORD array (to complete DATA of the RECORD)
      *
     C     1             ADD       ENDPOS        I
     C     I             DOWLT     E
     C                   MOVE      ARRAY(I)      RECORD(J)
     C                   ADD       1             I
     C                   ADD       1             J
     C                   ENDDO
     C                   Z-ADD     F             ENDPOS
     C                   Z-ADD     0             TABPOS
      *
      **  Field Separator is a ¢Tab! in the converted data
      *
     C                   Z-ADD     1             T
     C                   Z-ADD     1             D
     C     TB            LOOKUP    RECORD(T)                              51
     C     *IN51         DOWEQ     '1'
     C     1             ADD       TABPOS        I
     C                   Z-ADD     1             J
     C                   MOVEA     *BLANKS       FIELD
     C     I             DOWLT     T
     C                   MOVE      RECORD(I)     FIELD(J)
     C                   ADD       1             I
     C                   ADD       1             J
     C                   ENDDO
      *
      **  Store Each data Content in DATA DS  (Max 250 fields per records)
      *
     C                   MOVEA     FIELD         DATA(D)
     C                   ADD       1             D
     C                   Z-ADD     T             TABPOS
     C                   ADD       1             T
     C     TB            LOOKUP    RECORD(T)                              51
     C                   ENDDO
     C     1             ADD       TABPOS        I
     C                   Z-ADD     1             J
     C                   MOVEA     *BLANKS       FIELD
     C     I             DOWLE     1248
     C                   MOVE      RECORD(I)     FIELD(J)
     C                   ADD       1             I
     C                   ADD       1             J
     C                   ENDDO
     C                   MOVEA     FIELD         DATA(D)
     C                   ADD       1             D
     C                   ADD       2             E
      *
      **  Ensure that Record Content is meaningful and has to be stored in Interim file
      *
     C                   Eval      WKLIT1 = *BLANKS
     C                   Eval      WKLIT1 = 'MODIFICATION FLAG'
     C     DATA(1)       IFNE      'TAG'
     C     DATA(1)       ANDNE     WKLIT1
     C     DATA(1)       ANDNE     *BLANKS
      *
      **  If yes, then write in appropriate Output file
      *
     C                   SELECT
     C     MOVE_IN       WHENEQ    'B3'
     C                   EXSR      WriteB3
      *
     C     MOVE_IN       WHENEQ    'CT'
     C                   EXSR      WriteCT
      *
     C     MOVE_IN       WHENEQ    'CU'
     C                   EXSR      WriteCU
      *
     C     MOVE_IN       WHENEQ    'HL'
     C                   EXSR      WriteHL
      *
     C     MOVE_IN       WHENEQ    'TZ'
     C                   EXSR      WriteTZ
      *
     C     MOVE_IN       WHENEQ    'IB'
     C                   EXSR      WriteIB
      *
     C     MOVE_IN       WHENEQ    'IS'
     C                   EXSR      WriteIS
      *
     C     MOVE_IN       WHENEQ    'SI'
     C                   EXSR      WriteSI
      *
     C     MOVE_IN       WHENEQ    'SP'
     C                   EXSR      WriteSP
      *
     C     MOVE_IN       WHENEQ    'SD'                                                       CFT051
     C                   EXSR      WriteSD                                                    CFT051
      *                                                                                       CFT051
     C     MOVE_IN       WHENEQ    'LL'                                                       CFT051
     C                   EXSR      WriteLL                                                    CFT051
      *                                                                                       CFT051
     C     MOVE_IN       WHENEQ    'EL'                                                       CFT051
     C                   EXSR      WriteEL                                                    CFT051
      *                                                                                       CFT051
     C     MOVE_IN       WHENEQ    'FI'                                                       CSW218
     C                   EXSR      WriteFI                                                    CSW218
      *                                                                                       CSW218
     C                   ENDSL
      *
     C                   ENDIF
      *
      **  Check if another Record is available in the 1248 Characters read
      *
     C     E             IFLE      1248
     C     CR            LOOKUP    ARRAY(E)                               50
     C                   ELSE
     C                   MOVEL     '0'           *IN50
     C                   ENDIF
     C     E             ADD       1             F
     C                   ENDDO
      *
      **  Position working index
      **  if not CRLF in the record, store untreated character in LEFT Array
      *
     C     1             ADD       ENDPOS        I
     C                   Z-ADD     1             J
     C                   MOVEA     *BLANKS       LEFT
     C     1248          SUB       ENDPOS        LEN
     C     I             DOWLE     1248
     C     ARRAY(I)      IFNE      CR
     C     ARRAY(I)      ANDNE     LF
     C                   MOVE      ARRAY(I)      LEFT(J)
     C                   ENDIF
     C                   ADD       1             I
     C                   ADD       1             J
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WriteB3 -  Write BANK DIRECTORY Plus Records (METIB3PD)      *
      *  Called by: SRMOVE                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WriteB3       BEGSR
      *
     C                   EVAL      B3FLAG = DATA(1)
     C                   EVAL      B3KEY  = DATA(2)
     C                   EVAL      B3OFTP = DATA(3)
     C                   EVAL      B3POKY = DATA(4)
     C                   EVAL      B3HOKY = DATA(5)
     C                   EVAL      B3LGTP = DATA(6)
     C                   EVAL      B3LGPK = DATA(7)
     C                   EVAL      B3GRTP = DATA(8)
     C                   EVAL      B3GPKY = DATA(9)
     C                   EVAL      B3ISST = DATA(10)
     C                   EVAL      B3CGKY = DATA(11)
     C                   EVAL      B3LEIC = DATA(12)
     C                   EVAL      B3BICC = DATA(13)
     C                   EVAL      B3BRCD = DATA(14)
     C                   EVAL      B3UBIC = DATA(15)
     C                   EVAL      B3CHIP = DATA(16)
     C                   EVAL      B3NATI = DATA(17)
     C                   EVAL      B3CBIC = DATA(18)
     C                   EVAL      TMP105 = *BLANKS
     C                   EVAL      TMP105 = DATA(19)
     C                   EVAL      B3INS1 = %SUBST(TMP105:1:35)
     C                   EVAL      B3INS2 = %SUBST(TMP105:36:35)
     C                   EVAL      B3INS3 = %SUBST(TMP105:71:35)
     C                   EVAL      TMP105 = *BLANKS
     C                   EVAL      TMP105 = DATA(20)
     C                   EVAL      B3BIN1 = %SUBST(TMP105:1:35)
     C                   EVAL      B3BIN2 = %SUBST(TMP105:36:35)
     C                   EVAL      B3POBN = DATA(21)
     C                   EVAL      B3ADD1 = DATA(22)
     C                   EVAL      B3ADD2 = DATA(23)
     C                   EVAL      B3ADD3 = DATA(24)
     C                   EVAL      B3ADD4 = DATA(25)
     C                   EVAL      B3CITY = DATA(26)
     C                   EVAL      TMP105 = *BLANKS
     C                   EVAL      TMP105 = DATA(27)
     C                   EVAL      B3CPS1 = %SUBST(TMP105:1:30)
     C                   EVAL      B3CPS2 = %SUBST(TMP105:31:30)
     C                   EVAL      B3CPS3 = %SUBST(TMP105:61:30)
     C                   EVAL      B3ZIP = DATA(28)
     C                   EVAL      TMP105 = *BLANKS
     C                   EVAL      TMP105 = DATA(29)
     C                   EVAL      B3CNT1 = %SUBST(TMP105:1:35)
     C                   EVAL      B3CNT2 = %SUBST(TMP105:36:35)
     C                   EVAL      B3ISOC = DATA(30)
     C                   EVAL      B3TMZN = DATA(31)
     C                   EVAL      B3STYP = DATA(32)
     C                   EVAL      B3NWCY = DATA(33)
     C                   EVAL      B3BRQA = DATA(34)
     C                   EVAL      TMP105 = *BLANKS
     C                   EVAL      TMP105 = DATA(35)
     C                   EVAL      B3SER1 = %SUBST(TMP105:1:30)
     C                   EVAL      B3SER2 = %SUBST(TMP105:31:39)
     C                   EVAL      B3SSIC = DATA(36)
     C                   EVAL      B3IBNK = DATA(37)
     C                   EVAL      B3FILA = DATA(38)
     C                   EVAL      TMP105 = *BLANKS
     C                   EVAL      TMP105 = DATA(39)
     C                   EVAL      B3FLB1 = %SUBST(TMP105:1:35)
     C                   EVAL      B3FLB2 = %SUBST(TMP105:36:35)
      *
     C                   WRITE     MEBIB3D0
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WriteCT -  Write Country Records (METICCPD)                  *
      *  Called by: SRMOVE                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WriteCT       BEGSR
      *
     C                   EVAL      BCTAG  = DATA(1)
     C                   EVAL      BCFLAG = DATA(2)
     C                   EVAL      BCCNTC = DATA(3)
     C                   EVAL      BCCNTY = DATA(4)
 
     C                   WRITE     @BICCPD
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WriteCU -  Write Currency Records (METICUPD)                 *
      *  Called by: SRMOVE                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WriteCU       BEGSR
      *
     C                   EVAL      BUTAG  =  DATA(1)
     C                   EVAL      BUFLAG =  DATA(2)
     C                   EVAL      BUCYCD =  DATA(3)
     C                   EVAL      BUCYDS =  DATA(4)
     C                   MOVEL     DATA(5)       BUNDP
     C                   EVAL      BUCTRY =  DATA(6)
     C                   EVAL      BUCTRD =  DATA(7)
      *
     C                   WRITE     MEBICUD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WriteHL -  Write Holiday Records (METIHLPD)                  *
      *  Called by: SRMOVE                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WriteHL       BEGSR
      *
     C                   EVAL      BHTAG  = DATA(1)
     C                   EVAL      BHFLAG = DATA(2)
     C                   EVAL      BHCNTC = DATA(3)
     C                   EVAL      BHCNTY = DATA(4)
     C                   EVAL      BHHDAT = DATA(5)
     C                   EVAL      BHHTYP = DATA(6)
     C                   EVAL      BHHINF = DATA(7)
      *
     C                   WRITE     MEBIHLD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WriteTZ -  Write Timezone Records (METITZPD)                 *
      *  Called by: SRMOVE                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WriteTZ       BEGSR
      *
     C                   EVAL      BZTAG  = DATA(1)
     C                   EVAL      BZFLAG = DATA(2)
     C                   EVAL      BZCNTC = DATA(3)
     C                   EVAL      BZCNTY = DATA(4)
     C                   EVAL      BZREGN = DATA(5)
     C                   EVAL      BZSDAT = DATA(6)
     C                   EVAL      BZEDAT = DATA(7)
     C                   EVAL      BZHRDF = DATA(8)
      *
     C                   WRITE     MEBITZD0
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WriteIB -  Write IBAN Plus record                            *
      *  Called by: SRMOVE                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WriteIB       BEGSR
      *
     C                   EVAL      N3FLAG =  DATA(1)
     C                   EVAL      N3KEY  =  DATA(2)
     C                   EVAL      TMP105 = *BLANKS
     C                   EVAL      TMP105 = DATA(3)
     C                   EVAL      N3INS1 = %SUBST(TMP105:1:35)
     C                   EVAL      N3INS2 = %SUBST(TMP105:36:35)
     C                   EVAL      N3INS3 = %SUBST(TMP105:71:35)
     C                   EVAL      TMP105 = *BLANKS
     C                   EVAL      TMP105 = DATA(4)
     C                   EVAL      N3CTY1 = %SUBST(TMP105:1:35)
     C                   EVAL      N3CTY2 = %SUBST(TMP105:36:35)
     C                   EVAL      N3ISOC = DATA(5)
     C                   EVAL      N3IBNC = DATA(6)
     C                   EVAL      N3IBIC = DATA(7)
     C                   EVAL      N3RBIC = DATA(8)
     C                   EVAL      N3INAT = DATA(9)
     C                   EVAL      N3SCTX = DATA(10)
     C                   EVAL      N3FLDA = DATA(11)
     C                   EVAL      TMP105 = *BLANKS
     C                   EVAL      TMP105 = DATA(12)
     C                   EVAL      N3FLB1 = %SUBST(TMP105:1:35)
     C                   EVAL      N3FLB2 = %SUBST(TMP105:36:35)
      *
     C                   WRITE     MEIBN3D0
 
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WriteIS -  Write IBAN Structure Record                       *
      *  Called by: SRMOVE                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WriteIS       BEGSR
      *
     C                   EVAL      NSTAG  = DATA(1)
     C                   EVAL      NSFLAG = DATA(2)
     C                   EVAL      NSCCOD = DATA(3)
     C                   EVAL      NSCPOS = DATA(4)
     C                   EVAL      NSCLEN = DATA(5)
     C                   EVAL      NSDPOS = DATA(6)
     C                   EVAL      NSDLEN = DATA(7)
     C                   EVAL      NSBIDP = DATA(8)
     C                   EVAL      NSBIDL = DATA(9)
     C                   EVAL      NSBRCP = DATA(10)
     C                   EVAL      NSBRCL = DATA(11)
     C                   EVAL      NSINAT = DATA(12)
     C                   EVAL      NSACNP = DATA(13)
     C                   EVAL      NSACNL = DATA(14)
     C                   EVAL      NSIBNL = DATA(15)
     C                   EVAL      NSSEPA = DATA(16)
     C                   EVAL      NSODAT = DATA(17)
     C                   EVAL      NSMDAT = DATA(18)
      *
     C                   WRITE     MEIBNSD0
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WriteSI -  Write SSI Plus Record                             *
      *  Called by: SRMOVE                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WriteSI       BEGSR
      *
     C                   EVAL      SIFLAG = DATA(1)
     C                   EVAL      SIKEY  = DATA(2)
     C                   EVAL      SIGKEY = DATA(3)
     C                   EVAL      SIASST = DATA(4)
     C                   EVAL      SIOKEY = DATA(5)
     C                   EVAL      SIOBIC = DATA(6)
     C                   EVAL      SIISOC = DATA(7)
     C                   EVAL      SICORR = DATA(8)
     C                   EVAL      SIACCT = DATA(9)
     C                   EVAL      SIPRFC = DATA(10)
     C                   EVAL      SIITM1 = DATA(11)
     C                   EVAL      SIIAC1 = DATA(12)
     C                   EVAL      SIITM2 = DATA(13)
     C                   EVAL      SIIAC2 = DATA(14)
     C                   EVAL      TMP105 = *BLANKS
     C                   EVAL      TMP105 = DATA(15)
     C                   EVAL      SIINS1 = %SUBST(TMP105:1:35)
     C                   EVAL      SIINS2 = %SUBST(TMP105:36:35)
     C                   EVAL      SIINS3 = %SUBST(TMP105:71:35)
     C                   EVAL      SICITY = DATA(16)
     C                   EVAL      SICPS  = DATA(17)
     C                   EVAL      SICTYN = DATA(18)
     C                   EVAL      SICTYI = DATA(19)
     C                   EVAL      SISTDT = DATA(20)
     C                   EVAL      SIENDT = DATA(21)
     C                   EVAL      SIFLDA = DATA(22)
     C                   EVAL      SIFLDB = DATA(23)
      *
     C                   WRITE     MESSIPD0
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WriteSP -  Write SEPA Plus Record                            *
      *  Called by: SRMOVE                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WriteSP       BEGSR
      *
     C                   EVAL      SPFLAG = DATA(1)
     C                   EVAL      SPKEY  = DATA(2)
     C                   EVAL      SPBICC = DATA(3)
     C                   EVAL      TMP105 = *BLANKS
     C                   EVAL      TMP105 = DATA(4)
     C                   EVAL      SPINS1 = %SUBST(TMP105:1:35)
     C                   EVAL      SPINS2 = %SUBST(TMP105:36:35)
     C                   EVAL      SPINS3 = %SUBST(TMP105:71:35)
     C                   EVAL      SPCITY = DATA(5)
     C                   EVAL      SPISOC = DATA(6)
     C                   EVAL      SPSCHM = DATA(7)
     C                   EVAL      SPABIC = DATA(8)
     C                   EVAL      SPABST = DATA(9)
     C                   EVAL      SPABEN = DATA(10)
     C                   EVAL      SPPAYC = DATA(11)
     C                   EVAL      SPPRFC = DATA(12)
     C                   EVAL      SPREAC = DATA(13)
     C                   EVAL      SPITRM = DATA(14)
     C                   EVAL      SPSTDT = DATA(15)
     C                   EVAL      SPENDT = DATA(16)
     C                   EVAL      SPSAOS = DATA(17)
     C                   EVAL      SPFLDA = DATA(18)
     C                   EVAL      SPFLB1 = DATA(19)
     C                   EVAL      SPFLB2 = DATA(20)
      *
     C                   WRITE     MESEPAD0
      *
     C                   ENDSR
      *****************************************************************
      *                                                                                       CFT051
      /EJECT                                                                                  CFT051
      *****************************************************************                       CFT051
      *                                                               *                       CFT051
      *  WriteSD -  Write SwiftRef Records (METISDPD)                 *                       CFT051
      *  Called by: SRMOVE                                            *                       CFT051
      *  Calls    : None                                              *                       CFT051
      *                                                               *                       CFT051
      *****************************************************************                       CFT051
      *                                                                                       CFT051
     C     WriteSD       BEGSR                                                                CFT051
      *                                                                                       CFT051
     C                   EVAL      SDFLAG      =  DATA(1)                                     CFT051
     C                   EVAL      SDKEY       =  DATA(2)                                     CFT051
     C                   EVAL      SDBDPKY     =  DATA(3)                                     CFT051
     C                   EVAL      SDISNM      =  DATA(4)                                     CFT051
     C                   EVAL      SDCITY      =  DATA(5)                                     CFT051
     C                   EVAL      SDISOCD     =  DATA(6)                                     CFT051
     C                   EVAL      SDSVID      =  DATA(7)                                     CFT051
     C                   EVAL      SDSVCD      =  DATA(8)                                     CFT051
     C                   EVAL      SDSCHM      =  DATA(9)                                     CFT051
     C                   EVAL      SDCCYD      =  DATA(10)                                    CFT051
     C                   EVAL      SDPRTID     =  DATA(11)                                    CFT051
     C                   EVAL      SDPRNAM     =  DATA(12)                                    CFT051
     C                   EVAL      SDPRTYP     =  DATA(13)                                    CFT051
     C                   EVAL      SDDRIND     =  DATA(14)                                    CFT051
     C                   EVAL      SDINTRM     =  DATA(15)                                    CFT051
     C                   EVAL      SDADDID     =  DATA(16)                                    CFT051
     C                   EVAL      SDSTRDT     =  DATA(17)                                    CFT051
     C                   EVAL      SDSTPDT     =  DATA(18)                                    CFT051
     C                   EVAL      SDSRCDT     =  DATA(19)                                    CFT051
     C                   EVAL      SDATYP1     =  DATA(20)                                    CFT051
     C                   EVAL      SDATVL1     =  DATA(21)                                    CFT051
     C                   EVAL      SDATYP2     =  DATA(22)                                    CFT051
     C                   EVAL      SDATVL2     =  DATA(23)                                    CFT051
     C                   EVAL      SDATYP3     =  DATA(24)                                    CFT051
     C                   EVAL      SDATVL3     =  DATA(25)                                    CFT051
     C                   EVAL      SDFLDA      =  DATA(26)                                    CFT051
     C                   EVAL      SDFLDB      =  DATA(27)                                    CFT051
      *                                                                                       CFT051
     C                   WRITE     METISDD0                                                   CFT051
      *                                                                                       CFT051
     C                   ENDSR                                                                CFT051
      *                                                                                       CFT051
      /EJECT                                                                                  CFT051
      *****************************************************************                       CFT051
      *                                                               *                       CFT051
      *  WriteLL -  Write SwiftRef Records (METILLPD)                 *                       CFT051
      *  Called by: SRMOVE                                            *                       CFT051
      *  Calls    : None                                              *                       CFT051
      *                                                               *                       CFT051
      *****************************************************************                       CFT051
      *                                                                                       CFT051
     C     WriteLL       BEGSR                                                                CFT051
      *                                                                                       CFT051
     C                   EVAL      LLFLAG      =  DATA(1)                                     CFT051
     C                   EVAL      LLKEY       =  DATA(2)                                     CFT051
     C                   EVAL      LLISNM      =  DATA(3)                                     CFT051
     C                   EVAL      LLISOCD     =  DATA(4)                                     CFT051
     C                   EVAL      LLNATID     =  DATA(5)                                     CFT051
     C                   EVAL      LLNTIDT     =  DATA(6)                                     CFT051
     C                   EVAL      LLPOBN      =  DATA(7)                                     CFT051
     C                   EVAL      LLSTAD1     =  DATA(8)                                     CFT051
     C                   EVAL      LLSTAD2     =  DATA(9)                                     CFT051
     C                   EVAL      LLSTAD3     =  DATA(10)                                    CFT051
     C                   EVAL      LLSTAD4     =  DATA(11)                                    CFT051
     C                   EVAL      LLCITY      =  DATA(12)                                    CFT051
     C                   EVAL      LLCPS       =  DATA(13)                                    CFT051
     C                   EVAL      LLZIPC      =  DATA(14)                                    CFT051
     C                   EVAL      LLOFCTP     =  DATA(15)                                    CFT051
     C                   EVAL      LLBDPKY     =  DATA(16)                                    CFT051
     C                   EVAL      LLBDSKY     =  DATA(17)                                    CFT051
     C                   EVAL      LLFLDA      =  DATA(18)                                    CFT051
     C                   EVAL      LLFLDB      =  DATA(19)                                    CFT051
     C                   EVAL      LLFLDC      =  DATA(20)                                    CFT051
     C                   EVAL      LLFLDD      =  DATA(21)                                    CFT051
      *                                                                                       CFT051
     C                   WRITE     METILLD0                                                   CFT051
      *                                                                                       CFT051
     C                   ENDSR                                                                CFT051
      *****************************************************************                       CFT051
      *                                                                                       CFT051
      /EJECT                                                                                  CFT051
      *****************************************************************                       CFT051
      *                                                               *                       CFT051
      *  WriteEL -  Write SwiftRef Records (METIELPD)                 *                       CFT051
      *  Called by: SRMOVE                                            *                       CFT051
      *  Calls    : None                                              *                       CFT051
      *                                                               *                       CFT051
      *****************************************************************                       CFT051
      *                                                                                       CFT051
     C     WriteEL       BEGSR                                                                CFT051
      *                                                                                       CFT051
     C                   EVAL      ELFLAG      =  DATA(1)                                     CFT051
     C                   EVAL      ELKEY       =  DATA(2)                                     CFT051
     C                   EVAL      ELCTRY      =  DATA(3)                                     CFT051
     C                   EVAL      ELIBAN      =  DATA(4)                                     CFT051
     C                   EVAL      ELBIC       =  DATA(5)                                     CFT051
     C                   EVAL      ELVFROM     =  DATA(6)                                     CFT051
     C                   EVAL      ELFLDA      =  DATA(7)                                     CFT051
     C                   EVAL      ELFLDB      =  DATA(8)                                     CFT051
      *                                                                                       CFT051
     C                   WRITE     METIELD0                                                   CFT051
      *                                                                                       CFT051
     C                   ENDSR                                                                CFT051
      *****************************************************************                       CFT051
      /EJECT                                                                                  CSW218
      *****************************************************************                       CSW218
      *                                                               *                       CSW218
      *  WriteFI -  Write BIC Database 2018 Record                    *                       CSW218
      *  Called by: SRMOVE                                            *                       CSW218
      *  Calls    : None                                              *                       CSW218
      *                                                               *                       CSW218
      *****************************************************************                       CSW218
      *                                                                                       CSW218
     C     WriteFI       BEGSR                                                                CSW218
      *                                                                                       CSW218
     C                   EVAL      BDTAG  = DATA(1)                                           CSW218
     C                   EVAL      BDMODF = DATA(2)                                           CSW218
     C                   EVAL      BDBICC = DATA(3)                                           CSW218
     C                   EVAL      BDBICB = DATA(4)                                           CSW218
     C                   EVAL      TMP105 = *BLANKS                                           CSW218
     C                   EVAL      TMP105 = DATA(5)                                           CSW218
     C                   EVAL      BDINS1 = %SUBST(TMP105:1:35)                               CSW218
     C                   EVAL      BDINS2 = %SUBST(TMP105:36:35)                              CSW218
     C                   EVAL      BDINS3 = %SUBST(TMP105:71:35)                              CSW218
     C                   EVAL      TMP105 = *BLANKS                                           CSW218
     C                   EVAL      TMP105 = DATA(6)                                           CSW218
     C                   EVAL      BDBRC1 = %SUBST(TMP105:1:35)                               CSW218
     C                   EVAL      BDBRC2 = %SUBST(TMP105:36:35)                              CSW218
     C                   EVAL      BDCITY = DATA(7)                                           CSW218
     C                   EVAL      BDSUBT = DATA(8)                                           CSW218
     C                   EVAL      BDADDS = DATA(9)                                           CSW218
     C                   EVAL      BDXINF = DATA(10)                                          CSW218
     C                   EVAL      BDAPH1 = DATA(11)                                          CSW218
     C                   EVAL      BDAPH2 = DATA(12)                                          CSW218
     C                   EVAL      BDAPH3 = DATA(13)                                          CSW218
     C                   EVAL      BDAPH4 = DATA(14)                                          CSW218
     C                   EVAL      TMP105 = *BLANKS                                           CSW218
     C                   EVAL      TMP105 = DATA(15)                                          CSW218
     C                   EVAL      BDLOC1 = %SUBST(TMP105:1:25)                               CSW218
     C                   EVAL      BDLOC2 = %SUBST(TMP105:26:35)                              CSW218
     C                   EVAL      BDLOC3 = %SUBST(TMP105:61:35)                              CSW218
     C                   EVAL      TMP105 = *BLANKS                                           CSW218
     C                   EVAL      TMP105 = DATA(16)                                          CSW218
     C                   EVAL      BDCTY1 = %SUBST(TMP105:1:35)                               CSW218
     C                   EVAL      BDCTY2 = %SUBST(TMP105:36:35)                              CSW218
     C                   EVAL      BDPOBN = DATA(17)                                          CSW218
     C                   EVAL      TMP105 = *BLANKS                                           CSW218
     C                   EVAL      TMP105 = DATA(18)                                          CSW218
     C                   EVAL      BDPOB1 = %SUBST(TMP105:1:35)                               CSW218
     C                   EVAL      BDPOB2 = %SUBST(TMP105:36:35)                              CSW218
     C                   EVAL      BDPOB3 = %SUBST(TMP105:71:35)                              CSW218
     C                   EVAL      TMP105 = *BLANKS                                           CSW218
     C                   EVAL      TMP105 = DATA(19)                                          CSW218
     C                   EVAL      BDPBC1 = %SUBST(TMP105:1:35)                               CSW218
     C                   EVAL      BDPBC2 = %SUBST(TMP105:36:35)                              CSW218
      *                                                                                       CSW218
     C                   WRITE     @BICDPD                                                    CSW218
      *                                                                                       CSW218
     C                   ENDSR                                                                CSW218
      *****************************************************************                       CSW218
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREND   -  End Program                                       *
      *  Called by: Main routine                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SREND         BEGSR
      *
     C                   EVAL      *INLR = '1'
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR  - Initial Routine automatically called               *
      *  Called by:                                                   *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLoader
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  File Exception/Error Handling Subroutine          *
      *  Called by: Various                                           *
      *  Calls    : DBERRCTL - DB Error Control                       *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     ARUN          IFEQ      *BLANK
     C                   EVAL      ARUN = 'Y'
     C                   DUMP
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EXSR      SREND
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
