      *****************************************************************
/*STD *  RPGBASEBND                                                   *                       221257
/*EXI *  TEXT('Midas DL OIS applicable days correction')              *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL1643 - OIS Applicable Days Correction for all Deals        *
      *                                                               *
      *  Function:  This program displays, in a subfile, compounding  *
      *  (I/C)      interest rate records for deals of a particular   *
      *             currency and base rate code.                      *
      *             The user can specify the dates at which the       *
      *             new Applicable Days are to apply.                 *
      *                                                               *
      *  Called By: DLC1643 - OIS Applicable Days Correction          *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD051713           Date 08Sep18               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 245692             Date 10Dec13               *
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
      *                 CSD031             Date 10Apr06               *
      *                 223045             Date 01Mar06               *
      *                 221257             Date 01Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CIR013             Date 18Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 214440  *CREATE    Date 30Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD051713 - Incorrect rates are displayed on OIS Compounding  *
      *             Interest Rate Enquiry screen.                     *
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
      *  CPK025 - add /COPY ZFEB29Z1LE.                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  223045 - Do not include GUESS and COMPOUND records in the    *
      *           selection.  Also, do not update GUESS and COMPOUND  *
      *           records.                                            *
      *  221257 - Divide by zero caused by 'GUESS' records.           *
      *           Program also converted to ILE to be compatible with *
      *           220859 which changed DLDOISPD field L1CPRT to have  *
      *           15 decimal places.                                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CIR013 - Additional Calculation Method for FRA/IRS/CCF       *
      *           Also fix divide by zero error caused by number of   *
      *           days since last payment date being zero.            *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  214440 - New function to Amend Applicable Days for all Deals *
      *           (OIS)                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *   SRINIT - Initialisation of Program                          *
      *   SRVINS - Initial Screen Processing                          *
      *   SRSFLP - Subfile Processing                                 *
      *   SRTERM - Termination of Program                             *
      *                                                               *
      *   SRF5   - F5=Refresh Processing                              *
      *   SRVALD - Data Validation                                    *
      *   SRVALA - Action Code, Date and Applicable Days              *
      *   SRCLR  - Clear all display fields, subfile and error msg    *
      *            queue                                              *
      *   SRCLRM - Clear error message queue                          *
      *   SRLDSF - Build Subfile                                      *
      *   SRLOAD - Load Subfile display fields                        *
      *   SRSCRN - Display whole screen including subfile             *
      *   SRPROC - Process ENTER command.  Revalidate data            *
      *   SRCONF - Process Confirm Request - Amend, Delete            *
      *   SRCNFI - Process Confirm Request - Insert                   *
      *   SRUPDP - Update previous records                            *
      *   SRRECA - Recalculate interest amount due                    *
      *   ZASNMS- Sends messages to the program's message queue       *
      *   *PSSR - Error Handling                                      *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   03  - F3 EXIT                                               *
      *   05  - F5 Refresh                                            *
      *   09  - F9 Amend                                              *
      *   12  - Previous Screen                                       *
      *   22  - Rollup                                                *
      *   31  - Display deal detail                                   *
      *   40  - Error on Deal Number                                  *
      *   41  - Error on Deal Side                                    *
      *   42  - Error on Position to Date                             *
      *   45  - Error on Action Code                                  *
      *   46  - Error on Date                                         *
      *   47  - Error on Applicable Day                               *
      *   48  - Numeric test on Position to Date                      *
      *   50  - CHAIN to DEALSDG                                      *
      *   53  - READ on DLDOISL4                                      *
      *   54  - READ on DLDOISL5                                      *
      *   55  - READ on DLDOISL3                                      *
      *   56  - READ on DLDOISL6                                      *
      *   81  - Display Subfile                                       *
      *   82  - End of Subfile                                        *
      *   83  - Erase Record Format DL1643S0 (SFL)                    *
      *   86  - PUTOVER                                               *
      *   89  - End of OIS Compounding Interest Rate File DLDOISPD    *
      * 90-99 - Used by Standard Subroutines                          *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      *   99  - Date Format not valid.                                *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     FDLDOISL1  UF A E           K DISK
     F                                     RENAME(DLDOISD0:DLDOISD1)
     F                                     COMMIT
      ** OIS: Interest Rate logical File
      *
     FDLDOISL2  IF   E           K DISK
     F                                     RENAME(DLDOISD0:DLDOISD2)
      ** OIS: Interest Rate logical Acending date order
      *
     FDLDOISL3  IF   E           K DISK
      ** Logical file built over DLDOISPD
      *
     FDLDOISL4  IF   E           K DISK
     F                                     RENAME(DLDOISD0:DLDOISD4)
      ** Logical file built over DLDOISPD
      *
     FDLDOISL5  IF   E           K DISK
     F                                     RENAME(DLDOISD0:DLDOISD5)
      ** Logical file built over DLDOISPD
      *
     FDLDOISL6  IF   E           K DISK
     F                                     RENAME(DLDOISD0:DLDOISD6)
      ** Logical file built over DLDOISPD
      *
     FDEALS     UF   E           K DISK
      ** Logical file built over DEALSDG
     F                                     COMMIT
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
      *
     FDL1643DF  CF   E             WORKSTN
      ** OIS Applicable Days Amendment for all Deals Display
     F                                     INFDS(INFDS1)
     F                                     SFILE(DL1643S0:RRN)
      *
      *****************************************************************
      *
      /EJECT
      *
      ** Array containing Copyright statement
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D*COPY*ZSRSRC,ZSEDITZ1                                                                   221257
     D*COPY*ZSRSRC,ZSEDITZ1LE***                                                       221257 245692
     D*ZS2******       S              1    DIM(21)                                   245692 MD051713
     D ZS2             S              1    DIM(26)                                          MD051713
     D*COPY*ZSRSRC,ZDATE2Z1                                                                   221257
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                 221257
     D*COPY*ZSRSRC,ZEDITZ1                                                                    221257
     D/COPY ZSRSRC,ZEDITZ1LE                                                                  221257
     D*COPY*ZSRSRC,ZDATE9Z1                                                                   CIR013
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 CIR013
     D/COPY ZSRSRC,ZFEB29Z1LE                                                                 CPK025
      *
      /SPACE 3
      *
      ** Display File information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I#DSP)
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  #0PGM            *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data Structure to receive Bank details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Data Structure to receive Currency details
      *
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      ** Data Structure to receive Base Rate details
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** Data Structure to receive Dealing details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short DS for access objects
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long Data Structure
      *
      /EJECT
      *
     D*COPY*ZSRSRC,ZSEDITZ2                                                                   221257
     D                 DS                                                                     221257
     D**WORK15**               1     15  0                                           221257 MD051713
     D**ZS1*****               1     15  0                                           245692 MD051713
     D**********                           DIM(15)                                   245692 MD)51713
     D  WORK15                 1     19  0                                                  MD051713
     D  ZS1                    1     19  0                                                  MD051713
     D                                     DIM(19)                                          MD051713
     D*COPY*ZSRSRC,ZDATE9Z2                                                                   CIR013
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 CIR013
     D*COPY*ZSRSRC,ZINTDYZ1                                                                   CIR013
     D/COPY ZSRSRC,ZINTDYZ1LE                                                                 CIR013
      *
      /EJECT
      *
     C/TITLE Main Processing
      *
      *****************************************************************
      *                                                               *
      *    M A I N     P R O C E S S I N G                            *
      *                                                               *
      *****************************************************************
      *
      ** Perform Initialisation
      *
     C                   EXSR      SRINIT
      *
     C     *IN03         DOUNE     '0'
      *
      ** Validate Initial Screen
     C                   EXSR      SRVINS
      *
      ** Process Subfile
     C                   EXSR      SRSFLP
      *
     C                   ENDDO
      *
      ** Terminate Program
      *
     C                   EXSR      SRTERM
      *
      *================================================================
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initial Processing                                  *
      *                                                               *
      *  Called By : Main Processing                                  *
      *  Calls     : AOBANKR0, AODEALR0                               *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Initialise LDA field
      *
     C                   MOVEL     'DL1643'      DBPGM
     C     *DTAARA       DEFINE                  LDA
      *
      ** Key List to access data from file PF/DLDOISPD via DLDOISL3
      *
     C     KKON3         KLIST
     C                   KFLD                    WKDLN             6 0
     C                   KFLD                    WKSID             1
     C                   KFLD                    WKDAT             5 0
      *
      ** Key List to access data from file PF/DLDOISPD via DLDOISL4
      *
     C     KKON4         KLIST
     C                   KFLD                    WKBSD
      *
      ** Key list for OIS Deals Interest Rate File
      *
     C     KKLNO         KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    SIDE
      *
      ** Key list for OIS Componding history File
      *
     C     KPRVK         KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    SIDE
     C                   KFLD                    WDYNO
      *
      ** Initialise all working fields
      *
     C                   MOVE      *BLANKS       WVALD             1            Validation Check
      *
     C                   MOVE      *BLANKS       WCCY              3            OLD Currency
     C                   MOVE      *BLANKS       WWBSRC            2            OLD Base Rate
     C                   MOVE      *BLANKS       WPTDO             6            OLD P to Date
      *
      ** Fields used to check if the Deal number, Deal Side or the
      ** Position to Date have been validated.
      *
     C                   MOVE      *BLANKS       WCCYV             1            Valid Currency
     C                   MOVE      *BLANKS       WBSRV             1            Valid Side
     C                   MOVE      *BLANKS       WPTDV             1            Valid To Date
     C                   MOVE      *BLANKS       WAVAL             1            Valid Applicable fie
      *
     C                   MOVEL     'DRSMM   '    ZAMSGF
      *
      *
      ** Call Access Program to obtain Banks details from PF/SDBANKPD
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Obtain Midas Run Date
      *
     C                   MOVEL     BJMRDT        #0MRDT                         Midas Run Date
     C                   MOVEL     USER          #0USER                         User
     C                   MOVEL     WSID          #0WSID                         Work Station ID
      *
      ** Check System Date Format, DDMMYY (*IN98 off)
      **                           MMDDYY (*IN98 on).
      *
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      ** Access file SDDEALPD, divide Hong Kong Tax rate field and divide
      ** by 100 to get working tax rate TAXR.
     C**********           CALL 'AODEALR0'                                                    CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST'      POPTN
     C********** SDDEAL    PARM SDDEAL    DSFDY                                               CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     BNHKTR        DIV       100           TAXR              5 4
      *
      ** Set Subfile page size
      *
     C                   Z-ADD     10            WSFPG             3 0          SFLPAG
     C                   Z-ADD     1             #0SFRC                         SFLRCDNBR
      *
      ** Subfile pages
      *
     C                   Z-ADD     1             WSPAG             3 0
      *
      ** Processed Subfile record
      *
     C                   Z-ADD     0             WPRRN             3 0
      *
      ** Initialise Relative Record numbers
      *
     C                   Z-ADD     0             RRN               5 0
      *
      ** Maximum record number
      *
     C                   Z-ADD     0             WRRMX             5 0
     C                   Z-ADD     0             WRROK             5 0
     C                   MOVE      '0'           *IN81
      *
      ** Initialise Subfile Control
      *
     C                   MOVE      *BLANKS       #0DLNO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVINS - Validate initial screen                             *
      *                                                               *
      *  Called by : Main routine                                     *
      *  Calls     : SRVALD, SRTERM                                   *
      *                                                               *
      *****************************************************************
     C     SRVINS        BEGSR
      *
     C     WF12          DOUEQ     *BLANK
      *
     C                   MOVE      *BLANK        WF12              1
      *
      ** Do until Subfile processing is required.
      *
     C     WVALD         IFNE      *BLANK
      *
      ** Clear all display fields and message queue
      *
     C                   EXSR      SRCLR
      *
     C                   ENDIF
      *
      ** Display initial screen until F3 is pressed or all the
      ** fields have been validated
      *
     C     WVALD         DOUNE     'N'                                          Do until valid
      *
     C                   MOVE      '0'           *IN12
     C                   MOVE      '0'           *IN31
     C                   MOVE      '0'           *IN32
     C                   MOVE      'N'           WF5               1            Refresh
      *
     C                   WRITE     DL1643F0
      *
      ** Write error message
      *
     C                   WRITE     DL1643C1                                     Error msg
      *
     C                   MOVE      '0'           *IN81                          Sfldsp
     C                   MOVE      '1'           *IN83                          Erase SFL
     C                   MOVE      '0'           *IN31                          Dsp deal detail
      *
     C                   EXFMT     DL1643C0
      *
      ** Clear error message queue
      *
     C                   EXSR      SRCLRM                                       Clear error msg
      *
     C                   MOVE      '0'           *IN83
      *
     C                   MOVE      '0'           *IN40                          Deal Number
     C                   MOVE      '0'           *IN41                          Deal Side
     C                   MOVE      '0'           *IN42                          P to Date
     C                   MOVE      '0'           *IN45                          Action code
     C                   MOVE      '0'           *IN46                          Date
     C                   MOVE      '0'           *IN47                          Applicable Day
      *
     C                   SELECT
      *
      ** ... F3 is pressed, end processing
      *
     C     *IN03         WHENEQ    '1'                                          F3 Pressed
     C                   EXSR      SRTERM
      *
      ** ... F12 is pressed, return to initial screen
      *
     C     *IN12         WHENEQ    '1'                                          F12 Pressed
     C                   MOVE      'N'           WVALD
     C                   MOVE      'Y'           WF12                           Dsp Init Scrn
      *
      ** ... F5 is pressed, re-display screen with refreshed details
      *
     C     *IN05         WHENEQ    '1'
      *
     C                   MOVE      WCCY          #0CCY
     C                   MOVE      WWBSRC        #0BSRC
     C                   MOVE      WPTDO         #0PDAT
      *
     C                   MOVE      'N'           WVALD
      *
     C                   MOVE      'Y'           WF5
      *
      ** ENTER key is pressed, validate all field on the initial
      ** screen
      *
     C                   OTHER
      *
     C                   EXSR      SRVALD                                       Validation
      *
     C                   ENDSL
      *
     C                   MOVE      *BLANK        WCLR              1
     C     WF5           IFEQ      'N'
     C     WF12          ANDEQ     *BLANK
      *
     C     WWVALD        IFNE      'Y'
      *
      ** Clear Subfile  and erase Subfile control from the screen
      *
     C                   MOVE      '1'           *IN80                          Clear SFL
     C                   WRITE     DL1643C0
     C                   MOVE      '0'           *IN80
     C                   MOVE      'Y'           WCLR
     C                   ENDIF
      *
     C     WCCYV         IFEQ      'N'                                          Error Currency
     C     WBSRV         OREQ      'N'                                          Error Base Rate
     C     WPTDV         OREQ      'N'                                          Error To Date
      *
      ** One or more of the input fields are in error.
      *
     C                   MOVE      'N'           WVALD
      *
     C                   ELSE
      *
      ** All fields are valid
      *
     C                   MOVE      'Y'           WVALD
      *
      *
     C     #0PDAT        IFEQ      *BLANK
      *
      ** If no position to date has been entered, by default,
      ** start the enquiry at 7 days before rundate.
      *
     C     BJRDNB        SUB       7             WDFTD             5 0
      *
     C                   Z-ADD     WDFTD         ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #0PDAT
      *
     C                   ENDIF
      *
      ** Store old valid data for refresh
      *
     C                   MOVE      #0CCY         WCCY                           OLD Currency
     C                   MOVE      #0BSRC        WWBSRC                         OLD Base Rate
     C                   MOVE      #0PDAT        WPTDO                          OLD P to Date
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALD - Validate Currency, Base Rate Code and               *
      *           Position to Date                                    *
      *                                                               *
      *  Called by : SRVINS                                           *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRVALD        BEGSR
      *
     C                   MOVE      'Y'           WWVALD            1
      *
      ** Currency must be entered
      *
     C     #0CCY         IFEQ      *BLANK
     C                   MOVEL     'MMA1192'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        40
      *
      ** Currency Invalid
     C                   MOVE      'N'           WCCYV
     C                   MOVE      'N'           WWVALD
      *
     C                   ENDIF
      *
      ** Validate Currency from Currency table
     C     #0CCY         IFNE      *BLANKS
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      #0CCY         PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'MMA1193'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        40
      *
      ** Currency Invalid
     C                   MOVE      'N'           WCCYV
     C                   MOVE      'N'           WWVALD
      *
     C                   ELSE
      *
     C                   MOVE      PCCY          #0CCY
     C                   MOVE      'Y'           WCCYV                          Valid Currency
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Base Rate Code.
      *
      *
      ** Base Rate must be entered
      *
     C     #0BSRC        IFEQ      *BLANK
     C                   MOVEL     'MMA1250'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        41
     C                   MOVE      'N'           WBSRV                          Invalid Base Rate
     C                   MOVE      'N'           WWVALD
     C                   ENDIF
      *
      ** Validate Base Rate from Base Rate table
      *
     C     #0BSRC        IFNE      *BLANKS
     C     WCCYV         ANDEQ     'Y'                                          For Valid Currency
      *
     C                   MOVE      #0BSRC        PBSRC             2
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #0CCY         PCCY              3
     C                   PARM                    PBSRC
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'MMA1201'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        41
     C                   MOVE      'N'           WBSRV                          Invalid Base Rate
     C                   MOVE      'N'           WWVALD
     C                   ELSE
      *
     C                   MOVE      PBSRC         #0BSRC
     C                   MOVE      'Y'           WBSRV                          Valid Base Rate
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Position to Date
      *
     C     WCCYV         IFEQ      'Y'                                          For Valid Currency
     C     WWVALD        ANDEQ     'Y'
      *
     C     #0PDAT        IFNE      *BLANK
      *
      ** Test if Position to date is numeric.
      *
     C                   MOVEL     #0PDAT        WTEST             7
     C                   MOVE      'F'           WTEST
     C                   TESTN                   WTEST                48
      *
     C     *IN48         IFEQ      '1'
     C                   MOVE      #0PDAT        ZDATE
     C                   EXSR      ZDATE1
     C                   ENDIF
      *
     C     *IN99         IFEQ      '1'
     C     *IN48         OREQ      '0'
      *
      ** Send message 'Invalid Date'
      *
     C                   MOVEL     'MMA1188'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        42
     C                   MOVE      'N'           WPTDV                          Invalid P to Dt
     C                   MOVE      'N'           WWVALD
      *
     C                   ELSE
     C                   MOVE      'Y'           WPTDV                          Valid Date Form
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      'Y'           WPTDV                          Valid Date Form
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check if records are present on PF/DLDOISPD for the Currency
      ** and Base Rate code specified.
      *
     C     WCCYV         IFEQ      'Y'
     C     WBSRV         ANDEQ     'Y'
     C     WWVALD        ANDEQ     'Y'
      *
     C                   MOVE      *BLANKS       WFND1             1
     C                   MOVE      *BLANKS       WFOUND            1
     C     *LOVAL        SETLL     DLDOISD4
     C                   READ      DLDOISD4                               53
     C     *IN53         DOWEQ     '0'
      *
      ** Chain to PF/DEALSDG via logical file DEALS using record
      ** Format name DEALSDGF
      *
     C                   MOVE      L1DLNO        DLNO
     C     DLNO          CHAIN     DEALSDGF                           50
      *
     C     *IN50         IFEQ      '0'
     C     RECI          ANDEQ     'D'
     C**********         MOVE      #0BSRC        WBSRC             2 0                        CSD103
     C                   MOVE      #0BSRC        WBSRC             2                          CSD103
      *
     C     #0CCY         IFEQ      UCUCY
     C     WBSRC         ANDEQ     UBRTT
     C     #0CCY         OREQ      TCUCY
     C     WBSRC         ANDEQ     TBRTT
      *
     C     UICFR         IFEQ      'O'
     C     TICFR         OREQ      'O'
     C                   MOVE      'Y'           WFND1
     C     L1BSDT        IFGE      ZDAYNO
     C                   MOVE      'Y'           WFOUND
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      DLDOISD4                               53
     C                   ENDDO
      *
      ** Send Error message if no records are found for the Currency
      ** and Base Rate code specified.
      *
     C     WFND1         IFNE      'Y'
     C                   MOVEL     'MMA1251'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      'N'           WCCYV                          Invalid Currency
     C                   MOVE      'N'           WWVALD
      *
     C                   ELSE
     C                   MOVE      'Y'           WCCYV                          Valid Currency
     C                   ENDIF
      *
     C     WFOUND        IFNE      'Y'
     C     #0PDAT        ANDNE     *BLANKS
     C                   MOVEL     'MMA1245'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        42
     C                   MOVE      'N'           WPTDV                          Invalid P to Dt
     C                   MOVE      'N'           WWVALD
      *
     C                   ELSE
     C                   MOVE      'Y'           WPTDV                          Valid Date Form
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSFLP - Subfile processing                                  *
      *                                                               *
      *  Called by : Main processing                                  *
      *  Calls     : SRLOAD                                           *
      *                                                               *
      *****************************************************************
     C     SRSFLP        BEGSR
      *
      ** Perform this loop until cmd3 or F12 is pressed
      *
     C     *IN12         DOWEQ     '0'
      *
     C                   MOVE      '0'           *IN80                          SFLCLR
     C                   MOVE      '0'           *IN82                          SFL end (*more)
     C                   MOVE      '0'           *IN83                          Erase DL1643S0
     C                   MOVE      '0'           *IN55                          End of File
     C                   MOVE      '0'           *IN22                          Roll Up
     C                   MOVE      '0'           *IN40                          Currency
     C                   MOVE      '0'           *IN41                          Base Rate
     C                   MOVE      '0'           *IN42                          Position to dat
     C                   MOVE      '0'           *IN45                          Action code
     C                   MOVE      '0'           *IN46                          Date
     C                   MOVE      '0'           *IN47                          Applicable Day
      *
      ** Clear Error Message queue
      *
     C     WAPPD         IFNE      'N'
     C                   EXSR      SRCLRM
     C                   ENDIF
      *
      ** Clear Subfile
      *
     C                   MOVE      '1'           *IN80
     C                   WRITE     DL1643C0
     C                   MOVE      '0'           *IN80
      *
      ** Reset Number of records in subfile
      *
     C                   Z-ADD     0             WRRMX
     C                   MOVE      '0'           *IN81
      *
      ** Position and read DBF File
      *
     C                   MOVE      #0PDAT        ZDATE
     C                   EXSR      ZDATE1
     C                   MOVE      ZDAYNO        WKDAT
      *
      ** Only display records with the specified Currency and Base Rate
      *
     C     WKDAT         SETLL     DLDOISD0
     C                   READ      DLDOISL3                               55
     C     *IN55         DOWEQ     '0'
      *
     C                   MOVE      L1DLNO        DLNO
     C     DLNO          CHAIN     DEALSDGF                           50
     C     *IN50         IFEQ      '0'
     C     RECI          ANDEQ     'D'
     C                   MOVE      #0BSRC        WBSRC
      *
     C     #0CCY         IFEQ      UCUCY
     C     WBSRC         ANDEQ     UBRTT
     C     #0CCY         OREQ      TCUCY
     C     WBSRC         ANDEQ     TBRTT
      *
     C     UICFR         IFEQ      'O'
     C     TICFR         OREQ      'O'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      DLDOISL3                               55
     C                   ENDDO
      *
      ** Only do subfile processing if required records are found
      *
     C     *IN55         IFEQ      *OFF
      *
      ** Load subfile page
      *
     C                   EXSR      SRLDSF
      *
     C                   MOVEL     'N'           WRSF              1
      *
      ** Display screen until reload requested
      *
     C     WRSF          DOWEQ     'N'
      *
      ** Display screen until reload requested
      *
     C                   EXSR      SRSCRN
      *
     C                   SELECT
      *
      ** Process Response
      *
      ** If F3 has been pressed, exit program
      *
     C     *IN03         WHENEQ    '1'
     C     WAPPD         IFNE      'N'
     C                   EXSR      SRTERM
     C                   ENDIF
      *
      ** If F5 has been pressed, refresh screen
      *
     C     *IN05         WHENEQ    '1'
     C                   EXSR      SRF5
      *
      ** If F6 has been pressed, process confirm
      *
     C     *IN06         WHENEQ    '1'
     C                   MOVE      *OFF          *IN06
     C     #0ACTN        IFEQ      'I'
     C                   EXSR      SRCNFI
     C                   ELSE
     C                   EXSR      SRCONF
     C                   ENDIF
      *
      ** If F12 has been pressed, process Initial Screen
      *
     C     *IN12         WHENEQ    '1'
     C     WAPPD         IFNE      'N'
     C                   MOVE      'Y'           WRSF
     C                   ENDIF
      *
      ** If Rollup requested
      *
     C     *IN22         WHENEQ    '1'
     C                   EXSR      SRLDSF
      *
      ** Otherwise
      *
     C                   OTHER
     C                   EXSR      SRPROC
      *
     C                   ENDSL
      *
      ** Applicable Days do not match up, send error message.
      *
     C     WAPPD         IFEQ      'N'
     C                   MOVEL     'MMA1252'     ZAMSID
     C                   MOVEL     #0APD1        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ELSE
      *
      ** Goto showing initial screen subroutine
      *
     C                   EXSR      SRVINS
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLDSF - Build subfile page                                  *
      *                                                               *
      *  Called by : Main Processing                                  *
      *  Calls     : SRLOAD                                           *
      *                                                               *
      *****************************************************************
     C     SRLDSF        BEGSR
      *
      ** Refresh any input fields that has been changed just before
      ** rollup has been pressed.  Input fields will only be
      ** validated if ENTER key is pressed.
      *
     C     *IN22         IFEQ      '1'
      *
     C     #0CCY         IFNE      WCCY
     C                   MOVE      WCCY          #0CCY
     C                   ENDIF
      *
     C     #0BSRC        IFNE      WWBSRC
     C                   MOVE      WWBSRC        #0BSRC
     C                   ENDIF
      *
     C     #0PDAT        IFNE      WPTDO
     C                   MOVE      WPTDO         #0PDAT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If Rollup has been pressed and not end of file
      *
     C     *IN22         IFEQ      '1'
     C     *IN82         ANDEQ     '0'
     C     *IN55         ANDEQ     '0'
     C                   ENDIF
      *
     C     *IN22         IFEQ      '1'
     C     *IN55         ANDEQ     '1'
     C                   MOVE      '1'           *IN82                          SLFEND (*more)
     C                   ENDIF
      *
      ** Start at previous highest record in subfile
      *
     C                   Z-ADD     WRRMX         RRN
      *
      ** Initialise scan check count
      *
     C                   Z-ADD     0             WRRRD             3 0
      *
      ** Set required pages based on *Set Cursor or *Subfile Pages
      *
     C     WPRRN         IFGT      0
     C     WPRRN         DIV       WSFPG         WSPG              3 0
     C                   MVR                     WSLIN             3 0
     C     WSLIN         IFGT      0
     C                   ADD       1             WSPG
     C                   ENDIF
     C     WSPAG         IFGT      WSPG
     C                   Z-ADD     WSPAG         WSPG
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     WSPAG         WSPG
     C                   ENDIF
      *
      ** Compute lines required based on pages
     C     WSPG          MULT      WSFPG         WSFLN             9 0
     C     WSFLN         IFGT      999
     C                   Z-ADD     999           WSFLN
     C                   ENDIF
      *
      ** Load next SFL page until SFL page full
      *
     C     *IN82         DOWEQ     '0'
     C     WRROK         ANDLT     WSFLN
     C     *IN55         ANDEQ     '0'
      *
      ** Load Subfile fields
      *
     C                   EXSR      SRLOAD
      *
      ** Output to subfile
      *
     C                   ADD       1             RRN
     C                   ADD       1             WRROK
     C                   MOVE      '1'           *IN81
     C                   WRITE     DL1643S0                                     SFL
      *
     C                   ADD       1             WRRRD
      *
      ** Only display records with the specified Currency and Base Rate
      *
     C                   READ      DLDOISL3                               55
     C     *IN55         DOWEQ     '0'
      *
     C                   MOVE      L1DLNO        DLNO
     C     DLNO          CHAIN     DEALSDGF                           50
     C     *IN50         IFEQ      '0'
     C     RECI          ANDEQ     'D'
     C                   MOVE      #0BSRC        WBSRC
      *
     C     #0CCY         IFEQ      UCUCY
     C     WBSRC         ANDEQ     UBRTT
     C     #0CCY         OREQ      TCUCY
     C     WBSRC         ANDEQ     TBRTT
      *
     C     UICFR         IFEQ      'O'
     C     TICFR         OREQ      'O'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      DLDOISL3                               55
     C                   ENDDO
      *
     C     *IN55         IFEQ      '1'
     C                   MOVE      '1'           *IN82                          SLFEND (*more)
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   MOVE      '1'           *IN31
     C                   WRITE     DL1643F0
      *
      ** Save highest SFL record load can continue at end point
      *
     C     RRN           IFGT      WRRMX
      *
      ** Calculate top line
      *
     C     WRROK         DIV       WSFPG         WSPG
     C                   MVR                     WSLIN
     C     WSLIN         IFGT      0
     C     RRN           SUB       WSLIN         #0SFRC
     C                   ELSE
     C     RRN           SUB       WSFPG         #0SFRC
     C                   ENDIF
     C                   ADD       1             #0SFRC
     C                   Z-ADD     RRN           WRRMX
     C                   ENDIF
      *
     C                   Z-ADD     0             WRROK
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN - Display screen                                      *
      *                                                               *
      *  Called by : Main processing                                  *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRSCRN        BEGSR
      *
      ** Write error message
     C                   WRITE     DL1643C1
      *
      ** PUTOVR unless conditioned fields change
      *
     C     *IN81         IFNE      WIN81
     C                   MOVE      '0'           *IN86
     C                   END
     C                   MOVE      *IN81         WIN81             1
      *
     C                   MOVE      '1'           *IN81
      *
     C                   MOVE      '1'           *IN31
      *
     C     WCLR          IFEQ      'Y'
     C                   MOVE      '0'           *IN81                          Sfldsp
     C                   MOVE      '1'           *IN83                          Erase SFL
     C                   MOVE      '0'           *IN31                          Dsp deal detail
     C                   ENDIF
      *
     C                   EXFMT     DL1643C0                                     SFL Control
      *
      ** Reset all the error indicators
      *
     C                   MOVE      '0'           *IN40                          Deal Number
     C                   MOVE      '0'           *IN41                          Deal Side
     C                   MOVE      '0'           *IN42                          P to Date
     C                   MOVE      '0'           *IN45                          Action code
     C                   MOVE      '0'           *IN46                          Date
     C                   MOVE      '0'           *IN47                          Applicable Day
      *
      ** Clear error message queue
      *
     C                   EXSR      SRCLRM
      *
      ** Maintain subfile position where possible
      *
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        #0SFRC
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRF5 - If F5 has been pressed refresh screen.                *
      *                                                               *
      *  Called by : Main processing                                  *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRF5          BEGSR
      *
      ** Refresh Indicator
      *
     C                   MOVE      'Y'           WRSF
      *
      *** Restore old valid data for refresh
      *
     C                   MOVE      WCCY          #0CCY                          OLD Currency
     C                   MOVE      WWBSRC        #0BSRC                         OLD Base Rate
     C                   MOVE      WPTDO         #0PDAT                         OLD P to Date
     C                   MOVE      *BLANKS       #0ACTN                         Action code
     C                   MOVE      *BLANKS       #0DAT1                         Date
     C                   MOVE      *BLANKS       #0APD1                         Applicable Day
      *
     C                   MOVE      *OFF          *IN06
     C                   MOVE      *OFF          *IN32
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROC - Process Screen Input                                *
      *                                                               *
      *  Called by : SRSFLP                                           *
      *  Calls     : SRVALD, SRVALA                                   *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR
      *
     C                   EXSR      SRVALD
     C                   EXSR      SRVALA
      *
     C                   MOVE      *BLANK        WCLR
     C     WWVALD        IFNE      'Y'
      *
      ** Clear Subfile  and erase Subfile control from the screen
      *
     C                   MOVE      '1'           *IN80                          Clear SFL
     C                   WRITE     DL1643C0
     C                   MOVE      '0'           *IN80
     C                   MOVE      'Y'           WCLR
     C                   ENDIF
      *
     C     WCCYV         IFEQ      'N'                                          Error Currency
     C     WBSRV         OREQ      'N'                                          Error Base Rate
     C     WPTDV         OREQ      'N'                                          Error To Date
     C     WAVAL         OREQ      'N'                                          Error Applicable fie
      *
      ** One or more of the input fields are in error.
      *
     C                   MOVE      'N'           WVALD
      *
     C                   ELSE
      *
      ** All fields are valid rebuild the subfile.
      *
     C                   MOVE      'Y'           WVALD
     C                   MOVE      'Y'           WRSF
      *
      *
     C     #0PDAT        IFEQ      *BLANK
      *
      ** If no position to date has been entered, by default,
      ** start the enquiry at 7 days before rundate.
      *
     C     BJRDNB        SUB       7             WDFTD
      *
     C                   Z-ADD     WDFTD         ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #0PDAT
      *
     C                   ENDIF
      *
      ** Store old valid data for refressh
      *
     C                   MOVE      #0CCY         WCCY                           OLD Currency
     C                   MOVE      #0BSRC        WWBSRC                         OLD Base Rate
     C                   MOVE      #0PDAT        WPTDO                          OLD P to Date
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALA - Action Code, Date and Applicable Days               *
      *                                                               *
      *  Called by : SRPROC                                           *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRVALA        BEGSR
      *
     C                   MOVE      'Y'           WWVALA            1
      *
      ** Validate Action code
      *
     C     #0ACTN        IFNE      *BLANK
     C     #0ACTN        ANDNE     'I'
     C     #0ACTN        ANDNE     'A'
     C     #0ACTN        ANDNE     'D'
     C                   MOVEL     'MMA1253'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        45
     C                   MOVE      'N'           WAVAL
     C                   MOVE      'N'           WWVALA
      *
     C                   ELSE
     C                   MOVE      'Y'           WAVAL
     C                   ENDIF
      *
      ** Error if Action code is blank and Date is entered
      *
     C     #0ACTN        IFEQ      *BLANK
     C     #0DAT1        ANDNE     *BLANK
     C     WWVALA        ANDEQ     'Y'
     C                   MOVEL     'MMA1254'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        45
     C                   MOVE      'N'           WAVAL
     C                   MOVE      'N'           WWVALA
     C                   ENDIF
      *
      ** Validate Date
      *
     C     WAVAL         IFEQ      'Y'                                          For Valid Currency
     C     WWVALA        ANDEQ     'Y'
      *
      ** Test if Position to date is numeric.
      *
     C     #0DAT1        IFNE      *BLANK
      *
     C                   MOVEL     #0DAT1        WTEST
     C                   MOVE      'F'           WTEST
     C                   TESTN                   WTEST                48
      *
     C     *IN48         IFEQ      '1'
     C                   MOVE      #0DAT1        ZDATE
     C                   EXSR      ZDATE1
     C                   ENDIF
      *
     C     *IN99         IFEQ      '1'
     C     *IN48         OREQ      '0'
      *
      ** Send message 'Invalid Date'
      *
     C                   MOVEL     'MMA1188'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        46
     C                   MOVE      'N'           WAVAL                          Invalid Date
      *
     C                   ELSE
     C                   MOVE      'Y'           WAVAL                          Valid Date Form
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      'Y'           WAVAL                          Valid Date Form
     C                   ENDIF
      *
      ** Read all Deals for Date entered and check if the
      ** Interest period is closed.
      *
     C                   MOVE      #0BSRC        WBSRC
     C                   MOVE      'Y'           WPASS1            1
     C                   MOVE      'Y'           WMATCH            1
      *
     C     WPTDV         IFEQ      'Y'
     C     #0DAT1        ANDNE     *BLANK
     C     WWVALA        ANDEQ     'Y'
      *
     C                   MOVE      'N'           WFND2             1
     C                   MOVE      ZDAYNO        WKBSD             5 0
     C                   MOVE      ZDAYNO        WIDAT             5 0
     C     KKON4         SETLL     DLDOISD4
     C     KKON4         READE     DLDOISD4                               53
     C     *IN53         DOWEQ     *OFF
      *
     C                   MOVE      L1DLNO        DLNO
     C     DLNO          CHAIN     DEALSDGF                           50
     C     *IN50         IFEQ      '0'
     C     RECI          ANDEQ     'D'
      *
     C     #0CCY         IFEQ      UCUCY
     C     WBSRC         ANDEQ     UBRTT
     C     #0CCY         OREQ      TCUCY
     C     WBSRC         ANDEQ     TBRTT
      *
     C     UICFR         IFEQ      'O'
     C     ZDAYNO        ANDLT     USLIP
     C                   MOVEL     'MMA1205'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        46
     C                   MOVE      'N'           WAVAL                          Invalid Date
     C                   MOVE      'N'           WWVALA
     C                   ENDIF
      *
     C     TICFR         IFEQ      'O'
     C     ZDAYNO        ANDLT     TSLIP
     C                   MOVEL     'MMA1205'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        46
     C                   MOVE      'N'           WAVAL                          Invalid Date
     C                   MOVE      'N'           WWVALA
     C                   ENDIF
      *
     C     L1AMNT        IFNE      0
     C                   MOVEL     'MMA1256'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        46
     C                   MOVE      'N'           WAVAL                          Invalid Date
     C                   MOVE      'N'           WWVALA
     C                   ENDIF
      *
     C     UICFR         IFEQ      'O'
     C     TICFR         OREQ      'O'
      *
     C     WPASS1        IFEQ      'N'
     C     L1APDY        ANDNE     WAPDY
     C     L1RTYP        ANDNE     'GUESS   '                                                 223045
     C     L1RTYP        ANDNE     'COMPOUND'                                                 223045
     C                   MOVE      'N'           WMATCH
     C                   ENDIF
      *
     C                   MOVE      'N'           WPASS1
     C                   Z-ADD     L1APDY        WAPDY             3 0
     C                   MOVE      'Y'           WFND2
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
     C     KKON4         READE     DLDOISD4                               53
     C                   ENDDO
      *
      ** Send message 'Not all App Days are equal for this Date'
      *
     C     WMATCH        IFEQ      'N'
     C     WWVALA        ANDEQ     'Y'
     C                   MOVEL     'MMA1257'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        46
     C                   MOVE      'N'           WAVAL                          Invalid Date
     C                   MOVE      'N'           WWVALA
     C                   ENDIF
      *
      ** Send message 'Record for date DDMMYY not on file'.
      ** if not in Insert mode.
      *
     C     #0ACTN        IFNE      'I'
     C     WFND2         ANDEQ     'N'
     C     WWVALA        ANDEQ     'Y'
     C                   MOVEL     'MMA1204'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        46
     C                   MOVE      'N'           WAVAL                          Invalid Date
     C                   MOVE      'N'           WWVALA
     C                   ENDIF
      *
      ** Send message 'Record for this date already exists',
      ** if in Insert mode.
     C     #0ACTN        IFEQ      'I'
     C     WFND2         ANDEQ     'Y'
     C     WWVALA        ANDEQ     'Y'
     C                   MOVEL     'MMA1258'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        46
     C                   MOVE      'N'           WAVAL                          Invalid Date
     C                   MOVE      'N'           WWVALA
     C                   ENDIF
      *
      ** Send message 'Date has to be less than Run Date',
      ** if in Insert mode and Date entered is greater than Rundate.
     C     #0ACTN        IFEQ      'I'
     C     ZDAYNO        ANDGE     BJRDNB
     C     WWVALA        ANDEQ     'Y'
     C                   MOVEL     'MMA1255'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        46
     C                   MOVE      'N'           WAVAL                          Invalid Date
     C                   MOVE      'N'           WWVALA
     C                   ENDIF
      *
      ** Send message 'Today's Record can not be Deleted',
      ** if in Delete mode and Date entered equals Rundate.
     C     WFND2         IFEQ      'Y'
     C     #0ACTN        ANDEQ     'D'
     C     ZDAYNO        ANDEQ     BJRDNB
     C     WWVALA        ANDEQ     'Y'
     C                   MOVEL     'MMA1259'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        46
     C                   MOVE      'N'           WAVAL                          Invalid Date
     C                   MOVE      'N'           WWVALA
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Applicable Days
      *
     C     WAVAL         IFEQ      'Y'                                          For Valid Currency
     C     WWVALA        ANDEQ     'Y'
      *
     C     #0APD1        IFNE      *BLANK
     C                   Z-ADD     3             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   MOVE(P)   #0APD1        ZFIELD
     C                   EXSR      ZALIGN
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        WZERO             3
      *
     C     *IN99         IFEQ      *ON
     C     WZERO         OREQ      '  0'
     C                   MOVEL     'MMA1260'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        47
     C                   MOVE      'N'           WAVAL
     C                   ELSE
     C                   MOVE      ZFIELD        #0APD1
     C                   MOVE      'Y'           WAVAL
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      'Y'           WAVAL
     C                   ENDIF
      *
      ** Error if Applicable Day is blank and Action code is not 'D'
      ** or blanks and Date is entered.
      *
     C     #0APD1        IFEQ      *BLANK
     C     #0DAT1        ANDNE     *BLANK
     C     #0ACTN        ANDNE     'D'
     C     #0ACTN        ANDNE     *BLANK
     C                   MOVEL     'MMA1261'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        47
     C                   MOVE      'N'           WAVAL
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If all details are valid, enable F6 for confirmation
      *
     C     WAVAL         IFEQ      'Y'
     C     WWVALA        ANDEQ     'Y'
      *
     C     #0ACTN        IFNE      *BLANKS
     C     #0DAT1        ANDNE     *BLANKS
     C     #0APD1        ANDNE     *BLANKS
     C     #0ACTN        OREQ      'D'
     C     #0DAT1        ANDNE     *BLANKS
     C                   MOVE      *ON           *IN06
     C                   ELSE
     C                   MOVE      *OFF          *IN06
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *OFF          *IN06
     C                   MOVE      *OFF          *IN32
     C                   ENDIF
      *
      ** Hide Applicable Days field if Deleting as it is not relevant
      *
     C     #0ACTN        IFEQ      'D'
     C                   MOVE      *BLANKS       #0APD1
     C                   MOVE      *ON           *IN32
     C                   ELSE
     C                   MOVE      *OFF          *IN32
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCONF - Process Confirm Request - Amend, Delete             *
      *                                                               *
      *  Called by : SRSFLP                                           *
      *  Calls     : SRUPDP, SRRECA                                   *
      *                                                               *
      *****************************************************************
     C     SRCONF        BEGSR
      *
      ** Read all Deals for Date entered and process Applicable Day,
      ** Re-calculate Interest and Update files.
      *
     C                   MOVE      #0BSRC        WBSRC
      *
     C     KKON4         SETLL     DLDOISD4
     C     KKON4         READE     DLDOISD4                               53
     C     *IN53         DOWEQ     *OFF
      *
      ** Bypass the update processing if record found is a GUESS or                           223045
      ** COMPOUND record.                                                                     223045
      *                                                                                       223045
     C     L1RTYP        IFNE      'GUESS   '                                                 223045
     C     L1RTYP        ANDNE     'COMPOUND'                                                 223045
      *                                                                                       223045
     C                   MOVE      L1DLNO        DLNO
     C     DLNO          CHAIN     DEALSDGF                           50
     C     *IN50         IFEQ      '0'
     C     RECI          ANDEQ     'D'
      *
     C     UICFR         IFEQ      'O'
     C     TICFR         OREQ      'O'
      *
      ** Re-calculate Interest and update file
     C     #0CCY         IFEQ      UCUCY
     C     WBSRC         ANDEQ     UBRTT
     C     #0CCY         OREQ      TCUCY
     C     WBSRC         ANDEQ     TBRTT
     C                   MOVE      L1OTCD        SIDE              1
     C                   Z-ADD     L1BSDT        WDYNO             5 0
     C                   EXSR      SRUPDP
     C                   EXSR      SRRECA
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      *                                                                                       223045
     C                   ENDIF                                                                223045
     C     KKON4         READE     DLDOISD4                               53
     C                   ENDDO
      *
      ** Re-Load Subfile
     C                   MOVE      'Y'           WRSF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCNFI - Process Confirm Request - Insert                    *
      *                                                               *
      *  Called by : SRSFLP                                           *
      *  Calls     : SRUPDP, SRRECA                                   *
      *                                                               *
      *****************************************************************
     C     SRCNFI        BEGSR
      *
      ** Read all Deals for Date entered and process Applicable Day,
      ** Re-calculate Interest and Update files.
      *
     C                   MOVE      #0BSRC        WBSRC
      *
     C     *LOVAL        SETLL     DLDOISD5
     C                   READ      DLDOISD5                               54
     C     *IN54         DOWEQ     *OFF
      *
     C                   MOVE      L1DLNO        DLNO
     C     DLNO          CHAIN     DEALSDGF                           50
     C     *IN50         IFEQ      '0'
     C     RECI          ANDEQ     'D'
      *
     C     UICFR         IFEQ      'O'
     C     TICFR         OREQ      'O'
      *
     C     #0CCY         IFEQ      UCUCY
     C     WBSRC         ANDEQ     UBRTT
     C     #0CCY         OREQ      TCUCY
     C     WBSRC         ANDEQ     TBRTT
     C                   MOVE      L1OTCD        SIDE              1
      *
      ** Find last record for this deal number
     C     KKLNO         SETLL     DLDOISD6
     C     KKLNO         READE     DLDOISD6                               56
     C     *IN56         DOWEQ     *OFF
      *
     C     L1BSDT        IFGT      WIDAT
     C                   LEAVE
     C                   ENDIF
      *
     C                   Z-ADD     L1DLNO        WKDLN
     C                   MOVE      L1OTCD        WKSID
     C                   Z-ADD     L1BSDT        WKDAT
      *
     C     KKLNO         READE     DLDOISD6                               56
     C                   ENDDO
      *
     C     *IN56         IFEQ      *OFF
     C     KKON3         CHAIN     DLDOISD5                           56
     C                   ENDIF
      *
      ** Re-calculate Interest and update file
     C                   Z-ADD     L1BSDT        WDYNO
     C                   EXSR      SRUPDP
     C                   EXSR      SRRECA
      *
      ** Position pointer to next deal number
     C                   Z-ADD     99999         WKDAT
     C     KKON3         SETGT     DLDOISD5
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      DLDOISD5                               54
     C                   ENDDO
      *
      ** Re-Load Subfile
     C                   MOVE      'Y'           WRSF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDP - Update previous records                             *
      *                                                               *
      *  Called by : SRCONF, SRCNFI                                   *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRUPDP        BEGSR
      *
     C     KPRVK         CHAIN     DLDOISL1                           89
      *
      ** Save Applicable Days record
     C     #0ACTN        IFEQ      'D'
     C                   DELETE    DLDOISD1
     C                   Z-ADD     L1BSDT        WDYNO
      *
     C                   ELSE
     C                   MOVE      #0APD1        L1APDY
      *
     C     #0ACTN        IFEQ      'I'
     C     KPRVK         SETLL     DLDOISL1                             89
     C                   READ      DLDOISL1                               89
     C                   MOVE      #0APD1        L1APDY
     C                   Z-ADD     WIDAT         L1BSDT
     C                   WRITE     DLDOISD1
     C                   Z-ADD     WIDAT         WDYNO
     C                   ELSE
     C                   UPDATE    DLDOISD1
     C                   ENDIF
     C                   ENDIF
      *
      ** Save values of deal and side being processed. Used to test and
      ** exit from this processing loop.
     C                   Z-ADD     L1DLNO        WDLNO             6 0
     C                   MOVEL     L1OTCD        WOTCD             1
      *
      ** Save compounding rate from previous record
     C     KPRVK         CHAIN     DLDOISL1                           89
     C     *IN89         DOWEQ     *OFF
      *
      ** Position to the last record updated
     C     L1RTYP        IFEQ      'COMPOUND'
     C*******************Z-ADD     L1CPRT        WCPRT            12 9                        221257
     C                   Z-ADD     L1CPRT        WCPRT            1915                        221257
     C                   Z-ADD     L1INRT        WINRT            12 9
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
      * 'GUESS' records cause divide by zero                                                  221257
     C     L1RTYP        ANDNE     'GUESS'                                                    221257
      *
      ** Calculate the new componding rate and interest rate for each
      ** of the following records for this deal.
      *
      **  Apply spread to the old base rate on the deal
     C*******************Z-ADD     L1BSRT        WWRATE           11 7                        221257
     C                   Z-ADD     L1BSRT        WWRATE           1915                        221257
      *
      ** Spread for our side.
      *
     C     L1OTCD        IFEQ      'O'
      *
     C     USPIN         IFEQ      'A'
     C     L1BSRT        ADD       URTSP         WWRATE
     C                   ENDIF
      *
     C     USPIN         IFEQ      'S'
     C     L1BSRT        SUB       URTSP         WWRATE
     C                   ENDIF
      *
     C     USPIN         IFEQ      'P'
     C*****L1BSRT********MULT      URTSP         WORK             11 7                        221257
     C     L1BSRT        MULT      URTSP         WORK             1915                        221257
     C     WORK          DIV       100           WORK
     C     L1BSRT        ADD       WORK          WWRATE
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Spread for their side
      *
     C     TSPIN         IFEQ      'A'
     C     L1BSRT        ADD       TRTSP         WWRATE
     C                   ENDIF
      *
     C     TSPIN         IFEQ      'S'
     C     L1BSRT        SUB       TRTSP         WWRATE
     C                   ENDIF
      *
     C     TSPIN         IFEQ      'P'
     C*****L1BSRT********MULT      TRTSP         WORK             11 7                        221257
     C     L1BSRT        MULT      TRTSP         WORK                                         221257
     C     WORK          DIV       100           WORK
     C     L1BSRT        ADD       WORK          WWRATE
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Multiply the adjusted rate by the number of applicable days
      ** on the deals extension file.
     C*****WWRATE********MULT(H)   L1APDY        WRESA            12 9                        221257
     C     WWRATE        MULT(H)   L1APDY        WRESA            1915                        221257
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
      * Convert date to YYYYMMDD format                                                       CIR013
     C                   EXSR      ZDATE9                                                     CIR013
     C                   Z-ADD     @@VDT         ZZDATA                                       CIR013
      *                                                                                       CIR013
     C                   Z-ADD     L1BSDT        @@DAYN                                       CIR013
      *                                                                                       CIR013
      * Convert date to YYYYMMDD format                                                       CIR013
     C                   EXSR      ZDATE9                                                     CIR013
     C                   Z-ADD     @@VDT         ZZDATB                                       CIR013
      *                                                                                       CIR013
      * Check for the existence of any February 29th within the dates                         CIR013
     C                   EXSR      #FEB29                                                     CIR013
     C                   ENDIF                                                                CIR013
      *
      ** Divide by Our/Their Calculation Basis
     C     L1OTCD        IFEQ      'O'
      *
     C     UICBS         IFEQ      1
     C     UICBS         OREQ      4
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C*****WRESA*********DIV(H)    36500         WRESB            12 9                        221257
     C     WRESA         DIV(H)    36500         WRESB            1915                        221257
     C                   ENDIF
      *
     C     UICBS         IFEQ      2
     C     UICBS         OREQ      3
     C     UICBS         OREQ      5
     C     UICBS         OREQ      7
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
     C     TICBS         OREQ      7
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
      ** Add 1 to the result
     C*****WRESB*********ADD       1             WRESC            12 9                        221257
     C     WRESB         ADD       1             WRESC            1915                        221257
      *
      ** Multiply the result by the compounding rate from the previous
      ** record to get this records compounding rate.
     C*****WRESC*********MULT(H)   WCPRT         WRESD            12 9                        221257
     C     WRESC         MULT(H)   WCPRT         WRESD            1915                        221257
     C                   Z-ADD(H)  WRESD         L1CPRT
      *
      ** Subtract one from the result
     C*****WRESD*********SUB       1             WRESE            12 9                        221257
     C     WRESD         SUB       1             WRESE            1915                        221257
      *
      ** Multiply by Our/Their Calculation Basis
     C     L1OTCD        IFEQ      'O'
      *
     C     UICBS         IFEQ      1
     C     UICBS         OREQ      4
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C*****WRESE*********MULT(H)   36500         WRESF            12 9                        221257
     C     WRESE         MULT(H)   36500         WRESF            1915                        221257
     C                   ENDIF
      *
     C     UICBS         IFEQ      2
     C     UICBS         OREQ      3
     C     UICBS         OREQ      5
     C     UICBS         OREQ      7
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
     C     TICBS         OREQ      7
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
      ** Find number of days since last payment
     C     L1OTCD        IFEQ      'O'
     C     L1BSDT        SUB       USLIP         WNUMD             3 0
     C                   ELSE
     C     L1BSDT        SUB       TSLIP         WNUMD
     C                   ENDIF
      *
      ** Divide the result by the number of days since last interest
      ** payment date.
     C     WNUMD         IFGT      0                                                          CIR013
     C*****WRESF*********DIV(H)    WNUMD         WRESG            12 9                        221257
     C     WRESF         DIV(H)    WNUMD         WRESG            1915                        221257
      *
      ** Update the extension file with this compound rate and interest
      ** rate.
     C                   Z-ADD(H)  WRESG         L1INRT
     C                   UPDATE    DLDOISD1
     C                   ENDIF                                                                CIR013
      *
     C                   ENDIF
      *
     C                   READP     DLDOISD1                               89
      *
      ** Exit the loop when all records for the deal and side have been
      ** processed.
     C     L1DLNO        IFNE      WDLNO
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
      *  Called by : SRCONF, SRCNFI                                   *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRRECA        BEGSR
      *
      ** Position to the last record on the file for the deal and side
      ** being amended.
     C     KKLNO         SETLL     DLDOISL1                             89
     C                   READ      DLDOISL1                               89
      *
      ** Set the From Date to be either USLIP if Ours of TSLIP if Theirs
     C     SIDE          IFEQ      'O'
     C                   Z-ADD     USLIP         WFDTE             5 0
     C                   ELSE
     C                   Z-ADD     TSLIP         WFDTE
     C                   ENDIF
      *
     C                   Z-ADD     *ZERO         PINTA
      *
      ** If a settlement record then interest amount due needs recalculated
      ** Call program DL1664 to calculate the base amount of interest due
     C     L1RTYP        IFEQ      'SETTLE'
     C                   CALL      'DL1664'
     C                   PARM      DLNO          PDEAL             6 0
     C                   PARM      SIDE          PSIDE             1
     C                   PARM      WFDTE         PFDTE             5 0
     C                   PARM      BJRDNB        PRDNB             5 0
     C                   PARM      *ZERO         PINTA            13 0
     C                   PARM      *BLANKS       PRTCD
      *
     C     SIDE          IFEQ      'O'
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
     C     SIDE          IFEQ      'O'
     C     TAXR          ANDNE     *ZERO
     C     TAXI          ANDEQ     'Y'
     C     TAXR          MULT(H)   PINTA         WRKTAX           15 0
      *
      ** Subtract the result from the interest amount
     C     PINTA         SUB       WRKTAX        PINTA
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     PINTA         L1AMNT
      *
      ** Update OIS Compouding history file
     C                   UPDATE    DLDOISD1
      *
      ** Update DEALSDG
     C     SIDE          IFEQ      'O'
     C                   Z-ADD     L1INRT        UEINR
     C                   ELSE
     C                   Z-ADD     L1INRT        TEINR
     C                   ENDIF
      *
     C                   UPDATE    DEALSDGF
      *
      ** Count number of Applicable Days for Deal
     C                   Z-ADD     0             WDYNO
     C                   Z-ADD     0             WTOTAL            5 0
     C                   MOVE      'Y'           WPASS             1
      *
     C     KPRVK         SETLL     DLDOISD2
     C     KKLNO         READE     DLDOISD2                               89
     C                   Z-ADD     L1BSDT        WSTRDT            5 0
     C     *IN89         DOWEQ     '0'
      *
      ** Don't count the Applicable Day of the first record
     C     WPASS         IFEQ      'N'
     C     L1APDY        ADD       WTOTAL        WTOTAL
     C                   ENDIF
      *
     C                   MOVE      'N'           WPASS
     C     KKLNO         READE     DLDOISD2                               89
     C                   ENDDO
      *
     C                   Z-ADD     L1BSDT        WENDDT            5 0
      *
      ** Check if total matches number of days.
     C                   MOVE      'Y'           WAPPD             1
     C     WENDDT        SUB       WSTRDT        WDAYS             5 0
      *
     C     WTOTAL        IFNE      WDAYS
     C                   MOVE      'N'           WAPPD
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLOAD - Load subfile with details                           *
      *                                                               *
      *  Called by : SRLDSF                                           *
      *  Calls     : ZDATE2, ZSEDIT                                   *
      *                                                               *
      *****************************************************************
     C     SRLOAD        BEGSR
      *
      ** Convert Base Rate Change date in to DDMMYY format
     C**********         MOVE      L1BSDT        ZDAYNO                                       245692
     C                   MOVE      L1BSRT        #0BSRT            9 7                        245692
     C                   MOVE      *BLANKS       ZFLD15                                       245692
     C                   MOVE      L1BSRT        ZFLD15                                       245692
     C                   Z-ADD     7             ZDECS                                        245692
     C                   MOVE      'J'           ZECODE                                       245692
     C                   EXSR      ZSEDIT                                                     245692
     C                   MOVE      ZOUT21        W#BSRT                                       245692
      *                                                                                       245692
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #0BSDT
      *
     C                   MOVE      L1BSRT        #0BSRT
     C                   MOVE      L1APDY        #0APDY
     C                   MOVE      L1DLNO        #0DLNO
     C                   MOVE      L1OTCD        #0OTCD
     C                   Z-ADD     L1CPRT        WXCPRT           11 7
     C**********         MOVE      WXCPRT        #0CPRT                                       245692
     C                   MOVE      WXCPRT        #0CPRT            8 7                        245692
     C                   MOVE      *BLANKS       ZFLD15                                       245692
     C                   MOVE      WXCPRT        ZFLD15                                       245692
     C                   Z-ADD     7             ZDECS                                        245692
     C                   MOVE      'J'           ZECODE                                       245692
     C                   EXSR      ZSEDIT                                                     245692
     C                   MOVE      ZOUT21        W#CPRT                                       245692
      *                                                                                       245692
     C                   Z-ADD     L1INRT        WXINRT           11 7
     C**********         MOVE      WXINRT        #0INRT                                       245692
     C                   MOVE      WXINRT        #0INRT            9 7                        245692
     C                   MOVE      *BLANKS       ZFLD15                                       245692
     C                   MOVE      WXINRT        ZFLD15                                       245692
     C                   Z-ADD     7             ZDECS                                        245692
     C                   MOVE      'J'           ZECODE                                       245692
     C                   EXSR      ZSEDIT                                                     245692
     C                   MOVE      ZOUT21        W#INRT                                       245692
      *
      ** Call ZSEDIT for fields where decimal places depend on deal
      ** currency.  ZSEDIT Inserts sign, commas and a decimal point
      ** into numeric field and blanks out leading zeros.
      *
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      L1AMNT        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        #0AMT
      *
     C     L1RTYP        IFNE      'SETTLE'
     C     L1AMNT        ANDEQ     *ZEROS
     C                   MOVE      *BLANKS       #0AMT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTERM - Terminate program                                   *
      *                                                               *
      *  Called by : Main processing                                  *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRTERM        BEGSR
      *
     C                   COMMIT
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCLR - Clear all display fields and the message queue       *
      *                                                               *
      *  Called by : SRVINS                                           *
      *  Calls     : Y2CLMSC                                          *
      *****************************************************************
     C     SRCLR         BEGSR
      *
     C                   MOVE      *BLANKS       #0CCY
     C                   MOVE      *BLANKS       #0BSRC
     C                   MOVE      *BLANKS       #0PDAT
     C                   MOVE      *BLANKS       #0ACTN
     C                   MOVE      *BLANKS       #0DAT1
     C                   MOVE      *BLANKS       #0APD1
      *
      ** Clear Subfile  and erase Subfile control from the screen
      *
     C                   MOVE      '1'           *IN80                          Clear SFL
     C                   WRITE     DL1643C0
     C                   MOVE      '0'           *IN80
      *
     C                   EXSR      SRCLRM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCLRM - Clear error message queue                           *
      *                                                               *
      *  Called by : SRVINS, SRSFLP, SRSCRN, SRCLR                    *
      *  Calls     : Y2CLMSC                                          *
      *****************************************************************
     C     SRCLRM        BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      #0PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ZASNMS - Sends messages to the program's message queue       *
      *                                                               *
      *  Called by : Almost all screens with validation               *
      *  Calls     : Y2SNMGC                                          *
      *****************************************************************
     C     ZASNMS        BEGSR
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     #0PGM         ZAPGMQ
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     WERR          IFEQ      *BLANK
     C                   MOVE      'Y'           WERR              1
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   ROLBK
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C*COPY*ZSRSRC,ZDATE1Z2                                                                   221257
     C/COPY ZSRSRC,ZDATE1Z2LE                                                                 221257
      /EJECT
      *COPY*ZSRSRC,ZDATE2Z2                                                                   221257
      /COPY ZSRSRC,ZDATE2Z2LE                                                                 221257
      /EJECT
     C*COPY*ZSRSRC,ZSEDITZ3                                                                   221257
     C*COPY*ZSRSRC,ZSEDITZ3LE***                                                       221257 245692
     C/COPY ZSRSRC,ZSEDITZ4LE                                                                 245692
      /EJECT
     C*COPY*ZSRSRC,ZEDITZ2                                                                    221257
     C/COPY ZSRSRC,ZEDITZ2LE                                                                  221257
      /EJECT
     C*COPY*ZSRSRC,ZALIGNZ2                                                                   221257
     C/COPY ZSRSRC,ZALIGNZ2LE                                                                 221257
      /EJECT                                                                                  CIR013
     C*COPY*ZSRSRC,ZDATE9Z3                                                                   CIR013
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 CIR013
      /EJECT                                                                                  CIR013
     C*COPY*ZSRSRC,ZFEB29                                                                     CIR013
     C/COPY ZSRSRC,ZFEB29Z2LE                                                                 CIR013
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
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
