     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MS MT941/2 Generation on MT920 Request.')        *
      *****************************************************************
      *                                                               *
      *  Midas - SWIFT Direct Link Module                             *
      *                                                               *
      *  ME000060 - MT941/2 Automatic Generation on MT920 Request     *
      *                                                               *
      *  Function:   This program receives a request of processing    *
      *              of MT920 Request Message and generates as much   *
      *              MT941 Balance Messages as requested for existing *
      *              opened accounts, as much MT942 Interim Statement *
      *              Messages as requested for existing opened        *
      *              accounts and as much MT995 Query Messages as     *
      *              closed accounts or accounts for which MT941/942  *
      *              are not defined as required. All actions, that   *
      *              means MT941/942 generation, MT995 generation or  *
      *              error detection are printed on a report.         *
      *                                                               *
      *  Called By: MS1900                                            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013 *CREATE     Date 14May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Message Generation                            *
      *           This program is based on MSU920                     *
      *                                                               *
      *****************************************************************
      *
      **  Midas MS Incoming Messages Index by Transaction Reference Number.
     FMSIXI2L4  IF   E           K DISK    INFSR(*PSSR)
      *
      **  Midas MS Incoming Messages by TRNO.
     FMSMSI2L7  IF   E           K DISK    INFSR(*PSSR)
      *
      **  Midas GL Network Accounts
     FGLNWACL1  IF   E           K DISK    INFSR(*PSSR)
      *
      **  Midas GL Network Accounts - MT94x                .
     FGLNW94L1  IF   E           K DISK    INFSR(*PSSR)
      *
      **  Midas GL MT941/942 Messages Requests
     FGLMR94L0  O    E           K DISK    INFSR(*PSSR) COMMIT
      *
      **  Midas MG MTn95 Generation Extract File
     FMGFN95PD  O    E           K DISK    INFSR(*PSSR) COMMIT
      *
      **  Midas MG MTn95 Generation Supplementary File
     FMGXN95PD  O    E           K DISK    INFSR(*PSSR) COMMIT
      *
      **  Midas MS ME Incoming MT920 Audit File
     FMEI920PD  O    E           K DISK    INFSR(*PSSR) COMMIT
      *
      **  Midas MS ME Incoming MT920 Parts File
     FMEP920PD  O    E           K DISK    INFSR(*PSSR) COMMIT
      *
      **  Midas MS Automatic Generation of MT941 and MT942 Report.
     FME000060P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
      **  Midas MS Automatic Generation of MT941 and MT942 Audit Report.
     FME000060AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  61 - Retail Number required in the system.                   *
      *                                                               *
      *  77 - Resulting indicator on CHEKR>/TESTN operation codes.    *
      *                                                               *
      *  80 - Access to SDCUSTL7 failed.                              *
      *  81 - Access to MSIXI2L4 failed.                              *
      *  82 - Access to MSMSI2L7 failed.                              *
      *  83 - Access to GLNWACL1 failed.                              *
      *  84 - Access to GLNW94L0 failed.                              *
      *  87 - Access to GLMR94L0 failed.                              *
      *                                                               *
      *  90  -  Called program ended abnormally.                      *
      *  98  -  Date format MMDDYY.                                   *
      *  99  -  General Error Indicator.                              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *                  *************************                    *
      *                  ** INDICATORS NOT USED **                    *
      *                  *************************                    *
      *                                                               *
      *       ***************************************************     *
      *       * 01   02   03   04   05   06   07   08   09   10 *     *
      *       * 11   12   13   14   15   16   17   18   19   20 *     *
      *       * 21   22   23   24   25   26   27   28   29   30 *     *
      *       * 31   32   33   34   35   36   37   38   39   40 *     *
      *       * 41   42   43   44   45   46   47   48   49   50 *     *
      *       * 51   52   53   54   55   56   57   58   59   60 *     *
      *       * xx   62   63   64   65   66   67   68   69   70 *     *
      *       * 71   72   73   74   75   76   xx   78   79   80 *     *
      *       * xx   xx   xx   xx   xx   xx   xx   88   89   xx *     *
      *       * xx   xx   xx   xx   xx   xx   xx   xx   xx      *     *
      *       ***************************************************     *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *                S U B R O U T I N E   I N D E X                *
      *                -------------------------------                *
      *                                                               *
      *  #MREQU  - process extracted message request.                 *
      *  #SETH1  - Set up fields from ME000060P1 Header Record Format *
      *  #MT942  - Write a record in GLMR94PD and submit MT942 Gener. *
      *  #MIDAM  - Convert amount from SWIFT format to Midas Format.  *
      *  #MT995  - Write a record in MT995 Generation Driver File.    *
      *  #SETD1  - Set up fields from ME000060P1 Detail Record Format *
      *  #MS920  - Write a record in Action on MT920 File.            *
      *  #SNDMS  - send message to MOPERQ.                            *
      *  *INZSR  - initial processing.                                *
      *  #RCFP1  - Subroutine to register the P1 Printer File via RCF *
      *  #RCFAU  - Subroutine to register the AU Printer File via RCF *
      *  #AUDIT  - Subroutine to Output Audit report.                 *
      *  *PSSR   - Program exception error routine.                   *
      *                                                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      **  Array used to store Swift Data.
      *
      **  Array used to split or group informations.
     D STR             S              1    DIM(128)
      *
      **  Array containing possible actions on MT920 Request.
     D ACT             S             80    DIM(4) CTDATA PERRCD(1)

      ** Fields used in call to Module ZDATE1

     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D Errorflag       S              1A
      *
      **  Local data area for Run Date Informations.
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      *
      **  Local data area for database error details.
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      *
      **                                    134 141 DBFILE
      **       Defines :                    142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      **  File Information Data Structure for ME000060P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      **  File Information Data Structure for ME000060AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      **  Data Structure used to send a message to MOPERQ.
     D ERDTA         E DS                  EXTNAME(MEERDTA)
      *
      **  Data Structure used to define Carriage Return delimiters
      **  used when scanning in message.
      *
      **  Hex value  '  :'  = CRLF : start of text/Field Separator.
      **             027
      **             D5A
     D  WUCRLF                 1      3
     D  WUCHR1                 1      1
     D  WUCHR2                 2      2
     D  WUCHR3                 3      3
      *
      **  Data structure used to scan in SWIFT message data.
     D DSSWD           DS          9999    OCCURS(1)
     D  SWD                    1   9999
     D                                     DIM(9999)
      *
      **  Data structure used to split field 25 - Account Identification.
     D***WUFL25          DS            18
     D WUFL25          DS            24
     D  WUBRCA                 1      3
     D  WUCUST                 4      9
     D  WUCCY                 10     12
     D***WUCODE*               13     16                                                      CGL029
     D***WUSEQU*               17     18                                                      CGL029
     D  WUCODE                13     22                                                       CGL029
     D  WUSEQU                23     24                                                       CGL029
     D  WURETL                 1     10
      *
      **  Data structure used to group Full Account fields
      **  to be output in MEP920PD File.
     D***M1ACCN*         DS            18                                                     CGL029
     D M1ACCN          DS            24                                                       CGL029
     D  M1BRCA                 1      3
     D**M1CNUM**               4      9  0                                                    CSD027
     D  M1CNUM                 4      9A                                                      CSD027
     D  M1CCY                 10     12
     D***M1ACOD*               13     16  0                                                   CGL029
     D***M1ACSQ*               17     18  0                                                   CGL029
     D  M1ACOD                13     22  0                                                    CGL029
     D  M1ACSQ                23     24  0                                                    CGL029
      *
      **  Data structure used to group fields passed as
      **  parameters to AOACCTR0.
     D***P@ACCN*         DS            28                                                     CGL029
     D P@ACCN          DS            34                                                       CGL029
     D  P@RETL                 1     10
     D  P@CUST                11     16
     D  P@CCY                 17     19
     D***P@CODE*               20     23                                                      CGL029
     D***P@SEQU*               24     25                                                      CGL029
     D***P@BRCA*               26     28                                                      CGL029
     D  P@CODE                20     29                                                       CGL029
     D  P@SEQU                30     31                                                       CGL029
     D  P@BRCA                32     34                                                       CGL029
      *
      **  Data structure used to define and MT995
      **  Transaction Reference Number.
     D WUTNUM          DS            16
     D  MGMODI                 1      2
     D  WUDATE                 3      8
     D  WUSEQ                  9     14S 0
      *
      **  Data structure used to split Received Time.
     D WUMOTM          DS
     D  WUMOHH                 1      2
     D  WUMOMM                 3      4
      *
      **  Data structure used to split Second Level Message Text.
     D P@MGT2          DS
     D  WUTXTA                 1    256
     D  WUTXTB               257    512
      *
      **  Data structure used to split SWIFT II Message Input Reference.
     D MIR             DS            28
     D  WUMIR7                 7     14
     D  WUMI16                16     18
      *
      **  Data structures used to convert date defined
      **  SWIFT format to Midas Date format.
     D WUSWFD          DS             6
     D  WUSWYY                 1      2  0
     D  WUSWMM                 3      4  0
     D  WUSWDD                 5      6  0
     D WUMIDD          DS             6
     D  WUMIDM                 1      4  0
     D  WUMIYY                 5      6  0
      *
      **  Constant used to set up DBKEY when no Database Error.
     D WUDB99          C                   CONST('Last file used. See -
     D                                     Dump.')
      *
      **  Constants
     D WUNWRK          S              6    INZ('SWIFT ')
     D WURMSQ          S              6S 0
     D WUTAG           S              5
     D WUMTYP          S              3
     D WUT941          S              3    INZ('941')
     D WUT942          S              3    INZ('942')
     D WUT995          S              3    INZ('995')
     D MODEA           S              6
     D RCVDA           S              8
     D KNATY           S              1
     D KMTYP           S              3
     D CurPos          S              5U 0                                      Current Position
     D Length          S              5U 0                                      Length
     D StCheck         S              5U 0                                      Start Check Position
     D StResul         S              5U 0                                      Start Result Posit.
     D Result          S                   LIKE(P@MIDA)                         Result Field

      ** Parameters for QSNDDTAQ
     D PDataQueue      S             10    INZ('GLM94XDQ  ')
     D PLibrary        S             10    INZ('*LIBL     ')
     D PDataLength     S              5  0 INZ(1)
     D PData           S              1    INZ('C')

      *
      **  External data structure for Switchable Feature Details.
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SCLCD        E                     EXTFLD(LCD)
      *
      **  Data structure for Bank Details.
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      **  Data structure for Retail Details.
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      *
      **  Data structure for Branch Details.
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      **  External data structure for Account Details.
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D  ACCSFB       E                     EXTFLD(CFSB)
      *
      **  Data structure for Customer Details.
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
      *
      **  Data structure for Account Codes Details.
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
      *
      **  Data structure for Currency Details.
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Midas SD Counterparty Nostro Details record layout
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      ** Midas BIC Directory Details record layout
     D SDBICD        E DS                  EXTNAME(MEBICDPD)
      *
      **  First DS for access programs, short data structure.
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      **  Second DS for access programs, long data structure.
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D/COPY MGCPYSRC,MGCMNFCTDC

      *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
      **  Rename fields from Incoming Message Index File.
     IMSIXI2D0
     I              BRCA                        IXBRCA
     I              CNUM                        IXCNUM
     I              TRNO                        IXTRNO
      *
      /EJECT
      *****************************************************************
      *
      **  List of parameters.
     C     *ENTRY        PLIST
     C                   PARM                    P@RTNC            7
     C                   PARM                    P@TRNO           16
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                  M A I N  P R O C E S S I N G                 *
      *                                                               *
      *****************************************************************
      *
     C                   MOVE      *BLANKS       P@RTNC
      *
      **  Access to Incoming Message Index File.
     C     P@TRNO        CHAIN     MSIXI2L4                           81
      *
      **  If record not found, handle Database Error.
     C     *IN81         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'MSIXI2L4'    DBFILE                         ***************
     C                   MOVEL     P@TRNO        DBKEY                          * DB ERROR 01 *
     C                   Z-ADD     01            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      **  Output a record into Incoming MT920 Audit File MEI920PD.
     C                   EXSR      #MEI920
      *
      *
      **  If Receiver related Branch is not filled, error
      **  has to be printed on report.
     C     IXBRCA        IFEQ      *BLANKS
     C                   MOVE      'Y'           WUERR             1
     C                   Z-ADD     1             A                 1 0
     C                   MOVE      'ME00101'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
      *
     C                   ELSE
      *
     C                   END
      *
      **  If Sender Customer Number is not filled, error
      **  has to be printed on report.
     C*****IXCNUM        IFEQ      0                                                          CSD027
     C     IXCNUM        IFEQ      *BLANKS                                                    CSD027
      *
     C     WUERR         IFNE      'Y'
     C                   MOVE      'Y'           WUERR
     C                   Z-ADD     1             A
     C                   MOVE      'ME00102'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
      *
     C                   END
      *
     C                   ELSE
      *
      **  Access to Customer Details to retrieve Sender
      **  shortname and related Branch.
     C                   MOVEL     IXCNUM        P@KEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD            7                B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7                I:Option
     C                   PARM                    P@KEY1           10                I:Key field
     C                   PARM                    P@KYST            7                O:Key status
     C     SDCUST        PARM      SDCUST        DSSDY                              O:Format
      *
      **  If Customer was not found, handle Database Error.
     C     P@RTCD        IFNE      *BLANKS                                      Begin P@RTCD
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE                         ***************
     C                   MOVEL     P@KEY1        DBKEY                          * DB ERROR 03 *
     C                   Z-ADD     03            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   END                                                    End P@RTCD
     C     *LIKE         DEFINE    BBCSSN        WUSCSN
     C                   MOVE      BBCSSN        WUSCSN
      *
     C                   END
      *
      **  Set up fields from Automatic Generation of MT942 Report
      **  Printer File Header Record Format.
     C                   EXSR      #SETH1
      *
      **-------------< Extract Data From SWIFT Message >-------------**
      *
      **  Initialise Array used to store extracted Data.
     C                   MOVE      *BLANKS       SWD
     C                   Z-ADD     1             D                 5 0
      *
      * Get all records for SWIFT message and place all associated
      * records into array. A maximum of 10 records is assumed.
      *
     C     P@TRNO        SETLL     MSMSI2L7
     C     P@TRNO        READE     MSMSI2L7                               82
      *
      **  Do while Data to extract.
     C     *IN82         DOWEQ     *OFF
      *
      **  If more than 9999 characters, send message to MOPERQ
      **  and handle Database Error.
      *
     C     D             IFGT      9999
     C                   MOVE      'ME00103'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
     C                   EXSR      #SNDMS
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MSMSI2L7'    DBFILE                         ***************
     C                   MOVEL     P@TRNO        DBKEY                          * DB ERROR 04 *
     C                   Z-ADD     04            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   END
      *
     C                   MOVEA     MDTA          SWD(D)
     C                   ADD       256           D
      *
      **  Get next record.
     C     P@TRNO        READE     MSMSI2L7                               82
      *
     C                   ENDDO
      *
      **  Search for start of block.
     C                   MOVE      '{4:'         WUBLOK            3
     C     WUBLOK:3      SCAN      DSSWD:1       S                 5 0
      *
      **  If no Block 4: found, send message to MOPERQ
      **  ans handle Database Error.
     C     S             IFEQ      0
     C                   MOVE      'ME00104'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
     C                   EXSR      #SNDMS
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MSMSI2L7'    DBFILE                         ***************
     C                   MOVEL     P@TRNO        DBKEY                          * DB ERROR 05 *
     C                   Z-ADD     05            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   END
      *
      *  Determine delimiter positions for the block.
      *
      *  Search for delimiter WUTAGB - start of tag component
      *                       WUBLKE - End of block
      *
      *  Begin search after position of the Block Tag No.
      *
     C     WUTAGB:3      SCAN      DSSWD:S       WUBEGT            5 0
     C     WUBLKE:3      SCAN      DSSWD:S       WUENDB            5 0
      *
      **  Initialise Sequence Number of Requested message.
     C                   Z-ADD     0             WURMSQ
      *
      **----------------< Extract the Block's data >-----------------**
      *
      *  Repeat process while the new tag delimiter WUBKGB is prior to
      *  the Block's End of text delimiter WUBLKE.
      *
     C     WUBEGT        DOWLT     WUENDB
      *
      **  Clear message tag and message data fields.
     C                   MOVEL     *BLANKS       WUTAG
     C                   MOVEL     *BLANKS       WUDATA          100
      *
      **  Extract tag no.
      *
      **  Beginning of tag no. is the colon of the delimiter, so
      **  start search of tag from start position of delimiter.
      *
     C                   Z-ADD     WUBEGT        S
     C     ':':1         SCAN      DSSWD:S       WUBEGT            5 0
     C     WUBEGT        ADD       1             S
      *
      **  End of the tag no. is the next colon, start search after
      **  position of the first ':'
      *
     C     ':':1         SCAN      DSSWD:S       WUENDT            5 0
      *
      **  Determine length of tag (End - Start + 1)
      *
     C     WUENDT        SUB       WUBEGT        L                 5 0
     C                   ADD       1             L
      *
     C                   Z-ADD     WUBEGT        S
     C     L             SUBST     DSSWD:S       WUTAG
      *
      **  If Tag no. is :12: and number of request message is
      **  greater than 0, that means that a requested message
      **  has just been extracted and needs to be processed
      **  before processing current requested message.
      *
     C     WUTAG         IFEQ      ':12:'
     C     WURMSQ        ANDGT     0
     C                   EXSR      #MREQU
      *
     C                   END
      *
      **  Search for next WUTAGB delimiter starting from the tag no. to
      **  get end position of Data string to extract.
      *
      **  If no more WUTAGB for the block, the system sets the delimiter
      **  to '0' - in that case re-set it to the same value as the WUENDB
      **  so that to exit from the loop.
      *
     C     WUTAGB:3      SCAN      DSSWD:S       WUBEGT
      *
     C     WUBEGT        IFEQ      0
     C     WUBEGT        ORGT      WUENDB
     C                   Z-ADD     WUENDB        WUBEGT
      *
     C                   END
      *
      **  Determine start position of data string. It will be the
      **  end position of the tag no. plus 1.
     C     WUENDT        ADD       1             WUBEGS            5 0
      *
      *  Determine end position of data string. It will be prior to
      *  the position of the next delimiter.
      *
     C                   Z-ADD     WUBEGT        WUNXTT            5 0
     C     WUENDB        IFLT      WUNXTT
     C                   Z-ADD     WUENDB        WUNXTT
      *
     C                   END
      *
     C     WUNXTT        SUB       1             WUENDS            5 0
      *
      **  Determine length of data string (End - Start + 1).
      *
     C     WUENDS        SUB       WUBEGS        L
     C                   ADD       1             L
      *
      **  Extract data string.
      **  ('P' in posn 53 indicates that the result field will be padded
      **  on the right with blanks if factor 1 is shorter than the
      **  length of the result field)
      *
     C                   Z-ADD     WUBEGS        S
     C     L             IFGT      0
     C     L             SUBST(P)  DSSWD:S       WUDATA
      *
     C                   END
      *
      **  According to Tag Number, extract relevant details.
     C                   SELECT
      *
     C     WUTAG         WHENEQ    ':20: '
     C     *LIKE         DEFINE    MRRREF        WURREF
     C                   MOVEL     WUDATA        WURREF
      *
     C     WUTAG         WHENEQ    ':12: '
     C                   ADD       1             WURMSQ
     C                   MOVEL     WUDATA        WUMTYP
      *
     C     WUTAG         WHENEQ    ':25: '
     C                   CLEAR                   WUFL25
     C                   MOVEL     WUDATA        WUAC35           35
      *
     C     WUTAG         WHENEQ    ':34F:'
      *
      **  Define work fields used to convert amounts from
      **  SWIFT format to Midas format.
     C     *LIKE         DEFINE    P@CCY         WUDCCY
     C     *LIKE         DEFINE    P@CCY         WUCCCY
     C     *LIKE         DEFINE    P@AMNT        WUDAMT
     C     *LIKE         DEFINE    P@AMNT        WUCAMT
      *
      **  Determine which of two fields (Debit or Credit Floor
      **  Limit) is being extracted.
     C                   MOVE      *BLANKS       STR(1)
     C                   MOVEA     WUDATA        STR(1)
      *
      **  If field look like : :34F:DEM150000, that means
      **  both Debit and Credit Floor Limits are the same.
      **  If two fields look like : :34F:DEMD150000,
      **                            :34F:DEMC160000,
      **  that means Debit and Credit Floor Limits are different.
     C                   SELECT
      *
     C     STR(4)        WHENEQ    'D'
     C                   MOVEA     STR(1)        WUDCCY
     C                   MOVE      *BLANKS       WUDAMT
     C                   MOVEA     STR(5)        WUDAMT
      *
     C     STR(4)        WHENEQ    'C'
     C                   MOVEA     STR(1)        WUCCCY
     C                   MOVE      *BLANKS       WUCAMT
     C                   MOVEA     STR(5)        WUCAMT
      *
     C                   OTHER
     C                   MOVEA     STR(1)        WUDCCY
     C                   MOVEA     STR(1)        WUCCCY
     C                   MOVE      *BLANKS       WUDAMT
     C                   MOVEA     STR(4)        WUDAMT
     C                   MOVE      *BLANKS       WUCAMT
     C                   MOVEA     STR(4)        WUCAMT
      *
     C                   ENDSL
      *
     C                   ENDSL
      *
     C                   ENDDO
      *
      **  Process last extracted Message Request, only if a
      **  Message Part has been processed.
     C     WUMTYP        IFNE      *BLANKS
     C                   EXSR      #MREQU
      *
      **  Write Trailer Record Format.
     C                   WRITE     TRAILP1
      *
     C                   END
      *
      ** Activate MT941/MT942 generation if required
      *
     C     WUM94N        IFEQ      'Y'
      *
      ** Send a 'C' to data queue GLM94XDQ to initiate process
      *

     C                   CALL      'QSNDDTAQ'
     C                   PARM                    PDataQueue
     C                   PARM                    PLibrary
     C                   PARM                    PDataLength
     C                   PARM                    PData
     C                   ENDIF
      *
      ** Activate MT995 generation if required
      *
     C     WUM995        IFEQ      'Y'
     C                   CALL      'GLC001440'
     C                   ENDIF
      *
      **  Write Audit Report.
     C                   Z-ADD     WURMSQ        AU942R
     C                   EXSR      #AUDIT
      *
      **  End program.
      **  ¯¯¯¯¯¯¯¯¯¯¯¯
     C                   SETON                                        LR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  #SETH1  - Set up fields from Automatic Genaration of MT942   *
      *            Report Printer File Header Record Format.          *
      *                                                               *
      *  Called By : Main Processing                                  *
      *                                                               *
      *  Calls     :                                                  *
      *                                                               *
      *****************************************************************
      *
     C     #SETH1        BEGSR
      *
      **  First convert Received Date to Midas Day Number.
     C                   MOVE      MODE          WUSWFD
     C                   Z-ADD     WUSWYY        WUMIYY
     C  N98              MOVEL     WUSWDD        WUMIDM
     C   98              MOVEL     WUSWMM        WUMIDM
     C  N98              MOVE      WUSWMM        WUMIDM
     C   98              MOVE      WUSWDD        WUMIDM
     C                   MOVE      WUMIDD        DateIn
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM                    DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    Errorflag
     C     *LIKE         DEFINE    MODE          WUMODE
     C                   Z-ADD     DaynoOut      WUMODE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   MOVE      ZADATE        P1MODE
      *
      **  Received Time.
     C                   MOVE      MOTM          WUMOTM
     C                   MOVE      '  :  '       P1MOTM
     C                   MOVEL     WUMOHH        P1MOTM
     C                   MOVE      WUMOMM        P1MOTM
      *
      **  Sender.
     C                   MOVE      IXCNUM        P1SCNO
     C                   MOVEL     STID          P1STID
     C                   MOVE      *BLANKS       P1SCSN
     C*****IXCNUM        IFNE      0                                                          CSD027
     C     IXCNUM        IFNE      *BLANKS                                                    CSD027
     C                   MOVE      WUSCSN        P1SCSN
      *
     C                   ENDIF
      *
      **  Incoming MIR.
     C                   MOVE      MIR           P1IMIR
      *
      **  Incoming TRN.
     C                   MOVE      IXTRNO        P1ITRN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #MREQU  - process extracted message request.                 *
      *                                                               *
      *  Called by : Main Processing.                                 *
      *                                                               *
      *  Calls     : #VALAC                                           *
      *              #MT942                                           *
      *              #MT995                                           *
      *              #SETD1                                           *
      *              #RCFP1                                           *
      *              #MS920                                           *
      *                                                               *
      *****************************************************************
     C     #MREQU        BEGSR
      *
      **  If no error occurred while checking Receiver
      **  and sender, reset Message Id. to blanks.
     C     WUERR         IFNE      'Y'
     C                   MOVE      *BLANKS       WUMGID
      *
     C                   ENDIF
      *
      **  If message requested is not a MT941 or MT942
     C     WUMTYP        IFNE      WUT942
     C     WUMTYP        ANDNE     WUT941
     C     WUMGID        ANDEQ     *BLANKS
     C                   Z-ADD     2             A
     C                   MOVE      'ME00105'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
     C                   GOTO      @MT995
     C                   END
      *
     C                   Z-ADD     1             A
      *
      **  Check Account Identification and set up Full
      **  Account/Retail Number to be output on Report
      **  or in MEP920PD File.
     C                   CLEAR                   WUFL25
     C                   MOVEL     WUAC35        WUFL25
     C     *LIKE         DEFINE    M1ACCN        WUACCN
     C                   MOVE      *BLANKS       WUACCN
      *
     C     CFT004        IFEQ      'Y'
     C                   MOVEL     WUAC35        P@IBAN
     C                   CALL      'AOIBANR2'
     C                   PARM      *BLANKS       P@RTCD            7                B:Return code
     C                   PARM                    P@IBAN           34                I:Option
     C     ACCNT         PARM                    DSSDY                              I:Key field
      *
     C     P@RTCD        IFEQ      '      6'
     C     WUMGID        IFEQ      *BLANKS
     C                   Z-ADD     2             A
     C                   MOVE      'ME00127'     WUMGID
     C                   ENDIF
     C                   GOTO      @MT995
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     CFT004        IFEQ      'Y'
     C     P@RTCD        ANDNE     *BLANKS
     C     CFT004        ORNE      'Y'
      *
     C     ' '           CHECKR    WUAC35        L                        77
      *
     C                   SELECT
      *
     C     L             WHENEQ    10
      *
      **  If Retail Number not assumed by the system.
     C     BMRANR        IFNE      'Y'
      *
     C     WUMGID        IFEQ      *BLANKS
     C                   Z-ADD     2             A
     C                   MOVEL     'Y'           FORMAT1           1
     C                   MOVE      'ME00106'     WUMGID
      *
     C                   ENDIF
     C                   GOTO      @MT995
     C                   ENDIF
      *
      **  If Branch Code is missing in Multi-branch system.
     C     L             WHENEQ    15
      *
      **  If Multi-branch system.
     C     AGMBIN        IFEQ      'Y'
      *
     C     WUMGID        IFEQ      *BLANKS
     C                   Z-ADD     2             A
     C                   MOVEL     'Y'           FORMAT1
     C                   MOVE      'ME00107'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
     C                   ENDIF
      *
     C                   GOTO      @MT995
     C                   ENDIF
      *
      **  Add Single Branch Code.
     C     BJSBRC        CAT       WUAC35:0      WUFL25
      *
      **  If Branch Code used in Single Branch system.
     C     L             WHENEQ    18
      *
     C     AGMBIN        IFNE      'Y'
      *
     C     WUMGID        IFEQ      *BLANKS
     C                   Z-ADD     2             A
     C                   MOVEL     'Y'           FORMAT1
     C                   MOVE      'ME00108'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
     C                   ENDIF
      *
     C                   GOTO      @MT995
      *
     C                   ENDIF
     C                   OTHER
      *
     C     WUMGID        IFEQ      *BLANKS
     C                   Z-ADD     2             A
     C                   MOVEL     'Y'           FORMAT1
     C                   MOVE      'ME00109'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
     C                   ENDIF
      *
     C                   GOTO      @MT995
     C                   ENDSL
      *
      **  Check if valid account.
     C                   EXSR      #VALAC
      *
     C                   ENDIF
      *
      **  If any error occurred, goto printing tag.
     C     WUMGID        CABNE     *BLANKS       @MT995
      *
      **  Set up both Full Account and Retail Number.
     C                   MOVE      BRCA          WUBRCA
     C                   MOVE      CNUM          WUCUST
     C                   MOVE      CCY           WUCCY
     C                   MOVE      ACOD          WUCODE
     C                   MOVE      ACSQ          WUSEQU
     C                   MOVE      ACNO          WUACNO
      *
      **  If account is not live.
     C     ACST          IFEQ      'C'
     C                   Z-ADD     2             A
      *
      **  If Account is already closed.
     C     RECI          IFEQ      'C'
     C                   MOVE      'ME00117'     WUMGID
      *
      **  If Account is flagged for closure.
     C                   ELSE
     C                   MOVE      'ME00118'     WUMGID
      *
     C                   END
     C                   MOVE      *BLANKS       WUMGDA
     C                   GOTO      @MT995
      *
     C                   END
      *
      **  Define Key List to access to SWIFT Account Details.
     C     *LIKE         DEFINE    BRCA          KBRCA
     C     *LIKE         DEFINE    CNUM          KCNUM
     C     *LIKE         DEFINE    CCY           KCCY
     C     *LIKE         DEFINE    ACOD          KACOD
     C     *LIKE         DEFINE    ACSQ          KACSQ
     C     *LIKE         DEFINE    WUNWRK        KNWRK
     C     KGLNWAC       KLIST
     C                   KFLD                    KNWRK
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KNATY
     C     KGLNW94       KLIST
     C                   KFLD                    KNWRK
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KNATY
     C                   KFLD                    KDSTN            11
      *
      **  Set up Key Fields.
     C                   MOVE      WUNWRK        KNWRK
     C                   MOVEL     STID          KDSTN
     C                   MOVE      WUBRCA        KBRCA
     C                   MOVE      WUCUST        KCNUM
     C                   MOVE      WUCCY         KCCY
     C                   MOVE      WUCODE        KACOD
     C                   MOVE      WUSEQU        KACSQ
     C                   MOVE      'S'           KNATY                          Single account
      *
      **  Access to GL Network Accounts
     C     KGLNWAC       CHAIN     GLNWACD0                           83
      *
      **  If GL Network Accounts were not found.
     C     *IN83         IFEQ      *ON
     C                   Z-ADD     2             A
     C                   MOVE      'ME00119'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
     C                   GOTO      @MT995
     C                   END
      *
      **  If GL Network Account is not live.
     C     NARECI        IFNE      'D'
     C                   Z-ADD     2             A
     C                   MOVE      'ME00120'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
     C                   GOTO      @MT995
     C                   END
      *
      **  Initialize MT940 Destination
     C                   MOVE      NANATY        KNATY
      *
      **  Access to GL Network Accounts - MT94
     C     KGLNW94       CHAIN     GLNW94D0                           84
      *
      **  If Details were not found.
     C     *IN84         IFEQ      *ON
      *
      ** Check if the SWIFT address corresponds to a customer number.
      *
     C                   EVAL      P@BICC = %Subst(STID:1:8)
     C                   EVAL      P@BICB = %Subst(STID:9:3)
      *
     C                   CALL      'ME1400'
     C                   PARM      *Blanks       P@RtCd                         I:Return
     C                   PARM                    P@BICC            8            I:Bic Cod
     C                   PARM                    P@BICB            3            I:Bic Bra
     C                   PARM      *Blanks       SDCUST                         O:Custome
     C                   PARM      *Blanks       SDCNST                         O:Counter
     C                   PARM      *Blanks       SDBICD                         O:Bic Dir
     C                   PARM      *Blanks       @ICUST            1            O:Custome
     C                   PARM      *Blanks       @ICNST            1            O:Counter
     C                   PARM      *Blanks       @IBICD            1            O:Bic fou

     C                   IF        @ICUST = 'Y'
      ** Access the network account file with the destination in customer number format.
     C                   EVAL      KDSTN  = BBCUST
     C     KGLNW94       CHAIN     GLNW94D0                           84
     C                   ENDIF
     C                   ENDIF
      *
      **  If Details were not found.
     C     *IN84         IFEQ      *ON
     C                   Z-ADD     2             A
     C                   MOVE      'ME00121'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
     C                   GOTO      @MT995
     C                   END
      *
      **  If MT941 not defined as being required.
     C     WUMTYP        IFEQ      WUT941
     C     N41AER        ANDNE     'Y'
     C                   Z-ADD     2             A
     C                   MOVE      'ME00122'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
     C                   GOTO      @MT995
     C                   END
      *
      **  If MT942 not defined as being required.
     C     WUMTYP        IFEQ      WUT942
     C     N42AER        ANDNE     'Y'
     C                   Z-ADD     2             A
     C                   MOVE      'ME00125'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
     C                   GOTO      @MT995
     C                   END
      *
     C     @MT942        TAG
      *
      **  Write a record in MT942 Generation Driver File and
      **  submit MT942 Interim Statement Message generation.
     C     WUMTYP        IFEQ      WUT941
     C                   Z-ADD     4             A
     C                   ELSE
     C                   Z-ADD     3             A
     C                   ENDIF
     C                   MOVEL     'Y'           WUM94N            1
      *
     C                   EXSR      #MT942
      *
     C                   GOTO      @PRINT
      *
     C     @MT995        TAG
      *
      **  Do not generate MT995 if Unknown Receiver or Sender.
      *
     C     A             IFGE      2
      *
      **  Write a record in MT995 Generation Driver File.
     C                   MOVEL     'Y'           WUM995            1
     C                   EXSR      #MT995
      *
     C                   ENDIF
      *
     C     @PRINT        TAG
      *
      **  Get message text, only if Message Id. filled.
     C     WUMGID        IFNE      *BLANKS
     C                   CALL      'MEC1150'                            99
     C                   PARM      WUMGID        P@MGID            7
     C                   PARM      WUMGFI        P@MGFI           10
     C                   PARM      WUMGDA        P@MGDA          132
     C                   PARM      *BLANKS       P@MGT1          132
     C                   PARM      *BLANKS       P@MGT2
      *
      **  If program ends abnormally, handle database Error.
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'MEC1150 '    DBFILE                         ***************
     C                   MOVEL     '*CALL '      DBKEY                          * DB ERROR 07 *
     C                   Z-ADD     07            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   END
      *
      **  Set up fields from Automatic Generation of MT942 Report
      **  Printer File Detail Record Format.
     C                   EXSR      #SETD1
      *
      **  If Automatic Generation of MT942 Error Report
      **  not yet opened.
     C     WUOPP1        IFNE      'Y'
     C                   MOVE      'Y'           WUOPP1
      *
      **  Open Error Report Printer File.
     C                   OPEN      ME000060P1
      *
      **  Ensure Report Spool FileS are recorded by RCF.
     C                   EXSR      #RCFP1
      *
     C                   END
      *
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Z-ADD     1             RQDLN1            2 0
     C     OFLLN1        SUB       PRTLN1        DIFLN1            2 0
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
      *
     C                   END
      *
      **  Write Detail Record Format.
     C                   WRITE     DETAIL1
      *
     C     @MS920        TAG
      *
      **  Output a record into Action on MT920 File MEP920PD.
     C                   EXSR      #MS920
     C     @ENREQ        ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #VALAC  - Validate requested account.                        *
      *                                                               *
      *  Called By : #MREQU                                           *
      *                                                               *
      *  Calls     : *none                                            *
      *                                                               *
      *****************************************************************
      *
     C     #VALAC        BEGSR
      *
      **  Initialize parameter fields to access to
      **  Account Master Details File.
     C                   CLEAR                   P@ACCN
      *
      **  If Retail Number.
     C     L             IFEQ      10
      *
     C                   TESTN                   WURETL               77
      *
      **  If Retail Number is not numeric.
     C     *IN77         IFEQ      *OFF
      *
     C     WUMGID        IFEQ      *BLANKS
     C                   Z-ADD     2             A
     C                   MOVEL     'Y'           FORMAT1
     C                   MOVE      'ME00110'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
      *
     C                   ENDIF
     C                   GOTO      @ENVAC
      *
     C                   END
     C                   MOVE      WURETL        P@RETL
     C*
     C                   MOVE      *BLANKS       P@CUST
     C                   MOVE      *BLANKS       P@CCY
     C                   MOVE      *BLANKS       P@CODE
     C                   MOVE      *BLANKS       P@SEQU
     C                   MOVE      *BLANKS       P@BRCA
      *
     C                   ELSE
      *
      **  Check Branch Code.
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      WUBRCA        P@BRCA            3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      **  If Branch Code does not exist.
     C     P@RTCD        IFNE      *BLANKS
      *
     C     WUMGID        IFEQ      *BLANKS
     C                   Z-ADD     2             A
     C                   MOVEL     'Y'           FORMAT1
     C                   MOVE      'ME00111'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
     C                   MOVEL     WUBRCA        WUMGDA
      *
     C                   ENDIF
     C                   GOTO      @ENVAC
      *
     C                   ENDIF
      *
      **  Check Customer Number.
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      WUCUST        P@CNUM           10
     C                   PARM      *BLANKS       P@KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      **  If Customer Number does not exist.
     C     P@RTCD        IFNE      *BLANKS
      *
     C     WUMGID        IFEQ      *BLANKS
     C                   Z-ADD     2             A
     C                   MOVEL     'Y'           FORMAT1
     C                   MOVE      'ME00112'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
     C                   MOVEL     WUCUST        WUMGDA
      *
     C                   ENDIF
     C                   GOTO      @ENVAC
      *
     C                   ENDIF
      *
      **  Check Currency Code.
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      WUCCY         P@CCY             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  If Currency Code does not exist.
     C     P@RTCD        IFNE      *BLANKS
      *
     C     WUMGID        IFEQ      *BLANKS
     C                   Z-ADD     2             A
     C                   MOVEL     'Y'           FORMAT1
     C                   MOVE      'ME00113'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
     C                   MOVEL     WUCCY         WUMGDA
      *
     C                   ENDIF
     C                   GOTO      @ENVAC
      *
     C                   ENDIF
      *
      **  Check Account Code.
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C**********         PARM      WUCODE        P@ACOD            4                          CGL029
     C                   PARM      WUCODE        P@ACOD           10                          CGL029
     C     SDACOD        PARM      SDACOD        DSSDY
      *
      **  If Account Code does not exist.
     C     P@RTCD        IFNE      *BLANKS
      *
     C     WUMGID        IFEQ      *BLANKS
     C                   Z-ADD     2             A
     C                   MOVEL     'Y'           FORMAT1
     C                   MOVE      'ME00114'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
     C                   MOVEL     WUCODE        WUMGDA
      *
     C                   ENDIF
     C                   GOTO      @ENVAC
      *
     C                   ENDIF
      *
      **  Check Account Sequence. It must be numeric.
     C     WUSEQU        IFLT      '01'
     C     WUSEQU        ORGT      '99'
      *
     C     WUMGID        IFEQ      *BLANKS
     C                   Z-ADD     2             A
     C                   MOVEL     'Y'           FORMAT1
     C                   MOVE      'ME00115'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
     C                   MOVEL     WUSEQU        WUMGDA
      *
     C                   ENDIF
     C                   GOTO      @ENVAC
      *
     C                   ENDIF
      *
      **  Set up work field used to output Full Acount
      **  in MS920 Action File.
     C                   MOVE      WUFL25        WUACCN
      *
     C                   MOVE      WUBRCA        P@BRCA
     C                   MOVE      WUCUST        P@CUST
     C                   MOVE      WUCCY         P@CCY
     C                   MOVE      WUCODE        P@CODE
     C                   MOVE      WUSEQU        P@SEQU
      *
     C                   END
      *
      **  Initialize work field used to store the Retail Number.
     C     *LIKE         DEFINE    ACNO          WUACNO
     C                   MOVE      *ZEROS        WUACNO
      *
      **  Access to Account Master Details.
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    P@RETL           10
     C                   PARM                    P@CUST            6
     C                   PARM                    P@CCY             3
     C**********         PARM                    P@CODE            4                          CGL029
     C                   PARM                    P@CODE                                       CGL029
     C                   PARM                    P@SEQU            2
     C                   PARM                    P@BRCA            3
     C     ACCNT         PARM      ACCNT         DSSDY
      *
      **  If account was not found.
     C     P@RTCD        IFNE      *BLANKS
      *
     C     WUMGID        IFEQ      *BLANKS
     C                   Z-ADD     2             A
     C                   MOVEL     'Y'           FORMAT1
     C                   MOVE      'ME00116'     WUMGID
     C                   MOVE      *BLANKS       WUMGDA
      *
     C                   ENDIF
     C                   GOTO      @ENVAC
      *
     C                   END
      *
     C     @ENVAC        ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #MT942  - Write a record in MT942 Generation Driver File     *
      *            and submit MT942 Interim Statement Message         *
      *            generation.                                        *
      *                                                               *
      *  Called By : #MREQU                                           *
      *                                                               *
      *  Calls     : #MIDAM                                           *
      *                                                               *
      *****************************************************************
      *
     C     #MT942        BEGSR
      *
      **  Define Account Reference.
     C                   MOVE      *BLANKS       STR
     C                   MOVEA     WUCUST        STR(1)
     C                   MOVEA     WUCCY         STR(7)
     C                   MOVEA     WUCODE        STR(10)
     C**********         MOVEA     WUSEQU        STR(14)                                      CGL029
     C                   MOVEA     WUSEQU        STR(20)                                      CGL029
      *
      **  Define Key List to access to MG MT942 Generation Driver File.
     C     KGLMR94       KLIST
     C                   KFLD                    KNWRK
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KNATY
     C                   KFLD                    KDSTN
     C                   KFLD                    KMTYP
      *
      **  Access to MG MT941/2 Generation Driver File
     C                   MOVE      WUMTYP        KMTYP
      *
     C                   MOVEL     'MT920   '    MRSORQ
     C                   MOVEL     N4NWRK        MRNWRK
     C                   MOVEL     N4BRCA        MRBRCA
     C                   MOVEL     N4CNUM        MRCNUM
     C                   MOVEL     N4CCY         MRCCY
     C                   MOVEL     N4ACCD        MRACCD
     C                   MOVEL     N4ACSQ        MRACSQ
     C                   MOVEL     N4DSTN        MRDSTN
     C                   MOVEL     N4NATY        MRNATY
     C                   MOVEL     WUMTYP        MRMTPY
     C                   MOVEL (P) 'WAITING'     MRSTAT
     C                   Z-ADD     BJRDNB        MRSDTE
     C                   TIME                    WKTIME            6 0
     C                   MOVEL     WKTIME        MRSTIM
     C                   Z-ADD     BJRDNB        MRRDTE
     C                   MOVEL     'IMED'        MRSRTIM
     C                   Z-ADD     0             MRMGDT
     C                   MOVEL     *BLANKS       MRMGTM
     C                   MOVEL     WURREF        MRRREF
     C                   MOVEL     N4NWRK        MRRNWK
      *
     C     MRMTPY        IFEQ      WUT941
     C                   MOVEL     N41MI1        MRMIO1
     C                   MOVEL     N41MI2        MRMIO2
     C                   MOVEL     N41MI3        MRMIO3
     C                   MOVEL     N41MI4        MRMIO4
     C                   MOVEL     N41MI5        MRMIO5
     C                   MOVEL     N41MI6        MRMIO6
     C                   ENDIF
      *
     C     MRMTPY        IFEQ      WUT942
     C                   MOVEL     N42MI1        MRMIO1
     C                   MOVEL     N42MI2        MRMIO2
     C                   MOVEL     N42MI3        MRMIO3
     C                   MOVEL     N42MI4        MRMIO4
     C                   MOVEL     N42MI5        MRMIO5
     C                   MOVEL     N42MI6        MRMIO6
     C                   ENDIF
      *
     C                   MOVEL     WUAC35        MRFL25
     C*
      **  Convert Debit Floor Limit Amounts from SWIFT
      **  Format to Midas Format.
     C                   MOVE      WUDAMT        P@AMNT
     C                   MOVE      WUDCCY        P@CCY
     C                   EXSR      #MIDAM
     C                   MOVE      P@MIDA        MR2FLD
     C                   MOVE      *BLANKS       WUDAMT
     C                   MOVE      *BLANKS       WUDCCY
      *
      **  Convert Credit Floor Limit Amounts from SWIFT
      **  Format to Midas Format.
     C                   MOVE      WUCAMT        P@AMNT
     C                   MOVE      WUCCCY        P@CCY
     C                   EXSR      #MIDAM
     C                   MOVE      P@MIDA        MR2FLC
     C                   MOVE      *BLANKS       WUCAMT
     C                   MOVE      *BLANKS       WUCCCY
      *
     C                   MOVEL     MIR           MRIMIR
      *
      **  Write the record.
     C                   WRITE     GLMR94D0
      *
     C     @EN942        ENDSR
      /EJECT
      *****************************************************************
      *  #MIDAM  - Subroutine to convert amount from SWIFT format     *
      *              to Midas format.                                 *
      *                                                               *
      *  Called by : - #MT942                                         *
      *                                                               *
      *  Calls     :                                                  *
      *                                                               *
      *****************************************************************
      *
     C     #MIDAM        BEGSR
      *
     C                   CALL      'ZM1340'                             99
     C                   PARM                    P@AMNT           16
     C                   PARM                    P@CCY             3
     C                   PARM      'A'           P@TYPE            1
     C                   PARM      *BLANKS       P@MIDA           16
     C                   PARM      *BLANKS       P@ERRC            1
     C                   PARM      *ZERO         P@GNMDP           1
      *
      **  If call ends in error (program not found),
      **  handle Database Error.
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'ZM1340'      DBFILE                         ***************
     C                   MOVEL     '*PGM'        DBKEY                          * DB ERROR 08 *
     C                   Z-ADD     08            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   END
      *
      **  If an error occurred while running program,
      **  handle Database Error.
     C     P@ERRC        IFEQ      'Y'
     C     *LOCK         IN        LDA
     C     P@CCY         CAT       '-':0         DBKEY
     C                   MOVEL     'ZM1340'      DBFILE                         ***************
     C                   CAT       P@AMNT:0      DBKEY                          * DB ERROR 09 *
     C                   Z-ADD     09            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   END
      *
      ** Suppress coma & decimal point.
      *
     C                   EVAL      StCheck = 1                                  Start Check
     C                   EVAL      StResul = 1                                  Start Result
     C                   EVAL      Result  = *BLANKS                            Result
      *
      ** Do until the end of the field or until the first blanks character
      *
     C                   DOU       CurPos > %LEN(P@MIDA)
     C                             OR %SUBST(P@MIDA:CurPos:1) = *BLANKS
      *
      ** Retrieve the position of non-digit charater
      *
     C     '0123456789'  CHECK     P@MIDA:StCheckCurPos
      *
      ** If the result of check is zero, that means that all characters are digits
      *
     C                   IF        CurPos = *ZEROS
     C                   EVAL      CurPos = %LEN(P@MIDA) + 1
     C                   ENDIF
      *
      ** Retrieve length
      *
     C                   EVAL      Length = CurPos - StCheck
      *
      ** Extract the digits
      *
     C                   EVAL      %SUBST(Result:StResul:Length) =
     C                                %SUBST(P@MIDA:StCheck:Length)
      *
      ** Calcul the next position to fill in Result field
      *
     C                   EVAL      StResul = StResul + Length
      *
      ** Calcul the next start position to check
      *
     C                   EVAL      StCheck = CurPos + 1
      *
     C                   ENDDO
      *
      ** Right adjust the amount
      *
     C                   EVALR     P@MIDA = %TRIM(Result)
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #MT995  - Write a record in MT995 Generation Driver File.    *
      *                                                               *
      *  Called By : #MREQU                                           *
      *                                                               *
      *  Calls     : *none                                            *
      *                                                               *
      *****************************************************************
      *
     C     #MT995        BEGSR
      *
      **  Initialize all fields from record.
     C                   CLEAR                   MGFN95P0
     C*
     C                   MOVE      'GL'          MGMODI
      *
      **  Set up Transaction Number.
     C                   MOVE      WUSWRD        WUDATE
     C                   EVAL      MGUREF = #RtvTRNO('GL':#SWIFTDt(BJRDNB))     Build TRNO
      *
     C                   MOVEL     '995'         MGMTPY
     C                   MOVEL     STID          MGDSTN                         Sender Address
     C                   MOVEL     IXBRCA        MGBRCA                         Internal Branch
     C                   MOVEL     IXCNUM        MGDECN                         Sender Customer Nb.
     C                   MOVEL     WUNWRK        MGNWRK                         Network
     C                   MOVEL     WURREF        MGRREF                         Original reference
      *
      **  Set up Query Line 1 with Account Reference (Full
      **  Account or Retail Number extracted from MT920).
     C     FORMAT1       IFEQ      'Y'
     C     '/8/'         CAT       WUAC35:0      MGQRY1
     C                   ELSE
      *
      **  Get message text, only if Message Id. filled.
     C                   CALL      'MEC1150'                            99
     C                   PARM      WUMGID        P@MGID
     C                   PARM      WUMGFI        P@MGFI
     C                   PARM      WUMGDA        P@MGDA
     C                   PARM      *BLANKS       P@MGT1
     C                   PARM      *BLANKS       P@MGT2
      *
     C                   MOVEL     P@MGT1        MGQRY1
     C                   ENDIF
      *
     C                   MOVEL     '920'         MGTYPE
      *
     C                   MOVEL     MODE          MODEA
     C                   EVAL      MGDTOM = MODEC + MODEA
      *
      **  Write the record.
     C                   WRITE     MGFN95P0
      *
     C                   MOVEL     ':20:'        MGMTAG
     C                   MOVEL     *BLANKS       MGMFLD
     C                   MOVEL     WURREF        MGMFLD
     C                   MOVEL     'N'           MGCONT
      *
      **  Write the record.
     C                   WRITE     MGXN95P0
      *
     C                   MOVEL     ':12:'        MGMTAG
     C                   MOVEL     *BLANKS       MGMFLD
     C                   MOVEL     WUMTYP        MGMFLD
      *
      **  Write the record.
     C                   WRITE     MGXN95P0
      *
     C                   MOVEL     ':25:'        MGMTAG
     C                   MOVEL     *BLANKS       MGMFLD
     C                   MOVEL     WUAC35        MGMFLD
      *
      **  Write the record.
     C                   WRITE     MGXN95P0
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #SETD1  - Set up fields from Automatic Genaration of MT942   *
      *            Report Printer File Detail Record Format.          *
      *                                                               *
      *  Called By : #MREQU                                           *
      *                                                               *
      *  Calls     : *none                                            *
      *                                                               *
      *****************************************************************
      *
     C     #SETD1        BEGSR
      *
      **  Initialize all fields.
     C                   CLEAR                   DETAIL1
      *
      **  Type of Message Requested.
     C                   MOVE      WUMTYP        P1MTYP
      *
      **  If Full Account is not valid, use field :25: content.
     C     WUACCN        IFEQ      *BLANKS
     C                   MOVE      WUAC35        P1ACCN
      *
      **  If valid Full Account.
     C                   ELSE
     C                   MOVEA     *ALL'-'       STR
     C                   MOVEA     *ALL' '       STR(23)
     C                   MOVEA     WUBRCA        STR(1)
     C                   MOVEA     WUCUST        STR(5)
     C                   MOVEA     WUCCY         STR(12)
     C                   MOVEA     WUCODE        STR(16)
     C**********         MOVEA     WUSEQU        STR(21)                                      CGL029
     C                   MOVEA     WUSEQU        STR(27)                                      CGL029
     C                   MOVEA     STR(1)        P1ACCN
      *
      **  Retail Number.
     C     WUACNO        IFNE      *ZEROS
     C                   MOVE      WUACNO        P1ACCN
      *
     C                   END
      *
     C                   ENDIF
      *
      **  Action taken.
     C                   MOVEL     ACT(A)        P1ACTN
      *
     C                   SELECT
      *
     C     A             WHENEQ    1
     C                   CAT       P@MGT1:1      P1ACTN
      *
     C     A             WHENEQ    2
     C                   CAT       MGUREF:1      P1ACTN
     C                   CAT       ' -':0        P1ACTN
     C                   CAT       P@MGT1:1      P1ACTN
      *
      *
     C                   ENDSL
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #MEI920  - Write a record in Incoming MT920 Audit File       *
      *                                                               *
      *  Called By : #MREQU                                           *
      *                                                               *
      *  Calls     : *none                                            *
      *                                                               *
      *****************************************************************
      *
     C     #MEI920       BEGSR
      *
     C                   MOVEL     MIR           MIIMIR
     C                   MOVEL     STID          MIMFLD
     C                   MOVEL     IXTRNO        MIITRN
     C                   Z-ADD     MOTM          MIRCVT
      *
     C                   MOVEL     MODE          MODEA
     C                   EVAL      RCVDA = MODEC + MODEA
     C                   MOVEL     RCVDA         MIRCVD
      *
      **  Write the record.
     C                   WRITE     MEI920P0
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #MS920  - Write a record in Action on MT920 File.            *
      *                                                               *
      *  Called By : #MREQU                                           *
      *                                                               *
      *  Calls     : *none                                            *
      *                                                               *
      *****************************************************************
      *
     C     #MS920        BEGSR
      *
     C                   MOVEL     MIR           MPIMIR
     C                   MOVE      WUMTYP        MPMSGR
      *
     C                   MOVEL     WUAC35        MPACTR
     C     A             IFLE      2
     C                   MOVEL     MGUREF        MPM995
     C                   ELSE
     C                   MOVEL     *BLANKS       MPM995
     C                   ENDIF
     C                   MOVEL     *BLANKS       MPM94X
     C                   MOVEL     *BLANKS       MPNGEN                         Not used
     C                   MOVEL     MGQRY1        MPNAR1
     C                   MOVEL     MGQRY2        MPNAR2
     C                   MOVEL     MGQRY3        MPNAR3
     C                   MOVEL     MGQRY4        MPNAR4
     C                   MOVEL     MGQRY5        MPNAR5
     C                   MOVEL     MGQRY6        MPNAR6
      *
      **  Write the record.
     C                   WRITE     MEP920P0
      *
     C                   MOVEL     *BLANKS       MGQRY1
     C                   MOVEL     *BLANKS       MGQRY2
     C                   MOVEL     *BLANKS       MGQRY3
     C                   MOVEL     *BLANKS       MGQRY4
     C                   MOVEL     *BLANKS       MGQRY5
     C                   MOVEL     *BLANKS       MGQRY6
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #SNDMS  - send message to MOPERQ.                            *
      *                                                               *
      *  Called by : Main Processing.                                 *
      *                                                               *
      *  Calls     : *none                                            *
      *                                                               *
      *****************************************************************
     C     #SNDMS        BEGSR
      *
      **  Send message to Message Queue MOPERQ.
     C                   CALL      'AOCREPT'                            99
     C                   PARM      WUMGID        P@MGID            7
     C                   PARM      WUMGFI        P@MGFI           10
     C                   PARM      *BLANKS       P@MGLI           10
     C                   PARM      *BLANKS       P@MGDT          256
     C                   PARM      '*PRV '       P@MSGR            5
     C                   PARM      '*'           P@PRGM           10
     C                   PARM      'MOPERQ '     P@MSGQ           10
     C                   PARM      '*INFO  '     P@MTYP            7
      *
      **  If program ends abnormally, handle database Error.
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'AOCREPT '    DBFILE                         ***************
     C                   MOVEL     '*CALL '      DBKEY                          * DB ERROR 11 *
     C                   Z-ADD     11            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR  - initial processing.                                *
      *                                                               *
      *  Called at : Program Initialization Time.                     *
      *                                                               *
      *  Calls     : *none                                            *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Date Area Declaration.
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      PSProcPgm     DBPGM
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   Z-ADD     *ZEROS        DBASE
     C                   OUT       LDA
      *
      **  Define the Data Area for Run Date.
     C     *DTAARA       DEFINE                  RUNDAT
      *
      **  Retrieve Run Date Number and Multi-branch indicator.
     C                   IN        RUNDAT
      *
      **  Check System Date Format, DDMMYY or MMDDYY.
     C     AGDFF         COMP      'M'                                    98
      *
      **  Convert Run Date to SWIFT format YYMMDD.
     C     *LIKE         DEFINE    P@DATE        WUSWRD
     C                   Z-ADD     AGRDNB        P@DAY
     C                   CALL      'ZM0060'
     C                   PARM                    P@DAY             5 0
     C                   PARM                    P@DATE            6
     C                   MOVE      P@DATE        WUSWRD
      *
      **  Access to Bank Details to retrieve Midas Run Date,
      **  Report Title and Single Branch Code.
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  If Bank Details do not exist, handle database Error.
     C     P@RTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         ***************
     C                   MOVEL     '*FIRST'      DBKEY                          * DB ERROR 12 *
     C                   Z-ADD     12            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      **  Call access program for Retail details.
     C                   CALL      'AORETLR0'
     C                   PARM      '*MSG   '     P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDRETL        PARM      SDRETL        DSFDY
      *
      **  If Retails Details do not exist, handle database Error.
     C     P@RTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDRETLPD'    DBFILE                         ***************
     C                   MOVEL     '*FIRST'      DBKEY                          * DB ERROR 13 *
     C                   Z-ADD     13            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      **  If Retail Number required in the system.
     C     BMRANR        COMP      'Y'                                    61
      *
      **  Access Switchable Feature Details to check if
      **  feature CFT004 is switched on.
     C                   MOVE      'N'           CFT004            1
     C                   CALL      'AOSARDR0'                           90
     C                   PARM      '*MSG   '     P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      'CFT004'      P@SARD            6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      **  If program ended Abnormally, handle Database Error.
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CFT004
     C                   ENDIF
      *
      **  Define work field used to check if Error Report
      **  has been already opened.
     C                   MOVE      'N'           WUOPP1            1
      *
      **  Define work fields used to retrieve message text.
     C     *LIKE         DEFINE    P@MGFI        WUMGFI
     C     *LIKE         DEFINE    P@MGID        WUMGID
     C     *LIKE         DEFINE    P@MGDA        WUMGDA
     C                   MOVEL     'MEMSG'       WUMGFI
      *
      **  Setup field for 'CRLF', used in SCAN checking to determine
      **  delimiters for Block data strings.
     C                   BITOFF    '01236'       WUCHR1
     C                   BITON     '457'         WUCHR1
     C                   BITOFF    '01346'       WUCHR2
     C                   BITON     '257'         WUCHR2
      *
      **  Setup Block 4 delimiters.
      *
      **  Setup delimiters WUTAGB - start of tag within message block.
     C                   MOVE      ':'           WUCHR3
     C     *LIKE         DEFINE    WUCRLF        WUTAGB
     C                   MOVE      WUCRLF        WUTAGB
      *
      **  Setup delimiter WUBLKE - end of Block 4:
     C                   MOVE      '-'           WUCHR3
     C     *LIKE         DEFINE    WUCRLF        WUBLKE
     C                   MOVE      WUCRLF        WUBLKE
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #RCFP1  - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *  Called by : #MREQU                                           *
      *                                                               *
      *  Calls     : pgm ZSFILE                                       *
      *                                                               *
      *****************************************************************
      *
     C     #RCFP1        BEGSR
      *
      **  Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ               5
     C                   PARM                    SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
      **  If Error occurs during ZSFILE processing, then return to the
      **  Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  #RCFAU  - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *  Called by : #AUDIT                                           *
      *                                                               *
      *  Calls     : pgm ZSFILE                                       *
      *                                                               *
      *****************************************************************
      *
     C     #RCFAU        BEGSR
      *
      **  Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      **  If Error occurs during ZSFILE processing, then return to the
      **  Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  #AUDIT  - Subroutine to Output Audit report.                 *
      *                                                               *
      *  Called By : Main processing                                  *
      *              *PSSR                                            *
      *                                                               *
      *  Calls     : #RCFAU                                           *
      *                                                               *
      *****************************************************************
      *
     C     #AUDIT        BEGSR
      *
      **  Ensure Audit Report Spool File Recorded by RCF.
     C                   EXSR      #RCFAU
      *
      **  Output Report Header and File Controls.
      *
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      **  If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
      *
     C                   ELSE
      *
      **  Or, if no records read, Output "No Details" message.
      *
     C     AU942R        IFEQ      0
     C                   WRITE     NODTLS
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      *  Calls     : #AUDIT                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   MOVEL     '*ERROR*'     P@RTNC
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
      **  If subroutine automatically called.
     C     *LOCK         IN        LDA
     C                   MOVE      PSProcPgm     DBPGM
     C     DBFILE        IFEQ      *BLANKS
     C                   MOVEL     WUDB99        DBKEY
     C                   MOVEL     PSLastFile    DBFILE
     C                   Z-ADD     15            DBASE
      *
     C                   END
     C                   OUT       LDA
      *
     C                   DUMP
      *
     C                   SETON                                        U7U8LR
     C                   EXSR      #AUDIT
      *
     C                   ENDIF
      *
      **  If *PSSR already run, then just end the program here.
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
      ********************************************************************
** ACT
No Generation -
Generation of MT995 TRN n°
Generation of MT942 requested
Generation of MT941 requested
