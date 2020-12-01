     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *                       220859
/*EXI *  TEXT('Midas DL OIS Interest Rate Amendment')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL1652 - OIS Interest Rate Amendment                         *
      *                                                               *
      *  Function:  This program will allow amendment of a Base Rate, *
      *             or Initial Compounding Rate on a single record    *
      *             from PF/DLDOISPD.                                 *
      *                                                               *
      *  Called By: DL1641 - OIS Compounding Interest Rate Enquiry    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 245692             Date 11Dec13               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER016A            Date 19May08               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 CPK025             Date 08Jul06               *
      *                 BUG7033            Date 01Mar06               *
      *                 226723             Date 01Mar06               *
      *                 221685             Date 01Mar06               *
      *                 220859             Date 01Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CIR013             Date 21Apr05               *
      *                 CAS009             Date 16May05               *
      *                 CAS008             Date 16Jun04               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 217684             Date 12May03               *
      *                 CAS004             Date 26Jun02               *
      *                 212248             Date 21Nov02               *
      *                 214440             Date 30Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *  Last Amend No. 209171             Date 06Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007  *CREATE    Date 11May01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD-23981.                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER016A - German Interest Calculation: Upgarde of FGE059     *
      *            to Midas Plus (Recompile)                          *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CPK025 - add /COPY ZFEB29Z1LE and corrected definition of    *
      *           @@DAYN.                                             *
      *  BUG7033- Increase number of decimal places for work fields   *
      *           used to calculate compound rate to 15               *
      *  226723 - Allow insertion of negative base rates for OIS.     *
      *  221685 - Amending compound rate caused 'COMPOUND' records to *
      *           have zero compound rate. XALIGN needs changing to   *
      *           handle 18 digits. Originally written for 17 digits. *
      *  220859 - Increase the size of Compounding Rate from          *
      *           7 to 15 decimal places. DL1652 was converted to ILE *
      *           due to the change in the number of decimal places.  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CIR013 - Additional Calculation Method for FRA/IRS/CCF       *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CAS008 - IAS 39 Enhancements (Recompile)                     *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  212248 - Extend length of work fields to 14,9 to allow for   *
      *           large rates and/or long term backvaluation.         *
      *  214440 - New function to Amend Applicable Days for all Deals *
      *           (OIS)                                               *
      *  209171 - Error fix for 204923                                *
      *  204923 - Rate Fix Days Adjustment (OIS)                      *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
      *  CIR007 - Overnight Index Swaps                               *
      *                                                               *
      *****************************************************************
      *
      ** Logical file built over DEALSDG
     FDEALS     UF   E           K DISK
     F                                     COMMIT
      *
      ** Logical file built over PF/DLDOISPD  decending
     F***DLDOISL1UF  E           K        DISK                                                214440
     FDLDOISL1  UF A E           K DISK                                                       214440
     F                                     COMMIT
      ** Logical file built over DLDOISPD  ascending                                          214440
     FDLDOISL2  IF   E           K DISK                                                       214440
     F                                     RENAME(DLDOISD0:DLDOISD2)                          214440
      *                                                                                       214440
     FDLOISSL3  IF   E           K DISK                                                       204923
      *
      ** Display file
     FDL1652DF  CF   E             WORKSTN
      *
      *****************************************************************
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D*COPY ZSRSRC,ZDATE2Z1                                                                   220859
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                 220859
     D*COPY ZSRSRC,ZEDITZ1                                                                    220859
     D/COPY ZSRSRC,ZEDITZ1LE                                                                  220859
     D*COPY*ZSRSRC,ZDATE9Z1                                                                   CIR013
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 CIR013
     D/COPY ZSRSRC,ZFEB29Z1LE                                                                 CPK025
     D*XA1*************S              1    DIM(18)                       XALIGN SR. ARR 220859221685
     D*XA2*************S              1    DIM(18)                       XALIGN SR. ARR 220859221685
     D XA1             S              1    DIM(19)                              XALIGN SR. ARR221685
     D XA2             S              1    DIM(19)                              XALIGN SR. ARR221685
      *****************************************************************
      *
     D WCOTX           C                   CONST('COMPOUND RATE')
     D WSTTX           C                   CONST('BASE RATE    ')
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Program Status Data Structure
     D PSDS           SDS
     D  #0PGM            *PROC
     D  #0WSID               244    253
     D  #0USER               254    263
      *
      ** Data Structure to receive Deal details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      *
      ** Data Structure to receive Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Data Structure to receive SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Short data structure for access objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for access programs, long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D*COPY*ZSRSRC,ZDATE9Z2                                                                   CIR013
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 CIR013
     D*COPY*ZSRSRC,ZINTDYZ1                                                                   CIR013
     D/COPY ZSRSRC,ZINTDYZ1LE                                                                 CIR013
      /EJECT
      *****************************************************************
      *                                                               *
      *    M A I N     P R O C E S S I N G                            *
      *                                                               *
      *****************************************************************
      *
      ** Clear screen fields.
      *
     C                   MOVE      *BLANKS       #0PDAT
     C                   MOVE      *BLANKS       #0RTYP
     C                   MOVE      *BLANKS       #0NRAT
     C                   MOVE      *BLANKS       #0CRAT
     C                   MOVE      *BLANKS       #0APDY                                       214440
     C                   MOVE      *BLANK        #0NSGN            1                          226723
     C                   MOVE      *BLANK        #0CSGN            1                          226723
      *
      ** Move fields on file into display file
      *
     C                   MOVEL(P)  KDLNO         WCSSN             6
     C                   MOVE      PSIDE         WSIDE             1
     C                   MOVE      WSIDE         WCNA1             1
     C                   MOVE      AMEND         WCRTN             1
      *
      ** Move passed parameters into display fields
      *
     C                   MOVE      PDLNM         #0DLNO
     C                   MOVE      PSIDE         #0SIDE
     C                   MOVE      *BLANKS       #0PDAT
      *                                                                                       214440
      ** Delete processing                                                                    214440
     C     AMEND         IFEQ      'D'                                                        214440
     C                   EXSR      SRDELT                                                     214440
     C                   ENDIF                                                                214440
      *
      ** If F12 has not been pressed on first screen,
      *
     C     *IN50         DOWEQ     '0'
      *
      ** Display First Screen and validate entries until all valid
      *
     C                   MOVE      'N'           WVAL1             1
     C     WVAL1         DOWEQ     'N'
     C     *IN50         ANDEQ     '0'
     C                   EXSR      SRSCR1
     C     *INKL         IFEQ      '1'
     C                   MOVE      '1'           *IN50
     C                   ENDIF
     C                   MOVE      'Y'           WVAL1
     C                   EXSR      SRVAL1
     C                   ENDDO
      *
      ** Display Second Screen and validate entries until all valid
      *
     C     *IN70         DOWEQ     '0'
     C     *IN50         ANDEQ     '0'
     C                   MOVE      'N'           WVAL2             1
     C     WVAL2         DOWEQ     'N'
     C                   EXSR      SRSCR2
     C     *INKL         IFEQ      '1'
     C                   MOVE      '1'           *IN70
     C                   ENDIF
     C                   MOVE      'Y'           WVAL2
     C                   EXSR      SRVAL2
     C                   ENDDO
      *
      ** Display Second Screen and validate entries until all valid
      *
     C                   MOVE      'N'           WVAL3             1
     C     WVAL3         DOWEQ     'N'
     C     *IN71         ANDEQ     '0'
     C     *IN70         ANDEQ     '0'
     C                   EXSR      SRSCR3
     C     *INKL         IFEQ      '1'
     C                   MOVE      '1'           *IN71
     C                   ENDIF
     C                   MOVE      'Y'           WVAL3
     C                   EXSR      SRVAL3
     C                   ENDDO
      *
      ** F6 must be pressed to update
      *
     C     *INKF         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      SRSCR3
     C                   ENDDO
      *
      ** Previous if F12
      *
     C     *INKL         IFEQ      '1'
     C                   MOVE      '1'           *IN71
     C                   ENDIF
      *
      ** Update if F6
      *
     C     *INKF         IFEQ      '1'
     C                   EXSR      SRUPDP
     C                   EXSR      SRRECA
     C                   MOVE      'Y'           AMEND
     C                   MOVE      '1'           *IN50
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDDO
      *
      ** Termination Processing
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       214440
      *                                                               *                       214440
      *  SRDELT - Delete processing                                   *                       214440
      *                                                               *                       214440
      *  Called by: Main processing                                   *                       214440
      *  Calls    : SRCLRM, SRVAL2                                    *                       214440
      *                                                               *                       214440
      *****************************************************************                       214440
      *                                                                                       214440
     C     SRDELT        BEGSR                                                                214440
      *                                                                                       214440
      ** If F12 has not been pressed on first screen,                                         214440
     C     *IN50         DOWEQ     '0'                                                        214440
      *                                                                                       214440
      ** Display First Screen and validate entries until all valid                            214440
     C                   MOVE      'N'           WVAL1             1                          214440
     C     WVAL1         DOWEQ     'N'                                                        214440
     C     *IN50         ANDEQ     '0'                                                        214440
     C                   EXSR      SRSCR1                                                     214440
     C     *INKL         IFEQ      '1'                                                        214440
     C                   MOVE      '1'           *IN50                                        214440
     C                   ENDIF                                                                214440
     C                   MOVE      'Y'           WVAL1                                        214440
     C                   EXSR      SRVAL1                                                     214440
     C                   ENDDO                                                                214440
      *                                                                                       214440
      ** Display Second Screen                                                                214440
     C     *IN70         DOWEQ     '0'                                                        214440
     C     *IN50         ANDEQ     '0'                                                        214440
     C                   EXSR      SRSCR2                                                     214440
      *                                                                                       214440
      ** F10 must be pressed to delete                                                        214440
     C     *INKJ         DOWEQ     '0'                                                        214440
     C     *INKL         ANDEQ     '0'                                                        214440
     C                   EXSR      SRSCR2                                                     214440
     C                   ENDDO                                                                214440
      *                                                                                       214440
      ** Previous if F12                                                                      214440
     C     *INKL         IFEQ      '1'                                                        214440
     C                   MOVE      '1'           *IN70                                        214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
      ** Update if F10                                                                        214440
     C     *INKJ         IFEQ      '1'                                                        214440
     C                   DELETE    DLDOISD0                                                   214440
      *                                                                                       214440
     C     KPRVK         SETLL     DLDOISL1                             51                    214440
     C                   READP     DLDOISL1                               51                  214440
     C                   Z-ADD     L1BSDT        WDYNO                                        214440
      *                                                                                       214440
     C                   EXSR      SRUPDP                                                     214440
     C                   EXSR      SRRECA                                                     214440
     C                   MOVE      'Y'           AMEND                                        214440
     C                   MOVE      '1'           *IN50                                        214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
     C                   ENDDO                                                                214440
      *                                                                                       214440
     C                   ENDDO                                                                214440
      *                                                                                       214440
      ** Termination Processing                                                               214440
     C                   MOVE      '1'           *INLR                                        214440
     C                   RETURN                                                               214440
      *                                                                                       214440
     C                   ENDSR                                                                214440
      *                                                                                       214440
      *****************************************************************                       214440
      /EJECT                                                                                  214440
      *****************************************************************
      *                                                               *
      *  SRSCR1 - Validate second screen                              *
      *                                                               *
      *  Called by: Main routine                                      *
      *                                                               *
      *  Calls    : SRCLRM, SRVAL2                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRSCR1        BEGSR
      *
     C     AMEND         IFEQ      'I'                                                        214440
     C                   MOVE      '1'           *IN30                                        214440
     C                   ELSE                                                                 214440
     C     AMEND         IFEQ      'D'                                                        214440
     C                   MOVE      '1'           *IN31                                        214440
     C                   ELSE                                                                 214440
     C                   MOVE      '0'           *IN30                                        214440
     C                   MOVE      '0'           *IN31                                        214440
     C                   ENDIF                                                                214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
     C                   MOVE      '0'           *IN06
     C                   MOVE      '0'           *IN10                                        214440
     C                   MOVE      '0'           *IN40
     C                   MOVE      '1'           *IN42
     C                   MOVE      '1'           *IN44
     C                   MOVE      '1'           *IN47                                        226723
     C                   MOVE      '1'           *IN48                                        226723
     C                   MOVE      '0'           *IN60
     C                   MOVE      '0'           *IN70
     C                   MOVE      '0'           *IN80
     C                   MOVE      *BLANKS       #0RTYP
     C                   MOVE      *BLANKS       #0NRAT
     C                   MOVE      *BLANKS       #0CRAT
     C                   MOVE      *BLANKS       #0APDY                                       214440
     C                   MOVE      *BLANK        #0NSGN                                       226723
     C                   MOVE      *BLANK        #0CSGN                                       226723
      *
      ** Write Screen and Read response
      *
     C                   WRITE     DL1652F1
     C                   WRITE     DL1652C0
     C                   EXFMT     DL1652F0
      *
      ** Clear Message Subfile
      *
     C                   EXSR      SRCLRM
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCR2 - Validate second screen                              *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls    : SRCLRM, SRVAL2                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRSCR2        BEGSR
      *
      ** Display Literals and Function Keys
      *
     C                   MOVE      '0'           *IN06
     C                   MOVE      '1'           *IN40
     C                   MOVE      '0'           *IN41
     C                   MOVE      '1'           *IN60
     C                   MOVE      '0'           *IN71
      *
     C     L1RTYP        IFEQ      'COMPOUND'
     C                   MOVE      WCOTX         #0RTYP
     C**********         MOVE      L1CPRT        LCEDRT           13 9                        220859
     C**********         MOVE      LCEDRT        ZFIELD                                       220859
     C**********         Z-ADD     9             ZADEC                                        220859
     C**********         EXSR      ZEDIT                                                      220859
     C**********         MOVE      ZFIELD        #0CRAT                                       220859
     C                   MOVE      L1CPRT        LCEDRT           1815                        220859
      *                                                                                       226723
      ** Change the sign to positive prior to display.                                        226723
      *                                                                                       226723
     C     LCEDRT        IFLT      0                                                          226723
     C                   Z-SUB     LCEDRT        LCEDRT                                       226723
     C                   ENDIF                                                                226723
      *                                                                                       226723
     C                   MOVE      LCEDRT        XFIELD                                       220859
     C                   Z-ADD     3             XADIG                                        220859
     C                   Z-ADD     15            XADEC                                        220859
     C                   EXSR      XEDIT                                                      220859
     C                   MOVE      XFIELD        #0CRAT                                       220859
      *                                                                                       226723
      ** Display the appropriate sign if the rate is negative.                                226723
      *                                                                                       226723
     C     L1CPRT        IFLT      0                                                          226723
     C                   MOVE      '-'           #0CSGN                                       226723
     C                   ELSE                                                                 226723
     C                   MOVE      '+'           #0CSGN                                       226723
     C                   ENDIF                                                                226723
      *                                                                                       220859
     C                   MOVE      '1'           *IN80
     C                   MOVE      '1'           *IN42
     C                   MOVE      '0'           *IN44
     C                   MOVE      '1'           *IN47                                        226723
     C                   MOVE      '0'           *IN48                                        226723
     C                   ELSE
     C                   MOVE      WSTTX         #0RTYP
     C                   MOVE      L1BSRT        LBEDRT           11 7
      *                                                                                       226723
      ** Change the sign to positive prior to display.                                        226723
      *                                                                                       226723
     C     LBEDRT        IFLT      0                                                          226723
     C                   Z-SUB     LBEDRT        LBEDRT                                       226723
     C                   ENDIF                                                                226723
      *                                                                                       226723
     C                   MOVE      LBEDRT        ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        #0NRAT
      *                                                                                       226723
      ** Display the appropriate sign if the rate is negative.                                226723
      *                                                                                       226723
     C     L1BSRT        IFLT      0                                                          226723
     C                   MOVE      '-'           #0NSGN                                       226723
     C                   ELSE                                                                 226723
     C                   MOVE      '+'           #0NSGN                                       226723
     C                   ENDIF                                                                226723
      *                                                                                       226723
     C                   MOVE      '0'           *IN80
     C                   MOVE      '0'           *IN42
     C                   MOVE      '1'           *IN44
     C                   MOVE      '0'           *IN47                                        226723
     C                   MOVE      '1'           *IN48                                        226723
     C                   ENDIF
      *                                                                                       214440
      ** Display Applicable Days                                                              214440
     C                   SETOFF                                       45                      214440
     C                   Z-ADD     0             ZADEC                                        214440
     C                   MOVE(P)   L1APDY        ZFIELD                                       214440
     C                   EXSR      ZEDIT                                                      214440
     C                   MOVE      ZFIELD        #0APDY                                       214440
      *
      ** Call ZEDIT for fields where decimal places depend on deal
      ** currency
      *                                                                                       214440
      ** Display Literals and Function Keys for delete mode                                   214440
     C     AMEND         IFEQ      'D'                                                        214440
     C                   MOVE      '0'           *IN06                                        214440
     C                   MOVE      '1'           *IN10                                        214440
     C                   MOVE      '1'           *IN40                                        214440
     C                   MOVE      '1'           *IN42                                        214440
     C                   MOVE      '1'           *IN44                                        214440
     C                   MOVE      '1'           *IN45                                        214440
     C                   MOVE      '1'           *IN60                                        214440
     C                   MOVE      '1'           *IN47                                        226723
     C                   MOVE      '1'           *IN48                                        226723
     C                   ENDIF                                                                214440
      *
     C                   WRITE     DL1652F1
     C                   WRITE     DL1652C0
     C                   EXFMT     DL1652F0
      *
      **  Clear Message Subfile
      *
     C                   EXSR      SRCLRM
      *                                                                                       214440
     C                   MOVE      '0'           *IN43                                        214440
     C                   MOVE      '0'           *IN46                                        214440
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCR3  -  Validate third screen                             *
      *                                                               *
      *  Called by: Main routine                                      *
      *                                                               *
      *  Calls    : SRCLRM, ZASNMS, SRSCR2, SRUPDP, SRRECA            *
      *                                                               *
      *****************************************************************
      *
     C     SRSCR3        BEGSR
      *
      ** Display Literals and Function Keys
      *
     C                   MOVE      '1'           *IN06
     C                   MOVE      '1'           *IN40
     C                   MOVE      '1'           *IN42
     C                   MOVE      '0'           *IN43                                        214440
     C                   MOVE      '1'           *IN44
     C                   MOVE      '1'           *IN45                                        214440
     C                   MOVE      '0'           *IN46                                        214440
     C                   MOVE      '1'           *IN60
     C                   MOVE      '1'           *IN47                                        226723
     C                   MOVE      '1'           *IN48                                        226723
      *
      ** Write Screen and Read response
      *
     C                   WRITE     DL1652F1
     C                   WRITE     DL1652C0
     C                   EXFMT     DL1652F0
      *
      **  Clear Message Subfile
      *
     C                   EXSR      SRCLRM
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL1 - Validate Deal Number, Our/Their Side and            *
      *           Position to Date                                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : ZASNMS, ZDATE1                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRVAL1        BEGSR
      *
     C                   MOVE      'N'           WJUMP             1
      *
      ** Validate Date
      *
     C     #0PDAT        IFEQ      *BLANK
      *
      ** Send message 'Date Must be entered'
      *
     C                   MOVEL     'MMA1202'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN41
     C                   MOVE      'N'           WVAL1                          Invalid Date
     C                   MOVE      'Y'           WJUMP
      *
     C                   ELSE
      *
     C                   MOVE      #0PDAT        ZDATE
     C                   EXSR      ZDATE1
     C                   MOVE      ZDAYNO        WDYNO             5 0
      *
      ** Send message 'Invalid Date'
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'MMA1203'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN41
     C                   MOVE      'N'           WVAL1                          Invalid Date
     C                   MOVE      'Y'           WJUMP
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check if records are present on PF/DLDOISPD for the deal
      ** and side specified.
      *
     C     WJUMP         IFEQ      'N'
      *                                                                                       204923
     C     KDLNO         CHAIN     DEALSDGF                           52                      204923
      *                                                                                       204923
     C     *IN52         IFEQ      '1'                                                        204923
     C     *LOCK         IN        LDA                                                        204923
     C                   MOVEL     'DEALSDG'     DBFILE                                       204923
     C                   Z-ADD     1             DBASE                                        204923
     C                   MOVEL(P)  KDLNO         DBKEY                                        204923
     C                   OUT       LDA                                                        204923
     C                   EXSR      *PSSR                                                      204923
     C                   ENDIF                                                                204923
      *
     C     KPRVK         CHAIN     DLDOISD0                           51
      *                                                                                       204923
     C     *IN51         IFEQ      '0'                                                        204923
     C     FXDY1         ANDNE     0                                                          204923
     C     L1BSDT        ANDGE     PDATE                                                      204923
      *                                                                                       204923
     C     L1DLNO        CHAIN     DLOISSL3                           51                      204923
     C     *IN51         IFEQ      '0'                                                        204923
     C     L5RFIN        ANDNE     'Y'                                                        204923
      *                                                                                       204923
     C     *IN51         OREQ      '0'                                                        204923
     C     L5RFIN        ANDEQ     'Y'                                                        204923
     C     PSIDE         ANDEQ     'O'                                                        204923
     C     UNIPD         ANDNE     PDATE                                                      204923
      *                                                                                       204923
     C     *IN51         OREQ      '0'                                                        204923
     C     L5RFIN        ANDEQ     'Y'                                                        204923
     C     PSIDE         ANDEQ     'T'                                                        204923
     C     TNIPD         ANDNE     PDATE                                                      204923
     C                   MOVE      '1'           *IN51                                        204923
     C                   ENDIF                                                                204923
     C                   ENDIF                                                                204923
      *
      ** Send message 'Record for date DDMMYY not on file'.
      ** if not in Insert mode.                                                               214440
      *
     C     *IN51         IFEQ      '1'
     C     AMEND         ANDNE     'I'                                                        214440
     C                   MOVEL     'MMA1204'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN41
     C                   MOVE      'N'           WVAL1                          Invalid Deal
     C                   MOVE      'Y'           WJUMP
     C                   ENDIF
      *                                                                                       214440
      ** Send message 'Date has to be less than Run Date',                                    214440
      ** if in Insert mode and Date entered is greater than Rundate.                          214440
     C     AMEND         IFEQ      'I'                                                        214440
     C     WDYNO         ANDGE     BJRDNB                                                     214440
     C                   MOVEL     'MMA1255'     ZAMSID                                       214440
     C                   EXSR      ZASNMS                                                     214440
     C                   MOVE      '1'           *IN41                                        214440
     C                   MOVE      'N'           WVAL1                          Invalid Deal  214440
     C                   MOVE      'Y'           WJUMP                                        214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
      ** Send message 'Record for this date already exists',                                  214440
      ** if in Insert mode.                                                                   214440
     C     *IN51         IFEQ      '0'                                                        214440
     C     AMEND         ANDEQ     'I'                                                        214440
     C                   MOVEL     'MMA1258'     ZAMSID                                       214440
     C                   EXSR      ZASNMS                                                     214440
     C                   MOVE      '1'           *IN41                                        214440
     C                   MOVE      'N'           WVAL1                          Invalid Deal  214440
     C                   MOVE      'Y'           WJUMP                                        214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
      ** Send message 'Today's Record can not be Deleted',                                    214440
      ** if in Delete mode and Date entered equals Rundate.                                   214440
     C     *IN51         IFEQ      '0'                                                        214440
     C     AMEND         ANDEQ     'D'                                                        214440
     C     WDYNO         ANDEQ     BJRDNB                                                     214440
     C                   MOVEL     'MMA1259'     ZAMSID                                       214440
     C                   EXSR      ZASNMS                                                     214440
     C                   MOVE      '1'           *IN41                                        214440
     C                   MOVE      'N'           WVAL1                          Invalid Deal  214440
     C                   MOVE      'Y'           WJUMP                                        214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
      ** Send message 'Int. Amount Records can not be Deleted',                               214440
      ** if in Delete mode and Date entered has an Interest Amount.                           214440
     C     *IN51         IFEQ      '0'                                                        214440
     C     AMEND         ANDEQ     'D'                                                        214440
     C     L1AMNT        ANDNE     *ZERO                                                      214440
     C                   MOVEL     'MMA1262'     ZAMSID                                       214440
     C                   EXSR      ZASNMS                                                     214440
     C                   MOVE      '1'           *IN41                                        214440
     C                   MOVE      'N'           WVAL1                          Invalid Deal  214440
     C                   MOVE      'Y'           WJUMP                                        214440
     C                   ENDIF                                                                214440
      *
      ** Read the PF/DDEALDG for the deal
      *
     C     WJUMP         IFEQ      'N'
      *
     C********** KDLNO     CHAINDEALSDGF             52                                       204923
      *
     C********** *IN52     IFEQ '1'                                                           204923
     C********** *LOCK     IN   LDA                                                           204923
     C**********           MOVEL'DEALSDG' DBFILE                                              204923
     C**********           Z-ADD1         DBASE                                               204923
     C**********           MOVELKDLNO     DBKEY     P                                         204923
     C**********           OUT  LDA                                                           204923
     C**********           EXSR *PSSR                                                         204923
     C**********           ENDIF                                                              204923
      *
      ** If the Side is ours and the date entered is before the last
      ** Interest Payment Date then display error message.
      ** Send message 'Interest Period is closed'.
      *
     C     PSIDE         IFEQ      'O'
     C     WDYNO         IFLT      USLIP
     C                   MOVEL     'MMA1205'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN41
     C                   MOVE      'N'           WVAL1                          Invalid Side
     C                   ENDIF
     C                   ENDIF
      *
      ** If the Side is theirs and the date entered is before the last
      ** Interest Payment Date then display error message.
      ** Send message 'Interest Period is closed'.
      *
     C     PSIDE         IFEQ      'T'
     C     WDYNO         IFLT      TSLIP
     C                   MOVEL     'MMA1205'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN41
     C                   MOVE      'N'           WVAL1                          Invalid Side
     C                   ENDIF
     C                   ENDIF
      *
      ** If the 'Record Type Field' is set to 'GUESS' then write error
      ** message.
      ** Send message ''Guess' records cannot have their rates changed'
      *
     C     L1RTYP        IFEQ      'GUESS'
     C                   MOVEL     'MMA1206'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN41
     C                   MOVE      'N'           WVAL1
     C                   ENDIF
      *                                                                                       214440
      ** If Insert mode then read the previous record for details of                          214440
      ** new record to be inserted.                                                           214440
     C     AMEND         IFEQ      'I'                                                        214440
     C     KPRVK         SETLL     DLDOISL1                             51                    214440
     C                   READ      DLDOISL1                               51                  214440
     C                   ENDIF                                                                214440
      *
     C     *INKL         IFEQ      '1'
     C                   MOVE      '1'           *IN50
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL2 - Validate Deal Number, Our/Their Side and            *
      *           Position to Date                                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : ZASNMS, ZDATE1                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRVAL2        BEGSR
      *
      ** Move screen fields into work fields.
      *
     C                   MOVEL     #0DLNO        WDLNO             6
     C                   MOVEL     #0SIDE        PSIDE             1
     C                   MOVEL     #0PDAT        WPDAT             6
      *
     C     L1RTYP        IFEQ      'COMPOUND'
     C**********         Z-ADD     9             ZADEC                                        220859
     C**********         MOVE      LCEDRT        ZFIELD                                       220859
     C**********         EXSR      ZEDIT                                                      220859
     C**********         MOVE(P)   ZFIELD        WCRT             13                          220859
     C                   Z-ADD     3             XADIG                                        220859
     C                   Z-ADD     15            XADEC                                        220859
     C                   MOVE      LCEDRT        XFIELD                                       220859
     C                   EXSR      XEDIT                                                      220859
     C                   MOVE(P)   XFIELD        WCRT             19                          220859
     C                   ELSE
     C                   Z-ADD     7             ZADEC
     C                   MOVE      LBEDRT        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE(P)   ZFIELD        WBSRT            11
     C                   ENDIF
      ** Applicable Days                                                                      214440
     C                   Z-ADD     0             ZADEC                                        214440
     C                   MOVE(P)   L1APDY        ZFIELD                                       214440
     C                   EXSR      ZEDIT                                                      214440
     C                   MOVE      ZFIELD        WAPDY             3                          214440
      *
      ** If the value in the New Rate Field is different to that held
      ** on the file DLDOISPD, then validate it else redisplay screen.
      *
     C                   MOVE      'Y'           WVAL2
      *
     C     L1RTYP        IFEQ      'COMPOUND'
     C     #0CRAT        IFNE      WCRT
     C***********        MOVE(P)   #0CRAT        ZFIELD                                       220859
     C***********        Z-ADD     3             ZADIG                                        220859
     C***********        Z-ADD     9             ZADEC                                        220859
     C***********        EXSR      ZALIGN                                                     220859
     C***********        Z-ADD     9             ZADEC                                        220859
     C***********        EXSR      ZEDIT                                                      220859
     C***********        MOVE      ZFIELD        #0CRAT                                       220859
     C                   MOVE(P)   #0CRAT        XFIELD                                       220859
     C                   Z-ADD     3             XADIG                                        220859
     C                   Z-ADD     15            XADEC                                        220859
     C                   EXSR      XALIGN                                                     220859
     C                   Z-ADD     15            XADEC                                        220859
     C                   EXSR      XEDIT                                                      220859
     C                   MOVE      XFIELD        #0CRAT                                       220859
     C                   ENDIF
      *
      ** Validate the sign field                                                              226723
      *                                                                                       226723
     C     #0CSGN        IFEQ      ' '                                                        226723
     C                   MOVE      '+'           #0CSGN                                       226723
     C                   ENDIF                                                                226723
      *                                                                                       226723
     C     #0CSGN        IFNE      '+'                                                        226723
     C     #0CSGN        ANDNE     '-'                                                        226723
     C                   MOVEL     'MMA0035'     ZAMSID                                       226723
     C                   EXSR      ZASNMS                                                     226723
     C                   MOVE      '1'           *IN43                                        226723
     C                   MOVE      'N'           WVAL2                                        226723
     C                   ENDIF                                                                226723
     C                   ELSE
      *
     C     #0NRAT        IFNE      WBSRT
     C                   MOVE(P)   #0NRAT        ZFIELD
     C                   Z-ADD     3             ZADIG
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZALIGN
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        #0NRAT
     C                   ENDIF
     C                   ENDIF
      *                                                                                       226723
      ** Validate the sign field.                                                             226723
      *                                                                                       226723
     C     #0NSGN        IFEQ      ' '                                                        226723
     C                   MOVE      '+'           #0NSGN                                       226723
     C                   ENDIF                                                                226723
      *                                                                                       226723
     C     #0NSGN        IFNE      '+'                                                        226723
     C     #0NSGN        ANDNE     '-'                                                        226723
     C                   MOVEL     'MMA0035'     ZAMSID                                       226723
     C                   EXSR      ZASNMS                                                     226723
     C                   MOVE      '1'           *IN43                                        226723
     C                   MOVE      'N'           WVAL2                                        226723
     C                   ENDIF                                                                226723
      *
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'MMA1207'     ZAMSID
     C                   MOVE      '0'           *IN99
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN43                                        214440
     C                   MOVE      'N'           WVAL2
     C                   ENDIF
      *                                                                                       214440
      ** If the value in the App Days Field is different to that held                         214440
      ** on the file DLDOISPD, then validate it else redisplay screen.                        214440
     C     #0APDY        IFNE      WAPDY                                                      214440
     C                   Z-ADD     3             ZADIG                                        214440
     C                   Z-ADD     0             ZADEC                                        214440
     C                   MOVE(P)   #0APDY        ZFIELD                                       214440
     C                   EXSR      ZALIGN                                                     214440
     C                   EXSR      ZEDIT                                                      214440
     C                   MOVE      ZFIELD        #0APDY                                       214440
      *                                                                                       214440
     C     *IN99         IFEQ      *ON                                                        214440
     C     #0APDY        OREQ      '  0'                                                      214440
     C                   MOVEL     'MMA1260'     ZAMSID                                       214440
     C                   EXSR      ZASNMS                                                     214440
     C                   MOVE      '1'           *IN46                                        214440
     C                   MOVE      'N'           WVAL2                                        214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
     C                   ENDIF                                                                214440
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL3 - Validate Deal Number, Our/Their Side and            *
      *           Position to Date                                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : ZASNMS, ZDATE1                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRVAL3        BEGSR
      *
      ** Move screen fields into work fields.
      *
     C                   MOVEL     #0DLNO        WDLNO
     C                   MOVEL     #0SIDE        PSIDE
     C                   MOVEL     #0PDAT        WPDAT
      *
      ** Move the new rate field into a numeric field
      *
     C     L1RTYP        IFEQ      'COMPOUND'
     C**********         MOVE(P)   #0CRAT        ZFIELD                                       220859
     C**********         Z-ADD     3             ZADIG                                        220859
     C**********         Z-ADD     9             ZADEC                                        220859
     C**********         EXSR      ZALIGN                                                     220859
     C**********           MOVE ZFIELD    LCNRAT 129                                          212248
     C**********           MOVE ZFIELD    LCNRAT 149                                   212248 220859
     C                   MOVE(P)   #0CRAT        XFIELD                                       220859
     C                   Z-ADD     3             XADIG                                        220859
     C                   Z-ADD     15            XADEC                                        220859
     C                   EXSR      XALIGN                                                     220859
     C                   MOVE      XFIELD        LCNRAT           1815                        220859
      *                                                                                       226723
      ** Negate the rate if the sign field is negative.                                       226723
      *                                                                                       226723
     C     #0CSGN        IFEQ      '-'                                                        226723
     C                   Z-SUB     LCNRAT        LCNRAT                                       226723
     C                   ENDIF                                                                226723
      *                                                                                       226723
     C                   ELSE
     C                   MOVE(P)   #0NRAT        ZFIELD
     C                   Z-ADD     3             ZADIG
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        LBNRAT           10 7
      *                                                                                       226723
      ** Negate the rate if the sign field is negative.                                       226723
      *                                                                                       226723
     C     #0NSGN        IFEQ      '-'                                                        226723
     C                   Z-SUB     LBNRAT        LBNRAT                                       226723
     C                   ENDIF                                                                226723
      *                                                                                       226723
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDP - Update previous records                             *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRUPDP        BEGSR
      *
     C     AMEND         IFNE      'D'                                                        214440
      *                                                                                       214440
     C     L1RTYP        IFEQ      'COMPOUND'
     C                   Z-ADD     LCNRAT        L1CPRT
     C                   ELSE
     C                   Z-ADD     LBNRAT        L1BSRT
     C                   ENDIF
     C                   MOVE      #0APDY        L1APDY                                       214440
      *                                                                                       214440
     C     AMEND         IFEQ      'I'                                                        214440
     C                   Z-ADD     WDYNO         L1BSDT                                       214440
     C                   WRITE     DLDOISD0                                                   214440
      *                                                                                       214440
     C                   ELSE                                                                 214440
     C                   UPDATE    DLDOISD0
     C                   ENDIF                                                                214440
      *                                                                                       214440
     C                   ENDIF                                                                214440
      *
      ** Save values of deal and side being processed. Used to test and
      ** exit from this processing loop.
      *
     C                   Z-ADD     L1DLNO        WDNUM             6 0
     C                   MOVEL     L1OTCD        WOTCD             1
      *
      ** Save compounding rate from previous record.
      *
     C     KPRVK         CHAIN     DLDOISL1                           89
     C     *IN89         DOWEQ     *OFF
      *
      ** Position to the last record updated.
      *
     C     L1RTYP        IFEQ      'COMPOUND'
     C**********           Z-ADDL1CPRT    WCPRT  129                                          212248
     C**********           Z-ADDL1INRT    WINRT  129                                          212248
     C**********         Z-ADD     L1CPRT        WCPRT            14 9                 212248 220859
     C                   Z-ADD     L1CPRT        WCPRT            2015                        220859
     C                   Z-ADD     L1INRT        WINRT            14 9                        212248
     C                   ELSE
     C                   READ      DLDOISL1                               89
     C                   Z-ADD     L1CPRT        WCPRT
     C                   Z-ADD     L1INRT        WINRT
     C                   READP     DLDOISL1                               89
     C                   ENDIF
      *
      ** If the record changed was a COMPOUND record, then we do not
      ** want to recalculate the interest rate field for it. We start
      ** changeing records from the one immediately after the COMPOUND
      ** record.
      *
     C     L1RTYP        IFNE      'COMPOUND'
      *
      ** Calculate the new componding rate and interest rate for each
      ** of the following records for this deal.
      ** Apply spread to the old base rate on the deal
      *
     C                   Z-ADD     L1BSRT        WRATE            11 7
      *
      ** Spread for Our side.
      *
     C     L1OTCD        IFEQ      'O'
      *
     C     USPIN         IFEQ      'A'
     C     L1BSRT        ADD       URTSP         WRATE
     C                   ENDIF
      *
     C     USPIN         IFEQ      'S'
     C     L1BSRT        SUB       URTSP         WRATE
     C                   ENDIF
      *
     C     USPIN         IFEQ      'P'
     C     L1BSRT        MULT      URTSP         WORK             11 7
     C     WORK          DIV       100           WORK
     C     L1BSRT        ADD       WORK          WRATE
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Spread for Their side
      *
     C     TSPIN         IFEQ      'A'
     C     L1BSRT        ADD       TRTSP         WRATE
     C                   ENDIF
      *
     C     TSPIN         IFEQ      'S'
     C     L1BSRT        SUB       TRTSP         WRATE
     C                   ENDIF
      *
     C     TSPIN         IFEQ      'P'
     C     L1BSRT        MULT      TRTSP         WORK             11 7
     C     WORK          DIV       100           WORK
     C     L1BSRT        ADD       WORK          WRATE
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Multiply the adjusted rate by the number of applicable days
      ** on the deals extension file.
      *
     C********** WRATE     MULT L1APDY    WRESA  129H                                         212248
     C*****WRATE         MULT(H)   L1APDY        WRESA            14 9                212248 BUG7033
     C     WRATE         MULT(H)   L1APDY        WRESA            2015                       BUG7033
      *                                                                                       CIR013
     C     L1OTCD        IFEQ      'O'                                                        CIR013
     C     UICBS         ANDEQ     9                                                          CIR013
     C     L1OTCD        ORNE      'O'                                                        CIR013
     C     TICBS         ANDEQ     9                                                          CIR013
      *                                                                                       CIR013
     C     L1OTCD        IFEQ      'O'                                                        CIR013
      * Our Last Interest Payment Date                                                        CIR013
     C                   Z-ADD     USLIP         @@DAYN            5 0                        CIR013
     C                   ELSE                                                                 CIR013
      * Their Last Interest Payment Date                                                      CIR013
     C                   Z-ADD     TSLIP         @@DAYN                                       CIR013
     C                   ENDIF                                                                CIR013
      *                                                                                       CIR013
      * Convert start date to YYYYMMDD format                                                 CIR013
     C                   EXSR      ZDATE9                                                     CIR013
     C                   Z-ADD     @@VDT         ZZDATA                                       CIR013
      *                                                                                       CIR013
      * Convert end date to YYYYMMDD format                                                   CIR013
     C                   Z-ADD     L1BSDT        @@DAYN                                       CIR013
     C                   EXSR      ZDATE9                                                     CIR013
     C                   Z-ADD     @@VDT         ZZDATB                                       CIR013
      *                                                                                       CIR013
      * Check for the existence of any February 29th within the dates                         CIR013
     C                   EXSR      #FEB29                                                     CIR013
     C                   ENDIF                                                                CIR013
      *
      ** Divide by Our/Their Calculation Basis
      *
     C     L1OTCD        IFEQ      'O'
      *
     C     UICBS         IFEQ      1
     C     UICBS         OREQ      4
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C********** WRESA     DIV  36500     WRESB  129H                                         212248
     C*****WRESA         DIV(H)    36500         WRESB            14 9                212248 BUG7033
     C     WRESA         DIV(H)    36500         WRESB            2015                       BUG7033
     C                   ENDIF
      *
     C     UICBS         IFEQ      2
     C     UICBS         OREQ      3
     C     UICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     UICBS         ANDEQ     7
     C     WRESA         DIV(H)    36000         WRESB
     C                   ENDIF
      *
     C     UICBS         IFEQ      6
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WRESA         DIV(H)    36600         WRESB
     C                   ENDIF
      *
     C                   ELSE
      *
     C     TICBS         IFEQ      1
     C     TICBS         OREQ      4
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C     WRESA         DIV(H)    36500         WRESB
     C                   ENDIF
      *
     C     TICBS         IFEQ      2
     C     TICBS         OREQ      3
     C     TICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     TICBS         ANDEQ     7
     C     WRESA         DIV(H)    36000         WRESB
     C                   ENDIF
      *
     C     TICBS         IFEQ      6
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WRESA         DIV(H)    36600         WRESB
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Add 1 to the result.
      *
     C********** WRESB     ADD  1         WRESC  129                                          212248
     C*****WRESB         ADD       1             WRESC            14 9                212248 BUG7033
     C     WRESB         ADD       1             WRESC            2015                       BUG7033
      *
      ** Multiply the result by the compounding rate from the previous
      ** record to get this records compounding rate.
      *
     C********** WRESC     MULT WCPRT     WRESD  129H                                         212248
     C*****WRESC         MULT(H)   WCPRT         WRESD            14 9                 212248 220859
     C     WRESC         MULT(H)   WCPRT         WRESD            2015                        220859
     C                   Z-ADD(H)  WRESD         L1CPRT
      *
      ** Subtract one from the result.
      *
     C********** WRESD     SUB  1         WRESE  129                                          212248
     C*****WRESD         SUB       1             WRESE            14 9                 212248 220859
     C     WRESD         SUB       1             WRESE            2015                        220859
      *
      ** Multiply by Our/Their Calculation Basis
      *
     C     L1OTCD        IFEQ      'O'
      *
     C     UICBS         IFEQ      1
     C     UICBS         OREQ      4
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C********** WRESE     MULT 36500     WRESF  129H                                         212248
     C*****WRESE         MULT(H)   36500         WRESF            14 9                 212248 220859
     C     WRESE         MULT(H)   36500         WRESF            2015                        220859
     C                   ENDIF
      *
     C     UICBS         IFEQ      2
     C     UICBS         OREQ      3
     C     UICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     UICBS         ANDEQ     7
     C     WRESE         MULT(H)   36000         WRESF
     C                   ENDIF
      *
     C     UICBS         IFEQ      6
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WRESE         MULT(H)   36600         WRESF
     C                   ENDIF
      *
     C                   ELSE
      *
     C     TICBS         IFEQ      1
     C     TICBS         OREQ      4
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C     WRESE         MULT(H)   36500         WRESF
     C                   ENDIF
      *
     C     TICBS         IFEQ      2
     C     TICBS         OREQ      3
     C     TICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     TICBS         ANDEQ     7
     C     WRESE         MULT(H)   36000         WRESF
     C                   ENDIF
      *
     C     TICBS         IFEQ      6
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WRESE         MULT(H)   36600         WRESF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Find number of days since last payment.
      *
     C     L1OTCD        IFEQ      'O'
     C     L1BSDT        SUB       USLIP         WNUMD             3 0
     C                   ELSE
     C     L1BSDT        SUB       TSLIP         WNUMD
     C                   ENDIF
      *
      ** Divide the result by the number of days since last interest
      ** payment date.
      *
     C********** WRESF     DIV  WNUMD     WRESG  129H                                         212248
     C*****WRESF         DIV(H)    WNUMD         WRESG            14 9                 212248 220859
     C     WRESF         DIV(H)    WNUMD         WRESG            2015                        220859
      *
      ** Update the extension file with this compound rate and interest
      ** rate.
      *
     C                   Z-ADD(H)  WRESG         L1INRT
     C                   UPDATE    DLDOISD0
      *
     C                   ENDIF
      *
     C                   READP     DLDOISL1                               89
      *
      ** Exit the loop when all records for the deal and side have been
      ** processed.
      *
     C     L1DLNO        IFNE      WDNUM
     C     L1OTCD        ORNE      WOTCD
     C                   MOVE      *ON           *IN89
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRECA - Recalculate interest amount due                     *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRRECA        BEGSR
      *
      ** Position to the last record on the file for the deal and side
      ** being amended.
      *
     C     KKLNO         SETLL     DLDOISL1                             89
     C                   READ      DLDOISL1                               89
      *
      ** Set the From Date to be either USLIP if Ours of TSLIP if Theirs.
      *
     C     WSIDE         IFEQ      'O'
     C                   Z-ADD     USLIP         PFDTE
     C                   ELSE
     C                   Z-ADD     TSLIP         PFDTE
     C                   ENDIF
      *
      ** If a settlement record then interest amount due needs recalculated
      ** Call program DL1664 to calculate the base amount of interest due
      *
     C                   Z-ADD     *ZERO         PINTA                                        214440
     C     L1RTYP        IFEQ      'SETTLE'
     C                   CALL      'DL1664'
     C                   PARM      KDLNO         PDEAL             6 0
     C                   PARM      WSIDE         PSIDE             1
     C                   PARM      PFDTE         PFDTE             5 0
     C**********         PARM      BJRDNB        PRDNB             5 0                        209171
     C                   PARM      L1BSDT        PRDNB             5 0                        209171
     C                   PARM      *ZERO         PINTA            13 0
     C                   PARM      *BLANKS       PRTCD
      *
     C     WSIDE         IFEQ      'O'
     C                   ADD       UAIAN         PINTA
     C                   ADD       UAIAP         PINTA
     C                   ELSE
     C                   ADD       TAIAN         PINTA
     C                   ADD       TAIAP         PINTA
     C                   ENDIF
      *
      ** SETTLE records are also GUESS records for a succeeding interest
      ** period, so the compounding rate field must be set to 1.0.
      *
     C                   Z-ADD     1             L1CPRT
      *
      ** If the side is ours, the tax rate is not zero and the taxable
      ** indicator on the deal is 'Y' multiply the tax rate by the
      ** interest amount calculated above
      *
     C     WSIDE         IFEQ      'O'
     C     TAXR          ANDNE     *ZERO
     C     TAXI          ANDEQ     'Y'
     C     TAXR          MULT(H)   PINTA         WRKTAX           15 0
      *
      ** Subtract the result from the interest amount.
      *
     C     PINTA         SUB       WRKTAX        PINTA
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     PINTA         L1AMNT
      *
      ** Update OIS Compouding history file.
      *
     C                   UPDATE    DLDOISD0
      *
      ** Update DEALSDG
      *
     C     WSIDE         IFEQ      'O'
     C                   Z-ADD     L1INRT        UEINR
     C                   ELSE
     C                   Z-ADD     L1INRT        TEINR
     C                   ENDIF
      *
     C                   UPDATE    DEALSDGF
     C                   COMMIT
      *
      ** Count number of Applicable Days for Deal.                                            214440
     C                   Z-ADD     0             WDYNO                                        214440
     C                   Z-ADD     0             WTOTAL            5 0                        214440
     C                   MOVE      'Y'           WPASS             1                          214440
      *                                                                                       214440
     C     KPRVK         SETLL     DLDOISD2                                                   214440
     C     KKLNO         READE     DLDOISD2                               89                  214440
     C                   Z-ADD     L1BSDT        WSTRDT            5 0                        214440
     C     *IN89         DOWEQ     '0'                                                        214440
      *                                                                                       214440
      ** Don't count the Applicable Day of the first record.                                  214440
     C     WPASS         IFEQ      'N'                                                        214440
     C     L1APDY        ADD       WTOTAL        WTOTAL                                       214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
     C                   MOVE      'N'           WPASS                                        214440
     C     KKLNO         READE     DLDOISD2                               89                  214440
     C                   ENDDO                                                                214440
      *                                                                                       214440
     C                   Z-ADD     L1BSDT        WENDDT            5 0                        214440
      *                                                                                       214440
      ** Check if total matches number of days.                                               214440
     C                   MOVE      'Y'           PAPPD                                        214440
     C     WENDDT        SUB       WSTRDT        WDAYS             5 0                        214440
      *                                                                                       214440
     C     WTOTAL        IFNE      WDAYS                                                      214440
     C                   MOVE      'N'           PAPPD                                        214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *  Called By: None                                              *
      *                                                               *
      *  Calls    : AOBANKR0, AODEALR0, *PSSR                         *
      *                                                               *
      *****************************************************************
      *
      ** Perform initial processing
      *
     C     *INZSR        BEGSR
      *
      ** Receive Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    PDLNM             6
     C                   PARM                    PSIDE             1
     C                   PARM                    AMEND             1
     C                   PARM                    FXDY1             1 0                        204923
     C                   PARM                    PDATE             5 0                        204923
     C                   PARM                    PAPPD             1                          214440
      *
     C                   MOVE      PDLNM         KDLNO             6 0
      *
      **  Set up key list for OIS Deals Interest Rate File
      *
     C     KKLNO         KLIST
     C                   KFLD                    KDLNO
     C                   KFLD                    PSIDE
      *
      ** Set up key list for OIS Componding history File
      *
     C     KPRVK         KLIST
     C                   KFLD                    KDLNO
     C                   KFLD                    PSIDE
     C                   KFLD                    WDYNO
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Set off all indicators
      *
     C                   MOVE      '0'           *IN
      *
      ** Initialise LDA field.
      *
     C     *DTAARA       DEFINE                  LDA
     C                   MOVEL     'DL1652'      DBPGM
      *
      ** Define message file to be used
      *
     C                   MOVEL     'DRSMM   '    ZAMSGF
      *
      ** Initialise all working fields
      *
     C                   MOVE      *BLANKS       #0MRDT
     C                   MOVE      *BLANKS       WVALD             1
      *
      ** Call Access Program to obtain Banks details from PF/SDBANKPD
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Obtain Midas Run Date
      *
     C                   MOVEL     BJMRDT        #0MRDT
      *
      ** Check System Date Format, DDMMYY (*IN98 off)
      *                            MMDDYY (*IN98 on).
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   ENDIF
      *
      ** Access Dealing ICD, divide Hong Kong Tax rate field and divide
      ** by 100 to get working tax rate TAXR.
      *
     C**********           CALL 'AODEALR0'                                                    CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C********** SDDEAL    PARM SDDEAL    DSFDY                                               CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
     C     PRTCD         IFNE      *BLANKS
     C                   Z-ADD     3             DBASE
     C                   MOVE      'SDDEALPD'    DBFILE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     BNHKTR        DIV       100           TAXR              5 4
      *
      ** Check if switchable feature CIR004 is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CIR004'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF    '
     C     *LOCK         IN        LDA
     C                   Z-ADD     4             DBASE
     C                   MOVE      'SCSARDPD'    DBFILE
     C                   MOVEL     'CIR004'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR004            1
     C                   ELSE
     C                   MOVEL     'N'           CIR004
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCLRM - Clears error message subfile                        *
      *                                                               *
      *  Called by: SRSCR1                                            *
      *                                                               *
      *  Calls    : Y2CLMSC                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRCLRM        BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      #0PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
     C                   MOVE      *BLANK        WERRF             1
     C                   MOVE      *BLANK        WWARN             1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS - Sends messages to the program's message queue       *
      *                                                               *
      *  Called by: Almost all screens with validation                *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     ZASNMS        BEGSR
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     #0PGM         ZAPGMQ
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     WERR          IFEQ      *BLANK
     C                   MOVE      'Y'           WERR              1
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/ZDATE1
     C*COPY ZSRSRC,ZDATE1Z2                                                                   220859
     C/COPY ZSRSRC,ZDATE1Z2LE                                                                 220859
      /EJECT
     C*COPY ZSRSRC,ZDATE2Z2                                                                   220859
     C/COPY ZSRSRC,ZDATE2Z2LE                                                                 220859
     C**                                                                                      220859
     C*COPY ZSRSRC,ZEDITZ2                                                                    220859
     C/COPY ZSRSRC,ZEDITZ2LE                                                                  220859
     C*COPY ZSRSRC,ZALIGNZ2                                                                   220859
     C*COPY*ZSRSRC,ZALIGNZ2LE***                                                       220859 245692
     C/COPY ZSRSRC,ZALIGNZ4LE                                                                 245692
     C*COPY*ZSRSRC,ZDATE9Z3                                                                   CIR013
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 CIR013
     C*COPY*ZSRSRC,ZFEB29                                                                     CIR013
     C/COPY ZSRSRC,ZFEB29Z2LE                                                                 CIR013
      /EJECT                                                                                  220859
      *****************************************************************                       220859
      *                                                               *                       220859
      *  XEDIT   - Insert a decimal point into a numeric field and    *                       220859
      *            to blank out leading zeroes                        *                       220859
      *                                                               *                       220859
      *  This subroutine was based on   /COPY ZSRSRC, ZEDITZ2.        *                       220859
      *                                                               *                       220859
      *  Input fields are as follows:                                 *                       220859
      *                                                               *                       220859
      *****XFIELD*-*An*18*character*alphameric*field*to*contain*the****                 220859221685
      *    XFIELD - An 19 character alphameric field to contain the   *                       221685
      *            numeric input.                                     *                       220859
      *                                                               *                       220859
      *    XADEC - A one-digit numeric field containing the required  *                       220859
      *          number of decimal positions as a constant in your    *                       220859
      *          program.                                             *                       220859
      *                                                               *                       220859
      *  Output field:                                                *                       220859
      *                                                               *                       220859
      *****XFIELD*-*the*16*character*alphameric*field*containing*the***                 220859221685
      *    XFIELD - the 19 character alphameric field containing the  *                       221685
      *           numeric field with a decimal point inserted and the *                       220859
      *           leading zeroes suppressed.                          *                       220859
      *                                                               *                       220859
      *****************************************************************                       220859
      *                                                                                       220859
     C     XEDIT         BEGSR                                                                220859
      *                                                                                       220859
      **   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.                             220859
      *                                                                                       220859
     C                   Z-ADD     XADIG         XADIG             2 0                        220859
     C                   Z-ADD     XADEC         XADEC             2 0                        220859
     C**                                                                                      220859
     C*       SET UP WORK FIELDS                                                              220859
     C*                                                                                       220859
     C                   MOVEA     ' '           XA1                                          220859
     C                   MOVEA     ' '           XA2                                          220859
     C*                                                                                       220859
     C*******************Z-ADD     18            X1                2 0                  220859221685
     C*******************Z-ADD     18            X2                2 0                  220859221685
     C                   Z-ADD     19            X1                2 0                        221685
     C                   Z-ADD     19            X2                2 0                        221685
     C*                                                                                       220859
     C*****18************SUB       XADEC         XADEC2            2 0                  220859221685
     C     19            SUB       XADEC         XADEC2            2 0                        221685
     C*                                                                                       220859
     C*                                                                                       220859
     C                   MOVEA     XFIELD        XA1                                          220859
     C*                                                                                       220859
     C*       CHECK TO SEE IF THERE ARE ANY DECIMAL PLACES                                    220859
     C*                                                                                       220859
     C     XADEC         COMP      0                                      91                  220859
     C   91              GOTO      XT20                                                       220859
     C**                                                                                      220859
     C     XT10          TAG                                                    ** XT10 TAG **220859
     C**                                                                                      220859
     C*                                                                                       220859
     C*       SET UP DECIMALS                                                                 220859
     C*                                                                                       220859
     C                   MOVE      XA1(X1)       XA2(X2)                                      220859
     C     X1            SUB       1             X1                                           220859
     C     X2            SUB       1             X2                                           220859
     C*                                                                                       220859
     C     X2            COMP      0                                      90                  220859
     C   90              GOTO      XT30                                                       220859
     C*                                                                                       220859
     C*       CHECK IF END OF DECIMALS                                                        220859
     C**                                                                                      220859
     C     X2            COMP      XADEC2                             90                      220859
     C   90              GOTO      XT10                                                       220859
     C*                                                                                       220859
     C**                                                                                      220859
     C*       PUT IN DECIMAL PLACE                                                            220859
     C*                                                                                       220859
     C**********         MOVE      '.'           XA2(X2)                               220859 245692
     C                   MOVE      BNDCSP        XA2(X2)                                      245692
     C     X2            SUB       1             X2                                           220859
     C*                                                                                       220859
     C     XT20          TAG                                                    ** XT20 TAG **220859
     C*                                                                                       220859
     C*       SET UP INTEGERS                                                                 220859
     C*                                                                                       220859
     C                   MOVE      XA1(X1)       XA2(X2)                                      220859
     C     X1            SUB       1             X1                                           220859
     C     X2            SUB       1             X2                                           220859
     C**                                                                                      220859
     C     X2            COMP      0                                  90                      220859
     C   90              GOTO      XT20                                                       220859
     C*                                                                                       220859
     C*       PUT IN LEADING BLANKS                                                           220859
     C*                                                                                       220859
     C     XT30          TAG                                                    ** XT30 TAG **220859
     C**                                                                                      220859
     C                   Z-ADD     1             X2                                           220859
     C**                                                                                      220859
     C     XT40          TAG                                                    ** XT40 TAG **220859
     C*                                                                                       220859
     C     XA2(X2)       COMP      '0'                                9090                    220859
     C   90XA2(X2)       COMP      ' '                                9090                    220859
     C*                                                                                       220859
     C   90              GOTO      XT50                                                       220859
     C*                                                                                       220859
     C                   MOVE      ' '           XA2(X2)                                      220859
     C     X2            ADD       1             X2                                           220859
     C*                                                                                       220859
     C*****X2************COMP      18                                   90              220859221685
     C     X2            COMP      19                                   90                    221685
     C   90              GOTO      XT40                                                       220859
     C*                                                                                       220859
     C*       IF NO INTEGERS PUT IN LEADING ZERO                                              220859
     C*                                                                                       220859
     C     XT50          TAG                                                    ** XT50 TAG **220859
     C*                                                                                       220859
     C                   Z-ADD     XADEC2        X2                                           220859
     C  N91X2            SUB       1             X2                                           220859
     C     XA2(X2)       COMP      ' '                                    90                  220859
     C   90              MOVE      '0'           XA2(X2)                                      220859
     C*                                                                                       220859
     C*       SET UP OUTPUT FIELD                                                             220859
     C*                                                                                       220859
     C     XT60          TAG                                                    ** XT60 TAG **220859
     C*                                                                                       220859
     C*******************MOVEA     XA2           XFIELD           18                    220859221685
     C                   MOVEA     XA2           XFIELD           19                          221685
     C**                                                                                      220859
     CSR   XEND          ENDSR                                                  ** XEND **    220859
      *****************************************************************                       220859
      /EJECT                                                                                  220859
      *****************************************************************                       220859
      *                                                               *                       220859
      *  XALIGN  - Validate and Right-Align Numeric Fields with more  *                       220859
      *            than 9 decimal places.                             *                       220859
      *                                                               *                       220859
      *  This subroutine was based on   /COPY ZSRSRC, ZALIGNZ2.       *                       220859
      *  Input Fields are as follows:                                 *                       220859
      *                                                               *                       220859
      ****XFIELD*-*An*18*character*alphameric*field*to*contain*the*****                 220859221685
      *   XFIELD - A  19 character alphameric field to contain the    *                       221685
      *         numeric input. The field may contain leading and      *                       220859
      *         trailing blanks and a decimal point, and may have up  *                       220859
      **********to*17*digits.*Note:*17*digits*and*one*decimal*point*=**                 220859221685
      **********18*chracters.******************************************                 220859221685
      *         to 18 digits. Note: 18 digits and one decimal point = *                       221685
      *         19 chracters.                                         *                       221685
      *                                                               *                       220859
      *   XADEC - A two-digit numeric field containing the required   *                       220859
      *         number of decimal positions as a constant in your     *                       220859
      *         program.                                              *                       220859
      *                                                               *                       220859
      *   XADIG - A two-digit numeric field containing the required   *                       220859
      *           number of digits before the decimal point as a      *                       220859
      *           constant in your program.                           *                       220859
      *                                                               *                       220859
      *   Output Fields are as follows:                               *                       220859
      *                                                               *                       220859
      ****XFIELD*-*the*18*character*alphameric*field*containing*the****                 220859221685
      *   XFIELD - the 19 character alphameric field containing the   *                       221685
      *         validated and right aligned value, with no decimal    *                       220859
      *         point. Except in the case of embedded blanks, any     *                       220859
      *         failure in validation will leave ZFIELD as blank.     *                       220859
      *                                                               *                       220859
      *   *IN99 - set on if the input field is not a valid numeric    *                       220859
      *           field or if the number of digits before or after    *                       220859
      *           the decimal point exceeds the specified constants.  *                       220859
      *                                                               *                       220859
      *****************************************************************                       220859
      *                                                                                       220859
     C     XALIGN        BEGSR                                                                220859
     C**                                                                                      220859
     C                   SETOFF                                       929399                  220859
     C**                                                                                      220859
     C**   SAVE INPUT FIELD IN ARRAY, XA1.                                                    220859
     C**                                                                                      220859
     C                   MOVEA     XFIELD        XA1                                          220859
     C**                                                                                      220859
     C**   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.                             220859
     C                   Z-ADD     XADIG         XADIG             2 0                        220859
     C                   Z-ADD     XADEC         XADEC             2 0                        220859
     C**                                                                                      220859
     C**   CALCULATIONS TO DEFINE/CLEAR FIELDS.                                               220859
     C                   MOVE      ' '           XA2                                          220859
     C*******************MOVEA     XA2           XFIELD           18                    220859221685
     C                   MOVEA     XA2           XFIELD           19                          221685
     C                   Z-ADD     0             XX                2 0                        220859
     C                   Z-ADD     0             XY                2 0                        220859
     C**                                                                                      220859
     C**   ENSURE REQUIRED STRUCTURE OF FIELD IS VALID.                                       220859
     C     XADIG         ADD       XADEC         XZ                2 0                        220859
     C*****XZ************COMP      17                                 99                220859221685
     C     XZ            COMP      18                                 99                      221685
     C   99              GOTO      XAEND                                                      220859
     C**                                                                                      220859
     C**   LOOP TO FIND DECIMAL POINT, BLANKS AND CHARACTERS.                                 220859
     C     XATAG1        TAG                                                    ** XATAG1 TAG 220859
     C     XX            ADD       1             XX                                           220859
     C**                                                                                      220859
     C**   CHECK FOR DECIMAL POINT. ERROR IF SECOND DECIMAL POINT.                            220859
     C*****XA1(XX)       COMP      '.'                                    90           220859 245692
     C     XA1(XX)       COMP      BNDCSP                                 90                  245692
     C   90                                                                                   220859
     CAN 93              SETON                                        99                      220859
     C   99              GOTO      XAEND                                                      220859
     C**                                                                                      220859
     C**                                                                                      220859
     C**   CHECK FOR 'M' CONSTANT. ERROR IF NOT LAST CHARACTER ENTERED                        220859
     C     XA1(XX)       COMP      'M'                                    96                  220859
     C   96              DO                                                                   220859
     C*****XX************COMP      17                                 99  99            220859221685
     C     XX            COMP      18                                 99  99                  221685
     C   99              GOTO      XAEND                                                      220859
     C     XX            ADD       1             XX                                           220859
     C     XA1(XX)       COMP      ' '                                9999                    220859
     C   99              GOTO      XAEND                                                      220859
     C     XX            SUB       1             XX                                           220859
     C*****XX************COMP      11                                 99                220859221685
     C     XX            COMP      12                                 99                      221685
     C   99              GOTO      XAEND                                                      220859
     C                   END                                                                  220859
     C**                                                                                      220859
     C**   CHECK FOR 'T' CONSTANT. ERROR IF NOT LAST CHARACTER ENTERED                        220859
     C     XA1(XX)       COMP      'T'                                    97                  220859
     C   97              DO                                                                   220859
     C*****XX************COMP      17                                 99  99            220859221685
     C     XX            COMP      18                                 99  99                  221685
     C   99              GOTO      XAEND                                                      220859
     C     XX            ADD       1             XX                                           220859
     C     XA1(XX)       COMP      ' '                                9999                    220859
     C   99              GOTO      XAEND                                                      220859
     C     XX            SUB       1             XX                                           220859
     C*****XX************COMP      14                                 99                220859221685
     C     XX            COMP      15                                 99                      221685
     C   99              GOTO      XAEND                                                      220859
     C                   END                                                                  220859
     C**                                                                                      220859
     C**   CLEAR ALPHAMERIC CONSTANT FROM XA1                                                 220859
     C   96                                                                                   220859
     COR 97              MOVE      ' '           XA1(XX)                                      220859
     C**                                                                                      220859
     C**   CHECK FOR BLANKS. BYPASS FOR FIRST BLANK AFTER A DIGIT.                            220859
     C     XA1(XX)       COMP      ' '                                    91                  220859
     C   91                                                                                   220859
     CAN 92              GOTO      XATAG2                                                     220859
     C**                                                                                      220859
     C**   CHECK FOR NUMERIC, IF NOT '.' OR ' '.                                              220859
     C  N90                                                                                   220859
     CANN91XA1(XX)       COMP      '0'                                  99                    220859
     C  N90                                                                                   220859
     CANN91                                                                                   220859
     CANN99XA1(XX)       COMP      '9'                                99                      220859
     C   99              GOTO      XAEND                                        NOT NUMERIC   220859
     C**                                                                                      220859
     C**   STORE DIGITS IN ARRAY AND HOW MANY.                                                220859
     C**   XY, TOTAL OF DIGITS IN THE INPUT FIELD.                                            220859
     C**   XZ, TOTAL OF DIGITS TO THE LEFT OF DECIMAL POINT.                                  220859
     C  N90                                                                                   220859
     CANN91XY            ADD       1             XY                   92                      220859
     C  N90                                                                                   220859
     CANN91              MOVE      XA1(XX)       XA2(XY)                                      220859
     C   90              Z-ADD     XY            XZ                   93  93                  220859
     C**                                                                                      220859
     C*****XX************COMP      18                                   94 CHECK IF ALL 220859221685
     C     XX            COMP      19                                   94      CHECK IF ALL  221685
     C   94              GOTO      XATAG1                                                     220859
     C**                                                                                      220859
     C     XATAG2        TAG                                                    ** XATAG2 TAG 220859
     C**                                                                                      220859
     C**   IF 'M' SPECIFIED, MULTIPLY XA1 BY 1 MILLION                                        220859
     C   96XZ            ADD       6             XZ                                           220859
     C**                                                                                      220859
     C**   IF 'T' SPECIFIED, MULTIPLY XA1 BY 1 THOUSAND                                       220859
     C   97XZ            ADD       3             XZ                                           220859
     C**                                                                                      220859
     C**   FILL IN ZEROS IN ANY BLANKS LEFT OF DECIMAL POINT                                  220859
     C   96                                                                                   220859
     CAN 93                                                                                   220859
     COR 97                                                                                   220859
     CAN 93XZ            DOWGT     XY                                                         220859
     C     XY            ADD       1             XY                                           220859
     C                   MOVE      '0'           XA2(XY)                                      220859
     C                   END                                                                  220859
     C**                                                                                      220859
     C**   IF CONSTANT SPECIFIED WITH NO DECIMAL POINT ZEROISE BLANKS                         220859
     C   96                                                                                   220859
     CANN93              DO        6                                                          220859
     C     XY            ADD       1             XY                                           220859
     C                   MOVE      '0'           XA2(XY)                                      220859
     C                   END                                                                  220859
     C**                                                                                      220859
     C   97                                                                                   220859
     CANN93              DO        3                                                          220859
     C     XY            ADD       1             XY                                           220859
     C                   MOVE      '0'           XA2(XY)                                      220859
     C                   END                                                                  220859
     C**                                                                                      220859
     C**   IF NO DECIMAL POINT FOUND, SET TOTAL FIELD XZ.                                     220859
     C  N93              Z-ADD     XY            XZ                                           220859
     C**                                                                                      220859
     C**   CHECK FOR EMBEDDED BLANKS.                                                         220859
     C   91                                                                                   220859
     CAN 92              MOVEA     XA1(XX)       XFIELD                                       220859
     C   91                                                                                   220859
     CAN 92XFIELD        COMP      ' '                                9999                    220859
     C   99              GOTO      XAEND                                        EMBEDDED BLANK220859
     C**                                                                                      220859
     C**   ENSURE THAT NUMBER OF DIGITS ENTERED EITHER SIDE                                   220859
     C**   OF DECIMAL POINT ARE NOT MORE THAN ALLOWED.                                        220859
     C     XZ            COMP      XADIG                              99                      220859
     C     XY            SUB       XZ            XX                                           220859
     C  N99XADEC         SUB       XX            XX                     9995                  220859
     C   99              GOTO      XAEND                                                      220859
     C   95              GOTO      XATAG4                                       NO TRAILING   220859
     C**                                                   BLANKS.                            220859
     C**   FILL THE TRAILING BLANKS WITH ZEROS.                                               220859
     C     XY            ADD       XX            XZ                                           220859
     C     XATAG3        TAG                                                    ** XATAG3 TAG 220859
     C     XY            ADD       1             XY                                           220859
     C                   MOVE      '0'           XA2(XY)                                      220859
     C     XY            COMP      XZ                                   94                    220859
     C   94              GOTO      XATAG3                                                     220859
     C**                                                                                      220859
     C**   RIGHT-ALIGN THE VALUE BY MOVING BACK TO ARRAY, XA1.                                220859
     C     XATAG4        TAG                                                    ** XATAG4 TAG 220859
     C                   MOVE      '0'           XA1                                          220859
     C*******************Z-ADD     18            XX                                     220859221685
     C                   Z-ADD     19            XX                                           221685
     C     XATAG5        TAG                                                    ** XATAG5 TAG 220859
     C     XY            COMP      0                                      94                  220859
     C   94              GOTO      XATAG6                                                     220859
     C                   MOVE      XA2(XY)       XA1(XX)                                      220859
     C     XY            SUB       1             XY                                           220859
     C     XX            SUB       1             XX                                           220859
     C                   GOTO      XATAG5                                                     220859
     C     XATAG6        TAG                                                    ** XATAG6 TAG 220859
     C**                                                                                      220859
     C**   MOVE VALIDATED AND RIGHT-ALIGNED NUMBER BACK INTO XFIELD.                          220859
     C                   MOVEA     XA1           XFIELD                                       220859
     C**                                                                                      220859
     C                   SETOFF                                       9697                    220859
     C**                                                                                      220859
     C     XAEND         ENDSR                                                  * XAEND ENDSR 220859
     C**                                                                                      220859
     C**                                                                                      220859
     C********************************************************************                    220859
**  CPY@
(c) Finastra International Limited 2001
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN                        CIR013
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR                           CIR013
00000000310005900090001200015100181002120024300273003040033400365
