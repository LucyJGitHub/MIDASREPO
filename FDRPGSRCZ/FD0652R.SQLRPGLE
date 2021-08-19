     H DEBUG DATEDIT(*YMD)
     F*****************************************************************
/**** *  RPGBASE                                                      *                     MD056555
/*STD *  RPGSQLBND                                                    *                     MD056555
/*EXI *  TEXT('Midas FD Edit deal Types/Subtypes')                    *
/******  OVRDBF FILE(GPPRDXL0) TOFILE(GPPRODXL0)                      *            BUG10769 MD056555
/******  OVRDBF FILE(GPINSXL0) TOFILE(GPINSTXL0)                      *            BUG10769 MD056555
/*OVR *  OVRDBF FILE(GZSDBANK) TOFILE(GZSDBANKL2)                     *                       CSD031
/*OVRF*  OVRDBF FILE(GPPRDXL0) TOFILE(GPPRODXL0)                      *                     MD056555
/*OVRF*  OVRDBF FILE(GPINSXL0) TOFILE(GPINSTXL0)                      *                     MD056555
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  FD0652R - Edit Deal Type/Subtype details                     *
      *                                                               *
      *  Function:  This program maintains Deal Type/Subtype details  *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD056555           Date 31Aug20               *
      *  Prev Amend No. MD056747           Date 23Sep20               *
      *                 MD046248           Date 27Oct17               *
      *                 MD037467           Date 25May16               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 AR796904           Date 16Nov12               *
      *                 AR795970           Date 05Jul11               *
      *                 AR787620           Date 10Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24306           Date 11Jun09               *
      *                 BUG24223           Date 08Jun09               *
      *                 BUG24222           Date 05Jun09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 248297             Date 05JUN07               *
      *                 CPK027             Date 30Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241873             Date 29Aug06               *
      *                 BUG11785           Date 30Jul06               *
      *                 BUG11819           Date 30Jul06               *
      *                 BUG11797           Date 28Jul06               *
      *                 BUG11701           Date 17Jul06               *
      *                 BUG11448           Date 15Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG10769           Date 07Mar06               *
      *                 BUG10153           Date 01Feb06               *
      *                 CER001             Date 25Apr05               *
      *                 184471             Date 02Oct00               *
      *---------------------------------------------------------------
      *                                                               *
      *  MD056555 - Deliverable Data Split for SAR group              *
      *  MD056747 - Instrument Type is not being displayed on screen  *
      *  MD046248 - Finastra Rebranding                               *
      *  MD037467 - SG-DEAL TYPE/SUB TYPES ENQUIRY - Editable field   *
      *             in enquiry screen                                 *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR796904 - MXC0480 failed with decimal data error.  Applied  *
      *             AR314478 to initialise Effective Date field to    *
      *             zero if CSD039 is Off.  (Child: AR796905)         *
      *  AR795970 - Change §24c to plain 24c (Recompile)              *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,FDH00014                                 *
      *             WNCPYSRC,FDH00015                                 *
      *             WNCPYSRC,FDH00016                                 *
      *             WNCPYSRC,FDH00017                                 *
      *             WNCPYSRC,FDH00018                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24306 - Enquiry of New Field should show correct          *
      *             symbol "§". (Recompile)                           *
      *  BUG24223 - Enquiry Screen Not working                        *
      *  BUG24222 - Enquiry for New Field KWG not available on screen *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  248297 - DS DATA is part of FD0650GDTA and not in i-cards    *
      *           (Window Process)                                    *
      *  CPK027 - External field name entry is longer than six(6)     *
      *           characters                                          *
      *  241873 - Make the Fix Base Rate flag field appear at the     *
      *           first time the 1st details screen appears in ADD    *
      *           option.                                             *
      *  BUG11785 - DB error when deleting a record                   *
      *  BUG11819 - Deal type sub type details are not displayed when *
      *             enquiring in acceptance list                      *
      *  BUG11797 - Error msg appear after pressing F10               *
      *  BUG11701 - Description field should not be protected         *
      *  BUG11448 - Unexpected exit happened from the Central Deal    *
      *             Type/Subtype Input screen                         *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  BUG10769 - IAS and Global fields not available for input     *
      *  BUG10153 -Errors in validation of deal type/sub-type/class   *
      *  CER001 - LUX Upgrade to MidasPlus                            *
     F*  184471 - Add FRA/IRS Deal types to list.                     *
     F*           SAME FIX AS 107662 IN SD0650M                       *
      *+++REGIONAL+BEGIN+++++++++++++++++++++++++++++++++++++++++++++++++++++++*
      *                                                                        *
      * Midas DBA 3.01 ---------------- Regional ------------------------------*
      *  Last Amend No. ULX003             DATE 04SEP96                        *
      *                                                                        *
      *------------------------------------------------------------------------*
      *                                                                        *
      *  ULX003 - TOF/MIDAS INTERFACE                                          *
      *                                                                        *
      *+++REGIONAL+END+++++++++++++++++++++++++++++++++++++++++++++++++++++++++*
      *                                                                        *
     FFD0652R#  CF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Edit deal type/sub-type details
      *
     F***SDDLSTL1IF**E***********K********DISK                                              BUG10769
      **RTV:*Deal*subtypes*************Retrieval index                                      BUG10769
      *********************************                                                     BUG10769
      *                                                                                       CSD031
     FGPDLSTL1  IF   E           K DISK    USROPN
      *                                                                                       CSD031
      **RTV: Deal subtypes             Retrieval index                                        CSD031
      *                                                                                       CSD031
     FDEALSL10  IF   E           K DISK                                                           BU
      ** Midas DL DEALSDB/DEALSDC by Deal Type/Sub Type                                     BUG10769
      *                                                                                     BUG10769
     FGPPRDXL0  UF A E           K DISK    USROPN                                                 BU
     F                                     INFSR(*PSSR)                                           BU
     F                                     RENAME(GPPRODXD0:GPPRDXD0)                             BU
     F                                     COMMIT                                                 BU
      ** Midas GP Global Products X-Reference                                               BUG10769
      *                                                                                     BUG10769
     FGPINSXL0  UF A E           K DISK    USROPN                                                 BU
     F                                     INFSR(*PSSR)                                           BU
     F                                     RENAME(GPINSTXD0:GPINSXD0)                             BU
     F                                     COMMIT                                                 BU
      ** Midas GP Global Instruments X-Reference                                            BUG10769
      *                                                                                     BUG10769
     F*SCSARPL1* IF   E           K DISK                                                    MD056555
      ** Midas SC Switchable Feature Initialisation PGM index                               BUG10769
      *                                                                                     BUG10769
     F**********FDDTSTL1IF  E           K        DISK                           UC            CSD031
     FFDDTSTL1  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV : Deal Sub-types            Retrieval index
      *
     FSDMMODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Midas modules retrieval file
      *
     FFDDTSTL0  UF A E           K DISK    USROPN
     F                                     RENAME(FDDTSTPD:UPDFDT)
     F                                     COMMIT
     F                                     INFDS(ID0002)
     F                                     INFSR(*PSSR)
      * UPD : Deal Types/Sub-types            Update index
      *
     FSDADTSL0  IF   E           K DISK
     F                                     RENAME(FDDTSTPD:SDADTSLR)
      *                                                                                       CSD031
      ** RTV: Deal Type/Subtype Acceptance File                                               CSD031
      *                                                                                       CSD031
     FGPZONEL0  IF   E           K DISK
      *                                                                                       CSD031
      ** RTV: GP Zone                                                                         CSD031
      *                                                                                       CSD031
     FGZSDBANK  IF   E           K DISK    USROPN
      *                                                                                       CSD031
      ** UPD: GZ Bank Details ICD Keyed on DNWD                                               CSD031
     F/COPY WNCPYSRC,FDH00014
      *                                                                                       CSD031
     D********************************************************************
     D**********          AENA    1   3 78                                                    CSD031
     D AENA            S             78    DIM(4) CTDATA PERRCD(1)
     D*
     D*  DETAIL LINE COMMAND KEY TEXT
     D*
     D*
     D* KEY LINE COMMAND KEY TEXT
     D*
     D ARGV            S             78    DIM(1) CTDATA PERRCD(1)
      *                                                                                     BUG10769
      ** Override Command Array                                                             BUG10769
     D OVRC            S             80    DIM(2) CTDATA PERRCD(1)
      *                                                                                     BUG10769
      ** Deal Types valid to maintain Amortised Cost Accounting Indicator                   BUG10769
     D @DL             S              2    DIM(14) CTDATA PERRCD(1)             Deal types
      *
     D* Description     : Copyright notice for inclusion in all MKI programs
     D*
     D********************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all MKI programs
     D*
     D/COPY QWINDSRC,FD0650GDTA
     D*
      /EJECT
      * Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
      *                                                                                       CSD031
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank details file                                                                    CSD031
      *                                                                                       CSD031
     D WDTQ            DS
     D  WPFNAM                 1     10
     D  WKEYS                 11     40
     D  WDATA                 41    296
     D PDQMSG          DS          4040
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D*
     D SDPLIN        E DS                  EXTNAME(SDPLINPD)
     D** Dummy record format for access to Instrument Types
     D*
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
     D** Dummy record format for Portfolio Management ICD Details.
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D** First DS for access programs, short data structure               S01486
     D*                                                                   S01486
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01486
      **  Long data structure for access programs                         S01486
      *                                                                   S01486
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D @1DBRC        E DS                  EXTNAME(FDDTSTL0)
      * UPD : Deal Type/Sub-type            Update index
      * Current/previous master file format fields for change control
      *
     D**********#1DBRC      DS                             48                                 CER001
     D**********#1DBRC      DS                            114                          CER001 CSD031
     D***#1DBRC*     DS                            144                               CSD031 BUG11797
     D/COPY WNCPYSRC,FDH00073
     D #1DBRC          DS           149                                                           BU
     D/COPY WNCPYSRC,FDH00074
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D A@CPY           DS
     D* MKI Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              MKI Copyright array
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D ID0001          DS           528
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
      *
     D ID0003          DS           528
      * File information data structure
     D****DATA        DS                           1024                                       248297
     D DTSTDS          DS
      *                                                                                       CER001
     D  #1DTPE                 1      2
     D  #1DSTC                 3      4
     D  #1DCLA                 5      8
     D/COPY WNCPYSRC,FDH00075
      *
      /EJECT
      * Parameter declarations
     D**********P1PARM      DS                              4                                 CER001
     D**********P1PARM      DS                              8                          CER001 CSD031
     D P1PARM          DS             9
      * KEY: Deal Types/Sub-types            Retrieval index
      * I : MAP Deal Types/Sub-types Code
     D  P1DTPE                 1      2
     D  P1DSTC                 3      4
     D  P1DCLA                 5      8
     D  P1ACCP                 9      9
     D P2PARM          DS
      * I :  Action Code
     D  P2ANCD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Question Mark Invalid'
      * Key Field
     D  ZA0001                 1     10
      * Message data for 'Key Field Invalid Value'
      * If value in key field
     D  ZA0002                 1      1
      * Key Field
     D  ZA0003                 2     11
      * Message data for 'Deal Sub-type Name is req'
      * Deal Sub-type name
     D  ZA0004                 1     30
      * Message data for 'Instrument'
     D  ZA0005                 1      1
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0007                 1     10
     D GOPGM           C                   CONST('GOGETZONE')                                     BU
     D GOMSG           C                   CONST('ERROR IN GOGETZONE')                            BU
     D GPPROD        E DS                  EXTNAME(GPPRODPD)                                      BU
     D  PDGLCD       E                     EXTFLD(PDLCD)                                          BU
     D  PDGCHT       E                     EXTFLD(PDCHTP)                                         BU
      ** Global Product Code Details Data Structure                                         BUG10769
      *                                                                                     BUG10769
     D GPINST        E DS                  EXTNAME(GPINSTPD)                                      BU
      ** Global Instrument Code Details Data Structure                                      BUG10769
      *                                                                                     BUG10769
     D LDA             DS           256                                                           BU
      ** Local data area for database error details                                         BUG10769
      *                                                                                     BUG10769
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *                                                                                       CER001
      ** External DS for SAR Details                                                          CER001
      *                                                                                       CER001
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)                                      BU
     D  FYSLCA       E                     EXTFLD(FSYLDCA)
      *                                                                                     BUG10769
      ** External DS for Yield Curve Details                                                BUG10769
      *                                                                                     BUG10769
     D SDTCLS        E DS                  EXTNAME(SDTCLSPD)
      *                                                                                       CER001
      ** Dummy record for access to Transaction classes                                       CER001
      *                                                                                       CER001
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)                                      BU
      ** Dummy record format for access to Deal Sub-Types                                   BUG10769
      *                                                                                     BUG10769
     D PGMB            C                   CONST('XLIB/SDCSNDDTQ')
     D SCSARP        E DS                  EXTNAME(SCSRPJW0)                                MD056555
      *                                                                                       CSD031
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM                         KEY: Deal Type/sub.
     C     P2ANCD        PARM                    WP0001            1            Action Code
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
      * Check passed parameters
     C                   EXSR      FACKPM
      * Perform once if all passed, else repeat
     C     W0RPT         DOUEQ     'N'
      * Display and process key screen
     C                   EXSR      BADSKY
     C                   END
      * Terminate program
     C                   EXSR      ZXEXPG
      *****************************************************************
      /EJECT
     CSR   BADSKY        BEGSR
      *================================================================
      * Display and process key screen
      *================================================================
      * Initialize key screen
     C                   EXSR      MDIZ#K
      * Bypass first display of key screen is possible
     C                   MOVEL     'Y'           W0BYP             1
      * Signal start of transaction
     C                   MOVEL     'Y'           W0TRN             1
     C     W0TRN         DOWEQ     'Y'
     C     W0TRN         OREQ      'K'
      * Ensure transaction continues (if reset)
     C                   MOVEL     'Y'           W0TRN             1
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1DTPE        IFEQ      *BLANK                                       Deal type
     C     #1DSTC        OREQ      *BLANK                                       Deal Sub-type
     C********** #1DCLA    OREQ *BLANK                     Deal Class              BUG10769 BUG11819
     C     CDL038        ANDEQ     'Y'
     C     WCLRQD        ANDEQ     'Y'
      * One or more key fields is blank
     C                   MOVEL     'N'           W0BYP
     C                   END
     C                   END
      * Bypass key screen
     C     W0BYP         IFNE      'Y'
      * Display key screen
     C                   EXSR      BBEXFM
     C                   END
      * Cancel key screen bypass
     C                   MOVEL     'N'           W0BYP
      * Process response to key screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Switch between *ADD/*CHANGE modes
     C   09              CAS                     BCCHMD
      * HOME: Reset screen fields
     C   05              CAS                     BDHMKY
      * Process key screen input
     C                   CAS                     BEPRKY
     C                   END
     C     W0TRN         DOWEQ     'R'
     C                   MOVEL     'Y'           W0TRN
     C                   EXSR      BEPRKY
     C                   END
      *
     C                   END
     C                   END
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBEXFM        BEGSR
      *================================================================
      * Display key screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GADSAK
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            29
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      BBIN89
     C     CSD039        OREQ      'Y'
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         BBIN89            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
      *                                                                                       CSD031
      ** CSD039 switchable feature is on                                                      CSD031
      *                                                                                       CSC031
     C     CSD039        IFEQ      'Y'
      *                                                                                       CSC031
      ** If called from Central Layer                                                         CSD031
      *                                                                                       CSC031
     C     *INU1         IFEQ      *ON
     C                   MOVE      *OFF          *IN56
     C                   ELSE
      *                                                                                       CSC031
      ** If called from Zone Layer                                                            CSD031
      *                                                                                       CSC031
     C                   MOVE      *ON           *IN56
     C                   ENDIF
      *                                                                                       CSC031
     C                   ENDIF
      *                                                                                       CSC031
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   BCCHMD        BEGSR
      *================================================================
      * Switch between *ADD/*CHANGE modes
      *================================================================
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'CHG'         W0PMD             3
     C                   ELSE
     C                   MOVEL     'ADD'         W0PMD
     C                   END
      *================================================================
     CSR   BCEXIT        ENDSR
      /EJECT
     CSR   BDHMKY        BEGSR
      *================================================================
      * Process HOME key
      *================================================================
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   BDEXIT        ENDSR
      /EJECT
     CSR   BEPRKY        BEGSR
      *================================================================
      * Process key screen input
      *================================================================
      * Initialise detail screen
     C                   EXSR      MAIZ#1
      * Validate key fields
     C                   EXSR      BFVLKY
     C     *IN99         CABEQ     '1'           BEEXIT
      * Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    DTPE11                         Deal type
     C                   KFLD                    DLST11                         Deal Sub-type
     C                   KFLD                    CLAS11
      * Setup key
     C                   MOVEL     #1DTPE        DTPE11                         Deal type
     C                   MOVEL     #1DSTC        DLST11                         Deal Sub-type
      *                                                                                       CER001
     C     CDL038        IFEQ      'Y'
     C                   MOVEL     #1DCLA        CLAS11
     C                   ELSE
     C                   MOVEL     *BLANKS       CLAS11
     C                   ENDIF
      *
      ** If CSD039 is OFF                                                                     CSD031
      *                                                                                       CSD031
     C     CSD039        IFEQ      'N'
      *                                                                                       CSD031
      ** Or if CSD039 is ON and not for Acceptance                                            CSD031
      *                                                                                       CSD031
     C     CSD039        OREQ      'Y'
     C     P1ACCP        ANDEQ     'C'
      *                                                                                       CSD031
     C     KRTV          CHAIN     FDDTSTL1                           9091      *
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
      ** If CSD039 is ON and while for Acceptance                                             CSD031
      *                                                                                       CSD031
     C     CSD039        IFEQ      'Y'
     C     P1ACCP        ANDEQ     'A'
     C     KRTV          CHAIN     SDADTSL0                           9091
     C                   ENDIF
      *                                                                                       CSD031
     C     *IN91         IFEQ      '1'                                          - B1
      * Record locked
     C                   SETON                                        9931      *
     C                   GOTO      BEEXIT
     C                   END                                                    - E1
      *
      * Verify record existence against program mode
     C     W0PMD         IFNE      'ADD'                                        - B1
      * If record does not exist, error
     C     *IN90         IFEQ      '1'                                          - B2
     C                   SETON                                        993031    *
      * Send message 'Deal Type/subtype      NF'
     C                   MOVEL     'USR0043'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   - X2
     C                   EXSR      MBFL#1
      * USER: Initialize detail screen (existing record)
      * Set-up DTL Screen Footer - Standard Functions  *
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'                                          - B3
     C                   MOVEA     AENA(1)       ##CTX1
     C                   END                                                    - E3
     C*
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'                                          - B3
     C                   MOVEA     AENA(2)       ##CTX1
     C                   END                                                    - E3
     C*
     C*  If Action Code is Amend or Enquiry
     C*
     C     P2ANCD        IFEQ      'A'                                          - B3
     C     P2ANCD        OREQ      'E'
      *                                                                                       CSD031
     C     CSD039        IFEQ      'Y'
      *                                                                                       CSD031
     C     P2ANCD        IFEQ      'A'
     C                   MOVEA     AENA(4)       ##CTX1
     C                   ELSE
     C                   MOVEA     AENA(3)       ##CTX1
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C                   MOVEA     AENA(3)       ##CTX1
      *                                                                                       CSD031
     C                   ENDIF
     C                   END                                                    - E3
     C*
     C                   END                                                    - E2
      *
     C                   ELSE                                                   - X1
      * If record already exists, error
     C     *IN90         IFEQ      '0'                                          - B2
     C                   SETON                                        993031    *
      * Send message 'Deal Type/Sub-type     EX'
     C                   MOVEL     'USR1779'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   - X2
      * USER: Initialize detail screen (new record)
      * Set-up DTL Screen Footer - Standard Functions  *
     C/COPY WNCPYSRC,FDH00015
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'                                          - B3
     C                   MOVEA     AENA(1)       ##CTX1
     C                   END                                                    - E3
     C*
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'                                          - B3
     C                   MOVEA     AENA(2)       ##CTX1
     C                   END                                                    - E3
     C*
     C*  If Action Code is Amend :
     C*
     C     P2ANCD        IFEQ      'A'                                          - B3
     C     P2ANCD        OREQ      'E'
     C                   MOVEA     AENA(3)       ##CTX1
     C                   END                                                    - E3
     C*
     C                   END                                                    - E2
     C                   END                                                    - E1
      *..................................................
     C   99              GOTO      BEEXIT
      * No error: Display and process details
     C                   EXSR      CADSDA
      *
      *================================================================
     CSR   BEEXIT        ENDSR
      /EJECT
     CSR   BFVLKY        BEGSR
      *================================================================
      * Validate key fields
      *================================================================
     C                   MOVE      *OFF          *IN30
     C                   MOVE      *OFF          *IN31
      * USER: Validate key screen
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * Retrieve Deal Type - Deal Sub-types  *
     C                   EXSR      SARVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Send message '*Record already exists'
     C                   MOVEL     'Y2U0003'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      *
      * Validate Deal type
     C                   MOVEL     #1DTPE        WUTQKF                         Test ? in Key F
      *CASE:     WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9930      *
     C                   END                                                    *FI
      *
     C**********           MOVEL#1DSTC    WUTQKF           Test ? in Key F                  BUG10769
      *CASE:*****WRK.Test*?*in*Key*Field*is Question Mark                                   BUG10769
     C********** WUTQKF    IFEQ '?'                        *IF                              BUG10769
      **Send*message*'Question*Mark*Invalid'****                                            BUG10769
     C**********           MOVEL'USR0380' ZAMSID           Message id.                      BUG10769
     C**********           EXSR ZASNMS                     Send message                     BUG10769
     C**********           SETON                     9931  *                                BUG10769
      **********                                                                            BUG10769
     C**********           END                             *FI                              BUG10769
      * Deal type required.
     C     #1DTPE        IFEQ      *BLANK                                       IF
     C                   SETON                                        9930      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
      * Deal Sub-type Code required
     C     #1DSTC        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      ** Class required. (NOT FT TYPES OR CM)                                               BUG10769
      *                                                                                     BUG10769
     C     #1DCLA        IFEQ      *BLANK
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
     C                   SETON                                        9936
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                     BUG10769
      ** Class NOT required.  (FT TYPES AND CM)                                             BUG10769
      *                                                                                     BUG10769
     C     #1DCLA        IFNE      *BLANK
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
     C                   SETON                                        9936
     C                   MOVEL     'Y2U0002'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       241873
      ** If CDL019 enhancement is ON, validate Fix Base Rate                                  241873
      *                                                                                       241873
     C     CDL019        IFEQ      'Y'
      *                                                                                       241873
     C     #1DTPE        IFEQ      'IT'
     C     #1DTPE        OREQ      'TD'
     C     #1DTPE        OREQ      'IP'
     C     #1DTPE        OREQ      'TI'
     C                   MOVE      *ON           *IN63
     C                   ELSE
     C                   MOVE      *OFF          *IN63
     C                   ENDIF
     C                   ENDIF
      *
      * More validations on Deal Type/Subtype
     C     *IN30         IFEQ      *OFF
     C     *IN31         ANDEQ     *OFF
     C                   EXSR      DFV2RC
     C                   END
      *
      *================================================================
     CSR   BFEXIT        ENDSR
      /EJECT
      *================================================================
     CSR   DFV2RC        BEGSR
      *================================================================
      * Validate record
      *================================================================
      * USER: Validate record
      *CASE:     RCD.Subtype is invalid
     C********** KLDLST    KLIST                                                            BUG10769
     C**********           KFLD           #1DSTC                                            BUG10769
     C********** KLDLST    CHAINSDDLSTL1             91                                     BUG10769
     C********** *IN91     IFEQ '1'                                                         BUG10769
      *                                                                                       CSD031
      ** CSD039 swictable feature is off                                                      CSD031
      *                                                                                       CSD031
     C     CSD039        IFEQ      'N'
      *                                                                                       CSD031
     C                   CALL      'AODLSTR0'
     C                   PARM      *BLANK        P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      #1DSTC        P@DLST            2
     C                   PARM                    SDDLST
     C     P@RTCD        IFEQ      '*NRF   '
      * Send message 'Subtype invalid'
     C                   MOVEL     'USR1777'     ZAMSID                         Message id.
     C                   MOVEL     'GBMIDAS'     ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9931      *
     C                   ELSE
     C                   MOVEL     ASDSTC        #1DSTC
     C                   END                                                    *FI
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C     KLDLST        KLIST
     C                   KFLD                    #1DSTC
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
      *                                                                                       CSD031
     C     KLDLST        CHAIN     GPDLSTL1                           91
     C     *IN91         IFEQ      *ON
     C                   MOVEL     'USR1777'     ZAMSID
     C                   MOVEL     'GBMIDAS'     ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9931
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *
     C                   MOVEL     'N'           WERR              1
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
     C     #1DTPE        ANDNE     'C1'
     C     #1DTPE        ANDNE     'C2'
     C     #1DTPE        ANDNE     'BP'
     C     #1DTPE        ANDNE     'BD'
     C     #1DTPE        ANDNE     'TB'
     C     #1DTPE        ANDNE     'DA'
     C     #1DTPE        ANDNE     'TA'
     C     #1DTPE        ANDNE     'CS'
     C     #1DTPE        ANDNE     'BS'
     C     #1DTPE        ANDNE     'BR'
     C     #1DTPE        ANDNE     'TS'
     C     #1DTPE        ANDNE     'RA'
     C     #1DTPE        ANDNE     'TR'
     C     #1DTPE        ANDNE     'PS'
     C     #1DTPE        ANDNE     'ID'
     C     #1DTPE        ANDNE     'IL'
     C     #1DTPE        ANDNE     'IN'
     C     #1DTPE        ANDNE     'CC'
     C     #1DTPE        ANDNE     'CP'
     C     #1DTPE        ANDNE     'NT'
     C     #1DTPE        ANDNE     'RP'
     C     #1DTPE        ANDNE     'FR'                                                        18447
     C     #1DTPE        ANDNE     'RS'                                                        18447
     C     #1DTPE        ANDNE     'RX'                                                        18447
     C     #1DTPE        ANDNE     'RR'                                                        18447
     C     #1DTPE        ANDNE     'RF'                                                        18447
     C     #1DTPE        ANDNE     'NX'
     C                   MOVEL     'Y'           WERR
     C                   ENDIF
      *                                                                                     BUG10153
     C     CDL033        IFEQ      'Y'
     C     #1DTPE        ANDEQ     'CF'
     C                   MOVEL     'N'           WERR
     C                   ENDIF
      *                                                                                     BUG10153
      ** If CDL006 is ON, allow also deal types FL,DP,LP,FT,DT and LT.                      BUG10153
      *                                                                                     BUG10153
     C     CDL006        IFEQ      'Y'
     C     #1DTPE        IFEQ      'FL'
     C     #1DTPE        OREQ      'DP'
     C     #1DTPE        OREQ      'LP'
     C     #1DTPE        OREQ      'FT'
     C     #1DTPE        OREQ      'DT'
     C     #1DTPE        OREQ      'LT'
     C     #1DTPE        OREQ      'IT'
     C     #1DTPE        OREQ      'IP'
     C     #1DTPE        OREQ      'TD'
     C     #1DTPE        OREQ      'TI'
     C     #1DTPE        OREQ      'CI'
     C     #1DTPE        OREQ      'LN'
     C     #1DTPE        OREQ      'CD'
     C     #1DTPE        OREQ      'CL'
     C     #1DTPE        OREQ      'DL'
     C     #1DTPE        OREQ      'FP'
     C     #1DTPE        OREQ      'FS'
     C     #1DTPE        OREQ      'CX'
     C     #1DTPE        OREQ      'PI'
     C     #1DTPE        OREQ      'SI'
     C     #1DTPE        OREQ      'OP'
     C     #1DTPE        OREQ      'OT'
     C     #1DTPE        OREQ      'SW'
     C     #1DTPE        OREQ      'C1'
     C     #1DTPE        OREQ      'C2'
     C     #1DTPE        OREQ      'BP'
     C     #1DTPE        OREQ      'BD'
     C     #1DTPE        OREQ      'TB'
     C     #1DTPE        OREQ      'DA'
     C     #1DTPE        OREQ      'TA'
     C     #1DTPE        OREQ      'CS'
     C     #1DTPE        OREQ      'BS'
     C     #1DTPE        OREQ      'BR'
     C     #1DTPE        OREQ      'TS'
     C     #1DTPE        OREQ      'RA'
     C     #1DTPE        OREQ      'TR'
     C     #1DTPE        OREQ      'PS'
     C     #1DTPE        OREQ      'ID'
     C     #1DTPE        OREQ      'IL'
     C     #1DTPE        OREQ      'IN'
     C     #1DTPE        OREQ      'CC'
     C     #1DTPE        OREQ      'CP'
     C     #1DTPE        OREQ      'NT'
     C     #1DTPE        OREQ      'RP'
     C     #1DTPE        OREQ      'FR'
     C     #1DTPE        OREQ      'RS'
     C     #1DTPE        OREQ      'RX'
     C     #1DTPE        OREQ      'RR'
     C     #1DTPE        OREQ      'RF'
     C     #1DTPE        OREQ      'NX'
     C                   MOVEL     'N'           WERR
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10153
      ** If CFT006 is ON, allow also deal types RI,RO                                       BUG10153
      *                                                                                     BUG10153
     C     CFT006        IFEQ      'Y'
     C     #1DTPE        IFEQ      'RI'
     C     #1DTPE        OREQ      'RO'
     C                   MOVEL     'N'           WERR
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10153
      ** If CFT008 is ON, allow also deal types BI,BO                                       BUG10153
      *                                                                                     BUG10153
     C     CFT008        IFEQ      'Y'
     C     #1DTPE        IFEQ      'BI'
     C     #1DTPE        OREQ      'BO'
     C                   MOVEL     'N'           WERR
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10153
      ** If CRE008 is ON, allow also deal type  CM                                          BUG10153
      *                                                                                     BUG10153
     C     CRE008        IFEQ      'Y'
     C     #1DTPE        IFEQ      'CM'
     C                   MOVEL     'N'           WERR
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10153
     C     WERR          IFEQ      'Y'
      *
      * Send message 'Deal type invalid'
     C                   MOVEL     'USR1778'     ZAMSID                         Message id.
     C                   MOVEL     'GBMIDAS'     ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9930      *
     C                   END                                                    *FI
      *                                                                                       CSD031
      ** If CSD039 is ON, do not show fields 'Accept to Zone' or                              CSD031
      ** 'Central Data'                                                                       CSD031
      *                                                                                       CSD031
     C     CSD039        IFEQ      'Y'
     C     P1ACCP        ANDEQ     'A'
     C                   MOVE      *ON           *IN57
     C                   ENDIF
      *                                                                                       CER001
      ** Validate the class if CDL038 is on                                                   CER001
      *                                                                                       CER001
     C     CDL038        IFEQ      'Y'
     C                   EXSR      SRCLA
     C                   ENDIF
      *
      *================================================================
     CSR   DFEXIT        ENDSR
      /EJECT
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  SRCLA - Validate class                                       *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRCLA         BEGSR
      *                                                                                       CER001
     C                   MOVE      *OFF          *IN36
      *                                                                                     BUG10153
      * Send message 'Class invalid' if blank and shouldn't be.                             BUG10153
     C     #1DCLA        IFEQ      *BLANK
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
     C                   SETON                                        9936      *
     C                   MOVEL     'USR9012'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END
      * Send message 'Class invalid' if not blank and should be.                            BUG10153
     C     #1DCLA        IFNE      *BLANK
     C     #1DTPE        IFEQ      'IN'
     C     #1DTPE        OREQ      'CC'
     C     #1DTPE        OREQ      'CP'
     C     #1DTPE        OREQ      'NT'
     C     #1DTPE        OREQ      'RI'
     C     #1DTPE        OREQ      'RO'
     C     #1DTPE        OREQ      'BI'
     C     #1DTPE        OREQ      'BO'
     C     #1DTPE        OREQ      'CM'
     C                   SETON                                        9936      *
      * Send message '*Value not required'                                                  BUG10153
     C                   MOVEL     'USR9012'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END
     C                   END
     C***********#1DCLA****IFEQ *BLANKS                                              CER001 BUG10153
     C*********************SETON                     9936                            CER001 BUG10153
      *********************                                                          CER001 BUG10153
      ***Send*message*'*Value required'                                              CER001 BUG10153
      *********************                                                          CER001 BUG10153
     C*********************MOVEL'Y2U0001' ZAMSID                                     CER001 BUG10153
     C*********************MOVEL'Y2USRMSG'ZAMSGF                                     CER001 BUG10153
     C*********************EXSR ZASNMS                                               CER001 BUG10153
     C*********************ELSE                                                      CER001 BUG10153
      *                                                                                       CER001
      ** Check for class                                                                      CER001
      *                                                                                       CER001
     C     #1DCLA        IFNE      *BLANKS
     C                   CALL      'AOTCLSR0'
     C                   PARM      *BLANK        P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      #1DCLA        P@CLAS            4
     C                   PARM                    SDTCLS
      *                                                                                       CER001
     C     P@RTCD        IFEQ      '*NRF   '
      *                                                                                       CER001
      ** Send message 'Class invalid'                                                         CER001
      *                                                                                       CER001
     C                   MOVEL     'USR9012'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9936
     C                   ELSE
     C                   MOVEL     TCCLAS        #1DCLA
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDIF
     C                   ENDSR
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
     CSR   CADSDA        BEGSR
      *================================================================
      * Display and process detail screen
      *================================================================
      * Conduct detail screen conversation
      * - repeat until screen control flag is reset:
     C     W0TRN         DOWEQ     'Y'
      * Display detail screen
     C                   EXSR      CBEXFM
      * Process response to detail screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
      * HOME: Reset screen fields
     C   05              CAS                     CCDSPV
      * Process detail screen input
     C                   CAS                     CFPRSC
     C                   END
     C     W0TRN         IFEQ      'R'
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'Y'           W0TRN
     C                   EXSR      MAIZ#1
     C                   END
     C                   END
      *
      ** Instruct screen to return to subfile if enquiry mode and                             CSD031
      ** CSD039 is on                                                                         CSD031
      *                                                                                       CSD031
     C     CSD039        IFEQ      'Y'
     C     P2ANCD        ANDEQ     'E'
     C     *IN05         ANDEQ     *OFF
     C                   MOVEL     'N'           W0TRN
     C                   ENDIF
      *                                                                                       CSD031
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   CBEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GBDSAD
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            29
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         CBIN89            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y1SET
     C                   END
      *
      * If Enquiry mode, protect Description and Intrument fields
     C     P2ANCD        IFEQ      'E'
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN35
     C                   ELSE
      *                                                                                       CSD031
      ** If CSD039 is on, fields must be protected if action is delete                        CSD031
      *                                                                                       CSD031
     C     CSD039        IFEQ      'Y'
     C     WP0001        ANDEQ     'D'
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN35
     C                   ELSE
     C                   MOVE      *OFF          *IN35
      *                                                                                       CSD031
      ** Protect Deal Type/Subtype Desc. in zonal                                             CSD031
     C     *INU1         IFEQ      *OFF
     C     CSD039        ANDEQ     'Y'
     C                   MOVE      *ON           *IN34
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD039        IFEQ      'Y'
      *                                                                                       CSD031
      ** If called from Central Layer                                                         CSD031
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C                   MOVEA     '000'         *IN(54)
     C                   ELSE
      *                                                                                       CSD031
      ** If called from Zone Layer                                                            CSD031
      *                                                                                       CSD031
     C     P1ACCP        IFEQ      'A'
     C                   MOVE      *ON           *IN58
     C                   ELSE
     C                   MOVE      *OFF          *IN58
     C                   ENDIF
     C                   MOVEA     '111'         *IN(54)
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   CBEXIT        ENDSR
      /EJECT
     CSR   CCDSPV        BEGSR
      *================================================================
      * Redisplay previous screen
      *================================================================
      * USER: Process key screen request
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * Set-up KEY Screen Footer - Standard Functions  *
     C                   MOVEA     ARGV(1)       ##CTX1
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C     CSD039        IFEQ      'N'
     C     CSD039        OREQ      'Y'
     C     *IN12         ANDEQ     *ON
      * Start of 059331 - F12 for previous screen
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ENDIF
      * End of 059331
     C                   END                                                    *FI
     C   05              MOVEL     'R'           W0TRN
     C   12              MOVEL     'K'           W0TRN
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT
     CSR   CFPRSC        BEGSR
      *================================================================
      * Validate record
      *================================================================
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * If delete is not pending....
      * Validate details
     C  N10              CAS                     DCVLDL
     C                   END
      * QUIT if error:
     C   99              GOTO      CFEXIT
     C/COPY WNCPYSRC,FDH00076
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           CFEXIT
     C     W0RPT         CABEQ     'Y'           CFEXIT
      * No error: update record
     C     CSD039        IFEQ      'Y'
     C     P2ANCD        ANDNE     'E'
     C     CSD039        OREQ      'N'
     C                   EXSR      EBPR##
     C                   ENDIF
      *================================================================
     CSR   CFEXIT        ENDSR
      /EJECT
     CSR   DCVLDL        BEGSR
      *================================================================
      * Validate details
      *================================================================
     C                   MOVEL     *BLANK        W0RTN
      * Enquiry processing                                                                  BUG24223
     C     P2ANCD        IFEQ      'E'
     C                   MOVE      'Y'           W0DCF
     C                   MOVEL     'N'           W0TRN
     C                   GOTO      DCEXIT
     C                   ENDIF
      * Delete processing.
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
      * Send message 'F3/F10/F12 only valid opt'
     C                   MOVEL     'USR0536'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
      * Validate Deal Type/Subtype Name
      * CASE: DTL.Deal Type/Subtype name is blank
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
     C                   SETON                                        9932      *
      *
     C                   END                                                    *FI
      *
      ** Validate Instrument type
     C     BGPFMG        IFEQ      'Y'
     C     BGN4ST        OREQ      'Y'
     C********** CGL014    OREQ 'Y'                                                BUG10769 MD056747
     C********** CLE025    OREQ 'Y'                                                BUG10769 MD056747
     C     #1INNR        IFNE      *BLANK
      *
     C                   CALL      'AOPLINR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      #1INNR        @INNR             3
     C     SDPLIN        PARM      SDPLIN        DSSDY
      *
      **Clear*messages*from*program*message*queue.*                                         BUG10769
     C**********           CALL 'Y2CLMSC'                                                   BUG10769
     C**********           PARM ##PGM     ZAPGM  10                                         BUG10769
     C**********           PARM '*SAME'   ZAPGRL  5                                         BUG10769
      **Reset*first*message*only*flag.*                                                     BUG10769
     C**********           MOVEL'Y'       ZAFSMS  1      99*                                BUG10769
      *                                                                                     BUG10769
      ** Pass the value retrieved from AOPLINR0.                                            BUG10769
      *                                                                                     BUG10769
     C                   MOVEL     @INNR         #1INNR
      *
      ** Instrument Type invalid
     C     @RTCD         IFEQ      '*NRF'
     C     #1INNR        ANDNE     '?'
     C                   SETON                                        9933      *
     C**********           MOVEL'USR4272' ZAMSID           Message id.                      BUG10769
     C**********           MOVEL'GBMIDAS' ZAMSGF           Message file.                    BUG10769
     C                   MOVEL     'USR4523'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ELSE
      *
      ** Default SDPORTPD Instrument Type.
     C     BGPFMG        IFEQ      'Y'
     C********** CGL014    OREQ 'Y'                                                BUG10769 MD056747
     C********** CLE025    OREQ 'Y'                                                BUG10769 MD056747
     C                   MOVE      FCDINR        #1INNR
     C                   ELSE
      *                                                                                     BUG10769
      ** Instrument type must be entered                                                    BUG10769
      *                                                                                     BUG10769
     C     #1INNR        IFEQ      *BLANK
      *                                                                                       CSD031
     C     CSD039        OREQ      'Y'
     C     *INU1         ANDEQ     *ON
     C     P2ANCD        ANDEQ     'A'
      *                                                                                       CSD031
     C     CSD039        OREQ      'N'
      *                                                                                       CSD031
     C                   SETON                                        9933
     C                   MOVE      *BLANKS       ZAMSGF
     C                   MOVEL     'USR4524'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10769
      ** Process '?' processing                                                             BUG10769
      *                                                                                     BUG10769
     C     #1INNR        IFEQ      '?'
     C                   MOVEL     PDINNR        #1INNR
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10769
      ** Validate the Global Product and Instrument Codes if CGP001                         BUG10769
      ** is enabled.                                                                        BUG10769
      *                                                                                     BUG10769
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRVGPC
     C                   EXSR      SRVGIC
     C     W0INSC        IFEQ      '?'
     C                   MOVEL     #1INSC        W0INSC
     C                   MOVEL     'Y'           W0RPT
     C                   GOTO      DCEXIT
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10769
      ** If CDL019 enhancement is ON, validate Fix Base Rate                                BUG10769
      *                                                                                     BUG10769
     C     CDL019        IFEQ      'Y'
      *                                                                                     BUG10769
     C     #1DTPE        IFEQ      'IT'
     C     #1DTPE        OREQ      'TD'
     C     #1DTPE        OREQ      'IP'
     C     #1DTPE        OREQ      'TI'
     C                   MOVE      *ON           *IN63
     C                   ELSE
     C                   MOVE      *OFF          *IN63
     C                   ENDIF
      *                                                                                     BUG10769
     C     #1FBRT        IFNE      *BLANK
     C     #1FBRT        ANDNE     'Y'
     C     #1FBRT        ANDNE     'N'
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN40
     C                   MOVEL     'USR9155'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C     #1FBRT        IFEQ      *BLANK
     C                   MOVE      'N'           #1FBRT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10769
      ** If CAS009 is ON, validate Amortised Cost Accounting Indicator                      BUG10769
      *                                                                                     BUG10769
     C     CAS009        IFEQ      'Y'
     C     #1ACAI        IFNE      ' '
     C     #1ACAI        ANDNE     'Y'
     C     #1ACAI        ANDNE     'N'
     C                   MOVE      *ON           *IN44
     C                   MOVE      *ON           *IN99
      **Send message 'Valid values are 'Y', 'N' and blank'                                  BUG10769
     C                   MOVEL     'USR9155'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
      *                                                                                     BUG10769
     C     #1ACAI        IFEQ      'Y'
     C     #1ACAI        OREQ      'N'
      *                                                                                     BUG10769
     C     #1DTPE        LOOKUP    @DL                                    85
      *                                                                                     BUG10769
     C     *IN85         IFEQ      *OFF
     C                   MOVEL     'CAS0017'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN44
     C                   MOVE      *ON           *IN99
     C                   ENDIF
      *                                                                                     BUG10769
     C                   ENDIF
      *                                                                                     BUG10769
     C                   ENDIF
      *                                                                                     BUG10769
     C                   ENDIF
      *                                                                                     BUG10769
      ** If Initialisation program has run, do additional validation                        BUG10769
     C     WCAS9I        IFEQ      'Y'
      *                                                                                     BUG10769
      ** If CSD039 is OFF                                                                     CSD031
      *                                                                                       CSD031
     C     CSD039        IFEQ      'N'
      *                                                                                       CSD031
      ** Or if CSD039 is ON and not for Acceptance                                            CSD031
      *                                                                                       CSD031
     C     CSD039        OREQ      'Y'
     C     P1ACCP        ANDEQ     'C'
      *                                                                                       CSD031
      ** Retrieve Deal Type/Sub Type Record                                                 BUG10769
     C     KDTST#        CHAIN     FDDTSTL1                           70
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
      ** If CSD039 is ON and while for Acceptance                                             CSD031
      *                                                                                       CSD031
     C     CSD039        IFEQ      'Y'
     C     P1ACCP        ANDEQ     'A'
     C     KRTV          CHAIN     SDADTSL0                           9091
     C                   ENDIF
      *                                                                                     BUG10769
     C     #1ACAI        IFNE      FSACAI
      *                                                                                     BUG10769
      ** Check If Deal Type/Sub Type is attached to a Live Deal.                            BUG10769
      ** If it is, do not allow changing of ACAI                                            BUG10769
     C     KDTST#        CHAIN     DEALSL10                           70
     C     *IN70         IFEQ      *OFF
     C                   MOVEL     'USR9652'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN44
     C                   MOVE      *ON           *IN99
     C                   ENDIF
      *                                                                                     BUG10769
     C                   ENDIF
      *                                                                                     BUG10769
     C                   ENDIF
      *                                                                                     BUG10769
      ** If CAS001 enhancement is ON, validate Yield Curves:                                BUG10769
      *                                                                                     BUG10769
     C     CAS001        IFEQ      'Y'
     C/COPY WNCPYSRC,FDH00061
      *                                                                                     BUG10769
      ** Validate Buy/Our Yield Curve                                                       BUG10769
      *                                                                                     BUG10769
     C     #1OURY        IFNE      *BLANK
     C                   CALL      'AOYLDCR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1OURY        PYLDC             5
     C     SDYLDC        PARM      SDYLDC        DSSDY
      *                                                                                     BUG10769
     C                   MOVEL     PYLDC         #1OURY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      '*NRF'
     C                   MOVE      *ON           *IN41
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9157'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10769
      ** Validate Sell/Their Yield Curve                                                    BUG10769
      *                                                                                     BUG10769
     C     #1THRY        IFNE      *BLANK
     C                   CALL      'AOYLDCR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1THRY        PYLDC
     C     SDYLDC        PARM      SDYLDC        DSSDY
      *                                                                                     BUG10769
     C                   MOVEL     PYLDC         #1THRY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      '*NRF'
     C                   MOVE      *ON           *IN42
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9182'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                     BUG10769
      ** Optional only for the following deal type:                                         BUG10769
      ** FP,FS,CX,OP,OT,SW,SI,PI,RX                                                         BUG10769
      ** When CAS005 is On, Their Sell Yield Curve is                                       BUG10769
      ** also optional for deal type RS                                                     BUG10769
      *                                                                                     BUG10769
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
     C                   MOVE      *ON           *IN42
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9156'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10769
      ** Validate Yield Curve Mandatory entry                                               BUG10769
      *                                                                                     BUG10769
     C     #1YLDM        IFEQ      *BLANK
     C     #1YLDM        OREQ      'Y'
     C     #1YLDM        OREQ      'N'
      *                                                                                     BUG10769
     C                   ELSE
     C                   MOVE      *ON           *IN43
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9155'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10769
      ** If CAS005 is ON, validate Yield Curves:                                            BUG10769
      *                                                                                     BUG10769
     C     CAS005        IFEQ      'Y'
      *                                                                                     BUG10769
      ** Validate Buy/Our Forward Yield Curve                                               BUG10769
      *                                                                                     BUG10769
     C     #1ORFY        IFNE      *BLANK
     C                   CALL      'AOYLDCR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1ORFY        PYLDC
     C     SDYLDC        PARM      SDYLDC        DSSDY
      *                                                                                     BUG10769
     C                   MOVEL     PYLDC         #1ORFY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      '*NRF'
     C                   MOVE      *ON           *IN45
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9644'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10769
      ** Validate Sell/Their Forward Yield Curve                                            BUG10769
      *                                                                                     BUG10769
     C     #1THFY        IFNE      *BLANK
     C                   CALL      'AOYLDCR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1THFY        PYLDC
     C     SDYLDC        PARM      SDYLDC        DSSDY
      *                                                                                     BUG10769
     C                   MOVEL     PYLDC         #1THFY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      '*NRF'
     C                   MOVE      *ON           *IN46
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9645'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                     BUG10769
      ** Optional only for the following deal type:                                         BUG10769
      ** FP,FS,CX,OP,OT,SW,SI,PI,RX,RS                                                      BUG10769
      *                                                                                     BUG10769
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
     C                   MOVE      *ON           *IN46
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9156'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10769
      ** Validate Yield Curve Mandatory entry                                               BUG10769
      *                                                                                     BUG10769
     C     #1FYCM        IFEQ      *BLANK
     C     #1FYCM        OREQ      'Y'
     C     #1FYCM        OREQ      'N'
      *                                                                                     BUG10769
     C                   ELSE
     C                   MOVE      *ON           *IN47
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9155'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10769
      ** If CAS008 and CIR003, Validate Fwd Commitment yield curve                          BUG10769
      *                                                                                     BUG10769
     C     CAS008        IFEQ      'Y'
     C     CIR003        ANDEQ     'Y'
      *                                                                                     BUG10769
      ** Validate Buy/Our Forward Cmt Yield Curve                                           BUG10769
      *                                                                                     BUG10769
     C     #1OFCY        IFNE      *BLANK
     C     #1DTPE        ANDEQ     'RX'
     C                   CALL      'AOYLDCR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1OFCY        PYLDC
     C     SDYLDC        PARM      SDYLDC        DSSDY
      *                                                                                     BUG10769
     C                   MOVEL     PYLDC         #1OFCY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      '*NRF'
     C                   MOVE      *ON           *IN48
     C                   MOVE      *ON           *IN99
      *                                                                                     BUG10769
      ** Buy/Our Forward Commitment Yield Curve not valid                                   BUG10769
      *                                                                                     BUG10769
     C                   MOVEL     'USR9655'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10769
     C     #1OFCY        IFNE      *BLANK
     C     #1DTPE        ANDNE     'RX'
      *                                                                                     BUG10769
     C                   MOVE      *ON           *IN48
     C                   MOVE      *ON           *IN99
      *                                                                                     BUG10769
      ** Forward Commitment Yield Curve must be blank if deal type                          BUG10769
      ** is not 'RX'.                                                                       BUG10769
      *                                                                                     BUG10769
     C                   MOVEL     'USR9657'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                     BUG10769
      ** Validate Sell/Their Forward Cmt Yield Curve                                        BUG10769
      *                                                                                     BUG10769
     C     #1TFCY        IFNE      *BLANK
     C     #1DTPE        ANDEQ     'RX'
     C                   CALL      'AOYLDCR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1TFCY        PYLDC
     C     SDYLDC        PARM      SDYLDC        DSSDY
      *                                                                                     BUG10769
     C                   MOVEL     PYLDC         #1TFCY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      '*NRF'
     C                   MOVE      *ON           *IN49
     C                   MOVE      *ON           *IN99
      *                                                                                     BUG10769
      ** Sell/Their Forward Commitment Yield Curve not valid                                BUG10769
      *                                                                                     BUG10769
     C                   MOVEL     'USR9656'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10769
     C     #1TFCY        IFNE      *BLANK
     C     #1DTPE        ANDNE     'RX'
      *                                                                                     BUG10769
     C                   MOVE      *ON           *IN49
     C                   MOVE      *ON           *IN99
      *                                                                                     BUG10769
      ** Forward Commitment Yield Curve must be blank if deal type                          BUG10769
      ** is not 'RX'.                                                                       BUG10769
      *                                                                                     BUG10769
     C                   MOVEL     'USR9658'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                     BUG10769
      ** Validate Fwd Cmt Yield Curve Mandatory entry                                       BUG10769
      *                                                                                     BUG10769
     C     #1DTPE        IFEQ      'RX'
      *                                                                                     BUG10769
     C     #1FCCM        IFEQ      *BLANK
     C     #1FCCM        OREQ      'Y'
     C     #1FCCM        OREQ      'N'
     C                   ELSE
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN99
      *                                                                                     BUG10769
      ** Valid values are 'Y', 'N' and blank                                                BUG10769
      *                                                                                     BUG10769
     C                   MOVEL     'USR9155'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                     BUG10769
     C                   ELSE
      *                                                                                     BUG10769
     C     #1FCCM        IFNE      *BLANK
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN99
      *                                                                                     BUG10769
      ** Forward Commitment Yield Curve Mandatory must be blank if                          BUG10769
      ** deal type is not 'RX'.                                                             BUG10769
      *                                                                                     BUG10769
     C                   MOVEL     'USR9659'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                     BUG10769
     C                   ENDIF
      *                                                                                     BUG10769
     C                   ENDIF
      *                                                                                     BUG10769
      ** Validate Accept to Zone and Effective Date fields                                    CSD031
      ** If feature CSD039 is on                                                              CSD031
      *                                                                                       CSD031
     C     CSD039        IFEQ      'Y'
      *                                                                                       CSD031
     C                   Z-ADD     *ZERO         WEACC             5 0
      *                                                                                       CSD031
      ** If called from Central Layer                                                         CSD031
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
      *                                                                                       CSD031
     C     P2ANCD        IFNE      'E'
     C     P2ANCD        ANDNE     'D'
      *                                                                                       CSD031
      ** If Accept to zone is blank default it with 'N'                                       CSD031
      *                                                                                       CSD031
     C     #1ACZN        IFEQ      *BLANK
     C                   MOVE      'N'           #1ACZN
     C                   ENDIF
      *                                                                                       CSD031
      ** Valid values for accept to zone is either Y or N only                                CSD031
      *                                                                                       CSD031
     C     #1ACZN        IFNE      'Y'
     C     #1ACZN        ANDNE     'N'
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN52
      *                                                                                       CSD031
      ** Send error message                                                                   CSD031
      *                                                                                       CSD031
     C                   MOVEL     'SCC0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
      ** Effective Date may only be entered if 'Accept to Zone' is 'N'                        CSD031
      *                                                                                       CSD031
     C     #1EFDT        IFNE      *BLANK
      *                                                                                       CSD031
     C     #1ACZN        IFEQ      'N'
      *                                                                                       CSD031
      ** Check validity of effective date entered                                             CSD031
      *                                                                                       CSD031
     C                   MOVE      #1EFDT        ZDATE
     C                   EXSR      ZDATE1
      *                                                                                       CSD031
     C     ZERR          IFNE      *BLANK
     C                   MOVEL     'ASM0045'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN53
     C                   ELSE
     C                   Z-ADD     ZDAYNO        WEACC
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C     P2ANCD        IFNE      'E'
     C     P2ANCD        ANDNE     'D'
     C                   MOVEL     'CSD0001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN53
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
     C                   Z-ADD     0             ZDAYNO
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C                   MOVEL     'N'           W0RPT
      *                                                                                     BUG24222
     C     CER047        IFEQ      'Y'
      *                                                                                     BUG24222
     C     #1K24C        IFEQ      *BLANKS
     C                   MOVE      'Y'           #1K24C
     C                   ENDIF
      *                                                                                     BUG24222
     C     #1K24C        IFNE      'Y'
     C     #1K24C        ANDNE     'N'
     C                   MOVE      *ON           *IN78
     C                   MOVEL     'USR3973'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                     BUG24222
     C                   ENDIF
      *----------------------------------------------------------------
      *
      * CALC: Detail screen function fields
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
      * Process delete request
     C   10              CAS                     EDDLRQ
      * Process add request
     C     W0PMD         CASEQ     'ADD'         ECADRQ
      * Process update request
     C     W0PMD         CASNE     'ADD'         EECHRQ
     C                   END
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes
     C                   ROLBK
     C                   GOTO      EBEXIT
     C                   ELSE
      * Otherwise COMMIT any DBF changes
     C                   COMMIT
     C                   END
      * Start of 059331 - F3 to exit program
      * CASE: DTL.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * End of 059331
     C     W0PMD         IFEQ      'ADD'
      * Exit after successful add
     C                   MOVEL     'N'           W0RPT
     C                   END
      * Restart program for next record
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Deal Sub/Ty(FR) - Deal Sub-types  *
     C                   EXSR      SBCRRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record added'
     C                   MOVEL     'Y2U0011'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete DBF record
      * Delete Deal Sub/Ty(FR) - Deal Sub-types  *
     C                   EXSR      SDDLRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record deleted'
     C                   MOVEL     'Y2U0013'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
      * Change Deal Sub/Ty(Fr) - Deal Sub-types  *
     C                   EXSR      SFCHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Reset screen fields if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
     C                   END
     C                   ELSE
      * Send message '*Record changed'
     C                   MOVEL     'Y2U0012'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACKPM        BEGSR
      *================================================================
      * Check passed parameters
      *================================================================
      * Is full key present?
     C                   MOVE      *BLANK        WCLRQD            1
     C     CDL038        IFEQ      'Y'
     C     P1DTPE        IFNE      'OP'
     C     P1DTPE        ANDNE     'IN'
     C     P1DTPE        ANDNE     'CC'
     C     P1DTPE        ANDNE     'CP'
     C     P1DTPE        ANDNE     'NT'
     C     P1DTPE        ANDNE     'RP'
     C     P1DTPE        ANDNE     'RI'
     C     P1DTPE        ANDNE     'RO'
     C     P1DTPE        ANDNE     'BI'
     C     P1DTPE        ANDNE     'BO'
     C     P1DTPE        ANDNE     'CM'
     C                   MOVE      'Y'           WCLRQD
     C                   ENDIF
     C                   ENDIF
     C     P1DTPE        IFEQ      *BLANK                                       Deal type
     C     P1DSTC        OREQ      *BLANK                                       Deal Sub-type
     C********** P1DCLA    OREQ *BLANK                     Deal Class              BUG10769 BUG11819
     C     CDL038        ANDEQ     'Y'
     C     WCLRQD        ANDEQ     'Y'
      * Not every key field passed - loop program
     C                   MOVEL     'Y'           W0RPT             1
     C                   ELSE
      * Full key passed, so single shot program
     C                   MOVEL     'N'           W0RPT
     C                   END
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   GADSAK        BEGSR
      *================================================================
      * Set key screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSAD        BEGSR
      *================================================================
      * Set detail screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect key fields on detail screen
     C                   SETON                                        88        *
      * Enable key screen
     C                   SETON                                        87        *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields and "neither" paramete
      *================================================================
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1NARR                         Description
     C                   MOVEL     *BLANK        #1INNR                         Instrument
     C                   MOVEL     *BLANK        #1FBRT                         Fix Base Rate
     C                   MOVEL     *BLANK        #1PLDP                         Pricing Group  CPL00
     C                   MOVEL     *BLANK        #1PLDR                         Reporting GroupCPL00
     C                   MOVEL     *BLANK        #1PLCR                         Credit Rating  CPL00
     C                   MOVEL     *BLANK        #1OURY
     C                   MOVEL     *BLANK        #1THRY
     C                   MOVEL     *BLANK        #1YLDM
     C                   MOVEL     *BLANK        #1ORFY
     C                   MOVEL     *BLANK        #1THFY
     C                   MOVEL     *BLANK        #1FYCM
     C                   MOVE      *BLANKS       #1PRDC
     C                   MOVE      *BLANKS       #1INSC
     C                   MOVEL     *BLANK        #1OFCY
     C                   MOVEL     *BLANK        #1TFCY
     C                   MOVEL     *BLANK        #1FCCM
     C                   MOVE      *BLANK        #1ACAI                         Amort Cost Acct Ind.
     C                   MOVE      *BLANK        #1ACZN
     C                   MOVE      *BLANK        #1EFDT
     C     CER047        IFEQ      'Y'
     C                   MOVE      *BLANK        #1K24C
     C                   ENDIF
     C/COPY WNCPYSRC,FDH00016
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move FDDTSTPD fields to screen
      *================================================================
     C                   Z-ADD     LCD11         #1LCD                          Last Change Dat
     C                   MOVEL     TYLC11        #1TYLC                         Type of Last Ch
     C                   MOVEL     DTPE11        #1DTPE                         Deal type
     C                   MOVEL     DLST11        #1DSTC                         Deal Sub-type
     C                   MOVEL     NARR11        #1NARR                         Description
     C                   MOVEL     INNR          #1INNR                         Instrument
      *                                                                                       CER001
     C/COPY WNCPYSRC,FDH00017
     C     CDL038        IFEQ      'Y'
     C                   MOVE      CLAS11        #1DCLA
     C                   ELSE
     C                   MOVE      *BLANKS       #1DCLA
     C                   ENDIF
      *                                                                                       CER001
     C                   MOVEL     FDFBRT        #1FBRT                         Fix Base Rate
     C                   MOVEL     PLDPCD        #1PLDP                         Pricing Group  CPL00
     C                   MOVEL     PLDRCD        #1PLDR                         Reporting GroupCPL00
     C                   MOVEL     PLCRED        #1PLCR                         Credit Rating  CPL00
     C                   MOVEL     FSOURY        #1OURY
     C                   MOVEL     FSTHRY        #1THRY
     C                   MOVEL     FSYLDM        #1YLDM
     C                   MOVEL     FSORFY        #1ORFY
     C                   MOVEL     FSTHFY        #1THFY
     C                   MOVEL     FSFYCM        #1FYCM
      *                                                                                     BUG10769
     C     CDL019        IFEQ      'Y'
     C     #1DTPE        IFEQ      'IT'
     C     #1DTPE        OREQ      'TD'
     C     #1DTPE        OREQ      'IP'
     C     #1DTPE        OREQ      'TI'
     C                   MOVE      *ON           *IN63
     C                   ELSE
     C                   MOVE      *OFF          *IN63
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG10769
      ** Move the Global Product and Instrument Codes to screen fields                      BUG10769
      ** if CGP001 is enabled.                                                              BUG10769
      *                                                                                     BUG10769
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPPI
     C                   ENDIF
      *                                                                                     BUG10769
     C                   MOVEL     FSOFCY        #1OFCY
     C                   MOVEL     FSTFCY        #1TFCY
     C                   MOVEL     FSFCCM        #1FCCM
     C                   MOVE      FSACAI        #1ACAI
      *                                                                                       CSD031
     C     CSD039        IFEQ      'Y'
     C                   MOVE      *BLANK        #1EFDT
     C                   MOVE      EACC11        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATEP        #1EFDT
     C     ZDATEP        IFEQ      *ZERO
     C                   MOVE      *BLANK        #1EFDT
     C                   ENDIF
      *                                                                                       CSD031
      ** If called from Central Layer                                                         CSD031
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C                   MOVE      AACC11        #1ACZN
     C                   ELSE
      *                                                                                       CSD031
      ** If called from Zone Layer                                                            CSD031
      *                                                                                       CSD031
     C                   MOVE      GPDT11        #1ACZN
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C     CER047        IFEQ      'Y'
     C                   MOVEL     FSK24C        #1K24C
     C                   ENDIF
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P1DTPE        #1DTPE                         Deal type
     C                   MOVEL     P1DSTC        #1DSTC                         Deal Sub-type
      *                                                                                       CER001
     C     CDL038        IFEQ      'Y'
     C                   MOVEL     P1DCLA        #1DCLA
     C                   ELSE
     C                   MOVE      *BLANKS       #1DCLA
     C                   ENDIF
      * USER: Initialize key screen
      * Set-up KEY Screen Footer - Standard Functions  *
     C                   MOVEA     ARGV(1)       ##CTX1
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Retrieve Deal Sub-Type - Deal Sub-types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    DTPE11                         Deal type
     C                   KFLD                    DLST11                         Deal Sub-type
     C                   KFLD                    CLAS11
      * Move fields to key list
     C                   MOVEL     #1DTPE        DTPE11                         Deal type
     C                   MOVEL     #1DSTC        DLST11                         Deal Sub-type
      *                                                                                       CER001
     C     CDL038        IFEQ      'Y'
     C                   MOVEL     #1DCLA        CLAS11
     C                   ELSE
     C                   MOVE      *BLANKS       CLAS11
     C                   ENDIF
      *                                                                                       CER001
     C     KRSSA         CHAIN     FDDTSTL1                           90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0043'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   ELSE
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCRRC        BEGSR
      *================================================================
      * Create Deal Sub/Ty(FR) - Deal Sub-types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to FDDTSTL0
     C                   MOVEL     #1DTPE        DTPE11                         Deal type
     C                   MOVEL     #1DSTC        DLST11                         Deal Sub-type
     C                   Z-ADD     WURDNB        LCD11                          Last Change Dat
     C                   MOVEL     'I'           TYLC11                         Type of Last Ch
     C                   MOVEL     #1NARR        NARR11                         Description
     C                   MOVEL     #1INNR        INNR                           Instrument
      *                                                                                       CER001
     C     CDL038        IFEQ      'Y'
     C                   MOVEL     #1DCLA        CLAS11
     C                   ELSE
     C                   MOVEL     *BLANKS       CLAS11
     C                   ENDIF
     C                   MOVEL     #1FBRT        FDFBRT                         Fix Base Rate
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
      *                                                                                       CSD031
     C     CSD039        IFEQ      'Y'
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C                   MOVE      *ON           *IN56
     C                   MOVE      'Y'           GPDT11
     C                   MOVE      #1ACZN        AACC11
     C                   ELSE
     C                   MOVEL     P1DTPE        K1DTPE
     C                   MOVEL     P1DSTC        K1DSTC
     C                   MOVEL     P1DCLA        K1DCLA
     C                   MOVE      *BLANK        GPDT11
     C     KDTSL0        CHAIN     SDADTSL0                           90
     C     *IN90         IFEQ      *OFF
      *                                                                                       CSD031
      ** Send message                                                                         CSD031
      *                                                                                       CSD031
     C                   MOVEL     'CSD0002'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     AACC11        WZONE
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD     WEACC         EACC11
     C                   ELSE
     C                   Z-ADD     0             EACC11
     C                   ENDIF
     C     CER047        IFEQ      'Y'
     C                   MOVEL     #1K24C        FSK24C
     C                   ENDIF
      *
      * USER: Processing before Data update
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * Start of SAR S01117
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,FDH00077
     C                   MOVEL     DTSTDS        DATA
     C                   CALL      'WN0010'                                                   S
     C                   PARM      ##PGM         UPGM             10            Program
     C                   PARM      *BLANK        UFKEY             2            Function Key
     C                   PARM      'I'           UACTCD            1            Action  S01212
     C                   PARM                    DATA                           Trans Data
     C                   PARM      *BLANK        W0RTN                          Return Code
     C                   PARM                    SPARE           256            Spare Field
      * End of SAR S01117
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SBEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SBEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SBEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C*
     C                   END                                                    *FI
     C     KLCRSB        KLIST
     C                   KFLD                    DTPE11                         Deal type
     C                   KFLD                    DLST11                         Deal Sub-type
     C                   KFLD                    CLAS11
      * Check for duplicate primary key
     C     KLCRSB        SETLL     FDDTSTL0                               90    *
     C     *IN90         IFEQ      '1'
     C     CDL038        IFNE      'Y'
     C                   MOVEL     'USR0044'     W0RTN             7
      * Send message 'Deal Sub-types         EX'
     C                   MOVEL     'USR0044'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVEL     'USR9011'     W0RTN             7
      * Send message 'Deal type/subtype/class exists'                                       BUG10769
     C                   MOVEL     'USR9011'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   ENDIF
     C                   GOTO      SBEXIT
     C                   END
      *
     C                   WRITE     UPDFDT                               91      *
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *                                                                                     BUG10769
      ** Save the Global Product and Instrument Codes to the Cross-                         BUG10769
      ** Reference Files if CGP001 is enabled.                                              BUG10769
      *                                                                                     BUG10769
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPXU
     C                   ENDIF
      *                                                                                       CSD031
      ** Send details to data queue                                                           CSD031
      *                                                                                       CSD031
     C     CSD039        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C                   EXSR      SRSEND
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
      * USER: Processing after Data update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
      *
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      *================================================================
      /EJECT
     CSR   SDDLRC        BEGSR
      *================================================================
      * Delete Deal Sub/Ty(FR) - Deal Sub-types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before Data update
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y2U0004'     W0RTN                          *Return code
     C                   GOTO      SDEXIT                                       *QUIT
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * Start of SAR S01117
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,FDH00078
     C                   MOVEL     DTSTDS        DATA
     C                   CALL      'WN0010'
     C                   PARM      ##PGM         UPGM             10            Program
     C                   PARM      *BLANK        UFKEY             2            Function Key
     C                   PARM      'D'           UACTCD            1            Action  S01212
     C                   PARM                    DATA                           Trans Data
     C                   PARM      *BLANK        W0RTN                          Return Code
     C                   PARM                    SPARE           256            Spare Field
      * End of SAR S01117
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SDEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SDEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SDEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Move key fields to FDDTSTL0
     C                   MOVEL     #1DTPE        DTPE11                         Deal type
     C                   MOVEL     #1DSTC        DLST11                         Deal Sub-type
      *                                                                                       CER001
     C     CDL038        IFEQ      'Y'
     C                   MOVEL     #1DCLA        CLAS11
     C                   ELSE
     C                   MOVEL     *BLANKS       CLAS11
     C                   ENDIF
      *
     C     KLDLSD        KLIST
     C                   KFLD                    DTPE11                         Deal type
     C                   KFLD                    DLST11                         Deal Sub-type
     C                   KFLD                    CLAS11
     C     KLDLSD        CHAIN     FDDTSTL0                           9091      *
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C     KLDLSD        SETLL     FDDTSTL0                           9091      *
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C                   DELETE    UPDFDT                               91      *
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *                                                                                     BUG10769
      ** Enforce referential integrity if CGP001 is enabled.                                BUG10769
      *                                                                                     BUG10769
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPXD
     C                   ENDIF
      *                                                                                       CSD031
      ** Send details to data queue                                                           CSD031
      *                                                                                       CSD031
     C     CSD039        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C                   MOVE      'D'           TYLC11
     C                   EXSR      SRSEND
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
      * DBF delete successful
      * USER: Processing after Data update
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     1             WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
      *
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      *================================================================
      /EJECT
     CSR   SFCHRC        BEGSR
      *================================================================
      * Change Deal Sub/Ty(Fr) - Deal Sub-types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @ASRECN
     C                   MOVEL     #1DTPE        DTPE11                         Deal type
     C                   MOVEL     #1DSTC        DLST11                         Deal Sub-type
      *                                                                                       CER001
     C     CDL038        IFEQ      'Y'
     C                   MOVEL     #1DCLA        CLAS11
     C                   ELSE
     C                   MOVEL     *BLANKS       CLAS11
     C                   ENDIF
      *
      *
     C     KLCHSF        KLIST
     C                   KFLD                    DTPE11                         Deal type
     C                   KFLD                    DLST11                         Deal Sub-type
     C                   KFLD                    CLAS11
      *                                                                                       CSD031
      ** If CSD039 is OFF                                                                     CSD031
      *                                                                                       CSD031
     C     CSD039        IFEQ      'N'
      *                                                                                       CSD031
      ** Or if CSD039 is ON and not for Acceptance                                            CSD031
      *                                                                                       CSD031
     C     CSD039        OREQ      'Y'
     C     P1ACCP        ANDEQ     'C'
      *                                                                                       CSD031
     C     KLCHSF        CHAIN     FDDTSTL0                           9091      *
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
      ** If CSD039 is ON and while for Acceptance                                             CSD031
      *                                                                                       CSD031
     C     CSD039        IFEQ      'Y'
     C     P1ACCP        ANDEQ     'A'
     C     KRTV          CHAIN     SDADTSL0                           9091
     C                   ENDIF
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SFEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C     KLCHSF        SETLL     FDDTSTL0                           9091      *
     C                   GOTO      SFEXIT
     C                   END                                                    FI #1DBRC
      * Move non-key fields to @ASRECN
     C                   Z-ADD     WURDNB        LCD11                          Last Change Dat
     C                   MOVEL     'A'           TYLC11                         Type of Last Ch
     C                   MOVEL     #1NARR        NARR11                         Description
     C                   MOVEL     #1INNR        INNR                           Instrument
     C                   MOVEL     #1FBRT        FDFBRT                         Fix Base Rate
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
      *                                                                                       CSD031
     C     CSD039        IFEQ      'Y'
     C                   MOVE      #1ACZN        AACC11
     C                   MOVE      ZDAYNO        EACC11
     C                   ELSE
     C                   Z-ADD     0             EACC11
     C                   ENDIF
     C     CER047        IFEQ      'Y'
     C                   MOVEL     #1K24C        FSK24C
     C                   ENDIF
      *
      * USER: Processing before Data update
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * Start of SAR S01117
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,FDH00079
     C                   MOVEL     DTSTDS        DATA
     C                   CALL      'WN0010'
     C                   PARM      ##PGM         UPGM             10            Program
     C                   PARM      *BLANK        UFKEY             2            Function Key
     C                   PARM      P2ANCD        UACTCD            1            Action  S01212
     C                   PARM                    DATA                           Trans Data
     C                   PARM      *BLANK        W0RTN                          Return Code
     C                   PARM                    SPARE           256            Spare Field
      * End of SAR S01117
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C*
     C                   END                                                    *FI
     C                   UPDATE    UPDFDT                               91      *
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *                                                                                     BUG10769
      ** Save the Global Product and Instrument Codes to the Cross-                         BUG10769
      ** Reference Files if CGP001 is enabled.                                              BUG10769
      *                                                                                     BUG10769
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPXU
     C                   ENDIF
      *                                                                                       CSD031
      ** Send details to data queue                                                           CSD031
      *                                                                                       CSD031
     C     CSD039        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C                   EXSR      SRSEND
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
      *
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   SHRVGN        BEGSR
      *================================================================
      * get practically everythin - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSH         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSSH         CHAIN     @BGREC8                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0096'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     'SDMMODPD'    ZA0007                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      SHEXIT                                       *QUIT
     C                   GOTO      SHEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     BGSDGL        WUSDGL                         Standing data/G
     C                   MOVEL     BGDLFX        WUDLFX                         Dealing: FX
     C                   MOVEL     BGSYLN        WUSYLN                         Syndicated Loan
     C                   MOVEL     BGEXMG        WUEXMG                         Exposure Manage
     C                   MOVEL     BGCSLN        WUCSLN                         Customer Lendin
     C                   MOVEL     BGRTBN        WURTBN                         Retail Banking
     C                   MOVEL     BGMSDL        WUMSDL                         Midas/Swift dir
     C                   MOVEL     BGSECS        WUSECS                         Securities
     C                   MOVEL     BGAURC        WUAURC                         Auto-reconcilia
     C                   MOVEL     BGFDTR        WUFDTR                         Funds Transfer
     C                   MOVEL     BGFUOP        WUFUOP                         Futures & Optio
     C                   MOVEL     BGNWMI        WUNWMI                         Message Managem
     C                   MOVEL     BGFIIN        WUFIIN                         FRA/IRS Indicat
     C                   MOVEL     BGDLMM        WUDLMM                         Dealing: MM
     C                   MOVEL     BGTRMG        WUTRMG                         Treasury Manage
     C                   MOVEL     BGRKMG        WURKMG                         Risk Management
     C                   MOVEL     BGMFIC        WUMFIC                         Microfiche
     C                   MOVEL     BGIOAC        WUIOAC                         Interest on acc
     C                   MOVEL     BGCFMT        WUCFMT                         Confirmation Ma
     C                   MOVEL     BGRCFI        WURCFI                         Report Control
     C                   MOVEL     BGOPDK        WUOPDK                         Optical Disk
     C                   MOVEL     BGNUST        WUNUST                         History & Audit
     C                   MOVEL     BGNZST        WUNZST                         Eureka Data Imp
     C                   MOVEL     BGN2ST        WUN2ST                         Midas Plato
     C                   MOVEL     BGN4ST        WUN4ST                         Midas Plato
     C                   MOVEL     BGPFMG        WUPFMG                         Portfolio Management
      *================================================================
     CSR   SHEXIT        ENDSR
      /EJECT
     CSR   SIRVGN        BEGSR
      *================================================================
      * Get 'Window required' ind - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSI         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSSI         CHAIN     @BGREC8                            90        *
      * Data record not found
     C   90              MOVEL     'USR0096'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
      * CASE: DB1.Window processing requir. is Yes
     C     BGWDPR        IFEQ      'Y'                                          *IF
     C                   MOVEL     'Y'           WUWDPR                         Window processi
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SIEXIT        ENDSR
      /EJECT
     CSR   Y0SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y0EXIT        ENDSR
      /EJECT
     CSR   Y1SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y1EXIT        ENDSR
      /EJECT
     CSR   Y8TST         BEGSR
      *================================================================
      * Test cursor
      *================================================================
     C     @#DFMT        IFEQ      '#RCDKEY'
      * KEY Screen
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
     C                   END
     C     @#DFMT        IFEQ      '#RCDDTL1'
      * DETAIL Screen
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
     C                   END
      *================================================================
     CSR   Y8EXIT        ENDSR
      /EJECT
     CSR   Y9CLR         BEGSR
      *================================================================
      * Clear *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y9EXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text
      *================================================================
      * Signal help request
     C                   MOVEL     'Y'           W0HLP             1
      *
      * Extract cursor row and column
     C     @#RWCL        DIV       256           ZHCSRW            5 0          Row
     C                   MVR                     ZHCSCL            5 0          Column
      *
      * Save cursor position for redisplay
     C                   Z-ADD     ZHCSRW        ZZCSRW            3 0          Row
     C                   Z-ADD     ZHCSCL        ZZCSCL            3 0          Column
      *
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Help text sourc
     C                   PARM      *BLANK        YYHPFL           10            Help text file
     C                   PARM      *BLANK        YYHPLB           10            Help text libra
     C                   PARM                    W0RTN             7
     C                   PARM      '*START'      YYHLVN           10            Help label
     C                   PARM      '*NORMAL'     YYUSOP           10            Options
     C                   PARM      ZHCSRW        YYRW              5 0          Row
     C                   PARM      ZHCSCL        YYCL              5 0          Column
     C                   PARM      1             YYLGCT            5 0          # of grps
     C                   PARM      W0GRP         YYLGVN           10            Label grps
      *
      * Clear set cursor DDS indicator
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94        *
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel and exit from key screen
      *================================================================
      * USER: Exit program processing
      * CASE: KEY.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * End of 059331
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * ROLLBACK any uncommitted DBF changes
     C                   ROLBK                                          90
      *                                                                                     BUG10769
     C     CGP001        IFEQ      'Y'
     C                   CLOSE     GPPRDXL0
     C                   CLOSE     GPINSXL0
     C                   ENDIF
      *
      * Terminate program
     C                   SETON                                        LR
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
      *****************************************************************                     BUG10769
      *                                                               *                     BUG10769
      *  SRVGPC - Validates the Global Product Code.                  *                     BUG10769
      *                                                               *                     BUG10769
      *****************************************************************                     BUG10769
     C     SRVGPC        BEGSR
      *                                                                                     BUG10769
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSGF
      *                                                                                     BUG10769
      ** Product Code must be entered.                                                      BUG10769
      *                                                                                     BUG10769
     C     #1PRDC        IFNE      *BLANKS
      *                                                                                     BUG10769
     C                   CALL      'AOGPRDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1PRDC        PGPRD            10
     C     GPPROD        PARM      GPPROD        DSFDY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      PGPRD         #1PRDC
     C                   ELSE
      *                                                                                     BUG10769
     C                   SELECT
     C     PRTCD         WHENEQ    '*NOSEL '
     C                   MOVE      'GPM0004'     ZAMSID
      *                                                                                     BUG10769
      ** Invalid Product Code.                                                              BUG10769
      *                                                                                     BUG10769
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
      *                                                                                     BUG10769
     C                   ENDIF
      *                                                                                     BUG10769
     C                   ENDIF
      *                                                                                     BUG10769
     C     ZAMSID        IFNE      *BLANKS
     C                   MOVE      *ON           *IN38
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                     BUG10769
     C                   ENDSR
      *****************************************************************                     BUG10769
      /EJECT                                                                                BUG10769
      *****************************************************************                     BUG10769
      *                                                               *                     BUG10769
      *  SRVGIC - Validates the Global Instrument Code.               *                     BUG10769
      *                                                               *                     BUG10769
      *****************************************************************                     BUG10769
     C     SRVGIC        BEGSR
      *                                                                                     BUG10769
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSGF
      *                                                                                     BUG10769
      ** Instrument Code must be entered.                                                   BUG10769
      *                                                                                     BUG10769
     C     #1INSC        IFEQ      *BLANKS
     C     CGP003        IFEQ      'Y'
      *                                                                                       CSD031
     C     CSD039        IFEQ      'N'
      *                                                                                       CSD031
     C     CSD039        OREQ      'Y'
     C     *INU1         ANDEQ     *ON
      *                                                                                       CSD031
     C                   MOVE      'GPM0006'     ZAMSID
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
     C                   ELSE
      *                                                                                     BUG10769
      ** Store instrument code to e temporary variable                                      BUG11448
     C                   MOVEL     #1INSC        W0INSC           10
      *                                                                                     BUG11448
     C                   CALL      'AOGINSR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1INSC        PGINS            10
     C     GPINST        PARM      GPINST        DSFDY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      PGINS         #1INSC
     C                   ELSE
      *                                                                                     BUG10769
     C                   SELECT
     C     PRTCD         WHENEQ    '*NOSEL '
     C                   MOVE      'GPM0006'     ZAMSID
      *                                                                                     BUG10769
      ** Invalid Instrument Code.                                                           BUG10769
      *                                                                                     BUG10769
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
      *                                                                                     BUG10769
     C                   ENDIF
      *                                                                                     BUG10769
     C                   ENDIF
      *                                                                                     BUG10769
     C     ZAMSID        IFNE      *BLANKS
     C                   MOVE      *ON           *IN39
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                     BUG10769
     C                   ENDSR
      *****************************************************************                     BUG10769
      /EJECT                                                                                BUG10769
      *****************************************************************                     BUG10769
      *                                                               *                     BUG10769
      *  SRGPPI - Gets the Global Product and Instrument Codes.       *                     BUG10769
      *                                                               *                     BUG10769
      *****************************************************************                     BUG10769
     C     SRGPPI        BEGSR
      *                                                                                     BUG10769
     C                   MOVE      *BLANKS       #1PRDC
     C                   MOVE      *BLANKS       #1INSC
      *                                                                                     BUG10769
     C                   MOVE      WZONE         KZONE
     C                   MOVE      'DL'          KMOD
     C                   MOVEL     DTPE11        KTRTP
     C                   MOVEL     DLST11        KTRST
      *                                                                                     BUG10769
     C********** KGPXR     CHAINGPPRDXL0            N43                            BUG10769 BUG24223
     C     KGPXR         CHAIN(N)  GPPRDXL0                           90
      *                                                                                     BUG10769
     C********** *IN43     IFEQ *OFF                                               BUG10769 BUG24223
     C     *IN90         IFEQ      *OFF
     C                   MOVE      PDGPRD        #1PRDC
     C                   ENDIF
      *                                                                                     BUG10769
     C********** KGPXR     CHAINGPINSXL0            N43                            BUG10769 BUG24223
     C     KGPXR         CHAIN(N)  GPINSXL0                           90
      *                                                                                     BUG10769
     C********** *IN43     IFEQ *OFF                                               BUG10769 BUG24223
     C     *IN90         IFEQ      *OFF
     C                   MOVE      INGINS        #1INSC
     C                   ENDIF
      *                                                                                     BUG10769
     C                   ENDSR
      *****************************************************************                     BUG10769
      /EJECT                                                                                BUG10769
      *****************************************************************                     BUG10769
      *                                                               *                     BUG10769
      *  SRGPOF - Opens the Global Processing Cross-Reference Files.  *                     BUG10769
      *                                                               *                     BUG10769
      *****************************************************************                     BUG10769
     C     SRGPOF        BEGSR
      *                                                                                     BUG10769
     C                   Z-ADD     80            PLEN             15 5
      *                                                                                     BUG10769
     C                   DO        2             WIDX              1 0
      *                                                                                     BUG10769
     C                   MOVE      OVRC(WIDX)    PCMD             80
      *                                                                                     BUG10769
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD
     C                   PARM                    PLEN
      *                                                                                     BUG10769
     C                   ENDDO
      *                                                                                     BUG10769
     C                   OPEN      GPPRDXL0
     C                   OPEN      GPINSXL0
      *                                                                                     BUG10769
     C                   ENDSR
      *****************************************************************                     BUG10769
      /EJECT                                                                                BUG10769
      *****************************************************************                     BUG10769
      *                                                               *                     BUG10769
      *  SRGPGZ - Gets the Zone via GOGETZONE.                        *                     BUG10769
      *                                                               *                     BUG10769
      *****************************************************************                     BUG10769
     C     SRGPGZ        BEGSR
      *                                                                                     BUG10769
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
      *                                                                                     BUG10769
     C     PZRTCD        IFEQ      *BLANKS
     C                   MOVE      PZZONE        WZONE            10
     C                   ELSE
      *                                                                                     BUG10769
     C     PZRTCD        IFEQ      '*ERROR'
     C                   MOVEL     GOMSG         PZERMS
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                     BUG10769
     C                   ENDIF
      *                                                                                     BUG10769
     C                   ENDSR
      *****************************************************************                     BUG10769
      /EJECT                                                                                BUG10769
      *****************************************************************                     BUG10769
      *                                                               *                     BUG10769
      *  SRGPXU - Writes and updates records on the Global            *                     BUG10769
      *           Processing Cross-Reference Files.                   *                     BUG10769
      *                                                               *                     BUG10769
      *****************************************************************                     BUG10769
     C     SRGPXU        BEGSR
      *                                                                                     BUG10769
     C                   MOVE      WZONE         KZONE
     C                   MOVE      'DL'          KMOD
     C                   MOVEL     DTPE11        KTRTP
     C                   MOVEL     DLST11        KTRST
      *                                                                                     BUG10769
     C     KGPXR         CHAIN     GPPRDXL0                           43
      *                                                                                     BUG10769
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
      *                                                                                     BUG10769
     C     KGPXR         CHAIN     GPINSXL0                           43
      *                                                                                     BUG10769
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
      *                                                                                     BUG10769
     C                   ENDSR
      *****************************************************************                     BUG10769
      /EJECT                                                                                BUG10769
      *****************************************************************                     BUG10769
      *                                                               *                     BUG10769
      *  SRGPXD - Deletes records on the Global Processing Cross-     *                     BUG10769
      *           Reference Files.                                    *                     BUG10769
      *                                                               *                     BUG10769
      *****************************************************************                     BUG10769
     C     SRGPXD        BEGSR
      *                                                                                     BUG10769
     C                   MOVE      WZONE         KZONE
     C                   MOVE      'DL'          KMOD
     C                   MOVEL     DTPE11        KTRTP
     C                   MOVEL     DLST11        KTRST
      *                                                                                     BUG10769
     C     KGPXR         CHAIN     GPPRDXL0                           43
      *                                                                                     BUG10769
     C     *IN43         IFEQ      *OFF
     C                   DELETE    GPPRDXD0
     C                   ENDIF
      *                                                                                     BUG10769
     C     KGPXR         CHAIN     GPINSXL0                           43
      *                                                                                     BUG10769
     C     *IN43         IFEQ      *OFF
     C                   DELETE    GPINSXD0
     C                   ENDIF
      *                                                                                     BUG10769
     C                   ENDSR
      *****************************************************************                     BUG10769
      /EJECT
      *****************************************************************
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      *                                                                                     BUG10769
      ** Define LDA                                                                         BUG10769
      *                                                                                     BUG10769
     C     *DTAARA       DEFINE                  LDA
      *                                                                                     BUG10769
      ** Global Processing X-Reference Key List                                             BUG10769
      *                                                                                     BUG10769
     C     KGPXR         KLIST
     C                   KFLD                    KZONE            10
     C                   KFLD                    KMOD              2
     C                   KFLD                    KTRTP             5
     C                   KFLD                    KTRST             5
      *                                                                                     BUG10769
      * Define work field S01212
     C                   MOVEL     *BLANK        WUMFTS            1
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define work field If value in key field
     C                   MOVEL     *BLANK        WUIVKF            1
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Window processing requir.
     C                   MOVEL     *BLANK        WUWDPR            1
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field Type of Last Change
     C                   MOVEL     *BLANK        WUTYLC            1
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Define work field Standing data/Gen.Ledger
     C                   MOVEL     *BLANK        WUSDGL            1
      * Define work field Dealing: FX
     C                   MOVEL     *BLANK        WUDLFX            1
      * Define work field Syndicated Loans (REDUN)
     C                   MOVEL     *BLANK        WUSYLN            1
      * Define work field Exposure Management
     C                   MOVEL     *BLANK        WUEXMG            1
      * Define work field Customer Lending
     C                   MOVEL     *BLANK        WUCSLN            1
      * Define work field Retail Banking
     C                   MOVEL     *BLANK        WURTBN            1
      * Define work field Midas/Swift direct link
     C                   MOVEL     *BLANK        WUMSDL            1
      * Define work field Securities
     C                   MOVEL     *BLANK        WUSECS            1
      * Define work field Auto-reconciliations
     C                   MOVEL     *BLANK        WUAURC            1
      * Define work field Funds Transfer
     C                   MOVEL     *BLANK        WUFDTR            1
      * Define work field Futures & Options
     C                   MOVEL     *BLANK        WUFUOP            1
      * Define work field Message Management
     C                   MOVEL     *BLANK        WUNWMI            1
      * Define work field FRA/IRS Indicator
     C                   MOVEL     *BLANK        WUFIIN            1
      * Define work field Dealing: MM
     C                   MOVEL     *BLANK        WUDLMM            1
      * Define work field Treasury Management
     C                   MOVEL     *BLANK        WUTRMG            1
      * Define work field Risk Management
     C                   MOVEL     *BLANK        WURKMG            1
      * Define work field Microfiche
     C                   MOVEL     *BLANK        WUMFIC            1
      * Define work field Interest on accounts
     C                   MOVEL     *BLANK        WUIOAC            1
      * Define work field Confirmation Matching
     C                   MOVEL     *BLANK        WUCFMT            1
      * Define work field Report Control Facility
     C                   MOVEL     *BLANK        WURCFI            1
      * Define work field Optical Disk
     C                   MOVEL     *BLANK        WUOPDK            1
      * Define work field History & Audit Facility
     C                   MOVEL     *BLANK        WUNUST            1
      * Define work field Eureka Data Import Appln
     C                   MOVEL     *BLANK        WUNZST            1
      ** Define work field Midas Plato                                                      BUG10769
     C                   MOVEL     *BLANK        WUN2ST            1
      ** Define work field Private Banking                                                  BUG10769
     C                   MOVEL     *BLANK        WUN4ST            1
      ** Define work field Portfolio Management                                             MD056747
     C                   MOVEL     *BLANK        WUPFMG            1
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      * Open files
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
      * Define *Synon program work fields
     C                   MOVEL     *BLANKS       W0CFL            10            *Cursor field
     C                   Z-ADD     *ZEROS        W0CRW             5 0          *Cursor row
     C                   Z-ADD     *ZEROS        W0CCL             5 0          *Cursor column
      * Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10            Main file name
     C                   MOVE      @1FLB         ZZFLB            10            Main file lib
     C                   MOVE      @1FMB         ZZFMB            10            Main file mbr
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            LIBRARY/FILE
     C                   OPEN      FD0652R#
     C**********           OPEN FDDTSTL1                                                      CSD031
     C                   OPEN      SDMMODL1
     C                   OPEN      FDDTSTL0
     C                   MOVEL     'N'           W0PMT             1
     C                   MOVEL     'CHG'         W0PMD             3
     C                   MOVEL     *BLANK        W0GRP             1
      *
      * USER: Initialize program
      * Copyright Statement - Standard Functions  * copyright
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT                         RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
     C*
     C                   EXSR      SHRVGN
      *
      **  Access SDPORTPD for default Instrument Type
     C     BGPFMG        IFEQ      'Y'
     C**********           MOVE *ON       *IN68                                    BUG10769 MD056747
     C                   CALL      'AOPORTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDPORTPD'    DBFILE           10             *************
     C                   MOVEL     '01'          DBASE             3             *DBERROR 001*
     C                   MOVEL     @OPTN         DBOPTN            7             *************
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check for switchable feature CSD039                                                  CSD031
      *                                                                                       CSD031
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD039'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSD031
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CSD039  '    DBKEY
     C                   MOVEL     '10'          DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSD031
     C                   MOVE      *OFF          *IN51
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN52
     C                   MOVE      *OFF          *IN53
     C                   MOVE      *OFF          *IN54
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD039            1
     C                   MOVE      *ON           *IN51
     C                   ELSE
     C                   MOVE      'N'           CSD039
     C                   ENDIF
     C/COPY WNCPYSRC,FDH00018
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'
     C                   MOVEA     AENA(1)       ##CTX1
     C                   END
     C*
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'
     C                   MOVEA     AENA(2)       ##CTX1
     C                   END
     C*
     C*  If Action Code is Amend :
     C*
     C     P2ANCD        IFEQ      'A'
     C     P2ANCD        OREQ      'E'
     C     CSD039        IFEQ      'Y'
     C     P2ANCD        IFEQ      'A'
     C                   MOVEA     AENA(4)       ##CTX1
     C                   ELSE
     C                   MOVEA     AENA(3)       ##CTX1
     C                   ENDIF
     C                   ELSE
     C                   MOVEA     AENA(3)       ##CTX1
     C                   ENDIF
     C                   END
     C*
     C                   MOVEL     'Y'           WUMFTS                         S01212
     C     CSD039        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C                   MOVEL     'N'           WUMFTS
     C                   ENDIF
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * Get 'Window required' ind - MIDAS Modules  *
     C                   EXSR      SIRVGN
      * Data Structure for Deal - Deal Sub-types  *
     C                   END                                                    *FI
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
     C                   MOVEL     'ADD'         W0PMD                          *Program mode
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'CHG'         W0PMD                          *Program mode
     C                   END                                                    *FI
      *                                                                                       CER001
      ** Check for switchable feature                                                         CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       PRTCD             7
     C                   MOVE      *BLANKS       POPTN             7
     C                   MOVE      *BLANKS       PSARD             6
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CDL038'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CER001
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL038            1
     C                   MOVE      *ON           *IN37
     C                   ELSE
     C                   MOVE      'N'           CDL038
     C                   MOVE      *OFF          *IN37
     C                   ENDIF
      *                                                                                       CER001
      *                                                                                     BUG10153
      ** Check for switchable feature                                                       BUG10153
      *                                                                                     BUG10153
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CDL006'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG10153
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL006            1
     C                   ELSE
     C                   MOVE      'N'           CDL006
     C                   ENDIF
      *                                                                                     BUG10153
      ** Check for switchable feature                                                       BUG10153
      *                                                                                     BUG10153
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CDL033'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG10153
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL033            1
     C                   ELSE
     C                   MOVE      'N'           CDL033
     C                   ENDIF
      *                                                                                     BUG10153
      ** Check for switchable feature                                                       BUG10153
      *                                                                                     BUG10153
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT006'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG10153
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CFT006            1
     C                   ELSE
     C                   MOVE      'N'           CFT006
     C                   ENDIF
      *                                                                                     BUG10153
      ** Check for switchable feature                                                       BUG10153
      *                                                                                     BUG10153
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT008'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG10153
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CFT008            1
     C                   ELSE
     C                   MOVE      'N'           CFT008
     C                   ENDIF
      *                                                                                     BUG10153
      ** Check for switchable feature                                                       BUG10153
      *                                                                                     BUG10153
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CRE008'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG10153
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CRE008            1
     C                   ELSE
     C                   MOVE      'N'           CRE008
     C                   ENDIF
      *                                                                                     BUG10769
      ** Midas Plato is installed                                                           BUG10769
      *                                                                                     BUG10769
     C     WUN2ST        IFEQ      'Y'
     C                   MOVE      *ON           *IN60
     C                   ELSE
     C                   MOVE      *OFF          *IN60
     C                   ENDIF
      *                                                                                     BUG10769
      ***Private*Banking*is*installed**********************************            BUG10769 MD056747
      *****************************************************************            BUG10769 MD056747
     C********** WUN4ST    IFEQ 'Y'                                                BUG10769 MD056747
     C**********           MOVE *ON       *IN68                                    BUG10769 MD056747
     C**********           ELSE                                                    BUG10769 MD056747
     C**********           MOVE *OFF      *IN68                                    BUG10769 MD056747
     C**********           ENDIF                                                   BUG10769 MD056747
      *                                                                                     BUG10769
      ** Check for switchable feature                                                       BUG10769
      *                                                                                     BUG10769
     C                   MOVE      *OFF          *IN61
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGP001'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGP001            1
     C                   MOVE      *ON           *IN61
      *                                                                                     BUG10769
      ** Open the Global Processing Files.                                                  BUG10769
      *                                                                                     BUG10769
     C                   EXSR      SRGPOF
      *                                                                                     BUG10769
      ** Get the Zone.                                                                      BUG10769
      *                                                                                     BUG10769
     C                   EXSR      SRGPGZ
     C                   ELSE
     C                   MOVE      'N'           CGP001
     C                   ENDIF
      *                                                                                     BUG10769
      ** Check for switchable feature                                                       BUG10769
      *                                                                                     BUG10769
     C                   MOVE      *OFF          *IN62
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CDL019'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL019            1
     C                   MOVE      *ON           *IN62
     C                   ELSE
     C                   MOVE      'N'           CDL019
     C                   ENDIF
      *                                                                                     BUG10769
      ** Check for switchable feature                                                       BUG10769
      *                                                                                     BUG10769
     C                   MOVE      *OFF          *IN64
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAS001'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS001            1
     C                   MOVE      *ON           *IN64
     C                   ELSE
     C                   MOVE      'N'           CAS001
     C                   ENDIF
     C/COPY WNCPYSRC,FDH00062
      *                                                                                     BUG10769
      ** Check for switchable feature                                                       BUG10769
      *                                                                                     BUG10769
     C                   MOVE      *OFF          *IN65
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAS009'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS009            1
     C                   MOVE      *ON           *IN65
      *                                                                                     BUG10769
     C                   MOVE      '      '      KSARN             6
     C     '   '         CAT       '      '      KPNAM            10
      *                                                                                     BUG10769
     C     KSARP         KLIST
     C                   KFLD                    KSARN
     C                   KFLD                    KPNAM
      *                                                                                     BUG10769
     C                   MOVEL     'CAS009'      KSARN
     C     'DLC'         CAT       '000020'      KPNAM
      *                                                                                     BUG10769
     C*****KSARP         CHAIN     @SARPL1                            70                    MD056555
     C/EXEC SQL                                                                             MD056555
     C+ SELECT *                                                                            MD056555
     C+ into :SCSARP                                                                        MD056555
     C+ from SCSRPJW0                                                                       MD056555
     C+ where AKSARN = :KSARN and AKPNAM = :KPNAM                                           MD056555
     C/END-EXEC                                                                             MD056555
      *                                                                                     BUG10769
     C******IN70         IFEQ      *ON                                                      MD056555
     C                   IF        SQLCODE = 100                                            MD056555
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARPPD'    DBFILE
     C                   MOVEL     '03'          DBASE
     C                   MOVEL     'CAS009'      DBKEY            10
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                     BUG10769
      ** Check if Initialisation Program for CAS009 Fee Codes has run                       BUG10769
      *                                                                                     BUG10769
     C     AKPRVC        IFEQ      'Y'
      *                                                                                     BUG10769
      ** Set CAS009 Initialised Flag to Yes                                                 BUG10769
      *                                                                                     BUG10769
     C                   MOVE      'Y'           WCAS9I            1
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           CAS009
     C                   ENDIF
      *                                                                                     BUG10769
     C     KDTST#        KLIST
     C                   KFLD                    #1DTPE
     C                   KFLD                    #1DSTC
      *                                                                                     BUG10769
      ** Check for switchable feature                                                       BUG10769
      *                                                                                     BUG10769
     C                   MOVE      *OFF          *IN66
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAS005'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS005            1
     C                   MOVE      *ON           *IN66
     C                   ELSE
     C                   MOVE      'N'           CAS005
     C                   ENDIF
      *                                                                                     BUG10769
      ** Check for switchable feature                                                       BUG10769
      *                                                                                     BUG10769
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAS008'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS008            1
     C                   ELSE
     C                   MOVE      'N'           CAS008
     C                   ENDIF
      *                                                                                     BUG10769
      ** Check for switchable feature                                                       BUG10769
      *                                                                                     BUG10769
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CIR003'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CIR003            1
     C                   ELSE
     C                   MOVE      'N'           CIR003
     C                   ENDIF
      *                                                                                     BUG10769
     C     CAS008        IFEQ      'Y'
     C     CIR003        ANDEQ     'Y'
     C                   MOVE      *ON           *IN67
     C                   ELSE
     C                   MOVE      *OFF          *IN67
     C                   ENDIF
      *                                                                                     BUG10769
      ** Check for switchable feature                                                       BUG10769
      *                                                                                     BUG10769
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL014'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL014            1
     C                   ELSE
     C                   MOVE      'N'           CGL014
     C                   ENDIF
      *                                                                                     BUG10769
      ** Check for switchable feature                                                       BUG10769
      *                                                                                     BUG10769
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE025'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE025            1
     C                   ELSE
     C                   MOVE      'N'           CLE025
     C                   ENDIF
      *                                                                                     BUG10769
     C********** CGL014    IFEQ 'Y'                                                BUG10769 MD056747
     C********** CLE025    OREQ 'Y'                                                BUG10769 MD056747
     C**********           MOVE *ON       *IN68                                    BUG10769 MD056747
     C**********           ELSE                                                    BUG10769 MD056747
     C**********           MOVE *OFF      *IN68                                    BUG10769 MD056747
     C**********           ENDIF                                                   BUG10769 MD056747
      *                                                                                     BUG10769
      ** Check for switchable feature                                                       BUG10769
      *                                                                                     BUG10769
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGP003'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG10769
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGP003            1
     C                   ELSE
     C                   MOVE      'N'           CGP003
     C                   ENDIF
      *                                                                                       CSD031
     C     KDTSL0        KLIST
     C                   KFLD                    K1DTPE            2
     C                   KFLD                    K1DSTC            2
     C                   KFLD                    K1DCLA            4
      *                                                                                       CSD031
      ** If CSD039 switchable feature is on                                                   CSD031
      *                                                                                       CSD031
     C     CSD039        IFEQ      'Y'
      *                                                                                       CSD031
      ** If called from Central Layer                                                         CSD031
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
      *                                                                                       CSD031
     C                   OPEN      GPDLSTL1
     C                   OPEN      GZSDBANK
     C                   READ      GZSDBANK                               90
      *                                                                                       CSD031
     C     *IN90         IFEQ      *ON
     C                   MOVEL     'GZSDBANK'    DBFILE
     C                   MOVEL     '11'          DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSD031
      ** Convert next working to required format                                              CSD031
      *                                                                                       CSD031
     C                   Z-ADD     BJDNWD        ZDAYNO
     C                   MOVEL     BJDFIN        WUDFF
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATEP        WZDNWD            6
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *                                                                                       CSD031
      **  Set Date Format indicator for later use in SR ZDATE2                                CSD031
      *                                                                                       CSD031
     C                   MOVEL     BJDFIN        WUDFF
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C                   MOVE      *BLANK        FSACAI            1
      *                                                                                     BUG24222
      ** Call AOSARDR0 to check for CER047                                                  BUG24222
      *                                                                                     BUG24222
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY '    POPTN             7
     C                   PARM      'CER047'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG24222
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                     BUG24222
     C                   MOVE      'Y'           CER047            1
     C                   MOVE      *ON           *IN77
     C                   ELSE
     C                   MOVE      'N'           CER047
     C                   MOVE      *OFF          *IN77
      *                                                                                     BUG24222
     C                   ENDIF
      *                                                                                     MD056747
      ** Display Instrument Type field if Private Banking or                                MD056747
      ** Portfolio Management module is switched on                                         MD056747
      *                                                                                     MD056747
     C                   MOVE      *OFF          *IN68
     C     WUN4ST        IFEQ      'Y'
     C     WUPFMG        OREQ      'Y'
     C                   MOVE      *ON           *IN68
     C                   ENDIF
      *                                                                                     MD056747
     C/COPY WNCPYSRC,FDH00080
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT
      *****************************************************************                       CSD031
      *                                                               *                       CSD031
      * Setup details and send message to data queue                  *                       CSD031
      *                                                               *                       CSD031
      *****************************************************************                       CSD031
      *                                                                                       CSD031
     C     SRSEND        BEGSR
      *                                                                                       CSD031
     C                   MOVEL     'GPDTSTPD'    WPFNAM
     C                   MOVEL     P1PARM        WKEYS
     C                   MOVEL     @1DBRC        WDATA
     C                   MOVEL     WDTQ          PDQMSG
     C     'SD'          CAT       'ACCPDTQ'     PDQNAM           10
      *                                                                                       CSD031
     C     *LOVAL        SETLL     GPZONEL0
     C                   READ      GPZONEL0                               90
     C     *IN90         DOWEQ     *OFF
     C     ZOMSYS        CAT       'DPLIB'       PDQLIB
     C     ZOMSYS        CAT       PGMB          PGMNAM           16
     C                   CALL      PGMNAM
     C                   PARM                    PDQNAM
     C                   PARM                    PDQLIB           10
     C                   PARM                    PDQMSG
     C                   READ      GPZONEL0                               90
     C                   ENDDO
      *                                                                                       CSD031
     C                   ENDSR
      /EJECT                                                                                  CSD031
      *****************************************************************                       CSD031
      *                                                               *                       CSD031
      * ZDATE1 - Format Date for Output to file                       *                       CSD031
      *                                                               *                       CSD031
      *****************************************************************                       CSD031
      *                                                                                       CSD031
     C     ZDATE1        BEGSR
      *                                                                                       CSD031
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    WUDFF
     C                   PARM                    ZDAYNO            5 0
      *                                                                                       CSD031
     C                   ENDSR
      /EJECT                                                                                  CSD031
      *****************************************************************                       CSD031
      *                                                               *                       CSD031
      * ZDATE2 - Format Date for Output (screen)                      *                       CSD031
      *                                                               *                       CSD031
      *****************************************************************                       CSD031
      *                                                                                       CSD031
     C     ZDATE2        BEGSR
      *                                                                                       CSD031
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    WUDFF
     C                   PARM                    ZDATEP            6 0
     C                   PARM                    ZADATE            7
      *                                                                                       CSD031
     C                   ENDSR
      /EJECT                                                                                  CSD031
      *****************************************************************                       CSD031
     CSR   *PSSR         BEGSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD056555
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD056555
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA AENA
F3=Main Menu   F10=Delete   F12=Previous
F3=Exit   F12=Previous
F3=Main Menu   F12=Previous
F3=Main Menu   F5=Refresh   12=Previous                                                       CSD031
**CTDATA ARGV
F3=Previous
**CTDATA OVRC
OVRDBF FILE(GPPRDXL0) TOFILE(GPPRODXL0)                                                     BUG10769
OVRDBF FILE(GPINSXL0) TOFILE(GPINSTXL0)                                                     BUG10769
**CTDATA @DL
IP                                                                                          BUG10769
TI                                                                                          BUG10769
CL                                                                                          BUG10769
DL                                                                                          BUG10769
IT                                                                                          BUG10769
TD                                                                                          BUG10769
CI                                                                                          BUG10769
CD                                                                                          BUG10769
C2                                                                                          BUG10769
BP                                                                                          BUG10769
BD                                                                                          BUG10769
TB                                                                                          BUG10769
DA                                                                                          BUG10769
TA                                                                                          BUG10769
**CTDATA CPY@
(c) Finastra International Limited 2005
