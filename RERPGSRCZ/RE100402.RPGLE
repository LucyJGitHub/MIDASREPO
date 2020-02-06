     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Hierarchy Mbr Validation')    *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100402 - Cash Management Hierarchy Member Validation       *
      *                                                               *
      *  Function:  This program validates the 'front end' cash       *
      *             management hierarchy member records.              *
      *             The validation is as follows:                     *
      *             i. Records exist on REZSMXPD and REGAMXPD when    *
      *                required.                                      *
      *             ii. Certain fields on the hierarchy members must  *
      *                 be valid.                                     *
      *             As it does the validation, it creates 'live'      *
      *             hierarchy links (the back office representation   *
      *             of the front end hierarchy members).              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 14May13               *
      *                 AR676213           Date 19Nov10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 216106             Date 07Apr03               *
      *                 215579             Date 17Mar03               *
      *                 214360             Date 03Feb03               *
      *                 214552             Date 03Feb03               *
      *                 212463             Date 10Jan03               *
      *                 CRE008  *CREATE    Date 06Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216106 - Top a/c sweep freq must be 'D' for deferred posting *
      *  215579 - Hierarchy validation error                          *
      *  214360 - Cash Management Deferred Posting                    *
      *  214552 - Input cycle sweeping frequency                      *
      *  212463 - Missing validation of hierarchies                   *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
      * F R O N T  E N D  F I L E S
      * ---------------------------
 
      * Account Hierarchy Member
     FREACCML0  IF   E           K DISK    INFSR(*PSSR)
     FREACCML1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REACCMD0:REACCMD1)
 
      * Zero Balancing/Sweeping Member Extension
     FREZSMXPD  UF   E           K DISK    INFSR(*PSSR)
     FREZSMXL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSMXD0:REZSMXP0)
     FREZSMXL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSMXD0:REZSMXA0)
 
      * Group Account Member Extension
     FREGAMXPD  IF   E           K DISK    INFSR(*PSSR)
     FREGAMXL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REGAMXD0:REGAMXP0)
     FREGAMXL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REGAMXD0:REGAMXA0)
 
      * Zero Balancing/Sweeping Header Extension
     FREZSHXL0  IF   E           K DISK    INFSR(*PSSR)
      * Group Account Header Extension
     FREGAHXL0  IF   E           K DISK    INFSR(*PSSR)
 
      * Account Hierarchy Header
     FREACCHPD  IF   E           K DISK    INFSR(*PSSR)
 
 
      * ' L I V E '  B A C K  E N D  F I L E S
      * --------------------------------------
 
      * Live Cash Management Hierarchy Links
     FRELCMHLPD O  A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHLD0:O_LCMHLD0)
      * Live Zero Balancing/Sweeping Hierarchy Links
     FRELZSHLPD O  A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSHLD0:O_LZSHLD0)
      * Live Group Account Hierarchy Links
     FRELGAHLPD O  A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REGAHLD0:O_LGAHLD0)
 
      ** Variable Definitions                                                                 CGL029
     D I_CACCID        S             24                                                       CGL029
     D I_PACCID        S             24                                                       CGL029
     D I_SACCID        S             24                                                       CGL029
     D I_IIACID        S             24                                                       CGL029
     D I_IEACID        S             24                                                       CGL029
     D I_TACCID        S             24                                                       CGL029
     D I_IACCID        S             24                                                       CGL029
     D I_EACCID        S             24                                                       CGL029
     D DDCACC          S             28                                                       CGL029
     D DDPACC          S             28                                                       CGL029
     D DDSACC          S             28                                                       CGL029
     D DDINAC          S             28                                                       CGL029
     D DDIXAC          S             28                                                       CGL029
     D DDTACC          S             28                                                       CGL029
     D DDIACC          S             28                                                       CGL029
     D DDEACC          S             28                                                       CGL029
 
      * Cash Management Hierarchy Links
     D O_CMHL        E DS                  EXTNAME(RECMHLPD)
     D***C_ACCID                19     36                                                     CGL029
     D***P_ACCID                38     55                                                     CGL029
     D C_ACCID                19     42                                                       CGL029
     D P_ACCID                44     67                                                       CGL029
      * Zero Balancing/Sweeping Hierarchy Links
     D O_ZSHL        E DS                  EXTNAME(REZSHLPD)
     D***S_ACCID               108    125                                                     CGL029
     D***S_IIACID              246    263                                                     CGL029
     D***S_IEACID              264    281                                                     CGL029
     D S_ACCID1Temp          108    119                                                       CGL029
     D S_ACCID2Temp          282    291                                                       CGL029
     D S_ACCID3Temp          124    125                                                       CGL029
     D S_IIACID1Temp         246    257                                                       CGL029
     D S_IIACID2Temp         292    301                                                       CGL029
     D S_IIACID3Temp         262    263                                                       CGL029
     D S_IEACID1Temp         264    275                                                       CGL029
     D S_IEACID2Temp         302    311                                                       CGL029
     D S_IEACID3Temp         280    281                                                       CGL029
                                                                                              CGL029
      ** Shadow Account                                                                       CGL029
     D                 DS                                                                     CGL029
     D S_ACCID                 1     24                                                       CGL029
     D S_ACCID1                1     12                                                       CGL029
     D S_ACCID2               13     22                                                       CGL029
     D S_ACCID3               23     24                                                       CGL029
                                                                                              CGL029
      ** Income Account                                                                       CGL029
     D                 DS                                                                     CGL029
     D S_IIACID                1     24                                                       CGL029
     D S_IIACID1               1     12                                                       CGL029
     D S_IIACID2              13     22                                                       CGL029
     D S_IIACID3              23     24                                                       CGL029
                                                                                              CGL029
      ** Expense Account                                                                      CGL029
     D                 DS                                                                     CGL029
     D S_IEACID                1     24                                                       CGL029
     D S_IEACID1               1     12                                                       CGL029
     D S_IEACID2              13     22                                                       CGL029
     D S_IEACID3              23     24                                                       CGL029
                                                                                              CGL029
      * Group Account Hierarchy Links
     D O_GAHL        E DS                  EXTNAME(REGAHLPD)
     D***T_ACCID                28     45                                                     CGL029
     D***I_ACCID                46     63                                                     CGL029
     D***E_ACCID                64     81                                                     CGL029
     D T_ACCID                28     51                                                       CGL029
     D I_ACCID                52     75                                                       CGL029
     D E_ACCID                76     99                                                       CGL029
 
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      * Associated Hierarchies
     D AsocHier        S              9  0 DIM(100)
     D AsocHtyp        S              2    DIM(100)
 
 
      * Account ID
     D                 DS
     D*ACCID****               1     18                                                       CGL029
     D ACCID                   1     24                                                       CGL029
     D BRC                     1      3
     D*CUS******               4      9S 0                                                    CSD027
     D CUS                     4      9                                                       CSD027
     D CCY                    10     12
     D*ACD******              13     16S 0                                                    CGL029
     D*ASN******              17     18S 0                                                    CGL029
     D ACD                    13     22S 0                                                    CGL029
     D ASN                    23     24S 0                                                    CGL029
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for GENERAL LEDGER details
                                                                                              CGL029
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs                                                         CGL029
                                                                                              CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      ** Second DS for access programs
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
     IREACCMD0
     I              MEID                        CLLINK
     I              MEHIID                      CLHIER
     IREZSMXD0
     I              ZMMEID                      ZLLINK
      **
     I              ZMCBRC                      CLCBRC
     I              ZMCCUS                      CLCCUS
     I              ZMCCCY                      CLCCCY
     I              ZMCACD                      CLCACD
     I              ZMCASN                      CLCASN
     I              ZMCCAT                      CLCCAT
      **
     I              ZMLNAR                      ZLLNAR
     I              ZMSTYP                      ZLSTYP
     I              ZMSFRQ                      ZLSFRQ
     I              ZMSDAY                      ZLSDAY
     I              ZMLSDT                      ZLLSDT
     I              ZMNSDT                      ZLNSDT
     I              ZMSCPI                      ZLSCPI
     I              ZMSCBD                      ZLSCBD
     I              ZMZBNG                      ZLZBNG
     I              ZMTGBL                      ZLTGBL
     I              ZMRVSW                      ZLRVSW
     I              ZMSBRC                      ZLSBRC
     I              ZMSCUS                      ZLSCUS
     I              ZMSCCY                      ZLSCCY
     I              ZMSACD                      ZLSACD
     I              ZMSASN                      ZLSASN
     I              ZMMINB                      ZLMINB
     I              ZMMINL                      ZLMINL
     I              ZMMAXB                      ZLMAXB
     I              ZMMAXL                      ZLMAXL
     I              ZMMDVD                      ZLMDVD
     I              ZMMDCD                      ZLMDCD
     I              ZMFLFT                      ZLFLFT
     I              ZMFLFS                      ZLFLFS
     I              ZMIBRC                      ZLIBRC                                        TETXXX
     I              ZMICUS                      ZLICUS                                        TETXXX
     I              ZMICCY                      ZLICCY                                        TETXXX
     I              ZMIACD                      ZLIACD                                        TETXXX
     I              ZMIASN                      ZLIASN                                        TETXXX
     I              ZMEBRC                      ZLEBRC                                        TETXXX
     I              ZMECUS                      ZLECUS                                        TETXXX
     I              ZMECCY                      ZLECCY                                        TETXXX
     I              ZMEACD                      ZLEACD                                        TETXXX
     I              ZMEASN                      ZLEASN                                        TETXXX
     IREGAMXD0
     I              GMEID                       GLLINK
      **
     I              GMCBRC                      CLCBRC
     I              GMCCUS                      CLCCUS
     I              GMCCCY                      CLCCCY
     I              GMCACD                      CLCACD
     I              GMCASN                      CLCASN
     I              GMCCAT                      CLCCAT
      **
     I              GMBAIC                      GLBAIC
     I              GMICTB                      GLICTB
     I              GMTBRC                      GLTBRC
     I              GMTCUS                      GLTCUS
     I              GMTCCY                      GLTCCY
     I              GMTACD                      GLTACD
     I              GMTASN                      GLTASN
     I              GMIBRC                      GLIBRC
     I              GMICUS                      GLICUS
     I              GMICCY                      GLICCY
     I              GMIACD                      GLIACD
     I              GMIASN                      GLIASN
     I              GMEBRC                      GLEBRC
     I              GMECUS                      GLECUS
     I              GMECCY                      GLECCY
     I              GMEACD                      GLEACD
     I              GMEASN                      GLEASN
 
     IREZSMXP0
     I              ZMCBRC                      CLPBRC
     I              ZMCCUS                      CLPCUS
     I              ZMCCCY                      CLPCCY
     I              ZMCACD                      CLPACD
     I              ZMCASN                      CLPASN
      **
     I              ZMLNAR                      ZLLNAR
     IREGAMXP0
     I              GMCBRC                      CLPBRC
     I              GMCCUS                      CLPCUS
     I              GMCCCY                      CLPCCY
     I              GMCACD                      CLPACD
     I              GMCASN                      CLPASN
      /SPACE 5
 
      * Clear outputs
 
     C     I_RUN         IFEQ      'P'
     C                   Z-ADD     *ZERO         AsocHier
     C                   MOVEL     *BLANK        AsocHtyp
     C                   ENDIF
 
     C                   Z-ADD     0             CntTopAcs         3 0
     C                   Z-ADD     0             CntNonTopAcs      3 0          212463
 
      * Access hierarchy header
 
     C     I_HTYP        IFEQ      'ZS'
     C     I_HIER        CHAIN     REZSHXD0                           60
     C                   ELSE
     C     I_HIER        CHAIN     REGAHXD0                           60
     C                   ENDIF
 
 
      * Read all members for the input hierarchy
 
     C     I_HIER        SETLL     REACCMD0
     C     I_HIER        READE     REACCMD0                               60
 
     C     *IN60         DOWEQ     *OFF
 
      * If a zero-balancing/sweeping hierarchy
      * ---------------------------------------
 
     C     I_HTYP        IFEQ      'ZS'
 
      * Pick up Zero Balancing/Sweeping Member Extension
      * If no record is found, it's an error
      * 'No REZSMXPD record exists.
 
     C     CLLINK        CHAIN     REZSMXD0                           60
     C     *IN60         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'MEMBER   '   FldNameArr(Ix)
     C                   MOVEL     'RE75010'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   RETURN
     C                   ENDIF
 
     C                   MOVEL     ZLLNAR        ZLCNAR
 
      * Pick up PARENT Zero Balancing/Sweeping Member Extension
      * If no record is found, it's an error
 
     C     MEPID         IFEQ      *ZERO
     C                   MOVEL     'T'           CLCCAT
     C                   MOVEL     *BLANK        CLPBRC
     C**********         Z-ADD     *ZERO         CLPCUS                                       CSD027
     C                   EVAL      CLPCUS = *BLANKS                                           CSD027
     C                   MOVEL     *BLANK        CLPCCY
     C                   Z-ADD     *ZERO         CLPACD
     C                   Z-ADD     *ZERO         CLPASN
 
     C                   MOVEL     *BLANK        ZLPNAR
 
     C                   ADD       1             CntTopAcs
 
     C                   ELSE
     C     MEPID         CHAIN     REZSMXP0                           60
 
      * 'No REZSMXPD record exists.
 
     C     *IN60         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'MEMBER   '   FldNameArr(Ix)
     C                   MOVEL     'RE75011'     MsgIDArr(Ix)
     C**********         MOVEL     MEPID         MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     MEPID         MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   RETURN
     C                   ENDIF
                                                                                212463
     C                   ADD       1             CntNonTopAcs                   212463
 
     C                   MOVEL     ZLLNAR        ZLPNAR
     C                   ENDIF
 
      * Convert Cash Management Member
      * Validate Cash Management Member
 
     C                   EXSR      CNV_CMMEMBER
     C                   EXSR      VAL_CMMEMBER
 
      * Convert  Zero Balancing/Sweeping Member
      * Validate Zero Balancing/Sweeping Member
 
     C                   EXSR      CNV_ZSMEMBER
     C                   EXSR      VAL_ZSMEMBER
      * Update signed fields
     C                   Z-ADD     O_TGBL        ZLTGBL
     C                   Z-ADD     O_MINB        ZLMINB
     C                   Z-ADD     O_MINL        ZLMINL
     C                   Z-ADD     O_MAXB        ZLMAXB
     C                   Z-ADD     O_MAXL        ZLMAXL
 
      * Write a record to the 'Live' REZSHLPD
 
     C                   Z-ADD     I_HIER        ZLHIER
     C                   Z-ADD     0             ZLTVDR
     C                   Z-ADD     0             ZLTCDR
     C                   Z-ADD     0             ZLNASN
 
     C                   WRITE     O_LZSHLD0
 
      * If mode is not interactive and there are no errors
      *   Update last/next sweep date on REZSMXPD
      *   (following sweep date determined by REZSWPSCH)
 
     C     I_MODE        IFNE      'I'
     C     Ix            ANDEQ     0
     C     ZLNSDT        ANDLT     BJDNWD
     C                   Z-ADD     ZLNSDT        ZLLSDT
     C                   Z-ADD     O_FSDT        ZLNSDT
     C                   EXCEPT    U_REZSMX
     C                   ENDIF
 
     C                   ENDIF
 
      * If a group account hierarchy
      * ----------------------------
 
     C     I_HTYP        IFEQ      'GA'
 
      * Pick up Group Account Hierarchy Member Extension
      * If no record is found, it's an error
      * 'No REGAMXPD record exists.
 
     C     CLLINK        CHAIN     REGAMXD0                           60
     C     *IN60         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'MEMBER   '   FldNameArr(Ix)
     C                   MOVEL     'RE75012'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   RETURN
     C                   ENDIF
 
      * Pick up PARENT Group Account Hierarchy Member Extension
      * If no record is found, it's an error
 
     C     MEPID         IFEQ      *ZERO
     C                   MOVEL     'T'           CLCCAT
     C                   MOVEL     *BLANK        CLPBRC
     C**********         Z-ADD     *ZERO         CLPCUS                                       CSD027
     C                   EVAL      CLPCUS = *BLANKS                                           CSD027
     C                   MOVEL     *BLANK        CLPCCY
     C                   Z-ADD     *ZERO         CLPACD
     C                   Z-ADD     *ZERO         CLPASN
 
     C                   ADD       1             CntTopAcs
 
     C                   ELSE
     C     MEPID         CHAIN     REGAMXP0                           60
 
      * 'No REGAMXPD record exists.
 
     C     *IN60         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'MEMBER   '   FldNameArr(Ix)
     C                   MOVEL     'RE75013'     MsgIDArr(Ix)
     C**********         MOVEL     MEPID         MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     MEPID         MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   RETURN
     C                   ENDIF
                                                                                212463
     C                   ADD       1             CntNonTopAcs                   212463
                                                                                212463
     C                   ENDIF
 
      * Convert Cash Management Member
      * Validate Cash Management Member
 
     C                   EXSR      CNV_CMMEMBER
     C                   EXSR      VAL_CMMEMBER
 
      * Convert Group A/c Member
      * Validate Group A/c Member
 
     C                   EXSR      CNV_GAMEMBER
     C                   EXSR      VAL_GAMEMBER
      * Update signed fields
     C                   Z-ADD     O_ICTB        GLICTB
 
      * Write a record to the 'Live' REGAHLPD
 
     C                   Z-ADD     I_HIER        GLHIER
     C                   WRITE     O_LGAHLD0
 
     C                   ENDIF
 
      * Write a record to the 'Live' RECMHLPD
 
     C                   Z-ADD     0             CLNASN
 
     C                   WRITE     O_LCMHLD0
 
      * Check for child a/c occurences
 
     C                   EXSR      CHK_CHILDOCUR
 
      *  Read next Link
 
     C     I_HIER        READE     REACCMD0                               60
 
     C                   ENDDO
 
      * It's an error if there is not just 1 top a/c
      * 'Incorrect number of top a/cs for hierarchy.
 
     C     CntTopAcs     IFNE      1
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'MEMBER   '   FldNameArr(Ix)
     C                   MOVEL     'RE75014'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE                                                   212463
                                                                                212463
      * 'For local sweeping hierachies, a/cs must be defined below the top a/c' 212463
                                                                                212463
     C     I_HTYP        IFEQ      'ZS'                                         212463
     C     ZHEXTL        ANDNE     'Y'                                          212463
     C     CntNonTopAcs  ANDEQ     0                                            212463
     C                   EXSR      CHK_4RETURN                                  212463
     C                   ADD       1             Ix                             212463
     C                   MOVEL     'MEMBER   '   FldNameArr(Ix)                 212463
     C                   MOVEL     'RE75015'     MsgIDArr(Ix)                   212463
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                       212463 MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF                                                  212463
                                                                                212463
      * 'For group a/c hierachies, a/cs must be defined below the top a/c'      212463
                                                                                212463
     C     I_HTYP        IFEQ      'GA'                                         212463
     C     CntNonTopAcs  ANDEQ     0                                            212463
     C                   EXSR      CHK_4RETURN                                  212463
     C                   ADD       1             Ix                             212463
     C                   MOVEL     'MEMBER   '   FldNameArr(Ix)                 212463
     C                   MOVEL     'RE75016'     MsgIDArr(Ix)                   212463
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                       212463 MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF                                                  212463
                                                                                212463
      * 'A master a/c hierarchy can only consist of a top a/c'                  212463
                                                                                212463
     C     I_HTYP        IFEQ      'ZS'                                         212463
     C     ZHMAST        ANDEQ     'Y'                                          212463
     C     CntNonTopAcs  ANDGT     0                                            212463
     C                   EXSR      CHK_4RETURN                                  212463
     C                   ADD       1             Ix                             212463
     C                   MOVEL     'MEMBER   '   FldNameArr(Ix)                 212463
     C                   MOVEL     'RE75017'     MsgIDArr(Ix)                   212463
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                       212463 MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF                                                  212463
     C                   ENDIF
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Convert Cash Management Member
      ********************************************************************
     C     CNV_CMMEMBER  BEGSR
 
     C                   CALLB     'RE100314'
 
      * Return code
      * Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
      * INPUTS
      * Child a/c
      * Parent a/c
     C**********         PARM      C_ACCID       I_CACCID         18                          CGL029
     C**********         PARM      P_ACCID       I_PACCID         18                          CGL029
     C                   PARM      C_ACCID       I_CACCID                                     CGL029
     C                   PARM      P_ACCID       I_PACCID                                     CGL029
 
      * OUTPUTS
      * Child a/c
      * Parent a/c
     C**********         PARM                    DDCACC           22                          CGL029
     C**********         PARM                    DDPACC           22                          CGL029
     C                   PARM                    DDCACC                                       CGL029
     C                   PARM                    DDPACC                                       CGL029
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN CASH MANAGEMENT MEMBER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Cash Management Member
      ********************************************************************
     C     VAL_CMMEMBER  BEGSR
 
     C                   CALLB     'RE100304'
 
      * Return code
      * Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
      * Link ID
      * Hierarchy Currency
     C                   PARM      CLLINK        I_LINK            9 0
     C                   PARM                    I_HCCY            3
      * Child a/c
      * Parent a/c
     C**********         PARM      C_ACCID       I_CACCID         18                          CGL029
     C**********         PARM      P_ACCID       I_PACCID         18                          CGL029
     C                   PARM      C_ACCID       I_CACCID                                     CGL029
     C                   PARM      P_ACCID       I_PACCID                                     CGL029
 
      * BANK details
     C                   PARM                    SDBANK
 
      * OUTPUTS
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN CASH MANAGEMENT MEMBER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************                     CGL029
      /SPACE 5                                                                                CGL029
      ********************************************************************                    CGL029
      *                                                                  *                    CGL029
      * SrAccounts -  Set-up Account IDs                                 *                    CGL029
      *                                                                  *                    CGL029
      ********************************************************************                    CGL029
     C     SrAccounts    BEGSR                                                                CGL029
                                                                                              CGL029
      ** Shadow Acoount                                                                       CGL029
     C                   EVAL      S_ACCID1 = S_ACCID1Temp                                    CGL029
     C                   EVAL      S_ACCID2 = S_ACCID2Temp                                    CGL029
     C                   EVAL      S_ACCID3 = S_ACCID3Temp                                    CGL029
                                                                                              CGL029
      ** Income Acoount                                                                       CGL029
     C                   EVAL      S_IIACID1 = S_IIACID1Temp                                  CGL029
     C                   EVAL      S_IIACID2 = S_IIACID2Temp                                  CGL029
     C                   EVAL      S_IIACID3 = S_IIACID3Temp                                  CGL029
                                                                                              CGL029
      ** Expense Account                                                                      CGL029
     C                   EVAL      S_IEACID1 = S_IEACID1Temp                                  CGL029
     C                   EVAL      S_IEACID2 = S_IEACID2Temp                                  CGL029
     C                   EVAL      S_IEACID3 = S_IEACID3Temp                                  CGL029
                                                                                              CGL029
     C                   ENDSR                                                                CGL029
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Zero Balancing/Sweeping Member
      ********************************************************************
     C     CNV_ZSMEMBER  BEGSR
 
     C                   EXSR      SrAccounts                                                 CGL029
                                                                                              CGL029
     C                   CALLB     'RE100315'
 
      * Return code
      * Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
      * INPUTS
      * Child Currency
     C                   PARM      CLCCCY        I_CCCY            3
      * Edit code
     C                   PARM      *BLANK        I_ECODE           1
      * Date format
     C                   PARM      'N'           I_DATFMT          1
      * Sweep Type
     C                   PARM      ZLSTYP        I_STYP            1
      * Sweeping Frequency
      * Sweeping Day
      * Last Sweep Date
      * Next Sweep Date
     C                   PARM      ZLSFRQ        I_SFRQ            1
     C                   PARM      ZLSDAY        I_SDAY            2 0
     C                   PARM      ZLLSDT        I_LSDT            5 0
     C                   PARM      ZLNSDT        I_NSDT            5 0
      * Sweep Capitalized Interest
      * Sweep Cleared Balance on Association Date
      * Zero Balance - Net or Gross
     C                   PARM      ZLSCPI        I_SCPI            1
     C                   PARM      ZLSCBD        I_SCBD            1
     C                   PARM      ZLZBNG        I_ZBNG            1
      * Target Balance
     C                   PARM      ZLTGBL        I_TGBL           15 0
      * Reverse Sweep
     C                   PARM      ZLRVSW        I_RVSW            1
      * Shadow a/c
     C**********         PARM      S_ACCID       I_SACCID         18                          CGL029
     C                   PARM      S_ACCID       I_SACCID                                     CGL029
      * Internal Interest Income Account                                                      TETXXX
     C**********         PARM      S_IIACID      I_IIACID         18                   TETXXX CGL029
     C                   PARM      S_IIACID      I_IIACID                                     CGL029
      * Internal Interest Expense Account                                                     TETXXX
     C**********         PARM      S_IEACID      I_IEACID         18                   TETXXX CGL029
     C                   PARM      S_IEACID      I_IEACID                                     CGL029
      * Minimum Balance
      * Minimum Level
      * Maximum Balance
      * Maximum Level
     C                   PARM      ZLMINB        I_MINB           15 0
     C                   PARM      ZLMINL        I_MINL           15 0
     C                   PARM      ZLMAXB        I_MAXB           15 0
     C                   PARM      ZLMAXL        I_MAXL           15 0
      * Maximum Debit Value in a Day
      * Maximum Debit Count in a Day
     C                   PARM      ZLMDVD        I_MDVD           15 0
     C                   PARM      ZLMDCD        I_MDCD            3 0
      * Floor Limit for Top
      * Floor Limit for Sweep
     C                   PARM      ZLFLFT        I_FLFT           15 0
     C                   PARM      ZLFLFS        I_FLFS           15 0
 
      * BANK details
     C                   PARM                    SDBANK
 
      * OUTPUTS
      * Sweep Type
     C                   PARM                    DDSTYP           12
      * Sweeping Frequency
      * Sweeping Day
      * Last Sweep Date
      * Next Sweep Date
     C                   PARM                    DDSFRQ           30
     C                   PARM                    DDSDAY            2
     C                   PARM                    DDLSDT            7
     C                   PARM                    DDNSDT            7
      * Sweep Capitalized Interest
      * Sweep Cleared Balance on Association Date
      * Zero Balance - Net or Gross
     C                   PARM                    DDSCPI            3
     C                   PARM                    DDSCBD            3
     C                   PARM                    DDZBNG            5
      * Target Balance
     C                   PARM                    DDTGBL           22
      * Reverse Sweep
     C                   PARM                    DDRVSW            3
      * Shadow a/c
     C**********         PARM                    DDSACC           22                          CGL029
     C                   PARM                    DDSACC                                       CGL029
      * Internal Interest Income Account                                                      TETXXX
     C**********         PARM                    DDINAC           22                   TETXXX CGL029
     C                   PARM                    DDINAC                                       CGL029
      * Internal Interest Expense Account                                                     TETXXX
     C**********         PARM                    DDIXAC           22                   TETXXX CGL029
     C                   PARM                    DDIXAC                                       CGL029
      * Minimum Balance
      * Minimum Level
      * Maximum Balance
      * Maximum Level
     C                   PARM                    DDMINB           22
     C                   PARM                    DDMINL           22
     C                   PARM                    DDMAXB           22
     C                   PARM                    DDMAXL           22
      * Maximum Debit Value in a Day
      * Maximum Debit Count in a Day
     C                   PARM                    DDMDVD           22
     C                   PARM                    DDMDCD            5
      * Floor Limit for Top
      * Floor Limit for Sweep
     C                   PARM                    DDFLFT           22
     C                   PARM                    DDFLFS           22
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN ZERO BAL/SWEEPING MEMBER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Zero Balancing/Sweeping Member
      ********************************************************************
     C     VAL_ZSMEMBER  BEGSR
 
     C                   EXSR      SrAccounts                                                 CGL029
                                                                                              CGL029
     C                   CALLB     'RE100305'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Link ID
      * Child Currency
      * Child A/c Category
      * Deferred Posting                                                        216106
     C                   PARM      CLLINK        I_LINK            9 0
     C                   PARM      CLCCCY        I_CCCY            3
     C                   PARM      CLCCAT        I_CCAT            1
     C                   PARM      ZHDEFP        I_DEFP            1            216106
      * Child Narrative
     C                   PARM      ZLCNAR        I_SCNAR          30
      * Sweep Type
     C                   PARM      ZLSTYP        I_SSTYP           1
      * Sweeping Frequency - COB
      * Sweeping Day - COB
      * Next Sweep Date - COB
     C                   PARM      ZLSFRQ        I_SSFRQ           1
     C                   PARM      DDSDAY        I_SSDAY           2
     C                   PARM      DDNSDT        I_SNSDT           6
 
      * External                                                                214552
      * Master Account                                                          214552
     C                   PARM      ZHEXTL        I_SEXTL           1            214552
     C                   PARM      ZHMAST        I_SMAST           1            214552
      * Sweeping Holiday Convention - COB
     C                   PARM      ZHSHOC        I_SSHOC           1
      * Sweep Capitalized Interest
     C                   PARM      ZLSCPI        I_SSCPI           1
      * Sweep Cleared Balance on Association Date
      * Zero Balance - Net or Gross
     C                   PARM      ZLSCBD        I_SSCBD           1
     C                   PARM      ZLZBNG        I_SZBNG           1
      * Target Balance
     C                   PARM      DDTGBL        I_STGBL          22
      * Reverse Sweep
     C                   PARM      ZLRVSW        I_SRVSW           1
 
      * Shadow a/c
     C**********         PARM      S_ACCID       I_SACCID         18                          CGL029
     C                   PARM      S_ACCID       I_SACCID                                     CGL029
      * Internal Interest Income Account                                                      TETXXX
     C**********         PARM      S_IIACID      I_IIACID         18                   TETXXX CGL029
     C                   PARM      S_IIACID      I_IIACID                                     CGL029
      * Internal Interest Expense Account                                                     TETXXX
     C**********         PARM      S_IEACID      I_IEACID         18                   TETXXX CGL029
     C                   PARM      S_IEACID      I_IEACID                                     CGL029
 
      * Minimum Balance
      * Minimum Level
      * Maximum Balance
      * Maximum Level
     C                   PARM      DDMINB        I_SMINB          22
     C                   PARM      DDMINL        I_SMINL          22
     C                   PARM      DDMAXB        I_SMAXB          22
     C                   PARM      DDMAXL        I_SMAXL          22
 
      * Maximum Debit Value in a Day
      * Maximum Debit Count in a Day
     C                   PARM      DDMDVD        I_SMDVD          22
     C                   PARM      DDMDCD        I_SMDCD           5
 
      * Floor Limit for Top
      * Floor Limit for Sweep
     C                   PARM      DDFLFT        I_SFLFT          22
     C                   PARM      DDFLFS        I_SFLFS          22
 
      * BANK details
      * GENERAL LEDGER details
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
 
      * OUTPUTS
      * Following Sweep Date
     C                   PARM                    O_FSDT            5 0
      * Target Balance
      * Minimum Balance
      * Minimum Level
      * Maximum Balance
      * Maximum Level
     C                   PARM                    O_TGBL           15 0
     C                   PARM                    O_MINB           15 0
     C                   PARM                    O_MINL           15 0
     C                   PARM                    O_MAXB           15 0
     C                   PARM                    O_MAXL           15 0
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN ZERO BAL/SWEEPING MEMBER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Group A/c Member
      ********************************************************************
     C     CNV_GAMEMBER  BEGSR
 
     C                   CALLB     'RE100316'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Child Currency
     C                   PARM      CLCCCY        I_CCCY            3
      * Edit code
     C                   PARM      *BLANK        I_ECODE           1
 
      * Balance Available for Inter Company Overdraft
      * Inter Company Threshold Balance
     C                   PARM      GLBAIC        I_BAIC            1
     C                   PARM      GLICTB        I_ICTB           15 0
      * Transaction A/c
      * (Interest) Income A/c
      * (Interest) Expense A/c
     C**********         PARM      T_ACCID       I_TACCID         18                          CGL029
     C**********         PARM      I_ACCID       I_IACCID         18                          CGL029
     C**********         PARM      E_ACCID       I_EACCID         18                          CGL029
     C                   PARM      T_ACCID       I_TACCID                                     CGL029
     C                   PARM      I_ACCID       I_IACCID                                     CGL029
     C                   PARM      E_ACCID       I_EACCID                                     CGL029
 
      * OUTPUTS
 
      * Balance Available for Inter Company Overdraft
      * Inter Company Threshold Balance
     C                   PARM                    DDBAIC            3
     C                   PARM                    DDICTB           22
      * Transaction A/c
      * (Interest) Income A/c
      * (Interest) Expense A/c
     C**********         PARM                    DDTACC           22                          CGL029
     C**********         PARM                    DDIACC           22                          CGL029
     C**********         PARM                    DDEACC           22                          CGL029
     C                   PARM                    DDTACC                                       CGL029
     C                   PARM                    DDIACC                                       CGL029
     C                   PARM                    DDEACC                                       CGL029
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN GROUP A/C MEMBER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Group A/c Member
      ********************************************************************
     C     VAL_GAMEMBER  BEGSR
 
     C                   CALLB     'RE100306'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Link ID
      * Child Branch
      * Child Currency
     C                   PARM      CLLINK        I_LINK            9 0
     C                   PARM      CLCBRC        I_CBRC            3
     C                   PARM      CLCCCY        I_CCCY            3
 
      * Balance Available for Inter Company Overdraft
      * Inter Company Threshold Balance
     C                   PARM      GLBAIC        I_SBAIC           1
     C                   PARM      DDICTB        I_SICTB          22
 
      * Transaction A/c
      * (Interest) Income A/c
      * (Interest) Expense A/c
     C**********         PARM      T_ACCID       I_TACCID         18                          CGL029
     C**********         PARM      I_ACCID       I_IACCID         18                          CGL029
     C**********         PARM      E_ACCID       I_EACCID         18                          CGL029
     C                   PARM      T_ACCID       I_TACCID                                     CGL029
     C                   PARM      I_ACCID       I_IACCID                                     CGL029
     C                   PARM      E_ACCID       I_EACCID                                     CGL029
 
      * BANK details
     C                   PARM                    SDBANK
 
      * OUTPUTS
      * Inter Company Threshold Balance
     C                   PARM                    O_ICTB           15 0
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN GROUP A/C MEMBER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Check for child a/c occurences
      ********************************************************************
     C     CHK_CHILDOCUR BEGSR
 
      * Child a/c
 
     C                   MOVEL     C_ACCID       ACCID
 
      * ZERO BALANCING/SWEEPING HIERARCHY VALIDATION
      * --------------------------------------------
 
     C                   Z-ADD     0             ZSCnt             3 0
 
      * Look for a/c in zero balancing/sweeping hierarchies
 
     C     ACCNTK        SETLL     REZSMXA0
     C     ACCNTK        READE     REZSMXA0                               60
     C     *IN60         DOWEQ     '0'
     C     ZMMEID        CHAIN     REACCMD1                           60
 
      * 'No REACCMPD record exists.
 
     C     *IN60         IFEQ      '1'
     C                   ELSE
     C     MEHIID        IFEQ      I_HIER
     C                   ADD       1             ZSCnt
     C                   ELSE
     C     I_RUN         IFEQ      'P'
     C                   Z-ADD     1             Ah                3 0
     C     MEHIID        LOOKUP    AsocHier(Ah)                           99
     C     *IN99         IFEQ      '0'
     C     *ZERO         LOOKUP    AsocHier(Ah)                           99
     C                   MOVEL     MEHIID        AsocHier(Ah)
     C                   MOVEL     'ZS'          AsocHtyp(Ah)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     ACCNTK        READE     REZSMXA0                               60
     C                   ENDDO
 
      * Multiple a/cs in the same hierarchy is an error
      * 'Account appears more than once in this hierarchy'
 
     C     ZSCnt         IFGT      1
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'MEMBER   '   FldNameArr(Ix)
     C                   MOVEL     'RE75022'     MsgIDArr(Ix)
     C**********         MOVEL     ZMMEID        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     ZMMEID        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
      * GROUP A/C HIERARCHY VALIDATION
      * ------------------------------
 
     C                   Z-ADD     0             GACnt             3 0
 
      * Look for a/c in group a/c hierarchies
 
     C     ACCNTK        SETLL     REGAMXA0
     C     ACCNTK        READE     REGAMXA0                               60
     C     *IN60         DOWEQ     '0'
     C     GMEID         CHAIN     REACCMD1                           60
 
      * 'No REACCMPD record exists.
 
     C     *IN60         IFEQ      '1'
     C                   ELSE
     C     MEHIID        IFEQ      I_HIER
     C                   ADD       1             GACnt
     C                   ELSE
     C                   ADD       1             GACnt
     C     MEHIID        CHAIN     REACCHD0                           99
     C                   MOVEL     HIHISN        OtherHier        10
     C     I_RUN         IFEQ      'P'
     C                   Z-ADD     1             Ah
     C     MEHIID        LOOKUP    AsocHier(Ah)                           99
     C     *IN99         IFEQ      '0'
     C     *ZERO         LOOKUP    AsocHier(Ah)                           99
     C                   MOVEL     MEHIID        AsocHier(Ah)
     C                   MOVEL     'GA'          AsocHtyp(Ah)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     ACCNTK        READE     REGAMXA0                               60
     C                   ENDDO
 
      * Multiple a/cs across hierarchies is an error
      * 'Account appears in more than one group a/c hierarchy.
 
     C     I_HTYP        IFEQ      'GA'
     C     GACnt         ANDGT     1
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'MEMBER   '   FldNameArr(Ix)
     C                   MOVEL     'RE75024'     MsgIDArr(Ix)
     C**********         MOVEL     GMEID         MsgDtaArr(Ix)                              MD000091
     C**********         CAT       '.':0         MsgDtaArr(Ix)                              MD000091
     C**********         CAT       OtherHier:0   MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     GMEID         MsgDtaTmp                                  MD000091
     C                   CAT       '.':0         MsgDtaTmp                                  MD000091
     C                   CAT       OtherHier:0   MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C/COPY WNCPYSRC,RE100402C1
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Check for Return
      ********************************************************************
     C     CHK_4RETURN   BEGSR
     C     Ix            IFEQ      ArrayMax
     C                   RETURN
     C                   ENDIF
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
                                                                                215579
      * Return code                                                             215579
      * Error Message                                                           215579
     C                   PARM                    X_RTCD                         215579
     C                   PARM                    X_ERMS                         215579
      * INPUTS                                                                  215579
      * Mode
      * Run
     C                   PARM                    I_MODE            1
     C                   PARM                    I_RUN             1
      * Hierarchy
      * Hierarchy Type
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_HTYP            2
      * Hierarchy Currency
     C                   PARM                    I_HCCY            3
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
      * Associated Hierarchies
 
     C                   PARM                    AsocHier
     C                   PARM                    AsocHtyp
 
      * Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *  Access General Ledger Details
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR  '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      * key lists
 
     C     ACCNTK        KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
     OREZSMXD0  E            U_REZSMX
     O                       ZLLSDT
     O                       ZLNSDT
