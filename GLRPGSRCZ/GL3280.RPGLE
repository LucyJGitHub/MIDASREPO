     H DEBUG
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                       CGL120
/*STD *  RPGBASEMOD                                                   *                       CGL120
/*EXI *  TEXT('Midas GL IBAN installation program')                   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL3280  - IBAN Installation program                          *
      *                                                               *
      *  Function:  This program calculates and updates the IBAN      *
      *             number for each account on ACCNTAB                *
      *                                                               *
      *  Called By: GLC3280 - IBAN Installation program               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL120             Date 06Aug12               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035             Date 11Nov99               *
      *                 CFT004  *CREATE    Date 10Aug99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL120 - GL COB Components Task Split                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP035 - Account maintenance API; recompiled over changed    *
      *           ACCBR.                                              *
      *  CFT004 - International Banking Account Number                *
      *                                                               *
      *****************************************************************
     F***ACCBR*    UF   E           K DISK                                                    CGL120
     FACCNTL15  UF   E           K DISK                                                       CGL120
      ** GL Account by Branch
      *
     FSDCTRYL2  IF   E           K DISK
      **  SD Country codes
      *
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** EXTERNAL DS FOR SHORT DUMMY DATA STRUCTURE
     D*
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D** EXTERNAL DS FOR BRANCH DETAILS
     D*
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     I** EXTERNAL DS FOR ACCOUNT DETAILS
      *
      ****************************************************************
      **                     MAIN PROCESSING                        **
      ****************************************************************
      *
      *  Set up copyright parameter
     C                   MOVEA     CPY@          ACT@             80
      *
      * Access first branch
     C                   CALL      'AOBRCHR1'
     C                   PARM                    P@RTCD
     C                   PARM      '*FIRST'      P@OPTN            7
     C                   PARM                    P@BRCD            3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      * Process all branches
     C     P@RTCD        DOWEQ     *BLANKS
      *
      * Check if IBAN need to be generated
     C     A8GENM        IFEQ      '1'
     C     IBSEQN        IFEQ      '   '
     C                   MOVEL     'AAA'         IBSEQN
     C                   END
     C                   END
      *
      * Check if IBAN need to be generated
     C     A8GENM        IFEQ      '2'
     C     A8GENM        OREQ      '3'
     C     A8GENM        OREQ      '4'
      *
      *  Access country code
     C**********         CALL      'AOIBANR7'                                                 CGL120
     C                   CALLB     'AOIBANR7'                                                 CGL120
     C                   PARM                    P@RTCD
     C                   PARM      A8BRCD        P@BRCD
     C                   PARM                    P@ISOC            2
     C     P@RTCD        IFNE      *BLANKS
     C                   RETURN
     C                   ENDIF
      *
      * Access Country Details
     C     P@ISOC        CHAIN     SDCTRYL2                           70
      *
     C     *IN70         IFEQ      *ON
     C                   MOVE      '*ERROR'      P@RTCD
     C                   RETURN
     C                   ENDIF
      *
      * Check if IBAN are used
     C     A4BBAN        IFGT      *ZERO
      *
      * Access Account Details
     C*****A8BRCD        SETLL     ACCBR                              70                      CGL120
     C*****A8BRCD        READE     ACCBR                                  70                  CGL120
     C     A8BRCD        SETLL     ACCNTL15                           70                      CGL120
     C     A8BRCD        READE     ACCNTL15                               70                  CGL120
      *
      * Process all account for this branch
     C     *IN70         DOWEQ     *OFF
      *
      * Only process if IBAN field is blank
     C     IBAN          IFEQ      *BLANK
      *
      * Generate IBAN
     C**********         CALL      'AOIBANR6'                                                 CGL120
     C                   CALLB     'AOIBANR6'                                                 CGL120
     C                   PARM                    P@RTCD
     C     ACCNT         PARM      ACCNT         DSSDY
      *
     C     P@RTCD        IFEQ      *BLANKS
     C     IBAN          ANDNE     *BLANKS
     C                   UPDATE    ACCNTABF
     C                   ENDIF
     C                   ENDIF
      *
      *  Read next account for this branch
     C*****A8BRCD        READE     ACCBR                                  70                  CGL120
     C     A8BRCD        READE     ACCNTL15                               70                  CGL120
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Access next branch
     C                   CALL      'AOBRCHR1'
     C                   PARM                    P@RTCD
     C                   PARM      '*NEXT '      P@OPTN
     C                   PARM      A8BRCD        P@BRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C                   ENDDO
      *
      *
     C     P@RTCD        IFEQ      '*EOF   '
     C                   MOVEL     *BLANKS       P@RTCD
     C                   END
     C                   SETON                                        LR
     C                   RETURN
      *
      * PARAMETER
     C     *ENTRY        PLIST
     C                   PARM                    P@RTCD            7
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
