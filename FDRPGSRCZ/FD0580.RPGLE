     H DEBUG
      *****************************************************************
/*XBIA*: OVRDBF FILE(SDMDFFWR) TOFILE(SDMDFHL2)                     : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD Fwd Rates Exceeding Rate Tolerance Rpt')
      *****************************************************************
      *                                                               *
      *  Midas - FD Module                                            *
      *                                                               *
      *  FD0580 - FD Forward Rates Exceeding Rate Tolerance Report    *
      *                                                               *
      *  Function:  This program will read through the file SDMDFFWR  *
      *             from the start. It will either print details of   *
      *             all currency Forward rates exceeding tolerance    *
      *             today or just those currency forward rates        *
      *             exceeding tolerance today since the last time the *
      *             report was run.                                   *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 214115             Date 02Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 196570             Date 12Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006  *CREATE    Date 02Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  214115 - Forward Rates Report shows no points when S01432 on *
      *  196570 - Report does not show rates exceeding tolerance today*
      *  CSD006 - Market Data Feeds                                   *
      *                                                               *
      *****************************************************************
     FSDMDFFWR  UF   E           K DISK    INFSR(*PSSR)
      ** MDF History File For Forward Rates Exceeding Tolerance
      *
     FFD0580AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
      ** Forward Rates Exceeding Rate Tolerance Report - Audit
      *
     FFD0580P1  O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
      ** Forward Rates Exceeding Rate Tolerance Report
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   80  - End of File                                           *
      *   83  - Error on Update                                       *
      *                                                               *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT - Program Initialisation                              *
      *  SRPROC - Detail Processing                                   *
      *  SRSAVR - Subroutine to save rate history detail for each     *
      *           currency                                            *
      *  SRREPT - Process Report Lines                                *
      *  SRFMTR - Subroutine to format report fields                  *
      *                                                               *
      *  SRP1RC - Format and Write a Detail Record to the Report      *
      *  SRREND - Write End of Report                                 *
      *                                                               *
      *  SRAUDT - Produce Audit Report and End Program                *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *  RCFP1  - RCF Processing for P1 Report                        *
      *  RCFAU  - RCF Processing for Audit Report                     *
      *                                                               *
      *  AOBANKR0  - Access Object for Bank Details                   *
      *  ZSFILE    - Sets up spool file                               *
      *                                                               *
      *****************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
     D @OB             S             11  7 DIM(21)
     D @NB             S             11  7 DIM(21)
     D @OL             S             11  7 DIM(21)
     D @NL             S             11  7 DIM(21)
      *
      ** Array for old/new borrow and lending rates
      *
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
     D SPOOL1          DS
 
      **  File Information Data Structure for FD0580P1.
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      ** File Information Data Structure for FD0580AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D WTMEST          DS
      ** Data structure for timestamp (printed)
     D  WCENT                  1      2
     D  WYEAR                  3      4
     D  WSLSH1                 5      5
     D  WMONTH                 6      7
     D  WSLSH2                 8      8
     D  WDAY                   9     10
     D  WHOUR                 12     13
     D  WCOL1                 14     14
     D  WMIN                  15     16
     D  WCOL2                 17     17
     D  WSECS                 18     19
      *
     D WTMEDS          DS
      ** Data structure for timestamp
     D  WCNT                   1      2
     D  WYR                    3      4
     D  WMNTH                  5      6
     D  WDY                    7      8
     D  WHR                    9     10
     D  WMN                   11     12
     D  WSC                   13     14
      *
     D BEFRDS        E DS                  EXTNAME(FWDRTFE)
     D                                     PREFIX(B_)
      ** Before image details of the Forward rates
      *
     D AFTRDS        E DS                  EXTNAME(FWDRTFE)
     D                                     PREFIX(A_)
      ** After image details of the Forward rates
 
     D                 DS
     D arDFW                               LIKE(B_DFW)
     D  NoDayFrwd                     5P 0 Dim(25) OVERLAY(arDFW)
     D  NoDayFrwdA                    3    Dim(25) OVERLAY(arDFW)
      ** Number of Days Forward Array
 
     D                 DS
     D arRFW                               LIKE(B_RFW)
     D  FrwdRte                      13P 8 Dim(25) OVERLAY(arRFW)
     D  FrwdRteA                      7    Dim(25) OVERLAY(arRFW)
      ** Forward Rates Array
 
     D                 DS
     D arPNF                               LIKE(B_PNF)
     D  FrwdPte                      13P 8 Dim(25) OVERLAY(arPNF)
     D  FrwdPteA                      7    Dim(25) OVERLAY(arPNF)
      ** Forward Points Array
 
     D                 DS
     D arSFW                               LIKE(B_SFW)
     D  FrwdSign                      1A   Dim(25) OVERLAY(arSFW)
      ** Forward Sign Array
 
     D N               S              2  0
      ** Index for Arrays
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Dummy Data Structures used by Access Programs.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **   External data structures for Bank Details
      *
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Perform Initialisation.
      *
     C                   EXSR      SRINIT
      *
      ** Perform Detail Processing.
      *
     C                   EXSR      SRPROC
      *
      ** Output Audit Report and End Program.
      *
     C                   EXSR      SRAUDT
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *  AOBANKR0 Access Program                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR                                                  *** SRINIT ***
      *
      ** Receive Parameter List.
      *
     C     *ENTRY        PLIST
     C                   PARM                    RSEQ              5
     C                   PARM                    RPARM           100
 
      * Seton title indicator if the user requested todays report
 
     C                   MOVE      *OFF          *IN60
     C     RPARM         IFNE      'ALL'
     C                   MOVE      *ON           *IN60
     C                   ENDIF
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Setup LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Initialise LDA field.
      *
     C                   MOVEL     'FD0580'      DBPGM
      *
      *** Call Access Program for Bank Details - Title, Run Date and
      *** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   Z-ADD     001           DBASE                          * DB ERROR 01 *
     C                   MOVEL     WOPTN         DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check System Date Format, DDMMYY (*IN98 off)
      **                           MMDDYY (*IN98 on).
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *
      ** Key lists
      *
     C     KYMDF         KLIST
     C                   KFLD                    BJRDNB
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
      *
                                                                                              214115
      ** Check if switchable feature S01432 is switched on.                                   214115
                                                                                              214115
     C                   CALLB     'AOSARDR0'                                                 214115
     C                   PARM      *BLANKS       WRTCD                                        214115
     C                   PARM      '*VERIFY'     WOPTN                                        214115
     C                   PARM      'S01432'      @SARD             6                          214115
                                                                                              214115
      ** Database Error                                                                       214115
                                                                                              214115
     C     WRTCD         IFNE      *BLANKS                                                    214115
     C     WRTCD         ANDNE     '*NRF   '                                                  214115
     C                   MOVEL     'S01432'      DBKEY                                        214115
     C                   MOVEL     'SCSARDPD'    DBFILE                                       214115
     C                   MOVEL     '902'         DBASE                                        214115
     C                   EXSR      *PSSR                                                      214115
     C                   ENDIF                                                                214115
                                                                                              214115
     C     WRTCD         IFEQ      *BLANK                                                     214115
     C                   MOVE      'Y'           S01432            1                          214115
     C                   ELSE                                                                 214115
     C                   MOVE      'N'           S01432                                       214115
     C                   ENDIF                                                                214115
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRPROC
      *****************************************************************
      *                                                               *
      *  SRPROC - Subroutine to do the Detail Processing.             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *  SRREPT - Process Report Lines                                *
      *  SRSAVR - Save rate history to array                          *
      *  SRREND - Write End of Report                                 *
      *  RCFP1  - Subroutine to register P1 printer file via RCF.     *
      *                                                               *
      *****************************************************************
      *
     C     SRPROC        BEGSR                                                  *** SRPROC ***
      *
      ** Read first record from File.
      *
     C                   READ      SDMDFFWR                               80
      *
      ** If End of Records, (*IN80), Perform: Audit Reporting (No
      ** Records).
      *
     C     *IN80         IFEQ      *ON
     C                   EXSR      SRAUDT
     C                   ELSE
     C                   EXSR      RCFP1
     C                   ENDIF
      *
      ** Do until end of file
      *
     C     *IN80         DOUEQ     *ON
     C                   IF        RHPRCD = BJRDNB                                            196570
      *
      ** Count records read.
      *
     C                   ADD       1             RCOUNT            5 0
      *
      ** Process Report Lines.
      *
     C                   EXSR      SRREPT
     C                   ENDIF                                                                196570
      *
      ** Read next record.
      *
     C                   READ      SDMDFFWR                               80
     C                   ENDDO
      *
      ** Write final records and Totals to Report.
      *
     C                   EXSR      SRREND
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRREPT
      *****************************************************************
      *                                                               *
      *  SRREPT - Process Report Lines.                               *
      *                                                               *
      *  Called By: SRPROC                                            *
      *  Calls:                                                       *
      *  SRFMTR - Format fields for output                            *
      *  SRP1RC - Write Detail Record to the Report                   *
      *                                                               *
      *****************************************************************
      *
     C     SRREPT        BEGSR                                                  *** SRREPT ***
      *
      ** Format report fields for the first detail format
      *
     C                   EXSR      SRFMTR
      *
      ** Write out the record.
      *
     C                   EXSR      SRP1RC
      *
      ** Format report fields for the second detail format and print
      ** if non-blank
      *
     C                   EXSR      SRFMTR2
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRFMTR
      *****************************************************************
      *                                                               *
      *  SRFMTR - Subroutine to format report fields.                 *
      *                                                               *
      *  Called By: SRFMTR subroutine                                 *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRFMTR        BEGSR                                                  *** SRFMTR ***
 
      * Move Before and After Image into Data Structure
 
     C                   MOVEL     RHBIMG        BEFRDS
     C                   MOVEL     RHAIMG        AFTRDS
 
      * Forward Rate Id and Currency
 
     C                   MOVEL     RHTREF        WTREF
     C                   MOVEL     A_CCY         WCCY
 
      * Move data from before image into the days array
 
     C                   MOVE      B_DFW         arDFW
 
      * Forward Days 1
 
     C                   IF        NoDayFrwdA(1) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(1)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        WBDFW1
     C                   ELSE
     C                   MOVE      *BLANKS       WBDFW1
     C                   ENDIF
 
      * Forward Days 2
 
     C                   IF        NoDayFrwdA(2) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(2)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        WBDFW2
     C                   ELSE
     C                   MOVE      *BLANKS       WBDFW2
     C                   ENDIF
 
      * Move data from the before image into the rate array
     C                   MOVE      B_PNF         arPNF                                        214115
     C                   MOVE      B_RFW         arRFW
 
      * Forward Rate 1
 
     C                   IF        FrwdRteA(1) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      FrwdRte(1)    ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        WBRFW1
     C                   ELSE
     C                   MOVE      *BLANKS       WBRFW1
     C                   ENDIF
 
      * Forward Rate 2
 
     C                   IF        FrwdRteA(2) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      FrwdRte(2)    ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        WBRFW2
     C                   ELSE
     C                   MOVE      *BLANKS       WBRFW2
     C                   ENDIF
 
     C                   IF        S01432='Y'                                                 214115
      * Forward Points 2                                                                      214115
     C                   IF        FrwdPteA(2) <> *BLANK                                      214115
     C                   MOVE      *BLANKS       ZFIELD                                       214115
     C                   MOVE      FrwdPte(2)    ZFIELD                                       214115
     C                   EXSR      ZEDIT                                                      214115
     C                   MOVE      ZFIELD        WBRFW2                                       214115
     C                   ELSE                                                                 214115
     C                   MOVE      *BLANKS       WBRFW2                                       214115
     C                   ENDIF                                                                214115
     C                   ENDIF                                                                214115
      * Move data from the before image into the sign array
 
     C                   IF        S01432='Y'                                                 214115
     C                   MOVE      B_SFW         arSFW
     C                   ENDIF                                                                214115
      * Forward Sign 1
 
     C                   IF        FrwdSign(1) <> '+'
     C                             AND FrwdSign(1) <> '-'
     C                   MOVE      *BLANKS       WBSFW1
     C                   ELSE
     C                   Eval      WBSFW1 = FrwdSign(1)
     C                   ENDIF
 
      * Forward Sign 2
 
     C                   IF        FrwdSign(2) <> '+'
     C                             AND FrwdSign(2) <> '-'
     C                   MOVE      *BLANKS       WBSFW2
     C                   ELSE
     C                   Eval      WBSFW2 = FrwdSign(2)
     C                   ENDIF
 
      * Move data from after image into the days array
 
     C                   MOVE      A_DFW         arDFW
 
      * Forward Days 1
 
     C                   IF        NoDayFrwdA(1) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(1)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        WADFW1
     C                   ELSE
     C                   MOVE      *BLANKS       WADFW1
     C                   ENDIF
 
      * Forward Days 2
 
     C                   IF        NoDayFrwdA(2) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(2)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        WADFW2
     C                   ELSE
     C                   MOVE      *BLANKS       WADFW2
     C                   ENDIF
 
      * Move data from the after image into the rate array
 
     C                   MOVE      A_PNF         arPNF                                        214115
     C                   MOVE      A_RFW         arRFW
 
      * Forward Rate 1
 
     C                   IF        FrwdRteA(1) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      FrwdRte(1)    ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        WARFW1
     C                   ELSE
     C                   MOVE      *BLANKS       WARFW1
     C                   ENDIF
 
      * Forward Rate 2
 
     C                   IF        FrwdRteA(2) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      FrwdRte(2)    ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        WARFW2
     C                   ELSE
     C                   MOVE      *BLANKS       WARFW2
     C                   ENDIF
 
     C                   IF        S01432='Y'                                                 214115
      * Forward Points 2                                                                      214115
     C                   IF        FrwdPteA(2) <> *BLANK                                      214115
     C                   MOVE      *BLANKS       ZFIELD                                       214115
     C                   MOVE      FrwdPte(2)    ZFIELD                                       214115
     C                   EXSR      ZEDIT                                                      214115
     C                   MOVE      ZFIELD        WARFW2                                       214115
     C                   ELSE                                                                 214115
     C                   MOVE      *BLANKS       WARFW2                                       214115
     C                   ENDIF                                                                214115
     C                   ENDIF                                                                214115
      * Move data from the after image into the sign array
 
     C                   IF        S01432='Y'                                                 214115
     C                   MOVE      A_SFW         arSFW
     C                   ENDIF                                                                214115
 
      * Forward Sign 1
 
     C                   IF        FrwdSign(1) <> '+'
     C                             AND FrwdSign(1) <> '-'
     C                   MOVE      *BLANKS       WASFW1
     C                   ELSE
     C                   Eval      WASFW1 = FrwdSign(1)
     C                   ENDIF
 
      * Forward Sign 2
 
     C                   IF        FrwdSign(2) <> '+'
     C                             AND FrwdSign(2) <> '-'
     C                   MOVE      *BLANKS       WASFW2
     C                   ELSE
     C                   Eval      WASFW2 = FrwdSign(2)
     C                   ENDIF
 
      * Data Feed Request Id
 
     C                   MOVEL     RHDFRI        WDFRI
      * Timestamp
 
     C                   MOVEL     '/'           WSLSH1
     C                   MOVEL     '/'           WSLSH2
     C                   MOVEL     ':'           WCOL1
     C                   MOVEL     ':'           WCOL2
     C                   MOVEL     RHDFTS        WTMEDS
     C                   MOVEL     WCNT          WCENT
     C                   MOVEL     WYR           WYEAR
     C                   MOVEL     WMNTH         WMONTH
     C                   MOVEL     WDY           WDAY
     C                   MOVEL     WHR           WHOUR
     C                   MOVEL     WMN           WMIN
     C                   MOVEL     WSC           WSECS
 
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRFMTR2
      *****************************************************************
      *                                                               *
      *  SRFMTR2 - Subroutine to format report fields for detail2     *
      *            format                                             *
      *                                                               *
      *  Called By: SRREPT subroutine                                 *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRFMTR2       BEGSR                                                  *** SRFMTR ***
 
      * Initialise index to read through array
 
     C                   EVAL      N = 3
 
      * Do until there is'nt any more data to display for this record
 
B01  C                   DOW       N <= 25
 
      * Move data from before image into the days array
 
     C                   MOVE      B_DFW         arDFW
 
      * Forward Days
 
B02  C                   IF        NoDayFrwdA(N) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(N)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        WBDFW
X02  C                   ELSE
     C                   MOVE      *BLANKS       WBDFW
E02  C                   ENDIF
 
      * Move data from the before image into the rate array
 
     C                   MOVE      B_PNF         arPNF                                        214115
     C                   MOVE      B_RFW         arRFW
 
      * Forward Rate
 
     C                   IF        S01432='N'                                                 214115
B02  C                   IF        FrwdRteA(N) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      FrwdRte(N)    ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        WBRFW
X02  C                   ELSE
     C                   MOVE      *BLANKS       WBRFW
E02  C                   ENDIF
E02  C                   ENDIF                                                                214115
 
     C                   IF        S01432='Y'                                                 214115
     C                   IF        FrwdPteA(N) <> *BLANK                                      214115
     C                   MOVE      *BLANKS       ZFIELD                                       214115
     C                   MOVE      FrwdPte(N)    ZFIELD                                       214115
     C                   EXSR      ZEDIT                                                      214115
     C                   MOVE      ZFIELD        WBRFW                                        214115
     C                   ELSE                                                                 214115
     C                   MOVE      *BLANKS       WBRFW                                        214115
     C                   ENDIF                                                                214115
E02  C                   ENDIF                                                                214115
      * Move data from the before image into the sign array
 
     C                   IF        S01432='Y'                                                 214115
     C                   MOVE      B_SFW         arSFW
     C                   ENDIF                                                                214115
 
      * Forward Sign
 
B02  C                   IF        FrwdSign(N) <> '+'
     C                             AND FrwdSign(N) <> '-'
     C                   MOVE      *BLANKS       WBSFW
X02  C                   ELSE
     C                   Eval      WBSFW = FrwdSign(N)
E02  C                   ENDIF
 
      * Move data from after image into the days array
 
     C                   MOVE      A_DFW         arDFW
 
      * Forward Days
 
B02  C                   IF        NoDayFrwdA(N) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(N)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        WADFW
X02  C                   ELSE
     C                   MOVE      *BLANKS       WADFW
E02  C                   ENDIF
 
      * Move data from the after image into the rate array
 
     C                   MOVE      A_RFW         arRFW
     C                   MOVE      A_PNF         arPNF                                        214115
 
      * Forward Rate
 
     C                   IF        S01432='N'                                                 214115
B02  C                   IF        FrwdRteA(N) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      FrwdRte(N)    ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        WARFW
X02  C                   ELSE
     C                   MOVE      *BLANKS       WARFW
E02  C                   ENDIF
E02  C                   ENDIF                                                                214115
 
     C                   IF        S01432='Y'                                                 214115
     C                   IF        FrwdPteA(N) <> *BLANK                                      214115
     C                   MOVE      *BLANKS       ZFIELD                                       214115
     C                   MOVE      FrwdPte(N)    ZFIELD                                       214115
     C                   EXSR      ZEDIT                                                      214115
     C                   MOVE      ZFIELD        WARFW                                        214115
     C                   ELSE                                                                 214115
     C                   MOVE      *BLANKS       WARFW                                        214115
     C                   ENDIF                                                                214115
E02  C                   ENDIF                                                                214115
      * Move data from the after image into the sign array
 
     C                   IF        S01432='Y'                                                 214115
     C                   MOVE      A_SFW         arSFW
     C                   ENDIF                                                                214115
 
      * Forward Sign
 
B02  C                   IF        FrwdSign(N) <> '+'
     C                             AND FrwdSign(N) <> '-'
     C                   MOVE      *BLANKS       WASFW
X02  C                   ELSE
     C                   Eval      WASFW = FrwdSign(N)
E02  C                   ENDIF
 
      * Check to see if the fields are blank
 
B02  C                   IF        WBDFW <> *BLANK
B02  C                             OR WBRFW <> *BLANK
 
B02  C                             OR WADFW <> *BLANK
B02  C                             OR WARFW <> *BLANK
 
      * Write to the DETAIL2 format
 
     C                   EXSR      SRP1RC2
 
X02  C                   ELSE
     C                   LEAVE
E02  C                   ENDIF
 
     C                   EVAL      N = N + 1
 
E01  C                   ENDDO
 
     C                   ENDSR
      *
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
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   EVAL      ZADEC = 8
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C                   IF        ZFIELD = '      0.00000000'
     C                   EVAL      ZFIELD = *BLANK
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRP1RC
      *****************************************************************
      *                                                               *
      *  SRP1RC - Subroutine to Write a Detail record to the Report.  *
      *                                                               *
      *  Called By: SRREPT subroutine                                 *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRP1RC        BEGSR                                                  *** SRP1RC ***
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     6             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2
     C                   ELSE
     C                   WRITE     HEADP2
     C                   ENDIF
      *
      ** Write out Detail Record.
      *
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRP1RC2
      *****************************************************************
      *                                                               *
      *  SRP1RC2 - Subroutine to Write a Detail2 record to the Report *
      *                                                               *
      *  Called By: SRFMTR2 subroutine                                *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRP1RC2       BEGSR                                                  *** SRP1RC2 ***
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     5             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2
     C                   ENDIF
      *
      ** Write out DETAIL2 Record.
      *
     C                   WRITE     DETAIL2
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRREND
      *****************************************************************
      *                                                               *
      *  SRREND - Subroutine to Write End of Report.                  *
      *                                                               *
      *  Called By: SRPROC subroutine                                 *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRREND        BEGSR                                                  *** SRREND ***
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write out Total Format.
      *
     C                   WRITE     TRAILP1
     C                   CLOSE     FD0580P1
      *
      ** Update reported on audit report
      *
     C     KYMDF         SETLL     SDMDFFWR
     C                   READ      SDMDFFWR                               80
      *
      ** Do while processing date is equal to todays rundate
      *
     C     *IN80         DOWEQ     *OFF
     C     RHPRCD        ANDEQ     BJRDNB
     C                   MOVE      'Y'           RHAUDT
     C                   UPDATE    SDMDFHD0                             83
      *
      ** Error on update
      *
     C     *IN83         IFEQ      *ON
     C                   MOVE      'SDMDFFWR'    DBFILE                         ***************
     C                   Z-ADD     3             DBASE                          * DB ERROR 03 *
     C                   MOVEL     RHDITM        DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      SDMDFFWR                               80
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRAUDT
      *****************************************************************
      *                                                               *
      *  SRAUDT - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, SRPROC, *PSSR                    *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRAUDT        BEGSR                                                  *** SRAUDT ***
      *
      ** Output Report Header and File Controls.
      *
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message.
      *
     C     RCOUNT        IFEQ      0
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
      *
      ** End Program and Return.
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR **
      *
      ** Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   EXSR      SRAUDT
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/RCFP1
      *****************************************************************
      *                                                               *
      *  RCFP1  - Subroutine to register the P1 Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     RCFP1         BEGSR                                                   *** RCFP1  ***
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   OPEN      FD0580P1
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ               5
     C                   PARM      *BLANK        SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/RCFAU
      *****************************************************************
      *                                                               *
      *  RCFAU  - Subroutine to register the AU Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     RCFAU         BEGSR                                                   *** RCFAU  ***
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
