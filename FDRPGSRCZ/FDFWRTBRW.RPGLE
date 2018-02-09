     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD Forward Rates Details Browser Module')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing ILE Module                                   *
      *                                                               *
      *  FDFWRTBRW - Forward Rates Details Browser Module             *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of Forward Rates details       *
      *             for selection , the other picks off the           *
      *             selection made.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 235720             Date 18Nov03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 196570             Date 24Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP059  *CREATE    Date 13Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  235720 - JPY is not allowed to have 8 decimal places. Decimal*
      *           places for spot rate is selected based on its diffe-*
      *           rence to the decimal place of the base rate. This   *
      *           selection should be removed.                        *
      *  196570 - Patch for Market Data Feed (recompile)              *
      *  CAP059 - Conversion of Forward Rates into Modular APIs       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFDFWRTBDF CF   E             WORKSTN
     F                                     SFILE(FDFWRTS1:@@RRN)
     F                                     SFILE(FDFWRTS3:@@RRN)
      ** Forward Rates Details File - by Currency
     FFWDRT     IF   E           K DISK    INFSR(*PSSR)
 
      ** Forward Rates Details File - by Front Office Id.
     FFWDRTL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FWDRTFEF:FWDRTL1F)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the FD standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **--------------------------------------------------------------------------------------------
 
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D                 DS
     D arDFW                               LIKE(DFW)
     D  NoDayFrwd                     5P 0 Dim(25) OVERLAY(arDFW)
     D  NoDayFrwdA                    3    Dim(25) OVERLAY(arDFW)
      ** Number of Days Forward Array
 
     D                 DS
     D arRFW                               LIKE(RFW)
     D  FrwdRte                      13P 8 Dim(25) OVERLAY(arRFW)
     D  FrwdRteA                      7    Dim(25) OVERLAY(arRFW)
      ** Forward Rates Array
 
     D                 DS
     D arPNF                               LIKE(PNF)
     D  FrwdPte                      13P 8 Dim(25) OVERLAY(arPNF)
     D  FrwdPteA                      7    Dim(25) OVERLAY(arPNF)
      ** Forward Points Array
 
     D                 DS
     D arSFW                               LIKE(SFW)
     D  FrwdSign                      1A   Dim(25) OVERLAY(arSFW)
      ** Forward Sign Array
 
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Base Currency Number of decimal places
     D BCCDP           S              1  0
 
      ** Difference in Number of decimal places between Fwrd Ccy
      ** and Base Ccy
     D*** DiffNDP         S              1  0                                                 235720
 
     D*WKFLD12p6*******S             12P 6                                                    196570
     D*WKFLD12p7*******S             12P 7                                                    196570
     D*** WKFLD13p6       S             13P 6                                          196570 235720
     D*** WKFLD13p7       S             13P 7                                          196570 235720
     D*WKFLD12p8*******S             12P 8                                                    196570
     D WKFLD13p8       S             13P 8
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Set up the transaction reference to be used by the message handler
     C                   EVAL      TranRef = PCCY
     C                   EVAL      ActionCode = PACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      ** Initialization
      *
     C                   EXSR      INIT
 
      ** BUILD Sub-file
 
     C     @BDSFL        IFEQ      'Y'
      *
      **  If First time in or subfile by currency was previously being
      **  run, then build subfile keyed on currency.
      **  Stay in loop while F11 toggle key is used.
      *
     C     WCCY          IFNE      'F'
     C     WCCY          ANDNE     'S'
     C                   MOVE      'B'           WCCY
      *
     C                   ENDIF
      *
     C     *INKK         DOUEQ     '0'
      *
      ** On F11, initialize position/select fields
      *
     C     *INKK         IFEQ      '1'
      *
     C                   MOVE      *BLANK        DDOPT
     C                   MOVE      *BLANK        DDDYS1
     C                   MOVE      *BLANK        DDRTE1
     C                   MOVE      *BLANK        DDDYS2
     C                   MOVE      *BLANK        DDSFW2
 
      ** Clear program message queue
     C                   CALL      'ZA0250'
 
     C                   ENDIF
 
     C     WCCY          CASEQ     'B'           BLDSFL
     C     WCCY          CASEQ     'F'           BLDSFL2
     C                   ENDCS
     C                   ENDDO
 
     C                   ENDIF
 
      ** READ Subfile Record
 
     C     @RDSFL        IFEQ      'Y'
     C                   EXSR      RDSFLR
     C                   END
 
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - BUILD SUBFILE
      ********************************************************************
     C     BLDSFL        BEGSR
      *
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     FDFWRTS0
     C                   MOVE      '0'           *IN97
      *
      **  Set file pointer on key displayed on screen.
      *
     C     *LOVAL        SETLL     FWDRT
      *
      **  Read a Valid Transaction
      *
     C                   EXSR      RDTran
      *
      **  set up message 'no data to display'
      *
     C                   MOVE      *OFF          *IN80
     C     @@EOF         IFEQ      'Y'
     C                   MOVE      *ON           *IN80
     C                   END
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     *IN98         DOWEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     16
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      **  Format transaction fields for output
      *
     C                   EXSR      FMTTRN
      *
      **  Write the transaction to the subfile.
      *
      **  If action code or Transaction number selected is invalid
      **  the subfile postions on the error record and rebuilds
      *
     C                   MOVE      *OFF          *IN92
     C     @@RRN         IFNE      1
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDCCY     '  LOOKUP    FldNameArr                             98
     C     *IN99         IFNE      '1'
     C     *IN98         ANDNE     '1'
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C                   MOVE      *ON           *IN92
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     FDFWRTS1
      *
      **  Read a valid Transaction
      *
     C                   EXSR      RDTran
     C                   ENDDO
      *
      **  Set up footer toggle text and write the footer
      *
     C                   WRITE     FDFWRTF1
      *
      **  Write the message subfile
      *
     C*******************WRITE     FDFWRTM0
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C     @@CNT         IFEQ      0
     C                   MOVE      '1'           *IN97
     C                   WRITE     FDFWRTS0
     c                   MOVE      '0'           *IN97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN
      *
      **  write to the subfile with non-display set on
      *
     c                   MOVE      '1'           *IN93
     C                   WRITE     FDFWRTS1
     c                   MOVE      '0'           *IN93
     C                   WRITE     FDFWRTS0
     c                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     FDFWRTS0
     c                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      FDFWRTS0                               99
      *
      ** Clear any messages before processing user input
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      **  If F3, bypass further processing.
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F12, bypass further processing.
     C     *INKL         IFEQ      '1'
     C                   MOVEL     'L'           @OPSEL
     C                   MOVEL     '1'           @INKL
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
     C                   END
      *
      * Set indicator ans flag for Midas Front Office I.D. browse key   used
      *
     C     *INKK         IFEQ      '1'
     C                   MOVE      'F'           WCCY              1
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL2 - BUILD SUBFILE by FRONT OFFICE ID.
      ********************************************************************
 
     C     BLDSFL2       BEGSR
      *
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      **  Get Front Office Transaction Reference
      *
     C     *LOVAL        SETLL     FWDRT                              89
     C                   READ      FWDRT                                  89
     C                   MOVE      FRFRNT        @@FOID           20
     C     *IN89         IFEQ      '1'
     C                   MOVE      *BLANK        @@FOID
     C                   END
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     FDFWRTS2
     C                   MOVE      '0'           *IN97
      *
      **  Set file pointer on key displayed on screen.
      *
     C     @@FOID        SETLL     FWDRTL1
      *
      ** Read a Valid Trade
      *
     C                   EXSR      RDTran
      *
      **  set up message 'no data to display'
      *
     C                   MOVE      *OFF          *IN80
     C     @@EOF         IFEQ      'Y'
     C                   MOVE      *ON           *IN80
     C                   END
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     *IN98         DOWEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     16
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format custo fields for output
      *
     C                   EXSR      FMTTRN
      *
      **  Write the customer to the subfile.
      *
      **  If action code or Transaction number selected is invalid,
      **  the subfile postions on the error record and rebuilds
      *
     C                   MOVE      *OFF          *IN92
     C     @@RRN         IFNE      1
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C     'DDOPT     '  LOOKUP    FldNameArr                             99
     C     'DDCCY     '  LOOKUP    FldNameArr                             98
     C     *IN99         IFNE      '1'
     C     *IN98         ANDNE     '1'
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C                   MOVE      *ON           *IN92
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     FDFWRTS3
      *
      ** Read a valid Transaction
      *
     C                   EXSR      RDTran
     C                   END
      *
      **  Set up footer toggle text and write the footer
      *
     C                   WRITE     FDFWRTF1
      *
      **  Write the message subfile
      *
     C                   WRITE     FDFWRTM0
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C     @@CNT         IFEQ      0
     c                   MOVE      '1'           *IN97
     C                   WRITE     FDFWRTS2
     c                   MOVE      '0'           *IN97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN
      *
      **  write to the subfile with non-display set on
      *
     C                   MOVE      '1'           *IN93
     C                   WRITE     FDFWRTS3
     C                   MOVE      '0'           *IN93
     C                   WRITE     FDFWRTS2
     C                   ELSE
      *
      **  Set up footer toggle text and write the footer
      *
     C                   WRITE     FDFWRTF1
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     FDFWRTS2
     C                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      FDFWRTS2                               99
      *
      ** Clear any messages before processing user input
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     'L'           @OPSEL
     C                   MOVEL     '1'           @INKL
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
     C                   END
      *
      * Set indicator and flag for Midas (back) office Transaction number key
      *
     C     *INKK         IFEQ      '1'
     C                   MOVE      'B'           WCCY
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - READ SUBFILE RECORD
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
 
     C                   IF        WCCY <> 'F'
     C                   READC     FDFWRTS1                               99
     C                   ELSE
     C                   READC     FDFWRTS3                               99
     C                   ENDIF
 
     C                   END
      *
      **  Return the selected transaction reference and option
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'D'
     C                   MOVE      DDOPT         @OPSEL
     C                   ELSE
     C                   MOVE      'E'           @OPSEL
     C                   END
      *
     C                   MOVE      DDCCY         @TRSEL
      *
     C                   END
      *
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTTRN - FORMAT TRANSACTION FOR OUTPUT
      ******************************************************************
     C     FMTTRN        BEGSR
 
     C                   MOVE      FRFRNT        DDFRNT
     C                   MOVE      DFW           arDFW
      * Forward Days 1
     C                   IF        NoDayFrwdA(1) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(1)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDYS1
     C                   ELSE
     C                   MOVE      *BLANKS       DDDYS1
     C                   ENDIF
 
      * Forward Days 2
     C                   IF        NoDayFrwdA(2) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(2)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDYS2
     C                   ELSE
     C                   MOVE      *BLANKS       DDDYS2
     C                   ENDIF
 
 
      * Access currency data for the forward rate
      * (Database error handling done in access program).
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CCY           @KEYCY            3
     C     SDCURR        PARM      SDCURR        DSSDY
 
      * Calculate the difference in decimal places between forward
      * rate currency and base currency
 
     C**********         EVAL      DiffNDP = A6NBDP - BCCDP + 4                               235720
 
      * Currency Code
     C                   Eval      DDCCY = CCY
 
      * If S01432 is on diplay points, if not display the rates
 
     C                   IF        S01432 = 'Y'
      * S01432 is on
     C                   EXSR      PointsSR
     C                   ELSE
      * S01432 is off
     C                   EXSR      RatesSR
     C                   ENDIF
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * PointsSR - Display points if S01432 is on.                    *
      *                                                               *
      *****************************************************************
     C     PointsSR      BEGSR
 
     C                   EXSR      srCLR
     C                   MOVE      A6SPRT        WKFLD13P8
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDRTE1
 
      * Move data from FWDRTFE into array
     C                   MOVE      PNF           arPNF
 
     C                   IF        FrwdPteA(2) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(2)    WKFLD13p8
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDRTE2
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE2
     C                   ENDIF
 
      * Forward Sign
     C                   MOVE      SFW           arSFW
 
     C                   IF        FrwdSign(2) <> '+'
     C                             AND FrwdSign(2) <> '-'
     C                   MOVE      *BLANKS       DDSFW2
     C                   ELSE
     C                   Eval      DDSFW2 = FrwdSign(2)
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * RatesSR  -  display rates sub-routine                         *
      *                                                               *
      *****************************************************************
     C     RatesSR       BEGSR
     C
      * Move data from FWDRTFE into arrays
     C                   MOVE      RFW           arRFW
 
      * Forward Rate 1
     C                   IF        FrwdRteA(1) <> *BLANK
     C                   EXSR      SrCLR
     C                   Z-ADD     FrwdRte(1)    WKFLD13p8
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDRTE1
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE1
     C                   ENDIF
 
      * Forward Rate 2
     C                   IF        FrwdRteA(2) <> *BLANK
     C                   EXSR      SrCLR
     C                   Z-ADD     FrwdRte(2)    WKFLD13p8
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDRTE2
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE2
     C                   ENDIF
 
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * srCLR - Clear fields                                          *
      *                                                               *
      *****************************************************************
     C     srCLR         BEGSR
     C
     C*******************CLEAR                   WKFLD12p6                                    196570
     C*******************CLEAR                   WKFLD12p7                                    196570
     C*******************CLEAR                   WKFLD12p8                                    196570
     C**********         CLEAR                   WKFLD13p6                             196570 235720
     C**********         CLEAR                   WKFLD13p7                             196570 235720
     C                   CLEAR                   ZFIELD
     C                   CLEAR                   WKFLD13p8
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDTran - READ A TRANSACTION
      *****************************************************************
     C     RDTran        BEGSR
      *
      **  Reset End of File and skip record indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C     @@EOF         DOUEQ     'Y'
     C     CCY           ORNE      *BLANKS
     C     @@ERR         ANDEQ     *ZERO
     C     CHTP          ANDNE     'D'
     C     RECI          ANDNE     '*'
     C
      *
      **  Read the file
      *
     C                   READ      FWDRT                                  96
      *
      * End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     ERDCUST       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * RETURN ERROR MESSAGE
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C**********         SELECT                                                               235720
 
      * Set up the number of deciamal places
 
     C**********         WHEN      DiffNDP = 1                                                235720
     C*******************Z-ADD     WKFLD13p8     WKFLD12p6                                    196570
     C*******************MOVE      WKFLD12p6     ZFIELD                                       196570
     C**********         Z-ADD     WKFLD13p8     WKFLD13p6                             196570 235720
     C**********         MOVE      WKFLD13p6     ZFIELD                                196570 235720
     C**********         EVAL      ZADEC = 6                                                  235720
 
     C**********         WHEN      DiffNDP = 2                                                235720
     C*******************Z-ADD     WKFLD13p8     WKFLD12p7                                    196570
     C*******************MOVE      WKFLD12p7     ZFIELD                                       196570
     C**********         Z-ADD     WKFLD13p8     WKFLD13p7                             196570 235720
     C**********         MOVE      WKFLD13p7     ZFIELD                                196570 235720
     C**********         EVAL      ZADECD= 7                                                  235720
 
     C**********         OTHER                                                                235720
     C*******************Z-ADD     WKFLD13p8     WKFLD12p8                                    196570
     C*******************MOVE      WKFLD12p8     ZFIELD                                       196570
     C                   MOVE      WKFLD13p8     ZFIELD                                       196570
     C                   EVAL      ZADEC = 8
     C**********         ENDSL                                                                235720
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDITDay - Edit the Day Field                                 *
      *                                                               *
      *****************************************************************
     C     ZEDITDay      BEGSR
 
      * Set up the number of deciamal places
 
     C                   EVAL      ZADEC = 0
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C                   IF        ZFIELD = '               0'
     C                   EVAL      ZFIELD = *BLANK
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @TRSEL
     C                   MOVE      '0'           @INKC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * Return Code
     C                   PARM                    RetCodeIn
      * Action Code
     C                   PARM                    PACTN             1
      * Currency Pointer
     C                   PARM                    PCCY              3
      * Build Subfile
     C                   PARM                    @BDSFL            1
      * Read Subfile Record
     C                   PARM                    @RDSFL            1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * OUTPUT PARAMETERS :
      * Error Message
      * Option Selected
      * Transaction Reference selected
     C                   PARM                    @ERRMS            7
     C                   PARM                    @OPSEL            1
     C                   PARM                    @TRSEL            3
      * Command Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ** Initialize program name
     C                   MOVEL     'FDFWRTBRW'   DBPGM
      *
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
      *
     C                   MOVE      '1'           *IN94
     C                   MOVEL     '*'           DDPGMQ
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
 
      * Access currency data
      * (Database error handling done in access program).
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJCYCD        @KEYCY            3
     C     SDCURR        PARM      SDCURR        DSSDY
 
 
      ** Check if switchable feature S01432 is switched on.
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01432'      @SARD             6
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01432'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01432            1
     C                   ELSE
     C                   MOVE      'N'           S01432
     C                   ENDIF
 
     C                   EVAL      BCCDP = A6NBDP
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      *
      /EJECT
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
