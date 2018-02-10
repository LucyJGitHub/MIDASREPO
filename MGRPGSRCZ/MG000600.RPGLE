     H DEBUG FTRANS
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MG Format Commodity Trade(Consolidate Fixes)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation                                   *
      *                                                               *
      *  MG000600  - Midas MG Format Commodity Trade Confirmation     *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CSW216             Date 14Mar16               *
      *                 MD035515           Date 19Aug15               *
      *                 MD033754           Date 21Apr15               *
      *                 CGL165             Date 17Feb15               *
      *                 MD026953           Date 25Nov14               *
      *                 MD030922           Date 25Nov14               *
      *                 MD030880           Date 25Nov14               *
      *                 CSW214             Date 25Nov14               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 MD024078           Date 13Dec13               *
      *                 MD024068           Date 12Dec13               *
      *                 MD022425           Date 03Jun13               *
      *                 AR1097200          Date 05Apr13               *
      *                 AR1097109          Date 04Apr13               *
      *                 AR1097406          Date 27Mar13               *
      *                 AR1094963          Date 12Mar13               *
      *                 AR1053647          Date 06Nov12               *
      *                 CMG003  *CREATE    Date 04Oct12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CSW216 - SWIFT Changes 2016                                  *
      *  MD035515 - No MT600 generated if branch internal customer is *
      *             alphanumeric                                      *
      *  MD033754 - SWIFT MT600 not displayed in MMM even when data   *
      *             record has been successfully transmitted in       *
      *             I-series                                          *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD026953 - MGOREFPF is not updating                          *
      *  MD030922 - Line 7 displayed for field tag 72                 *
      *  MD030880 - Field 81J is generated in MT600 if the transaction*
      *             was inserted via interface                        *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  MD024078 - No field tags 83J and 87J for a trade repository  *
      *             confirmation                                      *
      *  MD024068 - Error on Code Common Reference Field Tag 22 in    *
      *             MT600 in MMM                                      *
      *  MD022425 - Additional deliveries for CSW213                  *
      *  AR1097200 - job DLC0210A in MSGW status                      *
      *  AR1097109 - No MT600 generated in Mgorefpd and MMM England   *
      *              zone; A character representation of a numeric    *
      *              value is in error                                *
      *  AR1097406 - A character representation of a numeric value is *
      *              in error                                         *
      *  AR1094963 - MT600 clashes to BF2.1                           *
      *  AR1053647 - Wrong sequence for Commodity Sold                *
      *  CMG003 - SWIFT MT600 Message Generation                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID C  F  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *    05            Error on write to PF/MGOREFPD                *
      *    06            Error on write to PF/MGOMSGPD                *
      *    10            EOF MGF600PD                                 *
      *    11            CHAIN to MGOREFL0 (TRN unique ?)             *
      *    15            Error in call to standard program (ZMxxxx)   *
      *    16            Error on delete of GDF record.               *
      *    22            LOKUP operation for determining the codeword *
      *    23            LOKUP operation for settlement code          *
      *    24            Error on call of MG5000                      *
      *    25            ConCord Interface is ON.                     *
      *    30            Feedback record not generated                *
      *    50            MG000600P1 open                              *
      *    55            Tag 53A already generated                    *
      *    U7U8          Database error                               *
      *                                                               *
     ******************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *   Main process                                                *
      *   SRINIT  - Initial process                                   *
      *   SRINTF  - Initialise non-constant fields                    *
      *   SRROUT  - Determine message routing                         *
      *   SRFMTA  - Format message detail - Sequence A                *
      *   SRFMTB  - Format message detail - Sequence B                *
      *   SRFMTC  - Format message detail - Sequence C                *
      *   SRFMTD  - Format message detail - Sequence D                *                     MD022425
      *   SRFMPY  - Format message - Cust. Extension SWIFT Details    *                     MD022425
      *   SRCODE  - Calculate codeword for fields 21/22               *
      *   SRPAYE  - Pay side field 57 (KNOWN or UNKNOWN)              *
      *   FSWAD - Format SWIFT address                                *
      *   FMT72 - Format Field 72                                     *
      *   FMT53 - Format Field 53  sequence B                         *
      *   FMTX1 - Format fields 56/57 or 86/87 for FMTB FMTC          *
      *   SRREPT  - Print incorrectly generated messages              *
      *   SROMSG  - Output correctly generated messages               *
      *   SRWREF  - Write reference record to PF/MGOREFPD             *
      *   *PSSR - Error handling                                      *
      *                                                               *
      *   NOTE:   A multiple occurrence data structure is used to     *
      *           store up the records that make up the SWIFT message *
      *           before writing the whole message to file.           *
      *           To store the records of the message, you must       *
      *           first access an OCUR record, obtain the Message Tag *
      *           & Message field data values for this OCUR record,   *
      *           then go on to the next OCUR record and continue     *
      *           this process until the SWIFT message is complete.   *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FMGF600PD  UF   E             DISK
     F                                     COMMIT
      ** MT600 Generation Driver File

     FMGOREFL0  IF   E           K DISK
     F                                     RENAME(MGOREFD0:MGREFL0)
      ** MG Message Reference by TRNO

     FMGOREFPD  O    E             DISK
     F                                     COMMIT
      ** MG Master Messages Reference File

     F***DEALS**   IF   E           K DISK    USROPN                                       AR1097200
     FDEALALL   IF   E           K DISK    USROPN                                          AR1097200
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDGF)
     F                                     IGNORE(DEALSDFF)
      ** Midas DL Deals File

     FSDCMDTL0  IF   E           K DISK
      ** Midas SD Commodity details

     FMGOMSGPD  O    E             DISK
     F                                     COMMIT
      ** MG Master Message Data File

     FDLRPIFL1  IF   E           K DISK    USROPN                                           MD024078
                                                                                            MD024078
     F***MGHISTL0  UF A E           K DISK                                                  MD022425
     FMGHISTL7  UF A E           K DISK                                                     MD022425
     F                                     COMMIT
      ** MG Transaction history file

     F/COPY WNCPYSRC,MG0600F001

     FMGOEXTPD  O    E             DISK
     F                                     COMMIT
      ** Midas MGS MG Message Data extension file

     FMG000600P1O    E             PRINTER USROPN
     F                                     OFLIND(*IN99)                                    MD022425
      ** MG Confirmation Formatting Error Report

     FMG000600AUO    E             PRINTER USROPN
      ** MG Confirmation Formatting Audit Report

     F/COPY WNCPYSRC,MG0600FFP1

      ********************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Array Containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array Containing Copyright statement

     D MSGA            S             60    DIM(9) CTDATA PERRCD(1)
      ** Array Containing Messages

     D TABS96          S             22    DIM(18) CTDATA PERRCD(1)
     D TABR96          S             10    DIM(18) ALT(TABS96)
      ** Selection Criteria for the codewrod (SWIFT96)

     D TABNST          S              2    DIM(5) CTDATA PERRCD(1)
      ** Codes indicating settlement via nostro

     D TABINT          S              2    DIM(5) CTDATA PERRCD(1)
     D/COPY WNCPYSRC,MG0300AE01
     D VALUNI          S              3    DIM(13) CTDATA PERRCD(1)
      ** Codes indicating settlement via internal

     D/COPY WNCPYSRC,MG0600E001

     D @WRK            S              1    DIM(50)
     D @BTB            S             35    DIM(6)

     D/COPY WNCPYSRC,MG0600IIP2

     D MULT            DS                  OCCURS(95)
     D  MTAG                   1      5
     D  MFLD                   6     55
     D  MERR                  56    105
      **  Multiple occurrence data structure for message

     D EXTN            DS                  OCCURS(45)
     D  MPSN                   1      2  0
     D  MTG                    3      7
     D  MCSI                   8     15
      ** Multiple occurrence data structure for extension file

     D                 DS
     D  @MTG                   1      5
     D  FLDTYP                 2      2
     D  FLDTAG                 4      4
      ** Field tag data structure

     D @TRN            DS                  OCCURS(16)
     D  @TR1                   1      2
     D  @TR2                   3      8
     D  @TR3                   9     11  0
     D  @TR4                  12     16
      **  Data structure build transaction reference number

     D @TRN1           DS                  OCCURS(16)                                       MD022425
     D  @TRN11                 1      2                                                     MD022425
     D  @TRN21                 3      8                                                     MD022425
     D  @TRN31                 9     14                                                     MD022425
     D  @TRN41                15     16  0                                                  MD022425
     D  @TRNID                 3     14                                                     MD022425
      **  Data structure build transaction reference number CSW213                          MD022425
                                                                                            MD022425
     D SEARCH          DS                  OCCURS(22)
     D  @MGST                  1      6
     D  @LSCC                  8     15
     D  @OF87                 17     17
     D  @NOST                 19     22
      **  Data structure to build key to determine codeword

     D CODEWD          DS                  OCCURS(22)
     D  CWRD                   1      8
     D  F57U                  10     10
      **  Data structure containing codeword for the new message

     D FLD2N           DS                  OCCURS(18)
     D  ZSCCY                  1      3
     D  ZSAMNT                 4     18
     D FLD3N           DS                  OCCURS(24)
     D  ZSDAT1                 1      6
     D  ZSCCY1                 7      9
     D  ZSAMN1                10     24
      **  Data structure containing codeword for FieldS 32B/32B

     D ERR3N           DS                  OCCURS(24)
     D  ZCCY                   1      3
     D  ZAMT                   5     17
      **  Erroneous currency & amounts

     D @MTAG           DS                  OCCURS(5)
     D  COLON1                 1      1
     D  FLDNO                  2      3
     D  TAG                    4      4
     D  COLON2                 5      5
      **  Data structure constructing message field tag

     D MPHAS           DS
     D  STATUS                 1      1
      **  Data structure to check MPHAS for Close of Business

     D P@IN            DS           256
     D  I@SNBR                 1      3
     D  I@DSCN                 4      9
     D  I@MTPY                10     12
     D  I@SETT                13     14  0
     D  I@CONC                15     15
     D  I@FTCS                16     16
     D  I@MMOD                17     18
      ** Data structure for input parameter

     D P@OUT           DS           256
     D  O@CNSN                 1      6  0
     D  O@SWSN                 7     18
     D  O@NWSN                19     38
     D  O@SWDS                39     49
     D  W@96CN                46     46
     D  W@BIC                 47     49
     D  O@NWDS                50     69
     D  O@NWRK                70     75
     D  O@MGSG                76     76
     D  O@MGST                77     80
     D  O@PAIN                81     81
     D  O@PCNB                82     87
     D  O@SPRS                88     90
      ** Data structure for ouput parameter

     D P@BTB           DS
     D  MGBTB1                 1     35
     D  MGBTB2                36     70
     D  MGBTB3                71    105
     D  MGBTB4               106    140
     D  MGBTB5               141    175
     D  MGBTB6               176    210

     D @HREF           DS                  OCCURS(16)
     D  HSMODI                 1      2
     D  HSTRAN                 3      8
     D  HSSEQ                  9     11
      **  Data structure for related reference

     D @HREF1          DS                  OCCURS(16)                                       MD022425
     D  H1MODI                 1      2                                                     MD022425
     D  H1TRAN                 3      8                                                     MD022425
     D  HSDEST                 9     14                                                     MD022425
     D  @SSEQ                 15     16                                                     MD022425
      **  Data structure for related reference CSW213                                       MD022425
                                                                                            MD022425
     D RPPT            DS                  OCCURS(5)                                        MD022425
     D  MGRJXX                 1     35                                                     MD022425
     D  MGRPXX                36     41                                                     MD022425
     D  MGRNXX                42     61                                                     MD022425
     D  MGRCXX                62     71                                                     MD022425
     D  MGRSXX                72     82                                                     MD022425
     D  MGRLXX                83    102                                                     MD022425
     D  MGRAXX               103    136                                                     MD022425
     D***MGUTXX*              137    146                                             MD022425 CSW214
     D***MGTNXX*              147    178                                             MD022425 CSW214
     D***MGTIXX*              179    179                                             MD022425 CSW214
     D***MGETXX*              180    180                                             MD022425 CSW214
     D***MGUTXX*              137    156                                               CSW214 CSW216
     D***MGTNXX*              157    188                                               CSW214 CSW216
     D***MGTIXX*              189    189                                               CSW214 CSW216
     D***MGETXX*              190    190                                               CSW214 CSW216
     D  MGUTXX               137    166                                                       CSW216
     D  MGTNXX               167    198                                                       CSW216
     D  MGTIXX               199    199                                                       CSW216
     D  MGETXX               200    200                                                       CSW216
      **  Multiple occurrence data structure for reporting party                            MD022425
                                                                                            MD022425
     D/COPY WNCPYSRC,MG0600I001

     D SDCSSW        E DS                  EXTNAME(SDCSSWPD)                                MD022425
      **  Data structure for Customer Extensions SWIFT Details                              MD022425
                                                                                            MD022425
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data structure for bank file

     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      **  Data structure for trading file

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **  Data structure for customer file

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  DFACQQ       E                     EXTFLD(QQDFAC)
      **  Data structure for branch file

     D SDBROK        E DS                  EXTNAME(SDBROKPD)
      **  Data structure for broker file

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      **  Data structure for module ICD file

     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  ACCDQQ       E                     EXTFLD(QQACCD)
      **  Data structure for nostro file

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **  Data structure for Currency File

     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      **  Data structure for message management data.

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      **  Data structure for SAR - Switchable features file

     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      **  Data structure for counterparty nostro file

     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short data structure for access programs

     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long data structure for access programs

     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** Third data structure for access programs

     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      **  Local data area

     I/COPY WNCPYSRC,MG0600IIP2

      **  Rename conflicting MGOREFL0 fields

     IMGREFL0
     I              SYTM                        MSYTM
     I              NWRK                        MNWRK
     I              SECN                        MSECN
     I              NWSN                        MNWSN
     I              DECN                        MDECN
     I              NWDS                        MNWDS
     I              MGSG                        MMGSG
     I              MGST                        MMGST
     I              F57U                        MF57U
     I              LSCC                        MLSCC
     I              HRDT                        MHRDT
     I              MGDE                        MMGDE
     I              MGTM                        MMGTM
     I              LADT                        MLADT
     I              RELD                        MRELD
     I              RELT                        MRELT
     I              CFPF                        MCFPF
     I              TODY                        MTODY
     I              CLSS                        MCLSS

     I/COPY WNCPYSRC,MG0600IIP1

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      ** Initial process

     C/COPY WNCPYSRC,MG0600CCP3

     C                   EXSR      SRINIT

     C/COPY WNCPYSRC,MG0600C012

      ** Read the first record from the MT600 extract file

     C                   READ      MGF600PD                               10

      ** Do While records found on the MT600 extract file

     C     *IN10         DOWEQ     '0'

     C/COPY WNCPYSRC,MG0600C013

      ** If DEALING MSG and NETTING access DEALS file

     C     CDL002        IFEQ      'Y'
     C     MGMODI        ANDEQ     'DL'
     C                   MOVEL     MGTNUM        KYDLNO            6 0
     C*****KYDLNO        CHAIN     DEALS                              40                   AR1097200
     C     KYDLNO        CHAIN     DEALALL                            40                   AR1097200
     C     *IN40         IFEQ      '1'
     C     RECI          OREQ      'N'                                                     AR1097200
     C                   MOVE      *BLANKS       NETBY
     C                   MOVE      *BLANKS       NETSL
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *BLANKS       NETBY
     C                   MOVE      *BLANKS       NETSL
     C                   ENDIF

      ** Initialise non-constant fields

     C                   EXSR      SRINTF

      ** Determine message routing

     C                   EXSR      SRROUT

      ** Format message detail - Sequence A

     C                   EXSR      SRFMTA

     C                   MOVE      'N'           SEQ15C            1                        MD033754
      ** Format message detail - Sequence B

     C     MGPMBC        IFEQ      'Y'
     C                   EXSR      SRFMTB
     C                   ELSE

      ** Format message detail - Sequence C

     C                   EXSR      SRFMTC
     C                   ENDIF
                                                                                            MD022425
      ** Format message detail - Sequence D                                                 MD022425
                                                                                            MD022425
     C     CSW213        IFEQ      'Y'                                                      MD022425
     C                   MOVEL     MGTTYP        KDTYP             2                        MD024078
     C                   MOVEL     MGTNUM        KDLNO            16                        MD024078
     C     RPIFKY        CHAIN     DLRPIFL1                           20                    MD024078
     C     *IN20         IFEQ      '0'                                                      MD024078
     C                   EXSR      SRFMTD                                                   MD022425
     C                   ENDIF                                                              MD024078
     C                   ENDIF                                                              MD022425

      ** Print incorrectly generated message

     C     @ERR          IFEQ      'Y'
     C                   EXSR      SRREPT
     C                   ELSE

     C/COPY WNCPYSRC,MG0600CCP5

      ** Output correctly generated message

     C                   EXSR      SROMSG

      ** If confirmation matching switched on, generate feedback record
      ** (at present only produced for dealing)

     C     BGCFMT        IFEQ      'Y'
     C     MGMODI        ANDEQ     'DL'
     C                   EXSR      CFMAT
     C                   ENDIF

     C                   ENDIF

      ** Delete the processed GDF record.

     C                   DELETE    MGF600PD                             16

      **  Error on delete of record.

     C     *IN16         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '001'         DBASE
     C                   MOVEL     MGTNUM        DBKEY
     C                   MOVEL     'MGF600PD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      **  Update sequence numbers on transaction record
      **  if no errors have occurred

     C     @ERR          IFNE      'Y'
     C     MGACMI        IFEQ      'Y'                                                      MD022425
     C                   CALL      'MG5000'                             24                  MD022425
     C                   PARM      MGTTYP        @MODI             2                        MD022425
     C                   PARM      MGTNUM        @TRAN            15                        MD022425
     C                   PARM      'CE'          @PROG             2                        MD022425
     C                   PARM      'U'           @MODE             1                        MD022425
     C                   PARM      *ZEROS        MGLSWC            3 0                      MD022425
     C                   PARM      *ZEROS        MGLSWS            3 0                      MD022425
     C                   PARM      *BLANKS       @ERCD             1                        MD022425
     C                   ELSE                                                               MD022425
     C                   CALL      'MG5000'                             24
     C                   PARM      MGMODI        @MODI             2
     C                   PARM      MGTNUM        @TRAN            15
     C                   PARM      'CE'          @PROG             2
     C                   PARM      'U'           @MODE             1
     C                   PARM      *ZEROS        MGLSWC            3 0
     C                   PARM      *ZEROS        MGLSWS            3 0
     C                   PARM      *BLANKS       @ERCD             1
     C                   ENDIF                                                              MD022425

      **  Error on access for sequence number

     C     @ERCD         IFEQ      'Y'
     C     *LOCK         IN        LDA
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      **  Program missing on call

     C     *IN24         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '002'         DBASE
     C                   MOVE      'MG5000'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF

     C     *LOCK         IN        LDA
     C                   MOVEL     'MG000600'    DBPGM
     C                   OUT       LDA

     C/COPY WNCPYSRC,MG0600C023

      ** COMIT all changes since no error on writing the message

     C                   COMMIT

      ** Read next MT600 extract record

     C                   READ      MGF600PD                               10

     C                   ENDDO

      ** Write end of report, only if the printer file is open

     C     *IN50         IFEQ      '1'
     C                   WRITE     EOREPT
     C                   ENDIF

     C/COPY WNCPYSRC,MG0600C034

     C                   SETON                                        LR

      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   SRINIT - Inital process                                     *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR

     C                   MOVEA     CPY@          BIS@             80

     C/COPY WNCPYSRC,MG0600C014

      ** Set up LDA

     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'MG000600'    DBPGM
     C                   MOVE      *BLANKS       DBASE
     C                   OUT       LDA

      ** Set up MPHAS data area

     C     *DTAARA       DEFINE                  MPHAS
     C     *LOCK         IN        MPHAS
     C                   MOVE      STATUS        COB               1
     C                   OUT       MPHAS

     C     HSKEY         KLIST
     C                   KFLD                    MGMODI
     C                   KFLD                    HSTRAN
     C                   KFLD                    HSDEST                                     MD022425
     C                   KFLD                    HSMTPY

      ** Access SDBANKPD for report title

     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '003'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access SDTRADPD for trading information

     C                   CALL      'AOTRADR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDTRAD        PARM      SDTRAD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '004'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDTRADPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access SDMMODPD for modules available

     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '005'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access SDMGMEPD for message management data.

     C                   CALL      'AOMGMER0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMGME        PARM      SDMGME        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '006'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDMGMEPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Switchable Features file for

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW012'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVE      '007'         DBASE
     C                   MOVEL     @SARD         DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CSW012            1
     C                   ELSE
     C                   MOVEL     'N'           CSW012
     C                   ENDIF
     C/COPY WNCPYSRC,MG0600C018

      ** Access SAR Details file to determine if CDL002 installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CDL002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '023'         DBASE
     C                   MOVEL     @RTCD         DBKEY
     C                   SETON                                        U7U8
     C                   EXSR      *PSSR
     C                   ENDIF
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CDL002            1
     C**********         OPEN      DEALS                                                   AR1097200
     C                   OPEN      DEALALL                                                 AR1097200
     C                   MOVEL     'TO BE '      NETTXT           12
     C                   MOVE      'NETTED'      NETTXT
     C                   ENDIF

      **  Initialise constant fields

     C                   MOVE      *LOVAL        CR                1
     C                   BITON     '457'         CR
     C                   MOVE      *LOVAL        LF                1
     C                   BITON     '257'         LF
     C                   MOVEL     CR            CRLF              2
     C                   MOVE      LF            CRLF
     C                   MOVE      *BLANKS       @TR4
     C                   MOVE      ':'           COLON1
     C                   MOVE      ':'           COLON2

      ** CRLF Control Character for message data records

     C                   MOVE      CRLF          CTRC

      ** Convert run date to YYMMDD, for Message Generation Date

     C                   CALL      'ZM0060'                             15
     C                   PARM      BJRDNB        ZMDAY             5 0
     C                   PARM                    ZMDATE            6

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '008'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0060'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      ZMDATE        MGDE

      ** Set-up Message Generation Century flag

     C                   MOVEL     MGDE          YY                2 0
     C     YY            IFLT      72
     C                   MOVE      '2'           CIND
     C                   ELSE
     C                   MOVE      '1'           CIND
     C                   ENDIF

      ** Convert history retention date to YYMMDD

     C     BJRDNB        ADD       ENDSMN        ZMDAY
     C                   CALL      'ZM0060'                             15
     C                   PARM                    ZMDAY
     C                   PARM                    ZMDATE            6

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '009'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0060'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      ZMDATE        @HRDT             6

      ** Check if SWIFT Changes 1996 (CSW096) is installed

     C                   CALL      'SWIFT96'
     C                   PARM      *BLANKS       @RTCD             7

     C     @RTCD         IFEQ      'CSW096'
     C                   MOVE      'Y'           CSW096            1
     C                   ELSE
     C                   MOVE      'N'           CSW096
     C                   ENDIF

      ** Access Switchable Features file for CEU003

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU003'      @SARD             6
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CEU003            1
     C                   ELSE
     C                   MOVEL     'N'           CEU003
     C                   ENDIF

     C/COPY WNCPYSRC,MG0600AC24

      ** Check if switchable feature CDL008 is switched on

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CDL008'      DBKEY
     C                   MOVEL     '026'         DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CDL008            1
     C                   ELSE
     C                   MOVE      'N'           CDL008
     C                   ENDIF

      ** Check if switchable feature CSW024 is switched on

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW024'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CSW024'      DBKEY
     C                   MOVEL     '028'         DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSW024            1
     C                   ELSE
     C                   MOVE      'N'           CSW024
     C                   ENDIF

      ** Access Switchable features file to see if ConCord is switched
      ** ON.

     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     RTCDA             7
     C                   PARM      '*VERIFY'     RTCDB             7
     C                   PARM      'CCF001'      RTCDC             6

     C     RTCDA         IFEQ      *BLANK
     C                   MOVE      *ON           *IN25
     C                   ENDIF
      *                                                                                     MD024078
      ** Setup Key Field for DLRPIFPD                                                       MD024078
      *                                                                                     MD024078
     C     RPIFKY        KLIST                                                              MD024078
     C                   KFLD                    KDTYP                                      MD024078
     C                   KFLD                    KDLNO                                      MD024078
      *                                                                                     MD024078
      ** Check if switchable feature CSW213 is switched on                                  MD024078
      *                                                                                     MD024078
     C                   CALL      'SWIF2013'                                               MD024078
     C                   PARM      *BLANKS       @RTCD                                      MD024078
      *                                                                                     MD024078
     C     @RTCD         IFEQ      'CSW2013'                                                MD024078
     C                   MOVE      'Y'           CSW213            1                        MD024078
     C                   OPEN      DLRPIFL1                                                 MD024078
     C                   ELSE                                                               MD024078
     C                   MOVE      'N'           CSW213                                     MD024078
     C                   ENDIF                                                              MD024078
                                                                                              CSW214
      ** Check if switchable feature CSW214 is switched on                                    CSW214
                                                                                              CSW214
     C                   CALL      'SWIF2014'                                                 CSW214
     C                   PARM      *BLANKS       PRTCD             7                          CSW214
                                                                                              CSW214
     C                   MOVEL     'N'           CSW214            1                          CSW214
     C                   IF        PRTCD = 'CSW2014'                                          CSW214
     C                   MOVEL     'Y'           CSW214                                       CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   SRINTF - Initalise non-constant fields                      *
      *                                                               *
      *****************************************************************
     C     SRINTF        BEGSR

     C                   MOVE      *BLANKS       AWBA6             6
     C                   MOVEL     MGAWBA        AWBA6

     C                   MOVE      *BLANKS       TRNO
     C                   MOVE      '      '      NWRK
     C**********         Z-ADD     0             SECN                                      AR1094963
     C                   MOVE      *BLANKS       SECN                                      AR1094963
     C                   MOVE      *BLANKS       NWSN
     C**********         Z-ADD     0             DECN                                      AR1094963
     C                   MOVE      *BLANKS       DECN                                      AR1094963
     C                   MOVE      *BLANKS       NWDS
     C                   MOVE      *BLANKS       MGSG
     C                   MOVE      *BLANKS       MGST
     C                   MOVE      *BLANKS       LSCC
     C                   MOVE      *BLANKS       F57U
     C                   Z-ADD     0             MGTM
     C                   Z-ADD     0             LATM
     C                   MOVE      *BLANKS       RELD
     C                   Z-ADD     0             RELT
     C                   MOVE      *BLANKS       AMTS
     C                   MOVE      *BLANKS       SVDT
     C                   MOVE      *BLANKS       CINDV
     C                   MOVE      *BLANKS       CLSS

     C                   MOVE      *BLANKS       @TRN
     C                   MOVE      *BLANKS       @ERR              1
     C                   MOVE      *BLANKS       STELX            10
     C                   MOVE      *BLANKS       SSTTX            12
     C                   MOVE      *BLANKS       SCRNM            20
     C                   MOVE      *BLANKS       SPCNB             6
     C                   MOVE      *BLANKS       SPAIN             1
      *                                                                                     MD024078
     C                   MOVE      *BLANKS       WRKMRJ                                     MD024078
     C                   MOVE      *BLANKS       WRKMRP                                     MD024078
     C                   MOVE      *BLANKS       WRKMRN                                     MD024078
     C                   MOVE      *BLANKS       WRKMRC                                     MD024078
     C                   MOVE      *BLANKS       WRKMRS                                     MD024078
     C                   MOVE      *BLANKS       WRKMRL                                     MD024078
     C                   MOVE      *BLANKS       WRKMRA                                     MD024078

     C/COPY WNCPYSRC,MG0600C025

      ** Initialise field to indicate that the current position
      ** for outputting field :72:, is at line 1

     C                   MOVE      'N'           LINE2             1

      ** Clear multiple occurrence data structure

     C                   Z-ADD     1             X                 2 0
     C     X             OCCUR     MULT

     C     X             DOWLE     95
     C     MULT          ANDNE     *BLANKS
     C                   MOVE      *BLANKS       MULT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDDO

      ** Clear multiple occurrence DS for the extension file.

     C                   Z-ADD     1             V                 2 0
     C     V             OCCUR     EXTN
     C     V             DOWLE     20
     C     MCSI          ANDNE     *BLANKS
     C                   Z-ADD     *ZEROS        MPSN
     C                   MOVE      *BLANKS       MTG
     C                   MOVE      *BLANKS       MCSI
     C                   ADD       1             V
     C     V             OCCUR     EXTN
     C                   ENDDO
     C                   Z-ADD     0             V

      ** Check if switchable feature CSW213 is switched on                                  MD022425
                                                                                            MD022425
     C**********         CALL      'SWIF2013'                                      MD022425 MD024078
     C**********         PARM      *BLANKS       @RTCD                             MD022425 MD024078
     C*****@RTCD         IFEQ      'CSW2013'                                       MD022425 MD024078
     C**********         MOVE      'Y'           CSW213            1               MD022425 MD024078
     C**********         ELSE                                                      MD022425 MD024078
     C**********         MOVE      'N'           CSW213                            MD022425 MD024078
     C**********         ENDIF                                                     MD022425 MD024078
      **********                                                                   MD022425 MD024078
      ** Obtain sequence numbers from transaction record

     C     MGACMI        IFEQ      'Y'                                                      MD022425
     C                   CALL      'MG5000'                             24                  MD022425
     C                   PARM      MGTTYP        @MODI             2                        MD022425
     C                   PARM      MGTNUM        @TRAN            15                        MD022425
     C                   PARM      'CE'          @PROG             2                        MD022425
     C                   PARM      *BLANKS       @MODE             1                        MD022425
     C                   PARM      *ZEROS        MGLSWC            3 0                      MD022425
     C                   PARM      *ZEROS        MGLSWS            3 0                      MD022425
     C                   PARM      *BLANKS       @ERCD             1                        MD022425
     C                   ELSE                                                               MD022425
     C                   CALL      'MG5000'                             24
     C                   PARM      MGMODI        @MODI             2
     C                   PARM      MGTNUM        @TRAN            15
     C                   PARM      'CE'          @PROG             2
     C                   PARM      *BLANKS       @MODE             1
     C                   PARM      *ZEROS        MGLSWC            3 0
     C                   PARM      *ZEROS        MGLSWS            3 0
     C                   PARM      *BLANKS       @ERCD             1
     C                   ENDIF                                                              MD022425

      ** Error on access for sequence number

     C     @ERCD         IFEQ      'Y'
     C     *LOCK         IN        LDA
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Program missing on call

     C     *IN24         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '010'         DBASE
     C                   MOVE      'MG5000'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C     *LOCK         IN        LDA
     C                   MOVEL     'MG000600'    DBPGM
     C                   OUT       LDA

      **  To ensure field 53 if generated when required

     C                   SETOFF                                       55

     C                   ENDSR
     C/EJECT                                                                                MD024078
      *****************************************************************                     MD024078
      *                                                               *                     MD024078
      *  GETRCL- Get record length                                    *                     MD024078
      *                                                               *                     MD024078
      *****************************************************************                     MD024078
      *                                                                                     MD024078
     C     GETRCL        BEGSR                                                              MD024078
      *                                                                                     MD024078
     C                   CALL      'UTGETRCDLN'                                             MD024078
     C                   PARM                    P#RTCD           10                        MD024078
     C                   PARM                    P#RCDL            5 0                      MD024078
     C                   PARM                    P#FILN           10                        MD024078
     C                   PARM      '*LIBL'       P#LIBN           10                        MD024078
      *                                                                                     MD024078
     C     P#RTCD        IFNE      *BLANK                                                   MD024078
     C                   EXSR      *PSSR                                                    MD024078
     C                   ENDIF                                                              MD024078
      *                                                                                     MD024078
     C                   ENDSR                                                              MD024078
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   SRROUT - determine message routing                          *
      *                                                               *
      *****************************************************************
     C     SRROUT        BEGSR

     C                   MOVE      MGBRCA        I@SNBR
     C                   MOVE      *BLANKS       I@DSCN
     C                   MOVE      MGCNUM        I@DSCN
     C                   MOVE      '600'         I@MTPY
     C                   MOVE      'Y'           I@CONC
     C                   Z-ADD     0             I@SETT
     C                   MOVE      *BLANK        I@FTCS
     C                   MOVE      MGMODI        I@MMOD

      ** Below are two copy sources intended for setting up the custom
      ** parameter (P@ZZ) in the call to MG9900.
      ** One (MG9900CALL) is in ALL MG generation programs and is for use
      ** when a change is required to all of them.
      ** The other is only in this program.

     C/COPY WNCPYSRC,MG9900CALL
     C/COPY WNCPYSRC,MG0600ROUT

     C                   CALL      'MG9900'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    P@IN
     C                   PARM      *BLANKS       P@OUT
     C                   PARM                    P@ZZ            256

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '011'         DBASE
     C                   MOVEL     '*CALL  '     DBKEY
     C                   MOVEL     'MG9900'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      O@NWRK        NWRK
     C**********         Z-ADD     O@CNSN        SECN                                      AR1094963
     C                   MOVEL     O@CNSN        SECN                                      AR1094963
     C                   MOVE      O@NWSN        NWSN
     C**********         Z-ADD     MGCNUM        DECN                                      AR1094963
     C                   MOVEL     MGCNUM        DECN                                      AR1094963
     C                   MOVE      O@NWDS        NWDS
     C                   MOVE      O@MGSG        MGSG
     C                   MOVE      O@MGST        MGST
     C                   MOVE      O@PCNB        SPCNB
     C                   MOVE      O@PAIN        SPAIN
     C                   ENDIF

     C/COPY WNCPYSRC,MG0600C026

     C                   MOVEL     *BLANKS       @KEY1
     C     MGACMI        IFEQ      'Y'                                                      MD022425
     C                   MOVEL     MGPTYA        @KEY1                                      MD022425
     C                   ELSE                                                               MD022425
     C                   MOVEL     MGCNUM        @KEY1
     C                   ENDIF                                                              MD022425
     C                   CALL      'AOCUSTR1'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      SDCUST        DSLDY

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'AOCUSTR0'    DBFILE
     C                   MOVE      '029'         DBASE
     C                   MOVEL     MGCNUM        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      BBCNA1        DSCNA1           35
     C                   MOVE      BBCNA2        DSCNA2           35
     C                   MOVE      BBCNA3        DSCNA3           35
     C                   MOVE      BBCNA4        DSCNA4           35
     C                   MOVE      BBCORP        DSCORP            1
     C                   MOVE      BBCBEI        DSCBEI           11
     C                   MOVE      BBRI01        DSRI01           40
     C                   MOVE      BBRI02        DSRI02           40
     C                   MOVE      BBRI03        DSRI03           40
     C                   MOVE      BBRI04        DSRI04           40
     C                   MOVE      BBRI05        DSRI05           40
     C                   MOVE      BBFUND        DSFUND           34
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   SRFMTA - Format message detail - Sequence A                 *
      *                                                               *
      *****************************************************************
     C     SRFMTA        BEGSR
     C                   MOVEL     *BLANKS       MGUNIT            3
     C                   MOVEL     *BLANKS       MGDENO            4
     C                   MOVEL     *BLANKS       MGFORM            8
     C                   MOVEL     *BLANKS       MGDELV            3
     C                   MOVEL     *BLANKS       MGALOC            5
     C                   MOVEL     *BLANKS       MGCREF           29
     C                   MOVEL     *BLANKS       MGCMSH           10
     C                   MOVEL     *BLANKS       MGCMUD           30

     C                   Z-ADD     *ZERO         X

      ** Field :15A: General Information

     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      ':15A:'       MTAG
     C                   MOVEL     *BLANK        MFLD

      ** Field :20:  Transaction reference number

     C                   ADD       1             X
     C     X             OCCUR     MULT
                                                                                            MD022425
     C     MGACMI        IFEQ      'Y'                                                      MD022425
     C                   MOVE      MGMODI        @TRN11                                     MD022425
     C                   MOVEL     MGTNUM        @TRN21                                     MD022425
     C                   MOVEL     MGCNUM        @TRN31                                     MD022425
     C     MGLSWS        ADD       1             @TRN41                                     MD022425
     C                   MOVE      ':20: '       MTAG                                       MD022425
     C                   MOVEL     @TRN1         MFLD                                       MD022425
                                                                                            MD022425
      ** Store the TRN of the new confirmation message                                      MD022425
                                                                                            MD022425
     C                   MOVEL     @TRN1         @TRNO            16                        MD022425
                                                                                            MD022425
     C                   ELSE                                                               MD022425
     C                   MOVE      MGMODI        @TR1
     C                   MOVEL     MGTNUM        @TR2
     C     MGLSWS        ADD       1             @TR3

     C/COPY WNCPYSRC,MG0600C027

     C                   MOVE      ':20: '       MTAG
     C                   MOVEL     @TRN          MFLD

      ** Store the TRN of the new confirmation message

     C                   MOVEL     @TRN          @TRNO            16
     C                   ENDIF                                                              MD022425

      ** Determine if the TRN is unique

     C     @TRNO         CHAIN     MGREFL0                            11

      ** Cannot have duplicate keys, hence error

     C     *IN11         IFEQ      '0'
     C                   MOVEL     MSGA(8)       MERR
     C                   MOVE      'Y'           @ERR
     C                   ENDIF

      ** Field :21:  Related reference
      ** Determine the message codeword

     C                   EXSR      SRCODE

     C/COPY WNCPYSRC,MG0600AC28

     C                   ADD       1             X
     C     X             OCCUR     MULT

     C     CWRD          IFNE      'NEW'
     C                   MOVE      MGLSWC        @TR3
     C                   MOVEL     @TRN          MFLD

     C     MGACMI        IFEQ      'Y'                                                      MD022425
     C                   MOVEL     MGCNUM        WDEST             6                        MD022425
     C                   MOVEL     @TRN1         MFLD                                       MD024078
     C                   ELSE                                                               MD022425
     C                   MOVEL     *BLANKS       WDEST                                      MD022425
     C                   ENDIF                                                              MD022425
                                                                                            MD022425
      ** Obtain transaction reference of previous MT600

     C                   MOVEL     MGTNUM        HSTRAN
     C                   MOVE      '600'         HSMTPY

     C                   MOVE      HSTRAN        @HTRN             6

     C*****HSKEY         SETGT     MGHISTL0                                                 MD022425
     C**********         READP     MGHISTL0                               56                MD022425
     C     HSKEY         SETGT     MGHISTL7                                                 MD022425
     C                   READP     MGHISTL7                               56                MD022425

     C     *IN56         IFEQ      '0'
     C     HSMODI        ANDEQ     MGMODI
     C     HSTRAN        ANDEQ     @HTRN
     C     HSDEST        ANDEQ     WDEST                                                    MD022425
     C     HSMTPY        ANDEQ     '600'
     C     MGACMI        IFEQ      'Y'                                                      MD022425
     C**********         MOVE      HSSEQ         @SSEQ                             MD022425 MD024078
     C**********         MOVEL     @HREF1        MFLD                              MD022425 MD024078
     C                   MOVEL     HSMODI        @TRN11                                     MD024078
     C                   MOVEL     HSTRAN        @TRN21                                     MD024078
     C                   MOVEL     @TRN1         MFLD                                       MD024078
     C                   ELSE                                                               MD022425
     C                   MOVEL     @HREF         MFLD
     C                   ENDIF                                                              MD022425
     C                   END

     C                   MOVE      ':21: '       MTAG
     C                   ELSE
     C                   MOVEL     'NEW'         MFLD
     C                   MOVE      ':21: '       MTAG

     C                   ENDIF

     C/COPY WNCPYSRC,MG0600C029

      ** Field :22: Code/Common Reference

     C                   ADD       1             X
     C     X             OCCUR     MULT

     C                   MOVE      *BLANKS       W22                                        MD024068
      *                                                                                     MD024068
     C                   SELECT
     C     MGCHTP        WHENEQ    'C'
     C                   MOVEL     'CANCEL'      W22              25
     C     CWRD          WHENEQ    'AMEND'
     C                   MOVEL     'COMPLETE'    W22
     C     MGTTYP        WHENEQ    'OT'
     C                   MOVEL     'EXOPTION'    W22
     C     CWRD          WHENEQ    'NEW'
     C                   MOVEL     'NEW'         W22
     C                   ENDSL

     C     MGTTYP        IFEQ      'OP'
     C     COB           ANDEQ     'C'
     C                   MOVEL     'EXOPTION'    W22
     C                   ENDIF

      ** Codeword blank

     C     CWRD          IFEQ      *BLANKS
     C                   MOVE      'Y'           @ERR
     C                   MOVEA     MSGA(7)       MERR
     C                   ENDIF

     C                   MOVEL     ':22:'        MTAG

     C/COPY WNCPYSRC,MG0600C049

     C                   MOVE      *BLANKS       ZCREF

      ** If SWIFT network, use sender & destination customer
      ** SWIFT address, and the exchange rate to produce
      ** common reference field;  Else use the message TRN

     C     NWRK          IFEQ      'SWIFT'
     C     NWRK          OREQ      'STTX'

     C     NWRK          IFEQ      'SWIFT'
     C                   MOVEL     NWSN          ZSSWI
     C                   MOVEL     NWDS          ZDSWI
     C                   ENDIF
     C/COPY WNCPYSRC,MG0600C040
     C                   MOVE      MGEXRT        ZRATE

      **  Format SWIFT common reference

     C                   CALL      'ZM0020'                             15
     C                   PARM                    ZSSWI            12
     C                   PARM                    ZDSWI            12
     C                   PARM                    ZRATE            13 8
     C                   PARM                    ZCREF            16

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '012'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0020'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF

     C     O@SWSN        IFNE      *BLANKS
     C     O@SWDS        ANDNE     *BLANKS

     C                   MOVE      MGEXRT        ZRATE
     C                   MOVEL     O@SWSN        ZSSWI
     C                   MOVEL     O@SWDS        ZDSWI

      **  Format SWIFT common reference

     C                   CALL      'ZM0020'                             15
     C                   PARM                    ZSSWI            12
     C                   PARM                    ZDSWI            12
     C                   PARM                    ZRATE            13 8
     C                   PARM                    ZCREF            16

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '013'         DBASE
     C                   MOVE      '      '      DBKEY
     C                   MOVEL     'ZM0020'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C/COPY WNCPYSRC,MG0600C041

     C                   ENDIF

     C     W22           CAT       '/':0         W22
     C     ZCREF         IFNE      *BLANKS
     C     W22           CAT       ZCREF:0       MFLD
     C                   ELSE
     C     W22           CAT       @TRNO:0       MFLD
     C                   ENDIF

      ** Field :94A: Scope of Operation

     C     CSW024        IFEQ      'Y'
     C     DSCORP        ANDEQ     'Y'
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      *BLANK        MFLD
     C                   MOVEL     'AGNT'        MFLD
     C                   MOVE      ':94A:'       MTAG
     C                   ELSE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      *BLANK        MFLD
     C                   MOVEL     'BILA'        MFLD
     C                   MOVE      ':94A:'       MTAG
     C                   ENDIF

      ** Field :82a: Party A

     C                   ADD       1             X
     C     X             OCCUR     MULT

     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      MGBRCA        @BRCD             3
     C     SDBRCH        PARM      SDBRCH        DSSDY

      ** Branch record not found - DB Error

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '014'         DBASE
     C                   MOVEL     MGBRCA        DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C**********         MOVE      *BLANKS       WBICN             6 0                      MD035515
     C                   MOVE      *BLANKS       WBICN             6                        MD035515
     C                   MOVEL     A8BICN        WBICN

     C                   MOVE      *BLANKS       ZDEST
     C                   MOVEL     WBICN         ZDEST
     C                   MOVE      *BLANKS       ACLINE
     C                   MOVE      ' '           TAG
     C                   MOVE      '82'          FLDNO
     C                   EXSR      FSWAD

      ** If corporate customer...

     C     CSW024        IFEQ      'Y'
     C     DSCORP        ANDEQ     'Y'

      ** If BEI output :87A:

     C     DSCBEI        IFNE      *BLANK
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      *BLANK        MFLD
     C                   MOVEL     DSCBEI        MFLD
     C                   MOVE      ':87A:'       MTAG

      ** If receiver party info output :87J:

     C                   ELSE
     C     DSRI01        IFNE      *BLANK
     C     DSRI02        ORNE      *BLANK
     C     DSRI03        ORNE      *BLANK
     C     DSRI04        ORNE      *BLANK
     C     DSRI05        ORNE      *BLANK

     C                   MOVE      *BLANK        DN87              1
     C     DSRI01        IFNE      *BLANK
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C     DN87          IFNE      'Y'
     C                   MOVE      ':87J:'       MTAG
     C                   MOVE      'Y'           DN87
     C                   ENDIF
     C                   MOVE      *BLANK        MFLD
     C                   MOVEL     DSRI01        MFLD
     C                   ENDIF
     C     DSRI02        IFNE      *BLANK
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C     DN87          IFNE      'Y'
     C                   MOVE      ':87J:'       MTAG
     C                   MOVE      'Y'           DN87
     C                   ENDIF
     C                   MOVE      *BLANK        MFLD
     C                   MOVEL     DSRI02        MFLD
     C                   ENDIF
     C     DSRI03        IFNE      *BLANK
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C     DN87          IFNE      'Y'
     C                   MOVE      ':87J:'       MTAG
     C                   MOVE      'Y'           DN87
     C                   ENDIF
     C                   MOVE      *BLANK        MFLD
     C                   MOVEL     DSRI03        MFLD
     C                   ENDIF
     C     DSRI04        IFNE      *BLANK
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C     DN87          IFNE      'Y'
     C                   MOVE      ':87J:'       MTAG
     C                   MOVE      'Y'           DN87
     C                   ENDIF
     C                   MOVE      *BLANK        MFLD
     C                   MOVEL     DSRI04        MFLD
     C                   ENDIF
     C     DSRI05        IFNE      *BLANK
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C     DN87          IFNE      'Y'
     C                   MOVE      ':87J:'       MTAG
     C                   MOVE      'Y'           DN87
     C                   ENDIF
     C                   MOVE      *BLANK        MFLD
     C                   MOVEL     DSRI05        MFLD
     C                   ENDIF

      ** Else output :87D:

     C                   ELSE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      ':87D:'       MTAG
     C                   MOVEL     DSCNA1        MFLD

      ** Address 2

     C     DSCNA2        IFNE      *BLANKS
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEL     DSCNA2        MFLD
     C                   ENDIF

      ** Address 3

     C     DSCNA3        IFNE      *BLANKS
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEL     DSCNA3        MFLD
     C                   ENDIF

      ** Address 4

     C     DSCNA4        IFNE      *BLANKS
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEL     DSCNA4        MFLD
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   ELSE

      ** Field :87a: Party B

     C                   ADD       1             X
     C     X             OCCUR     MULT

     C                   MOVE      *BLANKS       ZDEST
     C                   MOVEL     MGCNUM        ZDEST
     C                   MOVE      *BLANKS       ACLINE
     C                   MOVE      ' '           TAG
     C                   MOVE      '87'          FLDNO
     C                   EXSR      FSWAD

     C                   ENDIF

      ** Format Field :83a

     C/COPY WNCPYSRC,MG0600C044

     C                   EXSR      FMT83

      ** Field :30:  Trade Date (YYMMDD format)

     C                   ADD       1             X
     C     X             OCCUR     MULT
     C     CWRD          IFEQ      'NEW'
     C                   MOVE      MGTDAT        ZMDAY
     C                   ELSE
     C                   MOVE      BJRDNB        ZMDAY
     C                   ENDIF

      ** Convert Midas date to SWIFT date format

     C                   CALL      'ZM0065'                             15
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZSDATE            6
     C                   PARM                    ZSDATC            8

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '015'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0065'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVEL     ':30:'        MTAG
     C                   MOVEL     ZSDATE        MFLD

     C/COPY WNCPYSRC,MG0600C043

     C                   MOVE      *BLANKS       WCRTN
     C                   MOVE      *BLANKS       @NSKYB
     C                   MOVE      *BLANKS       @NSKYE

      ** Field :26C: Identification of the Commodity

     C                   EVAL      MGALOC = 'UNALL'
     C                   EXSR      SRBTB
     C                   Z-ADD     0             I
     C     I             DOWLT     6
     C                   ADD       1             I
     C                   MOVEL     @BTB(I)       @WRK07            7
     C                   MOVEL     @BTB(I)       @WRK10           10
     C                   MOVEL     @BTB(I)       @WRK12           12
     C                   IF        @WRK07 = '/DELIV/'
     C                   MOVE      @WRK10        MGDELV
     C                   ENDIF

     C                   IF        @WRK07 = '/ALLOC/'
     C                             AND %SUBST(@WRK12:8:5) <> *BLANKS
     C                   MOVE      @WRK12        MGALOC
     C                   ENDIF

     C                   ENDDO

     C     MGPMSC        IFEQ      'Y'
     C                   MOVE      MGPUCY        @UNITC            3
     C                   MOVE      MGPSTM        @STM
     C     @STM          LOOKUP    TABNST                                 23

     C     MGPONS        IFNE      *BLANKS
     C     *IN23         ANDEQ     '1'

      ** Use payment settlement currency to access nostro if not blank.
      ** Otherwise use sell currency.

     C     CEU003        IFEQ      'Y'
     C     MGPYCY        ANDNE     *BLANKS
     C                   MOVE      MGPYCY        @NSKYB
     C                   ELSE
     C                   MOVE      MGSLCY        @NSKYB
     C                   ENDIF
     C                   MOVEL     MGPONS        @NSKYE
     C                   ENDIF
     C                   ELSE

      ** Test if settlement via nostro

     C                   MOVE      MGSLCY        @UNITC            3
     C                   MOVE      MGRSTM        @STM              2
     C     @STM          LOOKUP    TABNST                                 23
     C     MGRONS        IFNE      *BLANKS
     C     *IN23         ANDEQ     '1'
     C     CEU003        IFEQ      'Y'
     C     MGRCCY        ANDNE     *BLANKS
     C                   MOVE      MGRCCY        @NSKYB
     C                   ELSE
     C                   MOVE      MGPUCY        @NSKYB
     C                   ENDIF
     C                   MOVEL     MGRONS        @NSKYE
     C                   ENDIF
     C                   ENDIF

     C     @NSKYE        IFNE      *BLANKS
     C                   CALL      'AONOSTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @NSKYA
     C                   PARM                    @NSKYB
     C                   PARM      *BLANKS       @NSKYC
     C                   PARM      *BLANKS       @NSKYD
     C                   PARM                    @NSKYE
     C                   PARM      *BLANKS       @KEYF
     C                   PARM      *BLANKS       @KEYG
     C                   PARM      *BLANKS       @KEYH
     C     SDNOST        PARM      SDNOST        DSFDY

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      *BLANKS       @KEY1
     C                   MOVEL     A7CUST        @KEY1

     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY

     C     '/'           CAT       BBCRTN        WCRTN            17
     C                   ELSE
     C     '/'           CAT       'UNKNOWN'     WCRTN
     C                   ENDIF
     C                   ELSE
     C     '/'           CAT       'UNKNOWN'     WCRTN
     C                   ENDIF

     C     WCRTN         CAT       '/'           WCRTN

     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @NSKYB        @KEY3             3
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   EVAL      MGCMSH = A6CYCD + '-' + A6SWCY
     C     MGCMSH        SETLL     SDCMDTL0
     C     MGCMSH        CHAIN     SDCMDTL0                           90
     C                   IF        *IN90 = '0'
     C                   EVAL      MGDENO = A6CMDN
     C                   EVAL      MGUNIT = A6CMUN
     C                   EVAL      MGFORM = A6CMFM
     C                   EVAL      MGCMUD = A6CMUD
     C     MGUNIT        LOOKUP    VALUNI                                 90
     C     *IN90         IFEQ      '0'
     C                   MOVEL     *BLANKS       MGUNIT
     C                   ENDIF
     C                   ENDIF

     C                   MOVE      *BLANKS       WMPTP

     C                   SELECT
     C     A6SWCY        WHENEQ    'XAU'
     C                   MOVEL     'GOLD'        WMPTP             8
     C     A6SWCY        WHENEQ    'XPT'
     C                   MOVEL     'PLAT'        WMPTP
     C     A6SWCY        WHENEQ    'XAG'
     C                   MOVEL     'SILV'        WMPTP
     C     A6SWCY        WHENEQ    'XPD'
     C                   MOVEL     'PALL'        WMPTP
     C     A6SWCY        WHENEQ    'XCO'
     C                   MOVEL     'COPP'        WMPTP
     C     A6SWCY        WHENEQ    'XIR'
     C                   MOVEL     'IRID'        WMPTP
     C     A6SWCY        WHENEQ    'XLE'
     C                   MOVEL     'LEAD'        WMPTP
     C     A6SWCY        WHENEQ    'XNI'
     C                   MOVEL     'NICK'        WMPTP
     C     A6SWCY        WHENEQ    'XOS'
     C                   MOVEL     'OSMI'        WMPTP
     C     A6SWCY        WHENEQ    'XOT'
     C                   MOVEL     'OTHR'        WMPTP
     C     A6SWCY        WHENEQ    'XPO'
     C                   MOVEL     'POIL'        WMPTP
     C     A6SWCY        WHENEQ    'XRH'
     C                   MOVEL     'RHOD'        WMPTP
     C     A6SWCY        WHENEQ    'XRU'
     C                   MOVEL     'RUTH'        WMPTP
     C     A6SWCY        WHENEQ    'XST'
     C                   MOVEL     'STEE'        WMPTP
     C     A6SWCY        WHENEQ    'XTN'
     C                   MOVEL     'TINA'        WMPTP
     C     A6SWCY        WHENEQ    'XTI'
     C                   MOVEL     'TITA'        WMPTP
     C     A6SWCY        WHENEQ    'XZN'
     C                   MOVEL     'ZINC'        WMPTP
     C     A6SWCY        WHENEQ    'CA1'
     C                   MOVEL     'AMEG50'      WMPTP
     C     A6SWCY        WHENEQ    'CA2'
     C                   MOVEL     'AMEG25'      WMPTP
     C     A6SWCY        WHENEQ    'CA3'
     C                   MOVEL     'AMEG10'      WMPTP
     C     A6SWCY        WHENEQ    'CA4'
     C                   MOVEL     'AMEG5 '      WMPTP
     C     A6SWCY        WHENEQ    'CU1'
     C                   MOVEL     'ANUG1/1'     WMPTP
     C     A6SWCY        WHENEQ    'CU2'
     C                   MOVEL     'ANUG1/2'     WMPTP
     C     A6SWCY        WHENEQ    'CU3'
     C                   MOVEL     'ANUG1/4'     WMPTP
     C     A6SWCY        WHENEQ    'CU4'
     C                   MOVEL     'ANUG1/10'    WMPTP
     C     A6SWCY        WHENEQ    'CB1'
     C                   MOVEL     'BRIT1/1'     WMPTP
     C     A6SWCY        WHENEQ    'CB2'
     C                   MOVEL     'BRIT1/2'     WMPTP
     C     A6SWCY        WHENEQ    'CB3'
     C                   MOVEL     'BRIT1/4'     WMPTP
     C     A6SWCY        WHENEQ    'CB4'
     C                   MOVEL     'BRIT1/10'    WMPTP
     C     A6SWCY        WHENEQ    'CCN'
     C                   MOVEL     'COIN    '    WMPTP
     C     A6SWCY        WHENEQ    'CC1'
     C                   MOVEL     'CORO100'     WMPTP
     C     A6SWCY        WHENEQ    'CC2'
     C                   MOVEL     'CORO20 '     WMPTP
     C     A6SWCY        WHENEQ    'CC3'
     C                   MOVEL     'CORO10 '     WMPTP
     C     A6SWCY        WHENEQ    'CD1'
     C                   MOVEL     'DUCA4  '     WMPTP
     C     A6SWCY        WHENEQ    'CD2'
     C                   MOVEL     'DUCA1  '     WMPTP
     C     A6SWCY        WHENEQ    'CF1'
     C                   MOVEL     'FRFR20 '     WMPTP
     C     A6SWCY        WHENEQ    'CG1'
     C                   MOVEL     'GECU50 '     WMPTP
     C     A6SWCY        WHENEQ    'CK1'
     C                   MOVEL     'KRUG1/1'     WMPTP
     C     A6SWCY        WHENEQ    'CK2'
     C                   MOVEL     'KRUG1/2'     WMPTP
     C     A6SWCY        WHENEQ    'CK3'
     C                   MOVEL     'KRUG1/4'     WMPTP
     C     A6SWCY        WHENEQ    'CK4'
     C                   MOVEL     'KRUG1/10'    WMPTP
     C     A6SWCY        WHENEQ    'CL1'
     C                   MOVEL     'LBTY20 '     WMPTP
     C     A6SWCY        WHENEQ    'CL2'
     C                   MOVEL     'LBTY10 '     WMPTP
     C     A6SWCY        WHENEQ    'CL3'
     C                   MOVEL     'LBTY5  '     WMPTP
     C     A6SWCY        WHENEQ    'CM1'
     C                   MOVEL     'MAPL1/1'     WMPTP
     C     A6SWCY        WHENEQ    'CM2'
     C                   MOVEL     'MAPL1/2'     WMPTP
     C     A6SWCY        WHENEQ    'CM3'
     C                   MOVEL     'MAPL1/4'     WMPTP
     C     A6SWCY        WHENEQ    'CM4'
     C                   MOVEL     'MAPL1/10'    WMPTP
     C     A6SWCY        WHENEQ    'CX1'
     C                   MOVEL     'MEXP50'      WMPTP
     C     A6SWCY        WHENEQ    'CX2'
     C                   MOVEL     'MEXP20'      WMPTP
     C     A6SWCY        WHENEQ    'CX3'
     C                   MOVEL     'MEXP10'      WMPTP
     C     A6SWCY        WHENEQ    'CX4'
     C                   MOVEL     'MEXP5 '      WMPTP
     C     A6SWCY        WHENEQ    'CU1'
     C                   MOVEL     'NBUF50'      WMPTP
     C     A6SWCY        WHENEQ    'CN1'
     C                   MOVEL     'NOBL1/1'     WMPTP
     C     A6SWCY        WHENEQ    'CW1'
     C                   MOVEL     'NSOV1/1'     WMPTP
     C     A6SWCY        WHENEQ    'CW2'
     C                   MOVEL     'NSOV1/2'     WMPTP
     C     A6SWCY        WHENEQ    'CO1'
     C                   MOVEL     'OSOV1/1'     WMPTP
     C     A6SWCY        WHENEQ    'CO2'
     C                   MOVEL     'OSOV1/2'     WMPTP
     C     A6SWCY        WHENEQ    'CS1'
     C                   MOVEL     'SAEG1/1'     WMPTP
     C     A6SWCY        WHENEQ    'CE1'
     C                   MOVEL     'SECU5  '     WMPTP
     C     A6SWCY        WHENEQ    'CT1'
     C                   MOVEL     'STAT20 '     WMPTP
     C     A6SWCY        WHENEQ    'CT2'
     C                   MOVEL     'STAT10 '     WMPTP
     C     A6SWCY        WHENEQ    'CT3'
     C                   MOVEL     'STAT5  '     WMPTP
     C     A6SWCY        WHENEQ    'CV1'
     C                   MOVEL     'VREN20 '     WMPTP
     C     A6SWCY        WHENEQ    'CV2'
     C                   MOVEL     'VREN10 '     WMPTP
     C                   ENDSL

     C                   IF        MGDELV <> *BLANKS
     C                   EVAL      WIDCOM = MGDELV
     C     WIDCOM        CAT       WCRTN:0       WIDCOM
     C     WIDCOM        CAT       '/':0         WIDCOM           45
     C                   ELSE
     C     WCRTN         CAT       '/':0         WIDCOM           45
     C                   ENDIF

     C     WIDCOM        CAT       MGALOC:0      WIDCOM
     C     WIDCOM        CAT       WMPTP:0       WIDCOM
     C     WIDCOM        CAT       MGDENO:0      WIDCOM

     C                   IF        MGFORM <> *BLANKS
     C     WIDCOM        CAT       '//':0        WIDCOM
     C     WIDCOM        CAT       MGFORM:0      WIDCOM
     C                   ENDIF

     C                   ADD       1             X
     C     X             OCCUR     MULT

     C                   MOVEL     ':26C:'       MTAG
     C                   MOVEL     WIDCOM        MFLD

      ** Field 26H Counterparty's reference not output

     C                   IF        %SUBST(MGBTB1:1:6) = '/CREF/'
     C                   EVAL      MGCREF = %SUBST(MGBTB1:7:29)
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEL     ':26H:'       MTAG
     C                   MOVEL     MGCREF        MFLD
     C                   ENDIF

      ** Price by Unit 33G

     C                   ADD       1             X
     C     X             OCCUR     MULT

     C/COPY WNCPYSRC,MG0600C042

     C                   MOVE      MGEXRT        ZEXRT

     C/COPY WNCPYSRC,MG0600C001

      ** Exchange rate conversion

     C                   CALL      'ZM0030'                             15
     C                   PARM                    ZEXRT            13 8
     C                   PARM                    ZSEXRT           12

     C/COPY WNCPYSRC,MG0600C037

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '017'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0030'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C/COPY WNCPYSRC,MG0600C003

     C                   EXSR      SRBTB

     C                   Z-ADD     1             I
     C                   MOVE      *BLANKS       @WRK33            5

     C     I             DOUGT     6
     C     @BTB(I)       IFNE      *BLANKS
     C     6             SUBST     @BTB(I)       WCHK33            6
     C     WCHK33        IFEQ      '/UNIT/'
     C                   MOVE      'SEE72'       @WRK33
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             I
     C                   ENDDO

     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @UNITC        @KEY3             3
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   MOVE      ':33G:'       MTAG
     C     A6SWCY        CAT       ZSEXRT:0      MFLD

     C     MFLD          CAT       @WRK33:0      MFLD

      ** Field 71C Not output
      ** Field 77H - Agreement

     C     MGAGTY        IFNE      *BLANKS
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      ':77H:'       MTAG

     C                   MOVEA     *BLANKS       @WRK
     C                   MOVEA     MGAGTY        @WRK
     C                   Z-ADD     1             Z                 3 0
     C     ' '           LOOKUP    @WRK(Z)                                31

     C     MGAGDT        IFNE      *ZEROS
     C                   MOVEA     '/'           @WRK(Z)
     C                   ADD       1             Z
     C                   MOVE      MGAGDT        WNAGDT            8
     C                   MOVEA     WNAGDT        @WRK(Z)

     C     MGAGVV        IFNE      *ZEROS
     C     ' '           LOOKUP    @WRK(Z)                                31
     C                   MOVEA     '//'          @WRK(Z)
     C                   ADD       2             Z
     C                   MOVE      MGAGVV        WNAGVV            4
     C                   MOVEA     WNAGVV        @WRK(Z)
     C                   ENDIF

     C                   ENDIF

     C                   MOVEA     @WRK          MFLD

     C                   ENDIF

      ** Format field :77D: - Conditions.

     C     MGCON1        IFNE      *BLANKS

      ** Store the CONDITIONS information for easier use.

     C                   MOVE      MGCON1        @BTB(1)
     C                   MOVE      MGCON2        @BTB(2)
     C                   MOVE      MGCON3        @BTB(3)
     C                   MOVE      MGCON4        @BTB(4)
     C                   MOVE      MGCON5        @BTB(5)
     C                   MOVE      MGCON6        @BTB(6)

     C                   Z-ADD     0             I
     C                   MOVE      'N'           FLD77O            1

      ** Search through all six fields & output if not blank.

     C     I             DOWLT     6

     C                   ADD       1             I

     C     @BTB(I)       IFNE      *BLANKS
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C     FLD77O        IFEQ      'N'
     C                   MOVE      ':77D:'       MTAG
     C                   MOVE      'Y'           FLD77O
     C                   ENDIF

     C                   MOVEL     @BTB(I)       MFLD
     C                   ENDIF

     C                   ENDDO

     C                   ENDIF

      ** Field 14C - Year Definitions

     C     MGAGTY        IFEQ      'ISDA'
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      ':14C:'       MTAG
     C                   MOVEL     MGISDA        MFLD
     C                   ENDIF

      * Field 72 formatting

     C                   EXSR      FLD72

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   FLD72 - Calculate field 72                                  *
      *                                                               *
      *****************************************************************
      *
     C     FLD72         BEGSR

     C                   MOVE      *BLANKS       @WRK

      ** Store the Sender to Receiver information for easier use.

     C                   EXSR      SRBTB

     C                   Z-ADD     0             I
     C                   MOVE      'N'           FLD72O            1

      ** Search through all six fields & output if not blank.

     C     I             DOWLT     6

     C                   ADD       1             I
     C                   MOVEL     @BTB(I)       @WRK06            6
     C                   MOVEL     @BTB(I)       @WRK07            7
     C                   MOVEL     @BTB(I)       @WRK10           10

     C     @BTB(I)       IFNE      *BLANKS
     C     @WRK07        IFNE      '/DELIV/'
     C     @WRK07        ANDNE     '/ALLOC/'
     C     @WRK06        ANDNE     '/CREF/'

     C     @WRK06        IFEQ      '/UNIT/'
     C     @WRK10        OREQ      MSGA(9)
     C                   MOVEL     *BLANKS       @UNIT
     C     @WRK06        IFEQ      '/UNIT/'
     C     3             SUBST     @WRK10:7      @UNIT             3
     C     @UNIT         LOOKUP    VALUNI                                 90
     C     *IN90         IFEQ      '1'
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C     FLD72O        IFEQ      'N'
     C                   MOVE      ':72: '       MTAG
     C                   MOVE      'Y'           FLD72O
     C                   ENDIF

     C                   IF        @UNIT = 'OTH'
     C                   EVAL      MFLD = '/UNIT/' + MGCMUD
     C                   ELSE
     C                   EVAL      MFLD = @BTB(I)
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDIF

     C                   ELSE
     C                   ADD       1             X
     C     X             OCCUR     MULT

     C     FLD72O        IFEQ      'N'
     C                   MOVE      ':72: '       MTAG
     C                   MOVE      'Y'           FLD72O
     C                   ENDIF

     C                   MOVEL     @BTB(I)       MFLD
     C                   ENDIF
     C                   ELSE

     C                   LEAVE

     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

     C/COPY WNCPYSRC,MG0600CCP3

      ** Output /TELEX/

     C/COPY WNCPYSRC,MG0600CCP4

     C*****MGBRKC        IFEQ      'TELX'                                                   MD030922
     C**********         MOVEA     '/TELEX/'     @WRK(1)                                    MD030922
     C**********         END                                                                MD030922

      ** Output /PHON/

     C/COPY WNCPYSRC,MG0600CCP5

     C*****MGBRKC        IFEQ      'PHON'                                                   MD030922
     C**********         MOVEA     '/PHON/'      @WRK(1)                                    MD030922
     C**********         END                                                                MD030922
      **********                                                                            MD030922
     C*****MGBRKC        IFNE      'TELX'                                                   MD030922
     C*****MGBRKC        ANDNE     'PHON'                                                   MD030922
     C*****MGBRKC        ANDNE     'MAIL'                                                   MD030922
     C*****MGBRKC        ANDNE     'SWAP'                                                   MD030922
     C*****MGBRKC        ANDNE     *BLANKS                                                  MD030922
      **********                                                                            MD030922
      ***Access*the*broker*file*                                                            MD030922
      **********                                                                            MD030922
     C**********         CALL      'AOBROKR0'                                               MD030922
     C**********         PARM      '*MSG   '     @RTCD             7                        MD030922
     C**********         PARM      '*KEY   '     @OPTN             7                        MD030922
     C**********         PARM      MGBRKC        @BROKY            4                        MD030922
     C*****SDBROK        PARM      SDBROK        DSFDY                                      MD030922
      **********                                                                            MD030922
      ***If*the*broker*code*is*not*found.*                                                  MD030922
      **********                                                                            MD030922
     C*****@RTCD         IFNE      *BLANKS                                                  MD030922
     C**********         MOVE      'Y'           @ERR                                       MD030922
     C**********         MOVEL     MSGA(4)       MERR                                       MD030922
     C**********         MOVEA     MGBRKC        @WRK(1)                                    MD030922
      **********                                                                            MD030922
      ***Format*the*broker*field.*                                                          MD030922
      **********                                                                            MD030922
     C**********         ELSE                                                               MD030922
      **********                                                                            MD030922
     C/COPY WNCPYSRC,MG0600CCP6
      **********                                                                            MD030922
     C**********         MOVEA     '/BROKER/'    @WRK(1)                                    MD030922
     C**********         MOVEA     A9BKNM        @WRK(9)                                    MD030922
      **********                                                                            MD030922
     C/COPY WNCPYSRC,MG0600CCP7
      **********                                                                            MD030922
     C**********         END                                                                MD030922
     C**********         END                                                                MD030922
      **********                                                                            MD030922
      ***Maximum*length*of*field*is*35*                                                     MD030922
      **********                                                                            MD030922
     C**********         MOVEA     @WRK(36)      @WRK15           15                        MD030922
     C*****@WRK15        IFNE      *BLANK                                                   MD030922
     C**********         Z-ADD     36            J                 2 0                      MD030922
     C**********         MOVEA     *BLANK        @WRK(J)                                    MD030922
     C**********         END                                                                MD030922
      **********                                                                            MD030922
      ****Output*Field*:72:*as*constructed*from*above*                                      MD030922
      **********                                                                            MD030922
     C*****@WRK(1)       IFNE      *BLANK                                                   MD030922
     C*****I****         ANDLE     6                                                        MD030922
     C**********         ADD       1             I                                          MD030922
     C**********         ADD       1             X                                          MD030922
     C*****X****         OCCUR     MULT                                                     MD030922
     C*****FLD72O        IFEQ      'N'                                                      MD030922
     C**********         MOVE      ':72: '       MTAG                                       MD030922
     C**********         MOVE      'Y'           FLD72O                                     MD030922
     C**********         ENDIF                                                              MD030922
     C**********         MOVEA     @WRK          MFLD                                       MD030922
     C**********         END                                                                MD030922
      **********                                                                            MD030922
      ***Wrap*round*to*the*next*line*the*remainder*of*the*BROKER*info.*                     MD030922
      **********                                                                            MD030922
     C*****@WRK15        IFNE      *BLANK                                                   MD030922
     C*****I****         ANDLE     6                                                        MD030922
     C**********         ADD       1             I                                          MD030922
     C**********         MOVEA     *BLANK        @WRK                                       MD030922
     C**********         MOVEA     '//'          @WRK(1)                                    MD030922
     C**********         MOVEA     @WRK15        @WRK(3)                                    MD030922
     C**********         ADD       1             X                                          MD030922
     C*****X****         OCCUR     MULT                                                     MD030922
     C**********         MOVEA     @WRK          MFLD                                       MD030922
     C/COPY WNCPYSRC,MG0600C040
     C**********         END                                                                MD030922
      **********                                                                            MD030922
     C/COPY WNCPYSRC,MG0600CCP8


     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   SRFMTB - Format message detail - Sequence B                 *
      *                                                               *
      *****************************************************************
      *
     C     SRFMTB        BEGSR

      **  Field :15B: Transaction Details

     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      ':15B:'       MTAG
     C                   MOVEL     *BLANK        MFLD

      ** 1. Sequence B - Quantity of Commodity - Bought
      ** ------------------------------

      ** Field :32F:  Unit, Amount Bought

     C                   ADD       1             X
     C     X             OCCUR     MULT

      ** Format purchase currency and amount

     C                   MOVE      MGPUCY        ZCCY
     C                   MOVE      MGPAMT        ZAMNT

     C/COPY WNCPYSRC,MG0600C038

     C                   CALL      'ZM0040'                             15
     C                   PARM                    ZAMNT            13 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZSAMNT           15
     C                   PARM                    ZSCCY             3
     C                   PARM      ' '           ZERR              1

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '018'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0040'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVE      MGUNIT        ZSCCY
     C                   MOVE      ':32F:'       MTAG

      ** Error - indicate erroneous fields

     C     ZERR          IFEQ      '1'
     C                   MOVE      'Y'           @ERR
     C                   MOVE      MGPAMT        ZAMT
     C                   MOVEL     ERR3N         MFLD
     C                   MOVEL     MSGA(5)       MERR
     C                   ELSE
     C                   MOVEL     FLD2N         MFLD
     C                   ENDIF

      ** Field :86a:  Intermediary

     C/COPY WNCPYSRC,MG0600C022

      ** Intermediary not blank; retrieve customer address

     C     MGRIBN        IFNE      *BLANKS
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      *BLANKS       ZDEST
     C                   MOVEL     MGRIBN        ZDEST
     C                   MOVE      *BLANKS       ACLINE           35
     C                   MOVEL     MGRIBA        ACLINE
     C                   MOVE      ' '           TAG
     C                   MOVE      '86'          FLDNO
     C                   MOVE      NETBY         CKNETI
     C                   EXSR      FSWAD
     C                   ENDIF

      ** Field :87a: Receiver of the Commodity

     C/COPY WNCPYSRC,MG0600C007

     C                   ADD       1             X
     C     X             OCCUR     MULT

      ** Test if settlement via nostro

     C                   MOVE      MGRSTM        @STM              2
     C     @STM          LOOKUP    TABNST                                 23
     C     MGRONS        IFNE      *BLANKS
     C     *IN23         ANDEQ     '1'

      ** Use receipt settlement currency to access nostro if not blank.
      ** Otherwise use purchase currency.

     C     CEU003        IFEQ      'Y'
     C     MGRCCY        ANDNE     *BLANKS
     C                   MOVE      MGRCCY        @NSKYB
     C                   ELSE
     C                   MOVE      MGPUCY        @NSKYB
     C                   ENDIF

     C                   MOVEL     MGRONS        @NSKYE
     C                   CALL      'AONOSTR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @NSKYA            6
     C                   PARM                    @NSKYB            3
     C                   PARM      *BLANKS       @NSKYC            4
     C                   PARM      *BLANKS       @NSKYD            2
     C                   PARM                    @NSKYE            2
     C                   PARM      *BLANKS       @KEYF             3
     C                   PARM      *BLANKS       @KEYG            10
     C                   PARM      *BLANKS       @KEYH             1
     C     SDNOST        PARM      SDNOST        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'Y'           @ERR
     C                   MOVEL     MGRONS        MFLD
     C                   MOVEL     MSGA(3)       MERR
     C                   MOVE      ':87 :'       MTAG
     C                   ELSE

     C                   MOVE      *BLANKS       ZDEST
     C                   MOVEL     A7CUST        ZDEST

     C/COPY WNCPYSRC,MG0600CCP1

     C                   MOVEL     *BLANKS       ACLINE
     C                   MOVE      ' '           TAG
     C                   MOVE      '87'          FLDNO
     C                   MOVE      NETBY         CKNETI            1

     C/COPY WNCPYSRC,MG0600C015

     C                   EXSR      FSWAD
     C                   ENDIF

      ** Our receive nostro is blank or settlement internal

     C                   ELSE

      ** Test if settlement internal

     C                   MOVE      MGRSTM        @STM
     C     @STM          LOOKUP    TABINT                                 23

     C     *IN23         IFEQ      '1'
     C                   MOVE      *BLANKS       ZDEST
     C                   MOVEL     SECN          ZDEST
     C                   MOVEL     *BLANKS       ACLINE
     C                   MOVE      ' '           TAG
     C                   MOVE      '87'          FLDNO
     C                   MOVE      NETBY         CKNETI
     C                   EXSR      FSWAD

     C                   ELSE
     C                   MOVE      ':87D:'       MTAG
     C                   MOVEL     'UNKNOWN'     MFLD
     C                   ENDIF

     C                   ENDIF

     C/COPY WNCPYSRC,MG0600C008

      ** 2. 34P Consideration
      ** ----------------------------

      **  Field :34P: Value date, currency code and the consideration paid by the Sender

     C                   ADD       1             X
     C     X             OCCUR     MULT

      **  Format value date to SWIFT standard

     C     MGTTYP        IFEQ      'OP'
     C     COB           ANDEQ     'C'
     C                   MOVE      MGOTDT        ZMDAY
     C                   ELSE
     C     CWRD          IFEQ      'AMEND'
     C                   MOVE      BJRDNB        ZMDAY
     C                   ELSE
     C                   MOVE      MGVDAT        ZMDAY
     C                   ENDIF
     C                   ENDIF
     C                   CALL      'ZM0065'                             15
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZSDAT1            6
     C                   PARM                    ZSDATC            8

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '016'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0065'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     X             OCCUR     MULT
     C                   MOVE      MGSLCY        ZCCY
     C                   MOVE      MGSAMT        ZAMNT

     C/COPY WNCPYSRC,MG0600C039

     C                   CALL      'ZM0040'                             15
     C                   PARM                    ZAMNT            13 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZSAMN1           15
     C                   PARM                    ZSCCY1            3
     C                   PARM      ' '           ZERR              1

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '019'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0040'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Error - indicate erroneous fields;

     C     ZERR          IFEQ      '1'
     C                   MOVE      'Y'           @ERR
     C                   MOVE      MGSAMT        ZAMT
     C                   MOVE      MGSLCY        ZCCY
     C                   MOVEL     ERR3N         MFLD
     C                   MOVEL     MSGA(4)       MERR

     C                   ELSE
     C                   MOVE      ':34P:'       MTAG
     C                   MOVEL     FLD3N         MFLD
     C                   ENDIF

     C/COPY WNCPYSRC,MG0600C009

      ** Field :53a: Sender's Correspondent
      ** Test if settlement via nostro

     C                   MOVE      MGPSTM        @STM
     C     @STM          LOOKUP    TABNST                                 23

     C     MGPONS        IFNE      *BLANKS
     C     *IN23         ANDEQ     '1'

      ** either A/C with Bank or Receipient entered
      ** or A/C with A/c line = 'DIRECT'

     C     MGAWBN        IFNE      *BLANKS
     C     MGRVNO        ORNE      *BLANKS
     C     AWBA6         ANDNE     'DIRECT'

      ** Use payment settlement currency to access nostro if not blank.
      ** Otherwise use sell currency.

     C     CEU003        IFEQ      'Y'
     C     MGPYCY        ANDNE     *BLANKS
     C                   MOVE      MGPYCY        @NSKYB
     C                   ELSE
     C                   MOVE      MGSLCY        @NSKYB
     C                   ENDIF

     C                   MOVEL     MGPONS        @NSKYE
     C                   CALL      'AONOSTR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @NSKYA            6
     C                   PARM                    @NSKYB            3
     C                   PARM      *BLANKS       @NSKYC            4
     C                   PARM      *BLANKS       @NSKYD            2
     C                   PARM                    @NSKYE            2
     C                   PARM      *BLANKS       @KEYF             3
     C                   PARM      *BLANKS       @KEYG            10
     C                   PARM      *BLANKS       @KEYH             1
     C     SDNOST        PARM      SDNOST        DSFDY

      **  Nostro customer not found

     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      'Y'           @ERR
     C                   MOVE      ':53 :'       MTAG
     C                   MOVEL     MGPONS        MFLD
     C                   MOVEL     MSGA(3)       MERR
     C                   ELSE

      ** Branch Internal Customer cf. Customer number of Our Pay Nostro

     C                   MOVEL     SECN          @SECN             6
     C     @SECN         IFNE      A7CUST
     C     MGAWBN        ANDNE     A7CUST
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      *BLANKS       ZDEST
     C     MGRVNO        IFEQ      *BLANKS
     C                   MOVEL     A7CUST        ZDEST
     C                   ELSE
     C                   MOVEL     MGRVNO        ZDEST

     C/COPY WNCPYSRC,MG0600C002

     C                   ENDIF
     C                   CALL      'ZM0050'                             15
     C                   PARM                    ZDEST            12
     C                   PARM                    ZSADD1           35
     C                   PARM                    ZSADD2           35
     C                   PARM                    ZSADD3           35
     C                   PARM                    ZSADD4           35
     C                   PARM                    ZSTAG             1
     C                   PARM                    ZSTYPE            1
     C                   PARM      ' '           ZERR              1
     C                   PARM                    ZDBEI             1

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '020'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0050'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      **  Error when formating address

     C     ZERR          IFEQ      '1'
     C                   MOVE      'Y'           @ERR
     C                   MOVE      ':53 :'       MTAG
     C                   MOVEL     ZDEST         MFLD
     C                   MOVEL     MSGA(6)       MERR
     C                   ELSE
     C                   EXSR      FMT53
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C/COPY WNCPYSRC,MG0600C010

      ** Field :56a: and :57a: Intermediary and Accnt with Institution
      ** Nostro field blank

     C     MGPSTM        IFEQ      00
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      ':57D:'       MTAG
     C                   MOVEL     'UNKNOWN'     MFLD
     C                   MOVE      'Y'           FLD57U            1
     C                   END

      ** Field 57 Seq C is not UNKNOWN

     C     FLD57U        IFNE      'Y'

      ** Field 56 and Field 57  intermediary and account with inst.

     C                   MOVEL     '56'          @TAGI             2
     C                   MOVEL     '57'          @TAGD             2
     C                   EXSR      FMTX1
     C                   END
     C                   MOVE      'N'           FLD57U

     C                   MOVE      *BLANK        ZDBEI

     C/COPY WNCPYSRC,MG0600C050

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   SRFMTC - Format message detail - Sequence C                 *
      *                                                               *
      *****************************************************************
     C     SRFMTC        BEGSR

      **  Field :15C: New Sequence

     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      ':15C:'       MTAG
     C                   MOVEL     *BLANK        MFLD

      ** 1. Sequence C - Quantity of Commodity - Sold
      ** ------------------------------

      **  Field :32F:  Currency, Amount Bought

     C                   ADD       1             X
     C     X             OCCUR     MULT

      ** Format purchase currency and amount

     C                   MOVE      MGSLCY        ZCCY
     C                   MOVE      MGSAMT        ZAMNT

     C/COPY WNCPYSRC,MG0600C038

     C                   CALL      'ZM0040'                             15
     C                   PARM                    ZAMNT            13 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZSAMNT           15
     C                   PARM                    ZSCCY             3
     C                   PARM      ' '           ZERR              1

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '018'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0040'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVE      ':32F:'       MTAG

      ** Error - indicate erroneous fields

     C     ZERR          IFEQ      '1'
     C                   MOVE      'Y'           @ERR
     C                   MOVE      MGPAMT        ZAMT
     C                   MOVEL     ERR3N         MFLD
     C                   MOVEL     MSGA(5)       MERR
     C                   ELSE
     C                   MOVE      MGUNIT        ZSCCY
     C                   MOVEL     FLD2N         MFLD
     C                   ENDIF

     C/COPY WNCPYSRC,MG0600C010

      ** Field :86a: and :87a: Intermediary and deliverer of the commodity
      ** Nostro field blank

     C     MGPSTM        IFEQ      00
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      ':87D:'       MTAG
     C                   MOVEL     'UNKNOWN'     MFLD
     C                   MOVE      'Y'           FLD57U            1
     C                   END

      ** Field 87 Seq C is not UNKNOWN

     C                   MOVE      'Y'           SEQ15C                                     MD033754
                                                                                            MD033754
     C     FLD87O        IFNE      'Y'

      ** Field 86 and Field 87  intermediary and account with inst.

     C                   MOVEL     '86'          @TAGI             2
     C                   MOVEL     '87'          @TAGD             2
     C                   EXSR      FMTX1
     C                   END
     C                   MOVE      'N'           FLD57U

     C                   MOVE      *BLANK        ZDBEI

     C/COPY WNCPYSRC,MG0600C008

      ***2.*34P*Consideration                                                              AR1053647
      ** 2. 34R Consideration                                                              AR1053647
      ** ----------------------------

      ***Field*:34P:*Value*date,*currency*code*and*the*consideration*paid*by*the*Sender    AR1053647
      ** Field :34R: Value date, currency code and the consideration paid by the Sender    AR1053647

     C                   ADD       1             X
     C     X             OCCUR     MULT

      ** Format value date to SWIFT standard

     C     MGTTYP        IFEQ      'OP'
     C     COB           ANDEQ     'C'
     C                   MOVE      MGOTDT        ZMDAY
     C                   ELSE
     C     CWRD          IFEQ      'AMEND'
     C                   MOVE      BJRDNB        ZMDAY
     C                   ELSE
     C                   MOVE      MGVDAT        ZMDAY
     C                   ENDIF
     C                   ENDIF
     C                   CALL      'ZM0065'                             15
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZSDAT1            6
     C                   PARM                    ZSDATC            8

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '016'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0065'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     X             OCCUR     MULT
     C                   MOVE      MGSLCY        ZCCY
     C                   MOVE      MGSAMT        ZAMNT

     C/COPY WNCPYSRC,MG0600C039

     C                   CALL      'ZM0040'                             15
     C                   PARM                    ZAMNT            13 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZSAMN1           15
     C                   PARM                    ZSCCY1            3
     C                   PARM      ' '           ZERR              1

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '019'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0040'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Error - indicate erroneous fields;

     C     ZERR          IFEQ      '1'
     C                   MOVE      'Y'           @ERR
     C                   MOVE      MGSAMT        ZAMT
     C                   MOVE      MGSLCY        ZCCY
     C                   MOVEL     ERR3N         MFLD
     C                   MOVEL     MSGA(4)       MERR

     C                   ELSE
     C**********         MOVE      ':34P:'       MTAG                                      AR1053647
     C                   MOVE      ':34R:'       MTAG                                      AR1053647
     C                   MOVEL     FLD3N         MFLD
     C                   END

     C/COPY WNCPYSRC,MG0600C010

      ***Field*:86a:*and*:87a:*Intermediary*and*Accnt*with*Institution                     AR1053647
      ** Field :56a: and :57a: Intermediary and Accnt with Institution                     AR1053647
      ** Nostro field blank

     C     MGPSTM        IFEQ      00
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      ':57D:'       MTAG
     C                   MOVEL     'UNKNOWN'     MFLD
     C                   MOVE      'Y'           FLD57U            1
     C                   END

      ** Field 57 Seq C is not UNKNOWN

     C     FLD57U        IFNE      'Y'

      ***Field*86*and*Field*87**intermediary*and*account*with inst.                        AR1053647
      ** Field 56 and Field 57 intermediary and account with inst.                         AR1053647

     C                   MOVEL     '56'          @TAGI                                     AR1053647
     C                   MOVEL     '57'          @TAGD                                     AR1053647
     C                   EXSR      FMTX1
     C                   END
     C                   MOVE      'N'           FLD57U

     C                   MOVE      *BLANK        ZDBEI

     C/COPY WNCPYSRC,MG0600C033

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   SRCODE - Calculate codework                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRCODE        BEGSR

     C                   MOVE      *BLANKS       PRNOUT            4
     C                   MOVE      *BLANKS       CODEWD

      ** Determine the state of the pay side of the transaction

     C                   EXSR      SRPAYE

      ** Pay field 87 & Rec our-nostro are BOTH not blank

     C     PAY87         IFNE      *BLANK
     C     MGRONS        ANDNE     *BLANK
     C                   MOVE      'BOTH'        PRNOST            4
     C                   ENDIF

      ** pay field 87 & rec our-nostro; Both blank/One blank

     C     PAY87         IFEQ      *BLANK
     C     MGRONS        OREQ      *BLANK
     C                   MOVE      'B/O '        PRNOST
     C                   ENDIF

      ** If sequence number zero (NEW message)

     C     MGLSWC        IFEQ      0
     C                   MOVEL     'NEW'         CWRD

      ** If both our-nostro fields non-blank the 87 fields are Known

     C     PRNOST        IFEQ      'BOTH'
     C                   MOVE      'K'           F57U

      ** Both or one our-nostro field(s) are blank, Unknown

     C                   ELSE
     C                   MOVE      'U'           F57U
     C                   ENDIF

      **  For SWIFT Changes 1996, the two new tables TABS96 and
      **  TABR96 are used to create the CONDITION and RESULT,
      **  as shown in the table below.  The position of the
      **  ONDITION on TABS96, is the same equivalent position
      **  for the RESULT on TABR96.  Hence when a LOKUP is performed
      **  on TABS96, using the CONDITION as the key, the equivalent
      **  positional RESULT value is placed in TABR96.

      **  To retrieve the first 3 fields for the CONDITION, the
      **  last confrimation created for the Transaction number
      **  is accessed.
      **  <----------------CONDITION------------------->  <--RESULT-->
      **  Status   Old Code  Old F57U  Rec Our-Nostro     Code     F57U
      **           LF/MGOREFL0         Pay Our-Nostro
      **  ----------------------------------------------------------------
      **      No record found          Both non-blank     AMEND     K
      **      No record found          One or both blank  AMEND     U
      **  NONREC   NEW          U      Both non-blank     NEW       K
      **  NONREC   NEW          U      One or both blank  NEW       U
      **  NONREC   NEW          K      Both non-blank     NEW       K
      **  NONREC   NEW          K      One or both blank  NEW       K
      **  SENT     NEW          U      Both non-blank     AMEND     K
      **  SENT     NEW          U      One or both blank  AMEND     U
      **  SENT     NEW          K      Both non-blank     AMEND     K
      **  SENT     NEW          K      One or both blank  AMEND     K
      **  NONREC   AMEND        U      Both non-blank     AMEND     K
      **  NONREC   AMEND        U      One or both blank  AMEND     U
      **  NONREC   AMEND        K      Both non-blank     AMEND     K
      **  NONREC   AMEND        K      One or both blank  AMEND     K
      **  SENT     AMEND        U      Both non-blank     AMEND     K
      **  SENT     AMEND        U      One or both blank  AMEND     U
      **  SENT     AMEND        K      Both non-blank     AMEND     K
      **  SENT     AMEND        K      One or both blank  AMEND     K

     C                   ELSE
     C                   MOVE      *BLANKS       SEARCH

      ** Retrieve last confirmation for this tranaction number

     C     MGACMI        IFEQ      'Y'                                                      MD022425
     C**********         ADD       1             MGLSWC                            MD022425 MD024078
     C                   MOVE      MGLSWC        @TRN41                                     MD022425
     C                   ELSE                                                               MD022425
     C                   MOVE      MGLSWC        @TR3
     C                   ENDIF                                                              MD022425
     C     @TRN          CHAIN     MGREFL0                            10

      ** If a message found build the selection key

     C     *IN10         IFEQ      '0'

     C     MMGSG         IFEQ      '2'
     C     MMGSG         OREQ      '3'
     C                   MOVEL     'SENT'        @MGST
     C                   ELSE
     C                   MOVEL     'NONREC'      @MGST
     C                   ENDIF

     C                   MOVEL     MLSCC         @LSCC
     C                   MOVE      MF57U         @OF87
     C                   MOVE      MCLSS         WCLSS             1
     C                   ENDIF
     C                   MOVE      PRNOST        @NOST

      ** Use select table to point to the result table

     C     SEARCH        LOOKUP    TABS96        TABR96                   22

      ** Key matches select table, outputs the corresponding
      ** result table value to 'TABR96'

     C     *IN22         IFEQ      '1'

     C                   MOVE      TABR96        CODEWD

     C                   ELSE
     C                   MOVEL     'AMEND   '    CWRD
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   SRPAYE - Pay side field 87 (KNOWN or UNKNOWN)               *
      *                                                               *
      *****************************************************************
     C     SRPAYE        BEGSR

     C                   MOVE      *BLANKS       PAY87             5

      ** Known when settlement via nostro (MGAWBN is blank)

     C     MGPSTM        IFEQ      02
     C     MGPSTM        OREQ      12
     C                   MOVE      'KNOWN'       PAY87
     C                   ENDIF

      ** Known when settlement internal (branch internal customer)

     C                   MOVE      MGPSTM        @STM              2
     C     @STM          LOOKUP    TABINT                                 23
     C     *IN23         IFEQ      '1'
     C                   MOVE      'KNOWN'       PAY87
     C                   ENDIF

      ** Known when settlement via nostro and MGAWBN entered

     C     MGPSTM        IFEQ      01
     C     MGPSTM        OREQ      07
     C     MGPSTM        OREQ      08
     C     MGAWBN        IFNE      *BLANKS
     C     MGAWBN        OREQ      *BLANKS
     C     AWBA6         ANDEQ     'DIRECT'
     C                   MOVE      'KNOWN'       PAY87
     C                   ENDIF
     C                   ENDIF

      ** Unknown when settlement internal

     C     MGPSTM        IFEQ      00
     C                   MOVE      *BLANKS       PAY87
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   FSWAD - Format SWIFT address                                *
      *                                                               *
      *****************************************************************
     C     FSWAD         BEGSR

      ** If NET deal set MFLD to 'TO BE NETTED'

     C     CKNETI        IFEQ      'Y'
     C     FLDNO         ANDEQ     '87'
     C                   MOVEL     NETTXT        MFLD
     C                   MOVE      'D'           TAG
     C                   MOVE      @MTAG         MTAG
     C                   ELSE
     C                   CALL      'ZM0050'                             15
     C                   PARM                    ZDEST            12
     C                   PARM                    ZSADD1           35
     C                   PARM                    ZSADD2           35
     C                   PARM                    ZSADD3           35
     C                   PARM                    ZSADD4           35
     C                   PARM                    ZSTAG             1
     C                   PARM                    ZSTYPE            1
     C                   PARM      ' '           ZERR              1
     C                   PARM      'Y'           ZDBEI             1

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '021'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0050'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      **  Error ?

     C     ZERR          IFEQ      '1'
     C                   MOVE      'Y'           @ERR
     C                   MOVE      ZSTAG         TAG
     C                   MOVE      @MTAG         MTAG
     C                   MOVEL     ZDEST         MFLD
     C                   MOVEL     MSGA(6)       MERR
     C                   ELSE

      ** Address 1

     C     ACLINE        IFNE      *BLANKS
     C                   MOVEL     ACLINE        MFLD
     C                   ELSE
     C                   MOVEL     ZSADD1        MFLD
     C                   ENDIF

      ** SWIFT address;  Else full address

     C     ZSTAG         IFEQ      'A'

     C/COPY WNCPYSRC,MG0600C045

     C                   MOVE      'A'           TAG
     C                   MOVE      @MTAG         MTAG
     C                   MOVE      *BLANKS       SAVMTG            5

     C/COPY WNCPYSRC,MG0600C046

     C     ACLINE        IFNE      *BLANKS
     C                   MOVE      MTAG          SAVMTG
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEL     ZSADD1        MFLD
     C                   ENDIF
     C                   EXSR      SEXTN

     C/COPY WNCPYSRC,MG0600C016

     C                   ELSE

     C/COPY WNCPYSRC,MG0600C047

     C                   MOVE      'D'           TAG
     C                   MOVE      @MTAG         MTAG

     C/COPY WNCPYSRC,MG0600C048

     C     ACLINE        IFNE      *BLANKS
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEL     ZSADD1        MFLD
     C                   ENDIF

      ** Address 2

     C     ZSADD2        IFNE      *BLANKS
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEL     ZSADD2        MFLD
     C                   ENDIF

      ** Address 3

     C     ZSADD3        IFNE      *BLANKS
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEL     ZSADD3        MFLD
     C                   ENDIF

      ** Address 4

     C     ZSADD4        IFNE      *BLANKS
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEL     ZSADD4        MFLD
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C/COPY WNCPYSRC,MG0600C017

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SEXTN - Store customer with SWIFT address to data structure *
      *                                                               *
      *   Called by: FSWAD, FMT53, FMT83                              *
      *   Calls    : None                                             *
      *                                                               *
      *****************************************************************
     C     SEXTN         BEGSR

     C     SAVMTG        IFNE      *BLANKS
     C                   MOVE      SAVMTG        @MTG
     C                   ELSE
     C                   MOVEL     MTAG          @MTG
     C                   ENDIF
     C     FLDTYP        IFEQ      '5'
     C     FLDTAG        ANDEQ     'A'
     C     FLDTYP        OREQ      '8'
     C     FLDTAG        ANDEQ     'A'
     C                   ADD       1             V
     C     V             OCCUR     EXTN
     C                   Z-ADD     X             MPSN
     C                   MOVEL     @MTG          MTG
     C                   MOVEL     ZDEST         MCSI
     C                   ENDIF

     C     SEXT9         ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   FMT83 - Format Field 83 address   - Sequence A              *
      *   Called by   SRFMTA  Format message details Sequence A       *
      *                                                               *
      *****************************************************************
     C     FMT83         BEGSR

     C**********         Z-ADD     0             WFLD83            6 0                      MD026953
     C                   MOVEL     *BLANKS       WFLD83            6                        MD026953
     C                   Z-ADD     0             WBCUST            6 0
     C                   MOVE      *BLANKS       BBCUST

     C     CSW024        IFEQ      'Y'
     C     DSFUND        ANDNE     *BLANK
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C     '/NAME/'      CAT       DSFUND        MFLD
     C                   MOVE      ':83J:'       MTAG

     C                   ELSE

      ** Access customer file for Beneficiary Customer Number

     C     MGBENN        IFNE      *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN

     C/COPY WNCPYSRC,MG0600C030

     C                   PARM      MGBENN        @KEY2            10

     C/COPY WNCPYSRC,MG0600C031

     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY

      ** Customer Not found on SDCUSTPD, check the counterparty
      ** Nostro file.

     C     @RTCD         IFNE      *BLANKS
     C                   CALL      'AOCNSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      MGBENN        @CNCD             8
     C     SDCNST        PARM      SDCNST        DSFDY

      ** Customer record not found - database error

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '022'         DBASE
     C                   MOVEL     MGBENN        DBKEY
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     999999        WBCUST
     C                   ENDIF
     C                   ELSE
     C                   MOVE      BBCUST        WBCUST
     C                   ENDIF
     C                   ENDIF

      ** Output this field only if Pay Ordering Bank/Customer
      ** is not the same as Sender, Receiver and Beneficiary
      ** Also, Pay Ordering Customer/Bank must have SWIFT address.

     C*****MGPOBN        IFNE      *ZERO                                                   AR1094963
     C*****MGPOBN        ANDNE     WBICN                                                   AR1094963
     C*****MGPOBN        ANDNE     MGCNUM                                                  AR1094963
     C*****MGPOBN        ANDNE     WBCUST                                                  AR1094963
     C**********         Z-ADD     MGPOBN        WFLD83                                    AR1094963
     C**********         ENDIF                                                             AR1094963
      *                                                                                    AR1094963
     C**********         IF        MGPOBN <> *ZERO AND MGPOBN <> %CHAR(WBICN)    AR1094963 AR1097109
     C**********         IF        MGPOBN <> *BLANKS AND MGPOBN <> %CHAR(WBICN)   AR1097109 MD035515
     C                   IF        MGPOBN <> *BLANKS AND MGPOBN <> WBICN                    MD035515
     C                             AND MGPOBN <> MGCNUM                                    AR1094963
     C                             AND MGPOBN <> %CHAR(WBCUST)                             AR1094963
     C**********         EVAL      WFLD83 = %DEC(MGPOBN:6:0)                      AR1094963 MD026953
     C                   EVAL      WFLD83 = MGPOBN                                          MD026953
     C                   ENDIF                                                             AR1094963

     C*****MGPOCN        IFNE      *ZERO                                                   AR1094963
     C*****MGPOCN        ANDNE     WBICN                                                   AR1094963
     C*****MGPOCN        ANDNE     MGCNUM                                                  AR1094963
     C*****MGPOCN        ANDNE     WBCUST                                                  AR1094963
     C**********         Z-ADD     MGPOCN        WFLD83                                    AR1094963
     C**********         ENDIF                                                             AR1094963
      *                                                                                    AR1094963
     C**********         IF        MGPOCN <> *ZERO AND MGPOCN <> %CHAR(WBICN)    AR1094963 AR1097406
     C**********         IF        MGPOCN <> *BLANKS AND MGPOCN <> %CHAR(WBICN)   AR1097406 MD035515
     C                   IF        MGPOCN <> *BLANKS AND MGPOCN <> WBICN                    MD035515
     C                             AND MGPOCN <> MGCNUM                                    AR1094963
     C                             AND MGPOCN <> %CHAR(WBCUST)                             AR1094963
     C**********         EVAL      WFLD83 = %DEC(MGPOCN:6:0)                      AR1094963 MD026953
     C                   EVAL      WFLD83 = MGPOCN                                          MD026953
     C                   ENDIF                                                             AR1094963

     C*****WFLD83        IFNE      *ZERO                                                    MD026953
     C     WFLD83        IFNE      *BLANKS                                                  MD026953
     C                   MOVE      *BLANKS       ZDEST
     C                   MOVEL     WFLD83        ZDEST

     C                   CALL      'ZM0050'                             15
     C                   PARM                    ZDEST            12
     C                   PARM                    ZSADD1           35
     C                   PARM                    ZSADD2           35
     C                   PARM                    ZSADD3           35
     C                   PARM                    ZSADD4           35
     C                   PARM                    ZSTAG             1
     C                   PARM                    ZSTYPE            1
     C                   PARM      ' '           ZERR              1
     C                   PARM                    ZDBEI             1

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '023'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0050'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Error ?

     C     ZERR          IFEQ      '1'
     C                   MOVE      'Y'           @ERR
     C                   MOVE      ZSTAG         TAG
     C                   MOVE      @MTAG         MTAG
     C                   MOVEL     ZDEST         MFLD
     C                   MOVEL     MSGA(6)       MERR

     C                   ELSE

      ** Output only if with SWIFT address.

     C     ZSTAG         IFEQ      'A'
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      *BLANKS       ACLINE
     C                   MOVE      ' '           TAG
     C                   MOVE      '83'          FLDNO
     C                   MOVE      'A'           TAG
     C                   MOVE      @MTAG         MTAG

      ** Address 1

     C                   MOVE      *BLANKS       SAVMTG            5
     C     ACLINE        IFNE      *BLANKS
     C                   MOVE      MTAG          SAVMTG
     C                   MOVEL     ACLINE        MFLD
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEL     ZSADD1        MFLD
     C                   ELSE
     C                   MOVEL     ZSADD1        MFLD
     C                   ENDIF

     C                   EXSR      SEXTN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      *****************************************************************
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *   FMT53 - Format Field 53 address   - Sequence C              *
      *   Called by   SRFMTC  Format message details Sequence C       *
      *                                                               *
      *****************************************************************
     C     FMT53         BEGSR

      **  A Type address

     C     ZSTAG         IFEQ      'A'
     C                   MOVE      ':53A:'       MTAG
     C                   MOVEL     ZSADD1        MFLD
     C                   EXSR      SEXTN
     C                   MOVE      '1'           *IN55

     C                   ELSE

      ** Access SDCUSTPD using our pay nostro customer number

     C                   MOVE      *BLANKS       @KEY1
     C                   MOVEL     A7CUST        @KEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY

      ** Customer record not found - Error

     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'Y'           @ERR
     C                   MOVE      ':53 :'       MTAG
     C                   MOVEL     A7CUST        MFLD
     C                   MOVE      MSGA(2)       MERR

     C                   ELSE

      ** B Type address

     C                   MOVE      BBPCNB        @PCNB             6 0
     C*****SPAIN         IFEQ      'P'                                                     AR1094963
     C*****@PCNB         ANDEQ     SECN                                                    AR1094963
     C*****BBPAIN        OREQ      'P'                                                     AR1094963
     C*****A7CUST        ANDEQ     SPCNB                                                   AR1094963
     C*****BBPCNB        OREQ      SPCNB                                                   AR1094963
     C*****BBPCNB        ANDNE     *BLANKS                                                 AR1094963
      *                                                                                    AR1094963
     C                   IF        SPAIN = 'P' AND %CHAR(@PCNB) = SECN                     AR1094963
     C                             OR BBPAIN = 'P' AND A7CUST = SPCNB                      AR1094963
     C                             OR BBPCNB = SPCNB AND BBPCNB <> *BLANKS                 AR1094963

     C                   MOVE      ':53B:'       MTAG
     C                   MOVE      *BLANKS       @WRK
     C                   MOVEA     BBCRNM        @WRK(1)
     C                   Z-ADD     22            J                 2 0
     C                   MOVEA     BBCRTN        @WRK(J)
     C                   MOVEA     @WRK          MFLD

      ** D Type address

     C                   ELSE
     C                   MOVE      ':53D:'       MTAG
     C                   MOVEL     ZSADD1        MFLD

      ** Address 2

     C     ZSADD2        IFNE      *BLANKS
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEL     ZSADD2        MFLD

      ** Address 3

     C     ZSADD3        IFNE      *BLANKS
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEL     ZSADD3        MFLD

      ** Address 4

     C     ZSADD4        IFNE      *BLANKS
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEL     ZSADD4        MFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   FMTX1 - Format Fields 86 & 87 - Sequence C                  *
      *   Called by   SRFMTC format message details Sequence C        *
      *   Calls       FSWAD  format SWIFT address                     *
      *                                                               *
      *****************************************************************
     C     FMTX1         BEGSR

     C                   MOVE      'N'           FLD87O            1

      **  Field :87:  A/C with institution non-blank

     C     MGAWBN        IFNE      *BLANKS

      **  Field :86:  Pay Intermediary bank

     C     MGPIBN        IFNE      *BLANKS
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      *BLANKS       ZDEST
     C                   MOVEL     MGPIBN        ZDEST
     C                   MOVEL     *BLANKS       ACLINE
     C                   MOVEL     MGPIBA        ACLINE
     C                   MOVE      ' '           TAG
     C                   MOVE      @TAGI         FLDNO
     C                   EXSR      FSWAD
     C                   ENDIF

      ** Format Account with institution

     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      *BLANKS       ZDEST
     C                   MOVEL     MGAWBN        ZDEST
     C                   MOVEL     *BLANKS       ACLINE

     C/COPY WNCPYSRC,MG0600C051

     C                   MOVEL     MGBENA        ACLINE
     C                   MOVE      ' '           TAG
     C                   MOVE      @TAGD         FLDNO

     C/COPY WNCPYSRC,MG0600C004

     C                   MOVE      NETSL         CKNETI
     C                   EXSR      FSWAD
     C                   MOVE      'Y'           FLD87O            1

      ** A/C with Inst. blank

     C                   ELSE

      **  Field 87 = pay nostro customer if settlement via '02' or '12'
      **  OR if A/c with Bank Account line set up as 'DIRECT'

     C     MGPSTM        IFEQ      02
     C     MGPSTM        OREQ      12
     C     AWBA6         OREQ      'DIRECT'
     C                   MOVEL     MGPONS        @NONB

      ** Use payment settlement currency to access nostro if not blank.
      ** Otherwise use sell currency.

     C     CEU003        IFEQ      'Y'
     C     MGPYCY        ANDNE     *BLANKS
     C                   MOVE      MGPYCY        @CYCD
     C                   ELSE
     C                   MOVE      MGSLCY        @CYCD
     C                   ENDIF

     C                   CALL      'AONOSTR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @CUST             6
     C                   PARM                    @CYCD             3
     C                   PARM      *BLANKS       @ACCD             4
     C                   PARM      *BLANKS       @ACSN             2
     C                   PARM                    @NONB             2
     C                   PARM      *BLANKS       @BRCD             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY

      ** Nostro customer not found

     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'Y'           @ERR
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEL     MGPONS        HLD2              2
     C                   MOVEL     MGSLCY        HLD5
     C                   MOVE      HLD2          HLD5              5
     C                   MOVEL     HLD5          MFLD
     C                   MOVEL     MSGA(3)       MERR
     C     @TAGD         IFEQ      '57'
     C                   MOVE      ':57 :'       MTAG
     C                   ELSE
     C                   MOVE      ':87 :'       MTAG
     C                   ENDIF
     C                   ELSE

      ** Format our Pay Nostro Customer Address

     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      *BLANKS       ZDEST
     C     MGRVNO        IFEQ      *BLANKS
     C                   MOVEL     A7CUST        ZDEST
     C                   ELSE
     C                   MOVEL     MGRVNO        ZDEST
     C                   ENDIF
     C                   MOVEL     *BLANKS       ACLINE
     C                   MOVE      ' '           TAG
     C                   MOVE      @TAGD         FLDNO
     C                   MOVE      NETSL         CKNETI
     C                   EXSR      FSWAD
     C                   ENDIF

     C                   ELSE
     C                   MOVE      MGPSTM        @STM
     C     @STM          LOOKUP    TABINT                                 23

     C     *IN23         IFEQ      '1'
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      *BLANKS       ZDEST
     C                   MOVEL     SECN          ZDEST
     C                   MOVEL     *BLANKS       ACLINE
     C                   MOVE      ' '           TAG
     C                   MOVE      @TAGD         FLDNO
     C                   MOVE      NETSL         CKNETI
     C                   EXSR      FSWAD

     C                   ELSE

      ** Use payment settlement currency to access nostro if not blank.
      ** Otherwise use sell currency.

     C     CEU003        IFEQ      'Y'
     C     MGPYCY        ANDNE     *BLANKS
     C                   MOVE      MGPYCY        @NSKYB
     C                   ELSE
     C                   MOVE      MGSLCY        @NSKYB
     C                   ENDIF

      ** Tag 53 should not be included inside 15C Sequence                                  MD033754
     C     SEQ15C        IFNE      'Y'                                                      MD033754
      ** Field 53 is equal to Our Pay Nostro

     C                   MOVEL     MGPONS        @NSKYE
     C                   CALL      'AONOSTR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @NSKYA            6
     C                   PARM                    @NSKYB            3
     C                   PARM      *BLANKS       @NSKYC            4
     C                   PARM      *BLANKS       @NSKYD            2
     C                   PARM                    @NSKYE            2
     C                   PARM      *BLANKS       @KEYF             3
     C                   PARM      *BLANKS       @KEYG            10
     C                   PARM      *BLANKS       @KEYH             1
     C     SDNOST        PARM      SDNOST        DSFDY

      ** Nostro customer not found

     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      'Y'           @ERR
     C                   MOVE      ':53 :'       MTAG
     C                   MOVEL     MGPONS        MFLD
     C                   MOVEL     MSGA(3)       MERR
     C                   ELSE

      ** Format our Pay Nostro Customer Address
      ** ( only if Tag 53A not yet generated )

     C     *IN55         IFEQ      '1'
     C                   MOVE      '0'           *IN55
     C                   ELSE

     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVE      *BLANKS       ZDEST
     C                   MOVEL     A7CUST        ZDEST
     C                   MOVEL     *BLANKS       ACLINE
     C                   MOVE      ' '           TAG
     C                   MOVE      '53'          FLDNO
     C                   EXSR      FSWAD
     C                   ENDIF

     C                   ENDIF
                                                                                            MD033754
     C                   ENDIF                                                              MD033754

      ** Settlement 01,07 or 08 with MGAWBN blank or settlement 00

     C                   ADD       1             X
     C     X             OCCUR     MULT
     C     @TAGD         IFEQ      '57'
     C                   MOVE      ':57D:'       MTAG
     C                   ELSE
     C                   MOVE      ':87D:'       MTAG
     C                   ENDIF
     C                   MOVEL     'UNKNOWN'     MFLD

     C/COPY WNCPYSRC,MG0600CCP2

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   SRREPT - print incorrectly generated messages               *
      *   Called by   Main process                                    *
      *                                                               *
      *****************************************************************
     C     SRREPT        BEGSR

     C     *IN50         IFEQ      '0'
     C                   OPEN      MG000600P1
     C                   SETON                                        50
     C                   ENDIF

      ** Set up headings and sender/customer information
      ** for the error report

     C                   MOVE      '0'           *IN30
     C     @FEED         IFEQ      ' '
     C                   MOVE      '1'           *IN30
     C                   ENDIF
     C                   MOVEL     MGTNUM        TNUM              6 0
     C                   WRITE     HEADER
     C                   WRITE     TEXT

      ** Process multiple occurrence data structure

     C                   Z-ADD     0             I                 2 0
     C     I             DOWLE     X
     C                   ADD       1             I
     C     I             OCCUR     MULT
     C     *IN99         IFEQ      '1'                                                      MD022425
     C                   WRITE     HEADER                                                   MD022425
     C                   WRITE     TEXT                                                     MD022425
     C                   WRITE     LINE                                                     MD022425
     C                   MOVE      '0'           *IN99                                      MD022425
     C                   ELSE                                                               MD022425
     C                   WRITE     LINE
     C                   ENDIF                                                              MD022425
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   SROMSG - output correctly generated messages                *
      *   Called by   Main process                                    *
      *                                                               *
      *****************************************************************
      *
     C     SROMSG        BEGSR

      ** Write reference record  (PF/MGOREFPD)

     C                   EXSR      SRWREF

     C/COPY WNCPYSRC,MG0600CCP6

      ** Write multiple occurrence data structure to MGOMSGPD

     C                   Z-ADD     1             X
     C     X             OCCUR     MULT

     C     X             DOWLE     95
     C     MULT          ANDNE     *BLANKS
     C                   WRITE     MGOMSGD0                             06

     C/COPY WNCPYSRC,MG0600CCP7

      **  Error on write to PF/MGOMSGPD (message data file)

     C     *IN06         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '024'         DBASE
     C                   MOVEL     '        '    DBKEY
     C                   MOVEL     'MGOMSGPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C/COPY WNCPYSRC,MG0600C005

     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDDO

      ** Write multiple occurrence data structure to MGOEXTPD

     C                   Z-ADD     1             V                 2 0
     C     V             OCCUR     EXTN
     C     V             DOWLE     20
     C     MCSI          ANDNE     *BLANKS
     C                   WRITE     MGOEXTD0                             06

      ** Error on write to PF/MGOEXTPD (message data extension file)

     C     *IN06         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '027'         DBASE
     C                   MOVEL     '        '    DBKEY
     C                   MOVEL     'MGOEXTPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ADD       1             V
     C     V             OCCUR     EXTN
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   CFMAT - produce confirmation matching feedback record       *
      *   Called by   Main process                                    *
      *                                                               *
      *****************************************************************
     C     CFMAT         BEGSR

     C                   CALL      'MG5001'
     C                   PARM      TRNO          @TRNM            16
     C                   PARM      MGBRCA        @BRCA             3
     C                   PARM      *BLANK        @FEED             1

     C     @FEED         IFEQ      'Y'

     C     *IN50         IFEQ      '0'
     C                   OPEN      MG000600P1
     C                   SETON                                        50U7
     C                   ENDIF

      ** Set up headings and sender/customer information
      ** for the error report

     C                   MOVE      '1'           *IN30
     C                   MOVEL     MGTNUM        TNUM              6 0
     C                   WRITE     HEADER
     C                   WRITE     TEXT
     C                   WRITE     FEED
     C                   MOVE      '0'           *IN30
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   SRWREF - Write reference record to PF/MGOREFPD              *
      *   Called by   SROMSG  output message PF/MGOMSGPD              *
      *                                                               *
      *****************************************************************
     C     SRWREF        BEGSR

     C                   MOVE      *BLANKS       SYTM
     C                   MOVE      MGMODI        MODI
     C                   MOVEL     @TRNO         TRNO
     C                   MOVE      *BLANKS       TRNF
     C                   MOVE      *BLANKS       TRNM
     C     MGACMI        IFEQ      'Y'                                                      MD022425
     C                   MOVEL     @TRNID        MTRN                                       MD022425
     C                   ELSE                                                               MD022425
     C                   MOVEL     @TR2          MTRN
     C                   ENDIF                                                              MD022425
     C                   MOVE      MGTTYP        TNTP
     C                   MOVE      MGTSTP        SBTP
     C                   MOVE      *BLANKS       EVTP
     C                   MOVEL     *BLANKS       NWBN
     C                   MOVE      '600'         MTPY
     C                   MOVE      'N'           MPRY
     C                   MOVEL     CWRD          LSCC
     C                   MOVEL     *BLANKS       PTST
     C                   MOVEL     *BLANKS       CARQ
     C                   MOVEL     *BLANKS       MPDE
     C                   MOVEL     @HRDT         HRDT
     C                   TIME                    MGTM
     C                   MOVE      BJMRDT        LADT
     C                   MOVE      MGTM          LATM

     C     MGST          IFEQ      'RSND'
     C                   MOVE      BJMRDT        RELD
     C                   MOVE      MGTM          RELT
     C                   ENDIF

     C                   MOVEL     *BLANKS       RUSR
     C                   MOVEL     *BLANKS       RWSN
     C                   MOVEL     *BLANKS       AMTS
     C                   MOVEL     *BLANKS       AMTX
     C                   MOVEL     *BLANKS       SVDT
     C                   MOVEL     *BLANKS       CINDV
     C                   MOVEL     *BLANKS       CCY
     C                   MOVEL     *BLANKS       NSNO
     C                   MOVEL     *BLANKS       SACN
     C                   MOVEL     *BLANKS       AORR
     C                   MOVEL     *BLANKS       DESI

      ** Branch details

     C                   MOVE      MGBRCA        BRCA
     C                   MOVE      MGPOBR        OTHB
     C     OTHB          IFNE      *BLANKS
     C                   MOVEL     MSGA(1)       OTHT
     C                   ENDIF
     C                   MOVE      MGROBR        RCBR

     C                   MOVE      *BLANKS       NETI
     C                   MOVE      *BLANKS       DELC
     C                   MOVE      *BLANKS       DYST
     C                   MOVE      *BLANKS       RSID
     C                   MOVE      *BLANKS       MSE1
     C                   MOVE      *BLANKS       ELIN
     C                   MOVE      *BLANKS       SSAC
     C                   MOVE      *BLANKS       MIR
     C                   MOVE      *BLANKS       TSKS
     C                   MOVE      *BLANKS       TSKY

      ** Set up CLS field when CDL002 is switched on

     C     CDL002        IFEQ      'Y'
     C                   MOVE      MGCLSS        CLSS
     C                   ENDIF
     C                   MOVE      MGCHTP        AORR

     C/COPY WNCPYSRC,MG0600C035

     C                   WRITE     MGOREFD0                             05

      ** Error on write to PF/MGOREFPD (message reference file)

     C     *IN05         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '025'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'MGOREFPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Write transaction history record

     C     MGACMI        IFEQ      'Y'                                                      MD022425
     C                   MOVEL     TRNO          @HREF1                                     MD022425
     C                   MOVEL     @HREF1        @HREF                                      MD024078
     C                   MOVE      '000'         HSSEQ                                      MD022425
     C                   MOVE      @SSEQ         HSSEQ                                      MD022425
     C                   ELSE                                                               MD022425
     C                   MOVEL     TRNO          @HREF
     C                   ENDIF                                                              MD022425
     C                   MOVE      '600'         HSMTPY

     C                   WRITE     MGHISTD0                             56

      **  Error on write to PF/MGHISTPD

     C     *IN56         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '027'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'MGHISTPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END

     C/COPY WNCPYSRC,MG0600C006

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   SRBTB - Store Sender to Receiver Information to temp work   *
      *           fields                                              *
      *                                                               *
      *****************************************************************
     C     SRBTB         BEGSR
     C                   MOVEA     *BLANKS       @BTB
     C                   MOVE      MGBTB1        @BTB(1)
     C                   MOVE      MGBTB2        @BTB(2)
     C                   MOVE      MGBTB3        @BTB(3)
     C                   MOVE      MGBTB4        @BTB(4)
     C                   MOVE      MGBTB5        @BTB(5)
     C                   MOVE      MGBTB6        @BTB(6)
     C                   ENDSR
     C/EJECT                                                                                MD022425
      *****************************************************************                     MD022425
      *   SRFMTD - Format message detail - Sequence D                 *                     MD022425
      *   Called by   Main process                                    *                     MD022425
      *   Calls                                                       *                     MD022425
      *****************************************************************                     MD022425
                                                                                            MD022425
     C     SRFMTD        BEGSR                                                              MD022425
      *                                                                                     MD022425
      **  Field :15D: New Sequence                                                          MD022425
      *                                                                                     MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVE      ':15D:'       MTAG                                       MD022425
     C                   MOVEL     *BLANK        MFLD                                       MD022425
     C                   Z-ADD     X             X15D              2 0                      MD024078
      *                                                                                     MD022425
      **  Clear multiple occurrence DS for the RPPT                                         MD022425
      *                                                                                     MD022425
     C                   Z-ADD     1             Y                 1 0                      MD022425
     C     Y             OCCUR     RPPT                                                     MD022425
     C     Y             DOWLE     4                                                        MD022425
      *                                                                                     MD022425
     C                   CLEAR                   RPPT                                       MD022425
      *                                                                                     MD022425
      **  This will clear the RPPT Multi-Occurence DS for the ff fields                     MD022425
      **  MGRJXX - Reporting Jurisdiction    MGUTXX - UTI Namespace/Issuer Code             MD022425
      **  MGRPXX - Reporting Party           MGTNXX - Transaction Identifier                MD022425
      **  MGRNXX - Reporting Party Name      MGTIXX - Transaction Identifier Type           MD022425
      **  MGRCXX - Reporting Party City      MGETXX - Event Type                            MD022425
      **  MGRSXX - Reporting Party SWIFT identification                                     MD022425
      **  MGRLXX - Reporting Party LEI                                                      MD022425
      **  MGRAXX - Reporting Party Account                                                  MD022425
      *                                                                                     MD022425
     C                   ADD       1             Y                                          MD022425
     C     Y             OCCUR     RPPT                                                     MD022425
     C                   ENDDO                                                              MD022425
     C                   Z-ADD     0             Y                                          MD022425
      *                                                                                     MD022425
      **  Initialize multioccurence DS RPPT with the 4 set of fields                        MD022425
      *                                                                                     MD022425
     C                   Z-ADD     1             Y1                1 0                      MD022425
     C     Y1            OCCUR     RPPT                                                     MD022425
     C     Y1            DOWLE     4                                                        MD022425
     C     Y1            IFEQ      1                                                        MD022425
     C                   MOVE      MGRJ01        MGRJXX                                     MD022425
     C                   MOVE      MGRP01        MGRPXX                                     MD022425
     C                   MOVE      MGRN01        MGRNXX                                     MD022425
     C                   MOVE      MGRC01        MGRCXX                                     MD022425
     C                   MOVE      MGRS01        MGRSXX                                     MD022425
     C                   MOVE      MGRL01        MGRLXX                                     MD022425
     C                   MOVE      MGRA01        MGRAXX                                     MD022425
     C                   MOVE      MGUT01        MGUTXX                                     MD022425
     C                   MOVE      MGTN01        MGTNXX                                     MD022425
     C                   MOVE      MGTI01        MGTIXX                                     MD022425
     C                   MOVE      MGET01        MGETXX                                     MD022425
     C                   ENDIF                                                              MD022425
     C     Y1            IFEQ      2                                                        MD022425
     C                   MOVE      MGRJ02        MGRJXX                                     MD022425
     C                   MOVE      MGRP02        MGRPXX                                     MD022425
     C                   MOVE      MGRN02        MGRNXX                                     MD022425
     C                   MOVE      MGRC02        MGRCXX                                     MD022425
     C                   MOVE      MGRS02        MGRSXX                                     MD022425
     C                   MOVE      MGRL02        MGRLXX                                     MD022425
     C                   MOVE      MGRA02        MGRAXX                                     MD022425
     C                   MOVE      MGUT02        MGUTXX                                     MD022425
     C                   MOVE      MGTN02        MGTNXX                                     MD022425
     C                   MOVE      MGTI02        MGTIXX                                     MD022425
     C                   MOVE      MGET02        MGETXX                                     MD022425
     C                   ENDIF                                                              MD022425
     C     Y1            IFEQ      3                                                        MD022425
     C                   MOVE      MGRJ03        MGRJXX                                     MD022425
     C                   MOVE      MGRP03        MGRPXX                                     MD022425
     C                   MOVE      MGRN03        MGRNXX                                     MD022425
     C                   MOVE      MGRC03        MGRCXX                                     MD022425
     C                   MOVE      MGRS03        MGRSXX                                     MD022425
     C                   MOVE      MGRL03        MGRLXX                                     MD022425
     C                   MOVE      MGRA03        MGRAXX                                     MD022425
     C                   MOVE      MGUT03        MGUTXX                                     MD022425
     C                   MOVE      MGTN03        MGTNXX                                     MD022425
     C                   MOVE      MGTI03        MGTIXX                                     MD022425
     C                   MOVE      MGET03        MGETXX                                     MD022425
     C                   ENDIF                                                              MD022425
     C     Y1            IFEQ      4                                                        MD022425
     C                   MOVE      MGRJ04        MGRJXX                                     MD022425
     C                   MOVE      MGRP04        MGRPXX                                     MD022425
     C                   MOVE      MGRN04        MGRNXX                                     MD022425
     C                   MOVE      MGRC04        MGRCXX                                     MD022425
     C                   MOVE      MGRS04        MGRSXX                                     MD022425
     C                   MOVE      MGRL04        MGRLXX                                     MD022425
     C                   MOVE      MGRA04        MGRAXX                                     MD022425
     C                   MOVE      MGUT04        MGUTXX                                     MD022425
     C                   MOVE      MGTN04        MGTNXX                                     MD022425
     C                   MOVE      MGTI04        MGTIXX                                     MD022425
     C                   MOVE      MGET04        MGETXX                                     MD022425
     C                   ENDIF                                                              MD022425
     C                   ADD       1             Y1                                         MD022425
     C     Y1            OCCUR     RPPT                                                     MD022425
     C                   ENDDO                                                              MD022425
     C                   Z-ADD     0             Y1                                         MD022425
      *                                                                                     MD022425
     C                   Z-ADD     0             WRKIX             1 0                      MD022425
     C                   MOVEL     'N'           WRKFLG            1                        MD022425
      *                                                                                     MD022425
      **  Do Loop for 4 times                                                               MD022425
      *                                                                                     MD022425
     C     WRKIX         DOWLT     4                                                        MD022425
     C                   ADD       1             WRKIX                                      MD022425
     C     WRKIX         OCCUR     RPPT                                                     MD022425
      *                                                                                     MD022425
      **  Reporting Jurisdiction                                                            MD022425
      *                                                                                     MD022425
     C     MGRJXX        IFEQ      *BLANKS                                                  MD022425
     C                   ADD       5             WRKIX                                      MD022425
     C                   ELSE                                                               MD022425
     C*****MGRJXX        IFNE      *BLANKS                                         MD022425 MD024078
     C*****MGRPXX        ANDNE     *BLANKS                                         MD022425 MD024078
     C*****MGRNXX        ANDNE     *BLANKS                                         MD022425 MD024078
     C*****MGRCXX        ANDNE     *BLANKS                                         MD022425 MD024078
     C*****MGRSXX        ANDNE     *BLANKS                                         MD022425 MD024078
     C*****MGRLXX        ANDNE     *BLANKS                                         MD022425 MD024078
     C*****MGRAXX        ANDNE     *BLANKS                                         MD022425 MD024078
     C     MGRJXX        IFNE      WRKMRJ                                                   MD024078
     C     MGRPXX        ORNE      WRKMRP                                                   MD024078
     C     MGRNXX        ORNE      WRKMRN                                                   MD024078
     C     MGRCXX        ORNE      WRKMRC                                                   MD024078
     C     MGRSXX        ORNE      WRKMRS                                                   MD024078
     C     MGRLXX        ORNE      WRKMRL                                                   MD024078
     C     MGRAXX        ORNE      WRKMRA                                                   MD024078
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':22L:'       MTAG                                       MD022425
     C                   MOVEL     MGRJXX        MFLD                                       MD022425
     C                   MOVEL     'N'           WRKFLG                                     MD022425
     C**********         ENDIF                                                     MD022425 MD024078
      *                                                                                     MD022425
      **  Reporting Party                                                                   MD022425
      *                                                                                     MD022425
     C     MGRPXX        IFNE      *BLANKS                                                  MD022425
     C                   MOVEL     MGRPXX        WRKMRP            6                        MD024078
     C                   MOVEL     MGRJXX        WRKMRJ           35                        MD024078
     C                   MOVEL     MGRNXX        WRKMRN           20                        MD024078
     C                   MOVEL     MGRCXX        WRKMRC           10                        MD024078
     C                   MOVEL     MGRSXX        WRKMRS           11                        MD024078
     C                   MOVEL     MGRLXX        WRKMRL           20                        MD024078
     C                   MOVEL     MGRAXX        WRKMRA           34                        MD024078
     C                   MOVE      *BLANKS       ZDEST                                      MD022425
     C                   MOVEL     MGRPXX        ZDEST                                      MD022425
     C                   MOVEL     MGRAXX        ACLINE                                     MD022425
     C                   MOVEL     '91'          FLDNO                                      MD022425
     C                   MOVE      *BLANKS       TAG                                        MD022425
     C                   EXSR      SRFMPY                                                   MD022425
     C                   ELSE                                                               MD022425
     C     MGRLXX        IFEQ      *BLANKS                                                  MD022425
     C     MGRNXX        ANDEQ     *BLANKS                                                  MD022425
     C     MGRSXX        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':91A:'       MTAG                                       MD022425
     C                   MOVEL     *BLANKS       MFLD                                       MD022425
     C                   MOVEL     MGRSXX        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   ELSE                                                               MD022425
     C                   MOVEL     MGRPXX        WRKMRP                                     MD024078
     C                   MOVEL     MGRJXX        WRKMRJ                                     MD024078
     C                   MOVEL     MGRNXX        WRKMRN                                     MD024078
     C                   MOVEL     MGRCXX        WRKMRC                                     MD024078
     C                   MOVEL     MGRSXX        WRKMRS                                     MD024078
     C                   MOVEL     MGRLXX        WRKMRL                                     MD024078
     C                   MOVEL     MGRAXX        WRKMRA                                     MD024078
     C     MGRNXX        IFNE      *BLANKS                                                  MD022425
     C     MGRSXX        ANDNE     *BLANKS                                                  MD022425
     C     MGRNXX        ORNE      *BLANKS                                                  MD022425
     C     MGRLXX        ANDNE     *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':91J:'       MTAG                                       MD022425
     C     MGRSXX        IFNE      *BLANKS                                                  MD022425
     C     '/ABIC/'      CAT       MGRSXX        MFLD                                       MD022425
     C                   ELSE                                                               MD022425
     C     '/ABIC'       CAT       '/UKWN'       MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     MGRLXX        IFNE      *BLANKS                                                  MD022425
     C     '/LEIC/'      CAT       MGRLXX        MFLD                                       MD022425
     C                   ELSE                                                               MD022425
     C     '/NAME/'      CAT       MGRNXX        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGRCXX        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     '/NAME/'      CAT       MGRCXX        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   ELSE                                                               MD022425
     C     MGRNXX        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':91D:'       MTAG                                       MD022425
     C                   MOVEL     MGRNXX        MFLD                                       MD022425
     C     MGRCXX        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     MGRCXX        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   ENDIF                                                              MD022425
     C                   ENDIF                                                              MD022425
     C                   ENDIF                                                              MD022425
     C                   ENDIF                                                              MD022425
     C                   ENDIF                                                              MD024078
      *                                                                                     MD022425
      **  Unique Transaction Identifier/Prior Unique Transaction Identifier                 MD022425
      *                                                                                     MD022425
     C     MGUTXX        IFNE      *BLANKS                                                  MD022425
     C     MGTNXX        ANDNE     *BLANKS                                                  MD022425
     C     MGTIXX        IFEQ      '0'                                                      MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':22M:'       MTAG                                       MD022425
     C                   MOVEL     MGUTXX        MFLD                                       MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':22N:'       MTAG                                       MD022425
     C                   MOVEL     MGTNXX        MFLD                                       MD022425
     C                   MOVEL     'Y'           WRKFLG                                     MD022425
     C                   ELSE                                                               MD022425
     C     WRKFLG        IFEQ      'Y'                                                      MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':22P:'       MTAG                                       MD022425
     C                   MOVEL     MGUTXX        MFLD                                       MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':22R:'       MTAG                                       MD022425
     C                   MOVEL     MGTNXX        MFLD                                       MD022425
     C                   ELSE                                                               MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':22M:'       MTAG                                       MD022425
     C                   MOVEL     MGUTXX        MFLD                                       MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':22N:'       MTAG                                       MD022425
     C                   MOVEL     MGTNXX        MFLD                                       MD022425
     C                   MOVEL     'Y'           WRKFLG                                     MD022425
     C                   ENDIF                                                              MD022425
     C                   ENDIF                                                              MD022425
     C                   ENDIF                                                              MD022425
     C                   ENDIF                                                              MD022425
      *                                                                                     MD022425
     C                   ENDDO                                                              MD022425
      **********                                                                   MD022425 MD030880
      ****Central Counterparty Clearing House                                      MD022425 MD030880
      **********                                                                   MD022425 MD030880
     C*****MGCCPI        IFNE      *BLANKS                                         MD022425 MD030880
     C**********         MOVE      *BLANKS       ZDEST                             MD022425 MD030880
     C**********         MOVEL     MGCCPI        ZDEST                             MD022425 MD030880
     C**********         MOVEL     MGCCPA        ACLINE                            MD022425 MD030880
     C**********         MOVEL     '81'          FLDNO                             MD022425 MD030880
     C**********         MOVE      *BLANKS       TAG                               MD022425 MD030880
     C**********         EXSR      SRFMPY                                          MD022425 MD030880
     C**********         ENDIF                                                     MD022425 MD030880
      *                                                                                     MD022425
      **  Clearing Exception Party                                                          MD022425
      *                                                                                     MD022425
     C     MGCEPI        IFNE      *BLANKS                                                  MD022425
     C                   MOVE      *BLANKS       ZDEST                                      MD022425
     C                   MOVEL     MGCEPI        ZDEST                                      MD022425
     C                   MOVEL     MGCEPA        ACLINE                                     MD022425
     C                   MOVEL     '96'          FLDNO                                      MD022425
     C                   MOVE      *BLANKS       TAG                                        MD022425
     C                   EXSR      SRFMPY                                                   MD022425
     C                   ENDIF                                                              MD022425
      *                                                                                     MD022425
      **  Clearing Broker Identification                                                    MD022425
      *                                                                                     MD022425
     C     MGCBCI        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':22S:'       MTAG                                       MD022425
     C     'C/'          CAT       MGCBCI        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGCBPI        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':22S:'       MTAG                                       MD022425
     C     'P/'          CAT       MGCBPI        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
      *                                                                                     MD022425
      **  Cleared Product Identification                                                    MD022425
      *                                                                                     MD022425
     C     MGPRID        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':22T:'       MTAG                                       MD022425
     C                   MOVEL     MGPRID        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
      *                                                                                     MD022425
      **  Clearing Threshold Indicator                                                      MD022425
      *                                                                                     MD022425
     C     MGCGTI        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':17E:'       MTAG                                       MD022425
     C                   MOVEL     MGCGTI        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
      *                                                                                     MD022425
      **  Underlying Product Identifier                                                     MD022425
      *                                                                                     MD022425
     C     MGUPID        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':22U:'       MTAG                                       MD022425
     C                   MOVEL     MGUPID        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
      *                                                                                     MD022425
      **  Allocation Indicator                                                              MD022425
      *                                                                                     MD022425
     C     MGALLI        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':17H:'       MTAG                                       MD022425
     C                   MOVEL     MGALLI        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
      *                                                                                     MD022425
      **  Collateralisation Indicator                                                       MD022425
      *                                                                                     MD022425
     C     MGCLLI        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':17P:'       MTAG                                       MD022425
     C                   MOVEL     MGCLLI        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
      *                                                                                     MD022425
      **  Execution Venue                                                                   MD022425
      *                                                                                     MD022425
     C     MGEXVE        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':22V:'       MTAG                                       MD022425
     C                   MOVEL     MGEXVE        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
      *                                                                                     MD022425
      **  Execution Timestamp                                                               MD022425
      *                                                                                     MD022425
     C     MGUTCT        IFNE      *ZEROS                                                   MD022425
     C     MGGEDT        ORNE      *ZEROS                                                   MD024078
     C     MGGETM        ORNE      *ZEROS                                                   MD024078
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':98D:'       MTAG                                       MD022425
     C                   MOVE      MGGEDT        DNGEDT            8                        MD022425
     C                   MOVE      MGGETM        DNGETM            6                        MD022425
     C                   MOVE      MGUTCT        DNUTCT            4                        MD022425
     C     MGUSGN        IFEQ      'N'                                                      MD022425
     C     DNGEDT        CAT       DNGETM        ETIME1           14                        MD022425
     C     '/N'          CAT       DNUTCT        ETIME2            6                        MD022425
     C     ETIME1        CAT       ETIME2        MFLD                                       MD022425
     C                   ELSE                                                               MD022425
     C     DNGEDT        CAT       DNGETM        ETIME1           14                        MD022425
     C     ETIME1        CAT       DNUTCT        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   ENDIF                                                              MD022425
      *                                                                                     MD022425
      **  Non Standard Flag                                                                 MD022425
      *                                                                                     MD022425
     C     MGNORS        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':17W:'       MTAG                                       MD022425
     C                   MOVEL     MGNORS        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
      *                                                                                     MD022425
      **  Link Swap Identification                                                          MD022425
      *                                                                                     MD022425
     C     MGLSID        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     ':22W:'       MTAG                                       MD022425
     C                   MOVEL     MGLSID        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
                                                                                              CSW214
      ** Financial Nature of the Counterparty Indicator                                       CSW214
                                                                                              CSW214
     C                   IF        MGFNCI <> *BLANKS                                          CSW214
     C                   ADD       1             X                                            CSW214
     C     X             OCCUR     MULT                                                       CSW214
     C                   MOVEL     ':17Y:'       MTAG                                         CSW214
     C                   MOVEL     MGFNCI        MFLD                                         CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Collateral Portfolio Indicator                                                       CSW214
                                                                                              CSW214
     C                   IF        MGCOPI <> *BLANKS                                          CSW214
     C                   ADD       1             X                                            CSW214
     C     X             OCCUR     MULT                                                       CSW214
     C                   MOVEL     ':17Z:'       MTAG                                         CSW214
     C                   MOVEL     MGCOPI        MFLD                                         CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Collateral Portfolio Code                                                            CSW214
                                                                                              CSW214
     C                   IF        MGCOPI = 'Y' AND                                           CSW214
     C                             MGCOPC <> *BLANKS                                          CSW214
     C                   ADD       1             X                                            CSW214
     C     X             OCCUR     MULT                                                       CSW214
     C                   MOVEL     ':22Q:'       MTAG                                         CSW214
     C                   MOVEL     MGCOPC        MFLD                                         CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Portfolio Compression Indicator                                                      CSW214
                                                                                              CSW214
     C                   IF        MGPOCI <> *BLANKS                                          CSW214
     C                   ADD       1             X                                            CSW214
     C     X             OCCUR     MULT                                                       CSW214
     C                   MOVEL     ':17L:'       MTAG                                         CSW214
     C                   MOVEL     MGPOCI        MFLD                                         CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Corporate Sector Indicator                                                           CSW214
                                                                                              CSW214
     C                   IF        MGCOSI <> *BLANKS                                          CSW214
     C                   ADD       1             X                                            CSW214
     C     X             OCCUR     MULT                                                       CSW214
     C                   MOVEL     ':17M:'       MTAG                                         CSW214
     C                   MOVEL     MGCOSI        MFLD                                         CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Trade with Non-EEA Counterparty Indicator                                            CSW214
                                                                                              CSW214
     C                   IF        MGTNEI <> *BLANKS                                          CSW214
     C                   ADD       1             X                                            CSW214
     C     X             OCCUR     MULT                                                       CSW214
     C                   MOVEL     ':17Q:'       MTAG                                         CSW214
     C                   MOVEL     MGTNEI        MFLD                                         CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Intragroup Trade Indicator                                                           CSW214
                                                                                              CSW214
     C                   IF        MGIGTI <> *BLANKS                                          CSW214
     C                   ADD       1             X                                            CSW214
     C     X             OCCUR     MULT                                                       CSW214
     C                   MOVEL     ':17S:'       MTAG                                         CSW214
     C                   MOVEL     MGIGTI        MFLD                                         CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Commercial or Treasury Financial Indicator                                           CSW214
                                                                                              CSW214
     C                   IF        MGCTFI <> *BLANKS                                          CSW214
     C                   ADD       1             X                                            CSW214
     C     X             OCCUR     MULT                                                       CSW214
     C                   MOVEL     ':17X:'       MTAG                                         CSW214
     C                   MOVEL     MGCTFI        MFLD                                         CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDIF                                                                CSW214
      *                                                                                     MD022425
      **  Additional Reporting Information                                                  MD022425
      *                                                                                     MD022425
     C     MGAR01        IFNE      *BLANKS                                                  MD022425
     C     MGAR02        ORNE      *BLANKS                                                  MD022425
     C     MGAR03        ORNE      *BLANKS                                                  MD022425
     C     MGAR04        ORNE      *BLANKS                                                  MD022425
     C     MGAR05        ORNE      *BLANKS                                                  MD022425
     C     MGAR06        ORNE      *BLANKS                                                  MD022425
     C     MGAR07        ORNE      *BLANKS                                                  MD022425
     C     MGAR08        ORNE      *BLANKS                                                  MD022425
     C     MGAR09        ORNE      *BLANKS                                                  MD022425
     C     MGAR10        ORNE      *BLANKS                                                  MD022425
     C     MGAR11        ORNE      *BLANKS                                                  MD022425
     C     MGAR12        ORNE      *BLANKS                                                  MD022425
     C     MGAR13        ORNE      *BLANKS                                                  MD022425
     C     MGAR14        ORNE      *BLANKS                                                  MD022425
     C     MGAR15        ORNE      *BLANKS                                                  MD022425
     C     MGAR16        ORNE      *BLANKS                                                  MD022425
     C     MGAR17        ORNE      *BLANKS                                                  MD022425
     C     MGAR18        ORNE      *BLANKS                                                  MD022425
     C     MGAR19        ORNE      *BLANKS                                                  MD022425
     C     MGAR20        ORNE      *BLANKS                                                  MD022425
      *                                                                                     MD022425
     C                   MOVE      *BLANK        DN77              1                        MD022425
     C     MGAR01        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR01        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR02        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR02        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR03        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR03        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR04        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR04        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR05        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR05        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR06        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR06        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR07        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR07        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR08        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR08        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR09        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR09        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR10        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR10        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR11        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR11        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR12        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR12        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR13        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR13        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR14        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR14        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR15        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR15        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR16        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR16        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR17        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR17        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR18        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR18        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR19        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR19        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     MGAR20        IFNE      *BLANK                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     DN77          IFNE      'Y'                                                      MD022425
     C                   MOVE      ':77A:'       MTAG                                       MD022425
     C                   MOVE      'Y'           DN77                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   MOVE      *BLANK        MFLD                                       MD022425
     C                   MOVEL     MGAR20        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   ENDIF                                                              MD022425
      *                                                                                     MD022425
     C     X             IFEQ      X15D                                                     MD024078
     C                   MOVE      *BLANKS       MTAG                                       MD024078
     C                   SUB       1             X                                          MD024078
     C                   ENDIF                                                              MD024078
      *                                                                                     MD024078
     C                   ENDSR                                                              MD022425
     C/EJECT                                                                                MD022425
      *****************************************************************                     MD022425
      *   SRFMPY - Format message - Cust. Extension SWIFT Details     *                     MD022425
      *   Called by   Main process                                    *                     MD022425
      *   Calls - None                                                *                     MD022425
      *****************************************************************                     MD022425
      *                                                                                     MD022425
     C     SRFMPY        BEGSR                                                              MD022425
      *                                                                                     MD022425
     C     ACLINE        IFNE      *BLANKS                                                  MD022425
     C     1             SUBST     ACLINE:1      ACTEMP            1                        MD022425
     C     ACTEMP        IFNE      '/'                                                      MD022425
     C     '/'           CAT       ACLINE        ACLINE                                     MD022425
     C                   ENDIF                                                              MD022425
      *                                                                                     MD022425
      **  Access Customer for with ZDEST (10 first characters) field using                  MD022425
      **  AOCSSWR0 - Customer Extension SWIFT Details                                       MD022425
      *                                                                                     MD022425
     C                   CALL      'AOCSSWR0'                                               MD022425
     C                   PARM      '*MSG   '     @RTCD             7                        MD022425
     C                   PARM      '*KEY   '     @OPTN             7                        MD022425
     C                   PARM      ZDEST         @KEY1            10                        MD022425
     C                   PARM      *BLANKS       @KYST             7                        MD022425
     C                   PARM                    DSLDY                                      MD022425
      *                                                                                     MD022425
      ** Extract SDCUSTPD and SDCSSWPD                                                      MD024078
      *                                                                                     MD024078
     C                   MOVEL     'SDCUSTPD'    P#FILN                                     MD024078
     C                   EXSR      GETRCL                                                   MD024078
     C     P#RCDL        SUBST     DSLDY         SDCUST                                     MD024078
     C     P#RCDL        ADD       1             WLEN              5 0                      MD024078
      *                                                                                     MD024078
     C                   MOVEL     'SDCSSWPD'    P#FILN                                     MD024078
     C                   EXSR      GETRCL                                                   MD024078
     C     P#RCDL        SUBST     DSLDY:WLEN    SDCSSW                                     MD024078
      *                                                                                     MD024078
     C     BBCSID        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     'A'           TAG                                        MD022425
     C                   MOVEL     @MTAG         MTAG                                       MD022425
     C     ACLINE        IFNE      *BLANKS                                                  MD022425
     C                   MOVEL     ACLINE        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     BBCSID        MFLD                                       MD022425
     C                   ELSE                                                               MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C                   MOVEL     'J'           TAG                                        MD022425
     C                   MOVEL     @MTAG         MTAG                                       MD022425
     C     '/ABIC'       CAT       '/UKWN'       ABIUKW           10                        MD022425
     C                   MOVEL     ABIUKW        MFLD                                       MD022425
     C     CSCLID        IFNE      *BLANKS                                                  MD022425
     C     CSCLSY        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     '/CLRC/'      CAT       CSCLSY        CLRTMP           10                        MD022425
     C     CLRTMP        CAT       CSCLID        MFLD                                       MD022425
     C                   ELSE                                                               MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     '/CLRC/'      CAT       CSCLID        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   ELSE                                                               MD022425
     C     BBCHID        IFNE      *ZEROS                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     '/CLRC'       CAT       '/CH'         CLRCH             8                        MD022425
     C                   MOVE      BBCHID        DNCHID            6                        MD022425
     C     CLRCH         CAT       DNCHID        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     BBCHSC        IFNE      *ZEROS                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     '/CLRC'       CAT       '/SC'         CLRSC             8                        MD022425
     C                   MOVE      BBCHSC        DNCHSC            6                        MD022425
     C     CLRSC         CAT       DNCHSC        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     BBCABA        IFNE      *ZEROS                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     '/CLRC'       CAT       '/CP'         CLRCP             8                        MD022425
     C                   MOVE      BBCABA        DNCABA            3                        MD022425
     C     CLRCP         CAT       DNCABA        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     BBBFIC        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     '/CLRC'       CAT       '/BJ'         CLRBJ             8                        MD022425
     C     CLRBJ         CAT       BBBFIC        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     BBBLCD        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     '/CLRC'       CAT       '/BL'         CLRBL             8                        MD022425
     C     CLRBL         CAT       BBBLCD        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C     BBFWCD        IFNE      *ZEROS                                                   MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     '/CLRC'       CAT       '/FW'         CLRFW             8                        MD022425
     C                   MOVE      BBFWCD        DNFWCD            9                        MD022425
     C     CLRFW         CAT       DNFWCD        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   ENDIF                                                              MD022425
     C     CSLEIC        IFNE      *BLANKS                                                  MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     '/LEIC/'      CAT       CSLEIC        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   ADD       1             X                                          MD022425
     C     X             OCCUR     MULT                                                     MD022425
     C     '/NAME/'      CAT       BBCNA1        MFLD                                       MD022425
     C                   ENDIF                                                              MD022425
     C                   ELSE                                                               MD022425
     C                   ADD       1             X                                          MD024078
     C     X             OCCUR     MULT                                                     MD024078
     C                   EXSR      FSWAD                                                    MD022425
     C                   ENDIF                                                              MD022425
     C                   ENDSR                                                              MD022425
     C/EJECT                                                                                MD022425
      *****************************************************************
     C/COPY WNCPYSRC,MG0600C036
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   *PSSR - Error handling                                      *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR

      **  Write database error to report

     C                   OPEN      MG000600AU
     C                   WRITE     HEAD
     C                   WRITE     DBERROR

     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
     C/COPY MGCPYSRC,MGSWIFTRAN
