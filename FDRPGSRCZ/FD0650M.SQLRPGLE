     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056555
/*STD *  RPGSQLBND                                                    *                     MD056555
/*EXI *  TEXT('Midas FD Deal type/subtypes maintenance subfile')      *
/******  OVRDBF FILE(GPPRDXL0) TOFILE(GPPRODXL0)                      *              CGP001 MD056555
/******  OVRDBF FILE(GPINSXL0) TOFILE(GPINSTXL0)                      *              CGP001 MD056666
/*OVRF*  OVRDBF FILE(GPPRDXL0) TOFILE(GPPRODXL0)                      *                     MD056555
/*OVRF*  OVRDBF FILE(GPINSXL0) TOFILE(GPINSTXL0)                      *                     MD056555
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Fixed Data Module                            *
      *                                                               *
      *  FD0650M - Midas Edit Deal Types/Subtypes                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056555           Date 31Aug20               *
      *  Prev Amend No. MD056992           Date 04Nov20               *
      *                 MD046248           Date 27Oct17               *
      *                 MD039356           Date 13Jul16               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 AR1068283          Date 19Aug14               *
      *                 MD023642           Date 21Nov13               *
      *                 207288             Date 17Jul12               *
      *                 AR921326           Date 24Feb12               *
      *                 AR795970           Date 05Jul11               *
      *                 AR787620           Date 10Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23955A          Date 21May09               *
      *                 BUG23955           Date 11May09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CPK027             Date 30Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG11551           Date 20Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10816           Date 09Mar06               *
      *                 BUG10791           Date 08Mar06               *
      *                 BUG10153           Date 01Feb06               *
      *                 CAS011             Date 16May05               *
      *                 231563             Date 10Jan05               *
      *                 CAS009             Date 04May04               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 BUG6307            Date 18Mar05               *
      *                 CAS008             Date 16Jun04               *
      *                 BUG5677            Date 01Feb05               *
      *                 BUG3039            Date 10Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL019             Date 09Feb04               *
      *                 BG0257             Date 23May03               *
      *                 CGP001             Date 23May03               *
      *                 CRE008             Date 10Apr02               *
      *                 CAS005             Date 16Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 180781             Date 25Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 151162             Date 23May00               *
      *                 CFT008             Date 04Jan00               *
      *                 CFT006             Date 20Oct99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             DATE 29Jun99               *
      *                 165341             DATE 13Oct99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 107662             Date 09Jun98               *
      *                 096515             DATE 26FEB97               *
      *                 101310             DATE 04JUL96               *
      *                 093958             DATE 20OCT95               *
      *                 S01408             DATE 12DEC95               *
      *                 S01408             DATE 06MAR95               *
      *                 S01486             DATE 08NOV94               *
      *                 057329             DATE 05NOV93               *
      *                 053717             DATE 13SEP93               *
      *                 AUS011             DATE 18JUN92               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD056555 - Deliverable Data Split for SAR group              *
      *  MD056992 - Added non-display attribute for spot indicator    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD039356 - Correct the display of Inst Type. (Recompile)     *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR1068283 - Description field is 35 long not 30 long         *
      *              Applied for MD021909A (Recompile)                *
      *  MD023642 - Deal Type/Subtype Maintenance errors.             *
      *           - Instrument Type not available even if CGL014      *
      *             is switched 'ON'.                                 *
      *  207288 - Display spot indicator.                             *
      *           Applied for AR999664 (Child: AR999668)              *
      *  AR921326 - Fix Base Rate field was not updated (Recompile)   *
      *  AR795970 - Change §24c to plain 24c (Recompile)              *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,FDH00019                                 *
      *             WNCPYSRC,FDH00020                                 *
      *             WNCPYSRC,FDH00021                                 *
      *             WNCPYSRC,FDH00022                                 *
      *             WNCPYSRC,FDH00023                                 *
      *             WNCPYSRC,FDH00024                                 *
      *             WNCPYSRC,FDH00025                                 *
      *             WNCPYSRC,FDH00026                                 *
      *             WNCPYSRC,FDH00027                                 *
      *             WNCPYSRC,FDH00028                                 *
      *             WNCPYSRC,FDH00029                                 *
      *             WNCPYSRC,FDH00030                                 *
      *             WNCPYSRC,FDH00033                                 *
      *             WNCPYSRC,FDH00031                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT045 Cannot amend deal type sub-type.              *
      *  BUG23955A - 24c must be in lower case (Recompile).           *
      *  BUG23955 - New Field show correct symbol "§" (Recompile)     *
      *             DSPF Modification                                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  CPK027 - External field name entry is longer than six(6)     *
      *           characters                                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11551 - Deletion is not allowed (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10816 - Product Code is missing (Recompile)               *
      *  BUG10791 -Include CF deal type in validating Amortised Cost  *
      *            Accounting.                                        *
      *  BUG10153 -Errors in validation of deal type/sub-type/class   *
      *  CAS011 - EIR/AC Accouting Upgrade to MP1                     *
      *  231563 - Additional Validation For ACAI                      *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  BUG6307- Global Product and Instrument should be non-manda-  *
      *           tory.                                               *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  BUG5677- Global Instrument Code is not mandatory if          *
      *           Management Limit (CGP003) is OFF.                   *
      *  BUG3039 - Webfacing Changes. Recompile.                      *
      *  CLE025 - Credit Lines                                        *
      *  CGL014 - Collateral Processing                               *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  BG0257 - Errors in Deal Type/Sub Type input                  *
      *           (Display file changed)                              *
      *  CGP001 - Global Processing                                   *
      *  CRE008 - Cash Management                                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  180781 - Only check instrument type if Private Banking is    *
      *           switched on.                                        *
      *  151162 - Add deal type NX for nostro transfers               *
      *  CFT008 - MT102 message addition for outgoing/incoming CCT    *
      *  CFT006 - MT101 message addition for outgoing/incoming RFT    *
      *  CPB001 - 'Private Banking' Module                            *
      *  165341 - Amend validation routine. Endif statement moved as  *
      *           it is preventing the main validation codes from     *
      *           being executed.                                     *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CPL002 - Addition of Midas-Plato Interface fields.           *
      *  107662 - Add FRA/IRS Deal types to list.                     *
      *  096515 - Program failed to pass the retrieved instrument     *
      *           type from AOPLINR0. Wrong values being written to   *
      *           file. Also, Message queue being cleared abnormally. *
      *  101310 - Deletion should not be allowed when the system      *
      *           set up is complete.                                 *
      *  093958 - Add extra payment types fpr Funds Transfer. Extra   *
      *           types are 'IN' 'CC' 'CP' 'NT' and 'RP' - 'OP' is    *
      *           already included as it used for Options in FX as    *
      *           well as Outgpong Payments in FT, but deal type 'OP' *
      *           in FX is rarely used so shouldn't cause a problem.  *
      *  S01408 - Addition of core hooks FD0650MFP1                   *
      *                                  FD0650MC10                   *
      *                                  FD0650MC11                   *
      *  S01408 - Addition of core hooks FD0650MCP9                   *
      *                                  FD0650MCP1                   *
      *                                  FD0650MCP2                   *
      *                                  FD0650MCP3 (3 times)         *
      *                                  FD0650MCP4                   *
      *                                  FD0650MCP5 (3 times)         *
      *                                  FD0650MCP6                   *
      *                                  FD0650MCP7                   *
      *                                  FD0650MCP8                   *
      *                                  FD0650MCPG                   *
      *                                  FD0650MADU                   *
      *                                  FD0650MCAU                   *
      *                                  FD0650MDAU                   *
      *                                  FD0650MFPG                   *
      *                                  FD0650MIPG                   *
      *                                  FD0650MVSF                   *
      *  S01486 - Portfolio Management Upgrade to Release 10.         *
      *  057329 - Add internal contract deal types PS, ID, & IL.      *
      *  053717 - Allow input of deal type/subtype combinations for   *
      *           NA'S purchased/sold.                                *
      *           NAP'S - C1 C2 BP BD TB DA TA                        *
      *           NAS'S - CS BS BR TS RA TR                           *
      *           Synon generated header information replaced         *
      *           by Standard Header Box.                             *   AUS011
      *  AUS011 - AUSTRALIAN PRODUCT - DEAL TYPE/SUB TYPE VALIDATION  *   AUS011
      *                                                               *
      *****************************************************************
      *                                                                   S01408
     F/COPY WNCPYSRC,FD0650MFP1                                           S01408
      *                                                                   S01408
     FFD0650M#  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
      * DSP: Edit Deal type/subtypes   Edit file
      *
     FFDDTSTL1  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     RENAME(FDDTSTPD:@FDDTST1)
      * RTV: Deal types/subtypes       Retrieval index
     F/COPY WNCPYSRC,FDH00019
      *
     F*SDDLSTL1IF**E***********K********DISK                                                  CDL038
      **RTV:*Deal*subtypes*************Retrieval index                                        CDL038
      **********************************                                                      CDL038
     FFDDTSTL0  UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     RENAME(FDDTSTPD:@FDDTST0)
      * UPD: Deal types/sub types      Update index
      *
     FFDDTSTYT  IF   E           K DISK
     F                                     RENAME(FDDTSTD0:RTVIDX)
      *                                                                                       207288
     FFDDTSTXT  UF A E           K DISK    COMMIT
     F                                     USROPN
     F                                     RENAME(FDDTSTD0:UPDIDX)
      *                                                                                       207288
     FGPPRDXL0  UF A E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     F                                     RENAME(GPPRODXD0:GPPRDXD0)
     F                                     COMMIT
      ** Midas GP Global Products X-Reference                                                 CGP001
      *                                                                                       CGP001
     FGPINSXL0  UF A E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     F                                     RENAME(GPINSTXD0:GPINSXD0)
     F                                     COMMIT
      ** Midas GP Global Instruments X-Reference                                              CGP001
      *                                                                                       CGP001
     F*SCSARPL1* IF   E           K DISK                                                    MD056555
      ** Midas SC Switchable Feature Initialisation PGM index                                 231563
      *                                                                                       231563
     F***DEALSL7 IF  E           K        DISK                                         231563 CAS011
     FDEALSL10  IF   E           K DISK
      ** Midas DL DEALSDB/DEALSDC by Deal Type/Sub Type                                       231563
     F*                                                                   S01408
     F/COPY WNCPYSRC,FD0650MFPG                                           S01408
     F*                                                                   S01408
     D********************TXT     1   2 78                                101310
     D TXT             S             78    DIM(3) CTDATA PERRCD(1)                               101
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D @CN             S             25    DIM(23) CTDATA PERRCD(1)             Long constants.
     D OVRC            S             80    DIM(2) CTDATA PERRCD(1)
      ** Override Command Array                                                               CGP001
      *                                                                                       CGP001
     D @DL             S              2    DIM(14) CTDATA PERRCD(1)             Deal types
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
      /EJECT
     D/COPY WNCPYSRC,FD0650MI01
     D GOPGM           C                   CONST('GOGETZONE')
     D GOMSG           C                   CONST('ERROR IN GOGETZONE')
      ** Global Processing Constants                                                          CGP001
      *                                                                                       CGP001
      * Data structures:-
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
     D** Dummy record format for access to Deal Sub-Types                                     CDL038
     D*                                                                                       CDL038
     D SDTCLS        E DS                  EXTNAME(SDTCLSPD)
     D** Dummy record format for access to Transaction Classes                                CDL038
     D*                                                                                       CDL038
     D SDPLIN        E DS                  EXTNAME(SDPLINPD)                    S01486
     D** Dummy record format for access to Instrument Types               S01486
     D*                                                                   S01486
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    S01486
     D** Dummy record format for access to Modules File                   S01486
     D*                                                                   S01486
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                    S01486
     D** Dummy record format for Portfolio Management ICD Details.        S01486
     D*                                                                   S01486
     D LDA             DS           256
      ** Local data area for database error details                                           CAS005
      *                                                                                       CAS005
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDL006
      ** Dummy record format for access to Switchable Features Details.   CDL006
      *                                                                   CDL006
     D/COPY WNCPYSRC,FD0650MI06
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01486
     D** First DS for access programs, short data structure               S01486
     D*                                                                   S01486
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01486
      **  Long data structure for access programs                         S01486
      *                                                                   S01486
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)
      ** Dummy record format for access to Yield Curve files                                  CAS001
     D  FYSLCA       E                     EXTFLD(FSYLDCA)
      *                                                                                       CAS001
     D GPPROD        E DS                  EXTNAME(GPPRODPD)
     D  PDGLCD       E                     EXTFLD(PDLCD)
     D  PDGCHT       E                     EXTFLD(PDCHTP)
      ** Global Product Code Details Data Structure                                           CGP001
      *                                                                                       CGP001
     D GPINST        E DS                  EXTNAME(GPINSTPD)
      ** Global Instrument Code Details Data Structure                                        CGP001
      *                                                                                       CGP001
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure.
     D/COPY WNCPYSRC,FD0650MI03
     D JBDTTM          DS
      * Job date/time.
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file data structure.
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure.
      *
     D/COPY WNCPYSRC,FD0650MI04
     D @1DBRC        E DS                  EXTNAME(FDDTSTL0)
      * Current/previous master file format fields for change control.
      *
     D/COPY WNCPYSRC,FD0650MI05
     D RUNDAT          DS
     D  MRDT                   1      7                                         S01229
     D  RDNB                   8     10P 0                                      S01229
     D  SUC                   11     11                                         S01229
     D  DFF                   12     12                                         S01229
     D  MBIN                  13     13                                         S01229
     D/COPY WNCPYSRC,FD0650MI02
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     array
     D                 DS
     D  ZAMSDA                 1    132
     D*  Data structure for passing data to messages
     D  ZA0001                 1     30
     D  ZA0003                 1     30
     D SCSARP        E DS                  EXTNAME(SCSRPJW0)                                MD056555
     I*                                                                   S01408
     I/COPY WNCPYSRC,FD0650MIPG                                           S01408
     I*                                                                   S01408
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
      * Initialise and load subfile page.
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      * Display screen until reload requested:
     C     W0RSF         DOWEQ     'N'
      * Display screen.
     C                   EXSR      CAEXFM
      * Process response:
      * Exit request: Cancel & exit program.
     C   03              CAS                     ZXEXPG
      * HOME: Request subfile reload.
     C   05              CAS                     FBRQRL
      *   Display next SFL page.
     C   27              CAS                     BBLDSF
      * Process screen input.
     C                   CAS                     DAPR##
     C                   END
      *
     C                   END                                                    OD W0RSF
     C                   END                                                    OD *HIVAL
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise & Load subfile page.
      *================================================================
      * Clear subfile.
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile.
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      * USER: Initialise subfile header
     C*                                                                   101310
     C                   MOVEL     'N'           WUDELA                         Deletion Allowe10131
      * CASE: WRK.Set Up Complete is No                                   101310
     C     WUSUC         IFEQ      'N'                                          *IF            10131
      * CASE: PGM.*Program mode is *CHANGE                                101310
     C     W0PMD         IFEQ      'CHG'                                        *IF            10131
     C                   MOVEL     'Y'           WUDELA                         Deletion Allowe10131
     C                   END                                                    *FI            10131
     C                   END                                                    *FI            10131
     C*                                                                   101310
      * Set Up Function Key Text - Standard Functions  *
     C*
     C*  If program mode is ADD:                                          101310
     C*                                                                   101310
     C     W0PMD         IFEQ      'ADD'                                                       10131
     C                   MOVEA     TXT(2)        ##CTX1                                        10131
     C                   ELSE                                                                  10131
     C*                                                                   101310
     C*  If set up is not complete:                                       101310
     C*                                                                   101310
     C     WUSUC         IFEQ      'N'                                                         10131
     C/COPY WNCPYSRC,FD0650MC01
     C                   MOVEA     TXT(1)        ##CTX1                                        10131
     C/COPY WNCPYSRC,FD0650MC02
     C                   ELSE                                                                  10131
     C                   MOVEA     TXT(3)        ##CTX1                                        10131
     C                   END                                                                   10131
     C                   END                                                                   10131
     C*                                                                   101310
     C***********W0PMD     IFEQ 'CHG'                                     101310
     C***********          MOVEATXT,1     ##CTX1                    S01229101310
     C***********          END                                            101310
     C***********W0PMD     IFEQ 'ADD'                                     101310
     C***********          MOVEATXT,2     ##CTX1                    S01229101310
     C***********          END                                            101310
     C*                                                                   101310
      * If CHANGE mode, then position file:
     C     W0PMD         IFNE      'ADD'
     C     *LIKE         DEFINE    #2DTPE        WZDTPE
     C                   MOVEL     #2DTPE        WZDTPE                         Deal type
     C     *LIKE         DEFINE    #2DLST        WZDLST
     C                   MOVEL     #2DLST        WZDLST                         Subtype
     C     *LIKE         DEFINE    #2CLAS        WZCLAS
     C                   MOVEL     #2CLAS        WZCLAS                         Class
     C     KPOS          KLIST
     C                   KFLD                    DTPE11                         Deal type
     C                   KFLD                    DLST11                         Deal type
     C                   KFLD                    CLAS11                         Class
      * Setup key.
     C                   MOVEL     #2DTPE        DTPE11                         Deal type
     C                   MOVEL     #2DLST        DLST11                         Deal type
     C                   MOVEL     #2CLAS        CLAS11                         Class
     C/COPY WNCPYSRC,FD0650MC37
     C     KPOS          SETLL     @FDDTST1                           82        *82=EOF
     C  N82              READ      @FDDTST1                             9182    *82=EOF
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MCPG                                           S01408
     C*                                                                   S01408
     C                   ELSE
     C                   SETOFF                                       82        *
     C                   END
      * Load subfile page.
     C                   EXSR      BBLDSF
      *................................................................
      * If no records found, display error message.
     C   82##RR          IFEQ      *ZERO                                        IF
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI ##RR = *ZERO
      *
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      * Load subfile page (write empty page if add mode).
      *================================================================
     C                   SETOFF                                       84        No SFLNXTCHG
      * Re-establish fields in read-ahead record.
     C   27W0PMD         IFNE      'ADD'
     C/COPY WNCPYSRC,FD0650MC38
     C  N82              READP     @FDDTST1                               90    *
     C  N82              READ      @FDDTST1                               90    *
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MCP1                                           S01408
     C*                                                                   S01408
     C                   END
      *
     C/COPY WNCPYSRC,FD0650MC33
      * Setof record error indicators.
     C***********          MOVE *ALL'0'   WKIND0  5                       S01486
     C*********************MOVE *ALL'0'   WKIND0  6                       S01486              CDL038
     C**********           MOVE *ALL'0'   WKIND0  9                                    CDL038 207288
     C**********           MOVE *ALL'0'   WKIND0 10                                  207288 MD023642
     C                   MOVE      *ALL'0'       WKIND0            9
     C/COPY WNCPYSRC,FD0650MC27
      * Start at previous highest SFL record reached.
     C                   Z-ADD     ##RRMX        ##RR              5 0
     C                   Z-ADD     *ZERO         ##RROK            5 0
      *................................................................
      * Load next page of SFL:
     C  N82##RROK        DOWLT     ##SFPG                                       DO
     C/COPY WNCPYSRC,FD0650MC18
     C*********************MOVEAWKIND0    *IN,32                                              CDL038
     C                   MOVEA     WKIND0        *IN(30)
     C/COPY WNCPYSRC,FDH00020
     C                   MOVE      *OFF          *IN71
     C                   MOVE      *OFF          *IN72
     C                   MOVE      *OFF          *IN73
     C                   MOVE      *OFF          *IN74
     C                   MOVE      *OFF          *IN75
     C                   MOVE      *OFF          *IN76
     C                   MOVE      *OFF          *IN41
     C                   MOVE      *OFF          *IN42
     C                   MOVE      *OFF          *IN58
     C                   MOVE      *OFF          *IN61
     C                   MOVE      *OFF          *IN62
     C                   MOVE      *OFF          *IN63
     C                   MOVE      *OFF          *IN69
      *                                                                                       CER047
     C     CER047        IFEQ      'Y'
     C                   SETOFF                                       45
     C                   ENDIF
      *                                                                                       CER047
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MCP3                                           S01408
     C*                                                                   S01408
     C                   SETOFF                                       87        *
      * Clear SFL fields.
     C                   EXSR      MAIZ#1
      * If change mode, load SFL fields.
     C     W0PMD         IFNE      'ADD'
     C                   EXSR      MBFL#1
      * Record will be selected unless overridden.
     C                   MOVEL     'Y'           W0RSL             1
      * USER: Initialise subfile record (existing record)
     C*********************MOVEL@CN,01    WUDELA           Deletion Allowe101310
     C                   MOVEL     @CN(01)       WUAMAL                         Amend allowed
      * If record dropped...
     C     W0RSL         CABNE     'Y'           BB020
      * Validate subfile record and calculate derived fields.
     C                   EXSR      DFV2RC
     C                   ELSE
      * USER: Initialise subfile record (new record)
     C                   MOVEL     @CN(01)       WUAMAL                         Amend allowed
      *CASE:     PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      @CN(06)                                      *IF
     C                   MOVEL     @CN(05)       WUDELA                         Deletion Allowe
     C                   END                                                    *FI
     C                   END
      * Output to subfile.
     C                   ADD       1             ##RR                 81        *
     C                   ADD       1             ##RROK
      * Set screen conditioning indicators.
     C                   EXSR      GADSA1
      *                                                                   S01408
     C/COPY WNCPYSRC,FD0650MC10                                           S01408
      *                                                                   S01408
     C                   WRITE     #SFLRCD
     C     BB020         TAG
     C     W0PMD         IFNE      'ADD'
     C/COPY WNCPYSRC,FD0650MC39
     C                   READ      @FDDTST1                               82    *82=EOF
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MCP2                                           S01408
     C*                                                                   S01408
     C                   END
     C  N82              END                                                    OD 1 - #SFPG
      *................................................................
      * Save highest SFL rec, so load can continue at end point.
     C     ##RR          IFGT      ##RRMX
     C     ##RRMX        ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
     C/COPY WNCPYSRC,FD0650MC14
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests.
      *================================================================
      * Set screen conditioning indicators.
     C                   EXSR      GBDSA2
      * Update screen time.
     C                   TIME                    ##TME                          Screen time.
     C     W0HLP         DOUEQ     'N'
      * PUTOVR unless conditioned fields change.
     C                   SETON                                        86
     C     *IN89         IFNE      CAIN89
     C     *IN81         ORNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN89         CAIN89            1
     C                   MOVE      *IN81         CAIN81            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
     C                   MOVEL     'N'           W0HLP             1            Reset help requ
      * If help requested, display help text.
     C   25              EXSR      ZHHPKY                                       Display help te
     C                   END
      * Update job time.
     C                   TIME                    ##JTM                          Job time.
      * Clear messages from program message queue.
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag.
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      * Process screen input.
      *================================================================
      * Maintain subfile position where possible.
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      *
     C     W0PMD         IFNE      'ADD'
      * Change of position specified?
     C     WZDTPE        CASNE     #2DTPE        FBRQRL                         Deal type
     C     WZDLST        CASNE     #2DLST        FBRQRL                         Subtype
     C     WZCLAS        CASNE     #2CLAS        FBRQRL                         Class
     C                   END
     C                   END
      * Quit if reload requested.
     C     W0RSF         CABEQ     'Y'           DAEXIT
      *
     C   81              DO
      * No data entered as yet.
     C                   MOVEL     'N'           WKIPIN            1
      * Confirm/update is not defered.
     C                   MOVEL     'N'           W0DCF             1
      * Process subfile records.
     C                   EXSR      DBPRSF
      * If error, exit:
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested:
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * If data entered.
     C     WKIPIN        IFEQ      'Y'
      * Update DBF from subfile.
     C                   EXSR      EAPRSF
      * If error during update, exit:
     C     *IN99         CABEQ     '1'           DAEXIT
     C                   END                                                    WKIPIN
     C                   END                                                    OD 81
      *=====Process function keys=====
     C/COPY WNCPYSRC,FD0650MC03
      * Switch between *ADD/*CHANGE modes.
     C   09              EXSR      FACHMD
     C/COPY WNCPYSRC,FD0650MC04
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile records.
      *================================================================
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
     C                   EXSR      DCPRSR
     C                   SETOFF                                       87        *
      * Set screen conditioning indicators.
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record.
      *================================================================
      * Setoff error indicators.
     C/COPY WNCPYSRC,FD0650MC19
     C*********************MOVEAWKIND0    *IN,32                                              CDL038
     C                   MOVEA     WKIND0        *IN(30)
     C/COPY WNCPYSRC,FDH00021
     C                   MOVE      *OFF          *IN71
     C                   MOVE      *OFF          *IN72
     C                   MOVE      *OFF          *IN73
     C                   MOVE      *OFF          *IN74
     C                   MOVE      *OFF          *IN75
     C                   MOVE      *OFF          *IN76
     C                   MOVE      *OFF          *IN41
     C                   MOVE      *OFF          *IN42
     C                   MOVE      *OFF          *IN58
     C                   MOVE      *OFF          *IN61
     C                   MOVE      *OFF          *IN62
     C                   MOVE      *OFF          *IN63
     C                   MOVE      *OFF          *IN69
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MCP3                                           S01408
     C*                                                                   S01408
     C                   SETOFF                                       98        No errors
     C                   SETOFF                                       84        NO SFLNXTCHG
     C     W0PMD         IFEQ      'ADD'
      * Check for null record.
     C                   EXSR      DDNLRC
     C     W0NLR         IFEQ      'Y'
     C                   GOTO      DCEXIT
     C                   END
      * If not null record, continue.
     C                   END
     C                   MOVEL     'Y'           WKIPIN                         Data entered
     C                   SETON                                        84        *SFLNXTCHG
      * If delete request, bypass validation.
     C     #1SEL         IFEQ      'D'
     C                   GOTO      DCEXIT
     C                   END
     C/COPY WNCPYSRC,FD0650MC05
      * Validate subfile record.
     C                   EXSR      DEV1RC
      * If SFLRCD invalid, note the fact.
     C   98
     CANN99              Z-ADD     ##RR          ##SFRC               99        Invalid SFLRCD
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   DDNLRC        BEGSR
      *================================================================
      * Check for null record.
      *================================================================
     C                   MOVEL     'N'           W0NLR             1
     C     #1DTPE        CABNE     *BLANK        DDEXIT                         Deal type
     C     #1DLST        CABNE     *BLANK        DDEXIT                         Subtype
     C     #1CLAS        CABNE     *BLANK        DDEXIT                         Class
     C     #1NARR        CABNE     *BLANK        DDEXIT                         Description of
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MCP4                                           S01408
     C*                                                                   S01408
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record.
      *================================================================
      * USER: Validate subfile record fields
     C/COPY WNCPYSRC,FD0650MC08
      *                                                                   S01486
      ** Validate Instrument type                                         S01486
      *                                                                   S01486
     C     BGPFMG        IFEQ      'Y'                                                         S0148
     C     BGN4ST        OREQ      'Y'                                                         CPB00
     C     CGL014        OREQ      'Y'
     C     CLE025        OREQ      'Y'
     C     #1INNR        IFNE      *BLANK                                                      S0148
     C                   CALL      'AOPLINR0'                                                  S0148
     C                   PARM      '*MSG   '     @RTCD             7                           S0148
     C                   PARM      '*KEY   '     @OPTN             7                           S0148
     C                   PARM      #1INNR        @INNR             3                           S0148
     C     SDPLIN        PARM      SDPLIN        DSSDY                                         S0148
      *                                                                   S01486
     C**Clear*messages*from*program*message*queue.*****************S01486 096515
     C*********            CALL 'Y2CLMSC'                          S01486 096515
     C*********            PARM ##PGM     ZAPGM  10                S01486 096515
     C*********            PARM '*SAME'   ZAPGRL  5                S01486 096515
     C**Reset*first*message*only*flag.*****************************S01486 096515
     C*********            MOVEL'Y'       ZAFSMS  1      99*       S01486 096515
     C*                                                                   096515
     C** Pass the value retrieved from AOPLINR0.                          096515
     C*                                                                   096515
     C                   MOVEL     @INNR         #1INNR                                        09651
      *                                                                   S01486
      ** Instrument Type invalid                                          S01486
     C     @RTCD         IFEQ      '*NRF'                                                      S0148
     C     #1INNR        ANDNE     '?'                                                         S0148
     C                   SETON                                        9837      *              S0148
     C                   MOVE      *BLANKS       ZAMSGF                         Message file.  S0148
     C******               MOVEL'USR4272' ZAMSID           Message S01486 CPB001
     C                   MOVEL     'USR4523'     ZAMSID                         Message id.    CPB00
     C                   EXSR      ZASNMS                                       Send message   S0148
     C                   ENDIF                                                                 S0148
     C                   ENDIF                                                                 S0148
     C                   ENDIF                                                                 16534
      *----------------------------------------------------------------   S01486
      *CASE:     PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      @CN(06)                                      *IF
     C                   MOVEL     #1DTPE        WUTQKF                         Test ? in Key F
      *CASE:     WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      @CN(07)                                      *IF
     C                   MOVEL     @CN(08)       W0RTN                          *Return code
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C*********************MOVEL#1DLST    WUTQKF           Test ? in Key F                    CDL038
      *CASE:*****WRK.Test*? in Key Field is Question Mark                                     CDL038
     C***********WUTQKF****IFEQ @CN,07                     *IF                                CDL038
     C*********************MOVEL@CN,08    W0RTN            *Return code                       CDL038
      **Send*message*'Question Mark Invalid'                                                  CDL038
     C*********************MOVEL'USR0380' ZAMSID           Message id.                        CDL038
     C*********************EXSR ZASNMS                     Send message                       CDL038
     C*********************SETON                     9835  *                                  CDL038
      *********************                                                                   CDL038
     C*********************END                             *FI                                CDL038
     C                   END                                                    *FI
      * Validate subfile record relations.
     C                   EXSR      DFV2RC
      * Deal type required.
     C     #1DTPE        IFEQ      *BLANK                                       IF
     C                   SETON                                        9834      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
      * Subtype required.
     C     #1DLST        IFEQ      *BLANK                                       IF
     C                   SETON                                        9835      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
      * Class required. (NOT FT TYPES OR CM)                                                  CDL038
     C     #1CLAS        IFEQ      *BLANK                                       IF
     C     CDL038        ANDEQ     'Y'
     C     #1DTPE        ANDNE     'OP'
     C     #1DTPE        ANDNE     'IN'
     C     #1DTPE        ANDNE     'CC'
     C     #1DTPE        ANDNE     'CP'
     C     #1DTPE        ANDNE     'NT'
     C     #1DTPE        ANDNE     'RP'
     C     #1DTPE        ANDNE     'RI'
     C     #1DTPE        ANDNE     'RO'
     C     #1DTPE        ANDNE     'BI'
     C     #1DTPE        ANDNE     'BO'
     C     #1DTPE        ANDNE     'CM'
     C                   SETON                                        9838      *
      * Send message '*Value required'                                                        CDL038
     C                   MOVEL     'Y2U0001'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
      * Class NOT required.  (FT TYPES AND CM)                                              BUG10153
     C     #1CLAS        IFNE      *BLANK                                       IF
     C     CDL038        ANDEQ     'Y'
     C     #1DTPE        IFEQ      'IN'
     C     #1DTPE        OREQ      'CC'
     C     #1DTPE        OREQ      'CP'
     C     #1DTPE        OREQ      'NT'
     C     #1DTPE        OREQ      'RI'
     C     #1DTPE        OREQ      'RO'
     C     #1DTPE        OREQ      'BI'
     C     #1DTPE        OREQ      'BO'
     C     #1DTPE        OREQ      'CM'
     C                   SETON                                        9838      *
      * Send message '*Value not required'                                                  BUG10153
     C                   MOVEL     'Y2U0002'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END
     C                   END                                                    FI
      *----------------------------------------------------------------   S01486
      *                                                                   S01486
      ** Instrument type                                                  S01486
     C     BGPFMG        IFEQ      'Y'                                                         S0148
     C     BGN4ST        OREQ      'Y'                                                         CPB00
     C     CGL014        OREQ      'Y'
     C     CLE025        OREQ      'Y'
      *                                                                   S01486
      ** Process '?' processing                                           S01486
     C     #1INNR        IFEQ      '?'                                                         S0148
     C                   MOVEL     PDINNR        #1INNR                                        S0148
     C                   ENDIF                                                                 S0148
     C***********          ENDIF                                    S01486180781
      *                                                                   S01486
      ** Default SDPORTPD Instrument Type.                                S01486
      ** Only if PM is ON                                                 CPB001
     C     BGPFMG        IFEQ      'Y'                                                         CPB00
     C     CGL014        OREQ      'Y'
     C     CLE025        OREQ      'Y'
     C     #1INNR        IFEQ      *BLANK                                                      S0148
     C                   MOVE      FCDINR        #1INNR                                        S0148
     C                   ENDIF                                                                 S0148
     C                   ELSE                                                                  CPB00
      *                                                                   CPB001
      ** Instruement type must be entered                                 CPB001
     C     #1INNR        IFEQ      *BLANK                                                      CPB00
     C                   SETON                                        9837      *              CPB00
     C                   MOVE      *BLANKS       ZAMSGF                         Message file.  CPB00
     C                   MOVEL     'USR4524'     ZAMSID                         Message id.    CPB00
     C                   EXSR      ZASNMS                                       Send message   CPB00
     C                   ENDIF                                                                 CPB00
     C                   ENDIF                                                                 CPB00
     C                   ENDIF                                                                 18078
     C***********          ENDIF                                    S01486165341
      *                                                                                       CAS009
      ** If CAS009 is ON, validate Amortised Cost Accounting Indicator                        CAS009
      *                                                                                       CAS009
     C     CAS009        IFEQ      'Y'
     C     #1ACAI        IFNE      ' '
     C     #1ACAI        ANDNE     'Y'
     C     #1ACAI        ANDNE     'N'
     C                   MOVE      *ON           *IN69
     C                   MOVE      *ON           *IN98
      **Send message 'Valid values are 'Y', 'N' and blank'                                    CAS009
     C                   MOVEL     'USR9155'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
      *                                                                                       CAS009
     C     #1ACAI        IFEQ      'Y'
     C     #1ACAI        OREQ      'N'
      *                                                                                       CAS009
     C     #1DTPE        LOOKUP    @DL                                    85
      *                                                                                       CAS009
     C     *IN85         IFEQ      *OFF
     C     CDL033        ANDEQ     'N'
     C**********           MOVEL'USR9651' ZAMSID           Message id.                 CAS009 CAS011
     C                   MOVEL     'CAS0017'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   MOVE      *ON           *IN69
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *                                                                                     BUG10791
     C     *IN85         IFEQ      *OFF
     C     CDL033        ANDEQ     'Y'
     C     #1DTPE        ANDNE     'CF'
     C                   MOVEL     'CAS0018'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN69
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *                                                                                       CAS009
     C                   ENDIF
      *                                                                                       CAS009
     C                   ENDIF
      *                                                                                       CAS009
     C                   ENDIF
      *                                                                                       CAS009
      ** If Initialisation program has run, do additional validation                          231563
     C     WCAS9I        IFEQ      'Y'
      *                                                                                       231563
      ** Retrieve Deal Type/Sub Type Record                                                   231563
     C     KDTST#        CHAIN     FDDTSTL1                           70
      *                                                                                       231563
     C     #1ACAI        IFNE      FSACAI
      *                                                                                       231563
      ** Check If Deal Type/Sub Type is attached to a Live Deal.                              231563
      ** If it is, do not allow changing of ACAI                                              231563
     C********** KDTST#    CHAINDEALSL7              70                                231563 CAS011
     C     KDTST#        CHAIN     DEALSL10                           70
     C     *IN70         IFEQ      *OFF
     C                   MOVEL     'USR9652'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   MOVE      *ON           *IN69
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *                                                                                       231563
     C                   ENDIF
      *                                                                                       231563
     C                   ENDIF
      *                                                                                       231563
     C     CER047        IFEQ      'Y'
      *                                                                                       CER047
     C     #1K24C        IFNE      'Y'
     C     #1K24C        ANDNE     'N'
      *                                                                                       CER047
     C                   SETON                                        9845
      *                                                                                       CER047
      ** Send Message                                                                         CER047
      *                                                                                       CER047
     C                   MOVEL     'USR3973'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *                                                                                       CER047
     C                   ELSE
     C                   SETOFF                                       45
      *                                                                                       CER047
     C                   ENDIF
      *                                                                                       CER047
     C                   ENDIF
      *                                                                                       CER047
     C/COPY WNCPYSRC,FD0650MC09
      *================================================================
     CSR   DEEXIT        ENDSR
      /EJECT
     CSR   DFV2RC        BEGSR
      *================================================================
      * Validate subfile record relations.
      *================================================================
      * USER: Validate subfile record relations
      *CASE:     RCD.Description of Deal type/subtype is *blank
     C     #1NARR        IFEQ      *BLANK                                       *IF
      * Setup message data for message.
     C                   MOVEL     #1NARR        ZA0003                         Description of
      * Send message 'Description not entered'
     C     CDL038        IFNE      'Y'
     C                   MOVEL     'USR1776'     ZAMSID                         Message id.
     C                   MOVEL     'GBMIDAS'     ZAMSGF                         Message file.
     C                   ELSE
     C                   MOVEL     'USR9010'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   ENDIF
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9836      *
      *
     C                   END                                                    *FI
     C/COPY WNCPYSRC,FD0650MC34
      *CASE:     RCD.Subtype is invalid
     C***********KLDLST****KLIST                                                              CDL038
     C*********************KFLD           #1DLST                                              CDL038
     C***********KLDLST****CHAINSDDLSTL1             91                                       CDL038
     C************IN91*****IFEQ '1'                                                           CDL038
     C                   CALL      'AODLSTR0'
     C                   PARM      *BLANK        P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      #1DLST        P@DLST            2
     C                   PARM                    SDDLST
     C     P@RTCD        IFEQ      '*NRF   '
      * Send message 'Subtype invalid'
     C                   MOVEL     'USR1777'     ZAMSID                         Message id.
     C                   MOVEL     'GBMIDAS'     ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9835      *
     C                   ELSE
     C                   MOVEL     ASDSTC        #1DLST
     C                   END                                                    *FI
      * Send message 'Class invalid' if blank and shouldn't be.                             BUG10153
     C     CDL038        IFEQ      'Y'                                          IF
     C     #1CLAS        IFEQ      *BLANK
     C     #1DTPE        ANDNE     'OP'
     C     #1DTPE        ANDNE     'IN'
     C     #1DTPE        ANDNE     'CC'
     C     #1DTPE        ANDNE     'CP'
     C     #1DTPE        ANDNE     'NT'
     C     #1DTPE        ANDNE     'RP'
     C     #1DTPE        ANDNE     'RI'
     C     #1DTPE        ANDNE     'RO'
     C     #1DTPE        ANDNE     'BI'
     C     #1DTPE        ANDNE     'BO'
     C     #1DTPE        ANDNE     'CM'
     C                   SETON                                        9838      *
     C                   MOVEL     'USR9012'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END
      * Send message 'Class invalid' if not blank and should be.                            BUG10153
     C     #1CLAS        IFNE      *BLANK
     C     #1DTPE        IFEQ      'IN'
     C     #1DTPE        OREQ      'CC'
     C     #1DTPE        OREQ      'CP'
     C     #1DTPE        OREQ      'NT'
     C     #1DTPE        OREQ      'RI'
     C     #1DTPE        OREQ      'RO'
     C     #1DTPE        OREQ      'BI'
     C     #1DTPE        OREQ      'BO'
     C     #1DTPE        OREQ      'CM'
     C                   SETON                                        9838      *
      * Send message '*Value not required'                                                  BUG10153
     C                   MOVEL     'USR9012'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END
     C                   END
     C                   END                                                    FI
      *CASE:     RCD.Class is invalid                                                         CDL038
     C     CDL038        IFEQ      'Y'
     C***********W0PMD     IFEQ 'ADD'                                              CDL038   BUG10153
     C***********#1CLAS    ORNE *BLANK                                             CDL038   BUG10153
     C     #1CLAS        IFNE      *BLANK
     C                   CALL      'AOTCLSR0'
     C                   PARM      *BLANK        P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      #1CLAS        P@CLAS            4
     C                   PARM                    SDTCLS
     C     P@RTCD        IFEQ      '*NRF   '
      * Send message 'Class invalid'                                                          CDL038
     C                   MOVEL     'USR9012'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9838      *
     C                   ELSE
     C                   MOVEL     TCCLAS        #1CLAS
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *                                                                   CFT006
     C                   MOVEL     'N'           WERR              1                           CFT00
      *CASE:     RCD.Deal type is invalid
     C     #1DTPE        IFNE      'IT'                                         *IF
     C     #1DTPE        ANDNE     'IP'
     C     #1DTPE        ANDNE     'TD'
     C     #1DTPE        ANDNE     'TI'
     C     #1DTPE        ANDNE     'CI'
     C     #1DTPE        ANDNE     'LN'
     C     #1DTPE        ANDNE     'CD'
     C     #1DTPE        ANDNE     'CL'
     C     #1DTPE        ANDNE     'DL'
     C     #1DTPE        ANDNE     'FP'
     C     #1DTPE        ANDNE     'FS'
     C     #1DTPE        ANDNE     'CX'
     C     #1DTPE        ANDNE     'PI'
     C     #1DTPE        ANDNE     'SI'
     C     #1DTPE        ANDNE     'OP'
     C     #1DTPE        ANDNE     'OT'
     C     #1DTPE        ANDNE     'SW'
     C     #1DTPE        ANDNE     'C1'                                                        05371
     C     #1DTPE        ANDNE     'C2'                                                        05371
     C     #1DTPE        ANDNE     'BP'                                                        05371
     C     #1DTPE        ANDNE     'BD'                                                        05371
     C     #1DTPE        ANDNE     'TB'                                                        05371
     C     #1DTPE        ANDNE     'DA'                                                        05371
     C     #1DTPE        ANDNE     'TA'                                                        05371
     C     #1DTPE        ANDNE     'CS'                                                        05371
     C     #1DTPE        ANDNE     'BS'                                                        05371
     C     #1DTPE        ANDNE     'BR'                                                        05371
     C     #1DTPE        ANDNE     'TS'                                                        05371
     C     #1DTPE        ANDNE     'RA'                                                        05371
     C     #1DTPE        ANDNE     'TR'                                                        05371
     C     #1DTPE        ANDNE     'PS'                                                        05732
     C     #1DTPE        ANDNE     'ID'                                                        05732
     C     #1DTPE        ANDNE     'IL'                                                        05732
     C     #1DTPE        ANDNE     'IN'                                                        09395
     C     #1DTPE        ANDNE     'CC'                                                        09395
     C     #1DTPE        ANDNE     'CP'                                                        09395
     C     #1DTPE        ANDNE     'NT'                                                        09395
     C     #1DTPE        ANDNE     'RP'                                                        09395
     C     #1DTPE        ANDNE     'FR'                                                        10766
     C     #1DTPE        ANDNE     'RS'                                                        10766
     C     #1DTPE        ANDNE     'RX'                                                        10766
     C     #1DTPE        ANDNE     'RR'                                                        10766
     C     #1DTPE        ANDNE     'RF'                                                        10766
     C     #1DTPE        ANDNE     'NX'                                                        15116
     C/COPY WNCPYSRC,FD0650MC53
     C***********CDL006    ANDEQ'N'                                 CDL006CFT006
     C                   MOVEL     'Y'           WERR                                          CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                                       CDL033
     C     CDL033        IFEQ      'Y'
     C     #1DTPE        ANDEQ     'CF'
     C                   MOVEL     'N'           WERR
     C                   ENDIF
      *                                                                                       CDL033
      ***********                                                   CDL006CFT006
      ***If*CDL006*is*ON,*allow*also*deal*types*FL,DP,LP,FT,DT*and  CDL006CFT006
      ***********                                                   CDL006CFT006
     C***********CDL006    OREQ 'Y'                                 CDL006CFT006
     C***********#1DTPE    ANDNE'FL'                                CDL006CFT006
     C***********#1DTPE    ANDNE'DP'                                CDL006CFT006
     C***********#1DTPE    ANDNE'LP'                                CDL006CFT006
     C***********#1DTPE    ANDNE'FT'                                CDL006CFT006
     C***********#1DTPE    ANDNE'DT'                                CDL006CFT006
     C***********#1DTPE    ANDNE'LT'                                CDL006CFT006
     C***********#1DTPE    ANDNE'IT'                                CDL006CFT006
     C***********#1DTPE    ANDNE'IP'                                CDL006CFT006
     C***********#1DTPE    ANDNE'TD'                                CDL006CFT006
     C***********#1DTPE    ANDNE'TI'                                CDL006CFT006
     C***********#1DTPE    ANDNE'CI'                                CDL006CFT006
     C***********#1DTPE    ANDNE'LN'                                CDL006CFT006
     C***********#1DTPE    ANDNE'CD'                                CDL006CFT006
     C***********#1DTPE    ANDNE'CL'                                CDL006CFT006
     C***********#1DTPE    ANDNE'DL'                                CDL006CFT006
     C***********#1DTPE    ANDNE'FP'                                CDL006CFT006
     C***********#1DTPE    ANDNE'FS'                                CDL006CFT006
     C***********#1DTPE    ANDNE'CX'                                CDL006CFT006
     C***********#1DTPE    ANDNE'PI'                                CDL006CFT006
     C***********#1DTPE    ANDNE'SI'                                CDL006CFT006
     C***********#1DTPE    ANDNE'OP'                                CDL006CFT006
     C***********#1DTPE    ANDNE'OT'                                CDL006CFT006
     C***********#1DTPE    ANDNE'SW'                                CDL006CFT006
     C***********#1DTPE    ANDNE'C1'                                CDL006CFT006
     C***********#1DTPE    ANDNE'C2'                                CDL006CFT006
     C***********#1DTPE    ANDNE'BP'                                CDL006CFT006
     C***********#1DTPE    ANDNE'BD'                                CDL006CFT006
     C***********#1DTPE    ANDNE'TB'                                CDL006CFT006
     C***********#1DTPE    ANDNE'DA'                                CDL006CFT006
     C***********#1DTPE    ANDNE'TA'                                CDL006CFT006
     C***********#1DTPE    ANDNE'CS'                                CDL006CFT006
     C***********#1DTPE    ANDNE'BS'                                CDL006CFT006
     C***********#1DTPE    ANDNE'BR'                                CDL006CFT006
     C***********#1DTPE    ANDNE'TS'                                CDL006CFT006
     C***********#1DTPE    ANDNE'RA'                                CDL006CFT006
     C***********#1DTPE    ANDNE'TR'                                CDL006CFT006
     C***********#1DTPE    ANDNE'PS'                                CDL006CFT006
     C***********#1DTPE    ANDNE'ID'                                CDL006CFT006
     C***********#1DTPE    ANDNE'IL'                                CDL006CFT006
     C***********#1DTPE    ANDNE'IN'                                CDL006CFT006
     C***********#1DTPE    ANDNE'CC'                                CDL006CFT006
     C***********#1DTPE    ANDNE'CP'                                CDL006CFT006
     C***********#1DTPE    ANDNE'NT'                                CDL006CFT006
     C***********#1DTPE    ANDNE'RP'                                CDL006CFT006
     C***********#1DTPE    ANDNE'FR'                                CDL006CFT006
     C***********#1DTPE    ANDNE'RS'                                CDL006CFT006
     C***********#1DTPE    ANDNE'RX'                                CDL006CFT006
     C***********#1DTPE    ANDNE'RR'                                CDL006CFT006
     C***********#1DTPE    ANDNE'RF'                                CDL006CFT006
      *                                                                   CFT006
      ** If CDL006 is ON, allow also deal types FL,DP,LP,FT,DT and LT.    CFT006
      *                                                                   CFT006
     C     CDL006        IFEQ      'Y'                                                         CFT00
     C     #1DTPE        IFEQ      'FL'                                                        CFT00
     C     #1DTPE        OREQ      'DP'                                                        CFT00
     C     #1DTPE        OREQ      'LP'                                                        CFT00
     C     #1DTPE        OREQ      'FT'                                                        CFT00
     C     #1DTPE        OREQ      'DT'                                                        CFT00
     C     #1DTPE        OREQ      'LT'                                                        CFT00
     C     #1DTPE        OREQ      'IT'                                                        CFT00
     C     #1DTPE        OREQ      'IP'                                                        CFT00
     C     #1DTPE        OREQ      'TD'                                                        CFT00
     C     #1DTPE        OREQ      'TI'                                                        CFT00
     C     #1DTPE        OREQ      'CI'                                                        CFT00
     C     #1DTPE        OREQ      'LN'                                                        CFT00
     C     #1DTPE        OREQ      'CD'                                                        CFT00
     C     #1DTPE        OREQ      'CL'                                                        CFT00
     C     #1DTPE        OREQ      'DL'                                                        CFT00
     C     #1DTPE        OREQ      'FP'                                                        CFT00
     C     #1DTPE        OREQ      'FS'                                                        CFT00
     C     #1DTPE        OREQ      'CX'                                                        CFT00
     C     #1DTPE        OREQ      'PI'                                                        CFT00
     C     #1DTPE        OREQ      'SI'                                                        CFT00
     C     #1DTPE        OREQ      'OP'                                                        CFT00
     C     #1DTPE        OREQ      'OT'                                                        CFT00
     C     #1DTPE        OREQ      'SW'                                                        CFT00
     C     #1DTPE        OREQ      'C1'                                                        CFT00
     C     #1DTPE        OREQ      'C2'                                                        CFT00
     C     #1DTPE        OREQ      'BP'                                                        CFT00
     C     #1DTPE        OREQ      'BD'                                                        CFT00
     C     #1DTPE        OREQ      'TB'                                                        CFT00
     C     #1DTPE        OREQ      'DA'                                                        CFT00
     C     #1DTPE        OREQ      'TA'                                                        CFT00
     C     #1DTPE        OREQ      'CS'                                                        CFT00
     C     #1DTPE        OREQ      'BS'                                                        CFT00
     C     #1DTPE        OREQ      'BR'                                                        CFT00
     C     #1DTPE        OREQ      'TS'                                                        CFT00
     C     #1DTPE        OREQ      'RA'                                                        CFT00
     C     #1DTPE        OREQ      'TR'                                                        CFT00
     C     #1DTPE        OREQ      'PS'                                                        CFT00
     C     #1DTPE        OREQ      'ID'                                                        CFT00
     C     #1DTPE        OREQ      'IL'                                                        CFT00
     C     #1DTPE        OREQ      'IN'                                                        CFT00
     C     #1DTPE        OREQ      'CC'                                                        CFT00
     C     #1DTPE        OREQ      'CP'                                                        CFT00
     C     #1DTPE        OREQ      'NT'                                                        CFT00
     C     #1DTPE        OREQ      'RP'                                                        CFT00
     C     #1DTPE        OREQ      'FR'                                                        CFT00
     C     #1DTPE        OREQ      'RS'                                                        CFT00
     C     #1DTPE        OREQ      'RX'                                                        CFT00
     C     #1DTPE        OREQ      'RR'                                                        CFT00
     C     #1DTPE        OREQ      'RF'                                                        CFT00
     C     #1DTPE        OREQ      'NX'                                                        15116
     C                   MOVEL     'N'           WERR                                          CFT00
     C                   ENDIF                                                                 CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      ** If CFT006 is ON, allow also deal types RI,RO                     CFT006
      *                                                                   CFT006
     C     CFT006        IFEQ      'Y'                                                         CFT00
     C     #1DTPE        IFEQ      'RI'                                                        CFT00
     C     #1DTPE        OREQ      'RO'                                                        CFT00
     C                   MOVEL     'N'           WERR                                          CFT00
     C                   ENDIF                                                                 CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT008
      ** If CFT008 is ON, allow also deal types BI,BO                     CFT008
      *                                                                   CFT008
     C     CFT008        IFEQ      'Y'                                                         CFT00
     C     #1DTPE        IFEQ      'BI'                                                        CFT00
     C     #1DTPE        OREQ      'BO'                                                        CFT00
     C                   MOVEL     'N'           WERR                                          CFT00
     C                   ENDIF                                                                 CFT00
     C                   ENDIF                                                                 CFT00
     C/COPY WNCPYSRC,FDH00022
      *                                                                   CRE008
      ** If CRE008 is ON, allow also deal type  CM                        CRE008
      *                                                                   CRE008
     C     CRE008        IFEQ      'Y'                                                         CRE00
     C     #1DTPE        IFEQ      'CM'                                                        CRE00
     C                   MOVEL     'N'           WERR                                          CRE00
     C                   ENDIF                                                                 CRE00
     C                   ENDIF                                                                 CRE00
      *                                                                   S01408
     C/COPY WNCPYSRC,FD0650MC11                                           S01408
     C     WERR          IFEQ      'Y'                                                         CFT00
      *                                                                   S01408
      * Send message 'Deal type invalid'
     C                   MOVEL     'USR1778'     ZAMSID                         Message id.
     C                   MOVEL     'GBMIDAS'     ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9834      *
     C                   END                                                    *FI
      *                                                                                       207288
      ** Validate spot indicator                                                              207288
      *                                                                                       207288
     C     BGN4ST        IFEQ      'Y'
     C     *IN46         IFEQ      '0'
     C                   MOVE      '1'           *IN46
     C                   ENDIF
     C                   EXSR      VALSPT
     C                   ELSE
     C                   MOVE      '0'           *IN46
     C                   ENDIF
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MVSF                                           S01408
     C*                                                                   S01408
      ** If CAS001 enhancement is ON, validate Yield Curves:                                  CAS001
      *                                                                                       CAS001
     C     CAS001        IFEQ      'Y'
     C/COPY WNCPYSRC,FDH00048
      *                                                                                       CAS001
      ** Validate Buy/Our Yield Curve                                                         CAS001
      *                                                                                       CAS001
     C     #1OURY        IFNE      *BLANK
     C                   CALL      'AOYLDCR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1OURY        PYLDC             5
     C     SDYLDC        PARM      SDYLDC        DSSDY
      *                                                                                       CAS001
     C                   MOVEL     PYLDC         #1OURY
      *                                                                                       CAS001
     C     PRTCD         IFEQ      '*NRF'
     C                   MOVE      *ON           *IN71
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9157'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CAS001
      ** Validate Sell/Their Yield Curve                                                      CAS001
      *                                                                                       CAS001
     C     #1THRY        IFNE      *BLANK
     C                   CALL      'AOYLDCR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1THRY        PYLDC
     C     SDYLDC        PARM      SDYLDC        DSSDY
      *                                                                                       CAS001
     C                   MOVEL     PYLDC         #1THRY
      *                                                                                       CAS001
     C     PRTCD         IFEQ      '*NRF'
     C                   MOVE      *ON           *IN72
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9182'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CAS001
      ** Optional only for the following deal type:                                           CAS001
      ** FP,FS,CX,OP,OT,SW,SI,PI,RX                                                           CAS001
      ** When CAS005 is On, Their Sell Yield Curve is                                         CAS005
      ** also optional for deal type RS                                                       CAS005
      *                                                                                       CAS001
     C     #1DTPE        IFEQ      'FP'
     C     #1DTPE        OREQ      'FS'
     C     #1DTPE        OREQ      'CX'
     C     #1DTPE        OREQ      'OP'
     C     #1DTPE        OREQ      'OT'
     C     #1DTPE        OREQ      'SW'
     C     #1DTPE        OREQ      'SI'
     C     #1DTPE        OREQ      'PI'
     C     #1DTPE        OREQ      'RX'
     C     CAS005        OREQ      'Y'
     C     #1DTPE        ANDEQ     'RS'
     C                   ELSE
     C                   MOVE      *ON           *IN72
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9156'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CAS001
      ** Validate Yield Curve Mandatory entry                                                 CAS001
      *                                                                                       CAS001
     C     #1YLDM        IFEQ      *BLANK
     C     #1YLDM        OREQ      'Y'
     C     #1YLDM        OREQ      'N'
      *                                                                                       CAS001
     C                   ELSE
     C                   MOVE      *ON           *IN73
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9155'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CAS001
      ** If CAS005 is ON, validate Yield Curves:                                              CAS005
      *                                                                                       CAS005
     C     CAS005        IFEQ      'Y'
      *                                                                                       CAS005
      ** Validate Buy/Our Forward Yield Curve                                                 CAS005
      *                                                                                       CAS005
     C     #1ORFY        IFNE      *BLANK
     C                   CALL      'AOYLDCR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1ORFY        PYLDC
     C     SDYLDC        PARM      SDYLDC        DSSDY
      *                                                                                       CAS005
     C                   MOVEL     PYLDC         #1ORFY
      *                                                                                       CAS005
     C     PRTCD         IFEQ      '*NRF'
     C                   MOVE      *ON           *IN74
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9644'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CAS005
      ** Validate Sell/Their Forward Yield Curve                                              CAS005
      *                                                                                       CAS005
     C     #1THFY        IFNE      *BLANK
     C                   CALL      'AOYLDCR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1THFY        PYLDC
     C     SDYLDC        PARM      SDYLDC        DSSDY
      *                                                                                       CAS005
     C                   MOVEL     PYLDC         #1THFY
      *                                                                                       CAS005
     C     PRTCD         IFEQ      '*NRF'
     C                   MOVE      *ON           *IN75
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9645'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CAS005
      ** Optional only for the following deal type:                                           CAS005
      ** FP,FS,CX,OP,OT,SW,SI,PI,RX,RS                                                        CAS005
      *                                                                                       CAS005
     C     #1DTPE        IFEQ      'FP'
     C     #1DTPE        OREQ      'FS'
     C     #1DTPE        OREQ      'CX'
     C     #1DTPE        OREQ      'OP'
     C     #1DTPE        OREQ      'OT'
     C     #1DTPE        OREQ      'SW'
     C     #1DTPE        OREQ      'SI'
     C     #1DTPE        OREQ      'PI'
     C     #1DTPE        OREQ      'RS'
     C     #1DTPE        OREQ      'RX'
     C                   ELSE
     C                   MOVE      *ON           *IN75
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9156'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CAS005
      ** Validate Yield Curve Mandatory entry                                                 CAS005
      *                                                                                       CAS005
     C     #1FYCM        IFEQ      *BLANK
     C     #1FYCM        OREQ      'Y'
     C     #1FYCM        OREQ      'N'
      *                                                                                       CAS005
     C                   ELSE
     C                   MOVE      *ON           *IN76
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9155'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CDL019
      ** If CDL019 enhancement is ON, validate Fix Base Rate                                  CDL019
      *                                                                                       CDL019
     C     CDL019        IFEQ      'Y'
      *                                                                                       CDL019
     C     #1DTPE        IFEQ      'IT'
     C     #1DTPE        OREQ      'TD'
     C     #1DTPE        OREQ      'IP'
     C     #1DTPE        OREQ      'TI'
     C                   MOVE      *ON           *IN59
     C                   ELSE
     C                   MOVE      *OFF          *IN59
     C                   ENDIF
      *                                                                                       CDL019
     C     #1FBRT        IFNE      *BLANK
     C     #1FBRT        ANDNE     'Y'
     C     #1FBRT        ANDNE     'N'
      *                                                                                       CDL019
     C                   MOVE      *ON           *IN58
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9155'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C     #1FBRT        IFEQ      *BLANK
     C     W0PMD         ANDEQ     'ADD'
     C                   MOVE      'N'           #1FBRT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CAS005
      ** Validate the Global Product and Instrument Codes if CGP001                           CGP001
      ** is enabled.                                                                          CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRVGPC
     C                   EXSR      SRVGIC
     C                   ENDIF
      *                                                                                       CGP001
      ** If CAS008 and CIR003, Validate Fwd Commitment yield curve                            CAS008
      *                                                                                       CAS008
     C     CAS008        IFEQ      'Y'
     C     CIR003        ANDEQ     'Y'
      *                                                                                       CAS008
      ** Validate Buy/Our Forward Cmt Yield Curve                                             CAS008
      *                                                                                       CAS008
     C     #1OFCY        IFNE      *BLANK
     C     #1DTPE        ANDEQ     'RX'
     C                   CALL      'AOYLDCR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1OFCY        PYLDC
     C     SDYLDC        PARM      SDYLDC        DSSDY
      *                                                                                       CAS008
     C                   MOVEL     PYLDC         #1OFCY
      *                                                                                       CAS008
     C     PRTCD         IFEQ      '*NRF'
     C                   MOVE      *ON           *IN61
     C                   MOVE      *ON           *IN98
      *                                                                                       CAS008
      ** Buy/Our Forward Commitment Yield Curve not valid                                     CAS008
      *                                                                                       CAS008
     C                   MOVEL     'USR9655'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CAS008
     C     #1OFCY        IFNE      *BLANK
     C     #1DTPE        ANDNE     'RX'
      *                                                                                       CAS008
     C                   MOVE      *ON           *IN61
     C                   MOVE      *ON           *IN98
      *                                                                                       CAS008
      ** Forward Commitment Yield Curve must be blank if deal type                            CAS008
      ** is not 'RX'.                                                                         CAS008
      *                                                                                       CAS008
     C                   MOVEL     'USR9657'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CAS008
      ** Validate Sell/Their Forward Cmt Yield Curve                                          CAS008
      *                                                                                       CAS008
     C     #1TFCY        IFNE      *BLANK
     C     #1DTPE        ANDEQ     'RX'
     C                   CALL      'AOYLDCR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1TFCY        PYLDC
     C     SDYLDC        PARM      SDYLDC        DSSDY
      *                                                                                       CAS008
     C                   MOVEL     PYLDC         #1TFCY
      *                                                                                       CAS008
     C     PRTCD         IFEQ      '*NRF'
     C                   MOVE      *ON           *IN62
     C                   MOVE      *ON           *IN98
      *                                                                                       CAS008
      ** Sell/Their Forward Commitment Yield Curve not valid                                  CAS008
      *                                                                                       CAS008
     C                   MOVEL     'USR9656'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CAS008
     C     #1TFCY        IFNE      *BLANK
     C     #1DTPE        ANDNE     'RX'
      *                                                                                       CAS008
     C                   MOVE      *ON           *IN62
     C                   MOVE      *ON           *IN98
      *                                                                                       CAS008
      ** Forward Commitment Yield Curve must be blank if deal type                            CAS008
      ** is not 'RX'.                                                                         CAS008
      *                                                                                       CAS008
     C                   MOVEL     'USR9658'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CAS008
      ** Validate Fwd Cmt Yield Curve Mandatory entry                                         CAS008
      *                                                                                       CAS008
     C     #1DTPE        IFEQ      'RX'
      *                                                                                       CAS008
     C     #1FCCM        IFEQ      *BLANK
     C     #1FCCM        OREQ      'Y'
     C     #1FCCM        OREQ      'N'
     C                   ELSE
     C                   MOVE      *ON           *IN63
     C                   MOVE      *ON           *IN98
      *                                                                                       CAS008
      ** Valid values are 'Y', 'N' and blank                                                  CAS008
      *                                                                                       CAS008
     C                   MOVEL     'USR9155'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CAS008
     C                   ELSE
      *                                                                                       CAS008
     C     #1FCCM        IFNE      *BLANK
     C                   MOVE      *ON           *IN63
     C                   MOVE      *ON           *IN98
      *                                                                                       CAS008
      ** Forward Commitment Yield Curve Mandatory must be blank if                            CAS008
      ** deal type is not 'RX'.                                                               CAS008
      *                                                                                       CAS008
     C                   MOVEL     'USR9659'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CAS008
     C                   ENDIF
      *                                                                                       CAS008
     C                   ENDIF
      *                                                                                       CAS008
      *================================================================
     CSR   DFEXIT        ENDSR
      /EJECT
     CSR   EAPRSF        BEGSR
      *================================================================
      * Update DBF from subfile records.
      *================================================================
      * Initialise subfile reload flag.
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'Y'           W0RSF
     C                   ELSE
     C                   MOVEL     'N'           W0RSF
     C                   END
      * Process all modified subfile records.
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
      * Process modified subfile record.
     C                   EXSR      EBPRSR
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes.
     C                   ROLBK
     C                   ELSE
      * Otherwise COMMIT any DBF changes.
     C                   COMMIT
     C                   END
     C                   MOVEL     *BLANK        #1SEL
      * Set screen conditioning indicators.
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      * If any errors, cancel reload.
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'N'           W0RSF             1
     C                   END
      *================================================================
     CSR   EAEXIT        ENDSR
      /EJECT
     CSR   EBPRSR        BEGSR
      *================================================================
      * Process modified subfile record.
      *================================================================
      * Set off error indicators.
     C/COPY WNCPYSRC,FD0650MC20
     C*********************MOVEAWKIND0    *IN,32           Clear errors                       CDL038
     C                   MOVEA     WKIND0        *IN(30)
     C                   MOVE      *OFF          *IN71
     C                   MOVE      *OFF          *IN72
     C                   MOVE      *OFF          *IN73
     C                   MOVE      *OFF          *IN74
     C                   MOVE      *OFF          *IN75
     C                   MOVE      *OFF          *IN76
     C                   MOVE      *OFF          *IN41
     C                   MOVE      *OFF          *IN42
     C                   MOVE      *OFF          *IN58
     C                   MOVE      *OFF          *IN61
     C                   MOVE      *OFF          *IN62
     C                   MOVE      *OFF          *IN63
     C                   MOVE      *OFF          *IN69
      *                                                                                       CER047
     C     CER047        IFEQ      'Y'
     C                   SETOFF                                       45
     C                   ENDIF
      *                                                                                       CER047
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MCP3                                           S01408
     C*                                                                   S01408
     C                   SETOFF                                       98        No errors
      *
     C     W0PMD         IFEQ      'ADD'
      * Process add request.
     C     #1SEL         IFNE      'D'
     C                   EXSR      DDNLRC
     C     W0NLR         IFNE      'Y'
     C                   EXSR      ECADRQ
     C                   END
     C                   END
     C                   ELSE
     C     #1SEL         IFEQ      'D'
      * Process delete request.
     C                   EXSR      EDDLRQ
     C                   ELSE
      * Process change request.
     C                   EXSR      EECHRQ
     C                   END
     C                   END
      * If error occurred on update, note the fact.
     C     *IN98         IFEQ      '1'
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     ##RR          ##SFRC               99        Error on update
     C                   END
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request.
      *================================================================
      * USER: Create DBF record
      * Create Deal type/subtype record
     C                   EXSR      SACRRC
     C     W0RTN         IFNE      *BLANK
      * Write error detected.
     C/COPY WNCPYSRC,FD0650MC21
     C                   MOVE      '1'           *IN(34)                        Screen errors
     C                   MOVE      '1'           *IN(35)                        Screen errors
     C                   MOVE      '1'           *IN(36)                        Screen errors
     C                   MOVE      '1'           *IN(37)                        Screen errors  S0148
     C                   MOVE      '1'           *IN(38)                        Screen errors
     C                   MOVE      '1'           *IN(38)
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MCP5                                           S01408
     C*                                                                   S01408
     C                   SETON                                        98        Format Error
     C                   SETOFF                                       87        Enable entry
     C                   SETON                                        84        SFLNXTCHG
     C                   ELSE
      * DBF Write successful.
     C                   SETON                                        87        Disable entry
     C                   SETOFF                                       84        No SFLNXTCHG
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request.
      *================================================================
      * USER: Delete DBF record
      * Delete Deal type/Subtype record  *
     C/COPY WNCPYSRC,FD0650MC06
     C                   EXSR      SCDLRC
     C/COPY WNCPYSRC,FD0650MC07
     C     W0RTN         IFNE      *BLANK
      * Delete unsuccessful.
     C/COPY WNCPYSRC,FD0650MC22
     C                   MOVE      '1'           *IN(33)                        Screen errors
     C                   MOVE      '1'           *IN(34)                        Screen errors
     C                   MOVE      '1'           *IN(35)                        Screen errors
     C                   MOVE      '1'           *IN(36)                        Screen errors
     C                   MOVE      '1'           *IN(37)                        Screen errors  S0148
     C                   MOVE      '1'           *IN38
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MCP5                                           S01408
     C*                                                                   S01408
     C                   SETON                                        98        Format Error
     C                   SETOFF                                       87        Enable entry
     C                   SETON                                        84        SFLNXTCHG
      * If record altered, reset subfile record.
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF Delete successful.
      * Blank out record and protect from entry.
     C                   EXSR      MAIZ#1
     C                   SETON                                        87        Disable entry
     C                   SETOFF                                       84        No SFLNXTCHG
     C                   MOVEL     'Y'           W0RSF             1            Reload subfile
     C                   END                                                    FI W0RTCD
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request.
      *================================================================
      * USER: Change DBF record
      * Change Deal type/subtype record
     C                   EXSR      SECHRC
     C     W0RTN         IFNE      *BLANK
      * DBF Update error detected.
     C/COPY WNCPYSRC,FD0650MC23
     C                   MOVE      '1'           *IN(34)                        Screen errors
     C                   MOVE      '1'           *IN(35)                        Screen errors
     C                   MOVE      '1'           *IN(36)                        Screen errors
     C                   MOVE      '1'           *IN(37)                        Screen errors  S0148
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MCP5                                           S01408
     C*                                                                   S01408
     C                   SETON                                        98        Format Error
     C                   SETOFF                                       87        Enable entry
     C                   SETON                                        84        SFLNXTCHG
      * Reset subfile record if changed record.
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF Update successful.
     C                   SETOFF                                       87        Enable entry
     C                   SETOFF                                       84        No SFLNXTCHG
     C                   END                                                    FI W0RTCD
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACHMD        BEGSR
      *================================================================
      * Flip between *ADD and *CHANGE modes.
      *================================================================
     C     W0PMD         IFNE      'ADD'
     C                   MOVEL     'ADD'         W0PMD
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
     C                   END
     C                   EXSR      FBRQRL
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      * Request subfile reload.
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
      /EJECT
     CSR   GADSA1        BEGSR
      *================================================================
      * Set display attributes for Subfile record.
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect keys if change mode or updated record.
     C                   SETON                                        88        *
     C   89
     CANN87              SETOFF                                       88        *
     C                   MOVEL     *IN87         *IN79
     C     WUDELA        IFEQ      @CN(05)                                      *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     *IN87         *IN78
     C/COPY WNCPYSRC,FD0650MC35
     C     WUAMAL        IFEQ      @CN(05)                                      *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSA2        BEGSR
      *================================================================
      * Set display attributes for Subfile control.
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise subfile record.
      *================================================================
     C                   MOVEL     *BLANK        #1DBRC                         Previous values
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #1DTPE                         Deal type
     C                   MOVEL     *BLANK        #1DLST                         Subtype
     C                   MOVEL     *BLANK        #1CLAS                         Class
     C                   MOVEL     *BLANK        #1NARR                         Description of
     C                   MOVEL     *BLANK        #1INNR                         Instrument typeS0148
     C                   MOVEL     *BLANK        #1FBRT                         Fix Base Rate
     C/COPY WNCPYSRC,FD0650MC40
     C                   MOVEL     *BLANK        #1PLDP                         Pricing Group  CPL00
     C/COPY WNCPYSRC,FDH00023
     C                   MOVEL     *BLANK        #1PLDR                         Reporting GroupCPL00
     C                   MOVEL     *BLANK        #1PLCR                         Credit Rating  CPL00
     C                   MOVEL     *BLANK        #1SFLG
     C                   MOVEL     *BLANK        #1OURY
     C                   MOVEL     *BLANK        #1THRY
     C                   MOVEL     *BLANK        #1YLDM
     C/COPY WNCPYSRC,FDH00049
     C                   MOVEL     *BLANK        #1ORFY
     C                   MOVEL     *BLANK        #1THFY
     C                   MOVEL     *BLANK        #1FYCM
     C                   MOVE      *BLANKS       #1PRDC
     C                   MOVE      *BLANKS       #1INSC
     C                   MOVEL     *BLANK        #1OFCY
     C                   MOVEL     *BLANK        #1TFCY
     C                   MOVEL     *BLANK        #1FCCM
     C                   MOVE      *BLANK        #1ACAI                         Amort Cost Acct Ind.
      *                                                                                       CER047
     C     CER047        IFEQ      'Y'
     C                   MOVEL     'Y'           #1K24C
     C                   ENDIF
      *                                                                                       CER047
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MCP6                                           S01408
     C*                                                                   S01408
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @FDDTST1 fields to subfile.
      *================================================================
     C/COPY WNCPYSRC,FD0650MC36
     C                   Z-ADD     LCD11         #1LCD                          Last Change Dat
     C                   MOVEL     TYLC11        #1TYLC                         Type of Last Ch
     C                   MOVEL     DTPE11        #1DTPE                         Deal type
     C                   MOVEL     DLST11        #1DLST                         Subtype
     C                   MOVEL     CLAS11        #1CLAS                         Class
     C                   MOVEL     NARR11        #1NARR                         Description of
     C                   MOVEL     INNR          #1INNR                         Instrument typeS0148
     C                   MOVEL     FDFBRT        #1FBRT                         Fix Base Rate
     C/COPY WNCPYSRC,FD0650MC41
     C                   MOVEL     PLDPCD        #1PLDP                         Pricing Group  CPL00
     C                   MOVEL     PLDRCD        #1PLDR                         Reporting GroupCPL00
     C                   MOVEL     PLCRED        #1PLCR                         Credit Rating  CPL00
      *                                                                                       207288
      ** Load spot indicator.                                                                 207288
      *                                                                                       207288
     C     KSECU         KLIST
     C                   KFLD                    TFDTPE
     C                   KFLD                    TFDLST
      *                                                                                       207288
     C     BGN4ST        IFEQ      'Y'
     C     #1DTPE        IFEQ      'FP'
     C     #1DTPE        OREQ      'FS'
     C     #1DTPE        OREQ      'CX'
     C     #1DTPE        OREQ      'PI'
     C     #1DTPE        OREQ      'SI'
     C     #1DTPE        OREQ      'OP'
     C     #1DTPE        OREQ      'OT'
     C     #1DTPE        OREQ      'SW'
     C                   MOVEL     DTPE11        TFDTPE
     C                   MOVEL     DLST11        TFDLST
     C     KSECU         CHAIN     RTVIDX                             90
     C     *IN90         IFEQ      '0'
     C                   MOVE      TFSPOT        #1SFLG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     FSOURY        #1OURY
     C                   MOVEL     FSTHRY        #1THRY
     C                   MOVEL     FSYLDM        #1YLDM
     C                   MOVEL     FSORFY        #1ORFY
     C                   MOVEL     FSTHFY        #1THFY
     C                   MOVEL     FSFYCM        #1FYCM
      *                                                                                       CDL019
     C     CDL019        IFEQ      'Y'
     C     #1DTPE        IFEQ      'IT'
     C     #1DTPE        OREQ      'TD'
     C     #1DTPE        OREQ      'IP'
     C     #1DTPE        OREQ      'TI'
     C                   MOVE      *ON           *IN59
     C                   ELSE
     C                   MOVE      *OFF          *IN59
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CGP001
      ** Move the Global Product and Instrument Codes to screen fields                        CGP001
      ** if CGP001 is enabled.                                                                CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPPI
     C                   ENDIF
      *                                                                                       CAS008
     C                   MOVEL     FSOFCY        #1OFCY
     C                   MOVEL     FSTFCY        #1TFCY
     C                   MOVEL     FSFCCM        #1FCCM
     C                   MOVE      FSACAI        #1ACAI
      *                                                                                       CER047
     C     CER047        IFEQ      'Y'
     C                   MOVEL     FSK24C        #1K24C
     C                   ENDIF
      *                                                                                       CER047
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MCP7                                           S01408
     C*                                                                   S01408
      * Hold current record image for change detection.
     C                   MOVEL     @1DBRC        #1DBRC
     C/COPY WNCPYSRC,FDH00024
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control.
      *================================================================
     C                   MOVEL     *BLANK        #2DTPE                         Deal type
     C                   MOVEL     *BLANK        #2DLST                         Subtype
     C                   MOVEL     *BLANK        #2CLAS                         Class
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Deal type/subtypes
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to record
     C                   MOVEL     #1DTPE        DTPE11                         Deal type
     C                   MOVEL     #1DLST        DLST11                         Subtype
     C                   MOVEL     #1CLAS        CLAS11                         Class
     C                   Z-ADD     WURDNB        LCD11                          Last Change Dat
     C                   MOVEL     @CN(19)       TYLC11                         Type of Last Ch
     C                   MOVEL     #1NARR        NARR11                         Description of
     C                   MOVEL     #1INNR        INNR                           Instrument typeS0148
     C                   MOVEL     #1FBRT        FDFBRT                         Fix Base Rate
     C/COPY WNCPYSRC,FD0650MC42
     C                   MOVEL     #1PLDP        PLDPCD                         Pricing Group  CPL00
     C                   MOVEL     #1PLDR        PLDRCD                         Reporting GroupCPL00
     C                   MOVEL     #1PLCR        PLCRED                         Credit Rating  CPL00
     C                   MOVEL     #1OURY        FSOURY
     C                   MOVEL     #1THRY        FSTHRY
     C                   MOVEL     #1YLDM        FSYLDM
     C                   MOVEL     #1ORFY        FSORFY
     C                   MOVEL     #1THFY        FSTHFY
     C                   MOVEL     #1FYCM        FSFYCM
     C                   MOVEL     #1OFCY        FSOFCY
     C                   MOVEL     #1TFCY        FSTFCY
     C                   MOVEL     #1FCCM        FSFCCM
     C                   MOVE      #1ACAI        FSACAI
      *                                                                                       CER047
     C     CER047        IFEQ      'Y'
     C                   MOVEL     #1K24C        FSK24C
     C                   ENDIF
      *                                                                                       CER047
     C/COPY WNCPYSRC,FD0650MC15
      *
     C     KLCRSA        KLIST
     C                   KFLD                    DTPE11                         Deal type
     C                   KFLD                    DLST11                         Subtype
     C                   KFLD                    CLAS11                         Class
      * Check for duplicate primary key.
     C/COPY WNCPYSRC,FD0650MC43
     C     KLCRSA        SETLL     @FDDTST0                               90    *
     C/COPY WNCPYSRC,FD0650MC28
     C     *IN90         IFEQ      '1'
     C     CDL038        IFNE      'Y'
     C                   MOVEL     'USR1779'     W0RTN             7
      * Send message 'Deal type/subtype exists '
     C                   MOVEL     'USR1779'     ZAMSID                         Message id.
     C                   MOVEL     'GBMIDAS'     ZAMSGF                         Message file.
     C                   ELSE
     C                   MOVEL     'USR9011'     W0RTN             7
      * Send message 'Deal type/subtype/class exists'                                         CDL038
     C                   MOVEL     'USR9011'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   ENDIF
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SAEXIT
     C                   END
      *
     C/COPY WNCPYSRC,FD0650MC24
     C                   WRITE     @FDDTST0                             91      *
     C/COPY WNCPYSRC,FDH00025
      *                                                                                       207288
      ** Write new record on extension file.                                                  207288
      *                                                                                       207288
     C     *IN91         IFEQ      '0'
     C     BGN4ST        ANDEQ     'Y'
     C     #1DTPE        IFEQ      'FP'
     C     #1DTPE        OREQ      'FS'
     C     #1DTPE        OREQ      'CX'
     C     #1DTPE        OREQ      'PI'
     C     #1DTPE        OREQ      'SI'
     C     #1DTPE        OREQ      'OP'
     C     #1DTPE        OREQ      'OT'
     C     #1DTPE        OREQ      'SW'
     C                   MOVEL     #1DTPE        TFDTPE
     C                   MOVEL     #1DLST        TFDLST
     C     KSECU         CHAIN     UPDIDX                             90
     C     *IN90         IFEQ      '1'
     C                   MOVEL     #1SFLG        TFSPOT
     C                   WRITE     UPDIDX                               91
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN91         IFEQ      '1'
      * Write error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *                                                                                       CGP001
      ** Save the Global Product and Instrument Codes to the Cross-                           CGP001
      ** Reference Files if CGP001 is enabled.                                                CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPXU
     C                   ENDIF
     C                   END
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MCAU                                           S01408
     C*                                                                   S01408
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SCDLRC        BEGSR
      *================================================================
      * Delete Deal type/subtypes
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @FDDTST0
     C                   MOVEL     #1DTPE        DTPE11                         Deal type
     C                   MOVEL     #1DLST        DLST11                         Subtype
     C                   MOVEL     #1CLAS        CLAS11                         Class
      *
     C     KLDLSC        KLIST
     C                   KFLD                    DTPE11                         Deal type
     C                   KFLD                    DLST11                         Subtype
     C                   KFLD                    CLAS11                         Class
     C/COPY WNCPYSRC,FD0650MC44
     C     KLDLSC        CHAIN     @FDDTST0                           9091      *
     C     *IN90         IFEQ      '0'
     C     *IN91         ANDEQ     '0'
     C     BGN4ST        ANDEQ     'Y'
     C     #1DTPE        IFEQ      'FP'
     C     #1DTPE        OREQ      'FS'
     C     #1DTPE        OREQ      'CX'
     C     #1DTPE        OREQ      'PI'
     C     #1DTPE        OREQ      'SI'
     C     #1DTPE        OREQ      'OP'
     C     #1DTPE        OREQ      'OT'
     C     #1DTPE        OREQ      'SW'
     C                   MOVEL     DTPE11        TFDTPE
     C                   MOVEL     DLST11        TFDLST
     C     KSECU         CHAIN     UPDIDX                             9091
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,FD0650MC29
     C     *IN90         IFEQ      '1'
      * Record already deleted.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SCEXIT
     C                   END
      *
      * Check for changed record.
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C/COPY WNCPYSRC,FDH00026
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
      * Use SETLL to release record lock.
     C/COPY WNCPYSRC,FD0650MC45
     C     KLDLSC        SETLL     @FDDTST0                           9091      *
     C     BGN4ST        IFEQ      'Y'
     C     KSECU         SETLL     UPDIDX
     C                   ENDIF
     C/COPY WNCPYSRC,FD0650MC30
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C/COPY WNCPYSRC,FD0650MC46
     C                   DELETE    @FDDTST0                             91      *
     C/COPY WNCPYSRC,FDH00027
      *                                                                                       207288
      ** Delete record on extension file.                                                     207288
      *                                                                                       207288
     C     *IN91         IFEQ      '0'
     C     BGN4ST        ANDEQ     'Y'
     C     #1DTPE        IFEQ      'FP'
     C     #1DTPE        OREQ      'FS'
     C     #1DTPE        OREQ      'CX'
     C     #1DTPE        OREQ      'PI'
     C     #1DTPE        OREQ      'SI'
     C     #1DTPE        OREQ      'OP'
     C     #1DTPE        OREQ      'OT'
     C     #1DTPE        OREQ      'SW'
     C                   DELETE    UPDIDX                               91
     C                   ENDIF
     C                   ENDIF
     C     *IN91         IFEQ      '1'
      * Delete error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *                                                                                       CGP001
      ** Enforce referential integrity if CGP001 is enabled.                                  CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPXD
     C                   ENDIF
     C/COPY WNCPYSRC,FD0650MC16
     C                   END
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MDAU                                           S01408
     C*                                                                   S01408
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SECHRC        BEGSR
      *================================================================
      * Change Deal type/subtypes
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @FDDTST0
     C                   MOVEL     #1DTPE        DTPE11                         Deal type
     C                   MOVEL     #1DLST        DLST11                         Subtype
     C                   MOVEL     #1CLAS        CLAS11                         Class
      *
     C     KLCHSE        KLIST
     C                   KFLD                    DTPE11                         Deal type
     C                   KFLD                    DLST11                         Subtype
     C                   KFLD                    CLAS11                         Class
     C/COPY WNCPYSRC,FD0650MC47
     C     KLCHSE        CHAIN     @FDDTST0                           9091      *
     C     *IN90         IFEQ      '0'
     C     *IN91         ANDEQ     '0'
     C     BGN4ST        ANDEQ     'Y'
     C     #1DTPE        IFEQ      'FP'
     C     #1DTPE        OREQ      'FS'
     C     #1DTPE        OREQ      'CX'
     C     #1DTPE        OREQ      'PI'
     C     #1DTPE        OREQ      'SI'
     C     #1DTPE        OREQ      'OP'
     C     #1DTPE        OREQ      'OT'
     C     #1DTPE        OREQ      'SW'
     C                   MOVEL     DTPE11        TFDTPE
     C                   MOVEL     DLST11        TFDLST
     C     KSECU         CHAIN     UPDIDX                             9091
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,FD0650MC31
      *
     C     *IN90         IFEQ      '1'
      * Record not found.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SEEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SEEXIT
     C                   END
      *
      * Check for changed record.
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C/COPY WNCPYSRC,FDH00028
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
      * Use SETLL to release record lock.
     C/COPY WNCPYSRC,FD0650MC48
     C     KLCHSE        SETLL     @FDDTST0                           9091      *
     C     BGN4ST        IFEQ      'Y'
     C     KSECU         SETLL     UPDIDX
     C                   ENDIF
     C                   GOTO      SEEXIT
     C                   END                                                    FI #1DBRC
     C/COPY WNCPYSRC,FD0650MC25
      * Move Non-key fields to @FDDTST0
     C                   Z-ADD     WURDNB        LCD11                          Last Change Dat
     C                   MOVEL     @CN(23)       TYLC11                         Type of Last Ch
     C                   MOVEL     #1NARR        NARR11                         Description of
     C                   MOVEL     #1INNR        INNR                           Instrument typeS0148
     C                   MOVEL     #1FBRT        FDFBRT                         Fix Base Rate
     C/COPY WNCPYSRC,FD0650MC49
     C                   MOVEL     #1PLDP        PLDPCD                         Pricing Group  CPL00
     C                   MOVEL     #1PLDR        PLDRCD                         Reporting GroupCPL00
     C                   MOVEL     #1PLCR        PLCRED                         Credit Rating  CPL00
     C                   MOVEL     #1SFLG        TFSPOT
     C                   MOVEL     #1OURY        FSOURY
     C                   MOVEL     #1THRY        FSTHRY
     C                   MOVEL     #1YLDM        FSYLDM
     C                   MOVEL     #1ORFY        FSORFY
     C                   MOVEL     #1THFY        FSTHFY
     C                   MOVEL     #1FYCM        FSFYCM
     C                   MOVEL     #1OFCY        FSOFCY
     C                   MOVEL     #1TFCY        FSTFCY
     C                   MOVEL     #1FCCM        FSFCCM
     C                   MOVE      #1ACAI        FSACAI
      *                                                                                       CER047
     C                   MOVE      #1K24C        FSK24C
      *
     C/COPY WNCPYSRC,FD0650MC50
     C                   UPDATE    @FDDTST0                             91      *
      *                                                                                       207288
      ** Update extension file.                                                               207288
      *                                                                                       207288
     C     *IN91         IFEQ      '0'
     C     BGN4ST        ANDEQ     'Y'
     C     #1DTPE        IFEQ      'FP'
     C     #1DTPE        OREQ      'FS'
     C     #1DTPE        OREQ      'CX'
     C     #1DTPE        OREQ      'PI'
     C     #1DTPE        OREQ      'SI'
     C     #1DTPE        OREQ      'OP'
     C     #1DTPE        OREQ      'OT'
     C     #1DTPE        OREQ      'SW'
     C                   UPDATE    UPDIDX
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,FD0650MC32
     C     *IN91         IFEQ      '1'
      * Change error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
     C/COPY WNCPYSRC,FDH00029
      * DBF Change successful.
      * Update saved record image.
     C                   MOVEL     @1DBRC        #1DBRC
      *                                                                                       CGP001
      ** Save the Global Product and Instrument Codes to the Cross-                           CGP001
      ** Reference Files if CGP001 is enabled.                                                CGP001
      *                                                                                       CGP001
     C/COPY WNCPYSRC,FDH00030
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPXU
     C                   ENDIF
     C/COPY WNCPYSRC,FD0650MC17
      *
     C                   END
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MADU                                           S01408
     C*                                                                   S01408
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRVGPC - Validates the Global Product Code.                  *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRVGPC        BEGSR
      *                                                                                       CGP001
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSGF
      *                                                                                       CGP001
      ** Product Code must be entered.                                                        CGP001
      *                                                                                       CGP001
     C********** #1PRDC    IFEQ *BLANKS                                               CGP001 BUG6307
     C**********           MOVE 'GPM0004' ZAMSID                                      CGP001 BUG6307
     C**********           ELSE                                                       CGP001 BUG6307
      *                                                                                      BUG6307
     C     #1PRDC        IFNE      *BLANKS
      *                                                                                       CGP001
     C                   CALL      'AOGPRDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1PRDC        PGPRD            10
     C     GPPROD        PARM      GPPROD        DSFDY
      *                                                                                       CGP001
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      PGPRD         #1PRDC
     C                   ELSE
      *                                                                                       CGP001
     C                   SELECT
     C     PRTCD         WHENEQ    '*NOSEL '
     C                   MOVE      'GPM0004'     ZAMSID
      *                                                                                       CGP001
      ** Invalid Product Code.                                                                CGP001
      *                                                                                       CGP001
     C     PRTCD         WHENEQ    '*NRF   '
     C                   MOVE      'GPM0005'     ZAMSID
     C                   OTHER
     C                   MOVEL     'GPPRODPD'    DBFILE
     C                   MOVEL     PGPRD         DBKEY
     C                   MOVEL     '08'          DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDSL
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C     ZAMSID        IFNE      *BLANKS
     C                   MOVE      *ON           *IN41
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRVGIC - Validates the Global Instrument Code.               *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRVGIC        BEGSR
      *                                                                                       CGP001
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSGF
      *                                                                                       CGP001
      ** Instrument Code must be entered.                                                     CGP001
      *                                                                                       CGP001
     C     #1INSC        IFEQ      *BLANKS
     C     CGP003        IFEQ      'Y'
     C                   MOVE      'GPM0006'     ZAMSID
     C                   ENDIF
     C                   ELSE
      *                                                                                       CGP001
     C                   CALL      'AOGINSR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1INSC        PGINS            10
     C     GPINST        PARM      GPINST        DSFDY
      *                                                                                       CGP001
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      PGINS         #1INSC
     C                   ELSE
      *                                                                                       CGP001
     C                   SELECT
     C     PRTCD         WHENEQ    '*NOSEL '
     C                   MOVE      'GPM0006'     ZAMSID
      *                                                                                       CGP001
      ** Invalid Instrument Code.                                                             CGP001
      *                                                                                       CGP001
     C     PRTCD         WHENEQ    '*NRF   '
     C                   MOVE      'GPM0007'     ZAMSID
     C                   OTHER
     C                   MOVEL     'GPPRODPD'    DBFILE
     C                   MOVEL     PGPRD         DBKEY
     C                   MOVEL     '09'          DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDSL
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C     ZAMSID        IFNE      *BLANKS
     C                   MOVE      *ON           *IN42
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPPI - Gets the Global Product and Instrument Codes.       *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPPI        BEGSR
      *                                                                                       CGP001
     C                   MOVE      *BLANKS       #1PRDC
     C                   MOVE      *BLANKS       #1INSC
      *                                                                                       CGP001
     C                   MOVE      WZONE         KZONE
     C                   MOVE      'DL'          KMOD
     C                   MOVEL     DTPE11        KTRTP
     C                   MOVEL     DLST11        KTRST
      *                                                                                       CGP001
     C     KGPXR         CHAIN(N)  GPPRDXL0                           43
      *                                                                                       CGP001
     C     *IN43         IFEQ      *OFF
     C                   MOVE      PDGPRD        #1PRDC
     C                   ENDIF
      *                                                                                       CGP001
     C     KGPXR         CHAIN(N)  GPINSXL0                           43
      *                                                                                       CGP001
     C     *IN43         IFEQ      *OFF
     C                   MOVE      INGINS        #1INSC
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPOF - Opens the Global Processing Cross-Reference Files.  *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPOF        BEGSR
      *                                                                                       CGP001
     C                   Z-ADD     80            PLEN             15 5
      *                                                                                       CGP001
     C                   DO        2             WIDX              1 0
      *                                                                                       CGP001
     C                   MOVE      OVRC(WIDX)    PCMD             80
      *                                                                                       CGP001
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD
     C                   PARM                    PLEN
      *                                                                                       CGP001
     C                   ENDDO
      *                                                                                       CGP001
     C                   OPEN      GPPRDXL0
     C                   OPEN      GPINSXL0
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPGZ - Gets the Zone via GOGETZONE.                        *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPGZ        BEGSR
      *                                                                                       CGP001
     C                   CALL      GOPGM
     C                   PARM      *BLANKS       PZRTCD            7
     C                   PARM      *BLANKS       PZERMS           50
     C                   PARM      'N'           PZFCHK            1
     C                   PARM      *BLANKS       PZZONE           10
     C                   PARM      *BLANKS       PZSHTC            4
     C                   PARM      *ZERO         PZRDNB            5 0
     C                   PARM      *ZERO         PZDNWD            5 0
     C                   PARM      *BLANKS       PZBCCY            3
     C                   PARM      *ZERO         PZNJOB            1 0
      *                                                                                       CGP001
     C     PZRTCD        IFEQ      *BLANKS
     C                   MOVE      PZZONE        WZONE            10
     C                   ELSE
      *                                                                                       CGP001
     C     PZRTCD        IFEQ      '*ERROR'
     C                   MOVEL     GOMSG         PZERMS
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPXU - Writes and updates records on the Global            *                       CGP001
      *           Processing Cross-Reference Files.                   *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPXU        BEGSR
      *                                                                                       CGP001
     C                   MOVE      WZONE         KZONE
     C                   MOVE      'DL'          KMOD
     C                   MOVEL     DTPE11        KTRTP
     C                   MOVEL     DLST11        KTRST
      *                                                                                       CGP001
     C     KGPXR         CHAIN     GPPRDXL0                           43
      *                                                                                       CGP001
     C     *IN43         IFEQ      *ON
     C                   MOVE      KZONE         PDZONE
     C                   MOVE      KMOD          PDMOD
     C                   MOVE      KTRTP         PDTRTP
     C                   MOVE      KTRST         PDTRST
     C                   MOVE      #1PRDC        PDGPRD
     C                   WRITE     GPPRDXD0
     C                   ELSE
     C                   MOVE      #1PRDC        PDGPRD
     C                   UPDATE    GPPRDXD0
     C                   ENDIF
      *                                                                                       CGP001
     C     KGPXR         CHAIN     GPINSXL0                           43
      *                                                                                       CGP001
     C     *IN43         IFEQ      *ON
     C                   MOVE      KZONE         INZONE
     C                   MOVE      KMOD          INMOD
     C                   MOVE      KTRTP         INTRTP
     C                   MOVE      KTRST         INTRST
     C                   MOVE      #1INSC        INGINS
     C                   WRITE     GPINSXD0
     C                   ELSE
     C                   MOVE      #1INSC        INGINS
     C                   UPDATE    GPINSXD0
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPXD - Deletes records on the Global Processing Cross-     *                       CGP001
      *           Reference Files.                                    *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPXD        BEGSR
      *                                                                                       CGP001
     C                   MOVE      WZONE         KZONE
     C                   MOVE      'DL'          KMOD
     C                   MOVEL     DTPE11        KTRTP
     C                   MOVEL     DLST11        KTRST
      *                                                                                       CGP001
     C     KGPXR         CHAIN     GPPRDXL0                           43
      *                                                                                       CGP001
     C     *IN43         IFEQ      *OFF
     C                   DELETE    GPPRDXD0
     C                   ENDIF
      *                                                                                       CGP001
     C     KGPXR         CHAIN     GPINSXL0                           43
      *                                                                                       CGP001
     C     *IN43         IFEQ      *OFF
     C                   DELETE    GPINSXD0
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue.
      *================================================================
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGM
     C                   END
      * If no message file specified use default.
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      * Clear all fields for default mechanism next time.
     C                   MOVEL     *BLANK        ZAPGM                          Program queue
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSID                         Message Id.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file.
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text.
      *================================================================
     C                   MOVEL     'Y'           W0HLP             1            Signal help req
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Member name.
     C                   PARM      *BLANK        YYHPFL           10            *DFT text file.
     C                   PARM      *BLANK        YYHPLB           10            Help text lib.
     C                   PARM                    W0RTN             7            Return Code.
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program: Normal.
      *================================================================
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct.
      *================================================================
      * ROLLBACK any uncommitted DBF changes.
     C                   ROLBK                                          90
      *                                                                                       207288
      ** Close extension file.                                                                207288
      *                                                                                       207288
     C     BGN4ST        IFEQ      'Y'
     C                   CLOSE     FDDTSTXT                             99
     C                   ENDIF
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   CLOSE     GPPRDXL0
     C                   CLOSE     GPINSXL0
     C                   ENDIF
      *
      * Terminate program.
     C                   SETON                                        LR
      *
      * Exit program.
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation.
      *================================================================
      *                                                                                       CGP001
      ** Global Processing X-Reference Key List                                               CGP001
      *                                                                                       CGP001
     C     KGPXR         KLIST
     C                   KFLD                    KZONE            10
     C                   KFLD                    KMOD              2
     C                   KFLD                    KTRTP             5
     C                   KFLD                    KTRST             5
      *                                                                                       CGP001
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
      * Setup job date/time.
     C                   Z-ADD     UDATE         ##JDT                          Job date.
     C                   TIME                    ##JTM                          Job time.
     C                   TIME                    ##TME             6 0          Screen time.
      * Define work field Deletion Allowed
     C                   MOVEL     *BLANK        WUDELA            1
      * Define work field Amend allowed
     C                   MOVEL     *BLANK        WUAMAL            1
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define LDA                                                                            CAS005
     C     *DTAARA       DEFINE                  LDA
      * Obtain default message file.
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Type of Last Change
     C                   MOVEL     *BLANK        WUTYLC            1
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Open files.
      * Begin commit control.
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
     C                   OPEN      FDDTSTL0
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MCP8                                           S01408
     C*                                                                   S01408
      *
     C**********           Z-ADD13        ##SFPG  30       SFLPAG                             CAS001
     C**********           Z-ADD6         ##SFPG  30                                   CAS001 CAS005
     C**********           Z-ADD5         ##SFPG  30                                   CAS005 CAS008
     C                   Z-ADD     4             ##SFPG            3 0
     C/COPY WNCPYSRC,FDH00033
     C                   Z-ADD     1             ##SFRC
     C                   Z-ADD     *ZERO         ##RRMX                         MAX RECNO
      *................................................................
      * If member empty, set to *ADD mode, else to *CHANGE mode.
     C     @1NROP        IFEQ      *ZERO
     C                   MOVEL     'ADD'         W0PMD             3            Add mode
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD                          Change mode
     C                   END
      * USER: Initialise program
      * Standard RPG Creation PAR - Standard Functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT                         RUN DATE       S0122
     C                   MOVE      MRDT          WUMRDT                                        S0122
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.     S0122
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT  S0122
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG   S0122
     C/COPY WNCPYSRC,FD0650MC51
      *                                                                                       CGP001
      ** Check if CGP001 is enabled.                                                          CGP001
      *                                                                                       CGP001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGP001'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CGP001
     C                   MOVE      'N'           CGP001            1
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGP001
     C                   MOVE      *ON           *IN40
      *                                                                                       CGP001
      ** Open the Global Processing Files.                                                    CGP001
      *                                                                                       CGP001
     C                   EXSR      SRGPOF
      *                                                                                       CGP001
      ** Get the Zone.                                                                        CGP001
      *                                                                                       CGP001
     C                   EXSR      SRGPGZ
     C                   ELSE
      *                                                                                       CGP001
     C     PRTCD         IFNE      '*NRF'
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CGP001'      DBKEY
     C                   MOVEL     '07'          DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CAS001
      ** Determine if CAS001 is installed                                                     CAS001
      *                                                                                       CAS001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CAS001'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CAS001
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '06'          DBASE
     C                   MOVEL     'CAS001'      DBKEY            29
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CAS001
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS001            1
     C                   MOVE      *ON           *IN55
     C                   ELSE
     C                   MOVE      'N'           CAS001
     C                   MOVE      *OFF          *IN55
     C                   ENDIF
     C/COPY WNCPYSRC,FDH00050
      *                                                                                       CAS001
      ** Determine if CAS005 is installed                                                     CAS005
      *                                                                                       CAS005
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CAS005'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CAS005
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '07'          DBASE
     C                   MOVEL     'CAS005'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CAS005
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS005            1
     C                   MOVE      *ON           *IN56
     C                   ELSE
     C                   MOVE      'N'           CAS005
     C                   MOVE      *OFF          *IN56
     C                   ENDIF
      *                                                                                      BUG5677
      ** Determine if Management Limit (CGP003) enhancement is on.                           BUG5677
      *                                                                                      BUG5677
     C                   MOVE      'N'           CGP003            1
      *                                                                                      BUG5677
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGP003'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                      BUG5677
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CGP003'      DBKEY
     C                   MOVEL     '12'          DBASE
     C                   OUT       LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                      BUG5677
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGP003
     C                   ENDIF
      *                                                                                       CDL019
      ** Determine if CDL019 is installed                                                     CDL019
      *                                                                                       CDL019
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CDL019'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CDL019
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL019            1
     C                   MOVE      *ON           *IN57
     C                   ELSE
     C                   MOVE      'N'           CDL019
     C                   MOVE      *OFF          *IN57
     C                   ENDIF
      *                                                                                       CAS005
      ** Determine if CAS008 is installed                                                     CAS008
      *                                                                                       CAS008
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CAS008'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CAS008
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '08'          DBASE
     C                   MOVEL     'CAS008'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CAS008
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS008            1
     C                   ELSE
     C                   MOVE      'N'           CAS008
     C                   ENDIF
      *                                                                                       CAS008
      ** Determine if CIR003 is installed                                                     CAS008
      *                                                                                       CAS008
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CIR003'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CAS008
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '09'          DBASE
     C                   MOVEL     'CIR003'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CAS008
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CIR003            1
     C                   ELSE
     C                   MOVE      'N'           CIR003
     C                   ENDIF
      *                                                                                       CAS008
     C     CAS008        IFEQ      'Y'
     C     CIR003        ANDEQ     'Y'
     C                   MOVE      *ON           *IN64
     C                   ELSE
     C                   MOVE      *OFF          *IN64
     C                   ENDIF
      *                                                                                       CAS008
      * Copyright Statement - Standard Functions  * copyright
      * Initialise subfile control.
     C                   EXSR      MEIZ#2
      *                                                                   S01486
      **  Access module file                                              S01486
      *                                                                   S01486
     C                   CALL      'AOMMODR0'                                                  S0148
     C                   PARM      '*MSG   '     @RTCD                                         S0148
     C                   PARM      '*FIRST '     @OPTN                                         S0148
     C     SDMMOD        PARM      SDMMOD        DSFDY                                         S0148
      *                                                                   S01486
     C     @RTCD         IFNE      *BLANK                                                      S0148
     C                   MOVEL     'SDMMODPD'    DBFILE           10             ************* S0148
     C                   MOVEL     '01'          DBASE             3             *DBERROR 001* S0148
     C                   MOVEL     @OPTN         DBOPTN            7             ************* S0148
     C                   SETON                                        U7U8LR                   S0148
     C                   EXSR      *PSSR                                                       S0148
     C                   END                                                                   S0148
      *                                                                   CPB001
      **  Instrument type is maintained if Private Banking is ON          CPB001
      *                                                                   CPB001
     C     BGN4ST        IFEQ      'Y'                                                         CPB00
     C                   MOVE      *ON           *IN39                                         CPB00
     C                   OPEN      FDDTSTXT
     C                   ENDIF                                                                 CPB00
      *                                                                   S01486
      **  Access SDPORTPD for default Instrument Type                     S01486
      *                                                                   S01486
     C     BGPFMG        IFEQ      'Y'                                                         S0148
     C/COPY WNCPYSRC,FD0650MC12
     C                   MOVE      *ON           *IN39                                         S0148
     C/COPY WNCPYSRC,FD0650MC13
     C                   CALL      'AOPORTR0'                                                  S0148
     C                   PARM      '*MSG   '     @RTCD                                         S0148
     C                   PARM      '*FIRST '     @OPTN                                         S0148
     C     SDPORT        PARM      SDPORT        DSFDY                                         S0148
      *                                                                   S01486
     C     @RTCD         IFNE      *BLANK                                                      S0148
     C                   MOVEL     'SDPORTPD'    DBFILE           10             ************* S0148
     C                   MOVEL     '02'          DBASE             3             *DBERROR 002* S0148
     C                   MOVEL     @OPTN         DBOPTN            7             ************* S0148
     C                   SETON                                        U7U8LR                   S0148
     C                   EXSR      *PSSR                                                       S0148
     C                   END                                                                   S0148
     C                   END                                                                   S0148
      *                                                                   CDL006
      **  Access Switchable Feature Details, Check if CDL006 is ON.       CDL006
      *                                                                   CDL006
     C                   MOVE      'N'           CDL006            1                           CDL00
     C                   CALL      'AOSARDR0'                                                  CDL00
     C                   PARM      *BLANKS       PRTCD             7                           CDL00
     C                   PARM      '*VERIFY'     POPTN             7                           CDL00
     C                   PARM      'CDL006'      PSARD             6                           CDL00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CDL00
      *                                                                   CDL006
     C     PRTCD         IFEQ      *BLANKS                                                     CDL00
     C                   MOVE      'Y'           CDL006                                        CDL00
     C                   ELSE                                                                  CDL00
      *                                                                   CDL006
     C     PRTCD         IFNE      '*NRF   '                                                   CDL00
     C                   MOVEL     'SDSARDPD'    DBFILE           10            ************   CDL00
     C                   MOVEL     '03'          DBASE             3            * DBERR 03 *   CDL00
     C                   MOVEL     POPTN         DBOPTN            7            ************   CDL00
     C                   MOVE      *ON           *INU7                                         CDL00
     C                   MOVE      *ON           *INU8                                         CDL00
     C                   MOVE      *ON           *INLR                                         CDL00
     C                   EXSR      *PSSR                                                       CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL006
     C                   END                                                                   CDL00
      *                                                                   CFT006
      **  Access Switchable Feature Details, Check if CFT006 is ON.       CFT006
      *                                                                   CFT006
     C                   MOVE      'N'           CFT006            1                           CFT00
     C                   CALL      'AOSARDR0'                                                  CFT00
     C                   PARM      *BLANKS       PRTCD             7                           CFT00
     C                   PARM      '*VERIFY'     POPTN             7                           CFT00
     C                   PARM      'CFT006'      PSARD             6                           CFT00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CFT00
      *                                                                   CFT006
     C     PRTCD         IFEQ      *BLANKS                                                     CFT00
     C                   MOVE      'Y'           CFT006                                        CFT00
     C                   ELSE                                                                  CFT00
      *                                                                   CFT006
     C     PRTCD         IFNE      '*NRF   '                                                   CFT00
     C                   MOVEL     'SDSARDPD'    DBFILE           10            ************   CFT00
     C                   MOVEL     '04'          DBASE             3            * DBERR 04 *   CFT00
     C                   MOVEL     POPTN         DBOPTN            7            ************   CFT00
     C                   MOVE      *ON           *INU7                                         CFT00
     C                   MOVE      *ON           *INU8                                         CFT00
     C                   MOVE      *ON           *INLR                                         CFT00
     C                   EXSR      *PSSR                                                       CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   END                                                                   CFT00
      *                                                                   CFT008
      **  Access Switchable Feature Details, Check if CFT008 is ON.       CFT008
      *                                                                   CFT008
     C                   MOVE      'N'           CFT008            1                           CFT00
     C                   CALL      'AOSARDR0'                                                  CFT00
     C                   PARM      *BLANKS       PRTCD             7                           CFT00
     C                   PARM      '*VERIFY'     POPTN             7                           CFT00
     C                   PARM      'CFT008'      PSARD             6                           CFT00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CFT00
      *                                                                   CFT008
     C     PRTCD         IFEQ      *BLANKS                                                     CFT00
     C                   MOVE      'Y'           CFT008                                        CFT00
     C                   ELSE                                                                  CFT00
      *                                                                   CFT008
     C     PRTCD         IFNE      '*NRF   '                                                   CFT00
     C                   MOVEL     'SDSARDPD'    DBFILE           10            ************   CFT00
     C                   MOVEL     '05'          DBASE             3            * DBERR 05 *   CFT00
     C                   MOVEL     POPTN         DBOPTN            7            ************   CFT00
     C                   MOVE      *ON           *INU7                                         CFT00
     C                   MOVE      *ON           *INU8                                         CFT00
     C                   MOVE      *ON           *INLR                                         CFT00
     C                   EXSR      *PSSR                                                       CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT008
     C                   ENDIF                                                                 CFT00
      *                                                                   CRE008
      **  Access Switchable Feature Details, Check if CRE008 is ON.       CRE008
      *                                                                   CRE008
     C                   MOVE      'N'           CRE008            1                           CRE00
     C                   CALL      'AOSARDR0'                                                  CRE00
     C                   PARM      *BLANKS       PRTCD             7                           CRE00
     C                   PARM      '*VERIFY'     POPTN             7                           CRE00
     C                   PARM      'CRE008'      PSARD             6                           CRE00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CRE00
      *                                                                   CRE008
     C     PRTCD         IFEQ      *BLANKS                                                     CRE00
     C                   MOVE      'Y'           CRE008                                        CRE00
     C                   ELSE                                                                  CRE00
      *                                                                   CRE008
     C     PRTCD         IFNE      '*NRF   '                                                   CRE00
     C                   MOVEL     'SCSARDPD'    DBFILE           10            ************   CRE00
     C                   MOVEL     '06'          DBASE             3            * DBERR 06 *   CRE00
     C                   MOVEL     POPTN         DBOPTN            7            ************   CRE00
     C                   MOVE      *ON           *INU7                                         CRE00
     C                   MOVE      *ON           *INU8                                         CRE00
     C                   MOVE      *ON           *INLR                                         CRE00
     C                   EXSR      *PSSR                                                       CRE00
     C                   ENDIF                                                                 CRE00
      *                                                                   CRE008
     C                   END                                                                   CRE00
     C/COPY WNCPYSRC,FD0650MC52
      *                                                                   CFT006
      ** Determine if CGL014 is installed                                                     CGL014
      *                                                                                       CGL014
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CGL014'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CGL014
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '10'          DBASE
     C                   MOVEL     'CGL014'      DBKEY
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CGL014
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL014            1
     C                   ELSE
     C                   MOVE      'N'           CGL014
     C                   ENDIF
     C/COPY WNCPYSRC,FDH00031
      *                                                                                       CLE025
      ** Determine if CLE025 is installed                                                     CLE025
      *                                                                                       CLE025
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CLE025'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE025
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '11'          DBASE
     C                   MOVEL     'CLE025'      DBKEY
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CLE025
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE025            1
     C                   ELSE
     C                   MOVE      'N'           CLE025
     C                   ENDIF
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
     C                   MOVE      *ON           *IN39
     C                   ENDIF
      *                                                                                       CAS009
      ** Determine if CAS009 is installed                                                     CAS009
      *                                                                                       CAS009
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CAS009'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CAS009
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '19'          DBASE
     C                   MOVEL     'CAS009'      DBKEY            29
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CAS009
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS009            1
     C                   MOVE      *ON           *IN60
      *                                                                                       231563
     C                   MOVE      '      '      KSARN             6
     C     '   '         CAT       '      '      KPNAM            10
      *                                                                                       231563
     C     KSARP         KLIST
     C                   KFLD                    KSARN
     C                   KFLD                    KPNAM
      *                                                                                       231563
     C                   MOVEL     'CAS009'      KSARN
     C     'DLC'         CAT       '000020'      KPNAM
      *                                                                                       231563
     C*****KSARP         CHAIN     @SARPL1                            70                    MD056555
     C/EXEC SQL                                                                             MD056555
     C+ SELECT *                                                                            MD056555
     C+ into :SCSARP                                                                        MD056555
     C+ from SCSRPJW0                                                                       MD056555
     C+ where AKSARN = :KSARN and AKPNAM = :KPNAM                                           MD056555
     C/END-EXEC                                                                             MD056555
      *                                                                                       231563
     C******IN70         IFEQ      *ON                                                      MD056555
     C                   IF        SQLCODE = 100                                            MD056555
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARPPD'    DBFILE
     C                   MOVEL     '20'          DBASE
     C                   MOVEL     'CAS009'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       231563
      ** Check if Initialisation Program for CAS009 Fee Codes has run                         231563
      *                                                                                       231563
     C     AKPRVC        IFEQ      'Y'
      *                                                                                       231563
      ** Set CAS009 Initialised Flag to Yes                                                   231563
      *                                                                                       231563
     C                   MOVE      'Y'           WCAS9I            1
     C                   ENDIF
     C                   ENDIF
      *                                                                                       231563
     C                   ELSE
     C                   MOVE      'N'           CAS009
     C                   MOVE      *OFF          *IN60
     C                   ENDIF
      *                                                                                       CAS009
     C     KDTST#        KLIST
     C                   KFLD                    #1DTPE
     C                   KFLD                    #1DLST
      *                                                                                       CDL038
      ** Determine if CDL038 is installed                                                     CDL038
      *                                                                                       CDL038
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CDL038'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CDL038
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL038            1
     C                   MOVE      *ON           *IN65
     C                   ELSE
     C                   MOVE      'N'           CDL038
     C                   MOVE      *OFF          *IN65
     C                   ENDIF
      *                                                                   CPL002
      * If Midas-Plato Module is swtched on, set on indicator 50          CPL002
      *                                                                   CPL002
     C     BGN2ST        IFEQ      'Y'                                                         CPL00
     C                   MOVE      *ON           *IN50                                         CPL00
     C                   ELSE                                                                  CPL00
     C                   MOVE      *OFF          *IN50                                         CPL00
     C                   ENDIF                                                                 CPL00
      *                                                                                       CDL033
      ** Determine if CDL033 is installed                                                     CDL033
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CDL033'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CDL033
     C                   MOVE      'N'           CDL033            1
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL033
     C                   ELSE
     C     PRTCD         IFNE      '*NRF   '
     C                   MOVE      '12'          DBASE
     C                   MOVEL     'CDL033  '    DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER047
      ** Call AOSARDR0 to check for CER047                                                    CER047
      *                                                                                       CER047
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CER047'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CER047
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CER047
     C                   MOVE      'Y'           CER047            1
     C                   MOVE      *OFF          *IN44
     C                   ELSE
     C                   MOVE      'N'           CER047
     C                   MOVE      *ON           *IN44
      *                                                                                       CER047
     C                   ENDIF
      *                                                                                       CER047
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
      *                                                                                       CER047
     C     *LOCK         IN        LDA
     C                   MOVE      '010'         DBASE
     C                   MOVEL     'CER047  '    DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *                                                                                       CER047
     C                   ENDIF
      *================================================================
     CSR   ZZEXIT        ENDSR
     C*                                                                   S01408
     C/COPY WNCPYSRC,FD0650MCP9                                           S01408
     C*                                                                   S01408
      *================================================================   S01486
     C*                                                                   S01486
     C     *PSSR         BEGSR                                                                 S0148
      *                                                                   S01486
     C                   DUMP                                                                  S0148
     C/COPY WNCPYSRC,FD0650MC26
     C                   RETURN                                                                S0148
      *                                                                   S01486
     C                   ENDSR                                                                 S0148
      *================================================================   S01486
      /EJECT                                                                                  207288
      *****************************************************************                       207288
      *                                                               *                       207288
      * VALSPT - Validate spot indicator                              *                       207288
      *                                                               *                       207288
      * Called by: DFV2RC                                             *                       207288
      *                                                               *                       207288
      * Calls: None                                                   *                       207288
      *                                                               *                       207288
      *****************************************************************                       207288
     C     VALSPT        BEGSR
      *                                                                                       207288
     C     #1DTPE        IFNE      'FP'
     C     #1DTPE        ANDNE     'FS'
     C     #1DTPE        ANDNE     'CX'
     C     #1DTPE        ANDNE     'PI'
     C     #1DTPE        ANDNE     'SI'
     C     #1DTPE        ANDNE     'OP'
     C     #1DTPE        ANDNE     'OT'
     C     #1DTPE        ANDNE     'SW'
     C     #1SFLG        ANDNE     ' '
     C                   MOVEL     'USR1780'     ZAMSID
     C                   MOVEL     'GBMIDAS'     ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN38
     C                   MOVE      '1'           *IN98
     C                   ENDIF
      *                                                                                       207288
     C     #1DTPE        IFEQ      'FP'
     C     #1DTPE        OREQ      'FS'
     C     #1DTPE        OREQ      'CX'
     C     #1DTPE        OREQ      'PI'
     C     #1DTPE        OREQ      'SI'
     C     #1DTPE        OREQ      'OP'
     C     #1DTPE        OREQ      'OT'
     C     #1DTPE        OREQ      'SW'
     C     #1SFLG        IFEQ      ' '
     C                   MOVE      'Y'           #1SFLG
     C                   ENDIF
     C                   ENDIF
      *                                                                                       207288
     C     #1SFLG        IFNE      'Y'
     C     #1SFLG        ANDNE     'N'
     C     #1SFLG        ANDNE     ' '
     C     *IN38         ANDEQ     '0'
     C                   MOVEL     'USR1781'     ZAMSID
     C                   MOVEL     'GBMIDAS'     ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN38
     C                   MOVE      '1'           *IN98
     C                   ENDIF
      *                                                                                       207288
     C                   ENDSR
      *                                                                                       207288
      *****************************************************************                       207288
**CTDATA TXT
D=Delete   F3=Exit   F5=Refresh   F9=Go to 'Add' Mode
F3=Exit   F5=Reset Screen   F9=Go to 'Change' Mode
F3=Exit   F5=Refresh   F9=Go to 'Add' Mode
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA @CN
Y
CHG
01
50
N
ADD
?
?INVAL
00
33
02
32
34
36
47
49
44
46
I
NARRAT
*ERROR*
D
A
**CTDATA OVRC
OVRDBF FILE(GPPRDXL0) TOFILE(GPPRODXL0)                                                       CGP001
OVRDBF FILE(GPINSXL0) TOFILE(GPINSTXL0)                                                       CGP001
**CTDATA @DL
IP                                                                                            CAS009
TI                                                                                            CAS009
CL                                                                                            CAS009
DL                                                                                            CAS009
IT                                                                                            CAS009
TD                                                                                            CAS009
CI                                                                                            CAS009
CD                                                                                            CAS009
C2                                                                                            CAS009
BP                                                                                            CAS009
BD                                                                                            CAS009
TB                                                                                            CAS009
DA                                                                                            CAS009
TA                                                                                            CAS009
