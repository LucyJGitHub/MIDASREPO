     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME BIC Database Copy')
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1470 - BIC Database Copy (Delta Update)                    *
      *                                                               *
      *  Function - This program reads the 'temporary' files for the  *
      *             BIC Database Plus and updates the master files    *
      *             accordingly                                       *
      *                                                               *
      *  Called By: MEC1420 - BIC Database Converter                  *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CFT040             Date 15Sep08               *
      *                 CFT035  *CREATE    Date 03Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT040 - BIC Plus IBAN Utility                               *
      *  CFT035 - BIC Database Changes for 2007                       *
      *                                                               *
      *****************************************************************
     FMETICPPD  IF   E             DISK
     FMETICCPD  IF   E             DISK
     FMEBICPL0  UF A E           K DISK    RENAME(@BICPPD:@BICPL0)
     F                                     PREFIX(MAS_)
     FMEBICCL0  UF A E           K DISK    RENAME(@BICCPD:@BICCL0)
     F                                     PREFIX(MAS_)
     FME1470P1  O    E             PRINTER OFLIND(*IN70)
     FMETICBPD  IF   E             DISK    PREFIX(TMP_)                                       CFT040
      ** Temporary BIC Plus IBAN file                                                         CFT040
      *                                                                                       CFT040
     FMEBICBL0  UF A E           K DISK    RENAME(MEBICBD0:@BICBL0)                           CFT040
     F                                     PREFIX(MST_)                                       CFT040
      ** Midas ME BIC Plus IBAN by Key                                                        CFT040
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    F U N C T I O N   O F   I N D I C A T O R S                *
      *                                                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     D
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
     D CFT040          S              1A                                                      CFT040
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects
      *
     D BICPTMP       E DS                  EXTNAME(METICPPD)
      ** BIC Plus temporary file records
      *
     D BICCTMP       E DS                  EXTNAME(METICCPD)
      ** BIC Country temporary file records
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT040
      ** External DS for SAR Details                                                          CFT040
      *                                                                                       CFT040
     D BICBTMP       E DS                  EXTNAME(METICBPD)                                  CFT040
     D                                     PREFIX(TMP_)                                       CFT040
      ** BIC Plus IBAN temporary file records                                                 CFT040
      *                                                                                       CFT040
     D BICPMAS         DS
     DMAS_BITAG                1      2
     DMAS_BIFLAG               3      3
     DMAS_BIBIC                4     14
     DMAS_BIINST              15    119
     DMAS_BIBNCH             120    189
     DMAS_BICITY             190    224
     DMAS_BISTYP             225    228
     DMAS_BISERV             229    288
     DMAS_BIXINF             289    323
     DMAS_BIADDR             324    463
     DMAS_BIZIP              464    478
     DMAS_BILOCN             479    568
     DMAS_BICNTY             569    638
     DMAS_BIPOBN             639    673
     DMAS_BIPOBZ             674    688
     DMAS_BIPOBL             689    778
     DMAS_BIPOBC             779    848
     DMAS_BISRCI             849    850
     DMAS_BISPEC             851    856
     DMAS_BIUPDT             857    862
     DMAS_BIORIG             863    866
     DMAS_BIKEY              867    874
     DMAS_BICHCK             875    876
     DMAS_BICHIP             877    882
     DMAS_BINATI             883    897
     DMAS_BIACTD             898    903
     DMAS_BIDCTD             904    909
     DMAS_BIUNDC             910    917
     DMAS_BIUNDN             918    925
     DMAS_BINKEY             926    933
     DMAS_BICFLG             934    934
     DMAS_BICINS             935    935
     DMAS_BIUSER             936   1063
     DMAS_BICBI1            1064   1080
     DMAS_BICBI2            1081   1097
     DMAS_BICBI3            1098   1114
     DMAS_BICBI4            1115   1131
     DMAS_BICBD1            1132   1160
     DMAS_BICBD2            1161   1189
     DMAS_BIMFLG            1190   1190
     DMAS_BIMMTH            1191   1191
     DMAS_BIMRLT            1192   1192
     DMAS_BIFILL            1193   1248
      ** BIC Plus master file records
      *
     D BICCMAS         DS
     DMAS_BCTAG                1      2
     DMAS_BCFLAG               3      3
     DMAS_BCCNTC               4      5
     DMAS_BCCNTY               6     75
     DMAS_BCFIL1              76    330
     DMAS_BCFIL2             331    585
     DMAS_BCFIL3             586    840
     DMAS_BCFIL4             841   1095
     DMAS_BCFIL5            1096   1248
      ** BIC Country master file records
      *
     D LDA             DS           256
      ** Local data area for database error details
      *
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256
      *                                                                                       CFT040
     D BICBMST         DS                                                                     CFT040
     DMST_BITAG                1      2                                                       CFT040
     DMST_BIFLAG               3      3                                                       CFT040
     DMST_BIKEY                4     11                                                       CFT040
     DMST_BIINST              12    116                                                       CFT040
     DMST_BICITY             117    151                                                       CFT040
     DMST_BIBINF             152    221                                                       CFT040
     DMST_BIBICC             222    229                                                       CFT040
     DMST_BIBRCD             230    232                                                       CFT040
     DMST_BIUBIC             233    240                                                       CFT040
     DMST_BIUBRC             241    243                                                       CFT040
     DMST_BIIBIC             244    251                                                       CFT040
     DMST_BIIBRC             252    254                                                       CFT040
     DMST_BIRBIC             255    262                                                       CFT040
     DMST_BIRBRC             263    265                                                       CFT040
     DMST_BIPBCD             266    269                                                       CFT040
     DMST_BICTCD             270    271                                                       CFT040
     DMST_BINATI             272    286                                                       CFT040
     DMST_BIUNTI             287    301                                                       CFT040
     DMST_BIICTY             302    303                                                       CFT040
     DMST_BIINAT             304    318                                                       CFT040
     DMST_BIUIND             319    333                                                       CFT040
     DMST_BIOND1             334    350                                                       CFT040
     DMST_BIOND2             351    367                                                       CFT040
     DMST_BICHIP             368    373                                                       CFT040
     DMST_BISTYP             374    377                                                       CFT040
     DMST_BISERV             378    437                                                       CFT040
     DMST_BIBRQA             438    472                                                       CFT040
     DMST_BISPCD             473    478                                                       CFT040
     DMST_BIADDR             479    618                                                       CFT040
     DMST_BIZIP              619    633                                                       CFT040
     DMST_BILOCN             634    723                                                       CFT040
     DMST_BICNTY             724    793                                                       CFT040
     DMST_BIPOBN             794    828                                                       CFT040
     DMST_BIPOBZ             829    843                                                       CFT040
     DMST_BIPLOC             844    933                                                       CFT040
     DMST_BIPCNT             934   1003                                                       CFT040
     DMST_BINDED            1004   1011                                                       CFT040
     DMST_BIUDAT            1012   1019                                                       CFT040
     DMST_BIFIL1            1020   1248                                                       CFT040
      ** BIC Plus IBAN master file records                                                    CFT040
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                   Index to subroutines                        *
      *  Main routine                                                 *
      *  SRINIT  -  Initial processing                                *
      *  SRDETL  -  Detail processing                                 *
      *  WRITEC  -  Write record to country                           *
      *  WRITEB  -  Write record to BIC                               *
      *  WRITEP  -  Write record to BIC Plus IBAN                     *                       CFT040
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
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'ME1470'      DBPGM
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBTXT
     C                   Z-ADD     0             DBASE
     C                   OUT       LDA
      *
      ** Retrieve bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST  '    POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         *DB ERROR 001 *
     C                   MOVEL     '*FIRST  '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CFT040
      ** Check if CFT040 is switched on                                                       CFT040
      *                                                                                       CFT040
     C                   EVAL      CFT040 = 'N'                                               CFT040
     C                   CALL      'AOSARDR0'                                                 CFT040
     C                   PARM      *BLANKS       @Rtcd             7                          CFT040
     C                   PARM      '*VERIFY'     @Optn             7                          CFT040
     C                   PARM      'CFT040'      @Sard             6                          CFT040
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT040
      *                                                                                       CFT040
     C                   IF        @Rtcd = *BLANKS                                            CFT040
     C                   EVAL      CFT040 = 'Y'                                               CFT040
     C                   ELSE                                                                 CFT040
     C                   IF        @Rtcd <> '*NRF   '                                         CFT040
     C     *LOCK         IN        LDA                                                        CFT040
     C                   EVAL      DBFile = 'SCSARDPD'                                        CFT040
     C                   EVAL      DBKey = @Optn                                              CFT040
     C                   EVAL      DBase = 4                                                  CFT040
     C                   OUT       LDA                                                        CFT040
     C                   EXSR      *PSSR                                                      CFT040
     C                   ENDIF                                                                CFT040
     C                   ENDIF                                                                CFT040
      *
      ** Initialise work fields and indicators
      *
     C                   MOVE      '1'           *IN90
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDETL  -  Detail Processing                                 *
      *  Called by: Main routine                                      *
      *  Calls    : SRCONV, SRHEAD, SRPOST, SRSPOT                    *
      *                                                               *
      *****************************************************************
      *
     C     SRDETL        BEGSR
      *
      ** Write report header
      *
     C                   WRITE     #1HEAD
      *                                                                                       CFT040
      ** Process BIC Plus records if CFT040 is off                                            CFT040
      *                                                                                       CFT040
     C                   IF        CFT040 = 'N'                                               CFT040
      *
      ** Read first BIC Plus record
      *
     C                   READ      METICPPD                             5860
      *
     C     *IN58         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE                          ***************
     C                   MOVEL     'METICPPD'    DBFILE                         *DB ERROR 002 *
     C                   MOVEL     '*FIRST  '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
      ** Process BIC Plus records
      *
     C     *IN60         DOWEQ     '0'
      *
      ** Process inserts
      *
     C     BIFLAG        IFEQ      'A'
     C     BIFLAG        OREQ      'W'
     C     BIKEY         CHAIN     MEBICPL0                           61
     C     *IN61         IFEQ      '1'
     C                   EVAl      BICPMAS = BICPTMP
     C                   WRITE     @BICPL0
      *
     C                   ELSE
      *
      ** Write exception to report
      *
     C                   EXSR      WRITEB
     C                   ENDIF
     C                   ENDIF
      *
      ** Process amends
      *
     C     BIFLAG        IFEQ      'M'
     C     BIKEY         CHAIN     MEBICPL0                           61
     C     *IN61         IFEQ      '0'
     C                   EVAl      BICPMAS = BICPTMP
     C                   UPDATE    @BICPL0
      *
     C                   ELSE
      *
      ** Write exception to report
      *
     C                   EXSR      WRITEB
     C                   ENDIF
     C                   ENDIF
      *
      ** Process deletes
      *
     C     BIFLAG        IFEQ      'D'
     C     BIKEY         CHAIN     MEBICPL0                           61
     C     *IN61         IFEQ      '0'
     C                   DELETE    @BICPL0
      *
     C                   ELSE
      *
      ** Write exception to report
      *
     C                   EXSR      WRITEB
     C                   ENDIF
     C                   ENDIF
     C
     C                   READ      METICPPD                               60
     C                   ENDDO
     C                   ENDIF
      *                                                                                       CFT040
      ** Else, process BIC Plus IBAN records if CFT040 is on                                  CFT040
      *                                                                                       CFT040
     C                   ELSE                                                                 CFT040
      *                                                                                       CFT040
      ** Read first BIC Plus IBAN record                                                      CFT040
      *                                                                                       CFT040
     C                   READ      METICBPD                               65                  CFT040
      *                                                                                       CFT040
     C     *IN65         IFEQ      '1'                                                        CFT040
     C     *LOCK         IN        LDA                                                        CFT040
     C                   EVAL      DBASE = 005                                                CFT040
     C                   EVAL      DBFILE = 'METICBPD'                                        CFT040
     C                   MOVEL     '*FIRST  '    DBKEY                                        CFT040
     C                   OUT       LDA                                                        CFT040
     C                   EXSR      *PSSR                                                      CFT040
      *                                                                                       CFT040
     C                   ELSE                                                                 CFT040
      *                                                                                       CFT040
      ** Process BIC Plus IBAN records                                                        CFT040
      *                                                                                       CFT040
     C     *IN65         DOWEQ     '0'                                                        CFT040
      *                                                                                       CFT040
      ** Process inserts                                                                      CFT040
      *                                                                                       CFT040
     C     TMP_BIFLAG    IFEQ      'A'                                                        CFT040
     C     TMP_BIKEY     CHAIN     MEBICBL0                           66                      CFT040
     C     *IN66         IFEQ      '1'                                                        CFT040
     C                   EVAL      BICBMST = BICBTMP                                          CFT040
     C                   WRITE     @BICBL0                                                    CFT040
      *                                                                                       CFT040
     C                   ELSE                                                                 CFT040
      *                                                                                       CFT040
      ** Write exception to report                                                            CFT040
      *                                                                                       CFT040
     C                   EXSR      WRITEP                                                     CFT040
     C                   ENDIF                                                                CFT040
     C                   ENDIF                                                                CFT040
      *                                                                                       CFT040
      ** Process amends                                                                       CFT040
      *                                                                                       CFT040
     C     TMP_BIFLAG    IFEQ      'M'                                                        CFT040
     C     TMP_BIKEY     CHAIN     MEBICBL0                           66                      CFT040
     C     *IN66         IFEQ      '0'                                                        CFT040
     C                   EVAL      BICBMST = BICBTMP                                          CFT040
     C                   UPDATE    @BICBL0                                                    CFT040
      *                                                                                       CFT040
     C                   ELSE                                                                 CFT040
      *                                                                                       CFT040
      ** Write exception to report                                                            CFT040
      *                                                                                       CFT040
     C                   EXSR      WRITEP                                                     CFT040
     C                   ENDIF                                                                CFT040
     C                   ENDIF                                                                CFT040
      *                                                                                       CFT040
      ** Process deletes                                                                      CFT040
      *                                                                                       CFT040
     C     TMP_BIFLAG    IFEQ      'D'                                                        CFT040
     C     TMP_BIKEY     CHAIN     MEBICBL0                           66                      CFT040
     C     *IN66         IFEQ      '0'                                                        CFT040
     C                   EVAL      BICBMST = BICBTMP                                          CFT040
     C                   UPDATE    @BICBL0                                                    CFT040
      *                                                                                       CFT040
     C                   ELSE                                                                 CFT040
      *                                                                                       CFT040
      ** Write exception to report                                                            CFT040
      *                                                                                       CFT040
     C                   EXSR      WRITEP                                                     CFT040
     C                   ENDIF                                                                CFT040
     C                   ENDIF                                                                CFT040
                                                                                              CFT040
     C                   READ      METICBPD                               65                  CFT040
     C                   ENDDO                                                                CFT040
     C                   ENDIF                                                                CFT040
     C                   ENDIF                                                                CFT040
      *
      ** Process BIC country records
      *
     C                   READ      METICCPD                             5962
      *
     C     *IN59         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     3             DBASE                          ***************
     C                   MOVEL     'METICCPD'    DBFILE                         *DB ERROR 003 *
     C                   MOVEL     '*FIRST  '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *
      ** Process BIC Plus records
      *
     C     *IN62         DOWEQ     '0'
      *
      ** Process inserts
      *       3
     C     BCFLAG        IFEQ      'A'
     C     BCFLAG        OREQ      'W'
     C     BCCNTY        CHAIN     MEBICCL0                           63
     C     *IN63         IFEQ      '1'
     C                   EVAl      BICCMAS = BICCTMP
     C                   WRITE     @BICCL0
      *
     C                   ELSE
      *
     C** Write exception to report
      *
     C                   EXSR      WRITEC
     C                   ENDIF
     C                   ENDIF
      *
      ** Process amends
      *
     C     BCFLAG        IFEQ      'M'
     C     BCCNTY        CHAIN     MEBICCL0                           63
     C     *IN63         IFEQ      '0'
     C                   EVAl      BICCMAS = BICCTMP
     C                   UPDATE    @BICCL0
      *
     C                   ELSE
      *
     C** Write exception to report
      *
     C                   EXSR      WRITEC
     C                   ENDIF
     C                   ENDIF
      *
      ** Process deletes
      *
     C     BCFLAG        IFEQ      'D'
     C     BCCNTY        CHAIN     MEBICCL0                           63
     C     *IN63         IFEQ      '0'
     C                   DELETE    @BICCL0
      *
     C                   ELSE
      *
      ** Write exception to report
      *
     C                   EXSR      WRITEC
     C                   ENDIF
     C                   ENDIF
     C
     C                   READ      METICCPD                               62
     C                   ENDDO
     C                   ENDIF
      *
      ** Write report footer
      *
     C                   WRITE     #1FOOT
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WRITEB  -  Write BIC Exception Record                        *
      *  Called by: SRDETL                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WRITEB        BEGSR
      *
      ** Set off successful upload indicator as at least one exception encountered
     C                   MOVE      '0'           *IN90
     C                   MOVEL     BITAG         #1TAG
     C                   MOVEL     BIFLAG        #1MOD
     C                   MOVEL     BIKEY         #1KEY
     C                   MOVEL     BIBIC         #1CODE
     C     100           SUBST     BIINST        #1DATA
     C                   WRITE     #1LIST                               70
      *
      **  If overflow occurs, print headings and detail record
      **  on the next page
      *
     C     *IN70         IFEQ      '1'
     C                   WRITE     #1HEAD
     C                   WRITE     #1LIST                               70
     C                   EVAl      *IN70 = '0'
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WRITEC  -  Write Country Exception Record                    *
      *  Called by: SRDETL                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WRITEC        BEGSR
      *
      ** Set off successful upload indicator as at least one exception encountered
     C                   MOVE      '0'           *IN90
     C                   MOVEL     BCTAG         #1TAG
     C                   MOVEL     BCFLAG        #1MOD
     C                   MOVEL     BCCNTY        #1KEY
     C                   MOVEL     BCCNTC        #1CODE
     C                   MOVEL     BCCNTY        #1DATA
     C                   WRITE     #1LIST                               70
      *
      **  If overflow occurs, print headings and detail record
      **  on the next page
      *
     C     *IN70         IFEQ      '1'
     C                   WRITE     #1HEAD
     C                   WRITE     #1LIST                               70
     C                   EVAl      *IN70 = '0'
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************                       CFT040
      *                                                               *                       CFT040
      *  WRITEP  -  Write BIC Plus IBAN Exception Record              *                       CFT040
      *  Called by: SRDETL                                            *                       CFT040
      *  Calls    : None                                              *                       CFT040
      *                                                               *                       CFT040
      *****************************************************************                       CFT040
      *                                                                                       CFT040
     C     WRITEP        BEGSR                                                                CFT040
      *                                                                                       CFT040
      ** Set off successful upload indicator as at least one exception encountered            CFT040
      *                                                                                       CFT040
     C                   MOVE      '0'           *IN90                                        CFT040
     C                   MOVEL     TMP_BITAG     #1TAG                                        CFT040
     C                   MOVEL     TMP_BIFLAG    #1MOD                                        CFT040
     C                   MOVEL     TMP_BIKEY     #1KEY                                        CFT040
     C                   MOVEL     TMP_BIBICC    #1CODE                                       CFT040
     C     100           SUBST     TMP_BIINST    #1DATA                                       CFT040
     C                   WRITE     #1LIST                               70                    CFT040
      *                                                                                       CFT040
      **  If overflow occurs, print headings and detail record                                CFT040
      **  on the next page                                                                    CFT040
      *                                                                                       CFT040
     C     *IN70         IFEQ      '1'                                                        CFT040
     C                   WRITE     #1HEAD                                                     CFT040
     C                   WRITE     #1LIST                               70                    CFT040
     C                   EVAL      *IN70 = '0'                                                CFT040
     C                   ENDIF                                                                CFT040
      *                                                                                       CFT040
     C                   ENDSR                                                                CFT040
      *                                                                                       CFT040
      /EJECT                                                                                  CFT040
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
     C                   MOVE      '1'           *INLR
     C                   RETURN
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
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   SETON                                        U7U8
     C                   EXSR      SREND
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2007
