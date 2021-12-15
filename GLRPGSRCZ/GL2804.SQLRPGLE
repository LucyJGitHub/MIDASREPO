     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058079
/*STD *  RPGSQLBND                                                    *                     MD058079
/*EXI *  TEXT('Midas GL Midas-Fontis i/face - daily statement gen')
      *****************************************************************
      *                                                               *
      *  Midas - Midas-Fontis Interface                               *
      *                                                               *
      *  GL2804 - Daily Statement Generation                          *
      *                                                               *
      *  Function:  To maintain the Fontis Accounts file and generate *
      *             MT940 format messages to be passed through the    *
      *             Midas-Fontis Interface                            *
      *                                                               *
      *  Close of Business                                            *
      *                                                               *
      *  Called By: GLC2804 - Fontis Message Generation               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058079           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01.02 ----------------------------------------*
      *                 201583             Date 13Jun02               *
      *                 196077             Date 15Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 181476             Date 13Jul00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW020             Date 11Jan00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 165717             DATE 06JAN97               *
      *                 CGL007             Date 26Mar99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CGL004 *CREATE     DATE 06JAN97               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058079 - Deliverable Data Split for sundry files           *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  201583 - Output field 64 even when it is zero.               *
      *  196077 - Ensure that SWIFT transaction ID has the correct    *
      *           value.                                              *
      *  181476 - Value date and posting date are in wrong order for  *
      *            field :61:.                                        *
      *  CSW020 - SWIFT Decimal Places                                *
      *           Add a new parameter for program ZM0040              *
      *  165717 - Field :25: should contain the Midas Retail Number if*
      *           retail account numbers are supported by the system. *
      *  CGL007 - Account Postings Enquiry (Recompile)                *
      *  CGL004 - Midas-Fontis Interface                              *
      *                                                               *
      *****************************************************************
     FRCPOSTL0  IF   E           K DISK
     FGLACBTL0  IF   E           K DISK
     FACCNT     IF   E           K DISK
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
     F*GLFNARL0* IF   E           K DISK                                                    MD058079
     F/COPY WNCPYSRC,GL2804F001
     FGLFONAL0  UF   E           K DISK
     FGLFREFL0  UF A E           K DISK
     FGLFDTAPD  O    E             DISK
     F/COPY WNCPYSRC,GL2804F002
     FGL2804AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
      /EJECT
      *****************************************************************
      *                                                               *
      *   Indicator Usage                                             *
      *   ---------------                                             *
      *                                                               *
      *   21        Member not found on message ref. file GLFREFL0    *
      *   22        No Record Found/Last record on GLFONAL0           *
      *   23        Account not found on account master file ACCNT    *
      *   24        Acc not found on today's acc bal. file GLACBTL0   *
      *   25        Acc not found on today's posting file APOSTPDF    *
      *   26        No Rec Found/Last rec on Narrative file GLFNARL0  *
      *   30        Balances don't match - error on write of mesg.    *
      *   31        Error on write of detail line                     *
      *   40        End of year                                       *
      *                                                               *
      *   U7 & U8   Database error                                    *
      *   nn        X                                                 *
      *                                                               *
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D LDA           E DS           256    EXTNAME(LDA)
      ** LDA for database error reporting
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
      *
     D GLFONT        E DS           256    EXTNAME(GLFONTDA)
      ** FONTIS Data Area
      *
     D PSDS           SDS
     D  @JOB                 244    253
     D  @USER                254    263
     D  @NUM                 264    269
      ** Program Status Data Structure - gives Job name, user and
      ** number
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for bank details table
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Data structure for currency details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** SAR file details
      *
     D/COPY WNCPYSRC,GL2804I002
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    165717
      * Data Structure for Midas Module Details Access Program            165717
     D*                                                                   165717
     D SDRETL        E DS                  EXTNAME(SDRETLPD)                    165717
      * Data Structure for Retail Data Access Program                     165717
      *                                                                   165717
     D GLFNAR        E DS                  EXTNAME(GLFNAJW0)                                MD058079
     D MNM             DS
     D  W@MNM                  1     10
     D  W@MDAT                 2      7
      ** Member name - date
      *
     D SPOOLU          DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
      ** File Information Data Structure for GL2804AU
      *
     D @20             DS
     D  @PFX                   1      2
     D  @DAT                   3      8
     D  @TIM                   9     12  0
     D  @SEQ                  13     15  0
      ** Transaction Reference Number data structure
      *
     D                 DS
     D**********                              1  18 F1FULA                                    CGL029
     D  F1FULA                 1     24
     D  F1BRCD                 1      3
     D**********                              4   90F1CNUM                                    CSD027
     D  F1CNUM                 4      9
     D  F1CCY                 10     12
     D**********                             13  160F1ACOD                                    CGL029
     D**********                             17  180F1ACSQ                                    CGL029
     D  F1ACOD                13     22  0
     D  F1ACSQ                23     24  0
      ** Full Account Data Structure
      *
     D                 DS
     D  @DATA                  1    256
     D  @TAG4                  1      4
     D  @TAG5                  1      5
     D/COPY WNCPYSRC,GL2804I004
     D  @DAT4                  5    256
     D  @DAT5                  6    256
      ** Message data
      *
     D                 DS
     D  SPOS                   1      7
     D  @SPID                  6      7
      ** Source of posting
      *
     D                 DS
     D  @28                    1      9
     D  @28S1                  1      5  0
     D  @28SL                  6      6    INZ('/')
     D  @28S2                  7      8
     D  @28S3                  7      9
      ** Field :28:
      *
     D                 DS
     D  @60F                   1     25
     D  @60FS1                 1      1
     D  @60FS2                 2      7
     D  @60FS3                 8     10
     D  @60FS4                11     25
      ** Field :60F:
      *
     D                 DS
     D**********                              1  64 @61                                       CGL029
     D  @61                    1     70
     D  @61S1                  1      6
     D  @61S2                  7     10
     D  @61S3                 11     11
      ** SWIFT Currency field (@61S4) not required
     D  @61S5                 12     26
     D  @61S6                 27     30
     D  @61S6A                27     27
     D  @61S6B                28     30
     D  @61S7                 31     46
     D  @61S8                 47     64
     D  @61S8A                47     48
     D  @61S8B                49     50
     D  @61S8C                51     64
     D  @61S8F                49     64
     D  @61SF1                49     49
     D**********                             50  64 @61SF2                                    CGL029
     D  @61SF2                50     70
      ** Field :61: subfields 1 to 8
      *
     D                 DS
     D  @62F                   1     25
     D  @62FS1                 1      1
     D  @62FS2                 2      7
     D  @62FS3                 8     10
     D  @62FS4                11     25
      ** Field :62F:
      *
     D                 DS
     D  @64                    1     25
     D  @64S1                  1      1
     D  @64S2                  2      7
     D  @64S3                  8     10
     D  @64S4                 11     25
      ** Field :64:
      *
     D                 DS
     D  @GLREF                 1     13
     D  @BRCA                  1      3
     D  @DPMT                  4      6
     D  @SPOS                  7     13
      ** GL posting reference for field :61: subfield 8
      *
     D                 DS
     D  @F4DAT                 1    256
     D  @F4S1                  1      6    INZ('{1:F01')
     D  @F4S2                  7     18
     D  @F4S3                 19     36    INZ('0000000000}{2:I940')
     D  @F4S4                 37     48    INZ('            ')
     D  @F4S5                 49    128    INZ('U3003}{4:')
      ** Array containing Copyright statement
     I/COPY WNCPYSRC,GL2804E001
      *
      /SPACE 3
     IGLACBLF
     I              LDBL                        LDBLO
     I              CLBL                        CLBLO
      ** Rename opening account balances
      *
     I/COPY WNCPYSRC,GL2804I001
      ** Swift Header
     I/COPY WNCPYSRC,GL2804I003
      *
      /EJECT
      *
      *****************************************************************
      *                                                               *
      *   Index to subroutines                                        *
      *   --------------------                                        *
      *                                                               *
      *   INIT      Initial process                                   *
      *   MAIN      Main detail process                               *
      *   CREATE    Create ISO MT940                                  *
      *   FLD20     Create field :20: (Transaction Reference Number)  *
      *   FLD25     Create field :25: (Account i/d)                   *
      *   FLD28     Create field :28:(Statement number/sequence)      *
      *   FLD60F    Create field :60F: (Opening Balance)              *
      *   FLD61     Create all field :61:s (Postings)                 *
      *   SF6       Format field :61:, subfield 6                     *
      *   SF7       Format field :61:, subfield 7                     *
      *   SF8       Format field :61:, subfield 8                     *
      *   SF9       Format field :61:, subfield 9                     *
      *   FLD62F    Create field :62F: (Closing Balance)              *
      *   FLD64     Create field :64: (Closing Available Balance)     *
      *   CLSDWN    Closing Processing                                *
      *   AUDIT     Audit Trail Report                                *
      *   *PSSR     Process errors                                    *
      *                                                               *
      *****************************************************************
      *
      /EJECT
      *
      *================================================================
      *  P R O G R A M    S T A R T                                   *
      *================================================================
      *
      ** Receive Parameter List
     C     *ENTRY        PLIST
     C                   PARM                    MNM              10
      *
      ** Execute initial process
     C                   EXSR      INIT
      *
      ** Execute main detail process
     C                   EXSR      MAIN
      *
      ** Execute closing process
     C                   EXSR      CLSDWN
      *
      ** Terminate RPG program with member name being passed back
      ** to calling program
     C                   SETON                                        LR
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  INIT                                           *
      * Function    :  Perform initial processing                     *
      *                                                               *
      * Called by   :  Main process                                   *
      * Calls       :  AOBANKR0                                       *
      *             :  AOSARDR0                                       *
      *****************************************************************
      *
     C     INIT          BEGSR
      *
      ** Initialise object copyright statement
     C                   MOVEA     CPY@          MKI@             80
      *
      ** Initialise LDA
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBASE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVEL     'GL2804'      DBPGM
     C                   OUT       LDA
      *
      ** Initialise record counters
     C                   Z-ADD     0             W@RED
     C                   Z-ADD     0             W@UPD
     C                   Z-ADD     0             W@DEL
     C                   Z-ADD     0             W@WRI
      *
      ** Initialise work field for value date
     C                   MOVE      *BLANKS       W@61S2            6
      *
      ** Set up key list for full account id.
     C     K#ACID        KLIST
     C                   KFLD                    F1CNUM
     C                   KFLD                    F1CCY
     C                   KFLD                    F1ACOD
     C                   KFLD                    F1ACSQ
     C                   KFLD                    F1BRCD
      *
      ** Set up key list to access narrative table
     C     K#FNAR        KLIST
     C                   KFLD                    L#TTYP            2
     C                   KFLD                    L#FTTR            1
      *
      ** Open Audit printer file PRTF/GL2804AU
     C                   OPEN      GL2804AU
      *
      ** Access SDBANKPD for bank ICD
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C                   PARM                    SDBANK
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '001'         DBASE                          * * * * * * * *
     C                   MOVEL     'FIRST'       DBKEY                          *  DBERR 001  *
     C                   MOVEL     'SDBANKPD'    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Dataarea GLFONTA
      *
     C     *DTAARA       DEFINE    GLFONTDA      GLFONT
     C                   IN        GLFONT
      *
      ** Determine if this is the last run of the year
     C                   MOVE      *BLANKS       W@DNWD            6
     C                   CALL      'ZM0060'
     C                   PARM      BJDNWD        ZMDAY             5 0
     C     W@DNWD        PARM                    ZMDATE            6
      *
     C                   MOVEL     W@DNWD        W@DAT2            2
     C                   MOVE      BJMRDT        W@DAT3            2
     C     W@DAT2        IFNE      W@DAT3
     C                   MOVE      *ON           *IN40
     C                   ENDIF
      *
      ** Determine the member name
     C                   MOVEL     'S'           W@MNM
     C                   Z-ADD     BJRDNB        W@DAT4            5 0
     C                   CALL      'ZM0060'
     C                   PARM      W@DAT4        ZMDAY             5 0
     C     W@MDAT        PARM                    ZMDATE            6
     C/COPY WNCPYSRC,GL2804C003
      *
      ** Check whether switchable feature CGL005, to use field 28c
      ** instead of 28 is switched on.
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL005'      @SAR              6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CGL005            1
     C                   ENDIF
     C/COPY WNCPYSRC,GL2804C001
      *
      ** Check whether Retail installed and Retail A/C Numbers supported  165717
      *                                                                   165717
     C                   CALL      'AOMMODR0'                                                  16571
     C                   PARM      '*MSG    '    @RTCD             7                           16571
     C                   PARM      '*FIRST  '    @OPTN             7                           16571
     C                   PARM                    SDMMOD                                        16571
      *                                                                   165717
     C     @RTCD         IFNE      *BLANKS                                                     16571
     C     *LOCK         IN        LDA                                                         16571
     C                   MOVE      '007'         DBASE                          * * * * * * * *16571
     C                   MOVEL     'FIRST'       DBKEY                          *  DBERR 007  *16571
     C                   MOVEL     'SDMMODPD'    DBFILE                         * * * * * * * *16571
     C                   OUT       LDA                                                         16571
     C                   EXSR      *PSSR                                                       16571
     C                   ENDIF                                                                 16571
      *                                                                   165717
     C     BGRTBN        IFEQ      'Y'                                                         16571
     C     BGNXST        OREQ      'Y'                                                         16571
     C                   CALL      'AORETLR0'                                                  16571
     C                   PARM      '*MSG   '     @RTCD             7                           16571
     C                   PARM      '*FIRST '     @OPTN             7                           16571
     C                   PARM                    SDRETL                                        16571
      *                                                                   165717
     C     @RTCD         IFNE      *BLANKS                                                     16571
     C     *LOCK         IN        LDA                                                         16571
     C                   MOVE      '008'         DBASE                          * * * * * * * *16571
     C                   MOVEL     'FIRST'       DBKEY                          *  DBERR 008  *16571
     C                   MOVEL     'SDRETLPD'    DBFILE                         * * * * * * * *16571
     C                   OUT       LDA                                                         16571
     C                   EXSR      *PSSR                                                       16571
     C                   ENDIF                                                                 16571
     C                   ENDIF                                                                 16571
      *
      ** Check whether switchable feature CSW020, SWIFT decimal           CSW020
      ** places is switched on.                                           CSW020
     C                   CALL      'AOSARDR0'                                                  CSW02
     C                   PARM      *BLANKS       @RTCD                                         CSW02
     C                   PARM      '*VERIFY'     @OPTN                                         CSW02
     C                   PARM      'CSW020'      @SAR              6                           CSW02
      *                                                                   CSW020
     C     @RTCD         IFEQ      *BLANK                                                      CSW02
     C                   MOVE      'Y'           CSW020            1                           CSW02
     C                   MOVE      'N'           WSWDPC            1                           CSW02
     C                   ELSE                                                                  CSW02
     C                   MOVE      ' '           WSWDPC                                        CSW02
     C                   ENDIF                                                                 CSW02
      *                                                                   CSW020
     C                   ENDSR                                                  INIT
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  MAIN                                           *
      * Function    :  Perform main detail processing                 *
      *                                                               *
      * Called by   :  Main process                                   *
      * Calls       :  CREATE                                         *
      *****************************************************************
      *
     C     MAIN          BEGSR
      *
     C                   READ      GLFONAL0                               22
      *
      ** Write title header
     C                   WRITE     GL2804A1
      *
     C     *IN22         DOWEQ     '0'                                          B01
      *
     C                   MOVE      F1FULA        W@ACC
     C                   ADD       1             W@RED
      *
     C     K#ACID        CHAIN     ACCNT                              23
      *
      ** If record not found DELETE fontis records
     C     *IN23         IFEQ      '1'                                          B02
     C                   DELETE    GLFONAD0
     C                   ADD       1             W@DEL
     C                   ELSE                                                   X02
      *
      ** Live account details are found
     C     RECI          IFEQ      'D'                                          B03
     C     F1FONA        ANDEQ     'Y'
     C     F1ATVD        ANDLE     BJDNWD
     C     F1DATV        ANDEQ     *ZEROS
     C     RECI          OREQ      'D'
     C     F1FONA        ANDEQ     'Y'
     C     F1ATVD        ANDLE     BJDNWD
     C     F1DATV        ANDGE     BJDNWD
      *
      ** Set up & initialise running account balance field
     C                   MOVE      *BLANKS       W@RABF           15 0
      *
      ** Generate MT940 message
     C                   EXSR      CREATE
      *
     C                   Z-ADD     BJDNWD        F1WD42
     C     *IN40         IFEQ      '1'                                          B04
     C                   Z-ADD     0             F1FNSQ
     C                   ELSE                                                   X04
     C                   ADD       1             F1FNSQ
     C                   ENDIF                                                  E04
     C                   UPDATE    GLFONAD0
     C                   ADD       1             W@UPD
     C                   ENDIF                                                  E03
     C                   ENDIF                                                  E02
     C                   READ      GLFONAL0                               22
     C                   ENDDO                                                  E01
      *
     C                   ENDSR                                                  MAIN
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  CREATE                                         *
      * Function    :  Create ISO MT940 message for transmission      *
      *                to FONTIS                                      *
      *                                                               *
      * Called by   :  MAIN                                           *
      * Calls       :  FLD20      Create field :20:                   *
      *                FLD25      Create field :25:                   *
      *                FLD28      Create field :28:                   *
      *                FLD60F     Create field :60F:                  *
      *                FLD61      Create all field :61:s              *
      *                FLD62F     Create field :62F:                  *
      *                FLD64      Create field :64:                   *
      *****************************************************************
      *
     C     CREATE        BEGSR
      *
      ** Access start of day opening balance
     C     K#ACID        CHAIN     GLACBTL0                           24
     C     *IN24         IFEQ      '1'                                          B01
      *
      ** Set opening balance to zero if not found
     C                   Z-ADD     0             CLBLO
     C                   Z-ADD     0             LDBLO
     C                   ENDIF                                                  E01
      *
      ** Set up running account balance.
     C                   Z-ADD     LDBLO         W@RABF
      *
      ** Write Swift Header to PF/GLFDTAPD
     C                   MOVE      F6FNBC        @F4S2
     C                   MOVEL     @F4DAT        F4DATA
     C                   WRITE     GLFDTAD0
      *
      ** Create field :20: (Transaction Reference Number)
     C                   EXSR      FLD20
      *
      ** Create field :25: (Account i/d)
     C                   EXSR      FLD25
      *
      ** Create field :28:(Statement number/sequence)
     C                   EXSR      FLD28
      *
      ** Create field :60F: (Opening Balance)
     C                   EXSR      FLD60F
      *
      ** Access first posting for this account
     C     K#ACID        CHAIN     APOSTPDF                           25
      *
      ** Compare account id read from RCPOSTL0 with that currently
      ** being processed on GLFONAL0
      *
     C     *IN25         DOWEQ     '0'                                          B01
     C     F1CNUM        ANDEQ     CNUM
     C     F1CCY         ANDEQ     CCY
     C     F1ACOD        ANDEQ     ACOD
     C     F1ACSQ        ANDEQ     ACSQ
     C     F1BRCD        ANDEQ     BRCA
      *
      ** Create all field :61:s (Postings)
     C                   EXSR      FLD61
      *
      ** Create field :86: (Narrative)
     C/COPY WNCPYSRC,GL2804C008
     C                   EXSR      FLD86
     C/COPY WNCPYSRC,GL2804C004
      *
      ** Maintain Running Account Balance
     C     @61S3         IFEQ      'D'                                          B02
     C                   ADD       PSTA          W@RABF
     C                   ELSE                                                   X02
     C                   SUB       PSTA          W@RABF
     C                   ENDIF                                                  E02
      *
      ** Read next record
     C                   READ      APOSTPDF                               25
     C                   ENDDO                                                  E01
      *
      ** Create field :62F: (Closing Balance)
     C                   EXSR      FLD62F
      *
      ***If*Cleared*balance*is*not*zero,*create*field*:64:************                        201583
      ** Create field :64:                                                                    201583
      ** (Closing Available Balance)
     C********** CLBL      IFNE 0                          B01                                201583
     C                   EXSR      FLD64
     C**********           ENDIF                           E01                                201583
      *
      **     <<< FOR FUTURE DEVELOPMENT >>>
      ** Tag :65: (Forward Available Balance)
      ** This is an appropiate position to add coding for this tag
     C/COPY WNCPYSRC,GL2804C005
      *
      ** Write Swift Trailer to PF/GLFDTAPD
     C                   CLEAR                   @DATA
     C                   MOVEL     '-}'          @DATA
     C                   MOVE      @DATA         F4DATA
     C                   WRITE     GLFDTAD0
      *
     C                   ENDSR                                                  CREATE
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD20                                          *
      * Function    :  Create field :20: (Transaction Reference       *
      *                Number)                                        *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     FLD20         BEGSR
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':20:'        @TAG4
     C                   MOVEL     'MF'          @PFX
     C                   MOVEL     W@MDAT        @DAT
      *
      ** Initialise Transaction Reference time subfield
     C                   TIME                    W#NEWT            6 0
     C     W#NEWT        IFEQ      W#OLDT                                       B01
     C                   ADD       1             @SEQ
     C                   ELSE                                                   X01
     C                   Z-ADD     1             @SEQ
     C                   Z-ADD     W#NEWT        W#OLDT            6 0
     C     W#OLDT        DIV       100           @TIM
     C                   ENDIF                                                  E01
      *
     C                   MOVEL     @20           @DAT4
     C                   MOVEL     @DATA         F4DATA
      *
      ** Write record to file
     C                   WRITE     GLFDTAD0
      *
      ** Keep a count of the number of records written to GLFDTAPD
     C                   ADD       1             W@WRI
      *
     C                   ENDSR                                                  FLD20
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD25                                          *
      * Function    :  Create field :25: (Account i/d)                *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     FLD25         BEGSR
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':25:'        @TAG4
     C     ATYP          IFEQ      'R'                                                         16571
     C     BMRANR        ANDEQ     'Y'                                                         16571
     C     ACNO          ANDNE     *ZEROS                                                      16571
     C                   MOVEL     ACNO          @DAT4                                         16571
     C                   ELSE                                                                  16571
     C                   MOVEL     F1FULA        @DAT4
     C                   END                                                                   16571
     C/COPY WNCPYSRC,GL2804C010
     C                   MOVEL     @DATA         F4DATA
      *
      ** Write record to file
     C                   WRITE     GLFDTAD0
      *
     C                   ENDSR                                                  FLD25
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD28                                          *
      * Function    :  Create field :28:(Statement number/Sequence)   *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     FLD28         BEGSR
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
      *
      ** If CGL005 switched off, output field 28.
     C     CGL005        IFNE      'Y'
     C                   MOVEL     ':28:'        @TAG4
     C     F1FNSQ        ADD       1             @28S1
     C                   MOVEL     '1 '          @28S2
     C                   MOVEL     @28           @DAT4
     C                   MOVEL     @DATA         F4DATA
      *
      ** If CGL005 switched on, output field 28C.
     C                   ELSE
     C                   MOVEL     ':28C:'       @TAG5
     C     F1FNSQ        ADD       1             @28S1
     C                   MOVEL     '1 '          @28S3
     C                   MOVEL     @28           @DAT5
     C                   MOVEL     @DATA         F4DATA
     C                   ENDIF
      *
      ** Write record to file
     C                   WRITE     GLFDTAD0
      *
     C                   ENDSR                                                  FLD28
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD60F                                         *
      * Function    :  Create field :60F: (Opening balance)           *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0060     Return date in ISO format           *
      *                ZM0040     Return ccy/amount in ISO format     *
      *****************************************************************
      *
     C     FLD60F        BEGSR
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':60F:'       @TAG5
      *
      ** Set up subfield 1 (Debit/Credit indicator) nb. zero = debit
     C     LDBLO         IFGT      0                                            B01
     C                   MOVE      'D'           @60FS1
     C                   Z-ADD     LDBLO         @WKAMT
     C                   ELSE                                                   X01
     C                   MOVE      'C'           @60FS1
     C                   Z-SUB     LDBLO         @WKAMT           13 0
     C                   ENDIF                                                  E01
      *
      ** Set up subfield 2 (date) and store for later use
     C                   CALL      'ZM0060'
     C                   PARM      BJRDNB        ZMDAY             5 0
     C     @60FS2        PARM                    ZMDATE            6
     C                   MOVE      ZMDATE        @RUND             6
      *
      ** Set up subfields 3 and 4 (Currency and Amount) nb. use
      ** currency code returned by ZM0040 in s/f 3 because this should
      ** be ISO standard value
     C                   CALL      'ZM0040'
     C                   PARM      @WKAMT        ZAMNT            13 0
     C                   PARM      F1CCY         ZCCY              3
     C     @60FS4        PARM                    ZSAMNT           15
     C     @60FS3        PARM                    ZSCCY             3
     C                   PARM      *BLANKS       ZERR              1
     C                   PARM      WSWDPC        ZSWDPC            1                           CSW02
      *
      ** If program fails, report database error
     C     ZERR          IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '002'         DBASE                          * * * * * * * *
     C                   MOVEL     'PROGRAM'     DBKEY                          *  DBERR 002  *
     C                   MOVEL     'ZM0040  '    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Move data to output record
     C                   MOVEL     @60F          @DAT5
     C                   MOVE      @DATA         F4DATA
      *
      ** Write record to file
     C                   WRITE     GLFDTAD0
      *
     C                   ENDSR                                                  FLD60F
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD61                                          *
      * Function    :  Create all field :61:s (postings)              *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0060     Return date in ISO format           *
      *                ZM0040     Return ccy/amount in ISO format     *
      *                SF6        Create subfield 6                   *
      *                SF7        Create subfield 7                   *
      *                SF8        Create subfield 8                   *
      *                SF9        Create subfield 9                   *
      *****************************************************************
      *
     C     FLD61         BEGSR
      *
      ** Format all field :61:s
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   CLEAR                   @61
     C                   MOVEL     ':61:'        @TAG4
      *
      ***Set*up*subfield*1*(posting*date,*YYMMDD)                                             181476
     C***********PSTD      IFNE 0                          B01                                181476
     C***********          CALL 'ZM0060'                                                      181476
     C***********          PARM PSTD      ZMDAY   50                                          181476
     C***********@61S1     PARM           ZMDATE  6                                           181476
     C***********          ENDIF                           E01                                181476
      ** Set up subfield 1 (value date, YYMMDD)                                               181476
     C                   CALL      'ZM0060'
     C                   PARM      VALD          ZMDAY             5 0
     C     @61S1         PARM                    ZMDATE            6
      *
      ***Set*up*subfield*2*(value*date,*MMDD)                                                 181476
     C***********          CALL 'ZM0060'                                                      181476
     C***********          PARM VALD      ZMDAY   50                                          181476
     C***********W@61S2    PARM           ZMDATE  6                                           181476
     C***********          MOVE W@61S2    @61S2                                               181476
      ** Set up subfield 2 (posting date, MMDD)                                               181476
     C     PSTD          IFNE      0                                            B01
     C                   CALL      'ZM0060'
     C                   PARM      PSTD          ZMDAY             5 0
     C     W@61S2        PARM                    ZMDATE            6
     C                   MOVE      W@61S2        @61S2
     C                   ENDIF
      *
      ** Set up subfield 3 (debit/credit indicator)
     C     DRCR          IFEQ      0                                            B01
     C                   MOVE      'D'           @61S3
     C                   ELSE                                                   X01
     C                   MOVE      'C'           @61S3
     C                   ENDIF                                                  E01
      *
      ** Set up subfield 5 (posting amount)
     C                   Z-ADD     PSTA          @WKAMT
     C                   CALL      'ZM0040'
     C                   PARM      @WKAMT        ZAMNT            13 0
     C                   PARM      F1CCY         ZCCY              3
     C     @61S5         PARM                    ZSAMNT           15
     C                   PARM                    ZSCCY             3
     C                   PARM      *BLANKS       ZERR              1
     C                   PARM      WSWDPC        ZSWDPC                                        CSW02
      *
      ** If program fails, report database error
     C     ZERR          IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '003'         DBASE                          * * * * * * * *
     C                   MOVEL     'PROGRAM'     DBKEY                          *  DBERR 003  *
     C                   MOVEL     'ZM0040  '    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Format subfield 6
     C                   EXSR      SF6
      *
      ** Format subfield 7
     C                   EXSR      SF7
      *
      ** Format subfield 8
     C                   EXSR      SF8
      *
      ** When all subfields for this line formatted, compress and
      ** output to file.
     C     @DAT4         CAT       @61S1:0       @DAT4
     C     @DAT4         CAT       @61S2:0       @DAT4
     C     @DAT4         CAT       @61S3:0       @DAT4
     C     @DAT4         CAT       @61S5:0       @DAT4
     C     @DAT4         CAT       @61S6:0       @DAT4
     C     @DAT4         CAT       @61S7:0       @DAT4
     C     @DAT4         CAT       @61S8:0       @DAT4
      *
      ** Move data to output record
     C                   MOVE      @DATA         F4DATA
      *
      ** Write record to file
     C                   WRITE     GLFDTAD0
      *
      ** Format subfield 9
     C                   EXSR      SF9
      *
     C                   ENDSR                                                  FLD61
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  SF6                                            *
      * Function    :  Create subfield 6 for field :61:               *
      *                                                               *
      * Called by   :  FLD61                                          *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SF6           BEGSR
      *
      ** First character of subfield 6 should always be 'F'
     C                   MOVE      'F'           @61S6A
      *
      ** Fill K-list fields to chain for Transaction Type ID
     C********** SWCR      IFNE *BLANKS                    B01                                196077
     C     PREF          IFNE      *BLANKS
     C                   MOVE      'Y'           L#FTTR
     C                   ELSE                                                   X01
     C                   MOVE      'N'           L#FTTR
     C                   ENDIF                                                  E01
      *
     C                   MOVEL     OTTP          L#TTYP
      *
     C*****K#FNAR        CHAIN     GLFNARD0                           26                    MD058079
     C/EXEC SQL                                                                             MD058079
     C+ SELECT *                                                                            MD058079
     C+ into :GLFNAR                                                                        MD058079
     C+ from GLFNAJW0                                                                       MD058079
     C+ where F2PMTT = :L#TTYP and F2FTTR = :L#FTTR                                         MD058079
     C/END-EXEC                                                                             MD058079
     C******IN26         IFEQ      '0'                                          B01         MD058079
     C     SQLCODE       IFEQ      0                                            B01         MD058079
     C                   MOVE      F2STTI        @61S6B
     C                   ELSE                                                   X01
      *
      ** If unable to set up code, default to 'MSC' - miscellaneous
     C                   MOVE      'MSC'         @61S6B
     C                   ENDIF                                                  E01
      *
     C                   ENDSR                                                  SF6
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  SF7                                            *
      * Function    :  Create subfield 7 for field :61:               *
      *                                                               *
      * Called by   :  FLD61                                          *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SF7           BEGSR
      *
      ** Use SWIFT common reference if available
     C     SWCR          IFNE      *BLANKS                                      B01
     C                   MOVEL     SWCR          @61S7
      *
      ** else - use 16 characters of Posting Narrative
     C                   ELSE                                                   X01
     C                   MOVEL     PNAR          @61S7
     C                   ENDIF                                                  E01
      *
     C                   ENDSR                                                  SF7
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  SF8                                            *
      * Function    :  Create subfield 8 for field :61:               *
      *                                                               *
      * Called by   :  FLD61                                          *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SF8           BEGSR
      *
      ** If Funds Transfer, use Payment Reference
     C     PREF          IFNE      *BLANKS                                      B01
     C                   MOVEL     PREF          @61S8F
      *
      ** else if Other transaction, use Transaction module code
     C                   ELSE                                                   X01
     C     OTRF          IFNE      *BLANKS                                      B02
     C                   MOVEL     F2TRMD        @61SF1
     C     F2TRMD        IFNE      ' '                                          B03
     C                   MOVE      OTRF          @61SF2
     C                   ENDIF                                                  E03
      *
      ** else just use source of posting
     C                   ELSE                                                   X02
      ** Use branch, department, source of posting
     C                   MOVE      'GL'          @61S8B
     C                   MOVEL     BRCA          @BRCA
     C                   MOVEL     DPMT          @DPMT
     C                   MOVEL     SPOS          @SPOS
     C                   MOVEL     @GLREF        @61S8C
      *
     C                   ENDIF                                                  E02
     C                   ENDIF                                                  E01
      *
     C     @61S8         IFNE      *BLANKS                                      B01
      *
      ** Subfield 8 should always begin with '//'
     C                   MOVE      '//'          @61S8A
     C                   ENDIF                                                  E01
      *
     C                   ENDSR                                                  SF8
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  SF9                                            *
      * Function    :  Create subfield 9 for field :61:               *
      *                                                               *
      * Called by   :  FLD61                                          *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SF9           BEGSR
      *
      ** Clear tag & data fields for writing of subfield 9
     C                   CLEAR                   @DATA
      *
      ** Retrieve SwiftNarrative from narrative table else Source of Posting
     C******IN26         IFEQ      '0'                                          B01         MD058079
     C     SQLCODE       IFEQ      0                                            B01         MD058079
     C                   MOVEL     F2NATV        @DATA
     C                   ELSE                                                   X01
     C                   MOVEL     SPOS          @DATA
     C                   END                                                    E01
     C/COPY WNCPYSRC,GL2804C002
      *
      ** If data in subfield 9, write to file
     C     @DATA         IFNE      *BLANKS                                      B01
     C                   MOVE      @DATA         F4DATA
     C                   WRITE     GLFDTAD0
     C                   ENDIF                                                  E01
      *
     C                   ENDSR                                                  SF9
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD86                                          *
      * Function    :  Create field :86: (narrative)                  *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :                                                 *
      *****************************************************************
      *
     C     FLD86         BEGSR
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':86:'        @TAG4
      *
      ** Set up posting narrative
     C                   MOVEL     PNAR          @DAT4
     C/COPY WNCPYSRC,GL2804C009
     C                   MOVEL     @DATA         F4DATA
     C                   WRITE     GLFDTAD0
      *
     C                   ENDSR
     C/COPY WNCPYSRC,GL2804C006
      *
      *****************************************************************
      * Subroutine  :  FLD62F                                         *
      * Function    :  Create field :62F: (closing balance)           *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0040     Return ccy/amount in ISO format     *
      *****************************************************************
      *
     C     FLD62F        BEGSR
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':62F:'       @TAG5
      *
      ** Set up subfield 1 (Debit/Credit indicator) nb. zero = credit
     C     LDBL          IFLE      0                                            B01
     C                   MOVE      'C'           @62FS1
     C                   Z-SUB     LDBL          @WKAMT
     C                   ELSE                                                   X01
     C                   MOVE      'D'           @62FS1
     C                   Z-ADD     LDBL          @WKAMT
     C                   ENDIF                                                  E01
      *
      ** If balances don't match write out error message
     C     LDBL          IFNE      W@RABF                                       B01
     C                   WRITE     GL2804A3                             30
     C                   ENDIF                                                  E01
      *
      ** Set up subfield 2 (date)
     C                   MOVE      @RUND         @62FS2
      *
      ** Set up subfields 3 and 4 (Currency and Amount) nb. use
      ** currency code returned by ZM0040 in s/f 3 because this should
      ** be ISO standard value
     C                   CALL      'ZM0040'
     C                   PARM      @WKAMT        ZAMNT            13 0
     C                   PARM      F1CCY         ZCCY              3
     C     @62FS4        PARM                    ZSAMNT           15
     C     @62FS3        PARM                    ZSCCY             3
     C                   PARM      *BLANKS       ZERR              1
     C                   PARM      WSWDPC        ZSWDPC                                        CSW02
      *
      ** If program fails, report database error
     C     ZERR          IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '004'         DBASE                          * * * * * * * *
     C                   MOVEL     'PROGRAM'     DBKEY                          *  DBERR 004  *
     C                   MOVEL     'ZM0040  '    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Move data to output record
     C                   MOVEL     @62F          @DAT5
     C                   MOVE      @DATA         F4DATA
      *
      ** Write record to file
     C                   WRITE     GLFDTAD0
      *
     C                   ENDSR                                                  FLD62F
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD64                                          *
      * Function    :  Create field :64: (closing available balance)  *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0040     Return ccy/amount in ISO format     *
      *****************************************************************
      *
     C     FLD64         BEGSR
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':64:'        @TAG4
      *
      ** Set up subfield 1 (Debit/Credit indicator) nb. zero = credit
     C     CLBL          IFLE      0                                            B01
     C                   MOVE      'C'           @64S1
     C                   Z-SUB     CLBL          @WKAMT
     C                   ELSE                                                   X01
     C                   MOVE      'D'           @64S1
     C                   Z-ADD     CLBL          @WKAMT
     C                   ENDIF                                                  E01
      *
      ** Set up subfield 2 (date)
     C                   MOVE      @RUND         @64S2
      *
      ** Set up subfields 3 and 4 (Currency and Amount) nb. use
      ** currency code returned by ZM0040 in s/f 3 because this should
      ** be ISO standard value
     C                   CALL      'ZM0040'
     C                   PARM      @WKAMT        ZAMNT            13 0
     C                   PARM      F1CCY         ZCCY              3
     C     @64S4         PARM                    ZSAMNT           15
     C     @64S3         PARM                    ZSCCY             3
     C                   PARM      *BLANKS       ZERR              1
     C                   PARM      WSWDPC        ZSWDPC                                        CSW02
      *
      ** If program fails, report database error
     C     ZERR          IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '005'         DBASE                          * * * * * * * *
     C                   MOVEL     'PROGRAM'     DBKEY                          *  DBERR 005  *
     C                   MOVEL     'ZM0040  '    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Move data to output record
     C                   MOVEL     @64           @DAT4
     C                   MOVE      @DATA         F4DATA
      *
      ** Write record to file
     C                   WRITE     GLFDTAD0
      *
     C                   ENDSR                                                  FLD64
      /EJECT
     C/COPY WNCPYSRC,GL2804C007
      *
      *****************************************************************
      * Subroutine  :  CLSDWN                                         *
      * Function    :  Closing Processing                             *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :                                                 *
      *****************************************************************
      *
     C     CLSDWN        BEGSR
      *
      ** Check for an index record for that day's member
      *
     C     MNM           CHAIN     GLFREFL0                           21
      *
     C     *IN21         IFEQ      '1'
     C                   MOVE      MNM           F3MBRN
     C                   MOVE      'P'           F3DNLS
     C                   Z-ADD     0             F3RSTN
     C                   MOVE      *BLANKS       F3RSTU
     C                   Z-ADD     0             F3RSTD
     C                   Z-ADD     0             F3RTIM
     C                   Z-ADD     0             F3DLDL
     C                   Z-ADD     0             F3TDNL
     C                   MOVE      *BLANKS       F3DLFN
     C                   WRITE     GLFREFD0
     C                   ELSE
     C                   MOVE      'P'           F3DNLS
     C                   Z-ADD     0             F3RSTN
     C                   MOVE      *BLANKS       F3RSTU
     C                   Z-ADD     0             F3RSTD
     C                   Z-ADD     0             F3RTIM
     C                   Z-ADD     0             F3DLDL
     C                   Z-ADD     0             F3TDNL
     C                   MOVE      *BLANKS       F3DLFN
     C                   UPDATE    GLFREFD0
     C                   ENDIF
      *
      ** Output Audit Trail Report
     C                   EXSR      AUDIT
      *
     C                   ENDSR                                                  CLSDWN
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  AUDIT                                          *
      * Function    :  Produce Audit Trail Report                     *
      *                                                               *
      * Called by   :  CLSDWN                                         *
      * Calls       :                                                 *
      *****************************************************************
      *
     C     AUDIT         BEGSR
      *
      ** If no record found on the file PF/GLFONAPD
     C     *IN22         IFEQ      '1'                                          B01
     C     W@RED         ANDEQ     0
      *
      ** Write 'no messages to report'
     C                   WRITE     GL2804A4
     C                   ELSE                                                   X01
      *
      ** Write out details
     C                   WRITE     GL2804A2                             31
     C                   ENDIF                                                  E01
      *
      ** Write out 'End of Report'
     C                   WRITE     GL2804A6
      *
      ** Close Audit printer file PRTF/GL2804AU
     C                   CLOSE     GL2804AU
      *
     C                   ENDSR                                                  AUDIT
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  *PSSR                                          *
      * Function    :  Called autmatically if a program error occurs  *
      *                or directly in case of database errors.        *
      *                This program DUMPs the program just once.      *
      *                                                               *
      * Called by   :  Automatically                                  *
      *                INIT                                           *
      *                                                               *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                              **
      *
      ** Check to see if *PSSR has been already called
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
      ** DUMP and write database error report
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   WRITE     GL2804A5
     C                   WRITE     GL2804A6
      *
      ** Close Audit printer file PRTF/GL2804AU
     C                   CLOSE     GL2804AU
      *
     C                   ENDIF
      *
      ** If *PSSR already run, end program.
      *
     C                   RETURN
      *
     C                   ENDSR                                                  *PSSR
      *
      ********************************************************************
** CPY@
(c) Finastra International Limited 2001
