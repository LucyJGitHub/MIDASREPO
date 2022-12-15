     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*OVR *  OVRDBF FILE(GZSDBANK) TOFILE(GZSDBANKL2)                     *                       CSD031
/**** *  RPGBASE                                                      *                     MD058769
/*STD *  RPGSQLBND                                                    *                     MD058769
/*EXI *  TEXT('Midas SD Narrative codes maintenance')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0080M - Midas SD Narrative codes maintenance.              *
      *                                                               *
      *  Function:  This sub-file program allows the user to maintain *
      *             from a list of narrative codes.                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058769           Date 21Sep21               *
      *  Prev Amend No. MD039572           Date 14Jan20               *
      *                 MD054605           Date 17Oct19               *
      *                 MD049636           Date 13Mar18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD036821           Date 15Dec15               *
      *                 MD035869           Date 24Nov15               *
      *                 MD026243           Date 19Aug14               *
      *                 MD024430           Date 20Jan14               *
      *                 CRE098             Date 02Dec13               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      *                 CSC043             Date 18Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11826           Date 02Aug06               *
      *                 BUG11804           Date 29Jul06               *
      *                 BUG11803           Date 29Jul06               *
      *                 BUG11774           Date 25Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAAA03             Date 28Mar04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD003             Date 01Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01408             DATE 12DEC94               *
      *                 S01459             DATE 12DEC94               *
      *                 028995             DATE 08APR93               *
      *                 S01117             DATE 25JUL90               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058769 - Deliverable Data Split for SDNARRPD and TABLETP   *
      *  MD039572 - Failed component during COB - COMPONENT DLC0606C  *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD049636 - New Narrative codes in 1-50 interval              *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036821 - Filter in the Narrative Codes Maintenance is      *
      *             misaligned (Recompile)                            *
      *  MD035869 - Update does not push through when amending a      *
      *             narrative code transaction (Recompile)            *
      *  MD026243 - Narrative description is 6-character shorter      *
      *             (Recompile)                                       *
      *  MD024430 - Trans type does not appear when only CGL013 is ON *
      *  CRE098 - User-Defined Retail Transaction Types on Postings   *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  CSC043 - MidasPlus IASP Enablement                           *
      *  BUG11826 - Validation on Central Data amendment is wrong     *
      *  BUG11804 - Wrong validation error message appear on          *
      *             Amendment                                         *
      *  BUG11803 - Effective date is present in zonal                *
      *             input screen (Recompile)                          *
      *  BUG11774 - Error msg when trying to accept central data      *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *     CAAA03 - Webfacing Changes (recompile).                   *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  S01408 - Addition of core hooks.                             *
      *  S01459 - Addition of header box and PSSR processing.         *
      *  028995 - FOR NARRATIVE CODE 44, PROGRAM SHOULD ALLOW         *
      *           THE DESCRIPTION TO BE LEFT BLANK, BUT IF ENTERED    *
      *           IT SHOULD START IN POPSITION 1.                     *
      *  S01117 - RELEASE 10 CHANGES.                                 *
      *                                                               *
      *****************************************************************
     F*Narrative codes maintenance    Initialise Program F-Spec
     F/COPY WNCPYSRC,SD0020MFPG
     FSD0080M#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Edit narrative codes
      *
     F*SDNARRL1* IF   E           K DISK    USROPN                                          MD058769
     F**********                           INFDS(INFDS1)                                    MD058769
     F**********                           INFSR(*PSSR)                                     MD058769
      * RTV : Midas SD Narrative codes retrieval
      *
     F*SDNARRL0* UF A E           K DISK    USROPN                                          MD058769
     F**********                           COMMIT                                           MD058769
     F**********                           INFDS(ID0001)                                    MD058769
     F**********                           INFSR(*PSSR)                                     MD058769
      * UPD : Midas SD Narrative codes update
      *
     FSDFCTLL0  UF   E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0002)
     F                                     INFSR(*PSSR)
      * UPD : Midas SD Standing data controls update
      *
     FGZSDBANK  IF   E           K DISK    USROPN
     FSDANARL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FGPZONEL0  IF   E           K DISK
     FGPNARRL0  UF A E           K DISK
     F                                     RENAME(SDNARRD0:SDNARD2)
     F                                     COMMIT
     FGPNARRL1  IF   E           K DISK
     F                                     RENAME(SDNARRD0:SDNARD3)
     FACKEYL4   IF   E           K DISK                                                           MD
     FSEACKL2   IF   E           K DISK                                                           MD
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D OVRC            S             80    DIM(1) CTDATA PERRCD(1)
     D HEAD3           S             40    DIM(3) CTDATA PERRCD(1)
     D* Narrative codes maintenance    Initialise Program E-Spec
     D/COPY WNCPYSRC,SD0080MEPG
     D*COPY*ZSRSRC,ZDATE1Z1                                                          CSD031 MD058769
     D/COPY ZSRSRC,ZDATE2Z1LE                                                               MD058769
     D CONS1           C                   CONST('NarCodeStartRange')
     D CONS2           C                   CONST('NarCodeEndRange')
     D PGMA            C                   CONST('GPAOSVALR0')
     D HEAD1A          C                   CONST('Accept to')
     D HEAD1B          C                   CONST('Zone')
     D HEAD2A          C                   CONST(' Central ')
     D HEAD2B          C                   CONST('Data')
     D**********    'XLIB/SDCSNDDTQ'      C         PGMB                               CSD031 CSC043
     D PGMB            C                   CONST('XPLIB/SDCSNDDTQ')
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D*Narrative codes maintenance    Initialise Program I-Spec
     D/COPY WNCPYSRC,SD0080MIPG
      /EJECT
      * Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D*@1DBRC***     E DS                  EXTNAME(SDNARRL0)                                MD058769
     D @1DBRC        E DS                  EXTNAME(SDNARJW0)                                MD058769
     D                                     PREFIX(X)                                        MD058769
     D SDNARR        E DS                  EXTNAME(SDNARJW0)                                MD058769
      * UPD : Midas SD Narrative codes update
      * Current/previous master file format fields for change control
      *
     D DESC            DS
     D  CHECK1                 1      1
     D  CHECK6                 1      6
     D  WHOLE                  1     30
     D QSDFC1        E DS                  EXTNAME(SDFCTLL0)
      * UPD : Midas SD Standing data controls update
     D YARDCS          DS            22
     D WUDELR          DS
     D  WUDR01                 1    250
     D  WUDR02               251    500
     D  WUDR03               501    750
     D  WUDR04               751   1000
     D  WUDR05              1001   1250
     D  WUDR06              1251   1500
     D  WUDR07              1501   1750
     D  WUDR08              1751   2000
     D  WUDR09              2001   2250
     D  WUDR00              2251   2500
     D  WUDR11              2501   2750
     D  WUDR12              2751   3000
      * Outward parameters
     D PARC            DS          3064
      * RCD : Midas SD Deleted records file retrieval
      * I :  File name
     D  PAFNME                 1     10
      * I :  Long Key
     D  PALKEY                11     60
      * I :  Deleted Data Record Pt1
     D  PADR01                61    310
      * I :  Deleted Data Record Pt2
     D  PADR02               311    560
      * I :  Deleted Data Record Pt3
     D  PADR03               561    810
      * I :  Deleted Data Record Pt4
     D  PADR04               811   1060
      * I :  Deleted Data Record Pt5
     D  PADR05              1061   1310
      * I :  Deleted Data Record Pt6
     D  PADR06              1311   1560
      * I :  Deleted Data Record Pt7
     D  PADR07              1561   1810
      * I :  Deleted Data Record Pt8
     D  PADR08              1811   2060
      * I :  Deleted Data Record Pt9
     D  PADR09              2061   2310
      * I :  Deleted Data Record Pt10
     D  PADR00              2311   2560
      * I :  Deleted Data Record Pt11
     D  PADR11              2561   2810
      * I :  Deleted Data Record Pt12
     D  PADR12              2811   3060
      * I :  Last Change Date
     D  PALCD               3061   3063P 0
      * I :  Type of Last Change
     D  PATYLC              3064   3064
      *
     D YBRDCS          DS            22
     D YCRDCS          DS            36
     D YDRDCS          DS            22
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      *                                                                                       CER030
      **  External DS for RE Transaction Type Details                                         CER030
      *                                                                                       CER030
     D SDRETR        E DS                  EXTNAME(SDRETRPD)
     D*A@CPY****       DS
     D**Copyright array                                                                     MD058769
     D**CPY@****               1     80                                                     MD058769
     D**********                           DIM(1) CTDATA PERRCD(1)              Copyright arMD058769
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * DS for Access Programs, short data structure.                                         CSD031
     D DSSARD        E DS                  EXTNAME(SCSARDPD)
      * Definition: Switchable Features Accessed Via Access Program.                          CSD031
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DS for Bank details                                                                   CSD031
     D LDA           E DS           256    EXTNAME(LDA)
     D  SPAREX       E                     EXTFLD(SPARE)
      ** Local data area for database error details                                           CSD031
     D WDTQ            DS
     D  WPFNAM                 1     10
     D  WKEYS                 11     40
     D  WDATA                 41    296
     D WNARR           DS            81
     D PDQMSG          DS          4040
     D ID0001          DS           528
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
      *
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
      * Message data for 'Code must be in range'
      * Narrative Code
     D  ZA0004                 1      2
      * Message data for 'Narrative Description sho'
      * Description of Narrative
     D  ZA0005                 1     30
      * Message data for 'Narrative Description'
      * Description of Narrative
     D  ZA0006                 1     30
      * Message data for 'Codes 1-50 cannot be'
      * Narrative Code
     D  ZA0007                 1      2
      * Message data for 'Position 1 of Description'
      * Description of Narrative
     D  ZA0008                 1     30
      * Message data for 'Positions 1 - 6 of'
      * Description of Narrative
     D  ZA0009                 1     30
      * Message data for 'Positions 1 - 6 of'
      * Description of Narrative
     D  ZA0010                 1     30
      * Message data for 'Positions 1 - 6 of'
      * Description of Narrative
     D  ZA0011                 1     30
      * Message data for 'Description should begin'
      * Description of Narrative
     D  ZA0012                 1     30
      * Message data for 'Description should begin'
      * Description of Narrative
     D  ZA0013                 1     30
      * Message data for 'Description should begin'
      * Description of Narrative
     D  ZA0014                 1     30
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
      * Initialise and load subfile page
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF
      * Display screen until reload requested
     C     W0RSF         DOWEQ     'N'
      * Display screen
     C                   EXSR      CAEXFM
      * Process response
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * HOME: Request subfile reload
     C   05              CAS                     FBRQRL
      * Display next SFL page
     C   27              CAS                     BBLDSF
      * Process screen input
     C                   CAS                     DAPR##
     C                   END
      *
     C                   END
     C                   END
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise & load subfile page
      *================================================================
      * Clear subfile
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      * USER: Initialize subfile header
      * Set Up Function Key Text - Standard Functions  *
     C*****************************************************************
     C*
     C*   Set up Function Key Text for Edit Files.
     C*
     C*****************************************************************
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C     CSD044        IFEQ      'Y'
     C     *INU1         IFEQ      *OFF
     C     *IN66         IFEQ      *OFF
      *                                                                                       CSD031
     C     W0PMD         IFEQ      'CHG'
      *                                                                                       CSD031
      ** Setup footer text:                                                                   CSD031
      ** D=Delete   F3=Main Menu   F5=Refresh   F9=Go to 'Add' Mode  F11=For Acceptance       CSD031
      *                                                                                       CSD031
     C                   MOVEL     'CSD0031'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
      *                                                                                       CSD031
     C     *IN90         IFEQ      '1'
      *                                                                                       CSD031
      ** Call to program ended in error                                                       CSD031
      *                                                                                       CSD031
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
      *                                                                                       CSD031
      ** Send message '*Error occured on CALL...'                                             CSD031
      *                                                                                       CSD031
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C                   ELSE
      *                                                                                       CSD031
      ** Setup footer text:                                                                   CSD031
      ** D=Delete   X=Accept  F5=Refresh   F12=Previous                                       CSD031
      *                                                                                       CSD031
     C                   MOVEL     'CSD0032'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
      *                                                                                       CSD031
     C     *IN90         IFEQ      '1'
      * Call to program ended in error                                                        CSD031
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
      * Send message '*Error occured on CALL...'                                              CSD031
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C     W0PMD         IFEQ      'CHG'
      *                                                                                       CSD031
      ** Setup footer text:                                                                   CSD031
      ** D=Delete   F3=Main Menu   F5=Refresh   F9=Go to 'Add' Mode                           CSD031
      *                                                                                       CSD031
     C                   MOVEL     'USR3348'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
      *                                                                                       CSD031
     C     *IN90         IFEQ      '1'
      *                                                                                       CSD031
      ** Call to program ended in error                                                       CSD031
      *                                                                                       CSD031
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
      *                                                                                       CSD031
      ** Send message '*Error occured on CALL...'                                             CSD031
      *                                                                                       CSD031
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C     W0PMD         IFEQ      'CHG'
      *                                                                                       CER030
     C     CER030        IFEQ      'Y'
     C     CGL013        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
     C                   MOVE      *ON           *IN37
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C* Setup footer text:
     C* D=Delete   F3=Main Menu   F5=Refresh   F9=Go to 'Add' Mode
     C                   MOVEL     'USR3348'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C     W0PMD         IFEQ      'ADD'
     C* Setup footer text:
     C* F3=Main Menu   F5=Refresh   F9=Go to 'Change' Mode
      *                                                                                       CER030
     C     CER030        IFEQ      'Y'
     C     CGL013        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
     C                   MOVE      *OFF          *IN37
      *                                                                                       CER030
     C     *IN05         IFEQ      '1'
      *                                                                                       CER030
     C                   MOVE      *OFF          *IN36
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   MOVEL     'USR3349'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
      * Start of S01408
      * 00/Copy member SD0080MISH - Narrative Codes  *
     C*Narrative codes  maintenance    Initialise Subfile Header
     C/COPY WNCPYSRC,SD0080MISH
      * End of S01408
      *................................................................
      * If CHANGE mode, then position file:
     C     W0PMD         IFNE      'ADD'
     C     *LIKE         DEFINE    #2NVCD        WZNVCD
     C                   MOVEL     #2NVCD        WZNVCD                         Narrative Code
      *                                                                                       CER030
     C     CER030        IFEQ      'Y'
     C     CGL013        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
     C     *LIKE         DEFINE    D2RTTY        WZRTTY
     C                   MOVEL     D2RTTY        WZRTTY
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
     C     *LIKE         DEFINE    #2ATOZ        WZATOZ
     C                   MOVEL     #2ATOZ        WZATOZ
     C     *LIKE         DEFINE    #2EFDA        WZEFDA
     C                   MOVEL     #2EFDA        WZEFDA
     C                   ENDIF
      *                                                                                       CSD031
     C     KPOS          KLIST
     C                   KFLD                    ALNVCD                         Narrative Code
      * Setup key
     C                   MOVEL     #2NVCD        ALNVCD                         Narrative Code
      * 82=EOF
     C     CSD044        IFEQ      'Y'
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
      *                                                                                       CSD031
     C     KPOS          SETLL     SDNARD3                            82
     C     *IN82         IFEQ      *OFF
     C                   READ      SDNARD3                              9182
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C     *IN66         IFEQ      *ON
     C     KPOS          SETLL     SDANARL0                           82
     C     *IN82         IFEQ      *OFF
     C                   READ      SDANARL0                             9182
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
      * CSD044 is a retired feature                                                         MD058769
     C*****KPOS*         SETLL     @ALREC0                            82                    MD058769
     C     *IN82         IFEQ      *OFF
     C**********         READ      @ALREC0                              9182                MD058769
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C*****KPOS*         SETLL     @ALREC0                            82        *           MD058769
      * 82=EOF
     C**N82*****         READ      @ALREC0                              9182    *           MD058769
     C/EXEC SQL                                                                             MD058769
     C+ declare ACursor insensitive scroll cursor for                                       MD058769
     C+ select * from SDNARJW0                                                              MD058769
     C+ where ALNVCD >= :ALNVCD                                                             MD058769
     C+ order by ALNVCD                                                                     MD058769
     C/END-EXEC                                                                             MD058769
                                                                                            MD058769
     C/EXEC SQL                                                                             MD058769
     C+ close ACursor                                                                       MD058769
     C/END-EXEC                                                                             MD058769
                                                                                            MD058769
     C/EXEC SQL                                                                             MD058769
     C+ open ACursor                                                                        MD058769
     C/END-EXEC                                                                             MD058769
                                                                                            MD058769
     C/EXEC SQL                                                                             MD058769
     C+ fetch next from ACursor into :SDNARR                                                MD058769
     C/END-EXEC                                                                             MD058769
                                                                                            MD058769
     C                   setoff                                       82                    MD058769
     C                   If        SQLCODE = 100                                            MD058769
     C                   seton                                        82                    MD058769
     C                   Endif                                                              MD058769
                                                                                            MD058769
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
     C                   SETOFF                                       82        *
     C                   END
      * Load subfile page
     C                   EXSR      BBLDSF
      *................................................................
      * If no records found, display error message
     C   82##RR          IFEQ      *ZERO                                        IF
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      * Load subfile page (write empty page if add mode)
      *================================================================
     C                   SETOFF                                       84        No SFLNXTCHG
      * Re-establish fields in read-ahead record
     C   27W0PMD         IFNE      'ADD'
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
      *                                                                                       CSD031
     C     *IN82         IFEQ      *OFF
     C                   READP     SDNARD3                                90
     C                   READ      SDNARD3                                90
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C     *IN66         IFEQ      *OFF
     C     *IN82         IFEQ      *OFF
     C**********         READP     @ALREC0                                90                MD058769
     C**********         READ      @ALREC0                                90                MD058769
     C                   ENDIF
     C                   ELSE
     C     *IN82         IFEQ      *OFF
     C                   READP     SDANARL0                               90
     C                   READ      SDANARL0                               90
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C**N82*****         READP     @ALREC0                                90    *           MD058769
     C**N82*****         READ      @ALREC0                                90    *           MD058769
     C     *IN82         IFEQ      '0'                                                      MD058769
     C/EXEC SQL                                                                             MD058769
     C+ fetch prior from ACursor into :SDNARR                                               MD058769
     C/END-EXEC                                                                             MD058769
     C/EXEC SQL                                                                             MD058769
     C+ fetch next from ACursor into :SDNARR                                                MD058769
     C/END-EXEC                                                                             MD058769
     C                   ENDIF                                                              MD058769
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C                   END
      *
      * Setof record error indicators
     C                   MOVE      *ALL'0'       WKIND0            3
     C                   MOVE      *ALL'1'       WKIND1            3
      * Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
     C                   Z-ADD     *ZERO         ##RROK            5 0
      * Set required pages based on *Set Cursor or *Subfile Pages
     C     W0RR0         IFGT      0
     C     W0RR0         DIV       ##SFPG        ##SPG             3 0
     C                   MVR                     ##SLIN            3 0
     C     ##SLIN        IFGT      0
     C                   ADD       1             ##SPG
     C                   END
     C     W0SPG         IFGT      ##SPG
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
     C                   ELSE
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
      * Compute lines required based on pages
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   END
      *................................................................
      * Load next subfile page
     C**N82##RROK        DOWLT     ##SFLN                                       DO          MD058769
     C                   DOW       SQLCODE = 0                                              MD058769
     C                             and ##RROK < ##SFLN                                      MD058769
      *                                                                                       CER030
      ** Check the Selected Transaction Type With The File Field                              CER030
      *                                                                                       CER030
     C     W0PMD         IFNE      'ADD'
      *                                                                                       CER030
     C     CGL013        IFEQ      'Y'
     C     CER030        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
     C     D2RTTY        IFNE      *BLANKS
      *                                                                                       CER030
     C     ALRTTY        CABNE     D2RTTY        BB020
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   ADD       1             ##RR
     C                   MOVEA     WKIND0        *IN(32)
     C                   SETOFF                                       87        *
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
     C                   MOVE      *OFF          *IN75
     C                   MOVE      *OFF          *IN77
     C                   ENDIF
      * Clear subfile fields
     C                   EXSR      MAIZ#1
      * If CHANGE mode, load subfile fields
     C     W0PMD         IFNE      'ADD'
     C                   EXSR      MBFL#1
      * Calculate function fields
     C                   EXSR      DG#2FN
      * Record will be selected unless overridden
     C                   MOVEL     'Y'           W0RSL
      * USER: Initialize subfile record (existing record)
      * Start of S01408
      * 00/Copy member SD0080MIRE - Narrative Codes  *
     C*Narrative codes maintenance    Initialise Exist Record
     C/COPY WNCPYSRC,SD0080MIRE
      * End of S01408
     C                   MOVEL     'Y'           WUDELA                         Deletion Allowe
     C                   MOVEL     'Y'           WUAMAL                         Amend allowed
      * CASE: WRK.Set Up Complete is Yes
     C     WUSUC         IFEQ      'Y'                                          *IF
      * CASE: PGM.*Program mode is *CHANGE
     C     W0PMD         IFEQ      'CHG'                                        *IF
      **CASE:*RCD.Narrative*Code*is*between*1*&*50                                          MD049636
     C********** #1NVCD    IFGE '01'                       *IF                              MD049636
     C********** #1NVCD    ANDLE'50'                                                        MD049636
     C                   MOVEL     'N'           WUDELA                         Deletion Allowe
     C                   MOVEL     'N'           WUAMAL                         Amend allowed
     C**********           END                             *FI                              MD049636
      * 00/Copy member SD0080MC01 - Narrative Codes  *
     C/COPY WNCPYSRC,SD0080MC01
     C                   END                                                    *FI
     C                   END                                                    *FI
      * If record dropped...
     C     CSD044        IFEQ      'Y'
     C     #2ATOZ        IFNE      *BLANKS
     C     #2ATOZ        ANDNE     ALGPDT
     C     *INU1         ANDEQ     *OFF
     C                   MOVE      'N'           W0RSL
     C                   ENDIF
      *                                                                                       CSD031
     C     #2ATOZ        IFNE      *BLANKS
     C     #2ATOZ        ANDNE     ALAACC
     C     *INU1         ANDEQ     *ON
     C                   MOVE      'N'           W0RSL
     C                   ENDIF
      *                                                                                       CSD031
     C                   CALL      'ZDATE2'
     C                   PARM      ALEACC        PDATE
     C                   PARM      BJDFIN        PDTFMT
     C                   PARM      *ZEROS        PCVTDT
     C                   PARM      *BLANKS       PALPDT
     C                   MOVEL     PCVTDT        CEFDA             6
     C     #2EFDA        IFNE      *BLANKS
     C     #2EFDA        ANDNE     CEFDA
     C                   MOVE      'N'           W0RSL
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   SUB       1             ##RR
     C     W0RSL         CABNE     'Y'           BB020
     C                   ADD       1             ##RR
      * Validate subfile record and calculate derived fields
     C                   EXSR      DFV2RC
     C                   ELSE
      * USER: Initialize subfile record (new record)
      * Start of S01408
      * 00/Copy member SD0080MIRN - Narrative Codes  *
     C*Narrative codes maintenance    Init Sfile Rcd (New Rcd)
     C/COPY WNCPYSRC,SD0080MIRN
      * End of S01408
     C                   MOVEL     'Y'           WUAMAL                         Amend allowed
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     'N'           WUDELA                         Deletion Allowe
     C                   END                                                    *FI
     C                   END
      * Output to subfile
     C                   ADD       1             ##RROK               81        *
      * If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99        *
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
     C     *IN66         ANDEQ     *ON
     C                   MOVE      *ON           *IN78
     C                   ENDIF
      *                                                                                       CSD031
     C                   WRITE     #SFLRCD
     C     BB020         TAG
     C     W0PMD         IFNE      'ADD'
      * 82=EOF
     C     CSD044        IFEQ      'Y'
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C                   READ      SDNARD3                                82
     C                   ELSE
     C     *IN66         IFEQ      *ON
     C                   READ      SDANARL0                               82
     C                   ELSE
     C**********         READ      @ALREC0                                82                MD058769
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C**********         READ      @ALREC0                                82    *           MD058769
     C/EXEC SQL                                                                             MD058769
     C+ fetch next from ACursor into :SDNARR                                                MD058769
     C/END-EXEC                                                                             MD058769
     C                   ENDIF
     C                   END
     C  N82              END
     C                   SETOFF                                       82                    MD058769
     C                   IF        SQLCODE = 100                                            MD058769
     C                   SETON                                        82                    MD058769
     C                   ENDIF                                                              MD058769
      *................................................................
      * Save highest SFL record load can continue at end point
     C     ##RR          IFGT      ##RRMX
      * Calculate top line
     C     ##RROK        DIV       ##SFPG        ##SPG
     C                   MVR                     ##SLIN
     C     ##SLIN        IFGT      0
     C     ##RR          SUB       ##SLIN        ##SFRC
     C                   ELSE
     C     ##RR          SUB       ##SFPG        ##SFRC
     C                   END
     C                   ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GBDSA2
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
     C                   MOVE      *OFF          *IN75
     C                   MOVE      *OFF          *IN77
     C                   ENDIF
      * PUTOVR unless conditioned fields change
     C                   SETON                                        86
     C     *IN89         IFNE      CAIN89
     C     *IN81         ORNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN89         CAIN89            1
     C                   MOVE      *IN81         CAIN81            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
      * Maintain subfile position where possible
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
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
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      * Process screen input
      *================================================================
      *
      * CALC: Subfile control function fields
      * Start of S01408
      * 00/Copy member SD0080MSFF - Narrative Codes  *
     C*Narrative codes maintenance    Calculate Control Funct
     C/COPY WNCPYSRC,SD0080MSFF
      * End of S01408
     C     W0PMD         IFNE      'ADD'
     C     *IN11         ANDNE     *ON
     C     *IN12         ANDNE     *ON
      * Change of position specified
     C     WZNVCD        CASNE     #2NVCD        FBRQRL                         Narrative Code
     C     WZATOZ        CASNE     #2ATOZ        FBRQRL
     C     WZEFDA        CASNE     #2EFDA        FBRQRL
     C                   END
      *                                                                                       CER030
     C     CER030        IFEQ      'Y'
     C     CGL013        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
     C     WZRTTY        CASNE     D2RTTY        FBRQRL
     C                   END
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   END
      * USER: Validate subfile control
      * Start of S01408
      * 00/Copy member SD0080MVSC - Narrative Codes  *
     C*Narrative codes maintenance    Validate Control
     C/COPY WNCPYSRC,SD0080MVSC
      * End of S01408
      * Quit if reload requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
      *
     C   81              DO
      * No data entered as yet
     C                   MOVEL     'N'           WKIPIN            1
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * Process subfile records
     C                   EXSR      DBPRSF
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * If data entered
     C     WKIPIN        IFEQ      'Y'
      * Update DBF from subfile
     C                   EXSR      EAPRSF
      * If error during update, exit:
     C     *IN99         CABEQ     '1'           DAEXIT
     C                   END                                                    WKIPIN
     C                   END
      * Switch between *ADD/*CHANGE modes
     C   09              EXSR      FACHMD
      * USER: Process command keys
      * Start of S01408
      * 00/Copy member SD0080MPCK - Narrative Codes  *
     C*Narrative codes maintenance    Process Command Keys
     C/COPY WNCPYSRC,SD0080MPCK
      * End of S01408
     C     CSD044        IFEQ      'Y'
      *                                                                                       CSD031
     C                   SELECT
     C     *IN11         WHENEQ    *ON
     C                   MOVEL     *BLANKS       #2NVCD
     C                   MOVEL     *BLANKS       #2ATOZ
     C                   MOVEL     *BLANKS       WZATOZ
     C                   MOVEL     *BLANKS       #2EFDA
     C                   MOVEL     *BLANKS       WZEFDA
     C                   EXSR      SRACPT
     C     *IN12         WHENEQ    *ON
     C                   MOVE      *OFF          *IN66
     C                   MOVE      *OFF          *IN72
     C                   MOVE      *OFF          *IN78
     C                   MOVE      *ON           *IN67
     C                   MOVE      *ON           *IN70
     C                   MOVE      *ON           *IN73
     C                   MOVEL     *BLANKS       #2NVCD
     C                   MOVEL     *BLANKS       #2ATOZ
     C                   MOVEL     *BLANKS       WZATOZ
     C                   MOVEL     *BLANKS       #2EFDA
     C                   MOVEL     *BLANKS       WZEFDA
     C                   MOVEL     HEAD3(1)      #2HEA3
     C                   WRITE     #SFLCTL
     C                   EXSR      FBRQRL
     C                   ENDSL
      *                                                                                       CSD031
     C                   ENDIF
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
     C                   EXSR      DCPRSR
     C                   SETOFF                                       87        *
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record
      *================================================================
      * Set off error indicators
     C                   MOVEA     WKIND0        *IN(32)
      * No errors
     C                   SETOFF                                       98
      * No SFLNXTCHG
     C                   SETOFF                                       84
      *                                                                                     BUG11774
      * If CSD044 = 'Y' and in Zonal layer and action is not 'D' or 'X'                     BUG11774
     C     CSD044        IFEQ      'Y'
     C     *INU1         ANDEQ     *OFF
     C     #1SEL         ANDEQ     ' '
      *                                                                                       CSD031
      * Get the original desc. of record being changed                                        CSD031
     C*****#1NVCD        CHAIN     SDNARRL1                           36                    MD058769
     C     *IN36         IFEQ      *OFF
     C                   MOVEL     ALDON         WDON
     C                   ENDIF
      *                                                                                       CSD031
      *                                                                                     BUG11826
      ** Check if there are pending records in acceptances file                             BUG11826
      *                                                                                     BUG11826
     C     #1DON         IFNE      WDON
     C     KLDLSC        CHAIN(N)  SDANARL0                           9091
     C     *IN90         IFEQ      *OFF
     C                   MOVEL     'CSD0002'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN34
     C                   ELSE
      *                                                                                     BUG11826
     C********** *INU1     IFEQ *OFF                                                 CSD031 BUG11774
     C********** #1DON     ANDNEWDON                                                 CSD031 BUG11774
     C********** #1DON     IFNE WDON                                               BUG11774 BUG11826
     C********** #1ATOZ    ANDEQ'Y'                                                  CSD031 BUG11826
     C     #1ATOZ        IFEQ      'Y'
     C**********           MOVEL'CSD0037' ZAMSID                                     CSD031 BUG11804
     C**********           MOVEL'CSD0002' ZAMSID                                   BUG11804 BUG11826
     C                   MOVEL     'CSD0037'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN34
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                     BUG11774
     C     W0PMD         IFEQ      'ADD'
      * Check for null record
     C                   EXSR      DDNLRC
     C     W0NLR         IFEQ      'Y'
     C                   GOTO      DCEXIT
     C                   END
      * If not null record, continue
     C                   END
      * Data entered
     C                   MOVEL     'Y'           WKIPIN
      * SFLNXTCHG
     C                   SETON                                        84
      *                                                                                       CSD031
     C     #1SEL         IFNE      'D'
     C     #1SEL         ANDNE     *BLANKS
     C     *IN66         ANDEQ     *OFF
     C                   MOVEL     'ASM0002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN32
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
     C                   MOVE      *OFF          *IN75
     C                   MOVE      *OFF          *IN77
      *                                                                                       CSD031
     C     #1SEL         IFNE      'D'
     C     #1SEL         ANDNE     *BLANKS
     C     #1SEL         ANDNE     'X'
     C     *IN66         ANDEQ     *ON
     C                   MOVEL     'ASM0002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN32
     C                   ENDIF
      *                                                                                       CSD031
     C     #1SEL         IFEQ      'D'
     C     *INU1         ANDEQ     *OFF
     C     #1ATOZ        ANDEQ     'Y'
     C     *IN66         ANDEQ     *OFF
     C     #1NVCD        CHAIN     SDANARL0                           68
     C     *IN68         IFEQ      *OFF
     C                   MOVEL     'CSD0002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN32
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C     #1SEL         IFEQ      'D'
     C     *INU1         ANDEQ     *OFF
     C     #1ATOZ        ANDEQ     'N'
     C                   GOTO      DCEXIT
     C                   ENDIF
      *                                                                                       CSD031
     C     #1SEL         IFEQ      'D'
     C     *INU1         ANDEQ     *ON
     C     #1ATOZ        ANDEQ     'Y'
     C                   MOVEL     'CSD0007'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN33
     C                   ENDIF
      *                                                                                       CSD031
RFM  C********** #1SEL     IFEQ 'D'                                                           CSD031
RFM  C********** *INU1     ANDEQ*ON                                                           CSD031
RFM  C********** #1ATOZ    ANDEQ'N'                                                           CSD031
RFM  C********** #1EFDA    ANDNE*BLANKS                                                       CSD031
RFM  C**********           MOVE #1EFDA    ZDATE                                               CSD031
RFM  C**********           EXSR ZDATE1                                                        CSD031
      *                                                                                       CSD031
RFM  C********** ZDAYNO    IFLT BJDNWD                                                        CSD031
      *                                                                                       CSD031
RFM  C**********           CALL 'ZDATE2'                                                      CSD031
RFM  C**********           PARM BJDNWD    PDATE                                               CSD031
RFM  C**********           PARM BJDFIN    PDTFMT                                              CSD031
RFM  C**********           PARM *ZEROS    PCVTDT                                              CSD031
RFM  C**********           PARM *BLANKS   PALPDT                                              CSD031
RFM  C**********           MOVELPCVTDT    ZAMSDA                                              CSD031
      *                                                                                       CSD031
RFM  C**********           MOVEL'CSD0007' ZAMSID                                              CSD031
RFM  C**********           EXSR ZASNMS                                                        CSD031
RFM  C**********           MOVE *ON       *IN98                                               CSD031
RFM  C**********           MOVE *ON       *IN33                                               CSD031
RFM  C**********           ENDIF                                                              CSD031
RFM  C**********           ENDIF                                                              CSD031
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
      *                                                                                     MD049636
      ** If delete request and set up complete is OFF                                       MD049636
      ** validate all narrative code                                                        MD049636
     C     WUSUC         IFEQ      'N'
     C     #1SEL         IFEQ      'D'
     C     #1NVCD        CHAIN     ACKEYL4                            90
     C     #1NVCD        CHAIN     SEACKL2                            91
     C     *IN90         IFEQ      '0'
     C     *IN91         OREQ      '0'
     C                   MOVEL     'ASM0165'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN32
     C                   GOTO      SKIP1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD049636
      * If delete request, bypass validation
     C     #1SEL         IFEQ      'D'
     C     CSD044        ANDEQ     'N'
     C                   GOTO      DCEXIT
     C                   END
     C     SKIP1         TAG
      * Validate subfile record
     C                   EXSR      DEV1RC
      * If SFLRCD invalid, note the fact
     C   98
     CANN99              Z-ADD     ##RR          ##SFRC               99        *
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   DDNLRC        BEGSR
      *================================================================
      * Check for null record
      *================================================================
     C                   MOVEL     'N'           W0NLR             1
     C     #1NVCD        CABNE     *BLANK        DDEXIT                         Narrative Code
     C     #1DON         CABNE     *BLANK        DDEXIT                         Description of
      *                                                                                       CER030
     C     CGL013        IFEQ      'Y'
     C     CER030        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
     C     D1RTTY        CABNE     *BLANKS       DDEXIT
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record
      *================================================================
      * USER: Validate subfile record fields
      * Start of S01408
      * 00/Copy member SD0080MVSR - Narrative Codes  *
     C*Narrative codes maintenance    Validate Subfile Records
     C/COPY WNCPYSRC,SD0080MVSR
      * End of S01408
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     #1NVCD        WUTQKF                         Test ? in Key F
      * Start of Fix S01117
     C                   MOVEL     #1NVCD        WUIVKF                         If value in key
      * End of Fix S01117
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     '?INVAL'      W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     #1NVCD        ZA0001                         Narrative Code
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
      * Start of Fix S01117
     C                   ELSE
      * CASE: WRK.If value in key field is Asterisk
     C     WUIVKF        IFEQ      '*'                                          *IF
      * Setup message data for message
     C                   MOVEL     WUIVKF        ZA0002                         If value in key
     C                   MOVEL     #1NVCD        ZA0003                         Narrative Code
      * Send message 'Key Field Invalid Value'
     C                   MOVEL     'USR0849'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
      * End of Fix S01117
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate subfile record relations
     C                   EXSR      DFV2RC
      * Narrative Code required
     C     #1NVCD        IFEQ      *BLANK                                       IF
     C                   SETON                                        9833
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Narrative Code Contains leading or trailing blank
     C     #1NVCD        IFNE      *BLANK
     C                   Z-ADD     0             LTBLK             1 0
     C     ' '           SCAN      #1NVCD        LTBLK
     C     LTBLK         IFNE      0
     C                   SETON                                        9833
      * Send message 'No Leading or Trailing blanks allowed'                                MD039572
     C                   MOVEL     'Y2U0064'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *================================================================
     CSR   DEEXIT        ENDSR
      /EJECT
     CSR   DFV2RC        BEGSR
      *================================================================
      * Validate subfile record relations
      *================================================================
      * Calculate function fields
     C                   EXSR      DG#2FN
      * USER: Validate subfile record relations
      * CASE: RCD.Narrative Code is equal to zero
     C     #1NVCD        IFEQ      '00'                                         *IF
      * Setup message data for message
     C                   MOVEL     #1NVCD        ZA0004                         Narrative Code
      * Send message 'Code must be in range'
     C                   MOVEL     'USR0171'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   END                                                    *FI
      * CASE: RCD.Narrative Code is equal to 01
     C     #1NVCD        IFEQ      '01'                                         *IF
      * CASE: RCD.Description of Narrative is not equal to
     C     #1DON         IFNE      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1DON         ZA0005                         Description of
      * Send message 'Narrative Description sho'
     C                   MOVEL     'USR0166'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C     W0PMD         ANDEQ     'ADD'
     C     #1NVCD        ANDGE     P@VL01
     C     #1NVCD        ANDLE     P@VL02
     C                   MOVEL     'CSD0008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN33
     C                   ENDIF
      *                                                                                       CSD031
     C     *INU1         IFEQ      *OFF
     C     W0PMD         ANDEQ     'ADD'
     C     #1NVCD        IFLT      P@VL01
     C     #1NVCD        ORGT      P@VL02
     C                   MOVEL     'CSD0009'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN33
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * CASE: RCD.Description of Narrative is *blank
     C     #1DON         IFEQ      *BLANK                                       *IF
      * CASE: RCD.Narrative Code is greater than 50
     C     #1NVCD        IFGT      '50'                                         *IF
      * Setup message data for message
     C                   MOVEL     #1DON         ZA0006                         Description of
      * Send message 'Narrative Description'
     C                   MOVEL     'USR0164'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Set Up Complete is Yes
     C     WUSUC         IFEQ      'Y'                                          *IF
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
      * CASE: RCD.Narrative Code is between 1 & 50
     C     #1NVCD        IFGE      '01'                                         *IF
     C     #1NVCD        ANDLE     '50'
      * Setup message data for message
     C                   MOVEL     #1NVCD        ZA0007                         Narrative Code
      * Send message 'Codes 1-50 cannot be'
     C                   MOVEL     'USR0167'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        WUFLG1                         Flag1
     C                   MOVEL     *BLANK        WUFLG6                         Flag6
      * CASE: WRK.Set Up Complete is No
     C     WUSUC         IFEQ      'N'                                          *IF
      * CASE: RCD.Narrative Code is equal to 33
     C     #1NVCD        IFEQ      '33'                                         *IF
      * Check Description - Narrative Codes  *
     C****************************************************************
     C* CHECK WHETHER NARRATIVE DESCRIPTION HAS ANY BLANK SPACES     *
     C* SINCE DESCRIPTION FOR NARRATIVE CODES 02-32,34-36 & 47-49    *
     C* SHOULD BEGIN IN POSITION 7: CODE 33 SHOULD BEGIN IN POSITION *
     C* 2: CODES 44-46 & 50 SHOULD BEGIN IN POSITION 1.              *
     C****************************************************************
     C                   MOVE      *BLANK        WHOLE
     C*********************MOVE *BLANK    WUE0ST  1        POS. 1 FLAG    S01229
     C                   MOVE      *BLANK        WUFLG1            1            POS. 1 FLAG    S0122
     C*********************MOVE *BLANK    WUE1ST  1        POS. 1-6 FLAG  S01229
     C                   MOVE      *BLANK        WUFLG6            1            POS. 1-6 FLAG  S0122
     C*********************MOVEL#1ANTX    WHOLE
     C                   MOVEL     #1DON         WHOLE
     C     CHECK1        IFEQ      *BLANK
     C*********************MOVE 'Y'       WUE0ST                          S01229
     C                   MOVE      'Y'           WUFLG1                                        S0122
     C                   ELSE
     C*********************MOVE 'N'       WUE0ST                          S01229
     C                   MOVE      'N'           WUFLG1                                        S0122
     C                   END
     C     CHECK6        IFEQ      *BLANK
     C*********************MOVE 'Y'       WUE1ST                          S01229
     C                   MOVE      'Y'           WUFLG6                                        S0122
     C                   ELSE
     C*********************MOVE 'N'       WUE1ST                          S01229
     C                   MOVE      'N'           WUFLG6                                        S0122
     C                   END
      * CASE: WRK.Flag1 is equal to NO
     C     WUFLG1        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DON         ZA0008                         Description of
      * Send message 'Position 1 of Description'
     C                   MOVEL     'USR0168'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Set Up Complete is No
     C     WUSUC         IFEQ      'N'                                          *IF
      * CASE: RCD.Narrative Code is between 2 &32
     C     #1NVCD        IFGE      '02'                                         *IF
     C     #1NVCD        ANDLE     '32'
      * Check Description - Narrative Codes  *
     C****************************************************************
     C* CHECK WHETHER NARRATIVE DESCRIPTION HAS ANY BLANK SPACES     *
     C* SINCE DESCRIPTION FOR NARRATIVE CODES 02-32,34-36 & 47-49    *
     C* SHOULD BEGIN IN POSITION 7: CODE 33 SHOULD BEGIN IN POSITION *
     C* 2: CODES 44-46 & 50 SHOULD BEGIN IN POSITION 1.              *
     C****************************************************************
     C                   MOVE      *BLANK        WHOLE
     C*********************MOVE *BLANK    WUE0ST  1        POS. 1 FLAG    S01229
     C                   MOVE      *BLANK        WUFLG1            1            POS. 1 FLAG    S0122
     C*********************MOVE *BLANK    WUE1ST  1        POS. 1-6 FLAG  S01229
     C                   MOVE      *BLANK        WUFLG6            1            POS. 1-6 FLAG  S0122
     C*********************MOVEL#1ANTX    WHOLE
     C                   MOVEL     #1DON         WHOLE
     C     CHECK1        IFEQ      *BLANK
     C*********************MOVE 'Y'       WUE0ST                          S01229
     C                   MOVE      'Y'           WUFLG1                                        S0122
     C                   ELSE
     C*********************MOVE 'N'       WUE0ST                          S01229
     C                   MOVE      'N'           WUFLG1                                        S0122
     C                   END
     C     CHECK6        IFEQ      *BLANK
     C*********************MOVE 'Y'       WUE1ST                          S01229
     C                   MOVE      'Y'           WUFLG6                                        S0122
     C                   ELSE
     C*********************MOVE 'N'       WUE1ST                          S01229
     C                   MOVE      'N'           WUFLG6                                        S0122
     C                   END
      * CASE: WRK.Flag6 is equal to NO
     C     WUFLG6        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DON         ZA0009                         Description of
      * Send message 'Positions 1 - 6 of'
     C                   MOVEL     'USR0169'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Set Up Complete is No
     C     WUSUC         IFEQ      'N'                                          *IF
      * CASE: RCD.Narrative Code is between 34 & 36
     C     #1NVCD        IFGE      '34'                                         *IF
     C     #1NVCD        ANDLE     '36'
      * Check Description - Narrative Codes  *
     C****************************************************************
     C* CHECK WHETHER NARRATIVE DESCRIPTION HAS ANY BLANK SPACES     *
     C* SINCE DESCRIPTION FOR NARRATIVE CODES 02-32,34-36 & 47-49    *
     C* SHOULD BEGIN IN POSITION 7: CODE 33 SHOULD BEGIN IN POSITION *
     C* 2: CODES 44-46 & 50 SHOULD BEGIN IN POSITION 1.              *
     C****************************************************************
     C                   MOVE      *BLANK        WHOLE
     C*********************MOVE *BLANK    WUE0ST  1        POS. 1 FLAG    S01229
     C                   MOVE      *BLANK        WUFLG1            1            POS. 1 FLAG    S0122
     C*********************MOVE *BLANK    WUE1ST  1        POS. 1-6 FLAG  S01229
     C                   MOVE      *BLANK        WUFLG6            1            POS. 1-6 FLAG  S0122
     C*********************MOVEL#1ANTX    WHOLE
     C                   MOVEL     #1DON         WHOLE
     C     CHECK1        IFEQ      *BLANK
     C*********************MOVE 'Y'       WUE0ST                          S01229
     C                   MOVE      'Y'           WUFLG1                                        S0122
     C                   ELSE
     C*********************MOVE 'N'       WUE0ST                          S01229
     C                   MOVE      'N'           WUFLG1                                        S0122
     C                   END
     C     CHECK6        IFEQ      *BLANK
     C*********************MOVE 'Y'       WUE1ST                          S01229
     C                   MOVE      'Y'           WUFLG6                                        S0122
     C                   ELSE
     C*********************MOVE 'N'       WUE1ST                          S01229
     C                   MOVE      'N'           WUFLG6                                        S0122
     C                   END
      * CASE: WRK.Flag6 is equal to NO
     C     WUFLG6        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DON         ZA0010                         Description of
      * Send message 'Positions 1 - 6 of'
     C                   MOVEL     'USR0169'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Set Up Complete is No
     C     WUSUC         IFEQ      'N'                                          *IF
      * CASE: RCD.Narrative Code is between 47 & 49
     C     #1NVCD        IFGE      '47'                                         *IF
     C     #1NVCD        ANDLE     '49'
      * Check Description - Narrative Codes  *
     C****************************************************************
     C* CHECK WHETHER NARRATIVE DESCRIPTION HAS ANY BLANK SPACES     *
     C* SINCE DESCRIPTION FOR NARRATIVE CODES 02-32,34-36 & 47-49    *
     C* SHOULD BEGIN IN POSITION 7: CODE 33 SHOULD BEGIN IN POSITION *
     C* 2: CODES 44-46 & 50 SHOULD BEGIN IN POSITION 1.              *
     C****************************************************************
     C                   MOVE      *BLANK        WHOLE
     C*********************MOVE *BLANK    WUE0ST  1        POS. 1 FLAG    S01229
     C                   MOVE      *BLANK        WUFLG1            1            POS. 1 FLAG    S0122
     C*********************MOVE *BLANK    WUE1ST  1        POS. 1-6 FLAG  S01229
     C                   MOVE      *BLANK        WUFLG6            1            POS. 1-6 FLAG  S0122
     C*********************MOVEL#1ANTX    WHOLE
     C                   MOVEL     #1DON         WHOLE
     C     CHECK1        IFEQ      *BLANK
     C*********************MOVE 'Y'       WUE0ST                          S01229
     C                   MOVE      'Y'           WUFLG1                                        S0122
     C                   ELSE
     C*********************MOVE 'N'       WUE0ST                          S01229
     C                   MOVE      'N'           WUFLG1                                        S0122
     C                   END
     C     CHECK6        IFEQ      *BLANK
     C*********************MOVE 'Y'       WUE1ST                          S01229
     C                   MOVE      'Y'           WUFLG6                                        S0122
     C                   ELSE
     C*********************MOVE 'N'       WUE1ST                          S01229
     C                   MOVE      'N'           WUFLG6                                        S0122
     C                   END
      * CASE: WRK.Flag6 is equal to NO
     C     WUFLG6        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DON         ZA0011                         Description of
      * Send message 'Positions 1 - 6 of'
     C                   MOVEL     'USR0169'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Start of 28995
      * Narrative code is 44
      * CASE: WRK.Set Up Complete is No
     C     WUSUC         IFEQ      'N'                                          *IF
      * CASE: RCD.Narrative Code is equal to 44
     C     #1NVCD        IFEQ      '44'                                         *IF
      * Description need not be input, but if it is,
      * it should start in position 1.
      * CASE: RCD.Description of Narrative is *blank
     C     #1DON         IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Check Description - Narrative Codes  *
     C****************************************************************
     C* CHECK WHETHER NARRATIVE DESCRIPTION HAS ANY BLANK SPACES     *
     C* SINCE DESCRIPTION FOR NARRATIVE CODES 02-32,34-36 & 47-49    *
     C* SHOULD BEGIN IN POSITION 7: CODE 33 SHOULD BEGIN IN POSITION *
     C* 2: CODES 44-46 & 50 SHOULD BEGIN IN POSITION 1.              *
     C****************************************************************
     C                   MOVE      *BLANK        WHOLE
     C*********************MOVE *BLANK    WUE0ST  1        POS. 1 FLAG    S01229
     C                   MOVE      *BLANK        WUFLG1            1            POS. 1 FLAG    S0122
     C*********************MOVE *BLANK    WUE1ST  1        POS. 1-6 FLAG  S01229
     C                   MOVE      *BLANK        WUFLG6            1            POS. 1-6 FLAG  S0122
     C*********************MOVEL#1ANTX    WHOLE
     C                   MOVEL     #1DON         WHOLE
     C     CHECK1        IFEQ      *BLANK
     C*********************MOVE 'Y'       WUE0ST                          S01229
     C                   MOVE      'Y'           WUFLG1                                        S0122
     C                   ELSE
     C*********************MOVE 'N'       WUE0ST                          S01229
     C                   MOVE      'N'           WUFLG1                                        S0122
     C                   END
     C     CHECK6        IFEQ      *BLANK
     C*********************MOVE 'Y'       WUE1ST                          S01229
     C                   MOVE      'Y'           WUFLG6                                        S0122
     C                   ELSE
     C*********************MOVE 'N'       WUE1ST                          S01229
     C                   MOVE      'N'           WUFLG6                                        S0122
     C                   END
      * CASE: WRK.Flag1 is equal to YES
     C     WUFLG1        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DON         ZA0012                         Description of
      * Send message 'Description should begin'
     C                   MOVEL     'USR0170'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Set Up Complete is No
     C     WUSUC         IFEQ      'N'                                          *IF
      * CASE: RCD.Narrative Code is 45 or 46
     C     #1NVCD        IFGE      '45'                                         *IF
     C     #1NVCD        ANDLE     '46'
      * Check Description - Narrative Codes  *
     C****************************************************************
     C* CHECK WHETHER NARRATIVE DESCRIPTION HAS ANY BLANK SPACES     *
     C* SINCE DESCRIPTION FOR NARRATIVE CODES 02-32,34-36 & 47-49    *
     C* SHOULD BEGIN IN POSITION 7: CODE 33 SHOULD BEGIN IN POSITION *
     C* 2: CODES 44-46 & 50 SHOULD BEGIN IN POSITION 1.              *
     C****************************************************************
     C                   MOVE      *BLANK        WHOLE
     C*********************MOVE *BLANK    WUE0ST  1        POS. 1 FLAG    S01229
     C                   MOVE      *BLANK        WUFLG1            1            POS. 1 FLAG    S0122
     C*********************MOVE *BLANK    WUE1ST  1        POS. 1-6 FLAG  S01229
     C                   MOVE      *BLANK        WUFLG6            1            POS. 1-6 FLAG  S0122
     C*********************MOVEL#1ANTX    WHOLE
     C                   MOVEL     #1DON         WHOLE
     C     CHECK1        IFEQ      *BLANK
     C*********************MOVE 'Y'       WUE0ST                          S01229
     C                   MOVE      'Y'           WUFLG1                                        S0122
     C                   ELSE
     C*********************MOVE 'N'       WUE0ST                          S01229
     C                   MOVE      'N'           WUFLG1                                        S0122
     C                   END
     C     CHECK6        IFEQ      *BLANK
     C*********************MOVE 'Y'       WUE1ST                          S01229
     C                   MOVE      'Y'           WUFLG6                                        S0122
     C                   ELSE
     C*********************MOVE 'N'       WUE1ST                          S01229
     C                   MOVE      'N'           WUFLG6                                        S0122
     C                   END
      * CASE: WRK.Flag1 is equal to YES
     C     WUFLG1        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DON         ZA0013                         Description of
      * Send message 'Description should begin'
     C                   MOVEL     'USR0170'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of 28995
      * CASE: WRK.Set Up Complete is No
     C     WUSUC         IFEQ      'N'                                          *IF
      * CASE: RCD.Narrative Code is equal to 50
     C     #1NVCD        IFEQ      '50'                                         *IF
      * Check Description - Narrative Codes  *
     C****************************************************************
     C* CHECK WHETHER NARRATIVE DESCRIPTION HAS ANY BLANK SPACES     *
     C* SINCE DESCRIPTION FOR NARRATIVE CODES 02-32,34-36 & 47-49    *
     C* SHOULD BEGIN IN POSITION 7: CODE 33 SHOULD BEGIN IN POSITION *
     C* 2: CODES 44-46 & 50 SHOULD BEGIN IN POSITION 1.              *
     C****************************************************************
     C                   MOVE      *BLANK        WHOLE
     C*********************MOVE *BLANK    WUE0ST  1        POS. 1 FLAG    S01229
     C                   MOVE      *BLANK        WUFLG1            1            POS. 1 FLAG    S0122
     C*********************MOVE *BLANK    WUE1ST  1        POS. 1-6 FLAG  S01229
     C                   MOVE      *BLANK        WUFLG6            1            POS. 1-6 FLAG  S0122
     C*********************MOVEL#1ANTX    WHOLE
     C                   MOVEL     #1DON         WHOLE
     C     CHECK1        IFEQ      *BLANK
     C*********************MOVE 'Y'       WUE0ST                          S01229
     C                   MOVE      'Y'           WUFLG1                                        S0122
     C                   ELSE
     C*********************MOVE 'N'       WUE0ST                          S01229
     C                   MOVE      'N'           WUFLG1                                        S0122
     C                   END
     C     CHECK6        IFEQ      *BLANK
     C*********************MOVE 'Y'       WUE1ST                          S01229
     C                   MOVE      'Y'           WUFLG6                                        S0122
     C                   ELSE
     C*********************MOVE 'N'       WUE1ST                          S01229
     C                   MOVE      'N'           WUFLG6                                        S0122
     C                   END
      * CASE: WRK.Flag1 is equal to YES
     C     WUFLG1        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DON         ZA0014                         Description of
      * Send message 'Description should begin'
     C                   MOVEL     'USR0170'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Start of S01408
      * 00/Copy member SD0080MVRR - Narrative Codes  *
     C*Narrative codes maintenance    Validate Record Relations
     C/COPY WNCPYSRC,SD0080MVRR
      * End of S01408
      *                                                                                       CER030
     C     CGL013        IFEQ      'Y'
     C     CER030        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
      ** Transaction type should be present in the                                            CER030
      ** transaction type static data                                                         CER030
      *                                                                                       CER030
     C                   MOVE      *OFF          *IN36
      *                                                                                       CER030
     C     D1RTTY        IFNE      *BLANKS
      *                                                                                       CER030
     C                   CALL      'AORETRR0'
     C                   PARM      '*MSG    '    PRTCD
     C                   PARM      '*KEY    '    POPTN
     C     D1RTTY        PARM      D1RTTY        PRTTY             5
     C     SDRETR        PARM      SDRETR        DSFDY
      *                                                                                       CER030
     C     PRTCD         IFEQ      '*NOSEL  '
      *                                                                                       CER030
     C                   MOVEL     #WRTTY        D1RTTY
      *                                                                                       CER030
     C                   ELSE
      *                                                                                       CER030
     C     PRTCD         IFNE      *BLANKS
      *                                                                                       CER030
     C                   MOVEL     'USR5315'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN36
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C     CSD044        IFEQ      'Y'
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C     #1ATOZ        ANDNE     'Y'
     C     #1ATOZ        ANDNE     'N'
RFM  C     #1ATOZ        ANDNE     ' '
     C                   MOVEL     'SCC0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN75
     C                   ENDIF
      * Default to 'N', if accept to zone is blanks                                           CSD031
RFM  C     #1ATOZ        IFEQ      ' '
RFM  C                   MOVE      'N'           #1ATOZ
RFM  C                   ENDIF
      * Default to 'N', if accept to zone is blanks                                           CSD031
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C     #1EFDA        ANDNE     *BLANKS
     C     #1ATOZ        ANDNE     'N'
     C                   MOVEL     'CSD0001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN77
     C                   ENDIF
      *                                                                                       CSD031
     C     #1EFDA        IFNE      *BLANKS
     C     *INU1         ANDEQ     *ON
     C     W0PMD         ANDEQ     'ADD'
     C                   Z-ADD     *ZERO         WEFDA             5 0
     C                   MOVE      #1EFDA        ZDATE
     C                   EXSR      ZDATE1
      *                                                                                       CSD031
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'ASM0045'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN77
     C                   ELSE
     C                   Z-ADD     ZDAYNO        WEFDA
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *================================================================
     CSR   DFEXIT        ENDSR
      /EJECT
     CSR   DG#2FN        BEGSR
      *================================================================
      * Calculate subfile record function fields
      *================================================================
      * CALC: Subfile record function fields
      * Start of S01408
      * 00/Copy member SD0080MRFF - Narrative Codes  *
     C*Narrative codes maintenance    Calculate Record Funct
     C/COPY WNCPYSRC,SD0080MRFF
      * End of S01408
      *================================================================
     CSR   DGEXIT        ENDSR
      /EJECT
     CSR   EAPRSF        BEGSR
      *================================================================
      * Update DBF from subfile
      *================================================================
      * Initialise subfile reload flag
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'Y'           W0RSF
     C                   ELSE
     C                   MOVEL     'N'           W0RSF
     C                   END
      * Process all modified subfile records
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
      * Process modified subfile record
     C                   EXSR      EBPRSR
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes
     C                   ROLBK
     C                   ELSE
      * Otherwise COMMIT any DBF changes
     C                   COMMIT
     C                   END
     C                   MOVEL     *BLANK        #1SEL
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      * If any errors, cancel reload
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'N'           W0RSF
     C                   END
      *================================================================
     CSR   EAEXIT        ENDSR
      /EJECT
     CSR   EBPRSR        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
      * Set off error indicators
     C                   MOVEA     WKIND0        *IN(32)
     C                   SETOFF                                       98
      *
     C     #1SEL         IFEQ      'X'
     C                   EXSR      SRACCP
     C                   ELSE
      *                                                                                       CSD031
     C     W0PMD         IFEQ      'ADD'
      * Process add request
     C     #1SEL         IFNE      'D'
     C                   EXSR      DDNLRC
     C     W0NLR         IFNE      'Y'
     C                   EXSR      ECADRQ
     C                   END
     C                   END
     C                   ELSE
     C     #1SEL         IFEQ      'D'
      * Process delete request
     C                   EXSR      EDDLRQ
     C                   ELSE
      * Process change request
     C                   EXSR      EECHRQ
     C                   END
     C                   END
     C                   ENDIF
      * If error occurred on update, note the fact
     C     *IN98         IFEQ      '1'
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     ##RR          ##SFRC               99        *
     C                   END
     C                   ELSE
      * USER: Extra processing after DBF update
      * Start of S01408
      * 00/Copy member SD0080MEPU - Narrative Codes  *
     C*Narrative codes maintenance    Extra Process. DBF Update
     C/COPY WNCPYSRC,SD0080MEPU
      * End of S01408
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Narrative Codes - Narrative Codes  *
     C                   EXSR      SACRRC
     C     W0RTN         IFNE      *BLANK
      * Write error detected
      * Screen errors
     C                   MOVEA     WKIND1        *IN(32)
      * Format error
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
     C                   ELSE
      * DBF write successful
      * disable entry
     C                   SETON                                        87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete DBF record
      * Delete Narrative Codes - Narrative Codes  *
     C                   EXSR      SCDLRC
     C     W0RTN         IFNE      *BLANK
      * Delete unsuccessful
      * Screen errors
     C                   MOVEA     WKIND1        *IN(32)
      * Format error
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
      * If record altered, reset subfile record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF delete successful
      * Blank out record and protect from entry
     C                   EXSR      MAIZ#1
      * disable entry
     C                   SETON                                        87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
      * Reload subfile
     C                   MOVEL     'Y'           W0RSF
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
      * Change Narrative Codes - Narrative Codes  *
     C                   EXSR      SECHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Screen errors
     C                   MOVEA     WKIND1        *IN(32)
      * Format error
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
      * Reset subfile record if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF update successful
      * Enable entry
     C                   SETOFF                                       87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACHMD        BEGSR
      *================================================================
      * Switch between *ADD/*CHANGE modes
      *================================================================
     C     W0PMD         IFNE      'ADD'
     C                   MOVEL     'ADD'         W0PMD
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
     C     *INU1         IFEQ      *OFF
     C                   MOVE      *OFF          *IN67
     C                   MOVE      *OFF          *IN70
     C                   MOVE      *OFF          *IN71
     C                   MOVE      *OFF          *IN73
     C                   MOVE      *OFF          *IN74
     C                   MOVE      *OFF          *IN76
     C                   MOVE      *OFF          *IN69
     C                   ELSE
     C                   MOVE      *ON           *IN70
     C                   MOVE      *ON           *IN71
     C                   MOVE      *OFF          *IN73
     C                   MOVE      *OFF          *IN74
     C                   MOVE      *OFF          *IN76
     C                   MOVE      *OFF          *IN69
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
     C     *INU1         IFEQ      *OFF
     C                   MOVE      *ON           *IN67
     C                   MOVE      *ON           *IN70
     C                   MOVE      *ON           *IN71
     C                   MOVE      *ON           *IN73
     C                   MOVE      *ON           *IN74
     C                   MOVE      *ON           *IN76
     C                   MOVE      *ON           *IN69
     C                   ELSE
     C                   MOVE      *ON           *IN70
     C                   MOVE      *ON           *IN71
     C                   MOVE      *ON           *IN73
     C                   MOVE      *ON           *IN74
     C                   MOVE      *OFF          *IN76
     C                   MOVE      *OFF          *IN69
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   END
     C                   EXSR      FBRQRL
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      * Request subfile reload
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
      /EJECT
     CSR   GADSA1        BEGSR
      *================================================================
      * Set display attributes for Subfile record
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect keys if change mode or updated record
     C                   SETON                                        88        *
     C   89
     CANN87              SETOFF                                       88        *
     C                   MOVEL     *IN87         *IN79
     C     WUDELA        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
      *                                                                                       CSD031
     C     *IN66         IFEQ      *OFF
     C                   MOVEL     *IN87         *IN78
     C                   ENDIF
      *                                                                                       CSD031
     C     WUAMAL        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSA2        BEGSR
      *================================================================
      * Set display attributes for Subfile control
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise subfile record
      *================================================================
      * Previous values
     C                   MOVEL     *BLANK        #1DBRC
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #1NVCD                         Narrative Code
     C                   MOVEL     *BLANK        #1DON                          Description of
      *                                                                                       CER030
     C     CGL013        IFEQ      'Y'
     C     CER030        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
     C                   MOVE      *BLANKS       D1RTTY
     C                   MOVE      *BLANKS       #WRTTY
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
     C                   MOVEL     *BLANKS       #1ATOZ
     C                   MOVEL     *BLANKS       #1EFDA
      *                                                                                       CSD031
     C     *INU1         IFEQ      *OFF
     C     *IN66         ANDEQ     *ON
     C                   MOVEL     *BLANKS       #1LACT
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @ALREC0 fields to subfile
      *================================================================
     C                   Z-ADD     ALLCD         #1LCD                          Last Change Dat
     C                   MOVEL     ALTYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     ALNVCD        #1NVCD                         Narrative Code
     C                   MOVEL     ALDON         #1DON                          Description of
      * Hold current record image for change detection
     C                   eval      @1DBRC = SDNARR                                          MD058769
     C                   MOVEL     @1DBRC        #1DBRC
      *                                                                                       CER030
     C     CGL013        IFEQ      'Y'
     C     CER030        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
     C                   MOVEL     ALRTTY        D1RTTY
     C                   MOVEL     ALRTTY        #WRTTY
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C                   MOVEL     ALAACC        #1ATOZ
     C                   ELSE
     C                   MOVEL     ALGPDT        #1ATOZ
     C                   ENDIF
      *                                                                                       CSD031
     C     ALEACC        IFEQ      *ZERO
     C                   MOVE      *BLANKS       #1EFDA
     C                   ELSE
     C                   CALL      'ZDATE2'
     C                   PARM      ALEACC        PDATE             5 0
     C                   PARM      BJDFIN        PDTFMT            1
     C                   PARM      *ZEROS        PCVTDT            6 0
     C                   PARM      *BLANKS       PALPDT            7
     C                   MOVE      PCVTDT        #1EFDA
     C                   ENDIF
      *                                                                                       CSD031
     C     *INU1         IFEQ      *OFF
     C     *IN66         ANDEQ     *ON
     C                   MOVEL     ALTYLC        #1LACT
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2NVCD                         Narrative Code
      *                                                                                       CER030
     C     CGL013        IFEQ      'Y'
     C     CER030        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
     C                   MOVE      *BLANKS       D2RTTY
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Narrative Codes - Narrative Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN
      * Move all fields to @ALRECZ
     C                   MOVEL     #1NVCD        ALNVCD                         Narrative Code
     C                   Z-ADD     WURDNB        ALLCD                          Last Change Dat
     C                   MOVEL     'I'           ALTYLC                         Type of Last Ch
     C                   MOVEL     #1DON         ALDON                          Description of
      *                                                                                       CER030
     C     CGL013        IFEQ      'Y'
     C     CER030        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
     C                   MOVEL     D1RTTY        ALRTTY
     C                   ELSE
      *                                                                                       CER030
     C                   MOVE      *BLANKS       ALRTTY
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CSD031
     C                   MOVE      *BLANK        ALAACC
     C                   Z-ADD     *ZERO         ALEACC
     C                   MOVE      *BLANK        ALGPDT
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
      *                                                                                       CSD031
     C                   MOVE      #1ATOZ        ALAACC
      *                                                                                       CSD031
     C     #1EFDA        IFNE      *BLANKS
     C                   MOVE      #1EFDA        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        ALEACC
     C                   ENDIF
      *                                                                                       CSD031
     C                   MOVE      'Y'           ALGPDT
     C                   ELSE
     C                   MOVE      'N'           ALGPDT
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *
     C     KLCRSA        KLIST
     C                   KFLD                    ALNVCD                         Narrative Code
      * Check for duplicate primary key
     C     CSD044        IFEQ      'Y'
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C     KLCRSA        SETLL     SDNARD2                                90
     C                   ELSE
     C*****KLCRSA        SETLL     @ALRECZ                                90                MD058769
     C/EXEC SQL                                                                             MD058769
     C+ SELECT *                                                                            MD058769
     C+ into :SDNARR                                                                        MD058769
     C+ from SDNARJW0                                                                       MD058769
     C+ where ALNVCD = :ALNVCD                                                              MD058769
     C/END-EXEC                                                                             MD058769
     C                   SETOFF                                       90                    MD058769
     C                   If        SQLCODE =  0                                             MD058769
     C                   SETON                                        90                    MD058769
     C                   ENDIF                                                              MD058769
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
     C*****KLCRSA        SETLL     @ALRECZ                                90    *           MD058769
     C                   ENDIF
      *                                                                                       CSD031
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR0030'     W0RTN
      * Send message 'Narrative Codes        EX'
     C                   MOVEL     'USR0030'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SAEXIT
     C                   END
      *
     C     CSD044        IFEQ      'Y'
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C                   WRITE     SDNARD2                              91
     C                   EXSR      SRSEND
     C                   ELSE
     C**********         WRITE     @ALRECZ                              91                  MD058769
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
     C**********         WRITE     @ALRECZ                              91      *           MD058769
     C/EXEC SQL                                                                             MD058769
     C+ insert into SDNARBTD                                                                MD058769
     C+ (                                                                                   MD058769
     C+   ALNVCD                                                                            MD058769
     C+  ,ALLCD                                                                             MD058769
     C+  ,ALTYLC                                                                            MD058769
     C+  ,ALDON                                                                             MD058769
     C+  ,ALZONE                                                                            MD058769
     C+  ,ALIUSR                                                                            MD058769
     C+  ,ALAUSR                                                                            MD058769
     C+  ,ALXUSR                                                                            MD058769
     C+  ,ALAACC                                                                            MD058769
     C+  ,ALEACC                                                                            MD058769
     C+  ,ALGPDT                                                                            MD058769
     C+  ,ALRTTY                                                                            MD058769
     C+  ,ALMODE                                                                            MD058769
     C+ )                                                                                   MD058769
     C+ Values                                                                              MD058769
     C+ (                                                                                   MD058769
     C+   :ALNVCD                                                                           MD058769
     C+  ,:ALLCD                                                                            MD058769
     C+  ,:ALTYLC                                                                           MD058769
     C+  ,:ALDON                                                                            MD058769
     C+  ,:ALZONE                                                                           MD058769
     C+  ,:ALIUSR                                                                           MD058769
     C+  ,:ALAUSR                                                                           MD058769
     C+  ,:ALXUSR                                                                           MD058769
     C+  ,:ALAACC                                                                           MD058769
     C+  ,:ALEACC                                                                           MD058769
     C+  ,:ALGPDT                                                                           MD058769
     C+  ,:ALRTTY                                                                           MD058769
     C+  ,'B'                                                                               MD058769
     C+ )                                                                                   MD058769
     C/END-EXEC                                                                             MD058769
     C/EXEC SQL                                                                             MD058769
     C+ insert into SDNARXTD                                                                MD058769
     C+ (                                                                                   MD058769
     C+   ALNVCD                                                                            MD058769
     C+  ,ALLCD                                                                             MD058769
     C+  ,ALTYLC                                                                            MD058769
     C+  ,ALDON                                                                             MD058769
     C+  ,ALZONE                                                                            MD058769
     C+  ,ALIUSR                                                                            MD058769
     C+  ,ALAUSR                                                                            MD058769
     C+  ,ALXUSR                                                                            MD058769
     C+  ,ALAACC                                                                            MD058769
     C+  ,ALEACC                                                                            MD058769
     C+  ,ALGPDT                                                                            MD058769
     C+  ,ALRTTY                                                                            MD058769
     C+  ,ALMODE                                                                            MD058769
     C+ )                                                                                   MD058769
     C+ Values                                                                              MD058769
     C+ (                                                                                   MD058769
     C+   :ALNVCD                                                                           MD058769
     C+  ,:ALLCD                                                                            MD058769
     C+  ,:ALTYLC                                                                           MD058769
     C+  ,:ALDON                                                                            MD058769
     C+  ,:ALZONE                                                                           MD058769
     C+  ,:ALIUSR                                                                           MD058769
     C+  ,:ALAUSR                                                                           MD058769
     C+  ,:ALXUSR                                                                           MD058769
     C+  ,:ALAACC                                                                           MD058769
     C+  ,:ALEACC                                                                           MD058769
     C+  ,:ALGPDT                                                                           MD058769
     C+  ,:ALRTTY                                                                           MD058769
     C+  ,'B'                                                                               MD058769
     C+ )                                                                                   MD058769
     C/END-EXEC                                                                             MD058769
     C                   ENDIF
      *
     C******IN91         IFEQ      '1'                                                      MD058769
     C     SQLCODE       IFNE      0                                                        MD058769
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN
      * USER: Processing if Data update error
      * Start of S01408
      * 00/Copy member SD0080MCBU - Narrative Codes  *
     C*
     C/COPY WNCPYSRC,SD0080MCBU
     C*
      * End of S01408
     C                   ELSE
      * USER: Processing after Data update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
      * Start of SAR S01117
      * Change code to filename NARRAT - SDNARRPD
      * Change Standing Data Cont - Standing Data Controls  *
     C     CSD044        IFEQ      'Y'
     C     *INU1         ANDEQ     *OFF
     C     CSD044        OREQ      'N'
     C                   EXSR      SBCHRC
     C                   ENDIF
      * End of SAR S01117
      * Update TABLETP - Narrative Codes  *
     C     CSD044        IFEQ      'N'
      *                                                                                       CSD031
     C**********         CALL      'TABLETP'                            90      Update TABLEMD058769
     C*****W0RTN         PARM      *BLANK        WQ0001            7            *Return codeMD058769
     C**********         PARM      ALNVCD        WQ0002            2            Narrative CoMD058769
     C**********         PARM      ALDON         WQ0003           30            Description MD058769
      **********                                                                     CER030 MD058769
     C**********         PARM      ALRTTY        PRTTY                                      MD058769
      **********                                                                     CER030 MD058769
     C**********         PARM      ALTYLC        WQ0004            1            Type of LastMD058769
     C**********         PARM      WURDNB        WQ0005            5 0          Run day numbMD058769
      **********                                                                            MD058769
     C******IN90         IFEQ      '1'                                                      MD058769
      * Call to program ended in error                                                      MD058769
     C**********         MOVEL     'Y2U0032'     W0RTN                                      MD058769
     C**********         MOVEL     *BLANKS       W0CLPG           10                        MD058769
     C**********         MOVEL     'TABLETP'     W0CLPG                                     MD058769
      **Send*message '*Error occured on CALL...'                                            MD058769
     C**********         MOVEL     'Y2U0032'     ZAMSID                                     MD058769
     C**********         MOVEL     'Y2USRMSG'    ZAMSGF                                     MD058769
     C**********         MOVEL     W0CLPG        ZAMSDA                         Message dataMD058769
     C**********         EXSR      ZASNMS                                                   MD058769
     C**********         END                                                                MD058769
      *                                                                                       CSD031
     C                   ENDIF
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
      * Start of S01408
      * 00/Copy member SD0080MCAU - Narrative Codes  *
     C*
     C/COPY WNCPYSRC,SD0080MCAU
     C*
      * End of S01408
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDNARRPD'    AHFLNM                         Filename
      *
     C     KLCHSB        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSB        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   GOTO      SBEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YARDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C                   UPDATE    @AHREAU                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFCTLL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCDLRC        BEGSR
      *================================================================
      * Delete Narrative Codes - Narrative Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN
      * USER: Processing before Data update
      * Start of S01408
      * 00/Copy member SD0080MDBU - Narrative Codes  *
     C*
     C/COPY WNCPYSRC,SD0080MDBU
     C*
      * End of S01408
      * Move key fields to @ALRECZ
     C                   MOVEL     #1NVCD        ALNVCD                         Narrative Code
      *
     C     KLDLSC        KLIST
     C                   KFLD                    ALNVCD                         Narrative Code
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C     KLDLSC        CHAIN     SDNARD2                            9091
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C     *IN66         IFEQ      *ON
     C     KLDLSC        CHAIN     SDANARL0                           9091
     C                   ELSE
     C*****KLDLSC        CHAIN     @ALRECZ                            9091                  MD058976
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
     C*****KLDLSC        CHAIN     @ALRECZ                            9091      *           MD058769
     C/EXEC SQL                                                                             MD058769
     C+ SELECT *                                                                            MD058769
     C+ into :SDNARR                                                                        MD058769
     C+ from SDNARJW0                                                                       MD058769
     C+ where ALNVCD = :ALNVCD                                                              MD058769
     C/END-EXEC                                                                             MD058769
     C                   SETOFF                                       9091                  MD058769
     C                   If        SQLCODE = 100                                            MD058769
     C                   SETON                                        90                    MD058769
     C                   ENDIF                                                              MD058769
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058769
     C                   SETON                                        91                    MD058769
     C                   ENDIF                                                              MD058769
                                                                                            MD058769
     C                   ENDIF
      *                                                                                       CSD031
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
      * Check for changed record
     C                   eval      @1DBRC = SDNARR                                          MD058769
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C     CSD044        IFEQ      'Y'
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C     KLDLSC        SETLL     SDNARD2                            9091
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C     *IN66         IFEQ      *ON
     C     KLDLSC        SETLL     SDANARL0                           9091
     C                   ELSE
     C*****KLDLSC        SETLL     @ALRECZ                            9091                  MD058769
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
     C*****KLDLSC        SETLL     @ALRECZ                            9091      *           MD058769
     C                   ENDIF
      *                                                                                       CSD031
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C     CSD044        IFEQ      'Y'
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C                   DELETE    SDNARD2                              91
     C                   MOVE      'D'           ALTYLC
     C                   EXSR      SRSEND
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C     *IN66         IFEQ      *ON
     C                   DELETE    SDNARRD0                             91
     C                   ELSE
     C**********         DELETE    @ALRECZ                              91                  MD058769
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
     C**********         DELETE    @ALRECZ                              91      *           MD058769
      * Do not allow deletion of core record                                                MD058769
     C     ALMODE        IFEQ      'C'                                                      MD058769
     C                   MOVEL     'USR0555'     ZAMSID                                     MD058769
     C                   MOVEL     'USR0555'     W0RTN                                      MD058769
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                     MD058769
     C                   EXSR      ZASNMS                                                   MD058769
     C                   GOTO      SCEXIT                                                   MD058769
     C                   ENDIF                                                              MD058769
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
                                                                                            MD058769
     C/EXEC SQL                                                                             MD058769
     C+ delete from SDNARBTD                                                                MD058769
     C+ where ALNVCD = :ALNVCD                                                              MD058769
     C/END-EXEC                                                                             MD058769
     C/EXEC SQL                                                                             MD058769
     C+ delete from SDNARXTD                                                                MD058769
     C+ where ALNVCD = :ALNVCD                                                              MD058769
     C/END-EXEC                                                                             MD058769
      *                                                                                       CSD031
     C******IN91         IFEQ      '1'                                                      MD058769
     C     SQLCODE       IFNE      0                                                        MD058769
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
      * WUDELR Data Structure - SD Deleted Records File  *
     C                   MOVEL     @1DBRC        WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDNARRPD'    PAFNME                         File name
     C                   MOVEL     #1NVCD        PALKEY                         Long Key
     C                   MOVEL     WUDR01        PADR01                         Deleted Data Re
     C                   MOVEL     WUDR02        PADR02                         Deleted Data Re
     C                   MOVEL     WUDR03        PADR03                         Deleted Data Re
     C                   MOVEL     WUDR04        PADR04                         Deleted Data Re
     C                   MOVEL     WUDR05        PADR05                         Deleted Data Re
     C                   MOVEL     WUDR06        PADR06                         Deleted Data Re
     C                   MOVEL     WUDR07        PADR07                         Deleted Data Re
     C                   MOVEL     WUDR08        PADR08                         Deleted Data Re
     C                   MOVEL     WUDR09        PADR09                         Deleted Data Re
     C                   MOVEL     WUDR00        PADR00                         Deleted Data Re
     C                   MOVEL     WUDR11        PADR11                         Deleted Data Re
     C                   MOVEL     WUDR12        PADR12                         Deleted Data Re
     C                   Z-ADD     WURDNB        PALCD                          Last Change Dat
     C                   MOVEL     'D'           PATYLC                         Type of Last Ch
      *
     C                   CALL      'SD0520X'                            90      Write Deleted R
     C                   PARM      *BLANK        W0RTN
     C                   PARM                    PARC                           RCD: SD Deleted
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0520X'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9833      *
     C                   END
RFM   * Update trailer for zonal                                                              CSD031
RFM  C     *IN66         IFEQ      '0'
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     1             WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
RFM  C                   ELSE
     C                   Z-ADD     0             WUNORC                         No. of Records
     C                   Z-ADD     0             WUNODL                         No. of Deletes
     C                   Z-ADD     0             WUNOIN                         No. of Inserts
     C                   Z-ADD     0             WUNOAM                         No. of Amends
RFM  C                   ENDIF
      * Start of SAR S01117
      * Change code to filename NARRAT - SDNARRPD
      * Change Standing Data Cont - Standing Data Controls  *
     C     CSD044        IFEQ      'Y'
     C     *INU1         ANDEQ     *OFF
     C     CSD044        OREQ      'N'
     C                   EXSR      SDCHRC
     C                   ENDIF
      * End of SAR S01117
     C                   MOVEL     'D'           WUTYLC                         Type of Last Ch
      * Update TABLETP - Narrative Codes  *
     C     CSD044        IFEQ      'N'
      *                                                                                       CSD031
     C**********         CALL      'TABLETP'                            90      Update TABLEMD058769
     C*****W0RTN         PARM      *BLANK        WQ0006            7            *Return codeMD058769
     C**********         PARM      ALNVCD        WQ0007            2            Narrative CoMD058769
     C**********         PARM      ALDON         WQ0008           30            Description MD058769
      **********                                                                     CER030 MD058769
     C**********         PARM      ALRTTY        PRTTY                                      MD058769
      **********                                                                     CER030 MD058769
     C**********         PARM      WUTYLC        WQ0009            1            Type of LastMD058769
     C**********         PARM      WURDNB        WQ0010            5 0          Run day numbMD058769
      **********                                                                            MD058769
     C******IN90         IFEQ      '1'                                                      MD058769
      **Call*to program ended in error                                                      MD058769
     C**********         MOVEL     'Y2U0032'     W0RTN                                      MD058769
     C**********         MOVEL     *BLANKS       W0CLPG           10                        MD058769
     C**********         MOVEL     'TABLETP'     W0CLPG                                     MD058769
      **Send*message '*Error occured on CALL...'                                            MD058769
     C**********         MOVEL     'Y2U0032'     ZAMSID                                     MD058769
     C**********         MOVEL     'Y2USRMSG'    ZAMSGF                                     MD058769
     C**********         MOVEL     W0CLPG        ZAMSDA                         Message dataMD058769
     C**********         EXSR      ZASNMS                                                   MD058769
     C**********         END                                                                MD058769
      *                                                                                       CSD031
     C                   ENDIF
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
      * Start of S01408
      * 00/Copy member SD0080MDAU - Narrative Codes  *
     C*
     C/COPY WNCPYSRC,SD0080MDAU
     C*
      * End of S01408
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YBRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDNARRPD'    AHFLNM                         Filename
      *
     C     KLCHSD        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSD        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   GOTO      SDEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YBRDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YBRDCS
     C                   MOVE      'Y'           YBRDC
     C                   END
      * If changed update record otherwise release record
     C     YBRDC         IFEQ      'Y'
     C                   UPDATE    @AHREAU                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFCTLL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SECHRC        BEGSR
      *================================================================
      * Change Narrative Codes - Narrative Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YCRDC             1
      *
      * Move key fields to @ALRECZ
     C                   MOVEL     #1NVCD        ALNVCD                         Narrative Code
      *
     C     KLCHSE        KLIST
     C                   KFLD                    ALNVCD                         Narrative Code
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C     KLCHSE        CHAIN     SDNARD2                            9091
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C     *IN66         IFEQ      *ON
     C     KLCHSE        CHAIN     SDANARL0                           9091
     C                   ELSE
     C*****KLCHSE        CHAIN     @ALRECZ                            9091                  MD058769
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
     C*****KLCHSE        CHAIN     @ALRECZ                            9091      *           MD058769
     C/EXEC SQL                                                                             MD058769
     C+ SELECT *                                                                            MD058769
     C+ into :SDNARR                                                                        MD058769
     C+ from SDNARJW0                                                                       MD058769
     C+ where ALNVCD = :ALNVCD                                                              MD058769
     C/END-EXEC                                                                             MD058769
     C                   SETOFF                                       9091                  MD058769
     C                   If        SQLCODE = 100                                            MD058769
     C                   SETON                                        90                    MD058769
     C                   ENDIF                                                              MD058769
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058769
     C                   SETON                                        91                    MD058769
     C                   ENDIF                                                              MD058769
                                                                                            MD058769
     C                   ENDIF
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SEEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   GOTO      SEEXIT
     C                   END
      *
      * Check for changed record
     C                   eval      @1DBRC = SDNARR                                          MD058769
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C**********         UNLOCK    SDNARRL0                             91      *           MD058769
     C                   GOTO      SEEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C                   MOVE      @1DBRC        YCRDCS
      * Move non-key fields to @ALRECZ
     C                   Z-ADD     WURDNB        ALLCD                          Last Change Dat
     C                   MOVEL     'A'           ALTYLC                         Type of Last Ch
     C                   MOVEL     #1DON         ALDON                          Description of
      *                                                                                       CER030
     C     CGL013        IFEQ      'Y'
     C     CER030        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
     C                   MOVEL     D1RTTY        ALRTTY
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
      *                                                                                       CSD031
     C                   MOVE      #1ATOZ        ALAACC
      *                                                                                       CSD031
     C     #1EFDA        IFNE      *BLANKS
     C                   MOVE      #1EFDA        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        ALEACC
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * USER: Processing before Data update
      * Start of S01408
      * 00/Copy member SD0080MBDU - Narrative Codes  *
     C*
     C/COPY WNCPYSRC,SD0080MBDU
     C*
      * End of S01408
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * If changed update record otherwise release record
     C     YCRDC         IFEQ      'Y'
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C                   UPDATE    SDNARD2                              91
     C                   EXSR      SRSEND
     C                   ELSE
     C**********         UPDATE    @ALRECZ                              91                  MD058769
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
     C**********         UPDATE    @ALRECZ                              91      *           MD058769
     C/EXEC SQL                                                                             MD058769
     C+ update SDNARXTD set                                                                 MD058769
     C+   ALLCD  = :ALLCD                                                                   MD058769
     C+  ,ALTYLC = :ALTYLC                                                                  MD058769
     C+  ,ALDON  = :ALDON                                                                   MD058769
     C+  ,ALZONE = :ALZONE                                                                  MD058769
     C+  ,ALIUSR = :ALIUSR                                                                  MD058769
     C+  ,ALAUSR = :ALAUSR                                                                  MD058769
     C+  ,ALXUSR = :ALXUSR                                                                  MD058769
     C+  ,ALAACC = :ALAACC                                                                  MD058769
     C+  ,ALEACC = :ALEACC                                                                  MD058769
     C+  ,ALGPDT = :ALGPDT                                                                  MD058769
     C+  ,ALRTTY = :ALRTTY                                                                  MD058769
     C+ where ALNVCD = :ALNVCD                                                              MD058769
     C/END-EXEC                                                                             MD058769
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      * Release record lock
     C     CSD044        IFEQ      'Y'
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C                   UNLOCK    GPNARRL0                             91
     C                   ELSE
     C**********         UNLOCK    SDNARRL0                             91                  MD058769
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
     C**********         UNLOCK    SDNARRL0                             91      *           MD058769
     C                   ENDIF
      *                                                                                       CSD031
     C                   END
     C******IN91         IFEQ      '1'                                                      MD058769
     C                   If        SQLCODE <> 0                                             MD058769
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      *
     C     CGL013        IFEQ      'Y'
     C     CER030        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
     C                   MOVEL     ALRTTY        #WRTTY
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
      * DBF change successful
      * USER: Processing after Data update
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOAM                         No. of Amends
      * Start of SAR S01117
      * Change code to filename NARRAT - SDNARRPD
      * Change Standing Data Cont - Standing Data Controls  *
     C     CSD044        IFEQ      'Y'
     C     *INU1         ANDEQ     *OFF
     C     CSD044        OREQ      'N'
     C                   EXSR      SFCHRC
     C                   ENDIF
      * End of SAR S01117
      * Update TABLETP - Narrative Codes  *
     C     CSD044        IFEQ      'N'
      *                                                                                       CSD031
     C**********         CALL      'TABLETP'                            90      Update TABLEMD058769
     C*****W0RTN         PARM      *BLANK        WQ0011            7            *Return codeMD058769
     C**********         PARM      ALNVCD        WQ0012            2            Narrative CoMD058769
     C**********         PARM      ALDON         WQ0013           30            Description MD058769
      **********                                                                     CER030 MD058769
     C**********         PARM      ALRTTY        PRTTY             5                        MD058769
      **********                                                                     CER030 MD058769
     C**********         PARM      ALTYLC        WQ0014            1            Type of LastMD058769
     C**********         PARM      WURDNB        WQ0015            5 0          Run day numbMD058769
      **********                                                                            MD058769
     C******IN90         IFEQ      '1'                                                      MD058769
      **Call*to program ended in error                                                      MD058769
     C**********         MOVEL     'Y2U0032'     W0RTN                                      MD058769
     C**********         MOVEL     *BLANKS       W0CLPG           10                        MD058769
     C**********         MOVEL     'TABLETP'     W0CLPG                                     MD058769
      **Send*message '*Error occured on CALL...'                                            MD058769
     C**********         MOVEL     'Y2U0032'     ZAMSID                                     MD058769
     C**********         MOVEL     'Y2USRMSG'    ZAMSGF                                     MD058769
     C**********         MOVEL     W0CLPG        ZAMSDA                         Message dataMD058769
     C**********         EXSR      ZASNMS                                                   MD058769
     C**********         END                                                                MD058769
      *                                                                                       CSD031
     C                   ENDIF
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
      * Start of S01408
      * 00/Copy member SD0080MADU - Narrative Codes  *
     C*
     C/COPY WNCPYSRC,SD0080MADU
     C*
      * End of S01408
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YDRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDNARRPD'    AHFLNM                         Filename
      *
     C     KLCHSF        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSF        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   GOTO      SFEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YDRDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YDRDCS
     C                   MOVE      'Y'           YDRDC
     C                   END
      * If changed update record otherwise release record
     C     YDRDC         IFEQ      'Y'
     C                   UPDATE    @AHREAU                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFCTLL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   Y0SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y0EXIT        ENDSR
      /EJECT
     CSR   Y8TST         BEGSR
      *================================================================
      * Test cursor
      *================================================================
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
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
      *
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Help text sourc
     C                   PARM      *BLANK        YYHPFL           10            Help text file
     C                   PARM      *BLANK        YYHPLB           10            Help text libra
     C                   PARM                    W0RTN
     C                   PARM      '*START'      YYHLVN           10            Help label
     C                   PARM      '*NORMAL'     YYUSOP           10            Options
     C                   PARM      ZHCSRW        YYRW              5 0          Row
     C                   PARM      ZHCSCL        YYCL              5 0          Column
     C                   PARM      *ZERO         YYLGCT            5 0          # of grps
     C                   PARM      *BLANK        YYLGVN           10            Label grps
      *
      * Clear set cursor DDS indicator
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94        *
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program: Normal
      *================================================================
      * USER: Exit program processing
      * Start of S01408
      * 00/Copy member SD0080MEPP - Narrative Codes  *
     C*Narrative codes  maintenance    Exit Program Processing
     C/COPY WNCPYSRC,SD0080MEPP
      * End of S01408
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
     C/EXEC SQL                                                                             MD058769
     C+ close ACursor                                                                       MD058769
     C/END-EXEC                                                                             MD058769
                                                                                            MD058769
      * ROLLBACK any uncommitted DBF changes
     C                   ROLBK                                          90
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
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
     C                   MOVEL     HEAD3(1)      #2HEA3
      *                                                                                       CSD031
      ** Access SAR details to see if CSD044 is switched on                                   CSD031
      *                                                                                       CSD031
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CSD044'      PSARD             6
     C     DSSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CSD031
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     PSARD         DBKEY
     C                   EXSR      *PSSR
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD044            1
     C                   MOVE      *ON           *IN35
     C                   ELSE
     C                   MOVE      'N'           CSD044
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *ON           *IN69
     C                   MOVE      *ON           *IN76
     C                   ENDIF
      *                                                                                       CSD031
      ** Call GPAOSVALR0 to retrieve the start and end range defined                          CSD031
      ** for Narrative Codes.                                                                 CSD031
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
     C                   CALL      PGMA
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      CONS1         P@OP01           20
     C                   PARM      *BLANKS       P@VL01          200
     C                   PARM      CONS2         P@OP02           20
     C                   PARM      *BLANKS       P@VL02          200
     C                   PARM      *BLANKS       P@OP03           20
     C                   PARM      *BLANKS       P@VL03          200
     C                   PARM      *BLANKS       P@OP04           20
     C                   PARM      *BLANKS       P@VL04          200
     C                   PARM      *BLANKS       P@OP05           20
     C                   PARM      *BLANKS       P@VL05          200
     C                   PARM      *BLANKS       P@OP06           20
     C                   PARM      *BLANKS       P@VL06          200
     C                   PARM      *BLANKS       P@OP07           20
     C                   PARM      *BLANKS       P@VL07          200
     C                   PARM      *BLANKS       P@OP08           20
     C                   PARM      *BLANKS       P@VL08          200
     C                   PARM      *BLANKS       P@OP09           20
     C                   PARM      *BLANKS       P@VL09          200
     C                   PARM      *BLANKS       P@OP10           20
     C                   PARM      *BLANKS       P@VL10          200
      *                                                                                       CSD031
     C     P@RTCD        IFNE      *BLANKS
     C**********           MOVEL'GPSVALPD'DBKEY                                      CSD031 MD054605
     C                   MOVEL     'GPSVLJW0'    DBKEY
     C                   MOVEL     '903'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSD031
     C                   MOVE      *ON           *IN70
     C                   MOVE      *ON           *IN71
     C                   MOVE      *ON           *IN73
     C                   MOVE      *ON           *IN74
     C                   MOVE      *OFF          *IN76
     C                   MOVE      *OFF          *IN69
     C                   MOVE      *OFF          *IN66
     C                   MOVE      *OFF          *IN67
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD044        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C                   MOVEL     HEAD1A        #2HEA1
     C                   MOVEL     HEAD1B        #2HEA2
     C                   MOVEL     HEAD3(3)      #2HEA3
     C                   Z-ADD     80            PLEN             15 5
     C                   MOVE      OVRC(1)       PCMD             80
      *                                                                                       CSD031
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD
     C                   PARM                    PLEN
      *                                                                                       CSD031
     C                   OPEN      GZSDBANK
     C                   READ      GZSDBANK                               90
     C     *IN90         IFEQ      *ON
     C                   MOVEL     'GZSDBANK'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   CLOSE     GZSDBANK
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
      ** If program is called from the zone layer (U1 = *OFF)                                 CSD031
      *                                                                                       CSD031
     C                   MOVE      *ON           *IN76
     C                   MOVE      *ON           *IN69
     C                   MOVE      *ON           *IN67
     C                   MOVEL     HEAD2A        #2HEA1
     C                   MOVEL     HEAD2B        #2HEA2
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *                                                                                       CSD031
     C     PRTCD         IFNE      *BLANK
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
      * Set century digit (If YY prior to 1940 treat as 20YY)
     C     ##JYY         IFLT      40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   END
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Define work field Deletion Allowed
     C                   MOVEL     *BLANK        WUDELA            1
      * Define work field Amend allowed
     C                   MOVEL     *BLANK        WUAMAL            1
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define work field If value in key field
     C                   MOVEL     *BLANK        WUIVKF            1
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Flag1
     C                   MOVEL     *BLANK        WUFLG1            1
      * Define work field Flag6
     C                   MOVEL     *BLANK        WUFLG6            1
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field Deleted Data Record Pt1
     C                   MOVEL     *BLANK        WUDR01          250
      * Define work field Deleted Data Record Pt2
     C                   MOVEL     *BLANK        WUDR02          250
      * Define work field Deleted Data Record Pt3
     C                   MOVEL     *BLANK        WUDR03          250
      * Define work field Deleted Data Record Pt4
     C                   MOVEL     *BLANK        WUDR04          250
      * Define work field Deleted Data Record Pt5
     C                   MOVEL     *BLANK        WUDR05          250
      * Define work field Deleted Data Record Pt6
     C                   MOVEL     *BLANK        WUDR06          250
      * Define work field Deleted Data Record Pt7
     C                   MOVEL     *BLANK        WUDR07          250
      * Define work field Deleted Data Record Pt8
     C                   MOVEL     *BLANK        WUDR08          250
      * Define work field Deleted Data Record Pt9
     C                   MOVEL     *BLANK        WUDR09          250
      * Define work field Deleted Data Record Pt10
     C                   MOVEL     *BLANK        WUDR00          250
      * Define work field Deleted Data Record Pt11
     C                   MOVEL     *BLANK        WUDR11          250
      * Define work field Deleted Data Record Pt12
     C                   MOVEL     *BLANK        WUDR12          250
      * Define work field Type of Last Change
     C                   MOVEL     *BLANK        WUTYLC            1
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      * Define work field Temporary Desc. of Narrative                                        CSD031
     C                   MOVEL     *BLANK        WDON             30
      * Open files
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN
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
     C                   OPEN      SD0080M#
     C**********         OPEN      SDNARRL1                                                 MD058769
     C**********         OPEN      SDNARRL0                                                 MD058769
     C                   OPEN      SDFCTLL0
     C                   MOVEL     'N'           W0PMT             1
      *
     C                   Z-ADD     13            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      * Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      * Scan limit
     C                   Z-ADD     500           W0SLM             5 0
      * Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      * Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
      *................................................................
      * Set to *CHANGE mode
     C                   MOVEL     'CHG'         W0PMD             3
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Start of S01459
      * Remove the creation parameters and header box functions
      * SD0080M precompiler - Narrative Codes  *
      * End of S01459
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Copyright Statement 1988 - Standard Functions  * copyright
      * Start of S01408
      * 00/Copy member SD0080MFPG - Narrative Codes  *
      * 00/Copy member SD0080MEPG - Narrative Codes  *
      * 00/Copy member SD0080MIPG - Narrative Codes  *
      * 00/Copy member SD0080MCPG - Narrative Codes  *
     C*Narrative codes maintenance    Initialise Program C-Spec
     C/COPY WNCPYSRC,SD0080MCPG
      * 00/Copy member SD0080MOPG - Narrative Codes  *
      * End of S01408
      * Initialise subfile control
     C                   EXSR      MEIZ#2
      *                                                                                       CER030
      ** Check if CER030 is On                                                                CER030
      *                                                                                       CER030
     C                   MOVE      *OFF          *IN51
      *                                                                                       CER030
     C                   MOVE      'N'           CER030            1
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER030'      PSARD
     C********** DSSARD    PARM *BLANKS   DSFDY                                        CER030 CER059
     C     DSSARD        PARM      DSSARD        DSFDY
      *                                                                                       CER030
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CER030
     C                   MOVE      'Y'           CER030
     C                   MOVE      *ON           *IN51
      *                                                                                       CER030
     C                   MOVE      *ON           *IN37
      *                                                                                       CER030
     C                   ELSE
      *                                                                                       CER030
     C     PRTCD         IFNE      '*NRF   '
      *                                                                                       CER030
     C                   EXSR      *PSSR
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
      ** Check if CGL013 is On                                                                CER030
      *                                                                                       CER030
     C                   MOVE      'N'           CGL013            1
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL013'      PSARD
     C********** DSSARD    PARM *BLANKS   DSFDY                                        CER030 CER059
     C     DSSARD        PARM      DSSARD        DSFDY
      *                                                                                       CER030
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CER030
     C                   MOVE      'Y'           CGL013
     C                   MOVE      *ON           *IN51
      *                                                                                       CER030
     C                   MOVE      *ON           *IN37
      *                                                                                       CER030
     C                   ELSE
      *                                                                                       CER030
     C     PRTCD         IFNE      '*NRF   '
      *                                                                                       CER030
     C                   EXSR      *PSSR
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CRE098
      ** Check if CRE098 is On                                                                CRE098
      *                                                                                       CRE098
     C**********           MOVE *OFF      *IN51                                      CRE098 MD024430
     C                   MOVE      'N'           CRE098            1
      *                                                                                       CRE098
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CRE098'      PSARD
     C     DSSARD        PARM      DSSARD        DSFDY
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CRE098
     C                   MOVE      'Y'           CRE098
     C                   MOVE      *ON           *IN51
     C                   MOVE      *ON           *IN37
     C                   ELSE
      *                                                                                       CRE098
     C     PRTCD         IFNE      '*NRF   '
      *                                                                                       CRE098
     C                   EXSR      *PSSR
      *                                                                                       CRE098
     C                   ENDIF
      *                                                                                       CRE098
     C                   ENDIF
      *                                                                                       CRE098
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT
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
      * Core function specific processing.
      *
     C/COPY WNCPYSRC,SD0080MPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0080MPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD058769
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD058769
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0080MPS2
      *
      *================================================================
     CSR                 ENDSR
      *****************************************************************                       CSD031
      /EJECT                                                                                  CSD031
      *****************************************************************                       CSD031
      *                                                               *                       CSD031
      *  SRACCP - Does acceptance processing.                         *                       CSD031
      *                                                               *                       CSD031
      *****************************************************************                       CSD031
     C     SRACCP        BEGSR
      *                                                                                       CSD031
     C                   MOVE      *BLANK        WACTN             1
      *                                                                                       CSD031
     C*****#1NVCD        CHAIN     SDNARRL1                           36                    MD058769
      *                                                                                       CSD031
     C     *IN36         IFEQ      *OFF
      *                                                                                       CSD031
     C                   SELECT
     C     #1LACT        WHENEQ    'I'
     C                   MOVE      'A'           WACTN
     C                   OTHER
     C                   MOVE      #1LACT        WACTN
     C                   ENDSL
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C                   SELECT
     C     #1LACT        WHENEQ    'A'
     C                   MOVE      'I'           WACTN
     C     #1LACT        WHENEQ    'D'
     C                   MOVE      *BLANK        WACTN
     C                   OTHER
     C                   MOVE      #1LACT        WACTN
     C                   ENDSL
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
      ** This overrides the narrative code details retrieved earlier.                         CSD031
      *                                                                                       CSD031
     C*****#1NVCD        CHAIN     SDANARL0                           36                    MD059769
      *                                                                                       CSD031
     C     *IN36         IFEQ      *OFF
      *                                                                                       CSD031
     C                   SELECT
      *                                                                                       CSD031
     C     WACTN         WHENEQ    'I'
     C                   Z-ADD     BJRDNB        ALLCD
     C                   MOVE      WACTN         ALTYLC
     C                   Z-ADD     BJRDNB        ALEACC
     C**********         WRITE     @ALRECZ                                                  MD058769
      *                                                                                       CSD031
     C                   Z-ADD     1             WUNORC
     C                   Z-ADD     *ZERO         WUNOAM
     C                   Z-ADD     *ZERO         WUNODL
     C                   Z-ADD     1             WUNOIN
     C                   EXSR      SBCHRC
      *                                                                                       CSD031
     C     WACTN         WHENEQ    'A'
     C                   MOVE      @1DBRC        WNARR
     C*****#1NVCD        CHAIN     SDNARRL0                           37                    MD058769
     C     *IN37         IFEQ      *OFF
     C                   MOVE      WNARR         @1DBRC
     C                   Z-ADD     BJRDNB        ALLCD
     C                   MOVE      WACTN         ALTYLC
     C                   Z-ADD     BJRDNB        ALEACC
     C**********         UPDATE    @ALRECZ                                                  MD058769
      *                                                                                       CSD031
     C                   Z-ADD     *ZERO         WUNORC
     C                   Z-ADD     *ZERO         WUNOIN
     C                   Z-ADD     *ZERO         WUNODL
     C                   Z-ADD     1             WUNOAM
     C                   EXSR      SFCHRC
     C                   ENDIF
      *                                                                                       CSD031
     C     WACTN         WHENEQ    'D'
     C*****#1NVCD        CHAIN     SDNARRL0                           37                    MD058769
     C     *IN37         IFEQ      *OFF
     C**********         DELETE    @ALRECZ                                                  MD058769
      *                                                                                       CSD031
     C                   Z-ADD     -1            WUNORC
     C                   Z-ADD     1             WUNODL
     C                   Z-ADD     *ZERO         WUNOIN
     C                   Z-ADD     *ZERO         WUNOAM
     C                   EXSR      SDCHRC
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDSL
      *                                                                                       CSD031
     C**********         DELETE    SDNARRD0                                                 MD058769
     C                   ENDIF
      *                                                                                       CSD031
     C                   MOVE      *OFF          *IN98
     C                   EXSR      FBRQRL
      *                                                                                       CSD031
     C                   ENDSR
      *****************************************************************                       CSD031
      /EJECT                                                                                  CSD031
      *****************************************************************                       CSD031
     CSR   SRSEND        BEGSR
      *================================================================                       CSD031
      * Setup details and send message to data queue                                          CSD031
      *================================================================                       CSD031
     C                   MOVEL     'GPNARRPD'    WPFNAM
     C                   MOVEL     #1NVCD        WKEYS
     C                   MOVEL     @1DBRC        WDATA
     C                   MOVEL     WDTQ          PDQMSG
     C     'SD'          CAT       'ACCPDTQ'     PDQNAM           10
      *                                                                                       CSD031
     C     *LOVAL        SETLL     GPZONEL0
     C                   READ      GPZONEL0                               90
     C     *IN90         DOWEQ     *OFF
     C     ZOMSYS        CAT       'DPLIB'       PDQLIB
     C********** ZOMSYS    CAT  PGMB      PGMNAM 16                                    CSD031 CSC043
     C     ZOMSYS        CAT       PGMB          PGMNAM           17
     C                   CALL      PGMNAM
     C                   PARM                    PDQNAM
     C                   PARM                    PDQLIB           10
     C                   PARM                    PDQMSG
     C                   READ      GPZONEL0                               90
     C                   ENDDO
      *================================================================                       CSD031
     CSR                 ENDSR
      /EJECT                                                                                  CSD031
     CSR   SRACPT        BEGSR
      *================================================================                       CSD031
      * Acceptance Screen                                                                     CSD031
      *================================================================                       CSD031
     C                   MOVE      *OFF          *IN67
     C                   MOVE      *OFF          *IN70
     C                   MOVE      *OFF          *IN73
     C                   MOVE      *ON           *IN72
     C                   MOVE      *ON           *IN66
     C                   MOVE      *ON           *IN76
     C                   MOVE      *ON           *IN69
     C                   MOVEL     HEAD3(2)      #2HEA3
     C                   WRITE     #SFLCTL
     C                   EXSR      FBRQRL
      *================================================================                       CSD031
     CSR                 ENDSR
      /EJECT                                                                                  CSD031
     O*Narrative codes maintenance    Initialise Program O-Spec
     C*COPY*ZSRSRC,ZDATE1Z2                                                          CSD031 MD058769
     C/COPY ZSRSRC,ZDATE1Z2LE                                                               MD058769
     O/COPY WNCPYSRC,SD0080MOPG
** CPY@     : Copyright notice for inclusion in all programs
(c) Finastra International Limited 2001
** OVRC                                                                                       CSD031
OVRDBF FILE(GZSDBANK) TOFILE(GZSDBANKL2)                                                      CSD031
** HEAD3                                                                                      CSD031
    Narrative Codes Maintenance                                                               CSD031
    Narrative Codes For Acceptance                                                            CSD031
Central Narrative Codes Maintenance                                                           CSD031
** ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN                                            CSD031
0366073110961461                                                                              CSD031
** ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR                                              CSD031
000031059090120151181212243273304334365                                                       CSD031
