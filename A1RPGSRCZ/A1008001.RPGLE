000100000000     H DEBUG DATEDIT(*YMD)
000200000000      *****************************************************************
000300000000/*STD *  RPGBASEBND                                                   *
000400000000/*EXI *  TEXT('Midas SD Consolidation Replication Maintenance')       *
000500000000      *****************************************************************
000600000000      *                                                               *
000700000000      *  Midas - Standing Data Module                                 *
000800000000      *                                                               *
000900000000      *  A1008001 - Midas SD Consolidation Replication Maintenance    *
001000000000      *                                                               *
001100000000      *  Function:  This program allows Enquire, Amend, Insert        *
001200000000      *             and logical Delete for a Consolidated Branch      *
001300000000      *                                                               *
001400000000      *  Called By: A1008000 - Reserved Batch Numbers Enquiry         *
001500000000      *                                                               *
001501210604      *  (c) Finastra International Limited 2021                      *
001502210604      *                                                               *
001503210604      *  Last Amend No. BA1008   *Create   Date 03Jun21               *
001504210604      *                                                               *
001505210604      *-------------------------------------------------------------- *
001506210604      *                                                               *
001507210604      *  BA1008 - Replication of Trades to consolidated branches      *
001508210604      *                                                               *
002400000000      *****************************************************************
002500000000      *
002600000000      ** Consolidated Branches Maintenance
002700000000     FA1008001DFCF   E             Workstn Usropn
002800000000     F                                     Infds(Infds#)
002900000000     F                                     Infsr(*PSSR)
003000000000
003100000000      ** Midas SD Consolidated Branches - Retrieval
003200000000     FA1CONBL1  IF   E           K DISK    Usropn
003300000000     F                                     Infds(Infds1)
003400000000     F                                     Infsr(*PSSR)
003500210604     F                                     Rename(A1CONBPF:XXCONBDB)
003600000000
003700000000      ** Midas SD Consolidated Branches - Update
003800000000     FA1CONBL0  UF A E           K DISK    Usropn
003900000000     F                                     Commit
004000000000     F                                     Infds(ID0001)
004100000000     F                                     Infsr(*PSSR)
004200210604     F                                     Rename(A1CONBPF:XXCONBDA)
004300000000      *
004400000000     FA1CONBPD  IF   E             DISK    INFSR(*pssr)
004500000000      /EJECT
004600000000
004700000000      *****************************************************************
004800000000      ** +-------------------------------+
004900000000      ** ¦ Data structures specification |
005000000000      ** +-------------------------------+
005100000000
005200000000      * Pgm Data srtucture
005300000000     D PGMDS         ESDs                  Extname(Y2PGDSP)
005400000000
005500000000      ** Display file information data structure
005600000000     D Infds#        E Ds                  Extname(Y2I#DSP)
005700000000
005800000000      ** File information data structure
005900000000     D Infds1        E Ds                  Extname(Y2I1DSP)
006000000000
006100000000      ** RBNO Code Details
006200000000     D @1DBRC        E Ds                  Extname(A1CONBL0)
006300000000
006400000000      ** Long DS for access programs
006500000000     D DSSDY         E Ds                  Extname(DSSDY)
006600000000
006700000000      ** Stored master file format fields
006800000000     D #1DBRC          Ds           222
006900000000     D  #1DB1                  1     12S 0
007000000000     D  #1DB2                 13     47
007100000000     D  #1DB3                 48     77
007200000000     D  #1DB4                 78     83
007300000000     D  #1DB5                 84    103
007400000000     D  #1DB6                104    138
007500000000     D  #1DB7                139    173
007600000000     D  #1DB8                174    208
007700000000     D  #1DB9                209    218
007800000000     D  #1DB10               219    219
007900000000     D  #1DB11               220    222P 0
008000000000
008100000000      ** Standing data controls update
008200000000     D YBRDCS          Ds           222
008300000000     D YCRDCS          Ds           222
008400000000
008500000000      ** Run date
008600000000     D RUNDAT          Ds
008700000000     D  MRDT                   1      7
008800000000     D  RDNB                   8     10P 0
008900000000     D  SUC                   11     11
009000000000     D  DFF                   12     12
009100000000     D  MBIN                  13     13
009200000000
009300000000      ** File information data structure
009400000000     D ID0001          Ds           528
009500000000
009600000000      ** File information data structure
009700000000     D ID0002          Ds           528
009800000000
009900000000      ** Parameter declarations
010000000000     D P1Parm          Ds            52
010100000000     D  P1BRCA                 1      3
010200000000     D  P1CUST                 4     10
010300000000     D  P1AUTH                11     11
010400000000
010500000000      ** MAP Action Code
010600000000     D P2Parm          Ds
010700000000     D  P2ANCD                 1      1
010800000000
010900000000     D                 Ds
011000000000     D  ZAMSDA                 1    132
011100000000     D  ZA0001                 1      3
011200000000     D  ZA0002                 1      6
011300000000
011400000000      ** Renamed input format fields
011500000000     IXXCONBDB
011600000000     I              FNBRCA                      WABRCA
011700000000      /EJECT
011800000000
011900000000      *****************************************************************
012000000000      ** Entry parameters
012100000000      *****************************************************************
012200000000      *
012300000000     C     *Entry        Plist
012400000000     C                   Parm                    P0RTN             7
012500000000     C                   Parm                    P1Parm
012600000000     C     P2ANCD        Parm                    WP0001            1
012700000000      * Initialize
012800000000     C                   Exsr      ZZINIT
012900000000      *
013000000000      * Check passed parameters
013100000000     C                   Exsr      FACKPM
013200000000      * Perform once if all passed, Else repeat
013300000000     C     W0RPT         Doueq     'N'
013400000000      * Display and process key screen
013500000000     C                   Exsr      BADSKY
013600000000     C                   Enddo
013700000000      * Terminate program
014000000000     C                   Exsr      ZXEXPG
014100000000      *
014200000000      /EJECT
014300000000
014400000000      *****************************************************************
014500000000      ** Display and process key screen
014600000000      *****************************************************************
014700000000     CSR   BADSKY        Begsr
014800000000
014900000000      ** Initialize key screen
015000000000     C                   Exsr      MDIZ#K
015100000000
015200000000      ** Bypass first display of key screen is possible
015300000000     C                   Movel     'Y'           W0BYP             1
015400000000      * Signal start of transaction
015500000000     C                   Movel     'Y'           W0TRN             1
015600000000     C     W0TRN         Doweq     'Y'
015700000000     C     W0TRN         Oreq      'K'
015800000000      * Ensure transaction continues (if reset)
015900000000     C                   Movel     'Y'           W0TRN             1
016000000000      * Conduct screen conversation
016100000000     C     W0TRN         Doweq     'Y'
016200000000      * Is bypass key screen still viable?
016300000000     C     W0BYP         Ifeq      'Y'
016400000000     C     #1BRCA        Ifeq      *Blanks
016500000000      * One or more key fields is Blank
016600000000     C     *IN05         Oreq      '1'
016700000000      * HOME: Reset screen fields
016800000000     C                   Movel     'N'           W0BYP
016900000000     C                   Endif
017000000000     C                   Endif
017100000000
017200000000      ** Bypass key screen
017300000000     C     W0BYP         Ifne      'Y'
017400000000      * Display key screen
017500000000     C                   Exsr      BBEXFM
017600000000     C                   Endif
017700000000
017800000000      ** Cancel key screen bypass
017900000000     C                   Movel     'N'           W0BYP
018000000000
018100000000      ** Process response to key screen
018200000000      ** Cancel & exit program
018300000000     C   03              Cas                     ZXEXPG
018400000000
018500000000      ** Switch between *ADD/*CHANGE modes
018600000000     C   09              Cas                     BCCHMD
018700000000
018800000000      ** HOME: Reset screen fields
018900000000     C   05              Cas                     BDHMKY
019000000000
019100000000      ** Process key screen input
019200000000     C                   Cas                     BEPRKY
019300000000     C                   End
019400000000      *
019500000000     C     W0TRN         Doweq     'R'
019600000000     C                   Movel     'Y'           W0TRN
019700000000     C                   Exsr      BEPRKY
019800000000     C                   Enddo
019900000000      *
020000000000     C                   Enddo
020100000000     C                   Enddo
020200000000      *
020300000000     CSR   BAEXIT        Endsr
020400000000      /EJECT
020500000000
020600000000      *****************************************************************
020700000000      * Display key screen
020800000000      *****************************************************************
020900000000     CSR   BBEXFM        Begsr
021000000000
021100000000      **Set screen conditioning indicators
021200000000     C                   Exsr      GADSAK
021300000000      * Update screen Time
021400000000     C                   Time                    ##TME
021500000000     C     W0HLP         Doueq     'N'
021600000000     C                   Movel     'N'           W0HLP             1
021700000000     C                   Move      *ALL'0'       ##OFF            30
021800000000     C                   MoveA     ##OFF         *IN(1)
021900000000
022000000000      ** PUTOVR unless conditioned fields change
022100000000     C                   Seton                                            86
022200000000     C     *IN89         Ifne      BBIN89
022300000000     C                   Setoff                                           86
022400000000     C                   Endif
022500000000     C                   Move      *IN89         BBIN89            1
022600000000
022700000000      ** Display Prompt 1
022800000000     C                   Write     #MSGCTL
022900000000     C                   Write     #CMDTXT1
023000000000     C                   Exfmt     #RCDKEY
023100000000      *
023200000000     C                   Enddo
023300000000      * Clear messages from program message queue
023400000000     C                   Call      'Y2CLMSC'
023500000000     C                   Parm      ##PGM         ZAPGMQ           10
023600000000     C                   Parm      '*SAME'       ZAPGRL            5
023700000000      * Reset first message only flag
023800000000     C                   Movel     'Y'           ZAFSMS            1
023900000000      * Reset global error indicator
024000000000     C                   Setoff                                           99
024100000000      *
024200000000     CSR   BBEXIT        Endsr
024300000000      /EJECT
024400000000
024500000000      *****************************************************************
024600000000      ** Switch between *ADD/*CHANGE modes
024700000000      *****************************************************************
024800000000     CSR   BCCHMD        Begsr
024900000000      *
025000000000     C     W0PMD         Ifeq      'ADD'
025100000000     C                   Movel     'CHG'         W0PMD             3
025200000000     C                   Else
025300000000     C                   Movel     'ADD'         W0PMD
025400000000      *
025500000000     C                   End
025600000000      *
025700000000     CSR   BCEXIT        Endsr
025800000000      /EJECT
025900000000
026000000000      *****************************************************************
026100000000      ** Process HOME key
026200000000      *****************************************************************
026300000000     CSR   BDHMKY        Begsr
026400000000      *
026500000000     C                   Movel     'N'           W0TRN
026600000000      *
026700000000     CSR   BDEXIT        Endsr
026800000000      /EJECT
026900000000
027000000000      *****************************************************************
027100000000      ** Process key screen input
027200000000      *****************************************************************
027300000000     CSR   BEPRKY        Begsr
027400000000
027500000000      ** Initialise detail screen
027600000000     C                   Exsr      MAIZ#1
027700000000
027800000000      ** Validate key fields
027900000000     C                   Exsr      BFVLKY
028000000000     C     *IN99         CabEq     '1'           BEEXIT
028100000000
028200000000      ** Check for existing record
028300000000     C     KRTV          Klist
028400000000     C                   Kfld                    FNBRCA
028500000000      * Setup key
028600000000     C                   Move      #1BRCA        FNBRCA
028700000000     C     KRTV          Chain     XXCONBDB                           9091
028800000000     C     *IN91         Ifeq      '1'
028900000000      * Record locked
029000000000     C                   Seton                                        9931
029100000000     C                   Goto      BEEXIT
029200000000     C                   Endif
029300000000
029400000000      ** If record does not exist, flip to add mode
029500000000     C     *IN90         Ifeq      '1'
029600000000     C                   Movel     'ADD'         W0PMD
029700000000      * Set up Detail Screen Header Title
029800000000     C                   Exsr      UASUBR
029900000000      * Set up Detail Screen Footer
030000000000     C                   Exsr      UBSUBR
030100000000      *
030200000000     C                   Else
030300000000      * If record does exist, flip to change mode
030400000000     C                   Movel     'CHG'         W0PMD
030500000000      * Load screen fields from DBF
030600000000     C                   Exsr      MBFL#1
030700000000      * Set up Detail Screen Header Title
030800000000     C                   Exsr      UCSUBR
030900000000      * Set up Detail Screen Footer
031000000000     C                   Exsr      UDSUBR
031100000000     C*
031200000000     C                   Endif
031300000000      *
031400000000     C   99              Goto      BEEXIT
031500000000
031600000000      ** No error: Display and process details
031700000000     C                   Exsr      CADSDA
031800000000      *
031900000000     CSR   BEEXIT        Endsr
032000000000      /EJECT
032100000000
032200000000      *****************************************************************
032300000000      * Validate key fields
032400000000      *****************************************************************
032500000000     CSR   BFVLKY        Begsr
032600000000
032700000000      ** Validate entries
032800000000B1   C                   If        P2ANCD = 'I'
032900000000     C                   Setoff                                       993132
033000000000
033100000000      ** BRCA validation
033200000000
033300000000      ** Check for existing record
033400000000     C                   Move      #1BRCA        FNBRCA
033500000000     C     KRTV          Chain     XXCONBDB                           90
033600000000B2   C                   If        *IN90 = *off
033700000000      * Duplicate BRCA entered
033800000000     C                   Seton                                        99
033900000000     C                   Seton                                        31
034000000000     C                   Movel     'XXX1183'     ZAMSID
034100000000     C                   Movel     'XXUSRMSG'    ZAMSGF
034200000000     C                   Exsr      ZASNMS
034300000000E1   C                   Endif
034400000000      *
034500000000X2   C                   Else
034600000000     C                   Move      #1BRCA        FNBRCA
034700000000      *
034800000000E1   C                   Endif
034900000000      *
035000000000     CSR   BFEXIT        Endsr
035100000000      /EJECT
035200000000
035300000000      *****************************************************************
035400000000      ** Display and process detail screen
035500000000      *****************************************************************
035600000000     CSR   CADSDA        Begsr
035700000000
035800000000      ** Repeat until screen control flag is reset:
035900000000     C     W0TRN         DOWEQ     'Y'
036000000000      * Display detail screen
036100000000     C                   Exsr      CBEXFM
036200000000      * Process response to detail screen
036300000000      * Cancel & exit program
036400000000     C   03              Cas                     ZXEXPG
036500000000      * Redisplay previous screen
036600000000     C   12              Cas                     CCDSPV
036700000000      * HOME: Reset screen fields
036800000000     C   05              Cas                     CCDSPV
036900000000      * Process detail screen input
037000000000     C                   Cas                     CFPRSC
037100000000     C                   End
037200000000      *
037300000000     C     W0TRN         Ifeq      'R'
037400000000     C     W0PMD         Ifeq      'ADD'
037500000000     C                   Exsr      MAIZ#1
037600000000     C                   Endif
037700000000     C                   Endif
037800000000      *
037900000000     C                   Enddo
038000000000      *
038100000000     CSR   CAEXIT        Endsr
038200000000      /EJECT
038300000000
038400000000      *****************************************************************
038500000000      ** Display screen
038600000000      *****************************************************************
038700000000     CSR   CBEXFM        Begsr
038800000000
038900000000      ** Set screen conditioning indicators
039000000000     C                   Exsr      GBDSAD
039100000000
039200000000      ** Update screen Time
039300000000     C                   Time                    ##TME
039400000000     C     W0HLP         Doueq     'N'
039500000000     C                   Movel     'N'           W0HLP             1
039600000000     C                   Move      *ALL'0'       ##OFF            30
039700000000     C                   MoveA     ##OFF         *IN(1)
039800000000
039900000000      ** PUTOVR unless conditioned fields change
040000000000     C                   Seton                                            86
040100000000     C     *IN89         Ifne      CBIN89
040200000000     C                   Setoff                                           86
040300000000     C                   Endif
040400000000     C                   Move      *IN89         CBIN89            1
040500000000
040600000000     C                   Write     #MSGCTL
040700000000     C                   Write     #CMDTXT2
040800000000     C                   Exfmt     #RCDDTL1
040900000000
041000000000     C                   Enddo
041100000000      * Clear messages from program message queue
041200000000     C                   Call      'Y2CLMSC'
041300000000     C                   Parm      ##PGM         ZAPGMQ           10
041400000000     C                   Parm      '*SAME'       ZAPGRL            5
041500000000      * Reset first message only flag
041600000000     C                   Movel     'Y'           ZAFSMS            1
041700000000      * Reset global error indicator
041800000000     C                   Setoff                                           99
041900000000      *
042000000000     CSR   CBEXIT        Endsr
042100000000      /EJECT
042200000000
042300000000      *****************************************************************
042400000000      ** Redisplay previous screen
042500000000      *****************************************************************
042600000000     CSR   CCDSPV        Begsr
042700000000
042800000000      ** Case: PAR.Action Code is Insert
042900000000     C     P2ANCD        Ifeq      'I'
043000000000      * Set up Key Screen Header Title
043100000000     C                   Exsr      UFSUBR
043200000000      * Set up Key Screen Footer
043300000000     C                   Exsr      UGSUBR
043400000000     C                   Else
043500000000      * Case: *Otherwise
043600000000     C                   Movel     'USR0790'     P0RTN
043700000000     C                   Exsr      ZYEXPG
043800000000     C                   Endif
043900000000      *
044000000000     C   05              Movel     'R'           W0TRN
044100000000     C   12              Movel     'K'           W0TRN
044200000000      *
044300000000     CSR   CCEXIT        Endsr
044400000000      /EJECT
044500000000
044600000000      *================================================================
044700000000      * Validate record
044800000000      *================================================================
044900000000     CSR   CFPRSC        Begsr
045000000000
045100000000      ** Confirm/update is not deferred
045200000000     C                   Movel     'N'           W0DCF             1
045300000000      * Validate details
045400000000     C  N10              Cas                     DCVLDL
045500000000     C                   End
045600000000      * QUIT if error:
045700000000     C   99              Goto      CFEXIT
045800000000      * Redisplay if change of customer entry.
045900000000     C   98              Goto      CFEXIT
046000000000      * Defer confirm/update requested
046100000000     C     W0DCF         CabEq     'Y'           CFEXIT
046200000000
046300000000      ** No error: update record
046400000000     C                   Exsr      EBPR##
046500000000      *
046600000000     CSR   CFEXIT        Endsr
046700000000      /EJECT
046800000000
046900000000      *****************************************************************
047000000000      ** Validate details
047100000000      *****************************************************************
047200000000     CSR   DCVLDL        Begsr
047300000000
047400000000      ** USER: Validate detail screen relations
047500000000     C                   Setoff                                       98
047600000000      *
047700000000     C     WP0001        Ifne      'E'
047800000000     C     W0PMD         Ifeq      'ADD'
047900000000     C     W0PMD         Oreq      'CHG'
048000000000      *
048100000000     C                   Setoff                                       993141
048200000000     C                   Setoff                                       32
048300000000     C                   Setoff                                       424344
048400000000
048500000000      ** Check if record exists - BRCA
048600000000     C     W0PMD         Ifeq      'ADD'
048700000000     C                   Exsr      SDRVGN
048800000000
048900000000      ** Case: PGM.*Return code is *Record already exists
049000000000     C     W0RTN         Ifeq      'Y2U0003'
049100000000      * Send message 'RBNO Rec exists'
049200000000     C                   Movel     'XXX1183'     ZAMSID
049300000000     C                   Movel     'XXUSRMSG'    ZAMSGF
049400000000     C                   Exsr      ZASNMS
049500000000     C                   Seton                                        9941
049600000000     C                   Goto      DCEXIT
049700000000     C                   Endif
049800000000     C                   Endif
049900000000      *
050000000000     C                   Endif
050100000000     C                   Endif
050200000000      *
050300000000     CSR   DCEXIT        Endsr
050400000000      /EJECT
050500000000
050600000000      *****************************************************************
050700000000      ** Process record:
050800000000      *****************************************************************
050900000000     CSR   EBPR##        Begsr
051000000000
051100000000      ** Process delete request
051200000000     C   10              Cas                     EDDLRQ
051300000000
051400000000      ** Process add request
051500000000     C     W0PMD         CaseQ     'ADD'         ECADRQ
051600000000
051700000000      ** Process update request
051800000000     C     W0PMD         CasNE     'ADD'         EECHRQ
051900000000     C                   End
052000000000
052100000000      ** Error: ROLLBACK any DBF changes
052200000000     C     W0RTN         Ifne      *Blank
052300000000     C                   Rolbk
052400000000     C                   Goto      EBEXIT
052500000000     C                   Else
052600000000      * Otherwise Commit any DBF changes
052700000000     C                   Commit
052800000000     C                   Endif
052900000000
053000000000      ** USER: Process command keys
053100000000     C     W0RTN         Ifeq      *Blank
053200000000     C     W0PMD         Ifeq      'ADD'
053300000000      * Exit after successful add
053400000000     C                   Movel     'N'           W0RPT
053500000000     C                   Endif
053600000000      * Restart program for next record
053700000000     C                   Movel     'N'           W0TRN
053800000000     C                   Endif
053900000000      *
054000000000     CSR   EBEXIT        Endsr
054100000000      /EJECT
054200000000
054300000000      *****************************************************************
054400000000      ** Process add request
054500000000      *****************************************************************
054600000000     CSR   ECADRQ        Begsr
054700000000
054800000000      ** Create RBNO Range
054900000000     C                   Exsr      SECRRC
055000000000     C     W0RTN         Ifeq      *Blank
055100000000      * Send message '*Record added'
055200000000     C                   Movel     'Y2U0011'     ZAMSID
055300000000     C                   Movel     'Y2USRMSG'    ZAMSGF
055400000000     C                   Exsr      ZASNMS
055500000000     C                   Endif
055600000000      *
055700000000     CSR   ECEXIT        Endsr
055800000000      /EJECT
055900000000
056000000000      *****************************************************************
056100000000      ** Process delete request
056200000000      *****************************************************************
056300000000     CSR   EDDLRQ        Begsr
056400000000
056500000000      ** Physical delete RBNO
056600000000     C                   Exsr      SGCHRC
056700000000     C     W0RTN         Ifeq      *Blank
056800000000      * Send message '*Record deleted'
056900000000     C                   Movel     'Y2U0013'     ZAMSID
057000000000     C                   Movel     'Y2USRMSG'    ZAMSGF
057100000000     C                   Exsr      ZASNMS
057200000000     C                   Endif
057300000000      *
057400000000     CSR   EDEXIT        Endsr
057500000000      /EJECT
057600000000
057700000000      *****************************************************************
057800000000      ** Process update request
057900000000      *****************************************************************
058000000000     CSR   EECHRQ        Begsr
058100000000
058200000000      ** Change RBNO
058300000000     C     WP0001        Ifne      'E'
058400000000     C                   Exsr      SHCHRC
058500000000     C     W0RTN         Ifne      *Blank
058600000000      * Reset screen fields if changed record
058700000000     C     W0RTN         CaseQ     'Y2U0007'     MBFL#1
058800000000     C                   End
058900000000     C                   Else
059000000000      * Send message '*Record changed'
059100000000     C                   Movel     'Y2U0012'     ZAMSID
059200000000     C                   Movel     'Y2USRMSG'    ZAMSGF
059300000000     C                   Exsr      ZASNMS
059400000000     C                   Endif
059500000000     C                   Endif
059600000000      *
059700000000     CSR   EEEXIT        Endsr
059800000000      /EJECT
059900000000
060000000000      *****************************************************************
060100000000      ** Check passed parameters
060200000000      *****************************************************************
060300000000     CSR   FACKPM        Begsr
060400000000      * Is full key present?
060500000000     C     P1BRCA        Ifeq      *Blanks
060600000000      * Not every key field passed - loop program
060700000000     C                   Movel     'Y'           W0RPT             1
060800000000     C                   Else
060900000000      * Full key passed, so single shot program
061000000000     C                   Movel     'N'           W0RPT
061100000000     C                   Endif
061200000000      *
061300000000     CSR   FAEXIT        Endsr
061400000000      /EJECT
061500000000
061600000000      *****************************************************************
061700000000      ** Set key screen conditioning indicators
061800000000      *****************************************************************
061900000000     CSR   GADSAK        Begsr
062000000000      *
062100000000     C     W0PMD         COMP      'ADD'                                  89
062200000000      *
062300000000     CSR   GAEXIT        Endsr
062400000000      /EJECT
062500000000
062600000000      *****************************************************************
062700000000      ** Set detail screen conditioning indicators
062800000000      *****************************************************************
062900000000     CSR   GBDSAD        Begsr
063000000000      *
063100000000     C     W0PMD         Comp      'ADD'                                  89
063200000000      * Protect key fields on detail screen
063300000000     C                   Seton                                        88
063400000000     C                   Movel     '0'           *IN79
063500000000     C                   Movel     '0'           *IN80
063600000000      *
063700000000     C     WUOFIN        Ifeq      'Y'
063800000000     C                   Movel     '1'           *IN79
063900000000     C                   Movel     '1'           *IN80
064000000000     C                   Endif
064100000000      *
064200000000     C                   Movel     '0'           *IN78
064300000000     C     W0PMD         Ifeq      'ADD'
064400000000     C                   Movel     '1'           *IN78
064500000000     C                   Endif
064600000000      * Enable key screen
064700000000     C                   Seton                                        87
064800000000      *
064900000000     CSR   GBEXIT        Endsr
065000000000      /EJECT
065100000000
065200000000      *****************************************************************
065300000000      * Initialise record - except for key fields
065400000000      *================================================================
065500000000     CSR   MAIZ#1        Begsr
065600000000      *
065700000000     C                   Movel     P2ANCD        #PANCD
065800000000      *
065900000000     C                   If        P2ANCD = 'I'
066000000000     C                   Movel     *Blanks       #1CUST
066100000000     C                   Movel     *Blanks       #1AUTH
066200000000     C                   Movel     *Blanks       #1USER
066300000000     C                   Movel     *Blanks       #1FOIR
066400000000     C                   Movel     *Blanks       #1QUEU
066500000000     C                   Movel     *Blanks       #1UDFF
066600000000     C                   Setoff                                       314142
066700000000     C                   Setoff                                       32
066800000000     C                   Setoff                                       4344
066900000000     C                   Endif
067000000000      *
067100000000     CSR   MAEXIT        Endsr
067200000000      /EJECT
067300000000
067400000000      *****************************************************************
067500000000      ** Move XXRBNOPD fields to screen
067600000000      *****************************************************************
067700000000     CSR   MBFL#1        Begsr
067800000000      *
067900000000     C                   Move      WABRCA        #1BRCA
068000000000     C                   Movel     FNCUST        #1CUST
068100000000     C                   Movel     FNAUTH        #1AUTH
068200000000     C                   Movel     FNUSER        #1USER
068300000000     C                   Movel     FNFOIR        #1FOIR
068400000000     C                   Movel     FNQUEUE       #1QUEU
068500000000     C                   Movel     FNUDFF        #1UDFF
068600000000      * Hold existing record image
068700000000     C                   Move      *Blanks       #1DBRC
068800000000     C                   Movel     @1DBRC        #1DBRC
068900000000      *
069000000000     CSR   MBEXIT        Endsr
069100000000      /EJECT
069200000000
069300000000      *****************************************************************
069400000000      ** Initialize key screen
069500000000      *****************************************************************
069600000000     CSR   MDIZ#K        Begsr
069700000000      *
069800000000     C                   Movel     P2ANCD        #PANCD
069900000000     C                   Movel     P1BRCA        #1BRCA
070000000000     C                   Movel     P1CUST        #1CUST
070100000000     C                   Movel     P1AUTH        #1AUTH
070200000000      * Set up Key Screen Header Title
070300000000     C                   Exsr      UHSUBR
070400000000      * Set up Key Screen Footer
070500000000     C                   Exsr      UISUBR
070600000000      *
070700000000     CSR   MDEXIT        Endsr
070800000000      /EJECT
070900000000
071000000000      *****************************************************************
071100000000      ** Check if record exists - RBNO
071200000000      *****************************************************************
071300000000     CSR   SDRVGN        Begsr
071400000000      *
071500000000     C                   Movel     *Blank        W0RTN             7
071600000000      * Declare restrictor key work fields
071700000000     C     *Like         Define    WABRCA        WQSD01
071800000000      * Define keylist
071900000000     C     KRSSD         Klist
072000000000     C                   Kfld                    WQSD01
072100000000      * Move fields to key list
072200000000     C                   Move      #1BRCA        WQSD01
072300000000     C     KRSSD         Setll     XXCONBDB
072400000000     C     KRSSD         Reade     XXCONBDB                               90
072500000000     C     *IN90         Ifeq      '1'
072600000000     C                   Movel     'XXH0017'     W0RTN             7
072700000000      * USER: Processing if Data record not found
072800000000     C                   Movel     'Y2U0005'     W0RTN
072900000000     C                   Goto      SDEXIT
073000000000     C                   Endif
073100000000      *
073200000000     C     *IN90         Doweq     '0'
073300000000     C                   Movel     'Y2U0003'     W0RTN
073400000000     C     KRSSD         Reade     XXCONBDB                               90
073500000000     C                   Enddo
073600000000      *
073700000000     CSR   SDEXIT        Endsr
073800000000      /EJECT
073900000000
074000000000      *****************************************************************
074100000000      ** Create BRCA Record
074200000000      *****************************************************************
074300000000     CSR   SECRRC        Begsr
074400000000      *
074500000000     C                   Movel     *Blank        W0RTN             7
074600000000      * Move all fields to XXCONBPD
074700000000     C                   Move      #1BRCA        FNBRCA
074800000000     C                   Movel     #1CUST        FNCUST
074900000000     C                   Movel     #1AUTH        FNAUTH
075000000000     C                   Movel     #1USER        FNUSER
075100000000     C                   Movel     #1FOIR        FNFOIR
075200000000     C                   Movel     #1QUEU        FNQUEUE
075300000000     C                   Movel     #1UDFF        FNUDFF
075400000000      *
075500000000     C     KLCRSE        Klist
075600000000     C                   Kfld                    FNBRCA
075700000000      * Check for duplicate primary key
075800000000     C     KLCRSE        Setll     XXCONBDA                               90
075900000000     C     *IN90         Ifeq      '1'
076000000000     C                   Movel     'XXX1183'     W0RTN             7
076100000000      * Send message 'BRCA Record exist'
076200000000     C                   Movel     'XXX1183'     ZAMSID
076300000000     C                   Exsr      ZASNMS
076400000000     C                   Goto      SEEXIT
076500000000     C                   Endif
076600000000      *
076700000000     C                   Write     XXCONBDA                             91
076800000000      *
076900000000     C     *IN91         Ifeq      '1'
077000000000      * Write error detected
077100000000     C                   Movel     'Y2U0004'     W0RTN             7
077200000000     C                   Else
077300000000      * USER: Processing after Data update
077400000000     C                   Z-Add     1             WUNORC
077500000000     C                   Z-Add     1             WUNOIN
077600000000     C                   Z-Add     *Zero         WUNOAM
077700000000     C                   Z-Add     *Zero         WUNODL
077800000000     C                   Endif
077900000000      *
078000000000     CSR   SEEXIT        Endsr
078100000000      /EJECT
078200000000
078300000000      *****************************************************************
078400000000      ** Physical delete of RBNO
078500000000      *****************************************************************
078600000000     CSR   SGCHRC        Begsr
078700000000     C                   Movel     *Blank        W0RTN             7
078800000000      * Case: PAR.Action Code is Delete
078900000000     C     P2ANCD        Ifeq      'D'
079000000000     C                   Move      #1BRCA        FNBRCA
079100000000      *
079200000000     C     KLDLTR        Klist
079300000000     C                   Kfld                    FNBRCA
079400000000     C     KLDLTR        Chain     XXCONBDA                           9091
079500000000      *
079600000000     C     *IN90         Ifeq      '1'
079700000000      * Record not found
079800000000     C                   Movel     'Y2U0009'     W0RTN             7
079900000000      * Send message '*Record no longer on file'
080000000000     C                   Movel     'Y2U0009'     ZAMSID
080100000000     C                   Movel     'Y2USRMSG'    ZAMSGF
080200000000     C                   Exsr      ZASNMS
080300000000     C                   Goto      SGEXIT
080400000000     C                   Endif
080500000000      * Record locked
080600000000     C     *IN91         Ifeq      '1'
080700000000     C                   Movel     'Y2U0004'     W0RTN             7
080800000000     C                   Goto      SGEXIT
080900000000     C                   Endif
081000000000      *
081100000000     C     *IN91         Ifeq      '0'
081200000000     C     *IN90         Andeq     '0'
081300000000     C                   Delete    XXCONBDA
081400000000     C                   Goto      SGEXIT
081500000000     C                   Endif
081600000000      *
081700000000     C                   Else
081800000000      * Send message 'Function key not allowed'
081900000000     C                   Movel     'USR0533'     ZAMSID
082000000000     C                   Exsr      ZASNMS
082100000000     C                   Seton                                        99
082200000000      *
082300000000     C                   Movel     'Y2U0004'     W0RTN
082400000000     C                   Goto      SGEXIT
082500000000     C                   Endif
082600000000
082700000000      ** Set PGM.*Record Data Changed flag
082800000000     C                   Move      'N'           YBRDC             1
082900000000      *
083000000000      * Move key fields to A1CONBPD
083100000000     C                   Move      #1BRCA        FNBRCA
083200000000      *
083300000000     C     KLCHSG        Klist
083400000000     C                   Kfld                    FNBRCA
083500000000     C     KLCHSG        Chain     XXCONBDA                           9091
083600000000     C     *IN90         Ifeq      '1'
083700000000      * Record not found
083800000000     C                   Movel     'Y2U0009'     W0RTN             7
083900000000      * Send message '*Record no longer on file'
084000000000     C                   Movel     'Y2U0009'     ZAMSID
084100000000     C                   Movel     'Y2USRMSG'    ZAMSGF
084200000000     C                   Exsr      ZASNMS
084300000000     C                   Goto      SGEXIT
084400000000     C                   Endif
084500000000      * Record locked
084600000000     C     *IN91         Ifeq      '1'
084700000000     C                   Movel     'Y2U0004'     W0RTN             7
084800000000     C                   Goto      SGEXIT
084900000000     C                   End
085000000000      *
085100000000      * Check for changed record
085200000000     C     #1DBRC        Ifne      @1DBRC
085300000000     C                   Movel     'Y2U0007'     W0RTN             7
085400000000      * Send message '*Update not accepted'
085500000000     C                   Movel     'Y2U0007'     ZAMSID
085600000000     C                   Movel     'Y2USRMSG'    ZAMSGF
085700000000     C                   Exsr      ZASNMS
085800000000      * Release record lock
085900000000     C                   Unlock    A1CONBL0                             91
086000000000     C                   Goto      SGEXIT
086100000000     C                   Endif
086200000000      * Store record data for null update check
086300000000     C                   Move      @1DBRC        YBRDCS
086400000000      * Set PGM.*Record Data Changed flag
086500000000     C     @1DBRC        Ifne      YBRDCS
086600000000     C                   Move      'Y'           YBRDC
086700000000     C                   Endif
086800000000      * If changed update record otherwise release record
086900000000     C     YBRDC         Ifeq      'Y'
087000000000     C                   Update    XXCONBDA                             91
087100000000     C                   Else
087200000000      * Release record lock
087300000000     C                   Unlock    A1CONBL0                             91
087400000000     C                   End
087500000000      * Change error detected
087600000000     C     *IN91         Ifeq      '1'
087700000000     C                   Movel     'Y2U0004'     W0RTN             7
087800000000     C                   Else
087900000000      * Update saved record image
088000000000     C                   Move      *Blanks       #1DBRC
088100000000     C                   Movel     @1DBRC        #1DBRC
088200000000      * DBF change successful
088300000000     C                   Endif
088400000000      *
088500000000     CSR   SGEXIT        Endsr
088600000000      /EJECT
088700000000
088800000000      *****************************************************************
088900000000      * Change BRCA
089000000000      *****************************************************************
089100000000     CSR   SHCHRC        Begsr
089200000000      *
089300000000     C                   Movel     *Blank        W0RTN             7
089400000000      * Set PGM.*Record Data Changed flag
089500000000     C                   Move      'N'           YCRDC             1
089600000000      * Move key fields to A1CONBPD
089700000000     C                   Move      #1BRCA        FNBRCA
089800000000      *
089900000000     C     KLCHSH        Klist
090000000000     C                   Kfld                    FNBRCA
090100000000     C     KLCHSH        Chain     XXCONBDA                           9091
090200000000     C     *IN90         Ifeq      '1'
090300000000      * Record not found
090400000000     C                   Movel     'Y2U0009'     W0RTN             7
090500000000      * Send message '*Record no longer on file'
090600000000     C                   Movel     'Y2U0009'     ZAMSID
090700000000     C                   Movel     'Y2USRMSG'    ZAMSGF
090800000000     C                   Exsr      ZASNMS
090900000000     C                   Goto      SHEXIT
091000000000     C                   Endif
091100000000      * Record locked
091200000000     C     *IN91         Ifeq      '1'
091300000000     C                   Movel     'Y2U0004'     W0RTN             7
091400000000     C                   Goto      SHEXIT
091500000000     C                   Endif
091600000000
091700000000      ** Check for changed record
091800000000     C     #1DBRC        Ifne      @1DBRC
091900000000     C                   Movel     'Y2U0007'     W0RTN             7
092000000000      * Send message '*Update not accepted'
092100000000     C                   Movel     'Y2U0007'     ZAMSID
092200000000     C                   Movel     'Y2USRMSG'    ZAMSGF
092300000000     C                   Exsr      ZASNMS
092400000000      * Release record lock
092500000000     C                   Unlock    A1CONBL0                             91
092600000000     C                   Goto      SHEXIT
092700000000     C                   Endif
092800000000      * Store record data for null update check
092900000000     C                   Move      @1DBRC        YCRDCS
093000000000      * Move non-key fields to A1CONBPD
093100000000     C                   Movel     #1CUST        FNCUST
093200000000     C                   Movel     #1AUTH        FNAUTH
093300000000     C                   Movel     #1USER        FNUSER
093400000000     C                   Movel     #1FOIR        FNFOIR
093500000000     C                   Movel     #1QUEU        FNQUEUE
093600000000     C                   Movel     #1UDFF        FNUDFF
093700000000      * Set PGM.*Record Data Changed flag
093800000000     C     @1DBRC        Ifne      YCRDCS
093900000000     C                   Move      'Y'           YCRDC
094000000000     C                   Endif
094100000000      * If changed update record otherwise release record
094200000000     C     YCRDC         Ifeq      'Y'
094300000000     C                   Update    XXCONBDA                             91
094400000000     C                   Else
094500000000      * Release record lock
094600000000     C                   Unlock    A1CONBL0                             91
094700000000     C                   End
094800000000     C     *IN91         Ifeq      '1'
094900000000      * Change error detected
095000000000     C                   Movel     'Y2U0004'     W0RTN             7
095100000000     C                   Else
095200000000      *
095300000000      * Update saved record image
095400000000     C                   Move      *Blanks       #1DBRC
095500000000     C                   Movel     @1DBRC        #1DBRC
095600000000      * DBF change successful
095700000000     C                   Z-Add     *Zero         WUNORC
095800000000     C                   Z-Add     *Zero         WUNOIN
095900000000     C                   Z-Add     1             WUNOAM
096000000000     C                   Z-Add     *Zero         WUNODL
096100000000      *
096200000000     C                   Endif
096300000000      *
096400000000     CSR   SHEXIT        Endsr
096500000000      /EJECT
096600000000
096700000000      *****************************************************************
096800000000      ** Set up Detail Screen Header Title
096900000000      *****************************************************************
097000000000     CSR   UASUBR        Begsr
097100000000      * Setup message data for message
097200000000     C     WP0001        Ifeq      'E'
097300000000     C                   Movel     'XXX1180'     ZAMSID
097400000000     C                   Else
097500000000     C                   Movel     'XXX1181'     ZAMSID
097600000000     C                   Endif
097700000000      *
097800000000     C                   Movel     'XXUSRMSG'    ZAMSGF
097900000000     C                   Call      'Y2RVMGC'                            90
098000000000     C                   Parm      *Blank        W0RTN             7
098100000000     C                   Parm                    ZAMSID            7
098200000000     C                   Parm                    ZAMSGF           10
098300000000     C                   Parm                    ZAMSDA          132
098400000000     C     WUDFTL        Parm                    W0MTX           132
098500000000     C                   Movel     *Blank        ZAMSDA
098600000000     C                   Movel     *Blank        ZAMSGF
098700000000      * Move to Header Title - Standard Functions  *
098800000000     C                   Movel     WUDFTL        ##URPT
098900000000      *
099000000000     CSR   UAEXIT        Endsr
099100000000      /EJECT
099200000000
099300000000      *****************************************************************
099400000000      ** Set up Detail Screen Footer
099500000000      *****************************************************************
099600000000     CSR   UBSUBR        Begsr
099700000000      * Setup message data for message
099800000000     C                   Movel     ZADFMF        ZAMSGF
099900000000     C                   Call      'Y2RVMGC'                            90
100000000000     C                   Parm      *Blank        W0RTN             7
100100000000     C                   Parm      'USR2919'     ZAMSID            7
100200000000     C                   Parm                    ZAMSGF           10
100300000000     C                   Parm                    ZAMSDA          132
100400000000     C     WUSFT1        Parm                    W0MTX           132
100500000000     C                   Movel     *Blank        ZAMSDA
100600000000     C                   Movel     *Blank        ZAMSGF
100700000000      * Move to Single Footer - Standard Functions  *
100800000000     C                   Movel     WUSFT1        ##CTX1
100900000000      *
101000000000     CSR   UBEXIT        Endsr
101100000000      /EJECT
101200000000
101300000000      *****************************************************************
101400000000      * Set up Detail Screen Header Title
101500000000      *****************************************************************
101600000000     CSR   UCSUBR        Begsr
101700000000      * Setup message data for message
101800000000     C     WP0001        Ifeq      'E'
101900000000     C                   Movel     'XXX1180'     ZAMSID
102000000000     C                   Else
102100000000     C                   Movel     'XXX1181'     ZAMSID
102200000000     C                   Endif
102300000000      *
102400000000     C                   Movel     'XXUSRMSG'    ZAMSGF
102500000000     C                   Call      'Y2RVMGC'                            90
102600000000     C                   Parm      *Blank        W0RTN             7
102700000000     C                   Parm                    ZAMSID            7
102800000000     C                   Parm                    ZAMSGF           10
102900000000     C                   Parm                    ZAMSDA          132
103000000000     C     WUDFTL        Parm                    W0MTX           132
103100000000     C                   Movel     *Blank        ZAMSDA
103200000000     C                   Movel     *Blank        ZAMSGF
103300000000      * Move to Header Title - Standard Functions  *
103400000000     C                   Movel     WUDFTL        ##URPT
103500000000      *
103600000000     CSR   UCEXIT        Endsr
103700000000      /EJECT
103800000000
103900000000      *****************************************************************
104000000000      ** Set up Detail Screen Footer
104100000000      *****************************************************************
104200000000     CSR   UDSUBR        Begsr
104300000000      * Amend or Enquiry mode
104400000000     C     P2ANCD        Ifeq      'E'
104500000000     C     P2ANCD        OREQ      'A'
104600000000      * Setup message data for message
104700000000     C                   Movel     ZADFMF        ZAMSGF
104800000000     C                   Call      'Y2RVMGC'                            90
104900000000     C                   Parm      *Blank        W0RTN             7
105000000000     C                   Parm      'USR2920'     ZAMSID            7
105100000000     C                   Parm                    ZAMSGF           10
105200000000     C                   Parm                    ZAMSDA          132
105300000000     C     WUSFT1        Parm                    W0MTX           132
105400000000     C                   Movel     *Blank        ZAMSDA
105500000000     C                   Movel     *Blank        ZAMSGF
105600000000     C                   Endif
105700000000      * Delete mode
105800000000     C     P2ANCD        Ifeq      'D'
105900000000      * Setup message data for message
106000000000     C                   Movel     ZADFMF        ZAMSGF
106100000000     C                   Call      'Y2RVMGC'                            90
106200000000     C                   Parm      *Blank        W0RTN             7
106300000000     C                   Parm      'USR2921'     ZAMSID            7
106400000000     C                   Parm                    ZAMSGF           10
106500000000     C                   Parm                    ZAMSDA          132
106600000000     C     WUSFT1        Parm                    W0MTX           132
106700000000     C                   Movel     *Blank        ZAMSDA
106800000000     C                   Movel     *Blank        ZAMSGF
106900000000     C                   Endif
107000000000      * Move to Single Footer - Standard Functions  *
107100000000     C                   Movel     WUSFT1        ##CTX1
107200000000      *
107300000000     CSR   UDEXIT        Endsr
107400000000      /EJECT
107500000000
107600000000      *****************************************************************
107700000000      ** Set up Key Screen Header Title
107800000000      *****************************************************************
107900000000     CSR   UFSUBR        Begsr
108000000000      * Setup message data for message
108100000000     C                   Movel     'XXUSRMSG'    ZAMSGF
108200000000     C                   Call      'Y2RVMGC'                            90
108300000000     C                   Parm      *Blank        W0RTN             7
108400000000     C                   Parm      'XXX1182'     ZAMSID            7
108500000000     C                   Parm                    ZAMSGF           10
108600000000     C                   Parm                    ZAMSDA          132
108700000000     C     WUDFTL        Parm                    W0MTX           132
108800000000     C                   Movel     *Blank        ZAMSDA
108900000000     C                   Movel     *Blank        ZAMSGF
109000000000      * Move to Header Title - Standard Functions  *
109100000000     C                   Movel     WUDFTL        ##URPT
109200000000      *
109300000000     CSR   UFEXIT        Endsr
109400000000      /EJECT
109500000000
109600000000      *****************************************************************
109700000000      ** Set up Key Screen Footer
109800000000      *****************************************************************
109900000000     CSR   UGSUBR        Begsr
110000000000      * Setup message data for message
110100000000     C                   Movel     ZADFMF        ZAMSGF
110200000000     C                   Call      'Y2RVMGC'                            90
110300000000     C                   Parm      *Blank        W0RTN             7
110400000000     C                   Parm      'USR2918'     ZAMSID            7
110500000000     C                   Parm                    ZAMSGF           10
110600000000     C                   Parm                    ZAMSDA          132
110700000000     C     WUSFT1        Parm                    W0MTX           132
110800000000     C                   Movel     *Blank        ZAMSDA
110900000000     C                   Movel     *Blank        ZAMSGF
111000000000      * Move to Single Footer - Standard Functions  *
111100000000     C                   Movel     WUSFT1        ##CTX1
111200000000      *
111300000000     CSR   UGEXIT        Endsr
111400000000      /EJECT
111500000000
111600000000      *****************************************************************
111700000000      ** Set up Key Screen Header Title
111800000000      *****************************************************************
111900000000     CSR   UHSUBR        Begsr
112000000000      * Setup message data for message
112100000000     C                   Movel     'XXUSRMSG'    ZAMSGF
112200000000     C                   Call      'Y2RVMGC'                            90
112300000000     C                   Parm      *Blank        W0RTN             7
112400000000     C                   Parm      'XXX1182'     ZAMSID            7
112500000000     C                   Parm                    ZAMSGF           10
112600000000     C                   Parm                    ZAMSDA          132
112700000000     C     WUDFTL        Parm                    W0MTX           132
112800000000     C                   Movel     *Blank        ZAMSDA
112900000000     C                   Movel     *Blank        ZAMSGF
113000000000      * Move to Header Title - Standard Functions  *
113100000000     C                   Movel     WUDFTL        ##URPT
113200000000      *
113300000000     CSR   UHEXIT        Endsr
113400000000      /EJECT
113500000000
113600000000      *****************************************************************
113700000000      ** Set up Key Screen Footer
113800000000      *****************************************************************
113900000000     CSR   UISUBR        Begsr
114000000000      * Setup message data for message
114100000000     C                   Movel     ZADFMF        ZAMSGF
114200000000     C                   Call      'Y2RVMGC'                            90
114300000000     C                   Parm      *Blank        W0RTN             7
114400000000     C                   Parm      'USR2918'     ZAMSID            7
114500000000     C                   Parm                    ZAMSGF           10
114600000000     C                   Parm                    ZAMSDA          132
114700000000     C     WUSFT1        Parm                    W0MTX           132
114800000000     C                   Movel     *Blank        ZAMSDA
114900000000     C                   Movel     *Blank        ZAMSGF
115000000000      * Move to Single Footer - Standard Functions  *
115100000000     C                   Movel     WUSFT1        ##CTX1
115200000000      *
115300000000     CSR   UIEXIT        Endsr
115400000000      /EJECT
115500000000
115600000000      *****************************************************************
115700000000      ** Send message to program's message queue
115800000000      *****************************************************************
115900000000     CSR   ZASNMS        Begsr
116000000000     C     ZAPGMQ        Ifeq      *Blank
116100000000     C                   Movel     ##PGM         ZAPGMQ
116200000000     C                   Endif
116300000000      * If no message file specified, use default
116400000000     C     ZAMSGF        Ifeq      *Blank
116500000000     C                   Movel     ZADFMF        ZAMSGF
116600000000     C                   Endif
116700000000     C                   Call      'Y2SNMGC'
116800000000     C                   Parm                    ZAPGMQ           10
116900000000     C                   Parm                    ZAPGRL            5
117000000000     C                   Parm                    ZAMSID            7
117100000000     C                   Parm                    ZAMSGF           10
117200000000     C                   Parm                    ZAMSDA          132
117300000000     C                   Parm                    ZAMSTP            7
117400000000      * Clear all fields for default mechanism next Time
117500000000     C                   Movel     *Blank        ZAPGMQ
117600000000     C                   Movel     *Blank        ZAPGRL
117700000000     C                   Movel     *Blank        ZAMSID
117800000000     C                   Movel     *Blank        ZAMSGF
117900000000     C                   Movel     *Blank        ZAMSDA
118000000000     C                   Movel     *Blank        ZAMSTP
118100000000      *
118200000000     CSR   ZAEXIT        Endsr
118300000000      /EJECT
118400000000
118500000000      *****************************************************************
118600000000      ** Cancel and exit from key screen
118700000000      *****************************************************************
118800000000     CSR   ZXEXPG        Begsr
118900000000      * USER: Exit program processing
119000000000      * Case: KEY.*CMD key is *Exit
119100000000     C     *IN03         Ifeq      '1'
119200000000     C                   Movel     'Y2U9999'     P0RTN
119300000000     C                   Exsr      ZYEXPG
119400000000     C                   Endif
119500000000     C*
119600000000     C                   Movel     *Blank        P0RTN
119700000000     C                   Exsr      ZYEXPG
119800000000      *
119900000000     CSR   ZXEXIT        Endsr
120000000000      /EJECT
120100000000
120200000000      *****************************************************************
120300000000      ** Exit program: Direct
120400000000      *****************************************************************
120500000000     CSR   ZYEXPG        Begsr
120600000000      * ROLLBACK any uncommitted DBF changes
120700000000     C                   Rolbk                                          90
120800000000      *
120900000000      * Exit program
121000000000     C                   Return
121100000000      *
121200000000      *
121300000000     CSR   ZYEXIT        Endsr
121400000000      /EJECT
121500000000
121600000000      *****************************************************************
121700000000      ** Initialisation
121800000000      *****************************************************************
121900000000     CSR   ZZINIT        Begsr
122000000000      *
122100000000     C                   Move      *Blank        P0RTN
122200000000     C                   Move      *Blank        W0RTN             7
122300000000      * Initialise indicators for re-Entry
122400000000     C                   Move      '0'           *IN
122500000000      * Update screen Time
122600000000     C                   Time                    ##TME             6 0
122700000000      * Define work field Display File Title
122800000000     C                   Movel     *Blank        WUDFTL           53
122900000000      * Obtain default message file
123000000000     C     *Dtaara       Define    Y2MGFLA       ZADFMF           10
123100000000     C                   In        ZADFMF
123200000000      * Define work field STD FTR 1
123300000000     C                   Movel     *Blank        WUSFT1           78
123400000000      * Define work field Midas Run Date
123500000000     C                   Movel     *Blank        WUMRDT            7
123600000000      * Define work field Run day number
123700000000     C                   Z-Add     *Zero         WURDNB            5 0
123800000000      * Define work field No. of Records
123900000000     C                   Z-Add     *Zero         WUNORC            5 0
124000000000      * Define work field No. of Inserts
124100000000     C                   Z-Add     *Zero         WUNOIN            5 0
124200000000      * Define work field No. of Amends
124300000000     C                   Z-Add     *Zero         WUNOAM            5 0
124400000000      * Define work field No. of Deletes
124500000000     C                   Z-Add     *Zero         WUNODL            5 0
124600000000      * Define work field Output field indicator
124700000000     C                   Movel     *Blank        WUOFIN            1
124800000000      * Define work field Set Up Complete
124900000000     C                   Movel     *Blank        WUSUC             1
125000000000      * Define work field Date format flag
125100000000     C                   Movel     *Blank        WUDFF             1
125200000000      * Define work field Multi-branching Indicator
125300000000     C                   Movel     *Blank        WUMBIN            1
125400000000      * Define work field Customer
125500000000     C                   Movel     *Blank        #WCUST            6
125600000000
125700000000      ** Open files first Time only
125800000000     C     W0OPN         Ifeq      *Blank
125900000000      * Begin Commit control
126000000000     C                   Call      'Y2BGCMC'
126100000000     C                   Parm                    W0RTN             7
126200000000     C     W0RTN         Ifne      *Blank
126300000000     C     W0RTN         Andne     'CPF8351'
126400000000     C                   Exsr      ZYEXPG
126500000000     C                   Endif
126600000000      *
126700000000     C                   Open      A1008001DF
126800000000     C                   Open      A1CONBL0
126900000000     C                   Open      A1CONBL1
127000000000      * Signal that files are now Open
127100000000     C                   Move      'Y'           W0OPN             1
127200000000     C                   Endif
127300000000      *
127400000000     C                   Movel     'N'           W0PMT             1
127500000000
127600000000      ** Select initial mode
127700000000     C     @1NROP        Ifeq      *Zero
127800000000      * Add mode
127900000000     C                   Movel     'ADD'         W0PMD             3
128000000000     C                   Else
128100000000      * Change mode
128200000000     C                   Movel     'CHG'         W0PMD
128300000000     C                   Endif
128400000000
128500000000      ** Copyright Statement and Rundate setup
128600000000     C     *Dtaara       Define                  RUNDAT
128700000000     C                   In        RUNDAT
128800000000     C                   Move      MRDT          ##MRDT            7
128900000000     C                   Move      MRDT          WUMRDT
129000000000     C                   Move      RDNB          WURDNB
129100000000     C                   Move      SUC           WUSUC
129200000000     C                   Move      DFF           WUDFF
129300000000     C                   Move      MBIN          WUMBIN
129400000000
129500000000      ** Action Enquire or Delete
129600000000     C     P2ANCD        Ifeq      'E'
129700000000     C     P2ANCD        Oreq      'D'
129800000000     C                   Movel     'Y'           WUOFIN
129900000000     C                   Endif
130000000000      *
130100000000     CSR   ZZEXIT        Endsr
130200000000      /EJECT
130300000000
130400000000      *****************************************************************
130500000000      *                                                               *
130600000000      * *PSSR  - Program exception error routine                      *
130700000000      *          Called automatiCally if a program error occurs,      *
130800000000      *          or directly by the program code using EXSR.          *
130900000000      *          This subroutine DUMPs the program just once.         *
131000000000      *                                                               *
131100000000      *****************************************************************
131200000000     CSR   *PSSR         Begsr
131300000000
131400000000      ** Standard Midas PSSR processing.
131500000000     C     @RUN          Ifeq      *Blank
131600000000     C                   Move      'Y'           @RUN              1
131700000000     C                   Move      'PSSR   '     P0RTN
131800000000     C                   Dump
131900000000
132000000000      ** Route job back into Midas.
132100000000     C                   Seton                                        LR
132200000000     C                   Call      'DBERRCTL'
132300000000     C                   End
132400000000      *
132500000000     CSR                 Endsr
132600000000      *****************************************************************
