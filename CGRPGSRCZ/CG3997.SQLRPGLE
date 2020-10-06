     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
     H*CVTOPT*(*GRAPHIC)***********************************************            MD054955 MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/**** *  RPGBNOCVT                                                    *              CSD053 MD054955
/**** *  RPGCVTOPT1                                                   *              CSD053 MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG Standard group-set details')                  *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG3997  - - - - Provide standard group set values.           *
     F*                                                               *
     F*  Function:   - - This program is executed for group set       *
     F*                   9999. It is passed a list of up to 20       *
     F*                   RDEs, and returns the corresponding         *
     F*                   values for each.                            *
     F*                                                               *
     F*  Called by:  - - CG3999 (Format data string)                  *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD054955           Date 16Dec19               *
      *                 MD046248           Date 27Oct17               *
      *                 CCG024             Date 29Sep16               *
      *                 MD039544           Date 30Jun16               *
      *                 CSD090             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22356           Date 22Jan09               *
      *                 CER038             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241599             Date 08Sep06               *
      *                 CPK025             Date 29Aug06               *
      *                 CSD053             Date 01Jun06               *
      *                 CCG018             Date 26Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG2330            Date 29Apr04               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 205145             Date 24Apr02               *
      *                 CCG015             Date 10Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                 137426             Date 22Jul98               *
     F*                 088481             DATE 01JUN95               *
     F*                 087018             DATE 03MAY95               *
     F*                 086244             DATE 06APR95               *
     F*                 086154             DATE 16MAR95               *
     F*                 086157             DATE 16MAR95               *
     F*                 S01522             DATE 16MAR95               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD and CGCDSHPD *
      *             to readable unicode equivalent.                   *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG024 - Use Atlernate Name and Address in Correspondence    *
      *  MD039544 - Introduce System Value 'CMAddrFromAddCustInf' to  *
      *             extract address from 'Additional Customer         *
      *             Information' tab.                                 *
      *  CSD090 - Customer Segmentation and Overdraft                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22356 - Customer address line 5 is missing                *
      *  CER038 - Additional fields added to Correspondence           *
      *  241599 - Apply fix 142187.                                   *
      *  142187 - Fields ##ADD1 and ##ADD2 for UDC customer sender    *
      *           are not correct and replaced by #SADD1 and #SADD2.  *
      *  CPK025 - MidasPlus 1.3 packaging.  Field name conflict.      *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *         - (Recompile)                                         *
      *  CCG018 - Extract all purpose field for Corr. Manager.        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
     F*  BUG2330- CG programs looking at wrong dataarea for CSC022    *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
     F*  205145 - Midas System Prefix                                 *
      *  CCG015 - Correspondence Manager Phase 1                      *
     F*  137426 - Create a new RDE 'Print Address Label' in the       *
     F*           SYSTEM Group Set.                                   *
     F*  088481 - Primary correspondent type not set up.              *
     F*  087018 - Formatting of item number still not right           *
     F*  086244 - Add processing for PDAT                             *
     F*           Also add time for Run Date                          *
     F*  086154 - Correct Formatting of rundate                       *
     F*  086157 - Allow load of Address elements                      *
     F*  S01522 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  Indicator usage                                              *
     F*  ~~~~~~~~~~~~~~~                                              *
     F*  81 -- Element found in RDE array.                            *
     F*  90 -- Error detected.                                        *
     F*  91 -- Record not found in file CGUDCRL0.                     *
     F*  92 -- Record not found in file CGCORRL0 or CGCORRL4.         *
     F*  93 -- Record not found in file SDCUSTL0.                     *
     F*  94 -- Record not found in file SDBRCHL0.                     *
     F*  95 -- Error detected from call to AOSARDR0                   *                       CCG015
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  Subroutine usage                                             *
     F*  ~~~~~~~~~~~~~~~~                                             *
     F*  SRMTCH -- Match entered RDEs to those in array RDE.          *
     F*  SRLOAD -- Load arrays RDE and DTA.                           *
     F*  SRCADD -- Retrieve correspondent details.                    *
     F*  SRSADD -- Retrieve sender's details.                         *
     F*  SREXPG -- Exit the program.                                  *
     F*  SRINIT -- Provide initialisation and definitions.            *
     F*                                                               *
     F*  Copied in routines:                                          *
     F*                                                               *
     F*  *PSSR  -- Program error routine.                             *
     F*  SRFILE -- File error routine.                                *
     F*  SRERR  -- Error reporting routine.                           *
     F*                                                               *
     F*****************************************************************
     F/SPACE
     F*-------------------------------------------------------------------
     F* Copied-in file definitions:
     F*
     F/COPY WNCPYSRC,CG3997FPG
     F*===================================================================
     FSDCUSTL0  IF   E           K DISK
     F                                     INFSR(SRFILE)
     F* Customer details
     F*-------------------------------------------------------------------
     FCGCORRL4  IF   E           K DISK
     F                                     INFSR(SRFILE)
     F* Correspondent details by customer number
     F*-------------------------------------------------------------------
     FCGCORRL0  IF   E           K DISK
     F                                     INFSR(SRFILE)
     F* Correspondent details by correspondent
     F*-------------------------------------------------------------------
     FSDBRCHL0  IF   E           K DISK
     F                                     INFSR(SRFILE)
     F* Branch details
     F*-------------------------------------------------------------------
     FCGUDCRL0  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F* UDC data reference details
     F*-------------------------------------------------------------------
     FCGXDCRL0  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F* UDC data reference details - ARCHIVE
     F*-------------------------------------------------------------------
     F*CGRDTAL1* IF   E           K DISK    USROPN                                          MD054955
     F**********                            INFSR(SRFILE)                                   MD054955
     F* UDC RDE master reference
     FCGAPFDPD  IF   E           K DISK
     F                                     INFSR(SRFILE)
      *                                                                                       CSD090
      ** Midas SD Customer Marketing Groups                                                   CSD090
      *                                                                                       CSD090
     FSDCMRKL0  IF   E           K DISK
      *                                                                                       CSD090
     F* All Purposed Field File                                                               CCG018
     F*-------------------------------------------------------------------                    CCG018
     FSDACUSL0  IF   E           K DISK                                                           MD
     F                                     INFSR(SRFILE)                                          MD
     F* Additional Customer details                                                         MD039544
     F*-------------------------------------------------------------------
     D/EJECT
     D*-------------------------------------------------------------------
     D* Error processing array:
     D*
     D*COPY*CGCPYSRC,SRERRE                                                                 MD054955
      /COPY CGCPYSRC,SRERRDLE                                                               MD054955
     D*
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
     D ##R             S             22    DIM(20)                              RDEs required.
     D ##D             S            256    DIM(20)                              Data returned.
     D ##S             S            256    DIM(20)                              Data string.
     D RDE             S             10    DIM(100) CTDATA PERRCD(1)            RDEs known.
     D DTA             S            256    DIM(100)                             Data for RDEs.
     D*
     D* Copied-in array definitions:
     D*
     D/COPY WNCPYSRC,CG3997EPG
     D*
     D*-------------------------------------------------------------------
     D/SPACE
     D*-------------------------------------------------------------------
     D/COPY WNCPYSRC,CG3997IPG
     D*
     D* Copied-in data structures
     D*
     D*...................................................................
      *                                                                                       CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      *                                                                                       CSC022
     D WCMT            S             10    DIM(10)
      *
      *                                                                                       CER038
     D                 DS                  INZ
     D  UADDR                  1    200
     D  UADD1                  1     50
     D  UADD2                 51    100
     D  UADD3                101    150
     D  UADD4                151    200
      *                                                                                       CER038
     D WSVL1           C                   CONST('Country')
     D WSVLK1          C                   CONST('CorrLine5Details')
     D WSVLK2          C                   CONST('CMAddrFromAddCustInf')                          MD
      *                                                                                       CER038
      ** Data Structure                                                                       CER038
      *                                                                                       CER038
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *                                                                                       CER038
     D SDALTN        E DS                  EXTNAME(SDALTNPD)
     D CGRDTA        E DS                  EXTNAME(CGRDTJW0)                                MD054955
     C*COPY*CGCPYSRC,SRERRI                                                                 MD054955
     D*COPY*CGCPYSRC,SRPGN                                                                  MD054955
     D/COPY CGCPYSRC,SRPGNLE                                                                MD054955
     D*
     D* Error processing data structures
     D*
     D*...................................................................
     D BIGLDA        E DS                  EXTNAME(CGLDA)
     D*
     D* Local data area
     D*
     D WDSJOB        E DS                  EXTNAME(SCCMTJOB)
     D  WCMTNO       E                     EXTFLD(COMITNUM)
     D  WJOB01       E                     EXTFLD(COMITJOB1)
     D  WJOB02       E                     EXTFLD(COMITJOB2)
     D  WJOB03       E                     EXTFLD(COMITJOB3)
     D  WJOB04       E                     EXTFLD(COMITJOB4)
     D  WJOB05       E                     EXTFLD(COMITJOB5)
     D  WJOB06       E                     EXTFLD(COMITJOB6)
     D  WJOB07       E                     EXTFLD(COMITJOB7)
     D  WJOB08       E                     EXTFLD(COMITJOB8)
     D  WJOB09       E                     EXTFLD(COMITJOB9)
     D  WJOB10       E                     EXTFLD(COMITJOB10)
     D  WCJOBS                 4    103
      ** Commitment Control dataarea                                                          CSC022
      *                                                                                       CSC022
     D RUNDTA        E DS                  EXTNAME(RUNDAT)                      086154
     D*                                                                   086154
     D* Get Rundate - Rundate  *                                          086154
     D*                                                                   086154
     D STATDT        E DS                  EXTNAME(SDSTAT)                      205145
     D*                                                                   205145
     D* Standing Data                                                     205145
     D*                                                                   205145
     D DECLIT          C                   CONST('*DEC')
      *                                                                   087018
     D                 DS                                                       087018
     D  @@ITEM                 1      8                                         087018
     D  @@ITMN                 1      8  0                                      087018
      ** Used to convert item reference from character to numeric         087018
      *                                                                   087018
      *                                                                                       CCG015
      ** Timestamp for Correspondence Manager                                                 CCG015
      ** Format CCYY-MM-DD.HH:MM:SS                                                           CCG015
     D ##TMST          DS
     D  ##TSYY                 1      4
     D  ##TSH1                 5      5
     D  ##TSMM                 6      7
     D  ##TSH2                 8      8
     D  ##TSDD                 9     10
     D  ##TSP1                11     11
     D  ##TSHH                12     13
     D  ##TSC1                14     14
     D  ##TSMN                15     16
     D  ##TSC2                17     17
     D  ##TSSS                18     19
      *                                                                                       CCG015
      ** Date 8                                                                               CCG015
      ** Format CCYYMMDD                                                                      CCG015
     D ##DT8           DS
     D  ##D8YY                 1      4
     D  ##D8MM                 5      6
     D  ##D8DD                 7      8
      *                                                                                       CCG015
      ** Time 6                                                                               CCG015
      ** Format HHMMSS                                                                        CCG015
     D ##TM6           DS
     D  ##T6HH                 1      4
     D  ##T6MN                 5      6
     D  ##T6SS                 7      8
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      **  Sar Text details                                                                    CCG015
      *                                                                                       CCG015
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *                                                                                       CSD090
      * Data Structures used by Access Programs                                               CCG015
      *                                                                                       CCG015
     D APFDS           DS
     D  PR2P                   1      1
      * Data Structures used by AllPurposeField                                               CCG018
      *                                                                                       CCG018
      * DATA STRUCTURE FOR AOSVALR0 STRING                                                    CCG024
     D                 DS
     D  PSVL3                  1    200
     D  PSVL31                 1      1
      *                                                                                       CCG024
     D                 DS
     D  #@CORR                 1     10
     D  AZCD                   8      8
      * System Value                                                                          CCG024
     D                 DS
     D  WSVLK3                 1     20    INZ('RecipientSpecialChar')
      *
      * Rename field for CGAPFDPD                                                             CPK025
     I@APFDPD
     I              PR2P                        XPR2P
      *                                                                                       CCG024
     I********************************************************************
     C/EJECT
     C********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN
     C                   PARM                    P0ACT
     C                   PARM                    ##R
     C                   PARM                    ##D
     C                   PARM                    ##S
     C*
     C* Add subroutine name to stack:
     C*
     C                   Z-ADD     1             Q
     C                   MOVEL     '@Main@'      @STK(Q)
     C*
     C* Initialise:
     C                   EXSR      SRINIT
     C*
     C* If not done, or if the item or correspondent has changed,
     C*  load the data array (DTA) for later selection:
     C*
     C     W0DONE        IFNE      'Y'
     C     #@ITEM        ORNE      SVITEM
     C     #@DCOR        ORNE      SVDCOR
     C                   EXSR      SRLOAD
     C                   MOVE      'Y'           W0DONE            1
     C                   MOVE      #@ITEM        SVITEM
     C                   MOVE      #@DCOR        SVDCOR
     C                   ENDIF
     C*
     C* For each RDE passed, return any corresponding values known:
     C*
     C                   EXSR      SRMTCH
     C*
     C* Exit program:
     C                   EXSR      SREXPG
     C*
     C                   RETURN
     C********************************************************************
     C/EJECT
     C     *INZSR        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     '*INZSR'      @STK(Q)
      *                                                                                       CCG015
      **  Check if Correspondence Manager is switched on                                      CCG015
      *                                                                                       CCG015
     C                   CALL      'AOSARDR0'                           95
     C                   PARM      '       '     #RTCD             7
     C                   PARM      '*VERIFY'     ##OPTN            7
     C                   PARM      'CCG015'      ##SARD            8
     C     SCSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CCG015
      **  If the Access Object returns an error code, process a                               CCG015
      **  database error.                                                                     CCG015
      *                                                                                       CCG015
     C     #RTCD         IFNE      *BLANK
     C     #RTCD         ANDNE     '*NRF   '
     C     *IN95         OREQ      *ON
     C                   MOVEL     'AOSARDR0'    W0FILE                         ***************
     C                   MOVEL     'CCG015'      W0KEY                          * DB ERROR 03 *
     C                   Z-ADD     03            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CCG015
     C     #RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CCG015            1
     C                   ELSE
     C                   MOVEL     'N'           CCG015
     C                   ENDIF
      *
     C                   CALL      'AOSARDR0'                           95
     C                   PARM      '       '     #RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CER038'      ##SARD
     C     SCSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CER038
     C     #RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CER038            1
     C                   ELSE
     C                   MOVEL     'N'           CER038
     C                   ENDIF
      *                                                                                       CSD090
      ** Access SAR details file to determine if CSD090 switchable feature                    CSD090
      ** is switched on                                                                       CSD090
      *                                                                                       CSD090
     C                   MOVE      'N'           CSD090            1
      *                                                                                       CSD090
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD090'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSD090
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*NRF'
     C                   MOVEL     'AOSARDR0'    W0FILE
     C                   MOVEL     'CSD090'      W0KEY
     C                   Z-ADD     22            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ELSE
     C                   MOVE      'Y'           CSD090
     C                   ENDIF
      *                                                                                       CER038
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       #RTCD
     C                   PARM      '*FIRST'      ##OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *                                                                                       CER038
     C                   MOVEL     WSVLK1        PSVLK1
     C                   MOVEL     *BLANKS       WCORR5
     C                   MOVEL     WSVLK2        PSVLK2
     C                   MOVEL     *BLANKS       ADDTNL
      *                                                                                       CER038
     C                   CALL      'AOSVALR0'
     C                   PARM                    PRTCD             7
     C                   PARM                    PSVLK1           20
     C                   PARM                    PSVL1           200
     C                   PARM                    PSVLK2           20
     C                   PARM                    PSVL2           200
     C                   PARM                    PSVLK3           20
     C                   PARM                    PSVL3           200
     C                   PARM                    PSVLK4           20
     C                   PARM                    PSVL4           200
     C                   PARM                    PSVLK5           20
     C                   PARM                    PSVL5           200
     C                   PARM                    PSVLK6           20
     C                   PARM                    PSVL6           200
     C                   PARM                    PSVLK7           20
     C                   PARM                    PSVL7           200
     C                   PARM                    PSVLK8           20
     C                   PARM                    PSVL8           200
     C                   PARM                    PSVLK9           20
     C                   PARM                    PSVL9           200
     C                   PARM                    PSVLK0           20
     C                   PARM                    PSVL0           200
      *                                                                                       CER038
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     PSVL1         WCORR5            7
     C                   MOVEL     PSVL2         ADDTNL            1
     C                   ENDIF
      *                                                                                       CER038
      *                                                                                       CCG024
      * Check if CCG024 is switched on                                                        CCG024
     C                   CALL      'AOSARDR0'
     C                   PARM                    PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CCG024'      PSARD
      *                                                                                       CCG024
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CCG024            1
     C                   ELSE
     C                   MOVE      'N'           CCG024
     C                   ENDIF
      *                                                                                       CCG024
      * Check System Value RecipientSpecialChar                                               CCG024
     C     CCG024        IFEQ      'Y'
      *                                                                                       CCG024
     C                   MOVEL     WSVLK3        PSVLK3
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PSVLK1
     C                   PARM                    PSVL1
     C                   PARM                    PSVLK2
     C                   PARM                    PSVL2
     C                   PARM                    PSVLK3
     C                   PARM                    PSVL3
     C                   PARM                    PSVLK4
     C                   PARM                    PSVL4
     C                   PARM                    PSVLK5
     C                   PARM                    PSVL5
     C                   PARM                    PSVLK6
     C                   PARM                    PSVL6
     C                   PARM                    PSVLK7
     C                   PARM                    PSVL7
     C                   PARM                    PSVLK8
     C                   PARM                    PSVL8
     C                   PARM                    PSVLK9
     C                   PARM                    PSVL9
     C                   PARM                    PSVLK0
     C                   PARM                    PSVL0
      *                                                                                       CCG024
     C     PRTCD         IFNE      *BLANKS
     C     PSVL3         IFEQ      '*NRF'
     C                   MOVE      PSVLK3        DBKEY
     C                   ENDIF
      *                                                                                       CCG024
     C                   MOVEL     'SDSVALR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     21            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CCG024
     C                   ENDIF
      *                                                                                       CCG024
     C**********         OPEN      CGRDTAL1                                                 MD054955
      *
      *  Set up copyright statement
      *
     C                   CLEAR                   NUMDS
     C                   CLEAR                   DTA
      *
     C     CCG015        IFEQ      'N'
     C                   DO        100           A1                3 0
      *
     C                   MOVEL(P)  DTA(A1)       RDRDE
      *
     C*****KKRDER        CHAIN     @RDTAL1                            90                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGRDTA                                                                        MD054955
     C+ from CGRDTJW0                                                                       MD054955
     C+ where RDRDE = :RDRDE and RDRECI = 'D'                                               MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
      *
     C     *IN90         IFEQ      *OFF
      *
     C     RDELYP        IFEQ      DECLIT
     C                   MOVEL(P)  NUMDS         DTA(A1)
     C                   ELSE
     C                   MOVE      *BLANKS       DTA(A1)
     C                   END
      *
     C                   END
      *
     C                   END
     C                   ENDIF
      *
     C**********         CLOSE     CGRDTAL1                                                 MD054955
     C*                                                                   086154
     C* Get Rundate - Rundate  *                                          086154
     C*                                                                   086154
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA                                        08615
     C                   IN        RUNDTA                                                      08615
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date 08615
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date 08615
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number 08615
     C                   MOVE      AGSUC         WUSUC             1            Set up complete08615
     C                   MOVE      AGDFF         WUDFF             1            Date Format    08615
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched 08615
      *                                                                   086154
      * Format Date                                                       086154
      *                                                                   086154
     C                   Z-ADD     WURDNB        ##DAYN                                        08615
     C                   MOVEL     'D'           ##DFMT                                        08615
      *                                                                   086154
     C                   CALL      'ZA0140'                                                    08615
     C                   PARM                    ##DAYN            5 0                         08615
     C                   PARM                    ##DFMT            1                           08615
     C                   PARM                    ##DATE            6 0                         08615
     C                   PARM                    ##DATA            7                           08615
     C                   PARM                    ##RTCD            1                           08615
     C                   PARM                    ##DAT8            8 0                         08615
      *                                                                   086154
      **  Database error                                                  086154
     C     ##RTCD        IFNE      *ZERO                                                       08615
      *                                                                   086154
     C                   MOVEL     'ZA0140  '    W0FILE                         ***************08615
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 01 *08615
     C                   Z-ADD     01            W0ERNB                         ***************08615
     C                   MOVEL     'MEM5003'     W0MSGD                                        08615
     C                   MOVEL     'MIDAS  '     W0MSGF                                        08615
     C                   EXSR      SRERR                                                       08615
     C                   ENDIF                                                                 08615
      *                                                                   086154
     C                   Z-ADD     ##DAT8        NUMVAL                                        08615
     C                   MOVE      '@'           NUMEDT                                        08615
      *                                                                   086244
      * Get Time for Run Date, place after decimal point                  086244
      *                                                                   086244
     C                   TIME                    ##TIME            6 0                         08624
     C     ##TIME        DIV       1000000       ##TIM6            7 6                         08624
     C                   ADD       ##TIM6        NUMVAL                                        08624
      *                                                                   086244
     C     *LIKE         DEFINE    NUMDS         ##RUND                                        08615
      *                                                                                       CCG015
      ** Format system RDE RUND as CCYY-MM-DD.HH:MM:SS                                        CCG015
      ** for Correspondence Manager                                                           CCG015
     C     CCG015        IFEQ      'Y'
     C                   MOVEL     *BLANK        ##RND2           19
     C                   MOVEL     '-'           ##TSH1
     C                   MOVEL     '-'           ##TSH2
     C                   MOVEL     '.'           ##TSP1
     C                   MOVEL     ':'           ##TSC1
     C                   MOVEL     ':'           ##TSC2
     C                   MOVE      ##DAT8        ##DT8
     C                   MOVE      ##D8YY        ##TSYY
     C                   MOVE      ##D8MM        ##TSMM
     C                   MOVE      ##D8DD        ##TSDD
     C                   MOVE      ##TIME        ##TM6
     C                   MOVE      ##T6HH        ##TSHH
     C                   MOVE      ##T6MN        ##TSMN
     C                   MOVE      ##T6SS        ##TSSS
     C                   MOVEL     ##TMST        ##RND2
     C                   ELSE
     C                   MOVEL     NUMDS         ##RUND                                        08615
     C                   ENDIF
      *                                                                                       205145
      ** Retrieve Midas system prefix (or library group)                                      205145
     C     CCG015        IFEQ      'Y'
     C     *DTAARA       DEFINE    SDSTAT        STATDT
     C     *LIKE         DEFINE    LIBR          #SYPFX
     C                   IN        STATDT
     C                   MOVEL     LIBR          #SYPFX
     C                   ELSE
     C                   MOVEL     *BLANK        #SYPFX
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C/EJECT
     C********************************************************************
     C**  Subroutine SRMTCH handles the RDE-matching requirement.       **
     C********************************************************************
     C     SRMTCH        BEGSR                                                  * S R M T C H *
     C*
     C* Add subroutine name to stack:
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRMTCH'      @STK(Q)
     C*
     C* For each RDE (of up to 20 elements),
     C*  clear the result;
     C*  If the RDE is not blank,
     C*   seek the RDE;
     C*   If found in array RDE,
     C*    move the corresponding value from array DTA.
     C*
     C                   DO        20            #I                3 0
     C                   MOVE      *BLANKS       ##D(#I)
     C                   MOVE      ##R(#I)       ##RDE            10
     C     ##RDE         IFNE      *BLANKS
     C     ##RDE         ANDNE     *HIVAL
     C***********          Z-ADD11        #R      30         start at 11  086157
     C                   Z-ADD     1             #R                3 0            start at 1   08615
     C     ##RDE         LOOKUP    RDE(#R)                                81      ~~~~~~~~~~~
     C     *IN81         IFEQ      *ON
     C*
     C* Get destination index:
     C*
     C***        #R        SUB  10        #W      30
     C***                  MOVELDTA,#W    ##D,#I
     C                   MOVEL     DTA(#R)       ##D(#I)
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C*
     C     EXMTCH        TAG                                                    <<<=== EXMTCH
     C*
     C* Unwind subroutine stack:
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**  Subroutine SRLOAD provides initialisation.                    **
     C********************************************************************
     C     SRLOAD        BEGSR                                                  * S R L O A D *
     C*
     C* Add subroutine name to stack:
     C*
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRLOAD'      @STK(Q)
     C*
     C* Clear destination correspondent details:
     C*
     C                   MOVE      *BLANKS       #DBICC
     C                   MOVE      *BLANKS       #DBICB
     C                   MOVE      *BLANKS       #DCTYP
     C                   MOVE      *BLANKS       #DCORN
     C                   MOVE      *BLANKS       #DFATT
     C                   MOVE      *BLANKS       #DADD1
     C                   MOVE      *BLANKS       #DADD2
     C                   MOVE      *BLANKS       #DADD3
     C                   MOVE      *BLANKS       #DADD4
     C                   MOVE      *BLANKS       #DADD5
     C                   MOVE      *BLANKS       #DADD6
     C                   MOVE      *BLANKS       #DADD7
     C                   MOVE      *BLANKS       #DADD8
     C                   MOVE      *BLANKS       #DZIP
     C                   MOVE      *BLANKS       #DPLAB                                        13742
     C*
     C* Clear primary correspondent details:
     C*
     C                   MOVE      *BLANKS       #PCTYP
     C                   MOVE      *BLANKS       #PCORN
     C                   MOVE      *BLANKS       #PFATT
     C                   MOVE      *BLANKS       #PADD1
     C                   MOVE      *BLANKS       #PADD2
     C                   MOVE      *BLANKS       #PADD3
     C                   MOVE      *BLANKS       #PADD4
     C                   MOVE      *BLANKS       #PADD5
     C                   MOVE      *BLANKS       #PADD6
     C                   MOVE      *BLANKS       #PADD7
     C                   MOVE      *BLANKS       #PADD8
     C                   MOVE      *BLANKS       #PZIP
     C*
     C* Primary or secondary flag:
     C*
     C                   MOVE      'P'           #PORS             1
     C*...................................................................
     C/EJECT
     C*...................................................................
     C* Clear sender's branch details:
     C*
     C                   MOVE      *BLANKS       #SBRNM
     C                   MOVE      *BLANKS       #SADD1
     C                   MOVE      *BLANKS       #SADD2
     C                   MOVE      *BLANKS       #SADD3
     C                   MOVE      *BLANKS       #SADD4
     C                   MOVE      *BLANKS       #SADD5
     C                   MOVE      *BLANKS       #SADD6
     C                   MOVE      *BLANKS       #SADD7
     C                   MOVE      *BLANKS       #SADD8
     C                   MOVE      *BLANKS       #SFAX
     C                   MOVE      *BLANKS       #STEL
     C                   MOVE      *BLANKS       #SCREF
     C*                                                                                       CCG015
     C* Production time used by Correspondence Manager                                        CCG015
     C*                                                                                       CCG015
     C                   MOVEL     *BLANK        ##PRD2           19
     C*
     C* Get details from CGUDCRPD, SDCUSTPD, CGCORRPD and SDBRCHPD:
     C*
     C                   Z-ADD     #@ITEM        DRITEM
     C                   MOVE      #@DCOR        DRDCOR
     C*
     C* Make item character:
     C*
     C***                  MOVE #@ITEM    @@ITEM  8
     C********** *LIKE     DEFN NUMDS     @@ITEM                          087018
     C**********           CLEARNUMDS                                     087018
     C**********           Z-ADD#@ITEM    NUMVAL                          087018
     C**********           MOVELNUMDS     @@ITEM                          087018
     C                   Z-ADD     #@ITEM        @@ITMN                                        08701
     C*
     C* Seek the UDC data reference record:
     C*
     C     #@ARCH        IFEQ      'A'
     C     KKUDCR        CHAIN     CGXDCRL0                           91
     C                   ELSE
     C     KKUDCR        CHAIN     CGUDCRL0                           91
     C                   ENDIF
     C     *IN91         IFEQ      *ON
     C                   MOVE      *BLANKS       DRPCOR
     C                   MOVE      *BLANKS       DRBRCA
     C                   MOVE      *BLANKS       DRORBR
     C                   MOVE      *BLANKS       #OBRNM
     C                   MOVE      *BLANKS       DRMODI
     C***                  MOVE *BLANKS   DRMTRN
     C                   MOVE      *BLANKS       DRMTRN                                        08624
     C                   MOVE      *BLANKS       DRISTS
     C                   MOVE      *BLANKS       DRPTYP
     C                   MOVE      *BLANKS       DRPSTP
     C                   Z-ADD     *ZEROS        DRRDNB                                        08624
     C                   Z-ADD     *ZEROS        DRATIM                                        08624
     C                   MOVE      *BLANKS       DRLGID
     C                   MOVE      *BLANKS       DRAUSR
     C                   CLEAR                   NUMDS                                         08624
     C                   MOVE      '@'           NUMEDT                                        08624
     C     CCG015        IFEQ      'N'
     C                   MOVEL     NUMDS         ##PDAT                                        08624
     C                   ELSE
     C                   MOVEL     *BLANK        ##PRD2
     C                   ENDIF
     C                   ELSE
      *                                                                   086244
      * Format Production Date and Time                                   086244
      *                                                                   086244
     C                   Z-ADD     DRRDNB        ##DAYN                                        08624
     C                   MOVEL     'D'           ##DFMT                                        08624
      *                                                                   086244
     C                   CALL      'ZA0140'                                                    08624
     C                   PARM                    ##DAYN            5 0                         08624
     C                   PARM                    ##DFMT            1                           08624
     C                   PARM                    ##DATE            6 0                         08624
     C                   PARM                    ##DATA            7                           08624
     C                   PARM                    ##RTCD            1                           08624
     C                   PARM                    ##DAT8            8 0                         08624
      *                                                                   086244
      **  Database error                                                  086244
     C     ##RTCD        IFNE      *ZERO                                                       08624
      *                                                                   086244
     C                   MOVEL     'ZA0140  '    W0FILE                         ***************08624
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 02 *08624
     C                   Z-ADD     02            W0ERNB                         ***************08624
     C                   MOVEL     'MEM5003'     W0MSGD                                        08624
     C                   MOVEL     'MIDAS  '     W0MSGF                                        08624
     C                   EXSR      SRERR                                                       08624
     C                   ENDIF                                                                 08624
      *                                                                   086244
     C                   Z-ADD     ##DAT8        NUMVAL                                        08624
     C                   MOVE      '@'           NUMEDT                                        08624
      *                                                                   086244
      * Get Time for Run Date, place after decimal point                  086244
      *                                                                   086244
     C     DRATIM        DIV       1000000       ##TIM6                                        08624
     C                   ADD       ##TIM6        NUMVAL                                        08624
      *                                                                   086244
      ** Format system RDE PDAT as CCYY-MM-DD.HH:MM:SS                                        CCG015
     C     CCG015        IFEQ      'Y'
     C                   MOVEL     '-'           ##TSH1
     C                   MOVEL     '-'           ##TSH2
     C                   MOVEL     '.'           ##TSP1
     C                   MOVEL     ':'           ##TSC1
     C                   MOVEL     ':'           ##TSC2
     C                   MOVE      ##DAT8        ##DT8
     C                   MOVE      ##D8YY        ##TSYY
     C                   MOVE      ##D8MM        ##TSMM
     C                   MOVE      ##D8DD        ##TSDD
     C                   MOVE      ##TIME        ##TM6
     C                   MOVE      ##T6HH        ##TSHH
     C                   MOVE      ##T6MN        ##TSMN
     C                   MOVE      ##T6SS        ##TSSS
     C                   MOVEL     ##TMST        ##PRD2
     C                   ELSE
     C     *LIKE         DEFINE    NUMDS         ##PDAT                                        08624
     C                   MOVEL     NUMDS         ##PDAT                                        08624
     C                   ENDIF
     C*
     C* If a primary correspondent is given, this record is secondary:
     C*
     C***********DRPCOR    IFNE *BLANKS                                   086244
     C     DRPCOR        IFNE      DRDCOR                                                      08624
     C                   MOVE      'S'           #PORS
     C                   ENDIF
     C*...................................................................
     C/EJECT
     C*...................................................................
     C* If an originating branch code is given,
     C*  retrieve the originating branch name:
     C*
     C     DRORBR        IFNE      *BLANKS
     C     DRORBR        CHAIN     SDBRCHL0                           94
     C     *IN94         IFEQ      *OFF
     C                   MOVE      A8BRNM        #OBRNM
     C                   ENDIF
     C                   ENDIF
     C*
     C* Seek destination correspondent details:
     C*
     C                   MOVE      #@DCOR        ##CORR
     C     CER038        IFEQ      'Y'
     C                   MOVE      'N'           CFLAG             1
     C                   ENDIF
     C                   EXSR      SRCADD
     C*
     C     CER038        IFEQ      'Y'
     C     UADDR         IFNE      *BLANKS
     C                   MOVE      'Y'           CFLAG
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER038
     C                   MOVE      ##BICC        #DBICC
     C                   MOVE      ##BICB        #DBICB
     C                   MOVE      ##CTYP        #DCTYP
     C                   MOVE      ##CORN        #DCORN
     C                   MOVE      ##FATT        #DFATT
     C                   MOVE      ##ADD1        #DADD1
     C                   MOVE      ##ADD2        #DADD2
     C                   MOVE      ##ADD3        #DADD3
     C                   MOVE      ##ADD4        #DADD4
     C                   MOVE      ##ADD5        #DADD5
     C                   MOVE      ##ADD6        #DADD6
     C                   MOVE      ##ADD7        #DADD7
     C                   MOVE      ##ADD8        #DADD8
     C                   MOVE      ##ZIP         #DZIP
     C                   MOVE      ##PLAB        #DPLAB                         print addr lbl 13742
     C                   MOVE      ##FAX         #DFAX
     C                   MOVE      ##ERT         #DERT
     C                   MOVE      ##EML         #DEML
     C*
     C* Seek primary correspondent details:
     C*
     C     DRPCOR        IFNE      *BLANKS
     C                   MOVE      DRPCOR        ##CORR
     C                   EXSR      SRCADD
     C*
     C                   MOVE      ##CTYP        #PCTYP
     C                   MOVE      ##CORN        #PCORN
     C                   MOVE      ##FATT        #PFATT
     C                   MOVE      ##ADD1        #PADD1
     C                   MOVE      ##ADD2        #PADD2
     C                   MOVE      ##ADD3        #PADD3
     C                   MOVE      ##ADD4        #PADD4
     C                   MOVE      ##ADD5        #PADD5
     C                   MOVE      ##ADD6        #PADD6
     C                   MOVE      ##ADD7        #PADD7
     C                   MOVE      ##ADD8        #PADD8
     C                   MOVE      ##ZIP         #PZIP
     C                   MOVE      ##FAX         #PFAX
     C                   MOVE      ##EML         #PEML
      *                                                                                       CSD090
      ** Get Additional Customer Segmentation Code                                            CSD090
      *                                                                                       CSD090
     C     CSD090        IFEQ      'Y'
     C                   MOVEL     ##CORR        PCUSNO            6
     C     PCUSNO        CHAIN     SDCMRKL0                           97
     C     *IN97         IFEQ      *OFF
      *                                                                                       CSD090
      ** Customer Segmentation Code                                                           CSD090
      *                                                                                       CSD090
     C                   MOVEL     D7CSDE        #DCSEG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*...................................................................
     C/EJECT
     C*...................................................................
     C* Seek sender's details:
     C*
     C                   EXSR      SRSADD
     C*
     C* End if UDC record found:
     C*
     C                   ENDIF
     C*...................................................................
     C*
     C* Clear the output data array:
     C*
     C***                  DO   100       @D      30
     C***                  MOVE *BLANKS   DTA,@D
     C***                  ENDDO
      *
     C                   RESET                   DTA
     C*
     C* Now we may finally load array DTA with the appropriate values:
     C*            ~~~~~~~
     C                   MOVEL     '00000000'    DTA(1)                          copy
     C                   MOVEL     #DADD1        DTA(2)                          daddr1
     C                   MOVEL     #DADD2        DTA(3)                          daddr2
     C                   MOVEL     #DADD3        DTA(4)                          daddr3
     C                   MOVEL     #DADD4        DTA(5)                          daddr4
     C     CER038        IFEQ      'Y'
     C     WCORR5        ANDEQ     WSVL1
     C     #DADD5        IFEQ      *BLANKS
     C     CFLAG         ANDEQ     'N'
     C**********           MOVE #@DCOR    WFLD6   6                                  CER038 BUG22356
     C     #@DCOR        CHAIN     CGCORRL0                           92
     C     *IN92         IFEQ      *OFF
     C                   MOVE      CDCUST        WFLD6             6
     C                   ENDIF
      *                                                                                     BUG22356
     C     WFLD6         CHAIN     SDCUSTL0                           93
     C     *IN93         IFNE      *ON
     C     BBCOLC        ANDNE     BJCNCD
      *                                                                                       CER038
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    BBCOLC
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *                                                                                       CER038
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     A4CNNM        #DADD5
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER038
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER038
     C                   MOVEL     #DADD5        DTA(6)                          daddr5
     C                   MOVEL     #DADD6        DTA(7)                          daddr6
     C                   MOVEL     #DADD7        DTA(8)                          daddr7
     C                   MOVEL     #DADD8        DTA(9)                          daddr8
     C                   MOVEL     #DBICC        DTA(10)                         dbica
     C                   MOVEL     #DBICB        DTA(11)                         dbicb
     C                   MOVEL     #@DCOR        DTA(12)                         dcorr
     C                   MOVEL     #DFATT        DTA(13)                         dfao
     C*********************MOVEL#DCORN    DTA,14            dname                             CCG015
     C*********************MOVEL#DCTYP    DTA,15            dtype                             CCG015
     C*********************MOVEL#DZIP     DTA,16            dzip                              CCG015
     C*********************MOVEL@@ITEM    DTA,17            item_id                           CCG015
     C*********************MOVELDRMODI    DTA,18            mmod                              CCG015
     C*********************MOVELDRMTRN    DTA,19            mtrn                       086244 CCG015
     C*********************MOVEL#OBRNM    DTA,20            obnam                             CCG015
     C*********************MOVELDRORBR    DTA,21            obrch                             CCG015
     C*********************MOVEL#PADD1    DTA,22            paddr1                            CCG015
     C*********************MOVEL#PADD2    DTA,23            paddr2                            CCG015
     C*********************MOVEL#PADD3    DTA,24            paddr3                            CCG015
     C*********************MOVEL#PADD4    DTA,25            paddr4                            CCG015
     C*********************MOVEL#PADD5    DTA,26            paddr5                            CCG015
     C*********************MOVEL#PADD6    DTA,27            paddr6                            CCG015
     C*********************MOVEL#PADD7    DTA,28            paddr7                            CCG015
     C*********************MOVEL#PADD8    DTA,29            paddr8                            CCG015
     C*...................................................................
     C/EJECT
     C*...................................................................
     C*********************MOVEL'00000000'DTA,30            page                              CCG015
     C*********************MOVELDRPCOR    DTA,31            pcorr                             CCG015
      *                                                                   086244
      *  Add PDAT to output                                               086244
      *                                                                   086244
     C***********          MOVEL#PFATT    DTA,32            pfao          086244
     C***********          MOVEL#PCORN    DTA,33            pname         086244
     C***********          MOVEL#PORS     DTA,34            pors          086244
     C***********          MOVE *BLANKS   DTA,35            pctype        086244
     C***********          MOVELDRPSTP    DTA,36            psbtp         086244
     C***********          MOVELDRPTYP    DTA,37            ptype         086244
     C***********          MOVEL#PZIP     DTA,38            pzip          086244
     C***********          MOVEL'00000000'DTA,39            rund          086244
     C***********          MOVEL##RUND    DTA,39            rund    086154086244
     C***********          MOVEL#SADD1    DTA,40            saddr1        086244
     C***********          MOVEL#SADD2    DTA,41            saddr2        086244
     C***********          MOVEL#SADD3    DTA,42            saddr3        086244
     C***********          MOVEL#SADD4    DTA,43            saddr4        086244
     C***********          MOVEL#SADD5    DTA,44            saddr5        086244
     C***********          MOVEL#SADD6    DTA,45            saddr6        086244
     C***********          MOVEL#SADD7    DTA,46            saddr7        086244
     C***********          MOVEL#SADD8    DTA,47            saddr8        086244
     C***********          MOVEL#SBRNM    DTA,48            sbnam         086244
     C***********          MOVEL#SCREF    DTA,49            sclr          086244
     C***********          MOVEL#SFAX     DTA,50            sfax          086244
     C***********          MOVEL#STEL     DTA,51            sphon         086244
     C***********          MOVELDRISTS    DTA,52            status        086244
     C*********************MOVEL##PDAT    DTA,32            pdat    086244                    CCG015
     C*********************MOVEL#PFATT    DTA,33            pfao    086244                    CCG015
     C*********************MOVEL#PCORN    DTA,34            pname   086244                    CCG015
     C*********************MOVEL#PORS     DTA,35            pors    086244                    CCG015
     C***********          MOVE *BLANKS   DTA,36            pctype  086244088481
     C*********************MOVEL#PCTYP    DTA,36            pctype  088481                    CCG015
     C***********          MOVELDRPSTP    DTA,37            psbtp   086244137426
     C***********          MOVELDRPTYP    DTA,38            ptype   086244137426
     C***********          MOVEL#PZIP     DTA,39            pzip    086244137426
     C***********          MOVEL##RUND    DTA,40            rund    086244137426
     C***********          MOVEL#SADD1    DTA,41            saddr1  086244137426
     C***********          MOVEL#SADD2    DTA,42            saddr2  086244137426
     C***********          MOVEL#SADD3    DTA,43            saddr3  086244137426
     C***********          MOVEL#SADD4    DTA,44            saddr4  086244137426
     C***********          MOVEL#SADD5    DTA,45            saddr5  086244137426
     C***********          MOVEL#SADD6    DTA,46            saddr6  086244137426
     C***********          MOVEL#SADD7    DTA,47            saddr7  086244137426
     C***********          MOVEL#SADD8    DTA,48            saddr8  086244137426
     C***********          MOVEL#SBRNM    DTA,49            sbnam   086244137426
     C***********          MOVEL#SCREF    DTA,50            sclr    086244137426
     C***********          MOVEL#SFAX     DTA,51            sfax    086244137426
     C***********          MOVEL#STEL     DTA,52            sphon   086244137426
     C***********          MOVELDRISTS    DTA,53            status  086244137426
     C*********************                                                                   CCG015
     C*********************MOVEL#DPLAB    DTA,37            paddrlabel137426                  CCG015
     C*********************MOVELDRPSTP    DTA,38            psbtp   137426                    CCG015
     C*********************MOVELDRPTYP    DTA,39            ptype   137426                    CCG015
     C*********************MOVEL#PZIP     DTA,40            pzip    137426                    CCG015
     C*********************MOVEL##RUND    DTA,41            rund    137426                    CCG015
     C*********************MOVEL#SADD1    DTA,42            saddr1  137426                    CCG015
     C*********************MOVEL#SADD2    DTA,43            saddr2  137426                    CCG015
     C*********************MOVEL#SADD3    DTA,44            saddr3  137426                    CCG015
     C*********************MOVEL#SADD4    DTA,45            saddr4  137426                    CCG015
     C*********************MOVEL#SADD5    DTA,46            saddr5  137426                    CCG015
     C*********************MOVEL#SADD6    DTA,47            saddr6  137426                    CCG015
     C*********************MOVEL#SADD7    DTA,48            saddr7  137426                    CCG015
     C*********************MOVEL#SADD8    DTA,49            saddr8  137426                    CCG015
     C*********************MOVEL#SBRNM    DTA,50            sbnam   137426                    CCG015
     C*********************MOVEL#SCREF    DTA,51            sclr    137426                    CCG015
     C*********************MOVEL#SFAX     DTA,52            sfax    137426                    CCG015
     C*********************MOVEL#STEL     DTA,53            sphon   137426                    CCG015
     C*********************MOVELDRISTS    DTA,54            status  137426                    CCG015
     C                   MOVEL     #DCORN        DTA(15)                         dname
     C                   MOVEL     #DCTYP        DTA(19)                         dtype
     C                   MOVEL     #DZIP         DTA(20)                         dzip
     C                   MOVEL     @@ITEM        DTA(22)                         item_id
     C                   MOVEL     DRMODI        DTA(25)                         mmod
     C                   MOVEL     DRMTRN        DTA(26)                         mtrn
     C                   MOVEL     #OBRNM        DTA(27)                         obnam
     C                   MOVEL     DRORBR        DTA(28)                         obrch
     C                   MOVEL     #PADD1        DTA(29)                         paddr1
     C                   MOVEL     #PADD2        DTA(30)                         paddr2
     C                   MOVEL     #PADD3        DTA(31)                         paddr3
     C                   MOVEL     #PADD4        DTA(32)                         paddr4
     C                   MOVEL     #PADD5        DTA(33)                         paddr5
     C                   MOVEL     #PADD6        DTA(34)                         paddr6
     C                   MOVEL     #PADD7        DTA(35)                         paddr7
     C                   MOVEL     #PADD8        DTA(36)                         paddr8
     C                   MOVEL     '00000000'    DTA(37)                         page
     C                   MOVEL     DRPCOR        DTA(38)                         pcorr
     C     CCG015        IFEQ      'N'
     C                   MOVEL     ##PDAT        DTA(39)                         pdat
     C                   ELSE
     C                   MOVEL     ##PRD2        DTA(39)                         pdat
     C                   ENDIF
     C                   MOVEL     #PFATT        DTA(40)                         pfao
     C                   MOVEL     #PCORN        DTA(41)                         pname
     C                   MOVEL     #PORS         DTA(42)                         pors
     C                   MOVEL     #PCTYP        DTA(43)                         pctype
     C                   MOVEL     #DPLAB        DTA(47)                         paddrlabel
     C                   MOVEL     DRPSTP        DTA(48)                         psbtp
     C                   MOVEL     DRPTYP        DTA(49)                         ptype
     C                   MOVEL     #PZIP         DTA(50)                         pzip
     C     CCG015        IFEQ      'N'
     C                   MOVEL     ##RUND        DTA(53)                         rund
     C                   ELSE
     C                   MOVEL     ##RND2        DTA(53)                         rund
     C                   ENDIF
     C                   MOVEL     #SADD1        DTA(54)                         saddr1
     C                   MOVEL     #SADD2        DTA(55)                         saddr2
     C                   MOVEL     #SADD3        DTA(56)                         saddr3
     C                   MOVEL     #SADD4        DTA(57)                         saddr4
     C                   MOVEL     #SADD5        DTA(58)                         saddr5
     C                   MOVEL     #SADD6        DTA(59)                         saddr6
     C                   MOVEL     #SADD7        DTA(60)                         saddr7
     C                   MOVEL     #SADD8        DTA(61)                         saddr8
     C                   MOVEL     #SBRNM        DTA(62)                         sbnam
     C                   MOVEL     #SCREF        DTA(63)                         sclr
     C                   MOVEL     #SFAX         DTA(64)                         sfax
     C                   MOVEL     #STEL         DTA(67)                         sphon
     C                   MOVEL     DRISTS        DTA(68)                         status
      *                                                                                       CCG015
     C     CCG015        IFEQ      'Y'
     C                   MOVEL     #DERT         DTA(14)                         dlvryrte
     C                   MOVEL     #DEML         DTA(16)                         dstemladr
     C                   MOVEL     #DFAX         DTA(17)                         dstfaxnmb
     C                   MOVEL     *BLANKS       DTA(18)                         dstwebadr
     C                   MOVEL     'Y'           DTA(21)                         generpdf
     C                   MOVEL     DRLGID        DTA(23)                         language
     C                   MOVEL     *BLANKS       DTA(24)                         mgmtprnt
     C                   MOVEL     #PEML         DTA(44)                         prcemladr
     C                   MOVEL     #PFAX         DTA(45)                         prcfaxnmb
     C                   MOVEL     *BLANKS       DTA(46)                         prcwebadr
     C                   MOVEL     *BLANKS       DTA(51)                         reprint
     C                   MOVEL     DRAUSR        DTA(52)                         requestor
     C                   MOVEL     *BLANKS       DTA(65)                         sndemladr
     C                   MOVEL     *BLANKS       DTA(66)                         sndwebadr
     C                   MOVEL     #SYPFX        DTA(69)                         system prfx
      *                                                                                       CCG018
      ** Set all purpose field                                                                CCG018
     C     *LIKE         DEFINE    DRPTYP        K#PTYP
     C     *LIKE         DEFINE    DRPSTP        K#PSTP
     C     KAPFD         KLIST
     C                   KFLD                    K#PTYP
     C                   KFLD                    K#PSTP
      *                                                                                       CCG018
     C                   CLEAR                   APFDS
      *                                                                                       CCG018
     C                   MOVEL     DRPTYP        K#PTYP
     C                   MOVEL     DRPSTP        K#PSTP
     C     KAPFD         CHAIN     CGAPFDPD                           96
     C     *IN96         IFEQ      *ON
     C                   MOVEL(P)  '*DFT'        K#PTYP
     C                   MOVEL(P)  '*DFT'        K#PSTP
     C     KAPFD         CHAIN     CGAPFDPD                           96
     C                   ENDIF
      *                                                                                       CCG018
     C     *IN96         IFEQ      *OFF
     C                   MOVEL     APFDS         DTA(70)                         all purpose field
     C                   ENDIF
     C     CSD090        IFEQ      'Y'
     C                   MOVEL     #DCSEG        DTA(71)                         customer segmentati
     C                   ENDIF
      *                                                                                       CCG018
     C                   ENDIF
     C*
     C/COPY WNCPYSRC,CG3997C001
     C     EXLOAD        TAG                                                    <<<=== EXLOAD
     C*
     C* Unwind subroutine stack:
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**  Subroutine SRCADD retrieves correspondent details.            **
     C********************************************************************
     C     SRCADD        BEGSR                                                  * S R C A D D *
     C*
     C* Add subroutine name to stack:
     C*
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRCADD'      @STK(Q)
     C*
      ** If feature CCG024 is on and special character is found in DRDCOR                     CCG024
     C                   MOVEL     'N'           XFOUND            1
     C     CCG024        IFEQ      'Y'
     C     PSVL31        SCAN      ##CORR                                 99
     C     *IN99         IFEQ      *ON
     C                   MOVEL     ##CORR        #@CORR
     C                   MOVEL     ##CORR        XXCORR            6
     C     XXCORR        CHAIN     CGCORRL4                           92
     C     *IN92         IFEQ      *ON
     C                   MOVEL     'CGCORRL4'    W0FILE
     C                   MOVEL     XXCORR        W0KEY                          ***************
     C                   Z-ADD     11            W0ERNB                         * DB ERROR 11 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   MOVEL     'Y'           XFOUND
      ** call AOALTNR0 to retireve alternate address                                          CCG024
     C                   CALL      'AOALTNR0'
     C                   PARM      '*BLANKS'     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    XXCORR
     C                   PARM                    AZCD
     C     SDALTN        PARM      SDALTN        DSFDY
     C                   MOVEL(P)  CDBICC        ##BICC
     C                   MOVEL(P)  CDBICB        ##BICB
     C                   MOVEL(P)  CDCTYP        ##CTYP
     C                   MOVEL(P)  CDCORN        ##CORN
     C                   MOVEL(P)  CDFATT        ##FATT
     C                   MOVEL(P)  BCCNA1        ##ADD1
     C                   MOVEL(P)  BCCNA2        ##ADD2
     C                   MOVEL(P)  BCCNA3        ##ADD3
     C                   MOVEL(P)  BCCNA4        ##ADD4
     C                   MOVEL(P)  BCCRTN        ##ADD5
     C                   MOVEL(P)  BCCNCD        ##ADD6
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CCG024
     C     XFOUND        IFEQ      'N'
     C* Seek values in the correspondent details file:
     C*
     C     ##CORR        CHAIN     CGCORRL0                           92
     C     *IN92         IFEQ      *OFF
     C                   MOVE      CDBICC        ##BICC
     C                   MOVE      CDBICB        ##BICB
     C                   MOVE      CDCTYP        ##CTYP
     C                   MOVE      CDCORN        ##CORN
     C                   MOVE      CDFATT        ##FATT
     C                   MOVE      CDADD1        ##ADD1
     C                   MOVE      CDADD2        ##ADD2
     C                   MOVE      CDADD3        ##ADD3
     C                   MOVE      CDADD4        ##ADD4
     C     CER038        IFEQ      'Y'
     C                   MOVE      CDADD1        UADD1
     C                   MOVE      CDADD2        UADD2
     C                   MOVE      CDADD3        UADD3
     C                   MOVE      CDADD4        UADD4
     C                   ENDIF
     C                   MOVE      CDADD5        ##ADD5
     C                   MOVE      CDADD6        ##ADD6
     C                   MOVE      CDADD7        ##ADD7
     C                   MOVE      CDADD8        ##ADD8
     C                   MOVE      CDZIP         ##ZIP
     C                   MOVE      CDPLAB        ##PLAB                                        13742
     C                   MOVE      CDFAX         ##FAX
     C                   MOVE      CDERT         ##ERT
     C                   MOVE      CDEML         ##EML
     C                   ENDIF
     C                   ENDIF
     C*...................................................................
     C/EJECT
     C*...................................................................
     C* If certain details were blank, look in SDCUSTL0:
     C*
     C     *IN92         IFEQ      *OFF
     C     CDCUST        ANDNE     *BLANKS                                                     08624
      ** If CMAddrFromAddCustInf is 'Y' look in SDACUSL0 first                              MD039544
     C     ADDTNL        IFEQ      'Y'
     C     CDCUST        CHAIN     SDACUSL0                           93
     C     *IN93         IFEQ      *OFF
     C                   MOVEL     E5CNA1        ##ADD1
     C                   MOVEL     E5CNA2        ##ADD2
     C                   MOVEL     E5CNA3        ##ADD3
     C                   MOVEL     E5CNA4        ##ADD4
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD039544
     C     CDCUST        CHAIN     SDCUSTL0                           93
     C     *IN93         IFEQ      *OFF
     C* Name:
     C     ##CORN        IFEQ      *BLANKS
     C                   MOVEL     BBCRNM        ##CORN
     C                   ENDIF
     C* Address:
     C     ##ADD1        IFEQ      *BLANKS
     C     ##ADD2        ANDEQ     *BLANKS
     C                   MOVEL     BBCNA1        ##ADD1
     C                   MOVEL     BBCNA2        ##ADD2
     C                   MOVEL     BBCNA3        ##ADD3
     C                   MOVEL     BBCNA4        ##ADD4
     C                   ENDIF
     C*
     C                   ENDIF
     C                   ENDIF
     C*
     C     EXCADD        TAG                                                    <<<=== EXCADD
     C*
     C* Unwind subroutine stack:
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**  Subroutine SRSADD retrieves the sender's details.             **
     C********************************************************************
     C     SRSADD        BEGSR                                                  * S R S A D D *
     C*
     C* Add subroutine name to stack:
     C*
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRSADD'      @STK(Q)
     C*
     C* Seek values in the branch details file:
     C*
     C     DRBRCA        CHAIN     SDBRCHL0                           94
     C     *IN94         IFEQ      *OFF
     C                   MOVE      A8BRNM        #SBRNM
     C*
     C* Seek values in the correspondent details file
     C*  for the branch's internal customer:
     C*
     C********** CDCUST    CHAINCGCORRL4             92                   087018
     C     A8BICN        CHAIN     CGCORRL4                           92                       08701
     C/COPY WNCPYSRC,CG3997C003
     C     *IN92         IFEQ      *OFF
     C                   MOVE      CDADD1        #SADD1
     C                   MOVE      CDADD2        #SADD2
     C                   MOVE      CDADD3        #SADD3
     C                   MOVE      CDADD4        #SADD4
     C                   MOVE      CDADD5        #SADD5
     C                   MOVE      CDADD6        #SADD6
     C                   MOVE      CDADD7        #SADD7
     C                   MOVE      CDADD8        #SADD8
     C                   MOVE      CDFAX         #SFAX
     C                   MOVE      CDTEL         #STEL
     C                   MOVE      CDCREF        #SCREF
     C*...................................................................
     C/EJECT
     C*...................................................................
     C* If certain details were blank, look in SDCUSTL0:
     C*
     C********** CDCUST    CHAINSDCUSTL0             93                   087018
     C     A8BICN        CHAIN     SDCUSTL0                           93                       08701
     C     *IN93         IFEQ      *OFF
     C* Address:
     C/COPY WNCPYSRC,CG3997C004
     C********** ##ADD1    IFEQ *BLANKS                                                       142187
     C********** ##ADD2    ANDEQ*BLANKS                                                       142187
     C     #SADD1        IFEQ      *BLANKS
     C     #SADD2        ANDEQ     *BLANKS
     C/COPY WNCPYSRC,CG3997C005
     C                   MOVEL     BBCNA1        #SADD1
     C                   MOVEL     BBCNA2        #SADD2
     C                   MOVEL     BBCNA3        #SADD3
     C                   MOVEL     BBCNA4        #SADD4
     C                   ENDIF
     C* Telephone:
     C     #STEL         IFEQ      *BLANKS
     C                   MOVEL     BBCTNB        #STEL
     C                   ENDIF
     C*
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*
     C     EXSADD        TAG                                                    <<<=== EXSADD
     C*
     C* Unwind subroutine stack:
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**  Subroutine SREXPG exits the program.                          **
     C********************************************************************
     C     SREXPG        BEGSR                                                  * S R E X P G *
     C*
     C* Add subroutine name to stack:
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SREXPG'      @STK(Q)
     C*
     C* /Copy point for exit processing:
     C*
     C/COPY WNCPYSRC,CG8200DEPP
     C*
     C* Copy any undisplayed messages to the caller:
     C*
     C                   CALL      'Y2CPMSC'
     C                   PARM                    ##PGM
     C*
     C* Write to the LDA:
     C                   OUT       BIGLDA
     C*
     C     EXEXPG        TAG                                                    <<<=== EXEXPG
     C*
     C* Unwind subroutine stack:
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**  Subroutine SRINIT provides initialisation.                    **
     C********************************************************************
     C     SRINIT        BEGSR                                                  * S R I N I T *
     C*
     C* Add subroutine name to stack:
     C*
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
     C*
     C* Define and clear error return code:
     C*
     C                   MOVE      *BLANKS       P0RTN             7
     C*
     C* Define the action code:
     C*
     C                   MOVE      P0ACT         P0ACT             8
     C*
     C* Move the copyright parameter:
     C*
     C                   MOVEA     CPY@          ACT@             80
     C*
     C* Get the local data area (*LDA):
     C*
     C     *DTAARA       DEFINE    *LDA          BIGLDA
     C                   IN        BIGLDA
     C*
     C* Common values:
     C*
     C     *LIKE         DEFINE    CDCORR        ##CORR
     C     *LIKE         DEFINE    CDBICC        ##BICC
     C     *LIKE         DEFINE    CDBICB        ##BICB
     C     *LIKE         DEFINE    CDCTYP        ##CTYP
     C     *LIKE         DEFINE    CDCORN        ##CORN
     C     *LIKE         DEFINE    CDFATT        ##FATT
     C     *LIKE         DEFINE    CDADD1        ##ADD1
     C     *LIKE         DEFINE    CDADD2        ##ADD2
     C     *LIKE         DEFINE    CDADD3        ##ADD3
     C     *LIKE         DEFINE    CDADD4        ##ADD4
     C     *LIKE         DEFINE    CDADD5        ##ADD5
     C     *LIKE         DEFINE    CDADD6        ##ADD6
     C     *LIKE         DEFINE    CDADD7        ##ADD7
     C     *LIKE         DEFINE    CDADD8        ##ADD8
     C     *LIKE         DEFINE    CDZIP         ##ZIP
     C     *LIKE         DEFINE    CDPLAB        ##PLAB                                        13742
     C     *LIKE         DEFINE    CDFAX         ##FAX
     C     *LIKE         DEFINE    CDERT         ##ERT
     C     *LIKE         DEFINE    CDEML         ##EML
     C*...................................................................
     C/EJECT
     C*...................................................................
     C* Destination correspondent values:
     C*
     C     *LIKE         DEFINE    CDBICC        #DBICC
     C     *LIKE         DEFINE    CDBICB        #DBICB
     C     *LIKE         DEFINE    CDCTYP        #DCTYP
     C     *LIKE         DEFINE    CDCORN        #DCORN
     C     *LIKE         DEFINE    CDFATT        #DFATT
     C     *LIKE         DEFINE    CDADD1        #DADD1
     C     *LIKE         DEFINE    CDADD2        #DADD2
     C     *LIKE         DEFINE    CDADD3        #DADD3
     C     *LIKE         DEFINE    CDADD4        #DADD4
     C     *LIKE         DEFINE    CDADD5        #DADD5
     C     *LIKE         DEFINE    CDADD6        #DADD6
     C     *LIKE         DEFINE    CDADD7        #DADD7
     C     *LIKE         DEFINE    CDADD8        #DADD8
     C     *LIKE         DEFINE    CDZIP         #DZIP
     C     *LIKE         DEFINE    A8BRNM        #OBRNM
     C     *LIKE         DEFINE    CDPLAB        #DPLAB                                        13742
     C     *LIKE         DEFINE    CDFAX         #DFAX
     C     *LIKE         DEFINE    CDERT         #DERT
     C     *LIKE         DEFINE    CDEML         #DEML
     C     *LIKE         DEFINE    D7CSDE        #DCSEG
     C*
     C* Primary correspondent values:
     C*
     C     *LIKE         DEFINE    CDCTYP        #PCTYP
     C     *LIKE         DEFINE    CDCORN        #PCORN
     C     *LIKE         DEFINE    CDFATT        #PFATT
     C     *LIKE         DEFINE    CDADD1        #PADD1
     C     *LIKE         DEFINE    CDADD2        #PADD2
     C     *LIKE         DEFINE    CDADD3        #PADD3
     C     *LIKE         DEFINE    CDADD4        #PADD4
     C     *LIKE         DEFINE    CDADD5        #PADD5
     C     *LIKE         DEFINE    CDADD6        #PADD6
     C     *LIKE         DEFINE    CDADD7        #PADD7
     C     *LIKE         DEFINE    CDADD8        #PADD8
     C     *LIKE         DEFINE    CDZIP         #PZIP
     C     *LIKE         DEFINE    CDFAX         #PFAX
     C     *LIKE         DEFINE    CDEML         #PEML
     C*...................................................................
     C/EJECT
     C*...................................................................
     C* Sender's values:
     C*
     C     *LIKE         DEFINE    A8BRNM        #SBRNM
     C     *LIKE         DEFINE    CDADD1        #SADD1
     C     *LIKE         DEFINE    CDADD2        #SADD2
     C     *LIKE         DEFINE    CDADD3        #SADD3
     C     *LIKE         DEFINE    CDADD4        #SADD4
     C     *LIKE         DEFINE    CDADD5        #SADD5
     C     *LIKE         DEFINE    CDADD6        #SADD6
     C     *LIKE         DEFINE    CDADD7        #SADD7
     C     *LIKE         DEFINE    CDADD8        #SADD8
     C     *LIKE         DEFINE    CDFAX         #SFAX
     C     *LIKE         DEFINE    CDTEL         #STEL
     C     *LIKE         DEFINE    CDCREF        #SCREF
     C*
     C* CGUDCRL0:
     C     KKUDCR        KLIST
     C                   KFLD                    #@ITEM
     C                   KFLD                    #@DCOR
     C* CGRDTAL1:
     C     KKRDER        KLIST
     C                   KFLD                    RDRDE
     C*
     C* Define save values for change in item or correspondent:
     C*
     C     *LIKE         DEFINE    #@ITEM        SVITEM
     C     *LIKE         DEFINE    #@DCOR        SVDCOR
      *
      **  Open the appropriate files if not already open
     C     #@ARCH        IFEQ      'A'
     C     ##FIL1        IFNE      'Y'
     C                   OPEN      CGXDCRL0
     C                   MOVE      'Y'           ##FIL1            1
     C                   ENDIF
     C                   ELSE
     C     ##FIL2        IFNE      'Y'
     C                   OPEN      CGUDCRL0
     C                   MOVE      'Y'           ##FIL2            1
     C                   ENDIF
     C                   ENDIF
     C*
     C/COPY WNCPYSRC,CG3997C002
     C     EXINIT        TAG                                                    <<<=== EXINIT
     C*
     C* Unwind subroutine stack:
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   MOVE      'N'           CSC022            1
     C                   MOVE      'N'           WCMTSK            1
      *                                                                                       CSC022
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CSC022'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSC022
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC022
     C                   MOVE      'N'           WCMTSK
      *                                                                                       CSC022
     C                   IN        WDSJOB
      *                                                                                       CSC022
     C     WCMTNO        IFGT      0
     C                   MOVEA     WCJOBS        WCMT
     C                   Z-ADD     1             I                 2 0
      *                                                                                       CSC022
     C     ##JOB         LOOKUP    WCMT(I)                                51
     C     *IN51         IFEQ      *ON
     C                   MOVE      'Y'           WCMTSK
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSC022
     C                   ELSE
     C     PRTCD         IFNE      '*NRF'
     C                   MOVEL     'CSC022'      W0KEY
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   Z-ADD     21            W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CSC022
     C************NAMVAR   DEFN           WDSJOB                                       CSC022BUG2330
     C     *DTAARA       DEFINE    SCCMTJOB      WDSJOB
      *                                                                                       CSC022
     C                   ENDIF
      *                                                                                       CSC022
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C** Subroutine *PSSR handles program errors.                       **
     C********************************************************************
     C*
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD054955
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD054955
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C* File and Program Error Processing
     C*
     C*COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C* /Copy point for calculation specifications:
     C*
     C/COPY WNCPYSRC,CG3997CPG
     C*
     C********************************************************************
     O/EJECT
     O********************************************************************
     C* /Copy point for output:
     C*
     O/COPY WNCPYSRC,CG3997DOPG
      *
     O********************************************************************
~~~~~~*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Notes *or this array:
      *
  RDEs*are in alphabetical order -- keep them that way;
  the *|" and description are comments only;
  if R*Es are added or removed, change the program
   to *atch the array indexes appropriately;
  "liv*" RDEs start in element 11.
      *                                                                   137426
  New * entry PRINTADDRL (Print Address Label) added to table.            137426
      * and entry Z47 removed.                                            137426
  New * entry CSEG (Customer Segmentation Code) added to table.                               CSD090
      * and entry Z02 removed.                                                                CSD090
______*________________________________________________________________
      *
Z33   *   |                                                                                   CCG015
Z34   *   |                                                                                   CCG015
Z35   *   |                                                                                   CCG015
Z36   *   |                                                                                   CCG015
Z37   *   |                                                                                   CCG015
Z38   *   |                                                                                   CCG015
Z39   *   |                                                                                   CCG015
Z40   *   |                                                                                   CCG015
Z41   *   |                                                                                   CCG015
Z42   *   |                                                                                   CCG015
Z43   *   |                                                                                   CCG015
Z44   *   |                                                                                   CCG015
Z45   *   |                                                                                   CCG015
Z46   *   |                                                                                   CCG015
Z47   *   |                                                               137426
Z48   *   |                                                               086244
** CPY@
(c) Finastra International Limited 2001
** RDE -- Array of standard group set report data elements.
COPY      | Number of copies
DADDR1    | Destination address 1
DADDR2    |                     2
DADDR3    |                     3
DADDR4    |                     4
DADDR5    |                     5
DADDR6    |                     6
DADDR7    |                     7
DADDR8    |                     8
DBICA     | Destination BIC address
DBICBB    | Destination BIC branch code
DCORR     | Destination correspondent
DFAO      | Destination "for attention of"
DLVRYRTE  | Delivery route                                                                    CCG015
DNAME     | Destination correspondent name
DSTEMLADR | Destination email address                                                         CCG015
DSTFAXNMB | Destination FAX number                                                            CCG015
DSTWEBADR | Destination web address                                                           CCG015
DTYPE     | Destination correspondent type
DZIP      | Destination zipcode / postcode
GENERPDF  | Generate PDF                                                                      CCG015
ITEM_ID   | Item identifier
LANGUAGE  | Destination language                                                              CCG015
MGMTPRNT  | Management print                                                                  CCG015
MMOD      | Midas module ID
MTRN      | Midas transaction reference
OBNAM     | Originating branch name
OBRCH     | Originating branch
PADDR1    | Primary address 1
PADDR2    |                 2
PADDR3    |                 3
PADDR4    |                 4
PADDR5    |                 5
PADDR6    |                 6
PADDR7    |                 7
PADDR8    |                 8
PAGE      | Page number
PCORR     | Primary correspondent
PDAT      | Production Date                                               086244
PFAO      | Primary "for attention of"
PNAME     | Primary correspondent name
PORS      | Primary or secondary flag
PCTYPE    | Primary correspondent type
PRCEMLADR | Primary recipient email address                                                   CCG015
PRCFAXNMB | Primary recipient FAX number                                                      CCG015
PRCWEBADR | Primary recipient web address                                                     CCG015
PRINTADDRL| Print Address Label Indicator
PSBTP     | Print item sub-type
PTYPE     | Print item type
PZIP      | Primary zipcode / postcode
REPRINT   | Reprint                                                                           CCG015
REQUESTOR | Requestor                                                                         CCG015
RUND      | Run date
SADDR1    | Sender's address 1
SADDR2    |                  2
SADDR3    |                  3
SADDR4    |                  4
SADDR5    |                  5
SADDR6    |                  6
SADDR7    |                  7
SADDR8    |                  8
SBNAM     | Sender's branch name
SCLR      | Sender's clearing reference
SFAX      | Sender's fax number
SNDEMLADR | Sender email address                                                              CCG015
SNDWEBADR | Sender web address                                                                CCG015
SPHON     | Sender's phone number
STATUS    | Item status
SYSTPRFX  | Midas System Prefix (Libraries group)                                             205145
ALLPURFLD | All Purpose Field                                                                 CCG018
CSEG      |                                                                                   CSD090
Z03       |   RDEs named znn are spares.
Z04       |   They are provided to keep this array
Z05       |    in ascending order.
Z06       |
Z07       |
Z08       |
Z09       |
Z10       |
Z11       |
Z12       |
Z13       |
Z14       |
Z15       |
Z16       |
Z17       |
Z18       |
Z19       |
Z20       |
Z21       |
Z22       |
Z23       |
Z24       |
Z25       |
Z26       |
Z27       |
Z28       |
Z29       |
Z30       |
Z31       |
