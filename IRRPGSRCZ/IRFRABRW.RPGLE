     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR FRA browse')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRFRABRW  - FRA ISSUED BROWSE                                *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of deals for selection,        *
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. BUG11376           Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209386             Date 09Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP004             Date 28Aug98               *
      *                 CAP003  *CREATE    Date 22May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11376-Remove the incorrect declaration of STDDECLARE      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  209386 - Wrong Message Ids                                   *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CIR005 - FRA/IRS Business Day Conventions (Recompiled)       *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP004 - API's Phase 3.                                      *
      *           Allow browse by Front Office Id.                    *
      *  CAP003 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FIRFRABDF  CF   E             WORKSTN
     F                                     SFILE(IRFRAS1:@@RRN)
     F                                     SFILE(IRFRAS3:@@RRN)                 CAP004
     FDLFRASL0  IF   E           K DISK    INFSR(*PSSR)
                                                                                              CIR008
      ** FRA Deals for Authorisation by Deal Status                                           CIR008
     FDLFRASL1  IF   E           K DISK    INFSR(*PSSR)                                       CIR008
     F                                     RENAME(DEALSDGF:DLFRASD1)                          CIR008
 
     FIRFRAL0   IF   E           K DISK    INFSR(*PSSR)                         CAP004
     F                                     RENAME(DEALSDGF:DEALSFOL0)           CAP004
                                                                                              CIR008
      ** FRA/IRS By Front Office ID for Authorisation                                         CIR008
     FIRFRAL1   IF   E           K DISK    INFSR(*PSSR)                                       CIR008
     F                                     RENAME(DEALSDGF:DEALSFOL1)                         CIR008
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D***/COPY IRCPYSRC,STDDECLARE                                                          BUG11376
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
     D  QQACD1       E                     EXTFLD(QQACCD)                                     CGL029
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D                 DS
     D@@DTIN                   1      8  0
 
     D DealFilFmt    E DS                  EXTNAME(DEALSDG)
      ** Deal in File Format
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CIR008
      ** Switchable Feature Parameter                                                         CIR008
     D CIR008          S              1A                                                      CIR008
                                                                                              CIR008
      ** Parameter for SDRTVTXT                                                               CIR008
     D PMsgDNb         S              7A                                                      CIR008
     D PMsgNm          S             10A                                                      CIR008
     D PMsgTxt         S             80A                                                      CIR008
 
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
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      * BUILD SUB-FILE
      *
     C     @BDSFL        IFEQ      'Y'
      *                                                                         CAP004
      **  If First time in or subfile by Midas deal number was previously       CAP004
      **  being run, then build subfile keyed on Midas deal number.             CAP004
      **  Stay in loop while F11 toggle key is used.                            CAP004
      *                                                                         CAP004
     C     WDEAL         IFNE      'F'                                          CAP004
     C     *INKK         DOUEQ     '0'                                          CAP004
     C                   EXSR      BLDSFL
      *                                                                         CAP004
      **  If F11, switch to Front Office Deal subfile                           CAP004
      *                                                                         CAP004
     C     *INKK         IFEQ      '1'                                          CAP004
     C                   EXSR      BLDSFL2                                      CAP004
     C                   END                                                    CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
     C                   ELSE                                                   CAP004
      *                                                                         CAP004
      **  If the subfile by Front Office Identifier was previously              CAP004
      **  being run, then build subfile keyed on Front Office ID.               CAP004
      **  Stay in loop while F11 toggle key is used.                            CAP004
      *
     C     *INKK         DOUEQ     '0'                                          CAP004
     C                   EXSR      BLDSFL2                                      CAP004
      *                                                                         CAP004
      **  If F11, switch to Midas Deal Number subfile                           CAP004
      *                                                                         CAP004
     C     *INKK         IFEQ      '1'                                          CAP004
     C                   EXSR      BLDSFL                                       CAP004
     C                   END                                                    CAP004
     C                   END                                                    CAP004
     C                   END                                                    CAP004
     C                   END
      *
      * READ SUBFILE RECORD
      *
     C     @RDSFL        IFEQ      'Y'
     C                   EXSR      RDSFLR
     C                   END
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - BUILD SUBFILE
      ********************************************************************
     C     BLDSFL        BEGSR
      *                                                                         CAP004
      * Set indicator and flag for Midas (back) office deal number key used     CAP004
      *                                                                         CAP004
     C                   MOVE      'B'           WDEAL                          CAP004
     C                   MOVE      '0'           *IN20                          CAP004
      *
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      * VALIDATE DEAL NUMBER (FOR POINTER)
      *
     C                   EXSR      VALDLN
     C/COPY WNCPYSRC,IRFRABC001
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     IRFRAS0
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     IRFRAF1
      *
      **  Set file pointer on key displayed on screen.
      *
      ** If FRA/IRS Deals Authorisation is installed and Action Code                          CIR008
      ** is 'X', use new file DLFRASL1 to select deals with status of                         CIR008
      ** 'C' (complete) or 'R' (requires re-authorisation).                                   CIR008
                                                                                              CIR008
     C                   IF        DDACTN = 'X' AND CIR008 = 'Y'                              CIR008
     C     @@DLNO        SETLL     DLFRASL1                                                   CIR008
     C                   ELSE                                                                 CIR008
     C     @@DLNO        SETLL     DLFRASL0
     C                   ENDIF                                                                CIR008
      *
      * READ A VALID DEAL
      *
     C                   EXSR      RDDEAL
      *
      **  If no records exist - set up an error message.
      **  and terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'MMM1007'     @ERRMS
     C                   RETURN
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
     C     @@EOF         DOWNE     'Y'
     C     *IN98         ANDEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      * Format Deal fields for output
      *
     C                   EXSR      FMTDEL
      *
      **  Write the deal to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     IRFRAS1
      *
      * READ A VALID DEAL
      *
     C                   EXSR      RDDEAL
     C                   END
      *
      **  Retrieve time
      *
     C                   TIME                    DDTIME
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     IRFRAS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      IRFRAS0                                99
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
     C                   MOVEL     '1'           @INKL
     C                   RETURN
     C                   END
      *
     C/COPY WNCPYSRC,IRFRABC002
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT                                                                    CAP004
      ********************************************************************      CAP004
      * BLDSFL2 - BUILD SUBFILE (For Front Office ID)                           CAP004
      ********************************************************************      CAP004
     C     BLDSFL2       BEGSR                                                  CAP004
      *                                                                         CAP004
      * Set indicator and flag for front office Id. key used                    CAP004
      *                                                                         CAP004
     C                   MOVE      'F'           WDEAL             1            CAP004
     C                   MOVE      '1'           *IN20                          CAP004
      *                                                                         CAP004
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING               CAP004
      *                                                                         CAP004
     C     BJSBRC        IFNE      *BLANK                                       CAP004
     C                   EXSR      CHAUTN                                       CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      * VALIDATE DEAL NUMBER (FOR POINTER)                                      CAP004
      *                                                                         CAP004
     C                   EXSR      VALDLN                                       CAP004
      *                                                                         CAP004
      **  Get Front Office Id                                                   CAP004
      *                                                                         CAP004
     C     @@DLNO        CHAIN     DLFRASL0                           89        CAP004
     C                   MOVE      FRNT          @@FODL           20            CAP004
     C     *IN89         IFEQ      '1'                                          CAP004
     C                   MOVE      *BLANK        @@FODL                         CAP004
     C                   END                                                    CAP004
     C/COPY WNCPYSRC,IRFRABC003
      *                                                                         CAP004
      **  Initialise subfile relative record number.                            CAP004
      *                                                                         CAP004
     C                   Z-ADD     0             @@RRN             5 0          CAP004
      *                                                                         CAP004
      **  Clear subfile before refilling by writing control record              CAP004
      **  with SFLCLR active.                                                   CAP004
      *                                                                         CAP004
     C                   MOVE      '1'           *IN97                          CAP004
     C                   WRITE     IRFRAS2                                      CAP004
     C                   MOVE      '0'           *IN97                          CAP004
      *                                                                         CAP004
      **  Write the select screen footer to the screen.                         CAP004
      *                                                                         CAP004
     C                   WRITE     IRFRAF1                                      CAP004
      *                                                                         CAP004
      **  Set file pointer on key displayed on screen.                          CAP004
      *                                                                         CAP004
      ** If FRA/IRS Deals Authorisation is installed and Action Code                          CIR008
      ** is 'X', use new file DEALSFOL1 to select deals with status of                        CIR008
      ** 'C' (complete) or 'R' (requires re-authorisation).                                   CIR008
                                                                                              CIR008
     C                   IF        DDACTN = 'X' AND CIR008 = 'Y'                              CIR008
     C     @@FODL        SETLL     DEALSFOL1                                                  CIR008
     C                   ELSE                                                                 CIR008
     C     @@FODL        SETLL     DEALSFOL0                                    CAP004
     C                   ENDIF                                                                CIR008
      *                                                                         CAP004
      * READ A VALID DEAL                                                       CAP004
      *                                                                         CAP004
     C                   EXSR      RDDEAL                                       CAP004
      *                                                                         CAP004
      **  If no records exist - set up an error message.                        CAP004
      **  and terminate                                                         CAP004
      *                                                                         CAP004
     C     @@EOF         IFEQ      'Y'                                          CAP004
     C                   MOVEL     'MMM1007'     @ERRMS                         CAP004
     C                   RETURN                                                 CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      **  Set on ROLLUP indicator to drive initial loop.                        CAP004
      *                                                                         CAP004
     C                   MOVE      '1'           *IN98                          CAP004
      *                                                                         CAP004
      **  Read records from the file into the subfile until a page has          CAP004
      **  been filled or there are no more records.                             CAP004
      **  Repeat the process until either the end of file, ROLLUP               CAP004
      **  has not been entered or F3 or F12 is input.                           CAP004
      *                                                                         CAP004
     C     @@EOF         DOWNE     'Y'                                          CAP004
     C     *IN98         ANDEQ     '1'                                          CAP004
      *                                                                         CAP004
      **  Initialise count of records written to subfile page.                  CAP004
      *                                                                         CAP004
     C                   Z-ADD     0             @@CNT             3 0          CAP004
      *                                                                         CAP004
      **  For each record read, write it to the subfile.                        CAP004
      **  Do this until end of file or the subfile page is full.                CAP004
      *                                                                         CAP004
     C     @@EOF         DOWNE     'Y'                                          CAP004
     C     @@CNT         ANDLT     14                                           CAP004
      *                                                                         CAP004
      **  Increment the subfile record no. and records written fields.          CAP004
      *                                                                         CAP004
     C                   ADD       1             @@RRN                          CAP004
     C                   ADD       1             @@CNT                          CAP004
      *                                                                         CAP004
      * Format Deal fields for output                                           CAP004
      *                                                                         CAP004
     C                   EXSR      FMTDEL                                       CAP004
      *                                                                         CAP004
      **  Write the deal to the subfile.                                        CAP004
      *                                                                         CAP004
     C                   MOVE      *BLANK        DDOPT                          CAP004
     C                   Z-ADD     @@RRN         DDSFRN                         CAP004
     C                   WRITE     IRFRAS3                                      CAP004
      *                                                                         CAP004
      * READ A VALID DEAL                                                       CAP004
      *                                                                         CAP004
     C                   EXSR      RDDEAL                                       CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      **  Retrieve time                                                         CAP004
      *                                                                         CAP004
     C                   TIME                    DDTIME                         CAP004
      *                                                                         CAP004
      **  Write the subfile control record to the screen to display             CAP004
      **  the subfile.                                                          CAP004
      *                                                                         CAP004
     C                   WRITE     IRFRAS2                                      CAP004
      *                                                                         CAP004
      **  Read the subfile control record to determine whether records          CAP004
      **  have been selected or whether ROLLUP is required.                     CAP004
      *                                                                         CAP004
     C                   READ      IRFRAS2                                99    CAP004
      *                                                                         CAP004
      **  If F3, bypass further processing.                                     CAP004
      *                                                                         CAP004
     C     *INKC         IFEQ      '1'                                          CAP004
     C                   MOVEL     '1'           @INKC                          CAP004
     C                   SETON                                        LR        CAP004
     C                   RETURN                                                 CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      **  If F12, bypass further processing.                                    CAP004
      *                                                                         CAP004
     C     *INKL         IFEQ      '1'                                          CAP004
     C                   MOVEL     '1'           @INKL                          CAP004
     C                   RETURN                                                 CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
     C/COPY WNCPYSRC,IRFRABC004
     C                   END                                                    CAP004
      *                                                                         CAP004
     C                   ENDSR                                                  CAP004
      ********************************************************************      CAP004
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
     C     WDEAL         IFNE      'F'                                          CAP004
     C                   READC     IRFRAS1                                99
     C                   ELSE                                                   CAP004
     C                   READC     IRFRAS3                                99    CAP004
     C                   END                                                    CAP004
     C                   END
      *
      **  Return the selected deal number and option
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'R'
     C     DDOPT         OREQ      'X'                                                        CIR008
     C     CIR008        ANDEQ     'Y'                                                        CIR008
     C                   MOVE      DDOPT         @OPSEL
     C                   ELSE
     C                   MOVE      'E'           @OPSEL
     C                   END
      *
     C                   MOVE      DDDEAL        @DLSEL
      *
     C                   END
      *
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTDEL - FORMAT DEAL FIELDS FOR OUTPUT
      ******************************************************************
     C     FMTDEL        BEGSR
      *
      * Deal number
      *
     C                   MOVE      DLNO          DDDEAL
      *
      * Front Office Deal number                                                CAP004
      *                                                                         CAP004
     C                   MOVE      FRNT          DDFODN                         CAP004
      *
      * Deal currency.
      *
     C** Access currency for number of decimal places
     C*
     C                   MOVE      UCUCY         @AJCD             3
     C*
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   MOVE      UCUCY         DDCCY
      *
      * Deal amount.
      *
     C     UPAMT         IFLT      0
     C                   Z-SUB     UPAMT         @@IAMT
     C                   ELSE
     C                   Z-ADD     UPAMT         @@IAMT
     C                   END
     C                   Z-ADD     17            @@CRET
     C                   Z-ADD     A6NBDP        @@CDP
     C                   EXSR      FMTEAM
     C                   MOVE      @@ADSP        DDSAMN
      *
      * Customer number
      *
     C                   MOVE      CNUM          DDCNUM
      *
      * Value date
      *
     C                   MOVE      VDAT          WQ0001
     C     WQ0001        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      ZDATE         DDVDAT
     C                   ELSE
     C                   MOVE      *BLANKS       DDVDAT
     C                   END
      *
      * Notice days or maturity date.
      *
     C                   MOVE      MDAT          WQ0001
     C     WQ0001        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      ZDATE         DDMDAT
     C                   ELSE
     C                   MOVE      *BLANKS       DDMDAT
     C                   END
      *
      **  If the deal has been deleted then show this.
      *
     C     RECI          IFEQ      'R'
     C                   MOVE      '1'           *IN95
     C                   MOVEL     'ZZGBMSGF'    MSGNM
     C                   MOVEL     'ZZM1614'     MSGDNB
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C                   PARM                    MSGNM            10
     C                   PARM                    MSGTXT           80
     C                   MOVEL     MSGTXT        DDTEXT
     C                   ELSE
                                                                                              CIR008
      ** If FRA/IRS Deals Authorisation is installed, set up deal                             CIR008
      ** status for Live or Matured Deals                                                     CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y'                                               CIR008
     C                   EVAL      PMsgDNb = *BLANKS                                          CIR008
                                                                                              CIR008
     C                   SELECT                                                               CIR008
     C                   WHEN      FIDSTS = 'C'                                               CIR008
     C**********         EVAL      PMsgDNb = 'ZZN9633'                                 CIR008 209386
     C                   EVAL      PMsgDNb = 'APA2058'                                        209386
     C                   WHEN      FIDSTS = 'A'                                               CIR008
     C**********         EVAL      PMsgDNb = 'ZZN9634'                                 CIR008 209386
     C                   EVAL      PMsgDNb = 'APA2059'                                        209386
     C                   WHEN      FIDSTS = 'R'                                               CIR008
     C**********         EVAL      PMsgDNb = 'ZZN9635'                                 CIR008 209386
     C                   EVAL      PMsgDNb = 'APA2060'                                        209386
     C                   WHEN      FIDSTS = 'M'                                               CIR008
     C**********         EVAL      PMsgDNb = 'ZZN9636'                                 CIR008 209386
     C                   EVAL      PMsgDNb = 'APA2061'                                        209386
     C                   ENDSL                                                                CIR008
                                                                                              CIR008
     C                   IF        PMsgDNb <> *BLANKS                                         CIR008
     C                   EVAL      *IN95 = *ON                                                CIR008
     C                   EXSR      SrRtvTxt                                                   CIR008
     C                   EVAL      DDTEXT = PMsgTxt                                           CIR008
     C                   ELSE                                                                 CIR008
     C                   EVAL      *IN95 = *OFF                                               CIR008
     C                   EVAL      DDTEXT = *BLANKS                                           CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   ELSE                                                                 CIR008
     C                   MOVE      '0'           *IN95
     C                   MOVE      *BLANKS       DDTEXT
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   END
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      *****************************************************************
      * RDDEAL - READ A DEAL
      *****************************************************************
     C     RDDEAL        BEGSR
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C     @@EOF         DOUEQ     'Y'
     C     @@ERR         OREQ      *ZERO
     C     DTYP          ANDEQ     'FR'                                         CAP004
      *
      **  Read the file.
      *
      ** If FRA/IRS Deals Authorisation is installed and Action Code                          CIR008
      ** is 'X', use new file DLFRASL1/DEALSFOL1 to select deals with                         CIR008
      ** status of 'C' (complete) or 'R' (requires re-authorisation).                         CIR008
                                                                                              CIR008
     C     WDEAL         IFEQ      'B'                                          CAP004
     C                   IF        DDACTN = 'X' AND CIR008 = 'Y'                              CIR008
     C                   READ      DLFRASL1                               96                  CIR008
     C                   ELSE                                                                 CIR008
     C                   READ      DLFRASL0                               96
     C                   ENDIF                                                                CIR008
     C                   ELSE                                                   CAP004
     C                   IF        DDACTN = 'X' AND CIR008 = 'Y'                              CIR008
     C                   READ      DEALSFOL1                              96                  CIR008
     C                   ELSE                                                                 CIR008
     C                   READ      DEALSFOL0                              96    CAP004
     C                   ENDIF                                                                CIR008
     C/COPY WNCPYSRC,IRFRABC005
     C                   END                                                    CAP004
      *
      * End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
      *
      ** If deal read, check whether user can see it
      *
     C     @@EOF         IFNE      'Y'
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C     BKOBUV        IFEQ      'Y'
     C     @@ERR         ANDEQ     *ZERO
     C                   CALL      'ZVOBU'
     C                   PARM                    ORBR
     C                   PARM                    @@ERR
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C     ERDDEL        ENDSR
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
      * VALDLN - VALIDATE DEAL NUMBER POINTER
      *****************************************************************
     C     VALDLN        BEGSR
      *
      **  Validate that the deal number is numeric or blank.
      *
     C                   TESTN                   DDDLNO               98
     C                   MOVE      DDDLNO        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     DDDLNO        IFEQ      *BLANKS
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C                   MOVE      DDDLNO        @@DLNO            6 0
      *
      * RETURN ERROR MESSAGE
      *
     C                   ELSE
     C                   MOVEL     'MMM0162'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM                    BNDCSP            1
     C                   PARM      *BLANK        @@AMTD           14
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTDAT - CONVERT DATE FROM FILE FORMAT TO DDMMMYY (OR MMDDYY)     *
      *****************************************************************
     C     CVTDAT        BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    WQ0001            5 0          Value date
     C                   PARM                    ZDATFM            1            Date format ind
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM                    WQ0004            7            Run-date in DDM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTEAM - FORMAT EDITTED AMOUNT
      *****************************************************************
     C     FMTEAM        BEGSR
      *
     C                   CALLB     'ZA1020'
     C                   PARM                    @@IAMT           15 0
     C                   PARM                    @@CRET            2 0
     C                   PARM                    @@CDP             1 0
     C                   PARM                    BNDCSP
     C                   PARM                    BNTHSP
     C                   PARM      *BLANKS       @@ADSP           21
      *
     C                   ENDSR
      *****************************************************************                       CIR008
      /EJECT                                                                                  CIR008
      *****************************************************************                       CIR008
      *  SrRtvTxt - Retrieve Text from Message File                   *                       CIR008
      *****************************************************************                       CIR008
     C     SrRtvTxt      BEGSR                                                                CIR008
                                                                                              CIR008
     C                   CALL      'SDRTVTXT'                                                 CIR008
     C                   PARM                    PMsgDNb                                      CIR008
     C                   PARM      'ZZGBMSGF'    PMsgNm                                       CIR008
     C                   PARM      *BLANKS       PMsgTxt                                      CIR008
                                                                                              CIR008
     C                   ENDSR                                                                CIR008
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
     C                   MOVE      *BLANK        @DLSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
     C                   MOVE      '0'           *IN20                          CAP004
      *
     C/COPY WNCPYSRC,IRFRABC006
     C                   ENDSR
     C********************************************************************
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
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM                    RetCodeIn
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *
      * BUILD SUB-FILE
     C                   PARM                    @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM                    @RDSFL            1
                                                                                              CIR008
      ** Switchable feature CIR008                                                            CIR008
     C                   PARM                    CIR008                                       CIR008
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM                    @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      *
      * DEAL NUMBER SELECTED
     C                   PARM                    @DLSEL            6
      *
      * COMMAND KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ** Initialize program name
      *
     C                   MOVEL     'IRFRABRW'    DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
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
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS DEALING DETAILS
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
     C/COPY WNCPYSRC,IRFRABC007
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
