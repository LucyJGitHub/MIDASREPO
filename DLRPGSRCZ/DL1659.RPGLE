     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *                       220859
/*EXI *  TEXT('Midas DL OIS Housekeeping for DLDOISPD')               *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL1659 - OIS Housekeeping for DLDOISPD                       *
      *                                                               *
      *  Function:  This program removes all OIS deal records from    *
      *             the deals extension file, PF/DLDOISPD, if the     *
      *             deal no longer exist on both the data base file,  *
      *             DEALSDG, and Deals History file, DLGHISPD.        *
      *                                                               *
      *  Called By: DLC1659 - OIS Housekeeping for DLDOISPD           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 220859             Date 26May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7411            Date 01Jun05               *
      *                 CDL028             Date 07Feb05               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007  *CREATE    Date 11May01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  220859 - Increase the size of Compounding Rate from          *
      *           7 to 15 decimal places. DL1659 was converted to ILE *
      *           due to the change in the number of decimal places.  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CIR007 - Overnight Index Swaps                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *   SRINIT - Initialisation of Program                          *
      *   SRPROC - Main Processing                                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   75  - READ DLDOISL2                                         *
      *   80  - READ DLDOISL2                                         *
      *   85  - CHAIN DEALS                                           *
      *   86  - CHAIN DEALSH                                          *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Logical file built over DLDOISPD
     FDLDOISL2  UF   E           K DISK
      *
      ** Logical file built over DEALSDG
     FDEALS     IF   E           K DISK
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
      *
      ** Logical file built over DLGHISPD
     FDEALSH    IF   E           K DISK
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDGF)
     F                                     IGNORE(DLBHISD0)
     F                                     IGNORE(DLCHISD0)
     F                                     IGNORE(DLDHISD0)
     F                                     IGNORE(DLEHISD0)
      *
      *****************************************************************
      /EJECT
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *****************************************************************
      /SPACE 3
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
     D LDA           E DS           256    EXTNAME(LDA)
      *
      *****************************************************************
      *                                                               *
      **  M A I N    P R O C E S S I N G                              *
      *                                                               *
      *****************************************************************
      *
      ** Perform Initialisation.
      *
     C                   EXSR      SRINIT
      *
      ** Perform Main Processing
      *
     C                   EXSR      SRPROC
      *
     C                   SETON                                            LR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT -   Initial Processing                                *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *  Called By: - Main Processing                                 *
      *                                                               *
      *****************************************************************
      *
      ** Perform initial processing
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Initialise LDA field.
      *
     C                   MOVEL     'DL1659'      DBPGM
     C     *DTAARA       DEFINE                  LDA
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROC -   Perform Main processing                           *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *  Called By: - Main Processing                                 *
      *                                                               *
      *****************************************************************
      *
      ** Perform Main Processing
      *
     C     SRPROC        BEGSR
      *
      ** Read through OIS Details file DLDOISPD and check if
      ** each deal exists on the Deals data base file DEALSDG and
      ** Deals history file DLGHISPD.
      *
     C                   READ      DLDOISL2                               80
      *
     C     *IN80         DOWEQ     '0'
      *
     C     L1DLNO        CHAIN     DEALS                              85
     C     L1DLNO        CHAIN     DEALSH                             86
      *
      ** Delete all records in DLDOISPD if the corresponding
      ** deal does not exist on both DEALSDG and DLGHISPD.
      *
     C     *IN85         IFEQ      *ON
     C     *IN86         ANDEQ     *ON
      *
     C                   DELETE    DLDOISD0
      *
     C     L1DLNO        READE     DLDOISL2                               75
      *
     C     *IN75         DOWEQ     '0'
     C                   DELETE    DLDOISD0
     C     L1DLNO        READE     DLDOISL2                               75
     C                   ENDDO
      *
     C                   ENDIF
      *
     C     L1DLNO        SETGT     DLDOISL2
     C                   READ      DLDOISL2                               80
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
