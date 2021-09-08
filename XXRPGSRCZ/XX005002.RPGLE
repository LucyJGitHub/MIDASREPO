000100210908     H DEBUG DATEDIT(*YMD)
000101210908      *****************************************************************
000102210908/*STD *  RPGBASEBND                                                   *
000103210908/*EXI *  TEXT('Midas XX Account Codes Mapping to HO Details')         *
000104210908      *****************************************************************
000105210908      *                                                               *
000106210908      *  Midas - General Ledger Module                                *
000107210908      *                                                               *
000108210908      *  XX005002 - Midas XX Account Codes Mapping to HO Details      *
000109210908      *               Enquiry screen                                  *
000110210908      *                                                               *
000111210908      *  Function:  This program will maintain the mapping between    *
000112210908      *             the Midas Account Codes and HO Details            *
000113210908      *                                                               *
000114210908      *  (C) Finastra International Limited 2021                      *
000115210908      *                                                               *
000116210908      *  Last Amend No. DRI005  *CREATE    Date 13Apr21               *
000117210908      *                                                               *
000118210908      *---------------------------------------------------------------*
000119210908      *                                                               *
000120210908      *  DRI005 - HO and EDW Extracts                                 *
000121210908      *                                                               *
000122210908      *****************************************************************
000123210908      *
000124210908      ** Midas A/c Codes Mapping to HO Details screen
000125210908     FXX005002DFCF   E             Workstn Usropn
000126210908     F                                     Infds(Infds#)
000127210908     F                                     Infsr(*PSSR)
000128210908
000129210908      ** Midas A/c Codes Mapping to HO Details - Rtv
000130210908     FXXACHOML0 IF   E           K DISK    Usropn
000131210908     F                                     Infds(Infds1)
000132210908     F                                     Infsr(*PSSR)
000133210908     F                                     Rename(XXACHOMD0:XXACHOMDB)
000134210908
000135210908      ** Midas A/c Codes Mapping to HO Details - Upd
000136210908     FXXACHOML1 UF A E           K DISK    Usropn
000137210908     F                                     Commit
000138210908     F                                     Infds(ID0001)
000139210908     F                                     Infsr(*PSSR)
000140210908     F                                     Rename(XXACHOMD0:XXACHOMDA)
000141210908      /EJECT
000142210908
000143210908      *****************************************************************
000144210908      ** +-------------------------------+
000145210908      ** ¦ Data structures specification |
000146210908      ** +-------------------------------+
000147210908      *
000148210908      * Pgm Data srtucture
000149210908     D PGMDS         ESDs                  Extname(Y2PGDSP)
000150210908
000151210908      ** Display file information data structure
000152210908     D Infds#        E Ds                  Extname(Y2I#DSP)
000153210908
000154210908      ** File information data structure
000155210908     D Infds1        E Ds                  Extname(Y2I1DSP)
000156210908
000157210908      ** HO Details Mapping
000158210908     D @1DBRC        E Ds                  Extname(XXACHOML0)
000159210908
000160210908      ** Long DS for access programs
000161210908     D DSSDY         E Ds                  Extname(DSSDY)
000162210908
000163210908      ** Stored master file format fields
000164210908     D #1DBRC          Ds            23
000165210908     D  #1DB1                  1     10S 0
000166210908     D  #1DB2                 11     15
000167210908     D  #1DB3                 16     19
000168210908     D  #1DB4                 20     22
000169210908     D  #1DB5                 23     23
000170210908
000171210908      ** Standing data controls update
000172210908     D YBRDCS          Ds            23
000173210908     D YCRDCS          Ds            23
000174210908
000175210908      ** Validation Array for valid Midas A/c Code
000176210908     D VLD             S              1A   DIM(10) PERRCD(10) CTDATA
000177210908
000178210908      ** Index for looping through the Midas A/c Code
000179210908     D WIdx1           S              2S 0
000180210908
000181210908      ** Midas A/c Code
000182210908     D MidAccod        S              1A   DIM(10)
000183210908
000184210908      ** Run date
000185210908     D RUNDAT          Ds
000186210908     D  MRDT                   1      7
000187210908     D  RDNB                   8     10P 0
000188210908     D  SUC                   11     11
000189210908     D  DFF                   12     12
000190210908     D  MBIN                  13     13
000191210908
000192210908      ** File information data structure
000193210908     D ID0001          Ds           528
000194210908
000195210908      ** File information data structure
000196210908     D ID0002          Ds           528
000197210908
000198210908     D P1Parm          Ds            23
000199210908     D  P1MDAC                 1     10
000200210908     D  P1HOAC                11     15
000201210908     D  P1HOPC                16     19
000202210908     D  P1HOMC                20     22
000203210908     D  P1EXCL                23     23
000204210908
000205210908      ** MAP Action Code
000206210908     D P2Parm          Ds
000207210908     D  P2ANCD                 1      1
000208210908
000209210908     D                 Ds
000210210908     D  ZAMSDA                 1    132
000211210908     D  ZA0001                 1      3
000212210908     D  ZA0002                 1      6
000213210908
000214210908      ** Renamed input format fields
000215210908     IXXACHOMDB
000216210908     I              XXMACOD                     WACODE
000217210908      /EJECT
000218210908
000219210908      *****************************************************************
000220210908      ** Entry parameters
000221210908      *****************************************************************
000222210908      *
000223210908     C     *Entry        Plist
000224210908     C                   Parm                    P0RTN             7
000225210908     C                   Parm                    P1Parm
000226210908     C     P2ANCD        Parm                    WP0001            1
000227210908      * Initialize
000228210908     C                   Exsr      ZZINIT
000229210908      *
000230210908      * Check passed parameters
000231210908     C                   Exsr      FACKPM
000232210908      * Perform once if all passed, Else repeat
000233210908     C     W0RPT         Doueq     'N'
000234210908      * Display and process key screen
000235210908     C                   Exsr      BADSKY
000236210908     C                   Enddo
000237210908      * Terminate program
000238210908     C                   Exsr      ZXEXPG
000239210908      *
000240210908      /EJECT
000241210908
000242210908      *****************************************************************
000243210908      ** Display and process key screen
000244210908      *****************************************************************
000245210908     CSR   BADSKY        Begsr
000246210908
000247210908      ** Initialize key screen
000248210908     C                   Exsr      MDIZ#K
000249210908
000250210908      ** Bypass first display of key screen is possible
000251210908     C                   Movel     'Y'           W0BYP             1
000252210908      * Signal start of transaction
000253210908     C                   Movel     'Y'           W0TRN             1
000254210908     C     W0TRN         Doweq     'Y'
000255210908     C     W0TRN         Oreq      'K'
000256210908      * Ensure transaction continues (if reset)
000257210908     C                   Movel     'Y'           W0TRN             1
000258210908      * Conduct screen conversation
000259210908     C     W0TRN         Doweq     'Y'
000260210908      * Is bypass key screen still viable?
000261210908     C     W0BYP         Ifeq      'Y'
000262210908     C     #1MDAC        Ifeq      *Blanks
000263210908      * One or more key fields is Blank
000264210908     C     *IN05         Oreq      '1'
000265210908      * HOME: Reset screen fields
000266210908     C                   Movel     'N'           W0BYP
000267210908     C                   Endif
000268210908     C                   Endif
000269210908
000270210908      ** Bypass key screen
000271210908     C     W0BYP         Ifne      'Y'
000272210908      * Display key screen
000273210908     C                   Exsr      BBEXFM
000274210908     C                   Endif
000275210908
000276210908      ** Cancel key screen bypass
000277210908     C                   Movel     'N'           W0BYP
000278210908
000279210908      ** Process response to key screen
000280210908      ** Cancel & exit program
000281210908     C   03              Cas                     ZXEXPG
000282210908
000283210908      ** Switch between *ADD/*CHANGE modes
000284210908     C   09              Cas                     BCCHMD
000285210908
000286210908      ** HOME: Reset screen fields
000287210908     C   05              Cas                     BDHMKY
000288210908
000289210908      ** Process key screen input
000290210908     C                   Cas                     BEPRKY
000291210908     C                   End
000292210908      *
000293210908     C     W0TRN         Doweq     'R'
000294210908     C                   Movel     'Y'           W0TRN
000295210908     C                   Exsr      BEPRKY
000296210908     C                   Enddo
000297210908      *
000298210908     C                   Enddo
000299210908     C                   Enddo
000300210908      *
000301210908     CSR   BAEXIT        Endsr
000302210908      /EJECT
000303210908
000304210908      *****************************************************************
000305210908      * Display key screen
000306210908      *****************************************************************
000307210908     CSR   BBEXFM        Begsr
000308210908
000309210908      **Set screen conditioning indicators
000310210908     C                   Exsr      GADSAK
000311210908      * Update screen Time
000312210908     C                   Time                    ##TME
000313210908     C     W0HLP         Doueq     'N'
000314210908     C                   Movel     'N'           W0HLP             1
000315210908     C                   Move      *ALL'0'       ##OFF            30
000316210908     C                   MoveA     ##OFF         *IN(1)
000317210908
000318210908      ** PUTOVR unless conditioned fields change
000319210908     C                   Seton                                            86
000320210908     C     *IN89         Ifne      BBIN89
000321210908     C                   Setoff                                           86
000322210908     C                   Endif
000323210908     C                   Move      *IN89         BBIN89            1
000324210908
000325210908      ** Display Prompt 1
000326210908     C                   Write     #MSGCTL
000327210908     C                   Write     #CMDTXT1
000328210908     C                   Exfmt     #RCDKEY
000329210908      *
000330210908     C                   Enddo
000331210908      * Clear messages from program message queue
000332210908     C                   Call      'Y2CLMSC'
000333210908     C                   Parm      ##PGM         ZAPGMQ           10
000334210908     C                   Parm      '*SAME'       ZAPGRL            5
000335210908      * Reset first message only flag
000336210908     C                   Movel     'Y'           ZAFSMS            1
000337210908      * Reset global error indicator
000338210908     C                   Setoff                                           99
000339210908      *
000340210908     CSR   BBEXIT        Endsr
000341210908      /EJECT
000342210908
000343210908      *****************************************************************
000344210908      ** Switch between *ADD/*CHANGE modes
000345210908      *****************************************************************
000346210908     CSR   BCCHMD        Begsr
000347210908      *
000348210908     C     W0PMD         Ifeq      'ADD'
000349210908     C                   Movel     'CHG'         W0PMD             3
000350210908     C                   Else
000351210908     C                   Movel     'ADD'         W0PMD
000352210908      *
000353210908     C                   End
000354210908      *
000355210908     CSR   BCEXIT        Endsr
000356210908      /EJECT
000357210908
000358210908      *****************************************************************
000359210908      ** Process HOME key
000360210908      *****************************************************************
000361210908     CSR   BDHMKY        Begsr
000362210908      *
000363210908     C                   Movel     'N'           W0TRN
000364210908      *
000365210908     CSR   BDEXIT        Endsr
000366210908      /EJECT
000367210908
000368210908      *****************************************************************
000369210908      ** Process key screen input
000370210908      *****************************************************************
000371210908     CSR   BEPRKY        Begsr
000372210908
000373210908      ** Initialise detail screen
000374210908     C                   Exsr      MAIZ#1
000375210908
000376210908      ** Validate key fields
000377210908     C                   Exsr      BFVLKY
000378210908     C     *IN99         CabEq     '1'           BEEXIT
000379210908
000380210908      ** Check for existing record
000381210908     C     KRTV          Klist
000382210908     C                   Kfld                    XXMACOD
000383210908      * Setup key
000384210908     C                   Move      #1MDAC        XXMACOD
000385210908     C     KRTV          Chain     XXACHOMDB                          9091
000386210908     C     *IN91         Ifeq      '1'
000387210908      * Record locked
000388210908     C                   Seton                                        9931
000389210908     C                   Goto      BEEXIT
000390210908     C                   Endif
000391210908
000392210908      ** If record does not exist, flip to add mode
000393210908     C     *IN90         Ifeq      '1'
000394210908     C                   Movel     'ADD'         W0PMD
000395210908      * Set up Detail Screen Header Title
000396210908     C                   Exsr      UASUBR
000397210908      * Set up Detail Screen Footer
000398210908     C                   Exsr      UBSUBR
000399210908      *
000400210908     C                   Else
000401210908      * If record does exist, flip to change mode
000402210908     C                   Movel     'CHG'         W0PMD
000403210908      * Load screen fields from DBF
000404210908     C                   Exsr      MBFL#1
000405210908      * Set up Detail Screen Header Title
000406210908     C                   Exsr      UCSUBR
000407210908      * Set up Detail Screen Footer
000408210908     C                   Exsr      UDSUBR
000409210908     C*
000410210908     C                   Endif
000411210908      *
000412210908     C   99              Goto      BEEXIT
000413210908
000414210908      ** No error: Display and process details
000415210908     C                   Exsr      CADSDA
000416210908      *
000417210908     CSR   BEEXIT        Endsr
000418210908      /EJECT
000419210908
000420210908      *****************************************************************
000421210908      * Validate key fields
000422210908      *****************************************************************
000423210908     CSR   BFVLKY        Begsr
000424210908
000425210908      ** Validate entries
000426210908     C                   If        P2ANCD = 'I'
000427210908     C                   Setoff                                       9931
000428210908
000429210908      ** Midas A/c Code validation
000430210908      * Midas A/c code should consist of 4 digits
000431210908     C                   MoveA     #1MDAC        MidAccod
000432210908
000433210908     C                   For       WIdx1 = 1 TO 10
000434210908     C                   If        %LookUp(MidAccod(WIdx1):VLD) = 0
000435210908     C                   Seton                                        99
000436210908     C                   Seton                                        31
000437210908     C                   Movel     'DRI0511'     ZAMSID
000438210908     C                   Movel     'XXUSRMSG'    ZAMSGF
000439210908     C                   Exsr      ZASNMS
000440210908     C                   Goto      BFEXIT
000441210908     C                   Endif
000442210908     C                   EndFor
000443210908     C                   If        *IN31 = *Off
000444210908
000445210908      ** Check for existing record
000446210908     C                   Move      #1MDAC        XXMACOD
000447210908     C     KRTV          Chain     XXACHOMDB                          90
000448210908     C                   If        *IN90 = *off
000449210908      * Duplicate Midas A/c Code entered
000450210908     C                   Seton                                        99
000451210908     C                   Seton                                        31
000452210908     C                   Movel     'DRI0514'     ZAMSID
000453210908     C                   Movel     'XXUSRMSG'    ZAMSGF
000454210908     C                   Exsr      ZASNMS
000455210908     C                   Endif
000456210908      *
000457210908     C                   Endif
000458210908      *
000459210908     C                   Endif
000460210908      *
000461210908     CSR   BFEXIT        Endsr
000462210908      /EJECT
000463210908
000464210908      *****************************************************************
000465210908      ** Display and process detail screen
000466210908      *****************************************************************
000467210908     CSR   CADSDA        Begsr
000468210908
000469210908      ** Repeat until screen control flag is reset:
000470210908     C     W0TRN         DOWEQ     'Y'
000471210908      * Display detail screen
000472210908     C                   Exsr      CBEXFM
000473210908      * Process response to detail screen
000474210908      * Cancel & exit program
000475210908     C   03              Cas                     ZXEXPG
000476210908      * Redisplay previous screen
000477210908     C   12              Cas                     CCDSPV
000478210908      * HOME: Reset screen fields
000479210908     C   05              Cas                     CCDSPV
000480210908      * Process detail screen input
000481210908     C                   Cas                     CFPRSC
000482210908     C                   End
000483210908      *
000484210908     C     W0TRN         Ifeq      'R'
000485210908     C     W0PMD         Ifeq      'ADD'
000486210908     C                   Exsr      MAIZ#1
000487210908     C                   Endif
000488210908     C                   Endif
000489210908      *
000490210908     C                   Enddo
000491210908      *
000492210908     CSR   CAEXIT        Endsr
000493210908      /EJECT
000494210908
000495210908      *****************************************************************
000496210908      ** Display screen
000497210908      *****************************************************************
000498210908     CSR   CBEXFM        Begsr
000499210908
000500210908      ** Set screen conditioning indicators
000501210908     C                   Exsr      GBDSAD
000502210908
000503210908      ** Update screen Time
000504210908     C                   Time                    ##TME
000505210908     C     W0HLP         Doueq     'N'
000506210908     C                   Movel     'N'           W0HLP             1
000507210908     C                   Move      *ALL'0'       ##OFF            30
000508210908     C                   MoveA     ##OFF         *IN(1)
000509210908
000510210908      ** PUTOVR unless conditioned fields change
000511210908     C                   Seton                                            86
000512210908     C     *IN89         Ifne      CBIN89
000513210908     C                   Setoff                                           86
000514210908     C                   Endif
000515210908     C                   Move      *IN89         CBIN89            1
000516210908      *
000517210908     C                   Write     #MSGCTL
000518210908     C                   Write     #CMDTXT2
000519210908     C                   Exfmt     #RCDDTL1
000520210908
000521210908     C                   Enddo
000522210908      * Clear messages from program message queue
000523210908     C                   Call      'Y2CLMSC'
000524210908     C                   Parm      ##PGM         ZAPGMQ           10
000525210908     C                   Parm      '*SAME'       ZAPGRL            5
000526210908      * Reset first message only flag
000527210908     C                   Movel     'Y'           ZAFSMS            1
000528210908      * Reset global error indicator
000529210908     C                   Setoff                                           99
000530210908      *
000531210908     CSR   CBEXIT        Endsr
000532210908      /EJECT
000533210908
000534210908      *****************************************************************
000535210908      ** Redisplay previous screen
000536210908      *****************************************************************
000537210908     CSR   CCDSPV        Begsr
000538210908
000539210908      ** Case: PAR.Action Code is Insert
000540210908     C     P2ANCD        Ifeq      'I'
000541210908      * Set up Key Screen Header Title
000542210908     C                   Exsr      UFSUBR
000543210908      * Set up Key Screen Footer
000544210908     C                   Exsr      UGSUBR
000545210908     C                   Else
000546210908      * Case: *Otherwise
000547210908     C                   Movel     'USR0790'     P0RTN
000548210908     C                   Exsr      ZYEXPG
000549210908     C                   Endif
000550210908      *
000551210908     C   05              Movel     'R'           W0TRN
000552210908     C   12              Movel     'K'           W0TRN
000553210908      *
000554210908     CSR   CCEXIT        Endsr
000555210908      /EJECT
000556210908
000557210908      *================================================================
000558210908      * Validate record
000559210908      *================================================================
000560210908     CSR   CFPRSC        Begsr
000561210908
000562210908      ** Confirm/update is not deferred
000563210908     C                   Movel     'N'           W0DCF             1
000564210908      * Validate details
000565210908     C  N10              Cas                     DCVLDL
000566210908     C                   End
000567210908      * QUIT if error:
000568210908     C   99              Goto      CFEXIT
000569210908      * Redisplay if change of customer entry.
000570210908     C   98              Goto      CFEXIT
000571210908      * Defer confirm/update requested
000572210908     C     W0DCF         CabEq     'Y'           CFEXIT
000573210908
000574210908      ** No error: update record
000575210908     C                   Exsr      EBPR##
000576210908      *
000577210908     CSR   CFEXIT        Endsr
000578210908      /EJECT
000579210908
000580210908      *****************************************************************
000581210908      ** Validate details
000582210908      *****************************************************************
000583210908     CSR   DCVLDL        Begsr
000584210908
000585210908      ** USER: Validate detail screen relations
000586210908     C                   Setoff                                       98
000587210908      *
000588210908     C     WP0001        Ifne      'E'
000589210908     C     W0PMD         Ifeq      'ADD'
000590210908     C     W0PMD         Oreq      'CHG'
000591210908      *
000592210908     C                   Setoff                                       993141
000593210908     C                   Setoff                                       424344
000594210908
000595210908      ** Check if record exists - Midas A/c Code
000596210908     C     W0PMD         Ifeq      'ADD'
000597210908     C                   Exsr      SDRVGN
000598210908
000599210908      ** Case: PGM.*Return code is *Record already exists
000600210908     C     W0RTN         Ifeq      'Y2U0003'
000601210908      * Setup message data for message
000602210908     C                   Movel     #1HOAC        ZA0001
000603210908      * Send message 'Midas A/c Code must be unique'
000604210908     C                   Movel     'DRI0505'     ZAMSID
000605210908     C                   Movel     'XXUSRMSG'    ZAMSGF
000606210908     C                   Exsr      ZASNMS
000607210908     C                   Seton                                        9941
000608210908     C                   Goto      DCEXIT
000609210908     C                   Endif
000610210908     C                   Endif
000611210908
000612210908      ** Case: *Otherwise
000613210908     C                   If        #1HOAC = *Blanks
000614210908      * HO A/c Code must be entered
000615210908     C                   Seton                                        9942
000616210908     C                   Movel     'DRI0506'     ZAMSID
000617210908     C                   Movel     'XXUSRMSG'    ZAMSGF
000618210908     C                   Exsr      ZASNMS
000619210908     C                   Endif
000620210908      *
000621210908     C                   If        #1HOPC = *Blanks
000622210908      * HO Product Code must be entered
000623210908     C                   Seton                                        9943
000624210908     C                   Movel     'DRI0507'     ZAMSID
000625210908     C                   Movel     'XXUSRMSG'    ZAMSGF
000626210908     C                   Exsr      ZASNMS
000627210908     C                   Endif
000628210908      *
000629210908     C                   If        #1HOMC = *Blanks
000630210908      * HO Market Code must be entered
000631210908     C                   Seton                                        9944
000632210908     C                   Movel     'DRI0508'     ZAMSID
000633210908     C                   Movel     'XXUSRMSG'    ZAMSGF
000634210908     C                   Exsr      ZASNMS
000635210908     C                   Endif
000636210908      *
000637210908     C                   If        #1EXCL = *Blanks
000638210908      * Exclude flag must be entered
000639210908     C                   Seton                                        9945
000640210908     C                   Movel     'DRI0509'     ZAMSID
000641210908     C                   Movel     'XXUSRMSG'    ZAMSGF
000642210908     C                   Exsr      ZASNMS
000643210908     C                   Else
000644210908     C                   If        #1EXCL <> 'Y' and #1EXCL <> 'N'
000645210908      * Exclude flag must be 'Y' or 'N'
000646210908     C                   Seton                                        9945
000647210908     C                   Movel     'DRI0510'     ZAMSID
000648210908     C                   Movel     'XXUSRMSG'    ZAMSGF
000649210908     C                   Exsr      ZASNMS
000650210908     C                   Endif
000651210908     C                   Endif
000652210908      *
000653210908     C                   Endif
000654210908     C                   Endif
000655210908      *
000656210908     CSR   DCEXIT        Endsr
000657210908      /EJECT
000658210908
000659210908      *****************************************************************
000660210908      ** Process record:
000661210908      *****************************************************************
000662210908     CSR   EBPR##        Begsr
000663210908
000664210908      ** Process delete request
000665210908     C   10              Cas                     EDDLRQ
000666210908
000667210908      ** Process add request
000668210908     C     W0PMD         CaseQ     'ADD'         ECADRQ
000669210908
000670210908      ** Process update request
000671210908     C     W0PMD         CasNE     'ADD'         EECHRQ
000672210908     C                   End
000673210908
000674210908      ** Error: ROLLBACK any DBF changes
000675210908     C     W0RTN         Ifne      *Blank
000676210908     C                   Rolbk
000677210908     C                   Goto      EBEXIT
000678210908     C                   Else
000679210908      * Otherwise Commit any DBF changes
000680210908     C                   Commit
000681210908     C                   Endif
000682210908
000683210908      ** USER: Process command keys
000684210908     C     W0RTN         Ifeq      *Blank
000685210908     C     W0PMD         Ifeq      'ADD'
000686210908      * Exit after successful add
000687210908     C                   Movel     'N'           W0RPT
000688210908     C                   Endif
000689210908      * Restart program for next record
000690210908     C                   Movel     'N'           W0TRN
000691210908     C                   Endif
000692210908      *
000693210908     CSR   EBEXIT        Endsr
000694210908      /EJECT
000695210908
000696210908      *****************************************************************
000697210908      ** Process add request
000698210908      *****************************************************************
000699210908     CSR   ECADRQ        Begsr
000700210908
000701210908      ** Create Midas A/c Code
000702210908     C                   Exsr      SECRRC
000703210908     C     W0RTN         Ifeq      *Blank
000704210908      * Send message '*Record added'
000705210908     C                   Movel     'Y2U0011'     ZAMSID
000706210908     C                   Movel     'Y2USRMSG'    ZAMSGF
000707210908     C                   Exsr      ZASNMS
000708210908     C                   Endif
000709210908      *
000710210908     CSR   ECEXIT        Endsr
000711210908      /EJECT
000712210908
000713210908      *****************************************************************
000714210908      ** Process delete request
000715210908      *****************************************************************
000716210908     CSR   EDDLRQ        Begsr
000717210908
000718210908      ** Physical delete Midas A/c Code
000719210908     C                   Exsr      SGCHRC
000720210908     C     W0RTN         Ifeq      *Blank
000721210908      * Send message '*Record deleted'
000722210908     C                   Movel     'Y2U0013'     ZAMSID
000723210908     C                   Movel     'Y2USRMSG'    ZAMSGF
000724210908     C                   Exsr      ZASNMS
000725210908     C                   Endif
000726210908      *
000727210908     CSR   EDEXIT        Endsr
000728210908      /EJECT
000729210908
000730210908      *****************************************************************
000731210908      ** Process update request
000732210908      *****************************************************************
000733210908     CSR   EECHRQ        Begsr
000734210908
000735210908      ** Change Midas A/c Code
000736210908     C     WP0001        Ifne      'E'
000737210908     C                   Exsr      SHCHRC
000738210908     C     W0RTN         Ifne      *Blank
000739210908      * Reset screen fields if changed record
000740210908     C     W0RTN         CaseQ     'Y2U0007'     MBFL#1
000741210908     C                   End
000742210908     C                   Else
000743210908      * Send message '*Record changed'
000744210908     C                   Movel     'Y2U0012'     ZAMSID
000745210908     C                   Movel     'Y2USRMSG'    ZAMSGF
000746210908     C                   Exsr      ZASNMS
000747210908     C                   Endif
000748210908     C                   Endif
000749210908      *
000750210908     CSR   EEEXIT        Endsr
000751210908      /EJECT
000752210908
000753210908      *****************************************************************
000754210908      ** Check passed parameters
000755210908      *****************************************************************
000756210908     CSR   FACKPM        Begsr
000757210908      * Is full key present?
000758210908     C     P1MDAC        Ifeq      *Blanks
000759210908      * Not every key field passed - loop program
000760210908     C                   Movel     'Y'           W0RPT             1
000761210908     C                   Else
000762210908      * Full key passed, so single shot program
000763210908     C                   Movel     'N'           W0RPT
000764210908     C                   Endif
000765210908      *
000766210908     CSR   FAEXIT        Endsr
000767210908      /EJECT
000768210908
000769210908      *****************************************************************
000770210908      ** Set key screen conditioning indicators
000771210908      *****************************************************************
000772210908     CSR   GADSAK        Begsr
000773210908      *
000774210908     C     W0PMD         COMP      'ADD'                                  89
000775210908      *
000776210908     CSR   GAEXIT        Endsr
000777210908      /EJECT
000778210908
000779210908      *****************************************************************
000780210908      ** Set detail screen conditioning indicators
000781210908      *****************************************************************
000782210908     CSR   GBDSAD        Begsr
000783210908      *
000784210908     C     W0PMD         Comp      'ADD'                                  89
000785210908      * Protect key fields on detail screen
000786210908     C                   Seton                                        88
000787210908     C                   Movel     '0'           *IN79
000788210908     C                   Movel     '0'           *IN80
000789210908      *
000790210908     C     WUOFIN        Ifeq      'Y'
000791210908     C                   Movel     '1'           *IN79
000792210908     C                   Movel     '1'           *IN80
000793210908     C                   Endif
000794210908      *
000795210908     C                   Movel     '0'           *IN78
000796210908     C     W0PMD         Ifeq      'ADD'
000797210908     C                   Movel     '1'           *IN78
000798210908     C                   Endif
000799210908      * Enable key screen
000800210908     C                   Seton                                        87
000801210908      *
000802210908     CSR   GBEXIT        Endsr
000803210908      /EJECT
000804210908
000805210908      *****************************************************************
000806210908      * Initialise record - except for key fields
000807210908      *================================================================
000808210908     CSR   MAIZ#1        Begsr
000809210908      *
000810210908     C                   Movel     P2ANCD        #PANCD
000811210908      *
000812210908     C                   If        P2ANCD = 'I'
000813210908     C                   Movel     *Blanks       #1HOAC
000814210908     C                   Movel     *Blanks       #1HOPC
000815210908     C                   Movel     *Blanks       #1HOMC
000816210908     C                   Movel     *Blanks       #1EXCL
000817210908
000818210908     C                   Setoff                                       314142
000819210908     C                   Setoff                                       434445
000820210908     C                   Endif
000821210908      *
000822210908     CSR   MAEXIT        Endsr
000823210908      /EJECT
000824210908
000825210908      *****************************************************************
000826210908      ** Move XXACHOMTD fields to screen
000827210908      *****************************************************************
000828210908     CSR   MBFL#1        Begsr
000829210908      *
000830210908     C                   Move      WACODE        #1MDAC
000831210908     C                   Movel     XXMHOAC       #1HOAC
000832210908     C                   Movel     XXMHOPC       #1HOPC
000833210908     C                   Movel     XXMHOMC       #1HOMC
000834210908     C                   Movel     XXMEXCL       #1EXCL
000835210908
000836210908      * Hold existing record image
000837210908     C                   Move      *Blanks       #1DBRC
000838210908     C                   Movel     @1DBRC        #1DBRC
000839210908      *
000840210908     CSR   MBEXIT        Endsr
000841210908      /EJECT
000842210908
000843210908      *****************************************************************
000844210908      ** Initialize key screen
000845210908      *****************************************************************
000846210908     CSR   MDIZ#K        Begsr
000847210908      *
000848210908     C                   Movel     P2ANCD        #PANCD
000849210908     C                   Movel     P1MDAC        #1MDAC
000850210908     C                   Movel     P1HOAC        #1HOAC
000851210908     C                   Movel     P1HOPC        #1HOPC
000852210908     C                   Movel     P1HOMC        #1HOMC
000853210908     C                   Movel     P1EXCL        #1EXCL
000854210908
000855210908      * Set up Key Screen Header Title
000856210908     C                   Exsr      UHSUBR
000857210908      * Set up Key Screen Footer
000858210908     C                   Exsr      UISUBR
000859210908      *
000860210908     CSR   MDEXIT        Endsr
000861210908      /EJECT
000862210908
000863210908      *****************************************************************
000864210908      ** Check if record exists - Midas A/c Code
000865210908      *****************************************************************
000866210908     CSR   SDRVGN        Begsr
000867210908      *
000868210908     C                   Movel     *Blank        W0RTN             7
000869210908      * Declare restrictor key work fields
000870210908     C     *Like         Define    WACODE        WQSD01
000871210908      * Define keylist
000872210908     C     KRSSD         Klist
000873210908     C                   Kfld                    WQSD01
000874210908      * Move fields to key list
000875210908     C                   Move      #1MDAC        WQSD01
000876210908     C     KRSSD         Setll     XXACHOMDB
000877210908     C     KRSSD         Reade     XXACHOMDB                              90
000878210908     C     *IN90         Ifeq      '1'
000879210908     C                   Movel     'DRI0515'     W0RTN             7
000880210908      * USER: Processing if Data record not found
000881210908     C                   Movel     'Y2U0005'     W0RTN
000882210908     C                   Goto      SDEXIT
000883210908     C                   Endif
000884210908      *
000885210908     C     *IN90         Doweq     '0'
000886210908     C                   Movel     'Y2U0003'     W0RTN
000887210908     C     KRSSD         Reade     XXACHOMDB                              90
000888210908     C                   Enddo
000889210908      *
000890210908     CSR   SDEXIT        Endsr
000891210908      /EJECT
000892210908
000893210908      *****************************************************************
000894210908      ** Create Midas A/c Code
000895210908      *****************************************************************
000896210908     CSR   SECRRC        Begsr
000897210908      *
000898210908     C                   Movel     *Blank        W0RTN             7
000899210908      * Move all fields to XXACHOMTD
000900210908     C                   Move      #1MDAC        XXMACOD
000901210908     C                   Movel     #1HOAC        XXMHOAC
000902210908     C                   Movel     #1HOPC        XXMHOPC
000903210908     C                   Movel     #1HOMC        XXMHOMC
000904210908     C                   Movel     #1EXCL        XXMEXCL
000905210908      *
000906210908     C     KLCRSE        Klist
000907210908     C                   Kfld                    XXMACOD
000908210908      * Check for duplicate primary key
000909210908     C     KLCRSE        Setll     XXACHOMDA                              90
000910210908     C     *IN90         Ifeq      '1'
000911210908     C                   Movel     'DRI0514'     W0RTN             7
000912210908      * Send message 'Midas A/c Code exist'
000913210908     C                   Movel     'DRI0514'     ZAMSID
000914210908     C                   Exsr      ZASNMS
000915210908     C                   Goto      SEEXIT
000916210908     C                   Endif
000917210908      *
000918210908     C                   Write     XXACHOMDA                            91
000919210908      *
000920210908     C     *IN91         Ifeq      '1'
000921210908      * Write error detected
000922210908     C                   Movel     'Y2U0004'     W0RTN             7
000923210908     C                   Else
000924210908      * USER: Processing after Data update
000925210908     C                   Z-Add     1             WUNORC
000926210908     C                   Z-Add     1             WUNOIN
000927210908     C                   Z-Add     *Zero         WUNOAM
000928210908     C                   Z-Add     *Zero         WUNODL
000929210908     C                   Endif
000930210908      *
000931210908     CSR   SEEXIT        Endsr
000932210908      /EJECT
000933210908
000934210908      *****************************************************************
000935210908      ** Physical delete of Midas A/c Code
000936210908      *****************************************************************
000937210908     CSR   SGCHRC        Begsr
000938210908     C                   Movel     *Blank        W0RTN             7
000939210908      * Case: PAR.Action Code is Delete
000940210908     C     P2ANCD        Ifeq      'D'
000941210908     C                   Move      #1MDAC        XXMACOD
000942210908      *
000943210908     C     KLDLTR        Klist
000944210908     C                   Kfld                    XXMACOD
000945210908     C     KLDLTR        Chain     XXACHOMDA                          9091
000946210908      *
000947210908     C     *IN90         Ifeq      '1'
000948210908      * Record not found
000949210908     C                   Movel     'Y2U0009'     W0RTN             7
000950210908      * Send message '*Record no longer on file'
000951210908     C                   Movel     'Y2U0009'     ZAMSID
000952210908     C                   Movel     'Y2USRMSG'    ZAMSGF
000953210908     C                   Exsr      ZASNMS
000954210908     C                   Goto      SGEXIT
000955210908     C                   Endif
000956210908      * Record locked
000957210908     C     *IN91         Ifeq      '1'
000958210908     C                   Movel     'Y2U0004'     W0RTN             7
000959210908     C                   Goto      SGEXIT
000960210908     C                   Endif
000961210908      *
000962210908     C     *IN91         Ifeq      '0'
000963210908     C     *IN90         Andeq     '0'
000964210908     C                   Delete    XXACHOMDA
000965210908     C                   Goto      SGEXIT
000966210908     C                   Endif
000967210908      *
000968210908     C                   Else
000969210908      * Send message 'Function key not allowed'
000970210908     C                   Movel     'USR0533'     ZAMSID
000971210908     C                   Exsr      ZASNMS
000972210908     C                   Seton                                        99
000973210908      *
000974210908     C                   Movel     'Y2U0004'     W0RTN
000975210908     C                   Goto      SGEXIT
000976210908     C                   Endif
000977210908
000978210908      ** Set PGM.*Record Data Changed flag
000979210908     C                   Move      'N'           YBRDC             1
000980210908      *
000981210908      * Move key fields to XXCACHOMTD
000982210908     C                   Move      #1MDAC        XXMACOD
000983210908      *
000984210908     C     KLCHSG        Klist
000985210908     C                   Kfld                    XXMACOD
000986210908     C     KLCHSG        Chain     XXACHOMDA                          9091
000987210908     C     *IN90         Ifeq      '1'
000988210908      * Record not found
000989210908     C                   Movel     'Y2U0009'     W0RTN             7
000990210908      * Send message '*Record no longer on file'
000991210908     C                   Movel     'Y2U0009'     ZAMSID
000992210908     C                   Movel     'Y2USRMSG'    ZAMSGF
000993210908     C                   Exsr      ZASNMS
000994210908     C                   Goto      SGEXIT
000995210908     C                   Endif
000996210908      * Record locked
000997210908     C     *IN91         Ifeq      '1'
000998210908     C                   Movel     'Y2U0004'     W0RTN             7
000999210908     C                   Goto      SGEXIT
001000210908     C                   End
001001210908      *
001002210908      * Check for changed record
001003210908     C     #1DBRC        Ifne      @1DBRC
001004210908     C                   Movel     'Y2U0007'     W0RTN             7
001005210908      * Send message '*Update not accepted'
001006210908     C                   Movel     'Y2U0007'     ZAMSID
001007210908     C                   Movel     'Y2USRMSG'    ZAMSGF
001008210908     C                   Exsr      ZASNMS
001009210908      * Release record lock
001010210908     C                   Unlock    XXACHOML1                            91
001011210908     C                   Goto      SGEXIT
001012210908     C                   Endif
001013210908      * Store record data for null update check
001014210908     C                   Move      @1DBRC        YBRDCS
001015210908      * Set PGM.*Record Data Changed flag
001016210908     C     @1DBRC        Ifne      YBRDCS
001017210908     C                   Move      'Y'           YBRDC
001018210908     C                   Endif
001019210908      * If changed update record otherwise release record
001020210908     C     YBRDC         Ifeq      'Y'
001021210908     C                   Update    XXACHOMDA                            91
001022210908     C                   Else
001023210908      * Release record lock
001024210908     C                   Unlock    XXACHOML1                            91
001025210908     C                   End
001026210908      * Change error detected
001027210908     C     *IN91         Ifeq      '1'
001028210908     C                   Movel     'Y2U0004'     W0RTN             7
001029210908     C                   Else
001030210908      * Update saved record image
001031210908     C                   Move      *Blanks       #1DBRC
001032210908     C                   Movel     @1DBRC        #1DBRC
001033210908      * DBF change successful
001034210908     C                   Endif
001035210908      *
001036210908     CSR   SGEXIT        Endsr
001037210908      /EJECT
001038210908
001039210908      *****************************************************************
001040210908      * Change Midas A/c Code
001041210908      *****************************************************************
001042210908     CSR   SHCHRC        Begsr
001043210908      *
001044210908     C                   Movel     *Blank        W0RTN             7
001045210908      * Set PGM.*Record Data Changed flag
001046210908     C                   Move      'N'           YCRDC             1
001047210908      * Move key fields to XXACHOMDA
001048210908     C                   Move      #1MDAC        XXMACOD
001049210908      *
001050210908     C     KLCHSH        Klist
001051210908     C                   Kfld                    XXMACOD
001052210908     C     KLCHSH        Chain     XXACHOMDA                          9091
001053210908     C     *IN90         Ifeq      '1'
001054210908      * Record not found
001055210908     C                   Movel     'Y2U0009'     W0RTN             7
001056210908      * Send message '*Record no longer on file'
001057210908     C                   Movel     'Y2U0009'     ZAMSID
001058210908     C                   Movel     'Y2USRMSG'    ZAMSGF
001059210908     C                   Exsr      ZASNMS
001060210908     C                   Goto      SHEXIT
001061210908     C                   Endif
001062210908      * Record locked
001063210908     C     *IN91         Ifeq      '1'
001064210908     C                   Movel     'Y2U0004'     W0RTN             7
001065210908     C                   Goto      SHEXIT
001066210908     C                   Endif
001067210908
001068210908      ** Check for changed record
001069210908     C     #1DBRC        Ifne      @1DBRC
001070210908     C                   Movel     'Y2U0007'     W0RTN             7
001071210908      * Send message '*Update not accepted'
001072210908     C                   Movel     'Y2U0007'     ZAMSID
001073210908     C                   Movel     'Y2USRMSG'    ZAMSGF
001074210908     C                   Exsr      ZASNMS
001075210908      * Release record lock
001076210908     C                   Unlock    XXACHOML1                            91
001077210908     C                   Goto      SHEXIT
001078210908     C                   Endif
001079210908      * Store record data for null update check
001080210908     C                   Move      @1DBRC        YCRDCS
001081210908      * Move non-key fields to XXACHOMTD
001082210908     C                   Movel     #1HOAC        XXMHOAC
001083210908     C                   Movel     #1HOPC        XXMHOPC
001084210908     C                   Movel     #1HOMC        XXMHOMC
001085210908     C                   Movel     #1EXCL        XXMEXCL
001086210908
001087210908      * Set PGM.*Record Data Changed flag
001088210908     C     @1DBRC        Ifne      YCRDCS
001089210908     C                   Move      'Y'           YCRDC
001090210908     C                   Endif
001091210908      * If changed update record otherwise release record
001092210908     C     YCRDC         Ifeq      'Y'
001093210908     C                   Update    XXACHOMDA                            91
001094210908     C                   Else
001095210908      * Release record lock
001096210908     C                   Unlock    XXACHOML1                            91
001097210908     C                   End
001098210908     C     *IN91         Ifeq      '1'
001099210908      * Change error detected
001100210908     C                   Movel     'Y2U0004'     W0RTN             7
001101210908     C                   Else
001102210908      *
001103210908      * Update saved record image
001104210908     C                   Move      *Blanks       #1DBRC
001105210908     C                   Movel     @1DBRC        #1DBRC
001106210908      * DBF change successful
001107210908     C                   Z-Add     *Zero         WUNORC
001108210908     C                   Z-Add     *Zero         WUNOIN
001109210908     C                   Z-Add     1             WUNOAM
001110210908     C                   Z-Add     *Zero         WUNODL
001111210908      *
001112210908     C                   Endif
001113210908      *
001114210908     CSR   SHEXIT        Endsr
001115210908      /EJECT
001116210908
001117210908      *****************************************************************
001118210908      ** Set up Detail Screen Header Title
001119210908      *****************************************************************
001120210908     CSR   UASUBR        Begsr
001121210908      * Setup message data for message
001122210908     C     WP0001        Ifeq      'E'
001123210908     C                   Movel     'DRI0512'     ZAMSID
001124210908     C                   Else
001125210908     C                   Movel     'DRI0513'     ZAMSID
001126210908     C                   Endif
001127210908      *
001128210908     C                   Movel     'XXUSRMSG'    ZAMSGF
001129210908     C                   Call      'Y2RVMGC'                            90
001130210908     C                   Parm      *Blank        W0RTN             7
001131210908     C                   Parm                    ZAMSID            7
001132210908     C                   Parm                    ZAMSGF           10
001133210908     C                   Parm                    ZAMSDA          132
001134210908     C     WUDFTL        Parm                    W0MTX           132
001135210908     C                   Movel     *Blank        ZAMSDA
001136210908     C                   Movel     *Blank        ZAMSGF
001137210908      * Move to Header Title - Standard Functions  *
001138210908     C                   Movel     WUDFTL        ##URPT
001139210908      *
001140210908     CSR   UAEXIT        Endsr
001141210908      /EJECT
001142210908
001143210908      *****************************************************************
001144210908      ** Set up Detail Screen Footer
001145210908      *****************************************************************
001146210908     CSR   UBSUBR        Begsr
001147210908      * Setup message data for message
001148210908     C                   Movel     ZADFMF        ZAMSGF
001149210908     C                   Call      'Y2RVMGC'                            90
001150210908     C                   Parm      *Blank        W0RTN             7
001151210908     C                   Parm      'USR2919'     ZAMSID            7
001152210908     C                   Parm                    ZAMSGF           10
001153210908     C                   Parm                    ZAMSDA          132
001154210908     C     WUSFT1        Parm                    W0MTX           132
001155210908     C                   Movel     *Blank        ZAMSDA
001156210908     C                   Movel     *Blank        ZAMSGF
001157210908      * Move to Single Footer - Standard Functions  *
001158210908     C                   Movel     WUSFT1        ##CTX1
001159210908      *
001160210908     CSR   UBEXIT        Endsr
001161210908      /EJECT
001162210908
001163210908      *****************************************************************
001164210908      * Set up Detail Screen Header Title
001165210908      *****************************************************************
001166210908     CSR   UCSUBR        Begsr
001167210908      * Setup message data for message
001168210908     C     WP0001        Ifeq      'E'
001169210908     C                   Movel     'DRI0512'     ZAMSID
001170210908     C                   Else
001171210908     C                   Movel     'DRI0513'     ZAMSID
001172210908     C                   Endif
001173210908      *
001174210908     C                   Movel     'XXUSRMSG'    ZAMSGF
001175210908     C                   Call      'Y2RVMGC'                            90
001176210908     C                   Parm      *Blank        W0RTN             7
001177210908     C                   Parm                    ZAMSID            7
001178210908     C                   Parm                    ZAMSGF           10
001179210908     C                   Parm                    ZAMSDA          132
001180210908     C     WUDFTL        Parm                    W0MTX           132
001181210908     C                   Movel     *Blank        ZAMSDA
001182210908     C                   Movel     *Blank        ZAMSGF
001183210908      * Move to Header Title - Standard Functions  *
001184210908     C                   Movel     WUDFTL        ##URPT
001185210908      *
001186210908     CSR   UCEXIT        Endsr
001187210908      /EJECT
001188210908
001189210908      *****************************************************************
001190210908      ** Set up Detail Screen Footer
001191210908      *****************************************************************
001192210908     CSR   UDSUBR        Begsr
001193210908      * Amend or Enquiry mode
001194210908     C     P2ANCD        Ifeq      'E'
001195210908     C     P2ANCD        OREQ      'A'
001196210908      * Setup message data for message
001197210908     C                   Movel     ZADFMF        ZAMSGF
001198210908     C                   Call      'Y2RVMGC'                            90
001199210908     C                   Parm      *Blank        W0RTN             7
001200210908     C                   Parm      'USR2920'     ZAMSID            7
001201210908     C                   Parm                    ZAMSGF           10
001202210908     C                   Parm                    ZAMSDA          132
001203210908     C     WUSFT1        Parm                    W0MTX           132
001204210908     C                   Movel     *Blank        ZAMSDA
001205210908     C                   Movel     *Blank        ZAMSGF
001206210908     C                   Endif
001207210908      * Delete mode
001208210908     C     P2ANCD        Ifeq      'D'
001209210908      * Setup message data for message
001210210908     C                   Movel     ZADFMF        ZAMSGF
001211210908     C                   Call      'Y2RVMGC'                            90
001212210908     C                   Parm      *Blank        W0RTN             7
001213210908     C                   Parm      'USR2921'     ZAMSID            7
001214210908     C                   Parm                    ZAMSGF           10
001215210908     C                   Parm                    ZAMSDA          132
001216210908     C     WUSFT1        Parm                    W0MTX           132
001217210908     C                   Movel     *Blank        ZAMSDA
001218210908     C                   Movel     *Blank        ZAMSGF
001219210908     C                   Endif
001220210908      * Move to Single Footer - Standard Functions  *
001221210908     C                   Movel     WUSFT1        ##CTX1
001222210908      *
001223210908     CSR   UDEXIT        Endsr
001224210908      /EJECT
001225210908
001226210908      *****************************************************************
001227210908      ** Set up Key Screen Header Title
001228210908      *****************************************************************
001229210908     CSR   UFSUBR        Begsr
001230210908      * Setup message data for message
001231210908     C                   Movel     'XXUSRMSG'    ZAMSGF
001232210908     C                   Call      'Y2RVMGC'                            90
001233210908     C                   Parm      *Blank        W0RTN             7
001234210908     C                   Parm      'DRI0516'     ZAMSID            7
001235210908     C                   Parm                    ZAMSGF           10
001236210908     C                   Parm                    ZAMSDA          132
001237210908     C     WUDFTL        Parm                    W0MTX           132
001238210908     C                   Movel     *Blank        ZAMSDA
001239210908     C                   Movel     *Blank        ZAMSGF
001240210908      * Move to Header Title - Standard Functions  *
001241210908     C                   Movel     WUDFTL        ##URPT
001242210908      *
001243210908     CSR   UFEXIT        Endsr
001244210908      /EJECT
001245210908
001246210908      *****************************************************************
001247210908      ** Set up Key Screen Footer
001248210908      *****************************************************************
001249210908     CSR   UGSUBR        Begsr
001250210908      * Setup message data for message
001251210908     C                   Movel     ZADFMF        ZAMSGF
001252210908     C                   Call      'Y2RVMGC'                            90
001253210908     C                   Parm      *Blank        W0RTN             7
001254210908     C                   Parm      'USR2918'     ZAMSID            7
001255210908     C                   Parm                    ZAMSGF           10
001256210908     C                   Parm                    ZAMSDA          132
001257210908     C     WUSFT1        Parm                    W0MTX           132
001258210908     C                   Movel     *Blank        ZAMSDA
001259210908     C                   Movel     *Blank        ZAMSGF
001260210908      * Move to Single Footer - Standard Functions  *
001261210908     C                   Movel     WUSFT1        ##CTX1
001262210908      *
001263210908     CSR   UGEXIT        Endsr
001264210908      /EJECT
001265210908
001266210908      *****************************************************************
001267210908      ** Set up Key Screen Header Title
001268210908      *****************************************************************
001269210908     CSR   UHSUBR        Begsr
001270210908      * Setup message data for message
001271210908     C                   Movel     'XXUSRMSG'    ZAMSGF
001272210908     C                   Call      'Y2RVMGC'                            90
001273210908     C                   Parm      *Blank        W0RTN             7
001274210908     C                   Parm      'DRI0516'     ZAMSID            7
001275210908     C                   Parm                    ZAMSGF           10
001276210908     C                   Parm                    ZAMSDA          132
001277210908     C     WUDFTL        Parm                    W0MTX           132
001278210908     C                   Movel     *Blank        ZAMSDA
001279210908     C                   Movel     *Blank        ZAMSGF
001280210908      * Move to Header Title - Standard Functions  *
001281210908     C                   Movel     WUDFTL        ##URPT
001282210908      *
001283210908     CSR   UHEXIT        Endsr
001284210908      /EJECT
001285210908
001286210908      *****************************************************************
001287210908      ** Set up Key Screen Footer
001288210908      *****************************************************************
001289210908     CSR   UISUBR        Begsr
001290210908      * Setup message data for message
001291210908     C                   Movel     ZADFMF        ZAMSGF
001292210908     C                   Call      'Y2RVMGC'                            90
001293210908     C                   Parm      *Blank        W0RTN             7
001294210908     C                   Parm      'USR2918'     ZAMSID            7
001295210908     C                   Parm                    ZAMSGF           10
001296210908     C                   Parm                    ZAMSDA          132
001297210908     C     WUSFT1        Parm                    W0MTX           132
001298210908     C                   Movel     *Blank        ZAMSDA
001299210908     C                   Movel     *Blank        ZAMSGF
001300210908      * Move to Single Footer - Standard Functions  *
001301210908     C                   Movel     WUSFT1        ##CTX1
001302210908      *
001303210908     CSR   UIEXIT        Endsr
001304210908      /EJECT
001305210908
001306210908      *****************************************************************
001307210908      ** Send message to program's message queue
001308210908      *****************************************************************
001309210908     CSR   ZASNMS        Begsr
001310210908     C     ZAPGMQ        Ifeq      *Blank
001311210908     C                   Movel     ##PGM         ZAPGMQ
001312210908     C                   Endif
001313210908      * If no message file specified, use default
001314210908     C     ZAMSGF        Ifeq      *Blank
001315210908     C                   Movel     ZADFMF        ZAMSGF
001316210908     C                   Endif
001317210908     C                   Call      'Y2SNMGC'
001318210908     C                   Parm                    ZAPGMQ           10
001319210908     C                   Parm                    ZAPGRL            5
001320210908     C                   Parm                    ZAMSID            7
001321210908     C                   Parm                    ZAMSGF           10
001322210908     C                   Parm                    ZAMSDA          132
001323210908     C                   Parm                    ZAMSTP            7
001324210908      * Clear all fields for default mechanism next Time
001325210908     C                   Movel     *Blank        ZAPGMQ
001326210908     C                   Movel     *Blank        ZAPGRL
001327210908     C                   Movel     *Blank        ZAMSID
001328210908     C                   Movel     *Blank        ZAMSGF
001329210908     C                   Movel     *Blank        ZAMSDA
001330210908     C                   Movel     *Blank        ZAMSTP
001331210908      *
001332210908     CSR   ZAEXIT        Endsr
001333210908      /EJECT
001334210908
001335210908      *****************************************************************
001336210908      ** Cancel and exit from key screen
001337210908      *****************************************************************
001338210908     CSR   ZXEXPG        Begsr
001339210908      * USER: Exit program processing
001340210908      * Case: KEY.*CMD key is *Exit
001341210908     C     *IN03         Ifeq      '1'
001342210908     C                   Movel     'Y2U9999'     P0RTN
001343210908     C                   Exsr      ZYEXPG
001344210908     C                   Endif
001345210908     C*
001346210908     C                   Movel     *Blank        P0RTN
001347210908     C                   Exsr      ZYEXPG
001348210908      *
001349210908     CSR   ZXEXIT        Endsr
001350210908      /EJECT
001351210908
001352210908      *****************************************************************
001353210908      ** Exit program: Direct
001354210908      *****************************************************************
001355210908     CSR   ZYEXPG        Begsr
001356210908      * ROLLBACK any uncommitted DBF changes
001357210908     C                   Rolbk                                          90
001358210908      *
001359210908      * Exit program
001360210908     C                   Return
001361210908      *
001362210908      *
001363210908     CSR   ZYEXIT        Endsr
001364210908      /EJECT
001365210908
001366210908      *****************************************************************
001367210908      ** Initialisation
001368210908      *****************************************************************
001369210908     CSR   ZZINIT        Begsr
001370210908      *
001371210908     C                   Move      *Blank        P0RTN
001372210908     C                   Move      *Blank        W0RTN             7
001373210908      * Initialise indicators for re-Entry
001374210908     C                   Move      '0'           *IN
001375210908      * Update screen Time
001376210908     C                   Time                    ##TME             6 0
001377210908      * Define work field Display File Title
001378210908     C                   Movel     *Blank        WUDFTL           53
001379210908      * Obtain default message file
001380210908     C     *Dtaara       Define    Y2MGFLA       ZADFMF           10
001381210908     C                   In        ZADFMF
001382210908      * Define work field STD FTR 1
001383210908     C                   Movel     *Blank        WUSFT1           78
001384210908      * Define work field Midas Run Date
001385210908     C                   Movel     *Blank        WUMRDT            7
001386210908      * Define work field Run day number
001387210908     C                   Z-Add     *Zero         WURDNB            5 0
001388210908      * Define work field No. of Records
001389210908     C                   Z-Add     *Zero         WUNORC            5 0
001390210908      * Define work field No. of Inserts
001391210908     C                   Z-Add     *Zero         WUNOIN            5 0
001392210908      * Define work field No. of Amends
001393210908     C                   Z-Add     *Zero         WUNOAM            5 0
001394210908      * Define work field No. of Deletes
001395210908     C                   Z-Add     *Zero         WUNODL            5 0
001396210908      * Define work field Output field indicator
001397210908     C                   Movel     *Blank        WUOFIN            1
001398210908      * Define work field Set Up Complete
001399210908     C                   Movel     *Blank        WUSUC             1
001400210908      * Define work field Date format flag
001401210908     C                   Movel     *Blank        WUDFF             1
001402210908      * Define work field Multi-branching Indicator
001403210908     C                   Movel     *Blank        WUMBIN            1
001404210908      * Define work field Customer
001405210908     C                   Movel     *Blank        #WCUST            6
001406210908
001407210908      ** Open files first Time only
001408210908     C     W0OPN         Ifeq      *Blank
001409210908      * Begin Commit control
001410210908     C                   Call      'Y2BGCMC'
001411210908     C                   Parm                    W0RTN             7
001412210908     C     W0RTN         Ifne      *Blank
001413210908     C     W0RTN         Andne     'CPF8351'
001414210908     C                   Exsr      ZYEXPG
001415210908     C                   Endif
001416210908      *
001417210908     C                   Open      XX005002DF
001418210908     C                   Open      XXACHOML0
001419210908     C                   Open      XXACHOML1
001420210908
001421210908      * Signal that files are now Open
001422210908     C                   Move      'Y'           W0OPN             1
001423210908     C                   Endif
001424210908      *
001425210908     C                   Movel     'N'           W0PMT             1
001426210908
001427210908      ** Select initial mode
001428210908     C     @1NROP        Ifeq      *Zero
001429210908      * Add mode
001430210908     C                   Movel     'ADD'         W0PMD             3
001431210908     C                   Else
001432210908      * Change mode
001433210908     C                   Movel     'CHG'         W0PMD
001434210908     C                   Endif
001435210908
001436210908      ** Copyright Statement and Rundate setup
001437210908     C     *Dtaara       Define                  RUNDAT
001438210908     C                   In        RUNDAT
001439210908     C                   Move      MRDT          ##MRDT            7
001440210908     C                   Move      MRDT          WUMRDT
001441210908     C                   Move      RDNB          WURDNB
001442210908     C                   Move      SUC           WUSUC
001443210908     C                   Move      DFF           WUDFF
001444210908     C                   Move      MBIN          WUMBIN
001445210908
001446210908      ** Action Enquire or Delete
001447210908     C     P2ANCD        Ifeq      'E'
001448210908     C     P2ANCD        Oreq      'D'
001449210908     C                   Movel     'Y'           WUOFIN
001450210908     C                   Endif
001451210908      *
001452210908     CSR   ZZEXIT        Endsr
001453210908      /EJECT
001454210908
001455210908      *****************************************************************
001456210908      *                                                               *
001457210908      * *PSSR  - Program exception error routine                      *
001458210908      *          Called automatiCally if a program error occurs,      *
001459210908      *          or directly by the program code using EXSR.          *
001460210908      *          This subroutine DUMPs the program just once.         *
001461210908      *                                                               *
001462210908      *****************************************************************
001463210908     CSR   *PSSR         Begsr
001464210908
001465210908      ** Standard Midas PSSR processing.
001466210908     C     @RUN          Ifeq      *Blank
001467210908     C                   Move      'Y'           @RUN              1
001468210908     C                   Move      'PSSR   '     P0RTN
001469210908     C                   Dump
001470210908
001471210908      ** Route job back into Midas.
001472210908     C                   Seton                                        LR
001473210908     C                   Call      'DBERRCTL'
001474210908     C                   End
001475210908      *
001476210908     CSR                 Endsr
001477210908      *****************************************************************
001478210908** VLD
0014792109080123456789
