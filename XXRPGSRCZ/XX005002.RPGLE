000100210907                           H DEBUG DATEDIT(*YMD)
000101210907      *****************************************************************
000102210907/*STD *  RPGBASEBND                                                   *
000103210907/*EXI *  TEXT('Midas XX Account Codes Mapping to HO Details')         *
000104210907      *****************************************************************
000105210907      *                                                               *
000106210907      *  Midas - General Ledger Module                                *
000107210907      *                                                               *
000108210907      *  XX005002 - Midas XX Account Codes Mapping to HO Details      *
000109210907      *               Enquiry screen                                  *
000110210907      *                                                               *
000111210907      *  Function:  This program will maintain the mapping between    *
000112210907      *             the Midas Account Codes and HO Details            *
000113210907      *                                                               *
000114210907      *  (C) Finastra International Limited 2021                      *
000115210907      *                                                               *
000116210907      *  Last Amend No. DRI005  *CREATE    Date 13Apr21               *
000117210907      *                                                               *
000118210907      *---------------------------------------------------------------*
000119210907      *                                                               *
000120210907      *  DRI005 - HO and EDW Extracts                                 *
000121210907      *                                                               *
000122210907      *****************************************************************
000123210907      *
000124210907      ** Midas A/c Codes Mapping to HO Details screen
000125210907     FXX005002DFCF   E             Workstn Usropn
000126210907     F                                     Infds(Infds#)
000127210907     F                                     Infsr(*PSSR)
000128210907
000129210907      ** Midas A/c Codes Mapping to HO Details - Rtv
000130210907     FXXACHOML0 IF   E           K DISK    Usropn
000131210907     F                                     Infds(Infds1)
000132210907     F                                     Infsr(*PSSR)
000133210907     F                                     Rename(XXACHOMD0:XXACHOMDB)
000134210907
000135210907      ** Midas A/c Codes Mapping to HO Details - Upd
000136210907     FXXACHOML1 UF A E           K DISK    Usropn
000137210907     F                                     Commit
000138210907     F                                     Infds(ID0001)
000139210907     F                                     Infsr(*PSSR)
000140210907     F                                     Rename(XXACHOMD0:XXACHOMDA)
000141210907      /EJECT
000142210907
000143210907      *****************************************************************
000144210907      ** +-------------------------------+
000145210907      ** ¦ Data structures specification |
000146210907      ** +-------------------------------+
000147210907      *
000148210907      * Pgm Data srtucture
000149210907     D PGMDS         ESDs                  Extname(Y2PGDSP)
000150210907
000151210907      ** Display file information data structure
000152210907     D Infds#        E Ds                  Extname(Y2I#DSP)
000153210907
000154210907      ** File information data structure
000155210907     D Infds1        E Ds                  Extname(Y2I1DSP)
000156210907
000157210907      ** HO Details Mapping
000158210907     D @1DBRC        E Ds                  Extname(XXACHOML0)
000159210907
000160210907      ** Long DS for access programs
000161210907     D DSSDY         E Ds                  Extname(DSSDY)
000162210907
000163210907      ** Stored master file format fields
000164210907     D #1DBRC          Ds            23
000165210907     D  #1DB1                  1     10S 0
000166210907     D  #1DB2                 11     15
000167210907     D  #1DB3                 16     19
000168210907     D  #1DB4                 20     22
000169210907     D  #1DB5                 23     23
000170210907
000171210907      ** Standing data controls update
000172210907     D YBRDCS          Ds            23
000173210907     D YCRDCS          Ds            23
000174210907
000175210907      ** Validation Array for valid Midas A/c Code
000176210907     D VLD             S              1A   DIM(10) PERRCD(10) CTDATA
000177210907
000178210907      ** Index for looping through the Midas A/c Code
000179210907     D WIdx1           S              2S 0
000180210907
000181210907      ** Midas A/c Code
000182210907     D MidAccod        S              1A   DIM(10)
000183210907
000184210907      ** Run date
000185210907     D RUNDAT          Ds
000186210907     D  MRDT                   1      7
000187210907     D  RDNB                   8     10P 0
000188210907     D  SUC                   11     11
000189210907     D  DFF                   12     12
000190210907     D  MBIN                  13     13
000191210907
000192210907      ** File information data structure
000193210907     D ID0001          Ds           528
000194210907
000195210907      ** File information data structure
000196210907     D ID0002          Ds           528
000197210907
000198210907     D P1Parm          Ds            23
000199210907     D  P1MDAC                 1     10
000200210907     D  P1HOAC                11     15
000201210907     D  P1HOPC                16     19
000202210907     D  P1HOMC                20     22
000203210907     D  P1EXCL                23     23
000204210907
000205210907      ** MAP Action Code
000206210907     D P2Parm          Ds
000207210907     D  P2ANCD                 1      1
000208210907
000209210907     D                 Ds
000210210907     D  ZAMSDA                 1    132
000211210907     D  ZA0001                 1      3
000212210907     D  ZA0002                 1      6
000213210907
000214210907      ** Renamed input format fields
000215210907     IXXACHOMDB
000216210907     I              XXMACOD                     WACODE
000217210907      /EJECT
000218210907
000219210907      *****************************************************************
000220210907      ** Entry parameters
000221210907      *****************************************************************
000222210907      *
000223210907     C     *Entry        Plist
000224210907     C                   Parm                    P0RTN             7
000225210907     C                   Parm                    P1Parm
000226210907     C     P2ANCD        Parm                    WP0001            1
000227210907      * Initialize
000228210907     C                   Exsr      ZZINIT
000229210907      *
000230210907      * Check passed parameters
000231210907     C                   Exsr      FACKPM
000232210907      * Perform once if all passed, Else repeat
000233210907     C     W0RPT         Doueq     'N'
000234210907      * Display and process key screen
000235210907     C                   Exsr      BADSKY
000236210907     C                   Enddo
000237210907      * Terminate program
000238210907     C                   Exsr      ZXEXPG
000239210907      *
000240210907      /EJECT
000241210907
000242210907      *****************************************************************
000243210907      ** Display and process key screen
000244210907      *****************************************************************
000245210907     CSR   BADSKY        Begsr
000246210907
000247210907      ** Initialize key screen
000248210907     C                   Exsr      MDIZ#K
000249210907
000250210907      ** Bypass first display of key screen is possible
000251210907     C                   Movel     'Y'           W0BYP             1
000252210907      * Signal start of transaction
000253210907     C                   Movel     'Y'           W0TRN             1
000254210907     C     W0TRN         Doweq     'Y'
000255210907     C     W0TRN         Oreq      'K'
000256210907      * Ensure transaction continues (if reset)
000257210907     C                   Movel     'Y'           W0TRN             1
000258210907      * Conduct screen conversation
000259210907     C     W0TRN         Doweq     'Y'
000260210907      * Is bypass key screen still viable?
000261210907     C     W0BYP         Ifeq      'Y'
000262210907     C     #1MDAC        Ifeq      *Blanks
000263210907      * One or more key fields is Blank
000264210907     C     *IN05         Oreq      '1'
000265210907      * HOME: Reset screen fields
000266210907     C                   Movel     'N'           W0BYP
000267210907     C                   Endif
000268210907     C                   Endif
000269210907
000270210907      ** Bypass key screen
000271210907     C     W0BYP         Ifne      'Y'
000272210907      * Display key screen
000273210907     C                   Exsr      BBEXFM
000274210907     C                   Endif
000275210907
000276210907      ** Cancel key screen bypass
000277210907     C                   Movel     'N'           W0BYP
000278210907
000279210907      ** Process response to key screen
000280210907      ** Cancel & exit program
000281210907     C   03              Cas                     ZXEXPG
000282210907
000283210907      ** Switch between *ADD/*CHANGE modes
000284210907     C   09              Cas                     BCCHMD
000285210907
000286210907      ** HOME: Reset screen fields
000287210907     C   05              Cas                     BDHMKY
000288210907
000289210907      ** Process key screen input
000290210907     C                   Cas                     BEPRKY
000291210907     C                   End
000292210907      *
000293210907     C     W0TRN         Doweq     'R'
000294210907     C                   Movel     'Y'           W0TRN
000295210907     C                   Exsr      BEPRKY
000296210907     C                   Enddo
000297210907      *
000298210907     C                   Enddo
000299210907     C                   Enddo
000300210907      *
000301210907     CSR   BAEXIT        Endsr
000302210907      /EJECT
000303210907
000304210907      *****************************************************************
000305210907      * Display key screen
000306210907      *****************************************************************
000307210907     CSR   BBEXFM        Begsr
000308210907
000309210907      **Set screen conditioning indicators
000310210907     C                   Exsr      GADSAK
000311210907      * Update screen Time
000312210907     C                   Time                    ##TME
000313210907     C     W0HLP         Doueq     'N'
000314210907     C                   Movel     'N'           W0HLP             1
000315210907     C                   Move      *ALL'0'       ##OFF            30
000316210907     C                   MoveA     ##OFF         *IN(1)
000317210907
000318210907      ** PUTOVR unless conditioned fields change
000319210907     C                   Seton                                            86
000320210907     C     *IN89         Ifne      BBIN89
000321210907     C                   Setoff                                           86
000322210907     C                   Endif
000323210907     C                   Move      *IN89         BBIN89            1
000324210907
000325210907      ** Display Prompt 1
000326210907     C                   Write     #MSGCTL
000327210907     C                   Write     #CMDTXT1
000328210907     C                   Exfmt     #RCDKEY
000329210907      *
000330210907     C                   Enddo
000331210907      * Clear messages from program message queue
000332210907     C                   Call      'Y2CLMSC'
000333210907     C                   Parm      ##PGM         ZAPGMQ           10
000334210907     C                   Parm      '*SAME'       ZAPGRL            5
000335210907      * Reset first message only flag
000336210907     C                   Movel     'Y'           ZAFSMS            1
000337210907      * Reset global error indicator
000338210907     C                   Setoff                                           99
000339210907      *
000340210907     CSR   BBEXIT        Endsr
000341210907      /EJECT
000342210907
000343210907      *****************************************************************
000344210907      ** Switch between *ADD/*CHANGE modes
000345210907      *****************************************************************
000346210907     CSR   BCCHMD        Begsr
000347210907      *
000348210907     C     W0PMD         Ifeq      'ADD'
000349210907     C                   Movel     'CHG'         W0PMD             3
000350210907     C                   Else
000351210907     C                   Movel     'ADD'         W0PMD
000352210907      *
000353210907     C                   End
000354210907      *
000355210907     CSR   BCEXIT        Endsr
000356210907      /EJECT
000357210907
000358210907      *****************************************************************
000359210907      ** Process HOME key
000360210907      *****************************************************************
000361210907     CSR   BDHMKY        Begsr
000362210907      *
000363210907     C                   Movel     'N'           W0TRN
000364210907      *
000365210907     CSR   BDEXIT        Endsr
000366210907      /EJECT
000367210907
000368210907      *****************************************************************
000369210907      ** Process key screen input
000370210907      *****************************************************************
000371210907     CSR   BEPRKY        Begsr
000372210907
000373210907      ** Initialise detail screen
000374210907     C                   Exsr      MAIZ#1
000375210907
000376210907      ** Validate key fields
000377210907     C                   Exsr      BFVLKY
000378210907     C     *IN99         CabEq     '1'           BEEXIT
000379210907
000380210907      ** Check for existing record
000381210907     C     KRTV          Klist
000382210907     C                   Kfld                    XXMACOD
000383210907      * Setup key
000384210907     C                   Move      #1MDAC        XXMACOD
000385210907     C     KRTV          Chain     XXACHOMDB                          9091
000386210907     C     *IN91         Ifeq      '1'
000387210907      * Record locked
000388210907     C                   Seton                                        9931
000389210907     C                   Goto      BEEXIT
000390210907     C                   Endif
000391210907
000392210907      ** If record does not exist, flip to add mode
000393210907     C     *IN90         Ifeq      '1'
000394210907     C                   Movel     'ADD'         W0PMD
000395210907      * Set up Detail Screen Header Title
000396210907     C                   Exsr      UASUBR
000397210907      * Set up Detail Screen Footer
000398210907     C                   Exsr      UBSUBR
000399210907      *
000400210907     C                   Else
000401210907      * If record does exist, flip to change mode
000402210907     C                   Movel     'CHG'         W0PMD
000403210907      * Load screen fields from DBF
000404210907     C                   Exsr      MBFL#1
000405210907      * Set up Detail Screen Header Title
000406210907     C                   Exsr      UCSUBR
000407210907      * Set up Detail Screen Footer
000408210907     C                   Exsr      UDSUBR
000409210907     C*
000410210907     C                   Endif
000411210907      *
000412210907     C   99              Goto      BEEXIT
000413210907
000414210907      ** No error: Display and process details
000415210907     C                   Exsr      CADSDA
000416210907      *
000417210907     CSR   BEEXIT        Endsr
000418210907      /EJECT
000419210907
000420210907      *****************************************************************
000421210907      * Validate key fields
000422210907      *****************************************************************
000423210907     CSR   BFVLKY        Begsr
000424210907
000425210907      ** Validate entries
000426210907     C                   If        P2ANCD = 'I'
000427210907     C                   Setoff                                       9931
000428210907
000429210907      ** Midas A/c Code validation
000430210907      * Midas A/c code should consist of 4 digits
000431210907     C                   MoveA     #1MDAC        MidAccod
000432210907
000433210907     C                   For       WIdx1 = 1 TO 10
000434210907     C                   If        %LookUp(MidAccod(WIdx1):VLD) = 0
000435210907     C                   Seton                                        99
000436210907     C                   Seton                                        31
000437210907     C                   Movel     'DRI0511'     ZAMSID
000438210907     C                   Movel     'XXUSRMSG'    ZAMSGF
000439210907     C                   Exsr      ZASNMS
000440210907     C                   Goto      BFEXIT
000441210907     C                   Endif
000442210907     C                   EndFor
000443210907     C                   If        *IN31 = *Off
000444210907
000445210907      ** Check for existing record
000446210907     C                   Move      #1MDAC        XXMACOD
000447210907     C     KRTV          Chain     XXACHOMDB                          90
000448210907     C                   If        *IN90 = *off
000449210907      * Duplicate Midas A/c Code entered
000450210907     C                   Seton                                        99
000451210907     C                   Seton                                        31
000452210907     C                   Movel     'DRI0514'     ZAMSID
000453210907     C                   Movel     'XXUSRMSG'    ZAMSGF
000454210907     C                   Exsr      ZASNMS
000455210907     C                   Endif
000456210907      *
000457210907     C                   Endif
000458210907      *
000459210907     C                   Endif
000460210907      *
000461210907     CSR   BFEXIT        Endsr
000462210907      /EJECT
000463210907
000464210907      *****************************************************************
000465210907      ** Display and process detail screen
000466210907      *****************************************************************
000467210907     CSR   CADSDA        Begsr
000468210907
000469210907      ** Repeat until screen control flag is reset:
000470210907     C     W0TRN         DOWEQ     'Y'
000471210907      * Display detail screen
000472210907     C                   Exsr      CBEXFM
000473210907      * Process response to detail screen
000474210907      * Cancel & exit program
000475210907     C   03              Cas                     ZXEXPG
000476210907      * Redisplay previous screen
000477210907     C   12              Cas                     CCDSPV
000478210907      * HOME: Reset screen fields
000479210907     C   05              Cas                     CCDSPV
000480210907      * Process detail screen input
000481210907     C                   Cas                     CFPRSC
000482210907     C                   End
000483210907      *
000484210907     C     W0TRN         Ifeq      'R'
000485210907     C     W0PMD         Ifeq      'ADD'
000486210907     C                   Exsr      MAIZ#1
000487210907     C                   Endif
000488210907     C                   Endif
000489210907      *
000490210907     C                   Enddo
000491210907      *
000492210907     CSR   CAEXIT        Endsr
000493210907      /EJECT
000494210907
000495210907      *****************************************************************
000496210907      ** Display screen
000497210907      *****************************************************************
000498210907     CSR   CBEXFM        Begsr
000499210907
000500210907      ** Set screen conditioning indicators
000501210907     C                   Exsr      GBDSAD
000502210907
000503210907      ** Update screen Time
000504210907     C                   Time                    ##TME
000505210907     C     W0HLP         Doueq     'N'
000506210907     C                   Movel     'N'           W0HLP             1
000507210907     C                   Move      *ALL'0'       ##OFF            30
000508210907     C                   MoveA     ##OFF         *IN(1)
000509210907
000510210907      ** PUTOVR unless conditioned fields change
000511210907     C                   Seton                                            86
000512210907     C     *IN89         Ifne      CBIN89
000513210907     C                   Setoff                                           86
000514210907     C                   Endif
000515210907     C                   Move      *IN89         CBIN89            1
000516210907      *
000517210907     C                   Write     #MSGCTL
000518210907     C                   Write     #CMDTXT2
000519210907     C                   Exfmt     #RCDDTL1
000520210907
000521210907     C                   Enddo
000522210907      * Clear messages from program message queue
000523210907     C                   Call      'Y2CLMSC'
000524210907     C                   Parm      ##PGM         ZAPGMQ           10
000525210907     C                   Parm      '*SAME'       ZAPGRL            5
000526210907      * Reset first message only flag
000527210907     C                   Movel     'Y'           ZAFSMS            1
000528210907      * Reset global error indicator
000529210907     C                   Setoff                                           99
000530210907      *
000531210907     CSR   CBEXIT        Endsr
000532210907      /EJECT
000533210907
000534210907      *****************************************************************
000535210907      ** Redisplay previous screen
000536210907      *****************************************************************
000537210907     CSR   CCDSPV        Begsr
000538210907
000539210907      ** Case: PAR.Action Code is Insert
000540210907     C     P2ANCD        Ifeq      'I'
000541210907      * Set up Key Screen Header Title
000542210907     C                   Exsr      UFSUBR
000543210907      * Set up Key Screen Footer
000544210907     C                   Exsr      UGSUBR
000545210907     C                   Else
000546210907      * Case: *Otherwise
000547210907     C                   Movel     'USR0790'     P0RTN
000548210907     C                   Exsr      ZYEXPG
000549210907     C                   Endif
000550210907      *
000551210907     C   05              Movel     'R'           W0TRN
000552210907     C   12              Movel     'K'           W0TRN
000553210907      *
000554210907     CSR   CCEXIT        Endsr
000555210907      /EJECT
000556210907
000557210907      *================================================================
000558210907      * Validate record
000559210907      *================================================================
000560210907     CSR   CFPRSC        Begsr
000561210907
000562210907      ** Confirm/update is not deferred
000563210907     C                   Movel     'N'           W0DCF             1
000564210907      * Validate details
000565210907     C  N10              Cas                     DCVLDL
000566210907     C                   End
000567210907      * QUIT if error:
000568210907     C   99              Goto      CFEXIT
000569210907      * Redisplay if change of customer entry.
000570210907     C   98              Goto      CFEXIT
000571210907      * Defer confirm/update requested
000572210907     C     W0DCF         CabEq     'Y'           CFEXIT
000573210907
000574210907      ** No error: update record
000575210907     C                   Exsr      EBPR##
000576210907      *
000577210907     CSR   CFEXIT        Endsr
000578210907      /EJECT
000579210907
000580210907      *****************************************************************
000581210907      ** Validate details
000582210907      *****************************************************************
000583210907     CSR   DCVLDL        Begsr
000584210907
000585210907      ** USER: Validate detail screen relations
000586210907     C                   Setoff                                       98
000587210907      *
000588210907     C     WP0001        Ifne      'E'
000589210907     C     W0PMD         Ifeq      'ADD'
000590210907     C     W0PMD         Oreq      'CHG'
000591210907      *
000592210907     C                   Setoff                                       993141
000593210907     C                   Setoff                                       424344
000594210907
000595210907      ** Check if record exists - Midas A/c Code
000596210907     C     W0PMD         Ifeq      'ADD'
000597210907     C                   Exsr      SDRVGN
000598210907
000599210907      ** Case: PGM.*Return code is *Record already exists
000600210907     C     W0RTN         Ifeq      'Y2U0003'
000601210907      * Setup message data for message
000602210907     C                   Movel     #1HOAC        ZA0001
000603210907      * Send message 'Midas A/c Code must be unique'
000604210907     C                   Movel     'DRI0505'     ZAMSID
000605210907     C                   Movel     'XXUSRMSG'    ZAMSGF
000606210907     C                   Exsr      ZASNMS
000607210907     C                   Seton                                        9941
000608210907     C                   Goto      DCEXIT
000609210907     C                   Endif
000610210907     C                   Endif
000611210907
000612210907      ** Case: *Otherwise
000613210907     C                   If        #1HOAC = *Blanks
000614210907      * HO A/c Code must be entered
000615210907     C                   Seton                                        9942
000616210907     C                   Movel     'DRI0506'     ZAMSID
000617210907     C                   Movel     'XXUSRMSG'    ZAMSGF
000618210907     C                   Exsr      ZASNMS
000619210907     C                   Endif
000620210907      *
000621210907     C                   If        #1HOPC = *Blanks
000622210907      * HO Product Code must be entered
000623210907     C                   Seton                                        9943
000624210907     C                   Movel     'DRI0507'     ZAMSID
000625210907     C                   Movel     'XXUSRMSG'    ZAMSGF
000626210907     C                   Exsr      ZASNMS
000627210907     C                   Endif
000628210907      *
000629210907     C                   If        #1HOMC = *Blanks
000630210907      * HO Market Code must be entered
000631210907     C                   Seton                                        9944
000632210907     C                   Movel     'DRI0508'     ZAMSID
000633210907     C                   Movel     'XXUSRMSG'    ZAMSGF
000634210907     C                   Exsr      ZASNMS
000635210907     C                   Endif
000636210907      *
000637210907     C                   If        #1EXCL = *Blanks
000638210907      * Exclude flag must be entered
000639210907     C                   Seton                                        9945
000640210907     C                   Movel     'DRI0509'     ZAMSID
000641210907     C                   Movel     'XXUSRMSG'    ZAMSGF
000642210907     C                   Exsr      ZASNMS
000643210907     C                   Else
000644210907     C                   If        #1EXCL <> 'Y' and #1EXCL <> 'N'
000645210907      * Exclude flag must be 'Y' or 'N'
000646210907     C                   Seton                                        9945
000647210907     C                   Movel     'DRI0510'     ZAMSID
000648210907     C                   Movel     'XXUSRMSG'    ZAMSGF
000649210907     C                   Exsr      ZASNMS
000650210907     C                   Endif
000651210907     C                   Endif
000652210907      *
000653210907     C                   Endif
000654210907     C                   Endif
000655210907      *
000656210907     CSR   DCEXIT        Endsr
000657210907      /EJECT
000658210907
000659210907      *****************************************************************
000660210907      ** Process record:
000661210907      *****************************************************************
000662210907     CSR   EBPR##        Begsr
000663210907
000664210907      ** Process delete request
000665210907     C   10              Cas                     EDDLRQ
000666210907
000667210907      ** Process add request
000668210907     C     W0PMD         CaseQ     'ADD'         ECADRQ
000669210907
000670210907      ** Process update request
000671210907     C     W0PMD         CasNE     'ADD'         EECHRQ
000672210907     C                   End
000673210907
000674210907      ** Error: ROLLBACK any DBF changes
000675210907     C     W0RTN         Ifne      *Blank
000676210907     C                   Rolbk
000677210907     C                   Goto      EBEXIT
000678210907     C                   Else
000679210907      * Otherwise Commit any DBF changes
000680210907     C                   Commit
000681210907     C                   Endif
000682210907
000683210907      ** USER: Process command keys
000684210907     C     W0RTN         Ifeq      *Blank
000685210907     C     W0PMD         Ifeq      'ADD'
000686210907      * Exit after successful add
000687210907     C                   Movel     'N'           W0RPT
000688210907     C                   Endif
000689210907      * Restart program for next record
000690210907     C                   Movel     'N'           W0TRN
000691210907     C                   Endif
000692210907      *
000693210907     CSR   EBEXIT        Endsr
000694210907      /EJECT
000695210907
000696210907      *****************************************************************
000697210907      ** Process add request
000698210907      *****************************************************************
000699210907     CSR   ECADRQ        Begsr
000700210907
000701210907      ** Create Midas A/c Code
000702210907     C                   Exsr      SECRRC
000703210907     C     W0RTN         Ifeq      *Blank
000704210907      * Send message '*Record added'
000705210907     C                   Movel     'Y2U0011'     ZAMSID
000706210907     C                   Movel     'Y2USRMSG'    ZAMSGF
000707210907     C                   Exsr      ZASNMS
000708210907     C                   Endif
000709210907      *
000710210907     CSR   ECEXIT        Endsr
000711210907      /EJECT
000712210907
000713210907      *****************************************************************
000714210907      ** Process delete request
000715210907      *****************************************************************
000716210907     CSR   EDDLRQ        Begsr
000717210907
000718210907      ** Physical delete Midas A/c Code
000719210907     C                   Exsr      SGCHRC
000720210907     C     W0RTN         Ifeq      *Blank
000721210907      * Send message '*Record deleted'
000722210907     C                   Movel     'Y2U0013'     ZAMSID
000723210907     C                   Movel     'Y2USRMSG'    ZAMSGF
000724210907     C                   Exsr      ZASNMS
000725210907     C                   Endif
000726210907      *
000727210907     CSR   EDEXIT        Endsr
000728210907      /EJECT
000729210907
000730210907      *****************************************************************
000731210907      ** Process update request
000732210907      *****************************************************************
000733210907     CSR   EECHRQ        Begsr
000734210907
000735210907      ** Change Midas A/c Code
000736210907     C     WP0001        Ifne      'E'
000737210907     C                   Exsr      SHCHRC
000738210907     C     W0RTN         Ifne      *Blank
000739210907      * Reset screen fields if changed record
000740210907     C     W0RTN         CaseQ     'Y2U0007'     MBFL#1
000741210907     C                   End
000742210907     C                   Else
000743210907      * Send message '*Record changed'
000744210907     C                   Movel     'Y2U0012'     ZAMSID
000745210907     C                   Movel     'Y2USRMSG'    ZAMSGF
000746210907     C                   Exsr      ZASNMS
000747210907     C                   Endif
000748210907     C                   Endif
000749210907      *
000750210907     CSR   EEEXIT        Endsr
000751210907      /EJECT
000752210907
000753210907      *****************************************************************
000754210907      ** Check passed parameters
000755210907      *****************************************************************
000756210907     CSR   FACKPM        Begsr
000757210907      * Is full key present?
000758210907     C     P1MDAC        Ifeq      *Blanks
000759210907      * Not every key field passed - loop program
000760210907     C                   Movel     'Y'           W0RPT             1
000761210907     C                   Else
000762210907      * Full key passed, so single shot program
000763210907     C                   Movel     'N'           W0RPT
000764210907     C                   Endif
000765210907      *
000766210907     CSR   FAEXIT        Endsr
000767210907      /EJECT
000768210907
000769210907      *****************************************************************
000770210907      ** Set key screen conditioning indicators
000771210907      *****************************************************************
000772210907     CSR   GADSAK        Begsr
000773210907      *
000774210907     C     W0PMD         COMP      'ADD'                                  89
000775210907      *
000776210907     CSR   GAEXIT        Endsr
000777210907      /EJECT
000778210907
000779210907      *****************************************************************
000780210907      ** Set detail screen conditioning indicators
000781210907      *****************************************************************
000782210907     CSR   GBDSAD        Begsr
000783210907      *
000784210907     C     W0PMD         Comp      'ADD'                                  89
000785210907      * Protect key fields on detail screen
000786210907     C                   Seton                                        88
000787210907     C                   Movel     '0'           *IN79
000788210907     C                   Movel     '0'           *IN80
000789210907      *
000790210907     C     WUOFIN        Ifeq      'Y'
000791210907     C                   Movel     '1'           *IN79
000792210907     C                   Movel     '1'           *IN80
000793210907     C                   Endif
000794210907      *
000795210907     C                   Movel     '0'           *IN78
000796210907     C     W0PMD         Ifeq      'ADD'
000797210907     C                   Movel     '1'           *IN78
000798210907     C                   Endif
000799210907      * Enable key screen
000800210907     C                   Seton                                        87
000801210907      *
000802210907     CSR   GBEXIT        Endsr
000803210907      /EJECT
000804210907
000805210907      *****************************************************************
000806210907      * Initialise record - except for key fields
000807210907      *================================================================
000808210907     CSR   MAIZ#1        Begsr
000809210907      *
000810210907     C                   Movel     P2ANCD        #PANCD
000811210907      *
000812210907     C                   If        P2ANCD = 'I'
000813210907     C                   Movel     *Blanks       #1HOAC
000814210907     C                   Movel     *Blanks       #1HOPC
000815210907     C                   Movel     *Blanks       #1HOMC
000816210907     C                   Movel     *Blanks       #1EXCL
000817210907
000818210907     C                   Setoff                                       314142
000819210907     C                   Setoff                                       434445
000820210907     C                   Endif
000821210907      *
000822210907     CSR   MAEXIT        Endsr
000823210907      /EJECT
000824210907
000825210907      *****************************************************************
000826210907      ** Move XXACHOMTD fields to screen
000827210907      *****************************************************************
000828210907     CSR   MBFL#1        Begsr
000829210907      *
000830210907     C                   Move      WACODE        #1MDAC
000831210907     C                   Movel     XXMHOAC       #1HOAC
000832210907     C                   Movel     XXMHOPC       #1HOPC
000833210907     C                   Movel     XXMHOMC       #1HOMC
000834210907     C                   Movel     XXMEXCL       #1EXCL
000835210907
000836210907      * Hold existing record image
000837210907     C                   Move      *Blanks       #1DBRC
000838210907     C                   Movel     @1DBRC        #1DBRC
000839210907      *
000840210907     CSR   MBEXIT        Endsr
000841210907      /EJECT
000842210907
000843210907      *****************************************************************
000844210907      ** Initialize key screen
000845210907      *****************************************************************
000846210907     CSR   MDIZ#K        Begsr
000847210907      *
000848210907     C                   Movel     P2ANCD        #PANCD
000849210907     C                   Movel     P1MDAC        #1MDAC
000850210907     C                   Movel     P1HOAC        #1HOAC
000851210907     C                   Movel     P1HOPC        #1HOPC
000852210907     C                   Movel     P1HOMC        #1HOMC
000853210907     C                   Movel     P1EXCL        #1EXCL
000854210907
000855210907      * Set up Key Screen Header Title
000856210907     C                   Exsr      UHSUBR
000857210907      * Set up Key Screen Footer
000858210907     C                   Exsr      UISUBR
000859210907      *
000860210907     CSR   MDEXIT        Endsr
000861210907      /EJECT
000862210907
000863210907      *****************************************************************
000864210907      ** Check if record exists - Midas A/c Code
000865210907      *****************************************************************
000866210907     CSR   SDRVGN        Begsr
000867210907      *
000868210907     C                   Movel     *Blank        W0RTN             7
000869210907      * Declare restrictor key work fields
000870210907     C     *Like         Define    WACODE        WQSD01
000871210907      * Define keylist
000872210907     C     KRSSD         Klist
000873210907     C                   Kfld                    WQSD01
000874210907      * Move fields to key list
000875210907     C                   Move      #1MDAC        WQSD01
000876210907     C     KRSSD         Setll     XXACHOMDB
000877210907     C     KRSSD         Reade     XXACHOMDB                              90
000878210907     C     *IN90         Ifeq      '1'
000879210907     C                   Movel     'DRI0515'     W0RTN             7
000880210907      * USER: Processing if Data record not found
000881210907     C                   Movel     'Y2U0005'     W0RTN
000882210907     C                   Goto      SDEXIT
000883210907     C                   Endif
000884210907      *
000885210907     C     *IN90         Doweq     '0'
000886210907     C                   Movel     'Y2U0003'     W0RTN
000887210907     C     KRSSD         Reade     XXACHOMDB                              90
000888210907     C                   Enddo
000889210907      *
000890210907     CSR   SDEXIT        Endsr
000891210907      /EJECT
000892210907
000893210907      *****************************************************************
000894210907      ** Create Midas A/c Code
000895210907      *****************************************************************
000896210907     CSR   SECRRC        Begsr
000897210907      *
000898210907     C                   Movel     *Blank        W0RTN             7
000899210907      * Move all fields to XXACHOMTD
000900210907     C                   Move      #1MDAC        XXMACOD
000901210907     C                   Movel     #1HOAC        XXMHOAC
000902210907     C                   Movel     #1HOPC        XXMHOPC
000903210907     C                   Movel     #1HOMC        XXMHOMC
000904210907     C                   Movel     #1EXCL        XXMEXCL
000905210907      *
000906210907     C     KLCRSE        Klist
000907210907     C                   Kfld                    XXMACOD
000908210907      * Check for duplicate primary key
000909210907     C     KLCRSE        Setll     XXACHOMDA                              90
000910210907     C     *IN90         Ifeq      '1'
000911210907     C                   Movel     'DRI0514'     W0RTN             7
000912210907      * Send message 'Midas A/c Code exist'
000913210907     C                   Movel     'DRI0514'     ZAMSID
000914210907     C                   Exsr      ZASNMS
000915210907     C                   Goto      SEEXIT
000916210907     C                   Endif
000917210907      *
000918210907     C                   Write     XXACHOMDA                            91
000919210907      *
000920210907     C     *IN91         Ifeq      '1'
000921210907      * Write error detected
000922210907     C                   Movel     'Y2U0004'     W0RTN             7
000923210907     C                   Else
000924210907      * USER: Processing after Data update
000925210907     C                   Z-Add     1             WUNORC
000926210907     C                   Z-Add     1             WUNOIN
000927210907     C                   Z-Add     *Zero         WUNOAM
000928210907     C                   Z-Add     *Zero         WUNODL
000929210907     C                   Endif
000930210907      *
000931210907     CSR   SEEXIT        Endsr
000932210907      /EJECT
000933210907
000934210907      *****************************************************************
000935210907      ** Physical delete of Midas A/c Code
000936210907      *****************************************************************
000937210907     CSR   SGCHRC        Begsr
000938210907     C                   Movel     *Blank        W0RTN             7
000939210907      * Case: PAR.Action Code is Delete
000940210907     C     P2ANCD        Ifeq      'D'
000941210907     C                   Move      #1MDAC        XXMACOD
000942210907      *
000943210907     C     KLDLTR        Klist
000944210907     C                   Kfld                    XXMACOD
000945210907     C     KLDLTR        Chain     XXACHOMDA                          9091
000946210907      *
000947210907     C     *IN90         Ifeq      '1'
000948210907      * Record not found
000949210907     C                   Movel     'Y2U0009'     W0RTN             7
000950210907      * Send message '*Record no longer on file'
000951210907     C                   Movel     'Y2U0009'     ZAMSID
000952210907     C                   Movel     'Y2USRMSG'    ZAMSGF
000953210907     C                   Exsr      ZASNMS
000954210907     C                   Goto      SGEXIT
000955210907     C                   Endif
000956210907      * Record locked
000957210907     C     *IN91         Ifeq      '1'
000958210907     C                   Movel     'Y2U0004'     W0RTN             7
000959210907     C                   Goto      SGEXIT
000960210907     C                   Endif
000961210907      *
000962210907     C     *IN91         Ifeq      '0'
000963210907     C     *IN90         Andeq     '0'
000964210907     C                   Delete    XXACHOMDA
000965210907     C                   Goto      SGEXIT
000966210907     C                   Endif
000967210907      *
000968210907     C                   Else
000969210907      * Send message 'Function key not allowed'
000970210907     C                   Movel     'USR0533'     ZAMSID
000971210907     C                   Exsr      ZASNMS
000972210907     C                   Seton                                        99
000973210907      *
000974210907     C                   Movel     'Y2U0004'     W0RTN
000975210907     C                   Goto      SGEXIT
000976210907     C                   Endif
000977210907
000978210907      ** Set PGM.*Record Data Changed flag
000979210907     C                   Move      'N'           YBRDC             1
000980210907      *
000981210907      * Move key fields to XXCACHOMTD
000982210907     C                   Move      #1MDAC        XXMACOD
000983210907      *
000984210907     C     KLCHSG        Klist
000985210907     C                   Kfld                    XXMACOD
000986210907     C     KLCHSG        Chain     XXACHOMDA                          9091
000987210907     C     *IN90         Ifeq      '1'
000988210907      * Record not found
000989210907     C                   Movel     'Y2U0009'     W0RTN             7
000990210907      * Send message '*Record no longer on file'
000991210907     C                   Movel     'Y2U0009'     ZAMSID
000992210907     C                   Movel     'Y2USRMSG'    ZAMSGF
000993210907     C                   Exsr      ZASNMS
000994210907     C                   Goto      SGEXIT
000995210907     C                   Endif
000996210907      * Record locked
000997210907     C     *IN91         Ifeq      '1'
000998210907     C                   Movel     'Y2U0004'     W0RTN             7
000999210907     C                   Goto      SGEXIT
001000210907     C                   End
001001210907      *
001002210907      * Check for changed record
001003210907     C     #1DBRC        Ifne      @1DBRC
001004210907     C                   Movel     'Y2U0007'     W0RTN             7
001005210907      * Send message '*Update not accepted'
001006210907     C                   Movel     'Y2U0007'     ZAMSID
001007210907     C                   Movel     'Y2USRMSG'    ZAMSGF
001008210907     C                   Exsr      ZASNMS
001009210907      * Release record lock
001010210907     C                   Unlock    XXACHOML1                            91
001011210907     C                   Goto      SGEXIT
001012210907     C                   Endif
001013210907      * Store record data for null update check
001014210907     C                   Move      @1DBRC        YBRDCS
001015210907      * Set PGM.*Record Data Changed flag
001016210907     C     @1DBRC        Ifne      YBRDCS
001017210907     C                   Move      'Y'           YBRDC
001018210907     C                   Endif
001019210907      * If changed update record otherwise release record
001020210907     C     YBRDC         Ifeq      'Y'
001021210907     C                   Update    XXACHOMDA                            91
001022210907     C                   Else
001023210907      * Release record lock
001024210907     C                   Unlock    XXACHOML1                            91
001025210907     C                   End
001026210907      * Change error detected
001027210907     C     *IN91         Ifeq      '1'
001028210907     C                   Movel     'Y2U0004'     W0RTN             7
001029210907     C                   Else
001030210907      * Update saved record image
001031210907     C                   Move      *Blanks       #1DBRC
001032210907     C                   Movel     @1DBRC        #1DBRC
001033210907      * DBF change successful
001034210907     C                   Endif
001035210907      *
001036210907     CSR   SGEXIT        Endsr
001037210907      /EJECT
001038210907
001039210907      *****************************************************************
001040210907      * Change Midas A/c Code
001041210907      *****************************************************************
001042210907     CSR   SHCHRC        Begsr
001043210907      *
001044210907     C                   Movel     *Blank        W0RTN             7
001045210907      * Set PGM.*Record Data Changed flag
001046210907     C                   Move      'N'           YCRDC             1
001047210907      * Move key fields to XXACHOMDA
001048210907     C                   Move      #1MDAC        XXMACOD
001049210907      *
001050210907     C     KLCHSH        Klist
001051210907     C                   Kfld                    XXMACOD
001052210907     C     KLCHSH        Chain     XXACHOMDA                          9091
001053210907     C     *IN90         Ifeq      '1'
001054210907      * Record not found
001055210907     C                   Movel     'Y2U0009'     W0RTN             7
001056210907      * Send message '*Record no longer on file'
001057210907     C                   Movel     'Y2U0009'     ZAMSID
001058210907     C                   Movel     'Y2USRMSG'    ZAMSGF
001059210907     C                   Exsr      ZASNMS
001060210907     C                   Goto      SHEXIT
001061210907     C                   Endif
001062210907      * Record locked
001063210907     C     *IN91         Ifeq      '1'
001064210907     C                   Movel     'Y2U0004'     W0RTN             7
001065210907     C                   Goto      SHEXIT
001066210907     C                   Endif
001067210907
001068210907      ** Check for changed record
001069210907     C     #1DBRC        Ifne      @1DBRC
001070210907     C                   Movel     'Y2U0007'     W0RTN             7
001071210907      * Send message '*Update not accepted'
001072210907     C                   Movel     'Y2U0007'     ZAMSID
001073210907     C                   Movel     'Y2USRMSG'    ZAMSGF
001074210907     C                   Exsr      ZASNMS
001075210907      * Release record lock
001076210907     C                   Unlock    XXACHOML1                            91
001077210907     C                   Goto      SHEXIT
001078210907     C                   Endif
001079210907      * Store record data for null update check
001080210907     C                   Move      @1DBRC        YCRDCS
001081210907      * Move non-key fields to XXACHOMTD
001082210907     C                   Movel     #1HOAC        XXMHOAC
001083210907     C                   Movel     #1HOPC        XXMHOPC
001084210907     C                   Movel     #1HOMC        XXMHOMC
001085210907     C                   Movel     #1EXCL        XXMEXCL
001086210907
001087210907      * Set PGM.*Record Data Changed flag
001088210907     C     @1DBRC        Ifne      YCRDCS
001089210907     C                   Move      'Y'           YCRDC
001090210907     C                   Endif
001091210907      * If changed update record otherwise release record
001092210907     C     YCRDC         Ifeq      'Y'
001093210907     C                   Update    XXACHOMDA                            91
001094210907     C                   Else
001095210907      * Release record lock
001096210907     C                   Unlock    XXACHOML1                            91
001097210907     C                   End
001098210907     C     *IN91         Ifeq      '1'
001099210907      * Change error detected
001100210907     C                   Movel     'Y2U0004'     W0RTN             7
001101210907     C                   Else
001102210907      *
001103210907      * Update saved record image
001104210907     C                   Move      *Blanks       #1DBRC
001105210907     C                   Movel     @1DBRC        #1DBRC
001106210907      * DBF change successful
001107210907     C                   Z-Add     *Zero         WUNORC
001108210907     C                   Z-Add     *Zero         WUNOIN
001109210907     C                   Z-Add     1             WUNOAM
001110210907     C                   Z-Add     *Zero         WUNODL
001111210907      *
001112210907     C                   Endif
001113210907      *
001114210907     CSR   SHEXIT        Endsr
001115210907      /EJECT
001116210907
001117210907      *****************************************************************
001118210907      ** Set up Detail Screen Header Title
001119210907      *****************************************************************
001120210907     CSR   UASUBR        Begsr
001121210907      * Setup message data for message
001122210907     C     WP0001        Ifeq      'E'
001123210907     C                   Movel     'DRI0512'     ZAMSID
001124210907     C                   Else
001125210907     C                   Movel     'DRI0513'     ZAMSID
001126210907     C                   Endif
001127210907      *
001128210907     C                   Movel     'XXUSRMSG'    ZAMSGF
001129210907     C                   Call      'Y2RVMGC'                            90
001130210907     C                   Parm      *Blank        W0RTN             7
001131210907     C                   Parm                    ZAMSID            7
001132210907     C                   Parm                    ZAMSGF           10
001133210907     C                   Parm                    ZAMSDA          132
001134210907     C     WUDFTL        Parm                    W0MTX           132
001135210907     C                   Movel     *Blank        ZAMSDA
001136210907     C                   Movel     *Blank        ZAMSGF
001137210907      * Move to Header Title - Standard Functions  *
001138210907     C                   Movel     WUDFTL        ##URPT
001139210907      *
001140210907     CSR   UAEXIT        Endsr
001141210907      /EJECT
001142210907
001143210907      *****************************************************************
001144210907      ** Set up Detail Screen Footer
001145210907      *****************************************************************
001146210907     CSR   UBSUBR        Begsr
001147210907      * Setup message data for message
001148210907     C                   Movel     ZADFMF        ZAMSGF
001149210907     C                   Call      'Y2RVMGC'                            90
001150210907     C                   Parm      *Blank        W0RTN             7
001151210907     C                   Parm      'USR2919'     ZAMSID            7
001152210907     C                   Parm                    ZAMSGF           10
001153210907     C                   Parm                    ZAMSDA          132
001154210907     C     WUSFT1        Parm                    W0MTX           132
001155210907     C                   Movel     *Blank        ZAMSDA
001156210907     C                   Movel     *Blank        ZAMSGF
001157210907      * Move to Single Footer - Standard Functions  *
001158210907     C                   Movel     WUSFT1        ##CTX1
001159210907      *
001160210907     CSR   UBEXIT        Endsr
001161210907      /EJECT
001162210907
001163210907      *****************************************************************
001164210907      * Set up Detail Screen Header Title
001165210907      *****************************************************************
001166210907     CSR   UCSUBR        Begsr
001167210907      * Setup message data for message
001168210907     C     WP0001        Ifeq      'E'
001169210907     C                   Movel     'DRI0512'     ZAMSID
001170210907     C                   Else
001171210907     C                   Movel     'DRI0513'     ZAMSID
001172210907     C                   Endif
001173210907      *
001174210907     C                   Movel     'XXUSRMSG'    ZAMSGF
001175210907     C                   Call      'Y2RVMGC'                            90
001176210907     C                   Parm      *Blank        W0RTN             7
001177210907     C                   Parm                    ZAMSID            7
001178210907     C                   Parm                    ZAMSGF           10
001179210907     C                   Parm                    ZAMSDA          132
001180210907     C     WUDFTL        Parm                    W0MTX           132
001181210907     C                   Movel     *Blank        ZAMSDA
001182210907     C                   Movel     *Blank        ZAMSGF
001183210907      * Move to Header Title - Standard Functions  *
001184210907     C                   Movel     WUDFTL        ##URPT
001185210907      *
001186210907     CSR   UCEXIT        Endsr
001187210907      /EJECT
001188210907
001189210907      *****************************************************************
001190210907      ** Set up Detail Screen Footer
001191210907      *****************************************************************
001192210907     CSR   UDSUBR        Begsr
001193210907      * Amend or Enquiry mode
001194210907     C     P2ANCD        Ifeq      'E'
001195210907     C     P2ANCD        OREQ      'A'
001196210907      * Setup message data for message
001197210907     C                   Movel     ZADFMF        ZAMSGF
001198210907     C                   Call      'Y2RVMGC'                            90
001199210907     C                   Parm      *Blank        W0RTN             7
001200210907     C                   Parm      'USR2920'     ZAMSID            7
001201210907     C                   Parm                    ZAMSGF           10
001202210907     C                   Parm                    ZAMSDA          132
001203210907     C     WUSFT1        Parm                    W0MTX           132
001204210907     C                   Movel     *Blank        ZAMSDA
001205210907     C                   Movel     *Blank        ZAMSGF
001206210907     C                   Endif
001207210907      * Delete mode
001208210907     C     P2ANCD        Ifeq      'D'
001209210907      * Setup message data for message
001210210907     C                   Movel     ZADFMF        ZAMSGF
001211210907     C                   Call      'Y2RVMGC'                            90
001212210907     C                   Parm      *Blank        W0RTN             7
001213210907     C                   Parm      'USR2921'     ZAMSID            7
001214210907     C                   Parm                    ZAMSGF           10
001215210907     C                   Parm                    ZAMSDA          132
001216210907     C     WUSFT1        Parm                    W0MTX           132
001217210907     C                   Movel     *Blank        ZAMSDA
001218210907     C                   Movel     *Blank        ZAMSGF
001219210907     C                   Endif
001220210907      * Move to Single Footer - Standard Functions  *
001221210907     C                   Movel     WUSFT1        ##CTX1
001222210907      *
001223210907     CSR   UDEXIT        Endsr
001224210907      /EJECT
001225210907
001226210907      *****************************************************************
001227210907      ** Set up Key Screen Header Title
001228210907      *****************************************************************
001229210907     CSR   UFSUBR        Begsr
001230210907      * Setup message data for message
001231210907     C                   Movel     'XXUSRMSG'    ZAMSGF
001232210907     C                   Call      'Y2RVMGC'                            90
001233210907     C                   Parm      *Blank        W0RTN             7
001234210907     C                   Parm      'DRI0516'     ZAMSID            7
001235210907     C                   Parm                    ZAMSGF           10
001236210907     C                   Parm                    ZAMSDA          132
001237210907     C     WUDFTL        Parm                    W0MTX           132
001238210907     C                   Movel     *Blank        ZAMSDA
001239210907     C                   Movel     *Blank        ZAMSGF
001240210907      * Move to Header Title - Standard Functions  *
001241210907     C                   Movel     WUDFTL        ##URPT
001242210907      *
001243210907     CSR   UFEXIT        Endsr
001244210907      /EJECT
001245210907
001246210907      *****************************************************************
001247210907      ** Set up Key Screen Footer
001248210907      *****************************************************************
001249210907     CSR   UGSUBR        Begsr
001250210907      * Setup message data for message
001251210907     C                   Movel     ZADFMF        ZAMSGF
001252210907     C                   Call      'Y2RVMGC'                            90
001253210907     C                   Parm      *Blank        W0RTN             7
001254210907     C                   Parm      'USR2918'     ZAMSID            7
001255210907     C                   Parm                    ZAMSGF           10
001256210907     C                   Parm                    ZAMSDA          132
001257210907     C     WUSFT1        Parm                    W0MTX           132
001258210907     C                   Movel     *Blank        ZAMSDA
001259210907     C                   Movel     *Blank        ZAMSGF
001260210907      * Move to Single Footer - Standard Functions  *
001261210907     C                   Movel     WUSFT1        ##CTX1
001262210907      *
001263210907     CSR   UGEXIT        Endsr
001264210907      /EJECT
001265210907
001266210907      *****************************************************************
001267210907      ** Set up Key Screen Header Title
001268210907      *****************************************************************
001269210907     CSR   UHSUBR        Begsr
001270210907      * Setup message data for message
001271210907     C                   Movel     'XXUSRMSG'    ZAMSGF
001272210907     C                   Call      'Y2RVMGC'                            90
001273210907     C                   Parm      *Blank        W0RTN             7
001274210907     C                   Parm      'DRI0516'     ZAMSID            7
001275210907     C                   Parm                    ZAMSGF           10
001276210907     C                   Parm                    ZAMSDA          132
001277210907     C     WUDFTL        Parm                    W0MTX           132
001278210907     C                   Movel     *Blank        ZAMSDA
001279210907     C                   Movel     *Blank        ZAMSGF
001280210907      * Move to Header Title - Standard Functions  *
001281210907     C                   Movel     WUDFTL        ##URPT
001282210907      *
001283210907     CSR   UHEXIT        Endsr
001284210907      /EJECT
001285210907
001286210907      *****************************************************************
001287210907      ** Set up Key Screen Footer
001288210907      *****************************************************************
001289210907     CSR   UISUBR        Begsr
001290210907      * Setup message data for message
001291210907     C                   Movel     ZADFMF        ZAMSGF
001292210907     C                   Call      'Y2RVMGC'                            90
001293210907     C                   Parm      *Blank        W0RTN             7
001294210907     C                   Parm      'USR2918'     ZAMSID            7
001295210907     C                   Parm                    ZAMSGF           10
001296210907     C                   Parm                    ZAMSDA          132
001297210907     C     WUSFT1        Parm                    W0MTX           132
001298210907     C                   Movel     *Blank        ZAMSDA
001299210907     C                   Movel     *Blank        ZAMSGF
001300210907      * Move to Single Footer - Standard Functions  *
001301210907     C                   Movel     WUSFT1        ##CTX1
001302210907      *
001303210907     CSR   UIEXIT        Endsr
001304210907      /EJECT
001305210907
001306210907      *****************************************************************
001307210907      ** Send message to program's message queue
001308210907      *****************************************************************
001309210907     CSR   ZASNMS        Begsr
001310210907     C     ZAPGMQ        Ifeq      *Blank
001311210907     C                   Movel     ##PGM         ZAPGMQ
001312210907     C                   Endif
001313210907      * If no message file specified, use default
001314210907     C     ZAMSGF        Ifeq      *Blank
001315210907     C                   Movel     ZADFMF        ZAMSGF
001316210907     C                   Endif
001317210907     C                   Call      'Y2SNMGC'
001318210907     C                   Parm                    ZAPGMQ           10
001319210907     C                   Parm                    ZAPGRL            5
001320210907     C                   Parm                    ZAMSID            7
001321210907     C                   Parm                    ZAMSGF           10
001322210907     C                   Parm                    ZAMSDA          132
001323210907     C                   Parm                    ZAMSTP            7
001324210907      * Clear all fields for default mechanism next Time
001325210907     C                   Movel     *Blank        ZAPGMQ
001326210907     C                   Movel     *Blank        ZAPGRL
001327210907     C                   Movel     *Blank        ZAMSID
001328210907     C                   Movel     *Blank        ZAMSGF
001329210907     C                   Movel     *Blank        ZAMSDA
001330210907     C                   Movel     *Blank        ZAMSTP
001331210907      *
001332210907     CSR   ZAEXIT        Endsr
001333210907      /EJECT
001334210907
001335210907      *****************************************************************
001336210907      ** Cancel and exit from key screen
001337210907      *****************************************************************
001338210907     CSR   ZXEXPG        Begsr
001339210907      * USER: Exit program processing
001340210907      * Case: KEY.*CMD key is *Exit
001341210907     C     *IN03         Ifeq      '1'
001342210907     C                   Movel     'Y2U9999'     P0RTN
001343210907     C                   Exsr      ZYEXPG
001344210907     C                   Endif
001345210907     C*
001346210907     C                   Movel     *Blank        P0RTN
001347210907     C                   Exsr      ZYEXPG
001348210907      *
001349210907     CSR   ZXEXIT        Endsr
001350210907      /EJECT
001351210907
001352210907      *****************************************************************
001353210907      ** Exit program: Direct
001354210907      *****************************************************************
001355210907     CSR   ZYEXPG        Begsr
001356210907      * ROLLBACK any uncommitted DBF changes
001357210907     C                   Rolbk                                          90
001358210907      *
001359210907      * Exit program
001360210907     C                   Return
001361210907      *
001362210907      *
001363210907     CSR   ZYEXIT        Endsr
001364210907      /EJECT
001365210907
001366210907      *****************************************************************
001367210907      ** Initialisation
001368210907      *****************************************************************
001369210907     CSR   ZZINIT        Begsr
001370210907      *
001371210907     C                   Move      *Blank        P0RTN
001372210907     C                   Move      *Blank        W0RTN             7
001373210907      * Initialise indicators for re-Entry
001374210907     C                   Move      '0'           *IN
001375210907      * Update screen Time
001376210907     C                   Time                    ##TME             6 0
001377210907      * Define work field Display File Title
001378210907     C                   Movel     *Blank        WUDFTL           53
001379210907      * Obtain default message file
001380210907     C     *Dtaara       Define    Y2MGFLA       ZADFMF           10
001381210907     C                   In        ZADFMF
001382210907      * Define work field STD FTR 1
001383210907     C                   Movel     *Blank        WUSFT1           78
001384210907      * Define work field Midas Run Date
001385210907     C                   Movel     *Blank        WUMRDT            7
001386210907      * Define work field Run day number
001387210907     C                   Z-Add     *Zero         WURDNB            5 0
001388210907      * Define work field No. of Records
001389210907     C                   Z-Add     *Zero         WUNORC            5 0
001390210907      * Define work field No. of Inserts
001391210907     C                   Z-Add     *Zero         WUNOIN            5 0
001392210907      * Define work field No. of Amends
001393210907     C                   Z-Add     *Zero         WUNOAM            5 0
001394210907      * Define work field No. of Deletes
001395210907     C                   Z-Add     *Zero         WUNODL            5 0
001396210907      * Define work field Output field indicator
001397210907     C                   Movel     *Blank        WUOFIN            1
001398210907      * Define work field Set Up Complete
001399210907     C                   Movel     *Blank        WUSUC             1
001400210907      * Define work field Date format flag
001401210907     C                   Movel     *Blank        WUDFF             1
001402210907      * Define work field Multi-branching Indicator
001403210907     C                   Movel     *Blank        WUMBIN            1
001404210907      * Define work field Customer
001405210907     C                   Movel     *Blank        #WCUST            6
001406210907
001407210907      ** Open files first Time only
001408210907     C     W0OPN         Ifeq      *Blank
001409210907      * Begin Commit control
001410210907     C                   Call      'Y2BGCMC'
001411210907     C                   Parm                    W0RTN             7
001412210907     C     W0RTN         Ifne      *Blank
001413210907     C     W0RTN         Andne     'CPF8351'
001414210907     C                   Exsr      ZYEXPG
001415210907     C                   Endif
001416210907      *
001417210907     C                   Open      XX005002DF
001418210907     C                   Open      XXACHOML0
001419210907     C                   Open      XXACHOML1
001420210907
001421210907      * Signal that files are now Open
001422210907     C                   Move      'Y'           W0OPN             1
001423210907     C                   Endif
001424210907      *
001425210907     C                   Movel     'N'           W0PMT             1
001426210907
001427210907      ** Select initial mode
001428210907     C     @1NROP        Ifeq      *Zero
001429210907      * Add mode
001430210907     C                   Movel     'ADD'         W0PMD             3
001431210907     C                   Else
001432210907      * Change mode
001433210907     C                   Movel     'CHG'         W0PMD
001434210907     C                   Endif
001435210907
001436210907      ** Copyright Statement and Rundate setup
001437210907     C     *Dtaara       Define                  RUNDAT
001438210907     C                   In        RUNDAT
001439210907     C                   Move      MRDT          ##MRDT            7
001440210907     C                   Move      MRDT          WUMRDT
001441210907     C                   Move      RDNB          WURDNB
001442210907     C                   Move      SUC           WUSUC
001443210907     C                   Move      DFF           WUDFF
001444210907     C                   Move      MBIN          WUMBIN
001445210907
001446210907      ** Action Enquire or Delete
001447210907     C     P2ANCD        Ifeq      'E'
001448210907     C     P2ANCD        Oreq      'D'
001449210907     C                   Movel     'Y'           WUOFIN
001450210907     C                   Endif
001451210907      *
001452210907     CSR   ZZEXIT        Endsr
001453210907      /EJECT
001454210907
001455210907      *****************************************************************
001456210907      *                                                               *
001457210907      * *PSSR  - Program exception error routine                      *
001458210907      *          Called automatiCally if a program error occurs,      *
001459210907      *          or directly by the program code using EXSR.          *
001460210907      *          This subroutine DUMPs the program just once.         *
001461210907      *                                                               *
001462210907      *****************************************************************
001463210907     CSR   *PSSR         Begsr
001464210907
001465210907      ** Standard Midas PSSR processing.
001466210907     C     @RUN          Ifeq      *Blank
001467210907     C                   Move      'Y'           @RUN              1
001468210907     C                   Move      'PSSR   '     P0RTN
001469210907     C                   Dump
001470210907
001471210907      ** Route job back into Midas.
001472210907     C                   Seton                                        LR
001473210907     C                   Call      'DBERRCTL'
001474210907     C                   End
001475210907      *
001476210907     CSR                 Endsr
001477210907      *****************************************************************
001478210907** VLD
0014792109070123456789
