     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Hierarchy Rel Validation')    *
/*XBIA*  OVRDBF FILE(RELCMHDL0X) TOFILE(RELCMHDL0) SHARE(*NO)         *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100404 - Cash Management Hierarchy Relationship Validation *
      *                                                               *
      *  Function:  This program does validation of relationships     *
      *             between a/cs in cash management hierarchies.      *
      *             It checks that top or leval group a/cs in zero    *
      *             balancing/sweeping hierarchies have an associated *
      *             transaction a/c.                                  *
      *             Where a shadow account is present for a zero      *
      *             balancing hier member, the income and expense a/cs*
      *             must be present and must be positioned correctly  *
      *             in the hierarchy.                                 *
      *             For linked zero balancing hierarchies the link    *
      *             must be between a top and sub a/c.                *
      *             For group a/c hierarchies it checks that alternate*
      *             a/cs to post interest to and internal income and  *
      *             expense a/cs are positioned correctly in the      *
      *             hierarchy.
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD000091           Date 15May13               *
      *  Prev Amend No. AR676213           Date 19Nov10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 214360             Date 03Feb03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  214360 - Cash Management Deferred Posting                    *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRELCMHDL0 IF   E           K DISK    INFSR(*PSSR)
     FRELCMHLL1 IF   E           K DISK    INFSR(*PSSR)
     FRELZSHLL0 IF   E           K DISK    INFSR(*PSSR)
     FRELGAHLL0 IF   E           K DISK    INFSR(*PSSR)
     FRELGAHLJ2 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REGAHLD0:REGAHLDJ2)
     F                                     PREFIX(A_)
     FRELZSHLJ2 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSHLD0:REZSHLDJ2)
     F                                     PREFIX(A_)
     FRELZSHDL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(Z_)
     FRELGAHLJ0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REGAHLD0:REGAHLDJ0)
     F                                     PREFIX(S_)
     FRELZSHLJ0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSHLD0:REZSHLDJ0)
     F                                     PREFIX(S_)
     FRELCMHDL0XIF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHDD0:RECMHDDX0)
     F                                     PREFIX(H_)
     FREACCHL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REACCHD0:REACCHD1)
     FREIAC     IF   E           K DISK    INFSR(*PSSR)
     FACNUM     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AC_)
     FRE100404AUO    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      ** File Information Data Structure for RE100404AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
     D I_PACD          S             10  0                                                    CGL029
     D BlankAC         S             24                                                       CGL029
 
      * CHILD Account ID
     D                 DS
     D***CACCID*                 1     18                                                     CGL029
     D CACCID                  1     24                                                       CGL029
     D CBRC                    1      3
     D*CCUS*****               4      9S 0                                                    CSD027
     D CCUS                    4      9                                                       CSD027
     D CCCY                   10     12
     D***CACD***                13     16S 0                                                  CGL029
     D***CASN***                17     18S 0                                                  CGL029
     D CACD                   13     22S 0                                                    CGL029
     D CASN                   23     24S 0                                                    CGL029
 
      * PARENT Account ID
     D                 DS
     D***PACCID*                 1     18                                                     CGL029
     D PACCID                  1     24                                                       CGL029
     D PBRC                    1      3
     D*PCUS*****               4      9S 0                                                    CSD027
     D PCUS                    4      9                                                       CSD027
     D PCCY                   10     12
     D***PACD***                13     16S 0                                                  CGL029
     D***PASN***                17     18S 0                                                  CGL029
     D PACD                   13     22S 0                                                    CGL029
     D PASN                   23     24S 0                                                    CGL029
 
      * WORK Account ID
     D                 DS
     D***WACCID*                 1     18                                                     CGL029
     D WACCID                  1     24                                                       CGL029
     D WBRC                    1      3
     D*WCUS*****               4      9S 0                                                    CSD027
     D WCUS                    4      9                                                       CSD027
     D WCCY                   10     12
     D***WACD***                13     16S 0                                                  CGL029
     D***WASN***                17     18S 0                                                  CGL029
     D***WCCAA**                 4     18                                                     CGL029
     D WACD                   13     22S 0                                                    CGL029
     D WASN                   23     24S 0                                                    CGL029
     D WCCAA                   4     24                                                       CGL029
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
      ** Chain Arrays
     D***O_GLAI*         S             18    DIM(99)                                          CGL029
     D O_GLAI          S             24    DIM(99)                                            CGL029
     D O_RAN           S             10    DIM(99)
     D O_AST           S              1    DIM(99)
     D O_PC            S              4    DIM(99)
     D O_ASC           S              2    DIM(99)
     D O_ODFT          S             15S 0 DIM(99)
     D O_BAIC          S              1    DIM(99)
     D O_ICTB          S             15S 0 DIM(99)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      * Clear outputs
 
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIDArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
 
      * INTERACTIVE mode
      * Non INTERACTIVE mode
 
     C     I_MODE        IFEQ      'I'
     C                   EXSR      INTERACT
     C                   ELSE
     C                   EXSR      NON_INTERACT
     C                   ENDIF
 
 
     C                   SETON                                        LR
     C                   RETURN
      /SPACE 5
      ********************************************************************
      * Interactive mode
      ********************************************************************
     C     INTERACT      BEGSR
 
      * Read Cash Management Hierarchy Header record
 
     C     I_Hierarchy   SETLL     RECMHDD0
     C     I_Hierarchy   READE     RECMHDD0                               60
 
      * Read links for hierarchy
 
     C  N60              EXSR      READ_LINKS
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Non-Interactive mode
      ********************************************************************
     C     NON_INTERACT  BEGSR
 
      * Read all Cash Management Hierarchy Header records
 
     C                   READ      RECMHDD0                               60
 
     C     *IN60         DOWEQ     *OFF
 
      * Read links for hierarchy
 
     C                   EXSR      READ_LINKS
 
      * If any errors detected
      *   Report the errors
      *   Set hierarchy status to 'ERRORS'
 
     C     Ix            IFGT      0
     C                   EXSR      REP_ERRORS
     C                   ADD       Ix            NoErrors          5 0
 
     C     CDHIER        CHAIN     REACCHD1                           60
     C  N60              MOVE      'E'           HISTAT
     C  N60              EXCEPT    U_REACCH
 
     C                   SETON                                        U7U8
     C                   ENDIF
 
      * Clear outputs
 
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIDArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
 
      * Read next Account Hierarchy Header record
 
     C                   READ      RECMHDD0                               60
 
     C                   ENDDO
      * End of Report
 
     C                   EXSR      END_OF_REP
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Read links for hierarchy
      ********************************************************************
     C     READ_LINKS    BEGSR
 
     C     CDHIER        SETLL     RECMHLD0
     C     CDHIER        READE     RECMHLD0                               60
 
      * Read all links for this hierarchy
 
     C     *IN60         DOWEQ     *OFF
 
      * CHILD A/c ID
 
     C                   MOVEL     CLCBRC        CBRC
     C                   MOVEL     CLCCUS        CCUS
     C                   MOVEL     CLCCCY        CCCY
     C                   MOVEL     CLCACD        CACD
     C                   MOVEL     CLCASN        CASN
 
      * PARENT A/c ID
 
     C                   MOVEL     CLPBRC        PBRC
     C                   MOVEL     CLPCUS        PCUS
     C                   MOVEL     CLPCCY        PCCY
     C                   MOVEL     CLPACD        PACD
     C                   MOVEL     CLPASN        PASN
 
      * Do validation
 
     C     CDHTYP        IFEQ      'ZS'
 
      * Zero Balancing/Sweeping Hierarchy TOP, LEVEL, SUB a/c validation
 
     C                   Z-ADD     0             CountACs          3 0
 
      * Access link
 
     C     LINKK         CHAIN     REZSHLD0                           60
     C     *IN60         IFEQ      '1'
     C                   MOVE      CLLINK        WLINK             9
     C                   EVAL      X_ERMS = 'RELZSHLPD missing ' +
     C                                      'for link ' + WLINK
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     CLCCAT        CASEQ     'T'           ZS_TOP_VAL
     C     CLCCAT        CASEQ     'L'           ZS_LEV_VAL
     C     CLCCAT        CASEQ     'S'           ZS_SUB_VAL
     C                   ENDCS
 
      * Zero Balancing/Sweeping Hierarchy Group A/c Cross Validation
 
     C                   EXSR      ZS_GA_XVAL
 
     C                   ELSE
 
      * Access REIAC
 
     C                   EXSR      ACS_REIAC
 
      * Access link
 
     C     LINKK         CHAIN     REGAHLD0                           60
     C     *IN60         IFEQ      '1'
     C                   MOVE      CLLINK        WLINK             9
     C                   EVAL      X_ERMS = 'REGAHLPD missing ' +
     C                                      'for link ' + WLINK
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Group A/c Hierarchy TOP, LEVEL, SUB a/c validation
 
     C     CLCCAT        CASEQ     'T'           GA_TOP_VAL
     C     CLCCAT        CASEQ     'L'           GA_LEV_VAL
     C     CLCCAT        CASEQ     'S'           GA_SUB_VAL
     C                   ENDCS
 
     C                   ENDIF
 
      * Exit if many errors encountered
 
     C                   IF        Ix  >   ArrayMax / 2
     C                   LEAVE
     C                   ENDIF
 
     C     CDHIER        READE     RECMHLD0                               60
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Zero Balancing/Sweeping Hierarchy TOP a/c validation
      ********************************************************************
     C     ZS_TOP_VAL    BEGSR
 
      * ' is a hierarchy that contains this top a/c but not as a top or sub a/c.'
      * (A top a/c in one hierarchy can only be a top or sub a/c in another.)
 
     C     CACCNTK       SETLL     RELZSHLJ2
     C     CACCNTK       READE     RELZSHLJ2                              60
     C     *IN60         DOWEQ     '0'
     C     A_CLHIER      IFNE      CLHIER
     C     A_CLHIER      CHAIN     RECMHDDX0                          99
     C     A_CLCCAT      IFEQ      'T'
     C     CLHIER        CHAIN     REZSHDD0                           99
     C                   ENDIF
     C     A_CLCCAT      IFEQ      'L'
     C     A_CLCCAT      OREQ      'T'
     C     A_ZDDEST      ANDNE     *BLANK
     C     Z_ZDDEST      ANDNE     *BLANK
     C     A_CLCCAT      OREQ      'T'
     C     A_ZDDEST      ANDEQ     *BLANK
     C     Z_ZDDEST      ANDEQ     *BLANK
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75040'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C**********         CAT       '.':0         MsgDtaArr(Ix)                              MD000091
     C**********         CAT       H_CDHISN:0    MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   CAT       '.':0         MsgDtaTmp                                  MD000091
     C                   CAT       H_CDHISN:0    MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
     C                   ADD       1             CountACs
     C                   ENDIF
     C                   ENDIF
     C     CACCNTK       READE     RELZSHLJ2                              60
     C                   ENDDO
 
      * ' is a hierarchy that must not contain this top a/c as a sub a/c.'
      * (A top a/c in one hierarchy can be a sub a/c in only ONE other.)
 
     C     CountACs      IFGT      1
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75041'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C**********         CAT       '.':0         MsgDtaArr(Ix)                              MD000091
     C**********         CAT       H_CDHISN:0    MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   CAT       '.':0         MsgDtaTmp                                  MD000091
     C                   CAT       H_CDHISN:0    MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
      * ' A top a/c must not have an Shadow account
 
     C                   MOVEL     ZLSBRC        WBRC
     C                   MOVEL     ZLSCUS        WCUS
     C                   MOVEL     ZLSCCY        WCCY
     C                   MOVEL     ZLSACD        WACD
     C                   MOVEL     ZLSASN        WASN
     C     WACCID        IFNE      BlankAC
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE76017'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
      * ' A top a/c must not have an internal interest income a/c.'
 
     C                   MOVEL     ZLIBRC        WBRC
     C                   MOVEL     ZLICUS        WCUS
     C                   MOVEL     ZLICCY        WCCY
     C                   MOVEL     ZLIACD        WACD
     C                   MOVEL     ZLIASN        WASN
     C     WACCID        IFNE      BlankAC
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75056'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
      * ' A top a/c must not have an internal interest expense a/c.'
 
     C                   MOVEL     ZLEBRC        WBRC
     C                   MOVEL     ZLECUS        WCUS
     C                   MOVEL     ZLECCY        WCCY
     C                   MOVEL     ZLEACD        WACD
     C                   MOVEL     ZLEASN        WASN
     C     WACCID        IFNE      BlankAC
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75057'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Zero Balancing/Sweeping Hierarchy LEVEL a/c validation
      ********************************************************************
     C     ZS_LEV_VAL    BEGSR
 
      * ' is a hierarchy that contains this level a/c when it should not.'
      * (A level a/c in one hierarchy cannot exist in any other hierarchy)
 
     C     CACCNTK       SETLL     RELZSHLJ2
     C     CACCNTK       READE     RELZSHLJ2                              60
     C     *IN60         DOWEQ     '0'
     C     A_CLHIER      IFNE      CLHIER
     C     A_CLHIER      CHAIN     RECMHDDX0                          99
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75042'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C**********         CAT       '.':0         MsgDtaArr(Ix)                              MD000091
     C**********         CAT       H_CDHISN:0    MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   CAT       '.':0         MsgDtaTmp                                  MD000091
     C                   CAT       H_CDHISN:0    MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C     CACCNTK       READE     RELZSHLJ2                              60
     C                   ENDDO
 
      *  If Shadow Account defined,
 
     C                   MOVEL     ZLSBRC        WBRC
     C                   MOVEL     ZLSCUS        WCUS
     C                   MOVEL     ZLSCCY        WCCY
     C                   MOVEL     ZLSACD        WACD
     C                   MOVEL     ZLSASN        WASN
 
     C     WACCID        IFNE      BlankAC
 
      * 'Internal Interest Income Account must exist'
 
     C                   MOVEL     ZLIBRC        WBRC
     C                   MOVEL     ZLICUS        WCUS
     C                   MOVEL     ZLICCY        WCCY
     C                   MOVEL     ZLIACD        WACD
     C                   MOVEL     ZLIASN        WASN
 
     C     WACCID        IFNE      BlankAC
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75066'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
 
     C                   ELSE
 
      * 'Internal interest income a/c is not a sub a/c in the same hierarchy.'
 
     C     WACCNTK       CHAIN     RELZSHLJ0                          60
     C     *IN60         IFEQ      '1'
     C     S_CLHIER      ORNE      CLHIER
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75067'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Internal interest income a/c for a member must have the same parent as the member'
 
     C                   MOVEL     S_CLPBRC      WBRC
     C                   MOVEL     S_CLPCUS      WCUS
     C                   MOVEL     S_CLPCCY      WCCY
     C                   MOVEL     S_CLPACD      WACD
     C                   MOVEL     S_CLPASN      WASN
     C     WACCID        IFNE      PACCID
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75068'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * ' A level a/c must have an internal interest expense a/c.'
 
     C                   MOVEL     ZLEBRC        WBRC
     C                   MOVEL     ZLECUS        WCUS
     C                   MOVEL     ZLECCY        WCCY
     C                   MOVEL     ZLEACD        WACD
     C                   MOVEL     ZLEASN        WASN
     C     WACCID        IFEQ      BlankAC
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75069'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Internal interest expense a/c is not a sub a/c in the same hierarchy.'
 
     C     WACCNTK       CHAIN     RELZSHLJ0                          60
     C     *IN60         IFEQ      '1'
     C     S_CLHIER      ORNE      CLHIER
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75070'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Internal interest expense a/c for a member must have the same parent as the member'
 
     C                   MOVEL     S_CLPBRC      WBRC
     C                   MOVEL     S_CLPCUS      WCUS
     C                   MOVEL     S_CLPCCY      WCCY
     C                   MOVEL     S_CLPACD      WACD
     C                   MOVEL     S_CLPASN      WASN
     C     WACCID        IFNE      PACCID
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75071'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Zero Balancing/Sweeping Hierarchy SUB a/c validation
      ********************************************************************
     C     ZS_SUB_VAL    BEGSR
 
      * ' is a hierarchy that contains this sub a/c but not as a top a/c.'
      * (A sub a/c in one hierarchy can only be a top a/c in another)
 
     C     CACCNTK       SETLL     RELZSHLJ2
     C     CACCNTK       READE     RELZSHLJ2                              60
     C     *IN60         DOWEQ     '0'
     C     A_CLHIER      IFNE      CLHIER
     C     A_CLHIER      CHAIN     RECMHDDX0                          99
     C     A_CLCCAT      IFNE      'T'
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75043'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C**********         CAT       '.':0         MsgDtaArr(Ix)                              MD000091
     C**********         CAT       H_CDHISN:0    MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   CAT       '.':0         MsgDtaTmp                                  MD000091
     C                   CAT       H_CDHISN:0    MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
     C                   ADD       1             CountACs
     C                   ENDIF
     C                   ENDIF
     C     CACCNTK       READE     RELZSHLJ2                              60
     C                   ENDDO
 
      * ' is a hierarchy that must not contain this sub a/c as a top a/c.'
      * (A sub a/c in one hierarchy can be a top a/c in only ONE other)
 
     C     CountACs      IFGT      1
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75044'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C**********         CAT       '.':0         MsgDtaArr(Ix)                              MD000091
     C**********         CAT       H_CDHISN:0    MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   CAT       '.':0         MsgDtaTmp                                  MD000091
     C                   CAT       H_CDHISN:0    MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
      *  If Shadow Account defined,
 
     C                   MOVEL     ZLSBRC        WBRC
     C                   MOVEL     ZLSCUS        WCUS
     C                   MOVEL     ZLSCCY        WCCY
     C                   MOVEL     ZLSACD        WACD
     C                   MOVEL     ZLSASN        WASN
 
     C     WACCID        IFNE      BlankAC
 
      * 'A sub a/c must have an internal interest income a/c.'
 
     C                   MOVEL     ZLIBRC        WBRC
     C                   MOVEL     ZLICUS        WCUS
     C                   MOVEL     ZLICCY        WCCY
     C                   MOVEL     ZLIACD        WACD
     C                   MOVEL     ZLIASN        WASN
     C     WACCID        IFEQ      BlankAC
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75085'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Internal interest income a/c is not a sub a/c in the same hierarchy.'
 
     C     WACCNTK       CHAIN     RELZSHLJ0                          60
     C     *IN60         IFEQ      '1'
     C     S_CLHIER      ORNE      CLHIER
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75086'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Internal interest income a/c for a member must have the same parent as the member'
 
     C                   MOVEL     S_CLPBRC      WBRC
     C                   MOVEL     S_CLPCUS      WCUS
     C                   MOVEL     S_CLPCCY      WCCY
     C                   MOVEL     S_CLPACD      WACD
     C                   MOVEL     S_CLPASN      WASN
     C     WACCID        IFNE      PACCID
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75087'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * ' A sub a/c must have an internal interest expense a/c.'
 
     C                   MOVEL     ZLEBRC        WBRC
     C                   MOVEL     ZLECUS        WCUS
     C                   MOVEL     ZLECCY        WCCY
     C                   MOVEL     ZLEACD        WACD
     C                   MOVEL     ZLEASN        WASN
     C     WACCID        IFEQ      BlankAC
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75088'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Internal interest expense a/c is not a sub a/c in the same hierarchy.'
 
     C     WACCNTK       CHAIN     RELZSHLJ0                          60
     C     *IN60         IFEQ      '1'
     C     S_CLHIER      ORNE      CLHIER
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75089'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Internal interest expense a/c for a member must have the same parent as the member'
 
     C                   MOVEL     S_CLPBRC      WBRC
     C                   MOVEL     S_CLPCUS      WCUS
     C                   MOVEL     S_CLPCCY      WCCY
     C                   MOVEL     S_CLPACD      WACD
     C                   MOVEL     S_CLPASN      WASN
     C     WACCID        IFNE      PACCID
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75090'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Zero Balancing/Sweeping Hierarchy Group A/c Cross Validation
      ********************************************************************
     C     ZS_GA_XVAL    BEGSR
 
      * Determine if a/c is an a/c in a group a/c hierarchy
 
     C     CACCNTK       CHAIN     RELGAHLJ2                          60
     C     *IN60         IFEQ      '0'
 
     C     A_CLHIER      CHAIN     RECMHDDX0                          99
 
      * If a/c is a top or level a/c
      * the a/c must have a transaction a/c that is a sub a/c and is
      * below the a/c in the group a/c hierarchy
 
     C     A_CLCCAT      IFEQ      'T'
     C     A_CLCCAT      OREQ      'L'
 
      * ' top/level a/c does not carry a transaction a/c.'
      * (Transaction a/c not present on top/level account)
 
     C                   MOVEL     A_GLTBRC      WBRC
     C                   MOVEL     A_GLTCUS      WCUS
     C                   MOVEL     A_GLTCCY      WCCY
     C                   MOVEL     A_GLTACD      WACD
     C                   MOVEL     A_GLTASN      WASN
     C     WACCID        IFEQ      BlankAC
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75045'     MsgIDArr(Ix)
     C**********         MOVEL     A_CLLINK      MsgDtaArr(Ix)                              MD000091
     C**********         CAT       '.':0         MsgDtaArr(Ix)                              MD000091
     C**********         CAT       H_CDHISN:0    MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     A_CLLINK      MsgDtaTmp                                  MD000091
     C                   CAT       '.':0         MsgDtaTmp                                  MD000091
     C                   CAT       H_CDHISN:0    MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * ' top/level a/c has a transaction a/c which is not a sub a/c.'
      * (Transaction a/c is not a sub a/c in the same hierarchy)
 
     C     WACCNTK       CHAIN     RELGAHLJ0                          60
     C     *IN60         IFEQ      '1'
     C     S_CLHIER      ORNE      A_CLHIER
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75046'     MsgIDArr(Ix)
     C**********         MOVEL     A_CLLINK      MsgDtaArr(Ix)                              MD000091
     C**********         CAT       '.':0         MsgDtaArr(Ix)                              MD000091
     C**********         CAT       H_CDHISN:0    MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     A_CLLINK      MsgDtaTmp                                  MD000091
     C                   CAT       '.':0         MsgDtaTmp                                  MD000091
     C                   CAT       H_CDHISN:0    MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * Check if transaction a/c exists below the top/level a/c
 
     C                   EXSR      CHK_AC_CHN
 
      * ' top/level a/c has a transaction a/c which is not below in the hierarchy.'
      * (Transaction a/c for a member is not present below that member.)
 
     C     AC_In_Chn     IFNE      'Y'
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75047'     MsgIDArr(Ix)
     C**********         MOVEL     A_CLLINK      MsgDtaArr(Ix)                              MD000091
     C**********         CAT       '.':0         MsgDtaArr(Ix)                              MD000091
     C**********         CAT       H_CDHISN:0    MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     A_CLLINK      MsgDtaTmp                                  MD000091
     C                   CAT       '.':0         MsgDtaTmp                                  MD000091
     C                   CAT       H_CDHISN:0    MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Group A/c Hierarchy TOP A/c Validation
      ********************************************************************
     C     GA_TOP_VAL    BEGSR
 
      * 'A top a/c must have alternate a/cs to post interest.'
 
     C     DACP          IFEQ      *BLANK
     C     CACP          OREQ      *BLANK
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75051'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * A/c ID = a/c to post DR interest
 
     C     DRBR          IFNE      *BLANK
     C                   MOVEL     DRBR          WBRC
     C                   MOVEL     DACP          WCCAA
     C                   ELSE
     C                   MOVEL     DACP          WACNO            10 0
     C                   EXSR      ACS_ACNUM
     C                   ENDIF
 
      * 'A/c to post DR int is not a sub a/c in the same hierarchy.'
 
     C     WACCNTK       CHAIN     RELGAHLJ0                          60
     C     *IN60         IFEQ      '1'
     C     S_CLHIER      ORNE      CLHIER
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75052'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * Check if a/c to post DR int exists below the top a/c
 
     C                   EXSR      CHK_AC_CHN
 
      * 'A/c to post DR int for a member is not present below that member.'
 
     C     AC_In_Chn     IFNE      'Y'
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75053'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
 
      * A/c ID = a/c to post CR interest
 
     C     CRBR          IFNE      *BLANK
     C                   MOVEL     CRBR          WBRC
     C                   MOVEL     CACP          WCCAA
     C                   ELSE
     C                   MOVEL     CACP          WACNO
     C                   EXSR      ACS_ACNUM
     C                   ENDIF
 
      * 'A/c to post CR int is not a sub a/c in the same hierarchy.'
 
     C     WACCNTK       CHAIN     RELGAHLJ0                          60
     C     *IN60         IFEQ      '1'
     C     S_CLHIER      ORNE      CLHIER
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75054'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * Check if a/c to post CR int exists below the top a/c
 
     C                   EXSR      CHK_AC_CHN
 
      * 'A/c to post CR int for a member is not present below that member.'
 
     C     AC_In_Chn     IFNE      'Y'
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75055'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      * ' A top a/c must not have an internal interest income a/c.'
 
     C                   MOVEL     GLIBRC        WBRC
     C                   MOVEL     GLICUS        WCUS
     C                   MOVEL     GLICCY        WCCY
     C                   MOVEL     GLIACD        WACD
     C                   MOVEL     GLIASN        WASN
     C     WACCID        IFNE      BlankAC
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75056'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
      * ' A top a/c must not have an internal interest expense a/c.'
 
     C                   MOVEL     GLEBRC        WBRC
     C                   MOVEL     GLECUS        WCUS
     C                   MOVEL     GLECCY        WCCY
     C                   MOVEL     GLEACD        WACD
     C                   MOVEL     GLEASN        WASN
     C     WACCID        IFNE      BlankAC
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75057'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Group A/c Hierarchy LEVEL A/c Validation
      ********************************************************************
     C     GA_LEV_VAL    BEGSR
 
      * 'A level a/c must have alternate a/cs to post interest.'
 
     C     DACP          IFEQ      *BLANK
     C     CACP          OREQ      *BLANK
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75061'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * A/c ID = a/c to post DR interest
 
     C     DRBR          IFNE      *BLANK
     C                   MOVEL     DRBR          WBRC
     C                   MOVEL     DACP          WCCAA
     C                   ELSE
     C                   MOVEL     DACP          WACNO
     C                   EXSR      ACS_ACNUM
     C                   ENDIF
 
      * 'A/c to post DR int is not a sub a/c in the same hierarchy.'
 
     C     WACCNTK       CHAIN     RELGAHLJ0                          60
     C     *IN60         IFEQ      '1'
     C     S_CLHIER      ORNE      CLHIER
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75062'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * Check if a/c to post DR int exists below the top a/c
 
     C                   EXSR      CHK_AC_CHN
 
      * 'A/c to post DR int for a member is not present below that member.'
 
     C     AC_In_Chn     IFNE      'Y'
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75063'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
 
      * A/c ID = a/c to post CR interest
 
     C     CRBR          IFNE      *BLANK
     C                   MOVEL     CRBR          WBRC
     C                   MOVEL     CACP          WCCAA
     C                   ELSE
     C                   MOVEL     CACP          WACNO
     C                   EXSR      ACS_ACNUM
     C                   ENDIF
 
      * 'A/c to post CR int is not a sub a/c in the same hierarchy.'
 
     C     WACCNTK       CHAIN     RELGAHLJ0                          60
     C     *IN60         IFEQ      '1'
     C     S_CLHIER      ORNE      CLHIER
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75064'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * Check if a/c to post CR int exists below the top a/c
 
     C                   EXSR      CHK_AC_CHN
 
      * 'A/c to post CR int for a member is not present below that member.'
 
     C     AC_In_Chn     IFNE      'Y'
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75065'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      * ' A level a/c must have an internal interest income a/c.'
 
     C                   MOVEL     GLIBRC        WBRC
     C                   MOVEL     GLICUS        WCUS
     C                   MOVEL     GLICCY        WCCY
     C                   MOVEL     GLIACD        WACD
     C                   MOVEL     GLIASN        WASN
     C     WACCID        IFEQ      BlankAC
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75066'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Internal interest income a/c is not a sub a/c in the same hierarchy.'
 
     C     WACCNTK       CHAIN     RELGAHLJ0                          60
     C     *IN60         IFEQ      '1'
     C     S_CLHIER      ORNE      CLHIER
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75067'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Internal interest income a/c for a member must have the same parent as the member'
 
     C                   MOVEL     S_CLPBRC      WBRC
     C                   MOVEL     S_CLPCUS      WCUS
     C                   MOVEL     S_CLPCCY      WCCY
     C                   MOVEL     S_CLPACD      WACD
     C                   MOVEL     S_CLPASN      WASN
     C     WACCID        IFNE      PACCID
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75068'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * ' A level a/c must have an internal interest expense a/c.'
 
     C                   MOVEL     GLEBRC        WBRC
     C                   MOVEL     GLECUS        WCUS
     C                   MOVEL     GLECCY        WCCY
     C                   MOVEL     GLEACD        WACD
     C                   MOVEL     GLEASN        WASN
     C     WACCID        IFEQ      BlankAC
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75069'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Internal interest expense a/c is not a sub a/c in the same hierarchy.'
 
     C     WACCNTK       CHAIN     RELGAHLJ0                          60
     C     *IN60         IFEQ      '1'
     C     S_CLHIER      ORNE      CLHIER
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75070'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Internal interest expense a/c for a member must have the same parent as the member'
 
     C                   MOVEL     S_CLPBRC      WBRC
     C                   MOVEL     S_CLPCUS      WCUS
     C                   MOVEL     S_CLPCCY      WCCY
     C                   MOVEL     S_CLPACD      WACD
     C                   MOVEL     S_CLPASN      WASN
     C     WACCID        IFNE      PACCID
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75071'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Group A/c Hierarchy SUB A/c Validation
      ********************************************************************
     C     GA_SUB_VAL    BEGSR
 
      * A/c ID = a/c to post DR interest
 
     C     DACP          IFNE      *BLANK
     C     DRBR          IFNE      *BLANK
     C                   MOVEL     DRBR          WBRC
     C                   MOVEL     DACP          WCCAA
     C                   ELSE
     C                   MOVEL     DACP          WACNO
     C                   EXSR      ACS_ACNUM
     C                   ENDIF
 
      * 'A/c to post DR int is not a sub a/c in the same hierarchy.'
 
     C     WACCNTK       CHAIN     RELGAHLJ0                          60
     C     *IN60         IFEQ      '1'
     C     S_CLHIER      ORNE      CLHIER
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75081'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'A/c to post DR int for a member must have the same parent as the member'
 
     C                   MOVEL     S_CLPBRC      WBRC
     C                   MOVEL     S_CLPCUS      WCUS
     C                   MOVEL     S_CLPCCY      WCCY
     C                   MOVEL     S_CLPACD      WACD
     C                   MOVEL     S_CLPASN      WASN
     C     WACCID        IFNE      PACCID
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75082'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * A/c ID = a/c to post CR interest
 
     C     CACP          IFNE      *BLANK
     C     CRBR          IFNE      *BLANK
     C                   MOVEL     CRBR          WBRC
     C                   MOVEL     CACP          WCCAA
     C                   ELSE
     C                   MOVEL     CACP          WACNO
     C                   EXSR      ACS_ACNUM
     C                   ENDIF
 
      * 'A/c to post CR int is not a sub a/c in the same hierarchy.'
 
     C     WACCNTK       CHAIN     RELGAHLJ0                          60
     C     *IN60         IFEQ      '1'
     C     S_CLHIER      ORNE      CLHIER
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75083'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'A/c to post CR int for a member must have the same parent as the member'
 
     C                   MOVEL     S_CLPBRC      WBRC
     C                   MOVEL     S_CLPCUS      WCUS
     C                   MOVEL     S_CLPCCY      WCCY
     C                   MOVEL     S_CLPACD      WACD
     C                   MOVEL     S_CLPASN      WASN
     C     WACCID        IFNE      PACCID
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75084'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * 'A sub a/c must have an internal interest income a/c.'
 
     C                   MOVEL     GLIBRC        WBRC
     C                   MOVEL     GLICUS        WCUS
     C                   MOVEL     GLICCY        WCCY
     C                   MOVEL     GLIACD        WACD
     C                   MOVEL     GLIASN        WASN
     C     WACCID        IFEQ      BlankAC
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75085'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Internal interest income a/c is not a sub a/c in the same hierarchy.'
 
     C     WACCNTK       CHAIN     RELGAHLJ0                          60
     C     *IN60         IFEQ      '1'
     C     S_CLHIER      ORNE      CLHIER
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75086'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Internal interest income a/c for a member must have the same parent as the member'
 
     C                   MOVEL     S_CLPBRC      WBRC
     C                   MOVEL     S_CLPCUS      WCUS
     C                   MOVEL     S_CLPCCY      WCCY
     C                   MOVEL     S_CLPACD      WACD
     C                   MOVEL     S_CLPASN      WASN
     C     WACCID        IFNE      PACCID
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75087'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * ' A sub a/c must have an internal interest expense a/c.'
 
     C                   MOVEL     GLEBRC        WBRC
     C                   MOVEL     GLECUS        WCUS
     C                   MOVEL     GLECCY        WCCY
     C                   MOVEL     GLEACD        WACD
     C                   MOVEL     GLEASN        WASN
     C     WACCID        IFEQ      BlankAC
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75088'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Internal interest expense a/c is not a sub a/c in the same hierarchy.'
 
     C     WACCNTK       CHAIN     RELGAHLJ0                          60
     C     *IN60         IFEQ      '1'
     C     S_CLHIER      ORNE      CLHIER
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75089'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Internal interest expense a/c for a member must have the same parent as the member'
 
     C                   MOVEL     S_CLPBRC      WBRC
     C                   MOVEL     S_CLPCUS      WCUS
     C                   MOVEL     S_CLPCCY      WCCY
     C                   MOVEL     S_CLPACD      WACD
     C                   MOVEL     S_CLPASN      WASN
     C     WACCID        IFNE      PACCID
     C                   ADD       1             Ix
     C                   MOVEL     'RELATION '   FldNameArr(Ix)
     C                   MOVEL     'RE75090'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Check if a/c exists below another a/c in a chain
      ********************************************************************
     C     CHK_AC_CHN    BEGSR
 
      * Construct a CM Hierarchy Chain
      * starting from the sub a/c
 
     C                   MOVEL     S_CLHIER      I_HIER
     C                   MOVEL     'GA'          I_HTYP
     C                   MOVEL     S_CLPBRC      I_PBRC
     C                   MOVEL     S_CLPCUS      I_PCUS
     C                   MOVEL     S_CLPCCY      I_PCCY
     C                   MOVEL     S_CLPACD      I_PACD
     C                   MOVEL     S_CLPASN      I_PASN
     C                   EXSR      CON_HCHN
 
      * Lookup child a/c in the sub a/c chain
 
     C                   EXSR      LOOKUP_AC
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Construct a CM Hierarchy Chain
      ********************************************************************
     C     CON_HCHN      BEGSR
 
     C                   CALLB     'RE100604'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
 
      * INPUTS
      * Hierarchy ID
     C                   PARM                    I_HIER            9 0
      * Hierarchy Type
     C                   PARM                    I_HTYP            2
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM                    I_PBRC            3
     C**********         PARM                    I_PCUS            6 0                        CSD027
     C                   PARM                    I_PCUS            6                          CSD027
     C                   PARM                    I_PCCY            3
     C**********         PARM                    I_PACD            4 0                        CGL029
     C                   PARM                    I_PACD                                       CGL029
     C                   PARM                    I_PASN            2 0
 
      * OUTPUTS
      * CHAINS FOR:
      * GL Account ID
      * Retail A/c No.
      * A/c Status
      * Profit Centre
      * A/c Section
      * Overdraft
      * Balance Available for I/C Overdraft
      * I/C Threshold Balance
     C                   PARM                    O_GLAI
     C                   PARM                    O_RAN
     C                   PARM                    O_AST
     C                   PARM                    O_PC
     C                   PARM                    O_ASC
     C                   PARM                    O_ODFT
     C                   PARM                    O_BAIC
     C                   PARM                    O_ICTB
      * Count in chain
     C                   PARM                    O_CNTCH           2 0
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'CONSTRUCT A CM CHAIN FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Lookup A/c In Chain
      ********************************************************************
     C     LOOKUP_AC     BEGSR
 
     C                   Z-ADD     1             X                 2 0
     C     CACCID        LOOKUP    O_GLAI(X)                              99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     'Y'           AC_In_Chn         1
     C                   ELSE
     C                   MOVEL     'N'           AC_In_Chn
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * Access REIAC
      ********************************************************************
     C     ACS_REIAC     BEGSR
 
     C     CACCNTK       CHAIN     REIAC                              60        *
     C     *IN60         IFEQ      '1'
     C                   EVAL      X_ERMS = 'REIACD missing ' +
     C                                      'for a/c ' + CACCID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * Access ACNUM
      ********************************************************************
     C     ACS_ACNUM     BEGSR
 
     C     WACNO         CHAIN     ACNUM                              60        *
     C     *IN60         IFEQ      '1'
     C                   MOVEL     *BLANK        WBRC
     C                   MOVEL     *BLANK        WCCAA
     C                   ELSE
     C                   MOVEL     AC_BRCA       WBRC
     C                   MOVEL     AC_CNUM       WCUS
     C                   MOVEL     AC_CCY        WCCY
     C                   MOVEL     AC_ACOD       WACD
     C                   MOVEL     AC_ACSQ       WASN
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * Report Errors
      ********************************************************************
     C     REP_ERRORS    BEGSR
 
     C                   Z-ADD     1             IIx               3 0
     C     IIx           DOUGT     Ix
 
     C                   MOVEL     MsgIdArr(IIx) @MSGID            7
     C                   MOVEL     MsgDtaArr(IIx)@MSGDT           45
     C                   EXSR      ZAMSGRTVMS
     C                   EVAL      R_ERMS = CompMsg
     C                   ADD       1             IIx
 
      * Output to report
 
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     ERROR
 
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * End of Report
      ********************************************************************
     C     END_OF_REP    BEGSR
 
      * Output count of errors and 'end of report'
 
     C                   Z-ADD     3             CHLINE
     C                   EXSR      PAG
     C                   WRITE     ENDOFREP
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Throw page headings (if required)
      ********************************************************************
     C     PAG           BEGSR
 
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   WRITE     PAGEHEAD
     C     6             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Retrieve a message
      ********************************************************************
     C     ZAMSGRTVMS    BEGSR
     C                   CALLB     'ZAMSGRTVMS'
     C                   PARM      *BLANK        ReturnCode       10
     C                   PARM      *BLANK        CompMsg        3000
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
     C                   PARM      'REUSRMSG  '  #MsgFile         10
     C                   PARM      '*LIBL  '     #MsgFLib         10
     C                   PARM      '0'           Level             1
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Register AU printer file with RCF
      ********************************************************************
     C     RCFAU         BEGSR
 
     C                   EVAL      ZSnum = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSErr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Mode
     C                   PARM                    I_MODE            1
      * Hierarchy
      * Hierarchy Type
     C                   PARM                    I_Hierarchy       9 0
     C                   PARM                    I_HierType        2
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
      * If NOT interactive mode
      *   Open printer file
      *   Register AU printer file with RCF
 
     C     I_MODE        IFNE      'I'
     C                   OPEN      RE100404AU
     C                   EXSR      RCFAU
     C                   ENDIF
 
      * Blank A/c
     C**********         Z-ADD     *ZERO         WCUS                                         CSD027
     C                   EVAL      WCUS = *BLANKS                                             CSD027
     C                   Z-ADD     *ZERO         WACD
     C                   Z-ADD     *ZERO         WASN
     C**********         MOVEL     WACCID        BlankAC          18                          CGL029
     C                   MOVEL     WACCID        BlankAC                                      CGL029
 
      * key lists
 
     C     CACCNTK       KLIST
     C                   KFLD                    CCUS
     C                   KFLD                    CCCY
     C                   KFLD                    CACD
     C                   KFLD                    CASN
     C                   KFLD                    CBRC
     C     WACCNTK       KLIST
     C                   KFLD                    WCUS
     C                   KFLD                    WCCY
     C                   KFLD                    WACD
     C                   KFLD                    WASN
     C                   KFLD                    WBRC
     C     LINKK         KLIST
     C                   KFLD                    CLHIER
     C                   KFLD                    CLLINK
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
     OREACCHD1  E            U_REACCH
     O                       HISTAT
