     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL JE Extended narrative - Window ctr')          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL0123W0 - JE Posting Extended Narrative Description         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Prev Amend No. EML102  *CREATE    Date 28Nov19               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  EML102 - Upgrade of UNL007 to FB2.1 SP23                     *
      *           UNL007 - Extended Narratives                        *
      *                                                               *
      *****************************************************************
      *
      *    F U N C T I O N   O F   I N D I C A T O R S
      *
      *       01      First time through
      *
      *       03      F3 Pressed EXIT program
      *       05      F5 Pressed REDISPLAY the screen
      *       10      F10 Pressed DELETE record
      *       11      F11 Pressed RETRIEVE key
      *       12      F12 Pressed goto PREVIOUS screen
      *
      *       20      Protect fields in enquire or delete mode
      *       21      Enable  F10 key
      *       22      Enable  F11 key
      *       23      Disable F12 key
      *       24      Disable F5  key
      *       30      Redisplay the screen
      *       84      Chain to GLJENPX0 failed
      *       85      Chain to GLJENPY0 failed
      *       86      Error on write GLJENPX0
      *       87      Chain to GZBITPV0
      *
      *       99      Data base error
      *       LR      Last record
      *
      *****************************************************************
      *
      *    S U B R O U T I N E    I N D E X
      *
      * #FVALD - Validate the screen
      * #FCLRM - Routine to clear program's message queue.
      * #FUPDA - Update the extension file
      * #FDELT - Delete record
      * #FINIT - Routine to handle initial processing
      * #FRSET - Reset/Refresh the screen if F5 is pressed
      * #FEXIT - Exit from program if F3 has been pressed
      * #FPREV - Exit from program if F12 has been pressed
      * #FENDP - Exit from program
      * #FSEND - Routine to send messages to message subfile.
      *
      *****************************************************************
     FGZBITPV0  UF A E           K DISK    COMMIT
      * Journal Entry Extension
      *
     FGPZONEL2  IF   E           K DISK
      * Retrieve Zone once
      *
     FGLJENPX0  UF A E           K DISK    COMMIT
     F                                     RENAME(GLJENPD1:UPDIDX)
      * Update index
      *
     FGLJENPY0  IF   E           K DISK
     F                                     RENAME(GLJENPD2:RTVIDX)
      * Retreival index
      *
     FGL0123#0  CF   E             WORKSTN
     F                                     RENAME(GL0123F0:SCREEN)
      * Display file
     F/EJECT
     D*****************************************************************
     D* Array for copyright
     D* Array for bottom line with function keys
     D FF1             S             50    DIM(4) CTDATA PERRCD(1)
     D* Array for titles
     D FF2             S             50    DIM(4) CTDATA PERRCD(1)
     D*****************************************************************
     D/EJECT
     D*
     D A@CPY           DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D* BIS Copyright array
     D*
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBKEY1               142    144
     D  DBKEY2               145    147
     D  DBKEY3               148    152
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D*
     D** Needed to retrieve Prefix (LIBR) to handled "Zone" records
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
     D*
     D** Data structure for database error
     D*
     D PSDS           SDS
     D  UFPGMN           *PROC
     D* Get program name from PSDS
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* First DS for access programs, short data structure
     D*
     D NWRCD         E DS                  EXTNAME(GLJENPX0)
     D* Current/previous master file fields
     D*
     D SVRCD           DS           568
     D* Stored master file fields

     D DATA            DS          1024
     D  #1BTNB                 1      3
     D  #1BINB                 4      6  0
     D  #1PTDT               207    211  0
     D  #1NA02               212    246
     D  #1NA03               247    281
     D  #1NA04               282    316
     D  #1NA05               317    351
     D  #1NA06               352    386
     D  #1NA07               387    421
     D  #1NA08               422    456
     D  #1NA09               457    491
     D  #1NA10               492    526
     D  #1NA11               527    561
     D  #1NA12               562    596
     D  #1NA13               597    631
     D  #1NA14               632    666
     D  #1NA15               667    701
     D  #1NA16               702    736
     D  #1NA17               737    771
     D  #1BPHI               772    772
     D  #1OBTN               773    775
     D  #1PTAM               776    782P 0
     D  #1PNAR               783    812
     D/EJECT
     C*****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    UFPACT            1
     C                   PARM                    DATA
     C                   PARM                    UFRTNC            7
     C                   PARM                    UFWLEN            3 0
     C                   PARM                    UFWWID            3 0
     C                   PARM                    UFSROW            3 0
     C                   PARM                    UFSCOL            3 0
     C                   PARM                    UFTITL            7
     C                   PARM                    UFSPAR          256
     C                   MOVEL     UFPACT        UFACTN            1
     C*
     C*-------------------------------------------------------------------------
     C* Main processing
     C*-------------------------------------------------------------------------
     C*
     C* Define the LDA for error handling
     C     *DTAARA       DEFINE                  LDA
     C*
     C* Execute initial routine
     C                   EXSR      #FINIT
     C*
     C* Continue to redisplay the screen if indicator 30 remains off
     C     *IN30         DOWEQ     '1'
     C*
     C* CTL format for message file
     C                   WRITE     #MSGCTL
     C*
     C* Main format of the display file
     C                   EXFMT     SCREEN
     C*
     C* Clear message file
     C                   EXSR      #FCLRM
     C*
     C     *IN03         CASEQ     '1'           #FEXIT
     C     *IN05         CASEQ     '1'           #FINIT
     C     *IN10         CASEQ     '1'           #FDELT
     C     *IN11         CASEQ     '1'           #FRETR
     C     *IN12         CASEQ     '1'           #FPREV
     C                   CAS                     #FVALD
     C                   ENDCS
     C*
     C                   ENDDO
     C*
     C                   EXSR      #FENDP
      /EJECT
     C*
     C*-------------------------------------------------------------------------
     C* #FVALD - Validate the screen
     C*-------------------------------------------------------------------------
     C*
     C     #FVALD        BEGSR
     C*
     C* If the action code is Enquire then simly exit from Pgm
     C     UFACTN        IFEQ      'E'
     C                   EXSR      #FENDP
     C                   END
     C*
     C* If the action code is Delete mode enter is not allowed
     C     UFACTN        IFEQ      'D'
     C                   MOVEL     'XXC0182'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      #FSEND
     C                   GOTO      #FVEND
     C                   ENDIF
     C*
     C* Update the extension file
     C                   EXSR      #FUPDA
     C*
     C     #FVEND        ENDSR
     C/EJECT
     C*
     C*-------------------------------------------------------------------------
     C* #FCLRM - Routine to clear program's message queue.
     C*-------------------------------------------------------------------------
     C*
     C     #FCLRM        BEGSR
     C*
     C                   CALL      'Y2CLMSC'
     C                   PARM      UFPGMN        ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
     C*
     C                   ENDSR
     C/EJECT
     C*
     C*-------------------------------------------------------------------------
     C* #FUPDA - Update the extension file
     C*-------------------------------------------------------------------------
     C*
     C     #FUPDA        BEGSR
     C*
     C* If indicator 85 is on then no record currently exists
     C     *IN85         IFEQ      '1'
     C     UFACTN        IFEQ      'I'
     C*
     C* Move screen fields to file fields
     C                   MOVEL     #FNA02        FNA02
     C                   MOVEL     #FNA03        FNA03
     C                   MOVEL     #FNA04        FNA04
     C                   MOVEL     #FNA05        FNA05
     C                   MOVEL     #FNA06        FNA06
     C                   MOVEL     #FNA07        FNA07
     C                   MOVEL     #FNA08        FNA08
     C                   MOVEL     #FNA09        FNA09
     C                   MOVEL     #FNA10        FNA10
     C                   MOVEL     #FNA11        FNA11
     C                   MOVEL     #FNA12        FNA12
     C                   MOVEL     #FNA13        FNA13
     C                   MOVEL     #FNA14        FNA14
     C                   MOVEL     #FNA15        FNA15
     C                   MOVEL     #FNA16        FNA16
     C                   MOVEL     #FNA17        FNA17
     C*
     C* Write a new record
     C                   WRITE     UPDIDX                               86
     C* If error on write (other user write the record)
     C     *IN86         IFEQ      *ON
     C                   MOVEL     'XXC0184'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      #FSEND
     C                   SETON                                        20
     C                   ELSE
     C                   SETOFF                                       30
     C                   ENDIF
     C*
     C                   ELSE
     C                   MOVEL     'XXC0184'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      #FSEND
     C                   SETON                                        20
     C                   ENDIF
     C*
     C                   ELSE
     C     UFACTN        IFEQ      'A'
     C*
     C* Record currently exists so need to update
     C*
     C     UFKLIS        CHAIN     UPDIDX                             84
     C*
     C* If no record found
     C     *IN84         IFEQ      '1'
     C*
     C** DATABASE ERROR HAS OCCURRED
     C*
     C     *LOCK         IN        LDA
     C                   MOVEL     UFPGMN        DBPGM
     C                   MOVEL     UFBTNB        DBKEY1
     C                   MOVEL     UFBINB        DBKEY2
     C                   MOVEL     UFPTDT        DBKEY3                         ***************
     C                   MOVE      'GLJENPX0'    DBFILE                         * DB ERROR 001*
     C                   Z-ADD     1             DBASE                          ***************
     C                   OUT       LDA
     C                   MOVE      'USR0563'     UFRTNC
     C                   EXSR      #FENDP
     C*
     C                   ELSE
     C*
     C* If the record has been changed
     C     NWRCD         IFNE      SVRCD
     C                   MOVEL     'XXC0181'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      #FSEND
     C*
     C                   ELSE
     C*
     C* Move screen fields to file fields
     C                   MOVEL     #FNA02        FNA02
     C                   MOVEL     #FNA03        FNA03
     C                   MOVEL     #FNA04        FNA04
     C                   MOVEL     #FNA05        FNA05
     C                   MOVEL     #FNA06        FNA06
     C                   MOVEL     #FNA07        FNA07
     C                   MOVEL     #FNA08        FNA08
     C                   MOVEL     #FNA09        FNA09
     C                   MOVEL     #FNA10        FNA10
     C                   MOVEL     #FNA11        FNA11
     C                   MOVEL     #FNA12        FNA12
     C                   MOVEL     #FNA13        FNA13
     C                   MOVEL     #FNA14        FNA14
     C                   MOVEL     #FNA15        FNA15
     C                   MOVEL     #FNA16        FNA16
     C                   MOVEL     #FNA17        FNA17
     C* Update record
     C                   UPDATE    UPDIDX
     C                   SETOFF                                       30
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDIF
     C                   ENDIF
     C*
     C                   MOVE      ZOZONE        EXZONE
     C                   MOVE      UFBTNB        EXBTNB
     C                   MOVE      UFBINB        EXBINB
     C*
     C     KGZBTP        CHAIN     GZBITPV0                           87
     C*
     C                   EVAL      EXNA2   = FNA02
     C                   EVAL      EXNA3   = FNA03
     C                   EVAL      EXNA4   = FNA04
     C                   EVAL      EXNA5   = FNA05
     C                   EVAL      EXNA6   = FNA06
     C                   EVAL      EXNA7   = FNA07
     C                   EVAL      EXNA8   = FNA08
     C                   EVAL      EXNA9   = FNA09
     C                   EVAL      EXNA10  = FNA10
     C                   EVAL      EXNA11  = FNA11
     C                   EVAL      EXNA12  = FNA12
     C                   EVAL      EXNA13  = FNA13
     C                   EVAL      EXNA14  = FNA14
     C                   EVAL      EXNA15  = FNA15
     C                   EVAL      EXNA16  = FNA16
     C                   EVAL      EXNA17  = FNA17
     C*
     C     *IN87         IFEQ      *OFF
     C                   UPDATE    GZBITPEX
     C                   ELSE
     C                   WRITE     GZBITPEX
     C                   ENDIF
     C*
     C                   ENDSR
     C/EJECT
     C*
     C*-------------------------------------------------------------------------
     C* #FDELT - Delete record
     C*-------------------------------------------------------------------------
     C*
     C     #FDELT        BEGSR
     C*
     C* Delete Record
     C     UFKLIS        CHAIN     UPDIDX                             84
     C     *IN84         IFEQ      '0'
     C*
     C* If the record has been changed
     C     NWRCD         IFNE      SVRCD
     C                   MOVEL     'XXC0181'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      #FSEND
     C* Othervise delete record
     C                   ELSE
     C                   DELETE    UPDIDX
     C                   EXSR      #FENDP
     C                   ENDIF
     C* If record is alredy deleted
     C                   ELSE
     C                   EXSR      #FENDP
     C                   ENDIF
     C                   ENDSR
     C/EJECT
     C*
     C*-------------------------------------------------------------------------
     C* #FINIT - Routine to handle initial processing
     C*-------------------------------------------------------------------------
     C*
     C     #FINIT        BEGSR
     C*
     C                   Z-ADD     UFSROW        SWROW
     C                   Z-ADD     UFSCOL        SWCOL
      *
     C*   Check for SAR EML102
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'EML102'      @SARD             6
     C                   PARM                    DSFDY
     C*
     C*   If no record found
     C     @RTCD         IFNE      *BLANKS
     C*
     C*   Call end processing
     C                   EXSR      #FENDP
     C*
     C                   ENDIF
     C*
     C*  Only do first time through
     C     #FBEGI        TAG
     C     *IN01         IFEQ      '0'
     C*
     C*  Set up the correct command key and title text
     C                   SELECT
     C* Action AMEND
     C     UFACTN        WHENEQ    'A'
     C                   MOVEA     FF1(1)        SFOOT
     C                   MOVEA     FF2(1)        STITL
     C* Action DELETE
     C     UFACTN        WHENEQ    'D'
     C                   MOVEA     FF1(2)        SFOOT
     C                   MOVEA     FF2(2)        STITL
     C                   MOVE      *ON           *IN20
     C                   MOVE      *ON           *IN21
     C                   MOVE      *ON           *IN23
     C                   MOVE      *ON           *IN24
     C* Action ENQUIRY
     C     UFACTN        WHENEQ    'E'
     C                   MOVEA     FF1(4)        SFOOT
     C                   MOVEA     FF2(3)        STITL
     C                   MOVE      *ON           *IN20
     C                   MOVE      *ON           *IN24
     C* Action INPUT
     C     UFACTN        WHENEQ    'I'
     C                   MOVEA     FF2(4)        STITL
     C                   MOVEA     FF1(1)        SFOOT
     C*
     C                   ENDSL
     C*
     C* If Input or Amend mode
     C     UFACTN        IFEQ      'A'
     C     UFACTN        OREQ      'I'
     C* If recent information exist enable Retrieve
     C     #1NA02        IFNE      *BLANKS
     C     #1NA03        ORNE      *BLANKS
     C     #1NA04        ORNE      *BLANKS
     C     #1NA05        ORNE      *BLANKS
     C     #1NA06        ORNE      *BLANKS
     C     #1NA07        ORNE      *BLANKS
     C     #1NA08        ORNE      *BLANKS
     C     #1NA09        ORNE      *BLANKS
     C     #1NA10        ORNE      *BLANKS
     C     #1NA11        ORNE      *BLANKS
     C     #1NA12        ORNE      *BLANKS
     C     #1NA13        ORNE      *BLANKS
     C     #1NA14        ORNE      *BLANKS
     C     #1NA15        ORNE      *BLANKS
     C     #1NA16        ORNE      *BLANKS
     C     #1NA17        ORNE      *BLANKS
     C                   MOVEA     FF1(3)        SFOOT
     C                   SETON                                        22
     C                   ENDIF
     C                   ENDIF
     C*
     C                   SETON                                        0130
     C*
     C                   ENDIF
     C*
     C* Setup key values using transaction data passed from caller
     C     *LIKE         DEFINE    FBTNB         UFBTNB
     C     *LIKE         DEFINE    FBINB         UFBINB
     C     *LIKE         DEFINE    FPTDT         UFPTDT
     C                   MOVEL     #1BTNB        UFBTNB
     C                   Z-ADD     #1BINB        UFBINB
     C                   Z-ADD     #1PTDT        UFPTDT
     C*
     C** Retrieve Zone
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT
     C*
     C     LIBR          CHAIN     GPZONEL2                           89
     C     *IN89         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     UFPGMN        DBPGM
     C                   MOVEL     LIBR          DBKEY
     C                   MOVE      'GPZONEL2'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   MOVE      'USR0563'     UFRTNC
     C                   EXSR      #FENDP
     C                   ENDIF
     C*
     C* Set up key list for file access
     C     UFKLIS        KLIST
     C                   KFLD                    UFBTNB
     C                   KFLD                    UFBINB
     C                   KFLD                    UFPTDT
     C*
     C     KGZBTP        KLIST
     C                   KFLD                    EXZONE
     C                   KFLD                    EXBTNB
     C                   KFLD                    EXBINB
     C*
     C* Chain to extension file
     C     UFKLIS        CHAIN     RTVIDX                             85
     C*
     C* If record found
     C     *IN85         IFEQ      '0'
     C*
     C* Set file field to screen fields
     C*
     C                   MOVEL     FNA02         #FNA02
     C                   MOVEL     FNA03         #FNA03
     C                   MOVEL     FNA04         #FNA04
     C                   MOVEL     FNA05         #FNA05
     C                   MOVEL     FNA06         #FNA06
     C                   MOVEL     FNA07         #FNA07
     C                   MOVEL     FNA08         #FNA08
     C                   MOVEL     FNA09         #FNA09
     C                   MOVEL     FNA10         #FNA10
     C                   MOVEL     FNA11         #FNA11
     C                   MOVEL     FNA12         #FNA12
     C                   MOVEL     FNA13         #FNA13
     C                   MOVEL     FNA14         #FNA14
     C                   MOVEL     FNA15         #FNA15
     C                   MOVEL     FNA16         #FNA16
     C                   MOVEL     FNA17         #FNA17
     C* Save current master file fields
     C                   MOVEL     NWRCD         SVRCD
     C* If somebody input the record, after Refresh can delete
     C     UFACTN        IFEQ      'D'
     C                   MOVEA     FF1(2)        SFOOT
     C                   SETON                                        21
     C                   ENDIF
     C*
     C* If the action code is Insert and record is exist
     C     UFACTN        IFEQ      'I'
     C                   MOVEL     'XXC0186'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      #FSEND
     C                   MOVE      'E'           UFACTN
     C                   SETOFF                                       01
     C                   GOTO      #FBEGI
     C                   ENDIF
     C* If record not present setup keyed fields
     C                   ELSE
     C                   MOVEL     UFBTNB        FBTNB
     C                   Z-ADD     UFBINB        FBINB
     C                   Z-ADD     UFPTDT        FPTDT
     C*
     C* If the action code is Amend and record not exist
     C     UFACTN        IFEQ      'A'
     C                   MOVE      'I'           UFACTN
     C                   SETOFF                                       01
     C                   GOTO      #FBEGI
     C                   ENDIF
     C*
     C* If the action code is Enquiry and record not exist
     C     UFACTN        IFEQ      'E'
     C                   MOVEL     'XXC0185'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      #FSEND
     C                   ENDIF
     C*
     C* If the action code is Delete and record not exist
     C     UFACTN        IFEQ      'D'
     C                   EXSR      #FENDP
     C                   ENDIF
     C*
     C* If the action code is Insert and record not exist
     C     UFACTN        IFEQ      'I'
     C                   MOVE      *BLANKS       #FNA02
     C                   MOVE      *BLANKS       #FNA03
     C                   MOVE      *BLANKS       #FNA04
     C                   MOVE      *BLANKS       #FNA05
     C                   MOVE      *BLANKS       #FNA06
     C                   MOVE      *BLANKS       #FNA07
     C                   MOVE      *BLANKS       #FNA08
     C                   MOVE      *BLANKS       #FNA09
     C                   MOVE      *BLANKS       #FNA10
     C                   MOVE      *BLANKS       #FNA11
     C                   MOVE      *BLANKS       #FNA12
     C                   MOVE      *BLANKS       #FNA13
     C                   MOVE      *BLANKS       #FNA14
     C                   MOVE      *BLANKS       #FNA15
     C                   MOVE      *BLANKS       #FNA16
     C                   MOVE      *BLANKS       #FNA17
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C* If Amend mode
     C     UFACTN        IFEQ      'A'
     C* If record not exist protect editing fields
     C     *IN85         IFEQ      *ON
     C                   SETON                                        20
     C* If record exist enable editing fields
     C                   ELSE
     C                   SETOFF                                       20
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDSR
     C/EJECT
     C*
     C*-------------------------------------------------------------------------
     C* #FEXIT - Exit from program if F3 has been pressed
     C*-------------------------------------------------------------------------
     C*
     C     #FEXIT        BEGSR
     C*
     C                   MOVE      'Y2U9999'     UFRTNC
     C                   EXSR      #FENDP
     C*
     C                   ENDSR
     C/EJECT
     C*
     C*-------------------------------------------------------------------------
     C* #FRETR - Retrieve data from DATA stored in previous F12
     C*-------------------------------------------------------------------------
     C*
     C     #FRETR        BEGSR
     C*
     C                   MOVEL     #1NA02        #FNA02
     C                   MOVEL     #1NA03        #FNA03
     C                   MOVEL     #1NA04        #FNA04
     C                   MOVEL     #1NA05        #FNA05
     C                   MOVEL     #1NA06        #FNA06
     C                   MOVEL     #1NA07        #FNA07
     C                   MOVEL     #1NA08        #FNA08
     C                   MOVEL     #1NA09        #FNA09
     C                   MOVEL     #1NA10        #FNA10
     C                   MOVEL     #1NA11        #FNA11
     C                   MOVEL     #1NA12        #FNA12
     C                   MOVEL     #1NA13        #FNA13
     C                   MOVEL     #1NA14        #FNA14
     C                   MOVEL     #1NA15        #FNA15
     C                   MOVEL     #1NA16        #FNA16
     C                   MOVEL     #1NA17        #FNA17
     C*
     C                   ENDSR
     C/EJECT
     C*
     C*-------------------------------------------------------------------------
     C* #FPREV - Exit from program if F12 has been pressed
     C*-------------------------------------------------------------------------
     C*
     C     #FPREV        BEGSR
     C*
     C* If Input or Amend mode store data to DATA
     C     UFACTN        IFEQ      'I'
     C     UFACTN        OREQ      'A'
     C                   MOVEL     #FNA02        #1NA02
     C                   MOVEL     #FNA03        #1NA03
     C                   MOVEL     #FNA04        #1NA04
     C                   MOVEL     #FNA05        #1NA05
     C                   MOVEL     #FNA06        #1NA06
     C                   MOVEL     #FNA07        #1NA07
     C                   MOVEL     #FNA08        #1NA08
     C                   MOVEL     #FNA09        #1NA09
     C                   MOVEL     #FNA10        #1NA10
     C                   MOVEL     #FNA11        #1NA11
     C                   MOVEL     #FNA12        #1NA12
     C                   MOVEL     #FNA13        #1NA13
     C                   MOVEL     #FNA14        #1NA14
     C                   MOVEL     #FNA15        #1NA15
     C                   MOVEL     #FNA16        #1NA16
     C                   MOVEL     #FNA17        #1NA17
     C                   ENDIF
     C*
     C                   MOVE      'USR0790'     UFRTNC
     C                   EXSR      #FENDP
     C*
     C                   ENDSR
     C/EJECT
     C*
     C*-------------------------------------------------------------------------
     C* #FENDP - Exit from program
     C*-------------------------------------------------------------------------
     C*
     C     #FENDP        BEGSR
     C*
     C                   SETON                                        LR
     C                   RETURN
     C*
     C                   ENDSR
     C/EJECT
     C*
     C*-------------------------------------------------------------------------
     C* #FSEND - Routine to send messages to message subfile.
     C*-------------------------------------------------------------------------
     C*
     C     #FSEND        BEGSR
     C*
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     UFPGMN        ZAPGM
     C                   ENDIF
     C*
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message File
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
     C*
     C                   ENDSR
      /EJECT
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2008
**CTDATA FF1
F3=Main Menu  F5=Refresh  F12=Previous
F3=Main Menu  F10=Delete
F3=Main Menu  F5=Refresh F11=Retrieve F12=Previous
F3=Main Menu  F12=Previous
**CTDATA FF2
  Extended Posting Narrative Description - Amend
 Extended Posting Narrative Description - Delete
 Extended Posting Narrative Description - Enquiry
 Extended Posting Narrative Description - Insert
