     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas A9 Account Codes Mapping to HO Details')         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  A9005001 - Midas A9 Account Codes Mapping to HO Details      *
      *               Enquiry screen                                  *
      *                                                               *
      *  Function:  This program will maintain the mapping between    *
      *             the Midas Account Codes and HO Details            *
      *                                                               *
      *  (C) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. MD062458           Date 25Mar24               *
      *  Prev Amend No. BA9005  *CREATE    Date 11Mar24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD062458 - Change GBA9USRMSG message file to GBXXUSRMSG      *
      *  BA9005 - HO and EDW Extracts                                 *
      *                                                               *
      *****************************************************************
      ** Midas A/c Codes Mapping to HO Details screen
     FA9005001DFCF   E             Workstn Usropn
     F                                     Sfile(#SFLRCD:##RR)
     F                                     Infds(Infds#)
     F                                     Infsr(*PSSR)
      *
      ** A9 Midas A/c Codes Mapping to HO Details - Rtv
     FA9ACHOML0 IF   E           K DISK    Usropn
     F                                     Infds(Infds1)
     F                                     Infsr(*PSSR)
      *
      /EJECT
      *****************************************************************
      ** +-------------------------------+
      ** ¦ Data structures specification |
      ** +-------------------------------+
      *
     D PGMDS         ESDs                  Extname(Y2PGDSP)

      ** Display file information data structure
     D Infds#        E Ds                  Extname(Y2I#DSP)

      ** File information data structure
     D Infds1        E Ds                  Extname(Y2I1DSP)

      ** Copyright array
     D RUNDAT          Ds
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13

      ** Outward parameters

      ** Outward parameters
     D PARC            Ds            23
     D  PAMDAC                 1     10
     D  PAHOAC                11     15
     D  PAHOPC                16     19
     D  PAHOMC                20     22
     D  PAEXCL                23     23

      ** Validation Array for valid Midas A/c Code
     D VLD             S              1A   DIM(10) PERRCD(10) CTDATA

      ** Index for looping through the Midas A/c Code
     D WIdx1           S              2S 0

      ** Midas A/c Code
     D MidAccod        S              1A   DIM(10)

      ** Parameter declarations
     D P1Parm          Ds
     D  P1DFMD                 1      1

      **
     D                 Ds
     D  ZAMSDA                 1    132
     D  ZA0001                 1      1
     D  ZA0002                 1      1
      /EJECT

      *****************************************************************
      ** Entry parameters
      *****************************************************************
      *
     C     *Entry        Plist
     C                   Parm                    P0RTN             7
     C     P1DFMD        Parm                    WP0001            1

      ** Initialize
     C                   Exsr      ZZINIT

     C                   Do        *Hival
      ** Initialise & load subfile page
     C                   Exsr      BAIZSF
     C                   Movel     'N'           W0RSF             1

      ** Display screen until reload requested
     C     W0RSF         Doweq     'N'
      ** Display screen
     C                   Exsr      CAEXFM
      ** Process response
      ** Cancel & exit program
     C   03              Cas                     ZXEXPG
      ** HOME: Request subfile reload
     C   05              Cas                     FBRQRL
      ** Display next SFL page
     C   27              Cas                     BBLDSF
      ** Process screen input
     C                   Cas                     DAPR##
     C                   End
      *
     C                   Enddo
     C                   Enddo
      /EJECT

      *****************************************************************
      ** Initialise and load subfile page
      *****************************************************************
      *
     CSR   BAIZSF        Begsr
      ** Clear subfile
     C                   Seton                                        80
     C                   Write     #SFLCTL
     C                   Setoff                                       80
      ** Reset no of records in subfile
     C                   Z-Add     *Zero         ##RRMX            5 081
      ** Initialize subfile control
     C     KPOS          Klist
     C                   Kfld                    XXMACOD
      ** Setup key
     C                   Move      #2MDAC        XXMACOD
      *
     C     KPOS          Setll     A9ACHOML0
     C                   Read      A9ACHOML0                            8782
      ** Save previous selector values
     C     *LIKE         Define    #2MDAC        WZMDAC
     C                   Movel     #2MDAC        WZMDAC
     C     *LIKE         Define    #2HOAC        WZHOAC
     C                   Movel     #2HOAC        WZHOAC
     C     *LIKE         Define    #2HOPC        WZHOPC
     C                   Movel     #2HOPC        WZHOPC
     C     *LIKE         Define    #2HOMC        WZHOMC
     C                   Movel     #2HOMC        WZHOMC
     C     *LIKE         Define    #2EXCL        WZEXCL
     C                   Movel     #2EXCL        WZEXCL
      *
     C     *LIKE         Define    #2HOAC        #3HOAC
     C     *LIKE         Define    #2HOPC        #3HOPC
     C     *LIKE         Define    #2HOMC        #3HOMC
     C     *LIKE         Define    #2EXCL        #3EXCL
     C
      ** Load subfile page
     C                   Z-Add     0             ##RROK            5 0
     C                   Exsr      BBLDSF
     CSR   BAEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Load subfile page
      *****************************************************************
      *
     CSR   BBLDSF        Begsr
      ** Re-establish fields in Read-ahead record
     C   27              Do
     C  N82              ReadP     A9ACHOML0                              90
     C  N82              Read      A9ACHOML0                              90
     C                   Enddo

      ** Setof record error indicators
     C                   Movel     *ALL'0'       WKIND0            1
     C                   Movea     WKIND0        *IN(35)
      ** Start at previous highest record in SFL
     C                   Z-Add     ##RRMX        ##RR              5 0
      ** Reset count of DBF records Read
     C                   Z-Add     0             ##RRRD            5 0
      ** Set required pages based on *Set Cursor or *subfile Pages
     C     W0RR0         Ifgt      0
     C     W0RR0         Div       ##SFPG        ##SPG             3 0
     C                   Mvr                     ##SLIN            3 0

     C     ##SLIN        Ifgt      0
     C                   Add       1             ##SPG
     C                   Endif

     C     W0SPG         Ifgt      ##SPG
     C                   Z-Add     W0SPG         ##SPG
     C                   Endif

     C                   Else
     C                   Z-Add     W0SPG         ##SPG
     C                   Endif

      ** Compute lines required based on pages
     C     ##SPG         Mult      ##SFPG        ##SFLN            9 0
     C     ##SFLN        Ifgt      999
     C                   Z-Add     999           ##SFLN
     C                   Endif

      ** Load next SFL page until SFL page full, or scan limit reached
     C     *IN82         Doweq     '0'
     C     ##RROK        Andlt     ##SFLN
     C     ##RRRD        Andlt     W0SLM
      ** Check selection fields - if fail, Read next record
     C     #2MDAC        Ifeq      *Blanks
     C     #2HOAC        Ifne      *Blank
     C                   MOVE      XXMHOAC       #3HOAC
     C     #3HOAC        CabNe     #2HOAC        BB020
     C                   Endif
     C                   Endif
      *
     C     #2MDAC        Ifeq      *Blanks
     C     #2HOAC        Oreq      *Blank
     C     #2HOPC        Ifne      *Blank
     C                   Eval      #3HOPC = XXMHOPC
     C     #3HOPC        CabNe     #2HOPC        BB020
     C                   Endif
     C                   Endif

     C     #2MDAC        Ifeq      *Blanks
     C     #2HOAC        Oreq      *Blank
     C     #2HOPC        Oreq      *Blank
     C     #2HOMC        Ifne      *Blank
     C                   Eval      #3HOMC = XXMHOMC
     C     #3HOMC        CabNe     #2HOMC        BB020
     C                   Endif
     C                   Endif

     C     #2MDAC        Ifeq      *Blanks
     C     #2HOAC        Oreq      *Blank
     C     #2HOPC        Oreq      *Blank
     C     #2HOMC        Oreq      *Blank
     C     #2EXCL        Ifne      *Blank
     C                   Eval      #3EXCL = XXMEXCL
     C     #3EXCL        CabNe     #2EXCL        BB020
     C                   Endif
     C                   Endif

      ** Load SFL fields
     C                   Exsr      MBFL#1
      ** Allow for possible *Set Cursor processing
     C                   Add       1             ##RR
     C                   Sub       1             ##RR
     C                   Movel     'Y'           W0RSL             1
      ** Allow for possible *Set Cursor processing
     C                   Add       1             ##RR
      ** USER: Initialize subfile record from DBF record
     C                   Sub       1             ##RR
      ** DBF record not selected
     C     W0RSL         CabNe     'Y'           BB020
      ** Output to subfile
     C                   Add       1             ##RR
     C                   Add       1             ##RROK               81
      ** If SFLRCD invalid, note that errors present
     C   98
     CANN99              Seton                                        99
     C                   Write     #SFLRCD
      ** Tag reference
     C     BB020         TAG
      ** Increment scan check count
     C                   Add       1             ##RRRD
     C                   Read      A9ACHOML0                              82
     C                   Enddo
      ** Tag reference
     C     BB900         TAG

      ** If no DBF records found, display error message
     C     ##RR          Ifeq      *Zero
     C     *IN82         Andeq     '1'
      ** Send message '*No data to display'
     C                   Movel     'Y2U0008'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Endif

      ** Save highest SFL record load can continue at end point
     C     ##RR          Ifgt      ##RRMX
      ** Calculate top line
     C     ##RROK        Div       ##SFPG        ##SPG
     C                   Mvr                     ##SLIN
     C     ##SLIN        Ifgt      0
     C     ##RR          Sub       ##SLIN        ##SFRC
     C                   Else
     C     ##RR          Sub       ##SFPG        ##SFRC
     C                   End
     C                   Add       1             ##SFRC
     C                   Z-Add     ##RR          ##RRMX
     C                   End

      ** If scan limit reached, display error message
     C     ##RRRD        Ifge      W0SLM
      ** Send message '*Scan limit reached'
     C                   Movel     'Y2U0017'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Else
     C                   Z-Add     0             ##RROK
     C                   End
     CSR   BBEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Display screen
      *****************************************************************
     CSR   CAEXFM        Begsr
      *
     C     W0HLP         Doueq     'N'
     C                   Movel     'N'           W0HLP             1
     C                   Move      *ALL'0'       ##OFF            30
     C                   MoveA     ##OFF         *IN(1)
      ** Update screen time
     C                   Time                    ##TME
      ** PUTOVR unless conditioned fields change
     C                   Seton                                        86
     C     *IN81         Ifne      CAIN81
     C                   Setoff                                       86
     C                   Endif
     C                   Move      *IN81         CAIN81            1
      *
     C                   Write     #MSGCTL
     C                   Write     #CMDTXT1
     C                   Exfmt     #SFLCTL
      ** Maintain subfile position where possible
     C     @#SFRC        Ifgt      *Zero
     C                   Z-Add     @#SFRC        ##SFRC
     C                   Endif
      *
     C                   Enddo
      ** Clear messages from program message queue
     C                   Call      'Y2CLMSC'
     C                   Parm      ##PGM         ZAPGMQ           10
     C                   Parm      '*SAME'       ZAPGRL            5
      ** Reset first message only flag
     C                   Movel     'Y'           ZAFSMS            1      99
     C                   Setoff                                         8392
     CSR   CAEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Process screen input
      *****************************************************************
     CSR   DAPR##        Begsr

      ** Confirm/update is not deferred
     C                   Movel     'N'           W0DCF             1
      ** Change of position specified
     C     WZMDAC        CasNe     #2MDAC        FBRQRL
     C     WZHOAC        CasNe     #2HOAC        FBRQRL
     C     WZHOPC        CasNe     #2HOPC        FBRQRL
     C     WZHOMC        CasNe     #2HOMC        FBRQRL
     C     WZEXCL        CasNe     #2EXCL        FBRQRL
     C                   End

      ** USER: Process subfile control (Pre-confirm)
      ** Reload subfile requested
     C     W0RSF         CabEq     'Y'           DAEXIT
     C     *IN81         Ifeq      '1'
      ** Process subfile records
     C                   Exsr      DBPRSF
     C                   Endif

      ** USER: Final processing (Pre-confirm)
      ** If error, quit processing
     C     *IN99         CabEq     '1'           DAEXIT
      ** Defer confirm/update requested
     C     W0DCF         CabEq     'Y'           DAEXIT

      ** USER: Process command keys
      ** CASE: PAR.Display file mode is Maintenance mode
     C     P1DFMD        Ifeq      'M'
      ** CASE: CTL.*CMD key is *Add
     C     *IN09         Ifeq      '1'
      ** Initialize calling parameters
     C                   Clear                   PARC
     C                   Movel     #2MDAC        PAMDAC
      ** Call A/c Code HO Details Mapping Maintenance screen
     C                   Call      'A9005002'                           90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm                    PARC
     C                   Parm      'I'           WQ0001            1
      *
     C     *IN90         Ifeq      '1'
      ** Call to program ended in error
     C                   Movel     'Y2U0032'     W0RTN
     C                   Movel     *Blanks       W0CLPG           10
     C                   Movel     'A9005002'    W0CLPG
      ** Send message '*Error occured on Call...'
     C                   Movel     'Y2U0032'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Movel     W0CLPG        ZAMSDA
     C                   Exsr      ZASNMS
     C                   Endif

      ** Error detected?
     C     W0RTN         Ifne      *Blank
     C                   Seton                                        9931
     C                   Endif
     C                   Movel     'Y'           W0RSF
     C                   Endif
     C                   Else

      ** CASE: *Otherwise
      ** CASE: CTL.*CMD key is *Go to 'Add' mode
     C     *IN09         Ifeq      '1'
      ** Send message 'Function key not allowed'
     C                   Movel     'USR0533'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Seton                                        99
      *
     C                   Endif
     C                   Endif
      *
     CSR   DAEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Process modified subfile record
      *****************************************************************
     CSR   DBPRSF        Begsr
      *
     C                   ReadC     #SFLRCD                                92
     C     *IN92         Doweq     '0'
      ** Process subfile record
     C                   Exsr      DCPRSR
     C                   Update    #SFLRCD
     C                   ReadC     #SFLRCD                                92
      *
     C                   Enddo
     CSR   DBEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Process subfile record
      *****************************************************************
     CSR   DCPRSR        Begsr

      ** Setof error indicators and SFLNXTCHG
     C                   MoveA     WKIND0        *IN(35)
     C                   Setoff                                       98

      ** USER: Process subfile record (Pre-confirm)
      ** Enquire Entered. CASE: RCD.*SFLSEL is *Enquire
     C     #1SEL         Ifeq      'E'
      ** Initialize calling parameters
     C                   Clear                   PARC
     C                   Movel     #1MDAC        PAMDAC
     C                   Movel     #1HOAC        PAHOAC
     C                   Movel     #1HOPC        PAHOPC
     C                   Movel     #1HOMC        PAHOMC
     C                   Movel     #1EXCL        PAEXCL
      ** Call CNAPS Codeword Maintenance
     C                   Call      'A9005002'                           90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm                    PARC
     C                   Parm      'E'           WQ0002            1
      *
     C     *IN90         Ifeq      '1'
      ** Call to program ended in error
     C                   Movel     'Y2U0032'     W0RTN
     C                   Movel     *Blanks       W0CLPG           10
     C                   Movel     'A9005002'    W0CLPG
      ** Send message '*Error occured on Call...'
     C                   Movel     'Y2U0032'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Movel     W0CLPG        ZAMSDA
     C                   Exsr      ZASNMS
     C                   Endif

      ** Error detected?
     C     W0RTN         Ifne      *Blank
     C                   Seton                                        98
     C                   Endif
     C                   Movel     'Y'           W0RSF
     C                   Endif

      ** Amend or Delete Entered
      ** CASE: PAR.Display file mode is Maintenance mode
     C     P1DFMD        Ifeq      'M'
      ** CASE: RCD.*SFLSEL is *Amend
     C     #1SEL         Ifeq      'A'
      ** Initialize calling parameters
     C                   Clear                   PARC
     C                   Movel     #1MDAC        PAMDAC
     C                   Movel     #1HOAC        PAHOAC
     C                   Movel     #1HOPC        PAHOPC
     C                   Movel     #1HOMC        PAHOMC
     C                   Movel     #1EXCL        PAEXCL
      ** Call CNAPS Codeword Maintenance
     C                   Call      'A9005002'                           90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm                    PARC
     C                   Parm      'A'           WQ0003            1
      *
     C     *IN90         Ifeq      '1'
      ** Call to program ended in error
     C                   Movel     'Y2U0032'     W0RTN
     C                   Movel     *Blanks       W0CLPG           10
     C                   Movel     'A9005002'    W0CLPG
      ** Send message '*Error occured on Call...'
     C                   Movel     'Y2U0032'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Movel     W0CLPG        ZAMSDA
     C                   Exsr      ZASNMS
     C                   Endif

      ** Error detected?
     C     W0RTN         Ifne      *Blank
     C                   Seton                                        98
     C                   Endif
     C                   Movel     'Y'           W0RSF
     C                   Endif

      ** Delete Entered
      ** CASE: RCD.*SFLSEL is *Delete
     C     #1SEL         Ifeq      'D'
      ** Initialize calling parameters
     C                   Clear                   PARC
     C                   Movel     #1MDAC        PAMDAC
     C                   Movel     #1HOAC        PAHOAC
     C                   Movel     #1HOPC        PAHOPC
     C                   Movel     #1HOMC        PAHOMC
     C                   Movel     #1EXCL        PAEXCL
      ** Call CNAPS Codeword Maintenance
     C                   Call      'A9005002'                           90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm                    PARC
     C                   Parm      'D'           WQ0004            1
      *
     C     *IN90         Ifeq      '1'
      ** Call to program ended in error
     C                   Movel     'Y2U0032'     W0RTN
     C                   Movel     *Blanks       W0CLPG           10
     C                   Movel     'A9005002'    W0CLPG
      ** Send message '*Error occured on Call...'
     C                   Movel     'Y2U0032'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Movel     W0CLPG        ZAMSDA
     C                   Exsr      ZASNMS
     C                   Endif

      ** Error detected?
     C     W0RTN         Ifne      *Blank
     C                   Seton                                        98
     C                   Endif
     C                   Movel     'Y'           W0RSF
     C                   Endif
     C                   Else

      ** CASE: *Otherwise
      ** Amend entered in Enquiry mode
      ** CASE: RCD.*SFLSEL is *Amend
     C     #1SEL         Ifeq      'A'
      ** Setup message data for message
     C                   Movel     #1SEL         ZA0001
      ** Send message 'value for field not valid'
     C                   Movel     'USR0553'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Seton                                        9835
      *
     C                   Goto      DCEXIT
     C                   Endif

      ** Delete entered in Enquiry mode
      ** CASE: RCD.*SFLSEL is *Delete
     C     #1SEL         Ifeq      'D'
      ** Setup message data for message
     C                   Movel     #1SEL         ZA0002
      ** Send message 'value for field not valid'
     C                   Movel     'USR0553'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Seton                                        9835
      *
     C                   Goto      DCEXIT
     C                   Endif
     C                   Endif

      ** F3 taken from EDTRCD program
      ** CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         Ifeq      'Y2U9999'
     C                   Movel     W0RTN         P0RTN
     C                   Exsr      ZYEXPG
     C                   Endif
      *
     C     *IN98         Ifeq      '1'
      ** SFLRCD invalid
     C  N99              Z-Add     ##RR          ##SFRC               99
     C                   Seton                                        84
     C                   Else
      ** SFLRCD valid.
     C                   Setoff                                       84
     C                   Movel     *Blank        #1SEL
     C                   Endif
      *
     CSR   DCEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Request subfile reload
      *****************************************************************
     CSR   FBRQRL        Begsr
      *
     C                   Movel     'Y'           W0RSF
     C     *IN05         Ifeq      *On
     C                   Move      *Blanks       #2MDAC
     C                   Setoff                                       70
     C                   Move      *Blanks       #2HOAC
     C                   Move      *Blanks       #2HOPC
     C                   Move      *Blanks       #2HOMC
     C                   Move      *Blanks       #2EXCL
     C                   Endif
      *
      ** Midas A/c Code should be 10 long
     C                   Setoff                                       70
     C                   If        #2MDAC <> *Blanks
     C                   MoveA     #2MDAC        MidAccod
     C                   For       WIdx1 = 1 TO 10
     C                   If        %LookUp(MidAccod(WIdx1):VLD) = 0
     C                   Movel     'A9X0011'     ZAMSID
     C**********         Movel     'GBA9USRMSG'  ZAMSGF                                     MD062458
     C                   Movel     'XXUSRMSG'    ZAMSGF                                     MD062458
     C                   Seton                                        70
     C                   Exsr      ZASNMS
     C                   Movel     'N'           W0RSF
     C                   Goto      FBEXIT
     C                   Endif
     C                   EndFor
     C                   Endif
      *
     CSR   FBEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Move A9ACHOML0 fields to subfile
      *****************************************************************
     CSR   MBFL#1        Begsr
      *
     C                   Movel     *Blank        #1SEL
     C                   Move      XXMACOD       #1MDAC
     C                   Movel     XXMHOAC       #1HOAC
     C                   Movel     XXMHOPC       #1HOPC
     C                   Movel     XXMHOMC       #1HOMC
     C                   Movel     XXMEXCL       #1EXCL
      *
     CSR   MBEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Initialise subfile control
      *****************************************************************
     CSR   MEIZ#2        Begsr
      *
     C                   Movel     *Blank        #2MDAC
     C                   Movel     *Blank        #2HOAC
     C                   Movel     *Blank        #2HOPC
     C                   Movel     *Blank        #2HOMC
     C                   Movel     *Blank        #2EXCL
      *
     CSR   MEEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Display file Header Title
      *****************************************************************
     CSR   UASUBR        Begsr

      ** CASE: PAR.Display file mode is Enquiry mode
     C     P1DFMD        Ifeq      'E'
      ** Setup message data for message
     C**********         Movel     'GBA9USRMSG'  ZAMSGF                                     MD062458
     C                   Movel     'XXUSRMSG'    ZAMSGF                                     MD062458
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'A9X0012'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUDFTL        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
     C                   Else

      ** CASE: PAR.Display file mode is Maintenance mode
     C     P1DFMD        Ifeq      'M'
      ** Setup message data for message
     C**********         Movel     'GBA9USRMSG'  ZAMSGF                                     MD062458
     C                   Movel     'XXUSRMSG'    ZAMSGF                                     MD062458
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'A9X0013'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUDFTL        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
     C                   Endif
     C                   Endif
      ** Move to Header Title - Standard Functions  *
     C                   Movel     WUDFTL        ##URPT
      *
     CSR   UAEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Display file Footers
      *****************************************************************
     CSR   UBSUBR        Begsr

      ** CASE: PAR.Display file mode is Enquiry mode
     C     P1DFMD        Ifeq      'E'
      ** Setup message data for message
     C                   Movel     ZADFMF        ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'USR2911'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUSFT1        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      ** Setup message data for message
     C                   Movel     ZADFMF        ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'USR2912'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUSFT2        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
     C                   Else

      ** CASE: PAR.Display file mode is Maintenance mode
     C     P1DFMD        Ifeq      'M'
      ** Setup message data for message
     C                   Movel     ZADFMF        ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'USR2913'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUSFT1        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      ** Setup message data for message
      ** Retrieve message STD FTR:DSPFIL Maint/2
     C                   Movel     ZADFMF        ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'USR2914'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUSFT2        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
     C                   Endif
     C                   Endif
      ** Move to Double Footer - Standard Functions  *
     C                   Movel     WUSFT1        ##CTX1
     C                   Movel     WUSFT2        ##CTX2
      *
     CSR   UBEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Send message to program's message queue
      *****************************************************************
     CSR   ZASNMS        Begsr
      *
     C     ZAPGMQ        Ifeq      *Blank
     C                   Movel     ##PGM         ZAPGMQ
     C                   Endif
      ** If no message file specified, use default
     C     ZAMSGF        Ifeq      *Blank
     C                   Movel     ZADFMF        ZAMSGF
     C                   Endif
      *
     C                   Call      'Y2SNMGC'
     C                   Parm                    ZAPGMQ           10
     C                   Parm                    ZAPGRL            5
     C                   Parm                    ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C                   Parm                    ZAMSTP            7
      ** Clear all fields for default mechanism next time
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
      ** Cancel & exit program
      *****************************************************************
     CSR   ZXEXPG        Begsr

      ** USER: Exit program processing
     C                   Exsr      ZYEXPG
      *
     CSR   ZXEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Exit program: Direct
      *****************************************************************
     CSR   ZYEXPG        Begsr

      ** Exit program
     C                   RETURN
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
     C                   Movel     *Blank        W0RSL             1
     C                   Movel     *Blank        W0RSF             1
      ** Initialise indicators for re-entry
     C                   Move      '0'           *IN
      ** Update screen time
     C                   Time                    ##TME             6 0
      ** Obtain default message file
     C     *Dtaara       Define    Y2MGFLA       ZADFMF           10
     C                   In        ZADFMF
      ** Define work field Midas Run Date
     C                   Movel     *Blank        WUMRDT            7
      ** Define work field Run day number
     C                   Z-Add     *Zero         WURDNB            5 0
      ** Define work field Set Up Complete
     C                   Movel     *Blank        WUSUC             1
      ** Define work field Date format flag
     C                   Movel     *Blank        WUDFF             1
      ** Define work field Multi-branching Indicator
     C                   Movel     *Blank        WUMBIN            1
      ** Define work field Display File Title
     C                   Movel     *Blank        WUDFTL           53
      ** Define work field STD FTR 1
     C                   Movel     *Blank        WUSFT1           78
      ** Define work field STD FTR 2
     C                   Movel     *Blank        WUSFT2           78
      ** Open files first time only
     C     W0OPN         Ifeq      *Blank
     C                   Open      A9005001DF
     C                   Open      A9ACHOML0
      ** Signal that files are now Open
     C                   Move      'Y'           W0OPN             1
     C                   Endif
      *
     C                   Movel     'N'           W0PMT             1
     C                   Z-Add     13            ##SFPG            3 0
     C                   Z-Add     1             ##SFRC
      ** Maximum record number
     C                   Z-Add     *Zero         ##RRMX
      ** Scan limit
     C                   Z-Add     500           W0SLM             5 0
      ** subfile pages
     C                   Z-Add     1             W0SPG             3 0
      ** Processed subfile record
     C                   Z-Add     0             W0RR0             4 0

      ** USER: Initialize program
      ** Copyright and rundate setup
     C     *Dtaara       Define                  RUNDAT
     C                   In        RUNDAT
     C                   Move      MRDT          ##MRDT            7
     C                   Move      MRDT          WUMRDT
     C                   Move      RDNB          WURDNB
     C                   Move      SUC           WUSUC
     C                   Move      DFF           WUDFF
     C                   Move      MBIN          WUMBIN
      ** Set up Display file Header Title
     C                   Exsr      UASUBR
      ** Set up Display file Footers
     C                   Exsr      UBSUBR
     C                   Z-Add     99999         W0SLM
      ** Initialise subfile control
     C                   Exsr      MEIZ#2
      *
     CSR   ZZEXIT        Endsr
      /EJECT

      *****************************************************************
      **
      ** *PSSR  - Program exception error routine
      **          Called automatiCally if a program error occurs,
      **          or directly by the program code using Exsr.
      **          This Subroutine DUMPs the program just once.
      **
      *****************************************************************
     CSR   *PSSR         Begsr
      **  Standard Midas PSSR processing.
     C     @RUN          Ifeq      *Blank
     C                   Move      'Y'           @RUN              1
     C                   Move      'PSSR   '     P0RTN
     C                   DUMP
      **  Route job back into Midas.
     C                   Seton                                        LR
     C                   Call      'DBERRCTL'
     C                   Endif
      *
     CSR                 Endsr
      *****************************************************************
** VLD
0123456789
