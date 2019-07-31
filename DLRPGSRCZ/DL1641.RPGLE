     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *                       220859
/*EXI *  TEXT('Midas DL OIS compounding interest rate enq/amend')     *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL1641 - Midas OIS Compounding Interest Rate Enquiry/Amend   *
      *                                                               *
      *  Function:  This program displays, in a subfile, compounding  *
      *  (I/C)      interest rate records for an OIS deal.            *
      *                                                               *
      *  Called By: DLC1641 - Midas OIS Compounding Interest Rate     *
      *                       Enquiry/Amend                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD051713           Date 08Sep18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 245692             Date 10Dec13               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 246529             Date 30Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 240334             Date 17Jan07               *
      *                 238193             Date 22Aug06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG6693            Date 28Feb06               *
      *                 BUG6043            Date 28Feb06               *
      *                 226723             Date 28Feb06               *
      *                 224925             Date 28Feb06               *
      *                 220859             Date 28Feb06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 214440             Date 30Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      *                 204440             Date 01Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007  *CREATE    Date 11May01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD051713 - Incorrect rates are displayed on OIS Compounding  *
      *             Interest Rate Enquiry screen.(Recompile)          *
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
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  246529 - Applied 1.2 core fix 241477.                        *
      *  241477 - Amend work fields used in ZSEDITZLE.                *
      *  240334 - Recompile over changes in ZACCHLE.                  *
      *  238193 - Recompiled due to changes in display file DL1641DF. *
      *           Applied BUG6043 and BUG6693.                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG6693 - Interest Column from the OIS Compounding Enquiry   *
      *            has disappeared (Recompile)                        *
      *  BUG6043 - Compounding rate incorrectly displayed.            *
      *            Change to DL1641DF. Recompile.                     *
      *  226723 - Recompiled due to change in display file DL1941DF.  *
      *  224925 - Allow enquiry of matured OIS deal rates; disable    *
      *           amend function keys if loan matured.                *
      *  220859 - Increase the size of Compounding Rate again from    *
      *           9 to 15 decimal places. DL1641 was converted to ILE *
      *           due to the change in the number of decimal places.  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  214440 - New function to Amend Applicable Days for all Deals *
      *           (OIS)                                               *
      *  204923 - Rate Fix Days Adjustment (OIS)                      *
      *  204440 - Additional validation for 'Position to Date'        *
      *  CIR007 - Overnight Index Swaps                               *
      *                                                               *
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT - Initialisation of Program                           *
      *  SRVINS - Initial Screen Processing                           *
      *  SRSFLP - Subfile Processing                                  *
      *  SRVALD - Data Validation                                     *
      *  SRCLR  - Clear all display fields, subfile and error msg queu*
      *  SRCLRM - Clears error message                                *
      *  SRBSFL - Build Subfile                                       *
      *  SRSCRN - Display whole screen including subfile              *
      *  SRAMEN - Amend data. Calls program DL1652                    *
      *  SRINST - Insert data. Calls program DL1652                   *                       214440
      *  SRDELT - Delete data. Calls program DL1652                   *                       214440
      *  SRPROC - Process ENTER command.  Revalidate data             *
      *  SRLOAD - Load Subfile display fields                         *
      *  SRREFR - F5=Refresh Processing                               *
      *  SRAUDT - Process audit report                                *
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
      ****09**-*F9*Amend***********************************************                       214440
      ****08**-*F8*Amend***********************************************                214440 224925
      ****09**-*F9*Insert**********************************************                214440 224925
      ****10**-*F10ADelete*********************************************                214440 224925
      *   15  - Enable F8 Amend                                       *                       224925
      *   16  - Enable F9 Insert                                      *                       224925
      *   17  - Enable F10 Delete                                     *                       224925
      *   12  - Previous Screen                                       *
      *   22  - Rollup                                                *
      *   31  - Display deal detail                                   *
      *   40  - Error on Deal Number                                  *
      *   41  - Error on Deal Side                                    *
      *   42  - Error on Position to Date                             *
      *   50  - Error on Chain to DEALSDG                             *
      *   52  - Error on Chain to DLDOISL2                            *
      *   54  - Error on READP to DLDOISL2                            *
      *   55  - Error on READ to DLDOISL2                             *
      *   60  - Call to program DL1652  Amend request                 *
      *   61  - Call to program DL1658  Audit Report                  *
      *   81  - Display Subfile                                       *
      *   82  - End of Subfile                                        *
      *   83  - Erase Record Format DL1641S0 (SFL)                    *
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
      *****************************************************************
     FDEALSALL  IF   E           K DISK                                                       224925
     F                                     IGNORE(DEALSDBF)                                   224925
     F                                     IGNORE(DEALSDCF)                                   224925
     F                                     IGNORE(DEALSDDF)                                   224925
     F                                     IGNORE(DEALSDEF)                                   224925
     F                                     IGNORE(DEALSDGF)                                   224925
     F                                     IGNORE(MMDELDP0)                                   224925
     F                                     IGNORE(MMDENBP0)                                   224925
     F                                     IGNORE(MMDENSP0)                                   224925
     F                                     IGNORE(FXDEALP0)                                   224925
     F                                     IGNORE(DLBHISD0)                                   224925
     F                                     IGNORE(DLCHISD0)                                   224925
     F                                     IGNORE(DLDHISD0)                                   224925
     F                                     IGNORE(DLEHISD0)                                   224925
      *
      ** Logical file built over DLDOISPD
     FDLDOISL2  IF   E           K DISK
     FDLOISSL3  IF   E           K DISK                                                       204923
      *
      ** Logical file built over DEALSDG
     FDEALS     IF   E           K DISK
     F                                     COMMIT
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
      *
      ** Display file
     FDL1641DF  CF   E             WORKSTN
     F                                     INFDS(INFDS1)
     F                                     SFILE(DL1641S0:RRN)
      *
      *****************************************************************
      *
      /EJECT
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D*COPY ZSRSRC,ZSEDITZ1                                                                   220859
     D*COPY*ZSRSRC,ZSEDITZ1LE                                                          220859 241477
     D*ZS2******       S              1    DIM(21)                                     241477 245692
     D ZS2             S              1    DIM(26)                                            245692
      *
     D*COPY ZSRSRC,ZDATE2Z1                                                                   220859
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                 220859
      *
     D*COPY ZSRSRC,ZALIGNZ1                                                                   220859
     D/COPY ZSRSRC,ZALIGNZ1LE                                                                 220859
      *
     D*COPY ZSRSRC,ZHOLE                                                               204923 220859
     D/COPY ZSRSRC,ZHOLELE                                                                    220859
      ** Array for holiday checking                                                           204923
      *                                                                                       204923
      /SPACE 3
      *
      ** Display File information data structure
     D INFDS1        E DS                  EXTNAME(Y2I#DSP)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Program Status Data Structure
     D PSDS           SDS
     D  #1PGM            *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      ** Data Structure for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Data Structure for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Data Structure for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  245692
     D QQACC1        E                     EXTFLD(QQACCD)                                     245692
      ** Data Structure to retrieve DEALING ICD details                                       245692
                                                                                              245692
      *
      ** Data structure for holiday checking                                                  204923
     D*COPY ZSRSRC,ZHOLI                                                               204923 220859
     D/COPY ZSRSRC,ZHOLILE                                                                    220859
      *                                                                                       204923
      ** First DS for access programs, shirt data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D*COPY ZSRSRC,ZSEDITZ2                                                                   220859
     D                 DS                                                                     220859
     D**WORK15**               1     15  0                                             220859 245692
     D**ZS1*****               1     15  0                                             241477 245692
     D**********                           DIM(15)                                     241477 245692
     D  WORK15                 1     19  0                                                    245692
     D  ZS1                    1     19  0                                                    245692
     D                                     DIM(19)                                            245692
      *
      /EJECT
      /TITLE Main Processing
      *
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Perform Initialisation.
      *
     C                   EXSR      SRINIT
      *
     C     *IN03         DOUNE     '0'
      *
      ** Validate Initial Screen.
      *
     C                   EXSR      SRVINS
      *
      ** Process Subfile
      *
     C                   EXSR      SRSFLP
      *
     C                   ENDDO
      *
      ** Terminate Program
      *
     C                   SETON                                            LR
      *
      *================================================================
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initial Processing                                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     ZDATE2                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2             80
      *
      ** Initialise LDA field.
      *
     C                   MOVEL     'DL1641'      DBPGM
     C     *DTAARA       DEFINE                  LDA
      *
      ** Define message file to be used
      *
     C                   MOVEL     'DRSMM   '    ZAMSGF
      *
      ** Call Access Program to obtain Banks details from PF/SDBANKPD
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error.
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Obtain Midas Run Date
      *
     C                   MOVEL     BJMRDT        #0MRDT
     C                   MOVEL     USER          #0USER
     C                   MOVEL     WSID          #0WSID
      *
      ** Check System Date Format, DDMMYY (*IN98 off)
      ** MMDDYY (*IN98 on)
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   ENDIF
      *                                                                                       245692
      ** Call Access Program to obtain DEALING ICD Details from SDDEALPD                      245692
      *                                                                                       245692
     C                   CALL      'AODEALR0'                                                 245692
     C                   PARM      *BLANKS       PRTCD             7                          245692
     C                   PARM      '*FIRST '     POPTN             7                          245692
     C     SDDEAL        PARM      SDDEAL        DSFDY                                        245692
      *                                                                                       245692
      ** Database Error.                                                                      245692
      *                                                                                       245692
     C     PRTCD         IFNE      *BLANKS                                                    245692
     C     *LOCK         IN        LDA                                                        245692
     C                   MOVE      'SDDEALPD'    DBFILE                                       245692
     C                   Z-ADD     8             DBASE                                        245692
     C                   MOVEL     '*FIRST  '    DBKEY                                        245692
     C                   OUT       LDA                                                        245692
     C                   EXSR      *PSSR                                                      245692
     C                   ENDIF                                                                245692
      *
      ** Key List to access data from file PF/DLDOISPD via
      ** DLDOISL2
      *
     C     KKON3         KLIST
     C                   KFLD                    KKDLN             6 0
     C                   KFLD                    KKSID             1
     C                   KFLD                    KKDAT             5 0
      *
     C     KKON2         KLIST
     C                   KFLD                    KKDLN
     C                   KFLD                    KKSID
      *
      ** Initialise all working fields
      *
     C                   MOVE      'N'           WVALD             1
      *
     C                   MOVE      *BLANKS       WDLO              6
     C                   MOVE      *BLANKS       WSIDO             1
     C                   MOVE      *BLANKS       WPTDO             6
      *
      ** Fields used to check if the Deal number, Deal Side or the
      ** Position to Date have been validated.
      *
     C                   MOVE      *BLANKS       WVDLNO            1
     C                   MOVE      *BLANKS       WVSIDE            1
     C                   MOVE      *BLANKS       WVTODT            1
     C                   MOVE      *BLANKS       WVINDT            1
      *
      ** Set Subfile page size
      *
     C                   Z-ADD     10            WSFPG             3 0
     C                   Z-ADD     1             #0SFRN
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
     C                   Z-ADD     0             WMAX              5 0
     C                   Z-ADD     0             WRROK             5 0
     C                   MOVE      '0'           *IN81
      *
      ** Initialise Subfile Control
      *
     C                   MOVE      *BLANKS       #0DLNO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVINS - Validate initial screen                             *
      *                                                               *
      *  Called by: Main routine                                      *
      *                                                               *
      *  Calls    : SRVALD - Validation processing                    *
      *             SRTERM - End program                              *
      *                                                               *
      *****************************************************************
      *
     C     SRVINS        BEGSR
      *
      ** Display initial screen until F3 is pressed or all the
      ** fields have been validated
      *
     C     *INKC         DOWEQ     '0'
     C     WVALD         ANDEQ     'N'
      *
     C                   MOVE      '0'           *IN31
     C                   WRITE     DL1641F0
      *
      ** Write error message
      *
     C                   WRITE     DL1641C1
      *
     C                   MOVE      '0'           *IN81
     C                   MOVE      '1'           *IN83
      *
     C                   EXFMT     DL1641C0
      *
      ** Clear error message queue
      *
     C                   EXSR      SRCLRM
      *
     C                   MOVE      '0'           *IN83
      *
     C                   MOVE      '0'           *IN40
     C                   MOVE      '0'           *IN41
     C                   MOVE      '0'           *IN42
      *
     C                   SELECT
      *
      ** If F12 is pressed, return to initial screen
      *
     C     *INKL         WHENEQ    '1'
     C                   EXSR      SRCLR
      *
      ** If F5 is pressed, re-display screen with refreshed details
      *
     C     *INKE         WHENEQ    '1'
      *
     C                   MOVE      WDLO          #0DLNO
     C                   MOVE      WSIDO         #0SIDE
     C                   MOVE      WPTDO         #0PDAT
      *
     C     *INKC         WHENNE    '1'
      *
     C                   EXSR      SRVALD
      *
     C                   ENDSL
      *
     C     *INKC         IFEQ      '0'
     C     *INKE         ANDEQ     '0'
      *
     C     WVDLNO        IFEQ      'N'
     C     WVSIDE        OREQ      'N'
     C     WVTODT        OREQ      'N'
     C     WVINDT        OREQ      'N'
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
      ** Store old valid data for refresh
      *
     C                   MOVE      #0DLNO        WDLO
     C                   MOVE      #0SIDE        WSIDO
     C                   MOVE      #0PDAT        WPTDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALD - Validate Deal Number, Our/Their Side and            *
      *           Position to Date                                    *
      *                                                               *
      *  Called by: SRVINS                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRVALD        BEGSR
      *
     C                   MOVE      'Y'           WVDLNO
     C                   MOVE      'Y'           WVSIDE
     C                   MOVE      'Y'           WVTODT
      *
     C     #0DLNO        IFEQ      *BLANK
      *
      ** Send message 'Deal Number must be entered'
      *
     C                   MOVEL     'MMA1183'     ZAMSID
     C                   EXSR      SRMSGQ
     C                   MOVEA     '111'         *IN(40)
      *
      ** Deal number invalid
      *
     C                   MOVE      'N'           WVDLNO
      *
     C                   ENDIF
      *
     C     #0DLNO        IFNE      *BLANKS
      *
      ** Check if Deal Number is numeric
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #0DLNO        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
     C                   EXSR      ZALIGN
      *
     C     *IN99         IFEQ      '0'
      *
      ** Deal number is numeric
      *
     C                   MOVE      #0DLNO        DLNO
      *
      ** Chain to PF/DEALSDG via logical file DEALS using record
      ** Format name DEALSDGF
      *
     C     DLNO          CHAIN     DEALSDGF                           50
      *
     C                   ENDIF
      *                                                                                       224925
      ** Chain to PF/DLGHISD0 if record no longer in DEALSDG file; disable                    224925
      ** amend function if deal no longer in DEALSDG file.                                    224925
      *                                                                                       224925
     C                   MOVE      *ON           W#DG              1                          224925
      *                                                                                       224925
     C     *IN50         IFEQ      *ON                                                        224925
     C                   MOVE      *OFF          W#DG                                         224925
     C     DLNO          CHAIN     DLGHISD0                           50                      224925
     C                   ENDIF                                                                224925
      *
     C     *IN99         IFEQ      '1'
     C     *IN50         OREQ      '1'
      *
      ** Send message 'Deals Number does not exist'
      *
     C                   MOVEL     'MMA1184'     ZAMSID
     C                   EXSR      SRMSGQ
     C                   MOVE      '1'           *IN40
      *
     C                   MOVE      'N'           WVDLNO
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Deal Side
      *
     C     WVDLNO        IFEQ      'Y'
      *
     C     #0SIDE        IFNE      'O'
     C     #0SIDE        ANDNE     'T'
     C     #0SIDE        ANDNE     *BLANKS
      *
      ** Send message 'Ourside/Theirside must be 'O' or 'T' or ' '
      *
     C                   MOVEL     'MMA1185'     ZAMSID
     C                   EXSR      SRMSGQ
     C                   MOVE      '1'           *IN41
      *
     C                   MOVE      'N'           WVSIDE
      *
     C                   ENDIF
      *
     C     #0SIDE        IFEQ      *BLANKS
      *
     C                   SELECT
      *
      ** Error: Both sides of the deal are OIS
      *
     C     UICFR         WHENEQ    'O'
     C     TICFR         ANDEQ     'O'
     C                   MOVEL     'MMA1187'     ZAMSID
     C                   EXSR      SRMSGQ
     C                   MOVE      '1'           *IN41
     C                   MOVE      'N'           WVSIDE
      *
      ** Error: Both sides of the deal are not OIS
      *
     C     UICFR         WHENNE    'O'
     C     TICFR         ANDNE     'O'
     C                   MOVEL     'MMA1190'     ZAMSID
     C                   EXSR      SRMSGQ
     C                   MOVE      '1'           *IN41
     C                   MOVE      'N'           WVSIDE
      *
     C                   OTHER
     C     UICFR         IFEQ      'O'
     C                   MOVE      'O'           #0SIDE
     C                   ELSE
     C     TICFR         IFEQ      'O'
     C                   MOVE      'T'           #0SIDE
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C     #0SIDE        IFEQ      'O'
     C     UICFR         ANDNE     'O'
      *
      **  Send message 'Specified deal and side is not an OIS'
      *
     C                   MOVEL     'MMA1186'     ZAMSID
     C                   EXSR      SRMSGQ
     C                   MOVE      '1'           *IN41
      *
     C                   MOVE      'N'           WVSIDE
      *
     C                   ENDIF
      *
     C     #0SIDE        IFEQ      'T'
     C     TICFR         ANDNE     'O'
      *
      ** Send message 'Specified deal and side is not an OIS'
      *
     C                   MOVEL     'MMA1186'     ZAMSID
     C                   EXSR      SRMSGQ
     C                   MOVE      '1'           *IN41
      *
     C                   MOVE      'N'           WVSIDE
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Position to Date
      *
     C     WVDLNO        IFEQ      'Y'
      *                                                                                       204923
     C                   MOVE      UCUCY         PCURR                                        204923
      *                                                                                       204923
     C                   CALL      'AOCURRR0'                                                 204923
     C                   PARM      *BLANKS       PRTCD                                        204923
     C                   PARM      '*KEY    '    POPTN                                        204923
     C                   PARM                    PCURR             3                          204923
     C     SDCURR        PARM      SDCURR        DSSDY                                        204923
      *                                                                                       204923
     C     PRTCD         IFNE      *BLANK                                                     204923
     C     *LOCK         IN        LDA                                                        204923
     C                   MOVEL     'SDCURRPD'    DBFILE                                       204923
     C                   Z-ADD     6             DBASE                                        204923
     C                   MOVEL     PCURR         DBKEY                                        204923
     C                   OUT       LDA                                                        204923
     C                   EXSR      *PSSR                                                      204923
     C                   ENDIF                                                                204923
      *                                                                                       204923
      ** If rate fix days adjustment is not 0, get the previous working day.                  204923
      *                                                                                       204923
     C     A6FXDY        IFNE      0                                                          204923
     C                   Z-ADD     A6FXDY        ZNRDYS                                       204923
     C                   MOVEL     BJLCCY        ZCCY                                         204923
     C                   Z-ADD     BJRDNB        ZDAYNO                                       204923
     C                   EXSR      ZBKDT                                                      204923
     C                   Z-ADD     ZDYNBR        WDATE             5 0                        204923
     C                   ENDIF                                                                204923
      *
     C     #0PDAT        IFNE      *BLANK
      *
      ** Check if Position to Date is numeric
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #0PDAT        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
     C                   EXSR      ZALIGN
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      #0PDAT        ZDATE
     C                   EXSR      ZDATE1
     C                   ENDIF
      *
     C     *IN99         IFEQ      '1'
      *
      ** Send message 'Invalid Date'
      *
     C                   MOVEL     'MMA1188'     ZAMSID
     C                   EXSR      SRMSGQ
     C                   MOVE      '1'           *IN42
     C                   MOVE      'N'           WVTODT
      *
     C                   ELSE
      *
      ** Send message 'Position to Date must not be after Run Date'
      *
     C     ZDAYNO        IFGT      BJRDNB
     C                   MOVEL     'MMA1191'     ZAMSID
     C                   EXSR      SRMSGQ
     C                   MOVE      '1'           *IN42
     C                   MOVE      'N'           WVTODT
      *
     C                   ELSE
      *
      ** Send message 'Position to Date must not be after Maturity Date'
      *
     C     ZDAYNO        IFGT      MDAT
     C                   MOVEL     'MMA1208'     ZAMSID
     C                   EXSR      SRMSGQ
     C                   MOVE      '1'           *IN42
     C                   MOVE      'N'           WVTODT
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If no position to date has been entered, by default,
      ** start the enquiry at 7 days before rundate.
      *
     C     BJRDNB        SUB       7             WDFTD             5 0
      *
     C                   Z-ADD     WDFTD         ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #0PDAT
     C                   MOVE      #0PDAT        ZDATE
     C                   EXSR      ZDATE1
      *
     C     ZDAYNO        IFGT      MDAT
     C                   MOVEL     'MMA1208'     ZAMSID
     C                   EXSR      SRMSGQ
     C                   MOVE      '1'           *IN42
     C                   MOVE      'N'           WVTODT
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Check if record is present on PF/DLDOISPD for the deal specified
      *
     C     WVDLNO        IFEQ      'Y'
     C     WVSIDE        ANDEQ     'Y'
      *                                                                                       204440
      ** Save present key field values of LF/DLDOISL2.                                        204440
      *                                                                                       204440
     C                   Z-ADD     L1DLNO        WRKDLN            6 0                        204440
     C                   MOVE      L1OTCD        WRKSID            1                          204440
     C                   Z-ADD     L1BSDT        WRKDAT            5 0                        204440
      *                                                                                       204440
     C                   MOVE      #0DLNO        L1DLNO
     C                   MOVE      #0SIDE        L1OTCD
      *
     C     L1DLNO        CHAIN     DLDOISL2                           52
      *
     C     *IN52         IFEQ      '1'
      *
      ** Send message 'Interest details are not available until after
      ** the first COB or after Value Date'
      *
     C                   MOVEL     'MMA1189'     ZAMSID
     C                   EXSR      SRMSGQ
     C                   MOVE      'N'           WVDLNO
      *
     C                   ELSE                                                                 204440
      *                                                                                       204440
      ** Check if records are found for dates within Position to Date and rundate.            204440
      *                                                                                       204440
     C     WVTODT        IFEQ      'Y'                                                        204440
      *                                                                                       204440
     C                   MOVE      #0PDAT        ZDATE                                        204440
     C                   EXSR      ZDATE1                                                     204440
     C                   MOVE      ZDAYNO        KKDAT                                        204440
      *                                                                                       204440
     C                   MOVE      #0DLNO        KKDLN                                        204440
     C                   MOVE      #0SIDE        KKSID                                        204440
      *                                                                                       204440
     C     KKON3         SETLL     DLDOISD0                                                   204440
     C     KKON2         READE     DLDOISD0                               56                  204440
      *                                                                                       204923
     C     *IN56         IFEQ      '0'                                                        204923
     C     A6FXDY        ANDNE     0                                                          204923
     C     L1BSDT        ANDEQ     WDATE                                                      204923
      *                                                                                       204923
     C     L1DLNO        CHAIN     DLOISSL3                           56                      204923
     C     *IN56         IFEQ      '0'                                                        204923
     C     L5RFIN        ANDNE     'Y'                                                        204923
      *                                                                                       204923
     C     *IN56         OREQ      '0'                                                        204923
     C     L5RFIN        ANDEQ     'Y'                                                        204923
     C     KKSID         ANDEQ     'O'                                                        204923
     C     UNIPD         ANDNE     WDATE                                                      204923
      *                                                                                       204923
     C     *IN56         OREQ      '0'                                                        204923
     C     L5RFIN        ANDEQ     'Y'                                                        204923
     C     KKSID         ANDEQ     'T'                                                        204923
     C     TNIPD         ANDNE     WDATE                                                      204923
     C                   MOVE      '1'           *IN56                                        204923
     C                   ENDIF                                                                204923
      *                                                                                       204923
     C                   ENDIF                                                                204923
      *                                                                                       204440
      ** If no record found, send error message.                                              204440
      *                                                                                       204440
     C     *IN56         IFEQ      '1'                                                        204440
     C                   MOVEL     'MMA1245'     ZAMSID                                       204440
     C                   EXSR      SRMSGQ                                                     204440
     C                   MOVE      '1'           *IN42                                        204440
     C                   MOVE      'N'           WVTODT                                       204440
      *                                                                                       204440
     C                   ENDIF                                                                204440
     C                   ENDIF
      *                                                                                       204440
      ** Restore file pointer.                                                                204440
      *                                                                                       204440
     C                   Z-ADD     WRKDLN        KKDLN                                        204440
     C                   MOVE      WRKSID        KKSID                                        204440
     C                   Z-ADD     WRKDAT        KKDAT                                        204440
     C     KKON3         CHAIN     DLDOISD0                           56                      204440
     C                   ENDIF                                                                204440
      *                                                                                       204440
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSFLP - Subfile processing                                  *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls    : SRLOAD                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRSFLP        BEGSR
      *
      ** Perform this loop until cmd3 or F12 is pressed
      *
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
      *
      ** Convert Midas day number into DDMMYY format
      *
     C                   Z-ADD     DDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         #0DDAT
      *
     C                   Z-ADD     VDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         #0VDAT
      *
     C                   Z-ADD     MDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         #0MDAT
      *
     C     #0SIDE        IFEQ      'O'
     C                   MOVE      UCUCY         #0CCYD
      *
      ** Next Interest Date for OUR side.
      *
     C     UNIPD         IFEQ      *ZEROS
     C                   MOVE      *BLANKS       #0NIND
     C                   ELSE
     C                   Z-ADD     UNIPD         ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #0NIND
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     #0SIDE        IFEQ      'T'
      *
     C                   MOVE      TCUCY         #0CCYD
      *
      ** Next Interest Date for THEIR side.
      *
     C     TNIPD         IFEQ      *ZEROS
     C                   MOVE      *BLANKS       #0NIND
     C                   ELSE
     C                   Z-ADD     TNIPD         ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #0NIND
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Retrieve the customer short name from PF/SDCUSTPD
      *
     C                   MOVEL     CNUM          PCLKEY
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCLKEY           10
     C                   PARM                    PKYSTS            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
      *
      ** Database error if not found
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     PCLKEY        DBKEY
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     BBCSSN        #0CSNM
      *
      ** Access Currencies file to retrieve number of decimal places
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG    '    PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM                    #0CCYD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     #0CCYD        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      '0'           *IN80
     C                   MOVE      '0'           *IN82
     C                   MOVE      '0'           *IN83
     C                   MOVE      '0'           *IN54
     C                   MOVE      '0'           *IN55
     C                   MOVE      '0'           *IN22
     C                   MOVE      '0'           *IN40
     C                   MOVE      '0'           *IN41
     C                   MOVE      '0'           *IN42
      *
      ** Clear Error Message queue
      *
     C     WAPPD         IFNE      'N'                                                        214440
     C                   EXSR      SRCLRM
     C                   ENDIF                                                                214440
      *
      ** Clear Subfile
      *
     C                   MOVE      '1'           *IN80
     C                   WRITE     DL1641C0
     C                   MOVE      '0'           *IN80
      *
      ** Reset Number of records in subfile
      *
     C                   Z-ADD     0             WMAX
     C                   MOVE      '0'           *IN81
      *
      ** Position and read DBF File
      *
     C                   MOVE      #0PDAT        ZDATE
     C                   EXSR      ZDATE1
     C                   MOVE      ZDAYNO        KKDAT
      *
     C                   MOVE      #0DLNO        KKDLN
     C                   MOVE      #0SIDE        KKSID
      *
     C     KKON3         SETLL     DLDOISD0
     C     KKON2         READE     DLDOISD0                               55
      *                                                                                       204923
     C     *IN55         IFEQ      '0'                                                        204923
     C     A6FXDY        ANDNE     0                                                          204923
     C     L1DLNO        CHAIN     DLOISSL3                           57                      204923
     C     *IN57         IFEQ      '0'                                                        204923
     C     L5RFIN        ANDNE     'Y'                                                        204923
      *                                                                                       204923
     C     *IN57         OREQ      '0'                                                        204923
     C     L5RFIN        ANDEQ     'Y'                                                        204923
     C     KKSID         ANDEQ     'O'                                                        204923
     C     UNIPD         ANDNE     WDATE                                                      204923
      *                                                                                       204923
     C     *IN57         OREQ      '0'                                                        204923
     C     L5RFIN        ANDEQ     'Y'                                                        204923
     C     KKSID         ANDEQ     'T'                                                        204923
     C     TNIPD         ANDNE     WDATE                                                      204923
     C                   MOVE      '1'           *IN57                                        204923
     C                   ENDIF                                                                204923
     C                   ENDIF                                                                204923
      *
      ** Only do subfile processing if required records are found
      *
     C     *IN55         IFEQ      *OFF
     C     A6FXDY        ANDEQ     0                                                          204923
      *                                                                                       204923
     C     A6FXDY        ORNE      0                                                          204923
     C     *IN55         ANDEQ     *OFF                                                       204923
     C     L1BSDT        ANDLT     WDATE                                                      204923
      *                                                                                       204923
     C     A6FXDY        ORNE      0                                                          204923
     C     *IN55         ANDEQ     *OFF                                                       204923
     C     L1BSDT        ANDEQ     WDATE                                                      204923
     C     *IN57         ANDNE     '1'                                                        204923
      *
      ** Load subfile page
      *
     C                   EXSR      SRBSFL
      *
     C                   MOVEL     'N'           WRELOD            1
      *
      ** Display screen until reload requested
      *
     C     WRELOD        DOWEQ     'N'
     C     *IN03         ANDEQ     '0'
      *
      ** Display screen until reload requested
      *
     C                   EXSR      SRSCRN
      *
     C                   SELECT
      *
      ** If F5 has been pressed, refresh screen
      *
     C     *IN05         WHENEQ    '1'
     C                   EXSR      SRREFR
      *
      ***If*F9*has*been*pressed,*process*Amend*************************                       214440
      ** If F8 has been pressed, process Amend                                                214440
      *
     C********** *IN09     WHEQ '1'                                                           214440
     C     *IN08         WHENEQ    '1'                                                        214440
     C                   EXSR      SRAMEN
      *                                                                                       214440
      ** If F9 has been pressed, process Insert                                               214440
      *                                                                                       214440
     C     *IN09         WHENEQ    '1'                                                        214440
     C                   EXSR      SRINST                                                     214440
      *                                                                                       214440
      ** If F10 has been pressed, process Delete                                              214440
      *                                                                                       214440
     C     *IN10         WHENEQ    '1'                                                        214440
     C                   EXSR      SRDELT                                                     214440
      *
      ** If F12 has been pressed, process Initial Screen
      *
     C     *IN12         WHENEQ    '1'
     C                   MOVE      'N'           WVALD
      *
     C     WAPPD         IFNE      'N'                                                        214440
     C                   MOVE      'Y'           WRELOD
     C                   ENDIF                                                                214440
      *
      ** If Rollup requested
      *
     C     *IN22         WHENEQ    '1'
     C                   EXSR      SRBSFL
      *
     C     *IN03         WHENNE    '1'
     C                   EXSR      SRPROC
      *
     C                   ENDSL
      *                                                                                       214440
      ***  Applicable Days do not match up, send error message.                               214440
      *                                                                                       214440
     C     WAPPD         IFEQ      'N'                                                        214440
     C                   MOVEL     'MMA1252'     ZAMSID                                       214440
     C                   EXSR      SRMSGQ                                                     214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
     C                   ENDDO
      *
     C                   ELSE
      *
     C                   EXSR      SRVINS
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBSFL   - Build subfile page                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls    : SRLOAD                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRBSFL        BEGSR
      *
      ** Refresh any input fields that has been changed just before
      ** rollup has been pressed.  Input fields will only be
      ** validated if ENTER key is pressed.
      **
      *
     C     *IN22         IFEQ      '1'
      *
     C     #0DLNO        IFNE      WDLO
     C                   MOVE      WDLO          #0DLNO
     C                   ENDIF
      *
     C     #0SIDE        IFNE      WSIDO
     C                   MOVE      WSIDO         #0SIDE
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
     C     *IN55         ANDEQ     '1'
     C                   MOVE      '1'           *IN82
     C                   ENDIF
      *
      ** Start at previous highest record in subfile
      *
     C                   Z-ADD     WMAX          RRN
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
      *
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
     C                   WRITE     DL1641S0
      *
     C                   ADD       1             WRRRD
      *
     C     KKON2         READE     DLDOISL2                               55
      *
     C     A6FXDY        IFNE      0                                                          204923
     C     *IN55         ANDEQ     '0'                                                        204923
     C     L1BSDT        ANDGE     WDATE                                                      204923
     C                   MOVE      '1'           *IN55                                        204923
      *                                                                                       204923
     C     L1BSDT        IFEQ      WDATE                                                      204923
     C     L1DLNO        CHAIN     DLOISSL3                           55                      204923
     C     *IN55         IFEQ      '0'                                                        204923
     C     L5RFIN        ANDNE     'Y'                                                        204923
      *                                                                                       204923
     C     *IN55         OREQ      '0'                                                        204923
     C     L5RFIN        ANDEQ     'Y'                                                        204923
     C     KKSID         ANDEQ     'O'                                                        204923
     C     UNIPD         ANDNE     WDATE                                                      204923
      *                                                                                       204923
     C     *IN55         OREQ      '0'                                                        204923
     C     L5RFIN        ANDEQ     'Y'                                                        204923
     C     KKSID         ANDEQ     'T'                                                        204923
     C     TNIPD         ANDNE     WDATE                                                      204923
     C                   MOVE      '1'           *IN55                                        204923
     C                   ENDIF                                                                204923
     C                   ENDIF                                                                204923
      *                                                                                       204923
     C                   ENDIF                                                                204923
      *                                                                                       204923
     C     *IN55         IFEQ      '1'
     C                   MOVE      '1'           *IN82
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Determine if the deal is amendable
      *
     C     RECI          IFEQ      'D'
     C**********           MOVE '1'       *IN09                                               214440
     C**********         MOVEA     '111'         *IN(08)                               214440 224925
     C                   MOVEA     '111'         *IN(15)                                      224925
     C                   ELSE
     C**********           MOVE '0'       *IN09                                               214440
     C**********         MOVEA     '000'         *IN(08)                               214440 224925
     C                   MOVEA     '000'         *IN(15)                                      224925
     C                   ENDIF
      *
     C                   MOVE      '1'           *IN31
     C                   WRITE     DL1641F0
      *
      ** Save highest SFL record load can continue at end point
      *
     C     RRN           IFGT      WMAX
      *
      ** Calculate top line
      *
     C     WRROK         DIV       WSFPG         WSPG
     C                   MVR                     WSLIN
     C     WSLIN         IFGT      0
     C     RRN           SUB       WSLIN         #0SFRN
     C                   ELSE
     C     RRN           SUB       WSFPG         #0SFRN
     C                   ENDIF
     C                   ADD       1             #0SFRN
     C                   Z-ADD     RRN           WMAX
     C                   ENDIF
      *
     C                   Z-ADD     0             WRROK
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN - Display screen                                      *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRSCRN        BEGSR
      *
      ** Write error message
      *
     C                   WRITE     DL1641C1
      *
      ** PUTOVR unless conditioned fields change
      *
     C     *IN81         IFNE      WIN81
     C                   MOVE      '0'           *IN86
     C                   ENDIF
     C                   MOVE      *IN81         WIN81             1
      *
     C                   MOVE      '1'           *IN81
      *
     C**********         MOVE      '1'           *IN08                                 214440 224925
     C**********         MOVE      '1'           *IN09                                 214440 224925
     C**********         MOVE      '1'           *IN10                                 214440 224925
     C                   MOVE      '1'           *IN31
      *                                                                                       214440
     C     WAPPD         IFEQ      'N'                                                        214440
     C                   MOVE      '1'           *IN35                                        214440
     C                   ENDIF                                                                214440
      *
     C                   EXFMT     DL1641C0
      *
      ** Reset all the error indicators
      *
     C                   MOVE      '0'           *IN35                                        214440
     C                   MOVE      '0'           *IN40
     C                   MOVE      '0'           *IN41
     C                   MOVE      '0'           *IN42
      *
      ** Clear error message queue
      *
     C                   EXSR      SRCLRM
      *
      ** Maintain subfile position where possible
      *
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        #0SFRN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRREFR - If F5 has been pressed refresh screen.              *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRREFR        BEGSR
      *
      ** Refresh Indicator
      *
     C                   MOVE      'Y'           WRELOD
      *
      ** Restore old valid data for refresh
      *
     C                   MOVE      WDLO          #0DLNO
     C                   MOVE      WSIDO         #0SIDE
     C                   MOVE      WPTDO         #0PDAT
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPROC   - Process Screen Input                               *
      *                                                               *
      * Called by: SRSFLP                                             *
      *                                                               *
      * Calls    : SRVALD                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRPROC        BEGSR
      *
     C                   EXSR      SRVALD
      *
     C     WVDLNO        IFEQ      'N'
     C     WVSIDE        OREQ      'N'
     C     WVTODT        OREQ      'N'
     C     WVINDT        OREQ      'N'
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
     C                   MOVE      'Y'           WRELOD
      *
      ** Store old valid data for refressh
      *
     C                   MOVE      #0DLNO        WDLO
     C                   MOVE      #0SIDE        WSIDO
     C                   MOVE      #0PDAT        WPTDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAMEN - Process Amend Request                               *
      *                                                               *
      *  Called by: SRSFLP - Subfile Processing                       *
      *                                                               *
      *  Calls    : DL1652 - OIS Interest Amendment Program           *
      *                                                               *
      *****************************************************************
      *
     C     SRAMEN        BEGSR
      *
      ** Call program DL1652 with Deal Number, Deal Side
      ** and deal amendment Code.
      *
     C                   CALL      'DL1652'                             60
     C                   PARM      WDLO          PDLNO             6
     C                   PARM      WSIDO         PDLSI             1
     C                   PARM      'N'           PAMEND            1
     C                   PARM      A6FXDY        FXDY1             1 0                        204923
     C                   PARM      WDATE         PDATE             5 0                        204923
     C                   PARM                    WAPPD             1                          214440
      *
     C     *IN60         IFEQ      '1'
      *
      ** Call to program ended in error
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'DL1652  '    DBFILE
     C                   MOVEL     '*CALL   '    DBKEY
     C                   Z-ADD     4             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       214440
      ***  Applicable Days do not match up.                                                   214440
      *                                                                                       214440
     C     WAPPD         IFEQ      'N'                                                        214440
     C                   MOVE      'Y'           WRELOD                                       214440
     C                   ELSE                                                                 214440
      *
      ** No Amendments, so redisplay the original screen.
      *
     C     PAMEND        IFEQ      'N'
     C                   MOVE      'N'           WRELOD
     C                   ENDIF
      *
      ** Deals Base rate has been amended, so need to rebuild the subfile.
      *
     C     PAMEND        IFEQ      'Y'
     C                   MOVE      'Y'           WRELOD
      *
      ** Base Rate has been amended so need to produce an Audit report
      *
     C                   EXSR      SRAUDT
      *
     C                   ENDIF
      *                                                                                       214440
     C                   ENDIF                                                                214440
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       214440
      *                                                               *                       214440
      *  SRINST   - Process Insert Request                            *                       214440
      *                                                               *                       214440
      *  Called by: SRSFLP - Subfile Processing                       *                       214440
      *                                                               *                       214440
      *  Calls    : DL1652 - OIS Interest Amendment Program           *                       214440
      *                                                               *                       214440
      *****************************************************************                       214440
      *                                                                                       214440
     C     SRINST        BEGSR                                                                214440
      *                                                                                       214440
      ** Call program DL1652 with Deal Number, Deal Side                                      214440
      ** and deal Amendment Code.                                                             214440
      *                                                                                       214440
     C                   CALL      'DL1652'                             60                    214440
     C                   PARM      WDLO          PDLNO                                        214440
     C                   PARM      WSIDO         PDLSI                                        214440
     C                   PARM      'I'           PAMEND                                       214440
     C                   PARM      A6FXDY        FXDY1                                        214440
     C                   PARM      WDATE         PDATE                                        214440
     C                   PARM                    WAPPD                                        214440
      *                                                                                       214440
     C     *IN60         IFEQ      '1'                                                        214440
      *                                                                                       214440
      ** Call to program ended in error                                                       214440
      *                                                                                       214440
     C     *LOCK         IN        LDA                                                        214440
     C                   MOVEL     'DL1652  '    DBFILE                                       214440
     C                   MOVEL     '*CALL'       DBKEY                                        214440
     C                   Z-ADD     6             DBASE                                        214440
     C                   OUT       LDA                                                        214440
     C                   EXSR      *PSSR                                                      214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
      **  Applicable Days do not match up.                                                    214440
      *                                                                                       214440
     C     WAPPD         IFEQ      'N'                                                        214440
     C                   MOVE      'Y'           WRELOD                                       214440
     C                   ELSE                                                                 214440
      *                                                                                       214440
      **  No Amendments, so redisplay the original screen.                                    214440
      *                                                                                       214440
     C     PAMEND        IFEQ      'N'                                                        214440
     C                   MOVE      'N'           WRELOD                                       214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
      **  Deals Base rate has been amended, so need to rebuild the subfile.                   214440
      *                                                                                       214440
     C     PAMEND        IFEQ      'Y'                                                        214440
     C                   MOVE      'Y'           WRELOD                                       214440
      *                                                                                       214440
      **  Base Rate has been amended so need to produce an Audit report                       214440
      *                                                                                       214440
     C                   EXSR      SRAUDT                                                     214440
      *                                                                                       214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
     C                   ENDSR                                                                214440
      *                                                                                       214440
      *****************************************************************                       214440
      /EJECT                                                                                  214440
      *****************************************************************                       214440
      *                                                               *                       214440
      *   SRDELT  - Process Delete Request                            *                       214440
      *                                                               *                       214440
      *   Called by: SRSFLP - Subfile Processing                      *                       214440
      *                                                               *                       214440
      *   Calls    : DL1652 - OIS Interest Amendment Program          *                       214440
      *                                                               *                       214440
      *****************************************************************                       214440
      *                                                                                       214440
     C     SRDELT        BEGSR                                                                214440
      *                                                                                       214440
      ** Call program DL1652 with Deal Number, Deal Side                                      214440
      ** and deal Amendment Code.                                                             214440
      *                                                                                       214440
     C                   CALL      'DL1652'                             60                    214440
     C                   PARM      WDLO          PDLNO                                        214440
     C                   PARM      WSIDO         PDLSI                                        214440
     C                   PARM      'D'           PAMEND                                       214440
     C                   PARM      A6FXDY        FXDY1                                        214440
     C                   PARM      WDATE         PDATE                                        214440
     C                   PARM                    WAPPD                                        214440
      *                                                                                       214440
     C     *IN60         IFEQ      '1'                                                        214440
      *                                                                                       214440
      ** Call to program ended in error                                                       214440
      *                                                                                       214440
     C     *LOCK         IN        LDA                                                        214440
     C                   MOVEL     'DL1652  '    DBFILE                                       214440
     C                   MOVEL     '*CALL'       DBKEY                                        214440
     C                   Z-ADD     7             DBASE                                        214440
     C                   OUT       LDA                                                        214440
     C                   EXSR      *PSSR                                                      214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
      **  Applicable Days do not match up.                                                    214440
      *                                                                                       214440
     C     WAPPD         IFEQ      'N'                                                        214440
     C                   MOVE      'Y'           WRELOD                                       214440
     C                   ELSE                                                                 214440
      *                                                                                       214440
      **  No Amendments, so redisplay the original screen.                                    214440
      *                                                                                       214440
     C     PAMEND        IFEQ      'N'                                                        214440
     C                   MOVE      'N'           WRELOD                                       214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
      **  Deals Base rate has been amended, so need to rebuild the subfile.                   214440
      *                                                                                       214440
     C     PAMEND        IFEQ      'Y'                                                        214440
     C                   MOVE      'Y'           WRELOD                                       214440
      *                                                                                       214440
      **  Base Rate has been amended so need to produce an Audit report                       214440
      *                                                                                       214440
     C                   EXSR      SRAUDT                                                     214440
      *                                                                                       214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
     C                   ENDIF                                                                214440
      *                                                                                       214440
     C                   ENDSR                                                                214440
      *                                                                                       214440
      *****************************************************************                       214440
      /EJECT                                                                                  214440
      *****************************************************************
      *                                                               *
      *  SRLOAD - Load subfile with details                           *
      *                                                               *
      *  Called by: Main Processing, ROLLUP                           *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRLOAD        BEGSR
      *
      ** Convert Base Rate Change date in to DDMMYY format.
      *
     C                   MOVE      L1BSDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #0BSDT
      *
     C**********         MOVE      L1BSRT        #0BSRT                                       245692
     C                   MOVE      L1BSRT        #0BSRT            9 7                        245692
     C                   MOVE      *BLANKS       ZFLD15                                       245692
     C                   MOVE      L1BSRT        ZFLD15                                       245692
     C                   Z-ADD     7             ZDECS                                        245692
     C                   MOVE      'J'           ZECODE                                       245692
     C                   EXSR      ZSEDIT                                                     245692
     C                   MOVE      ZOUT21        W#BSRT                                       245692
      *                                                                                       245692
     C**********         Z-ADD     L1CPRT        LXCPRT           11 7                        220859
     C                   Z-ADD     L1CPRT        LXCPRT           1915                        220859
     C**********         MOVE      LXCPRT        #0CPRT                                       245692
     C                   Z-ADD     LXCPRT        #0CPRT           1915                        245692
     C                   MOVE      *BLANKS       ZFLD15                                       245692
     C                   MOVE      LXCPRT        ZFLD15                                       245692
     C                   Z-ADD     15            ZDECS                                        245692
     C                   MOVE      'J'           ZECODE                                       245692
     C                   EXSR      ZSEDIT                                                     245692
     C                   MOVE      ZOUT21        W#CPRT                                       245692
      *                                                                                       245692
     C                   Z-ADD     L1INRT        LXINRT           11 7
      *
      ** Round off Interest Rate to the OIS Interest Rate
      ** Decimal Places when Interest Amount is not zero
      *
     C     L1AMNT        IFNE      0
      *
     C                   SELECT
     C     A6IRDP        WHENEQ    0
     C                   Z-ADD(H)  L1INRT        WDEC0            11 0
     C                   Z-ADD     WDEC0         LXINRT
     C     A6IRDP        WHENEQ    1
     C                   Z-ADD(H)  L1INRT        WDEC1            11 1
     C                   Z-ADD     WDEC1         LXINRT
     C     A6IRDP        WHENEQ    2
     C                   Z-ADD(H)  L1INRT        WDEC2            11 2
     C                   Z-ADD     WDEC2         LXINRT
     C     A6IRDP        WHENEQ    3
     C                   Z-ADD(H)  L1INRT        WDEC3            11 3
     C                   Z-ADD     WDEC3         LXINRT
     C     A6IRDP        WHENEQ    4
     C                   Z-ADD(H)  L1INRT        WDEC4            11 4
     C                   Z-ADD     WDEC4         LXINRT
     C     A6IRDP        WHENEQ    5
     C                   Z-ADD(H)  L1INRT        WDEC5            11 5
     C                   Z-ADD     WDEC5         LXINRT
     C     A6IRDP        WHENEQ    6
     C                   Z-ADD(H)  L1INRT        WDEC6            11 6
     C                   Z-ADD     WDEC6         LXINRT
     C                   ENDSL
      *
     C                   ENDIF
      *
     C**********         MOVE      LXINRT        #0INRT                                       245692
     C                   MOVE      LXINRT        #0INRT            9 7                        245692
     C                   MOVE      *BLANKS       ZFLD15                                       245692
     C                   MOVE      LXINRT        ZFLD15                                       245692
     C                   Z-ADD     7             ZDECS                                        245692
     C                   MOVE      'J'           ZECODE                                       245692
     C                   EXSR      ZSEDIT                                                     245692
     C                   MOVE      ZOUT21        W#INRT                                       245692
      *                                                                                       245692
     C                   MOVE      L1APDY        #0APDY
      *
      ** Call ZSEDIT for fields where decimal places depend on deal
      ** currency.  ZSEDIT Inserts sign, commas and a decimal point
      ** into numeric field and blanks out leading zeros.
      *
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      L1PRIN        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        #0PRIN
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
      *  SRAUDT - Audit report for amended Base Rate.                 *
      *                                                               *
      *  Called by: SRAMEN Process amend request                      *
      *                                                               *
      *  Calls    : DL1658 OIS Interest Rate Amendment Printing       *
      *                                                               *
      *****************************************************************
      *
     C     SRAUDT        BEGSR
      *
      ** Call program DL1658 to produce an Audit report with the
      ** changes.
      *
     C                   CALL      'DL1658'                             61
     C                   PARM      WDLO          PDLNO
     C                   PARM      WSIDO         PDLSI
     C                   PARM      A6FXDY        FXDY1             1 0                        204923
     C                   PARM      WDATE         PDATE             5 0                        204923
      *
     C     *IN61         IFEQ      '1'
      *
      ** Call to program ended in error
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'DL1658  '    DBFILE
     C                   MOVEL     '*CALL   '    DBKEY
     C                   Z-ADD     5             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCLR - Clear all display fields and the message queue       *
      *                                                               *
      *  Called by: All validation subroutines                        *
      *                                                               *
      *  Calls    : SRCLRM                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRCLR         BEGSR
      *
     C                   MOVE      *BLANKS       #0DLNO
     C                   MOVE      *BLANKS       #0SIDE
     C                   MOVE      *BLANKS       #0PDAT
      *
      ** Clear Subfile  and erase Subfile control from the screen
      *
     C                   MOVE      '1'           *IN80
     C                   WRITE     DL1641C0
     C                   MOVE      '0'           *IN80
      *
     C                   EXSR      SRCLRM
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCLRM - Clear error message queue                           *
      *                                                               *
      *  Called by: SRVINS, SRSCRN, SRCLR                             *
      *                                                               *
      *  Calls    : Y2CLMSC                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRCLRM        BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      #1PGM         ZAPGM            10
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
      *  SRMSGQ - Sends messages to the program's message queue       *
      *                                                               *
      *  Called by: Almost all screens with validation                *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRMSGQ        BEGSR
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     #1PGM         ZAPGMQ
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
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     WERROR        IFEQ      *BLANK
     C                   MOVE      'Y'           WERROR            1
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
      /EJECT
     C*COPY ZSRSRC,ZSEDITZ3                                                                   220859
     C*COPY*ZSRSRC,ZSEDITZ3LE***                                                       220859 245692
     C/COPY ZSRSRC,ZSEDITZ4LE                                                                 245692
      /EJECT
     C*COPY ZSRSRC,ZALIGNZ2                                                                   220859
     C/COPY ZSRSRC,ZALIGNZ2LE                                                                 220859
      /EJECT
     C*COPY ZSRSRC,ZBKDT                                                               204923 220859
     C/COPY ZSRSRC,ZBKDT_ILE                                                                  220859

      /EJECT                                                                                  204923
     C*COPY ZSRSRC,ZACCH                                                               204923 220859
     C/COPY ZSRSRC,ZACCHLE                                                                    220859
      /EJECT                                                                                  204923
**  CPY@
(c) Finastra International Limited 2001
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
