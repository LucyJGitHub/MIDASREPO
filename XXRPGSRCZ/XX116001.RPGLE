     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Reserved Batch Numbers Maintenance')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  XX116001 - Midas SD Reserved Batch Numbers Maintenance       *
      *                                                               *
      *  Function:  This program allows Enquire, Amend, Insert        *
      *             and logical Delete for a Reserved Batch Numbers   *
      *                                                               *
      *  Called By: XX116000 - Reserved Batch Numbers Enquiry         *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. JMI116   *Create   Date 09Jul20               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  JMI116 - Midas SD Reserved Batch Numbers                     *
      *                                                               *
      *****************************************************************
      *
      ** Reserved Batch Numbers Maintenance
     FXX116001DFCF   E             Workstn Usropn
     F                                     Infds(Infds#)
     F                                     Infsr(*PSSR)

      ** Midas SD Reserved Batch Numbers - Retrieval
     FXXRBNOL1  IF   E           K DISK    Usropn
     F                                     Infds(Infds1)
     F                                     Infsr(*PSSR)
     F                                     Rename(XXRBNOD0:XXRBNODB)

      ** Midas SD Reserved Batch Numbers - Update
     FXXRBNOL0  UF A E           K DISK    Usropn
     F                                     Commit
     F                                     Infds(ID0001)
     F                                     Infsr(*PSSR)
     F                                     Rename(XXRBNOD0:XXRBNODA)
      *
     FXXOPINPD  IF   E             DISK    INFSR(*pssr)
      /EJECT

      *****************************************************************
      ** +-------------------------------+
      ** ¦ Data structures specification |
      ** +-------------------------------+

      * Pgm Data srtucture
     D PGMDS         ESDs                  Extname(Y2PGDSP)

      ** Display file information data structure
     D Infds#        E Ds                  Extname(Y2I#DSP)

      ** File information data structure
     D Infds1        E Ds                  Extname(Y2I1DSP)

      ** RBNO Code Details
     D @1DBRC        E Ds                  Extname(XXRBNOL0)

      ** Long DS for access programs
     D DSSDY         E Ds                  Extname(DSSDY)

      ** Externally described DS for Department Code Details
     D SDDEPT        E DS                  EXTNAME(SDDEPTPD)

      ** Stored master file format fields
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

      ** Standing data controls update
     D YBRDCS          Ds           222
     D YCRDCS          Ds           222

      ** Index for looping through the RBNO
     D WIdx1           S              2S 0

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

      ** Parameter declarations
     D P1Parm          Ds            52
     D  P1SBTN                 1      3
     D  P1EBTN                 4      6
     D  P1FOID                 7     26
     D  P1DEPT                11     30
     D  P1ENAB                31     38
     D  P1LAUS                39     48
     D  P1LCTY                49     49
     D  P1LCDT                50     52P 0

      ** MAP Action Code
     D P2Parm          Ds
     D  P2ANCD                 1      1

     D                 Ds
     D  ZAMSDA                 1    132
     D  ZA0001                 1      3
     D  ZA0002                 1      6

     D ALPHNUM         C                   CONST('0123456789-
     D                                     ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D DeptA           S              1    DIM(3)
     D FOIDA           S              1    DIM(20)

      ** Renamed input format fields
     IXXRBNODB
     I              XSBTNB                      WASBTN
     I              XEBTNB                      WAEBTN
      /EJECT

      *****************************************************************
      ** Entry parameters
      *****************************************************************
      *
     C     *Entry        Plist
     C                   Parm                    P0RTN             7
     C                   Parm                    P1Parm
     C     P2ANCD        Parm                    WP0001            1
      * Initialize
     C                   Exsr      ZZINIT
      *
      * Check passed parameters
     C                   Exsr      FACKPM
      * Perform once if all passed, Else repeat
     C     W0RPT         Doueq     'N'
      * Display and process key screen
     C                   Exsr      BADSKY
     C                   Enddo
      * Terminate program
     C*****              Close     XXRBNOL0
     C*****              Close     XXRBNOL1
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
      * Signal start of transaction
     C                   Movel     'Y'           W0TRN             1
     C     W0TRN         Doweq     'Y'
     C     W0TRN         Oreq      'K'
      * Ensure transaction continues (if reset)
     C                   Movel     'Y'           W0TRN             1
      * Conduct screen conversation
     C     W0TRN         Doweq     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         Ifeq      'Y'
     C     #1SBTN        Ifeq      *Blanks
      * One or more key fields is Blank
     C     *IN05         Oreq      '1'
      * HOME: Reset screen fields
     C                   Movel     'N'           W0BYP
     C                   Endif
     C                   Endif

      ** Bypass key screen
     C     W0BYP         Ifne      'Y'
      * Display key screen
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
      * Update screen Time
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
      * Clear messages from program message queue
     C                   Call      'Y2CLMSC'
     C                   Parm      ##PGM         ZAPGMQ           10
     C                   Parm      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   Movel     'Y'           ZAFSMS            1
      * Reset global error indicator
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
     C                   Kfld                    XSBTNB
     C                   Kfld                    XEBTNB
      * Setup key
     C                   Move      #1SBTN        XSBTNB
     C                   Move      #1EBTN        XEBTNB
     C     KRTV          Chain     XXRBNODB                           9091
     C     *IN91         Ifeq      '1'
      * Record locked
     C                   Seton                                        9931
     C                   Goto      BEEXIT
     C                   Endif

      ** If record does not exist, flip to add mode
     C     *IN90         Ifeq      '1'
     C                   Movel     'ADD'         W0PMD
      * Set up Detail Screen Header Title
     C                   Exsr      UASUBR
      * Set up Detail Screen Footer
     C                   Exsr      UBSUBR
      *
     C                   Else
      * If record does exist, flip to change mode
     C                   Movel     'CHG'         W0PMD
      * Load screen fields from DBF
     C                   Exsr      MBFL#1
      * Set up Detail Screen Header Title
     C                   Exsr      UCSUBR
      * Set up Detail Screen Footer
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
B1   C                   If        P2ANCD = 'I'
     C                   Setoff                                       993132
     C                   Move      'N'           InvSBNum          1
     C                   Move      'N'           InvEBNum          1

      ** RBNO validation

      ** Check for existing record
     C                   Move      #1SBTN        XSBTNB
     C                   Move      #1EBTN        XEBTNB
     C     KRTV          Chain     XXRBNODB                           90
B2   C                   If        *IN90 = *off
      * Duplicate RBNO Range entered
     C                   Seton                                        99
     C                   Seton                                        31
     C                   Movel     'XXX1183'     ZAMSID
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
      *
X2   C                   Else
     C                   EXSR      ValBNum
      *
B3   C                   If        InvSBNum = 'Y' or InvEBNum = 'Y'
      *
     C                   If        InvSBNum = 'Y'
     C                   Seton                                        99
     C                   Seton                                        31
     C                   Movel     'XXX1187'     ZAMSID
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   EndIf
     C                   If        InvEBNum = 'Y'
     C                   Seton                                        99
     C                   Seton                                        32
     C                   Movel     'XXX1187'     ZAMSID
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   EndIf
      *
X3   C                   Else
      * Check that End Batch Number is greater than Start Batch Number
     C                   Move      #1SBTN        W_SBTN            3
     C                   Move      #1EBTN        W_EBTN            3
     C                   EXSR      ValBNumSE
     C                   If        InvEBNum = 'Y'
     C                   Seton                                        99
     C                   Seton                                        32
     C                   Movel     'XXX1188'     ZAMSID
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C
     C                   Else
      *
      * Check that the batch range doesn't overlap an already defined
      * Reserved Batch Number range
     C                   Move      'AAA'         XSBTNB
     C                   Move      *BLANKS       XEBTNB
     C     KRTV          Setll     XXRBNODB
     C                   Read      XXRBNODB
     C                   DOW       NOT %EOF(XXRBNOL1)
      *
      * For each record read:
     C                   Exsr      CompBNums
      *
      * Error if any of the following:
      * Start input is higher than start on record and lower than end on record
      * End input is higher than start on record and lower than end on record
      * Start input is lower than start on record and End input is higher than
      *  end on record
      * Start input is equal to start on record or end on record
      * End input is equal to start on record or end on record
     C                   If        (SS_ELH = 'H' and SE_ELH = 'L')
     C                             OR (ES_ELH = 'H' and EE_ELH = 'L')
     C                             OR (SS_ELH = 'L' and EE_ELH = 'H')
     C                             OR (SS_ELH = 'E' or SE_ELH = 'E' or
     C                             ES_ELH = 'E' or EE_ELH = 'E')
     C                   Seton                                        99
     C                   Seton                                        3132
     C                   Movel     'XXX1189'     ZAMSID
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Move      #1SBTN        XSBTNB
     C                   Move      #1EBTN        XEBTNB
     C                   Goto      BFEXIT
     C                   EndIf
      *
     C                   Read      XXRBNODB
     C                   EndDo
      *
      * Check that the batch range doesn't overlap the OPICS ICD batch
      * Number range defined
     C     1             SETLL     XXOPINPD
     C                   Read      XXOPINPD                               01
     C                   Move      OPLRBN        WASBTN
     C                   Move      OPURBN        WAEBTN
     C                   Exsr      CompBNums
     C                   If        (SS_ELH = 'H' and SE_ELH = 'L')
     C                             OR (ES_ELH = 'H' and EE_ELH = 'L')
     C                             OR (SS_ELH = 'L' and EE_ELH = 'H')
     C                             OR (SS_ELH = 'E' or SE_ELH = 'E' or
     C                             ES_ELH = 'E' or EE_ELH = 'E')
     C                   Seton                                        99
     C                   Seton                                        3132
     C                   Movel     'XXX1190'     ZAMSID
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Move      #1SBTN        XSBTNB
     C                   Move      #1EBTN        XEBTNB
     C                   Goto      BFEXIT
     C                   EndIf
      *
     C                   Move      #1SBTN        XSBTNB
     C                   Move      #1EBTN        XEBTNB
      *
E3   C                   Endif
      *
E3   C                   Endif
      *
E2   C                   Endif
      *
E1   C                   Endif
      *
     CSR   BFEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Display and process detail screen
      *****************************************************************
     CSR   CADSDA        Begsr

      ** Repeat until screen control flag is reset:
     C     W0TRN         DOWEQ     'Y'
      * Display detail screen
     C                   Exsr      CBEXFM
      * Process response to detail screen
      * Cancel & exit program
     C   03              Cas                     ZXEXPG
      * Redisplay previous screen
     C   12              Cas                     CCDSPV
      * HOME: Reset screen fields
     C   05              Cas                     CCDSPV
      * Process detail screen input
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

     C                   Write     #MSGCTL
     C                   Write     #CMDTXT2
     C                   Exfmt     #RCDDTL1

     C                   Enddo
      * Clear messages from program message queue
     C                   Call      'Y2CLMSC'
     C                   Parm      ##PGM         ZAPGMQ           10
     C                   Parm      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   Movel     'Y'           ZAFSMS            1
      * Reset global error indicator
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
      * Set up Key Screen Header Title
     C                   Exsr      UFSUBR
      * Set up Key Screen Footer
     C                   Exsr      UGSUBR
     C                   Else
      * Case: *Otherwise
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
      * Validate details
     C  N10              Cas                     DCVLDL
     C                   End
      * QUIT if error:
     C   99              Goto      CFEXIT
      * Redisplay if change of customer entry.
     C   98              Goto      CFEXIT
      * Defer confirm/update requested
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
     C                   Setoff                                       32
     C                   Setoff                                       424344

      ** Check if record exists - RBNO
     C     W0PMD         Ifeq      'ADD'
     C                   Exsr      SDRVGN

      ** Case: PGM.*Return code is *Record already exists
     C     W0RTN         Ifeq      'Y2U0003'
      * Send message 'RBNO Rec exists'
     C                   Movel     'XXX1183'     ZAMSID
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Seton                                        9941
     C                   Goto      DCEXIT
     C                   Endif
     C                   Endif

      ** Case: *Otherwise
      ** ADD VALIDATION **
      * Front Office ID expected to be '*ANY' or a string with last
      * position indicating wildcard ('%')
     C                   Move      *Blanks       FOIDError         1
     C                   Z-Add     1             x                 2 0
     C                   If        #1FOID <> *BLANKS
      *
      * Look up for wildcard '%'
     C                   MoveA     #1FOID        FOIDA
     C     '%'           LOOKUP    FOIDA(x)                               55

      * If no wildcard, value must be '*ANY'
     C                   If        *IN55 = *Off
     C                             and #1FOID <> '*ANY               '
     C                   Seton                                        99
     C                   Seton                                        42
     C                   Movel     'XXX1186'     ZAMSID
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Else
      *
      * If wildcard, ensure everything is blank after the wildcard
     C                   If        *IN55 = *On
     C                   Move      *BLANKS       TestSr           20
     C                   Add       1             x
     C     20            Sub       x             y                 2 0
     C                   Eval      TestSr = %SUBST(#1FOID:x:y)
     C                   If        TestSr <> *Blanks
     C                   Seton                                        99
     C                   Seton                                        42
     C                   Movel     'XXX1186'     ZAMSID
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   EndIf
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
      * Department Code expected to be '*ANY', or a 3A valid Department
      * Code or a 1A or 2A value with last position indicating
      * wildcard ('%')
     C                   Move      *Blanks       DEPTError         1
     C                   Z-Add     1             x                 2 0
B1   C                   If        %SUBST(#1DEPT:4:1) <> *BLANKS
      *
      * If position 4 is not blank, entry must be '*ANY'
B2   C                   If        #1DEPT <> '*ANY'
     C                   Move      'Y'           DEPTError
E2   C                   EndIf
      *
X1   C                   Else
      * Look up for wildcard '%'
     C                   MoveA     #1DEPT        DeptA
     C     '%'           LOOKUP    DeptA(x)                               55

      * If no wildcard found, entry must be a valid department
B2   C                   If        *IN55 = *OFF
      *
     C                   Movel     #1DEPT        PDPCD
      * Ascertain that input is a valid Department Code
     C                   CALL      'AODEPTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY'        POPTN             7
     C                   PARM                    PDPCD             3
     C     SDDEPT        PARM      SDDEPT        DSSDY
      *
B3   C     PRTCD         IfNe      *BLANKS
     C                   Move      'Y'           DEPTError
     C                   Else
     C                   If        #1DEPT = '?'
     C                   Movel     AEDPCD        #1DEPT
E3   C                   EndIf
E3   C                   EndIf
      *
X2   C                   Else
      * Wildcard found
      * If in position 1 error
     C                   If        x = 1
     C                   Move      'Y'           DEPTError
     C                   EndIf
      *
      * If in position 2, error if position 3 is not blank
     C                   If        x = 2
     C                             and %SUBST(#1DEPT:3:1) <> *Blanks
     C                   Move      'Y'           DEPTError
     C                   EndIf
      *
E2   C                   EndIf
      *
E1   C                   Endif
     C                   If        DEPTError = 'Y'
     C                   Seton                                        99
     C                   Seton                                        43
     C                   Movel     'XXX1184'     ZAMSID
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   EndIf
      *
      * ENABLED / DISABLED
     C                   If        #1ENAB <> 'ENABLED ' and
     C                             #1ENAB <> 'DISABLED'
     C                   Seton                                        99
     C                   Seton                                        44
     C                   Movel     'XXX1185'     ZAMSID
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   EndIf
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
      * Otherwise Commit any DBF changes
     C                   Commit
     C                   Endif

      ** USER: Process command keys
     C     W0RTN         Ifeq      *Blank
     C     W0PMD         Ifeq      'ADD'
      * Exit after successful add
     C                   Movel     'N'           W0RPT
     C                   Endif
      * Restart program for next record
     C                   Movel     'N'           W0TRN
     C                   Endif
      *
     CSR   EBEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Process add request
      *****************************************************************
     CSR   ECADRQ        Begsr

      ** Create RBNO Range
     C                   Exsr      SECRRC
     C     W0RTN         Ifeq      *Blank
      * Send message '*Record added'
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

      ** Physical delete RBNO
     C                   Exsr      SGCHRC
     C     W0RTN         Ifeq      *Blank
      * Send message '*Record deleted'
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

      ** Change RBNO
     C     WP0001        Ifne      'E'
     C                   Exsr      SHCHRC
     C     W0RTN         Ifne      *Blank
      * Reset screen fields if changed record
     C     W0RTN         CaseQ     'Y2U0007'     MBFL#1
     C                   End
     C                   Else
      * Send message '*Record changed'
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
      * Is full key present?
     C     P1SBTN        Ifeq      *Blanks
      * Not every key field passed - loop program
     C                   Movel     'Y'           W0RPT             1
     C                   Else
      * Full key passed, so single shot program
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
      * Protect key fields on detail screen
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
      * Enable key screen
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
     C                   Movel     *Blanks       #1FOID
     C                   Movel     *Blanks       #1DEPT
     C                   Movel     *Blanks       #1ENAB
     C                   Setoff                                       314142
     C                   Setoff                                       32
     C                   Setoff                                       4344
     C                   Endif
      *
     CSR   MAEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Move XXRBNOPD fields to screen
      *****************************************************************
     CSR   MBFL#1        Begsr
      *
     C                   Move      WASBTN        #1SBTN
     C                   Move      WAEBTN        #1EBTN
     C                   Movel     XFOID         #1FOID
     C                   Movel     XDEPT         #1DEPT
     C                   Movel     XENABL        #1ENAB
      * Hold existing record image
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
     C                   Movel     P1SBTN        #1SBTN
     C                   Movel     P1EBTN        #1EBTN
     C                   Movel     P1FOID        #1FOID
     C                   Movel     P1DEPT        #1DEPT
     C                   Movel     P1ENAB        #1ENAB
      * Set up Key Screen Header Title
     C                   Exsr      UHSUBR
      * Set up Key Screen Footer
     C                   Exsr      UISUBR
      *
     CSR   MDEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Check if record exists - RBNO
      *****************************************************************
     CSR   SDRVGN        Begsr
      *
     C                   Movel     *Blank        W0RTN             7
      * Declare restrictor key work fields
     C     *Like         Define    WASBTN        WQSD01
     C     *Like         Define    WAEBTN        WQSD02
      * Define keylist
     C     KRSSD         Klist
     C                   Kfld                    WQSD01
     C                   Kfld                    WQSD02
      * Move fields to key list
     C                   Move      #1SBTN        WQSD01
     C                   Move      #1EBTN        WQSD02
     C     KRSSD         Setll     XXRBNODB
     C     KRSSD         Reade     XXRBNODB                               90
     C     *IN90         Ifeq      '1'
     C                   Movel     'XXH0017'     W0RTN             7
      * USER: Processing if Data record not found
     C                   Movel     'Y2U0005'     W0RTN
     C                   Goto      SDEXIT
     C                   Endif
      *
     C     *IN90         Doweq     '0'
     C                   Movel     'Y2U0003'     W0RTN
     C     KRSSD         Reade     XXRBNODB                               90
     C                   Enddo
      *
     CSR   SDEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Create RBNO  Range
      *****************************************************************
     CSR   SECRRC        Begsr
      *
     C                   Movel     *Blank        W0RTN             7
      * Move all fields to XXRBNOPD
     C                   Move      #1SBTN        XSBTNB
     C                   Move      #1EBTN        XEBTNB
     C                   Movel     #1FOID        XFOID
     C                   Movel     #1DEPT        XDEPT
     C                   Movel     #1ENAB        XENABL
     C                   Movel     ##USR         XLAUS
     C                   Move      'I'           XLCTY
     C                   Z-Add     WURDNB        XLCDT
      *
     C     KLCRSE        Klist
     C                   Kfld                    XSBTNB
     C                   Kfld                    XEBTNB
      * Check for duplicate primary key
     C     KLCRSE        Setll     XXRBNODA                               90
     C     *IN90         Ifeq      '1'
     C                   Movel     'XXX1183'     W0RTN             7
      * Send message 'RBNO Range exist'
     C                   Movel     'XXX1183'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Goto      SEEXIT
     C                   Endif
      *
     C                   Write     XXRBNODA                             91
      *
     C     *IN91         Ifeq      '1'
      * Write error detected
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Else
      * USER: Processing after Data update
     C                   Z-Add     1             WUNORC
     C                   Z-Add     1             WUNOIN
     C                   Z-Add     *Zero         WUNOAM
     C                   Z-Add     *Zero         WUNODL
     C                   Endif
      *
     CSR   SEEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Physical delete of RBNO
      *****************************************************************
     CSR   SGCHRC        Begsr
     C                   Movel     *Blank        W0RTN             7
      * Case: PAR.Action Code is Delete
     C     P2ANCD        Ifeq      'D'
     C                   Move      #1SBTN        XSBTNB
     C                   Move      #1EBTN        XEBTNB
      *
     C     KLDLTR        Klist
     C                   Kfld                    XSBTNB
     C                   Kfld                    XEBTNB
     C     KLDLTR        Chain     XXRBNODA                           9091
      *
     C     *IN90         Ifeq      '1'
      * Record not found
     C                   Movel     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   Movel     'Y2U0009'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Goto      SGEXIT
     C                   Endif
      * Record locked
     C     *IN91         Ifeq      '1'
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Goto      SGEXIT
     C                   Endif
      *
     C     *IN91         Ifeq      '0'
     C     *IN90         Andeq     '0'
     C                   Delete    XXRBNODA
     C                   Goto      SGEXIT
     C                   Endif
      *
     C                   Else
      * Send message 'Function key not allowed'
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
      * Move key fields to XXRBNOPD
     C                   Move      #1SBTN        XSBTNB
     C                   Move      #1EBTN        XEBTNB
      *
     C     KLCHSG        Klist
     C                   Kfld                    XSBTNB
     C                   Kfld                    XEBTNB
     C     KLCHSG        Chain     XXRBNODA                           9091
     C     *IN90         Ifeq      '1'
      * Record not found
     C                   Movel     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   Movel     'Y2U0009'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Goto      SGEXIT
     C                   Endif
      * Record locked
     C     *IN91         Ifeq      '1'
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Goto      SGEXIT
     C                   End
      *
      * Check for changed record
     C     #1DBRC        Ifne      @1DBRC
     C                   Movel     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   Movel     'Y2U0007'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
      * Release record lock
     C                   Unlock    XXRBNOL0                             91
     C                   Goto      SGEXIT
     C                   Endif
      * Store record data for null update check
     C                   Move      @1DBRC        YBRDCS
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        Ifne      YBRDCS
     C                   Move      'Y'           YBRDC
     C                   Endif
      * If changed update record otherwise release record
     C     YBRDC         Ifeq      'Y'
     C                   Update    XXRBNODA                             91
     C                   Else
      * Release record lock
     C                   Unlock    XXRBNOL0                             91
     C                   End
      * Change error detected
     C     *IN91         Ifeq      '1'
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Else
      * Update saved record image
     C                   Move      *Blanks       #1DBRC
     C                   Movel     @1DBRC        #1DBRC
      * DBF change successful
     C                   Endif
      *
     CSR   SGEXIT        Endsr
      /EJECT

      *****************************************************************
      * Change RBNO
      *****************************************************************
     CSR   SHCHRC        Begsr
      *
     C                   Movel     *Blank        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   Move      'N'           YCRDC             1
      * Move key fields to XXRBNOPD
     C                   Move      #1SBTN        XSBTNB
     C                   Move      #1EBTN        XEBTNB
      *
     C     KLCHSH        Klist
     C                   Kfld                    XSBTNB
     C                   Kfld                    XEBTNB
     C     KLCHSH        Chain     XXRBNODA                           9091
     C     *IN90         Ifeq      '1'
      * Record not found
     C                   Movel     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   Movel     'Y2U0009'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Goto      SHEXIT
     C                   Endif
      * Record locked
     C     *IN91         Ifeq      '1'
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Goto      SHEXIT
     C                   Endif

      ** Check for changed record
     C     #1DBRC        Ifne      @1DBRC
     C                   Movel     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   Movel     'Y2U0007'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
      * Release record lock
     C                   Unlock    XXRBNOL0                             91
     C                   Goto      SHEXIT
     C                   Endif
      * Store record data for null update check
     C                   Move      @1DBRC        YCRDCS
      * Move non-key fields to XXRBNOPD
     C                   Movel     #1FOID        XFOID
     C                   Movel     #1DEPT        XDEPT
     C                   Movel     #1ENAB        XENABL
     C                   Movel     ##USR         XLAUS
     C                   Move      'A'           XLCTY
     C                   Z-Add     WURDNB        XLCDT
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        Ifne      YCRDCS
     C                   Move      'Y'           YCRDC
     C                   Endif
      * If changed update record otherwise release record
     C     YCRDC         Ifeq      'Y'
     C                   Update    XXRBNODA                             91
     C                   Else
      * Release record lock
     C                   Unlock    XXRBNOL0                             91
     C                   End
     C     *IN91         Ifeq      '1'
      * Change error detected
     C                   Movel     'Y2U0004'     W0RTN             7
     C                   Else
      *
      * Update saved record image
     C                   Move      *Blanks       #1DBRC
     C                   Movel     @1DBRC        #1DBRC
      * DBF change successful
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
      * Setup message data for message
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
      * Move to Header Title - Standard Functions  *
     C                   Movel     WUDFTL        ##URPT
      *
     CSR   UAEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Detail Screen Footer
      *****************************************************************
     CSR   UBSUBR        Begsr
      * Setup message data for message
     C                   Movel     ZADFMF        ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'USR2919'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUSFT1        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      * Move to Single Footer - Standard Functions  *
     C                   Movel     WUSFT1        ##CTX1
      *
     CSR   UBEXIT        Endsr
      /EJECT

      *****************************************************************
      * Set up Detail Screen Header Title
      *****************************************************************
     CSR   UCSUBR        Begsr
      * Setup message data for message
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
      * Move to Header Title - Standard Functions  *
     C                   Movel     WUDFTL        ##URPT
      *
     CSR   UCEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Detail Screen Footer
      *****************************************************************
     CSR   UDSUBR        Begsr
      * Amend or Enquiry mode
     C     P2ANCD        Ifeq      'E'
     C     P2ANCD        OREQ      'A'
      * Setup message data for message
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
      * Delete mode
     C     P2ANCD        Ifeq      'D'
      * Setup message data for message
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
      * Move to Single Footer - Standard Functions  *
     C                   Movel     WUSFT1        ##CTX1
      *
     CSR   UDEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Key Screen Header Title
      *****************************************************************
     CSR   UFSUBR        Begsr
      * Setup message data for message
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'XXX1182'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUDFTL        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      * Move to Header Title - Standard Functions  *
     C                   Movel     WUDFTL        ##URPT
      *
     CSR   UFEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Key Screen Footer
      *****************************************************************
     CSR   UGSUBR        Begsr
      * Setup message data for message
     C                   Movel     ZADFMF        ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'USR2918'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUSFT1        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      * Move to Single Footer - Standard Functions  *
     C                   Movel     WUSFT1        ##CTX1
      *
     CSR   UGEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Key Screen Header Title
      *****************************************************************
     CSR   UHSUBR        Begsr
      * Setup message data for message
     C                   Movel     'XXUSRMSG'    ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'XXX1182'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUDFTL        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      * Move to Header Title - Standard Functions  *
     C                   Movel     WUDFTL        ##URPT
      *
     CSR   UHEXIT        Endsr
      /EJECT

      *****************************************************************
      ** Set up Key Screen Footer
      *****************************************************************
     CSR   UISUBR        Begsr
      * Setup message data for message
     C                   Movel     ZADFMF        ZAMSGF
     C                   Call      'Y2RVMGC'                            90
     C                   Parm      *Blank        W0RTN             7
     C                   Parm      'USR2918'     ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C     WUSFT1        Parm                    W0MTX           132
     C                   Movel     *Blank        ZAMSDA
     C                   Movel     *Blank        ZAMSGF
      * Move to Single Footer - Standard Functions  *
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
      * If no message file specified, use default
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
      * Clear all fields for default mechanism next Time
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
      * USER: Exit program processing
      * Case: KEY.*CMD key is *Exit
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
      ** Exit program: Direct
      *****************************************************************
     CSR   ZYEXPG        Begsr
      * ROLLBACK any uncommitted DBF changes
     C                   Rolbk                                          90
      *
      * Exit program
     C                   Return
      *
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
      * Initialise indicators for re-Entry
     C                   Move      '0'           *IN
      * Update screen Time
     C                   Time                    ##TME             6 0
      * Define work field Display File Title
     C                   Movel     *Blank        WUDFTL           53
      * Obtain default message file
     C     *Dtaara       Define    Y2MGFLA       ZADFMF           10
     C                   In        ZADFMF
      * Define work field STD FTR 1
     C                   Movel     *Blank        WUSFT1           78
      * Define work field Midas Run Date
     C                   Movel     *Blank        WUMRDT            7
      * Define work field Run day number
     C                   Z-Add     *Zero         WURDNB            5 0
      * Define work field No. of Records
     C                   Z-Add     *Zero         WUNORC            5 0
      * Define work field No. of Inserts
     C                   Z-Add     *Zero         WUNOIN            5 0
      * Define work field No. of Amends
     C                   Z-Add     *Zero         WUNOAM            5 0
      * Define work field No. of Deletes
     C                   Z-Add     *Zero         WUNODL            5 0
      * Define work field Output field indicator
     C                   Movel     *Blank        WUOFIN            1
      * Define work field Set Up Complete
     C                   Movel     *Blank        WUSUC             1
      * Define work field Date format flag
     C                   Movel     *Blank        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   Movel     *Blank        WUMBIN            1
      * Define work field Customer
     C                   Movel     *Blank        #WCUST            6

      ** Open files first Time only
     C     W0OPN         Ifeq      *Blank
      * Begin Commit control
     C                   Call      'Y2BGCMC'
     C                   Parm                    W0RTN             7
     C     W0RTN         Ifne      *Blank
     C     W0RTN         Andne     'CPF8351'
     C                   Exsr      ZYEXPG
     C                   Endif
      *
     C                   Open      XX116001DF
     C                   Open      XXRBNOL0
     C                   Open      XXRBNOL1
      * Signal that files are now Open
     C                   Move      'Y'           W0OPN             1
     C                   Endif
      *
     C                   Movel     'N'           W0PMT             1

      ** Select initial mode
     C     @1NROP        Ifeq      *Zero
      * Add mode
     C                   Movel     'ADD'         W0PMD             3
     C                   Else
      * Change mode
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
      *                                                               *
      * ValBNum - Validates the Start and End Batch Number            *
      *                                                               *
      *****************************************************************
     C     ValBNum       Begsr
      *
      * Check that Start and End Batch Numbers are valid
B1   C                   If        #1SBTN = '000'
     C                   Move      'Y'           InvSBNum
E1   C                   EndIf
      *
B1   C                   If        InvSBNum <> 'Y'
     C                   Z-Add     1             x
     C                   DoW       (InvSBNum <> 'Y') and (x < 4)
      *
     C     1             Subst     #1SBTN:x      #CH               1
     C     #CH           Scan      ALPHNUM:1                              55
B2   C                   If        *IN55 = *Off
     C                   Move      'Y'           InvSBNum
E2   C                   EndIf
     C                   Add       1             x
     C                   EndDo
E1   C                   EndIf
      *
B2   C                   If        #1EBTN = '000'
     C                   Move      'Y'           InvEBNum
E2   C                   EndIf
      *
B2   C                   If        InvEBNum <> 'Y'
     C                   Z-Add     1             x
     C                   DoW       (InvEBNum <> 'Y') and (x < 4)
      *
     C     1             Subst     #1EBTN:x      #CH               1
     C     #CH           Scan      ALPHNUM:1                              55
B2   C                   If        *IN55 = *Off
     C                   Move      'Y'           InvEBNum
E2   C                   EndIf
     C                   Add       1             x
     C                   EndDo
E1   C                   EndIf
      *
     C                   EndSr
      *
      *****************************************************************
      *                                                               *
      * CompBNums - Compares the Batch Numbers input as the range     *
      *             against existing defined ranges                   *
      *                                                               *
      *****************************************************************
     C     CompBNums     Begsr
      *
      * Find out if Start Batch Number is less than, equal to or greater than an
      * existing record Start Batch Number
     C                   Move      #1SBTN        W_SBTN            3
     C                   Move      WASBTN        W_EBTN            3
     C                   Move      *Blanks       W_ELH             1
     C                   EXSR      ValBNumSE
     C                   Move      W_ELH         SS_ELH            1
      *
      * Find out if Start Batch Number is less than, equal to or greater than an
      * existing record End Batch Number
     C                   Move      #1SBTN        W_SBTN
     C                   Move      WAEBTN        W_EBTN
     C                   Move      *Blanks       W_ELH
     C                   EXSR      ValBNumSE
     C                   Move      W_ELH         SE_ELH            1
      *
      * Find out if End Batch Number is less than, equal to or greater than an
      * existing record Start Batch Number
     C                   Move      #1EBTN        W_SBTN
     C                   Move      WASBTN        W_EBTN
     C                   Move      *Blanks       W_ELH
     C                   EXSR      ValBNumSE
     C                   Move      W_ELH         ES_ELH            1
      *
      * Find out if End Batch Number is less than, equal to or greater than an
      * existing record End Batch Number
     C                   Move      #1EBTN        W_SBTN
     C                   Move      WAEBTN        W_EBTN
     C                   Move      *Blanks       W_ELH
     C                   EXSR      ValBNumSE
     C                   Move      W_ELH         EE_ELH            1
      *
     C                   EndSr
      *****************************************************************
      *                                                               *
      * ValBNumSE - Receives 2 batch numbers and checks which is      *
      *             higher, lower of equal                            *
      *             This is called to validate that End Batch No      *
      *             input is higher than the Start Batch No input     *
      *             and also to compare the input Batch Nos against   *
      *             the Batch numbers off existing records on         *
      *             XXRBNOPD                                          *
      *                                                               *
      *****************************************************************
     C     ValBNumSE     Begsr
      *
     C                   Move      'N'           InvEBNum
     C                   Z-Add     1             x
     C                   Z-Add     1             yS                2 0
     C                   Z-Add     1             yE                2 0
     C     1             Subst     W_SBTN:x      #CHS              1
     C     #CHS          Scan      ALPHNUM:1     yS                       55

     C     1             Subst     W_EBTN:x      #CHE              1
     C     #CHE          Scan      ALPHNUM:1     yE                       55

      * Checking the valid batch characters, if Position 1 of the End
      * batch number is before the Position 1 of the Start Batch Number
      * then error.
      * If Position 1 of the End batch number is after the Position 1
      * of the Start batch number then OK
      * If equal, then check position 2
     C                   If        yE < yS
     C                   Move      'Y'           InvEBNum
     C                   Move      'H'           W_ELH
     C                   Goto      ValBNumSEE
     C                   EndIf
      *
     C                   If        yE > yS
     C                   Move      'L'           W_ELH
     C                   Goto      ValBNumSEE
     C                   EndIf
      *
     C                   Z-Add     2             x
     C                   Z-Add     1             yS
     C                   Z-Add     1             yE
     C     1             Subst     W_SBTN:x      #CHS              1
     C     #CHS          Scan      ALPHNUM:1     yS                       55

     C     1             Subst     W_EBTN:x      #CHE              1
     C     #CHE          Scan      ALPHNUM:1     yE                       55
      *
     C                   If        yE < yS
     C                   Move      'H'           W_ELH
     C                   Move      'Y'           InvEBNum
     C                   Goto      ValBNumSEE
     C                   Endif
     C                   If        yE > yS
     C                   Move      'L'           W_ELH
     C                   Goto      ValBNumSEE
     C                   EndIf
      *
     C                   Z-Add     3             x
     C                   Z-Add     1             yS
     C                   Z-Add     1             yE
     C     1             Subst     W_SBTN:x      #CHS              1
     C     #CHS          Scan      ALPHNUM:1     yS                       55

     C     1             Subst     W_EBTN:x      #CHE              1
     C     #CHE          Scan      ALPHNUM:1     yE                       55
      *
      * If checking the 3rd position of Start and End batch number, error if
      * position 3 of the End batch number is before or the same as Position 3
      * of the Start batch number
     C                   If        yE <= yS
     C                   Move      'Y'           InvEBNum
     C                   EndIf
      *
     C                   If        yE < yS
     C                   Move      'H'           W_ELH
     C                   Else
     C                   If        yE > yS
     C                   Move      'L'           W_ELH
     C                   Else
     C                   Move      'E'           W_ELH
     C                   EndIf
     C                   EndIf
      *
     C     ValBNumSEE    Tag
     C                   EndSr
      *****************************************************************
