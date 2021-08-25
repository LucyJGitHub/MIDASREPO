     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Consolidation Replication Maintenance')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  A1008001 - Midas SD Consolidation Replication Maintenance    *
      *                                                               *
      *  Function:  This program allows Enquire, Amend, Insert        *
      *             and logical Delete for a Consolidated Branch      *
      *                                                               *
      *  Called By: A1008000 - Reserved Batch Numbers Enquiry         *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. BA1008   *Create   Date 03Jun21               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  BA1008 - Replication of Trades to consolidated branches      *
      *                                                               *
      *****************************************************************
      *
      ** Consolidated Branches Maintenance
      *
     FA1008001DFCF   E             Workstn Usropn
     F                                     Infds(Infds#)
     F                                     Infsr(*PSSR)
      *
      ** Midas SD Consolidated Branches - Retrieval
      *
     FA1CONBL1  IF   E           K DISK    Usropn
     F                                     Infds(Infds1)
     F                                     Infsr(*PSSR)
     F                                     Rename(A1CONBPF:XXCONBDB)
      *
      ** Midas SD Consolidated Branches - Update
      *
     FA1CONBL0  UF A E           K DISK    Usropn
     F                                     Commit
     F                                     Infds(ID0001)
     F                                     Infsr(*PSSR)
     F                                     Rename(A1CONBPF:XXCONBDA)
      *
     FA1CONBPD  IF   E             DISK    INFSR(*pssr)
      /EJECT

      *****************************************************************
      ** +-------------------------------+
      ** ¦ Data structures specification |
      ** +-------------------------------+
      *
      ** Pgm Data srtucture
      *
     D PGMDS         ESDs                  Extname(Y2PGDSP)
      *
      ** Display file information data structure
      *
     D Infds#        E Ds                  Extname(Y2I#DSP)
      *
      ** File information data structure
      *
     D Infds1        E Ds                  Extname(Y2I1DSP)
      *
      ** RBNO Code Details
      *
     D @1DBRC        E Ds                  Extname(A1CONBL0)
      *
      ** Long DS for access programs
      *
     D DSSDY         E Ds                  Extname(DSSDY)
      *
      ** Stored master file format fields
      *
     D #1DBRC          Ds           222
     D  #1DB1                  1     12S 0
     D  #1DB2                 13     47
     D  #1DB3                 48     77
     D  #1DB4                 78     83
     D  #1DB5                 84    103
     D  #1DB6                104    138
     D  #1DB7                139    173
     D  #1DB8                174    208
     D  #1DB9                209    218
     D  #1DB10               219    219
     D  #1DB11               220    222P 0
      *
      ** Standing data controls update
      *
     D YBRDCS          Ds           222
     D YCRDCS          Ds           222
      *
      ** Run date
      *
     D RUNDAT          Ds
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      *
      ** File information data structure
      *
     D ID0001          Ds           528
      *
      ** File information data structure
      *
     D ID0002          Ds           528
      *
      ** Parameter declarations
      *
     D P1Parm          Ds            52
     D  P1BRCA                 1      3
     D  P1CUST                 4     10
     D  P1AUTH                11     11
      *
      ** MAP Action Code
      *
     D P2Parm          Ds
     D  P2ANCD                 1      1

     D                 Ds
     D  ZAMSDA                 1    132
     D  ZA0001                 1      3
     D  ZA0002                 1      6

      *
      ** Renamed input format fields
      *
     IXXCONBDB
     I              FNBRCA                      WABRCA
      /EJECT

      *
      *****************************************************************
      ** Entry parameters                                             *
      *****************************************************************
      *
     C     *Entry        Plist
     C                   Parm                    P0RTN             7
     C                   Parm                    P1Parm
     C     P2ANCD        Parm                    WP0001            1
      *
      ** Initialize
      *
     C                   Exsr      ZZINIT
      *
      ** Check passed parameters
      *
     C                   Exsr      FACKPM
      *
      ** Perform once if all passed, Else repeat
      *
     C     W0RPT         Doueq     'N'
      *
      ** Display and process key screen
      *
     C                   Exsr      BADSKY
     C                   Enddo
      *
      ** Terminate program
      *
     C                   Exsr      ZXEXPG
      *
      /EJECT

      *****************************************************************
      ** Display and process key screen                               *
      *****************************************************************
     CSR   BADSKY        Begsr
      *
      ** Initialize key screen
      *
     C                   Exsr      MDIZ#K
      *
      ** Bypass first display of key screen is possible
      *
     C                   Movel     'Y'           W0BYP             1
      *
      ** Signal start of transaction
      *
     C                   Movel     'Y'           W0TRN             1
     C     W0TRN         Doweq     'Y'
     C     W0TRN         Oreq      'K'
      *
      ** Ensure transaction continues (if reset)
      *
     C                   Movel     'Y'           W0TRN             1
      *
      ** Conduct screen conversation
      *
     C     W0TRN         Doweq     'Y'
      *
      ** Is bypass key screen still viable?
      *
     C     W0BYP         Ifeq      'Y'
     C     #1BRCA        Ifeq      *Blanks
      *
      ** One or more key fields is Blank
      *
     C     *IN05         Oreq      '1'
      *
      ** HOME: Reset screen fields
      *
     C                   Movel     'N'           W0BYP
     C                   Endif
     C                   Endif
      *
      ** Bypass key screen
      *
     C     W0BYP         Ifne      'Y'
      *
      ** Display key screen
      *
     C                   Exsr      BBEXFM
     C                   Endif
      *
      ** Cancel key screen bypass
      *
     C                   Movel     'N'           W0BYP
      *
      ** Process response to key screen
      ** Cancel & exit program
      *
     C   03              Cas                     ZXEXPG
      *
      ** Switch between *ADD/*CHANGE modes
      *
     C   09              Cas                     BCCHMD
      *
      ** HOME: Reset screen fields
      *
     C   05              Cas                     BDHMKY
      *
      ** Process key screen input
      *
     C                   Cas                     BEPRKY
     C                   End
      *
     C     W0TRN         Doweq     'R'
     C                   Movel     'Y'           W0TRN
     C                   Exsr      BEPRKY
     C                   Enddo
      *
     C                   Enddo
     C                   Enddo
      *
     CSR   BAEXIT        Endsr
      /EJECT

      *****************************************************************
      * Display key screen                                            *
      *****************************************************************
     CSR   BBEXFM        Begsr
      *
      ** Set screen conditioning indicators
      *
     C                   Exsr      GADSAK
      *
      ** Update screen Time
      *
     C                   Time                    ##TME
     C     W0HLP         Doueq     'N'
     C                   Movel     'N'           W0HLP             1
     C                   Move      *ALL'0'       ##OFF            30
     C                   MoveA     ##OFF         *IN(1)
      *
      ** PUTOVR unless conditioned fields change
      *
     C                   Seton                                            86
     C     *IN89         Ifne      BBIN89
     C                   Setoff                                           86
     C                   Endif
     C                   Move      *IN89         BBIN89            1
      *
      ** Display Prompt 1
      *
     C                   Write     #MSGCTL
     C                   Write     #CMDTXT1
     C                   Exfmt     #RCDKEY
      *
     C                   Enddo
      *
      ** Clear messages from program message queue
      *
     C                   Call      'Y2CLMSC'
     C                   Parm      ##PGM         ZAPGMQ           10
     C                   Parm      '*SAME'       ZAPGRL            5
      *
      ** Reset first message only flag
      *
     C                   Movel     'Y'           ZAFSMS            1
      *
      ** Reset global error indicator
      *
     C                   Setoff                                           99
      *
     CSR   BBEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Switch between *ADD/*CHANGE modes                            *
      *****************************************************************
     CSR   BCCHMD        Begsr
      *
     C     W0PMD         Ifeq      'ADD'
     C                   Movel     'CHG'         W0PMD             3
     C                   Else
     C                   Movel     'ADD'         W0PMD
      *
     C                   End
      *
     CSR   BCEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Process HOME key                                             *
      *****************************************************************
     CSR   BDHMKY        Begsr
      *
     C                   Movel     'N'           W0TRN
      *
     CSR   BDEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Process key screen input                                     *
      *****************************************************************
     CSR   BEPRKY        Begsr
      *
      ** Initialise detail screen
      *
     C                   Exsr      MAIZ#1
      *
      ** Validate key fields
      *
     C                   Exsr      BFVLKY
     C     *IN99         CabEq     '1'           BEEXIT
      *
      ** Check for existing record
      *
     C     KRTV          Klist
     C                   Kfld                    FNBRCA
      *
      ** Setup key
      *
     C                   Move      #1BRCA        FNBRCA
     C     KRTV          Chain     XXCONBDB                           9091
     C     *IN91         Ifeq      '1'
      *
      ** Record locked
      *
     C                   Seton                                        9931
     C                   Goto      BEEXIT
     C                   Endif
      *
      ** If record does not exist, flip to add mode
      *
     C     *IN90         Ifeq      '1'
     C                   Movel     'ADD'         W0PMD
      *
      ** Set up Detail Screen Header Title
      *
     C                   Exsr      UASUBR
      *
      ** Set up Detail Screen Footer
      *
     C                   Exsr      UBSUBR
      *
     C                   Else
      *
      ** If record does exist, flip to change mode
      *
     C                   Movel     'CHG'         W0PMD
      *
      ** Load screen fields from DBF
      *
     C                   Exsr      MBFL#1
      *
      ** Set up Detail Screen Header Title
      *
     C                   Exsr      UCSUBR
      *
      ** Set up Detail Screen Footer
      *
     C                   Exsr      UDSUBR
     C*
     C                   Endif
      *
     C   99              Goto      BEEXIT
      *
      ** No error: Display and process details
      *
     C                   Exsr      CADSDA
      *
     CSR   BEEXIT        Endsr
      /EJECT

      *****************************************************************
      * Validate key fields                                           *
      *****************************************************************
     CSR   BFVLKY        Begsr
      *
      ** Validate entries
      *
B1   C                   If        P2ANCD = 'I'
     C                   Setoff                                       993132
      *
      ** BRCA validation
      *
      ** Check for existing record
      *
     C                   Move      #1BRCA        FNBRCA
     C     KRTV          Chain     XXCONBDB                           90
B2   C                   If        *IN90 = *off
      *
      ** Duplicate BRCA entered
      *
     C                   Seton                                        99
     C                   Seton                                        31
     C                   Movel     'XXX1183'     ZAMSID
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
E1   C                   Endif
      *
X2   C                   Else
     C                   Move      #1BRCA        FNBRCA
      *
E1   C                   Endif
      *
     CSR   BFEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Display and process detail screen                            *
      *****************************************************************
     CSR   CADSDA        Begsr
      *
      ** Repeat until screen control flag is reset:
      *
     C     W0TRN         DOWEQ     'Y'
      *
      ** Display detail screen
      *
     C                   Exsr      CBEXFM
      *
      ** Process response to detail screen
      ** Cancel & exit program
      *
     C   03              Cas                     ZXEXPG
      *
      ** Redisplay previous screen
      *
     C   12              Cas                     CCDSPV
      *
      ** HOME: Reset screen fields
      *
     C   05              Cas                     CCDSPV
      *
      ** Process detail screen input
      *
     C                   Cas                     CFPRSC
     C                   End
      *
     C     W0TRN         Ifeq      'R'
     C     W0PMD         Ifeq      'ADD'
     C                   Exsr      MAIZ#1
     C                   Endif
     C                   Endif
      *
     C                   Enddo
      *
     CSR   CAEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Display screen                                               *
      *****************************************************************
     CSR   CBEXFM        Begsr
      *
      ** Set screen conditioning indicators
      *
     C                   Exsr      GBDSAD
      *
      ** Update screen Time
      *
     C                   Time                    ##TME
     C     W0HLP         Doueq     'N'
     C                   Movel     'N'           W0HLP             1
     C                   Move      *ALL'0'       ##OFF            30
     C                   MoveA     ##OFF         *IN(1)
      *
      ** PUTOVR unless conditioned fields change
      *
     C                   Seton                                            86
     C     *IN89         Ifne      CBIN89
     C                   Setoff                                           86
     C                   Endif
     C                   Move      *IN89         CBIN89            1

     C                   Write     #MSGCTL
     C                   Write     #CMDTXT2
     C                   Exfmt     #RCDDTL1

     C                   Enddo
      *
      ** Clear messages from program message queue
      *
     C                   Call      'Y2CLMSC'
     C                   Parm      ##PGM         ZAPGMQ           10
     C                   Parm      '*SAME'       ZAPGRL            5
      *
      ** Reset first message only flag
      *
     C                   Movel     'Y'           ZAFSMS            1
      *
      ** Reset global error indicator
      *
     C                   Setoff                                           99
      *
     CSR   CBEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Redisplay previous screen                                    *
      *****************************************************************
     CSR   CCDSPV        Begsr
      *
      ** Case: PAR.Action Code is Insert
      *
     C     P2ANCD        Ifeq      'I'
      *
      ** Set up Key Screen Header Title
      *
     C                   Exsr      UFSUBR
      *
      ** Set up Key Screen Footer
      *
     C                   Exsr      UGSUBR
     C                   Else
      *
      ** Case: *Otherwise
      *
     C                   Movel     'USR0790'     P0RTN
     C                   Exsr      ZYEXPG
     C                   Endif
      *
     C   05              Movel     'R'           W0TRN
     C   12              Movel     'K'           W0TRN
      *
     CSR   CCEXIT        Endsr
      /EJECT

      *================================================================
      ** Validate record
      *================================================================
     CSR   CFPRSC        Begsr
      *
      ** Confirm/update is not deferred
      *
     C                   Movel     'N'           W0DCF             1
      *
      ** Validate details
      *
     C  N10              Cas                     DCVLDL
     C                   End
      *
      ** QUIT if error:
      *
     C   99              Goto      CFEXIT
      *
      ** Redisplay if change of customer entry.
      *
     C   98              Goto      CFEXIT
      *
      ** Defer confirm/update requested
      *
     C     W0DCF         CabEq     'Y'           CFEXIT
      *
      ** No error: update record
      *
     C                   Exsr      EBPR##
      *
     CSR   CFEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Validate details                                             *
      *****************************************************************
     CSR   DCVLDL        Begsr
      *
      ** USER: Validate detail screen relations
      *
     C                   Setoff                                       98
      *
     C     WP0001        Ifne      'E'
     C     W0PMD         Ifeq      'ADD'
     C     W0PMD         Oreq      'CHG'
      *
     C                   Setoff                                       993141
     C                   Setoff                                       32
     C                   Setoff                                       424344
      *
      ** Check if record exists - BRCA
      *
     C     W0PMD         Ifeq      'ADD'
     C                   Exsr      SDRVGN
      *
      ** Case: PGM.*Return code is *Record already exists
      *
     C     W0RTN         Ifeq      'Y2U0003'
      *
      ** Send message 'RBNO Rec exists'
      *
     C                   Movel     'XXX1183'     ZAMSID
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Seton                                        9941
     C                   Goto      DCEXIT
     C                   Endif
     C                   Endif
      *
     C                   Endif
     C                   Endif
      *
     CSR   DCEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Process record:                                              *
      *****************************************************************
     CSR   EBPR##        Begsr
      *
      ** Process delete request
      *
     C   10              Cas                     EDDLRQ
      *
      ** Process add request
      *
     C     W0PMD         CaseQ     'ADD'         ECADRQ
      *
      ** Process update request
      *
     C     W0PMD         CasNE     'ADD'         EECHRQ
     C                   End
      *
      ** Error: ROLLBACK any DBF changes
      *
     C     W0RTN         Ifne      *Blank
     C                   Rolbk
     C                   Goto      EBEXIT
     C                   Else
      *
      ** Otherwise Commit any DBF changes
      *
     C                   Commit
     C                   Endif
      *
      ** USER: Process command keys
      *
     C     W0RTN         Ifeq      *Blank
     C     W0PMD         Ifeq      'ADD'
      *
      ** Exit after successful add
      *
     C                   Movel     'N'           W0RPT
     C                   Endif
      *
      ** Restart program for next record
      *
     C                   Movel     'N'           W0TRN
     C                   Endif
      *
     CSR   EBEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Process add request                                          *
      *****************************************************************
     CSR   ECADRQ        Begsr
      *
      ** Create RBNO Range
      *
     C                   Exsr      SECRRC
     C     W0RTN         Ifeq      *Blank
      *
      ** Send message '*Record added'
      *
     C                   Movel     'Y2U0011'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Endif
      *
     CSR   ECEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Process delete request                                       *
      *****************************************************************
     CSR   EDDLRQ        Begsr
      *
      ** Physical delete RBNO
      *
     C                   Exsr      SGCHRC
     C     W0RTN         Ifeq      *Blank
      *
      ** Send message '*Record deleted'
      *
     C                   Movel     'Y2U0013'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Endif
      *
     CSR   EDEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Process update request                                       *
      *****************************************************************
     CSR   EECHRQ        Begsr
      *
      ** Change RBNO
      *
     C     WP0001        Ifne      'E'
     C                   Exsr      SHCHRC
     C     W0RTN         Ifne      *Blank
      *
      ** Reset screen fields if changed record
      *
     C     W0RTN         CaseQ     'Y2U0007'     MBFL#1
     C                   End
     C                   Else
      *
      ** Send message '*Record changed'
      *
     C                   Movel     'Y2U0012'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
     CSR   EEEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Check passed parameters                                      *
      *****************************************************************
     CSR   FACKPM        Begsr
      *
      ** Is full key present?
      *
     C     P1BRCA        Ifeq      *Blanks
      *
      ** Not every key field passed - loop program
      *
     C                   Movel     'Y'           W0RPT             1
     C                   Else
      *
      ** Full key passed, so single shot program
      *
     C                   Movel     'N'           W0RPT
     C                   Endif
      *
     CSR   FAEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set key screen conditioning indicators                       *
      *****************************************************************
     CSR   GADSAK        Begsr
      *
     C     W0PMD         COMP      'ADD'                                  89
      *
     CSR   GAEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set detail screen conditioning indicators                    *
      *****************************************************************
     CSR   GBDSAD        Begsr
      *
     C     W0PMD         Comp      'ADD'                                  89
      *
      ** Protect key fields on detail screen
      *
     C                   Seton                                        88
     C                   Movel     '0'           *IN79
     C                   Movel     '0'           *IN80
      *
     C     WUOFIN        Ifeq      'Y'
     C                   Movel     '1'           *IN79
     C                   Movel     '1'           *IN80
     C                   Endif
      *
     C                   Movel     '0'           *IN78
     C     W0PMD         Ifeq      'ADD'
     C                   Movel     '1'           *IN78
     C                   Endif
      *
      ** Enable key screen
      *
     C                   Seton                                        87
      *
     CSR   GBEXIT        Endsr
      /EJECT

      *****************************************************************
      * Initialise record - except for key fields                     *
      *================================================================
     CSR   MAIZ#1        Begsr
      *
     C                   Movel     P2ANCD        #PANCD
      *
     C                   If        P2ANCD = 'I'
     C                   Movel     *Blanks       #1CUST
     C                   Movel     *Blanks       #1AUTH
     C                   Movel     *Blanks       #1USER
     C                   Movel     *Blanks       #1FOIR
     C                   Movel     *Blanks       #1QUEU
     C                   Movel     *Blanks       #1UDFF
     C                   Setoff                                       314142
     C                   Setoff                                       32
     C                   Setoff                                       4344
     C                   Endif
      *
     CSR   MAEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Move XXRBNOPD fields to screen                               *
      *****************************************************************
     CSR   MBFL#1        Begsr
      *
     C                   Move      WABRCA        #1BRCA
     C                   Movel     FNCUST        #1CUST
     C                   Movel     FNAUTH        #1AUTH
     C                   Movel     FNUSER        #1USER
     C                   Movel     FNFOIR        #1FOIR
     C                   Movel     FNQUEUE       #1QUEU
     C                   Movel     FNUDFF        #1UDFF
      *
      ** Hold existing record image
      *
     C                   Move      *Blanks       #1DBRC
     C                   Movel     @1DBRC        #1DBRC
      *
     CSR   MBEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Initialize key screen                                        *
      *****************************************************************
     CSR   MDIZ#K        Begsr
      *
     C                   Movel     P2ANCD        #PANCD
     C                   Movel     P1BRCA        #1BRCA
     C                   Movel     P1CUST        #1CUST
     C                   Movel     P1AUTH        #1AUTH
      *
      ** Set up Key Screen Header Title
      *
     C                   Exsr      UHSUBR
      *
      ** Set up Key Screen Footer
      *
     C                   Exsr      UISUBR
      *
     CSR   MDEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Check if record exists - RBNO                                *
      *****************************************************************
     CSR   SDRVGN        Begsr
      *
     C                   Movel     *Blank        W0RTN             7
      *
      ** Declare restrictor key work fields
      *
     C     *Like         Define    WABRCA        WQSD01
      *
      ** Define keylist
      *
     C     KRSSD         Klist
     C                   Kfld                    WQSD01
      *
      ** Move fields to key list
      *
     C                   Move      #1BRCA        WQSD01
     C     KRSSD         Setll     XXCONBDB
     C     KRSSD         Reade     XXCONBDB                               90
     C     *IN90         Ifeq      '1'
     C                   Movel     'XXH0017'     W0RTN             7
      *
      ** USER: Processing if Data record not found
      *
     C                   Movel     'Y2U0005'     W0RTN
     C                   Goto      SDEXIT
     C                   Endif
      *
     C     *IN90         Doweq     '0'
     C                   Movel     'Y2U0003'     W0RTN
     C     KRSSD         Reade     XXCONBDB                               90
     C                   Enddo
      *
     CSR   SDEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Create BRCA Record                                           *
      *****************************************************************
     CSR   SECRRC        Begsr
      *
     C                   Movel     *Blank        W0RTN             7
      *
      ** Move all fields to XXCONBPD
      *
     C                   Move      #1BRCA        FNBRCA
     C                   Movel     #1CUST        FNCUST
     C                   Movel     #1AUTH        FNAUTH
     C                   Movel     #1USER        FNUSER
     C                   Movel     #1FOIR        FNFOIR
     C                   Movel     #1QUEU        FNQUEUE
     C                   Movel     #1UDFF        FNUDFF
      *
     C     KLCRSE        Klist
     C                   Kfld                    FNBRCA
      *
      ** Check for duplicate primary key
      *
     C     KLCRSE        Setll     XXCONBDA                               90
     C     *IN90         Ifeq      '1'
     C                   Movel     'XXX1183'     W0RTN             7
      *
      ** Send message 'BRCA Record exist'
      *
     C                   Movel     'XXX1183'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Goto      SEEXIT
     C                   Endif
      *
     C                   Write     XXCONBDA                             91
      *
     C     *IN91         Ifeq      '1'
      *
      ** Write error detected
      *
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Else
      *
      ** USER: Processing after Data update
      *
     C                   Z-Add     1             WUNORC
     C                   Z-Add     1             WUNOIN
     C                   Z-Add     *Zero         WUNOAM
     C                   Z-Add     *Zero         WUNODL
     C                   Endif
      *
     CSR   SEEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Physical delete of RBNO                                      *
      *****************************************************************
     CSR   SGCHRC        Begsr
     C                   Movel     *Blank        W0RTN             7
      *
      ** Case: PAR.Action Code is Delete
      *
     C     P2ANCD        Ifeq      'D'
     C                   Move      #1BRCA        FNBRCA
      *
     C     KLDLTR        Klist
     C                   Kfld                    FNBRCA
     C     KLDLTR        Chain     XXCONBDA                           9091
      *
     C     *IN90         Ifeq      '1'
      *
      ** Record not found
      *
     C                   Movel     'Y2U0009'     W0RTN             7
      *
      ** Send message '*Record no longer on file'
      *
     C                   Movel     'Y2U0009'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Goto      SGEXIT
     C                   Endif
      *
      ** Record locked
      *
     C     *IN91         Ifeq      '1'
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Goto      SGEXIT
     C                   Endif
      *
     C     *IN91         Ifeq      '0'
     C     *IN90         Andeq     '0'
     C                   Delete    XXCONBDA
     C                   Goto      SGEXIT
     C                   Endif
      *
     C                   Else
      *
      ** Send message 'Function key not allowed'
      *
     C                   Movel     'USR0533'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Seton                                        99
      *
     C                   Movel     'Y2U0004'     W0RTN
     C                   Goto      SGEXIT
     C                   Endif
      *
      ** Set PGM.*Record Data Changed flag
      *
     C                   Move      'N'           YBRDC             1
      *
      ** Move key fields to A1CONBPD
      *
     C                   Move      #1BRCA        FNBRCA
      *
     C     KLCHSG        Klist
     C                   Kfld                    FNBRCA
     C     KLCHSG        Chain     XXCONBDA                           9091
     C     *IN90         Ifeq      '1'
      *
      ** Record not found
      *
     C                   Movel     'Y2U0009'     W0RTN             7
      *
      ** Send message '*Record no longer on file'
      *
     C                   Movel     'Y2U0009'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Goto      SGEXIT
     C                   Endif
      *
      ** Record locked
      *
     C     *IN91         Ifeq      '1'
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Goto      SGEXIT
     C                   End
      *
      ** Check for changed record
      *
     C     #1DBRC        Ifne      @1DBRC
     C                   Movel     'Y2U0007'     W0RTN             7
      *
      ** Send message '*Update not accepted'
      *
     C                   Movel     'Y2U0007'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
      *
      ** Release record lock
      *
     C                   Unlock    A1CONBL0                             91
     C                   Goto      SGEXIT
     C                   Endif
      *
      ** Store record data for null update check
      *
     C                   Move      @1DBRC        YBRDCS
      *
      ** Set PGM.*Record Data Changed flag
      *
     C     @1DBRC        Ifne      YBRDCS
     C                   Move      'Y'           YBRDC
     C                   Endif
      *
      ** If changed update record otherwise release record
      *
     C     YBRDC         Ifeq      'Y'
     C                   Update    XXCONBDA                             91
     C                   Else
      *
      ** Release record lock
      *
     C                   Unlock    A1CONBL0                             91
     C                   End
      *
      ** Change error detected
      *
     C     *IN91         Ifeq      '1'
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Else
      *
      ** Update saved record image
      *
     C                   Move      *Blanks       #1DBRC
     C                   Movel     @1DBRC        #1DBRC
      *
      ** DBF change successful
      *
     C                   Endif
      *
     CSR   SGEXIT        Endsr
      /EJECT

      *****************************************************************
      * Change BRCA                                                   *
      *****************************************************************
     CSR   SHCHRC        Begsr
      *
     C                   Movel     *Blank        W0RTN             7
      *
      ** Set PGM.*Record Data Changed flag
      *
     C                   Move      'N'           YCRDC             1
      *
      ** Move key fields to A1CONBPD
      *
     C                   Move      #1BRCA        FNBRCA
      *
     C     KLCHSH        Klist
     C                   Kfld                    FNBRCA
     C     KLCHSH        Chain     XXCONBDA                           9091
     C     *IN90         Ifeq      '1'
      *
      ** Record not found
      *
     C                   Movel     'Y2U0009'     W0RTN             7
      *
      ** Send message '*Record no longer on file'
      *
     C                   Movel     'Y2U0009'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Goto      SHEXIT
     C                   Endif
      *
      ** Record locked
      *
     C     *IN91         Ifeq      '1'
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Goto      SHEXIT
     C                   Endif
      *
      ** Check for changed record
      *
     C     #1DBRC        Ifne      @1DBRC
     C                   Movel     'Y2U0007'     W0RTN             7
      *
      ** Send message '*Update not accepted'
      *
     C                   Movel     'Y2U0007'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
      *
      ** Release record lock
      *
     C                   Unlock    A1CONBL0                             91
     C                   Goto      SHEXIT
     C                   Endif
      *
      ** Store record data for null update check
      *
     C                   Move      @1DBRC        YCRDCS
      *
      ** Move non-key fields to A1CONBPD
      *
     C                   Movel     #1CUST        FNCUST
     C                   Movel     #1AUTH        FNAUTH
     C                   Movel     #1USER        FNUSER
     C                   Movel     #1FOIR        FNFOIR
     C                   Movel     #1QUEU        FNQUEUE
     C                   Movel     #1UDFF        FNUDFF
      *
      ** Set PGM.*Record Data Changed flag
      *
     C     @1DBRC        Ifne      YCRDCS
     C                   Move      'Y'           YCRDC
     C                   Endif
      *
      ** If changed update record otherwise release record
      *
     C     YCRDC         Ifeq      'Y'
     C                   Update    XXCONBDA                             91
     C                   Else
      *
      ** Release record lock
      *
     C                   Unlock    A1CONBL0                             91
     C                   End
     C     *IN91         Ifeq      '1'
      *
      ** Change error detected
      *
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Else
      *
      ** Update saved record image
      *
     C                   Move      *Blanks       #1DBRC
     C                   Movel     @1DBRC        #1DBRC
      *
      ** DBF change successful
      *
     C                   Z-Add     *Zero         WUNORC
     C                   Z-Add     *Zero         WUNOIN
     C                   Z-Add     1             WUNOAM
     C                   Z-Add     *Zero         WUNODL
      *
     C                   Endif
      *
     CSR   SHEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Detail Screen Header Title                            *
      *****************************************************************
     CSR   UASUBR        Begsr
      *
      ** Setup message data for message
      *
     C     WP0001        Ifeq      'E'
     C                   Movel     'XXX1180'     ZAMSID
     C                   Else
     C                   Movel     'XXX1181'     ZAMSID
     C                   Endif
      *
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm                    ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUDFTL        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      *
      ** Move to Header Title - Standard Functions  *
      *
     C                   Movel     WUDFTL        ##URPT
      *
     CSR   UAEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Detail Screen Footer                                  *
      *****************************************************************
     CSR   UBSUBR        Begsr
      *
      ** Setup message data for message
      *
     C                   Movel     ZADFMF        ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'USR2919'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUSFT1        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      *
      ** Move to Single Footer - Standard Functions  *
      *
     C                   Movel     WUSFT1        ##CTX1
      *
     CSR   UBEXIT        Endsr
      /EJECT

      *****************************************************************
      * Set up Detail Screen Header Title                             *
      *****************************************************************
     CSR   UCSUBR        Begsr
      *
      ** Setup message data for message
      *
     C     WP0001        Ifeq      'E'
     C                   Movel     'XXX1180'     ZAMSID
     C                   Else
     C                   Movel     'XXX1181'     ZAMSID
     C                   Endif
      *
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm                    ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUDFTL        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      *
      ** Move to Header Title - Standard Functions  *
      *
     C                   Movel     WUDFTL        ##URPT
      *
     CSR   UCEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Detail Screen Footer                                  *
      *****************************************************************
     CSR   UDSUBR        Begsr
      *
      ** Amend or Enquiry mode
      *
     C     P2ANCD        Ifeq      'E'
     C     P2ANCD        OREQ      'A'
      *
      ** Setup message data for message
      *
     C                   Movel     ZADFMF        ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'USR2920'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUSFT1        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
     C                   Endif
      *
      ** Delete mode
      *
     C     P2ANCD        Ifeq      'D'
      *
      ** Setup message data for message
      *
     C                   Movel     ZADFMF        ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'USR2921'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUSFT1        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
     C                   Endif
      *
      ** Move to Single Footer - Standard Functions  *
      *
     C                   Movel     WUSFT1        ##CTX1
      *
     CSR   UDEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Key Screen Header Title                               *
      *****************************************************************
     CSR   UFSUBR        Begsr
      *
      ** Setup message data for message
      *
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'XXX1182'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUDFTL        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      *
      ** Move to Header Title - Standard Functions  *
      *
     C                   Movel     WUDFTL        ##URPT
      *
     CSR   UFEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Key Screen Footer                                     *
      *****************************************************************
     CSR   UGSUBR        Begsr
      *
      ** Setup message data for message
      *
     C                   Movel     ZADFMF        ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'USR2918'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUSFT1        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      *
      ** Move to Single Footer - Standard Functions  *
      *
     C                   Movel     WUSFT1        ##CTX1
      *
     CSR   UGEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Key Screen Header Title                               *
      *****************************************************************
     CSR   UHSUBR        Begsr
      *
      ** Setup message data for message
      *
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'XXX1182'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUDFTL        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      *
      ** Move to Header Title - Standard Functions  *
      *
     C                   Movel     WUDFTL        ##URPT
      *
     CSR   UHEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Key Screen Footer                                     *
      *****************************************************************
     CSR   UISUBR        Begsr
      *
      ** Setup message data for message
      *
     C                   Movel     ZADFMF        ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'USR2918'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUSFT1        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      *
      ** Move to Single Footer - Standard Functions  *
      *
     C                   Movel     WUSFT1        ##CTX1
      *
     CSR   UIEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Send message to program's message queue                      *
      *****************************************************************
     CSR   ZASNMS        Begsr
     C     ZAPGMQ        Ifeq      *Blank
     C                   Movel     ##PGM         ZAPGMQ
     C                   Endif
      *
      ** If no message file specified, use default
      *
     C     ZAMSGF        Ifeq      *Blank
     C                   Movel     ZADFMF        ZAMSGF
     C                   Endif
     C                   Call      'Y2SNMGC'
     C                   Parm                    ZAPGMQ           10
     C                   Parm                    ZAPGRL            5
     C                   Parm                    ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C                   Parm                    ZAMSTP            7
      *
      ** Clear all fields for default mechanism next Time
      *
     C                   Movel     *Blank        ZAPGMQ
     C                   Movel     *Blank        ZAPGRL
     C                   Movel     *Blank        ZAMSID
     C                   Movel     *Blank        ZAMSGF
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSTP
      *
     CSR   ZAEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Cancel and exit from key screen                              *
      *****************************************************************
     CSR   ZXEXPG        Begsr
      *
      ** USER: Exit program processing
      ** Case: KEY.*CMD key is *Exit
      *
     C     *IN03         Ifeq      '1'
     C                   Movel     'Y2U9999'     P0RTN
     C                   Exsr      ZYEXPG
     C                   Endif
     C*
     C                   Movel     *Blank        P0RTN
     C                   Exsr      ZYEXPG
      *
     CSR   ZXEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Exit program: Direct                                         *
      *****************************************************************
     CSR   ZYEXPG        Begsr
      *
      ** ROLLBACK any uncommitted DBF changes
      *
     C                   Rolbk                                          90
      *
      ** Exit program
      *
     C                   Return
      *
     CSR   ZYEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Initialisation                                               *
      *****************************************************************
     CSR   ZZINIT        Begsr
      *
     C                   Move      *Blank        P0RTN
     C                   Move      *Blank        W0RTN             7
      *
      ** Initialise indicators for re-Entry
      *
     C                   Move      '0'           *IN
      *
      ** Update screen Time
      *
     C                   Time                    ##TME             6 0
      *
      ** Define work field Display File Title
      *
     C                   Movel     *Blank        WUDFTL           53
      *
      ** Obtain default message file
      *
     C     *Dtaara       Define    Y2MGFLA       ZADFMF           10
     C                   In        ZADFMF
      *
      ** Define work field STD FTR 1
      *
     C                   Movel     *Blank        WUSFT1           78
      *
      ** Define work field Midas Run Date
      *
     C                   Movel     *Blank        WUMRDT            7
      *
      ** Define work field Run day number
      *
     C                   Z-Add     *Zero         WURDNB            5 0
      *
      ** Define work field No. of Records
      *
     C                   Z-Add     *Zero         WUNORC            5 0
      *
      ** Define work field No. of Inserts
      *
     C                   Z-Add     *Zero         WUNOIN            5 0
      *
      ** Define work field No. of Amends
      *
     C                   Z-Add     *Zero         WUNOAM            5 0
      *
      ** Define work field No. of Deletes
      *
     C                   Z-Add     *Zero         WUNODL            5 0
      *
      ** Define work field Output field indicator
      *
     C                   Movel     *Blank        WUOFIN            1
      *
      ** Define work field Set Up Complete
      *
     C                   Movel     *Blank        WUSUC             1
      *
      ** Define work field Date format flag
      *
     C                   Movel     *Blank        WUDFF             1
      *
      ** Define work field Multi-branching Indicator
      *
     C                   Movel     *Blank        WUMBIN            1
      *
      ** Define work field Customer
      *
     C                   Movel     *Blank        #WCUST            6
      *
      ** Open files first Time only
      *
     C     W0OPN         Ifeq      *Blank
      *
      ** Begin Commit control
      *
     C                   Call      'Y2BGCMC'
     C                   Parm                    W0RTN             7
     C     W0RTN         Ifne      *Blank
     C     W0RTN         Andne     'CPF8351'
     C                   Exsr      ZYEXPG
     C                   Endif
      *
     C                   Open      A1008001DF
     C                   Open      A1CONBL0
     C                   Open      A1CONBL1
      *
      ** Signal that files are now Open
      *
     C                   Move      'Y'           W0OPN             1
     C                   Endif
      *
     C                   Movel     'N'           W0PMT             1
      *
      ** Select initial mode
      *
     C     @1NROP        Ifeq      *Zero
      *
      ** Add mode
      *
     C                   Movel     'ADD'         W0PMD             3
     C                   Else
      *
      ** Change mode
      *
     C                   Movel     'CHG'         W0PMD
     C                   Endif
      *
      ** Copyright Statement and Rundate setup
      *
     C     *Dtaara       Define                  RUNDAT
     C                   In        RUNDAT
     C                   Move      MRDT          ##MRDT            7
     C                   Move      MRDT          WUMRDT
     C                   Move      RDNB          WURDNB
     C                   Move      SUC           WUSUC
     C                   Move      DFF           WUDFF
     C                   Move      MBIN          WUMBIN
      *
      ** Action Enquire or Delete
      *
     C     P2ANCD        Ifeq      'E'
     C     P2ANCD        Oreq      'D'
     C                   Movel     'Y'           WUOFIN
     C                   Endif
      *
     CSR   ZZEXIT        Endsr
      /EJECT

      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatiCally if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     CSR   *PSSR         Begsr
      *
      ** Standard Midas PSSR processing.
      *
     C     @RUN          Ifeq      *Blank
     C                   Move      'Y'           @RUN              1
     C                   Move      'PSSR   '     P0RTN
     C                   Dump
      *
      ** Route job back into Midas.
      *
     C                   Seton                                        LR
     C                   Call      'DBERRCTL'
     C                   End
      *
     CSR                 Endsr
      *****************************************************************
