     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Adjustment to Amortisation Input')            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE002250 - Adjustment to Amortisation Input                  *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CAS019             Date 24Mar07               *
      *                 CAS016             Date 28Feb06               *
      *                 232845             Date 03Jun05               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CAS019 - Upgrade of CAS016 to Midas Plus (Recompile)         *
      *  CAS016 - IAS18 EIR Recalculation (Fee Amortisation Over      *
      *           Whole Period) -Recompile.                           *
      *  232845 - Upgrade of Nordea Enhancements to Release 4.04      *
      *           Changed Message IDs LEL0567, LEL0568, LEL0569 and   *
      *           LEL0570 to LEL0580, LEL0703, LEL0704 & LEL0705      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
     FCLOAN     UF A E           K DISK
      ** Loan Details File
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     F                                     INFSR(*PSSR)
     F                                     COMMIT

     FLEEIRDL0  UF A E           K DISK    INFSR(*PSSR)
      ** Midas LE Effective Interest Rate Details
     F                                     COMMIT

     FLE002250DFCF   E             WORKSTN
      ** Midas LE Adjustment to Amortisation Input Screen

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** Ê Named constants                      Ê
      ** Ê ===============                      Ê
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** Ê Arrays and Data Structures           Ê
      ** Ê ==========================           Ê
      ** +--------------------------------------+
     D LEARR@          S              2  0 DIM(9) CTDATA PERRCD(9)

      ** Layout for the RUNDAT data area
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)

      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** +--------------------------------------+
      ** Ê Declared variables                   Ê
      ** Ê ==================                   Ê
      ** +--------------------------------------+

      ** Parameters for access objects

     D PRTCD           S              7
     D POPTN           S              7
     D PCUST1          S             10
     D PKYST           S              7
     D PCURR           S              7
     D PCCY            S              3
     D PZOBRX          S              3

      ** Parameters for ZALIGN

     D ZALIGNOK        S              1
     D ZFIELD          S             16
     D ZECODE          S              1
     D ZADEC           S              1  0
     D ZADIG           S              2  0

      ** Parameters for ZVACTBU

     D PACTN           S              1    INZ('A')
     D PBRCH           S              3
     D PERROR          S              1P 0

     D PMSGFILE        S             10    INZ('LERMSGF')
     D PMSGID          S             10
     D WADJNUM         S             14  0
     D*WLNRF****       S              6  0                                                    CLE148
     D WLNRF           S              6                                                       CLE148
     D WRCDT           S              1    INZ('A')
     D WCCYERR         S              1
     D WCNUM           S              6
     D WERROR          S              1

      ** +--------------------------------------+
      ** Ê End of D-specs                       Ê
      ** Ê ==============                       Ê
      ** +--------------------------------------+

      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *                M A I N  P R O C E S S I N G                  *
      *                                                              *
      ****************************************************************

      ** Continue to redisplay the screen until no error is detected

     C                   DOU       *IN03 = *ON

      ** Write Message Control

     C                   WRITE     LE002250F2

      ** Write Main Format of the display file

     C                   EXFMT     LE002250F0

     C                   EXSR      SRRESET
     C                   SELECT
     C                   WHEN      *IN05 = *ON
     C                   EXSR      SRCLEAR
     C                   WHEN      *IN03 <> *ON
     C                   EXSR      SRVALID

      ** Check if there is any error of the fields
      ** Update Loan Detail File if no error in validation of fields

     C                   IF        WERROR = 'N'
     C                   EXSR      SRUPDATE
     C                   ENDIF
     C                   ENDSL

     C                   ENDDO

      **   Exit from program

     C                   EXSR      SREXIT
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRESET - Reset error indicators and clear program msg file   *
      *                                                               *
      *****************************************************************

     C     SRRESET       BEGSR

     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      *IN28 = *OFF
     C                   EVAL      *IN29 = *OFF
     C                   EVAL      WERROR = 'N'

      ** Clear program message file

     C                   CALL      'ZA0250'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLEAR - Clear Display fields                                *
      *                                                               *
      *****************************************************************
     C     SRCLEAR       BEGSR

     C                   EVAL      #1LNUM = *BLANKS
     C                   EVAL      #1CNUM = *BLANKS
     C                   EVAL      #1AJD = *BLANKS
     C                   EVAL      #1SIGN = *BLANKS
     C                   EVAL      #1CCY = *BLANKS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALID - Validation of Entry Data                            *
      *                                                               *
      *****************************************************************

     C     SRVALID       BEGSR

      ** Validate Loan Number Field

     C                   MOVE      #1LNUM        WLNRF

     C     WWLOAN        CHAIN     CLOAN
     C                   IF        %FOUND(CLOAN) AND
     C                             RECI = 'D'
      ** If Loan exists in the loan details file and live
      ** Validate if it is a current Loan

     C                   IF        BJRDNB <= VDAT OR
     C                             BJRDNB > MDAT AND
     C                             MDAT <> 0
     C                   EVAL      *IN25 = *ON
     C**********         EVAL      PMSGID = 'LEL0568'                                         232845
     C                   EVAL      PMSGID = 'LEL0580'                                         232845
     C                   EXSR      SRSNDMSG

     C                   ELSE
      ** Validate if Processing Type is allowed for adjustment
     C     PTYP          LOOKUP    LEARR@                                 85

     C                   IF        *IN85 = *OFF
     C                   EVAL      *IN25 = *ON
     C                   EVAL      PMSGID = 'LEL0572'
     C                   EXSR      SRSNDMSG
     C                   ENDIF
     C
     C                   ENDIF

      ** Validate authority for branch and action code

     C                   IF        AGMBIN = 'Y' AND *IN25 = *OFF

      ** Multi-branching

     C                   CALL      'ZVACTBU'
     C                   PARM                    PACTN
     C                   PARM      BRCA          PBRCH
     C                   PARM                    PERROR

     C                   IF        PERROR <> 0

     C                   IF        PERROR = 1
     C                   EVAL      PMSGID = 'LEL0303'
     C                   ELSE
     C                   EVAL      PMSGID = 'LEL0302'
     C                   ENDIF

     C                   EVAL      *IN25 = *ON
     C                   EXSR      SRSNDMSG
     C                   ENDIF

     C                   ELSE

      ** Not Multi-branching

     C                   IF        *IN25 = *OFF
     C                   CALL      'ZVACTU'
     C                   PARM                    PACTN
     C                   PARM                    PERROR

     C                   IF        PERROR <> 0
     C                   EVAL      *IN25 = *ON
     C                   EVAL      PMSGID = 'LEL0302'
     C                   EXSR      SRSNDMSG
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      ** Check the authority on originating branch

     C                   IF        BKOBRU = 'Y' AND
     C                             BKOBUV = 'Y' AND
     C                             AGMBIN = 'Y' AND
     C                             *IN25 = *OFF
     C                   CALL      'ZVOBU'
     C                   PARM      ORBR          PZOBRX
     C                   PARM                    PERROR

      ** Error "User not authorised to any originating branches"

     C                   IF        PERROR <> 0
     C                   IF        PERROR = 1
     C                   EVAL      *IN25 = *ON
     C                   EVAL      PMSGID = 'LEL0305'
     C                   ELSE

      ** Error "User not authorised to originating branch of facility"

     C                   EVAL      *IN25 = *ON
     C                   EVAL      PMSGID = 'LEL0306'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ELSE

      ** If loan is not found, error not a valid entry on the Loans file

     C                   EVAL      *IN25 = *ON
     C*********          EVAL      PMSGID = 'LEL0567'                                         232845
     C                   EVAL      PMSGID = 'LEL0703'                                         232845
     C                   EXSR      SRSNDMSG
     C                   ENDIF

      ** Validate Customer Field

     C                   IF        #1CNUM <> *BLANKS
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1CNUM        PCUST1
     C                   PARM      '       '     PKYST
     C     SDCUST        PARM      SDCUST        DSSDY

      *  Error if not on file

     C                   IF        PRTCD <> *BLANKS
     C                   IF        PRTCD = '*NRF   ' OR
     C                             PRTCD = '*KEY   '

      ** If Customer not found, error Customer number or shortname entered
      ** does not match a record on the customer file

     C                   EVAL      *IN26 = *ON
     C                   EVAL      PMSGID = 'LEA0034'
     C                   EXSR      SRSNDMSG
     C                   ELSE
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = #1CNUM
     C                   EVAL      DBPGM = 'LE002250'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ELSE

      ** If Customer is found, it must be the same as the loan customer name

     C                   EVAL      #1CNUM = *BLANKS
     C                   MOVE      BBCUST        #1CNUM
     C                   MOVE      CNUM          WCNUM
     C                   IF        WCNUM <> BBCUST AND *IN25 = *OFF
     C                   EVAL      *IN26 = *ON
     C**********         EVAL      PMSGID = 'LEL0569'                                         232845
     C                   EVAL      PMSGID = 'LEL0704'                                         232845
     C                   EXSR      SRSNDMSG
     C                   ENDIF

     C                   ENDIF

     C                   ELSE
     C                   EVAL      *IN26 = *ON
     C                   EVAL      PMSGID = 'LEM0178'
     C                   EXSR      SRSNDMSG
     C                   ENDIF

      ** Access Currency file to get number of decimal place

     C                   IF        #1CCY <> *BLANKS
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1CCY         PCCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   EVAL      WCCYERR = 'N'
     C                   IF        PRTCD <> *BLANKS
     C                   IF        PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAl      DBASE = 3
     C                   EVAL      DBKEY = #1CCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBPGM = 'LE002250'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WCCYERR = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      #1CCY = A6CYCD
     C                   ENDIF
     C                   ENDIF

      ** Validate Adjustment Amount Field

     C                   IF        #1AJD <> *BLANKS
     C                   MOVE      #1AJD         ZFIELD
     C                   EVAL      ZADIG = 14 - A6NBDP

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
     C                   PARM                    ZADIG

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
      ** Error "The entry is not a valid amount"

     C                   IF        ZALIGNOK = 'N'
     C                   EVAL      *IN27 = *ON
     C                   EVAL      PMSGID = 'LEA0192'
     C                   EXSR      SRSNDMSG
     C                   ELSE
     C                   MOVE      ZFIELD        #1AJD
     C                   ENDIF

     C                   ELSE

      ** Error "Adjustment Amount must be entered"

     C                   EVAL      *IN27 = *ON
     C                   EVAL      PMSGID = 'LEA0192'
     C                   EXSR      SRSNDMSG
     C                   ENDIF

      ** Validate Sign Field

     C                   IF        #1SIGN = *BLANKS

      ** Error "Sign must be entered"

     C                   EVAL      *IN28 = *ON
     C**********         EVAL      PMSGID = 'LEL0570'                                         232845
     C                   EVAL      PMSGID = 'LEL0705'                                         232845
     C                   EXSR      SRSNDMSG
     C                   ELSE

      ** Error "The entry is not '+' or '-'"

     C                   IF        #1SIGN <> '+' AND
     C                             #1SIGN <> '-'
     C                   EVAL      *IN28 = *ON
     C                   EVAL      PMSGID = 'LEL0571'
     C                   EXSR      SRSNDMSG
     C                   ENDIF
     C                   ENDIF

      ** Validate Currency field

     C                   IF        #1CCY = *BLANKS

      ** Error "Currency must be entered"

     C                   EVAL      *IN29 = *ON
     C                   EVAL      PMSGID = 'LEL0066'
     C                   EXSR      SRSNDMSG
     C                   ELSE

      ** Error "The entry is not a valid currency"

     C                   IF        WCCYERR = 'Y'
     C                   EVAL      *IN29 = *ON
     C                   EVAL      PMSGID = 'LEL0066'
     C                   EXSR      SRSNDMSG
     C                   ELSE

      ** Error "The entry does not match the drawn currency of the related loan"

     C                   IF        #1CCY <> CCY AND
     C                             *IN25 = *OFF
     C                   EVAL      *IN29 = *ON
     C                   EVAL      PMSGID = 'LEA0189'
     C                   EXSR      SRSNDMSG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPDATE - Update files                                       *
      *                                                               *
      *****************************************************************
     C     SRUPDATE      BEGSR

     C                   MOVE      ZFIELD        WADJNUM
     C                   IF        #1SIGN = '+'
     C                   EVAL      ANADJ = ANADJ + WADJNUM
     C                   ELSE
     C                   EVAL      ANADJ = ANADJ - WADJNUM
     C                   ENDIF

     C                   UPDATE    CLOANCLF
     C                   EXSR      SRCLEAR

     C     LNRF          CHAIN     LEEIRDL0
     C                   IF        %FOUND(LEEIRDL0)
     C                   EVAL      EIRCAL = 'Y'
     C                   UPDATE    LEEIRDD0
     C                   ENDIF

     C                   COMMIT

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSNDMSG - Send Error Message                                 *
      *                                                               *
      *****************************************************************
     C     SRSNDMSG      BEGSR

     C                   CALL      'ZA0340'
     C                   PARM                    PMSGFILE
     C                   PARM                    PMSGID
     C                   EVAL      WERROR = 'Y'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREXIT - Return to Calling Program                            *
      *                                                               *
      *****************************************************************
     C     SREXIT        BEGSR

     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Inital processing (Only done first time through)
      *****************************************************************

     C     *INZSR        BEGSR

      **  Set up Local Data Area

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPGM = *BLANKS
     C                   EVAL      DBASE = *ZERO
     C                   OUT       LDA

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'LE002250'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CALLB     'AOGELRR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDGELR        PARM      SDGELR        DSFDY

      * Datebase Error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'LE002250'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IN        RUNDAT

     C                   EVAL      #1PGMQ = PSPROCMOD
     C                   EVAL      #1USER = PSUSER
     C                   EVAL      #1JOB = PSJOBNAME
     C                   EVAL      #1MRDT = AGMRDT

     C     WWLOAN        KLIST
     C                   KFLD                    WLNRF
     C                   KFLD                    WRCDT

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.

      /COPY ZACPYSRC,PSSR_ILE

      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2004
** LEARR@
616263646566676869
