     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MG Generation of Answered Message MT995.')
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *  MG000995 - Generation of Answered Messages MT995.            *
      *                                                               *
      *  Called By: GLC001445 - Midas GL MT995 Message Generation.    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL013 *CREATE     Date 17May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL013 - MT94x Message Generation                            *
      *           This program is based on MGU995                     *
      *                                                               *
      *****************************************************************
      *
      **  Midas MG MGn95 Generation Extract File
     FMGFN95PD  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      **  Midas MG MTN95 Supplementary File
     FMGXN95L0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      **  Midas MG Message Reference File.
     FMGOREFPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      **  Midas MG Master Message Data File.
     FMGOMSGPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      **  Midas MG Answer Message Generation Audit Report.
     FMG000995AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
      *
      ********************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  81 - End of File MGFN95PD.                                   *
      *  82 - Access to MGXN95L0 failed.                              *
      *                                                               *
      *  90  -  CALL or DELET ended abnormally.                       *
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
      *       * 61   62   63   64   65   66   67   68   69   70 *     *
      *       * 71   72   73   74   75   76   xx   78   79   80 *     *
      *       * xx   xx   83   84   85   86   87   88   89   xx *     *
      *       * 91   92   93   94   95   96   97   98   99      *     *
      *       ***************************************************     *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *                S U B R O U T I N E   I N D E X                *
      *                -------------------------------                *
      *                                                               *
      *  #INIT   - Initial processing.                                *
      *  #ROUT   - Determine Message Routing.                         *
      *  #FLD20  - Format mandatory field 20.                         *
      *  #FLD21  - Format mandatory field 21.                         *
      *  #FLD75  - Format mandatory field 75.                         *
      *  #FLD77A - Format optional field 77A.                         *
      *  #FL11R  - Format optional field 11a.                         *
      *  #ORMSG  - Format optional field which mandatory fields from  *
      *            the original message.                              *
      *  #OMSG   - Write the data structure to Master Message Data.   *
      *  #OREF   - write a record in Master Message Reference File.   *
      *  #AUDIT  - Subroutine to Output Audit report.                 *
      *  *PSSR   - Program exception error routine.                   *
      *                                                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      **  Array used to store Swift Data.
      *
      **  Array containing narratives
     D NARR            S             35    DIM(20)
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      **  Local data area for database error details.
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      **  *LOCK IN LDA immediately before and OUT LDA immediately
      **  after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines :                    142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      **  Local data area for Run Date Informations.
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      **  File Information Data Structure for MSU942AU.
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      **  Multiple occurrence data structure for message.
     D MULT            DS                  OCCURS(200)
     D  MTAG                   1      5                                         Tag
     D  MFLD                   6     55                                         Message Field Detail
     D  CTRC                  56     57                                         CR/LF field
      *
      **  Constants
     D  WUMODE         S              6
      *
      **  Data structure for Bank Details.
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      **  Data structure for message management data.
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      *
      **  Data Structure for Branch details.
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      **  Data structure for User Details.
     D MUSER         E DS                  EXTNAME(MUSERDD)
     D  USMULT       E                     EXTFLD(MULT)
     D  USLCD        E                     EXTFLD(LCD)
      *
      **  Short data structure for access programs.
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      **  Long data structure for access programs.
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      **  External data structure for Switchable Features Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SCLCD        E                     EXTFLD(LCD)
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                  M A I N  P R O C E S S I N G                 *
      *                                                               *
      *****************************************************************
      *
      **  Initial processing.
      *
     C                   EXSR      #INIT
      *
      **  If feature is switched off.
     C     CGL013        CABEQ     'N'           @END
      *
      **  Read the first record from the MT995 extract file.
      *
     C                   READ      MGFN95PD                               81
      *
      **  Format Message Control.
      *
      **  Do While records found on the MT995 extract file.
      *
     C     *IN81         DOWEQ     *OFF                                         Begin DO_WHILE_81
      *
      **  Clear multiple occurrence data structure
      *
     C     1             DO        200           X                 3 0
     C     X             OCCUR     MULT
     C                   CLEAR                   MULT
     C                   ENDDO
      *
      **  Determine message routing.
     C                   EXSR      #ROUT
      *
      **  Write to MGOREFPD.
      *
     C                   EXSR      #OREF
      *
      **------------------< Format message fields >------------------**
      *
      **  Format mandatory field :20: (Transaction Refernece Number).
      *
     C                   EXSR      #FLD20
      *
      **  Format mandatory field :21: (Related Reference).
      *
     C                   EXSR      #FLD21
      *
      ** Format mandatory field :75: (Queries).
      *
     C                   EXSR      #FLD75
      *
      ** Format optional field :77A: (Narrative)
      *
     C                   EXSR      #FLD77A
      *
      ** Format optional field :11a: (MT and Date of Original Message).
      *
     C                   EXSR      #FL11R
      *
      ** Format optional field which contains a copy of at least
      ** all mandatory fields of the Original Message.
      *
     C                   EXSR      #ORMSG
      *
      **  Write to MGOMSGPD and clear data structure.
      *
     C                   EXSR      #OMSG
      *
      **  Delete the processed record.
      *
     C                   DELETE    MGFN95P0                             90
      *
      **  Error on record deletion.
     C     *IN90         IFEQ      *ON                                          Begin *IN90
     C     *LOCK         IN        LDA
     C                   MOVEL     'MGFN95PD'    DBFILE                         ***************
     C                   MOVEL     MGUREF        DBKEY                          * DB ERROR 01 *
     C                   Z-ADD     01            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF                                                  End *IN90
      *
      **  COMIT all changes since last Message writing without error.
      *
     C                   COMMIT
     C                   ADD       1             RCOUNT
      *
      **  Read next record from the MT995 extract file.
      *
     C                   READ      MGFN95PD                               81
      *
     C                   ENDDO                                                  End DO_W_81
      *
      **  Write MT995 Generation Audit Report.
     C                   EXSR      #AUDIT
      *
      **  Terminate program.
     C     @END          TAG
      *
     C                   SETON                                        LR
      *
     C/EJECT
      *****************************************************************
      *  #INIT   - Initial Processing.                                *
      *                                                               *
      *  Called by : Main processing                                  *
      *                                                               *
      *  Calls     : ZM0060                                           *
      *              *PSSR                                            *
      *****************************************************************
      *
     C     #INIT         BEGSR                                                  ** #INIT SR **
      *
      **  Date Area Declaration.
     C     *DTAARA       DEFINE                  LDA                            Local Data Area
     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBPGM
     C                   MOVEL     PSProcMod     DBMOD
     C                   MOVEL     *BLANKS       DBFILE
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     *BLANKS       DBASE
     C                   OUT       LDA
      *
      **  Run Date Date Area Declaration.
     C     *DTAARA       DEFINE                  RUNDAT
      *
      **  Access RUNDAT for multibranching indicator.
     C                   IN        RUNDAT
      *
      *
      **  Access Switchable Feature Details to check if
      **  feature CGL013 is switched on.
     C                   MOVE      'N'           CGL013            1
     C                   CALL      'AOSARDR0'                           90
     C                   PARM      '*MSG   '     P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      'CGL013'      P@SARD            6            I:Key field
     C     SCSARD        PARM      SCSARD        DSFDY                          O:Format
      *
      **  If program ended Abnormally, handle Database Error.
     C     *IN90         IFEQ      *ON                                          Begin *IN90
     C     P@RTCD        ORNE      *BLANKS
     C     P@RTCD        ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         ***************
     C                   MOVEL     P@SARD        DBKEY                          * DB ERROR 02 *
     C                   Z-ADD     02            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF                                                  End *IN90
      *
      **  If feature is not switched on.
     C     P@RTCD        CABNE     *BLANKS       @ENINI
     C                   MOVE      'Y'           CGL013
      *
      **  Access Bank Details for report title and Single
      **  Branch Code.
     C                   CALL      'AOBANKR0'                           90
     C                   PARM      '*MSG   '     P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  If program ended Abnormally or no record
      **  found, handle Database Error.
     C     *IN90         IFEQ      *ON                                          Begin *IN90
     C     P@RTCD        ORNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         ***************
     C                   MOVEL     '*FIRST '     DBKEY                          * DB ERROR 03 *
     C                   Z-ADD     03            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF                                                  End *IN90
      *
      **  Access SDMGMEPD for message management data.
      *
     C                   CALL      'AOMGMER0'
     C                   PARM      '*DBERR '     P@RTCD                         Return Code
     C                   PARM      '*FIRST '     P@OPTN                         Option
     C     SDMGME        PARM      SDMGME        DSFDY
      *
      **  Initialise constant fields.
      *
     C                   MOVE      *LOVAL        WUCR              1
     C                   BITON     '457'         WUCR
     C                   MOVE      *LOVAL        WULF              1
     C                   BITON     '257'         WULF
     C                   MOVEL     WUCR          WUCRLF            2
     C                   MOVE      WULF          WUCRLF
      *
      **  Set up CRLF Control Character for message data records.
      *
     C                   MOVE      WUCRLF        CTRC
      *
      **  Setup Block 4 delimiters.
      *
      **  Setup delimiter WUTAGB - start of tag within message block.
     C                   MOVEL     WUCRLF        WUTAGB            3
     C                   MOVE      ':'           WUTAGB
      *
      **  Setup delimiter WUBLKE - end of Block 4:
     C                   MOVEL     WUCRLF        WUBLKE            3
     C                   MOVE      '-'           WUBLKE
      *
      **  Convert run date to SWIFT Format (YYMMDD),
      **  to setup Message Generation Date.
     C                   Z-ADD     BJRDNB        P@DAY
     C                   CALL      'ZM0060'                             90
     C                   PARM                    P@DAY             5 0
     C                   PARM                    P@DATE            6
      *
      **  If Program ended in error, handle Database Error.
     C     *IN90         IFEQ      *ON                                          Begin *IN90
     C     *LOCK         IN        LDA
     C                   MOVEL     'ZM0060  '    DBFILE                         ***************
     C                   MOVEL     '*CALL  '     DBKEY                          * DB ERROR 04 *
     C                   Z-ADD     04            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   END                                                    End *IN90
     C                   MOVE      P@DATE        MGDE                           Message Generation D
     C                   MOVE      AGMRDT        LADT                           Last Action Date
      *
      **  Set up Message Generation Century flag.
      *
     C                   MOVEL     MGDE          WUYY              2 0
      *
     C     WUYY          IFLT      72                                           Begin WUYY
     C                   MOVE      '2'           CIND
      *
     C                   ELSE                                                   Else WUYY
     C                   MOVE      '1'           CIND
      *
     C                   ENDIF                                                  End WUYY
     C                   MOVE      'N'           MPRY                           Message Priority
      *
      **  Retrieve History Retention Date.
      *
     C     BJRDNB        ADD       ENDSMN        P@DAY
     C                   CALL      'ZM0060'                             90
     C                   PARM                    P@DAY             5 0
     C     HRDT          PARM                    P@DATE            6
      *
      **  If Program ended in error, handle Database Error.
     C     *IN90         IFEQ      *ON                                          Begin *IN90
     C     *LOCK         IN        LDA
     C                   MOVEL     'ZM0060  '    DBFILE                         ***************
     C                   MOVEL     '*CALL  '     DBKEY                          * DB ERROR 05 *
     C                   Z-ADD     05            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   END                                                    End *IN90
      *
      **  Define work field used to check if Error Report
      **  has been already opened.
     C                   MOVE      'N'           WUOPP1            1
      *
     C     @ENINI        ENDSR
     C/EJECT
      *****************************************************************
      *  #ROUT   - Determine Message Routing.                         *
      *                                                               *
      *  Called by : Main processing                                  *
      *                                                               *
      *  Calls     : MG9900                                           *
      *****************************************************************
     C     #ROUT         BEGSR                                                  ** #ROUT SR **
      *
      ** Retrieve branch detail
      *
     C     *LIKE         DEFINE    MGBRCA        P@BRCD                         Branch Code
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      MGBRCA        P@BRCD                         Branch Code
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      **  If programs ended abnormally, handle Database Error.
     C     P@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE                         ***************
     C                   MOVEL     MGBRCA        DBKEY                          * DB ERROR 06 *
     C                   Z-ADD     06            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     MGNWRK        NWRK                           Network
     C                   MOVEL     A8BICN        SECN                           Cust. No. of Sender
     C                   MOVEL     A8BTID        NWSN                           Sender
     C                   MOVEL     MGDECN        DECN                           Cust. No. of Destina
     C                   MOVEL     MGDSTN        NWDS                           Destination
     C                   MOVE      MGMTPY        MTPY                           Message Type
      *
      **  If MT995 is an answer to a MT920 Message, message is to
      **  be produced with a status of released.
      *
     C     MGRREF        IFNE      *BLANKS                                      Begin MGRREF
     C                   MOVE      'RSND'        MGST
     C                   MOVE      '2'           MGSG
     C                   ELSE                                                   Else MGRREF
     C                   MOVE      'CRTD'        MGST
     C                   MOVE      '1'           MGSG
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  #FLD20  - Subroutine to format mandatory field 20 with       *
      *            Transaction Reference Number.                      *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls     : *none                                            *
      *****************************************************************
      *
     C     #FLD20        BEGSR                                                  ** #FLD20 SR **
      *
     C                   Z-ADD     1             M
     C     M             OCCUR     MULT
      *
     C                   MOVE      ':20: '       MTAG
     C                   MOVE      *BLANKS       MFLD
     C                   MOVEL     MGUREF        MFLD
     C                   MOVE      WUCRLF        CTRC
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  #FLD21  - Subroutine to format mandatory field 21 with       *
      *            Related Reference.                                 *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls     : *none                                            *
      *****************************************************************
      *
     C     #FLD21        BEGSR                                                  ** #FLD21 SR **
      *
     C                   ADD       1             M
     C     M             OCCUR     MULT
      *
     C                   MOVE      ':21: '       MTAG
     C                   MOVEL     MGRREF        MFLD
     C                   MOVE      WUCRLF        CTRC
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  #FLD75  - Subroutine to format mandatory field 75 with       *
      *            Queries.                                           *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls     : *none                                            *
      *****************************************************************
      *
     C     #FLD75        BEGSR                                                  ** #FLD75 SR **
      *
     C                   ADD       1             M
     C     M             OCCUR     MULT
      *
     C                   MOVE      ':75: '       MTAG
     C                   MOVEL     MGQRY1        MFLD
     C                   MOVE      WUCRLF        CTRC
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  #FLD77A - Subroutine to format optional field 77A with       *
      *            Narratives                                         *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls     : *none                                            *
      *****************************************************************
      *
     C     #FLD77A       BEGSR                                                  ** #FLD75 SR **
     C                   MOVE      *BLANKS       NARR
     C                   MOVE      MGNR01        NARR(1)
     C                   MOVE      MGNR02        NARR(2)
     C                   MOVE      MGNR03        NARR(3)
     C                   MOVE      MGNR04        NARR(4)
     C                   MOVE      MGNR05        NARR(5)
     C                   MOVE      MGNR06        NARR(6)
     C                   MOVE      MGNR07        NARR(7)
     C                   MOVE      MGNR08        NARR(8)
     C                   MOVE      MGNR09        NARR(9)
     C                   MOVE      MGNR10        NARR(10)
     C                   MOVE      MGNR11        NARR(11)
     C                   MOVE      MGNR12        NARR(12)
     C                   MOVE      MGNR13        NARR(13)
     C                   MOVE      MGNR14        NARR(14)
     C                   MOVE      MGNR15        NARR(15)
     C                   MOVE      MGNR16        NARR(16)
     C                   MOVE      MGNR17        NARR(17)
     C                   MOVE      MGNR18        NARR(18)
     C                   MOVE      MGNR19        NARR(19)
     C                   MOVE      MGNR20        NARR(20)
      *
     C                   Z-ADD     1             A                 2 0
     C                   Z-ADD     1             B                 2 0
     C     A             DOWLT     21
      *
     C     NARR(A)       IFNE      *BLANKS
     C                   ADD       1             A
     C     M             OCCUR     MULT
      *
     C     B             IFEQ      1
     C                   MOVE      ':77A:'       MTAG
     C                   ADD       1             B
     C                   ELSE
     C                   MOVE      *BLANKS       MTAG
     C                   ENDIF
      *
     C                   MOVEL     NARR(A)       MFLD
     C                   MOVE      WUCRLF        CTRC
     C                   ENDIF
      *
     C                   ADD       1             A
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  #FL11R  - Subroutine to format optional field 11a with       *
      *            MT and Date of Original Message.                   *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls     : *none                                            *
      *****************************************************************
      *
     C     #FL11R        BEGSR                                                  ** #FL11R SR **
      *
     C                   ADD       1             M
     C     M             OCCUR     MULT
      *
     C                   MOVE      ':11R:'       MTAG
     C                   MOVEL     MGTYPE        MFLD
     C                   MOVE      WUCRLF        CTRC
      *
     C                   ADD       1             M
     C     M             OCCUR     MULT
      *
     C                   MOVE      *BLANKS       MTAG
     C                   MOVE      MGDTOM        WUMODE
     C                   MOVEL     WUMODE        MFLD
     C                   MOVE      WUCRLF        CTRC
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  #ORMSG  - Subroutine to format optional field which          *
      *            contains a copy of at least the mandatory fields   *
      *            of the original message being queried to enable    *
      *            the Receiver to positively identify that message   *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls     : *PSSR                                            *
      *****************************************************************
      *
     C     #ORMSG        BEGSR                                                  ** #ORMSG SR **
      *
      **  Read information from MGXN95PD file
     C     MGUREF        SETLL     MGXN95P0
     C     MGUREF        READE     MGXN95P0                               82
      *
      **  Do while Data to extract.
     C     *IN82         DOWEQ     *OFF                                         Begin DO_W_82
     C                   ADD       1             M
     C     M             OCCUR     MULT
      *
     C     MGMTAG        CAT       MGMFLD:0      MFLD
     C                   MOVE      WUCRLF        CTRC
      *
     C     MGCONT        IFEQ      'Y'
     C                   DELETE    MGXN95P0
     C     MGUREF        READE     MGXN95P0                               82
      *
     C     *IN82         IFEQ      *OFF
     C                   MOVE      *BLANKS       CTRC
     C                   ADD       1             M
     C     M             OCCUR     MULT
     C                   MOVEL(P)  MGMFLD        MFLD
     C                   MOVE      WUCRLF        CTRC
     C                   ENDIF
     C                   ENDIF                                                  End *IN77
      *
     C                   DELETE    MGXN95P0
     C     MGUREF        READE     MGXN95P0                               82
     C                   ENDDO                                                  End *IN7
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *  #OMSG   - Write the data structure to Master Message Data    *
      *            File.                                              *
      *                                                               *
      *  Called by : Main processing                                  *
      *                                                               *
      *  Calls     : *PSSR                                            *
      *****************************************************************
      *
     C     #OMSG         BEGSR                                                  ** #OMSG SR **
      *
      **  Write multiple occurrence data structure to MGOMSGPD.
      *
     C                   Z-ADD     1             M                 3 0
     C     M             OCCUR     MULT
      *
     C     M             DOWLE     200                                          Begin DO_W_M
     C     MFLD          ANDNE     *BLANKS
      *
     C                   WRITE     MGOMSGD0                             90
      *
      **  If error while writing into PF/MGOMSGPD,
      **  handle Database Error.
     C     *IN90         IFEQ      '1'                                          Begin *IN90
     C     *LOCK         IN        LDA
     C                   MOVEL     'MGOMSGPD'    DBFILE                         ***************
     C                   MOVEL     MULT          DBKEY                          * DB ERROR 08 *
     C                   Z-ADD     08            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   END                                                    End *IN90
      *
     C                   ADD       1             M
     C     M             OCCUR     MULT
      *
     C                   END                                                    End DO_W_M
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *  #OREF   - write a record in Master Message Reference File.   *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls     : *PSSR                                            *
      *****************************************************************
      *
     C     #OREF         BEGSR                                                  ** #OREF SR **
      *
     C                   MOVE      'GL'          MODI                           Module Id.
     C                   MOVE      MGUREF        TRNO                           Transaction Ref. No.
     C                   TIME                    MGTM                           Msg Generation Time
     C                   TIME                    LATM                           Last Actiuon Time
     C                   MOVE      MGBRCA        BRCA                           Branch Code
      *
      **  Write record in Message Reference File.
     C                   WRITE     MGOREFD0                             90
      *
      **  Handle Error on write to PF/MGOREFPD.
     C     *IN90         IFEQ      *ON                                          Begin *IN90
     C     *LOCK         IN        LDA
     C                   MOVEL     'MGOREFPD'    DBFILE                         ***************
     C                   MOVEL     TRNO          DBKEY                          * DB ERROR 09 *
     C                   Z-ADD     09            DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   END                                                    End *IN90
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #AUDIT  - Subroutine to Output Audit report.                 *
      *                                                               *
      *  Called By : Main processing                                  *
      *              *PSSR                                            *
      *                                                               *
      *  Calls     :                                                  *
      *****************************************************************
      *
     C     #AUDIT        BEGSR                                                  ** #AUDIT SR **
      *
      **  Output Report Header and File Controls.
      *
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      **  If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON                                          Begin *INU7
     C                   WRITE     DBERROR
      *
     C                   ELSE                                                   Else *INU7
      *
      **  Or, if no records read, Output "No Details" message.
      *
     C     RCOUNT        IFEQ      0                                            Begin RCOUNT
     C                   WRITE     NODTLS
      *
     C                   END                                                    End RCOUNT
      *
     C                   END                                                    End *INU7
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
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     WRUN          IFEQ      *BLANK                                       Begin WRUN
     C                   MOVE      'Y'           WRUN              1
      *
      **  If subroutine automatically called.
     C     *LOCK         IN        LDA
     C     DBFILE        IFEQ      *BLANKS                                      Begin DBFILE
     C     'Last Fil'    CAT       'e used':0    DBKEY
     C                   MOVEL     PSLastFile    DBFILE
      *
     C                   END                                                    End DBFILE
     C                   OUT       LDA
      *
     C                   DUMP
     C                   EXSR      #AUDIT
      *
     C                   ENDIF                                                  End WRUN
      *
      **  If *PSSR already run, then just end the program here.
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
