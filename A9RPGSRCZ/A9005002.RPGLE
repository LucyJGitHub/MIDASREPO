     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas A9 Account Codes Mapping to HO Details')         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  A9005002 - Midas A9 Account Codes Mapping to HO Details      *
      *               Enquiry screen                                  *
      *                                                               *
      *  Function:  This program will maintain the mapping between    *
      *             the Midas Account Codes and HO Details            *
      *                                                               *
      *  (C) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. MD062458           Date 25Mar24               *
      *  Prev Amend No. MD059284           Date 11Mar24               *
      *                 BA9005  *CREATE    Date 11Mar24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD062458 - Change GBA9USRMSG message file to GBXXUSRMSG      *
      *  MD059284 - HO Product Code and Market Code not mandatory     *
      *  BA9005 - HO and EDW Extracts                                 *
      *                                                               *
      *****************************************************************
      *
      ** Midas A/c Codes Mapping to HO Details screen
     FA9005002DFCF   E             Workstn Usropn
     F                                     Infds(Infds#)
     F                                     Infsr(*PSSR)

      ** Midas A/c Codes Mapping to HO Details - Rtv
     FA9ACHOML0 IF   E           K DISK    Usropn
     F                                     Infds(Infds1)
     F                                     Infsr(*PSSR)
     F                                     Rename(A9ACHOMD0:A9ACHOMDB)

      ** Midas A/c Codes Mapping to HO Details - Upd
     FA9ACHOML1 UF A E           K DISK    Usropn
     F                                     Commit
     F                                     Infds(ID0001)
     F                                     Infsr(*PSSR)
     F                                     Rename(A9ACHOMD0:A9ACHOMDA)
      /EJECT

      *****************************************************************
      ** +-------------------------------+
      ** ¦ Data structures specification |
      ** +-------------------------------+
      *
      ** Pgm Data srtucture
     D PGMDS         ESDs                  Extname(Y2PGDSP)

      ** Display file information data structure
     D Infds#        E Ds                  Extname(Y2I#DSP)

      ** File information data structure
     D Infds1        E Ds                  Extname(Y2I1DSP)

      ** HO Details Mapping
     D @1DBRC        E Ds                  Extname(A9ACHOML0)

      ** Long DS for access programs
     D DSSDY         E Ds                  Extname(DSSDY)

      ** Stored master file format fields
     D #1DBRC          Ds            23
     D  #1DB1                  1     10S 0
     D  #1DB2                 11     15
     D  #1DB3                 16     19
     D  #1DB4                 20     22
     D  #1DB5                 23     23

      ** Standing data controls update
     D YBRDCS          Ds            23
     D YCRDCS          Ds            23

      ** Validation Array for valid Midas A/c Code
     D VLD             S              1A   DIM(10) PERRCD(10) CTDATA

      ** Index for looping through the Midas A/c Code
     D WIdx1           S              2S 0

      ** Midas A/c Code
     D MidAccod        S              1A   DIM(10)

      ** Run date
     D RUNDAT          Ds
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13

      ** File information data structure
     D ID0001          Ds           528

      ** File information data structure
     D ID0002          Ds           528

     D P1Parm          Ds            23
     D  P1MDAC                 1     10
     D  P1HOAC                11     15
     D  P1HOPC                16     19
     D  P1HOMC                20     22
     D  P1EXCL                23     23

      ** MAP Action Code
     D P2Parm          Ds
     D  P2ANCD                 1      1

     D                 Ds
     D  ZAMSDA                 1    132
     D  ZA0001                 1      3
     D  ZA0002                 1      6

      ** Renamed input format fields
     IA9ACHOMDB
     I              XXMACOD                     WACODE
      /EJECT

      *****************************************************************
      ** Entry parameters
      *****************************************************************
      *
     C     *Entry        Plist
     C                   Parm                    P0RTN             7
     C                   Parm                    P1Parm
     C     P2ANCD        Parm                    WP0001            1
      ** Initialize
     C                   Exsr      ZZINIT
      *
      ** Check passed parameters
     C                   Exsr      FACKPM
      ** Perform once if all passed, Else repeat
     C     W0RPT         Doueq     'N'
      ** Display and process key screen
     C                   Exsr      BADSKY
     C                   Enddo
      ** Terminate program
     C                   Exsr      ZXEXPG
      *
      /EJECT

      *****************************************************************
      ** Display and process key screen
      *****************************************************************
     CSR   BADSKY        Begsr

      ** Initialize key screen
     C                   Exsr      MDIZ#K

      ** Bypass first display of key screen is possible
     C                   Movel     'Y'           W0BYP             1
      ** Signal start of transaction
     C                   Movel     'Y'           W0TRN             1
     C     W0TRN         Doweq     'Y'
     C     W0TRN         Oreq      'K'
      ** Ensure transaction continues (if reset)
     C                   Movel     'Y'           W0TRN             1
      ** Conduct screen conversation
     C     W0TRN         Doweq     'Y'
      ** Is bypass key screen still viable?
     C     W0BYP         Ifeq      'Y'
     C     #1MDAC        Ifeq      *Blanks
      ** One or more key fields is Blank
     C     *IN05         Oreq      '1'
      ** HOME: Reset screen fields
     C                   Movel     'N'           W0BYP
     C                   Endif
     C                   Endif

      ** Bypass key screen
     C     W0BYP         Ifne      'Y'
      ** Display key screen
     C                   Exsr      BBEXFM
     C                   Endif

      ** Cancel key screen bypass
     C                   Movel     'N'           W0BYP

      ** Process response to key screen
      ** Cancel & exit program
     C   03              Cas                     ZXEXPG

      ** Switch between *ADD/*CHANGE modes
     C   09              Cas                     BCCHMD

      ** HOME: Reset screen fields
     C   05              Cas                     BDHMKY

      ** Process key screen input
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
      * Display key screen
      *****************************************************************
     CSR   BBEXFM        Begsr

      **Set screen conditioning indicators
     C                   Exsr      GADSAK
      ** Update screen Time
     C                   Time                    ##TME
     C     W0HLP         Doueq     'N'
     C                   Movel     'N'           W0HLP             1
     C                   Move      *ALL'0'       ##OFF            30
     C                   MoveA     ##OFF         *IN(1)

      ** PUTOVR unless conditioned fields change
     C                   Seton                                            86
     C     *IN89         Ifne      BBIN89
     C                   Setoff                                           86
     C                   Endif
     C                   Move      *IN89         BBIN89            1

      ** Display Prompt 1
     C                   Write     #MSGCTL
     C                   Write     #CMDTXT1
     C                   Exfmt     #RCDKEY
      *
     C                   Enddo
      ** Clear messages from program message queue
     C                   Call      'Y2CLMSC'
     C                   Parm      ##PGM         ZAPGMQ           10
     C                   Parm      '*SAME'       ZAPGRL            5
      ** Reset first message only flag
     C                   Movel     'Y'           ZAFSMS            1
      ** Reset global error indicator
     C                   Setoff                                           99
      *
     CSR   BBEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Switch between *ADD/*CHANGE modes
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
      ** Process HOME key
      *****************************************************************
     CSR   BDHMKY        Begsr
      *
     C                   Movel     'N'           W0TRN
      *
     CSR   BDEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Process key screen input
      *****************************************************************
     CSR   BEPRKY        Begsr

      ** Initialise detail screen
     C                   Exsr      MAIZ#1

      ** Validate key fields
     C                   Exsr      BFVLKY
     C     *IN99         CabEq     '1'           BEEXIT

      ** Check for existing record
     C     KRTV          Klist
     C                   Kfld                    XXMACOD
      ** Setup key
     C                   Move      #1MDAC        XXMACOD
     C     KRTV          Chain     A9ACHOMDB                          9091
     C     *IN91         Ifeq      '1'
      ** Record locked
     C                   Seton                                        9931
     C                   Goto      BEEXIT
     C                   Endif

      ** If record does not exist, flip to add mode
     C     *IN90         Ifeq      '1'
     C                   Movel     'ADD'         W0PMD
      ** Set up Detail Screen Header Title
     C                   Exsr      UASUBR
      ** Set up Detail Screen Footer
     C                   Exsr      UBSUBR
      *
     C                   Else
      ** If record does exist, flip to change mode
     C                   Movel     'CHG'         W0PMD
      ** Load screen fields from DBF
     C                   Exsr      MBFL#1
      ** Set up Detail Screen Header Title
     C                   Exsr      UCSUBR
      ** Set up Detail Screen Footer
     C                   Exsr      UDSUBR
     C*
     C                   Endif
      *
     C   99              Goto      BEEXIT

      ** No error: Display and process details
     C                   Exsr      CADSDA
      *
     CSR   BEEXIT        Endsr
      /EJECT

      *****************************************************************
      * Validate key fields
      *****************************************************************
     CSR   BFVLKY        Begsr

      ** Validate entries
     C                   If        P2ANCD = 'I'
     C                   Setoff                                       9931

      ** Midas A/c Code validation
      ** Midas A/c code should consist of 4 digits
     C                   MoveA     #1MDAC        MidAccod

     C                   For       WIdx1 = 1 TO 10
     C                   If        %LookUp(MidAccod(WIdx1):VLD) = 0
     C                   Seton                                        99
     C                   Seton                                        31
     C                   Movel     'A9X0011'     ZAMSID
     C**********         Movel     'GBA9USRMSG'  ZAMSGF                                     MD062458
     C                   Movel     'XXUSRMSG'    ZAMSGF                                     MD062458
     C                   Exsr      ZASNMS
     C                   Goto      BFEXIT
     C                   Endif
     C                   EndFor
     C                   If        *IN31 = *Off

      ** Check for existing record
     C                   Move      #1MDAC        XXMACOD
     C     KRTV          Chain     A9ACHOMDB                          90
     C                   If        *IN90 = *off
      ** Duplicate Midas A/c Code entered
     C                   Seton                                        99
     C                   Seton                                        31
     C                   Movel     'A9X0014'     ZAMSID
     C**********         Movel     'GBA9USRMSG'  ZAMSGF                                     MD062458
     C                   Movel     'XXUSRMSG'    ZAMSGF                                     MD062458
     C                   Exsr      ZASNMS
     C                   Endif
      *
     C                   Endif
      *
     C                   Endif
      *
     CSR   BFEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Display and process detail screen
      *****************************************************************
     CSR   CADSDA        Begsr

      ** Repeat until screen control flag is reset:
     C     W0TRN         DOWEQ     'Y'
      ** Display detail screen
     C                   Exsr      CBEXFM
      ** Process response to detail screen
      ** Cancel & exit program
     C   03              Cas                     ZXEXPG
      ** Redisplay previous screen
     C   12              Cas                     CCDSPV
      ** HOME: Reset screen fields
     C   05              Cas                     CCDSPV
      ** Process detail screen input
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
      ** Display screen
      *****************************************************************
     CSR   CBEXFM        Begsr

      ** Set screen conditioning indicators
     C                   Exsr      GBDSAD

      ** Update screen Time
     C                   Time                    ##TME
     C     W0HLP         Doueq     'N'
     C                   Movel     'N'           W0HLP             1
     C                   Move      *ALL'0'       ##OFF            30
     C                   MoveA     ##OFF         *IN(1)

      ** PUTOVR unless conditioned fields change
     C                   Seton                                            86
     C     *IN89         Ifne      CBIN89
     C                   Setoff                                           86
     C                   Endif
     C                   Move      *IN89         CBIN89            1
      *
     C                   Write     #MSGCTL
     C                   Write     #CMDTXT2
     C                   Exfmt     #RCDDTL1

     C                   Enddo
      ** Clear messages from program message queue
     C                   Call      'Y2CLMSC'
     C                   Parm      ##PGM         ZAPGMQ           10
     C                   Parm      '*SAME'       ZAPGRL            5
      ** Reset first message only flag
     C                   Movel     'Y'           ZAFSMS            1
      ** Reset global error indicator
     C                   Setoff                                           99
      *
     CSR   CBEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Redisplay previous screen
      *****************************************************************
     CSR   CCDSPV        Begsr

      ** Case: PAR.Action Code is Insert
     C     P2ANCD        Ifeq      'I'
      ** Set up Key Screen Header Title
     C                   Exsr      UFSUBR
      ** Set up Key Screen Footer
     C                   Exsr      UGSUBR
     C                   Else
      ** Case: *Otherwise
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
      * Validate record
      *================================================================
     CSR   CFPRSC        Begsr

      ** Confirm/update is not deferred
     C                   Movel     'N'           W0DCF             1
      ** Validate details
     C  N10              Cas                     DCVLDL
     C                   End
      ** QUIT if error:
     C   99              Goto      CFEXIT
      ** Redisplay if change of customer entry.
     C   98              Goto      CFEXIT
      ** Defer confirm/update requested
     C     W0DCF         CabEq     'Y'           CFEXIT

      ** No error: update record
     C                   Exsr      EBPR##
      *
     CSR   CFEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Validate details
      *****************************************************************
     CSR   DCVLDL        Begsr

      ** USER: Validate detail screen relations
     C                   Setoff                                       98
      *
     C     WP0001        Ifne      'E'
     C     W0PMD         Ifeq      'ADD'
     C     W0PMD         Oreq      'CHG'
      *
     C                   Setoff                                       993141
     C                   Setoff                                       424344

      ** Check if record exists - Midas A/c Code
     C     W0PMD         Ifeq      'ADD'
     C                   Exsr      SDRVGN

      ** Case: PGM.*Return code is *Record already exists
     C     W0RTN         Ifeq      'Y2U0003'
      ** Setup message data for message
     C                   Movel     #1HOAC        ZA0001
      ** Send message 'Midas A/c Code must be unique'
     C                   Movel     'A9X0005'     ZAMSID
     C**********         Movel     'GBA9USRMSG'  ZAMSGF                                     MD062458
     C                   Movel     'XXUSRMSG'    ZAMSGF                                     MD062458
     C                   Exsr      ZASNMS
     C                   Seton                                        9941
     C                   Goto      DCEXIT
     C                   Endif
     C                   Endif

      ** Case: *Otherwise
     C                   If        #1HOAC = *Blanks
      ** HO A/c Code must be entered
     C                   Seton                                        9942
     C                   Movel     'A9X0006'     ZAMSID
     C**********         Movel     'GBA9USRMSG'  ZAMSGF                                     MD062458
     C                   Movel     'XXUSRMSG'    ZAMSGF                                     MD062458
     C                   Exsr      ZASNMS
     C                   Endif
      *
      ** HO Product Code and Market Code not mandatory                                      MD059284
     C**********         If        #1HOPC = *Blanks                                         MD059284
      **HO*Product*Code*must be entered                                                     MD059284
     C**********         Seton                                        9943                  MD059284
     C**********         Movel     'A9X0007'     ZAMSID                                     MD059284
     C**********         Movel     'XXUSRMSG'    ZAMSGF                                     MD059284
     C**********         Exsr      ZASNMS                                                   MD059284
     C**********         Endif                                                              MD059284
      *                                                                                     MD059284
     C**********         If        #1HOMC = *Blanks                                         MD059284
      **HO*Market*Code*must be entered                                                      MD059284
     C**********         Seton                                        9944                  MD059284
     C**********         Movel     'A9X0008'     ZAMSID                                     MD059284
     C**********         Movel     'XXUSRMSG'    ZAMSGF                                     MD059284
     C**********         Exsr      ZASNMS                                                   MD059284
     C**********         Endif                                                              MD059284
      *
     C                   If        #1EXCL = *Blanks
      ** Exclude flag must be entered
     C                   Seton                                        9945
     C                   Movel     'A9X0009'     ZAMSID
     C**********         Movel     'GBA9USRMSG'  ZAMSGF                                     MD062458
     C                   Movel     'XXUSRMSG'    ZAMSGF                                     MD062458
     C                   Exsr      ZASNMS
     C                   Else
     C                   If        #1EXCL <> 'Y' and #1EXCL <> 'N'
      ** Exclude flag must be 'Y' or 'N'
     C                   Seton                                        9945
     C                   Movel     'A9X0010'     ZAMSID
     C**********         Movel     'GBA9USRMSG'  ZAMSGF                                     MD062458
     C                   Movel     'XXUSRMSG'    ZAMSGF                                     MD062458
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
     C                   Endif
     C                   Endif
      *
     CSR   DCEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Process record:
      *****************************************************************
     CSR   EBPR##        Begsr

      ** Process delete request
     C   10              Cas                     EDDLRQ

      ** Process add request
     C     W0PMD         CaseQ     'ADD'         ECADRQ

      ** Process update request
     C     W0PMD         CasNE     'ADD'         EECHRQ
     C                   End

      ** Error: ROLLBACK any DBF changes
     C     W0RTN         Ifne      *Blank
     C                   Rolbk
     C                   Goto      EBEXIT
     C                   Else
      ** Otherwise Commit any DBF changes
     C                   Commit
     C                   Endif

      ** USER: Process command keys
     C     W0RTN         Ifeq      *Blank
     C     W0PMD         Ifeq      'ADD'
      ** Exit after successful add
     C                   Movel     'N'           W0RPT
     C                   Endif
      ** Restart program for next record
     C                   Movel     'N'           W0TRN
     C                   Endif
      *
     CSR   EBEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Process add request
      *****************************************************************
     CSR   ECADRQ        Begsr

      ** Create Midas A/c Code
     C                   Exsr      SECRRC
     C     W0RTN         Ifeq      *Blank
      ** Send message '*Record added'
     C                   Movel     'Y2U0011'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Endif
      *
     CSR   ECEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Process delete request
      *****************************************************************
     CSR   EDDLRQ        Begsr

      ** Physical delete Midas A/c Code
     C                   Exsr      SGCHRC
     C     W0RTN         Ifeq      *Blank
      ** Send message '*Record deleted'
     C                   Movel     'Y2U0013'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Endif
      *
     CSR   EDEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Process update request
      *****************************************************************
     CSR   EECHRQ        Begsr

      ** Change Midas A/c Code
     C     WP0001        Ifne      'E'
     C                   Exsr      SHCHRC
     C     W0RTN         Ifne      *Blank
      ** Reset screen fields if changed record
     C     W0RTN         CaseQ     'Y2U0007'     MBFL#1
     C                   End
     C                   Else
      ** Send message '*Record changed'
     C                   Movel     'Y2U0012'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
     CSR   EEEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Check passed parameters
      *****************************************************************
     CSR   FACKPM        Begsr
      ** Is full key present?
     C     P1MDAC        Ifeq      *Blanks
      ** Not every key field passed - loop program
     C                   Movel     'Y'           W0RPT             1
     C                   Else
      ** Full key passed, so single shot program
     C                   Movel     'N'           W0RPT
     C                   Endif
      *
     CSR   FAEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set key screen conditioning indicators
      *****************************************************************
     CSR   GADSAK        Begsr
      *
     C     W0PMD         COMP      'ADD'                                  89
      *
     CSR   GAEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set detail screen conditioning indicators
      *****************************************************************
     CSR   GBDSAD        Begsr
      *
     C     W0PMD         Comp      'ADD'                                  89
      ** Protect key fields on detail screen
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
      ** Enable key screen
     C                   Seton                                        87
      *
     CSR   GBEXIT        Endsr
      /EJECT

      *****************************************************************
      * Initialise record - except for key fields
      *================================================================
     CSR   MAIZ#1        Begsr
      *
     C                   Movel     P2ANCD        #PANCD
      *
     C                   If        P2ANCD = 'I'
     C                   Movel     *Blanks       #1HOAC
     C                   Movel     *Blanks       #1HOPC
     C                   Movel     *Blanks       #1HOMC
     C                   Movel     *Blanks       #1EXCL

     C                   Setoff                                       314142
     C                   Setoff                                       434445
     C                   Endif
      *
     CSR   MAEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Move A9ACHOMTD fields to screen
      *****************************************************************
     CSR   MBFL#1        Begsr
      *
     C                   Move      WACODE        #1MDAC
     C                   Movel     XXMHOAC       #1HOAC
     C                   Movel     XXMHOPC       #1HOPC
     C                   Movel     XXMHOMC       #1HOMC
     C                   Movel     XXMEXCL       #1EXCL

      ** Hold existing record image
     C                   Move      *Blanks       #1DBRC
     C                   Movel     @1DBRC        #1DBRC
      *
     CSR   MBEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Initialize key screen
      *****************************************************************
     CSR   MDIZ#K        Begsr
      *
     C                   Movel     P2ANCD        #PANCD
     C                   Movel     P1MDAC        #1MDAC
     C                   Movel     P1HOAC        #1HOAC
     C                   Movel     P1HOPC        #1HOPC
     C                   Movel     P1HOMC        #1HOMC
     C                   Movel     P1EXCL        #1EXCL

      ** Set up Key Screen Header Title
     C                   Exsr      UHSUBR
      ** Set up Key Screen Footer
     C                   Exsr      UISUBR
      *
     CSR   MDEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Check if record exists - Midas A/c Code
      *****************************************************************
     CSR   SDRVGN        Begsr
      *
     C                   Movel     *Blank        W0RTN             7
      ** Declare restrictor key work fields
     C     *Like         Define    WACODE        WQSD01
      ** Define keylist
     C     KRSSD         Klist
     C                   Kfld                    WQSD01
      ** Move fields to key list
     C                   Move      #1MDAC        WQSD01
     C     KRSSD         Setll     A9ACHOMDB
     C     KRSSD         Reade     A9ACHOMDB                              90
     C     *IN90         Ifeq      '1'
     C                   Movel     'A9X0015'     W0RTN             7
      ** USER: Processing if Data record not found
     C                   Movel     'Y2U0005'     W0RTN
     C                   Goto      SDEXIT
     C                   Endif
      *
     C     *IN90         Doweq     '0'
     C                   Movel     'Y2U0003'     W0RTN
     C     KRSSD         Reade     A9ACHOMDB                              90
     C                   Enddo
      *
     CSR   SDEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Create Midas A/c Code
      *****************************************************************
     CSR   SECRRC        Begsr
      *
     C                   Movel     *Blank        W0RTN             7
      ** Move all fields to A9ACHOMTD
     C                   Move      #1MDAC        XXMACOD
     C                   Movel     #1HOAC        XXMHOAC
     C                   Movel     #1HOPC        XXMHOPC
     C                   Movel     #1HOMC        XXMHOMC
     C                   Movel     #1EXCL        XXMEXCL
      *
     C     KLCRSE        Klist
     C                   Kfld                    XXMACOD
      ** Check for duplicate primary key
     C     KLCRSE        Setll     A9ACHOMDA                              90
     C     *IN90         Ifeq      '1'
     C                   Movel     'A9X0014'     W0RTN             7
      ** Send message 'Midas A/c Code exist'
     C                   Movel     'A9X0014'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Goto      SEEXIT
     C                   Endif
      *
     C                   Write     A9ACHOMDA                            91
      *
     C     *IN91         Ifeq      '1'
      ** Write error detected
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Else
      ** USER: Processing after Data update
     C                   Z-Add     1             WUNORC
     C                   Z-Add     1             WUNOIN
     C                   Z-Add     *Zero         WUNOAM
     C                   Z-Add     *Zero         WUNODL
     C                   Endif
      *
     CSR   SEEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Physical delete of Midas A/c Code
      *****************************************************************
     CSR   SGCHRC        Begsr
     C                   Movel     *Blank        W0RTN             7
      ** Case: PAR.Action Code is Delete
     C     P2ANCD        Ifeq      'D'
     C                   Move      #1MDAC        XXMACOD
      *
     C     KLDLTR        Klist
     C                   Kfld                    XXMACOD
     C     KLDLTR        Chain     A9ACHOMDA                          9091
      *
     C     *IN90         Ifeq      '1'
      ** Record not found
     C                   Movel     'Y2U0009'     W0RTN             7
      ** Send message '*Record no longer on file'
     C                   Movel     'Y2U0009'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Goto      SGEXIT
     C                   Endif
      ** Record locked
     C     *IN91         Ifeq      '1'
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Goto      SGEXIT
     C                   Endif
      *
     C     *IN91         Ifeq      '0'
     C     *IN90         Andeq     '0'
     C                   Delete    A9ACHOMDA
     C                   Goto      SGEXIT
     C                   Endif
      *
     C                   Else
      ** Send message 'Function key not allowed'
     C                   Movel     'USR0533'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Seton                                        99
      *
     C                   Movel     'Y2U0004'     W0RTN
     C                   Goto      SGEXIT
     C                   Endif

      ** Set PGM.*Record Data Changed flag
     C                   Move      'N'           YBRDC             1
      *
      ** Move key fields to A9CACHOMTD
     C                   Move      #1MDAC        XXMACOD
      *
     C     KLCHSG        Klist
     C                   Kfld                    XXMACOD
     C     KLCHSG        Chain     A9ACHOMDA                          9091
     C     *IN90         Ifeq      '1'
      ** Record not found
     C                   Movel     'Y2U0009'     W0RTN             7
      ** Send message '*Record no longer on file'
     C                   Movel     'Y2U0009'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Goto      SGEXIT
     C                   Endif
      ** Record locked
     C     *IN91         Ifeq      '1'
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Goto      SGEXIT
     C                   End
      *
      ** Check for changed record
     C     #1DBRC        Ifne      @1DBRC
     C                   Movel     'Y2U0007'     W0RTN             7
      ** Send message '*Update not accepted'
     C                   Movel     'Y2U0007'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
      ** Release record lock
     C                   Unlock    A9ACHOML1                            91
     C                   Goto      SGEXIT
     C                   Endif
      ** Store record data for null update check
     C                   Move      @1DBRC        YBRDCS
      ** Set PGM.*Record Data Changed flag
     C     @1DBRC        Ifne      YBRDCS
     C                   Move      'Y'           YBRDC
     C                   Endif
      ** If changed update record otherwise release record
     C     YBRDC         Ifeq      'Y'
     C                   Update    A9ACHOMDA                            91
     C                   Else
      ** Release record lock
     C                   Unlock    A9ACHOML1                            91
     C                   End
      ** Change error detected
     C     *IN91         Ifeq      '1'
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Else
      ** Update saved record image
     C                   Move      *Blanks       #1DBRC
     C                   Movel     @1DBRC        #1DBRC
      ** DBF change successful
     C                   Endif
      *
     CSR   SGEXIT        Endsr
      /EJECT

      *****************************************************************
      * Change Midas A/c Code
      *****************************************************************
     CSR   SHCHRC        Begsr
      *
     C                   Movel     *Blank        W0RTN             7
      ** Set PGM.*Record Data Changed flag
     C                   Move      'N'           YCRDC             1
      ** Move key fields to A9ACHOMDA
     C                   Move      #1MDAC        XXMACOD
      *
     C     KLCHSH        Klist
     C                   Kfld                    XXMACOD
     C     KLCHSH        Chain     A9ACHOMDA                          9091
     C     *IN90         Ifeq      '1'
      ** Record not found
     C                   Movel     'Y2U0009'     W0RTN             7
      ** Send message '*Record no longer on file'
     C                   Movel     'Y2U0009'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Goto      SHEXIT
     C                   Endif
      ** Record locked
     C     *IN91         Ifeq      '1'
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Goto      SHEXIT
     C                   Endif

      ** Check for changed record
     C     #1DBRC        Ifne      @1DBRC
     C                   Movel     'Y2U0007'     W0RTN             7
      ** Send message '*Update not accepted'
     C                   Movel     'Y2U0007'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
      ** Release record lock
     C                   Unlock    A9ACHOML1                            91
     C                   Goto      SHEXIT
     C                   Endif
      ** Store record data for null update check
     C                   Move      @1DBRC        YCRDCS
      ** Move non-key fields to A9ACHOMTD
     C                   Movel     #1HOAC        XXMHOAC
     C                   Movel     #1HOPC        XXMHOPC
     C                   Movel     #1HOMC        XXMHOMC
     C                   Movel     #1EXCL        XXMEXCL

      ** Set PGM.*Record Data Changed flag
     C     @1DBRC        Ifne      YCRDCS
     C                   Move      'Y'           YCRDC
     C                   Endif
      ** If changed update record otherwise release record
     C     YCRDC         Ifeq      'Y'
     C                   Update    A9ACHOMDA                            91
     C                   Else
      ** Release record lock
     C                   Unlock    A9ACHOML1                            91
     C                   End
     C     *IN91         Ifeq      '1'
      ** Change error detected
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Else
      *
      ** Update saved record image
     C                   Move      *Blanks       #1DBRC
     C                   Movel     @1DBRC        #1DBRC
      ** DBF change successful
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
      ** Set up Detail Screen Header Title
      *****************************************************************
     CSR   UASUBR        Begsr
      ** Setup message data for message
     C     WP0001        Ifeq      'E'
     C                   Movel     'A9X0012'     ZAMSID
     C                   Else
     C                   Movel     'A9X0013'     ZAMSID
     C                   Endif
      *
     C**********         Movel     'GBA9USRMSG'  ZAMSGF                                     MD062458
     C                   Movel     'XXUSRMSG'    ZAMSGF                                     MD062458
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm                    ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUDFTL        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      ** Move to Header Title - Standard Functions  *
     C                   Movel     WUDFTL        ##URPT
      *
     CSR   UAEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Detail Screen Footer
      *****************************************************************
     CSR   UBSUBR        Begsr
      ** Setup message data for message
     C                   Movel     ZADFMF        ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'USR2919'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUSFT1        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      ** Move to Single Footer - Standard Functions  *
     C                   Movel     WUSFT1        ##CTX1
      *
     CSR   UBEXIT        Endsr
      /EJECT

      *****************************************************************
      * Set up Detail Screen Header Title
      *****************************************************************
     CSR   UCSUBR        Begsr
      ** Setup message data for message
     C     WP0001        Ifeq      'E'
     C                   Movel     'A9X0012'     ZAMSID
     C                   Else
     C                   Movel     'A9X0013'     ZAMSID
     C                   Endif
      *
     C**********         Movel     'GBA9USRMSG'  ZAMSGF                                     MD062458
     C                   Movel     'XXUSRMSG'    ZAMSGF                                     MD062458
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm                    ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUDFTL        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      ** Move to Header Title - Standard Functions  *
     C                   Movel     WUDFTL        ##URPT
      *
     CSR   UCEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Detail Screen Footer
      *****************************************************************
     CSR   UDSUBR        Begsr
      ** Amend or Enquiry mode
     C     P2ANCD        Ifeq      'E'
     C     P2ANCD        OREQ      'A'
      ** Setup message data for message
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
      ** Delete mode
     C     P2ANCD        Ifeq      'D'
      ** Setup message data for message
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
      ** Move to Single Footer - Standard Functions  *
     C                   Movel     WUSFT1        ##CTX1
      *
     CSR   UDEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Key Screen Header Title
      *****************************************************************
     CSR   UFSUBR        Begsr
      ** Setup message data for message
     C**********         Movel     'GBA9USRMSG'  ZAMSGF                                     MD062458
     C                   Movel     'XXUSRMSG'    ZAMSGF                                     MD062458
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'A9X0016'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUDFTL        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      ** Move to Header Title - Standard Functions  *
     C                   Movel     WUDFTL        ##URPT
      *
     CSR   UFEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Key Screen Footer
      *****************************************************************
     CSR   UGSUBR        Begsr
      ** Setup message data for message
     C                   Movel     ZADFMF        ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'USR2918'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUSFT1        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      ** Move to Single Footer - Standard Functions  *
     C                   Movel     WUSFT1        ##CTX1
      *
     CSR   UGEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Key Screen Header Title
      *****************************************************************
     CSR   UHSUBR        Begsr
      ** Setup message data for message
     C**********         Movel     'GBA9USRMSG'  ZAMSGF                                     MD062458
     C                   Movel     'XXUSRMSG'    ZAMSGF                                     MD062458
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'A9X0016'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUDFTL        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      ** Move to Header Title - Standard Functions  *
     C                   Movel     WUDFTL        ##URPT
      *
     CSR   UHEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Key Screen Footer
      *****************************************************************
     CSR   UISUBR        Begsr
      ** Setup message data for message
     C                   Movel     ZADFMF        ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'USR2918'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUSFT1        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      ** Move to Single Footer - Standard Functions  *
     C                   Movel     WUSFT1        ##CTX1
      *
     CSR   UIEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Send message to program's message queue
      *****************************************************************
     CSR   ZASNMS        Begsr
     C     ZAPGMQ        Ifeq      *Blank
     C                   Movel     ##PGM         ZAPGMQ
     C                   Endif
      ** If no message file specified, use default
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
      ** Clear all fields for default mechanism next Time
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
      ** Cancel and exit from key screen
      *****************************************************************
     CSR   ZXEXPG        Begsr
      ** USER: Exit program processing
      ** Case: KEY.*CMD key is *Exit
     C     *IN03         Ifeq      '1'
     C                   Movel     'Y2U9999'     P0RTN
     C                   Exsr      ZYEXPG
     C                   Endif
      *
     C                   Movel     *Blank        P0RTN
     C                   Exsr      ZYEXPG
      *
     CSR   ZXEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Exit program: Direct
      *****************************************************************
     CSR   ZYEXPG        Begsr
      ** ROLLBACK any uncommitted DBF changes
     C                   Rolbk                                          90
      *
      ** Exit program
     C                   Return
      *
     CSR   ZYEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Initialisation
      *****************************************************************
     CSR   ZZINIT        Begsr
      *
     C                   Move      *Blank        P0RTN
     C                   Move      *Blank        W0RTN             7
      ** Initialise indicators for re-Entry
     C                   Move      '0'           *IN
      ** Update screen Time
     C                   Time                    ##TME             6 0
      ** Define work field Display File Title
     C                   Movel     *Blank        WUDFTL           53
      ** Obtain default message file
     C     *Dtaara       Define    Y2MGFLA       ZADFMF           10
     C                   In        ZADFMF
      ** Define work field STD FTR 1
     C                   Movel     *Blank        WUSFT1           78
      ** Define work field Midas Run Date
     C                   Movel     *Blank        WUMRDT            7
      ** Define work field Run day number
     C                   Z-Add     *Zero         WURDNB            5 0
      ** Define work field No. of Records
     C                   Z-Add     *Zero         WUNORC            5 0
      ** Define work field No. of Inserts
     C                   Z-Add     *Zero         WUNOIN            5 0
      ** Define work field No. of Amends
     C                   Z-Add     *Zero         WUNOAM            5 0
      ** Define work field No. of Deletes
     C                   Z-Add     *Zero         WUNODL            5 0
      ** Define work field Output field indicator
     C                   Movel     *Blank        WUOFIN            1
      ** Define work field Set Up Complete
     C                   Movel     *Blank        WUSUC             1
      ** Define work field Date format flag
     C                   Movel     *Blank        WUDFF             1
      ** Define work field Multi-branching Indicator
     C                   Movel     *Blank        WUMBIN            1
      ** Define work field Customer
     C                   Movel     *Blank        #WCUST            6
      ** Open files first Time only
     C     W0OPN         Ifeq      *Blank
      ** Begin Commit control
     C                   Call      'Y2BGCMC'
     C                   Parm                    W0RTN             7
     C     W0RTN         Ifne      *Blank
     C     W0RTN         Andne     'CPF8351'
     C                   Exsr      ZYEXPG
     C                   Endif
      *
     C                   Open      A9005002DF
     C                   Open      A9ACHOML0
     C                   Open      A9ACHOML1

      ** Signal that files are now Open
     C                   Move      'Y'           W0OPN             1
     C                   Endif
      *
     C                   Movel     'N'           W0PMT             1

      ** Select initial mode
     C     @1NROP        Ifeq      *Zero
      ** Add mode
     C                   Movel     'ADD'         W0PMD             3
     C                   Else
      ** Change mode
     C                   Movel     'CHG'         W0PMD
     C                   Endif

      ** Copyright Statement and Rundate setup
     C     *Dtaara       Define                  RUNDAT
     C                   In        RUNDAT
     C                   Move      MRDT          ##MRDT            7
     C                   Move      MRDT          WUMRDT
     C                   Move      RDNB          WURDNB
     C                   Move      SUC           WUSUC
     C                   Move      DFF           WUDFF
     C                   Move      MBIN          WUMBIN

      ** Action Enquire or Delete
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

      ** Standard Midas PSSR processing.
     C     @RUN          Ifeq      *Blank
     C                   Move      'Y'           @RUN              1
     C                   Move      'PSSR   '     P0RTN
     C                   Dump

      ** Route job back into Midas.
     C                   Seton                                        LR
     C                   Call      'DBERRCTL'
     C                   End
      *
     CSR                 Endsr
      *****************************************************************
** VLD
0123456789
