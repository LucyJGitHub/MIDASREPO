     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MR Access Account Keys')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting module                           *
      *                                                               *
      *  RPGLE/MRACSACKY - Access Account Keys                        *
      *                                                               *
      *  Function:  This module will be called from another RPGLE     *
      *             program. It is passed an account key broken into  *
      *             its constituent pieces. This program will access  *
      *             the account key details from file ACKEYAL, and    *
      *             return some of these to the calling progra. File  *
      *             Caching is used to boost the performance of this  *
      *             function.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CDL038             Date 10May05               *
      *                 CMR001   *CREATE   Date 16Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Account Keys
     FACKEY     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACKEYAKF)
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      * Maximum number of account keys
     D MaxNoAKey       C                   CONST(100)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Account Keys
     D #_AKey          S             14    DIM(MaxNoAKey)                                     CDL038
     D*#_AKey**********S             10    DIM(MaxNoAKey)                                     CDL038
 
      ** Account Key Details
     D #_AKeyDt        S            200    DIM(MaxNoAKey)
 
      * Account Key Details Data Structure
     D AKeyDS        E DS                  EXTNAME(ACKEYAL)
 
      * Account Code Details Data Structure
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WkRun           S              1
 
     D PAcKyPos01      S              2
     D PAcKyPos03      S              1
     D PAcKyPos04      S              2
     D PAcKyPos06      S              1
     D PAcKyPos07      S              1
     D PAcKyPos08      S              1
     D PAcKyPos09      S              1
     D PAcKyPos10      S              1
     D PAcKyPos11      S              4                                                       CDL038
     D PAcCodDR1       S             10
     D PAcSecDR1       S              2
     D PPosRfDR1       S              1
     D PAcCodDR2       S             10
     D PAcSecDR2       S              2
     D PPosRfDR2       S              1
     D PAcCodDR3       S             10
     D PAcSecDR3       S              2
     D PPosRfDR3       S              1
     D PAcCodCR1       S             10
     D PAcSecCR1       S              2
     D PPosRfCR1       S              1
     D PAcCodCR2       S             10
     D PAcSecCR2       S              2
     D PPosRfCR2       S              1
     D PAcCodCR3       S             10
     D PAcSecCR3       S              2
     D PPosRfCR3       S              1
     D @CIX            S              6  0
     D @IX             S              6  0
     D PAcCd           S             10  0
     D I#ERMS          S             30
     D*PAcKey**********S*************10                                                       CDL038
     D PAcKey          S             14                                                       CDL038
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EXSR      SRInit
 
      ** If the received Account Key is blank, pass back a blank format
     C                   IF        PAcKey = *BLANKS
     C                   CLEAR                   AKeyDS
     C                   ELSE
 
      ** If the account key was previously accessed, use that account key
      ** details
     C                   Z-ADD     1             @IX
     C     PAcKey        LOOKUP    #_AKey(@IX)                            99
 
     C                   IF        *IN99 = *ON
     C                   MOVEL     #_AKeyDt(@IX) AKeyDS
     C                   ELSE
 
      ** Access the account keys file
     C     PAcKey        CHAIN     ACKEY                              99
 
      ** If the account key was not found, pass back a blank format
     C                   IF        *IN99 = *ON
     C                   CLEAR                   AKeyDS
     C                   ENDIF
 
      ** Save the account key's details
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_AKey(@IX)                            99
 
     C                   IF        *IN99 = *ON
     C                   MOVEL     PAcKey        #_AKey(@IX)
     C                   MOVEL     AKeyDS        #_AKeyDt(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     PAcKey        #_AKey(@CIX)
     C                   MOVEL     AKeyDS        #_AKeyDt(@CIX)
     C                   IF        @CIX = MaxNoAKey
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      * Set up output data
     C                   EXSR      SRSetOutData
 
      ** Return
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetOutData - Subroutine that Sets up Output Data            *
      *                                                               *
      *****************************************************************
     C     SRSetOutData  BEGSR
 
      ** Debit output details:
 
     C                   IF        ACD1 <> 0
     C                   MOVE      ACD1          PAcCodDR1
      ** Get Account Code Details
     C                   EVAL      PAcCd = ACD1
     C                   EXSR      SRGetAcCdD
     C                   EVAL      PAcSecDR1 = A5ACSC
     C                   ENDIF
 
     C                   IF        ACD2 <> 0
     C                   MOVE      ACD2          PAcCodDR2
      ** Get Account Code Details
     C                   EVAL      PAcCd = ACD2
     C                   EXSR      SRGetAcCdD
     C                   EVAL      PAcSecDR2 = A5ACSC
     C                   ENDIF
 
     C                   IF        ACD3 <> 0
     C                   MOVE      ACD3          PAcCodDR3
      ** Get Account Code Details
     C                   EVAL      PAcCd = ACD3
     C                   EXSR      SRGetAcCdD
     C                   EVAL      PAcSecDR3 = A5ACSC
     C                   ENDIF
 
     C                   IF        PRF1 <> 0
     C                   MOVE      PRF1          PPosRfDR1
     C                   ENDIF
 
     C                   IF        PRF2 <> 0
     C                   MOVE      PRF2          PPosRfDR2
     C                   ENDIF
 
     C                   IF        PRF3 <> 0
     C                   MOVE      PRF3          PPosRfDR3
     C                   ENDIF
 
      ** Credit Output Details:
 
     C                   IF        ACD4 <> 0
     C                   MOVE      ACD4          PAcCodCR1
      ** Get Account Code Details
     C                   EVAL      PAcCd = ACD4
     C                   EXSR      SRGetAcCdD
     C                   EVAL      PAcSecCR1 = A5ACSC
     C                   ENDIF
 
     C                   IF        ACD5 <> 0
     C                   MOVE      ACD5          PAcCodCR2
      ** Get Account Code Details
     C                   EVAL      PAcCd = ACD5
     C                   EXSR      SRGetAcCdD
     C                   EVAL      PAcSecCR2 = A5ACSC
     C                   ENDIF
 
     C                   IF        ACD6 <> 0
     C                   MOVE      ACD6          PAcCodCR3
      ** Get Account Code Details
     C                   EVAL      PAcCd = ACD6
     C                   EXSR      SRGetAcCdD
     C                   EVAL      PAcSecCR3 = A5ACSC
     C                   ENDIF
 
     C                   IF        PRF4 <> 0
     C                   MOVE      PRF4          PPosRfCR1
     C                   ENDIF
 
     C                   IF        PRF5 <> 0
     C                   MOVE      PRF5          PPosRfCR2
     C                   ENDIF
 
     C                   IF        PRF6 <> 0
     C                   MOVE      PRF6          PPosRfCR3
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetAcCdD - Subroutine that Retrieves Account Code Details   *
      *                                                               *
      *****************************************************************
     C     SRGetAcCdD    BEGSR
 
     C                   MOVEL     PAcCd         I#LFD1
 
     C                   CALLB     'MXACSACOD'
      /COPY MXCPYSRC,MXACSPRME
 
     C                   IF        ACS_RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'INVALID A/C CODE: ' + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SDACOD = InData
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initial Processing                                   *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   EVAL      PAcCodDR1 = *BLANKS
     C                   EVAL      PAcSecDR1 = *BLANKS
     C                   EVAL      PPosRfDR1 = *BLANKS
     C                   EVAL      PAcCodDR2 = *BLANKS
     C                   EVAL      PAcSecDR2 = *BLANKS
     C                   EVAL      PPosRfDR2 = *BLANKS
     C                   EVAL      PAcCodDR3 = *BLANKS
     C                   EVAL      PAcSecDR3 = *BLANKS
     C                   EVAL      PPosRfDR3 = *BLANKS
     C                   EVAL      PAcCodCR1 = *BLANKS
     C                   EVAL      PAcSecCR1 = *BLANKS
     C                   EVAL      PPosRfCR1 = *BLANKS
     C                   EVAL      PAcCodCR2 = *BLANKS
     C                   EVAL      PAcSecCR2 = *BLANKS
     C                   EVAL      PPosRfCR2 = *BLANKS
     C                   EVAL      PAcCodCR3 = *BLANKS
     C                   EVAL      PAcSecCR3 = *BLANKS
     C                   EVAL      PPosRfCR3 = *BLANKS
 
     C                   EVAL      PAcKey = PAcKyPos01 + PAcKyPos03 +
     C                                      PAcKyPos04 + PAcKyPos06 +
     C                                      PAcKyPos07 + PAcKyPos08 +
     C                                      PAcKyPos09 + PAckyPos10 +                         CDL038
     C                                      PAcKyPos11                                        CDL038
     C**************************************PAcKyPos09 + PAckyPos10                           CDL038
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** Inputs
     C                   PARM                    PAcKyPos01
     C                   PARM                    PAcKyPos03
     C                   PARM                    PAcKyPos04
     C                   PARM                    PAcKyPos06
     C                   PARM                    PAcKyPos07
     C                   PARM                    PAcKyPos08
     C                   PARM                    PAcKyPos09
     C                   PARM                    PAcKyPos10
     C                   PARM                    PAcKyPos11                                   CDL038
 
      ** Outputs
     C                   PARM                    PAcCodDR1
     C                   PARM                    PAcSecDR1
     C                   PARM                    PPosRfDR1
     C                   PARM                    PAcCodDR2
     C                   PARM                    PAcSecDR2
     C                   PARM                    PPosRfDR2
     C                   PARM                    PAcCodDR3
     C                   PARM                    PAcSecDR3
     C                   PARM                    PPosRfDR3
     C                   PARM                    PAcCodCR1
     C                   PARM                    PAcSecCR1
     C                   PARM                    PPosRfCR1
     C                   PARM                    PAcCodCR2
     C                   PARM                    PAcSecCR2
     C                   PARM                    PPosRfCR2
     C                   PARM                    PAcCodCR3
     C                   PARM                    PAcSecCR3
     C                   PARM                    PPosRfCR3
 
     C                   Z-ADD     *ZERO         @CIX
 
     C                   ENDSR
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
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WkRun = *BLANK
     C                   EVAL      WkRun = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