** CPY@   Object Copyright
(c) Finastra International Limited 2012
** MSGA   Messages
Settlement - pay
Customer details not found on SDCUSTPD
Nostro customer not found on SDNOSTPD
Broker code not found on SDBROKPD
ZM0040 (format ccy and amount) call ended in error
ZM0050 (format SWIFT address) call ended in error
Codeword was not found for this message
Duplicate TRN (ref.) key built for this message
/UNIT/OTH/
** TABS96 - selection criteria for the codeword
                  BOTHAMEND    K
                  B/O AMEND    U
NONREC NEW      U BOTHNEW      K
NONREC NEW      U B/O NEW      U
NONREC NEW      K BOTHNEW      K
NONREC NEW      K B/O NEW      K
SENT   NEW      U BOTHAMEND    K
SENT   NEW      U B/O AMEND    U
SENT   NEW      K BOTHAMEND    K
SENT   NEW      K B/O AMEND    K
NONREC AMEND    U BOTHAMEND    K
NONREC AMEND    U B/O AMEND    U
NONREC AMEND    K BOTHAMEND    K
NONREC AMEND    K B/O AMEND    K
SENT   AMEND    U BOTHAMEND    K
SENT   AMEND    U B/O AMEND    U
SENT   AMEND    K BOTHAMEND    K
SENT   AMEND    K B/O AMEND    K
** TABNST - Codes indicating settlement via nostro
01
02
07
08
12
** TABINT - Codes indicating settlement via internal
03
04
05
06
14
** VALUNI
FOZ
GOZ
GRM
KLO
LIT
LOT
OTH
PND
TAL
TOL
TON
TOZ
UNT
