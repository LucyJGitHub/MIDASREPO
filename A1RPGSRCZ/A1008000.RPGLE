000100210721     H DEBUG DATEDIT(*YMD)
000200210721      *****************************************************************
000300210721/*STD *  RPGBASEBND                                                   *
000400210721/*EXI *  TEXT('Midas SD Consolidation Replication Maintenance')       *
000500210721      *****************************************************************
000600210721      *                                                               *
000700210721      *  Midas - Standing Data Module                                 *
000800210721      *                                                               *
000900210721      *  A1008000 - Midas SD Consolidation Replication Maintenance    *
001000210721      *                                                               *
001100210721      *  Function:  This program allows the user to enquire from a    *
001200210721      *             list of Branch Replication details                *
001300210721      *                                                               *
001400210721      *  (c) Finastra International Limited 2021                      *
001500210721      *                                                               *
001600210721      *  Last Amend No. BA1008   *Create   Date 03Jun21               *
001700210721      *                                                               *
001800210721      *-------------------------------------------------------------- *
001900210721      *                                                               *
002000210721      *  BA1008 - Replication of Trades to consolidated branches      *
002100210721      *                                                               *
002200210721      *****************************************************************
002300210721      ** Consolidated Branch Enquiry
002400210721     FA1008000DFCF   E             Workstn Usropn
002500210721     F                                     Sfile(#SFLRCD:##RR)
002600210721     F                                     Infds(Infds#)
002700210721     F                                     Infsr(*PSSR)
002800210721
002900210721      ** Midas SD Consolidated Branches - Retrieval
003000210721     FA1CONBL1  IF   E           K DISK    Usropn
003100210721     F                                     Infds(Infds1)
003200210721     F                                     Infsr(*PSSR)
003300210721      /EJECT
003400210721      *****************************************************************
003500210721      ** +-------------------------------+
003600210721      ** ¦ Data structures specification |
003700210721      ** +-------------------------------+
003800210721      *
003900210721     D PGMDS         ESDs                  Extname(Y2PGDSP)
004000210721
004100210721      ** Display file information data structure
004200210721     D Infds#        E Ds                  Extname(Y2I#DSP)
004300210721
004400210721      ** File information data structure
004500210721     D Infds1        E Ds                  Extname(Y2I1DSP)
004600210721
004700210721     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
004800210721      ** EXTERNAL DS FOR BRANCH DETAILS
004900210721
005000210721     D DSSDY         E DS                  EXTNAME(DSSDY)
005100210721      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
005200210721
005300210721      ** Outward parameters
005400210721     D PARC            Ds           222
005500210721     D  PABRCA                 1      3
005600210721
005700210721      ** Copyright array
005800210721     D RUNDAT          Ds
005900210721     D  MRDT                   1      7
006000210721     D  RDNB                   8     10P 0
006100210721     D  SUC                   11     11
006200210721     D  DFF                   12     12
006300210721     D  MBIN                  13     13
006400210721
006500210721      ** Parameter declarations
006600210721     D P1Parm          Ds
006700210721     D  P1DFMD                 1      1
006800210721
006900210721      **
007000210721     D                 Ds
007100210721     D  ZAMSDA                 1    132
007200210721     D  ZA0001                 1      1
007300210721     D  ZA0002                 1      1
007400210721
007500210721     D SCSARD        E DS                  EXTNAME(SCSARDPD)
007600210721      *
007700210721     D DSFDY         E DS                  EXTNAME(DSFDY)
007800210721      /EJECT
007900210721
008000210721      *****************************************************************
008100210721      ** Entry parameters
008200210721      *****************************************************************
008300210721      *
008400210721     C     *Entry        Plist
008500210721     C                   Parm                    P0RTN             7
008600210721     C     P1DFMD        Parm                    WP0001            1
008700210721
008800210721      ** Initialize
008900210721     C                   Exsr      ZZINIT
009000210721
009100210721     C                   Do        *Hival
009200210721      * Initialise & load subfile page
009300210721     C                   Exsr      BAIZSF
009400210721     C                   Movel     'N'           W0RSF             1
009500210721
009600210721      ** Display screen until reload requested
009700210721     C     W0RSF         Doweq     'N'
009800210721      * Display screen
009900210721     C                   Exsr      CAEXFM
010000210721      * Process response
010100210721      * Cancel & exit program
010200210721     C   03              Cas                     ZXEXPG
010300210721      * HOME: Request subfile reload
010400210721     C   05              Cas                     FBRQRL
010500210721      * Display next SFL page
010600210721     C   27              Cas                     BBLDSF
010700210721      * Process screen input
010800210721     C                   Cas                     DAPR##
010900210721     C                   End
011000210721      *
011100210721     C                   Enddo
011200210721     C                   Enddo
011300210721      /EJECT
011400210721
011500210721      *****************************************************************
011600210721      ** Initialise and load subfile page
011700210721      *****************************************************************
011800210721      *
011900210721     CSR   BAIZSF        Begsr
012000210721      * Clear subfile
012100210721     C                   Seton                                        80
012200210721     C                   Write     #SFLCTL
012300210721     C                   Setoff                                       80
012400210721      * Reset no of records in subfile
012500210721     C                   Z-Add     *Zero         ##RRMX            5 081
012600210721      * Initialize subfile control
012700210721     C     KPOS          Klist
012800210721     C                   Kfld                    FNBRCA
012900210721      * Setup key
013000210721     C                   Move      #2BRCA        FNBRCA
013100210721     C     KPOS          Setll     A1CONBL1
013200210721     C                   Read      A1CONBL1                             8782
013300210721      * Save previous selector values
013400210721     C     *LIKE         Define    #2BRCA        WZBRCA
013500210721     C                   Movel     #2BRCA        WZBRCA
013600210721      * Load subfile page
013700210721     C                   Z-Add     0             ##RROK            5 0
013800210721     C                   Exsr      BBLDSF
013900210721     CSR   BAEXIT        Endsr
014000210721      /EJECT
014100210721
014200210721      *****************************************************************
014300210721      ** Load subfile page
014400210721      *****************************************************************
014500210721      *
014600210721     CSR   BBLDSF        Begsr
014700210721      ** Re-establish fields in Read-ahead record
014800210721     C   27              Do
014900210721     C  N82              ReadP     A1CONBL1                               90
015000210721     C  N82              Read      A1CONBL1                               90
015100210721     C                   Enddo
015200210721
015300210721      * Setof record error indicators
015400210721     C                   Movel     *ALL'0'       WKIND0            1
015500210721     C                   Movea     WKIND0        *IN(35)
015600210721      * Start at previous highest record in SFL
015700210721     C                   Z-Add     ##RRMX        ##RR              5 0
015800210721      * Reset count of DBF records Read
015900210721     C                   Z-Add     0             ##RRRD            5 0
016000210721      * Set required pages based on *Set Cursor or *subfile Pages
016100210721     C     W0RR0         Ifgt      0
016200210721     C     W0RR0         Div       ##SFPG        ##SPG             3 0
016300210721     C                   Mvr                     ##SLIN            3 0
016400210721
016500210721     C     ##SLIN        Ifgt      0
016600210721     C                   Add       1             ##SPG
016700210721     C                   Endif
016800210721
016900210721     C     W0SPG         Ifgt      ##SPG
017000210721     C                   Z-Add     W0SPG         ##SPG
017100210721     C                   Endif
017200210721
017300210721     C                   Else
017400210721     C                   Z-Add     W0SPG         ##SPG
017500210721     C                   Endif
017600210721
017700210721      * Compute lines required based on pages
017800210721     C     ##SPG         Mult      ##SFPG        ##SFLN            9 0
017900210721     C     ##SFLN        Ifgt      999
018000210721     C                   Z-Add     999           ##SFLN
018100210721     C                   Endif
018200210721
018300210721      ** Load next SFL page until SFL page full, or scan limit reached
018400210721     C     *IN82         Doweq     '0'
018500210721     C     ##RROK        Andlt     ##SFLN
018600210721     C     ##RRRD        Andlt     W0SLM
018700210721
018800210721      ** Load SFL fields
018900210721     C                   Exsr      MBFL#1
019000210721      * Allow for possible *Set Cursor processing
019100210721     C                   Add       1             ##RR
019200210721     C                   Sub       1             ##RR
019300210721     C                   Movel     'Y'           W0RSL             1
019400210721      * Allow for possible *Set Cursor processing
019500210721     C                   Add       1             ##RR
019600210721      * USER: Initialize subfile record from DBF record
019700210721     C                   Sub       1             ##RR
019800210721      * DBF record not selected
019900210721     C     W0RSL         CabNe     'Y'           BB020
020000210721      * Output to subfile
020100210721     C                   Add       1             ##RR
020200210721     C                   Add       1             ##RROK               81
020300210721      * If SFLRCD invalid, note that errors present
020400210721     C   98
020500210721     CANN99              Seton                                        99
020600210721     C                   Write     #SFLRCD
020700210721      * Tag reference
020800210721     C     BB020         TAG
020900210721      * Increment scan check count
021000210721     C                   Add       1             ##RRRD
021100210721     C                   Read      A1CONBL1                               82
021200210721     C                   Enddo
021300210721      * Tag reference
021400210721     C     BB900         TAG
021500210721
021600210721      ** If no DBF records found, display error message
021700210721     C     ##RR          Ifeq      *Zero
021800210721     C     *IN82         Andeq     '1'
021900210721      * Send message '*No data to display'
022000210721     C                   Movel     'Y2U0008'     ZAMSID
022100210721     C                   Movel     'Y2USRMSG'    ZAMSGF
022200210721     C                   Exsr      ZASNMS
022300210721     C                   Endif
022400210721
022500210721      ** Save highest SFL record load can continue at end point
022600210721     C     ##RR          Ifgt      ##RRMX
022700210721      * Calculate top line
022800210721     C     ##RROK        Div       ##SFPG        ##SPG
022900210721     C                   Mvr                     ##SLIN
023000210721     C     ##SLIN        Ifgt      0
023100210721     C     ##RR          Sub       ##SLIN        ##SFRC
023200210721     C                   Else
023300210721     C     ##RR          Sub       ##SFPG        ##SFRC
023400210721     C                   End
023500210721     C                   Add       1             ##SFRC
023600210721     C                   Z-Add     ##RR          ##RRMX
023700210721     C                   End
023800210721
023900210721      ** If scan limit reached, display error message
024000210721     C     ##RRRD        Ifge      W0SLM
024100210721      * Send message '*Scan limit reached'
024200210721     C                   Movel     'Y2U0017'     ZAMSID
024300210721     C                   Movel     'Y2USRMSG'    ZAMSGF
024400210721     C                   Exsr      ZASNMS
024500210721     C                   Else
024600210721     C                   Z-Add     0             ##RROK
024700210721     C                   End
024800210721     CSR   BBEXIT        Endsr
024900210721      /EJECT
025000210721
025100210721      *****************************************************************
025200210721      ** Display screen
025300210721      *****************************************************************
025400210721     CSR   CAEXFM        Begsr
025500210721      *
025600210721     C     W0HLP         Doueq     'N'
025700210721     C                   Movel     'N'           W0HLP             1
025800210721     C                   Move      *ALL'0'       ##OFF            30
025900210721     C                   MoveA     ##OFF         *IN(1)
026000210721      * Update screen time
026100210721     C                   Time                    ##TME
026200210721      * PUTOVR unless conditioned fields change
026300210721     C                   Seton                                        86
026400210721     C     *IN81         Ifne      CAIN81
026500210721     C                   Setoff                                       86
026600210721     C                   Endif
026700210721     C                   Move      *IN81         CAIN81            1
026800210721      *
026900210721     C                   Write     #MSGCTL
027000210721     C                   Write     #CMDTXT1
027100210721     C                   Exfmt     #SFLCTL
027200210721      * Maintain subfile position where possible
027300210721     C     @#SFRC        Ifgt      *Zero
027400210721     C                   Z-Add     @#SFRC        ##SFRC
027500210721     C                   Endif
027600210721      *
027700210721     C                   Enddo
027800210721      * Clear messages from program message queue
027900210721     C                   Call      'Y2CLMSC'
028000210721     C                   Parm      ##PGM         ZAPGMQ           10
028100210721     C                   Parm      '*SAME'       ZAPGRL            5
028200210721      * Reset first message only flag
028300210721     C                   Movel     'Y'           ZAFSMS            1      99
028400210721     C                   Setoff                                         8392
028500210721     CSR   CAEXIT        Endsr
028600210721      /EJECT
028700210721
028800210721      *****************************************************************
028900210721      ** Process screen input
029000210721      *****************************************************************
029100210721     CSR   DAPR##        Begsr
029200210721
029300210721      ** Confirm/update is not deferred
029400210721     C                   Movel     'N'           W0DCF             1
029500210721      * Change of position specified
029600210721     C     WZBRCA        CasNe     #2BRCA        FBRQRL
029700210721     C                   End
029800210721
029900210721      ** USER: Process subfile control (Pre-confirm)
030000210721      ** Reload subfile requested
030100210721     C     W0RSF         CabEq     'Y'           DAEXIT
030200210721     C     *IN81         Ifeq      '1'
030300210721      * Process subfile records
030400210721     C                   Exsr      DBPRSF
030500210721     C                   Endif
030600210721
030700210721      ** USER: Final processing (Pre-confirm)
030800210721      ** If error, quit processing
030900210721     C     *IN99         CabEq     '1'           DAEXIT
031000210721      * Defer confirm/update requested
031100210721     C     W0DCF         CabEq     'Y'           DAEXIT
031200210721
031300210721      ** USER: Process command keys
031400210721      ** CASE: PAR.Display file mode is Maintenance mode
031500210721     C     P1DFMD        Ifeq      'M'
031600210721      * CASE: CTL.*CMD key is *Add
031700210721     C     *IN09         Ifeq      '1'
031800210721      *
031900210721      * Initialize calling parameters
032000210721     C                   Clear                   PARC
032100210721     C                   Movel     #2BRCA        PABRCA
032200210721      * Call Midas SD Consolidated Branches Maintenance
032300210721     C                   Call      'A1008001'                           90
032400210721     C                   Parm      *Blank        W0RTN             7
032500210721     C                   Parm                    PARC
032600210721     C                   Parm      'I'           WQ0001            1
032700210721      *
032800210721     C     *IN90         Ifeq      '1'
032900210721      * Call to program ended in error
033000210721     C                   Movel     'Y2U0032'     W0RTN
033100210721     C                   Movel     *Blanks       W0CLPG           10
033200210721     C                   Movel     'A1008000'    W0CLPG
033300210721      * Send message '*Error occured on Call...'
033400210721     C                   Movel     'Y2U0032'     ZAMSID
033500210721     C                   Movel     'Y2USRMSG'    ZAMSGF
033600210721     C                   Movel     W0CLPG        ZAMSDA
033700210721     C                   Exsr      ZASNMS
033800210721     C                   Endif
033900210721
034000210721      ** Error detected?
034100210721     C     W0RTN         Ifne      *Blank
034200210721     C                   Seton                                        9931
034300210721     C                   Endif
034400210721     C                   Movel     'Y'           W0RSF
034500210721     C                   Endif
034600210721     C                   Else
034700210721
034800210721      ** CASE: *Otherwise
034900210721      ** CASE: CTL.*CMD key is *Go to 'Add' mode
035000210721     C     *IN09         Ifeq      '1'
035100210721      * Send message 'Function key not allowed'
035200210721     C                   Movel     'USR0533'     ZAMSID
035300210721     C                   Exsr      ZASNMS
035400210721     C                   Seton                                        99
035500210721      *
035600210721     C                   Endif
035700210721     C                   Endif
035800210721      *
035900210721     CSR   DAEXIT        Endsr
036000210721      /EJECT
036100210721
036200210721      *****************************************************************
036300210721      ** Process modified subfile record
036400210721      *****************************************************************
036500210721     CSR   DBPRSF        Begsr
036600210721      *
036700210721     C                   ReadC     #SFLRCD                                92
036800210721     C     *IN92         Doweq     '0'
036900210721      * Process subfile record
037000210721     C                   Exsr      DCPRSR
037100210721     C                   Update    #SFLRCD
037200210721     C                   ReadC     #SFLRCD                                92
037300210721      *
037400210721     C                   Enddo
037500210721     CSR   DBEXIT        Endsr
037600210721      /EJECT
037700210721
037800210721      *****************************************************************
037900210721      ** Process subfile record
038000210721      *****************************************************************
038100210721     CSR   DCPRSR        Begsr
038200210721
038300210721      ** Setof error indicators and SFLNXTCHG
038400210721     C                   MoveA     WKIND0        *IN(35)
038500210721     C                   Setoff                                       98
038600210721
038700210721      ** USER: Process subfile record (Pre-confirm)
038800210721      ** Enquire Entered. CASE: RCD.*SFLSEL is *Enquire
038900210721     C     #1SEL         Ifeq      'E'
039000210721      * Initialize calling parameters
039100210721     C                   Clear                   PARC
039200210721     C                   Movel     #1BRCA        PABRCA
039300210721      * Call Midas SD Consolidated Branches Maintenance
039400210721     C                   Call      'A1008001'                           90
039500210721     C                   Parm      *Blank        W0RTN             7
039600210721     C                   Parm                    PARC
039700210721     C                   Parm      'E'           WQ0002            1
039800210721      *
039900210721     C     *IN90         Ifeq      '1'
040000210721      * Call to program ended in error
040100210721     C                   Movel     'Y2U0032'     W0RTN
040200210721     C                   Movel     *Blanks       W0CLPG           10
040300210721     C                   Movel     'A1008000'    W0CLPG
040400210721      * Send message '*Error occured on Call...'
040500210721     C                   Movel     'Y2U0032'     ZAMSID
040600210721     C                   Movel     'Y2USRMSG'    ZAMSGF
040700210721     C                   Movel     W0CLPG        ZAMSDA
040800210721     C                   Exsr      ZASNMS
040900210721     C                   Endif
041000210721
041100210721      ** Error detected?
041200210721     C     W0RTN         Ifne      *Blank
041300210721     C                   Seton                                        98
041400210721     C                   Endif
041500210721     C                   Movel     'Y'           W0RSF
041600210721     C                   Endif
041700210721
041800210721      ** Amend or Delete Entered
041900210721      ** CASE: PAR.Display file mode is Maintenance mode
042000210721     C     P1DFMD        Ifeq      'M'
042100210721      *
042200210721      * CASE: RCD.*SFLSEL is *Amend
042300210721     C     #1SEL         Ifeq      'A'
042400210721      * Initialize calling parameters
042500210721     C                   Movel     #1BRCA        PABRCA
042600210721      * Call Midas SD Consolidated Branches Maintenance
042700210721     C                   Call      'A1008001'                           90
042800210721     C                   Parm      *Blank        W0RTN             7
042900210721     C                   Parm                    PARC
043000210721     C                   Parm      'A'           WQ0003            1
043100210721      *
043200210721     C     *IN90         Ifeq      '1'
043300210721      * Call to program ended in error
043400210721     C                   Movel     'Y2U0032'     W0RTN
043500210721     C                   Movel     *Blanks       W0CLPG           10
043600210721     C                   Movel     'A1008000'    W0CLPG
043700210721      * Send message '*Error occured on Call...'
043800210721     C                   Movel     'Y2U0032'     ZAMSID
043900210721     C                   Movel     'Y2USRMSG'    ZAMSGF
044000210721     C                   Movel     W0CLPG        ZAMSDA
044100210721     C                   Exsr      ZASNMS
044200210721     C                   Endif
044300210721
044400210721      ** Error detected?
044500210721     C     W0RTN         Ifne      *Blank
044600210721     C                   Seton                                        98
044700210721     C                   Endif
044800210721     C                   Movel     'Y'           W0RSF
044900210721     C                   Endif
045000210721
045100210721      ** Delete Entered
045200210721      ** CASE: RCD.*SFLSEL is *Delete
045300210721     C     #1SEL         Ifeq      'D'
045400210721      * Initialize calling parameters
045500210721     C                   Clear                   PARC
045600210721     C                   Movel     #1BRCA        PABRCA
045700210721      * Call Midas SD Consolidated Branches Maintenance
045800210721     C                   Call      'A1008001'                           90
045900210721     C                   Parm      *Blank        W0RTN             7
046000210721     C                   Parm                    PARC
046100210721     C                   Parm      'D'           WQ0004            1
046200210721      *
046300210721     C     *IN90         Ifeq      '1'
046400210721      * Call to program ended in error
046500210721     C                   Movel     'Y2U0032'     W0RTN
046600210721     C                   Movel     *Blanks       W0CLPG           10
046700210721     C                   Movel     'A1008000'    W0CLPG
046800210721      * Send message '*Error occured on Call...'
046900210721     C                   Movel     'Y2U0032'     ZAMSID
047000210721     C                   Movel     'Y2USRMSG'    ZAMSGF
047100210721     C                   Movel     W0CLPG        ZAMSDA
047200210721     C                   Exsr      ZASNMS
047300210721     C                   Endif
047400210721
047500210721      ** Error detected?
047600210721     C     W0RTN         Ifne      *Blank
047700210721     C                   Seton                                        98
047800210721     C                   Endif
047900210721     C                   Movel     'Y'           W0RSF
048000210721     C                   Endif
048100210721     C                   Else
048200210721
048300210721      ** CASE: *Otherwise
048400210721      ** Amend entered in Enquiry mode
048500210721      ** CASE: RCD.*SFLSEL is *Amend
048600210721     C     #1SEL         Ifeq      'A'
048700210721      * Setup message data for message
048800210721     C                   Movel     #1SEL         ZA0001
048900210721      * Send message 'value for field not valid'
049000210721     C                   Movel     'USR0553'     ZAMSID
049100210721     C                   Exsr      ZASNMS
049200210721     C                   Seton                                        9835
049300210721      *
049400210721     C                   Goto      DCEXIT
049500210721     C                   Endif
049600210721
049700210721      ** Delete entered in Enquiry mode
049800210721      ** CASE: RCD.*SFLSEL is *Delete
049900210721     C     #1SEL         Ifeq      'D'
050000210721      * Setup message data for message
050100210721     C                   Movel     #1SEL         ZA0002
050200210721      * Send message 'value for field not valid'
050300210721     C                   Movel     'USR0553'     ZAMSID
050400210721     C                   Exsr      ZASNMS
050500210721     C                   Seton                                        9835
050600210721      *
050700210721     C                   Goto      DCEXIT
050800210721     C                   Endif
050900210721     C                   Endif
051000210721
051100210721      ** F3 taken from EDTRCD program
051200210721      ** CASE: PGM.*Return code is *User QUIT requested
051300210721     C     W0RTN         Ifeq      'Y2U9999'
051400210721     C                   Movel     W0RTN         P0RTN
051500210721     C                   Exsr      ZYEXPG
051600210721     C                   Endif
051700210721      *
051800210721     C     *IN98         Ifeq      '1'
051900210721      * SFLRCD invalid
052000210721     C  N99              Z-Add     ##RR          ##SFRC               99
052100210721     C                   Seton                                        84
052200210721     C                   Else
052300210721      * SFLRCD valid.
052400210721     C                   Setoff                                       84
052500210721     C                   Movel     *Blank        #1SEL
052600210721     C                   Endif
052700210721      *
052800210721     CSR   DCEXIT        Endsr
052900210721      /EJECT
053000210721
053100210721      *****************************************************************
053200210721      ** Request subfile reload
053300210721      *****************************************************************
053400210721     CSR   FBRQRL        Begsr
053500210721      *
053600210721     C                   Movel     'Y'           W0RSF
053700210721     C     *IN05         Ifeq      *On
053800210721     C                   Move      *Blanks       #2BRCA
053900210721     C                   Setoff                                       70
054000210721     C                   Endif
054100210721      *
054200210721     CSR   FBEXIT        Endsr
054300210721      /EJECT
054400210721
054500210721      *****************************************************************
054600210721      ** Move A1CONBL1 fields to subfile
054700210721      *****************************************************************
054800210721     CSR   MBFL#1        Begsr
054900210721      *
055000210721     C                   Movel     *Blank        #1SEL
055100210721     C                   Move      FNBRCA        #1BRCA
055200210721      *
055300210721     C                   CALL      'AOBRCHR1'
055400210721     C                   PARM      *BLANKS       @RTCD             7
055500210721     C                   PARM      '*KEY   '     @OPTN             7
055600210721     C                   PARM      FNBRCA        @BRCH             3
055700210721     C     SDBRCH        PARM      SDBRCH        DSSDY
055800210721     C     @RTCD         IFEQ      *BLANKS
055900210721     C                   MOVE      A8BRNM        #1BRNM
056000210721     C                   ELSE
056100210721     C                   MOVE      *BLANKS       #1BRNM
056200210721     C                   ENDIF
056300210721      *
056400210721     CSR   MBEXIT        Endsr
056500210721      /EJECT
056600210721
056700210721      *****************************************************************
056800210721      ** Initialise subfile control
056900210721      *****************************************************************
057000210721     CSR   MEIZ#2        Begsr
057100210721      *
057200210721     C                   Movel     *Blank        #2BRCA
057300210721      *
057400210721     CSR   MEEXIT        Endsr
057500210721      /EJECT
057600210721
057700210721      *****************************************************************
057800210721      ** Set up Display file Header Title
057900210721      *****************************************************************
058000210721     CSR   UASUBR        Begsr
058100210721
058200210721      * CASE: PAR.Display file mode is Enquiry mode
058300210721     C     P1DFMD        Ifeq      'E'
058400210721      * Setup message data for message
058500210721     C                   Movel     'XXUSRMSG'    ZAMSGF
058600210721     C                   Call      'Y2RVMGC'                            90
058700210721     C                   Parm      *Blank        W0RTN             7
058800210721     C                   Parm      'XXX1180'     ZAMSID            7
058900210721     C                   Parm                    ZAMSGF           10
059000210721     C                   Parm                    ZAMSDA          132
059100210721     C     WUDFTL        Parm                    W0MTX           132
059200210721     C                   Movel     *Blank        ZAMSDA
059300210721     C                   Movel     *Blank        ZAMSGF
059400210721     C                   Else
059500210721
059600210721      * CASE: PAR.Display file mode is Maintenance mode
059700210721     C     P1DFMD        Ifeq      'M'
059800210721      * Setup message data for message
059900210721     C                   Movel     'XXUSRMSG'    ZAMSGF
060000210721     C                   Call      'Y2RVMGC'                            90
060100210721     C                   Parm      *Blank        W0RTN             7
060200210721     C                   Parm      'XXX1181'     ZAMSID            7
060300210721     C                   Parm                    ZAMSGF           10
060400210721     C                   Parm                    ZAMSDA          132
060500210721     C     WUDFTL        Parm                    W0MTX           132
060600210721     C                   Movel     *Blank        ZAMSDA
060700210721     C                   Movel     *Blank        ZAMSGF
060800210721     C                   Endif
060900210721     C                   Endif
061000210721      * Move to Header Title - Standard Functions  *
061100210721     C                   Movel     WUDFTL        ##URPT
061200210721      *
061300210721     CSR   UAEXIT        Endsr
061400210721      /EJECT
061500210721
061600210721      *****************************************************************
061700210721      ** Set up Display file Footers
061800210721      *****************************************************************
061900210721     CSR   UBSUBR        Begsr
062000210721
062100210721      * CASE: PAR.Display file mode is Enquiry mode
062200210721     C     P1DFMD        Ifeq      'E'
062300210721      * Setup message data for message
062400210721     C                   Movel     ZADFMF        ZAMSGF
062500210721     C                   Call      'Y2RVMGC'                            90
062600210721     C                   Parm      *Blank        W0RTN             7
062700210721     C                   Parm      'USR2911'     ZAMSID            7
062800210721     C                   Parm                    ZAMSGF           10
062900210721     C                   Parm                    ZAMSDA          132
063000210721     C     WUSFT1        Parm                    W0MTX           132
063100210721     C                   Movel     *Blank        ZAMSDA
063200210721     C                   Movel     *Blank        ZAMSGF
063300210721      * Setup message data for message
063400210721     C                   Movel     ZADFMF        ZAMSGF
063500210721     C                   Call      'Y2RVMGC'                            90
063600210721     C                   Parm      *Blank        W0RTN             7
063700210721     C                   Parm      'USR2912'     ZAMSID            7
063800210721     C                   Parm                    ZAMSGF           10
063900210721     C                   Parm                    ZAMSDA          132
064000210721     C     WUSFT2        Parm                    W0MTX           132
064100210721     C                   Movel     *Blank        ZAMSDA
064200210721     C                   Movel     *Blank        ZAMSGF
064300210721     C                   Else
064400210721
064500210721      * CASE: PAR.Display file mode is Maintenance mode
064600210721     C     P1DFMD        Ifeq      'M'
064700210721      * Setup message data for message
064800210721     C                   Movel     ZADFMF        ZAMSGF
064900210721     C                   Call      'Y2RVMGC'                            90
065000210721     C                   Parm      *Blank        W0RTN             7
065100210721     C                   Parm      'USR2913'     ZAMSID            7
065200210721     C                   Parm                    ZAMSGF           10
065300210721     C                   Parm                    ZAMSDA          132
065400210721     C     WUSFT1        Parm                    W0MTX           132
065500210721     C                   Movel     *Blank        ZAMSDA
065600210721     C                   Movel     *Blank        ZAMSGF
065700210721      * Setup message data for message
065800210721      * Retrieve message STD FTR:DSPFIL Maint/2
065900210721     C                   Movel     ZADFMF        ZAMSGF
066000210721     C                   Call      'Y2RVMGC'                            90
066100210721     C                   Parm      *Blank        W0RTN             7
066200210721     C                   Parm      'USR2914'     ZAMSID            7
066300210721     C                   Parm                    ZAMSGF           10
066400210721     C                   Parm                    ZAMSDA          132
066500210721     C     WUSFT2        Parm                    W0MTX           132
066600210721     C                   Movel     *Blank        ZAMSDA
066700210721     C                   Movel     *Blank        ZAMSGF
066800210721     C                   Endif
066900210721     C                   Endif
067000210721      * Move to Double Footer - Standard Functions  *
067100210721     C                   Movel     WUSFT1        ##CTX1
067200210721     C                   Movel     WUSFT2        ##CTX2
067300210721      *
067400210721     CSR   UBEXIT        Endsr
067500210721      /EJECT
067600210721
067700210721      *****************************************************************
067800210721      ** Send message to program's message queue
067900210721      *****************************************************************
068000210721     CSR   ZASNMS        Begsr
068100210721      *
068200210721     C     ZAPGMQ        Ifeq      *Blank
068300210721     C                   Movel     ##PGM         ZAPGMQ
068400210721     C                   Endif
068500210721      * If no message file specified, use default
068600210721     C     ZAMSGF        Ifeq      *Blank
068700210721     C                   Movel     ZADFMF        ZAMSGF
068800210721     C                   Endif
068900210721      *
069000210721     C                   Call      'Y2SNMGC'
069100210721     C                   Parm                    ZAPGMQ           10
069200210721     C                   Parm                    ZAPGRL            5
069300210721     C                   Parm                    ZAMSID            7
069400210721     C                   Parm                    ZAMSGF           10
069500210721     C                   Parm                    ZAMSDA          132
069600210721     C                   Parm                    ZAMSTP            7
069700210721      * Clear all fields for default mechanism next time
069800210721     C                   Movel     *Blank        ZAPGMQ
069900210721     C                   Movel     *Blank        ZAPGRL
070000210721     C                   Movel     *Blank        ZAMSID
070100210721     C                   Movel     *Blank        ZAMSGF
070200210721     C                   Movel     *Blank        ZAMSDA
070300210721     C                   Movel     *Blank        ZAMSTP
070400210721      *
070500210721     CSR   ZAEXIT        Endsr
070600210721      /EJECT
070700210721
070800210721      *****************************************************************
070900210721      ** Cancel & exit program
071000210721      *****************************************************************
071100210721     CSR   ZXEXPG        Begsr
071200210721
071300210721      ** USER: Exit program processing
071400210721     C                   Exsr      ZYEXPG
071500210721      *
071600210721     CSR   ZXEXIT        Endsr
071700210721      /EJECT
071800210721
071900210721      *****************************************************************
072000210721      ** Exit program: Direct
072100210721      *****************************************************************
072200210721     CSR   ZYEXPG        Begsr
072300210721
072400210721      ** Exit program
072500210721     C                   RETURN
072600210721      *
072700210721     CSR   ZYEXIT        Endsr
072800210721      /EJECT
072900210721
073000210721      *****************************************************************
073100210721      ** Initialisation
073200210721      *****************************************************************
073300210721     CSR   ZZINIT        Begsr
073400210721      *
073500210721      *
073600210721      ** Check for switchable feature BA1007                                    BA1007
073700210721     C                   Call      'AOSARDR0'                                   BA1007
073800210721     C                   Parm      *Blanks       @RTCD             7            BA1007
073900210721     C                   Parm      '*VERIFY'     @OPTN             7            BA1007
074000210721     C                   Parm      'BA1007'      @SARD             6            BA1007
074100210721     C     SCSARD        Parm      SCSARD        DSFDY                          BA1007
074200210721                                                                                BA1007
074300210721     C                   If        @RTCD = *Blanks                              BA1007
074400210721     C                   Movel     'Y'           BA1007            1            BA1007
074500210721     C                   Else                                                   BA1007
074600210721     C                   Movel     'N'           BA1007                         BA1007
074700210721     C                   EXSR      ZYEXPG                                       BA1007
074800210721     C                   EndIf                                                  BA1007
074900210721      *
075000210721     C                   Move      *Blank        P0RTN
075100210721     C                   Move      *Blank        W0RTN             7
075200210721     C                   Movel     *Blank        W0RSL             1
075300210721     C                   Movel     *Blank        W0RSF             1
075400210721      * Initialise indicators for re-entry
075500210721     C                   Move      '0'           *IN
075600210721      * Update screen time
075700210721     C                   Time                    ##TME             6 0
075800210721      * Obtain default message file
075900210721     C     *Dtaara       Define    Y2MGFLA       ZADFMF           10
076000210721     C                   In        ZADFMF
076100210721      * Define work field Midas Run Date
076200210721     C                   Movel     *Blank        WUMRDT            7
076300210721      * Define work field Run day number
076400210721     C                   Z-Add     *Zero         WURDNB            5 0
076500210721      * Define work field Set Up Complete
076600210721     C                   Movel     *Blank        WUSUC             1
076700210721      * Define work field Date format flag
076800210721     C                   Movel     *Blank        WUDFF             1
076900210721      * Define work field Multi-branching Indicator
077000210721     C                   Movel     *Blank        WUMBIN            1
077100210721      * Define work field Display File Title
077200210721     C                   Movel     *Blank        WUDFTL           53
077300210721      * Define work field STD FTR 1
077400210721     C                   Movel     *Blank        WUSFT1           78
077500210721      * Define work field STD FTR 2
077600210721     C                   Movel     *Blank        WUSFT2           78
077700210721      * Open files first time only
077800210721     C     W0OPN         Ifeq      *Blank
077900210721     C                   Open      A1008000DF
078000210721     C                   Open      A1CONBL1
078100210721      * Signal that files are now Open
078200210721     C                   Move      'Y'           W0OPN             1
078300210721     C                   Endif
078400210721      *
078500210721     C                   Movel     'N'           W0PMT             1
078600210721     C                   Z-Add     13            ##SFPG            3 0
078700210721     C                   Z-Add     1             ##SFRC
078800210721      * Maximum record number
078900210721     C                   Z-Add     *Zero         ##RRMX
079000210721      * Scan limit
079100210721     C                   Z-Add     500           W0SLM             5 0
079200210721      * subfile pages
079300210721     C                   Z-Add     1             W0SPG             3 0
079400210721      * Processed subfile record
079500210721     C                   Z-Add     0             W0RR0             4 0
079600210721
079700210721      ** USER: Initialize program
079800210721      ** Copyright and rundate setup
079900210721     C     *Dtaara       Define                  RUNDAT
080000210721     C                   In        RUNDAT
080100210721     C                   Move      MRDT          ##MRDT            7
080200210721     C                   Move      MRDT          WUMRDT
080300210721     C                   Move      RDNB          WURDNB
080400210721     C                   Move      SUC           WUSUC
080500210721     C                   Move      DFF           WUDFF
080600210721     C                   Move      MBIN          WUMBIN
080700210721      * Set up Display file Header Title
080800210721     C                   Exsr      UASUBR
080900210721      * Set up Display file Footers
081000210721     C                   Exsr      UBSUBR
081100210721     C                   Z-Add     99999         W0SLM
081200210721      * Initialise subfile control
081300210721     C                   Exsr      MEIZ#2
081400210721      *
081500210721     CSR   ZZEXIT        Endsr
081600210721      /EJECT
081700210721
081800210721      *****************************************************************
081900210721      **
082000210721      ** *PSSR  - Program exception error routine
082100210721      **          Called automatiCally if a program error occurs,
082200210721      **          or directly by the program code using Exsr.
082300210721      **          This Subroutine DUMPs the program just once.
082400210721      **
082500210721      *****************************************************************
082600210721     CSR   *PSSR         Begsr
082700210721      *  Standard Midas PSSR processing.
082800210721     C     @RUN          Ifeq      *Blank
082900210721     C                   Move      'Y'           @RUN              1
083000210721     C                   Move      'PSSR   '     P0RTN
083100210721     C                   DUMP
083200210721      *  Route job back into Midas.
083300210721     C                   Seton                                        LR
083400210721     C                   Call      'DBERRCTL'
083500210721     C                   Endif
083600210721      *
083700210721     CSR                 Endsr
083800210721      *****************************************************************
